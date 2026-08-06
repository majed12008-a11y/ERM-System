# Architecture Transition Plan

| Field | Value |
|---|---|
| Status | ACCEPTED — governance transition strategy |
| Date | 2026-08-06 |
| Author | Independent Principal Architect (transition planning) |
| Provenance | Built from `architecture-baseline-consolidation-review.md` (63 documents classified; 5 broken traceability chains; constitutional gaps G1–G5) and `ADR-002-canonical-dataset-architecture.md` (the constitution being transitioned to). |
| Constraints honored | READ-ONLY. No code, SQL, manifests, migrations, commits. No redesign. Documentation only. |
| Purpose | Migrate GOVERNANCE from Installer History Architecture to Canonical Dataset Architecture. Not a redesign — a controlled migration of documents, terminology, governance artifacts, and traceability. |
| Start state | ADR-002 accepted; baseline carries both worldviews (decision layer consistent, baseline layer not). |
| End state | Architecture Baseline v2: exactly one constitutional architecture, objective exit criteria met (Section 9). |

---

## SECTION 1 — Transition Scope

Every architectural artifact affected by ADR-002, grouped by transition horizon. Full per-document disposition in `document-transition-matrix.csv`.

### 1.1 Immediate — the constitutional skeleton

Required first because every other step depends on the vocabulary and the ADR hierarchy being defined.

| Artifact | Why immediate |
|---|---|
| ADR-001 (adoption decision) | No formal ADR-001 exists; ADR-002 is the founding record. ADR-001 must formalize the series, the terminology policy, and the adoption of Baseline v2. |
| ADR template (`templates/adr-template.md`) | Empty (0 lines); the series cannot grow without it. |
| ADR index | No index exists; the series needs an index that also reconciles informal ADR-01..08 (RC4) and ADR-001..007 (phase5). |
| Terminology registry (`reference/glossary.md`) | Empty; no shared vocabulary exists. The registry is the precondition for every rewritten document. |
| Document index (`reference/document-index.md`) | Empty; must index the full baseline including ADR-002. |
| DOMAIN_MODEL aggregate concepts | The terminology constitution defines no aggregate/aggregate-root; ADR-002 P3/P6/I5/I10 require them. |

### 1.2 Near-term — document and governance disposition

The 27 documents classified Partially Consistent, Conceptually Divergent, or Superseded (Section 4). They block consistency and must be disposed before the baseline can be certified.

### 1.3 Long-term — operational artifacts

Deployment and operations artifacts are re-based only when next touched, because they are not read by the architecture decision process but by operators.

| Artifact | Why long-term |
|---|---|
| production-cutover-checklist.md | Operational readiness gate; re-based before the next cutover, not before the next architecture review. |
| deployment-hardening-contract.md | Operational hardening contract; re-based when next executed. |
| production-readiness-report.md | Snapshot; superseded by a re-baselined assessment at next release. |
| database-canonicalization-report.md | Deployment mechanism doc; re-baselined at next schema canonicalization. |
| Forward superpowers execution plans | Re-based at plan creation; historical plans archived. |

### 1.4 Permanent — evidence and history

Never migrated, only referenced. These are the Fully Consistent documents (36) plus all archived artifacts.

| Artifact | Why permanent |
|---|---|
| Evidence chain (root-cause, challenge review, registers, audits, coverage, quality reports) | Factual findings are not invalidated by ADR-002; they are its basis. |
| Business rules framework (RULE_* governance) | RULE 11/12 invariant source; independent of dataset framing. |
| RLS security docs | I11 (RLS sole access control) unchanged. |
| Historical/archived documents | Section 7: no historical information may be lost. |

---

## SECTION 2 — Transition Principles

Principles governing the transition itself (governance migration), not the target architecture (already set by ADR-002).

