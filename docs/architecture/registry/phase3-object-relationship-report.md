# Object Relationship Report — Phase 3 Constitutional Relationship Model

> Catalog of the immutable object relationships defined by the Phase 3 relationship layer, with each model's object kinds, composed-of relationship kinds, and cross-references into the Phase 1 registries and Phase 2 specifications. Authority: ADR-001, ADR-002, `constitutional-enforcement-architecture.md`, `constitutional-object-model.md` (§1, §2.1–§2.3), `architecture/registry/phase1-completion-report.md`, `architecture/registry/phase2-completion-report.md`.

## 1. Relationship-kind vocabulary (27 kinds)

| Kind | Valid from → to | Meaning | Source |
|---|---|---|---|
| realizes | Principle → Invariant | A principle is realized by one or more invariants (e.g., P3 realizes I5). | object-model §2.1 |
| derives-from | Invariant → Principle | An invariant is a checkable derivative of a principle. | object-model §2.1 |
| constrained-by | Rule → Constraint | Every rule has at least one operational predicate (constraint). | object-model §2.1 |
| constrains | Constraint → Rule | The predicate that makes the rule falsifiable (inverse of constrained-by; completes the §2.2 chain pair). | object-model §2.2 |
| owns | Rule/Evidence/Aggregate/Term/Registry/Specification → Ownership | Exactly one owning body per object/artifact (P2, I4, G5). | object-model §2.1/§2.3 |
| is-owned-by | Ownership → all | Inverse of owns. | object-model §2.3 |
| belongs-to | Rule/Constraint/Evidence/Verification/Gate/Exception/ADR → Baseline | Active constitutional objects compose Baseline v2 (object-model §1 defines Baseline as the set of active constitutional objects, which includes exceptions and ADRs). | object-model §2.1 / §1 |
| supersedes | changeable → changeable | Via ADR; the old object is deprecated, the new one traces back (T3). | object-model §2.1 |
| is-superseded-by | changeable → changeable | Inverse of supersedes. | object-model §2.1 |
| examines | Constraint → Evidence | The predicate operates on the evidence artifact(s). | object-model §2.2 |
| is-examined-by | Evidence → Constraint | Evidence is inert without a constraint. | object-model §2.2 |
| evaluates | Verification → Evidence | Verification evaluates evidence against the constraint. | object-model §2.2 |
| is-evaluated-by | Evidence → Verification | Inverse of evaluates. | object-model §2.2 |
| requires | Gate → Verification | A gate requires a verification result before an action proceeds. | object-model §2.2 |
| is-required-by | Verification → Gate | Inverse of requires. | object-model §2.2 |
| produces | Verification/Gate → Decision | Verification produces a binary result; a gate produces a ruling. | object-model §2.2 |
| records | Decision → Verification/Gate | A decision records the verification/gate outcome it documents. | enforcement architecture §2 (Decision Registry); §3 (Decision: Records → Verification/Gate) |
| grants | Decision → Exception | A decision grants a sanctioned deviation. | object-model §2.2 |
| suspends | Exception → Rule | An exception suspends the affected rule for its duration. | object-model §2.2 |
| cites | ADR → Evidence, Traceability | An ADR must be traceable to its evidence basis (T3). | object-model §2.2 |
| proposes | ADR → changeable | An ADR proposes a change to a constitutional object. | object-model §2.2 |
| amends | ADR → changeable | An ADR amends a constitutional object. | object-model §2.2 |
| replaces | ADR → changeable | An ADR replaces a constitutional object. | object-model §2.2 |
| retires | ADR → changeable | An ADR retires a constitutional object. | object-model §2.2 |
| attaches-to | Lifecycle/Ownership → all | Lifecycle and Ownership attach to every object/artifact. | object-model §2.3 |
| traverses | Traceability → chain | Traceability traverses the backward chain decision → evidence → constraint → rule. | object-model §2.3 |
| extends | Specification → Registry | A spec kind governs the records of its Phase 1 registry (Phase 2 layer link). | Phase 2 / §2 |

Vocabulary fidelity (condition C4): the 27 kinds are verified against `constitutional-object-model.md` §2.1–§2.3 by a source-of-truth fixture test — every source row is encoded with direction fidelity (direct, or via the documented inverse, e.g. "Rule has Lifecycle" ⇔ `attaches-to`), and the only kinds beyond the source rows are the six documented additions (`is-owned-by`, `is-evaluated-by`, `is-required-by`, `supersedes` inverses; `records` derived from enforcement architecture §2; `extends` Phase 2 layer link). The §2.3 meta-row "Relationship requires source + target" is a descriptive rule, not a registered kind.

## 2. Model catalog (10 models)

