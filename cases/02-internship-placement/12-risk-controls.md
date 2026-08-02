# Risk and Control Framework

## Case

Internship Placement and Matching System

## Domain

University Career Services and Internship Operations

## Document Purpose

This document identifies the major risks associated with the Internship
Placement and Matching System and defines the controls required to reduce those
risks.

The framework covers:

- Academic eligibility
- Employer management
- Internship opportunity approval
- Student applications
- Matching and recommendation logic
- Human review
- Manual overrides
- Capacity management
- Placement offers
- Final placement confirmation
- Internship outcomes
- Personal-data protection
- Information security
- Fairness and access
- Data quality
- Integrations
- Operational continuity
- Reporting and auditability

The system is intended to support decisions rather than replace accountable
human decision-makers.

The control framework therefore emphasizes:

- Rule consistency
- Explainability
- Human authorization
- Segregation of duties
- Historical traceability
- Capacity integrity
- Privacy by purpose
- Fairness review
- Data-quality visibility
- Operational resilience

## Risk Management Objectives

The risk-management process should ensure that:

- Academically ineligible students are not incorrectly placed.
- Eligible students are not excluded because of incorrect data.
- Employer requirements are applied consistently.
- Opportunity capacity is not exceeded.
- Students do not receive conflicting confirmed placements.
- Recommendations remain advisory and explainable.
- Manual overrides are authorized and documented.
- Sensitive student information is protected.
- Employers access only permitted candidate information.
- System failures do not silently change placement outcomes.
- Students at risk of remaining unplaced are identified early.
- Historical decisions can be reconstructed.
- Management reports are based on reliable definitions.
- Fairness indicators are reviewed with appropriate context.

# Risk Assessment Method

## Likelihood Scale

| Score | Level | Description |
|---:|---|---|
| 1 | Rare | Unlikely to occur under normal conditions |
| 2 | Unlikely | May occur occasionally |
| 3 | Possible | Could occur during a placement cycle |
| 4 | Likely | Expected to occur without effective controls |
| 5 | Almost Certain | Expected to occur frequently |

## Impact Scale

| Score | Level | Description |
|---:|---|---|
| 1 | Insignificant | Minimal operational effect |
| 2 | Minor | Limited delay or correction effort |
| 3 | Moderate | Student, employer or department impact |
| 4 | Major | Significant academic, privacy or operational impact |
| 5 | Severe | Legal, safety, institutional or large-scale student impact |

## Risk Score

```text
Inherent Risk Score =
Likelihood × Impact
```

## Risk Rating

| Score | Rating | Expected Response |
|---:|---|---|
| 1–4 | Low | Accept and monitor |
| 5–9 | Moderate | Assign controls and periodic review |
| 10–15 | High | Formal mitigation and management monitoring |
| 16–25 | Critical | Immediate mitigation and senior oversight |

## Residual Risk

Residual risk is the remaining risk after approved controls operate.

Residual risk should be reassessed using:

- Control design
- Control implementation
- Control operating evidence
- Known incidents
- Control exceptions
- Data-quality results
- Audit findings

# Control Types

## Preventive Controls

Preventive controls reduce the probability of an incorrect or unauthorized
event.

Examples include:

- Required-field validation
- Eligibility rules
- Role-based access
- Capacity locking
- Segregation of duties
- Employer verification
- Status-transition restrictions

## Detective Controls

Detective controls identify an error or abnormal condition after or while it
occurs.

Examples include:

- Capacity reconciliation
- Duplicate-placement reports
- Override monitoring
- Access-log review
- Fairness alerts
- Data-quality dashboards
- Expired-offer checks

## Corrective Controls

Corrective controls restore the process after a failure or exception.

Examples include:

- Decision correction workflow
- Capacity release
- Placement cancellation
- Data correction
- Recommendation reevaluation
- Student intervention
- Account suspension

## Directive Controls

Directive controls define expected behavior.

Examples include:

- Placement policy
- Privacy notice
- Employer-data agreement
- Academic eligibility policy
- Reviewer guidance
- Incident-response procedure

# Risk Ownership

| Risk Area | Primary Owner | Supporting Roles |
|---|---|---|
| Academic eligibility | Academic unit | Career center, IT |
| Employer approval | Career-center manager | Legal, privacy |
| Opportunity quality | Career center | Academic unit |
| Matching model | Career-center governance | Academic, IT, privacy |
| Capacity integrity | Career center | IT |
| Manual overrides | Authorized business owner | Internal audit |
| Personal data | Privacy officer | IT, security |
| Information security | Information security team | IT, system owner |
| Fairness review | Governance committee | Academic and career-center roles |
| Data quality | Data owner | Source-system owner, IT |
| Integration reliability | IT | Business process owner |
| Operational continuity | System owner | IT and university administration |

# Summary Risk Register

| Risk ID | Risk | Likelihood | Impact | Inherent Rating | Primary Controls | Residual Target |
|---|---|---:|---:|---|---|---|
| RC-001 | Incorrect academic eligibility | 4 | 5 | Critical | Versioned rules, source validation, review workflow | Moderate |
| RC-002 | Eligible student excluded by incomplete data | 4 | 4 | Critical | Data-quality status, information request, reevaluation | Moderate |
| RC-003 | Unauthorized academic exception | 3 | 5 | High | Role control, secondary approval, audit log | Low |
| RC-004 | Unverified or unsafe employer activated | 3 | 5 | High | Employer verification, status workflow, suspension | Moderate |
| RC-005 | Invalid opportunity published | 4 | 4 | Critical | Required review, structured fields, version control | Moderate |
| RC-006 | Employer changes approved conditions | 3 | 4 | High | Material-change detection and reapproval | Moderate |
| RC-007 | Duplicate or invalid application | 4 | 3 | High | Uniqueness and submission validation | Low |
| RC-008 | Mandatory requirement applied incorrectly | 4 | 4 | Critical | Structured requirements, rule testing, explanations | Moderate |
| RC-009 | Unexplained recommendation | 3 | 4 | High | Indicator evidence and model versioning | Low |
| RC-010 | Excessive reliance on compatibility score | 4 | 5 | Critical | Human review and advisory labeling | Moderate |
| RC-011 | Recommendation concentration | 3 | 4 | High | Concentration monitoring and governance review | Moderate |
| RC-012 | Hidden or inappropriate matching factor | 3 | 5 | High | Approved feature registry and model governance | Low |
| RC-013 | Opportunity capacity exceeded | 4 | 5 | Critical | Atomic reservation and reconciliation | Low |
| RC-014 | Expired offer continues blocking capacity | 4 | 3 | High | Expiration job and exception report | Low |
| RC-015 | Conflicting confirmed placements | 3 | 5 | High | Date-overlap validation and uniqueness controls | Low |
| RC-016 | Unauthorized manual override | 3 | 5 | High | Permission checks and secondary approval | Low |
| RC-017 | Override reason is incomplete | 4 | 3 | High | Mandatory structured reason and review | Low |
| RC-018 | Employer receives excessive student data | 3 | 5 | High | Purpose-based views and field minimization | Moderate |
| RC-019 | Sensitive student information used in scoring | 2 | 5 | High | Prohibited-field controls and privacy review | Low |
| RC-020 | Unauthorized account access | 3 | 5 | High | Authentication, least privilege and monitoring | Moderate |
| RC-021 | Bulk student-data export | 3 | 5 | High | Export restriction and anomaly detection | Moderate |
| RC-022 | Integration provides stale or duplicate data | 4 | 4 | Critical | Idempotency, freshness checks and reconciliation | Moderate |
| RC-023 | Matching or eligibility service unavailable | 3 | 4 | High | Retry, queueing and continuity procedure | Moderate |
| RC-024 | Notification failure causes missed deadline | 4 | 4 | Critical | In-system tasks, delivery monitoring and reminders | Moderate |
| RC-025 | Student remains unplaced without intervention | 4 | 5 | Critical | No-recommendation detection and escalation | Moderate |
| RC-026 | Decision history is overwritten | 3 | 5 | High | Versioning and immutable audit events | Low |
| RC-027 | KPI report uses inconsistent definitions | 3 | 4 | High | KPI catalog and definition versioning | Low |
| RC-028 | Small-group report exposes individuals | 2 | 5 | High | Suppression and access control | Low |
| RC-029 | Incorrect internship outcome recorded | 3 | 3 | Moderate | Evidence validation and controlled correction | Low |
| RC-030 | Backup or recovery failure | 2 | 5 | High | Tested recovery and reconciliation | Moderate |

