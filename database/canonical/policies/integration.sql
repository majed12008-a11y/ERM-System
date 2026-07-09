-- =========================================================================
-- integration — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: data_sync_jobs data_sync_jobs_insert; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY data_sync_jobs_insert ON integration.data_sync_jobs FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: data_sync_jobs data_sync_jobs_select; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY data_sync_jobs_select ON integration.data_sync_jobs FOR SELECT USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: data_sync_jobs data_sync_jobs_update; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY data_sync_jobs_update ON integration.data_sync_jobs FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: integration_credentials integration_credentials_delete; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY integration_credentials_delete ON integration.integration_credentials FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: integration_credentials integration_credentials_insert; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY integration_credentials_insert ON integration.integration_credentials FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: integration_credentials integration_credentials_select; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY integration_credentials_select ON integration.integration_credentials FOR SELECT USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: integration_credentials integration_credentials_update; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY integration_credentials_update ON integration.integration_credentials FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: integration_failures integration_failures_select; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY integration_failures_select ON integration.integration_failures FOR SELECT USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: integration_failures integration_failures_update; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY integration_failures_update ON integration.integration_failures FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--


-- =========================================================================
-- integration — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: data_sync_jobs; Type: ROW SECURITY; Schema: integration; Owner: -
--

ALTER TABLE integration.data_sync_jobs ENABLE ROW LEVEL SECURITY;

--

-- Name: integration_credentials; Type: ROW SECURITY; Schema: integration; Owner: -
--

ALTER TABLE integration.integration_credentials ENABLE ROW LEVEL SECURITY;

--

-- Name: integration_failures; Type: ROW SECURITY; Schema: integration; Owner: -
--

ALTER TABLE integration.integration_failures ENABLE ROW LEVEL SECURITY;

--


