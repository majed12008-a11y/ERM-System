-- =========================================================================
-- monitoring — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: compliance_reviews compliance_reviews_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY compliance_reviews_delete_policy ON monitoring.compliance_reviews FOR DELETE USING (system.fn_is_admin());


--

-- Name: compliance_reviews compliance_reviews_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY compliance_reviews_insert_policy ON monitoring.compliance_reviews FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: compliance_reviews compliance_reviews_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY compliance_reviews_select_policy ON monitoring.compliance_reviews FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: compliance_reviews compliance_reviews_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY compliance_reviews_update_policy ON monitoring.compliance_reviews FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: corrective_actions corrective_actions_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY corrective_actions_delete_policy ON monitoring.corrective_actions FOR DELETE USING (system.fn_is_admin());


--

-- Name: corrective_actions corrective_actions_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY corrective_actions_insert_policy ON monitoring.corrective_actions FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: corrective_actions corrective_actions_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY corrective_actions_select_policy ON monitoring.corrective_actions FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: corrective_actions corrective_actions_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY corrective_actions_update_policy ON monitoring.corrective_actions FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: deviations deviations_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY deviations_delete_policy ON monitoring.deviations FOR DELETE USING (system.fn_is_admin());


--

-- Name: deviations deviations_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY deviations_insert_policy ON monitoring.deviations FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: deviations deviations_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY deviations_select_policy ON monitoring.deviations FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: deviations deviations_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY deviations_update_policy ON monitoring.deviations FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: inspection_reports inspection_reports_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY inspection_reports_delete_policy ON monitoring.inspection_reports FOR DELETE USING (system.fn_is_admin());


--

-- Name: inspection_reports inspection_reports_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY inspection_reports_insert_policy ON monitoring.inspection_reports FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: inspection_reports inspection_reports_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY inspection_reports_select_policy ON monitoring.inspection_reports FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: inspection_reports inspection_reports_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY inspection_reports_update_policy ON monitoring.inspection_reports FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: inspections inspections_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY inspections_delete_policy ON monitoring.inspections FOR DELETE USING (system.fn_is_admin());


--

-- Name: inspections inspections_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY inspections_insert_policy ON monitoring.inspections FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: inspections inspections_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY inspections_select_policy ON monitoring.inspections FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: inspections inspections_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY inspections_update_policy ON monitoring.inspections FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: monitoring_findings monitoring_findings_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_findings_delete_policy ON monitoring.monitoring_findings FOR DELETE USING (system.fn_is_admin());


--

-- Name: monitoring_findings monitoring_findings_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_findings_insert_policy ON monitoring.monitoring_findings FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: monitoring_findings monitoring_findings_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_findings_select_policy ON monitoring.monitoring_findings FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: monitoring_findings monitoring_findings_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_findings_update_policy ON monitoring.monitoring_findings FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: monitoring_plans monitoring_plans_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_plans_delete_policy ON monitoring.monitoring_plans FOR DELETE USING (system.fn_is_admin());


--

-- Name: monitoring_plans monitoring_plans_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_plans_insert_policy ON monitoring.monitoring_plans FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: monitoring_plans monitoring_plans_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_plans_select_policy ON monitoring.monitoring_plans FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: monitoring_plans monitoring_plans_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_plans_update_policy ON monitoring.monitoring_plans FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: monitoring_visits monitoring_visits_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_visits_delete_policy ON monitoring.monitoring_visits FOR DELETE USING (system.fn_is_admin());


--

-- Name: monitoring_visits monitoring_visits_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_visits_insert_policy ON monitoring.monitoring_visits FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: monitoring_visits monitoring_visits_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_visits_select_policy ON monitoring.monitoring_visits FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: monitoring_visits monitoring_visits_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_visits_update_policy ON monitoring.monitoring_visits FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: preventive_actions preventive_actions_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY preventive_actions_delete_policy ON monitoring.preventive_actions FOR DELETE USING (system.fn_is_admin());


--

-- Name: preventive_actions preventive_actions_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY preventive_actions_insert_policy ON monitoring.preventive_actions FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: preventive_actions preventive_actions_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY preventive_actions_select_policy ON monitoring.preventive_actions FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: preventive_actions preventive_actions_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY preventive_actions_update_policy ON monitoring.preventive_actions FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: protocol_violations protocol_violations_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY protocol_violations_delete_policy ON monitoring.protocol_violations FOR DELETE USING (system.fn_is_admin());


--

-- Name: protocol_violations protocol_violations_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY protocol_violations_insert_policy ON monitoring.protocol_violations FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: protocol_violations protocol_violations_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY protocol_violations_select_policy ON monitoring.protocol_violations FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: protocol_violations protocol_violations_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY protocol_violations_update_policy ON monitoring.protocol_violations FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--


-- =========================================================================
-- monitoring — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: compliance_reviews; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.compliance_reviews ENABLE ROW LEVEL SECURITY;

--

-- Name: corrective_actions; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.corrective_actions ENABLE ROW LEVEL SECURITY;

--

-- Name: deviations; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.deviations ENABLE ROW LEVEL SECURITY;

--

-- Name: inspection_reports; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.inspection_reports ENABLE ROW LEVEL SECURITY;

--

-- Name: inspections; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.inspections ENABLE ROW LEVEL SECURITY;

--

-- Name: monitoring_findings; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.monitoring_findings ENABLE ROW LEVEL SECURITY;

--

-- Name: monitoring_plans; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.monitoring_plans ENABLE ROW LEVEL SECURITY;

--

-- Name: monitoring_visits; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.monitoring_visits ENABLE ROW LEVEL SECURITY;

--

-- Name: preventive_actions; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.preventive_actions ENABLE ROW LEVEL SECURITY;

--

-- Name: protocol_violations; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.protocol_violations ENABLE ROW LEVEL SECURITY;

--


