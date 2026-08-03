-- 59-gate0-document-rls.sql
-- ============================================================
-- Gate 0 RLS hardening: every documents table is RLS-protected.
-- "RLS is the sole access control mechanism" (AGENTS.md).
-- Idempotent.
-- ============================================================
BEGIN;

-- Helper: can the session user view a document?
CREATE OR REPLACE FUNCTION documents.fn_can_view_document(p_document_id BIGINT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = documents, security, public
AS $$
    SELECT EXISTS (
        SELECT 1 FROM documents.documents d
        WHERE d.id = p_document_id
          AND ( system.fn_is_admin((current_setting('app.user_id', true))::bigint)
                OR (current_setting('app.user_id', true))::bigint = d.uploaded_by
                OR EXISTS (SELECT 1 FROM documents.document_access a
                           WHERE a.document_id = d.id
                             AND a.deleted_at IS NULL
                             AND (a.user_id = (current_setting('app.user_id', true))::bigint
                                  OR a.role_id IN (SELECT ur.role_id FROM security.user_roles ur
                                                   WHERE ur.user_id = (current_setting('app.user_id', true))::bigint))
                             AND (a.expires_at IS NULL OR a.expires_at > now()))
          )
    );
$$;

-- Helper: does the session user hold a signature slot on the document?
-- (multi-signature workflow: an assigned signer may view the document
--  and sign their own PENDING slot — nothing more)
CREATE OR REPLACE FUNCTION documents.fn_is_document_signer(p_document_id BIGINT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = documents, security, public
AS $$
    SELECT EXISTS (
        SELECT 1 FROM documents.document_signatures s
        WHERE s.document_id = p_document_id
          AND s.signer_id = (current_setting('app.user_id', true))::bigint
    );
$$;

-- Legacy status column policy: `documents.documents.status` is a DENORMALIZED
-- COMPATIBILITY MIRROR of lifecycle_state_id. Source of truth going forward is
-- lifecycle_state_id (via document_lifecycle_states). status is kept in sync only
-- by fn_document_transition so legacy queries keep working during migration.
-- No new RLS policy, service, or route may depend on it.
COMMENT ON COLUMN documents.documents.status IS
  'LEGACY COMPATIBILITY MIRROR of lifecycle_state_id (denormalized state code). '
  'Do NOT use in business logic. Source of truth: lifecycle_state_id -> document_lifecycle_states.code.';

-- Extend documents.documents SELECT policy to include assigned signers
-- (replaces the 12/15-soft-delete definition; preserves admin/owner/access semantics)
DROP POLICY IF EXISTS documents_select_policy ON documents.documents;
CREATE POLICY documents_select_policy ON documents.documents
  FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (current_setting('app.user_id', true))::bigint = uploaded_by
    OR (
      system.is_active_row(deleted_at)
      AND EXISTS (
        SELECT 1 FROM documents.document_access da
        WHERE da.document_id = documents.id
          AND (
            da.user_id = (current_setting('app.user_id', true))::bigint
            OR da.role_id IN (
              SELECT ur.role_id FROM security.user_roles ur
              WHERE ur.user_id = (current_setting('app.user_id', true))::bigint
            )
          )
      )
    )
    OR documents.fn_is_document_signer(documents.id)
  );

-- ── Child records: SELECT/INSERT/UPDATE gated by parent visibility ──
DO $$
DECLARE t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY['document_versions','document_audit','document_signatures','generated_documents']
  LOOP
    EXECUTE format('ALTER TABLE documents.%I ENABLE ROW LEVEL SECURITY', t);
  END LOOP;
END $$;

DROP POLICY IF EXISTS dv_select ON documents.document_versions;
CREATE POLICY dv_select ON documents.document_versions FOR SELECT
  USING (documents.fn_can_view_document(document_id));
DROP POLICY IF EXISTS dv_insert ON documents.document_versions;
CREATE POLICY dv_insert ON documents.document_versions FOR INSERT
  WITH CHECK (documents.fn_can_view_document(document_id));

DROP POLICY IF EXISTS da_select ON documents.document_audit;
CREATE POLICY da_select ON documents.document_audit FOR SELECT
  USING (documents.fn_can_view_document(document_id));
DROP POLICY IF EXISTS da_insert ON documents.document_audit;
CREATE POLICY da_insert ON documents.document_audit FOR INSERT
  WITH CHECK (documents.fn_can_view_document(document_id));

DROP POLICY IF EXISTS ds_select ON documents.document_signatures;
CREATE POLICY ds_select ON documents.document_signatures FOR SELECT
  USING (documents.fn_can_view_document(document_id)
         OR documents.fn_is_document_signer(document_id));
DROP POLICY IF EXISTS ds_insert ON documents.document_signatures;
CREATE POLICY ds_insert ON documents.document_signatures FOR INSERT
  WITH CHECK (documents.fn_can_view_document(document_id));
DROP POLICY IF EXISTS ds_update ON documents.document_signatures;
CREATE POLICY ds_update ON documents.document_signatures FOR UPDATE
  USING (documents.fn_can_view_document(document_id))
  WITH CHECK (documents.fn_can_view_document(document_id));
-- Narrow permissive policy (justified): a signer may flip ONLY their own
-- PENDING slot to SIGNED. Cannot touch other slots or reject/revoke.
DROP POLICY IF EXISTS ds_update_own ON documents.document_signatures;
CREATE POLICY ds_update_own ON documents.document_signatures FOR UPDATE
  USING (signer_id = (current_setting('app.user_id', true))::bigint
         AND signature_status = 'PENDING')
  WITH CHECK (signer_id = (current_setting('app.user_id', true))::bigint
              AND signature_status = 'SIGNED');

DROP POLICY IF EXISTS gd_select ON documents.generated_documents;
CREATE POLICY gd_select ON documents.generated_documents FOR SELECT
  USING (documents.fn_can_view_document(generated_document_id));
DROP POLICY IF EXISTS gd_insert ON documents.generated_documents;
CREATE POLICY gd_insert ON documents.generated_documents FOR INSERT
  WITH CHECK (documents.fn_can_view_document(generated_document_id));

-- ── document_access ───────────────────────────────────────────
ALTER TABLE documents.document_access ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS doc_access_select ON documents.document_access;
CREATE POLICY doc_access_select ON documents.document_access FOR SELECT
  USING (documents.fn_can_view_document(document_id));
DROP POLICY IF EXISTS doc_access_insert ON documents.document_access;
CREATE POLICY doc_access_insert ON documents.document_access FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint)
              OR documents.fn_can_view_document(document_id));
