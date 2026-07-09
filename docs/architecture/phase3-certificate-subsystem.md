# Phase 3 — Certificate Subsystem

**Status**: Completed — Implemented (2026-07-03)  
**Depends on**: Phase 2 (Conditions + Evidence), `APPROVED` state semantics (RULE 11/12)

---

## 1. DB Schema

A new table for application approval certificates, distinct from the existing `security.digital_certificates` (which is for user identity certificates).

```sql
-- ============================================================
-- 1a. Core certificates table
-- ============================================================
CREATE DOMAIN documents.certificate_status AS VARCHAR(20)
  CHECK (VALUE IN ('DRAFT', 'GENERATING', 'ISSUED', 'REVOKED', 'SUPERSEDED', 'FAILED'));

CREATE TABLE documents.approval_certificates (
    id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    application_id      BIGINT NOT NULL REFERENCES core.applications(id),
    serial_number       VARCHAR(50) NOT NULL,
    version_no          INTEGER NOT NULL DEFAULT 1,
    status              documents.certificate_status NOT NULL DEFAULT 'DRAFT',
    issued_to_user_id   BIGINT NOT NULL REFERENCES security.users(id),
    issued_by_user_id   BIGINT NOT NULL REFERENCES security.users(id),
    issued_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
    revoked_at          TIMESTAMPTZ,
    revoked_by          BIGINT REFERENCES security.users(id),
    revocation_reason   TEXT,
    superseded_by       BIGINT REFERENCES documents.approval_certificates(id),
    generation_error    JSONB,  -- error details on FAILED state
    metadata            JSONB,  -- generation_parameters snapshot
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_cert_serial UNIQUE (serial_number),
    CONSTRAINT uq_app_version UNIQUE (application_id, version_no)
);

CREATE UNIQUE INDEX idx_cert_one_active
  ON documents.approval_certificates(application_id)
  WHERE status IN ('ISSUED', 'GENERATING', 'DRAFT');

CREATE INDEX idx_cert_app_id ON documents.approval_certificates(application_id);
CREATE INDEX idx_cert_serial ON documents.approval_certificates(serial_number);
CREATE INDEX idx_cert_status  ON documents.approval_certificates(status);

-- ============================================================
-- 1b. Certificate documents (the generated PDF files)
-- ============================================================
CREATE TABLE documents.approval_certificate_documents (
    id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    certificate_id      BIGINT NOT NULL REFERENCES documents.approval_certificates(id) ON DELETE CASCADE,
    document_id         BIGINT NOT NULL REFERENCES documents.documents(id),
    is_original         BOOLEAN NOT NULL DEFAULT TRUE,
    generated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- 1c. Certificate verification log (public, no FK)
-- ============================================================
CREATE TABLE documents.certificate_verification_log (
    id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    serial_number       VARCHAR(50) NOT NULL,
    verified_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    verified_by_ip      VARCHAR(50),
    result              VARCHAR(20) NOT NULL,
    details             JSONB
);

CREATE INDEX idx_ver_log_serial ON documents.certificate_verification_log(serial_number);
CREATE INDEX idx_ver_log_date   ON documents.certificate_verification_log(verified_at);
```

### Design Rationale

- **Separate table** from `security.digital_certificates` — application approval certs have different lifecycle (issued/revoked/superseded per application, not per user identity).
- **`version_no` + `superseded_by`** enforces immutability — re-issuance creates a new version, never overwrites.
- **`documents.documents`** link via `approval_certificate_documents` — reuses the existing file storage infrastructure (multer, RLS, audit triggers).
- **`certificate_verification_log`** is public with no FK constraints — verification works independently of authentication.
- **`serial_number`** is derived from `application_number` (already unique): `CERT-{application_number}-V{version_no}` e.g., `CERT-APP-2024-001-V1`. No separate sequence needed — the application number is already generated deterministically via `generateApplicationNumber()` at creation time, and `version_no` increments per `(application_id)`. The `UNIQUE(application_id, version_no)` constraint catches any race between two certs reaching ISSUED with the same version.

### New Document Type

Add to `documents.document_types`:
```sql
('APPROVAL_CERTIFICATE')
```

### RLS Policy

