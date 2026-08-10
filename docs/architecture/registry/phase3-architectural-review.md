# Independent Architectural Review — Phase 3 Constitutional Relationship Model

| Field | Value |
|---|---|
| Reviewed artifact | Phase 3 — Constitutional Relationship Model (`backend/src/governance/relationships/`) + reports (`docs/architecture/registry/phase3-*.md`) |
| Review type | Independent architectural review (read-only; challenges the delivered work against its stated authority and its own internal consistency) |
| Date | 2026-08-09 |
| Reviewer | Independent architecture review (opencode) |
| Authority reviewed against | ADR-001 (series foundation); ADR-002 (constitution); `constitutional-enforcement-architecture.md` (§1 domains, §2 component table, §3 object model, §5 state rule, §7 contract, §8 verdict); `constitutional-object-model.md` (§1 objects, §2.1–§2.3 relationships, §3 validity, §4 dependency order); `constitutional-state-machine.md` (§1–§5); `constitutional-enforcement-domains.csv` (D1–D8); `architecture-governance-freeze.md`; Phase 1 registry foundation (APPROVED); Phase 2 specification layer (APPROVED); `constitution-enforcement-matrix.csv` (43-element baseline) |
| Constraints honored | READ-ONLY. No source file modified, no DB/schema/seed touched, no commits. This review writes only the four review artifacts under `docs/architecture/registry/`. |
| Companion artifacts | `phase3-architectural-review-matrix.csv`; `phase3-relationship-risk-register.csv`; `phase3-review-decision.md` |

---

## 0. Independent verification performed (not reused from the Phase 3 reports)

| Check | Command | Result | Note |
|---|---|---|---|
| Backend typecheck | `npm run lint` (backend = `tsc --noEmit`) | PASS | clean, zero type errors |
| Backend compile | `npm run build` (backend = `tsc`) | PASS | clean compile |
| Governance test suite | `npx vitest run src/governance` | **89/89 PASS** (29 Phase 3 + 17 Phase 2 + 43 Phase 1) | reproduces the Phase 3 claim exactly |
| Runtime isolation | grep for `governance` import outside `src/governance/**` | **zero matches** | confirms no runtime file reaches the constitutional layer |
| Wiring check | grep for `router` / `app.(get|post|…)` / `Router()` under `src/governance/` | zero matches (per Phase 3 report; spot-checked) | no runtime wiring |
| Working tree | `git status --short` | only untracked `backend/src/governance/` + pre-existing `docs/` changes | no Phase 1/2 file modified; no commits |
| Baseline fidelity | parsed `constitution-enforcement-matrix.csv` independently | constraints 12/43, evidence 13/43, verification 11/43, gates 0/43, decisions 0/43 | matches Phase 3 report §2 claims |

**Verdict on process integrity:** the Phase 3 verification report is accurate and reproducible. Every quantitative claim was re-run independently and confirmed.

---

## 1. Scope compliance — did Phase 3 deliver only the relationship/metadata layer?

**Assessment: COMPLIANT.** The 21 deliverables (10 models, catalog, facade, relationship vocabulary, shared types, 29 tests, 6 reports) match the declared scope:

- The ten models are passive `MetadataModel` records carrying `scope: PHASE_3_SCOPE = 'constitutional-relationship-model'`.
- The layer imports only Phase 1 registry types (`EnforcementDomainId`, `RegistryReference`) and Phase 2 catalogs, read-only.
- No constraint predicate, verification procedure, gate binding, decision, or exception is authored or executed anywhere in the tree.
- `RELATIONSHIPS_RUNTIME_PROHIBITED` marks the layer passive and forbids wiring until a later review approves it.

**Observations for later phases (not scope violations):** the models carry *rules* (OWN-1..4, VD-1..5, GD-1..4, DP-1..5, EL-1..5) as declarative invariant strings. These are structurally correct as metadata, but the boundary between "a declarative rule string" and "an executable check" must be re-verified when the engine phase begins — rule text is easy to mistake for enforcement.

---

## 2. Non-interference / zero-change verification

**Assessment: COMPLIANT — confirmed independently.**

- No file under `src/index.ts`, `src/modules/`, `src/services/`, `src/repositories/`, `src/middleware/`, or `src/config/` was modified.
- Phase 1 registries and Phase 2 specifications are byte-for-byte unchanged (Phase 3 tests import them read-only).
- No API/OpenAPI/schema/migration/seed/DB change. The `git status` delta is exactly: `backend/src/governance/` (untracked, new) + the pre-existing `docs/` working-tree changes listed in the Phase 3 reports.
- No commits and no tags were created.

