# SDK Automation Plan — Orval Code Generation from OpenAPI

**Status:** Planning only — no implementation  
**Target:** Post Release Candidate (RC1.2)  
**Architecture Freeze:** In effect — do not modify OpenAPI, SDK, CI, or generate code

---

## 1. Current Architecture

### Component diagram

```
backend/openapi/openapi.yaml        ← canonical API contract (OpenAPI 3.1)
  └── components.yaml
  └── modules/*.yaml (15 domain files)
  └── security.schema.yaml

frontend/src/sdk/                    ← manually maintained
  ├── index.ts                       ← barrel re-export
  ├── core/
  │   ├── config.ts                  ← base URL configuration
  │   └── types.ts                   ← ~650 lines of hand-written TS interfaces
  ├── domains/                       ← 18 hand-written SDK files
  │   ├── security.sdk.ts
  │   ├── applications.sdk.ts
  │   ├── monitoring.sdk.ts
  │   └── ...
  └── public/
      └── verify.sdk.ts             ← public endpoints (no auth)

frontend/src/api/client.ts           ← custom Axios instance (82 lines)
  - JWT token management in sessionStorage
  - Automatic 401 → redirect to login
  - Token refresh interceptor
  - Toast error notifications
```

### Key facts

| Aspect | Current State |
|--------|---------------|
| **SDK maintenance** | Manual — every API change requires hand-editing 2-3 SDK files + type definitions |
| **Orval installed** | Yes (`^8.16.0` in `backend/package.json`) |
| **Orval configured** | No — no `orval.config.*` file exists anywhere |
| **Codegen script** | No — no npm script runs orval |
| **CI codegen step** | No |
| **Contract ↔ SDK alignment** | No automated verification — drift is undetectable until runtime |
| **sdk/index.ts comment** | `// Generated from OpenAPI 3.1 Contract (v1.0.0)` — misleading, SDK is hand-written |

### Current manual workflow

```
OpenAPI spec change (backend/openapi/ or swagger.ts)
  ↓  (developer must notice the change)
SDK manual update (frontend/src/sdk/domains/*.sdk.ts + core/types.ts)
  ↓  (error-prone, easy to miss)
TypeScript compilation (tsc --noEmit)
  ↓  (catches some errors but not semantic drift)
Manual testing
```

**Risks of current workflow:**
- Type definitions in `core/types.ts` may not match OpenAPI schemas
- SDK method signatures may not match actual endpoint parameters
- New endpoints may have no SDK coverage
- Response shape changes may not propagate to SDK consumers
- No automated enforcement of contract compliance

---

## 2. Target Architecture

### After automation

```
backend/openapi/openapi.yaml         ← single source of truth
  ↓
orval (npm run sdk:generate)         ← automated code generation
  ↓
frontend/src/generated-sdk/
  ├── domains/                        ← auto-generated functions (per OpenAPI tag)
  ├── core/types/                     ← auto-generated TypeScript interfaces
  └── index.ts                        ← auto-generated barrel

frontend/src/sdk/
  ├── index.ts                        ← re-exports from generated-sdk/ + manual files
  ├── core/config.ts                  ← manually maintained (base URL, unchanged)
  └── public/verify.sdk.ts            ← manually reviewed (public endpoints)

frontend/src/api/
  ├── client.ts                       ← unchanged (Axios + JWT + interceptors)
  └── mutator/custom-instance.ts      ← thin wrapper for orval
```

### Why separate `generated-sdk/` from `sdk/`

**Advantages of `frontend/src/generated-sdk/`:**

| Factor | Detail |
|--------|--------|
| **Clear boundary** | Generated directory is off-limits to hand edits. Developers know not to touch it. |
| **Parallel coexistence** | Hand-written `sdk/` and generated `generated-sdk/` can live side-by-side during migration. Consumers migrate one tag at a time. |
| **Safe rollback** | Delete `generated-sdk/` and restore `sdk/index.ts` — zero impact on consumers. |
| **Convention alignment** | Matches `graphql-codegen`, `protoc-gen-ts`, `openapi-generator` conventions. |
| **Clean CI validation** | CI can run a diff to detect drift between spec and committed generated output. |
| **Gitignore flexibility** | Can decide post-migration whether to commit generated output or regenerate in CI. |

**Disadvantages:**

