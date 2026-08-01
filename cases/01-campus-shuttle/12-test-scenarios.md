# Test Scenarios and Acceptance Criteria

## Purpose

This document defines functional, business-rule, data-quality, security,
API and recommendation-lifecycle test scenarios for the Campus Shuttle
Decision System.

The scenarios verify that the system:

- Records valid operational data
- Rejects invalid or incomplete records
- Calculates shuttle performance correctly
- Generates recommendations using documented business rules
- Preserves human approval and audit requirements
- Prevents unauthorized operational changes
- Handles boundary values consistently
- Produces explainable and traceable decisions

## Test Approach

The test set includes:

- Positive functional tests
- Negative validation tests
- Boundary-value tests
- Business-rule tests
- Data-quality tests
- API contract tests
- Security and authorization tests
- Auditability tests
- Recommendation effectiveness tests
- Failure and recovery scenarios

## Test Status Values

| Status | Description |
|---|---|
| Not Started | Test has not yet been executed |
| Passed | Actual result matches the expected result |
| Failed | Actual result differs from the expected result |
| Blocked | Test cannot be completed because of another issue |
| Not Applicable | Test is not relevant to the current implementation |

# Functional Test Scenarios

## TS-001: Create a Valid Route

**Related Requirement:** FR-001 Route Management

### Preconditions

- The user is authenticated.
- The user has route-management permission.
- No route exists with the identifier `ROUTE-A`.

### Test Data

| Field | Value |
|---|---|
| route_id | ROUTE-A |
| route_name | Central Campus - Dormitories |
| route_status | active |
| planned_duration_minutes | 35 |
| service_start_time | 07:00 |
| service_end_time | 23:00 |

### Steps

1. Open the route-management interface.
2. Select the create-route action.
3. Enter all required route information.
4. Submit the route record.

### Expected Result

- The route is created successfully.
- The route receives the identifier `ROUTE-A`.
- The route appears in the active-route list.
- An audit record is created.
- The audit record contains the responsible user and creation timestamp.

---

## TS-002: Reject a Duplicate Route Identifier

**Related Requirement:** FR-001 Route Management

### Preconditions

- A route with `route_id = ROUTE-A` already exists.
- The user has route-management permission.

### Steps

1. Attempt to create another route using `ROUTE-A`.
2. Submit the record.

### Expected Result

- The route is not created.
- The system returns a duplicate-identifier validation error.
- The original route remains unchanged.
- No new active route record is created.

---

## TS-003: Create a Valid Scheduled Trip

**Related Requirement:** FR-002 Trip Scheduling

### Preconditions

- Route `ROUTE-A` is active.
- Vehicle `VEHICLE-12` is available.
- The selected schedule period is active.

### Test Data

| Field | Value |
|---|---|
| trip_id | TRIP-2026-0801-0815 |
| route_id | ROUTE-A |
| vehicle_id | VEHICLE-12 |
| service_date | 2026-08-01 |
| planned_departure_at | 2026-08-01 08:15 |
| planned_arrival_at | 2026-08-01 08:50 |
| trip_status | planned |

### Expected Result

- The trip is created successfully.
- The trip is linked to the selected route and vehicle.
- The planned arrival time is later than the planned departure time.
- The trip appears in the daily operations schedule.

---

## TS-004: Reject a Trip With Invalid Timing

**Related Requirement:** FR-002 Trip Scheduling

### Test Data

| Field | Value |
|---|---|
| planned_departure_at | 2026-08-01 09:00 |
| planned_arrival_at | 2026-08-01 08:45 |

### Steps

1. Create a trip using the test timing values.
2. Submit the trip.

### Expected Result

- The trip is rejected.
- The system explains that planned arrival must be later than planned departure.
- No trip record is created.

---

## TS-005: Record a Valid Passenger Observation

**Related Requirement:** FR-003 Capacity Recording

### Preconditions

- The trip exists and is active.
- The related stop belongs to the trip route.

### Test Data

| Field | Value |
|---|---|
| observation_id | OBS-0001 |
| trip_id | TRIP-2026-0801-0815 |
| stop_id | STOP-04 |
| passenger_count | 42 |
| observation_method | sensor |
| confidence_score | 0.94 |

### Expected Result

- The observation is stored successfully.
- The observation is associated with the correct trip and stop.
- The system accepts the confidence score.
- Capacity utilization can be calculated from the observation.

---

## TS-006: Reject a Negative Passenger Count

