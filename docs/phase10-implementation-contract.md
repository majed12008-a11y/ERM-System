# Phase 10 Implementation Contract

> Governing document for every backlog item implementation.
> Each item defines exact scope, acceptance criteria, and rollback plan.

---

## PB-001: Add Zod validation to 35 unprotected API routes

### Purpose
Eliminate arbitrary data injection into 35 POST/PUT/PATCH routes that currently accept unvalidated request bodies. Every route must validate its input against a Zod schema before reaching business logic.

### Scope
- 35 routes across 21 route files
- ~20 new Zod schemas in `middleware/schemas.ts`
- One-line `validate(schema)` addition per route handler

### Files expected to change

| File | Routes | Change |
|------|--------|--------|
| `backend/src/middleware/schemas.ts` | — | Add ~20 new Zod schemas |
| `backend/src/modules/security/auth.routes.ts` | POST /refresh, POST /logout, POST /resend-verification | Add `validate()` to 3 routes |
| `backend/src/modules/security/roles.routes.ts` | PUT /:id | Add `validate()` |
| `backend/src/modules/security/responsibility.routes.ts` | POST /user-responsibilities | Add `validate()` |
| `backend/src/modules/core/applications.routes.ts` | POST /:id/withdraw, POST /:id/appeal, POST /:id/renewal | Add `validate()` to 3 routes |
| `backend/src/modules/core/evidence.routes.ts` | POST / | Add `validate()` after multer |
| `backend/src/modules/core/certificate.routes.ts` | POST /:id/reissue, POST /:id/retry, POST /:id/revoke | Add `validate()` to 3 routes |
| `backend/src/modules/committee/meetings.routes.ts` | POST /:id/quorum, PATCH /:id/minutes/:mid/approve, POST /:id | Add `validate()` to 3 routes |
| `backend/src/modules/committee/voting.routes.ts` | POST /sessions/:id/close | Add `validate()` |
| `backend/src/modules/committee/reviews.routes.ts` | POST /:assignmentId/submit | Add `validate()` |
| `backend/src/modules/committee/committees.routes.ts` | POST /:id/members, PUT /:id/members/:memberId | Add `validate()` to 2 routes |
| `backend/src/modules/committee/consent.routes.ts` | POST /versions/:id/approve, POST /versions/:id/retire, PUT /application-consents/:id/required | Add `validate()` to 3 routes |
| `backend/src/modules/committee/ethics-risk.routes.ts` | PUT /:id | Add `validate()` |
| `backend/src/modules/documents/documents.routes.ts` | POST / | Add `validate()` after multer |
| `backend/src/modules/safety/risk.routes.ts` | PUT /risk-register/:id, POST /risk-register/:id/mitigations | Add `validate()` to 2 routes |
| `backend/src/modules/communication/messages.routes.ts` | POST /messages | Add `validate()` after multer |
| `backend/src/modules/admin/backup.routes.ts` | POST /:name/verify, POST /:name/restore | Add `validate()` to 2 routes |
| `backend/src/modules/admin/email-config.routes.ts` | POST /, PUT /:id, POST /test | Add `validate()` to 3 routes |
| `backend/src/modules/admin/push-config.routes.ts` | POST /, PUT /:id | Add `validate()` to 2 routes |
| `backend/src/modules/admin/sms-config.routes.ts` | POST /, PUT /:id | Add `validate()` to 2 routes |
| `backend/src/modules/admin/reference-data.routes.ts` | POST /:entity, PUT /:entity/:id | Add `validate()` to 2 routes |
| `backend/src/modules/admin/system-config.routes.ts` | PUT /:group/:key | Add `validate()` |

### Files that MUST NOT change
- Any service file
- Any repository file
- Any database migration or seed file
- Any frontend file
- Any OpenAPI/Swagger spec (additive only if new schemas are exposed)
- Any workflow state machine

### Acceptance criteria
1. All 35 routes have `validate(schema)` middleware registered
2. `npm run lint` passes with zero errors
3. `npm test` passes (backend)
4. `npm run build` passes (frontend + backend)
5. For each of the 35 routes:
   - Valid payload → 2xx response
   - Empty body → 400 response
   - Malformed fields → 400 response
6. File upload routes (documents, evidence, messages) validate body after multer processes the multipart
7. Existing validated routes remain unaffected

