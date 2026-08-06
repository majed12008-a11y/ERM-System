# ADR-002 — Canonical Dataset Architecture

| Field | Value |
|---|---|
| Number | ADR-002 |
| Status | ACCEPTED — Constitutional foundation for all future RC4 work |
| Date | 2026-08-06 |
| Author | Enterprise Architecture (ratified from Independent Principal Architect root-cause analysis) |
| Provenance | `architecture-root-cause-analysis.md`, `architecture-challenge-review.md`, and the evidence chain they cite (`seed-reconstruction-execution-architecture.md`, `rc4-seed-final-assessment.md`, `seed-architecture-review.md`, `seed-quality-report.md`, `seed-dependency-graph.md`, `change-impact-analysis.md`, `canonical-seed-specification.md`, `database-population-audit.md`, `backend-table-usage.md`, `feature-data-coverage.md`, `installation-readiness.md`, `feature-traceability-review.md`, `RC4-ARCHITECTURE.md`, AGENTS.md) |
| Constraints honored | READ-ONLY. No code, SQL, manifests, migrations, or commits. No redesign. Documentation only. |
| Scope | Formally redefines the role of the Seed System. Establishes the architectural baseline that all future RC4 work must respect. |
| Supersedes | The framing of the seed suite as a dataset product wherever it appears in prior documents (see Section 7 and Section 8). Does not invalidate the factual findings of any cited document. |

---

## 1. Problem Statement

The Root Cause Analysis concluded:

> **"The seed suite was never a dataset — it was an installer history."**

The previous seed architecture failed for three structural reasons, each already established in `architecture-root-cause-analysis.md` and `architecture-challenge-review.md`:

1. **The domain was modeled as tables, not aggregates.** With no aggregate concept, invariants such as RULE 11 (terminal-state derivation) and RULE 12 (evidence DELETE authorization, 7-scenario matrix) had no authoritative home. They were distributed across SQL policies, repository methods, and services. Boundaries most central to the business — `core.applications` (FK fan-out 26×), `core.applications_conditions`, `documents.documents`, `certificates.*` — all failed for this reason.

2. **The execution model was a numeric ledger, not dependency semantics.** The 79-file suite conflated schema evolution, data provisioning, and environment scenario, then executed in numeric order. Business prerequisites (workflow definitions) were ordered numerically, fan-out consumers (`communication.*`) had no defined position, and the execution tracker (`ops.seed_tracker`) recorded its own state with provenance that was restored from a dump, not produced by execution.

3. **Ownership governance did not exist.** Cross-cutting anchors (`security.users`, FK fan-out 66×), unowned schemas (`monitoring.*`, zero consumers), and dead features (`templates.*`, zero consumers) had no owning subsystem and no retirement rule.

Consequence (from `architecture-challenge-review.md` S10): the architecture was rated NO; it designed a construction pipeline for a change ledger when the requirement was a governed, domain-aware, evolvable dataset product.

This ADR does not introduce new findings. It formalizes the decision that the Root Cause Analysis made unavoidable.

---

## 2. Decision

**The Seed System is hereby reclassified.**

- The 79-file numeric seed suite in `backend/seed/` is an **Installer History** — an append-only change ledger describing how a database came to be.
- The **Canonical Dataset** is the product — a governed, domain-aware, evolvable dataset that the system must present to all subsystems, roles, and features.
- The Canonical Dataset is the source of truth. The Installer History is a historical record that references it — never the reverse.

### Installer History vs Canonical Dataset — why they are fundamentally different architectural concepts

| Dimension | Installer History (the seed suite) | Canonical Dataset (the product) |
|---|---|---|
| Role | Describes how the database was built | Defines what must exist in the system |
| Order | Numeric execution order (`seed_dependency_graph.md`: near-linear chain, 113 edges) | Business dependency order (workflow prereq, aggregate composition) |
| Identity | File identity (filename, SHA-256, numeric prefix) | Business identity (natural keys, aggregate roots) |
| Provenance | Records itself; trustable only if execution is traceable — it is not (`ops.seed_tracker` rows restored with identical `applied_at`, `duration_ms=0`) | Provenance is a first-class property: who/what/when produced each datum |
| Idempotency | Not achieved (16 non-idempotent seeds; `-Force` replay fails on 17 files) | Mandatory: replay must yield the same dataset |
| Lifecycle | Append-only; no promotion, deprecation, branch, merge, or archive | Governed lifecycle: create, promote, version, deprecate, branch, merge, archive |
| Scope | Conflates DDL + RLS + data + environment scenario (13/79 MIXED seeds) | Data only; schema and policy are separate concerns |
| Verification | Integrity only (0 broken FKs, 45,453 rows) — never business behavior | Integrity **and** business behavior (RULE 11 reachability, RULE 12 matrix, committee lifecycle) |
| Change model | Change log (append entries forever) | Change management (version, deprecate, retire) |
| Outcome under current design | Cannot be made reproducible or trustable | Is the deliverable RC4 must produce |

