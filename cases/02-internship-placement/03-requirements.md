# System Requirements

## Case

Internship Placement and Matching System

## Domain

University Career Services and Internship Operations

## Document Purpose

This document defines the functional, non-functional, data, security,
integration and governance requirements of the Internship Placement and
Matching System.

The requirements translate the business problems and stakeholder needs into
testable system capabilities.

The system is intended to support:

- Student-profile management
- Academic eligibility validation
- Employer and opportunity management
- Internship applications
- Student preferences
- Candidate compatibility evaluation
- Explainable placement recommendations
- Human review and override
- Opportunity-capacity management
- Placement offers
- Final placement confirmation
- Internship outcome monitoring
- Reporting, governance and auditability

## Requirement Priorities

Requirements use the following priority levels.

| Priority | Meaning |
|---|---|
| Must Have | Required for the initial system to operate safely and correctly |
| Should Have | Important but may be delivered after core capabilities |
| Could Have | Valuable enhancement that is not essential for the initial release |
| Future | Planned for a later stage or separate implementation |

## Requirement Status Values

| Status | Meaning |
|---|---|
| Draft | Requirement is still under analysis |
| Proposed | Requirement is ready for stakeholder review |
| Approved | Requirement has been accepted |
| Deferred | Requirement has been postponed |
| Rejected | Requirement will not be implemented |
| Superseded | Requirement has been replaced by another requirement |

# Functional Requirements

## Student Profile Management

### FR-001: Create Student Profile

**Priority:** Must Have  
**Status:** Proposed

The system shall create an internship profile for each authenticated student
who is permitted to participate in the placement process.

The profile shall be associated with the student's university identity.

### Acceptance Conditions

- A student profile is connected to one university student identifier.
- Duplicate active profiles are not permitted.
- The system records the profile-creation timestamp.
- The system identifies the source of imported academic information.
- Students cannot create profiles for other students.

---

### FR-002: Maintain Student Profile

**Priority:** Must Have  
**Status:** Proposed

The system shall allow students to maintain permitted profile information,
including:

- Career interests
- Technical skills
- Business skills
- Language proficiency
- Certifications
- Project experience
- Location preferences
- Working-model preferences
- Internship-period availability
- Industry preferences
- Role preferences

Academic information obtained from authoritative university systems shall not
be directly editable by students.

### Acceptance Conditions

- Editable and non-editable fields are clearly distinguished.
- Changes are timestamped.
- Important changes are included in audit history.
- Invalid or unsupported values are rejected.
- Students can view the current profile-completeness status.

---

### FR-003: Calculate Profile Completeness

**Priority:** Must Have  
**Status:** Proposed

The system shall calculate whether a student profile contains the information
required for application and matching.

The completeness result shall identify:

- Completed sections
- Missing required sections
- Missing required documents
- Invalid information
- Expired information
- Recommended optional improvements

### Acceptance Conditions

- The system distinguishes required and optional information.
- A missing optional field does not block application submission.
- Missing mandatory information prevents affected actions.
- The student receives a clear explanation of incomplete sections.

---

### FR-004: Manage Student Skills

**Priority:** Must Have  
**Status:** Proposed

The system shall allow students to declare skills using a controlled skill
catalog.

Each student skill may include:

- Skill identifier
- Proficiency level
- Experience duration
- Evidence type
- Verification status
- Last-used date

### Acceptance Conditions

- Duplicate student-skill records are prevented.
- Proficiency uses an approved scale.
- Unverified self-declared skills are distinguishable from verified skills.
- Sensitive or irrelevant attributes are not treated as general skills.

---

### FR-005: Manage Student Preferences

**Priority:** Must Have  
**Status:** Proposed

The system shall allow students to define internship preferences.

Preferences may include:

- Preferred industries
- Preferred roles
- Preferred employers
- Preferred cities
- Acceptable travel distance
- Remote, hybrid or on-site working model
- Internship start and end periods
- Compensation preference
- Language preference
- Unacceptable conditions

Students shall be able to identify whether each preference is:

- Required
- Strongly preferred
- Preferred
- Neutral

### Acceptance Conditions

- Required preferences are clearly distinguished from ranking preferences.
- Conflicting preferences are detected.
- Preference changes are versioned.
- Changes made after application submission do not silently alter historical
  evaluations.

---

## Academic Eligibility

### FR-006: Retrieve Academic Information

**Priority:** Must Have  
**Status:** Proposed

The system shall retrieve or receive authoritative academic information needed
for internship eligibility evaluation.

Relevant information may include:

- Academic program
- Department
- Current academic year
- GPA
- Completed credits
- Completed courses
- Active enrollment status
- Previous internship completion
- Graduation status
- Academic restrictions

