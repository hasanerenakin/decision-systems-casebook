# Business Rules

## Case

Internship Placement and Matching System

## Domain

University Career Services and Internship Operations

## Document Purpose

This document defines the business rules governing the internship placement
and matching process.

The rules cover:

- Student profile readiness
- Academic eligibility
- Academic exceptions
- Employer and opportunity approval
- Applications
- Mandatory and preferred requirements
- Compatibility evaluation
- Opportunity capacity
- Placement recommendations
- Human review
- Manual overrides
- Placement offers
- Final placement confirmation
- Internship completion
- Data quality
- Auditability
- Privacy and fairness review

Business rules must be implemented consistently, versioned when changed and
connected to the decisions they influence.

## Rule Categories

| Category | Prefix | Purpose |
|---|---|---|
| Student Profile | BR-SP | Profile completeness and student information |
| Academic Eligibility | BR-AE | Academic participation conditions |
| Employer Management | BR-EM | Employer approval and access |
| Opportunity Management | BR-OP | Opportunity validation and activation |
| Application Management | BR-AP | Application submission and status |
| Requirement Evaluation | BR-RQ | Mandatory, preferred and optional requirements |
| Matching | BR-MT | Compatibility evaluation and recommendation |
| Capacity | BR-CP | Position availability and reservations |
| Human Review | BR-HR | Recommendation review and decisions |
| Override | BR-OV | Controlled exceptions to system results |
| Offer Management | BR-OF | Placement offers and response periods |
| Placement | BR-PL | Final placement confirmation and cancellation |
| Outcome | BR-OT | Internship completion and evaluation |
| Data Quality | BR-DQ | Reliability of evaluation inputs |
| Governance | BR-GV | Auditability, versioning and fairness monitoring |

## Rule Interpretation Principles

### Mandatory Rules

Mandatory rules must be satisfied before the related process can continue.

A failed mandatory rule cannot be compensated for by:

- A high compatibility score
- Strong preferred qualifications
- Employer preference
- Student preference
- Informal staff approval
- Earlier application time

### Advisory Rules

Advisory rules may influence ranking, alerts or review priority but do not
automatically exclude a student or confirm a placement.

### Human Review

Rules may generate:

- Eligibility results
- Exclusion results
- Compatibility indicators
- Recommendations
- Alerts
- Review tasks

Rules do not independently create a final confirmed placement.

### Rule Versioning

Every eligibility, requirement, compatibility and recommendation result must
preserve the rule version used at the time of evaluation.

Historical results must not be silently recalculated after a rule change.

# Student Profile Rules

## BR-SP-001: One Active Profile per Student

A student may have only one active internship-placement profile for the same
university identity.

### Expected Behavior

- Duplicate active profiles are rejected.
- Historical inactive profile versions may be retained.
- Profile merges require an authorized correction process.

---

## BR-SP-002: Authoritative Academic Fields

Academic information received from an approved university source cannot be
directly edited by the student.

Examples include:

- Academic program
- Department
- Academic year
- GPA
- Completed credits
- Completed courses
- Enrollment status

### Expected Behavior

- Students may report an error.
- Reported errors create a review request.
- The authoritative source remains unchanged until corrected through an
  approved process.

---

## BR-SP-003: Required Profile Completeness

A student cannot submit an internship application when required profile
sections are incomplete.

Required sections may include:

- Contact information
- Academic information
- Availability
- Required documents
- Minimum skill or preference information defined by policy

### Expected Behavior

The system must identify each missing section separately.

---

## BR-SP-004: Optional Information

Missing optional profile information must not automatically block an
application.

Optional information may reduce the completeness recommendation but must not be
presented as a mandatory eligibility failure.

---

## BR-SP-005: Controlled Skill Values

Student skills must use an approved skill catalog when a matching rule depends
on the skill.

Free-text skills may be stored for review but must not silently satisfy a
structured mandatory requirement.

---

## BR-SP-006: Skill Verification Status

A self-declared skill and a verified skill must be distinguishable.

Possible verification statuses include:

- Self-declared
- Document supported
- Course verified
- Certification verified
- Employer verified
- University verified

An opportunity may require a specific verification level only when the
requirement clearly states this condition.

---

## BR-SP-007: Preference Versioning

