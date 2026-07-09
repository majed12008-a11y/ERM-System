-- =========================================================================
-- reporting — TABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: analytics_snapshots; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.analytics_snapshots (
    id bigint NOT NULL,
    snapshot_date date NOT NULL,
    snapshot_type character varying(100) NOT NULL,
    metrics jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: dashboard_widgets; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.dashboard_widgets (
    id bigint NOT NULL,
    widget_code character varying(100) NOT NULL,
    widget_name character varying(300) NOT NULL,
    widget_type character varying(100),
    configuration jsonb,
    is_active boolean DEFAULT true NOT NULL
);


--

-- Name: kpi_results; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.kpi_results (
    id bigint NOT NULL,
    kpi_code character varying(100) NOT NULL,
    measurement_date date NOT NULL,
    kpi_value numeric(18,4),
    target_value numeric(18,4),
    calculated_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: report_definitions; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.report_definitions (
    id bigint NOT NULL,
    report_code character varying(100) NOT NULL,
    report_name character varying(300) NOT NULL,
    report_category character varying(100),
    sql_definition text,
    is_active boolean DEFAULT true NOT NULL
);


--

-- Name: report_executions; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.report_executions (
    id bigint NOT NULL,
    report_id bigint NOT NULL,
    executed_by bigint,
    execution_start timestamp with time zone,
    execution_end timestamp with time zone,
    execution_status character varying(50),
    output_file text
);


--


