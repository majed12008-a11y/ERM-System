-- ============================================================
-- 17-SAFETY DATA: risk_categories, risk_assessments, adverse_events,
--    serious_adverse_events, safety_followups, safety_reports,
--    safety_committee_reviews, mitigation_actions
-- ============================================================

BEGIN;

-- ============================================================
-- RISK CATEGORIES
-- ============================================================
INSERT INTO safety.risk_categories (category_code, category_name, description) VALUES
  ('PHYSICAL', 'مخاطر جسدية', 'Physical risks including injury, pain, discomfort'),
  ('PSYCHOLOGICAL', 'مخاطر نفسية', 'Psychological risks including distress, anxiety, trauma'),
  ('SOCIAL', 'مخاطر اجتماعية', 'Social risks including stigma, discrimination, loss of status'),
  ('ECONOMIC', 'مخاطر اقتصادية', 'Economic risks including financial loss, insurance issues'),
  ('LEGAL', 'مخاطر قانونية', 'Legal risks including breach of confidentiality, regulatory violations'),
  ('BIOLOGICAL', 'مخاطر بيولوجية', 'Biological risks including infection, biohazard exposure'),
  ('CHEMICAL', 'مخاطر كيميائية', 'Chemical risks including toxic exposure, drug reactions'),
  ('DATA_PRIVACY', 'مخاطر خصوصية البيانات', 'Data privacy risks including breach of personal data'),
  ('REPUTATIONAL', 'مخاطر سمعة', 'Reputational risks to institution or researchers'),
  ('ETHICAL', 'مخاطر أخلاقية', 'Ethical risks including coercion, undue influence');

-- ============================================================
-- RISK ASSESSMENTS (for approved/completed apps)
-- ============================================================
INSERT INTO safety.risk_assessments (application_id, assessment_date, overall_risk_level, assessment_summary, assessed_by)
SELECT a.id, '2024-03-20'::date, 'MEDIUM',
  'تقييم المخاطر لدراسة الوارفارين: المخاطر المتوقعة متوسطة وتشمل احتمالية حدوث نزيف وتحسس دوائي. تم وضع خطة مراقبة ومتابعة للمرضى. مستوى الفائدة المتوقعة يفوق المخاطر المحتملة.',
  u.id
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-001' AND u.username = 'ethics_admin';

INSERT INTO safety.risk_assessments (application_id, assessment_date, overall_risk_level, assessment_summary, assessed_by)
SELECT a.id, '2024-06-18'::date, 'HIGH',
  'تقييم المخاطر لدراسة علاج سرطان الثدي: مخاطر عالية نظراً لاستخدام علاج مناعي تجريبي وتأثيراته الجانبية المحتملة. تتطلب الخطة مراقبة دقيقة للآثار الجانبية وتقارير سلامة دورية.',
  u.id
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-002' AND u.username = 'ethics_admin';

INSERT INTO safety.risk_assessments (application_id, assessment_date, overall_risk_level, assessment_summary, assessed_by)
SELECT a.id, '2024-08-25'::date, 'HIGH',
  'تقييم مخاطر التعديل على دراسة سرطان الثدي: إضافة ذراع علاجي جديد يزيد من مستوى المخاطر. يجب تقديم تقارير سلامة إضافية.',
  u.id
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-003' AND u.username = 'ethics_admin';

INSERT INTO safety.risk_assessments (application_id, assessment_date, overall_risk_level, assessment_summary, assessed_by)
SELECT a.id, '2024-10-01'::date, 'LOW',
  'تقييم مخاطر دراسة الميكروبيوم: مخاطر منخفضة نظراً لكونها دراسة مقطعية غير تداخلية. تشمل المخاطر المحتملة خصوصية بيانات المشاركين.',
  u.id
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-005' AND u.username = 'ethics_admin';

-- ============================================================
-- MITIGATION ACTIONS
-- ============================================================
DO $$
DECLARE
  v_assessment1 bigint; v_assessment2 bigint; v_assessment3 bigint; v_assessment4 bigint;
  v_phy_id bigint; v_chem_id bigint; v_data_id bigint; v_psych_id bigint;
  v_ethics_admin bigint; v_researcher1 bigint; v_researcher2 bigint;
  v_chairperson bigint;
