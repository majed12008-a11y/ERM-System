/*
 * Fix workflow_instances UPDATE RLS — allow application owners and
 * reviewers to use FOR UPDATE (locking) and perform actual UPDATEs.
 *
 * Problem:
 *   The UPDATE policy on workflow.workflow_instances restricted both
 *   the USING clause (which controls SELECT ... FOR UPDATE visibility)
 *   and the WITH CHECK clause (which controls actual UPDATE) to admins
 *   only. This broke two operations for non-admin users:
 *
 *   1. findInstance() in executeTransition uses SELECT ... FOR UPDATE
 *      to lock the workflow instance. The UPDATE policy's USING clause
 *      blocked non-admin users from seeing rows with FOR UPDATE.
 *      → Result: "No active workflow instance" error.
 *
 *   2. updateInstanceState() / completeInstance() perform actual UPDATE.
 *      The WITH CHECK clause blocked non-admin users from modifying
 *      the instance.
 *      → These operations would also fail for non-admin.
 *
 * Fix:
 *   Relax the USING clause to match the SELECT policy — allow admin,
 *   application owner (submitted_by), and assigned reviewer.
 *   Relax the WITH CHECK clause to allow admin and application owner.
 *   This aligns with the existing core.applications UPDATE policy pattern.
 *
 * Safe to re-run: DROP/CREATE POLICY.
 */

DROP POLICY IF EXISTS workflow_instances_update ON workflow.workflow_instances;
CREATE POLICY workflow_instances_update ON workflow.workflow_instances FOR UPDATE
  USING (system.is_active_row(deleted_at) AND (
    system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)
    OR (entity_type = 'Application' AND entity_id IN (
      SELECT id FROM core.applications
      WHERE submitted_by = (current_setting('app.user_id'::text, true))::bigint
    ))
    OR (entity_type = 'Application' AND EXISTS (
      SELECT 1 FROM committee.review_assignments ra
      WHERE ra.application_id = workflow_instances.entity_id
        AND ra.reviewer_id = (current_setting('app.user_id'::text, true))::bigint
    ))
  ))
  WITH CHECK (system.is_active_row(deleted_at) AND (
    system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)
    OR (entity_type = 'Application' AND entity_id IN (
      SELECT id FROM core.applications
      WHERE submitted_by = (current_setting('app.user_id'::text, true))::bigint
    ))
  ));
