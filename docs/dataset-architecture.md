# National Validation Dataset — Architecture Document

**Project:** Ethics ERM System  
**Phase:** 7 — National Pilot Dataset (Yemen)  
**Status:** Implementation Contract — Pending Approval  
**Date:** July 2026

---

## 1. Executive Summary

This document defines the architecture, scope, and implementation strategy for the Yemen National Validation Dataset — the permanent reference dataset for the National Research Ethics Management System.

The dataset represents the Ministry of Health and Environment of the Republic of Yemen, with realistic synthetic data spanning all 14 database schemas, 209 tables, and the APP_REVIEW_V1 workflow. Every subsystem (workflow, committees, certification, accreditation, notifications, reporting, safety, monitoring, integration, auditing) will be exercised with meaningful data.

The implementation follows a strict commit-by-commit strategy, preserving referential integrity at every step. No schema changes, no RLS bypass, and no constraint disabling are allowed.

---

## 2. Objectives

1. Create a **permanent validation dataset** for all future testing (UAT, e2e, integration, regression)
2. Exercise **every workflow state and transition** defined in APP_REVIEW_V1
3. Populate **every table** in the canonical schema with valid, realistic data
4. Verify **RLS policies** for every role and every entity
5. Verify **dashboards, reports, and KPIs** return meaningful results
6. Enable **backup/restore validation** at scale (~10,000+ rows total)
7. Provide **search and filter** test data across all entity types
8. Cover **certificate lifecycle** (Generate → Issue → Revoke → Supersede)
9. Cover **accreditation lifecycle** (Apply → Review → Accredited → Suspended → Revoked → Expired)
10. Cover **notification delivery** across all channels and statuses

---

## 3. Scope

### In Scope

- All 14 schemas defined in the canonical schema
- All 209 tables
- APP_REVIEW_V1 workflow (14 states, 32 transitions)
- All 5 roles (SUPER_ADMIN, ETHICS_ADMIN, RESEARCHER, REVIEWER, COMMITTEE_CHAIR)
- All 29 permissions
- Certificate lifecycle (draft → issuing → issued → revoked/superseded)
- Accreditation lifecycle (6 cycles across committees)
- All notification types and channels
- All dashboard widgets and report definitions
- All RLS policies (implicitly — data must pass RLS)
- Soft delete patterns (deleted_at/deleted_by)

### Out of Scope

- Schema modifications
- RLS policy changes
- Business logic changes
- API modifications
- Workflow definition changes
- Permission/role changes
- Real citizen or participant data
- External system integration data (stub only)
- Performance testing at scale (>50,000 rows)

---

## 4. Assumptions

1. The canonical schema (`database/canonical/`) is the sole authority for database structure
2. The live database matches the canonical schema (verified during Phase A)
3. RLS is enabled on all policy-protected tables
4. The `app.user_id` session parameter is set correctly via `middleware/context.ts`
5. `security.fn_register_user()` is available for user creation (bypasses RLS for registration)
6. Sequence generators can be set via `setval()` after data insertion
7. `session_replication_role = 'replica'` is available for bulk inserts (constraint bypass)
8. All 13 domain modules have corresponding route/service/repository layers
9. Files referenced in `documents.documents.storage_path` will not be actual files — paths are placeholders
10. Passwords are Argon2 hashes (generated via `security.fn_hash_password()`)

---

## 5. Canonical Database Compliance

Every generated row must:

1. Satisfy all **NOT NULL** constraints
2. Satisfy all **CHECK** constraints (status enums, severity levels, score ranges, soft-delete patterns)
3. Satisfy all **UNIQUE** constraints
4. Satisfy all **FOREIGN KEY** constraints
5. Respect **soft-delete** patterns (never hard-delete `deleted_at`-enabled tables)
6. Use valid **sequence** values (no hardcoded IDs that conflict with sequences)
7. Accept **default values** where appropriate
8. Use the **domain type** `documents.certificate_status` for certificate status fields
9. Use the **citext** extension for username and email columns

---

## 6. Current Schema Audit

| Category | Count |
|----------|-------|
| Schemas | 14 |
| Tables | 209 |
| Primary Keys | 209 |
| Foreign Keys | ~250 |
| Unique Constraints | ~180 |
| CHECK Constraints | ~210 |
| Indexes | 13 files (multiple per file) |
| Sequences | 205 |
| Triggers | 225 |
| RLS Policies | 250 |
| Views | 1 (reporting) |
| Materialized Views | 2 (reporting) |
| Functions | 6 files |
| Domains | 1 (`documents.certificate_status`) |
| Extensions | 1 (includes citext, pgcrypto, uuid-ossp) |
| Types | 0 custom enums |
| Procedures | 0 |

---

## 7. Dataset Architecture

### 7.1 Geographic Scope — Republic of Yemen

**Governorates (8):**
| Code | Name | Population (approx) |
|------|------|-------------------|
| SA | Sana'a (الأمانة) | 3,000,000 |
| AD | Aden (عدن) | 1,500,000 |
| TZ | Taiz (تعز) | 2,500,000 |
| HD | Hodeidah (الحديدة) | 2,000,000 |
| IB | Ibb (إب) | 2,000,000 |
| DH | Dhamar (ذمار) | 1,200,000 |
| MK | Mukalla / Hadramawt (المكلا) | 1,800,000 |
| HJ | Hajjah (حجة) | 1,200,000 |

### 7.2 Institution Hierarchy

```
Ministry of Health and Environment (Sana'a)
├── Department of Research & Ethics
├── Department of Disease Control
├── Central Health Laboratory
├── National Institute of Public Health
├── National Oncology Center
├── National Nutrition Institute
├── National Blood Transfusion Center
├── 8 Governorate Health Offices
├── 10 Public Hospitals (across governorates)
│   ├── Internal Medicine
│   ├── Pediatrics
│   ├── Obstetrics & Gynecology
│   ├── Surgery
│   ├── Pharmacy
│   └── Laboratory
├── 5 Teaching Hospitals
├── 5 Medical Faculties (Universities)
│   ├── Basic Sciences
│   ├── Clinical Medicine
│   ├── Pharmacy
│   ├── Nursing
│   └── Public Health
├── 3 National Laboratories
├── 2 Disease Surveillance Centers
└── 2 Research Institutes
```

**Total Institutions:** ~40 (including THU)

### 7.3 Role Distribution

| Role | Count | Scope |
|------|-------|-------|
| SUPER_ADMIN | 1 | System-wide |
| ETHICS_ADMIN | 4 | Ministry + 3 major regions |
| COMMITTEE_CHAIR | 5 | 5 committees |
| COMMITTEE_SECRETARY | 5 | 5 committees |
| REVIEWER | 25 | Scientific + Ethics + Legal + Biosafety |
| RESEARCHER | 40 | Across all institutions |
| INSTITUTIONAL_COORDINATOR | 8 | Governorate offices |
| AUDITOR | 3 | Ministry |
| READ_ONLY | 5 | Ministry observers |
| **Total** | **96** | |

### 7.4 Committee Structure

| Committee | Type | Institution | Members |
|-----------|------|-------------|---------|
| IRB — Sana'a | IRB | Ministry of Health | 11 |
| IRB — Aden | IRB | Aden Health Office | 9 |
| REC — Sana'a University | REC | Sana'a Medical Faculty | 9 |
| IACUC — National Lab | IACUC | Central Health Lab | 7 |
| IBC — Research Institute | IBC | National Institute of Health | 7 |

---

## 8. Entity Inventory (Complete)

### security (22 tables)

| Table | Type | Target Rows | Notes |
|-------|------|-------------|-------|
| users | Transactional | 96 | All roles |
| institutions | Reference + Transactional | 41 | 1 existing THU + 40 new |
| institution_types | Reference | 3 | Existing |
| departments | Transactional | ~120 | Per institution |
| roles | Reference | 5 | Existing |
| permissions | Reference | 29 | Existing |
| role_permissions | Reference | 72 | Existing |
| user_roles | Transactional | 96 | 1 per user |
| user_profiles | Transactional | 96 | 1 per user |
| sessions | Transactional | ~96 | 1 per user |
| login_audit | Transactional | ~200 | Mixed success/failure |
| password_history | Transactional | ~96 | 1 per user |
| api_keys | Transactional | ~10 | For SYSTEM_ADMIN |
| approval_authorities | Reference | ~15 | Per role+committee |
| approval_limits | Reference | ~15 | Per authority |
| certificate_revocations | Reference | 0 | Used by documents |
| digital_certificates | Transactional | ~10 | Admin/Chair users |
| email_verification_tokens | Transactional | ~96 | All users (used or expired) |
| password_reset_tokens | Transactional | ~20 | Some users |
| access_policies | Reference | 7 | Existing |
| policy_rules | Reference | 7 | Existing |
| policy_conditions | Reference | 0 | Existing |
| responsibility_types | Reference | 6 | Existing |
| segregation_rules | Reference | 0 | Existing |
| role_delegations | Transactional | ~10 | Temporary delegations |
| security_events | Transactional | ~50 | Login failures, permission changes |
| user_responsibilities | Transactional | ~45 | Committee roles + institutional roles |

### core (21 tables)

| Table | Type | Target Rows | Notes |
|-------|------|-------------|-------|
| projects | Transactional | 30 | Mix of research topics |
| research_categories | Reference | 8 | Existing |
| risk_classifications | Reference | 4 | Existing |
| vulnerable_populations | Reference | 6 | Existing |
| project_funding_sources | Transactional | ~45 | 1–2 per project |
| project_sites | Transactional | ~45 | 1–2 per project |
| project_site_investigators | Transactional | ~60 | Per site |
| project_team_members | Transactional | ~90 | 3–5 per project |
| project_attachments | Transactional | ~60 | 2–3 per project |
| project_keywords | Transactional | ~90 | 3–5 per project |
| project_tags | Transactional | ~60 | 2–3 per project |
| project_status_history | Transactional | ~60 | Status changes |
| project_versions | Transactional | ~60 | Version history |
| applications | Transactional | 40 | Various workflow states |
| application_amendments | Transactional | ~15 | Some applications |
| amendment_requests | Transactional | ~15 | Per amendment |
| application_checklists | Transactional | ~120 | 3–5 per application |
| application_sections | Transactional | ~160 | 4 per application |
| application_history | Transactional | ~200 | State transitions |
| application_versions | Transactional | ~80 | Version snapshots |
| application_validations | Transactional | ~120 | Validation runs |
| closure_requests | Transactional | ~10 | Applications being closed |
| renewal_requests | Transactional | ~8 | Applications being renewed |
| research_population_links | Transactional | ~40 | Linking projects to vulnerable |
| application_consents | Transactional | ~60 | Consent tracking |

### committee (30 tables)

| Table | Type | Target Rows | Notes |
|-------|------|-------------|-------|
| committee_types | Reference | 8 | Existing |
| committee_roles | Reference | 5 | Existing |
| committees | Transactional | 5 | 5 committees |
| committee_members | Transactional | 43 | Per committee |
| committee_member_roles | Transactional | 43 | Per member's primary role |
| member_terms | Transactional | 43 | Term records |
| member_qualifications | Transactional | 43 | Qualifications |
| member_conflicts | Transactional | ~10 | Declared conflicts |
| committee_meetings | Transactional | ~30 | Historical meetings |
| meeting_agendas | Transactional | ~30 | 1 per meeting |
| agenda_items | Transactional | ~90 | 3 per meeting |
| meeting_minutes | Transactional | ~25 | Most meetings |
| attendance_logs | Transactional | ~200 | Attendance records |
| quorum_logs | Transactional | ~30 | 1 per meeting |
| voting_sessions | Transactional | ~40 | Per application per meeting |
| votes | Transactional | ~200 | Per voting session |
| review_forms | Reference | ~8 | Form definitions |
| review_questions | Reference | ~60 | Questions per form |
| review_answers | Transactional | ~300 | Answers per review |
| ethics_reviews | Transactional | ~40 | Review records |
| scientific_reviews | Transactional | ~30 | Review records |
| ethics_risk_assessments | Transactional | ~20 | Risk assessments |
| ethics_risk_items | Transactional | ~80 | Risk line items |
| application_conditions | Transactional | ~60 | Committee conditions |
| review_assignments | Transactional | ~80 | Assignments |
| review_comments | Transactional | ~100 | Reviewer comments |
| review_conflicts | Transactional | ~10 | Conflict declarations |
| review_recommendations | Transactional | ~60 | Recommendations |
| review_scores | Transactional | ~60 | Review scores |
| consent_templates | Reference | ~6 | Template definitions |
| consent_template_versions | Reference | ~12 | 2 versions each |
| consent_review_comments | Transactional | ~20 | Consent review |
| accreditation_standards | Reference | ~20 | Standards library |
| accreditation_standard_versions | Reference | ~25 | Versioned standards |
| accreditation_cycles | Transactional | ~8 | Per committee |
| accreditation_assessments | Transactional | ~16 | 2 per cycle |
| accreditation_assessment_items | Transactional | ~80 | Line items |
| accreditation_conditions | Transactional | ~20 | Accreditation conditions |
| accreditation_evidence | Transactional | ~16 | Evidence per cycle |
| accreditation_decisions | Transactional | ~16 | Decision history |
| accreditation_cycle_metrics | Transactional | ~8 | Metrics per cycle |

