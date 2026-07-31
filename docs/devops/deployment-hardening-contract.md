# Phase 5 Priority 4 — Deployment Hardening

## Commit 1: Deployment Audit + Production Readiness Contract

### Current State Summary

| Dimension | Score | Critical | High | Medium | Low |
|-----------|-------|----------|------|--------|-----|
| Secrets/Config Hardening | 4/10 | 0 | 2 | 4 | 4 |
| Backup/Restore | 5/10 | 2 | 3 | 5 | 1 |
| DB Resilience | 3/10 | 0 | 3 | 4 | 1 |
| Security Headers | 5/10 | 2 | 0 | 3 | 4 |
| Rate Limits | 6/10 | 2 | 1 | 3 | 0 |
| Deployment Runbooks | 5/10 | 1 | 1 | 5 | 4 |
| Rollback Strategy | 5/10 | 1 | 0 | 2 | 1 |
| **Overall** | **4.7/10** | **8** | **10** | **26** | **15** |

---

## 1. Secrets & Config Hardening

### Current State

| Aspect | Status | Details |
|--------|--------|---------|
| `.env` committed to git | ❌ | `backend/.env` tracked despite `.gitignore` rule |
| Zod validation | ✅ | Central schema at `env.ts`, rejects production on failure |
| Pino redaction | ✅ | Sensitive fields redacted in logs |
| Dockerfile secrets | ⚠️ | No Docker secrets, no `.env` baked into image (good) |
| DB_ENCRYPTION_KEY in Docker | ❌ | Not passed in `docker-compose.yml` — encryption silently disabled |
| JWT_SECRET in Docker | ⚠️ | No default — will be empty string if not set |
| CHROME_PATH bypasses Zod | ❌ | Read directly from `process.env` |
| Vite API base URL | ⚠️ | No support for runtime config — only build-time |

### Risk Inventory

| ID | Severity | Finding | Location |
|----|----------|---------|----------|
| SEC-01 | **HIGH** | `.env` committed to git — DB_PASSWORD (`postgres`) and JWT_SECRET (real 64-char hex) exposed in version control | `backend/.env` |
| SEC-02 | **HIGH** | DB_ENCRYPTION_KEY not passed in docker-compose — AES-256-GCM encryption silently disabled in containerized deployments | `docker-compose.yml` |
| SEC-03 | MEDIUM | Hardcoded dev passwords (`admin123`, `Test@1234`) in test files and seed SQL with known plaintext | 6 test files, 5 seed files |
| SEC-04 | MEDIUM | Fallback hardcoded `DB_PASSWORD: 'APP_PASSWORD'` in dev env validation | `env.ts:43` |
| SEC-05 | MEDIUM | `CHROME_PATH` read from raw `process.env` — bypasses Zod validation and missing-var warnings | `certificate.service.ts:399` |
| SEC-06 | MEDIUM | `NODE_ENV` read from raw `process.env` in error handler — bypasses Zod | `errorHandler.ts:24` |
| SEC-07 | LOW | Frontend `.gitignore` does not exclude `.env` files | `frontend/.gitignore` |
| SEC-08 | LOW | No secrets scanning tooling (gitleaks, secretlint, husky pre-commit hooks) | Project-wide |
| SEC-09 | LOW | All env vars read from `process.env` at module import time — no lazy loading | `env.ts`, multiple services |
| SEC-10 | LOW | Pino logger redacts `req.headers.authorization`, `req.body.password` (good) | `logger.ts:23` |

---

## 2. Backup / Restore

### Current State

