# Test Scenarios

## Case

Internship Placement and Matching System

## Domain

University Career Services and Internship Operations

## Document Purpose

This document defines business, functional, authorization, data-quality,
integration, concurrency and control test scenarios for the Internship
Placement and Matching System.

The scenarios validate whether the proposed system correctly supports:

- Student profile management
- Academic eligibility
- Academic exceptions
- Employer verification
- Internship opportunity approval
- Application submission
- Mandatory requirement evaluation
- Compatibility calculation
- Explainable recommendations
- Human review
- Manual overrides
- Placement offers
- Capacity reservations
- Final placement confirmation
- Placement cancellation
- Internship outcomes
- Student intervention
- Privacy
- Security
- Auditability
- Reporting
- Operational resilience

The scenarios are based on the requirements, business rules, data model,
matching model, API contract, KPI framework and risk-control framework defined
for this case.

## Test Objectives

The test process should confirm that:

- Mandatory rules are applied consistently.
- Boundary values are handled correctly.
- Missing data is not silently converted into a positive result.
- Academic eligibility remains separate from compatibility.
- Employer mandatory requirements are evaluated before ranking.
- Recommendations remain advisory.
- Final placement requires authorized human action.
- Capacity never becomes negative.
- Duplicate and overlapping placements are prevented.
- Manual overrides require authority and explanation.
- Sensitive student information is protected.
- Historical decisions remain traceable.
- Failed integrations do not create duplicate or partial records.
- Important operational and governance controls produce evidence.

# Test Levels

## Business Rule Testing

Validates individual business rules and decision outcomes.

## Functional Testing

Validates complete user and system workflows.

## Integration Testing

Validates information exchange with external systems.

## Authorization Testing

Validates role, employer, department and record-level access.

## Data Quality Testing

Validates completeness, freshness, consistency, validity and uniqueness.

## Concurrency Testing

Validates simultaneous offers, reservations and placement actions.

## Audit Testing

Validates whether important actions produce complete historical records.

## Reporting Testing

Validates KPI calculations, status separation and privacy suppression.

## Resilience Testing

Validates failure handling, retry, recovery and reconciliation.

# Test Priority

| Priority | Meaning |
|---|---|
| Critical | Failure may create invalid placement, privacy breach or capacity conflict |
| High | Failure materially affects students, employers or governance |
| Medium | Failure affects usability, reporting or operational efficiency |
| Low | Failure has limited business impact |

# Test Status Values

| Status | Meaning |
|---|---|
| Draft | Scenario is still being defined |
| Ready | Scenario is ready for execution |
| Passed | Actual result matches expected result |
| Failed | Actual result differs from expected result |
| Blocked | Scenario cannot be executed because of another issue |
| Deferred | Scenario will be executed later |
| Not Applicable | Scenario does not apply to the tested configuration |

# Test Data Conventions

Example test identifiers use the following pattern:

```text
Student: STUDENT-T001
Employer: EMP-T001
Opportunity: OPP-T001
Application: APP-T001
Recommendation: REC-T001
Offer: OFFER-T001
Placement: PL-T001
```

Example matching-model configuration:

```text
Model version: MATCHING-MODEL-1.0
Score range: 0–100
Standard recommendation threshold: 55
Minimum recommendation confidence: 60
```

Example academic rule configuration:

```text
Minimum academic year: 3
Minimum GPA: 2.50
Minimum completed credits: 120
Required course: Internship Preparation
```

# Student Profile Test Scenarios

## TS-SP-001: Create First Student Profile

**Priority:** High  
**Related Rules:** BR-SP-001  
**Related Requirements:** FR-001

### Preconditions

- The student has a valid university identity.
- No active placement profile exists for the student.

### Test Steps

1. Authenticate as the student.
2. Open the internship placement service.
3. Start profile creation.
4. Save the profile.

### Expected Results

- One active profile is created.
- The profile is connected to the authenticated student identifier.
- Profile status is `draft` or `incomplete`.
- Profile creation time is recorded.
- An audit event is created.

---

## TS-SP-002: Prevent Duplicate Active Profile

**Priority:** High  
**Related Rules:** BR-SP-001

### Preconditions

- One active profile already exists for the student.

### Test Steps

1. Attempt to create another active profile for the same student.

### Expected Results

- The second active profile is rejected.
- The existing profile remains unchanged.
- The response identifies a duplicate active profile conflict.
- No duplicate active record is created.

---

## TS-SP-003: Student Attempts to Edit Authoritative GPA

**Priority:** Critical  
**Related Rules:** BR-SP-002  
**Related Risks:** RC-001

### Preconditions

- The student has an academic record with GPA `3.09`.

### Test Steps

1. Authenticate as the student.
2. Submit a profile update attempting to change GPA to `3.50`.

### Expected Results

- The GPA update is rejected.
- The authoritative GPA remains `3.09`.
- Editable profile fields may still be updated when submitted separately.
- The unauthorized academic-field attempt is logged.

---

## TS-SP-004: Incomplete Mandatory Profile Blocks Application

**Priority:** High  
**Related Rules:** BR-SP-003  
**Related Requirements:** FR-003, FR-017

### Preconditions

- Student profile is missing mandatory availability information.
- Student is otherwise academically eligible.

### Test Steps

1. Attempt to submit an application.

### Expected Results

- Application submission is rejected.
- The response identifies the missing availability section.
- No active application is created.
- The student receives a clear corrective action.

---

## TS-SP-005: Missing Optional Information Does Not Block Application

**Priority:** Medium  
**Related Rules:** BR-SP-004

### Preconditions

- All mandatory profile fields are complete.
- Optional professional summary is empty.

### Test Steps

1. Submit an application to an active opportunity.

### Expected Results

- Application is accepted when all other rules pass.
- Missing optional summary does not become an eligibility failure.
- The system may recommend profile improvement without blocking submission.

---

## TS-SP-006: Duplicate Active Student Skill

**Priority:** Medium  
**Related Rules:** BR-SP-005  
**Related Data Constraint:** One active student-skill record per student and skill

### Preconditions

- The student already has an active SQL skill record.

### Test Steps

1. Attempt to create a second active SQL skill record.

### Expected Results

- Duplicate active skill creation is rejected.
- The user is directed to update the existing skill.
- Historical inactive skill versions remain permitted.

---

## TS-SP-007: Student Preference Versioning

**Priority:** High  
**Related Rules:** BR-SP-007

### Preconditions

- Student preference version 1 lists `Hybrid` as preferred.
- A recommendation was generated using version 1.

### Test Steps

1. Change the preference to `Remote`.
2. Save the new preference set.
3. Review the existing recommendation.

### Expected Results

- Preference version 2 is created.
- Version 1 remains historically available.
- The existing recommendation still references version 1.
- A new evaluation may use version 2.
- The historical recommendation is not silently changed.

---

## TS-SP-008: Detect Conflicting Hard Preferences

**Priority:** High  
**Related Rules:** BR-SP-008

### Preconditions

- Student preference contains:
  - `Remote only` as required
  - `On-site only` as required

### Test Steps

1. Save the preference set.

### Expected Results

- The conflict is detected.
- The system does not silently accept both constraints.
- The student receives a clear conflict message.
- Matching is held until the conflict is resolved.

# Academic Eligibility Test Scenarios

## TS-AE-001: Student Meets All Academic Rules

**Priority:** Critical  
**Related Rules:** BR-AE-001 to BR-AE-008

### Test Data

```text
Enrollment status: Active
Academic program: Eligible
Academic year: 4
GPA: 3.09
Completed credits: 180
Required course: Passed
Previous mandatory internship: Not completed
Internship period: Permitted
```

### Test Steps

1. Run academic eligibility evaluation.

### Expected Results

- Eligibility status is `eligible`.
- Every applicable rule result is stored as `passed`.
- Rule-set version is recorded.
- Academic record identifier is recorded.
- Evaluation timestamp and expiration are stored.

