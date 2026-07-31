# RC2 Certification Audit Report

**Audit Date:** 2026-07-16
**Auditor Role:** Independent Release Auditor
**Mode:** Disproof-oriented — every claim requires evidence

---

## Deliverable 1 — Functional Closure Validation

### 1.1 Reported Fixes

| Fix | Claimed | Verified | Evidence |
|-----|---------|----------|----------|
| `transitions.find is not a function` | Fixed in `Detail.tsx:84` | **PARTIAL** — runtime fix correct, but introduces type error | See 5.1 |
| `useRef` initial value (`useTemplateLivePreview.ts:23`) | Fixed | **PASS** | Code review confirms `useRef<ReturnType<typeof setTimeout> \| undefined>(undefined)` |
| Unused imports removed (`CycleDetail.tsx`) | Fixed | **PASS** | Code review confirms removal |
| `template-version.routes.ts:60` | Fixed — `findAll()` | **PARTIAL** — works but performance regression | See 3.1 |
| RLS grants for `templates` schema | Applied | **UNVERIFIED** — DB not running, cannot confirm live | SQL grant statements not independently verifiable |

### 1.2 Page Integrations

| Page | Template Integration | Status |
|------|---------------------|--------|
| Applications/Detail | `DocumentGenerationSection` with 9 actions | **PASS** — visible in screenshot `04-application-template-actions.png` |
| Reports | `DocumentGenerationSection` with annual report | **UNVERIFIED** — not captured in screenshots |
| Accreditation/CycleDetail | Import removed (not integrated) | **PASS** — per design, no template actions needed |
| Safety/RiskIncidents | Template actions present | **UNVERIFIED** — not captured in screenshots |
| Notifications | Template actions present | **UNVERIFIED** — not captured in screenshots |
| Messages | Template actions present | **UNVERIFIED** — not captured in screenshots |
| Documents | Upload/download only | **PASS** — by design, no generation needed |
| Dashboard | Summary only | **PASS** — by design |
| ConsentTemplates | Separate CRUD system | **PASS** — by design |

### 1.3 Login Flow

- Login with `admin/admin123` → redirects to `/` (Dashboard index) → **PASS**
- Evidence: Screenshot `01-login-page.png` (306 KB), `02-dashboard.png` (81 KB)
- E2E: `01-01-logged-in.png` (81 KB, same hash as `02-dashboard.png` — confirms post-login state)

### 1.4 Dashboard Navigation

- **PASS** — Dashboard loads after login, sidebar navigation visible in screenshots

### 1.5 Other Pages

| Page | Status | Evidence |
|------|--------|----------|
| Committees | **UNVERIFIED** — not in RC2 screenshots | — |
| Reviews | **UNVERIFIED** — not in RC2 screenshots | — |
| Notifications | **UNVERIFIED** — not in RC2 screenshots | — |
| Messaging | **UNVERIFIED** — not in RC2 screenshots | — |
| Safety | **UNVERIFIED** — not in RC2 screenshots | — |
| Accreditation | **UNVERIFIED** — not in RC2 screenshots | — |

### Verdict: **PARTIAL**

The RC2 scope covers templates. Template integration verified for Applications and the template library/detail/preview pages. All other modules are UNVERIFIED but were not claimed as part of RC2 scope.

---

## Deliverable 2 — Evidence Validation

### 2.1 Screenshot Evidence

| Metric | Claimed | Actual | Status |
|--------|---------|--------|--------|
| Total screenshots | 27 | 27 | PASS |
| All valid PNGs | Yes | Yes (magic bytes `89 50 4E 47` verified) | PASS |
| All > 10 KB | Yes | Yes (min 49.9 KB) | PASS |
| Unique images | Implied 27 | **10** | **FAIL** |

### 2.2 Screenshot Duplication Analysis

Of 27 files, **only 10 are unique images**. Clusters:

