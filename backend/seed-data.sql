-- seed-data.sql
-- Run: $env:PGPASSWORD='postgres'; psql -U postgres -d ethics_db -f backend/seed-data.sql

BEGIN;

SET app.user_id = '1';

-- ============================================================
-- LOOKUPS (FK targets)
-- ============================================================
INSERT INTO committee.committee_types (id, type_code, type_name, description)
OVERRIDING SYSTEM VALUE
VALUES (1, 'INSTITUTIONAL', 'لجنة مؤسسية', 'Institutional Review Board'),
       (2, 'NATIONAL', 'لجنة وطنية', 'National Ethics Committee')
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- USERS
-- ============================================================
INSERT INTO security.users (id, institution_id, username, email, password_hash, first_name_ar, last_name_ar, status)
OVERRIDING SYSTEM VALUE
VALUES
  (2, 1, 'researcher', 'researcher@example.com',
   '$argon2id$v=19$m=65536,t=3,p=4$p9MhNca3I36dn38uCEBNPQ$1cAzBr9O/r2jrGSByIug13x8eM+5pMWr/jOkPPStY9k',
   'أحمد', 'الباحث', 'ACTIVE'),
  (3, 1, 'reviewer', 'reviewer@ethics.gov',
   '$argon2id$v=19$m=65536,t=3,p=4$p9MhNca3I36dn38uCEBNPQ$1cAzBr9O/r2jrGSByIug13x8eM+5pMWr/jOkPPStY9k',
   'سارة', 'المراجع', 'ACTIVE'),
  (4, 1, 'officer', 'officer@ethics.gov',
   '$argon2id$v=19$m=65536,t=3,p=4$p9MhNca3I36dn38uCEBNPQ$1cAzBr9O/r2jrGSByIug13x8eM+5pMWr/jOkPPStY9k',
   'خالد', 'الموظف', 'ACTIVE')
ON CONFLICT (id) DO NOTHING;

INSERT INTO security.user_roles (user_id, role_id, assigned_by)
SELECT u.id, r.id, 1
FROM (VALUES ('researcher', 'RESEARCHER'), ('reviewer', 'REVIEWER'), ('officer', 'ETHICS_OFFICER')) AS x(username, role_code)
JOIN security.users u ON u.username = x.username
JOIN security.roles r ON r.code = x.role_code
ON CONFLICT DO NOTHING;

