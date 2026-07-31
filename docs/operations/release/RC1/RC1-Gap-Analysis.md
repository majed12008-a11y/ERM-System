# RC1 Gap Analysis

## ✅ Passed — Ready for RC1

| Area | Status | Notes |
|---|---|---|
| Backend E2E tests | 102/102 PASS | All phases (Users, Projects, Committee, Reviews, Safety, Reports, Admin, Comms, Workflow) |
| Frontend build | PASS | `tsc -b && vite build` — 0 errors |
| Frontend lint | 286 warnings | All `no-explicit-any` in SDK layer — pre-existing, tracked tech debt |
| Backend lint | — | Not run this session; assumes same quality as frontend |
| Documentation | 9 files | Architecture, Deployment, Governance, OpenAPI, Performance, Rollback, Runbook, Frontend Architecture, Page Map |

## ❌ Gaps — Post-RC1 Priority

### P0 — Critical

| ID | Gap | Details |
|---|---|---|
| G1 | Frontend unit tests | Only 2 test files exist (`LoginPage.test.tsx`, `StatusBadge.test.tsx`). Need component + integration tests for all 30+ pages. |
| G2 | Backend integration tests | Only E2E tests exist. Missing service-level and repository-level unit tests. |

### P1 — High

| ID | Gap | Details |
|---|---|---|
| G3 | SDK type coverage | ✅ **Done** — All 110+ SDK methods now have proper TypeScript types |
| G4 | No Dockerfile | ✅ **Done** — `backend/Dockerfile`, `frontend/Dockerfile`, `nginx.conf`, `docker-compose.yml` |
| G5 | No CI/CD pipeline | ✅ **Done** — GitHub Actions: backend lint/build/test, frontend build, E2E tests, Docker build+push |
| G6 | No monitoring/alerting | No Prometheus metrics, Grafana dashboards, or health check integrations beyond basic `/health`. |

### P2 — Medium

| ID | Gap | Details |
|---|---|---|
| G7 | SSE auth hardening | JWT in query params (EventSource limitation) is logged by proxies. Consider cookie-based SSE auth. |
| G8 | Rate limiting | No rate limiting on any route. High-load national system will need it. |
| G9 | No migration system | Schema is raw SQL files (`DDL Script.sql`, `ethics_db_tables.sql`, etc.). No versioned migration tool (e.g., Flyway, Prisma). |
| G10 | Integration endpoint docs | `integration.sdk.ts` exists but no integration page or documented use case (webhooks, external APIs). |
| G11 | Storybook / component docs | No component library docs. 12 custom UI components undocumented. |
| G12 | Error handling audit | No centralized error handler beyond Axios interceptor + sonner toasts. Error boundaries on some routes only. |

### P3 — Low

| ID | Gap | Details |
|---|---|---|
| G13 | Performance test refresh | Baseline from earlier session; needs re-run after all RC1 fixes. |
| G14 | Security audit | RLS policies verified for SELECT/INSERT; need full audit of UPDATE/DELETE policies across all tables. |
| G15 | Audit tag cleanup | First `rc1-candidate` tag was deleted; `rc1` is current. No release on remote yet. |

## Suggested Roadmap

```
RC1 (now)       → All 102 E2E tests pass, docs complete, tag rc1
RC1-hardening   → G1 (unit tests), G3 (SDK types), G12 (error handling)
RC2             → G4 (Docker), G5 (CI/CD), G8 (rate limiting), G9 (migrations)
Post-RC2        → G6 (monitoring), G7 (SSE auth), G10 (integration), G11 (Storybook)
```
