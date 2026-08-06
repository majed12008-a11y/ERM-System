# Architecture Root Cause Analysis

| Field | Value |
|---|---|
| Status | COMPLETE |
| Author | Independent Principal Architect (root-cause analysis) |
| Provenance | Root-cause analysis of `architecture-challenge-review.md` (S10 verdict NO), `architecture-boundary-analysis.csv` (10 REJECTED verdicts), `architecture-risk-register.csv`, `architecture-assumption-register.csv`, and the underlying evidence chain (`seed-reconstruction-execution-architecture.md`, `architecture-normalization-review.md`, `seed-architecture-review.md`, `rc4-seed-final-assessment.md`, `seed-quality-report.md`, `seed-dependency-graph.md`, `change-impact-analysis.md`, `canonical-seed-specification.md`, `database-population-audit.md`, `backend-table-usage.md`, `feature-data-coverage.md`, `installation-readiness.md`, `feature-traceability-review.md`, `RC4-ARCHITECTURE.md`, AGENTS.md) |
| Constraints honored | READ-ONLY. No redesign, no implementation, no code/SQL/manifests/migrations/diagrams, no commits. Documentation only. |
| Scope | Explain WHY the architecture failed: boundary failure analysis, dependency failure analysis, root cause tree, debt classification, blast radius, minimal blocking set, final verdict. No fixes proposed. |
| Date | 2026-08-06 |

**Boundary scope note.** `architecture-boundary-analysis.csv` carries 10 REJECTED verdicts across 12 subsystems (7 fully rejected: core.applications, security.users, documents.documents, monitoring.*, templates.*, core.applications_conditions, infrastructure; 3 rejected-in-part: workflow.* as seed-ordering authority, certificates.* for linkage enforcement, communication.* for seed ordering). This analysis covers every subsystem that carries a REJECTED verdict.

---

## SECTION 1 — Boundary Failure Analysis

### B1 — core.applications

| Question | Answer |
|---|---|
| Why rejected | FK fan-out 26× makes it the second most-referenced table in the system, yet it is claimed as a "core domain L3" leaf. It is read/written by committee, documents, workflow, and forms. The RULE 12 ownership chain spans four modules, so no single module can legitimately own it. The boundary claim "core owns applications" has no enforcement and no single responsible party. |
| Principle violated | Single Responsibility / Ownership (each subsystem should own the data and invariants of its domain). |
| Document that introduced the problem | `seed-reconstruction-execution-architecture.md` (L2–L5 core layers) and `canonical-seed-specification.md` (core domain canonical data), which assigned applications a layer as if it were a contained domain object. |
| Conceptual or structural | **Structural at the schema level** (real FK fan-out and multi-module writers), **conceptual at the model level** (no aggregate concept exists to re-own the fan-out). |
| Propagates? | **Yes — propagates.** It is the anchor of the evidence DELETE chain (RULE 12) and pulls documents, conditions, workflow, committee, and certificates into its blast radius. |

### B2 — security.users

| Question | Answer |
|---|---|
| Why rejected | FK fan-out 66× — the highest in the system — yet claimed as a "security domain" leaf. Every module writes audit columns (`created_by`/`submitted_by`/`updated_by`), and registration is performed through a `SECURITY DEFINER` bypass. The identity table is a system-wide shared kernel, not a module-owned entity. |
| Principle violated | Separation of cross-cutting concerns / Shared Kernel. Identity is a platform concept, not a module's private data; no shared-kernel concept exists to formalize that. |
| Document that introduced the problem | `database-population-audit.md` and `architecture-normalization-review.md` recorded the schema as-is; the layer model in `seed-reconstruction-execution-architecture.md` placed it under a security layer without recognizing it as a shared kernel. |
| Conceptual or structural | **Structural** (FK fan-out is schema-level) — the underlying flaw is that identity was never elevated to a shared-kernel concept. |
| Propagates? | **Yes — propagates.** It touches every module through audit columns and RLS context (`app.user_id`), so any ownership decision about users ripples system-wide. |

