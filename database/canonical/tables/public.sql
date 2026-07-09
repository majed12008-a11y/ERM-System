-- =========================================================================
-- public — TABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: perf_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.perf_results (
    stage_name text,
    query_name text,
    avg_ms numeric,
    min_ms numeric,
    max_ms numeric
);


--

-- Name: pgmigrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pgmigrations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    run_on timestamp without time zone NOT NULL
);


--

-- Name: v_chair_id; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v_chair_id (
    id bigint
);


--

-- Name: v_inst_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v_inst_codes (
    array_agg character varying[]
);


--

-- Name: v_user_id; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v_user_id (
    id bigint
);


--