| Factor | Detail |
|--------|--------|
| **Extra layer** | One additional path level (`generated-sdk/core/types/` vs `sdk/core/types.ts`) |
| **Import path change** | Consumers must import from `sdk/` (which re-exports from `generated-sdk/`) — no direct import from `generated-sdk/` |
| **Re-export maintenance** | `sdk/index.ts` must be updated to re-export from `generated-sdk/` — one-time effort |

**Recommendation: Use `generated-sdk/`.** The clear separation and parallel coexistence outweigh the one-time re-export setup cost.

### Workflow after automation

```
OpenAPI spec change (backend/openapi/ or swagger.ts)
  ↓
cd frontend && npm run sdk:generate    ← orval regenerates in ~2-5s
  ↓
TypeScript compilation (tsc --noEmit)
  ↓
npm test
  ↓
npm run build
```

No manual SDK edits needed. Type safety enforced at compile time.

---

## 3. Ownership Model

### Current state

```
orval: installed in backend/package.json (devDependencies)
config: does not exist
output: does not exist
generation: never runs
```

### Recommended model

```
orval: installed in frontend/package.json (devDependencies)
config: frontend/orval.config.ts
output: frontend/src/generated-sdk/
script: frontend package.json → "sdk:generate": "orval --config orval.config.ts"
run:    cd frontend && npm run sdk:generate
```

**Rationale:**

| Factor | Backend ownership | Frontend ownership |
|--------|-------------------|--------------------|
| **Output location** | Backend should not own frontend code generation | ✅ Frontend owns its own code |
| **Config proximity** | `orval.config.ts` references `../` paths to reach frontend | ✅ Config lives alongside its consumers |
| **Dependency scope** | Backend's `devDependencies` should stay backend-focused | ✅ Frontend controls its tooling |
| **npm script** | `cd frontend && npx -w backend orval` (awkward) | ✅ `cd frontend && npm run sdk:generate` (natural) |
| **CI pipeline** | Frontend CI job would need backend node_modules | ✅ Self-contained frontend job |

**Migration steps:**
1. Remove `orval` from `backend/package.json` devDependencies
2. Add `orval` to `frontend/package.json` devDependencies
3. Add `"sdk:generate": "orval --config orval.config.ts"` to frontend scripts
4. Create `frontend/orval.config.ts`
5. Optionally install `@orval/axios` in frontend (if not bundled with orval)

---

## 4. Orval Configuration

### Supported config files

Orval `^8.16.0` searches from `process.cwd()`:

1. `orval.config.ts`
2. `orval.config.js`
3. `orval.config.mjs`
4. `orval.config.mts`

Supports `--config <path>` flag.

### Available output plugins

| Plugin | Relevance |
|--------|-----------|
| `@orval/axios` | ✅ Primary — Axios-functions output matching current pattern |
| `@orval/core` | ✅ Required dependency |
| `@orval/query` | Optional — React Query hooks if adopted later |
| `@orval/zod` | Optional — runtime validation schemas |
| `@orval/mock` | Optional — MSW test mock handlers |

### Key orval features

| Feature | Relevance |
|---------|-----------|
| **Mutator** | ✅ Injects custom Axios instance (`client.ts`) preserving JWT/interceptors |
| **axios-functions** | ✅ Standalone functions matching current SDK pattern |
| **Type generation** | ✅ Generates TS interfaces from OpenAPI schemas (replaces `core/types.ts`) |
| **Clean output** | ✅ Wipes output directory before regeneration |
| **Tag-based grouping** | ✅ Groups by OpenAPI tag matching domain module organization |
| **Enum handling** | ⚠️ Must verify enum → union type generation matches hand-written patterns |
| **Nullable handling** | ⚠️ Must verify `nullable: true` → `null \| T` generation |

### Mutator integration

The existing Axios client at `frontend/src/api/client.ts` must be wrapped in an orval-compatible mutator:

```typescript
// Expected by orval:
const customInstance = <T>(config: AxiosRequestConfig, options?: AxiosRequestConfig): Promise<T>
```

The wrapper delegates to `client.ts` while preserving:
- JWT token management (sessionStorage + refresh)
- 401 → redirect to login
- Error toast notifications
- `baseURL: '/api/v1'`

No changes to `client.ts` — only a thin wrapper at `frontend/src/api/mutator/custom-instance.ts`.

### Proposed configuration file

