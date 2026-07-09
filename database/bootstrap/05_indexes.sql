-- =========================================================================
-- 05_indexes.sql — All indexes (excludes PK/unique constraint indexes)
-- Auto-generated from canonical extraction (273 indexes)
-- =========================================================================

-- =========================================================================
-- audit — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_audit_details_log; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_details_log ON audit.audit_details USING btree (audit_log_id);


--

-- Name: idx_audit_logs_entity; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_logs_entity ON audit.audit_logs USING btree (entity_name, entity_id);


--

-- Name: idx_audit_logs_entity_timestamp; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_logs_entity_timestamp ON audit.audit_logs USING btree (entity_name, event_timestamp DESC);


--

-- Name: idx_audit_logs_new_values; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_logs_new_values ON audit.audit_logs USING gin (new_values);


--

-- Name: idx_audit_logs_old_values; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_logs_old_values ON audit.audit_logs USING gin (old_values);


--

-- Name: idx_audit_logs_timestamp; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_logs_timestamp ON audit.audit_logs USING btree (event_timestamp);


--

-- Name: idx_entity_changes_entity; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_entity_changes_entity ON audit.entity_changes USING btree (entity_name, entity_id);


--

-- Name: idx_entity_changes_json; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_entity_changes_json ON audit.entity_changes USING gin (details);


--



-- =========================================================================
-- committee — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_agenda_items_agenda; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_agenda_items_agenda ON committee.agenda_items USING btree (agenda_id);


--

-- Name: idx_app_conditions_app_id; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_app_conditions_app_id ON committee.application_conditions USING btree (application_id) WHERE (deleted_at IS NULL);


--

-- Name: idx_app_conditions_status; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_app_conditions_status ON committee.application_conditions USING btree (status) WHERE (deleted_at IS NULL);


--

-- Name: idx_assessment_items_assessment; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_assessment_items_assessment ON committee.accreditation_assessment_items USING btree (assessment_id);


--

-- Name: idx_assessments_assessor; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_assessments_assessor ON committee.accreditation_assessments USING btree (assessed_by);


--

-- Name: idx_assessments_cycle; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_assessments_cycle ON committee.accreditation_assessments USING btree (cycle_id);


--

-- Name: idx_attendance_logs_meeting; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_attendance_logs_meeting ON committee.attendance_logs USING btree (meeting_id);


--

-- Name: idx_attendance_logs_user; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_attendance_logs_user ON committee.attendance_logs USING btree (user_id);


--

-- Name: idx_committee_meetings_committee; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_committee_meetings_committee ON committee.committee_meetings USING btree (committee_id);


--

-- Name: idx_committee_meetings_date; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_committee_meetings_date ON committee.committee_meetings USING btree (meeting_date);


--

-- Name: idx_committee_meetings_date_desc; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_committee_meetings_date_desc ON committee.committee_meetings USING btree (meeting_date DESC);


--

-- Name: idx_committee_member_roles_member; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_committee_member_roles_member ON committee.committee_member_roles USING btree (member_id);


--

-- Name: idx_committee_member_roles_role; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_committee_member_roles_role ON committee.committee_member_roles USING btree (role_id);


--

-- Name: idx_committee_members_committee; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_committee_members_committee ON committee.committee_members USING btree (committee_id);


--

-- Name: idx_committee_members_user; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_committee_members_user ON committee.committee_members USING btree (user_id);


--

-- Name: idx_committees_active; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_committees_active ON committee.committees USING btree (id) WHERE (deleted_at IS NULL);


--

-- Name: idx_committees_institution; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_committees_institution ON committee.committees USING btree (institution_id);


--

-- Name: idx_conditions_cycle; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_conditions_cycle ON committee.accreditation_conditions USING btree (cycle_id);


--

-- Name: idx_conditions_severity; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_conditions_severity ON committee.accreditation_conditions USING btree (severity);


--

-- Name: idx_conditions_status; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_conditions_status ON committee.accreditation_conditions USING btree (status) WHERE ((status)::text = ANY (ARRAY[('OPEN'::character varying)::text, ('OVERDUE'::character varying)::text]));


--

-- Name: idx_consent_review_consent; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_consent_review_consent ON committee.consent_review_comments USING btree (application_consent_id) WHERE (deleted_at IS NULL);


