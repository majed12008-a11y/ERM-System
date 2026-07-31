# RC1 — Rollback Plan

## Before Deployment

- [ ] Database backup taken: `pg_dump -U ethics_app -d ethics_erm > pre-rc1-backup.sql`
- [ ] Current working commit tagged: `git tag -a pre-rc1 -m "Pre-RC1 state"`
- [ ] Environment variables documented

## Rollback Triggers

| Condition | Action |
|-----------|--------|
| Migration failure | Restore from backup, fix migration, retry |
| Application crash on boot | Check env vars, DB connection, restore if needed |
| Authentication broken | Verify JWT_SECRET, DB_PASSWORD, restore from backup |
| Data integrity issue | Immediate restore, investigate offline |
| Performance degradation > 10% | Revert to previous version, re-benchmark |

## Rollback Procedure

### Application Rollback

```bash
# 1. Stop current
kill $(pgrep -f "node dist/index.js")

# 2. Revert code
git checkout pre-rc1
npm install
npm run build

# 3. Restart
node dist/index.js

# 4. Verify health
curl http://localhost:3000/api/v1/health
```

### Database Rollback

```bash
# 1. Drop current database
psql -U postgres -c "DROP DATABASE ethics_erm;"
psql -U postgres -c "CREATE DATABASE ethics_erm OWNER ethics_app;"

# 2. Restore from backup
psql -U ethics_app -d ethics_erm < pre-rc1-backup.sql

# 3. Verify data integrity
psql -U ethics_app -d ethics_erm -c "SELECT count(*) FROM security.users;"
psql -U ethics_app -d ethics_erm -c "SELECT count(*) FROM core.applications;"
```

### Full Rollback

```bash
git checkout pre-rc1
npm install
npm run build
pg_dump -U ethics_app -d ethics_erm > post-rc1-backup.sql  # save RC1 state
psql -U postgres -c "DROP DATABASE ethics_erm;"
psql -U postgres -c "CREATE DATABASE ethics_erm OWNER ethics_app;"
psql -U ethics_app -d ethics_erm < pre-rc1-backup.sql
node dist/index.js
```

## Post-Rollback

- [ ] Root cause documented
- [ ] Fix applied in development
- [ ] Tests re-run (182/182)
- [ ] Performance re-benchmarked
- [ ] New RC tag created
