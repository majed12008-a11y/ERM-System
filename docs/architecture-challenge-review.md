# Architecture Challenge Review

| Field | Value |
|---|---|
| Status | COMPLETE |
| Author | Independent Principal Architect (challenge review) |
| Provenance | Cross-analysis of `canonical-seed-specification.md`, `change-impact-analysis.md`, `seed-reconstruction-execution-architecture.md`, `feature-traceability-review.md`, `architecture-normalization-review.md`, `seed-architecture-review.md`, `seed-dependency-graph.md`, `seed-quality-report.md`, `backend-table-usage.md`, `feature-data-coverage.md`, `installation-readiness.md`, `rc4-seed-final-assessment.md`, `database-population-audit.md`, `RC4-ARCHITECTURE.md` |
| Constraints honored | READ-ONLY. No code, SQL, manifests, migrations, or commits. Documentation only. |
| Scope | Challenge the six prior stage documents as one authoritative architecture; identify hidden assumptions, boundary flaws, domain-model gaps, dependency-semantics divergence, evolution/governance gaps, dataset-lifecycle gaps, operational gaps, and verification blind spots. End with a YES/NO implementation verdict. |
| Date | 2026-08-06 |

---

## S1 — Hidden Architectural Assumptions

Each row asserts the assumption, where it originates, and the break condition that invalidates it.

| # | Assumption | Origin | Break-if-False |
|---|---|---|---|
| A1 | `ops.seed_tracker` status is trustworthy enough to skip already-applied seeds | `seed-reconstruction-execution-architecture.md`, `installation-readiness.md`, `rc4-seed-final-assessment.md` | Tracker rows are bulk-restored with identical `applied_at` 2026-08-04 and `duration_ms=0` (78 rows) — timestamps are artifacts of the dump restore, not of seed execution. Any replay decision based on tracker state is unsound. |
| A2 | The Gate-0 baseline dump is a complete, correct snapshot of the canonical dataset | `installation-readiness.md` (Path A) | Baseline contains only Era-2 + Era-3 output; Era-1 data was wiped by `00-truncate.sql` while the tracker still lists Era-1 seeds as `success`. The dump is self-consistent but not a traceable derivation of the seed suite. |
| A3 | Seed files are the single source of truth for dataset construction | `rc4-seed-final-assessment.md`, `architecture-normalization-review.md` | 33/79 seeds carry silent-no-op risk; 16 are non-idempotent; two parallel lineages (demo `APP-2024-*` vs Yemen `APP-2025/2026-*`) write the same tables with incompatible anchors. The suite as a whole is not reproducible, so the files cannot be the sole truth. |
| A4 | A full-suite deterministic rebuild from seed SQL is achievable once dependencies are topologically sorted | `seed-reconstruction-execution-architecture.md` (§3 DAG) | Era-1 seeds reference dead anchors (8 seeds reference `APP-2024-*`/demo users that no longer exist). Topological ordering fixes execution order, not anchor validity. Determinism requires dead-data removal, which SREA only defers to a late pipeline stage. |
| A5 | Scope-key idempotency (natural-key upsert) can be made safe under RLS | `seed-reconstruction-execution-architecture.md` (§8 idempotency) | Repositories rely on `app.user_id` RLS context; seed upserts that bypass the session user model can hit `FOR INSERT WITH CHECK` or `FOR ALL USING (true) WITH CHECK` policies unexpectedly. The deny-list of 15 runtime tables is asserted complete, not proven complete. |
| A6 | Verification via row counts and FK anti-joins proves the dataset is business-correct | `seed-reconstruction-execution-architecture.md` (§9), `seed-quality-report.md` (referential integrity A) | Referential integrity is A-grade and 0 broken FKs exist across 45,453 rows — but no assertion ever exercises workflow transitions, committee lifecycle, or notification behavior. Integrity ≠ correctness (see S8). |
| A7 | The 315 leaf routes reading 163 empty-table-hit routes is the correct definition of "feature readiness" | `change-impact-analysis.md` (S5=163), `feature-data-coverage.md` | Coverage is measured against route reads only. Features whose behavior is correctness-sensitive (workflow reachability per RULE 11, evidence DELETE matrix per RULE 12) can be "populated" yet wrong. Route-read coverage is necessary, not sufficient. |
| A8 | `monitoring.*` tables are out of scope because they are seed-only | `feature-data-coverage.md` (monitoring EMPTY silent no-op), `change-impact-analysis.md` | The `monitoring/audit` and `monitoring/config` routes read populated `audit.audit_logs`/`security.users`/`system.system_config` — the app's operational monitoring is served by other schemas. Writing monitoring.* via seeds with no repo and no route means the data is dead weight that inflates seed volume. |
| A9 | Frontend can be judged through SDK route mapping alone | `frontend_pages.csv` (51 pages), `sdk_route_map.csv` (19 files/167 methods) | The SDK hardcodes `applicationId=0` in `certificates.sdk.ts` and `Admin/EmailSettings.tsx` is an orphaned page. Route mapping proves connectivity, not behavior. Page-level flows were never asserted. |
| A10 | "Gate-0 reproducible" equals "RC4-ready" | `installation-readiness.md` (Path A), `rc4-seed-final-assessment.md` | Gate-0 reproducibility was achieved by dump restoration, not by seed re-execution. RC4 production deployment requires reproducible construction, not reproducible restoration. The two are conflated in the current acceptance framing. |