| Aspect | Status | Details |
|--------|--------|---------|
| Backup script | ✅ | `scripts/backup.ps1` — pg_dump custom format |
| API backup endpoints | ✅ | 6 routes under `/api/v1/admin/backup` |
| DR runbook | ✅ | `docs/dr-runbook.md` — procedures documented |
| Auto backup scheduling | ❌ | Not implemented — no cron, no in-app scheduler |
| Backup in Docker | ❌ | `pg_dump`/`pg_restore` not installed in `backend` Docker image |
| Backup rotation | ⚠️ | `rotate-backups.ps1` exists but not integrated with API |
| Pre-restore backup | ✅ | Automatic before every restore |
| Auto-revert on failure | ✅ | Renames `_old` DB back on restore failure |
| Verify procedure | ✅ | Restore to temp DB + row-count checks |
| Off-site backup | ❌ | All backups stored locally in `backups/` directory |
| Encrypted backups | ❌ | Backups are plain pg_dump custom format |

### Risk Inventory

| ID | Severity | Finding | Location |
|----|----------|---------|----------|
| BKP-01 | **CRITICAL** | `pg_dump`/`pg_restore`/`psql` not installed in Docker image — backup/restore/verify APIs will fail at runtime | `backend/Dockerfile` |
| BKP-02 | **CRITICAL** | No automated backup scheduling — zero backup automation in code | `package.json`, whole codebase |
| BKP-03 | **HIGH** | Database superuser password exposed in process list via `pg_dump -d "postgres://user:pass@..."` connection string | `backup.service.ts:59-61,117` |
| BKP-04 | **HIGH** | Cleanup errors silently swallowed with `.catch(() => {})` — can orphan temp databases | `backup.service.ts:158,182,183,187` |
| BKP-05 | **HIGH** | Password passed as CLI parameter in `backup.ps1` — visible in process listing | `scripts/backup.ps1:11,19` |
| BKP-06 | MEDIUM | Shell injection surface: `$Name` unsanitized in psql DDL commands | `scripts/backup.ps1:86,95-98` |
| BKP-07 | MEDIUM | No Swagger documentation for backup endpoints | `swagger.ts` |
| BKP-08 | MEDIUM | No input validation on POST `/admin/backup` body | `backup.routes.ts:25` |
| BKP-09 | MEDIUM | `pg_restore` stderr redirected to `$null` — diagnostic info lost | `scripts/backup.ps1:99,132,148` |
| BKP-10 | MEDIUM | No backup retention/rotation in `BackupService` API | `backup.service.ts` |
| BKP-11 | LOW | Backup always connects as superuser (`postgres`), bypassing RLS | `backup.service.ts:54-56` |

---

## 3. Database Resilience

### Current State

| Aspect | Status | Details |
|--------|--------|---------|
| Pool max connections | ✅ | 20 — adequate for single instance |
| Idle timeout | ✅ | 30s |
| Connection timeout | ⚠️ | 2s — may be too tight for cloud deployments |
| `statement_timeout` | ❌ | Not set — runaway queries can run indefinitely |
| `idle_in_transaction_session_timeout` | ❌ | Not set — abandoned transactions can hold locks |
| SSL/TLS for DB | ❌ | Not configured — traffic unencrypted in cloud |
| Connection retry on startup | ❌ | No retry loop before HTTP server starts |
| Pool monitoring metrics | ❌ | No pool size/utilization in Prometheus |
| Circuit breaker / failover | ❌ | Single host, single pool, no replica |
| TCP keepalive | ❌ | Not configured |
| Health check in Docker | ✅ | `pg_isready` in docker-compose |
| Slow query logging | ✅ | >100ms logged, >1000ms warn |

### Risk Inventory

| ID | Severity | Finding | Location |
|----|----------|---------|----------|
| DBR-01 | **HIGH** | No `statement_timeout` or query timeout — runaway queries can run indefinitely | `database.ts:50-73` |
| DBR-02 | **HIGH** | No SSL/TLS for production database connections | `database.ts:17-26` |
| DBR-03 | **HIGH** | No connection retry on startup — app fails immediately if DB is down | `index.ts:100-102` |
| DBR-04 | MEDIUM | No pool monitoring metrics (total/active/idle/waiting) exposed | `metrics.service.ts` |
| DBR-05 | MEDIUM | No circuit breaker or failover to replica | `database.ts` |
| DBR-06 | MEDIUM | `connectionTimeoutMillis: 2000` may be too tight for cloud | `database.ts:25` |
| DBR-07 | MEDIUM | No `idle_in_transaction_session_timeout` | `database.ts:17-26` |
| DBR-08 | LOW | No `keepAlive` on pool connections | `database.ts:17-26` |

