# RC1 Execution Contract

> Mandatory entry point for every implementation task until RC1 is released.
> This is an index and execution guide. It does not introduce new governance.
> Effective: 2026-07-14

---

## 1. Purpose

This document is the **mandatory starting point** for every implementation task from the date of adoption until RC1 is released. Every engineer, every sprint, every task must begin here.

This document does not define governance. It references the approved governance baseline and translates it into an execution sequence.

---

## 2. Governance Baseline

The following artifacts are frozen and govern all work. This document references them. It does not duplicate their contents.

| Artifact | Location | Purpose |
|----------|----------|---------|
| Metrics Model v1.0 | `docs/project-health-dashboard.md` (Section 10) | Defines all project metrics, formulas, and classifications |
| Project Health Dashboard | `docs/project-health-dashboard.md` | Single source of truth for project status |
| Definition of Done | `docs/standards/definition-of-done.md` | Acceptance criteria for every task |
| Release Gates | `docs/standards/release-gates.md` | Gates 1–8 infrastructure |
| Gate 8 | `docs/standards/gate-8-production-readiness.md` | Per-module Production Ready certification |
| ADR-001 | `docs/architecture/adr/ADR-001-template-engine-activation.md` | Template Engine deferred post-RC1 |
| RC1 Delivery Roadmap | `docs/roadmaps/rc1-delivery-roadmap.md` | Sprint sequence and RC1 scope |
| Exit Review Process | `docs/standards/exit-review-process.md` | Mandatory review before module certification |

**Do not re-read these artifacts for every task.** Know them. Follow them. Reference them when making decisions.

---

## 3. Engineering Rules

Every implementation task must comply with the following rules. No exceptions without explicit architectural justification documented in an ADR.

### R1 — No Breaking API Changes

All API changes must be backward-compatible. No endpoint removal, no response shape changes, no URL restructuring. Contract version bump required for any breaking change.

### R2 — No Database Redesign

No schema restructuring. No new tables unless absolutely necessary for the feature. No column type changes. No index removals. All schema changes require migration scripts and rollback plans.

### R3 — SDK-First Frontend

All new frontend API interactions must use the generated SDK. Raw `api.*` calls are permitted only in non-certified modules where no SDK equivalent exists, and only with explicit technical debt tracking.

### R4 — Preserve Architecture

Maintain three-layer separation (Routes → Services → Repositories). All repositories extend `AuditableRepository`. RLS is never disabled. Context propagation via `AsyncLocalStorage` is mandatory for all database operations.

### R5 — Vertical Slice Implementation

Every module follows the 10-stage vertical slice: Routes → Services → Repositories → OpenAPI → SDK → Frontend → Tests → Documentation → Gate 8 → Certification.

### R6 — Gate 8 Required

No module may be declared Production Ready without passing Gate 8 verification. Gate 8 requires: TypeScript PASS, tests PASS, OpenAPI complete, SDK complete, frontend migrated, zero regressions.

---

## 4. Execution Order

The remaining work must be executed in this order. No skipping. No reordering without engineering justification.

```
Step 1: Reporting Module
    Backend verified. OpenAPI complete. SDK exists.
    Task: Migrate frontend to SDK. Add dashboard integration.
    Gate 8 target: End of Sprint 6.
         ↓
Step 2: Notifications Module
    Backend verified. OpenAPI complete. SDK exists. Page migrated.
    Task: Add real-time SSE integration. Gate 8 verification.
    Gate 8 target: End of Sprint 6.
         ↓
Step 3: Reviews Module — Gate 8 Certification
    Code complete. Service extraction done. SDK migrated. OpenAPI complete.
    Task: Runtime verification. Gate 8 certification run.
    Gate 8 target: Start of Sprint 6.
         ↓
Step 4: Technical Debt Resolution
    TD-003, TD-005, TD-006, TD-008, TD-009.
    Task: Fix all "Should Fix Before RC1" items.
    Target: Sprint 6.
         ↓
Step 5: Security Review
    Task: Full security audit of all certified modules.
    Target: Sprint 7.
         ↓
Step 6: Performance Validation
    Task: Bundle analysis, query profiling, SSE validation.
    Target: Sprint 7.
         ↓
Step 7: RC1 Validation
    Task: Full E2E test run. Gate 8 final verification. Regression check.
    Target: Sprint 8.
         ↓
Step 8: Release Freeze
    Task: RC1 freeze. Release notes. Handoff.
    Target: Sprint 8.
```

**Current position:** Between Step 1 and Step 3. Reviews Gate 8 should run first (lowest effort), then Reporting and Notifications in parallel.

---

## 5. Out of Scope Until After RC1

The following items are explicitly frozen. Do not implement, propose, or discuss them during RC1 execution unless they resolve a critical production blocker.

| Item | Frozen Until |
|------|:------------:|
| New governance artifacts | Post-RC1 |
| New metrics or metric formula changes | Post-RC1 |
| New release gates | Post-RC1 |
| New architectural patterns | Post-RC1 |
| Template Engine activation (ADR-001) | Post-RC1 |
| Non-essential refactoring | Post-RC1 |
| Frontend unit test expansion | Post-RC1 |
| Playwright E2E test creation | Post-RC1 |
| Security hardening sprints | Post-RC1 |
| Performance optimization beyond validation | Post-RC1 |
| Bundle size reduction efforts | Post-RC1 |
| i18n expansion | Post-RC1 |
| New feature additions beyond RC1 scope | Post-RC1 |

---

## 6. Completion Requirement

Every implementation task must finish with the following steps, in order:

| Step | Action | Required |
|:----:|--------|:--------:|
| 1 | **Validation** — `npm run lint` (backend), `tsc --noEmit` (frontend), `npm test` (both) | Yes |
| 2 | **Exit Review** — Verify all acceptance criteria from Definition of Done | Yes |
| 3 | **Gate 8 Assessment** — If the task completes a module, run Gate 8 verification | Yes (per-module) |
| 4 | **Dashboard Update** — Update Project Health Dashboard only if module status changes | Conditional |

**No task is complete without Step 1.** Steps 2–4 are required at module completion boundaries.

---

## 7. Success Definition

RC1 is complete and ready for release **only when ALL** of the following conditions are met:

| # | Condition | Status |
|:-:|-----------|:------:|
| 1 | Every RC1 module has Production Ready status (Gate 8 PASS) | Pending |
| 2 | Security review is complete with no critical findings | Pending |
| 3 | Production build succeeds (`tsc -b && vite build`) | ✅ |
| 4 | Backend tests pass at ≥ 99% | ✅ (99.7%) |
| 5 | Frontend tests pass | ✅ (2/3, 1 pre-existing) |
| 6 | No critical regressions remain | ✅ (0) |
| 7 | All "Should Fix Before RC1" technical debt items are resolved | Pending |
| 8 | RC1 validation report is complete | Pending |
| 9 | Release Freeze is performed | Pending |

**Current overall status: NOT READY.** Conditions 1, 2, 7, 8, 9 pending.

---

*This document is the mandatory entry point for RC1 execution. It references the approved governance baseline. It does not introduce new governance.*
