-- ============================================================
-- 57-document-infrastructure.sql
-- ============================================================
-- بنية السجل القانوني الدائم للمستندات المولّدة:
--   1. أعمدة إضافية على documents.documents (uuid رقم الوثيقة،
--      الحالة، الثبات، بيانات القالب، النسخ، السحب/الإبطال).
--   2. توسعة documents.document_versions (uuid، القالب، السلسلة).
--   3. سجل تحقق عام documents.document_verification_log.
--   4. مشغل ثبات: منع تعديل/حذف الوثائق غير القابلة للتعديل.
--   5. دالة تحقق SECURITY DEFINER documents.fn_verify_generated_document.
--   6. RLS دفاعي على جداول السجل التابعة (إضافة/قراءة فقط).
-- Idempotent — يمكن إعادة تطبيقه بأمان.
-- ============================================================

BEGIN;

-- ============================================================
-- 1. documents.documents — أعمدة السجل القانوني
-- ============================================================
ALTER TABLE documents.documents
  ADD COLUMN IF NOT EXISTS document_uuid UUID NOT NULL DEFAULT gen_random_uuid(),
  ADD COLUMN IF NOT EXISTS document_number VARCHAR(100),
  ADD COLUMN IF NOT EXISTS status VARCHAR(20) NOT NULL DEFAULT 'OFFICIAL',
  ADD COLUMN IF NOT EXISTS is_immutable BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS current_version_no INTEGER NOT NULL DEFAULT 1,
  ADD COLUMN IF NOT EXISTS template_code VARCHAR(100),
  ADD COLUMN IF NOT EXISTS template_version INTEGER,
  ADD COLUMN IF NOT EXISTS language VARCHAR(5) NOT NULL DEFAULT 'ar',
  ADD COLUMN IF NOT EXISTS supersedes_version_no INTEGER,
  ADD COLUMN IF NOT EXISTS superseded_by_document_id BIGINT REFERENCES documents.documents(id),
  ADD COLUMN IF NOT EXISTS revoked_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS revoked_by BIGINT REFERENCES security.users(id),
  ADD COLUMN IF NOT EXISTS revocation_reason TEXT;

ALTER TABLE documents.documents
  DROP CONSTRAINT IF EXISTS chk_documents_status;
ALTER TABLE documents.documents
  ADD CONSTRAINT chk_documents_status CHECK (
    status IN ('OFFICIAL', 'REVOKED', 'VOID', 'SUPERSEDED')
  );

-- رقم الوثيقة فريد غير قابل للتكرار (public reference)
CREATE UNIQUE INDEX IF NOT EXISTS uq_documents_number
  ON documents.documents (document_number)
  WHERE document_number IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_documents_uuid
  ON documents.documents (document_uuid);

COMMENT ON COLUMN documents.documents.document_uuid IS 'معرّف عام للتحقق (يظهر في QR)';
COMMENT ON COLUMN documents.documents.document_number IS 'رقم الوثيقة الرسمي (PREFIX-YYYY-NNNN)';
COMMENT ON COLUMN documents.documents.status IS 'حالة السجل: OFFICIAL, REVOKED, VOID, SUPERSEDED';
COMMENT ON COLUMN documents.documents.is_immutable IS 'الوثائق المولّدة غير قابلة للتعديل/الحذف';
COMMENT ON COLUMN documents.documents.current_version_no IS 'رقم الإصدار الحالي من هذه الوثيقة';

-- ============================================================
-- 2. documents.document_versions — سلسلة النسخ
-- ============================================================
ALTER TABLE documents.document_versions
  ADD COLUMN IF NOT EXISTS document_uuid UUID,
  ADD COLUMN IF NOT EXISTS template_code VARCHAR(100),
  ADD COLUMN IF NOT EXISTS template_version INTEGER,
  ADD COLUMN IF NOT EXISTS language VARCHAR(5),
  ADD COLUMN IF NOT EXISTS supersedes_version_id BIGINT REFERENCES documents.document_versions(id);

COMMENT ON COLUMN documents.document_versions.document_uuid IS 'uuid الوثيقة في هذه النسخة';
COMMENT ON COLUMN documents.document_versions.supersedes_version_id IS 'النسخة السابقة التي تحل محلها هذه النسخة';

-- ============================================================
-- 3. سجل التحقق العام (بدون FK — نقطة عامة بلا جلسة)
-- ============================================================
CREATE TABLE IF NOT EXISTS documents.document_verification_log (
    id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reference     VARCHAR(100) NOT NULL,
    verified_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    verified_by_ip VARCHAR(50),
    result        VARCHAR(20) NOT NULL
      CHECK (result IN ('VALID', 'REVOKED', 'VOID', 'SUPERSEDED', 'NOT_FOUND', 'ERROR')),
    details       JSONB
);

CREATE INDEX IF NOT EXISTS idx_doc_ver_log_reference ON documents.document_verification_log(reference);
CREATE INDEX IF NOT EXISTS idx_doc_ver_log_date ON documents.document_verification_log(verified_at);