---

## S2 — Boundary Analysis

Verification that the boundaries drawn by `seed-reconstruction-execution-architecture.md` (L0–L16 pipeline layers) and the module boundaries in `feature-traceability-review.md` are clean, plus tables that straddle or leak across them.

### 2.1 Layer boundaries (pipeline layers L0–L16)

| Boundary claim | Evidence | Verdict |
|---|---|---|
| Infra (L0) is isolated from reference (L1) | `00-truncate.sql` wipes Era-1 data at infra stage | Clean — but conflicts with A1: tracker still records Era-1 as `success`. |
| Reference data (L0/L1) has no dependency on scenario data | Only 24/79 seeds have data dependencies; reference seeds are dependency-light | Clean in theory; violated in practice by 6 cross-layer chains (07→09→17→18→28→29→51→52→54→63 documented in AGENTS.md). |
| Core domain layers (L2–L5) are self-contained per module | FK fan-out from `ethics_db_schema.sql`: `security.users` referenced 66×, `core.applications` 26× | Boundary is permeable — users and applications are cross-cutting anchors, so "core" is a set of shared anchors, not a layer. |
| Reporting (L16) reads only from populated domains | `reporting.*` materialized views are dead (reporting EMPTY-ish) | Boundary holds vacuously because reporting is not populated. |

### 2.2 Overlapping and cyclic-boundary tables

| Table/schema | Primary claimer | Secondary writers | Risk |
|---|---|---|---|
| `core.applications` (FK fan-out 26×) | core domain L3 | committee, documents, workflow, forms | Anchor of 4+ modules; any boundary decision on it cascades. |
| `security.users` (FK fan-out 66×) | security domain | every domain via `created_by`/`submitted_by`/`updated_by` audit columns | Highest-fan-out anchor in the system; cannot belong to any single layer. |
| `documents.documents` (FK fan-out 7×) | documents domain L5 | workflow (lifecycle_state_id), committee, forms | `documents.lifecycle_state_id` couples the documents module to the workflow module, yet AGENTS.md places the gate under core; boundary mismatch documented in `58-gate0-document-lifecycle.sql`. |
| `workflow.workflows` + `workflow_instances` (6× each) | workflow module L6 | committee (accreditation defs), applications | Business DAG for committee workflows lives here; seed DAG ordering must respect it but currently does not (S4). |
| `committee.committee_meetings` (5×) | committee module | documents (minutes), applications | Committee is the second-largest populated module (607 rows) and a cross-domain reader. |
| `monitoring.*` | none (no repo, no route) | seeds only | Boundary is undefined; table group has no owning consumer. |

### 2.3 Verdict

