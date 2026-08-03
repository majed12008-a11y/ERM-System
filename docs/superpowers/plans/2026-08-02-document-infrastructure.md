# Plan: Document Infrastructure (Immutable Legal Record Generation)

Date: 2026-08-02
Status: Completed (Tasks 1–9 all done)

## Background / Problem

Official documents generated from form submissions (review form docs, decision letters,
monitoring/meeting/progress reports, safety/closure reports) currently lack:

1. **No versioning** — regenerating a doc overwrites nothing, but there is no version
   lineage and no way to tell which version was issued.
2. **No English templates** — every template in `seed/56` is Arabic-only; regeneration
   of an EN form silently falls back to Arabic (`document_render` returns `language: 'ar'`).
3. **No public verification** — certificates have `serialNumber` + QR verification, but
   generated documents have no equivalent endpoint or QR.
4. **No immutability** — generated documents can in principle be edited/deleted at DB level
   (soft-delete columns exist); legal records must be append-only.
5. **No digital signature model** — `document_signatures` table exists but nothing populates it.
6. **No lifecycle** — no REVOKED / VOID / SUPERSEDED states for issued documents.
7. **No audit trail** — `document_audit` table exists but nothing writes to it.
8. **No browser reloads** — the old workaround (`window.location.reload()` in FormFillPage
   after submit) was a cache-invalidation hack.

## Root cause already fixed (cache invalidation)

`node-postgres` returns `BIGINT id` as a **string** (`"17"`), while the frontend query key used
`Number(instanceId)` (`17`). `queryClient.invalidateQueries(['form-instance', 17])` matched an
empty key set, so no refetch fired and the only way the UI updated was a page reload.

**Fix applied in `frontend/src/pages/Forms/FormFillPage.tsx`:**

```ts
onSuccess: (updated) => {
  toast.success(t('formFill.submitted'))
  queryClient.setQueryData<InstanceData>(['form-instance', Number(instance.id)], (old) =>
    old ? { instance: updated, definition: old.definition } : old
  )
  queryClient.invalidateQueries({ queryKey: ['form-instance', Number(instance.id)] })
}
```

The `window.setTimeout(() => window.location.reload(), 800)` line was **removed**.
Verified via Playwright: badge flips at ~1.5s, network shows POST /submit → GET refetch, no reload.
Note: instance ids in the DOM/history are strings; other BIGINT-vs-number key mismatches should be
audited later (this plan includes a task for it).

## Goals

1. Every generated document is a **permanent, immutable legal record**: UUID, document number,
   checksum SHA-256, status lifecycle (OFFICIAL / REVOKED / VOID / SUPERSEDED), and a public
   verification reference.
2. **Template versioning**: templates versioned by `(code, language)`; regenerate uses the exact
   template version that produced the original; template updates create new template versions,
   never mutate issued documents.
3. **Document versioning**: re-issuing a document creates a new `version_no` and **supersedes**
   the previous one (previous stays immutable, marked SUPERSEDED, pointing to successor).
4. **English templates** for every official document, plus missing Arabic/English base templates
   (MONITORING_REPORT_DOC, MEETING_MINUTES_DOC, PROGRESS_REPORT_DOC, SAFETY_REPORT_DOC,
   CLOSURE_REPORT_DOC, DECISION_LETTER EN, REVIEW_FORM_DOC EN).
5. **QR verification endpoint**: `GET /api/v1/public/documents/verify/:reference` (public, rate
   limited, SECURITY DEFINER so RLS does not block anonymous reads) returning status + metadata.
6. **Verification page**: frontend `/verify` extended to accept a document reference (or QR code
   contents) alongside certificate serial verification; no reload, single page handles both.
7. **Digital signatures**: placeholder signature rows in `document_signatures` for all signatories
   (issuer, chair, etc.) at generation time, plus a signing endpoint that records a signature.
8. **Document lifecycle**: revoke / void endpoints (admin), which set status + store reason.
9. **Audit trail**: every generation / version / signature / revoke / verify writes a row in
   `document_audit`.
10. **No browser reloads anywhere** in this flow.

## Key decisions

- **Public verify uses SECURITY DEFINER function** (same pattern as certificates, seed 47).
  Reference accepts either `document_number` or the UUID.
