/*
===============================================================================
Internship Placement and Matching System
Analytical SQL Library
===============================================================================

Purpose
-------

This file contains analytical SQL queries supporting the KPI framework of the
Internship Placement and Matching System.

The queries cover:

- Student participation and profile readiness
- Academic eligibility
- Eligibility failure reasons
- Opportunity supply and capacity
- Application activity
- Mandatory requirement evaluation
- Matching quality
- Recommendation outcomes
- Students with no recommendation
- Placement offers
- Final placements
- Employer performance
- Internship outcomes
- Recommendation effectiveness
- Manual overrides
- Intervention cases
- Data quality
- Fairness and access review
- Capacity reconciliation
- Duplicate placement detection
- Governance controls
- Executive scorecards

SQL Dialect
-----------

The examples use PostgreSQL-compatible syntax.

The queries are analytical design examples rather than a production-ready
physical implementation.

Table and column names follow the conceptual data model defined in:

    07-data-model.md

Example parameters use the following notation:

    :placement_cycle_id
    :as_of_timestamp
    :minimum_group_size
    :recommendation_review_sla_hours

Status values are assumed to use lowercase API-compatible values such as:

    eligible
    active
    confirmed
    completed
    approved
    rejected

Production implementations should confirm the exact physical schema, status
values, indexes, time zone and data-retention rules.

Important Measurement Limitations
---------------------------------

1. A dedicated target-student population table is not currently defined.

   Queries that require a target population use active students with current
   academic records as an illustrative population.

2. The current preference entity does not contain an explicit ordinal ranking
   field.

   Therefore, an exact first-preference placement KPI cannot be calculated
   until a field such as preference_rank is introduced.

3. Submission-attempt failures are not represented as a dedicated entity.

   Application validation failure rates require an application-attempt or
   validation-event table in a production implementation.

4. Fairness queries support investigation.

   Statistical differences must not be interpreted automatically as proof of
   discrimination or unfair treatment.

===============================================================================
*/


/*
===============================================================================
QUERY 01
Student Participation and Profile Readiness
===============================================================================

Business questions:

- How many active students are in the current analytical population?
- How many have created a placement profile?
- How many profiles are complete?
- What is the average profile-completeness rate?
*/

WITH current_academic_records AS (
    SELECT
        sar.student_id,
        sar.academic_program_id,
        sar.academic_year,
        sar.gpa,
        sar.completed_credits,
        sar.data_quality_status,
        ROW_NUMBER() OVER (
            PARTITION BY sar.student_id
            ORDER BY sar.valid_from DESC, sar.source_updated_at DESC
        ) AS record_rank
    FROM student_academic_record sar
    WHERE sar.valid_from <= COALESCE(
        :as_of_timestamp,
        CURRENT_TIMESTAMP
    )
      AND (
          sar.valid_to IS NULL
          OR sar.valid_to > COALESCE(
              :as_of_timestamp,
              CURRENT_TIMESTAMP
          )
      )
),
active_student_population AS (
    SELECT DISTINCT
        s.student_id
    FROM student s
    INNER JOIN current_academic_records car
        ON car.student_id = s.student_id
       AND car.record_rank = 1
    WHERE s.student_status = 'active'
),
current_profiles AS (
    SELECT
        sp.student_id,
        sp.profile_status,
        sp.profile_completeness_rate,
        ROW_NUMBER() OVER (
            PARTITION BY sp.student_id
            ORDER BY sp.profile_version DESC, sp.updated_at DESC
        ) AS profile_rank
    FROM student_profile sp
    WHERE sp.effective_from <= COALESCE(
        :as_of_timestamp,
        CURRENT_TIMESTAMP
    )
      AND (
          sp.effective_to IS NULL
          OR sp.effective_to > COALESCE(
              :as_of_timestamp,
              CURRENT_TIMESTAMP
          )
      )
)
SELECT
    COUNT(DISTINCT asp.student_id) AS active_student_population,
    COUNT(DISTINCT cp.student_id) AS students_with_profile,
    COUNT(
        DISTINCT CASE
            WHEN cp.profile_status = 'complete'
            THEN cp.student_id
        END
    ) AS students_with_complete_profile,
    ROUND(
        100.0
        * COUNT(DISTINCT cp.student_id)
        / NULLIF(COUNT(DISTINCT asp.student_id), 0),
        2
    ) AS profile_activation_rate_pct,
    ROUND(
        100.0
        * COUNT(
            DISTINCT CASE
                WHEN cp.profile_status = 'complete'
                THEN cp.student_id
            END
        )
        / NULLIF(COUNT(DISTINCT cp.student_id), 0),
        2
    ) AS profile_completion_rate_pct,
    ROUND(
        AVG(cp.profile_completeness_rate),
        2
    ) AS average_profile_completeness_pct
FROM active_student_population asp
LEFT JOIN current_profiles cp
    ON cp.student_id = asp.student_id
   AND cp.profile_rank = 1;


/*
===============================================================================
QUERY 02
Latest Academic Eligibility Distribution
===============================================================================

Business questions:

- How many students are eligible?
- How many are ineligible?
- How many require review?
- How many have incomplete eligibility data?
*/

WITH latest_eligibility AS (
    SELECT
        aee.student_id,
        aee.placement_cycle_id,
        aee.eligibility_status,
        aee.data_quality_status,
        aee.failed_rule_count,
        aee.evaluated_at,
        ROW_NUMBER() OVER (
            PARTITION BY
                aee.student_id,
                aee.placement_cycle_id
            ORDER BY
                aee.evaluated_at DESC,
                aee.eligibility_evaluation_id DESC
        ) AS evaluation_rank
    FROM academic_eligibility_evaluation aee
    WHERE aee.placement_cycle_id = :placement_cycle_id
)
SELECT
    eligibility_status,
    COUNT(DISTINCT student_id) AS student_count,
    ROUND(
        100.0
        * COUNT(DISTINCT student_id)
        / NULLIF(
            SUM(COUNT(DISTINCT student_id)) OVER (),
            0
        ),
        2
    ) AS eligibility_share_pct,
    ROUND(
        AVG(failed_rule_count),
        2
    ) AS average_failed_rule_count
FROM latest_eligibility
WHERE evaluation_rank = 1
GROUP BY eligibility_status
ORDER BY student_count DESC;


/*
===============================================================================
QUERY 03
Top Academic Eligibility Failure Reasons
===============================================================================

Business question:

Which academic rules most frequently prevent students from becoming eligible?
*/

WITH latest_eligibility AS (
    SELECT
        aee.eligibility_evaluation_id,
        aee.student_id,
        aee.placement_cycle_id,
        ROW_NUMBER() OVER (
            PARTITION BY
                aee.student_id,
                aee.placement_cycle_id
            ORDER BY
                aee.evaluated_at DESC,
                aee.eligibility_evaluation_id DESC
        ) AS evaluation_rank
    FROM academic_eligibility_evaluation aee
    WHERE aee.placement_cycle_id = :placement_cycle_id
)
SELECT
    err.rule_id,
    err.rule_version,
    err.explanation,
    COUNT(DISTINCT le.student_id) AS affected_student_count,
    ROUND(
        100.0
        * COUNT(DISTINCT le.student_id)
        / NULLIF(
            COUNT(DISTINCT le.student_id) OVER (),
            0
        ),
        2
    ) AS affected_student_share_pct
FROM latest_eligibility le
INNER JOIN eligibility_rule_result err
    ON err.eligibility_evaluation_id =
       le.eligibility_evaluation_id
WHERE le.evaluation_rank = 1
  AND err.result_status = 'failed'
GROUP BY
    err.rule_id,
    err.rule_version,
    err.explanation
ORDER BY
    affected_student_count DESC,
    err.rule_id;


/*
===============================================================================
QUERY 04
Academic Exception Outcomes
===============================================================================

Business questions:

- How many academic exception requests were submitted?
- What percentage were approved?
- Which rules receive the most exception requests?
*/

SELECT
    aer.rule_id,
    COUNT(*) AS exception_request_count,
    COUNT(*) FILTER (
        WHERE aer.request_status = 'approved'
    ) AS approved_count,
    COUNT(*) FILTER (
        WHERE aer.request_status = 'rejected'
    ) AS rejected_count,
    COUNT(*) FILTER (
        WHERE aer.request_status IN (
            'pending',
            'information_required'
        )
    ) AS pending_count,
    ROUND(
        100.0
        * COUNT(*) FILTER (
            WHERE aer.request_status = 'approved'
        )
        / NULLIF(
            COUNT(*) FILTER (
                WHERE aer.request_status IN (
                    'approved',
                    'rejected'
                )
            ),
            0
        ),
        2
    ) AS approval_rate_pct,
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    aer.decided_at - aer.requested_at
                )
            ) / 3600.0
        ) FILTER (
            WHERE aer.decided_at IS NOT NULL
        ),
        2
    ) AS average_decision_time_hours
FROM academic_exception_request aer
INNER JOIN academic_eligibility_evaluation aee
    ON aee.eligibility_evaluation_id =
       aer.eligibility_evaluation_id
WHERE aee.placement_cycle_id = :placement_cycle_id
GROUP BY aer.rule_id
ORDER BY exception_request_count DESC;


/*
===============================================================================
QUERY 05
Opportunity Supply and Capacity Summary
===============================================================================

Business questions:

- How many active internship opportunities exist?
- What is total approved capacity?
- How many positions are confirmed or reserved?
- How much capacity remains available?
*/

WITH confirmed_capacity AS (
    SELECT
        p.opportunity_id,
        COUNT(*) AS confirmed_placement_count
    FROM placement p
    WHERE p.placement_cycle_id = :placement_cycle_id
      AND p.placement_status IN (
          'confirmed',
          'active',
          'completed'
      )
    GROUP BY p.opportunity_id
),
reserved_capacity AS (
    SELECT
        cr.opportunity_id,
        COUNT(*) AS active_reservation_count
    FROM capacity_reservation cr
    WHERE cr.reservation_status = 'active'
      AND cr.expires_at >
          COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
    GROUP BY cr.opportunity_id
),
opportunity_capacity AS (
    SELECT
        io.opportunity_id,
        io.employer_id,
        io.opportunity_title,
        io.industry,
        io.city,
        io.working_model,
        io.total_capacity,
        COALESCE(
            cc.confirmed_placement_count,
            0
        ) AS confirmed_placements,
        COALESCE(
            rc.active_reservation_count,
            0
        ) AS active_reservations,
        io.total_capacity
        - COALESCE(cc.confirmed_placement_count, 0)
        - COALESCE(rc.active_reservation_count, 0)
            AS calculated_available_capacity
    FROM internship_opportunity io
    LEFT JOIN confirmed_capacity cc
        ON cc.opportunity_id = io.opportunity_id
    LEFT JOIN reserved_capacity rc
        ON rc.opportunity_id = io.opportunity_id
    WHERE io.placement_cycle_id = :placement_cycle_id
      AND io.opportunity_status = 'active'
)
SELECT
    COUNT(DISTINCT opportunity_id) AS active_opportunity_count,
    COUNT(DISTINCT employer_id) AS participating_employer_count,
    SUM(total_capacity) AS total_approved_capacity,
    SUM(confirmed_placements) AS confirmed_placement_count,
    SUM(active_reservations) AS active_reservation_count,
    SUM(calculated_available_capacity) AS available_capacity,
    ROUND(
        100.0
        * SUM(confirmed_placements)
        / NULLIF(SUM(total_capacity), 0),
        2
    ) AS capacity_utilization_rate_pct,
    ROUND(
        100.0
        * SUM(calculated_available_capacity)
        / NULLIF(SUM(total_capacity), 0),
        2
    ) AS available_capacity_rate_pct