### Acceptance Conditions

- The source and retrieval time are recorded.
- Students cannot directly alter authoritative academic values.
- Missing academic data is reported.
- Stale data is identified according to an approved freshness rule.

---

### FR-007: Evaluate Academic Eligibility

**Priority:** Must Have  
**Status:** Proposed

The system shall evaluate student eligibility using institution-level and
department-specific academic rules.

Eligibility rules may consider:

- Enrollment status
- Academic program
- Current year
- Minimum GPA
- Completed credits
- Required courses
- Previous internship status
- Internship period
- Department approval
- Academic restrictions

### Acceptance Conditions

- The result is one of: eligible, ineligible, review required or data
  incomplete.
- Every failed rule is recorded.
- The rule version is preserved.
- Eligibility is recalculated when relevant academic information changes.
- Eligibility failure is explained using student-specific information.

---

### FR-008: Manage Academic Exceptions

**Priority:** Must Have  
**Status:** Proposed

The system shall support authorized academic exception requests.

An exception request shall include:

- Student
- Relevant eligibility rule
- Requested exception
- Supporting explanation
- Supporting documents
- Requesting user
- Responsible academic reviewer
- Decision
- Decision reason
- Decision timestamp
- Validity period

### Acceptance Conditions

- Students cannot approve their own exceptions.
- Career-center staff cannot approve academic exceptions unless explicitly
  authorized.
- Approved exceptions are limited to documented rules and periods.
- Rejected requests preserve their decision history.
- An expired exception cannot be applied to a new placement evaluation.

---

## Employer Management

### FR-009: Register Employer

**Priority:** Must Have  
**Status:** Proposed

The system shall allow authorized representatives to register an employer
organization.

Employer information may include:

- Organization name
- Industry
- Address
- Website
- Contact information
- Legal or registration identifier where required
- Organization status
- University relationship status

### Acceptance Conditions

- Duplicate employer records are detected.
- Employer activation requires career-center review.
- Inactive or suspended employers cannot publish active opportunities.
- Employer-status changes are audited.

---

### FR-010: Manage Employer Representatives

**Priority:** Must Have  
**Status:** Proposed

The system shall allow approved employer organizations to manage authorized
representatives.

Each representative shall be associated with:

- One employer
- Defined permissions
- Account status
- Verification status
- Last access information

### Acceptance Conditions

- Employer representatives cannot access other employers' records.
- Deactivated representatives lose access.
- Permission changes are logged.
- High-risk permissions require additional authorization.

---

### FR-011: Suspend Employer

**Priority:** Must Have  
**Status:** Proposed

The system shall allow authorized university staff to suspend an employer.

Suspension reasons may include:

- Invalid opportunity information
- Repeated cancellations
- Student complaints
- Privacy concerns
- Unsafe working conditions
- Unresolved institutional review
- Misuse of student data

### Acceptance Conditions

- Suspended employers cannot publish new opportunities.
- Existing active opportunities are placed under review.
- The suspension reason and decision owner are recorded.
- Reinstatement requires a documented decision.

---

## Internship Opportunity Management

### FR-012: Create Internship Opportunity

**Priority:** Must Have  
**Status:** Proposed

The system shall allow authorized employer representatives to create internship
opportunities.

An opportunity shall include:

- Opportunity title
- Employer
- Department or role
- Responsibilities
- Industry
- Location
- Working model
- Start date
- End date
- Application deadline
- Capacity
- Compensation information where applicable
- Required documents
- Opportunity status

### Acceptance Conditions

- Required fields are validated.
- End date must be later than start date.
- Application deadline must be compatible with the internship period.
- Capacity must be greater than zero.
- New opportunities require university review before activation.

---

### FR-013: Review Internship Opportunity

**Priority:** Must Have  
**Status:** Proposed

The system shall support career-center and academic review of internship
opportunities.

Review may verify:

- Employer status
- Completeness
- Academic relevance
- Internship duration
- Working conditions
- Capacity
- Required documentation
- Compliance with university policy

### Acceptance Conditions

- Opportunity status changes are controlled.
- Review results include reasons.
- Rejected opportunities can be returned for correction.
- Approved opportunity versions are preserved.
- Material changes after approval trigger re-review.

---

### FR-014: Define Opportunity Requirements

**Priority:** Must Have  
**Status:** Proposed

The system shall allow employer requirements to be represented as structured
records.

Each requirement shall contain:

- Requirement type
- Requirement category
- Required value
- Importance classification
- Evidence expectation
- Description

Importance classification shall support:

- Mandatory
- Preferred
- Optional

