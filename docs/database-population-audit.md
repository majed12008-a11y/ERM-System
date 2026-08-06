# Database Population Audit — `ethics_db`

**Task:** RC4 Pre-Analysis — Seed Coverage & Data Completeness Assessment (Analysis Only)
**Method:** Read-only exact `count(*)` over all tables, catalog-level introspection (`pg_catalog`/`information_schema`), and source-level seed analysis. No data, schema, or code modified.
**Authoritative snapshot:** `baseline_counts.csv` captured 2026-08-05 17:05 UTC (all 234 tables, exact counts, single consistent read). The backend dev server was running during capture; a small number of live queries later drifted (e.g., `workflow_instances` 96→98, `applications` 111→112, `notifications` 84). **All figures in this report use the baseline snapshot and are point-in-time.**

---

# 1. Executive Summary

- **45,453 rows across 234 tables** — 112 populated (48%), 122 empty (52%).
- The **core value chain is fully populated and referentially intact**: 112 applications across all 14 statuses, 121 projects, 1,062 documents, 57 certificates, 286 review assignments, 98 workflow instances, 35,208 audit rows.
- **Zero broken foreign keys** across all 269 FK constraints. The 27 previously-flagged "orphan" rows are all NULL-valued optional FKs (audit/versioning/revoked-by columns) — none is a true violation.
- **Three domains are entirely empty and this is a defect, not intent**: `safety` (12/12), `monitoring` (10/10), `accreditation_*` (9/9). Root cause: seeds `17-safety-data.sql`, `18-monitoring-data.sql`, `33-accreditation-seed.sql` anchor their `INSERT ... SELECT` to **`APP-2024-*` application numbers that do not exist in the baseline** (all applications are `APP-2025-*`). Seeds report `success` in `ops.seed_tracker` but insert nothing — a **silent no-op seed class**.
- **Also empty due to the same root cause**: informed consent (`29`), ethics-risk assessment (`28`), and part of `20-remaining-core-data.sql`/`96-realistic-data.sql` safety inserts.
- **Structural health is strong**: every populated table has a PK, all key parent/child links resolve, no empty parent is referenced by a populated child.
- **RC4 in-scope features lacking seed data**: SLA tracking (`workflow_sla`, `workflow_tasks` = 0), meeting/committee tracking (meetings 2, minutes/attendance/quorum sparse), reporting matviews (unrefreshed), review answer capture (`review_answers` = 0), integration (9/10 empty), templates pipeline (render/jobs/usage empty).

---

# 2. Database Overview

| Item | Value |
|------|-------|
| Database name | `ethics_db` |
| PostgreSQL version | **18.3** on x86_64-windows (msvc-19.44) |
| Total schemas | 17 application schemas (+ 11 system/temp: `pg_catalog`, `information_schema`, `pg_toast`, 5× `pg_temp_*`, 4× `pg_toast_temp_*`) |
| Total tables | **234** |
| Total views | **11** (all in `reporting`, all `vw_*`: 3 dashboard stats, 2 KPI, 2 committee, SLA, meetings, user, timeline) |
| Total materialized views | **2** (`reporting.mv_committee_performance`, `reporting.mv_daily_application_snapshot`) — both **unpopulated** |
| Total sequences | **229** |
| Total functions | **127** (+ 2 aggregates in `public`) |
| Total triggers | **245** (non-internal) |
| Total indexes | **646** (application schemas; + 221 `pg_toast` toast indexes + 124 `pg_catalog`) |
| Table partitions | 0 |
| Total FK constraints | **269** |

**Application schemas (17):** audit, committee, communication, core, documents, forms, integration, monitoring, ops, public, reference, reporting, safety, security, system, templates, workflow.

---

# 3. Schema Summary