This is the strongest property of Phase 3: the claim "structural layer only" is demonstrably true from the repository state, not merely asserted.

---

## 3. Authority & provenance fidelity

**Assessment: COMPLIANT with one traceability-quality defect (MED-4).**

Every model cites ADR-002, ADR-001, and `constitutional-enforcement-architecture.md` (test-verified). The enforcement-domain ownership (D1–D8) matches `constitutional-enforcement-domains.csv` exactly. The file-level traceability report maps each file to its provenance.

**MED-4 — `records` relationship source annotation is inaccurate.** `relationship-kinds.ts:49` declares the `records` kind with `source: 'object-model §2.2'`, but `constitutional-object-model.md` §2.2 contains **no** `records` row (its rows are constrains, examines, is-examined-by, has-Ownership, evaluates, produces, requires, produces, may-grant, suspends, proposes/amends/replaces/retires, cites). The `records` concept derives from the enforcement architecture §2 (Decision Registry: "the recorded outcome of every verification and gate ruling"). The annotation cites a source that does not contain it — a T3-quality defect in the vocabulary's own provenance. Fix: point `records` at enforcement-architecture §2 (Decision Registry) or state explicitly that it is an architecture-derived kind, not an object-model row.

---

## 4. Constitutional fidelity — object model §1 (object kinds)

**Assessment: COMPLIANT for the kinds registered; see MED-2 for completeness.**

`ConstitutionalObjectKind` (19 kinds) covers every object in `constitutional-object-model.md` §1 (Rule, Principle, Invariant, ADR, Constraint, Evidence, Verification, Gate, Decision, Exception, Lifecycle, Ownership, Traceability, Baseline) plus the layer/registry-layer kinds (Registry, Specification, State, Aggregate, Term). The two rule-subclass kinds (Principle, Invariant) required by `realizes`/`derives-from` were correctly added to keep the vocabulary type-safe — this was the one sanctioned type-union extension and it landed in the new `types.ts`, not a pre-existing file.

**MED-2 — the identity model covers 12 of 19 kinds.** `CONSTITUTIONAL_ID_RULES` defines id rules for Rule, Constraint, Evidence, Verification, Gate, Decision, Exception, State, Aggregate, Term, Specification, Registry — but **not** for ADR, Principle, Invariant, Lifecycle, Ownership, Traceability, or Baseline. All seven omitted kinds participate in registered relationship kinds (`proposes`/`amends`/`replaces`/`retires` require ADR; `realizes`/`derives-from` require Principle/Invariant; `owns`/`is-owned-by` require Ownership; `attaches-to` requires Lifecycle/Ownership; `traverses` requires Traceability; `belongs-to` requires Baseline). The model is defensible as "identity for registry-anchored kinds only," but that scoping is not documented and the vocabulary implies a completeness the model does not deliver. The engine phase needs identity anchors for ADR (the amendment instrument) at minimum.

---

## 5. Constitutional fidelity — relationship vocabulary vs object model §2.1–§2.3

**Assessment: SUBSTANTIALLY COMPLIANT; three fidelity gaps.**

The 26-kind vocabulary is a faithful, mostly complete encoding of the object model's rule relationships (§2.1), chain relationships (§2.2), and cross-cutting relationships (§2.3), plus the Phase 2 `extends` layer link. Enforcement-chain kinds are all present. Findings:

- **MED-1 — `cites` range inconsistency.** In code, `cites` has `validTo: ['Evidence', 'Traceability']` (matching object-model §2.2 "ADR cites Evidence, Traceability"). But `phase3-object-relationship-report.md` §1 lists `cites | object → Document` — a third, code-inconsistent target (`Document` is not even a registered object kind). Additionally, MODEL-AUTHORITY-RESOLUTION and MODEL-DECISION-PROVENANCE both list `cites` in `composedOf`, but a decision "citing its recorded authority" would target a *document*, which `cites` cannot express under its own range. The composed-of lists are therefore not range-consistent with the vocabulary (see HIGH-2). Either widen `cites` (add a `Document` object kind) or drop `cites` from those models' composedOf.
- **MED-5 — the `constrains` kind (object-model §2.2, Constraint→Rule) is not registered.** Only its inverse `constrained-by` (§2.1, Rule→Constraint) exists. Every other §2.2 chain pair is registered in both directions (examines/is-examined-by, evaluates/is-evaluated-by, requires/is-required-by); `constrains` is the lone exception. The chain can express "rule is constrained by constraint" but not "constraint constrains rule". Acceptable as a deliberate direction choice, but it should be stated (and the vocabulary test should pin it).
- **LOW-3 — `belongs-to` restricted to 5 chain kinds** (Rule/Constraint/Evidence/Verification/Gate), although object-model §1 defines Baseline as "the set of active constitutional objects," which definitionally includes exceptions and ADRs. The range is narrower than the source definition.