FROM opportunity_capacity;


/*
===============================================================================
QUERY 06
Capacity by Opportunity
===============================================================================

Business question:

Which opportunities are full, underutilized or at risk of over-allocation?
*/

WITH confirmed_capacity AS (
    SELECT
        p.opportunity_id,
        COUNT(*) AS confirmed_placement_count
    FROM placement p
    WHERE p.placement_cycle_id = :placement_cycle_id
      AND p.placement_status IN (
          'confirmed',
          'active',
          'completed'
      )
    GROUP BY p.opportunity_id
),
reserved_capacity AS (
    SELECT
        cr.opportunity_id,
        COUNT(*) AS active_reservation_count
    FROM capacity_reservation cr
    WHERE cr.reservation_status = 'active'
      AND cr.expires_at >
          COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
    GROUP BY cr.opportunity_id
)
SELECT
    io.opportunity_id,
    io.opportunity_title,
    e.employer_name,
    io.total_capacity,
    COALESCE(
        cc.confirmed_placement_count,
        0
    ) AS confirmed_placements,
    COALESCE(
        rc.active_reservation_count,
        0
    ) AS active_reservations,
    io.total_capacity
    - COALESCE(cc.confirmed_placement_count, 0)
    - COALESCE(rc.active_reservation_count, 0)
        AS available_capacity,
    ROUND(
        100.0
        * COALESCE(cc.confirmed_placement_count, 0)
        / NULLIF(io.total_capacity, 0),
        2
    ) AS confirmed_capacity_utilization_pct,
    CASE
        WHEN
            io.total_capacity
            - COALESCE(cc.confirmed_placement_count, 0)
            - COALESCE(rc.active_reservation_count, 0) < 0
        THEN 'capacity_conflict'
        WHEN
            io.total_capacity
            - COALESCE(cc.confirmed_placement_count, 0)
            - COALESCE(rc.active_reservation_count, 0) = 0
        THEN 'full_or_fully_reserved'
        WHEN
            100.0
            * COALESCE(cc.confirmed_placement_count, 0)
            / NULLIF(io.total_capacity, 0) < 40
        THEN 'low_utilization'
        ELSE 'available'
    END AS capacity_classification
FROM internship_opportunity io
INNER JOIN employer e
    ON e.employer_id = io.employer_id
LEFT JOIN confirmed_capacity cc
    ON cc.opportunity_id = io.opportunity_id
LEFT JOIN reserved_capacity rc
    ON rc.opportunity_id = io.opportunity_id
WHERE io.placement_cycle_id = :placement_cycle_id
  AND io.opportunity_status IN (
      'active',
      'closed'
  )
ORDER BY
    available_capacity ASC,
    confirmed_capacity_utilization_pct DESC;


/*
===============================================================================
QUERY 07
Opportunity-to-Eligible-Student Ratio
===============================================================================

Business question:

Is total internship capacity sufficient for the eligible student population?

Important:

A ratio above 1 does not prove that suitable capacity exists for every student.
Department, role, location, skill and preference compatibility still matter.
*/

WITH latest_eligibility AS (
    SELECT
        aee.student_id,
        aee.placement_cycle_id,
        aee.eligibility_status,
        ROW_NUMBER() OVER (
            PARTITION BY
                aee.student_id,
                aee.placement_cycle_id
            ORDER BY aee.evaluated_at DESC
        ) AS evaluation_rank
    FROM academic_eligibility_evaluation aee
    WHERE aee.placement_cycle_id = :placement_cycle_id
),
eligible_students AS (
    SELECT
        COUNT(DISTINCT student_id) AS eligible_student_count
    FROM latest_eligibility
    WHERE evaluation_rank = 1
      AND eligibility_status = 'eligible'
),
active_capacity AS (
    SELECT
        COALESCE(SUM(io.total_capacity), 0)
            AS total_active_capacity
    FROM internship_opportunity io
    INNER JOIN employer e
        ON e.employer_id = io.employer_id
    WHERE io.placement_cycle_id = :placement_cycle_id
      AND io.opportunity_status = 'active'
      AND e.employer_status = 'active'
)
SELECT
    es.eligible_student_count,
    ac.total_active_capacity,
    ROUND(
        ac.total_active_capacity::NUMERIC
        / NULLIF(es.eligible_student_count, 0),
        2
    ) AS opportunity_to_eligible_student_ratio,
    CASE
        WHEN
            ac.total_active_capacity::NUMERIC
            / NULLIF(es.eligible_student_count, 0) >= 1.00
        THEN 'potentially_sufficient_total_capacity'
        WHEN
            ac.total_active_capacity::NUMERIC
            / NULLIF(es.eligible_student_count, 0) >= 0.75
        THEN 'moderate_capacity_risk'
        WHEN
            ac.total_active_capacity::NUMERIC
            / NULLIF(es.eligible_student_count, 0) >= 0.50
        THEN 'high_capacity_risk'
        ELSE 'critical_capacity_shortage'
    END AS capacity_risk_classification
FROM eligible_students es
CROSS JOIN active_capacity ac;


/*
===============================================================================
QUERY 08
Application Funnel
===============================================================================

Business questions:

- How many students submitted applications?
- How many applications reached eligibility, employer review and offer stages?
- Where are applications leaving the process?
*/

SELECT
    a.application_status,
    COUNT(*) AS application_count,
    COUNT(DISTINCT a.student_id) AS distinct_student_count,
    COUNT(DISTINCT a.opportunity_id) AS distinct_opportunity_count,
    ROUND(
        100.0
        * COUNT(*)
        / NULLIF(SUM(COUNT(*)) OVER (), 0),
        2
    ) AS application_share_pct
FROM application a
INNER JOIN internship_opportunity io
    ON io.opportunity_id = a.opportunity_id
WHERE io.placement_cycle_id = :placement_cycle_id
GROUP BY a.application_status
ORDER BY application_count DESC;


/*
===============================================================================
QUERY 09
Applications per Student Distribution
===============================================================================

Business question:

How many applications does each participating student submit?
*/

WITH application_counts AS (
    SELECT
        a.student_id,
        COUNT(*) FILTER (
            WHERE a.application_status NOT IN (
                'draft',
                'closed'
            )
        ) AS submitted_application_count
    FROM application a
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = a.opportunity_id
    WHERE io.placement_cycle_id = :placement_cycle_id
    GROUP BY a.student_id
)
SELECT
    CASE
        WHEN submitted_application_count = 0
            THEN '0 applications'
        WHEN submitted_application_count = 1
            THEN '1 application'
        WHEN submitted_application_count BETWEEN 2 AND 3
            THEN '2-3 applications'
        ELSE '4 or more applications'
    END AS application_band,
    COUNT(*) AS student_count,
    ROUND(
        100.0
        * COUNT(*)
        / NULLIF(SUM(COUNT(*)) OVER (), 0),
        2
    ) AS student_share_pct
FROM application_counts
GROUP BY application_band
ORDER BY
    MIN(submitted_application_count);


/*
===============================================================================
QUERY 10
Mandatory Requirement Pass Rate
===============================================================================

Business question:

What percentage of evaluated applications pass every mandatory opportunity
requirement?
*/

WITH mandatory_requirements AS (
    SELECT
        oppr.opportunity_id,
        oppr.opportunity_requirement_id
    FROM opportunity_requirement oppr
    WHERE oppr.importance = 'mandatory'
      AND oppr.effective_from <=
          COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
      AND (
          oppr.effective_to IS NULL
          OR oppr.effective_to >
             COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
      )
),
application_mandatory_results AS (
    SELECT
        a.application_id,
        a.student_id,
        a.opportunity_id,
        COUNT(mr.opportunity_requirement_id)
            AS mandatory_requirement_count,
        COUNT(mr.opportunity_requirement_id) FILTER (
            WHERE re.evaluation_status = 'passed'
        ) AS passed_requirement_count,
        COUNT(mr.opportunity_requirement_id) FILTER (
            WHERE re.evaluation_status = 'failed'
        ) AS failed_requirement_count,
        COUNT(mr.opportunity_requirement_id) FILTER (
            WHERE re.evaluation_status IN (
                'evidence_missing',
                'review_required'
            )
            OR re.requirement_evaluation_id IS NULL
        ) AS incomplete_requirement_count
    FROM application a
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = a.opportunity_id
    INNER JOIN mandatory_requirements mr
        ON mr.opportunity_id = a.opportunity_id
    LEFT JOIN requirement_evaluation re
        ON re.application_id = a.application_id
       AND re.opportunity_requirement_id =
           mr.opportunity_requirement_id
    WHERE io.placement_cycle_id = :placement_cycle_id
    GROUP BY
        a.application_id,
        a.student_id,
        a.opportunity_id
)
SELECT
    COUNT(*) AS evaluated_application_count,
    COUNT(*) FILTER (
        WHERE mandatory_requirement_count > 0
          AND passed_requirement_count =
              mandatory_requirement_count
    ) AS applications_passing_all_mandatory_requirements,
    COUNT(*) FILTER (
        WHERE failed_requirement_count > 0
    ) AS applications_with_mandatory_failure,
    COUNT(*) FILTER (
        WHERE incomplete_requirement_count > 0
    ) AS applications_with_incomplete_requirement_evidence,
    ROUND(
        100.0
        * COUNT(*) FILTER (
            WHERE mandatory_requirement_count > 0
              AND passed_requirement_count =
                  mandatory_requirement_count
        )
        / NULLIF(COUNT(*), 0),
        2
    ) AS mandatory_requirement_pass_rate_pct
FROM application_mandatory_results;


/*
===============================================================================
QUERY 11
Most Common Mandatory Requirement Failures
===============================================================================

Business question:

Which employer requirements exclude the greatest number of applications?
*/

SELECT
    oppr.requirement_category,
    oppr.requirement_name,
    oppr.required_value,
    COUNT(DISTINCT re.application_id)
        AS failed_application_count,
    COUNT(DISTINCT a.student_id)
        AS affected_student_count,
    COUNT(DISTINCT oppr.opportunity_id)
        AS affected_opportunity_count
FROM requirement_evaluation re
INNER JOIN opportunity_requirement oppr
    ON oppr.opportunity_requirement_id =
       re.opportunity_requirement_id
INNER JOIN application a
    ON a.application_id = re.application_id
INNER JOIN internship_opportunity io
    ON io.opportunity_id = a.opportunity_id
WHERE io.placement_cycle_id = :placement_cycle_id
  AND oppr.importance = 'mandatory'
  AND re.evaluation_status = 'failed'
GROUP BY
    oppr.requirement_category,
    oppr.requirement_name,
    oppr.required_value
ORDER BY
    failed_application_count DESC,
    affected_student_count DESC;


/*
===============================================================================
QUERY 12
Matching Score and Confidence Distribution
===============================================================================

Business questions:

- What is the average compatibility score?
- How are evaluations distributed across compatibility bands?
- How many evaluations have low confidence?
*/

