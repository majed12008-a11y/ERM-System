-- =========================================================================-- committee — CONSTRAINT-- Extracted from live database — auto-generated-- =========================================================================-- Name: accreditation_assessment_items accreditation_assessment_items_pkey; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_assessment_items
    ADD CONSTRAINT accreditation_assessment_items_pkey PRIMARY KEY (id);

--
--  Name: accreditation_assessments accreditation_assessments_pkey; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_assessments
    ADD CONSTRAINT accreditation_assessments_pkey PRIMARY KEY (id);

--
--  Name: accreditation_conditions accreditation_conditions_pkey; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_conditions
    ADD CONSTRAINT accreditation_conditions_pkey PRIMARY KEY (id);

--
--  Name: accreditation_cycle_metrics accreditation_cycle_metrics_cycle_id_key; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_cycle_metrics
    ADD CONSTRAINT accreditation_cycle_metrics_cycle_id_key UNIQUE (cycle_id);

--
--  Name: accreditation_cycle_metrics accreditation_cycle_metrics_pkey; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_cycle_metrics
    ADD CONSTRAINT accreditation_cycle_metrics_pkey PRIMARY KEY (id);

--
--  Name: accreditation_cycles accreditation_cycles_pkey; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_cycles
    ADD CONSTRAINT accreditation_cycles_pkey PRIMARY KEY (id);

--
--  Name: accreditation_decisions accreditation_decisions_pkey; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_decisions
    ADD CONSTRAINT accreditation_decisions_pkey PRIMARY KEY (id);

--
--  Name: accreditation_evidence accreditation_evidence_pkey; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_evidence
    ADD CONSTRAINT accreditation_evidence_pkey PRIMARY KEY (id);

--
--  Name: accreditation_standard_versions accreditation_standard_versions_pkey; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_standard_versions
    ADD CONSTRAINT accreditation_standard_versions_pkey PRIMARY KEY (id);

--
--  Name: accreditation_standards accreditation_standards_pkey; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_standards
    ADD CONSTRAINT accreditation_standards_pkey PRIMARY KEY (id);

--
--  Name: application_conditions application_conditions_pkey; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.application_conditions
    ADD CONSTRAINT application_conditions_pkey PRIMARY KEY (id);

--
--  Name: consent_review_comments consent_review_comments_pkey; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.consent_review_comments
    ADD CONSTRAINT consent_review_comments_pkey PRIMARY KEY (id);

--
--  Name: consent_template_versions consent_template_versions_pkey; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.consent_template_versions
    ADD CONSTRAINT consent_template_versions_pkey PRIMARY KEY (id);

--
--  Name: consent_templates consent_templates_code_key; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.consent_templates
    ADD CONSTRAINT consent_templates_code_key UNIQUE (code);

--
--  Name: consent_templates consent_templates_pkey; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.consent_templates
    ADD CONSTRAINT consent_templates_pkey PRIMARY KEY (id);

--
--  Name: ethics_risk_assessments ethics_risk_assessments_pkey; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.ethics_risk_assessments
    ADD CONSTRAINT ethics_risk_assessments_pkey PRIMARY KEY (id);

--
--  Name: ethics_risk_items ethics_risk_items_pkey; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.ethics_risk_items
    ADD CONSTRAINT ethics_risk_items_pkey PRIMARY KEY (id);

--
--  Name: agenda_items pk_agenda_items; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.agenda_items
    ADD CONSTRAINT pk_agenda_items PRIMARY KEY (id);

--
--  Name: attendance_logs pk_attendance_logs; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.attendance_logs
    ADD CONSTRAINT pk_attendance_logs PRIMARY KEY (id);

--
--  Name: committee_meetings pk_committee_meetings; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committee_meetings
    ADD CONSTRAINT pk_committee_meetings PRIMARY KEY (id);

--
--  Name: committee_member_roles pk_committee_member_roles; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committee_member_roles
    ADD CONSTRAINT pk_committee_member_roles PRIMARY KEY (id);

--
--  Name: committee_members pk_committee_members; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committee_members
    ADD CONSTRAINT pk_committee_members PRIMARY KEY (id);

--
--  Name: committee_roles pk_committee_roles; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committee_roles
    ADD CONSTRAINT pk_committee_roles PRIMARY KEY (id);

