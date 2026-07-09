/*
 * 46-certificate-rls-hotfix.sql
 * =============================
 *
 * Commit 3.1 — Certificate RLS Hotfix
 *
 * المصدر: فجوة صلاحية بين العقد (Architecture Contract) وتطبيق RLS.
 *
 * المشكلة:
 *   العقد يسمح لأعضاء اللجنة (COMMITTEE_CHAIR, REVIEWER) بتنزيل
 *   شهادات الاعتماد، لكن سياسات RLS الحالية تسمح فقط لصاحب الطلب
 *   والمشرفين (admin) بالوصول.
 *
 * الإصلاح:
 *   1. إضافة دالة مساعدة system.fn_is_committee_member_for_application
 *      للتحقق من عضوية المستخدم في اللجنة المختصة بالطلب.
 *   2. تحديث سياسة SELECT لجدول documents.approval_certificates.
 *   3. تحديث سياسة SELECT لجدول documents.approval_certificate_documents.
 *
 * مصفوفة الوصول بعد الإصلاح:
 *   صاحب الطلب (applicant)    → YES
 *   COMMITTEE_CHAIR            → YES
 *   REVIEWER                   → YES
 *   ETHICS_ADMIN               → YES
 *   SUPER_ADMIN                → YES
 *   العامة (Public)            → تحقق فقط (verify)
 *
 * خطة التراجع (Rollback):
 *   DROP FUNCTION IF EXISTS system.fn_is_committee_member_for_application(BIGINT, BIGINT);
 *   -- ثم إعادة تشغيل سياسات 45-certificates.sql القسم 6
 */

-- ============================================================
-- 1. Helper Function
-- ============================================================
-- تتحقق مما إذا كان المستخدم عضوًا نشطًا في اللجنة المختصة بالطلب.
-- SECURITY DEFINER لتجاوز RLS على جداول العضوية.
CREATE OR REPLACE FUNCTION system.fn_is_committee_member_for_application(
    p_user_id BIGINT,
    p_application_id BIGINT
)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM core.applications a
    JOIN committee.committee_members cm
      ON cm.committee_id = a.target_committee_id
    WHERE a.id = p_application_id
      AND cm.user_id = p_user_id
      AND cm.is_active = true
  );
$$;

COMMENT ON FUNCTION system.fn_is_committee_member_for_application(BIGINT, BIGINT) IS
  'Returns true if p_user_id is an active committee member of the committee reviewing p_application_id. SECURITY DEFINER to bypass RLS.';

-- ============================================================
-- 2. Update documents.approval_certificates SELECT policy
-- ============================================================
DROP POLICY IF EXISTS cert_select ON documents.approval_certificates;

CREATE POLICY cert_select ON documents.approval_certificates FOR SELECT
  USING (
    -- Admin: unrestricted
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    -- Applicant: certificate issued to them
    OR issued_to_user_id = (current_setting('app.user_id', true))::bigint
    -- Committee member: active member of the committee reviewing this application
    OR system.fn_is_committee_member_for_application(
         (current_setting('app.user_id', true))::bigint,
         application_id
       )
  );

COMMENT ON POLICY cert_select ON documents.approval_certificates IS
  'Allows SELECT by admin, applicant (issued_to), or active committee member of the linked application';

-- ============================================================
-- 3. Update documents.approval_certificate_documents SELECT policy
-- ============================================================
DROP POLICY IF EXISTS cert_doc_select ON documents.approval_certificate_documents;

CREATE POLICY cert_doc_select ON documents.approval_certificate_documents FOR SELECT
  USING (
    -- Admin: unrestricted
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    -- Applicant: certificate issued to them
    OR certificate_id IN (
      SELECT id FROM documents.approval_certificates
      WHERE issued_to_user_id = (current_setting('app.user_id', true))::bigint
    )
    -- Committee member: active member of the committee reviewing the linked application
    OR certificate_id IN (
      SELECT ac2.id FROM documents.approval_certificates ac2
      WHERE system.fn_is_committee_member_for_application(
        (current_setting('app.user_id', true))::bigint,
        ac2.application_id
      )
    )
  );

COMMENT ON POLICY cert_doc_select ON documents.approval_certificate_documents IS
  'Allows SELECT by admin, applicant, or active committee member (derived through linked certificate)';
