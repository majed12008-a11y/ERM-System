# ADR-003 + ADR-004 — Board Submission

> Board submission cover for two proposed ADRs. This document is NOT an ADR. It does not accept ADR-003 or ADR-004, does not amend the constitution, and does not authorize Phase 4.

| Field | Value |
|---|---|
| Submission | ADR-003 (I11 SECURITY DEFINER Governance) + ADR-004 (EC8 Audit Chain) |
| Date | 2026-08-10 |
| Status | **SUBMITTED — PROPOSED — PENDING ADR BOARD APPROVAL** |
| Authority | ADR-001 (§2.2 binding template; §2.3 index), ADR-002 (constitution), ADR-INDEX §3 (PQ-1, PQ-2) |
| Basis | Final pre-ADR audit: `C6-security-definer-final-audit.md`, `C6-security-definer-inventory.csv`, `C6-final-decision-readiness.md`, `PQ1-EC8-final-confirmation.md`, `ADR-BOARD-C6-PQ1-FINAL-READINESS.md`, `ADR-BOARD-C6-PQ1-MATRIX-RECONCILIATION.md`, prior decision package |
| Constraint | Drafting only. No implementation. No commits, tags, or changes to source/SQL/DB/seeds/registries/specifications/relationship models/APIs. |

---

## 1. What is submitted

| ADR | Title | Status | Decision proposed |
|---|---|---|---|
| [ADR-003](ADR-003-I11-SECURITY-DEFINER-GOVERNANCE.md) | I11 SECURITY DEFINER Governance | PROPOSED — PENDING ADR BOARD APPROVAL | C6-D + C6-C: record the semantic-ownership vs enforcement-location interpretation (no P3/I5/I11 text change) and a bounded, enumerated R9 exception for the 28 live SECURITY DEFINER functions; I11 → Suspended for the exception's scope/expiry |
| [ADR-004](ADR-004-EC8-AUDIT-CHAIN.md) | EC8 Audit Chain | PROPOSED — PENDING ADR BOARD APPROVAL | Select Candidate A — `Decision → Evidence → Constraint → Rule` — as the canonical EC8 audit chain (explicit in `constitutional-object-model.md` §2.3 line 107); record the full enforcement chain as the projection; no amendment |

## 2. Status of each ADR

- **ADR-003 is proposed.** It is not accepted, not effective, and binds nothing until the Board accepts it, the exception is recorded in R9, and ADR-INDEX §3 PQ-2 is closed.
- **ADR-004 is proposed.** It is not accepted, not effective, and binds nothing until the Board accepts it and ADR-INDEX §3 PQ-1 is closed.
- **Both require Board approval.** Neither is currently effective.
- Neither ADR, upon acceptance, authorizes Phase 4 (ADR-003 §11; ADR-004 §8).

## 3. Phase 4 remains blocked

Phase 4 remains **BLOCKED** pending the Board's decisions. The prerequisites for activation of each ADR:

### 3.1 Prerequisites for ADR-003 activation (upon Board acceptance)
1. Exception recorded in R9 (`EXCEPTIONS` populated): target `I11`, authority = ADR-003, scope = Board-fixed surface (proposed: the 28 live functions in `C6-security-definer-inventory.csv`), expiry = Board-fixed, status = `Recorded`.
2. Conflict resolution recorded: the semantic-ownership vs enforcement-location interpretation (C6-D).
3. Verification registered (R2/R4): bypass detection (SECURITY DEFINER + disabled-RLS observable) with the exception carve-out applied — without binding a gate on a Suspended rule (GD-2).
4. I11 state transition recorded: Violated → Suspended for the exception's scope/expiry (state-machine transition 10).
5. ADR-INDEX §3 PQ-2 closed; ADR-003 row added to §1.

### 3.2 Prerequisites for ADR-004 activation (upon Board acceptance)
1. `TRACEABILITY_CHAIN` confirmed/pinned to `['Decision','Evidence','Constraint','Rule']`; projection (full enforcement chain) recorded.
2. Audit-chain edge assertions registered (edges in range, direction-legal).
3. EC8 two-referent distinction recorded (document-level exit criterion vs object-level audit chain).
4. ADR-INDEX §3 PQ-1 closed; ADR-004 row added to §1.

### 3.3 Phase 4 (collective)
Even with both ADRs activated, Phase 4 begins only when the Board, in a **separate decision**, authorizes it after: C6 + PQ-1 closed, artifacts updated, governance tests green, and the later architectural review confirms closure of C1–C6 (DECISION-P3-001 §4; DECISION-P3-002 §2).

## 4. Numbering note (Board must resolve at registration)

ADR-INDEX §2.1 (informal-ADR reconciliation map) reserves **ADR-003..ADR-010** for the RC4 and Phase-5 informal ADRs (RC4 ADR-01 → "TBD-P3 (ADR-003)"; RC4 ADR-02 → "TBD-P3 (ADR-004)"; …), to be renumbered into the formal series during transition Phase 3. ADR-001 §2.1 states **"A number is never reused."**

This submission therefore uses ADR-003/ADR-004 for the C6/PQ-1 decisions **as instructed**, but flags the collision: these two numbers are also reserved in the reconciliation map. The Board must resolve the numbering (e.g., re-sequence, or assign different numbers) **before** ADR-003/ADR-004 are registered in ADR-INDEX §1. Until registered, neither document is part of the formal series (ADR-001 §2.2, §2.3). This submission does not resolve the collision; it records it for the Board.

## 5. Language note

These ADRs are proposals. Nothing in this submission, or in ADR-003/ADR-004, establishes, activates, or resolves anything as a matter of current constitutional fact. Statements such as "I11 is now resolved" or "EC8 is now binding" or "Phase 4 is authorized" are explicitly **not** made here and must not be read into these documents.

## 6. References

- `ADR-003-I11-SECURITY-DEFINER-GOVERNANCE.md`
- `ADR-004-EC8-AUDIT-CHAIN.md`
- `ADR-003-004-CONSISTENCY-MATRIX.csv`
- `ADR-INDEX.md` (§2.1 numbering reservation)
- Final audit artifacts and prior decision package (see ADR-003 §4, ADR-004 §2)