SELECT
    me.model_version,
    CASE
        WHEN me.overall_compatibility_score >= 85
            THEN 'very_strong'
        WHEN me.overall_compatibility_score >= 70
            THEN 'strong'
        WHEN me.overall_compatibility_score >= 55
            THEN 'moderate'
        WHEN me.overall_compatibility_score >= 40
            THEN 'limited'
        ELSE 'weak'
    END AS compatibility_band,
    CASE
        WHEN me.confidence_level >= 90
            THEN 'high'
        WHEN me.confidence_level >= 75
            THEN 'good'
        WHEN me.confidence_level >= 60
            THEN 'moderate'
        ELSE 'low'
    END AS confidence_band,
    COUNT(*) AS evaluation_count,
    COUNT(DISTINCT a.student_id) AS student_count,
    ROUND(
        AVG(me.overall_compatibility_score),
        2
    ) AS average_compatibility_score,
    ROUND(
        AVG(me.confidence_level),
        2
    ) AS average_confidence_level
FROM match_evaluation me
INNER JOIN application a
    ON a.application_id = me.application_id
INNER JOIN internship_opportunity io
    ON io.opportunity_id = a.opportunity_id
WHERE io.placement_cycle_id = :placement_cycle_id
  AND me.match_status IN (
      'eligible',
      'evaluated'
  )
GROUP BY
    me.model_version,
    compatibility_band,
    confidence_band
ORDER BY
    me.model_version,
    MIN(me.overall_compatibility_score) DESC;


/*
===============================================================================
QUERY 13
Average Match Indicator Scores
===============================================================================

Business question:

Which compatibility dimensions are strongest or weakest across recommendations?
*/

SELECT
    me.model_version,
    mi.indicator_name,
    COUNT(*) AS indicator_record_count,
    ROUND(
        AVG(mi.indicator_value),
        2
    ) AS average_indicator_score,
    ROUND(
        AVG(mi.indicator_weight),
        4
    ) AS average_indicator_weight,
    ROUND(
        AVG(mi.weighted_value),
        2
    ) AS average_weighted_contribution,
    COUNT(*) FILTER (
        WHERE mi.indicator_status = 'missing'
    ) AS missing_indicator_count,
    COUNT(*) FILTER (
        WHERE mi.indicator_status = 'review_required'
    ) AS review_required_count
FROM match_indicator mi
INNER JOIN match_evaluation me
    ON me.match_evaluation_id =
       mi.match_evaluation_id
INNER JOIN application a
    ON a.application_id = me.application_id
INNER JOIN internship_opportunity io
    ON io.opportunity_id = a.opportunity_id
WHERE io.placement_cycle_id = :placement_cycle_id
GROUP BY
    me.model_version,
    mi.indicator_name
ORDER BY
    average_indicator_score DESC;


/*
===============================================================================
QUERY 14
Recommendation Status and Approval Rate
===============================================================================

Business questions:

- How many recommendations were generated?
- What percentage were approved?
- What percentage were rejected, held or expired?
*/

WITH recommendation_decisions AS (
    SELECT
        pr.recommendation_id,
        pr.recommendation_status,
        pr.overall_score,
        pr.confidence_level,
        pr.model_version,
        pd.decision_status,
        pd.decided_at,
        ROW_NUMBER() OVER (
            PARTITION BY pr.recommendation_id
            ORDER BY
                pd.decision_version DESC,
                pd.decided_at DESC
        ) AS decision_rank
    FROM placement_recommendation pr
    INNER JOIN application a
        ON a.application_id = pr.application_id
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = a.opportunity_id
    LEFT JOIN placement_decision pd
        ON pd.recommendation_id =
           pr.recommendation_id
    WHERE io.placement_cycle_id = :placement_cycle_id
)
SELECT
    model_version,
    COUNT(DISTINCT recommendation_id)
        AS recommendation_count,
    COUNT(DISTINCT recommendation_id) FILTER (
        WHERE decision_status = 'approved'
          AND decision_rank = 1
    ) AS approved_recommendation_count,
    COUNT(DISTINCT recommendation_id) FILTER (
        WHERE decision_status = 'rejected'
          AND decision_rank = 1
    ) AS rejected_recommendation_count,
    COUNT(DISTINCT recommendation_id) FILTER (
        WHERE decision_status = 'information_required'
          AND decision_rank = 1
    ) AS information_required_count,
    COUNT(DISTINCT recommendation_id) FILTER (
        WHERE decision_status = 'on_hold'
          AND decision_rank = 1
    ) AS on_hold_count,
    ROUND(
        100.0
        * COUNT(DISTINCT recommendation_id) FILTER (
            WHERE decision_status = 'approved'
              AND decision_rank = 1
        )
        / NULLIF(
            COUNT(DISTINCT recommendation_id) FILTER (
                WHERE decision_status IN (
                    'approved',
                    'rejected'
                )
                  AND decision_rank = 1
            ),
            0
        ),
        2
    ) AS recommendation_approval_rate_pct
FROM recommendation_decisions
GROUP BY model_version
ORDER BY model_version;


/*
===============================================================================
QUERY 15
Students With No Active Recommendation
===============================================================================

Business question:

Which eligible students have no active placement recommendation and may require
intervention?
*/

WITH latest_eligibility AS (
    SELECT
        aee.student_id,
        aee.placement_cycle_id,
        aee.eligibility_status,
        aee.data_quality_status,
        ROW_NUMBER() OVER (
            PARTITION BY
                aee.student_id,
                aee.placement_cycle_id
            ORDER BY aee.evaluated_at DESC
        ) AS evaluation_rank
    FROM academic_eligibility_evaluation aee
    WHERE aee.placement_cycle_id = :placement_cycle_id
),
current_academic_record AS (
    SELECT
        sar.student_id,
        sar.academic_program_id,
        sar.academic_year,
        ROW_NUMBER() OVER (
            PARTITION BY sar.student_id
            ORDER BY sar.valid_from DESC
        ) AS academic_rank
    FROM student_academic_record sar
    WHERE sar.valid_from <=
          COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
      AND (
          sar.valid_to IS NULL
          OR sar.valid_to >
             COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
      )
),
active_recommendations AS (
    SELECT DISTINCT
        a.student_id
    FROM placement_recommendation pr
    INNER JOIN application a
        ON a.application_id = pr.application_id
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = a.opportunity_id
    WHERE io.placement_cycle_id = :placement_cycle_id
      AND pr.recommendation_status IN (
          'pending_review',
          'information_required',
          'recommended',
          'limited_recommendation',
          'capacity_hold',
          'approved',
          'overridden'
      )
      AND (
          pr.expires_at IS NULL
          OR pr.expires_at >
             COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
      )
),
confirmed_students AS (
    SELECT DISTINCT
        p.student_id
    FROM placement p
    WHERE p.placement_cycle_id = :placement_cycle_id
      AND p.placement_status IN (
          'confirmed',
          'active',
          'completed'
      )
),
application_activity AS (
    SELECT
        a.student_id,
        COUNT(*) AS application_count,
        COUNT(*) FILTER (
            WHERE a.application_status IN (
                'ineligible',
                'not_selected',
                'expired',
                'closed'
            )
        ) AS unsuccessful_application_count
    FROM application a
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = a.opportunity_id
    WHERE io.placement_cycle_id = :placement_cycle_id
    GROUP BY a.student_id
)
SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    ap.program_name,
    car.academic_year,
    COALESCE(aa.application_count, 0)
        AS application_count,
    COALESCE(aa.unsuccessful_application_count, 0)
        AS unsuccessful_application_count,
    CASE
        WHEN COALESCE(aa.application_count, 0) = 0
            THEN 'no_active_application'
        WHEN COALESCE(
            aa.unsuccessful_application_count,
            0
        ) = COALESCE(aa.application_count, 0)
            THEN 'all_applications_unsuccessful'
        ELSE 'no_active_recommendation'
    END AS likely_intervention_reason
FROM latest_eligibility le
INNER JOIN student s
    ON s.student_id = le.student_id
LEFT JOIN current_academic_record car
    ON car.student_id = s.student_id
   AND car.academic_rank = 1
LEFT JOIN academic_program ap
    ON ap.academic_program_id =
       car.academic_program_id
LEFT JOIN application_activity aa
    ON aa.student_id = s.student_id
LEFT JOIN active_recommendations ar
    ON ar.student_id = s.student_id
LEFT JOIN confirmed_students cs
    ON cs.student_id = s.student_id
WHERE le.evaluation_rank = 1
  AND le.eligibility_status = 'eligible'
  AND ar.student_id IS NULL
  AND cs.student_id IS NULL
ORDER BY
    unsuccessful_application_count DESC,
    application_count ASC,
    s.student_id;


/*
===============================================================================
QUERY 16
No-Recommendation Rate
===============================================================================

Business question:

What percentage of eligible students currently have no active recommendation?
*/

WITH latest_eligibility AS (
    SELECT
        aee.student_id,
        aee.eligibility_status,
        ROW_NUMBER() OVER (
            PARTITION BY
                aee.student_id,
                aee.placement_cycle_id
            ORDER BY aee.evaluated_at DESC
        ) AS evaluation_rank
    FROM academic_eligibility_evaluation aee
    WHERE aee.placement_cycle_id = :placement_cycle_id
),
active_recommendations AS (
    SELECT DISTINCT
        a.student_id
    FROM placement_recommendation pr
    INNER JOIN application a
        ON a.application_id = pr.application_id
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = a.opportunity_id
    WHERE io.placement_cycle_id = :placement_cycle_id
      AND pr.recommendation_status IN (
          'pending_review',
          'recommended',
          'limited_recommendation',
          'capacity_hold',
          'approved',
          'overridden'
      )
      AND (
          pr.expires_at IS NULL
          OR pr.expires_at >
             COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
      )
)
SELECT
    COUNT(DISTINCT le.student_id)
        AS eligible_student_count,
    COUNT(DISTINCT le.student_id) FILTER (
        WHERE ar.student_id IS NOT NULL
    ) AS students_with_active_recommendation,
    COUNT(DISTINCT le.student_id) FILTER (
        WHERE ar.student_id IS NULL
    ) AS students_without_active_recommendation,
    ROUND(
        100.0
        * COUNT(DISTINCT le.student_id) FILTER (
            WHERE ar.student_id IS NULL
        )
        / NULLIF(
            COUNT(DISTINCT le.student_id),
            0
        ),
        2
    ) AS no_recommendation_rate_pct
FROM latest_eligibility le
LEFT JOIN active_recommendations ar
    ON ar.student_id = le.student_id
WHERE le.evaluation_rank = 1
  AND le.eligibility_status = 'eligible';


/*
===============================================================================
QUERY 17
Recommendation Concentration
===============================================================================

Business question:

What proportion of recommendations is received by the top 10 percent of
students?

Interpretation:

A high concentration should trigger investigation. It does not automatically
prove unfair treatment.
*/

WITH student_recommendation_counts AS (
    SELECT
        a.student_id,
        COUNT(*) AS recommendation_count
    FROM placement_recommendation pr
    INNER JOIN application a
        ON a.application_id = pr.application_id
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = a.opportunity_id
    WHERE io.placement_cycle_id = :placement_cycle_id
    GROUP BY a.student_id
),
ranked_students AS (
    SELECT
        student_id,
        recommendation_count,
        NTILE(10) OVER (
            ORDER BY recommendation_count DESC
        ) AS recommendation_decile
    FROM student_recommendation_counts
)
SELECT
    SUM(recommendation_count)
        AS total_recommendations,
    SUM(recommendation_count) FILTER (
        WHERE recommendation_decile = 1
    ) AS recommendations_received_by_top_decile,
    ROUND(
        100.0
        * SUM(recommendation_count) FILTER (
            WHERE recommendation_decile = 1
        )
        / NULLIF(
            SUM(recommendation_count),
            0
        ),
        2
    ) AS recommendation_concentration_rate_pct
FROM ranked_students;


