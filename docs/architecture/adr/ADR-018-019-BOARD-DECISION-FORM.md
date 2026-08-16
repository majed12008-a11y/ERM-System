# ADR-018/019 — Board Decision Form

> Fillable form for the ADR Board's formal decision on ADR-018 and ADR-019.
> This form is intentionally **blank** in every Board field. It is NOT a decision. It records nothing until the ADR Board fills and approves it.
> Creating this form performs no acceptance, no exception record, no transition, no closure, and no Phase 4 authorization.
> Each ADR's own Board Decision Template (ADR-018 §2.6; ADR-019 §2.4) remains the authoritative blank template; this form consolidates them for the Board's use.

| Field | Value |
|---|---|
| Form status | BLANK — FOR ADR BOARD USE ONLY |
| Date | 2026-08-16 (form prepared) |
| Prepared by | Architectural Governance Auditor (session review) |
| Decision authority | ADR Board (D6) |

---

## 1. Decision on ADR-018 — I11 SECURITY DEFINER Governance

> Draft under decision: `docs/architecture/adr/ADR-018-I11-SECURITY-DEFINER-GOVERNANCE.md` (PROPOSED — PENDING ADR BOARD APPROVAL).

### 1.1 Board selection

- [ ] **APPROVE** as written
- [ ] **APPROVE WITH CONDITIONS** (conditions in §1.4)
- [ ] **AMEND** (revisions required; returned to Proposed)
- [ ] **REJECT** (returned to Draft)

### 1.2 Scope decision (Board-fixed exception surface)

Proposed default: the **28 enumerated live SECURITY DEFINER functions** in `C6-security-definer-inventory.csv`. The Board may narrow this scope.

- [ ] Accept the proposed 28-function scope
- [ ] Narrow the scope (specify in §1.4 Conditions)
- [ ] Other: ______

### 1.3 Expiry / re-review decision

SPEC-EXCEPTION requires exceptions to be expiring, never permanent.

- [ ] Fixed expiry: date ________
- [ ] Re-review cadence: ________ (e.g., annual)
- [ ] Other: ______

### 1.4 Conditions (if APPROVE WITH CONDITIONS)

- [ ] Exception record in R9 must set: authority = this decision (ADR-018), scope = Board-fixed surface, expiry, status = `Recorded`
- [ ] I11 transition to Suspended (state-machine transition 10) with recorded authority = ADR Board (D6)
- [ ] Bypass-detection verification registered (R2/R4) with the exception carve-out, **without** gating on a Suspended rule (GD-2)
- [ ] Other conditions: ______

### 1.5 Board Decision Template (from ADR-018 §2.6 — fill on approval)

| Field | Value |
|---|---|
| Selected | *(blank — ADR Board decision)* |
| Effective date | *(blank — ADR Board decision)* |
| Approved by | *(blank — ADR Board decision)* |
| Conditions | *(blank — ADR Board decision)* |
| Review date | *(blank — ADR Board decision)* |

---

## 2. Decision on ADR-019 — EC8 Audit Chain (Traceability)

> Draft under decision: `docs/architecture/adr/ADR-019-EC8-AUDIT-CHAIN.md` (PROPOSED — PENDING ADR BOARD APPROVAL).

### 2.1 Board selection

- [ ] **APPROVE** as written
- [ ] **APPROVE WITH CONDITIONS** (conditions in §2.3)
- [ ] **AMEND** (revisions required; returned to Proposed)
- [ ] **REJECT** (returned to Draft)

### 2.2 Chain decision (PQ-1)

Proposed: canonical EC8 audit chain = `Decision → Evidence → Constraint → Rule` (**Candidate A**); the full enforcement chain (`Rule → Constraint → Evidence → Verification → Gate → Decision`) recorded as the documented projection.

- [ ] Confirm Candidate A as the canonical EC8 audit chain
- [ ] Other: ______

### 2.3 Conditions (if APPROVE WITH CONDITIONS)

- [ ] `TRACEABILITY_CHAIN` remains pinned to Candidate A
- [ ] The projection is recorded in the traceability model and reports
- [ ] EC8 two-referent distinction (document-level 6-chain exit criterion vs object-level audit chain) preserved
- [ ] Engine EC8 audit traverses Candidate A only, backward via `traverses`, per the hop-edge contract (ADR-019 §2.3(4))
- [ ] Other conditions: ______

### 2.4 Board Decision Template (from ADR-019 §2.4 — fill on approval)

| Field | Value |
|---|---|
| Selected | *(blank — ADR Board decision)* |
| Effective date | *(blank — ADR Board decision)* |
| Approved by | *(blank — ADR Board decision)* |
| Conditions | *(blank — ADR Board decision)* |

---

## 3. Post-decision action sequence (filled only after approval)

> The following sequence executes ONLY after the Board's formal decision. It is listed here so the Board sees the complete consequence of approval.

### 3.1 If ADR-018 is approved

| Step | Action | Where |
|---|---|---|
| 1 | Record the I11 exception in R9 `EXCEPTIONS` (targetElement=I11, authority=ADR-018, scope=Board-fixed, expiry, status=`Recorded`) | `exception.registry.ts` |
| 2 | Record the C6-D conflict-resolution interpretation (anchored by ADR-018 §2.1(1)) | ADR-018; later enforcement layer |
| 3 | Register the bypass-detection verification (R2/R4) with the exception carve-out; no gate binding (GD-2) | `verification.registry.ts` |
| 4 | Transition I11 to Suspended for the exception's scope/expiry (transition 10; authority = ADR Board D6) | state-machine §2 transition 10 |
| 5 | Update ADR-018 status to APPROVED; set Effective Date; fill Board fields | ADR-018 §2.6 |
| 6 | Update ADR-INDEX §1 status; close PQ-2 (Board decision) | `ADR-INDEX.md` §1/§3 |

### 3.2 If ADR-019 is approved

| Step | Action | Where |
|---|---|---|
| 1 | Confirm `TRACEABILITY_CHAIN` = Candidate A (already pinned); record the projection | `traceability-graph.ts`; traceability reports |
| 2 | Update ADR-019 status to APPROVED; set Effective Date; fill Board fields | ADR-019 §2.4 |
| 3 | Update ADR-INDEX §1 status; close PQ-1 (Board decision) | `ADR-INDEX.md` §1/§3 |

### 3.3 What approval does NOT do

- **Does NOT authorize Phase 4.** Phase 4 begins only when the Board, in a separate decision, authorizes it against all Phase-4 preconditions (ADR-018 §4.3; ADR-019 §4.4; `ADR-BOARD-C6-PQ1-PHASE4-PRECONDITIONS.csv` PREC-01..PREC-12).
- **Does NOT immediately make I11 gate-bindable.** While the exception is in force, I11 is Suspended and may not bind a gate (GD-2; state-machine §4 rule 2).
- **Does NOT change any frozen constitutional text** (ADR-002 P3/I5/I11; object-model §2.3; enforcement-architecture §2/§3).
- **Does NOT create registry-to-runtime edges** (R5 GATE_ELEMENT_ASSIGNMENTS stays empty; that binding is future work).

---

## 4. Board sign-off (blank until the Board acts)

| Field | Value |
|---|---|
| Decision date | *(blank — ADR Board decision)* |
| Approved by | *(blank — ADR Board decision)* |
| Quorum / authority reference | *(blank — ADR Board decision)* |
| Signature / record | *(blank — ADR Board decision)* |

---

> BLANK FORM. NOT A DECISION. Does not authorize Phase 4. Awaiting the ADR Board.