---

## 4. Security Headers

### Current State

| Header | Status | Source |
|--------|--------|--------|
| `X-Frame-Options: SAMEORIGIN` | ✅ | Helmet default |
| `X-Content-Type-Options: nosniff` | ✅ | Helmet default |
| `Strict-Transport-Security` | ✅ | Helmet default (max-age=15552000, includeSubDomains) |
| `Content-Security-Policy` | ⚠️ | Helmet defaults — very restrictive, no custom directives |
| `Referrer-Policy: no-referrer` | ✅ | Helmet default |
| `Permissions-Policy` | ✅ | Helmet 8 default |
| `X-XSS-Protection: 0` | ✅ | Helmet default |
| `Cross-Origin-Opener-Policy` | ❌ | Not set |
| `Cross-Origin-Embedder-Policy` | ❌ | Not set |
| Nginx security headers | ❌ | Frontend nginx sets zero security headers |
| CORS restricted origin | ✅ | Configurable via `CORS_ORIGIN`, `credentials: true` |
| `X-Request-Id` | ✅ | Manually set on all responses |

### Risk Inventory

| ID | Severity | Finding | Location |
|----|----------|---------|----------|
| HDR-01 | **CRITICAL** | Frontend nginx proxy sets zero security headers — no CSP, HSTS, X-Frame-Options, X-Content-Type-Options | `frontend/nginx.conf` |
| HDR-02 | **CRITICAL** | Helmet CSP in production uses restrictive defaults with zero custom directives — will block CDN fonts, analytics, scripts | `index.ts:67-70` |
| HDR-03 | MEDIUM | `NODE_ENV=ci` causes dev-level security (CSP disabled) in CI e2e tests | `ci.yml:152` |
| HDR-04 | MEDIUM | HSTS `includeSubDomains` may break non-HTTPS subdomains | Helmet default via `index.ts:67` |
| HDR-05 | MEDIUM | No `Cross-Origin-Opener-Policy` or `Cross-Origin-Embedder-Policy` — Spectre mitigation missing | Not set |
| HDR-06 | LOW | CORS falls back to `localhost:5173` in production if `CORS_ORIGIN` unset | `index.ts:72` |
| HDR-07 | LOW | CORS does not restrict allowed methods, headers, or maxAge | `index.ts:71-74` |
| HDR-08 | LOW | Error handler hides details in production (good) | `errorHandler.ts:24` |
| HDR-09 | LOW | Manual `X-Request-Id` on all responses (good) | `index.ts:61` |

---

## 5. Rate Limits

### Current State

| Endpoint | Limiter | Threshold | Configurable? |
|----------|---------|-----------|---------------|
| Global (all API routes) | Global | 60/min (prod), 100/min (dev) | ❌ Hardcoded |
| POST `/login` | Login | 10/min | ❌ Hardcoded |
| POST `/register` | Register | 5/min | ❌ Hardcoded |
| POST `/forgot-password` | Forgot | 3/min | ❌ Hardcoded |
| GET `/verify/:serialNumber` | Verify | 10/min | ❌ Hardcoded |

### Endpoints Without Specific Limiters

| Endpoint | Risk | Reason |
|----------|------|--------|
| POST `/refresh` | **HIGH** | No per-endpoint limiter — only global 60/min |
| POST `/reset-password` | MEDIUM | No per-endpoint limiter |
| POST `/resend-verification` | MEDIUM | Can be abused for email bombing |
| POST `/change-password` | LOW | Requires auth |
| GET `/health`, `/live`, `/ready` | LOW | Public but expected high volume |

