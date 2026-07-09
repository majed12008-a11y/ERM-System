-- =========================================================================
-- workflow — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: workflow_events workflow_events_select; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_events_select ON workflow.workflow_events FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (EXISTS ( SELECT 1
   FROM workflow.workflow_instances wi
  WHERE ((wi.id = workflow_events.workflow_instance_id) AND system.is_active_row(wi.deleted_at) AND ((((wi.entity_type)::text = 'Application'::text) AND (wi.entity_id IN ( SELECT applications.id
           FROM core.applications
          WHERE (applications.submitted_by = (current_setting('app.user_id'::text, true))::bigint)))) OR (((wi.entity_type)::text = 'Application'::text) AND (EXISTS ( SELECT 1
           FROM committee.review_assignments ra
          WHERE ((ra.application_id = wi.entity_id) AND (ra.reviewer_id = (current_setting('app.user_id'::text, true))::bigint)))))))))));


--

-- Name: workflow_instances workflow_instances_insert; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_instances_insert ON workflow.workflow_instances FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (((entity_type)::text = 'Application'::text) AND (EXISTS ( SELECT 1
   FROM core.applications a
  WHERE ((a.id = workflow_instances.entity_id) AND (a.submitted_by = (current_setting('app.user_id'::text, true))::bigint)))))));


--

-- Name: workflow_instances workflow_instances_select; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_instances_select ON workflow.workflow_instances FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (system.is_active_row(deleted_at) AND ((((entity_type)::text = 'Application'::text) AND (entity_id IN ( SELECT applications.id
   FROM core.applications
  WHERE (applications.submitted_by = (current_setting('app.user_id'::text, true))::bigint)))) OR (((entity_type)::text = 'Application'::text) AND (EXISTS ( SELECT 1
   FROM committee.review_assignments ra
  WHERE ((ra.application_id = workflow_instances.entity_id) AND (ra.reviewer_id = (current_setting('app.user_id'::text, true))::bigint)))))))));


--

-- Name: workflow_instances workflow_instances_update; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_instances_update ON workflow.workflow_instances FOR UPDATE USING ((system.is_active_row(deleted_at) AND (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (((entity_type)::text = 'Application'::text) AND (entity_id IN ( SELECT applications.id
   FROM core.applications
  WHERE (applications.submitted_by = (current_setting('app.user_id'::text, true))::bigint)))) OR (((entity_type)::text = 'Application'::text) AND (EXISTS ( SELECT 1
   FROM committee.review_assignments ra
  WHERE ((ra.application_id = workflow_instances.entity_id) AND (ra.reviewer_id = (current_setting('app.user_id'::text, true))::bigint)))))))) WITH CHECK ((system.is_active_row(deleted_at) AND (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (((entity_type)::text = 'Application'::text) AND (entity_id IN ( SELECT applications.id
   FROM core.applications
  WHERE (applications.submitted_by = (current_setting('app.user_id'::text, true))::bigint)))))));


--

-- Name: workflow_schedulers workflow_schedulers_insert; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_schedulers_insert ON workflow.workflow_schedulers FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: workflow_schedulers workflow_schedulers_select; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_schedulers_select ON workflow.workflow_schedulers FOR SELECT USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: workflow_schedulers workflow_schedulers_update; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_schedulers_update ON workflow.workflow_schedulers FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: workflow_tasks workflow_tasks_insert; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_tasks_insert ON workflow.workflow_tasks FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: workflow_tasks workflow_tasks_select; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_tasks_select ON workflow.workflow_tasks FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = assigned_to)));


--

-- Name: workflow_tasks workflow_tasks_update; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_tasks_update ON workflow.workflow_tasks FOR UPDATE USING ((system.is_active_row(deleted_at) AND (((current_setting('app.user_id'::text, true))::bigint = assigned_to) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)))) WITH CHECK ((((current_setting('app.user_id'::text, true))::bigint = assigned_to) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--

-- Name: workflow_triggers workflow_triggers_insert; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_triggers_insert ON workflow.workflow_triggers FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: workflow_triggers workflow_triggers_select; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_triggers_select ON workflow.workflow_triggers FOR SELECT USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: workflow_triggers workflow_triggers_update; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_triggers_update ON workflow.workflow_triggers FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- PostgreSQL database dump complete
--

\unrestrict EfLlh8zaoAZxblLLdcE75DJECOVvXBNZDXOIfd9p47FVIMzCWGvDdoVXLpIxYSn


-- =========================================================================
-- workflow — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: workflow_events; Type: ROW SECURITY; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_events ENABLE ROW LEVEL SECURITY;

--

-- Name: workflow_instances; Type: ROW SECURITY; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_instances ENABLE ROW LEVEL SECURITY;

--

-- Name: workflow_schedulers; Type: ROW SECURITY; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_schedulers ENABLE ROW LEVEL SECURITY;

--

-- Name: workflow_tasks; Type: ROW SECURITY; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_tasks ENABLE ROW LEVEL SECURITY;

--

-- Name: workflow_triggers; Type: ROW SECURITY; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_triggers ENABLE ROW LEVEL SECURITY;

--


