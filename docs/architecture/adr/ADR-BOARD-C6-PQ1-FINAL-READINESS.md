# ADR BOARD — C6 & PQ-1 FINAL READINESS

> Pre-ADR status. Does not authorize Phase 4; does not amend the constitution; does not create/amend ADR-003+. The Board's decision on ADR-003+ remains the ONLY unblocked-action path for Phase 4.

| Field | Value |
|---|---|
| Status | **READY FOR ADR DRAFTING — E (C6 + PQ-1)** |
| Date | 2026-08-10 |
| Evidence base | C6-security-definer-final-audit.md + C6-security-definer-inventory.csv + PQ1-EC8-final-confirmation.md (retained as unrelated historical evidence only — resolves a different EC-8 question; see item 5) + matrix reconciliation |
| Constraint | Phase 4 remains BLOCKED pending the Board's ADR-003+ decision. This artifact only removes the "further investigation" blocker. |

---

## 1. Readiness statement

The ADR Board can now decide C6 and PQ-1 **without another investigation**. The evidence required for the decision is complete:

1. **C6 surface (complete):** 30 SECURITY DEFINER functions = 28 live (13 system + 4 security + 6 committee + 5 documents) + 2 migration-only; recorded counts re-verified from 6 schema dumps; historical growth traced across 17 backup dumps.
2. **C6 finding (verified):** every SECURITY DEFINER function that reads/writes an RLS-protected table bypasses RLS; unrecorded deviation = violation (R9). Only 1 precedent recorded, scope "registration only", status Unrecorded → uncovered surface = 27 live functions.
3. **C6 path (tested):** one exception is possible; C6-D (interpretation: DOMAIN_MODEL A02/A09 is the semantic home of RULE 12, RLS policies its enforcement expression) + C6-C (recorded R9 exception with fixed scope/expiry; I11 → Suspended) resolves C6's two parts; no constitutional amendment required.
4. **C6 consequence (documented):** I11 gate remains un-bindable (GD-2) while the exception is in force; the bypass-detection verification cannot be gated on a Suspended rule.
5. **PQ-1 (confirmed):** EC-8 audit-chain Candidate A (`Decision → Evidence → Constraint → Rule`) is explicit in `constitutional-object-model.md` §2.3 line 107 and `constitutional-enforcement-architecture.md` §2/§3 (line 76), both labeling it T3/EC8 (A4-01 corrected: the traceability-chain confirmation rests on these constitutional sources, not on `PQ1-EC8-final-confirmation.md`, which resolves a different EC-8 question — the Document-aggregate subscriber endpoint). The traceability-chain selection requires no new model; no amendment.
6. **Matrix (reconciled):** prior-package option/requirement/state matrices reconciled against the governance registries and the constitution.

## 2. Decision inputs for ADR-003+ (Board's to choose)

| Item | Options | Evidence |
|---|---|---|
| Exception scope | Bounded class (option 3) vs per-object (option 2) vs broad (option 1) vs hybrid (option 6) | Audit §4 |
| I11 treatment | Suspended for exception scope (state-machine transition 10) | constitution §2.1/§6 |
| Expiry | Fixed term vs permanent; re-review cadence | audit §4 |
| EC-8 candidate | Candidate A (explicit) | PQ1 confirmation §2 |
| RULE 12 home | Semantic = DOMAIN_MODEL; enforcement = RLS; separation = C6-D | audit §6 |

## 3. What is NOT decided here

- ADR-003+ content and its signature (Board action).
- Phase 4 unblocking (remains BLOCKED pending that decision).
- Any change to R1–R11, seed/registry/state, or source (frozen during the audit).

## 4. Recommended next step (one of three)

1. **Board drafts ADR-003+** using the decision inputs in §2 (releases C6/PQ-1; Phase 4 unblocks after).
2. Board **rejects/defers** ADR-003+ → Phase 4 remains blocked; record the decision in the Board log.
3. Board **requests a specific additional audit** (e.g. a per-policy RLS bypass audit) → only then does further investigation occur.

## 5. References

- `C6-security-definer-final-audit.md`
- `C6-security-definer-inventory.csv`
- `C6-final-decision-readiness.md`
- `PQ1-EC8-final-confirmation.md`
- `ADR-BOARD-C6-PQ1-MATRIX-RECONCILIATION.md`
- Prior: `ADR-BOARD-C6-PQ1-DECISION-PACKAGE.md`, `ADR-BOARD-C6-PQ1-OPTION-MATRIX.csv`, `ADR-BOARD-C6-PQ1-RECOMMENDATION.md`
