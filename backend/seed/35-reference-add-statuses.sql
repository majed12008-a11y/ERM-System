-- ============================================================
-- 35-REFERENCE-ADD-STATUSES
-- ============================================================
-- إضافة حالات جديدة إلى reference.application_statuses
-- التي تتطلبها بنية سير العمل الموسعة (15 حالة).
--
-- الحالات المضافة:
--   AWAITING_CONDITIONS    — بانتظار الشروط، الباحث يرفع الأدلة
--   EVIDENCE_REJECTED      — الأدلة مرفوضة، الباحث يعيد التقديم
--   ARCHIVED               — أرشفة نهائية بعد انتهاء فترة الاحتفاظ
--
-- WITHDRAWN و CLOSED موجودتان مسبقاً من seed 01-reference.sql.
-- ============================================================

BEGIN;

-- إضافة حالة "بانتظار الشروط" (غير نهائية)
INSERT INTO reference.application_statuses (status_code, status_name_ar, status_name_en, display_order, is_terminal)
SELECT 'AWAITING_CONDITIONS', 'بانتظار الشروط', 'Awaiting Conditions', 12, false
WHERE NOT EXISTS (
    SELECT 1 FROM reference.application_statuses WHERE status_code = 'AWAITING_CONDITIONS'
);

-- إضافة حالة "الأدلة مرفوضة" (غير نهائية — يمكن إعادة تقديم الأدلة)
INSERT INTO reference.application_statuses (status_code, status_name_ar, status_name_en, display_order, is_terminal)
SELECT 'EVIDENCE_REJECTED', 'الأدلة مرفوضة', 'Evidence Rejected', 13, false
WHERE NOT EXISTS (
    SELECT 1 FROM reference.application_statuses WHERE status_code = 'EVIDENCE_REJECTED'
);

-- إضافة حالة "مؤرشف" (نهائية)
INSERT INTO reference.application_statuses (status_code, status_name_ar, status_name_en, display_order, is_terminal)
SELECT 'ARCHIVED', 'مؤرشف', 'Archived', 14, true
WHERE NOT EXISTS (
    SELECT 1 FROM reference.application_statuses WHERE status_code = 'ARCHIVED'
);

COMMIT;
