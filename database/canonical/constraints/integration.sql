-- =========================================================================
-- integration — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: data_sync_jobs pk_data_sync_jobs; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.data_sync_jobs
    ADD CONSTRAINT pk_data_sync_jobs PRIMARY KEY (id);


--

-- Name: event_bus_config pk_event_bus_config; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.event_bus_config
    ADD CONSTRAINT pk_event_bus_config PRIMARY KEY (id);


--

-- Name: event_outbox pk_event_outbox; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.event_outbox
    ADD CONSTRAINT pk_event_outbox PRIMARY KEY (id);


--

-- Name: event_subscriptions pk_event_subscriptions; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.event_subscriptions
    ADD CONSTRAINT pk_event_subscriptions PRIMARY KEY (id);


--

-- Name: external_systems pk_external_systems; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.external_systems
    ADD CONSTRAINT pk_external_systems PRIMARY KEY (id);


--

-- Name: integration_credentials pk_integration_credentials; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_credentials
    ADD CONSTRAINT pk_integration_credentials PRIMARY KEY (id);


--

-- Name: integration_failures pk_integration_failures; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_failures
    ADD CONSTRAINT pk_integration_failures PRIMARY KEY (id);


--

-- Name: integration_logs pk_integration_logs; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_logs
    ADD CONSTRAINT pk_integration_logs PRIMARY KEY (id);


--

-- Name: retry_queue pk_retry_queue; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.retry_queue
    ADD CONSTRAINT pk_retry_queue PRIMARY KEY (id);


--

-- Name: webhooks pk_webhooks; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.webhooks
    ADD CONSTRAINT pk_webhooks PRIMARY KEY (id);


--

-- Name: data_sync_jobs uq_data_sync_jobs_uuid; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.data_sync_jobs
    ADD CONSTRAINT uq_data_sync_jobs_uuid UNIQUE (uuid);


--

-- Name: event_bus_config uq_event_bus_config_key; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.event_bus_config
    ADD CONSTRAINT uq_event_bus_config_key UNIQUE (config_key);


--

-- Name: event_outbox uq_event_outbox_event_id; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.event_outbox
    ADD CONSTRAINT uq_event_outbox_event_id UNIQUE (event_id);


--

-- Name: external_systems uq_external_systems_code; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.external_systems
    ADD CONSTRAINT uq_external_systems_code UNIQUE (code);


--


-- =========================================================================
-- integration — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: data_sync_jobs fk_data_sync_jobs_system; Type: FK CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.data_sync_jobs
    ADD CONSTRAINT fk_data_sync_jobs_system FOREIGN KEY (external_system_id) REFERENCES integration.external_systems(id) ON DELETE CASCADE;


--

-- Name: integration_credentials fk_integration_credentials_system; Type: FK CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_credentials
    ADD CONSTRAINT fk_integration_credentials_system FOREIGN KEY (external_system_id) REFERENCES integration.external_systems(id) ON DELETE CASCADE;


--

-- Name: integration_failures fk_integration_failures_resolved_by; Type: FK CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_failures
    ADD CONSTRAINT fk_integration_failures_resolved_by FOREIGN KEY (resolved_by) REFERENCES security.users(id) ON DELETE SET NULL;


--

-- Name: integration_failures fk_integration_failures_system; Type: FK CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_failures
    ADD CONSTRAINT fk_integration_failures_system FOREIGN KEY (external_system_id) REFERENCES integration.external_systems(id) ON DELETE SET NULL;


--

-- Name: integration_logs fk_integration_logs_user; Type: FK CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_logs
    ADD CONSTRAINT fk_integration_logs_user FOREIGN KEY (created_by) REFERENCES security.users(id);


--