# Detailed Risks and Controls

## RC-001: Incorrect Academic Eligibility Decision

### Risk Description

The system may incorrectly classify a student as eligible or ineligible because
of:

- Incorrect rule configuration
- Outdated academic information
- Wrong department rule
- Invalid GPA or credit calculation
- Missing course information
- Incorrect rule effective date
- Unrecorded academic exception

### Potential Consequences

- Academically invalid placement
- Eligible student denied access
- Delayed graduation requirement
- Appeal and complaint
- Repeated manual correction
- Loss of stakeholder trust

### Preventive Controls

- Academic rules must be approved and versioned.
- Every rule must have an academic business owner.
- Rules must use effective start and end dates.
- Academic information must come from an authoritative source.
- Production activation must require rule test scenarios.
- Eligibility results must distinguish failure from missing data.
- Rule changes must be reviewed before activation.

### Detective Controls

- Eligibility-rate monitoring by department
- Failed-rule frequency report
- Data-incomplete eligibility report
- Comparison of academic exceptions and standard decisions
- Periodic sample review by academic coordinators

### Corrective Controls

- Controlled eligibility reevaluation
- Academic exception workflow
- Decision correction with preserved history
- Student notification and appeal support

### Evidence

- Rule approval record
- Rule version
- Eligibility rule results
- Academic source timestamp
- Academic reviewer decision
- Audit events

### Residual Risk Target

Moderate

---

## RC-002: Eligible Student Excluded Because of Missing or Stale Data

### Risk Description

A qualified student may be excluded when profile or academic information is:

- Missing
- Stale
- Conflicting
- Unverified
- Incorrectly mapped
- Unavailable because of integration failure

### Potential Consequences

- Lost opportunity
- Unequal process access
- Late intervention
- Student dissatisfaction
- Increased appeals

### Preventive Controls

- Missing data must not be treated as confirmed failure by default.
- Critical data receives a quality status.
- Academic-data freshness thresholds must be defined.
- Students can report incorrect information.
- Source-system timestamps must be retained.
- Required data is validated before matching.

### Detective Controls

- Stale academic-data rate
- Data-incomplete eligibility rate
- Recommendation data-warning rate
- Students with no recommendation because of missing evidence
- Source reconciliation reports

### Corrective Controls

- Information-request workflow
- Source-data correction
- Reevaluation after data refresh
- Student intervention case
- Controlled manual review

### Residual Risk Target

Moderate

---

## RC-003: Unauthorized Academic Exception

### Risk Description

A user without academic authority may approve or apply an exception to an
academic rule.

### Potential Consequences

- Invalid internship approval
- Inconsistent treatment
- Weak academic governance
- Audit finding
- Reputational damage

### Preventive Controls

- Academic exception approval limited to authorized roles.
- Permission must be connected to department scope.
- Students cannot approve their own requests.
- Career-center staff cannot approve unless explicitly delegated.
- High-impact exceptions require secondary approval.
- Exception validity and scope must be defined.

### Detective Controls

- Exception approval by role report
- Exceptions without academic approver
- Expired exception usage report
- High exception-rate alert by reviewer or rule

### Corrective Controls

- Revoke invalid exception
- Recalculate eligibility
- Suspend affected placement decision
- Notify relevant student and academic role
- Review access permissions

### Residual Risk Target

Low

---

## RC-004: Unverified, Restricted or Unsafe Employer Activated

### Risk Description

An employer may be activated without adequate verification or may continue
operating after a serious complaint or restriction.

### Potential Consequences

- Student safety risk
- Personal-data misuse
- Opportunity cancellation
- Reputational damage
- Legal or contractual exposure

### Preventive Controls

- Employer verification before activation
- Controlled employer statuses
- Authorized representative validation
- Acceptance of privacy and candidate-data responsibilities
- Opportunity publication blocked for suspended employers
- Employer-risk review when required

### Detective Controls

- Employer complaint monitoring
- Repeated cancellation rate
- Employer rejection and response patterns
- Suspended employer activity report
- Employer representative access review

### Corrective Controls

- Restrict or suspend employer
- Place active opportunities under review
- Revoke representative access
- Notify affected students
- Review active placements separately
- Document reinstatement decision

### Residual Risk Target

Moderate

---

## RC-005: Invalid or Incomplete Opportunity Published

### Risk Description

An opportunity may be published with:

- Missing responsibilities
- Invalid dates
- Zero or incorrect capacity
- Unclear requirements
- Inappropriate working conditions
- Academic irrelevance
- Inaccurate employer information

### Potential Consequences

- Invalid applications
- Student confusion
- Repeated clarification
- Late cancellation
- Inaccurate matching
- Wasted review effort

### Preventive Controls

- Required opportunity fields
- Start, end and deadline validation
- Positive capacity validation
- Structured requirement classification
- Career-center review
- Academic review when necessary
- Publication only after approval

### Detective Controls

- Opportunity completeness report
- Correction-required rate
- Opportunity cancellation analysis
- Missing-capacity report
- Student and staff issue reports

### Corrective Controls

- Return opportunity for correction
- Temporarily restrict visibility
- Reevaluate active applications
- Notify affected students
- Create new opportunity version

### Residual Risk Target

Moderate

---

## RC-006: Employer Changes Approved Opportunity Conditions

### Risk Description

An employer may change important conditions after opportunity approval.

Material changes may include:

- Responsibilities
- Mandatory skills
- Location
- Working model
- Dates
- Capacity
- Compensation
- Target academic program

### Potential Consequences

- Students evaluated using outdated conditions
- Unfair rejection
- Invalid placement
- Student withdrawal
- Academic-approval conflict

### Preventive Controls

- Approved opportunity version must be locked.
- Material changes must create a new version.
- Material changes trigger re-review.
- Offer conditions must match the approved version.
- Employers must provide a change reason.

