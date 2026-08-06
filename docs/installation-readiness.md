# Installation Readiness — `ethics_db`

**Task:** RC4 Phase-2 — assess what a fresh environment (or a re-provisioned one) needs to reach the verified Gate-0 baseline, and whether the seed suite alone can produce it.
**Method:** Simulated install-flow analysis from `AGENTS.md`, `apply-seeds.ps1`, `reset-dev-db.ps1`, `backup.ps1`, `docker-compose.yml`, and seed static analysis. **No installation was executed** — this is a read-only capability assessment against the documented commands.

---

# 1. The three installation paths

| Path | Command | Deterministic? | Produces Gate-0 baseline? |
|------|---------|----------------|---------------------------|
| **A. Baseline-restore (recommended)** | `reset-dev-db.ps1` (restores `gate0-baseline-2026-08-04.dump`, then `apply-seeds.ps1` w/o `-Force`, cleans PDFs) | **Yes** | **Yes** (exact) |
| **B. Manual fresh install (documented in AGENTS.md)** | DDL scripts → `apply-seeds.ps1` | **No** | **No** (see §3) |
| **C. Docker compose up** | `docker-compose.yml` (postgres:18-alpine) | **No** (no seed init) | **No** (empty DB) |

---

# 2. Path A — Baseline-restore (the only deterministic path)

**Assets:**
- `backend/backups/gate0-baseline-2026-08-04.dump` (3.43 MB, verified 2026-08-04 23:58).
- `scripts/reset-dev-db.ps1` — restores the dump via `backup.ps1 -Action Restore` (creates a pre-restore safety backup, atomically swaps the database), then applies **new** seeds only (all 78 historical seeds are registered `success` with SHA-256 checksums in the restored tracker, so nothing replays), then removes generated PDFs under `backend/uploads/generated-documents`.

**Why it works despite the suite not being re-runnable:**
- The dump carries the **data and the tracker together** — the tracker's `success` rows for 01–54 are consistent with the dump's content *as captured*, so `apply-seeds.ps1` skips the historical seeds (no replay of the broken 17/18/20/21/28/29/33 class).
- New seeds (added after 2026-08-04) apply incrementally by checksum.
- **Constraint:** a baseline restore is only correct if the dump was captured from the same seed/DDL state as the current `backend/seed` — otherwise checksum mismatches re-run historical seeds. Currently consistent (Gate-0 baseline commit `1fd6a09` matches).

**Verdict: Path A is the production/CI path and is sound.** It is also the only path whose end state is known: 234 tables, 45,453 rows (verified 2026-08-05).

---

# 3. Path B — Manual fresh install (documented, but broken end-to-end)

`AGENTS.md` documents:

```bash
psql -U postgres -d ethics_db -f "DDL Script.sql"      # schemas
psql -U postgres -d ethics_db -f ethics_db_tables.sql  # tables
psql -U postgres -d ethics_db -f ethics_db_functions.sql
psql -U postgres -d ethics_db -f ethics_db_tables_constraints.sql
for f in backend/seed/*.sql; do psql -U postgres -d ethics_db -f "$f"; done
```

## 3.1 What actually exists vs. documented

| Documented file | Reality |
|-----------------|---------|
| `DDL Script.sql` | **Not present** at repo root. Present equivalents: `ethics_db_schema.sql` (661 KB), `schema_only_dump.sql` (1.7 MB), `backup_schema_dump.sql` (705 KB). The three present files split the roles: `ethics_db_tables.sql` (274 KB, tables), `ethics_db_functions.sql` (510 KB, functions/triggers), `ethics_db_tables_constraints.sql` (407 KB, constraints/RLS). |
| `backend/seed/*.sql` | 79 files — but `apply-seeds.ps1` (not the raw loop) is required for tracker consistency; the raw `for` loop would **not** populate `ops.seed_tracker`. |

## 3.2 Simulated fresh-install outcome (all 79 seeds in numeric order on an empty schema)

