# Master Schema v2.0 — Enterprise Architecture Documentation

## Overview

| Schema | Tables | Purpose |
|--------|--------|---------|
| security | 25 | Users, roles, permissions, governance |
| committee | 26 | Committees, members, reviews, meetings |
| core | 24 | Applications, projects, research |
| documents | 12 | Documents, templates, retention |
| workflow | 14 | Workflows, states, transitions, automation |
| communication | 5 | Notifications, announcements |
| monitoring | 10 | Compliance, inspections, visits |
| reporting | 5 | Reports, dashboards, analytics |
| integration | 10 | External systems, webhooks, sync |
| reference | 15 | Lookup values, national registries |
| safety | 12 | Risk, incidents, adverse events |
| audit | 5 | Audit logs, entity changes |
| system | 14 | Config, rules, search, maintenance |
| **Total** | **176** | |

## Phase 16 — Governance Layer

### security.responsibility_types
Reference table for responsibility types.

| Column | Type | Description |
|--------|------|-------------|
| id | BIGINT PK | Identity |
| code | VARCHAR(50) UNIQUE | `REVIEWER`, `APPROVER`, `SIGNER`, etc. |
| name_ar | VARCHAR(200) | Arabic name |
| name_en | VARCHAR(200) | English name |

**Seed data:** 6 types: Reviewer, Approver, Signer, Observer, Coordinator, Secretary

### security.user_responsibilities
Maps users to responsibilities on specific entities (polymorphic).

| Column | Type | FK / Ref |
|--------|------|----------|
| user_id | BIGINT NOT NULL | → security.users |
| responsibility_type_id | BIGINT NOT NULL | → security.responsibility_types |
| entity_type | VARCHAR(50) | e.g. `application`, `project`, `committee` |
| entity_id | BIGINT | Polymorphic FK |
| assigned_by | BIGINT | → security.users |

**RLS:** Users see own responsibilities; admins see all.

## Phase 17 — Committee Governance

### committee.member_terms
Tracks committee membership periods with appointment/termination decisions.

| Column | Description |
|--------|-------------|
| member_id → committee.committee_members | The member |
| start_date / end_date | Membership period |
| appointment_decision_no | قرار التعيين |
| termination_decision_no | قرار الإنهاء |

### committee.member_qualifications
Academic and professional qualifications of committee members.

| Column | Description |
|--------|-------------|
| member_id → committee.committee_members | The member |
| specialization | التخصص |
| academic_degree | الدرجة العلمية |
| is_verified / verified_by | Verification workflow |

### committee.member_conflicts
Conflict of interest declarations (independent from review_conflicts).

| Column | Description |
|--------|-------------|
| member_id → committee.committee_members | The member |
| entity_type / entity_id | Related entity |
| conflict_type | Type of conflict |
| declared_at / resolved_at | Timeline |

## Phase 18 — Research Governance

### core.research_categories
Research type classification (Clinical, Behavioral, Social, Laboratory, Animal).

### core.risk_classifications
Risk severity levels with numerical scores (Low=1, Medium=2, High=3, Critical=4).

### core.vulnerable_populations
Special population categories requiring additional safeguards.

| Column | Description |
|--------|-------------|
| code | e.g. `CHILDREN`, `PREGNANT_WOMEN` |
| safeguards_required | Default safeguard measures |

### core.research_population_links
Many-to-many link between projects and vulnerable populations.

## Phase 19 — Document Governance

### documents.document_classifications
Classification levels: Public, Internal, Confidential, Secret — each with clearance requirements.

### documents.document_retention_rules
Per-document-type retention policy.

### documents.document_disposal_logs
Audit trail for document destruction.

## Phase 20 — Enterprise Risk Management

### safety.risk_register
Central risk register with computed risk scores.

| Column | Description |
|--------|-------------|
| risk_code | Unique identifier |
| likelihood × impact | → risk_score (computed) |
| risk_level | Derived severity |
| owner_id → security.users | Risk owner |
| status | IDENTIFIED → ASSESSED → MITIGATED → CLOSED |

### safety.risk_mitigations
Treatment plans for identified risks.

### safety.risk_incidents
Incident reports linked to risks.

### safety.corrective_actions
Corrective and preventive actions (CAPA) linked to incidents.

## Phase 21 — National Registry Layer

### reference.institutions_registry
National register of all institutions (universities, hospitals, research centers).

| Column | Description |
|--------|-------------|
| national_id | Unique national identifier |
| is_accredited / accreditation_body | Accreditation tracking |

### reference.professions_registry
Standardized profession codes (باحث, طبيب, صيدلي, etc.).

### reference.licenses_registry
Professional licenses with verification workflow.

| Column | Description |
|--------|-------------|
| user_id → security.users | License holder |
| profession_id → reference.professions_registry | Profession |
| verification_status | PENDING → VERIFIED → REJECTED |

## Phase 22 — Enterprise Search

### system.search_indexes
Full-text search index using PostgreSQL tsvector.

| Column | Description |
|--------|-------------|
| search_vector | tsvector column with GIN index |
| language | 'arabic' or 'english' |

### system.saved_searches
User-saved search queries with JSONB criteria.

### system.search_audit
Audit log for all search operations.

## Phase 23 — Business Rules Engine

### system.rule_conditions
Conditions that trigger rules (field_name + operator + value).

### system.rule_actions
Actions executed when conditions are met.

### system.rule_executions
Execution log with timing and results.

## Phase 24 — Workflow Automation

### workflow.workflow_events
Event log for workflow instances (audit trail).

### workflow.workflow_triggers
Event → Workflow trigger configuration.

| Column | Description |
|--------|-------------|
| trigger_event | e.g. `APPLICATION_SUBMITTED` |
| trigger_conditions | JSONB conditions |
| target_workflow_id → workflow.workflows | Workflow to start |

### workflow.workflow_schedulers
Cron-based workflow scheduler.

## Phase 25 — Enterprise Integration Layer

### integration.external_systems
Registered external system connections.

### integration.integration_credentials
Encrypted credentials for integrations.

### integration.integration_failures
Failure log with retry tracking.

### integration.data_sync_jobs
Synchronization job tracking.

## RLS Policies

New tables with RLS:

| Table | Policy |
|-------|--------|
| security.user_responsibilities | User sees own, admin sees all |
| committee.member_* | Members see own, admin sees all |
| safety.risk_* | Owner/assignee sees own, admin sees all |
| system.saved_searches | User sees own + shared, admin sees all |
| integration.integration_credentials | Admin only |
| integration.integration_failures | Admin only |

Pattern: `(user_id = app.user_id) OR fn_is_admin(app.user_id)`

## Key Indexes

| Table | Index |
|-------|-------|
| system.search_indexes | GIN(tsvector) |
| system.search_indexes | (entity_type, entity_id) |
| safety.risk_register | owner_id, status |
| integration.data_sync_jobs | external_system_id, status |
| workflow.workflow_events | workflow_instance_id, event_type |

## Seed Data Summary

| Table | Records |
|-------|---------|
| security.responsibility_types | 6 |
| core.research_categories | 5 |
| core.risk_classifications | 4 |
| core.vulnerable_populations | 4 |
| documents.document_classifications | 4 |
| reference.professions_registry | 7 |
