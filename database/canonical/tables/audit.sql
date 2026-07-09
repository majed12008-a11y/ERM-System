-- =========================================================================
-- audit — TABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: audit_details; Type: TABLE; Schema: audit; Owner: -
--

CREATE TABLE audit.audit_details (
    id bigint NOT NULL,
    audit_log_id bigint NOT NULL,
    field_name character varying(200) NOT NULL,
    old_value text,
    new_value text
);


--

-- Name: audit_logs; Type: TABLE; Schema: audit; Owner: -
--

CREATE TABLE audit.audit_logs (
    id bigint NOT NULL,
    user_id bigint,
    entity_name character varying(200) NOT NULL,
    entity_id bigint,
    operation_type character varying(50) NOT NULL,
    source_ip inet,
    event_timestamp timestamp with time zone DEFAULT now() NOT NULL,
    old_values jsonb,
    new_values jsonb
);


--

-- Name: entity_changes; Type: TABLE; Schema: audit; Owner: -
--

CREATE TABLE audit.entity_changes (
    id bigint NOT NULL,
    entity_name character varying(200) NOT NULL,
    entity_id bigint NOT NULL,
    change_type character varying(50) NOT NULL,
    changed_by bigint,
    changed_at timestamp with time zone DEFAULT now() NOT NULL,
    details jsonb
);


--

-- Name: hash_ledger; Type: TABLE; Schema: audit; Owner: -
--

CREATE TABLE audit.hash_ledger (
    id bigint NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    previous_hash character varying(256),
    current_hash character varying(256) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--


