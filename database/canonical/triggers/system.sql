-- =========================================================================
-- system — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: business_rules trigger_audit_business_rules; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_business_rules AFTER INSERT OR DELETE OR UPDATE ON system.business_rules FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: email_config trigger_audit_email_config; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_email_config AFTER INSERT OR DELETE OR UPDATE ON system.email_config FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: feature_flags trigger_audit_feature_flags; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_feature_flags AFTER INSERT OR DELETE OR UPDATE ON system.feature_flags FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: maintenance_log trigger_audit_maintenance_log; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_maintenance_log AFTER INSERT OR DELETE OR UPDATE ON system.maintenance_log FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: rule_actions trigger_audit_rule_actions; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_rule_actions AFTER INSERT OR DELETE OR UPDATE ON system.rule_actions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: rule_conditions trigger_audit_rule_conditions; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_rule_conditions AFTER INSERT OR DELETE OR UPDATE ON system.rule_conditions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: rule_executions trigger_audit_rule_executions; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_rule_executions AFTER INSERT OR DELETE OR UPDATE ON system.rule_executions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: rule_versions trigger_audit_rule_versions; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_rule_versions AFTER INSERT OR DELETE OR UPDATE ON system.rule_versions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: saved_searches trigger_audit_saved_searches; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_saved_searches AFTER INSERT OR DELETE OR UPDATE ON system.saved_searches FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: sms_config trigger_audit_sms_config; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_sms_config AFTER INSERT OR DELETE OR UPDATE ON system.sms_config FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: system_config trigger_audit_system_config; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_system_config AFTER INSERT OR DELETE OR UPDATE ON system.system_config FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: system_config trigger_updated_at; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON system.system_config FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: saved_searches trigger_updated_at_system_saved_searches; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_updated_at_system_saved_searches BEFORE UPDATE ON system.saved_searches FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: search_indexes trigger_updated_at_system_search_indexes; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_updated_at_system_search_indexes BEFORE UPDATE ON system.search_indexes FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--


