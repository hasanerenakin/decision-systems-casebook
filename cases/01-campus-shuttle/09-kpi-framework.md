# KPI Framework

## Purpose

This framework defines the key performance indicators used to evaluate
shuttle capacity, punctuality, service reliability, passenger experience
and recommendation effectiveness.

The indicators support operational decision-making while ensuring that
every recommendation is based on measurable and traceable evidence.

## KPI Design Principles

Each KPI should be:

- Clearly connected to a business objective
- Calculated using a documented formula
- Measured at a defined level of detail
- Supported by reliable source data
- Comparable across routes and time periods
- Interpreted together with operational context
- Traceable to the recommendation rules it supports

## Business Objectives

| Objective | Description |
|---|---|
| Capacity efficiency | Use available vehicle capacity effectively |
| Service reliability | Complete scheduled trips consistently |
| Punctuality | Reduce recurring departure and arrival delays |
| Passenger experience | Reduce overcrowding and service complaints |
| Operational control | Provide explainable and reviewable recommendations |
| Continuous improvement | Measure whether approved changes create benefits |

# Capacity KPIs

## KPI-001 Capacity Utilization Rate

Measures how much of a vehicle's usable capacity was occupied during a trip.

```text
Capacity Utilization Rate =
Passenger Count / Usable Vehicle Capacity × 100
```

| Attribute | Definition |
|---|---|
| Unit | Percentage |
| Calculation grain | Trip and passenger observation |
| Primary source | Passenger Observation, Vehicle |
| Target range | 50%–85% |
| Warning threshold | Above 85% |
| Critical threshold | Above 95% |

### Interpretation

- Very low utilization may indicate unnecessary frequency or excessive capacity.
- High utilization may indicate insufficient vehicle capacity.
- Utilization above 100% may represent overcrowding, standing passengers or an unreliable observation.

## KPI-002 Overcrowded Trip Rate

Measures the percentage of completed trips that exceeded the accepted
utilization threshold.

```text
Overcrowded Trip Rate =
Overcrowded Completed Trips / Total Completed Trips × 100
```

A trip is classified as overcrowded when its maximum observed utilization
exceeds 95 percent.

| Attribute | Definition |
|---|---|
| Unit | Percentage |
| Calculation grain | Route, time slot and reporting period |
| Target | Below 5% |
| Warning threshold | 5%–10% |
| Critical threshold | Above 10% |
| Related rules | BR-001, BR-002, BR-006 |

## KPI-003 Low-Utilization Trip Rate

Measures the percentage of completed trips operating below the accepted
minimum utilization level.

```text
Low-Utilization Trip Rate =
Trips Below 30% Utilization / Total Completed Trips × 100
```

| Attribute | Definition |
|---|---|
| Unit | Percentage |
| Target | Below 15% |
| Warning threshold | 15%–25% |
| Critical threshold | Above 25% |
| Related rules | BR-003, BR-007 |

Low utilization should not automatically result in service reduction.
Accessibility, minimum service frequency and alternative transport options
must also be considered.

# Punctuality KPIs

## KPI-004 On-Time Performance Rate

Measures the percentage of completed trips arriving within the accepted
delay tolerance.

```text
On-Time Performance Rate =
Trips Arriving Within 10 Minutes of Schedule /
Completed Trips With Valid Timing Data × 100
```

| Attribute | Definition |
|---|---|
| Unit | Percentage |
| Target | At least 90% |
| Warning threshold | 80%–89.99% |
| Critical threshold | Below 80% |
| Related rules | BR-004, BR-005 |

Cancelled trips are excluded from this calculation and evaluated separately.

## KPI-005 Average Arrival Delay

Measures the average number of minutes by which completed trips arrived
later than planned.

```text
Average Arrival Delay =
Sum of Positive Arrival Delay Minutes /
Number of Delayed Completed Trips
```

| Attribute | Definition |
|---|---|
| Unit | Minutes |
| Target | Below 5 minutes |
| Warning threshold | 5–10 minutes |
| Critical threshold | Above 10 minutes |

Trips arriving early are not used to reduce the average delay value.
Early arrivals should be measured separately because they may also create
service problems.

## KPI-006 Recurring Delay Rate

Measures how frequently comparable trips experience significant delays.

```text
Recurring Delay Rate =
Trips Delayed More Than 10 Minutes /
Comparable Completed Trips × 100
```

Comparable trips should share:

- The same route
- A similar departure time
- The same operating-day category
- A defined reporting period

| Attribute | Definition |
|---|---|
| Unit | Percentage |
| Target | Below 10% |
| Warning threshold | 10%–20% |
| Critical threshold | Above 20% |
| Related rule | BR-005 |

# Reliability KPIs

## KPI-007 Trip Completion Rate

Measures the percentage of scheduled trips completed successfully.

```text
Trip Completion Rate =
Completed Trips / Scheduled Trips × 100
```

| Attribute | Definition |
|---|---|
| Unit | Percentage |
| Target | At least 98% |
| Warning threshold | 95%–97.99% |
| Critical threshold | Below 95% |

Cancelled trips should also be categorized by reason:

- Vehicle failure
- Driver unavailability
- Weather
- Road closure
- Operational decision
- Data error

## KPI-008 Schedule Adherence Rate

Measures the percentage of trips departing and arriving within accepted
timing limits.

