-- ============================================================
-- 07-WORKFLOW INSTANCES AND ACTIONS
-- ============================================================

-- Workflow Instance for Application 1 (APPROVED)
-- Instances track the current state of each application in the workflow
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, completed_at, status_code)
SELECT w.id, 'Application', a.id, ss.id, a.submission_date, '2024-05-20 15:00:00+03'::timestamptz, 'COMPLETED'
FROM workflow.workflows w, core.applications a, workflow.workflow_states ss
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND a.application_number = 'APP-2024-001'
  AND ss.state_code = 'APPROVED';

-- Actions for Application 1's workflow
DO $$
DECLARE
  v_app_id bigint;
  v_inst_id bigint;
  v_admin_id bigint;
  v_chair_id bigint;
  v_res_id bigint;
BEGIN
  SELECT id INTO v_app_id FROM core.applications WHERE application_number = 'APP-2024-001';
  SELECT id INTO v_inst_id FROM workflow.workflow_instances WHERE entity_type = 'Application' AND entity_id = v_app_id;
  SELECT id INTO v_admin_id FROM security.users WHERE username = 'admin';
  SELECT id INTO v_chair_id FROM security.users WHERE username = 'chairperson';
  SELECT id INTO v_res_id FROM security.users WHERE username = 'researcher1';

  -- DRAFT -> SUBMITTED (by researcher)
  INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_date)
  SELECT v_inst_id, t.id, v_res_id, '2024-03-15 09:00:00+03'::timestamptz
  FROM workflow.workflow_transitions t, workflow.workflow_states fs, workflow.workflow_states ts
  WHERE t.transition_code = 'SUBMIT' AND fs.state_code = 'DRAFT' AND ts.state_code = 'SUBMITTED'
    AND t.from_state_id = fs.id AND t.to_state_id = ts.id;

  -- SUBMITTED -> INITIAL_REVIEW (by ethics admin)
  INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_date)
  SELECT v_inst_id, t.id, v_admin_id, '2024-03-16 10:00:00+03'::timestamptz
  FROM workflow.workflow_transitions t, workflow.workflow_states fs, workflow.workflow_states ts
  WHERE t.transition_code = 'ACCEPT_INITIAL' AND fs.state_code = 'SUBMITTED' AND ts.state_code = 'INITIAL_REVIEW'
    AND t.from_state_id = fs.id AND t.to_state_id = ts.id;

  -- INITIAL_REVIEW -> SCIENTIFIC_REVIEW
  INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_date)
  SELECT v_inst_id, t.id, v_admin_id, '2024-03-20 11:00:00+03'::timestamptz
  FROM workflow.workflow_transitions t, workflow.workflow_states fs, workflow.workflow_states ts
  WHERE t.transition_code = 'SEND_TO_SCIENTIFIC' AND fs.state_code = 'INITIAL_REVIEW' AND ts.state_code = 'SCIENTIFIC_REVIEW'
    AND t.from_state_id = fs.id AND t.to_state_id = ts.id;

  -- SCIENTIFIC_REVIEW -> ETHICAL_REVIEW
  INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_date)
  SELECT v_inst_id, t.id, v_admin_id, '2024-04-05 09:30:00+03'::timestamptz
  FROM workflow.workflow_transitions t, workflow.workflow_states fs, workflow.workflow_states ts
  WHERE t.transition_code = 'SEND_TO_ETHICAL' AND fs.state_code = 'SCIENTIFIC_REVIEW' AND ts.state_code = 'ETHICAL_REVIEW'
    AND t.from_state_id = fs.id AND t.to_state_id = ts.id;

  -- ETHICAL_REVIEW -> COMMITTEE_REVIEW
  INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_date)
  SELECT v_inst_id, t.id, v_admin_id, '2024-04-25 14:00:00+03'::timestamptz
  FROM workflow.workflow_transitions t, workflow.workflow_states fs, workflow.workflow_states ts
  WHERE t.transition_code = 'SEND_TO_COMMITTEE' AND fs.state_code = 'ETHICAL_REVIEW' AND ts.state_code = 'COMMITTEE_REVIEW'
    AND t.from_state_id = fs.id AND t.to_state_id = ts.id;

  -- COMMITTEE_REVIEW -> APPROVED (committee chair approves)
  INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_date)
  SELECT v_inst_id, t.id, v_chair_id, '2024-05-20 15:00:00+03'::timestamptz
  FROM workflow.workflow_transitions t, workflow.workflow_states fs, workflow.workflow_states ts
  WHERE t.transition_code = 'COMMITTEE_APPROVE' AND fs.state_code = 'COMMITTEE_REVIEW' AND ts.state_code = 'APPROVED'
    AND t.from_state_id = fs.id AND t.to_state_id = ts.id;

  -- Update the workflow instance state
  UPDATE workflow.workflow_instances SET current_state_id = (SELECT id FROM workflow.workflow_states WHERE state_code = 'APPROVED')
  WHERE id = v_inst_id;
