# Template Engine — Post-RC1 Activation Plan

> Documentation only. No code changes. No route activation. No seed data modifications.
> Created: 2026-07-14

---

## 1 — Current Production Path

The only active document generation in the system is the legacy certificate pipeline. It operates independently of the versioned template engine.

```
CertificateService
  │
  ├─ reads template HTML from documents.templates
  │   (template_code = 'APPROVAL_CERTIFICATE_V1')
  │
  ├─ builds Handlebars context from 5 joined tables:
  │   core.applications, core.projects, security.users,
  │   committee.committees, security.institutions
  │
  ├─ compiles via Handlebars.compile(templateContent)(ctx)
  │
  ├─ renders PDF via Puppeteer-core (page.setContent → page.pdf → A4)
  │
  ├─ writes file to uploads/certificates/{serialNumber}.pdf
  │
  ├─ creates documents.documents record
  │
  └─ links document to documents.approval_certificates
```

**Tables read:** `documents.templates`, `core.applications`, `core.projects`, `security.users`, `committee.committees`, `security.institutions`

**Tables written:** `documents.documents`, `documents.approval_certificates`, `documents.approval_certificate_documents`

**Template storage:** `documents.templates.template_content` — single HTML blob per template code, no versioning, no localization, no variable metadata.

**Notification rendering** uses a separate system: `TemplateRendererService` reads from `communication.notification_templates` by `(template_code, channel_type)` and renders subject/body for email/SMS delivery. This is independent of both the legacy certificate path and the versioned template engine.

---

## 2 — Future Target Architecture

The versioned template engine provides a unified document generation pipeline that replaces both the legacy certificate path and ad-hoc notification rendering.

```
Business Module (Application, Committee, Notification, etc.)
  │
  ├─ calls ApplicationDocumentService.generateApprovalLetter()
  │   or CommitteeDocumentService.generateFinalDecision()
  │   or NotificationDocumentService.generateStatusChangeNotification()
  │
  ▼
TemplateIntegrationService.renderModuleDocument(moduleKey, variables, userId)
  │
  ├─ MODULE_DOCUMENTS[moduleKey] → { templateCode, version, entityType }
  │
  ▼
TemplateEngineService.render({ templateCode, version, variables, locale })
  │
  ├─ IEngineVersionRepository.findByCodeAndVersion()
  │   → reads templates.template_versions (JSONB content, variable_definitions)
  │
  ├─ TemplateResolverService.resolveFromVariableDefinitions()
  │   → resolves entity data via registered IResolver implementations
  │   → caches resolved values per entity
  │
  ├─ Handlebars.compile(version.content)(resolvedVariables)
  │   → renders HTML from versioned, localized template content
  │
  ▼
SnapshotService.createSnapshot()
  │
  ├─ SHA-256 hash of rendered output
  │
  ├─ links to entity (Application, Meeting, etc.)
  │
  └─ audit trail in memory (transient; future: template_render_history)
```

**Tables read (versioned engine):**

| Table | Purpose |
|-------|---------|
| `templates.templates` | Template metadata by code (category, engine, default_locale) |
| `templates.template_versions` | Version content (JSONB), status, variable_definitions, effective dates |
| `templates.template_localizations` | Per-locale content overrides |
| `templates.template_variables` | Variable registry (resolver_path, source_type, defaults) |
| `templates.template_partials` | Reusable HTML fragments |
| `templates.template_approval_workflow` | Multi-step approval pipeline for template versions |

**Tables written (versioned engine):**

| Table | Purpose |
|-------|---------|
| `templates.template_render_history` | Append-only audit of every render |
| `templates.template_outputs` | Generated file metadata (storage_path, checksum, duration) |
| `templates.template_usage_statistics` | Per-template usage counters |
| `templates.template_version_audit` | Version status transitions |

---

## 3 — Migration Strategy

### Phase 1 — Seed Versioned Template Content (No Code Changes)

**Goal:** Populate the `templates.*` tables with the template content that the engine will read.