```sql
-- APPROVAL_CERTIFICATES: SELECT — owner + admin
CREATE POLICY cert_select ON documents.approval_certificates FOR SELECT
  USING (
    system.fn_is_admin(current_setting('app.user_id')::bigint)
    OR issued_to_user_id = current_setting('app.user_id')::bigint
  );

-- INSERT — admin only (issued_by_user_id must match session)
CREATE POLICY cert_insert ON documents.approval_certificates FOR INSERT
  WITH CHECK (
    system.fn_is_admin(current_setting('app.user_id')::bigint)
    AND issued_by_user_id = current_setting('app.user_id')::bigint
  );

-- UPDATE — only status changes via revoke
CREATE POLICY cert_update ON documents.approval_certificates FOR UPDATE
  USING (system.fn_is_admin(current_setting('app.user_id')::bigint))
  WITH CHECK (
    status IN ('REVOKED', 'SUPERSEDED')
    AND system.fn_is_admin(current_setting('app.user_id')::bigint)
  );

-- DELETE — blocked (audit trail)
CREATE POLICY cert_delete ON documents.approval_certificates FOR DELETE
  USING (false);

-- Verification log: insert public, select public
CREATE POLICY ver_log_insert ON documents.certificate_verification_log FOR INSERT
  WITH CHECK (true);  -- public, no auth required
CREATE POLICY ver_log_select ON documents.certificate_verification_log FOR SELECT
  USING (true);
```

---

## 2. Certificate Lifecycle & Workflow Integration

### State Machine

```
                 ┌──────────────────────────────────────────────────┐
                 │                                                  │
                 v                                                  │
  DRAFT ──→ GENERATING ──→ ISSUED ──→ REVOKED                      │
                  │                     │                           │
                  v                     v                           │
               FAILED ─────→ GENERATING (retry) ───────────────────┘
                                          │
                                          v
                                       ISSUED (after retry succeeds)

  ISSUED ──→ SUPERSEDED (when re-issue creates V2)
```

| State | Visibility | Meaning |
|-------|-----------|---------|
| `DRAFT` | Internal | Row inserted, generation not yet started |
| `GENERATING` | Internal | Puppeteer rendering in progress (prevents concurrent dups) |
| `ISSUED` | Public | Certificate valid, PDF available |
| `REVOKED` | Public | Certificate invalidated — permanent |
| `SUPERSEDED` | Public | Replaced by newer version — shows link to active cert |
| `FAILED` | Internal | PDF generation error — retryable |

**Allowed transitions:**
- `DRAFT → GENERATING` (job starts)
- `GENERATING → ISSUED` (success)
- `GENERATING → FAILED` (error)
- `FAILED → GENERATING` (retry)
- `ISSUED → REVOKED` (admin action)
- `ISSUED → SUPERSEDED` (re-issue creates V2)

**No UNREVOKE** — revocation is one-way. If revoked in error, re-issue (new version, clean audit trail).

### Trigger Point

Generation is **not** a workflow transition — it is an **automatic side effect** triggered when `updateStatus()` completes the `APPROVED` transition.

**Hook location** in `application.service.ts` (post-transaction, after dashboard broadcast):

```typescript
async updateStatus(id, body, user): Promise<ApplicationRow> {
  // ... existing transaction and broadcast logic ...
  
  // NEW: Auto-generate certificate on APPROVED
  if (updated.current_status === 'APPROVED') {
    // Fire-and-forget (non-blocking) — certificate generation
    // errors must NOT roll back the approval
    this.certificateService.generate(id, user).catch(err => {
      logger.error({ err, applicationId: id }, 'Certificate generation failed');
      // Notify admin via notification system
    });
  }
  
  return updated;
}
```

**Fire-and-forget** is deliberate: the approval is the critical path; the certificate is a side effect that can be retried.

### Race Prevention (Approval → Certificate)

Three-layer defense ensures exactly one active certificate per application:

**Layer 1 — Partial unique index (DB):**
```sql
CREATE UNIQUE INDEX idx_cert_one_active
  ON documents.approval_certificates(application_id)
  WHERE status IN ('ISSUED', 'GENERATING', 'DRAFT');
```
A second concurrent generation attempt hits a unique violation.