---

## TS-AE-002: Inactive Enrollment Causes Ineligibility

**Priority:** Critical  
**Related Rules:** BR-AE-001

### Preconditions

- Enrollment status is `inactive`.

### Test Steps

1. Run eligibility evaluation.

### Expected Results

- Eligibility status is `ineligible`.
- Active enrollment rule is marked `failed`.
- The observed status is recorded.
- Compatibility evaluation cannot proceed.

---

## TS-AE-003: Minimum Academic Year Boundary Pass

**Priority:** High  
**Related Rules:** BR-AE-003

### Test Data

```text
Required academic year: 3
Student academic year: 3
```

### Expected Results

- Academic-year rule passes.
- Equality with the minimum is accepted.

---

## TS-AE-004: Minimum Academic Year Boundary Fail

**Priority:** High  
**Related Rules:** BR-AE-003

### Test Data

```text
Required academic year: 3
Student academic year: 2
```

### Expected Results

- Academic-year rule fails.
- Eligibility is `ineligible` unless an approved exception policy applies.

---

## TS-AE-005: Minimum GPA Boundary Pass

**Priority:** Critical  
**Related Rules:** BR-AE-004

### Test Data

```text
Minimum GPA: 2.50
Student GPA: 2.50
```

### Expected Results

- GPA rule passes.
- The result does not incorrectly require a value greater than `2.50`.

---

## TS-AE-006: GPA Below Boundary Fails

**Priority:** Critical  
**Related Rules:** BR-AE-004

### Test Data

```text
Minimum GPA: 2.50
Student GPA: 2.49
```

### Expected Results

- GPA rule fails.
- Expected and observed values are stored.
- The student receives an understandable explanation.

---

## TS-AE-007: Missing GPA Produces Data Incomplete

**Priority:** Critical  
**Related Rules:** BR-AE-009, BR-DQ-001

### Preconditions

- GPA is mandatory for the applicable rule.
- Academic source returns no GPA value.

### Test Steps

1. Run eligibility evaluation.

### Expected Results

- Eligibility is `data_incomplete` or `review_required`.
- Missing GPA is not treated as a confirmed GPA failure.
- A data-quality warning is stored.
- A review or source-correction task is created.

---

## TS-AE-008: Stale Academic Record

**Priority:** High  
**Related Rules:** BR-DQ-002

### Preconditions

- Academic record is older than the approved freshness threshold.

### Test Steps

1. Run eligibility evaluation.

### Expected Results

- Record is marked `stale`.
- The configured policy determines whether evaluation is blocked or held for review.
- Stale data is visible to authorized reviewers.
- No silent positive eligibility result is produced when freshness is mandatory.

---

## TS-AE-009: Required Course Completed

**Priority:** High  
**Related Rules:** BR-AE-006

### Test Data

```text
Required course: Internship Preparation
Course status: Passed
```

### Expected Results

- Required-course rule passes.

---

## TS-AE-010: Required Course In Progress

**Priority:** High  
**Related Rules:** BR-AE-006

### Test Data

```text
Required course: Internship Preparation
Course status: In progress
Conditional eligibility policy: Not enabled
```

### Expected Results

- Required-course rule fails.
- `In progress` is not treated as completed.
- The student does not continue to standard matching.

---

## TS-AE-011: Previously Completed Mandatory Internship

**Priority:** High  
**Related Rules:** BR-AE-007

### Preconditions

- Student already completed the same mandatory internship requirement.

### Test Steps

1. Evaluate eligibility for another mandatory placement of the same type.

### Expected Results

- Standard mandatory placement eligibility fails.
- Voluntary internship handling remains separate when permitted.
- The result explains the previous completion condition.

---

## TS-AE-012: Eligibility Recalculation After Academic Change

**Priority:** Critical  
**Related Rules:** BR-AE-014

### Preconditions

- Student was previously ineligible because a required course was incomplete.
- The authoritative record is updated to `passed`.

### Test Steps

1. Receive the academic update.
2. Recalculate eligibility.

### Expected Results

- A new eligibility evaluation is created.
- The new result may become `eligible`.
- The previous evaluation remains available.
- The new academic record and rule version are recorded.

# Academic Exception Test Scenarios

## TS-EX-001: Student Creates Academic Exception Request

**Priority:** High  
**Related Rules:** BR-AE-011, BR-AE-012

### Preconditions

- Student has an eligible exception category.
- A standard academic rule failed.

### Test Steps

1. Submit exception reason and supporting evidence.

### Expected Results

- Exception status is `pending`.
- The request references the exact failed rule.
- No eligibility result is changed yet.
- An academic-review task is created.

---

## TS-EX-002: Student Attempts to Approve Own Exception

**Priority:** Critical  
**Related Rules:** BR-AE-011  
**Related Risk:** RC-003

### Test Steps

1. Authenticate as the student.
2. Attempt to call the academic exception decision operation.

### Expected Results

- Access is denied.
- Exception remains pending.
- The unauthorized action is logged.

---

## TS-EX-003: Career-Center User Without Academic Authority Approves Exception

**Priority:** Critical  
**Related Rules:** BR-AE-011

### Expected Results

- Approval is denied.
- The request remains unchanged.
- The system identifies insufficient academic authority.

---

## TS-EX-004: Authorized Academic Approval

**Priority:** Critical

### Preconditions

- Academic reviewer has the correct department scope.

### Test Steps

1. Approve the exception.
2. Define valid-from and valid-to dates.
3. Recalculate eligibility.

### Expected Results

- Exception becomes `approved`.
- Approver, reason, scope and validity period are stored.
- A new eligibility evaluation uses the exception.
- The original failed rule result remains visible.
- The final eligibility result is traceable to the exception.

---

## TS-EX-005: Expired Exception Cannot Be Reused

**Priority:** Critical  
**Related Rules:** BR-AE-013

### Preconditions

- The exception validity end date has passed.

### Test Steps

1. Run a new eligibility evaluation.

### Expected Results

- Expired exception is not applied.
- The student receives the standard rule result.
- A new exception request is required when permitted.

# Employer and Opportunity Test Scenarios

## TS-EM-001: Register New Employer

**Priority:** High  
**Related Rules:** BR-EM-001

### Expected Results

- Employer status is `pending`.
- Representative information is recorded.
- The employer cannot publish an active opportunity yet.
- Verification task is created.

---

## TS-EM-002: Duplicate Employer Detection

**Priority:** High

### Preconditions

- An employer with the same approved registration identifier exists.

### Test Steps

1. Submit another employer registration.

### Expected Results

- Potential duplicate is detected.
- A second active employer is not created automatically.
- The record is routed for review.

---

## TS-EM-003: Unapproved Employer Attempts to Publish Opportunity

**Priority:** Critical  
**Related Rules:** BR-EM-001

### Expected Results

- Publication is rejected.
- Opportunity may remain a draft.
- No active public opportunity is created.

---

## TS-EM-004: Employer Representative Accesses Another Employer

**Priority:** Critical  
**Related Rules:** BR-EM-003  
**Related Risk:** RC-020

### Preconditions

- Representative belongs to `EMP-T001`.

### Test Steps

1. Attempt to retrieve or update an opportunity owned by `EMP-T002`.

### Expected Results

- Access is denied.
- No record content is disclosed.
- The unauthorized access attempt is logged.

---

## TS-EM-005: Suspend Employer With Active Opportunities

**Priority:** Critical  
**Related Rules:** BR-EM-004

### Test Steps

1. Suspend an active employer.
2. Review the employer's active opportunities.

### Expected Results

- New opportunity publication is blocked.
- Pending opportunities move to review.
- Active offers and placements are flagged for impact review.
- Confirmed placements are not silently deleted.
- Suspension reason and owner are recorded.

---

