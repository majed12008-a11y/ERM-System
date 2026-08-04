-- 58-gate0-document-lifecycle.sql
-- ============================================================
-- Gate 0: configurable lifecycle, multi-signature, watermark,
-- metadata, and checksum infrastructure. Idempotent.
-- ============================================================
BEGIN;

-- ── 1. Lifecycle states ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS documents.document_lifecycle_states (
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code        VARCHAR(50) NOT NULL UNIQUE,
    name_ar     VARCHAR(200) NOT NULL,
    name_en     VARCHAR(200),
    is_terminal BOOLEAN NOT NULL DEFAULT FALSE,
    is_active   BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order  INTEGER NOT NULL DEFAULT 0,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ
);

INSERT INTO documents.document_lifecycle_states (code, name_ar, name_en, is_terminal, sort_order) VALUES
  ('DRAFT',             'مسودة',              'Draft',             FALSE, 10),
  ('UNDER_REVIEW',      'قيد المراجعة',        'Under Review',      FALSE, 20),
  ('PENDING_SIGNATURE', 'بانتظار التوقيع',     'Pending Signature', FALSE, 30),
  ('APPROVED',          'معتمدة',             'Approved',          FALSE, 40),
  ('ISSUED',            'صادرة',              'Issued',            FALSE, 50),
  ('SUPERSEDED',        'مستبدلة',            'Superseded',        TRUE,  60),
  ('REVOKED',           'ملغاة',              'Revoked',           TRUE,  70),
  ('VOID',              'باطلة',              'Void',              TRUE,  80),
  ('EXPIRED',           'منتهية الصلاحية',    'Expired',           TRUE,  90),
  ('ARCHIVED',          'مؤرشفة',             'Archived',          TRUE,  100)
ON CONFLICT (code) DO NOTHING;

-- ── 2. Transitions (configurable; edit here, no code change) ──
CREATE TABLE IF NOT EXISTS documents.document_lifecycle_transitions (
    id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    from_state_id       BIGINT NOT NULL REFERENCES documents.document_lifecycle_states(id),
    to_state_id         BIGINT NOT NULL REFERENCES documents.document_lifecycle_states(id),
    action_code         VARCHAR(50) NOT NULL,
    name_ar             VARCHAR(200) NOT NULL,
    name_en             VARCHAR(200),
    requires_signatures BOOLEAN NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (from_state_id, to_state_id, action_code)
);

INSERT INTO documents.document_lifecycle_transitions
  (from_state_id, to_state_id, action_code, name_ar, name_en, requires_signatures)
SELECT f.id, t.id, tr.action_code, tr.name_ar, tr.name_en, tr.requires_signatures
FROM (VALUES
  ('DRAFT',             'UNDER_REVIEW',      'START_REVIEW',        'بدء المراجعة',     'Start Review',        FALSE),
  ('UNDER_REVIEW',      'PENDING_SIGNATURE', 'REQUEST_SIGNATURES',  'طلب التوقيعات',     'Request Signatures',  FALSE),
  ('PENDING_SIGNATURE', 'APPROVED',          'APPROVE',             'اعتماد',            'Approve',             TRUE),
  ('PENDING_SIGNATURE', 'ISSUED',            'ISSUE',               'إصدار',              'Issue',               FALSE),
  ('PENDING_SIGNATURE', 'DRAFT',             'RETURN_FOR_REVISION', 'إعادة للمراجعة',    'Return for Revision', FALSE),
  ('APPROVED',          'ISSUED',            'ISSUE',               'إصدار',              'Issue',               FALSE),
  ('APPROVED',          'VOID',              'VOID',                'إبطال',              'Void',                FALSE),
  ('APPROVED',          'REVOKED',           'REVOKE',              'سحب',                'Revoke',              FALSE),
  ('ISSUED',            'SUPERSEDED',        'SUPERSEDE',           'استبدال',            'Supersede',           FALSE),
  ('ISSUED',            'REVOKED',           'REVOKE',              'سحب',                'Revoke',              FALSE),
  ('ISSUED',            'VOID',              'VOID',                'إبطال',              'Void',                FALSE),
  ('ISSUED',            'EXPIRED',           'EXPIRE',              'انتهاء الصلاحية',   'Expire',              FALSE),
  ('ISSUED',            'ARCHIVED',          'ARCHIVE',             'أرشفة',              'Archive',             FALSE),
  ('EXPIRED',           'ARCHIVED',          'ARCHIVE',             'أرشفة',              'Archive',             FALSE)
) AS tr(from_code, to_code, action_code, name_ar, name_en, requires_signatures)
JOIN documents.document_lifecycle_states f ON f.code = tr.from_code
JOIN documents.document_lifecycle_states t ON t.code = tr.to_code
ON CONFLICT (from_state_id, to_state_id, action_code) DO NOTHING;

