# Documents Module — Vertical Slice Analysis

> Comprehensive architectural and implementation assessment.
> Analysis date: 2026-07-13
> Reference implementation: Applications module

---

## 1. Completion Percentage by Layer

| Layer | Completion | Detail |
|-------|:----------:|--------|
| **Database** | 85% | 15 tables, 21 indexes, RLS on core tables, audit triggers, certificate subsystem. Missing: versioning in app code, centralized storage config. |
| **Backend** | 50% | 9 routes, 9 service methods, 11 repository methods. Missing: download endpoint, get-by-ID, update, pagination on entity query, preview. |
| **OpenAPI** | 70% | 9 endpoints documented. Missing: download, get-by-ID, update endpoints. No request/response examples. |
| **SDK** | 65% | 9 methods (matches backend 1:1). 4 types defined. Missing: download, getById methods. 0 unused methods. |
| **Frontend** | 25% | 3 pages exist. 0 use SDK (11 raw API calls). 0 reusable components. No download, no preview, no pagination, no classification display. |
| **Testing** | 10% | No document-specific unit tests. No integration tests for upload/download/sign flows. |

**Overall Completion: ~51%**

---

## 2. Layer-by-Layer Assessment

### 2.1 Database (85%)

**Strengths:**
- 15 tables covering documents, types, versions, access, signatures, approvals, audit, templates, generated documents, classifications, retention, disposal, certificates, and verification
- 21 indexes including GIN indexes on JSONB columns
- RLS enabled on `documents.documents`, `approval_certificates`, `approval_certificate_documents`, `certificate_verification_log`
- Audit triggers (`system.fn_log_audit()`) on all 15 tables
- `updated_at` triggers on classification and retention tables
- Soft-delete support via `deleted_at`/`deleted_by` columns
- Certificate subsystem with state machine (`certificate_status` domain: DRAFT → GENERATING → ISSUED → REVOKED/SUPERSEDED)
- Public certificate verification via `SECURITY DEFINER` function
- 7 base document types seeded + 11 additional types (Yemen data)

**Gaps:**
- No explicit UPDATE RLS policy on `documents.documents` (relies on DDL-level or implicit behavior)
- `document_versions` table exists but no application code creates version records
- `document_access` table exists but no application code manages access grants
- `document_approvals` table exists but no approval workflow in application code
- `document_retention_rules` and `document_disposal_logs` tables exist but no enforcement logic
- Polymorphic `entity_type`/`entity_id` — no FK enforcement at DB level
- `document_type_id = 11` (MeetingMinutes) is a magic number, not referenced via constant

### 2.2 Backend (50%)

**Routes (9):**

| # | Method | Path | Status |
|---|--------|------|:------:|
| 1 | GET | `/documents` | ✅ |
| 2 | GET | `/documents/types` | ✅ |
| 3 | POST | `/documents` | ✅ |
| 4 | GET | `/documents/classifications` | ✅ |
| 5 | GET | `/documents/entity/:type/:id` | ✅ |
| 6 | DELETE | `/documents/:id` | ✅ |
| 7 | POST | `/documents/:id/sign` | ✅ |
| 8 | GET | `/documents/:id/signatures` | ✅ |
| 9 | GET | `/documents/pending-signatures` | ✅ |
| 10 | **GET** | **`/documents/:id/download`** | ❌ MISSING |
| 11 | **GET** | **`/documents/:id`** | ❌ MISSING |
| 12 | **PUT** | **`/documents/:id`** | ❌ MISSING |

**Service Layer (9 methods):**
- `getAll`, `getTypes`, `getClassifications`, `getByEntity`, `getSignatures`, `getPendingSignatures`, `upload`, `sign`, `softDelete`

**Repository Layer (11 methods):**
- `findAll`, `findById`, `findByEntity`, `create`, `softDelete`, `getTypes`, `getClassifications`, `getSignatures`, `addSignature`, `findSignature`, `getPendingSignatures`

**Upload Pipeline:**
- multer v2.1.1 with disk storage to `uploads/`
- 10MB max file size
- 10 MIME types allowed (PDF, JPEG, PNG, TIFF, DOC, DOCX, XLS, XLSX, TXT)
- Timestamp-prefixed sanitized filenames
- No virus scanning

