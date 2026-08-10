# ADR Board Decision Package — C6 (I11 / SECURITY DEFINER) + PQ-1 (EC8 Audit Chain)

| Field | Value |
|---|---|
| Package | ADR Board Decision Package for the two remaining Phase-3 governance blockers: **C6** and **PQ-1** |
| Date | 2026-08-10 |
| Author | Governance review (prepared for the ADR board) |
| This package | Documentation only. Prepares the formal ADR-board decisions. **Not** an ADR; does **not** amend the constitution; does **not** authorize Phase 4. |
| Authority chain | ADR-002 (constitution) > ADR-001 (series foundation) > registered ADRs (closure decision §4 precedence rule); ADR-INDEX §3 (pending ADR-board questions PQ-1, PQ-2) |
| Binding template | `docs/templates/adr-template.md` (ADR-001 §2.2) — any ADR resulting from this package must follow it and be registered in ADR-INDEX |
| Status | **OPEN — Phase 4 remains BLOCKED pending the formal ADR-board decisions requested in §12.** |
| Final status line | C6 + PQ-1 Decision Package complete. Phase 4 remains BLOCKED pending formal ADR Board decisions. |
| Companions | `ADR-BOARD-C6-PQ1-OPTION-MATRIX.csv`; `ADR-BOARD-C6-PQ1-EVIDENCE-REGISTER.csv`; `ADR-BOARD-C6-PQ1-PHASE4-PRECONDITIONS.csv`; `ADR-BOARD-C6-PQ1-RECOMMENDATION.md`; `docs/architecture/registry/c6-pq1-governance-analysis.md`; `c6-pq1-risk-register.csv`; `c6-pq1-review-decision.md` |

---

## §1 — Purpose and Scope

**CONSTITUTIONAL REQUIREMENT.** This package exists so the ADR board can issue the two formal ADRs (ADR-003+) required by ADR-INDEX §3 (PQ-1, PQ-2) to close the two remaining Phase-3 blockers before any Phase-4 (enforcement-engine) work. The package:

1. **Establishes the current constitutional state** (§2) as verified from the repository.
2. **Sets out C6 evidence** (§3–§6): the I11 SECURITY DEFINER precedent and the P3–I11 conflict.
3. **Sets out PQ-1 evidence** (§8–§9): the EC8 audit-chain selection.
4. **Analyzes the C6/PQ-1 relationship** (§10) and the Phase-4 authorization conditions (§11).
5. **Requests the decisions** (§12) using the board decision templates; **Selected option** and **Effective date** are intentionally blank — they are the board's, not the package's.
6. **Recommends** (§13) but does not decide; **surfaces unresolved matters** (§14); and **confirms the no-change boundary** (§15).

**Scope boundary (CONSTITUTIONAL REQUIREMENT, Governance Freeze §3/§4):** this package changes nothing frozen. It is documentation only — no runtime code, SQL, database, seeds, registries (R1–R11), specifications, relationship models, APIs, tests, commits, or tags. Phase 4 work remains prohibited (DECISION-P3-001 §4; DECISION-P3-002 §2).

---

## §2 — Current Constitutional State

### 2.1 Authority chain (CONSTITUTIONAL REQUIREMENT)

| Level | Instrument | Status |
|---|---|---|
| Constitution | ADR-002 (Canonical Dataset Architecture; P1–P9, I1–I11, G1–G13, EC1–EC10) | APPROVED 2026-08-06; frozen (Governance Freeze §1) |
| Series foundation | ADR-001 (numbering policy; binding template; ADR index; terminology) | APPROVED 2026-08-07 |
| Index | ADR-INDEX (§2 reconciliation map; §3 pending questions PQ-1, PQ-2) | Current |
| Change control | `architecture-governance-freeze.md` §3/§4 — any change to a frozen element is a formal ADR | In effect |
| Precedence rule | `architecture-closure-decision.md` §4: ADR-002 > ADR-001 > registered ADRs | Binding |

### 2.2 Baseline state relevant to this package (REPOSITORY FACT, Phase 1/2/3 baselines)

| Baseline | Value | Source |
|---|---|---|
| Constitutional elements | 43 (P1–P9, I1–I11, G1–G13, EC1–EC10) | R1; `constitution-enforcement-matrix.csv` (43 rows) |
| Constraints present | 12/43 (I1, I11, EC1–EC10); gap 31 | R2; `enforcement-gap-register.csv` |
| Evidence | 13/43 | R3 |
| Verification | 11/43, all `NotRegistered`; EC8 `NeedsExtension` | R4; `verification.registry.ts` |
| Gates | 5 gates (GATE-01..05), 0 bindings, empty `requiredVerification`, empty `GATE_ELEMENT_ASSIGNMENTS` | R5; `gate.registry.ts`; GD-4 |
| Decisions | 0/43 (`DECISIONS` empty) | R6; `decision.registry.ts` |
| Exceptions | 1 unrecorded precedent (I11 SECURITY DEFINER); `EXCEPTIONS` empty | R9; `exception.registry.ts` |
| I11 state | **Violated** (unrecorded bypass in accepted baseline) | stress test §3; AEM §5 failure 2; R1 I11 `Present-Partial` |
| I11 classification | `Automatically verifiable (with documented bypass)` | R1 |

