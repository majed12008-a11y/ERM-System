# ADR-019 — EC8 Audit Chain (Traceability)

> DRAFT ONLY — NOT an accepted decision. This document proposes a decision to the ADR Board. It creates no obligation until formally accepted and registered in `docs/architecture/adr/ADR-INDEX.md` (ADR-001 §2.2, §2.3). It does not authorize Phase 4.
>
> **Numbering correction (finding J-01, review `ADR-003-004-PRE-BOARD-REVIEW.md` §Phase 5):** this decision was originally drafted as **ADR-004**. That number collides with the ADR-INDEX §2.1 informal-ADR reconciliation reservations (RC4 ADR-02 → TBD-P3 (ADR-004); ADR-001 §2.1: "A number is never reused"; Governance Freeze EC10). Resolution option **R1** assigns the next free numbers above all reservations (ADR-018/ADR-019). ADR-004 remains a historical draft with superseded numbering (see `ADR-004-EC8-AUDIT-CHAIN.md`).
>
> **Evidence correction (finding A4-01, review §3.1):** the earlier ADR-004 draft cited `PQ1-EC8-final-confirmation.md` as confirming the traceability-chain Candidate A. That document resolves a **different** EC-8 question — the Document-aggregate subscriber endpoint — and cites a non-existent source (`domain-model/object-model.md`). It does not speak to the traceability-chain selection. In this ADR the mis-citation is **removed**; the traceability-chain Candidate A rests solely on the constitutional sources (§2 evidence items 1–2, 4–6).

| Field | Value |
|---|---|
| Number | ADR-019 |
| Title | EC8 Audit Chain — canonical decision-trace chain `Decision → Evidence → Constraint → Rule` |
| Status | **PROPOSED — PENDING ADR BOARD APPROVAL** |
| Date | DRAFT / TBD (drafted 2026-08-10; renumbered 2026-08-11; effective date is a Board decision, blank in §2.4) |
| Author | Drafted by the governance review from the final C6/PQ-1 audit (pre-ADR artifacts); decision authority is the ADR Board |
| Decision authority | ADR Board (ADR-INDEX §3 PQ-1: "Resolved here → decisions are recorded as formal ADRs") |
| Provenance | ADR-INDEX §3 PQ-1; LOW-2 (`docs/architecture/registry/phase3-review-decision.md`); `docs/constitutional-object-model.md` §2.3 (line 107); `docs/constitutional-enforcement-architecture.md` §2/§3; ADR-002 T3/G3/EC8; `TRACEABILITY_CHAIN` in `backend/src/governance/relationships/traceability-graph.ts`; review finding J-01 (resolution R1) |
| Constraints honored | DRAFT only. Nothing in this document is implemented; no source code, SQL, database, seeds, registries (R1–R11), specifications, relationship models, or APIs are changed by this draft; ADR-INDEX §1/§3 statuses unchanged by this draft; no commit or tag. |
| Purpose | Propose that the canonical EC8 audit chain be `Decision → Evidence → Constraint → Rule` (Candidate A), confirming the explicitly stated constitutional chain, and that the full enforcement chain be recorded as its projection. |
| Supersedes | None. (Its own numbering supersedes the historical ADR-004 draft per J-01 R1; that is a numbering correction, not a decision supersession.) |
| Related ADRs | ADR-001, ADR-002, ADR-018 |

---

## 1. Context

PQ-1 (ADR-INDEX §3) asks: which traceability chain is authoritative for EC8 — the §2.3 chain `Decision → Evidence → Constraint → Rule`, or the §4 full chain via Verification/Gate?

The EC8 audit chain is the object-level decision-trace chain the future enforcement engine audits for decision provenance (T3: backward trace from decision to evidence to constraint to rule). It is distinct from the document-level exit criterion EC8 ("all 6 traceability chains re-verified, 0 broken") — that referent is a separate verification scope and is not what this ADR decides (PQ1RSK-02).

The constitution states the traceability chain in two places:

- `docs/constitutional-object-model.md` §2.3 (line 107): `Traceability | traverses | Relationship | Decision → Evidence → Constraint → Rule (T3; EC8)` — the **explicit** statement, labeled T3/EC8.
- `docs/constitutional-object-model.md` §4: the full enforcement chain `Rule → Constraint → Evidence → Verification → Gate → Decision` — from which a full backward reading `Decision → Gate → Verification → Evidence → Constraint → Rule` can be inferred, but which is **not** labeled as the audit/traceability chain.

Phase 3 recorded Candidate A (`TRACEABILITY_CHAIN` in `backend/src/governance/relationships/traceability-graph.ts` = `['Decision','Evidence','Constraint','Rule']`; asserted by `backend/src/governance/relationships/__tests__/relationships.test.ts:384`) and surfaced the source ambiguity to the Board as PQ-1 instead of resolving it unilaterally (LOW-2; `phase3-architectural-review.md` §118–120; `phase3-conditions-independent-review.md` §87).

