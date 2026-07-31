# RC1 — Performance Baseline v1.0

## Load Test Summary (H3)

- **Date**: Recorded
- **Tool**: Custom k6-style script via `backend/load-test.mjs`
- **Scenarios**: 6 (Auth, Project CRUD, Application Workflow, Committee Ops, Communication, Dashboard & Reporting)
- **Load**: 15 iterations × 5 concurrent users = 345 requests

## Results

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Error Rate | 0.58% | < 1% | ✅ |
| Pool Exhaustion | 0 | 0 | ✅ |
| Deadlocks | 0 | 0 | ✅ |
| Global P50 | 6.5 ms | — | — |
| Global P95 | 85.3 ms | < 300 ms | ✅ |
| PG Cache Hit Ratio | 99.8% | — | — |

### Per-Endpoint P95

| Endpoint Group | P95 | Status |
|----------------|-----|--------|
| CRUD Operations | < 100 ms | ✅ |
| Reporting | < 11 ms | ✅ |
| Communication | 16 ms | ✅ |

## Performance Optimizations Applied

| Optimization | Impact |
|--------------|--------|
| P0-1: `query()` read/write split | 4→2 RTT per query |
| P0-2: `committeeDecision` single transaction | 24→8 RTT, 5→1 connections |
| P0-3: `autoTransition`/`updateStatus` chain | client injection through chain |
| P1-A: `createMessage()` batch unnest | 1+N+M→3 queries |
| P1-B: `createAndNotifyBatch()` | N→1 INSERT per path |
| P1-C: Admin Stats LATERAL join | 6→1 queries |
| H1.2: Dashboard LATERAL join | 4→1 queries |
| H1.2: Pagination added | LIMIT/OFFSET on list endpoints |
| H1.3: 15 pagination indexes | created_at DESC across 8 schemas |

## Frozen Baseline

Any future change to Transaction Layer or pool config must be re-benchmarked against this baseline.
