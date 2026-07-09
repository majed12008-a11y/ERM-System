-- ============================================================
-- 37-WORKFLOW-ADD-TRANSITIONS
-- ============================================================
-- إضافة انتقالات سير عمل جديدة إلى workflow.workflow_transitions
-- لسير العمل APP_REVIEW_V1.
--
-- الانتقالات المضافة (18 صفاً):
--   REJECT_FROM_INITIAL      — رفض من المراجعة الأولية
--   REJECT_FROM_SCIENTIFIC   — رفض من المراجعة العلمية
--   REJECT_FROM_ETHICAL      — رفض من المراجعة الأخلاقية
--   COMMITTEE_CONDITIONAL    — موافقة مشروطة من اللجنة
--   CONDITIONS_MET           — استيفاء الشروط ← موافقة
--   CONDITIONS_NOT_MET       — عدم استيفاء الشروط ← رفض الأدلة
--   SUBMIT_EVIDENCE          — إعادة تقديم الأدلة ← بانتظار الشروط
--   REJECT_CONDITIONS        — رفض لعدم استيفاء الشروط
--   WITHDRAW (×8)            — سحب من 8 حالات غير نهائية
--   CLOSE                    — إغلاق الدراسة المعتمدة
--   ARCHIVE                  — أرشفة الدراسة المغلقة
-- ============================================================

BEGIN;

-- ============================================================
-- 3.3 Rejection Transitions
-- ============================================================

-- REJECT_FROM_INITIAL: INITIAL_REVIEW → REJECTED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'REJECT_FROM_INITIAL', 'رفض من المراجعة الأولية', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'INITIAL_REVIEW' AND ts.state_code = 'REJECTED'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'REJECT_FROM_INITIAL'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- REJECT_FROM_SCIENTIFIC: SCIENTIFIC_REVIEW → REJECTED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'REJECT_FROM_SCIENTIFIC', 'رفض من المراجعة العلمية', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'SCIENTIFIC_REVIEW' AND ts.state_code = 'REJECTED'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'REJECT_FROM_SCIENTIFIC'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- REJECT_FROM_ETHICAL: ETHICAL_REVIEW → REJECTED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'REJECT_FROM_ETHICAL', 'رفض من المراجعة الأخلاقية', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'ETHICAL_REVIEW' AND ts.state_code = 'REJECTED'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'REJECT_FROM_ETHICAL'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- ============================================================
-- 3.1 Forward Transitions
-- ============================================================

-- COMMITTEE_CONDITIONAL: COMMITTEE_REVIEW → AWAITING_CONDITIONS
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'COMMITTEE_CONDITIONAL', 'موافقة مشروطة من اللجنة', true, true, 'COMMITTEE_CHAIR,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'COMMITTEE_REVIEW' AND ts.state_code = 'AWAITING_CONDITIONS'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'COMMITTEE_CONDITIONAL'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- CONDITIONS_MET: AWAITING_CONDITIONS → APPROVED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'CONDITIONS_MET', 'استيفاء الشروط', false, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'AWAITING_CONDITIONS' AND ts.state_code = 'APPROVED'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'CONDITIONS_MET'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- CLOSE: APPROVED → CLOSED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'CLOSE', 'إغلاق الدراسة', true, false, 'ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'APPROVED' AND ts.state_code = 'CLOSED'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'CLOSE'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- ARCHIVE: CLOSED → ARCHIVED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'ARCHIVE', 'أرشفة الدراسة', false, false, 'SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'CLOSED' AND ts.state_code = 'ARCHIVED'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'ARCHIVE'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- ============================================================
-- 3.2 Return Transitions
-- ============================================================

-- CONDITIONS_NOT_MET: AWAITING_CONDITIONS → EVIDENCE_REJECTED
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'CONDITIONS_NOT_MET', 'رفض الأدلة', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'AWAITING_CONDITIONS' AND ts.state_code = 'EVIDENCE_REJECTED'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'CONDITIONS_NOT_MET'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- ============================================================
-- 3.5 Conditions Evidence Transitions
-- ============================================================

-- SUBMIT_EVIDENCE: EVIDENCE_REJECTED → AWAITING_CONDITIONS (إعادة تقديم الأدلة)
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'SUBMIT_EVIDENCE', 'إعادة تقديم الأدلة', false, false, 'RESEARCHER'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'EVIDENCE_REJECTED' AND ts.state_code = 'AWAITING_CONDITIONS'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'SUBMIT_EVIDENCE'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- REJECT_CONDITIONS: EVIDENCE_REJECTED → REJECTED (رفض لعدم استيفاء الشروط)
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'REJECT_CONDITIONS', 'رفض لعدم استيفاء الشروط', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'EVIDENCE_REJECTED' AND ts.state_code = 'REJECTED'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'REJECT_CONDITIONS'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- ============================================================
-- 3.4 Withdrawal Transitions
-- WITHDRAW من 8 حالات غير نهائية (باستثناء COMMITTEE_REVIEW)
-- ============================================================

-- WITHDRAW: DRAFT → WITHDRAWN
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'WITHDRAW', 'سحب الطلب', true, false, 'RESEARCHER,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'DRAFT' AND ts.state_code = 'WITHDRAWN'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'WITHDRAW'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- WITHDRAW: SUBMITTED → WITHDRAWN
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'WITHDRAW', 'سحب الطلب', true, false, 'RESEARCHER,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'SUBMITTED' AND ts.state_code = 'WITHDRAWN'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'WITHDRAW'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- WITHDRAW: INITIAL_REVIEW → WITHDRAWN
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'WITHDRAW', 'سحب الطلب', true, false, 'RESEARCHER,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'INITIAL_REVIEW' AND ts.state_code = 'WITHDRAWN'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'WITHDRAW'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- WITHDRAW: SCIENTIFIC_REVIEW → WITHDRAWN
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'WITHDRAW', 'سحب الطلب', true, false, 'RESEARCHER,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'SCIENTIFIC_REVIEW' AND ts.state_code = 'WITHDRAWN'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'WITHDRAW'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- WITHDRAW: ETHICAL_REVIEW → WITHDRAWN
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'WITHDRAW', 'سحب الطلب', true, false, 'RESEARCHER,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'ETHICAL_REVIEW' AND ts.state_code = 'WITHDRAWN'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'WITHDRAW'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- WITHDRAW: RETURNED → WITHDRAWN
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'WITHDRAW', 'سحب الطلب', true, false, 'RESEARCHER,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'RETURNED' AND ts.state_code = 'WITHDRAWN'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'WITHDRAW'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- WITHDRAW: AWAITING_CONDITIONS → WITHDRAWN
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'WITHDRAW', 'سحب الطلب', true, false, 'RESEARCHER,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'AWAITING_CONDITIONS' AND ts.state_code = 'WITHDRAWN'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'WITHDRAW'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- WITHDRAW: EVIDENCE_REJECTED → WITHDRAWN
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'WITHDRAW', 'سحب الطلب', true, false, 'RESEARCHER,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'EVIDENCE_REJECTED' AND ts.state_code = 'WITHDRAWN'
    AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'WITHDRAW'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

COMMIT;