Location: `frontend/orval.config.ts`

```typescript
import { defineConfig } from 'orval'

export default defineConfig({
  'ethics-erm': {
    input: {
      target: '../backend/openapi/openapi.yaml',
    },
    output: {
      target: './src/generated-sdk/',
      schemas: './src/generated-sdk/core/types',
      client: 'axios-functions',
      httpClient: 'axios',
      baseUrl: '/api/v1',
      clean: true,
      indexFiles: true,
      override: {
        mutator: {
          path: './src/api/mutator/custom-instance.ts',
          name: 'customInstance',
        },
      },
    },
    hooks: {
      afterAllFilesWrite: 'prettier --write',
    },
  },
})
```

### Generation command

```bash
cd frontend
npm run sdk:generate
```

### Output file map

| Directory | Content | Status |
|-----------|---------|--------|
| `frontend/src/generated-sdk/domains/` | Per-tag API functions | Generated |
| `frontend/src/generated-sdk/core/types/` | TypeScript interfaces | Generated |
| `frontend/src/generated-sdk/domains/index.ts` | Barrel export | Generated |
| `frontend/src/generated-sdk/core/types/index.ts` | Barrel export | Generated |
| `frontend/src/sdk/index.ts` | Re-exports from generated + manual | Manual (updated once) |
| `frontend/src/sdk/core/config.ts` | Base URL configuration | Manual (unchanged) |
| `frontend/src/sdk/public/verify.sdk.ts` | Public endpoint methods | Manual (reviewed) |
| `frontend/src/api/client.ts` | Axios + JWT | Manual (unchanged) |
| `frontend/src/api/mutator/custom-instance.ts` | Orval wrapper | New, manual |

---

## 5. Migration Strategy — 8 Phases

The migration proceeds in 8 sequential phases. Each phase is independently reversible via git.
No phase modifies the OpenAPI spec except Phase 2. No phase modifies CI until Phase 5.

```
Phase 0  — Preparation
  ↓
Phase 1  — Scaffold generation
  ↓
Phase 1.5 — Golden Diff (APPROVAL GATE)
  ↓
Phase 2  — OpenAPI gap resolution
  ↓
Phase 3  — Consumer migration
  ↓
Phase 4  — Mutator integration
  ↓
Phase 5  — CI integration
  ↓
Phase 6  — Manual SDK retirement
```

---

### Phase 0 — Preparation (1-2h)

**Actions:**
1. Install orval as a frontend devDependency
2. Create `frontend/src/api/mutator/custom-instance.ts` (thin wrapper around `client.ts`)
3. Create `frontend/orval.config.ts` targeting a single experimental tag only
4. Run `npm run sdk:generate` in a feature branch
5. Verify generated output structure compiles with `tsc --noEmit`

**Validation:** Generated files compile. Output directory structure matches expectations.

**Rollback:** Delete the feature branch.

---

### Phase 1 — Scaffold generation (2-3h)

**Actions:**
1. Expand orval config to all 15+ OpenAPI tags
2. Generate full SDK to `frontend/src/generated-sdk/`
3. Document directory layout, file naming conventions, type patterns
4. Record any orval warnings or errors

**Validation:** Full generation completes without errors. All OpenAPI paths are represented.

**Rollback:** `git checkout -- frontend/src/generated-sdk/` — delete the directory.

---

### Phase 1.5 — Golden Diff (3-5h) ← APPROVAL GATE

This is a hard gate. Migration **cannot continue** until compatibility is approved.

**Actions:**
1. Produce a structured diff between `generated-sdk/` and `sdk/` across all dimensions:

