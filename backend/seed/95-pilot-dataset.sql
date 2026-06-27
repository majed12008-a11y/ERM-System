-- ============================================================
-- 95-PILOT-DATASET.SQL — Yemeni Pilot Data for UAT (RC1)
-- Run AFTER: 01-reference.sql → ... → 23-add-audit-columns.sql
-- All UAT passwords: Pilot@1234
-- ============================================================
BEGIN;

SET session_replication_role = replica;

-- ============================================================
-- PART 1: INSTITUTIONS — Yemen Healthcare & Research Ecosystem
-- ============================================================

-- New institution types for pilot
INSERT INTO security.institution_types (code, name_ar, name_en) VALUES
  ('GOVERNMENT', 'جهة حكومية', 'Government Entity'),
  ('NATIONAL_COMMITTEE', 'لجنة وطنية', 'National Committee')
ON CONFLICT (code) DO NOTHING;

-- Yemen Ministry of Health
INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'MOH_YE', 'وزارة الصحة اليمنية', 'Yemen Ministry of Health', 'info@moh-ye.ye', '+967123456700', 'الجمهورية اليمنية - صنعاء - شارع الزبيري', true
FROM security.institution_types WHERE code = 'GOVERNMENT'
AND NOT EXISTS (SELECT 1 FROM security.institutions WHERE code = 'MOH_YE');

-- National Bioethics Committee Yemen
INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'NCBE_YE', 'اللجنة الوطنية للأخلاقيات الحيوية والطبية - اليمن', 'National Bioethics Committee - Yemen', 'info@ncbe-ye.ye', '+967123456701', 'الجمهورية اليمنية - صنعاء - حي السفارات', true
FROM security.institution_types WHERE code = 'NATIONAL_COMMITTEE'
AND NOT EXISTS (SELECT 1 FROM security.institutions WHERE code = 'NCBE_YE');

-- ============================================================
-- PART 2: UAT PILOT USERS (14 users)
-- Roles: 1 admin, 2 coordinators, 2 chairs, 4 members, 5 researchers
-- All passwords: Pilot@1234
-- ============================================================

DO $$
DECLARE
  v_pwd_hash text := '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y';
  v_admin_id bigint;
  v_moh_id bigint;
  v_ncbe_id bigint;
  v_sanaa_id bigint;
  v_aden_id bigint;
  v_hadramout_id bigint;
  v_taiz_id bigint;
  v_thawra_id bigint;
  v_ust_id bigint;