Student preferences used in a recommendation must be preserved as a historical
version.

A later preference change must not silently alter:

- Existing applications
- Historical recommendations
- Previous decisions
- Confirmed placements

---

## BR-SP-008: Conflicting Hard Preferences

The system must detect logically conflicting required preferences.

Example:

- Required working model: remote only
- Selected opportunity: on-site only

The combination must be classified as incompatible unless the student changes
the preference or an authorized review determines that the preference was
incorrectly recorded.

# Academic Eligibility Rules

## BR-AE-001: Active Enrollment

A student must have an active enrollment status for the relevant placement
period unless an approved policy permits another status.

Possible non-eligible statuses may include:

- Withdrawn
- Suspended
- Inactive
- Graduated
- Registration cancelled

---

## BR-AE-002: Eligible Academic Program

The student's academic program must be included in the opportunity or
placement-cycle eligibility scope.

A department or program mismatch results in:

- Ineligible, or
- Academic review required

The result depends on the applicable academic policy.

---

## BR-AE-003: Minimum Academic Year

When a placement cycle requires a minimum academic year, the student must meet
or exceed that year.

Example:

```text
Required academic year: 3
Student academic year: 2
Result: Ineligible
```

---

## BR-AE-004: Minimum GPA

When a minimum GPA is defined, the student's current authoritative GPA must be
greater than or equal to the required value.

Example:

```text
Minimum GPA: 2.50
Student GPA: 2.50
Result: Requirement passed
```

A value exactly equal to the minimum passes the rule.

---

## BR-AE-005: Required Credit Completion

When a minimum completed-credit value is required, the student's completed
credits must be greater than or equal to the threshold.

Credits currently in progress do not count unless the academic policy
explicitly permits them.

---

## BR-AE-006: Required Course Completion

A required course is considered completed only when the authoritative academic
record shows an accepted completion status.

Possible accepted statuses may include:

- Passed
- Exempt
- Transferred and accepted

A currently enrolled course does not satisfy the requirement unless an
approved rule explicitly allows conditional eligibility.

---

## BR-AE-007: Previous Mandatory Internship

A student cannot be placed into the same mandatory internship requirement more
than once when the requirement has already been successfully completed.

A voluntary internship may remain possible if permitted by policy.

---

## BR-AE-008: Internship Period Compatibility

The internship start and end dates must fall within an academically permitted
period or have documented academic approval.

---

## BR-AE-009: Eligibility Result Classification

Academic eligibility must produce one of the following results:

- Eligible
- Ineligible
- Review required
- Data incomplete

The system must not convert missing data into a confirmed failure unless the
policy explicitly requires rejection after a deadline.

---

## BR-AE-010: Failed Rule Explanation

Every failed academic rule must record:

- Rule identifier
- Rule version
- Expected condition
- Observed value
- Result
- Evaluation timestamp

The student-facing explanation must not expose unrelated academic information.

---

## BR-AE-011: Academic Exception Authority

Only an authorized academic role may approve an exception to an academic
eligibility rule.

Career-center staff may create or route an exception request but cannot approve
it unless they have explicit academic authority.

---

## BR-AE-012: Exception Scope

An academic exception must identify:

- The specific rule being overridden
- The student
- The placement cycle or opportunity
- Effective date
- Expiration date
- Decision reason
- Approving role

An exception must not create a general permanent exemption unless the policy
explicitly authorizes it.

---

## BR-AE-013: Expired Academic Exception

An expired academic exception cannot be used in a new eligibility evaluation.

A new review is required.

---

## BR-AE-014: Eligibility Recalculation

Eligibility must be recalculated when relevant information changes, including:

- Enrollment status
- GPA
- Completed credits
- Required course completion
- Academic rule version
- Internship period
- Approved exception status

# Employer Management Rules

## BR-EM-001: Employer Approval Before Activation

An employer must be reviewed and approved before publishing active internship
opportunities.

---

## BR-EM-002: Employer Status

Employer status must use a controlled value:

- Pending
- Active
- Restricted
- Suspended
- Rejected
- Inactive

Only active employers may create new published opportunities.

---

## BR-EM-003: Employer Representative Scope

An employer representative may access only:

- Their approved employer record
- Opportunities belonging to that employer
- Candidates submitted for those opportunities
- Related offers and placements

The representative must not access another employer's records.

---

## BR-EM-004: Suspended Employer

When an employer becomes suspended:

- New opportunities cannot be published.
- Pending opportunities are placed under review.
- Existing offers and placements are evaluated for impact.
- The suspension reason is recorded.
- Employer representatives lose restricted operational permissions.

Confirmed placements must not be silently cancelled.

---

## BR-EM-005: Employer Reinstatement

A suspended employer may become active only after an authorized review and
documented reinstatement decision.

# Opportunity Management Rules

## BR-OP-001: Positive Opportunity Capacity

Opportunity capacity must be a positive integer.

Boundary examples:

| Capacity | Result |
|---:|---|
| -1 | Invalid |
| 0 | Invalid |
| 1 | Valid |
| 10 | Valid |

---

## BR-OP-002: Valid Internship Dates

The opportunity end date must be later than the start date.

An opportunity with equal start and end dates is invalid unless a specific
one-day internship type is explicitly supported.

---

## BR-OP-003: Valid Application Deadline

The application deadline must occur before the opportunity start date.

The deadline may equal the final permitted application date according to
university policy.

---

## BR-OP-004: Opportunity Approval

An opportunity cannot become active until required reviews are complete.

Possible reviews include:

- Employer verification
- Career-center review
- Academic relevance review
- Safety or compliance review

---

## BR-OP-005: Requirement Classification

Every structured opportunity requirement must be classified as:

- Mandatory
- Preferred
- Optional

A requirement without an approved classification cannot act as an automatic
exclusion rule.

---

## BR-OP-006: Material Opportunity Change

A material change after approval triggers re-review.

Material changes include:

- Internship responsibilities
- Mandatory requirements
- Working model
- Location
- Start or end date
- Capacity
- Compensation status where institutionally relevant
- Employer
- Required academic program

---

## BR-OP-007: Expired Opportunity

An opportunity becomes unavailable for new applications after its application
deadline or controlled closure date.

Existing applications remain historically available.

---

## BR-OP-008: Opportunity Cancellation

Cancelling an opportunity requires:

- Cancellation reason
- Responsible user
- Effective timestamp
- Affected application review
- Affected offer review
- Stakeholder notification

# Application Management Rules

## BR-AP-001: Application Preconditions

A student may submit an application only when:

- The profile is sufficiently complete.
- The student is eligible or has an approved exception.
- The opportunity is active.
- The deadline has not passed.
- Required documents are available.
- The application limit has not been exceeded.
- No duplicate active application exists.
- No conflicting confirmed placement exists.

---

## BR-AP-002: Deadline Boundary

An application submitted exactly at the permitted deadline is accepted when
the system timestamp is not later than the deadline.

Example:

```text
Deadline: 2026-09-01 17:00:00
Submission: 2026-09-01 17:00:00
Result: Accepted
```

A submission after the deadline is rejected.

---

## BR-AP-003: Duplicate Application

A student cannot maintain more than one active application for the same
opportunity.

Withdrawn, rejected or expired historical applications remain available but do
not create a second active application conflict.

---

## BR-AP-004: Application Limit

A student's active application count must not exceed the applicable limit.

The limit may depend on:

- Placement period
- Academic department
- Mandatory internship status
- Active offers
- Confirmed placements

---

## BR-AP-005: Application Withdrawal

A student may withdraw an application before the defined cutoff point.

After a final confirmed placement, withdrawal must follow the placement
cancellation process.

---

## BR-AP-006: Controlled Application Status

Application status must follow an approved transition model.

Example valid transitions:

```text
Draft → Submitted
Submitted → Eligibility Review
Eligibility Review → Eligible
Eligible → Employer Review
Employer Review → Shortlisted
Shortlisted → Offer Pending
```

Invalid direct transitions must be rejected.

Example:

```text
Draft → Placement Confirmed
Result: Invalid transition
```

---

## BR-AP-007: Application Status Reason

A rejection, expiration, withdrawal or cancellation must include a structured
reason when required by policy.

# Requirement Evaluation Rules

## BR-RQ-001: Mandatory Requirements First

Mandatory requirements must be evaluated before compatibility ranking.

