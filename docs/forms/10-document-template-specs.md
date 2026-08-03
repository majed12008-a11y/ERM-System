# ERM-System Forms Library — Document Template Specifications (v2)

> Version 2.0 · 2026-08-02 · Status: Approved
> Specifies the official document template system: registry, anatomy, template context, per-class variables, watermarking, signatures, and the reuse path for all OFFICIAL forms in the catalog. Builds on the live template set (22 rows in `documents.templates`) and the engine.

---

## 1. Template Registry (live state + target)

Table: `documents.templates` (columns: `template_code, template_name, template_type, template_content, version_no, is_active, language, document_category, is_default, schema_metadata`).

### 1.1 Production templates (engine-wired, ar+en)

| template_code | category | ar id | en id | Used by forms |
|---|---|---|---|---|
| `DECISION_LETTER` | OFFICIAL_LETTER | 9 | 15 | FRM-019/020/021/042/043/044/050 |
| `REVIEW_FORM_DOC` | REVIEW_FORM | 11 | 19 | FRM-003/004/005/006/007/008/048 |
| `SAFETY_REPORT_DOC` | SAFETY_REPORT | 12 | 20 | FRM-025/026/027 |
| `CLOSURE_REPORT_DOC` | CLOSURE_REPORT | 13 | 21 | FRM-032/033 |
| `MONITORING_REPORT_DOC` | MONITORING_REPORT | 22 | 23 | FRM-028/029 |
| `PROGRESS_REPORT_DOC` | MONITORING_REPORT ⚠️ | 26 | 27 | FRM-024 (re-categorize → POST_APPROVAL) |
| `MEETING_MINUTES_DOC` | MEETING_DOCUMENT | 24 | 25 | FRM-015/016/017 |

### 1.2 Legacy/dead templates (verdicts from audit)

| template_code | type | Verdict |
|---|---|---|
| `APPROVAL_CERTIFICATE_V1` | PDF | **Replace** → engine-aligned certificate |
| `IRB_APPROVAL_LETTER` | PDF | **Replace** → `DECISION_LETTER` variant |
| `ICF_TEMPLATE` | HTML | **Replace** → `CONSENT_DOCUMENT` |
| `REVIEW_FORM` | PDF | **Remove** |
| `SAE_REPORT` | HTML | **Remove** |
| `ANNUAL_PROGRESS` | PDF | **Remove** |
| `SMOKE_TEST` | TEXT | **Remove** |

### 1.3 Target new templates

| template_code | category | Forms | Priority |
|---|---|---|---|
| `CONSENT_DOCUMENT` | CONSENT | FRM-034/038/039 | P6 |
| `PIS_DOCUMENT` | CONSENT | FRM-038 | P6 |
| `ASSENT_DOCUMENT` | CONSENT | FRM-039 | P6 |
| `APPLICATION_DOC` | APPLICATION | FRM-001 | P5 |
| `RECEIPT_DOC` | COMMUNICATION | FRM-035 | P5 |
| `NOTICE_DOC` | NOTICE | FRM-030/031/040/041/045/046 | P4/P6 |
| `CERTIFICATE_DOC` | CERTIFICATE | FRM-018 | P4 |
| `DECLARATION_DOC` | DECLARATION | FRM-014/012/013 | P3/P4 |

All templates: `template_type=HTML`, `is_active=true`, exactly one `is_default=true` per `(template_code, language)` (enforced by partial unique index `uq_templates_default`).

---

## 2. Official Document Anatomy (engine wrapper)

Every generated PDF = wrapper (engine) + body (template). Blocks:

| Block | Content | Requirement |
|---|---|---|
| Official Header | logo, institution/committee name (AR+EN), ministry/authority, contact line | page 1 |
| Document Number | from `documents.document_numbering` | unique |
| QR | `https://ethics.erc.gov.sa/verify/<ref>` | page 1 + last page |
| Version | `v<version_no>` + schema version | header |
| Issue Date | Gregorian (+Hijri for ar) | header |
| Watermark | derived from status (see §4) | when non-default |
| Signature block | multi-signatory: name, role, timestamp, hash | all official |
| Digital seal | seal image + cert reference | certificates/letters |
| Footer | confidentiality notice, verify URL, page n/N | every page |

Shared CSS: `@page A4 20mm`, `.header-branding`, `.document-meta`, `.qr-cell`, `.signature-block` (grid, 1 per signatory), `.confidential-footer`, `.watermark` (diagonal, `position:fixed`, `opacity:0.12`, `font-size:120px`).

---

## 3. Template Context Contract

Standard context merged for every render (from `04-pdf-spec.md`, extended):