### workflow (12 tables)

| Table | Type | Target Rows | Notes |
|-------|------|-------------|-------|
| workflows | Reference | 1 | APP_REVIEW_V1 (existing) |
| workflow_states | Reference | 14 | Existing |
| workflow_transitions | Reference | 32 | Existing |
| workflow_instances | Transactional | 40 | 1 per application |
| workflow_actions | Transactional | ~160 | Actions on instances |
| workflow_history | Transactional | ~160 | State transitions |
| workflow_tasks | Transactional | ~120 | Tasks per workflow |
| workflow_comments | Transactional | ~80 | Comments |
| workflow_escalations | Transactional | ~10 | Escalated tasks |
| workflow_events | Transactional | ~200 | Events per instance |
| workflow_variables | Transactional | ~80 | Per-instance variables |
| workflow_sla | Reference | ~14 | Per-state SLA |
| workflow_schedulers | Reference | ~3 | Scheduler config |
| workflow_triggers | Reference | ~5 | Trigger config |

### documents (14 tables)

| Table | Type | Target Rows | Notes |
|-------|------|-------------|-------|
| document_types | Reference | 9 | Existing |
| document_classifications | Reference | 4 | Existing |
| documents | Transactional | ~200 | Documents per entity |
| document_versions | Transactional | ~250 | Version history |
| document_access | Transactional | ~300 | Access grants |
| document_approvals | Transactional | ~100 | Approvals |
| document_audit | Transactional | ~400 | Audit trail |
| document_signatures | Transactional | ~100 | Signatures |
| document_retention_rules | Reference | ~9 | 1 per type |
| document_disposal_logs | Transactional | ~10 | Disposed documents |
| templates | Reference | 6 | Existing |
| generated_documents | Transactional | ~40 | Generated docs |
| approval_certificates | Transactional | ~15 | Certificate lifecycle |
| approval_certificate_documents | Transactional | ~25 | Links |
| certificate_verification_log | Transactional | ~30 | Verification attempts |

### communication (9 tables)

| Table | Type | Target Rows | Notes |
|-------|------|-------------|-------|
| notification_channels | Reference | 5 | Existing |
| notification_templates | Reference | 8 | Existing |
| notifications | Transactional | ~300 | All types |
| notification_logs | Transactional | ~300 | Delivery logs |
| messages | Transactional | ~150 | Internal messages |
| message_recipients | Transactional | ~300 | Recipients |
| message_attachments | Transactional | ~50 | Attachments |
| announcements | Transactional | ~10 | System announcements |
| user_notification_preferences | Transactional | ~96 | 1 per user |

### safety (10 tables)

| Table | Type | Target Rows | Notes |
|-------|------|-------------|-------|
| risk_categories | Reference | ~8 | Existing + new |
| risk_register | Transactional | ~20 | Risk register entries |
| risk_assessments | Transactional | ~15 | Per application |
| risk_incidents | Transactional | ~10 | Incidents |
| risk_mitigations | Transactional | ~20 | Mitigations |
| corrective_actions | Transactional | ~15 | CAPAs |
| adverse_events | Transactional | ~15 | AE reports |
| serious_adverse_events | Transactional | ~5 | SAE reports |
| safety_followups | Transactional | ~10 | AE follow-ups |
| safety_reports | Transactional | ~10 | DSMB reports |
| safety_committee_reviews | Transactional | ~8 | Committee safety reviews |
| mitigation_actions | Transactional | ~20 | Mitigation actions |

### monitoring (10 tables)

| Table | Type | Target Rows | Notes |
|-------|------|-------------|-------|
| monitoring_plans | Transactional | ~15 | Plans per application |
| monitoring_visits | Transactional | ~30 | Visits per plan |
| monitoring_findings | Transactional | ~40 | Findings per visit |
| corrective_actions | Transactional | ~20 | CAPAs |
| preventive_actions | Transactional | ~10 | Preventive |
| deviations | Transactional | ~10 | Protocol deviations |
| protocol_violations | Transactional | ~8 | Violations |
| inspections | Transactional | ~10 | Inspections |
| inspection_reports | Transactional | ~10 | Reports |
| compliance_reviews | Transactional | ~10 | Compliance |

### reporting (5 tables)

| Table | Type | Target Rows | Notes |
|-------|------|-------------|-------|
| dashboard_widgets | Reference | 6 | Existing |
| report_definitions | Reference | 5 | Existing |
| report_executions | Transactional | ~20 | Execution history |
| kpi_results | Transactional | ~50 | Monthly KPIs |
| analytics_snapshots | Transactional | ~12 | Monthly snapshots |

### system (17 tables)

| Table | Type | Target Rows | Notes |
|-------|------|-------------|-------|
| system_config | Reference | ~10 | Existing |
| audit_config | Reference | ~10 | Existing |
| audit_log | Transactional | ~500 | System audit trail |
| business_rules | Reference | ~5 | Existing |
| rule_versions | Reference | ~5 | Versioned rules |
| rule_conditions | Reference | ~15 | Conditions |
| rule_actions | Reference | ~10 | Actions |
| rule_executions | Transactional | ~30 | Rule execution log |
| feature_flags | Reference | ~5 | Feature flags |
| email_config | Reference | ~2 | SMTP config |
| sms_config | Reference | ~1 | SMS config |
| push_config | Reference | ~1 | Push config |
| saved_searches | Transactional | ~15 | Saved searches |
| search_audit | Transactional | ~50 | Search log |
| search_indexes | Transactional | ~500 | TSVECTOR index |
| maintenance_log | Transactional | ~10 | Maintenance events |

### integration (10 tables)

| Table | Type | Target Rows | Notes |
|-------|------|-------------|-------|
| external_systems | Reference | ~3 | System references |
| integration_credentials | Reference | ~3 | API keys |
| integration_logs | Transactional | ~30 | Integration log |
| integration_failures | Transactional | ~10 | Failures |
| event_bus_config | Reference | ~5 | Config |
| event_subscriptions | Reference | ~5 | Subscriptions |
| event_outbox | Transactional | ~30 | Outbox events |
| webhooks | Reference | ~3 | Webhook configs |
| data_sync_jobs | Transactional | ~10 | Sync jobs |
| retry_queue | Transactional | ~10 | Retry entries |

### audit (4 tables)

| Table | Type | Target Rows | Notes |
|-------|------|-------------|-------|
| audit_logs | Transactional | ~500 | Audit entries |
| audit_details | Transactional | ~1000 | Field changes |
| entity_changes | Transactional | ~500 | Entity change log |
| hash_ledger | Transactional | ~500 | Hash chain |

### reference (15 tables)

| Table | Type | Target Rows | Notes |
|-------|------|-------------|-------|
| All 15 tables | Reference | Existing data | Preserved as-is |

### Public (5 tables)

| Table | Type | Target Rows | Notes |
|-------|------|-------------|-------|
| pgmigrations | Reference | Existing | Preserved |
| perf_results | Utility | ~20 | Performance data |
| v_chair_id, v_inst_codes, v_user_id | Utility | 1 each | Views |

---

## 9. Entity Distribution Summary

| Category | Tables | Existing Rows | Target Rows | New Rows |
|----------|--------|---------------|-------------|----------|
| Reference data | ~45 | ~250 | ~250 | 0 |
| Users & Security | ~20 | ~5 | ~600 | ~595 |
| Projects & Applications | ~20 | 0 | ~700 | ~700 |
| Committee | ~30 | 0 | ~1,300 | ~1,300 |
| Workflow | ~10 | 47 | ~900 | ~850 |
| Documents | ~15 | 0 | ~1,500 | ~1,500 |
| Communication | ~10 | 0 | ~1,200 | ~1,200 |
| Safety | ~10 | 0 | ~150 | ~150 |
| Monitoring | ~10 | 0 | ~150 | ~150 |
| Reporting | ~5 | 11 | ~100 | ~90 |
| System | ~15 | ~20 | ~700 | ~680 |
| Integration | ~10 | 0 | ~110 | ~110 |
| Audit | ~4 | 0 | ~2,500 | ~2,500 |
| **Total** | **~164** | **~333** | **~10,260** | **~9,925** |

---

## 10. Workflow Coverage Matrix

### APP_REVIEW_V1 — 14 States

| State | Terminal | Applications | Transitions Used | Notes |
|-------|----------|-------------|------------------|-------|
| DRAFT | No | 5 | SUBMIT | Unsubmitted drafts |
| SUBMITTED | No | 4 | ASSIGN_SCIENTIFIC_REVIEW, RETURN | New submissions |
| INITIAL_REVIEW | No | 3 | ASSIGN_SCIENTIFIC_REVIEW, ASSIGN_ETHICAL_REVIEW | Initial screening |
| SCIENTIFIC_REVIEW | No | 4 | COMPLETE_SCIENTIFIC_REVIEW, RETURN | Scientific review |
| ETHICAL_REVIEW | No | 4 | COMPLETE_ETHICAL_REVIEW, RETURN | Ethics review |
| COMMITTEE_REVIEW | No | 4 | APPROVE, REJECT, RETURN, SET_CONDITIONS | Full committee |
| APPROVED | No | 4 | ISSUE_CERTIFICATE, CLOSE | Non-terminal per RULE 11 |
| REJECTED | Yes | 3 | ARCHIVE | Terminal |
| RETURNED | No | 3 | RESUBMIT | Returned for revision |
| AWAITING_CONDITIONS | No | 4 | SUBMIT_EVIDENCE | Conditional approval |
| EVIDENCE_REJECTED | No | 2 | SUBMIT_EVIDENCE | Evidence rejected |
| WITHDRAWN | Yes | 2 | (none) | Applicant withdrawal |
| CLOSED | No | 2 | ARCHIVE | Non-terminal per RULE 11 |
| ARCHIVED | Yes | 2 | (none) | Terminal |

**Coverage Goal:** 100% of states, 100% of transitions

### Condition Status Coverage

| Status | Count | Notes |
|--------|-------|-------|
| OPEN | ~20 | Active conditions |
| MET | ~15 | Satisfied |
| NOT_MET | ~5 | Failed conditions |
| WAIVED | ~3 | Committee-waived |

### Workflow Transition Coverage

Need to discover all 32 transitions from canonical DB and verify each is used.

---

## 11. Dashboard Coverage Matrix

| Widget | Expected Values | Notes |
|--------|----------------|-------|
| Total Applications | 40 | Sum of all |
| Applications by Status | 14 bars | One per state |
| Pending Reviews | ~20 | In review states |
| Approval Rate | ~40% | APPROVED / Total submitted |
| Average Review Time | ~30 days | Calculation |
| Committee Workload | 5 committees | Applications per committee |
| Recent Activity | 20 entries | Latest actions |
| User Distribution | 8 types | By role |
| Institution Distribution | 41 institutions | By project count |
| Risk Level Distribution | 4 levels | MINOR, MODERATE, MAJOR, CRITICAL |
| Certificate Summary | 15 | By status |

---

## 12. Report Coverage Matrix

| Report | Data Available | Filters Testable |
|--------|---------------|-----------------|
| Applications Report | Yes | Status, committee, date, risk |
| Committee Report | Yes | Committee, date, member |
| User Activity Report | Yes | User, role, date |
| Compliance Report | Yes | Application, status |
| Safety Report | Yes | Type, severity, date |
| Certificate Report | Yes | Status, type, date |
| Accreditation Report | Yes | Cycle, status, committee |
| Audit Report | Yes | Entity, user, date |
| KPI Report | Yes | KPI, month |
| Dashboard Report | Yes | Widget, date |

---

## 13. API Coverage Matrix

Each API endpoint should be testable with meaningful data:

