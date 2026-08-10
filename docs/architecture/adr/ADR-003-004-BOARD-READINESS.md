# Board Readiness — ADR-003 (I11 SECURITY DEFINER Governance) + ADR-004 (EC8 Audit Chain)

| Field | Value |
|---|---|
| Readiness assessment | Pre-board gate for the two proposed ADRs |
| Date | 2026-08-10 |
| Basis | `ADR-003-004-PRE-BOARD-REVIEW.md` (findings), `ADR-003-004-EVIDENCE-MATRIX.csv` (29 claims verified), `ADR-003-004-RISK-REGISTER.csv` (9 risks) |
| Verdict | **CONDITIONAL — SUBMIT AFTER REQUIRED CORRECTIONS. DO NOT ACCEPT AS WRITTEN.** Two corrections are required before acceptance/registration (J-01 numbering; A4-01 mis-citation). The decision substance of both ADRs is supported by verified evidence. |

---

## 1. The seven readiness conditions

| # | Condition | Status | Notes |
|---|---|---|---|
| 1 | Claim accuracy | PASS with corrections | All 29 material claims verified against source. 4 corrections: A3-01 (LOW), A3-02 (LOW), A3-03 (MEDIUM), A4-02 (MEDIUM). |
| 2 | Constitutional consistency | PASS | State transitions 10/12, state-machine rule 2, GD-2, exception mechanism (§2.2/§3.6), DOMAIN_MODEL A02/A09/V4/V8 — all exact. |
| 3 | Governance Freeze compliance | PASS | No frozen-text change proposed; formal-ADR and recorded-exception routes used (§3/§4). |
| 4 | Numbering | **BLOCKED** | J-01: ADR-003/ADR-004 collide with the ADR-INDEX §2.1 reservations (EC10; ADR-001 §2.1 "number never reused"). |
| 5 | Cross-ADR coupling | PASS | Independent instruments, AND-coupled at the Phase-4 gate; no contradiction. |
| 6 | Phase-4 non-authorization | PASS | Both ADRs state acceptance alone does not authorize Phase 4 (ADR-003 §11; ADR-004 §8). |
| 7 | Evidence traceability | PASS with corrections | A4-01 mis-citation (required); A3-03 prior-package divergence (reconcile at R9 record time); remainder verified. |

## 2. Required before the Board accepts/registers

1. **Numbering resolution (J-01 — REQUIRED).** The Board must decide the numbers for these two ADRs before registration. Recommended: assign the next free numbers **ADR-018** (I11 SECURITY DEFINER Governance) and **ADR-019** (EC8 Audit Chain), leaving the RC4/Phase5 reconciliation map intact (EC10 satisfied). The Board may instead re-sequence the map (R2/R3 in the review §Phase 5); any choice must be recorded in ADR-INDEX before the rows are added.
2. **ADR-004 mis-citation (A4-01 — REQUIRED).** Remove/correct the `PQ1-EC8-final-confirmation.md` citation in ADR-004 §2(3)/§3.3. That document decides a different EC-8 question (Document aggregate subscriber endpoint) and cites a non-existent `domain-model/object-model.md`. Correct the same line in `ADR-BOARD-C6-PQ1-FINAL-READINESS.md` (line 22). The traceability-chain Candidate A remains supported by `docs/constitutional-object-model.md` §2.3 line 107 and `constitutional-enforcement-architecture.md` §2/§3 (verified).

## 3. Recommended before acceptance

- **A4-02:** Reword ADR-004 §3.1/§5/§6 to describe the chain as a backward traversal (per `traverses`, `relationship-kinds.ts:61`) with an explicit hop contract — Evidence→Constraint via `is-examined-by`, Constraint→Rule via `constrains`, Decision→Evidence via the recorded provenance projection — instead of the imprecise "records/examines/constrained-by" edge list. Prevents range-incompatible engine links (RSK-02/HIGH-2 class).
- **A3-01:** Precision note in ADR-003 §2.3(1): 27 of 28 in-scope functions access RLS-protected data; `fn_current_user_id` (C6-005) is hygiene-only, included conservatively.
- **A3-02:** Anchor ADR-003 §12(5) to the precedence statement in §5(1) (recorded on acceptance); only the enforcement-level encoding is deferred.
- **A3-03:** Before creating the R9 exception record, enumerate the live Gate-0 baseline and confirm it matches the 28-function inventory (reconcile the prior-package `fn_auto_transition` divergence; it was dropped and is excluded from the authoritative final audit).
- **A3-04 / A4-03:** Map the custom sections to the binding template headings at registration (all required content is present).

## 4. What the Board must fill in (blank decision fields)

**ADR-003 (§13):** Selected (propose: C6-D + C6-C); exception scope (proposed: the 28 live functions in `C6-security-definer-inventory.csv` — Board may narrow); expiry or re-review cadence (mandatory per SPEC-EXCEPTION — currently "Not defined"); authority (proposed: ADR-003); effective date; approved by; conditions; review date.

**ADR-004 (§9):** Selected (propose: Candidate A — `Decision → Evidence → Constraint → Rule`; record Candidate B as the projection); effective date; approved by; conditions.

## 5. What acceptance closes — and what it does NOT close

If accepted, ADR-003 + ADR-004 close the two remaining **Phase-3 governance blockers**: C6 (I11 exception recording + P3–I11 conflict resolution, ADR-INDEX PQ-2) and PQ-1 (EC8 audit-chain selection, ADR-INDEX PQ-1). Acceptance is **not** Phase-4 authorization. Phase 4 begins only when, in a separate Board decision: both ADRs are accepted and registered; the R9 exception record is created with Board-fixed scope/expiry/status `Recorded`; the precedence and bypass-detection registrations exist; the C.4 governance test set is green; the later architectural review confirms closure of C1–C6 (DECISION-P3-001 §4; DECISION-P3-002 §2); and the no-change boundary is reconfirmed. GD-2 keeps the I11 gate un-bindable while I11 is Suspended (documented consequence, not a defect).

## 6. Recommended Board motion

> The Board receives the pre-board review of the proposed ADR-003 and ADR-004. It resolves the numbering question (recommended: assign ADR-018/ADR-019), requires the A4-01 mis-citation to be corrected in ADR-004 and the evidence register, and adopts the recommended precision corrections (A4-02, A3-01, A3-02, A3-03). It then fills the §13/§9 decision fields and proceeds to acceptance and registration. Phase 4 remains blocked until the separate Phase-4 authorization decision.
