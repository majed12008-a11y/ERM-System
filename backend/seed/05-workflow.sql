-- ============================================================
-- 05-WORKFLOW
-- ============================================================

-- Workflow definition
INSERT INTO workflow.workflows (workflow_code, workflow_name, entity_type, version_no, is_active)
VALUES ('APP_REVIEW_V1', 'سير عمل مراجعة الطلبات', 'Application', 1, true);

-- Workflow States (9 states matching the seed application_statuses)
INSERT INTO workflow.workflow_states (workflow_id, state_code, state_name, is_initial, is_terminal, display_order)
SELECT w.id, 'DRAFT', 'مسودة', true, false, 1
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1'
UNION ALL
SELECT w.id, 'SUBMITTED', 'مقدم', false, false, 2
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1'
UNION ALL
SELECT w.id, 'INITIAL_REVIEW', 'مراجعة أولية', false, false, 3
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1'
UNION ALL
SELECT w.id, 'SCIENTIFIC_REVIEW', 'مراجعة علمية', false, false, 4
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1'
UNION ALL
SELECT w.id, 'ETHICAL_REVIEW', 'مراجعة أخلاقية', false, false, 5
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1'
UNION ALL
SELECT w.id, 'COMMITTEE_REVIEW', 'مراجعة اللجنة', false, false, 6
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1'
UNION ALL
SELECT w.id, 'APPROVED', 'موافق عليه', false, true, 7
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1'
UNION ALL
SELECT w.id, 'REJECTED', 'مرفوض', false, true, 8
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1'
UNION ALL
SELECT w.id, 'RETURNED', 'معاد للمراجعة', false, false, 9
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1';

-- Workflow Transitions (14 transitions between states)
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'SUBMIT', 'تقديم الطلب', false, false, 'RESEARCHER'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'DRAFT' AND ts.state_code = 'SUBMITTED'

UNION ALL
SELECT w.id, fs.id, ts.id, 'ACCEPT_INITIAL', 'قبول للمراجعة الأولية', false, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'SUBMITTED' AND ts.state_code = 'INITIAL_REVIEW'

UNION ALL
SELECT w.id, fs.id, ts.id, 'RETURN_SUBMITTED', 'إعادة إلى المسودة', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'SUBMITTED' AND ts.state_code = 'DRAFT'

UNION ALL
SELECT w.id, fs.id, ts.id, 'REJECT_SUBMITTED', 'رفض الطلب', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'SUBMITTED' AND ts.state_code = 'REJECTED'

UNION ALL
SELECT w.id, fs.id, ts.id, 'SEND_TO_SCIENTIFIC', 'إرسال للمراجعة العلمية', false, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'INITIAL_REVIEW' AND ts.state_code = 'SCIENTIFIC_REVIEW'

UNION ALL
SELECT w.id, fs.id, ts.id, 'RETURN_INITIAL', 'إعادة من المراجعة الأولية', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'INITIAL_REVIEW' AND ts.state_code = 'SUBMITTED'

UNION ALL
SELECT w.id, fs.id, ts.id, 'SEND_TO_ETHICAL', 'إرسال للمراجعة الأخلاقية', false, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'SCIENTIFIC_REVIEW' AND ts.state_code = 'ETHICAL_REVIEW'

UNION ALL
SELECT w.id, fs.id, ts.id, 'RETURN_SCIENTIFIC', 'إعادة من المراجعة العلمية', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'SCIENTIFIC_REVIEW' AND ts.state_code = 'SUBMITTED'

UNION ALL
SELECT w.id, fs.id, ts.id, 'SEND_TO_COMMITTEE', 'إرسال لمراجعة اللجنة', false, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'ETHICAL_REVIEW' AND ts.state_code = 'COMMITTEE_REVIEW'

UNION ALL
SELECT w.id, fs.id, ts.id, 'RETURN_ETHICAL', 'إعادة من المراجعة الأخلاقية', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'ETHICAL_REVIEW' AND ts.state_code = 'INITIAL_REVIEW'

UNION ALL
SELECT w.id, fs.id, ts.id, 'COMMITTEE_APPROVE', 'موافقة اللجنة', false, true, 'COMMITTEE_CHAIR,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'COMMITTEE_REVIEW' AND ts.state_code = 'APPROVED'

UNION ALL
SELECT w.id, fs.id, ts.id, 'COMMITTEE_REJECT', 'رفض اللجنة', true, true, 'COMMITTEE_CHAIR,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'COMMITTEE_REVIEW' AND ts.state_code = 'REJECTED'

UNION ALL
SELECT w.id, fs.id, ts.id, 'COMMITTEE_RETURN', 'إعادة من اللجنة', true, true, 'COMMITTEE_CHAIR,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'COMMITTEE_REVIEW' AND ts.state_code = 'RETURNED'

UNION ALL
SELECT w.id, fs.id, ts.id, 'RESUBMIT', 'إعادة تقديم الطلب', false, false, 'RESEARCHER'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'RETURNED' AND ts.state_code = 'SUBMITTED';
