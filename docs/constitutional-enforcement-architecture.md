# Constitutional Enforcement Architecture

| Field | Value |
|---|---|
| Status | COMPLETE — final architectural specification before engineering begins |
| Date | 2026-08-06 |
| Authority | Independent Principal Architect, designing from `architecture-enforcement-model.md` (maturity 0.12/4.00; 0 of 43 elements fully enforced; implementation must not begin until enforcement is defined). Architecture Phase = CLOSED; ADR-002 = constitutional; Baseline v2 = frozen; Governance Freeze = active. |
| Constraints honored | READ-ONLY. Documentation only. No code, SQL, migrations, manifests, commits. No implementation, tooling, or CI. |
| Purpose | Define the enforcement architecture that transforms the constitutional model into an enforceable engineering contract. |
| Companions | `constitutional-object-model.md`, `constitutional-state-machine.md`, `constitutional-enforcement-domains.csv`. |
| Verdict | **YES AFTER IMPLEMENTING THIS ARCHITECTURE.** |

---

## SECTION 1 — Enforcement Domains

The constitution is partitioned into eight enforcement domains. Each domain owns one link of the enforcement chain (rule → constraint → evidence → verification → gate → decision) plus the two cross-cutting concerns (state, execution). Full per-domain detail in `constitutional-enforcement-domains.csv`.

| # | Domain | Responsibility | Scope | Constitutional authority | Enforcement objective |
|---|---|---|---|---|---|
| D1 | **Constitutional Definition** | Own the constitutional rules (P/I/G/EC), the ADR series, the baseline index, and the final vocabulary. Rules enter and leave the constitution only through this domain. | ADR-002; ADR-001; ADR index; baseline v2 index; glossary/vocabulary; document-transition-matrix | Enterprise Architecture (ADR board) | The constitution is complete, versioned, and change-controlled; every rule is registered with a legal state. |
| D2 | **Constraint** | Derive a falsifiable operational predicate for every rule; own the Constraint Registry. A rule with no constraint is not a rule. | All 43 constitutional elements | Enterprise Architecture (ADR board); Domain Architecture for domain-model-derived constraints | Every rule has exactly one checkable constraint. |
| D3 | **Evidence** | Define and curate the artifacts constraints examine; record the ownership of each artifact (P2, I4, G5); own the Evidence Registry. | Aggregate model; business dependency graph; natural-key sets; construction product; dead-data inventory; documents; DB state | Single ownership per artifact (P2, G5): Domain Architecture (models), Engineering Governance (engineering artifacts), DevOps Governance (operational artifacts), Enterprise Architecture (constitutional documents) | Every constraint has a defined, owned, current evidence source. |
| D4 | **Verification** | Define and execute objective procedures evaluating evidence against constraints; record results. Independent of implementers. | EC1–EC10 as the initial verification set; thereafter one procedure per constraint | Independent Enterprise Architecture Review Board | Verification is objective, repeatable, binary, and its results are recorded as Decisions. |
| D5 | **Gate** | Define the binding process points where verification results are enforced (document publication, disposition, ADR approval, construction acceptance, cutover). | Publication; document disposition; ADR approval; construction acceptance; cutover | Engineering Governance (engineering gates); Enterprise Architecture (constitutional gates); DevOps Governance (cutover) | No action passes a gate while a required verification has failed or is unexecuted. |
| D6 | **Decision & Exception** | Record every verification outcome, gate ruling, ADR approval, and sanctioned exception; own the Exception Registry. Exceptions are explicit, bounded, and expiring — never silent. | All decisions about constitutional objects; all exceptions (including the I11 SECURITY DEFINER precedent) | Enterprise Architecture (ADR board) for constitutional decisions; Independent Review Board for verification rulings | Every enforcement outcome is recorded with authority; no deviation exists without a recorded exception. |
| D7 | **Constitutional State** | Own the rule state machine; assign and maintain the legal state of every constitutional object; detect state violations (a rule used while Violated). | All constitutional objects (rules, constraints, evidence, ADRs, decisions, exceptions, gates) | Enterprise Architecture | The current legal status of every constitutional object is known and observable. |
| D8 | **Execution & Provenance** | Record construction/execution events with provenance that survives restore (I2, C3, P7); own the Execution Registry. | Dataset construction; migrations; Installer History; restore events | Engineering Governance / DevOps Governance (single ownership per execution artifact) | Execution evidence survives restore; no decision relies on provenance-less execution state. |