| # | Principle | Meaning |
|---|---|---|
| T1 | **No mixed worldview** | At every point in the transition, a document either belongs to Baseline v1 (Installer History) or Baseline v2 (Canonical Dataset) — never both. Documents are migrated atomically. |
| T2 | **Single constitutional source** | ADR-002 is the sole normative constitution; all other documents derive from it. No document may claim constitutional status in conflict with ADR-002. |
| T3 | **Backward traceability** | Every decision in the target baseline traces to ADR-002 → root-cause → challenge-review → evidence. Every migrated document traces to the document it replaced. |
| T4 | **Controlled terminology evolution** | Terms change only through the terminology transition plan (`terminology-transition-plan.csv`); no ad-hoc renaming. Deprecated terms remain legible in historical documents. |
| T5 | **Single ownership** | Each artifact has exactly one owning governance body (ADR board, engineering governance, domain architecture, product governance). No artifact is owned by two bodies. |
| T6 | **Archive before replace** | No document is deleted or overwritten until its replacement exists and its content is preserved. Historical information is never destroyed (Section 7). |
| T7 | **Governance first, mechanism later** | The transition changes governance artifacts first; operational mechanism docs are re-based only when next touched (Long-term). |
| T8 | **Evidence is immutable** | Factual analysis documents are never rewritten to fit the new worldview; they are archived and cited, preserving their original conclusions. |

---

## SECTION 3 — Transition Phases

Governance evolution phases only. Each phase has Objective, Input, Output, Completion Criteria. No implementation work is defined.

### Phase 0 — Constitutional scaffolding

| Item | Definition |
|---|---|
| Objective | Create the ADR infrastructure and terminology registry that make Baseline v2 definable. |
| Input | ADR-002; consolidation review (gaps G1, G2); empty stubs (adr-template, glossary, document-index). |
| Output | ADR-001; ADR template; ADR index (with informal-ADR reconciliation map); populated glossary/terminology registry; populated document index. |
| Completion criteria | ADR-001 approved; ADR template non-empty and binding; ADR index lists ADR-001, ADR-002 and all reconciled informal ADRs; glossary defines every term in the final vocabulary (Section 6); document index lists the full baseline. |

### Phase 1 — Domain terminology alignment

| Item | Definition |
|---|---|
| Objective | Make the terminology constitution (DOMAIN_MODEL) able to express ADR-002 concepts (aggregate, aggregate root, canonical dataset). |
| Input | DOMAIN_MODEL (SPEC-0005); terminology transition plan; glossary (from Phase 0). |
| Output | Amended DOMAIN_MODEL defining aggregate/aggregate-root; named aggregate roots for Application and Condition; dataset product vocabulary. |
| Completion criteria | DOMAIN_MODEL uses only final-vocabulary terms; aggregate roots named; no ADR-002 term left undefined. |

### Phase 2 — Document disposition

| Item | Definition |
|---|---|
| Objective | Apply the Keep/Rewrite/Merge/Replace/Archive/Delete disposition to all 27 affected documents. |
| Input | `document-transition-matrix.csv`; Phase 0 vocabulary; Phase 1 domain model. |
| Output | Every affected document disposed; replacements exist and are traceable to their originals; originals archived. |
| Completion criteria | Zero documents classified Partially Consistent/Conceptually Divergent/Superseded remain in the active baseline; disposition log complete. |

### Phase 3 — Governance re-baselining

| Item | Definition |
|---|---|
| Objective | Re-base the enterprise, engineering, and master-plan governance artifacts on ADR-002. |
| Input | Phase 2 outputs; RC4-ARCHITECTURE; ENGINEERING_*; ENTERPRISE_ARCHITECTURE_BASELINE_ASSESSMENT; PROJECT_CHARTER; AGENTS.md. |
| Output | Re-baselined engineering principles/manifest/program/documentation standard; re-baselined RC4 master plan; re-run enterprise baseline assessment with verdict consistent with ADR-002; AGENTS.md operating constitution updated. |
| Completion criteria | Enterprise baseline assessment v2 approved with ADR-002-consistent verdict; all ENGINEERING_* reference ADR-002; informal ADR numbering collision resolved (phase5 ADR-001..007 renumbered). |

### Phase 4 — Operational re-basing

