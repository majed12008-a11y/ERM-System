# ERM-System Forms Library — API Specifications (v2)

> Version 2.0 · 2026-08-02 · Status: Approved
> Complete REST API contract for the Forms Library + Official Documents engine. Current endpoints verified against `backend/src/modules/forms/forms.routes.ts`, `backend/src/modules/public/documents.routes.ts`, and `frontend/src/api/forms.ts`. New endpoints for the five mandatory features (multi-signature, checksum, verification portal, watermarks, lifecycle) are marked **[NEW]**.

Base URL: `/api/v1` · Auth: Bearer JWT except `/public/*` · Response envelope: `{ success, data, message? }` · Errors: `{ success:false, error }` (+ `validationErrors[]` on 400).

---

## 1. Form Definitions

| Method | Path | Auth | Body | Returns | Status |
|---|---|---|---|---|---|
| GET | `/forms` | ✅ | — | `FormDefinition[]` | ✅ |
| GET | `/forms/categories` | ✅ | — | `string[]` (categories) | ✅ |
| GET | `/forms/definitions/:code` | ✅ | — | `FormDefinition` | ✅ |
| POST | `/forms/definitions` | admin | `{form_code, form_name_ar, form_name_en, category, workflow_stage, version_no, schema_version, form_schema, renderer, is_active}` | `FormDefinition` | 🔴 NEW |
| POST | `/forms/definitions/:id/new-version` | admin | `{form_schema}` | new version, old deactivated | 🔴 NEW |

**`FormDefinition`** (`forms.form_definitions`): `{id, form_code, form_name_ar, form_name_en, category, workflow_stage, version_no, schema_version, form_schema{formCode, version, sections[], computed?}, renderer, is_active}`.

---

## 2. Form Instances

| Method | Path | Auth | Body | Returns | Status |
|---|---|---|---|---|---|
| GET | `/forms/instances` | ✅ | pagination | `{items, page, limit, total}` | ✅ |
| GET | `/forms/instances/entity/:entityType/:entityId` | ✅ | — | `FormInstance[]` | ✅ |
| GET | `/forms/instances/:id` | ✅ | — | `{instance, definition}` | ✅ |
| POST | `/forms/instances` | ✅ | `{form_code, entity_type, entity_id}` | `FormInstance` (DRAFT) | ✅ |
| PUT | `/forms/instances/:id` | ✅ | `{responses}` | `FormInstance` (draft save) | ✅ |
| POST | `/forms/instances/:id/submit` | ✅ | `{responses}` | `FormInstance` (SUBMITTED; server validates + computes `total_score`) | ✅ |
| POST | `/forms/instances/:id/approve` | chair/admin | — | `FormInstance` (APPROVED) | ✅ |
| POST | `/forms/instances/:id/return` | ✅ | — | `FormInstance` (RETURNED) | ✅ |
| POST | `/forms/instances/:id/void` | ✅ | — | `FormInstance` (VOID) | ✅ |

**`FormInstance`**: `{id, form_definition_id, entity_type, entity_id, status: DRAFT|SUBMITTED|RETURNED|APPROVED|VOID, responses, total_score, recommendation, submitted_by/at, approved_by/at, created_by/at, updated_at}`.

**Lifecycle contract:** `DRAFT/RETURNED` editable; `SUBMITTED` immutable responses; `APPROVED` locked; `VOID` terminal. Server-side Zod validation generated from stored `form_schema` at submit → 400 with `validationErrors[]`.

---

## 3. Generated Documents (per instance)

| Method | Path | Auth | Body | Returns | Status |
|---|---|---|---|---|---|
| POST | `/forms/instances/:id/generate` | ✅ | `{language?, templateCode?, signatories?: [{name, role}], context?}` | `GeneratedDocument` | ✅ |
| GET | `/forms/instances/:id/documents` | ✅ | — | `GeneratedDocumentRecord[]` | ✅ |
| GET | `/forms/documents/:id` | ✅ | — | `DocumentDetail` (doc + versions + audit + signatures) | ✅ |
| GET | `/forms/documents/:id/download` | ✅ | — | PDF blob (`Content-Disposition`) | ✅ |
| POST | `/forms/documents/:id/sign` | ✅ | `{signature_type}` | `DocumentSignature` | ✅ |
| POST | `/forms/documents/:id/lifecycle` | admin | `{status: 'REVOKED'|'VOID', reason}` | `{ok, documentId, status}` | ✅ |