-- ── 3. Transition function (single mutation path) ────────────
CREATE OR REPLACE FUNCTION documents.fn_document_transition(
    p_document_id BIGINT,
    p_action_code VARCHAR(50),
    p_actor_id    BIGINT,
    p_reason      TEXT DEFAULT NULL,
    p_details     JSONB DEFAULT NULL
)
RETURNS TABLE(ok BOOLEAN, message TEXT, new_status VARCHAR, document_number VARCHAR)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = documents, security, public
AS $$
DECLARE
    v_doc               documents.documents%ROWTYPE;
    v_from              documents.document_lifecycle_states%ROWTYPE;
    v_transition        documents.document_lifecycle_transitions%ROWTYPE;
    v_to_state          documents.document_lifecycle_states%ROWTYPE;
    v_missing_required  INTEGER;
BEGIN
    SELECT * INTO v_doc FROM documents.documents WHERE id = p_document_id;
    IF v_doc.id IS NULL THEN
        RETURN QUERY SELECT FALSE, 'Document not found', NULL::VARCHAR, NULL::VARCHAR;
        RETURN;
    END IF;

    IF NOT (system.fn_is_admin(p_actor_id) OR v_doc.uploaded_by = p_actor_id) THEN
        RETURN QUERY SELECT FALSE, 'Not authorized to transition this document', NULL::VARCHAR, v_doc.document_number;
        RETURN;
    END IF;

    SELECT * INTO v_from FROM documents.document_lifecycle_states WHERE id = v_doc.lifecycle_state_id;
    IF v_from.id IS NULL THEN
        RETURN QUERY SELECT FALSE, 'Document has no lifecycle state', NULL::VARCHAR, v_doc.document_number;
        RETURN;
    END IF;

    SELECT * INTO v_transition
    FROM documents.document_lifecycle_transitions tr
    WHERE tr.from_state_id = v_from.id
      AND tr.action_code = p_action_code
      AND tr.is_active = TRUE
    LIMIT 1;

    IF v_transition.id IS NULL THEN
        RETURN QUERY SELECT FALSE,
          format('Action %s is not allowed from state %s', p_action_code, v_from.code),
          NULL::VARCHAR, v_doc.document_number;
        RETURN;
    END IF;

    IF v_transition.requires_signatures THEN
        SELECT COUNT(*) INTO v_missing_required
        FROM documents.document_signatures ds
        WHERE ds.document_id = p_document_id
          AND ds.is_required = TRUE
          AND ds.signature_status <> 'SIGNED';
        IF v_missing_required > 0 THEN
            RETURN QUERY SELECT FALSE,
              format('%s required signature(s) missing', v_missing_required),
              NULL::VARCHAR, v_doc.document_number;
            RETURN;
        END IF;
    END IF;

    SELECT * INTO v_to_state FROM documents.document_lifecycle_states WHERE id = v_transition.to_state_id;

    UPDATE documents.documents
       SET status = v_to_state.code,
           lifecycle_state_id = v_to_state.id,
           revoked_at = CASE WHEN v_to_state.code IN ('REVOKED','VOID') THEN now() ELSE revoked_at END,
           revoked_by = CASE WHEN v_to_state.code IN ('REVOKED','VOID') THEN p_actor_id ELSE revoked_by END,
           revocation_reason = CASE WHEN v_to_state.code IN ('REVOKED','VOID') THEN COALESCE(p_reason, revocation_reason) ELSE revocation_reason END
     WHERE id = p_document_id;

    INSERT INTO documents.document_audit (document_id, action_type, action_by, details)
    VALUES (p_document_id, p_action_code, p_actor_id,
            jsonb_build_object('from_state', v_from.code, 'to_state', v_to_state.code,
                               'reason', p_reason, 'details', p_details));

    IF p_action_code = 'APPROVE' THEN
        INSERT INTO documents.document_approvals
            (document_id, approver_id, approval_status, approval_comments, approved_at, created_by, created_at)
        VALUES (p_document_id, p_actor_id, 'APPROVED', p_reason, now(), p_actor_id, now());
    END IF;

    RETURN QUERY SELECT TRUE, 'Transition applied', v_to_state.code, v_doc.document_number;