**Scope:**
- Insert 12 template records into `templates.templates` (one per unique templateCode from MODULE_DOCUMENTS)
- Insert 12 initial APPROVED versions into `templates.template_versions` with JSONB content matching the existing HTML templates
- Insert variable definitions into `templates.template_variables` for each template's placeholders
- Insert locale records into `templates.template_localizations` for Arabic and English

**Templates to seed:**

| templateCode | Source | Current Format |
|-------------|--------|----------------|
| `protocol-full` | New | HTML with Handlebars placeholders |
| `certificate-approval` | `documents.templates` WHERE code = `APPROVAL_CERTIFICATE_V1` | HTML |
| `condition-letter` | New | HTML |
| `decision-standard` | New | HTML |
| `meeting-minutes` | New | HTML |
| `accreditation-cert` | New | HTML |
| `consent-standard` | New | HTML |
| `safety-report` | New | HTML |
| `risk-assessment` | New | HTML |
| `notification-status-change` | `communication.notification_templates` | subject + body |
| `email-generic` | New | HTML |
| `report-annual` | New | HTML |

**Dependencies:** None. Can be done independently.

**Risk:** Low. Seed data only. No existing behavior changes.

---

### Phase 2 — Wire ApplicationDocumentService

**Goal:** Activate application-level document generation via the versioned engine.

**Scope:**
- Import `ApplicationDocumentService` into `backend/src/modules/applications/index.ts`
- Instantiate with `TemplateIntegrationService` (which requires `TemplateEngineService` + `SnapshotService` + `IEngineVersionRepository`)
- Wire `generateApprovalLetter` to be called when an application transitions to APPROVED
- Wire `generateRejectionLetter` to be called when an application transitions to REJECTED
- Wire `generateConditionalApproval` to be called when an application transitions to CONDITIONAL
- Keep legacy `CertificateService` active for certificate generation (no change)

**Services to instantiate:**

```typescript
import { TemplateEngineService } from '../../services/template-engine.service';
import { TemplateIntegrationService } from '../../services/template-integration.service';
import { SnapshotService } from '../../services/template-snapshot.service';
import { ApplicationDocumentService } from '../../services/document-generation.service';
import { EngineVersionRepository } from '../../repositories/engine-version.repository';

const versionRepo = new EngineVersionRepository();
const engine = new TemplateEngineService(versionRepo);
const snapshotService = new SnapshotService();
const integration = new TemplateIntegrationService(engine, snapshotService, versionRepo);
const appDocService = new ApplicationDocumentService(integration);
```

**Module keys activated:** `application.submission`, `application.receipt`, `application.correction`, `application.approval`, `application.conditional`, `application.rejection`, `application.withdrawal`

**Dependencies:** Phase 1 (seeded template content)

**Risk:** Medium. New code path for document generation. Parallel execution with legacy path means both produce output during transition. SnapshotService is in-memory only — renders are not persisted to DB until template_render_history is wired.

---

### Phase 3 — Wire CommitteeDocumentService

**Goal:** Activate committee-level document generation.

**Scope:**
- Import `CommitteeDocumentService` into `backend/src/modules/committee/index.ts`
- Wire `generateFinalDecision` to be called after committee voting completes
- Wire `generateMeetingMinutes` to be called when meeting minutes are saved
- Wire `generateMeetingAgenda` to be called when meetings are scheduled
- Wire `generateReviewSummary` to be called after review completion

**Module keys activated:** `meeting.agenda`, `meeting.minutes`, `committee.review`, `committee.decision`

**Dependencies:** Phase 2 (TemplateIntegrationService wiring pattern established)

**Risk:** Low. Committee document generation is additive — no existing behavior changes.

---

### Phase 4 — Wire Notification Generation

**Goal:** Activate notification document generation via the versioned engine.

