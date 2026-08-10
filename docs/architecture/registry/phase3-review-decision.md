# Review Decision — Phase 3 Constitutional Relationship Model

| Field | Value |
|---|---|
| Decision ID | DECISION-P3-001 |
| Decision | **APPROVED WITH CONDITIONS** |
| Date | 2026-08-09 |
| Reviewing body | Independent architecture review (opencode) |
| Authority | ADR-001; ADR-002; `constitutional-enforcement-architecture.md` (§7.3, §8); `constitutional-object-model.md`; `constitutional-state-machine.md`; `architecture-governance-freeze.md`; Phase 1 registry foundation (APPROVED); Phase 2 specification layer (APPROVED) |
| Basis | `phase3-architectural-review.md` (15 sections); `phase3-architectural-review-matrix.csv`; `phase3-relationship-risk-register.csv`; independent re-verification of the Phase 3 verification report |
| Scope | Approves Phase 3 as a completed, scoped engineering step. This is **not** a constitutional ADR and does not authorize runtime enforcement. |
| Decision type | Engineering review approval (not a constitutional change; Governance Freeze §4 — no frozen element is amended) |

---

## 1. What was reviewed

The Phase 3 Constitutional Relationship Model — ten passive metadata models under `backend/src/governance/relationships/`, the 26-kind immutable relationship vocabulary, the model catalog and facade, the 29 structural tests, and the six companion reports in `docs/architecture/registry/`. The review was read-only and independent: it re-ran `npm run lint`, `npm run build`, and `npx vitest run src/governance` (89/89 green), verified zero runtime wiring by grep, parsed `constitution-enforcement-matrix.csv` independently (12/43, 13/43, 11/43, 0/43, 0/43), and inspected every model file and test against the approved source-of-truth documents.

## 2. Verified strengths (unconditional findings)

1. **Scope integrity** — Phase 3 is exactly the structural relationship/metadata layer the mandate required. No predicate, procedure, binding, decision, or exception was authored or executed.
2. **Non-interference** — no Phase 1 or Phase 2 file was modified; no runtime file imports the constitutional layer; no API/OpenAPI/schema/migration/seed/DB change; no commits or tags. Verified from the repository state, not asserted.
3. **Reproducible verification** — the Phase 3 verification report's quantitative claims were re-run independently and confirmed.
4. **Constitutional fidelity** — the vocabulary and the five chain-link models (OWN/VD/GD/DP/EL rules) encode the object model, enforcement architecture, and state machine with high fidelity; all Phase 0/1 baselines are preserved byte-for-byte.

## 3. Conditions (must be satisfied before the enforcement-engine phase proceeds)

| # | Condition | Finding(s) | Severity |
|---|---|---|---|
| C1 | Fix the dependency-graph edge-direction semantics and correct the report diagrams/tables that imply uniform forward direction. The future engine must have a defined traversal contract. | HIGH-1 | High |
| C2 | Enforce range-compatibility of every model's composed-of kinds against its objectKinds in the test suite; resolve the `cites`/Document inconsistency and the layer `via`-kind violations ('attaches-to', 'traverses' used outside their vocabulary ranges); align MODEL-LINKING objectKinds with its own endpoints. | HIGH-2, MED-1 | High |
| C3 | Document the identity-model scoping (registry-anchored kinds only) or extend id rules to ADR/Principle/Invariant/Lifecycle/Ownership/Traceability/Baseline (ADR at minimum). | MED-2 | Medium |
| C4 | Add source-of-truth verification of the relationship vocabulary against object-model §2.1–§2.3 (exact set, direction, ranges); resolve the `constrains` and `belongs-to` range choices. | MED-3, MED-5, LOW-3 | Medium |
| C5 | Fix the `records` provenance annotation; update the stale "twelve models" comment in `types.ts`; surface the T3-chain ambiguity (LOW-2) to the ADR board and record the EC8 audit chain. | MED-4, LOW-1, LOW-2 | Low |
| C6 | Commit to a dated governance plan to record the I11 exception (R9) and resolve the P3–I11 conflict **before** binding any gate that gates the I11 verification (GD-2). This is the program's dominant risk and is a governance item, not a code item. | OBS-1 | High |

**Closed as of this decision:** none (all conditions open). C1–C5 may be closed by the owning domains (D1/D4/D5) via fixes plus re-verification, or by a documented, reviewed acceptance of the described scoping; C6 is closed only by a recorded ADR-board commitment with a date.

## 4. Binding statements

1. **Phase 3 is APPROVED as scoped** — the constitutional relationship model is accepted as the structural contract between the Phase 2 specification layer and the future enforcement engine.
2. **No Phase 4 work may begin** — no enforcement engine, no constraint/verification/gate authoring, no predicate writing, no runtime wiring — until C1–C5 are closed and C6 is committed. This extends the existing prohibitions (`RUNTIME_ENFORCEMENT_PROHIBITED`, `SPECIFICATIONS_RUNTIME_PROHIBITED`, `RELATIONSHIPS_RUNTIME_PROHIBITED`) and makes the gate explicit: a later architectural review must confirm closure of C1–C6 before approving Phase 4.
3. **This decision amends nothing in the constitution** (Governance Freeze §4). The three known constitutional defects (P3–I11 conflict, I11 bypass, P7 circularity) remain deferred to their ADRs and are **not** resolved here; C6 governs the I11 bypass.
4. **Baselines remain authoritative.** Constraints 12/43, evidence 13/43, verification 11/43 (all NotRegistered), gates 0/43 (5 gates, 0 bindings), decisions 0/43, exceptions 1 unrecorded precedent. No approval in this decision changes any of these numbers.

## 5. Decision log

| Date | Entry | Authority |
|---|---|---|
| 2026-08-09 | Review completed; 15 sections assessed; 1 high/medium/low finding set recorded (HIGH-1, HIGH-2, MED-1..5, LOW-1..3, OBS-1); decision APPROVED WITH CONDITIONS C1–C6. | Independent architecture review |

---

Prepared by the independent architecture review. Registered under `docs/architecture/registry/`. Not an ADR; does not amend the constitution.