## TS-OP-001: Create Valid Internship Opportunity

**Priority:** High

### Test Data

```text
Start date: 2026-07-01
End date: 2026-08-31
Application deadline: 2026-05-31 17:00
Capacity: 3
```

### Expected Results

- Opportunity is created in draft or pending-review status.
- Dates and capacity pass validation.
- Opportunity version 1 is recorded.

---

## TS-OP-002: Reject Zero Capacity

**Priority:** Critical  
**Related Rules:** BR-OP-001

### Test Data

```text
Capacity: 0
```

### Expected Results

- Opportunity creation or activation is rejected.
- Error identifies that capacity must be greater than zero.

---

## TS-OP-003: Reject Negative Capacity

**Priority:** Critical

### Test Data

```text
Capacity: -1
```

### Expected Results

- Validation fails.
- No invalid opportunity is activated.

---

## TS-OP-004: Reject End Date Before Start Date

**Priority:** High  
**Related Rules:** BR-OP-002

### Test Data

```text
Start date: 2026-08-01
End date: 2026-07-01
```

### Expected Results

- Opportunity is rejected.
- Date-order error is returned.

---

## TS-OP-005: Reject Application Deadline After Internship Start

**Priority:** High  
**Related Rules:** BR-OP-003

### Test Data

```text
Application deadline: 2026-07-10
Internship start date: 2026-07-01
```

### Expected Results

- Opportunity validation fails.
- No active publication occurs.

---

## TS-OP-006: Opportunity Requires Approval Before Activation

**Priority:** Critical  
**Related Rules:** BR-OP-004

### Test Steps

1. Create a complete opportunity.
2. Attempt to change status directly from draft to active.

### Expected Results

- Direct activation is rejected.
- Required review decisions must be completed.
- Status history records the rejected transition where appropriate.

---

## TS-OP-007: Unclassified Requirement Cannot Exclude Candidate

**Priority:** Critical  
**Related Rules:** BR-OP-005

### Preconditions

- Employer provides a text requirement without mandatory, preferred or optional classification.

### Expected Results

- Requirement cannot act as an automatic exclusion.
- Opportunity is returned for correction or the requirement remains informational.
- Candidate exclusion does not occur from unclassified text.

---

## TS-OP-008: Material Opportunity Change Triggers Reapproval

**Priority:** Critical  
**Related Rules:** BR-OP-006

### Preconditions

- Opportunity is approved and active.

### Test Steps

1. Change working model from `hybrid` to `on_site`.
2. Save the update.

### Expected Results

- A new opportunity version is created.
- Opportunity enters review or restricted state.
- Active applications are identified for reevaluation.
- Affected students are notified when appropriate.
- The old approved version remains available.

# Application Test Scenarios

## TS-AP-001: Submit Valid Application

**Priority:** Critical  
**Related Rules:** BR-AP-001

### Preconditions

- Student profile is complete.
- Student is eligible.
- Opportunity is active.
- Deadline has not passed.
- Application limit is available.
- No duplicate application exists.
- No conflicting placement exists.

### Expected Results

- Application is created.
- Status becomes `submitted`.
- Submission timestamp is stored.
- Profile and preference versions are stored.
- An audit event is created.

---

## TS-AP-002: Submission Exactly at Deadline

**Priority:** High  
**Related Rules:** BR-AP-002

### Test Data

```text
Deadline: 2026-05-31 17:00:00
Submission time: 2026-05-31 17:00:00
```

### Expected Results

- Application is accepted.

---

## TS-AP-003: Submission One Second After Deadline

**Priority:** High  
**Related Rules:** BR-AP-002

### Test Data

```text
Deadline: 2026-05-31 17:00:00
Submission time: 2026-05-31 17:00:01
```

### Expected Results

- Application is rejected.
- No active application is created.
- Deadline failure is explained.

---

## TS-AP-004: Duplicate Active Application

**Priority:** Critical  
**Related Rules:** BR-AP-003

### Preconditions

- Student already has an active application for the opportunity.

### Test Steps

1. Submit the same application again.

### Expected Results

- Duplicate submission is rejected or safely returns the original result when an idempotency key is reused.
- Only one active application exists.

---

## TS-AP-005: Application Limit Boundary

**Priority:** High  
**Related Rules:** BR-AP-004

### Test Data

```text
Maximum active applications: 5
Current active applications: 4
```

### Expected Results

- One additional application is accepted.
- Active application count becomes 5.

---

## TS-AP-006: Application Limit Exceeded

**Priority:** High

### Test Data

```text
Maximum active applications: 5
Current active applications: 5
```

### Expected Results

- Additional application is rejected.
- Existing applications remain unchanged.

---

## TS-AP-007: Withdraw Application Before Cutoff

**Priority:** Medium  
**Related Rules:** BR-AP-005

### Expected Results

- Application status becomes `withdrawn`.
- Withdrawal reason and timestamp are recorded.
- Historical application remains available.
- Related temporary processing is stopped.

---

## TS-AP-008: Invalid Status Transition

**Priority:** Critical  
**Related Rules:** BR-AP-006

### Test Steps

1. Attempt to change a draft application directly to `placement_confirmed`.

### Expected Results

- Transition is rejected.
- Application remains in draft.
- No placement is created.

# Requirement Evaluation Test Scenarios

## TS-RQ-001: All Mandatory Requirements Pass

**Priority:** Critical  
**Related Rules:** BR-RQ-001

### Preconditions

- Student satisfies every mandatory requirement.

### Expected Results

- Each mandatory result is `passed`.
- Combination continues to compatibility evaluation.

---

## TS-RQ-002: One Mandatory Requirement Fails

**Priority:** Critical

### Preconditions

- Student fails a mandatory SQL requirement.

### Expected Results

- Requirement result is `failed`.
- Standard compatibility ranking is not generated.
- Exclusion reason identifies SQL requirement failure.
- Preferred qualifications do not compensate.

---

## TS-RQ-003: Preferred Requirement Fails

**Priority:** High  
**Related Rules:** BR-RQ-002

### Preconditions

- Student fails one preferred Power BI requirement.
- All mandatory requirements pass.

### Expected Results

- Student is not excluded.
- Preferred requirement satisfaction decreases.
- The missing qualification appears in the explanation.

---

## TS-RQ-004: Optional Requirement Fails

**Priority:** Medium  
**Related Rules:** BR-RQ-003

### Expected Results

- Student remains eligible for scoring.
- Optional failure does not create an exclusion.

---

## TS-RQ-005: Mandatory Evidence Missing

**Priority:** Critical  
**Related Rules:** BR-RQ-004

### Preconditions

- Required certification is mandatory.
- Student claims the certification but no required evidence exists.

### Expected Results

- Result is `evidence_missing` or `review_required`.
- It is not incorrectly stored as passed.
- Recommendation generation is held.
- Information request is created.

---

## TS-RQ-006: Verified Skill Requirement With Self-Declared Skill

**Priority:** Critical  
**Related Rules:** BR-RQ-005

### Preconditions

- Opportunity requires verified SQL skill.
- Student SQL skill is self-declared only.

### Expected Results

- Requirement does not pass automatically.
- Result is evidence missing or failed according to policy.
- Verification requirement is shown in the explanation.

---

## TS-RQ-007: Language Boundary Pass

**Priority:** High  
**Related Rules:** BR-RQ-006

### Test Data

```text
Required level: B2
Student level: B2
```

### Expected Results

- Requirement passes.

---

## TS-RQ-008: Language Below Requirement

**Priority:** High

### Test Data

```text
Required level: B2
Student level: B1
```

### Expected Results

- Mandatory language requirement fails.
- Student does not proceed to standard compatibility ranking.

# Matching Model Test Scenarios

## TS-MT-001: Calculate Complete Compatibility Score

**Priority:** Critical  
**Related Rules:** BR-MT-001 to BR-MT-004

