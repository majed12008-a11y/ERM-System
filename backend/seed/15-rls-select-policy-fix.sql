-- ============================================================
-- 15-RLS-SELECT-POLICY-FIX
-- Fixes RLS policies that block UPDATE SET deleted_at in PG18.
--
-- ROOT CAUSE (discovered 2026-06-08):
-- PostgreSQL 18.3 evaluates the SELECT policy USING clause
-- against the NEW row during UPDATE. This means when a user
-- SET deleted_at = now(), the SELECT policy sees the NEW row
-- with non-null deleted_at, and is_active_row() returns false,
-- causing:
--   ERROR: new row violates row-level security policy
--
-- FIX PATTERNS:
--   1. SELECT policies: fn_is_admin OR owner OR (is_active_row AND ...)
--      - Admin: bypass is_active_row (can see soft-deleted rows)
--      - Owner: bypass is_active_row (can see/soft-delete own rows)
--      - Others: is_active_row AND their access conditions
--   2. UPDATE policies: same approach so admins can un-delete rows
-- The key change is moving fn_is_admin OUTSIDE the is_active_row
-- gate so admin operations never get blocked by the gate.
-- ============================================================

BEGIN;

-- ============================================================
-- core.applications
-- Owner+admin bypass is_active_row so soft-delete UPDATEs pass.
-- ============================================================
DROP POLICY IF EXISTS applications_select_policy ON core.applications;
CREATE POLICY applications_select_policy ON core.applications
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (current_setting('app.user_id', true))::bigint = submitted_by
    OR (
      system.is_active_row(deleted_at)
      AND (
        EXISTS (
          SELECT 1 FROM committee.review_assignments ra
          WHERE ra.application_id = applications.id
            AND ra.reviewer_id = (current_setting('app.user_id', true))::bigint
        )
        OR EXISTS (
          SELECT 1 FROM committee.committee_members cm
          JOIN committee.committees c ON cm.committee_id = c.id
          WHERE cm.user_id = (current_setting('app.user_id', true))::bigint
            AND c.id = applications.target_committee_id
        )
      )
    )
  );

-- ============================================================
-- core.projects
-- ============================================================
DROP POLICY IF EXISTS projects_select_policy ON core.projects;
CREATE POLICY projects_select_policy ON core.projects
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (current_setting('app.user_id', true))::bigint = principal_investigator_id
    OR (
      system.is_active_row(deleted_at)
      AND EXISTS (
        SELECT 1 FROM core.project_team_members ptm
        WHERE ptm.project_id = projects.id
          AND ptm.user_id = (current_setting('app.user_id', true))::bigint
      )
    )
  );

-- ============================================================
-- documents.documents
-- ============================================================
DROP POLICY IF EXISTS documents_select_policy ON documents.documents;
CREATE POLICY documents_select_policy ON documents.documents
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (current_setting('app.user_id', true))::bigint = uploaded_by
    OR (
      system.is_active_row(deleted_at)
      AND EXISTS (
        SELECT 1 FROM documents.document_access da
        WHERE da.document_id = documents.id
          AND (
            da.user_id = (current_setting('app.user_id', true))::bigint
            OR da.role_id IN (
              SELECT ur.role_id FROM security.user_roles ur
              WHERE ur.user_id = (current_setting('app.user_id', true))::bigint
            )
          )
      )
    )
  );

-- ============================================================
-- committee.committee_meetings
-- ============================================================
DROP POLICY IF EXISTS committee_meetings_policy ON committee.committee_meetings;
CREATE POLICY committee_meetings_policy ON committee.committee_meetings
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (
      system.is_active_row(deleted_at)
      AND EXISTS (
        SELECT 1 FROM committee.committee_members cm
        WHERE cm.committee_id = committee_meetings.committee_id
          AND cm.user_id = (current_setting('app.user_id', true))::bigint
          AND cm.is_active = true
      )
    )
  );

-- ============================================================
-- committee.ethics_reviews
-- ============================================================
DROP POLICY IF EXISTS ethics_reviews_select ON committee.ethics_reviews;
CREATE POLICY ethics_reviews_select ON committee.ethics_reviews
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (current_setting('app.user_id', true))::bigint = reviewer_id
  );

-- ============================================================
-- committee.scientific_reviews
-- ============================================================
DROP POLICY IF EXISTS scientific_reviews_select ON committee.scientific_reviews;
CREATE POLICY scientific_reviews_select ON committee.scientific_reviews
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (current_setting('app.user_id', true))::bigint = reviewer_id
  );

-- ============================================================
-- committee.review_assignments
-- ============================================================
DROP POLICY IF EXISTS review_assignments_select ON committee.review_assignments;
CREATE POLICY review_assignments_select ON committee.review_assignments
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (current_setting('app.user_id', true))::bigint = reviewer_id
    OR (current_setting('app.user_id', true))::bigint = assigned_by
  );

-- ============================================================
-- committee.member_conflicts
-- ============================================================
DROP POLICY IF EXISTS member_conflicts_select ON committee.member_conflicts;
CREATE POLICY member_conflicts_select ON committee.member_conflicts
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (
      system.is_active_row(deleted_at)
      AND member_id IN (
        SELECT cm.id FROM committee.committee_members cm
        WHERE cm.user_id = (current_setting('app.user_id', true))::bigint
      )
    )
  );