A failed mandatory requirement excludes the combination from standard
recommendation ranking.

---

## BR-RQ-002: Preferred Requirements

A failed preferred requirement does not automatically exclude the student.

It may reduce the preferred-requirement satisfaction indicator.

---

## BR-RQ-003: Optional Requirements

Optional requirements may provide additional context but must not create an
automatic exclusion.

---

## BR-RQ-004: Missing Evidence

Missing evidence must be distinguished from confirmed requirement failure.

Possible results include:

- Passed
- Failed
- Evidence missing
- Review required
- Not applicable

---

## BR-RQ-005: Verified Skill Requirement

When an opportunity requires verified evidence for a skill, a self-declared
skill alone does not satisfy the requirement.

---

## BR-RQ-006: Language Requirement

A mandatory language requirement passes only when the student's recorded level
meets or exceeds the required level on the approved scale.

Example scale:

```text
A1 < A2 < B1 < B2 < C1 < C2
```

Example:

```text
Required: B2
Student: B2
Result: Passed
```

---

## BR-RQ-007: Requirement Version

The requirement version used during evaluation must be stored.

A later employer change does not silently alter a completed historical
evaluation.

---

## BR-RQ-008: Requirement Change Reevaluation

An active application must be reevaluated when a material mandatory requirement
changes before final placement confirmation.

Affected students must be notified when the change influences eligibility.

# Matching Rules

## BR-MT-001: Eligible Combinations Only

Only combinations that pass academic eligibility and mandatory requirement
evaluation may receive a standard compatibility score.

---

## BR-MT-002: Compatibility Dimensions

Compatibility may include approved dimensions such as:

- Skill compatibility
- Academic relevance
- Industry preference
- Role preference
- Location compatibility
- Working-model compatibility
- Period compatibility
- Language compatibility
- Preferred requirement satisfaction

---

## BR-MT-003: Documented Weighting

Every compatibility dimension must have:

- Definition
- Weight
- Minimum and maximum value
- Data source
- Business owner
- Version
- Effective date

---

## BR-MT-004: Score Range

The overall compatibility score must remain within the approved range.

Example:

```text
Minimum score: 0
Maximum score: 100
```

Values below 0 or above 100 are invalid.

---

## BR-MT-005: Missing Data Treatment

Missing data must not automatically produce a favorable score.

The matching configuration must define whether missing data results in:

- Zero contribution
- Neutral contribution
- Review required
- Exclusion from the affected indicator

---

## BR-MT-006: Hard Student Constraint

A student preference classified as a required constraint may exclude an
opportunity when the opportunity conflicts with it.

Examples include:

- Unacceptable location
- Incompatible internship dates
- Required remote working model
- Documented availability restriction

The system must distinguish a student constraint from a general ranking
preference.

---

## BR-MT-007: Explainable Recommendation

A recommendation must display the main factors contributing to the result.

At minimum, it must include:

- Eligibility result
- Mandatory requirement results
- Compatibility indicators
- Missing preferred qualifications
- Preference alignment
- Capacity status
- Data-quality status
- Rule and model version

---

## BR-MT-008: Recommendation Is Advisory

A compatibility score or recommendation does not create:

- Employer acceptance
- Student acceptance
- Academic approval
- Placement confirmation

These statuses remain separate.

---

## BR-MT-009: Tie Handling

When two eligible candidates have the same compatibility result, the system
must use a documented tie-handling rule.

Possible approaches include:

- Human review
- Earlier completed application
- Higher preference alignment
- Greater unmet placement urgency
- Randomized controlled ordering

The system must not use an undocumented hidden factor.

---

## BR-MT-010: No-Recommendation Student

An eligible student with no active recommendation must receive a documented
reason category.

Possible categories include:

- No active opportunity
- Mandatory requirement mismatch
- Restrictive preference
- Capacity unavailable
- Missing evidence
- No submitted application
- Repeated employer rejection
- Date conflict

---

## BR-MT-011: Recommendation Expiration

A recommendation expires when:

- The opportunity closes.
- The application is withdrawn.
- Eligibility becomes invalid.
- Requirements materially change.
- Capacity becomes unavailable.
- A newer recommendation supersedes it.
- The recommendation validity period ends.

---

## BR-MT-012: Recommendation Concentration Alert

