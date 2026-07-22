# Deployment Guide — Ethics ERM System

**Version:** 1.0.0-rc2
**Last Updated:** 2026-07-22

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Repository Structure](#2-repository-structure)
3. [Local Development Setup](#3-local-development-setup)
4. [Docker Compose Deployment](#4-docker-compose-deployment)
5. [Manual Production Deployment](#5-manual-production-deployment)
6. [Environment Variable Reference](#6-environment-variable-reference)
7. [Database Initialization](#7-database-initialization)
8. [Health Checks](#8-health-checks)
9. [Backup and Restore](#9-backup-and-restore)
10. [Troubleshooting](#10-troubleshooting)

---

## 1. Prerequisites

### Required Software

| Software | Version | Purpose |
|----------|---------|---------|
| Node.js | **22+** | Backend runtime, frontend build |
| PostgreSQL | **18+** | Database server |
| npm | 10+ | Package manager (bundled with Node.js) |
| Docker | 24+ | Container deployment (optional) |
| Docker Compose | 2.20+ | Multi-service deployment (optional) |

### Database Client

The backend requires `psql` and `pg_dump` for database operations and backups:

```bash
# Debian/Ubuntu
sudo apt install postgresql-client-18

# macOS
brew install postgresql@18

# Windows (Chocolatey)
choco install postgresql18
```

---

## 2. Repository Structure

```
ethics-erm/                     # npm workspaces monorepo
├── backend/                    # Express 5 + TypeScript (CommonJS)
│   ├── src/                    # Source code
│   │   ├── index.ts            # Entrypoint
│   │   ├── config/             # Database, env, logger
│   │   ├── middleware/          # Auth, validation, error handler
│   │   ├── modules/            # 13 domain modules
│   │   ├── services/           # Business logic
│   ├── seed/                   # 72 SQL seed files
│   ├── Dockerfile              # Multi-stage: node:22-alpine
│   ├── .env                    # Development environment
│   └── package.json
├── frontend/                   # React 19 + Vite 8 + Tailwind 4
│   ├── src/                    # Source code
│   ├── nginx.conf              # Production nginx config
│   ├── Dockerfile              # Multi-stage: node → nginx
│   └── package.json
├── docker-compose.yml          # Full-stack deployment
├── DDL Script.sql              # Schema creation
├── ethics_db_tables.sql        # Table definitions
├── ethics_db_functions.sql     # Database functions
├── ethics_db_tables_constraints.sql  # Constraints
└── package.json                # Root monorepo scripts
```

---

## 3. Local Development Setup

### 3.1 Clone and Install

```bash
git clone <repository-url>
cd ethics-erm
npm install
```

### 3.2 Start PostgreSQL

```bash
# Docker (simplest)
docker run -d --name ethics-pg \
  -e POSTGRES_DB=ethics_db \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  postgres:18-alpine

# Or use existing PostgreSQL installation
```

### 3.3 Initialize Database

```bash
psql -U postgres -d ethics_db -f "DDL Script.sql"
psql -U postgres -d ethics_db -f ethics_db_tables.sql
psql -U postgres -d ethics_db -f ethics_db_functions.sql
psql -U postgres -d ethics_db -f ethics_db_tables_constraints.sql
```

### 3.4 Apply Seed Data

```bash
for f in backend/seed/*.sql; do psql -U postgres -d ethics_db -f "$f"; done
```

### 3.5 Configure Environment

The `backend/.env` file is committed for development. Key variables:

```bash
# Already in .env — verify these match your setup:
DB_HOST=localhost
DB_PORT=5432
DB_NAME=ethics_db
DB_USER=ethics_app        # Create this user or change to 'postgres'
DB_PASSWORD=postgres
JWT_SECRET=<64-char-hex>  # Pre-existing dev secret
PORT=8080
```

### 3.6 Create Database User (if needed)

```sql
CREATE USER ethics_app WITH PASSWORD 'postgres';
GRANT ALL PRIVILEGES ON DATABASE ethics_db TO ethics_app;
GRANT ALL ON SCHEMA public TO ethics_app;
GRANT ALL ON SCHEMA core TO ethics_app;
GRANT ALL ON SCHEMA security TO ethics_app;
GRANT ALL ON SCHEMA committee TO ethics_app;
GRANT ALL ON SCHEMA workflow TO ethics_app;
GRANT ALL ON SCHEMA documents TO ethics_app;
GRANT ALL ON SCHEMA communication TO ethics_app;
GRANT ALL ON SCHEMA safety TO ethics_app;
GRANT ALL ON SCHEMA reporting TO ethics_app;
GRANT ALL ON SCHEMA system TO ethics_app;
GRANT ALL ON SCHEMA templates TO ethics_app;
GRANT ALL ON SCHEMA ethics_risk TO ethics_app;
GRANT ALL ON SCHEMA reference TO ethics_app;
```

### 3.7 Start Development Servers

```bash
# Start both backend and frontend
npm run dev
```

This runs:
- Backend: `http://localhost:8080` (tsx watch with hot reload)
- Frontend: `http://localhost:5173` (Vite dev server, proxies /api → :8080)

### 3.8 Verify

```bash
# Run all quality checks
npm run verify

# Or individually:
npm run lint              # Backend type-check + frontend ESLint
npm test                  # Backend + frontend tests
npm run build             # Production build
```

---

## 4. Docker Compose Deployment

### 4.1 Set Required Environment Variables

```bash
export DB_PASSWORD="<strong-password>"
export JWT_SECRET="<random-string-at-least-32-chars>"
```

### 4.2 Start Services

```bash
docker compose up -d
```

This starts three services:

| Service | Image | Port | Health Check |
|---------|-------|------|-------------|
| `postgres` | `postgres:18-alpine` | `127.0.0.1:5432` | `pg_isready` |
| `backend` | `./backend` (built) | `8080` | `GET /api/v1/monitoring/health` |
| `frontend` | `./frontend` (built) | `80` | `GET /` |

### 4.3 Service Dependencies

```
postgres (healthy) → backend (healthy) → frontend
```

### 4.4 Volumes

| Volume | Purpose |
|--------|---------|
| `pgdata` | PostgreSQL data persistence |
| `backups` | Database backup storage |
| `uploads` | Uploaded file storage |

### 4.5 Initialize Database (Docker)

The DDL files are automatically mounted as init scripts:

```
DDL Script.sql              → /docker-entrypoint-initdb.d/01-ddl.sql
ethics_db_tables.sql        → /docker-entrypoint-initdb.d/02-tables.sql
ethics_db_functions.sql     → /docker-entrypoint-initdb.d/03-functions.sql
ethics_db_tables_constraints.sql → /docker-entrypoint-initdb.d/04-constraints.sql
```

Seed data must be applied manually after the database is running:

```bash
docker compose exec postgres sh -c '
  for f in /docker-entrypoint-initdb.d/*.sql; do
    psql -U postgres -d ethics_db -f "$f"
  done
'
```

Or from the host:

```bash
for f in backend/seed/*.sql; do
  PGPASSWORD=$DB_PASSWORD psql -U postgres -h localhost -d ethics_db -f "$f"
done
```

### 4.6 View Logs

```bash
docker compose logs -f backend
docker compose logs -f postgres
```

### 4.7 Stop Services

```bash
docker compose down          # Stop (preserve data)
docker compose down -v       # Stop AND delete volumes (destroys data)
```

---

## 5. Manual Production Deployment

### 5.1 Build Backend

```bash
cd backend
npm ci --omit=dev
npm run build               # Compiles TypeScript to dist/
```

### 5.2 Build Frontend

```bash
cd frontend
npm ci --omit=dev
npm run build               # tsc -b && vite build → dist/
```

### 5.3 Serve Frontend

The frontend production build requires a static file server with API proxy. Use the provided `nginx.conf` as a reference:

```nginx
server {
    listen 80;
    root /app/frontend/dist;
    index index.html;

    location /api/ {
        proxy_pass http://localhost:8080/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

### 5.4 Start Backend

```bash
cd backend
NODE_ENV=production node dist/index.js
```

### 5.5 Production Environment Variables

Minimum required:

```bash
NODE_ENV=production
DB_HOST=<db-host>
DB_PORT=5432
DB_NAME=ethics_db
DB_USER=<db-user>
DB_PASSWORD=<strong-password>
JWT_SECRET=<random-string-at-least-32-chars>
DB_ENCRYPTION_KEY=<random-string-at-least-32-chars>  # Required in production
```

**Important:** In production mode, the application will `process.exit(1)` if required environment variables are missing or invalid.

---

## 6. Environment Variable Reference

### Required Variables

| Variable | Type | Description |
|----------|------|-------------|
| `DB_PASSWORD` | string | PostgreSQL password |
| `JWT_SECRET` | string (min 32 chars) | HS256 signing key for JWTs |
| `DB_ENCRYPTION_KEY` | string (min 32 chars) | Data encryption key (required in production) |

### Database Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_HOST` | `localhost` | PostgreSQL host |
| `DB_PORT` | `5432` | PostgreSQL port |
| `DB_NAME` | `ethics_db` | Database name |
| `DB_USER` | `ethics_app` | Database user |
| `DB_SSL` | `false` | Enable SSL connection |
| `DB_SSL_REJECT_UNAUTHORIZED` | `true` | Reject self-signed SSL certs |
| `DB_STATEMENT_TIMEOUT` | `30000` | Query timeout (ms) |
| `DB_IDLE_TX_TIMEOUT` | `60000` | Idle transaction timeout (ms) |
| `DATABASE_URL` | `''` | Connection URL (overrides individual vars) |

### Server Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `3000` (code) / `8080` (.env) | Server listen port |
| `NODE_ENV` | `development` | Environment mode |
| `LOG_LEVEL` | `info` | Pino log level |
| `CORS_ORIGIN` | `http://localhost:5173` | Allowed CORS origins |
| `FRONTEND_URL` | `http://localhost:5173` | Frontend base URL |
| `TRUST_PROXY` | `1` | Express trust proxy setting |

### Rate Limiting Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `RATE_LIMIT_GLOBAL_MAX` | `60` | Global requests per minute |
| `RATE_LIMIT_AUTH_WINDOW_MS` | `60000` | Auth rate limit window (ms) |
| `RATE_LIMIT_LOGIN_MAX` | `10` | Login attempts per window |
| `RATE_LIMIT_REGISTER_MAX` | `5` | Registration attempts per window |
| `RATE_LIMIT_FORGOT_MAX` | `3` | Forgot-password attempts per window |
| `RATE_LIMIT_REFRESH_MAX` | `10` | Token refresh attempts per window |
| `RATE_LIMIT_RESET_PASSWORD_MAX` | `5` | Password reset attempts per window |
| `RATE_LIMIT_RESEND_VERIFICATION_MAX` | `5` | Resend verification attempts per window |

### SMTP Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `SMTP_HOST` | `localhost` | SMTP server host |
| `SMTP_PORT` | `587` | SMTP server port |
| `SMTP_SECURE` | `false` | Use TLS |
| `SMTP_USER` | `''` | SMTP username |
| `SMTP_PASS` | `''` | SMTP password |
| `SMTP_FROM` | `noreply@ethics.erc.gov.sa` | Sender email address |

### Backup Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `BACKUP_DIR` | `backups` | Backup storage directory |
| `BACKUP_RETENTION_DAILY` | `7` | Daily backup retention count |
| `BACKUP_RETENTION_WEEKLY` | `4` | Weekly backup retention count |
| `BACKUP_RETENTION_MONTHLY` | `3` | Monthly backup retention count |
| `BACKUP_SCHEDULE_CRON` | `0 2 * * *` | Backup cron schedule |
| `BACKUP_SCHEDULE_ENABLED` | `false` | Enable scheduled backups |
| `BACKUP_DESTINATION_TYPE` | `local` | `local` or `s3` |
| `BACKUP_S3_ENDPOINT` | `''` | S3-compatible endpoint |
| `BACKUP_S3_BUCKET` | `''` | S3 bucket name |
| `BACKUP_S3_REGION` | `''` | S3 region |
| `BACKUP_S3_ACCESS_KEY` | `''` | S3 access key |
| `BACKUP_S3_SECRET_KEY` | `''` | S3 secret key |

### Argon2 Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `ARGON2_MEMORY_COST` | `65536` | Memory cost (KiB) |
| `ARGON2_TIME_COST` | `3` | Time cost (iterations) |
| `ARGON2_PARALLELISM` | `4` | Parallelism degree |

---

## 7. Database Initialization

### Schema Creation Order

The database schema must be created in this exact order:

```bash
# Step 1: Create schemas and base structure
psql -U postgres -d ethics_db -f "DDL Script.sql"

# Step 2: Create all tables
psql -U postgres -d ethics_db -f ethics_db_tables.sql

# Step 3: Create database functions
psql -U postgres -d ethics_db -f ethics_db_functions.sql

# Step 4: Add constraints and indexes
psql -U postgres -d ethics_db -f ethics_db_tables_constraints.sql
```

### Seed Data Order

Seeds in `backend/seed/` are applied in numeric order (00 through 99). They are **not** idempotent unless noted.

```bash
for f in backend/seed/*.sql; do
  psql -U postgres -d ethics_db -f "$f"
done
```

### Key Seed Files

| File | Purpose | Idempotent |
|------|---------|-----------|
| `00-seed-tracker.sql` | Seed tracking table | Yes |
| `00-truncate.sql` | Clean all data (DANGEROUS) | Yes |
| `01-reference.sql` | Reference data (countries, etc.) | No |
| `02-users.sql` | Users, roles, permissions | No |
| `03-committees.sql` | Committee types and members | Partial |
| `04-documents.sql` | Document types and templates | No |
| `05-workflow.sql` | Workflow definitions and states | No |
| `33-fix-register-rls.sql` | RLS fix for registration | Yes |
| `34-documents-insert-rls.sql` | RLS fix for documents | Yes |

---

## 8. Health Checks

### Monitoring Endpoints

All health endpoints are unauthenticated and bypass rate limiting:

```bash
# Liveness probe (is the server running?)
curl http://localhost:8080/api/v1/monitoring/live

# Readiness probe (is the database reachable?)
curl http://localhost:8080/api/v1/monitoring/ready

# Detailed health status
curl http://localhost:8080/api/v1/monitoring/health

# System metrics
curl http://localhost:8080/api/v1/monitoring/metrics
```

### Docker Health Check

The backend Dockerfile includes a health check:

```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget -qO- http://localhost:8080/api/v1/monitoring/health || exit 1
```

### Verifying Full Stack

```bash
# 1. Check database
psql -U postgres -d ethics_db -c "SELECT 1"

# 2. Check backend
curl -s http://localhost:8080/api/v1/monitoring/ready | jq .

# 3. Check frontend
curl -s -o /dev/null -w "%{http_code}" http://localhost:5173

# 4. Check authentication
curl -s -X POST http://localhost:8080/api/v1/security/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' | jq .
```

---

## 9. Backup and Restore

### Manual Backup

```bash
pg_dump -U postgres -Fc -f backup_$(date +%Y%m%d_%H%M%S).dump ethics_db
```

### Restore from Backup

```bash
pg_restore -U postgres -d ethics_db --clean --if-exists backup.dump
```

### Application-Level Backup

The system provides backup management via the admin API:

```bash
# Create backup
curl -X POST http://localhost:8080/api/v1/admin/backup \
  -H "Authorization: Bearer <token>"

# List backups
curl http://localhost:8080/api/v1/admin/backup \
  -H "Authorization: Bearer <token>"

# Restore
curl -X POST http://localhost:8080/api/v1/admin/backup/<name>/restore \
  -H "Authorization: Bearer <token>"
```

---

## 10. Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|---------|
| `ECONNREFUSED 5432` | PostgreSQL not running | Start PostgreSQL or check `DB_HOST`/`DB_PORT` |
| `password authentication failed` | Wrong credentials | Check `DB_USER`/`DB_PASSWORD` in `.env` |
| `JWT_SECRET is required` | Missing or short secret | Set `JWT_SECRET` to a string ≥ 32 characters |
| `relation "X" does not exist` | Schema not initialized | Run database initialization SQL files |
| `Rate limit exceeded` | Too many requests | Wait 60 seconds or adjust `RATE_LIMIT_GLOBAL_MAX` |
| `Access token required` | Using refresh token as access | Use the `accessToken` from login response |
| Port 8080 already in use | Another process on port | Change `PORT` in `.env` or stop the other process |

### Logs

```bash
# Backend logs (structured JSON in production)
docker compose logs backend

# Pretty-printed logs in development
# (handled automatically by pino-pretty)
```

### Reset Development Environment

```bash
# Drop and recreate database
psql -U postgres -c "DROP DATABASE IF EXISTS ethics_db"
psql -U postgres -c "CREATE DATABASE ethics_db"

# Re-run initialization
psql -U postgres -d ethics_db -f "DDL Script.sql"
psql -U postgres -d ethics_db -f ethics_db_tables.sql
psql -U postgres -d ethics_db -f ethics_db_functions.sql
psql -U postgres -d ethics_db -f ethics_db_tables_constraints.sql

# Re-apply seeds
for f in backend/seed/*.sql; do psql -U postgres -d ethics_db -f "$f"; done
```
