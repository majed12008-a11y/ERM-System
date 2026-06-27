-- ============================================================
-- 18-MONITORING DATA: monitoring_plans, visits, findings,
--    corrective_actions, preventive_actions, compliance_reviews,
--    deviations, protocol_violations, inspections, reports
-- ============================================================

BEGIN;

-- ============================================================
-- MONITORING PLANS
-- ============================================================
DO $$
DECLARE
  v_app1_id bigint; v_app2_id bigint; v_app5_id bigint;
  v_admin bigint; v_reviewer1 bigint; v_reviewer2 bigint;
BEGIN
  SELECT id INTO v_admin FROM security.users WHERE username = 'ethics_admin';
  SELECT id INTO v_reviewer1 FROM security.users WHERE username = 'reviewer1';
  SELECT id INTO v_reviewer2 FROM security.users WHERE username = 'reviewer2';
  SELECT id INTO v_app1_id FROM core.applications WHERE application_number = 'APP-2024-001';
  SELECT id INTO v_app2_id FROM core.applications WHERE application_number = 'APP-2024-002';
  SELECT id INTO v_app5_id FROM core.applications WHERE application_number = 'APP-2024-005';

  -- Plan for APP-2024-001 (completed study)
  INSERT INTO monitoring.monitoring_plans (application_id, plan_code, monitoring_type, frequency_type, planned_start_date, planned_end_date, status_code, created_by)
  VALUES (v_app1_id, 'MP-2024-001', 'ON_SITE', 'QUARTERLY', '2024-04-01'::date, '2025-06-30'::date, 'ACTIVE', v_admin);

  -- Plan for APP-2024-002 (ongoing)
  INSERT INTO monitoring.monitoring_plans (application_id, plan_code, monitoring_type, frequency_type, planned_start_date, planned_end_date, status_code, created_by)
  VALUES (v_app2_id, 'MP-2024-002', 'ON_SITE', 'MONTHLY', '2024-07-01'::date, '2026-12-31'::date, 'ACTIVE', v_admin);

  -- Plan for APP-2024-005 (submitted - pending)
  INSERT INTO monitoring.monitoring_plans (application_id, plan_code, monitoring_type, frequency_type, planned_start_date, planned_end_date, status_code, created_by)
  VALUES (v_app5_id, 'MP-2024-003', 'DESKTOP', 'ANNUAL', '2024-11-01'::date, '2025-12-31'::date, 'PENDING', v_admin);

  -- ============================================================
  -- MONITORING VISITS
  -- ============================================================

  -- Visit 1 for Plan 1
  INSERT INTO monitoring.monitoring_visits (monitoring_plan_id, visit_date, monitor_id, visit_status, observations)
  SELECT id, '2024-07-15'::date, v_reviewer1, 'COMPLETED',
    'زيارة ميدانية أولى لدراسة الوارفارين. تم مراجعة ملفات المرضى والتأكد من تطبيق بروتوكول الدراسة. جميع الإجراءات مطابقة للمعايير. لوحظ تأخر بسيط في تحديث بعض السجلات.'
  FROM monitoring.monitoring_plans WHERE plan_code = 'MP-2024-001';

  -- Visit 2 for Plan 1
  INSERT INTO monitoring.monitoring_visits (monitoring_plan_id, visit_date, monitor_id, visit_status, observations)
  SELECT id, '2024-10-20'::date, v_reviewer2, 'COMPLETED',
    'زيارة ميدانية ثانية: تم مراجعة 50 ملف مريض. جميع نماذج الموافقة المستنيرة موقعة ومؤرخة بشكل صحيح. تم التأكد من توثيق الأحداث السلبية بشكل مناسب.'
  FROM monitoring.monitoring_plans WHERE plan_code = 'MP-2024-001';

  -- Visit 1 for Plan 2
  INSERT INTO monitoring.monitoring_visits (monitoring_plan_id, visit_date, monitor_id, visit_status, observations)
  SELECT id, '2024-08-01'::date, v_reviewer1, 'COMPLETED',
    'زيارة افتتاحية لدراسة سرطان الثدي. تم مراجعة البنية التحتية للمركز ومدى جاهزية فريق البحث. جميع التجهيزات مطابقة للمتطلبات.'
  FROM monitoring.monitoring_plans WHERE plan_code = 'MP-2024-002';

  -- Visit 2 for Plan 2
  INSERT INTO monitoring.monitoring_visits (monitoring_plan_id, visit_date, monitor_id, visit_status, observations)
  SELECT id, '2024-09-05'::date, v_reviewer2, 'COMPLETED',
    'زيارة متابعة: تم مراجعة أول 20 مريضة مسجلة في الدراسة. جميع معايير الاشتمال مطبقة بشكل صحيح. لوحظ نقص في توثيق بعض البيانات الديموغرافية.'
  FROM monitoring.monitoring_plans WHERE plan_code = 'MP-2024-002';

  -- Visit 3 for Plan 2 (after SAE)
  INSERT INTO monitoring.monitoring_visits (monitoring_plan_id, visit_date, monitor_id, visit_status, observations)
  SELECT id, '2024-10-15'::date, v_reviewer1, 'COMPLETED',
    'زيارة استثنائية بعد تسجيل حدث سلبي خطير. تم مراجعة الإجراءات المتبعة والتأكد من تطبيق بروتوكول السلامة. تم تقديم توصيات بتحسين المراقبة أثناء التسريب.'
  FROM monitoring.monitoring_plans WHERE plan_code = 'MP-2024-002';

  -- ============================================================
  -- MONITORING FINDINGS
  -- ============================================================

  -- Finding from Visit 1, Plan 1
  INSERT INTO monitoring.monitoring_findings (monitoring_visit_id, finding_type, severity, description, recommendation)
  SELECT mv.id, 'MINOR', 'LOW',
    'تأخر في تحديث السجلات الطبية لبعض المرضى (3 ملفات)',
    'ضرورة تحديث السجلات خلال 24 ساعة من المتابعة'
  FROM monitoring.monitoring_visits mv
  WHERE mv.monitor_id = (SELECT id FROM security.users WHERE username = 'reviewer1')
    AND mv.observations LIKE 'زيارة ميدانية أولى%';

  -- Finding from Visit 2, Plan 1
  INSERT INTO monitoring.monitoring_findings (monitoring_visit_id, finding_type, severity, description, recommendation)
  SELECT mv.id, 'OBSERVATION', 'LOW',
    'جميع الإجراءات مطابقة للمعايير ولم يتم تسجيل أي مخالفات جوهرية',
    'الاستمرار على نفس المستوى من الالتزام'
  FROM monitoring.monitoring_visits mv
  WHERE mv.monitor_id = (SELECT id FROM security.users WHERE username = 'reviewer2')
    AND mv.observations LIKE 'زيارة ميدانية ثانية%';

  -- Finding from Visit 2, Plan 2
  INSERT INTO monitoring.monitoring_findings (monitoring_visit_id, finding_type, severity, description, recommendation)
  SELECT mv.id, 'MAJOR', 'MEDIUM',
    'نقص في توثيق البيانات الديموغرافية لبعض المريضات (5 حالات)',
    'إكمال البيانات الناقصة خلال أسبوع وتدريب فريق البحث على أهمية التوثيق الكامل'
  FROM monitoring.monitoring_visits mv
  WHERE mv.monitor_id = (SELECT id FROM security.users WHERE username = 'reviewer2')
    AND mv.observations LIKE 'زيارة متابعة%';

  -- Finding from Visit 3, Plan 2
  INSERT INTO monitoring.monitoring_findings (monitoring_visit_id, finding_type, severity, description, recommendation)
  SELECT mv.id, 'CRITICAL', 'HIGH',
    'عدم وجود بروتوكول مكتوب للتعامل مع تفاعلات التسريب التحسسية',
    'وضع بروتوكول مكتوب لإدارة تفاعلات التسريب وتدريب فريق التمريض عليه قبل الجرعات القادمة'
  FROM monitoring.monitoring_visits mv
  WHERE mv.monitor_id = (SELECT id FROM security.users WHERE username = 'reviewer1')
    AND mv.observations LIKE 'زيارة استثنائية%';

  -- ============================================================
  -- CORRECTIVE ACTIONS
  -- ============================================================

  -- Corrective action for the major finding (missing demographic data)
  INSERT INTO monitoring.corrective_actions (finding_id, action_description, responsible_user_id, target_completion_date, status_code)
  SELECT mf.id, 'إكمال البيانات الديموغرافية الناقصة لخمس مريضات من خلال مراجعة الملفات الأصلية والتواصل مع المريضات عند الضرورة',
    v_reviewer1, '2024-09-12'::date, 'COMPLETED'
  FROM monitoring.monitoring_findings mf
  WHERE mf.finding_type = 'MAJOR' AND mf.severity = 'MEDIUM';

  -- Corrective action for the critical finding (infusion protocol)
  INSERT INTO monitoring.corrective_actions (finding_id, action_description, responsible_user_id, target_completion_date, status_code)
  SELECT mf.id, 'تطوير بروتوكول مكتوب لإدارة تفاعلات التسريب التحسسية يشمل: الأدوية المطلوبة، الجرعات، إجراءات الطوارئ، ومتابعة ما بعد التفاعل',
    v_reviewer2, '2024-10-22'::date, 'IN_PROGRESS'
  FROM monitoring.monitoring_findings mf
  WHERE mf.finding_type = 'CRITICAL' AND mf.severity = 'HIGH';

  -- Corrective action for the minor finding
  INSERT INTO monitoring.corrective_actions (finding_id, action_description, responsible_user_id, target_completion_date, status_code)
  SELECT mf.id, 'تحديث السجلات الطبية الثلاثة المتأخرة وتدريب الموظفين على أهمية التحديث الفوري',
    v_admin, '2024-07-18'::date, 'COMPLETED'
  FROM monitoring.monitoring_findings mf
  WHERE mf.finding_type = 'MINOR' AND mf.severity = 'LOW';

  -- ============================================================
  -- PREVENTIVE ACTIONS
  -- ============================================================

  -- Preventive action for the major finding
  INSERT INTO monitoring.preventive_actions (finding_id, action_description, responsible_user_id, target_completion_date, status_code)
  SELECT mf.id, 'تنظيم ورشة تدريبية لفريق البحث حول أهمية توثيق البيانات وأفضل الممارسات في إدارة البيانات السريرية',
    v_admin, '2024-09-30'::date, 'COMPLETED'
  FROM monitoring.monitoring_findings mf
  WHERE mf.finding_type = 'MAJOR' AND mf.severity = 'MEDIUM';

  -- Preventive action for the critical finding
  INSERT INTO monitoring.preventive_actions (finding_id, action_description, responsible_user_id, target_completion_date, status_code)
  SELECT mf.id, 'توفير مخزون كافٍ من أدوية الطوارئ (مضادات الهيستامين، الكورتيكوستيرويدات، الإبينيفرين) في وحدة التسريب',
    v_admin, '2024-10-30'::date, 'OPEN'
  FROM monitoring.monitoring_findings mf
  WHERE mf.finding_type = 'CRITICAL' AND mf.severity = 'HIGH';

  INSERT INTO monitoring.preventive_actions (finding_id, action_description, responsible_user_id, target_completion_date, status_code)
  SELECT mf.id, 'إعداد قائمة تدقيق (Checklist) للإجراءات الواجب اتباعها قبل وأثناء وبعد كل جلسة تسريب علاج مناعي',
    v_reviewer1, '2024-10-30'::date, 'IN_PROGRESS'
  FROM monitoring.monitoring_findings mf
  WHERE mf.finding_type = 'CRITICAL' AND mf.severity = 'HIGH';

