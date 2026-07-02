-- ============================================================
-- 41-APPLICATION-CONDITIONS.SQL
-- ============================================================
-- جدول شروط الموافقة المشروطة للطلبات.
-- يخزن الشروط التي تضعها اللجنة عند الموافقة المشروطة على طلب،
-- ويربطها بسير العمل (COMMITTEE_CONDITIONAL → AWAITING_CONDITIONS
-- → CONDITIONS_MET / CONDITIONS_NOT_MET).
--
-- يعمل هذا السكربت بشكل آمن عند إعادة التشغيل (idempotent)
-- باستخدام IF NOT EXISTS / OR REPLACE.
-- ============================================================

BEGIN;

-- ============================================================
-- 1. إنشاء الجدول
-- ============================================================
CREATE TABLE IF NOT EXISTS committee.application_conditions (
  id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  application_id    BIGINT NOT NULL REFERENCES core.applications(id) ON DELETE CASCADE,
  condition_text    TEXT NOT NULL,
  severity          VARCHAR(10) NOT NULL DEFAULT 'MAJOR'
                      CHECK (severity IN ('MINOR', 'MAJOR', 'CRITICAL')),
  category          VARCHAR(50) DEFAULT 'GENERAL'
                      CHECK (category IN ('GENERAL', 'SCIENTIFIC', 'ETHICAL', 'ADMINISTRATIVE', 'SAFETY')),
  due_date          TIMESTAMPTZ,
  status            VARCHAR(20) NOT NULL DEFAULT 'OPEN'
                      CHECK (status IN ('OPEN', 'MET', 'NOT_MET', 'WAIVED')),
  resolved_by       BIGINT REFERENCES security.users(id),
  resolved_at       TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_by        BIGINT NOT NULL REFERENCES security.users(id),
  updated_at        TIMESTAMPTZ,
  updated_by        BIGINT REFERENCES security.users(id),
  deleted_at        TIMESTAMPTZ,
  deleted_by        BIGINT REFERENCES security.users(id)
);

-- ============================================================
-- 2. الفهارس (Indexes)
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_app_conditions_app_id
  ON committee.application_conditions(application_id)
  WHERE deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_app_conditions_status
  ON committee.application_conditions(status)
  WHERE deleted_at IS NULL;

-- ============================================================
-- 3. تفعيل RLS
-- ============================================================
ALTER TABLE committee.application_conditions ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- 4. سياسات RLS
--
-- ملاحظة عن PostgreSQL 18.3 على Windows:
--   قد لا تعمل سياسات FOR INSERT WITH CHECK بشكل صحيح على
--   Windows. إذا ثبت فشل هذه السياسة، سيتم إنشاء نسخة بديلة
--   باستخدام FOR ALL USING (true) WITH CHECK (...) كحل بديل.
-- ============================================================

-- 4a. SELECT: مالك الطلب + أعضاء اللجنة المختصة + المشرفون
DROP POLICY IF EXISTS app_conditions_select ON committee.application_conditions;
CREATE POLICY app_conditions_select ON committee.application_conditions
  FOR SELECT
  USING (
    -- مالك الطلب
    application_id IN (
      SELECT id FROM core.applications
      WHERE submitted_by = current_setting('app.user_id')::bigint
    )
    OR
    -- عضو في اللجنة المختصة بهذا الطلب (وليس أي لجنة)
    application_id IN (
      SELECT a.id FROM core.applications a
      WHERE a.target_committee_id IN (
        SELECT cm.committee_id FROM committee.committee_members cm
        WHERE cm.user_id = current_setting('app.user_id')::bigint
          AND cm.is_active = true
      )
    )
    OR
    -- المشرف العام / مشرف الأخلاقيات
    system.fn_is_admin(current_setting('app.user_id')::bigint)
  );

