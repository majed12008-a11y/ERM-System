# Architecture Enforcement Model (AEM)

| Field | Value |
|---|---|
| Status | COMPLETE — formal specification of how every constitutional rule becomes objectively verifiable |
| Date | 2026-08-06 |
| Authority | Independent Principal Architect, responding to `architecture-constitution-stress-test.md` (verdict: NO). Architecture Phase = CLOSED; ADR-002 = constitutional; Baseline v2 = frozen; Governance Freeze = active. |
| Constraints honored | READ-ONLY. Documentation only. No code, SQL, migrations, manifests, commits. No implementation framework. No redesign. |
| Purpose | Transform the constitutional architecture from **declarative** to **enforceable**. Specify the conceptual enforcement chain, map every constitutional element to its enforcement class and maturity, explain every stress-test failure's cause, measure the gap, and rule on execution readiness. |
| Companion data | `constitution-enforcement-matrix.csv`, `constitutional-maturity-model.csv`, `enforcement-gap-register.csv`. |
| Verdict | **NO — the constitutional architecture is not yet a permanent engineering contract.** |

---

## SECTION 1 — Enforcement Philosophy

Three distinct ways an architecture can bind future work.

| Property | Declarative Architecture | Governed Architecture | Enforceable Architecture |
|---|---|---|---|
| Rules exist in documents | Yes | Yes | Yes |
| Change control exists (ADR, review, approval) | No | Yes | Yes |
| Compliance is assessed by humans | No | Yes (reviews, approvals) | Only where humans are the only possible verifier |
| Compliance is assessed by an objective procedure | No | No (optional, ad hoc) | Yes — every rule has a defined verification |
| Violation is detected automatically | No | No — detection depends on a review being performed | Yes — detection does not depend on human diligence |
| Violation blocks progress | No | Partially (if a reviewer notices) | Yes — a binding gate halts the action |
| Violation is recorded | No | Sometimes | Yes — a decision record exists |
| Trust basis | Words | Diligence | Mechanism |

- **Declarative architecture** states what must be true. It answers "what?" but provides no answer to "how do we know?" A declarative rule is an assertion: it holds because it was written.
- **Governed architecture** adds the social layer: ADRs, approval bodies, review boards, change control. Compliance is achieved by diligent people. Its failure mode is *neglect* — the review that is never scheduled, the audit that is never run, the exception that is never questioned.
- **Enforceable architecture** makes every rule falsifiable and every falsification observable. Each rule has a constraint (a checkable predicate), evidence (an artifact to check), verification (an objective procedure), a gate (a binding point), and a decision (a recorded outcome). Enforcement does not eliminate human judgment; it removes judgment from the question "did the rule hold?"

**Where the project stands.** The project is at the **declarative/governed boundary, with the governance layer unexecuted**. ADR-002 (P1–P9, I1–I11) is declarative — it asserts properties. The Governance Freeze and Transition Plan add governance: change control is defined (any change to a frozen element is an ADR), and the exit criteria EC1–EC10 are *written as* verification procedures ("verifiable by inspection/grep/audit"). But none of that verification has run: Phase 0 is unexecuted, no EC audit has been performed, and the stress test demonstrated that "grep prevents a violation" holds only if someone runs the grep. The constitution declares; the governance freeze orders; neither detects. This document specifies the enforcement that would close the gap.

---

## SECTION 2 — Constitutional Mapping

Every constitutional element, classified by its current enforcement reality. Full matrix: `constitution-enforcement-matrix.csv`. Classes:

- **Documentation only** — the rule is written; no procedure examines compliance.
- **Human-reviewed** — evidence exists that a human could assess, but no review is required or scheduled.
- **Automatically verifiable** — an objective procedure is *defined* (and, where noted, executed).
- **Currently unenforceable** — no constraint, evidence, or verification exists; the rule cannot be checked today.

### 2.1 Principles (P1–P9)

