# Case Study Summary

## Case

Campus Shuttle Decision System

## Domain

University Transportation Operations

## Status

Completed

## Overview

This case study designed an explainable decision-support system for improving
university shuttle operations.

The proposed system analyzes route performance, passenger capacity, delays,
service reliability and student feedback to generate operational
recommendations.

Recommendations may include:

- Adding a vehicle to an overcrowded route
- Reviewing an underutilized service period
- Revising a timetable
- Investigating recurring delays
- Monitoring service-quality problems

The system does not automatically change shuttle operations.

Every recommendation must be reviewed by an authorized decision-maker before
implementation.

## Business Problem

The university relies on fixed schedules, manual observations and passenger
complaints when managing shuttle services.

This creates several challenges:

- Overcrowded trips during peak periods
- Underutilized vehicles during low-demand periods
- Recurring delays
- Inconsistent operational records
- Limited visibility into route performance
- Decisions based on intuition rather than measurable evidence
- Difficulty evaluating whether operational changes are effective

## Proposed Solution

The proposed system combines operational measurements with documented
business rules.

The system:

1. Collects trip, vehicle, passenger and delay information.
2. Validates the quality of operational records.
3. Calculates route and service KPIs.
4. Detects threshold violations.
5. Generates explainable recommendations.
6. Presents supporting evidence to authorized reviewers.
7. Records approval or rejection decisions.
8. Monitors implementation results.
9. Compares before-and-after performance.

## Main System Capabilities

### Route and Trip Management

The system maintains:

- Routes
- Stops
- Route-stop relationships
- Vehicles
- Scheduled trips
- Actual trip times
- Vehicle assignments

### Capacity Monitoring

The system evaluates:

- Passenger counts
- Vehicle usable capacity
- Capacity-utilization rates
- Overcrowded trips
- Low-utilization trips
- Persistent demand patterns

### Delay Monitoring

The system calculates:

- Arrival delays
- On-time performance
- Recurring delay rates
- Delay reasons
- Schedule adherence

### Passenger Feedback

Feedback can be connected to:

- Routes
- Stops
- Individual trips
- Delay events
- Overcrowding problems
- Accessibility concerns

### Recommendation Management

The recommendation lifecycle includes:

- Generation
- Evidence attachment
- Priority assignment
- Human review
- Approval or rejection
- Implementation
- Post-implementation evaluation
- Expiration or withdrawal

## Key Business Rules

The case defined rules for:

- Overcapacity detection
- Persistent overcapacity
- Low utilization
- Significant delay
- Recurring delay
- Additional-vehicle review
- Service-frequency review
- Human approval
- Recommendation explainability

Boundary values were documented to ensure consistent interpretation.

Examples:

- Utilization must exceed 95 percent to be classified as overcrowded.
- A delay must exceed 10 minutes to be classified as significant.
- Persistent patterns require multiple comparable trips.
- No recommendation may automatically change the operational schedule.

## Key Performance Indicators

The KPI framework includes:

- Capacity Utilization Rate
- Overcrowded Trip Rate
- Low-Utilization Trip Rate
- On-Time Performance Rate
- Average Arrival Delay
- Recurring Delay Rate
- Trip Completion Rate
- Schedule Adherence Rate
- Complaint Rate
- Feedback Resolution Rate
- Recommendation Approval Rate
- Recommendation Response Time
- Recommendation Implementation Rate
- Recommendation Effectiveness Rate

Each KPI includes:

- A documented formula
- A calculation level
- A target value
- Warning and critical thresholds
- Related business rules
- Data-quality requirements

## Data Model

The conceptual model includes the following operational entities:

- Route
- Stop
- Route Stop
- Vehicle
- Trip
- Passenger Observation
- Delay Event
- Student Feedback

Decision-support entities include:

- Recommendation
- Recommendation Evidence
- Recommendation Decision

The model separates system-generated recommendations from human decisions.

This separation supports:

- Explainability
- Accountability
- Historical analysis
- Auditability
- Before-and-after evaluation

## API Design

The OpenAPI contract defines operations for:

- Retrieving route performance
- Listing recommendations
- Filtering recommendations
- Viewing recommendation evidence
- Approving recommendations
- Rejecting recommendations

The API contract also defines:

- Request parameters
- Response schemas
- Pagination
- Error responses
- Validation rules
- Conflict handling

## Analytics

The analytical SQL covers:

- Route performance summaries
- Peak-hour capacity analysis
- Recurring-delay detection
- Low-utilization detection
- Delay-reason analysis
- Passenger complaint rates
- Pending recommendations
- Recommendation review performance
- Before-and-after implementation analysis
- Data-quality coverage

The queries connect operational measurements with management decisions.

## Risk and Control Framework

The case identifies risks involving:

- Incorrect passenger counts
- Missing timing data
- Duplicate trips
- Incorrect vehicle capacity
- Outdated schedules
- False recommendations
- Delayed reviews
- Unauthorized changes
- Recommendation manipulation
- Audit-history loss
- Accessibility failures
- System unavailability
- Personal-data exposure
- Incorrect thresholds
- Unintended operational consequences

Controls are categorized as:

- Preventive
- Detective
- Corrective

The framework also defines:

- Control ownership
- Segregation of duties
- Audit requirements
- Incident management
- Residual risk
- Review frequency

## Testing Coverage

The test scenarios cover:

- Functional requirements
- Business rules
- Boundary values
- Data quality
- API responses
- Authorization
- Recommendation lifecycle
- Auditability
- Availability
- Recovery
- Post-implementation evaluation

The test documentation includes traceability between requirements, rules and
acceptance scenarios.

## Architectural Decision

The case adopted a human-approved recommendation model.

The system generates recommendations but does not automatically:

- Modify schedules
- Assign vehicles
- Reduce frequency
- Cancel trips
- Publish timetable changes

This decision was selected because operational recommendations may be affected
by incomplete data, accessibility requirements, temporary events and
conditions that are not represented in structured records.

The approach combines analytical consistency with human accountability.

## Deliverables

| Deliverable | File |
|---|---|
| Case overview | `README.md` |
| Problem definition | `01-problem-brief.md` |
| Stakeholder analysis | `02-stakeholders.md` |
| Requirements | `03-requirements.md` |
| Current process | `04-as-is-process.md` |
| Proposed process | `05-to-be-process.md` |
| Business rules | `06-business-rules.md` |
| Conceptual data model | `07-data-model.md` |
| OpenAPI contract | `08-api-contract.yml` |
| KPI framework | `09-kpi-framework.md` |
| Analytical SQL | `10-analytics.sql` |
| Risk and control framework | `11-risk-controls.md` |
| Test scenarios | `12-test-scenarios.md` |
| Architectural decision | `adr/adr-001-human-approved-recommendations.md` |

## Skills Demonstrated

This case study demonstrates:

- Business analysis
- Requirements engineering
- Stakeholder analysis
- Process modeling
- Business-rule design
- Decision-support system design
- Conceptual data modeling
- API contract design
- SQL analytics
- KPI development
- Risk and control analysis
- Acceptance testing
- Architecture decision documentation
- Technical writing

## Limitations

This repository currently represents a system-design case study rather than a
deployed production application.

The case does not currently include:

- A running backend service
- A user interface
- A production database
- Real university transportation data
- Live vehicle integrations
- Automated API tests
- Infrastructure configuration

These limitations are documented so that the scope is represented accurately.

## Potential Future Development

The case may later be expanded with:

- A physical relational database design
- Sample datasets
- Executable SQL scripts
- A dashboard prototype
- API implementation
- Automated rule evaluation
- Role-based interface prototypes
- Recommendation simulation
- Cost-impact analysis
- Route optimization models

## Final Outcome

The case demonstrates how an operational transportation problem can be
converted into a structured, measurable and auditable decision-support system.

The final design connects:

- Business problems
- Stakeholder needs
- System requirements
- Operational processes
- Data structures
- Business rules
- KPIs
- Analytical queries
- Risk controls
- Test scenarios
- Human decision-making

The resulting system design supports evidence-based shuttle management while
preserving operational judgment, accessibility, accountability and control.
