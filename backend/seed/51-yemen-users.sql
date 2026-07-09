-- =============================================================================
-- 51-yemen-users.sql
-- Commit 2: Users and Security
--
-- Purpose: Create 95 users with roles, profiles, sessions, login history
-- Dependencies: Commit 1 (institutions, departments)
-- Rollback: Entire file wrapped in single transaction (ROLLBACK to undo)
-- Idempotent: No — creates transactional data. Run once in order.
-- =============================================================================

BEGIN;

SET session_replication_role = 'replica';

-- Set app.user_id to admin (1) for RLS bypass on security.users INSERT
SELECT set_config('app.user_id', '1', true);

-- Fix sequences
SELECT setval('security.users_id_seq', COALESCE((SELECT MAX(id) FROM security.users), 0) + 1, false);
SELECT setval('security.user_roles_id_seq', COALESCE((SELECT MAX(id) FROM security.user_roles), 0) + 1, false);
SELECT setval('security.user_profiles_id_seq', COALESCE((SELECT MAX(id) FROM security.user_profiles), 0) + 1, false);
SELECT setval('security.sessions_id_seq', COALESCE((SELECT MAX(id) FROM security.sessions), 0) + 1, false);
SELECT setval('security.login_audit_id_seq', COALESCE((SELECT MAX(id) FROM security.login_audit), 0) + 1, false);
SELECT setval('security.password_history_id_seq', COALESCE((SELECT MAX(id) FROM security.password_history), 0) + 1, false);
SELECT setval('security.api_keys_id_seq', COALESCE((SELECT MAX(id) FROM security.api_keys), 0) + 1, false);
SELECT setval('security.user_responsibilities_id_seq', COALESCE((SELECT MAX(id) FROM security.user_responsibilities), 0) + 1, false);

-- =============================================================================
-- STEP 1: Create 95 users via fn_register_user (SECURITY DEFINER, bypasses RLS)
-- The function returns TABLE(id, uuid, username, email)
-- =============================================================================

-- Temp table to store created user IDs
CREATE TEMP TABLE temp_users (
  user_id BIGINT,
  user_uuid UUID,
  username CITEXT,
  email CITEXT,
  role_code VARCHAR(50),
  inst_code VARCHAR(50)
);

-- Ethics Admins (4 users — IDs 2-5)
INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'ETHICS_ADMIN', 'MOH_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'MOH_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'MOH_YE' AND d.code = 'ADMIN')::int,
  'moh.ethics'::citext,
  'moh.ethics@moh.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'أحمد', 'علي', 'Ahmed', 'Ali', '+967700000001') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'ETHICS_ADMIN', 'GHO_AD'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_AD')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_AD' AND d.code = 'PUB_HLTH')::int,
  'aden.ethics'::citext,
  'aden.ethics@aden.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عائشة', 'حسن', 'Aisha', 'Hassan', '+967700000002') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'ETHICS_ADMIN', 'GHO_TZ'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_TZ')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_TZ' AND d.code = 'PUB_HLTH')::int,
  'taiz.ethics'::citext,
  'taiz.ethics@taiz.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'محمد', 'عبدالله', 'Mohammed', 'Abdullah', '+967700000003') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'ETHICS_ADMIN', 'GHO_HD'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_HD')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_HD' AND d.code = 'PUB_HLTH')::int,
  'hodeidah.ethics'::citext,
  'hodeidah.ethics@hodeidah.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'فاطمة', 'عمر', 'Fatima', 'Omar', '+967700000004') AS ru;

-- Committee Chairs (5 users — IDs 6-10)
INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'COMMITTEE_CHAIR', 'MOH_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'MOH_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'MOH_YE' AND d.code = 'ADMIN')::int,
  'chair.irb.sanaa'::citext,
  'chair.irb.sanaa@moh.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالملك', 'الحسني', 'Abdulmalik', 'Al-Hasani', '+967700000005') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'COMMITTEE_CHAIR', 'GHO_AD'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_AD')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_AD' AND d.code = 'PUB_HLTH')::int,
  'chair.irb.aden'::citext,
  'chair.irb.aden@aden.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'خالد', 'عبدالرحمن', 'Khaled', 'Abdulrahman', '+967700000006') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'COMMITTEE_CHAIR', 'U_SANA_MED'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'U_SANA_MED')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'U_SANA_MED' AND d.code = 'CLIN_MED')::int,
  'chair.rec.sanaa'::citext,
  'chair.rec.sanaa@suna.edu.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'ياسر', 'القاضي', 'Yasser', 'Al-Qadi', '+967700000007') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'COMMITTEE_CHAIR', 'CHL_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'CHL_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'CHL_YE' AND d.code = 'MICRO')::int,
  'chair.iacuc'::citext,
  'chair.iacuc@chl.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'ليلى', 'محمود', 'Laila', 'Mahmoud', '+967700000008') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'COMMITTEE_CHAIR', 'NIPH_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'NIPH_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'NIPH_YE' AND d.code = 'EPID')::int,
  'chair.ibc'::citext,
  'chair.ibc@niph.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'سمير', 'الحاج', 'Samir', 'Al-Haj', '+967700000009') AS ru;

