# Disaster Recovery Runbook — ERM System RC1

## 1. Contact & Escalation

| Role | Name | Contact |
|------|------|---------|
| DB Admin | TBD | TBD |
| System Admin | TBD | TBD |
| App Owner | TBD | TBD |

## 2. System Architecture

```
[Frontend :80] → [Backend :8080] → [PostgreSQL 18 :5432]
                                         ↓
                                    pgdata (Docker volume)
                                    backups/ (host-mapped)
                                    uploads/ (host-mapped)
```

## 3. Backup Strategy

| Metric | Value |
|--------|-------|
| **Backup Tool** | `pg_dump` custom format (`-Fc`) |
| **Frequency** | Daily (manual/cron) |
| **Retention** | 7 daily + 4 weekly |
| **Format** | `.dump` (custom, compressible) |
| **Storage** | `./backups/` + Docker volume `backups:/app/backups` |
| **Verification** | Restore to temp DB + row-count checks |
| **RPO** | 24 hours (daily backup) |
| **RTO** | ~15 minutes (restore from .dump) |

### 3.1 What Gets Backed Up
- Full database (`ethics_db`) — schema + data via `pg_dump -Fc`
- Uploaded files (`./uploads/`)
- Configuration (`.env`, `docker-compose.yml`)

### 3.2 What Does NOT Get Backed Up (by pg_dump alone)
- Uploaded files — must be backed up separately
- Docker volumes (`pgdata` itself — use pg_dump instead for portability)

## 4. Backup Procedures

### 4.1 One-Time Backup (PowerShell)

```powershell
.\scripts\backup.ps1 -Action Backup
```

### 4.2 Named Backup

```powershell
.\scripts\backup.ps1 -Action Backup -Name "pre_uat_2026-06-21"
```

### 4.3 Via API (requires admin token)

```bash
curl -X POST http://localhost:8080/api/v1/admin/backups \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"label":"pre-uat"}'
```

## 5. Restore Procedures

### 5.1 Full Database Restore

```powershell
.\scripts\backup.ps1 -Action Restore -Name "ethics_db_20260621_120000.dump"
```

**Steps performed automatically:**
1. Create pre-restore backup (safety net)
2. Rename current DB → `ethics_db_old_NNNN`
3. Create fresh `ethics_db` (owner: ethics_app)
4. `pg_restore` the backup
5. Drop `ethics_db_old` on success
6. On failure: auto-revert (drop new, rename old back)

### 5.2 Point-in-Time Recovery

Not currently configured. Requires WAL archiving + continuous archiving.

### 5.3 Restore to a Different Environment

```powershell
pg_restore -h <target-host> -p 5432 -U ethics_app -d ethics_db -Fc ethics_db_20260621_120000.dump
```

## 6. Verification Procedure

### 6.1 Automatic Verify (recommended)

```powershell
.\scripts\backup.ps1 -Action Verify -Name "ethics_db_20260621_120000.dump"
```

*Restores to temp DB, counts rows across 5 key tables, drops temp DB.*

### 6.2 Manual Verify

```sql
SELECT 'users', COUNT(*) FROM security.users
UNION ALL SELECT 'projects', COUNT(*) FROM core.projects
UNION ALL SELECT 'applications', COUNT(*) FROM core.applications
UNION ALL SELECT 'committees', COUNT(*) FROM committee.committees
UNION ALL SELECT 'audit_logs', COUNT(*) FROM audit.audit_logs;
```

## 7. Disaster Scenarios

### Scenario A: Database Corruption

```
1. Identify corruption: check server logs, application errors
2. Stop application: docker-compose stop backend frontend
3. Restore from latest verified backup (Section 5.1)
4. Start application: docker-compose start backend frontend
5. Verify data integrity
6. RTO: ~15 min
```

### Scenario B: Accidental Data Loss

```
1. Identify scope of loss
2. If recent, restore from latest backup to temp DB
3. Export lost rows from temp DB
4. Import into production DB
5. Or: full restore if widespread
```

### Scenario C: Full Server Failure

```
1. Provision new server
2. Install Docker + Node.js 22+ (or latest LTS)
3. Clone repository, checkout tag RC1
4. Copy .env + docker-compose.yml
5. Copy latest backup file to ./backups/
6. docker-compose up -d postgres (wait for healthy)
7. Run restore (Section 5.1)
8. docker-compose up -d backend frontend
9. Run verification (Section 6.1)
10. RTO: ~30-60 min
```

### Scenario D: Container Failure

```powershell
docker-compose restart postgres
# If persistent:
docker-compose down -v   # CAREFUL: -v removes volumes!
# Restore from backup instead
docker-compose up -d postgres
.\scripts\backup.ps1 -Action Restore -Name "<latest>.dump"
```

## 8. Scheduled Backup (cron / Task Scheduler)

### Windows Task Scheduler

```powershell
# Register daily backup at 02:00
$action = New-ScheduledTaskAction -Execute "powershell.exe" `
  -Argument "-File `"$PSScriptRoot\scripts\backup.ps1`" -Action Backup"
$trigger = New-ScheduledTaskTrigger -Daily -At "02:00"
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest
Register-ScheduledTask -TaskName "ERM-DailyBackup" `
  -Action $action -Trigger $trigger -Principal $principal
```

### Linux Cron (for Docker host)

```bash
0 2 * * * cd /opt/erm && docker-compose exec -T postgres pg_dump -U postgres -Fc ethics_db > /opt/erm/backups/ethics_db_$(date +\%Y\%m\%d).dump
```

## 9. Retention Policy

| Age | Keep | Cleanup |
|-----|------|---------|
| < 7 days | All daily | — |
| 7–28 days | Weekly (Sundays) | Delete others |
| > 28 days | Monthly (1st) | Delete others |

## 10. DR Drill Checklist

- [x] Backup script exists (`scripts/backup.ps1`)
- [x] API backup endpoints exist (`/api/v1/admin/backups`)
- [x] Verification procedure implemented
- [ ] Backup scheduled (Task Scheduler / cron)
- [ ] Off-site backup configured
- [ ] Backup monitoring/alerting
- [ ] Runbook reviewed by team
- [ ] DR drill executed (see Section 11)

## 11. Drill Execution Log

### Drill #1 — 2026-06-21 (RC1 UAT Prep)

| Step | Action | Duration | Result |
|------|--------|----------|--------|
| 1 | Backup `ethics_db` via pg_dump -Fc | 9.8s | 13.8 MB written |
| 2 | Verify: restore to temp DB + row counts | 53.3s | 5/5 entities verified |
| 3 | Uploads backup (zip) | 1s | ~0 MB (2 files) |
| 4 | List backup TOC entries | — | 2,640 entries, 7 schemas |
| **Total** | | **~64s** | **PASS** |

**Verified row counts:**
| Entity | Rows |
|--------|------|
| Users | 1,021 |
| Projects | 10,161 |
| Applications | 50,021 |
| Committees | 2 |
| Audit Logs | 701,469 |

**Gaps Identified:**
- [ ] No automated backup scheduling (Task Scheduler / cron)
- [ ] No off-site/cloud backup target
- [ ] No monitoring/alerting on backup failure
- [ ] RPO = 24h (acceptable for pilot, tighten for production)
- [ ] Connection uses `postgres` superuser, not app-specific role
- [ ] WAL archiving not enabled (no PITR capability)