---

## 2. Decision

### 2.1 Evidence

1. **`docs/constitutional-object-model.md` §2.3 (line 107):** "Traceability | traverses | Relationship | Decision → Evidence → Constraint → Rule (T3; EC8)". This is the only place in the constitutional sources that names the audit/traceability chain, and it names Candidate A.
2. **`docs/constitutional-enforcement-architecture.md` §2/§3 (line 76):** the Traceability object is defined as "the backward chain decision → evidence → constraint → rule," traversed by T3/G3/EC8 — again Candidate A.
3. **`backend/src/governance/relationships/traceability-graph.ts`:** `TRACEABILITY_CHAIN` = `['Decision','Evidence','Constraint','Rule']` — Candidate A, already recorded by Phase 3.
4. **`docs/architecture/registry/phase3-traceability-report.md` (§3), `phase3-dependency-graph-report.md` (§3), `phase3-conditions-closure-report.md`:** the recorded audit chain is `Decision → Evidence → Constraint → Rule` (object-model §2.3; ADR-002 T3), with the alternative full-chain reading surfaced as the open PQ-1 question.
5. **ADR-002 §5 (T3) / G3 / EC8:** T3 — backward traceability to evidence; G3 — every decision traces to evidence; EC8 — the 6-chain re-verification exit criterion. All are satisfied by Candidate A.

The exact authoritative source for the chain is **`docs/constitutional-object-model.md` §2.3, line 107**.

> **Removed evidence (A4-01):** the earlier ADR-004 draft listed a third evidence item — `docs/architecture/adr/PQ1-EC8-final-confirmation.md` — as confirming Candidate A. Verified: that document resolves a **different** EC-8 question (Document-aggregate subscriber endpoint; its Candidate A = "unified subscriber endpoint on one aggregate", Candidate B = "separate relationship aggregate subscribes") and cites a non-existent source (`domain-model/object-model.md`; no `domain-model/` directory exists). It does not speak to the traceability-chain selection. It is **removed** from this ADR's evidence and is not cited for the traceability chain anywhere in this package (`ADR-BOARD-C6-PQ1-FINAL-READINESS.md` line 22 is corrected in the same pass).

### 2.2 Candidate analysis

#### 2.2.1 Candidate A — Decision → Evidence → Constraint → Rule

- **Explicit:** the only chain stated in the constitutional sources as the traceability chain (object-model §2.3 line 107; enforcement-architecture §2/§3), both labeling it T3/EC8.
- **Already recorded:** `TRACEABILITY_CHAIN` (Phase 3, condition C5) and the Phase-3 reports.
- **Semantics:** matches T3 ("traces to evidence") directly — a decision is traced to its evidence, the evidence to its constraint, the constraint to its rule. This is the authoritative reading of "decision → evidence → constraint → rule".
- **Object-kind support (Phase-3 vocabulary):** the chain is a **backward traversal** expressed by the `traverses` relationship (`relationship-kinds.ts:61`; validTo includes all chain nodes `['Rule','Constraint','Evidence','Verification','Gate','Decision']`), not by a direct Decision→Evidence edge. `records` has `validTo = ['Verification','Gate']` (`relationship-kinds.ts:50`) and cannot connect Decision → Evidence; `examines` is forward Constraint → Evidence (`relationship-kinds.ts:43`) and `constrained-by` is forward Rule → Constraint (`relationship-kinds.ts:34`); their backward readings are the inverse pairs `is-examined-by` / `constrains` (finding **A4-02**, review §3.3). The Decision → Evidence hop is established through the recorded provenance projection (`records`/`produces` via Verification/Gate), and the engine's EC8 audit scaffold defines its explicit hop-edge contract.
- **No amendment:** selecting A requires no change to frozen constitutional text; the ADR records the selection and the projection.

#### 2.2.2 Candidate B — Decision → Gate → Verification → Evidence → Constraint → Rule

- **Inferred:** read backward from object-model §4 (the full enforcement chain `Rule → Constraint → Evidence → Verification → Gate → Decision`) and from §2.2's map (Verification/Gate both produce Decision).
- **Not stated** anywhere as the audit/traceability chain.
- **Amendments required if selected:** object-model §2.3, enforcement-architecture §2/§3, and the Phase-3 recorded chain.
- **Semantics:** inserts recorded Verification/Gate hops between a decision and its evidence; this describes the *execution* path, not the *audit* path (T3 traces to evidence directly).

#### 2.2.3 Why Candidate A is the authoritative candidate