-- Scientific Reviewers (10 users — IDs 11-20)
INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'MOH_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'MOH_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'MOH_YE' AND d.code = 'ADMIN')::int,
  'sci.rev1'::citext,
  'sci.rev1@moh.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'حسين', 'سالم', 'Hussein', 'Salem', '+967700000010') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'CHL_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'CHL_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'CHL_YE' AND d.code = 'MICRO')::int,
  'sci.rev2'::citext,
  'sci.rev2@chl.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'نورالدين', 'أحمد', 'Nour', 'Aldeen', '+967700000011') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'NIPH_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'NIPH_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'NIPH_YE' AND d.code = 'EPID')::int,
  'sci.rev3'::citext,
  'sci.rev3@niph.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'إبراهيم', 'محمد', 'Ibrahim', 'Mohammed', '+967700000012') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'H_T_SANA'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_T_SANA')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_T_SANA' AND d.code = 'INTERNAL')::int,
  'sci.rev4'::citext,
  'sci.rev4@teach-sana.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'جمال', 'الدين', 'Jamal', 'Aldeen', '+967700000013') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'H_T_ADEN'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_T_ADEN')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_T_ADEN' AND d.code = 'INTERNAL')::int,
  'sci.rev5'::citext,
  'sci.rev5@teach-aden.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'طارق', 'عبدالوهاب', 'Tariq', 'Abdulwahab', '+967700000014') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'U_SANA_MED'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'U_SANA_MED')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'U_SANA_MED' AND d.code = 'CLIN_MED')::int,
  'sci.rev6'::citext,
  'sci.rev6@med-sana.edu.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'محمد', 'الحميري', 'Mohammed', 'Al-Himyari', '+967700000015') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'U_ADEN_MED'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'U_ADEN_MED')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'U_ADEN_MED' AND d.code = 'CLIN_MED')::int,
  'sci.rev7'::citext,
  'sci.rev7@med-aden.edu.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'أحمد', 'باطرف', 'Ahmed', 'Batraf', '+967700000016') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'U_TAIZ_MED'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'U_TAIZ_MED')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'U_TAIZ_MED' AND d.code = 'CLIN_MED')::int,
  'sci.rev8'::citext,
  'sci.rev8@med-taiz.edu.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالله', 'سعيد', 'Abdullah', 'Saeed', '+967700000017') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'RI_MED_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'RI_MED_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'RI_MED_YE' AND d.code = 'CLIN_RES')::int,
  'sci.rev9'::citext,
  'sci.rev9@yimr.edu.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'فهد', 'الحارثي', 'Fahd', 'Al-Harithi', '+967700000018') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'H_SP_SANA'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_SP_SANA')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_SP_SANA' AND d.code = 'INTERNAL')::int,
  'sci.rev10'::citext,
  'sci.rev10@hosp-sana.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عصام', 'الدين', 'Essam', 'Aldeen', '+967700000019') AS ru;

-- Ethics Reviewers (10 users — IDs 21-30)
INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'MOH_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'MOH_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'MOH_YE' AND d.code = 'ADMIN')::int,
  'ethics.rev1'::citext,
  'ethics.rev1@moh.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'هدى', 'عبدالملك', 'Huda', 'Abdulmalik', '+967700000020') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'GHO_SA'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_SA')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_SA' AND d.code = 'PUB_HLTH')::int,
  'ethics.rev2'::citext,
  'ethics.rev2@gho-sana.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'بشرى', 'أحمد', 'Bushra', 'Ahmed', '+967700000021') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'GHO_AD'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_AD')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_AD' AND d.code = 'PUB_HLTH')::int,
  'ethics.rev3'::citext,
  'ethics.rev3@gho-aden.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'زينب', 'علي', 'Zainab', 'Ali', '+967700000022') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'GHO_TZ'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_TZ')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_TZ' AND d.code = 'PUB_HLTH')::int,
  'ethics.rev4'::citext,
  'ethics.rev4@gho-taiz.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'منى', 'عبدالرحمن', 'Mona', 'Abdulrahman', '+967700000023') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'GHO_HD'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_HD')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_HD' AND d.code = 'PUB_HLTH')::int,
  'ethics.rev5'::citext,
  'ethics.rev5@gho-hode.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'سلمى', 'حسن', 'Salma', 'Hassan', '+967700000024') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'DSC_EPID'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'DSC_EPID')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'DSC_EPID' AND d.code = 'FIELD')::int,
  'ethics.rev6'::citext,
  'ethics.rev6@dsc-epid.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'أحمد', 'قاسم', 'Ahmed', 'Qasim', '+967700000025') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'DSC_CHRO'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'DSC_CHRO')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'DSC_CHRO' AND d.code = 'FIELD')::int,
  'ethics.rev7'::citext,
  'ethics.rev7@dsc-chro.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'مريم', 'إسماعيل', 'Maryam', 'Ismail', '+967700000026') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'LAB_VIRO'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'LAB_VIRO')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'LAB_VIRO' AND d.code = 'DIAG')::int,
  'ethics.rev8'::citext,
  'ethics.rev8@viro-lab.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'يوسف', 'سعيد', 'Yousef', 'Saeed', '+967700000027') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'LAB_BACT'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'LAB_BACT')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'LAB_BACT' AND d.code = 'DIAG')::int,
  'ethics.rev9'::citext,
  'ethics.rev9@bact-lab.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عمر', 'عبدالله', 'Omar', 'Abdullah', '+967700000028') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'NOC_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'NOC_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'NOC_YE' AND d.code = 'CHEMO')::int,
  'ethics.rev10'::citext,
  'ethics.rev10@noc.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'سحر', 'علي', 'Sahar', 'Ali', '+967700000029') AS ru;

-- Legal Reviewers (5 users — IDs 31-35)
INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'MOH_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'MOH_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'MOH_YE' AND d.code = 'ADMIN')::int,
  'legal.rev1'::citext,
  'legal.rev1@moh.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'ناصر', 'القباطي', 'Nasser', 'Al-Qubati', '+967700000030') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'MOH_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'MOH_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'MOH_YE' AND d.code = 'ADMIN')::int,
  'legal.rev2'::citext,
  'legal.rev2@moh.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'وليد', 'الشميري', 'Waleed', 'Al-Shamiri', '+967700000031') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'MOH_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'MOH_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'MOH_YE' AND d.code = 'ADMIN')::int,
  'legal.rev3'::citext,
  'legal.rev3@moh.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالرحمن', 'الحجري', 'Abdulrahman', 'Al-Hajri', '+967700000032') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'GHO_SA'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_SA')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_SA' AND d.code = 'PUB_HLTH')::int,
  'legal.rev4'::citext,
  'legal.rev4@gho-sana.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'يحيى', 'العبسي', 'Yahya', 'Al-Absi', '+967700000033') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'GHO_AD'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_AD')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_AD' AND d.code = 'PUB_HLTH')::int,
  'legal.rev5'::citext,
  'legal.rev5@gho-aden.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالكريم', 'النهاري', 'Abdulkarim', 'Al-Nahari', '+967700000034') AS ru;

