# Phase 3 Conditions Closure Report — Constitutional Relationship Model

| Field | Value |
|---|---|
| Decision | DECISION-P3-001 — APPROVED WITH CONDITIONS C1–C6 (`phase3-review-decision.md`, 2026-08-09) |
| This report | Closes C1–C5 (code + tests + reports). Records C6 as OPEN (governance, ADR board). |
| Date | 2026-08-09 |
| Authority | ADR-001; ADR-002; `constitutional-enforcement-architecture.md`; `constitutional-object-model.md`; `constitutional-state-machine.md`; `architecture-governance-freeze.md`; Phase 1/2 approvals |
| Basis | `phase3-architectural-review.md` (findings HIGH-1, HIGH-2, MED-1..5, LOW-1..3, OBS-1); `phase3-architectural-review-matrix.csv`; `phase3-relationship-risk-register.csv` |
| Scope | Engineering closure of review conditions. **Not** an ADR; does not amend the constitution; does not authorize Phase 4. The later architectural review required by the decision must confirm this closure. |

---

## 1. Condition closure — C1..C5

### C1 — Dependency-graph edge-direction semantics (HIGH-1) — CLOSED

**Finding:** the five edge kinds do not share a direction; `evaluates` (Verification→Evidence) and `requires` (Gate→Verification) point opposite the chain order while reports drew uniform forward arrows and mislabeled the Gate row's incoming edge. The engine had no traversal contract.

**Fix (`backend/src/governance/relationships/dependency-graph.ts`):**
- Added `DEPENDENCY_EDGE_DIRECTIONS`, an explicit per-edge traversal contract:
  - forward (enforcement flow): `constrained-by`, `examines`, `produces`
  - backward (prerequisite): `evaluates`, `requires`
- `EnforcementChainDirection` union pins the two direction classes.

**Reports:** `phase3-dependency-graph-report.md` §1 corrected (mixed-direction table + traversal contract), §2 layer pipeline, §3 EC8 audit chain.

**Test:** `relationships.test.ts` direction assertions cover the five dependency kinds and both direction classes.

### C2 — Range compatibility + `cites`/Document + layer via-kinds + MODEL-LINKING (HIGH-2, MED-1) — CLOSED

**Findings:** model composed-of kinds were never range-checked against the model's own objectKinds (so `cites` in MODEL-AUTHORITY-RESOLUTION / MODEL-DECISION-PROVENANCE could not express its intent); layer edges used `attaches-to`/`traverses` outside their vocabulary ranges; MODEL-LINKING objectKinds omitted its own endpoints.

**Fixes:**
- `relationship-kinds.ts` / `linking-model.ts`: layer edges now use dedicated kinds `LAYER_EDGE_KINDS` = `anchors` (Registry→Specification), `instantiates` (Specification→Relationship Model), `contracts` (Relationship Model→Future Enforcement Engine) — outside the object-model vocabulary, which does not cover layer endpoints.
- `linking-model.ts` MODEL-LINKING: composed-of `extends`, objectKinds `Registry`/`Specification` (its own endpoints).
- `authority-resolution.ts` and `decision-provenance.ts`: `cites` dropped from composedOf — its range (ADR → Evidence/Traceability) cannot express a decision→document authority link (MED-1); the decision's authority is already carried by `records`/`owns`.
- `exception-linkage.ts`: `records` dropped — `grants` already expresses the decision→exception link.
- `object-identity.ts` / `traceability-graph.ts`: objectKinds aligned so every composed-of kind has both sides inside the owning model's objectKinds.

**Test:** range-compatibility assertion for every model — each composed-of kind's validFrom and validTo intersect the model's objectKinds on both sides. Plus a dedicated layer-edge test (3 ordered edges, no Registry→Engine edge).

### C3 — Identity-model scoping (MED-2) — CLOSED

**Finding:** 12 id rules covered 12 of 19 object kinds; ADR, Principle, Invariant, Lifecycle, Ownership, Traceability, Baseline had no identity anchors.

**Fix (`backend/src/governance/relationships/object-identity.ts`):**
- Added an ADR id rule — `CONSTITUTIONAL_ID_RULES` now has 13 rules (the amendment instrument is identity-anchored, as the decision required at minimum).
- Documented the scoping explicitly: identity covers **registry-anchored kinds only**; Principle/Invariant/Lifecycle/Ownership/Traceability/Baseline identity is deferred to later phases.
- objectKinds widened to include Ownership/Baseline/ADR.

**Test:** id-rule count pinned at 13; scoping documented in the module.

### C4 — Source-of-truth vocabulary verification + `constrains` + `belongs-to` (MED-3, MED-5, LOW-3) — CLOSED

