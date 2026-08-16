-- ============================================================
-- 100-ADD-WORKFLOW-APPEAL-RENEWAL-TRANSITIONS
-- ============================================================
-- إضافة حالات وانتقالات سير العمل الناقصة المذكورة في الكود
-- لكنها غير معرّفة في قاعدة البيانات:
--
-- الحالات المضافة (2):
--   APPEAL_REVIEW     — مراجعة الاستئناف (بعد استئناف الرفض)
--   RENEWAL_REVIEW    — مراجعة التجديد (المراجعة المستمرة السنوية)
--
-- الانتقالات المضافة (10):
--   APPEAL              — REJECTED → APPEAL_REVIEW   (الباحث، يلزم تعليق)
--   ACCEPT_APPEAL       — APPEAL_REVIEW → APPROVED   (الإدارة، يلزم تعليق)
--   REJECT_APPEAL       — APPEAL_REVIEW → REJECTED   (الإدارة، يلزم تعليق)
--   WITHDRAW            — APPEAL_REVIEW → WITHDRAWN
--   INITIATE_RENEWAL    — APPROVED → RENEWAL_REVIEW  (الإدارة، لا يلزم تعليق)
--   RENEWAL_APPROVED    — RENEWAL_REVIEW → APPROVED
--   RENEWAL_REJECTED    — RENEWAL_REVIEW → REJECTED  (يلزم تعليق)
--   WITHDRAW            — RENEWAL_REVIEW → WITHDRAWN
--   WITHDRAW_DRAFT      — DRAFT → WITHDRAWN          (لا يلزم تعليق)
--   WITHDRAW_RETURNED   — RETURNED → WITHDRAWN       (يلزم تعليق)
--
-- ملاحظة RULE 11 (اشتقاق الحالة النهائية):
--   قاعدة 44-fix-terminal-states.sql تنص: "مصدر الحقيقة هو جدول
--   الانتقالات؛ is_terminal يجب أن يعكس الواقع". بإضافة انتقال APPEAL
--   من REJECTED أصبحت REJECTED غير نهائية (لديها انتقال صادر)، لذا
--   تُحدَّث is_terminal = false في workflow.workflow_states وفي
--   reference.application_statuses حتى لا تُكمل مثيل سير العمل عند الرفض
--   ويصبح الاستئناف ممكناً. (REJECTED ما زالت تُعامل نهائية لصلاحيات
--   حذف الأدلة عبر القائمة الثابتة في evidence.service.ts — RULE 12.)
--
-- ملاحظة INITIATE_RENEWAL:
--   application.service.ts:379 يستدعي executeTransition بمعامل comment
--   غير معرّف، لذا يجب أن يكون requires_comment = false.
-- ============================================================

BEGIN;

-- ============================================================
-- 1) الحالات الجديدة في workflow.workflow_states
-- ============================================================

-- APPEAL_REVIEW — غير نهائية (لديها انتقالات صادرة)
INSERT INTO workflow.workflow_states (workflow_id, state_code, state_name, is_initial, is_terminal, display_order)
SELECT w.id, 'APPEAL_REVIEW', 'مراجعة الاستئناف', false, false, 15
FROM workflow.workflows w
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_states s
    WHERE s.workflow_id = w.id AND s.state_code = 'APPEAL_REVIEW'
  );

-- RENEWAL_REVIEW — غير نهائية (لديها انتقالات صادرة)
INSERT INTO workflow.workflow_states (workflow_id, state_code, state_name, is_initial, is_terminal, display_order)
SELECT w.id, 'RENEWAL_REVIEW', 'مراجعة التجديد', false, false, 16
FROM workflow.workflows w
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_states s
    WHERE s.workflow_id = w.id AND s.state_code = 'RENEWAL_REVIEW'
  );

-- ============================================================
-- 2) الحالات الجديدة في reference.application_statuses
-- ============================================================

INSERT INTO reference.application_statuses (status_code, status_name_ar, status_name_en, display_order, is_terminal)
SELECT 'APPEAL_REVIEW', 'مراجعة الاستئناف', 'Appeal Review', 15, false
WHERE NOT EXISTS (
    SELECT 1 FROM reference.application_statuses WHERE status_code = 'APPEAL_REVIEW'
);

INSERT INTO reference.application_statuses (status_code, status_name_ar, status_name_en, display_order, is_terminal)
SELECT 'RENEWAL_REVIEW', 'مراجعة التجديد', 'Renewal Review', 16, false
WHERE NOT EXISTS (
    SELECT 1 FROM reference.application_statuses WHERE status_code = 'RENEWAL_REVIEW'
);

-- ============================================================
-- 3) تحديث is_terminal لـ REJECTED (أصبح لها انتقال صادر APPEAL)
-- ============================================================