### Detective Controls

- Offer-to-opportunity comparison
- Material change report
- Active applications linked to outdated versions
- Student complaint monitoring

### Corrective Controls

- Suspend affected offer
- Reevaluate applications
- Request student reconfirmation
- Release reservations where necessary
- Cancel invalid opportunity through controlled process

### Residual Risk Target

Moderate

---

## RC-007: Duplicate or Invalid Application

### Risk Description

A student may submit:

- Multiple active applications to the same opportunity
- An application after the deadline
- An application while academically ineligible
- An application beyond the permitted limit
- An application to a closed opportunity

### Potential Consequences

- Duplicate processing
- Incorrect application counts
- Employer confusion
- Unfair capacity use
- Increased operational workload

### Preventive Controls

- Unique active application constraint
- Deadline validation
- Eligibility validation
- Application-limit validation
- Opportunity-status validation
- Idempotency key for repeated submissions

### Detective Controls

- Duplicate active application query
- Application-status reconciliation
- Repeated request monitoring
- Invalid transition report

### Corrective Controls

- Close duplicate record
- Preserve original valid application
- Correct status through authorized process
- Notify student when necessary

### Residual Risk Target

Low

---

## RC-008: Mandatory Requirement Evaluated Incorrectly

### Risk Description

A mandatory employer requirement may be:

- Applied as preferred
- Ignored
- Interpreted incorrectly
- Applied using the wrong student value
- Evaluated against an outdated requirement version
- Satisfied using insufficient evidence

### Potential Consequences

- Ineligible candidate sent to employer
- Qualified candidate excluded
- Unexplained recommendation
- Employer dissatisfaction
- Inconsistent treatment

### Preventive Controls

- Structured requirement records
- Controlled importance values
- Approved operators and proficiency scales
- Requirement versioning
- Required evidence level
- Rule-level test scenarios
- Mandatory evaluation before compatibility scoring

### Detective Controls

- Mandatory failure analysis
- Requirement result sampling
- Requirement changes after application
- Employer feedback on invalid candidates
- Requirement-evaluation exception report

### Corrective Controls

- Reevaluation
- Requirement correction
- Recommendation superseding
- Employer and student notification
- Model or rule correction

### Residual Risk Target

Moderate

---

## RC-009: Recommendation Cannot Be Explained

### Risk Description

A recommendation may not retain enough information to explain why a student
was ranked or excluded.

### Potential Consequences

- Weak reviewer confidence
- Difficult appeal handling
- Audit failure
- Student distrust
- Hidden model errors

### Preventive Controls

Every recommendation must retain:

- Eligibility evaluation
- Mandatory requirement results
- Compatibility indicators
- Indicator weights
- Student preference version
- Data-quality status
- Confidence level
- Capacity status
- Rule and model version
- Explanation summary

### Detective Controls

- Recommendation evidence completeness report
- Missing indicator explanation report
- Decisions without linked recommendation evidence
- Periodic reviewer feedback

### Corrective Controls

- Hold recommendation for reevaluation
- Generate missing evidence
- Supersede incomplete recommendation
- Correct explanation template

### Residual Risk Target

Low

---

## RC-010: Excessive Reliance on Compatibility Score

### Risk Description

Reviewers or stakeholders may treat a compatibility score as a final decision
or as a general measure of student quality.

### Potential Consequences

- Inappropriate automated placement
- Ignored contextual information
- Reduced human accountability
- Unfair interpretation
- Model misuse outside internship placement

### Preventive Controls

- Recommendation status must be labeled advisory.
- Final placement requires human review.
- Score documentation must describe limitations.
- Eligibility, compatibility and placement must remain separate.
- Reviewer interface must show underlying indicators.
- Prohibited-use policy must be documented.
- Staff training must explain that score does not represent student worth.

### Detective Controls

- Placements without human decision
- High-volume reviewer approval without evidence review
- Unusually short review times
- Use of scores in unauthorized reports
- Model-access audit

### Corrective Controls

- Suspend affected workflow
- Review decisions
- Retrain users
- Restrict score visibility
- Conduct governance investigation

### Residual Risk Target

Moderate

---

## RC-011: Recommendation Concentration

### Risk Description

A limited group of students may repeatedly receive a large share of
recommendations.

### Potential Causes

- Genuine qualification differences
- Verified-skill imbalance
- Opportunity concentration
- Incomplete profiles
- Restrictive weights
- Repeated employer preferences
- Data or process bias

### Potential Consequences

- Students remain without opportunity
- Unequal access
- Repeated recommendation cycles
- Institutional concern
- Lower trust

### Preventive Controls

- Multiple compatibility dimensions
- Student-preference consideration
- No-recommendation intervention
- Weight governance
- Opportunity-diversity monitoring
- Separation of urgency from compatibility

### Detective Controls

- Top-decile recommendation concentration rate
- No-recommendation rate
- Recommendation rate by department
- Exclusion rate by requirement
- Recommendation distribution by model version

### Corrective Controls

- Review model weights
- Improve student profile support
- Increase opportunity diversity
- Review employer requirements
- Create targeted intervention
- Activate a new model version after approval

### Important Limitation

A concentration indicator must not automatically:

- Change scores
- Create quotas
- Confirm discrimination
- Reverse placements
- Remove employers

### Residual Risk Target

Moderate

---

## RC-012: Hidden, Inappropriate or Sensitive Matching Factor

### Risk Description

The matching model may use a factor that is:

- Undocumented
- Unapproved
- Irrelevant
- Sensitive
- Derived from protected information
- Difficult to explain

### Potential Consequences

- Privacy violation
- Fairness concern
- Legal exposure
- Unexplainable decisions
- Institutional misuse

### Preventive Controls

- Approved indicator registry
- Documented feature purpose
- Business, academic and privacy ownership
- Sensitive-data prohibition
- Model configuration approval
- Change control
- Test-data review

### Detective Controls

- Active-feature inventory
- Comparison of model configuration with approved registry
- Data-lineage review
- Privacy impact review
- Unauthorized field-use alert

### Corrective Controls

- Disable factor
- Suspend recommendation generation
- Reevaluate affected recommendations
- Notify governance roles
- Perform impact analysis

### Residual Risk Target

Low

---

## RC-013: Opportunity Capacity Exceeded

### Risk Description

The system may create more reservations or confirmed placements than the
opportunity capacity permits.

### Potential Consequences

- Two students assigned to one position
- Employer rejection after acceptance
- Student harm
- Manual emergency resolution
- Reputational damage

### Preventive Controls

- Capacity must be positive.
- Reservation creation and availability check must be atomic.
- Confirmed placement consumes capacity transactionally.
- Applications and recommendations do not consume capacity.
- Available capacity cannot become negative.
- Concurrent requests must use locking or equivalent concurrency control.

### Detective Controls

- Capacity reconciliation
- Negative-capacity exception query
- Confirmed placements exceeding capacity
- Duplicate active reservation report
- Capacity conflict attempts

### Corrective Controls

- Stop new offers
- Investigate latest reservation or placement
- Contact affected stakeholders
- Release invalid reservation
- Record correction without deleting history

### Residual Risk Target

Low

---

