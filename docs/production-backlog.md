# Production Backlog — RC1

> Generated: 2026-07-09
> Phase 9.5 Engineering Triage — validated against current codebase (commit `2278edb`)

## Scorecard Summary

| Category | Original | Adjusted | Change | Reason |
|----------|----------|----------|--------|--------|
| Security | 7/10 | 7/10 | — | H2 remains high; C5 scope doubled (35 routes) |
| Operations | 6/10 | 7/10 | +1 | H6/H7/H8 resolved; M7/M10 remain |
| Database | 7/10 | 8/10 | +1 | H9 false positive; M4 fixed |
| **Overall** | **7/10** | **7.5/10** | **+0.5** | |

## Validation Results

| ID | Finding | Status | Notes |
|----|---------|--------|-------|
| C1 | Static file serving | ✅ FIXED | |
| C2 | uncaughtException | ✅ FIXED | |
| C3 | Pool drain | ✅ FIXED | |
| C4 | FK constraint | ✅ FIXED | |
| **C5** | **19 routes missing Zod** | **⚠️ CONFIRMED (escalated)** | **Actual count: 35 routes across 18 files** |
| H1 | Message MIME | ✅ FIXED | |
| **H2** | **Backup shell injection** | **⚠️ CONFIRMED** | `exec()` with user-supplied `name` |
| H3 | Register response | ✅ FIXED | |
| H4 | Rate limiting | ✅ FIXED | |
| H5 | Dockerfile node_modules | ✅ FALSE POSITIVE | `npm ci --omit=dev` is correct |
| H6 | Resource limits | ✅ OBSOLETE | All containers have limits |
| H7 | PostgreSQL host binding | ✅ OBSOLETE | Bound to 127.0.0.1 |
| H8 | Backup password | ✅ FALSE POSITIVE | `[Parameter(Mandatory=$true)]` |
| H9 | RLS monitoring/reporting | ✅ FALSE POSITIVE | 60 policies exist in seed/25-*.sql |
| H10 | Indexes | ✅ FIXED | |
| M1 | CORS dev origin | ✅ FIXED | |
| M2 | FRONTEND_URL | ✅ FIXED | |
| M3 | Change-password valid. | ✅ FIXED | |
| M4 | HEALTHCHECK | ✅ OBSOLETE | All containers have health checks |
| M5 | JSON body limit | ✅ FIXED | |
| M6 | question_options JSONB | ✅ FIXED | |
| **M7** | **npm audit in CI** | **⚠️ CONFIRMED** | Trivy scans images only; no early-stage audit |
| **M8** | **Health endpoint format** | **⚠️ CONFIRMED** | 3 different formats across /live, /ready, /health |
| **M9** | **ZodError response** | **⚠️ PARTIALLY** | Returns 400 (not 422), but response shape differs |
| **M10** | **stop-prod.ps1** | **⚠️ CONFIRMED** | File does not exist |

---

## Backlog Items

### PB-001: Add Zod validation to 35 unprotected API routes

| Field | Value |
|-------|-------|
| **Severity** | Critical |
| **Category** | Input Validation / Security |
| **Description** | 35 POST/PUT/PATCH routes across 18 route files accept arbitrary data without Zod schema validation. This bypasses type checking, error normalization, and injection protection. |
| **Affected files** | `auth.routes.ts` (3 routes: refresh, logout, resend-verification), `roles.routes.ts` (1: PUT /:id), `responsibility.routes.ts` (1: POST /user-responsibilities), `applications.routes.ts` (3: withdraw, appeal, renewal), `evidence.routes.ts` (1: POST /), `certificate.routes.ts` (3: reissue, retry, revoke), `meetings.routes.ts` (3: quorum, approve minutes, update meeting), `voting.routes.ts` (1: close session), `reviews.routes.ts` (1: submit review), `committees.routes.ts` (2: add member, update member), `consent.routes.ts` (3: approve version, retire version, update required), `ethics-risk.routes.ts` (1: PUT /:id), `documents.routes.ts` (1: POST /), `risk.routes.ts` (2: update risk, add mitigation), `messages.routes.ts` (1: POST /), `backup.routes.ts` (2: verify, restore), `email-config.routes.ts` (3: create, update, test), `push-config.routes.ts` (2: create, update), `sms-config.routes.ts` (2: create, update), `reference-data.routes.ts` (2: create, update), `system-config.routes.ts` (1: update config) |
| **Root cause** | Routes were added without corresponding Zod schema definitions and `validate()` middleware. |
| **Business impact** | Arbitrary/malformed data can be sent to critical workflows (applications, certificates, backup restore, email config). Could cause data corruption or undefined behavior. |
| **Technical impact** | No type safety, no error normalization, no request body structure guarantees. `any` types used in handlers. |
| **Production impact** | At risk of data corruption, unhandled errors causing 500s, and inconsistent error responses. |
| **Regression risk** | Low — each route change is isolated. Adding a validate middleware that rejects bad input can break existing clients sending malformed data (which should be caught early in pilot). |
| **Dependencies** | Zod schemas need to be defined in `middleware/schemas.ts` or per-module schema files. |
| **Recommended solution** | For each route: (1) define a Zod schema for the request body, (2) add `validate(schema)` middleware call before the handler. For routes with file uploads, validate body after multer parses the multipart. |
| **Implementation order** | 1 |
| **Complexity** | Medium (35 routes, ~20 new schemas) |
| **Estimated time** | 2-3 days |
| **Required tests** | Unit: schema validation tests. Integration: hit each route with valid/invalid payloads. E2E: existing workflow tests should continue passing. |
| **Rollback** | Revert individual route file changes; each route's validate() call is a one-line addition. |
| **Status** | ⏳ Not started |
| **Owner** | TBD |

