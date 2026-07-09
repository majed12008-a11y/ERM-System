-- =========================================================================
-- safety — TABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: adverse_events; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.adverse_events (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    event_number character varying(100) NOT NULL,
    participant_reference character varying(200),
    event_date date NOT NULL,
    event_type character varying(100) NOT NULL,
    severity character varying(50) NOT NULL,
    expectedness character varying(50),
    relatedness character varying(50),
    description text NOT NULL,
    outcome_status character varying(100),
    reported_by bigint,
    reported_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_adverse_events_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: corrective_actions; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.corrective_actions (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    incident_id bigint,
    action_code character varying(50) NOT NULL,
    description text NOT NULL,
    assigned_to bigint,
    priority character varying(20) DEFAULT 'MEDIUM'::character varying NOT NULL,
    due_date date,
    completed_at timestamp with time zone,
    status character varying(30) DEFAULT 'OPEN'::character varying NOT NULL,
    closure_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_corrective_actions_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: mitigation_actions; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.mitigation_actions (
    id bigint NOT NULL,
    risk_assessment_id bigint NOT NULL,
    risk_category_id bigint,
    action_description text NOT NULL,
    responsible_user_id bigint,
    target_date date,
    completion_date date,
    status_code character varying(50) DEFAULT 'OPEN'::character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_mitigation_actions_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: risk_assessments; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.risk_assessments (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    assessment_date date NOT NULL,
    overall_risk_level character varying(50) NOT NULL,
    assessment_summary text,
    assessed_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_risk_assessments_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: risk_categories; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.risk_categories (
    id bigint NOT NULL,
    category_code character varying(100) NOT NULL,
    category_name character varying(300) NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL
);


--

-- Name: risk_incidents; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.risk_incidents (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    risk_id bigint,
    incident_code character varying(50) NOT NULL,
    incident_date timestamp with time zone NOT NULL,
    description text NOT NULL,
    severity character varying(30),
    root_cause text,
    reported_by bigint NOT NULL,
    status character varying(30) DEFAULT 'REPORTED'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_risk_incidents_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: risk_mitigations; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.risk_mitigations (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    risk_id bigint NOT NULL,
    mitigation_plan text NOT NULL,
    responsible_party bigint,
    target_date date,
    status character varying(30) DEFAULT 'PLANNED'::character varying NOT NULL,
    effectiveness_score integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_risk_mitigations_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: risk_register; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.risk_register (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    risk_code character varying(50) NOT NULL,
    risk_title character varying(300) NOT NULL,
    risk_description text,
    risk_category_id bigint,
    likelihood integer DEFAULT 1 NOT NULL,
    impact integer DEFAULT 1 NOT NULL,
    risk_score integer GENERATED ALWAYS AS ((likelihood * impact)) STORED,
    risk_level character varying(20),
    owner_id bigint,
    status character varying(30) DEFAULT 'IDENTIFIED'::character varying NOT NULL,
    identified_at timestamp with time zone DEFAULT now() NOT NULL,
    identified_by bigint,
    reviewed_at timestamp with time zone,
    reviewed_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_risk_register_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: safety_committee_reviews; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.safety_committee_reviews (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    committee_id bigint NOT NULL,
    review_date date NOT NULL,
    review_outcome character varying(100) NOT NULL,
    recommendations text,
    reviewed_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_safety_committee_reviews_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: safety_followups; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.safety_followups (
    id bigint NOT NULL,
    adverse_event_id bigint NOT NULL,
    followup_date date NOT NULL,
    followup_notes text NOT NULL,
    outcome_status character varying(100),
    created_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_safety_followups_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: safety_reports; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.safety_reports (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    report_number character varying(100) NOT NULL,
    report_type character varying(100) NOT NULL,
    reporting_period_start date,
    reporting_period_end date,
    report_summary text,
    submitted_by bigint,
    submitted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_safety_reports_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: serious_adverse_events; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.serious_adverse_events (
    id bigint NOT NULL,
    adverse_event_id bigint NOT NULL,
    seriousness_reason character varying(200) NOT NULL,
    hospitalization_required boolean DEFAULT false NOT NULL,
    life_threatening boolean DEFAULT false NOT NULL,
    death_occurred boolean DEFAULT false NOT NULL,
    disability_occurred boolean DEFAULT false NOT NULL,
    reported_to_committee_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_serious_adverse_events_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--


