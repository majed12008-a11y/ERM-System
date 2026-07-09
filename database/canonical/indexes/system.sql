-- =========================================================================
-- system — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_audit_log_action; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_audit_log_action ON system.audit_log USING btree (action_type);


--

-- Name: idx_audit_log_created; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_audit_log_created ON system.audit_log USING btree (created_at DESC);


--

-- Name: idx_audit_log_created_desc; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_audit_log_created_desc ON system.audit_log USING btree (created_at DESC);


--

-- Name: idx_audit_log_entity; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_audit_log_entity ON system.audit_log USING btree (entity_type, entity_id);


--

-- Name: idx_audit_log_user; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_audit_log_user ON system.audit_log USING btree (user_id);


--

-- Name: idx_maintenance_log_started; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_maintenance_log_started ON system.maintenance_log USING btree (started_at);


--

-- Name: idx_maintenance_log_status; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_maintenance_log_status ON system.maintenance_log USING btree (status);


--

-- Name: idx_rule_actions_rule; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_rule_actions_rule ON system.rule_actions USING btree (rule_id);


--

-- Name: idx_rule_conditions_rule; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_rule_conditions_rule ON system.rule_conditions USING btree (rule_id);


--

-- Name: idx_rule_executions_entity; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_rule_executions_entity ON system.rule_executions USING btree (entity_type, entity_id);


--

-- Name: idx_rule_executions_rule; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_rule_executions_rule ON system.rule_executions USING btree (rule_id);


--

-- Name: idx_search_audit_created; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_search_audit_created ON system.search_audit USING btree (created_at);


--

-- Name: idx_search_audit_user; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_search_audit_user ON system.search_audit USING btree (user_id);


--

-- Name: idx_search_indexes_entity; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_search_indexes_entity ON system.search_indexes USING btree (entity_type, entity_id);


--

-- Name: idx_search_indexes_vector; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_search_indexes_vector ON system.search_indexes USING gin (search_vector);


--

-- Name: idx_system_config_group; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_system_config_group ON system.system_config USING btree (config_group);


--


