-- =========================================================================
-- committee — TABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: accreditation_assessment_items; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.accreditation_assessment_items (
    id bigint NOT NULL,
    assessment_id bigint NOT NULL,
    standard_version_id bigint NOT NULL,
    is_met boolean DEFAULT false NOT NULL,
    findings text,
    score integer,
    CONSTRAINT chk_item_score CHECK (((score IS NULL) OR ((score >= 1) AND (score <= 5))))
);


--

-- Name: accreditation_assessments; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.accreditation_assessments (
    id bigint NOT NULL,
    cycle_id bigint NOT NULL,
    assessed_by bigint NOT NULL,
    overall_decision character varying(30) DEFAULT 'DEFER'::character varying NOT NULL,
    overall_justification text,
    overall_score integer,
    assessed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT chk_assessment_decision CHECK (((overall_decision)::text = ANY (ARRAY[('RECOMMEND_APPROVE'::character varying)::text, ('RECOMMEND_CONDITIONAL'::character varying)::text, ('RECOMMEND_REJECT'::character varying)::text, ('DEFER'::character varying)::text]))),
    CONSTRAINT chk_assessment_score CHECK (((overall_score IS NULL) OR ((overall_score >= 1) AND (overall_score <= 100))))
);


--

-- Name: accreditation_conditions; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.accreditation_conditions (
    id bigint NOT NULL,
    cycle_id bigint NOT NULL,
    condition_text text NOT NULL,
    due_date timestamp with time zone NOT NULL,
    status character varying(30) DEFAULT 'OPEN'::character varying NOT NULL,
    resolved_at timestamp with time zone,
    resolved_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    severity character varying(30) DEFAULT 'MAJOR'::character varying NOT NULL,
    standard_version_id bigint,
    assessment_id bigint,
    assessment_item_id bigint,
    CONSTRAINT chk_condition_severity CHECK (((severity)::text = ANY (ARRAY[('MINOR'::character varying)::text, ('MAJOR'::character varying)::text, ('CRITICAL'::character varying)::text]))),
    CONSTRAINT chk_condition_status CHECK (((status)::text = ANY (ARRAY[('OPEN'::character varying)::text, ('MET'::character varying)::text, ('OVERDUE'::character varying)::text, ('WAIVED'::character varying)::text])))
);


--

-- Name: accreditation_cycle_metrics; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.accreditation_cycle_metrics (
    id bigint NOT NULL,
    cycle_id bigint NOT NULL,
    meetings_last_12_months integer,
    protocols_reviewed_last_12_months integer,
    average_review_days numeric(5,1),
    quorum_percentage numeric(5,1),
    members_count integer,
    updated_at timestamp with time zone
);


--

-- Name: accreditation_cycles; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.accreditation_cycles (
    id bigint NOT NULL,
    committee_id bigint NOT NULL,
    standard_version_id bigint NOT NULL,
    cycle_number integer NOT NULL,
    status character varying(30) DEFAULT 'PENDING'::character varying NOT NULL,
    valid_from timestamp with time zone,
    valid_until timestamp with time zone,
    notes text,
    decided_by bigint,
    decided_at timestamp with time zone,
    created_by bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    CONSTRAINT chk_cycle_status CHECK (((status)::text = ANY (ARRAY[('PENDING'::character varying)::text, ('UNDER_REVIEW'::character varying)::text, ('ACCREDITED'::character varying)::text, ('CONDITIONAL'::character varying)::text, ('SUSPENDED'::character varying)::text, ('EXPIRED'::character varying)::text, ('REVOKED'::character varying)::text]))),
    CONSTRAINT chk_valid_dates CHECK (((valid_until IS NULL) OR (valid_from IS NULL) OR (valid_until > valid_from)))
);


--