-- 4b. INSERT: أعضاء اللجنة المختصة + المشرفون
DROP POLICY IF EXISTS app_conditions_insert ON committee.application_conditions;
CREATE POLICY app_conditions_insert ON committee.application_conditions
  FOR INSERT
  WITH CHECK (
    system.fn_is_admin(current_setting('app.user_id')::bigint)
    OR EXISTS (
      SELECT 1 FROM core.applications a
      JOIN committee.committee_members cm ON cm.committee_id = a.target_committee_id
      WHERE a.id = application_id
        AND cm.user_id = current_setting('app.user_id')::bigint
        AND cm.is_active = true
    )
  );

-- 4c. UPDATE: نفس نطاق INSERT
DROP POLICY IF EXISTS app_conditions_update ON committee.application_conditions;
CREATE POLICY app_conditions_update ON committee.application_conditions
  FOR UPDATE
  USING (
    system.fn_is_admin(current_setting('app.user_id')::bigint)
    OR EXISTS (
      SELECT 1 FROM core.applications a
      JOIN committee.committee_members cm ON cm.committee_id = a.target_committee_id
      WHERE a.id = application_id
        AND cm.user_id = current_setting('app.user_id')::bigint
        AND cm.is_active = true
    )
  )
  WITH CHECK (
    system.fn_is_admin(current_setting('app.user_id')::bigint)
    OR EXISTS (
      SELECT 1 FROM core.applications a
      JOIN committee.committee_members cm ON cm.committee_id = a.target_committee_id
      WHERE a.id = application_id
        AND cm.user_id = current_setting('app.user_id')::bigint
        AND cm.is_active = true
    )
  );

-- 4d. DELETE: غير مسموح — الحذف المادي ممنوع، يُستخدم الحذف الناعم (soft delete) فقط
DROP POLICY IF EXISTS app_conditions_delete ON committee.application_conditions;
CREATE POLICY app_conditions_delete ON committee.application_conditions
  FOR DELETE
  USING (false);

-- ============================================================
-- 5. مشغّل التدقيق (Audit Trigger)
-- ============================================================
-- يتم إرفاق مشغل التدقيق تلقائياً لجميع الجداول عبر السكربت
-- 13-audit-triggers.sql (DO block يمسح جميع الجداول دون مشغل)،
-- ولكن نظراً لأن هذا الجدول جديد بعد تشغيل السكربت 13،
-- يجب إرفاق المشغل يدوياً هنا.
DROP TRIGGER IF EXISTS trigger_audit_application_conditions ON committee.application_conditions;
CREATE TRIGGER trigger_audit_application_conditions
  AFTER INSERT OR UPDATE OR DELETE ON committee.application_conditions
  FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();

-- ============================================================
-- 6. التوثيق (Comments)
-- ============================================================
COMMENT ON TABLE committee.application_conditions IS
  'شروط الموافقة المشروطة للطلبات — ترتبط بحالة AWAITING_CONDITIONS في سير العمل';

COMMENT ON COLUMN committee.application_conditions.severity IS
  'خطورة الشرط: MINOR (طفيف), MAJOR (رئيسي), CRITICAL (حاسم)';

COMMENT ON COLUMN committee.application_conditions.category IS
  'تصنيف الشرط: GENERAL (عام), SCIENTIFIC (علمي), ETHICAL (أخلاقي), ADMINISTRATIVE (إداري), SAFETY (سلامة)';

COMMENT ON COLUMN committee.application_conditions.status IS
  'حالة الشرط: OPEN (مفتوح), MET (مستوفى), NOT_MET (غير مستوفى), WAIVED (متنازل عنه)';

-- ============================================================
-- 7. إضافة نوع المستند EVIDENCE_DOC
-- ============================================================
INSERT INTO documents.document_types (type_code, type_name_ar, type_name_en, description, is_required)
SELECT 'EVIDENCE_DOC', 'مستند إثبات', 'Evidence Document', 'مستندات الأدلة المقدمة لاستيفاء الشروط', false
WHERE NOT EXISTS (
  SELECT 1 FROM documents.document_types WHERE type_code = 'EVIDENCE_DOC'
);

COMMIT;
