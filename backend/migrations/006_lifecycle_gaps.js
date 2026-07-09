/**
 * Migration: 006_lifecycle_gaps
 * ─────────────────────────────────────────────────────────────────────────────
 * يُعالج الثغرات الحرجة في دورة حياة طلبات البحث بناءً على:
 *   - ICH-GCP E6(R3) §3.3  — مراجعة سنوية مستمرة
 *   - CIOMS Guideline 2     — آلية استئناف
 *   - WHO ERC §3.7          — الاستئناف
 *   - تحليل 14 حالة vs 9 حالات في workflow
 *
 * التغييرات:
 *   + 5 حالات جديدة في workflow.workflow_states
 *   + 10 انتقالات جديدة في workflow.workflow_transitions
 *   +  6 سجلات SLA في workflow.workflow_sla
 * ─────────────────────────────────────────────────────────────────────────────
 */

exports.up = (pgm) => {
  pgm.sql(`
    -- =========================================================================
    -- STEP 1: إضافة الحالات الجديدة
    -- =========================================================================
    -- نجلب workflow_id للـ APP_REVIEW_V1 ديناميكياً
    DO $$
    DECLARE
      v_workflow_id BIGINT;
      v_max_order   INT;
    BEGIN
      SELECT id INTO v_workflow_id
        FROM workflow.workflows
        WHERE workflow_code = 'APP_REVIEW_V1'
        LIMIT 1;

      IF v_workflow_id IS NULL THEN
        RAISE EXCEPTION 'Workflow APP_REVIEW_V1 not found — cannot run migration 006';
      END IF;

      SELECT COALESCE(MAX(display_order), 9) INTO v_max_order
        FROM workflow.workflow_states
        WHERE workflow_id = v_workflow_id;

      -- 1. CONDITIONALLY_APPROVED — موافقة مشروطة (non-terminal)
      INSERT INTO workflow.workflow_states
        (workflow_id, state_code, state_name, is_initial, is_terminal, display_order)
      VALUES
        (v_workflow_id, 'CONDITIONALLY_APPROVED', 'موافق عليه مشروطاً', FALSE, FALSE, v_max_order + 1)
      ON CONFLICT DO NOTHING;

      -- 2. WITHDRAWN — مسحوب (terminal)
      INSERT INTO workflow.workflow_states
        (workflow_id, state_code, state_name, is_initial, is_terminal, display_order)
      VALUES
        (v_workflow_id, 'WITHDRAWN', 'مسحوب', FALSE, TRUE, v_max_order + 2)
      ON CONFLICT DO NOTHING;

      -- 3. APPEAL_REVIEW — قيد الاستئناف (non-terminal)
      INSERT INTO workflow.workflow_states
        (workflow_id, state_code, state_name, is_initial, is_terminal, display_order)
      VALUES
        (v_workflow_id, 'APPEAL_REVIEW', 'قيد الاستئناف', FALSE, FALSE, v_max_order + 3)
      ON CONFLICT DO NOTHING;

      -- 4. RENEWAL_REVIEW — قيد التجديد السنوي (non-terminal)
      INSERT INTO workflow.workflow_states
        (workflow_id, state_code, state_name, is_initial, is_terminal, display_order)
      VALUES
        (v_workflow_id, 'RENEWAL_REVIEW', 'قيد التجديد السنوي', FALSE, FALSE, v_max_order + 4)
      ON CONFLICT DO NOTHING;

      -- 5. SUSPENDED — معلق (non-terminal)
      INSERT INTO workflow.workflow_states
        (workflow_id, state_code, state_name, is_initial, is_terminal, display_order)
      VALUES
        (v_workflow_id, 'SUSPENDED', 'معلق', FALSE, FALSE, v_max_order + 5)
      ON CONFLICT DO NOTHING;

      RAISE NOTICE 'Migration 006: % new states inserted for workflow %', 5, v_workflow_id;
    END $$;


    -- =========================================================================
    -- STEP 2: إضافة الانتقالات الجديدة
    -- =========================================================================
    DO $$
    DECLARE
      v_workflow_id       BIGINT;

      -- حالات المصدر (موجودة مسبقاً)
      s_draft             BIGINT;
      s_submitted         BIGINT;
      s_returned          BIGINT;
      s_committee_review  BIGINT;
      s_rejected          BIGINT;
      s_approved          BIGINT;

      -- حالات الهدف (الجديدة)
      s_conditionally     BIGINT;
      s_withdrawn         BIGINT;
      s_appeal_review     BIGINT;
      s_renewal_review    BIGINT;
      s_suspended         BIGINT;

    BEGIN
      -- جلب workflow_id
      SELECT id INTO v_workflow_id
        FROM workflow.workflows
        WHERE workflow_code = 'APP_REVIEW_V1'
        LIMIT 1;

      -- جلب IDs للحالات الموجودة
      SELECT id INTO s_draft            FROM workflow.workflow_states WHERE workflow_id = v_workflow_id AND state_code = 'DRAFT';
      SELECT id INTO s_submitted        FROM workflow.workflow_states WHERE workflow_id = v_workflow_id AND state_code = 'SUBMITTED';
      SELECT id INTO s_returned         FROM workflow.workflow_states WHERE workflow_id = v_workflow_id AND state_code = 'RETURNED';
      SELECT id INTO s_committee_review FROM workflow.workflow_states WHERE workflow_id = v_workflow_id AND state_code = 'COMMITTEE_REVIEW';
      SELECT id INTO s_rejected         FROM workflow.workflow_states WHERE workflow_id = v_workflow_id AND state_code = 'REJECTED';
      SELECT id INTO s_approved         FROM workflow.workflow_states WHERE workflow_id = v_workflow_id AND state_code = 'APPROVED';

      -- جلب IDs للحالات الجديدة
      SELECT id INTO s_conditionally    FROM workflow.workflow_states WHERE workflow_id = v_workflow_id AND state_code = 'CONDITIONALLY_APPROVED';
      SELECT id INTO s_withdrawn        FROM workflow.workflow_states WHERE workflow_id = v_workflow_id AND state_code = 'WITHDRAWN';
      SELECT id INTO s_appeal_review    FROM workflow.workflow_states WHERE workflow_id = v_workflow_id AND state_code = 'APPEAL_REVIEW';
      SELECT id INTO s_renewal_review   FROM workflow.workflow_states WHERE workflow_id = v_workflow_id AND state_code = 'RENEWAL_REVIEW';
      SELECT id INTO s_suspended        FROM workflow.workflow_states WHERE workflow_id = v_workflow_id AND state_code = 'SUSPENDED';

      -- ── مسارات السحب ──────────────────────────────────────────────────────
      -- DRAFT → WITHDRAWN  (الباحث يسحب مسودته)
      INSERT INTO workflow.workflow_transitions
        (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
      VALUES
        (v_workflow_id, s_draft, s_withdrawn, 'WITHDRAW_DRAFT',
         'سحب المسودة', FALSE, FALSE, 'RESEARCHER')
      ON CONFLICT DO NOTHING;

      -- SUBMITTED → WITHDRAWN  (الباحث يسحب طلبًا مقدَّمًا — قبل تعيين مراجع)
      INSERT INTO workflow.workflow_transitions
        (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
      VALUES
        (v_workflow_id, s_submitted, s_withdrawn, 'WITHDRAW',
         'سحب الطلب', TRUE, FALSE, 'RESEARCHER')
      ON CONFLICT DO NOTHING;

      -- RETURNED → WITHDRAWN  (الباحث يسحب طلبًا مُعادًا)
      INSERT INTO workflow.workflow_transitions
        (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
      VALUES
        (v_workflow_id, s_returned, s_withdrawn, 'WITHDRAW_RETURNED',
         'سحب الطلب المُعاد', TRUE, FALSE, 'RESEARCHER')
      ON CONFLICT DO NOTHING;

      -- ── مسارات الموافقة المشروطة ──────────────────────────────────────────
      -- COMMITTEE_REVIEW → CONDITIONALLY_APPROVED
      INSERT INTO workflow.workflow_transitions
        (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
      VALUES
        (v_workflow_id, s_committee_review, s_conditionally, 'COMMITTEE_CONDITION',
         'موافقة مشروطة', TRUE, TRUE, 'COMMITTEE_CHAIR,ETHICS_ADMIN,SUPER_ADMIN')
      ON CONFLICT DO NOTHING;

      -- CONDITIONALLY_APPROVED → APPROVED  (استيفاء الشروط)
      INSERT INTO workflow.workflow_transitions
        (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
      VALUES
        (v_workflow_id, s_conditionally, s_approved, 'CONDITIONS_MET',
         'استيفاء الشروط', TRUE, FALSE, 'ETHICS_ADMIN,SUPER_ADMIN')
      ON CONFLICT DO NOTHING;

      -- CONDITIONALLY_APPROVED → REJECTED  (فشل استيفاء الشروط)
      INSERT INTO workflow.workflow_transitions
        (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
      VALUES
        (v_workflow_id, s_conditionally, s_rejected, 'CONDITIONS_FAIL',
         'فشل استيفاء الشروط', TRUE, FALSE, 'ETHICS_ADMIN,SUPER_ADMIN')
      ON CONFLICT DO NOTHING;

      -- ── مسارات الاستئناف ──────────────────────────────────────────────────
      -- REJECTED → APPEAL_REVIEW  (الباحث يستأنف)
      INSERT INTO workflow.workflow_transitions
        (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
      VALUES
        (v_workflow_id, s_rejected, s_appeal_review, 'APPEAL',
         'تقديم استئناف', TRUE, FALSE, 'RESEARCHER')
      ON CONFLICT DO NOTHING;

      -- APPEAL_REVIEW → COMMITTEE_REVIEW  (قبول الاستئناف → إعادة للجنة)
      INSERT INTO workflow.workflow_transitions
        (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
      VALUES
        (v_workflow_id, s_appeal_review, s_committee_review, 'APPEAL_APPROVE',
         'قبول الاستئناف', TRUE, FALSE, 'ETHICS_ADMIN,SUPER_ADMIN')
      ON CONFLICT DO NOTHING;

      -- APPEAL_REVIEW → REJECTED  (رفض الاستئناف → يبقى مرفوضًا)
      INSERT INTO workflow.workflow_transitions
        (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
      VALUES
        (v_workflow_id, s_appeal_review, s_rejected, 'APPEAL_REJECT',
         'رفض الاستئناف', TRUE, FALSE, 'ETHICS_ADMIN,SUPER_ADMIN')
      ON CONFLICT DO NOTHING;

      -- ── مسارات التجديد السنوي ─────────────────────────────────────────────
      -- APPROVED → RENEWAL_REVIEW  (بدء دورة التجديد السنوية — ICH-GCP §3.3)
      INSERT INTO workflow.workflow_transitions
        (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
      VALUES
        (v_workflow_id, s_approved, s_renewal_review, 'INITIATE_RENEWAL',
         'بدء التجديد السنوي', FALSE, FALSE, 'ETHICS_ADMIN,SUPER_ADMIN')
      ON CONFLICT DO NOTHING;

      -- RENEWAL_REVIEW → APPROVED  (إقرار التجديد)
      INSERT INTO workflow.workflow_transitions
        (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
      VALUES
        (v_workflow_id, s_renewal_review, s_approved, 'RENEW_APPROVE',
         'إقرار التجديد', FALSE, FALSE, 'ETHICS_ADMIN,SUPER_ADMIN')
      ON CONFLICT DO NOTHING;

      -- RENEWAL_REVIEW → REJECTED  (رفض التجديد — ينهي الموافقة)
      INSERT INTO workflow.workflow_transitions
        (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
      VALUES
        (v_workflow_id, s_renewal_review, s_rejected, 'RENEW_REJECT',
         'رفض التجديد', TRUE, FALSE, 'ETHICS_ADMIN,SUPER_ADMIN')
      ON CONFLICT DO NOTHING;

      -- ── مسارات التعليق ────────────────────────────────────────────────────
      -- APPROVED → SUSPENDED
      INSERT INTO workflow.workflow_transitions
        (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
      VALUES
        (v_workflow_id, s_approved, s_suspended, 'SUSPEND',
         'تعليق الموافقة', TRUE, FALSE, 'ETHICS_ADMIN,SUPER_ADMIN')
      ON CONFLICT DO NOTHING;

      -- SUSPENDED → APPROVED  (رفع التعليق)
      INSERT INTO workflow.workflow_transitions
        (workflow_id, from_state_id, to_state_id, transition_code, transition_name, requires_comment, requires_vote, allowed_roles)
      VALUES
        (v_workflow_id, s_suspended, s_approved, 'REINSTATE',
         'رفع التعليق', TRUE, FALSE, 'ETHICS_ADMIN,SUPER_ADMIN')
      ON CONFLICT DO NOTHING;

      RAISE NOTICE 'Migration 006: 13 transitions inserted for workflow %', v_workflow_id;
    END $$;


    -- =========================================================================
    -- STEP 3: تفعيل سجلات SLA
    -- =========================================================================
    DO $$
    DECLARE
      v_workflow_id BIGINT;
    BEGIN
      SELECT id INTO v_workflow_id
        FROM workflow.workflows
        WHERE workflow_code = 'APP_REVIEW_V1'
        LIMIT 1;

      -- INITIAL_REVIEW: 7 أيام (ICH-GCP §3.2.2)
      INSERT INTO workflow.workflow_sla (workflow_id, state_id, sla_duration, escalation_action)
      SELECT v_workflow_id, s.id, INTERVAL '7 days', 'NOTIFY_ADMIN'
        FROM workflow.workflow_states s
        WHERE s.workflow_id = v_workflow_id AND s.state_code = 'INITIAL_REVIEW'
      ON CONFLICT DO NOTHING;

      -- SCIENTIFIC_REVIEW: 14 يوماً
      INSERT INTO workflow.workflow_sla (workflow_id, state_id, sla_duration, escalation_action)
      SELECT v_workflow_id, s.id, INTERVAL '14 days', 'NOTIFY_ADMIN'
        FROM workflow.workflow_states s
        WHERE s.workflow_id = v_workflow_id AND s.state_code = 'SCIENTIFIC_REVIEW'
      ON CONFLICT DO NOTHING;

      -- ETHICAL_REVIEW: 14 يوماً
      INSERT INTO workflow.workflow_sla (workflow_id, state_id, sla_duration, escalation_action)
      SELECT v_workflow_id, s.id, INTERVAL '14 days', 'NOTIFY_ADMIN'
        FROM workflow.workflow_states s
        WHERE s.workflow_id = v_workflow_id AND s.state_code = 'ETHICAL_REVIEW'
      ON CONFLICT DO NOTHING;

      -- COMMITTEE_REVIEW: 30 يوماً
      INSERT INTO workflow.workflow_sla (workflow_id, state_id, sla_duration, escalation_action)
      SELECT v_workflow_id, s.id, INTERVAL '30 days', 'NOTIFY_CHAIR'
        FROM workflow.workflow_states s
        WHERE s.workflow_id = v_workflow_id AND s.state_code = 'COMMITTEE_REVIEW'
      ON CONFLICT DO NOTHING;

      -- RENEWAL_REVIEW: 30 يوماً (ICH-GCP §3.3 — مراجعة سنوية)
      INSERT INTO workflow.workflow_sla (workflow_id, state_id, sla_duration, escalation_action)
      SELECT v_workflow_id, s.id, INTERVAL '30 days', 'NOTIFY_CHAIR'
        FROM workflow.workflow_states s
        WHERE s.workflow_id = v_workflow_id AND s.state_code = 'RENEWAL_REVIEW'
      ON CONFLICT DO NOTHING;

      -- APPEAL_REVIEW: 21 يوماً (CIOMS Guideline 2)
      INSERT INTO workflow.workflow_sla (workflow_id, state_id, sla_duration, escalation_action)
      SELECT v_workflow_id, s.id, INTERVAL '21 days', 'NOTIFY_ADMIN'
        FROM workflow.workflow_states s
        WHERE s.workflow_id = v_workflow_id AND s.state_code = 'APPEAL_REVIEW'
      ON CONFLICT DO NOTHING;

      RAISE NOTICE 'Migration 006: 6 SLA records inserted for workflow %', v_workflow_id;
    END $$;


    -- =========================================================================
    -- STEP 4: إضافة CONDITIONALLY_APPROVED إلى reference.application_statuses
    --         إذا كانت غير موجودة
    -- =========================================================================
    INSERT INTO reference.application_statuses
      (status_code, status_name, description, is_terminal, display_order)
    VALUES
      ('CONDITIONALLY_APPROVED', 'موافق عليه مشروطاً',
       'تمت الموافقة بشروط يجب استيفاؤها قبل بدء البحث', FALSE, 12),
      ('WITHDRAWN',   'مسحوب',
       'تم سحب الطلب من قِبل الباحث', TRUE, 13),
      ('APPEAL_REVIEW', 'قيد الاستئناف',
       'الطلب قيد مراجعة الاستئناف المقدم من الباحث', FALSE, 14),
      ('RENEWAL_REVIEW', 'قيد التجديد السنوي',
       'الطلب في مرحلة المراجعة السنوية المستمرة (ICH-GCP §3.3)', FALSE, 15),
      ('SUSPENDED',   'معلق',
       'تم تعليق الموافقة مؤقتاً بقرار من اللجنة', FALSE, 16)
    ON CONFLICT (status_code) DO NOTHING;
  `);
};