--
--  Name: committee_types pk_committee_types; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committee_types
    ADD CONSTRAINT pk_committee_types PRIMARY KEY (id);

--
--  Name: committees pk_committees; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committees
    ADD CONSTRAINT pk_committees PRIMARY KEY (id);

--
--  Name: ethics_reviews pk_ethics_reviews; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.ethics_reviews
    ADD CONSTRAINT pk_ethics_reviews PRIMARY KEY (id);

--
--  Name: meeting_agendas pk_meeting_agendas; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.meeting_agendas
    ADD CONSTRAINT pk_meeting_agendas PRIMARY KEY (id);

--
--  Name: meeting_minutes pk_meeting_minutes; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.meeting_minutes
    ADD CONSTRAINT pk_meeting_minutes PRIMARY KEY (id);

--
--  Name: member_conflicts pk_member_conflicts; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.member_conflicts
    ADD CONSTRAINT pk_member_conflicts PRIMARY KEY (id);

--
--  Name: member_qualifications pk_member_qualifications; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.member_qualifications
    ADD CONSTRAINT pk_member_qualifications PRIMARY KEY (id);

--
--  Name: member_terms pk_member_terms; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.member_terms
    ADD CONSTRAINT pk_member_terms PRIMARY KEY (id);

--
--  Name: quorum_logs pk_quorum_logs; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.quorum_logs
    ADD CONSTRAINT pk_quorum_logs PRIMARY KEY (id);

--
--  Name: review_answers pk_review_answers; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.review_answers
    ADD CONSTRAINT pk_review_answers PRIMARY KEY (id);

--
--  Name: review_assignments pk_review_assignments; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.review_assignments
    ADD CONSTRAINT pk_review_assignments PRIMARY KEY (id);

--
--  Name: review_comments pk_review_comments; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.review_comments
    ADD CONSTRAINT pk_review_comments PRIMARY KEY (id);

--
--  Name: review_conflicts pk_review_conflicts; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.review_conflicts
    ADD CONSTRAINT pk_review_conflicts PRIMARY KEY (id);

--
--  Name: review_forms pk_review_forms; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.review_forms
    ADD CONSTRAINT pk_review_forms PRIMARY KEY (id);

--
--  Name: review_questions pk_review_questions; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.review_questions
    ADD CONSTRAINT pk_review_questions PRIMARY KEY (id);

--
--  Name: review_recommendations pk_review_recommendations; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.review_recommendations
    ADD CONSTRAINT pk_review_recommendations PRIMARY KEY (id);

--
--  Name: review_scores pk_review_scores; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.review_scores
    ADD CONSTRAINT pk_review_scores PRIMARY KEY (id);

--
--  Name: scientific_reviews pk_scientific_reviews; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.scientific_reviews
    ADD CONSTRAINT pk_scientific_reviews PRIMARY KEY (id);

--
--  Name: votes pk_votes; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.votes
    ADD CONSTRAINT pk_votes PRIMARY KEY (id);

--
--  Name: voting_sessions pk_voting_sessions; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.voting_sessions
    ADD CONSTRAINT pk_voting_sessions PRIMARY KEY (id);

--
--  Name: accreditation_assessment_items uq_assessment_item; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_assessment_items
    ADD CONSTRAINT uq_assessment_item UNIQUE (assessment_id, standard_version_id);

--
--  Name: committee_members uq_committee_member; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committee_members
    ADD CONSTRAINT uq_committee_member UNIQUE (committee_id, user_id);

--
--  Name: committee_member_roles uq_committee_member_role; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committee_member_roles
    ADD CONSTRAINT uq_committee_member_role UNIQUE (member_id, role_id);

--
--  Name: committee_roles uq_committee_roles_code; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committee_roles
    ADD CONSTRAINT uq_committee_roles_code UNIQUE (role_code);

--
--  Name: committee_types uq_committee_types_code; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committee_types
    ADD CONSTRAINT uq_committee_types_code UNIQUE (type_code);

--
--  Name: committees uq_committees_code; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committees
    ADD CONSTRAINT uq_committees_code UNIQUE (committee_code);

--
--  Name: consent_template_versions uq_ctv_version_lang; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.consent_template_versions
    ADD CONSTRAINT uq_ctv_version_lang UNIQUE (template_id, version_no, language);

