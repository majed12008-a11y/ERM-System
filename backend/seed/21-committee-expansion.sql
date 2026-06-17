-- ============================================================
-- 21-COMMITTEE EXPANSION: New types, committees, users & members
-- ============================================================

-- ============================================================
-- 1. NEW COMMITTEE TYPES
-- ============================================================
INSERT INTO committee.committee_types (type_code, type_name, description) VALUES
  ('REC', 'لجنة أخلاقيات البحث', 'Research Ethics Committee'),
  ('SRC', 'لجنة المراجعة العلمية', 'Scientific Review Committee'),
  ('DSMB', 'مجلس مراقبة سلامة البيانات', 'Data Safety Monitoring Board'),
  ('COIC', 'لجنة تضارب المصالح', 'Conflict of Interest Committee'),
  ('NRC', 'لجنة المراجعة الوطنية', 'National Review Committee');

-- ============================================================
-- 2. NEW USERS (Sana'a University + Aden University)
-- ============================================================

-- ---- SANAA UNIVERSITY (SANAA_U) ----
-- Sanaa Ethics Admin
INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = i.id),
  'sanaa_admin', 'sanaa.admin@su.edu.ye',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'عبدالله', 'الحكمي', 'Abdullah', 'Alhakami', '+967711111111', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'SANAA_U';

-- Sanaa Chairperson
INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = i.id),
  'sanaa_chair', 'sanaa.chair@su.edu.ye',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'أحمد', 'المخلافي', 'Ahmed', 'Almekhlafi', '+967711111112', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'SANAA_U';

-- Sanaa Reviewer 1
INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = i.id),
  'sanaa_reviewer1', 'sanaa.reviewer1@su.edu.ye',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'مريم', 'النزيلي', 'Maryam', 'Alnezili', '+967711111113', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'SANAA_U';

-- Sanaa Reviewer 2
INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'DENT' AND d.institution_id = i.id),
  'sanaa_reviewer2', 'sanaa.reviewer2@su.edu.ye',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'خالد', 'الصبري', 'Khaled', 'Alsabri', '+967711111114', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'SANAA_U';

-- Sanaa Researcher 1
INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = i.id),
  'sanaa_researcher1', 'sanaa.researcher1@su.edu.ye',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'فاطمة', 'الواسعي', 'Fatima', 'Alwasai', '+967711111115', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'SANAA_U';

-- Sanaa Researcher 2
INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = i.id),
  'sanaa_researcher2', 'sanaa.researcher2@su.edu.ye',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'يوسف', 'الأغبري', 'Yousef', 'Alaghbari', '+967711111116', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'SANAA_U';

-- ---- ADEN UNIVERSITY (ADEN_U) ----
-- Aden Ethics Admin
INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = i.id),
  'aden_admin', 'aden.admin@aden-univ.net',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'ناصر', 'باحاج', 'Nasser', 'Bahaj', '+967722222221', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'ADEN_U';

-- Aden Chairperson
INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = i.id),
  'aden_chair', 'aden.chair@aden-univ.net',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'سالم', 'بن بريك', 'Salem', 'Binbrek', '+967722222222', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'ADEN_U';

-- Aden Reviewer 1
INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'PHARM' AND d.institution_id = i.id),
  'aden_reviewer1', 'aden.reviewer1@aden-univ.net',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'هند', 'باعوم', 'Hind', 'Baoum', '+967722222223', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'ADEN_U';

-- Aden Reviewer 2
INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = i.id),
  'aden_reviewer2', 'aden.reviewer2@aden-univ.net',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'عبدالرحمن', 'باذيب', 'Abdulrahman', 'Badheeb', '+967722222224', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'ADEN_U';

-- Aden Researcher 1
INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = i.id),
  'aden_researcher1', 'aden.researcher1@aden-univ.net',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'إيمان', 'باصبرة', 'Eman', 'Basabra', '+967722222225', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'ADEN_U';

-- ---- KSU - Additional Users ----
-- KSU Additional Reviewer for SRC
INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'SCI' AND d.institution_id = i.id),
  'ksu_reviewer4', 'reviewer4@ksu.edu.sa',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'نورة', 'الشريف', 'Noura', 'Alshareef', '+966509999999', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'KSU';