## RC-014: Expired or Declined Offer Continues Blocking Capacity

### Risk Description

A reservation may remain active after an offer is:

- Declined
- Rejected
- Expired
- Cancelled
- Superseded

### Potential Consequences

- Opportunity appears full
- Qualified students are not recommended
- Employer capacity remains unused
- Placement rate decreases

### Preventive Controls

- Reservation lifecycle linked to offer lifecycle
- Automatic expiration process
- Release transaction after decline or rejection
- Controlled status-transition rules

### Detective Controls

- Expired offers with active reservations
- Reservation age report
- Available-capacity reconciliation
- Offer expiration job monitoring

### Corrective Controls

- Release reservation
- Recalculate capacity
- Reactivate capacity-hold recommendations where appropriate
- Notify operational staff

### Residual Risk Target

Low

---

## RC-015: Conflicting Confirmed Placements

### Risk Description

A student may receive two confirmed placements with overlapping internship
dates.

### Potential Consequences

- Student cannot complete both internships
- Employer dissatisfaction
- Academic conflict
- Capacity distortion
- Administrative correction

### Preventive Controls

- Date-overlap validation before confirmation
- Controlled exception authority
- Final prerequisite checklist
- Placement creation idempotency
- One authoritative placement record

### Detective Controls

- Overlapping confirmed placement query
- Multiple active placement report
- Conflicting offer alert

### Corrective Controls

- Suspend conflicting placement
- Determine valid placement through authorized review
- Release capacity
- Notify stakeholders
- Preserve cancellation reason

### Residual Risk Target

Low

---

## RC-016: Unauthorized Manual Override

### Risk Description

A user may change a recommendation outcome without sufficient authority.

### Potential Consequences

- Inconsistent treatment
- Academic or capacity violation
- Fairness concern
- Audit finding
- Loss of trust

### Preventive Controls

- Role-based override permission
- Override category restrictions
- Non-overridable conditions
- Secondary approval for high-impact cases
- Supporting evidence requirement
- Separation between original and final result

### Detective Controls

- Override count by reviewer
- Missing secondary approval
- Override frequency by department
- Override use on mandatory failures
- Suspicious after-hours override activity

### Corrective Controls

- Revoke invalid override
- Suspend downstream offer or placement
- Review user access
- Reevaluate affected case
- Escalate to governance or audit

### Residual Risk Target

Low

---

## RC-017: Incomplete or Meaningless Override Reason

### Risk Description

An override may contain a reason such as:

- Approved
- Okay
- Done
- N/A
- Management request

without enough evidence to understand the decision.

### Potential Consequences

- Weak accountability
- Difficult appeals
- Inability to monitor patterns
- Audit finding
- Hidden policy inconsistency

### Preventive Controls

- Minimum explanation length
- Structured override category
- Supporting evidence reference
- Reviewer guidance
- Secondary approver review

### Detective Controls

- Decision reason completeness rate
- Repeated generic reason report
- Random control sampling
- Audit-event completeness

### Corrective Controls

- Return override for additional explanation
- Suspend approval until completed
- Reviewer coaching
- Update reason categories

### Residual Risk Target

Low

---

## RC-018: Employer Receives Excessive Student Information

### Risk Description

An employer may receive personal or academic information beyond what is needed
to evaluate a candidate.

### Examples

- Full academic history
- Other applications
- Other employer decisions
- Sensitive support information
- Internal reviewer notes
- Unnecessary contact information

### Potential Consequences

- Privacy breach
- Unauthorized processing
- Student complaint
- Regulatory or contractual issue
- Loss of trust

### Preventive Controls

- Employer-specific candidate view
- Field-level authorization
- Purpose-based access
- Data-minimization review
- Candidate-sharing stage validation
- Document-access controls
- Employer data-use terms

### Detective Controls

- Employer access logs
- Export monitoring
- Candidate-record access outside employer scope
- Privacy review sampling
- Unusual record-volume alert

### Corrective Controls

- Revoke access
- Suspend representative account
- Investigate exposure
- Notify privacy and security teams
- Apply incident-response process

### Residual Risk Target

Moderate

---

## RC-019: Sensitive Student Information Used in Matching

### Risk Description

Accessibility, health, financial, support or other sensitive information may
be used as a general scoring factor.

### Potential Consequences

- Discriminatory outcomes
- Privacy violation
- Student harm
- Unexplainable exclusion
- Legal exposure

### Preventive Controls

- Sensitive fields excluded from standard matching.
- Purpose-specific processing requires approval.
- Accessibility needs use controlled human review.
- Feature registry identifies prohibited data.
- Sensitive data stored separately with restricted access.
- Free-text data is not automatically scored.

### Detective Controls

- Data-lineage review
- Active matching-feature inventory
- Sensitive-field access report
- Privacy impact assessment
- Recommendation explanation sampling

### Corrective Controls

- Disable model configuration
- Reevaluate affected recommendations
- Restrict data access
- Investigate impact
- Notify appropriate governance roles

### Residual Risk Target

Low

---

## RC-020: Unauthorized Account Access

### Risk Description

An attacker or unauthorized user may access student, employer or staff
functions.

### Potential Consequences

- Personal-data exposure
- Manipulated decisions
- Fraudulent employer activity
- Unauthorized placement confirmation
- Service disruption

### Preventive Controls

- Approved authentication service
- Multi-factor authentication for privileged roles
- Strong session management
- Role-based authorization
- Least privilege
- Account verification
- Automatic deactivation after role change
- Secure password and credential policy where applicable

### Detective Controls

- Failed login monitoring
- Impossible-travel or unusual access detection
- Privileged-action monitoring
- Dormant-account review
- Session anomaly alerts

### Corrective Controls

- Account suspension
- Token revocation
- Credential reset
- Incident investigation
- Access-right recertification
- Affected decision review

### Residual Risk Target

Moderate

---

## RC-021: Unauthorized Bulk Data Export

### Risk Description

A user may download or extract a large quantity of student information.

### Potential Consequences

- Large-scale privacy breach
- Employer misuse
- Unauthorized profiling
- Reputational damage
- Legal exposure

### Preventive Controls

- Export permission separated from view permission
- Maximum export size
- Approved export purpose
- Masked fields
- Watermarked or traceable exports where appropriate
- Restricted API pagination
- High-risk export confirmation

### Detective Controls

- Export event logging
- High-volume query alert
- Repeated export monitoring
- Unusual employer activity
- Data-loss prevention controls where available

### Corrective Controls

- Terminate access
- Revoke downloaded access links
- Investigate and contain incident
- Notify privacy and security teams
- Review affected students and data categories

### Residual Risk Target

Moderate

---

## RC-022: Integration Provides Stale, Duplicate or Incorrect Data

### Risk Description

An external service may send:

- Duplicate messages
- Old academic records
- Incorrect identifiers
- Partial updates
- Out-of-order events
- Invalid status values

### Potential Consequences

- Incorrect eligibility
- Duplicate records
- Missing profile data
- Wrong notification
- Conflicting decisions

### Preventive Controls

- Idempotency keys
- Source record identifiers
- Schema validation
- Timestamp validation
- Controlled status mapping
- Message sequencing where required
- Retry-safe processing
- Source-system ownership