-- Biosafety Reviewers (5 users — IDs 36-40)
INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'CHL_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'CHL_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'CHL_YE' AND d.code = 'MICRO')::int,
  'bio.rev1'::citext,
  'bio.rev1@chl.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'جمال', 'العاقل', 'Jamal', 'Al-Aqil', '+967700000035') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'LAB_VIRO'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'LAB_VIRO')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'LAB_VIRO' AND d.code = 'DIAG')::int,
  'bio.rev2'::citext,
  'bio.rev2@viro-lab.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالرحمن', 'السقاف', 'Abdulrahman', 'Al-Saqqaf', '+967700000036') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'LAB_BACT'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'LAB_BACT')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'LAB_BACT' AND d.code = 'DIAG')::int,
  'bio.rev3'::citext,
  'bio.rev3@bact-lab.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'أمين', 'باجري', 'Amin', 'Bajari', '+967700000037') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'LAB_PARA'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'LAB_PARA')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'LAB_PARA' AND d.code = 'DIAG')::int,
  'bio.rev4'::citext,
  'bio.rev4@para-lab.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'صالح', 'عبدالملك', 'Saleh', 'Abdulmalik', '+967700000038') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'CHL_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'CHL_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'CHL_YE' AND d.code = 'IMM')::int,
  'bio.rev5'::citext,
  'bio.rev5@chl.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'هاني', 'عبدالغني', 'Hani', 'Abdulghani', '+967700000039') AS ru;

-- Committee Secretaries (5 users — IDs 41-45)
INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'MOH_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'MOH_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'MOH_YE' AND d.code = 'ADMIN')::int,
  'sec.irb.sanaa'::citext,
  'sec.irb.sanaa@moh.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'كمال', 'الدين', 'Kamal', 'Aldeen', '+967700000040') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'GHO_AD'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_AD')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_AD' AND d.code = 'PUB_HLTH')::int,
  'sec.irb.aden'::citext,
  'sec.irb.aden@aden.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'أمل', 'عبدالواحد', 'Amal', 'Abdulwahid', '+967700000041') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'U_SANA_MED'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'U_SANA_MED')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'U_SANA_MED' AND d.code = 'PUB_HEALTH')::int,
  'sec.rec.sanaa'::citext,
  'sec.rec.sanaa@suna.edu.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'فوزي', 'العريقي', 'Fawzi', 'Al-Ariqi', '+967700000042') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'CHL_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'CHL_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'CHL_YE' AND d.code = 'CHEM')::int,
  'sec.iacuc'::citext,
  'sec.iacuc@chl.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'رشا', 'محمد', 'Rasha', 'Mohammed', '+967700000043') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'NIPH_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'NIPH_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'NIPH_YE' AND d.code = 'TRAIN')::int,
  'sec.ibc'::citext,
  'sec.ibc@niph.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'إيمان', 'الحاج', 'Iman', 'Al-Haj', '+967700000044') AS ru;

-- Institutional Coordinators (8 users — IDs 46-53)
INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'GHO_SA'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_SA')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_SA' AND d.code = 'PUB_HLTH')::int,
  'coord.sanaa'::citext,
  'coord.sanaa@moh.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالله', 'الحمزة', 'Abdullah', 'Al-Hamza', '+967700000045') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'GHO_AD'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_AD')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_AD' AND d.code = 'PUB_HLTH')::int,
  'coord.aden'::citext,
  'coord.aden@aden.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'رياض', 'أحمد', 'Riyadh', 'Ahmed', '+967700000046') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'GHO_TZ'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_TZ')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_TZ' AND d.code = 'PUB_HLTH')::int,
  'coord.taiz'::citext,
  'coord.taiz@taiz.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'محمد', 'عبده', 'Mohammed', 'Abdu', '+967700000047') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'GHO_HD'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_HD')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_HD' AND d.code = 'PUB_HLTH')::int,
  'coord.hodeidah'::citext,
  'coord.hodeidah@hodeidah.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبده', 'صالح', 'Abdu', 'Saleh', '+967700000048') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'GHO_IB'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_IB')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_IB' AND d.code = 'PUB_HLTH')::int,
  'coord.ibb'::citext,
  'coord.ibb@ibb.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'أحمد', 'سيف', 'Ahmed', 'Saif', '+967700000049') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'GHO_DH'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_DH')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_DH' AND d.code = 'PUB_HLTH')::int,
  'coord.dhamar'::citext,
  'coord.dhamar@dhamar.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'علي', 'الحميري', 'Ali', 'Al-Himyari', '+967700000050') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'GHO_MK'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_MK')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_MK' AND d.code = 'PUB_HLTH')::int,
  'coord.mukalla'::citext,
  'coord.mukalla@mukalla.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عمر', 'باجابر', 'Omar', 'Bajaber', '+967700000051') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'GHO_HJ'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_HJ')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_HJ' AND d.code = 'PUB_HLTH')::int,
  'coord.hajjah'::citext,
  'coord.hajjah@hajjah.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالمجيد', 'الحداء', 'Abdulmajeed', 'Al-Hadda', '+967700000052') AS ru;

