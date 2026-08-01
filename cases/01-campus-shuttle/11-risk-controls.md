# Risk and Control Framework

## Purpose

This document identifies the main operational, data, security and
decision-making risks affecting the Campus Shuttle Decision System.

The objective is not to eliminate every possible risk. The objective is to
reduce the likelihood and impact of incorrect recommendations, unreliable
performance indicators, unauthorized changes and service disruptions.

Each risk is connected to one or more preventive, detective or corrective
controls.

## Control Types

### Preventive Controls

Preventive controls reduce the probability of an error or unauthorized action
before it occurs.

Examples:

- Required fields
- Role-based access
- Input validation
- Approval requirements
- Accepted-value restrictions

### Detective Controls

Detective controls identify problems after data or operational events have
been recorded.

Examples:

- Data quality reports
- Duplicate detection
- Threshold alerts
- Audit-log reviews
- Performance monitoring

### Corrective Controls

Corrective controls support recovery after a problem has been identified.

Examples:

- Data correction workflows
- Recommendation cancellation
- Schedule rollback
- Manual reassignment
- Incident investigation

# Risk Register

| Risk ID | Risk | Category | Likelihood | Impact | Risk Level |
|---|---|---|---|---|---|
| R-001 | Incorrect passenger counts | Data quality | High | High | Critical |
| R-002 | Missing trip timing data | Data quality | Medium | High | High |
| R-003 | Duplicate trip records | Data quality | Medium | High | High |
| R-004 | Incorrect vehicle capacity | Master data | Medium | High | High |
| R-005 | Outdated route schedules | Operational | Medium | High | High |
| R-006 | False overcrowding recommendation | Decision quality | Medium | High | High |
| R-007 | Delayed management review | Governance | Medium | Medium | Medium |
| R-008 | Unauthorized schedule change | Security | Low | Critical | High |
| R-009 | Recommendation manipulation | Security | Low | Critical | High |
| R-010 | Loss of audit history | Governance | Low | High | Medium |
| R-011 | Inaccessible service allocation | Service quality | Medium | High | High |
| R-012 | System unavailable during operations | Availability | Medium | High | High |
| R-013 | Personal data exposure | Privacy | Low | Critical | High |
| R-014 | Incorrect threshold configuration | Configuration | Medium | High | High |
| R-015 | Recommendation creates new operational problem | Decision quality | Medium | High | High |

# Detailed Risks and Controls

## R-001: Incorrect Passenger Counts

### Risk Description

Passenger counts may be inaccurate because of manual estimation, sensor
failure, duplicate observations or missing boarding information.

Incorrect passenger counts may produce false capacity-utilization results and
unnecessary vehicle-allocation recommendations.

### Potential Consequences

- False overcrowding alerts
- Incorrect low-utilization classifications
- Unnecessary vehicle allocation
- Failure to identify real capacity problems
- Unreliable management reports

### Preventive Controls

- Passenger count must not be negative.
- Passenger observations must include an observation method.
- Sensor-generated observations must include a device identifier.
- Manual observations must identify the responsible staff member.
- Passenger counts above a configurable physical limit must require review.

### Detective Controls

- Compare passenger counts from multiple observations on the same trip.
- Flag utilization rates above 120 percent.
- Monitor observation confidence scores.
- Detect sudden differences from the same route and time-slot baseline.
- Report trips without passenger observations.

### Corrective Controls

- Allow authorized staff to mark an observation as invalid.
- Recalculate affected KPIs after correction.
- Withdraw recommendations based only on invalid observations.
- Preserve both the original and corrected values in the audit history.

### Control Owner

Transportation Data Operations

---

## R-002: Missing Trip Timing Data

### Risk Description

Actual departure or arrival timestamps may be missing because of device
failure, incomplete driver records or integration problems.

### Potential Consequences

- Incorrect punctuality KPIs
- Incomplete delay analysis
- Failure to identify recurring delays
- Misleading route comparisons

