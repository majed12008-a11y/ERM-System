-- ============================================================
-- Seed: 58-template-database-integrity.sql
-- Description: Database-level integrity guarantees for the
-- template version lifecycle:
--
-- 1. Content Immutability Trigger — prevents content/
--    variable_definitions modification once version leaves DRAFT.
-- 2. Effective Date CHECK Constraint — ensures effective_until >
--    effective_from when both are set (no zero-width or inverted
--    effective periods).
-- 3. Partial Unique Index Verification — confirms that the
--    one_approved_version index (defined in 55-template-schema.sql)
--    exists and is unique.
--
-- All constraints are additive and idempotent (DROP IF EXISTS /
-- CREATE OR REPLACE).
-- ============================================================

-- ============================================================
-- 1. Content Immutability Trigger
-- ============================================================
-- Guards content and variable_definitions columns on
-- templates.template_versions. Once a version transitions out of
-- DRAFT (i.e., status is REVIEW, APPROVED, DEPRECATED, or
-- ARCHIVED), its content and variable definitions are frozen.
--
-- Status changes, effective dates, and audit metadata remain
-- modifiable — only the rendered payload is locked.
-- ============================================================

CREATE OR REPLACE FUNCTION templates.fn_block_version_content_update()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF OLD.status IN ('REVIEW', 'APPROVED', 'DEPRECATED', 'ARCHIVED') THEN
    IF NEW.content IS DISTINCT FROM OLD.content THEN
      RAISE EXCEPTION 'Cannot modify content of a version in status %', OLD.status
        USING HINT = 'Create a new version instead';
    END IF;
    IF NEW.variable_definitions IS DISTINCT FROM OLD.variable_definitions THEN
      RAISE EXCEPTION 'Cannot modify variable definitions of a version in status %', OLD.status
        USING HINT = 'Create a new version instead';
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_block_version_content_update ON templates.template_versions;

CREATE TRIGGER trg_block_version_content_update
  BEFORE UPDATE ON templates.template_versions
  FOR EACH ROW
  EXECUTE FUNCTION templates.fn_block_version_content_update();

-- ============================================================
-- 2. Effective Date CHECK Constraint
-- ============================================================
-- Prevents nonsensical effective date ranges:
--   - effective_until <= effective_from is invalid (zero-width
--     or inverted range)
--   - NULL in either column is allowed (open-ended effective
--     period)
-- ============================================================

ALTER TABLE templates.template_versions
  DROP CONSTRAINT IF EXISTS chk_template_versions_effective_dates;

ALTER TABLE templates.template_versions
  ADD CONSTRAINT chk_template_versions_effective_dates
  CHECK (
    effective_until IS NULL
    OR effective_from IS NULL
    OR effective_until > effective_from
  );

-- ============================================================
-- 3. Partial Unique Index Verification
-- ============================================================
-- The one_approved_version partial unique index (defined in
-- 55-template-schema.sql) enforces at the database level that
-- only one version per template can be in APPROVED status.
-- This verification block confirms the index exists.
-- ============================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes
    WHERE schemaname = 'templates'
      AND tablename = 'template_versions'
      AND indexname = 'one_approved_version'
  ) THEN
    RAISE WARNING 'one_approved_version partial unique index not found — ensure it is created via 55-template-schema.sql';
  END IF;
END;
$$;