-- ============================================================
-- 4. مشغل الثبات — منع تعديل/حذف السجل القانوني
-- ============================================================
CREATE OR REPLACE FUNCTION documents.fn_guard_document_immutable() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    IF OLD.is_immutable THEN
      RAISE EXCEPTION 'Document % is an immutable legal record and cannot be deleted', OLD.document_number;
    END IF;
    RETURN OLD;
  END IF;

  IF TG_OP = 'UPDATE' THEN
    IF OLD.is_immutable AND (
        NEW.checksum_sha256 IS DISTINCT FROM OLD.checksum_sha256
        OR NEW.storage_path IS DISTINCT FROM OLD.storage_path
        OR NEW.file_name IS DISTINCT FROM OLD.file_name
        OR NEW.document_number IS DISTINCT FROM OLD.document_number
        OR NEW.document_uuid IS DISTINCT FROM OLD.document_uuid
        OR NEW.is_immutable = FALSE
    ) THEN
      RAISE EXCEPTION 'Document % is immutable: content and identity cannot be altered', OLD.document_number;
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_documents_immutable ON documents.documents;
CREATE TRIGGER trg_documents_immutable
  BEFORE UPDATE OR DELETE ON documents.documents
  FOR EACH ROW EXECUTE FUNCTION documents.fn_guard_document_immutable();

-- ============================================================
-- 5. دالة التحقق العامة (SECURITY DEFINER — تتجاوز RLS)
-- ============================================================
CREATE OR REPLACE FUNCTION documents.fn_verify_generated_document(
    p_reference VARCHAR
)
RETURNS TABLE(
    document_number VARCHAR,
    document_uuid TEXT,
    status VARCHAR,
    document_title VARCHAR,
    document_type VARCHAR,
    language VARCHAR,
    version_no INTEGER,
    checksum_sha256 VARCHAR,
    issued_at TIMESTAMPTZ,
    issued_by_name VARCHAR,
    template_code VARCHAR,
    template_version INTEGER,
    superseded_by_number VARCHAR,
    revoked_at TIMESTAMPTZ,
    revocation_reason TEXT,
    entity_type VARCHAR,
    entity_id BIGINT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT
        d.document_number::VARCHAR,
        d.document_uuid::TEXT,
        d.status::VARCHAR,
        d.document_title::VARCHAR,
        dt.type_name_ar::VARCHAR AS document_type,
        d.language::VARCHAR,
        d.current_version_no::INTEGER AS version_no,
        d.checksum_sha256::VARCHAR,
        d.created_at AS issued_at,
        u.username::VARCHAR AS issued_by_name,
        d.template_code::VARCHAR,
        d.template_version::INTEGER,
        sd.document_number::VARCHAR AS superseded_by_number,
        d.revoked_at,
        d.revocation_reason,
        d.entity_type::VARCHAR,
        d.entity_id::BIGINT
    FROM documents.documents d
    LEFT JOIN documents.document_types dt ON dt.id = d.document_type_id
    LEFT JOIN security.users u ON u.id = d.uploaded_by
    LEFT JOIN documents.documents sd ON sd.id = d.superseded_by_document_id
    WHERE d.document_number = p_reference
       OR d.document_uuid::text = p_reference
    LIMIT 1;
$$;

COMMENT ON FUNCTION documents.fn_verify_generated_document(VARCHAR) IS
  'Returns public verification data for a generated document. SECURITY DEFINER to bypass RLS (public endpoint has no session user).';

-- ============================================================
-- 6. RLS دفاعي على جداول السجل التابعة
--    الجداول أضيفت/تُقرأ فقط بعد التحقق من الوثيقة الأب
--    (التي تملك RLS). SELECT/INSERT فقط → سجل مخصص للإلحاق.
-- ============================================================
ALTER TABLE documents.document_versions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS dv_select ON documents.document_versions;
CREATE POLICY dv_select ON documents.document_versions FOR SELECT USING (true);
DROP POLICY IF EXISTS dv_insert ON documents.document_versions;
CREATE POLICY dv_insert ON documents.document_versions FOR INSERT WITH CHECK (true);

ALTER TABLE documents.document_audit ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS da_select ON documents.document_audit;
CREATE POLICY da_select ON documents.document_audit FOR SELECT USING (true);
DROP POLICY IF EXISTS da_insert ON documents.document_audit;
CREATE POLICY da_insert ON documents.document_audit FOR INSERT WITH CHECK (true);

ALTER TABLE documents.document_signatures ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS ds_select ON documents.document_signatures;
CREATE POLICY ds_select ON documents.document_signatures FOR SELECT USING (true);
DROP POLICY IF EXISTS ds_insert ON documents.document_signatures;
CREATE POLICY ds_insert ON documents.document_signatures FOR INSERT WITH CHECK (true);

ALTER TABLE documents.generated_documents ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS gd_select ON documents.generated_documents;
CREATE POLICY gd_select ON documents.generated_documents FOR SELECT USING (true);
DROP POLICY IF EXISTS gd_insert ON documents.generated_documents;
CREATE POLICY gd_insert ON documents.generated_documents FOR INSERT WITH CHECK (true);

-- ============================================================
-- Verify
-- ============================================================
DO $$
DECLARE
    v_immutable INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_immutable
    FROM pg_trigger WHERE tgname = 'trg_documents_immutable';
    RAISE NOTICE 'Migration 57-document-infrastructure complete (immutable trigger: %)', v_immutable;
END $$;

COMMIT;