### B3 — documents.documents

| Question | Answer |
|---|---|
| Why rejected | Ownership is split three ways. `documents.lifecycle_state_id` NOT NULL without a default couples the documents table to the workflow module; AGENTS.md places the lifecycle gate under core; and RULE 12 derives evidence-authorization authority from the parent workflow entity, not from document ownership. The table cannot be owned by documents alone. |
| Principle violated | Cohesion / Single ownership — a boundary should correspond to exactly one responsibility owner. |
| Document that introduced the problem | `58-gate0-document-lifecycle.sql` (structural coupling), AGENTS.md RULE 12 (authority split), `change-impact-analysis.md` (S4 divergence). |
| Conceptual or structural | **Both.** Structural FK coupling to workflow; conceptual authority model derived from the parent entity. |
| Propagates? | **Yes — propagates.** Couples documents ↔ workflow ↔ core ↔ committee ↔ forms; the evidence DELETE matrix (7 scenarios) depends on all four factors simultaneously. |

### B4 — workflow.* (as seed-ordering authority)

| Question | Answer |
|---|---|
| Why rejected | The business DAG lives here (accreditation definitions, workflow instances) but the seed execution DAG is ordered numerically. Workflow definitions are business prerequisites; a numeric order only coincidentally matches business order for the Yemen lineage. The boundary "workflow owns its domain" is accepted for schema; the boundary "workflow data is positioned correctly in execution order" is rejected. |
| Principle violated | Dependency direction — the execution graph must respect the business graph. |
| Document that introduced the problem | `seed-dependency-graph.md` (113 edges, 24/79 dependency-bearing seeds, near-linear numeric chain) and `seed-reconstruction-execution-architecture.md` (DAG defined as an ordering problem, not a business-semantics problem). |
| Conceptual or structural | **Conceptual** — a semantic ordering defect, not a schema defect. |
| Propagates? | **Yes — propagates.** Every workflow-governed domain (accreditation, applications, conditions, certificates) inherits the wrong order in partial or rebuilt runs. |

### B5 — monitoring.*

| Question | Answer |
|---|---|
| Why rejected | No repository and no route touch `monitoring.*`. Only seeds write it. The boundary "monitoring is an app subsystem" has no owning consumer — the app's operational monitoring is served by `audit.audit_logs`, `security.users`, and `system.system_config` routes instead. The boundary is undefined, not merely weak. |
| Principle violated | Responsibility / "Unowned data" — a subsystem with no owner and no consumer is not a boundary, it is dead weight. |
| Document that introduced the problem | `feature-data-coverage.md` (monitoring EMPTY silent no-op) and `change-impact-analysis.md` (MonitoringService reads audit/system tables, not monitoring.*). |
| Conceptual or structural | **Conceptual** (absence of a monitoring-as-consumed-subsystem concept); the structural evidence (no repo, no route) is the symptom. |
| Propagates? | **No downstream propagation** (zero consumers) — but **yes, upstream**, because the tables inflate population, coverage, and verification metrics. |

### B6 — templates.*

| Question | Answer |
|---|---|
| Why rejected | Zero consumers in the 315-route traceability, yet retained in the canonical dataset and counted in the 28-feature completeness matrix. A boundary created for behavior that does not exist. |
| Principle violated | YAGNI / Dead-feature integrity — a boundary should correspond to exercised behavior. |
| Document that introduced the problem | `canonical-seed-specification.md` (retained in canonical data) and `feature-traceability-review.md` (counted as a feature). |
| Conceptual or structural | **Conceptual** — a feature defined without its behavior. |
| Propagates? | **No downstream propagation** (no consumers) — **yes, upstream**, distorting coverage and completeness verdicts. |

### B7 — core.applications_conditions

