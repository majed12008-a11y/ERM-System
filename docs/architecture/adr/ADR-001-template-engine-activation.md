# ADR-001: Template Engine Activation Strategy

| Field | Value |
|-------|-------|
| **Status** | Accepted |
| **Date** | 2026-07-14 |
| **Deciders** | Architecture Review Board |
| **Supersedes** | — |
| **Superseded by** | — |
| **Related** | `docs/architecture/template-engine-activation-plan.md` |

---

## Context

The Ethics ERM System contains three independent template systems, each serving a different purpose and operating at a different level of maturity.

### Why Three Template Systems Exist

**System 1 — Legacy Certificate Pipeline** (`documents.templates`)
Simple key-value store of HTML templates. A single `template_code` maps to a single HTML blob. `CertificateService` reads the template, compiles it with Handlebars, renders PDF via Puppeteer, and stores the file. No versioning, no localization, no variable metadata, no approval workflow. This is the **only active document generation path** in production.

**System 2 — Notification Message Templates** (`communication.notification_templates`)
Per-channel message templates for email and SMS delivery. `TemplateRendererService` looks up templates by `(template_code, channel_type)` and renders subject/body content. Used exclusively by `NotificationService` for multi-channel notification delivery. Independent of both the legacy certificate path and the versioned template engine.

**System 3 — Versioned Template Engine** (`templates.*` schema)
A full template lifecycle engine with 16 database tables, 11 service classes, version management (DRAFT → REVIEW → APPROVED → DEPRECATED → ARCHIVED), multi-step approval workflows, SHA-256 content snapshots, Handlebars rendering with variable resolution, localization support, and 900+ unit tests. This system is **architecturally complete but completely dormant** — no HTTP routes, no module registration, no seed data, no active consumers.

### Why the Legacy CertificateService Remains the Production Path

`CertificateService` is the only wired document generator. It reads from `documents.templates`, renders via Handlebars + Puppeteer, and produces approval certificates — the primary deliverable of the ethics review workflow. The versioned template engine was built as its successor but was never activated.

### Why the Versioned Template Engine Is Dormant

The engine was implemented as a greenfield subsystem. All 11 services, 16 tables, and 900+ tests were completed before any integration work began. The engine was never wired into module routes because:
1. The legacy certificate path already works
2. Integration requires seed data, entity resolvers, and module registration — none of which were completed
3. The engine was prioritized below other modules (Applications, Committees, Documents)

### Why RC1 Should Not Activate the Engine

Activating the versioned template engine before RC1 introduces unnecessary risk to a release candidate. The legacy certificate path is proven and stable. The engine adds value (versioning, localization, approval workflows) but none of these capabilities are required for RC1's core ethics approval workflow. Activating the engine would require:
- Seeding 12 templates into 5 new tables
- Implementing entity resolvers for 4 entity types
- Wiring `DocumentGenerationService` classes into module routes
- Validating PDF output equivalence with Puppeteer

None of this work blocks RC1. All of it can be done post-RC1 with zero risk to the released product.

---

## Decision

We record the following architectural decisions:

1. **RC1 continues using the legacy `CertificateService`** for approval certificate generation. The legacy path reads from `documents.templates`, compiles with Handlebars, and renders PDF via Puppeteer. No changes to this pipeline.

2. **The versioned Template Engine remains inactive through RC1.** The 11 services, 16 tables, and 900+ tests remain in the codebase as dormant code. No routes are exposed. No seed data is applied. No module registration occurs.

3. **Template Engine activation occurs only after RC1.** Activation follows the approved 7-phase migration strategy documented in `docs/architecture/template-engine-activation-plan.md`.

4. **Phase 5 (Parallel Validation) uses Shadow Mode.** Both the legacy certificate path and the versioned engine generate documents simultaneously. Only the legacy output is delivered to end users. The engine output is used for internal comparison and validation. No engine output is exposed to users until promotion criteria are met.

5. **The legacy path is replaced only when promotion criteria are satisfied.** All 7 criteria must pass before `CertificateService` switches to the engine:
   - HTML output equivalence (100% normalized match)
   - PDF output equivalence (SHA-256 checksum match)
   - Variable resolution completeness (no undefined placeholders)
   - Performance (engine ≤ 2× legacy at p95)
   - No rendering regressions (0 visual differences)
   - Rollback procedure validated
   - Sample size (≥ 50 certificates with PASS status)

