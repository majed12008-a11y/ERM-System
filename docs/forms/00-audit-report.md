# ERM-System Forms Library — Audit Report

> Version 2.0 · 2026-08-02 · Status: Approved
> Author: Official Forms & Documents Framework Program
> Scope: Complete audit of every existing form, template, and document pipeline in the ERM-System, as the mandatory first step of the Official Forms & Documents Framework build-out. Verdicts follow the task taxonomy: **Keep / Refactor / Merge / Split / Replace / Remove**.
> Supersedes: v1.0 (2026-08-01) which documented the pre-implementation state.

---

## 1. Executive Summary

The **v1 audit (2026-08-01) identified a fragmented, non-production state** and mandated a redesign. That redesign has since been **implemented and verified** (document infrastructure plan, Tasks 1–9, all done). This v2 audit re-baselines against what **actually exists in code and in the live database** so the ~50-form build-out starts from a truthful inventory.

**What changed since v1:**

| v1 finding (2026-08-01) | v2 status (2026-08-02) |
|---|---|
| No cohesive Forms Library | ✅ `forms` schema exists: `form_definitions` + `form_instances` with RLS, **8 seeded JSON-schema forms** |
| 10 of 12 templates had no code path | ✅ Generalized `DocumentRenderService` + render repository; **14 production HTML templates** (7 classes × ar/en) wired through it |
| `document_versions` / `generated_documents` dead schema | ✅ Engine writes `documents.documents`, `document_versions`, `document_audit`, `document_numbering` |
| No verification | ✅ Public verify endpoint + VerifyPage + QR; checksum immutability via `trg_documents_immutable` |
| No versioning/supersession | ✅ `new-version`, `set-default`, supersession chain, `REVOKED`/`VOID` lifecycle |
| No schema-driven renderer | ✅ `SchemaForm.tsx` renders `sections → fields` (text/textarea/number/date/boolean/select/radio/scale) with conditionals, local validation, bilingual labels |
| No official letters/minutes/safety docs | ✅ `DECISION_LETTER`, `MEETING_MINUTES_DOC`, `SAFETY_REPORT_DOC`, `MONITORING_REPORT_DOC`, `PROGRESS_REPORT_DOC`, `CLOSURE_REPORT_DOC`, `REVIEW_FORM_DOC` (ar + en) |
| Legacy flat questionnaires | ⚠️ **Still present** — `committee.review_forms` now contains only integration-test junk rows (INTG_TEST_*); real legacy forms (SCI_REVIEW_V1, ETH_REVIEW_V1) are gone from live data |

**Verdict summary (this v2):** of the forms/documents that exist today, **none are pure "Keep"**; the majority are **Refactor** (schema/content depth) or **Replace** (legacy templates). Below is the full per-form verdict matrix with reasoning and required action.

---

## 2. Audit Method

- Static analysis: `backend/src/modules/forms`, `backend/src/services/{form,document-render,certificate}.service.ts`, `backend/src/repositories/{form,document-render}.repository.ts`, `frontend/src/components/forms/*`, `frontend/src/pages/Forms/*`, `frontend/src/pages/Verify/*`.
- Live DB verification (ethics_db): `forms.form_definitions` (8 rows), `documents.templates` (22 rows), `committee.review_forms` (17 rows, all INTG_TEST_*), `documents.document_types` (40 rows), constraint definitions, workflow states/transitions.
- The task's 6 target categories used for future classification: **General, Review, Committee, Official Documents, Study Monitoring, Participant**.

---

## 3. Current-State Inventory

### 3.1 Schema-driven forms — `forms.form_definitions` (8 seeded, all v1, `schema_version 1.0.0`, active)