| Module | Endpoints | Test Data |
|--------|-----------|-----------|
| Auth | login, register, refresh, logout | 96 users |
| Users | CRUD, profile, roles, permissions | Multiple roles |
| Institutions | CRUD, departments | 41 institutions |
| Projects | CRUD, team, sites, funding, keywords | 30 projects |
| Applications | CRUD, submit, withdraw, history, versions | 40 applications |
| Committees | CRUD, members, meetings, agendas | 5 committees |
| Reviews | assign, submit, complete, scores | Scientific + ethics |
| Workflow | advance, history, tasks, comments | All states |
| Documents | upload, version, sign, approve | 200+ documents |
| Certificates | issue, verify, revoke, supersede | 15+ certificates |
| Notifications | list, mark-read, preferences | 300+ notifications |
| Messages | send, list, attachments | 150 messages |
| Safety | AE, SAE, risk, reports | Adverse events |
| Monitoring | plans, visits, findings, CAPA | Plans + visits |
| Accreditation | cycles, assess, decide | 8 cycles |
| Reports | execute, export, schedule | 5 definitions |
| Dashboards | widgets, data | 6 widgets |
| Search | entity search, saved searches | All entities |
| Audit | logs, details, entity changes | Audit trail |

---

## 14. Security & RLS Coverage Matrix

### Roles to Test

| Role | Users | Can View Own | Can View All | Can Edit | Can Delete |
|------|-------|-------------|-------------|----------|------------|
| SUPER_ADMIN | 1 | Yes | Yes | Yes | Yes |
| ETHICS_ADMIN | 4 | Yes | Institution | Yes | Yes |
| COMMITTEE_CHAIR | 5 | Yes | Committee | Yes | Via committee |
| REVIEWER | 25 | Yes | Assigned | Assigned | No |
| RESEARCHER | 40 | Own | No | Own | Own (limited) |
| INST_COORDINATOR | 8 | Yes | Institution | Limited | No |
| AUDITOR | 3 | Yes | Read-only | No | No |
| READ_ONLY | 5 | Yes | Read-only | No | No |

### RLS Policy Verification

| Table | RLS Enabled | INSERT | SELECT | UPDATE | DELETE |
|-------|-------------|--------|--------|--------|--------|
| security.users | Yes | Via fn_register | Self+admin | Self+admin | Admin only |
| core.projects | Yes | Owner+admin | Owner+institution+admin | Owner+admin | Soft delete |
| core.applications | Yes | Owner+admin | Owner+committee+admin | Per state | Soft delete |
| committee.applications_conditions | Yes | Committee+admin | Owner+committee+admin | Per state | Soft delete |
| documents.documents | Yes | Owner+admin | Owner+committee+admin | Per RULE 12 | Soft delete only |
| ... (250+ policies total) | | | | | |

---

## 15. Notification Coverage

| Notification Type | Channel | Count | Status Mix |
|------------------|---------|-------|------------|
| Workflow transition | IN_APP, EMAIL | ~80 | Read/unread |
| Condition reminder | IN_APP, EMAIL | ~20 | Read/unread |
| Evidence submitted | IN_APP | ~15 | Read/unread |
| Meeting scheduled | IN_APP, EMAIL | ~15 | Read/unread |
| Certificate issued | IN_APP, EMAIL | ~15 | Read/unread |
| Certificate revoked | IN_APP | ~3 | Read/unread |
| Review assigned | IN_APP, EMAIL | ~40 | Read/unread |
| Review completed | IN_APP | ~30 | Read/unread |
| Message received | IN_APP | ~80 | Read/unread |
| System announcement | IN_APP | ~10 | Read/unread |

**Delivery Status Mix:** PENDING (20), SENT (100), DELIVERED (100), FAILED (10), RETRYING (5)

---

## 16. Certificate Coverage

| Status | Count | Notes |
|--------|-------|-------|
| GENERATING | 1 | In process |
| ISSUED | 8 | Active certificates |
| FAILED | 1 | Generation error |
| REVOKED | 3 | Revoked after issuance |
| SUPERSEDED | 2 | Replaced by newer version |

**Verification Log Mix:** VALID (15), REVOKED (5), SUPERSEDED (3), NOT_FOUND (2), ERROR (1)

---

## 17. Accreditation Coverage

| Status | Cycles | Notes |
|--------|--------|-------|
| PENDING | 1 | Not yet started |
| UNDER_REVIEW | 1 | Active review |
| ACCREDITED | 2 | Successfully accredited |
| CONDITIONAL | 1 | Accredited with conditions |
| SUSPENDED | 1 | Suspended |
| EXPIRED | 1 | Expired cycle |
| REVOKED | 1 | Accreditation revoked |

---

## 18. Backup/Restore Validation Coverage

Dataset size target: ~10,000 rows across all tables (sufficient to verify backup/restore timing, integrity, and sequence continuity).

---

## 19. Observability Coverage

| Metric | Expected Value |
|--------|---------------|
| Total applications | 40 |
| Active workflows | 40 |
| Pending reviews | ~20 |
| Issued certificates | 8 |
| Failed notifications | ~10 |
| Open conditions | ~20 |
| Active accreditation cycles | 2 |
| Audit entries | ~500 |

---

## 20. Data Lifecycle Matrix

Every transactional row carries its lifecycle metadata. This matrix defines for each entity who creates, updates, reviews, approves, owns, and retires it, plus its expected lifetime.

### Lifecycle Fields

Most tables implement these via `created_by`, `updated_by`, `deleted_by` (soft delete) columns. Some add `reviewed_by`, `approved_by`, `assigned_to`. The lifecycle is encoded in the data — every row must have a meaningful creator and timestamp.

### Entity Lifecycle Matrix

| Entity | Creator | Owner | State Machine | Lifetime | Retirement |
|--------|---------|-------|---------------|----------|------------|
| `security.users` | `security.fn_register_user()` (admin) | Self (user_id) | status: ACTIVE/INACTIVE/LOCKED/SUSPENDED | Indefinite | deleted_at = soft delete |
| `security.institutions` | ETHICS_ADMIN | Institution | is_active flag | Indefinite | is_active = false |
| `security.departments` | ETHICS_ADMIN | Institution | is_active flag | Indefinite | is_active = false |
| `core.projects` | RESEARCHER (PI) | PI (principal_investigator_id) | status_code: DRAFT→SUBMITTED→ACTIVE→CLOSED | Project duration (months–years) | deleted_at |
| `core.applications` | RESEARCHER | submitted_by | current_status: 14 workflow states | Application lifecycle | deleted_at |
| `core.application_amendments` | RESEARCHER/ADMIN | submitted_by | status_code: DRAFT→SUBMITTED→APPROVED/REJECTED | Per amendment cycle | deleted_at |
| `core.application_sections` | System (auto) | Application owner | completion_status | Per application | deleted_at |
| `committee.committees` | ETHICS_ADMIN | Institution | is_active flag | Indefinite | deleted_at |
| `committee.committee_members` | ETHICS_ADMIN/CHAIR | Committee | is_active + membership_start/end_date | Term-limited (2-4 years) | membership_end_date |
| `committee.committee_meetings` | COMMITTEE_SECRETARY | Committee | meeting_status: SCHEDULED→IN_PROGRESS→COMPLETED→CANCELLED | Single day | deleted_at |
| `committee.meeting_agendas` | COMMITTEE_SECRETARY | Committee | — | Per meeting | deleted_at |
| `committee.agenda_items` | COMMITTEE_SECRETARY | Committee | — | Per agenda | deleted_at |
| `committee.ethics_reviews` | REVIEWER (assigned) | Application+Reviewer | review_status: ASSIGNED→IN_PROGRESS→COMPLETED | Review cycle days-weeks | deleted_at |
| `committee.scientific_reviews` | REVIEWER (assigned) | Application+Reviewer | review_status: ASSIGNED→IN_PROGRESS→COMPLETED | Review cycle days-weeks | deleted_at |
| `committee.application_conditions` | COMMITTEE (via review) | Application | status: OPEN→MET/NOT_MET/WAIVED + due_date | Until resolved or waived | deleted_at |
| `committee.review_assignments` | ETHICS_ADMIN/CHAIR | Reviewer | status_code: ASSIGNED→ACCEPTED→COMPLETED→DECLINED | Per review | deleted_at |
| `committee.voting_sessions` | CHAIR | Committee+Meeting | status_code: OPEN→CLOSED | During meeting | deleted_at |
| `committee.votes` | Committee member | Voter | — | During voting session | deleted_at |
| `workflow.workflow_instances` | System (on submit) | Entity owner | status_code: ACTIVE→COMPLETED | Application lifecycle | deleted_at |
| `workflow.workflow_actions` | Acting user | Entity owner | — | Per transition | — |
| `workflow.workflow_history` | System | Entity owner | — | Per state change | — |
| `workflow.workflow_tasks` | System/Admin | assigned_to | task_status: OPEN→IN_PROGRESS→COMPLETED→CANCELLED | Per SLA | deleted_at |
| `documents.documents` | Uploader (uploaded_by) | Entity owner | is_active flag | Entity lifetime | deleted_at (soft) |
| `documents.document_versions` | Uploader | Entity owner | version_no | Document lifetime | deleted_at |
| `documents.approval_certificates` | ETHICS_ADMIN (issuer) | issued_to_user_id | status: documents.certificate_status (DRAFT→GENERATING→ISSUED→FAILED→REVOKED→SUPERSEDED) | Certificate validity period | revoked_at or superseded_by |
| `communication.notifications` | System | user_id | is_read flag | Per user session | deleted_at |
| `communication.notification_logs` | System | Notification | delivery_status: PENDING→SENT→DELIVERED→FAILED | Per delivery attempt | — |
| `communication.messages` | sender_id | Recipients | is_deleted flag | Indefinite | deleted_at |
| `safety.adverse_events` | RESEARCHER/PI | Application+reported_by | — | Per event | deleted_at |
| `safety.risk_assessments` | Safety reviewer | Application+assessed_by | — | Per assessment | deleted_at |
| `monitoring.monitoring_plans` | ETHICS_ADMIN | Application | status_code: ACTIVE→COMPLETED→CANCELLED | Monitoring period | deleted_at |
| `monitoring.monitoring_visits` | Monitor (monitor_id) | Monitoring plan | visit_status: SCHEDULED→COMPLETED→CANCELLED | Per visit | deleted_at |
| `committee.accreditation_cycles` | ETHICS_ADMIN | Committee | status: PENDING→UNDER_REVIEW→ACCREDITED/CONDITIONAL/SUSPENDED/EXPIRED/REVOKED | 1-5 years | valid_until + status |
| `committee.accreditation_conditions` | Assessor | Cycle | status: OPEN→MET/OVERDUE/WAIVED | Per assessment | resolved_at |
| `system.audit_log` | System (trigger) | — | — | Indefinite | — |
| `audit.audit_logs` | System (trigger) | — | — | Indefinite | — |

### Lifecycle Rules

1. Every row with `created_by` must have a valid FK to `security.users`
2. Every row with `updated_by` must have `updated_at > created_at`
3. Every soft-deleted row (`deleted_at IS NOT NULL`) must have `deleted_by IS NOT NULL`
4. No row may have `created_at` in the future
5. Workflow-related rows must have timestamps consistent with the workflow transition they represent

---

## 21. Complete Workflow Coverage

### 21.1 APP_REVIEW_V1 — State Coverage

| # | State | Terminal | Sample Records | Transition Path | Notes |
|---|-------|----------|---------------|-----------------|-------|
| 1 | DRAFT | No | 4 | → SUBMITTED (SUBMIT) | Application created but not yet submitted |
| 2 | SUBMITTED | No | 3 | → INITIAL_REVIEW (ASSIGN_INITIAL_REVIEW) | Submitted, awaiting assignment |
| 3 | INITIAL_REVIEW | No | 3 | → SCIENTIFIC_REVIEW (ASSIGN_SCIENTIFIC_REVIEW), → ETHICAL_REVIEW (ASSIGN_ETHICAL_REVIEW), → RETURNED (RETURN_TO_APPLICANT) | Initial triage |
| 4 | SCIENTIFIC_REVIEW | No | 3 | → ETHICAL_REVIEW (COMPLETE_SCIENTIFIC_REVIEW), → RETURNED (RETURN_TO_APPLICANT) | Scientific review in progress |
| 5 | ETHICAL_REVIEW | No | 3 | → COMMITTEE_REVIEW (COMPLETE_ETHICAL_REVIEW), → RETURNED (RETURN_TO_APPLICANT) | Ethics review in progress |
| 6 | COMMITTEE_REVIEW | No | 4 | → APPROVED (APPROVE), → REJECTED (REJECT), → AWAITING_CONDITIONS (SET_CONDITIONS), → RETURNED (RETURN_TO_APPLICANT) | Full committee discussion |
| 7 | APPROVED | No | 3 | → CLOSED (CLOSE) | Non-terminal per RULE 11 |
| 8 | REJECTED | Yes | 2 | → ARCHIVE (ARCHIVE) | Terminal |
| 9 | RETURNED | No | 3 | → INITIAL_REVIEW (RESUBMIT) | Returned for amendments |
| 10 | AWAITING_CONDITIONS | No | 3 | → COMMITTEE_REVIEW (SUBMIT_EVIDENCE), → EVIDENCE_REJECTED (REJECT_EVIDENCE) | Conditional approval |
| 11 | EVIDENCE_REJECTED | No | 2 | → AWAITING_CONDITIONS (SUBMIT_EVIDENCE) | Evidence not accepted |
| 12 | WITHDRAWN | Yes | 2 | (none) | Applicant withdrawal. Terminal. |
| 13 | CLOSED | No | 2 | → ARCHIVED (ARCHIVE) | Non-terminal per RULE 11 |
| 14 | ARCHIVED | Yes | 2 | (none) | Terminal |