--

-- Name: idx_consent_templates_active; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_consent_templates_active ON committee.consent_templates USING btree (is_active) WHERE (deleted_at IS NULL);


--

-- Name: idx_consent_templates_type; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_consent_templates_type ON committee.consent_templates USING btree (consent_type) WHERE (deleted_at IS NULL);


--

-- Name: idx_ctv_status; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_ctv_status ON committee.consent_template_versions USING btree (status) WHERE (deleted_at IS NULL);


--

-- Name: idx_ctv_template; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_ctv_template ON committee.consent_template_versions USING btree (template_id) WHERE (deleted_at IS NULL);


--

-- Name: idx_cycles_committee; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_cycles_committee ON committee.accreditation_cycles USING btree (committee_id);


--

-- Name: idx_cycles_expiry; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_cycles_expiry ON committee.accreditation_cycles USING btree (valid_until) WHERE ((status)::text = 'ACCREDITED'::text);


--

-- Name: idx_cycles_status; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_cycles_status ON committee.accreditation_cycles USING btree (status);


--

-- Name: idx_decisions_created; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_decisions_created ON committee.accreditation_decisions USING btree (created_at DESC);


--

-- Name: idx_decisions_cycle; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_decisions_cycle ON committee.accreditation_decisions USING btree (cycle_id);


--

-- Name: idx_ethics_reviews_active; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_ethics_reviews_active ON committee.ethics_reviews USING btree (id) WHERE (deleted_at IS NULL);


--

-- Name: idx_ethics_reviews_application; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_ethics_reviews_application ON committee.ethics_reviews USING btree (application_id);


--

-- Name: idx_ethics_reviews_reviewer; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_ethics_reviews_reviewer ON committee.ethics_reviews USING btree (reviewer_id);


--

-- Name: idx_ethics_risk_assessments_app; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_ethics_risk_assessments_app ON committee.ethics_risk_assessments USING btree (application_id) WHERE (deleted_at IS NULL);


--

-- Name: idx_ethics_risk_assessments_review; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_ethics_risk_assessments_review ON committee.ethics_risk_assessments USING btree (ethics_review_id) WHERE (deleted_at IS NULL);


--

-- Name: idx_ethics_risk_items_assessment; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_ethics_risk_items_assessment ON committee.ethics_risk_items USING btree (assessment_id) WHERE (deleted_at IS NULL);


--

-- Name: idx_evidence_cycle; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_evidence_cycle ON committee.accreditation_evidence USING btree (cycle_id);


--

-- Name: idx_evidence_status; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_evidence_status ON committee.accreditation_evidence USING btree (status);


--

-- Name: idx_meeting_agendas_meeting; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_meeting_agendas_meeting ON committee.meeting_agendas USING btree (meeting_id);


--

-- Name: idx_meeting_minutes_meeting; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_meeting_minutes_meeting ON committee.meeting_minutes USING btree (meeting_id);


--

-- Name: idx_member_conflicts_entity; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_member_conflicts_entity ON committee.member_conflicts USING btree (entity_type, entity_id);


--

-- Name: idx_member_conflicts_member; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_member_conflicts_member ON committee.member_conflicts USING btree (member_id);


--

-- Name: idx_member_terms_start_desc; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_member_terms_start_desc ON committee.member_terms USING btree (start_date DESC);


--

-- Name: idx_quorum_logs_meeting; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_quorum_logs_meeting ON committee.quorum_logs USING btree (meeting_id);


--

-- Name: idx_review_answers_question; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_answers_question ON committee.review_answers USING btree (question_id);


--

-- Name: idx_review_assignments_app; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_assignments_app ON committee.review_assignments USING btree (application_id);


--

-- Name: idx_review_assignments_application; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_assignments_application ON committee.review_assignments USING btree (application_id);


--

-- Name: idx_review_assignments_assigned_desc; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_assignments_assigned_desc ON committee.review_assignments USING btree (assigned_at DESC);


--

-- Name: idx_review_assignments_reviewer; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_assignments_reviewer ON committee.review_assignments USING btree (reviewer_id);


--

-- Name: idx_review_assignments_reviewer_assigned; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_assignments_reviewer_assigned ON committee.review_assignments USING btree (reviewer_id, assigned_at DESC);


