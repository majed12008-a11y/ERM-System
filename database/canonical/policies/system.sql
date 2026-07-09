-- =========================================================================
-- system — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: saved_searches saved_searches_delete; Type: POLICY; Schema: system; Owner: -
--

CREATE POLICY saved_searches_delete ON system.saved_searches FOR DELETE USING (((user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--

-- Name: saved_searches saved_searches_insert; Type: POLICY; Schema: system; Owner: -
--

CREATE POLICY saved_searches_insert ON system.saved_searches FOR INSERT WITH CHECK (((user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--

-- Name: saved_searches saved_searches_select; Type: POLICY; Schema: system; Owner: -
--

CREATE POLICY saved_searches_select ON system.saved_searches FOR SELECT USING (((user_id = (current_setting('app.user_id'::text, true))::bigint) OR (is_shared = true) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--

-- Name: saved_searches saved_searches_update; Type: POLICY; Schema: system; Owner: -
--

CREATE POLICY saved_searches_update ON system.saved_searches FOR UPDATE USING (((user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--

-- Name: search_audit search_audit_select; Type: POLICY; Schema: system; Owner: -
--

CREATE POLICY search_audit_select ON system.search_audit FOR SELECT USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--


-- =========================================================================
-- system — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: saved_searches; Type: ROW SECURITY; Schema: system; Owner: -
--

ALTER TABLE system.saved_searches ENABLE ROW LEVEL SECURITY;

--

-- Name: search_audit; Type: ROW SECURITY; Schema: system; Owner: -
--

ALTER TABLE system.search_audit ENABLE ROW LEVEL SECURITY;

--