-- Auditors (3 users — IDs 54-56)
INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'MOH_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'MOH_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'MOH_YE' AND d.code = 'FINANCE')::int,
  'auditor1'::citext,
  'auditor1@moh.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'أحمد', 'الجرادي', 'Ahmed', 'Al-Jaradi', '+967700000053') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'MOH_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'MOH_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'MOH_YE' AND d.code = 'FINANCE')::int,
  'auditor2'::citext,
  'auditor2@moh.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالرحمن', 'المعمري', 'Abdulrahman', 'Al-Maamari', '+967700000054') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'REVIEWER', 'MOH_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'MOH_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'MOH_YE' AND d.code = 'QUALITY')::int,
  'auditor3'::citext,
  'auditor3@moh.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'علي', 'الزبيري', 'Ali', 'Al-Zubairi', '+967700000055') AS ru;

-- Researchers (40 users — IDs 57-96)
INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'MOH_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'MOH_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'MOH_YE' AND d.code = 'PLAN')::int,
  'researcher.moh'::citext,
  'researcher.moh@moh.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'جميل', 'الشرعبي', 'Jameel', 'Al-Sharabi', '+967700000056') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'CHL_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'CHL_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'CHL_YE' AND d.code = 'CHEM')::int,
  'researcher.chl'::citext,
  'researcher.chl@chl.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'نوال', 'أحمد', 'Nawal', 'Ahmed', '+967700000057') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'NIPH_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'NIPH_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'NIPH_YE' AND d.code = 'STATS')::int,
  'researcher.niph'::citext,
  'researcher.niph@niph.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'فكري', 'قاسم', 'Fikri', 'Qasim', '+967700000058') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'NOC_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'NOC_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'NOC_YE' AND d.code = 'SURG_ONC')::int,
  'researcher.noc'::citext,
  'researcher.noc@noc.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'باسم', 'الجرادي', 'Bassem', 'Al-Jaradi', '+967700000059') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'NNI_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'NNI_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'NNI_YE' AND d.code = 'CLIN_NUTR')::int,
  'researcher.nni'::citext,
  'researcher.nni@nni.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'تغريد', 'عبدالله', 'Taghreed', 'Abdullah', '+967700000060') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'NBTC_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'NBTC_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'NBTC_YE' AND d.code = 'PROCESS')::int,
  'researcher.nbtc'::citext,
  'researcher.nbtc@nbtc.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'محسن', 'مرشد', 'Mohsen', 'Murshid', '+967700000061') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'GHO_SA'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_SA')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_SA' AND d.code = 'PREV_MED')::int,
  'researcher.gho.sana'::citext,
  'researcher.gho.sana@moh.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'صادق', 'السماوي', 'Sadiq', 'Al-Samawi', '+967700000062') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'GHO_AD'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_AD')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_AD' AND d.code = 'PREV_MED')::int,
  'researcher.gho.aden'::citext,
  'researcher.gho.aden@aden.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'سالم', 'القحطاني', 'Salem', 'Al-Qahtani', '+967700000063') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'GHO_TZ'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_TZ')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_TZ' AND d.code = 'PREV_MED')::int,
  'researcher.gho.taiz'::citext,
  'researcher.gho.taiz@taiz.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'نبيل', 'العريقي', 'Nabeel', 'Al-Ariqi', '+967700000064') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'GHO_HD'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_HD')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_HD' AND d.code = 'PREV_MED')::int,
  'researcher.gho.hode'::citext,
  'researcher.gho.hode@hodeidah.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'شوقي', 'هائل', 'Shawqi', 'Hael', '+967700000065') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'GHO_IB'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_IB')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_IB' AND d.code = 'PREV_MED')::int,
  'researcher.gho.ibb'::citext,
  'researcher.gho.ibb@ibb.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالسلام', 'الورفي', 'Abdulsalam', 'Al-Warfi', '+967700000066') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'GHO_DH'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_DH')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_DH' AND d.code = 'PREV_MED')::int,
  'researcher.gho.dham'::citext,
  'researcher.gho.dham@dhamar.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'فؤاد', 'الضحياني', 'Fuad', 'Al-Dhahyani', '+967700000067') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'GHO_MK'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_MK')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_MK' AND d.code = 'PREV_MED')::int,
  'researcher.gho.mukalla'::citext,
  'researcher.gho.mukalla@mk.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'هاني', 'سويلم', 'Hani', 'Sweilem', '+967700000068') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'GHO_HJ'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'GHO_HJ')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'GHO_HJ' AND d.code = 'PREV_MED')::int,
  'researcher.gho.hajjah'::citext,
  'researcher.gho.hajjah@hajjah.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالعزيز', 'القباطي', 'Abdulaziz', 'Al-Qubati', '+967700000069') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'H_SP_SANA'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_SP_SANA')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_SP_SANA' AND d.code = 'INTERNAL')::int,
  'researcher.hosp.sana'::citext,
  'researcher.hosp.sana@sana.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'حليمة', 'ياسين', 'Halima', 'Yasin', '+967700000070') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'H_SP_ADEN'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_SP_ADEN')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_SP_ADEN' AND d.code = 'PEDIATRICS')::int,
  'researcher.hosp.aden'::citext,
  'researcher.hosp.aden@aden.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالله', 'الجابري', 'Abdullah', 'Al-Jabri', '+967700000071') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'H_SP_TAIZ'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_SP_TAIZ')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_SP_TAIZ' AND d.code = 'SURGERY')::int,
  'researcher.hosp.taiz'::citext,
  'researcher.hosp.taiz@taiz.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'منصور', 'الأغبري', 'Mansour', 'Al-Aghbari', '+967700000072') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'H_SP_HODE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_SP_HODE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_SP_HODE' AND d.code = 'OBGYN')::int,
  'researcher.hosp.hode'::citext,
  'researcher.hosp.hode@hodeidah.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'صبري', 'عبدالملك', 'Sabri', 'Abdulmalik', '+967700000073') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'H_SP_IBB'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_SP_IBB')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_SP_IBB' AND d.code = 'INTERNAL')::int,
  'researcher.hosp.ibb'::citext,
  'researcher.hosp.ibb@ibb.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'رشاد', 'الحميدي', 'Rashad', 'Al-Humaidi', '+967700000074') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'H_SP_DHAM'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_SP_DHAM')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_SP_DHAM' AND d.code = 'PEDIATRICS')::int,
  'researcher.hosp.dham'::citext,
  'researcher.hosp.dham@dhamar.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالله', 'عوض', 'Abdullah', 'Awad', '+967700000075') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'H_SP_MUKA'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_SP_MUKA')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_SP_MUKA' AND d.code = 'SURGERY')::int,
  'researcher.hosp.mukalla'::citext,
  'researcher.hosp.mukalla@mk.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'سالم', 'بن بريك', 'Salem', 'Bin Brik', '+967700000076') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'H_SP_HAJJ'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_SP_HAJJ')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_SP_HAJJ' AND d.code = 'INTERNAL')::int,
  'researcher.hosp.hajjah'::citext,
  'researcher.hosp.hajjah@hajjah.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'تركي', 'غالب', 'Turki', 'Ghaleb', '+967700000077') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'H_MS_ADEN'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_MS_ADEN')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_MS_ADEN' AND d.code = 'OBGYN')::int,
  'researcher.mch.aden'::citext,
  'researcher.mch.aden@aden.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'أروى', 'محمد', 'Arwa', 'Mohammed', '+967700000078') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'H_ER_SANA'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_ER_SANA')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_ER_SANA' AND d.code = 'ER')::int,
  'researcher.emerg.sana'::citext,
  'researcher.emerg.sana@sana.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'قصي', 'الأكوع', 'Qusai', 'Al-Akwa', '+967700000079') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'H_T_SANA'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_T_SANA')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_T_SANA' AND d.code = 'SURGERY')::int,
  'researcher.teach.sana'::citext,
  'researcher.teach.sana@sana.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'خالد', 'القاضي', 'Khaled', 'Al-Qadi', '+967700000080') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'H_T_ADEN'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_T_ADEN')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_T_ADEN' AND d.code = 'INTERNAL')::int,
  'researcher.teach.aden'::citext,
  'researcher.teach.aden@aden.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالله', 'باجري', 'Abdullah', 'Bajari', '+967700000081') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'H_T_TAIZ'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_T_TAIZ')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_T_TAIZ' AND d.code = 'PEDIATRICS')::int,
  'researcher.teach.taiz'::citext,
  'researcher.teach.taiz@taiz.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'محمد', 'السالمي', 'Mohammed', 'Al-Salimi', '+967700000082') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'H_T_HODE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_T_HODE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_T_HODE' AND d.code = 'OBGYN')::int,
  'researcher.teach.hode'::citext,
  'researcher.teach.hode@hodeidah.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'أحمد', 'شيباني', 'Ahmed', 'Shaibani', '+967700000083') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'H_T_MUKA'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'H_T_MUKA')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'H_T_MUKA' AND d.code = 'INTERNAL')::int,
  'researcher.teach.mukalla'::citext,
  'researcher.teach.mukalla@mk.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالناصر', 'حسين', 'Abdulnasser', 'Hussein', '+967700000084') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'U_SANA_MED'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'U_SANA_MED')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'U_SANA_MED' AND d.code = 'BASIC_SCI')::int,
  'researcher.med.sana'::citext,
  'researcher.med.sana@suna.edu.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالملك', 'المتوكل', 'Abdulmalik', 'Al-Mutawakkil', '+967700000085') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'U_ADEN_MED'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'U_ADEN_MED')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'U_ADEN_MED' AND d.code = 'BASIC_SCI')::int,
  'researcher.med.aden'::citext,
  'researcher.med.aden@aden-univ.net'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'أروى', 'الجرادي', 'Arwa', 'Al-Jaradi', '+967700000086') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'U_TAIZ_MED'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'U_TAIZ_MED')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'U_TAIZ_MED' AND d.code = 'BASIC_SCI')::int,
  'researcher.med.taiz'::citext,
  'researcher.med.taiz@taiz.edu.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'نادية', 'عبدالله', 'Nadia', 'Abdullah', '+967700000087') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'U_HODE_MED'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'U_HODE_MED')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'U_HODE_MED' AND d.code = 'BASIC_SCI')::int,
  'researcher.med.hode'::citext,
  'researcher.med.hode@hoduniv.edu.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالله', 'حسن', 'Abdullah', 'Hassan', '+967700000088') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'U_IBB_MED'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'U_IBB_MED')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'U_IBB_MED' AND d.code = 'BASIC_SCI')::int,
  'researcher.med.ibb'::citext,
  'researcher.med.ibb@ibbuniv.edu.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'إبراهيم', 'القباطي', 'Ibrahim', 'Al-Qubati', '+967700000089') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'LAB_VIRO'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'LAB_VIRO')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'LAB_VIRO' AND d.code = 'RES')::int,
  'researcher.viro'::citext,
  'researcher.viro@lab.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالرقيب', 'الشرجبي', 'Abdulraqeeb', 'Al-Sharjabi', '+967700000090') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'LAB_BACT'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'LAB_BACT')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'LAB_BACT' AND d.code = 'RES')::int,
  'researcher.bact'::citext,
  'researcher.bact@lab.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'بشرى', 'شمسان', 'Bushra', 'Shamsan', '+967700000091') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'LAB_PARA'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'LAB_PARA')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'LAB_PARA' AND d.code = 'RES')::int,
  'researcher.para'::citext,
  'researcher.para@lab.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'عبدالغني', 'حميد', 'Abdulghani', 'Humaid', '+967700000092') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'DSC_EPID'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'DSC_EPID')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'DSC_EPID' AND d.code = 'DATA')::int,
  'researcher.dsc.epid'::citext,
  'researcher.dsc.epid@epi.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'ماجد', 'الحضرمي', 'Majed', 'Al-Hadrami', '+967700000093') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'DSC_CHRO'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'DSC_CHRO')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'DSC_CHRO' AND d.code = 'DATA')::int,
  'researcher.dsc.chro'::citext,
  'researcher.dsc.chro@chro.gov.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'محمد', 'بن يحيى', 'Mohammed', 'Bin Yahya', '+967700000094') AS ru;

