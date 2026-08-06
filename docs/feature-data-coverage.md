# Feature / Data Coverage — 17 modules of `ethics_db`

**Task:** RC4 Phase-2 — assess per-feature data coverage (schema tables ↔ seeds ↔ backend modules).
**Method:** Cross-referenced from `table-classification.csv`, `module_coverage.csv`, `seed_insert_map.csv`, `backend_usage.csv`, and `database-population-audit.md`. All row counts are the verified 2026-08-05 baseline.
**Artifact:** `module_coverage.csv` (schema-level coverage matrix).

---

# 1. Coverage Matrix (17 modules)

| Module (schema) | Tables | Populated | Empty | Rows | Tables with seed INSERT | Seed coverage % | Backend usage (QUERIED/READ) | Verdict |
|-----------------|-------:|----------:|------:|-----:|------------------------:|----------------:|-----------------------------:|---------|
| audit | 4 | 2 | 2 | 35,208 | 2 | 50% | 2 | GOOD (runtime/trigger-fed) |
| committee | 41 | 17 | 24 | 607 | 36 | 88% | 29 | PARTIAL (accreditation/consent/risk empty) |
| communication | 9 | 6 | 3 | 163 | 7 | 78% | 5 | PARTIAL |
| core | 25 | 13 | 12 | 1,543 | 15 | 60% | 18 | PARTIAL (amendments/checklists empty) |
| documents | 21 | 17 | 4 | 5,270 | 15 | 71% | 15 | GOOD (Gate-0 target) |
| forms | 2 | 2 | 0 | 33 | 1 | 50% | 1 | GOOD |
| integration | 10 | 1 | 9 | 30 | 0 | 0% | 1 | EMPTY (out of RC4 scope) |
| monitoring | 10 | 0 | 10 | 0 | 10 | 100%* | 0 | **EMPTY — silent no-op** |
| ops | 1 | 1 | 0 | 78 | 0 | 0% | 1 | GOOD (tracker) |
| public | 5 | 3 | 2 | 3 | 0 | 0% | 1 | PARTIAL (functions only) |
| reference | 16 | 14 | 2 | 88 | 13 | 81% | 3 | GOOD |
| reporting | 5 | 2 | 3 | 11 | 4 | 80% | 3 | **EMPTY-ish (matviews dead)** |
| safety | 12 | 0 | 12 | 0 | 10 | 83%* | 1 | **EMPTY — silent no-op** |
| security | 27 | 17 | 10 | 1,645 | 15 | 56% | 20 | PARTIAL (runtime tables empty) |
| system | 16 | 5 | 11 | 20 | 1 | 6% | 3 | **EMPTY-ish (config/rules unused)** |
| templates | 16 | 6 | 10 | 90 | 0 | 0% | 0 | PARTIAL (definitions only) |
| workflow | 14 | 6 | 8 | 664 | 7 | 50% | 7 | GOOD (APP_REVIEW_V1 live) |
| **Total** | **234** | **112** | **122** | **45,453** | **118** | | **86 QUERIED** | |

> `*` coverage % is high because a seed *targets* the schema — the target's inserts are no-ops (see §3). Coverage-by-target ≠ coverage-by-rows.

---

# 2. Module deep-dives

## 2.1 Committee (41 tables) — largest domain, 17/41 populated
**Feeder seeds:** `03-committees`, `08-reviews`, `09-meetings-etc`, `21-committee-expansion`, `53-yemen-applications`, `95-pilot-dataset`, `96-realistic-data`, `20-remaining-core-data`, `28-ethics-risk-assessment`, `29-informed-consent`, `33-accreditation-seed`.

**Populated:** committees (8), members (60), review_assignments (286), review_forms, scientific/ethics_reviews, application_conditions, meetings (2), votes.
**Empty (24):** `accreditation_*` (9), `consent_templates`/`consent_template_versions`, `ethics_risk_assessments`/`ethics_risk_items`, `review_answers`/`review_scores`/`review_conflicts`, `member_qualifications`/`member_terms`/`member_conflicts`, `meeting_minutes`, `quorum_logs`, `agenda_items`, `committee_member_roles`.
**Root causes:** 28/29/33 no-op on dead `APP-2024-*` anchors; 20-remaining-core-data no-ops; review_answers/scores/conflicts never exercised (286 assignments exist but only 73/67 completed).