-- KSU Animal Researcher
INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = i.id),
  'ksu_animal_researcher', 'animal.researcher@ksu.edu.sa',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'عمر', 'القحطاني', 'Omar', 'Alqahtani', '+966508888887', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'KSU';

-- ============================================================
-- 3. ASSIGN SYSTEM ROLES TO NEW USERS
-- ============================================================
-- ETHICS_ADMIN roles
INSERT INTO security.user_roles (user_id, role_id, assigned_by)
SELECT u.id, r.id, (SELECT id FROM security.users WHERE username = 'admin')
FROM security.users u, security.roles r
WHERE u.username IN ('sanaa_admin', 'aden_admin') AND r.code = 'ETHICS_ADMIN';

-- COMMITTEE_CHAIR roles
INSERT INTO security.user_roles (user_id, role_id, assigned_by)
SELECT u.id, r.id, (SELECT id FROM security.users WHERE username = 'admin')
FROM security.users u, security.roles r
WHERE u.username IN ('sanaa_chair', 'aden_chair') AND r.code = 'COMMITTEE_CHAIR';

-- REVIEWER roles
INSERT INTO security.user_roles (user_id, role_id, assigned_by)
SELECT u.id, r.id, (SELECT id FROM security.users WHERE username = 'admin')
FROM security.users u, security.roles r
WHERE u.username IN ('sanaa_reviewer1', 'sanaa_reviewer2', 'aden_reviewer1', 'aden_reviewer2', 'ksu_reviewer4') AND r.code = 'REVIEWER';

-- RESEARCHER roles
INSERT INTO security.user_roles (user_id, role_id, assigned_by)
SELECT u.id, r.id, (SELECT id FROM security.users WHERE username = 'admin')
FROM security.users u, security.roles r
WHERE u.username IN ('sanaa_researcher1', 'sanaa_researcher2', 'aden_researcher1', 'ksu_animal_researcher') AND r.code = 'RESEARCHER';

-- Assign permissions to new ETHICS_ADMIN users
INSERT INTO security.role_permissions (role_id, permission_id)
SELECT ur.role_id, rp.permission_id
FROM security.user_roles ur
JOIN security.roles r ON r.id = ur.role_id
JOIN security.role_permissions rp ON rp.role_id = (SELECT id FROM security.roles WHERE code = 'ETHICS_ADMIN')
WHERE ur.user_id IN (SELECT id FROM security.users WHERE username IN ('sanaa_admin', 'aden_admin'))
  AND r.code = 'ETHICS_ADMIN';

-- ============================================================
-- 4. NEW COMMITTEES
-- ============================================================
-- IRB for Sana'a University
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, is_active)
SELECT i.id, 'IRB-SANAA-01', 'لجنة المراجعة المؤسسية - جامعة صنعاء', 'Sana''a University Institutional Review Board', ct.id, true
FROM security.institutions i, committee.committee_types ct
WHERE i.code = 'SANAA_U' AND ct.type_code = 'IRB';

-- IRB for Aden University
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, is_active)
SELECT i.id, 'IRB-ADEN-01', 'لجنة المراجعة المؤسسية - جامعة عدن', 'University of Aden Institutional Review Board', ct.id, true
FROM security.institutions i, committee.committee_types ct
WHERE i.code = 'ADEN_U' AND ct.type_code = 'IRB';

-- SRC (Scientific Review Committee) at KSU
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, is_active)
SELECT i.id, 'SRC-KSU-01', 'لجنة المراجعة العلمية - جامعة الملك سعود', 'KSU Scientific Review Committee', ct.id, true
FROM security.institutions i, committee.committee_types ct
WHERE i.code = 'KSU' AND ct.type_code = 'SRC';

-- REC (Research Ethics Committee) at Sana'a University
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, is_active)
SELECT i.id, 'REC-SANAA-01', 'لجنة أخلاقيات البحث - جامعة صنعاء', 'Sana''a University Research Ethics Committee', ct.id, true
FROM security.institutions i, committee.committee_types ct
WHERE i.code = 'SANAA_U' AND ct.type_code = 'REC';

