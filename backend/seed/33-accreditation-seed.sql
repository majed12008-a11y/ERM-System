SET app.user_id = '0';
BEGIN;

-- ============================================================
-- 33-ACCREDITATION-SEED.SQL
-- P3 Committee Accreditation — Seed Data
-- ============================================================

-- 1. STANDARDS — Master list (12 requirements)
INSERT INTO committee.accreditation_standards (code, name_ar, name_en, description_ar, description_en, category, sort_order)
VALUES
  ('SOP', 'الإجراءات التشغيلية المعيارية', 'Standard Operating Procedures',
   'وثائق الإجراءات التشغيلية المعيارية للجنة', 'Committee SOP documentation', 'DOCUMENT', 1),
  ('TOR', 'اختصاصات اللجنة', 'Terms of Reference',
   'وثيقة تحديد مهام وصلاحيات اللجنة', 'Committee Terms of Reference document', 'DOCUMENT', 2),
  ('COI', 'سياسة تضارب المصالح', 'Conflict of Interest Policy',
   'سياسة إدارة وتوثيق تضارب المصالح', 'Conflict of Interest management policy', 'DOCUMENT', 3),
  ('TRAINING', 'سجلات تدريب المراجعين', 'Reviewer Training Records',
   'سجلات تدريب وتأهيل أعضاء اللجنة', 'Committee member training and qualification records', 'TRAINING', 4),
  ('QUORUM', 'الامتثال للنصاب القانوني', 'Quorum Compliance Evidence',
   'سجلات إثبات اكتمال النصاب القانوني في الاجتماعات', 'Evidence of quorum compliance in meetings', 'COMPLIANCE', 5),
  ('MEETING_MINUTES', 'توثيق الاجتماعات', 'Meeting Documentation',
   'محاضر اجتماعات اللجنة مع الحضور والقرارات', 'Meeting minutes with attendance and decisions', 'DOCUMENT', 6),
  ('CONTINUING_REVIEW', 'إجراءات المراجعة المستمرة', 'Continuing Review Process',
   'آلية المتابعة المستمرة للأبحاث المعتمدة', 'Process for ongoing review of approved research', 'PROCESS', 7),
  ('SAE_HANDLING', 'إجراءات التعامل مع الأحداث الضارة', 'SAE Handling Process',
   'إجراءات الإبلاغ والتعامل مع الأحداث الضارة الجسيمة', 'Serious Adverse Event handling and reporting process', 'PROCESS', 8),
  ('DATA_PROTECTION', 'سياسة حماية البيانات', 'Data Protection & Confidentiality',
   'سياسة حماية سرية وخصوصية بيانات المشاركين', 'Data protection and confidentiality policy', 'DOCUMENT', 9),
  ('MEMBER_QUAL', 'سجلات مؤهلات الأعضاء', 'Member Qualification Records',
   'سجلات مؤهلات وخبرات أعضاء اللجنة', 'Committee member qualification and expertise records', 'TRAINING', 10),
  ('ANNUAL_REPORT', 'التقرير السنوي', 'Annual Activity Report',
   'تقرير سنوي عن نشاطات اللجنة', 'Annual committee activity report', 'DOCUMENT', 11),
  ('BUDGET', 'الميزانية التشغيلية', 'Operational Budget',
   'هيكل الميزانية التشغيلية للجنة', 'Committee operational budget structure', 'DOCUMENT', 12)
ON CONFLICT (code) DO NOTHING;

-- 2. STANDARD VERSION — 2027 Edition (all mandatory except ANNUAL_REPORT and BUDGET)
INSERT INTO committee.accreditation_standard_versions (standard_id, version_label, is_mandatory, is_active, effective_from)
SELECT s.id, '2027',
  CASE WHEN s.code IN ('ANNUAL_REPORT', 'BUDGET') THEN false ELSE true END,
  true, '2026-07-01'
FROM committee.accreditation_standards s
WHERE NOT EXISTS (
  SELECT 1 FROM committee.accreditation_standard_versions sv
  WHERE sv.standard_id = s.id AND sv.version_label = '2027'
);

-- 3. ACCREDITATION CYCLES — Test data

-- Helper: get user IDs
DO $$
DECLARE
  v_admin_id BIGINT;
  v_aden_chair_id BIGINT;
  v_sanaa_chair_id BIGINT;
  v_stdver_id BIGINT;
  v_cycle1_id BIGINT;
  v_cycle2_id BIGINT;
  v_cycle3_id BIGINT;
  v_assessment_id BIGINT;
  v_now TIMESTAMPTZ := now();
