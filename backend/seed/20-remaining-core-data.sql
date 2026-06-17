-- ============================================================
-- 20-REMAINING CORE DATA: project_team_members, funding, keywords,
--    sites, tags, quorum_logs, review_conflicts, review_scores,
--    agenda_items, document_versions, templates, user_profiles,
--    access_policies, notification_statuses, status_types,
--    workflow_sla, workflow_variables, amendments, closure,
--    renewal, dashboard_widgets, report_definitions
-- ============================================================

BEGIN;

-- ============================================================
-- PROJECT TEAM MEMBERS
-- ============================================================
INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
SELECT p.id, u.id, 'باحث رئيسي', true
FROM core.projects p, security.users u
WHERE p.project_code = 'KSU-RES-2024-001' AND u.username = 'researcher1';

INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
SELECT p.id, u.id, 'باحث مساعد', true
FROM core.projects p, security.users u
WHERE p.project_code = 'KSU-RES-2024-001' AND u.username = 'researcher2';

INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
SELECT p.id, u.id, 'محلل بيانات', true
FROM core.projects p, security.users u
WHERE p.project_code = 'KSU-RES-2024-001' AND u.username = 'reviewer1';

INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
SELECT p.id, u.id, 'باحث رئيسي', true
FROM core.projects p, security.users u
WHERE p.project_code = 'KSU-RES-2024-002' AND u.username = 'researcher1';

INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
SELECT p.id, u.id, 'باحث مساعد', true
FROM core.projects p, security.users u
WHERE p.project_code = 'KSU-RES-2024-002' AND u.username = 'researcher2';

INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
SELECT p.id, u.id, 'منسق الدراسة', true
FROM core.projects p, security.users u
WHERE p.project_code = 'KSU-RES-2024-002' AND u.username = 'reviewer3';

INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
SELECT p.id, u.id, 'باحث رئيسي', true
FROM core.projects p, security.users u
WHERE p.project_code = 'KSU-RES-2024-003' AND u.username = 'researcher2';

INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
SELECT p.id, u.id, 'مشرف أكاديمي', true
FROM core.projects p, security.users u
WHERE p.project_code = 'KSU-RES-2024-003' AND u.username = 'reviewer2';

-- ============================================================
-- PROJECT FUNDING SOURCES
-- ============================================================
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference)
SELECT p.id, 'مدينة الملك عبدالعزيز للعلوم والتقنية (KACST)', 'GOVERNMENT', 950000.00, 'SAR', 'KACST-BIO-2024-015'
FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-001';

INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference)
SELECT p.id, 'جامعة الملك سعود - عمادة البحث العلمي', 'INSTITUTIONAL', 150000.00, 'SAR', 'KSU-DSR-2024-089'
FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-001';

INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference)
SELECT p.id, 'الصندوق السعودي للتنمية الصحية', 'GOVERNMENT', 2200000.00, 'SAR', 'SFHD-ONC-2024-042'
FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-002';

INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference)
SELECT p.id, 'منحة بحثية - برنامج خادم الحرمين الشريفين للابتعاث', 'GOVERNMENT', 180000.00, 'SAR', 'KSB-2024-007'
FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-003';

-- ============================================================
-- PROJECT KEYWORDS
-- ============================================================
INSERT INTO core.project_keywords (project_id, keyword)
SELECT p.id, 'وارفارين' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-001'
UNION ALL SELECT p.id, 'علم الوراثة الدوائي' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-001'
UNION ALL SELECT p.id, 'CYP2C9' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-001'
UNION ALL SELECT p.id, 'VKORC1' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-001'
UNION ALL SELECT p.id, 'الجرعة المثلى' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-001'
UNION ALL SELECT p.id, 'الطب الدقيق' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-001';

INSERT INTO core.project_keywords (project_id, keyword)
SELECT p.id, 'سرطان الثدي' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-002'
UNION ALL SELECT p.id, 'العلاج المناعي' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-002'
UNION ALL SELECT p.id, 'مثبطات نقاط التفتيش' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-002'
UNION ALL SELECT p.id, 'PD-1' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-002'
UNION ALL SELECT p.id, 'العلوم السريرية' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-002'
UNION ALL SELECT p.id, 'الأورام' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-002';

INSERT INTO core.project_keywords (project_id, keyword)
SELECT p.id, 'الميكروبيوم' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-003'
UNION ALL SELECT p.id, 'السمنة' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-003'
UNION ALL SELECT p.id, 'الأطفال' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-003'
UNION ALL SELECT p.id, 'البكتيريا المعوية' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-003'
UNION ALL SELECT p.id, 'السعودية' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-003';

-- ============================================================
-- PROJECT TAGS
-- ============================================================
INSERT INTO core.project_tags (project_id, tag_name)
SELECT p.id, 'جينوم' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-001'
UNION ALL SELECT p.id, 'مستشفى جامعي' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-001'
UNION ALL SELECT p.id, 'تجربة سريرية' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-002'
UNION ALL SELECT p.id, 'تمويل حكومي' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-002'
UNION ALL SELECT p.id, 'وبائيات' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-003'
UNION ALL SELECT p.id, 'طب وقائي' FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-003';