**Domain principle.** Every enforcement act is owned by exactly one domain (G5/T5). The verification domain (D4) is independent of the domains whose artifacts it verifies — independence is a structural property of the architecture, not a procedural courtesy.

---

## SECTION 2 — Enforcement Architecture

The architectural components required to enforce the constitution. **Responsibilities only** — no implementation. Each component is justified by an existing finding; no component is included speculatively.

| Component | Responsibility | Justified by |
|---|---|---|
| **Rule Registry** | The authoritative enumeration of every constitutional rule (P1–P9, I1–I11, G1–G13, EC1–EC10) with its legal state, owner, and supersession history. Nothing is constitutional unless registered. | AEM §2 — 43 elements exist with no single enumeration; G10 (no new documents beyond baseline); EC2 (ADR index). |
| **Constraint Registry** | The checkable operational predicate for each rule: "what does a violation look like?" A rule without a registered constraint is unfalsifiable and therefore not enforceable. | AEM §3.2 — constraints missing for 31 of 43 elements. |
| **Evidence Registry** | The artifacts each constraint examines, their owning body (P2, I4, G5), and their currency. An unregistered evidence source is not admissible as evidence. | AEM §3.2 — evidence missing for 30 of 43; P9/I8 have evidence but no managed registry; ownership table exists but is unenforced (G5). |
| **Verification Registry** | The objective procedure per constraint, its inputs and outputs, its last run, and its result. Verification is registered before it runs; a verification that is not registered does not exist. | AEM §3.2 — verification missing for 32 of 43; EC1–EC10 are defined but unexecuted. |
| **Gate Registry** | The binding process points and the verification each gate requires. A gate with no required verification, or a verification with no gate, is a declaration. | AEM §3.2 — gates missing for 43 of 43. |
| **Decision Registry** | The recorded outcome of every verification and gate ruling, with its authority. Without a decision record, enforcement is unobservable. | AEM §3.2 — decisions missing for 43 of 43; T3/G3 backward traceability requires decision provenance. |
| **Execution Registry** | The record of construction and execution events with provenance that survives restore. No decision may rely on an execution event absent from this registry. | I2, C3, P7; challenge review A1 (ops.seed_tracker untrusted); ADR-002 §2 (provenance is a first-class property). |
| **Architecture State Registry** | The legal state of every constitutional object, maintained by D7 per `constitutional-state-machine.md`. A rule whose state is unknown is not usable. | AEM §4 — no element has a state; lifecycle undefined; the state machine requires a state holder. |
| **Exception Registry** | Sanctioned deviations with their authority, scope, and expiry. A deviation not recorded here is a violation, regardless of intent. | I11 bypass precedent — the accepted SECURITY DEFINER workaround exists with no recorded authority; C12 drift risk. |
| **Ownership Registry** | The owning body of every artifact and datum (P2, I4, G5). Ownership is a declaration made here and enforced by the evidence domain. | P2/I4 (single ownership per datum); G5 (single ownership of governance artifacts); roadmap §4 ownership table. |
| **Vocabulary Registry** | The final vocabulary, the forbidden terms, and the term gate (G4, G11). A term not registered here may not enter an active document. | G4/T4; G11; EC2; EC5; consolidation review §2 (no authoritative registry exists; glossary empty). |

**Component grouping.** The eleven components map to the enforcement chain: Rule (1), Constraint (2), Evidence (3, 10, 11), Verification (4), Gate (5), Decision (6, 9), and the two cross-cutting registries (7, 8). The chain is not satisfied by the existence of the components; it is satisfied only when each rule's links run through them in order.

---

## SECTION 3 — Constitutional Object Model

The conceptual objects inside the constitution, and their relationships. Full treatment in `constitutional-object-model.md`.

The objects and their defining relationships:

| Object | Definition | Relationship |
|---|---|---|
| **Constitutional Rule** | A normative statement (Principle, Invariant, Governance Rule, Exit Criterion). | Is constrained by → Constraint; has → Ownership; has → Lifecycle/State; belongs to → Baseline. |
| **Principle / Invariant / Governance Rule / Exit Criterion** | The four rule subclasses. | Principles realize Invariants; Invariants derive from Principles; Governance Rules govern the process; Exit Criteria certify the transition. |
| **ADR** | The change instrument. | Proposes / amends / replaces / retires → Rules and other objects. |
| **Constraint** | The falsifiable operational predicate of a rule. | Constrains → Rule; examines → Evidence; is evaluated by → Verification. |
| **Evidence** | The artifact a constraint examines. | Is examined by → Constraint; has → Ownership; is cited by → Traceability. |
| **Verification** | The objective procedure binding evidence to a constraint. | Evaluates → Evidence against → Constraint; produces → Decision; is required by → Gate. |
| **Gate** | The binding process point. | Requires → Verification; produces → Decision; halts action on failure. |
| **Decision** | The recorded outcome with authority. | Records → Verification/Gate outcome; may grant → Exception. |
| **Exception** | A sanctioned deviation with authority, scope, expiry. | Is granted by → Decision; suspends → a Rule; must reference → an ADR or authority. |
| **Relationship** | A typed link between objects (derives, realizes, constrains, verifies, owns, supersedes). | Connects all objects; a link without a source and target is invalid. |
| **Lifecycle** | The history of an object's states. | Attaches to → every object; governed by → the State Machine. |
| **Ownership** | The single owning body of an object. | Attaches to → every artifact/datum (P2, I4, G5); exactly one owner. |
| **Traceability** | The backward chain decision → evidence → constraint → rule. | Traverses → Relationships; required by → T3/G3/EC8. |
| **Baseline** | The set of active constitutional objects (Baseline v2). | Is composed of → active rules, their constraints, evidence, and verification. |

**Relationship rule.** A constitutional object is *operationally real* only when the objects it is defined against also exist: a Rule with no Constraint, a Constraint with no Evidence, a Verification with no registered procedure, a Gate with no required Verification, a Decision with no authority — each is an empty statement, not an object.

---

## SECTION 4 — Constitutional Lifecycle

The lifecycle of every constitutional object. Applied uniformly to rules, constraints, evidence, verification procedures, gates, ADRs, decisions, and exceptions (differences noted).

| Stage | Definition | What happens |
|---|---|---|
| **Creation** | The object is written, not yet constitutional. | Drafted by its owner (D1 for rules; D2 for constraints; D3 for evidence; D4 for verification; D5 for gates). Entered into the appropriate registry as **Draft**. |
| **Approval** | The object becomes constitutional. | The owning authority approves it — for rules and ADRs, the ADR board; for verification, the Independent Review Board; for evidence, its single owner (P2). Entered as **Approved**. |
| **Activation** | The object becomes binding. | The object is bound to the rest of the chain: a rule is linked to its constraint, a constraint to its evidence and verification, a verification to its gate. Entered as **Active**. Until activation a rule governs nothing. |
| **Verification** | The object is checked against its constraints. | The verification procedure runs (D4); the result moves the object to **Verified** or **Violated**. Verification recurs according to the procedure's registered frequency or trigger. |
| **Exception** | A sanctioned deviation is granted. | The ADR board (or recorded authority) grants an exception with scope and expiry; the affected rule moves to **Suspended** for the exception's duration. Exceptions are recorded in the Exception Registry, never silent. |
| **Replacement** | The object is superseded. | A new ADR replaces the object; the old object is marked **Deprecated** — no new obligations, history preserved (T6). The replacement records backward traceability to what it replaced (T3). |
| **Retirement** | The object leaves the active constitution. | The deprecated object is archived **verbatim** (T8); the archive manifest records disposition, date, and replacement. Entered as **Archived** — immutable history, never authoritative for implementation (closure decision §4). |

**Lifecycle rule.** No object may be activated without passing Approval; no object may be retired without passing through Deprecated; no active object may be deviated from except through a recorded Exception. The lifecycle is the same for every constitutional object so that no object has a hidden state.

---

## SECTION 5 — Constitutional State Machine

The legal states for constitutional rules, and their legal transitions. Full state definitions and transition table in `constitutional-state-machine.md`.

| State | Meaning |
|---|---|
| **Draft** | Written; not constitutional; binds nothing. |
| **Proposed** | Submitted for ADR approval; under review. |
| **Approved** | Accepted as constitutional; not yet bound to verification. |
| **Active** | Binding; linked to its constraint, evidence, and verification. |
| **Verified** | Active and last verification passed. |
| **Violated** | Active and last verification failed, or a violation was detected. |
| **Suspended** | Active obligations deferred by a recorded Exception. |
| **Deprecated** | Superseded; creates no new obligations; history preserved. |
| **Archived** | Retired; immutable history; terminal for normal use. |

