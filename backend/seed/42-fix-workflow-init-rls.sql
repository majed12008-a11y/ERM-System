/*
 * Fix RLS for fn_init_workflow — allow application owners to create
 * workflow instances via the SECURITY DEFINER function.
 *
 * Problem:
 *   fn_init_workflow() is SECURITY DEFINER owned by ethics_owner, but
 *   ethics_owner does not have BYPASSRLS. In PostgreSQL 15+, SECURITY
 *   DEFINER alone does not bypass RLS. The INSERT policy on
 *   workflow.workflow_instances required admin, so when a researcher
 *   submitted an application, fn_init_workflow INSERT was blocked by RLS.
 *
 *   Result: "No active workflow instance" error when ApplicationService
 *   called executeTransition() immediately after initWorkflow().
 *
 * Fix:
 *   Relax the INSERT policy to also allow the application owner
 *   (submitted_by) to insert a workflow instance for their own Application.
 *   This is the only non-admin use case — entity_type = 'Application'.
 *
 * Safe to re-run: CREATE OR REPLACE POLICY.
 */

DROP POLICY IF EXISTS workflow_instances_insert ON workflow.workflow_instances;
CREATE POLICY workflow_instances_insert ON workflow.workflow_instances FOR INSERT
  WITH CHECK (
    system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)
    OR
    (
      entity_type = 'Application'
      AND EXISTS (
        SELECT 1 FROM core.applications a
        WHERE a.id = entity_id
          AND a.submitted_by = (current_setting('app.user_id'::text, true))::bigint
      )
    )
  );
