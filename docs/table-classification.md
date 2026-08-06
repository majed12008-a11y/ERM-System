# Table Classification — `ethics_db`

**Task:** RC4 Phase-2 architecture review — classify all 234 tables by data role.
**Method:** Deterministic classifier over 234 tables (`docs/database-table-inventory.csv`) using schema, naming conventions, row counts, backend usage (`backend_usage.csv`), and seed-target map (`seed_insert_map.csv`). Cross-checked against live catalog. Machine-readable output: `table_classification.csv`.
**Note:** Class boundaries are heuristic (naming-pattern driven). Re-classification of a handful of borderline tables is expected; the aggregate statistics are robust.

---

# 1. Class Totals

| Class | Tables | Populated | Empty | Rows | Seed coverage (tables targeted by ≥1 seed) |
|-------|-------:|----------:|------:|-----:|--------------------------------------------:|
| Operational | 65 | 26 | 39 | 2,003 | 48 |
| Transactional | 45 | 21 | 24 | 1,722 | 37 |
| Configuration | 34 | 16 | 18 | 186 | 10 |
| Lookup | 24 | 23 | 1 | 372 | 22 |
| History | 20 | 13 | 7 | 1,281 | 11 |
| Runtime | 12 | 3 | 9 | 588 | 2 |
| Temporary | 5 | 3 | 2 | 3 | 0 |
| Bridge | 8 | 2 | 6 | 3,972 | 2 |
| Audit | 8 | 2 | 6 | 35,208 | 3 |
| Integration | 6 | 0 | 6 | 0 | 0 |
| Reference | 3 | 1 | 2 | 10 | 0 |
| Queue | 2 | 1 | 1 | 30 | 0 |
| System | 1 | 1 | 0 | 78 | 0 |
| Cache | 1 | 0 | 1 | 0 | 1 |
| **Total** | **234** | **112** | **122** | **45,453** | **136** |

> Row totals by class sum to 45,453 (cross-checked with the population audit). `Audit` is dominated by `audit.audit_details` (12,852) + `audit.audit_logs` (22,356) → 35,208 in-class rows. `Bridge` rows come almost entirely from `security.user_roles` (a join table that is heavily populated by the Yemen user seeds).

---

# 2. Class Definitions & Heuristics

| Class | Definition | Primary signals | Examples |
|-------|-----------|-----------------|----------|
| **Operational** | Transactional work products: documents, meetings, reviews, certificates, notifications, reports | `*_documents`, `documents`, `_reports`, `_minutes`, `_agenda`, `_attendance`, `_sessions`, `_votes`, `_followups`, `_certificates`, `keywords`, `sites`, `team_members`, `tags`, `funding_sources`, `links`, `populations`, `investigators`, `classifications`, `academic_titles` | `documents.documents`, `committee.committee_meetings`, `communication.notifications`, `documents.approval_certificates` |
| **Transactional** | Core business entities and workflow state | `users`, `profiles`, `applications`, `projects`, `institutions`, `committees`, `members`, `workflows`, `instances`, `conditions`, `amendments`, `requests`, `consents`, `checklists`, `validations`, `sessions`, `security_events` | `core.applications`, `core.projects`, `security.users`, `committee.committees`, `workflow.workflow_instances` |
| **Configuration** | System behavior/rendering configuration, templates, retention, mappings, feature flags | `config`, `settings`, `_templates`, `template_`, `_widgets`, `report_definitions`, `watermark`, `retention_rules`, `lifecycle_states`, `lifecycle_transitions`, `document_numbering`, `channels`, `notification_templates`, `_mapping`, `_preferences`, `feature_flags`, `forms`, `rule_*` | `documents.templates`, `system.*config*`, `documents.document_lifecycle_states`, `communication.notification_channels` |
| **Lookup** | Small controlled vocabularies / reference values | `_statuses`, `_types`, `_levels`, `_categories`, `_codes`, `_lookups`, `lookup_`, `_definitions`, `_registry`, `_status`, `_roles`, `_permissions`, `_priorities`, `vote_types`, `risk_levels`, `document_types`, `institution_types` | `reference.application_statuses`, `documents.document_types`, `security.roles`, `committee.committee_types`, `safety.risk_categories` |
| **History** | Temporal/versioned state (audit-oriented append-only variants) | `_history`, `_audit`, `changes`, `_log`, `_logs`, `_versions`, `_version`, `_revisions`, `_template_versions`, `_standard_versions` | `core.application_history`, `documents.document_versions`, `committee.consent_template_versions`, `audit.entity_changes` |
| **Runtime** | Engine/workflow execution artifacts, indexes, saved searches, tasks | `_instances`, `_actions`, `_executions`, `_jobs`, `_tasks`, `_triggers`, `_escalations`, `_events`, `_queue`, `_outbox`, `_bus`, `_schedulers`, `saved_searches`, `search_indexes`, `workflow_actions`, `render_jobs` | `workflow.workflow_actions`, `system.saved_searches`, `system.search_indexes`, `reporting.report_executions`, `templates.template_render_jobs` |
| **Temporary** | Utility/temp/virtual helper tables | `public.perf_results`, `public.v_*` (no PK) | `public.perf_results`, `public.v_chair_id`, `public.v_inst_codes`, `public.v_user_id` |
| **Bridge** | Join / many-to-many / access / delegation / authority | `_access`, `_permissions`, `grants`, `role_permissions`, `user_roles`, `committee_member_roles`, `_responsibilities`, `approval_authorities`, `approval_limits`, `segregation_rules`, `role_delegations`, `policy_*` | `security.user_roles`, `documents.document_access`, `security.approval_authorities`, `security.role_delegations` |
| **Audit** | Audit trail / ledger (schema `audit` or explicit) | schema `audit`; `audit_details`, `audit_logs`, `hash_ledger`, `security_events`-adjacent | `audit.audit_logs`, `audit.audit_details`, `audit.hash_ledger` |
| **Integration** | External system integration metadata | schema `integration` (non-queue) | `integration.external_systems`, `integration.integration_credentials`, `integration.integration_logs`, `integration.event_subscriptions` |
| **Reference** | Master/registry reference data (schema `reference`) | schema `reference`, `*_registry` | `reference.institutions_registry`, `reference.licenses_registry`, `reference.professions_registry` |
| **Queue** | Message/retry queues | `_queue`, `_outbox`, `retry_*`, `_bus` | `integration.event_outbox`, `integration.retry_queue` |
| **System** | Internal operational metadata | schema `ops` | `ops.seed_tracker` |
| **Cache** | Precomputed snapshots / analytic aggregates | `_snapshots`, `analytics_snapshots` | `reporting.analytics_snapshots` |