**Legal transitions.**

| From | To | Condition |
|---|---|---|
| Draft | Proposed | Submitted to the ADR board. |
| Proposed | Approved | ADR accepted. |
| Proposed | Draft | Rejected or returned for revision. |
| Approved | Active | Verification bound; gate assigned. |
| Approved | Deprecated | Superseded before activation. |
| Active | Verified | Verification passed. |
| Active | Violated | Verification failed or violation detected. |
| Verified | Violated | Subsequent verification failed. |
| Violated | Verified | Remediation passed re-verification. |
| Violated | Suspended | Exception granted with scope and expiry. |
| Violated | Deprecated | Replaced by ADR while violated. |
| Suspended | Active | Exception expired or lifted. |
| Suspended | Deprecated | Replaced while suspended. |
| Deprecated | Archived | Retirement executed; archive manifest recorded. |
| Archived | (none) | Terminal. Revival requires a new ADR (a new object). |

**State rule.** A rule in **Violated** or **Suspended** may not bind a Gate (D5) — no action may pass a gate on a violated or suspended rule. A rule in **Draft**, **Proposed**, or **Approved** binds nothing. The current state of every rule is held in the Architecture State Registry and is observable; an unverifiable state claim is a violation of the state machine.

---

## SECTION 6 — Enforcement Readiness

Whether every constitutional element can eventually become automatically enforceable. Full per-element required levels in `constitutional-maturity-model.csv`; the classification tables below are the authoritative readiness assessment.

| Classification | Meaning |
|---|---|
| **Ready** | An objective verification is specifiable today from existing definitions. |
| **Needs Extension** | A prerequisite artifact, rule amendment, or authority must exist first (per AEM §5 causes). |
| **Impossible** | No objective verification can ever exist. |

**Distribution: 9 Ready / 34 Needs Extension / 0 Impossible.**

### 6.1 Ready (9)

| Element | Why ready |
|---|---|
| I11 | Bypass detection is specifiable now: SECURITY DEFINER functions and disabled RLS are observable in the accepted baseline (the existing bypass is precisely such an observable). |
| G11 | Forbidden-terminology check defined (transition plan §6.4; EC5). |
| EC1 | File existence + approval record. |
| EC2 | Non-empty + final-vocabulary term-set comparison. |
| EC3 | Grep of DOMAIN_MODEL for Aggregate, Aggregate Root, Application/Condition roots. |
| EC5 | Forbidden-terms grep. |
| EC6 | Cutover-checklist grep for seed-status gating. |
| EC7 | Citation grep for SREA / dataset-architecture. |
| EC10 | ADR-index mapping-table presence. |

### 6.2 Needs Extension (34)

All 9 principles (P1–P9), 10 invariants (I1–I10), 12 governance rules (G1–G10, G12, G13), and 3 exit criteria (EC4, EC8, EC9). Representative reasons:

| Element | Required extension | Cause (AEM §5) |
|---|---|---|
| P1 | Construction product (canonical-dataset-specification + construction evidence) so "dataset is truth" is observable. | Missing evidence, Missing enforcement |
| P2 / I4 / G5 | Ownership Registry. | Missing evidence, Missing verification |
| P3 / I5 | Authoritative aggregate model (DOMAIN_MODEL amendment). | Missing evidence, Missing verification |
| P4 / I6 | Business dependency graph artifact. | Missing rule, Missing evidence |
| P5 / I7 | Lifecycle stage registry and authority. | Missing rule, Missing governance |
| P6 / I10 | Natural-key sets. | Missing evidence |
| P7 | **A rule amendment (ADR)** defining the provenance anchor. Without it, P7 is impossible; the extension is constitutional, not artifactual. | Missing rule, Missing evidence |
| P8 / I9 | Behavior formalizations (reachability, ownership matrices). | Missing evidence, Missing verification |
| P9 / I8 | Consumer-measurement window + retirement authority. | Missing rule, Missing ownership |
| G1 | Document-classification mechanism. | Missing verification, Missing governance |
| G2 | ADR hierarchy verification. | Missing governance |
| G3 / EC8 | Decision/evidence provenance records to audit chains against. | Missing verification |
| G4 | Vocabulary Registry term gate. | Missing enforcement |
| G6 | Archive manifests. | Missing enforcement |
| G7 | Milestone/ordering verification. | Missing governance |
| G8 | Immutability check (content-addressed archive). | Missing governance |
| G9 / G10 / G12 / G13 | Rule Registry + ADR gate. | Missing enforcement |
| EC4 | Repeatable consistency-matrix re-audit. | Missing verification |
| EC9 | Verdict-consistency contradiction check; semantic residue remains human. | Missing verification |

