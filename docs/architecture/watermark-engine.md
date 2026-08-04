# Watermark Engine — Architecture

**Status**: Implemented (2026-08-04) — Task 7 (user roadmap), maps to plan Task 6
**Scope**: Backend domain engine + target adapters, thin HTTP transports, render-service integration
**Quality gate**: A future render target (PDF, print, image) registers an adapter **without any engine or config change**; a custom watermark type registers a type renderer **without any engine change**.

---

## 1. Overview

The watermark engine produces **target-agnostic watermark layouts** from
configuration rows in `documents.document_watermark_config`, then lets a
**target adapter** convert a layout into the concrete output (HTML overlay today;
PDF, print, and image tomorrow). The engine knows nothing about PDFs, HTML,
pixels, or millimeters — rendering behavior is never hardcoded into the engine.

### Dependency flow

```
Config (DB row)                    WatermarkConfigRow
   → WatermarkRepository           (data access, extends AuditableRepository)
      → WatermarkEngine            (type renderers + condition evaluation → WatermarkLayout)
         → WatermarkAdapter        (target-specific layout → { html, css } | { ... })
            → WatermarkService     (facade: listConfigs, renderOverlay, overlayHtml, overlayCss)
               → render service / routes
```

The render service never contains watermark logic; it only requests an overlay
and injects it into the shell.

---

## 2. Core contracts

File: `backend/src/services/watermark/types.ts`

| Concept | Purpose |
|---------|---------|
| `WatermarkConfigRow` | A `document_watermark_config` row. Repository maps `SELECT *` and is tolerant of `type`/`condition` being absent (defaults `TEXT` / `null`). |
| `WatermarkCondition` | Declarative conditional-rendering spec: `{ all: [{ field, op, value }] }`, op ∈ `eq\|neq\|in\|not_in`. **ALL** semantics — every clause must hold. |
| `WatermarkRenderContext` | `{ language: 'ar'\|'en', target, values?: Record<string,string> }` — `values` carries the fields the conditions evaluate (e.g. `{ status: 'REVOKED' }`). |
| `WatermarkTile` | One watermark instance: geometry in **normalized 0..1 coordinates** (`x`, `y`, `rotationDeg`) + `text` + style tokens (font/size/color/opacity). |
| `WatermarkLayout` | `{ type, target, tiles, metadata }` — target-agnostic; the engine's output and the adapter's input. |

---

## 3. Engine

File: `backend/src/services/watermark/engine.ts`

- `WatermarkEngine.render(code, context)`:
  1. Looks up the config row (`findByCode`).
  2. Returns `null` when not found, or when `context` fails the config's `condition`.
  3. Delegates to the registered `WatermarkTypeRenderer` for the config `type`
     (unregistered custom type falls back to the TEXT renderer).
  4. A renderer returning zero tiles → `null` layout (caller renders no overlay).
- `WatermarkEngine.listConfigs()` — all active configs.
- `WatermarkTypeRenderer` — `key` + `build(config, text, context) → WatermarkLayout | null`.
  Custom watermark types register here (composition root), never in the engine.

Localization is the engine's job: `context.language === 'en'` selects
`text_en` with `text_ar` fallback; otherwise `text_ar`.

---

## 4. Type renderers

File: `backend/src/services/watermark/type-renderers.ts`

`TextWatermarkTypeRenderer` builds tiles for the six positions
(`CENTER`, `TOP_LEFT`, `TOP_RIGHT`, `BOTTOM_LEFT`, `BOTTOM_RIGHT`) in
normalized coordinates, applying rotation and the config's font/size/color/
opacity. New types (e.g. a full-page repeating pattern or an image stamp) are
added as new `WatermarkTypeRenderer` implementations registered in the
composition root — no engine change.

---

## 5. Target adapters

File: `backend/src/services/watermark/adapters.ts`