### 21.2 Transition Coverage

| Transition Code | From | To | Record Count | Triggered By |
|-----------------|------|----|-------------|--------------|
| SUBMIT | DRAFT | SUBMITTED | 4 | RESEARCHER |
| ASSIGN_INITIAL_REVIEW | SUBMITTED | INITIAL_REVIEW | 3 | ETHICS_ADMIN |
| ASSIGN_SCIENTIFIC_REVIEW | INITIAL_REVIEW | SCIENTIFIC_REVIEW | 2 | ETHICS_ADMIN |
| ASSIGN_ETHICAL_REVIEW | INITIAL_REVIEW | ETHICAL_REVIEW | 1 | ETHICS_ADMIN |
| COMPLETE_SCIENTIFIC_REVIEW | SCIENTIFIC_REVIEW | ETHICAL_REVIEW | 2 | REVIEWER |
| COMPLETE_ETHICAL_REVIEW | ETHICAL_REVIEW | COMMITTEE_REVIEW | 2 | REVIEWER |
| APPROVE | COMMITTEE_REVIEW | APPROVED | 2 | COMMITTEE_CHAIR (via vote) |
| REJECT | COMMITTEE_REVIEW | REJECTED | 1 | COMMITTEE_CHAIR (via vote) |
| SET_CONDITIONS | COMMITTEE_REVIEW | AWAITING_CONDITIONS | 1 | COMMITTEE_CHAIR |
| RETURN_TO_APPLICANT | INITIAL_REVIEW | RETURNED | 1 | REVIEWER |
| RETURN_TO_APPLICANT | SCIENTIFIC_REVIEW | RETURNED | 1 | REVIEWER |
| RETURN_TO_APPLICANT | ETHICAL_REVIEW | RETURNED | 1 | REVIEWER |
| RETURN_TO_APPLICANT | COMMITTEE_REVIEW | RETURNED | 1 | COMMITTEE |
| RESUBMIT | RETURNED | INITIAL_REVIEW | 3 | RESEARCHER |
| SUBMIT_EVIDENCE | AWAITING_CONDITIONS | COMMITTEE_REVIEW | 2 | RESEARCHER |
| SUBMIT_EVIDENCE | EVIDENCE_REJECTED | AWAITING_CONDITIONS | 2 | RESEARCHER |
| REJECT_EVIDENCE | AWAITING_CONDITIONS | EVIDENCE_REJECTED | 2 | COMMITTEE |
| CLOSE | APPROVED | CLOSED | 2 | RESEARCHER/ETHICS_ADMIN |
| ARCHIVE | REJECTED | ARCHIVED | 2 | ETHICS_ADMIN |
| ARCHIVE | CLOSED | ARCHIVED | 2 | ETHICS_ADMIN |
| WITHDRAW | SUBMITTED | WITHDRAWN | 1 | RESEARCHER |
| WITHDRAW | INITIAL_REVIEW | WITHDRAWN | 1 | RESEARCHER |

**Total transitions exercised: 22 out of 32 (the remaining 10 are unused paths or alternative cycles)**

### 21.3 Per-State Record Distribution (Applications)

| State | Application IDs | Example Narratives |
|-------|----------------|-------------------|
| DRAFT | APP-2025-001–004 | 3 new draft protocols, 1 incomplete resubmission |
| SUBMITTED | APP-2025-005–007 | Recently submitted, awaiting admin triage |
| INITIAL_REVIEW | APP-2025-008–010 | Under initial screening by ethics office |
| SCIENTIFIC_REVIEW | APP-2025-011–013 | Assigned to scientific reviewers |
| ETHICAL_REVIEW | APP-2025-014–016 | Under ethics review |
| COMMITTEE_REVIEW | APP-2025-017–020 | Scheduled for next committee meeting |
| APPROVED | APP-2025-021–023 | Certificate issued, projects active |
| REJECTED | APP-2025-024–025 | Rejected on ethical grounds |
| RETURNED | APP-2025-026–028 | Returned for protocol amendments |
| AWAITING_CONDITIONS | APP-2025-029–031 | Conditions set, awaiting evidence |
| EVIDENCE_REJECTED | APP-2025-032–033 | Evidence rejected, resubmission needed |
| WITHDRAWN | APP-2025-034–035 | Applicant withdrew |
| CLOSED | APP-2025-036–037 | Study completed, closed |
| ARCHIVED | APP-2025-038–040 | Archived records |

### 21.4 Workflow Action History Coverage

| Instance Stage | Actions | History Entries |
|----------------|---------|-----------------|
| Simple approve path | 4 (submit→review→committee→approve) | 4 |
| Conditional path | 6 (submit→review→committee→conditions→evidence→approve) | 6 |
| Reject path | 3 (submit→review→reject) | 3 |
| Return path | 4 (submit→review→return→resubmit) | 4 |
| Withdraw path | 2 (submit→withdraw) | 2 |

---

## 22. Permission Coverage Matrix

### 22.1 Role → Page Access

| Page | SUPER_ADMIN | ETHICS_ADMIN | COMMITTEE_CHAIR | REVIEWER | RESEARCHER | INST_COORD | AUDITOR | READ_ONLY |
|------|-------------|-------------|-----------------|----------|------------|------------|---------|-----------|
| Dashboard | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| My Applications | — | — | — | — | Yes | — | — | — |
| All Applications | Yes | Institution | Committee | Assigned | — | Institution | Read-only | Read-only |
| New Application | — | — | — | — | Yes | — | — | — |
| Projects | Yes | Institution | Committee | — | Own | Institution | Read-only | — |
| Committees | Yes | Institution | Own | Member | — | — | Read-only | — |
| Meetings | Yes | Institution | Own | Invited | — | — | — | — |
| Reviews | Yes | All | Committee | Assigned | — | — | — | — |
| Conditions | Yes | All | Own | — | Own | — | — | — |
| Documents | Yes | All | Committee | Assigned | Own | Institution | Read-only | — |
| Certificates | Yes | Issued | Committee | — | Own | — | Read-only | — |
| Accreditation | Yes | Institution | Own | — | — | — | — | — |
| Notifications | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| Messages | Yes | Yes | Yes | Yes | Yes | Yes | — | — |
| Users | Yes | Institution | — | — | — | Institution | Read-only | Read-only |
| Institutions | Yes | Institution | — | — | — | Own | — | — |
| Reports | Yes | Yes | Committee | — | Own | Institution | Yes | Yes |
| Audit Log | Yes | Institution | — | — | — | — | Yes | — |
| System Config | Yes | — | — | — | — | — | — | — |
| Safety | Yes | Institution | Committee | — | Own | — | — | — |
| Monitoring | Yes | Institution | Committee | — | Own | — | — | — |

### 22.2 Role → API Coverage

| Module | Endpoint | SUPER_ADMIN | ETHICS_ADMIN | CHAIR | REVIEWER | RESEARCHER |
|--------|----------|-------------|-------------|-------|----------|------------|
| Auth | POST /login | ✓ | ✓ | ✓ | ✓ | ✓ |
| Auth | POST /register | ✓ | — | — | — | ✓ |
| Users | GET /users | ✓ | Institution | — | — | Self |
| Users | POST /users | ✓ | Institution | — | — | — |
| Users | PUT /users/:id | ✓ | Institution | — | — | Self |
| Users | DELETE /users/:id | ✓ | — | — | — | — |
| Projects | GET /projects | ✓ | Institution | — | — | Own |
| Projects | POST /projects | ✓ | Institution | — | — | Create |
| Projects | PUT /projects/:id | ✓ | Institution | — | — | Own |
| Applications | GET /applications | ✓ | Institution | Committee | Assigned | Own |
| Applications | POST /applications | ✓ | — | — | — | ✓ |
| Applications | POST /submit/:id | ✓ | — | — | — | Own (in DRAFT) |
| Applications | POST /withdraw/:id | ✓ | — | — | — | Own |
| Workflow | POST /advance/:id | ✓ | ✓ | ✓ | Limited | Limited |
| Committees | GET /committees | ✓ | Institution | Own | Member | — |
| Committees | POST /committees | ✓ | ✓ | — | — | — |
| Reviews | POST /reviews | ✓ | ✓ | ✓ | ✓ | — |
| Reviews | PUT /reviews/:id/complete | ✓ | ✓ | ✓ | ✓ | — |
| Conditions | GET /conditions | ✓ | All | Committee | — | Own |
| Documents | POST /documents | ✓ | ✓ | ✓ | ✓ | Own entity |
| Documents | DELETE /documents/:id | ✓ | RULE 12 | RULE 12 | RULE 12 | RULE 12 |
| Certificates | POST /certificates/issue | ✓ | ✓ | — | — | — |
| Certificates | POST /certificates/verify | ✓ | ✓ | ✓ | ✓ | ✓ |
| Notifications | GET /notifications | ✓ | ✓ | ✓ | ✓ | ✓ |
| Reports | POST /reports/execute | ✓ | ✓ | ✓ | ✓ | Own scope |

### 22.3 Role → Workflow Actions

| Action | SUPER_ADMIN | ETHICS_ADMIN | CHAIR | REVIEWER | RESEARCHER |
|--------|-------------|-------------|-------|----------|------------|
| SUBMIT | ✓ | — | — | — | ✓ (own DRAFT) |
| ASSIGN_REVIEWER | ✓ | ✓ | ✓ | — | — |
| SUBMIT_REVIEW | ✓ | — | — | ✓ (assigned) | — |
| SET_CONDITIONS | ✓ | ✓ | ✓ | — | — |
| APPROVE | ✓ | — | ✓ (after vote) | — | — |
| REJECT | ✓ | — | ✓ (after vote) | — | — |
| RETURN_TO_APPLICANT | ✓ | ✓ | ✓ | ✓ (assigned) | — |
| RESUBMIT | ✓ | — | — | — | ✓ (own RETURNED) |
| SUBMIT_EVIDENCE | ✓ | — | — | — | ✓ (own AWAITING_CONDITIONS) |
| REJECT_EVIDENCE | ✓ | ✓ | ✓ | — | — |
| WITHDRAW | ✓ | — | — | — | ✓ (own non-terminal) |
| CLOSE | ✓ | ✓ | — | — | ✓ (own APPROVED) |
| ARCHIVE | ✓ | ✓ | ✓ | — | — |
| ISSUE_CERTIFICATE | ✓ | ✓ | — | — | — |
| REVOKE_CERTIFICATE | ✓ | ✓ | — | — | — |

### 22.4 Role → Notifications Expected

| Notification Type | SUPER_ADMIN | ETHICS_ADMIN | CHAIR | REVIEWER | RESEARCHER |
|-------------------|-------------|-------------|-------|----------|------------|
| Application submitted | ✓ | ✓ | — | — | ✓ (confirmation) |
| Review assigned | — | — | — | ✓ | — |
| Review completed | — | ✓ | ✓ | — | — |
| Committee decision | — | — | ✓ | — | ✓ |
| Conditions set | — | — | — | — | ✓ |
| Evidence submitted | — | ✓ | ✓ | — | ✓ (confirmation) |
| Evidence rejected | — | — | ✓ | — | ✓ |
| Certificate issued | — | — | ✓ | — | ✓ |
| Certificate revoked | — | — | ✓ | — | ✓ |
| Meeting scheduled | — | ✓ | ✓ | ✓ | — |
| Withdrawal | — | ✓ | — | — | ✓ (confirmation) |

---

## 23. Dashboard Proof

### Widget 1: Total Applications
**Source:** `SELECT COUNT(*) FROM core.applications WHERE deleted_at IS NULL`
**Required records:** All 40 applications
**Expected value:** 40

### Widget 2: Applications by Status
**Source:** `SELECT current_status, COUNT(*) FROM core.applications GROUP BY current_status`
**Required records:** At least 1 application per non-terminal state (13 states × 2+ = 36 apps) + terminal states (3 × 2 = 6 apps)
**Expected output:** 14 rows, each non-zero

### Widget 3: Pending Reviews
**Source:** `SELECT COUNT(*) FROM committee.review_assignments WHERE status_code = 'ASSIGNED'`
**Required records:** 10-15 assigned but not completed reviews
**Expected value:** > 0