### Regression tests
- **Suite R1** (Input Validation): Hit each of 35 routes with valid/invalid/empty payloads
- Full E2E test suite to verify workflow continuity
- Verify each existing validated route still returns 400 on bad input

### Rollback plan
- Each route change is a single line addition. Revert individual route files.
- If a schema is too strict, adjust the schema definition (no full rollback needed).
- Full rollback: `git revert <commit-hash>` for the PB-001 commit.

### Expected production impact
- **Positive**: Malformed requests are rejected immediately with 400 instead of propagating to business logic
- **Risk**: Clients sending implicit/undefined field values may break if their payloads were technically valid but ambiguous

---

## PB-002: Fix shell injection in backup service

### Purpose
Eliminate remote code execution vector via user-supplied backup name flowing into shell `exec()` calls.

### Scope
- `backup.service.ts`: refactor `run()` method signature and all callers
- `backup-destination.ts`: optional shell metacharacter check

### Files expected to change
- `backend/src/services/backup.service.ts` — replace `exec()` with `spawn()`, restructure argument passing
- `backend/src/services/backup-destination.ts` — optional: add shell metacharacter validation

### Files that MUST NOT change
- Backup route handler signatures (URLs remain unchanged)
- Backup API response format
- Any database schema
- Any frontend code
- Any other service or repository

### Acceptance criteria
1. `run()` method uses `spawn()` or `execFile()` with argument arrays — no shell invocation
2. No shell metacharacters accepted in backup name (validated at route level via Zod)
3. Backup create → verify → restore cycle works end-to-end
4. Pre-restore backup is created successfully before restore
5. Rollback on restore failure works correctly
6. `npm run lint` + `npm test` + `npm run build` pass
7. Security test: `name = "test.dump$(calc.exe)"` returns 400 or is safely handled

### Regression tests
- **Suite R2** (Backup Integrity): Full backup create/list/verify/restore cycle
- Edge cases: backup name with spaces, special chars, unicode
- E2E tests that depend on backup functionality

### Rollback plan
- Full revert of `backup.service.ts` to restore original `run()` method
- Alternative: keep both `exec()` and `execFile()` paths behind a runtime flag

### Expected production impact
- **Positive**: Critical security vulnerability eliminated
- **Risk**: Backup/restore operations may fail if argument restructuring introduces regressions in shell quoting behavior

---

## PB-003: Add `npm audit` to CI pipeline

### Purpose
Add early-stage dependency vulnerability detection to CI, before Docker image build.

### Scope
- `.github/workflows/ci.yml`: add `npm audit` step to backend and frontend jobs

### Files expected to change
- `.github/workflows/ci.yml`

### Files that MUST NOT change
- Any application code
- Any Dockerfile
- Any configuration files

### Implementation details

#### Environment variables (workflow-level)

| Variable | Default | Description |
|----------|---------|-------------|
| `AUDIT_LEVEL` | `high` | Severity threshold per `npm audit --audit-level`. Supports `low`, `moderate`, `high`, `critical`. |
| `AUDIT_PRODUCTION_ONLY` | `false` | When `true`, adds `--production` flag to audit only production dependencies. |
| `AUDIT_ENABLED` | `true` | When `false`, skips the audit step entirely. |

#### Changes to backend job

1. New step **Audit dependencies** inserted after `npm ci`, before type check:
   - Reads `AUDIT_ENABLED` — skips if `false`
   - Reads `AUDIT_PRODUCTION_ONLY` — adds `--production` flag if `true`
   - Generates JSON report: `npm audit --json > audit-backend-report.json` (never fails — `|| true`)
   - Enforces threshold: `npm audit --audit-level=$AUDIT_LEVEL` (fails the step if vulnerabilities at threshold)
2. New step **Upload audit report** after audit, using `actions/upload-artifact@v4`:
   - Artifact name: `audit-backend-report`
   - Path: `audit-backend-report.json`
   - Retention: 30 days
   - Runs `if: always()` to capture report even on audit failure

#### Changes to frontend job

Same structure as backend:
1. **Audit dependencies** step after `npm ci`, before type check
   - Output: `audit-frontend-report.json`
2. **Upload audit report** step
   - Artifact name: `audit-frontend-report`

#### Changes to docker job

1. New step **Download audit reports** after Trivy scans, using `actions/download-artifact@v4` with `pattern: audit-*-report` to pull both backend and frontend reports.
2. New step **Generate audit summary** that writes a markdown table to `$GITHUB_STEP_SUMMARY`:
   - If backend report exists: outputs vulnerability counts by severity
   - If frontend report exists: outputs vulnerability counts by severity
   - Uses `node -e` to parse JSON and format the table

