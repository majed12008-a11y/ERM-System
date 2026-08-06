# Seed Quality Report — `backend/seed`

**Task:** RC4 Phase-2 — quality assessment of the 79 seed files across idempotency, anchoring, transactions, hardcoded values, and silent-failure behavior.
**Method:** Programmatic static analysis of every file (`seed_analysis.csv`, 12 attributes per seed) + targeted DB verification. No files or data modified.

---

# 1. Overall quality verdict

**Rating: FAIL on reproducibility / idempotency; PASS on referential integrity of the resulting dataset.**

| Quality dimension | Grade | Summary |
|-------------------|-------|---------|
| Idempotency (re-runnable) | **F** | 16 non-idempotent data seeds; `-Force` replay fails on 17 files (AGENTS.md) |
| Fresh-install determinism | **F** | Two incompatible lineages; only baseline-restore is reproducible |
| Anchor integrity (foreign-key inputs) | **F** | 8 seeds reference dead `APP-2024-*`/demo users → silent 0-row inserts |
| Transaction safety | **D** | Mismatched BEGIN/COMMIT counts; no exception handling; partial/full rollback ambiguity |
| Hardcoded literal hygiene | **D** | ~18 seeds hardcode usernames/committee codes/app numbers |
| Idempotent mechanism adoption | **B** | 57/79 have guards; newer seeds (40,55–64) consistently idempotent |
| Data referential integrity (result) | **A** | 0 broken FKs in the baseline (45,453 rows) |
| RLS correctness | **A** | No `DISABLE ROW LEVEL SECURITY`; all fixes within RLS (AGENTS.md rules) |

---

# 2. Idempotency analysis

## 2.1 Mechanisms in use

| Mechanism | Seeds using it | Example |
|-----------|---------------|---------|
| `ON CONFLICT` | 16 | `64-application-registration.sql` (all 5 inserts) |
| `IF NOT EXISTS` | 23 | `55/56-forms-library*`, `57-document-infrastructure` |
| `DROP ... IF EXISTS` | 24 | `59-gate0-document-rls`, `61/62-*` |
| `WHERE NOT EXISTS (...)` guard | 33 | `51-accreditation-workflow`, `54-yemen-documents`, `58-gate0-lifecycle` |

## 2.2 Non-idempotent data seeds (16) — re-run duplicates or fails

All are plain `INSERT ... VALUES`/`INSERT ... SELECT` without conflict handling. A `-Force` replay against a populated DB either duplicates rows (no unique constraint) or trips unique/PK violations.

| Seed | Inserts | On re-run |
|------|--------:|-----------|
| `01-reference.sql` | 13 | duplicates reference/institutions |
| `02-users.sql` | 23 | PK violation (usernames exist) |
| `04-documents.sql` | 1 | duplicates doc types |
| `05-workflow.sql` | 3 | duplicates workflow def |
| `06-projects-apps.sql` | 8 | PK violation (app numbers) |
| `07-workflow-instances.sql` | 19 | duplicates instances |
| `08-reviews.sql` | 20 | duplicates reviews |
| `09-meetings-etc.sql` | 29 | duplicates meetings/comm |
| `10-yemen-institutions.sql` | 28 | duplicates institutions |
| `17-safety-data.sql` | 36 | FK/NOT-NULL failure (no anchors) or duplicate |
| `18-monitoring-data.sql` | 28 | same |
| `19-additional-communication.sql` | 13 | duplicates notifications |
| `20-remaining-core-data.sql` | 77 | duplicates across 28 tables |
| `33-fix-register-rls.sql` | 1 | duplicates the register-user function? (guarded) |
| `36-workflow-add-states.sql` | 5 | duplicates states |
| `37-workflow-add-transitions.sql` | 18 | duplicates transitions |

> `00-truncate.sql` is the intended "make it re-runnable" tool, but it does **not** reset `ops.seed_tracker` — so a truncate + replay silently skips everything (all checksums unchanged). The truncate/tracker pair is broken as a replay mechanism.

## 2.3 Idempotent-by-construction newer seeds (the good pattern)

