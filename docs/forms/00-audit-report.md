# ERM-System Forms Library — Audit Report

> Version 1.0 · 2026-08-01 · Status: Approved
> Author: Forms Library Redesign Program
> Scope: Complete audit of the existing forms, templates, and document infrastructure of the ERM-System (Ethics Review Management System).

---

## 1. Executive Summary

The current ERM-System contains **no cohesive Forms Library**. What exists is a set of disconnected, partially-implemented artifacts:

- Three **review questionnaires** (`committee.review_forms` + `review_questions`) that are a single-question list, not structured forms.
- Eleven **document templates** (`documents.templates`) of which exactly **one** (`APPROVAL_CERTIFICATE_V1`) has a working renderer.
- A **certificate subsystem** (Handlebars + Puppeteer + QRCode) that is the only end-to-end document pipeline in the system.
- An **informed consent** template management subsystem that stores raw text with **no rendering or preview**.
- A set of **`generated_documents` and `document_versions` tables that are dead schema** — seeded but never written by application code.

There are **no** official letters (approval/rejection/deferral), **no** committee meeting documents (agenda, minutes, attendance, voting, decision record), **no** safety/oversight forms (SAE, deviation, non-compliance, suspension, termination, closure), **no** monitoring instruments (site monitoring checklist, inspection report), and **no** declaration forms (researcher declaration, COI, confidentiality).

**Verdict:** The system fails the requirements of a national ethics review platform. A full redesign of the Forms Library is required, built on a reusable schema-driven form engine and a generalized backend document engine.

---

## 2. Audit Method

- Static analysis of `backend/src/modules`, `backend/src/services`, `backend/src/repositories`, `frontend/src/pages`, `frontend/src/components`.
- Database schema extraction from `database/canonical/` and seed analysis across `backend/seed/*.sql`.
- Live runtime verification against `localhost:8080` and `localhost:5173`.

---

## 3. Current-State Inventory

### 3.1 Review forms (questionnaires)

| Table | Purpose | Rows (seeded) | Fields |
|---|---|---|---|
| `committee.review_forms` | Form header | `SCI_REVIEW_V1`, `ETH_REVIEW_V1`, `EXP_REVIEW_V1`, `NCBE-YE-STD-001` | `form_code`, `form_name`, `review_type`, `version_no`, `is_active` |
| `committee.review_questions` | Flat question list | ~11 questions total | `question_code`, `question_text`, `question_type` (`TEXT`/`SCALE`/`BOOLEAN`/`CHOICE`), `display_order`, `is_required`, `question_options` |

**Weaknesses:**
- No sections, no guidance text, no conditional logic, no scoring/weighting, no recommendation field, no reviewer signature linkage.
- `EXP_REVIEW_V1` has **zero questions**.
- No bilingual question text (`question_text` is single-language).
- No version history; editing a live form mutates it in place.
- No linkage to the printable `REVIEW_FORM` template; the two are unrelated.

### 3.2 Document templates (`documents.templates`)

| `template_code` | Type | Has renderer | Notes |
|---|---|---|---|
| `APPROVAL_CERTIFICATE_V1` | `CERTIFICATE` | ✅ `CertificateService` | Full RTL HTML + QR |
| `IRB_APPROVAL_LETTER` | `PDF` | ❌ | Plain-text Handlebars, dead |
| `REVIEW_FORM` | `PDF` | ❌ | Plain-text Handlebars, dead |
| `ICF_TEMPLATE` | `HTML` | ❌ | Full HTML, no context builder |
| `SAE_REPORT` | `PDF` | ❌ | Plain-text Handlebars, dead |
| `ANNUAL_PROGRESS` | `PDF` | ❌ | Plain-text Handlebars, dead |
| `YEM_*` (×5) | `PDF`/`HTML` | ❌ | One-line plain text, dead |
| `SMOKE_TEST` | `HTML` | ❌ | Test data (inactive) |

**Weaknesses:**
- **10 of 12 templates have no code path.** No service reads them.
- `getTemplateContent()` selects by `template_code` **only** — ignores `version_no` and `is_active`. Versioning is effectively broken.
- Plain-text "PDF" templates cannot produce professional output (no header, no footer, no QR, no branding, no RTL layout).
- No `language` column, no `document_category`, no default-version marker, no layout/schema metadata.
- `documents.templates` has **no RLS policies** — readable by every authenticated user (acceptable for templates, but inconsistent with the strict documents policies).
- `template_content` has no validation; no preview/sandbox for Handlebars errors.

### 3.3 Certificate subsystem (the only working pipeline)

- `approval_certificates` lifecycle: `DRAFT → GENERATING → ISSUED → (REVOKED | SUPERSEDED | FAILED)`.
- `CertificateService.generate()` triggered as a side-effect when an application reaches `APPROVED` (`application.service.ts:162`).
- Rendering: `Handlebars.compile → page.setContent → page.pdf(A4, 20mm margins, printBackground)`.
- QR: `QRCode.toDataURL('https://ethics.erc.gov.sa/verify?serial=' + serial)` embedded in the HTML.
- Public verification: `GET /api/v1/public/verify/:serialNumber` + `VerifyPage` (browser print).
- **Weaknesses:**
  - Template lookup unversioned (see 3.2).
  - `document_type_id` passed as `undefined` to `documents.documents` INSERT despite NOT NULL (works only because a DB default exists) — should be set explicitly.
  - Signature hash (`sha256(userId-docId-timestamp)`) is a **placeholder**, not a tamper-evident digest of the PDF content.
  - Generated PDFs are stored but the **`documents.document_versions` history table is never written**.
  - No PDF/A conformance, no document numbering beyond the certificate serial.
  - Fonts referenced via `file:///app/fonts/...` are **not bundled in the Docker image**.

