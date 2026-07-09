-- =========================================================================
-- workflow — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: workflow_instances trigger_audit_workflow; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_instances FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: workflow_actions trigger_audit_workflow_actions; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_actions AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_actions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: workflow_comments trigger_audit_workflow_comments; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_comments AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_comments FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: workflow_escalations trigger_audit_workflow_escalations; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_escalations AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_escalations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: workflow_events trigger_audit_workflow_events; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_events AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_events FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: workflow_history trigger_audit_workflow_history; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_history AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_history FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: workflow_schedulers trigger_audit_workflow_schedulers; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_schedulers AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_schedulers FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: workflow_sla trigger_audit_workflow_sla; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_sla AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_sla FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: workflow_states trigger_audit_workflow_states; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_states AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_states FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: workflow_tasks trigger_audit_workflow_tasks; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_tasks AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_tasks FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: workflow_transitions trigger_audit_workflow_transitions; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_transitions AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_transitions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: workflow_triggers trigger_audit_workflow_triggers; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_triggers AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_triggers FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: workflow_variables trigger_audit_workflow_variables; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_variables AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_variables FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: workflows trigger_audit_workflows; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflows AFTER INSERT OR DELETE OR UPDATE ON workflow.workflows FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: workflow_schedulers trigger_updated_at_workflow_workflow_schedulers; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_updated_at_workflow_workflow_schedulers BEFORE UPDATE ON workflow.workflow_schedulers FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: workflow_triggers trigger_updated_at_workflow_workflow_triggers; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_updated_at_workflow_workflow_triggers BEFORE UPDATE ON workflow.workflow_triggers FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--


