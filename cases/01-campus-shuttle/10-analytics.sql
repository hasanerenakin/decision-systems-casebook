/*
Campus Shuttle Decision System
Operational Analytics Queries

SQL dialect: PostgreSQL-compatible analytical SQL

Expected parameters:
    :start_date
    :end_date

The queries use the conceptual entities defined in 07-data-model.md.
*/


/* ================================================================
   QUERY 01 — ROUTE PERFORMANCE SUMMARY

   Calculates completed trips, utilization, overcrowding,
   punctuality and average delay for each route.
   ================================================================ */

WITH passenger_counts AS (
    SELECT
        po.trip_id,
        MAX(po.passenger_count) AS maximum_passenger_count,
        AVG(po.confidence_score) AS average_confidence_score
    FROM passenger_observation AS po
    GROUP BY
        po.trip_id
),

trip_metrics AS (
    SELECT
        t.trip_id,
        t.route_id,
        t.vehicle_id,
        t.service_date,
        t.trip_status,
        v.usable_capacity,
        pc.maximum_passenger_count,
        pc.average_confidence_score,

        ROUND(
            100.0 * pc.maximum_passenger_count
            / NULLIF(v.usable_capacity, 0),
            2
        ) AS utilization_rate,

        GREATEST(
            EXTRACT(
                EPOCH FROM (
                    t.actual_arrival_at - t.planned_arrival_at
                )
            ) / 60.0,
            0
        ) AS arrival_delay_minutes

    FROM trip AS t

    INNER JOIN vehicle AS v
        ON v.vehicle_id = t.vehicle_id

    LEFT JOIN passenger_counts AS pc
        ON pc.trip_id = t.trip_id

    WHERE
        t.service_date BETWEEN :start_date AND :end_date
)

SELECT
    r.route_id,
    r.route_name,

    COUNT(tm.trip_id) AS scheduled_trip_count,

    COUNT(tm.trip_id) FILTER (
        WHERE tm.trip_status = 'completed'
    ) AS completed_trip_count,

    COUNT(tm.trip_id) FILTER (
        WHERE tm.trip_status = 'cancelled'
    ) AS cancelled_trip_count,

    ROUND(
        100.0
        * COUNT(tm.trip_id) FILTER (
            WHERE tm.trip_status = 'completed'
        )
        / NULLIF(COUNT(tm.trip_id), 0),
        2
    ) AS trip_completion_rate,

    ROUND(
        AVG(tm.utilization_rate) FILTER (
            WHERE tm.trip_status = 'completed'
              AND tm.utilization_rate IS NOT NULL
        ),
        2
    ) AS average_utilization_rate,

    ROUND(
        MAX(tm.utilization_rate) FILTER (
            WHERE tm.trip_status = 'completed'
        ),
        2
    ) AS peak_utilization_rate,

    COUNT(tm.trip_id) FILTER (
        WHERE tm.trip_status = 'completed'
          AND tm.utilization_rate > 95
    ) AS overcrowded_trip_count,

    ROUND(
        100.0
        * COUNT(tm.trip_id) FILTER (
            WHERE tm.trip_status = 'completed'
              AND tm.utilization_rate > 95
        )
        / NULLIF(
            COUNT(tm.trip_id) FILTER (
                WHERE tm.trip_status = 'completed'
                  AND tm.utilization_rate IS NOT NULL
            ),
            0
        ),
        2
    ) AS overcrowded_trip_rate,

    ROUND(
        AVG(tm.arrival_delay_minutes) FILTER (
            WHERE tm.trip_status = 'completed'
              AND tm.arrival_delay_minutes > 0
        ),
        2
    ) AS average_arrival_delay_minutes,

    ROUND(
        100.0
        * COUNT(tm.trip_id) FILTER (
            WHERE tm.trip_status = 'completed'
              AND tm.arrival_delay_minutes <= 10
        )
        / NULLIF(
            COUNT(tm.trip_id) FILTER (
                WHERE tm.trip_status = 'completed'
                  AND tm.arrival_delay_minutes IS NOT NULL
            ),
            0
        ),
        2
    ) AS on_time_performance_rate