### 2.3 The two pending ADR-board questions (CONSTITUTIONAL REQUIREMENT, ADR-INDEX §3)

| PQ | Question | Required decision | Status |
|---|---|---|---|
| PQ-1 | Which traceability chain is authoritative for EC8: §2.3 chain `Decision → Evidence → Constraint → Rule`, or the §4 full chain via Verification/Gate? | Select one chain; record the other as a projection | **OPEN** |
| PQ-2 | When will the ADR board record the I11 SECURITY DEFINER exception (formal ADR with dated commitment) and resolve the P3–I11 conflict? | Formal ADR committing to the exception and conflict resolution | **OPEN** |

---

## §3 — C6 Evidence

### 3.1 What C6 is (CONSTITUTIONAL REQUIREMENT, DECISION-P3-001 §3)

> **C6 —** Commit to a dated governance plan to record the I11 exception (R9) and resolve the P3–I11 conflict **before** binding any gate that gates the I11 verification (GD-2). This is the program's dominant risk and is a governance item, not a code item. *(HIGH — OBS-1)*

### 3.2 Confirmed status (REPOSITORY FACT)

- `backend/src/governance/registries/exception.registry.ts`: `KNOWN_PRECEDENTS` contains exactly one entry — `PRECEDENT-I11-SECURITY-DEFINER` with `targetElement: 'I11'`, authority `'Unrecorded — pending ADR review (deferred, not Phase 1 work)'`, scope `'SECURITY DEFINER registration function (backend/seed/33-fix-register-rls.sql) bypasses RLS for registration only'`, `expiry: 'Not defined'`, `status: 'Unrecorded'`, note recording the PostgreSQL 18.3 Windows bug workaround. `EXCEPTIONS` is empty (`[]`).
- **No ADR-003+ exists** in ADR-INDEX (formal series lists ADR-001, ADR-002 only; ADR-003+ reserved).
- **No dated ADR-board commitment exists anywhere** (grep clean across repo).
- P3–I11 conflict unresolved: DOMAIN_MODEL.md V8 declares it out of scope for that document; `constitutional-enforcement-architecture.md` §7 condition 2 records the amendment as pending.

### 3.3 Legal classification of the precedent (INTERPRETATION, from `c6-pq1-governance-analysis.md` A.6)

The SECURITY DEFINER precedent is, simultaneously:
- **(c) a historical implementation defect** — a documented workaround for a PostgreSQL 18.3 Windows bug (`FOR INSERT ... WITH CHECK` policies fail silently), accepted into the baseline as a sanctioned fix;
- **(b) a deviation from a frozen invariant** — the constitution classifies any unrecorded deviation as a violation regardless of intent (R9; object-model §3 rule 6; enforcement-architecture §2 Exception Registry), so its continued legitimacy requires a **constitutional exception** (R9);
- **(a) distinct from but packaged with the P3–I11 architectural contradiction** (the bypass is a violation of I11; the conflict is a contradiction between P3/I5 and I11);
- **(d) evidence of a governance gap** — no exception was recorded when the fix was accepted, and there is no bypass-detection verification (AEM §5 failure 2: Missing verification + Missing governance).

### 3.4 Gate-binding consequence (CONSTITUTIONAL REQUIREMENT)

**GD-2** (`backend/src/governance/relationships/gate-dependency.ts`): *"No gate on a breach: a rule in Violated or Suspended may not bind a gate (state-machine §4.2)."* State-machine rule 2 (constitutional-state-machine §4): a rule in **Violated** or **Suspended** may not bind a Gate (D5). I11 stands **Violated** today; a recorded exception moves it to **Suspended** (transition 10) — still un-bindable. Therefore **no gate may bind the I11 verification until C6 closes**, regardless of readiness (I11 is rated `Ready` in R4/§6.1 — readiness is specifiability, not authorization).

---

## §4 — P3 / I5 / I11 Relationship Analysis

### 4.1 The constitutional texts (CONSTITUTIONAL REQUIREMENT, ADR-002)

| Element | Text |
|---|---|
| **P3** (Principle, §3) | **Aggregate ownership.** Aggregate-level invariants (RULE 11, RULE 12) must be expressible in a single authoritative model, not scattered across policies and repository methods. |
| **I5** (Invariant, §5) | Aggregate-level business invariants (RULE 11 terminal-state reachability; RULE 12 evidence DELETE four-factor matrix) are expressible in a single authoritative model and are assertable by verification. |
| **I11** (Invariant, §5) | Schema, RLS, and data are distinct architectural concerns; no single construct may own more than one (RLS remains the sole access-control mechanism per AGENTS.md — never disabled, never bypassed). |

### 4.2 RULE 12's two mandated homes (CONSTITUTIONAL REQUIREMENT + INTERPRETATION)

