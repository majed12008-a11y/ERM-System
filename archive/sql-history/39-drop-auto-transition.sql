/*
 * Commit 2: Drop fn_auto_transition — broken by design (ORDER BY t.id LIMIT 1).
 * All callers removed. executeTransition() is the sole workflow state change path.
 * Idempotent: IF EXISTS guard.
 */
DROP FUNCTION IF EXISTS system.fn_auto_transition(varchar, bigint, bigint, text);
