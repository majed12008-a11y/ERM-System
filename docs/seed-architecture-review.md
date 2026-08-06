# Seed Architecture Review — `ethics_db`

**Task:** RC4 Phase-2 Architecture Review of the seed ecosystem (READ-ONLY)
**Method:** Source-level analysis of all 79 seed files in `backend/seed/`, tracker introspection (`ops.seed_tracker`), catalog checks, and live `count(*)` verification against `ethics_db` (PostgreSQL 18.3, baseline 2026-08-05).
**Scope note:** No files or data modified. `docs/database-population-audit.md`, `docs/database-table-inventory.csv`, `docs/seed-coverage-matrix.md` remain the authoritative population baseline; this report adds the architecture/dependency/quality layer.

---

# 1. Executive Summary

The `backend/seed/` directory is **not a seed suite in the conventional sense — it is a full DDL + data history** of the schema's evolution. 79 SQL files span four distinct epochs:

| Epoch | Files | Nature |
|-------|-------|--------|
| **Demo-era base** | `00`–`10` | Original reference + demo data (KSU, IRB-KSU-01, `APP-2024-*`) |
| **RLS & hardening stack** | `11`–`19`, `22`–`34`, `38`, `40`–`50` | 40+ files of `CREATE POLICY`/`FUNCTION`/`INDEX` — schema evolution, not seeding |
| **Yemen production dataset** | `50`–`54` | Realistic multi-committee dataset (41 institutions, 95+ users, 93 projects, 100+ applications, 1,500+ documents) — the **active** data lineage |
| **Gate-0 & tooling** | `55`–`64`, `90`–`99`, `migration-*` | Forms, document lifecycle/retention/watermark, test datasets, checksum maintenance |

**Key findings:**

1. **Root cause of empty domains is confirmed and is architectural, not accidental.** The demo-era seeds (`06-projects-apps.sql`, `08-reviews.sql`, `09-meetings-etc.sql`) created `APP-2024-001..005`. The production seeds `17-safety-data`, `18-monitoring-data`, `20-remaining-core-data`, `21-committee-expansion`, `28-ethics-risk-assessment`, `29-informed-consent`, `33-accreditation-seed` anchor their `INSERT ... SELECT` to those `APP-2024-*` numbers **and to demo-era usernames** (`researcher1`, `ethics_admin`, `reviewer1..3`, `chairperson`). The current DB contains **zero** of these anchors — only the Yemen-era users/institutions/apps. Every one of those seeds therefore inserts **zero rows while reporting `success`** — a 100% silent no-op class. This is why `safety` (12/12), `monitoring` (10/10), `accreditation_*` (9/9), consent, and ethics-risk are entirely empty.

2. **`ops.seed_tracker` does not prove application.** All 78 tracked seeds report `success` with `duration_ms=0` and identical `applied_at` (2026-08-04) — the tracker was bulk-restored from the Gate-0 baseline dump, not populated by genuine per-seed execution. Its `success` rows are not evidence the data exists.

3. **The tracker is not consulted when it matters.** `00-truncate.sql` wipes 136 tables (including all the demo-era anchors and all Yemen data) but does **not** reset `ops.seed_tracker`. Replaying after a truncate skips everything (`checksum unchanged`), leaving the DB empty. This is the seed-level counterpart of the documented "78 files are not idempotent — `-Force` replay fails on 17 seeds" limitation.

4. **Two parallel, mutually-incompatible data lineages coexist in one directory.** The demo era (anchors `APP-2024-*`, `KSU`, `IRB-KSU-01`) and the Yemen era (anchors `APP-2025-*`/`APP-2026-*`, `NBC_YE`/`SUREC_31`/…) both insert into the same tables with the same column sets. Only the Yemen lineage survives in the DB. Any seed that references demo-era anchors is dead code **against the current baseline** (17, 18, 20, 21, 28, 29, 33, plus the demo-era 06–09 themselves and cross-referencing 90/95/96 partially).

5. **The suite mixes schema DDL and data with no migration discipline.** ~29 files are DDL-only (`CREATE POLICY`/`FUNCTION`/`TABLE`/`INDEX`), 13 are MIXED (both), 31 are DATA, 6 are OTHER (truncate, tracker, data-dictionary, enable-RLS, constraints, checksum-fix). Rollback is impossible; ordering is purely filename-numeric. This matches RC4 gaps **D-01** (adopt migration framework) and **D-02** (align canonical schema with seeds) in `docs/RC4-ARCHITECTURE.md`.

