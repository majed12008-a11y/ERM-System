# ADR-018/019 — Board Decision Readiness

> Governance-audit artifact. Assesses whether ADR-018 and ADR-019 are ready for the ADR Board's formal decision.
> Role of this review: **Architectural Governance Auditor**. This document records evidence and a readiness recommendation only — it does **not** decide, accept, close, or authorize anything. The decision is the ADR Board's alone.
> Does not amend the constitution; does not authorize Phase 4; does not close C6, PQ-1, or PQ-2.

| Field | Value |
|---|---|
| Status | GOVERNANCE AUDIT — READINESS ASSESSMENT |
| Date | 2026-08-16 |
| Auditor | Architectural Governance Auditor (session review, not an ADR Board) |
| Scope | ADR-018 (`ADR-018-I11-SECURITY-DEFINER-GOVERNANCE.md`), ADR-019 (`ADR-019-EC8-AUDIT-CHAIN.md`), their board-readiness evidence, and the governance-state boundaries they touch (I11, R9, PQ-1, PQ-2, C6, Phase 4) |
| Prior | RC8 correction package (commit `d60a7b6` "ADR-003/ADR"): `ADR-018-019-BOARD-SUBMISSION.md`, `ADR-018-019-PRE-BOARD-CORRECTION-REPORT.md` (verdict READY FOR BOARD REVIEW), `ADR-003-004-PRE-BOARD-REVIEW.md` (findings A3-01..A3-04, A4-01..A4-03, J-01) |

---

## 1. Overview

This assessment verifies, from repository evidence only, that ADR-018 and ADR-019 are in the state they must be in for the ADR Board to make a formal decision: numbered without collision, status PROPOSED, board decision fields blank, evidence complete, and governance consequences stated. It confirms that neither ADR claims a resolved state, and that the review left every blocked governance item (I11 Violated, R9 EXCEPTIONS empty, PQ-1/PQ-2 OPEN, Phase 4 BLOCKED) exactly as the constitution and registries record it.

## 2. Scope and objectives

### 2.1 In scope

- ADR-018 content checks (§5 of the audit directive): numbering, status, blank board fields, scope (28+2), 27/28 verification, I11 state, Suspended non-binding, GD-2.
- ADR-019 content checks (§6): EC8 chain = Decision → Evidence → Constraint → Rule, backward traversal via `traverses`, no vocabulary/relationship-model modification.
- PQ-1 (§7): identify constitutional evidence for Candidate A, where it is located, the relationship used, model conformance, and the pinning test.
- PQ-2/C6 (§8): what the Board must decide, what must be recorded in R9, effective date, I11 transition, and what must **not** be done.
- R9 (§9): examine the Exception Registry; record that `EXCEPTIONS` is empty.
- Phase 4 (§10): search for any Phase 4 authorization, gate binding, runtime enforcement, or implementation authorization.

### 2.2 Out of scope (deliberately)

- **No decision** on ADR-018 or ADR-019 is made or recommended beyond a readiness assessment.
- **No acceptance, no R9 exception record, no I11 transition, no PQ closure, no Effective Date, no Board Decision fields, no commit or tag.**
- No change to any source code, SQL, database, seeds, registries (R1–R11), specifications, relationship models, vocabulary, or API.
- No Phase 4 work and no Phase 4 authorization.

### 2.3 Constraint honored by this review

This document is itself read-only documentation. It creates no obligation, records no decision, and performs no transition. It exists to give the ADR Board a verified evidence base for the one act that remains: **the Board's formal decision**.

## 3. Readiness criteria

A PROPOSED ADR is ready for the Board's decision when all of the following hold:

| # | Criterion | Where verified |
|---|---|---|
| R-1 | Number is free, never reused (ADR-001 §2.1 "A number is never reused"; EC10) | ADR-INDEX §1/§2.1 reservations; ADR-018/019 line 5 |
| R-2 | Status is exactly `PROPOSED — PENDING ADR BOARD APPROVAL` | ADR-018 line 11; ADR-019 line 13 |
| R-3 | Date states DRAFT/TBD with the effective date **blank** | ADR-018 line 12; ADR-019 line 14; §2.6/§2.4 board templates blank |
| R-4 | All Board Decision fields are blank | ADR-018 §2.6; ADR-019 §2.4 |
| R-5 | Template-conformant (ADR-001 §2.2; `adr-template.md`: Context/Decision/Alternatives/Consequences/References) | ADR-018 §1–§5; ADR-019 §1–§5 |
| R-6 | Evidence is complete and correctly cited (no mis-cited evidence) | ADR-018 §1.7; ADR-019 §2.1 (A4-01 mis-citation removed) |
| R-7 | No claim of a resolved state that the repository does not support | ADR-018 §2.4 "I11 remains Violated today"; ADR-019 §2.3 proposed, not effective |
| R-8 | Governance consequences are stated (I11 gate un-bindable; Phase 4 not authorized) | ADR-018 §4.2/§4.3; ADR-019 §4.3/§4.4 |
| R-9 | Registered in ADR-INDEX §1 (an unregistered ADR is not part of the series, ADR-001 §2.3) | ADR-INDEX §1 rows ADR-018/ADR-019 |
| R-10 | The review introduces no fabricated artifact, no forged decision, and no unsupported claim | this assessment §4–§10, all rows carry a file/line reference |

## 4. ADR-018 readiness assessment

Checklist A–H (audit directive §5):

| # | Check | Result | Evidence |
|---|---|---|---|
| A | Numbering: next free above all reservations | PASS | ADR-018 line 5 (J-01 R1); ADR-INDEX §2.1 reservations end at ADR-010; §2.2 ends at ADR-017; ADR-018 is the next free number; ADR-001 §2.1 |
| B | Status = PROPOSED, not APPROVED/ACCEPTED | PASS | ADR-018 line 11 `PROPOSED — PENDING ADR BOARD APPROVAL`; ADR-INDEX §1 row PROPOSED |
| C | Board fields blank | PASS | ADR-018 §2.6: Selected/Effective date/Approved by/Conditions/Review date all `*(blank — ADR Board decision)*` |
| D | Scope = 28 live + 2 migration-only functions | PASS | ADR-018 §1.7.1 (28 live: system 13, security 4, committee 6, documents 5; 2 migration-only); §2.2 proposed scope; `C6-security-definer-inventory.csv` (C6-001..C6-030) |
| E | 27/28 live functions access RLS-protected data | PASS | ADR-018 §1.4(1) and §1.7.1; `C6-security-definer-final-audit.md` §2 causal rule; `C6-security-definer-inventory.csv` (27 READ/WRITE + `system.fn_current_user_id` C6-005 = NONE hygiene) |
| F | I11 state: VIOLATED, not claimed resolved | PASS | ADR-018 §2.4 "I11 remains Violated today; resolution is proposed, not achieved"; R1 `rule.registry.ts` I11 `currentClassification: 'Automatically verifiable (with documented bypass)'`; R9 precedent status `Unrecorded` |
| G | Suspended rule may not bind a gate; exception transitions documented | PASS | ADR-018 §1.5, §2.4 (transition 10 Violated→Suspended; transition 12 Suspended→Active on expiry); state-machine §2 transitions 10/12, §4 rule 2 |
| H | GD-2 honored: no gate binding on Violated/Suspended I11 | PASS | `gate-dependency.ts` GD-2 line 17; state-machine §4 rule 2; ADR-018 §2.5(2) |

ADR-018 assessment: **READY FOR BOARD DECISION** (decision content is the Board's; this verifies the proposal's readiness, not its acceptance).

## 5. ADR-019 readiness assessment

Checklist (audit directive §6):

