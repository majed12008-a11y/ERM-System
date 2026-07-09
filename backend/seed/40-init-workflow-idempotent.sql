/*
 * Commit 2: Make fn_init_workflow idempotent.
 *
 * Previously the function performed a plain INSERT. If called twice for the
 * same (entity_type, entity_id), the unique partial index
 * uq_workflow_instance_active raised a unique_violation.
 *
 * Now uses ON CONFLICT DO NOTHING RETURNING id so that a retry or duplicate
 * request safely returns the existing instance ID instead of crashing.
 *
 * Prerequisite: uq_workflow_instance_active must exist (seed 38).
 * Safe to re-run: CREATE OR REPLACE FUNCTION.
 */
CREATE OR REPLACE FUNCTION system.fn_init_workflow(
    p_workflow_code character varying,
    p_entity_type character varying,
    p_entity_id bigint
) RETURNS bigint
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
    v_workflow_id   BIGINT;
    v_initial_state BIGINT;
    v_instance_id   BIGINT;
BEGIN
    SELECT id INTO v_workflow_id
    FROM workflow.workflows
    WHERE workflow_code = p_workflow_code AND is_active = TRUE;

    SELECT id INTO v_initial_state
    FROM workflow.workflow_states
    WHERE workflow_id = v_workflow_id AND is_initial = TRUE;

    INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id)
    VALUES (v_workflow_id, p_entity_type, p_entity_id, v_initial_state)
    ON CONFLICT (entity_type, entity_id) WHERE status_code = 'ACTIVE' AND deleted_at IS NULL
    DO NOTHING
    RETURNING id INTO v_instance_id;

    RETURN v_instance_id;
END;
$$;
