# Regression Matrix — Phase 10

> Validated against production readiness backlog (Phase 9.5)
> Each row describes a feature area, which backlog items affect it, required regression tests, and risk level.

---

## Matrix

| Feature | Affected By | Regression Tests Required | Risk Level |
|---------|-------------|--------------------------|------------|
| **API Input Validation** | PB-001 (all 18 route files) | For each of 35 newly-validated routes: (a) valid payload → 2xx, (b) invalid payload → 400, (c) boundary values. Run full E2E test suite. | 🟡 Medium |
| **Authentication & Login** | PB-001 (auth.routes.ts: refresh, logout, resend-verification) | Login → token refresh → logout cycle. Verify email verification flow. Token refresh with expired/invalid token returns 401. | 🟡 Medium |
| **Application Workflow** | PB-001 (applications.routes.ts: withdraw, appeal, renewal) | Create application → submit → withdraw. Submit → reject → appeal. Submit → approve → renewal. Verify workflow state transitions. | 🟡 Medium |
| **Certificate Management** | PB-001 (certificate.routes.ts: reissue, retry, revoke) | Issue → reissue. Issue → retry on failure. Issue → revoke. Verify certificate PDF download still works. | 🟡 Medium |
| **Document Upload/Download** | PB-001 (documents.routes.ts: POST /), PB-005 (ZodError shape) | Upload document → verify metadata in response. Upload with missing fields → verify 400 + requestId. | 🟢 Low |
| **Evidence Upload** | PB-001 (evidence.routes.ts: POST /) | Upload evidence → verify linked to condition. Upload with invalid condition_id → 400. | 🟢 Low |
| **Committee Management** | PB-001 (committees.routes.ts: add/update member) | Create committee → add member → update member role. Verify RLS restricts non-admin access. | 🟡 Medium |
| **Meeting Management** | PB-001 (meetings.routes.ts: quorum, approve minutes, update) | Create meeting → record attendance → set quorum. Create minutes → approve. Update meeting details. | 🟡 Medium |
| **Voting** | PB-001 (voting.routes.ts: close session) | Create session → cast votes → close session. Verify tally after close. Close already-closed session → 400. | 🟡 Medium |
| **Review Assignment** | PB-001 (reviews.routes.ts: submit review) | Assign reviewer → submit review. Submit with missing score → 400. | 🟢 Low |
| **Consent Management** | PB-001 (consent.routes.ts: approve, retire, update required) | Create consent version → approve. Approve → retire. Toggle `required` flag. | 🟡 Medium |
| **Risk Management** | PB-001 (risk.routes.ts: update, add mitigation) | Create risk incident → update → add mitigation. Verify mitigation linked correctly. | 🟢 Low |
| **Messaging** | PB-001 (messages.routes.ts: POST /) | Send message with attachments → verify delivered. Send with invalid recipient → 400. | 🟢 Low |
| **Backup & Restore** | PB-001 (backup.routes.ts: verify, restore), PB-002 (shell injection fix) | Create backup → verify → restore → verify data integrity. Pre-restore backup created. Rollback on failure works. | 🔴 High |
| **Admin Configuration** | PB-001 (email-config, push-config, sms-config, reference-data, system-config) | Create/update each config type → verify persisted. Test email → verify sent. Create reference data → verify listed. | 🟡 Medium |
| **Health Monitoring** | PB-004 (endpoint standardization) | GET /live → 200 + `{"status":"alive","service":"ethics-erm-api"}`. GET /ready → healthy/degraded. GET /health → full shape. Docker HEALTHCHECK passes. | 🟢 Low |
| **Error Handling** | PB-005 (ZodError response shape) | Send invalid body to any validated route → verify `requestId` in response. Send invalid body to non-validated route → verify 500 + `requestId`. | 🟢 Low |
| **CI Pipeline** | PB-003 (npm audit) | CI passes on PR branch. `npm audit` runs for both backend and frontend. Build artifacts unchanged. | 🟢 Low |
| **Production Shutdown** | PB-006 (stop-prod.ps1) | Script creates backup before shutdown. Containers stop gracefully. No data loss. | 🟢 Low |
| **Docker Deployment** | PB-004 (health check format if endpoint changes) | `docker-compose up` → all containers healthy. HEALTHCHECK passes within start period. | 🟢 Low |

---

## Regression Test Suites

### Suite R1 — Input Validation (runs per Sprint 2)
```
Precondition: Running backend with seeded database

For each of the 35 newly-protected routes:
  1. Send valid payload → expect 2xx (success/creation)
  2. Send empty body → expect 400
  3. Send malformed body (wrong types) → expect 400
  4. Send extra fields → expect 400 or ignore (per schema config)
  5. Send missing required fields → expect 400

Files: 18 route files, ~200 test cases
```

### Suite R2 — Backup Integrity (runs per Sprint 4)
```
Precondition: Running backend + postgres with seeded data

1. Create backup via API → verify backup file exists
2. List backups → verify new backup in list
3. Verify backup → verify DB object counts match source
4. Restore backup → verify data integrity after restore
5. Restore with rollback → verify old data preserved on failure
6. Attempt injection: name = "test$(malicious).dump" → expect 400
7. Backup create/verify/restore with unicode name → expect success

Files: backup.service.ts, backup-destination.ts, backup.routes.ts
```

### Suite R3 — Health Endpoints (runs per Sprint 3)
```
Precondition: Running backend

1. GET /live → 200, body has "status" and "service" fields
2. GET /ready → 200 (healthy) or 503 (degraded), body has "status" and "checks"
3. GET /health → 200, body has "service", "version", "status", "requestId", "uptime", "timestamp", "checks"
4. /live uses "alive"; /ready and /health use "healthy"/"degraded"
5. docker-compose ps → all containers "healthy"
6. Wait for restart → containers become healthy within start period

Files: monitoring/index.ts, Dockerfile, docker-compose.yml
```

### Suite R4 — Error Response Shape (runs per Sprint 3)
```
Precondition: Running backend

1. Send invalid body to any validated route → expect requestId in response
2. Send request that triggers 500 → expect requestId in response
3. Both responses have same shape: { success, error, requestId }

Files: validate.ts, errorHandler.ts
```

---

## Risk Legend

| Indicator | Meaning |
|-----------|---------|
| 🟢 Low | Single file change, backward-compatible, existing tests cover |
| 🟡 Medium | Multiple files, schema changes may break clients, needs E2E validation |
| 🔴 High | Core service change, data-critical, comprehensive manual testing required |