| Question | Answer |
|---|---|
| Why rejected | The RULE 12 authorization matrix requires application ownership + condition ownership + workflow state + user role simultaneously, yet conditions exist as a bare table with no aggregate anchor that binds them to their application, workflow state, and evidence. The aggregate is implicit and unenforced. |
| Principle violated | Aggregate boundary (domain integrity requires an aggregate root that enforces invariants). |
| Document that introduced the problem | AGENTS.md RULE 12, `change-impact-analysis.md` (evidence DELETE matrix), `canonical-seed-specification.md` (conditions canonical rows). |
| Conceptual or structural | **Conceptual** — a missing aggregate concept; structurally the table is ordinary. |
| Propagates? | **Yes — propagates.** Conditions are the middle link between applications, evidence documents, workflow states, and certificates; every RULE 12 scenario depends on the missing aggregate. |

### B8 — certificates.* (linkage enforcement)

| Question | Answer |
|---|---|
| Why rejected | The schema is accepted, but the boundary "certificates belong to their application" is not enforced: `certificates.sdk.ts` hardcodes `applicationId=0`, so the domain model does not enforce the certificate→application linkage at the SDK/domain boundary. |
| Principle violated | Invariant enforcement at the correct boundary. |
| Document that introduced the problem | `certificates.sdk.ts` (frontend SDK) and the SDK route mapping (`sdk_route_map.csv`). |
| Conceptual or structural | **Conceptual** — an unenforced linkage invariant. |
| Propagates? | **Yes, limited** — depends on the missing application aggregate (B7); downstream consumers (reporting, UAT) inherit the false linkage. |

### B9 — communication.* (seed ordering)

| Question | Answer |
|---|---|
| Why rejected | Communication is a fan-out consumer of every domain, but a linear seed chain gives it no defined position (it must be last or derived). The schema boundary is accepted; the placement boundary is rejected. |
| Principle violated | Dependency direction — consumers must be downstream of everything they consume. |
| Document that introduced the problem | `change-impact-analysis.md` (12 empty-table routes), `seed-dependency-graph.md` (no positional rule for fan-out consumers). |
| Conceptual or structural | **Conceptual** — an ordering/derivation defect. |
| Propagates? | **No downstream propagation** — **yes, upstream**, through metric distortion and through the false "13th module covered" implication. |

### B10 — infrastructure (00-truncate / 00-seed-tracker)

| Question | Answer |
|---|---|
| Why rejected | `00-truncate.sql` wipes Era-1 data, yet `ops.seed_tracker` still records Era-1 seeds as `success`. Tracker rows were bulk-restored with identical `applied_at` (2026-08-04) and `duration_ms=0`, so the tracker's provenance is an artifact of dump restoration, not of execution. The "infra is isolated and truthful" boundary is broken by its own ledger. |
| Principle violated | Data provenance / audit truth and idempotency. |
| Document that introduced the problem | `rc4-seed-final-assessment.md` (Era model), `seed-architecture-review.md` (4 epochs), AGENTS.md (seed re-run limitation, tracker checksum design in `00-seed-tracker.sql`). |
| Conceptual or structural | **Both.** Structural tracker design (restore leaves no execution trace); conceptual trust model (status treated as truth). |
| Propagates? | **Yes — propagates to everything.** Every replay, skip, and verification decision consumes tracker state; when tracker truth fails, all downstream decisions are unsound. |

---

## SECTION 2 — Dependency Failure Analysis

### 2.1 Hidden ownership

| Dependency | Evidence | Failure |
|---|---|---|
| `core.applications` owned by "core layer L3" | FK fan-out 26×; written by committee, documents, workflow, forms | The real owner is a cross-cutting anchor; the layer label hides that. |
| `security.users` owned by "security domain" | FK fan-out 66×; every module writes audit columns | Identity is a shared kernel wearing a module's name. |
| `documents.documents` owned by documents module | `lifecycle_state_id` NOT NULL; RULE 12 | Authority is derived from the parent workflow entity — ownership is split, not held. |
| `core.applications_conditions` owned by condition sub-domain | RULE 12 four-factor matrix | The condition has no aggregate root; ownership dissolves into policies. |