--

-- Name: idx_review_comments_application; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_comments_application ON committee.review_comments USING btree (application_id);


--

-- Name: idx_review_conflicts_application; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_conflicts_application ON committee.review_conflicts USING btree (application_id);


--

-- Name: idx_review_conflicts_reviewer; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_conflicts_reviewer ON committee.review_conflicts USING btree (reviewer_id);


--

-- Name: idx_review_questions_form; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_questions_form ON committee.review_questions USING btree (form_id);


--

-- Name: idx_review_recommendations_application; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_recommendations_application ON committee.review_recommendations USING btree (application_id);


--

-- Name: idx_review_scores_application; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_scores_application ON committee.review_scores USING btree (application_id);


--

-- Name: idx_scientific_reviews_active; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_scientific_reviews_active ON committee.scientific_reviews USING btree (id) WHERE (deleted_at IS NULL);


--

-- Name: idx_scientific_reviews_application; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_scientific_reviews_application ON committee.scientific_reviews USING btree (application_id);


--

-- Name: idx_scientific_reviews_reviewer; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_scientific_reviews_reviewer ON committee.scientific_reviews USING btree (reviewer_id);


--

-- Name: idx_standards_category; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_standards_category ON committee.accreditation_standards USING btree (category);


--

-- Name: idx_standards_sort; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_standards_sort ON committee.accreditation_standards USING btree (sort_order);


--

-- Name: idx_stdver_active; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_stdver_active ON committee.accreditation_standard_versions USING btree (is_active) WHERE (is_active = true);


--

-- Name: idx_votes_session; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_votes_session ON committee.votes USING btree (voting_session_id);


--

-- Name: idx_voting_sessions_meeting; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_voting_sessions_meeting ON committee.voting_sessions USING btree (meeting_id);


--

-- Name: uq_active_cycle_per_committee; Type: INDEX; Schema: committee; Owner: -
--

CREATE UNIQUE INDEX uq_active_cycle_per_committee ON committee.accreditation_cycles USING btree (committee_id) WHERE ((status)::text <> ALL (ARRAY[('EXPIRED'::character varying)::text, ('REVOKED'::character varying)::text]));


--



-- =========================================================================
-- communication — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_announcements_active; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_announcements_active ON communication.announcements USING btree (is_active);


--

-- Name: idx_message_recipients_created_desc; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_message_recipients_created_desc ON communication.message_recipients USING btree (created_at DESC);


--

-- Name: idx_message_recipients_recipient; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_message_recipients_recipient ON communication.message_recipients USING btree (recipient_id);


--

-- Name: idx_message_recipients_recipient_created; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_message_recipients_recipient_created ON communication.message_recipients USING btree (recipient_id, created_at DESC);


--

-- Name: idx_messages_created_desc; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_messages_created_desc ON communication.messages USING btree (created_at DESC);


--

-- Name: idx_messages_sender; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_messages_sender ON communication.messages USING btree (sender_id, is_deleted);


--

-- Name: idx_msg_attachments_message; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_msg_attachments_message ON communication.message_attachments USING btree (message_id);


--

-- Name: idx_msg_recipients_message; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_msg_recipients_message ON communication.message_recipients USING btree (message_id);


--

-- Name: idx_msg_recipients_recipient; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_msg_recipients_recipient ON communication.message_recipients USING btree (recipient_id, is_deleted);


--

-- Name: idx_notification_logs_notification; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notification_logs_notification ON communication.notification_logs USING btree (notification_id);


--

-- Name: idx_notifications_active; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notifications_active ON communication.notifications USING btree (id) WHERE (deleted_at IS NULL);


--

-- Name: idx_notifications_created_desc; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notifications_created_desc ON communication.notifications USING btree (created_at DESC);


--

-- Name: idx_notifications_read; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notifications_read ON communication.notifications USING btree (is_read);


--

-- Name: idx_notifications_source; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notifications_source ON communication.notifications USING btree (source_entity_type, source_entity_id);


--

-- Name: idx_notifications_user; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notifications_user ON communication.notifications USING btree (user_id);


--

-- Name: idx_notifications_user_created; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notifications_user_created ON communication.notifications USING btree (user_id, created_at DESC);


--

-- Name: uq_cert_notif_dedup; Type: INDEX; Schema: communication; Owner: -
--