| form_code | AR name | Category | Workflow stage | Sections | Fields |
|---|---|---|---|---|---|
| `ADMIN_SCREENING` | قائمة التدقيق الإداري | SCREENING | Initial Review | 2 | 6 (4 completeness booleans, outcome radio COMPLETE/INCOMPLETE/REJECTED, comments) |
| `SCI_REVIEW_PRIMARY` | المراجعة العلمية - التقييم الأساسي | REVIEW | Scientific Review | 3 | 11 (reviewer info, merit scales/selects, verdict w/ conditional justification) |
| `ETH_REVIEW` | المراجعة الأخلاقية | REVIEW | Ethical Review | 2 | 6 |
| `ANNUAL_PROGRESS` | تقرير التقدم السنوي | POST_APPROVAL | Continuing Review | 2 | 6 |
| `SAE_REPORT` | تقرير الحدث العكسي الخطير | SAFETY | SAE Review | 3 | 11 |
| `SITE_MONITORING` | قائمة مراقبة الموقع | MONITORING | Study Monitoring | 3 | 12 |
| `STUDY_CLOSURE` | تقرير إغلاق الدراسة | CLOSURE | Study Closure | 2 | 5 |
| `COMM_MINUTES` | محضر اجتماع اللجنة | MEETING | Committee Review | 2 | 8 |

**Supported field types in the renderer (`SchemaForm.tsx`):** `text`, `textarea`, `number`, `date`, `boolean` (Switch), `select`, `radio` (chips), `scale` (1–5 buttons). Supports: `required`, `conditional {field, equals}`, `min/max`, `maxLength`, `pattern`, `rows`. Local validation only (no server-side Zod-from-schema yet).

**Documented in meta-schema (`02-data-dictionary.md` §2) but NOT yet renderer-supported:** `email`, `tel`, `file`, `checkbox`, `placeholder`, `default`, `multiline`. → verdict: **Refactor** (extend renderer + validation).

### 3.2 Document templates — `documents.templates` (22 rows)

**Production HTML templates (wired through `DocumentRenderService`, ar+en, default+active):**

| template_code | type | ar | en | document_category | Renderer |
|---|---|---|---|---|---|
| `DECISION_LETTER` | HTML | id 9 | id 15 | OFFICIAL_LETTER | ✅ |
| `REVIEW_FORM_DOC` | HTML | id 11 | id 19 | REVIEW_FORM | ✅ |
| `SAFETY_REPORT_DOC` | HTML | id 12 | id 20 | SAFETY_REPORT | ✅ |
| `CLOSURE_REPORT_DOC` | HTML | id 13 | id 21 | CLOSURE_REPORT | ✅ |
| `MONITORING_REPORT_DOC` | HTML | id 22 | id 23 | MONITORING_REPORT | ✅ |
| `PROGRESS_REPORT_DOC` | HTML | id 26 | id 27 | MONITORING_REPORT | ⚠️ category mismatch — should be its own (e.g. POST_APPROVAL) |
| `MEETING_MINUTES_DOC` | HTML | id 24 | id 25 | MEETING_DOCUMENT | ✅ |

**Legacy / dead templates (no code path, `is_active=true` but unused):**

| template_code | type | Notes | Verdict |
|---|---|---|---|
| `APPROVAL_CERTIFICATE_V1` | PDF | superseded by certificate subsystem + engine | **Replace** (align to new engine; keep serial compat) |
| `IRB_APPROVAL_LETTER` | PDF | plain-text Handlebars, dead | **Replace** |
| `REVIEW_FORM` | PDF | plain-text Handlebars, dead (distinct from `REVIEW_FORM_DOC`) | **Remove** |
| `ICF_TEMPLATE` | HTML | raw text consent, no context builder | **Replace** (→ FRM-034 ICF) |
| `SAE_REPORT` | HTML | dead, superseded by `SAFETY_REPORT_DOC` | **Remove** |
| `ANNUAL_PROGRESS` | PDF | dead, superseded by `PROGRESS_REPORT_DOC` | **Remove** |
| `SMOKE_TEST` | TEXT | inactive | **Remove** |

### 3.3 Legacy relational forms — `committee.review_forms` + `review_questions`