| Schema | Tables | Populated | Empty | Views | Functions | Triggers | Sequences | Indexes | Rows | Population % |
|--------|-------:|----------:|------:|------:|----------:|---------:|----------:|--------:|-----:|-------------:|
| audit | 4 | 2 | 2 | 0 | 0 | 0 | 4 | 12 | 35,208 | 50% |
| committee | 41 | 17 | 24 | 0 | 7 | 44 | 41 | 122 | 607 | 41% |
| communication | 9 | 6 | 3 | 0 | 1 | 8 | 9 | 29 | 163 | 67% |
| core | 25 | 13 | 12 | 0 | 0 | 33 | 25 | 72 | 1,543 | 52% |
| documents | 21 | 17 | 4 | 0 | 6 | 19 | 20 | 59 | 5,270 | 81% |
| forms | 2 | 2 | 0 | 0 | 0 | 2 | 2 | 5 | 33 | 100% |
| integration | 10 | 1 | 9 | 0 | 0 | 12 | 10 | 29 | 30 | 10% |
| monitoring | 10 | 0 | 10 | 0 | 0 | 10 | 10 | 21 | 0 | 0% |
| ops | 1 | 1 | 0 | 0 | 0 | 0 | 1 | 2 | 78 | 100% |
| public | 5 | 3 | 2 | 0 | 94 | 0 | 1 | 1 | 3 | 60% |
| reference | 16 | 14 | 2 | 0 | 0 | 19 | 16 | 38 | 88 | 88% |
| reporting | 5 | 2 | 3 | 11 | 0 | 5 | 5 | 13 | 11 | 40% |
| safety | 12 | 0 | 12 | 0 | 0 | 16 | 12 | 38 | 0 | 0% |
| security | 27 | 17 | 10 | 0 | 4 | 31 | 27 | 80 | 1,645 | 63% |
| system | 16 | 5 | 11 | 0 | 15 | 14 | 16 | 37 | 20 | 31% |
| templates | 16 | 6 | 10 | 0 | 0 | 16 | 16 | 49 | 90 | 38% |
| workflow | 14 | 6 | 8 | 0 | 0 | 16 | 14 | 39 | 664 | 43% |
| **Total** | **234** | **112** | **122** | **11** | **127** | **245** | **229** | **646** | **45,453** | **48%** |

> Note: `public` holds 94 of the 127 functions plus the 2 aggregates (many are pgmigration helpers / rule-engine support); `audit` has none (its audit trail is written by triggers defined in the `system` schema). Index counts are per application schema, excluding `pg_toast` (221 toast indexes) and `pg_catalog` (124).

---

# 4. Complete Table Inventory

The full 234-row inventory is delivered as **`docs/database-table-inventory.csv`** with columns:

`Schema, Table, RowCount, PopulationStatus, BusinessModule, BusinessCritical, Seeded, Notes, PK, FKs, ReferencedBy`

Sorted by Schema → Table. **No table is omitted.** Population status thresholds:
- **Empty** = 0 rows · **Minimal** = 1–9 · **Partial** = 10–99 · **Well Populated** = 100+.

Summary of the inventory:
- 122 Empty, 50 Minimal, 44 Partial, 18 Well Populated.
- 4 tables have **no primary key**: `public.perf_results`, `public.v_chair_id`, `public.v_inst_codes`, `public.v_user_id` (utility/temp tables; intentional).
- 155 tables define outgoing FKs; 70 tables are referenced by other tables.
- 136 tables are known seed targets; 98 tables have no direct seed INSERT.

---

# 5. Tables With Data (112 tables)

### 5.1 Well Populated (18, ≥100 rows)
| Table | Rows |
|-------|-----:|
| audit.audit_logs | 22,356 |
| audit.audit_details | 12,852 |
| documents.document_access | 3,956 |
| documents.documents | 1,062 |
| workflow.workflow_actions | 489 |
| security.login_audit | 488 |
| core.application_history | 459 |
| core.project_keywords | 372 |
| security.sessions | 372 |
| committee.review_assignments | 286 |
| core.project_team_members | 141 |
| security.departments | 127 |
| core.projects | 121 |
| security.role_permissions | 114 |
| core.applications | 112 |
| security.user_roles | 107 |
| security.users | 106 |
| security.user_profiles | 101 |

### 5.2 Partial (44 tables, 10–99 rows)
Notable: workflow_instances 98, password_history 95, project_status_history 93, project_funding_sources 93, project_sites 93, notifications 84, seed_tracker 78, scientific_reviews 73, ethics_reviews 67, committee_members 57, approval_certificates 57, review_questions 54, documents.templates 25, form_instances 24, document_versions 36, messages 18, review_forms 18, application_conditions 15, workflow_states 14, application_statuses 14, template_versions 13, email_verification_tokens 13, notification_logs 12, generated_documents 12, document_audit 12, categories 12, system_config 11, lookup_values 11, academic_titles 11, document_lifecycle_states 10, professions_registry 10.

### 5.3 Minimal (50 tables, 1–9 rows)
Includes core reference/business support rows: form_definitions 9, signature_types 9, api_keys 9, research_categories 8, document_numbering 8, notification_templates 8, access_policies 7, notification_statuses 7, watermark_config 7, application_amendments 7, roles 7, kpi-related definitions, dashboard_widgets 6, responsibility_types 6, vulnerable_populations 6, committee_decision_types 5, status_types 5, notification_channels 5, report_definitions 5, template_partials 5, document_classifications 4, risk_classifications 4, attendance_logs 4, template_version_audit 4, review_comments 3, review_recommendations 3, risk_levels 3, lookup_categories 3, workflow_statuses 3, committee_meetings 2, votes 2, document_signatures 2, and 11 single-record tables (Section 5.4).