### Acceptance Conditions

- Mandatory requirements are evaluated before ranking.
- Preferred requirements influence compatibility.
- Optional requirements do not exclude candidates.
- Unstructured requirement text may be stored but must not silently act as an
  exclusion rule.
- Requirement changes are versioned.

---

### FR-015: Manage Opportunity Capacity

**Priority:** Must Have  
**Status:** Proposed

The system shall track opportunity capacity throughout the placement
lifecycle.

Capacity states shall distinguish:

- Total capacity
- Available capacity
- Temporarily reserved capacity
- Pending offers
- Accepted offers
- Confirmed placements
- Released capacity
- Cancelled positions

### Acceptance Conditions

- Available capacity cannot become negative.
- Capacity is recalculated after offer acceptance, rejection, expiration or
  cancellation.
- Capacity changes are audited.
- Concurrent actions cannot allocate the same final position twice.
- Capacity changes after active offers trigger review.

---

### FR-016: Close or Cancel Opportunity

**Priority:** Must Have  
**Status:** Proposed

The system shall allow an opportunity to be closed or cancelled.

A cancellation shall include:

- Cancellation reason
- Effective time
- Responsible user
- Affected applications
- Affected offers
- Communication status

### Acceptance Conditions

- New applications are blocked after closure.
- Affected students and responsible university staff are notified.
- Confirmed placements are not silently deleted.
- Capacity and application statuses are recalculated.
- Historical opportunity information remains available.

---

## Application Management

### FR-017: Submit Internship Application

**Priority:** Must Have  
**Status:** Proposed

The system shall allow eligible students to submit applications to active
opportunities.

Before submission, the system shall validate:

- Opportunity status
- Application deadline
- Student profile completeness
- Academic eligibility
- Required documents
- Application limits
- Existing conflicting placement status

### Acceptance Conditions

- Invalid applications are rejected with reasons.
- Successful submission records date and time.
- Duplicate active applications to the same opportunity are prevented.
- The student can view the resulting application status.

---

### FR-018: Withdraw Application

**Priority:** Must Have  
**Status:** Proposed

The system shall allow students to withdraw applications before a controlled
cutoff point.

### Acceptance Conditions

- Withdrawal reason may be requested.
- Employer and university review status are updated.
- Reserved capacity is released where applicable.
- Historical application information remains available.
- Withdrawal may be restricted after final placement confirmation.

---

### FR-019: Enforce Application Limits

**Priority:** Must Have  
**Status:** Proposed

The system shall enforce university-defined application limits.

Limits may depend on:

- Placement period
- Department
- Student status
- Active applications
- Pending offers
- Accepted offers
- Mandatory internship priority

### Acceptance Conditions

- The relevant limit is shown before application submission.
- An exceeded limit prevents new submission.
- Authorized exceptions are documented.
- Withdrawn or expired applications are handled according to policy.

---

### FR-020: Track Application Status

**Priority:** Must Have  
**Status:** Proposed

The system shall maintain a controlled application-status lifecycle.

Possible statuses may include:

- Draft
- Submitted
- Eligibility review
- Eligible
- Ineligible
- Employer review
- Shortlisted
- Not selected
- Offer pending
- Withdrawn
- Expired
- Closed

### Acceptance Conditions

- Invalid status transitions are rejected.
- Status changes record user, time and reason.
- Students see only permitted decision explanations.
- Employer-only evaluations are not disclosed without authorization.

---

## Matching and Recommendation

### FR-021: Build Eligible Candidate Pool

**Priority:** Must Have  
**Status:** Proposed

The system shall identify students eligible for each active internship
opportunity.

A student-opportunity combination shall be excluded when:

- Academic eligibility fails
- A mandatory employer requirement fails
- Internship dates conflict
- Opportunity is inactive
- Application deadline has passed
- Student has a conflicting confirmed placement
- Required documents are missing
- Employer capacity is unavailable where applicable

### Acceptance Conditions

- Each exclusion reason is recorded separately.
- Excluded combinations do not receive compatibility rankings.
- Data-incomplete combinations can be marked for review.
- Rule versions are preserved.

---

### FR-022: Evaluate Mandatory Requirements

**Priority:** Must Have  
**Status:** Proposed

The system shall evaluate every mandatory opportunity requirement against the
student profile.

### Acceptance Conditions

- All mandatory requirements must pass unless an authorized exception exists.
- Failed mandatory requirements are visible to authorized reviewers.
- The result identifies missing evidence separately from confirmed failure.
- Preferred criteria cannot compensate for a mandatory failure.

---

### FR-023: Calculate Compatibility Indicators

**Priority:** Must Have  
**Status:** Proposed

