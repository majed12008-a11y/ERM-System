# C6 / PQ-1 Governance Analysis — Phase 3 Blockers

| Field | Value |
|---|---|
| This report | Documentation-only governance analysis of the two remaining Phase-3 blockers: **C6** (I11 / P3 conflict and the unrecorded SECURITY DEFINER precedent) and **PQ-1** (EC8 audit-chain governance decision). Determines exactly what must be formally decided before Phase 4 can be authorized. |
| Date | 2026-08-10 |
| Scope | Documentation only. No source code, SQL, database, seeds, registries, specifications, relationship-model, API, or commit changes. No Phase 4. |
| Authority cited | ADR-001; ADR-002; ADR-INDEX; `constitutional-enforcement-architecture.md`; `constitutional-object-model.md`; `constitutional-state-machine.md`; `architecture-enforcement-model.md`; `architecture-constitution-stress-test.md`; `architecture-governance-freeze.md`; `architecture-baseline-consolidation-review.md`; `architecture-transition-plan.md`; DOMAIN_MODEL.md; Phase 1 registries; Phase 2 specifications; Phase 3 relationship models; `phase3-review-decision.md`; `phase3-conditions-closure-report.md`; all Phase 3 review artifacts |
| Method | Every claim below is quoted or anchored to a repository artifact. No fact was inferred. No contradiction was silently resolved. No constitution was reinterpreted to make a blocker disappear. |
| Companion artifacts | `c6-pq1-decision-matrix.csv`; `c6-pq1-risk-register.csv`; `c6-pq1-review-decision.md` |

---

# SECTION A — C6 / I11

## A.1 What exactly does P3 require?

P3 (ADR-002 §3, table row "P3 | **Aggregate ownership**"):

> **Aggregate ownership.** Aggregate-level invariants (RULE 11, RULE 12) must be expressible in a single authoritative model, not scattered across policies and repository methods.

Established by: Root Cause A; boundary rejections B1, B7, B3, B8. It is the constitutional **principle** that gave RULE 12 an authoritative home.

## A.2 What exactly does I5 require?

I5 (ADR-002 §5, invariant table):

> Aggregate-level business invariants (RULE 11 terminal-state reachability; RULE 12 evidence DELETE four-factor matrix) are expressible in a single authoritative model and are assertable by verification.

I5 is the **invariant** form of P3: the aggregate model must exist **and** be assertable by verification. DOMAIN_MODEL.md §7/Section 8 states I5 is now satisfiable: "RULE 12 (A02, crossing A01/A09/A18) have authoritative homes with stated invariants."

## A.3 What exactly does I11 require?

I11 (ADR-002 §5, invariant table):

> Schema, RLS, and data are distinct architectural concerns; no single construct may own more than one (RLS remains the sole access-control mechanism per AGENTS.md — never disabled, never bypassed).

I11 is the constitutional **invariant** that makes RLS the sole access-control mechanism, unconditionally: **never disabled, never bypassed**.

## A.4 Where does RULE 12 belong according to the current constitution?

RULE 12 (evidence-DELETE four-factor matrix) is simultaneously mandated into **two homes**, with no reconciliation and no precedence rule:

| Home | Mandated by | Current status |
|---|---|---|
| **1. Single authoritative aggregate model** | P3 (ADR-002 §3), I5 (ADR-002 §5), Governance Freeze §1 ("aggregate-level invariants (RULE 11, RULE 12) live in one authoritative model"), C5 (aggregate model required) | **Provided** by DOMAIN_MODEL.md: A02 Condition aggregate carries "RULE 12 evidence-DELETE four-factor matrix"; A09 Document carries "RULE 12 evidence residence"; §1.1 Policies; V4 (RULE 12 crosses A01/A02/A09/A18); R2 (constraint per aggregate invariant; first constraints from A02 RULE 12). |
| **2. RLS policy layer** | I11 (ADR-002 §5): RLS is the sole access-control mechanism; RULE 12 IS an access-control decision | **Remains** per I11: the matrix is expressed in RLS policy WHERE clauses (`documents.documents` policies, `FOR DELETE USING (false)`, `document_access`, `security.user_roles`) — see `forms/11-architecture-review.md`, `architecture-challenge-review.md`, `change-impact-analysis.md`. |