exports.down = (pgm) => {
  pgm.sql(`
    -- =========================================================================
    -- ROLLBACK: حذف جميع التغييرات
    -- =========================================================================
    DO $$
    DECLARE
      v_workflow_id BIGINT;
      new_states TEXT[] := ARRAY[
        'CONDITIONALLY_APPROVED','WITHDRAWN','APPEAL_REVIEW','RENEWAL_REVIEW','SUSPENDED'
      ];
      new_transitions TEXT[] := ARRAY[
        'WITHDRAW_DRAFT','WITHDRAW','WITHDRAW_RETURNED',
        'COMMITTEE_CONDITION','CONDITIONS_MET','CONDITIONS_FAIL',
        'APPEAL','APPEAL_APPROVE','APPEAL_REJECT',
        'INITIATE_RENEWAL','RENEW_APPROVE','RENEW_REJECT',
        'SUSPEND','REINSTATE'
      ];
    BEGIN
      SELECT id INTO v_workflow_id
        FROM workflow.workflows
        WHERE workflow_code = 'APP_REVIEW_V1'
        LIMIT 1;

      -- حذف SLA
      DELETE FROM workflow.workflow_sla
        WHERE workflow_id = v_workflow_id
          AND state_id IN (
            SELECT id FROM workflow.workflow_states
            WHERE workflow_id = v_workflow_id
              AND state_code = ANY(new_states)
          );

      -- حذف الانتقالات
      DELETE FROM workflow.workflow_transitions
        WHERE workflow_id = v_workflow_id
          AND transition_code = ANY(new_transitions);

      -- حذف الحالات
      DELETE FROM workflow.workflow_states
        WHERE workflow_id = v_workflow_id
          AND state_code = ANY(new_states);

      -- حذف من reference
      DELETE FROM reference.application_statuses
        WHERE status_code = ANY(new_states);

      RAISE NOTICE 'Migration 006 rolled back successfully';
    END $$;
  `);
};
