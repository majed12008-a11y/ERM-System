-- RLS Policies for communication schema
-- Run: psql -U postgres -d ethics_db -f backend/seed/16-rls-communication.sql
-- سياسات RLS للمراسلات والمرفقات والإشعارات.
-- تضمن عزل المراسلات بين المستخدمين حسب الصلاحيات.

BEGIN;

-- Helper: current user ID (0 = unauthenticated, NULL if not set)
CREATE OR REPLACE FUNCTION communication.fn_current_user_id()
RETURNS BIGINT
LANGUAGE sql STABLE
AS $$ SELECT (current_setting('app.user_id', true))::BIGINT; $$;

-- ============================================================
-- 1. communication.notifications
-- ============================================================
ALTER TABLE communication.notifications ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS notifications_select ON communication.notifications;
CREATE POLICY notifications_select ON communication.notifications FOR SELECT
  USING (
    user_id = communication.fn_current_user_id()
    OR system.fn_is_admin(communication.fn_current_user_id())
  );

DROP POLICY IF EXISTS notifications_insert ON communication.notifications;
CREATE POLICY notifications_insert ON communication.notifications FOR INSERT
  WITH CHECK (
    -- Any authenticated user can trigger notifications (service layer controls who/what)
    (communication.fn_current_user_id() > 0)
    OR system.fn_is_admin(communication.fn_current_user_id())
  );

DROP POLICY IF EXISTS notifications_update ON communication.notifications;
CREATE POLICY notifications_update ON communication.notifications FOR UPDATE
  USING (user_id = communication.fn_current_user_id())
  WITH CHECK (user_id = communication.fn_current_user_id());

DROP POLICY IF EXISTS notifications_delete ON communication.notifications;
CREATE POLICY notifications_delete ON communication.notifications FOR DELETE
  USING (system.fn_is_admin(communication.fn_current_user_id()));

-- ============================================================
-- 2. communication.messages
-- ============================================================
ALTER TABLE communication.messages ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS messages_select ON communication.messages;
CREATE POLICY messages_select ON communication.messages FOR SELECT
  USING (
    sender_id = communication.fn_current_user_id()
    OR EXISTS (SELECT 1 FROM communication.message_recipients mr WHERE mr.message_id = messages.id AND mr.recipient_id = communication.fn_current_user_id())
    OR system.fn_is_admin(communication.fn_current_user_id())
  );

DROP POLICY IF EXISTS messages_insert ON communication.messages;
CREATE POLICY messages_insert ON communication.messages FOR INSERT
  WITH CHECK (sender_id = communication.fn_current_user_id());

DROP POLICY IF EXISTS messages_update ON communication.messages;
CREATE POLICY messages_update ON communication.messages FOR UPDATE
  USING (sender_id = communication.fn_current_user_id())
  WITH CHECK (sender_id = communication.fn_current_user_id());

DROP POLICY IF EXISTS messages_delete ON communication.messages;
CREATE POLICY messages_delete ON communication.messages FOR DELETE
  USING (system.fn_is_admin(communication.fn_current_user_id()));

-- ============================================================
-- 3. communication.message_recipients
-- ============================================================
ALTER TABLE communication.message_recipients ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS message_recipients_select ON communication.message_recipients;
CREATE POLICY message_recipients_select ON communication.message_recipients FOR SELECT
  USING (
    recipient_id = communication.fn_current_user_id()
    OR system.fn_is_admin(communication.fn_current_user_id())
  );

DROP POLICY IF EXISTS message_recipients_insert ON communication.message_recipients;
CREATE POLICY message_recipients_insert ON communication.message_recipients FOR INSERT
  WITH CHECK (
    EXISTS (SELECT 1 FROM communication.messages m WHERE m.id = message_id AND m.sender_id = communication.fn_current_user_id())
    OR system.fn_is_admin(communication.fn_current_user_id())
  );

DROP POLICY IF EXISTS message_recipients_update ON communication.message_recipients;
CREATE POLICY message_recipients_update ON communication.message_recipients FOR UPDATE
  USING (recipient_id = communication.fn_current_user_id())
  WITH CHECK (recipient_id = communication.fn_current_user_id());

DROP POLICY IF EXISTS message_recipients_delete ON communication.message_recipients;
CREATE POLICY message_recipients_delete ON communication.message_recipients FOR DELETE
  USING (system.fn_is_admin(communication.fn_current_user_id()));

-- ============================================================
-- 4. communication.message_attachments
-- ============================================================
ALTER TABLE communication.message_attachments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS message_attachments_select ON communication.message_attachments;
CREATE POLICY message_attachments_select ON communication.message_attachments FOR SELECT
  USING (
    EXISTS (SELECT 1 FROM communication.messages m WHERE m.id = message_id AND m.sender_id = communication.fn_current_user_id())
    OR EXISTS (SELECT 1 FROM communication.message_recipients mr WHERE mr.message_id = message_id AND mr.recipient_id = communication.fn_current_user_id())
    OR system.fn_is_admin(communication.fn_current_user_id())
  );

