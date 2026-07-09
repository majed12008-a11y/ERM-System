-- =========================================================================
-- system — TABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: audit_config; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.audit_config (
    id bigint NOT NULL,
    entity_name character varying(200) NOT NULL,
    operations character varying(50)[] NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    retention_days integer DEFAULT 365 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: audit_log; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.audit_log (
    id bigint NOT NULL,
    user_id bigint,
    action_type character varying(100) NOT NULL,
    entity_type character varying(100),
    entity_id bigint,
    old_values jsonb,
    new_values jsonb,
    ip_address character varying(45),
    user_agent text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: business_rules; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.business_rules (
    id bigint NOT NULL,
    code character varying(100),
    name character varying(255),
    rule_definition jsonb,
    active boolean DEFAULT true
);


--

-- Name: email_config; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.email_config (
    id bigint NOT NULL,
    config_name character varying(200) NOT NULL,
    smtp_host character varying(500) NOT NULL,
    smtp_port integer DEFAULT 587 NOT NULL,
    smtp_username character varying(500),
    smtp_password text,
    use_tls boolean DEFAULT true NOT NULL,
    from_address character varying(500) NOT NULL,
    from_name character varying(300),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: feature_flags; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.feature_flags (
    id bigint NOT NULL,
    code character varying(100),
    name character varying(255),
    enabled boolean DEFAULT false
);


--

-- Name: maintenance_log; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.maintenance_log (
    id bigint NOT NULL,
    maintenance_type character varying(100) NOT NULL,
    description text NOT NULL,
    started_at timestamp with time zone NOT NULL,
    completed_at timestamp with time zone,
    status character varying(50) DEFAULT 'IN_PROGRESS'::character varying NOT NULL,
    performed_by bigint,
    notes text,
    CONSTRAINT chk_maintenance_status CHECK (((status)::text = ANY (ARRAY[('SCHEDULED'::character varying)::text, ('IN_PROGRESS'::character varying)::text, ('COMPLETED'::character varying)::text, ('FAILED'::character varying)::text, ('CANCELLED'::character varying)::text])))
);


--

-- Name: push_config; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.push_config (
    id bigint NOT NULL,
    config_name character varying(200) NOT NULL,
    provider character varying(100) NOT NULL,
    server_key text,
    app_id character varying(200),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: rule_actions; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.rule_actions (
    id bigint NOT NULL,
    rule_id bigint NOT NULL,
    action_type character varying(100) NOT NULL,
    action_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    order_index integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: rule_conditions; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.rule_conditions (
    id bigint NOT NULL,
    rule_id bigint NOT NULL,
    condition_group character varying(50) DEFAULT 'AND'::character varying NOT NULL,
    field_name character varying(200) NOT NULL,
    operator character varying(30) NOT NULL,
    field_value text NOT NULL,
    value_type character varying(30) DEFAULT 'STRING'::character varying NOT NULL,
    order_index integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: rule_executions; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.rule_executions (
    id bigint NOT NULL,
    rule_id bigint NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    conditions_met boolean NOT NULL,
    execution_result jsonb,
    execution_duration_ms integer,
    triggered_by bigint,
    executed_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: rule_versions; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.rule_versions (
    id bigint NOT NULL,
    rule_id bigint NOT NULL,
    version_no integer NOT NULL,
    definition jsonb,
    created_at timestamp with time zone DEFAULT now()
);


--

-- Name: saved_searches; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.saved_searches (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id bigint NOT NULL,
    search_name character varying(200) NOT NULL,
    search_criteria jsonb NOT NULL,
    entity_type character varying(100),
    is_shared boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint
);


--

-- Name: search_audit; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.search_audit (
    id bigint NOT NULL,
    user_id bigint,
    search_query text NOT NULL,
    entity_type character varying(100),
    result_count integer,
    search_duration_ms integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: search_indexes; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.search_indexes (
    id bigint NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    search_text text NOT NULL,
    search_vector tsvector,
    weight integer DEFAULT 1 NOT NULL,
    language character varying(10) DEFAULT 'arabic'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--

-- Name: sms_config; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.sms_config (
    id bigint NOT NULL,
    config_name character varying(200) NOT NULL,
    provider character varying(100) NOT NULL,
    api_key text,
    api_secret text,
    sender_name character varying(100),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: system_config; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.system_config (
    id bigint NOT NULL,
    config_key character varying(200) NOT NULL,
    config_value text NOT NULL,
    config_group character varying(100) DEFAULT 'GENERAL'::character varying NOT NULL,
    description text,
    is_encrypted boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--