-- DSMB at KSU
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, is_active)
SELECT i.id, 'DSMB-KSU-01', 'مجلس مراقبة سلامة البيانات - جامعة الملك سعود', 'KSU Data Safety Monitoring Board', ct.id, true
FROM security.institutions i, committee.committee_types ct
WHERE i.code = 'KSU' AND ct.type_code = 'DSMB';

-- IACUC at KSU (for animal research)
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, is_active)
SELECT i.id, 'IACUC-KSU-01', 'لجنة رعاية الحيوان - جامعة الملك سعود', 'KSU Animal Care Committee', ct.id, true
FROM security.institutions i, committee.committee_types ct
WHERE i.code = 'KSU' AND ct.type_code = 'IACUC';

-- COIC at KSU
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, is_active)
SELECT i.id, 'COIC-KSU-01', 'لجنة تضارب المصالح - جامعة الملك سعود', 'KSU Conflict of Interest Committee', ct.id, true
FROM security.institutions i, committee.committee_types ct
WHERE i.code = 'KSU' AND ct.type_code = 'COIC';

-- IRB at Taiz University
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, is_active)
SELECT i.id, 'IRB-TAIZ-01', 'لجنة المراجعة المؤسسية - جامعة تعز', 'Taiz University Institutional Review Board', ct.id, true
FROM security.institutions i, committee.committee_types ct
WHERE i.code = 'TAIZ_U' AND ct.type_code = 'IRB';

-- REC at Aden University
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, is_active)
SELECT i.id, 'REC-ADEN-01', 'لجنة أخلاقيات البحث - جامعة عدن', 'University of Aden Research Ethics Committee', ct.id, true
FROM security.institutions i, committee.committee_types ct
WHERE i.code = 'ADEN_U' AND ct.type_code = 'REC';

-- IRB at Hadramout University
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, is_active)
SELECT i.id, 'IRB-HADHRAMOUT-01', 'لجنة المراجعة المؤسسية - جامعة حضرموت', 'Hadramout University Institutional Review Board', ct.id, true
FROM security.institutions i, committee.committee_types ct
WHERE i.code = 'HADHRAMAUT_U' AND ct.type_code = 'IRB';

-- ============================================================
-- 5. COMMITTEE MEMBERS
-- ============================================================

-- ---- IRB SANAA ----
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, is_active)
SELECT c.id, u.id, '2024-06-01'::date, true
FROM committee.committees c, security.users u
WHERE c.committee_code = 'IRB-SANAA-01'
  AND u.username IN ('sanaa_chair', 'sanaa_reviewer1', 'sanaa_reviewer2', 'sanaa_admin');

-- ---- IRB ADEN ----
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, is_active)
SELECT c.id, u.id, '2024-06-01'::date, true
FROM committee.committees c, security.users u
WHERE c.committee_code = 'IRB-ADEN-01'
  AND u.username IN ('aden_chair', 'aden_reviewer1', 'aden_reviewer2', 'aden_admin');

-- ---- SRC KSU ----
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, is_active)
SELECT c.id, u.id, '2024-03-01'::date, true
FROM committee.committees c, security.users u
WHERE c.committee_code = 'SRC-KSU-01'
  AND u.username IN ('chairperson', 'reviewer1', 'reviewer3', 'ksu_reviewer4', 'ethics_admin');

-- ---- REC SANAA ----
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, is_active)
SELECT c.id, u.id, '2024-06-01'::date, true
FROM committee.committees c, security.users u
WHERE c.committee_code = 'REC-SANAA-01'
  AND u.username IN ('sanaa_chair', 'sanaa_reviewer1', 'sanaa_admin');

-- ---- DSMB KSU ----
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, is_active)
SELECT c.id, u.id, '2024-01-01'::date, true
FROM committee.committees c, security.users u
WHERE c.committee_code = 'DSMB-KSU-01'
  AND u.username IN ('chairperson', 'reviewer2', 'ethics_admin');

-- ---- IACUC KSU ----
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, is_active)
SELECT c.id, u.id, '2024-06-01'::date, true
FROM committee.committees c, security.users u
WHERE c.committee_code = 'IACUC-KSU-01'
  AND u.username IN ('chairperson', 'reviewer1', 'ksu_animal_researcher', 'ethics_admin');

