-- ============================================================
-- 06-PROJECTS AND APPLICATIONS
-- ============================================================
-- بيانات تجريبية للمشاريع والطلبات البحثية مع حالاتها المختلفة
-- (معتمد، معلق، قيد المراجعة).

-- PROJECT 1: Pharmacogenomics study (completed, approved)
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en,
  abstract_ar, abstract_en, objectives,
  principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date)
SELECT i.id, 'KSU-RES-2024-001',
  'تأثير العوامل الوراثية على استجابة المرضى لدواء الوارفارين في المجتمع السعودي',
  'Impact of Genetic Factors on Warfarin Response in Saudi Patients',
  'تهدف هذه الدراسة إلى تقييم تأثير التعددات الشكلية في الجينات المرتبطة باستقلاب الوارفارين على الجرعة المثلى للمرضى السعوديين. ستشمل الدراسة 500 مريض من مستشفى الملك خالد الجامعي.',
  'This study aims to assess the impact of genetic polymorphisms in warfarin metabolism-related genes on optimal dosing in Saudi patients. The study will include 500 patients from King Khalid University Hospital.',
  '1. تحديد التعددات الشكلية في جينات CYP2C9 و VKORC1 لدى المرضى السعوديين
2. ربط هذه التعددات بالجرعة المثلى من الوارفارين
3. تطوير نموذج جرعات مخصص للسعوديين',
  (SELECT id FROM security.users WHERE username = 'researcher1'), 'GENETIC', 'MEDIUM', 'APPROVED',
  '2024-03-01'::date, '2025-06-30'::date
FROM security.institutions i WHERE i.code = 'KSU';

-- PROJECT 2: Breast cancer immunotherapy (under review)
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en,
  abstract_ar, abstract_en, objectives,
  principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date)
SELECT i.id, 'KSU-RES-2024-002',
  'تقييم فعالية العلاج المناعي لدى مرضى سرطان الثدي في المملكة العربية السعودية',
  'Efficacy of Immunotherapy in Breast Cancer Patients in Saudi Arabia',
  'دراسة استباقية لتقييم فعالية وسلامة مثبطات نقاط التفتيش المناعية لدى 300 مريضة سرطان ثدي سعودية. تشمل الدراسة متابعة لمدة 24 شهراً.',
  'A prospective study evaluating the efficacy and safety of immune checkpoint inhibitors in 300 Saudi breast cancer patients. Includes a 24-month follow-up period.',
  '1. تقييم معدل الاستجابة للعلاج المناعي
2. تحديد العوامل المنبئة بالاستجابة
3. تقييم ملف السلامة والآثار الجانبية',
  (SELECT id FROM security.users WHERE username = 'researcher1'), 'CLINICAL_TRIAL', 'HIGH', 'UNDER_REVIEW',
  '2024-06-01'::date, '2026-12-31'::date
FROM security.institutions i WHERE i.code = 'KSU';

-- PROJECT 3: Pediatric microbiome (draft)
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en,
  abstract_ar, abstract_en, objectives,
  principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date)
SELECT i.id, 'KSU-RES-2024-003',
  'دور الميكروبيوم المعوي في تطور السمنة لدى الأطفال السعوديين',
  'Role of Gut Microbiome in Obesity Development Among Saudi Children',
  'دراسة مقطعية لتحليل تركيبة الميكروبيوم المعوي لدى 200 طفل سعودي (100 يعانون من السمنة و100 أصحاء) لتحديد الاختلافات في التنوع البكتيري.',
  'A cross-sectional study analyzing gut microbiome composition in 200 Saudi children (100 obese, 100 healthy) to identify differences in bacterial diversity.',
  '1. مقارنة تركيبة الميكروبيوم بين الأطفال المصابين بالسمنة والأصحاء
2. ربط التغيرات الميكروبية بالمؤشرات الحيوية للالتهاب
3. تحديد المؤشرات الميكروبية المنبئة للسمنة',
  (SELECT id FROM security.users WHERE username = 'researcher2'), 'EPIDEMIOLOGICAL', 'LOW', 'DRAFT',
  '2024-09-01'::date, '2025-12-31'::date
FROM security.institutions i WHERE i.code = 'KSU';

-- ============================================================
-- APPLICATIONS
-- ============================================================

-- Application 1: Pharmacogenomics - APPROVED (completed workflow)
INSERT INTO core.applications (application_number, project_id, application_type, current_status, submission_date, submitted_by, target_committee_id)
SELECT 'APP-2024-001', p.id, 'INITIAL', 'APPROVED', '2024-03-15 09:00:00+03'::timestamptz,
  (SELECT id FROM security.users WHERE username = 'researcher1'),
  c.id
FROM core.projects p, committee.committees c
WHERE p.project_code = 'KSU-RES-2024-001' AND c.committee_code = 'IRB-KSU-01';

-- Application 2: Breast Cancer - COMMITTEE_REVIEW (under committee review)
INSERT INTO core.applications (application_number, project_id, application_type, current_status, submission_date, submitted_by, target_committee_id)
SELECT 'APP-2024-002', p.id, 'INITIAL', 'COMMITTEE_REVIEW', '2024-06-10 10:30:00+03'::timestamptz,
  (SELECT id FROM security.users WHERE username = 'researcher1'),
  c.id
FROM core.projects p, committee.committees c
WHERE p.project_code = 'KSU-RES-2024-002' AND c.committee_code = 'IRB-KSU-01';

-- Application 3: Breast Cancer - SCIENTIFIC_REVIEW (second application for same project - amendment)
INSERT INTO core.applications (application_number, project_id, application_type, current_status, submission_date, submitted_by, target_committee_id)
SELECT 'APP-2024-003', p.id, 'AMENDMENT', 'SCIENTIFIC_REVIEW', '2024-08-20 14:00:00+03'::timestamptz,
  (SELECT id FROM security.users WHERE username = 'researcher1'),
  c.id
FROM core.projects p, committee.committees c
WHERE p.project_code = 'KSU-RES-2024-002' AND c.committee_code = 'IRB-KSU-01';

-- Application 4: Pediatric Microbiome - DRAFT (not yet submitted)
INSERT INTO core.applications (application_number, project_id, application_type, current_status, submitted_by, target_committee_id)
SELECT 'APP-2024-004', p.id, 'INITIAL', 'DRAFT',
  (SELECT id FROM security.users WHERE username = 'researcher2'),
  c.id
FROM core.projects p, committee.committees c
WHERE p.project_code = 'KSU-RES-2024-003' AND c.committee_code = 'IRB-KSU-01';

-- Application 5: Pharmacogenomics - SUBMITTED (waiting initial review)
INSERT INTO core.applications (application_number, project_id, application_type, current_status, submission_date, submitted_by, target_committee_id)
SELECT 'APP-2024-005', p.id, 'EXPEDITED', 'SUBMITTED', '2024-09-25 11:15:00+03'::timestamptz,
  (SELECT id FROM security.users WHERE username = 'researcher2'),
  c.id
FROM core.projects p, committee.committees c
WHERE p.project_code = 'KSU-RES-2024-001' AND c.committee_code = 'IRB-KSU-01';