**Download Pipeline:**
- ❌ **DOES NOT EXIST** — No download endpoint. Files written to disk but cannot be served over HTTP. `uploads/` directory is NOT exposed via `express.static()`.

**Preview Support:**
- ❌ **DOES NOT EXIST** — No inline preview, no thumbnail generation, no PDF viewer.

**Audit Integration:**
- ✅ `system.fn_log_audit()` triggers on all tables
- ✅ `document_audit` table with `action_type`, `action_by`, `action_timestamp`, `source_ip`, `details` JSONB

**Authorization:**
- ✅ RLS via AsyncLocalStorage context propagation
- ✅ INSERT policy: admin unrestricted, regular user must own application
- ✅ SELECT policy: admin OR owner OR document_access match
- ✅ Physical DELETE blocked at DB level

**Validation:**
- ✅ `uploadDocumentSchema` (Zod): validates body fields only
- ✅ `signDocumentSchema` (Zod): validates signature type
- ❌ No entity_type validation (accepts any string)
- ❌ No file type/size validation at Zod level (multer handles MIME only)

### 2.3 OpenAPI (70%)

**Defined (9):** list, upload, types, classifications, getByEntity, delete, sign, signatures, pendingSignatures

**Missing (3):** download, getById, update

**Issues:**
- No request/response examples
- No operationIds on some endpoints
- No file download response schema (`application/octet-stream`)
- No error response schemas

### 2.4 SDK (65%)

**9 methods, all typed:**

| Method | Backend Match | Used in Frontend |
|--------|:------------:|:----------------:|
| `list` | ✅ | ❌ (raw API used) |
| `getTypes` | ✅ | ❌ (raw API used) |
| `upload` | ✅ | ❌ (raw API used) |
| `getClassifications` | ✅ | ❌ (never called) |
| `getByEntity` | ✅ | ❌ (raw API used) |
| `delete` | ✅ | ❌ (raw API used) |
| `sign` | ✅ | ❌ (raw API used) |
| `getSignatures` | ✅ | ❌ (raw API used) |
| `getPendingSignatures` | ✅ | ❌ (never called) |

**0 unused methods.** **0 files import the documents SDK.**

**Types defined:** `Document`, `DocumentSignature`, `DocumentType`, `DocumentClassification`

**Missing types:** `DocumentVersion`, `DocumentAccess`, `DocumentApproval`, `DocumentAudit`, `DocumentClassification` (incomplete — missing `name_en`, `clearance_required`)

### 2.5 Frontend (25%)

**Pages Found (3):**

| Page | SDK Usage | Raw API Calls | Features |
|------|:---------:|:-------------:|----------|
| `DocumentsPage.tsx` | ❌ NONE | 4 (`list`, `types`, `upload`, `delete`) | List, upload dialog, delete. No pagination, no download, no preview, no classification filter. |
| `ESignaturesPage.tsx` | ❌ NONE | 3 (`list`, `sign`, `signatures`) | Lists ALL documents for signing. Does NOT use `getPendingSignatures()`. |
| `Applications/Edit.tsx` | ❌ NONE | 2 (`getByEntity`, `upload`) | Upload during app edit (step 3). Duplicated upload code. |
| `Applications/Detail.tsx` | ❌ NONE | 1 (`getByEntity`) | Read-only document list in card. |
| `Applications/Create.tsx` | ❌ NONE | 1 (`upload`) | Queues files, uploads after app creation. Silent error swallowing. |

**Missing Pages:**
- Document detail page (single document view)
- Document preview page (PDF/image viewer)
- Document version history page
- Document management admin page (types, classifications, retention rules)

**Missing Components:**
- `DocumentUpload` (shared upload component — currently duplicated in 3 places)
- `DocumentPreview` / `FileViewer`
- `DocumentDownload` button/link
- `DocumentCard`
- `DocumentList` (entity-specific)