BEGIN
  SELECT id INTO v_admin_id FROM security.users WHERE username = 'admin';
  SELECT id INTO v_moh_id FROM security.institutions WHERE code = 'MOH_YE';
  SELECT id INTO v_ncbe_id FROM security.institutions WHERE code = 'NCBE_YE';
  SELECT id INTO v_sanaa_id FROM security.institutions WHERE code = 'SANAA_U';
  SELECT id INTO v_aden_id FROM security.institutions WHERE code = 'ADEN_U';
  SELECT id INTO v_hadramout_id FROM security.institutions WHERE code = 'HADHRAMAUT_U';
  SELECT id INTO v_taiz_id FROM security.institutions WHERE code = 'TAIZ_U';
  SELECT id INTO v_thawra_id FROM security.institutions WHERE code = 'AL_THAWRA_H';
  SELECT id INTO v_ust_id FROM security.institutions WHERE code = 'SCI_TECH_U';

  -- 1. System Admin — MOH Yemen
  INSERT INTO security.users (institution_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
  VALUES (v_moh_id, 'uat_admin', 'uat.admin@moh-ye.ye', v_pwd_hash, 'مدير', 'النظام', 'System', 'Admin', '+967711111111', 'ACTIVE')
  ON CONFLICT (username) DO NOTHING;

  -- 2-3. Committee Coordinators (ETHICS_ADMIN)
  INSERT INTO security.users (institution_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
  VALUES
    (v_ncbe_id, 'uat_coord1', 'coordinator1@ncbe-ye.ye', v_pwd_hash, 'منسقة', 'اللجنة الوطنية', 'Nadia', 'Alwazir', '+967711111112', 'ACTIVE'),
    (v_sanaa_id, 'uat_coord2', 'coordinator2@su.edu.ye', v_pwd_hash, 'منسق', 'كلية الطب', 'Tariq', 'Alshami', '+967711111113', 'ACTIVE')
  ON CONFLICT (username) DO NOTHING;

  -- 4-5. Committee Chairs (COMMITTEE_CHAIR)
  INSERT INTO security.users (institution_id, department_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
  SELECT v_ncbe_id, NULL, 'uat_chair1', 'chair1@ncbe-ye.ye', v_pwd_hash, 'أستاذ', 'الحكيم', 'Prof', 'Alhakim', '+967711111114', 'ACTIVE'
  WHERE NOT EXISTS (SELECT 1 FROM security.users WHERE username = 'uat_chair1');

  INSERT INTO security.users (institution_id, department_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
  SELECT v_sanaa_id, d.id, 'uat_chair2', 'chair2@su.edu.ye', v_pwd_hash, 'دكتورة', 'المطري', 'Dr', 'Almatari', '+967711111115', 'ACTIVE'
  FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = v_sanaa_id
  AND NOT EXISTS (SELECT 1 FROM security.users WHERE username = 'uat_chair2');

  -- 6-9. Committee Members (REVIEWER role)
  INSERT INTO security.users (institution_id, department_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
  SELECT v_aden_id, d.id, 'uat_member1', 'member1@aden-univ.net', v_pwd_hash, 'دكتور', 'باصهي', 'Dr', 'Bassahi', '+967711111116', 'ACTIVE'
  FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = v_aden_id
  AND NOT EXISTS (SELECT 1 FROM security.users WHERE username = 'uat_member1');

  INSERT INTO security.users (institution_id, department_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
  SELECT v_hadramout_id, d.id, 'uat_member2', 'member2@hu.edu.ye', v_pwd_hash, 'دكتورة', 'بن بريك', 'Dr', 'Binbrik', '+967711111117', 'ACTIVE'
  FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = v_hadramout_id
  AND NOT EXISTS (SELECT 1 FROM security.users WHERE username = 'uat_member2');

  INSERT INTO security.users (institution_id, department_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
  SELECT v_taiz_id, d.id, 'uat_member3', 'member3@taiz.edu.ye', v_pwd_hash, 'دكتور', 'الأصبحي', 'Dr', 'Alasbahi', '+967711111118', 'ACTIVE'
  FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = v_taiz_id
  AND NOT EXISTS (SELECT 1 FROM security.users WHERE username = 'uat_member3');

  INSERT INTO security.users (institution_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
  VALUES (v_thawra_id, 'uat_member4', 'member4@althawra-hospital.ye', v_pwd_hash, 'دكتورة', 'الصبري', 'Dr', 'Alsabri', '+967711111119', 'ACTIVE')
  ON CONFLICT (username) DO NOTHING;

  -- 10-14. Researchers (RESEARCHER role)
  INSERT INTO security.users (institution_id, department_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
  SELECT v_sanaa_id, d.id, 'uat_res1', 'researcher1@su.edu.ye', v_pwd_hash, 'باحثة', 'الحبشي', 'Researcher', 'Alhabashi', '+967711111120', 'ACTIVE'
  FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = v_sanaa_id
  AND NOT EXISTS (SELECT 1 FROM security.users WHERE username = 'uat_res1');

  INSERT INTO security.users (institution_id, department_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
  SELECT v_aden_id, d.id, 'uat_res2', 'researcher2@aden-univ.net', v_pwd_hash, 'باحث', 'بن عيدان', 'Researcher', 'Binaeidan', '+967711111121', 'ACTIVE'
  FROM security.departments d WHERE d.code = 'PHARM' AND d.institution_id = v_aden_id
  AND NOT EXISTS (SELECT 1 FROM security.users WHERE username = 'uat_res2');

  INSERT INTO security.users (institution_id, department_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
  SELECT v_hadramout_id, d.id, 'uat_res3', 'researcher3@hu.edu.ye', v_pwd_hash, 'باحث', 'الكاف', 'Researcher', 'Alkaff', '+967711111122', 'ACTIVE'
  FROM security.departments d WHERE d.code = 'ENV' AND d.institution_id = v_hadramout_id
  AND NOT EXISTS (SELECT 1 FROM security.users WHERE username = 'uat_res3');

  INSERT INTO security.users (institution_id, department_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
  SELECT v_taiz_id, d.id, 'uat_res4', 'researcher4@taiz.edu.ye', v_pwd_hash, 'باحثة', 'المخلافي', 'Researcher', 'Almikhlafi', '+967711111123', 'ACTIVE'
  FROM security.departments d WHERE d.code = 'SCI' AND d.institution_id = v_taiz_id
  AND NOT EXISTS (SELECT 1 FROM security.users WHERE username = 'uat_res4');

  INSERT INTO security.users (institution_id, department_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
  SELECT v_ust_id, d.id, 'uat_res5', 'researcher5@ust.edu.ye', v_pwd_hash, 'باحث', 'العنسي', 'Researcher', 'Alansi', '+967711111124', 'ACTIVE'
  FROM security.departments d WHERE d.code = 'PHARM' AND d.institution_id = v_ust_id
  AND NOT EXISTS (SELECT 1 FROM security.users WHERE username = 'uat_res5');

  -- === ROLE ASSIGNMENTS ===
  -- SUPER_ADMIN
  INSERT INTO security.user_roles (user_id, role_id, assigned_by)
  SELECT u.id, r.id, v_admin_id
  FROM security.users u, security.roles r
  WHERE u.username = 'uat_admin' AND r.code = 'SUPER_ADMIN'
  ON CONFLICT DO NOTHING;

  -- ETHICS_ADMIN (coordinators)
  INSERT INTO security.user_roles (user_id, role_id, assigned_by)
  SELECT u.id, r.id, v_admin_id
  FROM security.users u, security.roles r
  WHERE u.username IN ('uat_coord1', 'uat_coord2') AND r.code = 'ETHICS_ADMIN'
  ON CONFLICT DO NOTHING;

  -- COMMITTEE_CHAIR
  INSERT INTO security.user_roles (user_id, role_id, assigned_by)
  SELECT u.id, r.id, v_admin_id
  FROM security.users u, security.roles r
  WHERE u.username IN ('uat_chair1', 'uat_chair2') AND r.code = 'COMMITTEE_CHAIR'
  ON CONFLICT DO NOTHING;

  -- REVIEWER (committee members)
  INSERT INTO security.user_roles (user_id, role_id, assigned_by)
  SELECT u.id, r.id, v_admin_id
  FROM security.users u, security.roles r
  WHERE u.username IN ('uat_member1', 'uat_member2', 'uat_member3', 'uat_member4') AND r.code = 'REVIEWER'
  ON CONFLICT DO NOTHING;

  -- RESEARCHER
  INSERT INTO security.user_roles (user_id, role_id, assigned_by)
  SELECT u.id, r.id, v_admin_id
  FROM security.users u, security.roles r
  WHERE u.username IN ('uat_res1', 'uat_res2', 'uat_res3', 'uat_res4', 'uat_res5') AND r.code = 'RESEARCHER'
  ON CONFLICT DO NOTHING;
END $$;

-- ============================================================
-- PART 3: COMMITTEES
-- ============================================================

INSERT INTO committee.committee_types (type_code, type_name, description) VALUES
  ('NATIONAL', 'لجنة وطنية', 'National Committee'),
  ('REGIONAL', 'لجنة إقليمية', 'Regional Committee')
ON CONFLICT (type_code) DO NOTHING;

DO $$
DECLARE
  v_national_type_id bigint;
  v_admin_id bigint;
BEGIN
  SELECT id INTO v_national_type_id FROM committee.committee_types WHERE type_code = 'NATIONAL';
  SELECT id INTO v_admin_id FROM security.users WHERE username = 'admin';

  -- NCBE Yemen National Committee
  INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, establishment_date, is_active, created_by)
  SELECT i.id, 'NCBE-YE-001', 'اللجنة الوطنية للأخلاقيات الحيوية والطبية - اليمن', 'National Bioethics Committee - Yemen', v_national_type_id, '2024-06-01', true, v_admin_id
  FROM security.institutions i WHERE i.code = 'NCBE_YE'
  AND NOT EXISTS (SELECT 1 FROM committee.committees WHERE committee_code = 'NCBE-YE-001');

  -- Sana'a University IRB
  INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, establishment_date, is_active, created_by)
  SELECT i.id, 'SANAA-IRB-001', 'لجنة أخلاقيات البحث العلمي - جامعة صنعاء', 'Sana''a University Research Ethics Committee', v_national_type_id, '2024-07-01', true, v_admin_id
  FROM security.institutions i WHERE i.code = 'SANAA_U'
  AND NOT EXISTS (SELECT 1 FROM committee.committees WHERE committee_code = 'SANAA-IRB-001');

  -- Al-Thawra Hospital IRB
  INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, establishment_date, is_active, created_by)
  SELECT i.id, 'THAWRA-IRB-001', 'لجنة أخلاقيات البحث - مستشفى الثورة العام', 'Al-Thawra Hospital Research Ethics Committee', v_national_type_id, '2024-08-01', true, v_admin_id
  FROM security.institutions i WHERE i.code = 'AL_THAWRA_H'
  AND NOT EXISTS (SELECT 1 FROM committee.committees WHERE committee_code = 'THAWRA-IRB-001');

  -- NCBE members
  INSERT INTO committee.committee_members (committee_id, user_id, role_id, membership_start_date, is_active, created_by)
  SELECT c.id, u.id, cr.id, '2024-06-01', true, v_admin_id
  FROM committee.committees c, security.users u, committee.committee_roles cr
  WHERE c.committee_code = 'NCBE-YE-001'
    AND u.username = 'uat_chair1'
    AND cr.role_code = 'CHAIR'
  ON CONFLICT DO NOTHING;

  INSERT INTO committee.committee_members (committee_id, user_id, role_id, membership_start_date, is_active, created_by)
  SELECT c.id, u.id, cr.id, '2024-06-01', true, v_admin_id
  FROM committee.committees c, security.users u, committee.committee_roles cr
  WHERE c.committee_code = 'NCBE-YE-001'
    AND u.username = 'uat_coord1'
    AND cr.role_code = 'SECRETARY'
  ON CONFLICT DO NOTHING;

  INSERT INTO committee.committee_members (committee_id, user_id, role_id, membership_start_date, is_active, created_by)
  SELECT c.id, u.id, cr.id, '2024-06-01', true, v_admin_id
  FROM committee.committees c, security.users u, committee.committee_roles cr
  WHERE c.committee_code = 'NCBE-YE-001'
    AND u.username IN ('uat_member1', 'uat_member2', 'uat_member3')
    AND cr.role_code = 'MEMBER'
  ON CONFLICT DO NOTHING;

  -- Sana'a University IRB members
  INSERT INTO committee.committee_members (committee_id, user_id, role_id, membership_start_date, is_active, created_by)
  SELECT c.id, u.id, cr.id, '2024-07-01', true, v_admin_id
  FROM committee.committees c, security.users u, committee.committee_roles cr
  WHERE c.committee_code = 'SANAA-IRB-001'
    AND u.username = 'uat_chair2'
    AND cr.role_code = 'CHAIR'
  ON CONFLICT DO NOTHING;

  INSERT INTO committee.committee_members (committee_id, user_id, role_id, membership_start_date, is_active, created_by)
  SELECT c.id, u.id, cr.id, '2024-07-01', true, v_admin_id
  FROM committee.committees c, security.users u, committee.committee_roles cr
  WHERE c.committee_code = 'SANAA-IRB-001'
    AND u.username = 'uat_coord2'
    AND cr.role_code = 'SECRETARY'
  ON CONFLICT DO NOTHING;

  INSERT INTO committee.committee_members (committee_id, user_id, role_id, membership_start_date, is_active, created_by)
  SELECT c.id, u.id, cr.id, '2024-07-01', true, v_admin_id
  FROM committee.committees c, security.users u, committee.committee_roles cr
  WHERE c.committee_code = 'SANAA-IRB-001'
    AND u.username IN ('uat_member4', 'uat_member1')
    AND cr.role_code = 'MEMBER'
  ON CONFLICT DO NOTHING;
END $$;

-- ============================================================
-- PART 4: RESEARCH STUDIES (Yemen-Relevant Topics)
-- ============================================================

DO $$
DECLARE
  v_prj_id bigint;
  v_admin_id bigint;
  v_res1_id bigint;
  v_res2_id bigint;
  v_res3_id bigint;
  v_res4_id bigint;
  v_res5_id bigint;
  v_sanaa_id bigint;
  v_aden_id bigint;
  v_hadramout_id bigint;
  v_taiz_id bigint;
  v_ust_id bigint;
  v_ncbe_committee_id bigint;
  v_sanaa_committee_id bigint;
BEGIN
  SELECT id INTO v_admin_id FROM security.users WHERE username = 'admin';
  SELECT id INTO v_res1_id FROM security.users WHERE username = 'uat_res1';
  SELECT id INTO v_res2_id FROM security.users WHERE username = 'uat_res2';
  SELECT id INTO v_res3_id FROM security.users WHERE username = 'uat_res3';
  SELECT id INTO v_res4_id FROM security.users WHERE username = 'uat_res4';
  SELECT id INTO v_res5_id FROM security.users WHERE username = 'uat_res5';
  SELECT id INTO v_sanaa_id FROM security.institutions WHERE code = 'SANAA_U';
  SELECT id INTO v_aden_id FROM security.institutions WHERE code = 'ADEN_U';
  SELECT id INTO v_hadramout_id FROM security.institutions WHERE code = 'HADHRAMAUT_U';
  SELECT id INTO v_taiz_id FROM security.institutions WHERE code = 'TAIZ_U';
  SELECT id INTO v_ust_id FROM security.institutions WHERE code = 'SCI_TECH_U';
  SELECT id INTO v_ncbe_committee_id FROM committee.committees WHERE committee_code = 'NCBE-YE-001';
  SELECT id INTO v_sanaa_committee_id FROM committee.committees WHERE committee_code = 'SANAA-IRB-001';

  -- Study 1: Malaria prevalence in pregnant women (tropical disease — Yemen-relevant)
  INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by)
  VALUES (v_sanaa_id, 'PRJ-SANAA-2026-001',
          'تقييم انتشار الملاريا بين الحوامل في اليمن وتأثيرها على صحة الأم والجنين',
          'Prevalence of Malaria Among Pregnant Women in Yemen and Its Impact on Maternal and Fetal Health',
          'تهدف هذه الدراسة الوبائية إلى تقييم معدل انتشار الملاريا بين النساء الحوامل في ثلاث محافظات يمنية (صنعاء، الحديدة، عدن) وتأثير الإصابة على نتائج الحمل.',
          'تحديد معدل انتشار الملاريا بين الحوامل - تقييم تأثير الإصابة على وزن الجنين ومدة الحمل - تقديم توصيات لبرامج الوقاية',
          v_res1_id, 'INFECTIOUS_DISEASE', 'MEDIUM', 'SUBMITTED', '2026-03-01', '2027-08-31', v_admin_id)
  RETURNING id INTO v_prj_id;

  INSERT INTO core.applications (application_number, project_id, application_type, current_status, submission_date, submitted_by, target_committee_id)
  VALUES ('APP-SANAA-2026-001', v_prj_id, 'INITIAL', 'SUBMITTED', now(), v_res1_id, v_ncbe_committee_id);

  -- Study 2: Cholera outbreak patterns in Yemen (epidemic)
  INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by)
  VALUES (v_aden_id, 'PRJ-ADEN-2026-001',
          'تحليل الأنماط الوبائية لتفشي الكوليرا في اليمن خلال الفترة 2020-2026',
          'Epidemiological Analysis of Cholera Outbreak Patterns in Yemen (2020-2026)',
          'دراسة تحليلية لبيانات تفشي الكوليرا في اليمن بهدف تحديد الأنماط الموسمية والجغرافية وتقييم استجابة النظام الصحي.',
          'تحليل البيانات الوبائية للكوليرا - تحديد عوامل الخطورة - تقييم فعالية التدخلات الصحية',
          v_res2_id, 'PUBLIC_HEALTH', 'MEDIUM', 'DRAFT', '2026-04-01', '2027-03-31', v_admin_id)
  RETURNING id INTO v_prj_id;

  INSERT INTO core.applications (application_number, project_id, application_type, current_status, submitted_by)
  VALUES ('APP-ADEN-2026-001', v_prj_id, 'INITIAL', 'DRAFT', v_res2_id);

  -- Study 3: Malnutrition in children under 5 in Yemen
  INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by)
  VALUES (v_hadramout_id, 'PRJ-HADRAMOUT-2026-001',
          'تقييم سوء التغذية لدى الأطفال دون سن الخامسة في المناطق الساحلية والجبلية باليمن',
          'Assessment of Malnutrition Among Children Under Five in Coastal and Mountainous Regions of Yemen',
          'دراسة مقارنة تقيم معدلات سوء التغذية بين الأطفال في المناطق الساحلية (حضرموت) والجبلية (صنعاء) وتحديد العوامل المساهمة.',
          'قياس مؤشرات سوء التغذية - مقارنة المناطق الساحلية والجبلية - تقديم توصيات غذائية',
          v_res3_id, 'PUBLIC_HEALTH', 'MEDIUM', 'SUBMITTED', '2026-05-15', '2027-11-14', v_admin_id)
  RETURNING id INTO v_prj_id;

  INSERT INTO core.applications (application_number, project_id, application_type, current_status, submission_date, submitted_by, target_committee_id)
  VALUES ('APP-HADRAMOUT-2026-001', v_prj_id, 'INITIAL', 'SUBMITTED', now(), v_res3_id, v_sanaa_committee_id);

  -- Study 4: Khat chewing effects on pregnancy outcomes
  INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by)
  VALUES (v_taiz_id, 'PRJ-TAIZ-2026-001',
          'تأثير تعاطي القات على نتائج الحمل وصحة المواليد في محافظة تعز',
          'Effect of Khat Chewing on Pregnancy Outcomes and Newborn Health in Taiz Governorate',
          'دراسة مقطعية تقيم تأثير تعاطي القات أثناء الحمل على نتائج الحمل وصحة المواليد في مستشفيات محافظة تعز.',
          'تقييم العلاقة بين تعاطي القات ووزن المواليد - قياس معدلات الإجهاض والولادة المبكرة',
          v_res4_id, 'REPRODUCTIVE_HEALTH', 'HIGH', 'DRAFT', '2026-06-01', '2027-05-31', v_admin_id)
  RETURNING id INTO v_prj_id;

  INSERT INTO core.applications (application_number, project_id, application_type, current_status, submitted_by)
  VALUES ('APP-TAIZ-2026-001', v_prj_id, 'INITIAL', 'DRAFT', v_res4_id);

  -- Study 5: Dengue fever vector surveillance in Hodeidah
  INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by)
  VALUES (v_ust_id, 'PRJ-UST-2026-001',
          'ترصد نواقل حمى الضنك في محافظة الحديدة وتقييم فعالية مكافحتها',
          'Dengue Fever Vector Surveillance in Hodeidah Governorate and Control Effectiveness Assessment',
          'دراسة حقلية لترصد بعوض الزاعجة (Aedes) المسبب لحمى الضنك في الحديدة وتقييم فعالية برامج المكافحة الحالية.',
          'ترصد كثافة البعوض الناقل - تحديد بؤر التفشي - تقييم فعالية المبيدات المستخدمة',
          v_res5_id, 'INFECTIOUS_DISEASE', 'MEDIUM', 'SUBMITTED', '2026-07-01', '2027-12-31', v_admin_id)
  RETURNING id INTO v_prj_id;

  INSERT INTO core.applications (application_number, project_id, application_type, current_status, submission_date, submitted_by, target_committee_id)
  VALUES ('APP-UST-2026-001', v_prj_id, 'INITIAL', 'SUBMITTED', now(), v_res5_id, v_ncbe_committee_id);
END $$;

-- ============================================================
-- PART 5: NCBE UAT MEETING
-- ============================================================

DO $$
DECLARE
  v_ncbe_id bigint;
  v_chair_id bigint;
  v_coord_id bigint;
  v_meeting_id bigint;
BEGIN
  SELECT id INTO v_ncbe_id FROM committee.committees WHERE committee_code = 'NCBE-YE-001';
  SELECT id INTO v_chair_id FROM security.users WHERE username = 'uat_chair1';
  SELECT id INTO v_coord_id FROM security.users WHERE username = 'uat_coord1';

  INSERT INTO committee.committee_meetings (committee_id, meeting_number, meeting_date, location, meeting_status, chairperson_id, created_by)
  VALUES (v_ncbe_id, 'MTG-NCBE-2026-001', '2026-08-15 10:00:00+03', 'قاعة الاجتماعات الرئيسية - اللجنة الوطنية للأخلاقيات - صنعاء', 'SCHEDULED', v_chair_id, v_coord_id)
  RETURNING id INTO v_meeting_id;

  INSERT INTO committee.meeting_agendas (meeting_id, title, description, created_by)
  VALUES
    (v_meeting_id, 'مراجعة جدول الأعمال والموافقة على محضر الاجتماع السابق', 'مراجعة جدول أعمال الاجتماع الأول للجنة الوطنية والموافقة على محضر الاجتماع التأسيسي', v_coord_id),
    (v_meeting_id, 'مناقشة طلب الموافقة على دراسة: انتشار الملاريا بين الحوامل', 'مناقشة طلب الموافقة على البحث المقدم من جامعة صنعاء حول الملاريا والحوامل', v_coord_id),
    (v_meeting_id, 'مناقشة طلب الموافقة على دراسة: ترصد نواقل حمى الضنك', 'مناقشة طلب الموافقة على البحث المقدم من جامعة العلوم والتكنولوجيا حول حمى الضنك', v_coord_id),
    (v_meeting_id, 'مناقشة طلب الموافقة على دراسة: سوء التغذية لدى الأطفال', 'مناقشة طلب الموافقة على البحث المقدم من جامعة حضرموت', v_coord_id),
    (v_meeting_id, 'تحديث حول أنشطة اللجنة والتقارير الواردة', 'عرض تقارير الأنشطة السابقة والإنجازات والتحديات', v_coord_id);

  INSERT INTO committee.attendance_logs (meeting_id, user_id, attendance_status, created_by)
  SELECT v_meeting_id, cm.user_id, 'PRESENT', v_coord_id
  FROM committee.committee_members cm
  WHERE cm.committee_id = v_ncbe_id AND cm.is_active = true;
END $$;

-- ============================================================
-- PART 6: REVIEW FORMS & ASSIGNMENTS
-- ============================================================

DO $$
DECLARE
  v_form_id bigint;
  v_coord_id bigint;
  v_rev1_id bigint;
  v_rev2_id bigint;
  v_rev3_id bigint;
  v_app1_id bigint;
  v_app3_id bigint;
  v_app5_id bigint;
BEGIN
  SELECT id INTO v_coord_id FROM security.users WHERE username = 'uat_coord1';
  SELECT id INTO v_rev1_id FROM security.users WHERE username = 'uat_member1';
  SELECT id INTO v_rev2_id FROM security.users WHERE username = 'uat_member2';
  SELECT id INTO v_rev3_id FROM security.users WHERE username = 'uat_member3';

  SELECT MAX(a.id) INTO v_app1_id FROM core.applications a JOIN core.projects p ON a.project_id = p.id WHERE p.project_code = 'PRJ-SANAA-2026-001';
  SELECT MAX(a.id) INTO v_app3_id FROM core.applications a JOIN core.projects p ON a.project_id = p.id WHERE p.project_code = 'PRJ-HADRAMOUT-2026-001';
  SELECT MAX(a.id) INTO v_app5_id FROM core.applications a JOIN core.projects p ON a.project_id = p.id WHERE p.project_code = 'PRJ-UST-2026-001';

  -- Create review form
  INSERT INTO committee.review_forms (form_code, form_name, review_type, is_active, created_by)
  VALUES ('NCBE-YE-STD-001', 'نموذج المراجعة الأخلاقية الموحد - اللجنة الوطنية اليمنية', 'ETHICAL', true, v_coord_id)
  ON CONFLICT (form_code, version_no) DO NOTHING
  RETURNING id INTO v_form_id;

  SELECT id INTO v_form_id FROM committee.review_forms WHERE form_code = 'NCBE-YE-STD-001';

  -- Questions
  INSERT INTO committee.review_questions (form_id, question_code, question_text, question_type, display_order, is_required, created_by)
  VALUES
    (v_form_id, 'Q01', 'هل تصميم الدراسة مناسب لتحقيق أهداف البحث؟', 'BOOLEAN', 1, true, v_coord_id),
    (v_form_id, 'Q02', 'هل تم الحصول على الموافقة المستنيرة بشكل مناسب؟', 'BOOLEAN', 2, true, v_coord_id),
    (v_form_id, 'Q03', 'هل المخاطر المتوقعة مقبولة مقارنة بالفوائد المحتملة؟', 'BOOLEAN', 3, true, v_coord_id),
    (v_form_id, 'Q04', 'هل خطة حماية البيانات والمعلومات الحساسة كافية؟', 'BOOLEAN', 4, true, v_coord_id),
    (v_form_id, 'Q05', 'هل فريق البحث مؤهل لتنفيذ هذه الدراسة؟', 'BOOLEAN', 5, true, v_coord_id),
    (v_form_id, 'Q06', 'التوصية العامة', 'CHOICE', 6, true, v_coord_id),
    (v_form_id, 'Q07', 'ملاحظات إضافية', 'TEXT', 7, false, v_coord_id)
  ON CONFLICT DO NOTHING;

  UPDATE committee.review_questions
  SET question_options = '["APPROVE","REJECT","REVISIONS_REQUIRED"]'::jsonb
  WHERE form_id = v_form_id AND question_code = 'Q06';

  -- Assign reviewers
  IF v_app1_id IS NOT NULL THEN
    INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date, status_code)
    VALUES (v_app1_id, v_rev1_id, 'ETHICAL', v_coord_id, '2026-08-10 23:59:59+03', 'ASSIGNED');

    INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date, status_code)
    VALUES (v_app1_id, v_rev2_id, 'ETHICAL', v_coord_id, '2026-08-10 23:59:59+03', 'ASSIGNED');
  END IF;

  IF v_app3_id IS NOT NULL THEN
    INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date, status_code)
    VALUES (v_app3_id, v_rev3_id, 'ETHICAL', v_coord_id, '2026-08-12 23:59:59+03', 'ASSIGNED');
  END IF;

  IF v_app5_id IS NOT NULL THEN
    INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date, status_code)
    VALUES (v_app5_id, v_rev1_id, 'ETHICAL', v_coord_id, '2026-08-15 23:59:59+03', 'ASSIGNED');

    INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date, status_code)
    VALUES (v_app5_id, v_rev3_id, 'ETHICAL', v_coord_id, '2026-08-15 23:59:59+03', 'ASSIGNED');
  END IF;