### 5.4 Tables with exactly one record (10)
`workflow.workflows` (APP_REVIEW_V1), `committee.voting_sessions`, `committee.meeting_agendas`, `documents.document_verification_log`, `system.email_config`, `system.sms_config`, `system.saved_searches`, and the 3 `public.v_*` utility tables.

---

# 6. Empty Tables (122)

Full classification with justification is in **Section 9**. Grouped by module:

| Module | Empty | Verdict |
|--------|------:|---------|
| Safety | 12 | **SHOULD CONTAIN DATA** (seed no-op) |
| System | 11 | Expected empty (config/rule engines) |
| Templates | 10 | Expected empty (pipeline not exercised) |
| Monitoring | 10 | **SHOULD CONTAIN DATA** (seed no-op) |
| Accreditation | 9 | **SHOULD CONTAIN DATA** (seed no-op) |
| Integration | 9 | Expected empty (out of RC4 scope) |
| Security Governance | 8 | Expected empty (not exercised) |
| Workflow | 8 | Mixed (SLA/variables SHOULD have data) |
| Applications | 7 | Mixed (support tables) |
| Projects | 4 | Mixed |
| Meetings | 3 | **SHOULD CONTAIN DATA** (2 meetings exist) |
| Documents | 3 | Mixed (approvals SHOULD have data) |
| Informed Consent | 3 | **SHOULD CONTAIN DATA** (seed no-op) |
| Committee Members | 3 | **SHOULD CONTAIN DATA** (57 members exist) |
| Reviews | 3 | **SHOULD CONTAIN DATA** (286 assignments exist) |
| Reporting | 3 | Mixed (kpi/analytics SHOULD be populated) |
| Auditing | 2 | Expected empty (hash_ledger/entity_changes) |
| Reference Data | 2 | Expected empty (registries unused) |
| Utilities | 2 | Expected (perf/pgmigrations) |
| Ethics Risk | 2 | **SHOULD CONTAIN DATA** (seed no-op) |
| Certificates | 1 | Expected (approval_certificate_documents) |
| Research Metadata | 1 | Expected (population links) |
| Messaging | 1 | Expected (attachments) |
| Roles | 1 | Expected (role_delegations) |
| Auth & Sessions | 1 | Expected (password_reset_tokens) |
| Announcements | 1 | Expected |
| Committees | 1 | **SHOULD CONTAIN DATA** (committee_member_roles) |
| Communication | 1 | Expected (user_notification_preferences) |

---

# 7. Business Coverage Assessment

| Business Module | Tables (pop/total) | Classification | Rationale |
|-----------------|-------------------|----------------|-----------|
| Users | 4/4 | **GOOD** | 106 users, 101 profiles, 107 role assignments; all identity tables populated |
| Roles & Permissions | 3/4 | **GOOD** | 7 roles, 32 permissions, 114 role-permission links; role_delegations empty (expected) |
| Institutions | 2/2 | **GOOD** | 41 institutions, 4 types |
| Departments | 1/1 | **GOOD** | 127 departments |
| Auth & Sessions | 5/6 | **PARTIAL** | 372 sessions, 488 login_audit, 95 password_history, 9 api_keys; password_reset_tokens empty (no resets in seed window) |
| Security Governance | 1/9 | **MINIMAL** | Only access_policies 7; approval/certificate/policy/segregation tables unused |
| Committees | 5/6 | **PARTIAL** | 8 committees, 57 members, types/roles; committee_member_roles empty (role link never written) |
| Committee Members | 0/3 | **EMPTY** | member_qualifications, member_terms, member_conflicts empty despite 57 members |
| Projects | 7/11 | **GOOD** | 121 projects with 141 team, 372 keywords, 93 funding, 93 sites, 93 status-history |
| Applications | 4/11 | **GOOD** | 112 applications across all 14 statuses + 459 history + 34 versions + 7 amendments |
| Reviews | 5/8 | **PARTIAL** | 286 assignments, 73 scientific, 67 ethics reviews, 18 forms, 54 questions; **review_answers 0**, scores/conflicts empty |
| Conditions | 1/1 | **GOOD** | 15 conditions (9 MET, 6 OPEN) |
| Workflow | 6/14 | **PARTIAL** | APP_REVIEW_V1 engine fully exercised (98 instances, 489 actions, 30 history); SLA/tasks/events/triggers/comments/escalations/schedulers/variables empty |
| Certificates | 1/2 | **GOOD** | 57 certificates (54 ISSUED, 3 GENERATING); all APPROVED apps have one |
| Documents | 15/18 | **GOOD** | 1,062 documents, 36 versions, 3,956 access grants, Gate-0 lifecycle states/transitions/retention/watermark/signatures populated; approvals/verification/disposal empty |
| Notifications | 4/4 | **GOOD** | 84 notifications, 12 logs, 8 templates, 5 channels |
| Messaging | 2/3 | **MINIMAL** | 18 messages, 36 recipients; attachments empty |
| Templates | 7/17 | **PARTIAL** | 12 templates, 13 versions, 44 variables, 12 categories, 5 partials; render jobs/history/usage/packages/outputs/validation/approval/localization empty |
| Forms | 2/2 | **GOOD** | 9 form definitions (all active), 24 instances |
| Reporting | 2/5 | **MINIMAL** | 6 dashboard widgets, 5 report definitions; kpi_results 0, matviews unrefreshed, analytics 0 |
| Auditing | 2/4 | **GOOD** | 22,356 logs + 12,852 details; entity_changes/hash_ledger empty (expected) |
| Reference Data | 14/16 | **GOOD** | All lookup/status tables seeded; registries empty (expected) |
| Safety | 0/12 | **EMPTY** | Seed `17-safety-data.sql` is a silent no-op (APP-2024 anchor) |
| Monitoring | 0/10 | **EMPTY** | Seed `18-monitoring-data.sql` is a silent no-op (APP-2024 anchor) |
| Accreditation | 0/9 | **EMPTY** | Seed `33-accreditation-seed.sql` no-op; accreditation workflow not created |
| Informed Consent | 0/3 | **EMPTY** | Seed `29-informed-consent.sql` no-op |
| Ethics Risk | 0/2 | **EMPTY** | Seed `28-ethics-risk-assessment.sql` no-op |
| Meetings | 4/7 | **MINIMAL** | Only 2 meetings, 1 agenda, 4 attendance, 1 voting session, 2 votes; minutes/quorum/agenda_items empty |
| Integration | 1/10 | **EMPTY** | Only event_outbox 30; integrations out of RC4 scope |
| System | 5/16 | **MINIMAL** | system_config 11, audit_config 6, email/sms config, saved_searches; rule engines/search/maintenance empty |
| Announcements | 0/1 | **EMPTY** | Not exercised |
| Research Metadata | 2/3 | **PARTIAL** | 8 categories, 4 risk classifications, 6 vulnerable populations; population links empty |
| Operations | 1/1 | **GOOD** | seed_tracker 78 |
| Utilities | 3/5 | **PARTIAL** | v_* temp tables; perf/pgmigrations empty |

