BEGIN;

-- ============================================================
-- 51-ACCREDITATION-WORKFLOW.SQL
-- ============================================================
-- تعريف سير عمل الاعتماد المؤسسي ACCREDITATION_CYCLE_V1
-- يطابق CYCLE_STATUS_TRANSITIONS من accreditation.constants.ts
-- ============================================================

-- 1. Create workflow definition
INSERT INTO workflow.workflows (workflow_code, workflow_name, entity_type, version_no, is_active)
SELECT 'ACCREDITATION_CYCLE_V1', 'سير عمل دورة الاعتماد', 'AccreditationCycle', 1, true
WHERE NOT EXISTS (
  SELECT 1 FROM workflow.workflows WHERE workflow_code = 'ACCREDITATION_CYCLE_V1'
);

-- 2. Workflow States (7 states matching CYCLE_STATUS_TRANSITIONS)
INSERT INTO workflow.workflow_states (workflow_id, state_code, state_name, is_initial, is_terminal, display_order)
SELECT w.id, 'PENDING', 'قيد الانتظار', true, false, 1
FROM workflow.workflows w WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_states s WHERE s.workflow_id = w.id AND s.state_code = 'PENDING')
UNION ALL
SELECT w.id, 'UNDER_REVIEW', 'قيد المراجعة', false, false, 2
FROM workflow.workflows w WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_states s WHERE s.workflow_id = w.id AND s.state_code = 'UNDER_REVIEW')
UNION ALL
SELECT w.id, 'ACCREDITED', 'معتمد', false, false, 3
FROM workflow.workflows w WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_states s WHERE s.workflow_id = w.id AND s.state_code = 'ACCREDITED')
UNION ALL
SELECT w.id, 'CONDITIONAL', 'معتمد بشروط', false, false, 4
FROM workflow.workflows w WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_states s WHERE s.workflow_id = w.id AND s.state_code = 'CONDITIONAL')
UNION ALL
SELECT w.id, 'SUSPENDED', 'معلق', false, false, 5
FROM workflow.workflows w WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_states s WHERE s.workflow_id = w.id AND s.state_code = 'SUSPENDED')
UNION ALL
SELECT w.id, 'EXPIRED', 'منتهي', false, false, 6
FROM workflow.workflows w WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_states s WHERE s.workflow_id = w.id AND s.state_code = 'EXPIRED')
UNION ALL
SELECT w.id, 'REVOKED', 'ملغي', false, true, 7
FROM workflow.workflows w WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_states s WHERE s.workflow_id = w.id AND s.state_code = 'REVOKED');

-- 3. Workflow Transitions
-- From PENDING → UNDER_REVIEW
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'SUBMIT', 'تقديم للمراجعة', false, false, 'SUPER_ADMIN,ETHICS_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND fs.state_code = 'PENDING' AND ts.state_code = 'UNDER_REVIEW'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_transitions t WHERE t.workflow_id = w.id AND t.transition_code = 'SUBMIT' AND t.from_state_id = fs.id);

-- From UNDER_REVIEW → ACCREDITED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'APPROVE', 'اعتماد', false, false, 'SUPER_ADMIN,ETHICS_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND fs.state_code = 'UNDER_REVIEW' AND ts.state_code = 'ACCREDITED'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_transitions t WHERE t.workflow_id = w.id AND t.transition_code = 'APPROVE' AND t.from_state_id = fs.id);

-- From UNDER_REVIEW → CONDITIONAL
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'CONDITIONAL', 'اعتماد بشروط', true, false, 'SUPER_ADMIN,ETHICS_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND fs.state_code = 'UNDER_REVIEW' AND ts.state_code = 'CONDITIONAL'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_transitions t WHERE t.workflow_id = w.id AND t.transition_code = 'CONDITIONAL' AND t.from_state_id = fs.id);

-- From UNDER_REVIEW → SUSPENDED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'SUSPEND', 'تعليق', true, false, 'SUPER_ADMIN,ETHICS_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND fs.state_code = 'UNDER_REVIEW' AND ts.state_code = 'SUSPENDED'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_transitions t WHERE t.workflow_id = w.id AND t.transition_code = 'SUSPEND' AND t.from_state_id = fs.id);

-- From UNDER_REVIEW → REVOKED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'REVOKE', 'إلغاء', true, false, 'SUPER_ADMIN,ETHICS_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND fs.state_code = 'UNDER_REVIEW' AND ts.state_code = 'REVOKED'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_transitions t WHERE t.workflow_id = w.id AND t.transition_code = 'REVOKE' AND t.from_state_id = fs.id);

