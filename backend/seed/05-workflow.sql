-- ============================================================
-- 05-WORKFLOW
-- ============================================================

-- Workflow definition
INSERT INTO workflow.workflows (workflow_code, workflow_name, entity_type, version_no, is_active)
VALUES ('APP_REVIEW_V1', 'Application Review Workflow', 'Application', 1, true);

-- Workflow States (9 states matching the seed application_statuses)
INSERT INTO workflow.workflow_states (workflow_id, state_code, state_name, is_initial, is_terminal, display_order)
SELECT w.id, 'DRAFT', 'Draft', true, false, 1
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1'
UNION ALL
SELECT w.id, 'SUBMITTED', 'Submitted', false, false, 2
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1'
UNION ALL
SELECT w.id, 'INITIAL_REVIEW', 'Initial Review', false, false, 3
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1'
UNION ALL
SELECT w.id, 'SCIENTIFIC_REVIEW', 'Scientific Review', false, false, 4
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1'
UNION ALL
SELECT w.id, 'ETHICAL_REVIEW', 'Ethical Review', false, false, 5
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1'
UNION ALL
SELECT w.id, 'COMMITTEE_REVIEW', 'Committee Review', false, false, 6
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1'
UNION ALL
SELECT w.id, 'APPROVED', 'Approved', false, true, 7
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1'
UNION ALL
SELECT w.id, 'REJECTED', 'Rejected', false, true, 8
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1'
UNION ALL
SELECT w.id, 'RETURNED', 'Returned for Revision', false, false, 9
FROM workflow.workflows w WHERE w.workflow_code = 'APP_REVIEW_V1';

-- Workflow Transitions (14 transitions between states)
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'SUBMIT', 'Submit Application', false, false, 'RESEARCHER'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'DRAFT' AND ts.state_code = 'SUBMITTED'

UNION ALL
SELECT w.id, fs.id, ts.id, 'ACCEPT_INITIAL', 'Accept for Initial Review', false, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'SUBMITTED' AND ts.state_code = 'INITIAL_REVIEW'

UNION ALL
SELECT w.id, fs.id, ts.id, 'RETURN_SUBMITTED', 'Return to Draft', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'SUBMITTED' AND ts.state_code = 'DRAFT'

UNION ALL
SELECT w.id, fs.id, ts.id, 'REJECT_SUBMITTED', 'Reject Application', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'SUBMITTED' AND ts.state_code = 'REJECTED'

UNION ALL
SELECT w.id, fs.id, ts.id, 'SEND_TO_SCIENTIFIC', 'Send to Scientific Review', false, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'INITIAL_REVIEW' AND ts.state_code = 'SCIENTIFIC_REVIEW'

UNION ALL
SELECT w.id, fs.id, ts.id, 'RETURN_INITIAL', 'Return from Initial Review', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'INITIAL_REVIEW' AND ts.state_code = 'SUBMITTED'

UNION ALL
SELECT w.id, fs.id, ts.id, 'SEND_TO_ETHICAL', 'Send to Ethical Review', false, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'SCIENTIFIC_REVIEW' AND ts.state_code = 'ETHICAL_REVIEW'

UNION ALL
SELECT w.id, fs.id, ts.id, 'RETURN_SCIENTIFIC', 'Return from Scientific Review', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'SCIENTIFIC_REVIEW' AND ts.state_code = 'SUBMITTED'

UNION ALL
SELECT w.id, fs.id, ts.id, 'SEND_TO_COMMITTEE', 'Send to Committee Review', false, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'ETHICAL_REVIEW' AND ts.state_code = 'COMMITTEE_REVIEW'

UNION ALL
SELECT w.id, fs.id, ts.id, 'RETURN_ETHICAL', 'Return from Ethical Review', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'ETHICAL_REVIEW' AND ts.state_code = 'INITIAL_REVIEW'

UNION ALL
SELECT w.id, fs.id, ts.id, 'COMMITTEE_APPROVE', 'Committee Approves', false, true, 'COMMITTEE_CHAIR,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'COMMITTEE_REVIEW' AND ts.state_code = 'APPROVED'

UNION ALL
SELECT w.id, fs.id, ts.id, 'COMMITTEE_REJECT', 'Committee Rejects', true, true, 'COMMITTEE_CHAIR,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'COMMITTEE_REVIEW' AND ts.state_code = 'REJECTED'

UNION ALL
SELECT w.id, fs.id, ts.id, 'COMMITTEE_RETURN', 'Committee Returns', true, true, 'COMMITTEE_CHAIR,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'COMMITTEE_REVIEW' AND ts.state_code = 'RETURNED'

UNION ALL
SELECT w.id, fs.id, ts.id, 'RESUBMIT', 'Resubmit Application', false, false, 'RESEARCHER'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1' AND fs.state_code = 'RETURNED' AND ts.state_code = 'SUBMITTED';
