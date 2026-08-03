-- 61-gate0-document-audit-signer-rls.sql
-- Task 4: an assigned signer must be able to write audit entries for documents
-- they are signing (e.g. the SIGNED action recorded by logAudit).
-- Mirrors the dual-gate pattern already used by ds_select in 59-gate0-document-rls.sql.

DROP POLICY IF EXISTS da_insert ON documents.document_audit;
CREATE POLICY da_insert ON documents.document_audit FOR INSERT
  WITH CHECK (documents.fn_can_view_document(document_id)
              OR documents.fn_is_document_signer(document_id));