A concentration alert may be generated when recommendations are repeatedly
assigned to a limited group of students.

The alert triggers human investigation and does not automatically modify
scores or placements.

# Capacity Rules

## BR-CP-001: Capacity Components

Opportunity capacity must distinguish:

```text
Total Capacity
Confirmed Placements
Active Reservations
Available Capacity
```

The standard available-capacity formula is:

```text
Available Capacity =
Total Capacity
- Confirmed Placements
- Active Reservations
```

---

## BR-CP-002: Non-Negative Capacity

Available capacity must never become negative.

A transaction that would produce negative capacity must be rejected.

---

## BR-CP-003: Application Does Not Consume Capacity

Submitting an application does not consume final opportunity capacity.

---

## BR-CP-004: Offer Reservation

A placement offer may create a temporary capacity reservation.

The reservation must include:

- Offer identifier
- Opportunity
- Student
- Reservation timestamp
- Expiration timestamp
- Reservation status

---

## BR-CP-005: Reservation Release

Capacity reservation must be released when:

- The student declines.
- The employer rejects the student.
- The offer expires.
- The offer is cancelled.
- The recommendation is withdrawn.
- Final placement fails prerequisite validation.

---

## BR-CP-006: Confirmed Placement Consumption

A confirmed placement converts reserved capacity into consumed capacity.

---

## BR-CP-007: Concurrent Reservation Control

The system must prevent two simultaneous actions from reserving the same final
position beyond total capacity.

---

## BR-CP-008: Capacity Reduction

When an employer reduces total capacity below the number of confirmed
placements:

- Existing confirmed placements are not silently cancelled.
- A critical review task is created.
- The change requires a documented reason.
- Affected offers and reservations are evaluated.

# Human Review Rules

## BR-HR-001: Authorized Reviewer

Only a user with the appropriate placement-review permission may approve or
reject a recommendation.

---

## BR-HR-002: Evidence Availability

A recommendation cannot receive final approval when required evidence is
missing or unavailable.

The reviewer may request additional information.

---

## BR-HR-003: Decision Reason

Every approval or rejection must include a decision reason.

A blank or meaningless reason is invalid.

Example invalid values:

```text
Okay
Done
Approved
N/A
```

---

## BR-HR-004: Original Recommendation Preservation

A human decision must not overwrite the original system recommendation.

The following must remain separately traceable:

- System result
- Reviewer decision
- Decision reason
- Final placement outcome

---

## BR-HR-005: Second Final Decision

A recommendation that already has a final decision cannot receive another
normal final decision.

A correction must use an authorized superseding or decision-correction process.

---

## BR-HR-006: Additional Information Status

When additional information is requested:

- The recommendation status changes appropriately.
- The request identifies the responsible party.
- A deadline may be assigned.
- Overdue requests generate an alert.

---

## BR-HR-007: Review Expiration

A reviewer cannot approve an expired recommendation without reevaluation.

# Manual Override Rules

## BR-OV-001: Override Authority

Only authorized roles may create a manual override.

Override authority may depend on:

- Rule type
- Academic impact
- Placement impact
- Fairness sensitivity
- Privacy sensitivity

---

## BR-OV-002: Non-Overridable Rules

The following cannot be overridden by unauthorized operational staff:

- Academic prohibition
- Suspended employer status
- Invalid placement dates
- Missing student consent
- Privacy restriction
- Confirmed capacity conflict
- Required legal or safety condition

---

## BR-OV-003: Override Information

Every override must record:

- Original recommendation
- Original rule result
- Final human decision
- Override category
- Detailed justification
- Supporting evidence
- Reviewer
- Timestamp
- Secondary approval where required

---

## BR-OV-004: Secondary Approval

High-impact overrides require a second authorized approver.

High-impact overrides may include:

- Academic exception
- Mandatory requirement bypass
- Capacity conflict
- Employer restriction
- Accessibility-sensitive decision
- Fairness-sensitive decision

---

## BR-OV-005: Override Does Not Delete History

The original recommendation and evaluation must remain available after an
override.

---

## BR-OV-006: Override Monitoring

Override frequency and patterns must be reportable by:

- Reviewer
- Department
- Rule
- Opportunity
- Employer
- Decision outcome