-- ============================================================
-- committee.member_qualifications
-- ============================================================
DROP POLICY IF EXISTS member_qualifications_select ON committee.member_qualifications;
CREATE POLICY member_qualifications_select ON committee.member_qualifications
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (
      system.is_active_row(deleted_at)
      AND member_id IN (
        SELECT cm.id FROM committee.committee_members cm
        WHERE cm.user_id = (current_setting('app.user_id', true))::bigint
      )
    )
  );

-- ============================================================
-- committee.member_terms
-- ============================================================
DROP POLICY IF EXISTS member_terms_select ON committee.member_terms;
CREATE POLICY member_terms_select ON committee.member_terms
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (
      system.is_active_row(deleted_at)
      AND member_id IN (
        SELECT cm.id FROM committee.committee_members cm
        WHERE cm.user_id = (current_setting('app.user_id', true))::bigint
      )
    )
  );

-- ============================================================
-- safety.corrective_actions
-- ============================================================
DROP POLICY IF EXISTS corrective_actions_select ON safety.corrective_actions;
CREATE POLICY corrective_actions_select ON safety.corrective_actions
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (current_setting('app.user_id', true))::bigint = assigned_to
  );

-- ============================================================
-- safety.risk_incidents
-- ============================================================
DROP POLICY IF EXISTS risk_incidents_select ON safety.risk_incidents;
CREATE POLICY risk_incidents_select ON safety.risk_incidents
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (current_setting('app.user_id', true))::bigint = reported_by
  );

-- ============================================================
-- safety.risk_mitigations
-- ============================================================
DROP POLICY IF EXISTS risk_mitigations_select ON safety.risk_mitigations;
CREATE POLICY risk_mitigations_select ON safety.risk_mitigations
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (current_setting('app.user_id', true))::bigint = responsible_party
  );

-- ============================================================
-- safety.risk_register
-- ============================================================
DROP POLICY IF EXISTS risk_register_select ON safety.risk_register;
CREATE POLICY risk_register_select ON safety.risk_register
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (current_setting('app.user_id', true))::bigint = owner_id
    OR (current_setting('app.user_id', true))::bigint = identified_by
  );

-- ============================================================
-- workflow.workflow_instances
-- ============================================================
DROP POLICY IF EXISTS workflow_instances_select ON workflow.workflow_instances;
CREATE POLICY workflow_instances_select ON workflow.workflow_instances
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (
      system.is_active_row(deleted_at)
      AND (
        (entity_type = 'Application' AND entity_id IN (
          SELECT id FROM core.applications
          WHERE submitted_by = (current_setting('app.user_id', true))::bigint
        ))
        OR (entity_type = 'Application' AND EXISTS (
          SELECT 1 FROM committee.review_assignments ra
          WHERE ra.application_id = workflow_instances.entity_id
            AND ra.reviewer_id = (current_setting('app.user_id', true))::bigint
        ))
      )
    )
  );

-- ============================================================
-- workflow.workflow_tasks
-- ============================================================
DROP POLICY IF EXISTS workflow_tasks_select ON workflow.workflow_tasks;
CREATE POLICY workflow_tasks_select ON workflow.workflow_tasks
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (current_setting('app.user_id', true))::bigint = assigned_to
  );

-- ============================================================
-- workflow.workflow_events
-- Note: this policy uses is_active_row(wi.deleted_at) on the
-- workflow_instances table indirectly, not on its own deleted_at.
-- Restructured for consistency: admin bypass first, then active check.
-- ============================================================
DROP POLICY IF EXISTS workflow_events_select ON workflow.workflow_events;
CREATE POLICY workflow_events_select ON workflow.workflow_events
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR EXISTS (
      SELECT 1 FROM workflow.workflow_instances wi
      WHERE wi.id = workflow_events.workflow_instance_id
        AND system.is_active_row(wi.deleted_at)
        AND (
          (wi.entity_type = 'Application' AND wi.entity_id IN (
            SELECT id FROM core.applications
            WHERE submitted_by = (current_setting('app.user_id', true))::bigint
          ))
          OR (wi.entity_type = 'Application' AND EXISTS (
            SELECT 1 FROM committee.review_assignments ra
            WHERE ra.application_id = wi.entity_id
              AND ra.reviewer_id = (current_setting('app.user_id', true))::bigint
          ))
        )
    )
  );

-- ============================================================
-- UPDATE policy fix for core.applications
-- Admin must bypass is_active_row so they can un-delete rows.
-- ============================================================
DROP POLICY IF EXISTS applications_update_policy ON core.applications;
CREATE POLICY applications_update_policy ON core.applications
  FOR UPDATE
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (
      system.is_active_row(deleted_at)
      AND (
        (current_setting('app.user_id', true))::bigint = submitted_by
        OR EXISTS (
          SELECT 1 FROM committee.review_assignments ra
          WHERE ra.application_id = applications.id
            AND ra.reviewer_id = (current_setting('app.user_id', true))::bigint
        )
      )
    )
  )
  WITH CHECK (
    (current_setting('app.user_id', true))::bigint = submitted_by
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  );

-- ============================================================
-- Verify
-- ============================================================
DO $$
DECLARE
    v_fixed BIGINT;
BEGIN
    SELECT COUNT(*) INTO v_fixed
    FROM pg_policies
    WHERE cmd = 'SELECT'
      AND qual::text LIKE '%fn_is_admin%';

    RAISE NOTICE 'Migration 15-rls-select-policy-fix complete:';
    RAISE NOTICE '  SELECT policies using fn_is_admin: %', v_fixed;
END $$;

COMMIT;