-- ============================================================
-- PROJECT SITES
-- ============================================================
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants)
SELECT p.id, 'مستشفى الملك خالد الجامعي - الرياض', 'الرياض', 'جامعة الملك سعود - حي الدرعية - الرياض', 300
FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-001';

INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants)
SELECT p.id, 'مستشفى الملك فيصل التخصصي - الرياض', 'الرياض', 'طريق الملك فيصل - حي المعذر - الرياض', 200
FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-001';

INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants)
SELECT p.id, 'مركز الأورام - مستشفى الملك خالد الجامعي', 'الرياض', 'جامعة الملك سعود - حي الدرعية - الرياض', 200
FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-002';

INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants)
SELECT p.id, 'مستشفى الملك عبدالعزيز الجامعي - جدة', 'مكة المكرمة', 'شارع الملك عبدالعزيز - حي الجامعة - جدة', 100
FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-002';

INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants)
SELECT p.id, 'مدرسة الأندلس الابتدائية - الرياض', 'الرياض', 'حي السفارات - الرياض', 100
FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-003';

INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants)
SELECT p.id, 'مدرسة النموذجية - الرياض', 'الرياض', 'حي العليا - الرياض', 100
FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-003';

-- ============================================================
-- PROJECT SITE INVESTIGATORS
-- ============================================================
INSERT INTO core.project_site_investigators (site_id, investigator_id, is_site_lead)
SELECT s.id, u.id, true
FROM core.project_sites s, security.users u
WHERE s.site_name = 'مستشفى الملك خالد الجامعي - الرياض' AND u.username = 'researcher1';

INSERT INTO core.project_site_investigators (site_id, investigator_id, is_site_lead)
SELECT s.id, u.id, true
FROM core.project_sites s, security.users u
WHERE s.site_name = 'مستشفى الملك فيصل التخصصي - الرياض' AND u.username = 'reviewer2';

INSERT INTO core.project_site_investigators (site_id, investigator_id, is_site_lead)
SELECT s.id, u.id, true
FROM core.project_sites s, security.users u
WHERE s.site_name = 'مركز الأورام - مستشفى الملك خالد الجامعي' AND u.username = 'researcher1';

INSERT INTO core.project_site_investigators (site_id, investigator_id, is_site_lead)
SELECT s.id, u.id, false
FROM core.project_sites s, security.users u
WHERE s.site_name = 'مستشفى الملك عبدالعزيز الجامعي - جدة' AND u.username = 'reviewer3';

-- ============================================================
-- QUORUM LOGS (for completed meetings)
-- ============================================================
INSERT INTO committee.quorum_logs (meeting_id, total_members, present_members, quorum_required, quorum_achieved)
SELECT m.id, 5, 4, 3, true
FROM committee.committee_meetings m WHERE m.meeting_number = 'IRB-MTG-2024-001';

INSERT INTO committee.quorum_logs (meeting_id, total_members, present_members, quorum_required, quorum_achieved)
SELECT m.id, 5, 3, 3, true
FROM committee.committee_meetings m WHERE m.meeting_number = 'IRB-MTG-2024-003';

-- ============================================================
-- REVIEW CONFLICTS
-- ============================================================
INSERT INTO committee.review_conflicts (application_id, reviewer_id, conflict_type, description, approved_by)
SELECT a.id, u.id, 'INSTITUTIONAL', 'للمراجع علاقة تعاون سابقة مع الباحث الرئيسي في مشروع بحثي آخر',
  (SELECT id FROM security.users WHERE username = 'ethics_admin')
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-001' AND u.username = 'reviewer3';

INSERT INTO committee.review_conflicts (application_id, reviewer_id, conflict_type, description, approved_by)
SELECT a.id, u.id, 'FINANCIAL', 'يتلقى المراجع تمويلاً بحثياً من نفس مصدر تمويل الدراسة',
  (SELECT id FROM security.users WHERE username = 'ethics_admin')
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-002' AND u.username = 'reviewer2';

-- ============================================================
-- REVIEW SCORES
-- ============================================================
INSERT INTO committee.review_scores (application_id, reviewer_id, review_type, score)
SELECT a.id, u.id, 'SCIENTIFIC', 92.00
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-001' AND u.username = 'reviewer1';

INSERT INTO committee.review_scores (application_id, reviewer_id, review_type, score)
SELECT a.id, u.id, 'ETHICAL', 88.50
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-001' AND u.username = 'reviewer2';

INSERT INTO committee.review_scores (application_id, reviewer_id, review_type, score)
SELECT a.id, u.id, 'SCIENTIFIC', 78.00
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-002' AND u.username = 'reviewer1';

INSERT INTO committee.review_scores (application_id, reviewer_id, review_type, score)
SELECT a.id, u.id, 'ETHICAL', 85.00
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-002' AND u.username = 'reviewer2';