| Item | Definition |
|---|---|
| Objective | Re-base deployment/operations artifacts that the transition has not touched yet. |
| Input | Phase 3 outputs; cutover checklist; deployment-hardening contract; production-readiness report; database-canonicalization report; forward superpowers plans. |
| Output | Re-based operational artifacts using dataset-construction readiness proof (not seed-tracker status); historical plans archived. |
| Completion criteria | production-cutover-checklist no longer gates on seed-status `[OK]`; deployment-hardening contract policy aligned with I1; no forward plan cites SREA or dataset-architecture as its target. |

### Phase 5 — Baseline v2 certification

| Item | Definition |
|---|---|
| Objective | Prove, by objective measurement, that the transition is complete. |
| Input | All phase outputs; the 10 exit criteria (Section 9). |
| Output | Architecture Baseline v2 declared; transition closure record. |
| Completion criteria | All 10 exit criteria satisfied; traceability chains 1–6 re-verified with 0 broken; no forbidden term in active documents; single constitutional architecture confirmed. |

---

## SECTION 4 — Document Migration Plan

Disposition of every document classified Partially Consistent, Conceptually Divergent, or Superseded. Full table in `document-transition-matrix.csv`; summary:

| Disposition | Count | Documents |
|---|---|---|
| Rewrite | 21 | installation-readiness; rc4-final-assessment; RC4-ARCHITECTURE; database-canonicalization-report; production-cutover-checklist; deployment-hardening-contract; production-readiness-report; phase5-observability-audit; ENTERPRISE_ARCHITECTURE_BASELINE_ASSESSMENT; ENGINEERING_PRINCIPLES; ENGINEERING_MANIFEST; ENGINEERING_PROGRAM_PLAN; ENGINEERING_DOCUMENTATION_STANDARD; PROJECT_CHARTER; DOMAIN_MODEL; AGENTS.md; README.md; document-index; glossary; adr-template; 2026-08-05-gate1-wave1 plan |
| Replace | 1 | canonical-seed-specification → `canonical-dataset-specification` (name embeds deprecated term) |
| Merge | 1 | dataset-architecture (useful content merged into canonical-dataset-specification; divergent seed-commit mechanism discarded) |
| Archive | 4 | SREA; ENGINEERING_SCAFFOLD_REPORT; 2026-08-02-gate0-document-lifecycle; 2026-08-02-document-infrastructure |
| Keep | 36 | All Fully Consistent documents (evidence chain, domain contracts, RLS, business rules) |
| Delete | 0 | Not used — Section 7 forbids information loss; all dispositions preserve content |

### Rationale by disposition

- **Rewrite** — document's content remains valid but its framing/mechanism belongs to Baseline v1. Same identity, new framing, versioned under the documentation standard.
- **Replace** — the document's *name* embeds a deprecated term ("canonical seed"). A new-named document (`canonical-dataset-specification`) takes its place; original archived.
- **Merge** — `dataset-architecture.md` carries a divergent dataset concept (validation dataset via seed commits) but also unique useful content (dataset objectives, scope) that belongs in the canonical dataset specification. Merge the useful content, discard the seed-commit mechanism, archive the original.
- **Archive** — document is superseded or purely historical; retained verbatim for traceability (Section 7). SREA is archived as a historical proposal, not destroyed; its factual analysis remains citable.
- **Keep** — no change; documents are either already consistent or are immutable evidence.
- **Delete** — reserved but unused: no artifact qualifies because every artifact carries information that Section 7 requires be preserved.

---

## SECTION 5 — Governance Migration

Governance evolution order and rationale.

### 5.1 ADR hierarchy

1. **ADR-001 (new)** — establishes the series, numbering policy, template, terminology policy, and adoption of Baseline v2. Foundation of the hierarchy.
2. **ADR-002 (existing)** — the constitution. Position: top of the hierarchy, referenced by all other ADRs.
3. **Reconciled informal ADRs** — RC4 ADR-01..08 and phase5 ADR-001..007 are renumbered into the formal series via a mapping table (RC4-ADR-01 → ADR-00N, etc.) so old references remain resolvable.

### 5.2 Migration order

