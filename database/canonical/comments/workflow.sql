-- =========================================================================
-- workflow — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: COLUMN workflow_instances.created_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_instances.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN workflow_instances.created_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_instances.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN workflow_instances.updated_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_instances.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN workflow_instances.updated_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_instances.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN workflow_instances.deleted_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_instances.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN workflow_instances.deleted_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_instances.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN workflow_tasks.created_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_tasks.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN workflow_tasks.created_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_tasks.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN workflow_tasks.updated_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_tasks.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN workflow_tasks.updated_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_tasks.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN workflow_tasks.deleted_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_tasks.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN workflow_tasks.deleted_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_tasks.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE workflow_events; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON TABLE workflow.workflow_events IS 'أحداث سير العمل / Workflow Events';


--

-- Name: TABLE workflow_schedulers; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON TABLE workflow.workflow_schedulers IS 'مجَدولات سير العمل / Workflow Schedulers';


--

-- Name: TABLE workflow_triggers; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON TABLE workflow.workflow_triggers IS 'مشغلات سير العمل / Workflow Triggers';


--

-- Name: COLUMN workflows.created_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflows.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN workflows.created_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflows.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN workflows.updated_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflows.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN workflows.updated_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflows.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN workflows.deleted_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflows.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN workflows.deleted_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflows.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--


