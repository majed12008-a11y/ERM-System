-- RLS Policies for new tables (Phase 16–25)
-- Run after master-schema-v2.sql

BEGIN;

-- Enable RLS on tables with sensitive access control
ALTER TABLE security.user_responsibilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE committee.member_terms ENABLE ROW LEVEL SECURITY;
ALTER TABLE committee.member_qualifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE committee.member_conflicts ENABLE ROW LEVEL SECURITY;
ALTER TABLE safety.risk_register ENABLE ROW LEVEL SECURITY;
ALTER TABLE safety.risk_mitigations ENABLE ROW LEVEL SECURITY;
ALTER TABLE safety.risk_incidents ENABLE ROW LEVEL SECURITY;
ALTER TABLE safety.corrective_actions ENABLE ROW LEVEL SECURITY;
ALTER TABLE reference.licenses_registry ENABLE ROW LEVEL SECURITY;
ALTER TABLE system.saved_searches ENABLE ROW LEVEL SECURITY;
ALTER TABLE system.search_audit ENABLE ROW LEVEL SECURITY;
ALTER TABLE integration.integration_credentials ENABLE ROW LEVEL SECURITY;
ALTER TABLE integration.integration_failures ENABLE ROW LEVEL SECURITY;
ALTER TABLE integration.data_sync_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflow.workflow_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflow.workflow_triggers ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflow.workflow_schedulers ENABLE ROW LEVEL SECURITY;

-- security.user_responsibilities: users see own, admins see all
CREATE POLICY user_responsibilities_select ON security.user_responsibilities FOR SELECT
  USING ((user_id = (current_setting('app.user_id', true))::bigint)
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint));

CREATE POLICY user_responsibilities_insert ON security.user_responsibilities FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

CREATE POLICY user_responsibilities_update ON security.user_responsibilities FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

CREATE POLICY user_responsibilities_delete ON security.user_responsibilities FOR DELETE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- committee.member_*: committee members see own, admins see all
CREATE POLICY member_terms_select ON committee.member_terms FOR SELECT
  USING ((member_id IN (SELECT id FROM committee.committee_members WHERE user_id = (current_setting('app.user_id', true))::bigint))
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint));

CREATE POLICY member_qualifications_select ON committee.member_qualifications FOR SELECT
  USING ((member_id IN (SELECT id FROM committee.committee_members WHERE user_id = (current_setting('app.user_id', true))::bigint))
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint));

CREATE POLICY member_conflicts_select ON committee.member_conflicts FOR SELECT
  USING ((member_id IN (SELECT id FROM committee.committee_members WHERE user_id = (current_setting('app.user_id', true))::bigint))
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- safety.*: owner/assignee can see, admins see all
CREATE POLICY risk_register_select ON safety.risk_register FOR SELECT
  USING ((owner_id = (current_setting('app.user_id', true))::bigint
    OR identified_by = (current_setting('app.user_id', true))::bigint)
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint));

CREATE POLICY risk_mitigations_select ON safety.risk_mitigations FOR SELECT
  USING ((responsible_party = (current_setting('app.user_id', true))::bigint)
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint));

CREATE POLICY risk_incidents_select ON safety.risk_incidents FOR SELECT
  USING ((reported_by = (current_setting('app.user_id', true))::bigint)
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint));

CREATE POLICY corrective_actions_select ON safety.corrective_actions FOR SELECT
  USING ((assigned_to = (current_setting('app.user_id', true))::bigint)
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- system.saved_searches: users see own + shared
CREATE POLICY saved_searches_select ON system.saved_searches FOR SELECT
  USING ((user_id = (current_setting('app.user_id', true))::bigint)
    OR is_shared = true
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint));

CREATE POLICY saved_searches_insert ON system.saved_searches FOR INSERT
  WITH CHECK ((user_id = (current_setting('app.user_id', true))::bigint)
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint));

CREATE POLICY saved_searches_update ON system.saved_searches FOR UPDATE
  USING ((user_id = (current_setting('app.user_id', true))::bigint)
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint));

CREATE POLICY saved_searches_delete ON system.saved_searches FOR DELETE
  USING ((user_id = (current_setting('app.user_id', true))::bigint)
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- integration.integration_credentials: only admins
CREATE POLICY integration_credentials_select ON integration.integration_credentials FOR SELECT
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

CREATE POLICY integration_credentials_insert ON integration.integration_credentials FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

CREATE POLICY integration_credentials_update ON integration.integration_credentials FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

CREATE POLICY integration_credentials_delete ON integration.integration_credentials FOR DELETE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

COMMIT;
