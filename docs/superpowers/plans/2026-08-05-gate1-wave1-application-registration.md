# Gate 1 — Wave 1 — Research Application Registration (FRM-001 / APP_PROTOCOL)

> Implementation plan · Phase 1 · One form at a time (stop-for-review after each form).
> Baseline: Gate 0 approved (2026-08-04). This plan covers ONLY the first Wave 1 form.

## 1. Audit verdict (Reuse / Refactor / Replace / Remove)

### Reuse (no redesign)
| Asset | Where | Use for FRM-001 |
|---|---|---|
| Form Runtime (schema-driven) | `form_definitions.form_schema` JSONB + `FormService` + `SchemaForm.tsx` + `FormFillPage.tsx` | Render + validate + autosave + submit + generate |
| `forms` module routes | `backend/src/modules/forms/forms.routes.ts` | Instances CRUD, submit, generate, download |
| Forms RLS | seed 55 policies (`fd_*`, `fi_*`) | Access control (never touch RLS) |
| Workflow engine | `WorkflowService.executeTransition` + `APP_REVIEW_V1` | Application state machine (`SUBMIT`) |
| Document platform | `DocumentRenderService.render()` | Official PDF with lifecycle, versioning, watermark, QR+checksum, signatures |
| i18n/RTL | react-i18next, logical CSS properties | Bilingual ar/en, RTL/LTR |
| UI primitives | `components/ui/*` | Buttons, cards, inputs, badges |

### Refactor (extend, backward-compatible — does NOT touch the 8 seeded forms)
| Change | Why |
|---|---|
| Move `FieldDef`/`SectionDef`/`FormSchema` to `backend/src/shared/types.ts` (exported) | No shared backend contract today; contract duplicated in `form.service.ts` + `frontend/.../types.ts` |
| Extract pure validation/computed logic into `backend/src/services/form-validation.ts` | Testable without DB; keeps `FormService` thin |
| Extend schema engine: types `email/tel/checkbox`, conditional ops `ne/in`, `dependencies` (cross-field), computed `sum/count`, field metadata `placeholder/helpText/unit`, top-level `wizard` + `workflow` + `document` config | FRM-001 needs a long protocol form + workflow + document integration |
| `FormService.submitInstance` → config-driven workflow hook (schema `workflow` block) inside one transaction | "No hardcoded workflow logic; transitions use the workflow engine" |
| Wire `POST /forms/documents/:id/sign` + `/lifecycle` routes; route revoke/void through the Gate-0 document lifecycle engine | Fix pre-existing 404 (frontend already calls them); use lifecycle engine not legacy `status` |

### Replace
- `Applications/Create.tsx` + `Edit.tsx` hardcoded wizards → **deferred**: the 4-field shell (project/committee/type) stays for Wave 1 as the application entry point; the full protocol is captured by the APP_PROTOCOL form through the Form Runtime. Merging the shell into the form flow is a follow-up item (needs a lookup/entity-picker field type).

### Remove
- Nothing is removed. All seeded Gate 0 forms keep working unchanged.

## 2. Design

### 2.1 Flow
```
Researcher: POST /core/applications?save_as_draft=true   (shell: project/committee/type)
        →  Form Library → Application Registration (Protocol)
        →  POST /forms/instances { form_code: APP_PROTOCOL, entity_type: Application, entity_id }
        →  FormFillPage (wizard mode) → autosave drafts (existing PUT)
        →  Submit → [validate] → form instance SUBMITTED + workflow SUBMIT (APP_REVIEW_V1)
                            → application.current_status = COMMITTEE_REVIEW
        →  Generate official document (APPLICATION_DOC → REC-YYYY-NNNN) via document platform
```

