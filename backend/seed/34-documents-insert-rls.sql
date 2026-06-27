/*
 * 34-documents-insert-rls.sql
 * ===========================
 *
 * إضافة سياسة INSERT لجدول documents.documents.
 *
 * الخلفية:
 *   جدول documents.documents مفعّل عليه RLS، لكنه كان يفتقد سياسة INSERT،
 *   مما يؤدي إلى خطأ "new row violates row-level security policy" عند رفع أي مستند.
 *
 * المنطق:
 *   - المشرف (Admin): يُسمح له بإدراج أي مستند دون قيود.
 *   - المستخدم العادي:
 *       1. يجب أن يكون uploaded_by مساوياً لمعرّف المستخدم في الجلسة.
 *       2. إذا كان entity_type = 'Application' وكان entity_id معروفاً،
 *          يجب أن يكون المستخدم هو مالك الطلب (submitted_by).
 *
 * ملاحظة عن PostgreSQL 18.3 على Windows:
 *   وفقاً لتوثيق سابق (33-fix-register-rls.sql)، قد لا تعمل سياسات FOR INSERT
 *   بشكل صحيح على Windows. إذا ثبت فشل هذه السياسة، سيتم إنشاء نسخة بديلة
 *   باستخدام FOR ALL USING (true) WITH CHECK (...) كحل بديل.
 */

-- إسقاط السياسة القديمة إن وجدت (في حالة إعادة التشغيل)
DROP POLICY IF EXISTS documents_insert_policy ON documents.documents;

-- إنشاء سياسة INSERT
CREATE POLICY documents_insert_policy ON documents.documents
  FOR INSERT
  WITH CHECK (
    -- المشرف: مسموح له بإدراج أي مستند
    system.fn_is_admin(current_setting('app.user_id')::bigint)
    OR
    (
      -- المستخدم العادي: uploaded_by يجب أن يطابق هويته
      uploaded_by = current_setting('app.user_id')::bigint
      AND
      (
        -- إذا كان المستند مرتبطاً بتطبيق، تحقق من ملكية التطبيق
        entity_type IS DISTINCT FROM 'Application'
        OR entity_id IS NULL
        OR EXISTS (
          SELECT 1
          FROM core.applications a
          WHERE a.id = entity_id
            AND a.submitted_by = current_setting('app.user_id')::bigint
            AND a.deleted_at IS NULL
        )
      )
    )
  );
