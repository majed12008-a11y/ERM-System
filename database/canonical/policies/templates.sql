-- =========================================================================
-- templates — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: admin_all ON categories; Type: POLICY; Schema: templates; Owner: -
--

CREATE POLICY admin_all ON templates.categories FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));


--

CREATE POLICY admin_all ON templates.templates FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_versions FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_localizations FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_variables FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_partials FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_packages FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_package_members FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_outputs FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_render_jobs FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_render_history FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_approval_workflow FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_usage_statistics FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_version_audit FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_validation_tests FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.event_template_mapping FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));


--

-- Name: read_all ON categories; Type: POLICY; Schema: templates; Owner: -
--

CREATE POLICY read_all ON templates.categories FOR SELECT USING (true);
CREATE POLICY read_all ON templates.templates FOR SELECT USING (true);
CREATE POLICY read_all ON templates.template_versions FOR SELECT USING (true);
CREATE POLICY read_all ON templates.template_localizations FOR SELECT USING (true);
CREATE POLICY read_all ON templates.template_variables FOR SELECT USING (true);
CREATE POLICY read_all ON templates.template_partials FOR SELECT USING (true);


--

-- Name: read_own_outputs; Type: POLICY; Schema: templates; Owner: -
--

CREATE POLICY read_own_outputs ON templates.template_outputs FOR SELECT USING ((generated_by = (current_setting('app.user_id'::text, true))::bigint));


--

-- Name: read_own_jobs; Type: POLICY; Schema: templates; Owner: -
--

CREATE POLICY read_own_jobs ON templates.template_render_jobs FOR SELECT USING ((created_by = (current_setting('app.user_id'::text, true))::bigint));


--

-- Name: read_own_history; Type: POLICY; Schema: templates; Owner: -
--

CREATE POLICY read_own_history ON templates.template_render_history FOR SELECT USING ((generated_by = (current_setting('app.user_id'::text, true))::bigint));


--

-- Name: no_physical_delete; Type: POLICY; Schema: templates; Owner: -
--

CREATE POLICY no_physical_delete ON templates.categories FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.templates FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_versions FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_localizations FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_variables FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_partials FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_packages FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_package_members FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_outputs FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_render_jobs FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_render_history FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_approval_workflow FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_usage_statistics FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_version_audit FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_validation_tests FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.event_template_mapping FOR DELETE USING (false);
