# Production Readiness Review

Phase 9 engineering validation audit. This document validates the previously identified findings only. No implementation changes were made.

## Executive Summary

Overall status: **Not production ready** until the P0 and P1 items below are resolved and regression-tested.

Production readiness score: **56 / 100**

Validated result:

| Area | Result |
| --- | --- |
| CI / deployment validation | P0 blocker confirmed |
| SSE authentication | P1 security bug confirmed |
| Backup / restore | P0 operational blocker confirmed |
| Backup download | P1 frontend/backend integration bug confirmed |
| Document lifecycle | P1 data-retention weakness confirmed |
| Upload consistency | P1 data-integrity bug confirmed |
| Retry queue | P1 operational reliability debt confirmed |
| Architecture layering | P2 architecture debt confirmed |
| OpenAPI consistency | P1 contract drift confirmed |
| Frontend authorization | P2 route-guard weakness confirmed |

No reviewed finding was proven to be a false positive. Some findings were reclassified from "bug" to architecture, technical debt, or operational risk where the code shows intentional but incomplete structure.

## Verified Findings

### 1. CI NODE_ENV and obsolete health endpoint

Status: **Confirmed**

Classification: **P0 Critical / Bug**

Evidence:

- `backend/src/config/env.ts:18` restricts `NODE_ENV` to `development`, `production`, or `test`.
- `backend/src/config/env.ts:66-70` falls back to a synthetic development config when validation fails outside production.
- `.github/workflows/ci.yml:163-171` starts the E2E backend with `NODE_ENV: ci`, `PORT: 8080`, and CI database variables.
- `.github/workflows/ci.yml:176` probes `http://localhost:8080/api/v1/health`.
- `backend/src/index.ts:93` mounts monitoring at `/api/v1/monitoring`.
- `backend/src/modules/monitoring/index.ts:12`, `:16`, and `:33` expose `/live`, `/ready`, and `/health` under `/monitoring`.
- `backend/Dockerfile:18` and `docker-compose.yml:51` already use `/api/v1/monitoring/health`, proving `/api/v1/health` is obsolete.

Affected files:

- `.github/workflows/ci.yml`
- `backend/src/config/env.ts`
- `backend/src/modules/monitoring/index.ts`
- `backend/src/index.ts`

Execution path:

CI sets `NODE_ENV=ci` -> backend imports `env.ts` -> Zod rejects `ci` -> non-production fallback config is used -> configured CI port and database variables are ignored -> CI waits on an endpoint that does not exist.

Root cause:

The environment schema and CI pipeline disagree on the allowed environment names, and the CI health check uses a pre-monitoring URL.

Production impact:

CI can fail to validate the real production-like backend path. Worse, a failed env parse outside production silently substitutes fallback values, so the process may start against the wrong port or database.

Regression risk:

Low. This is configuration-only if fixed by allowing `ci` or using `test`, and by updating the health URL.

Recommended fix:

Use `NODE_ENV=test` in CI or add `ci` to the schema with explicit semantics. Remove the fallback that discards supplied non-production values, or make it preserve valid provided values. Change CI health probe to `/api/v1/monitoring/health`.

Estimated implementation difficulty: **Low**

### 2. SSE authentication accepts weak token paths

Status: **Confirmed**

Classification: **P1 High / Bug**

Evidence:

- `backend/src/modules/communication/index.ts:52-63` reads `req.query.token` and calls `jose.jwtVerify` directly for notification SSE.
- `backend/src/modules/communication/index.ts:63-76` trusts `payload.userId` and registers the SSE client without checking token type or user status.
- `backend/src/modules/reporting/index.ts:22-28` reads `req.query.token` and calls `jose.jwtVerify` directly for dashboard SSE.
- `backend/src/middleware/auth.ts:23-25` rejects refresh tokens in the normal Bearer path.
- `backend/src/middleware/auth.ts:38-45` performs active-user lookup in the normal Bearer path.
- `backend/src/middleware/auth.ts:75-82` issues access tokens with `type: 'access'` and refresh tokens with `type: 'refresh'`.
- `frontend/src/hooks/useNotificationStream.ts:17-18` and `frontend/src/hooks/useDashboardStream.ts:18-19` put the JWT in the EventSource query string.

Affected files:

- `backend/src/modules/communication/index.ts`
- `backend/src/modules/reporting/index.ts`
- `backend/src/middleware/auth.ts`
- `frontend/src/hooks/useNotificationStream.ts`
- `frontend/src/hooks/useDashboardStream.ts`