FROM route AS r

LEFT JOIN trip_metrics AS tm
    ON tm.route_id = r.route_id

WHERE
    r.route_status = 'active'

GROUP BY
    r.route_id,
    r.route_name

ORDER BY
    overcrowded_trip_rate DESC NULLS LAST,
    average_arrival_delay_minutes DESC NULLS LAST;


/* ================================================================
   QUERY 02 — PEAK-HOUR CAPACITY ANALYSIS

   Identifies the routes and hourly time slots with the highest
   average and maximum utilization.
   ================================================================ */

WITH trip_capacity AS (
    SELECT
        t.trip_id,
        t.route_id,
        DATE_TRUNC(
            'hour',
            t.planned_departure_at
        )::time AS departure_hour,

        v.usable_capacity,
        MAX(po.passenger_count) AS maximum_passenger_count

    FROM trip AS t

    INNER JOIN vehicle AS v
        ON v.vehicle_id = t.vehicle_id

    INNER JOIN passenger_observation AS po
        ON po.trip_id = t.trip_id

    WHERE
        t.trip_status = 'completed'
        AND t.service_date BETWEEN :start_date AND :end_date

    GROUP BY
        t.trip_id,
        t.route_id,
        DATE_TRUNC('hour', t.planned_departure_at)::time,
        v.usable_capacity
),

utilization AS (
    SELECT
        trip_id,
        route_id,
        departure_hour,

        ROUND(
            100.0 * maximum_passenger_count
            / NULLIF(usable_capacity, 0),
            2
        ) AS utilization_rate

    FROM trip_capacity
)

SELECT
    r.route_id,
    r.route_name,
    u.departure_hour,

    COUNT(*) AS completed_trip_count,

    ROUND(
        AVG(u.utilization_rate),
        2
    ) AS average_utilization_rate,

    ROUND(
        MAX(u.utilization_rate),
        2
    ) AS maximum_utilization_rate,

    COUNT(*) FILTER (
        WHERE u.utilization_rate > 95
    ) AS overcrowded_trip_count,

    ROUND(
        100.0
        * COUNT(*) FILTER (
            WHERE u.utilization_rate > 95
        )
        / NULLIF(COUNT(*), 0),
        2
    ) AS overcrowded_trip_rate

FROM utilization AS u

INNER JOIN route AS r
    ON r.route_id = u.route_id

GROUP BY
    r.route_id,
    r.route_name,
    u.departure_hour

HAVING
    COUNT(*) >= 3

ORDER BY
    average_utilization_rate DESC,
    overcrowded_trip_rate DESC;


/* ================================================================
   QUERY 03 — RECURRING DELAY DETECTION

   Detects route and time-slot combinations where more than
   20 percent of comparable trips arrived over 10 minutes late.
   ================================================================ */

WITH comparable_trips AS (
    SELECT
        t.trip_id,
        t.route_id,

        DATE_TRUNC(
            'hour',
            t.planned_departure_at
        )::time AS departure_hour,

        CASE
            WHEN EXTRACT(ISODOW FROM t.service_date) IN (6, 7)
                THEN 'weekend'
            ELSE 'weekday'
        END AS operating_day_category,

        GREATEST(
            EXTRACT(
                EPOCH FROM (
                    t.actual_arrival_at - t.planned_arrival_at
                )
            ) / 60.0,
            0
        ) AS arrival_delay_minutes

    FROM trip AS t

    WHERE
        t.trip_status = 'completed'
        AND t.actual_arrival_at IS NOT NULL
        AND t.planned_arrival_at IS NOT NULL
        AND t.service_date BETWEEN :start_date AND :end_date
)