**Features Missing:**
- ❌ Download functionality (no download endpoint or UI)
- ❌ File preview (no PDF/image viewer)
- ❌ Pagination (SDK supports it, page ignores it)
- ❌ Classification display or filtering
- ❌ Sort-by-type filtering
- ❌ Bulk operations
- ❌ Client-side file type/size validation
- ❌ Reusable upload component
- ❌ Error handling on upload in Create.tsx (`.catch(() => {})`)
- ❌ Type safety (most document data typed as `any`)

**Raw API Calls Requiring SDK Migration (11):**

| File | Calls |
|------|:-----:|
| `DocumentsPage.tsx` | 4 |
| `ESignaturesPage.tsx` | 3 |
| `Applications/Edit.tsx` | 2 |
| `Applications/Detail.tsx` | 1 |
| `Applications/Create.tsx` | 1 |

### 2.6 Testing (10%)

- ❌ No document-specific unit tests
- ❌ No upload pipeline tests
- ❌ No download pipeline tests
- ❌ No signature flow tests
- ❌ No RLS policy tests for document tables
- ❌ No integration tests for document CRUD
- ❌ No E2E tests for upload/download/sign workflow

---

## 3. Gap Analysis

### 3.1 Critical Gaps (Block Release)

| # | Gap | Impact | Layer |
|---|-----|--------|-------|
| C1 | **No download endpoint** — Files uploaded to disk but cannot be served | Users cannot retrieve uploaded documents | Backend |
| C2 | **No download UI** — No button, no link, no flow | Frontend is non-functional for document retrieval | Frontend |
| C3 | **Zero SDK adoption** — 11 raw API calls across 5 files | Violates project standard (Applications/Committees baseline) | Frontend |
| C4 | **No pagination** — DocumentsPage fetches all records | Performance degrades with many documents | Frontend |
| C5 | **No file preview** — No PDF/image viewer | Users cannot preview documents inline | Frontend |

### 3.2 Important Gaps (Should Fix)

| # | Gap | Impact | Layer |
|---|-----|--------|-------|
| I1 | No `GET /:id` endpoint | Cannot fetch single document metadata | Backend |
| I2 | No `PUT /:id` endpoint | Cannot update document metadata after upload | Backend |
| I3 | No document version creation in app code | `document_versions` table unused | Backend |
| I4 | No document access management | `document_access` table unused | Backend |
| I5 | No reusable upload component | Code duplicated in 3 places | Frontend |
| I6 | No classification display/filtering | `getClassifications()` SDK method never called | Frontend |
| I7 | No `getPendingSignatures()` usage | ESignaturesPage lists ALL documents instead | Frontend |
| I8 | Silent error swallowing in Create.tsx | Upload failures invisible to user | Frontend |
| I9 | No file type/size validation on frontend | Users see server errors instead of client-side messages | Frontend |
| I10 | Type safety — most data typed as `any` | Runtime errors not caught at compile time | Frontend |

### 3.3 Nice-to-Have Gaps

| # | Gap | Impact | Layer |
|---|-----|--------|-------|
| N1 | No virus/malware scanning | Security risk for production | Backend |
| N2 | No centralized upload config | Hardcoded paths in 3+ places | Backend |
| N3 | No bulk operations | Cannot upload/delete/sign multiple documents | Both |
| N4 | No document approval workflow | `document_approvals` table unused | Backend |
| N5 | No retention/disposal enforcement | `document_retention_rules` table unused | Backend |
| N6 | No content-disposition headers | Download behavior undefined | Backend |

---

## 4. Missing Functionality

### Backend Missing

| # | Feature | Priority |
|---|---------|:--------:|
| B1 | `GET /documents/:id/download` — serve file content with correct Content-Type | Critical |
| B2 | `GET /documents/:id` — single document metadata | High |
| B3 | `PUT /documents/:id` — update document metadata | Medium |
| B4 | Document version creation on re-upload | Medium |
| B5 | Centralized multer configuration | Low |
| B6 | Entity type validation in Zod schema | Low |
| B7 | Static file serving for `uploads/` directory | Critical |

### Frontend Missing