Execution path:

Browser creates `EventSource(...?token=JWT)` -> backend stream route reads query token -> route directly verifies signature and expiry -> route does not call `authenticate` -> refresh-token type, active-user status, and revocation/session checks are bypassed.

Root cause:

SSE routes implement a separate authentication path instead of reusing the application JWT validation rules.

Production impact:

Refresh tokens can be used as long-lived SSE credentials. Disabled users and users with revoked sessions can continue connecting until token expiry, and query-string JWTs can leak through logs, browser history, reverse proxies, and monitoring tools.

Token expiry:

Expiry is enforced by `jose.jwtVerify`, but only signature/expiry are enforced.

Refresh tokens:

Accepted by both SSE endpoints because neither checks `payload.type`.

Disabled/revoked users:

Can connect until JWT expiry because no database user lookup or session lookup occurs.

Recommended fix:

Minimum safe fix: introduce shared SSE token validation that requires `type === 'access'`, validates `sub/userId`, loads the active user, and mirrors `authenticate` behavior.

Preferred migration: issue a short-lived SSE ticket through an authenticated POST endpoint, or move stream auth to httpOnly cookie-based auth with origin/CSRF protections. Avoid long-lived JWTs in query strings.

Migration difficulty:

Medium. EventSource cannot set arbitrary Authorization headers, so the frontend transport contract must change or use short-lived stream tickets.

Regression risk:

Medium. Existing streams and reconnect behavior need browser testing.

Estimated implementation difficulty: **Medium**

### 3. Restore can run while the backend is accepting traffic

Status: **Confirmed**

Classification: **P0 Critical / Operational Risk**

Evidence:

- `backend/src/modules/admin/backup.routes.ts:11` protects backup routes with auth and admin roles, but there is no maintenance-mode gate.
- `backend/src/modules/admin/backup.routes.ts:49-52` exposes restore as an in-process API call.
- `backend/src/services/backup.service.ts:156-183` performs restore by pre-backup, connection termination, database rename, database create, `pg_restore`, rollback on failure, and old database drop on success.
- `backend/src/services/backup.service.ts:250-254` terminates current connections once and waits 500 ms.
- `backend/src/index.ts:122` keeps the Express server listening; there is no request drain or pool shutdown in the restore path.

Affected files:

- `backend/src/modules/admin/backup.routes.ts`
- `backend/src/services/backup.service.ts`
- `backend/src/index.ts`

Execution path:

Admin calls restore endpoint -> backend process remains online -> service terminates current DB sessions once -> database is renamed and recreated -> concurrent/new HTTP requests can still enter the app and open new pool connections during rename or restore.

Root cause:

Restore is implemented as a live API operation without maintenance mode, connection admission control, HTTP draining, or pool shutdown.

Production impact:

Requests can fail mid-restore, reconnect to a partially restored database, or interfere with rollback. The rollback path exists, but it is not isolated from new application traffic.

Data corruption risk:

High operational risk. `pg_restore` loads into a newly created database while the app can reconnect. The risk is partial reads/writes and inconsistent application state during restore.

Regression risk:

Medium to high. Backup/restore touches core operations and should be tested in an environment with active traffic simulation.

Recommended fix:

Require maintenance mode before restore. Drain HTTP traffic, stop background jobs, close the application pool, block new requests, run restore from an out-of-band job or maintenance command, then restart services. Until that exists, disable production restore through the live API and document a runbook.

Estimated implementation difficulty: **Medium / High**

### 4. Backup download is not authenticated correctly from the frontend

Status: **Confirmed**

Classification: **P1 High / Bug**

Evidence:

- `frontend/src/pages/Admin/BackupSettings.tsx:110-116` reads `sessionStorage.getItem('access_token')`, builds `/api/v1/admin/backup/{name}/download`, and calls `window.open`.
- `frontend/src/api/client.ts:15-23` stores the token under `accessToken`, not `access_token`.
- `frontend/src/api/client.ts:46-47` attaches `Authorization` only for Axios requests.
- `backend/src/modules/admin/backup.routes.ts:11` applies `authenticate` to download.
- `backend/src/modules/admin/backup.routes.ts:56` exposes `GET /:name/download`.

Affected files:

- `frontend/src/pages/Admin/BackupSettings.tsx`
- `frontend/src/api/client.ts`
- `backend/src/modules/admin/backup.routes.ts`

Execution path:

User clicks download -> frontend checks wrong sessionStorage key -> download does not open. If the key were fixed, `window.open` still would not attach the Bearer header required by the backend.