### Detective Controls

- Integration failure rate
- Duplicate-message count
- Data freshness monitoring
- Source-to-target reconciliation
- Dead-letter queue review
- Conflicting critical data report

### Corrective Controls

- Replay valid message
- Quarantine invalid message
- Correct mapping
- Reconcile affected records
- Reevaluate eligibility or recommendation
- Notify business owner

### Residual Risk Target

Moderate

---

## RC-023: Eligibility or Matching Service Unavailable

### Risk Description

A technical failure may prevent eligibility evaluations or recommendations
during an active placement period.

### Potential Consequences

- Application delay
- Missed employer deadline
- Review backlog
- Students remain unplaced
- Emergency manual work

### Preventive Controls

- Monitored service availability
- Capacity planning
- Deployment change control
- Health checks
- Redundant components where appropriate
- Queue-based asynchronous processing
- Published maintenance windows

### Detective Controls

- Service health monitoring
- API success rate
- Processing failure rate
- Queue age
- Recommendation processing time
- User incident reports

### Corrective Controls

- Retry processing
- Failover
- Restore service
- Prioritize critical cases
- Activate continuity procedure
- Reconcile delayed evaluations

### Residual Risk Target

Moderate

---

## RC-024: Notification Failure Causes Missed Deadline

### Risk Description

Email or notification delivery may fail, causing a student, employer or
reviewer to miss an important action.

### Potential Consequences

- Offer expiration
- Missed application
- Delayed academic approval
- Capacity remains reserved
- Student loses opportunity

### Preventive Controls

- Important tasks visible inside the system
- Multiple reminders
- Notification templates with deadlines
- Validated contact information
- Escalation recipient
- Notification retry

### Detective Controls

- Notification delivery rate
- Failed-delivery queue
- Offers nearing expiration without viewed notification
- Overdue review tasks
- Unanswered information requests

### Corrective Controls

- Resend notification
- Escalate to staff
- Contact through approved alternate channel
- Extend deadline only through authorized process
- Document exceptional handling

### Residual Risk Target

Moderate

---

## RC-025: Student Remains Unplaced Without Timely Intervention

### Risk Description

An eligible student may reach the placement deadline without:

- Application
- Recommendation
- Active offer
- Confirmed placement
- Staff intervention

### Potential Consequences

- Missed mandatory internship
- Graduation delay
- Student dissatisfaction
- Emergency placement
- Unequal support

### Preventive Controls

- No-recommendation detection
- Placement-deadline monitoring
- Intervention priority rules
- Student dashboard warnings
- Career-center case assignment
- Opportunity supply monitoring

### Detective Controls

- Students with no recommendation rate
- Unplaced student rate
- Intervention backlog
- Eligible students with no application
- Cancelled placements requiring replacement

### Corrective Controls

- Open intervention case
- Review profile and preferences
- Academic consultation
- Targeted employer outreach
- External placement review
- Escalate critical deadline risk

### Residual Risk Target

Moderate

---

## RC-026: Decision History Overwritten or Deleted

### Risk Description

A later update may replace the original:

- Eligibility result
- Recommendation
- Human decision
- Override
- Offer
- Placement
- Outcome

### Potential Consequences

- No audit trail
- Difficult appeals
- Incorrect historical reporting
- Hidden corrections
- Control failure

### Preventive Controls

- Versioned records
- Status-history entities
- Immutable audit events
- No hard deletion of final decisions
- Correction through superseding records
- Effective-dated rules

### Detective Controls

- Missing history report
- Version-sequence validation
- Audit-event reconciliation
- Final records with no creation event
- Unexpected destructive database activity

### Corrective Controls

- Restore from audit or backup
- Create correction record
- Investigate unauthorized change
- Review affected reports
- Strengthen permissions

### Residual Risk Target

Low

---

## RC-027: KPI Report Uses Inconsistent Definition

### Risk Description

Two reports may calculate the same KPI using different:

- Statuses
- Populations
- Date fields
- Exclusions
- Denominators
- Model versions

### Potential Consequences

- Conflicting management information
- Incorrect decisions
- Misleading department comparison
- Loss of trust in reporting

### Preventive Controls

- Approved KPI catalog
- Versioned definitions
- Named numerator and denominator
- Defined reporting date
- Controlled status mappings
- Data-owner approval
- Reusable analytical views

### Detective Controls

- Report reconciliation
- KPI-definition comparison
- Independent calculation testing
- Unexpected trend-change review
- Data-quality warning

### Corrective Controls

- Correct report
- Publish definition notice
- Recalculate affected periods
- Preserve previous report version
- Update documentation

### Residual Risk Target

Low

---

## RC-028: Small-Group Reporting Exposes Individuals

### Risk Description

A dashboard or report may display results for a group small enough to identify
individual students.

### Potential Consequences

- Privacy breach
- Sensitive outcome exposure
- Re-identification
- Student complaint

### Preventive Controls

- Minimum reportable group size
- Suppression rules
- Role-based report access
- Removal of unnecessary dimensions
- Aggregation review
- Export restrictions

### Detective Controls

- Reports containing groups below threshold
- Dashboard privacy testing
- Report-access monitoring
- Manual review of new dimensions

### Corrective Controls

- Remove or suppress report
- Restrict access
- Investigate exposure
- Notify privacy owner
- Update dashboard configuration

### Residual Risk Target

Low

---

## RC-029: Incorrect Internship Outcome Recorded

### Risk Description

The final internship status may be recorded incorrectly or may combine
completion with academic-credit approval.

### Potential Consequences

- Incorrect academic record
- Misleading completion KPI
- Employer-performance distortion
- Student dispute
- Invalid model evaluation

### Preventive Controls

- Controlled outcome statuses
- Separate academic-credit status
- Required completion evidence
- Authorized outcome recorder
- Validation of planned and actual dates

### Detective Controls

- Outcome without placement
- Completed placement without outcome
- Completion and credit inconsistency
- Outcome correction frequency
- Employer and student evaluation reconciliation

### Corrective Controls

- Controlled outcome correction
- Academic review
- Recalculate affected KPI
- Notify student and responsible unit
- Preserve old outcome version

### Residual Risk Target

Low

---

## RC-030: Backup, Recovery or Reconciliation Failure

### Risk Description

The system may be unable to restore accurate placement and decision records
after a failure.

### Potential Consequences

- Lost applications
- Missing offers
- Incorrect capacity
- Lost audit evidence
- Delayed placement process
- Inability to reconstruct decisions

### Preventive Controls

- Approved backup schedule
- Encrypted backup storage
- Recovery-point and recovery-time targets
- Environment separation
- Database transaction integrity
- Documented recovery procedure

### Detective Controls

- Backup completion monitoring
- Restore testing
- Record-count reconciliation
- Capacity reconciliation after recovery
- Audit-sequence validation

### Corrective Controls

- Restore from approved backup
- Replay integration events
- Reconcile offers, reservations and placements
- Prioritize active deadline cases
- Document data loss and business impact

### Residual Risk Target

Moderate

# Control Matrix