**Layer 2 — Advisory lock (transaction-level):**
```sql
SELECT pg_advisory_xact_lock(hashtext('cert_gen_' || application_id::text));
```
Serializes concurrent generation attempts within the `withTransaction` block.

**Layer 3 — Service-level idempotency check:**
```typescript
const existing = await this.repo.findActiveByApplication(applicationId);
if (existing && ['ISSUED', 'GENERATING'].includes(existing.status)) {
  return existing; // Already generated — idempotent
}
if (existing?.status === 'FAILED') {
  await this.repo.updateStatus(existing.id, 'GENERATING'); // Retry
}
```

All three layers together guarantee exactly one successful certificate per application, even if the hook fires twice or a retry job fires simultaneously.

### Manual Re-issuance

An admin endpoint `POST /certificates/:id/reissue` creates version `N+1`:
1. Sets current certificate status to `SUPERSEDED`
2. Generates new certificate with `version_no + 1`
3. Links new cert to the same `application_id`
4. New serial: `ERC-APP-2024-001-V2`

### Revocation

`POST /certificates/:id/revoke`:

1. Sets status to `REVOKED`
2. Records `revoked_at`, `revoked_by`, `revocation_reason`
3. Certificate PDF remains accessible (immutable) but shows `REVOKED` watermark on verification
4. Does NOT change the application workflow state — the approval stands

**No UNREVOKE** — if revoked in error, re-issue (new version, clean audit trail).

### Revocation vs Supersession Policy Matrix

`REVOKED` and `SUPERSEDED` are semantically distinct:

| Scenario | Certificate State | App State | Semantic Meaning |
|----------|-----------------|-----------|------------------|
| Ethical violation found post-approval | **REVOKED** | Remains `APPROVED` | "This approval certificate is no longer valid due to a finding after issuance" |
| Application approval reversed (fraud) | **REVOKED** | Follows workflow (`REJECTED`) | "The underlying approval was reversed; certificate is void" |
| Applicant withdraws post-approval | **REVOKED** | `WITHDRAWN` | "Applicant withdrew after approval; certificate is void" |
| Re-issue (new version) | **SUPERSEDED** | Remains `APPROVED` | "A newer version exists — see V2" |
| Conditions modified after cert issued | **SUPERSEDED** | Remains `APPROVED` | "Certificate content outdated due to condition changes" |

**Distinction on verification page:**
- `REVOKED` → 🔴 "This certificate has been revoked and is no longer valid."
- `SUPERSEDED` → 🟡 "This certificate has been superseded by version X. [Verify Version X →]"

---

## 3. Template System (HTML → PDF)

### Template Storage

Reuse the existing `documents.templates` table:

```sql
INSERT INTO documents.templates (template_code, template_name, template_type, template_content)
VALUES (
  'APPROVAL_CERTIFICATE_V1',
  'Ethics Approval Certificate',
  'CERTIFICATE',
  '<html>... Handlebars template ...</html>'
);
```

### Rendering Pipeline

1. **Template source**: `documents.templates.template_content` (HTML with Handlebars `{{placeholders}}`)
2. **Data injection**: Server-side JSON context built by `CertificateService`
3. **HTML → PDF**: `puppeteer` (headless Chromium) for accurate rendering with CSS, Arabic/RTL support, embedded fonts
4. **Output**: PDF file saved to `./uploads/certificates/` directory, record created in `documents.documents`

### Arabic PDF Rendering

**Font: Noto Sans Arabic** (Google Fonts, OFL license, comprehensive Arabic glyph coverage including all diacritics and Quranic marks).

Font deployment:
- Font files bundled in `backend/fonts/` at build time:
  - `NotoSansArabic-Regular.ttf`
  - `NotoSansArabic-Bold.ttf`
- Loaded via `@font-face` with `file://` URL in the HTML template:
```html
<style>
  @font-face {
    font-family: 'Noto Sans Arabic';
    src: url('file:///app/fonts/NotoSansArabic-Regular.ttf') format('truetype');
    font-weight: 400;
  }
  @font-face {
    font-family: 'Noto Sans Arabic';
    src: url('file:///app/fonts/NotoSansArabic-Bold.ttf') format('truetype');
    font-weight: 700;
  }
  * { font-family: 'Noto Sans Arabic', sans-serif; }
  body { direction: rtl; }
  @page { size: A4; margin: 20mm; }
</style>
```

