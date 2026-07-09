-- =========================================================================
-- communication — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: announcements announcements_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY announcements_delete ON communication.announcements FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: announcements announcements_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY announcements_insert ON communication.announcements FOR INSERT WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: announcements announcements_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY announcements_select ON communication.announcements FOR SELECT USING (((is_active = true) OR system.fn_is_admin(communication.fn_current_user_id())));


--

-- Name: announcements announcements_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY announcements_update ON communication.announcements FOR UPDATE USING (system.fn_is_admin(communication.fn_current_user_id())) WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: message_attachments message_attachments_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY message_attachments_delete ON communication.message_attachments FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: message_attachments message_attachments_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY message_attachments_insert ON communication.message_attachments FOR INSERT WITH CHECK (((EXISTS ( SELECT 1
   FROM communication.messages m
  WHERE ((m.id = message_attachments.message_id) AND (m.sender_id = communication.fn_current_user_id())))) OR system.fn_is_admin(communication.fn_current_user_id())));


--

-- Name: message_attachments message_attachments_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY message_attachments_select ON communication.message_attachments FOR SELECT USING (((EXISTS ( SELECT 1
   FROM communication.messages m
  WHERE ((m.id = message_attachments.message_id) AND (m.sender_id = communication.fn_current_user_id())))) OR (EXISTS ( SELECT 1
   FROM communication.message_recipients mr
  WHERE ((mr.message_id = mr.message_id) AND (mr.recipient_id = communication.fn_current_user_id())))) OR system.fn_is_admin(communication.fn_current_user_id())));


--

-- Name: message_attachments message_attachments_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY message_attachments_update ON communication.message_attachments FOR UPDATE USING (system.fn_is_admin(communication.fn_current_user_id())) WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: message_recipients message_recipients_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY message_recipients_delete ON communication.message_recipients FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: message_recipients message_recipients_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY message_recipients_insert ON communication.message_recipients FOR INSERT WITH CHECK (((EXISTS ( SELECT 1
   FROM communication.messages m
  WHERE ((m.id = message_recipients.message_id) AND (m.sender_id = communication.fn_current_user_id())))) OR system.fn_is_admin(communication.fn_current_user_id())));


--

-- Name: message_recipients message_recipients_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY message_recipients_select ON communication.message_recipients FOR SELECT USING (((recipient_id = communication.fn_current_user_id()) OR system.fn_is_admin(communication.fn_current_user_id())));


--

-- Name: message_recipients message_recipients_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY message_recipients_update ON communication.message_recipients FOR UPDATE USING ((recipient_id = communication.fn_current_user_id())) WITH CHECK ((recipient_id = communication.fn_current_user_id()));


--

-- Name: messages messages_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY messages_delete ON communication.messages FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: messages messages_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY messages_insert ON communication.messages FOR INSERT WITH CHECK ((sender_id = communication.fn_current_user_id()));


--

-- Name: messages messages_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY messages_select ON communication.messages FOR SELECT USING (((sender_id = communication.fn_current_user_id()) OR (EXISTS ( SELECT 1
   FROM communication.message_recipients mr
  WHERE ((mr.message_id = messages.id) AND (mr.recipient_id = communication.fn_current_user_id())))) OR system.fn_is_admin(communication.fn_current_user_id())));


--

-- Name: messages messages_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY messages_update ON communication.messages FOR UPDATE USING ((sender_id = communication.fn_current_user_id())) WITH CHECK ((sender_id = communication.fn_current_user_id()));


--

-- Name: notification_channels notification_channels_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_channels_delete ON communication.notification_channels FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: notification_channels notification_channels_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_channels_insert ON communication.notification_channels FOR INSERT WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: notification_channels notification_channels_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_channels_select ON communication.notification_channels FOR SELECT USING (((is_active = true) OR system.fn_is_admin(communication.fn_current_user_id())));


--