INSERT INTO temp_users (user_id, user_uuid, username, email, role_code, inst_code)
SELECT ru.id, ru.uuid, ru.username, ru.email, 'RESEARCHER', 'RI_MED_YE'
FROM security.fn_register_user(
(SELECT id FROM security.institutions WHERE code = 'RI_MED_YE')::int,
  (SELECT d.id FROM security.departments d JOIN security.institutions i ON i.id = d.institution_id WHERE i.code = 'RI_MED_YE' AND d.code = 'EPID_RES')::int,
  'researcher.yimr'::citext,
  'researcher.yimr@yimr.edu.ye'::citext,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y',
  'أيمن', 'الشاوش', 'Ayman', 'Al-Shawish', '+967700000095') AS ru;

-- =============================================================================
-- STEP 2: Insert user_roles (1 per user, 95 new rows)
-- =============================================================================
INSERT INTO security.user_roles (user_id, role_id, assigned_by)
SELECT tu.user_id, r.id, 1
FROM temp_users tu
JOIN security.roles r ON r.code = tu.role_code;

-- =============================================================================
-- STEP 3: Insert user_profiles (95 profiles)
-- =============================================================================
INSERT INTO security.user_profiles (user_id, national_id, gender, date_of_birth, nationality_code, academic_title, specialization)
SELECT
  tu.user_id,
  LPAD((ROW_NUMBER() OVER (ORDER BY tu.user_id))::text, 9, '0')::int,
  CASE WHEN tu.user_id IN (3,5,8,21,22,23,24,26,30,41,43,44,57,60,65,70,73,78,79,81,82,84,86,87,88,91,94) THEN 'FEMALE' ELSE 'MALE' END,
  (DATE '1960-01-01' + (tu.user_id * 73 % 12000)::int),
  'YE',
  CASE
    WHEN r.code IN ('SUPER_ADMIN', 'ETHICS_ADMIN') THEN 'دكتور'
    WHEN r.code = 'COMMITTEE_CHAIR' THEN 'أستاذ دكتور'
    WHEN r.code = 'REVIEWER' THEN 'دكتور'
    ELSE 'باحث'
  END,
  CASE
    WHEN tu.inst_code LIKE 'H_%' THEN 'طب سريري'
    WHEN tu.inst_code LIKE 'U_%MED' THEN 'علوم طبية'
    WHEN tu.inst_code LIKE 'LAB_%' THEN 'علوم مختبرية'
    WHEN tu.inst_code LIKE 'DSC_%' THEN 'وبائيات'
    WHEN tu.inst_code LIKE 'RI_%' THEN 'بحوث صحية'
    WHEN tu.inst_code LIKE 'GHO_%' THEN 'صحة عامة'
    ELSE 'إدارة صحية'
  END
