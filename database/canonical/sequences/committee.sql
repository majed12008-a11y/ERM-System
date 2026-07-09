-- =========================================================================
-- committee — SEQUENCE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: accreditation_assessment_items_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_assessment_items ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.accreditation_assessment_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: accreditation_assessments_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_assessments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.accreditation_assessments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: accreditation_conditions_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_conditions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.accreditation_conditions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: accreditation_cycle_metrics_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_cycle_metrics ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.accreditation_cycle_metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: accreditation_cycles_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_cycles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.accreditation_cycles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: accreditation_decisions_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_decisions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.accreditation_decisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: accreditation_evidence_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_evidence ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.accreditation_evidence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: accreditation_standard_versions_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_standard_versions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.accreditation_standard_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: accreditation_standards_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_standards ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.accreditation_standards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: agenda_items_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.agenda_items ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.agenda_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: application_conditions_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.application_conditions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.application_conditions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: attendance_logs_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.attendance_logs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.attendance_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: committee_meetings_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.committee_meetings ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.committee_meetings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: committee_member_roles_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.committee_member_roles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.committee_member_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: committee_members_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.committee_members ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.committee_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: committee_roles_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.committee_roles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.committee_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: committee_types_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.committee_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.committee_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: committees_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.committees ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.committees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: consent_review_comments_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.consent_review_comments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.consent_review_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: consent_template_versions_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.consent_template_versions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.consent_template_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: consent_templates_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.consent_templates ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.consent_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: ethics_reviews_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.ethics_reviews ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.ethics_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: ethics_risk_assessments_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.ethics_risk_assessments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.ethics_risk_assessments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: ethics_risk_items_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.ethics_risk_items ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.ethics_risk_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: meeting_agendas_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.meeting_agendas ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.meeting_agendas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: meeting_minutes_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.meeting_minutes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.meeting_minutes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: member_conflicts_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.member_conflicts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.member_conflicts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: member_qualifications_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.member_qualifications ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.member_qualifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: member_terms_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.member_terms ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.member_terms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: quorum_logs_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.quorum_logs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.quorum_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: review_answers_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.review_answers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.review_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: review_assignments_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.review_assignments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.review_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: review_comments_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.review_comments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.review_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: review_conflicts_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.review_conflicts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.review_conflicts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: review_forms_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.review_forms ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.review_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: review_questions_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.review_questions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.review_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: review_recommendations_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.review_recommendations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.review_recommendations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: review_scores_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.review_scores ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.review_scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: scientific_reviews_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.scientific_reviews ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.scientific_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: votes_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.votes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: voting_sessions_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.voting_sessions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.voting_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--