**Related Requirement:** FR-003 Capacity Recording  
**Related Risk:** R-001 Incorrect Passenger Counts

### Test Data

```text
passenger_count = -4
```

### Expected Result

- The observation is rejected.
- The system displays a validation error.
- The invalid value is not used in KPI calculations.
- The failed request may be recorded for diagnostic purposes.

---

## TS-007: Calculate a Trip Delay

**Related Requirement:** FR-004 Delay Tracking

### Test Data

| Field | Value |
|---|---|
| planned_arrival_at | 09:00 |
| actual_arrival_at | 09:14 |

### Expected Result

```text
Arrival Delay = 14 minutes
```

- The trip is classified as significantly delayed.
- Business rule `BR-004` is satisfied.
- The delay is included in punctuality calculations.

---

## TS-008: Do Not Classify a Ten-Minute Delay as Significant

**Related Rules:** BR-004 Significant Delay

### Test Data

| Field | Value |
|---|---|
| planned_arrival_at | 09:00 |
| actual_arrival_at | 09:10 |

### Expected Result

- Calculated arrival delay is 10 minutes.
- The trip is not classified as significantly delayed.
- The trip remains within the accepted arrival tolerance.
- The trip contributes positively to the on-time performance rate.

---

## TS-009: Calculate Capacity Utilization

**Related Requirement:** FR-005 Utilization Calculation  
**Related KPI:** KPI-001 Capacity Utilization Rate

### Test Data

| Field | Value |
|---|---|
| passenger_count | 45 |
| usable_capacity | 50 |

### Expected Result

```text
Capacity Utilization Rate = 45 / 50 × 100 = 90%
```

- The calculated utilization is 90 percent.
- The trip exceeds the warning threshold.
- The trip does not exceed the critical 95 percent threshold.

---

## TS-010: Prevent Division by Zero in Utilization Calculation

**Related Requirement:** FR-005 Utilization Calculation  
**Related Risk:** R-004 Incorrect Vehicle Capacity

### Test Data

| Field | Value |
|---|---|
| passenger_count | 20 |
| usable_capacity | 0 |

### Expected Result

- The system does not calculate a percentage.
- The record is flagged as having invalid vehicle capacity.
- No capacity recommendation is generated from the record.
- The vehicle master-data issue is reported.

# Business-Rule Test Scenarios

## TS-011: Identify an Overcrowded Trip

**Related Rule:** BR-001 Overcapacity

### Test Data

| Passenger Count | Usable Capacity | Utilization |
|---:|---:|---:|
| 49 | 50 | 98% |

### Expected Result

- The trip is classified as overcrowded.
- The trip is included in the overcrowded-trip rate.
- The system records the triggering value and threshold.

---

## TS-012: Do Not Classify Exactly 95 Percent as Overcrowded

**Related Rule:** BR-001 Overcapacity

### Test Data

| Passenger Count | Usable Capacity | Utilization |
|---:|---:|---:|
| 38 | 40 | 95% |

### Expected Result

- The trip is not classified as overcrowded.
- The rule requires utilization to exceed 95 percent.
- No overcrowding alert is generated solely from this observation.

---

## TS-013: Trigger Persistent Overcapacity Review

**Related Rule:** BR-002 Persistent Overcapacity

### Test Data

Comparable trips for the same route and time slot:

| Trip | Utilization |
|---|---:|
| Trip 1 | 97% |
| Trip 2 | 101% |
| Trip 3 | 98% |
| Trip 4 | 84% |

### Preconditions

- All trips occurred within seven days.
- Observations meet the minimum confidence requirement.
- The trips are comparable by route, time slot and operating-day category.

### Expected Result

- Persistent overcapacity is detected.
- An additional-vehicle review is triggered.
- The recommendation contains the three qualifying trips as evidence.
- The lower-utilization trip remains visible but does not invalidate the rule.

---

## TS-014: Do Not Trigger Persistent Overcapacity With Only Two Trips

**Related Rule:** BR-002 Persistent Overcapacity

### Test Data

| Trip | Utilization |
|---|---:|
| Trip 1 | 98% |
| Trip 2 | 99% |

### Expected Result

- No additional-vehicle recommendation is generated.
- The system indicates that the minimum evidence count has not been reached.
- The high-utilization trips remain available for future evaluation.

---

## TS-015: Detect Repeated Low Utilization

**Related Rules:** BR-003 Low Utilization, BR-007 Reduced Frequency

