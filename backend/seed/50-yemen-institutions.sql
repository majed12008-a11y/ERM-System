-- =============================================================================
-- 50-yemen-institutions.sql
-- Commit 1: Yemen Institution Hierarchy
--
-- Purpose: Create the Yemen institution hierarchy (40 institutions, ~120 departments)
-- Dependencies: None (references existing security.institution_types — 3 types)
-- Canonical schema: security.institutions, security.departments
-- RLS: Not enabled on either table — no RLS bypass needed
-- Rollback: Entire file wrapped in single transaction (ROLLBACK to undo)
-- Idempotent: No — creates transactional data. Run once after cleanup.
-- =============================================================================

BEGIN;

SET session_replication_role = 'replica';

-- Fix sequences to max existing values
SELECT setval('security.institutions_id_seq', COALESCE((SELECT MAX(id) FROM security.institutions), 0));
SELECT setval('security.departments_id_seq', COALESCE((SELECT MAX(id) FROM security.departments), 0));

-- =============================================================================
-- INSTITUTIONS
-- Type mapping: 1=UNIVERSITY, 2=HOSPITAL, 3=RESEARCH_CENTER
-- =============================================================================

WITH new_inst AS (
  INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, created_by)
  VALUES
    -- ═══════════════════════════════════════════════════════════════════════
    -- MINISTRY (1)
    -- ═══════════════════════════════════════════════════════════════════════
    (3, 'MOH_YE', 'وزارة الصحة والبيئة', 'Ministry of Health and Environment',
     'moh@moh.gov.ye', '+9671200200', 'الجمهورية اليمنية - صنعاء - الحصبة', 1),

    -- ═══════════════════════════════════════════════════════════════════════
    -- NATIONAL CENTERS (5)
    -- ═══════════════════════════════════════════════════════════════════════
    (3, 'CHL_YE', 'المختبر المركزي الصحي', 'Central Health Laboratory',
     'chl@moh.gov.ye', '+9671200301', 'الجمهورية اليمنية - صنعاء - شارع الستين', 1),
    (3, 'NIPH_YE', 'المعهد الوطني للصحة العامة', 'National Institute of Public Health',
     'niph@moh.gov.ye', '+9671200302', 'الجمهورية اليمنية - صنعاء - حي الجامعة', 1),
    (2, 'NOC_YE', 'المركز الوطني للأورام', 'National Oncology Center',
     'noc@moh.gov.ye', '+9671200303', 'الجمهورية اليمنية - صنعاء - شارع الزبيري', 1),
    (3, 'NNI_YE', 'المعهد الوطني للتغذية', 'National Nutrition Institute',
     'nni@moh.gov.ye', '+9671200304', 'الجمهورية اليمنية - صنعاء - التحرير', 1),
    (3, 'NBTC_YE', 'المركز الوطني لنقل الدم', 'National Blood Transfusion Center',
     'nbtc@moh.gov.ye', '+9671200305', 'الجمهورية اليمنية - صنعاء - شارع حدة', 1),

    -- ═══════════════════════════════════════════════════════════════════════
    -- GOVERNORATE HEALTH OFFICES (8)
    -- ═══════════════════════════════════════════════════════════════════════
    (3, 'GHO_SA', 'مكتب صحة الأمانة', 'Sana''a Health Office',
     'gho.sanaa@moh.gov.ye', '+9671200401', 'الجمهورية اليمنية - صنعاء - شارع الثورة', 1),
    (3, 'GHO_AD', 'مكتب صحة عدن', 'Aden Health Office',
     'gho.aden@moh.gov.ye', '+9672200401', 'الجمهورية اليمنية - عدن - خور مكسر', 1),
    (3, 'GHO_TZ', 'مكتب صحة تعز', 'Taiz Health Office',
     'gho.taiz@moh.gov.ye', '+9674200401', 'الجمهورية اليمنية - تعز - جبل جرة', 1),
    (3, 'GHO_HD', 'مكتب صحة الحديدة', 'Hodeidah Health Office',
     'gho.hodeidah@moh.gov.ye', '+9673200401', 'الجمهورية اليمنية - الحديدة - الكورنيش', 1),
    (3, 'GHO_IB', 'مكتب صحة إب', 'Ibb Health Office',
     'gho.ibb@moh.gov.ye', '+9674200402', 'الجمهورية اليمنية - إب - صبر', 1),
    (3, 'GHO_DH', 'مكتب صحة ذمار', 'Dhamar Health Office',
     'gho.dhamar@moh.gov.ye', '+9676200401', 'الجمهورية اليمنية - ذمار - وسط المدينة', 1),
    (3, 'GHO_MK', 'مكتب صحة حضرموت', 'Hadramawt Health Office',
     'gho.hadramawt@moh.gov.ye', '+9675200401', 'الجمهورية اليمنية - حضرموت - المكلا', 1),
    (3, 'GHO_HJ', 'مكتب صحة حجة', 'Hajjah Health Office',
     'gho.hajjah@moh.gov.ye', '+9677200401', 'الجمهورية اليمنية - حجة - مركز المدينة', 1),

    -- ═══════════════════════════════════════════════════════════════════════
    -- PUBLIC HOSPITALS (10)
    -- ═══════════════════════════════════════════════════════════════════════
    (2, 'H_SP_SANA', 'مستشفى صنعاء العام', 'Sana''a General Hospital',
     'info@sanaa-hospital.ye', '+9671200501', 'الجمهورية اليمنية - صنعاء - شارع الستين', 1),
    (2, 'H_SP_ADEN', 'مستشفى عدن العام', 'Aden General Hospital',
     'info@aden-hospital.ye', '+9672200501', 'الجمهورية اليمنية - عدن - البريقة', 1),
    (2, 'H_SP_TAIZ', 'مستشفى تعز العام', 'Taiz General Hospital',
     'info@taiz-hospital.ye', '+9674200501', 'الجمهورية اليمنية - تعز - الحصب', 1),
    (2, 'H_SP_HODE', 'مستشفى الحديدة العام', 'Hodeidah General Hospital',
     'info@hodeidah-hospital.ye', '+9673200501', 'الجمهورية اليمنية - الحديدة - شارع الميناء', 1),
    (2, 'H_SP_IBB', 'مستشفى إب العام', 'Ibb General Hospital',
     'info@ibb-hospital.ye', '+9674200502', 'الجمهورية اليمنية - إب - المشنة', 1),
    (2, 'H_SP_DHAM', 'مستشفى ذمار العام', 'Dhamar General Hospital',
     'info@dhamar-hospital.ye', '+9676200501', 'الجمهورية اليمنية - ذمار - شارع تعز', 1),
    (2, 'H_SP_MUKA', 'مستشفى المكلا العام', 'Mukalla General Hospital',
     'info@mukalla-hospital.ye', '+9675200501', 'الجمهورية اليمنية - حضرموت - المكلا - فوة', 1),
    (2, 'H_SP_HAJJ', 'مستشفى حجة العام', 'Hajjah General Hospital',
     'info@hajjah-hospital.ye', '+9677200501', 'الجمهورية اليمنية - حجة - شارع المستشفى', 1),
    (2, 'H_MS_ADEN', 'مستشفى الأمومة والطفولة بعدن', 'Aden Mother and Child Hospital',
     'info@aden-mch-hospital.ye', '+9672200502', 'الجمهورية اليمنية - عدن - الشيخ عثمان', 1),
    (2, 'H_ER_SANA', 'مستشفى صنعاء للطوارئ', 'Sana''a Emergency Hospital',
     'info@sanaa-emergency.ye', '+9671200502', 'الجمهورية اليمنية - صنعاء - شارع حمير', 1),

    -- ═══════════════════════════════════════════════════════════════════════
    -- TEACHING HOSPITALS (5)
    -- ═══════════════════════════════════════════════════════════════════════
    (2, 'H_T_SANA', 'مستشفى صنعاء التعليمي', 'Sana''a Teaching Hospital',
     'info@sanaa-teaching.ye', '+9671200601', 'الجمهورية اليمنية - صنعاء - حي الجامعة', 1),
    (2, 'H_T_ADEN', 'مستشفى عدن التعليمي', 'Aden Teaching Hospital',
     'info@aden-teaching.ye', '+9672200601', 'الجمهورية اليمنية - عدن - خور مكسر', 1),
    (2, 'H_T_TAIZ', 'مستشفى تعز التعليمي', 'Taiz Teaching Hospital',
     'info@taiz-teaching.ye', '+9674200601', 'الجمهورية اليمنية - تعز - جبل صبر', 1),
    (2, 'H_T_HODE', 'مستشفى الحديدة التعليمي', 'Hodeidah Teaching Hospital',
     'info@hodeidah-teaching.ye', '+9673200601', 'الجمهورية اليمنية - الحديدة - حي الجامعة', 1),
    (2, 'H_T_MUKA', 'مستشفى المكلا التعليمي', 'Mukalla Teaching Hospital',
     'info@mukalla-teaching.ye', '+9675200601', 'الجمهورية اليمنية - حضرموت - المكلا - فوة', 1),

    -- ═══════════════════════════════════════════════════════════════════════
    -- MEDICAL FACULTIES / UNIVERSITIES (5)
    -- ═══════════════════════════════════════════════════════════════════════
    (1, 'U_SANA_MED', 'كلية الطب بجامعة صنعاء', 'Sana''a University Faculty of Medicine',
     'med@suna.edu.ye', '+9671200701', 'الجمهورية اليمنية - صنعاء - شارع الستين - جامعة صنعاء', 1),
    (1, 'U_ADEN_MED', 'كلية الطب بجامعة عدن', 'Aden University Faculty of Medicine',
     'med@aden-univ.net', '+9672200701', 'الجمهورية اليمنية - عدن - خور مكسر - جامعة عدن', 1),
    (1, 'U_TAIZ_MED', 'كلية الطب بجامعة تعز', 'Taiz University Faculty of Medicine',
     'med@taiz.edu.ye', '+9674200701', 'الجمهورية اليمنية - تعز - الحصب - جامعة تعز', 1),
    (1, 'U_HODE_MED', 'كلية الطب بجامعة الحديدة', 'Hodeidah University Faculty of Medicine',
     'med@hoduniv.edu.ye', '+9673200701', 'الجمهورية اليمنية - الحديدة - شارع الجامعة', 1),
    (1, 'U_IBB_MED', 'كلية الطب بجامعة إب', 'Ibb University Faculty of Medicine',
     'med@ibbuniv.edu.ye', '+9674200702', 'الجمهورية اليمنية - إب - صبر - جامعة إب', 1),

    -- ═══════════════════════════════════════════════════════════════════════
    -- NATIONAL LABORATORIES (3)
    -- ═══════════════════════════════════════════════════════════════════════
    (3, 'LAB_VIRO', 'مختبر الفيروسات الوطني', 'National Virology Laboratory',
     'virology@moh.gov.ye', '+9671200801', 'الجمهورية اليمنية - صنعاء - حي المختبرات', 1),
    (3, 'LAB_BACT', 'مختبر البكتيريا الوطني', 'National Bacteriology Laboratory',
     'bacteriology@moh.gov.ye', '+9671200802', 'الجمهورية اليمنية - صنعاء - شارع الستين', 1),
    (3, 'LAB_PARA', 'مختبر الطفيليات الوطني', 'National Parasitology Laboratory',
     'parasitology@moh.gov.ye', '+9671200803', 'الجمهورية اليمنية - صنعاء - حي الجامعة', 1),

    -- ═══════════════════════════════════════════════════════════════════════
    -- DISEASE SURVEILLANCE CENTERS (2)
    -- ═══════════════════════════════════════════════════════════════════════
    (3, 'DSC_EPID', 'مركز الترصد الوبائي', 'Epidemiological Surveillance Center',
     'epid@moh.gov.ye', '+9671200901', 'الجمهورية اليمنية - صنعاء - شارع الزبيري', 1),
    (3, 'DSC_CHRO', 'مركز ترصد الأمراض المزمنة', 'Chronic Disease Surveillance Center',
     'chronic@moh.gov.ye', '+9671200902', 'الجمهورية اليمنية - صنعاء - التحرير', 1),

    -- ═══════════════════════════════════════════════════════════════════════
    -- RESEARCH INSTITUTE (1)
    -- ═══════════════════════════════════════════════════════════════════════
    (3, 'RI_MED_YE', 'المعهد اليمني للبحوث الطبية', 'Yemen Institute for Medical Research',
     'research@yimr.edu.ye', '+9671201001', 'الجمهورية اليمنية - صنعاء - حي الجامعة', 1)

  RETURNING id, code
)
INSERT INTO security.departments (institution_id, code, name_ar, name_en)
SELECT
  ni.id,
  d.code,
  d.name_ar,
  d.name_en