`40-init-workflow-idempotent` (`ON CONFLICT DO NOTHING RETURNING id`), `55/56-forms-library*`, `58-gate0-*`, `60/61/62/63-*`, `64-application-registration` — these demonstrate the correct idiom and were the pattern for the Gate-0 baseline. **The suite's quality improves monotonically with file number**; the legacy 01–37 block is where the defects concentrate.

---

# 3. Anchor integrity (the silent no-op class)

## 3.1 Hardcoded anchors by seed

**18 seeds hardcode usernames/committee codes/app numbers** (full data in `seed_analysis.csv`):

- **Usernames** (16 seeds): `02,03,06,07,08,09,17,18,19,20,21,28,29,33,95,96` — e.g. `admin`, `ethics_admin`, `chairperson`, `reviewer1..3`, `researcher1..2`, `aden_*`, `sanaa_*`, `bio.rev1..5`.
- **Committee codes** (8 seeds): `IRB-KSU-01` (03,06,08,09,17), `IRB-SANAA-01` (21), Yemen codes `SUREC_31/AUREC_32/NBC_YE/SHEC_26/TRC_33/NSRB_4/NRC_YE/NMEC_YE` (53), `NCBE-YE-001/SANAA-IRB-001/THAWRA-IRB-001` (95).
- **Application numbers** (11 seeds): `APP-2024-001..009` (06,07,08,09,17,18,20,21,28,29) and `APP-2025-*`/`APP-2026-*` (53,54).

## 3.2 Why the 2024 anchors are dead

| Anchor | Created by | Present in DB? |
|--------|-----------|---------------:|
| `APP-2024-001..005` | `06-projects-apps` | **0** |
| `APP-2024-006..008` | `21-committee-expansion` (self-referencing) | **0** |
| `researcher1`/`researcher2` | `02-users` | **0** |
| `ethics_admin`, `chairperson`, `reviewer1..3` | `02-users` | **0** |
| `sanaa_chair`, `aden_chair` | `21-committee-expansion` | **0** |
| `KSU` institution, `IRB-KSU-01` committee | `01`/`03` | **0** |

Only `admin` (recreated by the Yemen lineage) and `APP_REVIEW_V1` workflow survive. Every seed that reads these anchors is dead code against the current baseline:

| Seed | Reads (absent) anchors | Result |
|------|------------------------|--------|
| `17-safety-data` | `APP-2024-001..005`, `researcher1..2`, `reviewer1..2`, `chairperson`, `ethics_admin` | `safety.*` = 0 rows |
| `18-monitoring-data` | `APP-2024-001..005`, demo users | `monitoring.*` = 0 rows |
| `20-remaining-core-data` | `APP-2024-001..005`, demo users | 24+/28 targets = 0 rows |
| `21-committee-expansion` | `APP-2024-006..008` + `sanaa_researcher1` | committee members for those apps = 0 |
| `28-ethics-risk-assessment` | `APP-2024-001..005`, `ethics_admin`, `reviewer1..2` | `ethics_risk_*` = 0 rows |
| `29-informed-consent` | `APP-2024-001..005`, `ethics_admin`, `reviewer1..2` | `consent_*` = 0 rows |
| `33-accreditation-seed` | `sanaa_chair`, `aden_chair` | `accreditation_*` = 0 rows |

## 3.3 No UUID literals anywhere

**0 UUID literals across all 79 files.** Good practice — all ID references resolve via `SELECT ... INTO` or `INSERT ... SELECT`. The problem is not UUIDs but the **anchored-by-business-key** pattern (`WHERE username='...'`/`application_number='...'`) which silently yields NULL/empty when the key is absent.

---

# 4. Transaction safety

## 4.1 BEGIN/COMMIT profile