### Test Data

Five comparable operating days:

| Day | Utilization |
|---|---:|
| Day 1 | 22% |
| Day 2 | 27% |
| Day 3 | 19% |
| Day 4 | 28% |
| Day 5 | 24% |

### Expected Result

- The time slot is classified as persistently underutilized.
- A frequency-review recommendation may be generated.
- The recommendation does not automatically reduce service.
- Minimum service and accessibility requirements remain part of the review.

---

## TS-016: Detect Recurring Delay

**Related Rule:** BR-005 Recurring Delay

### Test Data

Ten comparable trips:

- Three trips delayed more than 10 minutes
- Seven trips delayed 10 minutes or less

### Expected Result

```text
Recurring Delay Rate = 3 / 10 × 100 = 30%
```

- The recurring-delay rate exceeds 20 percent.
- A schedule-review recommendation is generated.
- Supporting trip identifiers and delay values are stored.

---

## TS-017: Do Not Trigger Recurring Delay at Exactly 20 Percent

**Related Rule:** BR-005 Recurring Delay

### Test Data

Ten comparable trips:

- Two trips delayed more than 10 minutes
- Eight trips delayed 10 minutes or less

### Expected Result

```text
Recurring Delay Rate = 20%
```

- No recurring-delay recommendation is generated.
- The rule requires the rate to exceed 20 percent.
- The metric remains visible as a warning-level result.

---

## TS-018: Prevent Automatic Schedule Modification

**Related Rule:** BR-008 Human Approval  
**Related Requirement:** NFR-002 Auditability

### Preconditions

- The system has generated a valid recommendation.
- The recommendation status is `pending`.

### Steps

1. Allow the recommendation process to complete.
2. Review the operational schedule.

### Expected Result

- The schedule remains unchanged.
- The recommendation status remains `pending`.
- Only an authorized human decision can approve the action.
- No vehicle or timetable modification occurs automatically.

---

## TS-019: Verify Recommendation Explanation

**Related Rule:** BR-009 Explanation  
**Related Requirement:** NFR-001 Explainability

### Expected Recommendation Content

- Triggering rule
- Target route
- Target time slot
- Supporting metrics
- Threshold values
- Confidence level
- Expected operational effect

### Expected Result

- All required explanation fields are present.
- Supporting evidence can be traced to operational records.
- A recommendation with missing evidence is not submitted for approval.

# Recommendation Lifecycle Tests

## TS-020: Generate an Additional-Vehicle Recommendation

**Related Requirements:** FR-006 Recommendation Generation

### Preconditions

- Persistent overcapacity requirements are satisfied.
- The supporting observations pass confidence checks.
- An alternative route does not provide adequate available capacity.

### Expected Result

- A new recommendation is created.
- `recommendation_type` is `add_vehicle`.
- Status is `pending`.
- Triggering rule is `BR-002` or `BR-006`.
- Evidence records are attached.
- Generation timestamp is recorded.

---

## TS-021: Approve a Pending Recommendation

**Related Requirement:** FR-006 Recommendation Generation  
**Related Rule:** BR-008 Human Approval

### Preconditions

- Recommendation `REC-2026-0042` exists.
- Recommendation status is `pending`.
- The user has approval permission.

### Test Data

| Field | Value |
|---|---|
| decision_status | approved |
| decision_reason | Repeated morning capacity problems are confirmed. |
| implementation_date | 2026-08-10 |

### Expected Result

- A recommendation-decision record is created.
- The recommendation status changes to `approved`.
- Reviewer identity and decision timestamp are stored.
- Implementation date is recorded.
- An audit event is created.

---

## TS-022: Reject a Pending Recommendation

### Preconditions

- The recommendation is pending.
- The reviewer has the required permission.

### Test Data

```text
Decision reason:
Passenger observations were affected by a temporary campus event and do not
represent normal demand.
```

### Expected Result

- The recommendation status changes to `rejected`.
- The rejection reason is stored.
- The supporting evidence is preserved.
- The operational schedule remains unchanged.

---

## TS-023: Prevent a Second Decision

**Related API Response:** HTTP 409 Conflict

### Preconditions

- The recommendation has already been approved.

### Steps

1. Submit a second approval or rejection request.

### Expected Result

- The second request is rejected.
- The existing decision remains unchanged.
- The API returns a conflict response.
- The attempted action is recorded in the audit log.

---

## TS-024: Expire an Outdated Recommendation

### Preconditions

