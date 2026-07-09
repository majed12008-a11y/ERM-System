-- =========================================================================
-- security — DEFAULT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: approval_authorities id; Type: DEFAULT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.approval_authorities ALTER COLUMN id SET DEFAULT nextval('security.approval_authorities_id_seq'::regclass);


--

-- Name: approval_limits id; Type: DEFAULT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.approval_limits ALTER COLUMN id SET DEFAULT nextval('security.approval_limits_id_seq'::regclass);


--

-- Name: certificate_revocations id; Type: DEFAULT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.certificate_revocations ALTER COLUMN id SET DEFAULT nextval('security.certificate_revocations_id_seq'::regclass);


--

-- Name: digital_certificates id; Type: DEFAULT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.digital_certificates ALTER COLUMN id SET DEFAULT nextval('security.digital_certificates_id_seq'::regclass);


--

-- Name: policy_conditions id; Type: DEFAULT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.policy_conditions ALTER COLUMN id SET DEFAULT nextval('security.policy_conditions_id_seq'::regclass);


--

-- Name: policy_rules id; Type: DEFAULT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.policy_rules ALTER COLUMN id SET DEFAULT nextval('security.policy_rules_id_seq'::regclass);


--

-- Name: role_delegations id; Type: DEFAULT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.role_delegations ALTER COLUMN id SET DEFAULT nextval('security.role_delegations_id_seq'::regclass);


--

-- Name: segregation_rules id; Type: DEFAULT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.segregation_rules ALTER COLUMN id SET DEFAULT nextval('security.segregation_rules_id_seq'::regclass);


--


-- =========================================================================
-- security — SEQUENCE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: access_policies_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.access_policies ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.access_policies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.api_keys ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.api_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: approval_authorities_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

CREATE SEQUENCE security.approval_authorities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--

-- Name: approval_authorities_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: -
--

ALTER SEQUENCE security.approval_authorities_id_seq OWNED BY security.approval_authorities.id;


--

-- Name: approval_limits_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

CREATE SEQUENCE security.approval_limits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--

-- Name: approval_limits_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: -
--

ALTER SEQUENCE security.approval_limits_id_seq OWNED BY security.approval_limits.id;


--

-- Name: certificate_revocations_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

CREATE SEQUENCE security.certificate_revocations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--

-- Name: certificate_revocations_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: -
--

ALTER SEQUENCE security.certificate_revocations_id_seq OWNED BY security.certificate_revocations.id;


--

-- Name: departments_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.departments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.departments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: digital_certificates_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

CREATE SEQUENCE security.digital_certificates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--

-- Name: digital_certificates_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: -
--

ALTER SEQUENCE security.digital_certificates_id_seq OWNED BY security.digital_certificates.id;


--

-- Name: email_verification_tokens_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.email_verification_tokens ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.email_verification_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: institution_types_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.institution_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.institution_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: institutions_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.institutions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.institutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: login_audit_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.login_audit ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.login_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: password_history_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.password_history ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.password_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: password_reset_tokens_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.password_reset_tokens ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.password_reset_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: permissions_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.permissions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: policy_conditions_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

CREATE SEQUENCE security.policy_conditions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--

-- Name: policy_conditions_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: -
--

ALTER SEQUENCE security.policy_conditions_id_seq OWNED BY security.policy_conditions.id;


--

-- Name: policy_rules_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

CREATE SEQUENCE security.policy_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--

-- Name: policy_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: -
--

ALTER SEQUENCE security.policy_rules_id_seq OWNED BY security.policy_rules.id;


--

-- Name: responsibility_types_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.responsibility_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.responsibility_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: role_delegations_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

CREATE SEQUENCE security.role_delegations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--

-- Name: role_delegations_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: -
--

ALTER SEQUENCE security.role_delegations_id_seq OWNED BY security.role_delegations.id;


--

-- Name: role_permissions_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.role_permissions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.role_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: roles_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.roles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: security_events_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.security_events ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.security_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: segregation_rules_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

CREATE SEQUENCE security.segregation_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--

-- Name: segregation_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: -
--

ALTER SEQUENCE security.segregation_rules_id_seq OWNED BY security.segregation_rules.id;


--

-- Name: sessions_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.sessions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: user_profiles_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.user_profiles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.user_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: user_responsibilities_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.user_responsibilities ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.user_responsibilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.user_roles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: users_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.users ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--


