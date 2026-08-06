# Architecture Normalization Review — Seed Ecosystem

**Task:** RC4 follow-up — a READ-ONLY architecture investigation of the entire seed ecosystem, before any individual-file fixes.
**Scope:** 79 seed files in `backend/seed`, 234-table `ethics_db`, verified baseline snapshot of 2026-08-05 (45,453 rows).
**Compliance:** No SQL, schema, migration, seed, documentation, or code was modified. No commits. This is a documentation-only deliverable.

**Companion artifacts:**
- `docs/architecture-normalization-tables.csv` — per-table taxonomy (234 rows: category + seeding policy)
- `docs/architecture-normalization-seeds.csv` — per-seed architectural role (79 rows)
- Prior verified deliverables (referenced, not duplicated): `database-population-audit.md`, `database-table-inventory.csv`, `seed-coverage-matrix.md`+`.csv`, `seed-quality-report.md`, `installation-readiness.md`

---

# Executive summary

The seed ecosystem is architecturally a **linear append-only change ledger** that is being used as if it were an **installer**. The numeric-prefix sequence conflates three independent dimensions — *schema evolution*, *data provisioning*, and *environment scenario* — into a single ordering. This conflation, not any individual broken file, is the root cause of the failures already documented in the RC4 Phase-2 reports.

Headline findings of this review:

| # | Finding | Evidence |
|---|---------|----------|
| F1 | 33/79 seeds carry silent-no-op risk (anchored reads that can yield 0 rows without error) | `seed_analysis.csv` `SilentNoOpRisk` column |
| F2 | 13/79 files are MIXED-responsibility (DDL + RLS + data in one file) | Type distribution: 31 DATA / 29 DDL / 13 MIXED / 6 OTHER |
| F3 | 9 numeric-prefix collision groups make ordering semantically ambiguous | prefixes 00, 13, 16, 17, 18, 33, 50, 51, 58 |
| F4 | Two incompatible data lineages (demo Era-1, Yemen Era-2) plus pilot (95) and realistic (96) fixtures coexist in one sequence | dependency edges + `seed_insert_map.csv` |
| F5 | Audit/history/queue tables are populated by direct fixture INSERTs — violating their own "runtime-generated" nature | 12,852 audit_details; 459 application_history; 36 document_versions |
| F6 | Data seeds (01–10) run **before** RLS migrations (11–17) — layer-order inversion on any fresh install | numeric sequence |
| F7 | The canonical dataset must be the **Yemen lineage as captured in the Gate-0 baseline dump** — the only fully-present, reproducible lineage | §3 |

---

# Section 1 — Table taxonomy (complete, 234 tables)

Every table was classified into the requested category set. Full per-table detail (including row counts, backend usage, and seed coverage) is in `docs/architecture-normalization-tables.csv`; this section defines the categories and summarizes the distribution.

## 1.1 Category definitions and distribution