An unusual pattern triggers review rather than automatic misconduct
classification.

# Placement Offer Rules

## BR-OF-001: Approved Recommendation Required

A standard placement offer may be created only from an approved recommendation
or authorized override.

---

## BR-OF-002: Offer Preconditions

Before creating an offer, the system must verify:

- Opportunity is active.
- Capacity is available.
- Student has no conflicting confirmed placement.
- Internship dates remain valid.
- Employer is not suspended.
- Required approvals are current.

---

## BR-OF-003: Offer Expiration

Every offer must have an expiration date later than its creation date.

---

## BR-OF-004: Expired Offer

An expired offer cannot be accepted.

Authorized reactivation must create a new controlled validity period and audit
event.

---

## BR-OF-005: Explicit Student Decision

Student acceptance must be explicit.

Viewing an offer or failing to respond does not equal acceptance.

---

## BR-OF-006: Student Decline

When a student declines:

- Offer status becomes declined.
- Capacity reservation is released.
- The recommendation and decision history remain available.
- Other matching actions may continue.

---

## BR-OF-007: Employer Decision Scope

An employer representative may accept or reject only offers related to their
own approved opportunities.

---

## BR-OF-008: Offer Condition Consistency

Offer conditions must remain consistent with the approved opportunity version.

A material difference requires review before the offer is issued.

---

## BR-OF-009: Multiple Active Offers

University policy must define whether a student may hold multiple active offers.

When multiple active offers are allowed, each must have:

- Independent expiration
- Independent reservation
- Conflict warning
- Clear acceptance consequences

# Final Placement Rules

## BR-PL-001: Placement Preconditions

A final placement may be confirmed only when all required conditions are met.

These may include:

- Student acceptance
- Employer acceptance
- Career-center approval
- Academic approval
- Valid opportunity
- Available or reserved capacity
- Complete required documents
- No conflicting confirmed placement
- Valid internship dates

---

## BR-PL-002: Distinct Approval Statuses

The system must distinguish:

- Recommendation approved
- Employer accepted
- Student accepted
- Academic approved
- Final placement confirmed

One status must not automatically represent another.

---

## BR-PL-003: Duplicate Placement Prevention

A student cannot have conflicting confirmed placements for overlapping
internship periods unless an explicit policy and authorized exception permit
it.

---

## BR-PL-004: Date Overlap

Two placements conflict when their active date periods overlap according to the
approved overlap rule.

The system must identify:

- Full overlap
- Partial overlap
- Same start date
- Same end date
- Contained period

---

## BR-PL-005: Placement Record Protection

A confirmed placement cannot be permanently deleted through normal user
actions.

It may be:

- Cancelled
- Corrected
- Superseded
- Marked invalid through an authorized process

Historical values remain available.

---

## BR-PL-006: Placement Cancellation

Cancellation requires:

- Cancellation reason
- Requesting party
- Authorized decision
- Effective date
- Capacity update
- Academic impact assessment
- Student support action where necessary

---

## BR-PL-007: Capacity After Cancellation

A cancelled placement releases capacity only when the cancellation status is
effective and no policy requires the position to remain unavailable.

---

## BR-PL-008: External Placement

A student-sourced external internship is not a confirmed university placement
until:

- Employer is reviewed.
- Opportunity is reviewed.
- Academic suitability is approved.
- Student acceptance is recorded.
- Required documents are complete.
- Final confirmation is completed.

# Internship Outcome Rules

## BR-OT-001: Outcome Classification

Internship outcome must use a controlled status:

- Successfully completed
- Partially completed
- Failed
- Cancelled by student
- Cancelled by employer
- Terminated by university
- Under review

---

## BR-OT-002: Completion vs Academic Credit

Internship completion and academic-credit approval must remain separate when
the university process requires separate decisions.

---

## BR-OT-003: Outcome Evidence

A final outcome may require:

- Student evaluation
- Employer evaluation
- Attendance information
- Internship report
- Academic assessment
- Completion date

---

## BR-OT-004: Outcome Traceability

The internship outcome must remain connected to:

- Student
- Opportunity
- Application
- Recommendation
- Human decision
- Offer
- Placement
- Employer

---

## BR-OT-005: Historical Matching Stability