### Risk Inventory

| ID | Severity | Finding | Location |
|----|----------|---------|----------|
| RTL-01 | **CRITICAL** | `trust proxy` not configured — `req.ip` returns nginx IP, breaking ALL IP-based rate limiting behind reverse proxy | Missing from `index.ts` |
| RTL-02 | **CRITICAL** | All rate limit thresholds hardcoded — not configurable via env vars | `index.ts:21,76`, `auth.routes.ts:13-14`, `certificate.routes.ts:15` |
| RTL-03 | HIGH | `/refresh` endpoint has no specific rate limiter — can be abused | `auth.routes.ts:74` |
| RTL-04 | MEDIUM | `/reset-password` has no specific rate limiter | `auth.routes.ts:65` |
| RTL-05 | MEDIUM | `/resend-verification` can be abused for email bombing | `auth.routes.ts:118` |
| RTL-06 | MEDIUM | Health check endpoints (`/live`, `/ready`, `/health`) subject to global 60/min limit — will block orchestrator probes under load | `index.ts:76` |

---

## 6. Deployment Runbooks

### Current State

| Aspect | Status | Details |
|--------|--------|---------|
| Docker Compose | ✅ | 3 services with resource limits and restart policies |
| Backend Dockerfile | ✅ | Multi-stage, non-root user, Alpine, production deps only |
| Frontend Dockerfile | ✅ | Multi-stage, nginx-alpine |
| HEALTHCHECK (backend) | ❌ | Not in Dockerfile or docker-compose |
| HEALTHCHECK (frontend) | ❌ | Not in Dockerfile or docker-compose |
| CI/CD pipeline | ⚠️ | CI only — builds images but does not deploy |
| Image tagging | ⚠️ | `latest` + `${{ github.sha }}` — no semantic versions |
| Vulnerability scanning | ❌ | No Trivy, Snyk, or Docker Scout |
| Custom Docker network | ❌ | Uses default bridge (no isolation) |
| CPU limits | ❌ | Not set on any service — no CPU caps |
| NODE_ENV handling | ❌ | `NODE_ENV=ci` not in env schema — validation failure |

### Risk Inventory

| ID | Severity | Finding | Location |
|----|----------|---------|----------|
| DEP-01 | **CRITICAL** | No HEALTHCHECK on backend or frontend containers — orchestrator cannot detect unhealthy containers | `backend/Dockerfile`, `docker-compose.yml` |
| DEP-02 | HIGH | CI pipeline builds images but has no deployment step — manual deploy required | `.github/workflows/ci.yml` |
| DEP-03 | MEDIUM | No CPU limits on any Docker service | `docker-compose.yml` |
| DEP-04 | MEDIUM | No custom Docker network | `docker-compose.yml` |
| DEP-05 | MEDIUM | No semantic version tags for Docker images | `ci.yml:198-212` |
| DEP-06 | MEDIUM | No container image vulnerability scanning | `ci.yml` |
| DEP-07 | MEDIUM | `NODE_ENV=ci` not in env schema — validation fails silently | `ci.yml:152`, `env.ts:18` |
| DEP-08 | LOW | Frontend starts without waiting for backend to be healthy | `docker-compose.yml:52-53` |
| DEP-09 | LOW | Backend Dockerfile copies as root then chowns to app user | `backend/Dockerfile:15-16` |

---

## 7. Rollback Strategy

### Current State

| Aspect | Status | Details |
|--------|--------|---------|
| Pre-restore auto-backup | ✅ | Created before every restore operation |
| Auto-revert on restore failure | ✅ | Renames `_old` DB back |
| Backup verify procedure | ✅ | Full restore to temp DB + row-count checks |
| DB migrations reversible | ✅ | All 6 migrations have `exports.down` |
| Docker image versioning | ⚠️ | `${{ github.sha }}` tags allow rollback but no semver mapping |
| Seed file rollback | ❌ | 34+ seed SQL files not migration-controlled — irreversible |
| Feature flags | ❌ | Zero feature flags — no canary or gradual rollout |
| Blue-green deployment | ❌ | No support |
| Backup rotation | ⚠️ | `rotate-backups.ps1` exists but not integrated |

