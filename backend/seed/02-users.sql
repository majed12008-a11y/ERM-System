-- ============================================================
-- 02-USERS, ROLES, PERMISSIONS
-- ============================================================

-- Roles
INSERT INTO security.roles (code, name_ar, name_en, description, is_system_role) VALUES
  ('SUPER_ADMIN', 'مدير النظام', 'Super Admin', 'Full system access', true),
  ('ETHICS_ADMIN', 'مدير أخلاقيات', 'Ethics Admin', 'Manages ethics reviews and committees', true),
  ('COMMITTEE_CHAIR', 'رئيس لجنة', 'Committee Chair', 'Chairs ethics committee meetings', true),
  ('REVIEWER', 'مراجع', 'Reviewer', 'Reviews research applications', false),
  ('RESEARCHER', 'باحث', 'Researcher', 'Submits research applications', false);

-- Permissions
INSERT INTO security.permissions (permission_code, module_name, action_name, description) VALUES
  ('application.view', 'Applications', 'View', 'View applications'),
  ('application.create', 'Applications', 'Create', 'Create applications'),
  ('application.update', 'Applications', 'Update', 'Update applications'),
  ('application.delete', 'Applications', 'Delete', 'Delete applications'),
  ('application.approve', 'Applications', 'Approve', 'Approve/reject applications'),

  ('project.view', 'Projects', 'View', 'View projects'),
  ('project.create', 'Projects', 'Create', 'Create projects'),
  ('project.update', 'Projects', 'Update', 'Update projects'),

  ('user.view', 'Users', 'View', 'View users'),
  ('user.create', 'Users', 'Create', 'Create users'),
  ('user.update', 'Users', 'Update', 'Update users'),

  ('role.view', 'Roles', 'View', 'View roles'),
  ('role.create', 'Roles', 'Create', 'Create roles'),
  ('role.update', 'Roles', 'Update', 'Update roles'),

  ('meeting.view', 'Meetings', 'View', 'View meetings'),
  ('meeting.create', 'Meetings', 'Create', 'Create meetings'),
  ('meeting.update', 'Meetings', 'Update', 'Update meetings'),

  ('review.view', 'Reviews', 'View', 'View reviews'),
  ('review.create', 'Reviews', 'Create', 'Create reviews'),
  ('review.submit', 'Reviews', 'Submit', 'Submit review decisions'),

  ('risk.view', 'Risk', 'View', 'View risk register'),
  ('risk.create', 'Risk', 'Create', 'Create risk entries'),

  ('document.view', 'Documents', 'View', 'View documents'),
  ('document.upload', 'Documents', 'Upload', 'Upload documents'),
  ('document.delete', 'Documents', 'Delete', 'Delete documents'),

  ('report.view', 'Reports', 'View', 'View reports'),
  ('report.export', 'Reports', 'Export', 'Export reports'),

  ('admin.access', 'Admin', 'Access', 'Access admin dashboard');

-- Assign permissions to SUPER_ADMIN
INSERT INTO security.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM security.roles r, security.permissions p
WHERE r.code = 'SUPER_ADMIN';

-- ETHICS_ADMIN permissions
INSERT INTO security.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM security.roles r, security.permissions p
WHERE r.code = 'ETHICS_ADMIN'
  AND p.permission_code IN ('application.view', 'application.update', 'application.approve',
    'project.view', 'user.view', 'user.create', 'user.update',
    'meeting.view', 'meeting.create', 'meeting.update',
    'review.view', 'review.create', 'review.submit',
    'document.view', 'document.upload', 'document.delete',
    'report.view', 'report.export', 'admin.access',
    'role.view', 'risk.view');

-- COMMITTEE_CHAIR permissions
INSERT INTO security.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM security.roles r, security.permissions p
WHERE r.code = 'COMMITTEE_CHAIR'
  AND p.permission_code IN ('application.view', 'application.approve',
    'project.view',
    'meeting.view', 'meeting.update',
    'review.view', 'review.submit',
    'document.view',
    'report.view');

-- REVIEWER permissions
INSERT INTO security.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM security.roles r, security.permissions p
WHERE r.code = 'REVIEWER'
  AND p.permission_code IN ('application.view',
    'review.view', 'review.submit',
    'document.view',
    'meeting.view');

-- RESEARCHER permissions
INSERT INTO security.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM security.roles r, security.permissions p
WHERE r.code = 'RESEARCHER'
  AND p.permission_code IN ('application.view', 'application.create', 'application.update',
    'project.view', 'project.create', 'project.update',
    'document.view', 'document.upload');

