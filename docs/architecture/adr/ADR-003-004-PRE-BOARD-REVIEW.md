# Pre-Board Independent Review — ADR-003 (I11 SECURITY DEFINER Governance) + ADR-004 (EC8 Audit Chain)

| Field | Value |
|---|---|
| Review | Independent pre-board review of the proposed ADR-003 and ADR-004 drafts |
| Date | 2026-08-10 |
| Reviewer | Independent review (read-only). Not the author of the submission; does not decide. |
| Reviewed documents | `ADR-003-I11-SECURITY-DEFINER-GOVERNANCE.md` (PROPOSED), `ADR-004-EC8-AUDIT-CHAIN.md` (PROPOSED), `ADR-003-004-BOARD-SUBMISSION.md`, `ADR-003-004-CONSISTENCY-MATRIX.csv` |
| Evidence base | Constitution (ADR-001/002), `constitutional-object-model.md`, `constitutional-enforcement-architecture.md`, `constitutional-state-machine.md`, `architecture-governance-freeze.md`, Phase-3 review/closure artifacts, C6/PQ-1 audit package, repository source (registries, relationship models, tests, schema dumps) |
| Constraint honored | Review only. No file was modified. No source/SQL/DB/seed/registry/spec/relationship/API change; no ADR-INDEX change; no commit. |
| Scope | Seven phases: (1) evidence collection; (2) ADR-003 review; (3) ADR-004 review; (4) joint consistency; (5) numbering; (6) board readiness; (7) Phase-4 gate. |
| Verdict | **CONDITIONAL — READY TO SUBMIT AFTER REQUIRED CORRECTIONS. NOT READY TO ACCEPT AS WRITTEN.** The decision substance of both ADRs (C6-D + C6-C for ADR-003; Candidate A for ADR-004) is supported by verified evidence. Two corrections are required before Board acceptance/registration: the numbering collision (finding J-01) and the ADR-004 mis-citation (finding A4-01). Three further corrections are recommended (A4-02, A3-01, A3-03). Neither ADR authorizes Phase 4; Phase 4 remains blocked. |

---

## Phase 1 — Evidence collected (all read and spot-verified)

Constitution: ADR-001 (numbering policy §2.1; binding template §2.2; index §2.3), ADR-002 (P3 §3, I5/I11 §5, T3/G3/EC8), ADR-INDEX (§1 series, §2.1/§2.2 reconciliation map, §3 PQ-1/PQ-2). Governance: `architecture-governance-freeze.md` (§1 frozen elements; §3 no-new-governance; §4 change control; EC10). Object model §2.1–§2.3, §4; enforcement architecture §2/§3; state machine (transitions 10/12; rule 2). Phase-3 artifacts: `phase3-review-decision.md` (C1–C6, LOW-2), `phase3-architectural-review-matrix.csv` (SCOPE-1, MED-1..5, HIGH-1/2, OBS-1, DEC-1), `phase3-relationship-risk-register.csv` (RSK-01..10), `phase3-dependency-graph-report.md` (§1 direction contract; §3 chain), `phase3-traceability-report.md` (§6), `phase3-conditions-independent-review.md`/matrix (C2–C5 closure; PQ-1 OPEN), `phase3-conditions-closure-report.md`. C6/PQ-1 package: `C6-security-definer-final-audit.md`, `C6-security-definer-inventory.csv`, `C6-final-decision-readiness.md`, `PQ1-EC8-final-confirmation.md`, `ADR-BOARD-C6-PQ1-DECISION-PACKAGE.md`, `-OPTION-MATRIX.csv`, `-EVIDENCE-REGISTER.csv`, `-PHASE4-PRECONDITIONS.csv`, `-RECOMMENDATION.md`, `-FINAL-READINESS.md`, `-MATRIX-RECONCILIATION.md`. Source: `relationship-kinds.ts`, `traceability-graph.ts`, `relationships.test.ts:384`, schema dumps (`fn_auto_transition`), DOMAIN_MODEL A02/A09/V4/V8. Submission set: `ADR-003-004-BOARD-SUBMISSION.md`, `ADR-003-004-CONSISTENCY-MATRIX.csv`.

---

## Phase 2 — ADR-003 review (I11 SECURITY DEFINER Governance)

### 2.1 Constitutional consistency — PASS