/*
===============================================================================
QUERY 18
Placement Offer Funnel
===============================================================================

Business questions:

- How many offers are pending, accepted, declined or expired?
- What is the student offer-acceptance rate?
- What is the offer-expiration rate?
*/

SELECT
    COUNT(*) AS total_offer_count,
    COUNT(*) FILTER (
        WHERE po.offer_status = 'pending_response'
    ) AS pending_offer_count,
    COUNT(*) FILTER (
        WHERE po.student_response_status = 'accepted'
    ) AS student_accepted_count,
    COUNT(*) FILTER (
        WHERE po.student_response_status IN (
            'declined',
            'rejected'
        )
    ) AS student_declined_count,
    COUNT(*) FILTER (
        WHERE po.offer_status = 'expired'
           OR po.student_response_status = 'expired'
    ) AS expired_offer_count,
    COUNT(*) FILTER (
        WHERE po.employer_response_status = 'accepted'
    ) AS employer_accepted_count,
    COUNT(*) FILTER (
        WHERE po.employer_response_status IN (
            'declined',
            'rejected'
        )
    ) AS employer_rejected_count,
    COUNT(*) FILTER (
        WHERE po.offer_status = 'placement_confirmed'
    ) AS placement_confirmed_offer_count,
    ROUND(
        100.0
        * COUNT(*) FILTER (
            WHERE po.student_response_status = 'accepted'
        )
        / NULLIF(
            COUNT(*) FILTER (
                WHERE po.student_response_status IN (
                    'accepted',
                    'declined',
                    'rejected'
                )
            ),
            0
        ),
        2
    ) AS student_offer_acceptance_rate_pct,
    ROUND(
        100.0
        * COUNT(*) FILTER (
            WHERE po.offer_status = 'expired'
               OR po.student_response_status = 'expired'
        )
        / NULLIF(COUNT(*), 0),
        2
    ) AS offer_expiration_rate_pct
FROM placement_offer po
INNER JOIN internship_opportunity io
    ON io.opportunity_id = po.opportunity_id
WHERE io.placement_cycle_id = :placement_cycle_id;


/*
===============================================================================
QUERY 19
Student and Employer Response Times
===============================================================================

Business questions:

- How long do students take to respond to offers?
- How long do employers take to confirm or reject candidates?
*/

SELECT
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    po.student_responded_at
                    - po.offer_created_at
                )
            ) / 3600.0
        ) FILTER (
            WHERE po.student_responded_at IS NOT NULL
        ),
        2
    ) AS average_student_response_time_hours,
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (
            ORDER BY
                EXTRACT(
                    EPOCH FROM (
                        po.student_responded_at
                        - po.offer_created_at
                    )
                ) / 3600.0
        ) FILTER (
            WHERE po.student_responded_at IS NOT NULL
        ),
        2
    ) AS median_student_response_time_hours,
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    po.employer_responded_at
                    - po.offer_created_at
                )
            ) / 3600.0
        ) FILTER (
            WHERE po.employer_responded_at IS NOT NULL
        ),
        2
    ) AS average_employer_response_time_hours,
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (
            ORDER BY
                EXTRACT(
                    EPOCH FROM (
                        po.employer_responded_at
                        - po.offer_created_at
                    )
                ) / 3600.0
        ) FILTER (
            WHERE po.employer_responded_at IS NOT NULL
        ),
        2
    ) AS median_employer_response_time_hours
FROM placement_offer po
INNER JOIN internship_opportunity io
    ON io.opportunity_id = po.opportunity_id
WHERE io.placement_cycle_id = :placement_cycle_id;


/*
===============================================================================
QUERY 20
Student Placement Rate by Academic Program
===============================================================================

Business questions:

- What percentage of eligible students received confirmed placements?
- Which programs have the highest number of unplaced students?
*/

WITH latest_eligibility AS (
    SELECT
        aee.student_id,
        aee.eligibility_status,
        ROW_NUMBER() OVER (
            PARTITION BY
                aee.student_id,
                aee.placement_cycle_id
            ORDER BY aee.evaluated_at DESC
        ) AS evaluation_rank
    FROM academic_eligibility_evaluation aee
    WHERE aee.placement_cycle_id = :placement_cycle_id
),
current_academic_record AS (
    SELECT
        sar.student_id,
        sar.academic_program_id,
        ROW_NUMBER() OVER (
            PARTITION BY sar.student_id
            ORDER BY sar.valid_from DESC
        ) AS academic_rank
    FROM student_academic_record sar
    WHERE sar.valid_from <=
          COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
      AND (
          sar.valid_to IS NULL
          OR sar.valid_to >
             COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
      )
),
placed_students AS (
    SELECT DISTINCT
        p.student_id
    FROM placement p
    WHERE p.placement_cycle_id = :placement_cycle_id
      AND p.placement_status IN (
          'confirmed',
          'active',
          'completed'
      )
)
SELECT
    ap.academic_program_id,
    ap.program_name,
    ap.department_name,
    COUNT(DISTINCT le.student_id)
        AS eligible_student_count,
    COUNT(DISTINCT ps.student_id)
        AS placed_student_count,
    COUNT(DISTINCT le.student_id)
    - COUNT(DISTINCT ps.student_id)
        AS unplaced_student_count,
    ROUND(
        100.0
        * COUNT(DISTINCT ps.student_id)
        / NULLIF(
            COUNT(DISTINCT le.student_id),
            0
        ),
        2
    ) AS student_placement_rate_pct
FROM latest_eligibility le
INNER JOIN current_academic_record car
    ON car.student_id = le.student_id
   AND car.academic_rank = 1
INNER JOIN academic_program ap
    ON ap.academic_program_id =
       car.academic_program_id
LEFT JOIN placed_students ps
    ON ps.student_id = le.student_id
WHERE le.evaluation_rank = 1
  AND le.eligibility_status = 'eligible'
GROUP BY
    ap.academic_program_id,
    ap.program_name,
    ap.department_name
ORDER BY
    student_placement_rate_pct ASC,
    eligible_student_count DESC;


/*
===============================================================================
QUERY 21
Average Time to Placement
===============================================================================

Business question:

How many days pass between a student's first submitted application and final
placement confirmation?
*/

WITH first_application AS (
    SELECT
        a.student_id,
        io.placement_cycle_id,
        MIN(a.submitted_at) AS first_application_at
    FROM application a
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = a.opportunity_id
    WHERE io.placement_cycle_id = :placement_cycle_id
      AND a.application_status <> 'draft'
    GROUP BY
        a.student_id,
        io.placement_cycle_id
),
placement_times AS (
    SELECT
        p.student_id,
        p.placement_id,
        p.confirmed_at,
        fa.first_application_at,
        EXTRACT(
            EPOCH FROM (
                p.confirmed_at
                - fa.first_application_at
            )
        ) / 86400.0 AS days_to_placement
    FROM placement p
    INNER JOIN first_application fa
        ON fa.student_id = p.student_id
       AND fa.placement_cycle_id =
           p.placement_cycle_id
    WHERE p.placement_cycle_id = :placement_cycle_id
      AND p.placement_status IN (
          'confirmed',
          'active',
          'completed'
      )
)
SELECT
    COUNT(*) AS placement_count,
    ROUND(
        AVG(days_to_placement),
        2
    ) AS average_days_to_placement,
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (
            ORDER BY days_to_placement
        ),
        2
    ) AS median_days_to_placement,
    ROUND(
        MIN(days_to_placement),
        2
    ) AS minimum_days_to_placement,
    ROUND(
        MAX(days_to_placement),
        2
    ) AS maximum_days_to_placement
FROM placement_times;


/*
===============================================================================
QUERY 22
Employer Opportunity Fill Rate
===============================================================================

Business questions:

- Which employers fill their internship capacity?
- Which employers have substantial unused capacity?
*/

WITH employer_capacity AS (
    SELECT
        e.employer_id,
        e.employer_name,
        COUNT(DISTINCT io.opportunity_id)
            AS opportunity_count,
        SUM(io.total_capacity)
            AS total_capacity
    FROM employer e
    INNER JOIN internship_opportunity io
        ON io.employer_id = e.employer_id
    WHERE io.placement_cycle_id = :placement_cycle_id
      AND io.opportunity_status IN (
          'active',
          'closed',
          'expired'
      )
    GROUP BY
        e.employer_id,
        e.employer_name
),
employer_placements AS (
    SELECT
        p.employer_id,
        COUNT(*) AS confirmed_placement_count
    FROM placement p
    WHERE p.placement_cycle_id = :placement_cycle_id
      AND p.placement_status IN (
          'confirmed',
          'active',
          'completed'
      )
    GROUP BY p.employer_id
)
SELECT
    ec.employer_id,
    ec.employer_name,
    ec.opportunity_count,
    ec.total_capacity,
    COALESCE(
        ep.confirmed_placement_count,
        0
    ) AS confirmed_placement_count,
    ec.total_capacity
    - COALESCE(ep.confirmed_placement_count, 0)
        AS unused_capacity,
    ROUND(
        100.0
        * COALESCE(ep.confirmed_placement_count, 0)
        / NULLIF(ec.total_capacity, 0),
        2
    ) AS employer_opportunity_fill_rate_pct
FROM employer_capacity ec
LEFT JOIN employer_placements ep
    ON ep.employer_id = ec.employer_id
ORDER BY
    employer_opportunity_fill_rate_pct ASC,
    ec.total_capacity DESC;


/*
===============================================================================
QUERY 23
Employer Candidate Acceptance and Response
===============================================================================

Business questions:

- Which employers accept or reject the highest proportion of candidates?
- How quickly does each employer respond?
*/

SELECT
    e.employer_id,
    e.employer_name,
    COUNT(*) FILTER (
        WHERE po.employer_response_status IN (
            'accepted',
            'rejected',
            'declined'
        )
    ) AS completed_employer_decisions,
    COUNT(*) FILTER (
        WHERE po.employer_response_status = 'accepted'
    ) AS accepted_candidate_count,
    COUNT(*) FILTER (
        WHERE po.employer_response_status IN (
            'rejected',
            'declined'
        )
    ) AS rejected_candidate_count,
    ROUND(
        100.0
        * COUNT(*) FILTER (
            WHERE po.employer_response_status = 'accepted'
        )
        / NULLIF(
            COUNT(*) FILTER (
                WHERE po.employer_response_status IN (
                    'accepted',
                    'rejected',
                    'declined'
                )
            ),
            0
        ),
        2
    ) AS employer_candidate_acceptance_rate_pct,
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    po.employer_responded_at
                    - po.offer_created_at
                )
            ) / 3600.0
        ) FILTER (
            WHERE po.employer_responded_at IS NOT NULL
        ),
        2
    ) AS average_response_time_hours
FROM employer e
INNER JOIN internship_opportunity io
    ON io.employer_id = e.employer_id
INNER JOIN placement_offer po
    ON po.opportunity_id = io.opportunity_id
WHERE io.placement_cycle_id = :placement_cycle_id
GROUP BY
    e.employer_id,
    e.employer_name
ORDER BY
    employer_candidate_acceptance_rate_pct DESC NULLS LAST;


/*
===============================================================================
QUERY 24
Opportunity Cancellation Impact
===============================================================================

Business questions:

- Which cancelled opportunities affected the most students?
- How many applications and offers were active at cancellation?
*/

SELECT
    io.opportunity_id,
    io.opportunity_title,
    e.employer_name,
    io.total_capacity,
    COUNT(DISTINCT a.application_id)
        AS affected_application_count,
    COUNT(DISTINCT a.student_id)
        AS affected_student_count,
    COUNT(DISTINCT po.placement_offer_id)
        AS affected_offer_count,
    COUNT(DISTINCT p.placement_id)
        AS affected_placement_count