-- ============================================================
-- USERS (passwords: admin123 for admin, Test@1234 for others)
-- ============================================================

INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = i.id),
  'admin', 'admin@ksu.edu.sa',
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'مدير', 'النظام', 'Admin', 'User', '+966501111111', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'KSU';

INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = i.id),
  'ethics_admin', 'ethics.admin@ksu.edu.sa',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'مشرف', 'الأخلاقيات', 'Ethics', 'Admin', '+966502222222', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'KSU';

INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = i.id),
  'chairperson', 'chair@ksu.edu.sa',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'رئيس', 'اللجنة', 'Chair', 'Person', '+966503333333', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'KSU';

INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = i.id),
  'reviewer1', 'reviewer1@ksu.edu.sa',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'أحمد', 'العلي', 'Ahmed', 'Alali', '+966504444444', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'KSU';

INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'PHARM' AND d.institution_id = i.id),
  'reviewer2', 'reviewer2@ksu.edu.sa',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'سارة', 'الخالد', 'Sara', 'Alkhalid', '+966505555555', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'KSU';

INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'SCI' AND d.institution_id = i.id),
  'reviewer3', 'reviewer3@ksu.edu.sa',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'محمد', 'الزهراني', 'Mohammed', 'Alzahrani', '+966506666666', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'KSU';

INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'MED' AND d.institution_id = i.id),
  'researcher1', 'researcher1@ksu.edu.sa',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'فاطمة', 'السعيد', 'Fatima', 'Alsaid', '+966507777777', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'KSU';

INSERT INTO security.users (institution_id, department_id, username, email, password_hash,
  first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status)
SELECT i.id,
  (SELECT d.id FROM security.departments d WHERE d.code = 'DENT' AND d.institution_id = i.id),
  'researcher2', 'researcher2@ksu.edu.sa',
  '$argon2id$v=19$m=65536,t=3,p=4$+8t0KofIUsG3Ag7WosWSxA$DRNTHGs7CZmBnDRV5vYlavZ+sl8F/fx5rixE+ncyNRw',
  'خالد', 'العمر', 'Khaled', 'Alomar', '+966508888888', 'ACTIVE'
FROM security.institutions i WHERE i.code = 'KSU';

-- ============================================================
-- USER ROLES
-- ============================================================

INSERT INTO security.user_roles (user_id, role_id, assigned_by)
SELECT u.id, r.id, u.id
FROM security.users u, security.roles r
WHERE u.username = 'admin' AND r.code = 'SUPER_ADMIN';

INSERT INTO security.user_roles (user_id, role_id, assigned_by)
SELECT u.id, r.id, u.id
FROM security.users u, security.roles r
WHERE u.username = 'ethics_admin' AND r.code = 'ETHICS_ADMIN';

INSERT INTO security.user_roles (user_id, role_id, assigned_by)
SELECT u.id, r.id, u.id
FROM security.users u, security.roles r
WHERE u.username = 'chairperson' AND r.code = 'COMMITTEE_CHAIR';

INSERT INTO security.user_roles (user_id, role_id, assigned_by)
SELECT u.id, r.id, (SELECT id FROM security.users WHERE username = 'admin')
FROM security.users u, security.roles r
WHERE u.username = 'reviewer1' AND r.code = 'REVIEWER';

INSERT INTO security.user_roles (user_id, role_id, assigned_by)
SELECT u.id, r.id, (SELECT id FROM security.users WHERE username = 'admin')
FROM security.users u, security.roles r
WHERE u.username = 'reviewer2' AND r.code = 'REVIEWER';

INSERT INTO security.user_roles (user_id, role_id, assigned_by)
SELECT u.id, r.id, (SELECT id FROM security.users WHERE username = 'admin')
FROM security.users u, security.roles r
WHERE u.username = 'reviewer3' AND r.code = 'REVIEWER';

INSERT INTO security.user_roles (user_id, role_id, assigned_by)
SELECT u.id, r.id, (SELECT id FROM security.users WHERE username = 'admin')
FROM security.users u, security.roles r
WHERE u.username = 'researcher1' AND r.code = 'RESEARCHER';

INSERT INTO security.user_roles (user_id, role_id, assigned_by)
SELECT u.id, r.id, (SELECT id FROM security.users WHERE username = 'admin')
FROM security.users u, security.roles r
WHERE u.username = 'researcher2' AND r.code = 'RESEARCHER';