END $$;

-- ============================================================
-- PART 7: SAFETY DATA
-- ============================================================

DO $$
DECLARE
  v_res1_id bigint;
  v_admin_id bigint;
  v_app1_id bigint;
BEGIN
  SELECT id INTO v_admin_id FROM security.users WHERE username = 'admin';
  SELECT id INTO v_res1_id FROM security.users WHERE username = 'uat_res1';
  SELECT MAX(a.id) INTO v_app1_id FROM core.applications a JOIN core.projects p ON a.project_id = p.id WHERE p.project_code = 'PRJ-SANAA-2026-001';

  IF v_app1_id IS NOT NULL THEN
    INSERT INTO safety.adverse_events (application_id, event_number, participant_reference, event_date, event_type, severity, expectedness, relatedness, description, outcome_status, reported_by)
    VALUES (v_app1_id, 'AE-NCBE-2026-001', 'P-1042', '2026-08-01', 'MINOR', 'MILD', 'UNEXPECTED', 'POSSIBLE', 'أبلغت إحدى المشاركات عن صداع خفيف استمر لمدة ساعتين بعد جمع العينة الدموية الثانية.', 'RECOVERED', v_res1_id);

    INSERT INTO safety.risk_register (risk_code, risk_title, risk_description, likelihood, impact, risk_level, owner_id, status, identified_by)
    VALUES ('RISK-NCBE-YE-001', 'مخاطر جمع البيانات الحساسة', 'احتمالية تسرب البيانات الشخصية للمشاركات في دراسة الملاريا', 3, 4, 'HIGH', v_res1_id, 'IDENTIFIED', v_admin_id);

    INSERT INTO safety.risk_register (risk_code, risk_title, risk_description, likelihood, impact, risk_level, owner_id, status, identified_by)
    VALUES ('RISK-NCBE-YE-002', 'مخاطر الوصول للمناطق النائية', 'صعوبة الوصول للمناطق الريفية في الحديدة لجمع العينات بسبب الوضع الأمني', 4, 3, 'HIGH', v_res1_id, 'IDENTIFIED', v_admin_id);

    INSERT INTO safety.risk_register (risk_code, risk_title, risk_description, likelihood, impact, risk_level, owner_id, status, identified_by)
    VALUES ('RISK-NCBE-YE-003', 'مخاطر التعامل مع العينات البيولوجية', 'احتمالية التعرض للعدوى أثناء جمع عينات الدم من المشاركات', 2, 3, 'MEDIUM', v_res1_id, 'IDENTIFIED', v_admin_id);
  END IF;