**Determinism guarantees:**
- All fonts, CSS, images embedded in HTML (no external network requests)
- `qrcode` produces deterministic output for same input (`errorCorrectionLevel: 'M'`)
- No JS execution in puppeteer — static HTML → PDF only
- Puppeteer version pinned to `package.json` — same Chromium version across dev/CI/prod
- In Docker: puppeteer bundled Chromium (no OS-level font discrepancies)

### Template Context Variables

```typescript
interface CertificateTemplateContext {
  serialNumber: string;
  applicationNumber: string;
  projectTitle: string;          // bilingual (ar/en)
  researcherName: string;        // full name
  committeeName: string;         // bilingual
  issueDate: string;             // formatted
  expiryDate: string | null;     // if applicable
  qrCodeDataUrl: string;         // base64 PNG for embedding
  approvalStatement: string;     // Arabic legal text
  conditions: {                  // MET conditions only (actionable)
    text: string;
    category: string;
  }[];
  footer: {
    institutionName: string;
    serialNumber: string;
  };
}
```

### PDF Generation Architecture

```
CertificateService.generate()
  │
  ├─ 1. Load template from documents.templates
  ├─ 2. Build context (application, user, committee, conditions)
  ├─ 3. Render HTML (Handlebars.compile)
  ├─ 4. Generate QR code (qrcode → data URL)
  ├─ 5. Launch puppeteer → page.setContent(html) → page.pdf()
  ├─ 6. Save PDF to ./uploads/certificates/{serial}.pdf
  ├─ 7. Create documents.documents record
  ├─ 8. Create approval_certificates record
  └─ 9. Create approval_certificate_documents link
```

### New Dependencies

```json
{
  "puppeteer": "^24.0.0",
  "handlebars": "^4.7.8",
  "qrcode": "^1.5.4"
}
```

---

## 4. Digital Signature / Verification Strategy

### PDF Signature (Optional for MVP)

Certificates contain a **verification hash** embedded as a metadata field in the PDF, computed from:
```
sha256(serialNumber + applicationNumber + issueDate + secret)
```

The hash enables:
- **Offline verification**: The hash can be checked against the known secret
- **Online verification** (preferred): Hash is redundant with QR → DB lookup

### What the Certificate PDF Contains

1. Committee letterhead + institutional branding
2. Applicant name, project title
3. Approval statement with application reference
4. Issue date + serial number
5. QR code (top-right corner) containing verification URL
6. Conditions that were MET (informational)
7. Footer with serial and verification URL

---

## 5. QR Verification Flow

### QR Code Content

```
https://ethics.erc.gov.sa/verify?serial=ERC-APP-2024-001-V1
```

**Deliberately minimal** — the serial is the primary key; no tokens or hashes in the URL.

### Public Verification Endpoint

**No authentication required** — this is a public API for third-party verification.

```
GET /api/v1/public/certificates/verify/:serialNumber
```

Response:
```json
{
  "success": true,
  "data": {
    "serialNumber": "CERT-APP-2024-001-V1",
    "status": "ISSUED",
    "certificateType": "ETHICS_APPROVAL",
    "issuingAuthority": "اللجنة الوطنية للأخلاقيات",
    "issuingAuthorityEn": "National Committee for Ethics",
    "committeeName": "لجنة أخلاقيات البحث العلمي",
    "committeeNameEn": "Scientific Research Ethics Committee",
    "researcherName": "د. أحمد محمد",
    "projectTitle": "دراسة تأثير العوامل الوراثية على الاستجابة للعلاج",
    "applicationNumber": "APP-2024-001",
    "institutionName": "جامعة الملك سعود",
    "issuedAt": "2024-06-15T10:30:00Z",
    "expiresAt": null,
    "verifiedAt": "2024-07-03T15:00:00Z"
  }
}
```

**Explicitly excluded from public payload (no sensitive data leakage):**
- ❌ Researcher email, phone, national ID
- ❌ Scientific abstract, methodology, research objectives
- ❌ Condition details, reviewer names, reviewer comments
- ❌ Any personal contact information