-- Name: accreditation_decisions; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.accreditation_decisions (
    id bigint NOT NULL,
    cycle_id bigint NOT NULL,
    from_status character varying(30),
    to_status character varying(30) NOT NULL,
    decision character varying(30) NOT NULL,
    decided_by bigint NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    decision_reason text,
    CONSTRAINT chk_decision_status CHECK (((decision)::text = ANY (ARRAY[('APPLY'::character varying)::text, ('SUBMIT'::character varying)::text, ('APPROVE'::character varying)::text, ('CONDITIONAL'::character varying)::text, ('SUSPEND'::character varying)::text, ('REVOKE'::character varying)::text, ('EXPIRE'::character varying)::text, ('RESUME'::character varying)::text])))
);


--

-- Name: accreditation_evidence; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.accreditation_evidence (
    id bigint NOT NULL,
    cycle_id bigint NOT NULL,
    standard_version_id bigint NOT NULL,
    document_id bigint,
    status character varying(30) DEFAULT 'PENDING'::character varying NOT NULL,
    notes text,
    uploaded_by bigint NOT NULL,
    uploaded_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_evidence_status CHECK (((status)::text = ANY (ARRAY[('PENDING'::character varying)::text, ('SUBMITTED'::character varying)::text, ('ACCEPTED'::character varying)::text, ('REJECTED'::character varying)::text, ('EXPIRED'::character varying)::text])))
);


--