- P3/I5/I11 quotations match ADR-002 exactly (§3 line 71; §5 lines 118/124). `constitutional-enforcement-architecture.md` §7/I11 framing consistent.
- State-transition claims are exact: transition 10 (Violated → Suspended, exception granted, authority D6/ADR board) and transition 12 (Suspended → Active, exception expired/lifted) match `constitutional-state-machine.md` lines 42/44; state-machine rule 2 ("no gate on a breach") matches line 100 and GD-2 (`gate-dependency.ts`).
- Exception mechanism claims match `constitutional-object-model.md` §2.2 (`Decision may grant Exception`; `Exception suspends Rule`) and §3 rule 6 (unrecorded exception = violation regardless of intent).
- C6-D (semantic ownership vs enforcement location) is consistent with DOMAIN_MODEL A02 ("RULE 12 evidence-DELETE four-factor matrix"), A09 ("RULE 12 evidence residence"), V4 ("RULE 12 crosses A01, A02, A09, A18"), and V8 (P3-vs-I11 conflict "out of scope … require ADR amendment"), all verified in `docs/architecture/DOMAIN_MODEL.md` (lines 26/33/353/357).
- The option analysis (§10) matches the option matrix (C6-A..C6-E) and the final audit §4 (options 1–6).

### 2.2 Scope — PASS with one precision note (A3-01)

- Surface facts are exact: 30 executable SECURITY DEFINER functions = 28 live (13 system + 4 security + 6 committee + 5 documents) + 2 migration-only; `security.fn_register_user` = inventory C6-015; recorded precedent covers 1; uncovered live surface = 27. Matches `C6-security-definer-inventory.csv` and final audit §3.
- §6 boundary (13 objective fields; proposed scope = 28 live functions; migration-only C6-029/C6-030 excluded; future functions not covered) is sound and matches SPEC-EXCEPTION shape (authority, scope, expiry, status) and the audit's option 3 (bounded class).
- **A3-01 (LOW):** §2.3(1) says all 28 "bypass RLS on protected data", but the audit's own §2 Q1 states `system.fn_current_user_id` (C6-005) "reads only the app.user_id GUC", "SECURITY DEFINER is unnecessary hygiene, NOT an RLS bypass". The 28-function scope itself is safe (conservative over-inclusion), but the causal sentence overstates the bypass count. Recommend a one-line correction (27 of 28 access RLS-protected data; C6-005 included conservatively).

### 2.3 RULE 12 authority — PASS

§7 preserves RULE 12 in the aggregate home (A02/A09) with RLS as enforcement, matching the final audit §6 and DOMAIN_MODEL V8. No evidence requires moving RULE 12.

### 2.4 Future evolution / enforcement — PASS with one clarification (A3-02)

- §6 boundary 1 ("No unnamed or future function is covered") correctly confines the exception; new SECURITY DEFINER functions require a separate Board decision. §12 items 1–6 (exception record shape, GD-2, bypass-detection constraint, scope conformance, precedence record, expiry enforcement) match the precondition table PREC-01..05/09 and DECISION-P3-001 C6.
- **A3-02 (LOW):** §12 item 5 says the precedence/conflict-resolution record is made "per the later enforcement work". PREC-02 requires the precedence rule recorded in the ADR text and a test green before Phase 4. Since §5(1) already states the precedence interpretation, anchor §12(5) to "recorded by §5(1) of this ADR upon acceptance; enforced at specification/relationship level in the later enforcement work" to avoid deferring the precedence statement itself.

### 2.5 Evidence-chain hygiene — MEDIUM (A3-03)

- **A3-03 (MEDIUM):** Prior-package artifacts enumerate `system.fn_auto_transition` as part of the SECURITY DEFINER surface (`ADR-BOARD-C6-PQ1-DECISION-PACKAGE.md` §6.2 line 171; `ADR-BOARD-C6-PQ1-EVIDENCE-REGISTER.csv` row C6EV-10). Verified: `fn_auto_transition` **is** `SECURITY DEFINER` (e.g. `backend/schema_only_dump.sql:213`) and appears in 5 of the 6 schema dumps used for the surface counts, but it was **dropped** (`archive/sql-history/39-drop-auto-transition.sql`, "broken by design"; `docs/architecture/Workflow-Implementation-Contract.md:189` marks REMOVED) and is not in the canonical live extraction (`database/canonical/functions/*.sql`). The final audit inventory (the authoritative input ADR-003 cites) correctly excludes it. Resolution: before creating the R9 exception record (PREC-04), confirm the live Gate-0 baseline contains exactly the 28 enumerated functions and not `fn_auto_transition`; the ADR should note this reconciliation.