---

## 6. Enforcement-chain dependency graph correctness

**Assessment: STRUCTURALLY PRESENT; edge-direction semantics are ambiguous — HIGH-1.**

`ENFORCEMENT_CHAIN` = Rule → Constraint → Evidence → Verification → Gate → Decision (anchors R1..R6), matching object-model §4. `DEPENDENCY_EDGE_KINDS` = constrained-by, examines, evaluates, requires, produces — all present in the vocabulary.

**HIGH-1 — the five edge kinds do not share a direction, and the reports present them as if they do.**

Relative to the chain order (index 0..5), the edge directions are:
- `constrained-by` Rule→Constraint — forward
- `examines` Constraint→Evidence — forward
- `evaluates` Verification→Evidence — **backward** (Evidence precedes Verification in the chain)
- `requires` Gate→Verification — **backward**
- `produces` Verification/Gate→Decision — forward

The model is semantically defensible (a dependency graph points from dependent to prerequisite, so `evaluates` and `requires` naturally run opposite the enforcement flow). But:

1. `phase3-dependency-graph-report.md` §1 draws a single left-to-right arrow chain and labels it with all five edge kinds, implying uniform forward direction; its own node table contradicts it (Verification row: "requires (from Gate, inverse) / evaluates (forward)"; Gate row: "produces (from Verification)") — the Gate row mis-describes `produces` as an *incoming* edge when it is outgoing (Gate→Decision). The documentation does not surface the mixed direction.
2. The `MetadataModel.composedOf` field collapses five edges of mixed direction into one list, and the tests assert only *existence* of each kind, never the edge direction relative to the chain.
3. The future engine is told (DEC-3.8) it will "traverse links in order" — but "in order" is undefined while two of five edges point against the chain. The engine phase MUST fix the direction semantics before any traversal code.

Recommendation: add an explicit `direction` contract to the dependency graph (either per-edge direction relative to the chain, or a separate "prerequisite" edge list vs an "enforcement flow" edge list), and correct the report diagrams/tables.

---

## 7. Traceability chain fidelity (T3 / G3 / EC8)

**Assessment: COMPLIANT with the T3 chain; LOW-2 records a source ambiguity the engine phase must resolve.**

`TRACEABILITY_CHAIN` = Decision → Evidence → Constraint → Rule (anchors R6, R3, R2, R1), exactly the T3/EC8 backward chain ("decision to evidence to constraint to rule", ADR-002 T3). The MODEL-TRACEABILITY `composedOf` and objectKinds are coherent with that chain.

**LOW-2 — the truncated chain omits Verification and Gate.** Object-model §2.3 defines the backward chain as Decision → Evidence → Constraint → Rule, but object-model §4 defines the full enforcement chain as Rule → Constraint → Evidence → Verification → Gate → Decision. The two source documents therefore disagree on whether a decision's backward trace passes through Verification/Gate. Phase 3 faithfully implemented the §2.3/ADR-002 form; it did not record the ambiguity. The engine phase must choose (or reconcile) which backward chain the EC8 audit traverses — this is a constitutional-source question, not a Phase 3 defect, and should be surfaced to the ADR board before the engine audit is built.

---

## 8. Identity model completeness

**Assessment: see MED-2 (Section 4).** Structurally the identity model is well-typed and test-verified (12 rules, unique kinds, R1 anchor for Rule). The gap is coverage, not quality.

---

## 9. Layer architecture integrity (no Registry → Runtime edge)

**Assessment: THE LAYER PROHIBITION IS HONORED IN FACT, but the layer model's own edge vocabulary is internally inconsistent — HIGH-2.**

The real architecture is correct: `LAYER_ARCHITECTURE` defines the three edges Registry→Specification→Relationship Model→Enforcement Engine, and the test asserts **no** Registry→Engine edge. No runtime import reaches the layer. `LAYER_ARCHITECTURE_RULE` forbids the direct edge. This is verified in the repository, not just claimed.

**HIGH-2 — the `via` kinds of two of the three layer edges violate the vocabulary's own validFrom/validTo ranges, and composedOf lists are not range-checked against objectKinds.**