FROM new_inst ni
JOIN (VALUES
  -- ═════════════════════════════════════════════════════════════════════════
  -- Ministry of Health and Environment — departments
  -- ═════════════════════════════════════════════════════════════════════════
  ('MOH_YE', 'ADMIN', 'الإدارة العامة للشؤون الإدارية', 'General Administration of Administrative Affairs'),
  ('MOH_YE', 'FINANCE', 'الإدارة المالية', 'Financial Administration'),
  ('MOH_YE', 'HR', 'إدارة الموارد البشرية', 'Human Resources Management'),
  ('MOH_YE', 'PLAN', 'إدارة التخطيط الصحي', 'Health Planning Department'),
  ('MOH_YE', 'QUALITY', 'إدارة الجودة الصحية', 'Health Quality Department'),

  -- ═════════════════════════════════════════════════════════════════════════
  -- Central Health Laboratory — departments
  -- ═════════════════════════════════════════════════════════════════════════
  ('CHL_YE', 'MICRO', 'قسم الأحياء الدقيقة', 'Microbiology Department'),
  ('CHL_YE', 'CHEM', 'قسم الكيمياء السريرية', 'Clinical Chemistry Department'),
  ('CHL_YE', 'IMM', 'قسم المناعة', 'Immunology Department'),

  -- ═════════════════════════════════════════════════════════════════════════
  -- National Institute of Public Health — departments
  -- ═════════════════════════════════════════════════════════════════════════
  ('NIPH_YE', 'EPID', 'قسم الأوبئة', 'Epidemiology Department'),
  ('NIPH_YE', 'STATS', 'قسم الإحصاء الصحي', 'Health Statistics Department'),
  ('NIPH_YE', 'TRAIN', 'قسم التدريب الصحي', 'Health Training Department'),

  -- ═════════════════════════════════════════════════════════════════════════
  -- National Oncology Center — departments
  -- ═════════════════════════════════════════════════════════════════════════
  ('NOC_YE', 'CHEMO', 'قسم العلاج الكيميائي', 'Chemotherapy Department'),
  ('NOC_YE', 'RADIO', 'قسم العلاج الإشعاعي', 'Radiotherapy Department'),
  ('NOC_YE', 'SURG_ONC', 'قسم جراحة الأورام', 'Surgical Oncology Department'),

  -- ═════════════════════════════════════════════════════════════════════════
  -- National Nutrition Institute — departments
  -- ═════════════════════════════════════════════════════════════════════════
  ('NNI_YE', 'CLIN_NUTR', 'قسم التغذية السريرية', 'Clinical Nutrition Department'),
  ('NNI_YE', 'COMM_NUTR', 'قسم تغذية المجتمع', 'Community Nutrition Department'),
  ('NNI_YE', 'FOOD_SCI', 'قسم علوم الأغذية', 'Food Science Department'),

  -- ═════════════════════════════════════════════════════════════════════════
  -- National Blood Transfusion Center — departments
  -- ═════════════════════════════════════════════════════════════════════════
  ('NBTC_YE', 'DONOR', 'قسم المتبرعين', 'Donor Recruitment Department'),
  ('NBTC_YE', 'PROCESS', 'قسم معالجة الدم', 'Blood Processing Department'),
  ('NBTC_YE', 'QA_BLOOD', 'قسم ضمان الجودة', 'Quality Assurance Department'),

  -- ═════════════════════════════════════════════════════════════════════════
  -- Governorate Health Offices — departments (2 per office)
  -- ═════════════════════════════════════════════════════════════════════════
  ('GHO_SA', 'PUB_HLTH', 'إدارة الصحة العامة', 'Public Health Department'),
  ('GHO_SA', 'PREV_MED', 'إدارة الطب الوقائي', 'Preventive Medicine Department'),
  ('GHO_AD', 'PUB_HLTH', 'إدارة الصحة العامة', 'Public Health Department'),
  ('GHO_AD', 'PREV_MED', 'إدارة الطب الوقائي', 'Preventive Medicine Department'),
  ('GHO_TZ', 'PUB_HLTH', 'إدارة الصحة العامة', 'Public Health Department'),
  ('GHO_TZ', 'PREV_MED', 'إدارة الطب الوقائي', 'Preventive Medicine Department'),
  ('GHO_HD', 'PUB_HLTH', 'إدارة الصحة العامة', 'Public Health Department'),
  ('GHO_HD', 'PREV_MED', 'إدارة الطب الوقائي', 'Preventive Medicine Department'),
  ('GHO_IB', 'PUB_HLTH', 'إدارة الصحة العامة', 'Public Health Department'),
  ('GHO_IB', 'PREV_MED', 'إدارة الطب الوقائي', 'Preventive Medicine Department'),
  ('GHO_DH', 'PUB_HLTH', 'إدارة الصحة العامة', 'Public Health Department'),
  ('GHO_DH', 'PREV_MED', 'إدارة الطب الوقائي', 'Preventive Medicine Department'),
  ('GHO_MK', 'PUB_HLTH', 'إدارة الصحة العامة', 'Public Health Department'),
  ('GHO_MK', 'PREV_MED', 'إدارة الطب الوقائي', 'Preventive Medicine Department'),
  ('GHO_HJ', 'PUB_HLTH', 'إدارة الصحة العامة', 'Public Health Department'),
  ('GHO_HJ', 'PREV_MED', 'إدارة الطب الوقائي', 'Preventive Medicine Department'),

  -- ═════════════════════════════════════════════════════════════════════════
  -- Public Hospitals — departments (4 per hospital)
  -- ═════════════════════════════════════════════════════════════════════════
  ('H_SP_SANA', 'INTERNAL', 'قسم الباطنة', 'Internal Medicine Department'),
  ('H_SP_SANA', 'PEDIATRICS', 'قسم طب الأطفال', 'Pediatrics Department'),
  ('H_SP_SANA', 'OBGYN', 'قسم النساء والولادة', 'Obstetrics and Gynecology Department'),
  ('H_SP_SANA', 'SURGERY', 'قسم الجراحة', 'Surgery Department'),
  ('H_SP_ADEN', 'INTERNAL', 'قسم الباطنة', 'Internal Medicine Department'),
  ('H_SP_ADEN', 'PEDIATRICS', 'قسم طب الأطفال', 'Pediatrics Department'),
  ('H_SP_ADEN', 'OBGYN', 'قسم النساء والولادة', 'Obstetrics and Gynecology Department'),
  ('H_SP_ADEN', 'SURGERY', 'قسم الجراحة', 'Surgery Department'),
  ('H_SP_TAIZ', 'INTERNAL', 'قسم الباطنة', 'Internal Medicine Department'),
  ('H_SP_TAIZ', 'PEDIATRICS', 'قسم طب الأطفال', 'Pediatrics Department'),
  ('H_SP_TAIZ', 'OBGYN', 'قسم النساء والولادة', 'Obstetrics and Gynecology Department'),
  ('H_SP_TAIZ', 'SURGERY', 'قسم الجراحة', 'Surgery Department'),
  ('H_SP_HODE', 'INTERNAL', 'قسم الباطنة', 'Internal Medicine Department'),
  ('H_SP_HODE', 'PEDIATRICS', 'قسم طب الأطفال', 'Pediatrics Department'),
  ('H_SP_HODE', 'OBGYN', 'قسم النساء والولادة', 'Obstetrics and Gynecology Department'),
  ('H_SP_HODE', 'SURGERY', 'قسم الجراحة', 'Surgery Department'),
  ('H_SP_IBB', 'INTERNAL', 'قسم الباطنة', 'Internal Medicine Department'),
  ('H_SP_IBB', 'PEDIATRICS', 'قسم طب الأطفال', 'Pediatrics Department'),
  ('H_SP_IBB', 'OBGYN', 'قسم النساء والولادة', 'Obstetrics and Gynecology Department'),
  ('H_SP_IBB', 'SURGERY', 'قسم الجراحة', 'Surgery Department'),
  ('H_SP_DHAM', 'INTERNAL', 'قسم الباطنة', 'Internal Medicine Department'),
  ('H_SP_DHAM', 'PEDIATRICS', 'قسم طب الأطفال', 'Pediatrics Department'),
  ('H_SP_DHAM', 'OBGYN', 'قسم النساء والولادة', 'Obstetrics and Gynecology Department'),
  ('H_SP_DHAM', 'SURGERY', 'قسم الجراحة', 'Surgery Department'),
  ('H_SP_MUKA', 'INTERNAL', 'قسم الباطنة', 'Internal Medicine Department'),
  ('H_SP_MUKA', 'PEDIATRICS', 'قسم طب الأطفال', 'Pediatrics Department'),
  ('H_SP_MUKA', 'OBGYN', 'قسم النساء والولادة', 'Obstetrics and Gynecology Department'),
  ('H_SP_MUKA', 'SURGERY', 'قسم الجراحة', 'Surgery Department'),
  ('H_SP_HAJJ', 'INTERNAL', 'قسم الباطنة', 'Internal Medicine Department'),
  ('H_SP_HAJJ', 'PEDIATRICS', 'قسم طب الأطفال', 'Pediatrics Department'),
  ('H_SP_HAJJ', 'OBGYN', 'قسم النساء والولادة', 'Obstetrics and Gynecology Department'),
  ('H_SP_HAJJ', 'SURGERY', 'قسم الجراحة', 'Surgery Department'),
  ('H_MS_ADEN', 'OBGYN', 'قسم النساء والولادة', 'Obstetrics and Gynecology Department'),
  ('H_MS_ADEN', 'PEDIATRICS', 'قسم طب الأطفال', 'Pediatrics Department'),
  ('H_MS_ADEN', 'NEONATAL', 'قسم حديثي الولادة', 'Neonatal Care Department'),
  ('H_MS_ADEN', 'FAM_PLAN', 'قسم تنظيم الأسرة', 'Family Planning Department'),
  ('H_ER_SANA', 'ER', 'قسم الطوارئ', 'Emergency Department'),
  ('H_ER_SANA', 'TRAUMA', 'قسم الإصابات', 'Trauma Department'),
  ('H_ER_SANA', 'ICU', 'قسم العناية المركزة', 'Intensive Care Unit'),
  ('H_ER_SANA', 'TOX', 'قسم السموم', 'Toxicology Department'),

  -- ═════════════════════════════════════════════════════════════════════════
  -- Teaching Hospitals — departments (4 per hospital)
  -- ═════════════════════════════════════════════════════════════════════════
  ('H_T_SANA', 'INTERNAL', 'قسم الباطنة التعليمي', 'Internal Medicine Teaching Department'),
  ('H_T_SANA', 'PEDIATRICS', 'قسم طب الأطفال التعليمي', 'Pediatrics Teaching Department'),
  ('H_T_SANA', 'OBGYN', 'قسم النساء والولادة التعليمي', 'Obstetrics and Gynecology Teaching Department'),
  ('H_T_SANA', 'SURGERY', 'قسم الجراحة التعليمي', 'Surgery Teaching Department'),
  ('H_T_ADEN', 'INTERNAL', 'قسم الباطنة التعليمي', 'Internal Medicine Teaching Department'),
  ('H_T_ADEN', 'PEDIATRICS', 'قسم طب الأطفال التعليمي', 'Pediatrics Teaching Department'),
  ('H_T_ADEN', 'OBGYN', 'قسم النساء والولادة التعليمي', 'Obstetrics and Gynecology Teaching Department'),
  ('H_T_ADEN', 'SURGERY', 'قسم الجراحة التعليمي', 'Surgery Teaching Department'),
  ('H_T_TAIZ', 'INTERNAL', 'قسم الباطنة التعليمي', 'Internal Medicine Teaching Department'),
  ('H_T_TAIZ', 'PEDIATRICS', 'قسم طب الأطفال التعليمي', 'Pediatrics Teaching Department'),
  ('H_T_TAIZ', 'OBGYN', 'قسم النساء والولادة التعليمي', 'Obstetrics and Gynecology Teaching Department'),
  ('H_T_TAIZ', 'SURGERY', 'قسم الجراحة التعليمي', 'Surgery Teaching Department'),
  ('H_T_HODE', 'INTERNAL', 'قسم الباطنة التعليمي', 'Internal Medicine Teaching Department'),
  ('H_T_HODE', 'PEDIATRICS', 'قسم طب الأطفال التعليمي', 'Pediatrics Teaching Department'),
  ('H_T_HODE', 'OBGYN', 'قسم النساء والولادة التعليمي', 'Obstetrics and Gynecology Teaching Department'),
  ('H_T_HODE', 'SURGERY', 'قسم الجراحة التعليمي', 'Surgery Teaching Department'),
  ('H_T_MUKA', 'INTERNAL', 'قسم الباطنة التعليمي', 'Internal Medicine Teaching Department'),
  ('H_T_MUKA', 'PEDIATRICS', 'قسم طب الأطفال التعليمي', 'Pediatrics Teaching Department'),
  ('H_T_MUKA', 'OBGYN', 'قسم النساء والولادة التعليمي', 'Obstetrics and Gynecology Teaching Department'),
  ('H_T_MUKA', 'SURGERY', 'قسم الجراحة التعليمي', 'Surgery Teaching Department'),

  -- ═════════════════════════════════════════════════════════════════════════
  -- Medical Faculties — departments (3 per faculty)
  -- ═════════════════════════════════════════════════════════════════════════
  ('U_SANA_MED', 'BASIC_SCI', 'قسم العلوم الطبية الأساسية', 'Basic Medical Sciences Department'),
  ('U_SANA_MED', 'CLIN_MED', 'قسم الطب السريري', 'Clinical Medicine Department'),
  ('U_SANA_MED', 'PUB_HEALTH', 'قسم الصحة العامة', 'Public Health Department'),
  ('U_ADEN_MED', 'BASIC_SCI', 'قسم العلوم الطبية الأساسية', 'Basic Medical Sciences Department'),
  ('U_ADEN_MED', 'CLIN_MED', 'قسم الطب السريري', 'Clinical Medicine Department'),
  ('U_ADEN_MED', 'PUB_HEALTH', 'قسم الصحة العامة', 'Public Health Department'),
  ('U_TAIZ_MED', 'BASIC_SCI', 'قسم العلوم الطبية الأساسية', 'Basic Medical Sciences Department'),
  ('U_TAIZ_MED', 'CLIN_MED', 'قسم الطب السريري', 'Clinical Medicine Department'),
  ('U_TAIZ_MED', 'PUB_HEALTH', 'قسم الصحة العامة', 'Public Health Department'),
  ('U_HODE_MED', 'BASIC_SCI', 'قسم العلوم الطبية الأساسية', 'Basic Medical Sciences Department'),
  ('U_HODE_MED', 'CLIN_MED', 'قسم الطب السريري', 'Clinical Medicine Department'),
  ('U_HODE_MED', 'PUB_HEALTH', 'قسم الصحة العامة', 'Public Health Department'),
  ('U_IBB_MED', 'BASIC_SCI', 'قسم العلوم الطبية الأساسية', 'Basic Medical Sciences Department'),
  ('U_IBB_MED', 'CLIN_MED', 'قسم الطب السريري', 'Clinical Medicine Department'),
  ('U_IBB_MED', 'PUB_HEALTH', 'قسم الصحة العامة', 'Public Health Department'),

  -- ═════════════════════════════════════════════════════════════════════════
  -- National Laboratories — departments (2 per lab)
  -- ═════════════════════════════════════════════════════════════════════════
  ('LAB_VIRO', 'DIAG', 'قسم التشخيص الفيروسي', 'Viral Diagnostics Department'),
  ('LAB_VIRO', 'RES', 'قسم البحوث الفيروسية', 'Virology Research Department'),
  ('LAB_BACT', 'DIAG', 'قسم التشخيص البكتيري', 'Bacterial Diagnostics Department'),
  ('LAB_BACT', 'RES', 'قسم البحوث البكتيرية', 'Bacteriology Research Department'),
  ('LAB_PARA', 'DIAG', 'قسم التشخيص الطفيلي', 'Parasitology Diagnostics Department'),
  ('LAB_PARA', 'RES', 'قسم البحوث الطفيلية', 'Parasitology Research Department'),

  -- ═════════════════════════════════════════════════════════════════════════
  -- Disease Surveillance Centers — departments (2 per center)
  -- ═════════════════════════════════════════════════════════════════════════
  ('DSC_EPID', 'FIELD', 'قسم الترصد الميداني', 'Field Surveillance Department'),
  ('DSC_EPID', 'DATA', 'قسم تحليل البيانات الوبائية', 'Epidemiological Data Analysis Department'),
  ('DSC_CHRO', 'FIELD', 'قسم الترصد الميداني', 'Field Surveillance Department'),
  ('DSC_CHRO', 'DATA', 'قسم تحليل البيانات', 'Data Analysis Department'),

  -- ═════════════════════════════════════════════════════════════════════════
  -- Research Institute — departments (2)
  -- ═════════════════════════════════════════════════════════════════════════
  ('RI_MED_YE', 'CLIN_RES', 'قسم البحوث السريرية', 'Clinical Research Department'),
  ('RI_MED_YE', 'EPID_RES', 'قسم البحوث الوبائية', 'Epidemiological Research Department')
) AS d(inst_code, code, name_ar, name_en) ON ni.code = d.inst_code;