-- ============================================================
-- PERMISSIONS (Phase 3 activation)
-- ============================================================
WITH seed_permissions AS (
  INSERT INTO security.permissions (permission_code, module_name, action_name, description)
  VALUES
    ('user.view', 'users', 'view', 'عرض المستخدمين'),
    ('user.create', 'users', 'create', 'إنشاء مستخدمين'),
    ('user.edit', 'users', 'edit', 'تعديل المستخدمين'),
    ('user.delete', 'users', 'delete', 'حذف المستخدمين'),
    ('user.assign_roles', 'users', 'assign_roles', 'تعيين أدوار للمستخدمين'),
    ('role.view', 'roles', 'view', 'عرض الأدوار'),
    ('role.create', 'roles', 'create', 'إنشاء أدوار'),
    ('role.edit', 'roles', 'edit', 'تعديل الأدوار'),
    ('role.delete', 'roles', 'delete', 'حذف الأدوار'),
    ('role.assign_permissions', 'roles', 'assign_permissions', 'تعيين صلاحيات للأدوار'),
    ('application.view', 'applications', 'view', 'عرض الطلبات'),
    ('application.create', 'applications', 'create', 'إنشاء طلبات'),
    ('application.review', 'applications', 'review', 'مراجعة الطلبات'),
    ('application.approve', 'applications', 'approve', 'اعتماد الطلبات'),
    ('application.delete', 'applications', 'delete', 'حذف الطلبات'),
    ('project.view', 'projects', 'view', 'عرض المشاريع'),
    ('project.create', 'projects', 'create', 'إنشاء مشاريع'),
    ('project.edit', 'projects', 'edit', 'تعديل المشاريع'),
    ('project.delete', 'projects', 'delete', 'حذف المشاريع'),
    ('committee.view', 'committee', 'view', 'عرض اللجان'),
    ('committee.manage', 'committee', 'manage', 'إدارة اللجان'),
    ('meeting.view', 'committee', 'view_meetings', 'عرض الاجتماعات'),
    ('meeting.create', 'committee', 'create_meetings', 'جدولة الاجتماعات'),
    ('review.view', 'reviews', 'view', 'عرض المراجعات'),
    ('review.submit', 'reviews', 'submit', 'تقديم مراجعة'),
    ('risk.view', 'risk', 'view', 'عرض سجل المخاطر'),
    ('risk.create', 'risk', 'create', 'تسجيل مخاطرة'),
    ('risk.edit', 'risk', 'edit', 'تعديل المخاطر'),
    ('report.view', 'reports', 'view', 'عرض التقارير'),
    ('report.export', 'reports', 'export', 'تصدير التقارير'),
    ('system.config', 'system', 'config', 'إعدادات النظام'),
    ('admin.full_access', 'admin', 'full_access', 'صلاحية كاملة للنظام')
  ON CONFLICT (permission_code) DO NOTHING
  RETURNING id, permission_code
)
-- Assign permissions to roles
INSERT INTO security.role_permissions (role_id, permission_id)
SELECT r.id, sp.id
FROM (VALUES
  ('SUPER_ADMIN', ARRAY['user.view', 'user.create', 'user.edit', 'user.delete', 'user.assign_roles',
    'role.view', 'role.create', 'role.edit', 'role.delete', 'role.assign_permissions',
    'application.view', 'application.create', 'application.review', 'application.approve', 'application.delete',
    'project.view', 'project.create', 'project.edit', 'project.delete',
    'committee.view', 'committee.manage', 'meeting.view', 'meeting.create',
    'review.view', 'review.submit',
    'risk.view', 'risk.create', 'risk.edit',
    'report.view', 'report.export',
    'system.config', 'admin.full_access']),
  ('ADMIN', ARRAY['user.view', 'user.create', 'user.edit', 'user.assign_roles',
    'role.view',
    'application.view', 'application.create', 'application.review', 'application.approve',
    'project.view', 'project.create', 'project.edit',
    'committee.view', 'committee.manage', 'meeting.view', 'meeting.create',
    'review.view', 'review.submit',
    'risk.view', 'risk.create', 'risk.edit',
    'report.view', 'report.export']),
  ('ETHICS_OFFICER', ARRAY['user.view',
    'application.view', 'application.review', 'application.approve',
    'project.view',
    'committee.view', 'meeting.view',
    'review.view', 'review.submit',
    'risk.view', 'risk.create',
    'report.view', 'report.export']),
  ('REVIEWER', ARRAY['application.view', 'application.review',
    'project.view',
    'meeting.view',
    'review.view', 'review.submit',
    'risk.view']),
  ('RESEARCHER', ARRAY['application.create', 'application.view',
    'project.create', 'project.view', 'project.edit',
    'risk.view'])
) AS x(role_code, perms)
JOIN security.roles r ON r.code = x.role_code
JOIN seed_permissions sp ON sp.permission_code = ANY(x.perms)
ON CONFLICT DO NOTHING;

-- ============================================================
-- RESPONSIBILITY TYPES (Phase 16)
-- ============================================================
INSERT INTO security.responsibility_types (code, name_ar, name_en, description)
VALUES
  ('REVIEWER', 'مراجع', 'Reviewer', 'مراجعة الطلبات'),
  ('APPROVER', 'معتمد', 'Approver', 'اعتماد القرارات'),
  ('SIGNER', 'موقع', 'Signer', 'التوقيع على الموافقات'),
  ('OBSERVER', 'مراقب', 'Observer', 'متابعة العمل'),
  ('COORDINATOR', 'منسق', 'Coordinator', 'تنسيق الأعمال'),
  ('SECRETARY', 'سكرتير', 'Secretary', 'توثيق المحاضر')
ON CONFLICT (code) DO NOTHING;

-- ============================================================
-- RESEARCH CATEGORIES (Phase 18)
-- ============================================================
INSERT INTO core.research_categories (code, name_ar, name_en, description)
VALUES
  ('CLINICAL_TRIAL', 'تجربة سريرية', 'Clinical Trial', 'بحث يتضمن تدخل علاجي'),
  ('BEHAVIORAL', 'بحث سلوكي', 'Behavioral Research', 'دراسة السلوك البشري'),
  ('SOCIAL_SCIENCE', 'بحث اجتماعي', 'Social Science', 'دراسة الظواهر الاجتماعية'),
  ('LABORATORY', 'بحث مخبري', 'Laboratory Research', 'تحليل عينات بيولوجية'),
  ('ANIMAL', 'بحث حيواني', 'Animal Research', 'دراسات حيوانات التجارب')
ON CONFLICT (code) DO NOTHING;