The system shall calculate compatibility indicators for eligible
student-opportunity combinations.

Indicators may include:

- Skill compatibility
- Academic relevance
- Industry preference alignment
- Role preference alignment
- Location compatibility
- Working-model compatibility
- Internship-period compatibility
- Language compatibility
- Preferred requirement satisfaction
- Previous placement considerations

### Acceptance Conditions

- Each indicator uses a documented formula or rule.
- Indicator weights are versioned.
- The system shows the factors contributing to the result.
- Missing information does not silently produce a positive match.
- Sensitive information is not used without approved purpose and authority.

---

### FR-024: Generate Placement Recommendations

**Priority:** Must Have  
**Status:** Proposed

The system shall generate ranked recommendations for eligible combinations.

A recommendation shall include:

- Student
- Opportunity
- Eligibility result
- Compatibility indicators
- Overall recommendation result
- Satisfied mandatory requirements
- Missing preferred qualifications
- Student preference alignment
- Capacity status
- Data-quality status
- Recommendation timestamp
- Rule and model version

### Acceptance Conditions

- Recommendations are advisory.
- No recommendation automatically confirms placement.
- Tied recommendations are handled using documented rules.
- Recommendation explanations are available to authorized reviewers.
- Historical recommendation versions are preserved.

---

### FR-025: Detect Students With No Recommendation

**Priority:** Must Have  
**Status:** Proposed

The system shall identify eligible students who have no active placement
recommendation.

Possible reasons shall include:

- No active opportunity
- Missing mandatory skill
- Restrictive location preference
- Internship-date conflict
- Incomplete profile
- Employer capacity shortage
- Academic eligibility problem
- No submitted applications
- Repeated employer rejection

### Acceptance Conditions

- Students are prioritized according to intervention deadlines.
- Responsible staff receive alerts.
- The system does not modify student preferences automatically.
- Support actions are recorded.

---

### FR-026: Monitor Recommendation Concentration

**Priority:** Should Have  
**Status:** Proposed

The system shall identify when recommendations are repeatedly concentrated
among a limited group of students.

### Acceptance Conditions

- Concentration metrics use documented definitions.
- Results are available to authorized governance roles.
- A concentration alert triggers review rather than automatic correction.
- The system preserves legitimate qualification differences for analysis.

---

## Human Review and Overrides

### FR-027: Review Placement Recommendation

**Priority:** Must Have  
**Status:** Proposed

The system shall allow authorized career-center staff to review placement
recommendations.

The review interface shall display:

- Eligibility result
- Mandatory requirement evaluation
- Compatibility indicators
- Student preferences
- Opportunity capacity
- Conflicts
- Supporting evidence
- Data-quality warnings
- Previous decisions
- Relevant academic approvals

### Acceptance Conditions

- Reviewers cannot approve recommendations with unresolved mandatory failures.
- Review actions are audited.
- The reviewer can request additional information.
- The system identifies recommendations approaching expiration.

---

### FR-028: Approve or Reject Recommendation

**Priority:** Must Have  
**Status:** Proposed

Authorized reviewers shall be able to approve or reject recommendations.

A decision shall include:

- Decision status
- Decision reason
- Reviewer identity
- Timestamp
- Related student
- Related opportunity
- Recommendation version

### Acceptance Conditions

- A reason is mandatory.
- The original recommendation remains unchanged.
- A second final decision requires an authorized correction or superseding
  process.
- Approval does not automatically mean the student or employer has accepted.

---

### FR-029: Request Additional Information

**Priority:** Must Have  
**Status:** Proposed

The system shall allow reviewers to request additional information from:

- Student
- Employer
- Academic department
- Career-center staff

### Acceptance Conditions

- The request identifies the required information.
- A deadline may be assigned.
- The recommendation status reflects pending information.
- Overdue requests generate alerts.
- Responses are linked to the relevant case.

---

### FR-030: Apply Manual Override

**Priority:** Must Have  
**Status:** Proposed

The system shall support authorized manual overrides where institutional policy
permits.

An override shall record:

- Original system result
- Final human decision
- Override category
- Detailed reason
- Responsible reviewer
- Required secondary approval
- Supporting evidence
- Timestamp

### Acceptance Conditions

- Mandatory academic rules cannot be overridden by unauthorized roles.
- High-impact overrides require secondary approval.
- Override rates are reportable.
- The original recommendation is preserved.
- Sensitive information is not included unnecessarily in free-text reasons.

---

### FR-031: Support Decision Appeal or Review Request

**Priority:** Should Have  
**Status:** Proposed

The system shall allow students to request review of defined decisions,
including:

- Academic eligibility
- Application rejection
- Placement recommendation outcome
- Manual override
- Opportunity cancellation impact

### Acceptance Conditions

- The request is routed to an appropriate independent role.
- The original decision remains effective unless suspended.
- Review outcome and reason are recorded.
- Appeal information does not expose other candidates' data.

---

## Placement Offer Management

### FR-032: Create Placement Offer

**Priority:** Must Have  
**Status:** Proposed

The system shall allow an approved recommendation to become a placement offer.

The offer shall contain:

- Student
- Opportunity
- Employer
- Offer date
- Expiration date
- Internship dates
- Working model
- Location
- Relevant conditions
- Capacity reservation
- Offer status

### Acceptance Conditions

- The opportunity has available capacity.
- The student has no conflicting confirmed placement.
- Offer expiration is later than offer creation.
- Capacity is reserved according to policy.
- The offer is visible only to authorized parties.

---

### FR-033: Accept or Decline Offer

**Priority:** Must Have  
**Status:** Proposed

The system shall allow students to accept or decline active placement offers.

### Acceptance Conditions

- Expired offers cannot be accepted.
- Acceptance records the student's explicit decision.
- Declined offers release reserved capacity.
- Other active offers are handled according to university policy.
- Students receive confirmation of the resulting status.

---

### FR-034: Record Employer Acceptance

**Priority:** Must Have  
**Status:** Proposed

The system shall record employer acceptance or rejection of the student.

### Acceptance Conditions

- Employer decisions are limited to their own opportunities.
- Decision time and responsible representative are recorded.
- Rejection reasons may be categorized.
- Confidential employer notes are access controlled.
- Capacity is updated after the decision.

---

### FR-035: Expire Placement Offer

**Priority:** Must Have  
**Status:** Proposed

The system shall expire offers that remain unanswered beyond their deadline.

### Acceptance Conditions

- Offer status becomes expired.
- Reserved capacity is released.
- Student and responsible staff are notified.
- An expired offer cannot be accepted without authorized reactivation.
- Expiration is audited.

---

## Final Placement

### FR-036: Confirm Final Placement

**Priority:** Must Have  
**Status:** Proposed

The system shall confirm a placement only when required approvals and
acceptances are complete.

Confirmation may require:

- Student acceptance
- Employer acceptance
- Career-center approval
- Academic approval where required
- Valid opportunity
- Available capacity
- No conflicting confirmed placement
- Required documents

### Acceptance Conditions

- Every prerequisite is validated.
- One student cannot have conflicting active mandatory placements unless
  explicitly permitted.
- Opportunity capacity is consumed.
- Relevant applications and offers are updated.
- Confirmation is audited.

---

### FR-037: Prevent Duplicate Confirmed Placements

**Priority:** Must Have  
**Status:** Proposed

The system shall prevent conflicting confirmed placements for the same student
and internship period.

### Acceptance Conditions

- Overlapping placement dates are detected.
- Permitted exceptions require documented authorization.
- Duplicate confirmation attempts are rejected.
- The existing confirmed placement remains unchanged.

---

### FR-038: Cancel Confirmed Placement

**Priority:** Must Have  
**Status:** Proposed

The system shall support controlled placement cancellation.

A cancellation shall include:

- Cancellation reason
- Requesting party
- Approving role
- Effective date
- Capacity impact
- Academic impact
- Follow-up action

### Acceptance Conditions

- Historical placement information remains available.
- Released capacity is recalculated.
- Affected stakeholders are notified.
- Students requiring replacement placement are identified.
- Academic consequences are recorded where applicable.

---

### FR-039: Manage External Student-Sourced Placement

**Priority:** Should Have  
**Status:** Proposed

The system shall support internships found independently by students.

### Acceptance Conditions

- The employer and opportunity are reviewed.
- Academic relevance is evaluated.
- Student consent and documents are recorded.
- External acceptance does not automatically equal university approval.
- Approved external placements follow the normal confirmation lifecycle.

---

## Internship Completion and Outcomes

### FR-040: Monitor Active Placement

**Priority:** Should Have  
**Status:** Proposed

The system shall track active internship placements.

Tracking may include:

- Start confirmation
- Attendance or participation status
- Midpoint review
- Report deadlines
- Employer evaluation
- Student evaluation
- Academic assessment
- Completion status

---

### FR-041: Record Internship Outcome

**Priority:** Must Have  
**Status:** Proposed

The system shall record the outcome of a completed or terminated internship.

Possible outcomes may include:

- Successfully completed
- Partially completed
- Failed
- Cancelled by student
- Cancelled by employer
- Terminated by university
- Completion under review