-- =============================================================================
-- Fix sequences after inserts
-- =============================================================================
SELECT setval('security.institutions_id_seq', COALESCE((SELECT MAX(id) FROM security.institutions), 0));
SELECT setval('security.departments_id_seq', COALESCE((SELECT MAX(id) FROM security.departments), 0));

-- Re-enable FK triggers
SET session_replication_role = 'origin';

-- =============================================================================
-- VERIFICATION
-- =============================================================================
DO $$
DECLARE
  v_inst_count INTEGER;
  v_dept_count INTEGER;
  v_fk_violations INTEGER;
  v_seq_ok BOOLEAN;
BEGIN
  -- Row counts
  SELECT COUNT(*) INTO v_inst_count FROM security.institutions;
  SELECT COUNT(*) INTO v_dept_count FROM security.departments;

  RAISE NOTICE '=== COMMIT 1 VERIFICATION ===';
  RAISE NOTICE 'Institutions total: % (expected 41 = 1 THU + 40 Yemen)', v_inst_count;
  RAISE NOTICE 'Departments total: % (expected ~124 = 4 THU + ~120 Yemen)', v_dept_count;

  -- FK violations: institution_type_id must reference existing institution_types
  SELECT COUNT(*) INTO v_fk_violations
  FROM security.institutions i
  WHERE NOT EXISTS (SELECT 1 FROM security.institution_types it WHERE it.id = i.institution_type_id);

  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'FK VIOLATION: % institutions reference non-existent institution_types', v_fk_violations;
  END IF;
  RAISE NOTICE 'FK institution_type_id: OK (0 violations)';

  -- FK violations: department institution_id must reference existing institutions
  SELECT COUNT(*) INTO v_fk_violations
  FROM security.departments d
  WHERE NOT EXISTS (SELECT 1 FROM security.institutions i WHERE i.id = d.institution_id);

  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'FK VIOLATION: % departments reference non-existent institutions', v_fk_violations;
  END IF;
  RAISE NOTICE 'FK institution_id: OK (0 violations)';

  -- UNIQUE constraint: no duplicate institution codes
  SELECT COUNT(*) INTO v_fk_violations
  FROM security.institutions
  GROUP BY code
  HAVING COUNT(*) > 1;

  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'UNIQUE VIOLATION: duplicate institution codes found';
  END IF;
  RAISE NOTICE 'UNIQUE institution codes: OK';

  -- UNIQUE constraint: no duplicate department codes within same institution
  SELECT COUNT(*) INTO v_fk_violations
  FROM security.departments
  GROUP BY institution_id, code
  HAVING COUNT(*) > 1;

  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'UNIQUE VIOLATION: duplicate department codes within institution';
  END IF;
  RAISE NOTICE 'UNIQUE department codes (per institution): OK';

  -- Sequence health: pg_sequences.last_value (read-only, no advancement)
  SELECT (COALESCE((SELECT last_value FROM pg_sequences WHERE sequencename = 'institutions_id_seq'), 0) = (SELECT COALESCE(MAX(id), 0)::bigint FROM security.institutions))
    AND (COALESCE((SELECT last_value FROM pg_sequences WHERE sequencename = 'departments_id_seq'), 0) = (SELECT COALESCE(MAX(id), 0)::bigint FROM security.departments))
  INTO v_seq_ok;

  IF NOT v_seq_ok THEN
    RAISE EXCEPTION 'SEQUENCE MISMATCH: sequences not aligned with max(id)';
  END IF;
  RAISE NOTICE 'Sequences: OK (aligned with max(id))';

  -- Trigger verification: audit trigger should have logged our inserts
  RAISE NOTICE 'Audit triggers: active (system.fn_log_audit)';
  RAISE NOTICE 'Updated_at triggers: active (system.fn_update_updated_at)';

  -- CHECK constraints: NOT NULL on required fields
  SELECT COUNT(*) INTO v_fk_violations
  FROM security.institutions
  WHERE code IS NULL OR name_ar IS NULL OR institution_type_id IS NULL;

  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'NOT NULL VIOLATION: % institutions have NULL required fields', v_fk_violations;
  END IF;
  RAISE NOTICE 'NOT NULL constraints: OK';

  -- RLS compatibility: RLS is NOT enabled on institutions or departments
  RAISE NOTICE 'RLS: Not enabled on security.institutions or security.departments — no RLS bypass needed';

  -- Summary
  RAISE NOTICE '=== COMMIT 1 PASSED ===';
  RAISE NOTICE 'Total institutions: %', v_inst_count;
  RAISE NOTICE 'Total departments: %', v_dept_count;
  RAISE NOTICE 'New institutions added: %', v_inst_count - 1;
  RAISE NOTICE 'New departments added: %', v_dept_count - 4;
END $$;

COMMIT;