Root cause:

Token storage key mismatch plus direct browser navigation to an Authorization-header protected endpoint.

Production impact:

Admins cannot reliably download backups from the UI.

Regression risk:

Low.

Recommended fix:

Download through Axios as a blob so the existing interceptor sends Authorization, then create an object URL for the browser download. Alternative: add a short-lived signed download URL endpoint.

Estimated implementation difficulty: **Low**

### 5. Document lifecycle lacks durable content retention

Status: **Confirmed**

Classification: **P1 High / Architecture**

Evidence:

- `backend/src/modules/documents/documents.routes.ts:38-90` exposes list, upload, types, classifications, entity list, soft delete, sign, signatures, and pending signatures.
- No document download or preview route exists in `backend/src/modules/documents/documents.routes.ts`.
- `backend/openapi/modules/documents.yaml:69-82` defines `/documents/{id}` only for delete.
- `backend/src/services/document.service.ts:77-84` soft-deletes metadata and then unlinks the physical file.
- `backend/src/repositories/document.repository.ts:72-80` soft-deletes the row by setting `deleted_at` and `deleted_by`.

Affected files:

- `backend/src/modules/documents/documents.routes.ts`
- `backend/src/services/document.service.ts`
- `backend/src/repositories/document.repository.ts`
- `backend/openapi/modules/documents.yaml`

Execution path:

User uploads evidence -> metadata stores `storage_path` -> user/admin deletes document -> repository marks row deleted -> service removes physical file from disk -> audit metadata remains but the actual content is gone.

Root cause:

The lifecycle conflates logical deletion with physical purge, and the API has no durable retrieval/preview contract.

Production impact:

Evidence content cannot be reconstructed after soft delete. This is risky for legal audit, long-term retention, research compliance, and committee decision traceability.

Preview support:

No implementation or OpenAPI route was found. The code does not prove that preview is intentionally unsupported, so the preview requirement is **UNCONFIRMED** as a product decision and confirmed as absent functionality.

Regression risk:

Medium. Retention behavior affects storage costs, privacy expectations, and delete semantics.

Recommended fix:

Separate soft delete from physical purge. Preserve immutable content for records that are evidence or audit artifacts. Add authorized download and preview endpoints, and implement retention/purge policy explicitly.

Estimated implementation difficulty: **Medium**

### 6. Upload can leave orphan files and phantom document rows

Status: **Confirmed**

Classification: **P1 High / Bug**

Evidence:

- `backend/src/modules/documents/documents.routes.ts:22-35` configures multer disk storage.
- `backend/src/modules/documents/documents.routes.ts:51-56` runs `upload.single('file')` before calling `service.upload` and returns errors without deleting the uploaded file.
- `backend/src/services/document.service.ts:37-47` creates the database row after the file is already on disk.
- `backend/src/services/document.service.ts:52-61` can create a metadata row without an uploaded file by using `body.file_name` and `storage_path: /uploads/{file_name}`.

Affected files:

- `backend/src/modules/documents/documents.routes.ts`
- `backend/src/services/document.service.ts`
- `backend/src/repositories/document.repository.ts`

Execution path:

Browser posts multipart form -> multer writes file to disk -> service attempts DB insert -> if RLS, validation, FK, connection, or repository error occurs, route returns error while the physical file remains.

Failure paths:

- DB insert rejected by RLS after file write.
- DB validation or constraint error after file write.
- Database connection failure after file write.
- Process crash between file write and metadata insert.
- No-file request creates a metadata row pointing at a path that may not exist.

Root cause:

Filesystem write and database insert are not coordinated with compensation or staging.

Production impact:

Storage accumulates orphan files, audit rows can reference missing files, and retention reporting becomes unreliable.

Regression risk:

Medium. Upload/delete/version behavior must be tested across all document entity types.

Recommended fix:

Minimum safe fix: on service failure, unlink `req.file.path` in the route error path. Better fix: upload to a staging path, create metadata, then atomically move to final storage and mark committed; add a reconciliation job for stale staged files.

Estimated implementation difficulty: **Low / Medium**

### 7. Retry queue is in-memory despite an existing persistent table

Status: **Confirmed**

Classification: **P1 High / Technical Debt**

Evidence:

- `backend/src/services/retry-queue.service.ts:8` stores timers in a process-local `Map`.
- `backend/src/services/retry-queue.service.ts:29` uses `setTimeout` for retry scheduling.
- `backend/src/services/retry-queue.service.ts:52` can clear timers, confirming process-local lifecycle.
- `backend/src/services/notification.service.ts:113` creates `new RetryQueueService()`.
- `backend/src/services/notification.service.ts:215` enqueues delivery retry through the in-memory queue.
- `database/canonical/tables/integration.sql:174` defines `integration.retry_queue`.
- `database/canonical/indexes/integration.sql:104` and `:112` index retry timing and status.
- `backend/src/repositories/integration.repository.ts:9` reads `integration.event_outbox`; no repository use of `integration.retry_queue` was found.

Affected files:

- `backend/src/services/retry-queue.service.ts`
- `backend/src/services/notification.service.ts`
- `database/canonical/tables/integration.sql`
- `database/canonical/indexes/integration.sql`
- `backend/src/repositories/integration.repository.ts`

Execution path:

Notification delivery fails -> service enqueues retry in memory -> Node process restarts or crashes -> timers disappear -> retry is never resumed from durable storage.

Root cause:

The durable retry schema exists but is not integrated with notification delivery.

Production impact:

Transient delivery failures can become permanent after deploys, restarts, or crashes. Notification reliability is not production-grade.

Regression risk:

Medium. Persistent retry needs idempotency and worker semantics.

Recommended fix:

Persist retry jobs in `integration.retry_queue` or a notification-specific durable queue. Add a worker that claims due jobs, records attempts, survives restart, and marks terminal failures explicitly.

Estimated implementation difficulty: **Medium**

### 8. Route handlers perform direct SQL outside the service/repository layers

Status: **Confirmed**

Classification: **P2 Medium / Architecture**

Evidence:

- `backend/src/modules/reference/index.ts:6`, `:14`, `:30`, and `:41` import and execute database queries directly.
- `backend/src/modules/core/lookups.routes.ts:2`, `:10`, `:19`, `:28`, and `:41` query directly from routes.
- `backend/src/modules/admin/system-config.routes.ts:4`, `:12`, and `:24` query directly from routes.
- `backend/src/modules/admin/reference-data.routes.ts:3`, `:42`, `:51`, `:65`, `:78`, and `:88` query directly from routes.
- `backend/src/modules/monitoring/index.ts:2`, `:21`, `:38`, and `:64` query directly; this is acceptable for health/metrics and is not treated as a domain layering defect.

Affected files:

- `backend/src/modules/reference/index.ts`
- `backend/src/modules/core/lookups.routes.ts`
- `backend/src/modules/admin/system-config.routes.ts`
- `backend/src/modules/admin/reference-data.routes.ts`
- `backend/src/modules/monitoring/index.ts`

Execution path:

HTTP request enters route -> route constructs SQL and calls `query` directly -> service/repository layer is skipped.

Root cause:

Lookup/admin/reference routes appear to be legacy or utility routes that predate strict enforcement of the three-layer architecture.

Production impact:

Business rules, audit consistency, RLS context expectations, validation, and testability become harder to enforce uniformly. The risk is medium because these routes are mostly reference/admin/lookup paths, not the full transaction workflow.

Regression risk:

Low to medium. Moving SQL into repositories is straightforward but affects many endpoint tests.

Recommended fix:

Migrate domain and admin-reference SQL to repositories/services. Leave monitoring health checks as a documented exception.

Estimated implementation difficulty: **Medium**

### 9. OpenAPI, SDK, and backend contracts are out of sync

Status: **Confirmed**

Classification: **P1 High / Architecture**

Evidence:

- `backend/openapi/openapi.yaml:44` declares `http://localhost:3000/api/v1`; backend development and CI use port 8080.
- `backend/src/modules/security/auth.routes.ts:60`, `:69`, `:113`, and `:122` implement forgot-password, reset-password, verify-email, and resend-verification.
- `backend/openapi/openapi.yaml:109-119` lists only login, register, refresh, logout, me, and change-password for auth.
- `frontend/src/pages/ForgotPasswordPage.tsx:29`, `ResetPasswordPage.tsx:33`, and `VerifyEmailPage.tsx:25` call auth endpoints that are absent from OpenAPI.
- `backend/src/modules/admin/index.ts:25` mounts `/admin/backup`; `backend/src/modules/admin/backup.routes.ts:28-72` implements list, create, verify, restore, download, delete, and rotate.
- No `backup` path exists in `backend/openapi/openapi.yaml`.
- `backend/src/modules/communication/index.ts:18` implements `/communication/notifications/unread-count`.
- `frontend/src/sdk/domains/communication.sdk.ts:14` calls `/communication/notifications/unread-count`.
- `backend/openapi/openapi.yaml:317-318` only lists `/communication/messages/unread-count`; notification unread count is missing.
- `backend/src/modules/communication/index.ts:52` implements `/communication/notifications/stream`, which is absent from OpenAPI.
- `backend/openapi/modules/reporting.yaml:10-15` marks `/reporting/dashboard/stream` with `security: []`, but `backend/src/modules/reporting/index.ts:22-28` requires a query JWT.
- `backend/src/modules/documents/documents.routes.ts:38-90` has no download or preview endpoint; `backend/openapi/modules/documents.yaml:69-82` also lacks download/preview.

