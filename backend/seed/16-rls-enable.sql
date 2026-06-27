-- 16-rls-enable.sql
-- Ensures ROW LEVEL SECURITY is enabled on all tables that have policies.
-- This must run AFTER all policy definitions have been created.
-- Run: psql -U postgres -d ethics_db -f seed/16-rls-enable.sql
-- تفعيل RLS على جميع الجداول التي لديها سياسات.
-- يجب تشغيله بعد إنشاء جميع تعريفات السياسات.

DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        SELECT n.nspname AS schema, c.relname AS table
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE EXISTS (SELECT 1 FROM pg_policy p WHERE p.polrelid = c.oid)
          AND NOT c.relrowsecurity
    LOOP
        EXECUTE format('ALTER TABLE %I.%I ENABLE ROW LEVEL SECURITY', rec.schema, rec.table);
        RAISE NOTICE 'ENABLED RLS on %.%', rec.schema, rec.table;
    END LOOP;
END $$;
