# ERM-System Forms Library — UI Specifications (v2)

> Version 2.0 · 2026-08-02 · Status: Approved
> Specifies the interactive form renderer, page composition, RTL/bilingual behavior, and component contracts for the ~50-form library. Builds on the current implementation (`SchemaForm.tsx`, `FormFillPage.tsx`, `FormLibraryPage.tsx`, `DocumentPanel.tsx`, `VerifyPage.tsx`) and extends it per the audit findings.

---

## 1. Architecture

```
FormLibraryPage (list of form definitions, filter by category)
   └─ navigate → /forms/fill/:instanceId
FormFillPage
   ├─ Header (title, code, version, entity, status badge)
   ├─ Score banner (computed total_score + recommendation)
   ├─ SchemaForm (editable when DRAFT/RETURNED, read-only otherwise)
   │    ├─ SectionRenderer (title, collapsible?, description)
   │    │    └─ FieldInput per field (type-dispatched)
   │    │         └─ validation messages
   ├─ Action bar (auto-save indicator, Save Draft, Submit)
   └─ DocumentPanel (list documents for instance)
        ├─ Generate (language select)
        ├─ Download / Detail dialog / Sign / Revoke
        └─ Live invalidation via queryKey ['form-documents', instanceId]
VerifyPage (public, no auth) — verification portal
```

## 2. SchemaForm Renderer

### 2.1 Field types (current → target)

| Field type | Current (`SchemaForm.tsx`) | Target |
|---|---|---|
| `text` | `Input` | keep |
| `textarea` | `Textarea` | keep; add `multiline` alias |
| `number` | `Input type=number` | keep |
| `date` | `Input type=date` | keep |
| `boolean` | `Switch` + "نعم/لا" | keep |
| `select` | native `<select>` | keep (native for a11y) |
| `radio` | chip `OptionField` buttons | keep |
| `scale` | round buttons `min..max` | keep; support configurable `min`/`max`/`step` |
| `email` | ❌ | **add** (`Input type=email` + email pattern) |
| `tel` | ❌ | **add** (`Input type=tel`) |
| `file` | ❌ | **add** (`FileUpload` — stores metadata ref, file goes to documents store) |
| `checkbox` | ❌ | **add** (multi-select / boolean group) |

### 2.2 Field attributes

| Attribute | Current | Target |
|---|---|---|
| `required` | ✅ | keep |
| `conditional {field, equals}` | ✅ | keep; add `notEquals`, `in []`, `dependents` for stronger branching |
| `min` / `max` | ✅ | keep |
| `maxLength` | ✅ | keep |
| `pattern` | ✅ | keep (regex) |
| `rows` | ✅ | keep |
| `default` | ❌ | **add** — applied on instance creation when response missing |
| `placeholder` | ❌ | **add** — bilingual `{ar, en}` |
| `help` | ❌ | **add** — bilingual help text under the label |
| `multiline` | ❌ | **add** |
| `step` | ❌ | **add** (number/scale) |
| `readOnly` | ❌ | **add** (autofilled server fields) |
| `hidden` | ❌ | **add** (system fields like application_number, reviewer_id) |

### 2.3 Computed fields

- `schema.computed.total_score = {type:'mean', fields:[...]}` — supported in UI live-score (`FormFillPage.liveScore`).
- **Target:** generalize to `computed.<key> = {type: 'mean'|'sum'|'min'|'max'|'concat', fields:[]}`; server materializes into `form_instances.total_score` on submit (see API/DB specs).

### 2.4 Validation

- Client: local per-field (`validateField`) → error i18n keys `schemaForm.errors.{required,pattern,maxLength,min,max,type}`.
- **Target:** renderer supports submitting; **server** (re-)validates responses against the stored schema (Zod generated from JSON Schema) and returns `validationErrors[]` on 400. `FormFillPage.submit.onError` already renders `validationErrors.join('; ')`.

### 2.5 Sections

- Current: flat list, header per section, `space-y-5`.
- **Target:** `collapsible` + `collapsedDefault` (from meta-schema), `description` under title, and **Stepper/Tabs** navigation for long official forms (FRM-001 protocol, FRM-034 consent).

---

## 3. Pages

### 3.1 FormLibraryPage (`/forms`)
- Grid of `FormDefinition` cards; show `form_name_ar/en`, `category`, `workflow_stage`, `version_no`, `is_active`.
- **Target:** category filter chips using the six task categories (General/Review/Committee/Official Documents/Study Monitoring/Participant); "New instance" action (entity picker) for forms with `entity_type` required; language toggle AR/EN.

### 3.2 FormFillPage (`/forms/fill/:instanceId`)
- Edit state only when `DRAFT`/`RETURNED`; read-only otherwise (verified).
- Auto-save: 800 ms debounce → `saveFormDraft`; indicator `saving → saved`.
- Submit: posts full `responses`; success → status `SUBMITTED`, invalidates `['form-instance', id]`.
- DocumentPanel appears when `status ∉ {DRAFT, VOID}`.
- Score banner shows `total_score` + `recommendation` (server values after submit).

### 3.3 DocumentPanel (instance documents)
- Lists `GET /forms/instances/:id/documents` results.
- Actions: generate (choose `language`), download, detail dialog (versions + audit + signatures), sign, lifecycle (revoke/void).
- All query keys numeric: `['form-documents', Number(entity_id)]`.

### 3.4 VerifyPage (public verification portal) — target expansion
- Input: document reference number (or UUID).
- Shows: status, title, version(s), issue/revocation dates, checksum, signatures (names/roles/timestamps), superseded-by link, revocation reason, **audit timeline**.
- **New:** live checksum comparison — user uploads the PDF → `POST /api/documents/checksum` → `VALID / INVALID / MODIFIED`.

---

## 4. RTL / Bilingual Contract

- All label/help/placeholder/options/section-title objects are `{ar, en}`; renderer picks active language (`i18n.language.startsWith('ar')`).
- RTL handled globally via `document.documentElement.dir`; icons flipped with `rtl:rotate-180`.
- Official PDF generation is **backend-side**; `language` + `dir` passed in generate request (see API spec).
- All new strings added to `ar.json`/`en.json` under `formLibrary.*`, `formFill.*`, `schemaForm.errors.*`, `documentPanel.*`, `verify.*`.

---

## 5. Component Inventory

| Component | Status | Purpose |
|---|---|---|
| `SchemaForm.tsx` | ✅ | dynamic renderer (extend per §2) |
| `DocumentPanel.tsx` | ✅ | generated-doc management per instance |
| `FormFillPage.tsx` | ✅ | fill + autosave + submit + panel |
| `FormLibraryPage.tsx` | ✅ | definition library |
| `VerifyPage.tsx` | ✅ | public verification (extend per §3.4) |
| `FieldInput` / `ScaleField` / `OptionField` | ✅ | internal renderer pieces |
| `ui/checkbox` | ❌ | **add** (shadcn-style) |
| `ui/file-upload` | ❌ | **add** |
| `ui/date-picker` | ❌ | optional (native `date` acceptable) |
| `Stepper` | ❌ | **add** for multi-section official forms |
| `SignatureBlock` | ❌ | **add** — displays multiple signatories with status (multi-signature feature) |

---

## 6. Accessibility

- Native `<select>`, `<label htmlFor>`, visible focus, `disabled` states preserved.
- Buttons used for radio/scale must expose `aria-pressed` / group role.
- Color not sole indicator: status badges include text labels (AR/EN).
- Keyboard: full tab order through sections; Enter submits (guarded by `required`).
