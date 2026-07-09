-- =========================================================================
-- 04_constraints.sql — Foreign keys, unique constraints, check constraints
-- Auto-generated from canonical extraction (239 FK + 307 constraints)
-- =========================================================================

-- =========================================================================
-- audit — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: hash_ledger hash_ledger_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.hash_ledger
    ADD CONSTRAINT hash_ledger_pkey PRIMARY KEY (id);


--

-- Name: audit_details pk_audit_details; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.audit_details
    ADD CONSTRAINT pk_audit_details PRIMARY KEY (id);


--

-- Name: audit_logs pk_audit_logs; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.audit_logs
    ADD CONSTRAINT pk_audit_logs PRIMARY KEY (id);


--

-- Name: entity_changes pk_entity_changes; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.entity_changes
    ADD CONSTRAINT pk_entity_changes PRIMARY KEY (id);


--


-- =========================================================================
-- audit — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: audit_details fk_audit_details_log; Type: FK CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.audit_details
    ADD CONSTRAINT fk_audit_details_log FOREIGN KEY (audit_log_id) REFERENCES audit.audit_logs(id) ON DELETE CASCADE;


--

-- Name: audit_logs fk_audit_logs_user; Type: FK CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.audit_logs
    ADD CONSTRAINT fk_audit_logs_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--

-- Name: entity_changes fk_entity_changes_user; Type: FK CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.entity_changes
    ADD CONSTRAINT fk_entity_changes_user FOREIGN KEY (changed_by) REFERENCES security.users(id);


--



-- =========================================================================
-- committee — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: accreditation_assessment_items accreditation_assessment_items_pkey; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_assessment_items
    ADD CONSTRAINT accreditation_assessment_items_pkey PRIMARY KEY (id);


--

-- Name: accreditation_assessments accreditation_assessments_pkey; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_assessments
    ADD CONSTRAINT accreditation_assessments_pkey PRIMARY KEY (id);


--

-- Name: accreditation_conditions accreditation_conditions_pkey; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_conditions
    ADD CONSTRAINT accreditation_conditions_pkey PRIMARY KEY (id);


--

-- Name: accreditation_cycle_metrics accreditation_cycle_metrics_cycle_id_key; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_cycle_metrics
    ADD CONSTRAINT accreditation_cycle_metrics_cycle_id_key UNIQUE (cycle_id);


--

-- Name: accreditation_cycle_metrics accreditation_cycle_metrics_pkey; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_cycle_metrics
    ADD CONSTRAINT accreditation_cycle_metrics_pkey PRIMARY KEY (id);


--

-- Name: accreditation_cycles accreditation_cycles_pkey; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_cycles
    ADD CONSTRAINT accreditation_cycles_pkey PRIMARY KEY (id);


--

-- Name: accreditation_decisions accreditation_decisions_pkey; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_decisions
    ADD CONSTRAINT accreditation_decisions_pkey PRIMARY KEY (id);


--

-- Name: accreditation_evidence accreditation_evidence_pkey; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_evidence
    ADD CONSTRAINT accreditation_evidence_pkey PRIMARY KEY (id);


--

-- Name: accreditation_standard_versions accreditation_standard_versions_pkey; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_standard_versions
    ADD CONSTRAINT accreditation_standard_versions_pkey PRIMARY KEY (id);


--

-- Name: accreditation_standards accreditation_standards_pkey; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_standards
    ADD CONSTRAINT accreditation_standards_pkey PRIMARY KEY (id);


--

-- Name: application_conditions application_conditions_pkey; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.application_conditions
    ADD CONSTRAINT application_conditions_pkey PRIMARY KEY (id);


--

-- Name: consent_review_comments consent_review_comments_pkey; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.consent_review_comments
    ADD CONSTRAINT consent_review_comments_pkey PRIMARY KEY (id);


--

-- Name: consent_template_versions consent_template_versions_pkey; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.consent_template_versions
    ADD CONSTRAINT consent_template_versions_pkey PRIMARY KEY (id);


--

-- Name: consent_templates consent_templates_code_key; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.consent_templates
    ADD CONSTRAINT consent_templates_code_key UNIQUE (code);


--

-- Name: consent_templates consent_templates_pkey; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.consent_templates
    ADD CONSTRAINT consent_templates_pkey PRIMARY KEY (id);


--

-- Name: ethics_risk_assessments ethics_risk_assessments_pkey; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.ethics_risk_assessments
    ADD CONSTRAINT ethics_risk_assessments_pkey PRIMARY KEY (id);


--

-- Name: ethics_risk_items ethics_risk_items_pkey; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.ethics_risk_items
    ADD CONSTRAINT ethics_risk_items_pkey PRIMARY KEY (id);


--

-- Name: agenda_items pk_agenda_items; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.agenda_items
    ADD CONSTRAINT pk_agenda_items PRIMARY KEY (id);


--

-- Name: attendance_logs pk_attendance_logs; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.attendance_logs
    ADD CONSTRAINT pk_attendance_logs PRIMARY KEY (id);


--

-- Name: committee_meetings pk_committee_meetings; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_meetings
    ADD CONSTRAINT pk_committee_meetings PRIMARY KEY (id);


--

-- Name: committee_member_roles pk_committee_member_roles; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_member_roles
    ADD CONSTRAINT pk_committee_member_roles PRIMARY KEY (id);


--

-- Name: committee_members pk_committee_members; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_members
    ADD CONSTRAINT pk_committee_members PRIMARY KEY (id);


--

-- Name: committee_roles pk_committee_roles; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_roles
    ADD CONSTRAINT pk_committee_roles PRIMARY KEY (id);


--

-- Name: committee_types pk_committee_types; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_types
    ADD CONSTRAINT pk_committee_types PRIMARY KEY (id);


--

-- Name: committees pk_committees; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committees
    ADD CONSTRAINT pk_committees PRIMARY KEY (id);


--

-- Name: ethics_reviews pk_ethics_reviews; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.ethics_reviews
    ADD CONSTRAINT pk_ethics_reviews PRIMARY KEY (id);


--

-- Name: meeting_agendas pk_meeting_agendas; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.meeting_agendas
    ADD CONSTRAINT pk_meeting_agendas PRIMARY KEY (id);


--

-- Name: meeting_minutes pk_meeting_minutes; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.meeting_minutes
    ADD CONSTRAINT pk_meeting_minutes PRIMARY KEY (id);


--

-- Name: member_conflicts pk_member_conflicts; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_conflicts
    ADD CONSTRAINT pk_member_conflicts PRIMARY KEY (id);


--

-- Name: member_qualifications pk_member_qualifications; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_qualifications
    ADD CONSTRAINT pk_member_qualifications PRIMARY KEY (id);


--

-- Name: member_terms pk_member_terms; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_terms
    ADD CONSTRAINT pk_member_terms PRIMARY KEY (id);


--

-- Name: quorum_logs pk_quorum_logs; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.quorum_logs
    ADD CONSTRAINT pk_quorum_logs PRIMARY KEY (id);


--

-- Name: review_answers pk_review_answers; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_answers
    ADD CONSTRAINT pk_review_answers PRIMARY KEY (id);


--

-- Name: review_assignments pk_review_assignments; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_assignments
    ADD CONSTRAINT pk_review_assignments PRIMARY KEY (id);


--

-- Name: review_comments pk_review_comments; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_comments
    ADD CONSTRAINT pk_review_comments PRIMARY KEY (id);


--

-- Name: review_conflicts pk_review_conflicts; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_conflicts
    ADD CONSTRAINT pk_review_conflicts PRIMARY KEY (id);


--

-- Name: review_forms pk_review_forms; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_forms
    ADD CONSTRAINT pk_review_forms PRIMARY KEY (id);


--

-- Name: review_questions pk_review_questions; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_questions
    ADD CONSTRAINT pk_review_questions PRIMARY KEY (id);


--

-- Name: review_recommendations pk_review_recommendations; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_recommendations
    ADD CONSTRAINT pk_review_recommendations PRIMARY KEY (id);


--

-- Name: review_scores pk_review_scores; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_scores
    ADD CONSTRAINT pk_review_scores PRIMARY KEY (id);


--

-- Name: scientific_reviews pk_scientific_reviews; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.scientific_reviews
    ADD CONSTRAINT pk_scientific_reviews PRIMARY KEY (id);


--

-- Name: votes pk_votes; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.votes
    ADD CONSTRAINT pk_votes PRIMARY KEY (id);


--

-- Name: voting_sessions pk_voting_sessions; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.voting_sessions
    ADD CONSTRAINT pk_voting_sessions PRIMARY KEY (id);


--

-- Name: accreditation_assessment_items uq_assessment_item; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_assessment_items
    ADD CONSTRAINT uq_assessment_item UNIQUE (assessment_id, standard_version_id);


--

-- Name: committee_members uq_committee_member; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_members
    ADD CONSTRAINT uq_committee_member UNIQUE (committee_id, user_id);


--

-- Name: committee_member_roles uq_committee_member_role; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_member_roles
    ADD CONSTRAINT uq_committee_member_role UNIQUE (member_id, role_id);


--

-- Name: committee_roles uq_committee_roles_code; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_roles
    ADD CONSTRAINT uq_committee_roles_code UNIQUE (role_code);


--

-- Name: committee_types uq_committee_types_code; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_types
    ADD CONSTRAINT uq_committee_types_code UNIQUE (type_code);


--

-- Name: committees uq_committees_code; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committees
    ADD CONSTRAINT uq_committees_code UNIQUE (committee_code);


--

-- Name: consent_template_versions uq_ctv_version_lang; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.consent_template_versions
    ADD CONSTRAINT uq_ctv_version_lang UNIQUE (template_id, version_no, language);


--

-- Name: member_conflicts uq_member_conflicts_uuid; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_conflicts
    ADD CONSTRAINT uq_member_conflicts_uuid UNIQUE (uuid);


--

-- Name: member_qualifications uq_member_qualifications_uuid; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_qualifications
    ADD CONSTRAINT uq_member_qualifications_uuid UNIQUE (uuid);


--

-- Name: member_terms uq_member_terms_uuid; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_terms
    ADD CONSTRAINT uq_member_terms_uuid UNIQUE (uuid);


--

-- Name: review_forms uq_review_forms_code; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_forms
    ADD CONSTRAINT uq_review_forms_code UNIQUE (form_code, version_no);


--

-- Name: accreditation_standard_versions uq_standard_version; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_standard_versions
    ADD CONSTRAINT uq_standard_version UNIQUE (standard_id, version_label);


--

