# Architectural Decision Log — Phase 2 Constitutional Enforcement Specifications

> Engineering decision record for the Phase 2 specification layer. This is **not** a constitutional ADR: it records the structural-engineering decisions taken to build the specification layer under the approved architecture. No decision here amends the constitution, so no new ADR was required (Governance Freeze §4 — changes to frozen elements require an ADR; none were made). Authority: ADR-001, ADR-002, `constitutional-enforcement-architecture.md`, `constitutional-object-model.md`, `constitutional-state-machine.md`.

| Decision | ID |
|---|---|
| Scope: specification layer only | DEC-2.1 |
| Six spec kinds in chain order | DEC-2.2 |
| Spec kinds extend registries, reference domain owners | DEC-2.3 |
| Shape-as-fields structural definition | DEC-2.4 |
| No predicate / procedure / binding authoring | DEC-2.5 |
| Registry content referenced, not duplicated | DEC-2.6 |
| Immutability via read-only types + scope marker | DEC-2.7 |
| Structural tests cross-reference Phase 1 registries | DEC-2.8 |
| Location: `backend/src/governance/specifications/` | DEC-2.9 |

## DEC-2.1 — Scope: specification layer only

Phase 2 implements the **missing structural layer between the existing registries (Phase 1) and the future enforcement engine**: the immutable constitutional metadata that defines *what a constraint/evidence/verification/gate/decision/exception specification structurally is*. It does not author the content of any predicate, procedure, binding, decision, or exception — that remains the work of D2/D4/D5/D6 in later phases (enforcement architecture §7.3, §8).

## DEC-2.2 — Six spec kinds in chain order

The catalog enumerates exactly the six kinds named in the Phase 2 mandate, in enforcement-chain order: **Constraint → Evidence → Verification → Gate → Decision → Exception**. The chain head (Rule, R1) and the cross-cutting registries (R7/R8/R10/R11) are Phase 1 content and are referenced, not redefined.

## DEC-2.3 — Spec kinds extend registries, reference domain owners

Each spec kind declares `extends` (the Phase 1 registry whose records it governs: R2→Constraint, R3→Evidence, R4→Verification, R5→Gate, R6→Decision, R9→Exception) and `owner` (the enforcement domain D2–D6 from `constitutional-enforcement-domains.csv`). This keeps single ownership (G5/T5) and links each spec to its authoritative registry without duplicating registry content.

## DEC-2.4 — Shape-as-fields structural definition

Each spec kind defines its structural contract as an ordered list of required fields (`name`, `meaning`, `required`, `source`). This is the "structural definition" of the mandate: it says *what a spec of that kind must contain*, not *what value it must yield*. Every field carries its provenance (`source`) so the shape itself is traceable (T3).

## DEC-2.5 — No predicate / procedure / binding authoring

Constraint predicates, verification procedure steps, gate bindings, and decision/exception records are **not** authored. The gate spec explicitly preserves the Phase 1 baseline (`GATE_ELEMENT_ASSIGNMENTS` empty, `requiredVerification` unbinding) — the mandate forbids runtime/execution work, and the architecture defers this to later phases (§7.3).

## DEC-2.6 — Registry content referenced, not duplicated

The spec definitions reference registry content by id and by description of the current registry state (e.g., "R2 registers 12 present constraints ({I1, I11, EC1..EC10})") rather than restating it. The Phase 2 tests import the Phase 1 registries read-only to assert that these references resolve against the actual catalog — keeping the two layers in lockstep without editing Phase 1.

## DEC-2.7 — Immutability via read-only types + scope marker

Every spec object is typed `readonly` throughout (matching Phase 1's `types.ts` conventions), and each definition carries `scope: PHASE_2_SCOPE = 'constitutional-enforcement-metadata'`. `SPECIFICATIONS_RUNTIME_PROHIBITED` extends Phase 1's prohibition to the specification layer: no behavior may be wired from these modules before a later architectural review approves it.

## DEC-2.8 — Structural tests cross-reference Phase 1 registries

The new test file verifies the catalog's integrity (6 kinds, chain order, unique ids, registry/owner mapping, authority citations, shape uniqueness) **and** asserts the Phase 1 registry baselines it references are intact (12 constraints, 7+13 evidence, EC1–EC10 with 7 Ready/3 NeedsExtension, GATE-01..05 with 0 bindings, 0 decisions, 1 I11 precedent). This makes Phase 2's "structural layer" claim checkable and proves zero drift in the underlying registries. Phase 1's test file was not modified.

## DEC-2.9 — Location

The layer lives at `backend/src/governance/specifications/`, a sibling of the Phase 1 `registries/` tree, keeping all constitutional infrastructure under `src/governance/` and out of the runtime graph (`src/index.ts`, `src/modules/`, `src/services/`, `src/repositories/`, `src/middleware/`).
