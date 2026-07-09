-- =========================================================================
-- core — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: application_consents app_consents_delete; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY app_consents_delete ON core.application_consents FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: application_consents app_consents_insert; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY app_consents_insert ON core.application_consents FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: application_consents app_consents_select; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY app_consents_select ON core.application_consents FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (EXISTS ( SELECT 1
   FROM committee.review_assignments ra
  WHERE ((ra.application_id = application_consents.application_id) AND (ra.reviewer_id = (current_setting('app.user_id'::text, true))::bigint) AND (ra.deleted_at IS NULL)))) OR (EXISTS ( SELECT 1
   FROM core.applications a
  WHERE ((a.id = application_consents.application_id) AND (a.submitted_by = (current_setting('app.user_id'::text, true))::bigint))))));


--

-- Name: application_consents app_consents_update; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY app_consents_update ON core.application_consents FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: applications applications_insert_policy; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY applications_insert_policy ON core.applications FOR INSERT WITH CHECK (((submitted_by = (current_setting('app.user_id'::text))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text))::bigint)));


--

-- Name: applications applications_select_policy; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY applications_select_policy ON core.applications FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = submitted_by) OR (system.is_active_row(deleted_at) AND ((EXISTS ( SELECT 1
   FROM committee.review_assignments ra
  WHERE ((ra.application_id = applications.id) AND (ra.reviewer_id = (current_setting('app.user_id'::text, true))::bigint)))) OR (EXISTS ( SELECT 1
   FROM (committee.committee_members cm
     JOIN committee.committees c ON ((cm.committee_id = c.id)))
  WHERE ((cm.user_id = (current_setting('app.user_id'::text, true))::bigint) AND (c.id = applications.target_committee_id))))))));


--

-- Name: applications applications_update_policy; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY applications_update_policy ON core.applications FOR UPDATE USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (system.is_active_row(deleted_at) AND (((current_setting('app.user_id'::text, true))::bigint = submitted_by) OR (EXISTS ( SELECT 1
   FROM committee.review_assignments ra
  WHERE ((ra.application_id = applications.id) AND (ra.reviewer_id = (current_setting('app.user_id'::text, true))::bigint)))))))) WITH CHECK ((((current_setting('app.user_id'::text, true))::bigint = submitted_by) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--

-- Name: projects projects_insert_policy; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY projects_insert_policy ON core.projects FOR INSERT WITH CHECK (((principal_investigator_id = (current_setting('app.user_id'::text))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text))::bigint)));


--

-- Name: projects projects_select_policy; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY projects_select_policy ON core.projects FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = principal_investigator_id) OR (system.is_active_row(deleted_at) AND (EXISTS ( SELECT 1
   FROM core.project_team_members ptm
  WHERE ((ptm.project_id = projects.id) AND (ptm.user_id = (current_setting('app.user_id'::text, true))::bigint)))))));


--

-- Name: projects projects_update_policy; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY projects_update_policy ON core.projects FOR UPDATE USING ((system.is_active_row(deleted_at) AND (((current_setting('app.user_id'::text, true))::bigint = principal_investigator_id) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)))) WITH CHECK ((((current_setting('app.user_id'::text, true))::bigint = principal_investigator_id) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--


-- =========================================================================
-- core — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: application_consents; Type: ROW SECURITY; Schema: core; Owner: -
--

ALTER TABLE core.application_consents ENABLE ROW LEVEL SECURITY;

--

-- Name: applications; Type: ROW SECURITY; Schema: core; Owner: -
--

ALTER TABLE core.applications ENABLE ROW LEVEL SECURITY;

--

-- Name: projects; Type: ROW SECURITY; Schema: core; Owner: -
--

ALTER TABLE core.projects ENABLE ROW LEVEL SECURITY;

--


