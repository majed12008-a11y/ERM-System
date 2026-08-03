# 11 — Architecture Review Report (Document Subsystem Readiness)

> **Version:** 1.0
> **Status:** For review
> **Scope:** Pre-Gate 0 readiness review of the document subsystem (render engine, legal record, verification, signatures, lifecycle, templates) against the goal of "supporting the next 5–10 years without redesign."
> **Method:** Deep source review (`document-render.service.ts`, `document-render.repository.ts`, `form.service.ts`, middleware schemas, `57-document-infrastructure.sql`) + live PostgreSQL audit (17 tables, 23 RLS policies, 6 orphaned tables, grants, triggers, indexes).
> **Reference:** `00-audit-report.md` (11 defects), `09-api-specs.md`, `10-document-template-specs.md`, `07-migration-roadmap.md`.

---

## 1. Executive summary

The document subsystem is **functionally sound but structurally single-purpose**. The immutable legal-record design (checksum, immutability trigger, SECURITY DEFINER verification, atomic numbering, DB-stored templates) is a strong foundation and should be preserved. However, the architecture conflates **four distinct concerns** into one status column and one render service:

1. **Lifecycle** (draft → … → issued → revoked) — hardcoded as a 4-value CHECK constraint.
2. **Versioning** — implemented as *new document identity + SUPERSEDED flag* rather than a version chain.
3. **Integrity** (file hash) vs **authenticity** (reference lookup) — conflated; the PDF footer displays a **hash of the document number, not of the PDF content** (defect #A-01 below).
4. **Signing** — a single-row append with no order, no status, no PKI-ready metadata.

Verdict: **Gate 0 is required and the right call.** The existing code gives us ~60% of the target model. What is missing is not new capability so much as **decoupling** (status → configurable lifecycle table, rendering → engine pipeline, signing → multi-signature workflow) and **covering** (RLS on orphaned tables, retention/classification/tags/metadata columns, config-driven checksum).

---

## 2. System under review

| Layer | Component | Location |
|---|---|---|
| Route | forms module (generate/sign/lifecycle/documents) | `backend/src/modules/forms/forms.routes.ts` |
| Route | public verification | `backend/src/modules/public/documents.routes.ts` |
| Service | `FormService` (orchestrates) | `backend/src/services/form.service.ts` |
| Service | `DocumentRenderService` (engine) | `backend/src/services/document-render.service.ts` |
| Repository | `DocumentRenderRepository` | `backend/src/repositories/document-render.repository.ts` |
| Repository | `DocumentNumberingRepository` | `backend/src/repositories/document-numbering.repository.ts` |
| DB | Legal record tables | `documents.*` (17 tables) |
| DB | Migration | `backend/seed/57-document-infrastructure.sql` |

### 2.1 Data flow today

```
generateDocument (FormService)
  → findActiveTemplate (template_code, language → is_default, version_no DESC)
  → findDocumentTypeId (category → document_types)
  → numberingRepo.allocate (atomic PREFIX-YYYY-NNNN)
  → findLatestVersionByEntity (for supersession + version_no)
  → Handlebars.compile(body) with {context, lang, documentNumber, dates, committee…}
  → buildShell()  [header, ref row, title, body, signature blocks, QR footer, confidentiality, page numbers]
  → puppeteer-core render PDF → real sha256 of file bytes
  → createDocument (status='OFFICIAL', is_immutable=true, document_uuid)
  → createVersion + createGenerated + logAudit + (markSuperseded if previous)
```

### 2.2 Verified current DB facts (live query)

- `documents.documents` (17 tables in schema): `status` CHECK = `{OFFICIAL, REVOKED, VOID, SUPERSEDED}` only. No DRAFT / UNDER_REVIEW / PENDING_SIGNATURE / APPROVED / ISSUED / EXPIRED / ARCHIVED.
- `documents.documents` RLS: INSERT/SELECT/UPDATE policies; **no DELETE policy** (physical delete blocked by RLS, matches RULE 12). SELECT policy already consults `document_access` (user_id OR role_id via `security.user_roles`).
- **6 tables have RLS disabled** and no `public` grants but full DML to `ethics_app`:
  `document_access`, `document_approvals`, `document_classifications`, `document_disposal_logs`, `document_retention_rules`, `document_types`; also `templates`, `document_verification_log` are RLS-off.
- RLS-enabled but **open** (`USING (true)` SELECT/INSERT): `document_versions`, `document_audit`, `document_signatures`, `generated_documents`, `document_numbering`.
- `document_approvals` has `FK document_id → documents.documents ON DELETE CASCADE` — **cascade can remove audit records**; also a `soft-delete` CHECK (`deleted_at IS NULL OR deleted_by IS NOT NULL`) that does **not** guarantee `deleted_at IS NOT NULL → deleted_by IS NOT NULL` semantics pair (it allows `deleted_by` set with `deleted_at` NULL — minor).
- `document_access`: supports `access_type`, `expires_at`, per-user and per-role grants — **already the access-control substrate**, but no endpoints consume it besides the SELECT policy.

---

## 3. Assessment by dimension

Legend: ✅ strong · 🟡 acceptable with caveats · ❌ blocking for target state.

| Dimension | Grade | Key evidence |
|---|---|---|
| Extensibility | 🟡 | DB-stored Handlebars templates = content changes without redeploy. But status is a CHECK enum, lifecycle rules live in service `WHERE status='OFFICIAL'` guards, signer types live in a Zod enum. Adding a state or signer role requires code + migration. |
| Reusability | ❌ | `DocumentRenderService.render()` is a 15-step monolith (template → type → number → version → shell → QR → puppeteer → checksum → 4 DB writes). No reusable engine components; watermark/checksum/lifecycle logic not separable. |
| Separation of concerns | ❌ | Lifecycle, versioning, supersession, signing, verification, rendering all coupled inside one service + one status column. |
| Performance | ❌ | **One puppeteer browser per render** (launch+close, no pool). Synchronous request blocks 5–15 s. No queue, no cache, no concurrency guard on version allocation. |
| Security | 🟡 | Strong: RLS as sole control, SECURITY DEFINER for public verification, immutable-trigger guard, atomic numbering. Weak: 6 RLS-off tables fully writable by app role; open `USING (true)` child tables; `document_approvals` CASCADE delete; verification endpoint uses reference only (no file). |
| Auditability | ✅ | `document_audit` on all lifecycle events; `system.fn_log_audit()` trigger on supporting tables; immutable records can't be deleted/altered. |
| Regulatory compliance | 🟡 | Confidentiality banner + version + QR are present. Missing: retention rules are never evaluated, no classification/confidentiality level on documents, no disposal workflow, no expiry, checksum display is wrong (A-01). |
| Long-term maintainability | 🟡 | Idempotent migrations, clean repos, Arabic-documented code = good. The orphaned tables (`document_access`, `document_approvals`, etc.) with no consuming code are a maintainability hazard — future devs will reimplement them. |

---

## 4. Findings & design challenges (challenge every decision)

### A-01 ❌ Footer shows a fake checksum
`document-render.service.ts:103`: `sha256 = crypto.createHash('sha256').update(allocated.number).digest('hex')` — hashes the **document number**, then the footer prints its first 16 chars. The real file hash is computed at `:133` and stored in `checksum_sha256`, but the rendered PDF never shows it. Any user comparing the printed hash against the file will see a mismatch and lose trust.
**Fix:** render the PDF bytes first, then derive the displayed hash from `checksum_sha256`.

### A-02 ❌ Verification = reference lookup only, no integrity check
`fn_verify_generated_document` and `GET /verify/:reference` resolve by `document_number | document_uuid` and return status. Nothing verifies that a **given file** is the genuine article. This is the entire gap the `POST /api/documents/checksum` requirement fills.
**Fix:** checksum endpoint computes SHA-256 of the uploaded file, compares to stored `checksum_sha256` by reference, returns `VALID | INVALID | MODIFIED | UNKNOWN` (algorithm configurable). Keep status-verification separate from integrity-verification in the docs.

### A-03 ❌ Status CHECK enum vs configurable lifecycle
`chk_documents_status` is a hardcoded 4-value enum; `setDocumentStatus` guards `WHERE status='OFFICIAL'`; `signDocument` rejects signing if `VOID|REVOKED`. Target lifecycle (`Draft → Under Review → Pending Signature → Approved → Issued → Superseded → Revoked → Expired → Archived`) **cannot** be expressed without code + migration per change.
**Fix:** reference tables `document_lifecycle_states` + `document_lifecycle_transitions` (+ `document_state_actions`), DB function `fn_document_transition()` as the single mutation path, service reads config, CHECK constraint becomes a minimal integrity guard (`state_id` must exist in table).

### A-04 ❌ Single-signature append vs multi-signature workflow
`document_signatures` = one row per signer (signer_id, signature_type, signature_hash, signed_at). `signDocument` blocks re-signing by the same user and accepts a Zod enum of 3 types. No ordering, no per-signature status, no title/affiliation, no certificate/TSA metadata, no requirement/optionality, no enforcement of "all required signers signed before ISSUED."
**Fix:** evolve to full multi-signature model (see Gate 0.1): `signature_type`, `signature_order`, `signature_status`, `signer_title`, `is_required`, `signed_at`, `signature_hash`, future `certificate_metadata`, `verification_metadata`. Signature types become a reference table (`SECRETARY`, `REVIEWER`, `CHAIR`, `INSTITUTIONAL_REPRESENTATIVE`, `APPLICANT`, `APPROVER`), configurable.

### A-05 🟡 Versioning vs supersession conflated
Re-render creates a **new** `documents.documents` row and marks the old row `SUPERSEDED`. Conceptually "v2 of the same document" becomes a distinct identity with its own QR/verify reference. Version chain lives in `document_versions`. This dual identity is confusing and fragments the audit trail across documents.
**Decision needed:** keep supersession-as-new-identity (simpler, each PDF independently verifiable — recommended) and make `document_versions` explicitly a *rendering* history, OR migrate to a true master/version model. The review recommends the former; document it in `05-database-mapping.md`.

### A-06 🟡 Unbounded browser spawn / no concurrency guard
- One puppeteer instance per render → cold-start latency dominates; no pool/reuse, no retry, no timeout isolation.
- `findLatestVersionByEntity` + insert is a read-then-write race: two concurrent generations of the same entity+template+language can both become vN.
**Fix:** browser pool (or `puppeteer-cluster`), and DB-level advisory lock `pg_advisory_xact_lock(hashtext('gen:'||entity_type||':'||entity_id))` around numbering+render commit.

### A-07 ❌ RLS gaps on Gate 0 tables
Per the project invariant ("RLS is the sole access control mechanism — never bypass"), six tables that Gate 0 will touch have RLS **off** and the app role holds full DML:
`document_access`, `document_approvals`, `document_classifications`, `document_disposal_logs`, `document_retention_rules`, `document_types` (+ `templates`, `document_verification_log`).
Also, the child audit tables (`document_versions`, `document_audit`, `document_signatures`, `generated_documents`) are `USING (true)` — readable by every session.
**Fix:** RLS policies per table in the migration (see Database Review deliverable). At minimum: SELECT gated by parent-document visibility (`EXISTS documents_select_policy` semantics), INSERT gated by admin or parent ownership, no DELETE/UPDATE.

### A-08 🟡 No retention / classification / confidentiality / tags / metadata on the legal record
Tables exist (`document_retention_rules`, `document_classifications`, `document_disposal_logs`) but:
- `documents.documents` has **no** `classification_id`, `confidentiality_level`, `retention_rule_id`, `expires_at`, `tags`, or `metadata JSONB`.
- Retention rules are never evaluated; no expiry job; no disposal workflow consuming `disposal_logs`.
**Fix:** columns + reference FKs + `documents.document_metadata` (JSONB extension point for future OCR/seal/TSA metadata). Gate 0 extensions.

### A-09 🟡 Approval workflow duplicated / orphaned
`document_approvals` (approver_id, approval_status, comments, timestamps) exists with no endpoints and no lifecycle hook. It overlaps with `document_signatures`. Either unify (approval = PENDING_SIGNATURE state + signatures) or wire it as the *approval gate* in the lifecycle engine. Recommendation: wire it — `document_approvals` = the *decision* record, `document_signatures` = the *applied signatures* on the issued artifact.

### A-10 🟡 `ON DELETE CASCADE` on `document_approvals.document_id`
Deleting a document row cascades approval records — but documents are immutable legal records. While the parent table has no DELETE policy (RLS blocks), the CASCADE is a latent data-loss path if RLS is ever bypassed. **Fix:** remove CASCADE, keep `RESTRICT`.

### A-11 🟡 Form-status lifecycle lives separately from document lifecycle
`form_instances.status` has its own enum `{DRAFT, SUBMITTED, RETURNED, APPROVED, VOID}`. The document lifecycle must be the *output* lifecycle; the form lifecycle is the *input*. Keep them separate but map the transition (SUBMITTED → can generate; APPROVED → issue). No shared code should mutate both.

### A-12 🟡 BIGINT→string / frontend `Number()`
node-postgres returns BIGINT ids as strings; frontend casts in query keys (`Number(...)`). For `document_approvals.document_id`, `document_access.*` etc. this pattern must be preserved consistently. Also `fn_verify_generated_document` returns `entity_id BIGINT` as string — harmless for the portal.

### A-13 🟡 Checksum algorithm hardcoded in two places
`sha256` appears in the render service (display hash) and the repository storage path, and as a Zod enum nowhere. The checksum API must read the algorithm from config (`CHECKSUM_ALGORITHM=sha256|sha384|sha512`), defaulting to sha256, and the stored hash column must be long enough for sha512 (128 hex chars → column is `VARCHAR`; verify width).

---

## 5. What Gate 0 must build (mapped to findings)

| Gate 0 feature | Kills | Builds on |
|---|---|---|
| 0.1 Multi-signature | A-04, A-09 | `document_signatures` (evolve), `document_approvals` (wire) |
| 0.2 Checksum API `POST /api/documents/checksum` | A-01, A-02, A-13 | `checksum_sha256` column, `document_verification_log` |
| 0.3 Verification portal | A-02 | `fn_verify_generated_document`, portal route |
| 0.4 Watermark engine | (new capability) | `buildShell()` → watermark layer |
| 0.5 Configurable lifecycle | A-03 | status CHECK → state/transition tables + `fn_document_transition()` |
| Retention/classification/confidentiality/categories/tags/metadata | A-08 | existing orphan tables + new columns |
| DB review + RLS hardening | A-07, A-10 | pg_policies audit (see Database Review deliverable) |

## 6. Verdict

| Criterion | Verdict |
|---|---|
| Can the current design support the next 5–10 years? | **No, not as-is.** It is a single-tenant, single-workflow pipeline. |
| Is the foundation worth keeping? | **Yes.** Immutability, RLS-first posture, DB templates, atomic numbering, SECURITY DEFINER verification. |
| Is Gate 0 scope right? | **Yes** — all five features map to concrete defects; the quality-gate documents are required to prevent re-conflation. |
| Gate for proceeding to new forms (per `07-migration-roadmap.md`) | Gate 0 must complete before any new forms are built. |

---

## 7. Open decisions for the reviewer

1. **Supersession model** (A-05): keep new-identity + `SUPERSEDED` (recommended) vs master/version model.
2. **Approvals vs signatures** (A-09): `document_approvals` as decision gate feeding `PENDING_SIGNATURE → APPROVED`, signatures as applied artifacts (recommended).
3. **Lifecycle storage** (A-03): DB reference tables + transition function vs JSON config. Recommend DB tables (queryable, auditable, RLS-able).
4. **Checksum display** (A-01): always show the real file hash on the PDF, truncated to 16 chars (recommended) vs full hash in a separate line.
5. **Retention execution**: background job (node-cron) vs lazy evaluation at read time. Recommend lazy evaluation first, batch job later.