The two are not two names for the same thing. An Installer History answers **"how did we get here?"** A Canonical Dataset answers **"what must be true?"** Every architecture failure documented in the Root Cause Analysis (boundary rejections B1–B10, blockers R1–R6) traces to treating the answer to the first question as if it were the answer to the second.

---

## 3. Architectural Principles

The following permanent principles follow directly from the findings in `architecture-root-cause-analysis.md` and `architecture-challenge-review.md`. No principle is asserted that is not supported by those findings.

| # | Principle | Established by |
|---|---|---|
| P1 | **Dataset-first.** The Canonical Dataset is the source of truth; the seed suite is a historical record. | Root Cause Analysis §7; challenge review A3, A10; `seed-quality-report.md` (suite fails as dataset). |
| P2 | **Domain ownership.** Every data ownership claim maps to exactly one owning subsystem, or is declared an explicit shared kernel. | Root Cause C; boundary rejections B2 (`security.users`), B5 (`monitoring.*`), B6 (`templates.*`). |
| P3 | **Aggregate ownership.** Aggregate-level invariants (RULE 11, RULE 12) must be expressible in a single authoritative model, not scattered across policies and repository methods. | Root Cause A; boundary rejections B1, B7, B3, B8. |
| P4 | **Semantic dependencies.** Execution order must respect the business dependency graph, never filename or numeric order. | Root Cause B; boundary rejections B4, B9; challenge review S4; `seed-dependency-graph.md`. |
| P5 | **Dataset lifecycle.** Canonical data must have promotion, deprecation, branch, merge, and archive stages. | Challenge review S6; risk R4. |
| P6 | **Business identity over execution order.** Idempotency is defined by business identity (natural keys, aggregate roots), not by position in a file sequence. | Challenge review A5; Root Cause B; `seed-dependency-graph.md`. |
| P7 | **Provenance trust.** No decision may rely on recorded execution state that cannot be proven to be a product of execution. | Challenge review A1 (tracker untrusted); blocker R1. |
| P8 | **Behavior verification over integrity verification.** Verification must assert business behavior (workflow reachability, ownership matrices, lifecycles), not only referential integrity. | Challenge review S8; Root Cause A; `seed-quality-report.md` (integrity A but behavior unverified). |
| P9 | **No dead data.** Canonical data may not reference features with zero consumers; dead or unowned data must be explicitly deprecated and retired. | Challenge review S3 (`templates.*`), S6; boundary rejections B5, B6; risk R5. |

---

## 4. Architectural Consequences

Consequences are architectural only; no implementation is described.

### Immediate (consequences that apply from the moment this ADR is accepted)

- **C1. Status change.** The seed suite is demoted from "source of truth" to "historical record." All reasoning must now treat it as evidence of history, not as the canonical product (`architecture-challenge-review.md` S10 recommendation).
- **C2. Restoration is not construction.** The Gate-0 baseline dump (`backend/backups/gate0-baseline-2026-08-04.dump`, 3.43 MB) reproduces a state by restoration; it does not demonstrate reproducible construction. "Gate-0 reproducible" is no longer equated with "RC4-ready" (challenge review A10).
- **C3. Tracker distrust.** `ops.seed_tracker` state is not evidence of execution. Any future execution record must carry provenance that survives restore (challenge review A1; Root Cause B10).
- **C4. The Canonical Dataset is the acceptance object.** Future RC4 acceptance is defined against the Canonical Dataset's properties (P1–P9), not against seed-file replay behavior.

### Future (consequences that shape the next architecture phase, but are not implemented here)

- **C5. Aggregate model required.** RULE 11 and RULE 12 must become expressible in an aggregate model. This changes how applications, conditions, documents, and certificates are architecturally related (Root Cause A; challenge review S3).
- **C6. Dataset lifecycle required.** Promotion, deprecation, branch, merge, and archive become mandatory properties of canonical data. This changes how datasets are versioned and how the multi-institution objective (per `RC4-ARCHITECTURE.md`) can be expressed (challenge review S6; risk R4).
- **C7. Semantic ordering required.** Any construction of canonical data must be ordered by business dependencies, and fan-out consumers (e.g., `communication.*`) must be positioned as derived or final (Root Cause B; challenge review S4).
- **C8. Behavior verification required.** Verification scope expands from integrity to business behavior: workflow reachability, evidence-ownership matrices, and lifecycle assertions (challenge review S8).
- **C9. Dead-data policy required.** Unowned and consumerless data (`monitoring.*`, `templates.*`, Era-1 anchors) requires explicit deprecation/retirement as a precondition to trusting coverage and completeness metrics (challenge review S5/S6; risk R5).

### Long-term (consequences that define the trajectory of the platform)

- **C10. Evolvability.** The architecture becomes a change-management system rather than a change log, enabling feature addition, schema change, and dataset versioning under governance (challenge review S5).
- **C11. Multi-institution capability.** A governed dataset lifecycle makes the RC4 multi-institution objective structurally expressible through dataset branching and merging (challenge review S6; risk R4).
- **C12. Architecture drift risk managed.** The risk that "the Gate-0 dump becomes the only trusted artifact and the seed suite is abandoned" (challenge review R10) is addressed by making the Canonical Dataset a product with defined construction, not by continuing to trust the dump as the product.

