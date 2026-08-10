# ADR BOARD — C6 & PQ-1 MATRIX RECONCILIATION

> Pre-ADR audit artifact. Reconciles the prior decision-package matrices (option matrix, requirement matrix, state matrix) against the deep audit evidence and the governance registries. No selection; records consistency.

| Field | Value |
|---|---|
| Status | RECONCILED — consistent with final audit + registries |
| Date | 2026-08-10 |
| Constraint | No registry/state/source change; verification only |

---

## 1. Option matrix (6 rows) — reconciled

| Prior-package row | Final audit | Reconciliation |
|---|---|---|
| O1 Broad exception | §4 option 1 — weakest constitutional consistency | Consistent (retained as a rejected-for-alone option) |
| O2 Per-object exception (28) | §4 option 2 — strong, heavy registry load | Consistent (surface count now 28 live, matches) |
| O3 Bounded class exception | §4 option 3 — viable core of C6-C | Consistent (categories enumerate from inventory) |
| O4 Infrastructure-outside-I11 | §4 option 4 — risky reinterpretation | Consistent (requires new classification rule) |
| O5 Amend I11 (C6-A) | §4 option 5 — frozen-text change | Consistent (not required; §6 separation) |
| O6 Evidence-supported hybrid | §4 option 6 — RECOMMENDED | Consistent (C6-D + C6-C test: SUFFICIENT §5) |

## 2. Requirement matrix (G1–G9) — reconciled

All nine requirement rows in the prior package trace to ADR-001/ADR-002 provisions or constitutional paragraphs and remain **unchanged** by the deep audit. The audit added one operational requirement not previously explicit:

- **G10 — Gate-0 verification dependency:** the Gate-0 document lifecycle subsystem (seeds 57/58/59) contributes 4 SECURITY DEFINER functions; C6 exception scope must include them (they are inside the 28 live) and Phase 4 verification must not gate on a Suspended I11 (GD-2). Recorded in audit §1.3/§5.

## 3. State matrix — reconciled

| Rule | Prior-package recorded state | Registry current | Reconciliation |
|---|---|---|---|
| R1 (I11) | Unrecorded precedent; unrecorded violations | R1 I11, precedent `Unrecorded` (exception.registry.ts) | Consistent — the 27 uncovered live functions are unrecorded deviations |
| R7 (RLS sole access control) | Active | rule.registry.ts | Consistent — SECURITY DEFINER bypasses remain under R7 until ADR-003+ |
| R9 (exception recording) | Violated | precedent Unrecorded | Consistent — C6-C records the exception → I11 Suspended (transition 10) |
| I11 | Violated | R1 I11 lines 67–74 | Consistent — the I11 gate stays un-bindable (GD-2) |
| R12 | Deferred/blocked | R12 registry rows | Consistent — C6-D resolves P3–I11 conflict without amendment |
| Phase transition | Phase 4 blocked | GD-2 | Consistent — remains blocked pending ADR-003+ |

## 4. PQ-1 reconciliation

Prior recommendation (PQ-1 = Candidate A) is **confirmed explicit** in `object-model.md` §2.3 line 107 (`PQ1-EC8-final-confirmation.md`). No registry/state change required for PQ-1; it becomes an ADR-003+ content item.

## 5. Deltas introduced by the deep audit

1. Surface fixed at **30 functions (28 live + 2 migration-only)** — supersedes any partial count in the prior package.
2. Recorded precedent covers only **C6-015 (fn_register_user)**; the "registration only" scope in ADR-002/registries is factually false for the repository (§2, Q6; DECISION-PACKAGE §6.2 reference).
3. C6-D + C6-C **sufficient** for C6 governance closure (§5 audit) — the pair is the evidence-supported hybrid (O6).
4. GD-2 consequence: I11 remains un-bindable while exception in force (documented, not a defect).

## 6. References

- Prior: `ADR-BOARD-C6-PQ1-DECISION-PACKAGE.md`, `ADR-BOARD-C6-PQ1-OPTION-MATRIX.csv`, `ADR-BOARD-C6-PQ1-RECOMMENDATION.md`
- Audit: `C6-security-definer-final-audit.md`, `C6-security-definer-inventory.csv`, `C6-final-decision-readiness.md`, `PQ1-EC8-final-confirmation.md`
- Registries: `backend/src/governance/registries/{exception,rule,verification,state-machine}.registry.ts`