### Acceptance criteria
1. CI pipeline includes `npm audit` for both backend and frontend
2. `AUDIT_LEVEL` env var controls severity threshold (default: `high`)
3. `AUDIT_ENABLED=false` skips audit entirely
4. `AUDIT_PRODUCTION_ONLY=true` restricts audit to production dependencies
5. `npm audit` failure at threshold blocks the build
6. JSON audit reports uploaded as CI artifacts for both backend and frontend
7. Combined audit summary displayed in GitHub Actions step summary
8. Build artifacts unchanged from previous CI runs
9. Existing jobs (validate, e2e, docker) unaffected
10. npm cache remains valid (no changes to setup-node cache config)

### Regression tests
- Run CI pipeline; verify backend and frontend jobs succeed
- Verify `npm audit` output appears in CI logs
- Verify audit reports are downloadable from CI run artifacts
- Verify existing type-check, build, test, lint steps still execute
- Verify Docker build, push, and Trivy scan steps unchanged
- Verify release tagging unaffected

### Rollback plan
- Revert `.github/workflows/ci.yml` using `git revert <commit-hash>`

### Expected production impact
- **Positive**: Dependency vulnerabilities caught pre-merge at PR time instead of post-merge during Docker scan
- **Risk**: `npm audit` may fail on existing vulnerabilities; `--audit-level=high` gates only high/critical as configured

---

## PB-004: Standardize health check endpoint responses

### Purpose
Unify response format across `/live`, `/ready`, and `/health` endpoints for monitoring tool interoperability.

### Scope
- `monitoring/index.ts`: refactor 3 endpoint response formats to a shared shape
- `swagger.ts`: update OpenAPI spec
- `Dockerfile`/`docker-compose.yml`: verify HEALTHCHECK directives still work (status code only)

### Files expected to change
- `backend/src/modules/monitoring/index.ts`
- `backend/src/config/swagger.ts` (if response schema updates needed)

### Files that MUST NOT change
- Any Docker HEALTHCHECK directive if using status-code-only probing (no response body parsing)
- Any business logic
- Any frontend code
- Any route handler outside monitoring

### Acceptance criteria
1. `GET /live` returns `{"status":"alive","service":"ethics-erm-api"}`
2. `GET /ready` returns same shape as `/health` with `status` and `checks`
3. `GET /health` returns full diagnostic shape (unchanged) plus `service`
4. `/live` uses `"alive"`; `/ready` and `/health` use `"healthy"`/`"degraded"`
5. Docker HEALTHCHECK directives pass (they use `wget --spider`, status code only)

### Regression tests
- **Suite R3** (Health Endpoints): Hit all 3 endpoints, verify JSON shapes
- `docker-compose ps` shows all containers healthy

### Rollback plan
- Revert `monitoring/index.ts` changes
- If Docker health checks break, revert and use query parameter for format selection

### Expected production impact
- **Positive**: Consistent format simplifies monitoring setup
- **Risk**: Monitoring tools parsing `/live` or `/ready` response body may need configuration update

---

## PB-005: Fix ZodError response format consistency

### Purpose
Add `requestId` field to Zod validation error responses so all error responses from the API share the same shape.

### Scope
- `validate.ts`: one-line addition to include `requestId` in error response

### Files expected to change
- `backend/src/middleware/validate.ts`

### Files that MUST NOT change
- Any route handler
- Any service
- Any frontend code
- Error handler middleware

### Acceptance criteria
1. Invalid request body → 400 response with `{ success, error, requestId }` format
2. Server error → 500 response with `{ success, error, requestId }` format
3. Both response shapes are identical in structure

### Regression tests
- **Suite R4** (Error Response Shape): Send invalid body, verify `requestId` in response

### Rollback plan
- Revert the single line change in `validate.ts`

### Expected production impact
- **Positive**: Consistent error format simplifies frontend error handling
- **Risk**: None — adding a field is backward-compatible

---

## PB-006: Create production shutdown script

### Purpose
Provide operators with a documented, safe shutdown procedure that backs up data before stopping services.

### Scope
- New file: `scripts/stop-prod.ps1`

### Files expected to change
- `scripts/stop-prod.ps1` (new file)

### Files that MUST NOT change
- Any application code
- Any Docker configuration
- Any existing script

