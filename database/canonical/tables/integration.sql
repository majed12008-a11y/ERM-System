-- =========================================================================
-- integration — TABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: data_sync_jobs; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.data_sync_jobs (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    external_system_id bigint NOT NULL,
    sync_direction character varying(10) DEFAULT 'BIDIRECTIONAL'::character varying NOT NULL,
    entity_type character varying(100) NOT NULL,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    records_processed integer DEFAULT 0,
    records_failed integer DEFAULT 0,
    status character varying(30) DEFAULT 'RUNNING'::character varying NOT NULL,
    error_log text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_integration_data_sync_jobs_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: event_bus_config; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.event_bus_config (
    id bigint NOT NULL,
    config_key character varying(200) NOT NULL,
    config_value text NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: event_outbox; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.event_outbox (
    id bigint NOT NULL,
    event_id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_type character varying(200) NOT NULL,
    aggregate_type character varying(100) NOT NULL,
    aggregate_id bigint NOT NULL,
    event_data jsonb NOT NULL,
    metadata jsonb,
    status character varying(50) DEFAULT 'PENDING'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    processed_at timestamp with time zone,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_event_outbox_status CHECK (((status)::text = ANY (ARRAY[('PENDING'::character varying)::text, ('PROCESSING'::character varying)::text, ('COMPLETED'::character varying)::text, ('FAILED'::character varying)::text]))),
    CONSTRAINT chk_integration_event_outbox_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: event_subscriptions; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.event_subscriptions (
    id bigint NOT NULL,
    subscription_name character varying(300) NOT NULL,
    event_type character varying(200) NOT NULL,
    endpoint_url text,
    handler_class character varying(500),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: external_systems; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.external_systems (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    system_type character varying(100) NOT NULL,
    base_url character varying(500),
    is_active boolean DEFAULT true NOT NULL,
    supports_webhook boolean DEFAULT false NOT NULL,
    supports_api boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--

-- Name: integration_credentials; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.integration_credentials (
    id bigint NOT NULL,
    external_system_id bigint NOT NULL,
    credential_type character varying(50) DEFAULT 'API_KEY'::character varying NOT NULL,
    credential_key character varying(200) NOT NULL,
    credential_value text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    expires_at timestamp with time zone,
    last_used_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--

-- Name: integration_failures; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.integration_failures (
    id bigint NOT NULL,
    external_system_id bigint,
    endpoint character varying(500) NOT NULL,
    error_message text NOT NULL,
    error_code character varying(100),
    request_payload text,
    response_payload text,
    retry_count integer DEFAULT 0 NOT NULL,
    max_retries integer DEFAULT 3 NOT NULL,
    status character varying(30) DEFAULT 'NEW'::character varying NOT NULL,
    resolved_at timestamp with time zone,
    resolved_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: integration_logs; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.integration_logs (
    id bigint NOT NULL,
    integration_type character varying(100) NOT NULL,
    direction character varying(10) NOT NULL,
    status character varying(50) NOT NULL,
    request_url text,
    request_body text,
    response_code integer,
    response_body text,
    error_message text,
    duration_ms integer,
    created_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: retry_queue; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.retry_queue (
    id bigint NOT NULL,
    source character varying(100) NOT NULL,
    payload jsonb NOT NULL,
    error_message text,
    retry_count integer DEFAULT 0 NOT NULL,
    max_retries integer DEFAULT 5 NOT NULL,
    next_retry_at timestamp with time zone,
    status character varying(50) DEFAULT 'PENDING'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    last_attempt_at timestamp with time zone,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_integration_retry_queue_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL))),
    CONSTRAINT chk_retry_queue_status CHECK (((status)::text = ANY (ARRAY[('PENDING'::character varying)::text, ('IN_PROGRESS'::character varying)::text, ('COMPLETED'::character varying)::text, ('FAILED'::character varying)::text])))
);


--

-- Name: webhooks; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.webhooks (
    id bigint NOT NULL,
    webhook_name character varying(300) NOT NULL,
    webhook_url text NOT NULL,
    secret_key text,
    events text[] NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    timeout_seconds integer DEFAULT 30 NOT NULL,
    retry_count integer DEFAULT 3 NOT NULL,
    last_called_at timestamp with time zone,
    last_status character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_integration_webhooks_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--