Affected files:

- `backend/openapi/openapi.yaml`
- `backend/openapi/modules/security.yaml`
- `backend/openapi/modules/communication.yaml`
- `backend/openapi/modules/reporting.yaml`
- `backend/openapi/modules/documents.yaml`
- `backend/src/modules/security/auth.routes.ts`
- `backend/src/modules/admin/backup.routes.ts`
- `backend/src/modules/communication/index.ts`
- `backend/src/modules/reporting/index.ts`
- `frontend/src/sdk/domains/communication.sdk.ts`
- Frontend pages listed above

Execution path:

Frontend and SDK call implemented backend endpoints -> OpenAPI either omits them, documents wrong server port, or documents wrong auth semantics -> generated SDK/contract validation cannot be trusted as the source of truth.

Root cause:

The OpenAPI contract is not being regenerated or validated against backend routes and frontend SDK usage.

Complete high-confidence mismatch report:

| Category | Backend / frontend reality | OpenAPI state | Impact |
| --- | --- | --- | --- |
| Server port | Backend dev/CI target 8080 | `localhost:3000` | Wrong generated clients/docs |
| Auth recovery | forgot/reset/verify/resend routes exist and are used | Missing from root auth paths | Auth pages outside contract |
| Admin backup | Full backup API exists and UI uses it | Missing | Critical admin API outside contract |
| Notification unread count | Backend and SDK use `/communication/notifications/unread-count` | Missing | SDK not derivable from contract |
| Notification SSE | Backend stream exists | Missing | Security/auth contract absent |
| Dashboard SSE | Requires query token in code | Marked `security: []` | Misleading public endpoint documentation |
| Documents download/preview | Not implemented | Not documented | Confirms absent lifecycle contract |

Regression risk:

Medium. Contract regeneration can affect many SDK consumers.

Recommended fix:

Make OpenAPI the authoritative contract again: update server URL strategy, add missing auth/admin/communication stream endpoints, document SSE auth parameters or replacement ticket flow, then regenerate SDK and compare frontend calls against generated clients.

Estimated implementation difficulty: **Medium**

### 10. Frontend route authorization only hides navigation links

Status: **Confirmed**

Classification: **P2 Medium / Architecture**

Evidence:

- `frontend/src/components/ProtectedRoute.tsx:4-16` checks only `isAuthenticated`.
- `frontend/src/App.tsx:111-154` nests all protected application and admin routes under the same `ProtectedRoute`.
- `frontend/src/layouts/RootLayout.tsx:62-127` assigns permissions to sidebar nav items.
- `frontend/src/layouts/RootLayout.tsx:139-145` filters visible links by `user.permissions`.
- `frontend/src/hooks/usePermission.ts:7-9` provides page-level permission checks, but route definitions do not use them.

Affected files:

- `frontend/src/components/ProtectedRoute.tsx`
- `frontend/src/App.tsx`
- `frontend/src/layouts/RootLayout.tsx`
- `frontend/src/hooks/usePermission.ts`

Execution path:

Authenticated user manually enters `/admin/backup` or `/users` -> `ProtectedRoute` allows rendering because the user is logged in -> nav visibility does not matter -> page loads and backend later denies unauthorized API calls if server permissions reject.

Root cause:

Permissions are enforced for navigation visibility, not route access.

Production impact:

Backend authorization remains the security boundary, so this is not a direct data-access bypass. However, unauthorized users can render page shells, trigger forbidden calls, and potentially see cached or static page metadata before API denial.

Regression risk:

Low to medium. Adding route metadata and a permission-aware route guard can affect routing and redirects.

Recommended fix:

Add route-level permission metadata and a permission-aware protected route wrapper. Keep backend authorization as the mandatory enforcement layer.

Estimated implementation difficulty: **Low / Medium**