| Stage | Seeds | Outcome |
|-------|-------|---------|
| Base DDL | 3 root files | Schema/tables/functions/constraints created (234 tables) |
| Tracker | `00-seed-tracker` | `ops.seed_tracker` created |
| Truncate | `00-truncate` | Runs (no-op on empty) — **does not reset tracker** |
| Demo-era base | `01`–`10` | Reference + demo anchors created (`KSU`, `IRB-KSU-01`, `APP-2024-001..005`, demo users) — **this lineage is recreated** |
| RLS stack | `11`–`19` (incl. `17-safety-data`) | Policies/functions + safety inserts — **`17-safety-data` still anchors to `APP-2024-*` which DO exist here**, so safety tables would populate |
| Expansion | `20`–`37` | `20`/`21`/`28`/`29` anchors present → would populate; `36/37` workflow states OK |
| Fixes | `38`–`50` | Structural fixes OK |
| Yemen series | `50`–`54` | **Duplicates** `security.institutions`/`users`/`committees` already created by 01–03/10 (both lineages coexist) → **PK/uniqueness conflicts or data mixing** |
| Gate-0 + test | `55`–`96` | Partial; `90/95/96` read both lineages |
| Fix-checksums | `99` | Tracker repair |

**Result: the manual path produces a HYBRID database** — demo-era AND Yemen-era data mixed in the same tables — not the Gate-0 baseline. `apply-seeds.ps1` without `-Force` would then refuse to replay anything because the tracker already records every file. This matches the documented `-Force` limitation ("fails on 17 seeds", AGENTS.md).

**Verdict: Path B is NOT safe for a fresh environment.** It was the original RC1-era path; it has been superseded by Path A for good reason.

---

# 4. Path C — Docker Compose

- `docker-compose.yml` provisions `postgres:18-alpine` with `POSTGRES_DB: ethics_db`, `POSTGRES_USER: postgres` — but has **no init scripts, no seed volumes, no migration container**. A `docker compose up` yields an **empty database**.
- Backend/frontend containers rely on the DB being pre-seeded (or restored) externally.
- **Verdict:** Path C alone is insufficient; must be combined with Path A (restore the baseline dump into the `pgdata` volume, or run `reset-dev-db.ps1` against the container).

---

# 5. Readiness checklist

| Requirement | Status | Evidence |
|-------------|--------|----------|
| PostgreSQL 18.3 (Windows) or 18-alpine (Docker) | ✓ | live DB + compose file |
| Verified baseline dump available | ✓ | `gate0-baseline-2026-08-04.dump` (3.43 MB) |
| Deterministic restore script | ✓ | `reset-dev-db.ps1` (+ `backup.ps1` Restore) |
| Seed application script with checksum tracking | ✓ | `apply-seeds.ps1` (SHA-256, `-Force`, `-DryRun`) |
| Base DDL scripts present | ⚠ | present but under different names than `AGENTS.md` documents (`DDL Script.sql` missing) |
| Fresh install from seeds only | ✗ | produces hybrid/duplicate state, not baseline |
| Idempotent replay | ✗ | 16 non-idempotent data seeds; `-Force` fails on 17 |
| Tracker integrity on replay | ✗ | truncate doesn't reset tracker; `success` ≠ data present |
| CI reproducibility | ✓ | CI documented to run via restore-based flow (per AGENTS.md e2e) |
| Rollback/migrations | ✗ | none (RC4 D-01 open) |

---

# 6. Recommendations

1. **Make Path A the only documented install** — update `AGENTS.md` to remove the misleading `DDL Script.sql` name and the raw `for` loop seed command (or mark Path B as "historical, do not use").
2. **Rename/align base DDL files** so the documented names exist (`DDL Script.sql` → point to `ethics_db_schema.sql`, or rename the docs).
3. **Add a seed-init hook to docker-compose** (mount a restore job or an init-dir) so `docker compose up` yields a usable DB.
4. **Invest in the migration framework (RC4 D-01)** so fresh installs become `migrate up` + idempotent reference seeds, eliminating Path B's hybrid state entirely.
5. **Keep the Gate-0 dump as the single source of truth** until migrations land; treat the seed suite as an append-only change ledger, not an installer.