RULE 12 (evidence-DELETE four-factor matrix) is mandated into two homes with **no reconciliation and no precedence rule**:

| Home | Mandated by | Status |
|---|---|---|
| **Single authoritative aggregate model** | P3, I5, Governance Freeze §1, ADR-002 C5 | **Provided** — DOMAIN_MODEL.md: A02 Condition aggregate carries the "RULE 12 evidence-DELETE four-factor matrix"; A09 Document carries "RULE 12 evidence residence"; V4 (RULE 12 crosses A01/A02/A09/A18); R2 (constraint per aggregate invariant). DOMAIN_MODEL §8: I5 "satisfiable". |
| **RLS policy layer** | I11 (RLS sole access-control; RULE 12 IS an access-control decision) | **Remains** — expressed in RLS policy `WHERE` clauses (`documents.documents` policies, `FOR DELETE USING (false)`, `document_access`, `security.user_roles`). |

**Stress-test ruling** (`architecture-constitution-stress-test.md` §2, cross-principle conflict): **"Genuine conflict."** The constitution mandates two homes for the same invariant and does not reconcile them; "no precedence between a principle and an invariant; nothing detects which home an implementer chose."

**DOMAIN_MODEL V8** (§6): *"Constitutional conflicts (not model violations): P3 vs I11 conflict ... Out of scope for this document; require ADR amendment via the enforcement architecture machinery. The aggregate home required by P3 is now provided here; the RLS home remains per I11."*

**Conclusion (INTERPRETATION):** RULE 12's aggregate home is satisfied; its RLS home remains mandated by I11; **the conflict is not resolved anywhere in the current constitution.**

### 4.3 What the amendment question actually is

- **I11 text need not change** if the exception route is used — but enforcement-architecture §7 condition 2 states the I11 bypass "require[s] constitutional amendment," and AEM §8 lists "the removal of the I11 bypass precedent" as a prerequisite; the stress test requires the reconciliation. C6's wording requires the ADR-board commitment covering **both** the exception **and** the conflict resolution.
- **The minimum** to resolve the conflict is **one amending ADR that reconciles the two homes and states the precedence** between P3/I5 and I11 for access-control matrices (§13 recommends an option).
- An **exception alone is insufficient** for Phase 4: it cannot reconcile two frozen rules, and a Suspended I11 still cannot bind a gate (GD-2).

---

## §5 — RULE 12 Authority Analysis

### 5.1 Where RULE 12 currently lives (REPOSITORY FACT)

- **Business-rule definitions:** `docs/architecture/RULE_12-Evidence-Delete-Authorization.md` (four-factor matrix; seven scenarios) and the RULE_* business-rules framework.
- **Aggregate model:** DOMAIN_MODEL.md A02 / A09 (authoritative model home; §1.1 Policies; V4).
- **RLS policies:** `documents.documents` policies with `FOR DELETE USING (false)` on both `documents` and related tables; `document_access`; `security.user_roles`; the evidence-DELETE matrix is applied in policy `WHERE` clauses.
- **Repositories:** RULE 12 checks also appear in service/repository logic (historical scattering P3 forbids).

### 5.2 Ownership determination (INTERPRETATION)

- The aggregate home's owner is the **Application/Condition aggregate** (P3; DOMAIN_MODEL).
- The RLS home's owner is the **I11 access-control layer** (per AGENTS.md: "RLS is the sole access control mechanism — never disable, never bypass").
- **RULE 12 authorization for evidence DELETE must be derived from the parent workflow entity** (Condition/Application), not from document ownership alone — the four-factor matrix: application ownership, condition ownership, workflow state, user role. This is the substance the board's precedence rule must govern.

### 5.3 What the board must resolve

The board must state, in the amending ADR, **how an access-control matrix can be simultaneously expressed in one authoritative model and in row-level policies** — either (a) model as the semantic home and RLS policies as its enforcement expression (requires no I11 text change; scopes P3/I5 to the model), or (b) model and policies as co-authoritative with an explicit precedence rule (requires I11/P3 text amendment), or (c) another reconciliation the board selects. The options are analyzed in `ADR-BOARD-C6-PQ1-OPTION-MATRIX.csv`.

---

## §6 — SECURITY DEFINER Precedent Analysis

### 6.1 The recorded precedent (REPOSITORY FACT)

- **Instrument:** `backend/seed/33-fix-register-rls.sql` — `SECURITY DEFINER` function `security.fn_register_user(...)` bypasses RLS for registration only.
- **Justification (recorded):** PostgreSQL 18.3 Windows bug — `FOR INSERT ... WITH CHECK` policies fail silently for `security.users`; SECURITY DEFINER is the accepted workaround (AGENTS.md "RLS fixes applied §1"; R9 note).
- **Caller in repo:** `backend/src/repositories/users.repository.ts` (create() at lines 102–129) calls `security.fn_register_user($1..$10)`; comment cites `backend/seed/33-fix-register-rls.sql`.

### 6.2 New repository fact — the bypass is broader than the single recorded precedent (REPOSITORY FACT)

