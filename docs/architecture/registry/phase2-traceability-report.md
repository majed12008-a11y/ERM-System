# Traceability Report — Phase 2 Constitutional Enforcement Specifications

> Backward-traceability record for the Phase 2 specification layer (backend structural metadata). Every spec kind traces to the approved architecture per T3/G3/EC8 scaffolding. Authority: ADR-001 §2, ADR-002, `constitutional-enforcement-architecture.md`, `constitutional-object-model.md`, `constitutional-state-machine.md`, `architecture/registry/phase1-completion-report.md` (APPROVED).
> This report is engineering traceability, not a constitutional document; it implements no verification.

## 1. File-level traceability

| File | Provenance (approved architecture) | Spec kind (extends / owner) |
|---|---|---|
| `backend/src/governance/specifications/types.ts` | Phase 2 mandate (six kinds); Phase 1 `registry.ts` types (`RegistryId`, `EnforcementDomainId`, `RegistryReference`); `constitutional-object-model.md` | Shared base |
| `backend/src/governance/specifications/constraint.specification.ts` | architecture §2 (Constraint Registry); object-model §2.2 (`constrains → Rule; examines → Evidence; evaluated by → Verification`); state-machine §5; `enforcement-gap-register.csv` baseline | SPEC-CONSTRAINT (R2 / D2) |
| `backend/src/governance/specifications/evidence.specification.ts` | architecture §2 (Evidence Registry); ADR-002 P2/I4/G5 (single ownership); object-model §2.2 | SPEC-EVIDENCE (R3 / D3) |
| `backend/src/governance/specifications/verification.specification.ts` | architecture §6.1 (9 Ready incl. EC set) + §8 (EC1–EC10 initial set); object-model §2.2; state-machine §5 (Verified/Violated) | SPEC-VERIFICATION (R4 / D4) |
| `backend/src/governance/specifications/gate.specification.ts` | architecture §2 (Gate Registry) + §5 state rule ("no gate on a breach"); D5 scope (publication, disposition, ADR approval, construction acceptance, cutover); object-model §2.2 | SPEC-GATE (R5 / D5) |
| `backend/src/governance/specifications/decision.specification.ts` | architecture §2 (Decision Registry); ADR-002 T3/G3/EC8 (decision provenance); object-model §2.2/§3.5 (authority required); state-machine §5 | SPEC-DECISION (R6 / D6) |
| `backend/src/governance/specifications/exception.specification.ts` | architecture §2 (Exception Registry); I11 SECURITY DEFINER precedent (R9, unrecorded/deferred); object-model §2.2/§3.6; state-machine §4.3/§5 | SPEC-EXCEPTION (R9 / D6) |
| `backend/src/governance/specifications/catalog.ts` | Phase 2 mandate (chain order); architecture §2 component grouping | Catalog (6 kinds) |
| `backend/src/governance/specifications/index.ts` | Facade over the six spec kinds; no route/service wiring | Shared base |
| `backend/src/governance/specifications/__tests__/specifications.test.ts` | Structural skeletons verifying the catalog and its cross-references into the Phase 1 registries | Tests |

## 2. Enforcement-chain traceability (rule → constraint → evidence → verification → gate → decision)

Phase 1 established the registries structurally; Phase 2 defines the **structural contract** each chain link's specification must satisfy:

| Chain link | Registry (Phase 1) | Specification kind (Phase 2) |
|---|---|---|
| Rule | R1 (43 elements) | referenced by constraint `element` field (R1 reference) |
| Constraint | R2 (12 present / 31 gap) | SPEC-CONSTRAINT shape (predicate, falsifiabilityCriterion, examinedEvidence, verificationTarget) |
| Evidence | R3 (7 artifacts, 13 present / 30 gap) | SPEC-EVIDENCE shape (artifact, owningBody, currency, admissibleAs, examinedBy) |
| Verification | R4 (EC1–EC10; 7 Ready / 3 NeedsExtension; +I11, G11 ready outside set) | SPEC-VERIFICATION shape (procedureId, constraintRef, inputs, outputs, expectedResult, lastRun, result) |
| Gate | R5 (GATE-01..05; 0 bindings) | SPEC-GATE shape (gateId, requiredVerification, haltOn, produces) |
| Decision | R6 (0 recorded) | SPEC-DECISION shape (decisionId, type, targetElement, authority, recordedOn, tracesTo) |
| Exception | R9 (1 precedent, unrecorded) | SPEC-EXCEPTION shape (exceptionId, targetElement, authority, scope, expiry, status) |

Per architecture §2 the chain is satisfied only when each rule's links run through the registries in order — Phase 2 adds the structural contract; the links themselves remain at their Phase 0/1 baseline (constraints 12/43, evidence 13/43, verification 11/43, gates 0/43, decisions 0/43). No link was bound.

## 3. Cross-layer traceability

| Concern | Traces through |
|---|---|
| Falsifiability (a rule with no constraint is not a rule) | R1 → R2 → SPEC-CONSTRAINT (predicate + falsifiabilityCriterion fields) |
| Single ownership (P2/I4/G5) | R3/R10 → SPEC-EVIDENCE (owningBody field) → ADR-002 P2/I4/G5 |
| Verification independence (D4) | R4 → SPEC-VERIFICATION (outputs binary result) → state-machine §5 (Verified/Violated) |
| No gate on a breach (D5) | R5 → SPEC-GATE (haltOn field) → architecture §5 state rule |
| Decision provenance (T3/G3/EC8) | R6 → SPEC-DECISION (authority + tracesTo fields) → ADR-002 T3/G3/EC8 |
| Exceptions expiring, never silent (D6) | R9 → SPEC-EXCEPTION (scope + expiry + status fields) → I11 precedent (unrecorded, deferred) |
| Uniform state machine | Each spec kind → state-machine §5 applicability statement |

## 4. Exit-criterion contributions (recorded, NOT executed)

| Exit criterion | Contribution of Phase 2 | Status |
|---|---|---|
| EC8 (traceability chains) | Spec-kind `authority` fields + this report scaffold the backward chains decision → evidence → constraint → rule | Scaffold only |
| EC2 (final vocabulary recorded) | The new source files and reports use only the final vocabulary; no forbidden terms introduced | Artifact exists; verification not executed |
| EC1 (ADR-001 exists and approved) | Every spec kind cites ADR-001 as authority | Artifact referenced; verification not executed |

## 5. Non-scope confirmation

- No new ADRs, no architectural documents, no amendments. P3–I11 conflict, I11 bypass, and P7 circularity remain recorded as deferred — none resolved here.
- No constraint predicate, verification procedure, gate binding, decision, or exception was authored or executed. `GATE_ELEMENT_ASSIGNMENTS` and `requiredVerification` remain at their Phase 1 baseline.
- No enforcement behavior, no verification execution, no gates, no decisions, no commits, no API/schema/migration/seed/database changes.
- Phase 1 registries were read only; no Phase 1 file was modified.