BEGIN
  SELECT id INTO v_ethics_admin FROM security.users WHERE username = 'ethics_admin';
  SELECT id INTO v_researcher1 FROM security.users WHERE username = 'researcher1';
  SELECT id INTO v_researcher2 FROM security.users WHERE username = 'researcher2';
  SELECT id INTO v_chairperson FROM security.users WHERE username = 'chairperson';
  SELECT id INTO v_phy_id FROM safety.risk_categories WHERE category_code = 'PHYSICAL';
  SELECT id INTO v_chem_id FROM safety.risk_categories WHERE category_code = 'CHEMICAL';
  SELECT id INTO v_data_id FROM safety.risk_categories WHERE category_code = 'DATA_PRIVACY';
  SELECT id INTO v_psych_id FROM safety.risk_categories WHERE category_code = 'PSYCHOLOGICAL';

  -- For assessment 1 (APP-2024-001)
  SELECT ra.id INTO v_assessment1 FROM safety.risk_assessments ra
    JOIN core.applications a ON a.id = ra.application_id
    WHERE a.application_number = 'APP-2024-001';

  INSERT INTO safety.mitigation_actions (risk_assessment_id, risk_category_id, action_description, responsible_user_id, target_date, status_code)
  VALUES (v_assessment1, v_phy_id, 'مراقبة علامات النزيف الحيوية للمرضى المسجلين في الدراسة وتوفير تدخل طبي فوري عند الحاجة', v_researcher1, '2024-04-15'::date, 'COMPLETED');

  INSERT INTO safety.mitigation_actions (risk_assessment_id, risk_category_id, action_description, responsible_user_id, target_date, status_code)
  VALUES (v_assessment1, v_chem_id, 'إجراء فحوصات إنزيمات الكبد بشكل دوري للمرضى لمراقبة السمية الكبدية المحتملة', v_researcher1, '2024-04-30'::date, 'COMPLETED');

  INSERT INTO safety.mitigation_actions (risk_assessment_id, risk_category_id, action_description, responsible_user_id, target_date, status_code)
  VALUES (v_assessment1, v_data_id, 'تشفير جميع بيانات المرضى وفصل المعلومات الشخصية عن البيانات السريرية', v_researcher1, '2024-04-01'::date, 'COMPLETED');

  -- For assessment 2 (APP-2024-002)
  SELECT ra.id INTO v_assessment2 FROM safety.risk_assessments ra
    JOIN core.applications a ON a.id = ra.application_id
    WHERE a.application_number = 'APP-2024-002';

  INSERT INTO safety.mitigation_actions (risk_assessment_id, risk_category_id, action_description, responsible_user_id, target_date, status_code)
  VALUES (v_assessment2, v_phy_id, 'وضع بروتوكول لإدارة الآثار الجانبية للعلاج المناعي (متلازمة إفراز السيتوكاين، التهاب القولون، التهاب الرئة)', v_researcher1, '2024-07-01'::date, 'IN_PROGRESS');

  INSERT INTO safety.mitigation_actions (risk_assessment_id, risk_category_id, action_description, responsible_user_id, target_date, status_code)
  VALUES (v_assessment2, v_psych_id, 'توفير دعم نفسي مستمر للمريضات المشاركات في الدراسة', v_chairperson, '2024-07-15'::date, 'IN_PROGRESS');

  INSERT INTO safety.mitigation_actions (risk_assessment_id, risk_category_id, action_description, responsible_user_id, target_date, status_code)
  VALUES (v_assessment2, v_data_id, 'تطبيق نظام إدارة بيانات آمن مع صلاحيات وصول محددة لأفراد فريق البحث فقط', v_researcher1, '2024-06-30'::date, 'COMPLETED');

  -- For assessment 3 (APP-2024-003)
  SELECT ra.id INTO v_assessment3 FROM safety.risk_assessments ra
    JOIN core.applications a ON a.id = ra.application_id
    WHERE a.application_number = 'APP-2024-003';

  INSERT INTO safety.mitigation_actions (risk_assessment_id, risk_category_id, action_description, responsible_user_id, target_date, status_code)
  VALUES (v_assessment3, v_phy_id, 'تحديث بروتوكول المراقبة ليشمل الآثار الجانبية الإضافية للذراع العلاجي الجديد', v_researcher1, '2024-09-15'::date, 'OPEN');

  INSERT INTO safety.mitigation_actions (risk_assessment_id, risk_category_id, action_description, responsible_user_id, target_date, status_code)
  VALUES (v_assessment3, v_data_id, 'مراجعة وتحديث نموذج الموافقة المستنيرة ليشمل المعلومات الجديدة عن المخاطر', v_ethics_admin, '2024-09-10'::date, 'OPEN');

  -- For assessment 4 (APP-2024-005)
  SELECT ra.id INTO v_assessment4 FROM safety.risk_assessments ra
    JOIN core.applications a ON a.id = ra.application_id
    WHERE a.application_number = 'APP-2024-005';

  INSERT INTO safety.mitigation_actions (risk_assessment_id, risk_category_id, action_description, responsible_user_id, target_date, status_code)
  VALUES (v_assessment4, v_data_id, 'استخدام رموز تعريفية بدلاً من أسماء المشاركين في قاعدة البيانات', v_researcher2, '2024-10-15'::date, 'OPEN');

  INSERT INTO safety.mitigation_actions (risk_assessment_id, risk_category_id, action_description, responsible_user_id, target_date, status_code)
  VALUES (v_assessment4, v_psych_id, 'توفير استبيانات ذاتية التعبئة لضمان راحة الأطفال المشاركين في الدراسة', v_researcher2, '2024-10-20'::date, 'OPEN');

  INSERT INTO safety.mitigation_actions (risk_assessment_id, risk_category_id, action_description, responsible_user_id, target_date, status_code)
  VALUES (v_assessment4, v_phy_id, 'التأكد من توفر غرفة إسعافات أولية أثناء إجراء المقابلات وجمع العينات', v_researcher2, '2024-10-10'::date, 'OPEN');
