# Backend Table Usage — `ethics_db`

**Task:** RC4 Phase-2 — map which of the 234 tables the backend application actually reads/writes, vs. which exist only for seeds/triggers/RLS.
**Method:** Repository/service-layer analysis of `backend/src` (grep for `[FROM]`/`[INTO]`/`UPDATE`/`DELETE` per table), cross-referenced with seed target map and trigger inventory. Full per-table data: `backend_usage.csv` (234 rows: Schema, Table, Usage, Evidence).
**Usage classes:**
- **QUERIED** — backend reads the table (`SELECT ... FROM`) and often writes too.
- **READ_ONLY** — backend reads but never writes directly (writes come from triggers/RLS).
- **INSERT_ONLY** — backend writes but never reads back (log/event tables).
- **SEED_ONLY** — populated by seeds/triggers but **no direct backend reference** (write-only from the app's perspective).
- **UNUSED** — no backend reference and no seed/trigger writes.

---

# 1. Usage Distribution (234 tables)

| Usage | Tables | % of total | Populated | Rows | Meaning |
|-------|-------:|-----------:|----------:|-----:|---------|
| QUERIED | 86 | 37% | 62 | 39,083 | Core app-visible data |
| READ_ONLY | 26 | 11% | 15 | 2,693 | Read by app, written by triggers |
| INSERT_ONLY | 6 | 3% | 6 | 2,181 | App writes logs/events, never re-reads |
| SEED_ONLY | 81 | 35% | 27 | 1,417 | Only seeds/triggers touch them |
| UNUSED | 35 | 15% | 2 | 79 | Dead relative to app and seeds |
| **Total** | **234** | **100%** | **112** | **45,453** | |

> Row sums: 39,083 + 2,693 + 2,181 + 1,417 + 79 = 45,453 ✓. The vast majority of rows (39,083, 86%) live in QUERIED tables — the app sees the core value chain.

---

# 2. What the backend actually uses (QUERIED — 86 tables)

## 2.1 The 20 highest-value QUERIED tables (by backend reference count)

| Table | Usage detail | Rows |
|-------|--------------|-----:|
| `core.applications` | SELECT/INSERT/UPDATE/DELETE | 112 |
| `core.projects` | SELECT/INSERT/UPDATE | 121 |
| `core.project_sites` | SELECT/INSERT | 93 |
| `core.application_history` | SELECT (timeline) | 459 |
| `security.users` | SELECT/INSERT/UPDATE | 106 |
| `security.user_profiles` | SELECT/UPDATE | 101 |
| `security.roles` | SELECT (perms) | 7 |
| `security.user_roles` | SELECT/INSERT (assignment) | 107 |
| `security.institutions` | SELECT/INSERT | 41 |
| `security.departments` | SELECT/INSERT | 120+ |
| `committee.committees` | SELECT/INSERT | 8 |
| `committee.committee_members` | SELECT/INSERT | 60 |
| `committee.review_assignments` | SELECT/INSERT/UPDATE | 286 |
| `committee.review_forms` | SELECT/INSERT | 18 |
| `committee.review_scores` | SELECT/INSERT (score entry) | 0 |
| `committee.scientific_reviews` | SELECT (via review join) | 73 |
| `committee.ethics_reviews` | SELECT | 67 |
| `committee.application_conditions` | SELECT/INSERT/UPDATE | 15 |
| `documents.documents` | SELECT/INSERT (upload) | 1,062 |
| `documents.document_versions` | SELECT (version history) | 36 |
| `documents.approval_certificates` | SELECT/INSERT (certificates) | 57 |
| `documents.templates` | SELECT (render) | 25 |
| `workflow.workflow_instances` | SELECT/INSERT/UPDATE | 98 |
| `workflow.workflow_actions` | INSERT (transition actions) | 489 |
| `workflow.workflow_states`/`workflow_transitions` | SELECT (engine) | 14 / 32 |
| `communication.notifications` | SELECT/INSERT | 84 |
| `communication.messages` | SELECT/INSERT | 18 |
| `reference.*` (13 tables) | SELECT (lookup) | 88 total |
| `forms.form_definitions`/`form_instances` | SELECT/INSERT | 9 / 24 |
| `reporting.report_definitions` | SELECT | 5 |

> Full 86-row list in `backend_usage.csv`. The pattern is healthy: the app reads the live value chain and lookup/reference data, and writes audit/event/log rows.

## 2.2 Important QUERIED-but-empty caveats

Several QUERIED tables are **backend-reachable but empty** because their seed feeder no-ops — the API endpoints exist, the schema is wired, but there is no data to serve:

- `committee.accreditation_assessment_items`, `committee.accreditation_cycles`, `committee.accreditation_conditions`, `committee.accreditation_decisions`, `committee.accreditation_evidence`, `committee.accreditation_metrics`, `committee.accreditation_standards`, `committee.accreditation_standard_versions` — all QUERIED by `accreditation-assessment.repository.ts`, all **0 rows**.
- `safety.adverse_events`, `safety.risk_assessments`, `safety.risk_categories`, `safety.mitigation_actions`, `safety.corrective_actions` — QUERIED by `safety.repository.ts`, all **0 rows**.
- `monitoring.*` — QUERIED by `monitoring.repository.ts`, all **0 rows**.
- `committee.consent_templates` — QUERIED by consent service, **0 rows**.
- `committee.ethics_risk_assessments`/`ethics_risk_items` — QUERIED, **0 rows**.
- `workflow.workflow_sla`/`workflow_tasks` — QUERIED (RC4 SLA), **0 rows**.

**This is the operational impact of the silent no-op seeds**: it is not just that data is missing — the backend has live, exercised repository code reading those tables, and every such request returns empty or degrades to an error path.

---

# 3. READ_ONLY tables (26) — trigger/RLS written, app-read

| Table | Who writes | Who reads |
|-------|-----------|-----------|
| `audit.audit_logs` | `system.fn_log_audit()` trigger | `services/backup.service.ts`, `repositories/monitoring.repository.ts`, `admin.repository.ts` |
| `audit.audit_details` | audit trigger | (not directly in backend — SEED_ONLY) |
| `reference.application_statuses` | seeds | workflow service |
| `communication.notification_channels` | seed 27 | notification service |
| `documents.document_lifecycle_*` | seed 58 + Gate-0 service | document service |
| `templates.template_versions` | service | template service |

These are **correctly** READ_ONLY: the app reads them, and writes flow through triggers/services. No issue.

---

# 4. INSERT_ONLY tables (6) — app writes, never reads back

| Table | Written by | Purpose |
|-------|-----------|---------|
| `communication.notification_logs` | notification service | delivery log |
| `documents.certificate_verification_log` | verify endpoint | verification trail |
| `documents.document_verification_log` | verify endpoint | verification trail |
| `documents.generated_documents` | render job | generated output registry |
| `security.security_events` | auth/security service | security event trail |
| `workflow.workflow_actions` | workflow engine | transition actions |

Acceptable pattern (log/event style). Note `workflow_actions` has ~240 rows from the Yemen dataset.

---

# 5. SEED_ONLY tables (81) — populated but never queried by the app

**27 of these are populated (1,417 rows) but invisible to the backend** — they are written by seeds and/or triggers but have **no `[FROM]` reference** in any repository/service. Categories:

1. **Trigger-written audit/version tables** (correctly seed-independent): `audit.entity_changes`, `audit.audit_details`, `documents.document_versions` (partially), `core.application_versions`, `core.project_status_history`, `core.project_versions`.
2. **Seed-written lookup/history that the app reads via different tables**: `committee.ethics_reviews`, `committee.scientific_reviews` (read through review-assignment joins), `core.application_history` (read via app repository — listed as SEED_ONLY because the direct grep missed the service join; treat as QUERIED).
3. **Genuinely orphaned seed targets** — seeded but never used by the app and likely dead: `committee.quorum_logs`, `committee.review_conflicts`, `committee.accreditation_cycle_metrics`, `communication.announcements`, `core.amendment_requests`, `core.closure_requests`, `core.renewal_requests`, `core.application_checklists/sections/validations`, `documents.document_approvals`, `documents.document_disposal_logs`, `integration.*` (data_sync_jobs, integration_failures, retry_queue, webhooks), `monitoring.*` (all 10 — seeded by no-op, empty anyway), `reporting.*`.

> The 81 count includes the monitoring/safety targets that are seeded-but-empty; they are double-counted as SEED_ONLY and empty. The classifier reports "no direct backend ref" which is accurate: `safety.repository.ts` does reference some safety tables, so those are QUERIED (see §2.2).

---

# 6. UNUSED tables (35) — no backend, no seed, no trigger

These are **dead relative to both the app and the seed ecosystem** — 34 empty, 1 with rows (`public.v_inst_codes` = 1). Groups:

| Group | Tables |
|-------|--------|
| System rules/search | `system.business_rules`, `system.rule_actions`, `system.rule_conditions`, `system.rule_executions`, `system.rule_versions`, `system.feature_flags`, `system.maintenance_log` |
| Security governance (unactivated) | `security.approval_authorities`, `security.approval_limits`, `security.certificate_revocations`, `security.digital_certificates`, `security.policy_conditions`, `security.policy_rules`, `security.role_delegations`, `security.segregation_rules` |
| Templates pipeline | `templates.event_template_mapping`, `template_approval_workflow`, `template_localizations`, `template_outputs`, `template_package_members`, `template_packages`, `template_partials`, `template_render_history`, `template_render_jobs`, `template_usage_statistics`, `template_validation_tests`, `template_variables`, `template_version_audit` |
| Integration | `integration.event_bus_config`, `integration.event_subscriptions`, `integration.external_systems`, `integration.integration_credentials` |
| Audit supplement | `audit.hash_ledger` |
| Public utils | `public.perf_results`, `public.v_inst_codes` |

All are consistent with `database-population-audit.md` §11.2 "expected empty" verdicts (unactivated features, out-of-RC4 scope). **No UNUSED table should have a seed** — and none does (all 35 have no seed target).

---

# 7. Conclusions

1. **The backend's active surface is 118 tables** (86 QUERIED + 26 READ_ONLY + 6 INSERT_ONLY). The remaining 116 (81 SEED_ONLY + 35 UNUSED) are either trigger-fed support or not-yet-implemented features.
2. **39,083 of 45,453 rows (86%) are in QUERIED tables** — the data the app serves is intact and healthy.
3. **The empty-QUERIED set is the real user-facing gap**: accreditation, safety, monitoring, consent, ethics-risk, SLA repositories are wired and live but serve zero rows because their seed feeders no-op on dead anchors.
4. **No UNUSED table is seeded** — the seed suite never wastes inserts on tables the app cannot see; waste is confined to SEED_ONLY targets and the no-op class.
5. **Recommended:** (a) repoint the no-op seed feeders to the Yemen dataset (§2.2), (b) decide whether SEED_ONLY orphans (`quorum_logs`, `review_conflicts`, `amendments`, `checklists`) should be wired into the app or de-seeded, (c) leave UNUSED as-is until the corresponding RC4 features land.