### 2.6 Template — LOW (A3-04)

Section numbering deviates from the binding template (§1 Context, §2 Decision, §3 Alternatives, §4 Consequences, §5 References). All required content is present. Map sections or formally extend the template at registration.

---

## Phase 3 — ADR-004 review (EC8 Audit Chain)

### 3.1 Source authority — PASS, with a required correction (A4-01)

- The exact authoritative source cited — `docs/constitutional-object-model.md` §2.3 line 107: "Traceability | traverses | Relationship | Decision → Evidence → Constraint → Rule (T3; EC8)" — is **verified verbatim**. Secondary source `constitutional-enforcement-architecture.md` §2/§3 (line 76: "The backward chain decision → evidence → constraint → rule") verified. `TRACEABILITY_CHAIN = ['Decision','Evidence','Constraint','Rule']` verified in `traceability-graph.ts:26–31`; the chain assertion at `relationships.test.ts:384` verified.
- **A4-01 (HIGH — correct before acceptance):** §2 evidence item 3 and §3.3 cite `PQ1-EC8-final-confirmation.md` as confirming the traceability-chain Candidate A. That document resolves a **different** EC-8 question — the Document-aggregate subscriber endpoint (its Candidate A = "unified subscriber endpoint on one aggregate"; Candidate B = "separate relationship aggregate subscribes") — and cites a **non-existent source** (`domain-model/object-model.md`; no `domain-model/` directory exists). It does not speak to the traceability-chain selection at all. The traceability-chain Candidate A is independently and correctly supported by the two constitutional sources above; the mis-citation must be removed or corrected. The same conflation exists in `ADR-BOARD-C6-PQ1-FINAL-READINESS.md` line 22. For a decision whose subject is traceability (T3), a clean evidence chain is mandatory.

### 3.2 Meaning — PASS (projection, not a new canonical model)

ADR-004 §1/§4 correctly defines the chain as the object-level decision-trace chain for the future engine's EC8 audit, distinct from the document-level EC8 exit criterion ("6 traceability chains re-verified") — recording the two-referent distinction (PQ1RSK-02/PREC-08). It records Candidate B as a projection of the enforcement chain, not a replacement of §4. No new canonical model is invented.

### 3.3 Direction — PASS with a hop-level imprecision (A4-02)

- The direction claims are consistent with `DEPENDENCY_EDGE_DIRECTIONS` (C1/HIGH-1 contract; `relationships.test.ts:368–374`).
- **A4-02 (MEDIUM — correct the edge claim):** §3.1/§5/§6 say the chain's edges are "`records`, `examines`, `constrained-by` (backward) — all in range". At the vocabulary level (`relationship-kinds.ts`): `records` has `validTo = ['Verification','Gate']` (line 50) — it cannot connect Decision → Evidence; `examines` is forward (Constraint → Evidence) and `constrained-by` is forward (Rule → Constraint); their backward readings are the inverse pairs `is-examined-by`/`constrains`. The Decision → Evidence hop has **no direct registered edge**; it is established through the recorded provenance projection (records/produces via Verification/Gate). The accurate framing is: the chain is a **backward traversal** (`traverses`, line 61, validTo includes all chain nodes) over the audit chain, with an explicit hop-edge contract for the engine's EC8 audit scaffold (§12.4). This prevents a range-incompatible implementation of the type RSK-02/HIGH-2 was created to catch.

### 3.4 Cycle / divergence risk — PASS

