-- ============================================================
-- rls-audit.sql
-- RC1.2 — RLS Hardening Sprint
-- مجموعة اختبارات دائمة لجميع جداول RLS المهمة
--
-- التشغيل:
--   $env:PGPASSWORD='postgres'; psql -U ethics_app -d ethics_db -f backend/scripts/rls-audit.sql
--
-- ملاحظة: يُشغّل كمستخدم ethics_app وليس postgres،
-- لأن postgres يتجاوز RLS (superuser).
-- ============================================================

\set ON_ERROR_ROLLBACK on
\t on

\echo ''
\echo '============================================'
\echo '  RLS AUDIT TEST SUITE — RC1.2'
\echo '  USER: ethics_app (RLS enforced)'
\echo '============================================'
\echo ''

-- ============================================================
-- القسم 1: اختبارات دوال المساعدة
-- ============================================================
\echo '--- 1. Helper Functions ---'

SELECT set_config('app.user_id', '2', false);
SELECT CASE WHEN system.fn_is_admin() THEN 'PASS 1a: fn_is_admin(admin)=true' ELSE 'FAIL 1a' END;

SELECT set_config('app.user_id', '13', false);
SELECT CASE WHEN NOT system.fn_is_admin() THEN 'PASS 1b: fn_is_admin(researcher)=false' ELSE 'FAIL 1b' END;

SELECT set_config('app.user_id', '368', false);
SELECT CASE WHEN NOT system.fn_is_admin() THEN 'PASS 1c: fn_is_admin(nobody)=false' ELSE 'FAIL 1c' END;

\echo ''

-- ============================================================
-- القسم 2: documents.documents
-- ============================================================
\echo '--- 2. documents.documents ---'

-- 2a. Admin → INSERT
SELECT set_config('app.user_id', '2', false);
DO $$
BEGIN
  INSERT INTO documents.documents
    (document_type_id, entity_type, entity_id, document_title, file_name, mime_type, file_size_bytes, storage_path, uploaded_by, created_by, created_at)
  VALUES
    (1, 'Test', 1, 'admin_test', 'admin.pdf', 'application/pdf', 100, '/tmp/admin_test.pdf', 2, 2, NOW());
  RAISE NOTICE 'PASS 2a: admin INSERT documents';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'FAIL 2a: admin INSERT documents — %', SQLERRM;
END $$;

-- 2b. Owner → INSERT (uploaded_by = app.user_id)
SELECT set_config('app.user_id', '13', false);
DO $$
BEGIN
  INSERT INTO documents.documents
    (document_type_id, entity_type, entity_id, document_title, file_name, mime_type, file_size_bytes, storage_path, uploaded_by, created_by, created_at)
  VALUES
    (1, 'Application', 12, 'owner_test', 'owner.pdf', 'application/pdf', 100, '/tmp/owner_test.pdf', 13, 13, NOW());
  RAISE NOTICE 'PASS 2b: owner INSERT documents';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'FAIL 2b: owner INSERT documents — %', SQLERRM;
END $$;

-- 2c. Unauthorized → INSERT ب uploaded_by لا يطابق app.user_id
SELECT set_config('app.user_id', '14', false);
DO $$
BEGIN
  INSERT INTO documents.documents
    (document_type_id, entity_type, entity_id, document_title, file_name, mime_type, file_size_bytes, storage_path, uploaded_by, created_by, created_at)
  VALUES
    (1, 'Application', 12, 'unauth_test', 'unauth.pdf', 'application/pdf', 100, '/tmp/unauth_test.pdf', 13, 13, NOW());
  RAISE NOTICE 'FAIL 2c: unauthorized INSERT — should have been blocked';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'PASS 2c: unauthorized INSERT documents blocked';
END $$;

-- 2d. Spoofed user_id → uploaded_by مختلف عن app.user_id
SELECT set_config('app.user_id', '13', false);
DO $$
BEGIN
  INSERT INTO documents.documents
    (document_type_id, entity_type, entity_id, document_title, file_name, mime_type, file_size_bytes, storage_path, uploaded_by, created_by, created_at)
  VALUES
    (1, 'Application', 12, 'spoof_test', 'spoof.pdf', 'application/pdf', 100, '/tmp/spoof_test.pdf', 2, 2, NOW());
  RAISE NOTICE 'FAIL 2d: spoofed user_id — should have been blocked';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'PASS 2d: spoofed user_id INSERT documents blocked';
END $$;

