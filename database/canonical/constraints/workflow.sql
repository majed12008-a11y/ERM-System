-- =========================================================================
-- workflow — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: workflow_actions pk_workflow_actions; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_actions
    ADD CONSTRAINT pk_workflow_actions PRIMARY KEY (id);


--

-- Name: workflow_comments pk_workflow_comments; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_comments
    ADD CONSTRAINT pk_workflow_comments PRIMARY KEY (id);


--

-- Name: workflow_escalations pk_workflow_escalations; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_escalations
    ADD CONSTRAINT pk_workflow_escalations PRIMARY KEY (id);


--

-- Name: workflow_events pk_workflow_events; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_events
    ADD CONSTRAINT pk_workflow_events PRIMARY KEY (id);


--

-- Name: workflow_history pk_workflow_history; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_history
    ADD CONSTRAINT pk_workflow_history PRIMARY KEY (id);


--

-- Name: workflow_instances pk_workflow_instances; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_instances
    ADD CONSTRAINT pk_workflow_instances PRIMARY KEY (id);


--

-- Name: workflow_schedulers pk_workflow_schedulers; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_schedulers
    ADD CONSTRAINT pk_workflow_schedulers PRIMARY KEY (id);


--

-- Name: workflow_sla pk_workflow_sla; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_sla
    ADD CONSTRAINT pk_workflow_sla PRIMARY KEY (id);


--

-- Name: workflow_states pk_workflow_states; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_states
    ADD CONSTRAINT pk_workflow_states PRIMARY KEY (id);


--

-- Name: workflow_tasks pk_workflow_tasks; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_tasks
    ADD CONSTRAINT pk_workflow_tasks PRIMARY KEY (id);


--

-- Name: workflow_transitions pk_workflow_transitions; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_transitions
    ADD CONSTRAINT pk_workflow_transitions PRIMARY KEY (id);


--

-- Name: workflow_triggers pk_workflow_triggers; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_triggers
    ADD CONSTRAINT pk_workflow_triggers PRIMARY KEY (id);


--

-- Name: workflow_variables pk_workflow_variables; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_variables
    ADD CONSTRAINT pk_workflow_variables PRIMARY KEY (id);


--

-- Name: workflows pk_workflows; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflows
    ADD CONSTRAINT pk_workflows PRIMARY KEY (id);


--

-- Name: workflow_events uq_workflow_events_uuid; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_events
    ADD CONSTRAINT uq_workflow_events_uuid UNIQUE (uuid);


--

-- Name: workflow_schedulers uq_workflow_schedulers_code; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_schedulers
    ADD CONSTRAINT uq_workflow_schedulers_code UNIQUE (code);


--

-- Name: workflow_states uq_workflow_state; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_states
    ADD CONSTRAINT uq_workflow_state UNIQUE (workflow_id, state_code);


--

-- Name: workflow_triggers uq_workflow_triggers_code; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_triggers
    ADD CONSTRAINT uq_workflow_triggers_code UNIQUE (code);


--

-- Name: workflows uq_workflows_code_version; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflows
    ADD CONSTRAINT uq_workflows_code_version UNIQUE (workflow_code, version_no);


--


-- =========================================================================
-- workflow — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: workflow_transitions fk_transition_from_state; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_transitions
    ADD CONSTRAINT fk_transition_from_state FOREIGN KEY (from_state_id) REFERENCES workflow.workflow_states(id);


--

-- Name: workflow_transitions fk_transition_to_state; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_transitions
    ADD CONSTRAINT fk_transition_to_state FOREIGN KEY (to_state_id) REFERENCES workflow.workflow_states(id);


--

-- Name: workflow_transitions fk_transition_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_transitions
    ADD CONSTRAINT fk_transition_workflow FOREIGN KEY (workflow_id) REFERENCES workflow.workflows(id);


--

-- Name: workflow_actions fk_workflow_actions_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_actions
    ADD CONSTRAINT fk_workflow_actions_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE CASCADE;


--

-- Name: workflow_actions fk_workflow_actions_transition; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_actions
    ADD CONSTRAINT fk_workflow_actions_transition FOREIGN KEY (transition_id) REFERENCES workflow.workflow_transitions(id);


--

-- Name: workflow_actions fk_workflow_actions_user; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_actions
    ADD CONSTRAINT fk_workflow_actions_user FOREIGN KEY (action_by) REFERENCES security.users(id);


--

-- Name: workflow_comments fk_workflow_comments_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_comments
    ADD CONSTRAINT fk_workflow_comments_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE CASCADE;


--

-- Name: workflow_comments fk_workflow_comments_user; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_comments
    ADD CONSTRAINT fk_workflow_comments_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--

-- Name: workflow_escalations fk_workflow_escalations_task; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_escalations
    ADD CONSTRAINT fk_workflow_escalations_task FOREIGN KEY (workflow_task_id) REFERENCES workflow.workflow_tasks(id) ON DELETE CASCADE;


--

-- Name: workflow_events fk_workflow_events_created_by; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_events
    ADD CONSTRAINT fk_workflow_events_created_by FOREIGN KEY (created_by) REFERENCES security.users(id) ON DELETE SET NULL;


--

-- Name: workflow_events fk_workflow_events_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_events
    ADD CONSTRAINT fk_workflow_events_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE SET NULL;


--

-- Name: workflow_history fk_workflow_history_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_history
    ADD CONSTRAINT fk_workflow_history_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE CASCADE;


--

-- Name: workflow_instances fk_workflow_instances_state; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_instances
    ADD CONSTRAINT fk_workflow_instances_state FOREIGN KEY (current_state_id) REFERENCES workflow.workflow_states(id);


--

-- Name: workflow_instances fk_workflow_instances_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_instances
    ADD CONSTRAINT fk_workflow_instances_workflow FOREIGN KEY (workflow_id) REFERENCES workflow.workflows(id);


--

-- Name: workflow_schedulers fk_workflow_schedulers_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_schedulers
    ADD CONSTRAINT fk_workflow_schedulers_workflow FOREIGN KEY (workflow_id) REFERENCES workflow.workflows(id);


--

-- Name: workflow_sla fk_workflow_sla_state; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_sla
    ADD CONSTRAINT fk_workflow_sla_state FOREIGN KEY (state_id) REFERENCES workflow.workflow_states(id);


--

-- Name: workflow_sla fk_workflow_sla_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_sla
    ADD CONSTRAINT fk_workflow_sla_workflow FOREIGN KEY (workflow_id) REFERENCES workflow.workflows(id);


--

-- Name: workflow_states fk_workflow_states_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_states
    ADD CONSTRAINT fk_workflow_states_workflow FOREIGN KEY (workflow_id) REFERENCES workflow.workflows(id) ON DELETE CASCADE;


--

-- Name: workflow_tasks fk_workflow_tasks_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_tasks
    ADD CONSTRAINT fk_workflow_tasks_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE CASCADE;


--

-- Name: workflow_tasks fk_workflow_tasks_user; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_tasks
    ADD CONSTRAINT fk_workflow_tasks_user FOREIGN KEY (assigned_to) REFERENCES security.users(id);


--

-- Name: workflow_triggers fk_workflow_triggers_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_triggers
    ADD CONSTRAINT fk_workflow_triggers_workflow FOREIGN KEY (target_workflow_id) REFERENCES workflow.workflows(id);


--

-- Name: workflow_variables fk_workflow_variables_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_variables
    ADD CONSTRAINT fk_workflow_variables_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE CASCADE;


--