Selecting Candidate A and pinning `TRACEABILITY_CHAIN` leaves the dependency graph acyclic and unambiguous; the §4 execution chain remains its own forward flow; no cycle or contradiction is introduced. `decision.specification.tracesTo` and MODEL-DECISION-PROVENANCE need no change under A (verified per decision-package §9). Vocabulary count claim ("27 kinds") is verified (27 `RELATIONSHIP_KINDS`; the "26 kinds" figure in the Phase-3 review matrix predates C4's `constrains` addition).

### 3.5 Template — LOW (A4-03)

Same structural deviation as A3-04; content complete.

---

## Phase 4 — Joint review

- **Independent instruments, AND-coupled at the Phase-4 gate.** ADR-003 (C6, PQ-2) and ADR-004 (PQ-1) are separate decisions; both must close before Phase 4 (decision-package §10). The drafts are consistent: ADR-004 cites ADR-003 as related; neither depends on the other's acceptance. No cross-contradiction.
- **Governance Freeze compliance — PASS.** Neither ADR amends frozen text (no P3/I5/I11 change; no object-model §2.3 change). Freeze §3/§4 routes (formal ADR; recorded exception with authority; confirmatory ADR) are honored. `ADR-003-004-CONSISTENCY-MATRIX.csv` is accurate: every row is PROPOSED; I11 remains Violated today; ADR-INDEX §1/§3 unchanged; Phase 4 remains blocked.
- **No-change boundary — PASS.** Both drafts carry the DRAFT-ONLY constraint; working-tree deltas are documentation artifacts only. No registry/spec/relationship/runtime/API/commit change (verified against the submission constraint and the decision-package §15 baseline).
- **Cross-document evidence defect (inherited):** `ADR-BOARD-C6-PQ1-FINAL-READINESS.md` line 22 repeats the A4-01 conflation. Correct it in the same pass as ADR-004.

---

## Phase 5 — Numbering review (collision)

**J-01 (HIGH — REQUIRED Board action, blocks registration):**

- ADR-INDEX §1 line 13 reserves "ADR-003+ | New decisions only; number never reused (ADR-001 §2.1)".
- ADR-INDEX §2.1 maps informal **RC4 ADR-01 → TBD-P3 (ADR-003)** and **RC4 ADR-02 → TBD-P3 (ADR-004)** (…RC4 ADR-08 → ADR-010); §2.2 maps Phase5 ADR-001..007 → ADR-011..ADR-017.
- The proposed ADR-003 (I11) and ADR-004 (EC8) therefore collide with numbers reserved for the informal-ADR reconciliation (Governance Freeze **EC10: "No informal-ADR numbering collision"**; ADR-001 §2.1(3): "A number is never reused").
- The submission records the collision but does not resolve it (`ADR-003-004-BOARD-SUBMISSION.md` §4). It must be resolved **before** registration (ADR-001 §2.2: an ADR is part of the series only if registered).

Resolution options for the Board:

| Option | Effect | Note |
|---|---|---|
| **R1 — Assign ADR-018/ADR-019** (recommended) | These decisions take the next free numbers above all reservations (ADR-017). RC4 map untouched; EC10 satisfied. | File names/headers/ADR-INDEX references updated. |
| R2 — Board re-sequences the RC4 map | RC4 ADR-01/02 re-mapped to higher numbers; new ADRs keep 003/004. | Requires amending ADR-INDEX §2.1 by Board decision; risk of churn across the reconciliation map. |
| R3 — Keep 003/004 and record a formal re-mapping ADR | A new ADR re-maps the informal numbers; the C6/PQ-1 ADRs register under 003/004. | Highest churn; collides with the "reserved" intent and EC10 unless the mapping ADR precedes registration. |

**Recommended: R1.** Assign the two decisions ADR-018 (I11 SECURITY DEFINER Governance) and ADR-019 (EC8 Audit Chain) unless the Board prefers a different explicit scheme. This is a Board call; the review does not decide.

---

## Phase 6 — Board readiness (7 conditions)

| # | Condition | Status | Evidence |
|---|---|---|---|
| 1 | Claim accuracy | **PASS with corrections** | All substantive claims verified; 4 corrections: A3-01 (LOW), A3-02 (LOW), A3-03 (MEDIUM), A4-02 (MEDIUM) |
| 2 | Constitutional consistency | **PASS** | State machine, object model, enforcement architecture, GD-2, DOMAIN_MODEL — all match |
| 3 | Governance Freeze compliance | **PASS** | No frozen-text change; formal-ADR and exception routes used |
| 4 | Numbering | **BLOCKED until resolved** | J-01 (ADR-INDEX §2.1 reservations; EC10; ADR-001 §2.1) |
| 5 | Cross-ADR coupling | **PASS** | Independent, AND-coupled at Phase-4 gate; no contradiction |
| 6 | Phase-4 non-authorization | **PASS** | ADR-003 §11, ADR-004 §8: acceptance alone does not authorize Phase 4 |
| 7 | Evidence traceability | **PASS with corrections** | A4-01 mis-citation (required); A3-03 prior-package divergence; remainder verified |

Board decision items (ADR-003): exception scope (proposed 28 live; Board may narrow), expiry/re-review cadence (§13 blank), authority (proposed ADR-003), §13 fields (selected/effective date/approved by/conditions/review date). Board decision items (ADR-004): Candidate A selection, §9 fields. Registration item: numbering resolution (J-01).

---

## Phase 7 — Phase-4 gate assessment (PREC-01..12)

| PREC | Addressed by | Status at review |
|---|---|---|
| PREC-01 R9 exception record | ADR-003 decision 2 + §12 item 1 | Covered; record created on acceptance |
| PREC-02 P3–I11 conflict + precedence | ADR-003 §5(1) (C6-D); §12 item 5 | Covered; precedence test (PREC-09) still to add |
| PREC-03 bypass-detection verification | ADR-003 §12 item 3 | Covered; register on acceptance |
| PREC-04 scope matches repository | ADR-003 §6 boundary 1; §12 item 4 | Covered, **subject to A3-03 live-baseline confirmation** |
| PREC-05 exception expiry | ADR-003 §6 boundary 10; §13 blank | **Board must fill** at acceptance |
| PREC-06 EC8 chain selection | ADR-004 decision 1 | Covered (Candidate A) |
| PREC-07 frozen-text amendment (if B) | Not applicable | A selected |
| PREC-08 EC8 two-referent | ADR-004 §1/§6 | Covered |
| PREC-09 governance test set (C.4) | ADR-003 §12; ADR-004 recording req. | **To be added on acceptance** (defines, does not yet add, the tests) |
| PREC-10 later architectural review | Separate gate (DECISION-P3-001 §4) | Not in ADRs; must still occur |
| PREC-11 formal ADR registration | Both ADRs + ADR-INDEX | **Blocked by J-01** until numbering resolved |
| PREC-12 no-change boundary | Submission constraint; both drafts | Holds; reconfirm at later review |

Phase 4 remains **BLOCKED**. Acceptance of both ADRs (plus the R9 record, precedence test, bypass-detection registration, test set, and the later architectural review) is a precondition, not a substitute, for a separate Phase-4 authorization decision.

---

## Findings register (summary)

| ID | Severity | ADR | Finding | Required before acceptance? |
|---|---|---|---|---|
| J-01 | HIGH | Both | Numbering collision with ADR-INDEX §2.1 reservations (EC10; ADR-001 §2.1) | YES (before registration) |
| A4-01 | HIGH | ADR-004 | §2(3)/§3.3 mis-cite `PQ1-EC8-final-confirmation.md` (different EC-8 question; cites non-existent `domain-model/object-model.md`) | YES (before acceptance) |
| A4-02 | MEDIUM | ADR-004 | Hop-edge claim "records/examines/constrained-by" is vocabulary-imprecise; no direct Decision→Evidence edge; use traversal + inverse-pair framing | RECOMMENDED |
| A3-03 | MEDIUM | ADR-003 | Prior-package surface includes dropped `system.fn_auto_transition`; reconcile live baseline before R9 record | RECOMMENDED (at R9 record time) |
| A3-01 | LOW | ADR-003 | §2.3 "all 28 bypass RLS" overstates; C6-005 is hygiene-only | RECOMMENDED |
| A3-02 | LOW | ADR-003 | §12(5) defers precedence recording wording; anchor to §5(1) | RECOMMENDED |
| A3-04 / A4-03 | LOW | Both | Template section structure deviates from binding template | At registration |

Full detail: `ADR-003-004-EVIDENCE-MATRIX.csv`, `ADR-003-004-RISK-REGISTER.csv`. Board position: `ADR-003-004-BOARD-READINESS.md`.

---

## Verdict

**CONDITIONAL — READY TO SUBMIT AFTER REQUIRED CORRECTIONS. NOT READY TO ACCEPT AS WRITTEN.**

The decision content of both proposals is correct and evidence-supported: **ADR-003 (C6-D + C6-C)** resolves the P3–I11 conflict by the semantic-vs-enforcement interpretation and governs the 28-function SECURITY DEFINER surface by a bounded, enumerated, expiring R9 exception (I11 → Suspended, gate-un-bindable per GD-2); **ADR-004 (Candidate A)** confirms the only explicitly stated constitutional audit chain (`Decision → Evidence → Constraint → Rule`) with the enforcement chain recorded as its projection and no frozen-text change. Neither authorizes Phase 4.

Required before the Board accepts/registers: (1) resolve the numbering collision (J-01); (2) correct the ADR-004 mis-citation (A4-01). Recommended: correct the hop-edge framing (A4-02), the bypass-count wording and §12(5) anchoring in ADR-003 (A3-01/A3-02), and reconcile the live baseline before the R9 record (A3-03). Then the Board fills the blank §13/§9 decision fields (scope, expiry, authority, effective date) and issues the registration.
