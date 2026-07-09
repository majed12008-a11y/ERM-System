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