INSERT INTO committee.review_scores (application_id, reviewer_id, review_type, score)
SELECT a.id, u.id, 'SCIENTIFIC', 70.50
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-003' AND u.username = 'reviewer1';

-- ============================================================
-- AGENDA ITEMS (detail for meeting agendas)
-- ============================================================
INSERT INTO committee.agenda_items (agenda_id, application_id, item_order, title, discussion_notes)
SELECT ma.id, a.id, 1,
  'عرض ومناقشة طلب APP-2024-001 - دراسة الوارفارين',
  'قدم الباحث الرئيسي عرضاً لنتائج الدراسة الأولية. تمت مناقشة الجوانب العلمية والأخلاقية. أوصت اللجنة بالموافقة.'
FROM committee.meeting_agendas ma, core.applications a
WHERE ma.title LIKE '%APP-2024-001%' AND a.application_number = 'APP-2024-001'
UNION ALL
SELECT ma.id, NULL, 2,
  'اعتماد محضر الاجتماع السابق',
  'تمت مراجعة محضر الاجتماع السابق واعتماده بالإجماع.'
FROM committee.meeting_agendas ma
WHERE ma.title LIKE '%محاضر الاجتماع السابق%'
UNION ALL
SELECT ma.id, a.id, 1,
  'مناقشة طلب APP-2024-002 - علاج سرطان الثدي',
  'تم عرض نتائج المراجعة العلمية والأخلاقية للطلب. اللجنة تدرس التوصيات.'
FROM committee.meeting_agendas ma, core.applications a
WHERE ma.title LIKE '%APP-2024-002%' AND a.application_number = 'APP-2024-002'
  AND ma.id = (SELECT id FROM committee.meeting_agendas WHERE title LIKE '%APP-2024-002%' AND title NOT LIKE '%تعديل%' LIMIT 1)
UNION ALL
SELECT ma.id, a.id, 2,
  'مناقشة طلب APP-2024-003 - التعديل على دراسة سرطان الثدي',
  'تم شرح أسباب التعديل المطلوب والذراع العلاجي الجديد.'
FROM committee.meeting_agendas ma, core.applications a
WHERE ma.title LIKE '%APP-2024-003%' AND a.application_number = 'APP-2024-003';

-- ============================================================
-- APPLICATION AMENDMENTS
-- ============================================================
INSERT INTO core.application_amendments (application_id, amendment_number, amendment_reason, amendment_description, submitted_by, submitted_at, status_code)
SELECT a.id, 'AMD-2024-001', 'طلب تعديل بروتوكول العلاج',
  'إضافة ذراع علاجي جديد (مثبط PD-1 + علاج كيميائي) وتعديل معايير الاشتمال لتشمل مريضات أكبر من 60 عاماً.',
  u.id, '2024-08-20 14:00:00+03'::timestamptz, 'SUBMITTED'
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-002' AND u.username = 'researcher1';

INSERT INTO core.amendment_requests (amendment_id, request_date, request_status, decision_date, comments)
SELECT aa.id, '2024-08-25 10:00:00+03'::timestamptz, 'UNDER_REVIEW', NULL,
  'الطلب قيد المراجعة من قبل اللجنة. سيتم البت فيه في الاجتماع القادم.'
FROM core.application_amendments aa WHERE aa.amendment_number = 'AMD-2024-001';

INSERT INTO core.application_amendments (application_id, amendment_number, amendment_reason, amendment_description, submitted_by, submitted_at, status_code)
SELECT a.id, 'AMD-2024-002', 'طلب تمديد فترة جمع البيانات',
  'نظراً لتأخر تسجيل المرضى، يطلب الباحث تمديد فترة جمع البيانات 3 أشهر إضافية حتى 30 سبتمبر 2025.',
  u.id, '2024-10-01 09:00:00+03'::timestamptz, 'DRAFT'
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-001' AND u.username = 'researcher1';

-- ============================================================
-- CLOSURE REQUESTS
-- ============================================================
INSERT INTO core.closure_requests (application_id, closure_reason, closure_summary, submitted_at, status_code)
SELECT a.id,
  'اكتمال جمع البيانات وتحليلها',
  'تم الانتهاء من جمع بيانات 500 مريض وتحليل النتائج. تم نشر ورقتين علميتين في مجلات محكمة. تم تطوير نموذج جرعات الوارفارين للسعوديين.',
  '2024-09-30 15:00:00+03'::timestamptz, 'SUBMITTED'
FROM core.applications a WHERE a.application_number = 'APP-2024-001';

-- ============================================================
-- RENEWAL REQUESTS
-- ============================================================
INSERT INTO core.renewal_requests (application_id, renewal_period_months, justification, submitted_at, status_code)
SELECT a.id, 12,
  'نظراً للحاجة لمتابعة المريضات لمدة 12 شهراً إضافية لتقييم البقاء طويل الأمد والآثار الجانبية المتأخرة للعلاج المناعي.',
  '2024-10-01 11:00:00+03'::timestamptz, 'DRAFT'