END $$;

-- Workflow Instance for Application 2 (COMMITTEE_REVIEW - active)
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code)
SELECT w.id, 'Application', a.id, ss.id, a.submission_date, 'ACTIVE'
FROM workflow.workflows w, core.applications a, workflow.workflow_states ss
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND a.application_number = 'APP-2024-002'
  AND ss.state_code = 'COMMITTEE_REVIEW';

-- Actions for Application 2 (up to COMMITTEE_REVIEW)
DO $$
DECLARE
  v_app_id bigint;
  v_inst_id bigint;
  v_admin_id bigint;
  v_res_id bigint;
BEGIN
  SELECT id INTO v_app_id FROM core.applications WHERE application_number = 'APP-2024-002';
  SELECT id INTO v_inst_id FROM workflow.workflow_instances WHERE entity_type = 'Application' AND entity_id = v_app_id;
  SELECT id INTO v_admin_id FROM security.users WHERE username = 'ethics_admin';
  SELECT id INTO v_res_id FROM security.users WHERE username = 'researcher1';

  INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_date)
  SELECT v_inst_id, t.id, v_res_id, '2024-06-10 10:30:00+03'::timestamptz
  FROM workflow.workflow_transitions t, workflow.workflow_states fs, workflow.workflow_states ts
  WHERE t.transition_code = 'SUBMIT' AND fs.state_code = 'DRAFT' AND ts.state_code = 'SUBMITTED'
    AND t.from_state_id = fs.id AND t.to_state_id = ts.id;

  INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_date)
  SELECT v_inst_id, t.id, v_admin_id, '2024-06-12 09:00:00+03'::timestamptz
  FROM workflow.workflow_transitions t, workflow.workflow_states fs, workflow.workflow_states ts
  WHERE t.transition_code = 'ACCEPT_INITIAL' AND fs.state_code = 'SUBMITTED' AND ts.state_code = 'INITIAL_REVIEW'
    AND t.from_state_id = fs.id AND t.to_state_id = ts.id;

  INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_date)
  SELECT v_inst_id, t.id, v_admin_id, '2024-06-18 11:00:00+03'::timestamptz
  FROM workflow.workflow_transitions t, workflow.workflow_states fs, workflow.workflow_states ts
  WHERE t.transition_code = 'SEND_TO_SCIENTIFIC' AND fs.state_code = 'INITIAL_REVIEW' AND ts.state_code = 'SCIENTIFIC_REVIEW'
    AND t.from_state_id = fs.id AND t.to_state_id = ts.id;

  INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_date)
  SELECT v_inst_id, t.id, v_admin_id, '2024-07-10 10:00:00+03'::timestamptz
  FROM workflow.workflow_transitions t, workflow.workflow_states fs, workflow.workflow_states ts
  WHERE t.transition_code = 'SEND_TO_ETHICAL' AND fs.state_code = 'SCIENTIFIC_REVIEW' AND ts.state_code = 'ETHICAL_REVIEW'
    AND t.from_state_id = fs.id AND t.to_state_id = ts.id;

  INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_date)
  SELECT v_inst_id, t.id, v_admin_id, '2024-08-01 14:00:00+03'::timestamptz
  FROM workflow.workflow_transitions t, workflow.workflow_states fs, workflow.workflow_states ts
  WHERE t.transition_code = 'SEND_TO_COMMITTEE' AND fs.state_code = 'ETHICAL_REVIEW' AND ts.state_code = 'COMMITTEE_REVIEW'
    AND t.from_state_id = fs.id AND t.to_state_id = ts.id;