| Order | Artifact class | Action |
|---|---|---|
| 1 | ADR infrastructure (template, index, ADR-001) | Create (Phase 0) — everything else references it. |
| 2 | Terminology registry + DOMAIN_MODEL | Populate/amend (Phases 0–1) — every rewritten document needs the vocabulary. |
| 3 | Standards (ENGINEERING_DOCUMENTATION_STANDARD, ENGINEERING_PRINCIPLES) | Rewrite (Phase 3) — bind the new conventions. |
| 4 | Roadmaps (RC4-ARCHITECTURE) | Re-base (Phase 3) — master plan must cite ADR-002. |
| 5 | Architecture docs (canonical-spec → canonical-dataset-spec; dataset-architecture merge; SREA archive) | Dispose (Phase 2) — the product spec and its superseded predecessors. |
| 6 | Execution contracts (Workflow-Implementation-Contract, phase2/3/4 contracts, cutover checklist, deployment-hardening) | Re-base mechanism references (Phase 4) — mechanism notes updated, not architectural content. |
| 7 | Review reports (ENTERPRISE_ARCHITECTURE_BASELINE_ASSESSMENT, production-readiness) | Re-run under the new constitution (Phase 3/4) — verdicts refreshed. |
| 8 | Operating constitution (AGENTS.md) | Rewrite (Phase 3) — the operational reference must match the architecture. |

### 5.3 Single ownership

| Artifact | Owning body |
|---|---|
| ADR series (ADR-001, ADR-002, index, template) | Enterprise Architecture (ADR board) |
| Terminology registry + DOMAIN_MODEL | Domain Architecture |
| ENGINEERING_* standards | Engineering Governance |
| RC4-ARCHITECTURE, enterprise baseline assessment | Enterprise Architecture |
| AGENTS.md | Engineering Governance + Enterprise Architecture (joint) |
| Operational contracts (cutover, hardening) | DevOps Governance |
| Business rules (RULE_*) | Business Architecture |

---

## SECTION 6 — Terminology Migration

Full table in `terminology-transition-plan.csv`. Design summary:

### 6.1 Deprecated terms

| Term | Deprecated because | Replacement |
|---|---|---|
| "Canonical Seed" | Embeds the worldview that the dataset is a kind of seed (SREA "canonical seed tree") | "Canonical Dataset" |
| "Seed Suite" (as the product) | Treats the ledger as the deliverable | "Installer History" (the record); "Canonical Dataset" (the product) |
| "Seed" (as a future construct unit) | The superseded construction model used seeds as the unit of construction | "Migration" / "Reference Dataset" / "Scenario Dataset" / "Fixture" (per bucket) |
| "Validation Dataset" (dataset-architecture) | A second, divergent dataset concept | "Canonical Dataset" |
| "Baseline-restore (as install path)" | Contradicts I3 (restoration ≠ construction) | "Dataset Construction" |
| "Dump / Gate-0 baseline (as source of truth)" | Contradicts P1 | "Baseline (dataset state)"; "Dump (carrier artifact)" |
| "seed-status [OK] as readiness proof" | Contradicts I2 | "Provenance evidence" |
| "Business Object" | Undefined; unused | "Business Entity" (DOMAIN_MODEL) / "Aggregate" (ADR) |

### 6.2 Replacement / canonical terms

| Term | Status | Notes |
|---|---|---|
| Canonical Dataset | Canonical | The product; the source of truth. |
| Installer History | Canonical | The role of the seed suite. |
| Baseline | Canonical (clarified) | A versioned, reproducible dataset STATE; never the dump. |
| Aggregate / Aggregate Root | Canonical | Must be added to DOMAIN_MODEL (Phase 1). |
| Runtime-Generated Data | Canonical (data class) | Distinct from "Runtime" (engine). |
| Application Ownership / Domain Ownership | Canonical | Per ADR P2. |

### 6.3 Allowed synonyms