FROM core.applications a WHERE a.application_number = 'APP-2024-002';

-- ============================================================
-- REFERENCE: notification_statuses, status_types
-- ============================================================
INSERT INTO reference.notification_statuses (status_code, status_name) VALUES
  ('PENDING', 'قيد الانتظار'),
  ('SENT', 'تم الإرسال'),
  ('DELIVERED', 'تم التسليم'),
  ('FAILED', 'فشل الإرسال'),
  ('READ', 'تم القراءة'),
  ('CANCELLED', 'ملغي'),
  ('SCHEDULED', 'مجدول');

INSERT INTO reference.status_types (status_type_code, status_type_name, description) VALUES
  ('APPLICATION_STATUS', 'حالة الطلب', 'حالات طلبات المراجعة الأخلاقية'),
  ('PROJECT_STATUS', 'حالة المشروع', 'حالات المشاريع البحثية'),
  ('REVIEW_STATUS', 'حالة المراجعة', 'حالات المراجعة العلمية والأخلاقية'),
  ('MEETING_STATUS', 'حالة الاجتماع', 'حالات اجتماعات اللجنة'),
  ('DOCUMENT_STATUS', 'حالة المستند', 'حالات المستندات');

-- ============================================================
-- USER PROFILES
-- ============================================================
INSERT INTO security.user_profiles (user_id, national_id, gender, date_of_birth, nationality_code, academic_title, specialization, biography)
SELECT u.id, '1012345678', 'ذكر', '1980-05-15'::date, 'SA', 'أستاذ دكتور', 'الصيدلة السريرية',
  'أستاذ الصيدلة السريرية بجامعة الملك سعود. له أكثر من 25 بحثاً منشوراً في مجال علم الوراثة الدوائي.'
FROM security.users u WHERE u.username = 'researcher1';

INSERT INTO security.user_profiles (user_id, national_id, gender, date_of_birth, nationality_code, academic_title, specialization, biography)
SELECT u.id, '1023456789', 'أنثى', '1985-11-20'::date, 'SA', 'دكتورة', 'طب الأسنان',
  'أستاذ مساعد في طب الأسنان بجامعة الملك سعود. مهتمة بأبحاث الميكروبيوم الفموي.'
FROM security.users u WHERE u.username = 'researcher2';

INSERT INTO security.user_profiles (user_id, national_id, gender, date_of_birth, nationality_code, academic_title, specialization, biography)
SELECT u.id, '1034567890', 'ذكر', '1975-03-10'::date, 'SA', 'أستاذ دكتور', 'الطب الباطني',
  'أستاذ الطب الباطني ورئيس اللجنة المؤسسية لمراجعة الأخلاقيات. خبرة 20 عاماً في المجال.'
FROM security.users u WHERE u.username = 'chairperson';

INSERT INTO security.user_profiles (user_id, national_id, gender, date_of_birth, nationality_code, academic_title, specialization, biography)
SELECT u.id, '1045678901', 'ذكر', '1982-07-22'::date, 'SA', 'أستاذ مشارك', 'علم الأدوية',
  'أستاذ مشارك في علم الأدوية. مراجع علمي معتمد في العديد من المجلات العلمية.'
FROM security.users u WHERE u.username = 'reviewer1';

INSERT INTO security.user_profiles (user_id, national_id, gender, date_of_birth, nationality_code, academic_title, specialization, biography)
SELECT u.id, '1056789012', 'أنثى', '1988-09-15'::date, 'SA', 'أستاذ مساعد', 'الأخلاقيات الحيوية',
  'أستاذ مساعد في الأخلاقيات الحيوية. عضو في اللجنة المؤسسية لمراجعة الأخلاقيات منذ 2022.'
FROM security.users u WHERE u.username = 'reviewer2';

INSERT INTO security.user_profiles (user_id, national_id, gender, date_of_birth, nationality_code, academic_title, specialization, biography)
SELECT u.id, '1067890123', 'ذكر', '1978-01-30'::date, 'SA', 'أستاذ', 'الإحصاء الحيوي',
  'أستاذ الإحصاء الحيوي بجامعة الملك سعود. خبير في تحليل البيانات السريرية.'
FROM security.users u WHERE u.username = 'reviewer3';

INSERT INTO security.user_profiles (user_id, national_id, gender, date_of_birth, nationality_code, academic_title, specialization, biography)
SELECT u.id, '1078901234', 'ذكر', '1970-12-05'::date, 'SA', 'أستاذ دكتور', 'إدارة الرعاية الصحية',
  'مشرف الأخلاقيات بالجامعة. خبرة 25 عاماً في إدارة المؤسسات الصحية والأكاديمية.'
FROM security.users u WHERE u.username = 'ethics_admin';

INSERT INTO security.user_profiles (user_id, national_id, gender, date_of_birth, nationality_code, academic_title, specialization, biography)
SELECT u.id, NULL, 'ذكر', '1990-06-18'::date, 'SA', NULL, 'تقنية المعلومات',
  'مدير النظام. مسؤول عن البنية التحتية التقنية للنظام.'
