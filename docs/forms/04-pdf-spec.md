# ERM-System Forms Library — PDF Specification & Template Variables (v1)

> Version 1.0 · 2026-08-01
> The authoritative specification for all official printed documents produced by the backend Document Engine. Every official PDF must comply with this spec.

---

## 1. Rendering Stack (Backend-Only)

| Layer | Technology | Notes |
|---|---|---|
| Template | Handlebars (HTML) | Single source of truth in `documents.templates` |
| Rendering | `puppeteer-core` + system Chrome | `page.setContent(html, {waitUntil:'load'})` |
| PDF | Chrome `page.pdf()` | A4, 20mm margins, `printBackground: true`, `preferCSSPageSize` |
| QR | `qrcode` | `toDataURL`, error correction M, 256px, margin 2 |
| Checksum | SHA-256 | Immutability + verification |
| Fonts | Noto Sans Arabic (self-hosted) | Must be bundled in Docker image |

**PDF/A note:** where full PDF/A conformance is required, post-process with a PDF/A converter (e.g., Ghostscript `-dPDFA=2`) at deploy time; the engine marks `pdfa_conformance: 'PDF/A-2b' | 'none'` in metadata based on configuration.

## 2. Official Document Anatomy (every document)

```
┌──────────────────────────────────────────────────────────────┐
│ PAGE 1                                                        │
│ ┌─ OFFICIAL HEADER (branding band) ────────────────────────┐ │
│ │ [Institution/Committee logo]   [Ministry name AR + EN]   │ │
│ │ Committee / Authority name (AR) + (EN)                   │ │
│ │ Address line · Phone · Email                             │ │
│ ├──────────────────────────────────────────────────────────┤ │
│ │ Reference No: DEC-APP-2026-…    Date: 2026-08-01         │ │
│ │ Version: 1.0    Classification: OFFICIAL   [QR]          │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                              │
│  Document title (AR)                                          │
│  Document title (EN)                                          │
│                                                              │
│  Body — sections, tables, decisions, conditions              │
│                                                              │
│ ┌─ SIGNATURE & SEAL BLOCK ─────────────────────────────────┐ │
│ │ [Signature line 1]        [Signature line 2]             │ │
│ │ Chairperson               Institutional Representative   │ │
│ │ (Signed: <name>, <date>)  (Digital seal)                 │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                              │
│ ┌─ FOOTER ────────────────────────────────────────────────┐ │
│ │ Confidentiality notice · Verify: <verify-url> · Page 1/N │ │
│ └─────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
```

### Mandatory blocks (all official documents)

| Block | Content | Requirement |
|---|---|---|
| **Official Header** | Logo, institution/committee name (AR+EN), ministry/authority name, contact line | Always present, page 1 |
| **Document Number** | Reference number from numbering register | Unique, top-right (RTL: left) |
| **Unique Identifier** | UUID stored in `generated_documents.uuid` | Hidden in metadata, printed as QR |
| **QR Code** | URL: `https://ethics.erc.gov.sa/verify/<doc-uuid>` | Page 1 + last page for multi-page |
| **Version** | `v<version_no>` + schema version | Header |
| **Issue Date** | Gregorian + Hijri (ar) / Gregorian (en) | Header |
| **Revision Date** | If revised | Header |
| **Approval Status** | `OFFICIAL` / `DRAFT` / `VOID` / `REVOKED` | Watermark when not OFFICIAL |
| **Electronic Signature** | Signer name + role + timestamp + hash | Signature block |
| **Digital Seal** | Authority seal image + cert reference | Signature block |
| **Footer** | Confidentiality notice, verify URL, page `n/N` | Every page |
| **Confidentiality Notice** | "This document is confidential and intended solely for the addressee…" (AR + EN) | Footer |
| **Page numbering** | `page n of N` via CSS `counter(page)` / puppeteer footer | Every page |

## 3. CSS Framework for Templates

Templates use a shared **document shell** (handled by the engine wrapper) + per-document body. The shell CSS is injected by the engine and defines:

```css
@page { size: A4; margin: 20mm; }
@page { @bottom-center { content: "Page " counter(page) " of " counter(pages); } } /* via footer template */
.header-branding { display:flex; justify-content:space-between; border-bottom:2px solid #1a5c2a; }
.document-meta { display:grid; grid-template-columns: 1fr auto; }
.qr-cell img { width: 96px; height: 96px; }
.signature-block { display:grid; grid-template-columns: 1fr 1fr; margin-top: 24mm; }
.confidential-footer { font-size: 9px; color: #777; border-top: 1px solid #ccc; }
```

The engine renders a **wrapper template** with three parts:
1. `header` (branding + meta + QR)
2. `body` (the document-specific template compiled with the data context)
3. `footer` (confidentiality + page numbers via Chrome footer template)

## 4. Template Context Contract

Every document template receives a **standard context** merged with document-specific variables:

| Variable | Type | Always? | Description |
|---|---|---|---|
| `documentNumber` | string | ✅ | reference number |
| `documentUuid` | string | ✅ | unique identifier |
| `documentTitle` | {ar,en} | ✅ | |
| `documentVersion` | string | ✅ | template version |
| `issueDateAr` / `issueDateEn` | string | ✅ | |
| `revisionDateAr/En` | string | when revised | |
| `status` | string | ✅ | OFFICIAL/DRAFT/VOID/REVOKED |
| `qrCodeDataUrl` | string | ✅ | base64 PNG |
| `verifyUrl` | string | ✅ | |
| `issuingAuthorityAr/En` | string | ✅ | |
| `institutionNameAr/En` | string | ✅ | |
| `committeeNameAr/En` | string | ✅ | |
| `logoDataUrl` | string | optional | base64 logo |
| `sealDataUrl` | string | optional | base64 digital seal |
| `signatories` | array | ✅ | [{nameAr, nameEn, roleAr, roleEn, signedAt, hash}] |
| `lang` | 'ar'\|'en' | ✅ | current render language |
| `dir` | 'rtl'\|'ltr' | ✅ | |
| `confidentialityAr/En` | string | ✅ | notice text |
| `conditions` | array | when applicable | [{text, category}] |
| `applicationNumber` | string | when linked | |
| `applicationStatus` | string | when linked | |
| `projectTitleAr/En` | string | when linked | |
| `researcherName` | string | when linked | |
| `sections` | array | when form-linked | [{title, rows:[{label, value}]}] — serialized form responses |

**Form-linked documents:** when a document is generated from a submitted form instance, `sections` is produced by a serializer that maps `form_schema` sections/fields → labelled table rows (bilingual). This is what lets 37 different forms reuse one rendering path.

## 5. Template Variables — Per Document Class

| Class | Extra variables |
|---|---|
| `DECISION_LETTER` | `letterType` (CONDITIONAL/REJECT/DEFER), `decisionSummary`, `conditions[]`, `appealNotice` |
| `REVIEW_FORM` | `reviewerName`, `reviewDate`, `totalScore`, `recommendation`, `justification`, `sections` |
| `CERTIFICATE` | `serialNumber`, `expiryDate`, `approvalStatement` (kept from existing impl) |
| `SAFETY_REPORT` | `saeReportNumber`, `eventDate`, `eventType`, `severity`, `relationship`, `expectedness`, `participantOutcome`, `actionTaken` |
| `MINUTES` | `meetingRef`, `meetingDate`, `chair`, `quorum`, `attendance`, `docket[]` |
| `CONSENT` | `studyTitle`, `piName`, `institution`, `consentSections[]`, `participantRights`, `contactInfo` |
| `NOTICE` (suspension/termination) | `noticeType`, `effectiveDate`, `reason`, `requiredActions`, `reinstatementPath` |
| `CLOSURE` | `finalEnrollment`, `completionDate`, `dataRetention`, `archiveLocation` |

## 6. Immutability & Verification

1. **Checksum:** `sha256(pdfBytes)` stored in `documents.documents.checksum_sha256` + `document_versions.checksum_sha256`.
2. **Verification endpoint:** `GET /api/v1/public/verify/:uuid` returns document metadata + status + checksum (public, rate-limited). QR links here.
3. **Tamper evidence:** the engine can embed a signed attribute (serial+uuid+checksum+HMAC with the same secret used by certificates) in the footer — see `07-migration-roadmap.md` for the hardening step.
4. **No regeneration of same reference:** if regeneration is requested, a new version/instance is created; the original PDF file is never overwritten.