SELECT
    r.route_id,
    r.route_name,
    ct.departure_hour,
    ct.operating_day_category,

    COUNT(*) AS comparable_trip_count,

    COUNT(*) FILTER (
        WHERE ct.arrival_delay_minutes > 10
    ) AS significantly_delayed_trip_count,

    ROUND(
        AVG(ct.arrival_delay_minutes),
        2
    ) AS average_delay_minutes,

    ROUND(
        100.0
        * COUNT(*) FILTER (
            WHERE ct.arrival_delay_minutes > 10
        )
        / NULLIF(COUNT(*), 0),
        2
    ) AS recurring_delay_rate

FROM comparable_trips AS ct

INNER JOIN route AS r
    ON r.route_id = ct.route_id

GROUP BY
    r.route_id,
    r.route_name,
    ct.departure_hour,
    ct.operating_day_category

HAVING
    COUNT(*) >= 3

    AND 100.0
        * COUNT(*) FILTER (
            WHERE ct.arrival_delay_minutes > 10
        )
        / NULLIF(COUNT(*), 0) > 20

ORDER BY
    recurring_delay_rate DESC,
    average_delay_minutes DESC;


/* ================================================================
   QUERY 04 — LOW-UTILIZATION SERVICE DETECTION

   Finds routes and time slots that repeatedly operate below
   30 percent capacity.
   ================================================================ */

WITH trip_utilization AS (
    SELECT
        t.trip_id,
        t.route_id,

        DATE_TRUNC(
            'hour',
            t.planned_departure_at
        )::time AS departure_hour,

        t.service_date,
        v.usable_capacity,
        MAX(po.passenger_count) AS maximum_passenger_count,

        ROUND(
            100.0 * MAX(po.passenger_count)
            / NULLIF(v.usable_capacity, 0),
            2
        ) AS utilization_rate

    FROM trip AS t

    INNER JOIN vehicle AS v
        ON v.vehicle_id = t.vehicle_id

    INNER JOIN passenger_observation AS po
        ON po.trip_id = t.trip_id

    WHERE
        t.trip_status = 'completed'
        AND t.service_date BETWEEN :start_date AND :end_date

    GROUP BY
        t.trip_id,
        t.route_id,
        DATE_TRUNC('hour', t.planned_departure_at)::time,
        t.service_date,
        v.usable_capacity
)

SELECT
    r.route_id,
    r.route_name,
    tu.departure_hour,

    COUNT(*) AS completed_trip_count,

    COUNT(*) FILTER (
        WHERE tu.utilization_rate < 30
    ) AS low_utilization_trip_count,

    ROUND(
        AVG(tu.utilization_rate),
        2
    ) AS average_utilization_rate,

    ROUND(
        100.0
        * COUNT(*) FILTER (
            WHERE tu.utilization_rate < 30
        )
        / NULLIF(COUNT(*), 0),
        2
    ) AS low_utilization_trip_rate

FROM trip_utilization AS tu

INNER JOIN route AS r
    ON r.route_id = tu.route_id

GROUP BY
    r.route_id,
    r.route_name,
    tu.departure_hour

HAVING
    COUNT(DISTINCT tu.service_date) >= 5

    AND 100.0
        * COUNT(*) FILTER (
            WHERE tu.utilization_rate < 30
        )
        / NULLIF(COUNT(*), 0) > 25

ORDER BY
    low_utilization_trip_rate DESC,
    average_utilization_rate ASC;


/* ================================================================
   QUERY 05 — DELAY REASON ANALYSIS

   Shows the most frequent and operationally costly delay causes.
   ================================================================ */

SELECT
    de.delay_reason,

    COUNT(*) AS delay_event_count,

    COUNT(DISTINCT de.trip_id) AS affected_trip_count,

    ROUND(
        AVG(de.delay_minutes),
        2
    ) AS average_delay_minutes,

    MAX(de.delay_minutes) AS maximum_delay_minutes,

    SUM(de.delay_minutes) AS total_delay_minutes

FROM delay_event AS de

INNER JOIN trip AS t
    ON t.trip_id = de.trip_id