**Scope:**
- Import `NotificationDocumentService` into notification delivery pipeline
- Wire `generateStatusChangeNotification` to be called when application status changes
- Wire `generateGenericEmail` to be called for ad-hoc notifications
- Maintain existing `TemplateRendererService` → `communication.notification_templates` path as fallback

**Module keys activated:** `notification.status`, `email.generic`

**Dependencies:** Phase 2 (TemplateIntegrationService available)

**Risk:** Low. Notification rendering already works via legacy path. New engine produces HTML that can be sent alongside or instead of legacy output.

---

### Phase 5 — Parallel Validation

**Goal:** Run both legacy and engine paths simultaneously. Compare outputs to verify equivalence before replacement.

**Scope:**
- Activate engine rendering for `application.approval` alongside legacy `CertificateService`
- Engine output is internal only — not exposed to end users
- For every certificate generated by the legacy path, also render via the engine in the background
- Log comparison results to a dedicated validation table or structured log

**Comparison dimensions:**

| Dimension | Legacy Source | Engine Source | Comparison Method |
|-----------|--------------|---------------|-------------------|
| Rendered HTML | `CertificateService` Handlebars output | `TemplateEngineService.render().html` | DOM diff or normalized string comparison |
| Generated PDF | `uploads/certificates/{serial}.pdf` | Engine-rendered PDF (temp path) | Byte-level checksum (SHA-256) |
| Variables | `buildTemplateContext()` context object | `TemplateResolverService` resolved map | Key-by-key value comparison |
| Metadata | `documents.approval_certificates` record | `SnapshotService` snapshot metadata | Field comparison (template code, version, timestamp) |
| Generation time | `Date.now()` delta in `CertificateService` | `RenderResult.resolutionTimeMs` | Numerical comparison (engine should be ≤ 2× legacy) |
| Output checksum | SHA-256 of legacy PDF bytes | SHA-256 of engine PDF bytes | Exact match required for promotion |

**Comparison logging:**

```
validation_id | application_id | legacy_html_hash | engine_html_hash | html_match
              | legacy_pdf_hash | engine_pdf_hash | pdf_match
              | variable_diff | metadata_diff | legacy_ms | engine_ms
              | created_at | status (PASS/FAIL)
```

**Promotion criteria — all must be satisfied:**

| # | Criterion | Threshold |
|---|-----------|-----------|
| 1 | HTML output equivalence | 100% match on normalized output (whitespace normalization allowed) |
| 2 | PDF output equivalence | SHA-256 checksum match on rendered PDFs |
| 3 | Variable resolution completeness | All variables resolved; no undefined placeholders in engine output |
| 4 | Performance | Engine render time ≤ 2× legacy render time (p95 over 100 renders) |
| 5 | No rendering regressions | 0 visual differences in certificate layout, fonts, images, QR codes |
| 6 | Rollback procedure validated | Legacy path confirmed functional after simulated engine failure |
| 7 | Sample size | ≥ 50 certificates rendered in parallel with PASS status |

**Dependencies:** Phase 4 (engine wired for notifications), Phase 1 (seeded template content)

**Risk:** Low. Engine output is internal only. No user-facing behavior changes. Validation is additive logging.

---

### Phase 6 — Replace CertificateService

**Goal:** Migrate certificate generation from legacy `documents.templates` to the versioned engine.

**Scope:**
- Rewrite `CertificateService.generate()` to call `TemplateIntegrationService.renderModuleDocument('application.approval', variables, userId)` instead of reading from `documents.templates`
- Remove direct Handlebars compilation
- Keep Puppeteer PDF rendering (engine produces HTML; PDF conversion stays)
- Keep file storage path (`uploads/certificates/`)
- Keep document record creation and linking

**Before:**
```
CertificateService
  → documents.templates (SELECT template_content)
  → Handlebars.compile()(ctx)
  → Puppeteer PDF
  → documents.documents
```

**After:**
```
CertificateService
  → TemplateIntegrationService.renderModuleDocument('application.approval')
  → TemplateEngineService.render()
  → Puppeteer PDF (same)
  → documents.documents (same)
```