-- From ACCREDITED → SUSPENDED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'SUSPEND', 'تعليق', true, false, 'SUPER_ADMIN,ETHICS_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND fs.state_code = 'ACCREDITED' AND ts.state_code = 'SUSPENDED'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_transitions t WHERE t.workflow_id = w.id AND t.transition_code = 'SUSPEND' AND t.from_state_id = fs.id);

-- From ACCREDITED → EXPIRED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'EXPIRE', 'انتهاء', false, false, 'SUPER_ADMIN,ETHICS_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND fs.state_code = 'ACCREDITED' AND ts.state_code = 'EXPIRED'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_transitions t WHERE t.workflow_id = w.id AND t.transition_code = 'EXPIRE' AND t.from_state_id = fs.id);

-- From ACCREDITED → REVOKED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'REVOKE', 'إلغاء', true, false, 'SUPER_ADMIN,ETHICS_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND fs.state_code = 'ACCREDITED' AND ts.state_code = 'REVOKED'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_transitions t WHERE t.workflow_id = w.id AND t.transition_code = 'REVOKE' AND t.from_state_id = fs.id);

-- From CONDITIONAL → ACCREDITED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'APPROVE', 'اعتماد', false, false, 'SUPER_ADMIN,ETHICS_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND fs.state_code = 'CONDITIONAL' AND ts.state_code = 'ACCREDITED'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_transitions t WHERE t.workflow_id = w.id AND t.transition_code = 'APPROVE' AND t.from_state_id = fs.id);

-- From CONDITIONAL → SUSPENDED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'SUSPEND', 'تعليق', true, false, 'SUPER_ADMIN,ETHICS_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND fs.state_code = 'CONDITIONAL' AND ts.state_code = 'SUSPENDED'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_transitions t WHERE t.workflow_id = w.id AND t.transition_code = 'SUSPEND' AND t.from_state_id = fs.id);

-- From CONDITIONAL → REVOKED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'REVOKE', 'إلغاء', true, false, 'SUPER_ADMIN,ETHICS_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND fs.state_code = 'CONDITIONAL' AND ts.state_code = 'REVOKED'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_transitions t WHERE t.workflow_id = w.id AND t.transition_code = 'REVOKE' AND t.from_state_id = fs.id);

-- From SUSPENDED → ACCREDITED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'APPROVE', 'اعتماد', false, false, 'SUPER_ADMIN,ETHICS_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND fs.state_code = 'SUSPENDED' AND ts.state_code = 'ACCREDITED'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_transitions t WHERE t.workflow_id = w.id AND t.transition_code = 'APPROVE' AND t.from_state_id = fs.id);

-- From SUSPENDED → CONDITIONAL
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'CONDITIONAL', 'اعتماد بشروط', true, false, 'SUPER_ADMIN,ETHICS_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND fs.state_code = 'SUSPENDED' AND ts.state_code = 'CONDITIONAL'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_transitions t WHERE t.workflow_id = w.id AND t.transition_code = 'CONDITIONAL' AND t.from_state_id = fs.id);

-- From SUSPENDED → REVOKED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'REVOKE', 'إلغاء', true, false, 'SUPER_ADMIN,ETHICS_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND fs.state_code = 'SUSPENDED' AND ts.state_code = 'REVOKED'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_transitions t WHERE t.workflow_id = w.id AND t.transition_code = 'REVOKE' AND t.from_state_id = fs.id);

-- From EXPIRED → REVOKED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'REVOKE', 'إلغاء', true, false, 'SUPER_ADMIN,ETHICS_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND fs.state_code = 'EXPIRED' AND ts.state_code = 'REVOKED'
  AND NOT EXISTS (SELECT 1 FROM workflow.workflow_transitions t WHERE t.workflow_id = w.id AND t.transition_code = 'REVOKE' AND t.from_state_id = fs.id);

-- 4. Backfill workflow instances for existing active cycles
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, status_code)
SELECT w.id, 'AccreditationCycle', ac.id, s.id, 'ACTIVE'
FROM committee.accreditation_cycles ac
CROSS JOIN workflow.workflows w
CROSS JOIN workflow.workflow_states s
WHERE w.workflow_code = 'ACCREDITATION_CYCLE_V1'
  AND s.state_code = ac.status::text
  AND ac.deleted_at IS NULL
  AND ac.status != 'REVOKED'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_instances wi
    WHERE wi.entity_type = 'AccreditationCycle' AND wi.entity_id = ac.id
  );

COMMIT;