-- ---- COIC KSU ----
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, is_active)
SELECT c.id, u.id, '2024-03-01'::date, true
FROM committee.committees c, security.users u
WHERE c.committee_code = 'COIC-KSU-01'
  AND u.username IN ('chairperson', 'reviewer3', 'ethics_admin');

-- ---- IRB TAIZ ----
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, is_active)
SELECT c.id, u.id, '2024-09-01'::date, true
FROM committee.committees c, security.users u
WHERE c.committee_code = 'IRB-TAIZ-01'
  AND u.username IN ('sanaa_chair', 'sanaa_reviewer2', 'sanaa_admin');

-- ---- REC ADEN ----
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, is_active)
SELECT c.id, u.id, '2024-06-01'::date, true
FROM committee.committees c, security.users u
WHERE c.committee_code = 'REC-ADEN-01'
  AND u.username IN ('aden_chair', 'aden_reviewer1', 'aden_admin');

-- ---- IRB HADHRAMOUT ----
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, is_active)
SELECT c.id, u.id, '2024-09-01'::date, true
FROM committee.committees c, security.users u
WHERE c.committee_code = 'IRB-HADHRAMOUT-01'
  AND u.username IN ('chairperson', 'reviewer1', 'reviewer2');

-- ============================================================
-- 6. MEMBER ROLE ASSIGNMENTS
-- ============================================================

-- Helper function variables pattern: role assignments by committee
-- Chair assignments
INSERT INTO committee.member_roles (member_id, role_id, start_date, is_primary, is_active)
SELECT DISTINCT cm.id, cr.id, '2024-01-01'::date, true, true
FROM committee.committee_members cm
JOIN committee.committees c ON c.id = cm.committee_id
JOIN security.users u ON u.id = cm.user_id
CROSS JOIN committee.committee_roles cr
WHERE c.committee_code IN ('SRC-KSU-01', 'DSMB-KSU-01', 'IACUC-KSU-01', 'COIC-KSU-01',
                           'IRB-HADHRAMOUT-01', 'IRB-TAIZ-01')
  AND u.username IN ('chairperson', 'sanaa_chair') AND cr.role_code = 'CHAIR';

INSERT INTO committee.member_roles (member_id, role_id, start_date, is_primary, is_active)
SELECT DISTINCT cm.id, cr.id, '2024-06-01'::date, true, true
FROM committee.committee_members cm
JOIN committee.committees c ON c.id = cm.committee_id
JOIN security.users u ON u.id = cm.user_id
CROSS JOIN committee.committee_roles cr
WHERE c.committee_code IN ('IRB-SANAA-01', 'REC-SANAA-01')
  AND u.username = 'sanaa_chair' AND cr.role_code = 'CHAIR';

INSERT INTO committee.member_roles (member_id, role_id, start_date, is_primary, is_active)
SELECT DISTINCT cm.id, cr.id, '2024-06-01'::date, true, true
FROM committee.committee_members cm
JOIN committee.committees c ON c.id = cm.committee_id
JOIN security.users u ON u.id = cm.user_id
CROSS JOIN committee.committee_roles cr
WHERE c.committee_code IN ('IRB-ADEN-01', 'REC-ADEN-01')
  AND u.username = 'aden_chair' AND cr.role_code = 'CHAIR';

-- Secretary assignments
INSERT INTO committee.member_roles (member_id, role_id, start_date, is_primary, is_active)
SELECT DISTINCT cm.id, cr.id, cm.membership_start_date, true, true
FROM committee.committee_members cm
JOIN committee.committees c ON c.id = cm.committee_id
JOIN security.users u ON u.id = cm.user_id
CROSS JOIN committee.committee_roles cr
WHERE c.committee_code IN ('IRB-SANAA-01', 'REC-SANAA-01', 'IRB-TAIZ-01')
  AND u.username = 'sanaa_admin' AND cr.role_code = 'SECRETARY';