- Boundaries are **defined by ownership column and module convention, not enforced**. No mechanism prevents a later seed from writing to a foreign module's tables, and the audit FK fan-out proves every module implicitly owns a slice of `security.users`.
- The pipeline-layer boundaries in SREA are execution order, not architectural isolation. That conflation is acceptable for a dataset pipeline but must not be sold as domain modularity.

---

## S3 — Domain Model Review

### 3.1 Table-based vs aggregate-based model

| Domain | Table (canonical) | Implied aggregate | Gaps |
|---|---|---|---|
| Application | `core.applications` (+ applications_conditions, documents, statuses) | Application aggregate | No aggregate boundary is defined. Evidence DELETE authorization (RULE 12) must span application + condition + document + workflow status simultaneously, but nothing in the schema names this aggregate — it exists only in policy logic and a repository method (`application.getApplicationStatus()`). |
| Committee | `committee.committees` (+ members, meetings, resolutions) | Committee aggregate | 607 rows populated; membership, meetings, and resolutions are three tables with three ownership roots; the aggregate is implicit. |
| Workflow | `workflow.workflows`/`workflow_instances` + transitions | Workflow definition + instance | Terminal-state derivation (RULE 11) is *derived*, not stored. Any dataset change must re-run reachability analysis; the seed pipeline has no such check. |
| Accreditation | committee workflow defs + conditions + certificates | End-to-end accreditation process | Spans committee, core, documents, forms, reporting. No single model captures the process; it exists as route choreography. |
| Certificate | `certificates.*` (57 in canonical) | Certificate issuance | `certificates.sdk.ts` hardcodes `applicationId=0`; the domain model does not enforce the application linkage at SDK level. |

### 3.2 Consequences

| Finding | Impact |
|---|---|
| No formal aggregate boundaries | Cross-module authorization (RULE 12 matrix, 7 scenarios) has no schema-level anchor; it lives in scattered policy WHERE clauses. |
| Terminal state is derived, not stored | Dataset population cannot assert "this application is terminal" without running reachability; verification engine has no reachability step. |
| `templates.*` has zero consumers | Dead domain object retained in canonical data; inflates population matrix (28-feature completeness counts features that no behavior consumes). |
| 292 repo→table pairs with `MeetingRepository` (18), `ReviewRepository` (17), `AuthRepository` (17) | Repository fan-out shows the data access layer is table-per-repository, not aggregate-per-repository. Aggregate boundaries would reduce repo count and centralize invariants. |

### 3.3 Verdict

- The domain model is **entity/table-centric with implicit, unenforced aggregates**. For dataset construction this is tolerable; for RC4 production behavior it is the root of most future correctness risk because invariants (RULE 11, RULE 12, evidence DELETE matrix) are distributed across SQL policies, repository methods, and services with no single authoritative model.

---

## S4 — Business Dependency Graph vs Seed Execution DAG

### 4.1 The two graphs

| Aspect | Business DAG (RC4 business semantics) | Seed execution DAG (SREA §3) |
|---|---|---|
| Nodes | Business entities/processes (accreditation, application lifecycle, committee workflow) | Seed files (79) |
| Edges | Business prerequisites (a certificate requires a resolution; a resolution requires a meeting) | Data dependencies (113 edges; `96-realistic-data.sql` 30 deps, `95-pilot-dataset.sql` 20, `21-committee-expansion.sql` 9) |
| Ordering force | Workflow reachability + RULE 12 ownership chain | Numeric prefix + manifest `depends_on` |
| Alignment today | 0 automated checks | Numeric order, which only coincidentally matches business order for Yemen lineage |

### 4.2 Known divergences

| Divergence | Evidence | Consequence |
|---|---|---|
| Workflow definitions precede the data they govern, but seed order is numeric not semantic | Committee workflows (accreditation defs) inserted in later seeds than the applications they validate | Application rows can be populated against workflow definitions that do not yet exist in a partial run; only FK constraints (0 broken) hide the semantic gap. |
| Two parallel lineages disagree on the same business entities | Demo `APP-2024-*` vs Yemen `APP-2025/2026-*` write same tables | Business DAG has two valid-but-incompatible histories; a fresh topological run cannot pick a winner without an explicit policy. |
| `documents.lifecycle_state_id` couples documents to workflow | `58-gate0-document-lifecycle.sql`, FK fan-out | Business ownership (workflow) and dataset placement (core) disagree; a gate-0 lifecycle state is required but the seeds that create applications precede those that set lifecycle states in some chains. |
| Notifications/communication cross every domain | communication module 12 empty-table routes | Communication is a fan-out consumer; it has no place in a linear seed chain and must be last or derived — SREA does not state this. |

