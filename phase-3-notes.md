# Phase 3: Functions + Triggers (منطق الأعمال) — ملاحظات التنفيذ

**التاريخ:** 2026-06-03
**الحالة:** مكتمل ✅

---

## ما تم تنفيذه
1. ✅ **11 دالة** في Schema `system`:
   - `fn_update_updated_at()` — تحديث `updated_at` تلقائياً
   - `fn_generate_application_number()` — توليد رقم طلب
   - `fn_generate_project_code()` — توليد كود مشروع
   - `fn_log_audit()` — تسجيل التغييرات
   - `fn_calculate_quorum(p_meeting_id)` — حساب النصاب
   - `fn_check_sla()` — مراقبة المهلة
   - `fn_auto_transition()` — محرك الانتقال التلقائي
   - `fn_create_snapshot()` — نسخ احتياطية عند التعديل
   - `fn_init_workflow()` — بدء سير العمل
   - `fn_notify_status_change()` — إشعار تغيير الحالة
   - `fn_apply_audit_triggers()` — تطبيق محفزات التدقيق

2. ✅ **19 Trigger**:
   - `trigger_updated_at` — على جميع الجداول التي تحتوي `updated_at`
   - `trigger_audit_*` — على 7 جداول رئيسية (applications, projects, users, committee_members, workflow_instances, documents, adverse_events)
   - `trigger_versioning_*` — على applications + projects
   - `trigger_notification_applications` — على applications

3. ✅ **سير العمل (Workflow)**:
   - تعريف `APP_REVIEW` مع 6 حالات و 6 انتقالات
   - (بالإضافة إلى `ETHICS_APPLICATION` الموجود سابقاً)

4. ✅ **إعدادات النظام**:
   - 11 config key في `system_config`
   - 6 audit config entries


---

## الوظائف المطلوب إنشاؤها

1. `fn_update_updated_at()` — Trigger function لتحديث `updated_at` تلقائياً (Standard)
2. `fn_generate_application_number()` — توليد رقم طلب آلي
3. `fn_generate_project_code()` — توليد كود مشروع آلي
4. `fn_log_audit()` — تسجيل التغييرات في audit.logs
5. `fn_calculate_quorum()` — حساب النصاب القانوني
6. `fn_check_sla()` — مراقبة المهلة الزمنية
7. `fn_auto_transition()` — Auto State Transition Engine
8. `fn_create_snapshot()` — إنشاء نسخة عند التعديل

## المحفزات (Triggers) المطلوبة

- trigger_updated_at على كل جدول يحتوي `updated_at`
- trigger_audit على الجداول الرئيسية
- trigger_versioning على project_versions و application_versions
- trigger_notification على تغيير الحالة

## ملاحظات
- كل الدوال تُنشأ في Schema `system` (لتوحيد دوال النظام)
- استخدام `SECURITY DEFINER` للدوال التي تحتاج صلاحيات عالية