| # | Rule | Current class |
|---|---|---|
| P1 | Dataset-first: Canonical Dataset is the source of truth; seed suite is a historical record | Currently unenforceable |
| P2 | Domain ownership: every datum maps to exactly one owning subsystem or a declared shared kernel | Currently unenforceable |
| P3 | Aggregate ownership: RULE 11/12 live in a single authoritative model | Currently unenforceable |
| P4 | Semantic dependencies: execution order respects the business graph, never numeric order | Currently unenforceable |
| P5 | Dataset lifecycle: promote/version/deprecate/branch/merge/archive | Currently unenforceable |
| P6 | Business identity over execution order | Currently unenforceable |
| P7 | Provenance trust: no decision on execution state not provably a product of execution | Currently unenforceable |
| P8 | Behavior verification over integrity verification | Currently unenforceable |
| P9 | No dead data; consumerless data retired | Human-reviewed (inventory documented; retirement unenforced) |

### 2.2 Invariants (I1–I11)

| # | Rule | Current class |
|---|---|---|
| I1 | Seed suite never treated as the dataset product | Documentation only (forbidden-vocabulary rule exists; EC5 audit unexecuted) |
| I2 | No decision based on non-provenanced execution state | Documentation only (EC6 defined; provenance mechanism circular) |
| I3 | Reproducibility by construction, not restoration | Currently unenforceable |
| I4 | Every datum single owner or declared shared kernel | Currently unenforceable |
| I5 | Aggregate invariants in a single authoritative model, assertable by verification | Currently unenforceable |
| I6 | Order respects the business graph; numeric order never sufficient | Currently unenforceable |
| I7 | All canonical data in a defined lifecycle | Currently unenforceable |
| I8 | No consumerless data in canonical counts; consumerless data deprecated/retired | Documentation only (inventory exists; retirement undefined) |
| I9 | Verification asserts business behavior, not only integrity | Currently unenforceable |
| I10 | Idempotency and reconciliation by business identity | Currently unenforceable |
| I11 | Schema/RLS/data distinct; RLS sole access control; never disabled, never bypassed | Automatically verifiable (DB-enforced) — with a documented bypass (SECURITY DEFINER workaround) |

### 2.3 Governance rules (G1–G13)

| # | Rule | Current class |
|---|---|---|
| G1 | No mixed worldview: every document belongs to exactly one baseline (T1) | Documentation only |
| G2 | Single constitutional source: ADR-002 is sole constitution (T2) | Documentation only (reviewable in principle) |
| G3 | Backward traceability: every decision traces to evidence (T3) | Documentation only (5 of 6 chains broken; EC8 unexecuted) |
| G4 | Controlled terminology evolution (T4) | Documentation only |
| G5 | Single ownership of governance artifacts (T5) | Documentation only (ownership table exists; no enforcement) |
| G6 | Archive before replace (T6) | Documentation only (no archive manifests yet) |
| G7 | Governance first, mechanism later (T7) | Documentation only |
| G8 | Evidence is immutable (T8) | Documentation only |
| G9 | No new principles beyond P1–P9 (freeze) | Documentation only |
| G10 | No new constitutional documents beyond the baseline list (freeze) | Documentation only |
| G11 | No new terminology beyond the final vocabulary (freeze) | Documentation only |
| G12 | No new ownership models (freeze) | Documentation only |
| G13 | Change to a frozen element = formal ADR; ADR-001 first; ordering gate until ADR-001 (freeze §4) | Documentation only |

### 2.4 Exit criteria (EC1–EC10)

| # | Rule | Current class |
|---|---|---|
| EC1 | ADR-001 exists/approved; ADR template non-empty and binding | Documentation only (verification defined, not run) |
| EC2 | Glossary, document index, ADR index populated; final vocabulary recorded | Documentation only (verification defined, not run) |
| EC3 | DOMAIN_MODEL defines Aggregate/Aggregate Root; Application/Condition roots named | Documentation only (verification defined, not run) |
| EC4 | All 27 affected documents disposed; zero active Partially/Divergent/Superseded | Documentation only (verification defined, not run) |
| EC5 | Zero forbidden terms in active documents | Documentation only (verification defined, not run) |
| EC6 | Cutover checklist gates on construction evidence, not seed-status | Documentation only (verification defined, not run) |
| EC7 | SREA and dataset-architecture archived; no active citations | Documentation only (verification defined, not run) |
| EC8 | All 6 traceability chains re-verified, 0 broken | Documentation only (verification defined, not run) |
| EC9 | Enterprise baseline assessment v2 approved, ADR-002-consistent | Documentation only (verification defined, not run) |
| EC10 | Informal ADR numbering collision resolved; mapping present | Documentation only (verification defined, not run) |

