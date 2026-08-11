# ADR-018 — I11 SECURITY DEFINER Governance

> DRAFT ONLY — NOT an accepted decision. This document proposes a decision to the ADR Board. It creates no obligation until formally accepted and registered in `docs/architecture/adr/ADR-INDEX.md` (ADR-001 §2.2, §2.3). It does not authorize Phase 4.
>
> **Numbering correction (finding J-01, review `ADR-003-004-PRE-BOARD-REVIEW.md` §Phase 5):** this decision was originally drafted as **ADR-003**. That number collides with the ADR-INDEX §2.1 informal-ADR reconciliation reservations (RC4 ADR-01 → TBD-P3 (ADR-003); ADR-001 §2.1: "A number is never reused"; Governance Freeze EC10). Resolution option **R1** assigns the next free numbers above all reservations (ADR-018/ADR-019). ADR-003 remains a historical draft with superseded numbering (see `ADR-003-I11-SECURITY-DEFINER-GOVERNANCE.md`).

| Field | Value |
|---|---|
| Number | ADR-018 |
| Title | I11 SECURITY DEFINER Governance — bounded exception mechanism for the audited SECURITY DEFINER surface, and resolution of the P3–I11 conflict |
| Status | **PROPOSED — PENDING ADR BOARD APPROVAL** |
| Date | DRAFT / TBD (drafted 2026-08-10; renumbered 2026-08-11; effective date is a Board decision, blank in §2.7) |
| Author | Drafted by the governance review from the final C6/PQ-1 audit (pre-ADR artifacts); decision authority is the ADR Board |
| Decision authority | ADR Board (D6 — Enterprise Architecture (ADR board) for constitutional decisions; ADR-INDEX §3 PQ-2) |
| Provenance | ADR-INDEX §3 PQ-2; DECISION-P3-001 C6; `architecture-constitution-stress-test.md` §2/§3; AEM §5 failures 1–2; ADR-002 §5 I11, §3 P3, §5 I5; R9 precedent `PRECEDENT-I11-SECURITY-DEFINER`; review finding J-01 (resolution R1) |
| Constraints honored | DRAFT only. Nothing in this document is implemented; no source code, SQL, database, seeds, registries (R1–R11), specifications, relationship models, or APIs are changed by this draft; ADR-INDEX §1/§3 statuses unchanged by this draft (the numbering reservation note is the correction package's own documentation); no commit or tag. |
| Purpose | Propose a bounded, recorded governance mechanism for legitimate SECURITY DEFINER usage under I11, and propose the resolution of the P3–I11 conflict (RULE 12 semantic ownership vs enforcement location). |
| Supersedes | None. No source artifact evidences that ADR-018 supersedes any prior decision. (Its own numbering supersedes the historical ADR-003 draft per J-01 R1; that is a numbering correction, not a decision supersession.) |
| Related ADRs | ADR-001 (series foundation), ADR-002 (constitution), ADR-019 (EC8 Audit Chain) |

---

## 1. Context

This ADR addresses the governance of the SECURITY DEFINER precedent and the P3–I11 conflict, both of which the ADR Board must resolve before Phase 4 (ADR-INDEX §3 PQ-2; DECISION-P3-001 C6).

### 1.1 Constitutional elements

| Element | Text | Source |
|---|---|---|
| **P3** (Principle) | Aggregate-level invariants (RULE 11, RULE 12) must be expressible in a single authoritative model, not scattered across policies and repository methods. | ADR-002 §3 |
| **I5** (Invariant) | Aggregate-level business invariants (RULE 11 terminal-state reachability; RULE 12 evidence DELETE four-factor matrix) are expressible in a single authoritative model and are assertable by verification. | ADR-002 §5 |
| **I11** (Invariant) | Schema, RLS, and data are distinct architectural concerns; no single construct may own more than one (RLS remains the sole access-control mechanism per AGENTS.md — never disabled, never bypassed). | ADR-002 §5 |
| **RULE 12** | Evidence-DELETE authorization four-factor matrix (application ownership, condition linkage, workflow state, user role), with the invariant "no DELETE after terminal state". | AGENTS.md Governance Rules; DOMAIN_MODEL A02/A09 |
| **R9** (Governance Rule) | Exception recording: an exception not recorded in the Exception Registry is a violation, regardless of intent. | constitutional-object-model §3 rule 6; enforcement-architecture §2 Exception Registry |

### 1.2 Semantic authority vs enforcement location

RULE 12 is expressed in two places that the constitution mandates without a stated precedence:

- **Semantic authority** lives in the aggregate model: DOMAIN_MODEL A02 (Condition) carries the "RULE 12 evidence-DELETE four-factor matrix"; A09 (Document) carries "RULE 12 evidence residence"; DOMAIN_MODEL V4 and §8 record that RULE 12 crosses A01/A02/A09/A18.
- **Enforcement location** lives in the RLS policy layer: `documents.documents` policies (`FOR DELETE USING (false)` on `documents` and related tables), `document_access`, `security.user_roles`.

The stress test classifies this as a genuine conflict (`architecture-constitution-stress-test.md` §2): "no precedence between a principle and an invariant; nothing detects which home an implementer chose." DOMAIN_MODEL V8 records the conflict as out of scope for that document and requiring ADR machinery. This ADR proposes the reconciliation (see §2).

### 1.3 The SECURITY DEFINER precedent

- The recorded precedent is `PRECEDENT-I11-SECURITY-DEFINER` (`backend/src/governance/registries/exception.registry.ts`): target `I11`, authority `'Unrecorded — pending ADR review (deferred, not Phase 1 work)'`, scope `'SECURITY DEFINER registration function (backend/seed/33-fix-register-rls.sql) bypasses RLS for registration only'`, expiry `'Not defined'`, status `'Unrecorded'`. The note records the PostgreSQL 18.3 Windows bug workaround (`FOR INSERT ... WITH CHECK` policies fail silently for `security.users`).
- The final audit (`docs/architecture/adr/C6-security-definer-final-audit.md`) verified that the executable surface is **30 SECURITY DEFINER functions = 28 live + 2 migration-only**, and that the recorded "registration only" scope covers **one** of them (`security.fn_register_user`, inventory id C6-015). The **uncovered live surface is 27 functions** — an order of magnitude wider than the recorded scope.

### 1.4 Why the original R9 registration-only precedent was insufficient

1. **Factually narrower than the repository.** The precedent names one function; the audited repository contains 28 live SECURITY DEFINER functions. Of these, **27 access RLS-protected data** (causal rule: a SECURITY DEFINER function executes with owner privileges, so PostgreSQL does not apply RLS to the queries it executes — see audit §2). **`system.fn_current_user_id` (C6-005) reads only the `app.user_id` GUC** — SECURITY DEFINER is unnecessary hygiene there, not an RLS bypass (audit §2 Q1); it is included in the 28 conservatively so that the exception scope is the full audited surface and the bypass-detection carve-out stays simple (finding **A3-01**, review §2.2).
2. **Unrecorded.** The precedent status is `Unrecorded`; R9 classifies any unrecorded deviation as a violation regardless of intent. The existing bypass therefore remains a standing violation (`AEM §5 failure 2`; stress test §3).
3. **No expiry, no authority.** `expiry: 'Not defined'`, authority `Unrecorded` — inconsistent with the expiring-by-design exception model (SPEC-EXCEPTION; enforcement-architecture §4 Exception stage).

### 1.5 Why C6 became a blocker

DECISION-P3-001 §3 (C6) requires a dated governance plan to record the I11 exception (R9) **and** resolve the P3–I11 conflict **before** binding any gate that gates the I11 verification. The gate-binding consequence is GD-2 / state-machine rule 2: a rule in **Violated** or **Suspended** may not bind a Gate (D5). I11 stands **Violated**; a recorded exception moves it to **Suspended** (state-machine transition 10) — still un-bindable. Therefore no gate may bind the I11 verification until the exception and the conflict resolution both exist. No ADR-018/ADR-019 existed at draft time (ADR-INDEX §1) and no dated Board commitment exists anywhere in the repository.

### 1.6 Problem statement

The exact governance problem, stated in three layers:

1. **Constitutional semantic ownership.** RULE 12 must have a single authoritative semantic home (P3, I5). That home is the aggregate model (DOMAIN_MODEL A02/A09). This is **not** in dispute — the aggregate home exists.
2. **Enforcement mechanism.** The same invariant must also be *enforced* at the row level (I11: RLS is the sole access-control mechanism — never disabled, never bypassed). Enforcement location (RLS policies) is distinct from semantic ownership (aggregate model). The problem is that the constitution does not state this distinction or a precedence rule between P3/I5 and I11.
3. **RLS / SECURITY DEFINER / exception governance.**
   - **RLS** is the sole access-control mechanism; it must never be disabled or bypassed (I11).
   - **SECURITY DEFINER** is a PostgreSQL function attribute that executes with owner privileges, bypassing RLS for the queries it runs. The audit establishes (Q1–Q6) that the attribute itself is **not** inherently a violation of I11 — only SECURITY DEFINER functions that read or write RLS-protected tables are bypasses, and only *unrecorded* deviations are violations (R9). The constitution does **not** state that SECURITY DEFINER is inherently forbidden; I11 forbids bypassing RLS and R9 forbids unrecorded deviations.
   - **Exception governance** is the only legitimate mechanism to sanction a deviation: recorded with authority, scope, and expiry (D6; constitutional-object-model §2.2: Exception suspends Rule for its duration).

The problem is that the existing bypass exists **outside** exception governance: unrecorded, unscoped to the real surface, and without expiry — while the conflict between the aggregate home and the RLS home remains unresolved.

### 1.7 Evidence

The decision inputs are the final pre-ADR audit artifacts, referenced exactly:

| Artifact | Path | Content |
|---|---|---|
| Final C6 audit | `docs/architecture/adr/C6-security-definer-final-audit.md` | Mechanical inventory (§1); I11 causal rule (§2); reconstructed violation surface = 28 live functions (§3); exception options 1–6 (§4); C6-D + C6-C sufficiency test (§5); RULE 12 semantic vs enforcement separation (§6) |
| Surface inventory | `docs/architecture/adr/C6-security-definer-inventory.csv` | 30 functions (id C6-001..C6-030), classification A/E, source, pattern |
| Decision readiness | `docs/architecture/adr/C6-final-decision-readiness.md` | Verdict evaluation: E supported (C6 + PQ-1 ready for ADR drafting) |
| Matrix reconciliation | `docs/architecture/adr/ADR-BOARD-C6-PQ1-MATRIX-RECONCILIATION.md` | Prior-package matrices reconciled; G10 (Gate-0 verification dependency) |
| Final readiness | `docs/architecture/adr/ADR-BOARD-C6-PQ1-FINAL-READINESS.md` | Board can decide without further investigation |
| Prior decision package | `docs/architecture/adr/ADR-BOARD-C6-PQ1-DECISION-PACKAGE.md` | §2 state; §3 C6 evidence; §4–§6 P3/I5/I11 and precedent analysis; §7 options; §13 recommendation |
| Option matrix | `docs/architecture/adr/ADR-BOARD-C6-PQ1-OPTION-MATRIX.csv` | Options C6-A..C6-E |
| Recommendation | `docs/architecture/adr/ADR-BOARD-C6-PQ1-RECOMMENDATION.md` | Advisory recommendation: C6-D + C6-C |

#### 1.7.1 Aggregate classification of the audited surface

| Class | Count | Details |
|---|---|---|
| A. Live executable SECURITY DEFINER functions | **28** | `system` 13 (fn_apply_audit_triggers, fn_calculate_quorum, fn_check_sla, fn_create_snapshot, fn_current_user_id, fn_generate_application_number, fn_generate_project_code, fn_init_workflow, fn_is_admin() no-arg, fn_is_admin(bigint), fn_is_committee_member_for_application, fn_log_audit, fn_notify_status_change); `security` 4 (fn_authenticate, fn_register_user, fn_reset_password, fn_verify_email); `committee` 6 (fn_cycle_created_by, fn_get_cycle_committee_id, fn_is_admin_or_cycle_creator_or_committee_admin, fn_is_assessor_for_cycle, fn_user_can_access_assessment, fn_user_can_access_cycle); `documents` 5 (fn_get_certificate_verification, fn_verify_generated_document, fn_document_transition, fn_can_view_document, fn_is_document_signer) |
| E. Migration-only | **2** | `security.fn_encrypt`, `security.fn_decrypt` (migration 002 only; not in canonical live extraction) |
| Total executable | **30** | 28 live + 2 migration-only |

Counts re-verified against the six schema dumps (27/15/15/14/14/13 occurrences). The full per-function detail is in the inventory CSV, not reproduced here.

#### 1.7.2 Live-surface reconciliation — `system.fn_auto_transition` (finding **A3-03**, review §2.5)

Prior-package artifacts enumerate `system.fn_auto_transition` as part of the SECURITY DEFINER surface (`ADR-BOARD-C6-PQ1-DECISION-PACKAGE.md` §6.2 line 171; `ADR-BOARD-C6-PQ1-EVIDENCE-REGISTER.csv` row C6EV-10). Verified for this ADR:

- `fn_auto_transition` **is** `SECURITY DEFINER` (e.g. `backend/schema_only_dump.sql:213`) and appears in 5 of the 6 schema dumps used for the surface counts.
- It was **dropped**: `archive/sql-history/39-drop-auto-transition.sql` ("broken by design"); `docs/architecture/Workflow-Implementation-Contract.md:189` marks it **REMOVED**.
- It is **not** in the canonical live extraction (`database/canonical/functions/*.sql`).

The final audit inventory (the authoritative input this ADR cites) correctly **excludes** it. Reconciliation record: the exception scope of this ADR is the **28 enumerated live functions** in `C6-security-definer-inventory.csv`; `fn_auto_transition` is historical/dropped and is **not** part of the exception surface. Before the R9 exception record is created (PREC-04), confirm the live Gate-0 baseline contains exactly the 28 enumerated functions and not `fn_auto_transition`.

#### 1.7.3 Verdict the audit supports

The audit concludes (C6-final-decision-readiness §3) that the Board can decide **now** without further investigation: the surface is complete, one exception is possible (bounded class form), no constitutional amendment is required for the proposed direction, and C6-D + C6-C satisfies C6's two required parts. GD-2 consequence (I11 stays gate-un-bindable while the exception is in force) is documented, not a defect.

---

## 2. Decision

> **PROPOSED BOARD DECISION.** This section is the proposed decision for Board approval. It is not effective. It binds nothing until the Board accepts ADR-018, the exception is recorded in R9 with the scope/expiry the Board fixes, and ADR-INDEX §3 PQ-2 is closed.

### 2.1 Proposed decision (C6-D + C6-C)

1. **Clarify semantic ownership versus enforcement location (C6-D).** ADR-018 proposes that DOMAIN_MODEL A02/A09 is the **semantic home** of RULE 12 and that RLS policies are its **enforcement expression**. Semantic ownership and enforcement location are distinct concerns; stating this distinction resolves the P3–I11 conflict **without** amending P3/I5/I11 text. The precedence interpretation proposed: where RULE 12 is concerned, the aggregate model states the invariant and the RLS layer enforces it; the two do not both *own* the invariant.

2. **Establish a bounded constitutional exception mechanism (C6-C).** ADR-018 proposes that legitimate SECURITY DEFINER usage be sanctioned by a **bounded class exception** recorded in the Exception Registry (R9) with authority = this ADR, scope fixed to the **enumerated 28-function live surface** (the Board may narrow it; the recorded "registration only" scope is factually false for the repository and is proposed for correction), expiry and re-review cadence set by the Board, and status `Recorded`. I11 is proposed to transition to **Suspended** for the exception's scope/expiry (state-machine transition 10).

The pair satisfies C6's two required parts: (a) record the exception (R9), (b) resolve the P3–I11 conflict. No constitutional amendment is proposed.

### 2.2 Exception boundary

The proposed exception is a **bounded class**, not an unlimited waiver. If accepted, the exception applies only to objects that satisfy **all** of the following objective boundaries. These are governance-level requirements only; this draft does not define implementation tables or runtime mechanisms.

| # | Boundary requirement | Objective definition |
|---|---|---|
| 1 | **Explicit object identification** | Each function in the exception scope is identified by schema + function name, as enumerated in `C6-security-definer-inventory.csv` (28 live functions). No unnamed or future function is covered. |
| 2 | **Owning domain** | Each object names its owning enforcement domain (D1–D8) and owning aggregate (A01–A25) where applicable, per the ownership rules (P2, I4). |
| 3 | **Declared purpose** | The specific governance purpose each function serves (e.g., registration single mutation path; role-bypass predicate; public verification with no session user). |
| 4 | **Security justification** | The concrete reason RLS-protected access is required, including any recorded workaround (e.g., the PostgreSQL 18.3 Windows `FOR INSERT ... WITH CHECK` silent-failure bug). |
| 5 | **RLS/authorization interaction** | For each function, the exact RLS policy, policy call site, or row it bypasses, and the compensating authorization check that still applies. |
| 6 | **Allowed data scope** | The schemas/tables each function may read or write while the exception is in force (e.g., `security.users` for registration; role/membership tables for policy predicates). |
| 7 | **Allowed operations** | The operations each function may perform (INSERT/UPDATE only on single mutation paths; READ only in policy predicates; no function may disable RLS). |
| 8 | **Evidence requirements** | The evidence each function must reference (source file path, seed file, canonical function file). |
| 9 | **Verification requirements** | The bypass-detection verification (SECURITY DEFINER + disabled-RLS observable) that must be registered (R4) with the exception carve-out applied, without binding a gate on a Suspended rule (GD-2). |
| 10 | **Expiration/review** | A fixed expiry or re-review cadence set by the Board; upon expiry the exception lapses and I11 returns to Active (state-machine transition 12) unless renewed. |
| 11 | **Owner** | A single named owner per exception record (the owning domain/authority that curates it). |
| 12 | **Approval authority** | ADR Board (D6) as the granting authority; authority recorded on the exception record. |
| 13 | **Provenance** | The exception record traces to this ADR and to the audited inventory rows (C6-001..C6-030) that establish the scope. |

Proposed scope default (subject to Board fixing): **the 28 live SECURITY DEFINER functions** in `C6-security-definer-inventory.csv`. The 2 migration-only functions (C6-029, C6-030) are proposed to be excluded from the live exception scope (they are transitional artifacts, not runtime surface). `system.fn_auto_transition` is excluded (dropped; see §1.7.2). Future SECURITY DEFINER functions are **not** covered by this exception; they require a separate Board decision (a new or amended ADR).

### 2.3 RULE 12

ADR-018 proposes to preserve, explicitly and without moving RULE 12 to another aggregate:

1. **Semantic ownership ≠ enforcement location.** RULE 12's semantic authority remains in the aggregate model (DOMAIN_MODEL A02/A09). RULE 12's enforcement remains expressed in RLS policies. Neither aggregate ownership nor enforcement authority moves.
2. **No evidence requires moving RULE 12.** The audit's RULE 12 authority analysis (C6-security-definer-final-audit §6) confirms the aggregate home (DOMAIN_MODEL V8: "The aggregate home required by P3 is now provided here") and the RLS home (I11) can coexist once the semantic/enforcement distinction is recorded.
3. **Cross-aggregate invariants** (RULE 12 crosses A01/A02/A09/A18) continue to be verified by reading across boundaries (D4), never by changing ownership.

### 2.4 I11 state

The proposed governance state transition for I11, upon formal acceptance:

| Step | State | Trigger |
|---|---|---|
| Current | **Violated** (unrecorded bypass in the accepted baseline) | stress test §3; AEM §5 failure 2; R9 precedent `Unrecorded` |
| 1 | **Board-reviewed** | ADR Board reviews this proposal (PROPOSED → decision) |
| 2 | **Exception/clarification formally recorded** | Board accepts ADR-018; exception recorded in R9 with scope/expiry, status `Recorded`; conflict resolution recorded (C6-D) |
| 3 | **Suspended** (for the exception's scope/expiry) | state-machine transition 10 (Violated → Suspended), authority = ADR Board (D6) |
| 4 | **Eligible for future verification only after required conditions** | Bypass-detection verification registered (R4) with carve-out; I11 returns to Active on expiry (transition 12) and may then bind a gate only when no longer Violated/Suspended |

This ADR does **not** claim I11 is already resolved. I11 remains Violated today; resolution is proposed, not achieved.

### 2.5 Verification requirements

The following must be verified **later** (after acceptance, as part of the enforcement architecture). This draft does **not** implement any of them.

1. **Exception record shape:** R9 `EXCEPTIONS` contains exactly one `Recorded` entry targeting I11, with non-empty authority (this ADR), scope (Board-fixed surface), and expiry; `KNOWN_PRECEDENTS` references the ADR.
2. **GD-2 invariant:** no GATE_ELEMENT_ASSIGNMENT binds a gate to the I11 verification while I11 is Violated or Suspended.
3. **Bypass-detection constraint:** a registered constraint/verification (R2/R4) detects SECURITY DEFINER functions and disabled RLS, with the exception carve-out applied — without gating on a Suspended rule.
4. **Scope conformance:** every in-scope function matches the inventory (C6-001..C6-030 classification); `system.fn_auto_transition` is absent from the live baseline; any new SECURITY DEFINER function outside the enumerated scope is detected and is a violation unless separately sanctioned.
5. **Precedence/conflict resolution record:** the semantic-vs-enforcement interpretation is **recorded by §2.1(1) of this ADR upon acceptance** and is enforced at specification/relationship level in the later enforcement work (finding **A3-02**, review §2.4 — the interpretation is anchored here, not deferred).
6. **Expiry enforcement:** the exception's expiry/review is enforceable and observable; on expiry I11 returns to Active (transition 12).

### 2.6 Board Decision Template

> Fields below are intentionally **blank** — they are the ADR Board's to fill upon acceptance. This draft does not select, date, or condition the decision.

| Field | Value |
|---|---|
| Selected | *(blank — ADR Board decision)* |
| Effective date | *(blank — ADR Board decision)* |
| Approved by | *(blank — ADR Board decision)* |
| Conditions | *(blank — ADR Board decision)* |
| Review date | *(blank — ADR Board decision)* |

---

## 3. Alternatives considered

| # | Alternative | Analysis (from evidence) | Why the proposed direction is preferred |
|---|---|---|---|
| 1 | **Amend I11** (C6-A: bounded registered-bypass carve-out in the invariant text) | Frozen-text change to ADR-002 §5; audit §4 option 5 | Not required — the semantic/enforcement distinction (C6-D) resolves the conflict without text change; keeps I11's "never bypassed" wording intact |
| 2 | **Amend P3/I5** (C6-B) | Frozen-text change to ADR-002 §3/§5 | Not required — the aggregate home already exists (DOMAIN_MODEL A02/A09); C6-D records the interpretation instead |
| 3 | **Individual exceptions** (per-object, 28 records) | Audit §4 option 2 — strong and precise but heavy registry load | Viable, but the bounded class form (option 3) is enumerable from the inventory with a fraction of the registry load |
| 4 | **Broad unrestricted exception** | Audit §4 option 1 — weakest constitutional consistency; legitimizes the exact pattern the stress test warns authorizes future workarounds | Rejected for the proposed exception, which is bounded and enumerable |
| 5 | **Infrastructure-outside-I11 treatment** | Audit §4 option 4 — requires a new classification rule and reinterpretation of I11 scope; risky since infra functions write protected data | Not proposed; classification ambiguity is a governance liability |
| 6 | **C6-D + bounded C6-C (the proposed direction)** | Audit §4 option 6 (evidence-supported hybrid); audit §5 test: **sufficient** for C6 governance closure | Smallest frozen-text change, bounded scope, recorded authority, explicit conflict resolution — the only option that satisfies both C6 parts without amendment |

No other alternatives are invented: options 1–6 are exactly the audited option matrix (C6-A..C6-E plus the hybrid).

---

## 4. Consequences

### 4.1 Positive (proposed, if accepted)

- Bounded, enumerated exception replaces an unscoped, unrecorded precedent — the bypass becomes auditable and reviewable.
- Explicit authority: every sanctioned SECURITY DEFINER function has a named owner, purpose, justification, and approval authority (ADR Board).
- Auditable governance: the exception record, its expiry, and its verification requirement are all observable (R4/R9).
- No silent SECURITY DEFINER bypass: unrecorded or out-of-scope SECURITY DEFINER functions remain violations (R9).
- P3–I11 conflict resolution without frozen-text amendment.

### 4.2 Negative (proposed, if accepted)

- Governance overhead: every in-scope function requires identification, justification, and scope data (13 boundary fields).
- Exception lifecycle: the record must be created, reviewed, renewed, and expired — recurring administrative cost.
- Future review burden: each expiry/review cycle re-opens the surface.
- Enforcement complexity: the bypass-detection verification must carry the carve-out and must not gate on a Suspended rule (GD-2).
- I11 remains gate-un-bindable while Suspended — Phase 4's I11 gate cannot bind until the exception expires or is lifted (documented consequence).

### 4.3 Phase 4 impact

**ADR-018 acceptance alone does NOT authorize Phase 4.**

If accepted, ADR-018 removes part of the constitutional ambiguity (the I11 exception recording and the P3–I11 conflict resolution) — but only once (a) the exception is recorded in R9 with the Board-fixed scope/expiry, (b) the conflict resolution is recorded, (c) the §2.5 verification requirements are registered, and (d) the later architectural review confirms closure of C1–C6 (DECISION-P3-001 §4; DECISION-P3-002 §2). Even then, GD-2 keeps the I11 gate un-bindable while I11 is Suspended. Phase 4 begins only when the Board, in a separate decision, authorizes it against all Phase-4 preconditions — never by this ADR's acceptance alone.

---

## 5. References

- `docs/architecture/adr/ADR-001-series-foundation.md` (series foundation; binding template §2.2)
- `docs/architecture/adr/ADR-002-canonical-dataset-architecture.md` (constitution — P3 §3, I5 §5, I11 §5; T3)
- `docs/architecture/adr/ADR-INDEX.md` (§3 PQ-2; §2.1 numbering reservation; EC10)
- `docs/architecture/adr/ADR-003-I11-SECURITY-DEFINER-GOVERNANCE.md` (historical draft; superseded numbering — J-01 R1)
- `docs/architecture/adr/ADR-003-004-PRE-BOARD-REVIEW.md` (findings A3-01, A3-02, A3-03, A3-04, J-01)
- `docs/architecture/adr/ADR-003-004-CURRENT-STATE-VERIFICATION.md` (pre-correction baseline)
- `docs/architecture/adr/C6-security-definer-final-audit.md` (final audit)
- `docs/architecture/adr/C6-security-definer-inventory.csv` (30-function surface)
- `docs/architecture/adr/C6-final-decision-readiness.md` (verdict E)
- `docs/architecture/adr/ADR-BOARD-C6-PQ1-FINAL-READINESS.md` (readiness)
- `docs/architecture/adr/ADR-BOARD-C6-PQ1-MATRIX-RECONCILIATION.md` (matrix reconciliation)
- `docs/architecture/adr/ADR-BOARD-C6-PQ1-DECISION-PACKAGE.md` (prior package)
- `docs/architecture/adr/ADR-BOARD-C6-PQ1-OPTION-MATRIX.csv` (options C6-A..C6-E)
- `docs/architecture/adr/ADR-BOARD-C6-PQ1-RECOMMENDATION.md` (advisory recommendation)
- `docs/constitutional-object-model.md` (§2.2 Exception; §3 rule 6)
- `docs/constitutional-enforcement-architecture.md` (D6; §4 Exception; §5 state machine; §7)
- `docs/constitutional-state-machine.md` (transitions 10, 12; rules 2–3)
- `docs/architecture-enforcement-model.md` (§5 failures 1–2; §2.2 I11)
- `docs/architecture/DOMAIN_MODEL.md` (A02/A09; V4; V8)
- `backend/src/governance/registries/exception.registry.ts` (R9 precedent)
- `backend/src/governance/registries/verification.registry.ts` (R4; I11 bypass-detection basis)
- `backend/src/governance/registries/rule.registry.ts` (R1 I11)
- `backend/src/governance/relationships/gate-dependency.ts` (GD-2)
- `archive/sql-history/39-drop-auto-transition.sql`, `docs/architecture/Workflow-Implementation-Contract.md:189`, `database/canonical/functions/*.sql` (fn_auto_transition reconciliation)

---

> DRAFT — PROPOSED BOARD DECISION. Not accepted. Not effective. Does not authorize Phase 4. Awaiting ADR Board approval.
