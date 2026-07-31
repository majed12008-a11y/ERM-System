-- =========================================================================
-- templates — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: pk_categories; Type: CONSTRAINT; Schema: templates; Owner: -
--

ALTER TABLE ONLY templates.categories ADD CONSTRAINT pk_categories PRIMARY KEY (id);
ALTER TABLE ONLY templates.templates ADD CONSTRAINT pk_templates PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_versions ADD CONSTRAINT pk_template_versions PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_localizations ADD CONSTRAINT pk_template_localizations PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_variables ADD CONSTRAINT pk_template_variables PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_partials ADD CONSTRAINT pk_template_partials PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_packages ADD CONSTRAINT pk_template_packages PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_package_members ADD CONSTRAINT pk_template_package_members PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_outputs ADD CONSTRAINT pk_template_outputs PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_render_jobs ADD CONSTRAINT pk_template_render_jobs PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_render_history ADD CONSTRAINT pk_template_render_history PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_approval_workflow ADD CONSTRAINT pk_template_approval_workflow PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_usage_statistics ADD CONSTRAINT pk_template_usage_statistics PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_version_audit ADD CONSTRAINT pk_template_version_audit PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_validation_tests ADD CONSTRAINT pk_template_validation_tests PRIMARY KEY (id);
ALTER TABLE ONLY templates.event_template_mapping ADD CONSTRAINT pk_event_template_mapping PRIMARY KEY (id);


--

-- Name: uq_categories_code; Type: CONSTRAINT; Schema: templates; Owner: -
--

ALTER TABLE ONLY templates.categories ADD CONSTRAINT uq_categories_code UNIQUE (code);
ALTER TABLE ONLY templates.templates ADD CONSTRAINT uq_templates_code UNIQUE (code);
ALTER TABLE ONLY templates.template_versions ADD CONSTRAINT uq_template_versions_version UNIQUE (template_id, version);
ALTER TABLE ONLY templates.template_localizations ADD CONSTRAINT uq_template_localizations_version_locale UNIQUE (template_version_id, locale);
ALTER TABLE ONLY templates.template_variables ADD CONSTRAINT uq_template_variables_code UNIQUE (code);
ALTER TABLE ONLY templates.template_partials ADD CONSTRAINT uq_template_partials_code UNIQUE (code);
ALTER TABLE ONLY templates.template_packages ADD CONSTRAINT uq_template_packages_code UNIQUE (code);
ALTER TABLE ONLY templates.template_usage_statistics ADD CONSTRAINT uq_template_usage_statistics_date UNIQUE (template_id, date);
ALTER TABLE ONLY templates.event_template_mapping ADD CONSTRAINT uq_event_template_mapping UNIQUE (event_type, template_code);


--

-- Name: fk_templates_category; Type: CONSTRAINT; Schema: templates; Owner: -
--

ALTER TABLE ONLY templates.templates ADD CONSTRAINT fk_templates_category FOREIGN KEY (category_id) REFERENCES templates.categories(id);
ALTER TABLE ONLY templates.template_versions ADD CONSTRAINT fk_template_versions_template FOREIGN KEY (template_id) REFERENCES templates.templates(id);
ALTER TABLE ONLY templates.template_localizations ADD CONSTRAINT fk_template_localizations_version FOREIGN KEY (template_version_id) REFERENCES templates.template_versions(id);
ALTER TABLE ONLY templates.template_partials ADD CONSTRAINT fk_template_partials_template FOREIGN KEY (template_id) REFERENCES templates.templates(id);
ALTER TABLE ONLY templates.template_package_members ADD CONSTRAINT fk_template_package_members_package FOREIGN KEY (package_id) REFERENCES templates.template_packages(id);
ALTER TABLE ONLY templates.template_outputs ADD CONSTRAINT fk_template_outputs_version FOREIGN KEY (template_version_id) REFERENCES templates.template_versions(id);
ALTER TABLE ONLY templates.template_render_jobs ADD CONSTRAINT fk_template_render_jobs_version FOREIGN KEY (template_version_id) REFERENCES templates.template_versions(id);
ALTER TABLE ONLY templates.template_render_jobs ADD CONSTRAINT fk_template_render_jobs_output FOREIGN KEY (output_id) REFERENCES templates.template_outputs(id);
ALTER TABLE ONLY templates.template_approval_workflow ADD CONSTRAINT fk_template_approval_workflow_version FOREIGN KEY (template_version_id) REFERENCES templates.template_versions(id);
ALTER TABLE ONLY templates.template_usage_statistics ADD CONSTRAINT fk_template_usage_statistics_template FOREIGN KEY (template_id) REFERENCES templates.templates(id);
ALTER TABLE ONLY templates.template_validation_tests ADD CONSTRAINT fk_template_validation_tests_version FOREIGN KEY (template_version_id) REFERENCES templates.template_versions(id);
ALTER TABLE ONLY templates.categories ADD CONSTRAINT fk_categories_parent FOREIGN KEY (parent_category_id) REFERENCES templates.categories(id);