| # | Feature | Priority |
|---|---------|:--------:|
| F1 | Download button/flow | Critical |
| F2 | SDK migration for all 11 raw API calls | Critical |
| F3 | Pagination on DocumentsPage | High |
| F4 | Reusable `DocumentUpload` component | High |
| F5 | Document preview (PDF/image viewer) | High |
| F6 | File type/size client-side validation | Medium |
| F7 | Classification display and filtering | Medium |
| F8 | `getPendingSignatures()` usage in ESignaturesPage | Medium |
| F9 | Error handling fix in Create.tsx | Medium |
| F10 | Type safety — replace `any` with proper types | Medium |
| F11 | Document detail page | Low |
| F12 | Document version history page | Low |

---

## 5. Technical Debt

| ID | Description | Severity | Effort |
|----|-------------|:--------:|:------:|
| TD-D1 | 11 raw API calls across 5 files (zero SDK adoption) | High | 1 day |
| TD-D2 | Upload code duplicated in DocumentsPage, Edit.tsx, Create.tsx | Medium | 0.5 day |
| TD-D3 | `Applications/Create.tsx` swallows upload errors silently | Medium | 0.5 hour |
| TD-D4 | `document_type_id = 11` magic number in committee.service.ts | Low | 0.5 hour |
| TD-D5 | 3 separate multer configurations (documents, evidence, messages) | Low | 0.5 day |
| TD-D6 | `softDelete` physically deletes files — orphaned DB records | Medium | 0.5 day |
| TD-D7 | Most document data typed as `any` in frontend JSX | Medium | 0.5 day |
| TD-D8 | `document_versions`, `document_access`, `document_approvals` tables exist but unused | Low | Future |
| TD-D9 | No document-specific test coverage | High | 1 day |

---

## 6. Risks

| Risk | Probability | Impact | Mitigation |
|------|:-----------:|:------:|-----------|
| No download endpoint means module is non-functional | **Confirmed** | Critical | Implement download endpoint as Task 1 |
| `softDelete` removes files from disk while DB record persists | **Confirmed** | High | Change to DB-only soft-delete, add cleanup job |
| No preview capability limits utility for PDF-heavy workflows | High | Medium | Implement basic inline preview |
| Upload code duplication increases maintenance burden | **Confirmed** | Medium | Extract shared `DocumentUpload` component |
| `uploads/` directory not served statically — production deployment may not have reverse proxy config | Medium | High | Add explicit Express static middleware |
| No virus scanning on uploads | Medium | High | Add ClamAV or similar in future sprint |
| Polymorphic entity linking has no FK enforcement | Low | Low | Acceptable pattern, document in schema docs |

---

## 7. Recommended Implementation Order

### Phase 1: Backend Foundation (Critical)
1. Add `GET /documents/:id/download` endpoint with `Content-Type` and `Content-Disposition` headers
2. Add `GET /documents/:id` endpoint for single document metadata
3. Serve `uploads/` directory via Express static middleware
4. Fix `softDelete` to not physically remove files

### Phase 2: SDK + Type Alignment
5. Add `download()` and `getById()` methods to SDK
6. Expand `Document` type with missing fields (`document_type_id`, `original_file_name`, `checksum_sha256`, etc.)
7. Expand `DocumentClassification` type with `name_en`, `clearance_required`
8. Regenerate SDK via Orval

### Phase 3: Frontend Core (SDK Migration)
9. Migrate DocumentsPage to SDK
10. Migrate ESignaturesPage to SDK (use `getPendingSignatures()`)
11. Migrate Applications/Edit.tsx to SDK
12. Migrate Applications/Detail.tsx to SDK
13. Migrate Applications/Create.tsx to SDK + fix error handling

### Phase 4: Frontend Features
14. Add download button to DocumentsPage and Applications/Detail.tsx
15. Add pagination to DocumentsPage
16. Extract shared `DocumentUpload` component
17. Add file type/size client-side validation
18. Add classification display and filtering

### Phase 5: Quality
19. Fix all `any` type annotations
20. Add loading/empty/error states to all document views
21. Verify RTL/LTR for Arabic/English
22. Verify accessibility (keyboard, ARIA)
23. Verify responsive layout