-- Name: accreditation_standard_versions; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.accreditation_standard_versions (
    id bigint NOT NULL,
    standard_id bigint NOT NULL,
    version_label character varying(50) NOT NULL,
    is_mandatory boolean DEFAULT true NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    effective_from date NOT NULL,
    effective_until date,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: accreditation_standards; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.accreditation_standards (
    id bigint NOT NULL,
    code character varying(100) NOT NULL,
    name_ar character varying(300) NOT NULL,
    name_en character varying(300) NOT NULL,
    description_ar text,
    description_en text,
    category character varying(50) DEFAULT 'DOCUMENT'::character varying NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--

-- Name: agenda_items; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.agenda_items (
    id bigint NOT NULL,
    agenda_id bigint NOT NULL,
    application_id bigint,
    item_order integer NOT NULL,
    title character varying(500) NOT NULL,
    discussion_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_agenda_items_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: application_conditions; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.application_conditions (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    condition_text text NOT NULL,
    severity character varying(10) DEFAULT 'MAJOR'::character varying NOT NULL,
    category character varying(50) DEFAULT 'GENERAL'::character varying,
    due_date timestamp with time zone,
    status character varying(20) DEFAULT 'OPEN'::character varying NOT NULL,
    resolved_by bigint,
    resolved_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT application_conditions_category_check CHECK (((category)::text = ANY (ARRAY[('GENERAL'::character varying)::text, ('SCIENTIFIC'::character varying)::text, ('ETHICAL'::character varying)::text, ('ADMINISTRATIVE'::character varying)::text, ('SAFETY'::character varying)::text]))),
    CONSTRAINT application_conditions_severity_check CHECK (((severity)::text = ANY (ARRAY[('MINOR'::character varying)::text, ('MAJOR'::character varying)::text, ('CRITICAL'::character varying)::text]))),
    CONSTRAINT application_conditions_status_check CHECK (((status)::text = ANY (ARRAY[('OPEN'::character varying)::text, ('MET'::character varying)::text, ('NOT_MET'::character varying)::text, ('WAIVED'::character varying)::text])))
);


--

-- Name: attendance_logs; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.attendance_logs (
    id bigint NOT NULL,
    meeting_id bigint NOT NULL,
    user_id bigint NOT NULL,
    attendance_status character varying(50) NOT NULL,
    check_in_time timestamp with time zone,
    remarks text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_attendance_logs_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: committee_meetings; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.committee_meetings (
    id bigint NOT NULL,
    committee_id bigint NOT NULL,
    meeting_number character varying(100) NOT NULL,
    meeting_date timestamp with time zone NOT NULL,
    location character varying(500),
    meeting_status character varying(50) DEFAULT 'SCHEDULED'::character varying NOT NULL,
    chairperson_id bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_committee_meetings_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: committee_member_roles; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.committee_member_roles (
    id bigint NOT NULL,
    member_id bigint NOT NULL,
    role_id bigint NOT NULL,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    assigned_by bigint
);


--

-- Name: committee_members; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.committee_members (
    id bigint NOT NULL,
    committee_id bigint NOT NULL,
    user_id bigint NOT NULL,
    membership_start_date date NOT NULL,
    membership_end_date date,
    is_active boolean DEFAULT true NOT NULL,
    role_id bigint,
    created_by bigint,
    created_at timestamp with time zone DEFAULT now(),
    updated_by bigint,
    updated_at timestamp with time zone
);


--

-- Name: committee_roles; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.committee_roles (
    id bigint NOT NULL,
    role_code character varying(100) NOT NULL,
    role_name character varying(200) NOT NULL,
    description text
);


--

-- Name: committee_types; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.committee_types (
    id bigint NOT NULL,
    type_code character varying(100) NOT NULL,
    type_name character varying(300) NOT NULL,
    description text
);


--

-- Name: committees; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.committees (
    id bigint NOT NULL,
    institution_id bigint NOT NULL,
    committee_code character varying(100) NOT NULL,
    committee_name_ar character varying(500) NOT NULL,
    committee_name_en character varying(500),
    committee_type_id bigint,
    establishment_date date,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_committees_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: consent_review_comments; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.consent_review_comments (
    id bigint NOT NULL,
    application_consent_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    decision character varying(50) NOT NULL,
    comment text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_consent_review_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: consent_template_versions; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.consent_template_versions (
    id bigint NOT NULL,
    template_id bigint NOT NULL,
    version_no integer NOT NULL,
    language character varying(10) NOT NULL,
    title character varying(500) NOT NULL,
    content text,
    document_id bigint,
    effective_from date,
    retired_at date,
    change_summary text,
    status character varying(50) DEFAULT 'DRAFT'::character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_ctv_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: consent_templates; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.consent_templates (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(500) NOT NULL,
    name_en character varying(500) NOT NULL,
    description text,
    consent_type character varying(50) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_consent_templates_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: ethics_reviews; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.ethics_reviews (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    review_status character varying(50) DEFAULT 'ASSIGNED'::character varying NOT NULL,
    recommendation character varying(100),
    ethical_risk_assessment text,
    summary text,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_ethics_reviews_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: ethics_risk_assessments; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.ethics_risk_assessments (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    ethics_review_id bigint,
    scientific_review_id bigint,
    assessment_version integer DEFAULT 1 NOT NULL,
    overall_risk_level character varying(50) NOT NULL,
    overall_risk_score numeric(10,2),
    recommendation character varying(100),
    assessed_by bigint NOT NULL,
    assessment_date date DEFAULT CURRENT_DATE NOT NULL,
    summary text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_ethics_risk_assessments_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: ethics_risk_items; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.ethics_risk_items (
    id bigint NOT NULL,
    assessment_id bigint NOT NULL,
    risk_category_id bigint NOT NULL,
    risk_description text NOT NULL,
    probability integer NOT NULL,
    severity integer NOT NULL,
    risk_score integer GENERATED ALWAYS AS ((probability * severity)) STORED,
    mitigation_plan text,
    residual_probability integer,
    residual_severity integer,
    residual_score integer GENERATED ALWAYS AS ((residual_probability * residual_severity)) STORED,
    is_acceptable boolean DEFAULT false,
    display_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    created_by bigint,
    CONSTRAINT chk_ethics_risk_items_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL))),
    CONSTRAINT ethics_risk_items_probability_check CHECK (((probability >= 1) AND (probability <= 5))),
    CONSTRAINT ethics_risk_items_residual_probability_check CHECK (((residual_probability >= 1) AND (residual_probability <= 5))),
    CONSTRAINT ethics_risk_items_residual_severity_check CHECK (((residual_severity >= 1) AND (residual_severity <= 5))),
    CONSTRAINT ethics_risk_items_severity_check CHECK (((severity >= 1) AND (severity <= 5)))
);


--

-- Name: meeting_agendas; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.meeting_agendas (
    id bigint NOT NULL,
    meeting_id bigint NOT NULL,
    title character varying(500) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_meeting_agendas_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: meeting_minutes; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.meeting_minutes (
    id bigint NOT NULL,
    meeting_id bigint NOT NULL,
    minutes_text text NOT NULL,
    approved_by bigint,
    approved_at timestamp with time zone,
    created_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_meeting_minutes_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: member_conflicts; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.member_conflicts (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    member_id bigint NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id bigint NOT NULL,
    conflict_type character varying(50) NOT NULL,
    description text,
    declared_at timestamp with time zone DEFAULT now() NOT NULL,
    resolved_at timestamp with time zone,
    resolution_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_member_conflicts_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: member_qualifications; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.member_qualifications (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    member_id bigint NOT NULL,
    specialization character varying(200) NOT NULL,
    academic_degree character varying(100) NOT NULL,
    institution_name character varying(300),
    experience_years integer,
    certificate_url text,
    is_verified boolean DEFAULT false NOT NULL,
    verified_by bigint,
    verified_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_member_qualifications_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: member_terms; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.member_terms (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    member_id bigint NOT NULL,
    start_date date NOT NULL,
    end_date date,
    appointment_decision_no character varying(100),
    appointment_decision_date date,
    termination_decision_no character varying(100),
    termination_decision_date date,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_member_terms_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: quorum_logs; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.quorum_logs (
    id bigint NOT NULL,
    meeting_id bigint NOT NULL,
    total_members integer NOT NULL,
    present_members integer NOT NULL,
    quorum_required integer NOT NULL,
    quorum_achieved boolean NOT NULL,
    calculated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_quorum_logs_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: review_answers; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.review_answers (
    id bigint NOT NULL,
    review_id bigint NOT NULL,
    review_type character varying(50) NOT NULL,
    question_id bigint NOT NULL,
    answer_text text,
    answer_score numeric(10,2),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: review_assignments; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.review_assignments (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    review_type character varying(50) NOT NULL,
    assigned_by bigint,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    due_date timestamp with time zone,
    status_code character varying(50) DEFAULT 'ASSIGNED'::character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_review_assignments_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: review_comments; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.review_comments (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    comment_text text NOT NULL,
    is_internal boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_review_comments_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: review_conflicts; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.review_conflicts (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    conflict_type character varying(100) NOT NULL,
    description text,
    declared_at timestamp with time zone DEFAULT now() NOT NULL,
    approved_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_review_conflicts_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: review_forms; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.review_forms (
    id bigint NOT NULL,
    form_code character varying(100) NOT NULL,
    form_name character varying(300) NOT NULL,
    review_type character varying(50) NOT NULL,
    version_no integer DEFAULT 1 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_review_forms_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: review_questions; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.review_questions (
    id bigint NOT NULL,
    form_id bigint NOT NULL,
    question_code character varying(100) NOT NULL,
    question_text text NOT NULL,
    question_type character varying(50) NOT NULL,
    display_order integer NOT NULL,
    is_required boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    question_options jsonb,
    CONSTRAINT chk_committee_review_questions_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: review_recommendations; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.review_recommendations (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    recommendation_type character varying(100) NOT NULL,
    justification text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_review_recommendations_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: review_scores; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.review_scores (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    review_type character varying(50) NOT NULL,
    score numeric(10,2) NOT NULL,
    calculated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_review_scores_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: scientific_reviews; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.scientific_reviews (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    review_status character varying(50) DEFAULT 'ASSIGNED'::character varying NOT NULL,
    recommendation character varying(100),
    summary text,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_scientific_reviews_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: votes; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.votes (
    id bigint NOT NULL,
    voting_session_id bigint NOT NULL,
    voter_id bigint NOT NULL,
    vote_value character varying(50) NOT NULL,
    vote_time timestamp with time zone DEFAULT now() NOT NULL,
    comments text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_votes_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: voting_sessions; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.voting_sessions (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    meeting_id bigint NOT NULL,
    voting_type character varying(50) NOT NULL,
    voting_start timestamp with time zone,
    voting_end timestamp with time zone,
    status_code character varying(50) DEFAULT 'OPEN'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_voting_sessions_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--


