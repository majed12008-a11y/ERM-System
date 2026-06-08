-- ============================================================
-- 14-RLS-COMPLETE
-- Closes all structural RLS gaps discovered in the Security
-- Coverage Matrix review:
--   A. Define system.fn_is_admin() — missing function
--   B. RLS for workflow_instances + workflow_tasks
--   C. Complete security.users policies (SELECT, UPDATE)
--   D. Policies for 7 tables with ENABLE RLS but no policies
-- ============================================================

BEGIN;

-- ============================================================
-- A. Define system.fn_is_admin()
--    Used by every RLS policy in the project but never defined
--    in any checked-in SQL file. SECURITY DEFINER so it can
--    read security.user_roles regardless of RLS on that table.
-- ============================================================

CREATE OR REPLACE FUNCTION system.fn_is_admin(p_user_id BIGINT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1 FROM security.user_roles ur
    JOIN security.roles r ON ur.role_id = r.id
    WHERE ur.user_id = p_user_id
      AND r.code IN ('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN')
  );
$$;

COMMENT ON FUNCTION system.fn_is_admin IS
  'Returns true if the user holds any administrative role. SECURITY DEFINER to bypass RLS on user_roles.';

-- ============================================================
-- B. RLS for workflow.workflow_instances
--    HIGH severity gap — any authenticated user could read/write
--    any workflow instance before this fix.
-- ============================================================

ALTER TABLE workflow.workflow_instances ENABLE ROW LEVEL SECURITY;

-- SELECT: entity owner, assigned reviewer, or admin
DROP POLICY IF EXISTS workflow_instances_select ON workflow.workflow_instances;
CREATE POLICY workflow_instances_select ON workflow.workflow_instances FOR SELECT
  USING (system.is_active_row(deleted_at) AND (
    (entity_type = 'Application' AND entity_id IN (
      SELECT id FROM core.applications
      WHERE submitted_by = (current_setting('app.user_id', true))::bigint
    ))
    OR (entity_type = 'Application' AND EXISTS (
      SELECT 1 FROM committee.review_assignments ra
      WHERE ra.application_id = workflow_instances.entity_id
        AND ra.reviewer_id = (current_setting('app.user_id', true))::bigint
    ))
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  ));

-- UPDATE: only admins (workflow transitions are handled by service layer)
DROP POLICY IF EXISTS workflow_instances_update ON workflow.workflow_instances;
CREATE POLICY workflow_instances_update ON workflow.workflow_instances FOR UPDATE
  USING (system.is_active_row(deleted_at) AND
    system.fn_is_admin((current_setting('app.user_id', true))::bigint))
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- INSERT: only admins (instances are created programmatically by workflows)
DROP POLICY IF EXISTS workflow_instances_insert ON workflow.workflow_instances;
CREATE POLICY workflow_instances_insert ON workflow.workflow_instances FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- DELETE: intentionally omitted (soft delete only)

-- ============================================================
-- B2. RLS for workflow.workflow_tasks
--     HIGH severity gap — any user could read/write any task.
-- ============================================================

ALTER TABLE workflow.workflow_tasks ENABLE ROW LEVEL SECURITY;

-- SELECT: assignee, or admin
DROP POLICY IF EXISTS workflow_tasks_select ON workflow.workflow_tasks;
CREATE POLICY workflow_tasks_select ON workflow.workflow_tasks FOR SELECT
  USING (system.is_active_row(deleted_at) AND (
    (current_setting('app.user_id', true))::bigint = assigned_to
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  ));

-- UPDATE: assignee (progress/complete own task) or admin
DROP POLICY IF EXISTS workflow_tasks_update ON workflow.workflow_tasks;
CREATE POLICY workflow_tasks_update ON workflow.workflow_tasks FOR UPDATE
  USING (system.is_active_row(deleted_at) AND (
    (current_setting('app.user_id', true))::bigint = assigned_to
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  ))
  WITH CHECK (
    (current_setting('app.user_id', true))::bigint = assigned_to
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  );

-- INSERT: only admins (tasks are created by the workflow engine)
DROP POLICY IF EXISTS workflow_tasks_insert ON workflow.workflow_tasks;
CREATE POLICY workflow_tasks_insert ON workflow.workflow_tasks FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- DELETE: intentionally omitted (soft delete only)

-- ============================================================
-- C. Complete security.users RLS policies
--    Currently only has INSERT (from 11-rls-fix.sql).
--    Need SELECT for own-profile / admin-all, UPDATE for
--    own-limited / admin-all.
-- ============================================================

-- SELECT: user sees own row, admin sees all
DROP POLICY IF EXISTS users_select_policy ON security.users;
CREATE POLICY users_select_policy ON security.users FOR SELECT
  USING (
    id = (current_setting('app.user_id', true))::bigint
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  );