-- Name: accreditation_standards uq_standards_code; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_standards
    ADD CONSTRAINT uq_standards_code UNIQUE (code);


--

-- Name: votes uq_vote_once; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.votes
    ADD CONSTRAINT uq_vote_once UNIQUE (voting_session_id, voter_id);


--


-- =========================================================================
-- committee — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: accreditation_assessment_items accreditation_assessment_items_assessment_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_assessment_items
    ADD CONSTRAINT accreditation_assessment_items_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES committee.accreditation_assessments(id);


--

-- Name: accreditation_assessment_items accreditation_assessment_items_standard_version_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_assessment_items
    ADD CONSTRAINT accreditation_assessment_items_standard_version_id_fkey FOREIGN KEY (standard_version_id) REFERENCES committee.accreditation_standard_versions(id);


--

-- Name: accreditation_assessments accreditation_assessments_assessed_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_assessments
    ADD CONSTRAINT accreditation_assessments_assessed_by_fkey FOREIGN KEY (assessed_by) REFERENCES security.users(id);


--

-- Name: accreditation_assessments accreditation_assessments_cycle_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_assessments
    ADD CONSTRAINT accreditation_assessments_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES committee.accreditation_cycles(id);


--

-- Name: accreditation_conditions accreditation_conditions_cycle_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_conditions
    ADD CONSTRAINT accreditation_conditions_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES committee.accreditation_cycles(id);


--

-- Name: accreditation_conditions accreditation_conditions_resolved_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_conditions
    ADD CONSTRAINT accreditation_conditions_resolved_by_fkey FOREIGN KEY (resolved_by) REFERENCES security.users(id);


--

-- Name: accreditation_cycle_metrics accreditation_cycle_metrics_cycle_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_cycle_metrics
    ADD CONSTRAINT accreditation_cycle_metrics_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES committee.accreditation_cycles(id);


--

-- Name: accreditation_cycles accreditation_cycles_committee_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_cycles
    ADD CONSTRAINT accreditation_cycles_committee_id_fkey FOREIGN KEY (committee_id) REFERENCES committee.committees(id);


--

-- Name: accreditation_cycles accreditation_cycles_created_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_cycles
    ADD CONSTRAINT accreditation_cycles_created_by_fkey FOREIGN KEY (created_by) REFERENCES security.users(id);


--

-- Name: accreditation_cycles accreditation_cycles_decided_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_cycles
    ADD CONSTRAINT accreditation_cycles_decided_by_fkey FOREIGN KEY (decided_by) REFERENCES security.users(id);


--

-- Name: accreditation_cycles accreditation_cycles_standard_version_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_cycles
    ADD CONSTRAINT accreditation_cycles_standard_version_id_fkey FOREIGN KEY (standard_version_id) REFERENCES committee.accreditation_standard_versions(id);


--

-- Name: accreditation_decisions accreditation_decisions_cycle_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_decisions
    ADD CONSTRAINT accreditation_decisions_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES committee.accreditation_cycles(id);


--

-- Name: accreditation_decisions accreditation_decisions_decided_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_decisions
    ADD CONSTRAINT accreditation_decisions_decided_by_fkey FOREIGN KEY (decided_by) REFERENCES security.users(id);


--

-- Name: accreditation_evidence accreditation_evidence_cycle_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_evidence
    ADD CONSTRAINT accreditation_evidence_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES committee.accreditation_cycles(id);


--

-- Name: accreditation_evidence accreditation_evidence_document_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_evidence
    ADD CONSTRAINT accreditation_evidence_document_id_fkey FOREIGN KEY (document_id) REFERENCES documents.documents(id);


--

-- Name: accreditation_evidence accreditation_evidence_standard_version_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_evidence
    ADD CONSTRAINT accreditation_evidence_standard_version_id_fkey FOREIGN KEY (standard_version_id) REFERENCES committee.accreditation_standard_versions(id);


--

-- Name: accreditation_evidence accreditation_evidence_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_evidence
    ADD CONSTRAINT accreditation_evidence_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES security.users(id);


--

-- Name: accreditation_standard_versions accreditation_standard_versions_standard_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_standard_versions
    ADD CONSTRAINT accreditation_standard_versions_standard_id_fkey FOREIGN KEY (standard_id) REFERENCES committee.accreditation_standards(id);


--

-- Name: application_conditions application_conditions_application_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.application_conditions
    ADD CONSTRAINT application_conditions_application_id_fkey FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: application_conditions application_conditions_created_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.application_conditions
    ADD CONSTRAINT application_conditions_created_by_fkey FOREIGN KEY (created_by) REFERENCES security.users(id);


--

-- Name: application_conditions application_conditions_deleted_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.application_conditions
    ADD CONSTRAINT application_conditions_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES security.users(id);


--

-- Name: application_conditions application_conditions_resolved_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.application_conditions
    ADD CONSTRAINT application_conditions_resolved_by_fkey FOREIGN KEY (resolved_by) REFERENCES security.users(id);


--

-- Name: application_conditions application_conditions_updated_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.application_conditions
    ADD CONSTRAINT application_conditions_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES security.users(id);


--

-- Name: committee_members committee_members_role_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_members
    ADD CONSTRAINT committee_members_role_id_fkey FOREIGN KEY (role_id) REFERENCES committee.committee_roles(id);


--

-- Name: consent_review_comments consent_review_comments_application_consent_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.consent_review_comments
    ADD CONSTRAINT consent_review_comments_application_consent_id_fkey FOREIGN KEY (application_consent_id) REFERENCES core.application_consents(id);


--

-- Name: consent_review_comments consent_review_comments_reviewer_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.consent_review_comments
    ADD CONSTRAINT consent_review_comments_reviewer_id_fkey FOREIGN KEY (reviewer_id) REFERENCES security.users(id);


--

-- Name: consent_template_versions consent_template_versions_document_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.consent_template_versions
    ADD CONSTRAINT consent_template_versions_document_id_fkey FOREIGN KEY (document_id) REFERENCES documents.documents(id);


--

-- Name: consent_template_versions consent_template_versions_template_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.consent_template_versions
    ADD CONSTRAINT consent_template_versions_template_id_fkey FOREIGN KEY (template_id) REFERENCES committee.consent_templates(id);


--

-- Name: ethics_risk_assessments ethics_risk_assessments_application_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.ethics_risk_assessments
    ADD CONSTRAINT ethics_risk_assessments_application_id_fkey FOREIGN KEY (application_id) REFERENCES core.applications(id);


--

-- Name: ethics_risk_assessments ethics_risk_assessments_assessed_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.ethics_risk_assessments
    ADD CONSTRAINT ethics_risk_assessments_assessed_by_fkey FOREIGN KEY (assessed_by) REFERENCES security.users(id);


--

-- Name: ethics_risk_assessments ethics_risk_assessments_ethics_review_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.ethics_risk_assessments
    ADD CONSTRAINT ethics_risk_assessments_ethics_review_id_fkey FOREIGN KEY (ethics_review_id) REFERENCES committee.ethics_reviews(id);


--

-- Name: ethics_risk_assessments ethics_risk_assessments_scientific_review_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.ethics_risk_assessments
    ADD CONSTRAINT ethics_risk_assessments_scientific_review_id_fkey FOREIGN KEY (scientific_review_id) REFERENCES committee.scientific_reviews(id);


--

-- Name: ethics_risk_items ethics_risk_items_assessment_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.ethics_risk_items
    ADD CONSTRAINT ethics_risk_items_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES committee.ethics_risk_assessments(id) ON DELETE CASCADE;


--

-- Name: ethics_risk_items ethics_risk_items_risk_category_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.ethics_risk_items
    ADD CONSTRAINT ethics_risk_items_risk_category_id_fkey FOREIGN KEY (risk_category_id) REFERENCES safety.risk_categories(id);


--

-- Name: agenda_items fk_agenda_items_agenda; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.agenda_items
    ADD CONSTRAINT fk_agenda_items_agenda FOREIGN KEY (agenda_id) REFERENCES committee.meeting_agendas(id) ON DELETE CASCADE;


--

-- Name: agenda_items fk_agenda_items_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.agenda_items
    ADD CONSTRAINT fk_agenda_items_application FOREIGN KEY (application_id) REFERENCES core.applications(id);


--

-- Name: attendance_logs fk_attendance_logs_meeting; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.attendance_logs
    ADD CONSTRAINT fk_attendance_logs_meeting FOREIGN KEY (meeting_id) REFERENCES committee.committee_meetings(id) ON DELETE CASCADE;


--

-- Name: attendance_logs fk_attendance_logs_user; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.attendance_logs
    ADD CONSTRAINT fk_attendance_logs_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--

-- Name: committee_meetings fk_committee_meetings_committee; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_meetings
    ADD CONSTRAINT fk_committee_meetings_committee FOREIGN KEY (committee_id) REFERENCES committee.committees(id) ON DELETE CASCADE;


--

-- Name: committee_members fk_committee_members_committee; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_members
    ADD CONSTRAINT fk_committee_members_committee FOREIGN KEY (committee_id) REFERENCES committee.committees(id) ON DELETE CASCADE;


--

-- Name: committee_members fk_committee_members_user; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_members
    ADD CONSTRAINT fk_committee_members_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--

-- Name: committees fk_committees_institution; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committees
    ADD CONSTRAINT fk_committees_institution FOREIGN KEY (institution_id) REFERENCES security.institutions(id);


--

-- Name: committees fk_committees_type; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committees
    ADD CONSTRAINT fk_committees_type FOREIGN KEY (committee_type_id) REFERENCES committee.committee_types(id);


--

-- Name: accreditation_conditions fk_conditions_assessment; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_conditions
    ADD CONSTRAINT fk_conditions_assessment FOREIGN KEY (assessment_id) REFERENCES committee.accreditation_assessments(id);


--

-- Name: accreditation_conditions fk_conditions_assessment_item; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_conditions
    ADD CONSTRAINT fk_conditions_assessment_item FOREIGN KEY (assessment_item_id) REFERENCES committee.accreditation_assessment_items(id);


--

-- Name: accreditation_conditions fk_conditions_standard_version; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.accreditation_conditions
    ADD CONSTRAINT fk_conditions_standard_version FOREIGN KEY (standard_version_id) REFERENCES committee.accreditation_standard_versions(id);


--

-- Name: ethics_reviews fk_ethics_reviews_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.ethics_reviews
    ADD CONSTRAINT fk_ethics_reviews_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: ethics_reviews fk_ethics_reviews_reviewer; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.ethics_reviews
    ADD CONSTRAINT fk_ethics_reviews_reviewer FOREIGN KEY (reviewer_id) REFERENCES security.users(id);