INSERT INTO committee.member_roles (member_id, role_id, start_date, is_primary, is_active)
SELECT DISTINCT cm.id, cr.id, cm.membership_start_date, true, true
FROM committee.committee_members cm
JOIN committee.committees c ON c.id = cm.committee_id
JOIN security.users u ON u.id = cm.user_id
CROSS JOIN committee.committee_roles cr
WHERE c.committee_code IN ('IRB-ADEN-01', 'REC-ADEN-01')
  AND u.username = 'aden_admin' AND cr.role_code = 'SECRETARY';

INSERT INTO committee.member_roles (member_id, role_id, start_date, is_primary, is_active)
SELECT DISTINCT cm.id, cr.id, cm.membership_start_date, true, true
FROM committee.committee_members cm
JOIN committee.committees c ON c.id = cm.committee_id
JOIN security.users u ON u.id = cm.user_id
CROSS JOIN committee.committee_roles cr
WHERE c.committee_code IN ('SRC-KSU-01', 'DSMB-KSU-01', 'IACUC-KSU-01', 'COIC-KSU-01')
  AND u.username = 'ethics_admin' AND cr.role_code = 'SECRETARY';

-- Member assignments
INSERT INTO committee.member_roles (member_id, role_id, start_date, is_primary, is_active)
SELECT DISTINCT cm.id, cr.id, cm.membership_start_date, false, true
FROM committee.committee_members cm
JOIN committee.committees c ON c.id = cm.committee_id
JOIN security.users u ON u.id = cm.user_id
CROSS JOIN committee.committee_roles cr
WHERE c.committee_code IN ('IRB-SANAA-01', 'REC-SANAA-01')
  AND u.username IN ('sanaa_reviewer1', 'sanaa_reviewer2') AND cr.role_code = 'MEMBER';

INSERT INTO committee.member_roles (member_id, role_id, start_date, is_primary, is_active)
SELECT DISTINCT cm.id, cr.id, cm.membership_start_date, false, true
FROM committee.committee_members cm
JOIN committee.committees c ON c.id = cm.committee_id
JOIN security.users u ON u.id = cm.user_id
CROSS JOIN committee.committee_roles cr
WHERE c.committee_code IN ('IRB-ADEN-01', 'REC-ADEN-01')
  AND u.username IN ('aden_reviewer1', 'aden_reviewer2') AND cr.role_code = 'MEMBER';

INSERT INTO committee.member_roles (member_id, role_id, start_date, is_primary, is_active)
SELECT DISTINCT cm.id, cr.id, cm.membership_start_date, false, true
FROM committee.committee_members cm
JOIN committee.committees c ON c.id = cm.committee_id
JOIN security.users u ON u.id = cm.user_id
CROSS JOIN committee.committee_roles cr
WHERE c.committee_code = 'SRC-KSU-01'
  AND u.username IN ('reviewer1', 'reviewer3', 'ksu_reviewer4') AND cr.role_code = 'MEMBER';

INSERT INTO committee.member_roles (member_id, role_id, start_date, is_primary, is_active)
SELECT DISTINCT cm.id, cr.id, cm.membership_start_date, false, true
FROM committee.committee_members cm
JOIN committee.committees c ON c.id = cm.committee_id
JOIN security.users u ON u.id = cm.user_id
CROSS JOIN committee.committee_roles cr
WHERE c.committee_code = 'DSMB-KSU-01'
  AND u.username = 'reviewer2' AND cr.role_code = 'MEMBER';

INSERT INTO committee.member_roles (member_id, role_id, start_date, is_primary, is_active)
SELECT DISTINCT cm.id, cr.id, cm.membership_start_date, false, true
FROM committee.committee_members cm
JOIN committee.committees c ON c.id = cm.committee_id
JOIN security.users u ON u.id = cm.user_id
CROSS JOIN committee.committee_roles cr
WHERE c.committee_code = 'IACUC-KSU-01'
  AND u.username IN ('reviewer1', 'ksu_animal_researcher') AND cr.role_code = 'MEMBER';

INSERT INTO committee.member_roles (member_id, role_id, start_date, is_primary, is_active)
SELECT DISTINCT cm.id, cr.id, cm.membership_start_date, false, true
FROM committee.committee_members cm
JOIN committee.committees c ON c.id = cm.committee_id
JOIN security.users u ON u.id = cm.user_id
CROSS JOIN committee.committee_roles cr
WHERE c.committee_code = 'COIC-KSU-01'
  AND u.username = 'reviewer3' AND cr.role_code = 'MEMBER';

