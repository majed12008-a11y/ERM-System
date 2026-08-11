# ADR-018 + ADR-019 — Board Submission

> Board submission cover for two proposed ADRs (renumbered from the historical ADR-003/ADR-004 drafts per review finding J-01, resolution R1). This document is NOT an ADR. It does not accept ADR-018 or ADR-019, does not amend the constitution, and does not authorize Phase 4.

| Field | Value |
|---|---|
| Submission | ADR-018 (I11 SECURITY DEFINER Governance) + ADR-019 (EC8 Audit Chain) |
| Date | 2026-08-11 |
| Status | **SUBMITTED — PROPOSED — PENDING ADR BOARD APPROVAL** |
| Authority | ADR-001 (§2.2 binding template; §2.3 index), ADR-002 (constitution), ADR-INDEX §3 (PQ-1, PQ-2), `ADR-003-004-PRE-BOARD-REVIEW.md` (finding J-01, resolution R1) |
| Basis | Final pre-ADR audit: `C6-security-definer-final-audit.md`, `C6-security-definer-inventory.csv`, `C6-final-decision-readiness.md`, `ADR-BOARD-C6-PQ1-FINAL-READINESS.md`, `ADR-BOARD-C6-PQ1-MATRIX-RECONCILIATION.md`, prior decision package; pre-board review findings; independent re-verification report |
| Constraint | Drafting/correction only. No implementation. No commits, tags, or changes to source/SQL/DB/seeds/registries/specifications/relationship models/APIs. No Board decision is made by this package. |
| Predecessors | ADR-003 (historical draft) → **ADR-018**; ADR-004 (historical draft) → **ADR-019** |

---

## 1. What is submitted

| ADR | Title | Status | Decision proposed |
|---|---|---|---|
| [ADR-018](ADR-018-I11-SECURITY-DEFINER-GOVERNANCE.md) | I11 SECURITY DEFINER Governance | PROPOSED — PENDING ADR BOARD APPROVAL | C6-D + C6-C: record the semantic-ownership vs enforcement-location interpretation (no P3/I5/I11 text change) and a bounded, enumerated R9 exception for the 28 live SECURITY DEFINER functions; I11 → Suspended for the exception's scope/expiry |
| [ADR-019](ADR-019-EC8-AUDIT-CHAIN.md) | EC8 Audit Chain | PROPOSED — PENDING ADR BOARD APPROVAL | Select Candidate A — `Decision → Evidence → Constraint → Rule` — as the canonical EC8 audit chain (explicit in `constitutional-object-model.md` §2.3 line 107); record the full enforcement chain as the projection; no amendment |

## 2. Status of each ADR

- **ADR-018 is proposed.** It is not accepted, not effective, and binds nothing until the Board accepts it, the exception is recorded in R9, and ADR-INDEX §3 PQ-2 is closed.
- **ADR-019 is proposed.** It is not accepted, not effective, and binds nothing until the Board accepts it and ADR-INDEX §3 PQ-1 is closed.
- **Both require Board approval.** Neither is currently effective.
- Neither ADR, upon acceptance, authorizes Phase 4 (ADR-018 §4.3; ADR-019 §4.4).

## 3. Corrections applied relative to the historical drafts

| Finding | Severity | Correction applied | Where |
|---|---|---|---|
| J-01 | HIGH | Numbering collision resolved via R1: ADR-003 → ADR-018; ADR-004 → ADR-019; historical drafts marked superseded-numbering; ADR-INDEX §1 registers the PROPOSED ADRs; ADR-INDEX §3 PQ rows reference the proposed ADRs | ADR-018, ADR-019, ADR-003, ADR-004, ADR-INDEX |
| A4-01 | HIGH | `PQ1-EC8-final-confirmation.md` mis-citation removed from the traceability-chain evidence; evidence now rests solely on constitutional sources; the same conflation corrected in `ADR-BOARD-C6-PQ1-FINAL-READINESS.md` line 22 | ADR-019 §2.1; FINAL-READINESS line 22 |
| A4-02 | MEDIUM | Hop-edge claim corrected: audit chain is a backward `traverses` traversal; `records`/`examines`/`constrained-by` keep their registered ranges; Decision → Evidence hop via provenance projection; hop-edge contract added | ADR-019 §2.2.1, §2.3(4), §4.1, §4.3 |
| A3-03 | MEDIUM | `fn_auto_transition` reconciliation recorded: dropped, not in canonical live extraction, excluded from exception scope; live-baseline confirmation requirement noted before R9 record | ADR-018 §1.7.2, §2.2, §2.5(4) |
| A3-01 | LOW | Bypass count corrected: 27 of 28 access RLS-protected data; `fn_current_user_id` (C6-005) is hygiene-only and included conservatively | ADR-018 §1.4 |
| A3-02 | LOW | §12(5)/§2.5(5) precedence record anchored to the ADR decision (§2.1(1)), not deferred | ADR-018 §2.5(5) |
| A3-04 / A4-03 | LOW | Template conformance: both ADRs follow the binding template (§1 Context, §2 Decision, §3 Alternatives, §4 Consequences, §5 References) | ADR-018, ADR-019 |