### Risk Inventory

| ID | Severity | Finding | Location |
|----|----------|---------|----------|
| ROL-01 | **CRITICAL** | 34+ seed SQL files not migration-controlled — irreversible if breaking data changes introduced | `backend/seed/` |
| ROL-02 | MEDIUM | No semantic version tags — rollback requires knowing exact commit SHA | `ci.yml:198-212` |
| ROL-03 | MEDIUM | Backup rotation script exists but not integrated with API | `scripts/rotate-backups.ps1` |
| ROL-04 | LOW | Shell injection surface in `backup.ps1` could corrupt rollback path | `scripts/backup.ps1:86,95-98` |

---

## 8. Architecture Decisions (ADRs)

### ADR-P4-001: Rate limit configurability ✅
**Decision**: Move all rate limit thresholds to env vars with sensible defaults.
**Rationale**: Hardcoded thresholds prevent tuning without code changes. Production environments need different limits than dev.
**Implemented**: `RATE_LIMIT_GLOBAL_MAX`, `RATE_LIMIT_AUTH_WINDOW_MS`, `RATE_LIMIT_LOGIN_MAX`, `RATE_LIMIT_REGISTER_MAX`, `RATE_LIMIT_FORGOT_MAX`, `RATE_LIMIT_REFRESH_MAX`, `RATE_LIMIT_RESET_PASSWORD_MAX`, `RATE_LIMIT_RESEND_VERIFICATION_MAX`, `RATE_LIMIT_VERIFY_MAX` added to env schema. All inline rate limiters use env vars.
**Files**: `env.ts`, `index.ts`, `auth.routes.ts`, `certificate.routes.ts`

### ADR-P4-002: Trust proxy configuration ✅
**Decision**: Add `app.set('trust proxy', 1)` to trust the nginx reverse proxy.
**Rationale**: Without this, `express-rate-limit` cannot distinguish between different clients — all traffic appears from nginx IP.
**Implemented**: `TRUST_PROXY` env var (default 1), applied as `app.set('trust proxy', env.TRUST_PROXY)`.
**Files**: `env.ts`, `index.ts`

### ADR-P4-003: DB SSL enforcement ✅
**Decision**: Add `DB_SSL` env var (boolean) and configure pool with `ssl: { rejectUnauthorized: true }` when enabled.
**Rationale**: Cloud deployments require encrypted database traffic. Current no-SSL config is acceptable only for local/Docker. PostgreSQL runs on Docker internal network (`postgres` hostname), so SSL unnecessary in Docker; required for cloud/managed DB.
**Implemented**: `DB_SSL` (default false), `DB_SSL_REJECT_UNAUTHORIZED` (default true). Pool config conditionally sets `ssl`.
**Files**: `env.ts`, `database.ts`

### ADR-P4-004: Query timeout enforcement ✅
**Decision**: Set `statement_timeout` at the pool level (per-session) and expose `DB_STATEMENT_TIMEOUT` env var.
**Rationale**: Runaway queries are a production reliability risk. Even PostgreSQL's own `statement_timeout` was not configured.
**Implemented**: `DB_STATEMENT_TIMEOUT` (default 30000ms), `DB_IDLE_TX_TIMEOUT` (default 60000ms). Set via `SET SESSION` in pool connect handler.
**Files**: `env.ts`, `database.ts`

### ADR-P4-005: DB connection retry on startup
**Decision**: Add retry loop with configurable interval and max attempts before starting HTTP server.
**Rationale**: The app currently fails immediately if DB is unavailable. Docker `depends_on` with `condition: service_healthy` covers Docker deployments, but dev/standalone use has no protection.
**Status**: Deferred to Commit 3.