- A recommendation has remained pending beyond its useful operating period.
- The underlying evidence period is no longer current.

### Expected Result

- Recommendation status changes to `expired`.
- The recommendation cannot be approved without re-evaluation.
- A new recommendation may be generated if current evidence still supports it.
- The original recommendation remains available historically.

---

## TS-025: Evaluate Recommendation Effectiveness

**Related KPI:** KPI-014 Recommendation Effectiveness Rate  
**Related Risk:** R-015 Recommendation Creates a New Operational Problem

### Test Data

| Metric | Before | Target | After |
|---|---:|---:|---:|
| Overcrowded trip rate | 24% | Below 10% | 8% |

### Expected Result

- The recommendation is classified as effective.
- Before-and-after measurements are stored.
- The evaluation period is documented.
- Effects on other routes are also reviewed.

---

## TS-026: Detect an Ineffective Recommendation

### Test Data

| Metric | Before | Target | After |
|---|---:|---:|---:|
| Average delay | 12 minutes | Below 8 minutes | 13 minutes |

### Expected Result

- The recommendation is classified as ineffective or worsened.
- The result is visible to operations management.
- The system does not silently classify implementation as successful.
- A review action can be initiated.

# Data-Quality Test Scenarios

## TS-027: Detect Missing Timing Data

**Related Risk:** R-002 Missing Trip Timing Data

### Test Data

- Trip status: `completed`
- Actual departure time: present
- Actual arrival time: missing

### Expected Result

- The trip is flagged as incomplete.
- The trip is excluded from reliable punctuality calculations.
- Data-quality coverage decreases.
- The dashboard shows a warning.

---

## TS-028: Detect Duplicate Trips

**Related Risk:** R-003 Duplicate Trip Records

### Test Data

Two records share:

- Route
- Vehicle
- Service date
- Planned departure time

### Expected Result

- The possible duplicate is detected.
- Only the accepted trip record contributes to KPIs.
- Related observations are reviewed before merging.
- The duplicate is not permanently deleted without trace.

---

## TS-029: Flag Low-Confidence Passenger Data

**Related Risk:** R-001 Incorrect Passenger Counts

### Test Data

```text
confidence_score = 0.54
```

### Expected Result

- The observation is marked as low confidence.
- The observation does not independently trigger a recommendation.
- The dashboard identifies limited data reliability.
- The record remains available for investigation.

---

## TS-030: Detect an Invalid Vehicle Capacity

### Test Data

```text
usable_capacity = -20
```

### Expected Result

- The vehicle record is rejected or quarantined.
- The value is not used in utilization calculations.
- The responsible data owner is alerted.
- Existing affected recommendations are reviewed.

---

## TS-031: Detect Missing Passenger Observations

### Preconditions

- A trip is completed.
- No passenger observation exists for the trip.

### Expected Result

- The trip is flagged as missing capacity data.
- Capacity KPIs exclude the trip from their reliable denominator.
- The data-quality report counts the missing observation.
- No capacity recommendation is based on the trip.

---

## TS-032: Preserve Original and Corrected Values

**Related Controls:** Audit and correction controls

### Preconditions

- A passenger count of 82 was recorded.
- Authorized review determines the correct value is 42.

### Expected Result

- The corrected value becomes active for calculations.
- The original value remains in history.
- Correction reason, user and timestamp are stored.
- Affected KPIs and recommendations are recalculated.

# API Contract Tests

## TS-033: Retrieve Valid Route Performance

**Endpoint**

```http
GET /routes/ROUTE-A/performance?startDate=2026-07-01&endDate=2026-07-31
```

### Expected Result

- API returns HTTP 200.
- Response includes route identifier.
- Response includes reporting period.
- Required KPI fields are present.
- Numeric fields follow the documented schema.

---

## TS-034: Reject an Invalid Date Range

**Endpoint**

```http
GET /routes/ROUTE-A/performance?startDate=2026-08-01&endDate=2026-07-01
```

### Expected Result

- API returns HTTP 400.
- Error response contains an error code.
- Error response contains a readable message.
- Error response contains a timestamp.

---

## TS-035: Return Route Not Found

**Endpoint**

```http
GET /routes/UNKNOWN/performance?startDate=2026-07-01&endDate=2026-07-31
```

### Expected Result

- API returns HTTP 404.
- Response uses the documented `ErrorResponse` schema.
- No unrelated route information is returned.

---

## TS-036: Filter Recommendations by Status