## 2.2 Documents (21 tables) — 17/21 populated, best coverage
**Feeder seeds:** `04-documents`, `54-yemen-documents`, `55/56-forms-library(-templates)`, `45-certificates`, `57-60-gate0-*`, `58-official-templates-en`, `63-document-retention-rules`, `64-application-registration`, `20-remaining-core-data`.
**Populated:** documents (1,062), document_types (28), templates (12+13), document_versions, document_access, approval_certificates (57), lifecycle tables.
**Empty (4):** `document_audit` (trigger-only), `document_signatures` (2 only → Minimal), `approval_certificate_documents`, `document_disposal_logs` (verification/disposal not exercised).

## 2.3 Core Applications (25 tables) — value chain intact, edges empty
**Feeder seeds:** `06-projects-apps`, `52-yemen-projects`, `53-yemen-applications`, `21-committee-expansion`, `20-remaining-core-data`, `64-application-registration`.
**Populated:** applications (112, all 14 statuses), projects (121), project_sites, application_history, workflow instances (98).
**Empty (12):** `application_amendments`, `amendment_requests`, `closure_requests`, `renewal_requests`, `application_checklists/sections/validations`, `research_population_links`, `project_attachments/versions/site_investigators/tags`.

## 2.4 Safety (12 tables) — **entirely empty**
**Feeder seeds:** `17-safety-data`, `90-gen-test-data`, `95-pilot-dataset`, `96-realistic-data`.
All 12 tables (risk_categories, risk_assessments, mitigation_actions, corrective_actions, adverse_events, serious_adverse_events, risk_incidents, risk_mitigations, risk_register, safety_reports, safety_followups, safety_committee_reviews) = **0 rows**.
`17-safety-data` anchors to `APP-2024-*` (absent) → inserts nothing. 90/95/96 safety inserts also reference demo users/apps → 0 rows. This is the **largest single-domain gap** and RC3-required.

## 2.5 Monitoring (10 tables) — **entirely empty**
**Feeder seed:** `18-monitoring-data` (only) — anchors to `APP-2024-*` → 0 rows. All 10 tables empty: monitoring_plans, monitoring_visits, monitoring_findings, compliance_reviews, deviations, inspections, inspection_reports, protocol_violations, corrective_actions, preventive_actions.

## 2.6 Security & Users (27 tables) — core alive, governance empty
**Feeder seeds:** `02-users`, `50/51-yemen-*`, `01-reference`, `95/96-*`, `90-gen-test-data`.
**Populated:** users (106), roles (7), user_roles, user_profiles, institutions (41), departments, sessions, login_audit, password_history, api_keys.
**Empty (10):** `approval_authorities`/`approval_limits`, `certificate_revocations`, `digital_certificates`, `policy_conditions`/`policy_rules`, `role_delegations`, `segregation_rules`, `security_events`, `password_reset_tokens` — governance/enforcement features not activated (expected-empty per audit §11.2).

## 2.7 Workflow (14 tables) — engine live, support tables empty
**Feeder seeds:** `05-workflow`, `07-workflow-instances`, `36/37-workflow-add-*`, `40-init-workflow-idempotent`, `53-yemen-applications`, `20-remaining-core-data`, `51-accreditation-workflow`.
**Populated:** workflows (1: `APP_REVIEW_V1` only), workflow_states (14), workflow_transitions (32), workflow_instances (98), workflow_actions, workflow_comments.
**Empty (8):** `workflow_sla`/`workflow_tasks` (RC4 SLA in-scope — zero data), `workflow_escalations/events/schedulers/triggers/variables`, `workflow_comments` (actually populated? see baseline), `accreditation workflow definition` (see below).

## 2.8 Reference (16 tables) — healthy
13/16 tables with seed inserts; 14/16 populated (institution_types 4, roles 7, application_statuses 14, lookups, academic titles, etc.). 2 empty: `institutions_registry`, `licenses_registry` (expected-empty until enrollment flows).

