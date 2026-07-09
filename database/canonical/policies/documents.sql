-- =========================================================================
-- documents — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: approval_certificates cert_delete; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY cert_delete ON documents.approval_certificates FOR DELETE USING (false);


--

-- Name: approval_certificate_documents cert_doc_delete; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY cert_doc_delete ON documents.approval_certificate_documents FOR DELETE USING (false);


--

-- Name: approval_certificate_documents cert_doc_insert; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY cert_doc_insert ON documents.approval_certificate_documents FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));


--

-- Name: approval_certificate_documents cert_doc_select; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY cert_doc_select ON documents.approval_certificate_documents FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (certificate_id IN ( SELECT approval_certificates.id
   FROM documents.approval_certificates
  WHERE (approval_certificates.issued_to_user_id = (current_setting('app.user_id'::text, true))::bigint))) OR (certificate_id IN ( SELECT ac2.id
   FROM documents.approval_certificates ac2
  WHERE system.fn_is_committee_member_for_application((current_setting('app.user_id'::text, true))::bigint, ac2.application_id)))));


--

-- Name: approval_certificates cert_insert; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY cert_insert ON documents.approval_certificates FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text))::bigint) AND (issued_by_user_id = (current_setting('app.user_id'::text))::bigint)));


--

-- Name: approval_certificates cert_select; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY cert_select ON documents.approval_certificates FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (issued_to_user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_committee_member_for_application((current_setting('app.user_id'::text, true))::bigint, application_id)));


--

-- Name: approval_certificates cert_update; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY cert_update ON documents.approval_certificates FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint)) WITH CHECK ((((status)::text = ANY (ARRAY[('REVOKED'::character varying)::text, ('SUPERSEDED'::character varying)::text, ('GENERATING'::character varying)::text])) AND system.fn_is_admin((current_setting('app.user_id'::text))::bigint)));


--

-- Name: documents documents_insert_policy; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY documents_insert_policy ON documents.documents FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text))::bigint) OR ((uploaded_by = (current_setting('app.user_id'::text))::bigint) AND (((entity_type)::text IS DISTINCT FROM 'Application'::text) OR (entity_id IS NULL) OR (EXISTS ( SELECT 1
   FROM core.applications a
  WHERE ((a.id = documents.entity_id) AND (a.submitted_by = (current_setting('app.user_id'::text))::bigint) AND (a.deleted_at IS NULL))))))));


--

-- Name: documents documents_select_policy; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY documents_select_policy ON documents.documents FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = uploaded_by) OR (system.is_active_row(deleted_at) AND (EXISTS ( SELECT 1
   FROM documents.document_access da
  WHERE ((da.document_id = documents.id) AND ((da.user_id = (current_setting('app.user_id'::text, true))::bigint) OR (da.role_id IN ( SELECT ur.role_id
           FROM security.user_roles ur
          WHERE (ur.user_id = (current_setting('app.user_id'::text, true))::bigint))))))))));


--

-- Name: documents documents_update_policy; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY documents_update_policy ON documents.documents FOR UPDATE USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = uploaded_by))) WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = uploaded_by)));


--

-- Name: certificate_verification_log ver_log_insert; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY ver_log_insert ON documents.certificate_verification_log FOR INSERT WITH CHECK (true);


--

-- Name: certificate_verification_log ver_log_select; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY ver_log_select ON documents.certificate_verification_log FOR SELECT USING (true);


--


-- =========================================================================
-- documents — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: approval_certificate_documents; Type: ROW SECURITY; Schema: documents; Owner: -
--

ALTER TABLE documents.approval_certificate_documents ENABLE ROW LEVEL SECURITY;

--

-- Name: approval_certificates; Type: ROW SECURITY; Schema: documents; Owner: -
--

ALTER TABLE documents.approval_certificates ENABLE ROW LEVEL SECURITY;

--

-- Name: certificate_verification_log; Type: ROW SECURITY; Schema: documents; Owner: -
--

ALTER TABLE documents.certificate_verification_log ENABLE ROW LEVEL SECURITY;

--

-- Name: documents; Type: ROW SECURITY; Schema: documents; Owner: -
--

ALTER TABLE documents.documents ENABLE ROW LEVEL SECURITY;

--