Live DB contains **17 rows, all `INTG_TEST_<timestamp>` integration-test junk** (each with 3 TEXT/SCALE/BOOLEAN questions). The original real forms (`SCI_REVIEW_V1`, `ETH_REVIEW_V1`, `NCBE-YE-STD-001` from seeds `08-reviews.sql`/`95-pilot-dataset.sql`) are **no longer present** in the database.

**Verdict: Remove.** The legacy questionnaire system (flat question lists, no sections/conditional/scoring/bilingual) is fully superseded by `forms.form_definitions`. Integration-test rows must be deleted as part of migration. The `/api/v1/committee/reviews/forms` routes + `ReviewFormsPage` stay only if the legacy `review_forms` module still backs another workflow; otherwise retire the routes too (verify before removal).

### 3.4 Working pipelines (post-implementation)

- **Document engine:** `DocumentRenderService` (Handlebars → Chrome → PDF; official wrapper: header/logo/number/QR/version/issue date/signatures/seal/footer/page numbers). Templates looked up by `(template_code, language)` honoring `is_default`/`is_active`.
- **Lifecycle (documents.documents):** DB CHECK = `OFFICIAL / REVOKED / VOID / SUPERSEDED`. `POST /documents/:id/lifecycle` (REVOKED|VOID only from OFFICIAL), `POST /documents/:id/sign`, `POST /instances/:id/generate`, `/documents/:id/download`, `/instances/:id/documents`.
- **Immutability:** BEFORE UPDATE/DELETE trigger `trg_documents_immutable` blocks checksum mutation & physical delete (soft-delete only); verified E2E.
- **Versioning/supersession:** `POST /documents/templates/:id/new-version`, `:id/set-default`; supersession chain v1→v2; public verify reports successor.
- **Public verification:** `GET /api/v1/public/verify/:ref` → `VALID|REVOKED|VOID|SUPERSEDED|NOT_FOUND|ERROR`; VerifyPage renders AR/EN status + revocation reason.
- **Numbering:** `documents.document_numbering` (category, year, prefix, last_seq) with advisory-lock atomic allocation.
- **Frontend:** `FormLibraryPage` (list definitions), `FormFillPage` (fill + autosave + submit + DocumentPanel), `DocumentPanel` (documents per instance: generate/download/detail/sign/revoke). VerifyPage. All query keys numeric-consistent (BIGINT → `Number()`).

### 3.5 Known defects / gaps found during audit

| # | Defect | Location | Severity |
|---|---|---|---|
| 1 | `SchemaForm` missing field types (`email`, `tel`, `file`, `checkbox`), no `default`/`placeholder`, no server-side schema→Zod validation | `SchemaForm.tsx`, `form.service.ts` | High |
| 2 | No computed/calculated fields despite `computed` block in docs (SCI total_score is not materialized) | `06-json-schemas.md` vs engine | High |
| 3 | `PROGRESS_REPORT_DOC` mis-categorized under MONITORING_REPORT | templates table | Low |
| 4 | Only 8/37–50 planned forms seeded; FRM-004/006/007/008/009/010/012/013/014/016/017/019/020/021/022/023/026/027/029/030/031/033/034/035/036/037 missing | seed | — (scope) |
| 5 | `documents.templates` has no RLS policies (consistent w/ v1 audit; acceptable for templates, but document it) | seed 57 | Low |
| 6 | Legacy `INTG_TEST_*` rows pollute `committee.review_forms` | live DB | Low |
| 7 | Single-signature only; task requires **multiple** digital signatures (Reviewer/Secretary/Chair/Inst.Rep) | `signDocument` | High |
| 8 | Verification lacks checksum comparison endpoint (`POST /api/documents/checksum`) | public routes | High (new feature) |
| 9 | No watermark rendering (DRAFT/COPY/VOID/SUPERSEDED/REVOKED/EXPIRED) in PDFs | engine | High (new feature) |
| 10 | Lifecycle lacks EXPIRED (documents CHECK has no EXPIRED; task requires Draft→…→Archived incl. EXPIRED) | DB CHECK | High (new feature) |
| 11 | Public `documents.documents` for form-linked docs has legacy doc 1057 (null number, no template_code) | live DB | Low |