### Implementation details

#### Script structure (`scripts/stop-prod.ps1`)

The script operates as a standalone PowerShell script with the following flow:

```
1. Validate environment (docker-compose.yml exists, docker daemon running)
2. Create pre-shutdown backup via docker exec pg_dump
3. If backup fails → exit with error (do NOT proceed)
4. Drain backend connections (optional: send SIGTERM, wait for graceful drain)
5. Stop frontend container (docker compose stop frontend)
6. Stop backend container (docker compose stop backend)
7. Stop postgres container (docker compose stop postgres)
8. Print summary
```

#### Backup mechanism

- Uses `docker exec` to run `pg_dump` inside the postgres container
- Output: custom format (`-Fc`) dump file saved to host filesystem
- Default location: `./backups/` directory (same as existing `backup.ps1`)
- Naming convention: `ethics_db_pre_shutdown_YYYYMMDD_HHmmss.dump`
- The backup step reuses the existing `backup.ps1` script pattern but adapted for Docker execution

#### Shutdown sequence

| Step | Action | Command | Timeout | Notes |
|------|--------|---------|---------|-------|
| 1 | Validate | `Test-Path docker-compose.yml`, `docker info` | — | Fail early if not in project root or docker not running |
| 2 | Backup | `docker exec postgres pg_dump -U postgres -Fc -f /tmp/backup.dump ethics_db` then copy to host | 300s (5min) | Fail-fast — abort if backup fails |
| 3 | Stop frontend | `docker compose stop frontend --timeout 30` | 30s | Frontend has no state, quick stop |
| 4 | Stop backend | `docker compose stop backend --timeout 60` | 60s | Allow in-flight requests to complete |
| 5 | Stop postgres | `docker compose stop postgres --timeout 120` | 120s | Allow connections to drain |
| 6 | Summary | Print status of each step | — | |

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `-BackupDir` | string | `./backups` | Directory to store the pre-shutdown backup |
| `-SkipBackup` | switch | — | Skip backup step (use only for non-production drills) |
| `-Force` | switch | — | Skip confirmation prompt |
| `-DbName` | string | `ethics_db` | Database name for backup |
| `-DbUser` | string | `postgres` | Database user for backup |
| `-ProjectDir` | string | `.` | Directory containing docker-compose.yml |

#### Error handling

- Any step failure (except `Stop-Process` with timeout expiry) exits immediately with non-zero code and descriptive message
- Backup failure is always fatal (even with `-Force`)
- SIGTERM is sent first; if container does not stop within timeout, SIGKILL is sent
- Partial shutdown state: if step 4 fails, steps 5+ still attempt execution (best-effort)

### Acceptance criteria
1. Script creates a pre-shutdown backup via `docker exec pg_dump` before stopping any service
2. Backup file is written to host filesystem with timestamped name
3. Script stops containers in correct order: frontend → backend → postgres
4. Each container receives graceful SIGTERM with configurable timeout before SIGKILL
5. PostgreSQL is drained after application connections close
6. Script exits with non-zero code and error message if backup fails (does not proceed to shutdown)
7. Script exits cleanly (exit 0) on successful complete shutdown
8. `-SkipBackup` flag bypasses backup (non-production use)
9. `-Force` flag skips confirmation prompt
10. Works from any directory (resolves docker-compose.yml via `-ProjectDir`)
11. No application code, Docker configuration, or existing scripts modified

### Regression tests
- **Manual (staging)**: Run `.\scripts\stop-prod.ps1` in staging environment
  - Verify backup file created in `./backups/` with timestamp
  - Verify containers stop in order: frontend → backend → postgres
  - Verify database is accessible after restart (data integrity via row count checks)
- **Drill**: Run `.\scripts\stop-prod.ps1 -SkipBackup -Force` to verify shutdown logic without backup
- **Recovery**: Run `docker compose up -d` and verify all services come online, health checks pass
- **Idempotency**: Run script twice; second run should handle already-stopped containers gracefully

### Rollback plan
- Delete `scripts/stop-prod.ps1`
- Start services manually: `docker compose up -d`

### Expected production impact
- **Positive**: Safe, repeatable shutdown procedure with guaranteed pre-shutdown backup
- **Risk**: None — new file, no existing code changed

---

## Sprint 3 — Implementation Contract Review

> This section documents the completed implementation of Sprint 3 (PB-005 + PB-004 + PB-009).

### Overview

