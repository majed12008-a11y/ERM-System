-- =========================================================================
-- reference — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: licenses_registry licenses_registry_delete; Type: POLICY; Schema: reference; Owner: -
--

CREATE POLICY licenses_registry_delete ON reference.licenses_registry FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: licenses_registry licenses_registry_insert; Type: POLICY; Schema: reference; Owner: -
--

CREATE POLICY licenses_registry_insert ON reference.licenses_registry FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: licenses_registry licenses_registry_select; Type: POLICY; Schema: reference; Owner: -
--

CREATE POLICY licenses_registry_select ON reference.licenses_registry FOR SELECT USING (true);


--

-- Name: licenses_registry licenses_registry_update; Type: POLICY; Schema: reference; Owner: -
--

CREATE POLICY licenses_registry_update ON reference.licenses_registry FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--


-- =========================================================================
-- reference — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: licenses_registry; Type: ROW SECURITY; Schema: reference; Owner: -
--

ALTER TABLE reference.licenses_registry ENABLE ROW LEVEL SECURITY;

--