CREATE UNIQUE INDEX uq_cert_notif_dedup ON communication.notifications USING btree (notification_type, user_id, source_entity_id) WHERE ((source_entity_type)::text = 'Certificate'::text);


--



-- =========================================================================
-- core — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_amendment_requests_status; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_amendment_requests_status ON core.amendment_requests USING btree (request_status);


--

-- Name: idx_app_consents_app; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_app_consents_app ON core.application_consents USING btree (application_id) WHERE (deleted_at IS NULL);


--

-- Name: idx_app_consents_status; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_app_consents_status ON core.application_consents USING btree (status) WHERE (deleted_at IS NULL);


--

-- Name: idx_app_consents_version; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_app_consents_version ON core.application_consents USING btree (consent_version_id) WHERE (deleted_at IS NULL);


--

-- Name: idx_application_amendments_application; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_application_amendments_application ON core.application_amendments USING btree (application_id);


--

-- Name: idx_application_checklists_application; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_application_checklists_application ON core.application_checklists USING btree (application_id);


--

-- Name: idx_application_history_action_at; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_application_history_action_at ON core.application_history USING btree (action_at);


--

-- Name: idx_application_history_application; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_application_history_application ON core.application_history USING btree (application_id);


--

-- Name: idx_application_sections_application; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_application_sections_application ON core.application_sections USING btree (application_id);


--

-- Name: idx_application_validations_application; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_application_validations_application ON core.application_validations USING btree (application_id);


--

-- Name: idx_application_versions_application; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_application_versions_application ON core.application_versions USING btree (application_id);


--

-- Name: idx_applications_active; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_active ON core.applications USING btree (id) WHERE (deleted_at IS NULL);


--

-- Name: idx_applications_committee; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_committee ON core.applications USING btree (target_committee_id);


--

-- Name: idx_applications_created_at; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_created_at ON core.applications USING btree (created_at DESC);


--

-- Name: idx_applications_created_desc; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_created_desc ON core.applications USING btree (created_at DESC);


--

-- Name: idx_applications_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_project ON core.applications USING btree (project_id);


--

-- Name: idx_applications_status; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_status ON core.applications USING btree (current_status);


--

-- Name: idx_applications_submission_date; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_submission_date ON core.applications USING btree (submission_date);


--

-- Name: idx_applications_submitted_by; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_submitted_by ON core.applications USING btree (submitted_by);


--

-- Name: idx_applications_submitted_by_created; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_submitted_by_created ON core.applications USING btree (submitted_by, created_at DESC);


--

-- Name: idx_closure_requests_application; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_closure_requests_application ON core.closure_requests USING btree (application_id);


--

-- Name: idx_project_attachments_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_project_attachments_project ON core.project_attachments USING btree (project_id);


--

-- Name: idx_project_funding_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_project_funding_project ON core.project_funding_sources USING btree (project_id);


--

-- Name: idx_project_keywords_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_project_keywords_project ON core.project_keywords USING btree (project_id);


--

-- Name: idx_project_sites_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_project_sites_project ON core.project_sites USING btree (project_id);


--

-- Name: idx_project_status_history_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_project_status_history_project ON core.project_status_history USING btree (project_id);


--

-- Name: idx_project_tags_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_project_tags_project ON core.project_tags USING btree (project_id);


--

-- Name: idx_project_team_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_project_team_project ON core.project_team_members USING btree (project_id);


--

-- Name: idx_project_versions_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_project_versions_project ON core.project_versions USING btree (project_id);


--

-- Name: idx_projects_active; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_projects_active ON core.projects USING btree (id) WHERE (deleted_at IS NULL);


--

-- Name: idx_projects_created_desc; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_projects_created_desc ON core.projects USING btree (created_at DESC);


--

-- Name: idx_projects_institution; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_projects_institution ON core.projects USING btree (institution_id);


--

-- Name: idx_projects_pi; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_projects_pi ON core.projects USING btree (principal_investigator_id);


--

-- Name: idx_projects_status; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_projects_status ON core.projects USING btree (status_code);


--

-- Name: idx_renewal_requests_application; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_renewal_requests_application ON core.renewal_requests USING btree (application_id);


--