END $$;

-- ============================================================
-- ADVERSE EVENTS
-- ============================================================
DO $$
DECLARE
  v_app1_id bigint; v_app2_id bigint;
  v_researcher1 bigint; v_researcher2 bigint;
BEGIN
  SELECT id INTO v_researcher1 FROM security.users WHERE username = 'researcher1';
  SELECT id INTO v_researcher2 FROM security.users WHERE username = 'researcher2';
  SELECT id INTO v_app1_id FROM core.applications WHERE application_number = 'APP-2024-001';
  SELECT id INTO v_app2_id FROM core.applications WHERE application_number = 'APP-2024-002';

  -- Adverse events for APP-2024-001 (warfarin study - completed)
  INSERT INTO safety.adverse_events (application_id, event_number, participant_reference, event_date, event_type, severity, expectedness, relatedness, description, outcome_status, reported_by, reported_at)
  VALUES (v_app1_id, 'AE-2024-001', 'PT-001', '2024-05-10'::date, 'HEMORRHAGE', 'MODERATE', 'EXPECTED', 'PROBABLE',
    'تعرض المشارك رقم 001 لنزيف في اللثة بعد أسبوعين من بدء العلاج بالوارفارين. تم تعديل الجرعة وتوقف النزيف بعد 24 ساعة.',
    'RECOVERED', v_researcher1, '2024-05-10 14:30:00+03'::timestamptz);

  INSERT INTO safety.adverse_events (application_id, event_number, participant_reference, event_date, event_type, severity, expectedness, relatedness, description, outcome_status, reported_by, reported_at)
  VALUES (v_app1_id, 'AE-2024-002', 'PT-015', '2024-06-22'::date, 'BRUISING', 'MILD', 'EXPECTED', 'DEFINITE',
    'ظهور كدمات متعددة على جلد المشارك رقم 015 بعد بدء العلاج. تم مراقبة نسبة INR وضبط الجرعة.',
    'RECOVERED', v_researcher1, '2024-06-22 09:15:00+03'::timestamptz);

  INSERT INTO safety.adverse_events (application_id, event_number, participant_reference, event_date, event_type, severity, expectedness, relatedness, description, outcome_status, reported_by, reported_at)
  VALUES (v_app1_id, 'AE-2024-003', 'PT-022', '2024-07-05'::date, 'NAUSEA', 'MILD', 'UNEXPECTED', 'POSSIBLE',
    'شعر المشارك رقم 022 بغثيان خفيف بعد تناول الجرعة اليومية من الوارفارين. لم يتطلب الأمر تدخلاً طبياً.',
    'RECOVERED', v_researcher1, '2024-07-05 11:00:00+03'::timestamptz);

  -- Adverse events for APP-2024-002 (breast cancer study - ongoing)
  INSERT INTO safety.adverse_events (application_id, event_number, participant_reference, event_date, event_type, severity, expectedness, relatedness, description, outcome_status, reported_by, reported_at)
  VALUES (v_app2_id, 'AE-2024-004', 'PT-101', '2024-08-15'::date, 'FATIGUE', 'MODERATE', 'EXPECTED', 'DEFINITE',
    'أبلغت المشاركة رقم 101 عن إرهاق شديد بعد الجرعة الثالثة من العلاج المناعي. تم إعطاء فترة راحة وتقليل الجرعة.',
    'RECOVERING', v_researcher1, '2024-08-15 16:00:00+03'::timestamptz);

  INSERT INTO safety.adverse_events (application_id, event_number, participant_reference, event_date, event_type, severity, expectedness, relatedness, description, outcome_status, reported_by, reported_at)
  VALUES (v_app2_id, 'AE-2024-005', 'PT-108', '2024-09-02'::date, 'RASH', 'MILD', 'EXPECTED', 'DEFINITE',
    'ظهور طفح جلدي من الدرجة الأولى لدى المشاركة رقم 108 بعد الجرعة الأولى. تم علاجه بمضادات الهيستامين وتحسن الطفح.',
    'RECOVERED', v_researcher1, '2024-09-02 10:30:00+03'::timestamptz);

  INSERT INTO safety.adverse_events (application_id, event_number, participant_reference, event_date, event_type, severity, expectedness, relatedness, description, outcome_status, reported_by, reported_at)
  VALUES (v_app2_id, 'AE-2024-006', 'PT-115', '2024-10-01'::date, 'COLITIS', 'SEVERE', 'EXPECTED', 'PROBABLE',
    'تم إدخال المشاركة رقم 115 إلى المستشفى بسبب التهاب القولون المرتبط بالعلاج المناعي. تم إعطاء كورتيكوستيرويدات وتحسنت الحالة بعد 5 أيام.',
    'RECOVERING', v_researcher1, '2024-10-01 08:00:00+03'::timestamptz);

  -- Serious adverse event for colitis
  INSERT INTO safety.serious_adverse_events (adverse_event_id, seriousness_reason, hospitalization_required, life_threatening, death_occurred, disability_occurred, reported_to_committee_at)
  SELECT id, 'استدعى التهاب القولون دخول المستشفى لمدة 5 أيام وتطلب علاجاً بالكورتيكوستيرويدات الوريدية', true, false, false, false, '2024-10-01 14:00:00+03'::timestamptz
  FROM safety.adverse_events WHERE event_number = 'AE-2024-006';

  -- Another adverse event - serious
  INSERT INTO safety.adverse_events (application_id, event_number, participant_reference, event_date, event_type, severity, expectedness, relatedness, description, outcome_status, reported_by, reported_at)
  VALUES (v_app2_id, 'AE-2024-007', 'PT-122', '2024-10-10'::date, 'INFUSION_REACTION', 'SEVERE', 'EXPECTED', 'DEFINITE',
    'تعرضت المشاركة رقم 122 لتفاعل تحسسي حاد أثناء الجرعة الرابعة من العلاج المناعي. تم إيقاف التسريب فوراً وإعطاء مضادات الهيستامين والكورتيكوستيرويدات. تحسنت الحالة بعد ساعتين.',
    'RECOVERED', v_researcher1, '2024-10-10 11:45:00+03'::timestamptz);

  INSERT INTO safety.serious_adverse_events (adverse_event_id, seriousness_reason, hospitalization_required, life_threatening, death_occurred, disability_occurred, reported_to_committee_at)
  SELECT id, 'تفاعل تحسسي حاد أثناء التسريب الوريدي استدعى تدخلاً طبياً فورياً', false, true, false, false, '2024-10-10 14:00:00+03'::timestamptz
  FROM safety.adverse_events WHERE event_number = 'AE-2024-007';
