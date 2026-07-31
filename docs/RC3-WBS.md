# RC3 Work Breakdown Structure (WBS)

**Date:** 2026-07-17
**Revision:** 2 (Architecture Review Applied)
**Status:** PLANNING ONLY — No implementation, no commits
**Base:** v1.0.0-rc2 (frozen)
**Branch:** New development branch from `v1.0.0-rc2`

---

## Change Log

| Rev | Date | Change | Reason |
|-----|------|--------|--------|
| 1 | 2026-07-17 | Initial WBS | Roadmap approved |
| 2 | 2026-07-17 | E0-02 security verification added; Epic 0 renamed + expanded; Epic 5 added; task counts synchronized; gates updated G0-G5; Release Scorecard added | Architecture review required changes |

---

## Epic Structure

```
Epic 0 — Baseline Certification          (7 tasks, pre-work)
Epic 1 — Security Hardening              (8 tasks, 2-3 days)
Epic 2 — Data Integrity & Validation     (4 tasks, 1.5-2 days)
Epic 3 — Developer Experience            (4 tasks, 0.5-1 day)
Epic 4 — Documentation                   (5 tasks, 2-3 days)
Epic 5 — System Certification            (10 tasks, 2-3 days)
                                       Total: 38 tasks, 8-12 days
```

---

## Epic 0 — Baseline Certification

**Purpose:** Establish the RC3 baseline before any changes. All snapshots become the comparison point for Epic 5 certification. No implementation work — measurement and verification only.

### E0-01: Define `verify` script in root `package.json`

| Field | Value |
|-------|-------|
| **ID** | E0-01 |
| **Title** | Define `npm run verify` composite script |
| **Description** | Create a root-level `verify` script that runs all quality checks in sequence. Define expected output for each check. Do not implement fixes — only define the command and document expected results. |
| **Estimated effort** | 30 min |
| **Dependencies** | None |
| **Files expected to change** | `package.json` (root) — add `"verify"` script |
| **Acceptance criteria** | `npm run verify` runs all 8 checks below; script exists and is documented in AGENTS.md |
| **Rollback strategy** | Remove `"verify"` script from `package.json` |
| **Regression risk** | None — new script, no existing code changes |

**The 8 checks in `verify`:**

| # | Check | Command | Expected |
|---|-------|---------|----------|
| 1 | Backend TypeScript | `cd backend && npx tsc --noEmit` | 0 errors |
| 2 | Frontend TypeScript | `cd frontend && npx tsc -b` | 0 errors |
| 3 | Frontend build | `cd frontend && npm run build` | `tsc -b && vite build` succeeds |
| 4 | Backend lint | `cd backend && npm run lint` | 0 errors (currently = `tsc --noEmit`) |
| 5 | Backend tests | `cd backend && npm test` | All tests pass |
| 6 | Frontend tests | `cd frontend && npm test` | All tests pass |
| 7 | Dependency audit | `cd backend && npm audit --audit-level=high` | 0 high/critical |
| 8 | Security scan | `npm audit --audit-level=high` (both) | 0 high/critical |

### E0-02: Security verification — BackupService exploitation resistance