FROM security.users u WHERE u.username = 'admin';

-- ============================================================
-- DOCUMENT TEMPLATES
-- ============================================================
INSERT INTO documents.templates (template_code, template_name, template_type, template_content, version_no, is_active) VALUES
  ('IRB_APPROVAL_LETTER', 'قالب خطاب الموافقة IRB', 'PDF',
   'بسم الله الرحمن الرحيم\n\nخطاب موافقة لجنة الأخلاقيات\n\nرقم الخطاب: {{letter_number}}\nالتاريخ: {{date}}\n\nالسادة/ {{institution_name}}\nالموضوع: الموافقة على الطلب {{application_number}}\n\nإشارة إلى طلب {{project_title}} المقدم من {{researcher_name}}، يسرنا إعلامكم بموافقة اللجنة المؤسسية لمراجعة الأخلاقيات على الطلب المذكور.\n\nوتفضلوا بقبول فائق الاحترام،\nرئيس اللجنة المؤسسية\n{{chairperson_name}}',
   1, true),
  ('REVIEW_FORM', 'نموذج المراجعة العلمية', 'PDF',
   'نموذج المراجعة العلمية\n\nالطلب: {{application_number}}\nالمراجع: {{reviewer_name}}\nالتاريخ: {{date}}\n\nالمعايير:\n1. أهمية البحث: {{criterion_1}}\n2. منهجية البحث: {{criterion_2}}\n3. مؤهلات الفريق: {{criterion_3}}\n\nالتوصية العامة: {{recommendation}}',
   1, true),
  ('ICF_TEMPLATE', 'نموذج الموافقة المستنيرة', 'HTML',
   '<!DOCTYPE html><html dir="rtl"><head><meta charset="UTF-8"></head><body><h1>نموذج الموافقة المستنيرة</h1><h2>عنوان الدراسة: {{study_title}}</h2><p><strong>الباحث الرئيسي:</strong> {{pi_name}}</p><p><strong>المؤسسة:</strong> {{institution}}</p><hr/><h3>مقدمة</h3><p>{{introduction}}</p><h3>الإجراءات</h3><p>{{procedures}}</p><h3>المخاطر والفوائد</h3><p>{{risks_benefits}}</p><h3>السرية</h3><p>{{confidentiality}}</p><hr/><p>أقر بأنني قرأت وفهمت المعلومات أعلاه وأوافق على المشاركة في هذه الدراسة.</p><p>اسم المشارك: ________________</p><p>التوقيع: ________________</p><p>التاريخ: ________________</p></body></html>',
   1, true),
  ('SAE_REPORT', 'قالب تقرير الحدث السلبي الخطير', 'PDF',
   'تقرير حدث سلبي خطير\n\nرقم التقرير: {{report_number}}\nرقم الطلب: {{application_number}}\nتاريخ التقرير: {{report_date}}\n\nنوع الحدث: {{event_type}}\nوصف الحدث: {{event_description}}\nالإجراء المتخذ: {{action_taken}}\n\nحالة المشارك: {{participant_outcome}}',
   1, true),
  ('ANNUAL_PROGRESS', 'قالب تقرير التقدم السنوي', 'PDF',
   'تقرير التقدم السنوي\n\nالرقم المرجعي: {{reference_number}}\nالفترة: {{period_start}} - {{period_end}}\n\nعدد المشاركين المسجلين: {{participants_enrolled}}\nعدد المشاركين المكملين: {{participants_completed}}\nالأحداث السلبية المسجلة: {{adverse_events}}\n\nملخص الإنجازات:\n{{summary}}',
   1, true);

-- ============================================================
-- DOCUMENT VERSIONS (for existing documents)
-- ============================================================
DO $$
DECLARE
  v_doc_proto bigint; v_doc_icf bigint; v_doc_cv bigint; v_doc_irb bigint;
  v_researcher1 bigint;
