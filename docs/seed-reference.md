# Seed Reference — Ethics ERM System

**Version:** 1.0.0-rc2
**Last Updated:** 2026-07-22
**Total Seed Files:** 72

---

## Table of Contents

1. [Overview](#1-overview)
2. [Execution Order](#2-execution-order)
3. [Domain Groups](#3-domain-groups)
   - [Infrastructure & Tracking](#31-infrastructure--tracking)
   - [Reference Data](#32-reference-data)
   - [Security](#33-security)
   - [Committee](#34-committee)
   - [Core](#35-core)
   - [Workflow](#36-workflow)
   - [Documents](#37-documents)
   - [Communication & Notifications](#38-communication--notifications)
   - [Safety](#39-safety)
   - [Ethics Risk & Consent](#310-ethics-risk--consent)
   - [Accreditation](#311-accreditation)
   - [RLS & Security Fixes](#312-rls--security-fixes)
   - [Audit & Monitoring](#313-audit--monitoring)
   - [Templates](#314-templates)
   - [Test Data](#315-test-data)
4. [Idempotency Guide](#4-idempotency-guide)
5. [Re-seeding Strategy](#5-re-seeding-strategy)

---

## 1. Overview

Seed files populate the database with reference data, test data, and configuration. They are **not** run automatically — apply manually via `psql`.

### Applying All Seeds

```bash
for f in backend/seed/*.sql; do
  psql -U postgres -d ethics_db -f "$f"
done
```

### Applying a Single Domain

To re-apply only one domain, use the specific file numbers listed below.

---

## 2. Execution Order

Seeds are designed to be applied in numeric order. Files with the same prefix number are independent and can be applied in any order within that group.

| Prefix | Purpose | Dependency |
|--------|---------|------------|
| `00` | Infrastructure (tracker, truncate) | None |
| `01` | Reference data | None |
| `02` | Users, roles, permissions | 01 |
| `03` | Committees | 02 |
| `04` | Documents | 01 |
| `05` | Workflow definitions | 01 |
| `06` | Projects and applications | 02, 05 |
| `07` | Workflow instances | 05, 06 |
| `08` | Reviews | 03, 06 |
| `09` | Meetings | 03, 06 |
| `10`-`29` | Expansion data | 02-09 |
| `30`-`39` | RLS, accreditation schema | Previous seeds |
| `40`-`49` | Workflow fixes, certificates | 05, 07 |
| `50`-`58` | Notification, templates | Previous seeds |
| `90`-`99` | Test data | All above |

---

## 3. Domain Groups

### 3.1 Infrastructure & Tracking

| File | Purpose | Idempotent | Tables |
|------|---------|-----------|--------|
| `00-seed-tracker.sql` | Creates seed tracking table to record applied seeds | Yes | `system.seed_tracking` |
| `00-truncate.sql` | **DANGEROUS**: Truncates all tables (for dev reset) | Yes | All tables |

### 3.2 Reference Data

| File | Purpose | Idempotent | Tables |
|------|---------|-----------|--------|
| `01-reference.sql` | Countries, governorates, nationalities, document types, classification levels | No | `reference.countries`, `reference.governorates`, `reference.nationalities`, `documents.document_types`, `documents.classifications` |
| `10-yemen-institutions.sql` | Yemen institutions, faculties, departments | No | `reference.institutions`, `reference.faculties`, `reference.departments` |
| `26-reference-data-crud.sql` | CRUD operations for reference data | Partial | `reference.*` |
| `35-reference-add-statuses.sql` | Additional status values | No | Various status tables |
| `50-yemen-institutions.sql` | Extended Yemen institution data | No | `reference.institutions` |

### 3.3 Security

| File | Purpose | Idempotent | Tables |
|------|---------|-----------|--------|
| `02-users.sql` | System users (admin, researcher, reviewers), roles, permissions, institutions, departments | No | `security.users`, `security.roles`, `security.permissions`, `security.role_permissions`, `security.user_roles`, `security.institutions`, `security.departments` |
| `51-yemen-users.sql` | Additional Yemen-specific users | No | `security.users` |

### 3.4 Committee

| File | Purpose | Idempotent | Tables |
|------|---------|-----------|--------|
| `03-committees.sql` | Committee types (IRB, IACUC, IBC), committees, members, member roles | Partial | `committee.committee_types`, `committee.committees`, `committee.committee_members`, `committee.committee_member_roles`, `committee.committee_roles` |
| `08-reviews.sql` | Review forms (SCIENTIFIC, ETHICS, EXPEDITED), assignments, reviews | No | `committee.review_forms`, `committee.review_assignments`, `committee.ethics_reviews`, `committee.scientific_reviews` |
| `09-meetings-etc.sql` | Meetings, agenda items, attendance, minutes, decisions, action items | No | `committee.committee_meetings`, `committee.meeting_agenda`, `committee.meeting_attendance`, `committee.meeting_minutes`, `committee.meeting_decisions`, `committee.action_items` |
| `21-committee-expansion.sql` | Expanded committee types (REC, SRC, DSMB), new committees, users | No | `committee.committee_types`, `committee.committees`, `committee.committee_members`, `security.users` |
| `22-add-member-roles.sql` | Adds role_id and audit columns to committee_members | Yes | `committee.committee_members` |

### 3.5 Core

| File | Purpose | Idempotent | Tables |
|------|---------|-----------|--------|
| `06-projects-apps.sql` | Projects and applications in various states | No | `core.projects`, `core.applications` |
| `20-remaining-core-data.sql` | Comprehensive: team members, funding, keywords, sites, tags, quorum logs, review conflicts, scores, agenda items, document versions, user profiles, access policies, SLA, amendments, closures, renewals, dashboard/report definitions | No | `core.project_team_members`, `core.project_funding`, `core.project_keywords`, `core.sites`, `core.tags`, `committee.quorum_logs`, `committee.review_conflicts`, `committee.review_scores`, `committee.agenda_items`, `documents.document_versions`, `security.user_profiles`, `documents.access_policies`, `workflow.workflow_sla`, `workflow.workflow_variables`, `core.amendments`, `core.closures`, `core.renewals`, `system.dashboard_widgets`, `system.report_definitions` |
| `41-application-conditions.sql` | Conditional approval conditions linked to workflow states | Yes | `core.application_conditions` |
| `52-yemen-projects.sql` | Yemen-specific project data | No | `core.projects` |
| `53-yemen-applications.sql` | Yemen-specific application data | No | `core.applications` |

### 3.6 Workflow

| File | Purpose | Idempotent | Tables |
|------|---------|-----------|--------|
| `05-workflow.sql` | Workflow definitions, states, transitions | No | `workflow.workflow_definitions`, `workflow.workflow_states`, `workflow.workflow_transitions` |
| `07-workflow-instances.sql` | Workflow instances for existing applications | No | `workflow.workflow_instances` |
| `36-workflow-add-states.sql` | Additional workflow states | No | `workflow.workflow_states` |
| `37-workflow-add-transitions.sql` | Additional workflow transitions | No | `workflow.workflow_transitions` |
| `38-workflow-add-constraints.sql` | Workflow constraint rules | No | `workflow.workflow_constraints` |
| `40-init-workflow-idempotent.sql` | Idempotent workflow initialization | Yes | `workflow.*` |
| `42-fix-workflow-init-rls.sql` | RLS fix for workflow initialization | Yes | RLS policies |
| `43-fix-workflow-update-rls.sql` | RLS fix for workflow updates | Yes | RLS policies |
| `44-fix-terminal-states.sql` | Fix terminal state definitions | Yes | `workflow.workflow_states` |

### 3.7 Documents

| File | Purpose | Idempotent | Tables |
|------|---------|-----------|--------|
| `04-documents.sql` | Document types and templates | No | `documents.document_types`, `documents.templates` |
| `54-yemen-documents.sql` | Yemen-specific document data | No | `documents.*` |

### 3.8 Communication & Notifications

| File | Purpose | Idempotent | Tables |
|------|---------|-----------|--------|
| `16-rls-communication.sql` | RLS policies for communication tables | Yes | RLS policies |
| `19-additional-communication.sql` | Additional communication data | No | `communication.*` |
| `27-notification-channel-config.sql` | Notification channel configuration (email, push, SMS) | No | `communication.notification_channels`, `communication.channel_configs` |
| `48-notification-source-columns.sql` | Adds source tracking columns to notifications | Yes | `communication.notifications` |
| `49-notification-preferences.sql` | User notification preferences | No | `communication.notification_preferences` |
| `50-notification-logs-rls-fix.sql` | RLS fix for notification logs | Yes | RLS policies |

### 3.9 Safety

| File | Purpose | Idempotent | Tables |
|------|---------|-----------|--------|
| `17-safety-data.sql` | Adverse events, risk register, corrective actions | No | `safety.adverse_events`, `safety.risk_register`, `safety.corrective_actions` |

### 3.10 Ethics Risk & Consent

| File | Purpose | Idempotent | Tables |
|------|---------|-----------|--------|
| `28-ethics-risk-assessment.sql` | Ethics risk assessment data | No | `ethics_risk.*` |
| `29-informed-consent.sql` | Consent templates, versions, per-application consents, review comments | No (DDL + INSERT) | `ethics_risk.consent_templates`, `ethics_risk.consent_template_versions`, `ethics_risk.application_consents`, `ethics_risk.consent_review_comments` |
| `30-rls-ethics-risk.sql` | RLS policies for ethics risk tables | Yes | RLS policies |

### 3.11 Accreditation

| File | Purpose | Idempotent | Tables |
|------|---------|-----------|--------|
| `31-accreditation-schema.sql` | DDL: cycles, evaluations, criteria, evidence, decisions | No | `accreditation.*` (schema creation) |
| `32-accreditation-rls.sql` | RLS policies for accreditation tables | Yes | RLS policies |
| `33-accreditation-seed.sql` | Accreditation seed data | No | `accreditation.*` |
| `51-accreditation-workflow.sql` | Accreditation workflow definitions | No | `workflow.*` |

### 3.12 RLS & Security Fixes

| File | Purpose | Idempotent | Tables |
|------|---------|-----------|--------|
| `11-rls-fix.sql` | RLS policy corrections | Yes | RLS policies |
| `12-soft-delete.sql` | Adds soft-delete columns (`deleted_at`, `deleted_by`) | Yes | ~80 transaction tables |
| `14-rls-complete.sql` | Complete RLS policy set | Yes | All tables |
| `15-rls-select-policy-fix.sql` | Fixes SELECT policies | Yes | RLS policies |
| `16-rls-enable.sql` | Enables RLS on all tables | Yes | All tables |
| `17-rls-cud-policies.sql` | CREATE/UPDATE/DELETE policies | Yes | RLS policies |
| `24-prod-readiness-fixes.sql` | Production readiness fixes | Yes | Various |
| `25-rls-monitoring-reporting.sql` | RLS for monitoring/reporting | Yes | RLS policies |
| `33-fix-register-rls.sql` | **Critical**: SECURITY DEFINER function for registration (PostgreSQL 18.3 Windows bug fix) | Yes | `security.fn_register_user` |
| `34-documents-insert-rls.sql` | INSERT policy for documents table | Yes | `documents.documents` |

### 3.13 Audit & Monitoring

| File | Purpose | Idempotent | Tables |
|------|---------|-----------|--------|
| `13-audit-triggers.sql` | Audit trigger functions | Yes | `system.fn_log_audit`, triggers on all tables |
| `13-data-dictionary.sql` | Data dictionary views | Yes | `system.*` (views) |
| `16-pagination-indexes.sql` | Performance indexes for pagination | Yes | Indexes on all tables |
| `18-audit-fix.sql` | Audit trigger fixes | Yes | Triggers |
| `18-monitoring-data.sql` | Monitoring data and views | Yes | `system.*` |
| `45-certificates.sql` | Certificate generation data | No | `core.certificates` |
| `46-certificate-rls-hotfix.sql` | RLS fix for certificates | Yes | RLS policies |
| `47-public-verify-function.sql` | Public certificate verification function | Yes | `core.fn_verify_certificate` |
| `99-fix-checksums.sql` | Fixes checksums for data integrity | Yes | Various |

### 3.14 Templates

| File | Purpose | Idempotent | Tables |
|------|---------|-----------|--------|
| `55-template-schema.sql` | DDL: template tables, categories, versions, snapshots | No | `templates.*` (schema creation) |
| `56-template-categories-variables.sql` | Template categories and variable definitions | No | `templates.categories`, `templates.variable_definitions` |
| `57-template-seed-content.sql` | Pre-built template content (12 templates across 12 categories) | No | `templates.templates`, `templates.template_versions` |
| `58-template-database-integrity.sql` | Database integrity checks for templates | Yes | `templates.*` |

### 3.15 Test Data

| File | Purpose | Idempotent | Tables |
|------|---------|-----------|--------|
| `90-gen-test-data.sql` | Generated test data | No | Various |
| `95-pilot-dataset.sql` | Pilot dataset for UAT | No | Various |
| `96-realistic-data.sql` | Realistic production-like data | No | Various |

---

## 4. Idempotency Guide

### Idempotent (Safe to Re-run)

Files marked as idempotent use:
- `IF NOT EXISTS` for DDL
- `ON CONFLICT DO NOTHING` for data
- `CREATE OR REPLACE` for functions
- `ADD COLUMN IF NOT EXISTS` for schema changes

These can be safely re-applied without errors.

### Non-Idempotent (Will Fail on Re-run)

Files without idempotency will throw errors on re-run due to:
- Duplicate key violations (INSERT without ON CONFLICT)
- Already-exists errors (CREATE without IF NOT EXISTS)

### Handling Non-Idempotent Seeds

To re-apply non-idempotent seeds:

**Option 1: Truncate first (development only)**
```bash
psql -U postgres -d ethics_db -f backend/seed/00-truncate.sql
# Then apply all seeds in order
```

**Option 2: Drop and recreate database**
```bash
psql -U postgres -c "DROP DATABASE ethics_db"
psql -U postgres -c "CREATE DATABASE ethics_db"
# Re-run full initialization + seeds
```

---

## 5. Re-seeding Strategy

### Development Reset

```bash
# 1. Truncate all data
psql -U postgres -d ethics_db -f backend/seed/00-truncate.sql

# 2. Re-apply seeds in order
for f in backend/seed/*.sql; do
  psql -U postgres -d ethics_db -f "$f"
done
```

### Production-like Reset

```bash
# 1. Drop and recreate
psql -U postgres -c "DROP DATABASE IF EXISTS ethics_db"
psql -U postgres -c "CREATE DATABASE ethics_db"

# 2. Initialize schema
psql -U postgres -d ethics_db -f "DDL Script.sql"
psql -U postgres -d ethics_db -f ethics_db_tables.sql
psql -U postgres -d ethics_db -f ethics_db_functions.sql
psql -U postgres -d ethics_db -f ethics_db_tables_constraints.sql

# 3. Apply seeds (skip test data 90-99)
for f in backend/seed/[0-8]*.sql; do
  psql -U postgres -d ethics_db -f "$f"
done
```

### Selective Re-seeding

To re-seed only one domain, identify the file numbers from the domain groups above and apply only those files. Note that dependent domains may need to be re-seeded first.