## False Positives

None of the reviewed findings were proven false.

UNCONFIRMED items:

- Whether document preview is intentionally unsupported. The code proves preview is absent, but no product decision or ADR was found.
- Whether all OpenAPI mismatches beyond the high-confidence list above exist. The report lists verified mismatches only.

## Risk Matrix

| Finding | Severity | Type | Confidence | Production blast radius |
| --- | --- | --- | --- | --- |
| CI `NODE_ENV=ci` and obsolete health URL | P0 | Bug | High | Deployment validation |
| Live restore while backend accepts traffic | P0 | Operational Risk | High | Whole database |
| SSE auth bypasses normal JWT checks | P1 | Bug | High | Security / notifications / reporting |
| Backup download cannot authenticate | P1 | Bug | High | Admin operations |
| Document soft delete removes physical content | P1 | Architecture | High | Audit / retention |
| Upload orphan files | P1 | Bug | High | Storage / data integrity |
| In-memory retry queue | P1 | Technical Debt | High | Notification reliability |
| OpenAPI contract drift | P1 | Architecture | High | SDK / frontend / integrations |
| Direct SQL in routes | P2 | Architecture | High | Maintainability / policy consistency |
| Frontend route auth lacks permission guard | P2 | Architecture | High | UX / defense in depth |

## Priority Matrix

| Priority | Items |
| --- | --- |
| Fix before any production deployment | CI/env health check, restore maintenance isolation |
| Fix before production pilot | SSE auth, document retention, upload rollback, persistent retry queue, OpenAPI drift |
| Fix before scale-up | Backup download UI, route-level frontend permissions, direct SQL migration |

## Operational Readiness

Operational readiness is **not acceptable** for production. CI is not validating the intended runtime configuration, and restore is exposed as a live in-process operation without maintenance isolation.

Required minimum:

- CI must start the backend with a valid environment and probe the real health endpoint.
- Restore must require maintenance mode or move out of the live API path.
- Backup download must be testable through the admin UI.

## Architecture Health

Architecture health is **moderate with known debt**. The core three-layer pattern exists, but direct SQL remains in reference, lookup, and admin-reference routes. Monitoring direct SQL is acceptable as a documented exception; domain/reference SQL should move behind services and repositories.

## Security Health

Security health is **not production-ready** until SSE authentication is corrected. Normal REST authentication rejects refresh tokens and checks active users, but SSE bypasses those checks and puts JWTs in query strings.

## Deployment Health

Deployment health is **blocked** by CI configuration drift. `NODE_ENV=ci` is invalid for the backend schema, and the health probe targets `/api/v1/health` instead of `/api/v1/monitoring/health`.

## Data Integrity

Data integrity is **at risk** in two confirmed areas:

- Uploads can leave orphan files after database failure.
- Restore can run while requests enter the application.

Both require compensating controls before production.

## Document Storage

Document storage is **not production-ready for regulated audit retention**. Soft delete currently removes the physical file, and there is no document download/preview API contract.

## Workflow Integrity

No additional critical workflow-state blocker was proven during this validation pass. The frontend route-authorization weakness can expose page shells, but backend authorization remains the control point for protected data.

## Notification Integrity

Notification integrity is **not production-ready**. Delivery retry is process-local and lost on restart, even though a persistent `integration.retry_queue` table exists. SSE authentication also needs correction.

## Backup Integrity

Backup integrity is **partially ready for backup creation and verification**, but **not ready for production restore**. Restore must be isolated by maintenance mode or executed out of process with traffic drained and database connections closed.

## Additional Production Blockers

No additional production blocker was included unless it met all requested criteria: critical, high confidence, and easy to reproduce.

Observed but not classified as new blockers:

- S3 backup destination methods throw "not implemented" in `backend/src/services/backup-destination.ts`. This is production-critical only if S3 is selected for production, so it is not included as a universal blocker.
- Development `.env` is committed by project convention per AGENTS.md; no production secret exposure was proven in this pass.

## Overall Production Readiness Score

Score: **56 / 100**

Readiness decision: **Do not approve production deployment yet.**

Minimum approval gate:

1. Resolve P0 CI/env/health failure.
2. Put restore behind maintenance isolation or remove live restore from production.
3. Fix SSE authentication parity with REST auth.
4. Preserve document evidence content after soft delete or define and implement a compliant retention policy.
5. Add upload rollback/staging.
6. Persist notification retries.
7. Reconcile OpenAPI with backend and SDK before external integration.