FROM internship_opportunity io
INNER JOIN employer e
    ON e.employer_id = io.employer_id
LEFT JOIN application a
    ON a.opportunity_id = io.opportunity_id
LEFT JOIN placement_offer po
    ON po.opportunity_id = io.opportunity_id
LEFT JOIN placement p
    ON p.opportunity_id = io.opportunity_id
WHERE io.placement_cycle_id = :placement_cycle_id
  AND io.opportunity_status = 'cancelled'
GROUP BY
    io.opportunity_id,
    io.opportunity_title,
    e.employer_name,
    io.total_capacity
ORDER BY
    affected_student_count DESC,
    affected_offer_count DESC;


/*
===============================================================================
QUERY 25
Placement Cancellation Rate and Reasons
===============================================================================

Business questions:

- What proportion of confirmed placements are cancelled?
- What are the most common cancellation reasons?
*/

SELECT
    pc.cancellation_reason_category,
    COUNT(*) AS cancellation_count,
    COUNT(DISTINCT pc.placement_id)
        AS affected_placement_count,
    COUNT(*) FILTER (
        WHERE pc.replacement_support_required = TRUE
    ) AS replacement_support_required_count,
    COUNT(*) FILTER (
        WHERE pc.capacity_release_status = 'released'
    ) AS released_capacity_count
FROM placement_cancellation pc
INNER JOIN placement p
    ON p.placement_id = pc.placement_id
WHERE p.placement_cycle_id = :placement_cycle_id
GROUP BY pc.cancellation_reason_category
ORDER BY cancellation_count DESC;


/*
===============================================================================
QUERY 26
Internship Outcome Summary
===============================================================================

Business questions:

- How many internships were completed successfully?
- How many were cancelled, failed or remain under review?
- What is the successful completion rate?
*/

SELECT
    io2.outcome_status,
    COUNT(*) AS outcome_count,
    ROUND(
        100.0
        * COUNT(*)
        / NULLIF(SUM(COUNT(*)) OVER (), 0),
        2
    ) AS outcome_share_pct,
    COUNT(*) FILTER (
        WHERE io2.academic_credit_status = 'approved'
    ) AS academic_credit_approved_count,
    COUNT(*) FILTER (
        WHERE io2.academic_credit_status = 'pending'
    ) AS academic_credit_pending_count
FROM internship_outcome io2
INNER JOIN placement p
    ON p.placement_id = io2.placement_id
WHERE p.placement_cycle_id = :placement_cycle_id
GROUP BY io2.outcome_status
ORDER BY outcome_count DESC;


/*
===============================================================================
QUERY 27
Successful Completion Rate
===============================================================================

Business question:

What percentage of internships with a final outcome were completed
successfully?
*/

SELECT
    COUNT(*) AS final_outcome_count,
    COUNT(*) FILTER (
        WHERE io2.outcome_status =
              'successfully_completed'
    ) AS successfully_completed_count,
    COUNT(*) FILTER (
        WHERE io2.outcome_status =
              'partially_completed'
    ) AS partially_completed_count,
    COUNT(*) FILTER (
        WHERE io2.outcome_status = 'failed'
    ) AS failed_count,
    COUNT(*) FILTER (
        WHERE io2.outcome_status IN (
            'cancelled_by_student',
            'cancelled_by_employer',
            'terminated_by_university'
        )
    ) AS cancelled_or_terminated_count,
    ROUND(
        100.0
        * COUNT(*) FILTER (
            WHERE io2.outcome_status =
                  'successfully_completed'
        )
        / NULLIF(
            COUNT(*) FILTER (
                WHERE io2.outcome_status <>
                      'under_review'
            ),
            0
        ),
        2
    ) AS successful_completion_rate_pct
FROM internship_outcome io2
INNER JOIN placement p
    ON p.placement_id = io2.placement_id
WHERE p.placement_cycle_id = :placement_cycle_id;


/*
===============================================================================
QUERY 28
Recommendation Effectiveness by Compatibility Band
===============================================================================

Business question:

How do recommendation scores relate to final internship outcomes?

Important:

This query measures association, not causation.
*/

WITH recommendation_placement_outcome AS (
    SELECT
        pr.recommendation_id,
        pr.model_version,
        pr.overall_score,
        pr.confidence_level,
        p.placement_id,
        io2.outcome_status
    FROM placement_recommendation pr
    INNER JOIN placement_decision pd
        ON pd.recommendation_id =
           pr.recommendation_id
       AND pd.decision_status IN (
           'approved',
           'overridden'
       )
    INNER JOIN placement_offer po
        ON po.placement_decision_id =
           pd.placement_decision_id
    INNER JOIN placement p
        ON p.placement_offer_id =
           po.placement_offer_id
    LEFT JOIN internship_outcome io2
        ON io2.placement_id = p.placement_id
    WHERE p.placement_cycle_id = :placement_cycle_id
)
SELECT
    model_version,
    CASE
        WHEN overall_score >= 85
            THEN 'very_strong'
        WHEN overall_score >= 70
            THEN 'strong'
        WHEN overall_score >= 55
            THEN 'moderate'
        WHEN overall_score >= 40
            THEN 'limited'
        ELSE 'weak'
    END AS compatibility_band,
    COUNT(DISTINCT placement_id)
        AS placement_count,
    COUNT(DISTINCT placement_id) FILTER (
        WHERE outcome_status =
              'successfully_completed'
    ) AS successful_placement_count,
    COUNT(DISTINCT placement_id) FILTER (
        WHERE outcome_status IS NOT NULL
          AND outcome_status <> 'under_review'
    ) AS placements_with_final_outcome,
    ROUND(
        100.0
        * COUNT(DISTINCT placement_id) FILTER (
            WHERE outcome_status =
                  'successfully_completed'
        )
        / NULLIF(
            COUNT(DISTINCT placement_id) FILTER (
                WHERE outcome_status IS NOT NULL
                  AND outcome_status <>
                      'under_review'
            ),
            0
        ),
        2
    ) AS recommendation_effectiveness_rate_pct,
    ROUND(
        AVG(confidence_level),
        2
    ) AS average_confidence_level
FROM recommendation_placement_outcome
GROUP BY
    model_version,
    compatibility_band
ORDER BY
    model_version,
    MIN(overall_score) DESC;


/*
===============================================================================
QUERY 29
Manual Override Rate and Categories
===============================================================================

Business questions:

- What percentage of reviewed recommendations receive an override?
- Which override categories are most common?
- Which reviewers create the most overrides?
*/

WITH completed_decisions AS (
    SELECT
        pd.placement_decision_id,
        pd.recommendation_id,
        pd.decided_by,
        pd.decision_status,
        pd.decided_at
    FROM placement_decision pd
    INNER JOIN placement_recommendation pr
        ON pr.recommendation_id =
           pd.recommendation_id
    INNER JOIN application a
        ON a.application_id = pr.application_id
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = a.opportunity_id
    WHERE io.placement_cycle_id = :placement_cycle_id
      AND pd.decision_status IN (
          'approved',
          'rejected',
          'overridden'
      )
)
SELECT
    COUNT(DISTINCT cd.placement_decision_id)
        AS completed_decision_count,
    COUNT(DISTINCT mo.manual_override_id)
        AS override_count,
    ROUND(
        100.0
        * COUNT(DISTINCT mo.manual_override_id)
        / NULLIF(
            COUNT(DISTINCT cd.placement_decision_id),
            0
        ),
        2
    ) AS manual_override_rate_pct,
    COUNT(DISTINCT mo.manual_override_id) FILTER (
        WHERE mo.secondary_approval_required = TRUE
    ) AS overrides_requiring_secondary_approval,
    COUNT(DISTINCT mo.manual_override_id) FILTER (
        WHERE mo.secondary_approval_required = TRUE
          AND mo.secondary_approved_by IS NOT NULL
    ) AS overrides_with_secondary_approval
FROM completed_decisions cd
LEFT JOIN manual_override mo
    ON mo.placement_decision_id =
       cd.placement_decision_id;


/*
===============================================================================
QUERY 30
Manual Override Detail
===============================================================================

Business question:

Which override categories, reviewers and rules should receive governance review?
*/

SELECT
    mo.override_category,
    mo.approved_by,
    COUNT(*) AS override_count,
    COUNT(*) FILTER (
        WHERE mo.secondary_approval_required = TRUE
    ) AS secondary_approval_required_count,
    COUNT(*) FILTER (
        WHERE mo.secondary_approval_required = TRUE
          AND mo.secondary_approved_by IS NULL
    ) AS missing_secondary_approval_count,
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    COALESCE(
                        mo.secondary_approved_at,
                        mo.approved_at
                    )
                    - mo.approved_at
                )
            ) / 3600.0
        ) FILTER (
            WHERE mo.secondary_approval_required = TRUE
              AND mo.secondary_approved_at IS NOT NULL
        ),
        2
    ) AS average_secondary_approval_time_hours
FROM manual_override mo
INNER JOIN placement_decision pd
    ON pd.placement_decision_id =
       mo.placement_decision_id
INNER JOIN placement_recommendation pr
    ON pr.recommendation_id =
       pd.recommendation_id
INNER JOIN application a
    ON a.application_id = pr.application_id
INNER JOIN internship_opportunity io
    ON io.opportunity_id = a.opportunity_id
WHERE io.placement_cycle_id = :placement_cycle_id
GROUP BY
    mo.override_category,
    mo.approved_by
ORDER BY
    override_count DESC,
    missing_secondary_approval_count DESC;


/*
===============================================================================
QUERY 31
Decision Reason Completeness
===============================================================================

Business question:

Do final human decisions contain a valid reason and structured reason category?
*/

SELECT
    COUNT(*) AS final_decision_count,
    COUNT(*) FILTER (
        WHERE pd.decision_reason_category IS NOT NULL
          AND TRIM(pd.decision_reason_category) <> ''
          AND pd.decision_reason IS NOT NULL
          AND LENGTH(TRIM(pd.decision_reason)) >= 20
    ) AS complete_decision_reason_count,
    COUNT(*) FILTER (
        WHERE pd.decision_reason_category IS NULL
           OR TRIM(pd.decision_reason_category) = ''
           OR pd.decision_reason IS NULL
           OR LENGTH(TRIM(pd.decision_reason)) < 20
    ) AS incomplete_decision_reason_count,
    ROUND(
        100.0
        * COUNT(*) FILTER (
            WHERE pd.decision_reason_category IS NOT NULL
              AND TRIM(pd.decision_reason_category) <> ''
              AND pd.decision_reason IS NOT NULL
              AND LENGTH(TRIM(pd.decision_reason)) >= 20
        )
        / NULLIF(COUNT(*), 0),
        2
    ) AS decision_reason_completeness_rate_pct
FROM placement_decision pd
INNER JOIN placement_recommendation pr
    ON pr.recommendation_id =
       pd.recommendation_id
INNER JOIN application a
    ON a.application_id = pr.application_id
INNER JOIN internship_opportunity io
    ON io.opportunity_id = a.opportunity_id
WHERE io.placement_cycle_id = :placement_cycle_id
  AND pd.decision_status IN (
      'approved',
      'rejected',
      'overridden'
  );


/*
===============================================================================
QUERY 32
Intervention Case Backlog
===============================================================================

Business questions:

- How many unplaced-student intervention cases are open?
- Which cases are overdue?
- Which reasons occur most frequently?
*/