UPDATE workflow.workflow_states s
SET is_terminal = false
FROM workflow.workflows w
WHERE s.workflow_id = w.id
  AND w.workflow_code = 'APP_REVIEW_V1'
  AND s.state_code = 'REJECTED'
  AND s.is_terminal = true;

UPDATE reference.application_statuses
SET is_terminal = false
WHERE status_code = 'REJECTED'
  AND is_terminal = true;

-- ============================================================
-- 4) الانتقالات الجديدة في workflow.workflow_transitions
-- ============================================================

-- APPEAL: REJECTED → APPEAL_REVIEW (الباحث، يلزم تعليق — مسوغ الاستئناف)
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'APPEAL', 'استئناف الرفض', true, false, 'RESEARCHER'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'REJECTED' AND ts.state_code = 'APPEAL_REVIEW'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'APPEAL'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- ACCEPT_APPEAL: APPEAL_REVIEW → APPROVED (إعادة الاعتماد، يلزم تعليق)
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'ACCEPT_APPEAL', 'قبول الاستئناف', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'APPEAL_REVIEW' AND ts.state_code = 'APPROVED'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'ACCEPT_APPEAL'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- REJECT_APPEAL: APPEAL_REVIEW → REJECTED (تأكيد الرفض، يلزم تعليق)
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'REJECT_APPEAL', 'رفض الاستئناف', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'APPEAL_REVIEW' AND ts.state_code = 'REJECTED'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'REJECT_APPEAL'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- WITHDRAW: APPEAL_REVIEW → WITHDRAWN
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'WITHDRAW', 'سحب الطلب', true, false, 'RESEARCHER,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'APPEAL_REVIEW' AND ts.state_code = 'WITHDRAWN'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'WITHDRAW'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- INITIATE_RENEWAL: APPROVED → RENEWAL_REVIEW (يلزم NO comment — الخدمة تمرر undefined)
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'INITIATE_RENEWAL', 'بدء التجديد السنوي', false, false, 'ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'APPROVED' AND ts.state_code = 'RENEWAL_REVIEW'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'INITIATE_RENEWAL'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- RENEWAL_APPROVED: RENEWAL_REVIEW → APPROVED (تجديد الموافقة)
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'RENEWAL_APPROVED', 'تجديد الموافقة', false, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'RENEWAL_REVIEW' AND ts.state_code = 'APPROVED'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'RENEWAL_APPROVED'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- RENEWAL_REJECTED: RENEWAL_REVIEW → REJECTED (لا يمكن استمرار الدراسة، يلزم تعليق)
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'RENEWAL_REJECTED', 'رفض التجديد', true, false, 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'RENEWAL_REVIEW' AND ts.state_code = 'REJECTED'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'RENEWAL_REJECTED'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- WITHDRAW: RENEWAL_REVIEW → WITHDRAWN
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'WITHDRAW', 'سحب الطلب', true, false, 'RESEARCHER,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'RENEWAL_REVIEW' AND ts.state_code = 'WITHDRAWN'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'WITHDRAW'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- WITHDRAW_DRAFT: DRAFT → WITHDRAWN (لا يلزم تعليق — WITHDRAW_MAP في الخدمة)
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'WITHDRAW_DRAFT', 'سحب المسودة', false, false, 'RESEARCHER,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'DRAFT' AND ts.state_code = 'WITHDRAWN'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'WITHDRAW_DRAFT'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- WITHDRAW_RETURNED: RETURNED → WITHDRAWN (يلزم تعليق)
INSERT INTO workflow.workflow_transitions (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
SELECT w.id, fs.id, ts.id, 'WITHDRAW_RETURNED', 'سحب الطلب المعاد', true, false, 'RESEARCHER,ETHICS_ADMIN,SUPER_ADMIN'
FROM workflow.workflows w, workflow.workflow_states fs, workflow.workflow_states ts
WHERE w.workflow_code = 'APP_REVIEW_V1'
  AND fs.state_code = 'RETURNED' AND ts.state_code = 'WITHDRAWN'
  AND NOT EXISTS (
    SELECT 1 FROM workflow.workflow_transitions t
    WHERE t.workflow_id = w.id AND t.transition_code = 'WITHDRAW_RETURNED'
      AND t.from_state_id = fs.id AND t.to_state_id = ts.id
  );

-- ============================================================
-- 5) إعادة تفعيل مثيلات سير العمل للطلبات الحالية المرفوضة
--    حتى يمكن استئنافها (كانت مكتملة لأن REJECTED كانت نهائية)
-- ============================================================

UPDATE workflow.workflow_instances wi
SET status_code = 'ACTIVE', completed_at = NULL
FROM core.applications a
WHERE wi.entity_type = 'Application'
  AND wi.entity_id = a.id
  AND a.current_status = 'REJECTED'
  AND EXISTS (
    SELECT 1 FROM workflow.workflow_states s
    WHERE s.id = wi.current_state_id AND s.state_code = 'REJECTED'
  )
  AND wi.status_code = 'COMPLETED';

COMMIT;
