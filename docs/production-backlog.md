# Production Backlog — RC1

> Generated: 2026-07-09
> Phase 9.5 Engineering Triage — validated against current codebase (commit `2278edb`)

## Scorecard Summary

| Category | Original | Adjusted | Change | Reason |
|----------|----------|----------|--------|--------|
| Security | 7/10 | 7/10 | — | H2 remains high; C5 scope doubled (35 routes) |
| Operations | 6/10 | 8/10 | +2 | H6/H7/H8 resolved; M7 (npm audit) fixed; M10 (stop-prod.ps1) fixed |
| Database | 7/10 | 8/10 | +1 | H9 false positive; M4 fixed |
| **Overall** | **7/10** | **7.5/10** | **+0.5** | M7 (npm audit) fixed, M10 (stop-prod.ps1) fixed |

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
| **M7** | **npm audit in CI** | **✅ FIXED** | PB-003 implemented and certified (Gate 2 PASS) |
| **M8** | **Health endpoint format** | **⚠️ CONFIRMED** | 3 different formats across /live, /ready, /health |
| **M9** | **ZodError response** | **⚠️ PARTIALLY** | Returns 400 (not 422), but response shape differs |
| **M10** | **stop-prod.ps1** | **✅ FIXED** | PB-006 implemented and certified (Gate 3 PASS) |

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
| **Status** | ✅ PASS — Accepted |
| **Owner** | TBD |

> **Completion note:** Completed under original implementation scope. Additional findings PB-007 and PB-008 were identified during release certification and tracked separately.

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
| **Category** | Operations |
| **Description** | No `npm audit` step exists in CI pipeline. Dependency vulnerabilities are only detected post-merge by Trivy scanning Docker images (image-level), which is too late for pre-merge prevention. |
| **Affected files** | `.github/workflows/ci.yml` |
| **Root cause** | CI was set up with `npm install`/`npm ci` only; dependency auditing was not configured. |
| **Business impact** | Vulnerable dependencies can be merged into main without warning. Vulnerabilities are only caught at image-scan time. |
| **Technical impact** | CI lacks a gate for dependency vulnerabilities. |
| **Production impact** | Medium — vulnerable packages could reach production if Trivy misses them (e.g., runtime-only vulnerabilities not in final image). |
| **Regression risk** | Low — `npm audit` runs in a separate step. No existing behavior changes. |
| **Dependencies** | None. |
| **Recommended solution** | Add `npm audit --audit-level=high` to both backend and frontend CI jobs after `npm ci`. Include `--production` flag to focus on runtime dependencies. |
| **Implementation order** | 1 (alongside PB-006) |
| **Complexity** | Low |
| **Estimated time** | 1 hour |
| **Required tests** | CI: run `backend` and `frontend` jobs, verify audit output. |
| **Rollback** | Revert `.github/workflows/ci.yml` |
| **Status** | ✅ Accepted — Completed — Closed (Gate 2 PASS) |
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
| **Status** | ✅ Accepted — Completed — Closed |
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
| **Status** | ✅ Accepted — Completed — Closed |
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
| **Status** | ✅ Accepted — Completed — Closed (Gate 3 PASS) |
| **Owner** | TBD |

---

### PB-009: Fix CI health probe URL alignment

| Field | Value |
|-------|-------|
| **Severity** | High |
| **Category** | CI/DevOps |
| **Description** | The CI pipeline at `.github/workflows/ci.yml` line 231 uses `curl -sf http://localhost:8080/api/v1/health` to wait for the server to start. The actual health endpoint is at `/api/v1/monitoring/health`. The wrong URL returns 404, causing `curl -sf` to always fail. The wait loop exhausts its 30 retries × 2s = 60s and errors out with "Server failed to start". Discovered during PB-004 triage. |
| **Affected files** | `.github/workflows/ci.yml` (line 231) |
| **Root cause** | Health endpoint URL was never updated after refactoring monitoring routes to the `/api/v1/monitoring/` prefix. The logger ignore list already contains `/api/v1/health`, suggesting someone suppressed the 404 noise instead of fixing the URL. |
| **Business impact** | High — CI E2E tests cannot run because the server readiness check always fails. Every CI run fails at "Wait for server", blocking all E2E validation. |
| **Technical impact** | CI E2E job is broken. The wait loop is effectively a 60-second sleep followed by unconditional failure; the server may be healthy but CI never knows. |
| **Production impact** | None (CI-only, not production) |
| **Regression risk** | 🟢 Low — single URL change in CI pipeline YAML |
| **Dependencies** | PB-004 (PB-009 discovered during PB-004 triage; verify correct URL after PB-004 endpoint changes) |
| **Recommended solution** | Change URL from `/api/v1/health` to `/api/v1/monitoring/health` in `.github/workflows/ci.yml` line 231. |
| **Implementation order** | 4 (same batch as Sprint 3 — CI fix alongside health endpoint changes) |
| **Complexity** | Low (one URL segment change) |
| **Estimated time** | 5 minutes |
| **Required tests** | CI pipeline run (manual trigger after merge) — verify E2E job health check succeeds |
| **Rollback** | Revert the URL change in `.github/workflows/ci.yml` |
| **Status** | ✅ Accepted — Completed — Closed |
| **Owner** | TBD |

---

### PB-007: Add Zod validation to saved-search routes in system/index.ts

