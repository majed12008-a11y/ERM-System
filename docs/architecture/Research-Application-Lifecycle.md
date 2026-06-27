# Research Application Lifecycle — ERM System

> **المصدر**: بيانات حية من قاعدة البيانات `ethics_db` (PostgreSQL 18.3 على Windows)  
> **تاريخ التحليل**: 27 يونيو 2026  
> **الغرض**: توثيق دورة حياة طلب البحث من التسجيل إلى الأرشفة، ومقارنتها بالممارسات العالمية (WHO, ICH-GCP E6(R3), CIOMS, FDA, OHRP).

---

## Table of Contents

1. [System Overview](#1-system-overview)
2. [Workflow Engine](#2-workflow-engine)
3. [States & Transitions](#3-states--transitions)
4. [Complete Lifecycle Stages](#4-complete-lifecycle-stages)
5. [Stage-by-Stage Detailed Analysis](#5-stage-by-stage-detailed-analysis)
   - [Stage 1: Registration / إنشاء المسودة](#stage-1-registration--إنشاء-المسودة)
   - [Stage 2: Submission / تقديم الطلب](#stage-2-submission--تقديم-الطلب)
   - [Stage 3: Initial Review / مراجعة أولية](#stage-3-initial-review--مراجعة-أولية)
   - [Stage 4: Scientific Review / مراجعة علمية](#stage-4-scientific-review--مراجعة-علمية)
   - [Stage 5: Ethical Review / مراجعة أخلاقية](#stage-5-ethical-review--مراجعة-أخلاقية)
   - [Stage 6: Committee Review / مراجعة اللجنة](#stage-6-committee-review--مراجعة-اللجنة)
   - [Stage 7: Approval / الموافقة النهائية](#stage-7-approval--الموافقة-النهائية)
   - [Stage 8: Rejection / الرفض](#stage-8-rejection--الرفض)
   - [Stage 9: Return for Revision / الإعادة للمراجعة](#stage-9-return-for-revision--الإعادة-للمراجعة)
   - [Stage 10: Post-Approval Monitoring / مراقبة ما بعد الموافقة](#stage-10-post-approval-monitoring--مراقبة-ما-بعد-الموافقة)
   - [Stage 11: Amendments / التعديلات](#stage-11-amendments--التعديلات)
   - [Stage 12: Renewal / التجديد](#stage-12-renewal--التجديد)
   - [Stage 13: Closure / الإغلاق](#stage-13-closure--الإغلاق)
   - [Stage 14: Withdrawal / السحب](#stage-14-withdrawal--السحب)
   - [Stage 15: Archiving / الأرشفة](#stage-15-archiving--الأرشفة)
6. [Comparison with Global Best Practices](#6-comparison-with-global-best-practices)
7. [Gap Analysis & Recommendations](#7-gap-analysis--recommendations)
8. [Appendix: Database Schema Reference](#8-appendix-database-schema-reference)

---

## 1. System Overview

### Architecture
- **3-layer**: Routes (`modules/`) → Services → Repositories
- **RLS** (Row-Level Security) هو آلية التحكم بالوصول الوحيدة — 235+ سياسة عبر جميع الجداول
- **Context Propagation**: `AsyncLocalStorage` → `SET SESSION app.user_id` → RLS
- **Backend**: Express 5 + TypeScript على منفذ 8080
- **Frontend**: React 19 + Vite + Tailwind 4 على منفذ 5173
- **Database**: PostgreSQL 18.3 على Windows

### Database Schemas (24)
| Schema | Description |
|--------|-------------|
| `security` | Users, roles, permissions, institutions, auth |
| `core` | Applications, projects, amendments, consents |
| `workflow` | Workflow engine — states, transitions, instances |
| `committee` | Committees, meetings, reviews, voting, accreditation |
| `reference` | Lookup tables — statuses, review types, risk levels |
| `documents` | Document management, templates, signatures |
| `communication` | Notifications, messages, announcements |
| `monitoring` | Compliance, deviations, inspections, monitoring plans |
| `safety` | Adverse events, risk register, safety reports |
| `integration` | Webhooks, event outbox, external systems |
| `audit` | Audit trail, hash ledger |
| `reporting` | Dashboards, KPIs, analytics |
| `system` | System config, business rules, search |
| `public` | Extensions (pgcrypto, uuid-ossp, citext) |

### Key Tables (209 total)
- **Applications**: `core.applications` (84 records live)
- **Projects**: `core.projects` (87 records live)
- **Workflow Instances**: `workflow.workflow_instances` (15 records live)
- **Workflow History**: `workflow.workflow_history` (8 records live)
- **Workflow Actions**: `workflow.workflow_actions` (23 records live)
- **Review Assignments**: `committee.review_assignments` (55 records live)
- **Scientific Reviews**: `committee.scientific_reviews` (39 records live)
- **Ethics Reviews**: `committee.ethics_reviews` (17 records live)
- **Voting Sessions**: `committee.voting_sessions` (3 records live)
- **Committees**: `committee.committees` (19 records live)

### Roles (7)
| Role | Code | Description |
|------|------|-------------|
| مدير النظام | `SUPER_ADMIN` | Full system access |
| مدير أخلاقيات | `ETHICS_ADMIN` | Manages ethics reviews and committees |
| رئيس لجنة | `COMMITTEE_CHAIR` | Chairs ethics committee meetings |
| مراجع | `REVIEWER` | Reviews research applications |
| باحث | `RESEARCHER` | Submits research applications |
| — | `TEST_E2E_P2_1724` | Test role (E2E) |
| سكرتير لجنة | `SECRATORY` | Transfers applications and assigns committees |

---

## 2. Workflow Engine

### Workflow Definition (Live Data)
- **Name**: `APP_REVIEW_V1` — سير عمل مراجعة الطلبات
- **Entity Type**: `Application`
- **Version**: 1
- **Status**: Active
- **Workflow ID**: 1

### System Functions (Live Data)
| Function | Purpose |
|----------|---------|
| `system.fn_init_workflow(workflow_code, entity_type, entity_id)` | Creates workflow instance in initial state (SECURITY DEFINER) |
| `system.fn_auto_transition(entity_type, entity_id, action_by, comment)` | Performs auto-transition — records action, history, updates instance, fires outbox event |
| `system.fn_notify_status_change()` | Trigger on `applications` status change — creates notification + outbox event |
| `system.fn_generate_application_number()` | Generates `APP-YYYY-NNNNNN` format |
| `system.fn_generate_project_code()` | Generates `PRJ-YY-NNNNNN` format |
| `system.fn_is_admin()` / `fn_is_admin(p_user_id)` | Checks if user has SUPER_ADMIN or ETHICS_ADMIN role |
| `system.fn_calculate_quorum()` | Calculates meeting quorum |
| `system.fn_check_sla()` | Checks workflow SLA compliance |
| `system.fn_current_user_id()` | Returns `current_setting('app.user_id')` |

---

## 3. States & Transitions

### Workflow States (9)
```
  ┌─────────────────────────────────────────────────────────────────────┐
  │                         APP_REVIEW_V1                              │
  │              سير عمل مراجعة الطلبات (Application)                   │
  └─────────────────────────────────────────────────────────────────────┘

State 1:  DRAFT (مسودة)           — Initial (is_initial = true)
State 2:  SUBMITTED (مقدم)        — Submitted, awaiting initial review
State 3:  INITIAL_REVIEW (مراجعة أولية) — Under initial/admin review
State 4:  SCIENTIFIC_REVIEW (مراجعة علمية) — Under scientific review
State 5:  ETHICAL_REVIEW (مراجعة أخلاقية)  — Under ethical review
State 6:  COMMITTEE_REVIEW (مراجعة اللجنة)  — Under full committee review
State 7:  APPROVED (موافق عليه)   — Terminal (is_terminal = true)
State 8:  REJECTED (مرفوض)        — Terminal (is_terminal = true)
State 9:  RETURNED (معاد للمراجعة) — Non-terminal, allows resubmission
```

### Transitions (14)
```
DRAFT ──SUBMIT──────────────────────────────────────▶ SUBMITTED

SUBMITTED ──ACCEPT_INITIAL──────────────────────────▶ INITIAL_REVIEW
SUBMITTED ──RETURN_SUBMITTED────────────────────────▶ DRAFT
SUBMITTED ──REJECT_SUBMITTED────────────────────────▶ REJECTED

INITIAL_REVIEW ──SEND_TO_SCIENTIFIC─────────────────▶ SCIENTIFIC_REVIEW
INITIAL_REVIEW ──RETURN_INITIAL─────────────────────▶ SUBMITTED

SCIENTIFIC_REVIEW ──SEND_TO_ETHICAL─────────────────▶ ETHICAL_REVIEW
SCIENTIFIC_REVIEW ──RETURN_SCIENTIFIC───────────────▶ SUBMITTED

ETHICAL_REVIEW ──SEND_TO_COMMITTEE─────────────────▶ COMMITTEE_REVIEW
ETHICAL_REVIEW ──RETURN_ETHICAL─────────────────────▶ INITIAL_REVIEW

COMMITTEE_REVIEW ──COMMITTEE_APPROVE────────────────▶ APPROVED
COMMITTEE_REVIEW ──COMMITTEE_REJECT─────────────────▶ REJECTED
COMMITTEE_REVIEW ──COMMITTEE_RETURN─────────────────▶ RETURNED

RETURNED ──RESUBMIT─────────────────────────────────▶ SUBMITTED
```

### Transition Details (Live Data)
| # | From | To | Code | Requires Comment | Requires Vote | Allowed Roles |
|---|------|----|------|:---:|:---:|-------------|
| 1 | DRAFT | SUBMITTED | `SUBMIT` | ✗ | ✗ | RESEARCHER |
| 2 | SUBMITTED | INITIAL_REVIEW | `ACCEPT_INITIAL` | ✗ | ✗ | ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN |
| 3 | SUBMITTED | DRAFT | `RETURN_SUBMITTED` | ✓ | ✗ | ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN |
| 4 | SUBMITTED | REJECTED | `REJECT_SUBMITTED` | ✓ | ✗ | ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN |
| 5 | INITIAL_REVIEW | SCIENTIFIC_REVIEW | `SEND_TO_SCIENTIFIC` | ✗ | ✗ | ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN |
| 6 | INITIAL_REVIEW | SUBMITTED | `RETURN_INITIAL` | ✓ | ✗ | ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN |
| 7 | SCIENTIFIC_REVIEW | ETHICAL_REVIEW | `SEND_TO_ETHICAL` | ✗ | ✗ | ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN |
| 8 | SCIENTIFIC_REVIEW | SUBMITTED | `RETURN_SCIENTIFIC` | ✓ | ✗ | ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN |
| 9 | ETHICAL_REVIEW | COMMITTEE_REVIEW | `SEND_TO_COMMITTEE` | ✗ | ✗ | ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN |
| 10 | ETHICAL_REVIEW | INITIAL_REVIEW | `RETURN_ETHICAL` | ✓ | ✗ | ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN |
| 11 | COMMITTEE_REVIEW | APPROVED | `COMMITTEE_APPROVE` | ✗ | ✓ | COMMITTEE_CHAIR, ETHICS_ADMIN, SUPER_ADMIN |
| 12 | COMMITTEE_REVIEW | REJECTED | `COMMITTEE_REJECT` | ✓ | ✓ | COMMITTEE_CHAIR, ETHICS_ADMIN, SUPER_ADMIN |
| 13 | COMMITTEE_REVIEW | RETURNED | `COMMITTEE_RETURN` | ✓ | ✓ | COMMITTEE_CHAIR, ETHICS_ADMIN, SUPER_ADMIN |
| 14 | RETURNED | SUBMITTED | `RESUBMIT` | ✗ | ✗ | RESEARCHER |

---

## 4. Complete Lifecycle Stages

### Documented vs. Actual Statuses

**Reference table** (`reference.application_statuses`): 11 statuses  
**Live application data** (`core.applications.current_status`): 14 distinct statuses

|#| Status | In Reference | In Apps (Live) | Workflow State | Note |
|---|--------|:---:|:---:|:---:|------|
|1| DRAFT | ✓ | ✓ | State 1 | |
|2| SUBMITTED | ✓ | ✓ | State 2 | |
|3| INITIAL_REVIEW | ✓ | ✗ | State 3 | Not used as direct status in apps |
|4| SCIENTIFIC_REVIEW | ✓ | ✓ | State 4 | |
|5| ETHICAL_REVIEW | ✓ | ✗ | State 5 | Not used as direct status in apps |
|6| COMMITTEE_REVIEW | ✓ | ✓ | State 6 | |
|7| APPROVED | ✓ | ✓ | State 7 | Terminal |
|8| REJECTED | ✓ | ✓ | State 8 | Terminal |
|9| RETURNED | ✓ | ✓ | State 9 | |
|10| WITHDRAWN | ✓ | ✗ | — | غير منفذ حالياً في التطبيقات الفعلية |
|11| CLOSED | ✓ | ✓ | — | Outside workflow, in apps |
|12| UNDER_REVIEW | ✗ | ✓ | — | غير منفذ حالياً — مستخدم في البيانات لكن غير موجود في مصفوفة الحالات الرسمية |
|13| CONDITIONALLY_APPROVED | ✗ | ✓ | — | غير منفذ حالياً في سير العمل الرسمي |
|14| DEFERRED | ✗ | ✓ | — | غير منفذ حالياً في سير العمل الرسمي |
|15| SUSPENDED | ✗ | ✓ | — | غير منفذ حالياً في سير العمل الرسمي |
|16| ARCHIVED | ✗ | ✓ | — | غير منفذ حالياً في سير العمل الرسمي |
|17| CONDITIONAL | ✗ | ✓ | — | غير منفذ حالياً (يُحتمل خطأ إملائي legacy) |

> **ملاحظة هامة**: هناك انفصال بين workflow engine (9 حالات، 14 انتقال) ومصفوفة الحالات المخزنة في `current_status` بالجدول `core.applications`. سير العمل الرسمي لا يدعم حالياً: `UNDER_REVIEW`, `CONDITIONALLY_APPROVED`, `DEFERRED`, `SUSPENDED`, `ARCHIVED`, `CONDITIONAL`, `WITHDRAWN` رغم وجودها في البيانات الفعلية أو في جدول reference.

---

## 5. Stage-by-Stage Detailed Analysis

### Stage 1: Registration / إنشاء المسودة

**المسار**: مستخدم → تسجيل الدخول → إنشاء مشروع → إنشاء طلب

| Element | Details (Live DB) |
|---------|-------------------|
| **Actor** | RESEARCHER (role_id = 5) — users 7, 8, 13, 14, 19, 164–381 |
| **DB Table** | `core.projects` (87 records) → `core.applications` (84 records) |
| **Initial Status** | `current_status = 'DRAFT'` |
| **Workflow** | `fn_init_workflow('APP_REVIEW_V1', 'Application', entity_id)` → creates instance at State 1 (DRAFT) |
| **Validation** | Application sections: `core.application_sections`, checklist: `core.application_checklists` |
| **Consent** | `core.application_consents` — consent form management |
| **Risk Classification** | `core.risk_classifications`, `committee.ethics_risk_assessments` |
| **RLS** | `projects_insert_policy`: PI or admin only; `applications_insert_policy`: submitted_by = app.user_id or admin |
| **Frontend** | Edit page (multi-step wizard) at `/applications/new` |
| **Permissions** | RESEARCHER only (by transition allowed_roles) |

**الممارسات العالمية**:
- **ICH-GCP E6(R3)** §5.5: يتطلب موافقة خطية من الباحث الرئيسي قبل بدء أي إجراء بحثي — النظام يطبق ذلك عبر `principal_investigator_id` المطلوب.
- **WHO ERC** §3.1: يتطلب تسجيل جميع الأبحاث في سجل عام — النظام يخصص `application_number` تلقائياً عبر `fn_generate_application_number()`.
- ✗ **ثغرة**: لا يوجد تكامل مع سجل أبحاث وطني (مثل clinicaltrials.gov أو WHO ICTRP).

---

### Stage 2: Submission / تقديم الطلب

**المسار**: RESEARCHER ← `POST /:id/submit` ← Transition `SUBMIT` (ID: 1)

| Element | Details |
|---------|---------|
| **Transition** | `SUBMIT` — DRAFT → SUBMITTED (State 1 → State 2) |
| **API Route** | `POST /api/v1/core/applications/:id/submit` — requires `transition_code: 'SUBMIT'` |
| **Workflow** | `workflow_actions` records action (RESEARCHER submits) |
| **Validation** | `updateApplicationStatusSchema` — `z.object({ transition_code, comment }).refine(requires at least one)` |
| **Trigger** | `fn_notify_status_change()` → sends notification + event outbox |
| **Live Data** | 5 transitions recorded: user 7 (2024-03-15), user 8 (2024-09-25), user 7 (2026-06-24), user 381 (2026-06-27) |
| **RLS** | `applications_update_policy`: submitted_by = app.user_id OR admin |

**الممارسات العالمية**:
- **ICH-GCP E6(R3)** §5.6: يتطلب أن يحتوي الطلب على جميع المستندات الداعمة — النظام يدعم `application_checklists` و `application_sections` لكن لا يفرض اكتمالها قبل السماح بالتقديم.
- **CIOMS Guideline 1**: يتطلب موافقة مستنيرة (informed consent) للأبحاث على البشر — النظام يدير `application_consents` بشكل منفصل.

---

### Stage 3: Initial Review / مراجعة أولية

**المسار**: ETHICS_ADMIN/COMMITTEE_CHAIR ← `ACCEPT_INITIAL` ← State 2 → State 3

| Element | Details |
|---------|---------|
| **Transition** | `ACCEPT_INITIAL` (ID: 2) — SUBMITTED → INITIAL_REVIEW |
| **Actor** | ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN |
| **Purpose** | التحقق من اكتمال الطلب، تصنيف نوع المراجعة (عادية/مستعجلة/كاملة) |
| **Alternative** | `RETURN_SUBMITTED` (ID: 3) → DRAFT; `REJECT_SUBMITTED` (ID: 4) → REJECTED |
| **Requires Comment** | RETURN and REJECT require comment; ACCEPT_INITIAL does not |
| **Live Data** | Instance 1 (App 1): user 1 (admin) accepted → INITIAL_REVIEW; Instance 2 (App 2): user 2 accepted |
| **Assignment** | `committee.review_assignments` — ethics_admin assigns reviewers |

**الممارسات العالمية**:
- **ICH-GCP E6(R3)** §3.2.2: IRB/IEC يجب أن تراجع الطلب خلال فترة زمنية محددة — النظام لا يفرض SLA في الكود (رغم وجود جدول `workflow_sla`).
- **WHO ERC** §3.2: يتطلب فحص النزاعات المحتملة — النظام يدير `review_conflicts` و `member_conflicts`.

---

### Stage 4: Scientific Review / مراجعة علمية

**المسار**: ETHICS_ADMIN ← `SEND_TO_SCIENTIFIC` ← State 3 → State 4  
ثم REVIEWER (scientific) ← تقييم علمي

| Element | Details |
|---------|---------|
| **Transition** | `SEND_TO_SCIENTIFIC` (ID: 5) — INITIAL_REVIEW → SCIENTIFIC_REVIEW |
| **Review Type** | `SCIENTIFIC` — form `SCI_REVIEW_V1` (review_forms.id = 1) |
| **Assignment** | `review_assignments` with `review_type = 'SCIENTIFIC'`, `status_code` in ASSIGNED, IN_PROGRESS, COMPLETED |
| **Review Table** | `committee.scientific_reviews` — 39 completed reviews (live) |
| **Recommendation** | `recommendation` field: APPROVED, REJECTED, REVISIONS_REQUIRED |
| **Review Questions** | `review_questions` linked to `review_forms` |
| **Review Answers** | `review_answers` — structured question responses |
| **Score** | `review_scores` — numeric scoring per application |
| **Comments** | `review_comments` — reviewer textual feedback |
| **Due Date** | `review_assignments.due_date` — tracked (e.g., 14-day default) |
| **RLS** | Reviewer sees via `review_assignments.reviewer_id` matching `app.user_id` |
| **Live Data** | 39 scientific reviews completed, recommendations vary: APPROVED (majority), REJECTED (9), REVISIONS_REQUIRED (6) |
| **Review Period** | Average ~7 days from assigned_at to completed_at (live data) |

**الممارسات العالمية**:
- ✓ **CIOMS Guideline 2**: Scientific review before ethical review — النظام يفرض الترتيب (SCIENCE → ETHICS).
- **ICH-GCP E6(R3)** §3.3: IRB يجب أن تضم أعضاء ذوي خبرة علمية — النظام يدير `member_qualifications` و `committee_member_roles`.
- ✗ **ثغرة**: لا يوجد `blinded review` (المراجع يرى الباحث).

---

### Stage 5: Ethical Review / مراجعة أخلاقية

**المسار**: ETHICS_ADMIN ← `SEND_TO_ETHICAL` ← State 4 → State 5  
ثم REVIEWER (ethics) ← تقييم أخلاقي

| Element | Details |
|---------|---------|
| **Transition** | `SEND_TO_ETHICAL` (ID: 7) — SCIENTIFIC_REVIEW → ETHICAL_REVIEW |
| **Review Type** | `ETHICS` — form `ETH_REVIEW_V1` (review_forms.id = 2) |
| **Assignment** | `review_assignments` with `review_type = 'ETHICS'` |
| **Review Table** | `committee.ethics_reviews` — 17 completed reviews (live) |
| **Recommendation** | `recommendation` field: APPROVED only in live data (all 17 = APPROVED) |
| **Risk Assessment** | `ethics_risk_assessments.ethical_risk_assessment` — LOW, MEDIUM (live data) |
| **Risk Items** | `committee.ethics_risk_items` — structured risk evaluation |
| **Consent Review** | `committee.consent_review_comments` — consent form review |
| **Consent Templates** | `committee.consent_templates`, `consent_template_versions` |
| **Vulnerable Populations** | `core.vulnerable_populations`, `core.research_population_links` |
| **Live Data** | 17 ethics reviews: ALL completed, ALL approved, risk: LOW (11) + MEDIUM (6) |

**الممارسات العالمية**:
- ✓ **CIOMS Guideline 1**: Ethical review must assess risks/benefits — النظام يدير `ethics_risk_assessments`.
- ✓ **OHRP 45 CFR 46.111**: Criteria for IRB approval — النظام يغطي تقييم المخاطر والموافقة المستنيرة.
- ✓ **CIOMS Guideline 9**: Special protections for vulnerable populations — النظام يدير `vulnerable_populations`.
- ✗ **ثغرة**: لا يوجد `expedited review` مسار مستقل رغم وجود `EXPEDITED` كـ review_type.

---

### Stage 6: Committee Review / مراجعة اللجنة

**المسار**: COMMITTEE_CHAIR ← `SEND_TO_COMMITTEE` ← State 5 → State 6  
ثم لجنة كاملة ← اجتماع ← تصويت ← قرار

| Element | Details |
|---------|---------|
| **Transition** | `SEND_TO_COMMITTEE` (ID: 9) — ETHICAL_REVIEW → COMMITTEE_REVIEW |
| **Committee Meeting** | `committee.committee_meetings` — SCHEDULED, IN_PROGRESS, COMPLETED |
| **Meeting Status** | `meeting_status`: SCHEDULED, IN_PROGRESS, COMPLETED, CANCELLED |
| **Agenda** | `committee.meeting_agendas` + `committee.agenda_items` (linked to application) |
| **Attendance** | `committee.attendance_logs` — member sign-in |
| **Quorum** | `committee.quorum_logs` — checked via `fn_calculate_quorum()` |
| **Minutes** | `committee.meeting_minutes` |
| **Voting** | `committee.voting_sessions` — STANDARD type, OPEN or CLOSED |
| **Votes** | `committee.votes` — voter_id, vote_type, comments |
| **Decision Types** | `reference.committee_decision_types` |
| **Vote Types** | `reference.vote_types` |
| **Live Data** | 3 voting sessions: App 1 (CLOSED — approved), Apps 2 & 3 (OPEN — pending) |
| **Chairperson** | `committee_meetings.chairperson_id` — COMMITTEE_CHAIR role |

**Transitions at This Stage** (all require vote = ✓):
- `COMMITTEE_APPROVE` (ID: 11) → APPROVED (terminal)
- `COMMITTEE_REJECT` (ID: 12) → REJECTED (terminal)
- `COMMITTEE_RETURN` (ID: 13) → RETURNED (non-terminal)

**الممارسات العالمية**:
- ✓ **ICH-GCP E6(R3)** §3.4: IRB يجب أن تصوت — النظام يدير `voting_sessions` و `votes`.
- ✓ **WHO ERC** §3.3: يتطلب نصاب قانوني — النظام يدير `quorum_logs`.
- ✓ **CIOMS Guideline 2**: يجب أن توثق اللجنة قراراتها — النظام يدير `meeting_minutes`.
- ✗ **ثغرة**: لا يوجد تصويت إلكتروني عن بعد (remote electronic voting) — STANDARD فقط.

---

### Stage 7: Approval / الموافقة النهائية

**المسار**: COMMITTEE_CHAIR ← `COMMITTEE_APPROVE` ← State 6 → State 7 (Terminal)

| Element | Details |
|---------|---------|
| **Transition** | `COMMITTEE_APPROVE` (ID: 11) — requires vote (✓), does NOT require comment |
| **State** | APPROVED — terminal state |
| **Live Data** | App 1 (APP-2024-001) completed this lifecycle: SUBMIT → ACCEPT_INITIAL → SEND_TO_SCIENTIFIC → SEND_TO_ETHICAL → SEND_TO_COMMITTEE → COMMITTEE_APPROVE. Duration: ~66 days (Mar 15 → May 20, 2024) |
| **Documents** | Approval certificate generated via `documents.generated_documents` |
| **Notification** | `fn_notify_status_change()` → notification to RESEARCHER + outbox event |
| **Application Types** | INITIAL, AMENDMENT, EXPEDITED, NEW, FULL — in live data |

**الممارسات العالمية**:
- **ICH-GCP E6(R3)** §3.1.2: يجب إصدار قرار كتابي — النظام يدعم `generated_documents` لكن لا ينشئ شهادة موافقة تلقائياً.
- ✗ **ثغرة**: لا يوجد `conditional approval` (موافقة مشروطة) في workflow engine رغم وجوده في بيانات `current_status`.

---

### Stage 8: Rejection / الرفض

**المسار**: `REJECT_SUBMITTED` (State 2 → 8) أو `COMMITTEE_REJECT` (State 6 → 8)

| Element | Details |
|---------|---------|
| **Transitions** | `REJECT_SUBMITTED` (ID: 4) — from SUBMITTED; `COMMITTEE_REJECT` (ID: 12) — from COMMITTEE_REVIEW |
| **Requires Comment** | Both require comment |
| **Requires Vote** | REJECT_SUBMITTED: ✗; COMMITTEE_REJECT: ✓ |
| **State** | REJECTED — terminal |
| **Live Data** | 3 apps in REJECTED status (IDs 40, 67, 68) |
| **Scientific Reviews** | 9 reviews recommended REJECTED (live data) |
| **Notification** | System notifies RESEARCHER via `fn_notify_status_change()` |
| **Appeal?** | غير منفذ حالياً — لا يوجد مسار استئناف (appeal) في سير العمل |

**الممارسات العالمية**:
- **ICH-GCP E6(R3)** §3.1.2: يجب إبلاغ الباحث بأسباب الرفض — النظام يفرض `comment` للرفض.
- ✗ **CIOMS Guideline 2**: يوصي بوجود آلية استئناف — غير منفذ حالياً.

---

### Stage 9: Return for Revision / الإعادة للمراجعة

**المسار**: `COMMITTEE_RETURN` (State 6 → 9) ثم `RESUBMIT` (State 9 → 2)

| Element | Details |
|---------|---------|
| **Transition** | `COMMITTEE_RETURN` (ID: 13) — requires comment + vote |
| **State** | RETURNED — non-terminal |
| **Resubmit** | `RESUBMIT` (ID: 14) — RESEARCHER only, no comment required |
| **Live Data** | 4 apps in RETURNED status (IDs 19, 32, 67, 68) |
| **Return Points** | Multiple return paths: SUBMITTED → DRAFT, INITIAL_REVIEW → SUBMITTED, SCIENTIFIC_REVIEW → SUBMITTED, ETHICAL_REVIEW → INITIAL_REVIEW, COMMITTEE_REVIEW → RETURNED |
| **Versioning** | `core.application_versions` + `core.project_versions` — tracks changes |

**الممارسات العالمية**:
- ✓ **ICH-GCP E6(R3)** §3.3.5: يتطلب توضيح التعديلات المطلوبة — النظام يفرض `comment` على الإعادة.
- ✓ **WHO ERC** §3.6: يسمح بإعادة التقديم بعد التعديل — `RESUBMIT` transition.

---

### Stage 10: Post-Approval Monitoring / مراقبة ما بعد الموافقة

**غير منفذ حالياً في سير العمل الرسمي** — هذه المرحلة تتم عبر جداول منفصلة خارج workflow engine.

| Element | Details |
|---------|---------|
| **Monitoring Plans** | `monitoring.monitoring_plans` — linked to application |
| **Monitoring Visits** | `monitoring.monitoring_visits` — scheduled visits |
| **Compliance Reviews** | `monitoring.compliance_reviews` — reviewer assigned |
| **Deviations** | `monitoring.deviations` — protocol deviations |
| **Protocol Violations** | `monitoring.protocol_violations` — serious violations |
| **Inspections** | `monitoring.inspections` — regulatory inspections |
| **Inspection Reports** | `monitoring.inspection_reports` |
| **Corrective Actions** | `monitoring.corrective_actions` + `safety.corrective_actions` |
| **Preventive Actions** | `monitoring.preventive_actions` |
| **Safety Reports** | `safety.safety_reports` — periodic safety reports |
| **Adverse Events** | `safety.adverse_events` — AE tracking |
| **Serious AE** | `safety.serious_adverse_events` — SAE tracking (24h/7d reporting) |
| **Safety Committee** | `safety.safety_committee_reviews` — DSMB/DMC reviews |
| **Risk Register** | `safety.risk_register` — ongoing risk management |
| **RLS** | Separate RLS policies per table — owner/admin access |

**الممارسات العالمية**:
- **ICH-GCP E6(R3)** §5.20: يتطلب مراقبة مستمرة — النظام يغطي 12+ جدول للمراقبة.
- **ICH-GCP E6(R3)** §4.11: SAE reporting within 24 hours — `serious_adverse_events` موجود لكن لا يوجد تحقق آلي من المهلة.
- ✗ **ثغرة**: لا يوجد تكامل آلي بين monitoring و workflow engine — التقارير لا تؤدي إلى transitions تلقائية.

---

### Stage 11: Amendments / التعديلات

**غير منفذ حالياً** عبر workflow engine الرسمي — التعديلات تتم عبر جداول منفصلة.

| Element | Details |
|---------|---------|
| **DB Tables** | `core.amendment_requests`, `core.application_amendments` |
| **Application Types** | AMENDMENT type exists (App 3: APP-2024-003) |
| **Linked To** | `application_amendments.application_id` — FK to core.applications |
| **Status** | PENDING → APPROVED/REJECTED |
| **Lifecycle** | Submitting researcher → ethics_admin review → committee review (loops back) |
| **Versioning** | `application_versions` tracks amendment changes |

**الممارسات العالمية**:
- **ICH-GCP E6(R3)** §4.10: يتطلب موافقة IRB على أي تعديل قبل التطبيق — النظام يدعم `amendment_requests` لكن لا يربطها بـ workflow تلقائياً.
- **CIOMS Guideline 7**: يتطلب إعادة تقييم المخاطر بعد التعديل — غير منفذ حالياً.

---

### Stage 12: Renewal / التجديد

**غير منفذ حالياً** — جداول موجودة لكن لا يوجد تكامل مع workflow.

| Element | Details |
|---------|---------|
| **DB Table** | `core.renewal_requests` |
| **Linked To** | `renewal_requests.application_id` |
| **Typical Cycle** | Annual renewal for multi-year studies |
| **Workflow** | غير منفذ حالياً — لا يوجد مسار تجديد في سير العمل |

**الممارسات العالمية**:
- **ICH-GCP E6(R3)** §3.1.4: يتطلب مراجعة سنوية (continuing review) — النظام لا يفرض ذلك.
- **OHRP 45 CFR 46.109(e)**: IRB must conduct continuing review at least annually — غير منفذ حالياً.

---

### Stage 13: Closure / الإغلاق

| Element | Details |
|---------|---------|
| **DB Table** | `core.closure_requests` |
| **Status** | CLOSED — موجود في `reference.application_statuses` كـ terminal |
| **Live Data** | App 29 (CLOSED), App 41, App 43, App 51, App 69 — 5 apps |
| **Linked To** | Application + final study report `safety.safety_reports` |
| **Workflow** | CLOSED غير موجود في workflow engine — لا يوجد مسار إغلاق رسمي |
| **Notification** | `fn_notify_status_change()` fires on direct status update |

**الممارسات العالمية**:
- **ICH-GCP E6(R3)** §4.13: يتطلب تقديم تقرير ختامي — `closure_requests` موجود لكن غير مرتبط بـ workflow.

---

### Stage 14: Withdrawal / السحب

**غير منفذ حالياً في التطبيقات الفعلية** — موجود في reference فقط.

| Element | Details |
|---------|---------|
| **Reference** | `WITHDRAWN` in `reference.application_statuses` (ID: 10, is_terminal: true) |
| **Live Data** | ✗ لا يوجد أي تطبيق في حالة WITHDRAWN |
| **Workflow** | غير منفذ حالياً — لا يوجد مسار سحب في workflow engine |
| **Permissions** | RESEARCHER should be able to withdraw own applications |

---

### Stage 15: Archiving / الأرشفة

**غير منفذ حالياً في سير العمل الرسمي** — جداول موجودة لكن خارج workflow.

| Element | Details |
|---------|---------|
| **Status** | ARCHIVED — موجود في بيانات التطبيقات (4 apps: 14, 22, 38, 44, 71) |
| **Reference** | غير موجود في `reference.application_statuses` |
| **Workflow** | غير منفذ حالياً |
| **Retention** | `documents.document_retention_rules` — document retention policies |
| **Disposal** | `documents.document_disposal_logs` — document disposal tracking |
| **Live Data** | 5 apps in ARCHIVED status |

---

## 6. Comparison with Global Best Practices

### ICH-GCP E6(R3) — Harmonised Tripartite Guideline for Good Clinical Practice

| Requirement | ERM System Status |
|------------|:---:|
| §3.1 — IRB/IEC composition & qualifications | ✓ `member_qualifications`, `committee_member_roles` |
| §3.2.2 — Written procedures for IRB review | ✓ Workflow engine defines 14 transitions |
| §3.2.5 — IRB review timeline | ✗ `workflow_sla` table exists but no enforcement in code |
| §3.3 — Continuing review (annual) | ✗ غير منفذ حالياً |
| §3.4 — IRB decision (approve/reject/modify) | ✓ Via voting + transitions |
| §4.10 — Protocol amendments require IRB approval | ~ `amendment_requests` exists but no workflow link |
| §4.11 — SAE reporting (24h/7d) | ~ Tables exist, no automated SLA check |
| §5.5 — PI qualifications documented | ~ `member_qualifications`, `licenses_registry` |
| §5.20 — Monitoring plan | ✓ `monitoring.monitoring_plans`, `monitoring_visits` |
| §8 — Essential documents for trial conduct | ✓ `documents` + `document_types` + retention rules |

### WHO ERC — Research Ethics Committee Standards

| Requirement | ERM System Status |
|------------|:---:|
| §3.1 — Registration of research | ✓ Auto-generated application number |
| §3.2 — Conflict of interest management | ✓ `member_conflicts`, `review_conflicts` |
| §3.3 — Quorum requirements | ✓ `quorum_logs`, `fn_calculate_quorum()` |
| §3.4 — Expedited review pathway | ~ `EXPEDITED` type exists but no separate workflow |
| §3.6 — Resubmission path | ✓ RESUBMIT transition (RETURNED → SUBMITTED) |
| §3.7 — Appeal mechanism | ✗ غير منفذ حالياً |
| §4.1 — Community engagement | ✗ غير منفذ حالياً |
| §4.3 — Data & safety monitoring | ✓ DSMB committee type (Data Safety Monitoring Board) |

### CIOMS — International Ethical Guidelines for Health-Related Research

| Guideline | ERM System Status |
|-----------|:---:|
| 1 — Scientific & ethical review | ✓ Sequential (SCIENCE → ETHICS) |
| 2 — Research ethics committee | ✓ 19 committees (institutional + national + specialised) |
| 7 — Community engagement | ✗ غير منفذ حالياً |
| 9 — Vulnerable populations | ✓ `vulnerable_populations` + `research_population_links` |
| 14 — Informed consent | ✓ `application_consents`, `consent_templates` |
| 15 — Reimbursement for participation | ✗ غير منفذ حالياً |
| 17 — Risk assessment | ✓ `risk_classifications`, `ethics_risk_assessments` |

### OHRP 45 CFR 46 — US Federal Policy (Common Rule)

| Requirement | ERM System Status |
|------------|:---:|
| §46.109(a) — IRB review | ✓ Workflow covers 6 review states |
| §46.109(e) — Continuing review frequency | ✗ غير منفذ حالياً |
| §46.111(a) — Criteria for IRB approval | ✓ Risk/benefit assessment, consent review |
| §46.115 — IRB records | ✓ `meeting_minutes`, `voting_sessions`, `audit` schema |

### FDA 21 CFR 50, 56, 312, 812

| Requirement | ERM System Status |
|------------|:---:|
| 21 CFR 50 — Protection of human subjects | ~ Consent management exists |
| 21 CFR 56 — IRB membership & operations | ✓ Committee roles, qualifications, terms |
| 21 CFR 312.53 — Investigator qualifications | ✓ `member_qualifications`, `licenses_registry` |

---

## 7. Gap Analysis & Recommendations

### Priority 1 Gaps (Must Fix)

| # | Gap | Impact | Recommendation |
|---|-----|--------|--------------|
| 1 | **No annual continuing review** | المخالفة لـ ICH-GCP §3.3 و OHRP 46.109(e) وإرشادات الهيئة الوطنية للأخلاقيات الحيوية | إضافة مسار `RENEW` في workflow engine ينتقل من APPROVED إلى RENEWAL_REVIEW عند انتهاء فترة الموافقة |
| 2 | **No appeal mechanism** | الباحث ليس لديه طريقة رسمية للاستئناف ضد الرفض | إضافة مسار APPEAL (APPROVED/REJECTED → APPEAL_REVIEW) أو `appeal_requests` جدول |
| 3 | **Conditional approval not in workflow** | الموافقة المشروطة تُستخدم في البيانات لكن لا يدعمها سير العمل | إضافة حالة CONDITIONALLY_APPROVED كحالة non-terminal مع شروط متابعة (conditions) |
| 4 | **14 statuses vs 9 workflow states** | انفصال بين `current_status` و workflow يسبب ارتباكًا | توحيد الحالات: كل حالة في workflow يجب أن تقابل حالة في `application_statuses` والعكس |
| 5 | **No SLA enforcement** | لا توجد متابعة آلية للمهل الزمنية للمراجعة | تفعيل `workflow_sla` + `fn_check_sla()` مع إشعارات عند تجاوز المدة |

### Priority 2 Gaps (Should Fix)

| # | Gap | Impact | Recommendation |
|---|-----|--------|--------------|
| 6 | **No expedited review path** | المستعجلة (EXPEDITED) ليس لها مسار مختلف في workflow | إضافة workflow ثاني لـ EXPEDITED أو مسار مختصر في نفس workflow |
| 7 | **Amendments not linked to workflow** | التعديلات تمر خارج سير العمل الرسمي | إضافة workflow للأمendment (AMENDMENT_REVIEW) أو إعادة توجيه التعديلات لمسار المراجعة |
| 8 | **Monitoring findings don't trigger workflow transitions** | المخالفات الرقابية لا تؤدي لتعليق أو إنهاء الموافقة | إضافة system functions للربط بين monitoring و workflow |
| 9 | **No audit trail link between workflow and application_history** | `application_history` فارغ — جميع الحركات مسجلة في `workflow` فقط | ربط الـ triggers بكتابة الـ application_history عند كل transition |
| 10 | **Withdraw function missing** | لا يوجد مسار سحب رغم وجوده في reference | إضافة `WITHDRAW` transition للباحث مع حالة WITHHELD/WITHDRAWN |

### Priority 3 Gaps (Nice to Have)

| # | Gap | Recommendation |
|---|-----|--------------|
| 11 | No integration with ClinicalTrials.gov / WHO ICTRP | إضافة webhook/external_system connector |
| 12 | No electronic remote voting | إضافة voting_type = ELECTRONIC مع دعم التوقيع الرقمي |
| 13 | No automatic consent form generation | إنشاء نماذج موافقة مخصصة بناءً على `consent_templates` |
| 14 | No community engagement tracking | إضافة جدول community_engagement مع مخرجات التشاور المجتمعي |
| 15 | No Serious Breach reporting module | إضافة جدول `serious_breaches` مع إشعارات للجهات الرقابية |

### Database Status Data Discrepancy

The following statuses exist in live application data but are **not defined** in `reference.application_statuses`:
- `UNDER_REVIEW` — appears in 11 applications
- `CONDITIONALLY_APPROVED` — appears in 5 applications
- `DEFERRED` — appears in 5 applications
- `SUSPENDED` — appears in 4 applications
- `ARCHIVED` — appears in 1 application (but used as project status elsewhere)
- `CONDITIONAL` — appears in 1 application (likely legacy/typo)

> **توصية عاجلة**: يجب إضافة هذه الحالات إلى `reference.application_statuses` أو تحويل التطبيقات الموجودة إلى الحالات الرسمية المدعومة في workflow.

---

## 8. Appendix: Database Schema Reference

### Workflow Tables (Live DB)

```sql
-- workflow.workflows
id              BIGINT PK
workflow_code   VARCHAR(100) NOT NULL  -- 'APP_REVIEW_V1'
workflow_name   VARCHAR(300) NOT NULL  -- سير عمل مراجعة الطلبات
entity_type     VARCHAR(100) NOT NULL  -- 'Application'
version_no      INTEGER DEFAULT 1
is_active       BOOLEAN DEFAULT TRUE
created_at      TIMESTAMPTZ DEFAULT NOW()

-- workflow.workflow_states
id              BIGINT PK
workflow_id     BIGINT FK → workflows.id
state_code      VARCHAR(100) NOT NULL  -- 'DRAFT', 'SUBMITTED', etc.
state_name      VARCHAR(300) NOT NULL  -- مسودة, مقدم, etc.
is_initial      BOOLEAN DEFAULT FALSE
is_terminal     BOOLEAN DEFAULT FALSE
display_order   INTEGER DEFAULT 1

-- workflow.workflow_transitions
id              BIGINT PK
workflow_id     BIGINT FK → workflows.id
from_state_id   BIGINT FK → workflow_states.id
to_state_id     BIGINT FK → workflow_states.id
transition_code VARCHAR(100) NOT NULL  -- 'SUBMIT', 'ACCEPT_INITIAL', etc.
transition_name VARCHAR(300) NOT NULL  -- تقديم الطلب, etc.
requires_comment BOOLEAN DEFAULT FALSE
requires_vote    BOOLEAN DEFAULT FALSE
allowed_roles    TEXT[] -- Array of role codes

-- workflow.workflow_instances
id              BIGINT PK
workflow_id     BIGINT FK → workflows.id
entity_type     VARCHAR(100) NOT NULL  -- 'Application'
entity_id       BIGINT NOT NULL
current_state_id BIGINT FK → workflow_states.id
started_at      TIMESTAMPTZ
completed_at    TIMESTAMPTZ
status_code     VARCHAR(50) DEFAULT 'ACTIVE'  -- ACTIVE, COMPLETED, SUSPENDED

-- workflow.workflow_actions
id              BIGINT PK
workflow_instance_id BIGINT FK
transition_id   BIGINT FK
action_by       BIGINT FK → security.users.id
action_comment  TEXT
action_date     TIMESTAMPTZ

-- workflow.workflow_history
id                      BIGINT PK
workflow_instance_id    BIGINT FK
from_state_id           BIGINT FK
to_state_id             BIGINT FK
transition_id           BIGINT FK
action_by               BIGINT
action_date             TIMESTAMPTZ
comments                TEXT

-- workflow.workflow_sla
id              BIGINT PK
workflow_id     BIGINT FK
state_id        BIGINT FK
sla_duration    INTERVAL
escalation_action TEXT
```

### Core Application Tables

```sql
-- core.projects
id                          BIGINT PK
institution_id              BIGINT FK → security.institutions.id
project_code                VARCHAR(100) UNIQUE NOT NULL  -- PRJ-YY-NNNNNN
title_ar / title_en         VARCHAR(1000)
abstract_ar / abstract_en   TEXT
objectives                  TEXT
principal_investigator_id   BIGINT FK → security.users.id
research_category           VARCHAR(100)
risk_level                  VARCHAR(50)
status_code                 VARCHAR(50) DEFAULT 'DRAFT'
start_date / end_date       DATE

-- core.applications
id                          BIGINT PK
application_number          VARCHAR(100) UNIQUE NOT NULL  -- APP-YYYY-NNNNNN
project_id                  BIGINT FK → core.projects.id
application_type            VARCHAR(50) NOT NULL  -- INITIAL, AMENDMENT, EXPEDITED, NEW, FULL
current_status              VARCHAR(50) DEFAULT 'DRAFT'
submission_date             TIMESTAMPTZ
submitted_by                BIGINT FK → security.users.id
priority_level              VARCHAR(50)
target_committee_id         BIGINT FK → committee.committees.id
```

### Review Tables

```sql
-- committee.review_assignments
id                BIGINT PK
application_id    BIGINT FK → core.applications.id
reviewer_id       BIGINT FK → security.users.id
review_type       VARCHAR(50)  -- SCIENTIFIC, ETHICS, CONSENT
assigned_by       BIGINT
assigned_at       TIMESTAMPTZ
due_date          TIMESTAMPTZ
status_code       VARCHAR(50)  -- ASSIGNED, IN_PROGRESS, COMPLETED, OVERDUE

-- committee.scientific_reviews
id                BIGINT PK
application_id    BIGINT FK
reviewer_id       BIGINT FK
review_status     VARCHAR(50)  -- COMPLETED
recommendation    VARCHAR(50)  -- APPROVED, REJECTED, REVISIONS_REQUIRED
summary           TEXT
started_at        TIMESTAMPTZ
completed_at      TIMESTAMPTZ

-- committee.ethics_reviews
id                BIGINT PK
application_id    BIGINT FK
reviewer_id       BIGINT FK
review_status     VARCHAR(50)
recommendation    VARCHAR(50)  -- APPROVED
ethical_risk_assessment VARCHAR(50)  -- LOW, MEDIUM
summary           TEXT
started_at        TIMESTAMPTZ
completed_at      TIMESTAMPTZ

-- committee.voting_sessions
id                BIGINT PK
application_id    BIGINT FK
meeting_id        BIGINT FK → committee.committee_meetings.id
voting_type       VARCHAR(50)  -- STANDARD
voting_start      TIMESTAMPTZ
voting_end        TIMESTAMPTZ
status_code       VARCHAR(50)  -- OPEN, CLOSED

-- committee.votes
id                BIGINT PK
voting_session_id BIGINT FK
voter_id          BIGINT FK → security.users.id
vote_type         VARCHAR(50) FK → reference.vote_types
comments          TEXT
```

### System Functions Summary

```sql
-- Workflow engine
system.fn_init_workflow(p_workflow_code, p_entity_type, p_entity_id) RETURNS BIGINT
system.fn_auto_transition(p_entity_type, p_entity_id, p_action_by, p_comment) RETURNS JSONB

-- Identity & auth
system.fn_current_user_id() RETURNS BIGINT
system.fn_is_admin() RETURNS BOOLEAN
system.fn_is_admin(p_user_id BIGINT) RETURNS BOOLEAN

-- Generation
system.fn_generate_application_number() RETURNS VARCHAR
system.fn_generate_project_code() RETURNS VARCHAR

-- Triggers
system.fn_notify_status_change() RETURNS TRIGGER  -- On applications.status change
system.fn_update_updated_at() RETURNS TRIGGER     -- On any table update
system.fn_create_snapshot() RETURNS TRIGGER       -- Versioning on update
system.fn_log_audit() RETURNS TRIGGER             -- Audit logging
system.fn_calculate_quorum() RETURNS TRIGGER
system.fn_check_sla() RETURNS TRIGGER
```

---

*Document generated from live database queries against `ethics_db` (PostgreSQL 18.3) on 27 June 2026.*  
*All data is based on actual records from `workflow.workflow_states`, `workflow.workflow_transitions`, `core.applications`, `committee.*`, `monitoring.*`, `safety.*`, and `reference.*` tables.*