FROM temp_users tu
JOIN security.roles r ON r.code = tu.role_code;

-- =============================================================================
-- STEP 4: Insert sessions (95 sessions)
-- =============================================================================
INSERT INTO security.sessions (user_id, ip_address, user_agent, login_at, expires_at)
SELECT
  tu.user_id,
  ('10.0.0.' || (tu.user_id % 254 + 1)::text)::inet,
  'Mozilla/5.0 Yemen Validation Dataset',
  now() - (INTERVAL '1 day' * (tu.user_id % 30)),
  now() + INTERVAL '7 days'
FROM temp_users tu;

-- =============================================================================
-- STEP 5: Insert login_audit (~200 entries — mix of success/failure)
-- =============================================================================
WITH audit_data AS (
  SELECT tu.user_id, tu.username::text AS uname
  FROM temp_users tu
  UNION ALL
  SELECT tu.user_id, tu.username::text
  FROM temp_users tu
  WHERE tu.user_id % 5 = 0
  UNION ALL
  SELECT NULL, random_username
  FROM (VALUES ('unknown.user'), ('hacker'), ('test'), ('admin_copy'), ('external')) AS u(random_username)
)
INSERT INTO security.login_audit (user_id, username_attempt, login_time, success, ip_address, failure_reason)
SELECT
  ad.user_id,
  ad.uname,
  now() - (INTERVAL '1 hour' * (ROW_NUMBER() OVER (ORDER BY random()) % 720)),
  CASE WHEN ad.user_id IS NOT NULL AND random() < 0.85 THEN true ELSE false END,
  ('10.0.' || (ad.user_id % 10)::text || '.' || (ad.user_id % 254 + 1)::text)::inet,
  CASE WHEN ad.user_id IS NULL THEN 'User not found'
       WHEN random() < 0.5 THEN 'Invalid password'
       ELSE 'Account locked'
  END
FROM audit_data ad
LIMIT 200;

-- =============================================================================
-- STEP 6: Insert password_history (1 per user)
-- =============================================================================
INSERT INTO security.password_history (user_id, password_hash)
SELECT tu.user_id,
  '$argon2id$v=19$m=65536,t=3,p=4$HOFZ6XX9/oNYZ+5odyihSQ$rvy8IpREw6giOK/JcxJr75HxFUwpUVT65pp4xwQgr/Y'
FROM temp_users tu;

