# Architectural Decision Log — Phase 3 Constitutional Relationship Model

> Engineering decision record for the Phase 3 relationship layer. This is **not** a constitutional ADR: it records the structural-engineering decisions taken to build the relationship model under the approved architecture. No decision here amends the constitution, so no new ADR was required (Governance Freeze §4 — changes to frozen elements require an ADR; none were made). Authority: ADR-001, ADR-002, `constitutional-enforcement-architecture.md`, `constitutional-object-model.md`, `constitutional-state-machine.md`, Phase 1 registry foundation (APPROVED), Phase 2 specification layer (APPROVED).

| Decision | ID |
|---|---|
| Scope: relationship/metadata layer only | DEC-3.1 |
| Ten metadata models in coverage order | DEC-3.2 |
| 26-kind immutable relationship vocabulary | DEC-3.3 |
| Layered pipeline with no Registry → Runtime edge | DEC-3.4 |
| Registry/spec content referenced, never duplicated | DEC-3.5 |
| Immutability via read-only types + scope marker | DEC-3.6 |
| Authority resolution as a written decision map (D1..D8) | DEC-3.7 |
| Dependency and traceability graphs defined as shapes only | DEC-3.8 |
| Baseline preserved: ownership/verification/gate/decision/exception stay at Phase 0/1 state | DEC-3.9 |
| Structural tests cross-reference Phase 1/2 read-only | DEC-3.10 |
| Location: `backend/src/governance/relationships/` | DEC-3.11 |

## DEC-3.1 — Scope: relationship/metadata layer only

Phase 3 implements the **missing structural relationship layer between the Phase 2 specifications and the future enforcement engine**. It contributes the structural contract the engine will consume — identity, immutable relationships, layer linking, dependency graph, traceability graph, authority resolution, evidence ownership, verification/gate dependency, decision provenance, exception linkage — as passive metadata. It authors no predicate, procedure, binding, decision, or exception; that remains the work of D2/D4/D5/D6 in later phases (enforcement architecture §7.3, §8).

## DEC-3.2 — Ten metadata models in coverage order

The catalog enumerates exactly the ten models required by the Phase 3 mandate: **MODEL-IDENTITY, MODEL-LINKING, MODEL-DEPENDENCY-GRAPH, MODEL-TRACEABILITY, MODEL-AUTHORITY-RESOLUTION, MODEL-EVIDENCE-OWNERSHIP, MODEL-VERIFICATION-DEPENDENCY, MODEL-GATE-DEPENDENCY, MODEL-DECISION-PROVENANCE, MODEL-EXCEPTION-LINKAGE**. The first five are the cross-cutting infrastructure (identity, layers, dependency, traceability, authority); the last five are the chain-link models (ownership, verification dependency, gate dependency, decision provenance, exception linkage). Chain head (Rule, R1) and cross-cutting registries (R7/R8/R10/R11) are Phase 1 content and are referenced, not redefined.

## DEC-3.3 — 26-kind immutable relationship vocabulary

The relationship-kind catalog (`RELATIONSHIP_KINDS`) fixes the immutable relationship vocabulary at 26 kinds sourced from `constitutional-object-model.md` §2.1–§2.3 (rule relationships, chain relationships, cross-cutting: Lifecycle/Ownership/Traceability) plus the `extends` layer link from Phase 2. Every kind declares `validFrom`/`validTo` object-kind ranges, so the future engine can reject ill-typed links by construction. The two rule-subclass object kinds (Principle, Invariant) required by `realizes`/`derives-from` are added to the object-kind union to keep the vocabulary type-safe.

## DEC-3.4 — Layered pipeline with no Registry → Runtime edge

The layer linking model encodes the architecture's pipeline as written edges: **Registry → Specification → Relationship Model → Future Enforcement Engine** (`extends`, `attaches-to`, `traverses`). `LAYER_ARCHITECTURE_RULE` extends the Phase 1/2 runtime prohibitions and forbids any direct Registry → Runtime connection. The three edges are the only inter-layer paths; the engine consumes the relationship model, never the registries directly.

## DEC-3.5 — Registry/spec content referenced, never duplicated

Every model references registry and specification content by id and by current-state description (e.g., "R3 keeps 7 artifact types; 13 present sources", "R5 GATE_01..05 with 0 bindings") instead of restating it. The Phase 3 tests import the Phase 1 registries and Phase 2 specs read-only to assert that these references resolve against the actual catalogs — keeping three layers in lockstep without editing Phase 1 or Phase 2.

## DEC-3.6 — Immutability via read-only types + scope marker

Every model object is typed `readonly` throughout (matching Phase 1/2 conventions), and each carries `scope: PHASE_3_SCOPE = 'constitutional-relationship-model'`. `RELATIONSHIPS_RUNTIME_PROHIBITED` extends the Phase 1/2 prohibitions to the relationship layer: no evaluation, resolution, or enforcement behavior may be wired from these modules before a later architectural review approves it.

## DEC-3.7 — Authority resolution as a written decision map (D1..D8)

The authority resolution model turns each enforcement domain owner (D1..D8) into a written resolution: authority body + authority documents + basis. It is a decision map, not a resolver — the future engine resolves recorded authority against this map. Every transition without a recorded authority remains a state-machine violation by definition (§4.6), so the map exists to make that check structurally possible.

## DEC-3.8 — Dependency and traceability graphs defined as shapes only

The dependency graph model defines the enforcement chain (Rule → Constraint → Evidence → Verification → Gate → Decision) with its five edge kinds (constrained-by, examines, evaluates, requires, produces) as a structural shape; the traceability graph defines the backward chain (Decision → Evidence → Constraint → Rule) for T3/G3/EC8. Both are shapes only — no node is bound, no chain is instantiated, and per-rule link presence stays at its Phase 0/1 baseline.

## DEC-3.9 — Baseline preserved: ownership/verification/gate/decision/exception stay at Phase 0/1 state

The five chain-link models state their baselines explicitly and leave them untouched: ownership declares single-owner rules over R3's 7 artifact types (13 present sources, 30 gap); verification keeps all 10 EC procedures `NotRegistered`; gates keep `GATE_ELEMENT_ASSIGNMENTS` empty and `requiredVerification` unbinding; decisions stay at 0 recorded; exceptions register only the single unrecorded I11 precedent. The model layer adds structure; it changes no record.

## DEC-3.10 — Structural tests cross-reference Phase 1/2 read-only

The new test file verifies the catalog's integrity (10 models, unique ids, coverage order, scope, authority citations, composed-of kinds valid) **and** asserts the Phase 1 registry and Phase 2 spec baselines it references are intact (11 registries R1..R11; 43 element ids; 7 artifact types; EC1..EC10 NotRegistered; 5 gates with 0 bindings; 0 decisions; 1 unrecorded I11 precedent; 6 spec kinds). This makes Phase 3's "structural layer" claim checkable and proves zero drift in the underlying layers. Phase 1 and Phase 2 test files were not modified.

## DEC-3.11 — Location

The layer lives at `backend/src/governance/relationships/`, a sibling of the Phase 1 `registries/` and Phase 2 `specifications/` trees, keeping all constitutional infrastructure under `src/governance/` and out of the runtime graph (`src/index.ts`, `src/modules/`, `src/services/`, `src/repositories/`, `src/middleware/`).