---

## 5. Invariants

Architectural invariants that **every future RC4 implementation** must satisfy. These are rules about the architecture, not implementation details.

| # | Invariant |
|---|---|
| I1 | The seed suite is never treated as the dataset product; it is a historical record that may be consulted but not relied upon as the canonical definition. |
| I2 | No decision may be based on recorded execution state as proof of execution unless that state carries provenance that survives database restore. |
| I3 | Reproducibility is by construction, not by restoration; "the environment has the right data" must be demonstrable without reference to a dump. |
| I4 | Every datum belongs to exactly one owning subsystem or to a declared shared kernel; no datum is owned by the execution mechanism that produced it. |
| I5 | Aggregate-level business invariants (RULE 11 terminal-state reachability; RULE 12 evidence DELETE four-factor matrix) are expressible in a single authoritative model and are assertable by verification. |
| I6 | The order in which data is produced respects the business dependency graph; numeric or filename order is never a sufficient ordering justification. |
| I7 | All canonical data participates in a defined lifecycle (create, promote, version, deprecate, branch, merge, archive); no canonical data exists outside a lifecycle. |
| I8 | No canonical datum may reference behavior with zero consumers; consumerless or unowned data is explicitly deprecated and retired, never silently retained in canonical counts. |
| I9 | Verification asserts business behavior in addition to integrity; a dataset that satisfies constraints but violates workflow, ownership, or lifecycle semantics is considered unverified. |
| I10 | Idempotency and reconciliation are defined by business identity (natural keys, aggregate roots), not by execution position or file identity. |
| I11 | Schema, RLS, and data are distinct architectural concerns; no single construct may own more than one (RLS remains the sole access-control mechanism per AGENTS.md — never disabled, never bypassed). |

---

## 6. Out of Scope

This ADR deliberately does **not** define:

- The seed runner or execution engine.
- SQL, seed file format, or migration syntax.
- Manifest or registry schema.
- Migration order or dependency-engine mechanics.
- Rollback or retry mechanisms.
- Verification tooling or assertion syntax.
- Technology selection (libraries, frameworks, migration frameworks).
- Any implementation of the Canonical Dataset.

These are matters for subsequent ADRs and design documents, which must themselves satisfy the principles (P1–P9) and invariants (I1–I11) herein.

---

## 7. Relationship to Existing ADRs

**Formal ADR series status.** At the time of writing, no formal ADR series exists under `docs/architecture/adr/`. **ADR-001 has not been authored.** ADR-002 is therefore the founding record of the formal series.

- ADR-002 does **not** supersede ADR-001, because no ADR-001 exists. ADR-002 reserves the numbering convention for the formal series and establishes the constitutional baseline that future ADRs (including a future ADR-001, if the series is renumbered) must satisfy.
- Pre-existing **informal ADR references** exist in `RC4-ARCHITECTURE.md` (ADR-01..08: PDF generation, email delivery, migration framework, HTML sanitization, test coverage, token storage, caching, job runner) and in `docs/devops/phase5-priority3-observability-audit.md` (ADR-001..007: health probes, metrics library, metrics security, naming, health consolidation, workflow telemetry, notification metrics). These are decision tables in a separate, informal namespace. ADR-002 does not overturn any technology decision recorded there; it establishes the architectural context those decisions must now respect. Future formalization of those informal decisions should be renumbered into the `docs/architecture/adr/` series.

**Governance documents.** ADR-002 extends, rather than contradicts, the governance baseline established by:
- `ENTERPRISE_TRACEABILITY_MODEL.md` (approved specification, SPEC-0011) — ADR-002 adds the dataset-product concept to the traceability model.
- `RC4-ARCHITECTURE.md` (master plan) — ADR-002 is the constitutional document the master plan must respect; the plan's dataset/seed posture must be re-based on ADR-002 (see Section 8).
- AGENTS.md (operating constitution) — ADR-002 amends the framing of the seed suite and the baseline-restore workflow described there (see Section 8).

**Summary.** ADR-002 **extends** the architectural baseline and **supersedes only the framing** of the seed suite as a dataset product wherever prior documents assert it. It does not invalidate any factual finding, any domain contract, or any prior technology decision.

---

## 8. Architecture Baseline Impact

Full classification in `ADR-002-impact-matrix.csv`. Summary:

| Classification | Documents |
|---|---|
| Compatible | All analysis/evidence documents whose factual findings remain valid under the new framing (challenge review, root-cause analysis, normalization review, population audit, table usage, feature coverage, traceability review, dependency graph, quality report, final assessment, seed architecture review, coverage matrices, supporting CSVs; domain contracts in `docs/architecture/`). |
| Needs Revision | Documents whose framing assumed the seed suite as the dataset product or equated restoration with construction: `canonical-seed-specification.md`, `installation-readiness.md`, `RC4-ARCHITECTURE.md`, `dataset-architecture.md`, AGENTS.md. |
| Superseded | `seed-reconstruction-execution-architecture.md` — its architectural stance (a construction pipeline for a change ledger) is superseded by ADR-002. Its factual analysis remains valid evidence but is not to be implemented as designed. |