SELECT
    ic.intervention_reason,
    ic.priority,
    ic.intervention_status,
    COUNT(*) AS intervention_case_count,
    COUNT(*) FILTER (
        WHERE ic.deadline <
              COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
          AND ic.intervention_status NOT IN (
              'resolved',
              'closed'
          )
    ) AS overdue_case_count,
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    COALESCE(
                        ic.resolved_at,
                        COALESCE(
                            :as_of_timestamp,
                            CURRENT_TIMESTAMP
                        )
                    )
                    - ic.opened_at
                )
            ) / 86400.0
        ),
        2
    ) AS average_case_age_days
FROM intervention_case ic
WHERE ic.placement_cycle_id = :placement_cycle_id
GROUP BY
    ic.intervention_reason,
    ic.priority,
    ic.intervention_status
ORDER BY
    CASE ic.priority
        WHEN 'critical' THEN 1
        WHEN 'high' THEN 2
        ELSE 3
    END,
    overdue_case_count DESC;


/*
===============================================================================
QUERY 33
Student Profile and Academic Data Quality
===============================================================================

Business questions:

- How many active students have incomplete profiles?
- How many academic records are stale, conflicting or incomplete?
*/

WITH current_profiles AS (
    SELECT
        sp.student_id,
        sp.profile_status,
        sp.profile_completeness_rate,
        ROW_NUMBER() OVER (
            PARTITION BY sp.student_id
            ORDER BY sp.profile_version DESC
        ) AS profile_rank
    FROM student_profile sp
    WHERE sp.effective_from <=
          COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
      AND (
          sp.effective_to IS NULL
          OR sp.effective_to >
             COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
      )
),
current_academic_records AS (
    SELECT
        sar.student_id,
        sar.data_quality_status,
        sar.source_updated_at,
        ROW_NUMBER() OVER (
            PARTITION BY sar.student_id
            ORDER BY sar.valid_from DESC
        ) AS academic_rank
    FROM student_academic_record sar
    WHERE sar.valid_from <=
          COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
      AND (
          sar.valid_to IS NULL
          OR sar.valid_to >
             COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
      )
)
SELECT
    COUNT(DISTINCT s.student_id)
        AS active_student_count,
    COUNT(DISTINCT s.student_id) FILTER (
        WHERE cp.profile_status = 'complete'
    ) AS complete_profile_count,
    COUNT(DISTINCT s.student_id) FILTER (
        WHERE cp.profile_status IS NULL
           OR cp.profile_status <> 'complete'
    ) AS incomplete_profile_count,
    COUNT(DISTINCT s.student_id) FILTER (
        WHERE car.data_quality_status = 'stale'
    ) AS stale_academic_record_count,
    COUNT(DISTINCT s.student_id) FILTER (
        WHERE car.data_quality_status = 'conflicting'
    ) AS conflicting_academic_record_count,
    COUNT(DISTINCT s.student_id) FILTER (
        WHERE car.data_quality_status = 'incomplete'
           OR car.data_quality_status IS NULL
    ) AS incomplete_academic_record_count,
    ROUND(
        100.0
        * COUNT(DISTINCT s.student_id) FILTER (
            WHERE car.data_quality_status = 'stale'
        )
        / NULLIF(
            COUNT(DISTINCT s.student_id),
            0
        ),
        2
    ) AS stale_academic_data_rate_pct
FROM student s
LEFT JOIN current_profiles cp
    ON cp.student_id = s.student_id
   AND cp.profile_rank = 1
LEFT JOIN current_academic_records car
    ON car.student_id = s.student_id
   AND car.academic_rank = 1
WHERE s.student_status = 'active';


/*
===============================================================================
QUERY 34
Recommendation Data-Quality Warning Rate
===============================================================================

Business question:

What percentage of recommendations contain incomplete, stale, conflicting or
low-confidence evidence?
*/

SELECT
    COUNT(DISTINCT pr.recommendation_id)
        AS total_recommendation_count,
    COUNT(DISTINCT pr.recommendation_id) FILTER (
        WHERE me.data_quality_status IN (
            'incomplete',
            'stale',
            'conflicting',
            'unverified',
            'low_confidence'
        )
           OR me.confidence_level < 60
    ) AS recommendation_with_warning_count,
    ROUND(
        100.0
        * COUNT(DISTINCT pr.recommendation_id) FILTER (
            WHERE me.data_quality_status IN (
                'incomplete',
                'stale',
                'conflicting',
                'unverified',
                'low_confidence'
            )
               OR me.confidence_level < 60
        )
        / NULLIF(
            COUNT(DISTINCT pr.recommendation_id),
            0
        ),
        2
    ) AS recommendation_data_warning_rate_pct
FROM placement_recommendation pr
INNER JOIN match_evaluation me
    ON me.match_evaluation_id =
       pr.match_evaluation_id
INNER JOIN application a
    ON a.application_id = pr.application_id
INNER JOIN internship_opportunity io
    ON io.opportunity_id = a.opportunity_id
WHERE io.placement_cycle_id = :placement_cycle_id;


/*
===============================================================================
QUERY 35
Recommendation Review SLA
===============================================================================

Business questions:

- How many recommendations remain pending?
- How many are older than the approved review SLA?
*/

SELECT
    COUNT(*) FILTER (
        WHERE pr.recommendation_status IN (
            'pending_review',
            'information_required'
        )
    ) AS pending_recommendation_count,
    COUNT(*) FILTER (
        WHERE pr.recommendation_status IN (
            'pending_review',
            'information_required'
        )
          AND EXTRACT(
              EPOCH FROM (
                  COALESCE(
                      :as_of_timestamp,
                      CURRENT_TIMESTAMP
                  )
                  - pr.generated_at
              )
          ) / 3600.0 >
              :recommendation_review_sla_hours
    ) AS overdue_recommendation_count,
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    pd.decided_at
                    - pr.generated_at
                )
            ) / 3600.0
        ) FILTER (
            WHERE pd.decided_at IS NOT NULL
        ),
        2
    ) AS average_completed_review_time_hours
FROM placement_recommendation pr
INNER JOIN application a
    ON a.application_id = pr.application_id
INNER JOIN internship_opportunity io
    ON io.opportunity_id = a.opportunity_id
LEFT JOIN placement_decision pd
    ON pd.recommendation_id =
       pr.recommendation_id
WHERE io.placement_cycle_id = :placement_cycle_id;


/*
===============================================================================
QUERY 36
Capacity Reconciliation Exceptions
===============================================================================

Business question:

Which opportunities have capacity values that violate the approved formula?

Expected formula:

Available Capacity =
Total Capacity
- Confirmed Placements
- Active Reservations
*/

WITH confirmed_capacity AS (
    SELECT
        p.opportunity_id,
        COUNT(*) AS confirmed_placement_count
    FROM placement p
    WHERE p.placement_cycle_id = :placement_cycle_id
      AND p.placement_status IN (
          'confirmed',
          'active',
          'completed'
      )
    GROUP BY p.opportunity_id
),
active_reservations AS (
    SELECT
        cr.opportunity_id,
        COUNT(*) AS active_reservation_count
    FROM capacity_reservation cr
    WHERE cr.reservation_status = 'active'
      AND cr.expires_at >
          COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
    GROUP BY cr.opportunity_id
)
SELECT
    io.opportunity_id,
    io.opportunity_title,
    io.total_capacity,
    COALESCE(
        cc.confirmed_placement_count,
        0
    ) AS confirmed_placements,
    COALESCE(
        ar.active_reservation_count,
        0
    ) AS active_reservations,
    io.total_capacity
    - COALESCE(cc.confirmed_placement_count, 0)
    - COALESCE(ar.active_reservation_count, 0)
        AS calculated_available_capacity,
    CASE
        WHEN io.total_capacity <= 0
            THEN 'invalid_total_capacity'
        WHEN
            io.total_capacity
            - COALESCE(cc.confirmed_placement_count, 0)
            - COALESCE(ar.active_reservation_count, 0) < 0
            THEN 'negative_available_capacity'
        WHEN COALESCE(cc.confirmed_placement_count, 0)
             > io.total_capacity
            THEN 'confirmed_placements_exceed_capacity'
        ELSE 'reconciled'
    END AS reconciliation_status
FROM internship_opportunity io
LEFT JOIN confirmed_capacity cc
    ON cc.opportunity_id = io.opportunity_id
LEFT JOIN active_reservations ar
    ON ar.opportunity_id = io.opportunity_id
WHERE io.placement_cycle_id = :placement_cycle_id
  AND (
      io.total_capacity <= 0
      OR
      io.total_capacity
      - COALESCE(cc.confirmed_placement_count, 0)
      - COALESCE(ar.active_reservation_count, 0) < 0
      OR COALESCE(cc.confirmed_placement_count, 0)
         > io.total_capacity
  )
ORDER BY io.opportunity_id;


/*
===============================================================================
QUERY 37
Expired Offers With Active Capacity Reservations
===============================================================================

Business question:

Are expired or declined offers still blocking opportunity capacity?
*/

SELECT
    po.placement_offer_id,
    po.student_id,
    po.opportunity_id,
    po.offer_status,
    po.student_response_status,
    po.offer_expires_at,
    cr.capacity_reservation_id,
    cr.reservation_status,
    cr.expires_at AS reservation_expires_at
FROM placement_offer po
INNER JOIN capacity_reservation cr
    ON cr.placement_offer_id =
       po.placement_offer_id
INNER JOIN internship_opportunity io
    ON io.opportunity_id = po.opportunity_id
WHERE io.placement_cycle_id = :placement_cycle_id
  AND cr.reservation_status = 'active'
  AND (
      po.offer_status IN (
          'expired',
          'declined',
          'cancelled',
          'superseded'
      )
      OR po.student_response_status IN (
          'declined',
          'expired'
      )
      OR po.employer_response_status IN (
          'rejected',
          'declined'
      )
      OR po.offer_expires_at <=
         COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
  )
ORDER BY po.offer_expires_at;


/*
===============================================================================
QUERY 38
Overlapping Confirmed Placement Detection
===============================================================================

Business question:

Does any student have overlapping confirmed internship placements?

PostgreSQL daterange overlap operator:

    &&
*/

SELECT
    p1.student_id,
    p1.placement_id AS first_placement_id,
    p2.placement_id AS second_placement_id,
    p1.internship_start_date
        AS first_start_date,
    p1.internship_end_date
        AS first_end_date,
    p2.internship_start_date
        AS second_start_date,
    p2.internship_end_date
        AS second_end_date
FROM placement p1
INNER JOIN placement p2
    ON p1.student_id = p2.student_id
   AND p1.placement_id < p2.placement_id
   AND DATERANGE(
       p1.internship_start_date,
       p1.internship_end_date,
       '[]'
   ) && DATERANGE(
       p2.internship_start_date,
       p2.internship_end_date,
       '[]'
   )
WHERE p1.placement_cycle_id = :placement_cycle_id
  AND p2.placement_cycle_id = :placement_cycle_id
  AND p1.placement_status IN (
      'confirmed',
      'active'
  )
  AND p2.placement_status IN (
      'confirmed',
      'active'
  )
ORDER BY p1.student_id;


/*
===============================================================================
QUERY 39
Duplicate Active Applications
===============================================================================

Business question:

Does a student have more than one active application for the same opportunity?
*/

SELECT
    a.student_id,
    a.opportunity_id,
    COUNT(*) AS active_application_count,
    ARRAY_AGG(
        a.application_id
        ORDER BY a.submitted_at
    ) AS application_ids
FROM application a
INNER JOIN internship_opportunity io
    ON io.opportunity_id = a.opportunity_id
