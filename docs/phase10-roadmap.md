# Phase 10 Implementation Roadmap

> Based on validated backlog from Phase 9.5 Engineering Triage
> Grouped to minimize regression risk: infrastructure-first, then isolated route changes, then middleware, then critical service

---

## Batch Organization

```
Batch 1 ── CI + Scripts
  PB-003 ── npm audit in CI
  PB-006 ── stop-prod.ps1
  (Zero application code changes → lowest risk)

Batch 2 ── Input Validation (35 routes)
  PB-001 ── Add Zod validation to 35 unprotected routes
  (Isolated per-file changes, easily revertible)

Batch 3 ── Response Consistency (middleware)
  PB-005 ── Fix ZodError response shape
  PB-004 ── Standardize health endpoints
  (Middleware changes → verify all response consumers)

Batch 4 ── Security Hardening (single service)
  PB-002 ── Fix shell injection in backup service
  (Highest risk → last, after all other fixes are validated)

Batch 5 ── Maintenance (post-certification findings)
  PB-007 ── Zod validation for saved-search routes
  PB-008 ── Review update schema .default() usage
  (Discovered during PB-001 release certification, outside original scope)
```

---

## Sprint 1 — CI + Foundational Operations

**Duration:** 2 days

**Status:** ✅ COMPLETED

**Completion:** 100% (2/2 issues closed)

**Overall Regression:** PASS

**Release Gate:** PASS

**Objectives:**
- ✅ Establish dependency vulnerability scanning in CI
- ✅ Create production shutdown procedures

**Issues:**
| ID | Title | Effort | Status |
|----|-------|--------|--------|
| PB-003 | Add `npm audit` to CI pipeline | 1h | ✅ Completed (Gate 2 PASS) |
| PB-006 | Create `stop-prod.ps1` | 2h | ✅ Completed (Gate 3 PASS) |

**Files modified/created:**
- ✅ `.github/workflows/ci.yml` — audit steps added to backend and frontend jobs
- ✅ `scripts/stop-prod.ps1` — new file

**Validation:**
- ✅ CI pipeline includes `npm audit` with configurable env vars (`AUDIT_LEVEL`, `AUDIT_PRODUCTION_ONLY`, `AUDIT_ENABLED`)
- ✅ `scripts/stop-prod.ps1` passes syntax validation (14 functions, 6 parameters)

**Regression tests:**
- ✅ CI: backend and frontend jobs verified — build artifacts unchanged
- ✅ Manual: audit JSON reports uploaded as CI artifacts
- ✅ Manual: combined audit summary in GitHub Actions step summary
- ✅ Manual: `stop-prod.ps1` verified for idempotency, error handling, data safety

**Rollback strategy:**
- CI: revert `.github/workflows/ci.yml`
- Script: delete `scripts/stop-prod.ps1`

**Acceptance criteria:**
- [x] CI pipeline includes `npm audit` for both backend and frontend
- [x] `AUDIT_LEVEL` env var controls severity threshold (default: `high`)
- [x] `AUDIT_ENABLED=false` skips audit entirely
- [x] `AUDIT_PRODUCTION_ONLY=true` restricts audit to production dependencies
- [x] `npm audit` failure (high/critical) blocks the build
- [x] JSON audit reports uploaded as CI artifacts for both backend and frontend
- [x] Combined audit summary displayed in GitHub Actions step summary
- [x] `stop-prod.ps1` creates a backup before shutdown
- [x] `stop-prod.ps1` performs graceful docker-compose shutdown
- [x] No application code changed
- [x] Existing jobs (validate, e2e, docker) unaffected
- [x] npm cache remains valid (unchanged setup-node cache config)
- [x] Docker build, push, and Trivy scan steps unchanged
- [x] Release tagging unaffected

---

## Sprint 2 — Input Validation

**Duration:** 3-4 days

**Objectives:**
- Add Zod schema validation to all 35 unprotected POST/PUT/PATCH routes
- Ensure every request body is validated before reaching business logic

**Issues:**
| ID | Title | Effort |
|----|-------|--------|
| PB-001 | Add Zod validation to 35 unprotected API routes | 2-3 days |

