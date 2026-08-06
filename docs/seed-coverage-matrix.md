# Seed Coverage Matrix — `ethics_db`

**Purpose:** Per-table assessment of seed coverage and data completeness for RC4 seed-enhancement planning. Companion to `docs/database-population-audit.md`.
**Snapshot:** 2026-08-05 17:05 UTC (`baseline_counts.csv`, exact `count(*)`).
**Verdicts:** `CurrentCoverage` = Empty / Minimal / Partially Populated / Well Populated. `Seeded` = Known (appears in ≥1 seed INSERT) / Unknown. `ShouldHaveSeedData` and `Priority` reflect business judgment (see report §11–§13). Full machine-readable data in `docs/seed-coverage-matrix.csv`.

**Totals:** 234 tables | 112 populated, 122 empty | **11 Critical, 77 High, 46 Medium, 100 Low** (priority).

---

## 1. CRITICAL priority (must be part of next Seed Enhancement Sprint)

| Table | Rows | Seeded | Should seed | Why |
|-------|-----:|--------|:-----------:|-----|
| committee.committee_member_roles | 0 | Known | Yes | 57 members + 5 roles exist but zero member-role mappings |
| committee.review_answers | 0 | Known | Yes | 286 assignments / 73+67 completed reviews; no structured answers |
| committee.review_scores | 0 | Unknown | Yes | No review scores ever recorded |
| core.application_checklists | 0 | Unknown | Yes | Form-driven application support unused |
| core.application_sections | 0 | Unknown | Yes | Application sections unused |
| core.application_validations | 0 | Unknown | Yes | Application validation rules unused |
| documents.document_approvals | 0 | Known | Yes | Gate-0 approval chain unexercised (only 2 signatures) |
| reporting.analytics_snapshots | 0 | Known | Yes | No analytics data; matviews unrefreshed |
| reporting.kpi_results | 0 | Known | Yes | No KPI results despite widgets/definitions |
| workflow.workflow_sla | 0 | Known | Yes | RC4 SLA tracking in-scope; zero SLA records |
| workflow.workflow_tasks | 0 | Unknown | Yes | RC4 SLA/task feature; zero tasks |

---

## 2. HIGH priority — empty domains requiring re-seed (seed no-op root cause)

### 2.1 Safety (seed `17-safety-data.sql` no-op — `APP-2024-*` anchor)
`adverse_events`, `corrective_actions`, `mitigation_actions`, `risk_assessments`, `risk_categories`, `risk_incidents`, `risk_mitigations`, `risk_register`, `safety_committee_reviews`, `safety_followups`, `safety_reports`, `serious_adverse_events` — all 0 rows.

### 2.2 Monitoring (seed `18-monitoring-data.sql` no-op)
`monitoring_plans`, `monitoring_visits`, `monitoring_findings`, `corrective_actions`, `preventive_actions`, `compliance_reviews`, `deviations`, `protocol_violations`, `inspections`, `inspection_reports` — all 0 rows.

### 2.3 Accreditation (seed `33-accreditation-seed.sql` no-op + workflow missing)
`accreditation_standards`, `accreditation_standard_versions`, `accreditation_cycles`, `accreditation_decisions`, `accreditation_assessments`, `accreditation_assessment_items`, `accreditation_conditions`, `accreditation_evidence`, `accreditation_cycle_metrics` — all 0 rows. Accreditation workflow definition does not exist.

### 2.4 Informed Consent (seed `29` no-op) and Ethics Risk (seed `28` no-op)
`consent_templates`, `consent_template_versions`, `application_consents`; `ethics_risk_assessments`, `ethics_risk_items` — all 0 rows.

### 2.5 Committee lifecycle (HIGH)
`meeting_minutes` 0, `quorum_logs` 0, `member_qualifications` 0, `member_terms` 0, `member_conflicts` 0, `agenda_items` 0, `review_conflicts` 0.

### 2.6 Application lifecycle requests (HIGH)
`amendment_requests` 0, `closure_requests` 0, `renewal_requests` 0 (endpoints exist, RC4 F-07/F-08).

### 2.7 Documents lifecycle (HIGH)
`document_disposal_logs` 0, `approval_certificate_documents` 0, `certificate_verification_log` 1.

---

## 3. MEDIUM priority

- `core.project_tags`, `core.project_site_investigators`, `core.project_versions`, `core.project_attachments`, `core.research_population_links` (0) — optional project/application support tables.
- `templates` execution tables: `template_render_jobs`, `template_render_history`, `template_usage_statistics`, `template_outputs`, `template_packages`, `template_package_members`, `template_localizations`, `template_validation_tests`, `template_approval_workflow`, `event_template_mapping` (0).
- `reporting.report_executions` (0), `system.feature_flags` (0).
- `communication.announcements` (0), `communication.user_notification_preferences` (0).

---

## 4. LOW priority (expected empty / definition-complete / maintain)

- **Definition/reference tables marked complete** (`Maintain (complete)`): committee_roles (5), committee_types (8), committees (8), roles (7), permissions (32), role_permissions (114), institution_types (4), form_definitions (9), application_statuses (14), workflow definitions, document_types (28), lifecycle states/transitions, signature_types, retention_rules (27), notification channels/templates, departments (127), institutions (41).
- **Expected empty** (no seed needed until features ship): integration.* (9), security governance (8), system rule/search/maintenance (11), workflow support (escalations/triggers/comments/events/schedulers/variables), template pipeline, audit support (entity_changes, hash_ledger), reference registries (institutions_registry, licenses_registry), utilities (perf_results, pgmigrations).
- **Maintain** (already well-populated): core business tables (applications 112, projects 121, documents 1,062, workflow 98 instances, reviews, users 106, sessions 372, audit 35,208).

---

## 5. Should-Have-Seed-Data summary

| Verdict | Scope | Count |
|---------|-------|------:|
| Should seed (Yes) | Empty must-seed + Minimal/Partial enrich + definition-complete tables that still want demo data | 157 |
| None needed (No) | Expected-empty support tables, audit/history, integration (out of scope), utilities | 77 |
| **Total** | | **234** |

---

## 6. Full matrix

The complete 234-row matrix is in **`docs/seed-coverage-matrix.csv`** (Schema, Table, Rows, Seeded, BusinessCritical, ShouldHaveSeedData, CurrentCoverage, RecommendedCoverage, Priority, Notes). The report's Section 8 (seed analysis) and Section 11 (empty-table review) are the narrative companion to this matrix.
