-- =========================================================================
-- monitoring — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: compliance_reviews trigger_audit_compliance_reviews; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_compliance_reviews AFTER INSERT OR DELETE OR UPDATE ON monitoring.compliance_reviews FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: corrective_actions trigger_audit_corrective_actions; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_corrective_actions AFTER INSERT OR DELETE OR UPDATE ON monitoring.corrective_actions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: deviations trigger_audit_deviations; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_deviations AFTER INSERT OR DELETE OR UPDATE ON monitoring.deviations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: inspection_reports trigger_audit_inspection_reports; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_inspection_reports AFTER INSERT OR DELETE OR UPDATE ON monitoring.inspection_reports FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: inspections trigger_audit_inspections; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_inspections AFTER INSERT OR DELETE OR UPDATE ON monitoring.inspections FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: monitoring_findings trigger_audit_monitoring_findings; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_monitoring_findings AFTER INSERT OR DELETE OR UPDATE ON monitoring.monitoring_findings FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: monitoring_plans trigger_audit_monitoring_plans; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_monitoring_plans AFTER INSERT OR DELETE OR UPDATE ON monitoring.monitoring_plans FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: monitoring_visits trigger_audit_monitoring_visits; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_monitoring_visits AFTER INSERT OR DELETE OR UPDATE ON monitoring.monitoring_visits FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: preventive_actions trigger_audit_preventive_actions; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_preventive_actions AFTER INSERT OR DELETE OR UPDATE ON monitoring.preventive_actions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: protocol_violations trigger_audit_protocol_violations; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_protocol_violations AFTER INSERT OR DELETE OR UPDATE ON monitoring.protocol_violations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--