---

# 8. Seed Coverage Assessment

### 8.1 Method & limitation
Seed-to-table mapping was derived by scanning all 78 `.sql` seed scripts for `INSERT INTO <schema>.<table>` targets (captured in `seedmap.txt`, available in the audit working files). **Limitation**: counts are table totals, not per-seed attribution — multiple seeds write to the same tables (users, applications, documents, workflow_instances), so a "populated" verdict reflects the whole chain, and a single seed's individual inserts cannot be isolated without replay. Scripts containing only DDL/RLS/triggers/functions are classified *structural*.

### 8.2 Which tables are populated by seeds
136 of 234 tables are direct seed INSERT targets; **84 of those currently contain data (62%)**. Tables populated by seeds include the entire identity/access layer (users, roles, permissions, institutions, departments), the full application pipeline (projects, applications, workflow instances/actions, reviews, conditions, documents, certificates), reference data, communication, forms, Gate-0 document infrastructure, and templates definitions. The remaining 52 seed targets are empty because of the silent no-op seeds (§8.4) and support tables whose seeds depend on data never created.

### 8.3 Which tables remain untouched by seeds
98 tables have no seed INSERT. Most are expected-empty support tables (integration, system rules, search, template pipeline, security governance, audit support). **Notable untouched-but-should-be-seeded**: `committee.review_answers`, `committee.review_scores`, `committee.review_conflicts`, `committee.member_qualifications/terms/conflicts`, `committee.committee_member_roles`, `workflow.workflow_sla`, `workflow.workflow_tasks`, `reporting.kpi_results`, `reporting.analytics_snapshots`, `documents.document_approvals`, `core.application_checklists/sections/validations`.