END $$;

-- Workflow Instance for Application 3 (SCIENTIFIC_REVIEW - active)
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code)
SELECT w.id, 'Application', a.id, ss.id, a.submission_date, 'ACTIVE'
FROM workflow.workflows w, core.applications a, workflow.workflow_states ss
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND a.application_number = 'APP-2024-003'
  AND ss.state_code = 'SCIENTIFIC_REVIEW';

-- Application 3: SUBMITTED -> INITIAL_REVIEW -> SCIENTIFIC_REVIEW
DO $$
DECLARE
  v_app_id bigint;
  v_inst_id bigint;
  v_admin_id bigint;
  v_res_id bigint;
BEGIN
  SELECT id INTO v_app_id FROM core.applications WHERE application_number = 'APP-2024-003';
  SELECT id INTO v_inst_id FROM workflow.workflow_instances WHERE entity_type = 'Application' AND entity_id = v_app_id;
  SELECT id INTO v_admin_id FROM security.users WHERE username = 'ethics_admin';
  SELECT id INTO v_res_id FROM security.users WHERE username = 'researcher1';

  INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_date)
  SELECT v_inst_id, t.id, v_res_id, '2024-08-20 14:00:00+03'::timestamptz
  FROM workflow.workflow_transitions t, workflow.workflow_states fs, workflow.workflow_states ts
  WHERE t.transition_code = 'SUBMIT' AND fs.state_code = 'DRAFT' AND ts.state_code = 'SUBMITTED'
    AND t.from_state_id = fs.id AND t.to_state_id = ts.id;

  INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_date)
  SELECT v_inst_id, t.id, v_admin_id, '2024-08-22 09:00:00+03'::timestamptz
  FROM workflow.workflow_transitions t, workflow.workflow_states fs, workflow.workflow_states ts
  WHERE t.transition_code = 'ACCEPT_INITIAL' AND fs.state_code = 'SUBMITTED' AND ts.state_code = 'INITIAL_REVIEW'
    AND t.from_state_id = fs.id AND t.to_state_id = ts.id;

  INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_date)
  SELECT v_inst_id, t.id, v_admin_id, '2024-08-28 11:00:00+03'::timestamptz
  FROM workflow.workflow_transitions t, workflow.workflow_states fs, workflow.workflow_states ts
  WHERE t.transition_code = 'SEND_TO_SCIENTIFIC' AND fs.state_code = 'INITIAL_REVIEW' AND ts.state_code = 'SCIENTIFIC_REVIEW'
    AND t.from_state_id = fs.id AND t.to_state_id = ts.id;
END $$;

-- Application 5: Workflow Instance (SUBMITTED)
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code)
SELECT w.id, 'Application', a.id, ss.id, a.submission_date, 'ACTIVE'
FROM workflow.workflows w, core.applications a, workflow.workflow_states ss
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND a.application_number = 'APP-2024-005'
  AND ss.state_code = 'SUBMITTED';

DO $$
DECLARE
  v_app_id bigint;
  v_inst_id bigint;
  v_res_id bigint;
BEGIN
  SELECT id INTO v_app_id FROM core.applications WHERE application_number = 'APP-2024-005';
  SELECT id INTO v_inst_id FROM workflow.workflow_instances WHERE entity_type = 'Application' AND entity_id = v_app_id;
  SELECT id INTO v_res_id FROM security.users WHERE username = 'researcher2';

  INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_date)
  SELECT v_inst_id, t.id, v_res_id, '2024-09-25 11:15:00+03'::timestamptz
  FROM workflow.workflow_transitions t, workflow.workflow_states fs, workflow.workflow_states ts
  WHERE t.transition_code = 'SUBMIT' AND fs.state_code = 'DRAFT' AND ts.state_code = 'SUBMITTED'
    AND t.from_state_id = fs.id AND t.to_state_id = ts.id;
END $$;