### 2.2 Schema capabilities added (backward compatible)
- Field types: `email`, `tel`, `checkbox` (value = `string[]`).
- `conditional`: `{ field, op?: 'eq'|'ne'|'in', equals?, value? }` — `equals` stays valid.
- `dependencies`: `[{ field, op: 'lt'|'lte'|'gt'|'gte'|'eq'|'ne', value?|valueField? }]` cross-field validation.
- `computed`: `mean` (existing) + `sum` + `count` (non-empty) + `count_checked` (checkbox options).
- Field metadata: `placeholder`, `helpText`, `unit`.
- Schema-level: `wizard: true`, `workflow: { entity_type, transition_on_submit }`, `document: { template_code, document_type }`.

### 2.3 APP_PROTOCOL sections (national MOH research-ethics protocol, ICH-GCP E6(R3) + CIOMS)
1. `applicant` — Applicant & Principal Investigator (name, email, tel, department, position).
2. `study_overview` — bilingual title, study type/design, summary, objectives, dates, funding, multi-center.
3. `participants` — population, inclusion/exclusion, vulnerable groups, sample size + justification, recruitment.
4. `methodology` — procedures, data collection, analysis, biospecimens (+ conditional storage).
5. `ethics` — risk level + justification, benefits, consent (+ conditional process), waiver (+ conditional), compensation, confidentiality, retention, anonymization, data transfer (+ conditional).
6. `attachments` — required-document checklist + computed readiness counter.

### 2.4 Workflow integration
`schema.workflow = { entity_type: 'Application', transition_on_submit: 'SUBMIT' }`. On submit, `FormService` executes `WorkflowService.executeTransition('Application', entity_id, 'SUBMIT', user)` inside the same transaction, then syncs `core.applications.current_status` via `ApplicationRepository.updateStatus`, then sends `APPLICATION_SUBMITTED` notification + dashboard event (reuses existing primitives). Transition names/codes stay DB-driven.

### 2.5 Document integration
`schema.document = { template_code: 'APPLICATION_DOC', document_type: 'APPLICATION' }`. Seed adds:
- `documents.document_types` row `APPLICATION`.
- `APPLICATION_DOC` template (ar + en) with `ON CONFLICT DO NOTHING`.
- `DocumentNumberingRepository.DEFAULT_PREFIXES['APPLICATION'] = 'REC'`.
Render goes through `DocumentRenderService.render()` → lifecycle `PENDING_SIGNATURE`, versioning, QR+checksum, watermark, signature slots.

## 3. Implementation steps

1. Backend: shared schema types + `form-validation.ts` (pure functions) + extend engine.
2. Backend: workflow hook in `submitInstance` (transactional) + notification; repo `submit` gains optional `client`.
3. Backend: wire sign/lifecycle routes; revoke/void via `DocumentLifecycleService`.
4. Seed `64-application-registration.sql` (idempotent).
5. Frontend: extend `types.ts` + `forms/validation.ts` helper.
6. Frontend: extend `SchemaForm` (new types/ops/groups) + build `FormWizard` + wire `FormFillPage`.
7. Tests: backend `form-validation.test.ts`; frontend validation + wizard tests.
8. Apply seed 64, live smoke (create shell → fill → submit → workflow → generate PDF → verify number/lifecycle).
9. Docs: this plan, `docs/forms/01-forms-catalog.md` FRM-001 status, `docs/forms/08-ui-specs.md` wizard mode.
10. Quality gates: backend lint → backend test → frontend lint → frontend test → frontend build. Commit (exclude pre-existing dirty files `application.service.ts`, `Applications/Edit.tsx`).

## 4. Success criteria (this form)
- Form renders via Form Runtime in wizard mode (stepper/progress/section nav/sticky validation/review summary/print).
- Draft autosave, submit validation (incl. email/tel/checkbox/conditionals/dependencies) enforced server-side.
- Submit advances `APP_REVIEW_V1` workflow to `COMMITTEE_REVIEW` and notifies.
- Generate produces immutable `REC-YYYY-NNNN` PDF with lifecycle + checksum + QR.
- Existing 8 seeded forms unaffected; existing 9 backend test failures unchanged (no new regressions).