-- Name: idx_research_population_links_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_research_population_links_project ON core.research_population_links USING btree (project_id);


--

-- Name: idx_site_investigator_site; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_site_investigator_site ON core.project_site_investigators USING btree (site_id);


--



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



-- =========================================================================
-- integration — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_data_sync_jobs_status; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_data_sync_jobs_status ON integration.data_sync_jobs USING btree (status);


--

-- Name: idx_data_sync_jobs_system; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_data_sync_jobs_system ON integration.data_sync_jobs USING btree (external_system_id);


--

-- Name: idx_event_outbox_created; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_event_outbox_created ON integration.event_outbox USING btree (created_at);


--

-- Name: idx_event_outbox_created_desc; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_event_outbox_created_desc ON integration.event_outbox USING btree (created_at DESC);


--

-- Name: idx_event_outbox_event_data; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_event_outbox_event_data ON integration.event_outbox USING gin (event_data);


--

-- Name: idx_event_outbox_status; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_event_outbox_status ON integration.event_outbox USING btree (status);


--

-- Name: idx_event_outbox_type; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_event_outbox_type ON integration.event_outbox USING btree (event_type);


--

-- Name: idx_event_subscriptions_event_type; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_event_subscriptions_event_type ON integration.event_subscriptions USING btree (event_type);


--

-- Name: idx_integration_logs_created; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_integration_logs_created ON integration.integration_logs USING btree (created_at);


--

-- Name: idx_integration_logs_created_desc; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_integration_logs_created_desc ON integration.integration_logs USING btree (created_at DESC);


--

-- Name: idx_integration_logs_status; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_integration_logs_status ON integration.integration_logs USING btree (status);


--

-- Name: idx_integration_logs_type; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_integration_logs_type ON integration.integration_logs USING btree (integration_type);


--

-- Name: idx_retry_queue_next_retry; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_retry_queue_next_retry ON integration.retry_queue USING btree (next_retry_at);


--

-- Name: idx_retry_queue_status; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_retry_queue_status ON integration.retry_queue USING btree (status);


--

-- Name: idx_webhooks_active; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_webhooks_active ON integration.webhooks USING btree (is_active);


--



-- =========================================================================
-- monitoring — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_compliance_reviews_application; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_compliance_reviews_application ON monitoring.compliance_reviews USING btree (application_id);


--

-- Name: idx_corrective_actions_finding; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_corrective_actions_finding ON monitoring.corrective_actions USING btree (finding_id);


--

-- Name: idx_deviations_application; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_deviations_application ON monitoring.deviations USING btree (application_id);


--

-- Name: idx_inspection_reports_inspection; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_inspection_reports_inspection ON monitoring.inspection_reports USING btree (inspection_id);


--

-- Name: idx_inspections_application; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_inspections_application ON monitoring.inspections USING btree (application_id);


--

-- Name: idx_monitoring_findings_visit; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_monitoring_findings_visit ON monitoring.monitoring_findings USING btree (monitoring_visit_id);


--

-- Name: idx_monitoring_plans_application; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_monitoring_plans_application ON monitoring.monitoring_plans USING btree (application_id);


--

-- Name: idx_monitoring_visits_plan; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_monitoring_visits_plan ON monitoring.monitoring_visits USING btree (monitoring_plan_id);


--

-- Name: idx_preventive_actions_finding; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_preventive_actions_finding ON monitoring.preventive_actions USING btree (finding_id);


--

-- Name: idx_protocol_violations_application; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_protocol_violations_application ON monitoring.protocol_violations USING btree (application_id);


--



-- =========================================================================
-- reference — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_licenses_registry_user; Type: INDEX; Schema: reference; Owner: -
--

CREATE INDEX idx_licenses_registry_user ON reference.licenses_registry USING btree (user_id);


--

-- Name: idx_licenses_registry_verification; Type: INDEX; Schema: reference; Owner: -
--

CREATE INDEX idx_licenses_registry_verification ON reference.licenses_registry USING btree (verification_status);


--

-- Name: idx_lookup_categories_active; Type: INDEX; Schema: reference; Owner: -
--

CREATE INDEX idx_lookup_categories_active ON reference.lookup_categories USING btree (is_active);


--

-- Name: idx_lookup_values_category; Type: INDEX; Schema: reference; Owner: -
--