END $$;

-- ============================================================
-- PART 8: SUMMARY
-- ============================================================

SET session_replication_role = origin;

COMMIT;

DO $$
DECLARE
  v_user_count integer;
  v_institution_count integer;
  v_committee_count integer;
  v_project_count integer;
  v_application_count integer;
BEGIN
  SELECT COUNT(*) INTO v_user_count FROM security.users;
  SELECT COUNT(*) INTO v_institution_count FROM security.institutions;
  SELECT COUNT(*) INTO v_committee_count FROM committee.committees;
  SELECT COUNT(*) INTO v_project_count FROM core.projects;
  SELECT COUNT(*) INTO v_application_count FROM core.applications;

  RAISE NOTICE '====================================================';
  RAISE NOTICE 'UAT Pilot Dataset Summary — Yemen';
  RAISE NOTICE '====================================================';
  RAISE NOTICE 'Users:          % (14 UAT pilot users added)', v_user_count;
  RAISE NOTICE 'Institutions:   %', v_institution_count;
  RAISE NOTICE 'Committees:     %', v_committee_count;
  RAISE NOTICE 'Projects:       % (5 Yemen-relevant studies)', v_project_count;
  RAISE NOTICE 'Applications:   %', v_application_count;
  RAISE NOTICE 'Password:       Pilot@1234 for all UAT accounts';
  RAISE NOTICE '====================================================';
END $$;