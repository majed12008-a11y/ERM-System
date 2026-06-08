-- ============================================================
-- 03-COMMITTEES AND COMMITTEE MEMBERS
-- ============================================================

-- Committee Types
INSERT INTO committee.committee_types (type_code, type_name, description) VALUES
  ('IRB', 'Institutional Review Board', 'لجنة المراجعة المؤسسية'),
  ('IACUC', 'Animal Care Committee', 'لجنة رعاية الحيوان'),
  ('IBC', 'Biosafety Committee', 'لجنة السلامة الحيوية');

-- Committees
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, is_active)
SELECT i.id, 'IRB-KSU-01', 'اللجنة المؤسسية لمراجعة الأخلاقيات - جامعة الملك سعود', 'KSU Institutional Review Board', ct.id, true
FROM security.institutions i, committee.committee_types ct
WHERE i.code = 'KSU' AND ct.type_code = 'IRB';

-- Committee Roles
INSERT INTO committee.committee_roles (role_code, role_name, description) VALUES
  ('CHAIR', 'Chairperson', 'رئيس اللجنة'),
  ('VICE_CHAIR', 'Vice Chairperson', 'نائب الرئيس'),
  ('MEMBER', 'Member', 'عضو'),
  ('SECRETARY', 'Secretary', 'سكرتير'),
  ('EXTERNAL', 'External Member', 'عضو خارجي');

-- Committee Members
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, is_active)
SELECT c.id, u.id, '2024-01-01'::date, true
FROM committee.committees c, security.users u
WHERE c.committee_code = 'IRB-KSU-01'
  AND u.username IN ('chairperson', 'reviewer1', 'reviewer2', 'reviewer3', 'ethics_admin');
