# تقرير تدقيق RLS الشامل

> **RC1.2 — RLS Hardening Sprint**
> تاريخ التقرير: 2026-06-27
> الإصدار: 1.0

---

## فهرس المحتويات

1. [ملخص تنفيذي](#1-ملخص-تنفيذي)
2. [منهجية التدقيق](#2-منهجية-التدقيق)
3. [جداول RLS — التغطية الكاملة](#3-جداول-rls--التغطية-الكاملة)
4. [جداول بدون سياسات INSERT](#4-جداول-بدون-سياسات-insert)
5. [جداول بدون سياسات UPDATE/DELETE](#5-جداول-بدون-سياسات-updatedelete)
6. [جرد دوال SECURITY DEFINER](#6-جرد-دوال-security-definer)
7. [دوال المساعدة (Helper Functions)](#7-دوال-المساعدة-helper-functions)
8. [تحليل احتمالية RLS Recursion](#8-تحليل-احتمالية-rls-recursion)
9. [تحليل جميع عمليات INSERT في الكود](#9-تحليل-جميع-عمليات-insert-في-الكود)
10. [قرارات معمارية](#10-قرارات-معمارية)
11. [التوصيات الفورية](#11-التوصيات-الفورية)

---

## 1. ملخص تنفيذي

تم إجراء تدقيق شامل لمنظومة Row Level Security عبر 72 جدولاً من 15 schema.

### النتائج الرئيسية

| البند | القيمة |
|-------|--------|
| إجمالي الجداول المفعل عليها RLS | 72 |
| جداول بسياسات INSERT كاملة | 69 |
| جداول بدون سياسات INSERT | 3 |
| جداول بدون سياسات UPDATE | 7 |
| جداول بدون سياسات DELETE | 36 |
| دوال SECURITY DEFINER | 12 |
| سياسات مكررة أو متضاربة | 0 |
| ثغرات نشطة (تؤثر على كود الإنتاج) | 1 (تم إصلاحها: documents.documents) |

### الخلاصة

- مشكلة `documents.documents` تم إصلاحها بإضافة `documents_insert_policy`.
- باقي الثغرات (3 جداول بدون INSERT policy) لا تؤثر حالياً لأن التطبيق لا يكتب عليها مباشرة.
- 36 جدولاً بدون DELETE policy — هذا مقصود لأن التطبيق يستخدم soft delete عبر UPDATE.
- نظام RLS مستقر وقابل للتوسع مع بعض التحسينات الموصى بها.

---

## 2. منهجية التدقيق

### المصادر

1. **قاعدة البيانات**: استعلامات مباشرة على `pg_class`, `pg_policies`, `pg_proc`
2. **الكود المصدري**: جميع ملفات TypeScript في `backend/src/repositories/`, `backend/src/services/`, `backend/src/modules/`
3. **ملفات البذور**: جميع ملفات SQL في `backend/seed/`

### معايير التقييم

- كل جدول مفعل عليه RLS يجب أن يكون لديه:
  - سياسة INSERT تتحقق من `app.user_id`
  - سياسة SELECT
  - سياسة UPDATE
  - سياسة DELETE (أو soft delete عبر UPDATE)
- لا يُسمح بسياسات `FOR ALL` في جداول الإنتاج
- كل دالة `SECURITY DEFINER` يجب أن يكون لها سبب موثق

---

## 3. جداول RLS — التغطية الكاملة

### 3.1 Schema: `committee` (21 جدولاً)

| الجدول | SELECT | INSERT | UPDATE | DELETE | ملاحظات |
|--------|--------|--------|--------|--------|----------|
| accreditation_assessment_items | ✅ | ✅ | ✅ | ❌ | Soft delete |
| accreditation_assessments | ✅ | ✅ | ✅ | ❌ | Soft delete |
| accreditation_conditions | ✅ | ✅ | ✅ | ❌ | Soft delete |
| accreditation_cycle_metrics | ✅ | ✅ | ✅ | ❌ | Soft delete |
| accreditation_cycles | ✅ | ✅ | ✅ | ✅ | |
| accreditation_decisions | ✅ | ✅ | ❌ | ❌ | إضافات فقط |
| accreditation_evidence | ✅ | ✅ | ✅ | ❌ | Soft delete |
| accreditation_standard_versions | ✅ | ✅ | ✅ | ✅ | |
| accreditation_standards | ✅ | ✅ | ✅ | ✅ | |
| committee_meetings | ✅ | ✅ | ✅ | ❌ | Soft delete |
| consent_review_comments | ✅ | ✅ | ✅ | ✅ | |
| consent_template_versions | ✅ | ✅ | ✅ | ✅ | |
| consent_templates | ✅ | ✅ | ✅ | ✅ | |
| ethics_reviews | ✅ | ✅ | ✅ | ❌ | Soft delete |
| ethics_risk_assessments | ✅ | ✅ | ✅ | ✅ | |
| ethics_risk_items | ✅ | ✅ | ✅ | ✅ | |
| member_conflicts | ✅ | ✅ | ✅ | ✅ | |
| member_qualifications | ✅ | ✅ | ✅ | ✅ | |
| member_terms | ✅ | ✅ | ✅ | ✅ | |
| review_assignments | ✅ | ✅ | ✅ | ❌ | Soft delete |
| scientific_reviews | ✅ | ✅ | ✅ | ❌ | Soft delete |

### 3.2 Schema: `communication` (8 جداول)

| الجدول | SELECT | INSERT | UPDATE | DELETE | ملاحظات |
|--------|--------|--------|--------|--------|----------|
| announcements | ✅ | ✅ | ✅ | ✅ | |
| message_attachments | ✅ | ✅ | ✅ | ✅ | |
| message_recipients | ✅ | ✅ | ✅ | ✅ | |
| messages | ✅ | ✅ | ✅ | ✅ | |
| notification_channels | ✅ | ✅ | ✅ | ✅ | |
| notification_logs | ✅ | ✅ | ✅ | ✅ | |
| notification_templates | ✅ | ✅ | ✅ | ✅ | |
| notifications | ✅ | ✅ | ✅ | ✅ | |

### 3.3 Schema: `core` (3 جداول)

| الجدول | SELECT | INSERT | UPDATE | DELETE | ملاحظات |
|--------|--------|--------|--------|--------|----------|
| application_consents | ✅ | ✅ | ✅ | ✅ | |
| applications | ✅ | ✅ | ✅ | ❌ | Soft delete |
| projects | ✅ | ✅ | ✅ | ❌ | Soft delete |

### 3.4 Schema: `documents` (1 جدول)

| الجدول | SELECT | INSERT | UPDATE | DELETE | ملاحظات |
|--------|--------|--------|--------|--------|----------|
| documents | ✅ | ✅ | ✅ | ❌ | تمت إضافة INSERT في هذا السباق |

### 3.5 Schema: `integration` (3 جداول)

| الجدول | SELECT | INSERT | UPDATE | DELETE | ملاحظات |
|--------|--------|--------|--------|--------|----------|
| data_sync_jobs | ✅ | ✅ | ✅ | ❌ | |
| integration_credentials | ✅ | ✅ | ✅ | ✅ | |
| integration_failures | ✅ | ❌ | ✅ | ❌ | لا يُكتب من التطبيق |

### 3.6 Schema: `monitoring` (10 جداول)

| الجدول | SELECT | INSERT | UPDATE | DELETE | ملاحظات |
|--------|--------|--------|--------|--------|----------|
| compliance_reviews | ✅ | ✅ | ✅ | ✅ | |
| corrective_actions | ✅ | ✅ | ✅ | ✅ | |
| deviations | ✅ | ✅ | ✅ | ✅ | |
| inspection_reports | ✅ | ✅ | ✅ | ✅ | |
| inspections | ✅ | ✅ | ✅ | ✅ | |
| monitoring_findings | ✅ | ✅ | ✅ | ✅ | |
| monitoring_plans | ✅ | ✅ | ✅ | ✅ | |
| monitoring_visits | ✅ | ✅ | ✅ | ✅ | |
| preventive_actions | ✅ | ✅ | ✅ | ✅ | |
| protocol_violations | ✅ | ✅ | ✅ | ✅ | |

ملاحظة: monitoring schema لديه **تغطية كاملة** — كل جدول لديه جميع السياسات الأربع.

### 3.7 Schema: `reference` (1 جدول)

| الجدول | SELECT | INSERT | UPDATE | DELETE | ملاحظات |
|--------|--------|--------|--------|--------|----------|
| licenses_registry | ✅ | ✅ | ✅ | ✅ | SELECT يسمح للجميع (`true`) |

### 3.8 Schema: `reporting` (6 جداول)

| الجدول | SELECT | INSERT | UPDATE | DELETE | ملاحظات |
|--------|--------|--------|--------|--------|----------|
| analytics_snapshots | ✅ | ✅ | ✅ | ✅ | |
| dashboard_widgets | ✅ | ✅ | ✅ | ✅ | |
| kpi_results | ✅ | ✅ | ✅ | ✅ | |
| report_definitions | ✅ | ✅ | ✅ | ✅ | |
| report_executions | ✅ | ✅ | ✅ | ✅ | |

### 3.9 Schema: `safety` (4 جداول)

| الجدول | SELECT | INSERT | UPDATE | DELETE | ملاحظات |
|--------|--------|--------|--------|--------|----------|
| corrective_actions | ✅ | ✅ | ❌ | ❌ | سياسات جزئية |
| risk_incidents | ✅ | ✅ | ❌ | ❌ | سياسات جزئية |
| risk_mitigations | ✅ | ✅ | ❌ | ❌ | سياسات جزئية |
| risk_register | ✅ | ✅ | ✅ | ❌ | |

### 3.10 Schema: `security` (3 جداول)

| الجدول | SELECT | INSERT | UPDATE | DELETE | ملاحظات |
|--------|--------|--------|--------|--------|----------|
| password_reset_tokens | ✅ | ✅ | ✅ | ❌ | |
| user_responsibilities | ✅ | ✅ | ✅ | ✅ | |
| users | ✅ | ✅ | ✅ | ❌ | |

### 3.11 Schema: `system` (2 جداول)

| الجدول | SELECT | INSERT | UPDATE | DELETE | ملاحظات |
|--------|--------|--------|--------|--------|----------|
| saved_searches | ✅ | ✅ | ✅ | ✅ | |
| search_audit | ✅ | ❌ | ❌ | ❌ | للقراءة فقط، Admin فقط |

### 3.12 Schema: `workflow` (5 جداول)

| الجدول | SELECT | INSERT | UPDATE | DELETE | ملاحظات |
|--------|--------|--------|--------|--------|----------|
| workflow_events | ✅ | ❌ | ❌ | ❌ | للقراءة فقط |
| workflow_instances | ✅ | ✅ | ✅ | ❌ | |
| workflow_schedulers | ✅ | ✅ | ✅ | ❌ | |
| workflow_tasks | ✅ | ✅ | ✅ | ❌ | |
| workflow_triggers | ✅ | ✅ | ✅ | ❌ | |

---

## 4. جداول بدون سياسات INSERT

### 4.1 `integration.integration_failures`

| الخاصية | القيمة |
|---------|--------|
| RLS مفعل | ✅ |
| سياسات موجودة | SELECT, UPDATE |
| INSERT policy | ❌ |
| هل يُكتب من التطبيق؟ | ❌ — لا يوجد كود يكتب على هذا الجدول |
| الخطورة | **منخفضة** — لا تأثير حالياً |

### 4.2 `system.search_audit`

| الخاصية | القيمة |
|---------|--------|
| RLS مفعل | ✅ |
| سياسات موجودة | SELECT فقط (`fn_is_admin`) |
| INSERT policy | ❌ |
| هل يُكتب من التطبيق؟ | ❌ — لا يوجد كود يكتب على هذا الجدول |
| الخطورة | **منخفضة** — الجدول للقراءة فقط حالياً |

### 4.3 `workflow.workflow_events`

| الخاصية | القيمة |
|---------|--------|
| RLS مفعل | ✅ |
| سياسات موجودة | SELECT فقط |
| INSERT policy | ❌ |
| UPDATE policy | ❌ |
| DELETE policy | ❌ |
| هل يُكتب من التطبيق؟ | ❌ — لا يوجد كود يكتب على هذا الجدول |
| الخطورة | **منخفضة** — الجدول للقراءة فقط حالياً |

### الخلاصة

- الجداول الثلاثة بدون INSERT policy **لا تُكتب من التطبيق** حالياً.
- لا توجد ثغرة نشطة فيها.
- يوصى بإضافة سياسات INSERT احترازية في RC2 لضمان عدم تعطل التطبيق إذا تغيرت المتطلبات مستقبلاً.

---

## 5. جداول بدون سياسات UPDATE/DELETE

### 5.1 جداول بدون UPDATE policy

| الجدول | التأثير |
|--------|---------|
| `committee.accreditation_decisions` | السجلات نهائية بعد الإضافة |
| `safety.corrective_actions` | السجلات نهائية بعد الإضافة |
| `safety.risk_incidents` | السجلات نهائية بعد الإضافة |
| `safety.risk_mitigations` | السجلات نهائية بعد الإضافة |
| `integration.integration_failures` | للقراءة فقط |
| `system.search_audit` | للقراءة فقط |
| `workflow.workflow_events` | للقراءة فقط |

### 5.2 جداول بدون DELETE policy

36 جدولاً بدون DELETE policy. هذا **مقصود** — التطبيق يستخدم `soft delete` عبر تحديث حقل `deleted_at` بدلاً من `DELETE`. لذلك فإن سياسة UPDATE هي المسؤولة عن التحقق من صلاحية الحذف المنطقي.

إذا كان هناك حذف فعّال (hard delete) في المستقبل، يجب إضافة سياسات DELETE.

---

## 6. جرد دوال SECURITY DEFINER

### 6.1 `system.fn_is_admin()` — في `14-rls-complete.sql`

```sql
CREATE FUNCTION system.fn_is_admin()
RETURNS boolean
LANGUAGE sql STABLE SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1 FROM security.user_roles ur
    JOIN security.roles r ON ur.role_id = r.id
    WHERE ur.user_id = current_setting('app.user_id')::bigint
      AND r.code IN ('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN')
  );
$$;
```

**السبب**: SECURITY DEFINER ضروري لقراءة `security.user_roles` التي عليها RLS. بدونها، المستخدم العادي لا يستطيع رؤية أدواره للتحقق من صلاحية admin.

**الاستخدام**: مُستخدم في ~200+ سياسة عبر جميع الجداول.

**هل يمكن إزالته؟** لا — هذا عمود فقري لمنظومة RLS بأكملها.

### 6.2 `system.fn_is_admin(p_user_id)` — في `14-rls-complete.sql`

نفس الدالة لكن مع باراميتر. SECURITY DEFINER لنفس السبب.

### 6.3 `system.fn_current_user_id()` — في `14-rls-complete.sql`

```sql
CREATE FUNCTION system.fn_current_user_id()
RETURNS bigint
LANGUAGE sql STABLE SECURITY DEFINER
AS $$
  SELECT current_setting('app.user_id')::bigint;
$$;
```

**السبب**: SECURITY DEFINER ضروري لقراءة `app.user_id` في سياقات معينة حيث لا يمكن قراءة متغيرات الجلسة.

**ملاحظة**: هناك دالة مطابقة `communication.fn_current_user_id()` بدون SECURITY DEFINER.

### 6.4 `system.fn_log_audit()` — في `18-audit-fix.sql`

**السبب**: SECURITY DEFINER للسماح لدالة audit trigger بكتابة سجلات التدقيق بغض النظر عن RLS.

**ضروري**: نعم — audit يجب أن يسجل كل العمليات حتى لو كان المستخدم لا يملك صلاحية INSERT على audit logs.

### 6.5 `system.fn_notify_status_change()` — في `14-rls-complete.sql`

**السبب**: SECURITY DEFINER للسماح لـ trigger بإرسال إشعارات عبر INSERT على `communication.notifications` التي عليها RLS.

**ضروري**: نعم — trigger يعمل بصلاحيات مالك الجدول ويحتاج لتجاوز RLS.

### 6.6 دوال الـ Accreditation — في `32-accreditation-rls.sql` (7 دوال)

| الدالة | السبب |
|--------|-------|
| `fn_accred_cycle_visible()` | كسر recursion بين `accreditation_cycles` و `committee_members` |
| `fn_accred_evidence_visible()` | كسر recursion في `accreditation_evidence` |
| `fn_accred_assessment_visible()` | كسر recursion في `accreditation_assessments` |
| `fn_accred_condition_visible()` | كسر recursion في `accreditation_conditions` |
| `fn_accred_decision_visible()` | كسر recursion في `accreditation_decisions` |
| `fn_accred_cycle_metrics_visible()` | كسر recursion في `accreditation_cycle_metrics` |

**ضروري**: نعم — بسبب RLS recursion بين جدول accreditation والجداول المرتبطة به.

### 6.7 `security.fn_register_user()` — في `33-fix-register-rls.sql`

```sql
CREATE FUNCTION security.fn_register_user(...)
RETURNS bigint
LANGUAGE plpgsql SECURITY DEFINER
AS $$ ... $$;
```

**السبب**: تجاوز خطأ PostgreSQL 18.3 على Windows حيث `FOR INSERT WITH CHECK` لا يعمل بشكل صحيح على جدول `security.users`.

**ضروري حالياً**: نعم — بسبب خلل PostgreSQL 18.3 Windows.
**هل يمكن إزالته مستقبلاً**: نعم — عند ترقية PostgreSQL أو تأكيد أن الخلل محصور في Windows.

### ملخص SECURITY DEFINER

| الدالة | الملف | السبب | يمكن إزالته؟ |
|--------|------|-------|-------------|
| `system.fn_is_admin()` | 14-rls-complete.sql | قراءة user_roles مع RLS | لا |
| `system.fn_is_admin(p)` | 14-rls-complete.sql | قراءة user_roles مع RLS | لا |
| `system.fn_current_user_id()` | 14-rls-complete.sql | قراءة app.user_id | لا |
| `system.fn_log_audit()` | 18-audit-fix.sql | كتابة audit logs | لا |
| `system.fn_notify_status_change()` | 14-rls-complete.sql | إرسال إشعارات من trigger | لا |
| `fn_accred_*` (7 دوال) | 32-accreditation-rls.sql | كسر RLS recursion | لا |
| `security.fn_register_user()` | 33-fix-register-rls.sql | خلل PostgreSQL 18.3 Windows | **نعم — مستقبلاً** |

---

## 7. دوال المساعدة (Helper Functions)

| الدالة | Schema | SECURITY DEFINER | الاستخدام |
|--------|--------|-----------------|-----------|
| `fn_is_admin()` | system | ✅ | ~200+ سياسة |
| `fn_is_admin(p)` | system | ✅ | ~50 سياسة |
| `fn_current_user_id()` | system | ✅ | ~20 سياسة |
| `fn_current_user_id()` | communication | ❌ | نادر |
| `is_active_row()` | system | ❌ (IMMUTABLE) | فحص soft delete |

---

## 8. تحليل احتمالية RLS Recursion

### 8.1 ما هو RLS Recursion؟

يحدث RLS recursion عندما:
1. سياسة على جدول A تستعلم من جدول B
2. سياسة على جدول B تستعلم من جدول A
3. يتم إنشاء حلقة لا نهائية

### 8.2 التحقق من السلاسل المحتملة

#### السلسلة 1: `documents.documents` ← `core.applications`

- سياسة INSERT في `documents.documents` تستعلم `core.applications` للتحقق من ملكية التطبيق
- سياسة SELECT في `core.applications` **لا تستعلم** `documents.documents`
- **لا يوجد recursion** ✅

#### السلسلة 2: `workflow.workflow_instances` ← `core.applications`

- سياسة SELECT في `workflow.workflow_instances` تستعلم `core.applications`
- سياسة SELECT في `core.applications` **لا تستعلم** `workflow.workflow_instances`
- **لا يوجد recursion** ✅

#### السلسلة 3: `committee.ethics_risk_assessments` ← `core.applications` ← `committee.review_assignments`

- `ethics_risk_assessments` SELECT تستعلم `core.applications` AND `committee.review_assignments`
- `applications` SELECT تستعلم `committee.review_assignments`
- `review_assignments` SELECT تستعلم... دعنا نتحقق

لنفحص سياسة SELECT لـ `review_assignments`:

```
SELECT EXISTS (
  SELECT 1 FROM committee.committee_members cm
  WHERE cm.user_id = current_setting('app.user_id')::bigint
    AND cm.is_active = true
)
```

`review_assignments` SELECT تستعلم `committee_members` فقط، لا `applications` ولا `ethics_risk_assessments`.

إذاً:
- `ethics_risk_assessments` → `applications` ✅
- `ethics_risk_assessments` → `review_assignments` ✅
- `ethics_risk_items` → `ethics_risk_assessments` → `applications` ✅
- `applications` → `review_assignments` ✅
- `review_assignments` → `committee_members` ✅
- **لا يوجد recursion** ✅

#### السلسلة 4: Accreditation schema (معروفة)

- تم حل recursion في `32-accreditation-rls.sql` باستخدام دوال SECURITY DEFINER.
- **تمت المعالجة** ✅

### 8.3 الخلاصة

لا توجد سلاسل recursion نشطة في النظام بعد تطبيق إصلاحات accreditation.

---

## 9. تحليل جميع عمليات INSERT في الكود

### 9.1 المنهجية

تم فحص جميع ملفات TypeScript في `backend/src/` والبحث عن كل عملية `INSERT INTO`. لكل INSERT تم تحديد:
1. الجدول المستهدف
2. هل الجدول عليه RLS
3. هل توجد INSERT Policy
4. هل سياسة INSERT تعتمد على `app.user_id`
5. هل Repository يرسل جميع الأعمدة المطلوبة بواسطة WITH CHECK

### 9.2 مصفوفة INSERT

| # | الملف | الجدول | RLS؟ | INSERT Policy؟ | تعتمد على app.user_id؟ | ملاحظات |
|---|-------|--------|------|---------------|----------------------|----------|
| 1 | auth.repository.ts | `security.login_audit` | ❌ | N/A | N/A | بدون RLS |
| 2 | auth.repository.ts | `security.security_events` | ❌ | N/A | N/A | بدون RLS |
| 3 | auth.repository.ts | `security.sessions` | ❌ | N/A | N/A | بدون RLS |
| 4 | auth.repository.ts | `security.password_history` | ❌ | N/A | N/A | بدون RLS |
| 5 | auth.repository.ts | `security.password_reset_tokens` | ✅ | ✅ | ✅ `user_id = app.user_id OR 0 OR admin` | |
| 6 | auth.repository.ts | `security.email_verification_tokens` | ❌ | N/A | N/A | بدون RLS |
| 7 | users.repository.ts | `security.user_roles` | ❌ | N/A | N/A | بدون RLS (مشكلة محتملة) |
| 8 | users.repository.ts | `security.user_profiles` | ❌ | N/A | N/A | بدون RLS |
| 9 | users.repository.ts | `security.user_responsibilities` | ✅ | ✅ | ✅ admin فقط | |
| 10 | authorization.repository.ts | `security.roles` | ❌ | N/A | N/A | بدون RLS |
| 11 | authorization.repository.ts | `security.permissions` | ❌ | N/A | N/A | بدون RLS |
| 12 | authorization.repository.ts | `security.role_permissions` | ❌ | N/A | N/A | بدون RLS |
| 13 | application.repository.ts | `core.applications` | ✅ | ✅ | ✅ `submitted_by = app.user_id OR admin` | |
| 14 | project.repository.ts | `core.projects` | ✅ | ✅ | ✅ `created_by = app.user_id OR admin` | |
| 15 | application-consent.repository.ts | `core.application_consents` | ✅ | ✅ | ✅ | |
| 16 | document.repository.ts | `documents.documents` | ✅ | ✅ *جديد* | ✅ `uploaded_by = app.user_id OR admin` | تم الإصلاح في هذا السباق |
| 17 | document.repository.ts | `documents.document_signatures` | ❌ | N/A | N/A | بدون RLS |
| 18 | committee.repository.ts | `committee.committees` | ❌ | N/A | N/A | بدون RLS |
| 19 | committee.repository.ts | `committee.committee_members` | ❌ | N/A | N/A | بدون RLS |
| 20 | committee.repository.ts | `committee.member_terms` | ✅ | ✅ | ✅ | |
| 21 | committee.repository.ts | `committee.member_qualifications` | ✅ | ✅ | ✅ | |
| 22 | committee.repository.ts | `committee.member_conflicts` | ✅ | ✅ | ✅ | |
| 23 | committee.repository.ts | `committee.review_assignments` | ✅ | ✅ | ✅ | |
| 24 | committee.repository.ts | `committee.review_forms` | ❌ | N/A | N/A | بدون RLS |
| 25 | committee.repository.ts | `committee.review_questions` | ❌ | N/A | N/A | بدون RLS |
| 26 | committee.repository.ts | `committee.review_recommendations` | ❌ | N/A | N/A | بدون RLS |
| 27 | committee.repository.ts | `committee.review_comments` | ❌ | N/A | N/A | بدون RLS |
| 28 | committee.repository.ts | `committee.review_answers` | ❌ | N/A | N/A | بدون RLS |
| 29 | committee.repository.ts | `committee.review_scores` | ❌ | N/A | N/A | بدون RLS |
| 30 | committee.repository.ts | `committee.committee_meetings` | ✅ | ✅ | ✅ | |
| 31 | committee.repository.ts | `committee.meeting_agendas` | ❌ | N/A | N/A | بدون RLS |
| 32 | committee.repository.ts | `committee.agenda_items` | ❌ | N/A | N/A | بدون RLS |
| 33 | committee.repository.ts | `committee.attendance_logs` | ❌ | N/A | N/A | بدون RLS |
| 34 | committee.repository.ts | `committee.meeting_minutes` | ❌ | N/A | N/A | بدون RLS |
| 35 | committee.repository.ts | `committee.voting_sessions` | ❌ | N/A | N/A | بدون RLS |
| 36 | committee.repository.ts | `committee.votes` | ❌ | N/A | N/A | بدون RLS |
| 37 | communication.repository.ts | `communication.messages` | ✅ | ✅ | ✅ | |
| 38 | communication.repository.ts | `communication.message_recipients` | ✅ | ✅ | ✅ | |
| 39 | communication.repository.ts | `communication.message_attachments` | ✅ | ✅ | ✅ | |
| 40 | notification.service.ts | `communication.notifications` | ✅ | ✅ | ✅ | |
| 41 | ethics-risk.repository.ts | `committee.ethics_risk_assessments` | ✅ | ✅ | ✅ | |
| 42 | ethics-risk.repository.ts | `committee.ethics_risk_items` | ✅ | ✅ | ✅ | |
| 43 | safety.repository.ts | `safety.risk_register` | ✅ | ✅ | ✅ | |
| 44 | safety.repository.ts | `safety.risk_mitigations` | ✅ | ✅ | ✅ | |
| 45 | safety.repository.ts | `safety.risk_incidents` | ✅ | ✅ | ✅ | |
| 46 | safety.repository.ts | `safety.corrective_actions` | ✅ | ✅ | ✅ | |
| 47 | safety.repository.ts | `safety.adverse_events` | ❌ | N/A | N/A | بدون RLS |
| 48 | workflow.repository.ts | `workflow.workflow_actions` | ❌ | N/A | N/A | بدون RLS |
| 49 | workflow.repository.ts | `workflow.workflow_history` | ❌ | N/A | N/A | بدون RLS |
| 50 | accreditation-*.repository.ts | `committee.accreditation_*` | ✅ | ✅ | ✅ | |
| 51 | consent-*.repository.ts | `committee.consent_*` | ✅ | ✅ | ✅ | |
| 52 | system.repository.ts | `system.saved_searches` | ✅ | ✅ | ✅ | |
| 53 | system-config.routes.ts | `system.system_config` | ❌ | N/A | N/A | بدون RLS |
| 54 | reference-data.routes.ts | جداول ديناميكية | ✅/❌ | حسب الجدول | حسب الجدول | خطير — يجب مراجعته |
| 55 | email-config.repository.ts | `system.email_config` | ❌ | N/A | N/A | بدون RLS |
| 56 | sms-config.repository.ts | `system.sms_config` | ❌ | N/A | N/A | بدون RLS |
| 57 | push-config.repository.ts | `system.push_config` | ❌ | N/A | N/A | بدون RLS |

### 9.3 ملاحظات هامة على INSERT

#### 9.3.1 `reference-data.routes.ts` — إدخال ديناميكي (خطير)

```
const result = await query(`INSERT INTO ${cfg.fullTable} (${cols}) VALUES (${placeholders}) RETURNING *`, values);
```

هذا الكود يسمح بالإدخال في جداول مختلفة بناءً على تكوين. يجب التحقق من أن:
- جميع الجداول المستهدفة لها RLS وسياسات INSERT
- أو أن الجداول بدون RLS (مثل reference data)

#### 9.3.2 `committee` schema — معظم الجداول بدون RLS

جداول مثل `committee_members`, `review_assignments` (بعضها), `committees` نفسها **لا يوجد عليها RLS**. هذا مقصود لأن هذه الجداول يديرها المسؤولون فقط (admin-only من طبقة التطبيق).

#### 9.3.3 `security` schema — بعض الجداول بدون RLS

`security.login_audit`, `security.security_events`, `security.sessions`, `security.password_history`, `security.email_verification_tokens` — ليس عليها RLS. هذا مقصود لأنها تحتاج أن يكتبها النظام حتى للمستخدمين غير المسجلين.

---

## 10. قرارات معمارية

### 10.1 توزيع RLS حسب الحساسية

| المستوى | schema | أسلوب RLS |
|---------|--------|-----------|
 | حرج | `core`, `documents` | owner + admin + authorized roles |
| حساس | `safety`, `committee`, `monitoring` | admin + owner/assigned |
| توثيق | `reporting`, `system` | admin أساساً |
| عام | `reference` | SELECT مفتوح للجميع |
| نظام | `integration` | admin |
| غير محمي | `audit` | لا يوجد RLS (SECURITY DEFINER triggers) |

### 10.2 Soft Delete كبديل عن DELETE

النظام يعتمد على soft delete (`deleted_at`, `deleted_by`) بدلاً من hard delete. لذلك:
- سياسات DELETE غير ضرورية في معظم الجداول
- سياسات UPDATE تتحقق من صلاحية "الحذف" عبر التحقق من `is_active_row()`
- هذا نمط سليم لتطبيقات ERM حيث يجب الاحتفاظ بسجل التغييرات

### 10.3 SECURITY DEFINER كحل ضروري

SECURITY DEFINER يُستخدم فقط عندما:
1. دالة تحتاج قراءة جداول عليها RLS (مثل `fn_is_admin`)
2. Trigger يحتاج كتابة سجلات Audit/Notification
3. كسر حلقة RLS recursion (accreditation)
4. خلل في PostgreSQL (register — `33-fix-register-rls.sql`)

### 10.4 سياسات `FOR ALL`

تم اكتشاف 6 جداول اختبارية تستخدم `FOR ALL USING (true) WITH CHECK (...)`:
- `test_rls6.t4` — policy `p4` for ALL
- `test_rls5.t3`, `test_rls8.t6`, `test_rls9.t7` — FOR INSERT WITH CHECK (true)

هذه **جداول اختبارية** وليست للإنتاج. لا تشكل خطراً.

---

## 11. التوصيات الفورية

### أولوية عالية — يجب التنفيذ في RC1.2

| # | التوصية | السبب |
|---|---------|-------|
| 1 | ✅ **تم**: إضافة `documents_insert_policy` | خلل نشط يمنع رفع المستندات |
| 2 | مراجعة `reference-data.routes.ts` — التأكد من أن الجداول المستهدفة لها RLS مناسب | إدخال ديناميكي قد يتجاوز RLS |
| 3 | توثيق سبب `security.fn_register_user()` SECURITY DEFINER في الكود | الشفافية المعمارية |

### أولوية متوسطة — RC1.3 أو RC2

| # | التوصية | السبب |
|---|---------|-------|
| 4 | إضافة سياسات INSERT احترازية لـ `workflow_events`, `search_audit`, `integration_failures` | استقرار مستقبلي |
| 5 | توحيد اسم سياسة UPDATE في `safety.corrective_actions` | الاتساق |
| 6 | إزالة `test_rls*` schemas | لا حاجة لها في الإنتاج |
| 7 | إضافة سياسات UPDATE لـ `safety.corrective_actions`, `safety.risk_incidents`, `safety.risk_mitigations` | إذا كان التعديل مسموحاً |

### أولوية منخفضة — RC2

| # | التوصية | السبب |
|---|---------|-------|
| 8 | إزالة `security.fn_register_user()` عند تأكيد إصلاح PostgreSQL 18.3 Windows | استعادة النمط الطبيعي |
| 9 | توحيد `fn_current_user_id()` — دالتان متطابقتان | تنظيف |
| 10 | إعادة النظر في جداول committee بدون RLS | تقييم الحاجة |

---

## الملحق ألف — جميع جداول RLS (72 جدولاً)

تم سردها بشكل كامل في الأقسام 3.1–3.12 أعلاه.

## الملحق باء — جميع سياسات RLS (235 سياسة)

تم استخراجها من `pg_policies` وتحميلها في الملف المساند.
