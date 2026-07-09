-- =========================================================================
-- integration — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: data_sync_jobs trigger_audit_data_sync_jobs; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_data_sync_jobs AFTER INSERT OR DELETE OR UPDATE ON integration.data_sync_jobs FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: event_bus_config trigger_audit_event_bus_config; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_event_bus_config AFTER INSERT OR DELETE OR UPDATE ON integration.event_bus_config FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: event_outbox trigger_audit_event_outbox; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_event_outbox AFTER INSERT OR DELETE OR UPDATE ON integration.event_outbox FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: event_subscriptions trigger_audit_event_subscriptions; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_event_subscriptions AFTER INSERT OR DELETE OR UPDATE ON integration.event_subscriptions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: external_systems trigger_audit_external_systems; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_external_systems AFTER INSERT OR DELETE OR UPDATE ON integration.external_systems FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: integration_credentials trigger_audit_integration_credentials; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_integration_credentials AFTER INSERT OR DELETE OR UPDATE ON integration.integration_credentials FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: integration_failures trigger_audit_integration_failures; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_integration_failures AFTER INSERT OR DELETE OR UPDATE ON integration.integration_failures FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: integration_logs trigger_audit_integration_logs; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_integration_logs AFTER INSERT OR DELETE OR UPDATE ON integration.integration_logs FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: retry_queue trigger_audit_retry_queue; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_retry_queue AFTER INSERT OR DELETE OR UPDATE ON integration.retry_queue FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: webhooks trigger_audit_webhooks; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_webhooks AFTER INSERT OR DELETE OR UPDATE ON integration.webhooks FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: external_systems trigger_updated_at_integration_external_systems; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_updated_at_integration_external_systems BEFORE UPDATE ON integration.external_systems FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: integration_credentials trigger_updated_at_integration_integration_credentials; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_updated_at_integration_integration_credentials BEFORE UPDATE ON integration.integration_credentials FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--


