-- =========================================================================
-- templates — TABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: categories; Type: TABLE; Schema: templates; Owner: -
--

CREATE TABLE templates.categories (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(500) NOT NULL,
    name_en character varying(500) NOT NULL,
    description text,
    parent_category_id bigint,
    required_variables jsonb DEFAULT '[]'::jsonb NOT NULL,
    default_output_format character varying(20) DEFAULT 'PDF'::character varying NOT NULL,
    approval_required boolean DEFAULT true NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint
);


--

-- Name: templates; Type: TABLE; Schema: templates; Owner: -
--

CREATE TABLE templates.templates (
    id bigint NOT NULL,
    category_id bigint NOT NULL,
    code character varying(100) NOT NULL,
    name_ar character varying(500) NOT NULL,
    name_en character varying(500) NOT NULL,
    description text,
    engine character varying(50) DEFAULT 'handlebars'::character varying NOT NULL,
    default_locale character varying(10) DEFAULT 'ar'::character varying NOT NULL,
    default_output_format character varying(20),
    variable_sources jsonb DEFAULT '[]'::jsonb NOT NULL,
    tags text[] DEFAULT '{}'::text[] NOT NULL,
    usage_count integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint
);


--

-- Name: template_versions; Type: TABLE; Schema: templates; Owner: -
--