The chain `Decision → Evidence → Constraint → Rule` is the only one explicitly identified in the constitutional object model as T3/EC8 (`docs/constitutional-object-model.md` §2.3 line 107), is already recorded by Phase 3, requires no amendment, and matches the backward-trace semantics of T3/G3. Candidate B is a defensible inferred reading of §4 but is not stated as the audit chain and would require constitutional amendment. Authority for this comparison: prior decision package §8–§9; governance analysis B.1–B.7.

No alternative candidates are invented: the two candidates above are the only two supported by repository evidence (object-model §2.3 vs §4).

### 2.3 Proposed decision

> **PROPOSED BOARD DECISION.** This section is the proposed decision for Board approval. It is not effective. It binds nothing until the Board accepts ADR-019 and ADR-INDEX §3 PQ-1 is closed.

1. **EC8 = Decision → Evidence → Constraint → Rule** (Candidate A) is proposed as the canonical EC8 audit chain for decision provenance (T3/G3/EC8), confirming the explicitly stated chain in `docs/constitutional-object-model.md` §2.3 (line 107).
2. **The full enforcement chain (Candidate B)** is proposed to be recorded as the documented **projection**: `Rule → Constraint → Evidence → Verification → Gate → Decision` is the *execution/enforcement* chain; the *audit* chain omits the recorded Verification/Gate hops. Candidate B is not the audit chain.
3. **Recording requirement (if accepted):** `TRACEABILITY_CHAIN` remains pinned to Candidate A; the projection is recorded in the traceability model and reports; the EC8 two-referent distinction (document-level 6-chain exit criterion vs object-level audit chain) is preserved.
4. **Hop-edge contract (if accepted):** the audit chain is traversed **backward** via the `traverses` relationship over the chain nodes. `records`, `examines`, and `constrained-by` retain their registered ranges (`relationship-kinds.ts:50/43/34`); the engine's EC8 audit scaffold must assert that every audit-chain hop is direction-legal per `DEPENDENCY_EDGE_DIRECTIONS` and in `RELATIONSHIP_KINDS` range — including the Decision → Evidence hop realized via the provenance projection, never via an out-of-range direct edge (finding **A4-02**).
5. **No constitutional amendment is proposed:** the confirmation requires no change to frozen text (object-model §2.3, enforcement-architecture §2/§3 remain as written).

### 2.4 Board Decision Template

> Fields below are intentionally **blank** — they are the ADR Board's to fill upon acceptance. This draft does not select, date, or condition the decision.

| Field | Value |
|---|---|
| Selected | *(blank — ADR Board decision)* |
| Effective date | *(blank — ADR Board decision)* |
| Approved by | *(blank — ADR Board decision)* |
| Conditions | *(blank — ADR Board decision)* |

---

## 3. Alternatives considered

Only alternatives supported by repository evidence are listed; no candidates are manufactured.

| # | Alternative | Evidence | Disposition |
|---|---|---|---|
| 1 | **Select Candidate B** (`Decision → Gate → Verification → Evidence → Constraint → Rule`) | Inferred from object-model §4 read backward and §2.2 produces-map; defensible but not stated as the audit chain anywhere | Not proposed: requires amendment of object-model §2.3, enforcement-architecture §2/§3, and the Phase-3 recorded chain; treats execution hops as audit hops |
| 2 | **Defer the selection** (leave PQ-1 OPEN) | LOW-2 remains open; engine must not build the EC8 audit before selection (PQ1RSK-01) | Not proposed: the final audit concluded the Board can decide now without further investigation; deferral keeps Phase 4 blocked on an unnecessary open question |
| 3 | **Select Candidate A** (the proposed direction) | Explicit in object-model §2.3 line 107; recorded by Phase 3; no amendment; direct T3 semantics | **Proposed** |

---

## 4. Consequences

### 4.1 Constitutional compatibility

The proposed decision, if accepted, is compatible with:

| Instrument | Compatibility |
|---|---|
| **ADR-001** | Series foundation: ADR-019 follows the binding template (ADR-001 §2.2) and will be registered in ADR-INDEX (§2.3); terminology policy respected (no new terms; final vocabulary only). |
| **ADR-002** | Confirms T3 (backward traceability to evidence), G3 (every decision traces to evidence), EC8 (chain re-verification). No ADR-002 text changes. I5/P3 unaffected (aggregate invariants remain in the model). |
| **Constitutional object model** | Candidate A is exactly what §2.3 states; §4's full chain remains the enforcement chain (its projection is recorded, not replaced). Object validity rules 5 and 8 (decision authority; backward traceability) are satisfied. |
| **Constitutional state machine** | No rule-state transition is involved; ADR-019 is a confirmatory decision (decision lifecycle: recorded → active → archived when superseded, state-machine §5). No Violated/Suspended rule is touched. |
| **Phase 3 relationship vocabulary** | The audit chain is a backward traversal via `traverses`; `records`/`examines`/`constrained-by` retain their registered ranges (27-kind vocabulary) and respect `DEPENDENCY_EDGE_DIRECTIONS`; `TRACEABILITY_CHAIN` already matches Candidate A. |
| **Dependency/direction rules** | The chain is backward (decision → rule); all edges traverse in their permitted direction per `DEPENDENCY_EDGE_DIRECTIONS` (C1/HIGH-1 contract), including the provenance-projection hop contract (§2.3(4)). |

