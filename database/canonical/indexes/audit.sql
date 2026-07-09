-- =========================================================================
-- audit — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_audit_details_log; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_details_log ON audit.audit_details USING btree (audit_log_id);


--

-- Name: idx_audit_logs_entity; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_logs_entity ON audit.audit_logs USING btree (entity_name, entity_id);


--

-- Name: idx_audit_logs_entity_timestamp; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_logs_entity_timestamp ON audit.audit_logs USING btree (entity_name, event_timestamp DESC);


--

-- Name: idx_audit_logs_new_values; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_logs_new_values ON audit.audit_logs USING gin (new_values);


--

-- Name: idx_audit_logs_old_values; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_logs_old_values ON audit.audit_logs USING gin (old_values);


--

-- Name: idx_audit_logs_timestamp; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_logs_timestamp ON audit.audit_logs USING btree (event_timestamp);


--

-- Name: idx_entity_changes_entity; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_entity_changes_entity ON audit.entity_changes USING btree (entity_name, entity_id);


--

-- Name: idx_entity_changes_json; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_entity_changes_json ON audit.entity_changes USING gin (details);


--