WHERE
    t.service_date BETWEEN :start_date AND :end_date
    AND de.delay_minutes > 0

GROUP BY
    de.delay_reason

ORDER BY
    total_delay_minutes DESC,
    delay_event_count DESC;


/* ================================================================
   QUERY 06 — COMPLAINT RATE BY ROUTE

   Compares passenger complaints with completed trip volume.
   ================================================================ */

WITH completed_trip_counts AS (
    SELECT
        route_id,
        COUNT(*) AS completed_trip_count
    FROM trip
    WHERE
        trip_status = 'completed'
        AND service_date BETWEEN :start_date AND :end_date
    GROUP BY
        route_id
),

feedback_counts AS (
    SELECT
        route_id,
        COUNT(*) AS feedback_count,

        COUNT(*) FILTER (
            WHERE feedback_category = 'delay'
        ) AS delay_feedback_count,

        COUNT(*) FILTER (
            WHERE feedback_category = 'overcrowding'
        ) AS overcrowding_feedback_count,

        COUNT(*) FILTER (
            WHERE feedback_category = 'safety'
        ) AS safety_feedback_count,

        COUNT(*) FILTER (
            WHERE feedback_category = 'accessibility'
        ) AS accessibility_feedback_count

    FROM student_feedback

    WHERE
        submitted_at::date BETWEEN :start_date AND :end_date

    GROUP BY
        route_id
)

SELECT
    r.route_id,
    r.route_name,

    COALESCE(ctc.completed_trip_count, 0) AS completed_trip_count,
    COALESCE(fc.feedback_count, 0) AS feedback_count,
    COALESCE(fc.delay_feedback_count, 0) AS delay_feedback_count,

    COALESCE(
        fc.overcrowding_feedback_count,
        0
    ) AS overcrowding_feedback_count,

    COALESCE(fc.safety_feedback_count, 0) AS safety_feedback_count,

    COALESCE(
        fc.accessibility_feedback_count,
        0
    ) AS accessibility_feedback_count,

    ROUND(
        100.0 * COALESCE(fc.feedback_count, 0)
        / NULLIF(ctc.completed_trip_count, 0),
        2
    ) AS complaints_per_100_completed_trips

FROM route AS r

LEFT JOIN completed_trip_counts AS ctc
    ON ctc.route_id = r.route_id

LEFT JOIN feedback_counts AS fc
    ON fc.route_id = r.route_id

WHERE
    r.route_status = 'active'

ORDER BY
    complaints_per_100_completed_trips DESC NULLS LAST;


/* ================================================================
   QUERY 07 — PENDING RECOMMENDATIONS WITH EVIDENCE

   Provides decision-makers with pending recommendations and the
   evidence supporting each recommendation.
   ================================================================ */

SELECT
    rec.recommendation_id,
    rec.route_id,
    r.route_name,
    rec.recommendation_type,
    rec.target_time_slot,
    rec.triggering_rule,
    rec.confidence_level,
    rec.expected_effect,
    rec.generated_at,

    COUNT(re.evidence_id) AS evidence_record_count,

    STRING_AGG(
        DISTINCT re.metric_name,
        ', '
        ORDER BY re.metric_name
    ) AS supporting_metrics,

    MAX(
        re.metric_value - re.threshold_value
    ) AS maximum_threshold_difference,

    CURRENT_TIMESTAMP - rec.generated_at AS waiting_for_review_duration

FROM recommendation AS rec

INNER JOIN route AS r
    ON r.route_id = rec.route_id

LEFT JOIN recommendation_evidence AS re
    ON re.recommendation_id = rec.recommendation_id

WHERE
    rec.recommendation_status = 'pending'

GROUP BY
    rec.recommendation_id,
    rec.route_id,
    r.route_name,
    rec.recommendation_type,
    rec.target_time_slot,
    rec.triggering_rule,
    rec.confidence_level,
    rec.expected_effect,
    rec.generated_at

