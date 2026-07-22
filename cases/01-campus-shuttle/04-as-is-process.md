# As-Is Process

## Current Vehicle Allocation Process

```mermaid
flowchart TD
    A[Academic term begins] --> B[Management prepares fixed schedule]
    B --> C[Vehicles assigned to routes]
    C --> D[Shuttle services operate]
    D --> E{Complaint received?}
    E -- No --> D
    E -- Yes --> F[Complaint reviewed manually]
    F --> G[Dispatcher contacts driver]
    G --> H{Change considered necessary?}
    H -- No --> D
    H -- Yes --> I[Temporary schedule or vehicle change]
    I --> D
```

## Process Weaknesses

- Performance is evaluated mainly through complaints.
- Capacity is not measured consistently.
- Temporary changes are not formally analyzed.
- Schedule decisions are not supported by historical evidence.
- There is no standard recommendation process.
