-- =========================================================================
-- documents — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_cert_app_id; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_cert_app_id ON documents.approval_certificates USING btree (application_id);


--

-- Name: idx_cert_one_active; Type: INDEX; Schema: documents; Owner: -
--

CREATE UNIQUE INDEX idx_cert_one_active ON documents.approval_certificates USING btree (application_id) WHERE ((status)::text = ANY (ARRAY[('ISSUED'::character varying)::text, ('GENERATING'::character varying)::text, ('DRAFT'::character varying)::text]));


--

-- Name: idx_cert_serial; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_cert_serial ON documents.approval_certificates USING btree (serial_number);


--

-- Name: idx_cert_status; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_cert_status ON documents.approval_certificates USING btree (status);


--

-- Name: idx_document_access_document; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_document_access_document ON documents.document_access USING btree (document_id);


--

-- Name: idx_document_access_user; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_document_access_user ON documents.document_access USING btree (user_id);


--

-- Name: idx_document_approvals_document; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_document_approvals_document ON documents.document_approvals USING btree (document_id);


--

-- Name: idx_document_audit_details; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_document_audit_details ON documents.document_audit USING gin (details);


--

-- Name: idx_document_audit_document; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_document_audit_document ON documents.document_audit USING btree (document_id);


--

-- Name: idx_document_signatures_document; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_document_signatures_document ON documents.document_signatures USING btree (document_id);


--

-- Name: idx_document_types_code; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_document_types_code ON documents.document_types USING btree (type_code);


--

-- Name: idx_document_versions_document; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_document_versions_document ON documents.document_versions USING btree (document_id);


--

-- Name: idx_documents_active; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_documents_active ON documents.documents USING btree (is_active);


--

-- Name: idx_documents_entity; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_documents_entity ON documents.documents USING btree (entity_type, entity_id);


--

-- Name: idx_documents_type; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_documents_type ON documents.documents USING btree (document_type_id);


--

-- Name: idx_documents_uploaded_desc; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_documents_uploaded_desc ON documents.documents USING btree (uploaded_at DESC);


--

-- Name: idx_generated_documents_entity; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_generated_documents_entity ON documents.generated_documents USING btree (entity_type, entity_id);


--

-- Name: idx_generated_documents_parameters; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_generated_documents_parameters ON documents.generated_documents USING gin (generation_parameters);


--

-- Name: idx_templates_type; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_templates_type ON documents.templates USING btree (template_type);


--

-- Name: idx_ver_log_date; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_ver_log_date ON documents.certificate_verification_log USING btree (verified_at);


--

-- Name: idx_ver_log_serial; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_ver_log_serial ON documents.certificate_verification_log USING btree (serial_number);


--