| Control ID | Control | Type | Frequency | Owner | Evidence |
|---|---|---|---|---|---|
| CT-001 | Validate student profile completeness | Preventive | On update and submission | System owner | Validation result |
| CT-002 | Evaluate versioned academic rules | Preventive | Each eligibility evaluation | Academic owner | Rule results |
| CT-003 | Review academic exceptions | Preventive | Per request | Academic authority | Exception decision |
| CT-004 | Verify employer before activation | Preventive | Per employer | Career center | Verification record |
| CT-005 | Review opportunity before publication | Preventive | Per opportunity | Career center | Review decision |
| CT-006 | Detect material opportunity changes | Preventive | On update | System | New version and review task |
| CT-007 | Prevent duplicate active application | Preventive | On submission | System | Constraint result |
| CT-008 | Evaluate mandatory requirements first | Preventive | Per application | Matching service | Requirement results |
| CT-009 | Preserve recommendation evidence | Preventive | Per recommendation | Matching service | Evidence records |
| CT-010 | Require human recommendation review | Preventive | Per recommendation | Career center | Placement decision |
| CT-011 | Monitor recommendation concentration | Detective | Weekly during cycle | Governance | Concentration report |
| CT-012 | Review active matching factors | Detective | Each model release | Model owner | Feature inventory |
| CT-013 | Reserve capacity atomically | Preventive | Per offer | System | Reservation transaction |
| CT-014 | Reconcile capacity | Detective | Hourly or daily | Operations | Capacity report |
| CT-015 | Release expired reservations | Corrective | Scheduled | System | Release event |
| CT-016 | Validate placement date overlap | Preventive | Per confirmation | System | Conflict result |
| CT-017 | Require override authorization | Preventive | Per override | Business owner | Permission result |
| CT-018 | Require secondary approval | Preventive | High-impact override | Academic or governance role | Approval record |
| CT-019 | Review override patterns | Detective | Monthly | Governance | Override report |
| CT-020 | Restrict employer candidate fields | Preventive | Every access | Privacy and IT | Access policy |
| CT-021 | Monitor data exports | Detective | Continuous | Security | Export logs |
| CT-022 | Validate integration messages | Preventive | Per message | IT | Schema result |
| CT-023 | Monitor service health | Detective | Continuous | IT operations | Monitoring logs |
| CT-024 | Monitor notification delivery | Detective | Continuous | Operations | Delivery status |
| CT-025 | Detect students without recommendations | Detective | Daily | Career center | Intervention list |
| CT-026 | Preserve immutable audit events | Preventive | Every material action | System owner | Audit event |
| CT-027 | Version KPI definitions | Preventive | On KPI change | Reporting owner | KPI catalog |
| CT-028 | Suppress small report groups | Preventive | Report generation | Privacy owner | Suppression result |
| CT-029 | Validate internship outcome evidence | Preventive | Per outcome | Academic or career-center role | Outcome record |
| CT-030 | Test backup recovery | Detective | Scheduled | IT operations | Restore test report |

# Access Control Matrix

| Function | Student | Employer | Career Center | Academic Role | Manager | IT Admin | Auditor |
|---|---:|---:|---:|---:|---:|---:|---:|
| View own student profile | Yes | No | Authorized | Authorized scope | Authorized | Technical support only | Read-only when approved |
| Edit student career profile | Own only | No | Assisted update | No | No | No | No |
| Edit authoritative academic data | No | No | No | Source process only | No | Technical integration only | No |
| Create opportunity | No | Own employer | Assisted | No | Assisted | No | No |
| Approve opportunity | No | No | Yes | When required | Yes | No | No |
| View candidate record | Own record | Submitted candidates only | Yes | Academic scope | Yes | Support only | Approved review only |
| Evaluate academic exception | Request only | No | Route only | Yes | Limited | No | Read-only |
| Review recommendation | Own result view | Limited candidate view | Yes | Consulted scope | Yes | No | Read-only |
| Apply manual override | No | No | Authorized only | Academic category | Authorized | No | No |
| Approve high-impact override | No | No | Limited | Academic authority | Governance authority | No | No |
| Create placement offer | No | No | Yes | No | Yes | No | Read-only |
| Accept student offer | Own only | No | No | No | No | No | No |
| Confirm employer response | No | Own employer | Assisted | No | No | No | No |
| Confirm final placement | No | No | Authorized | Consulted | Authorized | No | Read-only |
| Export student data | Own data only | Restricted | Restricted | Restricted scope | Restricted | Technical only | Approved audit scope |
| Configure matching model | No | No | Model owner | Consulted | Approver | Technical implementation | Read-only |
| Review audit events | Own actions where appropriate | Own activity where appropriate | Limited | Limited | Yes | Technical logs | Yes |

# Segregation of Duties

The following activities should be separated where feasible.

## Academic Rules

- Rule proposal
- Rule approval
- Technical configuration
- Eligibility result review

## Matching Model

- Indicator design
- Model approval
- Technical activation
- Recommendation review
- Model monitoring

## Manual Overrides

- Override request
- Primary approval
- Secondary approval
- Audit review

## Employer Management

- Employer registration
- Employer verification
- Employer suspension
- Employer reinstatement

## Placement Confirmation

- Recommendation generation
- Recommendation approval
- Offer response
- Final placement confirmation
- Post-placement audit

## High-Risk Conflict Examples

A user should not:

- Configure and independently approve the same academic rule.
- Create and secondary-approve the same override.
- Register and verify their own employer account.
- Generate and silently confirm a placement without required external actions.
- Modify an audit event for their own decision.

# Privacy Controls

## Data-Minimization Controls

The system should:

- Collect only required information.
- Avoid exact location where city or region is sufficient.
- Separate sensitive support records.
- Limit employer access to candidate-review needs.
- Avoid placing sensitive details in notification messages.
- Restrict free-text exports.

## Purpose-Limitation Controls

Student information may be used only for documented purposes such as:

- Eligibility
- Application
- Candidate review
- Placement
- Internship monitoring
- Approved reporting

Information must not be reused for unrelated ranking, disciplinary or academic
purposes without a separate authorized basis.

## Retention Controls

Retention rules should be defined separately for:

- Student profile
- Application
- Candidate-sharing record
- Recommendation
- Offer
- Placement
- Internship outcome
- Audit event
- Employer notes
- Uploaded documents

## Data Subject Controls

Where applicable, students should be able to:

- View permitted personal information
- Report incorrect information
- Request correction
- Understand important decision reasons
- Request review of defined decisions

# Information Security Controls

## Authentication

- University identity for students and staff
- Verified employer accounts
- Multi-factor authentication for privileged users
- Session timeout
- Account lockout or adaptive controls
- Secure credential recovery

## Authorization

- Role-based permissions
- Employer-level tenant restriction
- Department-level academic scope
- Least privilege
- Periodic access recertification
- Immediate removal after role termination

## Application Security

- Input validation
- Output encoding
- Secure API authorization
- Rate limiting
- Dependency and vulnerability review
- Secure secret management
- Protection against injection and unauthorized object access

## Data Security

- Encryption in transit
- Encryption at rest where required
- Secure document references
- Restricted backups
- Masked non-production data
- Controlled logging without unnecessary personal information

## Monitoring

