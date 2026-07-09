-- =========================================================================
-- reference — SEQUENCE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: academic_titles_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.academic_titles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.academic_titles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: application_statuses_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.application_statuses ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.application_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: committee_decision_types_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.committee_decision_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.committee_decision_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: document_statuses_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.document_statuses ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.document_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: institutions_registry_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.institutions_registry ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.institutions_registry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: licenses_registry_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.licenses_registry ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.licenses_registry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: lookup_categories_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.lookup_categories ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.lookup_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: lookup_values_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.lookup_values ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.lookup_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: notification_statuses_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.notification_statuses ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.notification_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: priority_levels_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.priority_levels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.priority_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: professions_registry_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.professions_registry ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.professions_registry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: review_statuses_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.review_statuses ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.review_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: risk_levels_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.risk_levels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.risk_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: status_types_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.status_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.status_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: vote_types_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.vote_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.vote_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: workflow_statuses_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.workflow_statuses ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.workflow_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--


