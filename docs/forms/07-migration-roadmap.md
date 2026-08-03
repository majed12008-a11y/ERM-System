# ERM-System Forms Library — Migration Plan & Implementation Roadmap (v2)

> Version 2.0 · 2026-08-02
> Migration plan and phased implementation roadmap for the ~50-form Official Forms & Documents Framework.
> **v2 update:** Phases A/B (engine + seeded forms + templates) are now **implemented and verified** (document infrastructure plan, Tasks 1–9). This roadmap re-scopes the remaining work around the five mandatory features (Gate 0) and the six-category catalog.

---

## 1. Migration Plan (from legacy artifacts)

### 1.1 Inventory to migrate / retire

| Legacy artifact | Disposition | Action |
|---|---|---|
| `committee.review_forms` + `review_questions` (INTG_TEST_* rows) | **Remove** | delete integration-test rows; verify no code depends on them; retire `/api/v1/committee/reviews/forms` routes + `ReviewFormsPage` if unused |
| `SCI_REVIEW_V1`/`ETH_REVIEW_V1` legacy forms | **Superseded** | content already recreated as JSON schemas (`SCI_REVIEW_PRIMARY`, `ETH_REVIEW`) |
| `APPROVAL_CERTIFICATE_V1` template | **Replace** | re-point certificate subsystem to the engine; keep serial compatibility `CERT-<appNo>-V<n>`; register `CERTIFICATE_DOC` |
| `IRB_APPROVAL_LETTER`, `ICF_TEMPLATE` | **Replace** | → `DECISION_LETTER` variant / `CONSENT_DOCUMENT` |
| `REVIEW_FORM`, `SAE_REPORT`, `ANNUAL_PROGRESS`, `SMOKE_TEST` | **Remove** | `is_active=false` (dead rows; superseded by `*_DOC` templates) |
| `PROGRESS_REPORT_DOC` | **Refactor** | re-categorize from MONITORING_REPORT → POST_APPROVAL |
| `documents.generated_documents`, `document_versions`, `document_approvals`, `document_audit` | **Keep (activated)** | continue engine writes |
| Raw `.txt` meeting minutes | **Superseded** | committee minutes = `MEETING_MINUTES_DOC` generated PDFs |

### 1.2 Migration sequence

1. **Backup:** full `pg_dump` + snapshot of `documents.templates`.
2. **Cleanup:** delete INTG_TEST_* rows; mark dead templates inactive.
3. **Gate 0 schema:** lifecycle CHECK expansion + `document_signatures` unique index + numbering categories for new classes (GEN/PPT/etc.).
4. **Seed:** new form definitions (42 to create) + new templates (`CONSENT_DOCUMENT`, `PIS_DOCUMENT`, `ASSENT_DOCUMENT`, `APPLICATION_DOC`, `RECEIPT_DOC`, `NOTICE_DOC`, `CERTIFICATE_DOC`, `DECLARATION_DOC`) — idempotent.
5. **Code:** renderer field-type extensions, multi-signature, checksum route, verification portal expansion, watermark injection.
6. **Verify:** each phase gated by backend `tsc --noEmit`, `npm test`, frontend `npm run build`; E2E per workflow path.
7. **Cutover:** new documents use new engine; old files remain readable via documents store.

### 1.3 Backward compatibility guarantees

- Certificate serials + public verification URLs remain valid.
- Existing uploaded documents untouched.
- `documents.templates (template_code, version_no)` unique constraint preserved; `uq_templates_default` continues to enforce one default per `(code, language)`.
- Legacy doc 1057 (null number, no template_code) left as-is (historical).

---

## 2. Implementation Roadmap

### Gate 0 — Mandatory features (do BEFORE new forms)
- [ ] **0.1 Multi-signature:** `document_signatures` unique `(document_id, signer_id, signature_type)`; extend `signDocument`; `SignatureBlock` UI + template `signatories[]`.
- [ ] **0.2 Checksum verification API:** `POST /public/checksum` (multipart) → `VALID|INVALID|MODIFIED`; rate-limited.
- [ ] **0.3 Verification portal:** VerifyPage shows versions, checksum, signatures, superseded-by, revocation reason, audit timeline; file-upload checksum compare.
- [ ] **0.4 Watermarks:** engine `.watermark` injection (DRAFT/COPY/VOID/SUPERSEDED/REVOKED/EXPIRED); render-time only.
- [ ] **0.5 Lifecycle expansion:** documents CHECK → `DRAFT/PENDING_SIGNATURE/APPROVED/ISSUED/SUPERSEDED/REVOKED/VOID/EXPIRED/ARCHIVED`; approve + expire + archive endpoints; scheduler for EXPIRED.