| # | Model | Object kinds | Composed of kinds | Purpose (abridged) |
|---|---|---|---|---|
| 1 | MODEL-IDENTITY | Rule, Constraint, Evidence, Verification, Gate, Decision, Exception, State, Aggregate, Term, Specification, Registry, Ownership, Baseline, ADR | owns, belongs-to, extends | Strongly typed constitutional identity: every object kind anchored to the R1..R11/spec/ADR layers via 13 id rules; scoping documented (registry-anchored kinds only; Principle/Invariant/Lifecycle/Ownership/Traceability/Baseline identity deferred to later phases) |
| 2 | MODEL-LINKING | Registry, Specification | extends | Layer pipeline Registry → Specification → Relationship Model → Future Enforcement Engine with no Registry → Runtime edge; pipeline edges typed by dedicated layer kinds `anchors`/`instantiates`/`contracts` (LAYER_EDGE_KINDS), not the object-model vocabulary |
| 3 | MODEL-DEPENDENCY-GRAPH | Rule, Constraint, Evidence, Verification, Gate, Decision | constrained-by, examines, evaluates, requires, produces | Structural dependency graph of the enforcement chain with an explicit per-edge direction contract (DEPENDENCY_EDGE_DIRECTIONS); execution order governed by the graph (P4/I6) |
| 4 | MODEL-TRACEABILITY | Decision, Evidence, Constraint, Rule, Traceability, Verification, Gate, ADR | records, produces, traverses, cites, evaluates, examines, constrained-by | Backward traceability graph decision → evidence → constraint → rule (T3/G3/EC8); EC8 audit chain recorded; §2.3 vs §4 ambiguity surfaced to ADR board (LOW-2) |
| 5 | MODEL-AUTHORITY-RESOLUTION | Rule, Decision, Exception, Ownership, Baseline, Verification, Gate | owns, records | Decision map turning each domain owner D1..D8 into authority body + documents + basis; `cites` dropped (range is ADR → Evidence/Traceability, cannot express decision→document) |
| 6 | MODEL-EVIDENCE-OWNERSHIP | Evidence, Ownership, Aggregate, Baseline | owns, is-owned-by, attaches-to | Single-owner structure for every evidence artifact (P2/I4/G5), enforced by the evidence domain (D3) |
| 7 | MODEL-VERIFICATION-DEPENDENCY | Verification, Constraint, Evidence, Decision, Gate | evaluates, is-evaluated-by, examines, produces, is-required-by | Verification depends on its constraint and the evidence examined; D4 stays structurally independent |
| 8 | MODEL-GATE-DEPENDENCY | Gate, Verification, Decision, Rule | requires, is-required-by, produces | Gate requires verification, halts on failure/non-execution, produces a ruling; no gate on a breach (GD-2) |
| 9 | MODEL-DECISION-PROVENANCE | Decision, Verification, Gate, Evidence, Constraint, Rule, Traceability, Lifecycle | records, produces, traverses, attaches-to | Provenance record every decision must carry: source, authority, record date, backward trace chain; `cites` dropped (review MED-1) |
| 10 | MODEL-EXCEPTION-LINKAGE | Exception, Decision, Rule, Lifecycle, Baseline | grants, suspends, attaches-to | Exception granted by a decision, suspends a rule, carries authority/scope/expiry; `records` dropped (`grants` already expresses the decision→exception link) |

## 3. Cross-references into Phase 1 registries and Phase 2 specifications

| Model | Registry reference (Phase 1) | Specification reference (Phase 2) |
|---|---|---|
| MODEL-IDENTITY | R1 (43 elements), R2..R11 anchors | 6 spec kinds (SPEC-CONSTRAINT … SPEC-EXCEPTION) |
| MODEL-LINKING | R1..R11 (as `Registry` layer) | extends targets per spec kind |
| MODEL-DEPENDENCY-GRAPH | R1..R6 (chain anchors) | SPEC-CONSTRAINT/…/SPEC-DECISION (chain kinds) |
| MODEL-TRACEABILITY | R1, R2, R3, R6 (backward anchors) | SPEC-DECISION (tracesTo shape) |
| MODEL-AUTHORITY-RESOLUTION | D1..D8 domain owners (`registry.ts`) | each spec kind's owner field |
| MODEL-EVIDENCE-OWNERSHIP | R3 (7 artifact types, 13 present sources); R10 (Ownership Registry) | SPEC-EVIDENCE (owningBody field) |
| MODEL-VERIFICATION-DEPENDENCY | R4 (EC1..EC10, all NotRegistered; +I11, G11 outside set) | SPEC-VERIFICATION (inputs/outputs shape) |
| MODEL-GATE-DEPENDENCY | R5 (GATE-01..05, 0 assignments) | SPEC-GATE (requiredVerification/haltOn shape) |
| MODEL-DECISION-PROVENANCE | R6 (0 decisions); R7 (Execution Registry) | SPEC-DECISION (authority/tracesTo shape) |
| MODEL-EXCEPTION-LINKAGE | R9 (1 precedent, I11 Unrecorded) | SPEC-EXCEPTION (scope/expiry/status shape) |

## 4. Baseline state carried (unchanged) by the models

| Baseline | Phase 0/1 value | Phase 3 contribution |
|---|---|---|
| Constraints | 12 present / 31 gap | chain shape, `constrained-by` edge |
| Evidence | 7 artifact types; 13 present / 30 gap | single-owner rules over R3 artifacts |
| Verification | EC1..EC10, 7 Ready / 3 NeedsExtension, all NotRegistered | dependency structure; no procedure run |
| Gates | 5 gates, 0 element bindings, empty requiredVerification | dependency structure; no gate executed |
| Decisions | 0 recorded | provenance shape; no decision recorded |
| Exceptions | 1 precedent, Unrecorded (I11) | linkage structure; no exception granted |