| # | Check | Result | Evidence |
|---|---|---|---|
| A | EC8 chain = Decision → Evidence → Constraint → Rule (Candidate A) | PASS | ADR-019 §2.3(1); `constitutional-object-model.md` §2.3 line 107 `Decision → Evidence → Constraint → Rule (T3; EC8)`; `constitutional-enforcement-architecture.md` line 76 |
| B | Backward traversal via `traverses`, not `records`/`examines`/`constrained-by` | PASS | ADR-019 §2.2.1 + §2.3(4); `relationship-kinds.ts`: `records` line 50 `validTo=['Verification','Gate']` (cannot connect Decision→Evidence), `examines` line 43 forward, `constrained-by` line 34 forward, `traverses` line 61 |
| C | No vocabulary / relationship-model modification | PASS | ADR-019 line 18 constraints honored; §2.3(4) kinds retain registered ranges; no ADR-019 change to `relationship-kinds.ts`/`traceability-graph.ts` |
| D | TRACEABILITY_CHAIN pinned to Candidate A | PASS | `traceability-graph.ts` `TRACEABILITY_CHAIN = ['Decision','Evidence','Constraint','Rule']` (lines 26–31); asserted at `relationships.test.ts:384` |
| E | Status PROPOSED; board fields blank | PASS | ADR-019 line 13; §2.4 blank fields |
| F | Mis-cited evidence removed (A4-01) | PASS | ADR-019 §2.1 removed-evidence note; `PQ1-EC8-final-confirmation.md` retained only as the A4-01 record, not evidence |

ADR-019 assessment: **READY FOR BOARD DECISION** (selection content is the Board's; this verifies the proposal's readiness, not its acceptance).

## 6. I11 and R9 readiness assessment

| Item | Current state (verified) | Evidence |
|---|---|---|
| I11 classification (R1) | `Automatically verifiable (with documented bypass)` | `rule.registry.ts` I11 entry |
| I11 link state | constraint Present-Partial; evidence Present; verification Present-Partial | `rule.registry.ts` I11 entry |
| I11 verification readiness (R4) | `READY_OUTSIDE_INITIAL_SET` — bypass detection: SECURITY DEFINER functions and disabled RLS observable in the accepted baseline | `verification.registry.ts` |
| I11 governance state | **VIOLATED** (unrecorded bypass in the accepted baseline) | ADR-018 §1.3/§1.4/§2.4; R9 precedent `Unrecorded`; AEM §5 failure 2; stress test §3 |
| I11 exception transition | Not yet performed; proposed upon ADR-018 acceptance (transition 10 Violated→Suspended) | ADR-018 §2.4; state-machine §2 transition 10 |
| R9 `KNOWN_PRECEDENTS` | Exactly 1 entry: `PRECEDENT-I11-SECURITY-DEFINER`, status `Unrecorded`, authority `Unrecorded — pending ADR review (deferred, not Phase 1 work)`, scope `SECURITY DEFINER registration function`, expiry `Not defined` | `exception.registry.ts` lines 24–34 |
| R9 `EXCEPTIONS` | **Empty** (`ReadonlyArray` with zero entries) | `exception.registry.ts` line 37 |
| No new R9 record created by this review | Confirmed — `EXCEPTIONS` remains empty; this assessment records, it does not register | this document §9; `exception.registry.ts` unchanged |

Readiness: I11 and R9 are in the exact state the Board's decision must act upon. The Board decides whether to accept ADR-018 (which would then make the exception recordable and the conflict resolvable); the audit does not pre-empt that.

## 7. PQ-1 readiness assessment

| Item | Answer | Evidence |
|---|---|---|
| What is PQ-1? | Which traceability chain is authoritative for EC8 — §2.3 `Decision → Evidence → Constraint → Rule`, or §4 full chain via Verification/Gate? | ADR-INDEX §3 PQ-1; LOW-2 |
| Constitutional evidence for Candidate A | `docs/constitutional-object-model.md` §2.3 line 107: `Traceability | traverses | Relationship | Decision → Evidence → Constraint → Rule (T3; EC8)` — the only constitutional location naming the audit/traceability chain | object-model §2.3 line 107; ADR-019 §2.1(1) |
| Secondary location | `docs/constitutional-enforcement-architecture.md` §2/§3 line 76: Traceability = "the backward chain decision → evidence → constraint → rule", traversed by T3/G3/EC8 | enforcement-architecture line 76; ADR-019 §2.1(2) |
| Relationship used for the backward traversal | `traverses` (line 61) — validTo includes all chain nodes; NOT `records` (line 50, validTo=['Verification','Gate']), NOT `examines` (line 43, forward), NOT `constrained-by` (line 34, forward) | `relationship-kinds.ts`; ADR-019 §2.2.1 |
| Model conformance | The chain matches the relationship vocabulary and `DEPENDENCY_EDGE_DIRECTIONS`; no kind range is violated | ADR-019 §4.1; `relationships.test.ts` |
| Pinning test | `relationships.test.ts:384` asserts `TRACEABILITY_CHAIN` equals `['Decision','Evidence','Constraint','Rule']` | `relationships.test.ts:384`; `traceability-graph.ts` lines 26–31 |
| PQ-1 status | **OPEN** — ADR-019 records the proposed decision; it does not close the question. Only the Board's formal decision closes it | ADR-INDEX §3 (note under table) |

