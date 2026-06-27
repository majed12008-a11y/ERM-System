SET app.user_id = '0';
BEGIN;

-- ============================================================
-- 96-REALISTIC-YEMENI-DATA.SQL
-- Hierarchical realistic dataset for Yemen MOH ethics system
-- ============================================================

-- ============================================================
-- 1. INSTITUTIONS & TYPES
-- ============================================================
INSERT INTO security.institution_types (code, name_ar, name_en) VALUES
  ('UNIVERSITY', 'جامعة', 'University'),
  ('HOSPITAL', 'مستشفى', 'Hospital'),
  ('GOVERNMENT', 'جهة حكومية', 'Government Body'),
  ('RESEARCH_CENTER', 'مركز أبحاث', 'Research Center')
ON CONFLICT (code) DO NOTHING;

INSERT INTO security.institutions (code, name_ar, name_en, institution_type_id, address) VALUES
  ('SANAA_U', 'جامعة صنعاء', 'Sana''a University', (SELECT id FROM security.institution_types WHERE code = 'UNIVERSITY'), 'الجمهورية اليمنية - صنعاء - شارع الستين'),
  ('ADEN_U', 'جامعة عدن', 'University of Aden', (SELECT id FROM security.institution_types WHERE code = 'UNIVERSITY'), 'الجمهورية اليمنية - عدن - خور مكسر'),
  ('TAIZ_U', 'جامعة تعز', 'Taiz University', (SELECT id FROM security.institution_types WHERE code = 'UNIVERSITY'), 'الجمهورية اليمنية - تعز - جبل حدة'),
  ('IBB_U', 'جامعة إب', 'Ibb University', (SELECT id FROM security.institution_types WHERE code = 'UNIVERSITY'), 'الجمهورية اليمنية - إب - صبرة'),
  ('DHAMAR_U', 'جامعة ذمار', 'Thamar University', (SELECT id FROM security.institution_types WHERE code = 'UNIVERSITY'), 'الجمهورية اليمنية - ذمار - جامعة ذمار'),
  ('HADHRAMOUT_U', 'جامعة حضرموت', 'Hadhramout University', (SELECT id FROM security.institution_types WHERE code = 'UNIVERSITY'), 'الجمهورية اليمنية - حضرموت - المكلا - فوة'),
  ('MOH_YE', 'وزارة الصحة العامة والسكان', 'Ministry of Public Health and Population', (SELECT id FROM security.institution_types WHERE code = 'GOVERNMENT'), 'الجمهورية اليمنية - صنعاء - شارع الزبيري'),
  ('ALTHAWRA_H', 'مستشفى الثورة العام', 'Al-Thawra General Hospital', (SELECT id FROM security.institution_types WHERE code = 'HOSPITAL'), 'الجمهورية اليمنية - صنعاء - شارع الثورة'),
  ('KUWAIT_H', 'مستشفى الكويت الجامعي', 'Kuwait University Hospital', (SELECT id FROM security.institution_types WHERE code = 'HOSPITAL'), 'الجمهورية اليمنية - صنعاء - حي الجامعة'),
  ('ALJOMHORI_H', 'مستشفى الجمهوري التعليمي', 'Al-Jomhori Teaching Hospital', (SELECT id FROM security.institution_types WHERE code = 'HOSPITAL'), 'الجمهورية اليمنية - صنعاء - شارع الجمهوري'),
  ('SABAEEN_H', 'مستشفى السبعين للأمومة والطفولة', 'Sabaeen Maternal and Child Hospital', (SELECT id FROM security.institution_types WHERE code = 'HOSPITAL'), 'الجمهورية اليمنية - صنعاء - شارع السبعين'),
  ('IBNSINA_H', 'مستشفى ابن سينا', 'Ibn Sina Hospital', (SELECT id FROM security.institution_types WHERE code = 'HOSPITAL'), 'الجمهورية اليمنية - حضرموت - المكلا - طريق الشاطئ'),
  ('NCBE_YE', 'المركز الوطني للبحوث والأخلاقيات الحيوية', 'National Center for Research and Bioethics', (SELECT id FROM security.institution_types WHERE code = 'RESEARCH_CENTER'), 'الجمهورية اليمنية - صنعاء - شارع جامعة صنعاء')
ON CONFLICT (code) DO UPDATE SET name_ar = EXCLUDED.name_ar;

-- ============================================================
-- 2. DEPARTMENTS
-- ============================================================
DO $$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN SELECT id, code FROM security.institutions WHERE code IN ('SANAA_U','ADEN_U','TAIZ_U','IBB_U','DHAMAR_U','HADHRAMOUT_U') LOOP
    INSERT INTO security.departments (institution_id, code, name_ar, name_en) VALUES
      (rec.id, 'MED_'||rec.code, 'كلية الطب والعلوم الصحية', 'College of Medicine and Health Sciences'),
      (rec.id, 'DENT_'||rec.code, 'كلية طب الأسنان', 'College of Dentistry'),
      (rec.id, 'PHARM_'||rec.code, 'كلية الصيدلة', 'College of Pharmacy'),
      (rec.id, 'NURS_'||rec.code, 'كلية التمريض', 'College of Nursing'),
      (rec.id, 'PUBH_'||rec.code, 'كلية الصحة العامة', 'College of Public Health'),
      (rec.id, 'LABS_'||rec.code, 'كلية العلوم الطبية المخبرية', 'College of Medical Laboratory Sciences')
    ON CONFLICT (institution_id, code) DO NOTHING;
  END LOOP;

  FOR rec IN SELECT id, code FROM security.institutions WHERE code IN ('ALTHAWRA_H','KUWAIT_H','ALJOMHORI_H','SABAEEN_H','IBNSINA_H') LOOP
    INSERT INTO security.departments (institution_id, code, name_ar, name_en)
    VALUES (rec.id, 'CLINIC_'||rec.code, 'قسم العيادات', 'Clinical Department')
    ON CONFLICT (institution_id, code) DO NOTHING;
  END LOOP;

  INSERT INTO security.departments (institution_id, code, name_ar, name_en)
  SELECT id, 'DIR_RESEARCH', 'الإدارة العامة للبحوث الصحية', 'General Directorate of Health Research'
  FROM security.institutions WHERE code = 'NCBE_YE'
  ON CONFLICT (institution_id, code) DO NOTHING;

  INSERT INTO security.departments (institution_id, code, name_ar, name_en)
  SELECT id, 'DIR_ETHICS', 'الإدارة العامة للأخلاقيات الحيوية', 'General Directorate of Bioethics'
  FROM security.institutions WHERE code = 'NCBE_YE'
  ON CONFLICT (institution_id, code) DO NOTHING;
END;
$$;

