/*
 * 50-notification-logs-rls-fix.sql
 * ====================================
 *
 * Phase 4 — Notification Expansion (Priority 1, Commit 3)
 *
 * إصلاح سياسة INSERT لجدول سجلات التوصيل للسماح
 * للتطبيق بإدراج سجلات التوصيل حتى في السياقات غير
 * المرتبطة بطلب HTTP (المهام الخلفية، المجدول، إلخ).
 *
 * المشكلة الأصلية:
 *   CREATE POLICY notification_logs_insert ... WITH CHECK (
 *     system.fn_is_admin(communication.fn_current_user_id())
 *   );
 *
 *   كانت تسمح فقط للمستخدمين الإداريين بإدراج سجلات.
 *   هذا يمنع المهام الخلفية (حيث app.user_id = 0)
 *   والمستخدمين العاديين من تسجيل حالة التوصيل.
 *
 * الإصلاح:
 *   - system.fn_is_admin(...) → السماح للمسؤول
 *   - fn_current_user_id() > 0 → السماح للمستخدمين العاديين
 *   - current_user = 'ethics_app' → السماح للتطبيق في المهام الخلفية
 *
 * التغييرات:
 *   1. استبدال سياسة INSERT
 *   2. إضافة سياسة تنظيف يدوي (اختياري)
 */

-- ============================================================
-- 1. Fix INSERT policy
-- ============================================================
DROP POLICY IF EXISTS notification_logs_insert ON communication.notification_logs;
CREATE POLICY notification_logs_insert ON communication.notification_logs FOR INSERT
  WITH CHECK (
    -- Admin users: can always log deliveries
    system.fn_is_admin(communication.fn_current_user_id())
    OR
    -- Authenticated users: any request with valid user context
    communication.fn_current_user_id() > 0
    OR
    -- Background jobs: backend runs as this user without request context
    current_user = 'ethics_app'
  );

COMMENT ON POLICY notification_logs_insert ON communication.notification_logs
  IS 'يسمح للمسؤولين والمستخدمين والتطبيق بإدراج سجلات التوصيل';

-- ============================================================
-- 2. Manual cleanup query (info-only — no automated job)
-- ============================================================
-- لحذف سجلات التوصيل الأقدم من 90 يوماً:
--   DELETE FROM communication.notification_logs
--   WHERE logged_at < NOW() - INTERVAL '90 days';
--
-- لحذف سجلات التوصيل الأقدم من 365 يوماً:
--   DELETE FROM communication.notification_logs
--   WHERE logged_at < NOW() - INTERVAL '365 days';