Sprint 3 contained two API consistency fixes plus a CI infrastructure fix discovered during PB-004 triage. PB-005 and PB-004 addressed response format inconsistencies from Phase 9.5 triage; PB-009 fixed a broken CI health check URL that blocked E2E validation. All three items have been completed, verified, and accepted.

| Item | Title | Effort | Type |
|------|-------|--------|------|
| PB-005 | Fix ZodError response format consistency | 30min | Bug fix (response shape) |
| PB-004 | Standardize health check endpoint responses | 2-4h | Production hardening |
| PB-009 | Fix CI health probe URL alignment | 5min | CI/DevOps fix |

---

### PB-005 — Scope

**Purpose:** Add `requestId` to Zod validation error responses so all API error responses share the same shape.

**Files affected:**

| File | Change | Risk |
|------|--------|------|
| `backend/src/middleware/validate.ts` | One-line addition: add `requestId: (req as any).requestId \|\| '-'` to error response JSON | 🟢 Low |

**Files that MUST NOT change:**
- Any route handler
- Any service file
- Any repository file
- Any frontend code
- Any OpenAPI/Swagger spec (additive field, no contract break)
- Any error handler middleware

**API compatibility:** Fully backward-compatible. Adds a field to an existing response. Existing clients that ignore unknown fields continue to work.

**OpenAPI impact:** None mandatory. The `requestId` field is already documented in the error schema if the spec uses `allOf` or composition. If the error schema is defined as a closed type, an additive update to the spec may be needed but does not break the contract.

**SDK impact:** None. The frontend SDK does not consume the error response body for display logic — it logs errors for debugging.

**Acceptance criteria:**
1. Invalid request body → 400 response with `{ success, error, requestId }` format
2. Server error → 500 response with `{ success, error, requestId }` format
3. Both response shapes are structurally identical
4. `npm run lint` + `npm test` + `npm run build` pass

**Regression tests (Suite R4):**
- Send invalid body to any validated route → verify `requestId` present in response
- Send request that triggers 500 → verify `requestId` present in response

**Rollback:** Revert the single line change in `validate.ts`.

---

### PB-004 — Scope

**Purpose:** Unify response format across `/live`, `/ready`, and `/health` endpoints for monitoring tool interoperability.

**Files affected:**

| File | Change | Risk |
|------|--------|------|
| `backend/src/modules/monitoring/index.ts` | Refactor 3 endpoint response formats to a shared shape | 🟢 Low |
| `backend/src/config/swagger.ts` | Update OpenAPI response schemas if documented as closed types | 🟢 Low |

**Files that require verification but NOT modification (unless broken):**
| File | Reason |
|------|--------|
| `docker-compose.yml` (line 51) | HEALTHCHECK uses `wget --spider` — status code only, no body parsing. Verify only, do not modify unless broken. |
| `backend/Dockerfile` (line 18) | Same as above — status code only. Verify only, do not modify unless broken. |

**Files that MUST NOT change:**
- Any business logic
- Any route handler outside monitoring
- Any service file
- Any repository file
- Any frontend code
- Any database schema

**Current state (3 formats):**

| Endpoint | Current Response | New Response |
|----------|-----------------|--------------|
| `GET /live` | `{"status":"alive"}` | `{"status":"healthy","service":"ethics-erm-api"}` |
| `GET /ready` | `{"status":"healthy","checks":{...}}` | Same shape as `/health` (status + service + checks) |
| `GET /health` | `{"service":"...","version":"...","status":"healthy","requestId":"...","uptime":...,"timestamp":"...","checks":{...}}` | Unchanged (full diagnostic shape) |

**API compatibility analysis:**

| Endpoint | Change | Backward Compatible? | Risk |
|----------|--------|---------------------|------|
| `/live` | Status value `"alive"` → `"healthy"`; adds `service` field | ⚠️ **Breaking** for tools parsing `status` field value. Adding `service` is backward-compatible. | 🟡 Medium |
| `/ready` | Gains new fields (service, etc.) | ✅ Backward-compatible — additive only | 🟢 Low |
| `/health` | Unchanged | ✅ No change | 🟢 Low |

**Mitigation for `/live` breaking change:**
- Docker HEALTHCHECK uses `wget --spider` which only checks HTTP status code (always 200 for /live) — **unaffected**
- Kubernetes liveness probes default to checking HTTP status code (200-399) — **unaffected**
- Any monitoring tool that parses the `status` field text value must be updated from `"alive"` to `"healthy"`
- If in doubt, the health endpoints are internal/operational only, not consumed by external clients

