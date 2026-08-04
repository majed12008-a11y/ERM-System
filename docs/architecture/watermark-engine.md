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
