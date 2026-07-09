-- =========================================================================
-- documents — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: approval_certificate_documents approval_certificate_documents_pkey; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.approval_certificate_documents
    ADD CONSTRAINT approval_certificate_documents_pkey PRIMARY KEY (id);


--

-- Name: approval_certificates approval_certificates_pkey; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.approval_certificates
    ADD CONSTRAINT approval_certificates_pkey PRIMARY KEY (id);


--

-- Name: certificate_verification_log certificate_verification_log_pkey; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.certificate_verification_log
    ADD CONSTRAINT certificate_verification_log_pkey PRIMARY KEY (id);


--

-- Name: document_access pk_document_access; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_access
    ADD CONSTRAINT pk_document_access PRIMARY KEY (id);


--

-- Name: document_approvals pk_document_approvals; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_approvals
    ADD CONSTRAINT pk_document_approvals PRIMARY KEY (id);


--

-- Name: document_audit pk_document_audit; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_audit
    ADD CONSTRAINT pk_document_audit PRIMARY KEY (id);


--

-- Name: document_classifications pk_document_classifications; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_classifications
    ADD CONSTRAINT pk_document_classifications PRIMARY KEY (id);


--

-- Name: document_disposal_logs pk_document_disposal_logs; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_disposal_logs
    ADD CONSTRAINT pk_document_disposal_logs PRIMARY KEY (id);


--

-- Name: document_retention_rules pk_document_retention_rules; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_retention_rules
    ADD CONSTRAINT pk_document_retention_rules PRIMARY KEY (id);


--

-- Name: document_signatures pk_document_signatures; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_signatures
    ADD CONSTRAINT pk_document_signatures PRIMARY KEY (id);


--

-- Name: document_types pk_document_types; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_types
    ADD CONSTRAINT pk_document_types PRIMARY KEY (id);


--

-- Name: document_versions pk_document_versions; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_versions
    ADD CONSTRAINT pk_document_versions PRIMARY KEY (id);


--

-- Name: documents pk_documents; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.documents
    ADD CONSTRAINT pk_documents PRIMARY KEY (id);


--

-- Name: generated_documents pk_generated_documents; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.generated_documents
    ADD CONSTRAINT pk_generated_documents PRIMARY KEY (id);


--

-- Name: templates pk_templates; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.templates
    ADD CONSTRAINT pk_templates PRIMARY KEY (id);


--

-- Name: approval_certificates uq_app_version; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.approval_certificates
    ADD CONSTRAINT uq_app_version UNIQUE (application_id, version_no);


--

-- Name: approval_certificates uq_cert_serial; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.approval_certificates
    ADD CONSTRAINT uq_cert_serial UNIQUE (serial_number);


--

-- Name: document_classifications uq_document_classifications_code; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_classifications
    ADD CONSTRAINT uq_document_classifications_code UNIQUE (code);


--

-- Name: document_disposal_logs uq_document_disposal_logs_uuid; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_disposal_logs
    ADD CONSTRAINT uq_document_disposal_logs_uuid UNIQUE (uuid);


--

-- Name: document_types uq_document_types_code; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_types
    ADD CONSTRAINT uq_document_types_code UNIQUE (type_code);


--

-- Name: document_versions uq_document_versions; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_versions
    ADD CONSTRAINT uq_document_versions UNIQUE (document_id, version_no);


--

-- Name: templates uq_templates_code_version; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.templates
    ADD CONSTRAINT uq_templates_code_version UNIQUE (template_code, version_no);


--


-- =========================================================================
-- documents — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: approval_certificate_documents approval_certificate_documents_certificate_id_fkey; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.approval_certificate_documents
    ADD CONSTRAINT approval_certificate_documents_certificate_id_fkey FOREIGN KEY (certificate_id) REFERENCES documents.approval_certificates(id) ON DELETE CASCADE;


--

-- Name: approval_certificate_documents approval_certificate_documents_document_id_fkey; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.approval_certificate_documents
    ADD CONSTRAINT approval_certificate_documents_document_id_fkey FOREIGN KEY (document_id) REFERENCES documents.documents(id) ON DELETE CASCADE;


--

-- Name: approval_certificates approval_certificates_application_id_fkey; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.approval_certificates
    ADD CONSTRAINT approval_certificates_application_id_fkey FOREIGN KEY (application_id) REFERENCES core.applications(id);


--

-- Name: approval_certificates approval_certificates_created_by_fkey; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.approval_certificates
    ADD CONSTRAINT approval_certificates_created_by_fkey FOREIGN KEY (created_by) REFERENCES security.users(id);


--