### Test Data

| Indicator | Score | Weight |
|---|---:|---:|
| Skill Compatibility | 90 | 0.25 |
| Academic Relevance | 85 | 0.15 |
| Preferred Requirement Satisfaction | 75 | 0.15 |
| Role Preference Alignment | 100 | 0.10 |
| Industry Preference Alignment | 80 | 0.10 |
| Location Compatibility | 70 | 0.08 |
| Working-Model Compatibility | 100 | 0.07 |
| Internship-Period Compatibility | 90 | 0.05 |
| Language Compatibility | 80 | 0.05 |

### Expected Results

```text
Overall compatibility score: 85.60
```

- Each indicator contribution is stored.
- Weight total equals `1.00`.
- Model version is stored.
- Score remains within 0–100.

---

## TS-MT-002: Reject Configuration Whose Weights Do Not Total 100 Percent

**Priority:** Critical

### Test Data

```text
Total active weights: 0.95
```

### Expected Results

- Model configuration cannot become active.
- Validation identifies the invalid weight total.
- Existing active model remains unchanged.

---

## TS-MT-003: Prevent Score Below Zero

**Priority:** Critical  
**Related Rules:** BR-MT-004

### Test Data

```text
Calculated score: -0.01
```

### Expected Results

- Evaluation fails validation.
- Invalid score is not stored as a completed match evaluation.

---

## TS-MT-004: Prevent Score Above 100

**Priority:** Critical

### Test Data

```text
Calculated score: 100.01
```

### Expected Results

- Evaluation fails validation.
- Technical or configuration error is recorded.

---

## TS-MT-005: Missing Mandatory Input Blocks Matching

**Priority:** Critical  
**Related Rules:** BR-MT-005

### Preconditions

- Academic eligibility requires a missing GPA.

### Expected Results

- Standard match score is not calculated.
- Match status is `data_incomplete`.
- The system does not assign a favorable default score.

---

## TS-MT-006: Missing Optional Industry Preference Uses Neutral Treatment

**Priority:** Medium

### Preconditions

- Student has not declared an industry preference.
- The active model defines neutral treatment for undeclared optional preference.

### Expected Results

- Student is not penalized as if the industry were unacceptable.
- The configured neutral value is used.
- The explanation states that no industry preference was declared.

---

## TS-MT-007: Student Hard Constraint Conflict

**Priority:** Critical  
**Related Rules:** BR-MT-006

### Test Data

```text
Student constraint: Remote only
Opportunity: On-site
```

### Expected Results

- Combination is marked incompatible.
- A standard recommendation is not generated.
- The conflict is explained as a student hard constraint.

---

## TS-MT-008: Preference Influences Ranking but Not Eligibility

**Priority:** High

### Preconditions

- Student meets all academic and employer mandatory requirements.
- Industry preference alignment is low.

### Expected Results

- Student remains eligible.
- Compatibility score may decrease.
- Eligibility status remains unchanged.

---

## TS-MT-009: High Compatibility With Low Confidence

**Priority:** High

### Test Data

```text
Compatibility score: 88
Confidence: 57
```

### Expected Results

- Compatibility remains 88.
- Confidence remains 57.
- The values are not merged into one score.
- Standard recommendation is held or flagged according to the minimum-confidence rule.
- Data-quality explanation is visible.

---

## TS-MT-010: Recommendation Threshold Boundary Pass

**Priority:** High

### Test Data

```text
Recommendation threshold: 55
Compatibility score: 55
Confidence: 60
```

### Expected Results

- Score satisfies the threshold.
- Recommendation may be generated when all other rules pass.

---

## TS-MT-011: Recommendation Below Threshold

**Priority:** High

### Test Data

```text
Recommendation threshold: 55
Compatibility score: 54.99
```

### Expected Results

- Standard recommendation is not generated automatically.
- Combination may be classified as limited or sent for review according to policy.

---

## TS-MT-012: Equal Scores Use Documented Tie Handling

**Priority:** High  
**Related Rules:** BR-MT-009

### Test Data

```text
Candidate A score: 82.50
Candidate B score: 82.50
Candidate A preference alignment: 85
Candidate B preference alignment: 75
```

### Expected Results

- Candidate A is ordered first under the documented tie rule.
- The tie-handling factor is visible.
- No hidden factor is used.

---

## TS-MT-013: Recommendation Explanation Completeness

**Priority:** Critical  
**Related Rules:** BR-MT-007  
**Related Risk:** RC-009

### Expected Results

Recommendation includes:

- Eligibility result
- Mandatory requirement results
- Individual indicators
- Indicator weights
- Overall score
- Confidence
- Preference alignment
- Capacity status
- Data-quality status
- Rule version
- Model version
- Human-readable summary

---

## TS-MT-014: Recommendation Does Not Confirm Placement

**Priority:** Critical  
**Related Rules:** BR-MT-008

### Test Steps

1. Generate a very strong recommendation.

### Expected Results

- No placement is created.
- No student acceptance is assumed.
- No employer acceptance is assumed.
- Recommendation status remains separate from placement status.

# Human Review and Override Test Scenarios

## TS-HR-001: Authorized Reviewer Approves Recommendation

**Priority:** Critical

### Preconditions

- Recommendation is pending review.
- Reviewer has the correct permission.

### Expected Results

- Human decision is created as `approved`.
- Reviewer identity, timestamp and reason are stored.
- Original recommendation remains unchanged.
- Approval does not yet create a confirmed placement.

---

## TS-HR-002: Unauthorized User Attempts Recommendation Approval

**Priority:** Critical  
**Related Rules:** BR-HR-001

### Expected Results

- Access is denied.
- Recommendation remains pending.
- Unauthorized action is logged.

---

## TS-HR-003: Blank Decision Reason

**Priority:** High  
**Related Rules:** BR-HR-003

### Test Data

```text
Decision reason: ""
```

### Expected Results

- Decision submission is rejected.
- No final decision is created.

---

## TS-HR-004: Meaningless Decision Reason

**Priority:** High

### Test Data

```text
Decision reason: "Okay"
```

### Expected Results

- Decision is rejected under explanation-quality validation.
- Reviewer is requested to provide a meaningful reason.

---

## TS-HR-005: Request Additional Information

**Priority:** High  
**Related Rules:** BR-HR-006

### Test Steps

1. Reviewer requests proof of certification.
2. Assign a response deadline.

### Expected Results

- Recommendation status becomes `information_required`.
- Responsible party and deadline are recorded.
- Overdue response can generate an alert.
- Recommendation cannot proceed until resolved.

---

## TS-HR-006: Approve Expired Recommendation

**Priority:** Critical  
**Related Rules:** BR-HR-007

### Preconditions

- Recommendation expiration time has passed.

### Expected Results

- Direct approval is rejected.
- Reevaluation is required.
- Expired recommendation remains historical.

---

## TS-HR-007: Human Decision Preserves Original Recommendation

**Priority:** Critical  
**Related Rules:** BR-HR-004

### Preconditions

- Recommendation status is `recommended`.
- Reviewer rejects it.

### Expected Results

- Original recommendation remains `recommended` as the system result.
- Human decision is stored separately as `rejected`.
- Historical explanation remains available.

---

## TS-OV-001: Authorized Operational Override

**Priority:** Critical  
**Related Rules:** BR-OV-001 to BR-OV-005

### Preconditions

- Reviewer has authority for the specified operational override category.
- Supporting evidence exists.

### Expected Results

- Override records original and final results.
- Override category and detailed reason are stored.
- Original recommendation remains unchanged.
- Required audit event is created.

---

## TS-OV-002: Unauthorized Mandatory Academic Rule Override

**Priority:** Critical  
**Related Rules:** BR-OV-002

### Test Steps

1. Career-center user attempts to bypass a mandatory academic prohibition.

### Expected Results