---

## Consequences

### Positive

- **Zero RC1 risk.** No template engine changes are included in the RC1 scope. The release candidate uses only the proven legacy certificate path.
- **Preserves stable production behavior.** `CertificateService` continues operating exactly as it does today. No behavioral changes, no output differences, no regression risk.
- **Avoids unnecessary architectural churn.** The three-template-system overlap is temporary and documented. Activating the engine post-RC1 allows thorough validation without release pressure.
- **Engine code is preserved and tested.** The 900+ unit tests continue to validate the engine's correctness. The codebase retains the investment without the integration risk.

### Negative

- **Temporary duplicate template systems.** Three template systems coexist through RC1 and the post-RC1 migration period. This is intentional — the legacy path cannot be retired until the engine is validated.
- **Deferred integration work.** Seed data, entity resolvers, module registration, and Puppeteer integration testing are all deferred. This work is estimated at 3–5 days post-RC1.
- **Technical debt accumulation.** The dormant engine services are dead code in the current codebase. This is acceptable for the RC1 timeline but should be resolved in the post-RC1 migration.

---

## Migration Strategy

The full 7-phase migration strategy is documented in:

**`docs/architecture/template-engine-activation-plan.md`**

Phases:

| Phase | Name | Description |
|:-----:|------|-------------|
| 1 | Seed Templates | Populate `templates.*` tables with 12 template records |
| 2 | Wire Applications | Activate `ApplicationDocumentService` in application routes |
| 3 | Wire Committees | Activate `CommitteeDocumentService` in committee routes |
| 4 | Wire Notifications | Activate `NotificationDocumentService` in notification pipeline |
| 5 | Parallel Validation | Shadow mode — both systems generate, only legacy delivers |
| 6 | Replace CertificateService | Switch `CertificateService` to engine output |
| 7 | Retire Legacy | Archive `documents.templates` table, remove dead code |

---

## Promotion Criteria

The legacy implementation may only be replaced when **all** of the following are satisfied:

| # | Criterion | Threshold | Measurement |
|---|-----------|-----------|-------------|
| 1 | HTML output equivalence | 100% normalized match | DOM diff or normalized string comparison |
| 2 | PDF output equivalence | SHA-256 checksum match | Byte-level comparison of rendered PDFs |
| 3 | Variable resolution completeness | No undefined placeholders | Engine output contains zero unresolved `{{variables}}` |
| 4 | Performance | Engine ≤ 2× legacy | p95 render time over ≥ 100 renders |
| 5 | No rendering regressions | 0 visual differences | Certificate layout, fonts, images, QR codes match |
| 6 | Rollback validated | Legacy path functional | Confirmed after simulated engine failure |
| 7 | Sample size | ≥ 50 certificates | All with PASS comparison status |

---

## Parallel Validation (Phase 5 — Shadow Mode)

During Phase 5, both the legacy certificate path and the versioned template engine operate simultaneously:

```
Certificate Request
  │
  ├─ Legacy Path (production)
  │   CertificateService → Handlebars → Puppeteer → PDF → User
  │
  └─ Engine Path (shadow)
      TemplateIntegrationService → Engine → HTML + PDF → Comparison Log
```

**Key constraints:**
- Only legacy output is delivered to end users
- Engine output is internal only — stored temporarily for comparison
- Comparison results are logged to a structured validation table
- No user-facing behavior changes during shadow mode
- Disabling engine comparison logging has zero user impact

---

## Future Review

This ADR must be revisited after:

1. **RC1 release** — confirming the release is stable
2. **RC1 stabilization period** — typically 2–4 weeks post-release
3. **Approval of the migration project** — formal go/no-go for Phase 1 activation

At that point, the migration team will present:
- Phase 1 seed data readiness
- Entity resolver implementation status
- Phase 5 parallel validation results (if Phase 5 has been executed)

---

*This ADR records the accepted architectural decision for Template Engine activation. The detailed implementation plan remains at `docs/architecture/template-engine-activation-plan.md`.*