If REVOKED, response includes `status: "REVOKED"`, `revokedAt`, and `revocationReason`.
If SUPERSEDED, response includes `status: "SUPERSEDED"` and `supersededBySerial`.

### Public Verification Architecture (RLS Bypass)

**Challenge**: The public verify endpoint has no `app.user_id` set (no authentication). However, `documents.approval_certificates` has RLS policies that require `app.user_id` for SELECT — without it, the policy evaluates all conditions as false and returns zero rows.

**Solution**: SECURITY DEFINER function that bypasses RLS:

```sql
CREATE OR REPLACE FUNCTION documents.fn_get_certificate_verification(
    p_serial_number VARCHAR
)
RETURNS TABLE(...)
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT ... FROM documents.approval_certificates c
    JOIN ... WHERE c.serial_number = p_serial_number;
$$;
```

Key properties:
- **SECURITY DEFINER**: Runs with owner privileges (bypasses RLS on `approval_certificates` and all joined tables)
- **Read-only**: Marked `STABLE`, no write operations
- **Limited scope**: Only returns verification-safe fields (no contact info, no internal notes)
- **No injection risk**: Parameterized via `$1` in repository call

The repository method `getVerificationData()` calls `SELECT * FROM documents.fn_get_certificate_verification($1)` instead of a raw SELECT query. This is the only access path that bypasses RLS — all authenticated endpoints continue to use normal RLS-protected queries.

**Seed 47** (`47-public-verify-function.sql`) creates this function. It is part of the certificate baseline and must be applied after seeds 45 and 46.

### Router

Add to `backend/src/index.ts`:
```typescript
import publicRoutes from './modules/public';
app.use('/api/v1/public', publicRoutes);  // before auth middleware? No — separate module
```

Mount `publicRoutes` **before** the general auth middleware injection. The `/api/v1/public/...` module will NOT use `authenticate` for its routes.

### QR Generation

- Library: `qrcode` npm package
- Generates a PNG data URL (base64) that is embedded in the HTML template
- Size: ~2×2 cm on the PDF, 256×256 resolution
- The verification URL is deterministic from the serial number (no per-request state)

### Verification Page (Public Frontend)

`/verify?serial=XXX` → React page with:
1. No auth required (public route in frontend)
2. Fetches verification data from `/api/v1/public/certificates/verify/:serial`
3. Shows certificate status with visual indicator (green/red)
4. Shows key certificate metadata
5. Option to download a verification report
6. Rate-limited (10 req/min per IP)

---

## 6. Backend Services & Routes

### New Files

```
backend/src/
├── services/
│   └── certificate.service.ts    # CertificateService — generate, reissue, revoke, verify
├── repositories/
│   └── certificate.repository.ts # CertificateRepository — CRUD for approval_certificates
├── modules/
│   ├── core/
│   │   └── certificate.routes.ts # Admin routes for certificates (auth required)
│   └── public/
│       ├── index.ts              # Public routes module
│       └── certificate.routes.ts # Public verification routes (no auth)
```

### CertificateService

```typescript
class CertificateService {
  // Auto-generated on APPROVED transition
  async generate(applicationId: number, issuedBy: AuthUser): Promise<ApprovalCertificate>
  
  // Manual re-issuance (admin)
  async reissue(certificateId: number, issuedBy: AuthUser): Promise<ApprovalCertificate>
  
  // Revoke (admin)
  async revoke(certificateId: number, reason: string, revokedBy: AuthUser): Promise<void>
  
  // Public verification (no auth)
  async verify(serialNumber: string): Promise<CertificateVerificationData>
  
  // Internal
  private async renderPdf(context: TemplateContext): Promise<{ pdfPath: string }>
  private async generateSerialNumber(applicationId: number, versionNo: number): Promise<string>
  private async buildTemplateContext(certificate: ApprovalCertificate): Promise<TemplateContext>
}
```

### Routes (Authenticated)

Mount under `/api/v1/core/applications/:applicationId/certificates`:

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/` | Admin | List certificates for application |
| GET | `/:id` | Admin/Owner | Get certificate details |
| POST | `/:id/reissue` | Admin | Re-issue (new version) |
| POST | `/:id/revoke` | Admin | Revoke certificate |
| GET | `/:id/download` | Admin/Owner | Download PDF |

### Routes (Public — No Auth)

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/api/v1/public/certificates/verify/:serialNumber` | None | Verify certificate |