### 6.3 Impossible (0) — with the enforceability boundary stated

No element is impossible to make at least partially automatable. The boundary is explicit: enforcement operates on **observable artifacts**, not intent. For intent-bearing rules the objective constraint is automatable, but the residual semantic judgment (e.g., whether an engineer *treated* the suite as the product under P1, whether an assessment verdict is *genuinely* ADR-002-consistent under EC9, whether provenance is *authentic* under P7) is inherently human and no architecture can remove it. This residue is the permanent L1 component of enforcement; it does not make the element Impossible because every such rule also has an automatable observable constraint.

---

## SECTION 7 — Engineering Contract

Whether this architecture is sufficient to become the permanent engineering contract for every future implementation activity.

**Sufficiency as a frame — yes.** The architecture supplies every element the AEM found missing:

- A domain owner and a component for each link of the enforcement chain (Sections 1–2).
- An object model in which every constitutional concept has defined relationships (Section 3; `constitutional-object-model.md`).
- A lifecycle and a state machine giving every rule a legal, observable status (Sections 4–5).
- A readiness classification showing exactly which prerequisites remain (Section 6).

**Sufficiency as a live contract — no, not yet.** The architecture is a specification, and three conditions must hold before it binds engineering:

1. **Acceptance.** This architecture must itself be accepted as constitutional (an ADR / closure decision), placing it in Baseline v2 alongside the Governance Freeze.
2. **Amendment of the three defects the stress test identified.** The P3–I11 conflict (RULE 12's two mandated homes), the I11 bypass precedent, and the P7 circularity require constitutional amendment — this architecture's ADR/Decision/Exception machinery enables those amendments but does not perform them.
3. **Execution of the 34 extensions.** The registries must be populated, the 9 Ready checks bound to gates, and the Phase 0–5 artifacts (aggregate model, dependency graph, natural keys, construction product) must exist.

Until these three conditions are met, the architecture is the **contract's enforcement frame**, not an operative contract. Engineering activity that constructs the frame is authorized; engineering activity that constructs the product is gated on the frame being live.

---

## SECTION 8 — Final Verdict

Question: **Can engineering finally begin after this architecture is accepted?**

**YES AFTER IMPLEMENTING THIS ARCHITECTURE.**

Supported only by evidence from prior documents:

1. **`architecture-enforcement-model.md`** §4.2: average maturity 0.12 of 4.00; 93.0% of elements at Level 0; 0 of 43 elements have complete enforcement. Acceptance of a specification does not by itself move a single element off Level 0 — enforcement becomes real only when the registries, constraints, verifications, and gates of this architecture are implemented and bound. Hence engineering (product construction) cannot begin at acceptance.

2. **`architecture-enforcement-model.md`** §7: the AEM ruled "implementation MUST NOT begin until enforcement architecture is defined." That precondition is satisfied **in principle** by this document — the enforcement architecture now exists. The gate the AEM imposed is therefore satisfiable, but only by implementing it.

3. **`architecture-constitution-stress-test.md`** §6: three constitutional defects (P3 vs I11 conflict; I11 bypass; P7 circular provenance) cannot be resolved by enforcement machinery alone — they require constitutional amendment. This architecture provides the ADR/Decision/Exception machinery that makes such amendments legitimate and recorded; it does not itself amend the constitution. Until those amendments exist, the contract contains unresolved contradictions.

4. **`constitutional-enforcement-architecture.md`** §6 (this document): 34 of 43 elements require extension before automatic enforcement; 9 are Ready. The engineering phase that builds the 34 extensions — the registries, the artifacts, the gates, the amendments — is the implementation of this architecture. Only after that implementation is complete may feature engineering proceed under an enforceable contract.

**Conclusion.** Engineering of the enforcement architecture (the constitutional enforcement phase: registries, constraints, verification, gates, and the three amendments) may begin upon acceptance of this architecture. Product engineering (RC4 feature construction) may begin only after the enforcement architecture is implemented and live. The answer is therefore **YES AFTER IMPLEMENTING THIS ARCHITECTURE** — the enforcement architecture is the missing link between the declarative constitution and the enforceable engineering contract, and it must be built before it can bind.