- Override is rejected.
- Academic rule result remains effective.
- No offer can be created from the rejected override.

---

## TS-OV-003: High-Impact Override Requires Secondary Approval

**Priority:** Critical  
**Related Rules:** BR-OV-004

### Preconditions

- Override category is high impact.

### Test Steps

1. Primary reviewer creates override.
2. Attempt to proceed without secondary approval.

### Expected Results

- Override remains pending secondary approval.
- Offer creation is blocked.
- The primary reviewer cannot approve their own secondary approval.

---

## TS-OV-004: Secondary Approver Is Same as Primary Reviewer

**Priority:** Critical

### Expected Results

- Secondary approval is rejected.
- Segregation-of-duties violation is recorded.

---

## TS-OV-005: Override Reason and Evidence Missing

**Priority:** High

### Expected Results

- Override creation is rejected.
- No downstream decision is changed.

# Capacity and Offer Test Scenarios

## TS-CP-001: Application Does Not Consume Capacity

**Priority:** Critical  
**Related Rules:** BR-CP-003

### Preconditions

```text
Total capacity: 2
Confirmed placements: 0
Active reservations: 0
```

### Test Steps

1. Submit five valid applications.

### Expected Results

```text
Available capacity: 2
```

- Applications do not reduce capacity.

---

## TS-CP-002: Recommendation Does Not Consume Capacity

**Priority:** Critical

### Test Steps

1. Generate recommendations for three students.

### Expected Results

- Available capacity remains unchanged.
- No reservation is created until an approved offer is issued.

---

## TS-CP-003: Offer Creates Reservation

**Priority:** Critical  
**Related Rules:** BR-CP-004

### Preconditions

```text
Total capacity: 2
Confirmed placements: 0
Active reservations: 0
Available capacity: 2
```

### Test Steps

1. Create one valid placement offer.

### Expected Results

```text
Active reservations: 1
Available capacity: 1
```

- Reservation references the offer and student.
- Reservation expiration matches the approved offer period.

---

## TS-CP-004: Student Decline Releases Reservation

**Priority:** Critical  
**Related Rules:** BR-CP-005

### Preconditions

- Offer has one active reservation.

### Test Steps

1. Student declines the offer.

### Expected Results

- Offer status becomes declined.
- Reservation becomes released.
- Available capacity increases by one.
- Release event is audited.

---

## TS-CP-005: Expired Offer Releases Reservation

**Priority:** Critical

### Preconditions

- Offer passes its expiration time without response.

### Test Steps

1. Run the expiration process.

### Expected Results

- Offer status becomes expired.
- Active reservation is released or expired.
- Capacity is recalculated.
- Student and responsible staff are notified.

---

## TS-CP-006: Prevent Negative Capacity

**Priority:** Critical  
**Related Rules:** BR-CP-002

### Preconditions

```text
Total capacity: 1
Active reservations: 1
Available capacity: 0
```

### Test Steps

1. Attempt to create a second reservation.

### Expected Results

- Transaction is rejected.
- Available capacity remains zero.
- No partial offer or reservation is created.

---

## TS-CP-007: Concurrent Reservation Requests for Final Position

**Priority:** Critical  
**Related Rules:** BR-CP-007  
**Related Risk:** RC-013

### Preconditions

```text
Total capacity: 1
Available capacity: 1
```

### Test Steps

1. Send two valid offer-creation requests at the same time.

### Expected Results

- Only one transaction succeeds.
- The other receives a capacity conflict.
- One active reservation exists.
- Available capacity becomes zero.
- No negative capacity occurs.

---

## TS-OF-001: Offer Expiration Equal to Creation Time

**Priority:** High  
**Related Rules:** BR-OF-003

### Test Data

```text
Offer creation: 2026-05-01 12:00
Offer expiration: 2026-05-01 12:00
```

### Expected Results

- Offer creation is rejected.
- Expiration must be later than creation.

---

## TS-OF-002: Student Explicitly Accepts Offer

**Priority:** Critical  
**Related Rules:** BR-OF-005

### Expected Results

- Student response becomes accepted.
- Response timestamp is recorded.
- Employer and other approvals remain separate.
- Final placement is not yet confirmed unless all prerequisites pass.

---

## TS-OF-003: No Response Does Not Equal Acceptance

**Priority:** Critical

### Preconditions

- Student opens the offer but submits no decision.

### Expected Results

- Response remains pending.
- No placement is created.
- Offer may later expire.

---

## TS-OF-004: Employer Representative Responds to Another Employer's Offer

**Priority:** Critical  
**Related Rules:** BR-OF-007

### Expected Results

- Access is denied.
- Offer remains unchanged.
- Unauthorized action is logged.

---

## TS-OF-005: Offer Conditions Differ From Approved Opportunity

**Priority:** Critical  
**Related Rules:** BR-OF-008

### Preconditions

- Approved opportunity is hybrid.
- Proposed offer is on-site.

### Expected Results

- Offer creation is blocked or routed for reapproval.
- Student does not receive an inconsistent offer.
- Material difference is recorded.

# Final Placement Test Scenarios

## TS-PL-001: Confirm Placement With All Preconditions

**Priority:** Critical  
**Related Rules:** BR-PL-001

### Preconditions

- Student accepted.
- Employer accepted.
- Career-center approval exists.
- Academic approval exists where required.
- Opportunity is active.
- Valid reservation exists.
- Required documents are complete.
- No conflicting placement exists.

### Expected Results

- Placement is created as `confirmed`.
- Reservation becomes consumed.
- Confirmed capacity increases by one.
- Related application and offer statuses are updated.
- Placement confirmation audit event is created.

---

## TS-PL-002: Missing Student Acceptance Blocks Confirmation

**Priority:** Critical

### Expected Results

- Placement creation is rejected.
- Reservation remains governed by offer policy.
- Missing student acceptance is identified.

---

## TS-PL-003: Missing Employer Acceptance Blocks Confirmation

**Priority:** Critical

### Expected Results

- Placement creation is rejected.
- Employer response remains required.

---

## TS-PL-004: Academic Approval and Employer Acceptance Remain Separate

**Priority:** Critical  
**Related Rules:** BR-PL-002

### Preconditions

- Employer accepted.
- Academic approval is still pending.

### Expected Results

- Placement is not confirmed.
- Employer acceptance does not automatically set academic approval.

---

## TS-PL-005: Prevent Duplicate Placement for Same Offer

**Priority:** Critical

### Test Steps

1. Submit the placement-confirmation request twice using the same idempotency key.

### Expected Results

- Only one placement exists.
- Repeated request returns the original result or a controlled duplicate response.
- Capacity is consumed only once.

---

## TS-PL-006: Prevent Overlapping Confirmed Placements

**Priority:** Critical  
**Related Rules:** BR-PL-003, BR-PL-004

### Preconditions

Existing placement:

```text
1 July 2026–31 August 2026
```

New proposed placement:

```text
1 August 2026–30 September 2026
```

### Expected Results

- Overlap is detected.
- New placement is rejected unless an authorized policy exception exists.
- Existing placement remains unchanged.

---

## TS-PL-007: Non-Overlapping Placement Dates

**Priority:** High

### Preconditions

Existing placement:

```text
1 July 2026–31 July 2026
```

New proposed placement:

```text
1 August 2026–31 August 2026
```

### Expected Results

- No overlap is detected when date rules permit consecutive periods.
- Other placement rules continue normally.

---

## TS-PL-008: Confirmed Placement Cannot Be Hard Deleted

**Priority:** Critical  
**Related Rules:** BR-PL-005

### Test Steps

1. Attempt to permanently delete a confirmed placement through a standard user operation.

### Expected Results

- Hard deletion is rejected.
- Cancellation or correction workflow is offered.
- Historical record remains available.

---

## TS-PL-009: Controlled Placement Cancellation