| Term | Allowed synonym of |
|---|---|
| Yemen lineage / Canonical Lineage | Canonical Dataset content (Era-2) |
| Canonical Schema | Schema authority (distinct from Canonical Dataset) |
| Scenario Dataset / Scenario Fixture | Dataset category (business scenarios over canonical) |
| Demo / Pilot / Test Fixture | Dataset fixture category (presentation/test over canonical) |
| "Gate-0" | Historical milestone (Baseline v1 referent) |

### 6.4 Forbidden terms (in active documents)

| Forbidden | Because |
|---|---|
| "Canonical Seed" | Deprecated; implies seed-as-product. |
| "Seed Suite is the source of truth" | Contradicts P1. |
| "keep the dump as single source of truth" | Contradicts P1. |
| "validation dataset" as a separate product | Divergent concept; retired with dataset-architecture. |
| "seed-status [OK] proves deployment" | Contradicts I2. |
| "Business Object" | Undefined; no meaning in final vocabulary. |

Forbidden terms remain legible in archived/historical documents (Section 7) but must not appear in active Baseline v2 documents.

### 6.5 Transition period and final vocabulary

- **Transition period:** from Phase 0 to Phase 5 closure. Deprecated terms are permitted in migration artifacts (rewrite notes, disposition logs) but not in new output.
- **Final vocabulary:** Canonical Dataset, Installer History, Baseline (state), Dump (carrier), Aggregate, Aggregate Root, Business Entity, Domain (qualified: Bounded Context / Domain Module / Domain Schema), Runtime-Generated Data, Runtime (engine), Reference Dataset, Scenario Dataset, Fixture (Demo/Pilot/Test), Migration, Provenance, Dataset Lifecycle, Canonical Lineage, Canonical Schema.

---

## SECTION 7 — Traceability Preservation

No historical information may be lost. Mechanisms:

### 7.1 Old reports remain valid

Every Fully Consistent evidence document (36) is **Keep** — never rewritten. The root-cause analysis, challenge review, and all registers remain citable as the evidence basis of ADR-002. Their conclusions are not re-interpreted.

### 7.2 Old ADRs remain understandable

- The informal ADR series (RC4 ADR-01..08, phase5 ADR-001..007) are renumbered via a **mapping table** preserved in the ADR index. Old references (e.g., "see RC4-ARCHITECTURE ADR-03") resolve to the formal number.
- ADR-002 explicitly records that it does not overturn informal technology decisions; the mapping preserves the decision content.

### 7.3 New ADRs remain authoritative

ADR-001 and ADR-002 sit at the top of the hierarchy. Every new ADR derives from them and cites them. The ADR index records the authority chain.

### 7.4 Archive discipline

- **Archive before replace:** every Rewrite/Replace/Merge produces an archived original, preserved verbatim, with a pointer from the new document to its archived original and vice versa.
- **Archive location:** `docs/architecture/archive/` (or per-document archive directory) with a manifest noting disposition, date, and replacement document.
- **No Delete:** Delete is reserved and unused; every artifact carries information the transition preserves.
- **Immutable evidence:** historical reports are not edited to fit the new worldview; they are archived and cited as-is. Their old-worldview terminology remains legible and is explicitly marked as Baseline v1 vocabulary where necessary.

---

## SECTION 8 — Constitutional Baseline Definition

**Architecture Baseline v2** officially consists of:

### 8.1 Constitutional documents (normative)

| Document | Role |
|---|---|
| ADR-001 | Series foundation: numbering, template, terminology policy, adoption of Baseline v2. |
| ADR-002 | The constitution: Canonical Dataset Architecture (P1–P9, I1–I11). |
| ADR index | Authority chain; informal-ADR reconciliation map. |
| Terminology registry (`reference/glossary.md`) | The final vocabulary (Section 6.5), binding on all documents. |
| DOMAIN_MODEL | Domain terminology constitution incl. aggregate/aggregate-root definitions. |
| `canonical-dataset-specification.md` | The Canonical Dataset product specification (replaces canonical-seed-specification). |
| ENGINEERING_PRINCIPLES | Engineering constitution (re-baselined, ADR-002-linked). |
| ENTERPRISE_TRACEABILITY_MODEL | Traceability constitution. |
| AGENTS.md | Operating constitution (re-baselined). |
| Business rules framework (RULE_*) | Rule governance constitution. |
| ENTERPRISE_ARCHITECTURE_BASELINE_ASSESSMENT v2 | Certified re-baselined assessment (ADR-002-consistent verdict). |