**Expected files modified:**
- `backend/src/middleware/schemas.ts` — add ~20 new Zod schemas
- 18 route files (one-line `validate(schema)` addition per route):
  - `security/auth.routes.ts` (3 routes: refresh, logout, resend-verification)
  - `security/roles.routes.ts` (1 route)
  - `security/responsibility.routes.ts` (1 route)
  - `core/applications.routes.ts` (3 routes)
  - `core/evidence.routes.ts` (1 route)
  - `core/certificate.routes.ts` (3 routes)
  - `committee/meetings.routes.ts` (3 routes)
  - `committee/voting.routes.ts` (1 route)
  - `committee/reviews.routes.ts` (1 route)
  - `committee/committees.routes.ts` (2 routes)
  - `committee/consent.routes.ts` (3 routes)
  - `committee/ethics-risk.routes.ts` (1 route)
  - `documents/documents.routes.ts` (1 route)
  - `safety/risk.routes.ts` (2 routes)
  - `communication/messages.routes.ts` (1 route)
  - `admin/backup.routes.ts` (2 routes)
  - `admin/email-config.routes.ts` (3 routes)
  - `admin/push-config.routes.ts` (2 routes)
  - `admin/sms-config.routes.ts` (2 routes)
  - `admin/reference-data.routes.ts` (2 routes)
  - `admin/system-config.routes.ts` (1 route)

**Validation:**
- `npm run lint` (tsc --noEmit) passes
- `npm test` passes
- `npm run build` passes
- For each route: valid request → 2xx, invalid request → 400

**Regression tests:**
- Hit each of the 35 routes with: (a) valid payload → expect 2xx, (b) empty body → expect 400, (c) malformed fields → expect 400
- Run full E2E test suite to verify no workflow broken
- Verify existing validated routes still return 400 on bad input (no regression)

**Rollback strategy:**
- Revert individual route files. Each `validate(schema)` addition is a single line; revert is trivial.
- If a schema is too strict, adjust the schema definition (no rollback needed).

**Acceptance criteria:**
- [ ] All 35 POST/PUT/PATCH routes have `validate(schema)` middleware
- [ ] `npm run lint` passes with zero errors
- [ ] All existing tests continue to pass
- [ ] Invalid payloads return 400 with `{ success: false, error: "..." }`
- [ ] File upload routes (documents, evidence, messages) validate body after multer parses multipart
- [ ] Each schema documents `required` vs `optional` fields

---

## Sprint 3 — API Consistency

**Duration:** 1 day

**Objectives:**
- Standardize health endpoint response formats for monitoring tool interoperability
- Fix ZodError response shape to include `requestId` for debugging

**Issues:**
| ID | Title | Effort |
|----|-------|--------|
| PB-005 | Fix ZodError response format consistency | 30min |
| PB-004 | Standardize health check endpoint responses | 2-4h |
| PB-009 | Fix CI health probe URL alignment | 5min |

**Expected files modified:**
- `backend/src/middleware/validate.ts` — add `requestId` to response
- `backend/src/modules/monitoring/index.ts` — unify /live, /ready, /health formats
- `backend/src/config/swagger.ts` — update OpenAPI spec to match new format
- `backend/src/config/logger.ts` — update health endpoint ignore list
- `backend/openapi/modules/monitoring.yaml` — expand health response schema
- `frontend/src/sdk/core/types.ts` — expand `HealthStatus` interface
- `.github/workflows/ci.yml` — fix health probe URL (PB-009)

**Validation:**
- `GET /live` returns `{"status":"alive","service":"ethics-erm-api"}`
- `GET /ready` returns same shape as `/health` with `status` and `checks`
- `GET /health` returns full diagnostic shape (unchanged)
- `/live` uses `"alive"`; `/ready` and `/health` use `"healthy"`/`"degraded"`
- Validation error response includes `requestId` field
- CI "Wait for server" step succeeds using correct URL (PB-009)

**Regression tests:**
- Verify `docker-compose` health checks still pass (they use `wget --spider`, status code only)
- Verify frontend error handling accepts new field (backward-compatible)
- Verify monitoring dashboards that parse health responses
- Verify CI pipeline E2E job health check succeeds after URL fix (PB-009)

**Rollback strategy:**
- Revert `validate.ts` and `monitoring/index.ts` changes
- If Docker health checks break, revert endpoint changes and use query parameter for format selection instead
- For PB-009: revert the single line in `.github/workflows/ci.yml`