**Summary.** 15 of 43 elements are **Currently unenforceable**; 26 are **Documentation only**; 1 is **Human-reviewed** in substance (P9); 1 is **Automatically verifiable** only because PostgreSQL itself enforces RLS (I11), and even that is bypassed in the accepted baseline. No element is fully enforced.

---

## SECTION 3 — Enforcement Model

### 3.1 The enforcement chain

A constitutional element is **enforced** only when all six links exist:

```
Constitutional rule
        ↓            the normative statement (P/I/G/EC)
Constraint
        ↓            the checkable predicate: "what does a violation look like?"
Evidence
        ↓            the artifact(s) the constraint operates on
Verification
        ↓            the objective procedure producing pass/fail
Gate
        ↓            the binding point where failure halts an action
Decision
                     the recorded outcome and its authority
```

| Link | Definition | Failure when absent |
|---|---|---|
| **Constitutional rule** | The normative statement. | No rule to enforce. |
| **Constraint** | A falsifiable operational predicate derived from the rule. | The rule cannot be violated *because it cannot be checked* — unfalsifiable. |
| **Evidence** | The verifiable artifact(s) the constraint examines. | The constraint has nothing to operate on — uncheckable. |
| **Verification** | An objective procedure evaluating evidence against the constraint; binary pass/fail, no discretion. | Evidence exists but is inert — uninspected. |
| **Gate** | A binding process point (publication, disposition, merge, release, ADR approval) that requires pass. | Verification is advisory — ignored. |
| **Decision** | A recorded outcome with authority. | No audit trail; violations vanish after the fact. |

### 3.2 Missing links per constitutional element

Cells: **P** = present, **M** = missing. Full matrix in `constitution-enforcement-matrix.csv`.

| Element | Constraint | Evidence | Verification | Gate | Decision |
|---|---|---|---|---|---|
| P1 | M | M | M | M | M |
| P2 | M | M | M | M | M |
| P3 | M | M | M | M | M |
| P4 | M | M | M | M | M |
| P5 | M | M | M | M | M |
| P6 | M | M | M | M | M |
| P7 | M | M | M | M | M |
| P8 | M | M | M | M | M |
| P9 | M | P (inventory, population matrix, table usage) | M | M | M |
| I1 | P (forbidden-vocabulary list) | M | M | M | M |
| I2 | M | M | M | M | M |
| I3 | M | M | M | M | M |
| I4 | M | M | M | M | M |
| I5 | M | M | M | M | M |
| I6 | M | M | M | M | M |
| I7 | M | M | M | M | M |
| I8 | M | P (dead-data inventory, canonical-spec §6) | M | M | M |
| I9 | M | M | M | M | M |
| I10 | M | M | M | M | M |
| I11 | P (RLS policies) / M (never-bypassed) | P (174+ policies, app.user_id context) | P (DB enforces RLS) / M (bypass detection) | M | M |
| G1–G13 | M | M | M | M | M |
| EC1–EC10 | P (each defines its check) | P (each names its artifact) | P *defined* / M *executed* | M | M |

**Aggregate.**

| Link | Present | Missing |
|---|---|---|
| Constraint | 12 of 43 | 31 of 43 |
| Evidence | 13 of 43 | 30 of 43 |
| Verification | 11 of 43 (10 defined-not-executed; 1 DB-enforced) | 32 of 43 |
| Gate | 0 of 43 | **43 of 43** |
| Decision | 0 of 43 | **43 of 43** |

**Read.** No constitutional element has a gate or a decision record. Nothing in the entire constitution is wired to a point where a violation stops progress and leaves a trace. The strongest links in the system belong to the exit criteria — and even those stop at "verification defined," never executed and never binding. The ECs are the project's only candidate verification procedures; the AEM's entire requirement for the transition is that they become executed gates rather than written criteria.

---

## SECTION 4 — Enforcement Coverage

### 4.1 Maturity levels

| Level | Name | Meaning |
|---|---|---|
| L0 | Defined only | Rule is written; no procedure examines it (Documentation only). |
| L1 | Reviewable | Evidence exists that a human could assess; no review required (Human-reviewed). |
| L2 | Traceable | Evidence exists and is mapped to the rule; compliance can be reconstructed. |
| L3 | Automatically verifiable | An objective procedure verifies the rule. |
| L4 | Continuously enforced | Verification runs against every change and failure blocks the change. |

