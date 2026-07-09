-- Active: 1780349863919@@127.0.0.1@5432
/*
 * 45-certificates.sql
 * ===================
 *
 * إنشاء نظام الشهادات الإلكترونية (Certificate Subsystem).
 *
 * يتضمن:
 *   1. نوع مستند APPROVAL_CERTIFICATE
 *   2. جدول approval_certificates مع قيود الحالة
 *   3. جدول approval_certificate_documents (ربط PDF)
 *   4. جدول certificate_verification_log (تحقق عام)
 *   5. مؤشر فريد جزئي لمنع التكرار
 *   6. سياسات RLS
 *   7. قالب الشهادة الافتراضي (Handlebars)
 *   8. دالة توليد الرقم التسلسلي
 *   9. إرفاق مشغل التدقيق
 */

-- ============================================================
-- 1. Document Type
-- ============================================================
INSERT INTO documents.document_types (type_code, type_name_ar, type_name_en)
VALUES ('APPROVAL_CERTIFICATE', 'شهادة اعتماد', 'Approval Certificate')
ON CONFLICT (type_code) DO NOTHING;

-- ============================================================
-- 2. Certificate Status Domain
-- ============================================================
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'certificate_status') THEN
    CREATE DOMAIN documents.certificate_status AS VARCHAR(20)
      CHECK (VALUE IN ('DRAFT', 'GENERATING', 'ISSUED', 'REVOKED', 'SUPERSEDED', 'FAILED'));
  END IF;
END;
$$;

-- ============================================================
-- 3. Core Certificates Table
-- ============================================================
DROP TABLE IF EXISTS documents.approval_certificates CASCADE;

CREATE TABLE documents.approval_certificates (
    id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    application_id      BIGINT NOT NULL REFERENCES core.applications(id),
    serial_number       VARCHAR(50) NOT NULL,
    version_no          INTEGER NOT NULL DEFAULT 1,
    status              documents.certificate_status NOT NULL DEFAULT 'DRAFT',
    issued_to_user_id   BIGINT NOT NULL REFERENCES security.users(id),
    issued_by_user_id   BIGINT NOT NULL REFERENCES security.users(id),
    issued_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
    revoked_at          TIMESTAMPTZ,
    revoked_by          BIGINT REFERENCES security.users(id),
    revocation_reason   TEXT,
    superseded_by       BIGINT REFERENCES documents.approval_certificates(id),
    generation_error    JSONB,
    metadata            JSONB,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by          BIGINT REFERENCES security.users(id),
    CONSTRAINT uq_cert_serial UNIQUE (serial_number),
    CONSTRAINT uq_app_version UNIQUE (application_id, version_no)
);

COMMENT ON TABLE documents.approval_certificates IS 'شهادات الاعتماد الصادرة للطلبات المعتمدة';
COMMENT ON COLUMN documents.approval_certificates.status IS 'حالة الشهادة: DRAFT, GENERATING, ISSUED, REVOKED, SUPERSEDED, FAILED';
COMMENT ON COLUMN documents.approval_certificates.serial_number IS 'الرقم التسلسلي للشهادة (مشتق من رقم الطلب)';
COMMENT ON COLUMN documents.approval_certificates.version_no IS 'رقم الإصدار (يزداد مع إعادة الإصدار)';
COMMENT ON COLUMN documents.approval_certificates.generation_error IS 'تفاصيل خطأ التوليد في حالة FAILED';

-- Partial unique index: at most one ISSUED/GENERATING/DRAFT cert per application
CREATE UNIQUE INDEX IF NOT EXISTS idx_cert_one_active
  ON documents.approval_certificates(application_id)
  WHERE status IN ('ISSUED', 'GENERATING', 'DRAFT');

CREATE INDEX IF NOT EXISTS idx_cert_app_id ON documents.approval_certificates(application_id);
CREATE INDEX IF NOT EXISTS idx_cert_serial ON documents.approval_certificates(serial_number);
CREATE INDEX IF NOT EXISTS idx_cert_status  ON documents.approval_certificates(status);

-- ============================================================
-- 4. Certificate Documents (PDF file links)
-- ============================================================
DROP TABLE IF EXISTS documents.approval_certificate_documents CASCADE;

