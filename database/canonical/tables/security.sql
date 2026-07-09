-- =========================================================================
-- security — TABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: users; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.users (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    institution_id bigint NOT NULL,
    department_id bigint,
    username public.citext NOT NULL,
    email public.citext NOT NULL,
    password_hash text NOT NULL,
    first_name_ar character varying(150),
    last_name_ar character varying(150),
    first_name_en character varying(150),
    last_name_en character varying(150),
    mobile character varying(50),
    status character varying(30) DEFAULT 'ACTIVE'::character varying NOT NULL,
    last_login_at timestamp with time zone,
    is_locked boolean DEFAULT false NOT NULL,
    is_email_verified boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_users_status CHECK (((status)::text = ANY (ARRAY[('ACTIVE'::character varying)::text, ('INACTIVE'::character varying)::text, ('LOCKED'::character varying)::text, ('SUSPENDED'::character varying)::text])))
);


--

-- Name: institution_types; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.institution_types (
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
    CONSTRAINT chk_institution_types_code CHECK ((length(TRIM(BOTH FROM code)) > 0))
);


--

-- Name: institutions; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.institutions (
    id bigint NOT NULL,
    institution_type_id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(300) NOT NULL,
    name_en character varying(300),
    license_number character varying(100),
    registration_number character varying(100),
    email character varying(200),
    phone character varying(100),
    address text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint
);


--

-- Name: access_policies; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.access_policies (
    id bigint NOT NULL,
    policy_code character varying(100) NOT NULL,
    policy_name character varying(200) NOT NULL,
    target_resource character varying(200) NOT NULL,
    policy_expression jsonb NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: api_keys; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.api_keys (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    key_name character varying(200) NOT NULL,
    api_key_hash text NOT NULL,
    expires_at timestamp with time zone,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: approval_authorities; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.approval_authorities (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    committee_id bigint,
    decision_type_id bigint,
    authority_level integer NOT NULL,
    active boolean DEFAULT true
);


--

-- Name: approval_limits; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.approval_limits (
    id bigint NOT NULL,
    authority_id bigint NOT NULL,
    max_risk_level integer,
    max_budget numeric(18,2),
    max_duration_days integer
);


--

-- Name: certificate_revocations; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.certificate_revocations (
    id bigint NOT NULL,
    certificate_id bigint NOT NULL,
    revoked_at timestamp with time zone NOT NULL,
    reason text
);


--

-- Name: departments; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.departments (
    id bigint NOT NULL,
    institution_id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--

-- Name: digital_certificates; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.digital_certificates (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    serial_number character varying(255),
    issuer character varying(500),
    valid_from timestamp with time zone,
    valid_to timestamp with time zone,
    status character varying(50)
);


--

-- Name: email_verification_tokens; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.email_verification_tokens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token_hash text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    used_at timestamp with time zone
);


--

-- Name: login_audit; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.login_audit (
    id bigint NOT NULL,
    user_id bigint,
    username_attempt character varying(255),
    login_time timestamp with time zone DEFAULT now() NOT NULL,
    success boolean NOT NULL,
    ip_address inet,
    failure_reason character varying(500)
);


--

-- Name: password_history; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.password_history (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    password_hash text NOT NULL,
    changed_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: password_reset_tokens; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.password_reset_tokens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token_hash text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    used_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint
);


--

-- Name: permissions; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.permissions (
    id bigint NOT NULL,
    permission_code character varying(150) NOT NULL,
    module_name character varying(100) NOT NULL,
    action_name character varying(100) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint
);


--

-- Name: policy_conditions; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.policy_conditions (
    id bigint NOT NULL,
    rule_id bigint NOT NULL,
    attribute_name character varying(200),
    operator character varying(50),
    comparison_value text
);


--

-- Name: policy_rules; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.policy_rules (
    id bigint NOT NULL,
    policy_id bigint NOT NULL,
    resource_type character varying(100) NOT NULL,
    expression text NOT NULL,
    priority integer DEFAULT 100
);


--

-- Name: responsibility_types; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.responsibility_types (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--

-- Name: role_delegations; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.role_delegations (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    from_user_id bigint NOT NULL,
    to_user_id bigint NOT NULL,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    reason text,
    created_at timestamp with time zone DEFAULT now()
);


--

-- Name: role_permissions; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.role_permissions (
    role_id bigint NOT NULL,
    permission_id bigint NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    id bigint NOT NULL
);


--

-- Name: roles; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.roles (
    id bigint NOT NULL,
    code character varying(100) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    description text,
    is_system_role boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint
);


--

-- Name: security_events; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.security_events (
    id bigint NOT NULL,
    event_type character varying(100) NOT NULL,
    severity character varying(20) NOT NULL,
    user_id bigint,
    source_ip inet,
    details jsonb,
    event_time timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_security_events_severity CHECK (((severity)::text = ANY (ARRAY[('LOW'::character varying)::text, ('MEDIUM'::character varying)::text, ('HIGH'::character varying)::text, ('CRITICAL'::character varying)::text])))
);


--

-- Name: segregation_rules; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.segregation_rules (
    id bigint NOT NULL,
    source_role_id bigint NOT NULL,
    target_role_id bigint NOT NULL,
    violation_type character varying(100) NOT NULL,
    active boolean DEFAULT true
);


--

-- Name: sessions; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.sessions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    session_token uuid DEFAULT gen_random_uuid() NOT NULL,
    ip_address inet,
    user_agent text,
    login_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    revoked_at timestamp with time zone
);


--

-- Name: user_profiles; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.user_profiles (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    national_id character varying(50),
    passport_number character varying(50),
    gender character varying(20) DEFAULT 'Male'::character varying,
    date_of_birth date,
    nationality_code character varying(10),
    academic_title character varying(200),
    specialization character varying(300),
    biography text,
    cv_document_id bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    academic_title_id bigint,
    CONSTRAINT chk_user_profiles_gender CHECK (((gender IS NULL) OR ((gender)::text = ANY (ARRAY[('MALE'::character varying)::text, ('FEMALE'::character varying)::text]))))
);


--

-- Name: user_responsibilities; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.user_responsibilities (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id bigint NOT NULL,
    responsibility_type_id bigint NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id bigint NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    assigned_by bigint,
    revoked_at timestamp with time zone,
    revoked_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    deleted_by bigint,
    deleted_at time with time zone,
    created_by bigint,
    updated_by bigint
);


--

-- Name: user_roles; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.user_roles (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    role_id bigint NOT NULL,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    assigned_by bigint
);


--