### 2.2 Hidden coupling

| Coupling | Evidence | Failure |
|---|---|---|
| documents ↔ workflow | `documents.lifecycle_state_id` NOT NULL without default (`58-gate0-document-lifecycle.sql`) | A NOT NULL constraint without a default silently couples two modules at the schema level. |
| applications ↔ documents ↔ conditions ↔ workflow ↔ committee | RULE 12 evidence DELETE matrix (7 scenarios, 4 factors) | Authorization correctness requires all four factors simultaneously; no boundary holds them. |
| every module ↔ users | audit FK columns across ~transaction tables; RLS context `app.user_id` | The audit trigger `system.fn_log_audit()` assumes `app.user_id` set — coupling through a session global. |

### 2.3 Cyclic dependency

| Cycle | Evidence |
|---|---|
| committee → applications → documents → workflow → committee (accreditation defs) | Committee writes applications; applications reference documents; documents reference workflow; workflow defines accreditation consumed by committee. |
| Seed-level cycles | Cross-seed cascades `07→09→17→18→28→29→51→52→54→63` (AGENTS.md) — the numeric chain contains ordering dependencies that fold back on each other across layer boundaries. |
| workflow ↔ core | Workflow instances govern application states while application rows seed workflow instances; neither direction is declared as primary. |

### 2.4 Shared responsibility

| Responsibility | Evidence | Failure |
|---|---|---|
| DDL + RLS + data in one seed | 13/79 seeds are MIXED-responsibility (`architecture-normalization-review.md` F2) | A single seed changes schema, policy, and data — three responsibility domains with three rollback rules. |
| Tracker shared between runner and dataset | `ops.seed_tracker` is both the runner's log and the dataset's provenance | Provenance is co-mingled with the execution mechanism that created it, so restoring the DB restores the provenance. |
| `monitoring.*` written by seeds, owned by no one | No repo, no route | Data production without an owner is shared responsibility by accident. |

### 2.5 Leaking abstractions

| Leak | Evidence |
|---|---|
| SDK leaks schema internals | `certificates.sdk.ts` hardcodes `applicationId=0` — the client leaks a default that bypasses the linkage invariant. |
| RLS policies implement authorization across modules | RULE 12 matrix exists only as scattered policy WHERE clauses; policies in the documents module reference application and condition semantics from other modules. |
| Reporting matviews reference raw schema | Reporting "EMPTY-ish" matviews are dead against the current dataset — the abstraction references a population that was never delivered. |
| Templates counted as a feature | 28-feature completeness counts a table group with zero consumers — an abstraction with no behavior behind it. |

---

## SECTION 3 — Root Cause Tree

```
ROOT CAUSE A — Table-centric domain model (no aggregate concept)
  The system models domains as FK-connected tables, not business aggregates.
  Invariants (RULE 11, RULE 12) are therefore distributed across policies,
  repository methods, and services with no single authoritative anchor.
  ├─ B1  core.applications            (fan-out anchor labeled as a layer leaf)
  ├─ B7  core.applications_conditions (RULE 12 four-factor aggregate missing)
  ├─ B3  documents.documents          (authority derived from parent entity — no aggregate holds it)
  └─ B8  certificates.*               (application linkage invariant unenforced at SDK boundary)

ROOT CAUSE B — Linear append-only ledger used as an installer
  The 79-file numeric seed suite is a change ledger (schema evolution +
  data provisioning + environment scenario conflated), but it is executed
  as an installer. Numeric order is not business order.
  ├─ B4  workflow.*                   (business DAG nodes ordered numerically)
  ├─ B9  communication.*              (fan-out consumer with no defined position)
  └─ B10 infrastructure tracker       (ledger records itself with restored, untrusted provenance)

ROOT CAUSE C — No ownership governance for cross-cutting concerns and dead features
  Cross-cutting anchors, dead features, and unowned schemas have no
  owning subsystem and no deprecation/retirement rule.
  ├─ B2  security.users               (shared kernel labeled as a module)
  ├─ B5  monitoring.*                 (no owner, no consumer, written by seeds)
  └─ B6  templates.*                  (feature with zero consumers, counted as covered)
```