The precedent registered in R9 names **only** the registration function. A repository-wide scan of SECURITY DEFINER shows the bypass surface is far wider:

| Schema file | SECURITY DEFINER occurrences |
|---|---|
| `schema_only_dump.sql` (repo root) | **27** |
| `ethics_db_schema.sql` | **15** |
| `ethics_db_tables_constraints.sql` | **15** |
| `scripts/db-schema-tables.sql` | **14** |
| `scripts/db-schema-full.sql` | **14** |
| `backend/schema_only_dump.sql` | **13** |

Functions observed (from `schema_only_dump.sql` and `ethics_db_schema.sql`):
- **security.*** — `fn_authenticate`, `fn_register_user`, `fn_reset_password`, `fn_verify_email`
- **system.*** — `fn_apply_audit_triggers`, `fn_auto_transition`, `fn_calculate_quorum`, `fn_check_sla`, `fn_create_snapshot`, `fn_current_user_id`, `fn_generate_application_number`, `fn_generate_project_code`, `fn_init_workflow`, `fn_is_admin`, `fn_is_committee_member_for_application`, `fn_log_audit`, `fn_notify_status_change`
- **committee.*** — `fn_cycle_created_by`, `fn_get_cycle_committee_id`, `fn_is_admin_or_cycle_creator_or_committee_admin`, `fn_is_assessor_for_cycle`, `fn_user_can_access_assessment`, `fn_user_can_access_cycle`
- **documents.*** — `fn_get_certificate_verification`

**Repo callers beyond the register precedent:** `backend/src/repositories/auth.repository.ts` (line 11, `security.fn_authenticate`); `backend/src/repositories/consent-review.repository.ts` (line 45, `system.fn_is_admin`); `docs/architecture/phase3-certificate-subsystem.md` (§13/§22: `47-public-verify-function.sql` SECURITY DEFINER public-verify function; `documents.fn_get_certificate_verification`).

**INTERPRETATION (consequence):** the I11 bypass precedent is **not limited to registration**. The board's exception must either (a) scope precisely to the enumerated functions, or (b) define a general, bounded carve-out policy for SECURITY DEFINER functions with a detection/registration requirement. The recorded R9 precedent's scope ("registration only") is **factually narrower than the repository state**. This widens the C6 decision and must be reflected in the exception scope and in the bypass-detection verification (R4 `READY_OUTSIDE_INITIAL_SET` — I11 basis: "Bypass detection: SECURITY DEFINER functions and disabled RLS observable in the accepted baseline").

### 6.3 Verification gap (REPOSITORY FACT)

- R4: I11 verification link `Present-Partial` ("DB enforces RLS; bypass detection mapped"); I11 listed in `READY_OUTSIDE_INITIAL_SET` with bypass-detection basis.
- AEM §5 failure 2: cause = **Missing verification** (no bypass detection) + **Missing governance** (no exception control).
- AEM §4: I11 is the sole L3 element (2.3%); "the one automatically enforced element (I11) is already violated in the accepted baseline."

---

## §7 — C6 Options

Evaluated in detail in `ADR-BOARD-C6-PQ1-OPTION-MATRIX.csv` (rows C6-A .. C6-E). Summary (all are RECOMMENDATION-level analyses for the board; none is decided):

| Option | Proposal | Constitutional impact | Needs amendment | Needs exception |
|---|---|---|---|---|
| **C6-A** | Amend I11 (e.g., a bounded, registered-bypass carve-out for enumerated SECURITY DEFINER functions) | I11 text changes | Yes (ADR-002 §5) | Possibly (transitional) |
| **C6-B** | Amend P3/I5 (scope the single-authoritative-model home; declare RLS policies the enforcement expression) | P3/I5 text changes | Yes (ADR-002 §3/§5) | No (but exception still needed for the existing bypass) |
| **C6-C** | Formal constitutional exception for the SECURITY DEFINER precedent (recorded in R9 with scope/authority/expiry) without amending I11 text | I11 → Suspended for the exception's scope/expiry | No | **Yes** |
| **C6-D** | Clarify semantic ownership vs enforcement location — the aggregate model owns the *semantics*; RLS policies *enforce* it; no genuine conflict remains | No text change; ADR records the interpretation | No | Yes (still needed for the bypass) |
| **C6-E** | Any evidence-supported option the board selects | As per board choice | As applicable | As applicable |

**REPOSITORY FACT relevant to C6-A:** the precedence must be stated between P3/I5 and I11 for access-control matrices (AEM §5 failure 1: Missing governance + Missing rule). **INTERPRETATION:** C6-C alone keeps I11 un-bindable (Suspended); C6-B/D without C6-C leaves the existing bypass a standing violation. The recommendation (§13) combines an option: **C6-D + C6-C** — interpret the model as semantic home (no P3/I5 text change), grant a scoped exception for the enumerated SECURITY DEFINER functions, and require bypass detection — subject to board approval.

---

## §8 — PQ-1 Evidence