| Dimension | Hand-written (`sdk/`) | Generated (`generated-sdk/`) | Match? |
|-----------|----------------------|------------------------------|--------|
| **API function names** | `applications.list()`, `applications.getById()` | Orval naming convention | ⚠️ Verify |
| **Request types** | `PaginationParams`, `CreateApplicationPayload` | Generated from `requestBody` schemas | ⚠️ Verify |
| **Response types** | `SuccessResponse<T>`, `Application` | Generated from `responses` schemas | ⚠️ Verify |
| **Enum representations** | String union types | Generated string unions or numeric enums | ⚠️ Verify |
| **Nullable fields** | `field?: T \| null` | `field?: T` or `field: T \| null` | ⚠️ Verify |
| **Optional fields** | `field?: T` (omitted = undefined) | `field?: T` or `field: T \| undefined` | ⚠️ Verify |
| **Pagination models** | `Pagination { page, limit, total, totalPages }` | Generated from `pagination` response | ⚠️ Verify |
| **Error models** | `ErrorResponse { success, error, requestId }` | Generated from `errorResponse` schema | ⚠️ Verify |
| **Date types** | `string` (ISO 8601) | `string` or `Date` | ⚠️ Verify |
| **Import structure** | Relative imports from `sdk/` | Generated imports within `generated-sdk/` | ⚠️ Verify |
| **Barrel exports** | `sdk/index.ts` aggregates all domains | Orval generates per-module barrels | ⚠️ Verify |
| **Response wrapper** | `SuccessResponse<T>` envelope | Orval may unwrap or keep envelope | ⚠️ Verify |

2. For each dimension, mark: ✅ Identical | ⚠️ Compatible (minor rename needed) | ❌ Incompatible (needs OpenAPI fix)
3. If any ❌ exists, document the fix (→ Phase 2)
4. All ⚠️ items must have a documented migration path before gate is passed

**Approval criteria:**
- Zero ❌ items
- Every ⚠️ item has an approved migration path
- Diff report is committed to the plan document
- Architecture owner signs off

**Validation:** Structured diff report committed to `docs/sdk-automation-plan.md` (within this document or as a companion file).

**Rollback:** Delete the diff report. Revert to Phase 1 state. No consumer impact.

---

### Phase 2 — OpenAPI gap resolution (2-4h)

> This is the only phase that modifies OpenAPI.

**Actions:**
1. Add missing schemas to `backend/openapi/components.yaml` or module files
2. Add missing path definitions (if hand-written SDK has methods for undocumented endpoints)
3. Add missing response schemas with `$ref` references
4. Fix nullable/optional type annotations to match expected generated output
5. Re-run generation to verify gaps are closed

**Validation:** Re-running Phase 1.5 diff shows all ❌ resolved. No new gaps introduced.

**Rollback:** `git revert` OpenAPI changes. These changes are additive-only (no existing schema removal), so revert is safe.

---

### Phase 3 — Consumer migration (4-6h)

**Actions:**
1. Update `frontend/src/sdk/index.ts` to re-export from `generated-sdk/` instead of hand-written files
2. Verify all existing imports from `sdk/` still resolve through the re-export layer
3. Fix any import path or name mismatches in pages, hooks, components
4. Migrate incrementally by domain tag — one tag at a time, each verified independently

**Validation:** `tsc --noEmit` passes with zero errors. `npm test` passes. `npm run build` succeeds.

**Rollback:** `git checkout -- frontend/src/sdk/index.ts` — restore previous re-exports pointing to hand-written files.

---

### Phase 4 — Mutator integration (1-2h)

**Actions:**
1. Confirm `frontend/src/api/mutator/custom-instance.ts` exists from Phase 0
2. Wire up JWT token forwarding, refresh interceptor
3. Test authenticated API calls end-to-end: login → list → create → logout
4. Verify error toasts still fire on 4xx/5xx responses
5. Verify 401 → redirect to login still works

**Validation:** Full auth flow works with generated SDK functions. All Axios interceptors fire correctly.

**Rollback:** Switch mutator path in `orval.config.ts` to a no-op passthrough (removes token handling but keeps generation working).

---

### Phase 5 — CI integration (1h)

**Actions:**
1. Add `npm run sdk:generate` step to frontend CI job (before typecheck)
2. Add CI check comparing generated output against committed output (no drift)
3. Verify `npm run sdk:generate` can run in CI without external dependencies (Node + npm only)
4. Remove any orphaned manual SDK maintenance notes from documentation

**Validation:** CI pipeline runs `generate → diff check → typecheck → lint → build → test` successfully.

**Rollback:** Remove CI codegen step. Restore previous CI config.

---

### Phase 6 — Manual SDK retirement (1-2h)

**Actions:**
1. Verify all consumers have been migrated to use `generated-sdk/` via the `sdk/` re-export layer
2. Remove hand-written files:
   - `frontend/src/sdk/core/types.ts` (replaced by `generated-sdk/core/types/`)
   - `frontend/src/sdk/domains/*.sdk.ts` (replaced by `generated-sdk/domains/`)