---

# 2. Seed Suite Inventory (79 files)

All 79 files in `backend/seed/`, classified. "Data targets" summarizes the tables each file inserts into (full per-seed target map in `seed_insert_map.csv`).

| # | File | Type | Classification | Data targets (tables) |
|---|------|------|----------------|-----------------------|
| 1 | `00-seed-tracker.sql` | DDL | Infrastructure | `ops.seed_tracker` (schema) |
| 2 | `00-truncate.sql` | OTHER | Destructive reset | truncates 136 tables, no tracker reset |
| 3 | `01-reference.sql` | DATA | Demo-era reference | `security.institution_types`, `reference.*`, institutions |
| 4 | `02-users.sql` | DATA | Demo-era users | `security.roles`, `security.users`, profiles, roles |
| 5 | `03-committees.sql` | DATA | Demo-era committees | `committee.committee_types`, `committee.committees`, members |
| 6 | `04-documents.sql` | DATA | Demo-era doc types | `documents.document_types` |
| 7 | `05-workflow.sql` | DATA | Demo-era workflow | `workflow.workflows`, states, transitions |
| 8 | `06-projects-apps.sql` | DATA | Demo-era projects/apps | `core.projects`, `core.applications` (`APP-2024-001..005`) |
| 9 | `07-workflow-instances.sql` | DATA | Demo-era instances | `workflow.workflow_instances`, actions |
| 10 | `08-reviews.sql` | DATA | Demo-era reviews | `committee.review_assignments`, `committee.review_forms`, scores |
| 11 | `09-meetings-etc.sql` | DATA | Demo-era meetings/comm | `committee.committee_meetings`, agendas, `communication.*` |
| 12 | `10-yemen-institutions.sql` | DATA | Yemen institutions (legacy v1) | `security.institutions`, `security.departments` |
| 13 | `11-rls-fix.sql` | MIXED | RLS hardening | policies/functions + small data |
| 14 | `12-soft-delete.sql` | DDL | Soft-delete infrastructure | 10+ indexes, policies |
| 15 | `13-audit-triggers.sql` | DDL | Audit trigger | trigger creation |
| 16 | `13-data-dictionary.sql` | OTHER | Documentation | comments only |
| 17 | `14-rls-complete.sql` | DDL | RLS policies | 20+ policies |
| 18 | `15-rls-select-policy-fix.sql` | DDL | RLS select fixes | 17 policies |
| 19 | `16-pagination-indexes.sql` | DDL | Indexes | 14 indexes |
| 20 | `16-rls-communication.sql` | DDL | RLS on communication | 30+ policies |
| 21 | `16-rls-enable.sql` | OTHER | RLS enablement | enable row level security |
| 22 | `17-rls-cud-policies.sql` | DDL | CUD policies | 9 policies |
| 23 | `17-safety-data.sql` | DATA | **Silent no-op** | `safety.risk_categories`, `risk_assessments`, `mitigation_actions`, `adverse_events` — all anchored to `APP-2024-*` → 0 rows |
| 24 | `18-audit-fix.sql` | MIXED | Audit fix | function + indexes + small data |
| 25 | `18-monitoring-data.sql` | DATA | **Silent no-op** | `monitoring.monitoring_plans/visits/findings` — anchored to `APP-2024-*` → 0 rows |
| 26 | `19-additional-communication.sql` | DATA | Communication data | `communication.notifications`, templates — partial anchor |
| 27 | `20-remaining-core-data.sql` | DATA | **Silent no-op (large part)** | 28 tables incl. `kpi_results`, `analytics_snapshots`, `workflow_sla/variables`, `tags`, `site_investigators`, `quorum_logs`, `review_conflicts/scores`, `agenda_items`, amendments — most anchored to `APP-2024-*`/demo usernames → 0 rows |
| 28 | `21-committee-expansion.sql` | DATA | Yemen committee (legacy v1) | `committee.committee_types`, committees, members + apps `APP-2024-006..008` (hardcoded, never created by 06) |
| 29 | `22-add-member-roles.sql` | DDL | Roles | `security.roles` rows (guarded) |
| 30 | `23-add-audit-columns.sql` | DDL | Columns | `ALTER TABLE ... ADD COLUMN` |
| 31 | `24-prod-readiness-fixes.sql` | DDL | Indexes/constraints | 19 indexes + constraints |
| 32 | `25-rls-monitoring-reporting.sql` | DDL | RLS monitoring/reporting | policies + 2 functions |
| 33 | `26-reference-data-crud.sql` | MIXED | Reference CRUD | `reference.*` tables + RLS |
| 34 | `27-notification-channel-config.sql` | DDL | Notification config | `communication.notification_channels` table + seed |
| 35 | `28-ethics-risk-assessment.sql` | MIXED | **Silent no-op (data part)** | `committee.ethics_risk_assessments/items` — anchored to `APP-2024-*` → 0 rows |
| 36 | `29-informed-consent.sql` | MIXED | **Silent no-op (data part)** | `committee.consent_templates`, versions, `core.application_consents` — anchored to `APP-2024-*` → 0 rows |
| 37 | `30-rls-ethics-risk.sql` | DDL | RLS | policies on ethics-risk tables |
| 38 | `31-accreditation-schema.sql` | DDL | Accreditation schema | `committee.accreditation_*` tables |
| 39 | `32-accreditation-rls.sql` | DDL | RLS accreditation | 30+ policies/functions |
| 40 | `33-accreditation-seed.sql` | DATA | **Silent no-op (data part)** | `committee.accreditation_standards/versions/cycles` — references committee chairs via demo usernames → 0 rows |
| 41 | `33-fix-register-rls.sql` | MIXED | Registration RLS fix | `security.fn_register_user` (SECURITY DEFINER) + data |
| 42 | `34-documents-insert-rls.sql` | DDL | Documents INSERT RLS | policy |
| 43 | `35-reference-add-statuses.sql` | DATA | Reference statuses | `reference.application_statuses` — partial |
| 44 | `36-workflow-add-states.sql` | DATA | Workflow states | `workflow.workflow_states` — references workflow |
| 45 | `37-workflow-add-transitions.sql` | DATA | Workflow transitions | `workflow.workflow_transitions` |
| 46 | `38-workflow-add-constraints.sql` | OTHER | Constraints | adds workflow constraints |
| 47 | `40-init-workflow-idempotent.sql` | MIXED | Workflow init | `system.fn_init_workflow` + data (idempotent) |
| 48 | `41-application-conditions.sql` | MIXED | Conditions schema | `committee.application_conditions` + RLS + trigger + 1 data row |
| 49 | `42-fix-workflow-init-rls.sql` | DDL | RLS fix | policy |
| 50 | `43-fix-workflow-update-rls.sql` | DDL | RLS fix | policy |
| 51 | `44-fix-terminal-states.sql` | OTHER | Terminal-state fix | data fixes (guarded) |
| 52 | `45-certificates.sql` | MIXED | Certificates schema + template | `documents.approval_certificates` table + `APPROVAL_CERTIFICATE_V1` template — **creates table but inserts ZERO certificate rows** |
| 53 | `46-certificate-rls-hotfix.sql` | DDL | RLS hotfix | function + 2 policies |
| 54 | `47-public-verify-function.sql` | DDL | Public verify | function |
| 55 | `48-notification-source-columns.sql` | DDL | Columns | indexes on notification source columns |
| 56 | `49-notification-preferences.sql` | DDL | Preferences | `communication.notification_preferences` table + RLS |
| 57 | `50-notification-logs-rls-fix.sql` | DDL | RLS fix | policy |
| 58 | `50-yemen-institutions.sql` | DATA | **Yemen institutions v2 (active)** | `security.institutions`, `security.departments` (41 inst, 120+ dept) |
| 59 | `51-accreditation-workflow.sql` | DATA | Accreditation workflow | `workflow.workflows` guarded insert of `ACCREDITATION_CYCLE_V1` — **workflow does not exist in DB despite tracker `success`** |
| 60 | `51-yemen-users.sql` | MIXED | **Yemen users (active)** | `security.users`, profiles, roles, sessions, login_audit (104 inserts) |
| 61 | `52-yemen-projects.sql` | DATA | **Yemen projects (active)** | `core.projects` (885 INSERTs) |
| 62 | `53-yemen-applications.sql` | DATA | **Yemen applications (active)** | `core.applications`, reviews, conditions (1,613 INSERTs) |
| 63 | `54-yemen-documents.sql` | DATA | **Yemen documents (active)** | `documents.*`, `approval_certificates` (1,516 INSERTs; 57 certs) |
| 64 | `55-forms-library.sql` | MIXED | Forms schema + seed | `forms.*` tables + RLS + data |
| 65 | `56-forms-library-templates.sql` | DATA | Forms templates | `forms.templates` data |
| 66 | `57-document-infrastructure.sql` | DDL | Document infra | tables, functions, triggers, policies |
| 67 | `58-gate0-document-lifecycle.sql` | MIXED | Gate-0 lifecycle | `documents.document_lifecycle_states/transitions` + data + `system.fn_*` |
| 68 | `58-official-templates-en.sql` | DATA | Official EN templates | `documents.templates` |
| 69 | `59-gate0-document-rls.sql` | DDL | Gate-0 RLS | 20+ policies + 2 functions |
| 70 | `60-gate0-document-signatures.sql` | MIXED | Signatures | tables + data |
| 71 | `61-gate0-document-audit-signer-rls.sql` | DDL | RLS fix | policy |
| 72 | `62-watermark-engine.sql` | DDL | Watermark | function/policy |
| 73 | `63-document-retention-rules.sql` | DATA | Retention rules | `documents.document_retention_rules` (idempotent) |
| 74 | `64-application-registration.sql` | DATA | **UNTRACKED** Gate-1 Wave-1 | `core.applications` + 3 related (idempotent `ON CONFLICT`) — **not in tracker** |
| 75 | `90-gen-test-data.sql` | DATA | Test data generator | users/apps/adverse_events via `generate_series` |
| 76 | `95-pilot-dataset.sql` | DATA | Pilot dataset | institutions, committees, users, review_forms (55 INSERTs) |
| 77 | `96-realistic-data.sql` | DATA | Realistic dataset | 51 INSERTs across institutions/committees/apps/meetings |
| 78 | `99-fix-checksums.sql` | OTHER | Tracker maintenance | fixes seed tracker checksums |
| 79 | `migration-add-question-options.sql` | DDL | Ad-hoc migration | adds question option columns |