--

-- Name: chk_templates_categories_soft_delete; Type: CONSTRAINT; Schema: templates; Owner: -
--

ALTER TABLE ONLY templates.categories ADD CONSTRAINT chk_templates_categories_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)));
ALTER TABLE ONLY templates.templates ADD CONSTRAINT chk_templates_templates_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)));
ALTER TABLE ONLY templates.template_variables ADD CONSTRAINT chk_templates_template_variables_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)));
ALTER TABLE ONLY templates.template_partials ADD CONSTRAINT chk_templates_template_partials_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)));
ALTER TABLE ONLY templates.template_packages ADD CONSTRAINT chk_templates_template_packages_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)));


--

-- Name: chk_template_versions_status; Type: CONSTRAINT; Schema: templates; Owner: -
--

ALTER TABLE ONLY templates.template_versions ADD CONSTRAINT chk_template_versions_status CHECK (((status)::text = ANY ((ARRAY['DRAFT'::character varying, 'REVIEW'::character varying, 'APPROVED'::character varying, 'DEPRECATED'::character varying, 'ARCHIVED'::character varying])::text[])));


--

-- Name: chk_template_variables_type; Type: CONSTRAINT; Schema: templates; Owner: -
--

ALTER TABLE ONLY templates.template_variables ADD CONSTRAINT chk_template_variables_type CHECK (((type)::text = ANY ((ARRAY['string'::character varying, 'number'::character varying, 'date'::character varying, 'boolean'::character varying, 'array'::character varying, 'object'::character varying, 'enum'::character varying])::text[])));


--

-- Name: chk_template_variables_source_type; Type: CONSTRAINT; Schema: templates; Owner: -
--

ALTER TABLE ONLY templates.template_variables ADD CONSTRAINT chk_template_variables_source_type CHECK (((source_type)::text = ANY ((ARRAY['manual'::character varying, 'entity'::character varying, 'computed'::character varying, 'context'::character varying])::text[])));


--

-- Name: chk_template_outputs_status; Type: CONSTRAINT; Schema: templates; Owner: -
--

ALTER TABLE ONLY templates.template_outputs ADD CONSTRAINT chk_template_outputs_status CHECK (((status)::text = ANY ((ARRAY['SUCCESS'::character varying, 'FAILED'::character varying, 'PARTIAL'::character varying])::text[])));


--

-- Name: chk_template_render_jobs_status; Type: CONSTRAINT; Schema: templates; Owner: -
--

ALTER TABLE ONLY templates.template_render_jobs ADD CONSTRAINT chk_template_render_jobs_status CHECK (((status)::text = ANY ((ARRAY['QUEUED'::character varying, 'PROCESSING'::character varying, 'COMPLETED'::character varying, 'FAILED'::character varying])::text[])));


--

-- Name: chk_template_render_history_status; Type: CONSTRAINT; Schema: templates; Owner: -
--

ALTER TABLE ONLY templates.template_render_history ADD CONSTRAINT chk_template_render_history_status CHECK (((status)::text = ANY ((ARRAY['SUCCESS'::character varying, 'FAILED'::character varying, 'PARTIAL'::character varying, 'PERMISSION_DENIED'::character varying, 'SUCCESS_WITH_WARNING'::character varying, 'EVENT_FAILED'::character varying])::text[])));


--

-- Name: chk_template_approval_workflow_status; Type: CONSTRAINT; Schema: templates; Owner: -
--

ALTER TABLE ONLY templates.template_approval_workflow ADD CONSTRAINT chk_template_approval_workflow_status CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'APPROVED'::character varying, 'REJECTED'::character varying])::text[])));


--

-- Name: chk_template_version_audit_action; Type: CONSTRAINT; Schema: templates; Owner: -
--

ALTER TABLE ONLY templates.template_version_audit ADD CONSTRAINT chk_template_version_audit_action CHECK (((action)::text = ANY ((ARRAY['CREATED'::character varying, 'SUBMITTED'::character varying, 'APPROVED'::character varying, 'REJECTED'::character varying, 'DEPRECATED'::character varying, 'ARCHIVED'::character varying, 'ROLLED_BACK'::character varying, 'SUPERSEDED'::character varying, 'DELETED'::character varying])::text[])));


--

-- Name: chk_template_validation_tests_result; Type: CONSTRAINT; Schema: templates; Owner: -
--

ALTER TABLE ONLY templates.template_validation_tests ADD CONSTRAINT chk_template_validation_tests_result CHECK (((last_result)::text = ANY ((ARRAY['PASS'::character varying, 'FAIL'::character varying, 'ERROR'::character varying])::text[])));