Coverage check: B1, B7, B3, B8 → Root Cause A (4); B4, B9, B10 → Root Cause B (3); B2, B5, B6 → Root Cause C (3). All 10 REJECTED verdicts assigned exactly once.

---

## SECTION 4 — Architectural Debt Classification

| Boundary | Classification | Why |
|---|---|---|
| B1 core.applications | **Wrong ownership** | A cross-cutting anchor is labeled as a core-layer leaf; the layer claim hides the true owner set. |
| B2 security.users | **Wrong ownership** | Identity is a system-wide shared kernel presented as a module's private data. |
| B3 documents.documents | **Wrong ownership** | Authority is split across workflow/core/documents with no single responsible subsystem. |
| B4 workflow.* (ordering) | **Wrong dependency** | Execution ordering does not respect the business prerequisite graph. |
| B5 monitoring.* | **Wrong responsibility** | Data produced with no owner and no consumer — responsibility assigned to no one. |
| B6 templates.* | **Missing concept** | A boundary defined for behavior that does not exist; the "feature" concept is empty. |
| B7 core.applications_conditions | **Wrong aggregate** | The RULE 12 four-factor aggregate is implicit; no aggregate root exists to enforce invariants. |
| B8 certificates.* (linkage) | **Missing concept** | The certificate→application linkage invariant has no enforcement concept at the boundary. |
| B9 communication.* (ordering) | **Wrong dependency** | Fan-out consumer has no defined downstream position in the execution order. |
| B10 infrastructure tracker | **Missing governance** | No provenance rule protects tracker truth from being restored, not executed. |

---

## SECTION 5 — Blast Radius

| Boundary | Depends on it | Continue around it? | Fix-later cost |
|---|---|---|---|
| B1 core.applications | documents, conditions, certificates, workflow, committee, forms (26 FKs); all RULE 12 scenarios | **No.** Every workflow-governed domain reads/writes applications. | **Redesign.** Extracting an aggregate root re-factors schema, repos, and policies. |
| B2 security.users | All modules (66 FKs); RLS context; audit trigger | **No.** Every write path touches users through audit columns. | **Redesign.** Elevating identity to a shared kernel is a system-wide change. |
| B3 documents.documents | workflow (lifecycle), committee, forms, evidence chain | **Partially.** Data work can continue; authorization correctness (RULE 12) cannot be asserted. | **Redesign.** Ownership relocation requires aggregate + policy rework. |
| B4 workflow.* (ordering) | Every workflow-governed domain | **Partially.** Population can continue; business-order validity is unprovable. | **Redesign of sequencing + verification**, but schema is stable. |
| B5 monitoring.* | None | **Yes.** Zero consumers; removal is self-contained. | **Low.** Removal, no redesign. |
| B6 templates.* | None (behavior) | **Yes.** Zero consumers; removal is self-contained. | **Low.** Removal, no redesign. |
| B7 core.applications_conditions | evidence, documents, certificates, all RULE 12 scenarios | **No.** The four-factor matrix is unusable without the aggregate. | **Redesign.** Aggregate extraction. |
| B8 certificates.* (linkage) | reporting, UAT | **Partially.** SDK-level patch is local; behavioral correctness remains unproven. | **Moderate.** Depends on B7 aggregate; otherwise local. |
| B9 communication.* (ordering) | None downstream | **Yes.** Can defer entirely. | **Low-to-moderate.** Ordering/derivation rule, no schema change. |
| B10 infrastructure tracker | **Everything** — execution, replay, skip, verification | **No.** Every decision consumes tracker state. | **Redesign.** Registry rebuild; provenance must be reconstructed, not migrated. |

---

## SECTION 6 — Minimal Blocking Set

Sequential unlocking — each step covers the boundaries listed and is the prerequisite that makes the next step's correctness provable.