### Preventive Controls

- Completed trips should require actual departure and arrival timestamps.
- Mobile or vehicle systems should validate timestamp formats.
- Device clocks should be synchronized with an approved time source.

### Detective Controls

- Generate a daily missing-timing report.
- Display data-quality coverage alongside punctuality KPIs.
- Prevent route punctuality from being classified as reliable when timing
  coverage is below the accepted threshold.

### Corrective Controls

- Permit authorized manual completion using supporting records.
- Label manually entered timestamps.
- Recalculate affected route metrics after correction.

---

## R-003: Duplicate Trip Records

### Risk Description

The same trip may be recorded more than once because of repeated integration
messages, manual entry or system retries.

### Potential Consequences

- Inflated trip counts
- Incorrect completion rates
- Duplicate complaints or observations
- Distorted capacity and delay statistics

### Preventive Controls

- Each trip must have a unique `trip_id`.
- Source messages should contain an idempotency key.
- Duplicate trip creation should be rejected.

### Detective Controls

- Search for records sharing route, vehicle, service date and planned
  departure time.
- Monitor duplicate-key errors.
- Include duplicate-record counts in data-quality reporting.

### Corrective Controls

- Merge valid related observations into the accepted trip record.
- Mark duplicate trips as invalid rather than deleting them permanently.
- Recalculate affected reports and recommendations.

---

## R-004: Incorrect Vehicle Capacity

### Risk Description

A vehicle may have an outdated or incorrect usable-capacity value.

The registered capacity may also differ from usable capacity because of
maintenance restrictions, accessibility space or temporary operational rules.

### Potential Consequences

- Incorrect utilization percentages
- False overcrowding classifications
- Unsafe vehicle assignments
- Misleading capacity comparisons

### Preventive Controls

- Vehicle capacity changes must require authorization.
- Capacity must be a positive integer.
- Usable capacity must not exceed registered physical capacity.
- Capacity changes must include an effective date and reason.

### Detective Controls

- Compare vehicle capacity with the approved fleet registry.
- Review unusual changes in utilization following capacity updates.
- Generate a report of vehicles with missing capacity.

### Corrective Controls

- Correct the vehicle master record.
- Recalculate affected utilization metrics.
- Review recommendations generated using the incorrect capacity.

---

## R-005: Outdated Route Schedules

### Risk Description

The system may calculate delays using an old schedule after a timetable,
academic calendar or route change.

### Potential Consequences

- False delay events
- Incorrect schedule-adherence rates
- Unnecessary schedule recommendations
- Passenger-facing information inconsistencies

### Preventive Controls

- Schedules must have effective start and end dates.
- Only one active schedule version may apply to the same route and time period.
- Schedule changes must use a controlled approval process.

### Detective Controls

- Compare operational trips with the active schedule version.
- Alert when trips reference expired schedules.
- Review schedule exceptions around holidays and academic-term changes.

### Corrective Controls

- Associate affected trips with the correct schedule version.
- Recalculate delay metrics.
- Document the reason for retrospective schedule correction.

---

## R-006: False Overcrowding Recommendation

### Risk Description

The system may recommend adding a vehicle because of isolated or unreliable
high passenger counts.

### Potential Consequences

- Increased operating cost
- Unnecessary vehicle use
- Reduced vehicle availability on other routes
- Lower confidence in the decision-support system

### Preventive Controls

- A recommendation must use multiple comparable trips.
- Low-confidence observations must not independently trigger a recommendation.
- Minimum evidence requirements must be defined for each rule.
- Alternative routes and available capacity must be evaluated.

### Detective Controls

- Show all supporting trips and measurements to the reviewer.
- Display evidence coverage and confidence level.
- Flag recommendations based on unusually small samples.
- Compare the recommendation with historical seasonal patterns.

### Corrective Controls

- Permit reviewers to reject the recommendation with a documented reason.
- Allow pending recommendations to be withdrawn when evidence becomes invalid.
- Use rejection reasons to improve recommendation rules.

