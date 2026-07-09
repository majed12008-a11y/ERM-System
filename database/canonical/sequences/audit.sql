-- =========================================================================
-- audit — DEFAULT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: hash_ledger id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.hash_ledger ALTER COLUMN id SET DEFAULT nextval('audit.hash_ledger_id_seq'::regclass);


--


-- =========================================================================
-- audit — SEQUENCE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: audit_details_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

ALTER TABLE audit.audit_details ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME audit.audit_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

ALTER TABLE audit.audit_logs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME audit.audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: entity_changes_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

ALTER TABLE audit.entity_changes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME audit.entity_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: hash_ledger_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

CREATE SEQUENCE audit.hash_ledger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--

-- Name: hash_ledger_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: -
--

ALTER SEQUENCE audit.hash_ledger_id_seq OWNED BY audit.hash_ledger.id;


--


