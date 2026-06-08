# Phase 0: Database Housekeeping — ملاحظات التنفيذ

**التاريخ:** 2026-06-03
**الحالة:** مكتمل ✅

---

## ما تم تنفيذه
1. ✅ تغيير ملكية **13 Schema** من `postgres` ← `ethics_owner`
2. ✅ إعادة ملكية **120 جدول** من `postgres` ← `ethics_owner`
3. ✅ منح صلاحيات USAGE, CREATE لـ `ethics_migration` على جميع الـ Schemas
4. ✅ منح USAGE وباقي الصلاحيات لـ `ethics_app`, `ethics_audit`, `ethics_reporting`, `ethics_readonly`, `ethics_workflow`
5. ✅ GRANT SELECT, INSERT, UPDATE, DELETE على جميع الجداول للأدوار المناسبة
6. ✅ ALTER DEFAULT PRIVILEGES لجميع الـ Schemas
7. ✅ إضافة Foreign Key `fk_committees_type` بين `committees` و `committee_types`
8. ✅ إنشاء جدول الربط `committee.committee_member_roles` (كان مفقوداً)

---

## المشكلة المكتشفة
- جميع الـ 14 Schema مملوكة للمستخدم `postgres` (سوبر يوزر)
- المستخدم `ethics_owner` ليس لديه صلاحية USAGE أو CREATE على أي Schema
- لا يمكن تشغيل أي أمر DDL/AQL بـ `ethics_owner` حاليًا

## ملاحظات
- يجب الاتصال بـ `postgres` (أو superuser آخر) لتنفيذ تغيير الملكية
- بعد تغيير الملكية، يجب منح الصلاحيات لباقي الأدوار
- يوجد Foreign Key مفقود موثق في DDL (committee.committees → committee_types)
- يوجد جدول ربط `committee_member_roles` مذكور في ملاحظات DDL ولكن لم يتم إنشاؤه
- يجب ضبط Default Privileges لكل Schema