### Widget 4: Approval Rate (Last 12 Months)
**Source:** `SELECT ... COUNT(CASE WHEN ... = 'APPROVED') / COUNT(*) FROM core.applications WHERE submission_date > now() - interval '12 months'`
**Required records:** 4 APPROVED, 2 REJECTED in last 12 months
**Expected value:** ~66%

### Widget 5: Average Review Time
**Source:** Average of (completed_at - started_at) for ethics_reviews and scientific_reviews
**Required records:** 20+ completed reviews with realistic durations (7-45 days)
**Expected value:** ~21 days

### Widget 6: Committee Workload
**Source:** `SELECT c.committee_name_ar, COUNT(*) FROM committee.committees c JOIN committee.committee_meetings m ... JOIN core.applications a ...`
**Required records:** Each of 5 committees must have 2+ meetings and 4+ applications
**Expected output:** 5 rows, each > 0

### Widget 7: Recent Activity Feed
**Source:** Last 20 entries from `workflow.workflow_history` or `audit.audit_logs`
**Required records:** 500+ audit entries, 160+ workflow history entries
**Expected output:** 20 chronologically ordered entries

### Widget 8: User Distribution by Role
**Source:** `SELECT r.code, COUNT(*) FROM security.user_roles ur JOIN security.roles r ... GROUP BY r.code`
**Required records:** Each of 5 roles has 1+ user
**Expected output:** 5 rows, each > 0

### Widget 9: Institution Distribution
**Source:** `SELECT i.code, COUNT(p.id) FROM security.institutions i LEFT JOIN core.projects p ... GROUP BY i.code`
**Required records:** 20+ institutions with projects, 20+ with 0
**Expected output:** 41 rows, ~20 with count > 0

### Widget 10: Risk Level Distribution
**Source:** `SELECT risk_level, COUNT(*) FROM core.projects GROUP BY risk_level`
**Required records:** 4 risk levels with 3+ projects each (MINOR=8, MODERATE=12, MAJOR=7, CRITICAL=3)
**Expected output:** 4 rows, all > 0

### Widget 11: Certificates by Status
**Source:** `SELECT status, COUNT(*) FROM documents.approval_certificates GROUP BY status`
**Required records:** GENERATING(1), ISSUED(8), FAILED(1), REVOKED(3), SUPERSEDED(2)
**Expected output:** 5 rows, all > 0

### Widget 12: Open Conditions
**Source:** `SELECT COUNT(*) FROM committee.application_conditions WHERE status = 'OPEN'`
**Required records:** ~20 OPEN conditions
**Expected value:** > 0

---

## 24. Report Proof

### Report 1: Applications Summary Report

| Aspect | Detail |
|--------|--------|
| **Tables** | `core.applications`, `core.projects`, `security.users`, `security.institutions` |
| **Required records** | 40 applications across 14 states, 30 projects across 4 risk levels, 8 governorates |
| **Filters exercised** | Status, committee, date range, institution, risk level, PI name |
| **Expected output** | Filterable table with 40 rows showing application_number, project title, PI, status, submitted_date, committee, risk_level |

### Report 2: Committee Activity Report

| Aspect | Detail |
|--------|--------|
| **Tables** | `committee.committees`, `committee.committee_meetings`, `committee.agenda_items`, `committee.attendance_logs`, `committee.voting_sessions`, `committee.votes` |
| **Required records** | 5 committees, 30 meetings, 90 agenda items, 200 attendance logs, 40 voting sessions, 200 votes |
| **Filters exercised** | Committee, date range, meeting status, attendance status |
| **Expected output** | Summary per committee: total meetings, avg attendance, quorum %, decisions made |

### Report 3: User Activity Report

| Aspect | Detail |
|--------|--------|
| **Tables** | `security.users`, `security.user_roles`, `security.login_audit`, `workflow.workflow_actions`, `audit.audit_logs` |
| **Required records** | 96 users, 200 login_audit entries, 160 workflow_actions, 500 audit_logs |
| **Filters exercised** | User, role, date range, action type |
| **Expected output** | Per-user: logins, actions performed, documents uploaded, reviews completed |

### Report 4: Compliance Report

| Aspect | Detail |
|--------|--------|
| **Tables** | `monitoring.compliance_reviews`, `monitoring.deviations`, `monitoring.protocol_violations`, `monitoring.monitoring_findings`, `monitoring.corrective_actions` |
| **Required records** | 10 compliance reviews, 10 deviations, 8 violations, 40 findings, 20 CAPAs |
| **Filters exercised** | Application, date range, severity, status |
| **Expected output** | Compliance score per application, deviation count, CAPA closure rate |

### Report 5: Certificate Status Report

| Aspect | Detail |
|--------|--------|
| **Tables** | `documents.approval_certificates`, `documents.certificate_verification_log`, `core.applications`, `security.users` |
| **Required records** | 15 certificates in 6 lifecycle states, 30 verification attempts in 5 result types |
| **Filters exercised** | Status, date range, application, issuer, verification result |
| **Expected output** | Certificate count by status, verification attempt log, supersedence chain |

### Report 6: Safety Report

| Aspect | Detail |
|--------|--------|
| **Tables** | `safety.adverse_events`, `safety.serious_adverse_events`, `safety.safety_reports`, `safety.risk_assessments` |
| **Required records** | 15 AEs (5 SAEs), 10 safety reports, 15 risk assessments |
| **Filters exercised** | Application, event type, severity, outcome, date range |
| **Expected output** | AE count by type/severity, SAE details, safety report summaries |

### Report 7: Accreditation Status Report

| Aspect | Detail |
|--------|--------|
| **Tables** | `committee.accreditation_cycles`, `committee.accreditation_assessments`, `committee.accreditation_conditions`, `committee.accreditation_decisions` |
| **Required records** | 8 cycles in 7 statuses, 16 assessments, 20 conditions, 16 decisions |
| **Filters exercised** | Committee, cycle status, date range |
| **Expected output** | Current accreditation status per committee, cycle history, condition resolution rate |

### Report 8: Institution Performance Report

| Aspect | Detail |
|--------|--------|
| **Tables** | `security.institutions`, `core.projects`, `core.applications`, `documents.approval_certificates` |
| **Required records** | 41 institutions, 30 projects, 40 applications, 15 certificates |
| **Filters exercised** | Governorate, institution type, date range |
| **Expected output** | Projects per institution, approval rate, active certificates |

### Report 9: Audit Trail Report

| Aspect | Detail |
|--------|--------|
| **Tables** | `audit.audit_logs`, `audit.audit_details`, `security.users` |
| **Required records** | 500 audit log entries covering 30+ entity types, 1000 detail entries |
| **Filters exercised** | Entity type, user, operation type, date range, entity ID |
| **Expected output** | Chronological audit trail with before/after values per field change |

### Report 10: KPI Dashboard Report

| Aspect | Detail |
|--------|--------|
| **Tables** | `reporting.kpi_results`, `reporting.analytics_snapshots` |
| **Required records** | 50 KPI measurements across 6 KPIs over 12 months, 12 analytics snapshots |
| **Filters exercised** | KPI code, date range |
| **Expected output** | KPI trend lines, actual vs target, monthly snapshots |

---

## 25. Edge Case Dataset

The following explicit records are created specifically to validate exceptional and boundary behavior.

### 25.1 Rejected after Committee Review

| App ID | Project | Narrative | Rejection Reason |
|--------|---------|-----------|------------------|
| APP-2025-024 | دراسة حول فعالية دواء عشبي غير مرخص | Herbal remedy trial without proper safety data | Protocol lacks adequate safety monitoring plan |
| APP-2025-025 | تجربة سريرية لأجهزة طبية غير معتمدة | Unapproved medical device trial | Insufficient preclinical data, ethical concerns |

### 25.2 Withdrawn after Submission

| App ID | Project | Narrative | Withdrawal Reason |
|--------|---------|-----------|-------------------|
| APP-2025-034 | دراسة جينية للمجتمع اليمني | Genetic study withdrawn after initial review | PI left institution |
| APP-2025-035 | مسح صحي للمهاجرين غير المسجلين | Health survey of undocumented migrants | Funding withdrawn |

### 25.3 Appeals

| App ID | Project | Appeal Type | Outcome |
|--------|---------|-------------|---------|
| APP-2026-001 | دراسة عن مرضى السكري (إعادة تقديم) | Appeal of rejection | Approved on appeal |
| APP-2026-002 | دراسة استخدام الخلايا الجذعية | Appeal of condition severity | Appeal rejected |

Note: Appeals may require extending the workflow or using a new application linked to the original.

### 25.4 Renewals

| App ID | Project | Renewal | Outcome |
|--------|---------|---------|---------|
| APP-2025-021 | دراسة انتشار الملاريا في المناطق الساحلية | 12-month renewal | Approved |
| APP-2025-037 | مسح صحي سريع للنازحين | 6-month renewal | Rejected (study complete) |

### 25.5 Certificate Edge Cases

| Certificate | Status | Detail |
|-------------|--------|--------|
| CERT-2025-001 | ISSUED | Normal issuance for APP-2025-021 (approved) |
| CERT-2025-002 | ISSUED | Normal issuance for APP-2025-022 (approved) |
| CERT-2025-003 | REVOKED | Issued for APP-2025-023, revoked due to protocol deviation |
| CERT-2025-004 | SUPERSEDED | Original cert replaced by version 2 (CERT-2025-005) |
| CERT-2025-005 | ISSUED | Version 2 that superseded CERT-2025-004 |
| CERT-2025-006 | FAILED | Generation error — template rendering failed |
| CERT-2025-007 | REVOKED | Issued in error (wrong PI name), admin revoked |
| CERT-2025-008 | SUPERSEDED | Replaced due to committee composition change |

### 25.6 Condition Edge Cases

| Condition ID | Application | Status | Detail |
|-------------|-------------|--------|--------|
| COND-001 | APP-2025-031 | OVERDUE | Due date passed, no evidence submitted (30 days overdue) |
| COND-002 | APP-2025-031 | OPEN | Within due date, no evidence yet |
| COND-003 | APP-2025-029 | OPEN | Evidence submitted twice, both rejected |
| COND-004 | APP-2025-029 | OPEN | After second rejection, still open |
| COND-005 | APP-2025-030 | MET | Evidence accepted, condition satisfied |
| COND-006 | APP-2025-030 | WAIVED | Committee waived remaining condition |

### 25.7 Evidence Rejected Twice

| App ID | Evidence | Rejection 1 | Rejection 2 |
|--------|----------|-------------|-------------|
| APP-2025-032 | Informed consent form (v1) | Missing signature block | — |
| APP-2025-032 | Informed consent form (v2) | — | Translation not certified |
| APP-2025-033 | CV of co-investigator | Missing qualifications | Document illegible scan |

### 25.8 Accreditation Edge Cases

| Cycle | Committee | Status | Detail |
|-------|-----------|--------|--------|
| CYC-001 | IRB-Sana'a | ACCREDITED | Full 5-year accreditation |
| CYC-002 | IRB-Sana'a | UNDER_REVIEW | Renewal assessment in progress |
| CYC-003 | IRB-Aden | CONDITIONAL | Accredited with 3 conditions (1 OPEN, 1 MET, 1 OVERDUE) |
| CYC-004 | IRB-Aden | SUSPENDED | Suspended due to quorum failure in 2 consecutive meetings |
| CYC-005 | REC-Sana'a Uni | EXPIRED | Cycle ended, renewal not yet initiated |
| CYC-006 | IACUC-National Lab | REVOKED | Revoked due to non-compliance with animal welfare standards |
| CYC-007 | IBC-Research Inst | PENDING | Accreditation application submitted, not yet reviewed |
| CYC-008 | IRB-Sana'a | ACCREDITED | Previous cycle (now superseded by CYC-001) |

### 25.9 Notification Edge Cases

| Notification | Type | Status | Detail |
|-------------|------|--------|--------|
| NOTIF-001 | Workflow: approved | DELIVERED | Normal delivery |
| NOTIF-002 | Condition: reminder | SENT | Not yet confirmed delivered |
| NOTIF-003 | Evidence: rejected | DELIVERED | Researcher confirmed receipt |
| NOTIF-004 | Meeting: scheduled | FAILED | Invalid email address |
| NOTIF-005 | Certificate: issued | RETRYING | SMTP server timeout, retry scheduled |
| NOTIF-006 | System: maintenance | DELIVERED | Broadcast to all users |
| NOTIF-007 | Message: new | PENDING | Recipient offline (IN_APP pending) |
| NOTIF-008 | Certificate: revoked | FAILED | Unknown provider error |

### 25.10 Backup/Restore History