-- =============================================================================
-- STEP 7: Insert api_keys (10 keys for admin + some ethics admins)
-- =============================================================================
INSERT INTO security.api_keys (user_id, key_name, api_key_hash, expires_at)
SELECT
  tu.user_id,
  tu.username::text || '_api_key',
  encode(gen_random_bytes(32), 'hex'),
  now() + INTERVAL '365 days'
FROM temp_users tu
WHERE tu.role_code IN ('ETHICS_ADMIN', 'COMMITTEE_CHAIR')
  AND tu.user_id IN (SELECT user_id FROM temp_users ORDER BY user_id LIMIT 10);

-- =============================================================================
-- STEP 8: Insert user_responsibilities (~45 entries)
-- =============================================================================
-- Secretaries get SECRETARY responsibility
INSERT INTO security.user_responsibilities (user_id, responsibility_type_id, entity_type, entity_id, assigned_by)
SELECT tu.user_id, 6, 'committee',
  CASE tu.inst_code
    WHEN 'MOH_YE' THEN 0
    WHEN 'GHO_AD' THEN 0
    WHEN 'U_SANA_MED' THEN 0
    WHEN 'CHL_YE' THEN 0
    WHEN 'NIPH_YE' THEN 0
  END,
  1
FROM temp_users tu
WHERE tu.username IN ('sec.irb.sanaa', 'sec.irb.aden', 'sec.rec.sanaa', 'sec.iacuc', 'sec.ibc');

-- Coordinators get COORDINATOR responsibility
INSERT INTO security.user_responsibilities (user_id, responsibility_type_id, entity_type, entity_id, assigned_by)
SELECT tu.user_id, 5, 'institution',
  (SELECT id FROM security.institutions WHERE code = tu.inst_code),
  1
FROM temp_users tu
WHERE tu.role_code = 'REVIEWER'
  AND tu.username LIKE 'coord.%';

-- Auditor assignments get OBSERVER responsibility
INSERT INTO security.user_responsibilities (user_id, responsibility_type_id, entity_type, entity_id, assigned_by)
SELECT tu.user_id, 4, 'system',
  (SELECT id FROM security.institutions WHERE code = 'MOH_YE')::int,
  1
FROM temp_users tu
WHERE tu.username IN ('auditor1', 'auditor2', 'auditor3');

-- =============================================================================
-- STEP 9: Fix sequences
-- =============================================================================
SELECT setval('security.users_id_seq', COALESCE((SELECT MAX(id) FROM security.users), 0) + 1, false);
SELECT setval('security.user_roles_id_seq', COALESCE((SELECT MAX(id) FROM security.user_roles), 0) + 1, false);
SELECT setval('security.user_profiles_id_seq', COALESCE((SELECT MAX(id) FROM security.user_profiles), 0) + 1, false);
SELECT setval('security.sessions_id_seq', COALESCE((SELECT MAX(id) FROM security.sessions), 0) + 1, false);
SELECT setval('security.login_audit_id_seq', COALESCE((SELECT MAX(id) FROM security.login_audit), 0) + 1, false);
SELECT setval('security.password_history_id_seq', COALESCE((SELECT MAX(id) FROM security.password_history), 0) + 1, false);
SELECT setval('security.api_keys_id_seq', COALESCE((SELECT MAX(id) FROM security.api_keys), 0) + 1, false);
SELECT setval('security.user_responsibilities_id_seq', COALESCE((SELECT MAX(id) FROM security.user_responsibilities), 0) + 1, false);

-- Re-enable FK triggers
SET session_replication_role = 'origin';

-- =============================================================================
-- VERIFICATION
-- =============================================================================
DO $$
DECLARE
  v_total_users INTEGER;
  v_total_roles INTEGER;
  v_total_profiles INTEGER;
  v_total_sessions INTEGER;
  v_total_login_audit INTEGER;
  v_total_password_history INTEGER;
  v_total_api_keys INTEGER;
  v_total_responsibilities INTEGER;
  v_fk_violations INTEGER;
  v_seq_ok BOOLEAN;
  v_seq_check INTEGER;
  v_role_dist RECORD;