**Endpoint**

```http
GET /recommendations?status=pending
```

### Expected Result

- API returns HTTP 200.
- Every returned recommendation has `pending` status.
- Pagination information is included.
- Page size does not exceed the documented maximum.

---

## TS-037: Reject an Unsupported Recommendation Status

**Endpoint**

```http
GET /recommendations?status=waiting
```

### Expected Result

- API returns HTTP 400.
- The response identifies `waiting` as an unsupported value.
- Accepted values are not modified by the request.

---

## TS-038: Reject a Decision Reason That Is Too Short

**Endpoint**

```http
POST /recommendations/REC-2026-0042/decision
```

### Request Body

```json
{
  "decisionStatus": "approved",
  "decisionReason": "Okay"
}
```

### Expected Result

- API returns HTTP 400.
- The decision is not recorded.
- The response explains the minimum-length requirement.
- Recommendation status remains `pending`.

---

## TS-039: Retrieve Recommendation Evidence

**Endpoint**

```http
GET /recommendations/REC-2026-0042
```

### Expected Result

- API returns HTTP 200.
- Recommendation summary is included.
- Explanation is included.
- Supporting evidence is included.
- Threshold and measured values are included.
- Decision is `null` when the recommendation has not been reviewed.

# Security and Authorization Tests

## TS-040: Prevent an Unauthorized Route Change

**Related Risk:** R-008 Unauthorized Schedule Change

### Preconditions

- The user is authenticated as a reporting analyst.
- The role has read-only route access.

### Steps

1. Attempt to modify an active route.

### Expected Result

- The request is denied.
- The route remains unchanged.
- The authorization failure is logged.
- No administrative permission is granted automatically.

---

## TS-041: Prevent an Unauthorized Recommendation Decision

### Preconditions

- The user has analytics access but not approval permission.

### Steps

1. Attempt to approve a recommendation.

### Expected Result

- The request is denied.
- Recommendation status remains `pending`.
- The attempt is recorded.
- The response does not expose sensitive administrative details.

---

## TS-042: Protect System-Generated Evidence

**Related Risk:** R-009 Recommendation Manipulation

### Preconditions

- A recommendation and its evidence records exist.

### Steps

1. Attempt to manually modify the metric value in a recommendation-evidence record.

### Expected Result

- Direct modification is rejected.
- Original evidence remains unchanged.
- The attempted modification is logged.
- Corrections must use an authorized recalculation process.

---

## TS-043: Verify Sensitive Feedback Masking

**Related Risk:** R-013 Personal Data Exposure

### Test Data

A student feedback record contains:

- Full name
- Email address
- Complaint text

### Preconditions

- The user has access to aggregated operational reports but not personal data.

### Expected Result

- Personally identifiable fields are hidden or masked.
- The complaint category remains available for analysis.
- Unauthorized identity access is not possible.
- Access attempts are auditable.

---

## TS-044: Verify Segregation of Duties

### Preconditions

A user has permission to configure recommendation thresholds.

### Steps

1. Change an overcrowding threshold.
2. Attempt to approve a recommendation generated using that change.

### Expected Result

- Independent approval is required for the threshold change.
- High-impact actions cannot be completed by one user without review.
- Both actions are recorded separately.

# Auditability Tests

## TS-045: Record a Schedule Change

### Steps

1. Change the planned departure time from 08:00 to 08:15.
2. Enter a change reason.
3. Save the new schedule version.

### Expected Result

The audit record includes:

- Event identifier
- Responsible user
- Event timestamp
- Previous value: 08:00
- New value: 08:15
- Change reason
- Affected schedule identifier

---

## TS-046: Prevent Hard Deletion of a Decision

### Preconditions

- An approved recommendation decision exists.

### Steps

1. Attempt to permanently delete the decision.

### Expected Result

- Permanent deletion is rejected.
- The decision remains historically accessible.
- Authorized cancellation, correction or superseding procedures may be used.
- The deletion attempt is logged.

---

## TS-047: Maintain Recommendation Rule Version

### Preconditions

- Recommendation rule `BR-002` version 1 generated a recommendation.
- The rule is later updated to version 2.

### Expected Result

- The historical recommendation remains linked to version 1.
- New recommendations use version 2.
- Historical evidence is not recalculated silently.
- Rule-version changes are auditable.

# Availability and Recovery Tests

## TS-048: Use Approved Schedule During System Downtime

**Related Risk:** R-012 System Unavailability During Operations