CREATE INDEX idx_lookup_values_category ON reference.lookup_values USING btree (category_id);


--



-- =========================================================================
-- reporting — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_analytics_snapshots_json; Type: INDEX; Schema: reporting; Owner: -
--

CREATE INDEX idx_analytics_snapshots_json ON reporting.analytics_snapshots USING gin (metrics);


--

-- Name: idx_dashboard_widgets_json; Type: INDEX; Schema: reporting; Owner: -
--

CREATE INDEX idx_dashboard_widgets_json ON reporting.dashboard_widgets USING gin (configuration);


--

-- Name: idx_kpi_results_code; Type: INDEX; Schema: reporting; Owner: -
--

CREATE INDEX idx_kpi_results_code ON reporting.kpi_results USING btree (kpi_code);


--

-- Name: idx_mv_committee_perf; Type: INDEX; Schema: reporting; Owner: -
--

CREATE UNIQUE INDEX idx_mv_committee_perf ON reporting.mv_committee_performance USING btree (committee_id, month);


--

-- Name: idx_mv_daily_snapshot; Type: INDEX; Schema: reporting; Owner: -
--

CREATE UNIQUE INDEX idx_mv_daily_snapshot ON reporting.mv_daily_application_snapshot USING btree (snapshot_date, current_status);


--

-- Name: idx_report_executions_report; Type: INDEX; Schema: reporting; Owner: -
--

CREATE INDEX idx_report_executions_report ON reporting.report_executions USING btree (report_id);


--



-- =========================================================================
-- safety — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_adverse_events_active; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_adverse_events_active ON safety.adverse_events USING btree (id) WHERE (deleted_at IS NULL);


--

-- Name: idx_adverse_events_application; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_adverse_events_application ON safety.adverse_events USING btree (application_id);


--

-- Name: idx_adverse_events_created_desc; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_adverse_events_created_desc ON safety.adverse_events USING btree (created_at DESC);


--

-- Name: idx_adverse_events_date; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_adverse_events_date ON safety.adverse_events USING btree (event_date);


--

-- Name: idx_corrective_actions_incident; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_corrective_actions_incident ON safety.corrective_actions USING btree (incident_id);


--

-- Name: idx_mitigation_actions_assessment; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_mitigation_actions_assessment ON safety.mitigation_actions USING btree (risk_assessment_id);


--

-- Name: idx_risk_assessments_application; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_risk_assessments_application ON safety.risk_assessments USING btree (application_id);


--

-- Name: idx_risk_incidents_risk; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_risk_incidents_risk ON safety.risk_incidents USING btree (risk_id);


--

-- Name: idx_risk_mitigations_risk; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_risk_mitigations_risk ON safety.risk_mitigations USING btree (risk_id);


--

-- Name: idx_risk_register_owner; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_risk_register_owner ON safety.risk_register USING btree (owner_id);


--

-- Name: idx_risk_register_status; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_risk_register_status ON safety.risk_register USING btree (status);


--

-- Name: idx_safety_committee_reviews_application; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_safety_committee_reviews_application ON safety.safety_committee_reviews USING btree (application_id);


--

-- Name: idx_safety_committee_reviews_committee; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_safety_committee_reviews_committee ON safety.safety_committee_reviews USING btree (committee_id);


--

-- Name: idx_safety_followups_event; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_safety_followups_event ON safety.safety_followups USING btree (adverse_event_id);


--

-- Name: idx_safety_reports_application; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_safety_reports_application ON safety.safety_reports USING btree (application_id);


--

-- Name: idx_serious_adverse_events_event; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_serious_adverse_events_event ON safety.serious_adverse_events USING btree (adverse_event_id);


--



-- =========================================================================
-- security — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_access_policy_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_access_policy_active ON security.access_policies USING btree (is_active);


--

-- Name: idx_access_policy_expression; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_access_policy_expression ON security.access_policies USING gin (policy_expression);


--

-- Name: idx_api_keys_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_api_keys_active ON security.api_keys USING btree (is_active);


--

-- Name: idx_api_keys_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_api_keys_user ON security.api_keys USING btree (user_id);


--

-- Name: idx_departments_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_departments_active ON security.departments USING btree (is_active);


--

-- Name: idx_departments_institution; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_departments_institution ON security.departments USING btree (institution_id);