### Phase 6: Testing + Exit Review
24. Add backend unit tests for document service/repository
25. Add integration tests for upload/download/sign flow
26. Run full regression suite
27. Complete Exit Review

---

## 8. Vertical Slice Implementation Plan

### Task 1 — Backend Download Endpoint
**Files:** `documents.routes.ts`, `document.service.ts`, `document.repository.ts`
**Changes:**
- Add `GET /:id/download` route with `authenticate` middleware
- Service calls `repo.findById()` to get `storage_path` and `mime_type`
- Use `res.download()` with correct `Content-Type` header
- Add `GET /` static middleware for `uploads/` directory in `index.ts`
- Fix `softDelete` to skip physical file deletion

### Task 2 — Backend Get-By-ID Endpoint
**Files:** `documents.routes.ts`, `document.service.ts`
**Changes:**
- Add `GET /:id` route
- Service delegates to existing `repo.findById()`
- Return single document metadata

### Task 3 — OpenAPI Update
**Files:** `backend/openapi/modules/documents.yaml`
**Changes:**
- Add `GET /documents/{id}` operation
- Add `GET /documents/{id}/download` operation with `application/octet-stream` response
- Add request/response examples for all 11 endpoints
- Add operationIds

### Task 4 — SDK Expansion
**Files:** `frontend/src/sdk/domains/documents.sdk.ts`, `frontend/src/sdk/core/types.ts`
**Changes:**
- Add `getById(id: number)` method
- Add `download(id: number)` method (returns blob/stream)
- Expand `Document` type with: `document_type_id`, `original_file_name`, `checksum_sha256`, `storage_provider`, `is_active`
- Expand `DocumentClassification` type with: `name_en`, `clearance_required`, `description`
- Add `DocumentVersion` type
- Regenerate via Orval

### Task 5 — DocumentsPage SDK Migration + Pagination
**Files:** `frontend/src/pages/Documents/DocumentsPage.tsx`
**Changes:**
- Replace 4 raw API calls with SDK methods
- Add pagination support (pass `page`/`limit` to `documents.list()`)
- Add download button per row
- Add classification filter dropdown
- Add proper error handling with toast notifications
- Fix type annotations (replace `any` with `Document`)

### Task 6 — ESignaturesPage SDK Migration
**Files:** `frontend/src/pages/ESignatures/ESignaturesPage.tsx`
**Changes:**
- Replace 3 raw API calls with SDK methods
- Use `documents.getPendingSignatures()` instead of listing ALL documents
- Add proper loading/empty/error states
- Fix type annotations

### Task 7 — Applications Pages SDK Migration
**Files:** `Applications/Edit.tsx`, `Applications/Detail.tsx`, `Applications/Create.tsx`
**Changes:**
- Replace remaining 4 raw API calls with SDK methods
- Fix silent error swallowing in Create.tsx
- Add proper error handling with toast notifications
- Invalidate query cache after upload

### Task 8 — Shared DocumentUpload Component
**Files:** New `frontend/src/components/DocumentUpload.tsx`
**Changes:**
- Extract upload form into reusable component
- Props: `entityType`, `entityId`, `onUploadSuccess`, `compact?`
- File type/size client-side validation (match backend MIME list + 10MB limit)
- Drag-and-drop support
- Progress indicator
- Replace duplicated code in DocumentsPage, Edit.tsx, Create.tsx

### Task 9 — Document Preview Component
**Files:** New `frontend/src/components/DocumentPreview.tsx`
**Changes:**
- Inline PDF viewer (using iframe or object tag)
- Image preview for JPEG/PNG/TIFF
- Download link as fallback for unsupported types
- Dialog-based preview triggered from document list

### Task 10 — Type Safety + Quality
**Files:** All document frontend files
**Changes:**
- Replace all `any` type annotations with proper types
- Add loading skeletons to DocumentsPage and ESignaturesPage
- Add empty state messages
- Verify RTL layout for Arabic
- Verify LTR layout for English
- Verify keyboard navigation on upload/download buttons
- Verify ARIA labels on interactive elements

