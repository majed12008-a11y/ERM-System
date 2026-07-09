-- =========================================================================
-- integration — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: TABLE data_sync_jobs; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON TABLE integration.data_sync_jobs IS 'وظائف مزامنة البيانات / Data Sync Jobs';


--

-- Name: COLUMN data_sync_jobs.created_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.data_sync_jobs.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN data_sync_jobs.created_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.data_sync_jobs.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN data_sync_jobs.updated_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.data_sync_jobs.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN data_sync_jobs.updated_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.data_sync_jobs.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN data_sync_jobs.deleted_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.data_sync_jobs.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN data_sync_jobs.deleted_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.data_sync_jobs.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN event_outbox.created_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.event_outbox.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN event_outbox.created_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.event_outbox.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN event_outbox.updated_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.event_outbox.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN event_outbox.updated_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.event_outbox.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN event_outbox.deleted_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.event_outbox.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN event_outbox.deleted_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.event_outbox.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE external_systems; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON TABLE integration.external_systems IS 'الأنظمة الخارجية المتصلة / External Systems';


--

-- Name: TABLE integration_credentials; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON TABLE integration.integration_credentials IS 'بيانات اعتماد التكامل / Integration Credentials';


--

-- Name: TABLE integration_failures; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON TABLE integration.integration_failures IS 'سجل فشل التكامل / Integration Failures';


--

-- Name: COLUMN retry_queue.created_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.retry_queue.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN retry_queue.created_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.retry_queue.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN retry_queue.updated_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.retry_queue.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN retry_queue.updated_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.retry_queue.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN retry_queue.deleted_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.retry_queue.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN retry_queue.deleted_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.retry_queue.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN webhooks.created_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.webhooks.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN webhooks.created_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.webhooks.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN webhooks.updated_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.webhooks.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN webhooks.updated_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.webhooks.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN webhooks.deleted_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.webhooks.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN webhooks.deleted_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.webhooks.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--