--
--  Name: member_conflicts uq_member_conflicts_uuid; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.member_conflicts
    ADD CONSTRAINT uq_member_conflicts_uuid UNIQUE (uuid);

--
--  Name: member_qualifications uq_member_qualifications_uuid; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.member_qualifications
    ADD CONSTRAINT uq_member_qualifications_uuid UNIQUE (uuid);

--
--  Name: member_terms uq_member_terms_uuid; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.member_terms
    ADD CONSTRAINT uq_member_terms_uuid UNIQUE (uuid);

--
--  Name: review_forms uq_review_forms_code; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.review_forms
    ADD CONSTRAINT uq_review_forms_code UNIQUE (form_code, version_no);

--
--  Name: accreditation_standard_versions uq_standard_version; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_standard_versions
    ADD CONSTRAINT uq_standard_version UNIQUE (standard_id, version_label);

--
--  Name: accreditation_standards uq_standards_code; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_standards
    ADD CONSTRAINT uq_standards_code UNIQUE (code);

--
--  Name: votes uq_vote_once; Type: CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.votes
    ADD CONSTRAINT uq_vote_once UNIQUE (voting_session_id, voter_id);



-- =========================================================================-- committee — FK_CONSTRAINT-- Extracted from live database — auto-generated-- =========================================================================-- Name: accreditation_assessment_items accreditation_assessment_items_assessment_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_assessment_items
    ADD CONSTRAINT accreditation_assessment_items_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES committee.accreditation_assessments(id);

--
--  Name: accreditation_assessment_items accreditation_assessment_items_standard_version_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_assessment_items
    ADD CONSTRAINT accreditation_assessment_items_standard_version_id_fkey FOREIGN KEY (standard_version_id) REFERENCES committee.accreditation_standard_versions(id);

--
--  Name: accreditation_assessments accreditation_assessments_assessed_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_assessments
    ADD CONSTRAINT accreditation_assessments_assessed_by_fkey FOREIGN KEY (assessed_by) REFERENCES security.users(id);

--
--  Name: accreditation_assessments accreditation_assessments_cycle_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_assessments
    ADD CONSTRAINT accreditation_assessments_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES committee.accreditation_cycles(id);

--
--  Name: accreditation_conditions accreditation_conditions_cycle_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_conditions
    ADD CONSTRAINT accreditation_conditions_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES committee.accreditation_cycles(id);

--
--  Name: accreditation_conditions accreditation_conditions_resolved_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_conditions
    ADD CONSTRAINT accreditation_conditions_resolved_by_fkey FOREIGN KEY (resolved_by) REFERENCES security.users(id);

--
--  Name: accreditation_cycle_metrics accreditation_cycle_metrics_cycle_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_cycle_metrics
    ADD CONSTRAINT accreditation_cycle_metrics_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES committee.accreditation_cycles(id);

--
--  Name: accreditation_cycles accreditation_cycles_committee_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_cycles
    ADD CONSTRAINT accreditation_cycles_committee_id_fkey FOREIGN KEY (committee_id) REFERENCES committee.committees(id);

--
--  Name: accreditation_cycles accreditation_cycles_created_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_cycles
    ADD CONSTRAINT accreditation_cycles_created_by_fkey FOREIGN KEY (created_by) REFERENCES security.users(id);

--
--  Name: accreditation_cycles accreditation_cycles_decided_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_cycles
    ADD CONSTRAINT accreditation_cycles_decided_by_fkey FOREIGN KEY (decided_by) REFERENCES security.users(id);

--
--  Name: accreditation_cycles accreditation_cycles_standard_version_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_cycles
    ADD CONSTRAINT accreditation_cycles_standard_version_id_fkey FOREIGN KEY (standard_version_id) REFERENCES committee.accreditation_standard_versions(id);

--
--  Name: accreditation_decisions accreditation_decisions_cycle_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_decisions
    ADD CONSTRAINT accreditation_decisions_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES committee.accreditation_cycles(id);

--
--  Name: accreditation_decisions accreditation_decisions_decided_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_decisions
    ADD CONSTRAINT accreditation_decisions_decided_by_fkey FOREIGN KEY (decided_by) REFERENCES security.users(id);

--
--  Name: accreditation_evidence accreditation_evidence_cycle_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_evidence
    ADD CONSTRAINT accreditation_evidence_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES committee.accreditation_cycles(id);