**Acceptance criteria:**
- [x] `/live` returns consistent JSON shape
- [x] `/ready` and `/health` share the same response type
- [x] `/live` uses `"alive"`; `/ready` and `/health` use `"healthy"`/`"degraded"`
- [x] Docker HEALTHCHECK directives continue to pass
- [x] Validation error responses include `requestId`
- [x] Swagger spec updated to match new formats
- [x] CI health probe URL uses `/api/v1/monitoring/health` (PB-009)

---

## Sprint 3 — API Consistency

**Duration:** 1 day

**Status:** ✅ COMPLETED

**Completion:** 100% (3/3 issues closed)

**Overall Regression:** PASS

**Release Gate:** PASS

**Objectives:**
- ✅ Standardize health endpoint response formats for monitoring tool interoperability
- ✅ Fix ZodError response shape to include `requestId` for debugging
- ✅ Fix CI health probe URL alignment

**Issues:**
| ID | Title | Effort | Status |
|----|-------|--------|--------|
| PB-005 | Fix ZodError response format consistency | 30min | ✅ Completed (Gate 4 PASS) |
| PB-004 | Standardize health check endpoint responses | 2-4h | ✅ Completed (Gate 5 PASS) |
| PB-009 | Fix CI health probe URL alignment | 5min | ✅ Completed (Gate 6 PASS) |

**Files modified:**
- ✅ `backend/src/middleware/validate.ts` — `requestId` added to ZodError 400 response
- ✅ `backend/src/modules/monitoring/index.ts` — `/live` → `{ status: 'alive', service }`, `/ready` → `{ status, service, checks }` (unhealthy→degraded)
- ✅ `backend/src/config/swagger.ts` — stale `/health` path removed, `/monitoring/health` response doc expanded
- ✅ `backend/src/config/logger.ts` — `/api/v1/health` removed from ignore list
- ✅ `backend/openapi/modules/monitoring.yaml` — health response schema expanded to 7 fields
- ✅ `frontend/src/sdk/core/types.ts` — `HealthStatus` interface expanded
- ✅ `.github/workflows/ci.yml` — CI health probe URL fixed (PB-009)

**Validation:**
- ✅ `GET /live` returns `{"status":"alive","service":"ethics-erm-api"}`
- ✅ `GET /ready` returns same shape as `/health` with `status` and `checks`
- ✅ `GET /health` returns full diagnostic shape (unchanged)
- ✅ `/live` uses `"alive"`; `/ready` and `/health` use `"healthy"`/`"degraded"`
- ✅ Validation error response includes `requestId` field
- ✅ CI "Wait for server" step succeeds using correct URL (PB-009)

**Regression tests:**
- ✅ `npm run lint` passes (backend = tsc --noEmit)
- ✅ `npm test` passes (366/366 unit tests, 4 integration skip — pre-existing)
- ✅ `cd frontend && npm run build` passes
- ✅ Docker HEALTHCHECK uses `wget --spider` (status-code-only check, unaffected by response body changes)
- ✅ Frontend error handling accepts new `requestId` field (backward-compatible addition)
- ✅ CI E2E health check uses correct `/api/v1/monitoring/health` URL (PB-009)

**Rollback strategy:**
- Revert `validate.ts` and `monitoring/index.ts` changes
- Revert `.github/workflows/ci.yml` for PB-009

**Acceptance criteria:**
- [x] `/live` returns consistent JSON shape
- [x] `/ready` and `/health` share the same response type
- [x] `/live` uses `"alive"`; `/ready` and `/health` use `"healthy"`/`"degraded"`
- [x] Docker HEALTHCHECK directives continue to pass
- [x] Validation error responses include `requestId`
- [x] Swagger spec updated to match new formats
- [x] CI health probe URL uses `/api/v1/monitoring/health` (PB-009)

---

## Sprint 4 — Security Hardening

**Duration:** 1-2 days

**Objectives:**
- Eliminate shell injection vector in backup service
- Replace `exec()` with `execFile()` for all database command execution

**Issues:**
| ID | Title | Effort |
|----|-------|--------|
| PB-002 | Fix shell injection in backup service | 1 day |

**Expected files modified:**
- `backend/src/services/backup.service.ts` — refactor `run()` method, `verify()`, `restore()`, `create()`, `dropDatabase()`, `terminateConnections()`
- `backend/src/services/backup-destination.ts` — optional: add shell metacharacter check in `getPath()`
- `backend/src/middleware/schemas.ts` — add Zod schema for backup name parameter (already done in Sprint 2 if PB-001 is completed first)