### 8.1 The two EC8 referents — must not be conflated (CONSTITUTIONAL REQUIREMENT + INTERPRETATION)

| Referent | Meaning | Source |
|---|---|---|
| **1. Exit criterion EC8 (document-level)** | "All 6 traceability chains re-verified with 0 broken" — six document chains (Problem → Finding → Root Cause → ADR Principle → Affected Documents) | `architecture-transition-plan.md` §9 (line 327); AEM §2.4; `architecture-baseline-consolidation-review.md` §5 (5 of 6 broken; chain 4 intact) |
| **2. EC8 audit chain (object-level)** | The decision-trace chain the future engine audits | object-model §2.3 label; Phase-3 meaning |

**PQ-1 resolves referent 2.** Referent 1 is a separate verification scope (R4: EC8 `NeedsExtension` — "Decision/evidence provenance records to audit chains against"; AEM G3: "5 of 6 chains broken; EC8 unexecuted"; maturity 0.12/4.00, 0/43 enforced). The two must be recorded as distinct in the PQ-1 ADR (PQ1RSK-02).

### 8.2 The candidates (CONSTITUTIONAL REQUIREMENT)

| # | Candidate chain (backward, decision → rule) | Where stated |
|---|---|---|
| **A** | **Decision → Evidence → Constraint → Rule** (§2.3 short chain) | `constitutional-object-model.md` §2.3: "Traceability \| traverses \| Relationship \| Decision → Evidence → Constraint → Rule (T3; EC8)." Also enforcement-architecture §2/§3 (Traceability object); decision.specification `tracesTo`; `TRACEABILITY_CHAIN` in `traceability-graph.ts`. **Recorded by Phase 3 (C5).** |
| **B** | **Decision → Gate → Verification → Evidence → Constraint → Rule** (§4 full chain read backward) | Inferred from object-model §4 (enforcement chain Rule → Constraint → Evidence → Verification → Gate → Decision) read backward; §2.2 map (Verification/Gate both produce Decision). |

### 8.3 Exact relationship path (REPOSITORY FACT, Phase-3 vocabulary)

- **Candidate A:** `Decision ──records/produces──► Evidence ──examines──► Constraint ──constrained-by──► Rule` (R6→R3→R2→R1). Edges: `records` (backward), `examines` (backward), `constrained-by` (backward). All in range; matches `TRACEABILITY_CHAIN`.
- **Candidate B:** `Decision ──produces/records──► Gate ──requires(rev)──► Verification ──evaluates(rev)──► Evidence ──examines(rev)──► Constraint ──constrained-by(rev)──► Rule` (R6→R5→R4→R3→R2→R1). Uses `requires` and `evaluates` in the backward direction per `DEPENDENCY_EDGE_DIRECTIONS` (C1/HIGH-1 contract). All edges in range.

### 8.4 Is one candidate already mandated? (INTERPRETATION)

- **Candidate A is the only chain explicitly stated** in the constitutional sources (object-model §2.3; enforcement-architecture §2/§3) and both label it T3/EC8; Phase 3 implemented and recorded it.
- **Candidate B is an inferred reading** of object-model §4 and the §2.2 produces-map; defensible but not stated as the audit chain anywhere.
- The Phase-3 review (LOW-2), closure report, and governance analysis confirm a **genuine two-way source conflict**: §2.3 states the short chain; §4 implies the full chain. **Constitutional-source question, not a Phase-3 defect.** Phase 3 could not and must not decide unilaterally.

---

## §9 — EC8 Candidate Comparison

| Criterion | Candidate A (short, §2.3) | Candidate B (full, §4) |
|---|---|---|
| Explicitly stated as T3/EC8 chain | **Yes** — object-model §2.3; enforcement-architecture §2/§3 | No (inferred) |
| Already recorded by Phase 3 | **Yes** — `TRACEABILITY_CHAIN` (C5) | No |
| Traverses Verification/Gate hops | No | Yes |
| Requires amendment of frozen text | **No** (confirmatory ADR records selection + projection) | **Yes** — object-model §2.3, enforcement-architecture §2/§3, and the Phase-3 recorded chain |
| Edge support in vocabulary (27 kinds) | `records`, `examines`, `constrained-by` | Adds `requires`, `evaluates` (backward per DEPENDENCY_EDGE_DIRECTIONS) |
| Traceability semantics ("traces to evidence", T3) | Direct | Indirect (via Gate/Verification) |
| Risk of false audit outcomes if engine built before selection | Both — engine must not be built before selection (PQ1RSK-01) | Same |
| Impact on `decision.specification.tracesTo` | Unchanged | Must be updated (if B) |
| Impact on `MODEL-DECISION-PROVENANCE` | Unchanged | Must be updated (if B) |

**INTERPRETATION (evidence-lead, not a decision):** Candidate A is the only explicitly mandated reading, is already recorded, and can be confirmed without amending frozen text; Candidate B is defensible but requires a constitutional amendment. The board's selection is **PQ-1**; this package's evidence register does not presuppose an outcome.

---

## §10 — C6 / PQ-1 Dependency Analysis