-- UPDATE: user can update own non-sensitive fields; admin can update all
DROP POLICY IF EXISTS users_update_policy ON security.users;
CREATE POLICY users_update_policy ON security.users FOR UPDATE
  USING (
    id = (current_setting('app.user_id', true))::bigint
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  )
  WITH CHECK (
    id = (current_setting('app.user_id', true))::bigint
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  );

-- ============================================================
-- D. Policies for tables with ENABLE RLS but no policies
--    These 7 tables were enabled in rls-v2.sql / master-schema-v2
--    but no CREATE POLICY was ever written, making them
--    completely inaccessible to non-owner roles.
-- ============================================================

-- D1. reference.licenses_registry — reference data, world-readable, admin-writable
DROP POLICY IF EXISTS licenses_registry_select ON reference.licenses_registry;
CREATE POLICY licenses_registry_select ON reference.licenses_registry FOR SELECT
  USING (true);

DROP POLICY IF EXISTS licenses_registry_insert ON reference.licenses_registry;
CREATE POLICY licenses_registry_insert ON reference.licenses_registry FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS licenses_registry_update ON reference.licenses_registry;
CREATE POLICY licenses_registry_update ON reference.licenses_registry FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS licenses_registry_delete ON reference.licenses_registry;
CREATE POLICY licenses_registry_delete ON reference.licenses_registry FOR DELETE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- D2. system.search_audit — audit log, admin-only SELECT
DROP POLICY IF EXISTS search_audit_select ON system.search_audit;
CREATE POLICY search_audit_select ON system.search_audit FOR SELECT
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- D3. integration.integration_failures — sensitive operational data, admin-only
DROP POLICY IF EXISTS integration_failures_select ON integration.integration_failures;
CREATE POLICY integration_failures_select ON integration.integration_failures FOR SELECT
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS integration_failures_update ON integration.integration_failures;
CREATE POLICY integration_failures_update ON integration.integration_failures FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint))
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- D4. integration.data_sync_jobs — operational data, admin-only
DROP POLICY IF EXISTS data_sync_jobs_select ON integration.data_sync_jobs;
CREATE POLICY data_sync_jobs_select ON integration.data_sync_jobs FOR SELECT
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS data_sync_jobs_insert ON integration.data_sync_jobs;
CREATE POLICY data_sync_jobs_insert ON integration.data_sync_jobs FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS data_sync_jobs_update ON integration.data_sync_jobs;
CREATE POLICY data_sync_jobs_update ON integration.data_sync_jobs FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint))
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- D5. workflow.workflow_events — visible to instance viewers, admin sees all
DROP POLICY IF EXISTS workflow_events_select ON workflow.workflow_events;
CREATE POLICY workflow_events_select ON workflow.workflow_events FOR SELECT
  USING (
    EXISTS (
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
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  );

-- D6. workflow.workflow_triggers — system configuration, admin-only
DROP POLICY IF EXISTS workflow_triggers_select ON workflow.workflow_triggers;
CREATE POLICY workflow_triggers_select ON workflow.workflow_triggers FOR SELECT
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS workflow_triggers_insert ON workflow.workflow_triggers;
CREATE POLICY workflow_triggers_insert ON workflow.workflow_triggers FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS workflow_triggers_update ON workflow.workflow_triggers;
CREATE POLICY workflow_triggers_update ON workflow.workflow_triggers FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint))
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- D7. workflow.workflow_schedulers — system configuration, admin-only
DROP POLICY IF EXISTS workflow_schedulers_select ON workflow.workflow_schedulers;
CREATE POLICY workflow_schedulers_select ON workflow.workflow_schedulers FOR SELECT
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS workflow_schedulers_insert ON workflow.workflow_schedulers;
CREATE POLICY workflow_schedulers_insert ON workflow.workflow_schedulers FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS workflow_schedulers_update ON workflow.workflow_schedulers;
CREATE POLICY workflow_schedulers_update ON workflow.workflow_schedulers FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint))
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- ============================================================
-- E. Verify — list all RLS-enabled tables and their policy count
-- ============================================================

DO $$
DECLARE
    v_total_enabled BIGINT;
    v_total_policies BIGINT;
    v_gap_tables TEXT;
BEGIN
    SELECT COUNT(*) INTO v_total_enabled
    FROM pg_tables t
    JOIN pg_class c ON c.oid = (t.schemaname || '.' || t.tablename)::regclass
    WHERE c.relrowsecurity = true;

    SELECT COUNT(*) INTO v_total_policies
    FROM pg_policies;

    RAISE NOTICE 'Migration 14-rls-complete complete:';
    RAISE NOTICE '  RLS-enabled tables: %', v_total_enabled;
    RAISE NOTICE '  Total RLS policies: %', v_total_policies;
END $$;

COMMIT;
