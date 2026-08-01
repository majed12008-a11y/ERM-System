# ERM-System Forms Library — Database Mapping (v1)

> Version 1.0 · 2026-08-01
> DDL and RLS mapping for the new Forms Library schema, plus extensions to existing documents tables. Applied as `backend/seed/55-forms-library.sql`.

---

## 1. New Schema: `forms`

```sql
CREATE SCHEMA IF NOT EXISTS forms;

-- 1.1 Form definitions (schema-driven)
CREATE TABLE IF NOT EXISTS forms.form_definitions (
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    form_code       VARCHAR(100) NOT NULL,
    form_name_ar    VARCHAR(500) NOT NULL,
    form_name_en    VARCHAR(500),
    category        VARCHAR(50)  NOT NULL,
    workflow_stage  VARCHAR(50)  NOT NULL,
    version_no      INTEGER      NOT NULL DEFAULT 1,
    schema_version  VARCHAR(20)  NOT NULL DEFAULT '1.0.0',
    form_schema     JSONB        NOT NULL,
    renderer        VARCHAR(50)  NOT NULL DEFAULT 'schema-form',
    is_active       BOOLEAN      NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT now(),
    created_by      BIGINT REFERENCES security.users(id),
    updated_at      TIMESTAMPTZ,
    updated_by      BIGINT REFERENCES security.users(id),
    deleted_at      TIMESTAMPTZ,
    deleted_by      BIGINT REFERENCES security.users(id),
    CONSTRAINT uq_form_definitions_code_version UNIQUE (form_code, version_no),
    CONSTRAINT chk_form_definitions_soft_delete CHECK ((deleted_at IS NULL) OR (deleted_by IS NOT NULL))
);

-- 1.2 Form instances (filled data)
CREATE TABLE IF NOT EXISTS forms.form_instances (
    id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    form_definition_id  BIGINT NOT NULL REFERENCES forms.form_definitions(id),
    entity_type         VARCHAR(100) NOT NULL,
    entity_id           BIGINT NOT NULL,
    status              VARCHAR(20) NOT NULL DEFAULT 'DRAFT'
        CHECK (status IN ('DRAFT','SUBMITTED','RETURNED','APPROVED','VOID')),
    responses           JSONB NOT NULL DEFAULT '{}',
    total_score         NUMERIC(6,2),
    recommendation      VARCHAR(50),
    submitted_by        BIGINT REFERENCES security.users(id),
    submitted_at        TIMESTAMPTZ,
    approved_by         BIGINT REFERENCES security.users(id),
    approved_at         TIMESTAMPTZ,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by          BIGINT REFERENCES security.users(id),
    updated_at          TIMESTAMPTZ,
    updated_by          BIGINT REFERENCES security.users(id),
    deleted_at          TIMESTAMPTZ,
    deleted_by          BIGINT REFERENCES security.users(id),
    CONSTRAINT chk_form_instances_soft_delete CHECK ((deleted_at IS NULL) OR (deleted_by IS NOT NULL))
);

CREATE INDEX IF NOT EXISTS idx_form_instances_entity ON forms.form_instances (entity_type, entity_id, status);
CREATE INDEX IF NOT EXISTS idx_form_definitions_active ON forms.form_definitions (form_code, is_active);
```

### RLS (forms schema)

```sql
ALTER TABLE forms.form_definitions ENABLE ROW LEVEL SECURITY;
ALTER TABLE forms.form_instances ENABLE ROW LEVEL SECURITY;

-- Definitions: readable by all authenticated users; write by admins
CREATE POLICY fd_select ON forms.form_definitions FOR SELECT USING (true);
CREATE POLICY fd_insert ON forms.form_definitions FOR INSERT
  WITH CHECK (system.fn_is_admin());
CREATE POLICY fd_update ON forms.form_definitions FOR UPDATE
  USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());
CREATE POLICY fd_delete ON forms.form_definitions FOR DELETE USING (false); -- soft only

-- Instances: creator owns their drafts; submissions visible to committee
CREATE POLICY fi_select ON forms.form_instances FOR SELECT
  USING (created_by = app.user_id
         OR system.fn_is_admin()
         OR EXISTS (SELECT 1 FROM security.user_roles ur
                    JOIN security.roles r ON ur.role_id = r.id
                    WHERE ur.user_id = app.user_id AND ur.is_active
                      AND r.name IN ('ETHICS_ADMIN','CHAIR','COMMITTEE_MEMBER','COORDINATOR')));
CREATE POLICY fi_insert ON forms.form_instances FOR INSERT
  WITH CHECK (created_by = app.user_id OR system.fn_is_admin());
CREATE POLICY fi_update ON forms.form_instances FOR UPDATE
  USING (created_by = app.user_id OR system.fn_is_admin())
  WITH CHECK (created_by = app.user_id OR system.fn_is_admin());
CREATE POLICY fi_delete ON forms.form_instances FOR DELETE USING (false);
```

