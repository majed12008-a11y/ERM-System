# RC4 Seed Ecosystem — Final Assessment

**Deliverable 8/8** — synthesis of the RC4 Phase-2 (READ-ONLY) seed architecture review.
**Scope:** 79 seed files in `backend/seed`, 234-table `ethics_db`, verified against the 2026-08-05 baseline snapshot (45,453 rows).
**Rule compliance:** No schema/data/seed/doc modification; no commits; analysis only.

---

# 1. What the ecosystem IS

A **79-file, numerically-ordered, psql-executed append-only change ledger**, tracked in `ops.seed_tracker` (SHA-256 checksums), applied by `scripts/apply-seeds.ps1`. It spans two architectural eras:

- **Era 1 (demo, seeds 01–49):** reference data, demo users/institutions, RLS stack, workflow states, safety/monitoring/ethics-risk data, accreditation. Anchored on `APP-2024-*`, `KSU`, demo usernames.
- **Era 2 (Yemen, seeds 50–54):** the current demo dataset — 41 institutions, 106 users, `APP-2025-*` (28) and `APP-2026-*` (84) applications, 57 approval certificates.
- **Era 3 (Gate-0+, seeds 55–99):** idempotent, guarded, high-quality infrastructure (document lifecycle, RLS, forms library, retention rules).

The current DB contains **only Era-2 + Era-3 output**. Era-1 data was wiped by `00-truncate`/reset and its anchors are absent — yet the tracker still lists Era-1 seeds as `success` (bulk-restored with the baseline dump, `duration_ms=0`).

# 2. What is healthy

1. **Resulting data integrity** — 0 broken foreign keys across 45,453 rows; RLS never disabled (AGENTS.md invariant honored); all `SECURITY DEFINER` workarounds contained and verified.
2. **No UUID literals** — all references resolve via `SELECT...INTO`/`INSERT...SELECT` (good practice, despite §4's NULL-variable trap).
3. **Era-3 quality** — seeds 40, 55–64 demonstrate the correct idioms (`ON CONFLICT DO NOTHING RETURNING id`, `IF NOT EXISTS`, `DROP...IF EXISTS`, anchor guards). The suite's quality improves monotonically with file number.
4. **Deterministic restore path** — `reset-dev-db.ps1` + `gate0-baseline-2026-08-04.dump` is the single reproducible way to reach the verified baseline (commit `1fd6a09`).

# 3. What is broken (prioritized)

| # | Severity | Defect | Seeds |
|---|----------|--------|-------|
| 1 | **Critical** | Silent no-op: `INSERT...SELECT` anchored on dead `APP-2024-*`/demo users yields 0 rows yet tracker says `success` | 17, 18, 20, 21, 28, 29, 33 |
| 2 | **Critical** | Tracker `success` is bulk-restored, not per-file execution evidence (`duration_ms=0`, identical `applied_at`) — `success` ≠ data present | all 78 |
| 3 | **High** | Full-file rollback masked: NOT-NULL FK chain (`mitigation_actions.risk_assessment_id`) aborts the whole seed's transaction, including unconditional inserts — proves `risk_categories`=0 despite unconditional insert | 17, 18, 29 |
| 4 | **High** | Fresh-install path (documented in AGENTS.md) is broken: `DDL Script.sql` missing; raw seed loop creates a **hybrid** demo+Yemen database, not the baseline | all, esp. 50–54 |
| 5 | **Medium** | 16 non-idempotent data seeds; `-Force` replay fails on 17 files | 01–10, 17–21, 28, 29, 35–37 |
| 6 | **Medium** | `00-truncate` doesn't reset the tracker → truncate+replay silently skips everything | 00, apply-seeds |
| 7 | **Low** | Seed 21 self-references `APP-2024-006..008` (creates them only if `sanaa_researcher1` exists) | 21 |

# 4. The single root cause

**Era-1 seeds were written as a linear script against a specific historical DB state, but are now treated as a versioned ledger.** When the dataset pivoted to the Yemen lineage, the old anchors died; the tracker (restored with the dump) still claims Era-1 ran. Any analysis that trusts either the tracker or the seed files alone is wrong — only row counts tell the truth.

# 5. Recommendation — decision for the project

**Adopt the baseline-restore + migration model (RC4 D-01) as the ONLY install/change mechanism.**

- **Now:** keep `gate0-baseline-2026-08-04.dump` as the single source of truth; treat seeds 01–54 as historical ledger (documented, not re-runnable); new changes arrive only as Era-3-style idempotent seeds applied by `apply-seeds.ps1`.
- **Transition:** repair or retire the 7 dead-anchor seeds (17, 18, 20, 21, 28, 29, 33) — repoint to Yemen anchors or convert to idempotent reference-only.
- **Target:** a proper migration framework (`migrate up`), with the seed suite reduced to (a) idempotent reference seeds and (b) scenario fixtures, executed deterministically — eliminating the hybrid-install and tracker-masking failure classes entirely.

# 6. Deliverables produced (RC4 Phase-2)

| # | File | Content |
|---|------|---------|
| 1 | `docs/seed-architecture-review.md` | architecture, lineages, tracker mechanics (Parts 1, 3) |
| 2 | `docs/table-classification.md` | 234-table taxonomy + coverage (Part 2) |
| 3 | `docs/feature-data-coverage.md` | 17-module coverage matrix (Part 4) |
| 4 | `docs/backend-table-usage.md` | backend usage vs. seed coverage (Part 5) |
| 5 | `docs/seed-dependency-graph.md` | per-seed dependency graph (Part 1) |
| 6 | `docs/seed-quality-report.md` | idempotency/anchors/transactions/tracker (Part 6) |
| 7 | `docs/installation-readiness.md` | fresh-install simulation, 3 paths (Part 7) |
| 8 | **this file** | synthesis & recommendation (Part 8) |

All 8 documents cross-reference the verified artifacts `docs/database-population-audit.md`, `docs/database-table-inventory.csv`, `docs/seed-coverage-matrix.md`+`.csv` and the temp CSVs (`seed_insert_map.csv`, `backend_usage.csv`).