**BOARD DECISION REQUIRED — the C6 and PQ-1 decisions are independent instruments but coupled at the Phase-4 gate:**

| Dimension | C6 | PQ-1 |
|---|---|---|
| Decision instrument | Formal ADR-003+ (PQ-2) | Formal ADR-003+ (PQ-1) |
| Amendable | Possibly (P3/I5 and/or I11) | Only if B selected (§2.3/enforcement-arch) |
| Exception | Yes (R9, I11) | No |
| Closes | C6 condition (DECISION-P3-001) | LOW-2 / PQ-1 (ADR-INDEX §3) |
| Gate coupling | GD-2: no gate may bind I11 verification until C6 closes | Engine's EC8 audit must not be built before PQ-1 selects the chain |

**INTERPRETATION:** both are **ADR-board decisions**; neither may be substituted by a documentation note, a bare R9 row, or a report interpretation (Governance Freeze §4; stress test §4; object-model §2.2 — an Exception must reference an ADR or authority). They can be resolved in the same ADR session but are separate decisions with separate fields. The Phase-4 gate is AND: **both must close** before the enforcement-engine phase (DECISION-P3-001 §4; DECISION-P3-002 §2; closure report §5).

---

## §11 — Phase 4 Authorization Conditions

Full precondition table: `ADR-BOARD-C6-PQ1-PHASE4-PRECONDITIONS.csv`. Summary (CONSTITUTIONAL REQUIREMENT):

1. **C6 closes:** formal ADR-003+ records the I11 exception in R9 (id, targetElement=I11, authority=ADR, scope, expiry, status=Recorded) **and** resolves the P3–I11 conflict (precedence rule). (DECISION-P3-001 §3 C6; ADR-INDEX PQ-2)
2. **PQ-1 closes:** formal ADR-003+ selects the canonical EC8 audit chain and records the other candidate as a projection. (ADR-INDEX PQ-1)
3. **Artifacts updated per decision** (§12.3): R9/SPEC-EXCEPTION, MODEL-TRACEABILITY/MODEL-DECISION-PROVENANCE, decision.specification (if B), Phase-3 reports, ADR-INDEX §3 (PQ-1/PQ-2 → closed; new ADR rows).
4. **Governance tests green** (§12.4): R9 exception shape, GD-2 no-gate-binding invariant, I11 bypass-detection constraint, precedence rule, TRACEABILITY_CHAIN pinning, audit-chain edge assertions.
5. **Later architectural review confirms closure of C1–C6** (DECISION-P3-001 §4; DECISION-P3-002 §2) before any Phase-4 work.
6. **No-change boundary holds** (§15).

---

## §12 — Required Decisions (ADR Board Decision Templates)

### Decision Template — C6 (PQ-2)