END $$;

-- ============================================================
-- COMPLIANCE REVIEWS
-- ============================================================
DO $$
DECLARE
  v_app1_id bigint; v_app2_id bigint;
  v_chairperson bigint; v_reviewer2 bigint;
BEGIN
  SELECT id INTO v_chairperson FROM security.users WHERE username = 'chairperson';
  SELECT id INTO v_reviewer2 FROM security.users WHERE username = 'reviewer2';
  SELECT id INTO v_app1_id FROM core.applications WHERE application_number = 'APP-2024-001';
  SELECT id INTO v_app2_id FROM core.applications WHERE application_number = 'APP-2024-002';

  INSERT INTO monitoring.compliance_reviews (application_id, reviewer_id, review_date, compliance_score, summary, status_code)
  VALUES (v_app1_id, v_chairperson, '2024-08-01'::date, 95.00,
    'مراجعة الامتثال لدراسة الوارفارين: التزام ممتاز ببروتوكول الدراسة والمعايير الأخلاقية. جميع نماذج الموافقة المستنيرة موثقة بشكل صحيح. السجلات منظمة وكاملة.',
    'COMPLIANT');

  INSERT INTO monitoring.compliance_reviews (application_id, reviewer_id, review_date, compliance_score, summary, status_code)
  VALUES (v_app2_id, v_reviewer2, '2024-09-15'::date, 82.50,
    'مراجعة الامتثال لدراسة سرطان الثدي: التزام جيد بشكل عام ولكن توجد بعض الثغرات في توثيق البيانات الديموغرافية. تم اتخاذ إجراءات تصحيحية.',
    'PARTIALLY_COMPLIANT');

  INSERT INTO monitoring.compliance_reviews (application_id, reviewer_id, review_date, compliance_score, summary, status_code)
  VALUES (v_app1_id, v_reviewer2, '2024-10-01'::date, 97.50,
    'مراجعة امتثال ثانية: تحسن ملحوظ في الالتزام بالبروتوكول. جميع التوصيات السابقة تم تطبيقها.',
    'COMPLIANT');