--

-- Name: meeting_agendas fk_meeting_agendas_meeting; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.meeting_agendas
    ADD CONSTRAINT fk_meeting_agendas_meeting FOREIGN KEY (meeting_id) REFERENCES committee.committee_meetings(id) ON DELETE CASCADE;


--

-- Name: meeting_minutes fk_meeting_minutes_meeting; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.meeting_minutes
    ADD CONSTRAINT fk_meeting_minutes_meeting FOREIGN KEY (meeting_id) REFERENCES committee.committee_meetings(id) ON DELETE CASCADE;


--

-- Name: member_conflicts fk_member_conflicts_member; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_conflicts
    ADD CONSTRAINT fk_member_conflicts_member FOREIGN KEY (member_id) REFERENCES committee.committee_members(id);


--

-- Name: member_qualifications fk_member_qualifications_member; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_qualifications
    ADD CONSTRAINT fk_member_qualifications_member FOREIGN KEY (member_id) REFERENCES committee.committee_members(id);


--

-- Name: member_qualifications fk_member_qualifications_verified_by; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_qualifications
    ADD CONSTRAINT fk_member_qualifications_verified_by FOREIGN KEY (verified_by) REFERENCES security.users(id);


--

-- Name: committee_member_roles fk_member_roles_member; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_member_roles
    ADD CONSTRAINT fk_member_roles_member FOREIGN KEY (member_id) REFERENCES committee.committee_members(id) ON DELETE CASCADE;


--

-- Name: committee_member_roles fk_member_roles_role; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_member_roles
    ADD CONSTRAINT fk_member_roles_role FOREIGN KEY (role_id) REFERENCES committee.committee_roles(id) ON DELETE CASCADE;


--

-- Name: member_terms fk_member_terms_member; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_terms
    ADD CONSTRAINT fk_member_terms_member FOREIGN KEY (member_id) REFERENCES committee.committee_members(id);


--

-- Name: quorum_logs fk_quorum_logs_meeting; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.quorum_logs
    ADD CONSTRAINT fk_quorum_logs_meeting FOREIGN KEY (meeting_id) REFERENCES committee.committee_meetings(id) ON DELETE CASCADE;


--

-- Name: review_answers fk_review_answers_question; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_answers
    ADD CONSTRAINT fk_review_answers_question FOREIGN KEY (question_id) REFERENCES committee.review_questions(id) ON DELETE CASCADE;


--

-- Name: review_assignments fk_review_assignments_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_assignments
    ADD CONSTRAINT fk_review_assignments_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: review_assignments fk_review_assignments_reviewer; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_assignments
    ADD CONSTRAINT fk_review_assignments_reviewer FOREIGN KEY (reviewer_id) REFERENCES security.users(id);


--

-- Name: review_comments fk_review_comments_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_comments
    ADD CONSTRAINT fk_review_comments_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: review_conflicts fk_review_conflicts_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_conflicts
    ADD CONSTRAINT fk_review_conflicts_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: review_questions fk_review_questions_form; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_questions
    ADD CONSTRAINT fk_review_questions_form FOREIGN KEY (form_id) REFERENCES committee.review_forms(id) ON DELETE CASCADE;


--

-- Name: review_recommendations fk_review_recommendations_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_recommendations
    ADD CONSTRAINT fk_review_recommendations_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: review_scores fk_review_scores_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_scores
    ADD CONSTRAINT fk_review_scores_application FOREIGN KEY (application_id) REFERENCES core.applications(id);


--

-- Name: scientific_reviews fk_scientific_reviews_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.scientific_reviews
    ADD CONSTRAINT fk_scientific_reviews_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: scientific_reviews fk_scientific_reviews_reviewer; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.scientific_reviews
    ADD CONSTRAINT fk_scientific_reviews_reviewer FOREIGN KEY (reviewer_id) REFERENCES security.users(id);


--

-- Name: votes fk_votes_session; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.votes
    ADD CONSTRAINT fk_votes_session FOREIGN KEY (voting_session_id) REFERENCES committee.voting_sessions(id) ON DELETE CASCADE;


--

-- Name: votes fk_votes_voter; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.votes
    ADD CONSTRAINT fk_votes_voter FOREIGN KEY (voter_id) REFERENCES security.users(id);


--

-- Name: voting_sessions fk_voting_sessions_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.voting_sessions
    ADD CONSTRAINT fk_voting_sessions_application FOREIGN KEY (application_id) REFERENCES core.applications(id);


--

-- Name: voting_sessions fk_voting_sessions_meeting; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.voting_sessions
    ADD CONSTRAINT fk_voting_sessions_meeting FOREIGN KEY (meeting_id) REFERENCES committee.committee_meetings(id);


--

-- Name: meeting_minutes meeting_minutes_created_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.meeting_minutes
    ADD CONSTRAINT meeting_minutes_created_by_fkey FOREIGN KEY (created_by) REFERENCES security.users(id);


--



-- =========================================================================
-- communication — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: message_attachments message_attachments_pkey; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_attachments
    ADD CONSTRAINT message_attachments_pkey PRIMARY KEY (id);


--

-- Name: message_recipients message_recipients_pkey; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_recipients
    ADD CONSTRAINT message_recipients_pkey PRIMARY KEY (id);


--

-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--

-- Name: announcements pk_announcements; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.announcements
    ADD CONSTRAINT pk_announcements PRIMARY KEY (id);


--

-- Name: notification_channels pk_notification_channels; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_channels
    ADD CONSTRAINT pk_notification_channels PRIMARY KEY (id);


--

-- Name: notification_logs pk_notification_logs; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_logs
    ADD CONSTRAINT pk_notification_logs PRIMARY KEY (id);


--

-- Name: notification_templates pk_notification_templates; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_templates
    ADD CONSTRAINT pk_notification_templates PRIMARY KEY (id);


--

-- Name: notifications pk_notifications; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notifications
    ADD CONSTRAINT pk_notifications PRIMARY KEY (id);


--

-- Name: notification_channels uq_notification_channels; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_channels
    ADD CONSTRAINT uq_notification_channels UNIQUE (channel_code);


--

-- Name: notification_templates uq_notification_templates_code; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_templates
    ADD CONSTRAINT uq_notification_templates_code UNIQUE (template_code);


--

-- Name: user_notification_preferences uq_user_notif_pref; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.user_notification_preferences
    ADD CONSTRAINT uq_user_notif_pref UNIQUE (user_id, notification_type, channel);


--

-- Name: user_notification_preferences user_notification_preferences_pkey; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.user_notification_preferences
    ADD CONSTRAINT user_notification_preferences_pkey PRIMARY KEY (id);


--


-- =========================================================================
-- communication — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: announcements fk_announcements_user; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.announcements
    ADD CONSTRAINT fk_announcements_user FOREIGN KEY (created_by) REFERENCES security.users(id);


--

-- Name: notification_logs fk_notification_logs_notification; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_logs
    ADD CONSTRAINT fk_notification_logs_notification FOREIGN KEY (notification_id) REFERENCES communication.notifications(id) ON DELETE CASCADE;


--

-- Name: notifications fk_notifications_user; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notifications
    ADD CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--

-- Name: message_attachments message_attachments_message_id_fkey; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_attachments
    ADD CONSTRAINT message_attachments_message_id_fkey FOREIGN KEY (message_id) REFERENCES communication.messages(id) ON DELETE CASCADE;


--

-- Name: message_recipients message_recipients_message_id_fkey; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_recipients
    ADD CONSTRAINT message_recipients_message_id_fkey FOREIGN KEY (message_id) REFERENCES communication.messages(id) ON DELETE CASCADE;


--

-- Name: message_recipients message_recipients_recipient_id_fkey; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_recipients
    ADD CONSTRAINT message_recipients_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES security.users(id);


--

-- Name: messages messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.messages
    ADD CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES security.users(id);


--

-- Name: user_notification_preferences user_notification_preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.user_notification_preferences
    ADD CONSTRAINT user_notification_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--



-- =========================================================================
-- core — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: application_consents application_consents_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_consents
    ADD CONSTRAINT application_consents_pkey PRIMARY KEY (id);


--

-- Name: amendment_requests pk_amendment_requests; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.amendment_requests
    ADD CONSTRAINT pk_amendment_requests PRIMARY KEY (id);


--

-- Name: application_amendments pk_application_amendments; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_amendments
    ADD CONSTRAINT pk_application_amendments PRIMARY KEY (id);


--

-- Name: application_checklists pk_application_checklists; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_checklists
    ADD CONSTRAINT pk_application_checklists PRIMARY KEY (id);


--

-- Name: application_history pk_application_history; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_history
    ADD CONSTRAINT pk_application_history PRIMARY KEY (id);


--

-- Name: application_sections pk_application_sections; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_sections
    ADD CONSTRAINT pk_application_sections PRIMARY KEY (id);


--

-- Name: application_validations pk_application_validations; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_validations
    ADD CONSTRAINT pk_application_validations PRIMARY KEY (id);


--

-- Name: application_versions pk_application_versions; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_versions
    ADD CONSTRAINT pk_application_versions PRIMARY KEY (id);


--

-- Name: applications pk_applications; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.applications
    ADD CONSTRAINT pk_applications PRIMARY KEY (id);


--

-- Name: closure_requests pk_closure_requests; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.closure_requests
    ADD CONSTRAINT pk_closure_requests PRIMARY KEY (id);


--

-- Name: project_attachments pk_project_attachments; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_attachments
    ADD CONSTRAINT pk_project_attachments PRIMARY KEY (id);


--

-- Name: project_funding_sources pk_project_funding_sources; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_funding_sources
    ADD CONSTRAINT pk_project_funding_sources PRIMARY KEY (id);


--

-- Name: project_keywords pk_project_keywords; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_keywords
    ADD CONSTRAINT pk_project_keywords PRIMARY KEY (id);


--

-- Name: project_site_investigators pk_project_site_investigators; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_site_investigators
    ADD CONSTRAINT pk_project_site_investigators PRIMARY KEY (id);


--

-- Name: project_sites pk_project_sites; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_sites
    ADD CONSTRAINT pk_project_sites PRIMARY KEY (id);


--

-- Name: project_status_history pk_project_status_history; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_status_history
    ADD CONSTRAINT pk_project_status_history PRIMARY KEY (id);


--

-- Name: project_tags pk_project_tags; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_tags
    ADD CONSTRAINT pk_project_tags PRIMARY KEY (id);