---

### PB-002: Fix shell injection in backup service

| Field | Value |
|-------|-------|
| **Severity** | High |
| **Category** | Security |
| **Description** | `backup.service.ts` uses `exec()` (shell) for all postgres commands. User-supplied `name` parameter flows into `fp` → shell command via `${fp}` inside double-quoted shell strings. `getPath()` validates `.dump` extension and prevents path traversal, but does not sanitize shell metacharacters (`$()`, backticks, etc.). |
| **Affected files** | `backend/src/services/backup.service.ts` (method `run()` lines 77-94, methods `verify()` line 131, `restore()` line 165/174), `backend/src/services/backup-destination.ts` (method `getPath()` lines 68-74 — path traversal check only, no shell sanitization) |
| **Root cause** | `child_process.exec()` spawns a shell. Any interpolated values with shell metacharacters become code execution. |
| **Business impact** | Attacker with backup API access could execute arbitrary OS commands on the server. The backup/restore endpoints require admin authentication, but a compromised admin account or SSRF could trigger this. |
| **Technical impact** | Remote code execution in the container. Full server compromise. |
| **Production impact** | Critical. Attackers could exfiltrate the database, install malware, pivot to internal network. |
| **Regression risk** | Medium — changing from `exec()` to `execFile()` requires restructuring how arguments are passed. Commands like `pg_dump ... -f "${tmpPath}"` use shell features (quoting, variable expansion); these must be converted to argument arrays. |
| **Dependencies** | None. Isolated to `backup.service.ts`. |
| **Recommended solution** | Replace `promisify(exec)` with `spawn()` from `child_process`. Convert all command strings to argument arrays. For the `run()` method, change signature to accept `(cmd: string, args: string[])` instead of `(cmd: string)`. Validate `name` parameter at the route level (via Zod schema) to allow only `[a-zA-Z0-9_.-]`. |
| **Implementation order** | 3 |
| **Complexity** | Medium (one service file, but careful argument restructuring required) |
| **Estimated time** | 1 day |
| **Required tests** | Unit: `run()` with various argument combinations. Integration: backup create/verify/restore cycle. Security: attempt injection via name parameter. |
| **Rollback** | Revert `backup.service.ts` changes; restore original `run()` method. |
| **Status** | ⏳ Not started |
| **Owner** | TBD |

---

### PB-003: Add `npm audit` to CI pipeline

| Field | Value |
|-------|-------|
| **Severity** | Medium |
| **Category** | CI / Security |
| **Description** | CI pipeline (`.github/workflows/ci.yml`) has no `npm audit` step. Trivy scans Docker images but only on `main`/tag pushes. Dependency vulnerabilities are not caught early on PR branches. |
| **Affected files** | `.github/workflows/ci.yml` |
| **Root cause** | CI was designed with Trivy for container scanning but omitted npm-level audit. |
| **Business impact** | Vulnerable dependencies may be merged undetected. Only caught post-merge during image build. |
| **Technical impact** | Delayed vulnerability detection. |
| **Production impact** | Low (Trivy catches known vulns eventually), but violates shift-left security principle. |
| **Regression risk** | None — adds a new CI step that doesn't affect build output. `npm audit` may fail on existing vulnerabilities; `--audit-level=high` can gate only high/critical. |
| **Dependencies** | None. |
| **Recommended solution** | Add `npm audit --audit-level=high` to both backend and frontend jobs in CI after `npm ci`. Optionally: add `npm audit` as a separate scheduled workflow (weekly). |
| **Implementation order** | 1 (alongside PB-001) |
| **Complexity** | Low |
| **Estimated time** | 1 hour |
| **Required tests** | CI pipeline run after change. No application tests needed. |
| **Rollback** | Revert `.github/workflows/ci.yml` changes. |
| **Status** | ⏳ Not started |
| **Owner** | TBD |

---

### PB-004: Standardize health check endpoint responses