-- ============================================================
-- VULNERABLE POPULATIONS (Phase 18)
-- ============================================================
INSERT INTO core.vulnerable_populations (code, name_ar, name_en, safeguards_required)
VALUES
  ('CHILDREN', 'أطفال', 'Children', 'موافقة ولي الأمر'),
  ('PREGNANT', 'حوامل', 'Pregnant Women', 'تقييم المخاطر على الجنين'),
  ('PRISONERS', 'سجناء', 'Prisoners', 'ضمان عدم الإكراه'),
  ('DISABLED', 'ذوو الإعاقة', 'Disabled', 'توفير وسائل تواصل')
ON CONFLICT (code) DO NOTHING;

-- ============================================================
-- DOCUMENT CLASSIFICATIONS (Phase 19)
-- ============================================================
INSERT INTO documents.document_classifications (code, name_ar, name_en, description, clearance_required)
VALUES
  ('PUBLIC', 'عام', 'Public', 'متاح للجميع', 1),
  ('INTERNAL', 'داخلي', 'Internal', 'متاح للموظفين', 2),
  ('CONFIDENTIAL', 'خاص', 'Confidential', 'للمخولين فقط', 3),
  ('SECRET', 'سري', 'Secret', 'درجة عالية من السرية', 4)
ON CONFLICT (code) DO NOTHING;

-- ============================================================
-- PROFESSIONS REGISTRY (Phase 21)
-- ============================================================
INSERT INTO reference.professions_registry (code, name_ar, name_en, category)
VALUES
  ('PHYSICIAN', 'طبيب', 'Physician', 'MEDICAL'),
  ('PHARMACIST', 'صيدلي', 'Pharmacist', 'MEDICAL'),
  ('NURSE', 'ممرض', 'Nurse', 'MEDICAL'),
  ('RESEARCHER', 'باحث', 'Researcher', 'RESEARCH'),
  ('BIOETHICIST', 'أخصائي أخلاقيات', 'Bioethicist', 'ETHICS'),
  ('LAB_TECH', 'فني مختبر', 'Lab Technician', 'TECHNICAL'),
  ('ADMIN', 'إداري', 'Administrator', 'ADMIN')
ON CONFLICT (code) DO NOTHING;

-- ============================================================
-- COMMITTEE
-- ============================================================
INSERT INTO committee.committees (id, institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, establishment_date, is_active)
OVERRIDING SYSTEM VALUE
VALUES (1, 1, 'NEC', 'اللجنة الوطنية للأخلاقيات', 'National Ethics Committee', 1, '2026-01-01', TRUE)
ON CONFLICT (id) DO NOTHING;

INSERT INTO committee.committee_members (id, committee_id, user_id, membership_start_date, membership_end_date, is_active)
OVERRIDING SYSTEM VALUE
VALUES (1, 1, 1, '2026-01-01', '2028-12-31', TRUE),
       (2, 1, 3, '2026-01-01', '2028-12-31', TRUE)
ON CONFLICT (id) DO NOTHING;

INSERT INTO committee.committee_member_roles (member_id, role_id)
SELECT 1, cr.id FROM committee.committee_roles cr WHERE cr.role_code = 'CHAIR'
UNION ALL
SELECT 2, cr.id FROM committee.committee_roles cr WHERE cr.role_code = 'MEMBER';

INSERT INTO committee.member_terms (member_id, start_date, end_date, appointment_decision_no, is_active)
VALUES (1, '2026-01-01', '2028-12-31', 'ق ١٢٣', TRUE),
       (2, '2026-01-01', '2028-12-31', 'ق ١٢٤', TRUE);

INSERT INTO committee.member_qualifications (member_id, specialization, academic_degree, institution_name, experience_years, is_verified, verified_by)
VALUES (1, 'إدارة صحية', 'دكتوراه', 'جامعة الملك سعود', 10, TRUE, 1),
       (2, 'طب بشري', 'بكالوريوس', 'جامعة الملك عبدالعزيز', 14, TRUE, 1);

INSERT INTO security.user_responsibilities (user_id, responsibility_type_id, entity_type, entity_id, assigned_by)
SELECT 3, rt.id, 'committee', 1, 1
FROM security.responsibility_types rt WHERE rt.code = 'REVIEWER';