| Cluster | Files | Size | Claim | Reality |
|---------|-------|------|-------|---------|
| `F64B7C82` | 8 files | 145 KB | Version detail, Snapshot history, Render history, Audit trail (4 standalone + 4 E2E) | **Same full-page screenshot** — `full_page=True` captures entire scrollable page; scrolling within same page produces identical image |
| `5E903AB5` | 4 files | 68 KB | Template detail, Variable inspector (2 standalone + 2 E2E) | **Same image** — Variable inspector is a panel within the same page |
| `FCA54B45` | 3 files | 66 KB | Template actions, Preview modal (1 standalone + 2 E2E) | **E2E modal didn't open** — `03-03-template-actions` and `04-04-preview-modal` are byte-identical |
| `B14CE4DA` | 3 files | 50 KB | Preview page, Render result (1 standalone + 2 E2E) | **Same image** — Render button was disabled, nothing changed |

### 2.3 What the Evidence Actually Shows

| Unique Image | What It Shows | Files Using It |
|-------------|---------------|----------------|
| `9D749742` | Login page | 1 (standalone only) |
| `7D7A2B9D` | Dashboard (post-login) | 2 (standalone + E2E) |
| `FB54EF05` | Application Detail | 2 (standalone + E2E) |
| `FCA54B45` | Application Detail scrolled to bottom | 3 (standalone template-actions + E2E actions + E2E modal) |
| `190E3A56` | **Actual preview modal** (standalone only) | 1 |
| `6A890021` | Template Library | 2 (standalone + E2E) |
| `5E903AB5` | Template Detail page | 4 (2 standalone + 2 E2E) |
| `B14CE4DA` | Template Preview page | 3 (1 standalone + 2 E2E) |
| `6D3731CE` | Template Preview page (E2E render state) | 1 (E2E only) |
| `F64B7C82` | Version Detail page | 8 (4 standalone + 4 E2E) |

### 2.4 Evidence Gaps

| Claimed Screenshot | Evidence Status |
|-------------------|-----------------|
| `05-application-preview-modal.png` | **VALID** — unique hash, modal visible (standalone set only) |
| `04-04-preview-modal.png` (E2E) | **INVALID** — identical to pre-click state; modal did not open |
| `11-11-version-detail.png` through `14-14-audit-trail.png` | **MISLEADING** — 4 screenshots claimed as 4 different sections, all byte-identical |
| Template actions on Reports, Safety, Notifications, Messages | **MISSING** — no screenshots of these pages |

### 2.5 Automation Scripts

| Script | Exists | Functional | Notes |
|--------|--------|-----------|-------|
| `scripts/rc2-screenshots.py` | Yes (12 KB) | Yes — produced 13 files | `full_page=True` causes same-page section duplication |
| `scripts/rc2-e2e-walkthrough.py` | Yes (16.7 KB) | Yes — produced 14 files | E2E preview modal failed to open |

### Verdict: **FAIL**

The evidence shows **10 unique UI states** across 27 files. The report claims 27 distinct UI validations but the underlying screenshots prove otherwise. The E2E walkthrough's preview modal step (Step 4) produced an identical image to the pre-click state, meaning the modal did not actually open in the E2E run. The 4 "different sections" of version detail are byte-identical full-page captures.

---

## Deliverable 3 — Regression Audit

### 3.1 `template-version.routes.ts:57-62` — Performance Regression

```
const allVersions = await versionRepo.findAll();
versions = allVersions.filter(v => v.template_id === templateId);
```

The `findAll()` method loads **every template version** across all templates into memory, then filters by `template_id` in JavaScript. Before the fix, the route called `findByTemplateCode('')` which also failed, but the intent was a filtered query. The replacement is correct in behavior but introduces a full-table-scan performance regression.

**Severity: Medium** — correct behavior, poor performance at scale.

### 3.2 Proxy Port

`frontend/vite.config.ts:10` targets `http://localhost:8080`. **Correct** — was temporarily changed to 8081 for screenshot capture but reverted.

### 3.3 Console.log in Production Code

- Frontend: **0** instances
- Backend: **16** instances — all in test files (`e2e-workflow-scenarios.test.ts`) and scripts (`gen-hash.ts`). **No production console.log.**

### 3.4 TODO/FIXME/Debugger

