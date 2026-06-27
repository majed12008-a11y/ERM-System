-- ============================================================
-- 11-RLS-FIX
-- 1. Add missing INSERT policy for security.users
-- 2. Fix fn_log_audit to treat user_id=0 as NULL (prevents FK violation)
-- 3. Grant USAGE on sequence for currval()
-- ============================================================
-- إصلاحات RLS: إضافة سياسة INSERT للمستخدمين، إصلاح fn_log_audit،
-- ومنح صلاحيات على المتسلسلات. أساسي لتشغيل نظام التسجيل.

BEGIN;

-- ----- آلية عمل سياسة INSERT ---------------------------------
-- تسمح هذه السياسة بإدراج سجل جديد عندما يكون المستخدم غير مُسجّل
-- الدخول (app.user_id = 0) أو عندما يكون المستخدم مسؤولاً (admin).
--
-- ملاحظة مهمة:
--   في PostgreSQL 18.3 على Windows، سياسات FOR INSERT لا تعمل
--   بسبب خلل في المحرّك. تم إنشاء دالة SECURITY DEFINER
--   (security.fn_register_user) في الملف 33-fix-register-rls.sql
--   لتجاوز هذا الخلل. تبقى هذه السياسة موجودة كمرجع ولتعمل تلقائياً
--   إذا تم إصلاح الخلل في إصدار مستقبلي من PostgreSQL.
-- ----------------------------------------------------------------
DROP POLICY IF EXISTS users_insert_policy ON security.users;
CREATE POLICY users_insert_policy ON security.users FOR INSERT
  WITH CHECK (
    (current_setting('app.user_id', true))::bigint = 0
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  );

-- Fix fn_log_audit to treat user_id=0 as NULL (prevents FK violation on audit_logs)
CREATE OR REPLACE FUNCTION system.fn_log_audit()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
    v_audit_log_id BIGINT;
    v_user_id BIGINT;
    v_operation VARCHAR(50);
BEGIN
    IF TG_OP = 'INSERT' THEN
        v_operation := 'CREATE';
    ELSIF TG_OP = 'UPDATE' THEN
        v_operation := 'UPDATE';
    ELSIF TG_OP = 'DELETE' THEN
        v_operation := 'DELETE';
    END IF;

    BEGIN
        v_user_id := current_setting('app.user_id')::BIGINT;
        IF v_user_id = 0 THEN
            v_user_id := NULL;
        END IF;
    EXCEPTION WHEN OTHERS THEN
        v_user_id := NULL;
    END;

    BEGIN
        INSERT INTO audit.audit_logs (user_id, entity_name, entity_id, operation_type, source_ip)
        VALUES (
            v_user_id,
            TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,
            CASE WHEN TG_OP = 'INSERT' THEN NEW.id WHEN TG_OP = 'UPDATE' THEN NEW.id ELSE OLD.id END,
            v_operation,
            NULL
        )
        RETURNING id INTO v_audit_log_id;
    EXCEPTION WHEN foreign_key_violation THEN
        -- user_id references non-existent user; retry with NULL
        INSERT INTO audit.audit_logs (user_id, entity_name, entity_id, operation_type, source_ip)
        VALUES (
            NULL,
            TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,
            CASE WHEN TG_OP = 'INSERT' THEN NEW.id WHEN TG_OP = 'UPDATE' THEN NEW.id ELSE OLD.id END,
            v_operation,
            NULL
        )
        RETURNING id INTO v_audit_log_id;
    END;

    IF TG_OP = 'UPDATE' THEN
        IF NEW.id IS DISTINCT FROM OLD.id THEN
            INSERT INTO audit.audit_details (audit_log_id, field_name, old_value, new_value)
            VALUES (v_audit_log_id, 'id', OLD.id::TEXT, NEW.id::TEXT);
        END IF;
    END IF;

    RETURN NEW;
END;
$function$;

-- Grant USAGE on users_id_seq so currval() works for ethics_app
GRANT USAGE ON SEQUENCE security.users_id_seq TO ethics_app;

COMMIT;