END $$;

-- ============================================================
-- SAFETY FOLLOW-UPS
-- ============================================================
DO $$
DECLARE
  v_reviewer1 bigint; v_reviewer2 bigint;
BEGIN
  SELECT id INTO v_reviewer1 FROM security.users WHERE username = 'reviewer1';
  SELECT id INTO v_reviewer2 FROM security.users WHERE username = 'reviewer2';

  -- Follow-up for AE-2024-001 (gingival hemorrhage)
  INSERT INTO safety.safety_followups (adverse_event_id, followup_date, followup_notes, outcome_status, created_by)
  SELECT id, '2024-05-12'::date, 'تم متابعة المشارك رقم 001 بعد تعديل جرعة الوارفارين. تحسنت حالة اللثة وعادت نسبة INR إلى المستوى العلاجي.', 'RESOLVED', v_reviewer1
  FROM safety.adverse_events WHERE event_number = 'AE-2024-001';

  INSERT INTO safety.safety_followups (adverse_event_id, followup_date, followup_notes, outcome_status, created_by)
  SELECT id, '2024-05-19'::date, 'متابعة ثانية: المشارك لا يزال مستقراً ولا توجد علامات نزيف جديدة. يستمر على الجرعة المعدلة.', 'RESOLVED', v_reviewer1
  FROM safety.adverse_events WHERE event_number = 'AE-2024-001';

  -- Follow-up for AE-2024-006 (colitis)
  INSERT INTO safety.safety_followups (adverse_event_id, followup_date, followup_notes, outcome_status, created_by)
  SELECT id, '2024-10-06'::date, 'تم خروج المشاركة رقم 115 من المستشفى بعد تحسن التهاب القولون. ستتم متابعتها أسبوعياً لتقييم الاستجابة.', 'ONGOING', v_reviewer2
  FROM safety.adverse_events WHERE event_number = 'AE-2024-006';

  -- Follow-up for AE-2024-007 (infusion reaction)
  INSERT INTO safety.safety_followups (adverse_event_id, followup_date, followup_notes, outcome_status, created_by)
  SELECT id, '2024-10-11'::date, 'المشاركة رقم 122 بخير ولا توجد أعراض متبقية. تم اتخاذ إجراءات وقائية للجرعات القادمة.', 'RESOLVED', v_reviewer2
  FROM safety.adverse_events WHERE event_number = 'AE-2024-007';