### ADR-P4-006: Docker HEALTHCHECK
**Decision**: Add HEALTHCHECK to backend (curl `/live`) and frontend (curl nginx `/`) Dockerfiles.
**Rationale**: Without health checks, the orchestrator cannot detect or restart unhealthy containers. Docker Compose restart policies become less effective.
**Status**: Deferred to Commit 5 (per plan).

### ADR-P4-007: Postgres client in Docker image
**Decision**: Add `apk add --no-cache postgresql-client` to the backend Dockerfile.
**Rationale**: The backup/restore/verify API endpoints call `pg_dump`, `pg_restore`, and `psql` — these are not present in the `node:22-alpine` base image, making the backup API non-functional in production.
**Status**: Deferred to Commit 3 (per plan).

### ADR-P4-008: Nginx security headers ✅
**Decision**: Add security headers to `frontend/nginx.conf` matching the backend Helmet configuration.
**Rationale**: The frontend nginx proxy sets zero security headers. All users interact with the frontend through nginx, making this the most critical point for header enforcement.
**Implemented**: HSTS, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, Permissions-Policy, Content-Security-Policy.
**Files**: `frontend/nginx.conf`

### ADR-P4-009: Seed file migration control
**Decision**: Keep seed files manual but document their dependencies and add a pre-seed backup step in the deployment runbook.
**Rationale**: Converting 34+ seed files to migrations would be high-effort. The backup restore mechanism already provides rollback.
**Status**: Deferred to Commit 6 (per plan).

### ADR-P4-010: Health endpoints excluded from global rate limiter ✅
**Decision**: Move `/live`, `/ready`, `/health`, `/metrics` before the global rate limiter registration.
**Rationale**: Orchestrator health probes can fire frequently under load. The global 60/min limiter would cause orchestrators to see 429 responses.
**Implemented**: Monitoring routes registered before global `rateLimit()` middleware.
**Files**: `index.ts`

### ADR-P4-011: CSP blob: for certificate/report downloads ✅
**Decision**: Add explicit CSP directives with `blob:` in `defaultSrc` for PDF certificate and CSV report downloads.
**Rationale**: Helmet's default CSP blocks blob URLs. Both `CertificatesTab` and `ReportsPage` use `URL.createObjectURL()` for file downloads.
**Implemented**: Custom CSP directives on Helmet (backend) and nginx (frontend) with `default-src 'self' blob:`.
**Files**: `index.ts`, `frontend/nginx.conf`

---

## 9. Commit Plan — Updated

### Commit 2: ✅ Security & Rate Limit Hardening (DONE)
- Move `/live`, `/ready`, `/health`, `/metrics` before global rate limiter ✅
- Add `TRUST_PROXY` env var and `app.set('trust proxy', env.TRUST_PROXY)` ✅
- Make all rate limit thresholds configurable via env vars ✅
- Add specific rate limiters for `/refresh`, `/reset-password`, `/resend-verification` ✅
- Add security headers to `frontend/nginx.conf` (HSTS, XFO, XCTO, Referrer-Policy, Permissions-Policy, CSP) ✅
- Add custom CSP directives to Helmet configuration (blob: for cert/report downloads) ✅
- Add `DB_SSL` env var and pool SSL config ✅
- Add `DB_STATEMENT_TIMEOUT` and `DB_IDLE_TX_TIMEOUT` env vars and pool session config ✅
- Update `.env.example` with all new env vars ✅
- CSP validated against SSE (same-origin), Vite frontend (static bundles), QR flows (not used), blob/data URLs (added `blob:`) ✅

### Commit 3: DB Resilience & Connection Hardening
- Add connection retry loop on startup before HTTP server listen
- Add `idle_in_transaction_session_timeout` to pool config
- Add `keepAlive` to pool config
- Add pool monitoring metrics to Prometheus registry
- Increase `connectionTimeoutMillis` from 2000 to configurable default (e.g. 5000)
- Add postgresql-client to backend Dockerfile (apk add)
- Add `DB_POOL_MAX` env var (currently hardcoded to 20)