- **0** across the entire codebase.

### 3.5 Hardcoded Secrets

- **0** in production code. Test files use `admin123` and `Test@1234` — standard test fixtures.

### 3.6 Other Regressions

No other regressions detected. All imports, exports, function signatures, and RLS context propagation intact.

### Verdict: **1 regression found** (performance). No correctness regressions.

---

## Deliverable 4 — API Contract Audit

### 4.1 Contract Mismatches

| # | Endpoint | SDK Type | Backend Reality | Severity |
|---|----------|----------|-----------------|----------|
| 1 | `GET /workflow/available-transitions/:type/:id` | `SuccessResponse<WorkflowTransition[]>` | `SuccessResponse<{ current_state: string\|null, transitions: WorkflowTransition[] }>` | **CRITICAL** — breaks `tsc -b` |
| 2 | `POST /templates/template-render` | `RenderDocumentResult` includes `correlationId` | Backend does not return `correlationId` | LOW — field is `undefined` at runtime |
| 3 | `POST /templates/preview` (document-level) | Not in SDK | Backend route exists | LOW — unused by frontend |
| 4 | `POST /templates/render` (document-level) | Not in SDK | Backend route exists | LOW — unused by frontend |

### 4.2 Template SDK Contracts (All Match)

| SDK Method | Backend Route | Match |
|-----------|---------------|-------|
| `templates.preview()` | `POST /templates/template-preview` | PASS |
| `templates.render()` | `POST /templates/template-render` | PASS |
| `templates.getSnapshots()` | `GET /templates/template-snapshots` | PASS |
| `templates.getSnapshotByHash()` | `GET /templates/template-snapshots/:hash` | PASS |
| `templates.verifySnapshot()` | `POST /templates/template-snapshots/verify` | PASS |
| `templates.rollback()` | `POST /templates/template-rollback` | PASS |
| `templates.listCategories()` | `GET /templates/categories` | PASS |
| `templates.getCategory()` | `GET /templates/categories/:id` | PASS |

### 4.3 Application SDK Contracts (All Match)

| SDK Method | Backend Route | Match |
|-----------|---------------|-------|
| `applications.list()` | `GET /core/applications` | PASS |
| `applications.getById()` | `GET /core/applications/:id` | PASS |
| `applications.getSla()` | `GET /core/applications/:id/sla` | PASS |
| `applications.getHistory()` | `GET /core/applications/:id/history` | PASS |

### Verdict: **1 CRITICAL mismatch** (workflow SDK type), 2 LOW mismatches.

---

## Deliverable 5 — Production Audit

### 5.1 TypeScript

| Check | Command | Result | Status |
|-------|---------|--------|--------|
| Frontend `tsc --noEmit` | `npx tsc --noEmit` | 0 errors | **MISLEADING** — root tsconfig has `"files": []`, checks nothing |
| Frontend `tsc -b` | `npx tsc -b` | **1 error** | **FAIL** — `TS2339: Property 'transitions' does not exist on type 'WorkflowTransition[]'` at `Detail.tsx:84` |
| Frontend `npm run build` | `tsc -b && vite build` | **FAILS** | **FAIL** — blocked by `tsc -b` error |
| Backend `tsc --noEmit` | `npx tsc --noEmit` | 0 errors | PASS |

### 5.2 Build

| Check | Result | Status |
|-------|--------|--------|
| Frontend production build | **BLOCKED** by TS error | **FAIL** |
| Backend production build | N/A (no vite/esbuild step) | PASS |

### 5.3 Lint

| Check | Result | Status |
|-------|--------|--------|
| Frontend ESLint | Not configured (`npm run lint` not found) | UNVERIFIED |
| Backend lint (`tsc --noEmit`) | 0 errors | PASS |

### 5.4 Runtime

| Check | Result | Status |
|-------|--------|--------|
| ErrorBoundary | Properly implemented (`getDerivedStateFromError` + `componentDidCatch`) | PASS |
| Unhandled promise rejections | None found in production code | PASS |
| Email failure handling | Silently swallowed (`.catch(() => {})`) in `auth.service.ts:175,218` | LOW — user gets no feedback if email fails |