**Findings:** tests verified internal consistency but never compared the vocabulary to object-model §2.1–§2.3 (exact set/direction/range); `constrains` (Constraint→Rule) was unregistered while every other §2.2 chain pair had both directions; `belongs-to` was narrower than the §1 Baseline definition.

**Fixes:**
- `relationship-kinds.ts`: registered `constrains` (Constraint→Rule), the §2.2 inverse of `constrained-by`; widened `belongs-to` to Rule/Constraint/Evidence/Verification/Gate/**Exception**/**ADR** per the §1 Baseline definition (LOW-3). Vocabulary is now **27 kinds**.
- `types.ts`: `constrains` added to the relationship-kind union.

**Test (`relationships.test.ts`):**
- `RELATIONSHIP_SOURCE_FIXTURE` encodes the object-model §2.1–§2.3 rows with direction fidelity (direct or via the documented inverse); `DOCUMENTED_VOCABULARY_EXTRAS` = `['is-owned-by','is-evaluated-by','is-required-by','supersedes','records','extends']`.
- Set-equality assertion: vocabulary (27) = fixture ∪ extras, disjoint.
- `constrains` pinned in the §2.2 chain-pair test; `belongs-to` range pinned to include Exception/ADR.

### C5 — `records` provenance + stale comment + T3-chain ambiguity + EC8 chain (MED-4, LOW-1, LOW-2) — CLOSED

**Fixes:**
- `relationship-kinds.ts`: `records` source re-annotated from the inaccurate `object-model §2.2` (which has no such row) to `enforcement architecture §2 (Decision Registry); §3 (Decision: Records → Verification/Gate)` (MED-4).
- `types.ts`: the stale "twelve models" comment corrected (LOW-1).
- `traceability-graph.ts` + `phase3-dependency-graph-report.md` §3: the EC8 audit chain recorded as `Decision → Evidence → Constraint → Rule` (object-model §2.3; ADR-002 T3).
- `traceability-graph.ts` + `phase3-traceability-report.md` §6 + `ADR-INDEX.md` §3: the §2.3 vs §4 chain ambiguity (LOW-2) surfaced to the ADR board as **pending question PQ-1** — which chain the EC8 audit traverses is a constitutional-source decision, not a Phase 3 defect.

## 2. Condition status — C6 (OBS-1) — **OPEN**

The I11 SECURITY DEFINER bypass remains an unrecorded exception (R9, `KNOWN_PRECEDENTS`, EL-3 standing violation), and the P3–I11 conflict is unresolved. This is a **governance item, not a code item**: it is closed only by a recorded ADR-board commitment, with a date, to record the I11 exception and resolve the conflict **before** binding any gate that gates the I11 verification (GD-2). Surfaced to the ADR board as **pending question PQ-2** in `ADR-INDEX.md` §3. Phase 3 correctly did not record the exception itself (scope: register the precedent only).

## 3. Re-verification (post-closure, 2026-08-09)

| Command | Result |
|---|---|
| `npm run lint` (backend = `tsc --noEmit`) | **PASS** — no type errors |
| `npm run build` (backend = `tsc`) | **PASS** — clean compile |
| `npx vitest run src/governance/relationships/__tests__/relationships.test.ts` | **40/40 PASS** (29 original + 11 review-condition tests) |
| `npx vitest run src/governance` | **100/100 PASS** (40 relationships + 17 Phase 2 + 43 Phase 1) |
| `npm test` (full backend suite) | 619 passed / 85 skipped (27 files); 4 pre-existing HTTP integration files fail with `ECONNREFUSED 127.0.0.1:8080` (no server running; unrelated to this change, matches Phase 2 baseline) |

Full numbers and the invariant matrix are recorded in `phase3-verification-report.md`.

## 4. Non-change confirmation

- No Phase 1 registry or Phase 2 specification file was modified (referenced read-only).
- No runtime file, route, service, repository, middleware, config, API, OpenAPI, schema, migration, seed, or DB change.
- No commits, no tags. Working tree remains uncommitted.
- No constitutional document was amended; no ADR was created; the three known defects (P3–I11 conflict, I11 bypass, P7 circularity) remain deferred to their ADRs.
- Baselines unchanged: constraints 12/43, evidence 13/43, verification 11/43 (all NotRegistered), gates 0/43 (5 gates, 0 bindings), decisions 0/43, exceptions 1 unrecorded precedent (I11).

## 5. Outstanding

1. **C6 — OPEN** (see §2): requires a dated ADR-board commitment (ADR-INDEX PQ-2).
2. **LOW-2 / PQ-1 — OPEN at constitutional level**: the ADR board must select the EC8 audit chain (ADR-INDEX PQ-1); Phase 3 has recorded its §2.3 choice and the ambiguity.
3. Per `phase3-review-decision.md` §4, a **later architectural review must confirm closure of C1–C6 before Phase 4** (enforcement engine) may begin. No Phase 4 work is authorized by this report.