PQ-1 determination: the constitutional evidence for Candidate A is explicit and singular; ADR-019 correctly captures it. The question is **ready for Board decision**; it remains **OPEN** until the Board decides.

## 8. PQ-2 / C6 readiness assessment

### 8.1 What the Board must decide (for ADR-018)

| # | Board decision element | Referenced by |
|---|---|---|
| 1 | Accept or reject the C6-D + C6-C pair (semantic/enforcement distinction + bounded class exception) | ADR-018 §2.1 |
| 2 | Fix the exception scope (proposed default: the 28 enumerated live functions; Board may narrow) | ADR-018 §2.2 |
| 3 | Fix the expiry / re-review cadence (SPEC-EXCEPTION: exceptions are expiring) | ADR-018 §2.2 boundary 10 |
| 4 | Fix the Effective Date (blank today) | ADR-018 §2.6 |
| 5 | State conditions and review date | ADR-018 §2.6 |

### 8.2 What must be recorded after acceptance (NOT before)

| Step | Record | Registry/document |
|---|---|---|
| 1 | Exception record in R9: targetElement=I11, authority=ADR-018, scope=Board-fixed surface, expiry, status=`Recorded` | `exception.registry.ts` `EXCEPTIONS` |
| 2 | Conflict-resolution record (C6-D interpretation anchored by ADR-018 §2.1(1)) | ADR-018 (upon acceptance); enforcement layer later |
| 3 | Bypass-detection verification registered with carve-out (R2/R4), **without** gating on a Suspended rule | `verification.registry.ts` / constraint registry |
| 4 | I11 transition to Suspended (transition 10) with recorded authority = ADR Board (D6) | state-machine §2 transition 10 |
| 5 | ADR-INDEX §3 PQ-2 status updated to closed by the Board's decision | ADR-INDEX §3 |

### 8.3 What must NOT be done

- **No exception record before acceptance** — R9 `EXCEPTIONS` stays empty (this review verified it did not change).
- **No I11 transition before acceptance** — I11 stays Violated.
- **No Effective Date** — blank until the Board fills it.
- **No Phase 4 authorization by ADR-018 acceptance alone** — ADR-018 §4.3; Phase 4 requires a separate Board decision against all preconditions.

## 9. R9 exception-registry examination

| Field | Verified value | Evidence |
|---|---|---|
| `KNOWN_PRECEDENTS` | 1 entry — `PRECEDENT-I11-SECURITY-DEFINER` (target I11; authority "Unrecorded — pending ADR review (deferred, not Phase 1 work)"; scope "SECURITY DEFINER registration function (backend/seed/33-fix-register-rls.sql) bypasses RLS for registration only"; expiry "Not defined"; status `Unrecorded`) | `exception.registry.ts` lines 24–34 |
| `EXCEPTIONS` | **empty** — no recorded exceptions exist in the registry | `exception.registry.ts` line 37 |
| Registry owner/authority | D6 (recorded authority); references enforcement-architecture §2, enforcement-domains D6, seed 33 | `exception.registry.ts` lines 41–47 |
| Any recorded exception status | n/a — no records exist; the only precedent is `Unrecorded` | `exception.registry.ts` |

R9 examination result: the registry is **empty of exceptions** with exactly one **Unrecorded** precedent. This review created no record. Any `Recorded` entry can only appear after the Board's formal ADR decision (PREC-02/PREC-05/PREC-11 in `ADR-BOARD-C6-PQ1-PHASE4-PRECONDITIONS.csv`).

## 10. Phase 4 readiness assessment