| Category | Tables | Definition / scope |
|----------|-------:|--------------------|
| **Operational / Transactional** | 85 | Business activity records — events, work-products, and state transitions of the domain (reviews, meetings, documents, notifications, monitoring, safety, accreditation cycles). |
| **Configuration** | 38 | System/domain settings and catalogs that shape behaviour (system_config, email/sms/push config, lifecycle states, retention rules, form definitions, notification templates, template library, dashboard widgets). |
| **Reference Data** | 30 | Static lookup/domain vocabularies (statuses, types, levels, categories, registries, review questions, report definitions). |
| **Security** | 18 | Access subjects and control (users' access artefacts, roles, permissions, sessions, tokens, API keys, delegation/policy/approval rule tables). |
| **Historical** | 10 | Versioned/point-in-time snapshots of domain records (application_history, application_versions, document_versions, template versions, workflow_history). |
| **Logging** | 10 | Operational trails that are append-only evidence (notification_logs, search_audit, integration logs/failures, verification/disposal logs, security_events, maintenance_log, report_executions). |
| **Workflow** | 10 | Workflow definitions (workflows/states/transitions) and their runtime artefacts (instances, tasks, actions, escalations, events, schedulers, triggers). |
| **Integration** | 8 | External-system bridges (external_systems, credentials, webhooks, subscriptions, event bus config, outbox, retry queue, sync jobs). |
| **Master Data** | 8 | Durable core entities that are the subjects of the domain (users, user_profiles, institutions, departments, applications, projects, committees, committee_members). |
| **Audit** | 7 | Integrity evidence written under control of the audit subsystem (audit_logs, audit_details, entity_changes, hash_ledger, system.audit_log, login_audit, document_audit). |
| **Temporary / Cache** | 5 | Scratch/cache artefacts (public.v_chair_id, v_inst_codes, v_user_id, perf_results) and search_indexes. |
| **Reporting** | 3 | Aggregated analytics artefacts (analytics_snapshots, kpi_results, template_usage_statistics). |
| **Other** | 2 | Infrastructure meta: `ops.seed_tracker` (seed bookkeeping) and `public.pgmigrations` (migration-framework bookkeeping). Justified: neither is domain data; both are operations metadata. |
| **Materialized Views** | 0 | **Category intentionally empty** — the schema contains no materialized views. Verified: no `matview` objects exist. |
| **Test / Demo** | 0 | **Category intentionally empty** — no dedicated demo/test tables exist; demo data is inserted into real operational/master tables. This is itself a finding (see F5/F9). |

## 1.2 Notable structural observations

1. **"Reference Data" leaks out of the `reference` schema** — reference-like tables live in `core` (research_categories, risk_classifications, vulnerable_populations), `committee` (committee_types/roles, accreditation_standards), `documents` (document_types, signature types, classifications), `security` (institution_types, responsibility_types), `reporting` (report_definitions). The `reference` schema holds only 16 of the 30 reference tables; the rest are scattered by domain. Not wrong per se, but means "reference" is a role, not a location.
2. **Master Data is a thin layer** — only 8 tables. Everything else accumulates around it. In the current baseline, master rows are almost entirely Yemen-fixture-origin (41 institutions, 106 users, 112 applications, 8 committees).
3. **`public.v_*` temp tables persist** (1 row each) — leftover scratch tables from seed scripts, never dropped. Evidence of loose seed hygiene (Section 7, anti-pattern AP-11).
4. **`ops.seed_tracker` and `public.pgmigrations`** are the only meta tables; both are populated by tooling (apply-seeds / migration runner), not by seeds.

---

# Section 2 — Seeding policy per category

For each category we define the correct seeding disposition, then flag current-state compliance.

## 2.1 Policy matrix

| Category | Policy | Rationale |
|----------|--------|-----------|
| **Reference Data** | **Must always contain seed data** | Lookups are meaningless if empty; they define the valid-value universe at deploy time. |
| **Configuration** | **Must always contain seed data** (catalog/config types) except env-specific settings (system_config, email/sms/push_config, feature_flags) which are **May contain seed data (env-specific)** | Behaviour-shaping catalogs need defaults; credentials/endpoints are environment-owned. |
| **Workflow (definitions)** | **Must always contain seed data** | Workflows/states/transitions must exist before any instance can be created. |
| **Workflow (runtime)** | **Runtime-generated only** | Instances/tasks/actions are created by the workflow engine, not by seeds (demo fixtures may *trigger* them, not insert them). |
| **Master Data** | **May contain seed data** | A bootstrap admin + canonical org shell is required; bulk master entities are runtime/tenant-owned. |
| **Security (role catalog)** | **Must always contain seed data** | Roles/permissions/role_permissions must be present at deploy time. |
| **Security (users, sessions, tokens)** | **May contain seed data** (bootstrap admin) / **Runtime-generated only** | Only the admin bootstrap should be seeded; everything else is runtime. |
| **Operational / Transactional** | **May contain seed data (scenario/demo only)** | Valid to seed coherent scenarios in dev/UAT; production activity is runtime. |
| **Historical** | **Runtime-generated only** | Version/history rows must be produced by application/trigger logic, never direct-INSERTed by fixtures. |
| **Audit** | **Must never be seeded** | Audit rows are integrity evidence; seeding them falsifies the audit trail. |
| **Logging** | **Runtime-generated only** | Log records are side effects of system activity. |
| **Integration** | **May contain seed data** (endpoint/credential config) except queues/outbox = **Runtime-generated only** | Connector config is deploy-time; messages are runtime. |
| **Reporting** | **May contain seed data** (widget/definition catalogs) except snapshots/KPI = **Runtime-generated only** | Dashboards/report definitions are config; results are computed. |
| **Temporary / Cache** | **Runtime-generated only** | By definition. |
| **Materialized Views** | **Runtime-generated only** | REFRESH-driven (none exist). |
| **Other** | **Runtime-generated only** | Tooling-owned bookkeeping. |

**Aggregate disposition across all 234 tables:**
- Must always contain seed data: **69** (Reference 30 + Configuration 33 + Workflow definitions 3 + Security role catalog 3)
- May contain seed data (incl. env-specific): **20** (Master 8 + Operational 85→scenario-permitted + Integration 6 + Reporting 2 + Security 1 → the policy value is per-table; 20 is the count of "May" tagged tables, but scenario-permitted operational tables are 85)
- Runtime-generated only: **53**
- Must never be seeded: **7** (Audit)

## 2.2 Current-state compliance (violations)

| Violation | Category | Evidence |
|-----------|----------|----------|
| **Audit seeded by fixtures** | Audit | `audit.audit_details` 12,852 and `audit.audit_logs` 22,356 rows exist; `security.login_audit` 488. Some are trigger-side-effects of legitimate activity, but `11-rls-fix.sql` and `18-audit-fix.sql` **explicitly INSERT into audit_logs/audit_details** (see `seed_insert_map.csv`). Direct fixture writes to the audit trail violate "never seeded". |
| **History populated by direct INSERT** | Historical | `core.application_history` 459, `core.project_status_history` 93, `documents.document_versions` 36 — written by `53-yemen-applications.sql` / `52-yemen-projects.sql` / `54-yemen-documents.sql` via direct INSERT, not by workflow/document engine logic. |
| **Queues not runtime-only** | Integration | `integration.event_outbox` 30 rows in the baseline. Outbox rows should be produced by the write path; fixture presence means the outbox was populated directly. |
| **Temp tables persist** | Temporary / Cache | `public.v_*` rows (1 each) remain in the schema. |
| **Config seeded without env partition** | Configuration | `system.system_config` 11 rows seeded as universal values — no dev/test/prod differentiation. |

---

# Section 3 — Canonical Dataset (single source of truth)

## 3.1 Candidates evaluated

| Candidate | Description | Verdict | Justification |
|-----------|-------------|---------|---------------|
| **Demo dataset (Era-1)** | Seeds 01–09, 17–21: `KSU`, `IRB-KSU-01`, `APP-2024-001..009`, demo users `admin/ethics_admin/researcher1/reviewer1..3` | **REJECT** | All anchors are **dead** in the current DB (0 `APP-2024-*`, 0 `KSU`, 0 `researcher1`); it is not reproducible and it is the source of the silent-no-op class of failures. Historical artefact only. |
| **Yemen dataset (Era-2)** | Seeds 50–54: 41 institutions, 106 users, 28 `APP-2025-*` + 84 `APP-2026-*` applications, 57 certificates, 1,062 documents | **ACCEPT — canonical lineage** | Only lineage **fully present** in the verified baseline (no missing anchors); realistic, regionally-accurate scale; deterministic (guarded, keyed rows); already the de-facto data the DB carries. |
| **Pilot dataset** | Seed 95 (`NCBE-YE-001`, `SANAA-IRB-001`, `THAWRA-IRB-001`) | **REJECT as canonical** | Not present in the current baseline; built on top of the mixed lineage (depends on 01/02/03/08/10/21/50/53/90); smaller and committee-specific. Valid only as a *delta fixture over* the canonical dataset, not as a competing lineage. |
| **Realistic dataset** | Seed 96 (`ethics_admin`-backed apps, adverse events) | **REJECT as canonical** | 51 inserts, depends on 95 which depends on dead Era-1 anchors (via 21/02). Same hybrid problem, bigger. |
| **Baseline dump** | `backend/backups/gate0-baseline-2026-08-04.dump` | **ACCEPT — carrier/mechanism, not a dataset** | A snapshot of *whatever* lineage is canonical. It is the reproducible carrier (via `reset-dev-db.ps1`), but it cannot be the "source of truth" — it is a copy of it. |
| **Mixed datasets** | Any fresh-install outcome of the current numeric sequence | **REJECT** | Produces a hybrid (demo + Yemen) state, duplicates PKs, and is non-deterministic. |

## 3.2 Recommendation

> **The canonical lineage is the Yemen dataset (Era-2), as materialized in the Gate-0 baseline dump, over a shared reference/configuration/workflow core that is environment-invariant.**

This is a **layered canonical dataset**, not a single file set:

1. **Shared core (must always exist, identical in every env):** reference lookups, document types, workflow definitions, lifecycle/retention configuration, forms library, security role catalog, admin bootstrap. Supplied by *reference seeds* (Section 5) — these are not "a dataset", they are the baseline.
2. **Canonical master + scenario data:** the Yemen lineage (Era-2) — institutions, users, committees, applications, documents. This is the single dataset against which all demos, UAT, and e2e run.
3. **Runtime data:** anything produced by application activity. Never seeded.

**Why Yemen:** (a) presence — it is the only lineage fully materialized in the verified baseline; (b) realism — 112 applications across 8 committees/41 institutions exercises the workflow matrix that the demo dataset never did; (c) determinism — its rows are guarded and keyed, and it is reproducible through the dump; (d) regional fit — the deployment context is Yemen's national ethics-governance framework; (e) maintenance — Era-1 must be retired, and pilot/realistic fixtures must be *re-anchored on top of* Yemen, not on Era-1.

**Consequence:** seeds 01–09, 17–21 (Era-1) become **legacy documentation, not executable installers**; seeds 50–54 become the canonical fixture layer; 95/96 become optional deltas. The seed folder cannot continue to hold multiple competing lineages targeting the same tables.

---

# Section 4 — Seed architecture as a system (not as files)

## 4.1 The required role taxonomy

The ecosystem needs seven disjoint architectural roles, each with its own lifecycle and semantics. The current system has **one** role — "seed" — with shared ordering, shared tracking, and shared replay semantics for all 79 files.

| Role | Purpose | Lifecycle semantics | Replay behaviour |
|------|---------|---------------------|------------------|
| **Migrations** | Schema evolution: DDL, RLS policies, functions, triggers, indexes, constraints | Versioned, forward-only, never edited after application | Run once per environment, tracked by version |
| **Reference Seeds** | Baseline values: lookups, config, workflow definitions, role catalog | Idempotent, always applied, environment-invariant | Re-runnable safely (`ON CONFLICT`/guards) |
| **Scenario Seeds** | Coherent business scenarios (one application through its lifecycle) | Idempotent, self-contained, canonical-anchored | Re-runnable; produce a *complete* scenario |
| **Demo Fixtures** | Bulk presentation-grade data (Yemen lineage) | Droppable/reloadable, tied to canonical dataset | Reloadable on demand, never in prod |
| **Test Fixtures** | Deterministic data for automated tests | Isolated, deterministic, small | Loaded/cleared per test run |
| **Patch Seeds** | One-off corrections to existing environments | Documented, time-boxed, replaceable by migrations | Applied explicitly, never auto-replayed |
| **Infrastructure Scripts** | Tracker management, truncate/reset, docs, helper functions | Operational tooling, not data | Not "seeds" at all |

## 4.2 Why the current organization fails as a system

1. **Ordering conflates "kind" with "sequence"** — the numeric prefix is the only dependency mechanism, so migrations, reference data, scenarios, fixtures, and patches are interleaved in one 00–99 stream (9 layer oscillations, Section 6).
2. **Replay semantics are uniform** — `apply-seeds.ps1` treats a migration, a reference row, and a 1,613-row demo fixture identically: checksum, apply, record. There is no way to say "this must never replay", "this is droppable", or "this is a patch".
3. **Environment invariance is absent** — no dev/test/prod distinction; everything seeds into the same schema. Demo fixtures and environment config share the folder with deployment-critical migrations.
4. **No forward-only contract** — files are edited in place (e.g., `16-rls-communication` vs `16-rls-enable` vs `16-pagination-indexes`; `17-rls-cud` vs `17-safety`; `33-accreditation-seed` vs `33-fix-register-rls`), so the sequence is not append-only despite the tracker implying it is.
5. **MIXED files violate single-responsibility** — 13 files combine DDL + RLS + data (Section 5), so a migration cannot be applied to a schema independently of the scenario data baked into the same file.

---

# Section 5 — Per-file architectural role (all 79 files)

Complete mapping in `docs/architecture-normalization-seeds.csv`. Summary:

| Architectural role | Files | Target bucket | Representative files |
|--------------------|------:|---------------|----------------------|
| **Migration** | 29 | `migrations/` | 12, 13-audit, 14, 16-pagination, 16-rls-comm, 17-rls-cud, 22, 23, 24, 25, 27, 30, 31, 32, 38, 40, 45, 47, 48, 49, 55-forms, 57, 58-lifecycle, 59, 61, 62, migration-add-question-options, 26, 41 |
| **Reference Seed** | 12 | `seed/reference/` | 01-reference, 04-documents, 05-workflow, 35, 36, 37, 51-accred-workflow, 56, 58-official-templates, 60, 63, 64 |
| **Scenario Seed** | 15 | `seed/scenarios/` | 02-users, 03-committees, 06–09, 10, 17-safety, 18-monitoring, 19, 20, 21, 28, 29, 33-accred |
| **Demo Fixture** | 6 | `seed/fixtures/demo/` | 50-yemen-inst, 51-yemen-users, 52, 53, 54, 95-pilot |
| **Test Fixture** | 2 | `seed/fixtures/test/` | 90-gen-test-data, 96-realistic |
| **Patch Seed** | 10 | `patches/` | 11-rls-fix, 15, 18-audit-fix, 33-fix-register, 34, 42, 43, 44-fix, 46, 50-notif |
| **Infrastructure Script** | 5 | `scripts/infrastructure/` | 00-seed-tracker, 00-truncate, 13-data-dictionary, 16-rls-enable, 99-fix-checksums |

## 5.1 Files that should NOT remain seeds

| File | Current role | Belongs instead | Reason |
|------|--------------|-----------------|--------|
| `00-seed-tracker.sql` | Infrastructure | `scripts/` | Bookkeeping DDL, not data. |
| `00-truncate.sql` | Infrastructure | `scripts/` | Dangerous reset; also internally inconsistent (does not reset tracker). |
| `13-data-dictionary.sql` | Infrastructure | `docs/` or `scripts/` | It is a documentation artefact shipped as SQL. |
| `16-rls-enable.sql` | Infrastructure | `migrations/` (as an idempotent migration) | Enabling RLS is a schema-security migration, not an operational script. |
| `99-fix-checksums.sql` | Infrastructure | `patches/` + marked "do not replay" | Rewrites tracker checksums; 204 KB of hardcoded app numbers; a maintenance hazard, not a seed. |
| `migration-add-question-options.sql` | Migration | `migrations/` | Already named as a migration; only needs a versioned name and to leave the seed sequence. |
| `13-audit-triggers.sql` | Migration | `migrations/` | Pure DDL (trigger). |
| `47-public-verify-function.sql` | Migration | `migrations/` | Pure DDL (function); non-idempotent as written. |

## 5.2 Files that need splitting (MIXED responsibilities)

These combine schema evolution with data provisioning and must be decomposed before they can be re-homed:

| File | Contains DDL for | Contains data for | Split into |
|------|------------------|-------------------|------------|
| `11-rls-fix.sql` | RLS policies | audit.audit_logs/audit_details | Migration + (nothing — audit must not be seeded) |
| `18-audit-fix.sql` | indexes/function | audit.audit_logs/audit_details | Migration + remove data |
| `26-reference-data-crud.sql` | user_profiles table | reference.academic_titles | Migration + Reference Seed |
| `28-ethics-risk-assessment.sql` | 3 tables + indexes | ethics_risk_assessments/items | Migration + Scenario Seed |
| `29-informed-consent.sql` | 4 tables + policies | consent_templates/versions, application_consents | Migration + Scenario Seed |
| `33-fix-register-rls.sql` | SECURITY DEFINER function | security.users (via function) | Migration (function) |
| `40-init-workflow-idempotent.sql` | fn_init_workflow function | — (helper) | Migration |
| `41-application-conditions.sql` | application_conditions table + policies + trigger | documents.document_types | Migration + Reference Seed |
| `45-certificates.sql` | certificates tables + policies | document_types, templates | Migration + Reference Seed |
| `51-yemen-users.sql` | (uses fn_register_user) | users/roles/sessions/login_audit/password_history/api_keys | Demo Fixture (remove direct login_audit/password_history writes) |
| `55-forms-library.sql` | forms tables + policies | document_types, form_definitions, numbering | Migration + Reference Seed |
| `58-gate0-document-lifecycle.sql` | lifecycle tables + functions | lifecycle states/transitions, watermark config | Migration + Reference Seed |
| `60-gate0-document-signatures.sql` | — | document_signature_types | Reference Seed (trivially MIXED) |

## 5.3 Role assignment rationale notes

- **02-users → Scenario Seed, not Security bootstrap.** It seeds `roles/permissions/role_permissions` (which is a Security-bootstrap concern) *and* demo users (`researcher1`, `reviewer1..3`). The role-catalog part should become a Reference Seed; the demo users belong to a scenario/fixture. This is the single most important split: the security baseline is currently hostage to demo data.
- **33-accreditation-seed → Scenario Seed** (dead-anchored on `sanaa_chair`/`aden_chair`), while **51-accreditation-workflow → Reference Seed** (workflow definition, guarded).
- **95-pilot-dataset → Demo Fixture** but flagged as a *delta-over-canonical* fixture; it must be re-anchored to Yemen data if retained.
- **90-gen-test-data / 96-realistic-data → Test Fixtures**; both currently depend on mixed lineages and must be re-anchored or isolated into a test schema.

---

# Section 6 — Dependency model (correct execution layers)

## 6.1 The layer model

Instead of a flat numeric order, the ecosystem requires **ordered execution layers** with dependency edges *within* layers and strict layer ordering. Patches are cross-cutting and apply on top of any layer.

```
L0  Infrastructure & Meta      tracker, truncate, checksum repair, data dictionary
L1  Schema Migrations          DDL, RLS policies, functions, triggers, indexes, constraints
L2  Reference & Config Seeds   lookups, doc types, workflow definitions, forms, retention, role catalog
L3  Security Bootstrap         roles, permissions, admin user  (currently embedded in 02-users)
L4  Master & Scenario Seeds    org entities, canonical scenarios  (Yemen master data)
L5  Demo Fixtures              bulk presentation data  (Yemen 50-54; pilot 95)
L6  Test / Pilot Fixtures      deterministic automated-test data  (90, 96)
X   Patch Seeds                one-off corrections, applied explicitly on top
```

**Layer invariants:**
1. L1 must fully precede L2–L6 — data seeds must never run before the RLS/DDL that governs them.
2. L2 must precede L3–L6 — no workflow instances, users, or scenarios before reference/workflow definitions exist.
3. L3 (security bootstrap) must precede L4 — no master/scenario rows before roles and the admin exist.
4. L5/L6 must be built **on the canonical L4 dataset**, never on competing lineages.
5. Patches (X) must be documented and non-replayable-by-default; they are not part of the fresh-install path.

## 6.2 The current sequence interleaves layers 9 times

Mapping each file to its proper layer and reading the numeric sequence shows the oscillation:

```
00  L0   01 L4   02 L4   03 L4   04 L2   05 L2   06 L4   07 L4   08 L4   09 L4   10 L4
11  X    12 L1   13 L1   13b L0  14 L1   15 X    16 L1   16b L1   16c L0   17 L1   17b L4
18  X    18b L4  19 L4   20 L4   21 L4   22 L1   23 L1   24 L1   25 L1   26 L1   27 L1
28  L1+L4 29 L1+L4  30 L1  31 L1  32 L1  33 L4  33b X  34 X  35 L2  36 L2  37 L2
38  L1   40 L1   41 L1+L2 42 X  43 X  44 X  45 L1+L2  46 X  47 L1  48 L1  49 L1
50  X    50b L5  51 L2   51b L5  52 L5  53 L5  54 L5
55  L1+L2 56 L2  57 L1  58 L1+L2  58b L2  59 L1  60 L2  61 L1  62 L1  63 L2  64 L2
90  L6   95 L5/L6   96 L6   99 X   migration-add L1
```

**Consequences of the interleaving:**
- **Data before security (layer inversion):** the demo data seeds (01–10) run before the RLS stack (11–17). On a fresh install they execute with RLS effectively absent, so the resulting rows were never validated against the access policies they will live under. The baseline only looks correct because RLS was retrofitted *after* the demo data already existed.
- **Fixtures interleaved with migrations (50/51/58 collisions):** a migration (`50-notification-logs-rls-fix`) shares a prefix with a fixture (`50-yemen-institutions`); apply order between them is lexical, not semantic.
- **Patches embedded mid-sequence (11, 18, 33b, 34, 42–46, 50):** patches are forward-inline instead of being an explicit cross-cutting layer, so they replay on every `-Force` run with the same hazards as migrations.

## 6.3 Cross-layer dependency violations (from `seed_dependency_edges.csv`, 114 edges)

- **Fixture-on-dead-anchor chains:** `96-realistic` → `95-pilot` → `21-committee-expansion` → demo users (`sanaa_*`, `aden_*`) and `APP-2024-006..008`; `95-pilot` also → `08-reviews`/`03-committees`/`02-users` (Era-1). The test fixtures therefore transitively depend on the dead lineage.
- **Era-2 fixtures depend on Era-1 outputs:** `52-yemen-projects` → `06-projects-apps` (reads `core.projects`); `53-yemen-applications` → `06`/`07`/`03`/`21`; `54-yemen-documents` → `04`/`06`/`09`/`41`/`45`/`53`. The canonical fixture set is **not self-contained** — it leans on Era-1 files that the canonical-dataset decision (Section 3) retires.
- **Two seeds write the same tables with different lineage intent:** `security.institutions` is written by 01 (Era-1), 10 (Era-1 Yemen), 50 (Era-2), 95 (pilot), 96 (realistic). Same for `security.users` (02, 21, 51, 95, 96) and `core.applications` (06, 21, 53, 95, 96). The dependency graph is a **diamond over shared targets**, not a pipeline.

---

# Section 7 — Architectural anti-patterns (beyond the APP-2024 issue)

The APP-2024 anchoring failure is one instance of deeper design assumptions. Twelve patterns, grouped as four primary assumptions and six secondary defects.

## Primary design assumptions

### AP-1 — Business-key anchoring as a join mechanism
`INSERT ... SELECT ... WHERE username = 'researcher1'` (or `application_number`, `committee_code`) resolves foreign references by business key. When the key is absent the `SELECT` yields nothing, the variable stays NULL, and the insert either no-ops or raises — **without a clear message**. The APP-2024 case is the visible instance; the mechanism is everywhere (all `SilentNoOpRisk=True` seeds: 33/79). Correct contract: foreign references must resolve through identifiers created *by the same seed* (self-contained) or the seed must raise loudly if an anchor is missing.

### AP-2 — Historical/temporal coupling
Seeds encode point-in-time keys: `APP-2024-*` (06–09, 17–21, 28–29), `APP-2025-*`/`APP-2026-*` (53–54, 99). The data is frozen to a fiscal era; when the era passes, either the keys stop matching real data or the fixture silently stops producing rows. Application numbers must be runtime-generated, not fixture literals.

### AP-3 — Mixed responsibilities in a single file
13 files mix DDL, RLS, reference data, and scenario data (Section 5.2). A schema migration cannot be applied independently of the fixture data bundled with it; a fixture cannot be dropped without dropping a migration. Single-responsibility is the fix (Section 5).

### AP-4 — Silent execution semantics
No exception guards in `DO` blocks; `INSERT...SELECT` no-ops are indistinguishable from success; the tracker records "success" for files that produced 0 rows; `-v ON_ERROR_STOP=1` only catches raised errors, not zero-row outcomes. The system cannot distinguish "applied" from "did something". Tracker `success` must be paired with row-count evidence.

## Secondary defects

### AP-5 — Competing lineages in one sequence
Demo (Era-1), Yemen (Era-2), Pilot (95), and Realistic (96) all seed the same canonical tables. A single folder holds multiple incompatible datasets; there is no mechanism to say which dataset is canonical (resolved in Section 3: Yemen).

### AP-6 — Self-referential seeds
`21-committee-expansion` creates `APP-2024-006..008` and then reads them back in the same file. It succeeds only against one exact historical state. A seed must not both produce and consume the same rows.

### AP-7 — Numeric-prefix collisions
9 prefixes are shared (00, 13, 16, 17, 18, 33, 50, 51, 58). Ordering between collision members is lexical, not semantic — e.g., `50-notification-logs-rls-fix` vs `50-yemen-institutions`, `17-rls-cud-policies` vs `17-safety-data`. The numbering scheme has run out of meaningful order.

### AP-8 — Tracker-as-truth fallacy
`ops.seed_tracker` records "applied" without row counts; all 78 rows share `applied_at=2026-08-04` and `duration_ms=0` (bulk-restored with the baseline dump). Success ≠ data present. The tracker is a checksum ledger, not evidence of execution.

### AP-9 — No environment/tenant partitioning
Demo data lives in the same `core.applications`/`security.users` as any future real data, with no dataset tag, tenant column, or schema separation. Env-specific config (`system_config`, `email/sms_config`) is seeded as universal. On a shared DB, fixture data and production data are indistinguishable.

### AP-10 — Audit/history contamination
Fixtures direct-INSERT into audit tables (`11-rls-fix`, `18-audit-fix` → `audit_logs/audit_details`), history tables (`53` → `application_history`, `52` → `project_status_history`, `54` → `document_versions`), and log tables. This violates the "runtime-generated" policy of Section 2 and undermines the integrity value of those tables.

### AP-11 — Leftover scratch artefacts
`public.v_chair_id/v_inst_codes/v_user_id` temp tables persist in the schema (1 row each) — created by seed scripts and never dropped. Combined with `public.perf_results`/`pgmigrations`, the `public` schema accumulates script debris.

### AP-12 — Fixture-on-fixture inheritance depth
`96-realistic` depends on 95→21→53→90 chains (114 dependency edges total). Any subset is non-portable, and the deepest chains transitively depend on the dead lineage (Section 6.3). Fixtures must be shallow, canonical-anchored, and independently reloadable.

---

# Section 8 — Findings and architectural recommendation (no implementation)

## 8.1 Findings summary

| ID | Finding | Severity |
|----|---------|----------|
| A1 | The ecosystem is one flat numbered sequence serving five distinct lifecycle roles; ordering is the only dependency mechanism | Critical |
| A2 | Data seeds precede RLS migrations on a fresh install (layer inversion) | Critical |
| A3 | 33/79 seeds can silently no-op; the tracker records success without row evidence | High |
| A4 | 13 files mix migration + data responsibilities | High |
| A5 | Two+ competing lineages seed the same canonical tables; canonical dataset undefined until now | High |
| A6 | Fixtures write directly into audit/history/log tables | High |
| A7 | 9 numeric-prefix collisions make order ambiguous | Medium |
| A8 | No environment/tenant partitioning of fixture vs runtime data | Medium |
| A9 | Temp/scratch objects leak into the schema | Low |
| A10 | Role catalog (security baseline) is hostage to demo user data inside 02-users | High |

## 8.2 Target-state architecture (recommended shape)

1. **Buckets, not prefixes:** migrations/ (versioned, forward-only), seed/reference/, seed/scenarios/, seed/fixtures/demo/, seed/fixtures/test/, patches/, scripts/infrastructure/ — each with its own semantics (§4.1).
2. **Canonical dataset:** Yemen lineage (Era-2) over the shared reference/config/workflow core, carried by the Gate-0 baseline dump (§3.2); Era-1 retired to legacy documentation; pilot/realistic re-anchored as deltas.
3. **Layer-ordered execution:** L0→L1→L2→L3→L4→L5→L6 with explicit patch layer (§6.1), replacing the numeric sequence.
4. **Single-responsibility files:** every MIXED file split into its migration and its data (§5.2); security bootstrap separated from demo users (§5.3).
5. **Loud-failure contract:** all anchored reads raise on missing anchors; all seeds record row counts; the tracker records execution evidence, not just checksums.

## 8.3 Scope statement

This document is an **architecture findings and recommendation package only**. It deliberately proposes **no** implementation: no new SQL, no migration framework choice, no seed rewrites, no schema changes, no repository reorganization, and no commits. The target-state shape in §8.2 and the per-file re-homing in §5 are architectural directives to be executed in a subsequent (separately scoped) implementation phase.
