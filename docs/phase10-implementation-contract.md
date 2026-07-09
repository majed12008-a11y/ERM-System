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

### Acceptance criteria
1. CI pipeline includes `npm audit --audit-level=high` for both backend and frontend
2. `npm audit` failure (high/critical) blocks the build
3. Build artifacts unchanged from previous CI runs

### Regression tests
- Run CI pipeline; verify backend and frontend jobs succeed
- Verify `npm audit` output appears in CI logs

### Rollback plan
- Revert `.github/workflows/ci.yml`

### Expected production impact
- **Positive**: Dependency vulnerabilities caught pre-merge
- **Risk**: `npm audit` may fail on existing vulnerabilities; use `--audit-level=high` to gate only high/critical

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
1. `GET /live` returns `{"status":"healthy","service":"ethics-erm-api"}`
2. `GET /ready` returns same shape as `/health` with `status` and `checks`
3. `GET /health` returns full diagnostic shape (unchanged) plus `service`
4. All three use consistent status values (`"healthy"`/`"degraded"`)
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

### Acceptance criteria
1. Script creates a pre-shutdown backup via `docker exec`
2. Script gracefully stops backend and frontend containers
3. PostgreSQL is drained after application connections close
4. Script exits cleanly on success
5. Script exits with error message if backup fails (does not proceed to shutdown)

### Regression tests
- Manual: run in staging, verify backup created and containers stop gracefully
- Verify database is accessible after restart (data integrity)

### Rollback plan
- Delete `scripts/stop-prod.ps1`

### Expected production impact
- **Positive**: Safe, repeatable shutdown procedure
- **Risk**: None — new file, no existing code changed
