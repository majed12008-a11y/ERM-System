-- =========================================================================
-- reporting — SEQUENCE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: analytics_snapshots_id_seq; Type: SEQUENCE; Schema: reporting; Owner: -
--

ALTER TABLE reporting.analytics_snapshots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reporting.analytics_snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: dashboard_widgets_id_seq; Type: SEQUENCE; Schema: reporting; Owner: -
--

ALTER TABLE reporting.dashboard_widgets ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reporting.dashboard_widgets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: kpi_results_id_seq; Type: SEQUENCE; Schema: reporting; Owner: -
--

ALTER TABLE reporting.kpi_results ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reporting.kpi_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: report_definitions_id_seq; Type: SEQUENCE; Schema: reporting; Owner: -
--

ALTER TABLE reporting.report_definitions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reporting.report_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: report_executions_id_seq; Type: SEQUENCE; Schema: reporting; Owner: -
--

ALTER TABLE reporting.report_executions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reporting.report_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--