**Note on `system.fn_is_admin()`:** already exists (used by documents policies). Check `46-certificate-rls-hotfix.sql` for the exact name/behavior; if the project uses `system.is_admin()` adjust accordingly.

---

## 2. Extend `documents.templates`

```sql
ALTER TABLE documents.templates
  ADD COLUMN IF NOT EXISTS language          VARCHAR(5)  NOT NULL DEFAULT 'ar',
  ADD COLUMN IF NOT EXISTS document_category VARCHAR(50),
  ADD COLUMN IF NOT EXISTS is_default        BOOLEAN     NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS schema_metadata   JSONB;

-- Default per code: exactly one active default per (template_code, language)
CREATE UNIQUE INDEX IF NOT EXISTS uq_templates_default
  ON documents.templates (template_code, language)
  WHERE is_default AND is_active;
```

## 3. New: `documents.document_numbering`

```sql
CREATE TABLE IF NOT EXISTS documents.document_numbering (
    id        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category  VARCHAR(50) NOT NULL,
    year      INTEGER     NOT NULL,
    prefix    VARCHAR(20) NOT NULL,
    last_seq  BIGINT      NOT NULL DEFAULT 0,
    CONSTRAINT uq_document_numbering UNIQUE (category, year)
);

CREATE POLICY dn_select ON documents.document_numbering FOR SELECT USING (true);
CREATE POLICY dn_write ON documents.document_numbering FOR INSERT WITH CHECK (true);
ALTER TABLE documents.document_numbering ENABLE ROW LEVEL SECURITY;
```

## 4. Writes to existing tables (now active)

| Table | Written by | Purpose |
|---|---|---|
| `documents.generated_documents` | Engine | Every generated document: template_id, entity, generated_document_id, generation_parameters (context), generated_by/at |
| `documents.document_versions` | Engine | Immutable version history + checksum for each generated PDF |
| `documents.document_signatures` | Signing service | Signature records with `signature_hash`, `certificate_serial` (populated) |
| `documents.document_audit` | Engine | `action_type` = GENERATE/RENDER/SIGN/VERIFY with details JSONB |
| `documents.document_approvals` | Letter approval flow | Approval records for official letters |

## 5. Audit triggers

```sql
DO $$
DECLARE v_tables TEXT[] := ARRAY['form_definitions','form_instances','document_numbering'];
        v_tbl TEXT;
BEGIN
  FOREACH v_tbl IN ARRAY v_tables
  LOOP
    IF NOT EXISTS (SELECT 1 FROM information_schema.triggers
                   WHERE event_object_schema = CASE WHEN v_tbl LIKE 'form%' THEN 'forms' ELSE 'documents' END
                     AND event_object_table = v_tbl
                     AND trigger_name = 'trg_audit_' || v_tbl) THEN
      EXECUTE format(
        'CREATE TRIGGER trg_audit_%I AFTER INSERT OR UPDATE OR DELETE ON %I.%I
         FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit()',
        v_tbl, CASE WHEN v_tbl LIKE 'form%' THEN 'forms' ELSE 'documents' END, v_tbl);
    END IF;
  END LOOP;
END;
$$;
```

## 6. Entity-relationship map

```
form_definitions 1 ─── N form_instances
form_instances N ─── 1 {core.applications | committee.meetings | ...}   (entity_type, entity_id)
generated_documents 1 ─── 1 documents.documents (generated_document_id)
generated_documents N ─── 1 documents.templates (template_id)
documents.documents 1 ─── N document_versions
documents.documents 1 ─── N document_signatures
documents.documents 1 ─── N document_approvals
documents.documents 1 ─── N document_audit
```

**Note:** `documents.documents.document_type_id` is NOT NULL — the engine must always supply an explicit `document_type_id` (register official document types, e.g. `OFFICIAL_LETTER`, `REVIEW_FORM`, `MINUTES`, `CONSENT`, in the `documents.document_types` table).