---

## R-007: Delayed Management Review

### Risk Description

Operational recommendations may remain pending beyond the period in which
they are useful.

### Potential Consequences

- Capacity or delay problems continue unresolved
- Recommendations expire before implementation
- Management accountability becomes unclear
- Passenger complaints increase

### Preventive Controls

- Assign every recommendation to an authorized review role.
- Define review deadlines according to recommendation priority.
- Display pending recommendations on the management dashboard.

### Detective Controls

- Alert when response time exceeds 24 hours.
- Escalate critical recommendations after 48 hours.
- Report pending recommendation age by responsible team.

### Corrective Controls

- Reassign recommendations when the responsible reviewer is unavailable.
- Expire recommendations that are no longer operationally relevant.
- Generate a new recommendation when current evidence still supports action.

---

## R-008: Unauthorized Schedule Change

### Risk Description

An unauthorized person may modify routes, vehicle assignments or timetable
information.

### Potential Consequences

- Service disruption
- Passenger safety concerns
- Incorrect public information
- Loss of operational accountability

### Preventive Controls

- Apply role-based access control.
- Separate recommendation review from schedule administration.
- Require strong authentication for administrative actions.
- Require approval for high-impact schedule changes.

### Detective Controls

- Record user, time, old value and new value for every change.
- Alert on unusual changes outside operating procedures.
- Review privileged-user activity regularly.

### Corrective Controls

- Provide schedule-version rollback.
- Disable compromised accounts.
- Investigate affected changes using audit records.
- Notify operational teams when a rollback occurs.

---

## R-009: Recommendation Manipulation

### Risk Description

A user may alter recommendation evidence, confidence values or decision
status to influence operational decisions.

### Potential Consequences

- Biased vehicle allocation
- Unjustified management decisions
- Loss of system credibility
- Fraud or misuse of university resources

### Preventive Controls

- System-generated evidence must be read-only.
- Recommendation rules must be version-controlled.
- Decision reviewers must not modify supporting measurements.
- Administrative permissions must follow least-privilege principles.

### Detective Controls

- Maintain an immutable audit trail.
- Compare recommendation records with source measurements.
- Alert when confidence or evidence values change after generation.
- Review unusual approval patterns by user.

### Corrective Controls

- Restore the original recommendation version.
- Suspend affected user permissions.
- Re-evaluate decisions linked to manipulated records.
- Escalate confirmed misuse through the university governance process.

---

## R-010: Loss of Audit History

### Risk Description

Changes to routes, recommendations or decisions may not be traceable because
records were overwritten or deleted.

### Potential Consequences

- Decisions cannot be explained
- Errors cannot be investigated
- Accountability is reduced
- Historical performance comparisons become unreliable

### Preventive Controls

- Use versioned records for controlled configuration changes.
- Prevent hard deletion of recommendations and decisions.
- Store previous and new values for important changes.
- Back up audit records regularly.

### Detective Controls

- Monitor gaps in audit sequence.
- Reconcile decision records with recommendation-status changes.
- Test audit-log recovery procedures.

### Corrective Controls

- Restore records from backups.
- Reconstruct missing events from operational logs when possible.
- Document unrecoverable audit gaps as governance incidents.

---

## R-011: Inaccessible Service Allocation

### Risk Description

A vehicle without required accessibility features may be assigned to a route
or trip used by passengers with accessibility requirements.

### Potential Consequences

- Passengers cannot use the service
- Equality and accessibility obligations may be violated
- Complaints and reputational damage
- Operational reassignment at short notice

### Preventive Controls

- Store accessibility capability for each vehicle.
- Define routes and trips requiring accessible vehicles.
- Reject incompatible vehicle assignments.
- Maintain minimum accessible-service coverage.

### Detective Controls

- Report accessibility requirement mismatches.
- Monitor accessibility-related feedback.
- Review cancelled or replaced accessible trips.