END;
$$;

-- ── 4. Signature types (configurable) ─────────────────────────
CREATE TABLE IF NOT EXISTS documents.document_signature_types (
    code       VARCHAR(50) PRIMARY KEY,
    name_ar    VARCHAR(200) NOT NULL,
    name_en    VARCHAR(200) NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active  BOOLEAN NOT NULL DEFAULT TRUE
);

INSERT INTO documents.document_signature_types (code, name_ar, name_en, sort_order) VALUES
  ('SECRETARY', 'أمين اللجنة', 'Committee Secretary', 10),
  ('REVIEWER', 'المراجع', 'Reviewer', 20),
  ('CHAIR', 'رئيس اللجنة', 'Committee Chair', 30),
  ('INSTITUTIONAL_REPRESENTATIVE', 'ممثل المؤسسة', 'Institutional Representative', 40),
  ('APPLICANT', 'مقدم الطلب', 'Applicant', 50),
  ('APPROVER', 'المعتمد', 'Approver', 60),
  ('ELECTRONIC', 'توقيع إلكتروني', 'Electronic', 70)
ON CONFLICT (code) DO NOTHING;

ALTER TABLE documents.document_signatures
  ADD COLUMN IF NOT EXISTS signature_order INTEGER NOT NULL DEFAULT 1,
  ADD COLUMN IF NOT EXISTS signature_status VARCHAR(20) NOT NULL DEFAULT 'SIGNED',
  ADD COLUMN IF NOT EXISTS signer_title VARCHAR(500),
  ADD COLUMN IF NOT EXISTS is_required BOOLEAN NOT NULL DEFAULT TRUE,
  ADD COLUMN IF NOT EXISTS certificate_metadata JSONB,
  ADD COLUMN IF NOT EXISTS verification_metadata JSONB;

ALTER TABLE documents.document_signatures
  DROP CONSTRAINT IF EXISTS chk_doc_signature_status;
ALTER TABLE documents.document_signatures
  ADD CONSTRAINT chk_doc_signature_status CHECK (signature_status IN ('PENDING','SIGNED','REJECTED','REVOKED'));

ALTER TABLE documents.document_signatures
  DROP CONSTRAINT IF EXISTS fk_doc_signatures_type;
ALTER TABLE documents.document_signatures
  ADD CONSTRAINT fk_doc_signatures_type FOREIGN KEY (signature_type)
  REFERENCES documents.document_signature_types(code);

-- ── 5. Watermark config (configurable, no hardcoding) ─────────
CREATE TABLE IF NOT EXISTS documents.document_watermark_config (
    id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code         VARCHAR(50) NOT NULL UNIQUE,
    text_ar      VARCHAR(200) NOT NULL,
    text_en      VARCHAR(200) NOT NULL,
    font_family  VARCHAR(100) NOT NULL DEFAULT 'Tahoma',
    font_size_pt NUMERIC(4,1) NOT NULL DEFAULT 60,
    color        VARCHAR(20) NOT NULL DEFAULT '#B71C1C',
    opacity      NUMERIC(3,2) NOT NULL DEFAULT 0.12,
    rotation_deg NUMERIC(5,2) NOT NULL DEFAULT -30,
    position     VARCHAR(20) NOT NULL DEFAULT 'CENTER',
    is_active    BOOLEAN NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at   TIMESTAMPTZ
);

