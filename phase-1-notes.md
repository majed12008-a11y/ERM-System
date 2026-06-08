# Phase 1: Reference/Seed Data — ملاحظات التنفيذ

**التاريخ:** 2026-06-03
**الحالة:** مكتمل ✅

---

## ما تم تنفيذه
1. ✅ `security.roles` — 12 دوراً (16 بإجمالي 4 أدوار سابقة)
2. ✅ `security.institution_types` — 5 أنواع مؤسسات
3. ✅ `reference.lookup_categories` — 6 فئات
4. ✅ `reference.lookup_values` — 23 قيمة مرجعية
5. ✅ `reference.application_statuses` — 9 حالات
6. ✅ `reference.review_statuses` — 4 حالات
7. ✅ `reference.workflow_statuses` — 4 حالات
8. ✅ `reference.risk_levels` — 3 مستويات
9. ✅ `reference.priority_levels` — 4 مستويات
10. ✅ `reference.document_statuses` — 4 حالات
11. ✅ `reference.notification_statuses` — 5 حالات
12. ✅ `reference.committee_decision_types` — 4 أنواع قرارات
13. ✅ `reference.vote_types` — 3 أنواع تصويت
14. ✅ `documents.document_types` — 9 أنواع مستندات
15. ✅ `committee.committee_roles` — 6 أدوار لجنة
16. ✅ `communication.notification_channels` — 5 قنوات
17. ✅ `reference.status_types` — 5 أنواع حالات

---

## الهدف
تعبئة جميع جداول الـ Reference والبيانات الأساسية التي يحتاجها النظام للعمل.

## الجداول المستهدفة
1. `security.roles` — 12 دوراً
2. `security.institution_types` — 5 أنواع
3. `security.permissions` — صلاحيات لكل وحدة
4. `reference.lookup_categories` + `reference.lookup_values` — الفئات والقيم المرجعية
5. `reference.application_statuses` — حالات الطلب
6. `reference.review_statuses` — حالات المراجعة
7. `reference.workflow_statuses` — حالات سير العمل
8. `reference.risk_levels` — مستويات المخاطرة
9. `reference.priority_levels` — مستويات الأولوية
10. `reference.document_statuses` — حالات المستندات
11. `reference.notification_statuses` — حالات الإشعارات
12. `reference.committee_decision_types` — أنواع قرارات اللجنة
13. `reference.vote_types` — أنواع التصويت
14. `documents.document_types` — أنواع المستندات
15. `committee.committee_roles` — أدوار اللجنة
16. `communication.notification_channels` — قنوات الإشعارات

## ملاحظات
- يجب مسح البيانات الموجودة (5 أدوار) قبل إعادة الإدخال لتجنب التكرار
- بعض القيم (مثل `committee_decision_types.is_approval`) تحتاج دقة في التحديد
- استخدام `INSERT ... ON CONFLICT DO NOTHING` لتجنب الأخطاء