INSERT INTO committee.member_roles (member_id, role_id, start_date, is_primary, is_active)
SELECT DISTINCT cm.id, cr.id, cm.membership_start_date, false, true
FROM committee.committee_members cm
JOIN committee.committees c ON c.id = cm.committee_id
JOIN security.users u ON u.id = cm.user_id
CROSS JOIN committee.committee_roles cr
WHERE c.committee_code IN ('IRB-TAIZ-01', 'IRB-HADHRAMOUT-01')
  AND u.username IN ('reviewer1', 'reviewer2', 'sanaa_reviewer2') AND cr.role_code = 'MEMBER';

-- ============================================================
-- 7. NEW PROJECTS & APPLICATIONS (Yemeni Research)
-- ============================================================

-- ---- Project 1: Malaria in Pregnancy (Sana'a University) ----
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en,
  principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date)
SELECT i.id, 'SANAA-RES-2024-001',
  'تقييم انتشار الملاريا بين الحوامل في اليمن وتأثيرها على صحة الأم والجنين',
  'Prevalence of Malaria Among Pregnant Women in Yemen and Its Impact on Maternal and Fetal Health',
  u.id, 'CLINICAL', 'HIGH', 'UNDER_REVIEW', '2024-09-01'::date, '2025-08-31'::date
FROM security.institutions i, security.users u
WHERE i.code = 'SANAA_U' AND u.username = 'sanaa_researcher1';

-- ---- Project 2: Dengue Fever (Aden University) ----
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en,
  principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date)
SELECT i.id, 'ADEN-RES-2024-001',
  'دراسة وبائية لداء حمى الضنك في محافظة عدن وتقييم فعالية برامج المكافحة',
  'Epidemiological Study of Dengue Fever in Aden Governorate and Evaluation of Control Programs',
  u.id, 'CLINICAL', 'MEDIUM', 'UNDER_REVIEW', '2024-10-01'::date, '2025-09-30'::date
FROM security.institutions i, security.users u
WHERE i.code = 'ADEN_U' AND u.username = 'aden_researcher1';

-- ---- Project 3: Child Malnutrition (Sana'a University) ----
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en,
  principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date)
SELECT i.id, 'SANAA-RES-2024-002',
  'تقييم سوء التغذية لدى الأطفال دون سن الخامسة في المناطق الريفية بمحافظة صنعاء',
  'Assessment of Malnutrition Among Children Under Five in Rural Areas of Sana''a Governorate',
  u.id, 'SOCIAL', 'MEDIUM', 'DRAFT', '2024-11-01'::date, '2025-10-31'::date
FROM security.institutions i, security.users u
WHERE i.code = 'SANAA_U' AND u.username = 'sanaa_researcher2';

-- ---- KSU Animal Research Project ----
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en,
  principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date)
SELECT i.id, 'KSU-RES-2024-004',
  'دراسة تأثير المستخلصات النباتية اليمنية على نمو الأورام في الفئران المختبرية',
  'Effect of Yemeni Plant Extracts on Tumor Growth in Laboratory Mice',
  u.id, 'ANIMAL', 'HIGH', 'DRAFT', '2024-12-01'::date, '2026-11-30'::date
FROM security.institutions i, security.users u
WHERE i.code = 'KSU' AND u.username = 'ksu_animal_researcher';

-- ---- Applications for new projects ----
-- App 6: Malaria project
INSERT INTO core.applications (application_number, project_id, application_type, current_status, submitted_by, submission_date)
SELECT 'APP-2024-006', p.id, 'INITIAL', 'SUBMITTED', u.id, '2024-09-15 10:00:00+03'::timestamptz
FROM core.projects p, security.users u
WHERE p.project_code = 'SANAA-RES-2024-001' AND u.username = 'sanaa_researcher1';

-- App 7: Dengue project
INSERT INTO core.applications (application_number, project_id, application_type, current_status, submitted_by, submission_date)
SELECT 'APP-2024-007', p.id, 'INITIAL', 'SUBMITTED', u.id, '2024-10-10 09:30:00+03'::timestamptz
FROM core.projects p, security.users u
WHERE p.project_code = 'ADEN-RES-2024-001' AND u.username = 'aden_researcher1';