### Task 11 — Backend Tests
**Files:** New `backend/src/test/document.service.test.ts`
**Changes:**
- Unit tests for upload (valid file, oversized file, invalid MIME)
- Unit tests for softDelete
- Unit tests for sign (new signature, duplicate signature)
- Unit tests for download (existing file, missing file, soft-deleted)
- Unit tests for findByEntity (with results, no results)

### Task 12 — Exit Review + Gate 8
**Changes:**
- Run full regression suite
- Verify: Backend TS, Frontend TS, Production Build, Unit Tests
- Compile Exit Review report
- Mark Documents module as PRODUCTION READY

---

## 9. Task Summary

| # | Task | Layer | Priority | Est. Effort |
|---|------|-------|:--------:|:-----------:|
| 1 | Backend Download Endpoint + Static Serving | Backend | Critical | 0.5 day |
| 2 | Backend Get-By-ID Endpoint | Backend | High | 0.25 day |
| 3 | OpenAPI Update | OpenAPI | High | 0.25 day |
| 4 | SDK Expansion + Regeneration | SDK | High | 0.25 day |
| 5 | DocumentsPage SDK Migration + Pagination | Frontend | Critical | 0.5 day |
| 6 | ESignaturesPage SDK Migration | Frontend | High | 0.25 day |
| 7 | Applications Pages SDK Migration | Frontend | High | 0.5 day |
| 8 | Shared DocumentUpload Component | Frontend | High | 0.5 day |
| 9 | Document Preview Component | Frontend | Medium | 0.5 day |
| 10 | Type Safety + Quality | Frontend | Medium | 0.5 day |
| 11 | Backend Tests | Testing | High | 0.5 day |
| 12 | Exit Review + Gate 8 | Governance | Critical | 0.25 day |

**Total: 12 tasks**
**Total estimated effort: ~5 days (1 sprint)**

---

## 10. Estimated Sprints

| Sprint | Scope | Tasks | Duration |
|--------|-------|:-----:|:--------:|
| Sprint A | Backend foundation + OpenAPI + SDK + Frontend SDK migration + Download | 1–7 | 3 days |
| Sprint B | Reusable components + Preview + Quality + Tests + Exit Review | 8–12 | 2 days |

**Recommendation: 1 sprint (5 working days)**

The Documents module is less complex than Committees (no N+1 queries, no multi-entity sub-resources) but has a critical infrastructure gap (no download). Once the download endpoint is added, the remaining work is primarily frontend SDK migration and component extraction — patterns already established in Applications and Committees.

---

## Appendix A — Document Workflow Support Matrix

| Workflow | DB Support | Backend Support | Frontend Support |
|----------|:----------:|:---------------:|:----------------:|
| Upload | ✅ | ✅ | ✅ (raw API) |
| Download | ✅ (storage_path) | ❌ **MISSING** | ❌ **MISSING** |
| Preview | ❌ | ❌ | ❌ |
| Versioning | ✅ (document_versions) | ❌ (no code) | ❌ |
| Metadata | ✅ | ⚠️ (no update) | ❌ |
| Categories | ✅ (document_types) | ✅ | ⚠️ (not displayed) |
| Attachments | ✅ | ✅ | ✅ (raw API) |
| Workflow Linkage | ✅ (entity_type/entity_id) | ✅ | ✅ |
| Evidence Linkage | ✅ (ApplicationCondition) | ✅ (evidence module) | ✅ (ConditionsPanel) |
| Certificates | ✅ (approval_certificates) | ✅ (certificate module) | ✅ (CertificatesTab) |
| Conditions | ✅ | ✅ (condition module) | ✅ (ConditionsPanel) |

## Appendix B — Integration Points

| Module | Integration | Status |
|--------|------------|:------:|
| Applications | Documents uploaded per application via entity_type='Application' | ✅ Working (raw API) |
| Committees | Meeting minutes created as documents, auto-signed | ✅ Working (SDK) |
| Reviews | No direct document integration | — |
| Templates | Template-driven document generation (7 service classes) | ✅ Working (separate pipeline) |
| Notifications | Document upload triggers EVIDENCE_UPLOADED notification | ✅ Working |

---

*This analysis is read-only. No code was modified. Awaiting approval before starting development.*