-- ============================================================
-- PROJECTS
-- ============================================================
INSERT INTO core.projects (id, institution_id, project_code, title_ar, title_en, abstract_ar, principal_investigator_id, research_category, status_code, start_date, expected_end_date)
OVERRIDING SYSTEM VALUE
VALUES
  (1, 1, 'PRJ-2026-001', 'تأثير دواء جديد على مرضى السكري',
   'Effect of a novel drug on diabetes patients',
   'دراسة سريرية لتقييم فعالية وسلامة دواء جديد لمرضى السكري من النوع الثاني',
   2, 'CLINICAL_TRIAL', 'ACTIVE', '2026-03-01', '2027-03-01'),
  (2, 1, 'PRJ-2026-002', 'مسح وطني لانتشار الأمراض المزمنة',
   'National survey of chronic disease prevalence',
   'مسح ميداني لتحديد معدلات انتشار الأمراض المزمنة',
   2, 'OBSERVATIONAL', 'UNDER_REVIEW', '2026-05-01', '2026-12-31')
ON CONFLICT (id) DO NOTHING;

INSERT INTO core.project_team_members (project_id, user_id, role_name, is_active)
VALUES (1, 2, 'PRINCIPAL_INVESTIGATOR', TRUE),
       (2, 2, 'PRINCIPAL_INVESTIGATOR', TRUE);

-- ============================================================
-- APPLICATIONS
-- ============================================================
INSERT INTO core.applications (id, application_number, project_id, application_type, current_status, submission_date, submitted_by, priority_level)
OVERRIDING SYSTEM VALUE
VALUES (1, 'APP-2026-001', 1, 'INITIAL', 'DRAFT', NULL, 2, 'NORMAL'),
       (2, 'APP-2026-002', 2, 'INITIAL', 'SUBMITTED', NOW() - INTERVAL '3 days', 2, 'HIGH')
ON CONFLICT (id) DO NOTHING;

INSERT INTO core.application_versions (application_id, version_no, snapshot_data, created_by)
VALUES (2, 1, '{"title":"Chronic disease survey","objective":"Determine prevalence rates","methodology":"Field survey","population":"Adults 18+","sample_size":5000}', 2);

-- ============================================================
-- COMMITTEE MEETING + REVIEWS
-- ============================================================
INSERT INTO committee.committee_meetings (id, committee_id, meeting_number, meeting_date, location, meeting_status, chairperson_id)
OVERRIDING SYSTEM VALUE
VALUES (1, 1, 1, NOW() + INTERVAL '7 days', 'قاعة الاجتماعات الرئيسية', 'SCHEDULED', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date, status_code)
SELECT 2, 3, 'FULL_BOARD', 1, NOW() + INTERVAL '14 days', 'PENDING';

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
INSERT INTO communication.notifications (user_id, notification_type, subject, message_body, priority_level)
VALUES
  (1, 'REVIEW_REQUEST', 'طلب جديد للمراجعة', 'تم تقديم طلب APP-2026-002', 'HIGH'),
  (3, 'ASSIGNMENT', 'طلب مراجعة', 'تم تعيينك مراجعاً للطلب APP-2026-002', 'HIGH'),
  (2, 'STATUS_UPDATE', 'تم تقديم الطلب', 'تم تقديم طلبك APP-2026-002', 'NORMAL');

-- ============================================================
-- RISK REGISTER (Phase 20)
-- ============================================================
INSERT INTO safety.risk_register (risk_code, risk_title, risk_description, likelihood, impact, risk_level, owner_id, status)
VALUES
  ('RSK-001', 'تسرب بيانات المرضى', 'تسرب البيانات الشخصية للمرضى', 3, 4, 'HIGH', 1, 'IDENTIFIED'),
  ('RSK-002', 'مخالفة بروتوكول البحث', 'انحراف عن بروتوكول البحث المعتمد', 2, 3, 'MEDIUM', 2, 'IDENTIFIED'),
  ('RSK-003', 'تأخير الموافقات', 'تأخر الحصول على الموافقات الأخلاقية', 4, 2, 'MEDIUM', 4, 'ASSESSED')
ON CONFLICT (risk_code) DO NOTHING;

INSERT INTO safety.risk_mitigations (risk_id, mitigation_plan, responsible_party, target_date, status)
SELECT id, 'تشفير بيانات المرضى وتطبيق سياسة خصوصية', 1, '2026-07-01', 'PLANNED'
FROM safety.risk_register WHERE risk_code = 'RSK-001';

-- ============================================================
-- SAVED SEARCH (Phase 22)
-- ============================================================
INSERT INTO system.saved_searches (user_id, search_name, entity_type, search_criteria, is_shared)
VALUES (1, 'الطلبات الجديدة', 'applications', '{"current_status":"SUBMITTED"}', TRUE);

COMMIT;
