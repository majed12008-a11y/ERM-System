-- ============================================================================
-- Migration 60 — Task 4: slot-based multi-signature support
-- ============================================================================
-- 1. document_signatures.signed_at was NOT NULL, which blocked the creation of
--    PENDING slots (a slot is assigned before it is signed). Allow NULL and
--    enforce the invariant: any row marked SIGNED must carry signed_at.
-- 2. Prevent duplicate PENDING slots for the same (document, signer).
-- 3. The legacy signDocumentSchema accepts ELECTRONIC | DIGITAL | WET; register
--    DIGITAL and WET as configurable signature types so the FK
--    (fk_doc_signatures_type) continues to accept them.
-- ============================================================================

ALTER TABLE documents.document_signatures
  ALTER COLUMN signed_at DROP NOT NULL;

ALTER TABLE documents.document_signatures
  DROP CONSTRAINT IF EXISTS chk_doc_signature_signed_at;
ALTER TABLE documents.document_signatures
  ADD CONSTRAINT chk_doc_signature_signed_at
  CHECK (signature_status <> 'SIGNED' OR signed_at IS NOT NULL);

ALTER TABLE documents.document_signatures
  DROP CONSTRAINT IF EXISTS uq_doc_signature_pending_slot;
CREATE UNIQUE INDEX IF NOT EXISTS uq_doc_signature_pending_slot
  ON documents.document_signatures (document_id, signer_id)
  WHERE signature_status = 'PENDING' AND deleted_at IS NULL;

INSERT INTO documents.document_signature_types (code, name_ar, name_en, sort_order) VALUES
  ('DIGITAL', 'توقيع رقمي', 'Digital', 80),
  ('WET',     'توقيع رطب',  'Wet Ink', 90)
ON CONFLICT (code) DO NOTHING;