-- App 8: Malnutrition project (still in draft)
INSERT INTO core.applications (application_number, project_id, application_type, current_status, submitted_by, submission_date)
SELECT 'APP-2024-008', p.id, 'INITIAL', 'DRAFT', u.id, '2024-11-05 08:00:00+03'::timestamptz
FROM core.projects p, security.users u
WHERE p.project_code = 'SANAA-RES-2024-002' AND u.username = 'sanaa_researcher2';

-- App 9: Animal research (draft)
INSERT INTO core.applications (application_number, project_id, application_type, current_status, submitted_by, submission_date)
SELECT 'APP-2024-009', p.id, 'INITIAL', 'DRAFT', u.id, '2024-12-01 11:00:00+03'::timestamptz
FROM core.projects p, security.users u
WHERE p.project_code = 'KSU-RES-2024-004' AND u.username = 'ksu_animal_researcher';

-- ============================================================
-- 8. PROJECT TEAM MEMBERS
-- ============================================================
-- Malaria project team
INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
SELECT p.id, u.id, 'باحث رئيسي', true
FROM core.projects p, security.users u
WHERE p.project_code = 'SANAA-RES-2024-001' AND u.username = 'sanaa_researcher1';

INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
SELECT p.id, u.id, 'باحث مساعد', true
FROM core.projects p, security.users u
WHERE p.project_code = 'SANAA-RES-2024-001' AND u.username = 'sanaa_researcher2';

INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
SELECT p.id, u.id, 'منسق ميداني', true
FROM core.projects p, security.users u
WHERE p.project_code = 'SANAA-RES-2024-001' AND u.username = 'sanaa_reviewer2';

-- Dengue project team
INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
SELECT p.id, u.id, 'باحث رئيسي', true
FROM core.projects p, security.users u
WHERE p.project_code = 'ADEN-RES-2024-001' AND u.username = 'aden_researcher1';

INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
SELECT p.id, u.id, 'محلل بيانات', true
FROM core.projects p, security.users u
WHERE p.project_code = 'ADEN-RES-2024-001' AND u.username = 'aden_reviewer2';

-- Malnutrition project team
INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
SELECT p.id, u.id, 'باحث رئيسي', true
FROM core.projects p, security.users u
WHERE p.project_code = 'SANAA-RES-2024-002' AND u.username = 'sanaa_researcher2';

INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
SELECT p.id, u.id, 'مشرف أكاديمي', true
FROM core.projects p, security.users u
WHERE p.project_code = 'SANAA-RES-2024-002' AND u.username = 'sanaa_chair';

-- Animal research team
INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
SELECT p.id, u.id, 'باحث رئيسي', true
FROM core.projects p, security.users u
WHERE p.project_code = 'KSU-RES-2024-004' AND u.username = 'ksu_animal_researcher';

INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
SELECT p.id, u.id, 'مساعد مختبر', true
FROM core.projects p, security.users u
WHERE p.project_code = 'KSU-RES-2024-004' AND u.username = 'researcher1';

-- ============================================================
-- 9. NEW MEETINGS FOR NEW COMMITTEES
-- ============================================================
-- Meeting for IRB Sana'a
INSERT INTO committee.committee_meetings (committee_id, meeting_number, meeting_date, location, meeting_status, chairperson_id)
SELECT c.id, 'IRB-SANAA-MTG-001', '2024-10-20 10:00:00+03'::timestamptz, 'قاعة المؤتمرات - جامعة صنعاء', 'SCHEDULED', u.id
FROM committee.committees c, security.users u
WHERE c.committee_code = 'IRB-SANAA-01' AND u.username = 'sanaa_chair';

-- Meeting for IRB Aden
INSERT INTO committee.committee_meetings (committee_id, meeting_number, meeting_date, location, meeting_status, chairperson_id)
SELECT c.id, 'IRB-ADEN-MTG-001', '2024-10-25 10:00:00+03'::timestamptz, 'قاعة الاجتماعات - كلية الطب - جامعة عدن', 'SCHEDULED', u.id
FROM committee.committees c, security.users u
WHERE c.committee_code = 'IRB-ADEN-01' AND u.username = 'aden_chair';