**Validation:**
- `npm run lint` passes
- `npm test` passes with updated backup tests
- Backup create → verify → restore cycle works in staging
- Shell injection attempt via name parameter is rejected (400) or safely handled

**Regression tests:**
- Full backup cycle: create, list, verify, delete
- Restore: verify pre-backup creation, DB rename, data integrity
- Edge cases: backup name with spaces, special chars, unicode
- E2E tests that depend on backup functionality

**Rollback strategy:**
- Full revert of `backup.service.ts` to restore original `run()` method
- Alternative: keep both `exec()` and `execFile()` paths behind a feature flag

**Acceptance criteria:**
- [ ] `run()` method uses `spawn()` or `execFile()` with argument arrays
- [ ] No shell metacharacters are accepted in backup name (validated at route level via Zod)
- [ ] Backup create/verify/restore works end-to-end
- [ ] Pre-restore backup is created successfully
- [ ] Rollback on restore failure works correctly
- [ ] All existing tests pass
- [ ] Security test: `name = "test.dump$(calc.exe)"` returns 400 or safely handled

---

## Sprint 5 — Maintenance (Post-Certification Findings)

**Duration:** 1 day

**Objectives:**
- Add Zod validation to saved-search routes discovered during PB-001 release certification
- Review and fix update schemas where `.default()` causes unintended overwrite of existing values
- These items were identified during PB-001 release certification but outside the original implementation scope

**Issues:**
| ID | Title | Effort |
|----|-------|--------|
| PB-007 | Add Zod validation to saved-search routes in system/index.ts | 1h |
| PB-008 | Review update schemas using .default() to prevent unintended overwrite | 2-4h |

**Expected files modified:**
- `backend/src/middleware/schemas.ts` — add `createSavedSearchSchema`, `updateSavedSearchSchema`; review `updateEmailConfigSchema`, `updateSmsConfigSchema`, `updatePushConfigSchema` for `.default()` vs `.optional()`
- `backend/src/modules/system/index.ts` — add `validate()` middleware to POST and PUT saved-search routes

**Validation:**
- `npm run lint` passes
- `npm test` passes
- Saved-search POST/PUT with valid payload → 2xx, invalid → 400
- Email/SMS/Push config PUT with partial body preserves unprovided fields

**Regression tests:**
- Create Email/SMS/Push config with omitted optional fields → defaults applied correctly
- Update Email/SMS/Push config with single field → only that field changes
- Verify existing E2E tests for config management still pass

**Rollback strategy:**
- Revert `system/index.ts` changes
- Revert schema changes in `schemas.ts`

**Acceptance criteria:**
- [ ] `POST /saved-searches` has `validate(createSavedSearchSchema)`
- [ ] `PUT /saved-searches/:id` has `validate(updateSavedSearchSchema)`
- [ ] Update schemas for email/sms/push config use `.optional()` instead of `.default()` where appropriate
- [ ] PUT with partial body does not overwrite omitted fields with defaults
- [ ] All existing tests pass

---

## Dependency Map

```
PB-003 (npm audit)     ← no deps
PB-006 (stop-prod.ps1) ← no deps
PB-001 (Zod routes)    ← no deps (schemas are self-contained)
PB-005 (ZodError fmt)  ← no deps
PB-004 (health format) ← no deps (update Dockerfile/compose if needed)
PB-009 (CI health URL)  ← PB-004 (verify correct endpoint after format change)
PB-002 (shell inject)  ← PB-001 (Zod schema for backup name prevents injection at route level)
PB-007 (saved-searches) ← no deps
PB-008 (update defaults) ← PB-001 (schemas were introduced there)
```

## Risk Heatmap

| Batch | Risk | Reason |
|-------|------|--------|
| Batch 1 | 🟢 Low | No application code changes |
| Batch 2 | 🟡 Medium | 35 small changes, each isolated; schema strictness may break existing clients |
| Batch 3 | 🟢 Low | Response format changes are backward-compatible (adding fields, not removing) |
| Batch 4 | 🟡 Medium | Core infrastructure service; backup/restore must work correctly |
| Batch 5 | 🟢 Low | Small isolated changes; no new functionality |