-- ============================================================
-- 3. COMMITTEE TYPES & COMMITTEES
-- ============================================================
INSERT INTO committee.committee_types (type_code, type_name, description) VALUES
  ('NATIONAL', 'اللجنة الوطنية العليا للأخلاقيات الحيوية', 'Supreme National Bioethics Committee'),
  ('TEACHING_HOSP', 'لجنة أخلاقيات المستشفيات التعليمية', 'Teaching Hospitals Ethics Committee'),
  ('PUBLIC_HEALTH', 'لجنة أخلاقيات أبحاث الصحة العامة', 'Public Health Research Ethics Committee'),
  ('INFECTIOUS', 'لجنة أخلاقيات أبحاث الأمراض السارية', 'Infectious Disease Research Ethics Committee'),
  ('MATERNAL_CHILD', 'لجنة أخلاقيات أبحاث الأمومة والطفولة', 'Maternal and Child Health Research Ethics Committee'),
  ('NUTRITION', 'لجنة أخلاقيات أبحاث التغذية', 'Nutrition Research Ethics Committee'),
  ('LAB_RESEARCH', 'لجنة أخلاقيات الأبحاث المخبرية', 'Laboratory Research Ethics Committee'),
  ('CLINICAL_TRIAL', 'لجنة أخلاقيات التجارب السريرية', 'Clinical Trial Ethics Committee')
ON CONFLICT (type_code) DO NOTHING;

DO $$
DECLARE
  v_ncbe_id BIGINT;
BEGIN
  SELECT id INTO v_ncbe_id FROM security.institutions WHERE code = 'NCBE_YE';
  INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, is_active) VALUES
    (v_ncbe_id, 'NCBE-NAT-01', 'اللجنة الوطنية العليا للأخلاقيات الحيوية', 'National Supreme Bioethics Committee', (SELECT id FROM committee.committee_types WHERE type_code='NATIONAL'), true),
    (v_ncbe_id, 'NCBE-TH-01', 'لجنة أخلاقيات أبحاث المستشفيات التعليمية', 'Teaching Hospital Research Ethics Committee', (SELECT id FROM committee.committee_types WHERE type_code='TEACHING_HOSP'), true),
    (v_ncbe_id, 'NCBE-PH-01', 'لجنة أخلاقيات أبحاث الصحة العامة', 'Public Health Research Ethics Committee', (SELECT id FROM committee.committee_types WHERE type_code='PUBLIC_HEALTH'), true),
    (v_ncbe_id, 'NCBE-ID-01', 'لجنة أخلاقيات أبحاث الأمراض السارية', 'Infectious Disease Research Ethics Committee', (SELECT id FROM committee.committee_types WHERE type_code='INFECTIOUS'), true),
    (v_ncbe_id, 'NCBE-MC-01', 'لجنة أخلاقيات أبحاث الأمومة والطفولة', 'Maternal and Child Health Research Ethics Committee', (SELECT id FROM committee.committee_types WHERE type_code='MATERNAL_CHILD'), true),
    (v_ncbe_id, 'NCBE-NUT-01', 'لجنة أخلاقيات أبحاث التغذية', 'Nutrition Research Ethics Committee', (SELECT id FROM committee.committee_types WHERE type_code='NUTRITION'), true),
    (v_ncbe_id, 'NCBE-LAB-01', 'لجنة أخلاقيات الأبحاث المخبرية', 'Laboratory Research Ethics Committee', (SELECT id FROM committee.committee_types WHERE type_code='LAB_RESEARCH'), true),
    (v_ncbe_id, 'NCBE-CT-01', 'لجنة أخلاقيات التجارب السريرية', 'Clinical Trial Ethics Committee', (SELECT id FROM committee.committee_types WHERE type_code='CLINICAL_TRIAL'), true)
  ON CONFLICT (committee_code) DO UPDATE SET committee_name_ar = EXCLUDED.committee_name_ar;
END;
$$;

-- ============================================================
-- 4. USERS (all roles)
-- ============================================================
DO $$
DECLARE
  fn_ar TEXT[] := ARRAY['أحمد','محمد','علي','خالد','عمر','عبدالله','حسن','حسين','ياسر','ناصر',
    'ماجد','فهد','سامي','وائل','نبيل','جمال','هاني','أيمن','باسم','فارس',
    'مروان','غسان','أكرم','رامي','بدر','شوقي','هشام','إبراهيم','إسماعيل','حمزة',
    'فاطمة','مريم','نورة','سارة','هدى','أمل','نادية','ليلى','سامية','خديجة',
    'عائشة','رنا','عفاف','جميلة','نبيلة','بهيجة','منى','سحر','إيمان','غادة',
    'ابتسام','آمال','بشرى','تهاني','حنان','رجاء','زينب','سلوى','شيماء','صباح',
    'إياد','بسام','تميم','جابر','جهاد','حارث','رياض','زياد','سالم','سهيل',
    'صادق','صالح','صلاح','ضياء','طارق','عادل','عباس','علاء','عمار','قتيبة'];
  ln_ar TEXT[] := ARRAY['القباطي','الحكمي','المخلافي','النزيلي','الصبري','العدني','الحميري','الشميري','المطري','الكحلاني',
    'العنسي','الذهبي','المؤيد','الهتار','الدبعي','الشوكاني','الأكوع','البخيتي','الجعدي','الحجي',
    'الحرازي','الخولاني','الدغيش','الرازحي','الزبيري','السفياني','الشامي','الصالحي','الضبي','الظفاري',
    'العامري','العريقي','العزي','العولقي','الغابري','الغالبي','الغشمي','الفضلي','القرشي','القطني',
    'اللاحجي','المتوكل','المجيدي','المحضار','المرادي','المزجاجي','المسلطي','المعزبي','المغربي','المنصور',
    'المهدي','النبهاني','النعمان','الهاشمي','الهندواني','الوجيه','الوزير','اليافعي','باذيب','بن بريك',
    'بن دغر','بن مسلم','حيدرة','خنبشي','دحان','سعيد','سنيد','شرف','شعلان','شيخ',
    'صبره','طاهر','عبدالوهاب','عبيد','عقلان','عمران','قايد','لطف','نعمان','هاشم'];
  fn_en TEXT[] := ARRAY['Ahmed','Mohammed','Ali','Khaled','Omar','Abdullah','Hassan','Hussein','Yasser','Naser',
    'Majed','Fahd','Sami','Wael','Nabil','Jamal','Hani','Ayman','Basem','Fares',
    'Marwan','Ghassan','Akram','Rami','Badr','Shawqi','Hisham','Ibrahim','Ismail','Hamza',
    'Fatima','Maryam','Noura','Sara','Huda','Amal','Nadia','Laila','Samia','Khadija',
    'Aisha','Rana','Afaf','Jamila','Nabila','Bahija','Mona','Sahar','Iman','Ghada',
    'Abtisam','Amal','Bushra','Tahani','Hanan','Raja','Zainab','Salwa','Shaima','Sabah',
    'Iyad','Bassam','Tamim','Jaber','Jihad','Hareth','Riyad','Ziyad','Salem','Suhail',
    'Sadiq','Saleh','Salah','Dhiya','Tariq','Adel','Abbas','Alaa','Ammar','Qutaiba'];
  ln_en TEXT[] := ARRAY['Alqabati','Alhakami','Almekhlafi','Alnezili','Alsabri','Aladni','Alhamiri','Alshamiri','Almatri','Alkahlni',
    'Alansi','Aldhahabi','Almuayad','Alhatar','Aldabai','Alshawkany','Alakwa','Albukhaiti','Aljadi','Alhaji',
    'Alharazi','Alkhawlani','Aldaghesh','Alrazahi','Alzubairi','Alsufyani','Alshami','Alsalehi','Aldhabi','Aldhafari',
    'Alameri','Alariki','Alazzi','Alawlaqi','Alghabri','Alghalibi','Alghashmi','Alfadhli','Alqurashi','Alqutni',
    'Allahji','Almutawakkil','Almajidi','Almihdhar','Almaradi','Almizjaji','Almaslati','Almaazbi','Almaghribi','Almansour',
    'Almahdi','Alnabhani','Alnuman','Alhashimi','Alhindwani','Alwajih','Alwazir','Al yafei','Bathib','Bin brek',
    'Bin dagher','Bin muslim','Haidara','Khanbashi','Dahan','Saeed','Sunaid','Sharaf','Shalaan','Sheikh',
    'Sabrah','Taher','Abdulwahab','Obaid','Aqlan','Omran','Qaid','Lutfi','Noman','Hashim'];
  v_pw TEXT := '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw';
  v_inst_ids BIGINT[]; v_ncbe_id BIGINT; v_moh_id BIGINT;
  i INT; j INT; k INT;