### Module Registration

In `backend/src/index.ts`:
```typescript
import publicRoutes from './modules/public';
app.use('/api/v1/public', publicRoutes);
```

New module `backend/src/modules/public/index.ts`:
```typescript
import { Router } from 'express';
import certificateRoutes from './certificate.routes';
const router = Router();
router.use('/certificates', certificateRoutes);
export default router;
```

---

## 7. Frontend Certificate UI

### Certificate Tab on Application Detail

Add a `CertificatesTab` component to `frontend/src/pages/Applications/Detail.tsx`:

**Applicant View** (READ only):
- Certificate list with status badges (ACTIVE/REVOKED/SUPERSEDED)
- "Download PDF" button for each certificate
- Verification status indicator
- QR code preview (expandable)

**Admin View** (Manage):
- All applicant features +
- "Re-issue Certificate" button (opens confirmation dialog)
- "Revoke Certificate" button (opens reason dialog)
- Certificate generation history

### Public Verification Page

`frontend/src/pages/Verify/VerifyPage.tsx`:
- **No authentication required**
- Query parameter: `?serial=ERC-APP-2024-001-V1`
- Fetches from `/api/v1/public/certificates/verify/:serialNumber`
- Displays:
  - Certificate status (large badge: ACTIVE ✅ / REVOKED ❌)
  - Researcher name
  - Project title
  - Committee name
  - Issue date
  - Serial number
  - Verification timestamp (when this verification was performed)
- SEO: meta tags with Open Graph for social sharing
- Styling: matches the institutional design system

### Frontend Routes

```typescript
// App.tsx or router config
<Route path="/verify" element={<VerifyPage />} />
```

This route is defined OUTSIDE the auth-protected layout (separate from `PrivateRoute`).

### SDK Methods (Authenticated)

Add to `frontend/src/sdk/domains/certificates.sdk.ts`:
```typescript
export const certificates = {
  list(applicationId: number) { ... },
  getById(id: number) { ... },
  download(id: number) { ... },    // returns blob
  reissue(id: number) { ... },
  revoke(id: number, reason: string) { ... },
}
```

### Public SDK

`frontend/src/sdk/public/verify.sdk.ts`:
```typescript
export const verify = {
  check(serialNumber: string) { ... },
}
```

---

## 8. Permission Matrix

| Action | SUPER_ADMIN | ETHICS_ADMIN | COMMITTEE_CHAIR | REVIEWER | RESEARCHER | Public |
|--------|-------------|--------------|-----------------|----------|------------|--------|
| View certificates | ✅ | ✅ | ✅ | ✅ | Own only | ❌ |
| Download PDF | ✅ | ✅ | ✅ | ✅ | Own only | ❌ |
| Generate (auto on APPROVED) | ✅ | ✅ | — | — | — | — |
| Re-issue | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Revoke | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Verify (public) | — | — | — | — | — | ✅ |
| View verification log | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

---

## 9. Audit Trail

### DB-Level

Both `documents.approval_certificates` and `documents.approval_certificate_documents` have `created_at` timestamps. The `system.fn_log_audit()` trigger is attached (same pattern as all other tables via the DO block in `13-audit-triggers.sql`).

### Application-Level

CertificateService logs structured audit entries:

| Action | Logged Fields |
|--------|--------------|
| Generate | certificateId, applicationId, serialNumber, issuedBy |
| Re-issue | oldCertId, newCertId, newVersionNo, reason |
| Revoke | certificateId, revokedBy, reason |
| Verification (public) | serialNumber, result, sourceIp (logged in verification_log table) |

### Immutability

- Once a certificate PDF is generated, it is NEVER deleted or overwritten.
- Soft-delete (`deleted_at`) on `documents.documents` for certificate files is FORBIDDEN (`FOR DELETE USING (false)`).
- Status changes (REVOKED/SUPERSEDED) are UPDATE operations on the `approval_certificates` table only — the PDF remains accessible.
- Re-issuance creates a new version entirely (new `approval_certificates` row, new PDF, new serial).

---

## 10. Rollback Strategy

### Scenario 1: PDF Generation Fails

