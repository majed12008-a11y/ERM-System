# Incident Response Runbook — ERM System

## 1. Severity Classification

| Severity | Label | Definition | Response Time |
|----------|-------|------------|---------------|
| **SEV-0** | Critical | Complete system outage, data loss, security breach | Immediate (≤15 min) |
| **SEV-1** | High | Major feature unavailable, degraded performance, auth broken | ≤30 min |
| **SEV-2** | Medium | Non-critical feature broken, UI glitch, single-user issue | ≤2 hours |
| **SEV-3** | Low | Cosmetic issue, documentation gap, enhancement request | Next business day |

## 2. Incident Response Flow

```
                    ┌─────────────┐
                    │ Detect      │  ← monitoring alert / user report / manual check
                    └──────┬──────┘
                           ↓
                    ┌─────────────┐
                    │ Triage      │  ← classify severity, assign owner
                    └──────┬──────┘
                           ↓
                    ┌─────────────┐
                    │ Mitigate    │  ← stop the bleeding (rollback, restart, block)
                    └──────┬──────┘
                           ↓
                    ┌─────────────┐
                    │ Resolve     │  ← apply fix, verify
                    └──────┬──────┘
                           ↓
                    ┌─────────────┐
                    │ Review      │  ← RCA, postmortem, preventive actions
                    └─────────────┘
```

## 3. Common Incident Scenarios

### SCENARIO A: Database Connection Lost (SEV-0)

**Symptoms:** API health check returns `db: unhealthy`, endpoints return 500.

**Steps:**
1. Check Postgres container: `docker compose ps postgres`
2. Check logs: `docker compose logs postgres --tail=50`
3. Verify network: `docker compose exec backend ping postgres`
4. If container crashed: `docker compose up -d postgres`
5. If data issue: restore from latest backup (see Rollback Playbook §3)
6. Verify: `docker compose exec backend wget -qO- http://localhost:8080/api/v1/monitoring/health`

**Escalation:** If container restart fails, escalate to DB admin.

### SCENARIO B: Application Crash on Startup (SEV-0)

**Symptoms:** Container repeatedly restarting, `wget health` fails.

**Steps:**
1. Check logs: `docker compose logs backend --tail=50`
2. Common causes:
   - Database not ready: verify `depends_on: condition: service_healthy`
   - Missing env vars: verify `.env` or docker-compose environment block
   - JWT_SECRET missing: verify `JWT_SECRET` is set
3. If env issue: fix and restart: `docker compose restart backend`
4. If code issue: rollback to previous tag (see Rollback Playbook §4)
5. Verify: `docker compose exec backend wget -qO- http://localhost:8080/api/v1/monitoring/health`

**Escalation:** If startup fails after 3 attempts, escalate to dev team.

### SCENARIO C: Authentication Failure (SEV-1)

**Symptoms:** Login returns 401/500 for all users, or specific roles cannot login.

**Steps:**
1. Check `GET /api/v1/monitoring/health` — is DB healthy?
2. Check JWT_SECRET hasn't changed: compare with previous deployment
3. Check rate limiting: too many failed logins may trigger rate limit
4. Try direct DB auth: `psql -U ethics_app -d ethics_db -c "SELECT username FROM security.users LIMIT 5"`
5. If JWT_SECRET rotated: ensure all services use same secret
6. If DB issue: restore from pre-release backup

**Escalation:** If auth broken for >10 minutes, rollback (see Rollback Playbook §2).

### SCENARIO D: Backup Failure (SEV-2)

**Symptoms:** Scheduled backup alert, manual backup fails.

**Steps:**
1. Check backup logs in application logs
2. Verify disk space: `df -h /app/backups`
3. Verify Postgres connectivity from backend
4. Try manual: `curl -X POST -H "Authorization: Bearer $TOKEN" http://localhost:8080/api/v1/admin/backup`
5. If disk full: rotate or archive old backups manually
6. If pg_dump permission: verify superuser credentials

**Escalation:** If backup fails for >24 hours, escalate to SEV-1.

### SCENARIO E: Seed Application Failure (SEV-1)

**Symptoms:** Seed script exits with error, application has inconsistent schema.

**Steps:**
1. Check seed status: `.\scripts\seed-status.ps1`
2. Identify failed seed from tracker table
3. Check seed SQL for errors (missing dependencies, duplicate objects)
4. Fix seed SQL and re-run: `.\scripts\apply-seeds.ps1 -Force`
5. If unrecoverable: restore DB from pre-release backup and re-apply seeds in order

**Escalation:** If schema is corrupted, restore from backup immediately.

### SCENARIO F: High Error Rate / Performance Degradation (SEV-1)

**Symptoms:** Prometheus metrics show >1% 5xx errors, p95 response time >2x baseline.

**Steps:**
1. Check `/api/v1/monitoring/metrics` for error rate and pool stats
2. Check `GET /api/v1/monitoring/health` for all checks
3. Check DB connection pool: `db_pool_waiting_requests` > 0 indicates contention
4. Check slow queries: `SELECT * FROM pg_stat_activity WHERE state = 'active' ORDER BY query_start`
5. If DB contention: increase pool size or kill long-running queries
6. If application issue: rollback to previous release
7. Restart services: `docker compose restart backend`

**Escalation:** If degradation persists after rollback, escalate to infrastructure team.

### SCENARIO G: Security Breach / Unauthorized Access (SEV-0)

**Symptoms:** Suspicious activity in audit logs, unauthorized data access.

**Steps:**
1. IMMEDIATELY: Isolate affected service (block port in firewall / stop container)
2. Preserve logs and container state for forensics
3. Rotate all secrets (JWT_SECRET, DB passwords, API keys)
4. Restore from clean backup
5. Conduct full security review
6. Notify security team and stakeholders

**Escalation:** Immediately notify CISO and legal team.

## 4. Communication Templates

### Initial Alert (within 15 min of SEV-0/SEV-1)

```
INCIDENT: <Brief description>
SEVERITY: SEV-<0|1>
AFFECTED: <System/components>
STARTED: <Timestamp>
ACTION: <Initial mitigation steps>
OWNER: <Name>
```

### Status Update (every 30 min for SEV-0, every 60 min for SEV-1)

```
UPDATE: <Incident ID>
STATUS: Investigating / Mitigating / Resolved
PROGRESS: <What has been done>
NEXT: <Next steps>
ETA: <Estimated resolution time>
```

### Resolution Notice

```
RESOLVED: <Incident ID>
SUMMARY: <What happened>
ROOT CAUSE: <Why it happened>
FIX: <What was done>
MONITORING: <Verification steps>
```

## 5. Post-Incident Review (PIR) Process

After every SEV-0 and SEV-1 incident:

1. **Schedule PIR meeting** within 48 hours
2. **Document timeline** of detection → triage → mitigation → resolution
3. **Identify root cause** (5 Whys technique)
4. **Define action items** with owners and deadlines
5. **Track in Defect Registry** (`docs/security/Defect-Registry.md`)
6. **Update runbooks** with lessons learned

## 6. Monitoring & Alerting Contacts

| Channel | Details |
|---------|---------|
| Application health | `GET /api/v1/monitoring/health` (polled every 30s) |
| Readiness probe | `GET /api/v1/monitoring/ready` (polled every 10s) |
| Prometheus metrics | `GET /api/v1/monitoring/metrics` |
| Container health | Docker HEALTHCHECK (30s interval, 3 retries) |
| DB health | Postgres pg_isready (10s interval, 5 retries) |
| Logs | `docker compose logs backend --tail=100` |
| System admin | TBD |
| DB admin | TBD |
| App owner | TBD |