BEGIN
  SELECT id INTO v_ncbe_id FROM security.institutions WHERE code = 'NCBE_YE';
  SELECT id INTO v_moh_id FROM security.institutions WHERE code = 'MOH_YE';
  v_inst_ids := ARRAY(SELECT id FROM security.institutions WHERE code IN ('SANAA_U','ADEN_U','TAIZ_U','IBB_U','DHAMAR_U','HADHRAMOUT_U') ORDER BY code);

  -- National admin
  INSERT INTO security.users (institution_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
  VALUES (v_ncbe_id, 'national_admin', 'national.admin@ncbe.ye', v_pw, 'عبدالملك', 'الهتار', 'Abdulmalik', 'Alhatar', '+967700000001', 'ACTIVE')
  ON CONFLICT (username) DO NOTHING;

  -- 5 coordinators
  FOR i IN 1..5 LOOP
    INSERT INTO security.users (institution_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
    VALUES (v_ncbe_id, 'coordinator_'||i, 'coordinator'||i||'@ncbe.ye', v_pw, fn_ar[i], ln_ar[i], fn_en[i], ln_en[i], '+967711'||LPAD(i::TEXT,4,'0'), 'ACTIVE')
    ON CONFLICT (username) DO NOTHING;
  END LOOP;

  -- 8 chairs
  FOR i IN 1..8 LOOP
    INSERT INTO security.users (institution_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
    VALUES (v_ncbe_id, 'chair_'||i, 'chair'||i||'@ncbe.ye', v_pw, fn_ar[10+i], ln_ar[10+i], fn_en[10+i], ln_en[10+i], '+967722'||LPAD(i::TEXT,4,'0'), 'ACTIVE')
    ON CONFLICT (username) DO NOTHING;
  END LOOP;

  -- 8 coordinators per committee
  FOR i IN 1..8 LOOP
    INSERT INTO security.users (institution_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
    VALUES (v_ncbe_id, 'cmte_coord_'||i, 'cmte.coord'||i||'@ncbe.ye', v_pw, fn_ar[20+i], ln_ar[20+i], fn_en[20+i], ln_en[20+i], '+967733'||LPAD(i::TEXT,4,'0'), 'ACTIVE')
    ON CONFLICT (username) DO NOTHING;
  END LOOP;

  -- 40 reviewers
  FOR i IN 1..40 LOOP
    j := (i % 80) + 1; k := ((i*3) % 80) + 1;
    INSERT INTO security.users (institution_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
    VALUES (v_ncbe_id, 'reviewer_'||i, 'reviewer'||i||'@ncbe.ye', v_pw, fn_ar[j], ln_ar[k], fn_en[j], ln_en[k], '+967744'||LPAD(i::TEXT,4,'0'), 'ACTIVE')
    ON CONFLICT (username) DO NOTHING;
  END LOOP;

  -- 80 committee members
  FOR i IN 1..80 LOOP
    j := ((i*7) % 80) + 1; k := ((i*13) % 80) + 1;
    INSERT INTO security.users (institution_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
    VALUES (v_ncbe_id, 'member_'||i, 'member'||i||'@ncbe.ye', v_pw, fn_ar[j], ln_ar[k], fn_en[j], ln_en[k], '+967755'||LPAD(i::TEXT,4,'0'), 'ACTIVE')
    ON CONFLICT (username) DO NOTHING;
  END LOOP;

  -- 100 researchers (distributed across universities)
  FOR i IN 1..100 LOOP
    j := ((i*17+3) % 80) + 1; k := ((i*23+7) % 80) + 1;
    INSERT INTO security.users (institution_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
    VALUES (v_inst_ids[((i-1)%6)+1], 'researcher_'||i, 'researcher'||i||'@univ.ye', v_pw, fn_ar[j], ln_ar[k], fn_en[j], ln_en[k], '+967766'||LPAD(i::TEXT,4,'0'), 'ACTIVE')
    ON CONFLICT (username) DO NOTHING;
  END LOOP;

  -- 50 assistant researchers
  FOR i IN 1..50 LOOP
    j := ((i*29+11) % 80) + 1; k := ((i*37+13) % 80) + 1;
    INSERT INTO security.users (institution_id, username, email, password_hash, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
    VALUES (v_inst_ids[((i-1)%6)+1], 'assistant_'||i, 'assistant'||i||'@univ.ye', v_pw, fn_ar[j], ln_ar[k], fn_en[j], ln_en[k], '+967777'||LPAD(i::TEXT,4,'0'), 'ACTIVE')
    ON CONFLICT (username) DO NOTHING;
  END LOOP;
END;
$$;

-- ============================================================
-- 5. USER PROFILES (Yemeni national IDs, DOB, gender)
-- ============================================================
DO $$
DECLARE
  u RECORD; i INT; v_nid TEXT; v_gender TEXT; v_dob DATE; v_title TEXT; v_spec TEXT;
BEGIN
  i := 0;
  FOR u IN SELECT id, username, first_name_ar, first_name_en FROM security.users WHERE username NOT LIKE 'assistant_%' ORDER BY id LOOP
    i := i + 1;
    v_nid := LPAD((1000000000 + i)::TEXT, 10, '0');
    IF u.first_name_en IN ('Fatima','Maryam','Noura','Sara','Huda','Amal','Nadia','Laila','Samia','Khadija',
      'Aisha','Rana','Afaf','Jamila','Nabila','Bahija','Mona','Sahar','Iman','Ghada',
      'Abtisam','Bushra','Tahani','Hanan','Raja','Zainab','Salwa','Shaima','Sabah') THEN
      v_gender := 'FEMALE';
    ELSE
      v_gender := 'MALE';
    END IF;
    v_dob := '1960-01-01'::date + (random()*12000)::int;
    INSERT INTO security.user_profiles (user_id, national_id, gender, date_of_birth, nationality_code)
    VALUES (u.id, v_nid, v_gender, v_dob, 'YE')
    ON CONFLICT (user_id) DO NOTHING;
  END LOOP;
END;
$$;

-- ============================================================
-- 6. USER ROLES
-- ============================================================
DO $$
DECLARE
  v_id BIGINT;
BEGIN
  SELECT id INTO v_id FROM security.users WHERE username = 'national_admin';
  INSERT INTO security.user_roles (user_id, role_id, assigned_by) SELECT v_id, id, v_id FROM security.roles WHERE code='SUPER_ADMIN' ON CONFLICT DO NOTHING;
  INSERT INTO security.user_roles (user_id, role_id, assigned_by) SELECT v_id, id, v_id FROM security.roles WHERE code='ETHICS_ADMIN' ON CONFLICT DO NOTHING;

  SELECT id INTO v_id FROM security.users WHERE username = 'admin';
  INSERT INTO security.user_roles (user_id, role_id, assigned_by) SELECT v_id, id, v_id FROM security.roles WHERE code='SUPER_ADMIN' ON CONFLICT DO NOTHING;
  INSERT INTO security.user_roles (user_id, role_id, assigned_by) SELECT v_id, id, v_id FROM security.roles WHERE code='ETHICS_ADMIN' ON CONFLICT DO NOTHING;

  SELECT id INTO v_id FROM security.users WHERE username = 'ethics_admin';
  INSERT INTO security.user_roles (user_id, role_id, assigned_by) SELECT v_id, id, v_id FROM security.roles WHERE code='ETHICS_ADMIN' ON CONFLICT DO NOTHING;

  FOR i IN 1..5 LOOP
    SELECT id INTO v_id FROM security.users WHERE username = 'coordinator_'||i;
    INSERT INTO security.user_roles (user_id, role_id, assigned_by) SELECT v_id, id, v_id FROM security.roles WHERE code='COMMITTEE_COORD' ON CONFLICT DO NOTHING;
  END LOOP;

  FOR i IN 1..8 LOOP
    SELECT id INTO v_id FROM security.users WHERE username = 'chair_'||i;
    INSERT INTO security.user_roles (user_id, role_id, assigned_by) SELECT v_id, id, v_id FROM security.roles WHERE code='COMMITTEE_CHAIR' ON CONFLICT DO NOTHING;
    SELECT id INTO v_id FROM security.users WHERE username = 'cmte_coord_'||i;
    INSERT INTO security.user_roles (user_id, role_id, assigned_by) SELECT v_id, id, v_id FROM security.roles WHERE code='COMMITTEE_COORD' ON CONFLICT DO NOTHING;
  END LOOP;

  FOR i IN 1..40 LOOP
    SELECT id INTO v_id FROM security.users WHERE username = 'reviewer_'||i;
    INSERT INTO security.user_roles (user_id, role_id, assigned_by) SELECT v_id, id, v_id FROM security.roles WHERE code='REVIEWER' ON CONFLICT DO NOTHING;
  END LOOP;

  FOR i IN 1..80 LOOP
    SELECT id INTO v_id FROM security.users WHERE username = 'member_'||i;
    INSERT INTO security.user_roles (user_id, role_id, assigned_by) SELECT v_id, id, v_id FROM security.roles WHERE code='COMMITTEE_MEMBER' ON CONFLICT DO NOTHING;
  END LOOP;

  FOR i IN 1..100 LOOP
    SELECT id INTO v_id FROM security.users WHERE username = 'researcher_'||i;
    INSERT INTO security.user_roles (user_id, role_id, assigned_by) SELECT v_id, id, v_id FROM security.roles WHERE code='RESEARCHER' ON CONFLICT DO NOTHING;
  END LOOP;

  FOR i IN 1..50 LOOP
    SELECT id INTO v_id FROM security.users WHERE username = 'assistant_'||i;
    INSERT INTO security.user_roles (user_id, role_id, assigned_by) SELECT v_id, id, v_id FROM security.roles WHERE code='ASSISTANT_RESEARCHER' ON CONFLICT DO NOTHING;
  END LOOP;
END;
$$;

-- ============================================================
-- 7. COMMITTEE MEMBERS
-- ============================================================
DO $$
DECLARE
  v_comm_ids BIGINT[]; v_rev_ids BIGINT[]; v_mem_ids BIGINT[];
  v_uid BIGINT; i INT; j INT;
BEGIN
  v_comm_ids := ARRAY(SELECT id FROM committee.committees WHERE committee_code LIKE 'NCBE-%' ORDER BY committee_code);
  v_rev_ids := ARRAY(SELECT id FROM security.users WHERE username LIKE 'reviewer_%' ORDER BY username);
  v_mem_ids := ARRAY(SELECT id FROM security.users WHERE username LIKE 'member_%' ORDER BY username);

  FOR i IN 1..array_length(v_comm_ids,1) LOOP
    SELECT id INTO v_uid FROM security.users WHERE username = 'chair_'||i;
    INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, is_active)
    VALUES (v_comm_ids[i], v_uid, '2024-01-15'::date, true);

    SELECT id INTO v_uid FROM security.users WHERE username = 'cmte_coord_'||i;
    INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, is_active)
    VALUES (v_comm_ids[i], v_uid, '2024-01-15'::date, true);

    FOR j IN 0..4 LOOP
      IF ((i-1)*5+j+1) <= array_length(v_rev_ids,1) THEN
        INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, is_active)
        VALUES (v_comm_ids[i], v_rev_ids[((i-1)*5+j+1)], '2024-02-01'::date, true);
      END IF;
    END LOOP;

    FOR j IN 0..9 LOOP
      IF ((i-1)*10+j+1) <= array_length(v_mem_ids,1) THEN
        INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, is_active)
        VALUES (v_comm_ids[i], v_mem_ids[((i-1)*10+j+1)], '2024-01-20'::date, true);
      END IF;
    END LOOP;
  END LOOP;
END;
$$;

-- ============================================================
-- 8. PROJECTS (100 realistic Yemeni health research projects)
-- ============================================================
DO $$
DECLARE
  v_inst_ids BIGINT[]; v_res_ids BIGINT[];
  v_projects TEXT[][3] := ARRAY[
    ARRAY['PH','انتشار الأمراض المزمنة بين السكان في المناطق الحضرية والريفية في محافظة صنعاء','Prevalence of chronic diseases among urban and rural populations in Sana''a Governorate'],
    ARRAY['PH','تقييم جودة الرعاية الصحية الأولية في مراكز الرعاية بمحافظة عدن','Assessment of primary healthcare quality in Aden health centers'],
    ARRAY['PH','معدلات الإصابة بالسكري من النوع الثاني في محافظة حضرموت','Type 2 diabetes incidence rates in Hadhramout Governorate'],
    ARRAY['PH','العوامل المرتبطة بارتفاع ضغط الدم في المجتمع اليمني','Factors associated with hypertension in Yemeni society'],
    ARRAY['PH','انتشار السمنة بين الأطفال في سن المدرسة في مدينة تعز','Obesity prevalence among school-age children in Taiz City'],
    ARRAY['PH','الصحة النفسية لدى العاملين في القطاع الصحي بعد النزاع','Mental health among healthcare workers post-conflict'],
    ARRAY['PH','تقييم برامج التوعية الصحية في مدارس محافظة إب','Evaluation of health awareness programs in Ibb Governorate schools'],
    ARRAY['PH','مستوى المعرفة بمرض السرطان وطرق الوقاية في المجتمع اليمني','Cancer awareness and prevention methods in Yemeni society'],
    ARRAY['PH','العنف الأسري وآثاره على الصحة النفسية للنساء في اليمن','Domestic violence and its impact on women''s mental health in Yemen'],
    ARRAY['PH','انتشار أمراض القلب التاجية بين المدخنين في اليمن','Coronary heart disease prevalence among smokers in Yemen'],
    ARRAY['PH','تأثير تلوث الهواء على صحة الجهاز التنفسي في مدينة صنعاء','Air pollution impact on respiratory health in Sana''a City'],
    ARRAY['PH','مستوى النشاط البدني لدى البالغين في المجتمع اليمني','Physical activity levels among adults in Yemeni society'],
    ARRAY['PH','تقييم خدمات الطوارئ الطبية في المستشفيات الحكومية في اليمن','Assessment of emergency medical services in Yemeni government hospitals'],
    ARRAY['ID','انتشار مرض الملاريا في المناطق الساحلية والجبلية في اليمن','Malaria prevalence in coastal and mountainous regions of Yemen'],
    ARRAY['ID','دراسة وبائية لمرض حمى الضنك في محافظة الحديدة','Epidemiological study of dengue fever in Al-Hudaydah Governorate'],
    ARRAY['ID','انتشار فيروس الكبد الوبائي B في فئات مختلفة من المجتمع اليمني','Hepatitis B virus prevalence among different Yemeni population groups'],
    ARRAY['ID','مرض السل المقاوم للأدوية في اليمن: الوضع الحالي وعوامل الخطر','Drug-resistant tuberculosis in Yemen: current status and risk factors'],
    ARRAY['ID','انتشار فيروس كورونا المستجد بين العاملين الصحيين في اليمن','COVID-19 prevalence among healthcare workers in Yemen'],
    ARRAY['ID','مقاومة المضادات الحيوية لدى المرضى في المستشفيات اليمنية','Antibiotic resistance among patients in Yemeni hospitals'],
    ARRAY['ID','انتشار الكوليرا في المناطق المتضررة من النزاع في اليمن','Cholera prevalence in conflict-affected areas of Yemen'],
    ARRAY['ID','تقييم فعالية برامج التطعيم الوطنية في اليمن','Evaluation of national vaccination program effectiveness in Yemen'],
    ARRAY['ID','داء الليشمانيات الحشوي في اليمن: دراسة وبائية','Visceral leishmaniasis in Yemen: an epidemiological study'],
    ARRAY['ID','انتشار الطفيليات المعوية بين الأطفال في اليمن','Intestinal parasite prevalence among children in Yemen'],
    ARRAY['MC','معدلات وفيات الأمهات في المناطق الريفية بمحافظة حجة','Maternal mortality rates in rural areas of Hajjah Governorate'],
    ARRAY['MC','تقييم خدمات رعاية الحمل والولادة في المراكز الصحية بعدن','Assessment of pregnancy and delivery care services in Aden health centers'],
    ARRAY['MC','انتشار سوء التغذية بين النساء الحوامل في اليمن','Malnutrition prevalence among pregnant women in Yemen'],
    ARRAY['MC','العوامل المرتبطة بانخفاض الوزن عند الولادة في مدينة المكلا','Factors associated with low birth weight in Al-Mukalla City'],
    ARRAY['MC','تقييم معرفة الأمهات بالرضاعة الطبيعية في محافظة ذمار','Assessment of maternal knowledge about breastfeeding in Dhamar Governorate'],
    ARRAY['MC','انتشار فقر الدم بين النساء في سن الإنجاب في اليمن','Anemia prevalence among women of reproductive age in Yemen'],
    ARRAY['MC','تأثير تثقيف الأمهات على صحة الطفل في المناطق الريفية','Impact of maternal education on child health in rural areas'],
    ARRAY['MC','معدلات وفيات الأطفال دون الخامسة في اليمن: دراسة تحليلية','Under-five child mortality rates in Yemen: an analytical study'],
    ARRAY['MC','تقييم خدمات الصحة الإنجابية في مخيمات النازحين','Assessment of reproductive health services in IDP camps'],
    ARRAY['MC','انتشار الولادة المبكرة وعوامل الخطر المرتبطة بها في اليمن','Preterm birth prevalence and associated risk factors in Yemen'],
    ARRAY['MC','تقييم التغطية بالتحصين الأساسي للأطفال في اليمن','Assessment of basic childhood immunization coverage in Yemen'],
    ARRAY['MC','ممارسات تغذية الرضع وصغار الأطفال في المجتمع اليمني','Infant and young child feeding practices in Yemeni society'],
    ARRAY['MC','انتشار تشوهات الأطفال الخلقية في اليمن','Congenital anomalies prevalence among children in Yemen'],
    ARRAY['NU','انتشار سوء التغذية الحاد بين الأطفال دون سن الخامسة في اليمن','Severe acute malnutrition prevalence among under-five children in Yemen'],
    ARRAY['NU','تقييم فعالية برامج التدخل الغذائي في المناطق المتضررة','Evaluation of nutritional intervention program effectiveness in affected areas'],
    ARRAY['NU','نقص المغذيات الدقيقة لدى النساء والأطفال في اليمن','Micronutrient deficiency among women and children in Yemen'],
    ARRAY['NU','انتشار التقزم بين الأطفال في المرتفعات اليمنية','Stunting prevalence among children in Yemeni highlands'],
    ARRAY['NU','تقييم الوضع الغذائي للأسر النازحة في محافظة مأرب','Nutritional status assessment of displaced families in Marib Governorate'],
    ARRAY['NU','العلاقة بين الأمن الغذائي وسوء التغذية في الأسر اليمنية','Relationship between food security and malnutrition in Yemeni households'],
    ARRAY['NU','فعالية برنامج التغذية المدرسية على التحصيل الدراسي','School feeding program effectiveness on academic achievement'],
    ARRAY['NU','انتشار السمنة وزيادة الوزن بين المراهقين في اليمن','Obesity and overweight prevalence among adolescents in Yemen'],
    ARRAY['NU','تقييم المعرفة الغذائية لدى الأمهات في محافظة إب','Nutritional knowledge assessment among mothers in Ibb Governorate'],
    ARRAY['LB','تقييم كفاءة مختبرات المستشفيات العامة في تشخيص الأمراض المعدية','Efficiency evaluation of public hospital laboratories in diagnosing infectious diseases'],
    ARRAY['LB','مستوى تطبيق معايير الجودة في المختبرات الطبية في اليمن','Quality standards implementation level in Yemeni medical laboratories'],
    ARRAY['LB','تقييم دقة اختبارات فصائل الدم في مختبرات مدينة عدن','Accuracy assessment of blood typing tests in Aden City laboratories'],
    ARRAY['LB','انتشار البكتيريا المقاومة للمضادات الحيوية في العينات المخبرية','Antibiotic-resistant bacteria prevalence in laboratory samples'],
    ARRAY['LB','تقييم جودة إجراءات السلامة الحيوية في مختبرات صنعاء','Assessment of biosafety procedures quality in Sana''a laboratories'],
    ARRAY['LB','مقارنة طرق تشخيص الملاريا في المختبرات اليمنية','Comparison of malaria diagnostic methods in Yemeni laboratories'],
    ARRAY['LB','تقييم كفاءة فحوصات وظائف الكبد في مختبرات محافظة حضرموت','Efficiency assessment of liver function tests in Hadhramout laboratories'],
    ARRAY['CT','تقييم فعالية وسلامة دواء جديد لعلاج الملاريا في اليمن','Efficacy and safety evaluation of a new malaria treatment drug in Yemen'],
    ARRAY['CT','تجربة سريرية لمقارنة علاجين لمرض السكري من النوع الثاني','Clinical trial comparing two treatments for type 2 diabetes'],
    ARRAY['CT','فعالية العلاج الثلاثي لمرض السل المقاوم للأدوية','Efficacy of triple therapy for drug-resistant tuberculosis'],
    ARRAY['CT','تقييم فعالية المكملات الغذائية في تحسين صحة الأمهات','Assessment of nutritional supplement effectiveness in improving maternal health'],
    ARRAY['CT','تجربة سريرية لتقييم لقاح جديد ضد الكوليرا','Clinical trial evaluating a new cholera vaccine'],
    ARRAY['MH','انتشار الاكتئاب والقلق بين طلاب الجامعات اليمنية','Depression and anxiety prevalence among Yemeni university students'],
    ARRAY['MH','الصدمة النفسية لدى الأطفال المتأثرين بالنزاع في اليمن','Psychological trauma among conflict-affected children in Yemen'],
    ARRAY['MH','اضطراب ما بعد الصدمة لدى النازحين داخلياً في اليمن','Post-traumatic stress disorder among internally displaced persons in Yemen'],
    ARRAY['MH','تقييم خدمات الصحة النفسية المتاحة في اليمن','Assessment of available mental health services in Yemen'],
    ARRAY['MH','انتشار تعاطي التبغ والقات بين الشباب في المجتمع اليمني','Tobacco and khat use prevalence among youth in Yemeni society'],
    ARRAY['MH','العلاقة بين البطالة والصحة النفسية لدى الشباب في اليمن','Relationship between unemployment and mental health among youth in Yemen'],
    ARRAY['MH','تأثير وسائل التواصل الاجتماعي على الصحة النفسية للمراهقين','Social media impact on adolescent mental health'],
    ARRAY['MH','انتشار الإرهاق الوظيفي بين الأطباء والممرضين في اليمن','Burnout prevalence among doctors and nurses in Yemen'],
    ARRAY['HS','تقييم نظام المعلومات الصحية في اليمن: التحديات والحلول','Assessment of health information system in Yemen: challenges and solutions'],
    ARRAY['HS','تحليل كفاءة الإنفاق الصحي في اليمن','Analysis of health expenditure efficiency in Yemen'],
    ARRAY['HS','تقييم جودة الخدمات الصحية في المرافق الطبية بمحافظة عدن','Quality assessment of health services in Aden medical facilities'],
    ARRAY['HS','توزيع الكوادر الصحية في المناطق الحضرية والريفية في اليمن','Health workforce distribution in urban and rural areas of Yemen'],
    ARRAY['HS','تقييم فعالية نظام الإحالة الطبي في اليمن','Evaluation of medical referral system effectiveness in Yemen'],
    ARRAY['HS','دور التطبيب عن بعد في تحسين الوصول للرعاية الصحية في اليمن','Telemedicine role in improving healthcare access in Yemen']
  ];
  v_code TEXT; v_status TEXT; v_risk TEXT; v_rand REAL;
  v_sd DATE; v_ed DATE; i INT; d INT;
BEGIN
  v_res_ids := ARRAY(SELECT id FROM security.users WHERE username LIKE 'researcher_%' ORDER BY username);
  v_inst_ids := ARRAY(SELECT id FROM security.institutions WHERE code IN ('SANAA_U','ADEN_U','TAIZ_U','IBB_U','DHAMAR_U','HADHRAMOUT_U') ORDER BY code);

  FOR i IN 1..array_length(v_projects,1) LOOP
    v_code := 'YEM-'||v_projects[i][1]||'-'||LPAD(i::TEXT,4,'0');
    v_rand := random();
    IF v_rand < 0.15 THEN v_status := 'DRAFT';
    ELSIF v_rand < 0.30 THEN v_status := 'SUBMITTED';
    ELSIF v_rand < 0.45 THEN v_status := 'UNDER_REVIEW';
    ELSIF v_rand < 0.55 THEN v_status := 'APPROVED';
    ELSIF v_rand < 0.65 THEN v_status := 'CONDITIONALLY_APPROVED';
    ELSIF v_rand < 0.70 THEN v_status := 'REJECTED';
    ELSIF v_rand < 0.80 THEN v_status := 'CLOSED';
    ELSIF v_rand < 0.88 THEN v_status := 'ARCHIVED';
    ELSIF v_rand < 0.92 THEN v_status := 'RETURNED';
    ELSIF v_rand < 0.96 THEN v_status := 'DEFERRED';
    ELSE v_status := 'SUSPENDED'; END IF;
    IF v_rand < 0.3 THEN v_risk := 'LOW'; ELSIF v_rand < 0.7 THEN v_risk := 'MEDIUM'; ELSE v_risk := 'HIGH'; END IF;
    v_sd := '2024-01-01'::date + (random()*600)::int;
    v_ed := v_sd + (180+random()*540)::int;
    INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date)
    VALUES (v_inst_ids[((i-1)%6)+1], v_code, v_projects[i][2], v_projects[i][3], v_res_ids[((i-1)%array_length(v_res_ids,1))+1], v_projects[i][1], v_risk, v_status, v_sd, v_ed)
    ON CONFLICT (project_code) DO UPDATE SET title_ar = EXCLUDED.title_ar;
  END LOOP;
END;
$$;

-- ============================================================
-- 9. APPLICATIONS (one per non-draft project)
-- ============================================================
DO $$
DECLARE
  rec RECORD; v_comm_ids BIGINT[]; v_rand REAL;
BEGIN
  v_comm_ids := ARRAY(SELECT id FROM committee.committees WHERE committee_code LIKE 'NCBE-%' ORDER BY committee_code);
  FOR rec IN SELECT id, principal_investigator_id, status_code FROM core.projects WHERE status_code != 'DRAFT' LOOP
    v_rand := random();
    INSERT INTO core.applications (application_number, project_id, application_type, current_status, submission_date, submitted_by, target_committee_id)
    VALUES ('APP-YEM-'||LPAD(rec.id::TEXT,5,'0'), rec.id,
      CASE WHEN v_rand<0.5 THEN 'NEW' WHEN v_rand<0.75 THEN 'EXPEDITED' ELSE 'FULL' END,
      rec.status_code, NOW()-(random()*365)::int*INTERVAL '1 day',
      rec.principal_investigator_id, v_comm_ids[((rec.id%8)::int)+1])
    ON CONFLICT (application_number) DO NOTHING;
  END LOOP;
END;
$$;

-- ============================================================
-- 10. REVIEWS (scientific + ethics)
-- ============================================================
DO $$
DECLARE
  rec RECORD; v_rids BIGINT[]; v_rid BIGINT; v_rec TEXT; v_score REAL; v_at TIMESTAMPTZ;
BEGIN
  v_rids := ARRAY(SELECT id FROM security.users WHERE username LIKE 'reviewer_%' ORDER BY username LIMIT 30);
  FOR rec IN SELECT a.id aid, a.current_status FROM core.applications a WHERE a.current_status IN ('UNDER_REVIEW','APPROVED','CONDITIONALLY_APPROVED','REJECTED','CLOSED','ARCHIVED') LOOP
    v_rid := v_rids[(rec.aid%30)+1]; v_score := 60+random()*40;
    v_rec := CASE WHEN v_score>=80 THEN 'APPROVED' WHEN v_score>=65 THEN 'REVISIONS_REQUIRED' ELSE 'REJECTED' END;
    v_at := NOW()-(random()*180)::int*INTERVAL '1 day';
    INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
    VALUES (rec.aid, v_rid, 'COMPLETED', v_rec, 'تمت المراجعة العلمية للبحث مع بعض الملاحظات.', v_at-INTERVAL '7 days', v_at);
    INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_at, status_code)
    VALUES (rec.aid, v_rid, 'SCIENTIFIC', v_at-INTERVAL '14 days', 'COMPLETED');
    IF rec.current_status IN ('APPROVED','CONDITIONALLY_APPROVED') THEN
      INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
      VALUES (rec.aid, v_rids[((rec.aid+5)%30)+1], 'COMPLETED', 'APPROVED', CASE WHEN random()<0.7 THEN 'LOW' ELSE 'MEDIUM' END, 'البث متوافق مع المعايير الأخلاقية.', v_at+INTERVAL '1 day', v_at+INTERVAL '3 days');
    END IF;
  END LOOP;
END;
$$;

-- ============================================================
-- 11. COMMITTEE MEETINGS (50)
-- ============================================================
DO $$
DECLARE
  v_cids BIGINT[]; v_chids BIGINT[];
  v_mdate DATE; v_status TEXT; i INT;
  v_locations TEXT[] := ARRAY['قاعة الاجتماعات الرئيسية - مبنى NCBE', 'قاعة الأخلاقيات - الطابق الثالث', 'قاعة المؤتمرات - المركز الوطني', 'قاعة اليمن الكبرى', 'قاعة عدن', 'قاعة حضرموت'];
BEGIN
  v_cids := ARRAY(SELECT id FROM committee.committees WHERE committee_code LIKE 'NCBE-%' ORDER BY committee_code);
  v_chids := ARRAY(SELECT id FROM security.users WHERE username LIKE 'chair_%' ORDER BY username);
  FOR i IN 1..50 LOOP
    v_mdate := '2024-03-01'::date + (i*14)::int;
    IF v_mdate < CURRENT_DATE THEN
      v_status := CASE WHEN random()<0.7 THEN 'COMPLETED' WHEN random()<0.85 THEN 'CANCELLED' ELSE 'POSTPONED' END;
    ELSE
      v_status := CASE WHEN random()<0.7 THEN 'SCHEDULED' ELSE 'PENDING' END;
    END IF;
    INSERT INTO committee.committee_meetings (committee_id, meeting_number, meeting_date, location, meeting_status, chairperson_id)
    VALUES (v_cids[((i-1)%8)+1], 'MTG-NCBE-'||LPAD(i::TEXT,4,'0'), v_mdate, v_locations[((i-1)%6)+1], v_status, v_chids[((i-1)%8)+1]);
    IF v_status = 'COMPLETED' THEN
      INSERT INTO committee.quorum_logs (meeting_id, total_members, present_members, quorum_required, quorum_achieved)
      SELECT id, 16, 12+(random()*4)::int, 9, true FROM committee.committee_meetings WHERE meeting_number='MTG-NCBE-'||LPAD(i::TEXT,4,'0');
    END IF;
  END LOOP;
END;
$$;

-- ============================================================
-- 12. SAFETY DATA
-- ============================================================
DO $$
DECLARE
  v_aids BIGINT[]; v_rids BIGINT[];
  v_et TEXT[] := ARRAY['NAUSEA','DIZZINESS','HEADACHE','FEVER','RASH','DIARRHEA','FATIGUE','PAIN','HYPERTENSION','ALLERGIC_REACTION'];
  v_desc TEXT[] := ARRAY['غثيان خفيف بعد تناول الدواء','دوار وعدم اتزان','صداع متوسط الشدة','ارتفاع في درجة الحرارة','ظهور طفح جلدي','إسهال حاد','إرهاق عام','ألم في موقع الحقن','ارتفاع ضغط الدم','حساسية جلدية'];
  i INT;
BEGIN
  v_aids := ARRAY(SELECT id FROM core.applications WHERE current_status IN ('APPROVED','CONDITIONALLY_APPROVED','CLOSED','UNDER_REVIEW'));
  v_rids := ARRAY(SELECT id FROM security.users WHERE username LIKE 'researcher_%' ORDER BY username LIMIT 20);

  INSERT INTO safety.risk_categories (category_code, category_name, description) VALUES
    ('PHYSICAL', 'مخاطر جسدية', 'Physical risks including injury or bodily harm'),
    ('PSYCHOLOGICAL', 'مخاطر نفسية', 'Psychological risks including stress or anxiety'),
    ('SOCIAL', 'مخاطر اجتماعية', 'Social risks including stigma or discrimination'),
    ('CHEMICAL', 'مخاطر كيميائية', 'Chemical risks including exposure to hazardous substances'),
    ('BIOLOGICAL', 'مخاطر بيولوجية', 'Biological risks including infectious agents'),
    ('DATA_PRIVACY', 'مخاطر خصوصية البيانات', 'Data privacy and confidentiality risks')
  ON CONFLICT (category_code) DO NOTHING;

  FOR i IN 1..200 LOOP
    INSERT INTO safety.adverse_events (application_id, event_number, participant_reference, event_date, event_type, severity, expectedness, relatedness, description, outcome_status, reported_by, reported_at)
    VALUES (v_aids[((i-1)%array_length(v_aids,1))+1], 'AE-YEM-'||LPAD(i::TEXT,5,'0'), 'PT-'||LPAD((1000+i)::TEXT,4,'0'),
      '2024-04-01'::date+(random()*240)::int, v_et[((i-1)%10)+1],
      CASE WHEN random()<0.5 THEN 'MILD' WHEN random()<0.8 THEN 'MODERATE' ELSE 'SEVERE' END,
      CASE WHEN random()<0.7 THEN 'EXPECTED' ELSE 'UNEXPECTED' END,
      CASE WHEN random()<0.5 THEN 'PROBABLE' WHEN random()<0.8 THEN 'POSSIBLE' ELSE 'DEFINITE' END,
      v_desc[((i-1)%10)+1], CASE WHEN random()<0.7 THEN 'RECOVERED' WHEN random()<0.9 THEN 'RECOVERING' ELSE 'ONGOING' END,
      v_rids[((i-1)%array_length(v_rids,1))+1], NOW()-(random()*200)::int*INTERVAL '1 day')
    ON CONFLICT DO NOTHING;
    IF i%4=0 THEN
      INSERT INTO safety.serious_adverse_events (adverse_event_id, seriousness_reason, hospitalization_required, life_threatening, death_occurred, disability_occurred, reported_to_committee_at)
      SELECT id, 'استدعى دخول المستشفى للمراقبة.', random()<0.5, random()<0.2, false, random()<0.1, NOW()-(random()*30)::int*INTERVAL '1 day'
      FROM safety.adverse_events WHERE event_number='AE-YEM-'||LPAD(i::TEXT,5,'0');
    END IF;
  END LOOP;

  FOR i IN 1..array_length(v_aids,1) LOOP
    INSERT INTO safety.risk_assessments (application_id, assessment_date, overall_risk_level, assessment_summary, assessed_by)
    VALUES (v_aids[i], '2024-05-01'::date+(random()*200)::int,
      CASE WHEN random()<0.3 THEN 'LOW' WHEN random()<0.7 THEN 'MEDIUM' ELSE 'HIGH' END,
      'تم تقييم مخاطر البحث وفق المعايير الوطنية.', v_rids[((i-1)%array_length(v_rids,1))+1]);
  END LOOP;
END;
$$;

-- ============================================================
-- 13. DOCUMENTS (templates + generated)
-- ============================================================
DO $$
DECLARE
  v_aids BIGINT[]; v_rids BIGINT[];
  v_dn TEXT[] := ARRAY['بروتوكول البحث', 'نموذج الموافقة المستنيرة', 'استبيان جمع البيانات', 'السيرة الذاتية للباحث', 'الميزانية التقديرية', 'خطاب الموافقة'];
  i INT; j INT;
BEGIN
  v_aids := ARRAY(SELECT id FROM core.applications ORDER BY id);
  v_rids := ARRAY(SELECT id FROM security.users WHERE username LIKE 'researcher_%' ORDER BY username LIMIT 30);

  INSERT INTO documents.templates (template_code, template_name, template_type, template_content, version_no, is_active) VALUES
    ('YEM_IRB_LETTER', 'قالب خطاب موافقة اللجنة', 'PDF', 'خطاب موافقة اللجنة الوطنية للأخلاقيات', 1, true),
    ('YEM_CONSENT', 'قالب الموافقة المستنيرة', 'HTML', 'نموذج الموافقة المستنيرة للمشاركة في البحث', 1, true),
    ('YEM_SAE_REPORT', 'قالب تقرير الحدث السلبي', 'PDF', 'نموذج الإبلاغ عن الأحداث السلبية', 1, true),
    ('YEM_PROGRESS', 'قالب التقرير المرحلي', 'PDF', 'نموذج التقرير المرحلي للبحث', 1, true),
    ('YEM_REVIEW_FORM', 'قالب نموذج المراجعة', 'PDF', 'نموذج مراجعة الطلبات', 1, true)
  ON CONFLICT (template_code, version_no) DO NOTHING;

  FOR i IN 1..array_length(v_aids,1) LOOP
    FOR j IN 1..3 LOOP
      INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, mime_type, file_size_bytes, storage_path, uploaded_by)
      VALUES (j, 'application', v_aids[i], v_dn[j]||' - رقم '||(SELECT application_number FROM core.applications WHERE id=v_aids[i]),
        'doc_'||v_aids[i]||'_'||j||'.pdf', 'application/pdf', (1000+random()*5000)::int,
        '/uploads/'||v_aids[i]||'/'||j||'.pdf', v_rids[((i-1)%array_length(v_rids,1))+1]);
    END LOOP;
  END LOOP;
END;
$$;

-- ============================================================
-- 14. MESSAGES (1000)
-- ============================================================
DO $$
DECLARE
  v_uids BIGINT[]; v_mid BIGINT;
  v_sub TEXT[] := ARRAY['استفسار حول حالة الطلب','طلب تعديلات على البحث','تذكير بموعد الاجتماع','دعوة لحضور اجتماع اللجنة','نتائج المراجعة العلمية','طلب معلومات إضافية','إشعار الموافقة الأخلاقية','طلب إعادة تقديم'];
  i INT;
BEGIN
  v_uids := ARRAY(SELECT id FROM security.users ORDER BY id);
  FOR i IN 1..1000 LOOP
    INSERT INTO communication.messages (sender_id, subject, message_body)
    VALUES (v_uids[((i-1)%array_length(v_uids,1))+1], v_sub[((i-1)%8)+1]||' رقم '||i, 'نص الرسالة.')
    RETURNING id INTO v_mid;
    INSERT INTO communication.message_recipients (message_id, recipient_id)
    VALUES (v_mid, v_uids[((i*7)%array_length(v_uids,1))+1]);
    IF i%3=0 THEN
      INSERT INTO communication.message_recipients (message_id, recipient_id)
      VALUES (v_mid, v_uids[((i*13)%array_length(v_uids,1))+1]);
    END IF;
  END LOOP;
END;
$$;

-- ============================================================
-- 15. NOTIFICATIONS (5000)
-- ============================================================
DO $$
DECLARE
  v_uids BIGINT[];
  v_nt TEXT[] := ARRAY['STATUS_CHANGE','NEW_ASSIGNMENT','MEETING_REMINDER','DEADLINE_APPROACHING','SYSTEM_ALERT','COMMITTEE_DECISION'];
  i INT;
BEGIN
  v_uids := ARRAY(SELECT id FROM security.users ORDER BY id);
  FOR i IN 1..5000 LOOP
    INSERT INTO communication.notifications (user_id, notification_type, subject, message_body, priority_level)
    VALUES (v_uids[((i-1)%array_length(v_uids,1))+1], v_nt[((i-1)%6)+1],
      CASE ((i-1)%6)+1 WHEN 1 THEN 'تغيير حالة الطلب' WHEN 2 THEN 'تكليف جديد' WHEN 3 THEN 'تذكير باجتماع' WHEN 4 THEN 'اقتراب موعد' WHEN 5 THEN 'تنبيه النظام' ELSE 'قرار اللجنة' END,
      'إشعار رقم '||i::TEXT, CASE WHEN random()<0.2 THEN 'HIGH' WHEN random()<0.6 THEN 'NORMAL' ELSE 'LOW' END);
  END LOOP;
END;
$$;

-- ============================================================
-- 16. AUDIT LOGS (10000 records)
-- ============================================================
INSERT INTO system.audit_log (user_id, action_type, entity_type, entity_id, old_values, new_values)
SELECT
  (ARRAY(SELECT id FROM security.users ORDER BY id))[1+(i%(SELECT count(*) FROM security.users))],
  (ARRAY['CREATE','UPDATE','DELETE'])[1+(i%3)],
  (ARRAY['core.applications','core.projects','committee.committee_members','security.users','safety.adverse_events'])[1+(i%5)],
  (i%500)+1, '{}'::jsonb, '{"action":"seed_data"}'::jsonb
FROM generate_series(1,10000) AS i;

COMMIT;