-- =========================================================================
-- reference — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: academic_titles trigger_audit_academic_titles; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_academic_titles AFTER INSERT OR DELETE OR UPDATE ON reference.academic_titles FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: application_statuses trigger_audit_application_statuses; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_application_statuses AFTER INSERT OR DELETE OR UPDATE ON reference.application_statuses FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: committee_decision_types trigger_audit_committee_decision_types; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_committee_decision_types AFTER INSERT OR DELETE OR UPDATE ON reference.committee_decision_types FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: document_statuses trigger_audit_document_statuses; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_document_statuses AFTER INSERT OR DELETE OR UPDATE ON reference.document_statuses FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: institutions_registry trigger_audit_institutions_registry; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_institutions_registry AFTER INSERT OR DELETE OR UPDATE ON reference.institutions_registry FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: licenses_registry trigger_audit_licenses_registry; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_licenses_registry AFTER INSERT OR DELETE OR UPDATE ON reference.licenses_registry FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: lookup_categories trigger_audit_lookup_categories; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_lookup_categories AFTER INSERT OR DELETE OR UPDATE ON reference.lookup_categories FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: lookup_values trigger_audit_lookup_values; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_lookup_values AFTER INSERT OR DELETE OR UPDATE ON reference.lookup_values FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: notification_statuses trigger_audit_notification_statuses; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_notification_statuses AFTER INSERT OR DELETE OR UPDATE ON reference.notification_statuses FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: priority_levels trigger_audit_priority_levels; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_priority_levels AFTER INSERT OR DELETE OR UPDATE ON reference.priority_levels FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: professions_registry trigger_audit_professions_registry; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_professions_registry AFTER INSERT OR DELETE OR UPDATE ON reference.professions_registry FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: review_statuses trigger_audit_review_statuses; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_review_statuses AFTER INSERT OR DELETE OR UPDATE ON reference.review_statuses FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: risk_levels trigger_audit_risk_levels; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_risk_levels AFTER INSERT OR DELETE OR UPDATE ON reference.risk_levels FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: status_types trigger_audit_status_types; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_status_types AFTER INSERT OR DELETE OR UPDATE ON reference.status_types FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: vote_types trigger_audit_vote_types; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_vote_types AFTER INSERT OR DELETE OR UPDATE ON reference.vote_types FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: workflow_statuses trigger_audit_workflow_statuses; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_statuses AFTER INSERT OR DELETE OR UPDATE ON reference.workflow_statuses FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: institutions_registry trigger_updated_at_reference_institutions_registry; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_updated_at_reference_institutions_registry BEFORE UPDATE ON reference.institutions_registry FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: licenses_registry trigger_updated_at_reference_licenses_registry; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_updated_at_reference_licenses_registry BEFORE UPDATE ON reference.licenses_registry FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: professions_registry trigger_updated_at_reference_professions_registry; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_updated_at_reference_professions_registry BEFORE UPDATE ON reference.professions_registry FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--