END $$;

-- ============================================================
-- DEVIATIONS
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

  INSERT INTO monitoring.deviations (application_id, deviation_code, deviation_date, deviation_type, description, reported_by, reported_at)
  VALUES (v_app1_id, 'DEV-2024-001', '2024-05-25'::date, 'MINOR',
    'تم إجراء قياس INR بعد مرور 8 أيام بدلاً من 7 أيام كما هو محدد في البروتوكول لمشارك واحد. تم توثيق الانحراف واتخاذ الإجراء التصحيحي.',
    v_researcher1, '2024-05-25 10:00:00+03'::timestamptz);

  INSERT INTO monitoring.deviations (application_id, deviation_code, deviation_date, deviation_type, description, reported_by, reported_at)
  VALUES (v_app2_id, 'DEV-2024-002', '2024-08-30'::date, 'MINOR',
    'تم إعطاء الجرعة الثانية من العلاج المناعي للمشاركة رقم 105 بعد 23 يوماً بدلاً من 21 يوماً بسبب ظروف صحية طارئة للمريضة. تم توثيق الانحراف.',
    v_researcher1, '2024-08-30 14:30:00+03'::timestamptz);
END $$;

-- ============================================================
-- PROTOCOL VIOLATIONS
-- ============================================================
DO $$
DECLARE
  v_app2_id bigint;
  v_researcher1 bigint;
