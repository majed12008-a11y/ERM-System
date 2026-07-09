-- ============================================================
-- 36-WORKFLOW-ADD-STATES
-- ============================================================
-- إضافة حالات سير عمل جديدة إلى workflow.workflow_states
-- لسير العمل APP_REVIEW_V1.
--
-- الحالات المضافة (5):
--   AWAITING_CONDITIONS  — بانتظار الشروط
--   EVIDENCE_REJECTED    — الأدلة مرفوضة (حلقة تصحيح الشروط)
--   WITHDRAWN            — مسحوب
--   CLOSED               — مغلق (شبه نهائي — يمكن الأرشفة)
--   ARCHIVED             — أرشيف
-- ============================================================

BEGIN;

-- AWAITING_CONDITIONS — غير نهائية، يمكن الانتقال إلى APPROVED أو EVIDENCE_REJECTED
INSERT INTO workflow.workflow_states (workflow_id, state_code, state_name, is_initial, is_terminal, display_order)
SELECT w.id, 'AWAITING_CONDITIONS', 'بانتظار الشروط', false, false, 10
FROM workflow.workflows w
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_states s
    WHERE s.workflow_id = w.id AND s.state_code = 'AWAITING_CONDITIONS'
  );

-- EVIDENCE_REJECTED — غير نهائية، الأدلة المرفوضة يمكن إعادة تقديمها
INSERT INTO workflow.workflow_states (workflow_id, state_code, state_name, is_initial, is_terminal, display_order)
SELECT w.id, 'EVIDENCE_REJECTED', 'الأدلة مرفوضة', false, false, 11
FROM workflow.workflows w
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_states s
    WHERE s.workflow_id = w.id AND s.state_code = 'EVIDENCE_REJECTED'
  );

-- WITHDRAWN — نهائية
INSERT INTO workflow.workflow_states (workflow_id, state_code, state_name, is_initial, is_terminal, display_order)
SELECT w.id, 'WITHDRAWN', 'مسحوب', false, true, 12
FROM workflow.workflows w
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_states s
    WHERE s.workflow_id = w.id AND s.state_code = 'WITHDRAWN'
  );

-- CLOSED — شبه نهائية (يمكن الانتقال إلى ARCHIVED)
INSERT INTO workflow.workflow_states (workflow_id, state_code, state_name, is_initial, is_terminal, display_order)
SELECT w.id, 'CLOSED', 'مغلق', false, false, 13
FROM workflow.workflows w
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_states s
    WHERE s.workflow_id = w.id AND s.state_code = 'CLOSED'
  );

-- ARCHIVED — نهائية
INSERT INTO workflow.workflow_states (workflow_id, state_code, state_name, is_initial, is_terminal, display_order)
SELECT w.id, 'ARCHIVED', 'مؤرشف', false, true, 14
FROM workflow.workflows w
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_states s
    WHERE s.workflow_id = w.id AND s.state_code = 'ARCHIVED'
  );

COMMIT;