Full per-finding detail and verification: `ADR-018-019-PRE-BOARD-CORRECTION-REPORT.md`.

## 4. Phase 4 remains blocked

Phase 4 remains **BLOCKED** pending the Board's decisions. The prerequisites for activation of each ADR:

### 4.1 Prerequisites for ADR-018 activation (upon Board acceptance)
1. Exception recorded in R9 (`EXCEPTIONS` populated): target `I11`, authority = ADR-018, scope = Board-fixed surface (proposed: the 28 live functions in `C6-security-definer-inventory.csv`), expiry = Board-fixed, status = `Recorded`.
2. Conflict resolution recorded: the semantic-ownership vs enforcement-location interpretation (C6-D).
3. Verification registered (R2/R4): bypass detection (SECURITY DEFINER + disabled-RLS observable) with the exception carve-out applied — without binding a gate on a Suspended rule (GD-2).
4. I11 state transition recorded: Violated → Suspended for the exception's scope/expiry (state-machine transition 10).
5. ADR-INDEX §3 PQ-2 closed; ADR-018 row status updated to APPROVED.

### 4.2 Prerequisites for ADR-019 activation (upon Board acceptance)
1. `TRACEABILITY_CHAIN` confirmed/pinned to `['Decision','Evidence','Constraint','Rule']`; projection (full enforcement chain) recorded.
2. Audit-chain edge assertions registered (edges in range, direction-legal; hop-edge contract per ADR-019 §2.3(4)).
3. EC8 two-referent distinction recorded (document-level exit criterion vs object-level audit chain).
4. ADR-INDEX §3 PQ-1 closed; ADR-019 row status updated to APPROVED.

### 4.3 Phase 4 (collective)
Even with both ADRs activated, Phase 4 begins only when the Board, in a **separate decision**, authorizes it after: C6 + PQ-1 closed, artifacts updated, governance tests green, and the later architectural review confirms closure of C1–C6 (DECISION-P3-001 §4; DECISION-P3-002 §2).

## 5. Numbering resolution (J-01)

ADR-INDEX §2.1 (informal-ADR reconciliation map) reserves **ADR-003..ADR-010** for the RC4 and Phase-5 informal ADRs; ADR-011..ADR-017 are reserved for the Phase5 observability audit. ADR-001 §2.1 states **"A number is never reused."** The review's resolution option **R1** (recommended) assigns the next free numbers above all reservations: **ADR-018** and **ADR-019**. This package implements R1:

- ADR-018/ADR-019 carry the corrected decision content.
- ADR-003/ADR-004 are retained as **historical drafts with superseded numbering** (marked, not registered; not part of the formal series).
- ADR-INDEX §1 reserves ADR-003+ for reconciliation as before; ADR-003/ADR-004 are explicitly noted as historical.
- EC10 (no informal-ADR numbering collision) is satisfied: the new numbers do not collide with any reservation.

## 6. Language note

These ADRs are proposals. Nothing in this submission, or in ADR-018/ADR-019, establishes, activates, or resolves anything as a matter of current constitutional fact. Statements such as "I11 is now resolved" or "EC8 is now binding" or "Phase 4 is authorized" are explicitly **not** made here and must not be read into these documents. I11 remains **Violated**; EXCEPTIONS remain empty; PQ-1/PQ-2 remain **OPEN**.

## 7. References

- `ADR-018-I11-SECURITY-DEFINER-GOVERNANCE.md`
- `ADR-019-EC8-AUDIT-CHAIN.md`
- `ADR-018-019-CONSISTENCY-MATRIX.csv`
- `ADR-018-019-PRE-BOARD-CORRECTION-REPORT.md`
- `ADR-003-I11-SECURITY-DEFINER-GOVERNANCE.md` / `ADR-004-EC8-AUDIT-CHAIN.md` (historical drafts, superseded numbering)
- `ADR-003-004-PRE-BOARD-REVIEW.md` (findings), `ADR-003-004-CURRENT-STATE-VERIFICATION.md` (pre-correction baseline)
- `ADR-INDEX.md` (§1, §2.1, §3)
- Final audit artifacts and prior decision package (see ADR-018 §1.7, ADR-019 §2.1)