### 8.4 Seed scripts with no visible effect (silent no-ops)
| Seed | Empty targets (of its insert list) | Root cause |
|------|-----------------------------------|-----------|
| `17-safety-data.sql` | 8 safety tables | `INSERT...SELECT` anchored to `APP-2024-001/002/003/005` + `ethics_admin` — no such application numbers (baseline is `APP-2025-*`) |
| `18-monitoring-data.sql` | 10 monitoring tables | Same `APP-2024-*` dependency (v_app1/2/5) |
| `33-accreditation-seed.sql` | 7 accreditation tables | Standards insert uses `ON CONFLICT (code) DO NOTHING` but dependent `DO $$` blocks resolve `APP-2024-*` apps + legacy committee chairs |
| `28-ethics-risk-assessment.sql` | 2 tables (ethics_risk_assessments, ethics_risk_items) | Ethics-risk items/reviews anchored to legacy review rows |
| `29-informed-consent.sql` | 4 tables (consent_templates, consent_template_versions, application_consents, consent_review_comments) | Consent templates anchored to legacy data; only review_assignments (286) writes from its list |
| `20-remaining-core-data.sql` | 13 of 28 targets | kpi_results, analytics_snapshots, workflow_sla/variables, tags, site_investigators, quorum_logs, review_conflicts/scores, agenda_items, amendment/closure/renewal_requests all empty |
| `90-gen-test-data.sql` | 2 safety targets | safety.adverse_events/corrective_actions empty |
| `95-pilot-dataset.sql` | 2 safety targets | safety.adverse_events/risk_register empty |
| `96-realistic-data.sql` | 6 targets | safety.risk_categories/adverse_events/serious_adverse_events/risk_assessments, quorum_logs, system.audit_log empty |
| `51-accreditation-workflow.sql` | accreditation workflow inserts | No accreditation workflow definition exists — only `APP_REVIEW_V1` (98 instances); the seed's accreditation-specific inserts never run |

### 8.5 Business areas lacking seed coverage
1. **Safety** (adverse events, risk assessment, SAE, follow-ups) — entirely absent.
2. **Monitoring** (plans, visits, findings, CAPA, deviations, inspections) — entirely absent.
3. **Accreditation** (cycles, standards, assessments, conditions, evidence) — entirely absent, plus its workflow.
4. **Informed Consent / Ethics Risk** — absent.
5. **Structured review evidence** — `review_answers` (0), `review_scores` (0), `review_conflicts` (0).
6. **Committee lifecycle** — meetings (2), minutes (0), quorum (0), attendance (4), member terms/qualifications/conflicts (0).
7. **SLA / tasks / escalations** — workflow_sla (0), workflow_tasks (0), escalations (0).
8. **Reporting** — kpi_results (0), analytics_snapshots (0), matviews unrefreshed, report_executions (0).
9. **Document approvals / verification / disposal** — document_approvals (0), verification_log (1), disposal_logs (0).
10. **Templates execution pipeline** — render_jobs/history, usage statistics, validation tests, outputs, packages, localizations, approval workflow all (0).
11. **Application support lifecycle** — checklists/sections/validations (0), amendment/closure/renewal requests (0).
12. **Certificates lifecycle** — certificate_verification_log (0), approval_certificate_documents (0), certificate_revocations (0).

### 8.6 Tables requiring additional realistic production-like data
- `review_answers` (0) — reviewers need structured answer data across the 54 questions.
- `workflow_sla` + `workflow_tasks` — RC4 SLA feature needs SLA records per state and open/overdue tasks.
- `safety.*`, `monitoring.*`, `accreditation.*`, `consent_*`, `ethics_risk_*` — re-seed against `APP-2025-*` numbering.
- `committee_member_roles`, `member_qualifications/terms`, `meeting_minutes`, `quorum_logs`, `attendance_logs` (4), `votes` (2).
- `kpi_results`, `analytics_snapshots`, matview refresh for reporting verification.
- `templates` execution tables + `document_approvals` for Gate-0 approval-chain verification.
- `integration` event_outbox already has 30 rows; remaining integration tables expected-empty.

---

# 9. Referential Integrity Review

### 9.1 Orphan records / broken foreign keys
- **Zero true broken FKs** across all **269** FK constraints (scan: child FK non-NULL but no matching parent — 0 rows).
- 27 FKs carry NULL values on their FK column; **all are legitimate optional columns** (audit `user` for system-generated logs 11,215; `document_access.role_id` 3,956 — grants are user-based; documents `superseded_by/classification/retention/revoked_by`; certificates `revoked_by/superseded_by/created_by`; form audit columns; conditions `deleted_by/updated_by/resolved_by`; applications `submitted_by` 11 = the DRAFT applications).

### 9.2 Nullable FK columns remaining NULL
| Column | NULL count | Justification |
|--------|-----------:|---------------|
| audit_logs.user_id | 11,215 | System/trigger-generated entries (expected) |
| document_access.role_id | 3,956 | All grants are user-based; role-grants never used |
| documents.superseded_by_document_id | 1,062 | No supersession chain used yet |
| documents.classification_id | 1,062 | Classification not assigned to documents |
| documents.retention_rule_id | 1,062 | Retention rules exist (27) but not attached per-document |
| documents.revoked_by | 1,061 | No revocations |
| user_profiles.academic_title_id | 101 | Titles exist (11) but not linked to profiles |
| login_audit.user_id | 73 | System login rows |
| applications.submitted_by | 11 | The 11 DRAFT applications (expected) |
| users.department_id | 10 | Users without department (expected for some roles) |