BEGIN
  SELECT id INTO v_admin_id FROM security.users WHERE username = 'admin';
  SELECT id INTO v_aden_chair_id FROM security.users WHERE username = 'aden_chair';
  SELECT id INTO v_sanaa_chair_id FROM security.users WHERE username = 'sanaa_chair';

  -- Use first active standard version
  SELECT id INTO v_stdver_id FROM committee.accreditation_standard_versions
  WHERE is_active = true LIMIT 1;

  -- Cycle 1: ACCREDITED (committee 1 — NCBE, cycle 1, valid 2026–2029)
  INSERT INTO committee.accreditation_cycles
    (committee_id, standard_version_id, cycle_number, status, valid_from, valid_until, notes, decided_by, decided_at, created_by, created_at)
  VALUES
    (1, v_stdver_id, 1, 'ACCREDITED', '2026-07-01', '2029-07-01',
     'الدورة الأولى — اعتماد كامل', v_admin_id, v_now, v_admin_id, v_now - interval '30 days')
  RETURNING id INTO v_cycle1_id;

  INSERT INTO committee.accreditation_decisions (cycle_id, from_status, to_status, decision, decided_by, notes, created_at)
  VALUES (v_cycle1_id, NULL, 'PENDING', 'APPLY', v_admin_id, 'تقديم طلب اعتماد', v_now - interval '30 days');

  INSERT INTO committee.accreditation_decisions (cycle_id, from_status, to_status, decision, decided_by, notes, created_at)
  VALUES (v_cycle1_id, 'PENDING', 'UNDER_REVIEW', 'SUBMIT', v_admin_id, 'تقديم للمراجعة', v_now - interval '25 days');

  INSERT INTO committee.accreditation_decisions (cycle_id, from_status, to_status, decision, decided_by, notes, created_at)
  VALUES (v_cycle1_id, 'UNDER_REVIEW', 'ACCREDITED', 'APPROVE', v_admin_id, 'اعتماد كامل', v_now - interval '20 days');

  -- Assessment for cycle 1
  INSERT INTO committee.accreditation_assessments (cycle_id, assessed_by, overall_decision, overall_justification, overall_score, assessed_at)
  VALUES (v_cycle1_id, v_admin_id, 'RECOMMEND_APPROVE', 'جميع المعايير مستوفاة', 92, v_now - interval '21 days')
  RETURNING id INTO v_assessment_id;

  INSERT INTO committee.accreditation_assessment_items (assessment_id, standard_version_id, is_met, findings, score)
  SELECT v_assessment_id, sv.id, true, 'مستوفى', 5
  FROM committee.accreditation_standard_versions sv WHERE sv.is_active = true;

  -- Cycle 2: UNDER_REVIEW (committee 3 — Aden)
  INSERT INTO committee.accreditation_cycles
    (committee_id, standard_version_id, cycle_number, status, notes, created_by, created_at)
  VALUES
    (3, v_stdver_id, 1, 'UNDER_REVIEW',
     'الدورة الأولى — قيد التقييم', v_aden_chair_id, v_now - interval '10 days')
  RETURNING id INTO v_cycle2_id;

  INSERT INTO committee.accreditation_decisions (cycle_id, from_status, to_status, decision, decided_by, notes, created_at)
  VALUES (v_cycle2_id, NULL, 'PENDING', 'APPLY', v_aden_chair_id, 'تقديم طلب اعتماد', v_now - interval '10 days');

  INSERT INTO committee.accreditation_decisions (cycle_id, from_status, to_status, decision, decided_by, notes, created_at)
  VALUES (v_cycle2_id, 'PENDING', 'UNDER_REVIEW', 'SUBMIT', v_aden_chair_id, 'تقديم للمراجعة', v_now - interval '5 days');

  -- Cycle 3: CONDITIONAL (committee 2 — Sanaa, with 2 open conditions)
  INSERT INTO committee.accreditation_cycles
    (committee_id, standard_version_id, cycle_number, status, valid_from, valid_until, notes, decided_by, decided_at, created_by, created_at)
  VALUES
    (2, v_stdver_id, 1, 'CONDITIONAL', '2026-06-01', '2029-06-01',
     'الدورة الأولى — اعتماد مشروط', v_admin_id, v_now - interval '15 days', v_sanaa_chair_id, v_now - interval '40 days')
  RETURNING id INTO v_cycle3_id;

  INSERT INTO committee.accreditation_decisions (cycle_id, from_status, to_status, decision, decided_by, notes, created_at)
  VALUES (v_cycle3_id, NULL, 'PENDING', 'APPLY', v_sanaa_chair_id, 'تقديم طلب اعتماد', v_now - interval '40 days');

  INSERT INTO committee.accreditation_decisions (cycle_id, from_status, to_status, decision, decided_by, notes, created_at)
  VALUES (v_cycle3_id, 'PENDING', 'UNDER_REVIEW', 'SUBMIT', v_sanaa_chair_id, 'تقديم للمراجعة', v_now - interval '35 days');

  INSERT INTO committee.accreditation_decisions (cycle_id, from_status, to_status, decision, decided_by, notes, created_at)
  VALUES (v_cycle3_id, 'UNDER_REVIEW', 'CONDITIONAL', 'CONDITIONAL', v_admin_id, 'اعتماد مشروط — مطلوب استكمال SOPs', v_now - interval '15 days');

  -- 2 conditions for cycle 3
  INSERT INTO committee.accreditation_conditions (cycle_id, condition_text, due_date, status)
  VALUES (v_cycle3_id, 'تقديم الإجراءات التشغيلية المعيارية (SOPs) محدثة', v_now + interval '60 days', 'OPEN');

  INSERT INTO committee.accreditation_conditions (cycle_id, condition_text, due_date, status)
  VALUES (v_cycle3_id, 'توثيق سجلات تدريب المراجعين للعام الحالي', v_now + interval '30 days', 'OPEN');

END $$;

COMMIT;