**The stress test** (`architecture-constitution-stress-test.md` §2, cross-principle conflict) rules:

> P3/I5 require RULE 12 ... to live in a single authoritative model. I11 requires RLS to be the sole access-control mechanism. RULE 12 IS an access-control decision. One rule, two mandated authoritative homes (the aggregate model and the RLS policy layer). The constitution does not define how an access-control matrix can be simultaneously expressed in one model and in row-level policies. ... **Genuine conflict.** The constitution mandates two homes for the same invariant and does not reconcile them.

**DOMAIN_MODEL.md V8** (Section 6) records:

> Constitutional conflicts (not model violations): P3 vs I11 conflict (RULE 12's two mandated homes: aggregate model vs schema/RLS/data distinctness); I11 bypass precedent (SECURITY DEFINER); P7 circularity. **Out of scope for this document; require ADR amendment via the enforcement architecture machinery. The aggregate home required by P3 is now provided here; the RLS home remains per I11.**

**Conclusion:** RULE 12's aggregate home is satisfied; its RLS home remains mandated by I11; **the conflict is not resolved anywhere in the current constitution.**

## A.5 Is the SECURITY DEFINER precedent actually an I11 violation?

**Yes.** The stress test (§3, I11 row) rules explicitly:

> **No — and the violation is already in the accepted baseline.** Registration via `security.fn_register_user` — a SECURITY DEFINER function that bypasses RLS. The sanctioned fix `33-fix-register-rls.sql` is a documented RLS bypass (SECURITY DEFINER), justified by a PostgreSQL 18.3 Windows policy bug. The invariant says "never disabled, never bypassed"; the accepted baseline bypasses it, and the precedent authorizes future SECURITY DEFINER workarounds.

Corroborating authorities:
- `constitutional-enforcement-architecture.md` §2 Exception Registry: "A deviation not recorded here is a violation, regardless of intent."
- `constitutional-object-model.md` §3 rule 6: "An Exception not recorded in the Exception Registry is a violation, regardless of intent (I11 bypass precedent)."
- `constitutional-enforcement-architecture.md` §6.1 rates I11 **Ready** because "the existing bypass is precisely such an observable" (bypass detection is specifiable now).
- `architecture-enforcement-model.md` §5 failure 2: "I11 already violated (SECURITY DEFINER bypass)" — cause: **Missing verification + Missing governance**.

The precedent (`backend/seed/33-fix-register-rls.sql`, function `security.fn_register_user`) exists in the accepted baseline and is registered only as an **unrecorded** precedent in R9 (`backend/src/governance/registries/exception.registry.ts`: `KNOWN_PRECEDENTS` entry `PRECEDENT-I11-SECURITY-DEFINER`, `status: 'Unrecorded'`, authority `'Unrecorded — pending ADR review'`, `expiry: 'Not defined'`; `EXCEPTIONS` is empty).

## A.6 Classification of the precedent

The SECURITY DEFINER precedent is:
- **(c) A historical implementation defect** in origin — a documented workaround for a PostgreSQL 18.3 Windows bug (`FOR INSERT ... WITH CHECK` policies fail silently), accepted into the baseline as a sanctioned fix. This is what AGENTS.md and `33-fix-register-rls.sql` record.
- **(b) A deviation from a frozen invariant**, whose continued legitimacy can only be established as a **constitutional exception** (R9), because the constitution classifies any unrecorded deviation as a violation regardless of intent. It is currently **not** recorded as an exception (only as an unrecorded precedent).
- **(a) Coupled with — but distinct from — the architectural contradiction**: the P3–I11 conflict (RULE 12's two homes). The bypass is a violation of I11; the conflict is a contradiction between P3/I5 and I11. They are two different defects, both named by enforcement-architecture §7 condition 2.
- **(d) Evidence of a governance gap**: no exception was recorded at the time the fix was accepted, so the constitution now classifies the baseline as standing in violation; and there is no bypass-detection verification (Missing verification), so the violation is undetectable by machinery.

**Answer:** the precedent **is** an I11 violation; it is primarily a **historical implementation defect** whose legitimacy must be established as a **constitutional exception**; it is distinct from (but packaged with) the **P3–I11 architectural contradiction**; and both are currently governed by nothing.

## A.7 Does I11 require amendment?

Two paths exist; the architecture requires the amendment path for the bypass:

- **Exception path (no text amendment to I11):** record the deviation as a sanctioned exception; I11 moves to **Suspended** for the exception's scope/expiry (state machine transition 10). The invariant text is unchanged. **But** a Suspended rule may not bind a gate (GD-2), so this alone keeps I11's gate blocked.
- **Amendment path:** `constitutional-enforcement-architecture.md` §7 condition 2 states the I11 bypass precedent "require[s] constitutional amendment — this architecture's ADR/Decision/Exception machinery enables those amendments but does not perform them." `architecture-enforcement-model.md` §8: "requires ... the removal of the I11 bypass precedent" as a prerequisite. An ADR would amend I11 (e.g., a bounded, registered-bypass carve-out for the registration function) or record the exception via a formal ADR.

**Answer:** I11's *text* need not change if the exception route is used, but the architecture (§7) explicitly requires the constitutional-amendment route for the three defects, and C6's requirement is the ADR-board commitment covering both the exception **and** the conflict resolution.

## A.8 Does P3 require amendment?

The P3–I11 conflict requires reconciliation; P3's aggregate requirement itself is already satisfied (DOMAIN_MODEL). The missing piece is a **precedence/reconciliation rule** between the principle (single authoritative model) and the invariant (RLS sole access control) for access-control matrices. The stress test names the missing rule: "no precedence between a principle and an invariant; nothing detects which home an implementer chose."

**Answer:** P3 (or I11, or both, plus a precedence rule) requires amendment — the conflict cannot be resolved by an exception, because an exception governs a deviation, not a contradiction between two frozen rules.

## A.9 Does I5 require amendment?

I5 is the invariant that carries RULE 12 into the single authoritative model. If the reconciliation scopes P3/I5 to the model and declares the RLS policies the enforcement expression of the matrix, I5 needs at most a clarifying amendment (and the precedence rule). If the board instead decides the model is the sole home and RLS policies are mere implementation, then I11 needs the amendment instead.

**Answer:** the exact amendment target (I11 vs P3/I5 vs both + precedence rule) is the ADR board's choice; the minimum is **one amending ADR that reconciles the two homes and states the precedence** between P3/I5 and I11 for access-control matrices.

## A.10 Is a formal exception sufficient?

**No — not for Phase 4.** A formal exception is **necessary** (it governs the existing deviation and lifts the standing Violated classification to Suspended) but **not sufficient**:
1. GD-2 / state-machine rule 2: "A rule in **Violated** or **Suspended** may not bind a Gate (D5)." A recorded exception moves I11 to **Suspended** — still un-bindable. I11's bypass-detection verification therefore cannot be gated while the exception is in force.
2. The P3–I11 conflict remains unresolved — an exception cannot reconcile two frozen rules.
3. This matches C6's wording (`phase3-review-decision.md` §3): "Commit to a dated governance plan to **record the I11 exception (R9) and resolve the P3–I11 conflict before** binding any gate that gates the I11 verification (GD-2)."

## A.11 What authority is required to approve that exception?

- **Owning domain:** D6 (Decision & Exception) — `constitutional-enforcement-architecture.md` §1.
- **Approving body for constitutional decisions:** **Enterprise Architecture (ADR board)** — D6 scope: "Enterprise Architecture (ADR board) for constitutional decisions."
- **Recorded instrument:** the exception must reference an ADR or authority (object-model §2.2: Exception "must reference an ADR or authority"); the state machine transition 10 (Violated → Suspended) lists authority "ADR board / recorded authority (D6)"; ADR-INDEX PQ-2 requires a "Formal ADR committing to the exception and conflict resolution."
- **Series mechanics:** ADR-003+ (ADR-001 §2.1 — numbers never reused; template binding; must be registered in ADR-INDEX).

**Answer:** the Enterprise Architecture (ADR board) via a **formal ADR (ADR-003+)**; a bare R9 registry row without the ADR would not satisfy PQ-2.

## A.12 Can Phase 4 legally create a gate involving I11 while this remains unresolved?

**No.** Three independent reasons:
1. **GD-2 / state-machine rule 2** (`gate-dependency.ts` GD-2; `constitutional-state-machine.md` §4 rule 2): I11 currently stands **Violated** (unrecorded bypass) → may not bind a gate. If the exception is granted, I11 moves to **Suspended** → still may not bind a gate.
2. **Unresolved constitutional contradiction** (P3–I11): enforcement-architecture §7 condition 2 and stress-test §6 make the amendment a prerequisite to a live contract; `phase3-review-decision.md` §4.2 and the closure report prohibit all Phase 4 work until C6 closes.
3. **Ready ≠ legal**: enforcement-architecture §6.1 marks I11 "Ready" (an objective verification is specifiable) — readiness is about specifiability, not about permission to bind a gate. GD-2 still governs the binding.

---

# SECTION B — PQ-1 / EC8

## B.1 Candidates

| # | Candidate chain (backward, decision → rule) | Where stated |
|---|---|---|
| **A** | **Decision → Evidence → Constraint → Rule** (§2.3 short chain; the chain Phase 3 recorded) | `constitutional-object-model.md` §2.3: "Traceability | traverses | Relationship | Decision → Evidence → Constraint → Rule (T3; EC8)." Also enforcement-architecture §2/§3 (Traceability object); decision.specification `tracesTo` (T3 / EC8); `TRACEABILITY_CHAIN` in `traceability-graph.ts`. |
| **B** | **Decision → Gate → Verification → Evidence → Constraint → Rule** (§4 full chain read backward) | Inferred from `constitutional-object-model.md` §4 (enforcement chain Rule → Constraint → Evidence → Verification → Gate → Decision) read backward; the §2.2 map (Verification/Gate both produce Decision). |

## B.2 Exact relationship path for each candidate

Using the Phase-3 vocabulary (`relationship-kinds.ts`; `traceability-graph.ts`; dependency-graph report §3):

**Candidate A** (as recorded by Phase 3, dependency-graph report §3):
```
Decision ──records/produces──► Evidence ──examines──► Constraint ──constrained-by──► Rule
   R6                          R3                      R2                          R1
```
Edges and sources:
| Edge | Kind | Direction | Authoritative source |
|---|---|---|---|
| Decision → Evidence | `records` (via `produces` for verification/gate outcomes) | backward | enforcement-architecture §2 (Decision Registry), §3 (Decision: Records → Verification/Gate); object-model §2.2 (Verification/Gate produces Decision) |
| Evidence → Constraint | `examines` (read backward = `is-examined-by`) | backward | object-model §2.2: "Constraint examines Evidence" |
| Constraint → Rule | `constrained-by` (read backward = `constrains`) | backward | object-model §2.1: "Rule is constrained by Constraint"; §2.2 "Constraint constrains Rule" |

**Candidate B** (full chain, backward):
```
Decision ──produces/records──► Gate ──requires (rev)──► Verification ──evaluates (rev)──► Evidence ──examines (rev)──► Constraint ──constrained-by (rev)──► Rule
   R6                            R5                      R4                          R3                      R2                              R1
```
Edges and sources:
| Edge | Kind | Direction | Authoritative source |
|---|---|---|---|
| Decision → Gate | `records` (gate ruling) / `produces` | backward | object-model §2.2: "Gate produces Decision (the gate ruling, recorded)"; enforcement-architecture §2 Decision Registry |
| Gate → Verification | `requires` (read backward) | backward | object-model §2.2: "Gate requires Verification"; dependency-graph `DEPENDENCY_EDGE_DIRECTIONS` (`requires` = backward) |
| Verification → Evidence | `evaluates` (read backward) | backward | object-model §2.2: "Verification evaluates Evidence"; `evaluates` = backward edge |
| Evidence → Constraint | `examines` (read backward) | backward | object-model §2.2 |
| Constraint → Rule | `constrained-by` (read backward) | backward | object-model §2.1/§2.2 |

## B.3 Comparison against the constitutional sources

| Source | Candidate A (§2.3 short) | Candidate B (§4 full) |
|---|---|---|
| `constitutional-object-model.md` §2.3 | **Explicitly stated**: "Traceability ... Decision → Evidence → Constraint → Rule (T3; EC8)" | Not stated here |
| `constitutional-enforcement-architecture.md` §2/§3 (Traceability) | **Explicit**: "The backward chain decision → evidence → constraint → rule" | Not stated |
| ADR-002 (T3/G3/EC8 as adopted) | AEM §2.3 G3: "Backward traceability: every decision traces to evidence (T3)"; decision.specification `tracesTo` | Compatible with "traces to evidence" but adds Gate/Verification hops |
| `constitutional-object-model.md` §4 (enforcement chain) | Omitted Verification/Gate | Supported as the full chain read backward |
| `constitutional-object-model.md` §2.2 map | Decision is produced by Verification **and** Gate | Supported |
| Transition plan T3 | "Every decision in the target baseline traces to ADR-002 → root-cause → challenge-review → evidence" (document-level chain) | n/a (document-level, distinct concept) |
| Phase-3 vocabulary | `records`, `examines`, `constrained-by` all in range; chain = R6→R3→R2→R1 | Requires `records`+`produces`, `requires`, `evaluates`, `examines`, `constrained-by` — all in range |

## B.4 Is one candidate already constitutionally mandated?

- **Candidate A is the only chain explicitly stated** in the constitutional sources: object-model §2.3 and enforcement-architecture §2/§3 both state `Decision → Evidence → Constraint → Rule`, and both label it T3/EC8. Phase 3 implemented and recorded exactly this chain (C5).
- **Candidate B is an inferred reading** of object-model §4 (the forward enforcement chain read backward) and the §2.2 produces-map. It is defensible but is not stated as the audit chain anywhere.
- The Phase 3 architectural review (LOW-2), the closure report, and this analysis all confirm a **genuine two-way source conflict**: §2.3 states the short chain; §4 implies the full chain. Because the object-model is a frozen constitutional companion, the conflict is a **constitutional-source question**, not a Phase-3 defect.

**Answer:** no candidate is *unambiguously* mandated — Candidate A is explicitly stated (and recorded), Candidate B is implied. The ADR board must select; Phase 3 could not and must not decide unilaterally.

## B.5 The exact decision the ADR Board must make

The board must decide **which chain is the canonical EC8 audit chain for decision provenance**:

- **Option 1 — select Candidate A** (`Decision → Evidence → Constraint → Rule`): confirm the explicit §2.3/T3 chain; record Candidate B as a documented **projection** (the full enforcement chain is the *execution* chain; the audit chain omits the recorded Verification/Gate hops). Engine audits A. **No frozen text needs to change** — the ADR records the interpretation.
- **Option 2 — select Candidate B** (`Decision → Gate → Verification → Evidence → Constraint → Rule`): the audit must traverse Gate/Verification; **object-model §2.3 (and the enforcement-architecture §2/§3 Traceability definition, and the Phase-3 recorded chain) must be amended** to the full chain. This is an amendment of frozen text.

Either way the decision is recorded as a **formal ADR (ADR-003+)** per ADR-INDEX §3 ("Resolved here → decisions are recorded as formal ADRs") and must update: `MODEL-TRACEABILITY` (`traceability-graph.ts`), `MODEL-DECISION-PROVENANCE` (`decision-provenance.ts`), `decision.specification.ts` (`tracesTo`), the dependency-graph report §3, the traceability report, and the object-relationship report.

## B.6 Can PQ-1 be closed without an ADR amendment?

- **If the board selects Candidate A:** **yes** — PQ-1 closes with a **confirmatory ADR** (records the selection and the projection); no frozen text is amended.
- **If the board selects Candidate B:** **no** — closing PQ-1 requires **amending** object-model §2.3 (and the enforcement-architecture §2/§3 Traceability definition, and the Phase-3 recorded chain) via a formal ADR.
- In both cases, the selection itself is a formal ADR per ADR-INDEX §3; only the amendment question differs.

## B.7 Precision note — two "EC8" referents must not be conflated

EC8 appears in the constitution with two meanings:
1. **Exit criterion EC8** (`architecture-transition-plan.md` §9; AEM §2.4): "All 6 traceability chains re-verified, 0 broken" — the six **document-level** chains (Problem → Finding → Root Cause → ADR Principle → Affected Documents) from `architecture-baseline-consolidation-review.md` §5 (5 of 6 were broken; chain 4 intact).
2. **EC8 audit chain** (the Phase-3 meaning; object-model §2.3 label): the **object-level** decision-trace chain that the future engine audits.

PQ-1 resolves meaning 2. Meaning 1 (the document-level 6-chain re-verification) is a separate EC8 verification scope that the engine must also implement, and must not be silently merged with the decision-trace chain. This distinction should be recorded in the PQ-1 ADR.

---

# SECTION C — Phase-4 Readiness

## C.1 Blocking decisions (Phase 4 may not begin until these close)

| # | Decision | Required instrument | Closes |
|---|---|---|---|
| 1 | Record the I11 SECURITY DEFINER exception (target element, scope, authority, expiry, status) **and** resolve the P3–I11 conflict (reconcile RULE 12's two homes; state precedence between P3/I5 and I11) | **Formal ADR-003+** with a dated commitment (ADR-INDEX PQ-2) | **C6** |
| 2 | Select the canonical EC8 audit chain (Candidate A or B); record the other as projection; update the affected relationship/provenance artifacts | **Formal ADR-003+** (ADR-INDEX PQ-1) | **PQ-1** |

Both are **ADR-board decisions**. Neither may be substituted by a documentation note (a real constitutional change requires the ADR process — Governance Freeze §4; stress-test §4).

## C.2 Advisory (not blocking)

- **D3 per-artifact authority resolution** (AUTH-1 note): D3's authority body is a role set; per-artifact ownership must resolve via R10 reconciliation (OWN-4). Advisory for engine design, not a gate.
- **INFO-1..5** from the independent review (e.g., fixture hand-maintained, range overlap semantics, objectKinds over-approximation): advisory engineering notes, no constitutional content.
- **EC8 document-level 6-chain re-verification** (B.7): a verification scope to be implemented by the engine, not a pre-Phase-4 blocker in itself.
- **P7 circularity** (third known defect): separate ADR-track item; does not gate Phase 4 under C6/PQ-1 but must be resolved on its own ADR before the provenance machinery it touches is relied on.

## C.3 Documents that must change after each decision

**After PQ-1 closes (select A or B):**
- `backend/src/governance/relationships/traceability-graph.ts` (`MODEL-TRACEABILITY` — status/recorded chain; if B, the chain itself)
- `backend/src/governance/relationships/decision-provenance.ts` (`MODEL-DECISION-PROVENANCE` — if B)
- `backend/src/governance/specifications/decision.specification.ts` (`tracesTo` meaning — if B)
- `docs/architecture/registry/phase3-dependency-graph-report.md` §3; `phase3-traceability-report.md` §6; `phase3-object-relationship-report.md` (recorded chain + projection)
- `docs/architecture/registry/traceability-register.md` / `registry-implementation-inventory.md` (R6)
- If B: **`docs/constitutional-object-model.md` §2.3** and **`constitutional-enforcement-architecture.md` §2/§3** (amendment)

**After C6 closes:**
- `backend/src/governance/registries/exception.registry.ts` (R9 — record the exception: `EXCEPTIONS` populated with id, targetElement=I11, authority=ADR, scope, expiry, status=Recorded; `KNOWN_PRECEDENTS` entry updated to reference the ADR)
- `backend/src/governance/specifications/exception.specification.ts` (SPEC-EXCEPTION status)
- `docs/architecture/adr/ADR-INDEX.md` (§3 — PQ-2 status → closed; new ADR row)
- If the exception or precedence touches frozen text: **ADR-002 §3/§5** (P3/I5 and/or I11) and/or a precedence rule, via the amending ADR
- `docs/architecture/registry/phase3-*-closure/review` reports (C6 status)

## C.4 Tests/invariants that must be added after each decision

**After C6:**
- R9 test: `EXCEPTIONS` contains exactly one Recorded entry targeting I11, with non-empty authority (ADR ref), scope, expiry, and status `Recorded`; `KNOWN_PRECEDENTS` links to the ADR.
- GD-2 invariant: assert no `GATE_ELEMENT_ASSIGNMENT` binds a gate to the I11 verification while I11 is `Suspended`/`Violated`; assert the binding appears only after the exception record exists and the conflict ADR is registered.
- I11 constraint/verification: bypass-detection constraint (SECURITY DEFINER + disabled-RLS observable) registered in R2/R4 with the exception carve-out applied.
- Precedence rule: a test asserting the reconciliation (RULE 12 model home + RLS enforcement expression) is registered (new/amended rule id).

**After PQ-1:**
- `TRACEABILITY_CHAIN` pinned to the selected chain (A: `['Decision','Evidence','Constraint','Rule']`; B: `['Decision','Gate','Verification','Evidence','Constraint','Rule']`), with the projection recorded in the model status.
- A test asserting the audit chain's edges are all in `RELATIONSHIP_KINDS` ranges and match `DEPENDENCY_EDGE_DIRECTIONS`.
- A test asserting the engine's EC8 audit shape consumes the selected chain (scaffold-level; no execution).

## C.5 What must NOT change

Per the No-Change Boundary (below) and Governance Freeze §3/§4: no runtime code, SQL, database, seeds, registries, specifications, relationship models, or APIs may change as part of closing C6/PQ-1; no commits/tags; no frozen element changes outside the formal ADR process; the existing runtime prohibitions (`RUNTIME_ENFORCEMENT_PROHIBITED`, `SPECIFICATIONS_RUNTIME_PROHIBITED`, `RELATIONSHIPS_RUNTIME_PROHIBITED`) remain in force.

## C.6 Minimum governance work before Phase 4

1. ADR board issues **ADR-003+** recording the I11 exception with a **date**, and resolves the P3–I11 conflict (precedence rule) — closes **C6/PQ-2**.
2. ADR board issues the **PQ-1 ADR** selecting the EC8 audit chain (and, if B, amending object-model §2.3 + enforcement-architecture §2/§3) — closes **PQ-1**.
3. R9/SPEC-EXCEPTION and MODEL-TRACEABILITY/MODEL-DECISION-PROVENANCE updated to reflect both decisions; governance tests (C.4) added and green.
4. The later architectural review confirms closure of C1–C6 per `phase3-review-decision.md` §4 before any Phase-4 work.

---

# NO-CHANGE BOUNDARY (confirmed)

This analysis produced documentation only. Confirmed:

- **No source code changes** — zero files under `backend/src/` modified.
- **No SQL changes** — zero `.sql` files modified.
- **No database changes** — no schema, migration, policy, or data change.
- **No seed changes** — zero seed files modified or executed.
- **No registry changes** — R1–R11 untouched (the I11 precedent remains registered only as Unrecorded; no exception was recorded).
- **No specification changes** — Phase-2 spec kinds untouched.
- **No relationship-model changes** — Phase-3 models untouched.
- **No API changes** — no contract/OpenAPI change.
- **No commits, no tags** — working tree unchanged except these documentation artifacts.

Companion artifacts: `c6-pq1-decision-matrix.csv`, `c6-pq1-risk-register.csv`, `c6-pq1-review-decision.md`.