A trip is schedule-adherent when:

- Departure delay is no more than 5 minutes
- Arrival delay is no more than 10 minutes

```text
Schedule Adherence Rate =
Schedule-Adherent Trips / Completed Trips × 100
```

| Attribute | Definition |
|---|---|
| Unit | Percentage |
| Target | At least 85% |
| Warning threshold | 75%–84.99% |
| Critical threshold | Below 75% |

# Passenger Experience KPIs

## KPI-009 Complaint Rate

Measures the number of submitted complaints relative to completed trips.

```text
Complaint Rate =
Number of Relevant Complaints /
Number of Completed Trips × 100
```

| Attribute | Definition |
|---|---|
| Unit | Complaints per 100 completed trips |
| Calculation grain | Route, category and reporting period |
| Target | Below 3 |
| Warning threshold | 3–5 |
| Critical threshold | Above 5 |

Complaints should be grouped into categories:

- Delay
- Overcrowding
- Safety
- Accessibility
- Driver conduct
- Route coverage
- Service information

## KPI-010 Feedback Resolution Rate

Measures the percentage of reviewed feedback records that were resolved.

```text
Feedback Resolution Rate =
Resolved Feedback Records /
Feedback Records Requiring Action × 100
```

| Attribute | Definition |
|---|---|
| Unit | Percentage |
| Target | At least 90% |
| Warning threshold | 75%–89.99% |
| Critical threshold | Below 75% |

# Decision-Support KPIs

## KPI-011 Recommendation Approval Rate

Measures the percentage of reviewed recommendations approved by authorized
operations managers.

```text
Recommendation Approval Rate =
Approved Recommendations /
Reviewed Recommendations × 100
```

This KPI should not be treated as a success measure on its own.

A very high approval rate may indicate useful recommendations, but it may also
indicate weak review controls. A very low approval rate may indicate poor rule
quality or incomplete evidence.

## KPI-012 Recommendation Response Time

Measures the time between recommendation generation and human review.

```text
Recommendation Response Time =
Decision Timestamp - Recommendation Generation Timestamp
```

| Attribute | Definition |
|---|---|
| Unit | Hours |
| Target | Below 24 hours |
| Warning threshold | 24–48 hours |
| Critical threshold | Above 48 hours |

## KPI-013 Recommendation Implementation Rate

Measures the percentage of approved recommendations implemented within the
planned period.

```text
Recommendation Implementation Rate =
Implemented Approved Recommendations /
Approved Recommendations × 100
```

| Attribute | Definition |
|---|---|
| Unit | Percentage |
| Target | At least 85% |
| Warning threshold | 70%–84.99% |
| Critical threshold | Below 70% |

## KPI-014 Recommendation Effectiveness Rate

Measures whether implemented recommendations achieved their expected
operational improvement.

```text
Recommendation Effectiveness Rate =
Effective Implemented Recommendations /
Evaluated Implemented Recommendations × 100
```

A recommendation is considered effective when its target KPI improves by the
minimum value defined before implementation.

Example:

- Recommendation: Add one vehicle to Route A between 08:00 and 09:00
- Baseline overcrowded trip rate: 24%
- Target overcrowded trip rate: Below 10%
- Post-implementation result: 8%
- Evaluation: Effective

# KPI Summary

| KPI | Target | Main Decision Area |
|---|---:|---|
| Capacity Utilization Rate | 50%–85% | Vehicle allocation |
| Overcrowded Trip Rate | Below 5% | Additional capacity |
| Low-Utilization Trip Rate | Below 15% | Frequency review |
| On-Time Performance Rate | At least 90% | Schedule revision |
| Average Arrival Delay | Below 5 minutes | Delay investigation |
| Recurring Delay Rate | Below 10% | Route and schedule review |
| Trip Completion Rate | At least 98% | Service reliability |
| Schedule Adherence Rate | At least 85% | Operational control |
| Complaint Rate | Below 3 per 100 trips | Passenger experience |
| Feedback Resolution Rate | At least 90% | Service management |
| Recommendation Response Time | Below 24 hours | Management review |
| Recommendation Implementation Rate | At least 85% | Operational execution |

# Analysis Dimensions

KPIs should be filterable by:

- Route
- Stop
- Vehicle
- Time slot
- Day of week
- Academic or holiday period
- Vehicle type
- Feedback category
- Delay reason
- Recommendation status

These dimensions allow managers to distinguish persistent operational
problems from temporary or isolated events.

# Reporting Periods

The system should support:

- Daily operational monitoring
- Weekly route reviews
- Monthly management reporting
- Academic-term comparisons
- Before-and-after recommendation analysis

Different reporting periods should not be compared without considering
seasonal demand, holidays and university calendar changes.

# Data Quality Requirements

A KPI should not be presented as reliable when:

- Vehicle capacity is missing
- Passenger observation confidence is below the accepted limit
- Planned or actual timing information is missing
- Trip status is inconsistent
- Duplicate trip records exist
- Reporting coverage is below the minimum threshold

The dashboard should display a data-quality warning when a KPI is calculated
using incomplete or low-confidence records.

# Governance

Each KPI must have:

- A business owner
- A technical owner
- A documented formula
- A defined source
- A review frequency
- A threshold approval process
- A version history

Changes to formulas or thresholds should be documented because they can alter
historical comparisons and recommendation results.