END $$;

-- ============================================================
-- SAFETY REPORTS
-- ============================================================
DO $$
DECLARE
  v_app1_id bigint; v_app2_id bigint;
  v_researcher1 bigint; v_researcher2 bigint;
BEGIN
  SELECT id INTO v_researcher1 FROM security.users WHERE username = 'researcher1';
  SELECT id INTO v_researcher2 FROM security.users WHERE username = 'researcher2';
  SELECT id INTO v_app1_id FROM core.applications WHERE application_number = 'APP-2024-001';
  SELECT id INTO v_app2_id FROM core.applications WHERE application_number = 'APP-2024-002';

  -- DSMB report for APP-2024-001
  INSERT INTO safety.safety_reports (application_id, report_number, report_type, reporting_period_start, reporting_period_end, report_summary, submitted_by, submitted_at)
  VALUES (v_app1_id, 'SR-2024-001', 'DSMB_REPORT', '2024-03-15'::date, '2024-06-15'::date,
    'تقرير سلامة أولي لدراسة الوارفارين: تم تسجيل 3 أحداث سلبية (نزيف لثة خفيف، كدمات، غثيان) وجميعها كانت خفيفة إلى متوسطة وتعافت تماماً. لم يتم تسجيل أي أحداث سلبية خطيرة. نسبة INR ضمن المستوى العلاجي لـ 95% من المشاركين. يوصي الفريق باستمرار الدراسة دون تعديلات.',
    v_researcher1, '2024-06-20 15:00:00+03'::timestamptz);

  -- DSMB report for APP-2024-002 (ongoing)
  INSERT INTO safety.safety_reports (application_id, report_number, report_type, reporting_period_start, reporting_period_end, report_summary, submitted_by, submitted_at)
  VALUES (v_app2_id, 'SR-2024-002', 'DSMB_REPORT', '2024-06-10'::date, '2024-09-10'::date,
    'تقرير سلامة دوري لدراسة سرطان الثدي: تم تسجيل 4 أحداث سلبية منها حالة واحدة خطيرة (التهاب القولون). جميع الحالات تم التعامل معها بشكل مناسب. يوصي الفريق باستمرار الدراسة مع مراقبة مكثفة للآثار الجانبية الهضمية.',
    v_researcher1, '2024-09-15 14:00:00+03'::timestamptz);

  -- Expedited report for SAE
  INSERT INTO safety.safety_reports (application_id, report_number, report_type, reporting_period_start, reporting_period_end, report_summary, submitted_by, submitted_at)
  VALUES (v_app2_id, 'SR-2024-003', 'EXPEDITED', '2024-10-01'::date, '2024-10-01'::date,
    'تقرير مستعجل: تم تسجيل حدث سلبي خطير (تفاعل تحسسي أثناء التسريب) للمشاركة رقم 122. تم إيقاف التسريب فوراً وتقديم العلاج اللازم. تحسنت الحالة بالكامل. يوصى بتعديل بروتوكول المراقبة أثناء التسريب وإضافة مضادات الهيستامين قبل الجرعات القادمة.',
    v_researcher1, '2024-10-10 16:00:00+03'::timestamptz);

  -- Annual safety report for APP-2024-001
  INSERT INTO safety.safety_reports (application_id, report_number, report_type, reporting_period_start, reporting_period_end, report_summary, submitted_by, submitted_at)
  VALUES (v_app1_id, 'SR-2024-004', 'ANNUAL', '2024-03-15'::date, '2024-09-15'::date,
    'تقرير سلامة نصف سنوي: تم إكمال مرحلة جمع البيانات بنجاح. جميع الأحداث السلبية المسجلة كانت متوقعة وتم التعامل معها. لا توجد توصيات بتعديل بروتوكول الدراسة.',
    v_researcher1, '2024-09-20 10:00:00+03'::timestamptz);
