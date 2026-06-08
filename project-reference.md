# Project Reference Data
## National Ethics & Medical Research Governance Platform

---

## Database Connection

| Parameter | Value |
|-----------|-------|
| Host | localhost |
| Port | 5432 |
| Database | ethics_db |
| PostgreSQL Version | 18 |
| Superuser | postgres |
| App Owner | ethics_owner |

## PostgreSQL Roles

| Role | Purpose | Login |
|------|---------|-------|
| postgres | Superuser | Yes |
| administrator | Superuser | Yes |
| ethics_owner | Schema owner | Yes |
| ethics_migration | DDL execution | Yes |
| ethics_app | Backend API | Yes |
| ethics_workflow | Workflow Engine | Yes |
| ethics_reporting | Reports | Yes |
| ethics_audit | Audit | Yes |
| ethics_readonly | Read-only | Yes |
| ethics_service | Role group (no login) | No |

## Schemas (14 total)

| Schema | Owner | Status |
|--------|-------|--------|
| security | → ethics_owner | Needs ownership change |
| core | → ethics_owner | Needs ownership change |
| workflow | → ethics_owner | Needs ownership change |
| committee | → ethics_owner | Needs ownership change |
| documents | → ethics_owner | Needs ownership change |
| monitoring | → ethics_owner | Needs ownership change |
| safety | → ethics_owner | Needs ownership change |
| communication | → ethics_owner | Needs ownership change |
| audit | → ethics_owner | Needs ownership change |
| reporting | → ethics_owner | Needs ownership change |
| reference | → ethics_owner | Needs ownership change |
| integration | → ethics_owner | Created, empty |
| system | → ethics_owner | Created, empty |
| public | pg_database_owner | Default |

## Current Database Objects

| Object Type | Count |
|-------------|-------|
| Tables | 120 |
| Indexes | 310 |
| Views | 0 |
| Functions (business) | 0 |
| Triggers | 0 |
| RLS Policies | 0 |

## Extensions Installed

- citext 1.8
- pgcrypto 1.4
- uuid-ossp 1.1
- plpgsql 1.0

## RBAC Roles (System)

| Code | Name (AR) |
|------|-----------|
| SUPER_ADMIN | Super Administrator |
| SYS_ADMIN | System Administrator |
| ETHICS_ADMIN | Ethics Administrator |
| COMMITTEE_CHAIR | Committee Chairman |
| COMMITTEE_MEMBER | Committee Member |
| SCIENTIFIC_REVIEWER | Scientific Reviewer |
| LEGAL_REVIEWER | Legal Reviewer |
| RESEARCHER | Researcher |
| INST_COORDINATOR | Institution Coordinator |
| AUDITOR | Auditor |
| COMPLIANCE_OFFICER | Compliance Officer |
| AI_ANALYST | AI Analyst |

## Application Statuses

| Status Code | Description |
|-------------|-------------|
| DRAFT | مسودة |
| SUBMITTED | مقدم |
| UNDER_REVIEW | قيد المراجعة |
| APPROVED | موافق عليه |
| CONDITIONAL_APPROVED | موافق بشروط |
| REJECTED | مرفوض |
| AMENDMENT_REQUESTED | طلب تعديل |
| WITHDRAWN | مسحوب |
| CLOSED | مغلق |

## Review Types

| Code | Description |
|------|-------------|
| SCIENTIFIC | مراجعة علمية |
| ETHICS | مراجعة أخلاقية |
| LEGAL | مراجعة قانونية |

## Committee Decision Types

| Code | Name | Is Approval |
|------|------|-------------|
| APPROVED | موافق | true |
| CONDITIONAL_APPROVAL | موافق بشروط | true |
| DEFERRED | مؤجل | false |
| REJECTED | مرفوض | false |

## Vote Types

| Code | Name |
|------|------|
| APPROVE | موافق |
| DISAPPROVE | غير موافق |
| ABSTAIN | ممتنع |
## Risk Levels

| Code | Name | Severity Score |
|------|------|----------------|
| LOW | منخفض | 1 |
| MEDIUM | متوسط | 2 |
| HIGH | مرتفع | 3 |

## Priority Levels

| Code | Name | Order |
|------|------|-------|
| LOW | منخفضة | 1 |
| NORMAL | عادية | 2 |
| HIGH | عالية | 3 |
| URGENT | عاجلة | 4 |

## Institution Types

| Code | Name (AR) |
|------|-----------|
| UNIVERSITY | جامعة |
| HOSPITAL | مستشفى |
| RESEARCH_CENTER | مركز بحوث |
| MINISTRY | وزارة |
| PHARMA_COMPANY | شركة أدوية |
## Document Types

| Code | Name (AR) |
|------|-----------|
| PROTOCOL | بروتوكول البحث |
| CONSENT_FORM | نموذج موافقة |
| QUESTIONNAIRE | استبيان |
| CV | سيرة ذاتية |
| APPROVAL_LETTER | خطاب موافقة |
| STUDY_REPORT | تقرير دراسة |
| SAFETY_REPORT | تقرير سلامة |
---

## Workflow States (Initial)
- DRAFT → SUBMITTED → UNDER_REVIEW → (APPROVED | REJECTED)

## Application Types
- NEW: طلب جديد
- AMENDMENT: تعديل
- RENEWAL: تجديد
- CLOSURE: إغلاق

## Gender
- MALE: ذكر
- FEMALE: أنثى

---
*Last updated: 2026-06-03*
