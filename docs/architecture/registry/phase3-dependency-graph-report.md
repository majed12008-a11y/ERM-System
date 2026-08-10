# Dependency Graph Report — Phase 3 Constitutional Relationship Model

> Structural report of the constitutional dependency graph defined by the Phase 3 relationship layer: the enforcement chain, its edge kinds, the layer pipeline, and the backward traceability chain. Graph **shape only** — no node is bound and no chain is instantiated; per-rule link presence stays at its Phase 0/1 baseline. Authority: ADR-002 (P4/I6), `constitutional-enforcement-architecture.md` (§2/§3/§4), `constitutional-object-model.md` (§4), `architecture/registry/phase1-completion-report.md`, `architecture/registry/phase2-completion-report.md`.

## 1. Enforcement chain (MODEL-DEPENDENCY-GRAPH)

```
Enforcement flow:   Rule ──► Constraint ──► Evidence ──► Verification ──► Gate ──► Decision
                      R1        R2            R3             R4           R5         R6
```

The five edge kinds do **not** share a uniform direction relative to the enforcement flow (review HIGH-1; corrected per the direction contract in `DEPENDENCY_EDGE_DIRECTIONS`):

| Edge kind | Direction in the graph | Relative to enforcement flow (Rule → … → Decision) |
|---|---|---|
| `constrained-by` | Rule → Constraint | **forward** (0 → 1) |
| `examines` | Constraint → Evidence | **forward** (1 → 2) |
| `evaluates` | Verification → Evidence | **backward** (3 → 2) — prerequisite edge (dependent → evidence) |
| `requires` | Gate → Verification | **backward** (4 → 3) — prerequisite edge (dependent → verification) |
| `produces` | Verification/Gate → Decision | **forward** (3/4 → 5) |

**Traversal contract (condition C1):** the future engine must read the per-edge direction before any traversal — `forward` edges are walked as-is along the flow; `backward` edges are walked reversed. "Traverse links in order" is undefined without this contract; it is now explicit.

| Position | Kind | Registry anchor | Incoming edge (kind, direction) |
|---|---|---|---|
| 1 | Rule | R1 | — (chain head; constitutional source P/I/G/EC) |
| 2 | Constraint | R2 | constrained-by (from Rule, forward) |
| 3 | Evidence | R3 | examines (from Constraint, forward); is-evaluated-by of Verification `evaluates` (backward, see below) |
| 4 | Verification | R4 | is-required-by of Gate `requires` (backward); requires from Gate |
| 5 | Gate | R5 | — (its `requires` runs backward to Verification; its `produces` runs forward to Decision) |
| 6 | Decision | R6 | produces (from Verification and Gate, forward) |

Note the graph nodes are linked by **two kinds of flow**: the enforcement flow (Rule → … → Decision, carried by `constrained-by`, `examines`, `produces`) and the prerequisite edges (`evaluates`, `requires`) that point from a dependent later in the chain back to its prerequisite earlier in the chain.

Edge kinds composing the dependency graph: `constrained-by`, `examines`, `evaluates`, `requires`, `produces` (DEPENDENCY_EDGE_KINDS).

## 2. Layer pipeline (MODEL-LINKING)

```
 Registry ──anchors──► Specification ──instantiates──► Relationship Model ──contracts──► Future Enforcement Engine
   (R1..R11)            (SPEC-CONSTRAINT …              (10 models)                       (not implemented)
                         SPEC-EXCEPTION)
```

- The three edges are the only inter-layer paths, and are typed with **dedicated layer-edge kinds** (`LAYER_EDGE_KINDS`: `anchors`, `instantiates`, `contracts`), not with the object-model `via` vocabulary — the object-model ranges do not cover layer endpoints (review HIGH-2; condition C2).
- The only object-model relationship the linking model composes is `extends` (Specification → Registry), the underlying relationship between a spec kind and the registry it governs.
- **No direct Registry → Runtime connection is permitted** (`LAYER_ARCHITECTURE_RULE`; extends `RUNTIME_ENFORCEMENT_PROHIBITED`, `SPECIFICATIONS_RUNTIME_PROHIBITED`, `RELATIONSHIPS_RUNTIME_PROHIBITED`).
- The future engine consumes the relationship model, never the registries directly.

## 3. Backward traceability chain (MODEL-TRACEABILITY)

```
 Decision ──records/produces──► Evidence ──examines──► Constraint ──constrained-by──► Rule
    R6                            R3                      R2                          R1
```

Direction is backward (T3/G3/EC8): every decision must trace decision → evidence → constraint → rule. The chain is the structural contract the future engine audits recorded provenance against.

**EC8 audit chain recorded by Phase 3 (condition C5):** the recorded audit chain is `Decision → Evidence → Constraint → Rule` (object-model §2.3; ADR-002 T3). The alternative full-chain reading via Verification/Gate (object-model §4) is a known source ambiguity — it has been surfaced to the ADR board (ADR-INDEX pending question PQ-1; review LOW-2) and must be reconciled before the engine builds the EC8 audit.

## 4. Chain-link models

| Model | Depends on | Contributes |
|---|---|---|
| MODEL-EVIDENCE-OWNERSHIP | R3 artifacts; R10 Ownership Registry | single-owner `owns` edges per artifact (P2/I4/G5) |
| MODEL-VERIFICATION-DEPENDENCY | R4 EC procedures; constraints (R2); evidence (R3) | `evaluates`/`examines` edges + D4 independence invariant |
| MODEL-GATE-DEPENDENCY | R5 gates; R4 verifications | `requires`/`produces` edges + halt-on-failure (GD-3), no gate on a breach (GD-2) |
| MODEL-DECISION-PROVENANCE | R6; R7 execution records | `records`/`traverses` edge + backward provenance shape (DP-1..5) |
| MODEL-EXCEPTION-LINKAGE | R9 precedent; R6 decisions | `grants`/`suspends` edge + expiring exception shape (EL-1..5) |

## 5. Graph instantiation state (unchanged)

| Link | Baseline | Phase 3 status |
|---|---|---|
| constraints bound to rules | 12 / 43 | shape defined; no binding |
| evidence present | 13 / 43 (7 artifact types) | shape defined; no new artifact |
| verification registered | 10 / 43 (all NotRegistered; +I11, G11 ready outside set) | shape defined; no procedure run |
| gates bound | 0 / 43 (5 gates, 0 element assignments) | shape defined; no gate executed |
| decisions recorded | 0 / 43 | shape defined; no decision recorded |
| exceptions recorded | 1 precedent, Unrecorded | shape defined; no exception granted |

The dependency graph is a **shape**, not a state: it defines how the future engine will traverse links, while every link remains at its Phase 0/1 baseline. No runtime behavior, no API, no schema, no seed, no database change was made by Phase 3.