INSERT INTO documents.document_watermark_config (code, text_ar, text_en, font_size_pt, color, opacity, rotation_deg, position) VALUES
  ('DRAFT',      'مسودة',            'DRAFT',      60, '#0b3d2e', 0.10, -30, 'CENTER'),
  ('COPY',       'نسخة',             'COPY',       60, '#0b3d2e', 0.10, -30, 'CENTER'),
  ('VOID',       'باطلة',            'VOID',       60, '#B71C1C', 0.14, -30, 'CENTER'),
  ('SUPERSEDED', 'مستبدلة',          'SUPERSEDED', 55, '#B71C1C', 0.14, -30, 'CENTER'),
  ('REVOKED',    'ملغاة',            'REVOKED',    60, '#B71C1C', 0.16, -30, 'CENTER'),
  ('EXPIRED',    'منتهية الصلاحية',  'EXPIRED',    55, '#B71C1C', 0.14, -30, 'CENTER'),
  ('CUSTOM',     'مخصص',             'CUSTOM',     60, '#555555', 0.10, -30, 'CENTER')
ON CONFLICT (code) DO NOTHING;

-- ── 6. documents.documents — metadata columns ─────────────────
ALTER TABLE documents.documents
  ADD COLUMN IF NOT EXISTS lifecycle_state_id BIGINT REFERENCES documents.document_lifecycle_states(id),
  ADD COLUMN IF NOT EXISTS classification_id BIGINT REFERENCES documents.document_classifications(id),
  ADD COLUMN IF NOT EXISTS confidentiality_level VARCHAR(20) NOT NULL DEFAULT 'INTERNAL',
  ADD COLUMN IF NOT EXISTS retention_rule_id BIGINT REFERENCES documents.document_retention_rules(id),
  ADD COLUMN IF NOT EXISTS expires_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS tags TEXT[] NOT NULL DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS metadata JSONB NOT NULL DEFAULT '{}';

ALTER TABLE documents.documents
  DROP CONSTRAINT IF EXISTS chk_documents_confidentiality;
ALTER TABLE documents.documents
  ADD CONSTRAINT chk_documents_confidentiality
  CHECK (confidentiality_level IN ('PUBLIC','INTERNAL','CONFIDENTIAL','RESTRICTED'));

-- Default for legacy inserts (e.g. seed 54-yemen-documents.sql) that omit
-- lifecycle_state_id. Required so that re-applying the seed suite after the
-- column already exists as NOT NULL does not fail on re-runs; the backfill
-- UPDATEs below then normalize real values from the status column.
DO $$
DECLARE v_issue_state_id BIGINT;
BEGIN
    SELECT id INTO v_issue_state_id FROM documents.document_lifecycle_states WHERE code = 'ISSUED';
    IF v_issue_state_id IS NOT NULL THEN
        EXECUTE format('ALTER TABLE documents.documents ALTER COLUMN lifecycle_state_id SET DEFAULT %s', v_issue_state_id);
    END IF;
END $$;

-- ── 7. status column: free-form state code (engine-driven) ────
ALTER TABLE documents.documents DROP CONSTRAINT IF EXISTS chk_documents_status;
ALTER TABLE documents.documents ALTER COLUMN status TYPE VARCHAR(50);
ALTER TABLE documents.documents ALTER COLUMN status SET DEFAULT 'ISSUED';

UPDATE documents.documents d SET status = 'ISSUED', lifecycle_state_id = s.id
FROM documents.document_lifecycle_states s
WHERE s.code = 'ISSUED' AND d.status IN ('OFFICIAL','ISSUED');

UPDATE documents.documents d SET lifecycle_state_id = s.id
FROM documents.document_lifecycle_states s
WHERE d.lifecycle_state_id IS NULL AND s.code = d.status;

ALTER TABLE documents.documents
  ALTER COLUMN lifecycle_state_id SET NOT NULL;

-- ── 8. checksum width + verification log result codes ─────────
ALTER TABLE documents.documents ALTER COLUMN checksum_sha256 TYPE VARCHAR(128);

ALTER TABLE documents.document_verification_log
  DROP CONSTRAINT IF EXISTS document_verification_log_result_check;
ALTER TABLE documents.document_verification_log
  ADD CONSTRAINT document_verification_log_result_check
  CHECK (result IN ('VALID','INVALID','MODIFIED','UNKNOWN','REVOKED','VOID','SUPERSEDED','EXPIRED','NOT_FOUND','ERROR'));

-- ── Verify ────────────────────────────────────────────────────
DO $$
DECLARE v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM documents.document_lifecycle_states WHERE is_active = TRUE;
    RAISE NOTICE 'Migration 58 complete (% active lifecycle states)', v_count;
END $$;

COMMIT;