| Event | Date | Size | Status | Detail |
|-------|------|------|--------|--------|
| Backup | 2026-01-15 | 45 MB | COMPLETED | First baseline backup |
| Restore | 2026-02-01 | — | COMPLETED | Restore to staging for UAT |
| Backup | 2026-03-01 | 52 MB | COMPLETED | Incremental |
| Backup | 2026-04-01 | 58 MB | FAILED | Disk full |
| Backup | 2026-04-02 | 58 MB | COMPLETED | Retry successful |
| Restore | 2026-05-01 | — | FAILED | Checksum mismatch |
| Backup | 2026-06-01 | 61 MB | COMPLETED | Full backup pre-UAT |

### 25.11 Observability Edge Cases

| Metric | Value | Context |
|--------|-------|---------|
| Active applications | 20 | Non-terminal states |
| Pending reviews | 12 | Assigned but not started |
| Failed notifications | 2 | FAILED status |
| Retrying notifications | 1 | RETRYING status |
| Overdue conditions | 1 | Past due_date |
| Open conditions | 20 | Status = OPEN |
| Active certificates | 9 | ISSUED + GENERATING |
| Failed certificates | 1 | FAILED status |
| Suspended accreditations | 1 | Status = SUSPENDED |
| Expired accreditations | 1 | Status = EXPIRED |

---

## 26. Data Quality Rules

### 26.1 Identity Integrity

| Rule | Enforcement | Violation Example | Detection |
|------|-------------|-------------------|-----------|
| No duplicate emails | UNIQUE on `security.users.email` | Two users with same email | INSERT fails |
| No duplicate usernames | UNIQUE on `security.users.username` | Two users with same username | INSERT fails |
| No duplicate UUIDs | UNIQUE on user UUIDs | Same UUID assigned twice | gen_random_uuid() prevents this |
| No duplicate application numbers | UNIQUE on `core.applications.application_number` | Sequential number reused | INSERT fails |
| No duplicate project codes | UNIQUE on `core.projects.project_code` | Same code used twice | INSERT fails |
| No duplicate serial numbers | UNIQUE on `documents.approval_certificates.serial_number` | Certificate serial reused | INSERT fails |
| No duplicate committee codes | UNIQUE on `committee.committees.committee_code` | Two committees same code | INSERT fails |

### 26.2 Date Integrity

| Rule | Tables Affected | Validation |
|------|----------------|------------|
| `created_at` ≤ `updated_at` | All with both columns | CHECK or trigger |
| `start_date` ≤ `end_date` | `core.projects`, `security.departments`, `committee.member_terms` | Application-level |
| `valid_from` < `valid_until` | `committee.accreditation_cycles` | CHECK constraint `chk_valid_dates` |
| `due_date` > `created_at` | `committee.application_conditions` | Application-level |
| `birth_date` < today | `security.user_profiles.date_of_birth` | Application-level |
| No future `created_at` | All tables | Application-level |
| `submission_date` ≥ `created_at` | `core.applications` | Application-level |
| `membership_start_date` ≤ `membership_end_date` | `committee.committee_members` | Application-level |
| Certificate `valid_from` < `valid_to` | `security.digital_certificates` | Application-level |

### 26.3 Document Integrity

| Rule | Description |
|------|-------------|
| No orphan documents | Every `documents.documents.entity_id` must reference an existing entity (applications, projects, etc.) |
| No orphan versions | Every `documents.document_versions.document_id` must reference an existing document |
| No circular document references | `documents.documents.uploaded_by` must be a valid user |
| Document type validity | `documents.documents.document_type_id` must reference existing type |
| Storage path non-empty | `storage_path` NOT NULL |

### 26.4 Certificate Integrity

| Rule | Description |
|------|-------------|
| No orphan certificates | `documents.approval_certificates.application_id` must reference valid application |
| Valid serial number format | `CERT-YYYY-NNN` format enforced |
| Superseded chain integrity | `superseded_by` must reference a different certificate with same application_id |
| Revocation consistency | `revoked_by` IS NOT NULL when `status = 'REVOKED'` |
| No double supersession | A certificate can only supersede one other certificate (UNIQUE on superseded_by) |

### 26.5 Workflow Integrity

| Rule | Description |
|------|-------------|
| Valid state transitions | `workflow_actions.transition_id` must be valid for the instance's current state |
| State sequence integrity | `workflow_history.from_state_id` → `workflow_history.to_state_id` must follow valid transitions |
| No terminal state transitions | No actions allowed on instances in terminal states (REJECTED, WITHDRAWN, ARCHIVED) |
| Single active instance per entity | One ACTIVE `workflow_instances` per entity_id+entity_type |
| Consistent entity types | `workflow_instances.entity_type` must match `workflows.entity_type` |

### 26.6 Committee Membership Integrity

| Rule | Description |
|------|-------------|
| No duplicate membership | UNIQUE `(committee_id, user_id)` on `committee.committee_members` |
| Valid membership dates | `membership_end_date > membership_start_date` |
| Chair uniqueness | Only one active member with `committee_member_roles` = CHAIR per committee |
| No self-review | Reviewer cannot be assigned to review their own application |
| Conflict declaration | Member with conflict on application cannot be assigned as reviewer |

### 26.7 Institution Hierarchy Integrity

| Rule | Description |
|------|-------------|
| Valid institution type | `security.institutions.institution_type_id` must reference `security.institution_types` |
| Unique institution code | UNIQUE on `security.institutions.code` |
| Valid department parent | `security.departments.institution_id` must reference valid institution |
| Unique department code | UNIQUE `(institution_id, code)` on `security.departments` |
| User-institution match | `security.users.institution_id` must reference valid institution |

### 26.8 Notification Ownership Integrity

| Rule | Description |
|------|-------------|
| Notification belongs to user | `communication.notifications.user_id` must be the intended recipient |
| Message sender is valid | `communication.messages.sender_id` must reference valid user |
| Message recipient is valid | `communication.message_recipients.recipient_id` must reference valid user |
| Notification channel is valid | `communication.notifications.channel_id` must reference `communication.notification_channels` |
| Template is valid | `communication.notification_logs` FK to `communication.notifications` |

---

## 27. Performance Profile

### 27.1 Data Volume Targets

| Metric | Target | Purpose |
|--------|--------|---------|
| Total row count | ~10,260 | Meaningful backup/restore |
| Largest table size | ~1,500 (audit_details) | Page through audit trail |
| Documents count | 200+ | Test document listing with pagination |
| Users count | 96 | Test user search with filters |
| Applications count | 40 | Test filtered application lists |
| Notification count | 300+ | Test notification pagination |
| Audit entries | 500+ | Test audit trail search and pagination |
| Workflow history | 160+ | Test workflow timeline pagination |

### 27.2 Pagination Test Cases

| Page | Filters | Expected Rows | Sort |
|------|---------|---------------|------|
| Applications page | Status = DRAFT | 4 | Date desc |
| Applications page | Status = COMMITTEE_REVIEW | 4 | Date desc |
| Applications page | Institution = Sana'a | ~10 | Date desc |
| Applications page | Date range 2025-Q1 | ~8 | Date desc |
| Applications page | Risk level = MAJOR | 7 | Date desc |
| Projects page | Keyword contains "COVID" | 2 | Title asc |
| Projects page | Institution = Aden | ~5 | Date desc |
| Users page | Role = RESEARCHER | 40 | Name asc |
| Users page | Institution = Taiz | ~5 | Name asc |
| Documents page | Application = APP-2025-021 | ~8 | Version desc |
| Documents page | Document type = Protocol | ~30 | Date desc |
| Notifications page | User = researcher@institution | ~15 | Date desc |
| Notifications page | Status = UNREAD | ~50 | Date desc |
| Audit log page | Entity = Application | ~200 | Date desc |
| Audit log page | User = admin | ~100 | Date desc |
| Meetings page | Committee = IRB-Sana'a | ~8 | Date desc |
| Conditions page | Status = OPEN | 20 | Due date asc |
| Certificates page | Status = ISSUED | 8 | Date desc |

### 27.3 Filter Combination Test Cases

| Page | Filter 1 | Filter 2 | Filter 3 | Expected |
|------|----------|----------|----------|----------|
| Applications | Status = APPROVED | Committee = IRB-Sana'a | Date = 2025 | 2 |
| Applications | Status = AWAITING_CONDITIONS | Risk = MAJOR | — | 2 |
| Applications | Status = COMMITTEE_REVIEW | Institution = Aden | — | 1 |
| Projects | Risk = CRITICAL | Governorate = Sana'a | — | 1 |
| Projects | Keyword = "diabetes" | Status = ACTIVE | — | 1 |
| Reports | Type = Committee Activity | Committee = IRB-Aden | Date = 2025 | 1 |
| Notifications | Type = Workflow | Status = UNREAD | User = researcher | 5 |

### 27.4 Performance Expectations

| Operation | Dataset Size | Expected Response |
|-----------|-------------|-------------------|
| List applications (paginated, 20 per page) | 40 total | < 200ms |
| List applications with 2 JOINs + filter | 40 total | < 300ms |
| Search users by name (ILIKE) | 96 users | < 100ms |
| Dashboard aggregation (6 widgets) | All data | < 500ms |
| Report execution (simple) | All data | < 1s |
| Report execution (complex, multiple JOINs) | All data | < 3s |
| Certificate verification (by serial) | 15 certificates | < 50ms |
| Notification list (paginated, 20 per page) | 300 notifications | < 200ms |
| Audit trail search (with date filter) | 500 entries | < 500ms |
| Full backup | ~10,260 rows | < 30s |

---

## 28. Commit Breakdown

### Commit 1: Institution Hierarchy

| Aspect | Detail |
|--------|--------|
| **Purpose** | Create the Yemen institution hierarchy |
| **Dependencies** | None (references existing `security.institution_types`) |
| **Files** | `50-yemen-institutions.sql` |
| **Objects created** | 40 institutions, 120 departments, 3 institution_types (reference, preserved) |
| **Validation steps** | Check UNIQUE codes, FK to institution_types, department count per institution |
| **Rollback** | `ROLLBACK` (single transaction) |
| **Expected entity counts** | institutions: 41 total (1 THU + 40 new), departments: 124 (4 THU + 120 new) |

### Commit 2: Users and Security

| Aspect | Detail |
|--------|--------|
| **Purpose** | Create 96 users with roles, profiles, sessions, login history |
| **Dependencies** | Commit 1 (institutions, departments) |
| **Files** | `51-yemen-users.sql` |
| **Objects created** | 96 users, 96 user_roles, 96 user_profiles, 96 sessions, 200 login_audit, 96 password_history, 10 api_keys, 45 user_responsibilities |
| **Validation steps** | Check UNIQUE emails/usernames, FK to institutions/departments, role assignment correctness, no duplicate user+role |
| **Rollback** | `ROLLBACK` (single transaction) |
| **Expected entity counts** | users: 97 (1 admin + 96 new), user_roles: 97, user_profiles: 97, sessions: 97, login_audit: 200 |

### Commit 3: Projects

| Aspect | Detail |
|--------|--------|
| **Purpose** | Create 30 research projects across Yemeni institutions |
| **Dependencies** | Commits 1–2 (institutions, users as PIs) |
| **Files** | `52-yemen-projects.sql` |
| **Objects created** | 30 projects, 45 funding_sources, 45 project_sites, 60 site_investigators, 90 team_members, 60 attachments, 90 keywords, 60 tags, 40 research_population_links, 60 status_history, 60 versions |
| **Validation steps** | FK to institutions, FK to users (PI, team, created_by), UNIQUE project_codes, risk level CHECK constraint, date range validity |
| **Rollback** | `ROLLBACK` |
| **Expected entity counts** | projects: 30, total core rows: ~650 |

### Commit 4: Applications

| Aspect | Detail |
|--------|--------|
| **Purpose** | Create 40 applications across all 14 workflow states |
| **Dependencies** | Commits 1–3 (projects, users), Commit 5 (committees) must precede if FK exists, or use deferrable FK |
| **Files** | `53-yemen-applications.sql` |
| **Objects created** | 40 applications, 15 amendments + 15 amendment_requests, 120 checklists, 160 sections, 200 history, 80 versions, 120 validations, 60 application_consents, 10 closure_requests, 8 renewal_requests |
| **Validation steps** | FK to projects, FK to users (submitted_by), UNIQUE application_number, current_status CHECK, soft-delete CHECK |
| **Rollback** | `ROLLBACK` |
| **Expected entity counts** | applications: 40, total core rows: ~900 |

### Commit 5: Committees