END $$;

-- ============================================================
-- SAFETY COMMITTEE REVIEWS
-- ============================================================
INSERT INTO safety.safety_committee_reviews (application_id, committee_id, review_date, review_outcome, recommendations, reviewed_by)
SELECT a.id, c.id, '2024-06-25'::date, 'APPROVED',
  'تراجع اللجنة تقارير السلامة الأولية لدراسة الوارفارين وتوافق على استمرار الدراسة. توصي اللجنة بتقديم تقارير سلامة كل 3 أشهر.',
  u.id
FROM core.applications a, committee.committees c, security.users u
WHERE a.application_number = 'APP-2024-001' AND c.committee_code = 'IRB-KSU-01' AND u.username = 'chairperson';

INSERT INTO safety.safety_committee_reviews (application_id, committee_id, review_date, review_outcome, recommendations, reviewed_by)
SELECT a.id, c.id, '2024-09-20'::date, 'CONDITIONAL',
  'تراجع اللجنة تقرير السلامة الدوري لدراسة سرطان الثدي. الموافقة مشروطة بتعديل بروتوكول مراقبة التفاعلات التحسسية وتقديم خطة واضحة للتعامل مع الحالات الطارئة.',
  u.id
FROM core.applications a, committee.committees c, security.users u
WHERE a.application_number = 'APP-2024-002' AND c.committee_code = 'IRB-KSU-01' AND u.username = 'chairperson';

INSERT INTO safety.safety_committee_reviews (application_id, committee_id, review_date, review_outcome, recommendations, reviewed_by)
SELECT a.id, c.id, '2024-10-11'::date, 'REQUIRES_ACTION',
  'مراجعة عاجلة للحدث السلبي الخطير (تفاعل تحسسي). تطلب اللجنة تقديم تقرير مفصل عن الإجراءات التصحيحية خلال 7 أيام.',
  u.id
FROM core.applications a, committee.committees c, security.users u
WHERE a.application_number = 'APP-2024-002' AND c.committee_code = 'IRB-KSU-01' AND u.username = 'ethics_admin';

COMMIT;