| Search | Result |
|---|---|
| Any Phase 4 authorization anywhere in the repository | **NONE found** |
| Any gate binding a rule in Violated/Suspended (R5 GATE_ELEMENT_ASSIGNMENTS) | **0 assignments** (`gate-dependency.ts` GD-4; GATE_DEPENDENCY_MODEL status) |
| Any runtime enforcement or implementation authorization in ADR-018/019 | **NONE** — both ADRs state "DRAFT ONLY — NOT an accepted decision... does not authorize Phase 4" (ADR-018 line 3; ADR-019 line 3) |
| Any implementation authorization in this review | **NONE** — this assessment is read-only documentation |
| Phase 4 state | **BLOCKED** — pending the Board's formal decisions on ADR-018/019 and the separate Phase 4 authorization decision |

Phase 4 determination: **BLOCKED**. Nothing in this package, the ADR drafts, or this review changes that. Phase 4 begins only when the Board, in a separate decision, authorizes it against all Phase-4 preconditions (`ADR-BOARD-C6-PQ1-PHASE4-PRECONDITIONS.csv` PREC-01..PREC-12).

## 11. Boundary of the review

1. This review is an **audit**, not a decision. It produces evidence and a readiness assessment.
2. It **does not** accept ADR-018/019, record an R9 exception, transition I11, close PQ-1/PQ-2/C6, set an Effective Date, fill Board fields, authorize Phase 4, or create any registry-to-runtime edge.
3. It **does not** modify any source artifact (code, SQL, seeds, registries, specs, relationship models, vocabulary, APIs). Working-tree source modifications present at review time are the user's prior workflow changes and are outside this audit's scope.
4. It **does not** commit, tag, or push anything.
5. It preserves the historical ADR-003/ADR-004 drafts and the pre-correction baseline exactly as recorded (`ADR-003-004-CURRENT-STATE-VERIFICATION.md`).

## 12. Evidence register

| ID | Evidence | Path:line | Used for |
|---|---|---|---|
| EV-01 | ADR-018 numbering correction (J-01 R1), status PROPOSED, blank board template | `ADR-018-I11-SECURITY-DEFINER-GOVERNANCE.md:5,11,12,182-192` | ADR-018 checks A/B/C |
| EV-02 | 30-function surface = 28 live + 2 migration-only; aggregate classification | `C6-security-definer-inventory.csv`; `C6-security-definer-final-audit.md` §1/§3; ADR-018 §1.7.1 | ADR-018 check D |
| EV-03 | 27/28 live functions access RLS-protected data; `fn_current_user_id` (C6-005) NONE hygiene | `C6-security-definer-inventory.csv`; ADR-018 §1.4(1) | ADR-018 check E |
| EV-04 | I11 Violated; precedent Unrecorded; no claimed resolution | `rule.registry.ts` I11; `exception.registry.ts`; ADR-018 §2.4 | ADR-018 check F |
| EV-05 | Transition 10 (Violated→Suspended) and 12 (Suspended→Active); rule 2 no gate on breach | `constitutional-state-machine.md:42,44,100` | ADR-018 check G; §6 |
| EV-06 | GD-2 = "No gate on a breach: a rule in Violated or Suspended may not bind a gate" | `gate-dependency.ts:17` | ADR-018 check H |
| EV-07 | EC8 chain explicit at the only constitutional location naming it | `constitutional-object-model.md:107` | ADR-019 check A; §7 |
| EV-08 | Traceability = backward chain decision→evidence→constraint→rule (T3/G3/EC8) | `constitutional-enforcement-architecture.md:76` | ADR-019 check A; §7 |
| EV-09 | `records` line 50 validTo=['Verification','Gate']; `examines` line 43 forward; `constrained-by` line 34 forward; `traverses` line 61 | `relationship-kinds.ts:34,43,50,61` | ADR-019 check B |
| EV-10 | TRACEABILITY_CHAIN = ['Decision','Evidence','Constraint','Rule'] | `traceability-graph.ts:26-31` | ADR-019 check D; §7 |
| EV-11 | Chain assertion test | `relationships.test.ts:384` | ADR-019 check D; §7 |
| EV-12 | R9 EXCEPTIONS empty; one Unrecorded precedent | `exception.registry.ts:24-37` | §6; §9 |
| EV-13 | ADR-INDEX rows PROPOSED; PQ-1/PQ-2 OPEN | `ADR-INDEX.md:13,14,52,53,55` | Readiness criteria R-9; §7/§8 |
| EV-14 | Phase 4 BLOCKED; 0 gate assignments; ADRs do not authorize Phase 4 | `gate-dependency.ts:19,37`; ADR-018:3; ADR-019:3; `ADR-BOARD-C6-PQ1-PHASE4-PRECONDITIONS.csv` | §10 |

