# Decision Systems Casebook

A portfolio repository containing structured business analysis, system design
and decision-support case studies.

The repository demonstrates how complex operational problems can be translated
into:

- Clear problem definitions
- Stakeholder and decision-right analysis
- Current-state and future-state workflows
- Functional and non-functional requirements
- Business rules
- Conceptual data models
- API contracts
- Decision-support logic
- KPI frameworks
- Analytical SQL
- Risk and control models
- Test scenarios
- Architecture decision records

The cases focus on designing understandable, traceable and human-governed
systems rather than presenting isolated code examples.

## Repository Status

**2 completed case studies**

| No. | Case | Domain | Status |
|---:|---|---|---|
| 01 | [Campus Shuttle Decision-Support System](cases/01-campus-shuttle/) | University Transportation Operations | **Completed** |
| 02 | [Internship Placement and Matching System](cases/02-internship-placement/) | University Career Services | **Completed** |

## Case 01: Campus Shuttle Decision-Support System

The first case designs a decision-support system for university shuttle
operations.

The case addresses challenges such as:

- Uncertain passenger demand
- Overcrowded or underutilized trips
- Manual dispatch decisions
- Limited operational visibility
- Delayed response to demand changes
- Inconsistent service-level measurement

The proposed design supports:

- Demand observation
- Occupancy monitoring
- Dispatch recommendations
- Human-approved operational decisions
- Route and trip analysis
- KPI reporting
- Risk controls
- Decision traceability

The system generates recommendations while preserving the authority of human
dispatchers.

### Main Deliverables

- Problem brief
- Stakeholder analysis
- Requirements
- Current-state process
- Future-state process
- Business rules
- Conceptual data model
- OpenAPI contract
- KPI framework
- Analytical SQL
- Risk and control framework
- Test scenarios
- Final case summary
- Architecture decision record

[Open the Campus Shuttle case](cases/01-campus-shuttle/)

## Case 02: Internship Placement and Matching System

The second case designs an explainable internship placement and matching system
for a university career center.

The case addresses challenges such as:

- Fragmented student information
- Inconsistent academic eligibility checks
- Unstructured employer requirements
- Manual candidate comparison
- Limited application visibility
- Opportunity-capacity conflicts
- Unexplained recommendations
- Informal exception handling
- Delayed intervention for unplaced students
- Weak decision traceability

The proposed design supports:

- Versioned student profiles
- Academic eligibility evaluation
- Authorized academic exceptions
- Employer verification
- Structured internship opportunities
- Mandatory requirement evaluation
- Multi-dimensional compatibility scoring
- Separate confidence evaluation
- Explainable recommendations
- Human review and controlled overrides
- Placement offers
- Temporary capacity reservations
- Final placement confirmation
- Internship outcomes
- Unplaced-student intervention
- Operational and governance reporting

The central architectural decision is to separate eligibility from
compatibility scoring.

A high compatibility score cannot compensate for:

- Academic ineligibility
- Failed mandatory requirements
- Missing mandatory evidence
- Blocking student constraints
- Invalid employer or opportunity status

Recommendations remain advisory and final placement requires authorized human
review.

### Main Deliverables

- Problem brief
- Stakeholder and decision-right analysis
- Functional and non-functional requirements
- Current-state process
- Future-state process
- Detailed business-rule catalog
- Conceptual data model
- Matching model
- OpenAPI contract
- KPI framework
- PostgreSQL-oriented analytical SQL
- Risk and control framework
- Functional and end-to-end test scenarios
- Final case summary
- Architecture decision record

[Open the Internship Placement case](cases/02-internship-placement/)

## Case Design Method

Each case follows a consistent analysis and design sequence.

```mermaid
flowchart LR
    A[Problem Definition] --> B[Stakeholder Analysis]
    B --> C[Requirements]
    C --> D[Current-State Process]
    D --> E[Future-State Process]
    E --> F[Business Rules]
    F --> G[Data Model]
    G --> H[API and Decision Logic]
    H --> I[KPI and Analytics]
    I --> J[Risk and Controls]
    J --> K[Test Scenarios]
    K --> L[Case Summary and ADR]
```

## Decision-Support Principles

### Human Accountability

The designed systems support decisions without automatically replacing
accountable human roles.

### Explainability

Recommendations and evaluations retain the rules, indicators, evidence and
versions that produced them.

### Separation of Decision States

Different decision concepts remain separate.

Examples include:

- Observation and recommendation
- Eligibility and compatibility
- Recommendation and approval
- Offer and confirmed placement
- Reservation and consumed capacity
- Internship completion and academic-credit approval