--
--  Name: accreditation_evidence accreditation_evidence_document_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_evidence
    ADD CONSTRAINT accreditation_evidence_document_id_fkey FOREIGN KEY (document_id) REFERENCES documents.documents(id);

--
--  Name: accreditation_evidence accreditation_evidence_standard_version_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_evidence
    ADD CONSTRAINT accreditation_evidence_standard_version_id_fkey FOREIGN KEY (standard_version_id) REFERENCES committee.accreditation_standard_versions(id);

--
--  Name: accreditation_evidence accreditation_evidence_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_evidence
    ADD CONSTRAINT accreditation_evidence_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES security.users(id);

--
--  Name: accreditation_standard_versions accreditation_standard_versions_standard_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_standard_versions
    ADD CONSTRAINT accreditation_standard_versions_standard_id_fkey FOREIGN KEY (standard_id) REFERENCES committee.accreditation_standards(id);

--
--  Name: application_conditions application_conditions_application_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.application_conditions
    ADD CONSTRAINT application_conditions_application_id_fkey FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;

--
--  Name: application_conditions application_conditions_created_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.application_conditions
    ADD CONSTRAINT application_conditions_created_by_fkey FOREIGN KEY (created_by) REFERENCES security.users(id);

--
--  Name: application_conditions application_conditions_deleted_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.application_conditions
    ADD CONSTRAINT application_conditions_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES security.users(id);

--
--  Name: application_conditions application_conditions_resolved_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.application_conditions
    ADD CONSTRAINT application_conditions_resolved_by_fkey FOREIGN KEY (resolved_by) REFERENCES security.users(id);

--
--  Name: application_conditions application_conditions_updated_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.application_conditions
    ADD CONSTRAINT application_conditions_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES security.users(id);

--
--  Name: committee_members committee_members_role_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committee_members
    ADD CONSTRAINT committee_members_role_id_fkey FOREIGN KEY (role_id) REFERENCES committee.committee_roles(id);

--
--  Name: consent_review_comments consent_review_comments_application_consent_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.consent_review_comments
    ADD CONSTRAINT consent_review_comments_application_consent_id_fkey FOREIGN KEY (application_consent_id) REFERENCES core.application_consents(id);

--
--  Name: consent_review_comments consent_review_comments_reviewer_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.consent_review_comments
    ADD CONSTRAINT consent_review_comments_reviewer_id_fkey FOREIGN KEY (reviewer_id) REFERENCES security.users(id);

--
--  Name: consent_template_versions consent_template_versions_document_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.consent_template_versions
    ADD CONSTRAINT consent_template_versions_document_id_fkey FOREIGN KEY (document_id) REFERENCES documents.documents(id);

--
--  Name: consent_template_versions consent_template_versions_template_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.consent_template_versions
    ADD CONSTRAINT consent_template_versions_template_id_fkey FOREIGN KEY (template_id) REFERENCES committee.consent_templates(id);

--
--  Name: ethics_risk_assessments ethics_risk_assessments_application_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.ethics_risk_assessments
    ADD CONSTRAINT ethics_risk_assessments_application_id_fkey FOREIGN KEY (application_id) REFERENCES core.applications(id);

--
--  Name: ethics_risk_assessments ethics_risk_assessments_assessed_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.ethics_risk_assessments
    ADD CONSTRAINT ethics_risk_assessments_assessed_by_fkey FOREIGN KEY (assessed_by) REFERENCES security.users(id);

--
--  Name: ethics_risk_assessments ethics_risk_assessments_ethics_review_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.ethics_risk_assessments
    ADD CONSTRAINT ethics_risk_assessments_ethics_review_id_fkey FOREIGN KEY (ethics_review_id) REFERENCES committee.ethics_reviews(id);

--
--  Name: ethics_risk_assessments ethics_risk_assessments_scientific_review_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.ethics_risk_assessments
    ADD CONSTRAINT ethics_risk_assessments_scientific_review_id_fkey FOREIGN KEY (scientific_review_id) REFERENCES committee.scientific_reviews(id);

--
--  Name: ethics_risk_items ethics_risk_items_assessment_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.ethics_risk_items
    ADD CONSTRAINT ethics_risk_items_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES committee.ethics_risk_assessments(id) ON DELETE CASCADE;

