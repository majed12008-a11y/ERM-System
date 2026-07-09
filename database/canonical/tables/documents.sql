-- =========================================================================
-- documents — TABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: approval_certificate_documents; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.approval_certificate_documents (
    id bigint NOT NULL,
    certificate_id bigint NOT NULL,
    document_id bigint NOT NULL,
    is_original boolean DEFAULT true NOT NULL,
    generated_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: approval_certificates; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.approval_certificates (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    serial_number character varying(50) NOT NULL,
    version_no integer DEFAULT 1 NOT NULL,
    status documents.certificate_status DEFAULT 'DRAFT'::character varying NOT NULL,
    issued_to_user_id bigint NOT NULL,
    issued_by_user_id bigint NOT NULL,
    issued_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    revoked_by bigint,
    revocation_reason text,
    superseded_by bigint,
    generation_error jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint
);


--

-- Name: certificate_verification_log; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.certificate_verification_log (
    id bigint NOT NULL,
    serial_number character varying(50) NOT NULL,
    verified_at timestamp with time zone DEFAULT now() NOT NULL,
    verified_by_ip character varying(50),
    result character varying(20) NOT NULL,
    details jsonb,
    CONSTRAINT certificate_verification_log_result_check CHECK (((result)::text = ANY (ARRAY[('VALID'::character varying)::text, ('REVOKED'::character varying)::text, ('SUPERSEDED'::character varying)::text, ('NOT_FOUND'::character varying)::text, ('ERROR'::character varying)::text])))
);


--

-- Name: document_access; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_access (
    id bigint NOT NULL,
    document_id bigint NOT NULL,
    user_id bigint,
    role_id bigint,
    access_type character varying(50) NOT NULL,
    granted_by bigint,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_documents_document_access_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: document_approvals; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_approvals (
    id bigint NOT NULL,
    document_id bigint NOT NULL,
    approver_id bigint NOT NULL,
    approval_status character varying(50) NOT NULL,
    approval_comments text,
    approved_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_documents_document_approvals_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: document_audit; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_audit (
    id bigint NOT NULL,
    document_id bigint NOT NULL,
    action_type character varying(100) NOT NULL,
    action_by bigint,
    action_timestamp timestamp with time zone DEFAULT now() NOT NULL,
    source_ip inet,
    details jsonb
);


--

-- Name: document_classifications; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_classifications (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    description text,
    clearance_required character varying(50),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--

-- Name: document_disposal_logs; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_disposal_logs (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    document_id bigint NOT NULL,
    disposed_at timestamp with time zone DEFAULT now() NOT NULL,
    disposed_by bigint NOT NULL,
    disposal_method character varying(50) NOT NULL,
    authorization_ref character varying(100),
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: document_retention_rules; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_retention_rules (
    id bigint NOT NULL,
    document_type_id bigint NOT NULL,
    retention_period_days integer NOT NULL,
    disposition_action character varying(50) DEFAULT 'ARCHIVE'::character varying NOT NULL,
    legal_basis text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--

-- Name: document_signatures; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_signatures (
    id bigint NOT NULL,
    document_id bigint NOT NULL,
    signer_id bigint NOT NULL,
    signature_type character varying(100) NOT NULL,
    signature_hash text,
    signed_at timestamp with time zone NOT NULL,
    certificate_serial character varying(500),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_documents_document_signatures_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: document_types; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_types (
    id bigint NOT NULL,
    type_code character varying(100) NOT NULL,
    type_name_ar character varying(300) NOT NULL,
    type_name_en character varying(300),
    description text,
    is_required boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: document_versions; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_versions (
    id bigint NOT NULL,
    document_id bigint NOT NULL,
    version_no integer NOT NULL,
    file_name character varying(1000) NOT NULL,
    storage_path text NOT NULL,
    checksum_sha256 character varying(128),
    uploaded_by bigint NOT NULL,
    uploaded_at timestamp with time zone DEFAULT now() NOT NULL,
    version_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_documents_document_versions_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: documents; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.documents (
    id bigint NOT NULL,
    document_type_id bigint NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    document_title character varying(1000) NOT NULL,
    file_name character varying(1000) NOT NULL,
    original_file_name character varying(1000),
    mime_type character varying(255),
    file_size_bytes bigint,
    storage_provider character varying(100),
    storage_path text NOT NULL,
    checksum_sha256 character varying(128),
    uploaded_by bigint NOT NULL,
    uploaded_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_documents_documents_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: generated_documents; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.generated_documents (
    id bigint NOT NULL,
    template_id bigint NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    generated_document_id bigint,
    generated_by bigint NOT NULL,
    generated_at timestamp with time zone DEFAULT now() NOT NULL,
    generation_parameters jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_documents_generated_documents_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: templates; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.templates (
    id bigint NOT NULL,
    template_code character varying(100) NOT NULL,
    template_name character varying(500) NOT NULL,
    template_type character varying(100) NOT NULL,
    template_content text NOT NULL,
    version_no integer DEFAULT 1 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_documents_templates_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--


