-- =========================================================================
-- system — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--

-- Name: business_rules business_rules_code_key; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.business_rules
    ADD CONSTRAINT business_rules_code_key UNIQUE (code);


--

-- Name: business_rules business_rules_pkey; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.business_rules
    ADD CONSTRAINT business_rules_pkey PRIMARY KEY (id);


--

-- Name: feature_flags feature_flags_code_key; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.feature_flags
    ADD CONSTRAINT feature_flags_code_key UNIQUE (code);


--

-- Name: feature_flags feature_flags_pkey; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.feature_flags
    ADD CONSTRAINT feature_flags_pkey PRIMARY KEY (id);


--

-- Name: audit_config pk_audit_config; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.audit_config
    ADD CONSTRAINT pk_audit_config PRIMARY KEY (id);


--

-- Name: email_config pk_email_config; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.email_config
    ADD CONSTRAINT pk_email_config PRIMARY KEY (id);


--

-- Name: maintenance_log pk_maintenance_log; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.maintenance_log
    ADD CONSTRAINT pk_maintenance_log PRIMARY KEY (id);


--

-- Name: rule_actions pk_rule_actions; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_actions
    ADD CONSTRAINT pk_rule_actions PRIMARY KEY (id);


--

-- Name: rule_conditions pk_rule_conditions; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_conditions
    ADD CONSTRAINT pk_rule_conditions PRIMARY KEY (id);


--

-- Name: rule_executions pk_rule_executions; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_executions
    ADD CONSTRAINT pk_rule_executions PRIMARY KEY (id);


--

-- Name: saved_searches pk_saved_searches; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.saved_searches
    ADD CONSTRAINT pk_saved_searches PRIMARY KEY (id);


--

-- Name: search_audit pk_search_audit; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.search_audit
    ADD CONSTRAINT pk_search_audit PRIMARY KEY (id);


--

-- Name: search_indexes pk_search_indexes; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.search_indexes
    ADD CONSTRAINT pk_search_indexes PRIMARY KEY (id);


--

-- Name: sms_config pk_sms_config; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.sms_config
    ADD CONSTRAINT pk_sms_config PRIMARY KEY (id);


--

-- Name: system_config pk_system_config; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.system_config
    ADD CONSTRAINT pk_system_config PRIMARY KEY (id);


--

-- Name: push_config push_config_pkey; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.push_config
    ADD CONSTRAINT push_config_pkey PRIMARY KEY (id);


--

-- Name: rule_versions rule_versions_pkey; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_versions
    ADD CONSTRAINT rule_versions_pkey PRIMARY KEY (id);


--

-- Name: audit_config uq_audit_config_entity; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.audit_config
    ADD CONSTRAINT uq_audit_config_entity UNIQUE (entity_name);


--

-- Name: saved_searches uq_saved_searches_uuid; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.saved_searches
    ADD CONSTRAINT uq_saved_searches_uuid UNIQUE (uuid);


--

-- Name: system_config uq_system_config_key; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.system_config
    ADD CONSTRAINT uq_system_config_key UNIQUE (config_key);


--


-- =========================================================================
-- system — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: audit_log audit_log_user_id_fkey; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.audit_log
    ADD CONSTRAINT audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES security.users(id);


--

-- Name: maintenance_log fk_maintenance_log_user; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.maintenance_log
    ADD CONSTRAINT fk_maintenance_log_user FOREIGN KEY (performed_by) REFERENCES security.users(id);


--

-- Name: rule_actions fk_rule_actions_rule; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_actions
    ADD CONSTRAINT fk_rule_actions_rule FOREIGN KEY (rule_id) REFERENCES system.business_rules(id) ON DELETE CASCADE;


--

-- Name: rule_conditions fk_rule_conditions_rule; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_conditions
    ADD CONSTRAINT fk_rule_conditions_rule FOREIGN KEY (rule_id) REFERENCES system.business_rules(id) ON DELETE CASCADE;


--

-- Name: rule_executions fk_rule_executions_rule; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_executions
    ADD CONSTRAINT fk_rule_executions_rule FOREIGN KEY (rule_id) REFERENCES system.business_rules(id) ON DELETE CASCADE;


--

-- Name: rule_executions fk_rule_executions_triggered_by; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_executions
    ADD CONSTRAINT fk_rule_executions_triggered_by FOREIGN KEY (triggered_by) REFERENCES security.users(id) ON DELETE SET NULL;


--

-- Name: saved_searches fk_saved_searches_user; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.saved_searches
    ADD CONSTRAINT fk_saved_searches_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--

-- Name: search_audit fk_search_audit_user; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.search_audit
    ADD CONSTRAINT fk_search_audit_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE SET NULL;


--