### Historical Traceability

Material decisions preserve:

- Input version
- Rule version
- Model version
- Human decision
- Override reason
- Status history
- Audit evidence

### Data Quality

Missing, stale, conflicting and unverified information remains visible.

Missing critical information is not silently treated as a confirmed failure or
a favorable default.

### Privacy and Access Control

Users receive only the information necessary for their authorized purpose.

### Measurable Outcomes

Every case connects operational workflows with defined KPIs and analytical
queries.

### Risk-Based Design

High-impact workflows include preventive, detective and corrective controls.

## Repository Structure

```text
decision-systems-casebook/
├── README.md
└── cases/
    ├── 01-campus-shuttle/
    │   ├── README.md
    │   ├── 01-problem-brief.md
    │   ├── 02-stakeholders.md
    │   ├── 03-requirements.md
    │   ├── 04-as-is-process.md
    │   ├── 05-to-be-process.md
    │   ├── 06-business-rules.md
    │   ├── 07-data-model.md
    │   ├── 08-api-contract.yml
    │   ├── 09-kpi-framework.md
    │   ├── 10-analytics.sql
    │   ├── 11-risk-controls.md
    │   ├── 12-test-scenarios.md
    │   ├── 13-case-summary.md
    │   └── adr/
    │       └── adr-001-human-approved-recommendations.md
    │
    └── 02-internship-placement/
        ├── README.md
        ├── 01-problem-brief.md
        ├── 02-stakeholders.md
        ├── 03-requirements.md
        ├── 04-as-is-process.md
        ├── 05-to-be-process.md
        ├── 06-business-rules.md
        ├── 07-data-model.md
        ├── 08-matching-model.md
        ├── 09-api-contract.yml
        ├── 10-kpi-framework.md
        ├── 11-analytics.sql
        ├── 12-risk-controls.md
        ├── 13-test-scenarios.md
        ├── 14-case-summary.md
        └── adr/
            └── adr-001-separate-eligibility-from-scoring.md
```

## Skills Demonstrated

### Business Analysis

- Problem framing
- Scope definition
- Stakeholder analysis
- Decision-right analysis
- Requirements engineering
- Process modeling
- Business-rule specification
- Acceptance criteria

### Systems Analysis

- Conceptual data modeling
- Entity and relationship design
- Status lifecycle design
- Data-quality requirements
- Integration design
- API contract design
- Traceability

### Decision-Support Design

- Rule-based eligibility
- Recommendation workflows
- Compatibility scoring
- Confidence calculation
- Explainability
- Human review
- Controlled overrides
- Architecture decision records

### Data and Analytics

- KPI design
- Funnel analysis
- Capacity analysis
- Operational reporting
- Outcome measurement
- Analytical SQL
- Data-quality monitoring
- Fairness and access indicators

### Risk and Governance

- Risk registers
- Preventive controls
- Detective controls
- Corrective controls
- Role-based access
- Segregation of duties
- Privacy analysis
- Auditability
- Recovery planning

### Quality Assurance

- Functional testing
- Boundary-value testing
- Authorization testing
- Business-rule testing
- Concurrency testing
- Integration testing
- End-to-end testing
- Recovery testing

## Technology and Documentation Formats

The repository uses:

- Markdown
- Mermaid diagrams
- YAML
- OpenAPI 3.0
- SQL
- PostgreSQL-oriented analytical syntax
- Architecture Decision Records

These formats make each case readable, reviewable and suitable for version
control.

## Portfolio Positioning

The casebook is designed to demonstrate the connection between:

```text
Business Problem
→ Process
→ Requirements
→ Rules
→ Data
→ Services
→ Decisions
→ Controls
→ Measurement
```

This approach reflects the responsibilities found across roles such as:

- Business Analyst
- Systems Analyst
- Business Systems Analyst
- Product Analyst
- Operations Analyst
- Data Analyst
- Decision-Support Analyst
- Junior Product Manager
- Technology and Process Consultant

## Important Note

The cases are design studies.

They do not represent deployed production systems and do not contain real
student, employer, passenger or institutional data.

All sample:

- Rules
- Thresholds
- Weights
- Service levels
- Risk scores
- KPI targets
- API addresses
- Identifiers

are illustrative and would require stakeholder, legal, privacy, security and
technical validation before real implementation.

## Current Progress

- [x] Case 01 — Campus Shuttle Decision-Support System
- [x] Case 02 — Internship Placement and Matching System
- [ ] Additional decision-system cases

The repository will continue to expand with cases from different operational
domains while preserving the same structured analysis and design approach.
