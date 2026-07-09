-- =========================================================================
-- safety — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: corrective_actions corrective_actions_insert; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY corrective_actions_insert ON safety.corrective_actions FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = assigned_to)));


--

-- Name: corrective_actions corrective_actions_select; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY corrective_actions_select ON safety.corrective_actions FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = assigned_to)));


--

-- Name: risk_incidents risk_incidents_insert; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY risk_incidents_insert ON safety.risk_incidents FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = reported_by)));


--

-- Name: risk_incidents risk_incidents_select; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY risk_incidents_select ON safety.risk_incidents FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = reported_by)));


--

-- Name: risk_mitigations risk_mitigations_insert; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY risk_mitigations_insert ON safety.risk_mitigations FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = responsible_party)));


--

-- Name: risk_mitigations risk_mitigations_select; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY risk_mitigations_select ON safety.risk_mitigations FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = responsible_party)));


--

-- Name: risk_register risk_register_insert; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY risk_register_insert ON safety.risk_register FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = owner_id) OR ((current_setting('app.user_id'::text, true))::bigint = identified_by)));


--

-- Name: risk_register risk_register_select; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY risk_register_select ON safety.risk_register FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = owner_id) OR ((current_setting('app.user_id'::text, true))::bigint = identified_by)));


--

-- Name: risk_register risk_register_update; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY risk_register_update ON safety.risk_register FOR UPDATE USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = owner_id) OR ((current_setting('app.user_id'::text, true))::bigint = identified_by))) WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = owner_id) OR ((current_setting('app.user_id'::text, true))::bigint = identified_by)));


--


-- =========================================================================
-- safety — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: corrective_actions; Type: ROW SECURITY; Schema: safety; Owner: -
--

ALTER TABLE safety.corrective_actions ENABLE ROW LEVEL SECURITY;

--

-- Name: risk_incidents; Type: ROW SECURITY; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_incidents ENABLE ROW LEVEL SECURITY;

--

-- Name: risk_mitigations; Type: ROW SECURITY; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_mitigations ENABLE ROW LEVEL SECURITY;

--

-- Name: risk_register; Type: ROW SECURITY; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_register ENABLE ROW LEVEL SECURITY;

--