### 3.4 Consent templates

- `committee.consent_templates` + `consent_template_versions` (`DRAFT/UNDER_REVIEW/APPROVED/RETIRED`).
- Content is **raw text**; there is **no rendering**, **no printable document**, **no bilingual content storage per version** beyond `language` scalar.
- `core.application_consents` links applications to approved versions, but no document is ever produced.

### 3.5 Dead / seeded-but-unused schema

| Table | Status |
|---|---|
| `documents.generated_documents` | Seeded (`20-remaining-core-data.sql:442`) but **no repository/service writes it** |
| `documents.document_versions` | **Never written by app code** |
| `documents.document_approvals` | Never written |
| `documents.document_audit` | Exists; `system.audit_logs` trigger covers audits instead — unused |
| `documents.document_retention_rules` | Never written |

### 3.6 Form UI infrastructure

- **No shared form primitives.** The UI library (`components/ui`) has `Button`, `Input`, `Textarea`, `Label`, `Card`, `Dialog`, `Select`, `Switch`, `Badge`, `Table`. Missing: `Checkbox`, `RadioGroup`, `DatePicker`, `FormField`/`FormItem`, `ErrorMessage`, `Tabs`, `Accordion`, `Stepper`, `Scale/Rating`, `FileUpload`, `Combobox`.
- **Three inconsistent form styles**:
  1. RHF + zod + `ui/*` primitives (Profile, Documents, MeetingDetail);
  2. RHF + zod + raw HTML inputs (majority: Applications, Accreditation, Safety, Projects, ReviewForms);
  3. Raw `useState` controlled forms (ConsentTemplates, DocumentTemplates).
- **No schema-driven renderer.** The only dynamic rendering is ad-hoc `switch` over question types in `Applications/Detail.tsx:408-432`.
- **No `useFieldArray`** — array fields hand-rolled via dot-path register.
- **No document preview** beyond a raw `<pre>` in `Admin/DocumentTemplates.tsx:192`.
- **No client-side PDF / print CSS** for official documents (by design — documents are backend-generated).

### 3.7 Other gaps found

- `Applications/Detail.tsx:18` imports `committeeDecisionSchema` which is **not exported** from `lib/schemas.ts` (breaks `tsc -b`).
- `CyclesList.tsx` has RHF typing errors (`to_status` on a `{transition_code, decision_reason}` type).
- `ReviewFormsPage` allows editing live forms in place with no versioning.
- No form-level audit view, no document history UI, no approval workflows for generated documents.

---

## 4. Gap Analysis (Required vs. Current)

| Requirement | Current State | Gap |
|---|---|---|
| Application/Protocol registration | `core.applications` + 4-step wizard | No formal protocol registration document, no schema-driven form |
| Administrative screening checklist | ❌ | **Missing** |
| Scientific review (primary/secondary) | Flat 5-question list | Not a structured form, no printable output |
| Ethical review | Flat 6-question list | Same |
| Statistical / legal / bioethics review | ❌ | **Missing** |
| Expedited / exemption determination | `EXP_REVIEW_V1` (empty) | **Missing** content |
| Committee agenda / attendance / minutes / voting / decision record | Raw meeting tables, `.txt` minutes | **Not production documents**; no PDF/QR/signature |
| Approval certificate | ✅ Working | Needs document numbering, versioning, PDF/A |
| Conditional approval / rejection / deferral letters | ❌ | **Missing** |
| Amendment request/review | ❌ | **Missing** |
| Continuing review / annual progress | `ANNUAL_PROGRESS` template (dead) | **Missing** code path + form |
| SAE / deviation / non-compliance reports | `SAE_REPORT` template (dead) | **Missing** code path + forms |
| Site monitoring checklist / inspection report | ❌ | **Missing** |
| Suspension / termination / closure / final report | ❌ | **Missing** |
| Informed consent template | Raw text store | No rendering, no PDF, no bilingual rendering |
| Researcher / COI / confidentiality declarations | ❌ | **Missing** |
| Document receipt / appeal / complaint | ❌ | **Missing** |
| Official header, QR, numbering, digital seal, bilingual, RTL/LTR, PDF/A | Partial (certificates only) | Must be generalized |

---

## 5. Redesign Directives

1. **Generalize the certificate pipeline** into a reusable backend **Document Engine** (`DocumentRenderService`) that renders *any* template with an official wrapper (header/logo/number/QR/version/issue date/signature/seal/confidentiality/footer/page numbers).
2. **Introduce schema-driven forms**: a `forms` schema with JSON-schema definitions, versioned instances, and a reusable frontend renderer.
3. **Version templates properly**: lookup by `(template_code, language)` honoring `is_active` and version selection; record every generated document in `document_versions`.
4. **Establish document numbering**: category-based reference numbers (e.g. `REC-2026-APPR-000123`).
5. **Make generated PDFs immutable and auditable**: SHA-256 checksum, soft-delete only, full audit trail, public QR verification.
6. **Add bilingual support**: `language` on templates, `{{t 'key'}}`-style context or dual-content templates, `dir` honored at render time.
7. **Replace all dead templates** with production-grade HTML/CSS templates; delete/retire the plain-text placeholders.

See the companion documents in this folder for the full catalog, data dictionary, business rules, PDF specifications, database mapping, JSON schemas, template variables, migration plan, and implementation roadmap.