--

-- Name: project_team_members pk_project_team_members; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_team_members
    ADD CONSTRAINT pk_project_team_members PRIMARY KEY (id);


--

-- Name: project_versions pk_project_versions; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_versions
    ADD CONSTRAINT pk_project_versions PRIMARY KEY (id);


--

-- Name: projects pk_projects; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.projects
    ADD CONSTRAINT pk_projects PRIMARY KEY (id);


--

-- Name: renewal_requests pk_renewal_requests; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.renewal_requests
    ADD CONSTRAINT pk_renewal_requests PRIMARY KEY (id);


--

-- Name: research_categories pk_research_categories; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.research_categories
    ADD CONSTRAINT pk_research_categories PRIMARY KEY (id);


--

-- Name: research_population_links pk_research_population_links; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.research_population_links
    ADD CONSTRAINT pk_research_population_links PRIMARY KEY (id);


--

-- Name: risk_classifications pk_risk_classifications; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.risk_classifications
    ADD CONSTRAINT pk_risk_classifications PRIMARY KEY (id);


--

-- Name: vulnerable_populations pk_vulnerable_populations; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.vulnerable_populations
    ADD CONSTRAINT pk_vulnerable_populations PRIMARY KEY (id);


--

-- Name: application_consents uq_app_consent_version; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_consents
    ADD CONSTRAINT uq_app_consent_version UNIQUE (application_id, consent_version_id);


--

-- Name: application_versions uq_application_versions; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_versions
    ADD CONSTRAINT uq_application_versions UNIQUE (application_id, version_no);


--

-- Name: applications uq_applications_number; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.applications
    ADD CONSTRAINT uq_applications_number UNIQUE (application_number);


--

-- Name: project_team_members uq_project_member; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_team_members
    ADD CONSTRAINT uq_project_member UNIQUE (project_id, user_id);


--

-- Name: project_versions uq_project_version; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_versions
    ADD CONSTRAINT uq_project_version UNIQUE (project_id, version_no);


--

-- Name: projects uq_projects_code; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.projects
    ADD CONSTRAINT uq_projects_code UNIQUE (project_code);


--

-- Name: research_categories uq_research_categories_code; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.research_categories
    ADD CONSTRAINT uq_research_categories_code UNIQUE (code);


--

-- Name: research_population_links uq_research_population_links_uuid; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.research_population_links
    ADD CONSTRAINT uq_research_population_links_uuid UNIQUE (uuid);


--

-- Name: risk_classifications uq_risk_classifications_code; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.risk_classifications
    ADD CONSTRAINT uq_risk_classifications_code UNIQUE (code);


--

-- Name: vulnerable_populations uq_vulnerable_populations_code; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.vulnerable_populations
    ADD CONSTRAINT uq_vulnerable_populations_code UNIQUE (code);


--


-- =========================================================================
-- core — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: application_consents application_consents_application_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_consents
    ADD CONSTRAINT application_consents_application_id_fkey FOREIGN KEY (application_id) REFERENCES core.applications(id);


--

-- Name: application_consents application_consents_consent_version_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_consents
    ADD CONSTRAINT application_consents_consent_version_id_fkey FOREIGN KEY (consent_version_id) REFERENCES committee.consent_template_versions(id);


--

-- Name: application_consents application_consents_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_consents
    ADD CONSTRAINT application_consents_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES security.users(id);


--

-- Name: amendment_requests fk_amendment_requests_amendment; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.amendment_requests
    ADD CONSTRAINT fk_amendment_requests_amendment FOREIGN KEY (amendment_id) REFERENCES core.application_amendments(id) ON DELETE CASCADE;


--

-- Name: application_amendments fk_application_amendments_application; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_amendments
    ADD CONSTRAINT fk_application_amendments_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: application_checklists fk_application_checklists_application; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_checklists
    ADD CONSTRAINT fk_application_checklists_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: application_history fk_application_history_application; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_history
    ADD CONSTRAINT fk_application_history_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: application_sections fk_application_sections_application; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_sections
    ADD CONSTRAINT fk_application_sections_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: application_validations fk_application_validations_application; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_validations
    ADD CONSTRAINT fk_application_validations_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: application_versions fk_application_versions_application; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_versions
    ADD CONSTRAINT fk_application_versions_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: applications fk_applications_committee; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.applications
    ADD CONSTRAINT fk_applications_committee FOREIGN KEY (target_committee_id) REFERENCES committee.committees(id);


--

-- Name: applications fk_applications_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.applications
    ADD CONSTRAINT fk_applications_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--

-- Name: applications fk_applications_user; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.applications
    ADD CONSTRAINT fk_applications_user FOREIGN KEY (submitted_by) REFERENCES security.users(id);


--

-- Name: closure_requests fk_closure_requests_application; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.closure_requests
    ADD CONSTRAINT fk_closure_requests_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: project_attachments fk_project_attachment_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_attachments
    ADD CONSTRAINT fk_project_attachment_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--

-- Name: project_funding_sources fk_project_funding_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_funding_sources
    ADD CONSTRAINT fk_project_funding_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--

-- Name: project_keywords fk_project_keywords_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_keywords
    ADD CONSTRAINT fk_project_keywords_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--

-- Name: project_team_members fk_project_member_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_team_members
    ADD CONSTRAINT fk_project_member_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--

-- Name: project_team_members fk_project_member_user; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_team_members
    ADD CONSTRAINT fk_project_member_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--

-- Name: project_sites fk_project_sites_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_sites
    ADD CONSTRAINT fk_project_sites_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--

-- Name: project_status_history fk_project_status_history_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_status_history
    ADD CONSTRAINT fk_project_status_history_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--

-- Name: project_tags fk_project_tags_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_tags
    ADD CONSTRAINT fk_project_tags_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--

-- Name: project_versions fk_project_versions_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_versions
    ADD CONSTRAINT fk_project_versions_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--

-- Name: projects fk_projects_institution; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.projects
    ADD CONSTRAINT fk_projects_institution FOREIGN KEY (institution_id) REFERENCES security.institutions(id);


--

-- Name: projects fk_projects_pi; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.projects
    ADD CONSTRAINT fk_projects_pi FOREIGN KEY (principal_investigator_id) REFERENCES security.users(id);


--

-- Name: renewal_requests fk_renewal_requests_application; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.renewal_requests
    ADD CONSTRAINT fk_renewal_requests_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: research_population_links fk_research_population_links_population; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.research_population_links
    ADD CONSTRAINT fk_research_population_links_population FOREIGN KEY (vulnerable_population_id) REFERENCES core.vulnerable_populations(id);


--

-- Name: research_population_links fk_research_population_links_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.research_population_links
    ADD CONSTRAINT fk_research_population_links_project FOREIGN KEY (project_id) REFERENCES core.projects(id);


--

-- Name: project_site_investigators fk_site_inv_site; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_site_investigators
    ADD CONSTRAINT fk_site_inv_site FOREIGN KEY (site_id) REFERENCES core.project_sites(id) ON DELETE CASCADE;


--

-- Name: project_site_investigators fk_site_inv_user; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_site_investigators
    ADD CONSTRAINT fk_site_inv_user FOREIGN KEY (investigator_id) REFERENCES security.users(id);


--



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



-- =========================================================================
-- integration — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: data_sync_jobs pk_data_sync_jobs; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.data_sync_jobs
    ADD CONSTRAINT pk_data_sync_jobs PRIMARY KEY (id);


--

-- Name: event_bus_config pk_event_bus_config; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.event_bus_config
    ADD CONSTRAINT pk_event_bus_config PRIMARY KEY (id);


--

-- Name: event_outbox pk_event_outbox; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.event_outbox
    ADD CONSTRAINT pk_event_outbox PRIMARY KEY (id);


--

-- Name: event_subscriptions pk_event_subscriptions; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.event_subscriptions
    ADD CONSTRAINT pk_event_subscriptions PRIMARY KEY (id);


--

-- Name: external_systems pk_external_systems; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.external_systems
    ADD CONSTRAINT pk_external_systems PRIMARY KEY (id);


--

-- Name: integration_credentials pk_integration_credentials; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_credentials
    ADD CONSTRAINT pk_integration_credentials PRIMARY KEY (id);


--

-- Name: integration_failures pk_integration_failures; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_failures
    ADD CONSTRAINT pk_integration_failures PRIMARY KEY (id);


--

-- Name: integration_logs pk_integration_logs; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_logs
    ADD CONSTRAINT pk_integration_logs PRIMARY KEY (id);


--

-- Name: retry_queue pk_retry_queue; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.retry_queue
    ADD CONSTRAINT pk_retry_queue PRIMARY KEY (id);


--

-- Name: webhooks pk_webhooks; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.webhooks
    ADD CONSTRAINT pk_webhooks PRIMARY KEY (id);


--

-- Name: data_sync_jobs uq_data_sync_jobs_uuid; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.data_sync_jobs
    ADD CONSTRAINT uq_data_sync_jobs_uuid UNIQUE (uuid);


--

-- Name: event_bus_config uq_event_bus_config_key; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.event_bus_config
    ADD CONSTRAINT uq_event_bus_config_key UNIQUE (config_key);


--

-- Name: event_outbox uq_event_outbox_event_id; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.event_outbox
    ADD CONSTRAINT uq_event_outbox_event_id UNIQUE (event_id);


--

-- Name: external_systems uq_external_systems_code; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.external_systems
    ADD CONSTRAINT uq_external_systems_code UNIQUE (code);


--


-- =========================================================================
-- integration — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: data_sync_jobs fk_data_sync_jobs_system; Type: FK CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.data_sync_jobs
    ADD CONSTRAINT fk_data_sync_jobs_system FOREIGN KEY (external_system_id) REFERENCES integration.external_systems(id) ON DELETE CASCADE;


--

-- Name: integration_credentials fk_integration_credentials_system; Type: FK CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_credentials
    ADD CONSTRAINT fk_integration_credentials_system FOREIGN KEY (external_system_id) REFERENCES integration.external_systems(id) ON DELETE CASCADE;


--

-- Name: integration_failures fk_integration_failures_resolved_by; Type: FK CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_failures
    ADD CONSTRAINT fk_integration_failures_resolved_by FOREIGN KEY (resolved_by) REFERENCES security.users(id) ON DELETE SET NULL;


--

-- Name: integration_failures fk_integration_failures_system; Type: FK CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_failures
    ADD CONSTRAINT fk_integration_failures_system FOREIGN KEY (external_system_id) REFERENCES integration.external_systems(id) ON DELETE SET NULL;