### Corrective Controls

- Assign a compatible replacement vehicle.
- Notify affected passengers when possible.
- Record and investigate the cause of the mismatch.

---

## R-012: System Unavailability During Operations

### Risk Description

The decision-support or operational management interface may become
unavailable during shuttle operating hours.

### Potential Consequences

- Managers cannot view alerts
- Recommendations cannot be reviewed
- Schedule information may become inaccessible
- Manual operations increase the risk of error

### Preventive Controls

- Define availability and recovery objectives.
- Use monitored infrastructure.
- Maintain tested backup procedures.
- Provide a read-only fallback report for critical information.

### Detective Controls

- Monitor system health and response times.
- Alert technical support when availability thresholds are breached.
- Track failed API requests and integration errors.

### Corrective Controls

- Activate the documented incident-response process.
- Use the latest approved schedule during downtime.
- Restore service from backups or standby components.
- Reconcile manually recorded events after recovery.

---

## R-013: Personal Data Exposure

### Risk Description

Student feedback may contain names, contact information or sensitive
statements that are visible to unauthorized users.

### Potential Consequences

- Privacy violation
- Reputational harm
- Unauthorized profiling
- Legal or regulatory consequences

### Preventive Controls

- Collect only the minimum personal information required.
- Separate identity information from analytical feedback data.
- Restrict access to identifiable feedback.
- Mask personal details in operational dashboards.
- Define data-retention periods.

### Detective Controls

- Monitor access to sensitive feedback.
- Review downloads and bulk exports.
- Scan free-text fields for accidentally submitted personal information.

### Corrective Controls

- Remove or mask exposed personal information.
- Revoke unauthorized access.
- Investigate and document the incident.
- Notify the responsible privacy team.

---

## R-014: Incorrect Threshold Configuration

### Risk Description

A utilization, delay or confidence threshold may be entered incorrectly or
changed without proper evaluation.

### Potential Consequences

- Too many or too few recommendations
- Important operational problems remain undetected
- Management receives misleading alerts
- Historical results become difficult to compare

### Preventive Controls

- Threshold changes must require approval.
- Accepted ranges must be validated.
- Changes must include justification and effective date.
- Thresholds must be tested against historical data before activation.

### Detective Controls

- Monitor sudden changes in recommendation volume.
- Compare current thresholds with the approved configuration register.
- Review configuration changes regularly.

### Corrective Controls

- Restore the previous threshold version.
- Reprocess the affected period when necessary.
- Withdraw recommendations generated by an invalid configuration.

---

## R-015: Recommendation Creates a New Operational Problem

### Risk Description

An approved recommendation may improve one KPI while negatively affecting
another route, time slot or passenger group.

For example, moving a vehicle to an overcrowded route may create insufficient
capacity elsewhere.

### Potential Consequences

- New overcrowding on another route
- Reduced accessibility
- Increased operating cost
- Longer waiting times
- Unintended service inequality

### Preventive Controls

- Conduct an impact assessment before approval.
- Evaluate vehicle availability across the entire network.
- Identify affected routes and passenger groups.
- Define expected benefits and possible negative effects.

### Detective Controls

- Compare before-and-after KPIs.
- Monitor both the target route and affected routes.
- Review passenger feedback after implementation.
- Define an observation period for every implemented recommendation.

### Corrective Controls

- Reverse or modify the operational change.
- Record the reason the recommendation was ineffective.
- Update recommendation rules using the evaluation result.
- Require additional review for similar future recommendations.

# Control Matrix

