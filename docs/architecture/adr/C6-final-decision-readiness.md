# C6 — Final Decision Readiness (Verdict Evaluation)

> Pre-ADR audit artifact. Input to the ADR Board decision for ADR-003+ (ADR-INDEX PQ-1, PQ-2). Does not amend the constitution; does not authorize Phase 4.

| Field | Value |
|---|---|
| Status | READY — BOARD DECISION REQUIRED (no further investigation needed) |
| Date | 2026-08-10 |
| Prior | `C6-security-definer-final-audit.md` (evidence), `C6-security-definer-inventory.csv` (surface) |
| Verdict | **E — C6 + PQ-1 READY FOR ADR DRAFTING** (with PQ-1 Candidate A explicit) |

---

## 1. Why the audit answers the Board's question

The Board could not decide C6 before because the following were unknown. The deep audit resolved each with mechanical evidence:

| Previous blocker | Now established by |
|---|---|
| Is the SECURITY DEFINER finding real, and what is the full surface? | §1–§2 of the final audit: 30 functions inventoried (28 live + 2 migration-only), counts re-verified from 6 schema dumps |
| Is the exception impossible (constitutional?) or possible? | §4: option 3 viable (bounded class exception); option 6 (hybrid) is the evidence-supported form — "one exception is possible" |
| Does C6 require a constitutional amendment? | §5–§6: NO — C6-D (interpretation) + C6-C (recorded exception) resolve the P3–I11 conflict without changing frozen text |
| What does the Board still have to decide? | The exception scope (fixed to the 28-function surface), its expiry, and authority — i.e. the content of ADR-003+ (a Board decision, not an investigation) |

## 2. Verdict option walk-through (no selection, tested against evidence)

| Option | Test against evidence | Result |
|---|---|---|
| A — BLOCKED; surface requires further architectural decision | The surface is now fully enumerated and options 1–6 evaluated; remaining work is ADR drafting, not architecture research | **NOT supported** |
| B — BLOCKED; constitutional amendment required | §6 proves semantic/enforcement separation without amendment; option 5 (amendment) is one of six, not required | **NOT supported** |
| C — BLOCKED; formal exception design required | Exception design is exactly the ADR-003+ deliverable the Board now has complete inputs for | **NOT supported** |
| D — PQ-1 READY; C6 still blocked | C6 has complete evidence and a tested, sufficient resolution path (C6-D + C6-C) | **NOT supported** |
| E — C6 + PQ-1 READY FOR ADR DRAFTING | Board can decide both with the artifacts; Phase 4 remains BLOCKED pending that decision | **SUPPORTED** |

## 3. Why E is not "just because analysis is complete"

E is supported only because the audit produced **concrete answers** to every open question, not because work was done:

1. **Surface completeness:** §1+CSV — previously partial; now all 30 functions with source, pattern, and classification.
2. **Causal rule:** §2 — SECURITY DEFINER + RLS-protected access = bypass; unrecorded = violation (R9). All 28 live functions are the surface.
3. **Possibility:** §4 — one exception is possible; the bounded class form is sound.
4. **Sufficiency test:** §5 — C6-D + C6-C passes C6's two required parts; GD-2 consequence documented (gate stays unbindable).
5. **No amendment needed:** §6 — RULE 12 semantic vs enforcement authority separation resolves the P3–I11 conflict.
6. **PQ-1:** `PQ1-EC8-final-confirmation.md` — Candidate A is explicit in source (object-model §2.3 line 107).

The Board's remaining decision is **which exception scope/expiry to write** — the substance of the ADR, not further discovery.

## 4. What remains BLOCKED regardless of verdict

- **Phase 4 (RLS policy freeze / bypass-detection verification)** — remains BLOCKED pending the ADR Board's formal decision. E does not authorize Phase 4; it means the Board can now make that decision without another investigation.
- **I11 gate binding** — GD-2 / state-machine rule 2 forbids gating on a rule in Violated or Suspended state; a recorded exception leaves I11 Suspended → still un-bindable while the exception is in force (documented consequence, §5 of the audit).

## 5. References

- `C6-security-definer-final-audit.md` (§1–§6 evidence)
- `C6-security-definer-inventory.csv` (surface)
- `PQ1-EC8-final-confirmation.md` (PQ-1 evidence)
- `ADR-BOARD-C6-PQ1-MATRIX-RECONCILIATION.md` (prior package matrix reconciled)
- Prior package: `ADR-BOARD-C6-PQ1-DECISION-PACKAGE.md`, `ADR-BOARD-C6-PQ1-OPTION-MATRIX.csv`, `ADR-BOARD-C6-PQ1-RECOMMENDATION.md`