## 13. Risk assessment

| Risk | Likelihood | Impact | Mitigation (present in the package) |
|---|---|---|---|
| A claim that ADR-018 acceptance resolves I11 immediately | Low | High (false resolution claim) | ADR-018 §2.4 explicitly: "I11 remains Violated today; resolution is proposed, not achieved"; I11 stays Suspended and gate-un-bindable while the exception is in force (GD-2) |
| A claim that acceptance authorizes Phase 4 | Low | High (scope breach) | ADR-018 §4.3 and ADR-019 §4.4 explicitly deny this; PREC-01..PREC-12 must be satisfied |
| Evidence mis-citation in ADR-019 | Resolved (A4-01) | Medium | `PQ1-EC8-final-confirmation.md` removed from evidence and labeled as unrelated historical evidence |
| Registry drift (an R9 record appearing before acceptance) | Low | Medium | This review verifies `EXCEPTIONS` remains empty; §9 records the expected post-acceptance sequence |
| Numbering reuse or collision | None | High | ADR-018/019 above all reservations (ADR-001 §2.1); ADR-003/004 remain historical drafts |

## 14. Recommendation

**Recommendation (audit only — the Board decides):** ADR-018 and ADR-019 are **ready for the ADR Board's formal decision**. The evidence base is complete, the drafts are template-conformant and correctly numbered, board fields are blank, no state is falsely claimed resolved, and every downstream governance consequence (I11 Suspended + gate-un-bindable while the exception is in force; Phase 4 remains BLOCKED; R9/PQ-1/PQ-2 close only by the Board's decision) is stated in the drafts themselves.

The Board's remaining work is the decision itself — accepting, amending, or rejecting — and, upon acceptance, executing the recorded sequence in §8.2.

## 15. References

- `docs/architecture/adr/ADR-018-I11-SECURITY-DEFINER-GOVERNANCE.md` (PROPOSED)
- `docs/architecture/adr/ADR-019-EC8-AUDIT-CHAIN.md` (PROPOSED)
- `docs/architecture/adr/ADR-INDEX.md` (§1, §2.1, §3)
- `docs/architecture/adr/ADR-003-004-PRE-BOARD-REVIEW.md` (findings A3-01..A3-04, A4-01..A4-03, J-01)
- `docs/architecture/adr/ADR-003-004-CURRENT-STATE-VERIFICATION.md` (pre-correction baseline)
- `docs/architecture/adr/C6-security-definer-final-audit.md`, `C6-security-definer-inventory.csv`, `C6-final-decision-readiness.md`
- `docs/architecture/adr/ADR-BOARD-C6-PQ1-FINAL-READINESS.md`, `ADR-BOARD-C6-PQ1-PHASE4-PRECONDITIONS.csv`
- `docs/constitutional-object-model.md` (§2.3 line 107)
- `docs/constitutional-enforcement-architecture.md` (§2/§3 line 76)
- `docs/constitutional-state-machine.md` (transitions 10, 12; §4 rule 2)
- `docs/templates/adr-template.md`
- `backend/src/governance/registries/exception.registry.ts` (R9), `rule.registry.ts` (R1), `verification.registry.ts` (R4)
- `backend/src/governance/relationships/gate-dependency.ts` (GD-2), `relationship-kinds.ts`, `traceability-graph.ts`, `__tests__/relationships.test.ts`

---

> GOVERNANCE AUDIT — READINESS ASSESSMENT ONLY. No decision, no acceptance, no exception record, no transition, no closure, no Effective Date, no Phase 4 authorization, no commit.