### 9.3 Parent tables with no children (in-degree 0, populated)
63 populated tables are never referenced by any FK. All are expected leaf/reference/history tables (e.g., audit_details, application_history, project_keywords, document_access, workflow_actions, user_roles, reference lookups, system_config, event_outbox). None indicates missing relational design.

### 9.4 Child tables with no parent
**None.** Every populated child row resolves to a parent; the parent-empty → child-populated scan returned 0 rows.

### 9.5 Junction tables with suspiciously low population
| Junction | Rows | Assessment |
|----------|-----:|-----------|
| committee.committee_member_roles | 0 | **Suspicious** — 57 members, 5 roles exist, but no member-role links |
| security.role_permissions | 114 | Healthy (7 roles × 32 permissions) |
| core.research_population_links | 0 | Expected (feature unused) |
| core.project_site_investigators | 0 | Expected (feature unused) |
| core.project_tags | 0 | Expected (feature unused) |
| committee.review_scores | 0 | **Suspicious** — reviews exist but no scores |
| committee.review_conflicts | 0 | Expected (no conflict cases seeded) |
| communication.message_attachments | 0 | Expected |
| documents.approval_certificate_documents | 0 | Expected (certificates not linked to source docs) |
| templates.template_package_members | 0 | Expected |

---

# 10. Population Statistics

### 10.1 Rows per schema
See **Section 3** (35,208 in audit; 1,645 security; 5,270 documents; 664 workflow; 607 committee; 1,543 core; etc.).

### 10.2 Population percentage per schema
audit 50%, committee 41%, communication 67%, core 52%, documents 81%, forms 100%, integration 10%, monitoring 0%, ops 100%, public 60%, reference 88%, reporting 40%, safety 0%, security 63%, system 31%, templates 38%, workflow 43%.

### 10.3 Distribution metrics
| Metric | Value |
|--------|------:|
| Total rows | 45,453 |
| Populated tables | 112 |
| Avg rows per populated table | **405.8** |
| Median rows (populated) | **12** |
| Median rows (all tables) | 0 |
| Largest table | audit.audit_logs (22,356) |
| Smallest populated | 10 tables with 1 row |

### 10.4 Largest business tables (excl. audit)
documents.document_access 3,956 · documents.documents 1,062 · workflow.workflow_actions 489 · security.login_audit 488 · core.application_history 459 · core.project_keywords 372 · security.sessions 372 · committee.review_assignments 286 · core.project_team_members 141 · security.departments 127 · core.projects 121 · security.role_permissions 114 · core.applications 112.

### 10.5 Largest audit tables
audit.audit_logs 22,356 · audit.audit_details 12,852 · security.login_audit 488 · core.application_history 459 · documents.document_audit 12.

### 10.6 Largest workflow tables
workflow.workflow_actions 489 · workflow.workflow_instances 98 · workflow.workflow_history 30 · workflow.workflow_states 14 · workflow.workflow_transitions 32.

---

# 11. Empty Table Review (122 tables)

Legend: **S** = Should Contain Data, **E** = Expected Empty. Verdicts below are the source of `ShouldHaveSeedData` in `docs/seed-coverage-matrix.csv`.

### 11.1 SHOULD CONTAIN DATA (58) — with justification
| Table | Justification |
|-------|--------------|
| safety.adverse_events, corrective_actions, mitigation_actions, risk_assessments, risk_categories, risk_incidents, risk_mitigations, risk_register, safety_committee_reviews, safety_followups, safety_reports, serious_adverse_events (12) | Seed `17-safety-data.sql` is a silent no-op (APP-2024 anchor). Adverse events/risk/SAE data are RC3-required |
| monitoring.compliance_reviews, corrective_actions, deviations, inspection_reports, inspections, monitoring_findings, monitoring_plans, monitoring_visits, preventive_actions, protocol_violations (10) | Seed `18-monitoring-data.sql` silent no-op. Monitoring plans/visits/CAPA are part of the reviewed-data model |
| committee.accreditation_standards, standard_versions, cycles, decisions, assessments, assessment_items, conditions, evidence, cycle_metrics (9) | Seed `33-accreditation-seed.sql` no-op; accreditation is an RC3 scope deliverable |
| committee.consent_templates, consent_template_versions, core.application_consents (3) | Seed `29-informed-consent.sql` no-op |
| committee.ethics_risk_assessments, ethics_risk_items (2) | Seed `28-ethics-risk-assessment.sql` no-op |
| committee.review_answers, review_scores, review_conflicts (3) | 286 assignments + 73/67 completed reviews exist; structured answer/score capture never exercised |
| committee.committee_member_roles (1) | 57 members and 5 roles exist but no member-role mapping |
| committee.member_qualifications, member_terms, member_conflicts (3) | 57 members exist; lifecycle/conflict tracking unused |
| committee.meeting_minutes, quorum_logs (2) | 2 meetings exist but no minutes or quorum logs |
| committee.agenda_items (1) | Meetings exist (2) but no agenda items tracked |
| workflow.workflow_sla, workflow_tasks (2) | RC4 SLA in-scope; SLA columns/tables have zero data |
| reporting.kpi_results, analytics_snapshots, report_executions (3) | Dashboard widgets/definitions exist; no KPI/analytics/execution data (matviews unrefreshed) |
| documents.document_approvals (1) | Gate-0 approval chain unexercised (only 2 signatures) |
| core.application_checklists, application_sections, application_validations (3) | Form-driven application support tables unused |
| core.amendment_requests, closure_requests, renewal_requests (3) | Endpoints exist (RC4 F-07/F-08); no request data |

