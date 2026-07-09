-- =========================================================================
-- safety — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: adverse_events trigger_audit_adverse_events; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_adverse_events AFTER INSERT OR DELETE OR UPDATE ON safety.adverse_events FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: corrective_actions trigger_audit_corrective_actions; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_corrective_actions AFTER INSERT OR DELETE OR UPDATE ON safety.corrective_actions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: mitigation_actions trigger_audit_mitigation_actions; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_mitigation_actions AFTER INSERT OR DELETE OR UPDATE ON safety.mitigation_actions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: risk_assessments trigger_audit_risk_assessments; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_risk_assessments AFTER INSERT OR DELETE OR UPDATE ON safety.risk_assessments FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: risk_categories trigger_audit_risk_categories; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_risk_categories AFTER INSERT OR DELETE OR UPDATE ON safety.risk_categories FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: risk_incidents trigger_audit_risk_incidents; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_risk_incidents AFTER INSERT OR DELETE OR UPDATE ON safety.risk_incidents FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: risk_mitigations trigger_audit_risk_mitigations; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_risk_mitigations AFTER INSERT OR DELETE OR UPDATE ON safety.risk_mitigations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: risk_register trigger_audit_risk_register; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_risk_register AFTER INSERT OR DELETE OR UPDATE ON safety.risk_register FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: safety_committee_reviews trigger_audit_safety_committee_reviews; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_safety_committee_reviews AFTER INSERT OR DELETE OR UPDATE ON safety.safety_committee_reviews FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: safety_followups trigger_audit_safety_followups; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_safety_followups AFTER INSERT OR DELETE OR UPDATE ON safety.safety_followups FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: safety_reports trigger_audit_safety_reports; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_safety_reports AFTER INSERT OR DELETE OR UPDATE ON safety.safety_reports FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: serious_adverse_events trigger_audit_serious_adverse_events; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_serious_adverse_events AFTER INSERT OR DELETE OR UPDATE ON safety.serious_adverse_events FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: corrective_actions trigger_updated_at_safety_corrective_actions; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_updated_at_safety_corrective_actions BEFORE UPDATE ON safety.corrective_actions FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: risk_incidents trigger_updated_at_safety_risk_incidents; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_updated_at_safety_risk_incidents BEFORE UPDATE ON safety.risk_incidents FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: risk_mitigations trigger_updated_at_safety_risk_mitigations; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_updated_at_safety_risk_mitigations BEFORE UPDATE ON safety.risk_mitigations FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: risk_register trigger_updated_at_safety_risk_register; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_updated_at_safety_risk_register BEFORE UPDATE ON safety.risk_register FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--