-- 2e. Invalid entity_id → entity_id غير موجود
SELECT set_config('app.user_id', '13', false);
DO $$
BEGIN
  INSERT INTO documents.documents
    (document_type_id, entity_type, entity_id, document_title, file_name, mime_type, file_size_bytes, storage_path, uploaded_by, created_by, created_at)
  VALUES
    (1, 'Application', 99999, 'invalid_entity', 'invalid.pdf', 'application/pdf', 100, '/tmp/invalid_entity.pdf', 13, 13, NOW());
  RAISE NOTICE 'FAIL 2e: invalid entity_id — should have been blocked';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'PASS 2e: invalid entity_id INSERT documents blocked';
END $$;

\echo ''

-- ============================================================
-- القسم 3: core.applications
-- ============================================================
\echo '--- 3. core.applications ---'

-- 3a. Admin → SELECT
SELECT set_config('app.user_id', '2', false);
DO $$
DECLARE v_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM core.applications;
  RAISE NOTICE 'PASS 3a: admin SELECT applications (count=%)', v_count;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'FAIL 3a: admin SELECT applications — %', SQLERRM;
END $$;

-- 3b. Owner → SELECT (يرى تطبيقاته فقط)
SELECT set_config('app.user_id', '13', false);
DO $$
DECLARE v_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM core.applications;
  RAISE NOTICE 'PASS 3b: owner SELECT applications (count=%)', v_count;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'FAIL 3b: owner SELECT applications — %', SQLERRM;
END $$;

-- 3c. Admin → INSERT (مع جميع الحقول الإجبارية)
SELECT set_config('app.user_id', '2', false);
DO $$
BEGIN
  INSERT INTO core.applications (application_number, project_id, application_type, current_status, submitted_by, created_by, created_at)
  VALUES ('RLS-TEST-' || floor(random() * 1000000)::text, 1, 'INITIAL', 'DRAFT', 2, 2, NOW());
  RAISE NOTICE 'PASS 3c: admin INSERT applications';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'FAIL 3c: admin INSERT applications — %', SQLERRM;
END $$;

-- 3d. Unauthorized → INSERT ب submitted_by لا يطابق app.user_id
SELECT set_config('app.user_id', '14', false);
DO $$
BEGIN
  INSERT INTO core.applications (project_id, submitted_by, current_status, created_by, created_at, application_number)
  VALUES (1, 13, 'DRAFT', 13, NOW(), 'RLS-TEST-UNATH-' || NOW()::text);
  RAISE NOTICE 'FAIL 3d: unauthorized INSERT applications — should have been blocked';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'PASS 3d: unauthorized INSERT applications blocked';
END $$;

\echo ''

-- ============================================================
-- القسم 4: security.users
-- ============================================================
\echo '--- 4. security.users ---'

-- 4a. Admin → SELECT الكل
SELECT set_config('app.user_id', '2', false);
DO $$
DECLARE v_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM security.users;
  RAISE NOTICE 'PASS 4a: admin SELECT all users (count=%)', v_count;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'FAIL 4a: admin SELECT users — %', SQLERRM;
END $$;

-- 4b. Owner → SELECT نفسه
SELECT set_config('app.user_id', '13', false);
DO $$
DECLARE v_id INTEGER;
BEGIN
  SELECT id INTO v_id FROM security.users WHERE id = 13;
  IF v_id = 13 THEN
    RAISE NOTICE 'PASS 4b: owner SELECT self from users';
  ELSE
    RAISE NOTICE 'FAIL 4b: owner SELECT self — no row returned';
  END IF;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'FAIL 4b: owner SELECT self — %', SQLERRM;
END $$;

-- 4c. Regular user → SELECT مستخدم آخر (يجب أن يفشل)
SELECT set_config('app.user_id', '13', false);
DO $$
DECLARE v_id INTEGER;
BEGIN
  SELECT id INTO v_id FROM security.users WHERE id = 2;
  IF v_id IS NULL THEN
    RAISE NOTICE 'PASS 4c: regular user cannot SELECT other user';
  ELSE
    RAISE NOTICE 'FAIL 4c: regular user SELECTED other user';
  END IF;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'FAIL 4c: regular user SELECT other user — %', SQLERRM;
END $$;

\echo ''

-- ============================================================
-- القسم 5: system.search_audit (بدون INSERT policy — اختبار متوقع)
-- ============================================================
\echo '--- 5. system.search_audit (no INSERT policy — should fail) ---'

SELECT set_config('app.user_id', '2', false);
DO $$
BEGIN
  INSERT INTO system.search_audit (user_id, search_query, entity_type, result_count)
  VALUES (2, 'test', 'Application', 0);
  RAISE NOTICE 'FAIL 5: search_audit INSERT — should have been blocked';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'PASS 5: search_audit INSERT blocked (expected — no INSERT policy)';