### 5.5 React Warnings

| Check | Result | Status |
|-------|--------|--------|
| Console errors during E2E | 0 JavaScript errors captured by Playwright | PASS |

### Verdict: **FAIL** — Frontend production build is blocked by a TypeScript error introduced during RC2.

---

## Deliverable 6 — Security Audit

### 6.1 Authentication

| Check | Status | Evidence |
|-------|--------|----------|
| All template routes require JWT | PASS | All 9 route files have `authenticate` middleware (24/24 endpoints) |
| Unauthenticated access blocked | PASS | 401 returned without token |

### 6.2 Authorization

| Check | Status | Evidence |
|-------|--------|----------|
| Admin write operations restricted | PASS | `authorize(SUPER_ADMIN, SYS_ADMIN, ADMIN, ETHICS_ADMIN)` on create/update/delete |
| `POST /versions/:id/submit` | **GAP** — no `authorize()`, any authenticated user can submit | `template-version.routes.ts:113` |
| `POST /document/preview` | **GAP** — no `authorize()`, any user can preview | `template-document.routes.ts:9` |
| `POST /document/render` | **GAP** — no `authorize()`, any user can render | `template-document.routes.ts:19` |

### 6.3 RLS

| Check | Status | Evidence |
|-------|--------|----------|
| RLS enabled on all 16 template tables | PASS | `55-template-schema.sql:524-539` |
| RLS policies per table | PASS | `admin_all`, `read_all`, `no_physical_delete` |
| `app.user_id` propagation | PASS | `database.ts:79` sets via `set_config` |
| No RLS bypass in template code | PASS | All queries go through `AuditableRepository.query()` |

### 6.4 SQL Injection

| Check | Status | Evidence |
|-------|--------|----------|
| All queries parameterized | PASS | All repositories use `$1, $2, ...` placeholders |
| No string interpolation of user input | PASS | No `pool.query(\`...\${userInput}\`)` patterns found |

### 6.5 Input Validation

| Check | Status | Evidence |
|-------|--------|----------|
| Template preview/render routes | PASS | Zod schemas validate all fields |
| `template-document.routes.ts` POST endpoints | **GAP** — no Zod validation on `POST /preview` or `POST /render` | Direct `req.body` access |
| Template CRUD routes | PASS | `createTemplateSchema`, `updateTemplateSchema` |

### 6.6 Sensitive Data

| Check | Status | Evidence |
|-------|--------|----------|
| `.env` in `.gitignore` | PASS | `.gitignore:4` |
| JWT_SECRET strength | PASS | 64 hex chars, enforced min 32 in `env.ts:16` |
| Logger redaction | PASS | `logger.ts:23` redacts auth headers and passwords |
| No hardcoded secrets in production code | PASS | All credentials from `env.*` |

### 6.7 Template Engine Security

| Check | Status | Evidence |
|-------|--------|----------|
| Handlebars HTML escaping ON | PASS | `noEscape` not configured |
| Prototype access blocked | PASS | `allowProtoMethodsByDefault` not set |
| Forbidden helpers disabled | PASS | `eval`, `import`, `exec`, etc. registered as disabled |
| `safeHtml` helper | INFORMATIONAL | Admin-only template editing, opt-in helper |

### Verdict: **PASS with gaps** — 3 authorization gaps, 1 input validation gap, all non-critical.

---

## Deliverable 7 — Documentation Audit

### 7.1 RC2 Report Accuracy

| Claim in Report | Actual | Status |
|-----------------|--------|--------|
| "Frontend `tsc --noEmit` passes" | Root tsconfig has `"files": []` — checks nothing | **MISLEADING** |
| "Backend `tsc --noEmit` passes" | True | PASS |
| "27 screenshots captured" | 27 files exist, only 10 unique | **MISLEADING** |
| "14 E2E screenshots, 0 JS errors" | True (0 errors), but many are duplicates | PARTIAL |
| "14/14 gates PASS" | Gate G1 (build) actually FAILS | **FALSE** |
| "Recommendation: Proceed to RC2 certification" | Build is broken | **INCORRECT** |