BEGIN
  -- Row counts
  SELECT COUNT(*) INTO v_total_users FROM security.users;
  SELECT COUNT(*) INTO v_total_roles FROM security.user_roles;
  SELECT COUNT(*) INTO v_total_profiles FROM security.user_profiles;
  SELECT COUNT(*) INTO v_total_sessions FROM security.sessions;
  SELECT COUNT(*) INTO v_total_login_audit FROM security.login_audit;
  SELECT COUNT(*) INTO v_total_password_history FROM security.password_history;
  SELECT COUNT(*) INTO v_total_api_keys FROM security.api_keys;
  SELECT COUNT(*) INTO v_total_responsibilities FROM security.user_responsibilities;

  RAISE NOTICE '=== COMMIT 2 VERIFICATION ===';
  RAISE NOTICE 'Users total: % (expected 96 = 1 admin + 95 new)', v_total_users;
  RAISE NOTICE 'User roles: % (expected 96 = 1 admin + 95 new)', v_total_roles;
  RAISE NOTICE 'User profiles: % (expected 96)', v_total_profiles;
  RAISE NOTICE 'Sessions: % (expected ~96)', v_total_sessions;
  RAISE NOTICE 'Login audit: % (expected ~200)', v_total_login_audit;
  RAISE NOTICE 'Password history: % (expected ~96)', v_total_password_history;
  RAISE NOTICE 'API keys: % (expected ~10)', v_total_api_keys;
  RAISE NOTICE 'User responsibilities: % (expected ~45)', v_total_responsibilities;

  -- FK violations: institution_id must reference existing institutions
  SELECT COUNT(*) INTO v_fk_violations
  FROM security.users u
  WHERE NOT EXISTS (SELECT 1 FROM security.institutions i WHERE i.id = u.institution_id);
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'FK VIOLATION: % users reference non-existent institutions', v_fk_violations;
  END IF;
  RAISE NOTICE 'FK institution_id: OK (0 violations)';

  -- FK violations: department_id must reference existing departments
  SELECT COUNT(*) INTO v_fk_violations
  FROM security.users u
  WHERE u.department_id IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM security.departments d WHERE d.id = u.department_id);
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'FK VIOLATION: % users reference non-existent departments', v_fk_violations;
  END IF;
  RAISE NOTICE 'FK department_id: OK (0 violations)';

  -- FK violations: role_id must reference existing roles
  SELECT COUNT(*) INTO v_fk_violations
  FROM security.user_roles ur
  WHERE NOT EXISTS (SELECT 1 FROM security.roles r WHERE r.id = ur.role_id);
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'FK VIOLATION: % user_roles reference non-existent roles', v_fk_violations;
  END IF;
  RAISE NOTICE 'FK role_id: OK (0 violations)';

  -- FK violations: user_id must reference existing users
  SELECT COUNT(*) INTO v_fk_violations
  FROM security.user_roles ur
  WHERE NOT EXISTS (SELECT 1 FROM security.users u WHERE u.id = ur.user_id);
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'FK VIOLATION: % user_roles reference non-existent users', v_fk_violations;
  END IF;
  RAISE NOTICE 'FK user_roles->users: OK (0 violations)';

  -- UNIQUE constraints: no duplicate emails or usernames
  SELECT COUNT(*) INTO v_fk_violations
  FROM security.users
  GROUP BY email
  HAVING COUNT(*) > 1;
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'UNIQUE VIOLATION: duplicate emails found';
  END IF;
  RAISE NOTICE 'UNIQUE emails: OK';

  SELECT COUNT(*) INTO v_fk_violations
  FROM security.users
  GROUP BY username
  HAVING COUNT(*) > 1;
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'UNIQUE VIOLATION: duplicate usernames found';
  END IF;
  RAISE NOTICE 'UNIQUE usernames: OK';

  -- UNIQUE constraint: (user_id, role_id)
  SELECT COUNT(*) INTO v_fk_violations
  FROM security.user_roles
  GROUP BY user_id, role_id
  HAVING COUNT(*) > 1;
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'UNIQUE VIOLATION: duplicate user+role combinations';
  END IF;
  RAISE NOTICE 'UNIQUE user_roles (user_id, role_id): OK';

  -- UNIQUE constraint: user_profiles (user_id)
  SELECT COUNT(*) INTO v_fk_violations
  FROM security.user_profiles
  GROUP BY user_id
  HAVING COUNT(*) > 1;
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'UNIQUE VIOLATION: duplicate user_profiles';
  END IF;
  RAISE NOTICE 'UNIQUE user_profiles (user_id): OK';

  -- Sequence health (call nextval to populate pg_sequences.last_value on PG18)
  SELECT nextval('security.users_id_seq')
    INTO v_seq_check;
  v_seq_ok := (v_seq_check = (SELECT COALESCE(MAX(id), 0) + 1 FROM security.users));
  -- Reset sequence back to proper value
  PERFORM setval('security.users_id_seq', v_seq_check - 1, true);
  IF NOT v_seq_ok THEN
    RAISE EXCEPTION 'SEQUENCE MISMATCH: users_id_seq at % but MAX(id) + 1 = %', v_seq_check, (SELECT COALESCE(MAX(id), 0) + 1 FROM security.users);
  END IF;
  RAISE NOTICE 'Sequences: OK';

  -- NOT NULL constraints
  SELECT COUNT(*) INTO v_fk_violations
  FROM security.users
  WHERE username IS NULL OR email IS NULL OR password_hash IS NULL OR institution_id IS NULL;
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'NOT NULL VIOLATION: % users have NULL required fields', v_fk_violations;
  END IF;
  RAISE NOTICE 'NOT NULL constraints: OK';

  -- CHECK constraint: status
  SELECT COUNT(*) INTO v_fk_violations
  FROM security.users
  WHERE status NOT IN ('ACTIVE', 'INACTIVE', 'LOCKED', 'SUSPENDED');
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'CHECK VIOLATION: % users have invalid status', v_fk_violations;
  END IF;
  RAISE NOTICE 'CHECK status: OK';

  -- Role distribution summary
  RAISE NOTICE '=== ROLE DISTRIBUTION ===';
  FOR v_role_dist IN
    SELECT r.code, COUNT(*) AS cnt
    FROM security.user_roles ur
    JOIN security.roles r ON r.id = ur.role_id
    GROUP BY r.code
    ORDER BY r.code
  LOOP
    RAISE NOTICE '%: %', v_role_dist.code, v_role_dist.cnt;
  END LOOP;

  -- BUSINESS VALIDATION: Department belongs to the correct institution
  SELECT COUNT(*) INTO v_fk_violations
  FROM security.users u
  JOIN security.departments d ON d.id = u.department_id
  WHERE d.institution_id != u.institution_id;
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'BUSINESS RULE: % users have department-institution mismatch', v_fk_violations;
  END IF;
  RAISE NOTICE 'Department-institution match: OK (0 mismatches)';

  -- BUSINESS VALIDATION: No user in THU except admin
  SELECT COUNT(*) INTO v_fk_violations
  FROM security.users u
  JOIN security.institutions i ON i.id = u.institution_id
  WHERE i.code = 'THU' AND u.id > 1;
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'BUSINESS RULE: % users incorrectly assigned to THU', v_fk_violations;
  END IF;
  RAISE NOTICE 'No non-admin users in THU: OK';

  RAISE NOTICE '=== COMMIT 2 PASSED ===';
END $$;

COMMIT;

DROP TABLE IF EXISTS temp_users;
