# RC1 — Deployment Checklist

## Prerequisites

- [ ] PostgreSQL 18.3 running
- [ ] Node.js 20+ installed
- [ ] Git tag `rc1` checked out

## Fresh Install

```bash
# 1. Create database and roles
psql -U postgres -f backend/bootstrap.sql

# 2. Run migrations
cd backend
npx run-migrations  # or node migrations/*.js sequentially

# 3. Seed data
psql -U ethics_app -d ethics_erm -f seed/00-truncate.sql
psql -U ethics_app -d ethics_erm -f seed/01-reference.sql
psql -U ethics_app -d ethics_erm -f seed/02-users.sql
# ... remaining seed files in order

# 4. Install dependencies & build
npm install
npx tsc -b

# 5. Start
node dist/index.js
# Verify: http://localhost:3000/api/v1/health
```

## Environment Variables

| Variable | Required | Notes |
|----------|----------|-------|
| `DB_PASSWORD` | ✅ | No default. Dev fallback: `APP_PASSWORD` |
| `JWT_SECRET` | ✅ | Min 32 chars. Dev: auto-generated |
| `DB_HOST` | Optional | Default: localhost |
| `DB_PORT` | Optional | Default: 5432 |
| `DB_NAME` | Optional | Default: ethics_erm |
| `DB_USER` | Optional | Default: ethics_app |
| `LOG_LEVEL` | Optional | Default: info |
| `NODE_ENV` | Optional | Default: development. Fail-fast in production |

## Smoke Tests

- [ ] `GET /api/v1/health` → 200
- [ ] `POST /api/v1/security/auth/login` → accessToken
- [ ] `GET /api/v1/security/users` → paginated list (with JWT)
- [ ] `GET /api/v1/docs` → Swagger UI
- [ ] `GET /api/v1/reference/institutions-registry` → 200 (public)
- [ ] SSE stream: `/api/v1/communication/notifications/stream?token=...`