BEGIN
  SELECT id INTO v_researcher1 FROM security.users WHERE username = 'researcher1';

  -- Get document IDs
  SELECT id INTO v_doc_proto FROM documents.documents WHERE document_title = 'بروتوكول البحث - دراسة الوارفارين';
  SELECT id INTO v_doc_icf FROM documents.documents WHERE document_title = 'نموذج الموافقة المستنيرة - وارفارين';
  SELECT id INTO v_doc_cv FROM documents.documents WHERE document_title = 'السيرة الذاتية - الباحث الرئيسي';
  SELECT id INTO v_doc_irb FROM documents.documents WHERE document_title = 'خطاب الموافقة IRB - دراسة الوارفارين';

  -- Version 1 for protocol
  IF v_doc_proto IS NOT NULL THEN
    INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
    VALUES (v_doc_proto, 1, 'protocol_warfarin_v1.pdf', 'uploads/documents/protocol_warfarin_v1.pdf', 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b', v_researcher1, '2024-03-10 09:00:00+03'::timestamptz, 'النسخة الأولية');

    INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
    VALUES (v_doc_proto, 2, 'protocol_warfarin_v2.pdf', 'uploads/documents/protocol_warfarin_v2.pdf', 'b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c', v_researcher1, '2024-03-14 14:00:00+03'::timestamptz, 'تم التعديل بناءً على ملاحظات المراجعين');
  END IF;

  -- Version 1 for ICF
  IF v_doc_icf IS NOT NULL THEN
    INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
    VALUES (v_doc_icf, 1, 'icf_warfarin.pdf', 'uploads/documents/icf_warfarin.pdf', 'c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3', v_researcher1, '2024-03-12 10:00:00+03'::timestamptz, 'النسخة الأولى من نموذج الموافقة');
  END IF;

  -- Version 1 for CV
  IF v_doc_cv IS NOT NULL THEN
    INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
    VALUES (v_doc_cv, 1, 'cv_researcher1.pdf', 'uploads/documents/cv_researcher1.pdf', 'd4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4', v_researcher1, '2024-03-10 09:00:00+03'::timestamptz, 'السيرة الذاتية');
  END IF;

  -- Version 1 for IRB approval
  IF v_doc_irb IS NOT NULL THEN
    INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
    VALUES (v_doc_irb, 1, 'irb_approval_warfarin.pdf', 'uploads/documents/irb_approval_warfarin.pdf', 'e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5', (SELECT id FROM security.users WHERE username = 'ethics_admin'), '2024-05-20 15:00:00+03'::timestamptz, 'خطاب الموافقة الرسمي');
  END IF;
END $$;

-- ============================================================
-- DOCUMENT ACCESS
-- ============================================================
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by)
SELECT d.id, u.id, 'VIEW', (SELECT id FROM security.users WHERE username = 'ethics_admin')
FROM documents.documents d, security.users u
WHERE d.document_title = 'بروتوكول البحث - دراسة الوارفارين' AND u.username = 'reviewer1';

INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by)
SELECT d.id, u.id, 'VIEW', (SELECT id FROM security.users WHERE username = 'ethics_admin')
FROM documents.documents d, security.users u
WHERE d.document_title = 'بروتوكول البحث - دراسة الوارفارين' AND u.username = 'reviewer2';

INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by)
SELECT d.id, u.id, 'DOWNLOAD', (SELECT id FROM security.users WHERE username = 'ethics_admin')
FROM documents.documents d, security.users u
WHERE d.document_title = 'بروتوكول البحث - دراسة الوارفارين' AND u.username = 'researcher1';

INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by)
SELECT d.id, u.id, 'VIEW', (SELECT id FROM security.users WHERE username = 'ethics_admin')
FROM documents.documents d, security.users u
WHERE d.document_title = 'نموذج الموافقة المستنيرة - وارفارين' AND u.username = 'reviewer1';

INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by)
SELECT d.id, u.id, 'VIEW', (SELECT id FROM security.users WHERE username = 'ethics_admin')
FROM documents.documents d, security.users u
WHERE d.document_title = 'نموذج الموافقة المستنيرة - وارفارين' AND u.username = 'reviewer2';

-- ============================================================
-- GENERATED DOCUMENTS
-- ============================================================
INSERT INTO documents.generated_documents (template_id, entity_type, entity_id, generated_document_id, generated_by, generation_parameters)
SELECT t.id, 'Application', a.id, (SELECT id FROM documents.documents WHERE document_title = 'خطاب الموافقة IRB - دراسة الوارفارين'),
  (SELECT id FROM security.users WHERE username = 'ethics_admin'),
  '{"letter_number": "IRB-2024-001", "date": "2024-05-20", "language": "ar"}'
FROM documents.templates t, core.applications a
WHERE t.template_code = 'IRB_APPROVAL_LETTER' AND a.application_number = 'APP-2024-001';

-- ============================================================
-- SECURITY ACCESS POLICIES
-- ============================================================
INSERT INTO security.access_policies (policy_code, policy_name, target_resource, policy_expression, is_active) VALUES
  ('USER_OWN_DATA', 'الوصول إلى بيانات المستخدم الخاصة', 'users',
   '{"type": "owner", "field": "id", "equal_to": "current_user_id"}', true),
  ('APPLICATION_OWNER', 'الوصول إلى طلبات المستخدم', 'applications',
   '{"type": "owner", "field": "submitted_by", "equal_to": "current_user_id"}', true),
  ('PROJECT_OWNER', 'الوصول إلى مشاريع المستخدم', 'projects',
   '{"type": "owner", "field": "principal_investigator_id", "equal_to": "current_user_id"}', true),
  ('COMMITTEE_ACCESS', 'الوصول إلى بيانات اللجنة', 'committee_data',
   '{"type": "role", "roles": ["ETHICS_ADMIN", "COMMITTEE_CHAIR", "REVIEWER"]}', true),
  ('REVIEWER_ACCESS', 'الوصول إلى المراجعات الموكلة', 'reviews',
   '{"type": "assignee", "field": "reviewer_id", "equal_to": "current_user_id"}', true),
  ('ADMIN_FULL_ACCESS', 'الوصول الكامل للمدير', 'all',
   '{"type": "role", "roles": ["SUPER_ADMIN"]}', true),
  ('DOCUMENT_ACCESS_POLICY', 'الوصول إلى المستندات', 'documents',
   '{"type": "dynamic", "check_table": "documents.document_access", "field": "user_id", "equal_to": "current_user_id"}', true);