--

-- Name: idx_email_verif_tokens_hash; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_email_verif_tokens_hash ON security.email_verification_tokens USING btree (token_hash);


--

-- Name: idx_email_verif_tokens_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_email_verif_tokens_user ON security.email_verification_tokens USING btree (user_id);


--

-- Name: idx_institution_types_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_institution_types_active ON security.institution_types USING btree (is_active);


--

-- Name: idx_institution_types_name_ar; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_institution_types_name_ar ON security.institution_types USING btree (name_ar);


--

-- Name: idx_institutions_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_institutions_active ON security.institutions USING btree (is_active);


--

-- Name: idx_institutions_name_ar; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_institutions_name_ar ON security.institutions USING btree (name_ar);


--

-- Name: idx_institutions_type; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_institutions_type ON security.institutions USING btree (institution_type_id);


--

-- Name: idx_login_audit_success; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_login_audit_success ON security.login_audit USING btree (success);


--

-- Name: idx_login_audit_time; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_login_audit_time ON security.login_audit USING btree (login_time DESC);


--

-- Name: idx_password_history_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_password_history_user ON security.password_history USING btree (user_id);


--

-- Name: idx_password_reset_tokens_expires; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_password_reset_tokens_expires ON security.password_reset_tokens USING btree (expires_at);


--

-- Name: idx_password_reset_tokens_user_id; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_password_reset_tokens_user_id ON security.password_reset_tokens USING btree (user_id);


--

-- Name: idx_permissions_module; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_permissions_module ON security.permissions USING btree (module_name);


--

-- Name: idx_role_permissions_permission; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_role_permissions_permission ON security.role_permissions USING btree (permission_id);


--

-- Name: idx_roles_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_roles_active ON security.roles USING btree (is_active);


--

-- Name: idx_security_events_details; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_security_events_details ON security.security_events USING gin (details);


--

-- Name: idx_security_events_severity; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_security_events_severity ON security.security_events USING btree (severity);


--

-- Name: idx_security_events_time; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_security_events_time ON security.security_events USING btree (event_time DESC);


--

-- Name: idx_sessions_expiry; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_sessions_expiry ON security.sessions USING btree (expires_at);


--

-- Name: idx_sessions_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_sessions_user ON security.sessions USING btree (user_id);


--

-- Name: idx_user_profiles_national_id; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_profiles_national_id ON security.user_profiles USING btree (national_id);


--

-- Name: idx_user_profiles_specialization; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_profiles_specialization ON security.user_profiles USING btree (specialization);


--

-- Name: idx_user_responsibilities_entity; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_responsibilities_entity ON security.user_responsibilities USING btree (entity_type, entity_id);


--

-- Name: idx_user_responsibilities_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_responsibilities_user ON security.user_responsibilities USING btree (user_id);


--

-- Name: idx_user_roles_role; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_roles_role ON security.user_roles USING btree (role_id);


--

-- Name: idx_user_roles_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_roles_user ON security.user_roles USING btree (user_id);


--

-- Name: idx_users_created_desc; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_users_created_desc ON security.users USING btree (created_at DESC);


--

-- Name: idx_users_department; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_users_department ON security.users USING btree (department_id);


--

-- Name: idx_users_institution; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_users_institution ON security.users USING btree (institution_id);


--

-- Name: idx_users_last_login; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_users_last_login ON security.users USING btree (last_login_at);


--

-- Name: idx_users_status; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_users_status ON security.users USING btree (status);


--

-- Name: uq_role_permissions_role_perm; Type: INDEX; Schema: security; Owner: -
--

CREATE UNIQUE INDEX uq_role_permissions_role_perm ON security.role_permissions USING btree (role_id, permission_id);


--



-- =========================================================================
-- system — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_audit_log_action; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_audit_log_action ON system.audit_log USING btree (action_type);


--

-- Name: idx_audit_log_created; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_audit_log_created ON system.audit_log USING btree (created_at DESC);


--

-- Name: idx_audit_log_created_desc; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_audit_log_created_desc ON system.audit_log USING btree (created_at DESC);


--

-- Name: idx_audit_log_entity; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_audit_log_entity ON system.audit_log USING btree (entity_type, entity_id);


--

