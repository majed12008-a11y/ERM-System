-- =========================================================================
-- integration — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_data_sync_jobs_status; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_data_sync_jobs_status ON integration.data_sync_jobs USING btree (status);


--

-- Name: idx_data_sync_jobs_system; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_data_sync_jobs_system ON integration.data_sync_jobs USING btree (external_system_id);


--

-- Name: idx_event_outbox_created; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_event_outbox_created ON integration.event_outbox USING btree (created_at);


--

-- Name: idx_event_outbox_created_desc; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_event_outbox_created_desc ON integration.event_outbox USING btree (created_at DESC);


--

-- Name: idx_event_outbox_event_data; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_event_outbox_event_data ON integration.event_outbox USING gin (event_data);


--

-- Name: idx_event_outbox_status; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_event_outbox_status ON integration.event_outbox USING btree (status);


--

-- Name: idx_event_outbox_type; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_event_outbox_type ON integration.event_outbox USING btree (event_type);


--

-- Name: idx_event_subscriptions_event_type; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_event_subscriptions_event_type ON integration.event_subscriptions USING btree (event_type);


--

-- Name: idx_integration_logs_created; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_integration_logs_created ON integration.integration_logs USING btree (created_at);


--

-- Name: idx_integration_logs_created_desc; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_integration_logs_created_desc ON integration.integration_logs USING btree (created_at DESC);


--

-- Name: idx_integration_logs_status; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_integration_logs_status ON integration.integration_logs USING btree (status);


--

-- Name: idx_integration_logs_type; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_integration_logs_type ON integration.integration_logs USING btree (integration_type);


--

-- Name: idx_retry_queue_next_retry; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_retry_queue_next_retry ON integration.retry_queue USING btree (next_retry_at);


--

-- Name: idx_retry_queue_status; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_retry_queue_status ON integration.retry_queue USING btree (status);


--

-- Name: idx_webhooks_active; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_webhooks_active ON integration.webhooks USING btree (is_active);


--