--
--  Name: ethics_risk_items ethics_risk_items_risk_category_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.ethics_risk_items
    ADD CONSTRAINT ethics_risk_items_risk_category_id_fkey FOREIGN KEY (risk_category_id) REFERENCES safety.risk_categories(id);

--
--  Name: agenda_items fk_agenda_items_agenda; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.agenda_items
    ADD CONSTRAINT fk_agenda_items_agenda FOREIGN KEY (agenda_id) REFERENCES committee.meeting_agendas(id) ON DELETE CASCADE;

--
--  Name: agenda_items fk_agenda_items_application; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.agenda_items
    ADD CONSTRAINT fk_agenda_items_application FOREIGN KEY (application_id) REFERENCES core.applications(id);

--
--  Name: attendance_logs fk_attendance_logs_meeting; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.attendance_logs
    ADD CONSTRAINT fk_attendance_logs_meeting FOREIGN KEY (meeting_id) REFERENCES committee.committee_meetings(id) ON DELETE CASCADE;

--
--  Name: attendance_logs fk_attendance_logs_user; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.attendance_logs
    ADD CONSTRAINT fk_attendance_logs_user FOREIGN KEY (user_id) REFERENCES security.users(id);

--
--  Name: committee_meetings fk_committee_meetings_committee; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committee_meetings
    ADD CONSTRAINT fk_committee_meetings_committee FOREIGN KEY (committee_id) REFERENCES committee.committees(id) ON DELETE CASCADE;

--
--  Name: committee_members fk_committee_members_committee; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committee_members
    ADD CONSTRAINT fk_committee_members_committee FOREIGN KEY (committee_id) REFERENCES committee.committees(id) ON DELETE CASCADE;

--
--  Name: committee_members fk_committee_members_user; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committee_members
    ADD CONSTRAINT fk_committee_members_user FOREIGN KEY (user_id) REFERENCES security.users(id);

--
--  Name: committees fk_committees_institution; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committees
    ADD CONSTRAINT fk_committees_institution FOREIGN KEY (institution_id) REFERENCES security.institutions(id);

--
--  Name: committees fk_committees_type; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committees
    ADD CONSTRAINT fk_committees_type FOREIGN KEY (committee_type_id) REFERENCES committee.committee_types(id);

--
--  Name: accreditation_conditions fk_conditions_assessment; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_conditions
    ADD CONSTRAINT fk_conditions_assessment FOREIGN KEY (assessment_id) REFERENCES committee.accreditation_assessments(id);

--
--  Name: accreditation_conditions fk_conditions_assessment_item; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_conditions
    ADD CONSTRAINT fk_conditions_assessment_item FOREIGN KEY (assessment_item_id) REFERENCES committee.accreditation_assessment_items(id);

--
--  Name: accreditation_conditions fk_conditions_standard_version; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.accreditation_conditions
    ADD CONSTRAINT fk_conditions_standard_version FOREIGN KEY (standard_version_id) REFERENCES committee.accreditation_standard_versions(id);

--
--  Name: ethics_reviews fk_ethics_reviews_application; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.ethics_reviews
    ADD CONSTRAINT fk_ethics_reviews_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;

--
--  Name: ethics_reviews fk_ethics_reviews_reviewer; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.ethics_reviews
    ADD CONSTRAINT fk_ethics_reviews_reviewer FOREIGN KEY (reviewer_id) REFERENCES security.users(id);

--
--  Name: meeting_agendas fk_meeting_agendas_meeting; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.meeting_agendas
    ADD CONSTRAINT fk_meeting_agendas_meeting FOREIGN KEY (meeting_id) REFERENCES committee.committee_meetings(id) ON DELETE CASCADE;

--
--  Name: meeting_minutes fk_meeting_minutes_meeting; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.meeting_minutes
    ADD CONSTRAINT fk_meeting_minutes_meeting FOREIGN KEY (meeting_id) REFERENCES committee.committee_meetings(id) ON DELETE CASCADE;

--
--  Name: member_conflicts fk_member_conflicts_member; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.member_conflicts
    ADD CONSTRAINT fk_member_conflicts_member FOREIGN KEY (member_id) REFERENCES committee.committee_members(id);