-- ============================================================
-- 10. KEYWORDS & SITES FOR NEW PROJECTS
-- ============================================================
INSERT INTO core.project_keywords (project_id, keyword)
SELECT p.id, 'ملاريا'
FROM core.projects p WHERE p.project_code = 'SANAA-RES-2024-001'
UNION ALL
SELECT p.id, 'حوامل'
FROM core.projects p WHERE p.project_code = 'SANAA-RES-2024-001'
UNION ALL
SELECT p.id, 'اليمن'
FROM core.projects p WHERE p.project_code = 'SANAA-RES-2024-001'
UNION ALL
SELECT p.id, 'حمى الضنك'
FROM core.projects p WHERE p.project_code = 'ADEN-RES-2024-001'
UNION ALL
SELECT p.id, 'وبائيات'
FROM core.projects p WHERE p.project_code = 'ADEN-RES-2024-001'
UNION ALL
SELECT p.id, 'سوء التغذية'
FROM core.projects p WHERE p.project_code = 'SANAA-RES-2024-002'
UNION ALL
SELECT p.id, 'أطفال'
FROM core.projects p WHERE p.project_code = 'SANAA-RES-2024-002'
UNION ALL
SELECT p.id, 'مستخلصات نباتية'
FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-004'
UNION ALL
SELECT p.id, 'أورام'
FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-004'
UNION ALL
SELECT p.id, 'فئران مختبرية'
FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-004';

-- ============================================================
-- 11. FUNDING SOURCES
-- ============================================================
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code)
SELECT p.id, 'صندوق دعم البحث العلمي - وزارة التعليم العالي اليمن', 'GOVERNMENT', 50000.00, 'USD'
FROM core.projects p WHERE p.project_code = 'SANAA-RES-2024-001';

INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code)
SELECT p.id, 'منظمة الصحة العالمية - مكتب اليمن', 'INTERNATIONAL', 35000.00, 'USD'
FROM core.projects p WHERE p.project_code = 'ADEN-RES-2024-001';

INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code)
SELECT p.id, 'جامعة الملك سعود - كرسي البحث', 'INSTITUTIONAL', 200000.00, 'SAR'
FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-004';

-- ============================================================
-- 12. STUDY SITES
-- ============================================================
-- Malaria study sites
INSERT INTO core.project_sites (project_id, site_name, governorate, address)
SELECT p.id, 'مستشفى الثورة العام - صنعاء', 'صنعاء', 'شارع الثورة - قسم النساء والولادة'
FROM core.projects p WHERE p.project_code = 'SANAA-RES-2024-001';

INSERT INTO core.project_sites (project_id, site_name, governorate, address)
SELECT p.id, 'المركز الصحي - منطقة همدان', 'صنعاء', 'مديرية همدان'
FROM core.projects p WHERE p.project_code = 'SANAA-RES-2024-001';

INSERT INTO core.project_sites (project_id, site_name, governorate, address)
SELECT p.id, 'المركز الصحي - منطقة أرحب', 'صنعاء', 'مديرية أرحب'
FROM core.projects p WHERE p.project_code = 'SANAA-RES-2024-001';

-- Dengue study sites
INSERT INTO core.project_sites (project_id, site_name, governorate, address)
SELECT p.id, 'مستشفى الثورة بعدن', 'عدن', 'البريقة'
FROM core.projects p WHERE p.project_code = 'ADEN-RES-2024-001';

INSERT INTO core.project_sites (project_id, site_name, governorate, address)
SELECT p.id, 'مستشفى الجمهوري - عدن', 'عدن', 'خور مكسر'
FROM core.projects p WHERE p.project_code = 'ADEN-RES-2024-001';

-- Animal research site
INSERT INTO core.project_sites (project_id, site_name, governorate, address)
SELECT p.id, 'مختبر أبحاث الحيوان - كلية الطب - جامعة الملك سعود', 'الرياض', 'حي الملز - كلية الطب'
FROM core.projects p WHERE p.project_code = 'KSU-RES-2024-004';
