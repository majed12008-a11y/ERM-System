-- =========================================================================
-- workflow — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_workflow_actions_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_actions_instance ON workflow.workflow_actions USING btree (workflow_instance_id);


--

-- Name: idx_workflow_comments_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_comments_instance ON workflow.workflow_comments USING btree (workflow_instance_id);


--

-- Name: idx_workflow_escalations_task; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_escalations_task ON workflow.workflow_escalations USING btree (workflow_task_id);


--

-- Name: idx_workflow_events_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_events_instance ON workflow.workflow_events USING btree (workflow_instance_id);


--

-- Name: idx_workflow_events_type; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_events_type ON workflow.workflow_events USING btree (event_type);


--

-- Name: idx_workflow_history_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_history_instance ON workflow.workflow_history USING btree (workflow_instance_id);


--

-- Name: idx_workflow_instances_active; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_instances_active ON workflow.workflow_instances USING btree (id) WHERE (deleted_at IS NULL);


--

-- Name: idx_workflow_instances_entity; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_instances_entity ON workflow.workflow_instances USING btree (entity_type, entity_id);


--

-- Name: idx_workflow_instances_state; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_instances_state ON workflow.workflow_instances USING btree (current_state_id);


--

-- Name: idx_workflow_sla_workflow; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_sla_workflow ON workflow.workflow_sla USING btree (workflow_id);


--

-- Name: idx_workflow_states_workflow; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_states_workflow ON workflow.workflow_states USING btree (workflow_id);


--

-- Name: idx_workflow_tasks_active; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_tasks_active ON workflow.workflow_tasks USING btree (id) WHERE (deleted_at IS NULL);


--

-- Name: idx_workflow_tasks_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_tasks_instance ON workflow.workflow_tasks USING btree (workflow_instance_id);


--

-- Name: idx_workflow_tasks_user; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_tasks_user ON workflow.workflow_tasks USING btree (assigned_to);


--

-- Name: idx_workflow_transitions_workflow; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_transitions_workflow ON workflow.workflow_transitions USING btree (workflow_id);


--

-- Name: idx_workflow_triggers_event; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_triggers_event ON workflow.workflow_triggers USING btree (trigger_event);


--

-- Name: idx_workflow_variables_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_variables_instance ON workflow.workflow_variables USING btree (workflow_instance_id);


--

-- Name: idx_workflow_variables_json; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_variables_json ON workflow.workflow_variables USING gin (variable_value);


--

-- Name: idx_workflows_entity; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflows_entity ON workflow.workflows USING btree (entity_type);


--

-- Name: uq_workflow_instance_active; Type: INDEX; Schema: workflow; Owner: -
--

CREATE UNIQUE INDEX uq_workflow_instance_active ON workflow.workflow_instances USING btree (entity_type, entity_id) WHERE (((status_code)::text = 'ACTIVE'::text) AND (deleted_at IS NULL));


--