**OpenAPI impact:** The OpenAPI spec at `backend/src/config/swagger.ts` documents the health endpoint response shape. An update is required to match the new format but is additive and does not break existing consumers.

**SDK impact:** None. Health endpoints are not consumed by the frontend SDK (the SDK is manually maintained — see SDK Policy below).

**Acceptance criteria:**
1. `GET /live` returns `{"status":"alive","service":"ethics-erm-api"}` with HTTP 200
2. `GET /ready` returns same shape as `/health` including `status`, `service`, and `checks`
3. `GET /health` returns full diagnostic shape (unchanged)
4. `/live` uses `"alive"`; `/ready` and `/health` use `"healthy"`/`"degraded"` only
5. Docker HEALTHCHECK directives pass (`docker compose ps` shows all containers healthy)
6. `npm run lint` + `npm test` + `npm run build` pass

**Regression tests (Suite R3):**
- `GET /live` → 200, body has `"status"` and `"service"` fields
- `GET /ready` → 200 (healthy) or 503 (degraded), body has `"status"`, `"service"`, `"checks"`
- `GET /health` → 200, body has `"service"`, `"version"`, `"status"`, `"requestId"`, `"uptime"`, `"timestamp"`, `"checks"`
- `docker compose ps` → all containers "healthy"
- Containers become healthy within start period after restart

**Rollback:** Revert `monitoring/index.ts` changes. Docker health checks fall back to previous response format.

---

### PB-009 — Scope

**Purpose:** Fix the CI health probe URL to align with the actual health endpoint path, unblocking E2E validation in CI.

**Background:** The CI pipeline uses `curl -sf http://localhost:8080/api/v1/health` to check server readiness, but the correct path is `http://localhost:8080/api/v1/monitoring/health`. This causes `curl -sf` to always fail (404), making the wait loop a 60-second delay followed by "Server failed to start". The logger already suppresses `/api/v1/health` requests, confirming the wrong URL was known but never fixed.

**Files affected:**

| File | Change | Risk |
|------|--------|------|
| `.github/workflows/ci.yml` (line 231) | Change `/api/v1/health` → `/api/v1/monitoring/health` | 🟢 Low |

**Files that MUST NOT change:**
- Any backend code
- Any frontend code
- Any Dockerfile or docker-compose.yml (their health checks already use the correct URL)

**API compatibility:** N/A — CI-only change, no API surface affected.

**OpenAPI impact:** None.

**SDK impact:** None.

**Acceptance criteria:**
1. CI "Wait for server" step succeeds with `curl -sf http://localhost:8080/api/v1/monitoring/health`
2. CI E2E job proceeds past the health check to run Playwright tests
3. `npm run lint` + `npm test` + `npm run build` pass locally

**Regression tests (Suite R5):**
- Run CI pipeline (manual trigger on branch) — verify E2E job health check passes
- Verify that a failing server still correctly causes the wait loop to error (no false positives)

**Rollback:** Revert the single URL change in `.github/workflows/ci.yml`.

---

### Sprint 3 — Combined Regression Risk Assessment

| Risk Factor | Assessment |
|-------------|-----------|
| **Scope creep** | Low — all three items are single-file changes (plus optional swagger update) |
| **API breakage** | 🟡 Medium — `/live` status value changes from `"alive"` to `"healthy"`. Mitigated by internal-only usage (no external consumers). |
| **Docker health checks** | 🟢 Low — `wget --spider` checks HTTP status code only |
| **Frontend impact** | 🟢 None — health endpoints not consumed by SDK |
| **CI pipeline** | 🟢 Low — PB-009 is a fix, not a change; corrects a pre-existing bug |
| **SDK (manual)** | 🟢 None — health endpoints not consumed by the manually-maintained SDK |
| **Database impact** | 🟢 None |
| **Rollback complexity** | 🟢 Low — revert single files |
| **Overall regression risk** | 🟢 Low |

### Sprint 3 — Architecture Freeze Compliance