- **Immutability enforced by trigger**: `fn_guard_document_immutable()` blocks UPDATE of
  `checksum_sha256`, `storage_path`, `file_name`, `document_number`, `uuid` once `is_immutable`,
  and blocks physical delete (soft-delete only) of immutable rows. Note the PG 18.3 Windows
  `FOR DELETE USING(false)` gotcha from AGENTS.md — use `BEFORE UPDATE`/`BEFORE DELETE` triggers
  rather than relying on delete policies alone; keep `FOR ALL USING(true) WITH CHECK(...)` for
  INSERT on the parent table.
- **`document_versions` stores snapshots**: each issued version copies `checksum_sha256`,
  `storage_path`, `file_name`, `document_number`, `template_code`, `template_version`, `issued_by`.
  The live `documents` row is the current version; the versions table is the lineage.
- **Supersede is done via `supersedes_id` on `document_versions`** (new version row references the
  one it replaces) AND status flip of the old `documents` row to `SUPERSEDED`.
- **Templates are fetched by exact `(code, language, version_no)`**: regeneration resolves the
  stored `template_code` + `template_version`; new-issue resolves `is_default` + latest `version_no`
  for the requested language, falling back to Arabic only if no template for the requested language
  exists (and `document_render` must NOT silently pick another language — return an error instead).
- **Do NOT hand-edit SDK files.** Backend OpenAPI spec is the contract source. Since SDK
  regeneration via Orval is heavy, new endpoint types are added as small hand-written additions to
  `frontend/src/api/forms.ts` + `frontend/src/types.ts` ONLY where SDK files are not involved, and
  the OpenAPI spec is updated in the same PR so regeneration stays consistent.

## Architecture recap (verified during exploration)

- Backend: `modules/forms/forms.routes.ts` → `services/form.service.ts` → `repositories/document-render.repository.ts`
  (generation) and `document-render.service.ts` (HTML→PDF via puppeteer/chrome, QR PNG + SHA-256).
- Generation flow: `POST /api/v1/forms/:instanceId/generate` (validate) → `FormService.generateFormDocument`
  → template lookup (`document-template.repository.findActiveTemplate`) → render service renders HTML,
  embeds QR, produces PDF, computes checksum → repo persists `documents.documents` + `document_versions`
  + `document_audit` → returns download URL.
- Download: `GET /api/v1/forms/documents/:id/download` (already fixed — no doubled `/api/v1` prefix).
- Templates stored in `documents.templates` with `(code, name_ar, name_en, language, version_no,
  is_active, is_default, document_category, content_html, variables_json)`.
- Certificates: `modules/public/certificate.routes.ts` uses `verifyLimiter`; `certificate.service.ts`
  calls `fn_get_certificate_verification(serial)` (SECURITY DEFINER, seed 47). Frontend `VerifyPage.tsx`
  + `sdk/public/verify.sdk.ts` consume `/public/certificates/verify/:serialNumber`.
- RLS: `documents.documents` SELECT via `documents_select_policy` (seed 15) = admin OR own OR
  `document_access` match. INSERT = admin OR (`uploaded_by = app.user_id` AND entity ownership).
  Audit + versions + signatures + generated_documents child tables currently have **no RLS policy**
  that lets the generating app session write — the `BEFORE INSERT` on parent already gates issuance;
  child rows are written by the same session that created the parent, so they must be readable by
  that session too. A `FOR SELECT USING (TRUE)` on child tables is acceptable here because they are
  only reachable via the parent's policies (defense in depth via parent join); the parent RLS is the
  real gate. Keep `document_access` as the override for committee/admin.

## Task list

### Task 1 — (DONE) Fix cache invalidation + remove reload hack
Files: `frontend/src/pages/Forms/FormFillPage.tsx`
- Removed `window.setTimeout(() => window.location.reload(), 800)`.
- `setQueryData` + `invalidateQueries(['form-instance', Number(instance.id)])`.
- Verify: `npm run lint` (eslint) + `npm run build` (tsc -b) in `frontend`.
- Verified via Playwright (POST → GET refetch, no reload).

### Task 2 — SQL: schema for immutable legal record (new seed `57-document-infrastructure.sql`)
Files: `backend/seed/57-document-infrastructure.sql` (new), run via psql.
Steps:
1. Add columns to `documents.documents`:
   - `document_uuid UUID NOT NULL DEFAULT gen_random_uuid()` (public reference; unique)
   - `checksum_sha256 VARCHAR(64)`
   - `is_immutable BOOLEAN NOT NULL DEFAULT FALSE`
   - `current_version_no INTEGER NOT NULL DEFAULT 1`
   - `template_code VARCHAR(50)`
   - `template_version INTEGER`
   - `supersedes_version_no INTEGER`
   - `revocation_reason TEXT`