### Commit 4: Backup & Restore Hardening
- Fix backup.service.ts — use `execFile` with args array instead of shell string
- Fix backup.service.ts — add error logging on cleanup `.catch(() => {})`
- Fix backup.service.ts — use `PGPASSWORD` env var instead of inline connection string
- Add backup retention/rotation to `BackupService` API
- Add Swagger documentation for backup endpoints
- Add input validation on backup POST route
- Add `node-cron` dependency and implement in-app backup scheduling

### Commit 5: Docker & CI/CD Hardening
- Add HEALTHCHECK to backend and frontend Dockerfiles
- Add CPU limits to docker-compose.yml
- Add custom Docker network
- Add NODE_ENV=production handling in CI (fix `ci` → valid env value)
- Add semantic version tagging to CI (git tag triggers)
- Add `CORS_ORIGIN`, `FRONTEND_URL`, `DB_ENCRYPTION_KEY` to docker-compose.yml env vars
- Add DB_ENCRYPTION_KEY to env schema (conditionally required in production)

### Commit 6: Rollback & Runbook Updates
- Add pre-seed backup requirement to deployment runbook
- Document seed file application order and dependencies
- Update `scripts/backup.ps1` — fix shell injection, add input sanitization
- Update `scripts/backup.ps1` — remove hardcoded password, make mandatory parameter
- Add off-site/cloud backup section to DR runbook
- Update CI pipeline to add container vulnerability scanning
- Document rollback procedure in deployment runbook

### Commit 7: Verification
- Run full test suite
- Verify rate limits with configurable env vars
- Verify security headers via curl
- Verify DB SSL and query timeouts
- Verify backup/restore workflow in Docker
- Confirm no regressions
- Update production readiness report score

---

## 10. Detailed Risk Breakdown

### All Critical Risks (8)

| ID | Dimension | Risk | Proposed Fix | Commit |
|----|-----------|------|-------------|--------|
| BKP-01 | Backup | `pg_dump`/`pg_restore` not in Docker | Add `apk add postgresql-client` | C3 |
| BKP-02 | Backup | No automated backup scheduling | Implement with `node-cron` | C4 |
| HDR-01 | Security | Nginx zero security headers | Add headers to nginx.conf | C2 |
| HDR-02 | Security | CSP too restrictive | Custom CSP directives | C2 |
| RTL-01 | Rate Limits | `trust proxy` not set — IP limiting broken | `app.set('trust proxy', 1)` | C2 |
| RTL-02 | Rate Limits | All thresholds hardcoded | Env vars for all thresholds | C2 |
| DEP-01 | Deployment | No HEALTHCHECK on containers | Add HEALTHCHECK to Dockerfiles | C5 |
| ROL-01 | Rollback | Seeds not migration-controlled | Runbook: backup before seeds | C6 |

### All High Risks (10)

| ID | Dimension | Risk | Proposed Fix | Commit |
|----|-----------|------|-------------|--------|
| SEC-01 | Secrets | `.env` committed to git | Remove from git, add to .gitignore | C2 |
| SEC-02 | Secrets | DB_ENCRYPTION_KEY missing in Docker | Add to docker-compose env | C5 |
| BKP-03 | Backup | Password in process list | Use PGPASSWORD env var | C4 |
| BKP-04 | Backup | `.catch(() => {})` swallows errors | Log cleanup failures | C4 |
| BKP-05 | Backup | Password in CLI args | Make mandatory param, use env | C4 |
| DBR-01 | DB | No statement_timeout | Add session config | C2 |
| DBR-02 | DB | No SSL/TLS | Add DB_SSL config | C2 |
| DBR-03 | DB | No startup retry | Add retry loop | C3 |
| RTL-03 | Rate Limits | No refresh limiter | Add specific limiter | C2 |
| DEP-02 | Deployment | CI only, no CD | Add deployment step or doc | C5 |