--

-- Name: integration_logs fk_integration_logs_user; Type: FK CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_logs
    ADD CONSTRAINT fk_integration_logs_user FOREIGN KEY (created_by) REFERENCES security.users(id);


--



-- =========================================================================
-- monitoring — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: compliance_reviews pk_compliance_reviews; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.compliance_reviews
    ADD CONSTRAINT pk_compliance_reviews PRIMARY KEY (id);


--

-- Name: corrective_actions pk_corrective_actions; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.corrective_actions
    ADD CONSTRAINT pk_corrective_actions PRIMARY KEY (id);


--

-- Name: deviations pk_deviations; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.deviations
    ADD CONSTRAINT pk_deviations PRIMARY KEY (id);


--

-- Name: inspection_reports pk_inspection_reports; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.inspection_reports
    ADD CONSTRAINT pk_inspection_reports PRIMARY KEY (id);


--

-- Name: inspections pk_inspections; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.inspections
    ADD CONSTRAINT pk_inspections PRIMARY KEY (id);


--

-- Name: monitoring_findings pk_monitoring_findings; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.monitoring_findings
    ADD CONSTRAINT pk_monitoring_findings PRIMARY KEY (id);


--

-- Name: monitoring_plans pk_monitoring_plans; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.monitoring_plans
    ADD CONSTRAINT pk_monitoring_plans PRIMARY KEY (id);


--

-- Name: monitoring_visits pk_monitoring_visits; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.monitoring_visits
    ADD CONSTRAINT pk_monitoring_visits PRIMARY KEY (id);


--

-- Name: preventive_actions pk_preventive_actions; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.preventive_actions
    ADD CONSTRAINT pk_preventive_actions PRIMARY KEY (id);


--

-- Name: protocol_violations pk_protocol_violations; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.protocol_violations
    ADD CONSTRAINT pk_protocol_violations PRIMARY KEY (id);


--

-- Name: monitoring_plans uq_monitoring_plan_code; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.monitoring_plans
    ADD CONSTRAINT uq_monitoring_plan_code UNIQUE (plan_code);


--


-- =========================================================================
-- monitoring — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: compliance_reviews fk_compliance_reviews_application; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.compliance_reviews
    ADD CONSTRAINT fk_compliance_reviews_application FOREIGN KEY (application_id) REFERENCES core.applications(id);


--

-- Name: compliance_reviews fk_compliance_reviews_reviewer; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.compliance_reviews
    ADD CONSTRAINT fk_compliance_reviews_reviewer FOREIGN KEY (reviewer_id) REFERENCES security.users(id);


--

-- Name: corrective_actions fk_corrective_actions_finding; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.corrective_actions
    ADD CONSTRAINT fk_corrective_actions_finding FOREIGN KEY (finding_id) REFERENCES monitoring.monitoring_findings(id) ON DELETE CASCADE;


--

-- Name: deviations fk_deviations_application; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.deviations
    ADD CONSTRAINT fk_deviations_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: inspection_reports fk_inspection_reports_inspection; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.inspection_reports
    ADD CONSTRAINT fk_inspection_reports_inspection FOREIGN KEY (inspection_id) REFERENCES monitoring.inspections(id) ON DELETE CASCADE;


--

-- Name: inspections fk_inspections_application; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.inspections
    ADD CONSTRAINT fk_inspections_application FOREIGN KEY (application_id) REFERENCES core.applications(id);


--

-- Name: inspections fk_inspections_inspector; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.inspections
    ADD CONSTRAINT fk_inspections_inspector FOREIGN KEY (inspector_id) REFERENCES security.users(id);


--

-- Name: monitoring_findings fk_monitoring_findings_visit; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.monitoring_findings
    ADD CONSTRAINT fk_monitoring_findings_visit FOREIGN KEY (monitoring_visit_id) REFERENCES monitoring.monitoring_visits(id) ON DELETE CASCADE;


--

-- Name: monitoring_plans fk_monitoring_plan_application; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.monitoring_plans
    ADD CONSTRAINT fk_monitoring_plan_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: monitoring_visits fk_monitoring_visits_monitor; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.monitoring_visits
    ADD CONSTRAINT fk_monitoring_visits_monitor FOREIGN KEY (monitor_id) REFERENCES security.users(id);


--

-- Name: monitoring_visits fk_monitoring_visits_plan; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.monitoring_visits
    ADD CONSTRAINT fk_monitoring_visits_plan FOREIGN KEY (monitoring_plan_id) REFERENCES monitoring.monitoring_plans(id) ON DELETE CASCADE;


--

-- Name: preventive_actions fk_preventive_actions_finding; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.preventive_actions
    ADD CONSTRAINT fk_preventive_actions_finding FOREIGN KEY (finding_id) REFERENCES monitoring.monitoring_findings(id) ON DELETE CASCADE;


--

-- Name: protocol_violations fk_protocol_violations_application; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.protocol_violations
    ADD CONSTRAINT fk_protocol_violations_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--



-- =========================================================================
-- public — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: pgmigrations pgmigrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pgmigrations
    ADD CONSTRAINT pgmigrations_pkey PRIMARY KEY (id);


--



-- =========================================================================
-- reference — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: academic_titles academic_titles_code_key; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.academic_titles
    ADD CONSTRAINT academic_titles_code_key UNIQUE (code);


--

-- Name: academic_titles academic_titles_pkey; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.academic_titles
    ADD CONSTRAINT academic_titles_pkey PRIMARY KEY (id);


--

-- Name: application_statuses pk_application_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.application_statuses
    ADD CONSTRAINT pk_application_statuses PRIMARY KEY (id);


--

-- Name: committee_decision_types pk_committee_decision_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.committee_decision_types
    ADD CONSTRAINT pk_committee_decision_types PRIMARY KEY (id);


--

-- Name: document_statuses pk_document_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.document_statuses
    ADD CONSTRAINT pk_document_statuses PRIMARY KEY (id);


--

-- Name: institutions_registry pk_institutions_registry; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.institutions_registry
    ADD CONSTRAINT pk_institutions_registry PRIMARY KEY (id);


--

-- Name: licenses_registry pk_licenses_registry; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT pk_licenses_registry PRIMARY KEY (id);


--

-- Name: lookup_categories pk_lookup_categories; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.lookup_categories
    ADD CONSTRAINT pk_lookup_categories PRIMARY KEY (id);


--

-- Name: lookup_values pk_lookup_values; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.lookup_values
    ADD CONSTRAINT pk_lookup_values PRIMARY KEY (id);


--

-- Name: notification_statuses pk_notification_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.notification_statuses
    ADD CONSTRAINT pk_notification_statuses PRIMARY KEY (id);


--

-- Name: priority_levels pk_priority_levels; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.priority_levels
    ADD CONSTRAINT pk_priority_levels PRIMARY KEY (id);


--

-- Name: professions_registry pk_professions_registry; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.professions_registry
    ADD CONSTRAINT pk_professions_registry PRIMARY KEY (id);


--

-- Name: review_statuses pk_review_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.review_statuses
    ADD CONSTRAINT pk_review_statuses PRIMARY KEY (id);


--

-- Name: risk_levels pk_risk_levels; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.risk_levels
    ADD CONSTRAINT pk_risk_levels PRIMARY KEY (id);


--

-- Name: status_types pk_status_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.status_types
    ADD CONSTRAINT pk_status_types PRIMARY KEY (id);


--

-- Name: vote_types pk_vote_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.vote_types
    ADD CONSTRAINT pk_vote_types PRIMARY KEY (id);


--

-- Name: workflow_statuses pk_workflow_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.workflow_statuses
    ADD CONSTRAINT pk_workflow_statuses PRIMARY KEY (id);


--

-- Name: application_statuses uq_application_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.application_statuses
    ADD CONSTRAINT uq_application_statuses UNIQUE (status_code);


--

-- Name: committee_decision_types uq_committee_decision_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.committee_decision_types
    ADD CONSTRAINT uq_committee_decision_types UNIQUE (decision_code);


--

-- Name: document_statuses uq_document_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.document_statuses
    ADD CONSTRAINT uq_document_statuses UNIQUE (status_code);


--

-- Name: institutions_registry uq_institutions_registry_national_id; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.institutions_registry
    ADD CONSTRAINT uq_institutions_registry_national_id UNIQUE (national_id);


--

-- Name: institutions_registry uq_institutions_registry_uuid; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.institutions_registry
    ADD CONSTRAINT uq_institutions_registry_uuid UNIQUE (uuid);


--

-- Name: licenses_registry uq_licenses_registry_license_number; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT uq_licenses_registry_license_number UNIQUE (license_number);


--

-- Name: licenses_registry uq_licenses_registry_uuid; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT uq_licenses_registry_uuid UNIQUE (uuid);


--

-- Name: lookup_categories uq_lookup_categories; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.lookup_categories
    ADD CONSTRAINT uq_lookup_categories UNIQUE (category_code);


--

-- Name: lookup_values uq_lookup_values; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.lookup_values
    ADD CONSTRAINT uq_lookup_values UNIQUE (category_id, value_code);


--

-- Name: notification_statuses uq_notification_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.notification_statuses
    ADD CONSTRAINT uq_notification_statuses UNIQUE (status_code);


--

-- Name: priority_levels uq_priority_levels; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.priority_levels
    ADD CONSTRAINT uq_priority_levels UNIQUE (priority_code);


--

-- Name: professions_registry uq_professions_registry_code; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.professions_registry
    ADD CONSTRAINT uq_professions_registry_code UNIQUE (code);


--

-- Name: review_statuses uq_review_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.review_statuses
    ADD CONSTRAINT uq_review_statuses UNIQUE (status_code);


--

-- Name: risk_levels uq_risk_levels; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.risk_levels
    ADD CONSTRAINT uq_risk_levels UNIQUE (risk_code);


--

-- Name: status_types uq_status_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.status_types
    ADD CONSTRAINT uq_status_types UNIQUE (status_type_code);


--

-- Name: vote_types uq_vote_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.vote_types
    ADD CONSTRAINT uq_vote_types UNIQUE (vote_code);


--

-- Name: workflow_statuses uq_workflow_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.workflow_statuses
    ADD CONSTRAINT uq_workflow_statuses UNIQUE (status_code);


--


-- =========================================================================
-- reference — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: licenses_registry fk_licenses_registry_profession; Type: FK CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT fk_licenses_registry_profession FOREIGN KEY (profession_id) REFERENCES reference.professions_registry(id);


--