- Authentication events
- Privileged actions
- Bulk export
- Unusual employer access
- Permission changes
- Decision and override activity
- Security incident correlation

# Matching Model Controls

## Model Configuration Controls

Every configuration must include:

- Model name
- Model version
- Active indicators
- Indicator weights
- Score ranges
- Missing-data treatment
- Confidence calculation
- Recommendation thresholds
- Tie-handling rules
- Effective dates
- Approved owners

## Pre-Release Controls

Before a model version becomes active:

1. Weights must total 100 percent.
2. Score boundaries must be tested.
3. Mandatory failures must block standard scoring.
4. Sensitive fields must be excluded.
5. Missing-data scenarios must be tested.
6. Explanation outputs must be reviewed.
7. Tie scenarios must be tested.
8. Historical comparisons must be completed.
9. Privacy and fairness reviews must be documented.
10. Rollback procedure must be defined.

## Post-Release Controls

After activation, monitor:

- Score distribution
- Confidence distribution
- Recommendation rate
- No-recommendation rate
- Override rate
- Employer acceptance
- Student acceptance
- Placement conversion
- Completion outcomes
- Concentration indicators
- Data-quality warnings

# Fairness and Access Controls

## Monitoring Controls

The university may review:

- Placement rate by academic program
- Recommendation rate by program
- No-recommendation rate
- Opportunity access rate
- Employer rejection rate
- Override rate
- Recommendation concentration
- Intervention case rate

## Context Requirements

Before interpreting a difference, reviewers must consider:

- Sample size
- Opportunity supply
- Student preferences
- Application activity
- Academic eligibility
- Employer requirements
- Missing data
- Confidence level
- Department rules

## Prohibited Automatic Actions

A fairness alert must not automatically:

- Modify a score
- Apply a quota
- Confirm discrimination
- Cancel a placement
- Suspend an employer
- Override academic eligibility

## Fairness Review Evidence

A review should record:

- Indicator
- Reporting population
- Group size
- Data-quality status
- Relevant model version
- Context analysis
- Reviewer conclusion
- Approved action
- Follow-up date

# Data Quality Controls

## Completeness Controls

Required data includes:

- Student identity
- Academic program
- Eligibility inputs
- Opportunity dates
- Opportunity capacity
- Mandatory requirements
- Application status
- Offer expiration
- Placement dates

## Validity Controls

Examples include:

- GPA within accepted range
- Positive opportunity capacity
- End date after start date
- Deadline before internship start
- Compatibility score between 0 and 100
- Controlled statuses
- Valid language-level scale

## Uniqueness Controls

Prevent duplicate active:

- Student profiles
- Applications
- Recommendations where prohibited
- Offers where prohibited
- Reservations
- Placements

## Consistency Controls

Examples:

- Cancelled opportunity cannot accept new applications.
- Expired offer cannot retain active reservation.
- Confirmed placement must consume capacity.
- Internship outcome must reference a placement.
- Suspended employer cannot publish an active opportunity.
- Approved recommendation is not the same as confirmed placement.

## Freshness Controls

Data freshness must be monitored for:

- Academic records
- Student availability
- Opportunity capacity
- Employer status
- Application status
- Offer status

# Integration Controls

## Message Validation

Each integration message should contain:

- Source-system identifier
- Source-record identifier
- Event or update timestamp
- Schema version
- Correlation identifier
- Idempotency identifier

## Failure Handling

A failed integration should:

- Preserve the rejected message.
- Record a structured error.
- Avoid partial business-state updates.
- Support safe retry.
- Notify technical owners.
- Identify affected students or opportunities.

## Reconciliation

Reconciliation should compare:

- Source student count
- Current academic records
- Employer account status
- Opportunity records
- Notification requests and delivery results
- Documents requested and received

# Operational Continuity

## Critical Processes

Critical activities include:

- Application submission
- Eligibility evaluation
- Opportunity review
- Recommendation generation
- Offer response
- Capacity release
- Placement confirmation
- Student intervention

## Continuity Priorities

| Priority | Process |
|---|---|
| 1 | Protect confirmed placement and capacity integrity |
| 2 | Preserve offer deadlines and responses |
| 3 | Process critical eligibility and placement cases |
| 4 | Restore recommendation processing |
| 5 | Restore standard reports and non-critical features |

## Manual Continuity Procedure

When the system is unavailable:

- New high-impact decisions must use an approved temporary record.
- Temporary decisions require unique identifiers.
- Capacity must be checked through one controlled source.
- Manual confirmations require authorized approval.
- Temporary records must be entered into the system after restoration.
- Reconciliation must confirm no duplicate or conflicting placement exists.

## Recovery Validation

After recovery, verify:

- Application counts
- Latest eligibility results
- Active recommendations
- Pending offers
- Active reservations
- Confirmed placements
- Capacity totals
- Audit-event sequence
- Notification backlog

# Incident Classification

## Severity 1: Critical

Examples:

- Confirmed capacity exceeded
- Large-scale personal-data breach
- Unauthorized placement confirmations
- Matching model using prohibited sensitive information
- Complete placement service outage near deadline
- Loss of final placement records

### Response

- Immediate containment
- Senior management notification
- Privacy or security escalation
- Business continuity activation
- Formal incident investigation

## Severity 2: High

Examples:

- Multiple incorrect eligibility decisions
- Suspended employer remains active
- High-impact override without approval
- Notification outage affecting active offers
- Recommendation backlog threatens deadlines

### Response

- Same-day investigation
- Owner and management notification
- Affected case identification
- Corrective action and monitoring

## Severity 3: Moderate

Examples:

- Individual data inconsistency
- Delayed opportunity review
- Single incorrect status transition
- Non-critical report inconsistency

### Response

- Assigned operational resolution
- Documented correction
- Trend monitoring

## Severity 4: Low

Examples:

- Minor display issue
- Non-blocking optional-data warning
- Low-impact notification formatting issue

### Response

- Standard support process
- Planned correction

# Escalation Matrix

| Event | Initial Owner | Escalation |
|---|---|---|
| Academic-rule failure | Academic coordinator | Department authority |
| Employer safety concern | Career-center manager | Administration, legal |
| Personal-data exposure | Privacy officer | Security and senior management |
| Unauthorized access | Security team | Privacy and system owner |
| Capacity conflict | Career-center operations | Manager and IT |
| Duplicate placement | Career-center manager | Academic unit and administration |
| High-impact override issue | Governance owner | Internal audit |
| Recommendation concentration | Model owner | Fairness review committee |
| System outage | IT operations | Business continuity owner |
| Student deadline risk | Career-center specialist | Career-center manager |

# Key Risk Indicators