A final outcome must not silently rewrite the historical recommendation score.

Outcomes may be used for later analysis or future model review through a
separate controlled process.

# Data Quality Rules

## BR-DQ-001: Missing Academic Data

An eligibility decision cannot be classified as confirmed eligible when a
mandatory academic value is missing.

The result must be:

- Data incomplete, or
- Review required

---

## BR-DQ-002: Stale Academic Data

Academic data older than the approved freshness threshold must be marked as
stale.

Stale data may block high-impact decisions according to policy.

---

## BR-DQ-003: Conflicting Information

When two approved sources provide conflicting critical values:

- The conflict is recorded.
- Automatic final evaluation is suspended.
- An authorized review task is created.

---

## BR-DQ-004: Invalid Score Input

A compatibility indicator cannot be calculated using values outside its
approved range.

---

## BR-DQ-005: Missing Capacity Data

An opportunity with missing or invalid capacity cannot issue a placement offer.

---

## BR-DQ-006: Duplicate Core Records

Duplicate active records must be prevented for:

- Student profile
- Employer
- Opportunity identifier
- Active application
- Active offer where prohibited
- Confirmed placement

---

## BR-DQ-007: Data Quality Visibility

Authorized reviewers must see warnings when a recommendation uses:

- Missing data
- Stale data
- Unverified skills
- Low-confidence evidence
- Conflicting information
- Manual corrections

# Governance Rules

## BR-GV-001: Decision Auditability

The system must record important decisions and status changes.

Required audit information includes:

- Event identifier
- User or system identity
- Timestamp
- Affected entity
- Previous status
- New status
- Reason
- Rule version
- Correlation identifier where applicable

---

## BR-GV-002: Rule Ownership

Every configurable rule must have:

- Business owner
- Technical owner
- Version
- Approval status
- Effective date
- Review date

---

## BR-GV-003: Effective-Dated Rules

A rule applies only during its approved effective period.

Future rules must not be applied early.

Expired rules must not be used for new evaluations.

---

## BR-GV-004: No Silent Historical Recalculation

Historical decisions must not be silently changed when:

- Rule weights change
- Eligibility conditions change
- Opportunity requirements change
- Student preferences change
- Skill catalog values change

A new evaluation must create a new version.

---

## BR-GV-005: Personal Data Minimization

Only information necessary for an authorized placement purpose may be
displayed or shared.

---

## BR-GV-006: Employer Candidate Access

An employer may access a candidate only when:

- The employer owns the relevant opportunity.
- The candidate has entered the approved employer-review stage.
- Required sharing conditions are satisfied.
- The employer account remains active.

---

## BR-GV-007: Sensitive Student Information

Accessibility, health, support or other sensitive information must not become
a general compatibility score.

Such information may be used only through an approved, limited and
purpose-specific process.

---

## BR-GV-008: Fairness Indicators

Fairness indicators may trigger investigation, comparison and governance
review.

They must not automatically:

- Confirm discrimination
- Change a student's score
- Remove an employer
- Reverse a placement
- Apply a quota

Any resulting action requires authorized human review.

---

## BR-GV-009: Small Group Protection

Reports must protect groups that are too small for safe aggregated reporting.

The approved minimum group size must be defined by privacy governance.

---

## BR-GV-010: Segregation of Duties

High-impact activities should be separated where operationally possible.

Examples include:

| Activity | Separate Role |
|---|---|
| Configure eligibility rule | Rule owner |
| Generate recommendation | System |
| Review recommendation | Career-center reviewer |
| Approve academic exception | Academic authority |
| Confirm placement | Authorized placement role |
| Review audit records | Governance or audit role |

# Recommendation Priority Rules

## BR-PR-001: Critical Priority

A student case may receive critical priority when:

- A mandatory internship deadline is imminent.
- A confirmed placement is cancelled close to the deadline.
- A severe accessibility or safety issue is identified.
- A system error affects final placement confirmation.
- A student has no valid placement and no remaining standard opportunity.

---

## BR-PR-002: High Priority

A case may receive high priority when:

- The student has repeated employer rejections.
- Eligibility review is overdue.
- An offer is approaching expiration.
- Opportunity capacity is at risk.
- Required academic approval remains pending.
- A fairness or override alert requires timely review.