| Field | Value |
|-------|-------|
| **Severity** | Medium |
| **Category** | Validation |
| **Description** | `system/index.ts` has two routes (`POST /saved-searches` and `PUT /saved-searches/:id`) that accept request body data without Zod schema validation. Discovered during PB-001 release certification — outside the original PB-001 implementation scope. |
| **Affected files** | `backend/src/modules/system/index.ts` (lines 19, 27) |
| **Root cause** | Routes were never included in the initial PB-001 audit due to being in an `index.ts` aggregator rather than a `.routes.ts` file. |
| **Business impact** | Low — saved searches are per-user and non-critical. Malformed data could cause client-side errors. |
| **Technical impact** | No type safety, no error normalization for these two endpoints. |
| **Production impact** | Low — data is user-owned and isolated. |
| **Regression risk** | Low — adding validation may reject previously-accepted malformed data from the frontend. |
| **Dependencies** | None. |
| **Recommended solution** | Define a createSavedSearchSchema and updateSavedSearchSchema in `middleware/schemas.ts`, add `validate()` middleware to both routes. |
| **Implementation order** | 5 |
| **Complexity** | Low |
| **Estimated time** | 1 hour |
| **Required tests** | Unit: schema validation. Integration: POST/PUT with valid/invalid payloads. |
| **Rollback** | Revert route changes in `system/index.ts`. |
| **Status** | ⏳ Not started |
| **Owner** | TBD |

---

### PB-008: Review update schemas using .default() to prevent unintended overwrite

| Field | Value |
|-------|-------|
| **Severity** | Medium |
| **Category** | Validation / Data Integrity |
| **Description** | Several update schemas use `.partial(createSchema)` where the base create schema uses `.default()`. When `.partial()` is applied, the `.default()` values still fire for unprovided fields, causing PUT handlers to send default values to the repository. This overwrites existing database values with empty defaults during partial updates. Affects `updateEmailConfigSchema`, `updateSmsConfigSchema`, `updatePushConfigSchema`, and any similar update schemas. Discovered during PB-001 release certification. |
| **Affected files** | `backend/src/middleware/schemas.ts` — `updateEmailConfigSchema`, `updateSmsConfigSchema`, `updatePushConfigSchema` (line 453, 476, 465) |
| **Root cause** | The pattern `updateXSchema = createXSchema.partial()` carries `.default()` values from the create schema into the update schema. Zod applies defaults before the route handler reads `req.body`. |
| **Business impact** | Medium — updating one field on an email/SMS/push config could silently reset other fields to their default values (empty strings, `true`, etc.). |
| **Technical impact** | PUT semantics drift from PATCH semantics. Update is no longer partial — it replaces unprovided fields with defaults. |
| **Production impact** | Low unless operators rely on partial update behavior for config management. |
| **Regression risk** | Medium — changing defaults to `.optional()` would reject previously-accepted empty values in create scenarios. Must verify create routes still accept omitted optional fields. |
| **Dependencies** | PB-001 (these schemas were introduced there). |
| **Recommended solution** | Review each update schema and replace `.default()` with `.optional()` where the update should preserve existing values. Keep `.default()` only in create schemas. The review should determine where `.optional()` is more appropriate than `.default()`. |
| **Implementation order** | 5 |
| **Complexity** | Low (per-schema review, one-line changes) |
| **Estimated time** | 2-4 hours (including testing) |
| **Required tests** | Create: verify omitted optional fields get default values. Update: verify omitted fields are not sent to DB (preserving existing values). |
| **Rollback** | Revert schema changes in `schemas.ts`. |
| **Status** | ⏳ Not started |
| **Owner** | TBD |

---

### PB-010: Automate SDK generation from OpenAPI

| Field | Value |
|-------|-------|
| **Severity** | Low |
| **Category** | Developer Experience |
| **Description** | The frontend SDK at `frontend/src/sdk/` is manually maintained. Despite `orval` being installed as a backend devDependency (`^8.16.0`), there is no configuration file, no npm codegen script, and no CI codegen step. Every API contract change requires manual synchronization between the OpenAPI spec and the SDK, creating maintenance burden and risk of contract drift. Automate SDK generation from the canonical OpenAPI spec at `backend/openapi/openapi.yaml`. |
| **Affected files** | `frontend/orval.config.ts` (new), `frontend/src/sdk/` (generated), `backend/package.json` (move orval to workspace root or frontend) |
| **Root cause** | SDK was written by hand during initial development without a code generation pipeline. |
| **Business impact** | Low — existing SDK works correctly but requires manual updates when API contracts change. No production impact. |
| **Technical impact** | Manual SDK syncing is error-prone and slows down development. Each API contract change requires manual edits to 2-3 SDK files and type definitions. |
| **Production impact** | None |
| **Regression risk** | 🟡 Medium — generated SDK may differ from hand-written patterns, requiring frontend import changes |
| **Dependencies** | None (post-RC work) |
| **Recommended solution** | Configure orval with `orval.config.ts`, generate via `npm run generate` in frontend, use mutator to inject existing Axios client. See `docs/sdk-automation-plan.md` for full migration strategy. |
| **Implementation order** | 6 (post-RC) |
| **Complexity** | Medium |
| **Estimated time** | 1-2 days |
| **Required tests** | Verify all generated SDK methods match existing API behavior. Regression: full frontend build + existing SDK consumer tests. |
| **Rollback** | Delete generated files, restore SDK to pre-generation state via git |
| **Status** | ⏳ Deferred — Post Release Candidate |
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
