-- bootstrap.sql
-- Creates initial institution + super admin user for testing
-- Run: $env:PGPASSWORD='postgres'; psql -U postgres -d ethics_db -f backend/bootstrap.sql

BEGIN;

-- 1. Institution
INSERT INTO security.institutions (id, code, name_ar, name_en, institution_type_id, is_active)
OVERRIDING SYSTEM VALUE
VALUES (1, 'MOH', 'وزارة الصحة', 'Ministry of Health', 1, TRUE)
ON CONFLICT (id) DO NOTHING;

-- 2. Department
INSERT INTO security.departments (id, institution_id, code, name_ar, name_en)
OVERRIDING SYSTEM VALUE
VALUES (1, 1, 'RESEARCH', 'إدارة المعلومات والبحوث', 'Research Department')
ON CONFLICT (id) DO NOTHING;

-- 3. Admin user (password: admin123)
INSERT INTO security.users (id, institution_id, username, email, password_hash, first_name_ar, last_name_ar, status)
OVERRIDING SYSTEM VALUE
VALUES (1, 1, 'admin', 'admin@ethics.gov',
  '$argon2id$v=19$m=65536,t=3,p=4$p9MhNca3I36dn38uCEBNPQ$1cAzBr9O/r2jrGSByIug13x8eM+5pMWr/jOkPPStY9k',
  'مدير', 'النظام', 'ACTIVE')
ON CONFLICT (id) DO NOTHING;

-- 4. Assign admin role
INSERT INTO security.user_roles (user_id, role_id, assigned_by)
SELECT 1, id, 1 FROM security.roles WHERE code = 'ADMIN'
ON CONFLICT DO NOTHING;

COMMIT;