### Acceptance Conditions

- Outcome reason is recorded.
- Required evaluations are linked.
- Completion date is stored.
- Academic-credit status remains separate when necessary.
- Historical recommendation and placement data remain traceable.

---

### FR-042: Collect Student and Employer Evaluation

**Priority:** Should Have  
**Status:** Proposed

The system shall support structured post-internship evaluations from students
and employers.

### Acceptance Conditions

- Evaluation access is limited to relevant parties.
- Free-text responses are protected.
- Evaluations can be analyzed in aggregated form.
- An evaluation does not silently modify historical matching scores.

---

## Notifications and Tasks

### FR-043: Send Process Notifications

**Priority:** Must Have  
**Status:** Proposed

The system shall send notifications for important events, including:

- Missing profile information
- Eligibility result
- Application submission
- Application-status change
- Additional information request
- Employer decision
- Placement recommendation
- Offer creation
- Offer expiration
- Offer acceptance or rejection
- Placement confirmation
- Placement cancellation
- Internship deadlines

### Acceptance Conditions

- Notifications identify the required action and deadline.
- Sensitive information is minimized.
- Delivery status may be monitored.
- Users can view important notifications within the system.

---

### FR-044: Create Operational Tasks

**Priority:** Should Have  
**Status:** Proposed

The system shall create tasks for responsible staff when intervention is
required.

Examples include:

- Review pending opportunity
- Resolve missing eligibility data
- Review override request
- Contact unplaced student
- Investigate capacity conflict
- Confirm placement cancellation
- Review fairness alert

---

## Reporting and Analytics

### FR-045: Provide Operational Dashboard

**Priority:** Must Have  
**Status:** Proposed

The system shall provide authorized staff with an operational dashboard.

The dashboard may include:

- Active students
- Complete and incomplete profiles
- Active opportunities
- Pending applications
- Pending decisions
- Expiring offers
- Unplaced students
- Remaining capacity
- Confirmed placements
- Placement cancellations
- Overdue tasks

---

### FR-046: Provide Management Reports

**Priority:** Must Have  
**Status:** Proposed

The system shall provide aggregated management reports.

Reports may include:

- Placement rate
- Unplaced student rate
- Opportunity fill rate
- Offer acceptance rate
- Average time to placement
- Internship completion rate
- Employer participation
- Department comparison
- Override rate
- Recommendation concentration
- Students with no recommendation

### Acceptance Conditions

- Access is restricted by role.
- Aggregated reports do not expose unnecessary personal information.
- Formulas and reporting periods are documented.
- Data-quality limitations are visible.

---

### FR-047: Support Fairness Review

**Priority:** Must Have  
**Status:** Proposed

The system shall provide authorized governance roles with indicators that
support review of placement outcomes.

Possible analysis dimensions include:

- Academic department
- Academic year
- Application period
- Opportunity category
- Working model
- Recommendation status
- Placement result

### Acceptance Conditions

- Indicators trigger investigation rather than automatic conclusions.
- Small groups are protected against re-identification.
- Sensitive attributes are not introduced without approved purpose.
- Differences are presented with contextual information.

---

### FR-048: Preserve Historical Analysis

**Priority:** Must Have  
**Status:** Proposed

The system shall retain approved historical records needed for trend and
outcome analysis.

Historical analysis shall preserve relevant versions of:

- Eligibility rules
- Opportunity requirements
- Matching logic
- Recommendation results
- Human decisions
- Capacity
- Placement outcomes

# Non-Functional Requirements

## Usability

### NFR-001: Understandable Status Information

The system shall present student, employer and staff statuses using clear and
consistent terminology.

### NFR-002: Explainable Results

Eligibility, exclusion and recommendation results shall provide understandable
reasons appropriate to the user's authorization level.

### NFR-003: Accessible Interface

The user interface should follow approved accessibility standards and support
keyboard navigation, readable labels and assistive technologies.

### NFR-004: Error Prevention

High-impact actions shall include validation and confirmation before final
submission.

## Performance

### NFR-005: Interactive Response Time

Standard profile, opportunity and application pages should respond within an
acceptable operational period under expected load.

### NFR-006: Matching Processing Time

The system shall generate placement recommendations within a period appropriate
to the defined application cycle.

### NFR-007: Reporting Performance

Operational reports shall identify their reporting period and data freshness.

## Availability and Reliability

### NFR-008: Service Availability

The system should be available during published placement and application
periods.

### NFR-009: Transaction Integrity

Placement, offer and capacity transactions shall not produce partial or
conflicting results.

### NFR-010: Recovery

The system shall support documented backup, recovery and reconciliation
procedures.

