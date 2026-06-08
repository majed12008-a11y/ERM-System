-- ============================================================
-- 10-YEMEN-INSTITUTIONS
-- Yemeni institutions and departments for the ERM system
-- ============================================================

-- Yemeni Universities
INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'SANAA_U', 'جامعة صنعاء', 'Sana''a University', 'info@su.edu.ye', '+967123456789', 'الجمهورية اليمنية - صنعاء - شارع الستين', true
FROM security.institution_types WHERE code = 'UNIVERSITY';

INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'ADEN_U', 'جامعة عدن', 'University of Aden', 'info@aden-univ.net', '+967223456789', 'الجمهورية اليمنية - عدن - خور مكسر', true
FROM security.institution_types WHERE code = 'UNIVERSITY';

INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'TAIZ_U', 'جامعة تعز', 'Taiz University', 'info@taiz.edu.ye', '+967423456789', 'الجمهورية اليمنية - تعز - الحصب', true
FROM security.institution_types WHERE code = 'UNIVERSITY';

INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'HADHRAMAUT_U', 'جامعة حضرموت', 'Hadramout University', 'info@hu.edu.ye', '+967523456789', 'الجمهورية اليمنية - حضرموت - المكلا', true
FROM security.institution_types WHERE code = 'UNIVERSITY';

INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'IBB_U', 'جامعة إب', 'Ibb University', 'info@ibbuniv.edu.ye', '+ nasod423456790', 'الجمهورية اليمنية - إب - صبر', true
FROM security.institution_types WHERE code = 'UNIVERSITY';

INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'DHAMAR_U', 'جامعة ذمار', 'Thamar University', 'info@thamaruni.edu.ye', '+967623456789', 'الجمهورية اليمنية - ذمار', true
FROM security.institution_types WHERE code = 'UNIVERSITY';

INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'HODEIDAH_U', 'جامعة الحديدة', 'Hodeidah University', 'info@hoduniv.edu.ye', '+967323456789', 'الجمهورية اليمنية - الحديدة - شارع الجامعة', true
FROM security.institution_types WHERE code = 'UNIVERSITY';

INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'YEMENIA_U', 'الجامعة اليمنية', 'Yemenia University', 'info@yemenia.edu.ye', '+967123456790', 'الجمهورية اليمنية - صنعاء - حدة', true
FROM security.institution_types WHERE code = 'UNIVERSITY';

INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'SCI_TECH_U', 'جامعة العلوم والتكنولوجيا', 'University of Science and Technology', 'info@ust.edu.ye', '+967123456791', 'الجمهورية اليمنية - صنعاء - شارع حمير', true
FROM security.institution_types WHERE code = 'UNIVERSITY';

INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'QUEEN_ARWA_U', 'جامعة الملكة أروى', 'Queen Arwa University', 'info@queenarwa.edu.ye', '+967423456791', 'الجمهورية اليمنية - تعز - جبل صبر', true
FROM security.institution_types WHERE code = 'UNIVERSITY';

INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'SABA_U', 'جامعة سبأ', 'Saba University', 'info@saba.edu.ye', '+967123456792', 'الجمهورية اليمنية - صنعاء - ضبوة', true
FROM security.institution_types WHERE code = 'UNIVERSITY';

-- Yemeni Hospitals
INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'AL_THAWRA_H', 'مستشفى الثورة العام', 'Al-Thawra General Hospital', 'info@althawra-hospital.ye', '+967123456793', 'الجمهورية اليمنية - صنعاء - شارع الثورة', true
FROM security.institution_types WHERE code = 'HOSPITAL';

INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'AL_JUMHOURI_H', 'مستشفى الجمهوري', 'Al-Jumhouri Hospital', 'info@aljumhouri-hospital.ye', '+967123456794', 'الجمهورية اليمنية - صنعاء - شارع الزبيري', true
FROM security.institution_types WHERE code = 'HOSPITAL';

INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'AL_THAWRA_ADEN_H', 'مستشفى الثورة بعدن', 'Al-Thawra Hospital Aden', 'info@thawra-aden-hospital.ye', '+967223456790', 'الجمهورية اليمنية - عدن - البريقة', true
FROM security.institution_types WHERE code = 'HOSPITAL';

INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'AL_WAHDA_H', 'مستشفى الوحدة التعليمي', 'Al-Wahda Teaching Hospital', 'info@wahda-hospital.ye', '+967123456795', 'الجمهورية اليمنية - صنعاء - الوحدة', true
FROM security.institution_types WHERE code = 'HOSPITAL';

INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'MUKALLA_H', 'مستشفى المكلا', 'Mukalla Hospital', 'info@mukalla-hospital.ye', '+967523456790', 'الجمهورية اليمنية - حضرموت - المكلا', true
FROM security.institution_types WHERE code = 'HOSPITAL';

INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'TAIZ_H', 'مستشفى تعز العام', 'Taiz General Hospital', 'info@taiz-hospital.ye', '+967423456792', 'الجمهورية اليمنية - تعز - جبل جرة', true
FROM security.institution_types WHERE code = 'HOSPITAL';

-- Yemeni Research Centers
INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'YEMEN_RC', 'المركز اليمني للبحوث', 'Yemeni Center for Research', 'info@ycr.edu.ye', '+967123456796', 'الجمهورية اليمنية - صنعاء - شارع الستين', true
FROM security.institution_types WHERE code = 'RESEARCH_CENTER';

INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'TROPICAL_RC', 'مركز البحوث الاستوائية', 'Tropical Research Center', 'info@trc.edu.ye', '+967123456797', 'الجمهورية اليمنية - الحديدة - الكورنيش', true
FROM security.institution_types WHERE code = 'RESEARCH_CENTER';

INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'ENDEMIC_RC', 'مركز الأبحاث للأمراض المتوطنة', 'Endemic Diseases Research Center', 'info@endemic-research.ye', '+967123456798', 'الجمهورية اليمنية - صنعاء - حي الجامعة', true
FROM security.institution_types WHERE code = 'RESEARCH_CENTER';

-- ============================================================
-- Departments for each Yemeni university
-- ============================================================

-- Sana'a University departments
INSERT INTO security.departments (institution_id, code, name_ar, name_en)
SELECT i.id, 'MED', 'كلية الطب', 'College of Medicine'
FROM security.institutions i WHERE i.code = 'SANAA_U'
UNION ALL
SELECT i.id, 'DENT', 'كلية طب الأسنان', 'College of Dentistry'
FROM security.institutions i WHERE i.code = 'SANAA_U'
UNION ALL
SELECT i.id, 'PHARM', 'كلية الصيدلة', 'College of Pharmacy'
FROM security.institutions i WHERE i.code = 'SANAA_U'
UNION ALL
SELECT i.id, 'SCI', 'كلية العلوم', 'College of Science'
FROM security.institutions i WHERE i.code = 'SANAA_U'
UNION ALL
SELECT i.id, 'ENG', 'كلية الهندسة', 'College of Engineering'
FROM security.institutions i WHERE i.code = 'SANAA_U'
UNION ALL
SELECT i.id, 'NUR', 'كلية التمريض', 'College of Nursing'
FROM security.institutions i WHERE i.code = 'SANAA_U';

-- University of Aden departments
INSERT INTO security.departments (institution_id, code, name_ar, name_en)
SELECT i.id, 'MED', 'كلية الطب', 'College of Medicine'
FROM security.institutions i WHERE i.code = 'ADEN_U'
UNION ALL
SELECT i.id, 'PHARM', 'كلية الصيدلة', 'College of Pharmacy'
FROM security.institutions i WHERE i.code = 'ADEN_U'
UNION ALL
SELECT i.id, 'SCI', 'كلية العلوم', 'College of Science'
FROM security.institutions i WHERE i.code = 'ADEN_U'
UNION ALL
SELECT i.id, 'ENG', 'كلية الهندسة', 'College of Engineering'
FROM security.institutions i WHERE i.code = 'ADEN_U'
UNION ALL
SELECT i.id, 'NUR', 'كلية التمريض', 'College of Nursing'
FROM security.institutions i WHERE i.code = 'ADEN_U';