### 8.2 Evidence baseline (non-normative, immutable)

All 36 Fully Consistent documents: root-cause analysis, challenge review, registers (assumption/risk/boundary/blocker/mapping), normalization review + CSVs, population audit, table usage, feature coverage/traceability, seed architecture/quality/dependency/coverage reviews, table classification, domain contracts, RLS security docs, verification platform, document-render-pipeline, ENTERPRISE_TRACEABILITY_MODEL.

### 8.3 Historical archive (non-normative, immutable)

All archived documents (SREA, dataset-architecture, ENGINEERING_SCAFFOLD_REPORT, historical superpowers plans) plus archived originals of every Rewrite/Replace/Merge.

---

## SECTION 9 — Transition Exit Criteria

Objective conditions proving the transition complete. All must be verifiable by inspection/grep/audit.

| # | Criterion | Verification |
|---|---|---|
| EC1 | ADR-001 exists and is approved; ADR template non-empty and binding | File existence + approval status |
| EC2 | Glossary, document index, ADR index populated; final vocabulary recorded | Non-empty; term set matches Section 6.5 |
| EC3 | DOMAIN_MODEL defines Aggregate and Aggregate Root; Application/Condition aggregate roots named | Grep DOMAIN_MODEL |
| EC4 | All 27 affected documents disposed per matrix; zero active documents remain Partially Consistent/Divergent/Superseded | Re-audit of consistency matrix |
| EC5 | Zero forbidden terms in active documents (grep: "canonical seed", "validation dataset", "seed-status", "dump as source of truth") | Grep active baseline |
| EC6 | production-cutover-checklist gates on dataset-construction evidence, not seed-status `[OK]` | Grep cutover checklist |
| EC7 | SREA and dataset-architecture archived; no active document cites them as forward plan | Grep active baseline for citations |
| EC8 | All 6 traceability chains re-verified with 0 broken | Traceability audit |
| EC9 | ENTERPRISE_ARCHITECTURE_BASELINE_ASSESSMENT v2 approved with ADR-002-consistent verdict | Approval status |
| EC10 | Informal ADR numbering collision resolved; mapping table present | ADR index |

---

## SECTION 10 — Final Verdict

**YES — after this transition plan is executed, the project will have exactly ONE constitutional architecture.**

Support:

1. **The plan eliminates coexistence by disposition.** Section 4 leaves no active document outside Baseline v2: 21 rewritten, 1 replaced, 1 merged, 4 archived, 36 kept (evidence), 0 deleted. The Conceptually Divergent and Superseded documents — the sources of the second worldview — are archived (EC7).

2. **The plan removes the contradictions, not just the documents.** Governance migration (Section 5) and terminology migration (Section 6) target the specific contradictions catalogued in the consolidation review (dump-as-truth vs P1, restore-as-install vs I3, seed-status-proof vs I2, validation-dataset divergence). EC5 and EC6 measure their removal.

3. **The plan makes the single baseline self-certifying.** Exit criteria EC1–EC10 are objective and verifiable; EC4, EC5, and EC8 directly assert single-baseline properties (no mixed classification, no forbidden terminology, no broken traceability). Completion of the plan is defined as the state where only one constitutional architecture is measurable.

4. **The plan preserves, never destroys, history.** Section 7 guarantees the evidence chain and archived documents remain citable, so the single architecture is achieved without information loss — the transition is a governance consolidation, not a rewrite of history.

**Conditionality.** The verdict is conditional on full execution: all phases 0–5 completed, all 10 exit criteria met. If any exit criterion fails, the transition is not complete and the project is still in the mixed state — by the plan's own definition. Executed as specified, the project ends with exactly one constitutional architecture: **Canonical Dataset Architecture (Baseline v2)**.