-- Name: approval_certificates approval_certificates_issued_by_user_id_fkey; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.approval_certificates
    ADD CONSTRAINT approval_certificates_issued_by_user_id_fkey FOREIGN KEY (issued_by_user_id) REFERENCES security.users(id);


--

-- Name: approval_certificates approval_certificates_issued_to_user_id_fkey; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.approval_certificates
    ADD CONSTRAINT approval_certificates_issued_to_user_id_fkey FOREIGN KEY (issued_to_user_id) REFERENCES security.users(id);


--

-- Name: approval_certificates approval_certificates_revoked_by_fkey; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.approval_certificates
    ADD CONSTRAINT approval_certificates_revoked_by_fkey FOREIGN KEY (revoked_by) REFERENCES security.users(id);


--

-- Name: approval_certificates approval_certificates_superseded_by_fkey; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.approval_certificates
    ADD CONSTRAINT approval_certificates_superseded_by_fkey FOREIGN KEY (superseded_by) REFERENCES documents.approval_certificates(id);


--

-- Name: document_access fk_document_access_document; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_access
    ADD CONSTRAINT fk_document_access_document FOREIGN KEY (document_id) REFERENCES documents.documents(id) ON DELETE CASCADE;


--

-- Name: document_access fk_document_access_role; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_access
    ADD CONSTRAINT fk_document_access_role FOREIGN KEY (role_id) REFERENCES security.roles(id);


--

-- Name: document_access fk_document_access_user; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_access
    ADD CONSTRAINT fk_document_access_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--

-- Name: document_approvals fk_document_approvals_approver; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_approvals
    ADD CONSTRAINT fk_document_approvals_approver FOREIGN KEY (approver_id) REFERENCES security.users(id);


--

-- Name: document_approvals fk_document_approvals_document; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_approvals
    ADD CONSTRAINT fk_document_approvals_document FOREIGN KEY (document_id) REFERENCES documents.documents(id) ON DELETE CASCADE;


--

-- Name: document_audit fk_document_audit_document; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_audit
    ADD CONSTRAINT fk_document_audit_document FOREIGN KEY (document_id) REFERENCES documents.documents(id) ON DELETE CASCADE;


--

-- Name: document_disposal_logs fk_document_disposal_logs_disposed_by; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_disposal_logs
    ADD CONSTRAINT fk_document_disposal_logs_disposed_by FOREIGN KEY (disposed_by) REFERENCES security.users(id);


--

-- Name: document_disposal_logs fk_document_disposal_logs_document; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_disposal_logs
    ADD CONSTRAINT fk_document_disposal_logs_document FOREIGN KEY (document_id) REFERENCES documents.documents(id);


--

-- Name: document_retention_rules fk_document_retention_rules_type; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_retention_rules
    ADD CONSTRAINT fk_document_retention_rules_type FOREIGN KEY (document_type_id) REFERENCES documents.document_types(id);


--

-- Name: document_signatures fk_document_signatures_document; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_signatures
    ADD CONSTRAINT fk_document_signatures_document FOREIGN KEY (document_id) REFERENCES documents.documents(id) ON DELETE CASCADE;


--

-- Name: document_signatures fk_document_signatures_signer; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_signatures
    ADD CONSTRAINT fk_document_signatures_signer FOREIGN KEY (signer_id) REFERENCES security.users(id);


--

-- Name: document_versions fk_document_versions_document; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_versions
    ADD CONSTRAINT fk_document_versions_document FOREIGN KEY (document_id) REFERENCES documents.documents(id) ON DELETE CASCADE;


--

-- Name: document_versions fk_document_versions_user; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_versions
    ADD CONSTRAINT fk_document_versions_user FOREIGN KEY (uploaded_by) REFERENCES security.users(id);


--

-- Name: documents fk_documents_type; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.documents
    ADD CONSTRAINT fk_documents_type FOREIGN KEY (document_type_id) REFERENCES documents.document_types(id);


--

-- Name: documents fk_documents_uploaded_by; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.documents
    ADD CONSTRAINT fk_documents_uploaded_by FOREIGN KEY (uploaded_by) REFERENCES security.users(id);


--

-- Name: generated_documents fk_generated_documents_document; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.generated_documents
    ADD CONSTRAINT fk_generated_documents_document FOREIGN KEY (generated_document_id) REFERENCES documents.documents(id);


--

-- Name: generated_documents fk_generated_documents_template; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.generated_documents
    ADD CONSTRAINT fk_generated_documents_template FOREIGN KEY (template_id) REFERENCES documents.templates(id);


--

-- Name: generated_documents fk_generated_documents_user; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.generated_documents
    ADD CONSTRAINT fk_generated_documents_user FOREIGN KEY (generated_by) REFERENCES security.users(id);


--