CREATE TABLE documents.approval_certificate_documents (
    id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    certificate_id      BIGINT NOT NULL REFERENCES documents.approval_certificates(id) ON DELETE CASCADE,
    document_id         BIGINT NOT NULL REFERENCES documents.documents(id) ON DELETE CASCADE,
    is_original         BOOLEAN NOT NULL DEFAULT TRUE,
    generated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE documents.approval_certificate_documents IS 'ربط الشهادات بملفات PDF المخزنة';
COMMENT ON COLUMN documents.approval_certificate_documents.is_original IS 'true للإصدار الأصلي، false إذا أعيد توليد PDF';

-- ============================================================
-- 5. Certificate Verification Log (public, no FK)
-- ============================================================
DROP TABLE IF EXISTS documents.certificate_verification_log CASCADE;

CREATE TABLE documents.certificate_verification_log (
    id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    serial_number       VARCHAR(50) NOT NULL,
    verified_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    verified_by_ip      VARCHAR(50),
    result              VARCHAR(20) NOT NULL CHECK (result IN ('VALID', 'REVOKED', 'SUPERSEDED', 'NOT_FOUND', 'ERROR')),
    details             JSONB
);

CREATE INDEX IF NOT EXISTS idx_ver_log_serial ON documents.certificate_verification_log(serial_number);
CREATE INDEX IF NOT EXISTS idx_ver_log_date   ON documents.certificate_verification_log(verified_at);

COMMENT ON TABLE documents.certificate_verification_log IS 'سجل عمليات التحقق العامة من الشهادات';

-- ============================================================
-- 6. RLS
-- ============================================================
ALTER TABLE documents.approval_certificates ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS cert_select ON documents.approval_certificates;
CREATE POLICY cert_select ON documents.approval_certificates FOR SELECT
  USING (
    system.fn_is_admin(current_setting('app.user_id')::bigint)
    OR issued_to_user_id = current_setting('app.user_id')::bigint
  );

DROP POLICY IF EXISTS cert_insert ON documents.approval_certificates;
CREATE POLICY cert_insert ON documents.approval_certificates FOR INSERT
  WITH CHECK (
    system.fn_is_admin(current_setting('app.user_id')::bigint)
    AND issued_by_user_id = current_setting('app.user_id')::bigint
  );

DROP POLICY IF EXISTS cert_update ON documents.approval_certificates;
CREATE POLICY cert_update ON documents.approval_certificates FOR UPDATE
  USING (system.fn_is_admin(current_setting('app.user_id')::bigint))
  WITH CHECK (
    status IN ('REVOKED', 'SUPERSEDED', 'GENERATING')
    AND system.fn_is_admin(current_setting('app.user_id')::bigint)
  );

DROP POLICY IF EXISTS cert_delete ON documents.approval_certificates;
CREATE POLICY cert_delete ON documents.approval_certificates FOR DELETE
  USING (false);

ALTER TABLE documents.approval_certificate_documents ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS cert_doc_select ON documents.approval_certificate_documents;
CREATE POLICY cert_doc_select ON documents.approval_certificate_documents FOR SELECT
  USING (
    system.fn_is_admin(current_setting('app.user_id')::bigint)
    OR certificate_id IN (
      SELECT id FROM documents.approval_certificates
      WHERE issued_to_user_id = current_setting('app.user_id')::bigint
    )
  );

DROP POLICY IF EXISTS cert_doc_insert ON documents.approval_certificate_documents;
CREATE POLICY cert_doc_insert ON documents.approval_certificate_documents FOR INSERT
  WITH CHECK (system.fn_is_admin(current_setting('app.user_id')::bigint));

DROP POLICY IF EXISTS cert_doc_delete ON documents.approval_certificate_documents;
CREATE POLICY cert_doc_delete ON documents.approval_certificate_documents FOR DELETE
  USING (false);

ALTER TABLE documents.certificate_verification_log ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS ver_log_insert ON documents.certificate_verification_log;
CREATE POLICY ver_log_insert ON documents.certificate_verification_log FOR INSERT
  WITH CHECK (true);

DROP POLICY IF EXISTS ver_log_select ON documents.certificate_verification_log;
CREATE POLICY ver_log_select ON documents.certificate_verification_log FOR SELECT
  USING (true);

-- ============================================================
-- 7. Default Certificate Template
-- ============================================================
INSERT INTO documents.templates (template_code, template_name, template_type, template_content)
VALUES (
  'APPROVAL_CERTIFICATE_V1',
  'شهادة اعتماد أخلاقيات البحث',
  'CERTIFICATE',
  '<!DOCTYPE html>
<html dir="rtl" lang="ar">
<head>
<meta charset="utf-8">
<style>
  @font-face {
    font-family: ''Noto Sans Arabic'';
    src: url(''file:///app/fonts/NotoSansArabic-Regular.ttf'') format(''truetype'');
    font-weight: 400;
  }
  @font-face {
    font-family: ''Noto Sans Arabic'';
    src: url(''file:///app/fonts/NotoSansArabic-Bold.ttf'') format(''truetype'');
    font-weight: 700;
  }
  * { font-family: ''Noto Sans Arabic'', sans-serif; margin: 0; padding: 0; box-sizing: border-box; }
  body { direction: rtl; padding: 40px; color: #1a1a1a; }
  @page { size: A4; margin: 20mm; }

  .header { text-align: center; margin-bottom: 30px; border-bottom: 2px solid #1a5c2a; padding-bottom: 20px; }
  .header h1 { font-size: 22px; color: #1a5c2a; margin-bottom: 5px; }
  .header h2 { font-size: 16px; color: #555; font-weight: 400; }

  .serial { text-align: left; font-size: 11px; color: #888; margin-bottom: 20px; }
  .qr { text-align: left; margin-bottom: 20px; }
  .qr img { width: 100px; height: 100px; }

  .body-text { font-size: 14px; line-height: 2; margin-bottom: 30px; }
  .body-text .approval-statement { font-size: 16px; font-weight: 700; margin-bottom: 15px; }

  .info-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
  .info-table td { padding: 8px 12px; border: 1px solid #ddd; font-size: 13px; }
  .info-table td:first-child { font-weight: 700; background: #f5f5f5; width: 35%; }

  .conditions { margin-bottom: 30px; }
  .conditions h3 { font-size: 14px; color: #1a5c2a; margin-bottom: 10px; }
  .conditions ul { list-style: none; padding: 0; }
  .conditions li { font-size: 12px; padding: 4px 0; border-bottom: 1px solid #eee; }

  .footer { text-align: center; font-size: 11px; color: #888; border-top: 1px solid #ccc; padding-top: 15px; margin-top: 30px; }
</style>
</head>
<body>

<div class="serial">{{serialNumber}}</div>

<div class="header">
  <h1>{{committeeName}}</h1>
  <h2>{{committeeNameEn}}</h2>
  <h1 style="font-size:20px;margin-top:20px;">شهادة اعتماد</h1>
  <h2 style="font-size:16px;">Approval Certificate</h2>
</div>

<div class="qr">
  <img src="{{qrCodeDataUrl}}" alt="QR">
</div>

<div class="body-text">
  <div class="approval-statement">{{approvalStatement}}</div>
  <p>يشهد الفريق المختص بأن البحث المقدم من {{researcherName}} بعنوان "{{projectTitle}}" قد استوفي المتطلبات الأخلاقية اللازمة لإجراء البحث على البشر.</p>
</div>

<table class="info-table">
  <tr><td>رقم الطلب</td><td>{{applicationNumber}}</td></tr>
  <tr><td>اسم الباحث</td><td>{{researcherName}}</td></tr>
  <tr><td>عنوان البحث</td><td>{{projectTitle}}</td></tr>
  <tr><td>الجهة</td><td>{{institutionName}}</td></tr>
  <tr><td>تاريخ الإصدار</td><td>{{issueDate}}</td></tr>
  {{#if expiryDate}}
  <tr><td>تاريخ الانتهاء</td><td>{{expiryDate}}</td></tr>
  {{/if}}
  <tr><td>رقم الشهادة</td><td>{{serialNumber}}</td></tr>
</table>

{{#if conditions.length}}
<div class="conditions">
  <h3>الاشتراطات / Conditions</h3>
  <ul>
    {{#each conditions}}
    <li>{{text}}</li>
    {{/each}}
  </ul>
</div>
{{/if}}

<div class="footer">
  <p>{{issuingAuthority}} | {{serialNumber}}</p>
  <p>للتحقق: https://ethics.erc.gov.sa/verify?serial={{serialNumber}}</p>
</div>

</body>
</html>'
)
ON CONFLICT (template_code, version_no) DO NOTHING;

-- ============================================================
-- 8. Audit Trigger Attachment
-- ============================================================
DO $$
DECLARE
  v_tables TEXT[] := ARRAY['approval_certificates', 'approval_certificate_documents', 'certificate_verification_log'];
  v_tbl TEXT;
BEGIN
  FOREACH v_tbl IN ARRAY v_tables
  LOOP
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.triggers
      WHERE event_object_schema = 'documents'
        AND event_object_table = v_tbl
        AND trigger_name = 'trg_audit_' || v_tbl
    ) THEN
      EXECUTE format(
        'CREATE TRIGGER trg_audit_%I
         AFTER INSERT OR UPDATE OR DELETE ON documents.%I
         FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit()',
        v_tbl, v_tbl
      );
    END IF;
  END LOOP;
END;
$$;