### NFR-011: Idempotent Processing

Repeated integration messages shall not create duplicate applications,
opportunities, offers or placements.

## Security

### NFR-012: Authentication

All users shall authenticate through an approved identity mechanism.

### NFR-013: Role-Based Access Control

Access shall be limited according to user role, organization, department and
business purpose.

### NFR-014: Least Privilege

Users shall receive only the permissions necessary for their responsibilities.

### NFR-015: Sensitive Data Protection

Sensitive information shall be protected during storage, transmission,
display and export.

### NFR-016: Privileged Action Control

High-impact actions such as employer suspension, rule changes and manual
overrides shall require enhanced authorization.

### NFR-017: Security Monitoring

The system shall record and monitor failed access attempts, unusual exports and
privileged actions.

## Privacy

### NFR-018: Data Minimization

The system shall collect and display only the personal information necessary
for documented placement purposes.

### NFR-019: Purpose Limitation

Student information shall not be reused for unrelated scoring or evaluation
without an approved purpose.

### NFR-020: Employer Data Access

Employers shall access only candidate information required for their own
approved opportunities.

### NFR-021: Retention

Personal and placement records shall follow documented retention and deletion
rules.

### NFR-022: Sensitive Circumstances

Accessibility or support-related information shall be restricted and shall not
become a general-purpose matching score.

## Auditability

### NFR-023: Audit Events

The system shall record important events, including:

- Eligibility decisions
- Opportunity approval
- Requirement changes
- Application-status changes
- Recommendation generation
- Human decisions
- Manual overrides
- Capacity changes
- Offer actions
- Placement confirmation
- Access changes
- Data corrections

### NFR-024: Audit Record Content

Audit records shall contain:

- Event identifier
- User or system identity
- Timestamp
- Affected entity
- Previous value
- New value
- Reason
- Correlation identifier where applicable

### NFR-025: Historical Integrity

Final decisions and confirmed placements shall not be permanently deleted
through normal user interfaces.

## Explainability and Fairness

### NFR-026: Recommendation Transparency

Authorized reviewers shall be able to understand the main factors contributing
to a recommendation.

### NFR-027: Version Traceability

Every eligibility and recommendation result shall be linked to the rules and
weights used at the time of evaluation.

### NFR-028: Human Oversight

The initial system shall not autonomously confirm final placements.

### NFR-029: Fairness Monitoring

The system shall support controlled comparison of outcomes while protecting
privacy and avoiding unsupported conclusions.

### NFR-030: Override Accountability

Manual overrides shall require reason, authority and audit history.

## Maintainability

### NFR-031: Configurable Rules

Approved eligibility and matching rules should be configurable without
uncontrolled code changes.

### NFR-032: Rule Ownership

Every configurable rule shall have:

- Business owner
- Technical owner
- Version
- Effective date
- Approval status

### NFR-033: Documentation

System processes, APIs, data definitions and decision rules shall be
documented.

### NFR-034: Testability

Functional rules and important boundary conditions shall be testable using
repeatable scenarios.

# Data Requirements

## DR-001: Unique Identifiers

Core entities shall use stable unique identifiers.

Core entities include:

- Student
- Employer
- Opportunity
- Application
- Recommendation
- Offer
- Placement
- Decision

## DR-002: Controlled Vocabularies

Controlled values shall be used for:

- Skills
- Academic programs
- Opportunity statuses
- Application statuses
- Requirement importance
- Working models
- Decision reasons
- Placement outcomes

## DR-003: Effective-Dated Rules

Academic eligibility rules and matching configurations shall support effective
start and end dates.

## DR-004: Data Source Identification

Imported data shall record its authoritative source and relevant update time.

## DR-005: Data Quality Status

Critical evaluations shall identify whether input data is:

- Complete
- Incomplete
- Stale
- Conflicting
- Unverified

## DR-006: Historical Versions

Material changes to opportunity requirements, eligibility rules and matching
logic shall preserve previous versions.

## DR-007: Time Consistency

System timestamps shall use a documented time standard and preserve the
relevant local interpretation where required.

# Integration Requirements

## IR-001: Student Information System Integration

The system should receive approved student and academic information from the
university student information system.

## IR-002: Identity Integration

The system shall use the approved university identity service for student and
staff authentication.

## IR-003: Employer Identity

Employer access shall use an approved registration and verification process.

## IR-004: Document Management

The system may integrate with an approved document-management service for CVs,
academic documents and internship forms.

## IR-005: Notification Service

The system should integrate with approved email or notification services.

## IR-006: Integration Failure Handling

Failed integrations shall:

- Record an error
- Avoid duplicate processing
- Preserve retry information
- Alert responsible technical staff
- Identify affected business records