---

## 4. Per-Form Verdict Matrix (Keep / Refactor / Merge / Split / Replace / Remove)

### 4.1 Existing schema-driven forms (`forms.form_definitions`)

| form_code | Current Category | Verdict | Required action |
|---|---|---|---|
| `ADMIN_SCREENING` | SCREENING | **Refactor** | Keep structure; add missing fields per FRM-002 spec (exempt outcome, required-docs linkage); target category **General** |
| `SCI_REVIEW_PRIMARY` | REVIEW | **Refactor** | Keep; materialize `total_score`, add reviewer sign-off block, map to target category **Review** |
| `ETH_REVIEW` | REVIEW | **Refactor** | Keep; deepen ethics sections (consent, vulnerable, privacy, risk/benefit), category **Review** |
| `ANNUAL_PROGRESS` | POST_APPROVAL | **Refactor** | Keep; add enrollment/outcomes/AE fields per FRM-024; category **Study Monitoring** (continuing review) |
| `SAE_REPORT` | SAFETY | **Refactor** | Keep; add reporting-timeline & causality per FRM-025; category **Study Monitoring** |
| `SITE_MONITORING` | MONITORING | **Refactor** | Keep; category **Study Monitoring** |
| `STUDY_CLOSURE` | CLOSURE | **Refactor** | Keep; category **Study Monitoring** |
| `COMM_MINUTES` | MEETING | **Refactor** | Keep; add docket/decision/voting blocks; category **Committee** |

### 4.2 Forms to CREATE (from `01-forms-catalog.md` v1 + task gaps) — classified by task categories

| Target Category | Forms to create |
|---|---|
| **General** | FRM-001 Application/Protocol (INTERACTIVE+OFFICIAL), FRM-009 Exemption, FRM-035 Document Receipt, FRM-037 Appeal |
| **Review** | FRM-004 Secondary Scientific, FRM-006 Statistical, FRM-007 Legal, FRM-008 Expedited, FRM-022 Amendment Request, FRM-023 Amendment Review, FRM-003/005 review refinements (above) |
| **Committee** | FRM-010 Agenda, FRM-011 Attendance, FRM-012 COI Declaration, FRM-013 Confidentiality, FRM-015 Minutes (from COMM_MINUTES), FRM-016 Voting Record, FRM-017 Decision Record |
| **Official Documents** | FRM-014 Researcher Declaration, FRM-018 Approval Certificate, FRM-019 Conditional Approval, FRM-020 Rejection Letter, FRM-021 Deferral Letter, FRM-024 Continuing Review (from ANNUAL_PROGRESS), FRM-025 SAE (from SAE_REPORT), FRM-026 Deviation, FRM-027 Non-compliance, FRM-030 Suspension Notice, FRM-031 Termination Notice, FRM-032 Study Closure (from STUDY_CLOSURE), FRM-033 Final Report, FRM-034 ICF |
| **Study Monitoring** | FRM-028 Site Monitoring (from SITE_MONITORING), FRM-029 Inspection Report |
| **Participant** | FRM-036 Participant Complaint, participant-facing PIS/consent documents, FRM-034 assent variant |

### 4.3 Templates verdict

| template_code | Verdict | Action |
|---|---|---|
| `DECISION_LETTER` (ar/en) | **Keep** | reuse for FRM-019/020/021 |
| `REVIEW_FORM_DOC` (ar/en) | **Keep** | reuse for all review forms |
| `SAFETY_REPORT_DOC` (ar/en) | **Keep** | reuse for FRM-025/026/027 |
| `MONITORING_REPORT_DOC` (ar/en) | **Keep** | reuse for FRM-028/029 |
| `PROGRESS_REPORT_DOC` (ar/en) | **Refactor** | re-categorize (POST_APPROVAL), reuse for FRM-024 |
| `CLOSURE_REPORT_DOC` (ar/en) | **Keep** | reuse for FRM-032/033 |
| `MEETING_MINUTES_DOC` (ar/en) | **Keep** | reuse for FRM-015/016/017 |
| `APPROVAL_CERTIFICATE_V1` | **Replace** | align certificate to engine; keep serial compatibility |
| `IRB_APPROVAL_LETTER` | **Replace** | → `DECISION_LETTER` variant |
| `ICF_TEMPLATE` | **Replace** | → production consent document template |
| `REVIEW_FORM` | **Remove** | dead |
| `SAE_REPORT` | **Remove** | dead |
| `ANNUAL_PROGRESS` | **Remove** | dead |
| `SMOKE_TEST` | **Remove** | dead |