BEGIN
  SELECT id INTO v_researcher1 FROM security.users WHERE username = 'researcher1';
  SELECT id INTO v_app2_id FROM core.applications WHERE application_number = 'APP-2024-002';

  INSERT INTO monitoring.protocol_violations (application_id, violation_date, severity, description, corrective_action_required, status_code, created_by)
  VALUES (v_app2_id, '2024-09-20'::date, 'MAJOR',
    'تم تضمين مريضة رقم 118 في الدراسة رغم استيفائها لمعيار استبعاد (ارتفاع إنزيمات الكبد > 3 أضعاف الحد الأعلى الطبيعي). تم إيقافها فور اكتشاف المخالفة. الإجراء التصحيحي: تم إيقاف المريضة عن العلاج وإحالتها لطبيب الكبد. سيتم تدريب فريق البحث على مراجعة معايير الاستبعاد بدقة قبل التسجيل.',
    true, 'CLOSED', v_researcher1);
END $$;

-- ============================================================
-- INSPECTIONS & INSPECTION REPORTS
-- ============================================================
DO $$
DECLARE
  v_app1_id bigint; v_app2_id bigint;
  v_admin bigint; v_chairperson bigint;
  v_insp1_id bigint; v_insp2_id bigint;
BEGIN
  SELECT id INTO v_admin FROM security.users WHERE username = 'ethics_admin';
  SELECT id INTO v_chairperson FROM security.users WHERE username = 'chairperson';
  SELECT id INTO v_app1_id FROM core.applications WHERE application_number = 'APP-2024-001';
  SELECT id INTO v_app2_id FROM core.applications WHERE application_number = 'APP-2024-002';

  -- Inspection 1
  INSERT INTO monitoring.inspections (application_id, inspection_type, inspection_date, inspector_id, status_code, summary)
  VALUES (v_app1_id, 'ROUTINE', '2024-08-15'::date, v_chairperson, 'COMPLETED',
    'تفتيش روتيني لدراسة الوارفارين: تم مراجعة جميع الوثائق والسجلات. النتائج إيجابية بشكل عام.');
  SELECT currval(pg_get_serial_sequence('monitoring.inspections', 'id')) INTO v_insp1_id;

  INSERT INTO monitoring.inspection_reports (inspection_id, report_number, findings_summary, recommendations, submitted_at, approved_at)
  VALUES (v_insp1_id, 'INSP-RPT-2024-001',
    'نتائج التفتيش الروتيني: الالتزام العام جيد. لوحظ وجود بعض السجلات غير المكتملة (تم تصحيحها). جميع نماذج الموافقة المستنيرة سليمة.',
    '1. الاستمرار في تطبيق معايير الجودة الحالية
2. تحسين نظام التذكير لتحديث السجلات في الوقت المحدد
3. إجراء تدريب دوري لفريق البحث',
    '2024-08-18 15:00:00+03'::timestamptz, '2024-08-20 10:00:00+03'::timestamptz);

  -- Inspection 2
  INSERT INTO monitoring.inspections (application_id, inspection_type, inspection_date, inspector_id, status_code, summary)
  VALUES (v_app2_id, 'FOR_CAUSE', '2024-10-12'::date, v_admin, 'COMPLETED',
    'تفتيش لسبب بعد تسجيل حدث سلبي خطير. تم التحقيق في ملابسات الحدث والإجراءات المتخذة.');
  SELECT currval(pg_get_serial_sequence('monitoring.inspections', 'id')) INTO v_insp2_id;

  INSERT INTO monitoring.inspection_reports (inspection_id, report_number, findings_summary, recommendations, submitted_at, approved_at)
  VALUES (v_insp2_id, 'INSP-RPT-2024-002',
    'تقرير تفتيش دراسة سرطان الثدي بعد الحادث السلبي الخطير: تم التحقق من تسلسل الأحداث. فريق التمريض تصرف بشكل مناسب. لكن لا يوجد بروتوكول مكتوب للتعامل مع تفاعلات التسريب.',
    '1. وضع بروتوكول مكتوب لإدارة تفاعلات التسريب فوراً
2. تدريب جميع طاقم التمريض على البروتوكول الجديد
3. توفير أدوية الطوارئ في وحدة التسريب بشكل دائم
4. تقديم تقرير عن الإجراءات التصحيحية خلال 14 يوماً',
    '2024-10-14 16:00:00+03'::timestamptz, NULL);
END $$;

COMMIT;