-- Name: idx_audit_log_user; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_audit_log_user ON system.audit_log USING btree (user_id);


--

-- Name: idx_maintenance_log_started; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_maintenance_log_started ON system.maintenance_log USING btree (started_at);


--

-- Name: idx_maintenance_log_status; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_maintenance_log_status ON system.maintenance_log USING btree (status);


--

-- Name: idx_rule_actions_rule; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_rule_actions_rule ON system.rule_actions USING btree (rule_id);


--

-- Name: idx_rule_conditions_rule; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_rule_conditions_rule ON system.rule_conditions USING btree (rule_id);


--

-- Name: idx_rule_executions_entity; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_rule_executions_entity ON system.rule_executions USING btree (entity_type, entity_id);


--

-- Name: idx_rule_executions_rule; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_rule_executions_rule ON system.rule_executions USING btree (rule_id);


--

-- Name: idx_search_audit_created; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_search_audit_created ON system.search_audit USING btree (created_at);


--

-- Name: idx_search_audit_user; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_search_audit_user ON system.search_audit USING btree (user_id);


--

-- Name: idx_search_indexes_entity; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_search_indexes_entity ON system.search_indexes USING btree (entity_type, entity_id);


--

-- Name: idx_search_indexes_vector; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_search_indexes_vector ON system.search_indexes USING gin (search_vector);


--

-- Name: idx_system_config_group; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_system_config_group ON system.system_config USING btree (config_group);


--



-- =========================================================================
-- workflow — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_workflow_actions_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_actions_instance ON workflow.workflow_actions USING btree (workflow_instance_id);


--

-- Name: idx_workflow_comments_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_comments_instance ON workflow.workflow_comments USING btree (workflow_instance_id);


--

-- Name: idx_workflow_escalations_task; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_escalations_task ON workflow.workflow_escalations USING btree (workflow_task_id);


--

-- Name: idx_workflow_events_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_events_instance ON workflow.workflow_events USING btree (workflow_instance_id);


--

-- Name: idx_workflow_events_type; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_events_type ON workflow.workflow_events USING btree (event_type);


--

-- Name: idx_workflow_history_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_history_instance ON workflow.workflow_history USING btree (workflow_instance_id);


--

-- Name: idx_workflow_instances_active; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_instances_active ON workflow.workflow_instances USING btree (id) WHERE (deleted_at IS NULL);


--

-- Name: idx_workflow_instances_entity; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_instances_entity ON workflow.workflow_instances USING btree (entity_type, entity_id);


--

-- Name: idx_workflow_instances_state; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_instances_state ON workflow.workflow_instances USING btree (current_state_id);


--

-- Name: idx_workflow_sla_workflow; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_sla_workflow ON workflow.workflow_sla USING btree (workflow_id);


--

-- Name: idx_workflow_states_workflow; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_states_workflow ON workflow.workflow_states USING btree (workflow_id);


--

-- Name: idx_workflow_tasks_active; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_tasks_active ON workflow.workflow_tasks USING btree (id) WHERE (deleted_at IS NULL);


--

-- Name: idx_workflow_tasks_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_tasks_instance ON workflow.workflow_tasks USING btree (workflow_instance_id);


--

-- Name: idx_workflow_tasks_user; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_tasks_user ON workflow.workflow_tasks USING btree (assigned_to);


--

-- Name: idx_workflow_transitions_workflow; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_transitions_workflow ON workflow.workflow_transitions USING btree (workflow_id);


--

-- Name: idx_workflow_triggers_event; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_triggers_event ON workflow.workflow_triggers USING btree (trigger_event);


--

-- Name: idx_workflow_variables_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_variables_instance ON workflow.workflow_variables USING btree (workflow_instance_id);


--

-- Name: idx_workflow_variables_json; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_variables_json ON workflow.workflow_variables USING gin (variable_value);


--

-- Name: idx_workflows_entity; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflows_entity ON workflow.workflows USING btree (entity_type);


--

-- Name: uq_workflow_instance_active; Type: INDEX; Schema: workflow; Owner: -
--

CREATE UNIQUE INDEX uq_workflow_instance_active ON workflow.workflow_instances USING btree (entity_type, entity_id) WHERE (((status_code)::text = 'ACTIVE'::text) AND (deleted_at IS NULL));


--




