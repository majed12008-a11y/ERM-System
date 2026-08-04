-- 62-watermark-engine.sql
-- ============================================================
-- Watermark engine: extend watermark config to be fully
-- configuration-driven. Adds a type discriminator (custom
-- watermark types registered via the engine's type renderers)
-- and an optional JSONB condition for conditional rendering.
-- Idempotent.
-- ============================================================
BEGIN;

ALTER TABLE documents.document_watermark_config
  ADD COLUMN IF NOT EXISTS type VARCHAR(30) NOT NULL DEFAULT 'TEXT';

-- Conditional rendering spec: {"all":[{"field":"status","op":"eq","value":"REVOKED"}]}
ALTER TABLE documents.document_watermark_config
  ADD COLUMN IF NOT EXISTS condition JSONB;

-- Example: the REVOKED watermark is only drawn when the document
-- status is REVOKED (declarative, evaluated by the engine).
UPDATE documents.document_watermark_config
SET condition = '{"all":[{"field":"status","op":"eq","value":"REVOKED"}]}'::jsonb
WHERE code = 'REVOKED' AND condition IS NULL;

-- Ensure existing rows carry the default type.
UPDATE documents.document_watermark_config
SET type = 'TEXT'
WHERE type IS NULL OR type = '';

DO $$
DECLARE v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM documents.document_watermark_config WHERE is_active = TRUE;
    RAISE NOTICE 'Migration 62 complete (% active watermark configs)', v_count;
END $$;

COMMIT;