-- ============================================================
-- WORKFLOW SLA
-- ============================================================
INSERT INTO workflow.workflow_sla (workflow_id, state_id, max_duration_hours, warning_hours, is_active)
SELECT w.id, s.id, 48, 24, true
FROM workflow.workflows w, workflow.workflow_states s
WHERE w.workflow_code = 'ETHICS_REVIEW' AND s.state_code = 'SUBMITTED';

INSERT INTO workflow.workflow_sla (workflow_id, state_id, max_duration_hours, warning_hours, is_active)
SELECT w.id, s.id, 168, 120, true
FROM workflow.workflows w, workflow.workflow_states s
WHERE w.workflow_code = 'ETHICS_REVIEW' AND s.state_code = 'SCIENTIFIC_REVIEW';

INSERT INTO workflow.workflow_sla (workflow_id, state_id, max_duration_hours, warning_hours, is_active)
SELECT w.id, s.id, 120, 72, true
FROM workflow.workflows w, workflow.workflow_states s
WHERE w.workflow_code = 'ETHICS_REVIEW' AND s.state_code = 'ETHICS_REVIEW';

INSERT INTO workflow.workflow_sla (workflow_id, state_id, max_duration_hours, warning_hours, is_active)
SELECT w.id, s.id, 720, 480, true
FROM workflow.workflows w, workflow.workflow_states s
WHERE w.workflow_code = 'ETHICS_REVIEW' AND s.state_code = 'COMMITTEE_REVIEW';

-- ============================================================
-- WORKFLOW VARIABLES (for existing workflow instances)
-- ============================================================
INSERT INTO workflow.workflow_variables (workflow_instance_id, variable_name, variable_value)
SELECT wi.id, 'risk_level', '"MEDIUM"'::jsonb
FROM workflow.workflow_instances wi
WHERE wi.entity_type = 'Application'
  AND wi.entity_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-001');

INSERT INTO workflow.workflow_variables (workflow_instance_id, variable_name, variable_value)
SELECT wi.id, 'is_expedited', 'false'::jsonb
FROM workflow.workflow_instances wi
WHERE wi.entity_type = 'Application'
  AND wi.entity_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-001');

INSERT INTO workflow.workflow_variables (workflow_instance_id, variable_name, variable_value)
SELECT wi.id, 'risk_level', '"HIGH"'::jsonb
FROM workflow.workflow_instances wi
WHERE wi.entity_type = 'Application'
  AND wi.entity_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-002');

INSERT INTO workflow.workflow_variables (workflow_instance_id, variable_name, variable_value)
SELECT wi.id, 'committee_meeting_required', 'true'::jsonb
FROM workflow.workflow_instances wi
WHERE wi.entity_type = 'Application'
  AND wi.entity_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-002');

INSERT INTO workflow.workflow_variables (workflow_instance_id, variable_name, variable_value)
SELECT wi.id, 'risk_level', '"LOW"'::jsonb
FROM workflow.workflow_instances wi
WHERE wi.entity_type = 'Application'
  AND wi.entity_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-005');

-- ============================================================
-- REPORTING DASHBOARD WIDGETS
-- ============================================================
INSERT INTO reporting.dashboard_widgets (widget_code, widget_name, widget_type, configuration, is_active) VALUES
  ('PENDING_APPS', 'الطلبات قيد الانتظار', 'COUNTER',
   '{"title": "الطلبات قيد الانتظار", "query": "SELECT COUNT(*) FROM core.applications WHERE current_status NOT IN (''APPROVED'',''REJECTED'',''WITHDRAWN'')", "refresh_interval": 300}', true),
  ('APPS_BY_STATUS', 'الطلبات حسب الحالة', 'PIE_CHART',
   '{"title": "توزيع الطلبات حسب الحالة", "query": "SELECT current_status, COUNT(*) FROM core.applications GROUP BY current_status", "refresh_interval": 600}', true),
  ('RECENT_ACTIVITY', 'آخر النشاطات', 'LIST',
   '{"title": "آخر النشاطات", "query": "SELECT created_at, description FROM system.audit_log ORDER BY created_at DESC LIMIT 10", "refresh_interval": 120}', true),
  ('AVG_REVIEW_TIME', 'متوسط وقت المراجعة', 'GAUGE',
   '{"title": "متوسط وقت المراجعة (أيام)", "query": "SELECT AVG(EXTRACT(DAY FROM (completed_at - started_at))) FROM committee.scientific_reviews WHERE completed_at IS NOT NULL", "refresh_interval": 3600}', true),
  ('APPS_OVER_TIME', 'الطلبات عبر الوقت', 'LINE_CHART',
   '{"title": "الطلبات المقدمة عبر الوقت", "query": "SELECT DATE_TRUNC(''month'', submission_date) AS month, COUNT(*) FROM core.applications WHERE submission_date IS NOT NULL GROUP BY month ORDER BY month", "refresh_interval": 3600}', true),
  ('COMMITTEE_MEETINGS', 'اجتماعات اللجنة القادمة', 'CALENDAR',
   '{"title": "اجتماعات اللجنة القادمة", "query": "SELECT meeting_date, location, meeting_status FROM committee.committee_meetings WHERE meeting_date >= NOW() ORDER BY meeting_date", "refresh_interval": 600}', true);

