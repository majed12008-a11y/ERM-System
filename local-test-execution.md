# Local Test Execution Guide — RC1.2

> Adapts the [RC1.2 Master Plan](./RC1.2-Integration-UAT-Master-Plan.md) for local (non-Docker) execution.
> The master plan remains the frozen baseline — this file documents local deviations only.

## Environment differences

| Aspect | Plan baseline | Local adaptation |
|--------|---------------|------------------|
| Infrastructure | Docker Compose (3 services) | Direct Node + local PostgreSQL |
| Backend URL | `http://localhost:8080` | Same — no change |
| Frontend URL | `http://localhost` (Nginx :80) | `http://localhost:5173` (Vite dev) |
| Logs | `docker-compose logs backend` | Terminal stdout + `backend/logs/` |
| DB connection | `postgres` user via Docker network | `ethics_app` via `localhost:5432` |
| Service start | `docker-compose up -d` | Terminal 1: `cd backend && npm run dev` |
| | | Terminal 2: `cd frontend && npm run dev` |

## Pre-Execution Checklist (Section 5) — Local versions

Replace the following items:

| ID | Plan check | Local equivalent |
|----|------------|------------------|
| B-06 | Docker image tags | **Skip** — not applicable |
| R-01 | Docker services 3/3 healthy | Verify: terminal shows both servers listening |
| R-07 | `GET http://localhost` → 200 | `GET http://localhost:5173` → 200 |
| R-09 | `docker-compose logs --tail=50` | Check terminal output / `backend-uat.log` |

## Gate 1 — Smoke Test: Local adaptations

### Batch A — Startup (replaces SMK-001–008)

| ID | Local action | Expected |
|----|--------------|----------|
| SMK-001 | Terminal 1: `cd backend && npm run dev` | `Server listening on port 8080` |
| | Terminal 2: `cd frontend && npm run dev` | `Local: http://localhost:5173` |
| SMK-002 | `pg_isready -U ethics_app -d ethics_db -h localhost` | `accepting connections` |
| SMK-003 | `curl -s -o nul -w "%{http_code}" http://localhost:8080/api/v1/` | `200` |
| SMK-004 | `curl -s -o nul -w "%{http_code}" http://localhost:5173/` | `200` |
| SMK-005 | Check backend terminal for `connected` or pool init message | No connection errors |
| SMK-006 | `cd backend && npx node-pg-migrate up` | `Already up to date` (or runs migrations) |
| SMK-007 | `psql -U ethics_app -d ethics_db -c "SELECT COUNT(*) FROM security.users"` | `> 0` |
| SMK-008 | Search terminal / logs for `FATAL` | 0 matches |

### Batch B–D — No changes except URL for SMK-023:

| ID | Change |
|----|--------|
| SMK-023 (accidentally references 80) | Use `http://localhost:5173` for all frontend page actions |

### Pass Criteria — Same targets:
- SMK-P01–P04: 8/8, 10/10, 20/20, 10/10 = 48/48

## Gate 2–6 — No local adaptations needed

All API calls, SQL validations, and UI interactions are identical.
Only change: frontend pages at `http://localhost:5173` instead of `http://localhost`.

## Quick start checklist

```powershell
# 1. Start PostgreSQL (must be running on localhost:5432)

# 2. Apply DDL + seeds (one-time)
psql -U postgres -d ethics_db -f "DDL Script.sql"
psql -U postgres -d ethics_db -f ethics_db_tables.sql
psql -U postgres -d ethics_db -f ethics_db_functions.sql
psql -U postgres -d ethics_db -f ethics_db_tables_constraints.sql
Get-ChildItem backend/seed/*.sql | ForEach-Object { psql -U postgres -d ethics_db -f $_.FullName }

# 3. Start backend (keep running)
cd backend
npm run dev

# 4. Start frontend (separate terminal)
cd frontend
npm run dev

# 5. Run smoke tests (see Gate 1 Batch A–D above)
```
