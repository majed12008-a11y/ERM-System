-- =========================================================================
-- system — DEFAULT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: audit_log id; Type: DEFAULT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.audit_log ALTER COLUMN id SET DEFAULT nextval('system.audit_log_id_seq'::regclass);


--

-- Name: business_rules id; Type: DEFAULT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.business_rules ALTER COLUMN id SET DEFAULT nextval('system.business_rules_id_seq'::regclass);


--

-- Name: feature_flags id; Type: DEFAULT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.feature_flags ALTER COLUMN id SET DEFAULT nextval('system.feature_flags_id_seq'::regclass);


--

-- Name: rule_versions id; Type: DEFAULT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_versions ALTER COLUMN id SET DEFAULT nextval('system.rule_versions_id_seq'::regclass);


--


-- =========================================================================
-- system — SEQUENCE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: audit_config_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.audit_config ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.audit_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: audit_log_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

CREATE SEQUENCE system.audit_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--

-- Name: audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: system; Owner: -
--

ALTER SEQUENCE system.audit_log_id_seq OWNED BY system.audit_log.id;


--

-- Name: business_rules_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

CREATE SEQUENCE system.business_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--

-- Name: business_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: system; Owner: -
--

ALTER SEQUENCE system.business_rules_id_seq OWNED BY system.business_rules.id;


--

-- Name: email_config_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.email_config ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.email_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: feature_flags_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

CREATE SEQUENCE system.feature_flags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--

-- Name: feature_flags_id_seq; Type: SEQUENCE OWNED BY; Schema: system; Owner: -
--

ALTER SEQUENCE system.feature_flags_id_seq OWNED BY system.feature_flags.id;


--

-- Name: maintenance_log_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.maintenance_log ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.maintenance_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: push_config_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.push_config ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.push_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: rule_actions_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.rule_actions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.rule_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: rule_conditions_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.rule_conditions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.rule_conditions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: rule_executions_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.rule_executions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.rule_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: rule_versions_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

CREATE SEQUENCE system.rule_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--

-- Name: rule_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: system; Owner: -
--

ALTER SEQUENCE system.rule_versions_id_seq OWNED BY system.rule_versions.id;


--

-- Name: saved_searches_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.saved_searches ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.saved_searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: search_audit_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.search_audit ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.search_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: search_indexes_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.search_indexes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.search_indexes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: sms_config_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.sms_config ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.sms_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: system_config_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.system_config ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.system_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--


