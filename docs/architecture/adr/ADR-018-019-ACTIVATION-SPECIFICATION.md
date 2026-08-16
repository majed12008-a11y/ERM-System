# ADR-018/019 — Activation Specification

> Specifies the precise, verifiable meaning of "activation" for ADR-018 and ADR-019 — the post-acceptance sequence of registry records, transitions, and status updates, in dependency order, with the authority for each step.
> This specification **defines** activation; it does **not** perform it. No acceptance, no exception record, no transition, no closure, no Effective Date, no Phase 4 authorization, and no commit are performed by this document.
> It is written so that after the Board decides, every activation step is mechanical and machine-checkable.

| Field | Value |
|---|---|
| Status | SPECIFICATION — NOT EXECUTED |
| Date | 2026-08-16 |
| Authority reference | ADR-018 §2.4/§2.6; ADR-019 §2.3/§2.4; state-machine §2 transitions 2, 10, 12; ADR-001 §2.2/§2.3 |
| Applies to | ADR-018 (I11 SECURITY DEFINER Governance), ADR-019 (EC8 Audit Chain) |

---

## 1. Activation definition

**Activation** = the set of discrete, ordered, authority-annotated actions that must be executed for a PROPOSED ADR to become a binding constitutional decision and for its downstream registry/state consequences to be recorded. Until the ADR Board makes the formal decision, **no activation action is valid** (state-machine rule 6: every transition has an authority; a transition without a recorded authority is an undocumented state change and a violation).

### 1.1 Preconditions (all must hold before any activation action)

| # | Precondition | Verified |
|---|---|---|
| P-1 | ADR Board formal decision exists (APPROVE or APPROVE WITH CONDITIONS) | NOT YET — pending Board |
| P-2 | ADR-018/019 status is PROPOSED at decision time | Yes (ADR-INDEX §1) |
| P-3 | R9 `EXCEPTIONS` is empty at decision time (nothing pre-recorded) | Yes (`exception.registry.ts:37`) |
| P-4 | I11 is Violated at decision time (no transition pre-performed) | Yes (ADR-018 §2.4; R9 precedent Unrecorded) |
| P-5 | PQ-1/PQ-2 are OPEN at decision time | Yes (ADR-INDEX §3) |

## 2. Activation sequence — ADR-018

### 2.1 Step ADR18-1: Record the R9 exception (C6-C)

- **Action:** append one `ExceptionRecord` to `EXCEPTIONS` in `backend/src/governance/registries/exception.registry.ts`:
  - `targetElement: 'I11'`
  - `authority: 'ADR-018'` (this decision)
  - `scope:` the Board-fixed surface (default: the 28 enumerated live SECURITY DEFINER functions in `C6-security-definer-inventory.csv`)
  - `expiry:` the Board-fixed value/cadence
  - `status: 'Recorded'`
  - `note:` references ADR-018 and the inventory rows (C6-001..C6-030)
- **Authority:** ADR Board (D6); this ADR.
- **Verification:** `EXCEPTIONS.length === 1` with `status === 'Recorded'` and `targetElement === 'I11'`.

### 2.2 Step ADR18-2: Record the C6-D conflict-resolution interpretation

- **Action:** record that semantic ownership of RULE 12 lives in the aggregate model (DOMAIN_MODEL A02/A09) and enforcement lives in the RLS policy layer — the precedence interpretation anchored by ADR-018 §2.1(1).
- **Authority:** ADR-018 upon acceptance.
- **Verification:** ADR-018 status APPROVED; the interpretation appears in the enforcement layer work (later), not as a re-drafted constitutional text.

### 2.3 Step ADR18-3: Register the bypass-detection verification (R2/R4)

- **Action:** register the bypass-detection constraint/verification (SECURITY DEFINER functions + disabled-RLS observable) in `verification.registry.ts` (and constraint registry as applicable) with the exception carve-out applied.
- **Constraint:** this registration **must not** bind a gate (GD-2; state-machine §4 rule 2 — I11 is Suspended, not gate-bindable).
- **Verification:** verification record present; R5 `GATE_ELEMENT_ASSIGNMENTS` remains empty.

### 2.4 Step ADR18-4: Transition I11 to Suspended (state-machine transition 10)

- **Action:** record the state transition I11: Violated → Suspended (exception granted with scope and expiry).
- **Authority:** ADR Board / recorded authority (D6).
- **Consequence (documented, not a defect):** while the exception is in force, I11 is Suspended and **may not bind a gate** (GD-2; ADR-018 §4.2 negative; C6-final-decision-readiness §4).
- **On expiry:** transition 12 Suspended → Active by the authority that granted the exception.

### 2.5 Step ADR18-5: Finalize the ADR record

