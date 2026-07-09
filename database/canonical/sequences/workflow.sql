-- =========================================================================
-- workflow — SEQUENCE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: workflow_actions_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_actions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: workflow_comments_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_comments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: workflow_escalations_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_escalations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_escalations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: workflow_events_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_events ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: workflow_history_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_history ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: workflow_instances_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: workflow_schedulers_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_schedulers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_schedulers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: workflow_sla_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_sla ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_sla_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: workflow_states_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_states ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: workflow_tasks_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_tasks ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: workflow_transitions_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_transitions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: workflow_triggers_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_triggers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_triggers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: workflow_variables_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_variables ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_variables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: workflows_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflows ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--