**`GeneratedDocumentRecord`** (documents.documents): `{id, document_type_id, entity_type, entity_id, document_title, file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by/at, document_number, document_uuid, status, is_immutable, current_version_no, template_code, template_version, language, supersedes_version_no, superseded_by_document_id, revoked_at/by, revocation_reason, version_count, signature_count, audit_count}`.

**`DocumentDetail`**: `{document, versions[], audit[], signatures[]}`.

### 3.1 [NEW] Multi-signature signing
| Method | Path | Auth | Body | Returns |
|---|---|---|---|---|
| POST | `/forms/documents/:id/sign` | ✅ | `{signature_type: 'REVIEWER'|'SECRETARY'|'CHAIR'|'INSTITUTIONAL_REPRESENTATIVE'|'APPLICANT'|'APPROVER'}` | updated doc (one signature added) |
| GET | `/forms/documents/:id/signatures` | ✅ | — | `DocumentSignature[]` |

Enforced: each `(document_id, signer_id, signature_type)` unique; signing allowed while status in `ISSUED` (or configured gate); every signer must have role + permission. Renderer `SignatureBlock` displays all signatories.

---

## 4. Templates (admin)

| Method | Path | Auth | Body | Returns | Status |
|---|---|---|---|---|---|
| GET | `/documents/templates` | ✅ | — | template list (code, language, version, is_default, is_active) | ✅ |
| POST | `/documents/templates/:id/new-version` | admin | `{content}` | new version (old deactivated, default carried) | ✅ |
| POST | `/documents/templates/:id/set-default` | admin | — | marks default for `(code, language)` | ✅ |
| GET | `/documents/templates/:code/:lang/active` | ✅ | — | active/default template for rendering | ✅ |

---

## 5. Public Verification

| Method | Path | Auth | Body | Returns | Status |
|---|---|---|---|---|---|
| GET | `/public/verify/:reference` | public (rate-limited) | — | document metadata + status | ✅ |
| POST | `/public/checksum` | public | multipart: PDF file | `{result: 'VALID'|'INVALID'|'MODIFIED', checksum, docNumber, status}` | 🔴 NEW |

**Verify response** (`fn_verify_generated_document`): reference, title, status (`VALID|REVOKED|VOID|SUPERSEDED|NOT_FOUND|ERROR`), version_no, template_code, language, checksum_sha256, issued/revoked dates, signatures, superseded_by link, audit timeline.

**Checksum algorithm:** server recomputes `sha256(uploadedBytes)` and compares to `documents.checksum_sha256`; also verifies length mismatch (`MODIFIED` if bytes differ but header matched, `INVALID` if no match / no doc).

---

## 6. Documents Engine (direct module) — current surface

Existing `documents` module routes (admin upload/download, application documents, evidence) are unchanged and continue to serve non-generated documents. Generated official documents go through `/forms/*` + `/public/*`.

---

## 7. [NEW] Lifecycle status model (target)

`documents.documents.status` CHECK grows to:

```
DRAFT → PENDING_SIGNATURE → APPROVED → ISSUED → SUPERSEDED → REVOKED → EXPIRED → ARCHIVED
                                                    ↘ VOID (admin)
```

| Transition | Allowed from | Role | Endpoint |
|---|---|---|---|
| PENDING_SIGNATURE | DRAFT (after generate) | engine | (engine) |
| APPROVED | PENDING_SIGNATURE | chair | `POST /documents/:id/approve` [NEW] |
| ISSUED | APPROVED | engine/coordinator | (engine) |
| SUPERSEDED | ISSUED | engine (new-version) | ✅ existing |
| REVOKED | ISSUED | admin | `POST /documents/:id/lifecycle` |
| VOID | ISSUED/DRAFT | admin | `POST /documents/:id/lifecycle` |
| EXPIRED | ISSUED | engine (date-driven) | scheduler [NEW] |
| ARCHIVED | EXPIRED/CLOSED | admin | `POST /documents/:id/lifecycle` [NEW] |

**Watermarks** derived from status at render: `DRAFT`/`COPY` (non-default versions) /`VOID`/`SUPERSEDED`/`REVOKED`/`EXPIRED` — rendered diagonally by the engine when status ≠ OFFICIAL(default). Response of generate includes `watermark`.

---

## 8. Response envelope & error conventions

```json
{ "success": true, "data": { } }
{ "success": false, "error": "message", "validationErrors": ["field x required"] }
```

- Pagination: `GET /forms/instances?page=1&limit=20` → `{items, page, limit, total}`.
- BIGINT ids returned as strings by node-postgres → frontend wraps `Number(...)` before use in query keys.
- All mutations write `documents.document_audit` + `audit.audit_logs` (trigger) rows.