DROP POLICY IF EXISTS doc_access_delete ON documents.document_access;
CREATE POLICY doc_access_delete ON documents.document_access FOR DELETE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint)
         OR documents.fn_can_view_document(document_id));

-- ── document_approvals ────────────────────────────────────────
ALTER TABLE documents.document_approvals ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS doc_approvals_select ON documents.document_approvals;
CREATE POLICY doc_approvals_select ON documents.document_approvals FOR SELECT
  USING (documents.fn_can_view_document(document_id));
DROP POLICY IF EXISTS doc_approvals_insert ON documents.document_approvals;
CREATE POLICY doc_approvals_insert ON documents.document_approvals FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint)
              OR documents.fn_can_view_document(document_id));

-- ── Lookup tables: SELECT for all, writes admin-only ──────────
-- Includes the migration-58 lifecycle/config tables (source-of-truth config).
DO $$
DECLARE t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY['document_classifications','document_retention_rules','document_types','templates',
                           'document_lifecycle_states','document_lifecycle_transitions',
                           'document_signature_types','document_watermark_config']
  LOOP
    EXECUTE format('ALTER TABLE documents.%I ENABLE ROW LEVEL SECURITY', t);
    EXECUTE format('DROP POLICY IF EXISTS lookup_select ON documents.%I', t);
    EXECUTE format('CREATE POLICY lookup_select ON documents.%I FOR SELECT USING (true)', t);
    EXECUTE format('DROP POLICY IF EXISTS lookup_write ON documents.%I', t);
    EXECUTE format('CREATE POLICY lookup_write ON documents.%I FOR INSERT WITH CHECK (system.fn_is_admin((current_setting(''app.user_id'', true))::bigint))', t);
    EXECUTE format('DROP POLICY IF EXISTS lookup_update ON documents.%I', t);
    EXECUTE format('CREATE POLICY lookup_update ON documents.%I FOR UPDATE USING (system.fn_is_admin((current_setting(''app.user_id'', true))::bigint))', t);
    EXECUTE format('DROP POLICY IF EXISTS lookup_delete ON documents.%I', t);
    EXECUTE format('CREATE POLICY lookup_delete ON documents.%I FOR DELETE USING (system.fn_is_admin((current_setting(''app.user_id'', true))::bigint))', t);
  END LOOP;
END $$;

-- ── document_disposal_logs: admin writes, owner views ─────────
ALTER TABLE documents.document_disposal_logs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS disposal_select ON documents.document_disposal_logs;
CREATE POLICY disposal_select ON documents.document_disposal_logs FOR SELECT
  USING (documents.fn_can_view_document(document_id));
DROP POLICY IF EXISTS disposal_insert ON documents.document_disposal_logs;
CREATE POLICY disposal_insert ON documents.document_disposal_logs FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- ── document_verification_log: append-only for public, admin read ──
ALTER TABLE documents.document_verification_log ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS ver_log_select ON documents.document_verification_log;
CREATE POLICY ver_log_select ON documents.document_verification_log FOR SELECT
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));
DROP POLICY IF EXISTS ver_log_insert ON documents.document_verification_log;
CREATE POLICY ver_log_insert ON documents.document_verification_log FOR INSERT WITH CHECK (true);

-- ── Remove CASCADE on audit-related FKs ───────────────────────
ALTER TABLE documents.document_approvals DROP CONSTRAINT IF EXISTS fk_document_approvals_document;
ALTER TABLE documents.document_approvals
  ADD CONSTRAINT fk_document_approvals_document FOREIGN KEY (document_id)
  REFERENCES documents.documents(id) ON DELETE RESTRICT;

ALTER TABLE documents.document_access DROP CONSTRAINT IF EXISTS fk_document_access_document;
ALTER TABLE documents.document_access
  ADD CONSTRAINT fk_document_access_document FOREIGN KEY (document_id)
  REFERENCES documents.documents(id) ON DELETE RESTRICT;

-- document_signatures holds legally binding signature evidence: physical
-- delete must never cascade (audit trail integrity). Soft-delete only.
ALTER TABLE documents.document_signatures DROP CONSTRAINT IF EXISTS fk_document_signatures_document;
ALTER TABLE documents.document_signatures
  ADD CONSTRAINT fk_document_signatures_document FOREIGN KEY (document_id)
  REFERENCES documents.documents(id) ON DELETE RESTRICT;

-- Verify
DO $$
DECLARE v_missing INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_missing
    FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname = 'documents' AND c.relkind = 'r' AND NOT c.relrowsecurity;
    RAISE NOTICE 'Migration 59 complete (documents tables without RLS: %)', v_missing;
END $$;

COMMIT;