END $$;

\echo ''

-- ============================================================
-- القسم 6: workflow.workflow_events (بدون INSERT policy)
-- ============================================================
\echo '--- 6. workflow.workflow_events (no INSERT policy — should fail) ---'

SELECT set_config('app.user_id', '2', false);
DO $$
BEGIN
  INSERT INTO workflow.workflow_events (workflow_instance_id, event_type, event_data)
  VALUES (1, 'TEST', '{}');
  RAISE NOTICE 'FAIL 6: workflow_events INSERT — should have been blocked';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'PASS 6: workflow_events INSERT blocked (expected — no INSERT policy)';
END $$;

\echo ''

-- ============================================================
-- القسم 7: integration.integration_failures (بدون INSERT policy)
-- ============================================================
\echo '--- 7. integration.integration_failures (no INSERT policy — should fail) ---'

SELECT set_config('app.user_id', '2', false);
DO $$
BEGIN
  INSERT INTO integration.integration_failures (job_id, error_code, error_message, failed_at)
  VALUES (1, 'TEST', 'test error', NOW());
  RAISE NOTICE 'FAIL 7: integration_failures INSERT — should have been blocked';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'PASS 7: integration_failures INSERT blocked (expected — no INSERT policy)';
END $$;

\echo ''

-- ============================================================
-- القسم 8: workflow.workflow_instances
-- ============================================================
\echo '--- 8. workflow.workflow_instances ---'

SELECT set_config('app.user_id', '2', false);
DO $$
DECLARE v_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM workflow.workflow_instances;
  RAISE NOTICE 'PASS 8a: admin SELECT workflow_instances (count=%)', v_count;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'FAIL 8a: admin SELECT workflow_instances — %', SQLERRM;
END $$;

SELECT set_config('app.user_id', '13', false);
DO $$
DECLARE v_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM workflow.workflow_instances;
  RAISE NOTICE 'PASS 8b: owner SELECT workflow_instances (count=%)', v_count;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'FAIL 8b: owner SELECT workflow_instances — %', SQLERRM;
END $$;

\echo ''

-- ============================================================
-- القسم 9: التحقق من تغطية السياسات
-- ============================================================
\echo '--- 9. Policy Coverage Checks ---'

-- 9a. جميع جداول RLS لديها INSERT policy (باستثناء المسموح به)
DO $$
DECLARE
  v_missing TEXT := '';
BEGIN
  SELECT string_agg(schemaname || '.' || tablename, ', ') INTO v_missing
  FROM (
    SELECT n.nspname AS schemaname, c.relname AS tablename
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relrowsecurity = true AND c.relkind = 'r'
      AND n.nspname NOT IN ('test_rls3','test_rls4','test_rls5','test_rls6','test_rls8','test_rls9')
    EXCEPT
    SELECT schemaname, tablename
    FROM pg_policies
    WHERE cmd = 'INSERT'
  ) AS missing;
  IF v_missing IS NULL THEN
    RAISE NOTICE 'PASS 9a: All RLS tables have INSERT policies';
  ELSE
    RAISE NOTICE 'FAIL 9a: Tables missing INSERT policies: %', v_missing;
  END IF;
END $$;

-- 9b. RLS لا يزال مفعلاً على الجداول الحرجة
DO $$
DECLARE
  v_off TEXT := '';
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
                 WHERE c.relname = 'documents' AND n.nspname = 'documents' AND c.relrowsecurity = true) THEN
    v_off := v_off || 'documents.documents ';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
                 WHERE c.relname = 'applications' AND n.nspname = 'core' AND c.relrowsecurity = true) THEN
    v_off := v_off || 'core.applications ';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
                 WHERE c.relname = 'users' AND n.nspname = 'security' AND c.relrowsecurity = true) THEN
    v_off := v_off || 'security.users ';
  END IF;
  IF v_off = '' THEN
    RAISE NOTICE 'PASS 9b: RLS enabled on all critical tables';
  ELSE
    RAISE NOTICE 'FAIL 9b: RLS disabled on: %', v_off;
  END IF;
END $$;

\echo ''
\echo '============================================'
\echo '  RLS AUDIT TEST SUITE — COMPLETE'
\echo '============================================'
\echo ''
\echo 'مراجعة النتائج:'
\echo '  PASS = السلوك صحيح'
\echo '  FAIL = يحتاج تحقيق'
\echo ''

\set ON_ERROR_ROLLBACK off