---

# 3. Root Cause Chain (silent no-op seeds)

## 3.1 The anchor graph

The demo-era seeds created a complete anchor graph that later seeds depended on:

```
01-reference  → KSU institution (King Saud University)
02-users      → admin, ethics_admin, chairperson, reviewer1..3, researcher1..2
03-committees → IRB-KSU-01 committee + members
04-documents  → document types
05-workflow   → APP_REVIEW_V1 (only workflow that survived)
06-projects-apps → KSU-RES-2024-001 project + APP-2024-001..005
07-workflow-instances → workflow instances for APP-2024-*
08-reviews    → review assignments/forms for APP-2024-001..003
09-meetings   → meetings, agendas, communication
```

The DB currently contains **none** of the nodes in that graph (verified live: `researcher1`=0, `ethics_admin`=0, `chairperson`=0, `project_code LIKE 'KSU%'`=0, `committee_code='IRB-KSU-01'`=0, `APP-2024-*`=0). Only `admin` survived (re-created/kept by the Yemen lineage), and only `APP_REVIEW_V1` survived from `05-workflow`.

## 3.2 The dead-dependent seeds

Every seed below queries one or more demo-era anchors via `INSERT ... SELECT ... FROM core.applications/security.users/... WHERE application_number='APP-2024-…' OR username='…'`. With zero matching rows, the `SELECT` returns nothing and the `INSERT` inserts nothing — with exit code 0.