ORDER BY
    rec.confidence_level DESC,
    rec.generated_at ASC;


/* ================================================================
   QUERY 08 — RECOMMENDATION REVIEW PERFORMANCE

   Measures approval rate and average management response time.
   ================================================================ */

SELECT
    rec.recommendation_type,

    COUNT(*) AS reviewed_recommendation_count,

    COUNT(*) FILTER (
        WHERE rd.decision_status = 'approved'
    ) AS approved_recommendation_count,

    COUNT(*) FILTER (
        WHERE rd.decision_status = 'rejected'
    ) AS rejected_recommendation_count,

    ROUND(
        100.0
        * COUNT(*) FILTER (
            WHERE rd.decision_status = 'approved'
        )
        / NULLIF(COUNT(*), 0),
        2
    ) AS recommendation_approval_rate,

    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    rd.decided_at - rec.generated_at
                )
            ) / 3600.0
        ),
        2
    ) AS average_response_time_hours

FROM recommendation AS rec

INNER JOIN recommendation_decision AS rd
    ON rd.recommendation_id = rec.recommendation_id

WHERE
    rec.generated_at::date BETWEEN :start_date AND :end_date

GROUP BY
    rec.recommendation_type

ORDER BY
    reviewed_recommendation_count DESC;


/* ================================================================
   QUERY 09 — BEFORE-AND-AFTER RECOMMENDATION ANALYSIS

   Compares route overcrowding during the 28 days before and after
   an approved recommendation was implemented.
   ================================================================ */

WITH approved_recommendations AS (
    SELECT
        rec.recommendation_id,
        rec.route_id,
        rec.recommendation_type,
        rd.implementation_date

    FROM recommendation AS rec

    INNER JOIN recommendation_decision AS rd
        ON rd.recommendation_id = rec.recommendation_id

    WHERE
        rd.decision_status = 'approved'
        AND rd.implementation_date IS NOT NULL
),

trip_utilization AS (
    SELECT
        t.trip_id,
        t.route_id,
        t.service_date,

        ROUND(
            100.0 * MAX(po.passenger_count)
            / NULLIF(v.usable_capacity, 0),
            2
        ) AS utilization_rate

    FROM trip AS t

    INNER JOIN vehicle AS v
        ON v.vehicle_id = t.vehicle_id

    INNER JOIN passenger_observation AS po
        ON po.trip_id = t.trip_id

    WHERE
        t.trip_status = 'completed'

    GROUP BY
        t.trip_id,
        t.route_id,
        t.service_date,
        v.usable_capacity
),

comparison AS (
    SELECT
        ar.recommendation_id,
        ar.route_id,
        ar.recommendation_type,
        ar.implementation_date,
        tu.trip_id,
        tu.utilization_rate,

        CASE
            WHEN tu.service_date >= ar.implementation_date - INTERVAL '28 days'
             AND tu.service_date < ar.implementation_date
                THEN 'before'

            WHEN tu.service_date >= ar.implementation_date
             AND tu.service_date < ar.implementation_date + INTERVAL '28 days'
                THEN 'after'
        END AS comparison_period

    FROM approved_recommendations AS ar

    INNER JOIN trip_utilization AS tu
        ON tu.route_id = ar.route_id

       AND tu.service_date >= ar.implementation_date - INTERVAL '28 days'
       AND tu.service_date < ar.implementation_date + INTERVAL '28 days'
),

period_metrics AS (
    SELECT
        recommendation_id,
        route_id,
        recommendation_type,
        implementation_date,
        comparison_period,

        COUNT(*) AS completed_trip_count,

        ROUND(
            AVG(utilization_rate),
            2
        ) AS average_utilization_rate,

        ROUND(
            100.0
            * COUNT(*) FILTER (
                WHERE utilization_rate > 95
            )
            / NULLIF(COUNT(*), 0),
            2
        ) AS overcrowded_trip_rate

    FROM comparison

    WHERE
        comparison_period IS NOT NULL

    GROUP BY
        recommendation_id,
        route_id,
        recommendation_type,
        implementation_date,
        comparison_period
)