### 4.3 Verdict

- The SREA DAG **partially addresses execution order but does not address business-order validity**. A topological order that satisfies FK constraints can still produce business-invalid states (e.g., certificates issued before resolutions, conditions resolved before submission). The verification engine must check Business-DAG reachability, not only FK anti-joins.

---

## S5 — Evolution Readiness

### 5.1 Governance processes required by RC4 but undefined today

| Evolution scenario | Required control | Status today |
|---|---|---|
| Add a new feature | New tables + RLS policies + feature completeness entry + seed layer | Only schema evolution exists (append-only seeds). No feature-level entry control. |
| Add a seed | Registry entry + dependency edge + checksum | `ops.seed_tracker` + SHA-256 exists but tracker trust is broken (A1). |
| Change schema | Migration path + backfill + policy refresh | Numeric append-only ledger exists; no migration/backfill governance. |
| Retire a feature | Dead-data removal + route pruning + feature traceability update | Undefined. `templates.*` (0 consumers) and `monitoring.*` (no consumers) already wait. |
| Ship dataset v2 | Fork/branch, promote, deprecate, merge | Undefined (see S6). |

### 5.2 Evidence of present-day evolution debt

- 16 non-idempotent seeds, 17-file `-Force` replay failure (AGENTS.md, `seed-quality-report.md`).
- 8 seeds referencing dead `APP-2024-*`/demo anchors — retained, not removed, because removal breaks the ledger chain.
- 9 numeric-prefix collision groups (`architecture-normalization-review.md` F3).
- 5 failing dependency chains documented in AGENTS.md (`07→09→17→18→28→29→51→52→54→63`).

### 5.3 Verdict

- **Not evolution-ready.** The append-only ledger design is a change *log*, not a change *management* system. Every future change to canonical data must be dual-implemented (data change + registry/checksum change + dependency update), and there is no defined process or ownership for doing so. This is the single largest long-term maintainability risk in the architecture.

---

## S6 — Canonical Dataset Lifecycle

### 6.1 Lifecycle stages missing

The SREA pipeline defines *construction* stages (L0–L16) and gates (G0–G3) but not a *lifecycle*:

| Lifecycle stage | Defined? | Gap |
|---|---|---|
| Create/build | Yes (L0–L16) | — |
| Promote (dev → staging → prod) | No | No promotion path exists; Gate-0 dump is copied, not promoted. |
| Version/release | Partial (SHA-256 manifest) | No semantic versioning, no changelog per canonical dataset. |
| Deprecate | No | Era-1 anchors still referenced but functionally dead; no deprecation marker. |
| Branch/merge (customer/country variants) | No | Yemen lineage is de-facto a branch that won; no merge policy exists. |
| Archive | No | No rule for removing dead seeds/tables while keeping traceability. |
| Baseline freeze | Partial (Gate-0 dump) | Freeze is by dump, not by reproducible seed state (A10). |

### 6.2 Consequences

| Gap | Consequence |
|---|---|
| No promotion path | Every environment re-builds from raw SQL; the dump becomes the only trusted artifact, defeating the seed-suite-as-truth goal. |
| No branch/merge | Multi-institution RC4 objective (per `RC4-ARCHITECTURE.md`) is structurally unsupported: two institutions' data cannot be merged without a merge policy. |
| No deprecation | Dead data (templates, monitoring.*, Era-1 anchors) persists and inflates all counts: 81 SEED_ONLY tables, 27 populated dead-only tables, 1,417 rows. |
| No archive | `UNUSED` 35 tables (2 populated, 79 rows) have no disposal rule. |

### 6.3 Verdict

- The architecture models **construction, not lifecycle**. For a production-deployable platform (RC4 goal), a canonical dataset must have a defined lifecycle including promotion, deprecation, and multi-tenant branching. This gap is architectural, not cosmetic.