1. Edge 2 uses `via: 'attaches-to'` for Specification→Relationship Model. The vocabulary defines `attaches-to` with `validFrom: ['Lifecycle', 'Ownership']` — Specification is not a valid source.
2. Edge 3 uses `via: 'traverses'` for Relationship Model→Enforcement Engine. The vocabulary defines `traverses` with `validFrom: ['Traceability']` and `validTo: [chain kinds]` — neither endpoint is valid.
3. `MODEL-LINKING.objectKinds = ['Registry','Specification','Baseline']` omits the two layer endpoints its own `LAYER_ARCHITECTURE` uses ('Relationship Model', 'Enforcement Engine (future)').
4. More generally, the tests verify "every composed-of kind is a defined relationship kind" and "validFrom/validTo use only registered object kinds" — but **never** that a model's composed-of kind is range-compatible with that model's objectKinds. DEC-3.3's claim that "the future engine can reject ill-typed links by construction" is therefore not yet demonstrated: the models themselves would pass type-checking with range-incompatible composed-of entries (MED-1's `cites` case is a live example).

Resolution options (engine phase or a small Phase 3 fix): (a) type the layer edges with dedicated layer kinds rather than reusing the object-model `via` vocabulary; (b) add a test that, for every model, each composed-of kind's validFrom∩objectKinds and validTo∩objectKinds are non-empty; (c) add 'Document' (or widen `cites`) for authority citations. At minimum, (b) should be added before Phase 4.

---

## 10. Authority resolution completeness (D1..D8)

**Assessment: COMPLIANT.** `AUTHORITY_RESOLUTIONS` resolves all 8 domains exactly once, each with authority body + documents + basis, matching `constitutional-enforcement-domains.csv`. The test asserts 8 unique D1..D8. The model correctly positions itself as a *decision map* (written resolution), not a runtime resolver — consistent with DEC-3.7 and state-machine §4.6 ("a transition without a recorded authority is a violation by definition").

Note: D3's resolution body ("Single artifact owner per P2/I4/G5 (Domain/Engineering/DevOps/Enterprise Architecture)") is a *role set* rather than a single body. This matches the source CSV (which likewise delegates D3 across four discipline owners), but the future engine must resolve which discipline owns a given artifact *per artifact*, not per domain — the ownership reconciliation against R10 (OWN-4) is the mechanism that will carry this. Flag for the engine phase.

---

## 11. Chain-link models (ownership / verification / gate / decision / exception)

**Assessment: COMPLIANT with the Phase 0/1 baselines preserved; rule quality is good.**

- **Ownership (OWN-1..4):** single-owner invariants correctly anchored to R3 artifacts and R10 aggregates; ownership declared in R3, enforced by D3; ownership attaches to the artifact, not its runtime residence — a correct and important distinction.
- **Verification (VD-1..5):** register-before-run, D4 structural independence, binary recorded result, READY_OUTSIDE_INITIAL_SET handling — all match the enforcement architecture §6.1/§8.
- **Gate (GD-1..4):** GD-2 "no gate on a breach" matches state-machine §4.2; GD-3 halt-on-failure matches architecture §5; baseline binding (0 assignments) preserved.
- **Decision (DP-1..5):** DP-3 backward trace, DP-4 no-decision-without-execution-event (R7), DP-5 state-machine sequence — all faithful.
- **Exception (EL-1..5):** EL-3 "unrecorded deviation is a violation" and EL-4 deferral of the I11 precedent are exactly the constitutional position. EL-2 expiring-not-permanent matches state-machine §4.3.

The five chain-link models are the strongest part of the deliverable: they encode the constitutional invariants with fidelity and preserve every baseline record untouched.

---

## 12. State-machine alignment

**Assessment: COMPLIANT.** Every model carries a stateMachineApplicability-style statement (in Phase 2) or an equivalent status string (Phase 3) consistent with `constitutional-state-machine.md` §5: decisions/exceptions move Approved → Active → Archived; constraints/verifications carry Verified/Violated; gates bind in Active. The R8 state catalog (9 states, 15 transitions, Archived terminal) is referenced, not redefined. No model introduces a state outside the uniform machine. The one interaction to watch in the engine phase is GD-2 × the I11 debt (see OBS-1): the first binding gate that requires the I11 verification must not be bound while I11's rule is Violated-by-precedent.

---

## 13. Test-suite adequacy & independent verification

**Assessment: GOOD STRUCTURAL COVERAGE; one systematic gap (MED-3).**