## 2.9 Reporting (5 tables) — provisioned, dead
**Feeder seed:** `20-remaining-core-data` (no-op).
`kpi_results`, `analytics_snapshots`, `report_executions` empty. 2 populated (report_definitions?). Both matviews (`mv_committee_performance`, `mv_daily_application_snapshot`) unpopulated, never refreshed, unreferenced by backend.

## 2.10 System (16 tables) — **nearly empty**
**Feeder seed:** `96-realistic-data` (tiny). 11/16 empty: `system_config`/`audit_config`/`email_config`/`sms_config`/`push_config`/`feature_flags`, `business_rules`, `rule_*`, `search_*`, `saved_searches`, `maintenance_log`. Only `search_*`? verify — the schema runs on defaults.

## 2.11 Templates (16 tables) — definitions only
`templates` (12), `template_versions` (13), `template_partials` (5), `template_variables` (44) populated; render/usage/validation pipeline tables empty (no seed targets, runtime-only). No seed file targets the `templates` schema.

## 2.12 Integration (10 tables) — out of RC4 scope
Only `event_outbox` (30) has rows; rest empty; no seed targets (correct).

---

# 3. Root-cause summary (why coverage is "empty despite seeds")

Every empty-but-seeded domain shares the **dead-anchor no-op** pattern from `seed-architecture-review.md` §3:

| Domain | Feeder seed(s) | Anchor that's gone |
|--------|----------------|--------------------|
| safety | 17-safety-data, 90, 95, 96 | `APP-2024-001..005`, `researcher1..2`, `reviewer1..2` |
| monitoring | 18-monitoring-data | `APP-2024-001..005`, demo users |
| accreditation | 33-accreditation-seed | `sanaa_chair`, `aden_chair` (demo users) |
| consent | 29-informed-consent | `APP-2024-*`, `ethics_admin`, `reviewer1..2` |
| ethics-risk | 28-ethics-risk-assessment | `APP-2024-*`, `ethics_admin`, `reviewer1..2` |
| reporting / SLA / meeting artifacts | 20-remaining-core-data | `APP-2024-*`, demo users |

---

# 4. Feature-level coverage (RC4 in-scope features)

| RC4 feature | Data present? | Detail |
|-------------|--------------|--------|
| PDF certificate generation (F-01) | ✓ | 57 `approval_certificates`; template `APPROVAL_CERTIFICATE_V1` (created by 45, populated by 54) |
| Application templates (F-02) | ✓ | `documents.templates` 25 rows (12 official + 13 forms-library) |
| SLA tracking (F-04) | ✗ | `workflow_sla`, `workflow_tasks` = 0 |
| Meeting packs (F-05) | ✗ | `meeting_minutes`/`agenda_items`/`quorum_logs` = 0; only 2 meetings |
| Scheduled reports (F-06) | ✗ | `report_executions` = 0; matviews dead |
| Renewal UI (F-07) | ✗ | `renewal_requests` = 0 (endpoint exists) |
| Appeal UI (F-08) | ✗ | no appeal table data |
| Certificate verification (F-09) | ⚠ | function exists (`47-public-verify-function`); `certificate_verification_log` ~0 |
| Dashboard widgets | ✗ | `analytics_snapshots`, `kpi_results` = 0 |
| Audit trail export | ✓ | 35,208 audit rows (audit_logs 22,356 + details 12,852) |
| Safety module (i18n) | ✗ | safety domain 100% empty |
| Notification preferences | ⚠ | table exists + RLS; `user_notification_preferences` ~0 |

---

# 5. Recommendations

1. **Fix the anchor class first** (highest leverage): re-seed safety/monitoring/accreditation/consent/ethics-risk against the Yemen dataset (APP-2025/2026 + existing Yemen users), or re-create the demo anchors. This single change populates 4 empty domains + ~58 should-contain tables.
2. **Decide SLA ownership:** `workflow_sla`/`workflow_tasks` are RC4 in-scope and empty — needs a seed or a runtime job.
3. **Refresh or drop matviews:** add `REFRESH MATERIALIZED VIEW` to a job, or remove until reporting is implemented.
4. **Document templates/runtime tables** are intentionally empty; mark them explicitly as runtime-bootstrapped so they aren't re-flagged.
