-- =========================================================================
-- reporting — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: analytics_snapshots trigger_audit_analytics_snapshots; Type: TRIGGER; Schema: reporting; Owner: -
--

CREATE TRIGGER trigger_audit_analytics_snapshots AFTER INSERT OR DELETE OR UPDATE ON reporting.analytics_snapshots FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: dashboard_widgets trigger_audit_dashboard_widgets; Type: TRIGGER; Schema: reporting; Owner: -
--

CREATE TRIGGER trigger_audit_dashboard_widgets AFTER INSERT OR DELETE OR UPDATE ON reporting.dashboard_widgets FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: kpi_results trigger_audit_kpi_results; Type: TRIGGER; Schema: reporting; Owner: -
--

CREATE TRIGGER trigger_audit_kpi_results AFTER INSERT OR DELETE OR UPDATE ON reporting.kpi_results FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: report_definitions trigger_audit_report_definitions; Type: TRIGGER; Schema: reporting; Owner: -
--

CREATE TRIGGER trigger_audit_report_definitions AFTER INSERT OR DELETE OR UPDATE ON reporting.report_definitions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: report_executions trigger_audit_report_executions; Type: TRIGGER; Schema: reporting; Owner: -
--

CREATE TRIGGER trigger_audit_report_executions AFTER INSERT OR DELETE OR UPDATE ON reporting.report_executions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--