### Phase 1 — Renderer & validation hardening
- [ ] `SchemaForm.tsx`: add `email`, `tel`, `file`, `checkbox`, `placeholder`, `default`, `help`, `multiline`, `step`, `readOnly`, `hidden`; `computed` generalization (mean/sum/min/max/concat).
- [ ] Server-side validation: Zod-from-schema at submit → `validationErrors[]`.
- [ ] `total_score`/`recommendation` materialized on submit.

### Phase 2 — Refactor seeded forms (8) to full spec + re-categorize
- [ ] FRM-002 (General), FRM-003/005 (Review), FRM-015 (Committee), FRM-024/025/028/032 (Study Monitoring) → full field specs, bilingual, conditional/computed.

### Phase 3 — Review forms
- [ ] FRM-004 `SCI_REVIEW_SECONDARY`, FRM-006 `STAT_REVIEW`, FRM-007 `LEGAL_REVIEW`, FRM-008 `EXPEDITED_REVIEW`, FRM-022 `AMENDMENT_REQUEST`, FRM-023 `AMENDMENT_REVIEW`, FRM-047 `REVIEW_ASSIGNMENT`, FRM-048 `REVIEW_CONSOLIDATION`.

### Phase 4 — Committee forms
- [ ] FRM-010 `COMM_AGENDA`, FRM-011 `COMM_ATTENDANCE`, FRM-012 `COI_DECLARATION`, FRM-013 `CONFIDENTIALITY_AGREEMENT`, FRM-016 `VOTING_RECORD`, FRM-017 `DECISION_RECORD`.

### Phase 5 — Official Documents
- [ ] FRM-014 `RESEARCHER_DECLARATION`, FRM-018 certificate alignment, FRM-019/020/021 letters, FRM-030/031 notices, FRM-042/043/044/050 letters; `DECLARATION_DOC`/`NOTICE_DOC` templates.

### Phase 6 — Study Monitoring + General
- [ ] FRM-026 `DEVIATION_REPORT`, FRM-027 `NONCOMPLIANCE_REPORT`, FRM-029 `INSPECTION_REPORT`, FRM-033 `FINAL_STUDY_REPORT`.
- [ ] FRM-001 `APP_PROTOCOL` (+ `APPLICATION_DOC`), FRM-009 `EXEMPTION_DETERMINATION`, FRM-035 `DOCUMENT_RECEIPT`, FRM-037 `APPEAL_FORM`, FRM-045 `CORRESPONDENCE`, FRM-046 `APPLICATION_WITHDRAWAL`, FRM-049 `DATA_REQUEST_FORM`.

### Phase 7 — Participant + Consent
- [ ] FRM-034 `ICF_TEMPLATE`, FRM-038 `PIS_TEMPLATE`, FRM-039 `ASSENT_TEMPLATE` (+ `CONSENT_DOCUMENT`/`PIS_DOCUMENT`/`ASSENT_DOCUMENT` templates).
- [ ] FRM-036 `PARTICIPANT_COMPLAINT`, FRM-040 `PARTICIPANT_WITHDRAWAL`, FRM-041 `PARTICIPANT_NOTICE`.

### Hardening & scale (follow-up)
- [ ] PDF/A post-processing (Ghostscript) + `pdfa_conformance` metadata.
- [ ] Tamper-evident footer HMAC (serial+uuid+checksum).
- [ ] Real PKI e-signature integration (national CA) → `certificate_serial`.
- [ ] Font bundling in Docker (Noto Sans Arabic woff2/ttf) + Chrome install step.
- [ ] RLS refinement + indexes + `total_score` materialization.
- [ ] Server-side generation queue (worker) for bulk letters; SSE progress.
- [ ] i18n completion for all new form labels (`ar.json`/`en.json`).

---

## 3. Definition of Done (per form)

1. JSON schema stored + validates; bilingual labels present.
2. Interactive UI renders via the schema-driven renderer with conditional fields, autosave, and (where applicable) computed score.
3. Submission validates server-side; `form_instances` row immutable once submitted.
4. Official PDF renders from submitted data with full header/QR/signature/seal/watermark/footer anatomy.
5. `documents.documents` + `document_versions` + `generated_documents` + `document_audit` rows written; reference number allocated unique.
6. Multi-signature gate satisfied where the form is an official decision/letter.
7. Audit triggers active; notification triggered on relevant transitions.
8. Backend `tsc --noEmit` clean; frontend typecheck clean for touched files; E2E passes for the form's workflow path.

---

## 4. Success Criteria (v2)

- All 50 catalog forms render via the shared renderer and generate official documents via the engine.
- Zero standalone forms; zero duplicated generation logic; zero lifecycle bypass.
- Public verification + checksum endpoints fully operational for all OFFICIAL documents.
- Legacy artifacts removed/retired per §1.1 with no regression in existing application/certificate workflows.