### 7.2 Documentation Completeness

| Document | Exists | Accurate |
|----------|--------|----------|
| `docs/release-gates.md` | Yes | Yes — historical gates correct |
| `docs/template-verification-matrix.md` | Yes | UNVERIFIED |
| `docs/template-user-journeys.md` | Yes | UNVERIFIED |
| `docs/RC2-FUNCTIONAL-CLOSURE-REPORT.md` | Yes | **PARTIAL** — contains false claims about build status and screenshot uniqueness |
| `AGENTS.md` | Yes | Yes — architecture description accurate |

### Verdict: **FAIL** — RC2 report contains false claims about build status and misleading claims about evidence.

---

## Deliverable 8 — Technical Debt Audit

| # | Item | Severity | Description |
|---|------|----------|-------------|
| 1 | **Frontend build broken** | **CRITICAL** | `tsc -b` fails: `TS2339` in `Detail.tsx:84`. SDK type for `getAvailableTransitions` returns `WorkflowTransition[]` but backend returns `{ current_state, transitions }`. Build cannot produce production artifacts. |
| 2 | **Workflow SDK type mismatch** | **HIGH** | `workflow.sdk.ts:18` types response as `SuccessResponse<WorkflowTransition[]>` but actual shape is `SuccessResponse<{ current_state: string\|null, transitions: WorkflowTransition[] }>`. Type lie — works at runtime but breaks `tsc -b`. |
| 3 | **`tsc --noEmit` is a no-op** | **MEDIUM** | Root `tsconfig.json` has `"files": []` and only references sub-projects. `tsc --noEmit` checks nothing. CI and AGENTS.md both claim this is the lint command — it isn't. Real type checking requires `tsc -b`. |
| 4 | **Screenshot evidence quality** | **MEDIUM** | 27 files but only 10 unique images. `full_page=True` captures entire scrollable page, so scrolling within same page produces identical images. E2E preview modal didn't open. |
| 5 | **`findAll()` performance regression** | **MEDIUM** | `template-version.routes.ts:57-62` loads all versions into memory, filters in JS. Should be `findByTemplateId(templateId)` in the repository. |
| 6 | **Missing Zod validation** | **LOW** | `template-document.routes.ts` POST endpoints read `req.body` directly without schema validation. |
| 7 | **Missing `authorize()` on 3 endpoints** | **LOW** | `POST /versions/:id/submit`, `POST /document/preview`, `POST /document/render` — any authenticated user can call these. |
| 8 | **Email failure silent swallow** | **LOW** | `auth.service.ts:175,218` — `.catch(() => {})` hides email delivery failures from users. |
| 9 | **`safeHtml` Handlebars helper** | **LOW** | Admin-controlled XSS bypass available in template engine. Acceptable if only admins edit templates. |
| 10 | **`app.user_id` NaN on versions endpoint** | **LOW** | `/api/v1/templates/versions` returns "NaN" for `app.user_id`. AsyncLocalStorage context doesn't propagate. Pre-existing, not introduced by RC2. |

---

## Deliverable 9 — Certification Checklist