-- Name: licenses_registry fk_licenses_registry_user; Type: FK CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT fk_licenses_registry_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--

-- Name: licenses_registry fk_licenses_registry_verified_by; Type: FK CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT fk_licenses_registry_verified_by FOREIGN KEY (verified_by) REFERENCES security.users(id);


--

-- Name: lookup_values fk_lookup_values_category; Type: FK CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.lookup_values
    ADD CONSTRAINT fk_lookup_values_category FOREIGN KEY (category_id) REFERENCES reference.lookup_categories(id) ON DELETE CASCADE;


--



-- =========================================================================
-- reporting — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: analytics_snapshots pk_analytics_snapshots; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.analytics_snapshots
    ADD CONSTRAINT pk_analytics_snapshots PRIMARY KEY (id);


--

-- Name: dashboard_widgets pk_dashboard_widgets; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.dashboard_widgets
    ADD CONSTRAINT pk_dashboard_widgets PRIMARY KEY (id);


--

-- Name: kpi_results pk_kpi_results; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.kpi_results
    ADD CONSTRAINT pk_kpi_results PRIMARY KEY (id);


--

-- Name: report_definitions pk_report_definitions; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.report_definitions
    ADD CONSTRAINT pk_report_definitions PRIMARY KEY (id);


--

-- Name: report_executions pk_report_executions; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.report_executions
    ADD CONSTRAINT pk_report_executions PRIMARY KEY (id);


--

-- Name: dashboard_widgets uq_dashboard_widgets; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.dashboard_widgets
    ADD CONSTRAINT uq_dashboard_widgets UNIQUE (widget_code);


--

-- Name: report_definitions uq_report_definitions; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.report_definitions
    ADD CONSTRAINT uq_report_definitions UNIQUE (report_code);


--


-- =========================================================================
-- reporting — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: report_executions fk_report_executions_report; Type: FK CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.report_executions
    ADD CONSTRAINT fk_report_executions_report FOREIGN KEY (report_id) REFERENCES reporting.report_definitions(id);


--

-- Name: report_executions fk_report_executions_user; Type: FK CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.report_executions
    ADD CONSTRAINT fk_report_executions_user FOREIGN KEY (executed_by) REFERENCES security.users(id);


--



-- =========================================================================
-- safety — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: adverse_events pk_adverse_events; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.adverse_events
    ADD CONSTRAINT pk_adverse_events PRIMARY KEY (id);


--

-- Name: corrective_actions pk_corrective_actions; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.corrective_actions
    ADD CONSTRAINT pk_corrective_actions PRIMARY KEY (id);


--

-- Name: mitigation_actions pk_mitigation_actions; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.mitigation_actions
    ADD CONSTRAINT pk_mitigation_actions PRIMARY KEY (id);


--

-- Name: risk_assessments pk_risk_assessments; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_assessments
    ADD CONSTRAINT pk_risk_assessments PRIMARY KEY (id);


--

-- Name: risk_categories pk_risk_categories; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_categories
    ADD CONSTRAINT pk_risk_categories PRIMARY KEY (id);


--

-- Name: risk_incidents pk_risk_incidents; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_incidents
    ADD CONSTRAINT pk_risk_incidents PRIMARY KEY (id);


--

-- Name: risk_mitigations pk_risk_mitigations; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_mitigations
    ADD CONSTRAINT pk_risk_mitigations PRIMARY KEY (id);


--

-- Name: risk_register pk_risk_register; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_register
    ADD CONSTRAINT pk_risk_register PRIMARY KEY (id);


--

-- Name: safety_committee_reviews pk_safety_committee_reviews; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_committee_reviews
    ADD CONSTRAINT pk_safety_committee_reviews PRIMARY KEY (id);


--

-- Name: safety_followups pk_safety_followups; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_followups
    ADD CONSTRAINT pk_safety_followups PRIMARY KEY (id);


--

-- Name: safety_reports pk_safety_reports; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_reports
    ADD CONSTRAINT pk_safety_reports PRIMARY KEY (id);


--

-- Name: serious_adverse_events pk_serious_adverse_events; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.serious_adverse_events
    ADD CONSTRAINT pk_serious_adverse_events PRIMARY KEY (id);


--

-- Name: adverse_events uq_adverse_events_number; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.adverse_events
    ADD CONSTRAINT uq_adverse_events_number UNIQUE (event_number);


--

-- Name: corrective_actions uq_corrective_actions_code; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.corrective_actions
    ADD CONSTRAINT uq_corrective_actions_code UNIQUE (action_code);


--

-- Name: corrective_actions uq_corrective_actions_uuid; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.corrective_actions
    ADD CONSTRAINT uq_corrective_actions_uuid UNIQUE (uuid);


--

-- Name: risk_categories uq_risk_categories_code; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_categories
    ADD CONSTRAINT uq_risk_categories_code UNIQUE (category_code);


--

-- Name: risk_incidents uq_risk_incidents_code; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_incidents
    ADD CONSTRAINT uq_risk_incidents_code UNIQUE (incident_code);


--

-- Name: risk_incidents uq_risk_incidents_uuid; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_incidents
    ADD CONSTRAINT uq_risk_incidents_uuid UNIQUE (uuid);


--

-- Name: risk_mitigations uq_risk_mitigations_uuid; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_mitigations
    ADD CONSTRAINT uq_risk_mitigations_uuid UNIQUE (uuid);


--

-- Name: risk_register uq_risk_register_code; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_register
    ADD CONSTRAINT uq_risk_register_code UNIQUE (risk_code);


--

-- Name: risk_register uq_risk_register_uuid; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_register
    ADD CONSTRAINT uq_risk_register_uuid UNIQUE (uuid);


--

-- Name: safety_reports uq_safety_reports_number; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_reports
    ADD CONSTRAINT uq_safety_reports_number UNIQUE (report_number);


--


-- =========================================================================
-- safety — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: adverse_events fk_adverse_events_application; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.adverse_events
    ADD CONSTRAINT fk_adverse_events_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: adverse_events fk_adverse_events_reported_by; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.adverse_events
    ADD CONSTRAINT fk_adverse_events_reported_by FOREIGN KEY (reported_by) REFERENCES security.users(id);


--

-- Name: corrective_actions fk_corrective_actions_assigned_to; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.corrective_actions
    ADD CONSTRAINT fk_corrective_actions_assigned_to FOREIGN KEY (assigned_to) REFERENCES security.users(id);


--

-- Name: corrective_actions fk_corrective_actions_incident; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.corrective_actions
    ADD CONSTRAINT fk_corrective_actions_incident FOREIGN KEY (incident_id) REFERENCES safety.risk_incidents(id);


--

-- Name: mitigation_actions fk_mitigation_actions_assessment; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.mitigation_actions
    ADD CONSTRAINT fk_mitigation_actions_assessment FOREIGN KEY (risk_assessment_id) REFERENCES safety.risk_assessments(id) ON DELETE CASCADE;


--

-- Name: mitigation_actions fk_mitigation_actions_category; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.mitigation_actions
    ADD CONSTRAINT fk_mitigation_actions_category FOREIGN KEY (risk_category_id) REFERENCES safety.risk_categories(id);


--

-- Name: mitigation_actions fk_mitigation_actions_user; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.mitigation_actions
    ADD CONSTRAINT fk_mitigation_actions_user FOREIGN KEY (responsible_user_id) REFERENCES security.users(id);


--

-- Name: risk_assessments fk_risk_assessments_application; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_assessments
    ADD CONSTRAINT fk_risk_assessments_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: risk_assessments fk_risk_assessments_user; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_assessments
    ADD CONSTRAINT fk_risk_assessments_user FOREIGN KEY (assessed_by) REFERENCES security.users(id);


--

-- Name: risk_incidents fk_risk_incidents_reported_by; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_incidents
    ADD CONSTRAINT fk_risk_incidents_reported_by FOREIGN KEY (reported_by) REFERENCES security.users(id);


--

-- Name: risk_incidents fk_risk_incidents_risk; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_incidents
    ADD CONSTRAINT fk_risk_incidents_risk FOREIGN KEY (risk_id) REFERENCES safety.risk_register(id);


--

-- Name: risk_mitigations fk_risk_mitigations_responsible; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_mitigations
    ADD CONSTRAINT fk_risk_mitigations_responsible FOREIGN KEY (responsible_party) REFERENCES security.users(id);


--

-- Name: risk_mitigations fk_risk_mitigations_risk; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_mitigations
    ADD CONSTRAINT fk_risk_mitigations_risk FOREIGN KEY (risk_id) REFERENCES safety.risk_register(id);


--

-- Name: risk_register fk_risk_register_category; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_register
    ADD CONSTRAINT fk_risk_register_category FOREIGN KEY (risk_category_id) REFERENCES safety.risk_categories(id);


--

-- Name: risk_register fk_risk_register_identified_by; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_register
    ADD CONSTRAINT fk_risk_register_identified_by FOREIGN KEY (identified_by) REFERENCES security.users(id);


--

-- Name: risk_register fk_risk_register_owner; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_register
    ADD CONSTRAINT fk_risk_register_owner FOREIGN KEY (owner_id) REFERENCES security.users(id);


--

-- Name: risk_register fk_risk_register_reviewed_by; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_register
    ADD CONSTRAINT fk_risk_register_reviewed_by FOREIGN KEY (reviewed_by) REFERENCES security.users(id);


--

-- Name: safety_committee_reviews fk_safety_committee_reviews_application; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_committee_reviews
    ADD CONSTRAINT fk_safety_committee_reviews_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: safety_committee_reviews fk_safety_committee_reviews_committee; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_committee_reviews
    ADD CONSTRAINT fk_safety_committee_reviews_committee FOREIGN KEY (committee_id) REFERENCES committee.committees(id);


--

-- Name: safety_committee_reviews fk_safety_committee_reviews_user; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_committee_reviews
    ADD CONSTRAINT fk_safety_committee_reviews_user FOREIGN KEY (reviewed_by) REFERENCES security.users(id);


--

-- Name: safety_followups fk_safety_followups_event; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_followups
    ADD CONSTRAINT fk_safety_followups_event FOREIGN KEY (adverse_event_id) REFERENCES safety.adverse_events(id) ON DELETE CASCADE;


--

-- Name: safety_reports fk_safety_reports_application; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_reports
    ADD CONSTRAINT fk_safety_reports_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--

-- Name: safety_reports fk_safety_reports_user; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_reports
    ADD CONSTRAINT fk_safety_reports_user FOREIGN KEY (submitted_by) REFERENCES security.users(id);


--