- **Action:** set ADR-018 status APPROVED; fill the Board Decision Template (§2.6: Selected, Effective date, Approved by, Conditions, Review date).
- **Authority:** ADR Board.
- **Verification:** ADR-018 §2.6 fully populated; no `*(blank — ADR Board decision)*` remains.

### 2.6 Step ADR18-6: Update the ADR index

- **Action:** ADR-INDEX §1 row for ADR-018 → APPROVED with Effective Date; §3 PQ-2 → closed by the Board's decision.
- **Authority:** ADR Board.
- **Verification:** ADR-INDEX §3 PQ-2 status = closed (not "proposed in ADR-018").

## 3. Activation sequence — ADR-019

### 3.1 Step ADR19-1: Confirm the chain and record the projection

- **Action:** confirm `TRACEABILITY_CHAIN` stays pinned to `['Decision','Evidence','Constraint','Rule']`; record the full enforcement chain `Rule → Constraint → Evidence → Verification → Gate → Decision` as the documented projection in the traceability model and reports.
- **Authority:** ADR-019 upon acceptance.
- **Verification:** `traceability-graph.ts` chain unchanged; projection present in traceability reports.

### 3.2 Step ADR19-2: Finalize the ADR record

- **Action:** set ADR-019 status APPROVED; fill the Board Decision Template (§2.4: Selected, Effective date, Approved by, Conditions).
- **Authority:** ADR Board.
- **Verification:** ADR-019 §2.4 fully populated.

### 3.3 Step ADR19-3: Update the ADR index

- **Action:** ADR-INDEX §1 row for ADR-019 → APPROVED with Effective Date; §3 PQ-1 → closed by the Board's decision.
- **Authority:** ADR Board.
- **Verification:** ADR-INDEX §3 PQ-1 status = closed.

## 4. Activation invariants (hold across both ADRs)

| # | Invariant | Enforcement |
|---|---|---|
| 1 | No activation action executes before the Board's formal decision | State-machine rule 6; §1.1 preconditions |
| 2 | No R9 `Recorded` exception exists before ADR-018 acceptance | R9 shape test (PREC-09 C.4 test set) |
| 3 | No I11 transition before ADR-018 acceptance | State-machine rule 6 |
| 4 | No PQ-1/PQ-2 closure before the respective ADR acceptance | ADR-INDEX §3 note |
| 5 | No Phase 4 authorization by either activation | ADR-018 §4.3; ADR-019 §4.4; PREC-01..PREC-12 |
| 6 | No frozen-text amendment during activation | ADR-018 §2.1 (C6-D, no amendment); ADR-019 §2.3(5) |
| 7 | No registry-to-runtime edge created by activation | R5 `GATE_ELEMENT_ASSIGNMENTS` stays empty; GD-4 |
| 8 | I11 stays gate-un-bindable while Suspended | GD-2; state-machine §4 rule 2 |
| 9 | Exceptions are expiring (SPEC-EXCEPTION) | Board-fixed expiry/cadence; transition 12 |

## 5. Non-activation (what must NOT be executed)

The following are **explicitly not** part of activation and must not be performed:

- Recording an R9 exception, transitioning I11, or closing PQ-1/PQ-2 **before** the Board's decision.
- Setting any Effective Date, filling any Board field, or marking any ADR APPROVED.
- Binding any gate to I11 while I11 is Violated or Suspended (GD-2).
- Modifying ADR-002 P3/I5/I11 text, object-model §2.3, or enforcement-architecture §2/§3.
- Modifying the relationship vocabulary (`relationship-kinds.ts`, `traceability-graph.ts`).
- Authorizing or beginning Phase 4 work.
- Creating, committing, tagging, or pushing any git artifact as part of activation without a separate, explicit instruction.

## 6. Verification of activation (post-acceptance checks)

After the Board approves and activation executes, the following must be mechanically checkable:

| Check | Expected | Artifact |
|---|---|---|
| R9 exception recorded | `EXCEPTIONS` has exactly one `Recorded` I11 entry with authority/scope/expiry | `exception.registry.ts` |
| I11 state | Suspended (transition 10) while exception in force; Active on expiry (transition 12) | Architecture State Registry (D7) / state-machine |
| No gate bound | R5 `GATE_ELEMENT_ASSIGNMENTS` empty | `gate-dependency.ts` GD-4 |
| Chain pinned | `TRACEABILITY_CHAIN` = Candidate A | `traceability-graph.ts` |
| ADR statuses | ADR-018/019 APPROVED with Effective Dates | ADR files + ADR-INDEX §1 |
| PQ statuses | PQ-1/PQ-2 closed by the Board's decision | ADR-INDEX §3 |
| No source change | git diff empty for source/registries (only the recorded activation edits present) | git status |

---

> SPECIFICATION ONLY. NOT EXECUTED. Awaiting the ADR Board's formal decision.