### 11.2 EXPECTED EMPTY (64) — representative justification
| Group | Tables | Why expected |
|-------|--------|--------------|
| Security governance | approval_authorities/limits, certificate_revocations, digital_certificates, policy_conditions/rules, role_delegations, segregation_rules, security_events | Enforcement/policy features not yet activated |
| Auth support | password_reset_tokens | No resets issued in seed window |
| System | audit_log, business_rules, rule_*, feature_flags (0), maintenance_log, push_config, search_audit, search_indexes | Rule engine/search/maintenance not exercised; system_config/audit_config/email/sms already populated |
| Templates pipeline | event_template_mapping, template_approval_workflow, template_localizations, template_outputs, template_package_members/packages, render_history/jobs, usage_statistics, validation_tests | Template definitions exist (12+13); execution pipeline not run |
| Workflow support | workflow_comments, escalations, events, schedulers, triggers, variables | APP_REVIEW_V1 runs without these support mechanisms |
| Integration | data_sync_jobs, event_bus_config, event_subscriptions, external_systems, integration_credentials/failures/logs, retry_queue, webhooks | Integrations explicitly out of RC4 scope (event_outbox 30 is the only populated table) |
| Auditing | entity_changes, hash_ledger | Supplemental audit tables not in use (audit_logs/details are) |
| Reference | institutions_registry, licenses_registry | Registries unused until enrollment flows |
| Documents | certificate_verification_log (1 → borderline S/Minimal), document_disposal_logs, approval_certificate_documents | Verification/disposal not exercised |
| Meetings | agenda_items counted in §11.1; attendance_logs (4) minimal | Meeting tracking barely exercised |
| Applications | research_population_links, project_attachments, project_versions, project_site_investigators, project_tags | Optional feature tables |
| Communication | announcements, message_attachments, user_notification_preferences | Channels/notifications configured but unused |
| Consent | committee.consent_review_comments | Consent flow never exercised |
| Utilities | perf_results, pgmigrations | Benchmark/migration bookkeeping |

> **Borderline calls**: `attendance_logs` (4), `meeting_agendas` (1) and `certificate_verification_log` (1) are technically populated but should grow in spirit; they are kept under their current minimal state in Section 5, and the verdict columns in the CSV reflect the "S in spirit" flag where applicable.

---

# 12. Improvement Opportunities

### Missing reference data
- `review_scores` schema for scoring, `review_conflicts` scenarios, `member_qualifications/terms`, `committee_member_roles`.
- `workflow_sla` definitions per state; `workflow_tasks` templates.
- `document_approvals` chain data and per-document `retention_rule_id` linkage (rules exist, 27, but never applied to documents).

### Missing workflow scenarios
- Accreditation workflow definition + instances (no `ACCREDITATION_*` workflow at all).
- SLA-driven task creation, escalations, triggers, schedulers (all support tables empty).
- Renewal, closure, amendment, withdrawal edge-case instances (only 7 amendments, 0 closure/renewal requests).

### Missing document scenarios
- Document supersession chains (0), revocations (0), classifications (0 assigned), per-document retention (0), approval workflows (0), disposal logs (0), certificate verification (1), multi-version flows (36 versions for 1,062 docs — mostly single-version).

### Missing reporting scenarios
- KPI results (0), analytics snapshots (0), unrefreshed matviews, no report executions.

### Missing notification scenarios
- Announcements (0), notification preferences (0), channel routing logs sparse (12).

### Missing committee scenarios
- Meeting minutes (0), quorum logs (0), attendance (4), votes (2), member lifecycle (0), member-role mapping (0), conflict declarations (0).

### Missing historical data
- Login/audit history is healthy (488/35,208), but no aging/archival scenarios; `application_history` 459 for 112 apps (~4 per app) is realistic but no long-horizon (multi-year) data.

### Missing edge-case data
- `EVIDENCE_REJECTED` applications (1), `RETURNED` (1), `INITIAL_REVIEW` (1) are under-represented vs. a production distribution; zero `review_answers` at all states; zero withdrawn-during-review cases with evidence; zero rejected-with-SAE-followup safety data.