> **Materialized views** (2) are not tables and are intentionally excluded from the 234 count, but they belong to the Cache class semantically: `reporting.mv_committee_performance`, `reporting.mv_daily_application_snapshot` — both unpopulated, never refreshed, and not referenced by backend code.

---

# 3. Cross-cutting observations by class

## 3.1 Operational (65 tables) — largest class, mostly alive
- **Documents ecosystem dominates**: `documents.documents` (1,062 rows), `document_versions`, `document_access`, `approval_certificates` (57), generated-document metadata.
- **Empty operational targets** are almost all seeds-anchored: `meeting_minutes` (0), `quorum_logs` (0), `agenda_items` (0) and sparse `attendance_logs` (4) are empty because `20-remaining-core-data` (their feeder) no-ops, while only 2 `committee_meetings` exist.

## 3.2 Transactional (45) — the core value chain is intact
- `core.applications` (112), `core.projects` (121), `core.project_sites`, `workflow.workflow_instances` (98) are fully populated and FK-clean.
- **Empty transactional**: `integration` tables are classified Integration; within Transactional the empties are consent (`core.application_consents`), amendment (`core.application_amendments`), renewal/closure/appeal requests, and `safety`-adjacent application risk data — all anchored to dead demo apps.

## 3.3 Configuration (34) — templates alive, engine config dead
- `documents.templates` and `document_retention_rules` are populated (Gate-0).
- `system.*` configuration (email/sms/push config, feature flags, audit config, search, saved_searches) is **largely empty** (11/16 system tables empty) — system module runs on defaults, and `20-remaining-core-data` (its feeder) no-ops.

## 3.4 Lookup (24) — reference values healthy
- `security.institution_types` (4), `security.roles` (7), `documents.document_types` (28), `reference.application_statuses` (14), `committee.committee_types` (8) all populated by seeds 01/02/03/21/95/96.
- 8 empty lookups are mostly domain-specific vocabularies whose seeds are no-ops (e.g. safety risk levels, accreditation standards).

## 3.5 History (20) — thin
- `core.application_history` (112+ rows) and `documents.document_versions` present; most other `_history`/`_versions` tables are empty because their source data was never created.

## 3.6 Runtime (12) — effectively empty
- Only `workflow.workflow_actions` and `system.search_indexes`-adjacent have data; `report_executions`, `template_render_jobs`, `render_history`, `saved_searches`, `search_audit`, `search_indexes`, `validation_tests`, `usage_statistics` are all 0. The reporting/template engines are provisioned but not exercised by seeds.

## 3.7 Queue (2), Cache (1), Integration (6), System (1)
- `integration.event_outbox` (30 rows) is the only integration data; everything else in `integration` is 0.
- `ops.seed_tracker` (78 rows) is the lone System table.

---

# 4. Table inventory summary (Grouped by class)

