# RC1 — Deployment Checklist

## Option A: Docker Compose (Recommended)

```bash
# 1. Prerequisites
docker --version       # Docker 24+
docker compose version # Docker Compose v2

# 2. Set secrets
$env:JWT_SECRET = "<your-32-char-hex-secret>"

# 3. Start all services
docker compose up -d --build

# 4. Verify
curl http://localhost:8080/api/v1/health
curl http://localhost/api/v1/health  # via Nginx
```

**Stack:** Frontend (Nginx:80) → Backend (Node:8080) → PostgreSQL (5432)

## Option B: Manual Install

### Prerequisites

- [ ] PostgreSQL 18.3 running
- [ ] Node.js 20+ installed
- [ ] Git tag `rc1` checked out

### Fresh Install

```bash
# 1. Create database and roles
psql -U postgres -f DDL\ Script.sql

# 2. Apply schema
psql -U postgres -d ethics_db -f ethics_db_tables.sql
psql -U postgres -d ethics_db -f ethics_db_functions.sql
psql -U postgres -d ethics_db -f ethics_db_tables_constraints.sql

# 3. Install dependencies & build
cd backend
npm install
npm run build

# 4. Start
npm start
# Verify: http://localhost:8080/api/v1/health
```

### Frontend (Development)
```bash
cd frontend
npm install
npm run dev
# Opens: http://localhost:5173
```

## Environment Variables

| Variable | Required | Default | Notes |
|----------|----------|---------|-------|
| `JWT_SECRET` | ✅ | — | Min 32 hex chars. **Must set in production** |
| `DB_PASSWORD` | ✅ | postgres | PostgreSQL password |
| `PORT` | Optional | 8080 | Backend listen port |
| `DB_HOST` | Optional | localhost | Docker: `postgres` |
| `DB_PORT` | Optional | 5432 | |
| `DB_NAME` | Optional | ethics_db | |
| `DB_USER` | Optional | postgres | |
| `NODE_ENV` | Optional | development | Production: fail-fast |
| `LOG_LEVEL` | Optional | info | |

## Smoke Tests

- [ ] `GET /api/v1/health` → 200
- [ ] `POST /api/v1/security/auth/login` → accessToken
- [ ] `GET /api/v1/security/users` → paginated list (with JWT)
- [ ] `GET /api/v1/docs` → Swagger UI
- [ ] `GET /api/v1/reference/institutions-registry` → 200 (public)
- [ ] SSE stream: `/api/v1/notifications/stream?token=...`