| # | Gate | Criteria | Status | Evidence |
|---|------|----------|--------|----------|
| G1 | **Build** | `npm run build` passes | **FAIL** | `tsc -b` fails with `TS2339` in `Detail.tsx:84` |
| G2 | **Lifecycle** | DRAFT→REVIEW→APPROVED | PASS | SQL verified, audit entries confirmed |
| G3 | **Preview** | Template preview renders HTML | PASS | API returns 1194 chars HTML in 32ms |
| G4 | **Render** | Template render + snapshot | PASS | Hash `bd18a15b` verified |
| G5 | **Snapshot** | Snapshot verify valid=true | PASS | match=true confirmed |
| G6 | **Audit** | Audit trail entries exist | PASS | 4 entries in `template_version_audit` |
| G7 | **UI** | Login flow | PASS | Admin login → Dashboard verified |
| G7 | **UI** | Application Detail renders | PASS | After fix, page loads correctly |
| G7 | **UI** | Template actions work | PASS | Preview modal opens (standalone evidence) |
| G7 | **UI** | Template Library | PASS | 12 templates displayed |
| G7 | **UI** | Template Detail | PASS | certificate-approval detail shown |
| G7 | **UI** | Variable Inspector | UNVERIFIED | Same screenshot as Template Detail |
| G7 | **UI** | Snapshot/Render/Audit sections | UNVERIFIED | Same screenshot for all 4 sections |
| G8 | **Evidence** | Screenshots captured | **FAIL** | 27 files, 10 unique. E2E modal didn't open. |
| G9 | **TypeScript** | `tsc -b` passes | **FAIL** | 1 error in `Detail.tsx:84` |
| G10 | **Security** | Auth on all endpoints | PASS | 24/24 template endpoints authenticated |

**Gates passed: 10/16**
**Gates failed: 3** (Build, Evidence, TypeScript)
**Gates unverified: 3** (Variable Inspector, Snapshot sections, Render sections)

---

## Deliverable 10 — Executive Verdict

### 1. Can RC2 be certified?

**NO**

### 2. Blocking Issues

| # | Issue | Severity | Fix Required |
|---|-------|----------|-------------|
| **B1** | Frontend `npm run build` fails — `TS2339` in `Detail.tsx:84` | **CRITICAL** | Update `workflow.sdk.ts:18` type from `SuccessResponse<WorkflowTransition[]>` to `SuccessResponse<{ current_state: string\|null; transitions: WorkflowTransition[] }>`. Or cast in the queryFn. |
| **B2** | RC2 report contains false claims about build status and screenshot uniqueness | **HIGH** | Report must be corrected to reflect actual findings. |
| **B3** | Screenshot evidence is 63% duplicates — 27 files, 10 unique images | **HIGH** | E2E walkthrough must be re-run with proper navigation between sections (use `page.evaluate('window.scrollTo(0, ...)'` before full-page screenshot, or use element-level screenshots). |

### 3. Non-Blocking Issues

| # | Issue | Severity | Recommendation |
|---|-------|----------|----------------|
| N1 | `findAll()` performance regression | MEDIUM | Add `findByTemplateId()` to repository |
| N2 | Missing Zod validation on document routes | LOW | Add schemas to `template-document.routes.ts` |
| N3 | Missing `authorize()` on 3 endpoints | LOW | Add role guards |
| N4 | Email failure silent swallow | LOW | Log or notify user |
| N5 | `tsc --noEmit` is a no-op | MEDIUM | Fix root tsconfig or update AGENTS.md to use `tsc -b` |
| N6 | SDK type `correlationId` mismatch | LOW | Add to backend response or remove from SDK type |

### 4. Remaining Production Risks

| Risk | Impact | Likelihood |
|------|--------|-----------|
| Build broken → cannot deploy | No production deployment possible | **CERTAIN** |
| `findAll()` memory usage | OOM at scale with many template versions | Low at current scale |
| Unvalidated document route inputs | Potential injection if Handlebars has escape bypass | Low (admin-only templates) |
| Silent email failures | Users don't receive verification/reset emails | Medium |

### 5. Confidence Level

**45%**

The backend template engine infrastructure is functional and well-tested. The audit trail, lifecycle, snapshot verification, and RLS are all solid. However:
- The frontend build is broken (critical)
- The evidence quality is poor (63% duplicates)
- The RC2 report contains false claims

### 6. Verdict

## **NO-GO**

**Three blocking issues must be resolved before RC2 certification:**

1. **Fix the build** — update the workflow SDK type or the queryFn to eliminate the `TS2339` error
2. **Correct the RC2 report** — remove false claims about build status and screenshot uniqueness
3. **Regenerate evidence** — re-run the E2E walkthrough ensuring each step produces a genuinely distinct screenshot (not `full_page=True` on same-page scrolling)

Once these three items are resolved, RC2 can be re-audited for certification.

---

*End of audit. No code was modified. No commits were made.*