2. Add columns to `documents.document_versions` if not already present:
   - `document_uuid UUID`, `checksum_sha256 VARCHAR(64)`, `storage_path`, `file_name`,
     `template_code`, `template_version`, `issued_by`, `supersedes_id BIGINT REFERENCES
     documents.document_versions(id)`.
3. Extend `documents.document_status` enum/CHECK to include `SUPERSEDED` (verify current domain
   values first — AGENTS.md RULE 11 lists statuses; generated docs use a separate status column or
   the existing status column must allow REVOKED/VOID/SUPERSEDED). Prefer a dedicated
   `document_status` CHECK if one exists; otherwise add CHECK constraint on `status`.
4. `document_access` stays as-is.
5. Trigger `fn_guard_document_immutable()`:
   - `BEFORE UPDATE OF checksum_sha256, storage_path, file_name, document_number, document_uuid`
     ON documents.documents FOR EACH ROW — if `OLD.is_immutable` raise exception.
   - `BEFORE DELETE` ON documents.documents FOR EACH ROW — if `OLD.is_immutable` raise exception
     (only soft-delete allowed; plus RLS `FOR DELETE USING(false)` on parent table already blocks).
6. `SECURITY DEFINER` function `documents.fn_verify_document(reference TEXT)`:
   - Input: document_number OR document_uuid.
   - Returns JSONB: status, document_number, document_uuid, title (ar/en by param or both),
     version_no, checksum_sha256, issued_at, issued_by, template_code/version, superseded_by_number
     (if superseded), revocation_reason, verified_at.
   - Resolves latest version row for the document; joins users for issued_by name.
7. RLS for child tables (versions, audit, signatures, generated_documents): `FOR SELECT USING(TRUE)`
   plus `FOR INSERT WITH CHECK (TRUE)` (session that creates the parent already passed the parent
   INSERT policy). No UPDATE/DELETE policies → child rows effectively immutable via RLS.
8. Seed EN + missing templates (Task 4 depends on this data, but the SQL file can be one seed;
   split template seeds into their own file `58-official-templates-en.sql` if cleaner).
9. Run: `psql -U postgres -d ethics_db -f backend/seed/57-document-infrastructure.sql`
   (and 58 if separate). Verify with a smoke query.

### Task 3 — Backend: versioning + lifecycle + audit in render repo/service
Files:
- `backend/src/repositories/document-render.repository.ts`
- `backend/src/services/document-render.service.ts`
- `backend/src/services/form.service.ts`
Steps:
1. `DocumentRenderRepository.createDocument(...)`: accept `template_code`, `template_version`,
   `checksum_sha256`, `document_uuid`, `is_immutable=TRUE`, set `status='OFFICIAL'`,
   `current_version_no=1`. Insert the version snapshot row in the same transaction.
2. New `createNewVersion(parentDocId, snapshot)` → returns new `documents.documents` row with
   `current_version_no = parent+1`, `supersedes_version_no = parent`, new `document_uuid` (new
   public reference for the new version), `is_immutable=TRUE`, and marks the old row
   `status='SUPERSEDED'`. Child versions rows keep `supersedes_id` chain.
3. `getDocumentWithVersions(documentId)` → row + versions[] (ordered by version_no ASC).
4. `getDocumentAudit(documentId)` → audit rows ordered by timestamp.
5. `writeAudit(actorId, documentId, action, details)` → insert into `documents.document_audit`.
6. `setDocumentStatus(documentId, status, reason, actorId)` → update + audit (only when status is
   OFFICIAL; cannot transition REVOKED/VOID/SUPERSEDED back).
7. `DocumentRenderService.generate`:
   - Template resolution must pass `language` through; if requested language template missing,
     throw 400 (do NOT fall back silently). Keep `en` → `ar` fallback ONLY for legacy flows that
     the frontend explicitly opts into.
   - After PDF render, store checksum + document_uuid; write audit entry "GENERATED".
8. `FormService` new methods (called from routes):
   - `listGeneratedDocuments(instanceId)` → documents for instance (via new repo method joining
     documents + document_versions for versions count).
   - `getDocumentDetail(documentId)` → doc + versions + audit + signatures.
   - `signDocument(documentId, userId)` → insert placeholder signature (digital_signature JSONB
     placeholder) into `document_signatures`, audit "SIGNED".
   - `revokeDocument(documentId, reason, actor)` / `voidDocument(...)` → admin-only via
     `system.fn_is_admin(app.user_id)` check in SQL; audit "REVOKED"/"VOIDED".
