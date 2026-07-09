-- =========================================================================
-- core — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: amendment_requests trigger_audit_amendment_requests; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_amendment_requests AFTER INSERT OR DELETE OR UPDATE ON core.amendment_requests FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: application_amendments trigger_audit_application_amendments; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_application_amendments AFTER INSERT OR DELETE OR UPDATE ON core.application_amendments FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: application_checklists trigger_audit_application_checklists; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_application_checklists AFTER INSERT OR DELETE OR UPDATE ON core.application_checklists FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: application_consents trigger_audit_application_consents; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_application_consents AFTER INSERT OR DELETE OR UPDATE ON core.application_consents FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: application_history trigger_audit_application_history; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_application_history AFTER INSERT OR DELETE OR UPDATE ON core.application_history FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: application_sections trigger_audit_application_sections; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_application_sections AFTER INSERT OR DELETE OR UPDATE ON core.application_sections FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: application_validations trigger_audit_application_validations; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_application_validations AFTER INSERT OR DELETE OR UPDATE ON core.application_validations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: application_versions trigger_audit_application_versions; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_application_versions AFTER INSERT OR DELETE OR UPDATE ON core.application_versions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: applications trigger_audit_applications; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_applications AFTER INSERT OR DELETE OR UPDATE ON core.applications FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: closure_requests trigger_audit_closure_requests; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_closure_requests AFTER INSERT OR DELETE OR UPDATE ON core.closure_requests FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: project_attachments trigger_audit_project_attachments; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_attachments AFTER INSERT OR DELETE OR UPDATE ON core.project_attachments FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: project_funding_sources trigger_audit_project_funding_sources; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_funding_sources AFTER INSERT OR DELETE OR UPDATE ON core.project_funding_sources FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: project_keywords trigger_audit_project_keywords; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_keywords AFTER INSERT OR DELETE OR UPDATE ON core.project_keywords FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: project_site_investigators trigger_audit_project_site_investigators; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_site_investigators AFTER INSERT OR DELETE OR UPDATE ON core.project_site_investigators FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: project_sites trigger_audit_project_sites; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_sites AFTER INSERT OR DELETE OR UPDATE ON core.project_sites FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: project_status_history trigger_audit_project_status_history; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_status_history AFTER INSERT OR DELETE OR UPDATE ON core.project_status_history FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: project_tags trigger_audit_project_tags; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_tags AFTER INSERT OR DELETE OR UPDATE ON core.project_tags FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: project_team_members trigger_audit_project_team_members; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_team_members AFTER INSERT OR DELETE OR UPDATE ON core.project_team_members FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: project_versions trigger_audit_project_versions; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_versions AFTER INSERT OR DELETE OR UPDATE ON core.project_versions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: projects trigger_audit_projects; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_projects AFTER INSERT OR DELETE OR UPDATE ON core.projects FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: renewal_requests trigger_audit_renewal_requests; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_renewal_requests AFTER INSERT OR DELETE OR UPDATE ON core.renewal_requests FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: research_categories trigger_audit_research_categories; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_research_categories AFTER INSERT OR DELETE OR UPDATE ON core.research_categories FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: research_population_links trigger_audit_research_population_links; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_research_population_links AFTER INSERT OR DELETE OR UPDATE ON core.research_population_links FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: risk_classifications trigger_audit_risk_classifications; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_risk_classifications AFTER INSERT OR DELETE OR UPDATE ON core.risk_classifications FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: vulnerable_populations trigger_audit_vulnerable_populations; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_vulnerable_populations AFTER INSERT OR DELETE OR UPDATE ON core.vulnerable_populations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: applications trigger_notification_applications; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_notification_applications AFTER UPDATE ON core.applications FOR EACH ROW EXECUTE FUNCTION system.fn_notify_status_change();


--

-- Name: applications trigger_updated_at; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON core.applications FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: projects trigger_updated_at; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON core.projects FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: research_categories trigger_updated_at_core_research_categories; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_updated_at_core_research_categories BEFORE UPDATE ON core.research_categories FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: risk_classifications trigger_updated_at_core_risk_classifications; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_updated_at_core_risk_classifications BEFORE UPDATE ON core.risk_classifications FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: vulnerable_populations trigger_updated_at_core_vulnerable_populations; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_updated_at_core_vulnerable_populations BEFORE UPDATE ON core.vulnerable_populations FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: applications trigger_versioning_applications; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_versioning_applications AFTER UPDATE ON core.applications FOR EACH ROW EXECUTE FUNCTION system.fn_create_snapshot();


--

-- Name: projects trigger_versioning_projects; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_versioning_projects AFTER UPDATE ON core.projects FOR EACH ROW EXECUTE FUNCTION system.fn_create_snapshot();


--