- **39 seeds use transactions**; all top-level `BEGIN;`/`COMMIT;` pairs match 1:1 at file level.
- **Hidden imbalance in no-op seeds**: `17-safety-data` has **4 `DO $$...$$` blocks** inside its single transaction (BEGIN at lines 7, 64, 135, 195, 226). The 4 DO-blocks are PL/pgSQL blocks, not transactions — but each performs `SELECT ... INTO v_x FROM ... WHERE username='...'` with **no `EXCEPTION`/`IS NULL` guard**. When the SELECT returns nothing, `v_x` is NULL.
- **Verified NOT-NULL trap**: `safety.mitigation_actions.risk_assessment_id` is `NOT NULL` and `safety.risk_assessments.application_id` is `NOT NULL`. In `17-safety-data`, the mitigation_actions DO-block inserts `v_assessment1` (NULL, since the risk_assessments `INSERT...SELECT` no-op'd). This raises a **NOT NULL violation**, which aborts the whole file's transaction — **including the unconditional `safety.risk_categories` inserts**. That is the definitive mechanism behind `risk_categories` = 0 despite its unconditional `INSERT`.

## 4.2 Implications

- A no-op seed does **not** necessarily exit 0: it can **raise and roll back everything** (17, 18, 20, 29). Either way the tracker reports `success` if the tracker was bulk-restored (see §5), masking the failure.
- **Fix pattern**: guard each DO-block with `IF v_x IS NULL THEN RAISE EXCEPTION 'anchor missing'` or `RETURN`, and/or use `ON CONFLICT`. Newer seeds (40/55–64) already follow this discipline.

---

# 5. Tracker integrity

| Property | Observed | Meaning |
|----------|----------|---------|
| `ops.seed_tracker` rows | 78 (all `success`) | every seed "applied" |
| `duration_ms` | **0 for all 78** | not genuine execution timings |
| `applied_at` | identical (2026-08-04) for all | bulk-restored from baseline dump |
| Checksum column | SHA-256 per file | the only honest field |

**Conclusion:** the tracker's `success` is a bulk-restored record, not per-seed execution evidence. Combined with §3/§4, **tracker `success` ≠ data present**. Any report that cites `ops.seed_tracker` as proof of seeding is unsound. The only reliable proof is row counts (this package uses the 2026-08-05 baseline `count(*)` snapshot).

---

# 6. Silent-failure risk inventory

| Risk class | Seeds | Evidence |
|-----------|-------|----------|
| Silent no-op (0 rows, exit 0) | 17, 18, 20, 21, 28, 29, 33 | `INSERT...SELECT` with absent anchors; confirmed 0 rows in DB |
| Full-file rollback (exit≠0 masked) | 17, 18, 29 (NOT-NULL chain) | `mitigation_actions.risk_assessment_id NOT NULL`; unconditional inserts also 0 |
| Transaction-wrapped non-idempotent | 01–10 (no TX), 17–21, 36–37, 50–54 | `-Force` replay duplicates/fails |
| Self-referencing hardcoded numbers | 21 (`APP-2024-006..008` created only if `sanaa_researcher1` exists) | creates data only on one exact historical state |
| Tracker-restore masking | all 78 | `success` without execution |
| Truncate-without-tracker-reset | 00-truncate + apply-seeds | replay silently skips all |

---

# 7. Quality improvements recommended

1. **Add anchor guards to all `INSERT...SELECT`/DO-block seeds** — `IF NOT FOUND THEN RAISE EXCEPTION 'anchor missing'`; convert silent no-ops into loud failures (aligns with `apply-seeds.ps1` `ON_ERROR_STOP=1` philosophy).
2. **Add `ON CONFLICT`/`WHERE NOT EXISTS` to the 16 non-idempotent data seeds**, or split them into reference (idempotent) vs. scenario (one-shot) buckets.
3. **Reset `ops.seed_tracker` inside `00-truncate.sql`** so a truncate + replay actually replays (or document that truncate is only safe before a baseline-restore).
4. **Track row counts in `ops.seed_tracker`** (`rows_affected`) so a 0-row insert is recorded as suspicious, not `success`.
5. **Remove or repoint the 7 dead-anchor seeds** (17,18,20,21,28,29,33) to the Yemen dataset anchors (`APP-2025-*`/`APP-2026-*`, existing Yemen users/committees).