9. All DB writes go through `AuditableRepository`-style `app.user_id` context so RLS works.

### Task 4 — Backend: routes + validation + public verify endpoint
Files:
- `backend/src/modules/forms/forms.routes.ts`
- `backend/src/modules/forms/index.ts` (if needed)
- `backend/src/modules/public/documents.routes.ts` (new)
- `backend/src/modules/public/index.ts` (mount)
- `backend/src/middleware/validate.ts` (schemas)
- `backend/src/shared/types.ts` (types if needed)
Steps:
1. `GET /forms/:instanceId/documents` → list generated docs (auth + can-view-instance).
2. `GET /forms/documents/:id` → detail (doc + versions + audit + signatures).
3. `POST /forms/documents/:id/sign` → body `{ signature_type?: string }`; returns created
   signature placeholder; audit.
4. `POST /forms/documents/:id/revoke` → body `{ reason: string (min 5) }`; admin-only.
5. `POST /forms/documents/:id/void` → same; admin-only.
6. `GET /public/documents/verify/:reference` → public, `verifyLimiter`, no auth; calls
   `documents.fn_verify_document(reference)`; maps result to JSON. 404 if not found.
7. Mount `/public/documents` in public index; keep cert routes intact.
8. Verify with curl.

### Task 5 — Frontend: verification page + SDK addition
Files:
- `frontend/src/pages/Verify/VerifyPage.tsx`
- `frontend/src/sdk/public/verify.sdk.ts` (or `frontend/src/api/documents.ts` if SDK regen too heavy)
- `frontend/src/api/forms.ts` (document list/detail/sign/revoke/void)
- `frontend/src/types.ts` (interfaces)
- `frontend/src/i18n/` ar/en keys
Steps:
1. Extend `VerifyPage` to auto-detect input type: if it matches `/^(RVW|DOC|DEC|MON|MTG|PRG|SAF|CLS|CERT|QR)\d*[-]?\d+/` or a 36-char UUID → document verify; if `CERT-…`/serial → certificate verify. Single page, no reload; URL param `?ref=…` / `?serial=…` drives both.
2. New API funcs in `frontend/src/api/forms.ts`: `listGeneratedDocuments`, `getDocumentDetail`, `signGeneratedDocument`, `revokeGeneratedDocument`, `voidGeneratedDocument`. Add matching types in `frontend/src/types.ts`.
3. Verify document call: `GET /public/documents/verify/:reference` → render result card (status badge, number, title, version, checksum short, issued at/by, superseded/revocation info, "verified at" timestamp).
4. Add a QR button on the verified result (reuse existing QR render helper used by certificates if one exists; otherwise add a small QR PNG embed from a `qrcode` lib already in package.json).
5. i18n keys: `verify.*`, `documents.*` for both ar/en.

### Task 6 — Frontend: FormFillPage document panel (no reloads)
Files: `frontend/src/pages/Forms/FormFillPage.tsx`
Steps:
1. After submit/generation, fetch document list via `listGeneratedDocuments(instanceId)` and cache
   under `['form-instance-documents', Number(instance.id)]`.
2. Render a "Generated Documents" panel listing each document: number, title (ar/en by lang),
   version badge, status badge (OFFICIAL/REVOKED/VOID/SUPERSEDED), issued date, checksum short,
   download link, signature count, audit button.
3. Actions per row: Sign (opens confirm → POST sign → invalidate list + detail), Revoke/Void
   (admin only, prompt for reason → POST → invalidate), Detail (expandable → versions + audit +
   signatures).
4. After `generate` succeeds, invalidate the documents key (not a reload). After `sign`/`revoke`,
   invalidate again. All UI updates come from the same query keys as Task 1 fix.
5. No `window.location.reload()` anywhere in the file.

### Task 7 — Frontend: Admin template versioning UI
Files: `frontend/src/pages/Admin/DocumentTemplates.tsx`
Steps:
1. Show `language`, `version_no`, `is_default`, `is_active`, `document_category` columns.
2. "New Version" action per template row → POST creates `version_no+1` with same code+language,
   sets `is_active` on new, `is_active=false` on old (backend handles). Confirm dialog.
3. "Set Default" action → sets `is_default=true` for that code+language, false for others (backend).
4. Verify lint/build.

