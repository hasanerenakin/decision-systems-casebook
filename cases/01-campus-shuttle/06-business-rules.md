# Business Rules

## Capacity Rules

### BR-001 Overcapacity

A trip is classified as overcrowded when estimated passenger count exceeds
95 percent of usable vehicle capacity.

### BR-002 Persistent Overcapacity

An additional vehicle review is triggered when a route exceeds 95 percent
utilization on at least three comparable trips within seven days.

### BR-003 Low Utilization

A trip is classified as underutilized when utilization remains below
30 percent for five comparable operating days.

## Delay Rules

### BR-004 Significant Delay

A trip is classified as delayed when actual arrival exceeds planned arrival
by more than ten minutes.

### BR-005 Recurring Delay

A schedule review is triggered when more than 20 percent of comparable trips
are significantly delayed.

## Recommendation Rules

### BR-006 Additional Vehicle

The system may recommend an additional vehicle when persistent overcapacity
is detected and no alternative route has available capacity.

### BR-007 Reduced Frequency

The system may recommend reduced frequency when low utilization is detected
and service-level requirements remain satisfied.

### BR-008 Human Approval

No recommendation shall automatically modify the operational schedule.

### BR-009 Explanation

Each recommendation must contain:

- Triggering rule
- Relevant route and time slot
- Supporting measurements
- Confidence level
- Expected operational effect
