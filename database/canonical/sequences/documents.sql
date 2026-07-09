-- =========================================================================
-- documents — SEQUENCE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: approval_certificate_documents_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.approval_certificate_documents ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.approval_certificate_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: approval_certificates_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.approval_certificates ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.approval_certificates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: certificate_verification_log_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.certificate_verification_log ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.certificate_verification_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: document_access_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_access ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_access_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: document_approvals_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_approvals ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_approvals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: document_audit_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_audit ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: document_classifications_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_classifications ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_classifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: document_disposal_logs_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_disposal_logs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_disposal_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: document_retention_rules_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_retention_rules ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_retention_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: document_signatures_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_signatures ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_signatures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: document_types_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: document_versions_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_versions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: documents_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.documents ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: generated_documents_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.generated_documents ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.generated_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: templates_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.templates ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--