WHERE io.placement_cycle_id = :placement_cycle_id
  AND a.application_status NOT IN (
      'withdrawn',
      'expired',
      'closed',
      'not_selected',
      'ineligible',
      'placement_confirmed'
  )
GROUP BY
    a.student_id,
    a.opportunity_id
HAVING COUNT(*) > 1
ORDER BY active_application_count DESC;


/*
===============================================================================
QUERY 40
Fairness and Access Review by Academic Program
===============================================================================

Business questions:

- Do recommendation and placement rates differ substantially by program?
- Which programs have the highest no-recommendation rate?

Privacy control:

Rates are suppressed when the eligible population is smaller than
:minimum_group_size.
*/

WITH latest_eligibility AS (
    SELECT
        aee.student_id,
        aee.eligibility_status,
        ROW_NUMBER() OVER (
            PARTITION BY
                aee.student_id,
                aee.placement_cycle_id
            ORDER BY aee.evaluated_at DESC
        ) AS evaluation_rank
    FROM academic_eligibility_evaluation aee
    WHERE aee.placement_cycle_id = :placement_cycle_id
),
current_academic_record AS (
    SELECT
        sar.student_id,
        sar.academic_program_id,
        ROW_NUMBER() OVER (
            PARTITION BY sar.student_id
            ORDER BY sar.valid_from DESC
        ) AS academic_rank
    FROM student_academic_record sar
    WHERE sar.valid_from <=
          COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
      AND (
          sar.valid_to IS NULL
          OR sar.valid_to >
             COALESCE(:as_of_timestamp, CURRENT_TIMESTAMP)
      )
),
recommended_students AS (
    SELECT DISTINCT
        a.student_id
    FROM placement_recommendation pr
    INNER JOIN application a
        ON a.application_id = pr.application_id
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = a.opportunity_id
    WHERE io.placement_cycle_id = :placement_cycle_id
),
placed_students AS (
    SELECT DISTINCT
        p.student_id
    FROM placement p
    WHERE p.placement_cycle_id = :placement_cycle_id
      AND p.placement_status IN (
          'confirmed',
          'active',
          'completed'
      )
),
program_population AS (
    SELECT
        ap.academic_program_id,
        ap.program_name,
        ap.department_name,
        COUNT(DISTINCT le.student_id)
            AS eligible_student_count,
        COUNT(DISTINCT rs.student_id)
            AS recommended_student_count,
        COUNT(DISTINCT ps.student_id)
            AS placed_student_count
    FROM latest_eligibility le
    INNER JOIN current_academic_record car
        ON car.student_id = le.student_id
       AND car.academic_rank = 1
    INNER JOIN academic_program ap
        ON ap.academic_program_id =
           car.academic_program_id
    LEFT JOIN recommended_students rs
        ON rs.student_id = le.student_id
    LEFT JOIN placed_students ps
        ON ps.student_id = le.student_id
    WHERE le.evaluation_rank = 1
      AND le.eligibility_status = 'eligible'
    GROUP BY
        ap.academic_program_id,
        ap.program_name,
        ap.department_name
)
SELECT
    academic_program_id,
    program_name,
    department_name,
    eligible_student_count,
    CASE
        WHEN eligible_student_count <
             :minimum_group_size
        THEN NULL
        ELSE recommended_student_count
    END AS recommended_student_count,
    CASE
        WHEN eligible_student_count <
             :minimum_group_size
        THEN NULL
        ELSE placed_student_count
    END AS placed_student_count,
    CASE
        WHEN eligible_student_count <
             :minimum_group_size
        THEN NULL
        ELSE ROUND(
            100.0
            * recommended_student_count
            / NULLIF(eligible_student_count, 0),
            2
        )
    END AS recommendation_rate_pct,
    CASE
        WHEN eligible_student_count <
             :minimum_group_size
        THEN NULL
        ELSE ROUND(
            100.0
            * placed_student_count
            / NULLIF(eligible_student_count, 0),
            2
        )
    END AS placement_rate_pct,
    CASE
        WHEN eligible_student_count <
             :minimum_group_size
        THEN NULL
        ELSE ROUND(
            100.0
            * (
                eligible_student_count
                - recommended_student_count
            )
            / NULLIF(eligible_student_count, 0),
            2
        )
    END AS no_recommendation_rate_pct,
    CASE
        WHEN eligible_student_count <
             :minimum_group_size
        THEN 'suppressed_small_group'
        ELSE 'reportable'
    END AS privacy_status
FROM program_population
ORDER BY
    privacy_status,
    placement_rate_pct ASC NULLS LAST;


/*
===============================================================================
QUERY 41
Fairness Comparison Against Institutional Placement Rate
===============================================================================

Business question:

How far is each program's placement rate from the institution-wide rate?

Interpretation:

A large difference should trigger contextual review of opportunity supply,
application activity, eligibility, preferences, employer requirements and
sample size.
*/

WITH latest_eligibility AS (
    SELECT
        aee.student_id,
        aee.eligibility_status,
        ROW_NUMBER() OVER (
            PARTITION BY
                aee.student_id,
                aee.placement_cycle_id
            ORDER BY aee.evaluated_at DESC
        ) AS evaluation_rank
    FROM academic_eligibility_evaluation aee
    WHERE aee.placement_cycle_id = :placement_cycle_id
),
current_academic_record AS (
    SELECT
        sar.student_id,
        sar.academic_program_id,
        ROW_NUMBER() OVER (
            PARTITION BY sar.student_id
            ORDER BY sar.valid_from DESC
        ) AS academic_rank
    FROM student_academic_record sar
),
placed_students AS (
    SELECT DISTINCT
        p.student_id
    FROM placement p
    WHERE p.placement_cycle_id = :placement_cycle_id
      AND p.placement_status IN (
          'confirmed',
          'active',
          'completed'
      )
),
eligible_population AS (
    SELECT
        le.student_id,
        car.academic_program_id,
        CASE
            WHEN ps.student_id IS NOT NULL
            THEN 1
            ELSE 0
        END AS placed_flag
    FROM latest_eligibility le
    INNER JOIN current_academic_record car
        ON car.student_id = le.student_id
       AND car.academic_rank = 1
    LEFT JOIN placed_students ps
        ON ps.student_id = le.student_id
    WHERE le.evaluation_rank = 1
      AND le.eligibility_status = 'eligible'
),
institution_rate AS (
    SELECT
        100.0
        * SUM(placed_flag)
        / NULLIF(COUNT(*), 0)
            AS institution_placement_rate_pct
    FROM eligible_population
),
program_rates AS (
    SELECT
        ep.academic_program_id,
        COUNT(*) AS eligible_student_count,
        SUM(ep.placed_flag) AS placed_student_count,
        100.0
        * SUM(ep.placed_flag)
        / NULLIF(COUNT(*), 0)
            AS program_placement_rate_pct
    FROM eligible_population ep
    GROUP BY ep.academic_program_id
)
SELECT
    pr.academic_program_id,
    ap.program_name,
    ap.department_name,
    pr.eligible_student_count,
    CASE
        WHEN pr.eligible_student_count <
             :minimum_group_size
        THEN NULL
        ELSE ROUND(
            pr.program_placement_rate_pct,
            2
        )
    END AS program_placement_rate_pct,
    CASE
        WHEN pr.eligible_student_count <
             :minimum_group_size
        THEN NULL
        ELSE ROUND(
            ir.institution_placement_rate_pct,
            2
        )
    END AS institution_placement_rate_pct,
    CASE
        WHEN pr.eligible_student_count <
             :minimum_group_size
        THEN NULL
        ELSE ROUND(
            pr.program_placement_rate_pct
            - ir.institution_placement_rate_pct,
            2
        )
    END AS placement_rate_difference_points,
    CASE
        WHEN pr.eligible_student_count <
             :minimum_group_size
        THEN 'suppressed_small_group'
        WHEN ABS(
            pr.program_placement_rate_pct
            - ir.institution_placement_rate_pct
        ) >= 15
        THEN 'review_recommended'
        ELSE 'within_initial_review_range'
    END AS review_status
FROM program_rates pr
INNER JOIN academic_program ap
    ON ap.academic_program_id =
       pr.academic_program_id
CROSS JOIN institution_rate ir
ORDER BY
    review_status DESC,
    placement_rate_difference_points ASC NULLS LAST;


/*
===============================================================================
QUERY 42
Audit Event Completeness
===============================================================================

Business question:

Do audit events contain the fields required to reconstruct important actions?
*/

SELECT
    COUNT(*) AS audit_event_count,
    COUNT(*) FILTER (
        WHERE audit_event_id IS NOT NULL
          AND actor_type IS NOT NULL
          AND actor_id IS NOT NULL
          AND event_type IS NOT NULL
          AND entity_type IS NOT NULL
          AND entity_id IS NOT NULL
          AND occurred_at IS NOT NULL
          AND event_reason IS NOT NULL
          AND LENGTH(TRIM(event_reason)) >= 5
    ) AS complete_audit_event_count,
    COUNT(*) FILTER (
        WHERE audit_event_id IS NULL
           OR actor_type IS NULL
           OR actor_id IS NULL
           OR event_type IS NULL
           OR entity_type IS NULL
           OR entity_id IS NULL
           OR occurred_at IS NULL
           OR event_reason IS NULL
           OR LENGTH(TRIM(event_reason)) < 5
    ) AS incomplete_audit_event_count,
    ROUND(
        100.0
        * COUNT(*) FILTER (
            WHERE audit_event_id IS NOT NULL
              AND actor_type IS NOT NULL
              AND actor_id IS NOT NULL
              AND event_type IS NOT NULL
              AND entity_type IS NOT NULL
              AND entity_id IS NOT NULL
              AND occurred_at IS NOT NULL
              AND event_reason IS NOT NULL
              AND LENGTH(TRIM(event_reason)) >= 5
        )
        / NULLIF(COUNT(*), 0),
        2
    ) AS audit_event_completeness_rate_pct
FROM audit_event
WHERE occurred_at >= (
    SELECT pc.application_start_at
    FROM placement_cycle pc
    WHERE pc.placement_cycle_id =
          :placement_cycle_id
)
  AND occurred_at <= COALESCE(
      :as_of_timestamp,
      CURRENT_TIMESTAMP
  );


/*
===============================================================================
QUERY 43
Placement Funnel Scorecard
===============================================================================

Business question:

How many students remain at each major stage of the placement process?
*/