### Missing production-like datasets
- Safety, monitoring, accreditation, consent, ethics-risk (all empty).
- A realistic multi-committee workload beyond SUREC_31 (49 of 112 apps) — TRC_33 (4), SHEC_26 (3), NRC_YE (1) are thin.

---

# 13. Recommendations (prioritized for next Seed Enhancement Sprint)

### CRITICAL
1. **Repoint seeds `17-safety-data.sql`, `18-monitoring-data.sql`, `33-accreditation-seed.sql` (and `28`/`29`) from `APP-2024-*` anchors to the `APP-2025-*` baseline** (or resolve application IDs by `application_number` prefix/pattern instead of exact 2024 numbers). This resurrects safety, monitoring, accreditation, consent, and ethics-risk data in one change.
2. **Create the accreditation workflow** (definition, states, transitions) in `51-accreditation-workflow.sql` — currently only `APP_REVIEW_V1` exists; accreditation seeds depend on it.
3. **Seed `workflow_sla` + `workflow_tasks`** for the `APP_REVIEW_V1` states so RC4 SLA tracking has data to verify against.

### HIGH
4. **Seed structured review evidence**: `review_answers` (rows per review_question × completed review), `review_scores`, `review_comments` (currently 3) to make the review workflow data-complete.
5. **Seed committee lifecycle**: `committee_member_roles` (57 members → 5 roles), `member_qualifications`, `member_terms`, and meeting `minutes` + `quorum_logs` + more `attendance_logs`/`votes`.
6. **Populate `document_approvals`** and assign `retention_rule_id`/`classification_id` to existing documents to exercise Gate-0 approval/retention.
7. **Refresh the two reporting matviews** and seed `kpi_results` + `analytics_snapshots` for RC4 dashboard/report verification.
8. **Add renewal/closure/amendment request instances** (endpoints exist; currently 0) for RC4 F-07/F-08 verification.
9. **Rebalance application distribution** — add more `TRC_33`/`SHEC_26`/`NRC_YE` workloads and more edge-case statuses (`RETURNED`, `INITIAL_REVIEW`, `EVIDENCE_REJECTED`).

### MEDIUM
10. **Seed application support tables** (`application_checklists`, `application_sections`, `application_validations`) and project optional tables (`tags`, `site_investigators`, `population_links`).
11. **Seed template execution data** (`template_render_jobs`, `render_history`, `usage_statistics`, `outputs`, `localizations`, `validation_tests`) once render pipeline lands.
12. **Add announcement + notification preference rows** for RC4 notification-preferences UI.
13. **Add certificate verification + disposal + approval_certificate_documents scenarios** for Gate-0 certificate lifecycle.

### LOW
14. **Seed document supersession/revocation chains** for versioning edge cases.
15. **Populate `system.feature_flags`** if flag-driven rollout is planned; leave rule engine/search tables empty until features ship.
16. **Add `password_reset_tokens` + `security_events`** when security tooling is exercised (keep empty for now).
17. **Keep integration tables empty** (except event_outbox) until integrations are in scope; add config seeds alongside feature work.

---

# Appendix A — Method & Reproducibility
- Exact counts: `SELECT count(*)` loop over `information_schema.tables` (BASE TABLE, non-system schemas) → `baseline_counts.csv` (234 rows).
- Schema/sequence/function/trigger/index counts: `pg_catalog` introspection (functions incl. 2 aggregates; triggers exclude internal; indexes exclude `pg_toast`).
- PK/FK/referenced-by: `pg_constraint` + `pg_attribute` + `pg_namespace` (269 FKs; 230 PKs; 4 PK-less utility tables).
- Broken-FK scan: for each FK, `count(*) WHERE child.fk IS NOT NULL AND NOT EXISTS(parent)`; NULL-FK scan separately.
- Distribution queries grouped by status/type; column names verified against `information_schema.columns` before each query.
- Seed mapping: regex scan of all seed `.sql` files for `INSERT INTO` targets (`seedmap.txt`); counts are table totals, not per-seed attribution (see §8.1).
- Live-drift caveat: dev server was running; snapshot is point-in-time at 2026-08-05 17:05 UTC.

# Appendix B — Deliverables
- **`docs/database-population-audit.md`** — this report.
- **`docs/database-table-inventory.csv`** — 234-row inventory (Schema, Table, Row Count, Population Status, Business Module, Business Critical, Seeded, Notes, PK, FKs, ReferencedBy).
- **`docs/seed-coverage-matrix.md`** + **`docs/seed-coverage-matrix.csv`** — 234-row seed/coverage matrix (Schema, Table, Rows, Seeded, Business Critical, Should Have Seed Data, Current Coverage, Recommended Coverage, Priority, Notes).
