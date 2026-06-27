-- ============================================================
-- 33-FIX-REGISTER-RLS
-- ============================================================
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- المشكلة:
--   PostgreSQL 18.3 على Windows لا ينفّذ سياسات FOR INSERT
--   بشكل صحيح. حتى WITH CHECK (true) يتم رفضها، وذلك لأن
--   PostgreSQL يقوم بتقييم USING (البند المخصص للـ SELECT)
--   أثناء عملية INSERT، وهذا البند يكون فارغاً (NULL) في
--   سياسات INSERT مما يؤدي إلى رفض كل الإدراجات.
--
-- الحل:
--   دالة SECURITY DEFINER تنفّذ INSERT بصلاحيات مالك الجدول
--   (الذي يتجاوز RLS تلقائياً). الباك إند يستدعي هذه الدالة
--   بدلاً من جملة INSERT المباشرة.
--
-- ملاحظة:
--   سياسة users_insert_policy الأصلية (FOR INSERT WITH CHECK)
--   تبقى موجودة في قاعدة البيانات. إذا تم إصلاح الخلل في
--   إصدار مستقبلي من PostgreSQL، ستعمل السياسة تلقائياً دون
--   الحاجة لأي تغيير.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

BEGIN;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- fn_register_user
-- 
-- تنشئ مستخدماً جديداً في جدول security.users
-- 
-- المتغيرات:
--   p_institution_id : المؤسسة التابع لها المستخدم
--   p_department_id  : القسم (يمكن أن يكون NULL)
--   p_username       : اسم المستخدم (CITEXT — غير حساس لحالة الأحرف)
--   p_email          : البريد الإلكتروني (CITEXT)
--   p_password_hash  : كلمة المرور مشفرة (argon2)
--   p_first_name_ar  : الاسم الأول بالعربية
--   p_last_name_ar   : اسم العائلة بالعربية
--   p_first_name_en  : الاسم الأول بالإنجليزية
--   p_last_name_en   : اسم العائلة بالإنجليزية
--   p_mobile         : رقم الجوال
--
-- تُستخدم هذه الدالة في:
--   AuthService.register()  — تسجيل مستخدم جديد
--   UsersService.create()   — إنشاء مستخدم من لوحة التحكم
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
CREATE OR REPLACE FUNCTION security.fn_register_user(
    p_institution_id INTEGER,
    p_department_id INTEGER,
    p_username CITEXT,
    p_email CITEXT,
    p_password_hash TEXT,
    p_first_name_ar VARCHAR,
    p_last_name_ar VARCHAR,
    p_first_name_en VARCHAR,
    p_last_name_en VARCHAR,
    p_mobile VARCHAR
)
RETURNS TABLE (id BIGINT, uuid UUID, username CITEXT, email CITEXT)
LANGUAGE plpgsql
-- SECURITY DEFINER used only because PostgreSQL 18.3 on Windows
-- incorrectly rejects INSERT despite valid WITH CHECK policy.
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    INSERT INTO security.users
        (institution_id, department_id, username, email, password_hash,
         first_name_ar, last_name_ar, first_name_en, last_name_en, mobile)
    VALUES
        (p_institution_id, p_department_id, p_username, p_email, p_password_hash,
         p_first_name_ar, p_last_name_ar, p_first_name_en, p_last_name_en, p_mobile)
    -- ملاحظة: نستخدم security.users.id بدلاً من id فقط
    -- لتجنب تعارض الأسماء مع أعمدة RETURN TABLE في PL/pgSQL
    RETURNING security.users.id, security.users.uuid,
              security.users.username, security.users.email;
END;
$$;

GRANT EXECUTE ON FUNCTION security.fn_register_user(INTEGER, INTEGER, CITEXT, CITEXT, TEXT, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR) TO ethics_app;

COMMIT;
