-- ============================================================
-- 03-COMMITTEES AND COMMITTEE MEMBERS
-- ============================================================

-- Committee Types
INSERT INTO committee.committee_types (type_code, type_name, description) VALUES
  ('IRB', 'لجنة المراجعة المؤسسية', 'Institutional Review Board'),
  ('IACUC', 'لجنة رعاية الحيوان', 'Animal Care Committee'),
  ('IBC', 'لجنة السلامة الحيوية', 'Biosafety Committee');

-- Committees
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, is_active)
SELECT i.id, 'IRB-KSU-01', 'اللجنة المؤسسية لمراجعة الأخلاقيات - جامعة الملك سعود', 'KSU Institutional Review Board', ct.id, true
FROM security.institutions i, committee.committee_types ct
WHERE i.code = 'KSU' AND ct.type_code = 'IRB';

-- Committee Roles
INSERT INTO committee.committee_roles (role_code, role_name, description) VALUES
  ('CHAIR', 'رئيس اللجنة', 'Chairperson'),
  ('VICE_CHAIR', 'نائب الرئيس', 'Vice Chairperson'),
  ('MEMBER', 'عضو', 'Member'),
  ('SECRETARY', 'سكرتير', 'Secretary'),
  ('EXTERNAL', 'عضو خارجي', 'External Member');

-- Committee Members
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, is_active)
SELECT c.id, u.id, '2024-01-01'::date, true
FROM committee.committees c, security.users u
WHERE c.committee_code = 'IRB-KSU-01'
  AND u.username IN ('chairperson', 'reviewer1', 'reviewer2', 'reviewer3', 'ethics_admin');

-- Assign Roles to Committee Members
INSERT INTO committee.member_roles (member_id, role_id, start_date, is_primary, is_active)
SELECT cm.id, cr.id, '2024-01-01'::date, true, true
FROM committee.committee_members cm
JOIN committee.committees c ON c.id = cm.committee_id
JOIN security.users u ON u.id = cm.user_id
CROSS JOIN committee.committee_roles cr
WHERE c.committee_code = 'IRB-KSU-01' AND u.username = 'chairperson' AND cr.role_code = 'CHAIR';

INSERT INTO committee.member_roles (member_id, role_id, start_date, is_primary, is_active)
SELECT cm.id, cr.id, '2024-01-01'::date, true, true
FROM committee.committee_members cm
JOIN committee.committees c ON c.id = cm.committee_id
JOIN security.users u ON u.id = cm.user_id
CROSS JOIN committee.committee_roles cr
WHERE c.committee_code = 'IRB-KSU-01' AND u.username = 'ethics_admin' AND cr.role_code = 'SECRETARY';

INSERT INTO committee.member_roles (member_id, role_id, start_date, is_primary, is_active)
SELECT cm.id, cr.id, '2024-01-01'::date, false, true
FROM committee.committee_members cm
JOIN committee.committees c ON c.id = cm.committee_id
JOIN security.users u ON u.id = cm.user_id
CROSS JOIN committee.committee_roles cr
WHERE c.committee_code = 'IRB-KSU-01' AND u.username IN ('reviewer1', 'reviewer2', 'reviewer3') AND cr.role_code = 'MEMBER';