### 4.4 Legacy artifacts verdict

| Artifact | Verdict | Action |
|---|---|---|
| `committee.review_forms` (INTG_TEST_* rows) | **Remove** | delete rows; confirm no code depends on them |
| `committee.review_questions` (legacy) | **Remove** | superseded |
| `/api/v1/committee/reviews/forms` routes + ReviewFormsPage | **Remove/Merge** | retire unless verified in-use; migrate Qs into JSON schemas |
| `documents.generated_documents`, `document_versions`, `document_approvals`, `document_audit` | **Keep** (activated) | continue engine writes |

---

## 5. Gap Analysis (Required ~50 forms vs. Current)

| Task category | Required | Current | Gap |
|---|---|---|---|
| General | ~8 | 0 | FRM-001/009/035/037 + receipt + appeals + protocol |
| Review | ~10 | 3 (SCI/ETH + legacy) | FRM-004/006/007/008/022/023 + scoring |
| Committee | ~8 | 1 (COMM_MINUTES) | FRM-010/011/012/013/016/017 |
| Official Documents | ~14 | 7 templates (docs) + certificates | letters, notices, declarations, ICF |
| Study Monitoring | ~6 | 3 (progress/SAE/site/closure) | deviation, non-compliance, inspection, final |
| Participant | ~4 | 0 | complaint, PIS, assent, participant notices |

**Required before adding forms (task-mandated features):**
1. Multiple digital signatures (multi-signatory documents).
2. `POST /api/documents/checksum` verification API (VALID/INVALID/MODIFIED).
3. Full verification portal (reference, status, versions, checksum, signatures, supersession, revocation, audit timeline).
4. Watermark rendering (DRAFT/COPY/VOID/SUPERSEDED/REVOKED/EXPIRED).
5. Expanded document lifecycle: `DRAFT → PENDING_SIGNATURE → APPROVED → ISSUED → SUPERSEDED → REVOKED → EXPIRED → ARCHIVED` (DB CHECK must grow from `OFFICIAL/REVOKED/VOID/SUPERSEDED`).

---

## 6. Redesign Directives (updated)

1. **Extend the renderer** (`SchemaForm.tsx`): add `email`, `tel`, `file`, `checkbox`, `placeholder`, `default`, `multiline`; support `computed`/calculated fields; wire server-side validation (Zod-from-schema) into `form.service`.
2. **Generalize signing** to multi-signature roles (Reviewer/Secretary/Chair/Institutional Representative) on one document.
3. **Implement the 5 mandatory features** (multi-signature, checksum API, verification portal, watermarks, lifecycle expansion) **before** creating the remaining forms.
4. **Re-categorize** forms/templates into the task's 6 categories (General/Review/Committee/Official Documents/Study Monitoring/Participant).
5. **Build the ~42 missing forms** as JSON schemas + reused official templates; every form gets an INTERACTIVE instance + (where official) an OFFICIAL generated document. No standalone forms, no duplicated generation logic, no bypassed lifecycle.
6. **Clean legacy**: drop INTG_TEST_* rows, retire dead templates (`REVIEW_FORM`, `SAE_REPORT`, `ANNUAL_PROGRESS`, `SMOKE_TEST`), align certificate subsystem to the engine.

See `01-forms-catalog.md`, `08-ui-specs.md`, `09-api-specs.md`, `10-document-template-specs.md`, and the revised data dictionary / PDF spec / DB mapping / JSON schemas / migration roadmap in this folder.
