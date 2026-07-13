-- =========================================================================
-- templates — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: trg_audit_categories; Type: TRIGGER; Schema: templates; Owner: -
--

CREATE TRIGGER trg_audit_categories AFTER INSERT OR DELETE OR UPDATE ON templates.categories FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

CREATE TRIGGER trg_audit_templates AFTER INSERT OR DELETE OR UPDATE ON templates.templates FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_versions AFTER INSERT OR DELETE OR UPDATE ON templates.template_versions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_localizations AFTER INSERT OR DELETE OR UPDATE ON templates.template_localizations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_variables AFTER INSERT OR DELETE OR UPDATE ON templates.template_variables FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_partials AFTER INSERT OR DELETE OR UPDATE ON templates.template_partials FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_packages AFTER INSERT OR DELETE OR UPDATE ON templates.template_packages FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_package_members AFTER INSERT OR DELETE OR UPDATE ON templates.template_package_members FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_outputs AFTER INSERT OR DELETE OR UPDATE ON templates.template_outputs FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_render_jobs AFTER INSERT OR DELETE OR UPDATE ON templates.template_render_jobs FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_render_history AFTER INSERT OR DELETE OR UPDATE ON templates.template_render_history FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_approval_workflow AFTER INSERT OR DELETE OR UPDATE ON templates.template_approval_workflow FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_usage_statistics AFTER INSERT OR DELETE OR UPDATE ON templates.template_usage_statistics FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_version_audit AFTER INSERT OR DELETE OR UPDATE ON templates.template_version_audit FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_validation_tests AFTER INSERT OR DELETE OR UPDATE ON templates.template_validation_tests FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_event_template_mapping AFTER INSERT OR DELETE OR UPDATE ON templates.event_template_mapping FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
