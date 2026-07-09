-- =========================================================================
-- monitoring — SEQUENCE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: compliance_reviews_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.compliance_reviews ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.compliance_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: corrective_actions_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.corrective_actions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.corrective_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: deviations_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.deviations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.deviations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: inspection_reports_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.inspection_reports ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.inspection_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: inspections_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.inspections ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.inspections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: monitoring_findings_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.monitoring_findings ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.monitoring_findings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: monitoring_plans_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.monitoring_plans ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.monitoring_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: monitoring_visits_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.monitoring_visits ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.monitoring_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: preventive_actions_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.preventive_actions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.preventive_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: protocol_violations_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.protocol_violations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.protocol_violations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--