SELECT
    pm_before.recommendation_id,
    pm_before.route_id,
    r.route_name,
    pm_before.recommendation_type,
    pm_before.implementation_date,

    pm_before.completed_trip_count AS before_trip_count,
    pm_after.completed_trip_count AS after_trip_count,

    pm_before.average_utilization_rate AS before_average_utilization,
    pm_after.average_utilization_rate AS after_average_utilization,

    pm_before.overcrowded_trip_rate AS before_overcrowded_trip_rate,
    pm_after.overcrowded_trip_rate AS after_overcrowded_trip_rate,

    ROUND(
        pm_before.overcrowded_trip_rate
        - pm_after.overcrowded_trip_rate,
        2
    ) AS overcrowding_rate_improvement,

    CASE
        WHEN pm_after.overcrowded_trip_rate
             < pm_before.overcrowded_trip_rate
            THEN 'improved'

        WHEN pm_after.overcrowded_trip_rate
             = pm_before.overcrowded_trip_rate
            THEN 'unchanged'

        ELSE 'worsened'
    END AS evaluation_result

FROM period_metrics AS pm_before

INNER JOIN period_metrics AS pm_after
    ON pm_after.recommendation_id = pm_before.recommendation_id
   AND pm_after.comparison_period = 'after'

INNER JOIN route AS r
    ON r.route_id = pm_before.route_id

WHERE
    pm_before.comparison_period = 'before'

ORDER BY
    overcrowding_rate_improvement DESC;


/* ================================================================
   QUERY 10 — DATA QUALITY COVERAGE

   Identifies missing or unreliable operational records that may
   affect KPI calculations and recommendation quality.
   ================================================================ */

WITH trip_quality AS (
    SELECT
        t.trip_id,
        t.route_id,
        t.service_date,

        CASE
            WHEN t.vehicle_id IS NULL THEN 1
            ELSE 0
        END AS missing_vehicle_flag,

        CASE
            WHEN t.planned_arrival_at IS NULL
              OR t.actual_arrival_at IS NULL
                THEN 1
            ELSE 0
        END AS missing_timing_flag,

        CASE
            WHEN COUNT(po.observation_id) = 0 THEN 1
            ELSE 0
        END AS missing_passenger_observation_flag,

        CASE
            WHEN AVG(po.confidence_score) < 0.70 THEN 1
            ELSE 0
        END AS low_confidence_observation_flag

    FROM trip AS t

    LEFT JOIN passenger_observation AS po
        ON po.trip_id = t.trip_id

    WHERE
        t.trip_status = 'completed'
        AND t.service_date BETWEEN :start_date AND :end_date

    GROUP BY
        t.trip_id,
        t.route_id,
        t.service_date,
        t.vehicle_id,
        t.planned_arrival_at,
        t.actual_arrival_at
)

SELECT
    r.route_id,
    r.route_name,

    COUNT(*) AS completed_trip_count,

    SUM(tq.missing_vehicle_flag) AS missing_vehicle_count,

    SUM(tq.missing_timing_flag) AS missing_timing_count,

    SUM(
        tq.missing_passenger_observation_flag
    ) AS missing_passenger_observation_count,

    SUM(
        tq.low_confidence_observation_flag
    ) AS low_confidence_observation_count,

    ROUND(
        100.0
        * COUNT(*) FILTER (
            WHERE tq.missing_vehicle_flag = 0
              AND tq.missing_timing_flag = 0
              AND tq.missing_passenger_observation_flag = 0
              AND tq.low_confidence_observation_flag = 0
        )
        / NULLIF(COUNT(*), 0),
        2
    ) AS reliable_data_coverage_rate

FROM trip_quality AS tq

INNER JOIN route AS r
    ON r.route_id = tq.route_id

GROUP BY
    r.route_id,
    r.route_name

ORDER BY
    reliable_data_coverage_rate ASC;