---

## S7 — Operational Architecture

| Concern | Requirement for RC4 | Evidence of gap |
|---|---|---|
| Multi-branch environments | Parallel staging/QA/prod datasets | Only a single baseline-restore path (`reset-dev-db.ps1`) is deterministic (installation-readiness Path A). |
| Multi-tenant / multi-institution | RC4 objective per `RC4-ARCHITECTURE.md` | Canonical dataset is a single lineage; no tenant partition, no institution-branching merge (S6). |
| Offline installs | Deployment to non-networked sites | Path B (manual fresh install) is explicitly NOT deterministic; docker Path C yields an empty DB. |
| Incremental upgrades | Patch a running installation without full rebuild | 16 non-idempotent seeds and no upgrade path — only full rebuild or full restore. |
| Seed execution environment | Deterministic, logged, resumable | Current executor is filename-ordered psql with `ON_ERROR_STOP=1`; SREA proposes the real orchestrator but it is not yet built. |
| Auditability of dataset provenance | Who/what/when produced each row | Tracker timestamps are dump-restored artifacts (A1); provenance is untrusted. |

### Verdict
- **Not operationally ready.** The architecture supports a single deterministic restore path; every other operational mode (incremental upgrade, multi-tenant, offline fresh install, environment promotion) is either unsupported or explicitly broken.

---

## S8 — Verification Completeness

### 8.1 What is verified today vs what is asserted

| Assertion | Verified? | Evidence |
|---|---|---|
| Referential integrity | Yes | 0 broken FKs across 45,453 rows (`seed-quality-report.md` A). |
| RLS correctness | Yes (sample) | Registration + documents INSERT policies verified (3/3 tests). |
| Row-count targets per module | Partially | Population audit by module exists; no commit-asserted thresholds. |
| FK anti-joins / orphans | Proposed | SREA §9 proposes; not yet implemented. |
| Duplicate/empty-chain checks | Proposed | SREA §9 proposes; not yet implemented. |
| Feature completeness (28 features, 315 routes) | Partially | Route-read coverage exists; behavioral assertion does not. |
| Workflow reachability (RULE 11) | **No** | Terminal states are derived; never asserted. |
| Evidence DELETE matrix (RULE 12, 7 scenarios) | **No** | Policy matrix documented in AGENTS.md; never executed against dataset. |
| Committee lifecycle (creation→meeting→resolution) | **No** | 607 rows populated; no lifecycle assertion. |
| Notification/communication behavior | **No** | 12 empty-table routes; behavior unasserted. |
| Long-running transitions | **No** | No seed exercises or verifies a full multi-state application lifecycle. |
| Frontend flows (51 pages, 167 SDK methods) | **No** | SDK route mapping only; `applicationId=0` hardcode proves unexecuted paths. |

### 8.2 Root cause

- The verification architecture is **integrity-centered, not behavior-centered**. It proves the dataset satisfies constraints; it does not prove the dataset satisfies business semantics. RULE 11 and RULE 12 are the two clearest victims — both are pure business logic with no schema representation and no verification hook.

### Verdict
- Verification is **incomplete by design**. Row counts and FK checks are necessary but are the weakest possible correctness signal. Without reachability, ownership-matrix, and lifecycle assertions, "verification passing" cannot be read as "RC4-ready".

---

## S9 — Future Risk Analysis

Probability (P): 1–5. Impact (I): 1–5. Fix difficulty (F): 1–5 (5 = hardest).

