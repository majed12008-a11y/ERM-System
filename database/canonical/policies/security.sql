-- =========================================================================
-- security — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: password_reset_tokens password_reset_tokens_insert; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY password_reset_tokens_insert ON security.password_reset_tokens FOR INSERT WITH CHECK ((((current_setting('app.user_id'::text, true))::bigint = 0) OR (user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--

-- Name: password_reset_tokens password_reset_tokens_select; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY password_reset_tokens_select ON security.password_reset_tokens FOR SELECT USING ((((current_setting('app.user_id'::text, true))::bigint = 0) OR (user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--

-- Name: password_reset_tokens password_reset_tokens_update; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY password_reset_tokens_update ON security.password_reset_tokens FOR UPDATE USING (((user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint))) WITH CHECK (((user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--

-- Name: user_responsibilities user_responsibilities_delete; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY user_responsibilities_delete ON security.user_responsibilities FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: user_responsibilities user_responsibilities_insert; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY user_responsibilities_insert ON security.user_responsibilities FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: user_responsibilities user_responsibilities_select; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY user_responsibilities_select ON security.user_responsibilities FOR SELECT USING (((user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--

-- Name: user_responsibilities user_responsibilities_update; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY user_responsibilities_update ON security.user_responsibilities FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: users users_insert_policy; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY users_insert_policy ON security.users FOR INSERT WITH CHECK ((((current_setting('app.user_id'::text, true))::bigint = 0) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--

-- Name: users users_select_policy; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY users_select_policy ON security.users FOR SELECT USING (((id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--

-- Name: users users_update_policy; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY users_update_policy ON security.users FOR UPDATE USING (((id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint))) WITH CHECK (((id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--


-- =========================================================================
-- security — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: password_reset_tokens; Type: ROW SECURITY; Schema: security; Owner: -
--

ALTER TABLE security.password_reset_tokens ENABLE ROW LEVEL SECURITY;

--

-- Name: user_responsibilities; Type: ROW SECURITY; Schema: security; Owner: -
--

ALTER TABLE security.user_responsibilities ENABLE ROW LEVEL SECURITY;

--

-- Name: users; Type: ROW SECURITY; Schema: security; Owner: -
--

ALTER TABLE security.users ENABLE ROW LEVEL SECURITY;

--