- The `generate()` call in `application.service.ts` is fire-and-forget (non-blocking).
- Application is already `APPROVED` — the certificate failure does NOT roll back the approval.
- **Immediate auto-retry**: In the `generate()` catch block, one single retry attempt is made. If that also fails, status → `FAILED`.
- **Manual retry**: Admin clicks "Retry" via `POST /certificates/:certId/retry` — finds the FAILED cert, transitions to `GENERATING`, re-runs puppeteer.
- **No infinite retry**: A FAILED cert stays FAILED until explicitly retried, preventing retry storms.
- **Scheduler (post-MVP)**: Periodic job queries FAILED certs older than 5 min, retries with backoff: 1min→5min→30min→2h→give up.

### Scenario 2: Template Rendering Error

- Handlebars compilation is validated at startup (template pre-compilation).
- If a specific application's context fails (e.g., missing data), the error is logged and a notification is sent to the admin group.
- No data loss — the application remains APPROVED, and cert can be retried.

### Scenario 3: Revocation Accident

- Revoked certificates remain in the DB with status `REVOKED` and timestamp.
- **No un-revoke**: There is no `UNREVOKE` action — the audit trail of revocation is definitive.
- If a certificate was revoked in error, the only fix is to re-issue (which creates a new version with an audit trail).

### Scenario 4: Public Verification Service Down

- Verification via QR code URL fails gracefully: "Verification service unavailable. Contact the issuing authority."
- The QR code URL is deterministic (just the serial number) — no state to lose.
- The PDF itself remains downloadable (file storage independent of verification service).

### Scenario 5: Rollback of Certificate Feature

- Since certificates are generated as a fire-and-forget side effect, removing the feature later requires:
  1. Removing the `generate()` call from `application.service.ts` (no further certificates generated)
  2. Existing certificates remain in the DB (read-only, no active effect on workflow)
  3. Optionally, soft-delete the `approval_certificates` table (mark `FOR DELETE USING (false)`)

### DB-Level Safety

- All certificate operations are wrapped in transactions via `withTransaction()`.
- `serial_number` UNIQUE constraint prevents duplicate issuance.
- `application_id + version_no` UNIQUE constraint prevents version conflicts.

---

## Implementation Order

| Step | Description | Est. Files |
|------|-------------|------------|
| 1 | DB seed: `45-certificates.sql` (tables, RLS, document_type seed) | 1 SQL |
| 2 | Add npm dependencies: puppeteer, handlebars, qrcode | 1 config |
| 3 | `CertificateRepository` (5 methods) | 1 TS |
| 4 | `CertificateService.generate()` + `renderPdf()` + `verify()` | 1 TS |
| 5 | `certificate.routes.ts` (authenticated CRUD) | 1 TS |
| 6 | Wire into `core/index.ts` + `application.service.ts` hook | 2 edits |
| 7 | Public verification routes + module | 2 TS |
| 8 | Frontend SDK + types | 2 SDK files |
| 9 | Frontend `CertificatesTab` component | 1 TSX |
| 10 | Frontend public `VerifyPage` | 1 TSX |
| 11 | Frontend routes update | 1 edit |
| 12 | DB seed: `46-certificate-rls-hotfix.sql` (committee member access fix) | 1 SQL |
| 13 | DB seed: `47-public-verify-function.sql` (SECURITY DEFINER bypass for public verify) | 1 SQL |
| 14 | E2E tests | 1 PS1 script |
| 15 | Frontend lint + backend lint + tests | verification |

---

**Total estimated new files**: ~14 files  
**Total estimated modified files**: ~4 files  
**Estimated effort**: 6-8 implementation cycles

---

## Seed Inventory

| Seed | Purpose | RLS Pattern |
|------|---------|-------------|
| `45-certificates.sql` | Schema, tables, domain, indexes, RLS policies, default template, audit triggers | `current_setting('app.user_id')` without `true` flag (brittle) |
| `46-certificate-rls-hotfix.sql` | Add `fn_is_committee_member_for_application()`, update SELECT policies for committee member access | `current_setting('app.user_id', true)` with safe `true` flag |
| `47-public-verify-function.sql` | SECURITY DEFINER function for public verification (no `app.user_id` set) | Bypasses RLS entirely via SECURITY DEFINER |