--
--  Name: member_qualifications fk_member_qualifications_member; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.member_qualifications
    ADD CONSTRAINT fk_member_qualifications_member FOREIGN KEY (member_id) REFERENCES committee.committee_members(id);

--
--  Name: member_qualifications fk_member_qualifications_verified_by; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.member_qualifications
    ADD CONSTRAINT fk_member_qualifications_verified_by FOREIGN KEY (verified_by) REFERENCES security.users(id);

--
--  Name: committee_member_roles fk_member_roles_member; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committee_member_roles
    ADD CONSTRAINT fk_member_roles_member FOREIGN KEY (member_id) REFERENCES committee.committee_members(id) ON DELETE CASCADE;

--
--  Name: committee_member_roles fk_member_roles_role; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.committee_member_roles
    ADD CONSTRAINT fk_member_roles_role FOREIGN KEY (role_id) REFERENCES committee.committee_roles(id) ON DELETE CASCADE;

--
--  Name: member_terms fk_member_terms_member; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.member_terms
    ADD CONSTRAINT fk_member_terms_member FOREIGN KEY (member_id) REFERENCES committee.committee_members(id);

--
--  Name: quorum_logs fk_quorum_logs_meeting; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.quorum_logs
    ADD CONSTRAINT fk_quorum_logs_meeting FOREIGN KEY (meeting_id) REFERENCES committee.committee_meetings(id) ON DELETE CASCADE;

--
--  Name: review_answers fk_review_answers_question; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.review_answers
    ADD CONSTRAINT fk_review_answers_question FOREIGN KEY (question_id) REFERENCES committee.review_questions(id) ON DELETE CASCADE;

--
--  Name: review_assignments fk_review_assignments_application; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.review_assignments
    ADD CONSTRAINT fk_review_assignments_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;

--
--  Name: review_assignments fk_review_assignments_reviewer; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.review_assignments
    ADD CONSTRAINT fk_review_assignments_reviewer FOREIGN KEY (reviewer_id) REFERENCES security.users(id);

--
--  Name: review_comments fk_review_comments_application; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.review_comments
    ADD CONSTRAINT fk_review_comments_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;

--
--  Name: review_conflicts fk_review_conflicts_application; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.review_conflicts
    ADD CONSTRAINT fk_review_conflicts_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;

--
--  Name: review_questions fk_review_questions_form; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.review_questions
    ADD CONSTRAINT fk_review_questions_form FOREIGN KEY (form_id) REFERENCES committee.review_forms(id) ON DELETE CASCADE;

--
--  Name: review_recommendations fk_review_recommendations_application; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.review_recommendations
    ADD CONSTRAINT fk_review_recommendations_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;

--
--  Name: review_scores fk_review_scores_application; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.review_scores
    ADD CONSTRAINT fk_review_scores_application FOREIGN KEY (application_id) REFERENCES core.applications(id);

--
--  Name: scientific_reviews fk_scientific_reviews_application; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.scientific_reviews
    ADD CONSTRAINT fk_scientific_reviews_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;

--
--  Name: scientific_reviews fk_scientific_reviews_reviewer; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.scientific_reviews
    ADD CONSTRAINT fk_scientific_reviews_reviewer FOREIGN KEY (reviewer_id) REFERENCES security.users(id);

--
--  Name: votes fk_votes_session; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.votes
    ADD CONSTRAINT fk_votes_session FOREIGN KEY (voting_session_id) REFERENCES committee.voting_sessions(id) ON DELETE CASCADE;

--
--  Name: votes fk_votes_voter; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.votes
    ADD CONSTRAINT fk_votes_voter FOREIGN KEY (voter_id) REFERENCES security.users(id);

--
--  Name: voting_sessions fk_voting_sessions_application; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.voting_sessions
    ADD CONSTRAINT fk_voting_sessions_application FOREIGN KEY (application_id) REFERENCES core.applications(id);

--
--  Name: voting_sessions fk_voting_sessions_meeting; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.voting_sessions
    ADD CONSTRAINT fk_voting_sessions_meeting FOREIGN KEY (meeting_id) REFERENCES committee.committee_meetings(id);

--
--  Name: meeting_minutes meeting_minutes_created_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -

ALTER TABLE ONLY committee.meeting_minutes
    ADD CONSTRAINT meeting_minutes_created_by_fkey FOREIGN KEY (created_by) REFERENCES security.users(id);




