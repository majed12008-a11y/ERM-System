# Production Cutover Checklist — ERM System

## Pre-Cutover (T-24h)

### Environment Validation

- [ ] Production server provisioned (CPU, RAM, disk)
- [ ] Docker Engine 24+ installed
- [ ] Node.js 22+ installed (if non-Docker)
- [ ] PostgreSQL 18+ installed (if non-Docker)
- [ ] Network connectivity verified (DNS, firewall, ports)
- [ ] TLS certificates obtained and installed
- [ ] `/app/backups` directory has sufficient free space (>10 GB)
- [ ] `/app/uploads` directory mounted

### Configuration

- [ ] `.env` file present with all required variables
- [ ] `JWT_SECRET` is a fresh 32+ char random value
- [ ] `DB_ENCRYPTION_KEY` set (production only)
- [ ] `NODE_ENV=production`
- [ ] `CORS_ORIGIN` set to production frontend URL
- [ ] `SMTP_*` configured with production mail server
- [ ] `BACKUP_SCHEDULE_ENABLED=true`
- [ ] `BACKUP_DESTINATION_TYPE` configured (local/s3)

### Database

- [ ] DDL scripts applied (schemas, tables, functions, constraints)
- [ ] All seed files applied and verified:
      `.\scripts\seed-status.ps1` — all seeds show `[OK]`
- [ ] Pre-cutover backup taken:
      `.\scripts\backup.ps1 -Action Backup -Name "pre_cutover"`
- [ ] Backup verified:
      `.\scripts\backup.ps1 -Action Verify -Name "pre_cutover_*.dump"`

### Application Build

- [ ] Backend compiles: `cd backend && npm run build`
- [ ] Frontend compiles: `cd frontend && npm run build`
- [ ] Release tag created: `git tag -a v<version> -m "Production cutover <version>"`
- [ ] Docker images built and pushed (if using Docker):
      `docker compose build && docker compose push`

## Cutover (T-0)

### Service Start

- [ ] Postgres container started (if Docker):
      `docker compose up -d postgres`
- [ ] Postgres health confirmed:
      `docker compose ps postgres` → healthy
- [ ] Backend container started:
      `docker compose up -d backend`
- [ ] Backend health confirmed:
      `curl -sf http://localhost:8080/api/v1/monitoring/health`
- [ ] Frontend container started:
      `docker compose up -d frontend`
- [ ] Frontend accessible:
      `curl -sf http://localhost/ | head -1`

### Smoke Tests

- [ ] Health endpoint returns 200:
      `GET /api/v1/monitoring/health`
- [ ] Readiness endpoint returns DB healthy:
      `GET /api/v1/monitoring/ready`
- [ ] Metrics endpoint returns Prometheus data:
      `GET /api/v1/monitoring/metrics`
- [ ] Login as admin succeeds:
      `POST /api/v1/security/auth/login` (admin)
- [ ] Login as researcher succeeds:
      `POST /api/v1/security/auth/login` (researcher)
- [ ] List applications returns data:
      `GET /api/v1/core/applications`
- [ ] Swagger docs accessible:
      `GET /api/v1/docs`

### DNS & Proxy Flip

- [ ] DNS record updated to point to production IP
- [ ] TTL set appropriately (300s for cutover, 3600s after)
- [ ] TLS certificate valid for domain
- [ ] Reverse proxy configured (if applicable)
- [ ] HTTP→HTTPS redirect working
- [ ] Frontend loads at production URL over HTTPS

## Post-Cutover (T+1h)

### Monitoring

- [ ] HEALTHCHECK passing for all containers
- [ ] Error rate < 0.1% (check /metrics)
- [ ] DB connection pool stable (< 50% utilization)
- [ ] Response times within baseline (p95 < 500ms)
- [ ] Memory usage stable (no leak)

### Verification

- [ ] Full user flow tested (login → create project → submit application)
- [ ] Backup created and verified:
      `POST /api/v1/admin/backup` → verify
- [ ] Seed state re-verified:
      `.\scripts\seed-status.ps1`
- [ ] Scheduled backup enabled and firing:
      Check logs for "Scheduled backup created"

### Rollback Preparedness

- [ ] Rollback trigger thresholds defined
- [ ] Pre-cutover backup confirmed restorable
- [ ] Previous release tag identified for rollback
- [ ] Stakeholders notified of cutover completion

## Rollback Decision Criteria

Rollback immediately if any of these are true after cutover:

| Condition | Check |
|-----------|-------|
| Health check fails | `curl -sf http://localhost:8080/api/v1/monitoring/health` fails |
| DB connectivity lost | `/ready` returns DB unhealthy |
| Auth broken | Login returns 5xx for any role |
| Error rate >1% | `/metrics` shows >1% 5xx |
| Data integrity issue | Constraint violations in audit log |
| Performance >2x baseline | p95 response time >2x pre-cutover baseline |

## Post-Cutover (T+24h)

- [ ] Error rate stable (<0.1%)
- [ ] No memory leak (memory usage flat)
- [ ] Backup rotated and retention working
- [ ] All automated alerts firing correctly
- [ ] Stakeholder sign-off received
- [ ] DNS TTL increased to 3600s
- [ ] Pre-cutover backup archived for 30 days