### 4.2 Current maturity

Full per-element data: `constitutional-maturity-model.csv`. Distribution:

| Level | Count | Elements | % |
|---|---|---|---|
| L0 | 40 | P1–P8, I1–I7, I9, I10, G1–G13, EC1–EC10 | 93.0% |
| L1 | 2 | P9, I8 | 4.7% |
| L2 | 0 | — | 0.0% |
| L3 | 1 | I11 (RLS DB-enforced; bypass not detected) | 2.3% |
| L4 | 0 | — | 0.0% |

**Average current maturity: 0.12 of 4.00.** Ninety-three percent of the constitution is at Level 0. The single L3 element is the one the stress test proved to be already violated (I11). The constitution's enforcement coverage is effectively zero.

### 4.3 Required maturity

For the constitution to function as an engineering contract, constitutional rules (P, I, freeze rules) require **L4 — continuously enforced** (they bind every future change); governance rules and exit criteria require at minimum **L3 — automatically verifiable**. Required-level assignments are in `constitutional-maturity-model.csv` and `enforcement-gap-register.csv`.

---

## SECTION 5 — Constitutional Weaknesses

Every failure found by the Constitution Stress Test, with its cause classified as **Missing rule / Missing verification / Missing ownership / Missing evidence / Missing governance / Missing enforcement**.

| # | Stress-test failure | Why it could occur | Cause |
|---|---|---|---|
| 1 | P3 vs I11 conflict (RULE 12 mandated into two authoritative homes) | The constitution states both requirements with no reconciliation and no precedence between a principle and an invariant; nothing detects which home an implementer chose. | **Missing governance** (no reconciliation authority) + **Missing rule** (no precedence rule) |
| 2 | I11 already violated (SECURITY DEFINER bypass) | The invariant's "never bypassed" has no detection; the accepted `33-fix-register-rls.sql` workaround is itself a bypass, establishing precedent. | **Missing verification** (no bypass detection) + **Missing governance** (no exception control) |
| 3 | P7 circular provenance | The required evidence (provenance that "survives restore") can itself be restored and forged; no external anchor is defined. | **Missing rule** + **Missing evidence** |
| 4 | Invariants prevent zero violations | No constraint/evidence/verification/gate/decision exists for any invariant; prohibition is declaration, not detection. | **Missing enforcement** + **Missing verification** + **Missing evidence** |
| 5 | Dataset-philosophy fallback (dump becomes truth) | EC5/EC6/EC7 audits are defined but never run; no construction product exists to serve as the truth P1 asserts. | **Missing enforcement** + **Missing evidence** |
| 6 | 5 PARTIALLY scenarios (tenants, multi-dataset, PG replacement, distribution, DR) | The constitution does not define these constructs (deferred D1/D7); there is no rule for them to be checked against. | **Missing rule** |
| 7 | P3/P4/P6/P8 unenforceable (depend on Phase 1–2 artifacts) | No authoritative aggregate model, business graph, natural-key sets, or behavior formalizations exist. | **Missing evidence** + **Missing verification** |
| 8 | I2 enforcement | The cutover gate is not re-based (EC6 unexecuted); provenance spec is circular. | **Missing rule** + **Missing verification** |
| 9 | P9 dead-data time-sensitivity | "Zero consumers" is a snapshot; measurement window and retirement authority are undefined. | **Missing rule** + **Missing ownership** |

**Cause frequency across failures.**

| Cause | Failures | Dominant where |
|---|---|---|
| Missing rule | 5 | scenario constructs, provenance, RULE 12 precedence, dead-data window |
| Missing verification | 4 | invariant violations, I11 bypass, Phase 1–2 dependencies |
| Missing evidence | 4 | aggregate model, graph, natural keys, construction product |
| Missing governance | 2 | RULE 12 conflict, I11 bypass |
| Missing enforcement | 2 | fallback, invariant prevention |
| Missing ownership | 1 | dead-data retirement authority |

The failure pattern is structural, not incidental: the constitution defines rules but owns none of the five enforcement links (Section 3) for almost any element.

---

## SECTION 6 — Enforcement Gap Matrix

Full register: `enforcement-gap-register.csv`. Summary:

| Constitutional element | Current level | Required level | Gap | Risk |
|---|---|---|---|---|
| P1–P8 | L0 | L4 | 4 | **CRITICAL** |
| P9 | L1 | L4 | 3 | HIGH |
| I1–I7, I9, I10 | L0 | L4 | 4 | **CRITICAL** |
| I8 | L1 | L4 | 3 | HIGH |
| I11 | L3 (bypassed) | L4 | 1 nominal / real gap unresolved | **CRITICAL** |
| G1, G4, G9–G13 | L0 | L4 | 4 | HIGH |
| G2, G3, G5–G8 | L0 | L3 | 3 | HIGH / MEDIUM |
| EC1–EC10 | L0 | L3 | 3 | HIGH |

**Gap summary.**

| Gap size | Elements | Risk profile |
|---|---|---|
| 4 (L0 → L4) | 24 | CRITICAL for P/I; HIGH for governance freeze rules |
| 3 (L0/L1 → L3/L4) | 18 | HIGH (P9, I8, G2–G8, EC1–EC10) |
| 1 (L3 → L4) | 1 | CRITICAL (I11 — gap is not the level, it is the accepted bypass) |

The gap is not concentrated in a few rules — it is the *default state* of the constitution. No implementation is proposed here; the register only quantifies the distance between the constitution's claim and its current enforcement reality.

---

## SECTION 7 — Execution Readiness

Question: **Can future implementation violate the constitution without being detected?**

**YES.**

On constitutional-enforcement grounds alone (not project progress):

1. **Zero gates and zero decision records exist** for any constitutional element (Section 3.2: 0 of 43 for both links). A violation stops nothing and leaves no trace.
2. **93.0% of elements are at Level 0** (Section 4.2). For 40 of 43 elements there is no procedure that could detect a violation.
3. **The one automatically enforced element (I11) is already violated** in the accepted baseline (SECURITY DEFINER bypass), and the bypass is precisely the kind of change nothing detects.
4. **The only defined verification procedures are EC1–EC10, and none has been executed** (Section 2.4). Detection currently depends on a human deciding to run a check that has never been run.
5. **The constraint/evidence layer is absent** for 31 of 43 constraints and 30 of 43 evidence sets (Section 3.2). Even a willing auditor has no artifact to examine for most rules.

Because every constitutional rule can be violated today with no mechanism to observe the violation, **implementation must not begin** on constitutional-enforcement grounds. This verdict does not address project progress; it addresses only whether the constitution can currently police itself, and it cannot.

---

## SECTION 8 — Final Constitutional Verdict

Question: **Is the constitutional architecture now suitable to become the permanent engineering contract for all future implementation?**

**NO.**

Supported only by evidence from prior architecture documents:

1. **`architecture-constitution-stress-test.md`** returned NO: one frozen invariant (I11) is already violated in the accepted baseline; P7's provenance mechanism is circular; P3 and I11 conflict with no reconciliation.
2. **Enforcement coverage (this model, Section 4):** 93.0% of constitutional elements are Level 0 (defined only), average maturity 0.12 of 4.00. A contract that cannot be checked is not a contract.
3. **`architecture-baseline-consolidation-review.md`** §5: traceability chain 5 is BROKEN — P3/I5 (single authoritative aggregate model) has no operational document. The constitution presupposes artifacts that do not exist.
4. **ADR-002 §8:** the impact matrix marks 5 documents Needs Revision and 1 Superseded, and none has been revised or retired — the declarative state the stress test described.
5. **`architecture-closure-decision.md`** §6 and `architecture-governance-freeze.md` §4: the governing authority until ADR-001 exists is the freeze plus the transition plan; Phase 0 is unexecuted, so even the change-control mechanism the freeze depends on is not yet operational.

The constitution is directionally sound — the scenario test returned 0 outright failures and the governance freeze withstood circumvention — but suitability as the **permanent engineering contract** requires internal consistency (resolve P3 vs I11), the removal of the I11 bypass precedent, and the raising of enforcement coverage from 0.12 to the L3/L4 baseline this model specifies. All three are prerequisites, not options; therefore the answer is **NO**.

A permanent engineering contract must be checkable by the engineer who is not diligent, not merely by the reviewer who is. The constitution is not yet that contract.