**Priority:** Critical  
**Related Rules:** BR-PL-006

### Test Steps

1. Submit cancellation reason and effective date.
2. Obtain required approval.

### Expected Results

- Placement status changes through an approved transition.
- Cancellation reason, requesting party and approver are stored.
- Capacity impact is calculated.
- Replacement support is created when required.
- Original placement remains historical.

---

## TS-PL-010: External Student-Sourced Internship Requires Review

**Priority:** High  
**Related Rules:** BR-PL-008

### Preconditions

- Student reports an internship found independently.

### Expected Results

- It is not immediately recorded as confirmed.
- Employer and opportunity review are required.
- Academic suitability is checked.
- Final placement uses the controlled confirmation workflow.

# Internship Outcome Test Scenarios

## TS-OT-001: Record Successful Internship Completion

**Priority:** High  
**Related Rules:** BR-OT-001

### Preconditions

- Confirmed placement exists.
- Required completion evidence is available.

### Expected Results

- Outcome becomes `successfully_completed`.
- Completion date is stored.
- Student and employer evaluation statuses are stored.
- Placement may become completed.
- Audit event is created.

---

## TS-OT-002: Internship Completion Does Not Automatically Approve Academic Credit

**Priority:** Critical  
**Related Rules:** BR-OT-002

### Preconditions

- Internship outcome is successfully completed.
- Academic-credit review is pending.

### Expected Results

- Outcome remains successfully completed.
- Academic-credit status remains pending.
- The two statuses are not merged.

---

## TS-OT-003: Outcome Without Placement

**Priority:** Critical

### Test Steps

1. Attempt to create an outcome for a non-existent placement.

### Expected Results

- Request is rejected.
- No orphan outcome record is created.

---

## TS-OT-004: Outcome Correction Preserves History

**Priority:** High

### Preconditions

- Outcome was incorrectly recorded as failed.
- Authorized evidence shows successful completion.

### Test Steps

1. Submit a controlled correction.

### Expected Results

- New outcome version is created.
- Previous version remains available.
- Correction reason and author are recorded.
- Affected KPI results can be recalculated with version traceability.

---

## TS-OT-005: Final Outcome Does Not Rewrite Historical Recommendation

**Priority:** Critical  
**Related Rules:** BR-OT-005

### Preconditions

- Historical recommendation score is 82.
- Internship outcome is failed.

### Expected Results

- Historical recommendation remains 82.
- Outcome is linked for later analysis.
- No silent score modification occurs.

# Intervention Test Scenarios

## TS-IN-001: Eligible Student With No Application

**Priority:** High  
**Related Rules:** BR-MT-010

### Preconditions

- Student is eligible.
- Application deadline is approaching.
- Student has no active application.

### Expected Results

- Intervention case is created or proposed.
- Reason is `no_active_application`.
- Priority reflects the remaining time.
- Case is assigned to authorized staff.

---

## TS-IN-002: Student Has Applications but No Recommendation

**Priority:** High

### Preconditions

- Student has valid applications.
- No active recommendation exists.

### Expected Results

- No-recommendation reason is identified.
- Intervention case references relevant applications.
- Staff can distinguish requirement mismatch, capacity issue and missing evidence.

---

## TS-IN-003: Cancelled Placement Creates Replacement Support

**Priority:** Critical

### Preconditions

- Student's confirmed placement is cancelled near the deadline.

### Expected Results

- Intervention priority is critical or high.
- Replacement-support requirement is recorded.
- Responsible staff receive an alert.

---

## TS-IN-004: Student Preferences Are Not Changed Automatically

**Priority:** Critical

### Preconditions

- Student remains unplaced because of restrictive preferences.

### Expected Results

- System may recommend preference review.
- Student preference values remain unchanged.
- Staff cannot silently weaken hard constraints.

# Authorization and Privacy Test Scenarios

## TS-AU-001: Student Views Own Profile

**Priority:** High

### Expected Results

- Student can view permitted own profile information.
- Restricted internal notes are not exposed.

---

## TS-AU-002: Student Views Another Student's Profile

**Priority:** Critical

### Expected Results

- Access is denied.
- No profile data is returned.
- Attempt is logged.

---

## TS-AU-003: Employer Views Candidate Before Approved Review Stage

**Priority:** Critical  
**Related Rule:** BR-GV-006

### Expected Results

- Candidate access is denied.
- Employer receives no student information.

---

## TS-AU-004: Employer Views Approved Candidate

**Priority:** High

### Preconditions

- Candidate is in an approved employer-review stage.
- Employer owns the opportunity.

### Expected Results

- Employer sees only approved candidate fields.
- Other applications and internal notes are hidden.
- Access event is logged.

---

## TS-AU-005: Employer Attempts Bulk Candidate Export Without Permission

**Priority:** Critical  
**Related Risk:** RC-021

### Expected Results

- Export is denied or limited.
- View permission does not automatically grant export permission.
- High-volume request is logged.

---

## TS-AU-006: Sensitive Support Information Excluded From Matching

**Priority:** Critical  
**Related Rule:** BR-GV-007

### Preconditions

- Student has restricted accessibility or support information.

### Expected Results

- Sensitive information is not included as a general matching indicator.
- It is not shown to employers.
- Approved purpose-specific staff access remains separate.

---

## TS-AU-007: Career-Center User Accesses Academic Exception Outside Scope

**Priority:** Critical

### Expected Results

- Access is denied or limited to routing information.
- Academic decision details remain restricted according to role.

---

## TS-AU-008: Privileged User Role Removal

**Priority:** Critical

### Preconditions

- Staff member previously had override permission.
- Permission is removed.

### Test Steps

1. Attempt to create another override.

### Expected Results

- Override operation is denied immediately or after the approved access-propagation period.
- Old permission is not retained.

# Auditability Test Scenarios

## TS-AD-001: Eligibility Decision Audit Event

**Priority:** High

### Expected Results

Audit event contains:

- Event identifier
- System or user actor
- Student or evaluation entity
- Timestamp
- Result
- Rule-set version
- Correlation identifier

---

## TS-AD-002: Opportunity Change Audit History

**Priority:** High

### Preconditions

- Approved opportunity capacity changes from 3 to 2.

### Expected Results

- Previous and new values are recorded.
- Change reason and actor are stored.
- New opportunity version is created.
- Impact review is traceable.

---

## TS-AD-003: Manual Override Audit Completeness

**Priority:** Critical

### Expected Results

Audit history includes:

- Original result
- Final result
- Override category
- Reviewer
- Supporting evidence
- Secondary approval when required
- Timestamps

---

## TS-AD-004: Placement Status History

**Priority:** Critical

### Test Steps

1. Confirm placement.
2. Activate placement.
3. Complete placement.

### Expected Results

- Every transition is recorded.
- Previous and new statuses are preserved.
- Final record is reconstructable.

---

## TS-AD-005: Audit Event Cannot Be Edited by Normal User

**Priority:** Critical

### Expected Results

- Normal user cannot modify or delete audit history.
- Unauthorized attempt is logged.

# Integration Test Scenarios

## TS-IG-001: Receive Valid Academic Record

**Priority:** Critical

### Expected Results

- Record is accepted.
- Source identifier and source timestamp are stored.
- Current academic record is updated through a controlled version.
- Eligibility reevaluation may be triggered.

---

## TS-IG-002: Receive Duplicate Integration Message

**Priority:** Critical  
**Related Risk:** RC-022

### Preconditions

- A message with the same source and idempotency identifier was already processed.

### Expected Results

- No duplicate academic record is created.
- The original result is reused or duplicate is safely ignored.
- Processing event is logged.

---

## TS-IG-003: Receive Out-of-Order Older Academic Record

**Priority:** Critical

### Preconditions

- Current academic record source timestamp is newer than the incoming message.

### Expected Results

- Older message does not silently replace the current record.
- Message is ignored, quarantined or reviewed according to policy.
- Data freshness remains correct.

