-- =========================================================================
-- templates — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: one_approved_version; Type: UNIQUE INDEX; Schema: templates; Owner: -
--

CREATE UNIQUE INDEX one_approved_version ON templates.template_versions (template_id) WHERE (status = 'APPROVED'::character varying);


--

-- Name: idx_template_versions_template_id; Type: INDEX; Schema: templates; Owner: -
--

CREATE INDEX idx_template_versions_template_id ON templates.template_versions (template_id);
CREATE INDEX idx_template_versions_status ON templates.template_versions (status);
CREATE INDEX idx_template_versions_effective ON templates.template_versions (effective_from, effective_until);
CREATE INDEX idx_template_outputs_entity ON templates.template_outputs (entity_type, entity_id);
CREATE INDEX idx_template_outputs_version ON templates.template_outputs (template_version_id);
CREATE INDEX idx_template_render_jobs_status ON templates.template_render_jobs (status);
CREATE INDEX idx_template_render_jobs_priority ON templates.template_render_jobs (priority, queued_at);
CREATE INDEX idx_template_render_history_entity ON templates.template_render_history (entity_type, entity_id);
CREATE INDEX idx_template_render_history_generated_at ON templates.template_render_history (generated_at);
CREATE INDEX idx_template_variables_resolver_path ON templates.template_variables (resolver_path);
CREATE INDEX idx_template_variables_code ON templates.template_variables (code);
CREATE INDEX idx_template_partials_code ON templates.template_partials (code);
CREATE INDEX idx_template_package_members_package ON templates.template_package_members (package_id);
CREATE INDEX idx_template_package_members_slot ON templates.template_package_members (package_id, slot_order);
CREATE INDEX idx_template_version_audit_version ON templates.template_version_audit (template_version_id);
CREATE INDEX idx_template_version_audit_created ON templates.template_version_audit (created_at);
CREATE INDEX idx_template_approval_workflow_version ON templates.template_approval_workflow (template_version_id);
CREATE INDEX idx_template_localizations_version ON templates.template_localizations (template_version_id);
CREATE INDEX idx_template_usage_statistics_date ON templates.template_usage_statistics (template_id, date);
CREATE INDEX idx_event_template_mapping_event ON templates.event_template_mapping (event_type);
CREATE INDEX idx_categories_parent ON templates.categories (parent_category_id);
CREATE INDEX idx_templates_category ON templates.templates (category_id);
CREATE INDEX idx_templates_code ON templates.templates (code);