| Seed | Anchors it queries | Result in baseline |
|------|--------------------|--------------------|
| `17-safety-data.sql` | `APP-2024-001..005`, `researcher1..2`, `reviewer1..2`, `chairperson`, `ethics_admin`, `IRB-KSU-01` | `safety.*` all 0 rows |
| `18-monitoring-data.sql` | `APP-2024-001..005`, demo users | `monitoring.*` all 0 rows |
| `20-remaining-core-data.sql` | `APP-2024-001..005`, demo users | 24+ of 28 targets 0 rows |
| `21-committee-expansion.sql` | `APP-2024-006..008` (created *by itself* only if `sanaa_researcher1` exists), demo + sanaa users | committee members for demo apps 0 |
| `28-ethics-risk-assessment.sql` | `APP-2024-001..005`, `ethics_admin`, `reviewer1..2` | `committee.ethics_risk_*` 0 rows |
| `29-informed-consent.sql` | `APP-2024-001..005`, `ethics_admin`, `reviewer1..2` | `committee.consent_*`, `core.application_consents` 0 rows |
| `33-accreditation-seed.sql` | `sanaa_chair`, `aden_chair`, `admin` + `accreditation_standard_versions` | `accreditation_*` 0 rows (chairs don't exist) |

## 3.3 Why the tracker lies

The tracker is a SHA-256 checksum ledger (see `scripts/apply-seeds.ps1`): a file is re-applied only when its checksum changes or `-Force` is passed. It is restored wholesale from the Gate-0 baseline dump (all 78 rows `success`, `duration_ms=0`, `applied_at=2026-08-04`). Because the checksums of the no-op seeds match their last-applied state, `apply-seeds.ps1` skips them — the DB remains empty in those domains and the tracker continues to claim `success`.

The checksum ledger therefore records **"this file was applied at some point"**, not **"this file produced data"**. Any verification that relies on `ops.seed_tracker` alone is unsound.

---

# 4. Transaction Wrapping Analysis

`INSERT ... SELECT` chains that span multiple dependent inserts are wrapped in `BEGIN`/`COMMIT` (or are *not* wrapped where they should be). This is a partial-rollback hazard:

- **`17-safety-data.sql`**: 5 `BEGIN`, 1 `COMMIT`. If the `mitigation_actions` DO-block fails (e.g., FK to a `risk_assessment_id` that the 0-row `INSERT ... SELECT` never created), everything is rolled back — consistent with `safety.risk_categories` being 0 **despite** its unconditional inserts.
- **`18-monitoring-data.sql`**: 6 `BEGIN`, 1 `COMMIT` — same profile; all monitoring tables 0.
- **`29-informed-consent.sql`**: 1 `BEGIN`, 1 `COMMIT`, `consent_templates` unconditionally created yet 0 rows — rollback evidence.
- `00`–`10` demo-era files have **no** transaction wrapping (partial writes possible on failure).
- Yemen-era files (`50`–`54`) are each wrapped in a single `BEGIN`/`COMMIT` with `session_replication_role = 'replica'` and `set_config('app.user_id','1')` — correct isolation, but each is a **one-shot, non-idempotent** transaction.

The 1-`BEGIN`/1-`COMMIT` profile is itself a red flag: a single failure rolls back the entire file, so a file that "failed" per psql's `ON_ERROR_STOP` leaves no trace of its intended data — the empty-domain symptom is consistent with **either** silent no-op **or** full-file rollback.

---

# 5. Architecture Assessment

| Dimension | Rating | Evidence |
|-----------|--------|----------|
| **Idempotency** | ✗ Broken (17 seeds fail on `-Force` replay; tracker doesn't survive truncate) | AGENTS.md; `00-truncate.sql` leaves tracker intact |
| **Referential integrity of seed data** | ✓ Pass (0 broken FKs in baseline) | `database-population-audit.md` §1 |
| **Data lineage clarity** | ✗ Two incompatible epochs (demo vs Yemen) with dead cross-references | anchor graph §3.1–3.2 |
| **Rollback** | ✗ None (no down-migrations) | all files are forward-only |
| **Schema/seed alignment** | ✗ Divergence risk (D-02) | base DDL files at repo root + seeds both mutate schema |
| **Fresh-install reproducibility** | ✗ Only via baseline-restore, not via seeds | `reset-dev-db.ps1` + AGENTS.md |
| **Trackability** | ⚠ Partial (checksum ledger, but not execution-validating) | §3.3 |
| **RLS correctness** | ✓ Good (R-03 / R-04 rules preserved; no policy disables row-level security) | seed RLS stack |

## Recommended structural direction (already flagged in RC4-ARCHITECTURE D-01/D-02)

1. **Adopt a migration framework** with up/down pairs; fold the DDL-only seeds into migrations and keep only true reference data as seeds.
2. **Split seed data by reference vs. scenario:** reference/lookup seeds (idempotent, no anchors) vs. scenario seeds (demo, pilot, realistic) that are explicitly labelled and never mixed into production.
3. **Anchor-resolve before insert:** replace hardcoded `APP-2024-*`/username literals with lookups resolved at seed time, and fail loudly when anchors are absent (don't silently insert 0 rows).
4. **Make the tracker execution-honest:** record row counts, and reset it (or require `-Force` with a data wipe) inside `00-truncate.sql`.