| Variable | Type | Always | Description |
|---|---|---|---|
| `documentNumber` | string | ✅ | reference number |
| `documentUuid` | string | ✅ | unique id (QR) |
| `documentTitle` | {ar,en} | ✅ | |
| `documentVersion` | string | ✅ | |
| `issueDateAr/En` | string | ✅ | |
| `revisionDateAr/En` | string | when revised | |
| `status` | string | ✅ | OFFICIAL/DRAFT/VOID/SUPERSEDED/REVOKED/EXPIRED |
| `watermark` | string | ✅ | rendered label for non-default statuses (else "") |
| `qrCodeDataUrl` | string | ✅ | |
| `verifyUrl` | string | ✅ | |
| `issuingAuthorityAr/En`, `institutionNameAr/En`, `committeeNameAr/En` | string | ✅ | |
| `logoDataUrl`, `sealDataUrl` | string | optional | |
| `signatories` | array | ✅ | `[{nameAr,nameEn,roleAr,roleEn,signedAt,hash,status}]` — multi-signature |
| `lang` | 'ar'\|'en' | ✅ | |
| `dir` | 'rtl'\|'ltr' | ✅ | |
| `confidentialityAr/En` | string | ✅ | |
| `conditions` | array | when applicable | `[{text, category}]` |
| `applicationNumber`, `applicationStatus`, `projectTitleAr/En`, `researcherName` | string | when linked | |
| `sections` | array | when form-linked | `[{title, rows:[{label, value}]}]` serializer output |

**Form-linked documents:** `sections` produced by the serializer mapping `form_schema` sections/fields → bilingual labelled rows. This is what lets all forms reuse one render path.

---

## 4. Watermark Specification [NEW]

Derived at render time from document status + version:

| State | Watermark text (AR/EN) | Trigger |
|---|---|---|
| OFFICIAL + default version | none | normal issue |
| DRAFT | مسودة / DRAFT | generate in DRAFT state |
| REVOKED | ملغاة / REVOKED | lifecycle REVOKED |
| VOID | لاغية / VOID | lifecycle VOID |
| SUPERSEDED | مستبدلة / SUPERSEDED | superseded by newer version |
| EXPIRED | منتهية / EXPIRED | date-driven expiry |
| OFFICIAL + non-default version | نسخة / COPY | reprint of older version |

Implementation: engine injects `.watermark` div with `{{watermark}}` before `page.pdf()`; watermark text passed in context. Never embedded into stored PDF bytes (keeps checksum = canonical OFFICIAL bytes; watermark applied on render).

---

## 5. Per-Class Variables

| Class | Extra variables |
|---|---|
| `DECISION_LETTER` | `letterType` (CONDITIONAL/REJECT/DEFER/INITIATION/RENEWAL/SITE/AMENDMENT), `decisionSummary`, `conditions[]`, `appealNotice` |
| `REVIEW_FORM` | `reviewerName`, `reviewDate`, `totalScore`, `recommendation`, `justification`, `sections` |
| `CERTIFICATE` | `serialNumber`, `expiryDate`, `approvalStatement` (serial back-compat) |
| `SAFETY_REPORT` | `saeReportNumber`, `eventDate`, `eventType`, `severity`, `relationship`, `expectedness`, `participantOutcome`, `actionTaken` |
| `MINUTES` | `meetingRef`, `meetingDate`, `chair`, `quorum`, `attendance`, `docket[]` |
| `CONSENT` | `studyTitle`, `piName`, `institution`, `consentSections[]`, `participantRights`, `contactInfo` |
| `NOTICE` | `noticeType`, `effectiveDate`, `reason`, `requiredActions`, `reinstatementPath` |
| `CLOSURE` | `finalEnrollment`, `completionDate`, `dataRetention`, `archiveLocation` |
| `APPLICATION` | `protocolNumber`, `projectTitle`, `researcherName`, `institution`, `sections` (protocol sections) |
| `DECLARATION` | `declarantName`, `declarationType` (RESEARCHER/COI/CONFIDENTIALITY), `declarationText`, `signatories[]` |

---

## 6. Template Authoring Rules

1. HTML + Handlebars only; `{{ }}` for context vars, `{{#each}}`/`{{#if}}` allowed.
2. `dir="rtl"` on root element for ar; fonts via system/self-hosted Noto Sans Arabic (bundle in Docker).
3. Every template must render without error for empty context (engine guard: missing var → empty string, not throw).
4. `document_category` must match a value in `documents.document_types.code`.
5. `is_default=true` exactly one per `(template_code, language)` among active rows.
6. Templates are soft-deleted only; versions immutable once rendered.
7. All templates bilingual: `template_content` may contain both AR/EN blocks conditioned on `{{lang}}`, or separate rows per language (current convention: separate rows).

---

## 7. Generation Flow (engine)

```
POST /forms/instances/:id/generate {language, templateCode?, signatories?}
  1. validate instance SUBMITTED/APPROVED (BR-002)
  2. resolve template by (template_code, language) active+default
  3. build context: standard + per-class + sections serializer
  4. render Handlebars → wrapper (header/QR/watermark/footer) → page.setContent
  5. page.pdf(A4, 20mm, printBackground) → bytes
  6. sha256(bytes) → checksum
  7. allocate document_number (advisory lock) → documents.documents row
  8. write document_versions + generated_documents + document_audit
  9. return {documentId, documentNumber, versionNo, checksum, ...}
```

Immutability: `trg_documents_immutable` blocks UPDATE of checksum/status tampering and DELETE; only lifecycle endpoints mutate `status`.
