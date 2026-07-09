-- =========================================================================
-- documents — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: approval_certificate_documents trg_audit_approval_certificate_documents; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trg_audit_approval_certificate_documents AFTER INSERT OR DELETE OR UPDATE ON documents.approval_certificate_documents FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: approval_certificates trg_audit_approval_certificates; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trg_audit_approval_certificates AFTER INSERT OR DELETE OR UPDATE ON documents.approval_certificates FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: certificate_verification_log trg_audit_certificate_verification_log; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trg_audit_certificate_verification_log AFTER INSERT OR DELETE OR UPDATE ON documents.certificate_verification_log FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: document_access trigger_audit_document_access; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_access AFTER INSERT OR DELETE OR UPDATE ON documents.document_access FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: document_approvals trigger_audit_document_approvals; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_approvals AFTER INSERT OR DELETE OR UPDATE ON documents.document_approvals FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: document_audit trigger_audit_document_audit; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_audit AFTER INSERT OR DELETE OR UPDATE ON documents.document_audit FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: document_classifications trigger_audit_document_classifications; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_classifications AFTER INSERT OR DELETE OR UPDATE ON documents.document_classifications FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: document_disposal_logs trigger_audit_document_disposal_logs; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_disposal_logs AFTER INSERT OR DELETE OR UPDATE ON documents.document_disposal_logs FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: document_retention_rules trigger_audit_document_retention_rules; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_retention_rules AFTER INSERT OR DELETE OR UPDATE ON documents.document_retention_rules FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: document_signatures trigger_audit_document_signatures; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_signatures AFTER INSERT OR DELETE OR UPDATE ON documents.document_signatures FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: document_types trigger_audit_document_types; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_types AFTER INSERT OR DELETE OR UPDATE ON documents.document_types FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: document_versions trigger_audit_document_versions; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_versions AFTER INSERT OR DELETE OR UPDATE ON documents.document_versions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: documents trigger_audit_documents; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_documents AFTER INSERT OR DELETE OR UPDATE ON documents.documents FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: generated_documents trigger_audit_generated_documents; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_generated_documents AFTER INSERT OR DELETE OR UPDATE ON documents.generated_documents FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: templates trigger_audit_templates; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_templates AFTER INSERT OR DELETE OR UPDATE ON documents.templates FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: document_classifications trigger_updated_at_documents_document_classifications; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_updated_at_documents_document_classifications BEFORE UPDATE ON documents.document_classifications FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: document_retention_rules trigger_updated_at_documents_document_retention_rules; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_updated_at_documents_document_retention_rules BEFORE UPDATE ON documents.document_retention_rules FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--


