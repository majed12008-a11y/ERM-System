-- =========================================================================
-- integration — SEQUENCE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: data_sync_jobs_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.data_sync_jobs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.data_sync_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: event_bus_config_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.event_bus_config ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.event_bus_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: event_outbox_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.event_outbox ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.event_outbox_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: event_subscriptions_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.event_subscriptions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.event_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: external_systems_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.external_systems ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.external_systems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: integration_credentials_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.integration_credentials ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.integration_credentials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: integration_failures_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.integration_failures ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.integration_failures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: integration_logs_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.integration_logs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.integration_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: retry_queue_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.retry_queue ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.retry_queue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: webhooks_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.webhooks ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.webhooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--