| Field | Value |
|-------|-------|
| **Severity** | Medium |
| **Category** | Operations / Observability |
| **Description** | Three health endpoints return three different response formats: `GET /live` returns `{"status":"alive"}`, `GET /ready` returns `{"status":"healthy","checks":{...}}`, `GET /health` returns `{"service":"...","version":"...","status":"healthy","requestId":"...","uptime":...,"timestamp":"...","checks":{...}}`. Status value strings are inconsistent ("alive" vs "healthy"/"unhealthy" vs "healthy"/"degraded"). |
| **Affected files** | `backend/src/modules/monitoring/index.ts` (lines 12-56) |
| **Root cause** | Endpoints were added incrementally without a shared format contract. |
| **Business impact** | Monitoring tools (Kubernetes probes, Datadog, CloudWatch) may misread endpoint status if format varies. Operators cannot rely on consistent field names. |
| **Technical impact** | `/live` is used as k8s liveness probe (always 200), `/ready` as readiness probe (503 when unhealthy), `/health` for detailed diagnostics. The inconsistency forces monitoring code to handle multiple formats. |
| **Production impact** | Low — all endpoints work. Medium — incident response time increases due to format confusion. |
| **Regression risk** | Low — changes are to response JSON shape only. If any monitoring tool parses specific fields (like `checks`), those must be preserved. |
| **Dependencies** | Docker HEALTHCHECK directives reference the endpoint format in `docker-compose.yml` (line 51) and `backend/Dockerfile` (line 18). These must be updated if endpoint paths change. |
| **Recommended solution** | Standardize on the `/health` format as the canonical response. Make `/live` return `{"status":"healthy","service":"ethics-erm-api"}` (minimal but consistent shape). Make `/ready` return the same shape as `/health`. Unify status values to `"healthy"`/`"degraded"`. |
| **Implementation order** | 4 |
| **Complexity** | Low |
| **Estimated time** | 2-4 hours |
| **Required tests** | Integration: hit all three endpoints, verify response shapes match a shared type. Update Docker health check tests if they parse response body. |
| **Rollback** | Revert `monitoring/index.ts` changes. |
| **Status** | ⏳ Not started |
| **Owner** | TBD |

---

### PB-005: Fix ZodError response format consistency

| Field | Value |
|-------|-------|
| **Severity** | Medium |
| **Category** | API Consistency |
| **Description** | When Zod validation fails in `validate.ts` middleware, response is `errorResponse(messages)` which returns `{success: false, error: "..."}` — missing the `requestId` field that the global `errorHandler` includes. This creates two response shapes for validation errors vs. server errors. |
| **Affected files** | `backend/src/middleware/validate.ts` (line 19), `backend/src/middleware/errorHandler.ts` (lines 16-27) |
| **Root cause** | `validate.ts` was written before the global error handler was standardized. |
| **Business impact** | API consumers must handle two different error response shapes. |
| **Technical impact** | Minor — frontend SDK may not log requestId for validation errors, complicating debugging. |
| **Production impact** | Low. |
| **Regression risk** | Low — HTTP status code doesn't change (remains 400). Response shape gains an additional field (`requestId`), which is backward-compatible (consumers that ignore unknown fields). |
| **Dependencies** | None. |
| **Recommended solution** | In `validate.ts`, pass `requestId` from `(req as any).requestId` into the response: `res.status(400).json({ success: false, error: messages, requestId: (req as any).requestId || '-' })`. |
| **Implementation order** | 4 (alongside PB-004) |
| **Complexity** | Low (one line change) |
| **Estimated time** | 30 minutes |
| **Required tests** | Integration: submit invalid request body, verify response includes `requestId` field. |
| **Rollback** | Revert `validate.ts` change. |
| **Status** | ⏳ Not started |
| **Owner** | TBD |

---

### PB-006: Create production shutdown script

| Field | Value |
|-------|-------|
| **Severity** | Medium |
| **Category** | Operations |
| **Description** | No `stop-prod.ps1` script exists for graceful production shutdown. Operators must manually run `docker compose down` or kill processes, risking data loss or incomplete shutdown. |
| **Affected files** | New file: `scripts/stop-prod.ps1` |
| **Root cause** | Not created during initial operations setup. |
| **Business impact** | Emergency shutdown procedures are not documented or scripted. Increased risk of data loss during unplanned downtime. |
| **Technical impact** | No graceful shutdown sequencing (backup first, then stop backend, then stop DB). |
| **Production impact** | Medium — operator error during emergency shutdown could corrupt database. |
| **Regression risk** | None — new file, no existing code changes. |
| **Dependencies** | None. |
| **Recommended solution** | Create `scripts/stop-prod.ps1` that: (1) creates a pre-shutdown backup via `docker exec`, (2) gracefully stops backend and frontend containers, (3) optionally stops postgres after applications drain. |
| **Implementation order** | 1 (alongside PB-003) |
| **Complexity** | Low |
| **Estimated time** | 1-2 hours |
| **Required tests** | Manual: run in staging, verify containers stop gracefully. |
| **Rollback** | Delete the file. |
| **Status** | ⏳ Not started |
| **Owner** | TBD |

---

## Deprecated Items

The following findings from the original report are **removed** from the active backlog:

| ID | Reason |
|----|--------|
| H5 | ✅ False positive — Dockerfile is correct |
| H6 | ✅ Already fixed — resource limits present |
| H7 | ✅ Already fixed — PostgreSQL bound to 127.0.0.1 |
| H8 | ✅ False positive — password is mandatory parameter |
| H9 | ✅ False positive — RLS exists on all monitoring/reporting tables |
| M4 | ✅ Already fixed — HEALTHCHECK on all containers |
| M6 | ✅ Already fixed — question_options converted to JSONB |
