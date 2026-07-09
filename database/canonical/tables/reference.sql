-- =========================================================================
-- reference — TABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: academic_titles; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.academic_titles (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    display_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--

-- Name: application_statuses; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.application_statuses (
    id bigint NOT NULL,
    status_code character varying(100) NOT NULL,
    status_name_ar character varying(300) NOT NULL,
    status_name_en character varying(300),
    display_order integer DEFAULT 1,
    is_terminal boolean DEFAULT false
);


--

-- Name: committee_decision_types; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.committee_decision_types (
    id bigint NOT NULL,
    decision_code character varying(100) NOT NULL,
    decision_name character varying(300) NOT NULL,
    is_approval boolean DEFAULT false NOT NULL
);


--

-- Name: document_statuses; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.document_statuses (
    id bigint NOT NULL,
    status_code character varying(50) NOT NULL,
    status_name character varying(200) NOT NULL
);


--

-- Name: institutions_registry; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.institutions_registry (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    national_id character varying(50) NOT NULL,
    name_ar character varying(300) NOT NULL,
    name_en character varying(300),
    type character varying(100) NOT NULL,
    address text,
    city character varying(100),
    country character varying(100) DEFAULT 'Saudi Arabia'::character varying NOT NULL,
    phone character varying(50),
    email character varying(200),
    website character varying(200),
    is_accredited boolean DEFAULT false NOT NULL,
    accreditation_body character varying(200),
    license_number character varying(100),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--

-- Name: licenses_registry; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.licenses_registry (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id bigint,
    profession_id bigint,
    license_number character varying(100) NOT NULL,
    issuing_body character varying(200),
    issued_date date,
    expiry_date date,
    license_document_url text,
    verification_status character varying(30) DEFAULT 'PENDING'::character varying NOT NULL,
    verified_by bigint,
    verified_at timestamp with time zone,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--

-- Name: lookup_categories; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.lookup_categories (
    id bigint NOT NULL,
    category_code character varying(100) NOT NULL,
    category_name_ar character varying(300) NOT NULL,
    category_name_en character varying(300),
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: lookup_values; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.lookup_values (
    id bigint NOT NULL,
    category_id bigint NOT NULL,
    value_code character varying(100) NOT NULL,
    value_name_ar character varying(500) NOT NULL,
    value_name_en character varying(500),
    display_order integer DEFAULT 1,
    is_default boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: notification_statuses; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.notification_statuses (
    id bigint NOT NULL,
    status_code character varying(50) NOT NULL,
    status_name character varying(200) NOT NULL
);


--

-- Name: priority_levels; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.priority_levels (
    id bigint NOT NULL,
    priority_code character varying(50) NOT NULL,
    priority_name character varying(200) NOT NULL,
    priority_order integer NOT NULL
);


--

-- Name: professions_registry; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.professions_registry (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    category character varying(100),
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--

-- Name: review_statuses; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.review_statuses (
    id bigint NOT NULL,
    status_code character varying(100) NOT NULL,
    status_name character varying(300) NOT NULL,
    is_terminal boolean DEFAULT false
);


--

-- Name: risk_levels; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.risk_levels (
    id bigint NOT NULL,
    risk_code character varying(50) NOT NULL,
    risk_name character varying(200) NOT NULL,
    severity_score integer NOT NULL
);


--

-- Name: status_types; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.status_types (
    id bigint NOT NULL,
    status_type_code character varying(100) NOT NULL,
    status_type_name character varying(300) NOT NULL,
    description text
);


--

-- Name: vote_types; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.vote_types (
    id bigint NOT NULL,
    vote_code character varying(100) NOT NULL,
    vote_name character varying(300) NOT NULL,
    display_order integer DEFAULT 1 NOT NULL
);


--

-- Name: workflow_statuses; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.workflow_statuses (
    id bigint NOT NULL,
    status_code character varying(100) NOT NULL,
    status_name character varying(300) NOT NULL
);


--