| Field | Value |
|-------|-------|
| **ID** | E0-02 |
| **Title** | Verify BackupService cannot be exploited via command injection |
| **Description** | PB-002 reported shell injection in `backup.service.ts`. Code inspection shows `execFile` is in use, but this must be verified with active testing. Write and run tests that attempt to exploit the backup service through: (1) shell metacharacters in name (`;`, `|`, `` ` ``, `$()`, `&&`), (2) unicode filenames, (3) filenames with spaces, (4) path traversal (`../../etc/passwd`), (5) long filenames (1000+ chars), (6) invalid characters (`<`, `>`, `"`, `'`). The task is complete only after ALL tests pass demonstrating the service rejects or safely handles every attack vector. |
| **Estimated effort** | 1 hour |
| **Dependencies** | None |
| **Files expected to change** | `backend/src/test/backup-security.test.ts` — new or expanded test file |
| **Acceptance criteria** | All 6 attack categories tested; every test demonstrates safe handling (reject or sanitize); no shell execution occurs; `npm test` passes |
| **Rollback strategy** | Delete test file (tests only, no production code changes) |
| **Regression risk** | None — test-only; verifies existing behavior |

### E0-03: Baseline test count snapshot

| Field | Value |
|-------|-------|
| **ID** | E0-03 |
| **Title** | Record baseline test counts |
| **Description** | Run both test suites and record: (1) total tests, (2) passing, (3) failing, (4) skipped, (5) file count. Save results to `docs/rc3-baseline.json`. This becomes the regression comparison point — Epic 5 must match or improve these numbers. |
| **Estimated effort** | 15 min |
| **Dependencies** | E0-01 (verify script must exist) |
| **Files expected to change** | `docs/rc3-baseline.json` — new file (test counts snapshot) |
| **Acceptance criteria** | `rc3-baseline.json` exists with accurate counts from both `cd backend && npm test` and `cd frontend && npm test` |
| **Rollback strategy** | Delete `rc3-baseline.json` |
| **Regression risk** | None — measurement only |

### E0-04: API snapshot

| Field | Value |
|-------|-------|
| **ID** | E0-04 |
| **Title** | Record baseline API endpoint inventory |
| **Description** | Count all API endpoints by method (GET, POST, PUT, DELETE, PATCH) and module. Record which endpoints have Zod validation, which have `authorize()`, which have neither. Save to `docs/rc3-baseline.json` (append to E0-03 output). This becomes the comparison point for E1 validation coverage and E5-03 API coverage report. |
| **Estimated effort** | 30 min |
| **Dependencies** | None |
| **Files expected to change** | `docs/rc3-baseline.json` — append API inventory |
| **Acceptance criteria** | Complete endpoint inventory with validation/authorization status for every route; numbers match actual route files |
| **Rollback strategy** | Delete `rc3-baseline.json` |
| **Regression risk** | None — measurement only |

### E0-05: Database schema snapshot

| Field | Value |
|-------|-------|
| **ID** | E0-05 |
| **Title** | Record baseline database schema |
| **Description** | Connect to PostgreSQL and snapshot: (1) all schemas, (2) all tables with column counts, (3) all RLS policies, (4) all functions, (5) all indexes. Save to `docs/rc3-baseline.json` (append). This becomes the comparison point for E5-01 database coverage and E5-07 document management verification. |
| **Estimated effort** | 30 min |
| **Dependencies** | Running PostgreSQL instance |
| **Files expected to change** | `docs/rc3-baseline.json` — append schema inventory |
| **Acceptance criteria** | Schema snapshot matches actual database; all tables, policies, functions, indexes counted |
| **Rollback strategy** | Delete `rc3-baseline.json` |
| **Regression risk** | None — read-only queries |

### E0-06: OpenAPI snapshot

| Field | Value |
|-------|-------|
| **ID** | E0-06 |
| **Title** | Record baseline OpenAPI specification |
| **Description** | Parse `backend/openapi/openapi.yaml` and record: (1) total paths, (2) total operations, (3) total schemas, (4) version string. Save to `docs/rc3-baseline.json` (append). This becomes the comparison point for E5-03 API coverage and SDK verification. |
| **Estimated effort** | 15 min |
| **Dependencies** | None |
| **Files expected to change** | `docs/rc3-baseline.json` — append OpenAPI inventory |
| **Acceptance criteria** | OpenAPI snapshot matches actual spec files; version string recorded |
| **Rollback strategy** | Delete `rc3-baseline.json` |
| **Regression risk** | None — read-only parsing |

### E0-07: Coverage baseline

| Field | Value |
|-------|-------|
| **ID** | E0-07 |
| **Title** | Record baseline test coverage metrics |
| **Description** | Run test suites with coverage enabled (if configured) or estimate coverage by: (1) counting test files vs source files, (2) counting tested endpoints vs total endpoints, (3) counting tested repository methods vs total methods. Save to `docs/rc3-baseline.json` (append). If coverage tooling is not configured, record the estimation methodology and numbers. This becomes the comparison point for E5 reports. |
| **Estimated effort** | 30 min |
| **Dependencies** | E0-03, E0-04 |
| **Files expected to change** | `docs/rc3-baseline.json` — append coverage estimates |
| **Acceptance criteria** | Coverage baseline recorded; methodology documented; numbers are reproducible |
| **Rollback strategy** | Delete `rc3-baseline.json` |
| **Regression risk** | None — measurement only |

---

## Epic 1 — Security Hardening

### E1-01: Add `authorize()` to template version submit endpoint

| Field | Value |
|-------|-------|
| **ID** | E1-01 |
| **Title** | Authorize template version submit |
| **Description** | `POST /versions/:id/submit` at `template-version.routes.ts:113` has `authenticate` but no `authorize()`. Any authenticated user can submit a template version for review. Add `authorize(...ADMIN_ROLES)` to restrict to admin users. |
| **Estimated effort** | 15 min |
| **Dependencies** | None |
| **Files expected to change** | `backend/src/modules/templates/template-version.routes.ts` — add `authorize(...ADMIN_ROLES)` to line 113 |
| **Acceptance criteria** | Non-admin users receive 403 on `POST /versions/:id/submit`; admin users can still submit |
| **Rollback strategy** | Remove `authorize()` call from the route |
| **Regression risk** | Low — adding restriction, not changing behavior for authorized users |

### E1-02: Add `authorize()` to template document preview/render endpoints

| Field | Value |
|-------|-------|
| **ID** | E1-02 |
| **Title** | Authorize template document preview and render |
| **Description** | `POST /document/preview` and `POST /document/render` at `template-document.routes.ts:9,19` have `authenticate` but no `authorize()`. Any authenticated user can preview/render any template. Add `authorize(...ADMIN_ROLES)` to both. |
| **Estimated effort** | 15 min |
| **Dependencies** | None |
| **Files expected to change** | `backend/src/modules/templates/template-document.routes.ts` — add `authorize(...ADMIN_ROLES)` to lines 9, 19 |
| **Acceptance criteria** | Non-admin users receive 403 on `POST /document/preview` and `POST /document/render`; admin users can still use both |
| **Rollback strategy** | Remove `authorize()` calls from both routes |
| **Regression risk** | Low — adding restriction; DocumentGenerationSection in frontend is only visible to admin users |

### E1-03: Add Zod validation to template document routes

| Field | Value |
|-------|-------|
| **ID** | E1-03 |
| **Title** | Validate template document request bodies |
| **Description** | `template-document.routes.ts` POST endpoints read `req.body` directly without Zod validation. Define `previewDocumentSchema` and `renderDocumentSchema` in `schemas.ts`, add `validate()` middleware to both routes. |
| **Estimated effort** | 30 min |
| **Dependencies** | None |
| **Files expected to change** | `backend/src/middleware/schemas.ts` — add 2 schemas; `backend/src/modules/templates/template-document.routes.ts` — add `validate()` calls |
| **Acceptance criteria** | Invalid payloads return 400 with `{ success: false, error: "..." }`; valid payloads pass through unchanged |
| **Rollback strategy** | Revert `schemas.ts` additions and `validate()` calls |
| **Regression risk** | Low — may reject previously-accepted malformed payloads (should be caught early) |

### E1-04: Add Zod validation to saved-search routes

| Field | Value |
|-------|-------|
| **ID** | E1-04 |
| **Title** | Validate saved-search request bodies |
| **Description** | `system/index.ts` has `POST /saved-searches` and `PUT /saved-searches/:id` without Zod validation (PB-007). Define `createSavedSearchSchema` and `updateSavedSearchSchema` in `schemas.ts`, add `validate()` middleware. |
| **Estimated effort** | 30 min |
| **Dependencies** | None |
| **Files expected to change** | `backend/src/middleware/schemas.ts` — add 2 schemas; `backend/src/modules/system/index.ts` — add `validate()` calls |
| **Acceptance criteria** | Invalid payloads return 400; valid payloads pass through unchanged |
| **Rollback strategy** | Revert `schemas.ts` and `system/index.ts` changes |
| **Regression risk** | Low — may reject previously-accepted malformed data |

### E1-05: Add Zod validation to remaining unprotected routes (batch 1)

| Field | Value |
|-------|-------|
| **ID** | E1-05 |
| **Title** | Validate auth, role, responsibility routes |
| **Description** | Add Zod schemas and `validate()` middleware to 5 routes: `auth.routes.ts` (refresh, logout, resend-verification — 3 routes), `roles.routes.ts` (PUT /:id — 1 route), `responsibility.routes.ts` (POST /user-responsibilities — 1 route). These are low-risk, isolated changes. |
| **Estimated effort** | 1 hour |
| **Dependencies** | None |
| **Files expected to change** | `backend/src/middleware/schemas.ts` — add schemas; `backend/src/modules/security/auth.routes.ts`; `backend/src/modules/security/roles.routes.ts`; `backend/src/modules/security/responsibility.routes.ts` |
| **Acceptance criteria** | Each route returns 400 on invalid payload, 2xx on valid; `npm run lint` passes |
| **Rollback strategy** | Revert individual route files |
| **Regression risk** | Low — isolated per-file changes |

### E1-06: Add Zod validation to remaining unprotected routes (batch 2)

| Field | Value |
|-------|-------|
| **ID** | E1-06 |
| **Title** | Validate application, evidence, certificate routes |
| **Description** | Add Zod schemas and `validate()` middleware to 7 routes: `applications.routes.ts` (withdraw, appeal, renewal — 3), `evidence.routes.ts` (POST / — 1), `certificate.routes.ts` (reissue, retry, revoke — 3). |
| **Estimated effort** | 1.5 hours |
| **Dependencies** | None |
| **Files expected to change** | `backend/src/middleware/schemas.ts` — add schemas; `backend/src/modules/core/applications.routes.ts`; `backend/src/modules/core/evidence.routes.ts`; `backend/src/modules/core/certificate.routes.ts` |
| **Acceptance criteria** | Each route returns 400 on invalid payload; existing tests pass |
| **Rollback strategy** | Revert individual route files |
| **Regression risk** | Low — isolated per-file changes |

### E1-07: Add Zod validation to remaining unprotected routes (batch 3)

| Field | Value |
|-------|-------|
| **ID** | E1-07 |
| **Title** | Validate committee, meeting, voting routes |
| **Description** | Add Zod schemas and `validate()` middleware to 8 routes: `meetings.routes.ts` (3), `voting.routes.ts` (1), `reviews.routes.ts` (1), `committees.routes.ts` (2), `consent.routes.ts` (1 — approve version only, others may already have validation). |
| **Estimated effort** | 1.5 hours |
| **Dependencies** | None |
| **Files expected to change** | `backend/src/middleware/schemas.ts` — add schemas; `backend/src/modules/committee/meetings.routes.ts`; `backend/src/modules/committee/voting.routes.ts`; `backend/src/modules/committee/reviews.routes.ts`; `backend/src/modules/committee/committees.routes.ts`; `backend/src/modules/committee/consent.routes.ts` |
| **Acceptance criteria** | Each route returns 400 on invalid payload; existing tests pass |
| **Rollback strategy** | Revert individual route files |
| **Regression risk** | Low — isolated per-file changes |

### E1-08: Add Zod validation to remaining unprotected routes (batch 4)

| Field | Value |
|-------|-------|
| **ID** | E1-08 |
| **Title** | Validate safety, communication, admin routes |
| **Description** | Add Zod schemas and `validate()` middleware to remaining routes: `ethics-risk.routes.ts` (1), `documents.routes.ts` (1), `risk.routes.ts` (2), `messages.routes.ts` (1), `backup.routes.ts` (2), `email-config.routes.ts` (3), `push-config.routes.ts` (2), `sms-config.routes.ts` (2), `reference-data.routes.ts` (2), `system-config.routes.ts` (1). |
| **Estimated effort** | 2 hours |
| **Dependencies** | None |
| **Files expected to change** | `backend/src/middleware/schemas.ts` — add schemas; 10 route files across safety, communication, admin modules |
| **Acceptance criteria** | All routes return 400 on invalid payload; `npm run lint` passes; existing tests pass |
| **Rollback strategy** | Revert individual route files |
| **Regression risk** | Low — isolated per-file changes |

---

## Epic 2 — Data Integrity & Validation

### E2-01: Fix `findAll()` performance regression

| Field | Value |
|-------|-------|
| **ID** | E2-01 |
| **Title** | Add `findByTemplateId()` to template version repository |
| **Description** | `template-version.routes.ts:57-62` calls `versionRepo.findAll()` which loads ALL versions across ALL templates, then filters in JS. Add `findByTemplateId(templateId: number)` to `TemplateVersionRepository` that does `SELECT * FROM templates.template_versions WHERE template_id = $1 ORDER BY created_at DESC`. Update the route to use it. |
| **Estimated effort** | 1 hour |
| **Dependencies** | None |
| **Files expected to change** | `backend/src/repositories/template-version.repository.ts` — add `findByTemplateId()`; `backend/src/modules/templates/template-version.routes.ts` — replace `findAll()` + filter with `findByTemplateId()` |
| **Acceptance criteria** | Route returns same results as before; query uses SQL WHERE clause instead of JS filter; `npm run lint` passes |
| **Rollback strategy** | Revert both files to use `findAll()` + filter |
| **Regression risk** | Low — same output, different query plan |

### E2-02: Fix `app.user_id` NaN propagation on versions endpoint

| Field | Value |
|-------|-------|
| **ID** | E2-02 |
| **Title** | Fix NaN user context on template versions endpoint |
| **Description** | `/api/v1/templates/versions` returns `invalid input syntax for type bigint: "NaN"` because `app.user_id` is not propagated from AsyncLocalStorage to the repository query. The issue is in how the versions route extracts the user from the request — it likely reads `req.user.id` but the middleware sets it differently. Trace the user extraction and fix the mapping. |
| **Estimated effort** | 2 hours |
| **Dependencies** | None |
| **Files expected to change** | `backend/src/modules/templates/template-version.routes.ts` — fix user ID extraction; possibly `backend/src/middleware/context.ts` — verify AsyncLocalStorage propagation |
| **Acceptance criteria** | `GET /api/v1/templates/versions` returns valid data (no NaN errors); `app.user_id` is correctly set in database sessions |
| **Rollback strategy** | Revert route file changes |
| **Regression risk** | Medium — context propagation is delicate; verify with existing tests |

### E2-03: Fix update schema `.default()` overwrite behavior

| Field | Value |
|-------|-------|
| **ID** | E2-03 |
| **Title** | Prevent unintended field overwrite in partial updates |
| **Description** | `updateEmailConfigSchema`, `updateSmsConfigSchema`, `updatePushConfigSchema` in `schemas.ts` use `.partial(createSchema)` where create schemas have `.default()`. When `.partial()` is applied, `.default()` still fires for unprovided fields, overwriting existing DB values with empty defaults during PUT. Replace `.default()` with `.optional()` in update schemas. |
| **Estimated effort** | 2 hours |
| **Dependencies** | E1-08 (schemas should be in place) |
| **Files expected to change** | `backend/src/middleware/schemas.ts` — modify `updateEmailConfigSchema`, `updateSmsConfigSchema`, `updatePushConfigSchema` |
| **Acceptance criteria** | PUT with partial body preserves unprovided fields; create routes still accept omitted optional fields with defaults; existing tests pass |
| **Rollback strategy** | Revert schema changes in `schemas.ts` |
| **Regression risk** | Medium — changing default behavior; must verify both create and update paths |

### E2-04: Fix SDK `correlationId` type mismatch

| Field | Value |
|-------|-------|
| **ID** | E2-04 |
| **Title** | Align SDK render result type with backend response |
| **Description** | `templates.sdk.ts` types the render response as including `correlationId`, but the backend does not return this field. Either add `correlationId` to the backend response or remove it from the SDK type. Recommended: remove from SDK type (backend doesn't generate correlation IDs). |
| **Estimated effort** | 15 min |
| **Dependencies** | None |
| **Files expected to change** | `frontend/src/sdk/domains/templates.sdk.ts` — remove `correlationId` from `RenderDocumentResult` type; possibly `frontend/src/sdk/core/types.ts` |
| **Acceptance criteria** | `tsc -b` passes; SDK type matches backend response exactly |
| **Rollback strategy** | Revert SDK type changes |
| **Regression risk** | None — type-only change, no runtime behavior |

---

## Epic 3 — Developer Experience & Tooling

### E3-01: Fix `tsc --noEmit` no-op in root tsconfig

| Field | Value |
|-------|-------|
| **ID** | E3-01 |
| **Title** | Make root TypeScript check meaningful |
| **Description** | Root `tsconfig.json` has `"files": []` which makes `tsc --noEmit` check nothing. Two options: (A) remove `"files": []` and let it check all referenced projects, or (B) update CI and AGENTS.md to use `tsc -b` instead. Recommended: Option B — keep root tsconfig as-is (it's a project references container) and update documentation to use `tsc -b` as the lint command. |
| **Estimated effort** | 30 min |
| **Dependencies** | None |
| **Files expected to change** | `AGENTS.md` — update lint command documentation; `.github/workflows/ci.yml` — if CI uses `tsc --noEmit`, change to `tsc -b` |
| **Acceptance criteria** | CI lint step runs real type checking; AGENTS.md documents correct command |
| **Rollback strategy** | Revert documentation changes |
| **Regression risk** | None — documentation/CI only |

### E3-02: Fix email failure silent swallow

| Field | Value |
|-------|-------|
| **ID** | E3-02 |
| **Title** | Log email delivery failures |
| **Description** | `auth.service.ts:175,218` has `.catch(() => {})` which silently swallows email failures. Replace with `.catch((err) => logger.warn({ err, email }, 'Email delivery failed'))` so failures are observable. Do not throw — email failure should not block registration/password reset. |
| **Estimated effort** | 15 min |
| **Dependencies** | None |
| **Files expected to change** | `backend/src/services/auth.service.ts` — replace 2 `.catch(() => {})` with logged catches |
| **Acceptance criteria** | Email failures are logged at warn level; registration/password reset still succeeds when email fails |
| **Rollback strategy** | Revert `auth.service.ts` changes |
| **Regression risk** | None — logging only, no behavior change |

### E3-03: Add `*.dump` to `.gitignore`

| Field | Value |
|-------|-------|
| **ID** | E3-03 |
| **Title** | Exclude backup dump files from git tracking |
| **Description** | `backend/backups/` contains 12 `.dump` files (up to 14 MB) that are not in `.gitignore`. Add `*.dump` to `.gitignore` and remove tracked dump files from git index (not from disk). |
| **Estimated effort** | 15 min |
| **Dependencies** | None |
| **Files expected to change** | `.gitignore` — add `*.dump`; git index — `git rm --cached backend/backups/*.dump` |
| **Acceptance criteria** | `git status` shows dump files as untracked; `.gitignore` contains `*.dump` |
| **Rollback strategy** | Remove `*.dump` from `.gitignore`; `git add` the dump files back |
| **Regression risk** | None — repo hygiene only |

### E3-04: Configure frontend ESLint properly

| Field | Value |
|-------|-------|
| **ID** | E3-04 |
| **Title** | Wire up meaningful ESLint for frontend |
| **Description** | `frontend/package.json` has `"lint": "eslint ."` but the ESLint config may not be doing useful work. Verify the ESLint config, ensure it runs without errors, and integrate it into the verify command. |
| **Estimated effort** | 1 hour |
| **Dependencies** | None |
| **Files expected to change** | `frontend/eslint.config.js` — verify/update; `frontend/package.json` — verify lint script |
| **Acceptance criteria** | `cd frontend && npm run lint` runs and passes; catches real issues (unused imports, etc.) |
| **Rollback strategy** | Revert ESLint config changes |
| **Regression risk** | Low — may surface existing lint issues that need fixing |

---

## Epic 4 — Documentation

### E4-01: Update AGENTS.md with RC3 commands

| Field | Value |
|-------|-------|
| **ID** | E4-01 |
| **Title** | Update AGENTS.md development commands |
| **Description** | Update AGENTS.md to reflect: (1) `npm run verify` as the quality gate, (2) correct lint command (`tsc -b` for frontend, `tsc --noEmit` for backend), (3) new branch workflow from `v1.0.0-rc2`, (4) any changed test commands. |
| **Estimated effort** | 30 min |
| **Dependencies** | E3-01 |
| **Files expected to change** | `AGENTS.md` — update Development commands section |
| **Acceptance criteria** | AGENTS.md accurately reflects current project commands and workflow |
| **Rollback strategy** | Revert `AGENTS.md` changes |
| **Regression risk** | None — documentation only |

### E4-02: Write API reference guide

| Field | Value |
|-------|-------|
| **ID** | E4-02 |
| **Title** | Create consumer-facing API documentation |
| **Description** | Write `docs/api-reference.md` documenting all API modules, authentication flow, pagination, error responses, and rate limits. Reference OpenAPI specs as the source of truth. Include examples for key endpoints (login, list applications, template operations). |
| **Estimated effort** | 4 hours |
| **Dependencies** | E1-01 through E1-08 (API should be finalized) |
| **Files expected to change** | `docs/api-reference.md` — new file |
| **Acceptance criteria** | Document covers all 15 API modules; includes auth flow, pagination, error format; examples work against running backend |
| **Rollback strategy** | Delete the file |
| **Regression risk** | None — new documentation |

### E4-03: Write deployment guide

| Field | Value |
|-------|-------|
| **ID** | E4-03 |
| **Title** | Create step-by-step deployment documentation |
| **Description** | Write `docs/deployment-guide.md` covering: (1) prerequisites (Node 22+, PostgreSQL 18+, Docker), (2) local development setup, (3) Docker Compose deployment, (4) manual deployment steps, (5) environment variable reference, (6) database migration/seed order, (7) health check verification. |
| **Estimated effort** | 3 hours |
| **Dependencies** | None |
| **Files expected to change** | `docs/deployment-guide.md` — new file |
| **Acceptance criteria** | New developer can deploy from scratch using only this guide; covers all env vars from `.env.example` |
| **Rollback strategy** | Delete the file |
| **Regression risk** | None — new documentation |

### E4-04: Write admin user manual (template management)

| Field | Value |
|-------|-------|
| **ID** | E4-04 |
| **Title** | Create template management user guide |
| **Description** | Write `docs/user-guide-templates.md` covering: (1) template library navigation, (2) creating templates, (3) managing versions, (4) lifecycle (DRAFT→REVIEW→APPROVED), (5) preview and render, (6) variable inspector, (7) snapshot verification, (8) rollback. Include screenshots references from `docs/screenshots/rc2/`. |
| **Estimated effort** | 3 hours |
| **Dependencies** | E1-01 through E1-03 (template security finalized) |
| **Files expected to change** | `docs/user-guide-templates.md` — new file |
| **Acceptance criteria** | Admin can manage templates end-to-end using only this guide; covers all template UI pages |
| **Rollback strategy** | Delete the file |
| **Regression risk** | None — new documentation |

### E4-05: Write database seed reference

| Field | Value |
|-------|-------|
| **ID** | E4-05 |
| **Title** | Document all 64 seed SQL files |
| **Description** | Write `docs/seed-reference.md` documenting each seed file in `backend/seed/` (00 through 99): purpose, tables touched, dependencies on other seeds, whether idempotent. Group by domain (security, core, committee, etc.). |
| **Estimated effort** | 2 hours |
| **Dependencies** | None |
| **Files expected to change** | `docs/seed-reference.md` — new file |
| **Acceptance criteria** | All 64 seed files documented; execution order explained; idempotency noted |
| **Rollback strategy** | Delete the file |
| **Regression risk** | None — new documentation |

---

## Epic 5 — System Certification

**Purpose:** Comprehensive system-wide certification before RC3 release. Every task produces a report. All reports must PASS before the RC3 tag is created. No code changes — verification and reporting only.

### E5-01: Database coverage report

| Field | Value |
|-------|-------|
| **ID** | E5-01 |
| **Title** | Produce database coverage report |
| **Description** | Compare current database schema against E0-05 baseline snapshot. Report: (1) tables with/without RLS, (2) tables with/without audit triggers, (3) policies per table, (4) functions count, (5) indexes count, (6) any schema drift from seed files. Save report to `docs/rc3-certification/database-coverage.md`. |
| **Estimated effort** | 1 hour |
| **Dependencies** | E0-05 (baseline schema snapshot) |
| **Files expected to change** | `docs/rc3-certification/database-coverage.md` — new file |
| **Acceptance criteria** | Report shows 0 regressions from baseline; all tables have RLS; all audit triggers present |
| **Rollback strategy** | Delete report file |
| **Regression risk** | None — read-only queries |

### E5-02: Workflow coverage report

| Field | Value |
|-------|-------|
| **ID** | E5-02 |
| **Title** | Produce workflow coverage report |
| **Description** | Verify all workflow states defined in `Workflow-Implementation-Contract.md` (15 states) are implemented. For each state: (1) verify it exists in the database, (2) verify transitions are defined, (3) verify RLS policies allow/disallow correctly, (4) verify UI displays the state. Compare against workflow seed data. Save to `docs/rc3-certification/workflow-coverage.md`. |
| **Estimated effort** | 2 hours |
| **Dependencies** | E0-05 (baseline schema snapshot) |
| **Files expected to change** | `docs/rc3-certification/workflow-coverage.md` — new file |
| **Acceptance criteria** | All 15 workflow states verified; all transitions documented; no missing states or transitions |
| **Rollback strategy** | Delete report file |
| **Regression risk** | None — read-only verification |

### E5-03: API coverage report

| Field | Value |
|-------|-------|
| **ID** | E5-03 |
| **Title** | Produce API coverage report |
| **Description** | Compare current API endpoints against E0-04 baseline snapshot and OpenAPI spec. Report: (1) endpoints with Zod validation, (2) endpoints with `authorize()`, (3) endpoints with both, (4) endpoints with neither, (5) new endpoints since baseline, (6) removed endpoints. Verify SDK methods map 1:1 to backend routes. Save to `docs/rc3-certification/api-coverage.md`. |
| **Estimated effort** | 2 hours |
| **Dependencies** | E0-04 (baseline API snapshot), E0-06 (OpenAPI snapshot), Epic 1 complete |
| **Files expected to change** | `docs/rc3-certification/api-coverage.md` — new file |
| **Acceptance criteria** | 0 endpoints without validation; 0 endpoints without authorization; SDK 1:1 with backend |
| **Rollback strategy** | Delete report file |
| **Regression risk** | None — read-only verification |

### E5-04: Role coverage report

| Field | Value |
|-------|-------|
| **ID** | E5-04 |
| **Title** | Produce role-based access coverage report |
| **Description** | For every endpoint that requires authorization: (1) verify `authorize()` is present, (2) verify correct roles are listed, (3) verify RLS policies enforce role-based access at DB level. Cross-reference with the role hierarchy defined in the system. Save to `docs/rc3-certification/role-coverage.md`. |
| **Estimated effort** | 2 hours |
| **Dependencies** | E1-01, E1-02 (authorize gaps closed) |
| **Files expected to change** | `docs/rc3-certification/role-coverage.md` — new file |
| **Acceptance criteria** | Every write endpoint has `authorize()`; role assignments match business requirements |
| **Rollback strategy** | Delete report file |
| **Regression risk** | None — read-only verification |

### E5-05: UI coverage report

| Field | Value |
|-------|-------|
| **ID** | E5-05 |
| **Title** | Produce UI page coverage report |
| **Description** | Verify all frontend pages render without errors: (1) login, (2) dashboard, (3) applications list/detail, (4) templates library/detail/preview/version, (5) committees/meetings/reviews, (6) documents, (7) notifications, (8) reports, (9) admin pages. Capture screenshots for each. Verify i18n keys exist for Arabic and English. Save to `docs/rc3-certification/ui-coverage.md`. |
| **Estimated effort** | 3 hours |
| **Dependencies** | None |
| **Files expected to change** | `docs/rc3-certification/ui-coverage.md` — new file; `docs/screenshots/rc3/` — new screenshots |
| **Acceptance criteria** | Every page renders without JS errors; both languages work; screenshots captured |
| **Rollback strategy** | Delete report file and screenshots |
| **Regression risk** | None — read-only verification |

### E5-06: Report coverage report

| Field | Value |
|-------|-------|
| **ID** | E5-06 |
| **Title** | Produce reporting module coverage report |
| **Description** | Verify the reporting module: (1) all report types generate without errors, (2) PDF export works, (3) Excel export works, (4) report endpoints return valid data, (5) charts render in UI. Save to `docs/rc3-certification/report-coverage.md`. |
| **Estimated effort** | 2 hours |
| **Dependencies** | None |
| **Files expected to change** | `docs/rc3-certification/report-coverage.md` — new file |
| **Acceptance criteria** | All report types generate; PDF and Excel exports work; no errors |
| **Rollback strategy** | Delete report file |
| **Regression risk** | None — read-only verification |

### E5-07: Document management verification

| Field | Value |
|-------|-------|
| **ID** | E5-07 |
| **Title** | Verify document management lifecycle |
| **Description** | Verify the complete document lifecycle: (1) upload succeeds, (2) download succeeds, (3) RLS prevents unauthorized access, (4) soft delete works, (5) physical delete is blocked, (6) entity linking works, (7) audit trail records document events. Save to `docs/rc3-certification/document-management.md`. |
| **Estimated effort** | 2 hours |
| **Dependencies** | E0-05 (baseline schema snapshot) |
| **Files expected to change** | `docs/rc3-certification/document-management.md` — new file |
| **Acceptance criteria** | All 7 document lifecycle operations verified; RLS enforced; audit trail intact |
| **Rollback strategy** | Delete report file |
| **Regression risk** | None — read-only verification |

### E5-08: Backup and restore certification

| Field | Value |
|-------|-------|
| **ID** | E5-08 |
| **Title** | Certify backup and restore functionality |
| **Description** | End-to-end backup cycle: (1) create backup, (2) verify backup, (3) list backups, (4) restore from backup, (5) verify data integrity after restore, (6) delete backup. Verify E0-02 security tests still pass. Verify `execFile` is used (no shell). Save to `docs/rc3-certification/backup-restore.md`. |
| **Estimated effort** | 2 hours |
| **Dependencies** | E0-02 (security verification), E1-08 (backup routes validated) |
| **Files expected to change** | `docs/rc3-certification/backup-restore.md` — new file |
| **Acceptance criteria** | Full backup cycle works; security tests pass; no shell injection vectors |
| **Rollback strategy** | Delete report file |
| **Regression risk** | None — verification against running system |

### E5-09: Performance certification

| Field | Value |
|-------|-------|
| **ID** | E5-09 |
| **Title** | Verify no performance regressions |
| **Description** | Verify: (1) `findByTemplateId()` is used instead of `findAll()` + filter (E2-01), (2) no full-table scans on critical paths, (3) build time is within acceptable limits (< 10s), (4) page load time is acceptable, (5) API response times are within SLA. Save to `docs/rc3-certification/performance.md`. |
| **Estimated effort** | 2 hours |
| **Dependencies** | E2-01 (performance fix) |
| **Files expected to change** | `docs/rc3-certification/performance.md` — new file |
| **Acceptance criteria** | No full-table scans; build < 10s; API responses < 500ms for standard operations |
| **Rollback strategy** | Delete report file |
| **Regression risk** | None — measurement only |

### E5-10: Final release certification

| Field | Value |
|-------|-------|
| **ID** | E5-10 |
| **Title** | Produce final release certification report |
| **Description** | Aggregate all Epic 5 reports into a single release certification. Compare test counts against E0-03 baseline (must match or improve). Verify `npm run verify` passes. Verify all E5-01 through E5-09 reports are PASS. Produce the Release Scorecard (see Release Scorecard section below). Save to `docs/rc3-certification/release-certification.md`. |
| **Estimated effort** | 2 hours |
| **Dependencies** | E0-03 (baseline test counts), E5-01 through E5-09 (all reports) |
| **Files expected to change** | `docs/rc3-certification/release-certification.md` — new file |
| **Acceptance criteria** | All E5 reports PASS; test counts match or improve baseline; Release Scorecard all PASS |
| **Rollback strategy** | Delete report file |
| **Regression risk** | None — aggregation and comparison only |

---

## Dependency Graph

```
Epic 0 (Baseline Certification)
  ├── E0-01 (verify script)                    ← no deps
  ├── E0-02 (security verification)            ← no deps
  ├── E0-03 (test count snapshot)              ← depends on E0-01
  ├── E0-04 (API snapshot)                     ← no deps
  ├── E0-05 (DB schema snapshot)               ← no deps (needs running DB)
  ├── E0-06 (OpenAPI snapshot)                 ← no deps
  └── E0-07 (coverage baseline)                ← depends on E0-03, E0-04

Epic 1 (Security Hardening) — all tasks parallelizable
  ├── E1-01 (authorize submit)                 ← no deps
  ├── E1-02 (authorize document)               ← no deps
  ├── E1-03 (validate document)                ← no deps
  ├── E1-04 (validate saved-search)            ← no deps
  ├── E1-05 (validate auth/role)               ← no deps
  ├── E1-06 (validate app/evidence/cert)       ← no deps
  ├── E1-07 (validate committee)               ← no deps
  └── E1-08 (validate safety/comm/admin)       ← no deps

Epic 2 (Data Integrity)
  ├── E2-01 (findByTemplateId)                 ← no deps
  ├── E2-02 (NaN propagation)                  ← no deps
  ├── E2-03 (update schema defaults)           ← depends on E1-08 (schemas exist)
  └── E2-04 (SDK correlationId)                ← no deps

Epic 3 (Developer Experience)
  ├── E3-01 (tsc --noEmit)                     ← no deps
  ├── E3-02 (email failure logging)            ← no deps
  ├── E3-03 (gitignore dumps)                  ← no deps
  └── E3-04 (ESLint config)                    ← no deps

Epic 4 (Documentation)
  ├── E4-01 (AGENTS.md update)                 ← depends on E3-01
  ├── E4-02 (API reference)                    ← depends on E1-01..E1-08
  ├── E4-03 (Deployment guide)                 ← no deps
  ├── E4-04 (Admin user manual)                ← depends on E1-01..E1-03
  └── E4-05 (Seed reference)                   ← no deps

Epic 5 (System Certification) — sequential within, some parallelism possible
  ├── E5-01 (DB coverage)                      ← depends on E0-05
  ├── E5-02 (Workflow coverage)                ← depends on E0-05
  ├── E5-03 (API coverage)                     ← depends on E0-04, E0-06, Epic 1
  ├── E5-04 (Role coverage)                    ← depends on E1-01, E1-02
  ├── E5-05 (UI coverage)                      ← no deps (but best after Epics 1-3)
  ├── E5-06 (Report coverage)                  ← no deps
  ├── E5-07 (Document management)              ← depends on E0-05
  ├── E5-08 (Backup/restore)                   ← depends on E0-02, E1-08
  ├── E5-09 (Performance)                      ← depends on E2-01
  └── E5-10 (Final certification)              ← depends on E0-03, E5-01..E5-09
```

### Parallelizable Groups

| Group | Tasks | Can Run In Parallel |
|-------|-------|-------------------|
| G0 | E0-01, E0-02, E0-04, E0-05, E0-06 | **Yes** — independent baselines |
| G1 | E1-01, E1-02, E1-03, E1-04, E1-05, E1-06, E1-07, E1-08 | **Yes** — all independent route changes |
| G2 | E2-01, E2-02, E2-04 | **Yes** — all independent fixes |
| G3 | E3-01, E3-02, E3-03, E3-04 | **Yes** — all independent DX changes |
| G4 | E4-03, E4-05 | **Yes** — independent docs |
| G5 | E4-02, E4-04 | **Yes** — but both depend on Epic 1 |
| G6 | E5-01, E5-02, E5-05, E5-06, E5-07 | **Yes** — independent reports (after E0 baselines) |
| G7 | E5-03, E5-04 | **Yes** — but both depend on Epic 1 |
| G8 | E5-08, E5-09 | **Yes** — but depend on earlier tasks |

---

## Review Gates

### Gate G0: Baseline Certification (Before RC3 Starts)

| Check | Reviewer | Criteria |
|-------|----------|----------|
| `npm run verify` passes | Engineer | All 8 checks green |
| Branch created from `v1.0.0-rc2` | Engineer | Clean branch, no RC2 commits |
| E0-02 security verification passes | Security lead | All 6 attack vectors tested and safe |
| Baseline snapshots complete (E0-03..E0-07) | Tech lead | `rc3-baseline.json` exists with all sections |

### Gate G1: Security (After Epic 1)

| Check | Reviewer | Criteria |
|-------|----------|----------|
| **Security Review** | Security lead | All 3 authorize gaps closed; all POST/PUT/PATCH routes have Zod validation |
| **Code Review** | Peer engineer | Each route change is isolated; no behavior change for authorized users |
| **Functional Review** | QA | Existing E2E tests pass; invalid payloads return 400 on all new validation |
| `npm run verify` passes | CI | All 8 checks green |

### Gate G2: Data Integrity (After Epic 2)

| Check | Reviewer | Criteria |
|-------|----------|----------|
| **Code Review** | Peer engineer | `findByTemplateId()` is correct SQL; NaN fix doesn't break other endpoints |
| **Functional Review** | QA | Template versions endpoint returns valid data; partial updates preserve fields |
| **Performance Review** | Tech lead | No full-table scans; query uses proper index |
| `npm run verify` passes | CI | All 8 checks green |

### Gate G3: Developer Experience (After Epic 3)

| Check | Reviewer | Criteria |
|-------|----------|----------|
| **Code Review** | Peer engineer | Email failure logging is non-blocking; gitignore changes are safe |
| **CI Review** | DevOps | Lint command runs real type checking |
| `npm run verify` passes | CI | All 8 checks green |

### Gate G4: Documentation (After Epic 4)

| Check | Reviewer | Criteria |
|-------|----------|----------|
| **Documentation Review** | Tech lead | All docs are accurate, complete, and reference correct commands |
| **Security Review** | Security lead | No sensitive data in docs; no credentials mentioned |
| `npm run verify` passes | CI | All 8 checks green |

### Gate G5: System Certification (After Epic 5)

| Check | Reviewer | Criteria |
|-------|----------|----------|
| **E5-01 DB Coverage** | DBA | Report PASS — 0 regressions from baseline |
| **E5-02 Workflow Coverage** | Tech lead | Report PASS — all 15 states verified |
| **E5-03 API Coverage** | Security lead | Report PASS — 0 endpoints without validation/authorization |
| **E5-04 Role Coverage** | Security lead | Report PASS — all write endpoints authorized |
| **E5-05 UI Coverage** | QA | Report PASS — all pages render without errors |
| **E5-06 Report Coverage** | QA | Report PASS — all report types generate |
| **E5-07 Document Management** | QA | Report PASS — full lifecycle verified |
| **E5-08 Backup/Restore** | DevOps | Report PASS — full cycle works, security verified |
| **E5-09 Performance** | Tech lead | Report PASS — no regressions |
| **E5-10 Final Certification** | Release manager | All E5 reports PASS; Release Scorecard all PASS |

### RC3 Release Gate

| Check | Reviewer | Criteria |
|-------|----------|----------|
| All gates G0-G5 pass | Release manager | Every gate has PASS status |
| Release Scorecard all PASS | Release manager | See Release Scorecard below |
| `npm run verify` passes | CI | Final run, all 8 checks green |
| **RC3 tag created** | Release manager | `v1.0.0-rc3` points to release commit |

---

## Release Scorecard

The RC3 Release Scorecard must be completed before the `v1.0.0-rc3` tag is created. Every item must be PASS. Any FAIL blocks the release.

| # | Category | Metric | PASS Criteria | Source |
|---|----------|--------|---------------|--------|
| 1 | **Unit Tests** | Backend test count | ≥ baseline (E0-03) | `cd backend && npm test` |
| 2 | **Unit Tests** | Frontend test count | ≥ baseline (E0-03) | `cd frontend && npm test` |
| 3 | **Integration Tests** | E2E scenario count | ≥ baseline (E0-03) | `cd backend && npm test` (integration) |
| 4 | **API Coverage** | Endpoints with Zod validation | 100% of POST/PUT/PATCH | E5-03 report |
| 5 | **API Coverage** | Endpoints with authorize() | 100% of write endpoints | E5-03 report |
| 6 | **Database Coverage** | Tables with RLS | 100% | E5-01 report |
| 7 | **Database Coverage** | Audit triggers | 100% of transaction tables | E5-01 report |
| 8 | **Workflow Coverage** | States implemented | 15/15 | E5-02 report |
| 9 | **Workflow Coverage** | Transitions defined | All valid transitions | E5-02 report |
| 10 | **Security Findings** | High/critical vulnerabilities | 0 | `npm audit --audit-level=high` |
| 11 | **Security Findings** | Shell injection vectors | 0 exploitable | E0-02 + E5-08 reports |
| 12 | **Performance** | Build time | < 10 seconds | E5-09 report |
| 13 | **Performance** | Full-table scans on critical paths | 0 | E5-09 report |
| 14 | **Documentation** | AGENTS.md accuracy | Current commands documented | E4-01 |
| 15 | **Documentation** | API reference exists | Complete | E4-02 |
| 16 | **Documentation** | Deployment guide exists | Complete | E4-03 |
| 17 | **Backup & Restore** | Full cycle works | Create → Verify → Restore → Verify | E5-08 report |
| 18 | **Backup & Restore** | Security | No shell injection | E0-02 + E5-08 reports |
| 19 | **Build** | `npm run verify` | All 8 checks green | E0-01 |
| 20 | **Build** | `tsc -b` passes | 0 errors | CI |

### Scorecard Verdict

```
IF all 20 items = PASS → GO for RC3 tagging
IF any item = FAIL     → NO-GO, fix required before tagging
```

---

## Execution Sequence

### Phase 0: Baseline Certification (Day 0)

| Step | Task | Duration | Parallel? |
|------|------|----------|-----------|
| 1 | Create branch from `v1.0.0-rc2` | 5 min | — |
| 2 | E0-01: Define `npm run verify` | 30 min | — |
| 3 | E0-02: Security verification (backup) | 1 hour | With E0-04, E0-05, E0-06 |
| 4 | E0-04: API snapshot | 30 min | With E0-02, E0-05, E0-06 |
| 5 | E0-05: DB schema snapshot | 30 min | With E0-02, E0-04, E0-06 |
| 6 | E0-06: OpenAPI snapshot | 15 min | With E0-02, E0-04, E0-05 |
| 7 | E0-03: Test count snapshot | 15 min | After E0-01 |
| 8 | E0-07: Coverage baseline | 30 min | After E0-03, E0-04 |
| 9 | Run `npm run verify` — establish baseline | 5 min | — |
| 10 | **Gate G0: Baseline Certification** | 30 min | — |
| **Total** | | **3-4 hours** | |

### Phase 1: Security Hardening (Days 1-3)

All Epic 1 tasks can run in parallel.

| Step | Task | Duration | Parallel? |
|------|------|----------|-----------|
| 11 | E1-01: Authorize submit endpoint | 15 min | With E1-02..E1-08 |
| 12 | E1-02: Authorize document endpoints | 15 min | With E1-01, E1-03..E1-08 |
| 13 | E1-03: Validate document routes | 30 min | With E1-01, E1-02, E1-04..E1-08 |
| 14 | E1-04: Validate saved-search routes | 30 min | With E1-01..E1-03, E1-05..E1-08 |
| 15 | E1-05: Validate auth/role routes | 1 hour | With E1-01..E1-04, E1-06..E1-08 |
| 16 | E1-06: Validate app/evidence/cert routes | 1.5 hours | With E1-01..E1-05, E1-07..E1-08 |
| 17 | E1-07: Validate committee routes | 1.5 hours | With E1-01..E1-06, E1-08 |
| 18 | E1-08: Validate safety/comm/admin routes | 2 hours | With E1-01..E1-07 |
| 19 | **Gate G1: Security + Code + Functional review** | 2 hours | — |
| **Total** | | **2-3 days** | (with parallelism) |

### Phase 2: Data Integrity (Days 3-5)

| Step | Task | Duration | Parallel? |
|------|------|----------|-----------|
| 20 | E2-01: Fix findAll() regression | 1 hour | With E2-02, E2-04 |
| 21 | E2-02: Fix NaN propagation | 2 hours | With E2-01, E2-04 |
| 22 | E2-04: Fix SDK correlationId | 15 min | With E2-01, E2-02 |
| 23 | E2-03: Fix update schema defaults | 2 hours | After E1-08 |
| 24 | **Gate G2: Code + Functional + Performance review** | 2 hours | — |
| **Total** | | **1.5-2 days** | (with parallelism) |

### Phase 3: Developer Experience (Days 4-5, parallel with Phase 2)

| Step | Task | Duration | Parallel? |
|------|------|----------|-----------|
| 25 | E3-01: Fix tsc --noEmit | 30 min | With E3-02, E3-03, E3-04 |
| 26 | E3-02: Fix email failure logging | 15 min | With E3-01, E3-03, E3-04 |
| 27 | E3-03: Add *.dump to gitignore | 15 min | With E3-01, E3-02, E3-04 |
| 28 | E3-04: Configure ESLint | 1 hour | With E3-01..E3-03 |
| 29 | **Gate G3: Code + CI review** | 1 hour | — |
| **Total** | | **0.5-1 day** | (with parallelism) |

### Phase 4: Documentation (Days 5-7)

| Step | Task | Duration | Parallel? |
|------|------|----------|-----------|
| 30 | E4-01: Update AGENTS.md | 30 min | After E3-01 |
| 31 | E4-03: Write deployment guide | 3 hours | With E4-05 |
| 32 | E4-05: Write seed reference | 2 hours | With E4-03 |
| 33 | E4-02: Write API reference | 4 hours | After Epic 1 |
| 34 | E4-04: Write admin user manual | 3 hours | After E1-01..E1-03 |
| 35 | **Gate G4: Documentation + Security review** | 2 hours | — |
| **Total** | | **2-3 days** | (with parallelism) |

### Phase 5: System Certification (Days 7-9)

| Step | Task | Duration | Parallel? |
|------|------|----------|-----------|
| 36 | E5-01: DB coverage report | 1 hour | With E5-02, E5-05, E5-06, E5-07 |
| 37 | E5-02: Workflow coverage report | 2 hours | With E5-01, E5-05, E5-06, E5-07 |
| 38 | E5-05: UI coverage report | 3 hours | With E5-01, E5-02, E5-06, E5-07 |
| 39 | E5-06: Report coverage report | 2 hours | With E5-01, E5-02, E5-05, E5-07 |
| 40 | E5-07: Document management verification | 2 hours | With E5-01, E5-02, E5-05, E5-06 |
| 41 | E5-03: API coverage report | 2 hours | With E5-04 |
| 42 | E5-04: Role coverage report | 2 hours | With E5-03 |
| 43 | E5-08: Backup/restore certification | 2 hours | With E5-09 |
| 44 | E5-09: Performance certification | 2 hours | With E5-08 |
| 45 | E5-10: Final release certification | 2 hours | After E5-01..E5-09 |
| 46 | **Gate G5: System Certification** | 2 hours | — |
| **Total** | | **2-3 days** | (with parallelism) |

### Phase 6: Release (Day 9-10)

| Step | Task | Duration |
|------|------|----------|
| 47 | Complete Release Scorecard (20 items) | 30 min |
| 48 | Run `npm run verify` — final check | 5 min |
| 49 | Stage and commit all changes | 10 min |
| 50 | Create tag `v1.0.0-rc3` | 5 min |
| 51 | Push branch and tag | 5 min |
| **Total** | | **55 min** |

---

## Estimated Total Effort

| Phase | Duration | Tasks |
|-------|----------|-------|
| Phase 0: Baseline Certification | 3-4 hours | 7 |
| Phase 1: Security Hardening | 2-3 days | 8 |
| Phase 2: Data Integrity | 1.5-2 days | 4 |
| Phase 3: Developer Experience | 0.5-1 day | 4 |
| Phase 4: Documentation | 2-3 days | 5 |
| Phase 5: System Certification | 2-3 days | 10 |
| Phase 6: Release | 55 min | — |
| **Total** | **8-12 working days** | **38 tasks + 6 gates** |

---

## Task Count Verification

| Epic | Tasks | IDs |
|------|-------|-----|
| Epic 0 — Baseline Certification | 7 | E0-01, E0-02, E0-03, E0-04, E0-05, E0-06, E0-07 |
| Epic 1 — Security Hardening | 8 | E1-01, E1-02, E1-03, E1-04, E1-05, E1-06, E1-07, E1-08 |
| Epic 2 — Data Integrity | 4 | E2-01, E2-02, E2-03, E2-04 |
| Epic 3 — Developer Experience | 4 | E3-01, E3-02, E3-03, E3-04 |
| Epic 4 — Documentation | 5 | E4-01, E4-02, E4-03, E4-04, E4-05 |
| Epic 5 — System Certification | 10 | E5-01, E5-02, E5-03, E5-04, E5-05, E5-06, E5-07, E5-08, E5-09, E5-10 |
| **Total** | **38** | |

| Metric | Value |
|--------|-------|
| Total tasks | 38 |
| Total gates | 6 (G0, G1, G2, G3, G4, G5) |
| Release gate | 1 (RC3 Release) |
| Estimated duration | 8-12 working days |
| Parallelizable tasks | 28 of 38 (74%) |

---

## Risk Register

| Risk | Impact | Likelihood | Mitigation | Task |
|------|--------|-----------|------------|------|
| Zod validation strictness breaks existing clients | MEDIUM | Medium | Add validation incrementally; test each route with valid payload first | E1-05..E1-08 |
| NaN fix requires AsyncLocalStorage change | MEDIUM | Low | Trace user extraction in route; likely simple mapping fix | E2-02 |
| Update schema default fix breaks create routes | MEDIUM | Low | Verify create routes still accept omitted fields after change | E2-03 |
| ESLint surfaces many existing issues | LOW | Medium | Fix lint errors as part of E3-04; scope may expand | E3-04 |
| Documentation scope creep | LOW | Medium | Time-box to estimated hours; prioritize API + deployment | E4-02..E4-05 |
| E5 certification finds regressions | MEDIUM | Low | Fix regressions before E5-10; each E5 task produces actionable report | E5-01..E5-10 |
| Performance certification fails | MEDIUM | Low | E2-01 fixes primary regression; E5-09 verifies | E5-09 |
| Backup cycle fails during certification | HIGH | Low | E0-02 verifies security first; E5-08 verifies full cycle | E5-08 |
