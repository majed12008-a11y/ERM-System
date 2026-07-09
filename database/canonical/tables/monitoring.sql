-- =========================================================================
-- monitoring — TABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: compliance_reviews; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.compliance_reviews (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    review_date date NOT NULL,
    compliance_score numeric(5,2),
    summary text,
    status_code character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_compliance_reviews_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: corrective_actions; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.corrective_actions (
    id bigint NOT NULL,
    finding_id bigint NOT NULL,
    action_description text NOT NULL,
    responsible_user_id bigint,
    target_completion_date date,
    completion_date date,
    status_code character varying(50) DEFAULT 'OPEN'::character varying NOT NULL
);


--

-- Name: deviations; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.deviations (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    deviation_code character varying(100),
    deviation_date date NOT NULL,
    deviation_type character varying(100),
    description text NOT NULL,
    reported_by bigint,
    reported_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_deviations_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: inspection_reports; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.inspection_reports (
    id bigint NOT NULL,
    inspection_id bigint NOT NULL,
    report_number character varying(100),
    findings_summary text,
    recommendations text,
    submitted_at timestamp with time zone,
    approved_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_inspection_reports_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: inspections; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.inspections (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    inspection_type character varying(100) NOT NULL,
    inspection_date date NOT NULL,
    inspector_id bigint,
    status_code character varying(50),
    summary text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_inspections_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: monitoring_findings; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.monitoring_findings (
    id bigint NOT NULL,
    monitoring_visit_id bigint NOT NULL,
    finding_type character varying(100) NOT NULL,
    severity character varying(50) NOT NULL,
    description text NOT NULL,
    recommendation text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_monitoring_findings_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: monitoring_plans; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.monitoring_plans (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    plan_code character varying(100) NOT NULL,
    monitoring_type character varying(100) NOT NULL,
    frequency_type character varying(100),
    planned_start_date date,
    planned_end_date date,
    status_code character varying(50) DEFAULT 'ACTIVE'::character varying NOT NULL,
    created_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_monitoring_plans_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: monitoring_visits; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.monitoring_visits (
    id bigint NOT NULL,
    monitoring_plan_id bigint NOT NULL,
    visit_date date NOT NULL,
    monitor_id bigint,
    visit_status character varying(50) NOT NULL,
    observations text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_monitoring_visits_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: preventive_actions; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.preventive_actions (
    id bigint NOT NULL,
    finding_id bigint NOT NULL,
    action_description text NOT NULL,
    responsible_user_id bigint,
    target_completion_date date,
    completion_date date,
    status_code character varying(50) DEFAULT 'OPEN'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_preventive_actions_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: protocol_violations; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.protocol_violations (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    violation_date date NOT NULL,
    severity character varying(50) NOT NULL,
    description text NOT NULL,
    corrective_action_required boolean DEFAULT true NOT NULL,
    status_code character varying(50) DEFAULT 'OPEN'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_protocol_violations_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--