| Field | Value |
|---|---|
| **Decision ID** | BD-C6-001 |
| **Issue** | The I11 SECURITY DEFINER bypass is an unrecorded exception (R9, `PRECEDENT-I11-SECURITY-DEFINER`, `Unrecorded`) = standing violation (EL-3); the P3–I11 conflict (RULE 12's two mandated homes) is unresolved; no ADR-003+ or dated commitment exists; **no gate may bind the I11 verification until resolved (GD-2)**. |
| **Current authority** | I11 (ADR-002 §5); P3/I5 (ADR-002 §3/§5); R9 (exception.registry.ts); SPEC-EXCEPTION; exception-linkage EL-3; GD-2; state-machine transition 10; ADR-INDEX PQ-2 |
| **Evidence** | `ADR-BOARD-C6-PQ1-EVIDENCE-REGISTER.csv` rows C6EV-01..C6EV-12; stress test §3 I11; AEM §5 failures 1–2; §6 (SECURITY DEFINER surface: 27/15/15/14/14/13 occurrences across 6 schema files); DECISION-P3-001 C6; closure report §2; independent review §7 |
| **Options considered** | C6-A (amend I11); C6-B (amend P3/I5); C6-C (exception only); C6-D (ownership/enforcement clarification); C6-E (board-chosen, evidence-supported). See `ADR-BOARD-C6-PQ1-OPTION-MATRIX.csv`. |
| **Selected option** | *(blank — ADR board decision)* |
| **Reason** | *(blank — ADR board decision)* |
| **Constitutional impact** | If amendment: ADR-002 §3/§5 (P3/I5 and/or I11) and/or a precedence rule. If exception only: I11 state transition to Suspended for the exception's scope/expiry. |
| **Required amendments** | TBD by board (C6-A/B/D); minimum one amending ADR if conflict is resolved by text; none if interpreted (C6-D) |
| **Required exception** | R9 record (id, targetElement=I11, authority=ADR-003+, scope, expiry, status=Recorded); `KNOWN_PRECEDENTS` updated to reference the ADR |
| **Required verification** | Bypass detection (SECURITY DEFINER + disabled-RLS observable) registered in R2/R4 with the exception carve-out applied; GD-2 invariant test |
| **Effective date** | *(blank — ADR board decision)* |
| **Decision authority** | ADR board (D6 scope: "Enterprise Architecture (ADR board) for constitutional decisions") |
| **Status** | **BOARD DECISION REQUIRED** |

### Decision Template — PQ-1 (EC8 Audit Chain)

| Field | Value |
|---|---|
| **Decision ID** | BD-PQ1-001 |
| **Issue** | Which traceability chain is the canonical EC8 audit chain for decision provenance: Candidate A (`Decision → Evidence → Constraint → Rule`, §2.3) or Candidate B (`Decision → Gate → Verification → Evidence → Constraint → Rule`, §4 read backward)? |
| **Current authority** | object-model §2.3 (states A) vs §4 (implies B); enforcement-architecture §2/§3 (states A); ADR-002 T3/G3/EC8; `TRACEABILITY_CHAIN` (Phase-3 recorded A); ADR-INDEX PQ-1 |
| **Evidence** | `ADR-BOARD-C6-PQ1-EVIDENCE-REGISTER.csv` rows PQ1EV-01..PQ1EV-08; LOW-2 (phase3-review-decision.md); closure report §1 C5 / §5; `c6-pq1-governance-analysis.md` B.1–B.7 |
| **Options considered** | Select A (confirm §2.3; record B as projection; no frozen-text change); Select B (full chain; amend object-model §2.3 + enforcement-architecture §2/§3 + Phase-3 recorded chain). See OPTION-MATRIX. |
| **Selected option** | *(blank — ADR board decision)* |
| **Reason** | *(blank — ADR board decision)* |
| **Constitutional impact** | If A: none (confirmatory ADR). If B: amendment of object-model §2.3 and enforcement-architecture §2/§3 Traceability definition. |
| **Required amendments** | None (A); object-model §2.3 + enforcement-architecture §2/§3 (B) |
| **Required exception** | None |
| **Required verification** | `TRACEABILITY_CHAIN` pinned to selected chain; audit-chain edge assertions (all edges in `RELATIONSHIP_KINDS` ranges, match `DEPENDENCY_EDGE_DIRECTIONS`); engine EC8-audit-shape scaffold test (no execution); EC8 two-referent distinction recorded |
| **Effective date** | *(blank — ADR board decision)* |
| **Decision authority** | ADR board (ADR-INDEX §3: "Resolved here → decisions are recorded as formal ADRs") |
| **Status** | **BOARD DECISION REQUIRED** |

### §12.3 Artifacts to update after each decision

**After C6 (BD-C6-001):**
- `backend/src/governance/registries/exception.registry.ts` (R9 — `EXCEPTIONS` populated; `KNOWN_PRECEDENTS` updated to reference ADR)
- `backend/src/governance/specifications/exception.specification.ts` (SPEC-EXCEPTION status)
- `backend/src/governance/registries/rule.registry.ts` (R1 — I11 state/classification, if applicable)
- `backend/src/governance/registries/verification.registry.ts` (R4 — I11 bypass-detection registration)
- `backend/src/governance/registries/decision.registry.ts` (R6 — record the ADR approval decision)
- `docs/architecture/adr/ADR-INDEX.md` (§3 — PQ-2 → closed; new ADR row; §1 formal series)
- If amendment: **ADR-002 §3/§5** (via the amending ADR) and/or a precedence rule

**After PQ-1 (BD-PQ1-001):**
- `backend/src/governance/relationships/traceability-graph.ts` (MODEL-TRACEABILITY — status/recorded chain; if B, the chain itself)
- `backend/src/governance/relationships/decision-provenance.ts` (MODEL-DECISION-PROVENANCE — if B)
- `backend/src/governance/specifications/decision.specification.ts` (`tracesTo` meaning — if B)
- `docs/architecture/registry/phase3-dependency-graph-report.md` §3; `phase3-traceability-report.md` §6; `phase3-object-relationship-report.md` (recorded chain + projection)
- `docs/architecture/registry/traceability-register.md` / `registry-implementation-inventory.md`
- If B: **`docs/constitutional-object-model.md` §2.3** and **`constitutional-enforcement-architecture.md` §2/§3** (amendment)
- `docs/architecture/adr/ADR-INDEX.md` (§3 — PQ-1 → closed; new ADR row)

### §12.4 Tests/invariants to add after each decision

**After C6:** R9 test (EXCEPTIONS contains exactly one Recorded entry targeting I11 with non-empty ADR authority, scope, expiry, status Recorded; KNOWN_PRECEDENTS links to ADR); GD-2 invariant (no GATE_ELEMENT_ASSIGNMENT binds a gate to the I11 verification while I11 is Suspended/Violated; binding appears only after exception + conflict ADR exist); I11 bypass-detection constraint registered (R2/R4); precedence-rule test (reconciliation registered).

**After PQ-1:** `TRACEABILITY_CHAIN` pinned to selected chain (A: `['Decision','Evidence','Constraint','Rule']`; B: `['Decision','Gate','Verification','Evidence','Constraint','Rule']`) with the projection recorded; audit-chain edge-in-range + direction test; engine EC8-audit-shape scaffold test (no execution).

---

## §13 — Recommended Decisions

**RECOMMENDATION (advisory — the board decides; nothing here is an accepted decision):**

1. **C6 — recommended: C6-D + C6-C** (interpret + exception). Resolve the conflict by interpretation: DOMAIN_MODEL (A02/A09) is the **semantic home**; RLS policies are its **enforcement expression**; no P3/I5 text change needed beyond recording the interpretation; **and** grant a formal exception for the enumerated SECURITY DEFINER functions (scope must match the repository surface in §6.2, authority = the ADR, with expiry), so I11 moves to Suspended for that bounded scope and the standing Violated classification is lifted. **Why:** it satisfies C6's two parts (record exception + resolve conflict), minimizes frozen-text churn, and keeps I11's invariant text intact — but it is the option with the strongest need for the board's explicit precedence statement.
2. **PQ-1 — recommended: select Candidate A** (confirmatory ADR, no frozen-text amendment; record Candidate B as the documented projection: the full §4 chain is the *execution* chain; the audit chain omits the recorded Verification/Gate hops). **Why:** A is the only explicitly stated T3/EC8 chain, is already recorded by Phase 3, closes PQ-1 with a confirmatory ADR, and avoids amending frozen constitutional text. The board may instead select B; the package records B's amendment consequences (§9).
3. **Both decisions:** record both as **formal ADRs (ADR-003+)**, registered in ADR-INDEX; both carry dated commitments (PQ-2 requires a date); both must be accompanied by the §12.4 test set; the later architectural review must confirm C1–C6 closure before Phase 4.

**Recommended final verdict (see `ADR-BOARD-C6-PQ1-RECOMMENDATION.md`):** **C — BLOCKED — ADR BOARD GOVERNANCE DECISION REQUIRED**, with components A (amendment) and B (exception) as elements of the C6 decision, and with C6 and PQ-1 both closing before Phase 4. E is **not** selected: no evidence proves the blockers are already closed (R9 still Unrecorded; ADR-INDEX §3 still OPEN; grep clean for any ADR-003+).

---

## §14 — Explicit Unresolved Matters

**BOARD DECISION REQUIRED** — these remain unresolved and are NOT silently resolved by this package:

1. **Precedence rule** between P3/I5 and I11 for access-control matrices (stress-test §6; AEM §5 failure 1). No rule exists; this package does not invent one.
2. **Scope of the I11 exception** — single function vs the enumerated repository surface (§6.2: 27/15/15/14/14/13 SECURITY DEFINER occurrences). The recorded R9 precedent's "registration only" scope is narrower than the repository. The board must fix the scope.
3. **Exception expiry** — the R9 record has `expiry: 'Not defined'`; exceptions are expiring by design (SPEC-EXCEPTION). The board must set an expiry or a re-review cadence.
4. **EC8 two-referent distinction** — document-level 6-chain re-verification vs object-level audit chain must be recorded separately in the PQ-1 ADR (PQ1RSK-02); not merged.
5. **P7 circularity** — third known constitutional defect; separate ADR-track item; advisory for this package (C.2), must be resolved before the provenance machinery it touches is relied on.
6. **D3 per-artifact authority resolution** (AUTH-1/OWN-4) — advisory (INFO-1..5); not a gate for this package.
7. **`c6-pq1-decision-matrix.csv`** referenced by `c6-pq1-governance-analysis.md` §C.6/companion list does **not exist in the repository** (only the risk register, review decision, and analysis are present). The decision matrix for this package is supplied here as `ADR-BOARD-C6-PQ1-OPTION-MATRIX.csv`; the missing referenced file is a documentation discrepancy to be reconciled (not resolved here).

---

## §15 — No-Change Boundary (confirmed)

**REPOSITORY FACT — verified 2026-08-10.** This decision package produced documentation only. Confirmed:

- **No source code changes** — zero files under `backend/src/` modified by this package.
- **No SQL changes** — zero `.sql` files modified or executed.
- **No database changes** — no schema, migration, policy, or data change.
- **No seed changes** — zero seed files modified or executed.
- **No registry changes** — R1–R11 untouched (I11 precedent remains `Unrecorded`; no exception recorded).
- **No specification changes** — Phase-2 spec kinds untouched.
- **No relationship-model changes** — Phase-3 models untouched.
- **No API changes** — no contract/OpenAPI change.
- **No ADR created** — no ADR-003+; ADR-INDEX §1/§3 unchanged by this package.
- **No commits, no tags** — working tree changed only by these documentation artifacts.

Existing prohibitions remain in force: `RUNTIME_ENFORCEMENT_PROHIBITED`, `SPECIFICATIONS_RUNTIME_PROHIBITED`, `RELATIONSHIPS_RUNTIME_PROHIBITED`, and the Phase-4 prohibition (DECISION-P3-001 §4).

---

Prepared for the ADR board. Registered under `docs/architecture/adr/`. Not an ADR; does not amend the constitution; does not authorize Phase 4.