Full per-table data is in `table_classification.csv` (234 rows: Schema, Table, RowCount, Classification, BackendUsage, HasSeed). The single-table listing is intentionally omitted here to keep this report readable; it is available in the machine-readable artifact and in `docs/database-table-inventory.csv`.

## Seed coverage by class

| Class | Tables with a seed target | Tables with no seed target | Seed gap examples |
|-------|--------------------------:|---------------------------:|-------------------|
| Operational | 48 | 17 | `integration.*` (no seeds), `templates.template_render_*` (engine tables), `reporting.report_executions`, `committee.member_conflicts` |
| Transactional | 37 | 8 | `security.sessions`, `security.login_audit`, `security.password_history`, `security.api_keys`, `security.digital_certificates`, `security.certificate_revocations` (runtime-created, correctly unseeded) |
| Configuration | 10 | 24 | `system.*config*`, `system.feature_flags`, `system.business_rules`, `templates.template_packages/outputs` (DDL-created, data runtime) |
| Lookup | 22 | 2 | `core.risk_classifications`, `core.vulnerable_populations` (runtime-referenced) |
| History | 11 | 9 | `documents.document_audit` (trigger-written) |
| Runtime | 2 | 10 | engine execution tables (runtime-populated) |
| Temporary | 0 | 5 | helper tables |
| Bridge | 2 | 6 | access/delegation tables |
| Audit | 3 | 5 | trigger-written (correctly unseeded) |
| Integration | 0 | 6 | no seeds target integration schema |
| Reference | 0 | 3 | registry tables (DDL-defined) |
| Queue | 0 | 2 | runtime |
| System | 0 | 1 | tracker self-managed |
| Cache | 1 | 0 | matview-backed snapshot |
| **Total** | **136** | **98** | |

## Classification of "empty but should have seed" vs "empty and correctly empty"

From `database-population-audit.md` §5 (58 Should-Contain / 64 Expected-Empty) mapped to class:

- **Should-Contain but empty (58)** — all concentrated in seeds that no-op: Operational (meetings/agenda/review artifacts), Transactional (consent, amendments, SLA, conditions), Lookup (safety/accreditation vocabularies), Runtime (report executions). Root cause: anchor-gone seeds (see `seed-architecture-review.md` §3).
- **Expected-Empty (64)** — correctly empty: Audit/History (trigger/runtime-written), Integration/Queue/Cache/Runtime engine tables, System, Temporary, plus runtime-created Security tables (sessions, login_audit, api_keys, certificates).

---

# 5. Class → Backend usage cross-tab

| Class | QUERIED | READ_ONLY | INSERT_ONLY | SEED_ONLY | UNUSED | Total |
|-------|--------:|----------:|------------:|----------:|-------:|------:|
| Operational | 27 | 8 | 1 | 28 | 1 | 65 |
| Transactional | 29 | 2 | 0 | 13 | 1 | 45 |
| Configuration | 8 | 7 | 0 | 2 | 17 | 34 |
| Lookup | 10 | 4 | 0 | 10 | 0 | 24 |
| History | 7 | 1 | 3 | 7 | 2 | 20 |
| Runtime | 2 | 0 | 2 | 8 | 0 | 12 |
| Temporary | 0 | 0 | 0 | 3 | 2 | 5 |
| Bridge | 1 | 0 | 0 | 1 | 6 | 8 |
| Audit | 0 | 2 | 0 | 4 | 2 | 8 |
| Integration | 0 | 0 | 0 | 2 | 4 | 6 |
| Reference | 2 | 1 | 0 | 0 | 0 | 3 |
| Queue | 0 | 1 | 0 | 1 | 0 | 2 |
| System | 0 | 0 | 0 | 1 | 0 | 1 |
| Cache | 0 | 0 | 0 | 1 | 0 | 1 |
| **Total** | **86** | **26** | **6** | **81** | **35** | **234** |

> `backend-table-usage.md` (Part 5) analyzes the backend side in full; this cross-tab shows the class↔usage relationship. Note the high `SEED_ONLY` counts in Operational/Configuration/History — those tables are populated only by seeds and never read by the application (they are "write-only" from the app's perspective).

---

# 6. Recommendations

1. **Empty-anchored classes first:** Operational/Transactional/Lookup tables fed by dead seeds should be the priority for Gate-1+ remediation (safety, monitoring, consent, ethics-risk, accreditation, SLA).
2. **Configuration & Runtime:** decide explicitly whether `system.*` config and engine tables are seed-provided or runtime-bootstrapped; currently they are empty with no owner.
3. **History/Audit:** confirm trigger/runtime-only population is intended for all `_history`/`_audit` tables (currently thin because their parents are empty).
4. **Matviews (Cache class):** add a refresh job or drop them until reporting is implemented — they are unpopulated and unreferenced.
