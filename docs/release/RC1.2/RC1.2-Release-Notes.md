# RC1.2 Release Notes — Evidence & Certificates

## Release Information

| Field | Value |
|---|---|
| Release | RC1.2 |
| Status | **Approved** |
| Date | 2026-07-03 |
| Tag | `git tag rc1.2` |
| Base | RC1.1 (2026-06-24) |

## Executive Summary

RC1.2 completes the Conditions + Evidence module (Phase 2) and the Certificate Subsystem (Phase 3), along with all intermediate stabilization phases. The system now supports the full application lifecycle from DRAFT through APPROVED, including condition management, evidence upload, and certificate generation.

---

## Completed Phases

### Phase 1 — Core Application Workflow ✅
- Application CRUD with multi-state workflow (DRAFT → SUBMITTED → INITIAL_REVIEW → SCIENTIFIC_REVIEW → ETHICAL_REVIEW → COMMITTEE_REVIEW → APPROVED/REJECTED)
- Workflow transitions validated with RLS (10+ states, 20+ transitions)
- Workflow authorization policies enforced

### Phase 1.5 — Committee & Review Infrastructure ✅
- Committee CRUD with member management
- Review assignment and submission
- Meeting scheduling and minutes
- Accreditation cycle management

### Phase 1.6 — Terminal States Hotfix ✅
- Corrected terminal state semantics per RULE 11
- `REJECTED`, `WITHDRAWN`, `ARCHIVED` are true terminals
- `APPROVED` and `CLOSED` are NOT terminal (transitions to CLOSE and ARCHIVE exist)
- Seed `44-fix-terminal-states.sql` applied

### Phase 1.7 — Workflow RLS + Stability ✅
- Workflow initialization RLS fix (seed `43-fix-workflow-init-rls.sql`)
- Workflow transition update RLS fix (seed `42-fix-workflow-update-rls.sql`)
- Idempotent workflow initialization (seed `40-init-workflow-idempotent.sql`)
- Workflow constraints and transitions validated

### Phase 2 — Conditions & Evidence ✅
- Condition CRUD (create, read, update, delete) with severity/category
- Condition resolution workflow (MET, NOT_MET, WAIVED)
- Evidence upload to `documents.documents` with polymorphic `entity_type = 'ApplicationCondition'`
- Evidence DELETE with four-factor authorization matrix (RULE 12)
- RLS policies for condition and evidence tables
- Frontend `ConditionsPanel` with collapsible evidence section per condition

### Phase 3 — Certificate Subsystem ✅
- Automatic certificate generation on `APPROVED` transition (fire-and-forget)
- State machine: DRAFT → GENERATING → ISSUED → REVOKED/SUPERSEDED + FAILED
- Three-layer race prevention: partial unique index + advisory lock + idempotency check
- PDF rendering via puppeteer-core + Handlebars with Noto Sans Arabic fonts
- QR code embedded in certificate for public verification
- Authenticated endpoints: list, get, download, reissue, retry, revoke
- Public verification endpoint (no auth, SECURITY DEFINER bypass for RLS)
- Frontend `CertificatesTab` (download/reissue/retry/revoke) and public `VerifyPage`
- RLS hotfix for committee member access
- Backend lint: 0 errors. Backend tests: 410 pass / 13 pre-existing failures (unrelated)

---

## Certificate Seeds Inventory

| Seed | File | Purpose | RLS Pattern |
|------|------|---------|-------------|
| 45 | `45-certificates.sql` | Schema, tables, domain, indexes, RLS policies (7 policies), default Handlebars template, audit triggers | `current_setting('app.user_id')` without `true` flag |
| 46 | `46-certificate-rls-hotfix.sql` | `fn_is_committee_member_for_application()` helper; updates `cert_select` and `cert_doc_select` policies to include COMMITTEE_CHAIR and REVIEWER | `current_setting('app.user_id', true)` with safe `true` flag |
| 47 | `47-public-verify-function.sql` | `fn_get_certificate_verification()` SECURITY DEFINER function for public verify endpoint (no session user) | Bypasses RLS entirely via SECURITY DEFINER |

## RLS Bypass Architecture

The public verify endpoint has no `app.user_id` set (unauthenticated). Direct SELECT on `documents.approval_certificates` would be blocked by RLS. The solution uses a SECURITY DEFINER function (`documents.fn_get_certificate_verification`) that runs with owner privileges and bypasses RLS. This is the **only** access path that bypasses RLS — all authenticated endpoints use normal RLS-protected queries. See `docs/architecture/phase3-certificate-subsystem.md` §5 for full documentation.

## Known Issues

- 13 pre-existing test failures (unrelated to RC1.2 — messaging, accreditation, document signatures)
- Puppeteer PDF generation depends on local Chrome installation (`puppeteer-core` not `puppeteer`) — non-blocking for MVP
- Port 8080 conflict with httpd (PostgreSQL EnterpriseDB web interface) on some local setups