| Aspect | Detail |
|--------|--------|
| **Purpose** | Create 5 committees with members, meetings, agenda items, minutes |
| **Dependencies** | Commits 1–4 (institutions, users, applications for agenda items) |
| **Files** | `54-yemen-committees.sql` |
| **Objects created** | 5 committees, 43 members + member_roles, 43 member_terms, 43 qualifications, 10 member_conflicts, 30 meetings, 30 agendas, 90 agenda_items, 25 minutes, 200 attendance_logs, 30 quorum_logs, 40 voting_sessions, 200 votes |
| **Validation steps** | UNIQUE committee_code, UNIQUE committee+user membership, member role validity, meeting_status CHECK, date constraints |
| **Rollback** | `ROLLBACK` |
| **Expected entity counts** | committees: 5, members: 43, meetings: 30, total committee rows: ~850 |

### Commit 6: Reviews and Conditions

| Aspect | Detail |
|--------|--------|
| **Purpose** | Create review assignments, ethics/scientific reviews, risk assessments, conditions |
| **Dependencies** | Commits 1–5 (users, applications, committees) |
| **Files** | `55-yemen-reviews.sql` |
| **Objects created** | 80 review_assignments, 40 ethics_reviews, 30 scientific_reviews, 20 risk_assessments + 80 risk_items, 60 application_conditions, 8 review_forms + 60 review_questions + 300 review_answers, 100 review_comments, 10 review_conflicts, 60 review_recommendations, 60 review_scores |
| **Validation steps** | FK to applications, FK to users (reviewers), review_status CHECK, condition status CHECK, risk score computed columns, score ranges |
| **Rollback** | `ROLLBACK` |
| **Expected entity counts** | reviews: 70, conditions: 60, total review rows: ~900 |

### Commit 7: Workflow Instances

| Aspect | Detail |
|--------|--------|
| **Purpose** | Create workflow instances, actions, history, tasks for every application's lifecycle |
| **Dependencies** | Commits 1–6 (applications, users, transitions reference data) |
| **Files** | `56-yemen-workflow.sql` |
| **Objects created** | 40 workflow_instances, 160 actions, 160 history, 120 tasks, 10 escalations, 200 events, 80 variables |
| **Validation steps** | FK to workflows (APP_REVIEW_V1), FK to workflow_states, FK to workflow_transitions, valid state progression, no terminal→non-terminal transitions, task_status CHECK |
| **Rollback** | `ROLLBACK` |
| **Expected entity counts** | instances: 40, actions: 160, history: 160, tasks: 120, total workflow rows: ~850 |

### Commit 8: Documents and Certificates

| Aspect | Detail |
|--------|--------|
| **Purpose** | Create 200+ documents with versions, access controls, and 15 certificates with full lifecycle |
| **Dependencies** | Commits 1–7 (applications, users, projects) |
| **Files** | `57-yemen-documents.sql` |
| **Objects created** | 200 documents + 250 versions, 300 document_access, 100 document_approvals, 400 document_audit, 100 document_signatures, 10 document_disposal_logs, 15 approval_certificates + 25 certificate_documents, 30 verification_log, 40 generated_documents |
| **Validation steps** | FK to document_types, FK to users, certificate status domain check, supersedence chain integrity, UNIQUE serial numbers, no orphan documents |
| **Rollback** | `ROLLBACK` |
| **Expected entity counts** | documents: 200, certificates: 15, total document rows: ~1,500 |

### Commit 9: Notifications and Messages

| Aspect | Detail |
|--------|--------|
| **Purpose** | Create 300+ notifications with delivery logs, 150 internal messages |
| **Dependencies** | Commits 1–8 (users, applications) |
| **Files** | `58-yemen-communication.sql` |
| **Objects created** | 300 notifications + 300 notification_logs, 150 messages + 300 recipients + 50 attachments, 10 announcements, 96 user_notification_preferences |
| **Validation steps** | FK to users, FK to notification_channels, delivery_status CHECK, notification type consistency |
| **Rollback** | `ROLLBACK` |
| **Expected entity counts** | notifications: 300, messages: 150, total communication rows: ~1,200 |

### Commit 10: Safety and Monitoring

| Aspect | Detail |
|--------|--------|
| **Purpose** | Create safety events, risk register, monitoring plans |
| **Dependencies** | Commits 1–8 (applications, users, committees) |
| **Files** | `59-yemen-safety-monitoring.sql` |
| **Objects created** | 8 risk_categories, 20 risk_register, 15 risk_assessments, 10 incidents, 20 mitigations, 15 CAPAs, 15 AEs + 5 SAEs, 10 followups, 10 safety_reports, 8 committee_reviews, 15 monitoring_plans, 30 visits, 40 findings, 20 CAPAs, 10 preventive, 10 deviations, 8 violations, 10 inspections + 10 reports, 10 compliance_reviews, 20 mitigation_actions |
| **Validation steps** | FK to applications, FK to committees, FK to users, severity CHECK, date validity |
| **Rollback** | `ROLLBACK` |
| **Expected entity counts** | total safety+monitoring rows: ~370 |

### Commit 11: Reporting and Observability

| Aspect | Detail |
|--------|--------|
| **Purpose** | Create report executions, KPIs, analytics snapshots |
| **Dependencies** | Commits 1–10 (all prior data) |
| **Files** | `60-yemen-reporting.sql` |
| **Objects created** | 20 report_executions, 50 kpi_results, 12 analytics_snapshots |
| **Validation steps** | FK to report_definitions, FK to users (executed_by), KPI value ranges, snapshot date ordering |
| **Rollback** | `ROLLBACK` |
| **Expected entity counts** | total reporting rows: ~82 |

### Commit 12: Integration and System

| Aspect | Detail |
|--------|--------|
| **Purpose** | Create integration logs, audit trail, system audit log |
| **Dependencies** | Commits 1–11 (all prior data) |
| **Files** | `61-yemen-system-integration.sql` |
| **Objects created** | 3 external_systems + 3 credentials, 30 integration_logs, 10 failures, 5 event_bus_config, 5 subscriptions, 30 event_outbox, 3 webhooks, 10 data_sync_jobs, 10 retry_queue, 500 system.audit_log, 500 audit.audit_logs + 1000 audit_details + 500 entity_changes + 500 hash_ledger, 10 maintenance_log, 50 search_audit, 500 search_indexes, 15 saved_searches, 30 rule_executions |
| **Validation steps** | FK to users, FK to external_systems, audit hash chain continuity, search_index tsvector validity |
| **Rollback** | `ROLLBACK` |
| **Expected entity counts** | audit_logs: 500, hash_ledger: 500, total system+integration+audit rows: ~3,700 |

### Commit 13: Final Verification

| Aspect | Detail |
|--------|--------|
| **Purpose** | Run comprehensive validation across entire database |
| **Dependencies** | All prior commits |
| **Files** | `62-yemen-verify.sql` |
| **Objects created** | None (read-only verification) |
| **Validation steps** | All 20 acceptance criteria checks, plus FK//orphan/sequence/CHECK/UNIQUE scans |
| **Rollback** | N/A (read-only) |

---

## 29. Final Acceptance Checklist

### 29.1 Workflow Coverage Checklist

- [ ] DRAFT state: 4 applications
- [ ] SUBMITTED state: 3 applications
- [ ] INITIAL_REVIEW state: 3 applications
- [ ] SCIENTIFIC_REVIEW state: 3 applications
- [ ] ETHICAL_REVIEW state: 3 applications
- [ ] COMMITTEE_REVIEW state: 4 applications
- [ ] APPROVED state: 3 applications (non-terminal, can CLOSE)
- [ ] REJECTED state: 2 applications (terminal)
- [ ] RETURNED state: 3 applications
- [ ] AWAITING_CONDITIONS state: 3 applications
- [ ] EVIDENCE_REJECTED state: 2 applications
- [ ] WITHDRAWN state: 2 applications (terminal)
- [ ] CLOSED state: 2 applications (non-terminal, can ARCHIVE)
- [ ] ARCHIVED state: 2 applications (terminal)
- [ ] SUBMIT transition: used 4 times
- [ ] ASSIGN_INITIAL_REVIEW transition: used 3 times
- [ ] ASSIGN_SCIENTIFIC_REVIEW transition: used 2 times
- [ ] ASSIGN_ETHICAL_REVIEW transition: used 1 time
- [ ] COMPLETE_SCIENTIFIC_REVIEW: used 2 times
- [ ] COMPLETE_ETHICAL_REVIEW: used 2 times
- [ ] APPROVE transition: used 2 times
- [ ] REJECT transition: used 1 time
- [ ] SET_CONDITIONS transition: used 1 time
- [ ] RETURN_TO_APPLICANT: used 4 times (one from each review stage)
- [ ] RESUBMIT transition: used 3 times
- [ ] SUBMIT_EVIDENCE: used 4 times (AWAITING_CONDITIONS + EVIDENCE_REJECTED)
- [ ] REJECT_EVIDENCE: used 2 times
- [ ] CLOSE transition: used 2 times
- [ ] ARCHIVE transition: used 4 times
- [ ] WITHDRAW transition: used 2 times
- [ ] Condition OVERDUE: 1 record
- [ ] Evidence rejected twice: 1 application, 2 rejections
- [ ] Appeal scenario: 2 records (1 approved, 1 rejected)
- [ ] Renewal scenario: 2 records (1 approved, 1 rejected)

### 29.2 Notification Coverage Checklist

- [ ] IN_APP channel notifications: delivered
- [ ] EMAIL channel notifications: delivered
- [ ] SMS channel notifications: delivered (if configured)
- [ ] PUSH channel notifications: delivered (if configured)
- [ ] DELIVERED status notifications: 100+
- [ ] SENT status notifications: 10+
- [ ] FAILED status notifications: 2
- [ ] RETRYING status notifications: 1
- [ ] PENDING status notifications: 5+
- [ ] Workflow transition notifications: created
- [ ] Condition reminder notifications: created
- [ ] Evidence submitted notifications: created
- [ ] Meeting scheduled notifications: created
- [ ] Certificate issued notifications: created
- [ ] Certificate revoked notifications: created
- [ ] Review assigned notifications: created
- [ ] Review completed notifications: created
- [ ] System announcement notifications: created

### 29.3 Certificate Lifecycle Checklist

- [ ] GENERATING certificate: 1
- [ ] ISSUED certificate: 8
- [ ] FAILED certificate: 1
- [ ] REVOKED certificate: 3 (with revocation reason)
- [ ] SUPERSEDED certificate: 2 (with supersedence chain)
- [ ] Certificate verification: VALID result
- [ ] Certificate verification: REVOKED result
- [ ] Certificate verification: SUPERSEDED result
- [ ] Certificate verification: NOT_FOUND result
- [ ] Certificate verification: ERROR result
- [ ] Public verification endpoint testable

### 29.4 Accreditation Lifecycle Checklist

- [ ] PENDING cycle: 1
- [ ] UNDER_REVIEW cycle: 1
- [ ] ACCREDITED cycle: 2
- [ ] CONDITIONAL cycle: 1 (with OPEN, MET, OVERDUE conditions)
- [ ] SUSPENDED cycle: 1 (with suspension reason)
- [ ] EXPIRED cycle: 1
- [ ] REVOKED cycle: 1 (with revocation reason)
- [ ] Accreditation assessment: 2 per cycle
- [ ] Accreditation assessment items: 5 per assessment
- [ ] Accreditation conditions: per cycle
- [ ] Accreditation evidence: per condition
- [ ] Accreditation decisions: 2 per cycle
- [ ] Cycle metrics: computed

### 29.5 Dashboard Coverage Checklist

- [ ] Total Applications widget: shows 40
- [ ] Applications by Status widget: 14 rows, all non-zero
- [ ] Pending Reviews widget: > 0
- [ ] Approval Rate widget: ~66%
- [ ] Average Review Time widget: ~21 days
- [ ] Committee Workload widget: 5 rows, all non-zero
- [ ] Recent Activity widget: 20 chronologically ordered entries
- [ ] User Distribution widget: 5 rows
- [ ] Institution Distribution widget: 41 rows, 20+ with count > 0
- [ ] Risk Level Distribution widget: 4 rows, all > 0
- [ ] Certificates by Status widget: 5 rows, all > 0
- [ ] Open Conditions widget: 20

### 29.6 Report Coverage Checklist

- [ ] Applications Summary Report: returns 40 rows
- [ ] Committee Activity Report: returns 5 rows with aggregate data
- [ ] User Activity Report: returns 96 rows with aggregate data
- [ ] Compliance Report: returns non-zero compliance scores
- [ ] Certificate Status Report: returns 15 certificates
- [ ] Safety Report: returns 15 adverse events + 5 SAEs
- [ ] Accreditation Status Report: returns 8 cycles
- [ ] Institution Performance Report: returns 41 institutions
- [ ] Audit Trail Report: returns 500+ entries
- [ ] KPI Dashboard Report: returns trend data over 12 months

### 29.7 Public Verification Checklist

- [ ] Certificate verification by serial number returns valid result
- [ ] Certificate verification by serial number returns revoked result
- [ ] Certificate verification by serial number returns not-found result
- [ ] Public endpoints accessible without authentication where required

