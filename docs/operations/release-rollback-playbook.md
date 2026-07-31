# Release Rollback Playbook — ERM System

## 1. Pre-Release Discipline

Before any release, the following MUST be verified:

| Check | Command / Action |
|-------|-----------------|
| Git tag created | `git tag -a v<major>.<minor>.<patch> -m "Release <version>"` |
| Database backup | `POST /api/v1/admin/backup` or `.\scripts\backup.ps1 -Action Backup -Name "pre_release_v<version>"` |
| Seed state recorded | `.\scripts\seed-status.ps1` — verify all seeds applied |
| Current git SHA recorded | `git rev-parse HEAD > .release-sha` |
| Release assets built | `npm run build` (backend + frontend) |
| Smoke test passed | `GET /api/v1/monitoring/health` returns healthy |
| Rollback threshold defined | Perf degradation <10%, error rate <1% |

## 2. Rollback Triggers

| Trigger | Threshold | Action |
|---------|-----------|--------|
| Migration failure | Seed/DDL exits with non-zero | **Immediate rollback** |
| Application crash | Process exits after startup | **Immediate rollback** |
| Authentication broken | Login returns 5xx for any role | **Immediate rollback** |
| Data integrity violation | Constraint errors in audit log | Rollback after investigation |
| Performance degradation | p95 > 2x baseline | Rollback if >10% users affected |
| Error rate spike | HTTP 5xx > 1% of requests | Rollback |

## 3. Database Rollback

### 3.1 Via Backup API (recommended)

```bash
# 1. List available backups
curl -s -H "Authorization: Bearer $TOKEN" \
  http://localhost:8080/api/v1/admin/backup | jq .

# 2. Restore pre-release backup
curl -s -X POST -H "Authorization: Bearer $TOKEN" \
  http://localhost:8080/api/v1/admin/backup/pre_release_v1.2.3_2026-07-05T02-00-00.dump/restore

# 3. Verify restoration
curl -s http://localhost:8080/api/v1/monitoring/health | jq .
```

### 3.2 Via CLI script

```bash
.\scripts\backup.ps1 -Action Restore -Name "pre_release_v1.2.3_2026-07-05T02-00-00.dump" -Password "postgres"
```

### 3.3 Manual restore (if API unavailable)

```bash
# Create fresh database
psql -U postgres -c "DROP DATABASE IF EXISTS ethics_db;"
psql -U postgres -c "CREATE DATABASE ethics_db OWNER ethics_app;"

# Restore from backup
pg_restore -U postgres -d ethics_db -Fc "backups/pre_release_v1.2.3_2026-07-05T02-00-00.dump"

# Verify
psql -U postgres -d ethics_db -c "SELECT COUNT(*) FROM security.users;"
```

## 4. Application Rollback

### 4.1 Docker deployment

```bash
# 1. Pull previous image tag
docker pull ghcr.io/your-org/ethics-erm/backend:v1.2

# 2. Update docker-compose.yml image tag
#    image: ghcr.io/your-org/ethics-erm/backend:v1.2

# 3. Restart service
docker compose up -d backend

# 4. Verify
curl -sf http://localhost:8080/api/v1/monitoring/health && echo "OK"
```

### 4.2 Manual deployment

```bash
# 1. Checkout previous release tag
git checkout v1.2

# 2. Rebuild
cd backend && npm ci && npm run build

# 3. Restart process
pm2 restart ethics-api  # or systemctl restart ethics-api
## 4. Verify
curl -sf http://localhost:8080/api/v1/monitoring/health
```

## 5. Seed Rollback

If the release added new seed files that must be reverted:

```bash
# 1. Check which seeds were applied by the release
.\scripts\seed-status.ps1

# 2. For each new seed, determine reverse operation
#    (seeds should generally be additive/idempotent — drops require manual SQL)

# 3. If a seed created tables/columns that need removal:
psql -U postgres -d ethics_db -c "
  -- Example: revert seed 52-new-feature.sql
  DROP TABLE IF EXISTS new_feature CASCADE;
  DELETE FROM ops.seed_tracker WHERE filename = '52-new-feature.sql';
"

# 4. Re-verify seed state
.\scripts\seed-status.ps1
```

## 6. Post-Rollback Verification Checklist

| Step | Action |
|------|--------|
| 1 | Verify `GET /api/v1/monitoring/health` returns `healthy` |
| 2 | Verify `GET /api/v1/monitoring/ready` returns DB `healthy` |
| 3 | Login as admin + researcher |
| 4 | Verify core CRUD (project, application, committee) |
| 5 | Check error rate in logs (<1%) |
| 6 | Verify backup of pre-rollback state exists |
| 7 | Document rollback cause in incident log |
| 8 | Notify stakeholders of rollback and status |
| 9 | Schedule RCA meeting |

## 7. Rollback Prevention Checklist

| Practice | Status |
|----------|--------|
| All seeds idempotent (IF NOT EXISTS / OR REPLACE) | In progress |
| Seed tracker table (ops.seed_tracker) | ✅ |
| Pre-release backup automated | ✅ |
| Canary deployment (staged rollout) | ❌ |
| Feature flags for risky changes | ❌ |
| Automated rollback tests | ❌ |