### Preconditions

- The management system is unavailable.
- A previously approved daily schedule is available.

### Expected Result

- Operations staff can access the approved fallback schedule.
- No unapproved recommendation is implemented.
- Manual operational events can be recorded for later reconciliation.
- The outage is logged as an incident.

---

## TS-049: Reconcile Records After Recovery

### Preconditions

- Trips were recorded manually during downtime.
- The primary system has been restored.

### Expected Result

- Manual records are imported through a controlled process.
- Duplicate trips are detected.
- Reconciled records are marked with their source.
- KPIs are recalculated after validation.

---

## TS-050: Restore Audit Records From Backup

### Preconditions

- A test environment contains a simulated loss of audit records.
- A valid backup exists.

### Expected Result

- Audit records are restored successfully.
- Record sequence and completeness are checked.
- Any unrecoverable gaps are reported.
- The restoration activity is itself audited.

# Boundary-Value Test Matrix

| Test ID | Value | Expected Classification |
|---|---:|---|
| BV-001 | Utilization 29.99% | Low utilization |
| BV-002 | Utilization 30.00% | Not below low-utilization threshold |
| BV-003 | Utilization 85.00% | Within target upper boundary |
| BV-004 | Utilization 85.01% | Warning level |
| BV-005 | Utilization 95.00% | Not overcrowded |
| BV-006 | Utilization 95.01% | Overcrowded |
| BV-007 | Delay 10 minutes | On time under current rule |
| BV-008 | Delay 10 minutes 1 second | Significantly delayed |
| BV-009 | Confidence score 0 | Minimum valid numeric boundary |
| BV-010 | Confidence score 1 | Maximum valid numeric boundary |
| BV-011 | Confidence score below 0 | Invalid |
| BV-012 | Confidence score above 1 | Invalid |
| BV-013 | Passenger count 0 | Valid empty trip observation |
| BV-014 | Passenger count -1 | Invalid |
| BV-015 | Page size 100 | Valid API maximum |
| BV-016 | Page size 101 | Invalid |

# Acceptance Criteria Traceability Matrix

| Requirement or Rule | Covered By |
|---|---|
| FR-001 Route Management | TS-001, TS-002 |
| FR-002 Trip Scheduling | TS-003, TS-004 |
| FR-003 Capacity Recording | TS-005, TS-006 |
| FR-004 Delay Tracking | TS-007, TS-008 |
| FR-005 Utilization Calculation | TS-009, TS-010 |
| FR-006 Recommendation Generation | TS-020, TS-021, TS-022 |
| FR-007 Alert Management | TS-013, TS-016, TS-024 |
| FR-008 Feedback Connection | TS-043 |
| NFR-001 Explainability | TS-019, TS-039 |
| NFR-002 Auditability | TS-018, TS-045, TS-046, TS-047 |
| NFR-004 Security | TS-040, TS-041, TS-042, TS-043 |
| BR-001 Overcapacity | TS-011, TS-012 |
| BR-002 Persistent Overcapacity | TS-013, TS-014 |
| BR-003 Low Utilization | TS-015 |
| BR-004 Significant Delay | TS-007, TS-008 |
| BR-005 Recurring Delay | TS-016, TS-017 |
| BR-006 Additional Vehicle | TS-020 |
| BR-007 Reduced Frequency | TS-015 |
| BR-008 Human Approval | TS-018, TS-021 |
| BR-009 Explanation | TS-019 |

# Definition of Done

A feature is considered complete when:

- Related acceptance tests are documented.
- Positive and negative scenarios pass.
- Boundary conditions are verified.
- Authorization rules are enforced.
- Audit records are generated where required.
- Error responses follow the API contract.
- Data-quality failures are visible.
- No recommendation bypasses human approval.
- Test evidence is stored.
- Known limitations are documented.

# Test Evidence

Each executed test should record:

- Test identifier
- Execution date
- Environment
- Tester
- Input data
- Expected result
- Actual result
- Status
- Screenshot or log reference when relevant
- Defect identifier when failed
- Retest result

# Future Automated Testing Scope

The following areas may later be automated:

- API schema validation
- KPI calculation tests
- Business-rule boundary tests
- Duplicate-record checks
- Recommendation evidence validation
- Permission tests
- SQL regression tests
- Audit-event verification
- Data-quality coverage checks
- Before-and-after effectiveness calculations

Automated tests should complement, not replace, human review of operational
recommendations and service impacts.