---

## BR-PR-003: Standard Priority

Standard priority applies to:

- Normal recommendation review
- Profile improvement
- Preference adjustment support
- Routine opportunity approval
- Non-urgent information requests

# Boundary-Value Rules

| Rule Area | Boundary | Expected Result |
|---|---:|---|
| Minimum GPA | Student equals minimum | Pass |
| Minimum academic year | Student equals required year | Pass |
| Minimum completed credits | Student equals threshold | Pass |
| Application deadline | Submitted exactly at deadline | Accept |
| Application deadline | Submitted one second late | Reject |
| Opportunity capacity | 0 | Invalid |
| Opportunity capacity | 1 | Valid |
| Available capacity | 0 | No new reservation |
| Available capacity | 1 | One reservation permitted |
| Compatibility score | 0 | Valid minimum |
| Compatibility score | 100 | Valid maximum |
| Compatibility score | -0.01 | Invalid |
| Compatibility score | 100.01 | Invalid |
| Offer expiration | Equal to creation time | Invalid |
| Offer expiration | Later than creation time | Valid |
| Language requirement | Student equals required level | Pass |
| Application count | Equals maximum limit | No additional application |
| Application count | One below maximum | One additional application allowed |

# Rule Conflict Resolution

When two rules conflict, the following order generally applies:

1. Legal, safety and privacy restrictions
2. Academic eligibility rules
3. Employer mandatory requirements
4. Opportunity and capacity rules
5. Student hard constraints
6. Placement conflict rules
7. Preferred employer requirements
8. Student ranking preferences
9. Optimization and recommendation rules

A conflict that cannot be resolved through approved precedence must be sent for
authorized human review.

# Rule Traceability Matrix

| Rule Group | Related Requirements |
|---|---|
| Student profile rules | FR-001 to FR-005 |
| Academic eligibility rules | FR-006 to FR-008 |
| Employer rules | FR-009 to FR-011 |
| Opportunity rules | FR-012 to FR-016 |
| Application rules | FR-017 to FR-020 |
| Requirement rules | FR-021 and FR-022 |
| Matching rules | FR-023 to FR-026 |
| Human review rules | FR-027 to FR-029 |
| Override rules | FR-030 and FR-031 |
| Offer rules | FR-032 to FR-035 |
| Placement rules | FR-036 to FR-039 |
| Outcome rules | FR-040 to FR-042 |
| Notification and task rules | FR-043 and FR-044 |
| Reporting and governance rules | FR-045 to FR-048 |

# Rule Change Process

A business-rule change should follow this process:

1. Identify the requested change.
2. Document the business reason.
3. Identify affected stakeholders.
4. Analyze student, employer and operational impact.
5. Review privacy, fairness and security implications.
6. Define the new rule version.
7. Add effective dates.
8. Create or update test scenarios.
9. Obtain approval.
10. Activate the rule.
11. Monitor results.
12. Preserve the previous version.

# Business Rule Success Criteria

The rule framework is successful when:

- Eligibility conditions are applied consistently.
- Mandatory requirements are evaluated before ranking.
- Student preferences remain distinct from eligibility.
- Capacity cannot become negative.
- Recommendations remain explainable.
- Human decisions remain separate from system results.
- Overrides require authority and justification.
- Offers expire and release capacity correctly.
- Duplicate confirmed placements are prevented.
- Historical rules and decisions remain traceable.
- Data-quality limitations are visible.
- Fairness indicators trigger review rather than automatic conclusions.
- Sensitive student information is protected.

# Business Rule Summary

The Internship Placement and Matching System does not treat placement as a
single numerical-ranking problem.

The rule framework separates:

- Academic eligibility
- Employer mandatory requirements
- Preferred qualifications
- Student preferences
- Compatibility indicators
- Opportunity capacity
- System recommendations
- Human decisions
- Student acceptance
- Employer acceptance
- Final placement confirmation
- Internship outcome

This separation supports:

- Correctness
- Explainability
- Human accountability
- Privacy
- Fairness review
- Capacity integrity
- Auditability
- Historical analysis

The next document will define the conceptual data model connecting students,
academic programs, employers, opportunities, applications, eligibility
evaluations, recommendations, offers, placements and internship outcomes.
