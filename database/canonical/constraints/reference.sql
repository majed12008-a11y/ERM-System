-- =========================================================================
-- reference — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: academic_titles academic_titles_code_key; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.academic_titles
    ADD CONSTRAINT academic_titles_code_key UNIQUE (code);


--

-- Name: academic_titles academic_titles_pkey; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.academic_titles
    ADD CONSTRAINT academic_titles_pkey PRIMARY KEY (id);


--

-- Name: application_statuses pk_application_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.application_statuses
    ADD CONSTRAINT pk_application_statuses PRIMARY KEY (id);


--

-- Name: committee_decision_types pk_committee_decision_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.committee_decision_types
    ADD CONSTRAINT pk_committee_decision_types PRIMARY KEY (id);


--

-- Name: document_statuses pk_document_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.document_statuses
    ADD CONSTRAINT pk_document_statuses PRIMARY KEY (id);


--

-- Name: institutions_registry pk_institutions_registry; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.institutions_registry
    ADD CONSTRAINT pk_institutions_registry PRIMARY KEY (id);


--

-- Name: licenses_registry pk_licenses_registry; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT pk_licenses_registry PRIMARY KEY (id);


--

-- Name: lookup_categories pk_lookup_categories; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.lookup_categories
    ADD CONSTRAINT pk_lookup_categories PRIMARY KEY (id);


--

-- Name: lookup_values pk_lookup_values; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.lookup_values
    ADD CONSTRAINT pk_lookup_values PRIMARY KEY (id);


--

-- Name: notification_statuses pk_notification_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.notification_statuses
    ADD CONSTRAINT pk_notification_statuses PRIMARY KEY (id);


--

-- Name: priority_levels pk_priority_levels; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.priority_levels
    ADD CONSTRAINT pk_priority_levels PRIMARY KEY (id);


--

-- Name: professions_registry pk_professions_registry; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.professions_registry
    ADD CONSTRAINT pk_professions_registry PRIMARY KEY (id);


--

-- Name: review_statuses pk_review_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.review_statuses
    ADD CONSTRAINT pk_review_statuses PRIMARY KEY (id);


--

-- Name: risk_levels pk_risk_levels; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.risk_levels
    ADD CONSTRAINT pk_risk_levels PRIMARY KEY (id);


--

-- Name: status_types pk_status_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.status_types
    ADD CONSTRAINT pk_status_types PRIMARY KEY (id);


--

-- Name: vote_types pk_vote_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.vote_types
    ADD CONSTRAINT pk_vote_types PRIMARY KEY (id);


--

-- Name: workflow_statuses pk_workflow_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.workflow_statuses
    ADD CONSTRAINT pk_workflow_statuses PRIMARY KEY (id);


--

-- Name: application_statuses uq_application_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.application_statuses
    ADD CONSTRAINT uq_application_statuses UNIQUE (status_code);


--

-- Name: committee_decision_types uq_committee_decision_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.committee_decision_types
    ADD CONSTRAINT uq_committee_decision_types UNIQUE (decision_code);


--

-- Name: document_statuses uq_document_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.document_statuses
    ADD CONSTRAINT uq_document_statuses UNIQUE (status_code);


--

-- Name: institutions_registry uq_institutions_registry_national_id; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.institutions_registry
    ADD CONSTRAINT uq_institutions_registry_national_id UNIQUE (national_id);


--

-- Name: institutions_registry uq_institutions_registry_uuid; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.institutions_registry
    ADD CONSTRAINT uq_institutions_registry_uuid UNIQUE (uuid);


--

-- Name: licenses_registry uq_licenses_registry_license_number; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT uq_licenses_registry_license_number UNIQUE (license_number);


--

-- Name: licenses_registry uq_licenses_registry_uuid; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT uq_licenses_registry_uuid UNIQUE (uuid);


--

-- Name: lookup_categories uq_lookup_categories; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.lookup_categories
    ADD CONSTRAINT uq_lookup_categories UNIQUE (category_code);


--

-- Name: lookup_values uq_lookup_values; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.lookup_values
    ADD CONSTRAINT uq_lookup_values UNIQUE (category_id, value_code);


--

-- Name: notification_statuses uq_notification_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.notification_statuses
    ADD CONSTRAINT uq_notification_statuses UNIQUE (status_code);


--

-- Name: priority_levels uq_priority_levels; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.priority_levels
    ADD CONSTRAINT uq_priority_levels UNIQUE (priority_code);


--

-- Name: professions_registry uq_professions_registry_code; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.professions_registry
    ADD CONSTRAINT uq_professions_registry_code UNIQUE (code);


--

-- Name: review_statuses uq_review_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.review_statuses
    ADD CONSTRAINT uq_review_statuses UNIQUE (status_code);


--

-- Name: risk_levels uq_risk_levels; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.risk_levels
    ADD CONSTRAINT uq_risk_levels UNIQUE (risk_code);


--

-- Name: status_types uq_status_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.status_types
    ADD CONSTRAINT uq_status_types UNIQUE (status_type_code);


--

-- Name: vote_types uq_vote_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.vote_types
    ADD CONSTRAINT uq_vote_types UNIQUE (vote_code);


--

-- Name: workflow_statuses uq_workflow_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.workflow_statuses
    ADD CONSTRAINT uq_workflow_statuses UNIQUE (status_code);


--


-- =========================================================================
-- reference — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: licenses_registry fk_licenses_registry_profession; Type: FK CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT fk_licenses_registry_profession FOREIGN KEY (profession_id) REFERENCES reference.professions_registry(id);


--

-- Name: licenses_registry fk_licenses_registry_user; Type: FK CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT fk_licenses_registry_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--

-- Name: licenses_registry fk_licenses_registry_verified_by; Type: FK CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT fk_licenses_registry_verified_by FOREIGN KEY (verified_by) REFERENCES security.users(id);


--

-- Name: lookup_values fk_lookup_values_category; Type: FK CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.lookup_values
    ADD CONSTRAINT fk_lookup_values_category FOREIGN KEY (category_id) REFERENCES reference.lookup_categories(id) ON DELETE CASCADE;


--