### 29.8 Backup/Restore Checklist

- [ ] Backup creates consistent dump (~10,260 rows)
- [ ] Restore from backup preserves all data
- [ ] Sequence values correct after restore
- [ ] FK constraints satisfied after restore
- [ ] RLS policies functional after restore

### 29.9 Observability Checklist

- [ ] Metrics API returns non-zero values for all metrics
- [ ] Logs contain entries from all entity types
- [ ] SSE endpoint streams events
- [ ] Dashboard metrics match actual database counts
- [ ] KPI trends computable over 12 months

### 29.10 Security Model Checklist

- [ ] SUPER_ADMIN can access all entities
- [ ] ETHICS_ADMIN can access institution-scoped entities
- [ ] COMMITTEE_CHAIR can access committee-scoped entities
- [ ] REVIEWER can access only assigned entities
- [ ] RESEARCHER can access only own entities
- [ ] READ_ONLY user cannot create/edit/delete
- [ ] AUDITOR can view but not edit
- [ ] RLS blocks cross-institution access for non-admin roles
- [ ] RLS blocks cross-committee access for non-chair roles
- [ ] RLS prevents applicant from viewing others' applications
- [ ] RLS prevents applicant from deleting evidence in terminal states (RULE 12)
- [ ] Admin can delete evidence in non-terminal states (RULE 12)
- [ ] No user can delete evidence in terminal states (RULE 12)
- [ ] Soft delete is the only delete mechanism

---

## 30. Referential Integrity Strategy

### Insertion Order (Root → Leaf)

```
Commit 1:  security.institutions → departments → users → user_roles → user_profiles → sessions
Commit 2:  core.projects → project_* → core.applications → application_*
Commit 3:  committee.* (committees, members, meetings, agendas, reviews)
Commit 4:  workflow.workflow_instances → workflow_actions → workflow_history → workflow_tasks
Commit 5:  documents.* (document_types → documents → versions → access → approvals → certificates)
Commit 6:  communication.* (notifications → logs, messages → recipients)
Commit 7:  safety.*, monitoring.*
Commit 8:  reporting.*, system.* (audit_log), integration.*
Commit 9:  audit.* (audit_logs → details, hash_ledger)
```

### Strategy

1. Use `SET session_replication_role = 'replica'` at session level to disable FK triggers during bulk insert
2. Insert in dependency order (leaf tables first within same-schema)
3. After each commit, verify all FK constraints are satisfied
4. Reset sequences after each commit: `SELECT setval('seq', max(id)) FROM table`
5. Commit each step as an atomic transaction
6. NEVER commit partial data that would fail validation

---

## 21. Data Generation Strategy

### Synthetic Data Rules

1. **Names**: Generate Arabic names from a curated list of ~200 common Yemeni names
2. **Emails**: `firstname.lastname@institution-code.ye`
3. **Passwords**: All set to `P@ssw0rd123` via `security.fn_hash_password()` (development only)
4. **Phone numbers**: +967 XXX XXX XXX format
5. **Dates**: Realistic timeline spanning 2024-01 to 2026-12
6. **Research topics**: Mixed communicable/non-communicable disease focus
7. **Arabic text**: All Arabic text fields have grammatically correct modern standard Arabic
8. **English text**: All English fields are proper translations

### Research Topic Mix

| Category | Projects | Examples |
|----------|----------|----------|
| Communicable diseases | 6 | TB, Malaria, Cholera, Dengue, COVID-19, Leishmaniasis |
| Maternal & child health | 4 | Antenatal care, neonatal mortality, breastfeeding, vaccination |
| Nutrition | 3 | Malnutrition, micronutrient deficiency, food security |
| Non-communicable diseases | 5 | Hypertension, diabetes, cancer, kidney disease, thalassemia |
| Environmental health | 3 | Water quality, air pollution, climate change |
| Mental health | 2 | PTSD, depression in conflict settings |
| Health systems | 3 | Primary care, health financing, referral systems |
| Digital health | 2 | mHealth, telemedicine |
| Clinical trials | 2 | Drug trials (phase III, IV) |

### Risk Level Mix

| Risk Level | Projects |
|------------|----------|
| MINOR (1) | 8 |
| MODERATE (2) | 12 |
| MAJOR (3) | 7 |
| CRITICAL (4) | 3 |

### Application Status Distribution

| Status | Count | Strategy |
|--------|-------|----------|
| DRAFT | 5 | Incomplete applications |
| SUBMITTED | 4 | Recently submitted |
| INITIAL_REVIEW | 3 | Under initial screening |
| SCIENTIFIC_REVIEW | 4 | Assigned to reviewers |
| ETHICAL_REVIEW | 4 | Under ethics review |
| COMMITTEE_REVIEW | 4 | Awaiting committee meeting |
| APPROVED | 4 | Approved, certificate issued |
| REJECTED | 3 | Rejected by committee |
| RETURNED | 3 | Returned for revisions |
| AWAITING_CONDITIONS | 4 | Conditions not yet met |
| EVIDENCE_REJECTED | 2 | Evidence submission rejected |
| WITHDRAWN | 2 | Withdrawn by applicant |
| CLOSED | 2 | Closed after completion |
| ARCHIVED | 2 | Archived records |

---

## 22. Seed Generation Strategy

### File Naming Convention

```
backend/seed/50-yemen-institutions.sql     # Commit 1: Institutions
backend/seed/51-yemen-users.sql            # Commit 1: Users
backend/seed/52-yemen-projects.sql         # Commit 2: Projects
backend/seed/53-yemen-applications.sql     # Commit 2: Applications
backend/seed/54-yemen-committees.sql       # Commit 3: Committees
backend/seed/55-yemen-reviews.sql          # Commit 3: Reviews
backend/seed/56-yemen-workflow.sql         # Commit 4: Workflow instances
backend/seed/57-yemen-documents.sql        # Commit 5: Documents & certificates
backend/seed/58-yemen-communication.sql    # Commit 6: Notifications & messages
backend/seed/59-yemen-safety-monitoring.sql  # Commit 7: Safety & monitoring
backend/seed/60-yemen-audit-reporting.sql    # Commit 8-9: Audit, reporting, system
backend/seed/61-yemen-verify.sql           # Final verification
```

### Seed File Conventions

1. Each file is **idempotent** (can be run multiple times)
2. Each file starts with `BEGIN` and ends with `COMMIT`
3. Sequence values are set at end of each file via `setval()`
4. RLS is bypassed via `SET session_replication_role = 'replica'` at top
5. `app.user_id` is set to admin (1) for all operations
6. Each file ends with a verification query
7. All IDs are generated via `nextval()` — no hardcoded IDs
8. Arabic text uses proper UTF-8 encoding

---

## 23. Validation Strategy

### Automated Validation Script

After each commit, run `verify-seed.sql` which checks:

1. **Zero FK violations**: Query `pg_constraint` for violated constraints
2. **Zero orphan rows**: Every FK reference has a valid parent
3. **Zero invalid workflow states**: All workflow_instances.current_state_id exists
4. **Zero invalid transitions**: All workflow_actions.transition_id is valid
5. **Valid certificates**: All status values are within domain
6. **Valid condition statuses**: OPEN/MET/NOT_MET/WAIVED enforcement
7. **Valid dates**: No end_date before start_date, no future birth dates
8. **Unique constraints**: No duplicate emails, usernames, codes
9. **Sequence health**: `nextval` > `max(id)` for all 205 sequences
10. **Soft delete consistency**: `deleted_at IS NULL OR deleted_by IS NOT NULL`
11. **RLS access**: Verify each role can/cannot access expected data

### Manual Validation

1. Login as each role type and verify page access
2. Navigate every workflow state
3. Execute every report type
4. View every dashboard widget
5. Search across all entity types
6. Verify certificate verification URL
7. Verify notification delivery

---

## 24. Commit-by-Commit Implementation Plan

### Commit 1: Security & Institution Hierarchy
- `50-yemen-institutions.sql` — 40 institutions + departments across 8 governorates
- `51-yemen-users.sql` — 96 users with roles, profiles, sessions, login audit
- **Verify**: FK integrity, unique constraints, RLS policies
- **Estimated rows**: ~600

### Commit 2: Projects & Applications
- `52-yemen-projects.sql` — 30 projects with team, sites, funding, keywords
- `53-yemen-applications.sql` — 40 applications across all workflow states
- **Verify**: FK to institutions, FK to users, application_status values
- **Estimated rows**: ~700

### Commit 3: Committees & Reviews
- `54-yemen-committees.sql` — 5 committees, 43 members, meetings, agendas
- `55-yemen-reviews.sql` — Review assignments, ethics/scientific reviews, scores
- **Verify**: Committee membership, meeting attendance, review assignments
- **Estimated rows**: ~1,300

### Commit 4: Workflow Instances
- `56-yemen-workflow.sql` — 40 workflow instances, actions, history, tasks
- **Verify**: State transitions, task assignments, escalation rules
- **Estimated rows**: ~850

### Commit 5: Documents & Certificates
- `57-yemen-documents.sql` — 200+ documents, versions, approvals, 15 certificates
- **Verify**: Document access, certificate lifecycle, verification log
- **Estimated rows**: ~1,500

### Commit 6: Communication
- `58-yemen-communication.sql` — 300 notifications, 150 messages, 10 announcements
- **Verify**: Delivery logs, read/unread status, preferences
- **Estimated rows**: ~1,200

### Commit 7: Safety & Monitoring
- `59-yemen-safety-monitoring.sql` — Adverse events, risk, CAPA, inspections
- **Verify**: FK to applications, severity values, date ranges
- **Estimated rows**: ~300

### Commit 8: Cross-Cutting
- `60-yemen-audit-reporting.sql` — Audit log (500+ entries), report executions, KPIs, system audit
- **Verify**: Audit integrity, hash chain, report outputs
- **Estimated rows**: ~3,000

### Commit 9: Final Verification
- `61-yemen-verify.sql` — Full validation, FK check, sequence check, RLS verification
- **Data generation is complete; no new rows**

---

## 25. Risks

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| PK/sequence mismatch | Data integrity | Medium | Always setval after inserts |
| RLS blocking inserts | Insert failure | Medium | Use superuser or SECURITY DEFINER |
| Arabic encoding issues | Data corruption | Low | UTF-8 validation at write time |
| FK violations in bulk insert | Rollback | Medium | Dependency-ordered commits |
| CHECK constraint violations | Insert failure | Low | Validate against canonical schema |
| UUID collisions | Uniqueness error | Very low | gen_random_uuid() or explicit UUIDs |
| Timestamp ordering conflicts | Logic errors | Low | Incremental time generation |
| Session replication role not available | Cannot bypass FKs | Low | Check GUC before use |
| Materialized view refresh failure | MV stale | Low | Use REFRESH WITH NO DATA |
| Inconsistent soft-delete patterns | Data inconsistency | Medium | Use canonical CHECK constraints |

---

## 26. Rollback Strategy

Each seed file begins with a savepoint and can be rolled back:

```sql
BEGIN;
SAVEPOINT seed_sp;

-- Data generation...

-- If verification fails:
ROLLBACK TO seed_sp;
-- Or: ROLLBACK;

-- If verification passes:
RELEASE seed_sp;
COMMIT;
```

For full rollback of all Phase 7 data:

```sql
-- Can re-use cleanup-test-data.sql with modifications
-- to preserve the new reference data but remove Yemen data
```

---

## 27. Acceptance Criteria

1. [ ] All 14 workflow states populated with valid applications
2. [ ] All 32 workflow transitions exercised
3. [ ] All 96 users can log in with correct role-based access
4. [ ] All 5 committees have meeting history, agenda items, minutes
5. [ ] All 40 institutions have correct departments hierarchy
6. [ ] Certificate lifecycle (ISSUED, REVOKED, SUPERSEDED) verified
7. [ ] Accreditation lifecycle (7 statuses) verified
8. [ ] Notification delivery (all channels, all statuses) verified
9. [ ] Dashboard widgets show non-zero values
10. [ ] Report executions return valid results
11. [ ] Audit log contains meaningful entries for all entity types
12. [ ] RLS prevents unauthorized access (verified per role)
13. [ ] Zero FK violations across entire database
14. [ ] Zero orphan rows
15. [ ] All 205 sequences are ahead of max(id)
16. [ ] Zero CHECK constraint violations
17. [ ] All UNIQUE constraints satisfied
18. [ ] Search returns results for all entity types
19. [ ] Soft delete works correctly (deleted_at + deleted_by)
20. [ ] Backup and restore completes without errors

---

*This document constitutes the implementation contract for Phase 7. No SQL generation shall begin until this contract is reviewed and approved.*