| # | Risk | Area | P | I | F | Rank (P×I×F) |
|---|---|---|---|---|---|---|
| R1 | Tracker trust remains broken; replay decisions silently wrong | Execution | 5 | 5 | 4 | 100 |
| R2 | Full-suite determinism from seed SQL never achieved (Era-1 anchors + dual lineage) | Reproducibility | 5 | 4 | 5 | 100 |
| R3 | Business-correctness debt compounds (RULE 11/12 never asserted) | Verification | 5 | 4 | 4 | 80 |
| R4 | Multi-institution RC4 objective blocked by missing branch/merge lifecycle | Dataset lifecycle | 4 | 4 | 4 | 64 |
| R5 | Dead-data inflation grows (templates, monitoring.*, Era-1 anchors) | Maintenance | 5 | 3 | 3 | 45 |
| R6 | Scope-key deletes under RLS silently fail (deny-list incomplete) | Idempotency | 3 | 4 | 3 | 36 |
| R7 | Operational modes (incremental upgrade, offline install) remain broken | Operations | 4 | 3 | 3 | 36 |
| R8 | Aggregate-boundary debt blocks authorization refactors | Domain model | 4 | 3 | 4 | 48 |
| R9 | Future schema changes stall on dual-implementation governance burden | Evolution | 4 | 3 | 4 | 48 |
| R10 | Gate-0 dump becomes the only trusted artifact, seed suite abandoned | Architecture drift | 3 | 4 | 5 | 60 |

Top 3 by product: R1 (100), R2 (100), R3 (80). R10 (60) is the strategic drift risk that follows if R1/R2 are left unaddressed.

---

## S10 — Architecture Verdict

### 10.1 Dimension ratings

| Dimension | Rating (1–5) | Rationale |
|---|---|---|
| Domain Modeling | 2 | Implicit aggregates; invariants distributed across policies/repos/services; terminal state derived, never stored. |
| Boundary Design | 2 | Module boundaries by convention only; `security.users` and `core.applications` are unbounded shared anchors; `monitoring.*` unowned. |
| Maintainability | 2 | Append-only ledger with 16 non-idempotent files, dead anchors, 9 collision groups, no retire process. |
| Extensibility | 2 | Multi-institution/tenant branch-merge unsupported; 28-feature completeness counts dead features (`templates.*`). |
| Governance | 1 | No process for add-schema, add-feature, retire-feature, or dataset v2; tracker trust broken (A1). |
| Evolution | 2 | Change log, not change management; dual-implementation burden on every future change. |
| Operational Readiness | 2 | One deterministic path (baseline restore); incremental/offline/multi-tenant/promotion unsupported. |
| Dataset Architecture | 2 | Construction lifecycle only; promotion/deprecation/branch/merge/archive undefined. |
| Verification Architecture | 2 | Integrity-centered only; business behavior (RULE 11/12, committee lifecycle, notifications, long-running transitions) never asserted. |
| Overall Maturity | 2 | Analysis is strong (17 documents, 45,453 rows, 315 routes mapped) but the produced architecture cannot yet deliver a deterministic, governable, evolvable canonical dataset. |

### 10.2 Verdict

**NO — do not start implementation.**

The SREA implementation plan is well-formed at the mechanism level (registry, dependency engine, verification engine, rollback), but the challenge review finds that starting it now would harden an architecture whose foundations are still unsound:

**Blocking conditions (must be resolved before implementation begins):**
1. **Tracker trust** — `ops.seed_tracker` state is dump-restored and cannot drive replay decisions (A1). The registry redesign must treat current tracker rows as untrusted and rebuild provenance, not migrate it.
2. **Business-correctness verification** — RULE 11 reachability, RULE 12 ownership-matrix, committee lifecycle, and notification behavior have no verification hook. The verification engine must assert behavior, not only integrity (S8).
3. **Dataset lifecycle** — promotion, deprecation, branch/merge, and archive are undefined. RC4's multi-institution objective cannot be met without them (S6).
4. **Dead-data policy** — Era-1 anchors, `templates.*`, and `monitoring.*` must have a defined removal/archival path before canonical counts can be trusted (S5, S9 R5).

**Recommended posture:** proceed to **SREA Phase 1 gate** (registry + dependency engine proof on a single lineage) only after the four blocking conditions above are addressed in the design, not during it. If the business accepts single-lineage, single-institution scope for RC4, conditions 3–4 may be deferred but conditions 1–2 are mandatory regardless of scope.

**Independent judgment:** the analysis artifacts are the strongest asset produced so far. They should be preserved as the authoritative source of truth and the seed suite should be demoted from "source of truth" to "historical record" until a reproducible, behavior-verified canonical dataset exists.
