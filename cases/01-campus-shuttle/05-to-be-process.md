# To-Be Process

```mermaid
flowchart TD
    A[Trip completed] --> B[Collect passenger and timing data]
    B --> C[Validate trip records]
    C --> D[Calculate utilization and delay metrics]
    D --> E[Apply recommendation rules]
    E --> F{Threshold exceeded?}
    F -- No --> G[Store performance result]
    F -- Yes --> H[Generate recommendation]
    H --> I[Operations manager reviews evidence]
    I --> J{Recommendation approved?}
    J -- No --> K[Record rejection reason]
    J -- Yes --> L[Update vehicle or schedule plan]
    L --> M[Measure result after implementation]
    M --> G
```

## Improvements

- Decisions are based on operational measurements.
- Recommendations remain subject to human approval.
- Rejected recommendations are recorded.
- Changes can be compared with later performance.
- Every recommendation is traceable.