# Governance Requirements

## GR-001: Decision Ownership

Every high-impact decision type shall have an identified accountable role.

## GR-002: Segregation of Duties

High-impact changes should separate:

- Rule configuration
- Recommendation generation
- Recommendation review
- Final placement confirmation
- Audit review

## GR-003: Change Approval

Changes to eligibility rules, matching weights, fairness indicators and
capacity policies shall require documented approval.

## GR-004: Policy Versioning

Policy changes shall include:

- Version
- Owner
- Approval date
- Effective date
- Change reason
- Affected processes

## GR-005: Periodic Review

The university shall periodically review:

- Recommendation outcomes
- Manual overrides
- Employer rejection patterns
- Students with no recommendation
- Privacy access
- Security events
- Data quality
- Placement completion

## GR-006: Honest System Representation

The system shall distinguish between:

- Eligibility result
- Compatibility indicator
- Recommendation
- Employer acceptance
- Student acceptance
- Academic approval
- Confirmed placement

One status shall not be presented as another.

# Requirement Dependencies

| Requirement | Depends On |
|---|---|
| FR-007 Academic eligibility | FR-006 Academic information |
| FR-017 Application submission | FR-003, FR-007, FR-012 |
| FR-021 Eligible candidate pool | FR-007, FR-014, FR-017 |
| FR-023 Compatibility indicators | FR-004, FR-005, FR-014 |
| FR-024 Recommendations | FR-021, FR-022, FR-023 |
| FR-027 Human review | FR-024 |
| FR-032 Placement offer | FR-028, FR-015 |
| FR-036 Final placement | FR-032, FR-033, FR-034 |
| FR-041 Internship outcome | FR-036 |
| FR-047 Fairness review | FR-024, FR-028, FR-036 |

# Preliminary Requirement Traceability

| Stakeholder Need | Related Requirements |
|---|---|
| Students need understandable eligibility results | FR-007, NFR-002 |
| Students need preference-aware recommendations | FR-005, FR-023, FR-024 |
| Employers need eligible candidates | FR-014, FR-021, FR-022 |
| Career-center staff need reduced manual workload | FR-021, FR-024, FR-045 |
| Academic units retain eligibility authority | FR-007, FR-008 |
| Opportunity capacity must remain accurate | FR-015, FR-032, FR-035 |
| Decisions must be explainable | FR-024, FR-027, NFR-026 |
| Overrides must be controlled | FR-030, NFR-030 |
| Unplaced students need early support | FR-025, FR-044 |
| Personal information must be protected | NFR-012 to NFR-022 |
| Decisions must remain auditable | NFR-023 to NFR-025 |
| Administration needs aggregated outcomes | FR-046, FR-047 |

# Assumptions

The requirements currently assume:

- Students use authenticated university identities.
- Employers are reviewed before activation.
- Academic data is available from an authoritative source.
- Final placements require student and employer participation.
- Career-center staff coordinate operational placement status.
- Academic departments retain academic exception authority.
- Recommendations are advisory.
- The initial system does not autonomously confirm placements.

# Open Requirement Questions

The following questions require later validation:

- Which academic rules are institution-wide?
- Which rules are department-specific?
- Which preference types may act as hard constraints?
- How many active applications may a student maintain?
- When should opportunity capacity be reserved?
- Which offer actions release capacity?
- Can employers view full CV documents?
- Which recommendation factors may be visible to students?
- Which overrides require secondary approval?
- How should tied recommendations be handled?
- What is the maximum offer-response period?
- Which data may be retained after graduation?
- Which fairness dimensions are legally and institutionally appropriate?
- What process governs students with no available opportunity?
- Which employer rejection reasons may be shared with students?

# Definition of Requirement Completion

A requirement will be considered ready for implementation when:

- Its business owner is identified.
- Its priority is approved.
- Its expected behavior is clear.
- Acceptance criteria are documented.
- Related data fields are defined.
- Authorization rules are known.
- Error conditions are described.
- Audit requirements are identified.
- Dependencies are understood.
- Relevant test scenarios can be written.

## Requirement Summary

The Internship Placement and Matching System must support a complete and
controlled placement lifecycle.

The system must not treat placement as a simple score or automatic assignment.

It must combine:

- Academic eligibility
- Employer requirements
- Student preferences
- Opportunity capacity
- Explainable matching
- Human review
- Student and employer acceptance
- Placement confirmation
- Outcome monitoring
- Privacy
- Security
- Auditability
- Fairness-aware governance

The next document will model the current manual internship-placement process
and identify its delays, repeated activities, decision points and control
weaknesses.