| Order | Blocker | Boundaries covered | What it unlocks | Reasoning |
|---|---|---|---|---|
| 1 | Registry/execution trust (provenance rebuild) | B10 | Every downstream decision (replay, skip, verify, baseline) becomes trustworthy | Highest dependency fan-in: all other work consumes its output. Smallest fix, largest unlock. |
| 2 | Semantic dependency ordering (business DAG) | B4, B9 | Workflow-governed and fan-out domains can be ordered provably | Directly converts numeric order into business order; prerequisite for trusting any domain's population. |
| 3 | Application aggregate model | B1, B7 | RULE 12 matrix, documents authority, certificates linkage become expressible | Central to 3 of 4 domains still blocked; the single highest-value domain-model change. |
| 4 | Shared-anchor ownership (identity kernel) | B2 | All module ownership claims become honest; audit/RLS coupling formalized | Follows aggregate work because identity semantics depend on a stable domain model. |
| 5 | Dead/unowned data policy | B5, B6 | Metrics, coverage, and verification become truthful | Cheap and self-contained; must precede any re-verification, which requires steps 1–2 first. |
| 6 | Document ownership relocation | B3 | Evidence chain fully owned and RULE 12 assertable | Requires the aggregate (3) and kernel (4) to exist first. |

If only **ONE** architectural issue were fixed: **registry/execution trust (B10)** — it gates every other decision and is the cheapest fix, therefore it unlocks the largest portion of the design (execution, replay, verification, and baseline trust). Each subsequent step unlocks the next layer until all four blockers from the challenge review are covered:

- Challenge blocker "Tracker trust" → covered by step 1.
- Challenge blocker "Business-correctness verification" → covered by steps 2 and 3 (ordering + aggregate make RULE 11/12 assertable).
- Challenge blocker "Dataset lifecycle" → covered by steps 4, 5, 6 (honest ownership and dead-data policy are prerequisites for promotion/deprecation).
- Challenge blocker "Dead-data policy" → covered by step 5.

---

## SECTION 7 — Final Root Cause Verdict

The architecture received **NO** for a single fundamental reason:

**The seed suite was never a dataset — it was an installer history. The architecture designed a construction pipeline for a change ledger, while the requirement was a governed, domain-aware, evolvable canonical dataset product.**

Concretely, three failure vectors produced the verdict:

1. **The domain was modeled as tables, not aggregates.** With no aggregate concept (Root Cause A), invariants such as RULE 11 terminal-state derivation and RULE 12 evidence DELETE authorization had nowhere to live. They were distributed across SQL policies, repository methods, and services. The boundaries most central to the business — applications, conditions, documents, certificates — all failed for this reason. No amount of seed engineering can make a table-centric model enforce aggregate-level invariants.

2. **The execution model was a numeric ledger, not a dependency semantics.** The 79-file append-only ledger conflated schema evolution, data provisioning, and environment scenario, then was executed in filename order (Root Cause B). Business prerequisites (workflow definitions) were ordered numerically, fan-out consumers had no position, and the tracker recorded the ledger's own state with provenance that was restored, not executed. The execution architecture therefore could not be made deterministic or trustworthy regardless of how well its engine was specified.

3. **Ownership governance did not exist.** Cross-cutting anchors (identity), unowned schemas (monitoring), and dead features (templates) had no owning subsystem and no retirement rule (Root Cause C). The result was an architecture whose boundaries could not be trusted as boundaries at all — some were shared kernels wearing module names, some were empty labels, some had no owner.

The verdict was not a failure of analysis — the 17 documents mapped 234 tables, 45,453 rows, 315 routes, and 113 dependency edges with high fidelity. The verdict is a failure of **architecture posture**: the plan hardened a pipeline for a historical change ledger when the actual deliverable was a governed dataset product with a domain model, a semantic dependency graph, an ownership model, and a provenance that could survive restoration. Fixing the pipeline cannot fix the product; that is why the correct answer, on the evidence, was **NO**.
