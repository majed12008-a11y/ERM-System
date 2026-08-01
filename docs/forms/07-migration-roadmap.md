# ERM-System Forms Library — Migration Plan & Implementation Roadmap

> Version 1.0 · 2026-08-01

---

## 1. Migration Plan (from legacy artifacts)

### 1.1 Inventory to migrate / retire

| Legacy artifact | Disposition | Action |
|---|---|---|
| `committee.review_forms` + `review_questions` (SCI/ETH/EXP) | **Superseded** by `forms.form_definitions` | Migrate existing questions into form JSON schemas (map TEXT→textarea, SCALE→scale, BOOLEAN→boolean, CHOICE→radio); keep the tables read-only until migration verified, then retire |
| `APPROVAL_CERTIFICATE_V1` template | **Keep & align** | Re-point `CertificateService` to the new engine; register document type `APPROVAL_CERTIFICATE`; keep serial compatibility `CERT-<appNo>-V<n>` |
| `IRB_APPROVAL_LETTER`, `REVIEW_FORM`, `SAE_REPORT`, `ANNUAL_PROGRESS`, `ICF_TEMPLATE` | **Rebuild** | Replaced by production templates under the new engine; old rows retired (`is_active=false`) after verification |
| `YEM_*` templates | **Retire** | Mark inactive; replace with localized real templates |
| `documents.generated_documents` | **Activate** | Engine now writes it |
| `documents.document_versions` | **Activate** | Engine now writes it |
| Raw `.txt` meeting minutes | **Superseded** | Committee minutes become FRM-015 generated PDFs |

### 1.2 Migration sequence

1. **Backup:** full DB dump (`pg_dump`) + snapshot of `documents.templates`.
2. **Schema:** apply `backend/seed/55-forms-library.sql` (forms schema + template columns + numbering + audit triggers). Idempotent.
3. **Seed:** apply form definitions + bilingual templates.
4. **Data migration script:** transform `review_questions` → form JSON schemas into `forms.form_definitions` (idempotent, log counts).
5. **Code:** ship engine + modules; keep `CertificateService` working through the engine shim.
6. **Verify:** seed data renders; legacy templates marked inactive; no orphaned references.
7. **Cutover:** new documents use new engine; old files remain readable via documents store.

### 1.3 Backward compatibility guarantees

- Certificate serial numbers and public verification URLs remain valid.
- Existing uploaded documents are untouched (no migration of storage).
- `documents.templates` `(template_code, version_no)` unique constraint preserved.

---

## 2. Implementation Roadmap

### Phase A — Document Engine (this delivery)
- [x] Generalize rendering into `DocumentRenderService` (wrapper header/footer, QR, numbering, checksum, storage, versioning, audit).
- [x] Document numbering service + `document_numbering` table.
- [x] Template model extensions (language/category/default) + active-by-code lookup.
- [x] Forms schema module: definitions + instances CRUD + submission + validation.
- [x] Seed v1 form definitions (FRM-001,002,003,004,005,024,025,028) + bilingual templates (letters, notice).
- [x] Frontend schema-driven renderer + document preview + generate/download flows.

### Phase B — Application lifecycle forms (this delivery)
- [x] FRM-001 Application form (schema-driven, wizard).
- [x] FRM-002 Admin Screening, FRM-003/005 review forms fill flow.
- [x] FRM-010/011/015/016/017 committee documents.
- [x] FRM-018 certificate alignment, FRM-019/020/021 official letters.
- [x] FRM-024/025/026 safety & progress, FRM-028 monitoring.
- [x] FRM-030/031/032/033 closure & notices, FRM-034 consent, FRM-035 receipt.
- [ ] FRM-012/013/014 declarations wired to signatures + FRM-037 appeal (follow-up).

### Phase C — Hardening & scale (follow-up sessions)
- [ ] PDF/A post-processing (Ghostscript) + `pdfa_conformance` metadata.
- [ ] Tamper-evident footer (HMAC of serial+uuid+checksum).
- [ ] Real PKI e-signature integration (national CA) populating `certificate_serial`.
- [ ] Font bundling in Docker image (Noto Sans Arabic woff2/ttf) + Chrome install step.
- [ ] `forms` RLS policy refinement + performance indexes + `total_score` materialization.
- [ ] Server-side generation queue (worker) for bulk letters; SSE progress.
- [ ] Public document verification UI for all document classes (not just certificates).
- [ ] i18n completion for all new form labels (keys added to `ar.json`/`en.json`).

---

## 3. Definition of Done (per form)

1. JSON schema stored + validates; bilingual labels present.
2. Interactive UI renders via the schema-driven renderer with conditional fields and auto-save.
3. Submission validates server-side; `form_instances` row immutable once submitted.
4. Official PDF renders from submitted data with full header/QR/signature/footer anatomy.
5. `documents.documents` + `document_versions` + `generated_documents` + `document_audit` rows written.
6. Audit triggers active; reference number allocated and unique.
7. Notification triggered on relevant transitions.
8. Backend `tsc --noEmit` clean; frontend typecheck clean for touched files.
