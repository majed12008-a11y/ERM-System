# Document Render Pipeline — Architecture

**Status**: Implemented (2026-08-04) — plan Task 7 (render service fixes)
**Scope**: `DocumentRenderService` (`backend/src/services/document-render.service.ts`) + `DocumentRenderRepository` (`backend/src/repositories/document-render.repository.ts`) — official-document PDF generation, checksumming, versioning, and concurrency
**Quality gate**: concurrent generation for the same entity never races on version numbers; a rendered document's stored checksum always matches the bytes on disk; a failed render never leaves partial DB state or orphaned temp files.

---

## 1. Pipeline overview

```
allocate number (sequence, outside lock)
   → launch browser (one per request)
   → pass 1: render shell to temp file with placeholder hash
   → sha256(temp file)          (A-01 real checksum)
   → pass 2: re-render shell to temp file with real hash prefix in footer
   → sha256(temp file)          (final checksum)
   → withEntityLock(entityType, entityId):   [transaction]
        version lookup → createDocument → createVersion
        → markSuperseded(previous) + SUPERSEDED audit → createGenerated → GENERATED audit
   → rename temp file → {templateCode}_{number}_v{versionNo}.pdf
   → finally: close browser, remove temp file
```

Two phases are deliberately separated: **PDF production** (expensive, parallelizable, no shared state) happens before the **DB transaction** (short, serialized on the entity lock). The document number is allocated from the sequence *before* rendering, so the entity lock is never held during the ~1–2 s render — only during the millisecond-scale DB writes.

---

## 2. Browser lifecycle and reuse strategy

- **One browser per request.** `render()` calls `launchBrowser()` exactly once and closes it in `finally`. Browsers are never pooled or shared across requests — avoids leaked processes, cross-request state bleed, and profile lock contention.
- **Page per render pass, reused browser within the request.** `renderPdf(html, outputPath, browser?)` opens a fresh page for each pass (`page.setContent` → `page.pdf`) and closes the page in `finally`; when a `browser` is passed in, it closes only the page and leaves the caller-owned browser alive. When no browser is passed (standalone callers), it launches and closes its own.
- **Executable resolution** (`launchBrowser`): `CHROME_PATH` env → else `PUPPETEER_CHROMIUM_REVISION` → else `findChrome()` scanning well-known install paths (`Program Files\Google\Chrome\...`). Headless with `--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage`.
- **Result**: the two-pass A-01 render reuses a single browser, so launch overhead is paid once per document; the footer hash in pass 2 is a genuine re-render, not a post-hoc text patch (keeps the PDF a faithful single-source render).

---

## 3. Entity lock scope and concurrency model

- **Mechanism**: `DocumentRenderRepository.withEntityLock<T>(entityType, entityId, fn)` runs `fn` inside `withTransaction` (BEGIN/COMMIT, RLS `app.user_id` set on the dedicated client) after taking `pg_advisory_xact_lock(hashtext('docgen_' || entityType || '_' || entityId))`. `_xact_` semantics: the lock is released automatically at COMMIT/ROLLBACK — no leak on any code path.
- **Scope**: one lock per **entity** (`entity_type` + `entity_id`, i.e. a form instance), not global and not per user. Concurrent generation for *different* entities proceeds in parallel; only same-entity generation serializes.
- **What runs inside the lock** (all on the same client → one atomic transaction):
  1. `findLatestVersionByEntity` — the version lineage includes only `ISSUED`/`SUPERSEDED` rows (a `PENDING_SIGNATURE` draft is not yet part of the lineage).
  2. `createDocument` with `status = 'PENDING_SIGNATURE'`, `current_version_no` computed inside the lock, and `lifecycle_state_id` resolved from the `PENDING_SIGNATURE` state code (dedicated `$22` param — reusing `$13` for both `status` and the subquery fails on PG 18 with `inconsistent types`).
  3. `createVersion`, `markSuperseded` (+ `SUPERSEDED` audit on the old doc), `createGenerated`, and the `GENERATED` audit row.
- **Race eliminated (A-06)**: two concurrent generates for the same entity serialize on the advisory lock. The second sees the first's committed rows, so it computes `v2` and supersedes `v1` instead of colliding on `v1` or corrupting the `superseded_by_document_id` chain. Verified in smoke: two rapid generates each produced `v1` (both `PENDING_SIGNATURE`, no lineage entry yet), then issuing `v1` and generating again produced `v2` and marked `v1` `SUPERSEDED`.
- **Keying caveat**: `hashtext` collisions are possible in theory across different `entityType`/`entityId` pairs; over-locking (false serialization) is the only consequence — never under-locking.

---

## 4. Failure recovery strategy during rendering

- **No DB write until the PDF is provably good.** Both render passes and both checksums complete *before* the transaction starts. The stored `checksum_sha256` is the SHA-256 of the pass-2 bytes — the exact file that is later renamed into place — so a verification lookup always matches the on-disk document.
- **Temp file + atomic rename.** Passes render to `.tmp_<uuid>.pdf` in the same directory as the target, so the final `fs.rename` is a same-filesystem rename (no cross-volume copy). The final name `{safeCode}_{number}_v{versionNo}.pdf` embeds the version computed inside the lock, so filename and DB row can never disagree.
- **Cleanup in `finally`**: the browser is always closed and the temp file removed with `{ force: true }` on every exit path — success, render error, or DB error. No orphaned `.tmp_*.pdf` or leaked Chrome processes.
- **Failure matrix**:
  | Failure | Consequence | Recovery |
  |---|---|---|
  | Pass 1 or pass 2 render throws | No temp leftovers (finally), no DB rows | Caller sees 500; retry starts a fresh render |
  | DB transaction fails (constraint, RLS, lock contention) | Transaction rolls back — no document/version/audit rows | Number sequence gap is acceptable (standard sequence semantics); retry allocates a new number |
  | `fs.rename` fails after commit (same-dir rename; near-impossible on Windows) | Document row exists but file not at `storage_path`; temp removed | Detected by verification/`storage_path` check; regenerate on next generate |
  | Process crash mid-transaction | `_xact_` lock auto-released; uncommitted rows rolled back by PG; temp file remains (only leftover, harmless) | Next generate re-renders |
- **Audit integrity**: `GENERATED`/`SUPERSEDED` audit rows are written in the same transaction as the rows they describe — an audit entry can never exist without its subject, and `markSuperseded` only flips the old document once the new one is fully committed.
