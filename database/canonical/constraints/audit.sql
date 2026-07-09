-- =========================================================================
-- audit — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: hash_ledger hash_ledger_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.hash_ledger
    ADD CONSTRAINT hash_ledger_pkey PRIMARY KEY (id);


--

-- Name: audit_details pk_audit_details; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.audit_details
    ADD CONSTRAINT pk_audit_details PRIMARY KEY (id);


--

-- Name: audit_logs pk_audit_logs; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.audit_logs
    ADD CONSTRAINT pk_audit_logs PRIMARY KEY (id);


--

-- Name: entity_changes pk_entity_changes; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.entity_changes
    ADD CONSTRAINT pk_entity_changes PRIMARY KEY (id);


--


-- =========================================================================
-- audit — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: audit_details fk_audit_details_log; Type: FK CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.audit_details
    ADD CONSTRAINT fk_audit_details_log FOREIGN KEY (audit_log_id) REFERENCES audit.audit_logs(id) ON DELETE CASCADE;


--

-- Name: audit_logs fk_audit_logs_user; Type: FK CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.audit_logs
    ADD CONSTRAINT fk_audit_logs_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--

-- Name: entity_changes fk_entity_changes_user; Type: FK CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.entity_changes
    ADD CONSTRAINT fk_entity_changes_user FOREIGN KEY (changed_by) REFERENCES security.users(id);


--