-- Taiz University departments
INSERT INTO security.departments (institution_id, code, name_ar, name_en)
SELECT i.id, 'MED', 'كلية الطب', 'College of Medicine'
FROM security.institutions i WHERE i.code = 'TAIZ_U'
UNION ALL
SELECT i.id, 'SCI', 'كلية العلوم', 'College of Science'
FROM security.institutions i WHERE i.code = 'TAIZ_U'
UNION ALL
SELECT i.id, 'EDU', 'كلية التربية', 'College of Education'
FROM security.institutions i WHERE i.code = 'TAIZ_U';

-- Hadramout University departments
INSERT INTO security.departments (institution_id, code, name_ar, name_en)
SELECT i.id, 'MED', 'كلية الطب', 'College of Medicine'
FROM security.institutions i WHERE i.code = 'HADHRAMAUT_U'
UNION ALL
SELECT i.id, 'DENT', 'كلية طب الأسنان', 'College of Dentistry'
FROM security.institutions i WHERE i.code = 'HADHRAMAUT_U'
UNION ALL
SELECT i.id, 'SCI', 'كلية العلوم', 'College of Science'
FROM security.institutions i WHERE i.code = 'HADHRAMAUT_U'
UNION ALL
SELECT i.id, 'ENV', 'كلية علوم البيئة', 'College of Environmental Sciences'
FROM security.institutions i WHERE i.code = 'HADHRAMAUT_U';

-- Ibb University departments
INSERT INTO security.departments (institution_id, code, name_ar, name_en)
SELECT i.id, 'MED', 'كلية الطب', 'College of Medicine'
FROM security.institutions i WHERE i.code = 'IBB_U'
UNION ALL
SELECT i.id, 'SCI', 'كلية العلوم', 'College of Science'
FROM security.institutions i WHERE i.code = 'IBB_U'
UNION ALL
SELECT i.id, 'AGRI', 'كلية الزراعة', 'College of Agriculture'
FROM security.institutions i WHERE i.code = 'IBB_U';

-- Thamar University departments
INSERT INTO security.departments (institution_id, code, name_ar, name_en)
SELECT i.id, 'MED', 'كلية الطب', 'College of Medicine'
FROM security.institutions i WHERE i.code = 'DHAMAR_U'
UNION ALL
SELECT i.id, 'SCI', 'كلية العلوم', 'College of Science'
FROM security.institutions i WHERE i.code = 'DHAMAR_U'
UNION ALL
SELECT i.id, 'ENG', 'كلية الهندسة', 'College of Engineering'
FROM security.institutions i WHERE i.code = 'DHAMAR_U';

-- Hodeidah University departments
INSERT INTO security.departments (institution_id, code, name_ar, name_en)
SELECT i.id, 'SCI', 'كلية العلوم', 'College of Science'
FROM security.institutions i WHERE i.code = 'HODEIDAH_U'
UNION ALL
SELECT i.id, 'MARINE', 'كلية علوم البحار', 'College of Marine Sciences'
FROM security.institutions i WHERE i.code = 'HODEIDAH_U'
UNION ALL
SELECT i.id, 'AGRI', 'كلية الزراعة', 'College of Agriculture'
FROM security.institutions i WHERE i.code = 'HODEIDAH_U';

-- University of Science and Technology departments
INSERT INTO security.departments (institution_id, code, name_ar, name_en)
SELECT i.id, 'MED', 'كلية الطب', 'College of Medicine'
FROM security.institutions i WHERE i.code = 'SCI_TECH_U'
UNION ALL
SELECT i.id, 'DENT', 'كلية طب الأسنان', 'College of Dentistry'
FROM security.institutions i WHERE i.code = 'SCI_TECH_U'
UNION ALL
SELECT i.id, 'PHARM', 'كلية الصيدلة', 'College of Pharmacy'
FROM security.institutions i WHERE i.code = 'SCI_TECH_U'
UNION ALL
SELECT i.id, 'SCI', 'كلية العلوم', 'College of Science'
FROM security.institutions i WHERE i.code = 'SCI_TECH_U';
