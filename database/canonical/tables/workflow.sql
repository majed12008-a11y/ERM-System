-- =========================================================================
-- workflow — TABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: workflow_instances; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_instances (
    id bigint NOT NULL,
    workflow_id bigint NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    current_state_id bigint NOT NULL,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    status_code character varying(50) DEFAULT 'ACTIVE'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_workflow_workflow_instances_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: workflow_sla; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_sla (
    id bigint NOT NULL,
    workflow_id bigint NOT NULL,
    state_id bigint NOT NULL,
    max_duration_hours integer NOT NULL,
    warning_hours integer,
    is_active boolean DEFAULT true NOT NULL
);


--

-- Name: workflow_tasks; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_tasks (
    id bigint NOT NULL,
    workflow_instance_id bigint NOT NULL,
    task_code character varying(100) NOT NULL,
    task_name character varying(300) NOT NULL,
    assigned_to bigint,
    due_date timestamp with time zone,
    completed_at timestamp with time zone,
    task_status character varying(50) DEFAULT 'OPEN'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_workflow_workflow_tasks_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: workflow_actions; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_actions (
    id bigint NOT NULL,
    workflow_instance_id bigint NOT NULL,
    transition_id bigint NOT NULL,
    action_by bigint NOT NULL,
    action_comment text,
    action_date timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: workflow_comments; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_comments (
    id bigint NOT NULL,
    workflow_instance_id bigint NOT NULL,
    user_id bigint NOT NULL,
    comment_text text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: workflow_escalations; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_escalations (
    id bigint NOT NULL,
    workflow_task_id bigint NOT NULL,
    escalation_level integer NOT NULL,
    escalated_to bigint,
    escalation_reason text,
    escalated_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: workflow_events; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_events (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    workflow_instance_id bigint,
    event_type character varying(100) NOT NULL,
    event_data jsonb DEFAULT '{}'::jsonb,
    source character varying(100),
    created_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: workflow_history; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_history (
    id bigint NOT NULL,
    workflow_instance_id bigint NOT NULL,
    from_state_id bigint,
    to_state_id bigint,
    transition_id bigint,
    action_by bigint,
    action_date timestamp with time zone DEFAULT now() NOT NULL,
    comments text
);


--

-- Name: workflow_schedulers; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_schedulers (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    cron_expression character varying(100) NOT NULL,
    workflow_id bigint NOT NULL,
    action_params jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true NOT NULL,
    last_run_at timestamp with time zone,
    next_run_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--

-- Name: workflow_states; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_states (
    id bigint NOT NULL,
    workflow_id bigint NOT NULL,
    state_code character varying(100) NOT NULL,
    state_name character varying(300) NOT NULL,
    is_initial boolean DEFAULT false NOT NULL,
    is_terminal boolean DEFAULT false NOT NULL,
    display_order integer DEFAULT 1 NOT NULL
);


--

-- Name: workflow_transitions; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_transitions (
    id bigint NOT NULL,
    workflow_id bigint NOT NULL,
    from_state_id bigint NOT NULL,
    to_state_id bigint NOT NULL,
    transition_code character varying(100) NOT NULL,
    transition_name character varying(300) NOT NULL,
    requires_comment boolean DEFAULT false NOT NULL,
    requires_vote boolean DEFAULT false NOT NULL,
    allowed_roles character varying(500)
);


--

-- Name: workflow_triggers; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_triggers (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    trigger_event character varying(100) NOT NULL,
    trigger_conditions jsonb DEFAULT '{}'::jsonb,
    target_workflow_id bigint,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--

-- Name: workflow_variables; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_variables (
    id bigint NOT NULL,
    workflow_instance_id bigint NOT NULL,
    variable_name character varying(200) NOT NULL,
    variable_value jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: workflows; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflows (
    id bigint NOT NULL,
    workflow_code character varying(100) NOT NULL,
    workflow_name character varying(300) NOT NULL,
    entity_type character varying(100) NOT NULL,
    version_no integer DEFAULT 1 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_workflow_workflows_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--