**Module keys activated:** `application.approval` (replaces legacy path)

**Dependencies:** Phase 5 (parallel validation PASS), Phase 1 (seeded template content), Phase 2 (engine wired)

**Risk:** High. This is the only active document generation path. Any failure breaks certificate issuance. However, Phase 5 parallel validation has already confirmed equivalence. Requires:
- Seed data must include a complete `certificate-approval` template with all Handlebars variables
- Puppeteer integration must be tested with engine output (engine may produce different HTML structure)
- QR code generation must be preserved (currently inline in CertificateService context building)
- Rollback: revert to legacy `documents.templates` read if engine fails

---

### Phase 7 — Retire Legacy Templates

**Goal:** Remove the legacy `documents.templates` table and associated code.

**Scope:**
- Remove `CertificateRepository.getTemplateContent()` method
- Remove `documents.templates` seed data (seeds 20, 45, 96)
- Archive `documents.templates` table (do not drop — historical data preservation)
- Remove any dead code that references `documents.templates`
- Update `CertificateService` unit tests to mock `TemplateIntegrationService` instead of `documents.templates`

**Dependencies:** Phase 6 (CertificateService fully migrated)

**Risk:** Low. Legacy path is already disabled. This is cleanup only.

---

## 4 — Remaining Integration Work

### Services Already Implemented (Complete)

| Service | File | Status |
|---------|------|:------:|
| TemplateEngineService | `template-engine.service.ts` | Complete |
| TemplateIntegrationService | `template-integration.service.ts` | Complete |
| TemplateResolverService | `template-resolver.service.ts` | Complete |
| ResolverRegistry | `template-resolver-registry.ts` | Complete |
| SnapshotService | `template-snapshot.service.ts` | Complete |
| VersionLifecycleService | `template-version-lifecycle.service.ts` | Complete |
| LifecycleValidationService | `template-lifecycle-validation.service.ts` | Complete |
| RollbackService | `template-rollback.service.ts` | Complete |
| ApprovalWorkflowService | `template-approval-workflow.service.ts` | Complete |
| TemplateValidationService | `template-validation.service.ts` | Complete |
| TimelineService | `template-timeline.service.ts` | Complete |
| TemplateRendererService | `template-renderer.service.ts` | Complete |
| ApplicationDocumentService | `document-generation.service.ts` | Complete |
| CommitteeDocumentService | `document-generation.service.ts` | Complete |
| AccreditationDocumentService | `document-generation.service.ts` | Complete |
| ConsentDocumentService | `document-generation.service.ts` | Complete |
| SafetyDocumentService | `document-generation.service.ts` | Complete |
| NotificationDocumentService | `document-generation.service.ts` | Complete |
| ReportDocumentService | `document-generation.service.ts` | Complete |
| TemplateApprovalWorkflowRepository | `template-approval-workflow.repository.ts` | Complete |

**Total: 20 services/repositories implemented. 0 routes. 0 seed data. 0 module registration.**

### Missing Integrations

| Integration | Phase | Effort | Description |
|------------|:-----:|:------:|-------------|
| Module registration | 2 | 0.5 day | Import + instantiate services in `backend/src/index.ts` or module entry points |
| IEngineVersionRepository implementation | 1 | 1 day | Concrete implementation that reads from `templates.template_versions` — may already exist in repositories, needs verification |
| Entity resolvers | 2–3 | 2 days | IResolver implementations for Application, Meeting, Committee, Institution entity types |
| Puppeteer integration test | 5–6 | 0.5 day | Verify engine HTML output renders correctly to PDF; validate during parallel phase |

### Missing Routes

| Route | Phase | Description |
|-------|:-----:|-------------|
| Template admin CRUD | Post-RC1 | HTTP endpoints for managing templates, versions, approval workflows |
| Template preview | Post-RC1 | HTTP endpoint for previewing rendered output before activation |
| Template render trigger | 2–6 | Not a separate route — generation is triggered by workflow events within existing routes |