DROP POLICY IF EXISTS message_attachments_insert ON communication.message_attachments;
CREATE POLICY message_attachments_insert ON communication.message_attachments FOR INSERT
  WITH CHECK (
    EXISTS (SELECT 1 FROM communication.messages m WHERE m.id = message_id AND m.sender_id = communication.fn_current_user_id())
    OR system.fn_is_admin(communication.fn_current_user_id())
  );

DROP POLICY IF EXISTS message_attachments_update ON communication.message_attachments;
CREATE POLICY message_attachments_update ON communication.message_attachments FOR UPDATE
  USING (system.fn_is_admin(communication.fn_current_user_id()))
  WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));

DROP POLICY IF EXISTS message_attachments_delete ON communication.message_attachments;
CREATE POLICY message_attachments_delete ON communication.message_attachments FOR DELETE
  USING (system.fn_is_admin(communication.fn_current_user_id()));

-- ============================================================
-- 5. communication.announcements
-- ============================================================
ALTER TABLE communication.announcements ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS announcements_select ON communication.announcements;
CREATE POLICY announcements_select ON communication.announcements FOR SELECT
  USING (
    is_active = true
    OR system.fn_is_admin(communication.fn_current_user_id())
  );

DROP POLICY IF EXISTS announcements_insert ON communication.announcements;
CREATE POLICY announcements_insert ON communication.announcements FOR INSERT
  WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));

DROP POLICY IF EXISTS announcements_update ON communication.announcements;
CREATE POLICY announcements_update ON communication.announcements FOR UPDATE
  USING (system.fn_is_admin(communication.fn_current_user_id()))
  WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));

DROP POLICY IF EXISTS announcements_delete ON communication.announcements;
CREATE POLICY announcements_delete ON communication.announcements FOR DELETE
  USING (system.fn_is_admin(communication.fn_current_user_id()));

-- ============================================================
-- 6. communication.notification_channels (reference data)
-- ============================================================
ALTER TABLE communication.notification_channels ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS notification_channels_select ON communication.notification_channels;
CREATE POLICY notification_channels_select ON communication.notification_channels FOR SELECT
  USING (
    is_active = true
    OR system.fn_is_admin(communication.fn_current_user_id())
  );

DROP POLICY IF EXISTS notification_channels_insert ON communication.notification_channels;
CREATE POLICY notification_channels_insert ON communication.notification_channels FOR INSERT
  WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));

DROP POLICY IF EXISTS notification_channels_update ON communication.notification_channels;
CREATE POLICY notification_channels_update ON communication.notification_channels FOR UPDATE
  USING (system.fn_is_admin(communication.fn_current_user_id()))
  WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));

DROP POLICY IF EXISTS notification_channels_delete ON communication.notification_channels;
CREATE POLICY notification_channels_delete ON communication.notification_channels FOR DELETE
  USING (system.fn_is_admin(communication.fn_current_user_id()));

-- ============================================================
-- 7. communication.notification_templates (reference data)
-- ============================================================
ALTER TABLE communication.notification_templates ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS notification_templates_select ON communication.notification_templates;
CREATE POLICY notification_templates_select ON communication.notification_templates FOR SELECT
  USING (
    is_active = true
    OR system.fn_is_admin(communication.fn_current_user_id())
  );

DROP POLICY IF EXISTS notification_templates_insert ON communication.notification_templates;
CREATE POLICY notification_templates_insert ON communication.notification_templates FOR INSERT
  WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));

DROP POLICY IF EXISTS notification_templates_update ON communication.notification_templates;
CREATE POLICY notification_templates_update ON communication.notification_templates FOR UPDATE
  USING (system.fn_is_admin(communication.fn_current_user_id()))
  WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));

DROP POLICY IF EXISTS notification_templates_delete ON communication.notification_templates;
CREATE POLICY notification_templates_delete ON communication.notification_templates FOR DELETE
  USING (system.fn_is_admin(communication.fn_current_user_id()));

-- ============================================================
-- 8. communication.notification_logs (admin-only)
-- ============================================================
ALTER TABLE communication.notification_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS notification_logs_select ON communication.notification_logs;
CREATE POLICY notification_logs_select ON communication.notification_logs FOR SELECT
  USING (system.fn_is_admin(communication.fn_current_user_id()));

DROP POLICY IF EXISTS notification_logs_insert ON communication.notification_logs;
CREATE POLICY notification_logs_insert ON communication.notification_logs FOR INSERT
  WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));

DROP POLICY IF EXISTS notification_logs_update ON communication.notification_logs;
CREATE POLICY notification_logs_update ON communication.notification_logs FOR UPDATE
  USING (system.fn_is_admin(communication.fn_current_user_id()))
  WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));

DROP POLICY IF EXISTS notification_logs_delete ON communication.notification_logs;
CREATE POLICY notification_logs_delete ON communication.notification_logs FOR DELETE
  USING (system.fn_is_admin(communication.fn_current_user_id()));

COMMIT;