3. Update `frontend/src/sdk/index.ts` to only re-export from `generated-sdk/` + manual files:
   - `core/config.ts`
   - `public/verify.sdk.ts`
4. Remove the misleading `// Generated from OpenAPI 3.1 Contract` comment from `sdk/index.ts`
5. Audit for any remaining direct imports of removed files
6. Mark PB-010 as completed in the backlog

**Validation:**
- `tsc --noEmit` passes with zero errors
- `npm test` passes
- `npm run build` succeeds
- No imports reference removed SDK files
- `grep -r "from.*sdk/domains/"` returns zero matches
- `grep -r "from.*sdk/core/types\b"` returns zero matches

**Rollback:** `git revert` the removal commit. Hand-written files are restored from git history.

**Acceptance criteria:**
- [ ] All SDK functions are generated from OpenAPI — no hand-written equivalents exist
- [ ] `frontend/src/sdk/` contains only: `index.ts`, `core/config.ts`, `public/verify.sdk.ts`
- [ ] `frontend/src/generated-sdk/` is the single source of generated API code
- [ ] `npm run sdk:generate` produces the same output on every machine (deterministic)
- [ ] CI validates that generated output matches committed output (no drift)

---

## 6. Migration Timeline

| Phase | Effort | Dependencies | Gate | Verification |
|-------|--------|--------------|------|--------------|
| Phase 0 — Preparation | 1-2h | None | None | Generated output compiles |
| Phase 1 — Scaffold | 2-3h | Phase 0 | None | Full generation succeeds |
| Phase 1.5 — Golden Diff | 3-5h | Phase 1 | ✅ APPROVAL GATE | Diff report approved |
| Phase 2 — OpenAPI gaps | 2-4h | Phase 1.5 | None | Gaps closed, diff ✅ |
| Phase 3 — Consumer migration | 4-6h | Phase 2 | None | `tsc --noEmit` + tests pass |
| Phase 4 — Mutator | 1-2h | Phase 3 | None | E2E auth flow works |
| Phase 5 — CI integration | 1h | Phase 4 | None | CI pipeline green |
| Phase 6 — Manual retirement | 1-2h | Phase 5 | None | Zero hand-written SDK files remain |
| **Total** | **15-25h** | | | |

---

## 7. Rollback Matrix

| Phase | Rollback Action | Independent? | Consumer Impact During Rollback |
|-------|----------------|--------------|-------------------------------|
| **Phase 0** | Delete feature branch | ✅ Yes | None — feature branch only |
| **Phase 1** | `git checkout -- generated-sdk/` or delete dir | ✅ Yes | None — generated dir unused by consumers |
| **Phase 1.5** | Delete diff report doc | ✅ Yes | None — documentation only |
| **Phase 2** | `git revert` OpenAPI commits | ✅ Yes | None — additive OpenAPI changes don't break existing consumers |
| **Phase 3** | `git checkout -- sdk/index.ts` to restore re-exports | ✅ Yes | Temporary — restoring re-exports instantly reverts consumer mappings |
| **Phase 4** | Switch mutator to no-op passthrough in `orval.config.ts` | ✅ Yes | Token handling degrades but generation continues working |
| **Phase 5** | Remove CI codegen step from workflow yaml | ✅ Yes | CI reverts to previous pipeline config |
| **Phase 6** | `git revert` the removal commit | ✅ Yes | Hand-written files restored from git history |

**Key safety guarantees:**
- Every phase is independently reversible without needing to revert subsequent phases
- No phase destroys data — hand-written files remain in git history forever
- The `sdk/` → `generated-sdk/` re-export layer means consumer code never imports directly from `generated-sdk/`
- Phase ordering is strictly forward: no phase depends on a later phase completing

---

## 8. Risk Matrix

