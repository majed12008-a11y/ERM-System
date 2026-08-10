# ADR Board Recommendation — C6 (I11 / SECURITY DEFINER) + PQ-1 (EC8 Audit Chain)

| Field | Value |
|---|---|
| This document | Advisory recommendation to the ADR board. **RECOMMENDATION only — nothing here is an accepted decision.** The board decides via formal ADRs. |
| Date | 2026-08-10 |
| Authority | ADR-001; ADR-002; ADR-INDEX (§3 PQ-1, PQ-2); `architecture-governance-freeze.md`; DECISION-P3-001; DECISION-P3-002 |
| Basis | `ADR-BOARD-C6-PQ1-DECISION-PACKAGE.md`; `ADR-BOARD-C6-PQ1-OPTION-MATRIX.csv`; `ADR-BOARD-C6-PQ1-EVIDENCE-REGISTER.csv`; `ADR-BOARD-C6-PQ1-PHASE4-PRECONDITIONS.csv`; `c6-pq1-governance-analysis.md`; `c6-pq1-risk-register.csv`; `c6-pq1-review-decision.md` |
| Status | **OPEN — Phase 4 remains BLOCKED pending formal ADR Board decisions.** |

---

## 1. Recommendation summary

1. **C6 (BD-C6-001):** resolve the P3–I11 conflict by **interpretation (option C6-D)** — DOMAIN_MODEL (A02/A09) is the **semantic home** of RULE 12; RLS policies are its **enforcement expression** — **and** grant a **formal exception (option C6-C)** for the enumerated SECURITY DEFINER functions, recorded in R9 with authority = the ADR, a board-fixed scope matching the repository surface (27/15/15/14/14/13 occurrences), and a board-set expiry. This pair satisfies C6's two required parts (record exception + resolve conflict) with the smallest frozen-text change and keeps I11's invariant text intact.
2. **PQ-1 (BD-PQ1-001):** **select Candidate A** — `Decision → Evidence → Constraint → Rule` — as the canonical EC8 audit chain via a **confirmatory ADR** (no frozen-text amendment), and record Candidate B (the full §4 chain) as the documented projection (execution chain, not audit chain).
3. **Process:** issue both as **formal ADRs (ADR-003+, ADR-004+ per board numbering)** following the binding template (`docs/templates/adr-template.md`); register both in ADR-INDEX; close ADR-INDEX §3 PQ-1 and PQ-2; add the §12.4 test set; then run the **later architectural review** confirming closure of C1–C6 before any Phase-4 work.

**Recommended final verdict: C — BLOCKED — ADR BOARD GOVERNANCE DECISION REQUIRED.** (The C6 decision includes amendment and exception components; the package as a whole requires formal ADR-board governance decisions. **E is not selected**: no evidence proves the blockers already closed — R9 remains `Unrecorded`, ADR-INDEX §3 remains OPEN, and no ADR-003+ exists.)

## 2. Why (condensed evidence)

- **I11 is Violated today.** The SECURITY DEFINER bypass is in the accepted baseline (stress test §3), recorded only as an *unrecorded* precedent (R9), and the repository surface is far wider than the recorded "registration only" scope (§6.2). An exception is necessary to lift the standing violation.
- **The P3–I11 conflict is a genuine contradiction** (stress test §2) that an exception cannot resolve — it needs a precedence rule or an interpretation recording which home is semantic and which enforces.
- **GD-2 forbids binding the I11 gate** while I11 is Violated *or* Suspended, so Phase 4 stays blocked until both the exception and the conflict resolution exist, regardless of the option chosen.
- **Candidate A is the only chain explicitly stated** as T3/EC8 (object-model §2.3; enforcement-architecture §2/§3) and is already recorded by Phase 3; selecting it closes PQ-1 without amending frozen text. Candidate B requires a constitutional amendment and is therefore the higher-change path.

## 3. What the board must decide (not this document)

| # | Decision | Fields the board fills | Effective date |
|---|---|---|---|
| BD-C6-001 | Record I11 exception + resolve P3–I11 conflict (ADR-INDEX PQ-2) | Selected option; Reason; Required amendments; exception scope/expiry; Required verification | *(blank — board sets)* |
| BD-PQ1-001 | Select EC8 audit chain (ADR-INDEX PQ-1) | Selected option; Reason; amendment path (if B); Required verification | *(blank — board sets)* |

## 4. Caveats and open items

- The **precedence rule** between P3/I5 and I11 for access-control matrices is required by the stress test and AEM; this document does not invent one — the board states it.
- The **exception scope and expiry** are board decisions; the recorded precedent's "registration only" scope is **factually narrower than the repository** and must be corrected.
- The **EC8 two-referent distinction** (document-level 6-chain exit criterion vs object-level audit chain) must be recorded in the PQ-1 ADR.
- **P7 circularity** remains on its own ADR track; advisory here, but must be resolved before the provenance machinery it touches is relied on.

## 5. No-change boundary

Confirmed: documentation only. No source, SQL, database, seeds, registries, specifications, relationship models, APIs, ADRs, commits, or tags changed by this recommendation.

---

Prepared for the ADR board. Not an ADR; does not amend the constitution; does not authorize Phase 4.