| KRI | Risk Signal | Example Threshold |
|---|---|---|
| Eligibility data incomplete rate | Source-data failure | Above 5% |
| Stale academic data rate | Outdated academic decisions | Above 2% |
| Students with no recommendation | Placement-access risk | Above 15% near deadline |
| Capacity reconciliation exceptions | Over-allocation risk | Any negative result |
| Expired offers with active reservation | Capacity blockage | Any unresolved record |
| Manual override rate | Excessive human divergence | Significant increase from baseline |
| Missing secondary approval | Governance failure | Any case |
| Decision reason completeness | Weak accountability | Below 100% |
| Recommendation concentration | Access concentration | Above approved review threshold |
| Low-confidence recommendation rate | Weak evidence | Significant increase |
| Employer cancellation rate | Partnership instability | Above approved threshold |
| Notification delivery failure | Missed deadline risk | Above approved threshold |
| Integration failure rate | Data-processing instability | Above approved threshold |
| Audit-event completeness | Traceability weakness | Below 99% |
| Duplicate confirmed placement | Placement integrity failure | Any case |

Thresholds are preliminary and require institutional approval.

# Control Testing Plan

## Daily or Continuous Tests

- Negative capacity check
- Expired offer with active reservation
- Suspended employer activity
- Duplicate confirmed placement
- Failed notification queue
- Critical intervention overdue
- Service availability
- Integration failures

## Weekly Tests During Active Cycle

- Students with no recommendation
- Review backlog
- Eligibility data quality
- Employer response delay
- Recommendation concentration
- Low-confidence recommendations
- Opportunity supply by department

## Monthly Tests

- Override pattern review
- Access recertification exceptions
- Employer cancellation trends
- Decision-reason completeness
- Audit-event completeness
- Small-group reporting review

## Per Release

- Business-rule regression tests
- Status-transition tests
- Authorization tests
- Capacity concurrency tests
- Matching-model tests
- Privacy field tests
- API contract validation
- Recovery procedure validation where relevant

## Annual or Periodic Tests

- Full access review
- Backup restoration
- Business continuity exercise
- Privacy impact reassessment
- Security penetration testing
- Model governance review
- Retention and deletion review

# Control Test Record

A control test should record:

- Control identifier
- Test objective
- Test date
- Tester
- Population
- Sample
- Test method
- Expected result
- Actual result
- Exception count
- Evidence reference
- Corrective action
- Responsible owner
- Due date
- Retest result

# Control Deficiency Classification

## Design Deficiency

The control does not adequately address the identified risk.

Example:

```text
A decision reason is required, but the field accepts one-character values.
```

## Implementation Deficiency

The control is designed but not implemented consistently.

Example:

```text
Secondary approval exists in policy but is not enforced by the application.
```

## Operating Deficiency

The control exists but does not operate as expected.

Example:

```text
The expiration job failed and reservations remained active.
```

## Evidence Deficiency

The control may operate, but sufficient evidence is not retained.

Example:

```text
An academic exception was approved, but the approver identity was not stored.
```

# Corrective Action Management

Every material control deficiency should include:

- Deficiency identifier
- Related risk
- Description
- Root cause
- Impact
- Interim control
- Permanent corrective action
- Responsible owner
- Target date
- Priority
- Validation method
- Closure approval

# Audit Evidence Requirements

The system should preserve evidence for:

- Academic rule approval
- Eligibility evaluation
- Academic exception decision
- Employer verification
- Opportunity review
- Requirement version
- Application submission
- Requirement evaluation
- Match evaluation
- Recommendation evidence
- Human decision
- Manual override
- Secondary approval
- Capacity reservation
- Offer response
- Final placement
- Placement cancellation
- Internship outcome
- Permission change
- Sensitive export
- Rule and model configuration change

# Risk Acceptance

A residual risk may be accepted only when:

- The risk is clearly documented.
- The business owner is identified.
- Current controls are understood.
- The potential impact is accepted.
- The acceptance period is defined.
- Review date is recorded.
- Senior approval is obtained for high or critical residual risk.

Risk acceptance must not be used to bypass:

- Legal obligations
- Safety requirements
- Required academic authority
- Personal-data protection
- Confirmed capacity integrity
- Required student consent

# Risk Review Frequency

| Risk Rating | Minimum Review Frequency |
|---|---|
| Critical | Continuous monitoring and monthly formal review |
| High | Monthly during active cycles |
| Moderate | Quarterly or per placement cycle |
| Low | Annually or after material change |

A new review is also required when:

- A major incident occurs.
- A new matching-model version is introduced.
- Academic policies change.
- A new data source is connected.
- Employer-data access changes.
- A new sensitive data category is proposed.
- Placement capacity logic changes.
- A significant audit finding occurs.

# Risk and Control Traceability

| Process Area | Major Risks | Main Controls |
|---|---|---|
| Student profile | RC-002, RC-022 | CT-001, CT-022 |
| Academic eligibility | RC-001, RC-003 | CT-002, CT-003 |
| Employer management | RC-004 | CT-004 |
| Opportunity management | RC-005, RC-006 | CT-005, CT-006 |
| Applications | RC-007 | CT-007 |
| Requirement evaluation | RC-008 | CT-008 |
| Matching | RC-009 to RC-012 | CT-009 to CT-012 |
| Capacity | RC-013, RC-014 | CT-013 to CT-015 |
| Placement confirmation | RC-015 | CT-016 |
| Overrides | RC-016, RC-017 | CT-017 to CT-019 |
| Privacy | RC-018, RC-019, RC-021, RC-028 | CT-020, CT-021, CT-028 |
| Security | RC-020, RC-021 | Authentication and monitoring controls |
| Integrations | RC-022 | CT-022 |
| Availability | RC-023, RC-024 | CT-023, CT-024 |
| Student intervention | RC-025 | CT-025 |
| Auditability | RC-026 | CT-026 |
| Reporting | RC-027 | CT-027 |
| Outcomes | RC-029 | CT-029 |
| Recovery | RC-030 | CT-030 |

# Risk Framework Success Criteria

The risk and control framework is successful when:

- Every high-impact process has an accountable owner.
- Eligibility rules are versioned and testable.
- Missing data is not silently treated as failure.
- Academic exceptions require proper authority.
- Employers are verified before activation.
- Material opportunity changes trigger review.
- Mandatory requirements are evaluated before scoring.
- Recommendations retain explainable evidence.
- Final placements require human authorization.
- Capacity cannot become negative.
- Expired offers release reservations.
- Conflicting placements are prevented.
- Manual overrides remain visible and controlled.
- Employers receive only necessary candidate information.
- Sensitive information is excluded from general matching.
- Students with no recommendation are detected early.
- Historical decisions cannot be silently overwritten.
- KPI definitions remain controlled.
- Small groups receive privacy protection.
- Recovery procedures preserve placement integrity.
- Control exceptions lead to documented corrective action.

# Risk and Control Summary

The Internship Placement and Matching System introduces significant benefits,
but it also creates academic, operational, privacy, fairness and technical
risks.

The highest-risk areas are:

- Academic eligibility
- Mandatory requirement evaluation
- Matching-model use
- Opportunity capacity
- Manual overrides
- Personal-data access
- Integration reliability
- Student deadline management
- Historical decision integrity

The proposed control environment combines:

- Preventive validation
- Authorized human review
- Role-based access
- Segregation of duties
- Transactional capacity control
- Model and rule versioning
- Audit events
- Data-quality monitoring
- Fairness review
- Incident escalation
- Recovery and reconciliation

The next document will translate the requirements, business rules and controls
into test scenarios covering normal workflows, boundary values, authorization,
failure handling, matching logic, capacity conflicts and auditability.