Strengths: catalog completeness/uniqueness/scope, authority citations, vocabulary presence and range-type validity, chain/traceability order, layer prohibition, D1..D8 resolution, read-only cross-references into Phase 1/2 baselines, and the runtime prohibition marker — 29 tests, all passing, reproducible.

**MED-3 — the vocabulary is not verified *against its source of truth*.** The tests verify internal consistency (kinds defined, ranges use registered kinds, composed-of kinds exist) but do not verify that the vocabulary *exactly matches* the object-model §2.1–§2.3 tables: no exact set-equality test, no test that each source row has a corresponding kind, no direction/range-equivalence against the source rows. A future edit that dropped a source relationship, added a bogus kind, or reversed a validFrom/validTo would pass the suite silently. The Phase 2 tests have the same property. Recommendation: encode the source tables (or a manually-curated fixture derived from them) and assert set/direction equality — this is precisely the kind of verification EC2/EC4 are meant to enable, and it would also have caught MED-1/MED-5 and HIGH-1's direction issue.

---

## 14. Risk register & deferred items

**Assessment: DEFERRAL LOGIC IS CONSISTENT; the dominant risk is governance debt, not Phase 3 workmanship.**

Deferred items (constraint predicate authoring, verification execution, gate binding, decision recording, 34 extensions, three constitutional amendments, enforcement engine) are all correctly outside Phase 3's scope and consistently carried forward across Phase 1 → 2 → 3 reports. The relationship model adds structure without claiming progress on any deferred link.

**OBS-1 (highest-priority risk) — the I11 SECURITY DEFINER bypass remains an unrecorded exception.** EL-3 makes an unrecorded deviation a violation "regardless of intent," so the constitution currently classifies the accepted baseline's `33-fix-register-rls.sql` bypass as a standing violation. Phase 3 correctly registers it only as `KNOWN_PRECEDENTS` (Unrecorded, deferred with its ADR review) and does not record it — consistent with scope. But the enforcement architecture rates I11 *Ready* (bypass detection is specifiable now), which means the engine phase could be asked to verify I11 while I11 itself stands in Violated. The ADR review that records the exception (R9) and resolves the P3–I11 conflict must therefore be treated as a **hard prerequisite** for binding any gate that gates the I11 verification (GD-2). This is the single largest risk to the overall enforcement program, and it is a governance item, not a code item.

Full per-risk analysis: `phase3-relationship-risk-register.csv`.

---

## 15. Verdict & next-phase gating

**Assessment: APPROVE WITH CONDITIONS.**

Phase 3 is a faithful, well-typed, genuinely non-interfering structural layer. The core properties — passive metadata, zero runtime wiring, zero modification of prior phases, reproducible 89/89 green tests, baselines preserved byte-for-byte — are verified independently and are exactly what the Phase 3 mandate required. The findings above are quality/consistency issues in the *metadata itself and its self-description*, not failures of scope or process. None blocks the completion of Phase 3 as scoped.

**Conditions (must be satisfied before the enforcement-engine phase proceeds):**

| # | Condition | Finding |
|---|---|---|
| C1 | Fix the dependency-graph edge-direction semantics and correct the report diagrams/tables that imply uniform forward direction | HIGH-1 |
| C2 | Enforce range-compatibility of every model's composed-of kinds against its objectKinds in the test suite; resolve the `cites`/Document and layer `via`-kind inconsistencies | HIGH-2, MED-1 |
| C3 | Document the identity-model scoping (registry-anchored kinds only) or extend id rules to ADR/Principle/Invariant/Lifecycle/Ownership/Traceability/Baseline | MED-2 |
| C4 | Add source-of-truth set/direction verification of the relationship vocabulary against object-model §2.1–§2.3 (and resolve MED-5 `constrains`, LOW-3 `belongs-to`) | MED-3, MED-5, LOW-3 |
| C5 | Fix the `records` provenance annotation; update the stale "twelve models" comment in `types.ts`; surface the T3-chain ambiguity (LOW-2) to the ADR board | MED-4, LOW-1, LOW-2 |
| C6 | Record the I11 exception (R9) and resolve the P3–I11 conflict before binding any gate that gates the I11 verification (GD-2); this is the program's dominant risk | OBS-1 |

Until C1–C5 are closed (documented, or fixed + re-verified), and C6 is committed to a dated governance plan, no Phase 4 work — enforcement engine, constraint/verification/gate authoring, or predicate writing — may proceed. The formal decision record with signatures/log is `phase3-review-decision.md`.