-- Name: serious_adverse_events fk_serious_adverse_events_event; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.serious_adverse_events
    ADD CONSTRAINT fk_serious_adverse_events_event FOREIGN KEY (adverse_event_id) REFERENCES safety.adverse_events(id) ON DELETE CASCADE;


--



-- =========================================================================
-- security — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: approval_authorities approval_authorities_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.approval_authorities
    ADD CONSTRAINT approval_authorities_pkey PRIMARY KEY (id);


--

-- Name: approval_limits approval_limits_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.approval_limits
    ADD CONSTRAINT approval_limits_pkey PRIMARY KEY (id);


--

-- Name: certificate_revocations certificate_revocations_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.certificate_revocations
    ADD CONSTRAINT certificate_revocations_pkey PRIMARY KEY (id);


--

-- Name: digital_certificates digital_certificates_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.digital_certificates
    ADD CONSTRAINT digital_certificates_pkey PRIMARY KEY (id);


--

-- Name: digital_certificates digital_certificates_serial_number_key; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.digital_certificates
    ADD CONSTRAINT digital_certificates_serial_number_key UNIQUE (serial_number);


--

-- Name: email_verification_tokens email_verification_tokens_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.email_verification_tokens
    ADD CONSTRAINT email_verification_tokens_pkey PRIMARY KEY (id);


--

-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (id);


--

-- Name: access_policies pk_access_policies; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.access_policies
    ADD CONSTRAINT pk_access_policies PRIMARY KEY (id);


--

-- Name: api_keys pk_api_keys; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.api_keys
    ADD CONSTRAINT pk_api_keys PRIMARY KEY (id);


--

-- Name: departments pk_departments; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.departments
    ADD CONSTRAINT pk_departments PRIMARY KEY (id);


--

-- Name: institution_types pk_institution_types; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.institution_types
    ADD CONSTRAINT pk_institution_types PRIMARY KEY (id);


--

-- Name: institutions pk_institutions; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.institutions
    ADD CONSTRAINT pk_institutions PRIMARY KEY (id);


--

-- Name: login_audit pk_login_audit; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.login_audit
    ADD CONSTRAINT pk_login_audit PRIMARY KEY (id);


--

-- Name: password_history pk_password_history; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.password_history
    ADD CONSTRAINT pk_password_history PRIMARY KEY (id);


--

-- Name: permissions pk_permissions; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.permissions
    ADD CONSTRAINT pk_permissions PRIMARY KEY (id);


--

-- Name: responsibility_types pk_responsibility_types; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.responsibility_types
    ADD CONSTRAINT pk_responsibility_types PRIMARY KEY (id);


--

-- Name: roles pk_roles; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.roles
    ADD CONSTRAINT pk_roles PRIMARY KEY (id);


--

-- Name: security_events pk_security_events; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.security_events
    ADD CONSTRAINT pk_security_events PRIMARY KEY (id);


--

-- Name: sessions pk_sessions; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.sessions
    ADD CONSTRAINT pk_sessions PRIMARY KEY (id);


--

-- Name: user_profiles pk_user_profiles; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_profiles
    ADD CONSTRAINT pk_user_profiles PRIMARY KEY (id);


--

-- Name: user_responsibilities pk_user_responsibilities; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT pk_user_responsibilities PRIMARY KEY (id);


--

-- Name: user_roles pk_user_roles; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_roles
    ADD CONSTRAINT pk_user_roles PRIMARY KEY (id);


--

-- Name: users pk_users; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT pk_users PRIMARY KEY (id);


--

-- Name: policy_conditions policy_conditions_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.policy_conditions
    ADD CONSTRAINT policy_conditions_pkey PRIMARY KEY (id);


--

-- Name: policy_rules policy_rules_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.policy_rules
    ADD CONSTRAINT policy_rules_pkey PRIMARY KEY (id);


--

-- Name: role_delegations role_delegations_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.role_delegations
    ADD CONSTRAINT role_delegations_pkey PRIMARY KEY (id);


--

-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--

-- Name: segregation_rules segregation_rules_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.segregation_rules
    ADD CONSTRAINT segregation_rules_pkey PRIMARY KEY (id);


--

-- Name: access_policies uq_access_policy_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.access_policies
    ADD CONSTRAINT uq_access_policy_code UNIQUE (policy_code);


--

-- Name: departments uq_departments_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.departments
    ADD CONSTRAINT uq_departments_code UNIQUE (institution_id, code);


--

-- Name: institution_types uq_institution_types_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.institution_types
    ADD CONSTRAINT uq_institution_types_code UNIQUE (code);


--

-- Name: institutions uq_institutions_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.institutions
    ADD CONSTRAINT uq_institutions_code UNIQUE (code);


--

-- Name: permissions uq_permissions_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.permissions
    ADD CONSTRAINT uq_permissions_code UNIQUE (permission_code);


--

-- Name: responsibility_types uq_responsibility_types_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.responsibility_types
    ADD CONSTRAINT uq_responsibility_types_code UNIQUE (code);


--

-- Name: roles uq_roles_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.roles
    ADD CONSTRAINT uq_roles_code UNIQUE (code);


--

-- Name: sessions uq_session_token; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.sessions
    ADD CONSTRAINT uq_session_token UNIQUE (session_token);


--

-- Name: user_profiles uq_user_profiles_user; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_profiles
    ADD CONSTRAINT uq_user_profiles_user UNIQUE (user_id);


--

-- Name: user_responsibilities uq_user_responsibilities_uuid; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT uq_user_responsibilities_uuid UNIQUE (uuid);


--

-- Name: user_roles uq_user_role; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_roles
    ADD CONSTRAINT uq_user_role UNIQUE (user_id, role_id);


--

-- Name: users uq_users_email; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT uq_users_email UNIQUE (email);


--

-- Name: users uq_users_username; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT uq_users_username UNIQUE (username);


--

-- Name: users uq_users_uuid; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT uq_users_uuid UNIQUE (uuid);


--


-- =========================================================================
-- security — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: email_verification_tokens email_verification_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.email_verification_tokens
    ADD CONSTRAINT email_verification_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--

-- Name: api_keys fk_api_keys_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.api_keys
    ADD CONSTRAINT fk_api_keys_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--

-- Name: departments fk_departments_institution; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.departments
    ADD CONSTRAINT fk_departments_institution FOREIGN KEY (institution_id) REFERENCES security.institutions(id) ON DELETE CASCADE;


--

-- Name: institutions fk_institutions_type; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.institutions
    ADD CONSTRAINT fk_institutions_type FOREIGN KEY (institution_type_id) REFERENCES security.institution_types(id) ON DELETE RESTRICT;


--

-- Name: login_audit fk_login_audit_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.login_audit
    ADD CONSTRAINT fk_login_audit_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE SET NULL;


--

-- Name: password_history fk_password_history_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.password_history
    ADD CONSTRAINT fk_password_history_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--

-- Name: role_permissions fk_role_permissions_permission; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.role_permissions
    ADD CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id) REFERENCES security.permissions(id) ON DELETE CASCADE;


--

-- Name: role_permissions fk_role_permissions_role; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.role_permissions
    ADD CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES security.roles(id) ON DELETE CASCADE;


--

-- Name: security_events fk_security_events_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.security_events
    ADD CONSTRAINT fk_security_events_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE SET NULL;


--

-- Name: sessions fk_sessions_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.sessions
    ADD CONSTRAINT fk_sessions_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--

-- Name: user_profiles fk_user_profiles_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_profiles
    ADD CONSTRAINT fk_user_profiles_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--

-- Name: user_responsibilities fk_user_responsibilities_assigned_by; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT fk_user_responsibilities_assigned_by FOREIGN KEY (assigned_by) REFERENCES security.users(id);


--

-- Name: user_responsibilities fk_user_responsibilities_revoked_by; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT fk_user_responsibilities_revoked_by FOREIGN KEY (revoked_by) REFERENCES security.users(id);


--

-- Name: user_responsibilities fk_user_responsibilities_type; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT fk_user_responsibilities_type FOREIGN KEY (responsibility_type_id) REFERENCES security.responsibility_types(id);


--

-- Name: user_responsibilities fk_user_responsibilities_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT fk_user_responsibilities_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--

-- Name: user_roles fk_user_roles_role; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_roles
    ADD CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES security.roles(id) ON DELETE CASCADE;


--

-- Name: user_roles fk_user_roles_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_roles
    ADD CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--

-- Name: users fk_users_department; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT fk_users_department FOREIGN KEY (department_id) REFERENCES security.departments(id);


--

-- Name: users fk_users_institution; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT fk_users_institution FOREIGN KEY (institution_id) REFERENCES security.institutions(id);


--

-- Name: password_reset_tokens password_reset_tokens_created_by_fkey; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_created_by_fkey FOREIGN KEY (created_by) REFERENCES security.users(id);


--

-- Name: password_reset_tokens password_reset_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--

-- Name: user_profiles user_profiles_academic_title_id_fkey; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_profiles
    ADD CONSTRAINT user_profiles_academic_title_id_fkey FOREIGN KEY (academic_title_id) REFERENCES reference.academic_titles(id);


--



-- =========================================================================
-- system — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--

-- Name: business_rules business_rules_code_key; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.business_rules
    ADD CONSTRAINT business_rules_code_key UNIQUE (code);


--

-- Name: business_rules business_rules_pkey; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.business_rules
    ADD CONSTRAINT business_rules_pkey PRIMARY KEY (id);


--

-- Name: feature_flags feature_flags_code_key; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.feature_flags
    ADD CONSTRAINT feature_flags_code_key UNIQUE (code);


--

-- Name: feature_flags feature_flags_pkey; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.feature_flags
    ADD CONSTRAINT feature_flags_pkey PRIMARY KEY (id);


--

-- Name: audit_config pk_audit_config; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.audit_config
    ADD CONSTRAINT pk_audit_config PRIMARY KEY (id);


--

-- Name: email_config pk_email_config; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.email_config
    ADD CONSTRAINT pk_email_config PRIMARY KEY (id);


--

-- Name: maintenance_log pk_maintenance_log; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.maintenance_log
    ADD CONSTRAINT pk_maintenance_log PRIMARY KEY (id);


--

-- Name: rule_actions pk_rule_actions; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_actions
    ADD CONSTRAINT pk_rule_actions PRIMARY KEY (id);


--

-- Name: rule_conditions pk_rule_conditions; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_conditions
    ADD CONSTRAINT pk_rule_conditions PRIMARY KEY (id);


--