-- Name: notification_channels notification_channels_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_channels_update ON communication.notification_channels FOR UPDATE USING (system.fn_is_admin(communication.fn_current_user_id())) WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: notification_logs notification_logs_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_logs_delete ON communication.notification_logs FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: notification_logs notification_logs_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_logs_insert ON communication.notification_logs FOR INSERT WITH CHECK ((system.fn_is_admin(communication.fn_current_user_id()) OR (communication.fn_current_user_id() > 0) OR (CURRENT_USER = 'ethics_app'::name)));


--

-- Name: notification_logs notification_logs_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_logs_select ON communication.notification_logs FOR SELECT USING (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: notification_logs notification_logs_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_logs_update ON communication.notification_logs FOR UPDATE USING (system.fn_is_admin(communication.fn_current_user_id())) WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: notification_templates notification_templates_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_templates_delete ON communication.notification_templates FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: notification_templates notification_templates_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_templates_insert ON communication.notification_templates FOR INSERT WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: notification_templates notification_templates_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_templates_select ON communication.notification_templates FOR SELECT USING (((is_active = true) OR system.fn_is_admin(communication.fn_current_user_id())));


--

-- Name: notification_templates notification_templates_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_templates_update ON communication.notification_templates FOR UPDATE USING (system.fn_is_admin(communication.fn_current_user_id())) WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: notifications notifications_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notifications_delete ON communication.notifications FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: notifications notifications_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notifications_insert ON communication.notifications FOR INSERT WITH CHECK (((communication.fn_current_user_id() > 0) OR system.fn_is_admin(communication.fn_current_user_id())));


--

-- Name: notifications notifications_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notifications_select ON communication.notifications FOR SELECT USING (((user_id = communication.fn_current_user_id()) OR system.fn_is_admin(communication.fn_current_user_id())));


--

-- Name: notifications notifications_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notifications_update ON communication.notifications FOR UPDATE USING ((user_id = communication.fn_current_user_id())) WITH CHECK ((user_id = communication.fn_current_user_id()));


--

-- Name: user_notification_preferences pref_admin_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY pref_admin_delete ON communication.user_notification_preferences FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: user_notification_preferences pref_admin_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY pref_admin_insert ON communication.user_notification_preferences FOR INSERT WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: user_notification_preferences pref_admin_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY pref_admin_select ON communication.user_notification_preferences FOR SELECT USING (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: user_notification_preferences pref_admin_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY pref_admin_update ON communication.user_notification_preferences FOR UPDATE USING (system.fn_is_admin(communication.fn_current_user_id())) WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: user_notification_preferences pref_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY pref_delete ON communication.user_notification_preferences FOR DELETE USING ((user_id = communication.fn_current_user_id()));


--

-- Name: user_notification_preferences pref_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY pref_insert ON communication.user_notification_preferences FOR INSERT WITH CHECK ((user_id = communication.fn_current_user_id()));


--

-- Name: user_notification_preferences pref_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY pref_select ON communication.user_notification_preferences FOR SELECT USING ((user_id = communication.fn_current_user_id()));


--

-- Name: user_notification_preferences pref_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY pref_update ON communication.user_notification_preferences FOR UPDATE USING ((user_id = communication.fn_current_user_id())) WITH CHECK ((user_id = communication.fn_current_user_id()));


--


-- =========================================================================
-- communication — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: announcements; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.announcements ENABLE ROW LEVEL SECURITY;

--

-- Name: message_attachments; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.message_attachments ENABLE ROW LEVEL SECURITY;

--

-- Name: message_recipients; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.message_recipients ENABLE ROW LEVEL SECURITY;

--

-- Name: messages; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.messages ENABLE ROW LEVEL SECURITY;

--

-- Name: notification_channels; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.notification_channels ENABLE ROW LEVEL SECURITY;

--

-- Name: notification_logs; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.notification_logs ENABLE ROW LEVEL SECURITY;

--

-- Name: notification_templates; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.notification_templates ENABLE ROW LEVEL SECURITY;

--

-- Name: notifications; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.notifications ENABLE ROW LEVEL SECURITY;

--

-- Name: user_notification_preferences; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.user_notification_preferences ENABLE ROW LEVEL SECURITY;

--


