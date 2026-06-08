# RC1 — Operations Runbook

## Startup

```bash
cd /opt/ethics-erm/backend
export NODE_ENV=production
export DB_PASSWORD=...
export JWT_SECRET=...
node dist/index.js
```

Expected: `Server running on port 3000`

## Health Check

```bash
curl http://localhost:3000/api/v1/health
# → {"success":true,"data":{"status":"healthy","db":"connected","uptime":1234}}
```

If failing: check DB connection, `DB_PASSWORD`, PostgreSQL service.

## Log Locations

| Source | Location | Format |
|--------|----------|--------|
| Application | stdout (pino) | JSON lines |
| pino-http | stdout | `←` / `→` / `✗` prefixed |
| PostgreSQL | `pg_stat_activity` | SQL queries (slow >100ms/1000ms) |

Log level controlled by `LOG_LEVEL` env var (default: `info`).

## Database Backup

```bash
pg_dump -U ethics_app -d ethics_erm -Fc -f backup-$(date +%Y%m%d).dump
# Or SQL format:
pg_dump -U ethics_app -d ethics_erm > backup-$(date +%Y%m%d).sql
```

## Database Restore

```bash
# Drop and recreate
psql -U postgres -c "DROP DATABASE ethics_erm;"
psql -U postgres -c "CREATE DATABASE ethics_erm OWNER ethics_app;"

# Restore
pg_restore -U ethics_app -d ethics_erm backup-20260608.dump
# Or for SQL format:
psql -U ethics_app -d ethics_erm < backup-20260608.sql
```

## JWT Secret Rotation

1. Generate new secret: `openssl rand -hex 32`
2. Update `JWT_SECRET` env var
3. Restart backend
4. All existing sessions invalidated (forced re-login)

## Emergency Rollback

See `RC1-Rollback-Plan.md` for detailed procedure.

Quick version:
```bash
# Stop
kill $(pgrep -f "node dist/index.js")

# Restore code
git checkout pre-rc1

# Restore DB
psql -U postgres -c "DROP DATABASE ethics_erm;"
psql -U postgres -c "CREATE DATABASE ethics_erm OWNER ethics_app;"
psql -U ethics_app -d ethics_erm < pre-rc1-backup.sql

# Restart
npm install && npm run build && node dist/index.js
```

## Monitoring Commands

```bash
# Check deadlocks
psql -U ethics_app -d ethics_erm -c "SELECT * FROM pg_stat_database WHERE datname = 'ethics_erm';"

# Check connections
psql -U ethics_app -d ethics_erm -c "SELECT count(*) FROM pg_stat_activity;"

# Check slow queries (requires pg_stat_statements)
psql -U ethics_app -d ethics_erm -c "SELECT query, mean_exec_time FROM pg_stat_statements ORDER BY mean_exec_time DESC LIMIT 10;"

# Check RLS is active
psql -U ethics_app -d ethics_erm -c "SELECT relname, relrowsecurity FROM pg_class WHERE relrowsecurity = true;"
```

## Key User Accounts (Seed Data)

| User | ID | Password | Role |
|------|----|----------|------|
| admin | 21 | admin123 | Admin |
| ethics_admin | 22 | Test@1234 | Ethics Admin |
| chairperson | 23 | Test@1234 | Chairperson |
| reviewer1-3 | 24-26 | Test@1234 | Reviewer |
| researcher1-2 | 27-28 | Test@1234 | Researcher |