| Phase | Risk | Severity | Rollback | Blocking? |
|-------|------|----------|----------|-----------|
| **Phase 0** | orval version incompatibility with Node.js | Low | Delete branch | No — skip or fix version |
| **Phase 1** | Orval cannot parse some OpenAPI 3.1 patterns | Low | Delete generated dir | ⚠️ Yes — must resolve before Golden Diff |
| **Phase 1.5** | Diff reveals incompatible type representations | Medium | Report only, no code impact | ✅ **BLOCKING** — gate cannot pass without resolution |
| **Phase 1.5** | Hand-written types have no OpenAPI equivalent | Medium | Report only | ⚠️ Yes — must add to OpenAPI (Phase 2) |
| **Phase 2** | OpenAPI additions conflict with frozen spec | Low | Revert commits | No — additions only, no deletions |
| **Phase 3** | Consumer import paths don't match generated names | Medium | Restore sdk/index.ts | No — fix one tag at a time |
| **Phase 3** | Generated function names differ from existing call sites | Medium | Restore sdk/index.ts | No — use re-export aliasing |
| **Phase 4** | Mutator wrapper breaks JWT flow | High | Switch to no-op mutator | ⚠️ Yes — must fix before Phase 5 |
| **Phase 4** | Error toast interceptor doesn't fire | Medium | Switch to no-op mutator | No — UX regression only |
| **Phase 5** | CI generator step adds build time | Low | Remove step | No — optimization |
| **Phase 5** | Generated output differs between local and CI | Low | Commit generated output | No — deterministic fix |
| **Phase 6** | Orphaned import references removed SDK files | Low | Revert removal commit | No — caught by `tsc --noEmit` |

---

## 9. Risks (Comprehensive)

| Risk | Severity | Mitigation |
|------|----------|------------|
| Generated types differ from hand-written types | Medium | Golden Diff (Phase 1.5) catches all differences before consumer migration |
| Generated function signatures differ from existing SDK consumers | Medium | Tag-by-tag incremental migration with per-tag verification |
| Orval does not support some OpenAPI 3.1 feature | Low | Test with single module in Phase 0 before full scaffold |
| Mutator wrapper breaks JWT flow | High | E2E auth flow test in Phase 4; no-op fallback protects rollback |
| Base URL mismatch (spec has `:3000`, server uses `:8080`) | Low | Set `baseUrl: '/api/v1'` in orval config (relative path, Vite proxy) |
| Workspace-level orval installation | Low | Install in frontend; remove from backend |
| Golden Diff reveals unresolvable incompatibility | Medium | Stop migration. Document findings. Defer to RC2 planning. |
| Phase 2 OpenAPI additions violate architecture freeze | Low | Phase 2 is post-RC. Freeze is lifted by then. |

---

## 10. Effort Summary

| Item | Effort |
|------|--------|
| PB-010 backlog creation | ✅ Done |
| Orval config + mutator wrapper | 1-2h |
| Scaffold generation | 2-3h |
| Golden Diff + approval | 3-5h |
| OpenAPI spec enrichment | 2-4h |
| Consumer migration + re-exports | 4-6h |
| Mutator E2E verification | 1-2h |
| CI integration | 1h |
| Manual SDK retirement | 1-2h |
| **Total** | **15-25h** |

---

## 11. Recommendation

**Proceed after RC1.2.** The migration is medium-effort (15-25h) with low overall risk because:

1. Orval is already installed — no new dependency acquisition cost
2. Separate `generated-sdk/` directory allows parallel coexistence during migration
3. Golden Diff (Phase 1.5) provides a hard approval gate — no surprises during consumer migration
4. Every phase is independently reversible via `git checkout` or `git revert`
5. Hand-written SDK is preserved in git — zero destruction risk
6. Tag-by-tag consumer migration allows incremental rollback

**Order of work:**
1. Phase 0 + 1 (scaffold — pure investigation, no replacement)
2. Phase 1.5 (Golden Diff — approve before proceeding)
3. Phase 2 (OpenAPI enrichment — improves contract for all consumers)
4. Phase 3 + 4 (swap generated SDK in, fix consumer imports, wire mutator)
5. Phase 5 (CI enforcement — final safety net)
6. Phase 6 (retire hand-written SDK — celebration)

**Primary risk:** Consumer import path and function name changes (Phase 3). Mitigated by:
- Tag-by-tag incremental migration
- `sdk/index.ts` re-export layer (consumers never import from `generated-sdk/` directly)
- Phase 1.5 Golden Diff catches all naming differences in advance

---

## 12. References

- OpenAPI spec: `backend/openapi/openapi.yaml`
- Current SDK: `frontend/src/sdk/`
- Axios client: `frontend/src/api/client.ts`
- Orval docs: https://orval.dev/docs
- Architecture freeze: `docs/architecture-freeze.md`
- Production backlog: `docs/production-backlog.md` (PB-010)
- Project REVIEW.md (lists manual SDK as known weakness)