### Task 7 impl notes (2026-08-02)
- Checked `backend/src/repositories/document-template.repository.ts` + `document-templates.routes.ts`;
  existing CRUD covers create/update/list. Add `POST /templates/:id/new-version` and
  `POST /templates/:id/set-default` (admin-only, `authorize('SUPER_ADMIN','ETHICS_ADMIN','SYS_ADMIN','ADMIN')`).
- New-version backend: copy code+language+category, `version_no = max+1`, `is_active=true` on new,
  `is_active=false` on old, keep `is_default` on old unless it was default (new becomes default then).
- Frontend `Admin/DocumentTemplates.tsx` gains "New Version" and "Set Default" buttons + confirm dialog.
- Verify eslint + tsc.

### Task 8 — DONE (2026-08-02)
- Audited `queryKey`/`invalidateQueries` across frontend. Two fixes in `DocumentPanel.tsx`:
  invalidations used `doc.entity_id` (BIGINT string from DB) while the query key was
  `['form-documents', instanceId]` (number) → wrapped with `Number(doc.entity_id)` so invalidation
  actually matches. Same pattern already correct in `FormFillPage.tsx`.
- `DocumentTemplates.tsx` uses a single static `['document-templates']` key — no fix needed.
- `VerifyPage.tsx` uses string keys (`ref`/`serial`) consistently — no fix needed.
- Frontend `npx eslint` on all touched files: clean. `tsc -b` still has 2 PRE-EXISTING errors in
  untouched files (`Accreditation/CyclesList.tsx`, `Applications/Detail.tsx`) — confirmed present on
  baseline via `git stash`; not caused by this work.

### Task 8 — BIGINT-vs-number audit (small)
Files: frontend api/sdk calls for ids
- Grep frontend for `queryKey`/`invalidates`/`setQueryData` using ids that may be strings; align
  with `Number(...)` where the backend returns BIGINT as string. Only fix keys used in the document
  flow plus obvious form-instance ones.

### Task 9 — DONE (2026-08-02)
- Backend `npm run lint` (tsc --noEmit): clean. `npm test`: 432 passed, 9 failed — all 9 are the
  PRE-EXISTING failures in `integration.test.ts`/`integration-v2.test.ts` (confirmed identical on
  baseline via `git stash`; unrelated to this work).
- Frontend `npx eslint` on all touched files: clean. `npm run build` (`tsc -b`) still has 2
  PRE-EXISTING errors in untouched files (`Accreditation/CyclesList.tsx`, `Applications/Detail.tsx`).
- Playwright E2E (`scripts` temp script, headless chromium, backend 8080 + frontend 5173): **11/11
  checks passed** for: login → open instance 2 → generate Arabic doc → **no `location.reload`
  (window marker stays alive, zero frame navigations)** → new doc (RVW-2026-XXXX) appears in panel
  without reload → detail dialog shows GENERATED audit → sign → signature recorded → revoke →
  status REVOKED via API → `/verify?ref=<number>` shows REVOKED + revocation reason.
- Supersession (API): generate twice → v1 SUPERSEDED pointing to v2 (current_version_no=2,
  supersedes_version_no=1); public verify of v1 returns SUPERSEDED + superseded_by_number.
- Immutability (DB, as app session): UPDATE of `checksum_sha256` and DELETE on an immutable doc
  both blocked by `trg_documents_immutable` trigger (verified error messages).
- Cleanup: all test-generated rows removed (docs, versions, audit, signatures, generated_documents,
  verification log). Legacy doc 1057 (null document_number) restored to OFFICIAL.
- Note: `e2e_doc_flow.py` sits in a temp dir (`C:\Users\ADM\AppData\Local\Temp\opencode`) — not
  committed to the repo; a committed Playwright suite would be a follow-up.

## Out of scope (deferred)
- PKI/real digital signature crypto — placeholders only.
- Batch issuance / multi-signature approval workflow (document_approvals).
- SDK regen via Orval (types hand-written in parallel with OpenAPI spec update).
- Localizing the PDF itself fully (templates hold ar/en bodies; shell stays as-is).

## Open questions to confirm with user if needed
- Should revoke/void be admin-only or committee-chair only? (Plan assumes admin per existing
  `fn_is_admin` semantics used across the app.)
- Reference format for verify URL: use `document_number` (e.g., `RVW-2026-0005`) — matches how
  certificate serial numbers already work.
