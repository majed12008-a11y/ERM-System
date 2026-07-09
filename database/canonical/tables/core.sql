-- =========================================================================
-- core — TABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: amendment_requests; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.amendment_requests (
    id bigint NOT NULL,
    amendment_id bigint NOT NULL,
    request_date timestamp with time zone DEFAULT now() NOT NULL,
    request_status character varying(50) NOT NULL,
    decision_date timestamp with time zone,
    comments text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_amendment_requests_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: application_amendments; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.application_amendments (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    amendment_number character varying(100) NOT NULL,
    amendment_reason text NOT NULL,
    amendment_description text,
    submitted_by bigint,
    submitted_at timestamp with time zone,
    status_code character varying(50) DEFAULT 'DRAFT'::character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_application_amendments_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: application_checklists; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.application_checklists (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    checklist_item character varying(500) NOT NULL,
    is_completed boolean DEFAULT false NOT NULL,
    completed_at timestamp with time zone,
    completed_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_application_checklists_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: application_consents; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.application_consents (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    consent_version_id bigint NOT NULL,
    is_required boolean DEFAULT true NOT NULL,
    status character varying(50) DEFAULT 'PENDING'::character varying NOT NULL,
    reviewer_notes text,
    reviewed_by bigint,
    reviewed_at timestamp with time zone,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_app_consents_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: application_history; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.application_history (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    action_type character varying(100) NOT NULL,
    old_value text,
    new_value text,
    action_by bigint,
    action_at timestamp with time zone DEFAULT now() NOT NULL,
    remarks text
);


--

-- Name: application_sections; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.application_sections (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    section_code character varying(100) NOT NULL,
    section_name character varying(300) NOT NULL,
    completion_percentage numeric(5,2) DEFAULT 0,
    status_code character varying(50) DEFAULT 'INCOMPLETE'::character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_application_sections_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: application_validations; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.application_validations (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    validation_rule character varying(300) NOT NULL,
    validation_result boolean NOT NULL,
    validation_message text,
    validated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_application_validations_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: application_versions; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.application_versions (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    version_no integer NOT NULL,
    snapshot_data jsonb NOT NULL,
    created_by bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: applications; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.applications (
    id bigint NOT NULL,
    application_number character varying(100) NOT NULL,
    project_id bigint NOT NULL,
    application_type character varying(50) NOT NULL,
    current_status character varying(50) DEFAULT 'DRAFT'::character varying NOT NULL,
    submission_date timestamp with time zone,
    submitted_by bigint,
    priority_level character varying(50),
    target_committee_id bigint,
    remarks text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_applications_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: closure_requests; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.closure_requests (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    closure_reason text NOT NULL,
    closure_summary text,
    submitted_at timestamp with time zone,
    status_code character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_closure_requests_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: project_attachments; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_attachments (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    document_name character varying(500) NOT NULL,
    file_path text NOT NULL,
    file_size bigint,
    mime_type character varying(200),
    uploaded_by bigint,
    uploaded_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_project_attachments_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: project_funding_sources; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_funding_sources (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    funding_source_name character varying(500) NOT NULL,
    funding_type character varying(100),
    amount numeric(18,2),
    currency_code character varying(10),
    funding_reference character varying(200),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_project_funding_sources_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: project_keywords; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_keywords (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    keyword character varying(200) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_project_keywords_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: project_site_investigators; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_site_investigators (
    id bigint NOT NULL,
    site_id bigint NOT NULL,
    investigator_id bigint NOT NULL,
    is_site_lead boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_project_site_investigators_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: project_sites; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_sites (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    site_name character varying(500) NOT NULL,
    governorate character varying(100),
    address text,
    expected_participants integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_project_sites_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: project_status_history; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_status_history (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    old_status character varying(50),
    new_status character varying(50) NOT NULL,
    changed_by bigint,
    changed_at timestamp with time zone DEFAULT now() NOT NULL,
    remarks text
);


--

-- Name: project_tags; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_tags (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    tag_name character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_project_tags_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: project_team_members; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_team_members (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    user_id bigint NOT NULL,
    role_name character varying(200) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_project_team_members_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: project_versions; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_versions (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    version_no integer NOT NULL,
    version_notes text,
    snapshot_data jsonb NOT NULL,
    created_by bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: projects; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.projects (
    id bigint NOT NULL,
    institution_id bigint NOT NULL,
    project_code character varying(100) NOT NULL,
    title_ar character varying(1000) NOT NULL,
    title_en character varying(1000),
    abstract_ar text,
    abstract_en text,
    objectives text,
    principal_investigator_id bigint NOT NULL,
    research_category character varying(100),
    risk_level character varying(50),
    status_code character varying(50) DEFAULT 'DRAFT'::character varying NOT NULL,
    start_date date,
    expected_end_date date,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_projects_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: renewal_requests; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.renewal_requests (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    renewal_period_months integer,
    justification text,
    submitted_at timestamp with time zone,
    status_code character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_renewal_requests_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: research_categories; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.research_categories (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_research_categories_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: research_population_links; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.research_population_links (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id bigint NOT NULL,
    vulnerable_population_id bigint NOT NULL,
    safeguard_measures text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_research_population_links_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: risk_classifications; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.risk_classifications (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    severity_level integer DEFAULT 1 NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_risk_classifications_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: vulnerable_populations; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.vulnerable_populations (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    description text,
    safeguards_required text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_vulnerable_populations_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--