-- ============================================================
-- REPORT DEFINITIONS
-- ============================================================
INSERT INTO reporting.report_definitions (report_code, report_name, report_category, sql_definition, is_active) VALUES
  ('RPT_APPS_BY_STATUS', 'تقرير الطلبات حسب الحالة', 'APPLICATIONS',
   'SELECT a.application_number, a.application_type, a.current_status, a.submission_date, u.first_name_ar || '' '' || u.last_name_ar AS researcher, p.title_ar AS project_title FROM core.applications a JOIN security.users u ON a.submitted_by = u.id JOIN core.projects p ON a.project_id = p.id ORDER BY a.submission_date DESC',
   true),
  ('RPT_REVIEW_PERFORMANCE', 'تقرير أداء المراجعين', 'REVIEWS',
   'SELECT u.first_name_ar || '' '' || u.last_name_ar AS reviewer, COUNT(sr.id) AS reviews_completed, AVG(EXTRACT(DAY FROM (sr.completed_at - sr.started_at))) AS avg_days FROM committee.scientific_reviews sr JOIN security.users u ON sr.reviewer_id = u.id WHERE sr.completed_at IS NOT NULL GROUP BY sr.reviewer_id, u.first_name_ar, u.last_name_ar ORDER BY avg_days',
   true),
  ('RPT_SAFEY_SUMMARY', 'ملخص السلامة', 'SAFETY',
   'SELECT a.application_number, COUNT(ae.id) AS total_events, COUNT(sae.id) AS serious_events FROM core.applications a LEFT JOIN safety.adverse_events ae ON a.id = ae.application_id LEFT JOIN safety.serious_adverse_events sae ON ae.id = sae.adverse_event_id GROUP BY a.id, a.application_number ORDER BY total_events DESC',
   true),
  ('RPT_MONITORING_STATUS', 'حالة المراقبة', 'MONITORING',
   'SELECT mp.plan_code, a.application_number, mp.monitoring_type, mp.status_code, COUNT(mv.id) AS visits_completed FROM monitoring.monitoring_plans mp JOIN core.applications a ON mp.application_id = a.id LEFT JOIN monitoring.monitoring_visits mv ON mp.id = mv.monitoring_plan_id AND mv.visit_status = ''COMPLETED'' GROUP BY mp.id, mp.plan_code, a.application_number, mp.monitoring_type, mp.status_code',
   true),
  ('RPT_COMMITTEE_DECISIONS', 'قرارات اللجنة', 'COMMITTEE',
   'SELECT cm.meeting_number, cm.meeting_date, COUNT(v.id) AS total_votes, v2.vote_value, COUNT(v2.id) AS vote_count FROM committee.committee_meetings cm JOIN committee.voting_sessions vs ON cm.id = vs.meeting_id JOIN committee.votes v ON vs.id = v.voting_session_id JOIN committee.votes v2 ON vs.id = v2.voting_session_id GROUP BY cm.meeting_number, cm.meeting_date, v2.vote_value ORDER BY cm.meeting_date',
   true);

-- ============================================================
-- KPI RESULTS (dashboard metrics)
-- ============================================================
INSERT INTO reporting.kpi_results (kpi_code, measurement_date, kpi_value, target_value) VALUES
  ('AVG_REVIEW_DAYS', '2024-09-30'::date, 14.5, 30.0),
  ('APPROVAL_RATE', '2024-09-30'::date, 85.0, 90.0),
  ('PENDING_APPS_COUNT', '2024-09-30'::date, 3.0, 0.0),
  ('COMPLIANCE_SCORE', '2024-09-30'::date, 91.5, 95.0),
  ('SAFEY_REPORTING_RATE', '2024-09-30'::date, 100.0, 100.0);

-- ============================================================
-- ANALYTICS SNAPSHOT
-- ============================================================
INSERT INTO reporting.analytics_snapshots (snapshot_date, snapshot_type, metrics) VALUES
  ('2024-09-30'::date, 'MONTHLY',
   '{
     "total_applications": 5,
     "approved": 1,
     "under_review": 3,
     "draft": 1,
     "total_projects": 3,
     "active_committees": 1,
     "committee_members": 5,
     "adverse_events": 7,
     "serious_adverse_events": 2,
     "monitoring_plans": 3,
     "compliance_rate": 91.5,
     "avg_review_days": 14.5
   }'::jsonb);

COMMIT;