### 4.2 Positive (proposed, if accepted)

- Explicit EC8 definition: the audit chain is unambiguous and already implemented/recorded.
- Deterministic traversal: the engine audits exactly `Decision → Evidence → Constraint → Rule`; no ambiguity between §2.3 and §4 remains.
- Clear provenance path: a decision's trace to evidence, constraint, and rule is direct (T3).
- Mechanical verification target: `TRACEABILITY_CHAIN` pinning and edge assertions are already scaffolded.
- No frozen-text amendment; LOW-2 / PQ-1 closes with a confirmatory ADR.

### 4.3 Negative (proposed, if accepted)

- Future implementation must conform to the chain: any engine EC8 audit must traverse Candidate A only.
- The relationship vocabulary becomes binding for EC8: the audit chain is traversed backward; `records`, `examines`, and `constrained-by` keep their registered ranges, and the Decision → Evidence hop is realized via the provenance projection — out-of-range direct edges are forbidden (A4-02). The Verification/Gate hops are projections and must not be treated as audit hops.
- The EC8 two-referent distinction must be maintained operationally to avoid conflating the document-level exit criterion with the object-level audit chain (PQ1RSK-02).

### 4.4 Phase 4 impact

**Acceptance of ADR-019 alone does NOT authorize Phase 4.**

If accepted, ADR-019 closes the PQ-1 question (the audit chain is defined) — but Phase 4 begins only when the Board, in a separate decision, authorizes it against all Phase-4 preconditions (C6 closes via ADR-018, PQ-1 closes via this ADR, artifacts updated, governance tests green, later architectural review confirms C1–C6 closure — DECISION-P3-001 §4; DECISION-P3-002 §2). The engine's EC8 audit must not be built before the chain is selected; once selected, it must traverse Candidate A only.

---

## 5. References

- `docs/architecture/adr/ADR-001-series-foundation.md`
- `docs/architecture/adr/ADR-002-canonical-dataset-architecture.md` (T3, G3, EC8)
- `docs/architecture/adr/ADR-018-I11-SECURITY-DEFINER-GOVERNANCE.md` (related, proposed)
- `docs/architecture/adr/ADR-004-EC8-AUDIT-CHAIN.md` (historical draft; superseded numbering — J-01 R1)
- `docs/architecture/adr/ADR-003-004-PRE-BOARD-REVIEW.md` (findings A4-01, A4-02, A4-03, J-01)
- `docs/architecture/adr/ADR-003-004-CURRENT-STATE-VERIFICATION.md` (pre-correction baseline)
- `docs/architecture/adr/ADR-INDEX.md` (§3 PQ-1)
- `docs/constitutional-object-model.md` (§2.3 line 107 — Candidate A explicit; §2.2; §4)
- `docs/constitutional-enforcement-architecture.md` (§2/§3 Traceability)
- `docs/constitutional-state-machine.md` (§5 decisions lifecycle)
- `docs/architecture/DOMAIN_MODEL.md` (P3/I5 contract-definition layer)
- `backend/src/governance/relationships/traceability-graph.ts` (`TRACEABILITY_CHAIN`)
- `backend/src/governance/relationships/relationship-kinds.ts` (`records` line 50; `examines` line 43; `constrained-by` line 34; `traverses` line 61)
- `backend/src/governance/relationships/__tests__/relationships.test.ts` (chain assertion, line 384)
- `docs/architecture/registry/phase3-review-decision.md` (LOW-2)
- `docs/architecture/registry/phase3-traceability-report.md`, `phase3-dependency-graph-report.md`, `phase3-conditions-closure-report.md`, `phase3-architectural-review.md`
- `docs/architecture/adr/ADR-BOARD-C6-PQ1-DECISION-PACKAGE.md` (§8–§9 candidates; §10 dependency)
- `docs/architecture/adr/ADR-BOARD-C6-PQ1-RECOMMENDATION.md` (PQ-1 recommendation)
- `docs/architecture/adr/PQ1-EC8-final-confirmation.md` (cited only as the A4-01 removed-evidence record — NOT evidence for the traceability chain)

---

> DRAFT — PROPOSED BOARD DECISION. Not accepted. Not effective. Does not authorize Phase 4. Awaiting ADR Board approval.