`WatermarkAdapter.render(layout) → { html, css }` (or a future target's DTO).
- `HtmlWatermarkAdapter` maps normalized coordinates to `left/top:NN%`,
  centers each tile with `translate(-50%, -50%)`, applies `rotate()`, emits
  `data-wm-type` markers, and **escapes all text and attribute values**.
- Adapters are keyed by target (`html` today) in `createWatermarkAdapters()`
  (`backend/src/services/watermark/registry.ts`).

Adding a target = registering one adapter; layout geometry and configs are
reused unchanged.

---

## 6. Facade + integration

File: `backend/src/services/watermark/service.ts`

`WatermarkService` composes engine + adapters and exposes `listConfigs()`,
`renderOverlay(code, language, target, values)`, `overlayHtml(...)`,
`overlayCss(...)`. `renderOverlay` returns `null` when the target has no
adapter, the code is unknown, or the condition fails.

### Render service integration

`backend/src/services/document-render.service.ts`:
- `RenderRequest.watermark?: { code: string; values?: Record<string,string> }`.
- The engine + HTML adapter are constructor-injected
  (`createWatermarkEngine()`, `createWatermarkAdapters().get('html')`).
- `resolveWatermarkOverlay(code, language, values)` resolves the overlay
  **before** the single `shellHtml` build and injects
  `<style>…</style>…overlay…` just before `</body>`. A watermark engine error
  is logged and **skipped** (the document still renders).

`backend/src/services/form.service.ts` threads `opts.watermark` through to the
render request, so form-generated documents can request a watermark by code.

### Routes

`backend/src/modules/documents/documents.routes.ts`:
- `GET /api/v1/documents/watermarks` (authenticated) — list active configs.
- `POST /api/v1/documents/:id/preview-watermark` (authenticated, body
  `{ code, language? }`) — returns `{ html, css }`. Unknown code → 404;
  a known code whose condition fails → `{ html: '', css: '' }` (legitimately
  no watermark for that context).

### Configuration & migration

`backend/seed/62-watermark-engine.sql` extends
`documents.document_watermark_config` with:
- `type VARCHAR(30) NOT NULL DEFAULT 'TEXT'` — discriminator for type renderers.
- `condition JSONB` — conditional rendering, e.g.
  `{"all":[{"field":"status","op":"eq","value":"REVOKED"}]}`.

The seven seeded configs (`DRAFT/COPY/VOID/SUPERSEDED/REVOKED/EXPIRED/CUSTOM`)
remain `TEXT`; `REVOKED` additionally carries the example condition above.
The repository maps `SELECT *` so the columns may be added/removed without
code changes. RLS permits `SELECT` on the config table; no writes are exposed.

---

## 7. Extension model (how to add)

| Want to… | Do this |
|----------|---------|
| Add a watermark text/look | Insert/update a row in `documents.document_watermark_config` (no code). |
| Render a watermark only in some states | Set the row's `condition` JSONB; pass the state via `RenderRequest.watermark.values`. |
| Support PDF / print / image output | Register a new `WatermarkAdapter` in `createWatermarkAdapters()` — engine + configs unchanged. |
| Add a custom watermark type (pattern, image, QR) | Implement `WatermarkTypeRenderer` and register it in `createWatermarkEngine()` — engine unchanged; unknown types fall back to TEXT. |

---

## 8. Security & constraints

- Watermark config is **read-only** via RLS (`lookup_select`); the API exposes
  no write path — config changes are DBA/seed controlled.
- All rendered text and attribute values are escaped by the adapter (XSS-safe
  when the overlay is injected into HTML shells).
- Engine errors are caught at the render-service boundary: a watermark failure
  never blocks document issuance.
- RLS is never disabled; `WatermarkRepository` goes through
  `AuditableRepository` (sets `app.user_id` per request).

---

## 9. Watermark precedence strategy

The current engine resolves **one config per call** (`engine.render(code, ctx)`);
a single code is the only composition mode exposed today. The strategy below
is the design contract for multi-watermark selection and composition. It is
**additive** — it requires no change to renderers, adapters, config columns, or
the DB. The engine already provides the two primitives it needs: per-config
condition evaluation and a target-agnostic `WatermarkLayout`.

### 9.1 Selection (which configs are candidates)

- `RenderRequest.watermark` carries an **ordered list** of candidate codes
  (`{ code, values? }` each). Today it is a single code; that is the list of
  length one.
- Each candidate goes through the **same pipeline**: condition evaluation →
  type renderer → layout. Candidates whose `condition` fails, whose type is
  unknown (no registered renderer and no TEXT fallback), or whose renderer
  produces zero tiles are **skipped before priority is applied**.

### 9.2 Priority (who wins)

- **Order = priority**: the position in the requested list is the primary
  priority (first = highest). This mirrors the verification-platform
  precedence rule (registration order = priority, first match shadows later
  providers).
- **Optional tie-breaker (future, config-driven)**: a `priority INT` column on
  `document_watermark_config` (lower number = higher priority, default e.g.
  `100`) breaks ties, then requested list position, then config `id`. Adding
  the column is an optional migration; selection is orchestration and needs no
  engine change.

### 9.3 Composition rules (how selected configs combine)

Two modes, chosen **per request or per config** — never hardcoded:

1. **`single` (default) — winner-take-all.** After skipping condition-failing
   candidates, the highest-priority applicable config renders; all lower-
   priority configs are shadowed. Prevents overlapping watermarks and preserves
   legibility (e.g., a `REVOKED` doc shows only `REVOKED`, never `REVOKED` + `DRAFT`).
2. **`layered` (opt-in) — cumulative.** Every matching config renders, subject
   to the **slot conflict rule**: two configs targeting the same `position`
   must not both draw — the higher-priority one wins that slot, the others draw
   in their distinct slots (e.g., `CENTER` DRAFT + `TOP_LEFT` CONFIDENTIAL
   compose; two `CENTER` configs do not).

**Merging:** layered layouts combine at the orchestration layer by
concatenating tiles into one `WatermarkLayout` — each tile already carries its
own anchor/coordinates, so adapters render the merged layout unchanged.

### 9.4 Edge rules (already enforced)

- No applicable config → empty overlay (document renders without watermark).
- Engine error → watermark skipped, warning logged; watermark selection never
  affects the document record, checksum, or lifecycle.
- Precedence is evaluated against the **document context** (`values`, e.g.
  `{ status: 'REVOKED' }`), so the same request can resolve to different
  watermarks for different documents.

---

## 10. Future renderer support

### 10.1 Current boundary

`WatermarkTypeRenderer` (engine, §3) is the registration point for **content
kinds**, and `WatermarkAdapter` (§5) for **targets**. Today the tile model is
text-only (`WatermarkTile.text`, §2) and one renderer (`TEXT`) plus one adapter
(`html`) are registered. Adding a content kind or a target is always a
**new registration, never an engine change** — that part of the design already
holds.

### 10.2 Content model (additive evolution)

`WatermarkTile` gains a discriminated content union while geometry
(`x`, `y`, `anchor`, `rotationDeg`, `opacity`) stays shared:

```
content: { kind: 'text',  text: string }
       | { kind: 'svg',   svg: string }                     // inline markup
       | { kind: 'image', src: string, widthMm?: number, heightMm?: number }
```

The TEXT renderer keeps emitting the text tile (backward compatible); the
geometry stays adapter-relevant only.

### 10.3 Planned renderers (register in `createWatermarkEngine()`)

| Renderer | Kind | Produces |
|----------|------|----------|
| `TextWatermarkTypeRenderer` | `TEXT` (implemented) | localized text tiles |
| `SvgWatermarkTypeRenderer` | `SVG` (future) | vector tiles from config `payload` (seals, patterns) |
| `ImageWatermarkTypeRenderer` | `IMAGE` (future) | raster tiles from an asset reference / data URL, scaled in mm |
| Custom domain renderers | any code (future) | e.g. QR/barcode, institutional seal, department stamp |

Unknown/unregistered types already fall back to `TEXT` (§3), so an unregistered
future renderer degrades gracefully instead of failing.

### 10.4 Config & adapters

- **Config:** an optional `payload JSONB` column (SVG markup, asset key, repeat
  parameters) is a forward-compatible migration — the repository maps `SELECT *`
  and is already tolerant of absent columns.
- **Adapters:** each adapter switches on `content.kind`. `HtmlWatermarkAdapter`
  renders inline SVG / `<img>` for the new kinds today; future `pdf` / `image` /
  `print` adapters embed vector or raster content natively. No engine changes.

### 10.5 Design-gate claim

Both extensions (multi-watermark precedence §9 and non-text renderers §10) are
supported by the current architecture with **additive changes only**: an
orchestration method for selection/merging (§9) and new renderers + a content
union + optional `payload` column (§10). No renderer, adapter, condition,
config-semantics, or DB-backwards-compatibility change is required.