-- Name: rule_executions pk_rule_executions; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_executions
    ADD CONSTRAINT pk_rule_executions PRIMARY KEY (id);


--

-- Name: saved_searches pk_saved_searches; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.saved_searches
    ADD CONSTRAINT pk_saved_searches PRIMARY KEY (id);


--

-- Name: search_audit pk_search_audit; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.search_audit
    ADD CONSTRAINT pk_search_audit PRIMARY KEY (id);


--

-- Name: search_indexes pk_search_indexes; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.search_indexes
    ADD CONSTRAINT pk_search_indexes PRIMARY KEY (id);


--

-- Name: sms_config pk_sms_config; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.sms_config
    ADD CONSTRAINT pk_sms_config PRIMARY KEY (id);


--

-- Name: system_config pk_system_config; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.system_config
    ADD CONSTRAINT pk_system_config PRIMARY KEY (id);


--

-- Name: push_config push_config_pkey; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.push_config
    ADD CONSTRAINT push_config_pkey PRIMARY KEY (id);


--

-- Name: rule_versions rule_versions_pkey; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_versions
    ADD CONSTRAINT rule_versions_pkey PRIMARY KEY (id);


--

-- Name: audit_config uq_audit_config_entity; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.audit_config
    ADD CONSTRAINT uq_audit_config_entity UNIQUE (entity_name);


--

-- Name: saved_searches uq_saved_searches_uuid; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.saved_searches
    ADD CONSTRAINT uq_saved_searches_uuid UNIQUE (uuid);


--

-- Name: system_config uq_system_config_key; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.system_config
    ADD CONSTRAINT uq_system_config_key UNIQUE (config_key);


--


-- =========================================================================
-- system — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: audit_log audit_log_user_id_fkey; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.audit_log
    ADD CONSTRAINT audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES security.users(id);


--

-- Name: maintenance_log fk_maintenance_log_user; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.maintenance_log
    ADD CONSTRAINT fk_maintenance_log_user FOREIGN KEY (performed_by) REFERENCES security.users(id);


--

-- Name: rule_actions fk_rule_actions_rule; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_actions
    ADD CONSTRAINT fk_rule_actions_rule FOREIGN KEY (rule_id) REFERENCES system.business_rules(id) ON DELETE CASCADE;


--

-- Name: rule_conditions fk_rule_conditions_rule; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_conditions
    ADD CONSTRAINT fk_rule_conditions_rule FOREIGN KEY (rule_id) REFERENCES system.business_rules(id) ON DELETE CASCADE;


--

-- Name: rule_executions fk_rule_executions_rule; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_executions
    ADD CONSTRAINT fk_rule_executions_rule FOREIGN KEY (rule_id) REFERENCES system.business_rules(id) ON DELETE CASCADE;


--

-- Name: rule_executions fk_rule_executions_triggered_by; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_executions
    ADD CONSTRAINT fk_rule_executions_triggered_by FOREIGN KEY (triggered_by) REFERENCES security.users(id) ON DELETE SET NULL;


--

-- Name: saved_searches fk_saved_searches_user; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.saved_searches
    ADD CONSTRAINT fk_saved_searches_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--

-- Name: search_audit fk_search_audit_user; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.search_audit
    ADD CONSTRAINT fk_search_audit_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE SET NULL;


--



-- =========================================================================
-- workflow — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: workflow_actions pk_workflow_actions; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_actions
    ADD CONSTRAINT pk_workflow_actions PRIMARY KEY (id);


--

-- Name: workflow_comments pk_workflow_comments; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_comments
    ADD CONSTRAINT pk_workflow_comments PRIMARY KEY (id);


--

-- Name: workflow_escalations pk_workflow_escalations; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_escalations
    ADD CONSTRAINT pk_workflow_escalations PRIMARY KEY (id);


--

-- Name: workflow_events pk_workflow_events; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_events
    ADD CONSTRAINT pk_workflow_events PRIMARY KEY (id);


--

-- Name: workflow_history pk_workflow_history; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_history
    ADD CONSTRAINT pk_workflow_history PRIMARY KEY (id);


--

-- Name: workflow_instances pk_workflow_instances; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_instances
    ADD CONSTRAINT pk_workflow_instances PRIMARY KEY (id);


--

-- Name: workflow_schedulers pk_workflow_schedulers; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_schedulers
    ADD CONSTRAINT pk_workflow_schedulers PRIMARY KEY (id);


--

-- Name: workflow_sla pk_workflow_sla; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_sla
    ADD CONSTRAINT pk_workflow_sla PRIMARY KEY (id);


--

-- Name: workflow_states pk_workflow_states; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_states
    ADD CONSTRAINT pk_workflow_states PRIMARY KEY (id);


--

-- Name: workflow_tasks pk_workflow_tasks; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_tasks
    ADD CONSTRAINT pk_workflow_tasks PRIMARY KEY (id);


--

-- Name: workflow_transitions pk_workflow_transitions; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_transitions
    ADD CONSTRAINT pk_workflow_transitions PRIMARY KEY (id);


--

-- Name: workflow_triggers pk_workflow_triggers; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_triggers
    ADD CONSTRAINT pk_workflow_triggers PRIMARY KEY (id);


--

-- Name: workflow_variables pk_workflow_variables; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_variables
    ADD CONSTRAINT pk_workflow_variables PRIMARY KEY (id);


--

-- Name: workflows pk_workflows; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflows
    ADD CONSTRAINT pk_workflows PRIMARY KEY (id);


--

-- Name: workflow_events uq_workflow_events_uuid; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_events
    ADD CONSTRAINT uq_workflow_events_uuid UNIQUE (uuid);


--

-- Name: workflow_schedulers uq_workflow_schedulers_code; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_schedulers
    ADD CONSTRAINT uq_workflow_schedulers_code UNIQUE (code);


--

-- Name: workflow_states uq_workflow_state; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_states
    ADD CONSTRAINT uq_workflow_state UNIQUE (workflow_id, state_code);


--

-- Name: workflow_triggers uq_workflow_triggers_code; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_triggers
    ADD CONSTRAINT uq_workflow_triggers_code UNIQUE (code);


--

-- Name: workflows uq_workflows_code_version; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflows
    ADD CONSTRAINT uq_workflows_code_version UNIQUE (workflow_code, version_no);


--


-- =========================================================================
-- workflow — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: workflow_transitions fk_transition_from_state; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_transitions
    ADD CONSTRAINT fk_transition_from_state FOREIGN KEY (from_state_id) REFERENCES workflow.workflow_states(id);


--

-- Name: workflow_transitions fk_transition_to_state; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_transitions
    ADD CONSTRAINT fk_transition_to_state FOREIGN KEY (to_state_id) REFERENCES workflow.workflow_states(id);


--

-- Name: workflow_transitions fk_transition_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_transitions
    ADD CONSTRAINT fk_transition_workflow FOREIGN KEY (workflow_id) REFERENCES workflow.workflows(id);


--

-- Name: workflow_actions fk_workflow_actions_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_actions
    ADD CONSTRAINT fk_workflow_actions_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE CASCADE;


--

-- Name: workflow_actions fk_workflow_actions_transition; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_actions
    ADD CONSTRAINT fk_workflow_actions_transition FOREIGN KEY (transition_id) REFERENCES workflow.workflow_transitions(id);


--

-- Name: workflow_actions fk_workflow_actions_user; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_actions
    ADD CONSTRAINT fk_workflow_actions_user FOREIGN KEY (action_by) REFERENCES security.users(id);


--

-- Name: workflow_comments fk_workflow_comments_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_comments
    ADD CONSTRAINT fk_workflow_comments_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE CASCADE;


--

-- Name: workflow_comments fk_workflow_comments_user; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_comments
    ADD CONSTRAINT fk_workflow_comments_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--

-- Name: workflow_escalations fk_workflow_escalations_task; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_escalations
    ADD CONSTRAINT fk_workflow_escalations_task FOREIGN KEY (workflow_task_id) REFERENCES workflow.workflow_tasks(id) ON DELETE CASCADE;


--

-- Name: workflow_events fk_workflow_events_created_by; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_events
    ADD CONSTRAINT fk_workflow_events_created_by FOREIGN KEY (created_by) REFERENCES security.users(id) ON DELETE SET NULL;


--

-- Name: workflow_events fk_workflow_events_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_events
    ADD CONSTRAINT fk_workflow_events_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE SET NULL;


--

-- Name: workflow_history fk_workflow_history_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_history
    ADD CONSTRAINT fk_workflow_history_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE CASCADE;


--

-- Name: workflow_instances fk_workflow_instances_state; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_instances
    ADD CONSTRAINT fk_workflow_instances_state FOREIGN KEY (current_state_id) REFERENCES workflow.workflow_states(id);


--

-- Name: workflow_instances fk_workflow_instances_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_instances
    ADD CONSTRAINT fk_workflow_instances_workflow FOREIGN KEY (workflow_id) REFERENCES workflow.workflows(id);


--

-- Name: workflow_schedulers fk_workflow_schedulers_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_schedulers
    ADD CONSTRAINT fk_workflow_schedulers_workflow FOREIGN KEY (workflow_id) REFERENCES workflow.workflows(id);


--

-- Name: workflow_sla fk_workflow_sla_state; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_sla
    ADD CONSTRAINT fk_workflow_sla_state FOREIGN KEY (state_id) REFERENCES workflow.workflow_states(id);


--

-- Name: workflow_sla fk_workflow_sla_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_sla
    ADD CONSTRAINT fk_workflow_sla_workflow FOREIGN KEY (workflow_id) REFERENCES workflow.workflows(id);


--

-- Name: workflow_states fk_workflow_states_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_states
    ADD CONSTRAINT fk_workflow_states_workflow FOREIGN KEY (workflow_id) REFERENCES workflow.workflows(id) ON DELETE CASCADE;


--

-- Name: workflow_tasks fk_workflow_tasks_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_tasks
    ADD CONSTRAINT fk_workflow_tasks_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE CASCADE;


--

-- Name: workflow_tasks fk_workflow_tasks_user; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_tasks
    ADD CONSTRAINT fk_workflow_tasks_user FOREIGN KEY (assigned_to) REFERENCES security.users(id);


--

-- Name: workflow_triggers fk_workflow_triggers_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_triggers
    ADD CONSTRAINT fk_workflow_triggers_workflow FOREIGN KEY (target_workflow_id) REFERENCES workflow.workflows(id);


--

-- Name: workflow_variables fk_workflow_variables_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_variables
    ADD CONSTRAINT fk_workflow_variables_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE CASCADE;


--