---

## TS-IG-004: Invalid Integration Schema

**Priority:** High

### Preconditions

- Required student identifier is missing.

### Expected Results

- Message is rejected.
- Partial student update does not occur.
- Structured error is recorded.
- Message is available for controlled retry or correction.

---

## TS-IG-005: Notification Delivery Failure

**Priority:** High  
**Related Risk:** RC-024

### Preconditions

- Placement offer notification fails.

### Expected Results

- Offer remains visible in the system.
- Delivery failure is recorded.
- Retry is attempted.
- Staff alert is generated before the response deadline when necessary.

---

## TS-IG-006: Integration Fails During Multi-Step Update

**Priority:** Critical

### Test Steps

1. Begin an update that creates a record and changes a status.
2. Simulate failure before completion.

### Expected Results

- No invalid partial business state remains.
- Transaction is rolled back or safely marked incomplete.
- Retry does not duplicate completed actions.

# Reporting and KPI Test Scenarios

## TS-KPI-001: Academic Eligibility Rate

**Priority:** High

### Test Data

```text
Eligible: 80
Ineligible: 15
Review required: 3
Data incomplete: 2
```

### Expected Result

Using only completed eligible and ineligible results:

```text
Academic eligibility rate =
80 / (80 + 15) × 100
= 84.21%
```

- Review-required and data-incomplete populations are reported separately.

---

## TS-KPI-002: Placement Rate Uses Eligible Student Denominator

**Priority:** Critical

### Test Data

```text
Eligible students: 100
Confirmed placed students: 85
```

### Expected Result

```text
Student placement rate = 85%
```

- Recommendations and offers are not counted as confirmed placements.

---

## TS-KPI-003: Capacity Utilization

**Priority:** Critical

### Test Data

```text
Total approved capacity: 40
Confirmed placements: 30
```

### Expected Result

```text
Capacity utilization rate = 75%
```

- Active reservations are not counted as confirmed placements.

---

## TS-KPI-004: Recommendation Effectiveness Uses Final Outcomes

**Priority:** High

### Test Data

```text
Completed placements linked to recommendations: 20
Successfully completed: 18
Under review: 2
```

### Expected Result

When `under review` is excluded from the final-outcome denominator:

```text
Recommendation effectiveness rate = 18 / 18 × 100 = 100%
```

- Report clearly states the denominator.
- The result is not presented as proof of causation.

---

## TS-KPI-005: Small-Group Suppression

**Priority:** Critical  
**Related Rule:** BR-GV-009

### Preconditions

```text
Minimum reportable group size: 5
Group size: 3
```

### Expected Results

- Group rate is suppressed.
- Individual counts are not exposed when they enable re-identification.
- Authorized detailed operational access remains separate.

---

## TS-KPI-006: KPI Definition Versioning

**Priority:** High

### Preconditions

- Placement-rate denominator changes in a new approved KPI version.

### Expected Results

- New reports use the new definition version.
- Historical reports retain the old definition.
- Results are not silently overwritten.

---

## TS-KPI-007: Recommendation Concentration Alert

**Priority:** High

### Preconditions

- Top 10 percent of students receive more recommendations than the approved threshold.

### Expected Results

- Governance alert is created.
- No student score is changed automatically.
- Review includes opportunity supply, preferences, qualifications and data quality.

# Resilience and Recovery Test Scenarios

## TS-RS-001: Matching Service Temporary Failure

**Priority:** High

### Test Steps

1. Submit a valid match-evaluation request.
2. Simulate temporary service failure.

### Expected Results

- Application remains valid.
- Request is retried or queued safely.
- No duplicate match evaluation is created.
- User receives a controlled status.

---

## TS-RS-002: Offer Expiration Process Failure

**Priority:** Critical

### Preconditions

- Several offers are due to expire.

### Test Steps

1. Simulate scheduled expiration job failure.
2. Run the detective capacity report.

### Expected Results

- Expired offers with active reservations are detected.
- Operations receive an alert.
- Recovery process releases reservations once safely resumed.
- Capacity reconciliation returns to the correct state.

---

## TS-RS-003: Restore From Backup

**Priority:** Critical  
**Related Risk:** RC-030

### Test Steps

1. Restore an approved backup into the recovery environment.
2. Reconcile active placement-cycle records.

### Expected Results

The following reconcile correctly:

- Applications
- Latest eligibility evaluations
- Recommendations
- Offers
- Active reservations
- Confirmed placements
- Capacity
- Audit events

---

## TS-RS-004: Recovery Does Not Duplicate Integration Events

**Priority:** Critical

### Preconditions

- Integration messages are replayed after recovery.

### Expected Results

- Previously processed messages do not create duplicate records.
- Idempotency controls remain effective.

# End-to-End Test Scenarios

## TS-E2E-001: Standard Successful Placement

**Priority:** Critical

### Scenario

A student completes the full standard placement lifecycle without exceptions.

### Test Flow

1. Student authenticates.
2. Student completes profile.
3. Academic information is retrieved.
4. Student becomes eligible.
5. Active employer creates an opportunity.
6. Opportunity is reviewed and approved.
7. Student submits application.
8. Mandatory requirements pass.
9. Compatibility score and confidence are calculated.
10. Recommendation is generated.
11. Career-center reviewer approves it.
12. Placement offer is created.
13. Capacity is reserved.
14. Student accepts.
15. Employer accepts.
16. Academic and administrative prerequisites are completed.
17. Placement is confirmed.
18. Capacity reservation is consumed.
19. Internship becomes active.
20. Internship is completed.
21. Student and employer evaluations are recorded.
22. Final outcome is successfully completed.

### Expected Results

- Every stage uses a controlled status.
- All material actions are audited.
- Recommendation remains separate from human decision.
- Offer remains separate from placement.
- Capacity remains correct.
- Outcome remains linked to the original evaluation chain.

---

## TS-E2E-002: Academic Exception Placement

**Priority:** Critical

### Scenario

A student fails one permitted academic rule but receives an authorized
exception.

### Expected Flow

1. Standard eligibility result is not eligible.
2. Student submits exception request.
3. Academic authority approves the specific exception.
4. A new eligibility evaluation becomes eligible.
5. Matching and placement proceed normally.
6. Final placement remains traceable to the academic exception.

### Expected Results

- Original failed rule remains visible.
- Exception scope and dates are preserved.
- Unauthorized roles cannot approve the exception.
- Final placement audit trail includes the exception reference.

---

## TS-E2E-003: Mandatory Requirement Failure

**Priority:** Critical

### Scenario

A student is academically eligible but fails a mandatory language requirement.

### Expected Results

- Application remains historically available.
- Mandatory requirement result is failed.
- Standard compatibility ranking is not generated.
- Student receives an authorized explanation.
- Preferred qualifications do not override the failure.
- No placement offer is created.

---

## TS-E2E-004: Offer Declined and Capacity Reused

**Priority:** Critical

### Scenario

The first student declines an offer and the position is offered to another
student.

### Expected Flow

1. First recommendation approved.
2. Offer created.
3. Capacity reserved.
4. First student declines.
5. Reservation is released.
6. Second approved recommendation receives an offer.
7. Capacity is reserved again.
8. Second student accepts.
9. Final placement is confirmed.

### Expected Results

- Capacity is never negative.
- First offer remains historical.
- Second offer uses the released capacity.
- Only one final placement consumes the position.

---

## TS-E2E-005: Student Remains Unplaced and Receives Intervention

**Priority:** High

### Scenario

An eligible student receives no active recommendation near the placement
deadline.

### Expected Results

- Student is detected by the no-recommendation process.
- Intervention case is created.
- Reason and priority are recorded.
- Staff action is assigned.
- Student preferences are not changed automatically.
- Support outcome is auditable.

---