CREATE TABLE templates.template_versions (
    id bigint NOT NULL,
    template_id bigint NOT NULL,
    version character varying(20) NOT NULL,
    status character varying(20) DEFAULT 'DRAFT'::character varying NOT NULL,
    content jsonb NOT NULL,
    content_hash character varying(64) NOT NULL,
    variable_definitions jsonb DEFAULT '[]'::jsonb NOT NULL,
    change_summary text,
    effective_from timestamp with time zone,
    effective_until timestamp with time zone,
    retired_at timestamp with time zone,
    approved_by bigint,
    approved_at timestamp with time zone,
    created_by bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: template_localizations; Type: TABLE; Schema: templates; Owner: -
--

CREATE TABLE templates.template_localizations (
    id bigint NOT NULL,
    template_version_id bigint NOT NULL,
    locale character varying(10) NOT NULL,
    content jsonb NOT NULL,
    content_hash character varying(64) NOT NULL,
    is_verified boolean DEFAULT false NOT NULL,
    verified_by bigint,
    verified_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: template_variables; Type: TABLE; Schema: templates; Owner: -
--

CREATE TABLE templates.template_variables (
    id bigint NOT NULL,
    code character varying(100) NOT NULL,
    name_ar character varying(500) NOT NULL,
    name_en character varying(500) NOT NULL,
    type character varying(50) NOT NULL,
    enum_values jsonb,
    source_type character varying(50) NOT NULL,
    resolver_path character varying(500),
    resolver_function character varying(100),
    resolver_function_args jsonb,
    entity_whitelist_root character varying(100),
    default_value jsonb,
    description_ar text,
    description_en text,
    required boolean DEFAULT false NOT NULL,
    validation_rules jsonb,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint
);


--

-- Name: template_partials; Type: TABLE; Schema: templates; Owner: -
--

CREATE TABLE templates.template_partials (
    id bigint NOT NULL,
    template_id bigint,
    code character varying(100) NOT NULL,
    name_ar character varying(500) NOT NULL,
    name_en character varying(500) NOT NULL,
    engine character varying(50) DEFAULT 'handlebars'::character varying NOT NULL,
    content text NOT NULL,
    content_hash character varying(64) NOT NULL,
    version character varying(20) DEFAULT '1.0.0'::character varying NOT NULL,
    depends_on character varying(100)[] DEFAULT '{}'::character varying[] NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint
);


--

-- Name: template_packages; Type: TABLE; Schema: templates; Owner: -
--

CREATE TABLE templates.template_packages (
    id bigint NOT NULL,
    code character varying(100) NOT NULL,
    name_ar character varying(500) NOT NULL,
    name_en character varying(500) NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint
);


--

-- Name: template_package_members; Type: TABLE; Schema: templates; Owner: -
--

CREATE TABLE templates.template_package_members (
    id bigint NOT NULL,
    package_id bigint NOT NULL,
    template_code character varying(100) NOT NULL,
    slot_order integer NOT NULL,
    output_format character varying(20) DEFAULT 'PDF'::character varying NOT NULL,
    required boolean DEFAULT true NOT NULL,
    depends_on_slot integer
);


--

-- Name: template_outputs; Type: TABLE; Schema: templates; Owner: -
--

CREATE TABLE templates.template_outputs (
    id bigint NOT NULL,
    template_version_id bigint NOT NULL,
    locale character varying(10) NOT NULL,
    output_format character varying(20) NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    storage_path character varying(1000) NOT NULL,
    file_name character varying(500) NOT NULL,
    file_size_bytes bigint,
    checksum_sha256 character varying(64) NOT NULL,
    variables_hash character varying(64) NOT NULL,
    rendered_html_hash character varying(64),
    digital_signature_ref character varying(500),
    generated_by bigint NOT NULL,
    generated_at timestamp with time zone DEFAULT now() NOT NULL,
    generation_duration_ms integer,
    status character varying(20) DEFAULT 'SUCCESS'::character varying NOT NULL,
    error_message text
);


--

-- Name: template_render_jobs; Type: TABLE; Schema: templates; Owner: -
--

CREATE TABLE templates.template_render_jobs (
    id bigint NOT NULL,
    template_version_id bigint NOT NULL,
    locale character varying(10) NOT NULL,
    output_format character varying(20) NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    variables jsonb,
    priority integer DEFAULT 0 NOT NULL,
    status character varying(20) DEFAULT 'QUEUED'::character varying NOT NULL,
    output_id bigint,
    error_message text,
    queued_at timestamp with time zone DEFAULT now() NOT NULL,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    created_by bigint NOT NULL
);


--

-- Name: template_render_history; Type: TABLE; Schema: templates; Owner: -
--

CREATE TABLE templates.template_render_history (
    id bigint NOT NULL,
    template_version_id bigint NOT NULL,
    template_code character varying(100) NOT NULL,
    version character varying(20) NOT NULL,
    locale character varying(10) NOT NULL,
    output_format character varying(20) NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    generated_by bigint NOT NULL,
    generated_at timestamp with time zone DEFAULT now() NOT NULL,
    variables_hash character varying(64) NOT NULL,
    rendered_html_hash character varying(64),
    output_id bigint NOT NULL,
    storage_path character varying(1000) NOT NULL,
    checksum_sha256 character varying(64) NOT NULL,
    duration_ms integer,
    status character varying(20) NOT NULL
);


--

-- Name: template_approval_workflow; Type: TABLE; Schema: templates; Owner: -
--

CREATE TABLE templates.template_approval_workflow (
    id bigint NOT NULL,
    template_version_id bigint NOT NULL,
    step_order integer NOT NULL,
    approver_role character varying(100) NOT NULL,
    approver_id bigint,
    status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    comments text,
    acted_by bigint,
    acted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: template_usage_statistics; Type: TABLE; Schema: templates; Owner: -
--

CREATE TABLE templates.template_usage_statistics (
    id bigint NOT NULL,
    template_id bigint NOT NULL,
    date date NOT NULL,
    generation_count integer DEFAULT 0 NOT NULL,
    unique_users integer DEFAULT 0 NOT NULL,
    avg_duration_ms integer,
    total_size_bytes bigint DEFAULT 0 NOT NULL,
    by_format jsonb DEFAULT '{}'::jsonb NOT NULL,
    by_locale jsonb DEFAULT '{}'::jsonb NOT NULL
);


--

-- Name: template_version_audit; Type: TABLE; Schema: templates; Owner: -
--

CREATE TABLE templates.template_version_audit (
    id bigint NOT NULL,
    template_version_id bigint NOT NULL,
    action character varying(20) NOT NULL,
    actor_id bigint NOT NULL,
    previous_status character varying(20),
    new_status character varying(20),
    comment text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: template_validation_tests; Type: TABLE; Schema: templates; Owner: -
--

CREATE TABLE templates.template_validation_tests (
    id bigint NOT NULL,
    template_version_id bigint NOT NULL,
    test_data jsonb,
    expected_output_hash character varying(64),
    expected_html_hash character varying(64),
    test_description text,
    last_run_at timestamp with time zone,
    last_result character varying(10),
    last_error text,
    last_output_hash character varying(64)
);


--

-- Name: event_template_mapping; Type: TABLE; Schema: templates; Owner: -
--

CREATE TABLE templates.event_template_mapping (
    id bigint NOT NULL,
    event_type character varying(100) NOT NULL,
    template_code character varying(100) NOT NULL,
    locale character varying(10) DEFAULT 'ar'::character varying NOT NULL,
    output_format character varying(20) DEFAULT 'PDF'::character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint
);
