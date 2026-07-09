-- =========================================================================
-- reporting — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: analytics_snapshots analytics_snapshots_delete_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY analytics_snapshots_delete_policy ON reporting.analytics_snapshots FOR DELETE USING (system.fn_is_admin());


--

-- Name: analytics_snapshots analytics_snapshots_insert_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY analytics_snapshots_insert_policy ON reporting.analytics_snapshots FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: analytics_snapshots analytics_snapshots_select_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY analytics_snapshots_select_policy ON reporting.analytics_snapshots FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: analytics_snapshots analytics_snapshots_update_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY analytics_snapshots_update_policy ON reporting.analytics_snapshots FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: dashboard_widgets dashboard_widgets_delete_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY dashboard_widgets_delete_policy ON reporting.dashboard_widgets FOR DELETE USING (system.fn_is_admin());


--

-- Name: dashboard_widgets dashboard_widgets_insert_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY dashboard_widgets_insert_policy ON reporting.dashboard_widgets FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: dashboard_widgets dashboard_widgets_select_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY dashboard_widgets_select_policy ON reporting.dashboard_widgets FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: dashboard_widgets dashboard_widgets_update_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY dashboard_widgets_update_policy ON reporting.dashboard_widgets FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: kpi_results kpi_results_delete_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY kpi_results_delete_policy ON reporting.kpi_results FOR DELETE USING (system.fn_is_admin());


--

-- Name: kpi_results kpi_results_insert_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY kpi_results_insert_policy ON reporting.kpi_results FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: kpi_results kpi_results_select_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY kpi_results_select_policy ON reporting.kpi_results FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: kpi_results kpi_results_update_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY kpi_results_update_policy ON reporting.kpi_results FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: report_definitions report_definitions_delete_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY report_definitions_delete_policy ON reporting.report_definitions FOR DELETE USING (system.fn_is_admin());


--

-- Name: report_definitions report_definitions_insert_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY report_definitions_insert_policy ON reporting.report_definitions FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: report_definitions report_definitions_select_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY report_definitions_select_policy ON reporting.report_definitions FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: report_definitions report_definitions_update_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY report_definitions_update_policy ON reporting.report_definitions FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: report_executions report_executions_delete_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY report_executions_delete_policy ON reporting.report_executions FOR DELETE USING (system.fn_is_admin());


--

-- Name: report_executions report_executions_insert_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY report_executions_insert_policy ON reporting.report_executions FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: report_executions report_executions_select_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY report_executions_select_policy ON reporting.report_executions FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: report_executions report_executions_update_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY report_executions_update_policy ON reporting.report_executions FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--


-- =========================================================================
-- reporting — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: analytics_snapshots; Type: ROW SECURITY; Schema: reporting; Owner: -
--

ALTER TABLE reporting.analytics_snapshots ENABLE ROW LEVEL SECURITY;

--

-- Name: dashboard_widgets; Type: ROW SECURITY; Schema: reporting; Owner: -
--

ALTER TABLE reporting.dashboard_widgets ENABLE ROW LEVEL SECURITY;

--

-- Name: kpi_results; Type: ROW SECURITY; Schema: reporting; Owner: -
--

ALTER TABLE reporting.kpi_results ENABLE ROW LEVEL SECURITY;

--

-- Name: report_definitions; Type: ROW SECURITY; Schema: reporting; Owner: -
--

ALTER TABLE reporting.report_definitions ENABLE ROW LEVEL SECURITY;

--

-- Name: report_executions; Type: ROW SECURITY; Schema: reporting; Owner: -
--

ALTER TABLE reporting.report_executions ENABLE ROW LEVEL SECURITY;

--


