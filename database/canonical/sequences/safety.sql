-- =========================================================================
-- safety — SEQUENCE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: adverse_events_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.adverse_events ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.adverse_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: corrective_actions_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.corrective_actions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.corrective_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: mitigation_actions_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.mitigation_actions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.mitigation_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: risk_assessments_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_assessments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.risk_assessments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: risk_categories_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_categories ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.risk_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: risk_incidents_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_incidents ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.risk_incidents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: risk_mitigations_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_mitigations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.risk_mitigations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: risk_register_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_register ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.risk_register_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: safety_committee_reviews_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.safety_committee_reviews ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.safety_committee_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: safety_followups_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.safety_followups ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.safety_followups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: safety_reports_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.safety_reports ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.safety_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: serious_adverse_events_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.serious_adverse_events ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.serious_adverse_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--


