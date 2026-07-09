-- =========================================================================
-- communication — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: announcements trigger_audit_announcements; Type: TRIGGER; Schema: communication; Owner: -
--

CREATE TRIGGER trigger_audit_announcements AFTER INSERT OR DELETE OR UPDATE ON communication.announcements FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: message_attachments trigger_audit_message_attachments; Type: TRIGGER; Schema: communication; Owner: -
--

CREATE TRIGGER trigger_audit_message_attachments AFTER INSERT OR DELETE OR UPDATE ON communication.message_attachments FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: message_recipients trigger_audit_message_recipients; Type: TRIGGER; Schema: communication; Owner: -
--

CREATE TRIGGER trigger_audit_message_recipients AFTER INSERT OR DELETE OR UPDATE ON communication.message_recipients FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: messages trigger_audit_messages; Type: TRIGGER; Schema: communication; Owner: -
--

CREATE TRIGGER trigger_audit_messages AFTER INSERT OR DELETE OR UPDATE ON communication.messages FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: notification_channels trigger_audit_notification_channels; Type: TRIGGER; Schema: communication; Owner: -
--

CREATE TRIGGER trigger_audit_notification_channels AFTER INSERT OR DELETE OR UPDATE ON communication.notification_channels FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: notification_logs trigger_audit_notification_logs; Type: TRIGGER; Schema: communication; Owner: -
--

CREATE TRIGGER trigger_audit_notification_logs AFTER INSERT OR DELETE OR UPDATE ON communication.notification_logs FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: notification_templates trigger_audit_notification_templates; Type: TRIGGER; Schema: communication; Owner: -
--

CREATE TRIGGER trigger_audit_notification_templates AFTER INSERT OR DELETE OR UPDATE ON communication.notification_templates FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: notifications trigger_audit_notifications; Type: TRIGGER; Schema: communication; Owner: -
--

CREATE TRIGGER trigger_audit_notifications AFTER INSERT OR DELETE OR UPDATE ON communication.notifications FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--