## TS-E2E-006: Employer Suspension During Active Process

**Priority:** Critical

### Scenario

An employer is suspended after applications and offers exist.

### Expected Results

- New employer activity is blocked.
- Active opportunities and offers are reviewed.
- Students and staff receive appropriate notifications.
- Confirmed placements are assessed individually.
- No records are silently deleted.
- All decisions are documented.

# Negative and Abuse Test Scenarios

## TS-NEG-001: SQL Injection Attempt in Search Field

**Priority:** Critical

### Expected Results

- Input is treated safely.
- Database query is not altered.
- No unauthorized records are returned.
- Security event is logged when appropriate.

---

## TS-NEG-002: Unauthorized Object Identifier Manipulation

**Priority:** Critical

### Test Steps

1. Employer changes an opportunity identifier in the API path to another employer's record.

### Expected Results

- Access is denied.
- No cross-employer data is exposed.

---

## TS-NEG-003: Excessively Long Free-Text Reason

**Priority:** Medium

### Preconditions

- Submitted reason exceeds the documented maximum length.

### Expected Results

- Request is rejected with field validation.
- No truncated misleading decision is stored silently.

---

## TS-NEG-004: Unsupported Status Value

**Priority:** High

### Test Data

```text
Application status: maybe_selected
```

### Expected Results

- Status is rejected.
- Controlled vocabulary remains enforced.

---

## TS-NEG-005: Repeated Placement Confirmation Request

**Priority:** Critical

### Expected Results

- Idempotency prevents duplicate placement and duplicate capacity consumption.

---

## TS-NEG-006: Tampered Profile Version

**Priority:** High

### Preconditions

- User submits an update using an outdated entity version.

### Expected Results

- Update receives a precondition or version conflict.
- Newer record is not overwritten.
- User can reload the current version.

# Test Traceability Matrix

| Test Area | Main Test Scenarios | Related Artifacts |
|---|---|---|
| Student profile | TS-SP-001 to TS-SP-008 | Requirements, business rules, data model |
| Academic eligibility | TS-AE-001 to TS-AE-012 | Requirements, business rules |
| Academic exceptions | TS-EX-001 to TS-EX-005 | Business rules, risk controls |
| Employers | TS-EM-001 to TS-EM-005 | Stakeholders, requirements, risk controls |
| Opportunities | TS-OP-001 to TS-OP-008 | Requirements, business rules |
| Applications | TS-AP-001 to TS-AP-008 | Process, requirements, API contract |
| Requirement evaluation | TS-RQ-001 to TS-RQ-008 | Business rules, matching model |
| Matching | TS-MT-001 to TS-MT-014 | Matching model, KPI framework |
| Human review | TS-HR-001 to TS-HR-007 | Requirements, risk controls |
| Overrides | TS-OV-001 to TS-OV-005 | Business rules, governance controls |
| Capacity | TS-CP-001 to TS-CP-007 | Business rules, analytics, risk controls |
| Offers | TS-OF-001 to TS-OF-005 | API contract, process model |
| Placements | TS-PL-001 to TS-PL-010 | Requirements, data model, risk controls |
| Outcomes | TS-OT-001 to TS-OT-005 | Data model, KPI framework |
| Intervention | TS-IN-001 to TS-IN-004 | To-be process, KPI framework |
| Authorization | TS-AU-001 to TS-AU-008 | Stakeholders, privacy and security controls |
| Auditability | TS-AD-001 to TS-AD-005 | Data model, risk controls |
| Integrations | TS-IG-001 to TS-IG-006 | API contract, risk controls |
| KPI reporting | TS-KPI-001 to TS-KPI-007 | KPI framework, analytics SQL |
| Recovery | TS-RS-001 to TS-RS-004 | Risk controls |
| End-to-end | TS-E2E-001 to TS-E2E-006 | All case artifacts |
| Negative testing | TS-NEG-001 to TS-NEG-006 | API, security and control requirements |

# Critical Regression Test Set

The following scenarios should be included in every major release:

1. TS-AE-001: Student meets all academic rules
2. TS-AE-005: Minimum GPA boundary pass
3. TS-AE-007: Missing GPA produces data incomplete
4. TS-EX-002: Student cannot approve own exception
5. TS-EM-004: Employer cannot access another employer
6. TS-OP-002: Zero capacity rejected
7. TS-AP-002: Submission exactly at deadline
8. TS-AP-003: Submission after deadline rejected
9. TS-RQ-002: Mandatory requirement failure blocks ranking
10. TS-MT-001: Compatibility calculation
11. TS-MT-009: Compatibility and confidence remain separate
12. TS-MT-014: Recommendation does not confirm placement
13. TS-HR-002: Unauthorized reviewer rejected
14. TS-OV-003: High-impact override requires secondary approval
15. TS-CP-006: Negative capacity prevented
16. TS-CP-007: Concurrent reservation control
17. TS-OF-003: No response does not equal acceptance
18. TS-PL-001: Valid final placement confirmation
19. TS-PL-006: Overlapping placement prevented
20. TS-AU-006: Sensitive support information excluded from matching
21. TS-IG-002: Duplicate integration message handled safely
22. TS-KPI-005: Small-group reporting suppressed
23. TS-RS-002: Expired reservation recovery
24. TS-E2E-001: Complete successful placement lifecycle

# Test Evidence Requirements

Each executed scenario should retain:

- Test scenario identifier
- Test environment
- Application or build version
- Rule-set version
- Matching-model version
- Test-data identifiers
- Execution date
- Tester
- Request or action performed
- Expected result
- Actual result
- Response code where applicable
- Screenshots or logs where appropriate
- Database or audit evidence where authorized
- Defect identifier when failed
- Retest result
- Final status

# Defect Severity

| Severity | Meaning | Example |
|---|---|---|
| Critical | Invalid placement, privacy breach or capacity corruption | Duplicate confirmed placements |
| High | Major process or authorization failure | Unauthorized override |
| Medium | Material workflow or reporting issue | Incorrect warning message |
| Low | Minor display or usability issue | Label inconsistency |

# Test Exit Criteria

Testing may be considered complete when:

- All critical scenarios are executed.
- All critical defects are resolved.
- No unresolved defect can produce negative capacity.
- No unresolved defect can create duplicate confirmed placements.
- Academic eligibility boundary tests pass.
- Mandatory requirements are evaluated before matching.
- Recommendation evidence is complete.
- Authorization tests pass for student, employer, academic and staff roles.
- High-impact overrides require secondary approval.
- Sensitive information is excluded from general matching.
- Audit records are complete for material actions.
- Integration retries do not create duplicates.
- Capacity reconciliation returns no unexplained exception.
- KPI formulas produce approved results.
- Small-group reporting controls operate correctly.
- End-to-end placement workflows pass.
- Recovery and reconciliation tests are completed.

# Test Scenario Summary

The Internship Placement and Matching System requires more than standard form
validation.

The test strategy must verify the complete decision lifecycle:

1. Student profile readiness
2. Academic eligibility
3. Academic exception authority
4. Employer verification
5. Opportunity approval
6. Application validation
7. Mandatory requirement evaluation
8. Compatibility calculation
9. Recommendation explainability
10. Human review
11. Manual override control
12. Offer and capacity management
13. Student and employer acceptance
14. Final placement confirmation
15. Internship outcome
16. Intervention
17. Privacy
18. Security
19. Auditability
20. Reporting and recovery

The most important test principle is that the system must preserve the
difference between:

- Eligibility
- Compatibility
- Recommendation
- Human approval
- Offer
- Student acceptance
- Employer acceptance
- Academic approval
- Confirmed placement
- Internship outcome

A successful test result demonstrates not only that the workflow operates, but
also that decisions remain explainable, authorized, traceable and safe.

The next document will summarize the full internship placement case, its
business problem, proposed solution, major design decisions, expected value and
portfolio relevance.
