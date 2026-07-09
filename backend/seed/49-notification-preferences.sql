/*
 * 49-notification-preferences.sql
 * ====================================
 *
 * Phase 4 — Notification Expansion (Priority 1, Commit 2)
 *
 * إنشاء جدول تفضيلات الإشعارات لكل مستخدم.
 *
 * التغييرات:
 *   1. إنشاء جدول user_notification_preferences
 *   2. مؤشر فريد لمنع التكرار
 *   3. سياسات RLS (المستخدم يرى/يعدّل تفضيلاته فقط)
 *
 * ملاحظة: لا يتم إنشاء صفوف افتراضية عند إنشاء الجدول.
 * يتم حساب القيم الافتراضية في طبقة الخدمة (virtual defaults).
 * لا تنشأ الصفوف إلا عندما يعدّل المستخدم تفضيلاته صراحةً.
 */

-- ============================================================
-- 1. Create preferences table
-- ============================================================
CREATE TABLE IF NOT EXISTS communication.user_notification_preferences (
    id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id           BIGINT NOT NULL REFERENCES security.users(id) ON DELETE CASCADE,
    notification_type VARCHAR(100) NOT NULL,
    channel           VARCHAR(50) NOT NULL CHECK (channel IN ('IN_APP', 'EMAIL', 'SMS', 'PUSH')),
    is_enabled        BOOLEAN NOT NULL DEFAULT TRUE,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ,
    CONSTRAINT uq_user_notif_pref UNIQUE (user_id, notification_type, channel)
);

COMMENT ON TABLE communication.user_notification_preferences
  IS 'تفضيلات المستخدم لكل نوع إشعار وقناة توصيل';
COMMENT ON COLUMN communication.user_notification_preferences.user_id
  IS 'معرف المستخدم';
COMMENT ON COLUMN communication.user_notification_preferences.notification_type
  IS 'نوع الإشعار (مثل APPLICATION_APPROVED)';
COMMENT ON COLUMN communication.user_notification_preferences.channel
  IS 'قناة التوصيل (IN_APP, EMAIL, SMS, PUSH)';
COMMENT ON COLUMN communication.user_notification_preferences.is_enabled
  IS 'تفعيل الإشعار عبر هذه القناة لهذا النوع';

-- ============================================================
-- 2. RLS policies
-- ============================================================
ALTER TABLE communication.user_notification_preferences ENABLE ROW LEVEL SECURITY;

-- User: SELECT own preferences
DROP POLICY IF EXISTS pref_select ON communication.user_notification_preferences;
CREATE POLICY pref_select ON communication.user_notification_preferences FOR SELECT
  USING (user_id = communication.fn_current_user_id());

-- User: INSERT own preferences
DROP POLICY IF EXISTS pref_insert ON communication.user_notification_preferences;
CREATE POLICY pref_insert ON communication.user_notification_preferences FOR INSERT
  WITH CHECK (user_id = communication.fn_current_user_id());

-- User: UPDATE own preferences
DROP POLICY IF EXISTS pref_update ON communication.user_notification_preferences;
CREATE POLICY pref_update ON communication.user_notification_preferences FOR UPDATE
  USING (user_id = communication.fn_current_user_id())
  WITH CHECK (user_id = communication.fn_current_user_id());

-- User: DELETE own preferences (reset to virtual defaults)
DROP POLICY IF EXISTS pref_delete ON communication.user_notification_preferences;
CREATE POLICY pref_delete ON communication.user_notification_preferences FOR DELETE
  USING (user_id = communication.fn_current_user_id());

-- Admin: SELECT all preferences
DROP POLICY IF EXISTS pref_admin_select ON communication.user_notification_preferences;
CREATE POLICY pref_admin_select ON communication.user_notification_preferences FOR SELECT
  USING (system.fn_is_admin(communication.fn_current_user_id()));

-- Admin: INSERT for any user
DROP POLICY IF EXISTS pref_admin_insert ON communication.user_notification_preferences;
CREATE POLICY pref_admin_insert ON communication.user_notification_preferences FOR INSERT
  WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));

-- Admin: UPDATE any preference
DROP POLICY IF EXISTS pref_admin_update ON communication.user_notification_preferences;
CREATE POLICY pref_admin_update ON communication.user_notification_preferences FOR UPDATE
  USING (system.fn_is_admin(communication.fn_current_user_id()))
  WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));

-- Admin: DELETE any preference
DROP POLICY IF EXISTS pref_admin_delete ON communication.user_notification_preferences;
CREATE POLICY pref_admin_delete ON communication.user_notification_preferences FOR DELETE
  USING (system.fn_is_admin(communication.fn_current_user_id()));
