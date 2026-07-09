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
```

---

## Sprint 1 — CI + Foundational Operations

**Duration:** 2 days

**Objectives:**
- Establish dependency vulnerability scanning in CI
- Create production shutdown procedures

**Issues:**
| ID | Title | Effort |
|----|-------|--------|
| PB-003 | Add `npm audit` to CI pipeline | 1h |
| PB-006 | Create `stop-prod.ps1` | 2h |

**Expected files modified/created:**
- `.github/workflows/ci.yml` — add `npm audit --audit-level=high` to backend and frontend jobs
- `scripts/stop-prod.ps1` — new file

**Validation:**
- CI pipeline passes with `npm audit` step (may need `--audit-level=high` to pass with existing vulns)
- `scripts/stop-prod.ps1` runs without error in staging

**Regression tests:**
- CI: run `backend` and `frontend` jobs, verify build artifacts unchanged
- Manual: verify `npm audit` output in CI logs

**Rollback strategy:**
- CI: revert `.github/workflows/ci.yml`
- Script: delete `scripts/stop-prod.ps1`

**Acceptance criteria:**
- [ ] CI pipeline includes `npm audit` for both backend and frontend
- [ ] `npm audit` failure (high/critical) blocks the build
- [ ] `stop-prod.ps1` creates a backup before shutdown
- [ ] `stop-prod.ps1` performs graceful docker-compose shutdown
- [ ] No application code changed

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

**Expected files modified:**
- `backend/src/middleware/validate.ts` — add `requestId` to response
- `backend/src/modules/monitoring/index.ts` — unify /live, /ready, /health formats
- `backend/src/config/swagger.ts` — update OpenAPI spec to match new format
- `backend/Dockerfile` — update HEALTHCHECK if endpoint shape changes
- `docker-compose.yml` — update HEALTHCHECK if endpoint shape changes

**Validation:**
- `GET /live` returns `{"status":"healthy","service":"ethics-erm-api"}`
- `GET /ready` returns same shape as `/health` with `status` and `checks`
- `GET /health` returns full diagnostic shape (unchanged)
- All three use consistent status values (`"healthy"`/`"degraded"`)
- Validation error response includes `requestId` field

**Regression tests:**
- Verify `docker-compose` health checks still pass (they use `wget --spider`, status code only)
- Verify frontend error handling accepts new field (backward-compatible)
- Verify monitoring dashboards that parse health responses

**Rollback strategy:**
- Revert `validate.ts` and `monitoring/index.ts` changes
- If Docker health checks break, revert endpoint changes and use query parameter for format selection instead

**Acceptance criteria:**
- [ ] `/live` returns consistent JSON shape
- [ ] `/ready` and `/health` share the same response type
- [ ] All health endpoints use `"healthy"`/`"degraded"` (not `"alive"`, `"unhealthy"`)
- [ ] Docker HEALTHCHECK directives continue to pass
- [ ] Validation error responses include `requestId`
- [ ] Swagger spec updated to match new formats

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

## Dependency Map

```
PB-003 (npm audit)     ← no deps
PB-006 (stop-prod.ps1) ← no deps
PB-001 (Zod routes)    ← no deps (schemas are self-contained)
PB-005 (ZodError fmt)  ← no deps
PB-004 (health format) ← no deps (update Dockerfile/compose if needed)
PB-002 (shell inject)  ← PB-001 (Zod schema for backup name prevents injection at route level)
```

## Risk Heatmap

| Batch | Risk | Reason |
|-------|------|--------|
| Batch 1 | 🟢 Low | No application code changes |
| Batch 2 | 🟡 Medium | 35 small changes, each isolated; schema strictness may break existing clients |
| Batch 3 | 🟢 Low | Response format changes are backward-compatible (adding fields, not removing) |
| Batch 4 | 🟡 Medium | Core infrastructure service; backup/restore must work correctly |
