-- ============================================================
-- 44-FIX-TERMINAL-STATES
-- ============================================================
-- Fix is_terminal flag mismatches between DB and runtime code.
--
-- Issue: The hardcoded TERMINAL_STATES array in workflow.service.ts
-- was fixed to: ['REJECTED', 'WITHDRAWN', 'ARCHIVED']
-- but the DB still had stale values for APPROVED and CLOSED.
--
-- The rules:
--   worklow.workflow_states.is_terminal → controls workflow instance
--     completion. Must match the code's TERMINAL_STATES.
--   reference.application_statuses.is_terminal → UI semantic flag.
--     Still useful for UI badges/display, but must match workflow
--     semantics to avoid confusion.
--
-- States that ARE terminal (no outgoing transitions):
--   REJECTED  → terminal (no transitions from REJECTED)
--   WITHDRAWN → terminal (no transitions from WITHDRAWN)
--   ARCHIVED  → terminal (no transitions from ARCHIVED)
--
-- States that are NOT terminal (have outgoing transitions):
--   APPROVED  → was true, but APPROVED → CLOSE exists
--   CLOSED    → correctly false in workflow_states, but was
--               true in application_statuses
--
-- Source of truth: the workflow_transitions table defines the
-- actual state machine. is_terminal must reflect reality.
-- ============================================================

BEGIN;

-- ============================================================
-- Fix workflow.workflow_states
-- ============================================================
UPDATE workflow.workflow_states s
SET is_terminal = false
FROM workflow.workflows w
WHERE s.workflow_id = w.id
  AND w.workflow_code = 'APP_REVIEW_V1'
  AND s.state_code = 'APPROVED'
  AND s.is_terminal = true;

-- ============================================================
-- Fix reference.application_statuses
-- ============================================================
UPDATE reference.application_statuses
SET is_terminal = false
WHERE status_code = 'APPROVED'
  AND is_terminal = true;

UPDATE reference.application_statuses
SET is_terminal = false
WHERE status_code = 'CLOSED'
  AND is_terminal = true;

COMMIT;