### Missing Seed Data

| Seed | Phase | Description |
|------|:-----:|-------------|
| `templates.templates` rows | 1 | 12 template records (one per unique templateCode) |
| `templates.template_versions` rows | 1 | 12 initial APPROVED versions with JSONB content |
| `templates.template_variables` rows | 1 | Variable definitions for each template's placeholders |
| `templates.template_localizations` rows | 1 | Arabic + English locale overrides |
| `templates.template_approval_workflow` rows | 1 | Initial approval workflow steps (if approval_required = true) |

### Migration Risks

| Risk | Probability | Impact | Mitigation |
|------|:----------:|:------:|------------|
| Engine HTML output differs from legacy HTML | Medium | High | Phase 5 parallel validation with side-by-side comparison; promotion criteria require 100% match |
| Variable resolution fails for complex entities | Low | Medium | Unit test all resolvers against seeded entity data |
| Puppeteer PDF rendering breaks with new HTML | Medium | High | Phase 5 parallel validation compares PDF checksums; promotion requires byte-level equivalence |
| Seed data incomplete (missing variables) | Low | High | Audit all Handlebars placeholders in existing templates; map to variable definitions |
| SnapshotService memory pressure | Low | Low | In-memory only; add DB persistence in post-RC1 enhancement |
| Template version status not APPROVED | Low | High | Ensure all seeded versions are status = APPROVED; engine rejects non-APPROVED versions |

### Rollback Strategy

| Phase | Rollback Method | Downtime |
|:-----:|-----------------|:--------:|
| 1 | Delete seed data from `templates.*` tables | None |
| 2 | Remove `ApplicationDocumentService` import from module | None |
| 3 | Remove `CommitteeDocumentService` import from module | None |
| 4 | Remove `NotificationDocumentService` import from module | None |
| 5 | Disable engine comparison logging; no user impact (output is internal) | None |
| 6 | Revert `CertificateService.generate()` to read from `documents.templates` | < 5 min |
| 7 | Restore `documents.templates` seed data | < 5 min |

**Key invariant:** The legacy `documents.templates` table and `CertificateService` legacy path remain untouched until Phase 6. At any point during Phases 2–5, the system can revert to legacy behavior by removing the new imports. Phase 5 parallel validation is purely additive logging — disabling it has zero user impact.

---

## 5 — Success Criteria

### No Template Engine Work Blocks RC1

- [ ] RC1 delivery roadmap unchanged
- [ ] No template engine routes activated before RC1
- [ ] No template seed data applied before RC1
- [ ] CertificateService continues using legacy `documents.templates` path through RC1
- [ ] All 20 services remain in codebase but unwired (dead code, no runtime impact)

### All Remaining Work Is Integration Only

- [ ] 20 services/repositories already implemented and tested (900+ tests)
- [ ] 16-table schema with RLS, audit triggers, and indexes already defined
- [ ] MODULE_DOCUMENTS mapping (23 document types) already defined
- [ ] TemplateIntegrationService facade already implemented
- [ ] Only missing: seed data, module imports, entity resolvers, Puppeteer integration test

### Legacy Generation Remains Supported Until Migration Completes

- [ ] `documents.templates` table retains seeded data through Phase 5
- [ ] `CertificateService` legacy path untouched through Phase 5
- [ ] `TemplateRendererService` → `communication.notification_templates` path untouched through Phase 5
- [ ] Parallel execution possible: engine output and legacy output can coexist

### A Future Migration Path Exists with Minimal Risk

- [ ] 7-phase strategy documented with clear dependencies
- [ ] Rollback defined for every phase
- [ ] Risk matrix with mitigations
- [ ] No breaking changes to existing API contracts
- [ ] Engine output is HTML-compatible with existing Puppeteer PDF pipeline
- [ ] Phase 5 parallel validation provides empirical evidence of equivalence before replacement

---

*This document is the official post-RC1 activation plan for the versioned template engine. Update after each migration phase completes.*