| Control ID | Control | Type | Frequency | Owner |
|---|---|---|---|---|
| C-001 | Passenger-count validation | Preventive | Every observation | Data Operations |
| C-002 | Missing operational data report | Detective | Daily | Data Operations |
| C-003 | Duplicate-trip detection | Detective | Every ingestion cycle | IT Operations |
| C-004 | Vehicle-capacity approval | Preventive | On change | Fleet Manager |
| C-005 | Schedule-version validation | Preventive | Every trip | Transport Operations |
| C-006 | Recommendation evidence review | Preventive | Every recommendation | Operations Manager |
| C-007 | Pending-review escalation | Detective | Hourly | System Service |
| C-008 | Role-based access control | Preventive | Continuous | IT Security |
| C-009 | Administrative audit review | Detective | Monthly | Internal Control |
| C-010 | Configuration rollback | Corrective | As required | System Administrator |
| C-011 | Accessibility assignment validation | Preventive | Every assignment | Dispatcher |
| C-012 | System health monitoring | Detective | Continuous | IT Operations |
| C-013 | Sensitive-data masking | Preventive | Every display request | Application Service |
| C-014 | Threshold change approval | Preventive | On change | Governance Committee |
| C-015 | Post-implementation evaluation | Detective | After each implementation | Operations Analyst |

# Risk-Based Recommendation Review

Recommendations should be assigned a review priority.

## Critical Priority

A recommendation is critical when it concerns:

- Passenger safety
- Severe overcrowding
- Accessibility failure
- Multiple cancelled trips
- Major operational disruption

Critical recommendations should be reviewed as soon as operationally possible.

## High Priority

A recommendation is high priority when:

- Utilization exceeds the critical threshold repeatedly
- Recurring delay rate exceeds 20 percent
- A route has repeated service-reliability failures
- Passenger complaints significantly exceed the accepted level

## Standard Priority

A recommendation is standard priority when:

- Low utilization suggests a timetable review
- Performance is declining but remains within safe limits
- Operational optimization is possible without immediate service risk

# Segregation of Duties

No single user should control the entire recommendation lifecycle.

Recommended separation:

| Activity | Responsible Role |
|---|---|
| Configure business rules | System administrator and governance owner |
| Generate recommendations | System |
| Review recommendation evidence | Operations analyst |
| Approve or reject recommendation | Operations manager |
| Change operational schedule | Authorized dispatcher |
| Evaluate implementation result | Independent analyst or manager |
| Review audit records | Internal control or security team |

A user may perform multiple roles in a small organization, but high-impact
changes should still require independent review.

# Audit Requirements

The system should record the following events:

- Route creation and modification
- Schedule-version changes
- Vehicle-capacity changes
- Passenger-observation corrections
- Recommendation generation
- Recommendation evidence changes
- Approval and rejection decisions
- Implementation-date changes
- User-role changes
- Threshold configuration changes
- Failed authorization attempts

Each audit record should contain:

- Event identifier
- Event type
- User or system identity
- Timestamp
- Affected entity
- Previous value
- New value
- Change reason
- Correlation or trace identifier

# Incident Management

An incident should be created when:

- Incorrect data produces a high-impact recommendation
- An unauthorized change is detected
- Sensitive information is exposed
- Audit records are missing
- The system is unavailable beyond the accepted period
- A recommendation causes significant service deterioration

## Incident Lifecycle

1. Detect and record the incident.
2. Classify severity and affected services.
3. Contain the immediate impact.
4. Correct data or configuration where possible.
5. Recalculate affected KPIs and recommendations.
6. Identify the root cause.
7. Define preventive actions.
8. Close the incident with documented evidence.

# Residual Risk

Controls reduce risk but do not guarantee that every recommendation will be
correct.

Operational conditions such as accidents, weather, road closures, events and
unexpected passenger demand may not be fully predictable.

For this reason:

- Recommendations remain subject to human approval.
- Supporting evidence must remain visible.
- High-impact changes require post-implementation monitoring.
- Managers must be able to override recommendations with a documented reason.
- Historical outcomes should be used to improve future rules.

# Review Frequency

This risk framework should be reviewed:

- At the beginning of each academic term
- After a major route or system change
- After a high-severity incident
- When recommendation rules are modified
- When new data sources are introduced
- At least once per year