| Freeze Rule | PB-005 (ZodError) | PB-004 (Health) | PB-009 (CI URL) |
|-------------|-------------------|-----------------|------------------|
| No new endpoints | ✅ Not adding | ✅ Not adding | ✅ CI-only, not API |
| No URL changes | ✅ Not changing | ✅ Not changing | ✅ CI config, not API |
| No frontend routing | ✅ Not touching | ✅ Not touching | ✅ Not touching |
| No database schema | ✅ Not touching | ✅ Not touching | ✅ Not touching |
| No business logic | ✅ Not touching | ✅ Not touching | ✅ Not touching |
| No module split | ✅ Not touching | ✅ Not touching | ✅ Not touching |
| No service split | ✅ Not touching | ✅ Not touching | ✅ Not touching |
| No feature addition | ✅ Bug fix only | ✅ Hardening only | ✅ Bug fix only |

**Verdict:** Sprint 3 is fully compliant with the architecture freeze.

### Sprint 3 — Implementation Order

```
PB-005 (ZodError response shape)
  ↓
  (no dependency — can run independently)
  ↓
PB-004 (Health endpoint standardization)
  ↓
  (PB-009 depends on PB-004 for correct final URL)
  ↓
PB-009 (CI health probe URL alignment)
```

**Why PB-005 first:** Single-line change, zero risk, immediate validation that the `requestId` field is available on the `req` object. Once confirmed, proceed to PB-004 which involves more format changes.

**Why PB-004 before PB-009:** PB-009 changes the CI health check URL to `/api/v1/monitoring/health`. PB-004 may alter the response shape of that endpoint. While the URL path itself won't change due to PB-004, implementing PB-004 first ensures the targeted endpoint is stable before updating the CI probe.

All three items touch different files and could technically run in parallel, but sequential order reduces diagnostic confusion if CI fails.

### Sprint 3 — Estimated Commits

| Item | Files | Estimated Commits |
|------|-------|-------------------|
| PB-005 | 1 | 1 commit |
| PB-004 | 1-2 (monitoring/index.ts ± swagger.ts) | 1 commit |
| PB-009 | 1 (ci.yml) | 1 commit |
| **Total Sprint 3** | **3-4 files** | **3 commits** |

### Sprint 3 — Verification

```bash
# After implementation:
cd backend && npm run lint    # tsc --noEmit
cd backend && npm test        # vitest run
cd frontend && npm run build  # tsc -b && vite build
# Manual:
curl http://localhost:8080/api/v1/monitoring/live
curl http://localhost:8080/api/v1/monitoring/ready
curl http://localhost:8080/api/v1/monitoring/health
docker compose ps  # verify all healthy
# CI URL correctness:
curl -sf http://localhost:8080/api/v1/monitoring/health  # should return 200
curl -sf http://localhost:8080/api/v1/health              # should return 404 (confirm broken URL is fixed)
```

---

### SDK Policy — Manual Maintenance (Not Auto-Generated)

**Investigation finding:** The frontend SDK at `frontend/src/sdk/` is **manually maintained**, not auto-generated from OpenAPI. Despite `orval` being installed as a devDependency, there is no orval configuration file, no npm codegen script, and no CI codegen step. The project's own REVIEW.md identifies this as a weakness.

**Pipeline for API contract changes:**
```
OpenAPI spec change (backend/openapi/ or swagger.ts)
  ↓  (manual, no codegen)
SDK update (frontend/src/sdk/domains/*.sdk.ts + core/types.ts)
  ↓
TypeScript compilation (tsc --noEmit / npm run build)
  ↓
Regression tests (npm test backend + frontend)
```

**Implications for Sprint 3:**
- PB-004 updates the OpenAPI spec (`swagger.ts`) for health endpoint response shapes
- Since health endpoints are **not consumed by the frontend** (no SDK methods exist for them), no SDK changes are required
- If future sprints change API response shapes consumed by the frontend, the SDK must be updated manually as part of the implementation
- The SDK's `sdk/index.ts` contains a misleading comment `// Generated from OpenAPI 3.1 Contract` — this is aspirational and does not reflect reality

**Long-term recommendation (out of Sprint 3 scope):**
Configure orval properly with an `orval.config.ts` pointing to the OpenAPI spec path and integrate codegen into CI. This would eliminate the manual maintenance burden and prevent contract drift.

---

## Backlog Items (unmodified references)

The following items remain unchanged from their original contract definitions above:
- PB-002 (lines 81-122) — scope deferred to Sprint 4
- PB-007 (backlog only) — scope deferred to Sprint 5
- PB-008 (backlog only) — scope deferred to Sprint 5

PB-009 has been added to Sprint 3 (see PB-009 — Scope section above) and is NOT deferred.