WITH latest_eligibility AS (
    SELECT
        aee.student_id,
        aee.eligibility_status,
        ROW_NUMBER() OVER (
            PARTITION BY
                aee.student_id,
                aee.placement_cycle_id
            ORDER BY aee.evaluated_at DESC
        ) AS evaluation_rank
    FROM academic_eligibility_evaluation aee
    WHERE aee.placement_cycle_id = :placement_cycle_id
),
eligible_students AS (
    SELECT DISTINCT
        student_id
    FROM latest_eligibility
    WHERE evaluation_rank = 1
      AND eligibility_status = 'eligible'
),
students_with_application AS (
    SELECT DISTINCT
        a.student_id
    FROM application a
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = a.opportunity_id
    WHERE io.placement_cycle_id = :placement_cycle_id
      AND a.application_status <> 'draft'
),
students_with_recommendation AS (
    SELECT DISTINCT
        a.student_id
    FROM placement_recommendation pr
    INNER JOIN application a
        ON a.application_id = pr.application_id
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = a.opportunity_id
    WHERE io.placement_cycle_id = :placement_cycle_id
),
students_with_approved_recommendation AS (
    SELECT DISTINCT
        a.student_id
    FROM placement_decision pd
    INNER JOIN placement_recommendation pr
        ON pr.recommendation_id =
           pd.recommendation_id
    INNER JOIN application a
        ON a.application_id = pr.application_id
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = a.opportunity_id
    WHERE io.placement_cycle_id = :placement_cycle_id
      AND pd.decision_status IN (
          'approved',
          'overridden'
      )
),
students_with_offer AS (
    SELECT DISTINCT
        po.student_id
    FROM placement_offer po
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = po.opportunity_id
    WHERE io.placement_cycle_id = :placement_cycle_id
),
students_with_placement AS (
    SELECT DISTINCT
        p.student_id
    FROM placement p
    WHERE p.placement_cycle_id = :placement_cycle_id
      AND p.placement_status IN (
          'confirmed',
          'active',
          'completed'
      )
),
students_with_successful_outcome AS (
    SELECT DISTINCT
        p.student_id
    FROM internship_outcome io2
    INNER JOIN placement p
        ON p.placement_id = io2.placement_id
    WHERE p.placement_cycle_id = :placement_cycle_id
      AND io2.outcome_status =
          'successfully_completed'
)
SELECT
    stage_order,
    stage_name,
    student_count
FROM (
    SELECT
        1 AS stage_order,
        'Eligible Students' AS stage_name,
        COUNT(*) AS student_count
    FROM eligible_students

    UNION ALL

    SELECT
        2,
        'Students With Application',
        COUNT(*)
    FROM students_with_application

    UNION ALL

    SELECT
        3,
        'Students With Recommendation',
        COUNT(*)
    FROM students_with_recommendation

    UNION ALL

    SELECT
        4,
        'Students With Approved Recommendation',
        COUNT(*)
    FROM students_with_approved_recommendation

    UNION ALL

    SELECT
        5,
        'Students With Offer',
        COUNT(*)
    FROM students_with_offer

    UNION ALL

    SELECT
        6,
        'Students With Confirmed Placement',
        COUNT(*)
    FROM students_with_placement

    UNION ALL

    SELECT
        7,
        'Students With Successful Outcome',
        COUNT(*)
    FROM students_with_successful_outcome
) funnel
ORDER BY stage_order;


/*
===============================================================================
QUERY 44
Executive Placement Cycle Scorecard
===============================================================================

Business question:

What are the main placement-cycle KPIs in one management-level result row?
*/

WITH latest_eligibility AS (
    SELECT
        aee.student_id,
        aee.eligibility_status,
        aee.data_quality_status,
        ROW_NUMBER() OVER (
            PARTITION BY
                aee.student_id,
                aee.placement_cycle_id
            ORDER BY aee.evaluated_at DESC
        ) AS evaluation_rank
    FROM academic_eligibility_evaluation aee
    WHERE aee.placement_cycle_id = :placement_cycle_id
),
eligible_students AS (
    SELECT DISTINCT
        student_id
    FROM latest_eligibility
    WHERE evaluation_rank = 1
      AND eligibility_status = 'eligible'
),
incomplete_eligibility AS (
    SELECT DISTINCT
        student_id
    FROM latest_eligibility
    WHERE evaluation_rank = 1
      AND eligibility_status = 'data_incomplete'
),
application_students AS (
    SELECT DISTINCT
        a.student_id
    FROM application a
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = a.opportunity_id
    WHERE io.placement_cycle_id = :placement_cycle_id
      AND a.application_status <> 'draft'
),
recommendation_students AS (
    SELECT DISTINCT
        a.student_id
    FROM placement_recommendation pr
    INNER JOIN application a
        ON a.application_id = pr.application_id
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = a.opportunity_id
    WHERE io.placement_cycle_id = :placement_cycle_id
),
placement_students AS (
    SELECT DISTINCT
        p.student_id
    FROM placement p
    WHERE p.placement_cycle_id = :placement_cycle_id
      AND p.placement_status IN (
          'confirmed',
          'active',
          'completed'
      )
),
opportunity_supply AS (
    SELECT
        COUNT(DISTINCT io.opportunity_id)
            AS active_opportunity_count,
        COALESCE(SUM(io.total_capacity), 0)
            AS total_capacity
    FROM internship_opportunity io
    INNER JOIN employer e
        ON e.employer_id = io.employer_id
    WHERE io.placement_cycle_id = :placement_cycle_id
      AND io.opportunity_status = 'active'
      AND e.employer_status = 'active'
),
offer_metrics AS (
    SELECT
        COUNT(*) AS total_offer_count,
        COUNT(*) FILTER (
            WHERE po.student_response_status =
                  'accepted'
        ) AS student_accepted_offer_count,
        COUNT(*) FILTER (
            WHERE po.student_response_status IN (
                'accepted',
                'declined',
                'rejected'
            )
        ) AS decided_offer_count
    FROM placement_offer po
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = po.opportunity_id
    WHERE io.placement_cycle_id = :placement_cycle_id
),
override_metrics AS (
    SELECT
        COUNT(DISTINCT pd.placement_decision_id)
            AS completed_decision_count,
        COUNT(DISTINCT mo.manual_override_id)
            AS override_count
    FROM placement_decision pd
    INNER JOIN placement_recommendation pr
        ON pr.recommendation_id =
           pd.recommendation_id
    INNER JOIN application a
        ON a.application_id = pr.application_id
    INNER JOIN internship_opportunity io
        ON io.opportunity_id = a.opportunity_id
    LEFT JOIN manual_override mo
        ON mo.placement_decision_id =
           pd.placement_decision_id
    WHERE io.placement_cycle_id = :placement_cycle_id
      AND pd.decision_status IN (
          'approved',
          'rejected',
          'overridden'
      )
),
outcome_metrics AS (
    SELECT
        COUNT(*) FILTER (
            WHERE io2.outcome_status <>
                  'under_review'
        ) AS final_outcome_count,
        COUNT(*) FILTER (
            WHERE io2.outcome_status =
                  'successfully_completed'
        ) AS successful_outcome_count
    FROM internship_outcome io2
    INNER JOIN placement p
        ON p.placement_id = io2.placement_id
    WHERE p.placement_cycle_id = :placement_cycle_id
)
SELECT
    :placement_cycle_id AS placement_cycle_id,
    (
        SELECT COUNT(*)
        FROM eligible_students
    ) AS eligible_student_count,
    (
        SELECT COUNT(*)
        FROM incomplete_eligibility
    ) AS eligibility_data_incomplete_count,
    (
        SELECT COUNT(*)
        FROM application_students
    ) AS students_with_application,
    (
        SELECT COUNT(*)
        FROM recommendation_students
    ) AS students_with_recommendation,
    (
        SELECT COUNT(*)
        FROM placement_students
    ) AS students_with_confirmed_placement,
    os.active_opportunity_count,
    os.total_capacity,
    ROUND(
        100.0
        * (
            SELECT COUNT(*)
            FROM application_students
        )
        / NULLIF(
            (
                SELECT COUNT(*)
                FROM eligible_students
            ),
            0
        ),
        2
    ) AS application_submission_rate_pct,
    ROUND(
        100.0
        * (
            SELECT COUNT(*)
            FROM recommendation_students
        )
        / NULLIF(
            (
                SELECT COUNT(*)
                FROM eligible_students
            ),
            0
        ),
        2
    ) AS recommendation_generation_rate_pct,
    ROUND(
        100.0
        * (
            SELECT COUNT(*)
            FROM placement_students
        )
        / NULLIF(
            (
                SELECT COUNT(*)
                FROM eligible_students
            ),
            0
        ),
        2
    ) AS student_placement_rate_pct,
    ROUND(
        100.0
        * (
            (
                SELECT COUNT(*)
                FROM eligible_students
            )
            -
            (
                SELECT COUNT(*)
                FROM recommendation_students
            )
        )
        / NULLIF(
            (
                SELECT COUNT(*)
                FROM eligible_students
            ),
            0
        ),
        2
    ) AS students_without_recommendation_rate_pct,
    ROUND(
        100.0
        * om.student_accepted_offer_count
        / NULLIF(om.decided_offer_count, 0),
        2
    ) AS student_offer_acceptance_rate_pct,
    ROUND(
        100.0
        * (
            SELECT COUNT(*)
            FROM placement_students
        )
        / NULLIF(os.total_capacity, 0),
        2
    ) AS capacity_utilization_rate_pct,
    ROUND(
        100.0
        * ov.override_count
        / NULLIF(
            ov.completed_decision_count,
            0
        ),
        2
    ) AS manual_override_rate_pct,
    ROUND(
        100.0
        * outm.successful_outcome_count
        / NULLIF(outm.final_outcome_count, 0),
        2
    ) AS successful_completion_rate_pct,
    COALESCE(
        :as_of_timestamp,
        CURRENT_TIMESTAMP
    ) AS calculated_at
FROM opportunity_supply os
CROSS JOIN offer_metrics om
CROSS JOIN override_metrics ov
CROSS JOIN outcome_metrics outm;


/*
===============================================================================
ANALYTICAL IMPLEMENTATION NOTES
===============================================================================

Recommended Production Improvements
-----------------------------------

A physical implementation should consider adding the following analytical
structures:

1. placement_cycle_student

   Provides the official target-student population for each placement cycle.

2. application_submission_attempt

   Records successful and failed application-submission attempts so that
   application validation failure rates can be calculated accurately.

3. preference_rank

   Adds explicit ordering to student opportunity preferences and enables exact
   first-preference recommendation and placement KPIs.

4. notification_event

   Enables notification delivery and response analysis.

5. integration_event

   Enables monitoring of student-information, identity, document and
   notification integrations.

6. employer_candidate_decision

   Separates employer candidate-review decisions from placement-offer
   decisions when employers evaluate students before an offer is created.

7. daily_kpi_snapshot

   Preserves approved daily KPI values and definition versions.

Recommended Indexes
-------------------

Production indexes may include:

    academic_eligibility_evaluation (
        placement_cycle_id,
        student_id,
        evaluated_at DESC
    )

    internship_opportunity (
        placement_cycle_id,
        opportunity_status,
        employer_id
    )

    application (
        student_id,
        opportunity_id,
        application_status
    )

    requirement_evaluation (
        application_id,
        opportunity_requirement_id
    )

    match_evaluation (
        application_id,
        model_version,
        evaluated_at DESC
    )

    placement_recommendation (
        application_id,
        recommendation_status,
        generated_at
    )

    placement_decision (
        recommendation_id,
        decision_version DESC
    )

    placement_offer (
        opportunity_id,
        student_id,
        offer_status,
        offer_expires_at
    )

    capacity_reservation (
        opportunity_id,
        reservation_status,
        expires_at
    )

    placement (
        placement_cycle_id,
        student_id,
        opportunity_id,
        placement_status
    )

    intervention_case (
        placement_cycle_id,
        priority,
        intervention_status,
        deadline
    )

Recommended Governance Controls
-------------------------------

- Store the KPI definition version with every materialized KPI result.
- Store the matching-model version with recommendation reports.
- Preserve the source extraction timestamp.
- Apply minimum-group suppression before presenting fairness results.
- Restrict identifiable student-level queries to authorized operational roles.
- Do not expose confidential employer notes in analytical views.
- Reconcile total capacity, active reservations and confirmed placements.
- Treat recommendation and placement results as separate measures.
- Preserve historical records rather than silently recalculating them.
- Validate all percentages using both counts and denominators.
- Review missing or stale data before interpreting KPI differences.

End of analytical SQL library.
===============================================================================
*/
