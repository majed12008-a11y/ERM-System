# Architecture Baseline Consolidation Review

| Field | Value |
|---|---|
| Status | COMPLETE |
| Author | Independent Principal Architect (baseline consolidation review) |
| Provenance | Evaluation of every architecture and governance document against ADR-002 (`docs/architecture/adr/ADR-002-canonical-dataset-architecture.md`), using the findings of `architecture-challenge-review.md` and `architecture-root-cause-analysis.md` as the evidence base. Direct inspection of the `backend/seed/` directory (79 files), `docs/`, and the DOMAIN_MODEL, governance, devops, database, and planning artifacts. |
| Constraints honored | READ-ONLY. No code, SQL, manifests, migrations, commits. No redesign. Documentation only. |
| Scope | Determine whether the project has ONE coherent architectural baseline (Canonical Dataset Architecture) or whether multiple philosophies coexist. Verdict per the established evidence only. |
| Date | 2026-08-06 |

**Preface.** The review evaluates ~46 architecture and governance artifacts against ADR-002. ADR-002 is assumed constitutional. The verdict answers only one question: has the project successfully transitioned from Installer History Architecture to Canonical Dataset Architecture?

---

## SECTION 1 — Baseline Consistency

Every affected document classified against ADR-002. Full per-document detail in `architecture-consistency-matrix.csv`.

| Classification | Count | Documents |
|---|---|---|
| Fully Consistent | 24 | ADR-002 + impact matrix; root-cause analysis; challenge review; all analysis/evidence chain (assumption/risk/boundary/blocker/mapping registers, normalization review + tables/seeds CSVs, population audit, table usage, feature coverage/traceability, seed architecture review, quality report, dependency graph, coverage matrices, table classification); verification platform; document-render-pipeline; Workflow-Implementation-Contract; ENTERPRISE_TRACEABILITY_MODEL; RLS security docs; business rules framework. |
| Partially Consistent | 17 | canonical-seed-specification; installation-readiness; rc4-seed-final-assessment; RC4-ARCHITECTURE; database-canonicalization-report; production-cutover-checklist; deployment-hardening-contract; production-readiness-report; phase5-observability-audit; ENTERPRISE_ARCHITECTURE_BASELINE_ASSESSMENT; ENGINEERING_PRINCIPLES/MANIFEST/PROGRAM_PLAN/DOCUMENTATION_STANDARD/SCAFFOLD_REPORT; PROJECT_CHARTER; DOMAIN_MODEL; AGENTS.md; docs/README; document-index; glossary; adr-template; Gate-1 superpowers plan. |
| Conceptually Divergent | 1 | `dataset-architecture.md` |
| Superseded | 1 | `seed-reconstruction-execution-architecture.md` |

### 1.1 Fully Consistent (24)

These documents align with ADR-002 or contain only factual evidence that the decision does not invalidate.

| Document | Why fully consistent |
|---|---|
| ADR-002-canonical-dataset-architecture.md | The constitutional document itself. |
| ADR-002-impact-matrix.csv | Companion to the ADR; consistent by construction. |
| architecture-root-cause-analysis.md | The ADR's basis; its verdict (seed suite = installer history) is codified verbatim. |
| architecture-challenge-review.md | The ADR's basis; its S10 verdict is what ADR-002 formalizes. |
| architecture-assumption/risk/boundary/blocker/mapping registers (.csv) | Pure evidence; assumptions A1/A3/A10, risks R1–R15, boundary rejections B1–B10, blockers R1–R6 are folded into ADR-002 P1–P9/I1–I11. |
| architecture-normalization-review.md + CSVs | Aligned with ADR-002: explicitly classifies the baseline dump as a "carrier/mechanism, not a dataset... cannot be the source of truth" — the same position as ADR-002 C2/P1. |
| database-population-audit.md, database-table-inventory.csv | Factual audit; unchanged by the decision. |
| backend-table-usage.md, backend-route-traceability.csv | Factual usage classes; supports P9 (no dead data). |
| feature-data-coverage.md, feature-traceability-review.md, feature-traceability-matrix.csv | Factual coverage; supports P8/P9. |
| seed-architecture-review.md, seed-quality-report.md, seed-dependency-graph.md, seed-coverage-matrix.md/.csv, table-classification.md | Factual evidence of the Installer History; basis for the decision, not contradicted by it. |
| verification-platform.md, document-render-pipeline.md, Workflow-Implementation-Contract.md | Domain contracts; no dataset framing. (Workflow contract's "seed SQL" reference is a mechanism note, not a dataset claim.) |
| ENTERPRISE_TRACEABILITY_MODEL.md | Approved governance baseline that ADR-002 explicitly extends; no conflict. |
| security/RLS-* (RLS-Audit, RLS-Hardening, RLS-Inventory, Defect-Registry, Quality-Gates) | RLS remains the sole access control (ADR I11); unchanged. |
| docs/business/rules/* (RULE_* governance) | Rule governance; RULE 11/12 invariant source; consistent with ADR I5. |

### 1.2 Partially Consistent (17)

Consistent in substance but carry the previous worldview in framing, mechanism, or status.

| Document | Partly consistent because | What is consistent |
|---|---|---|
| canonical-seed-specification.md | Framed as a *seed* specification ratified by seed buckets; content (Yemen lineage, counts, dead-data list, A1–A11) is the dataset product's content spec | Content itself is ADR-002's Canonical Dataset definition |
| installation-readiness.md | Recommends Path A (baseline-restore) as the deterministic install path | Its finding that only one path is deterministic is correct evidence |
| rc4-seed-final-assessment.md | "Now: keep gate0-baseline dump as the single source of truth" contradicts P1 (dataset is truth, dump is not) | Its conclusion that the suite is a change ledger is the ADR's basis |
| RC4-ARCHITECTURE.md | Master plan predates ADR-002; informal ADR-01..08 table; dataset posture not re-based | ADR-03 ("replace ad-hoc seed files") directionally supports the transition |
| database-canonicalization-report.md | "Live DB reflects cumulative application of all seed files"; seed files as deployment mechanism; counts predate Gate-0 era (references 57 ACTIVE files, current suite has 79) | Schema-canonicalization concept is compatible |
| production-cutover-checklist.md | Requires "all seeds show [OK]" via seed-status.ps1 as readiness proof — contradicts I2 (tracker state is not proof of execution) | Checklist structure is sound |
| deployment-hardening-contract.md | ROL-01 decision "keep seed files manual, not migration-controlled"; SEC-03 hardcoded passwords in seed SQL | Findings are valid evidence |
| production-readiness-report.md | Assumes seed-based deployment path | Findings remain valid |
| phase5-priority3-observability-audit.md | Informal ADR-001..007 numbering collides with the formal series (ADR-002 §7) | Observability decisions not overturned |
| ENTERPRISE_ARCHITECTURE_BASELINE_ASSESSMENT.md | Approved (2026-08-01) with "no critical blockers" — contradicts ADR-002's 4-blocker verdict; pre-dates the decision | Assessment method is sound |
| ENGINEERING_PRINCIPLES.md | No dataset/dataset-governance principle; AP-001/AP-002 (single responsibility) align with I11 | AP principles remain valid |
| ENGINEERING_MANIFEST / PROGRAM_PLAN / DOCUMENTATION_STANDARD / SCAFFOLD_REPORT | Pre-date ADR-002; contain no dataset governance; none reference ADR-002 | Engineering conventions remain valid |
| PROJECT_CHARTER.md | Pre-dates; no dataset product concept | Charter remains valid |
| DOMAIN_MODEL.md | Claims to be "the single source of truth for domain terminology" but defines NO aggregate, aggregate-root, or dataset concept that ADR-002 P3/P6/I5/I10 depend on | Its 9 bounded contexts and ubiquitous language remain valid |
| AGENTS.md | "Seed re-run limitation" and "baseline-restore workflow" sections still frame the seed suite as the product (ADR-002 I1) | Its architecture/Rule-11/Rule-12 and RLS constraints remain valid |
| docs/README.md | Skeleton; has no Decisions/ADR section; does not index ADR-002 | Structure is extensible |
| reference/document-index.md, reference/glossary.md | EMPTY (header only); no ADR index, no terminology registry | — |
| templates/adr-template.md | EMPTY (0 lines); no ADR template exists despite ADR-002 being accepted | — |
| 2026-08-05-gate1-wave1-application-registration.md | "Baseline: Gate 0 approved" framing treats the dump-state as the foundation without ADR-002 caveat (C2) | It does not re-run seeds; feature work is compatible |

### 1.3 Conceptually Divergent (1)

| Document | Why divergent |
|---|---|
| dataset-architecture.md | Defines a separate "Yemen National Validation Dataset" as a permanent reference dataset built by a commit-by-commit seed plan (50-yemen-institutions → 61-yemen-verify). Its seed plan does NOT match the actual suite (8 of its 12 named commit files do not exist — e.g. `55-yemen-reviews.sql`, `56-yemen-workflow.sql`, `58-yemen-communication.sql`, `61-yemen-verify.sql`; the real 55–64 files are forms-library and Gate-0). It embodies the Installer History worldview (dataset = seed commits) and does not reference ADR-002. It is a dataset concept, but not the Canonical Dataset product concept. |

### 1.4 Superseded (1)

| Document | Why superseded |
|---|---|
| seed-reconstruction-execution-architecture.md | Per ADR-002 §8: designed a construction pipeline for a change ledger. Its premise (re-run the 79-file suite deterministically = the goal) directly contradicts I1 (the suite is a historical record). Factual analysis retained as evidence; architecture not to be implemented as designed. |

---

## SECTION 2 — Terminology Consistency

**Headline finding: there is no authoritative terminology registry.** `docs/reference/glossary.md` is empty, `docs/reference/document-index.md` is empty, and `docs/domain/DOMAIN_MODEL.md` — which declares itself "the single source of truth for domain terminology" — defines none of the terms ADR-002 depends on. Every term below therefore has multiple live meanings across documents. Full registry in `architecture-terminology-registry.csv`.

| Term | Meaning in ADR-002 | Conflicting/other meanings in the baseline | Ambiguity |
|---|---|---|---|
| Seed | An individual SQL file in `backend/seed/` (79 files) — a historical-record artifact | Also used for future construct units: `seeds/` tree (SREA), `reference seed`, `scenario seed`, `patch seed` (canonical-spec, normalization-review) | HIGH — same word for legacy artifact and future construct |
| Seed Suite | The 79-file numeric collection — the Installer History | "Seed suite reduced to reference seeds + scenario fixtures" (rc4-final-assessment) describes a *future managed collection* | MEDIUM |
| Canonical Seed | Not a term of art; the ADR's product term is Canonical Dataset | "NEW canonical seed tree (replaces flat backend/seed/)" (SREA); "canonical seed specification" (file name); the term embeds the superseded worldview | HIGH — the term itself implies the dataset is a kind of seed |
| Canonical Dataset | THE product; the source of truth (P1) | Same meaning in normalization-review F7 and canonical-spec §2 (Yemen lineage) — intent aligned, but no product boundary is specified | LOW within ADR; MEDIUM across docs |
| Installer History | The role of the seed suite (change ledger) | Used only in ADR-002 and root-cause analysis | LOW — defined once |
| Dataset | Generic word | "validation dataset" (dataset-architecture), "pilot dataset" (95), "realistic data" (96), "demo dataset" — overloaded between product-definition and scenario fixture | MEDIUM |
| Baseline | A reproducible dataset STATE (ADR I3); distinct from a dump | "Gate-0 baseline" (the dump artifact), "baseline restore" (mechanism), "baseline freeze" (milestone) — artifact/state/milestone conflated | MEDIUM-HIGH |
| Scenario | Not defined in ADR-002 | "Scenario Seed" category (15 seeds, canonical-spec); "scenarios" bucket (SREA); vs "scenario" = business scenario in normalization-review | MEDIUM |
| Reference | Reference data / Reference Seed (idempotent, environment-invariant) | Consistent across normalization-review, canonical-spec, SREA | LOW |
| Fixture | Not defined in ADR-002 | "Demo Fixture" (6), "Test Fixture" (2), "Pilot Fixture", "delta fixture over canonical" (normalization-review); `fixtures/demo\|pilot\|test` buckets (SREA); overlaps with "scenario" | MEDIUM-HIGH |
| Runtime | Not defined in ADR-002 (implied by I11: application-produced data) | "Runtime-accumulated rows" excluded from dataset (canonical-spec); "runtime-generated only" (normalization-review, workflow/audit/historical); "Form Runtime" = the schema-driven form ENGINE (Gate-1 plan) | HIGH — data-class vs engine |
| Business Object | Not defined in ADR-002; ADR uses "business identity" (P6) | DOMAIN_MODEL defines "business entities"; "business object" is effectively undefined and unused in seed docs | HIGH — term exists without definition |
| Aggregate / Aggregate Root | The authoritative invariant model (P3, P6, I5, I10) | Not defined in DOMAIN_MODEL (terminology constitution); no concrete aggregate root named for Application/Condition | HIGH — constitutional term absent from the terminology constitution |
| Domain | Not defined in ADR-002 | Three levels coexist: business domains (DOMAIN_MODEL, 9 bounded contexts), domain modules (AGENTS, 13), domain schemas (14) | MEDIUM |

Additional overloaded terms: **Canonical Lineage** (normalization-review F7) vs **Canonical Schema** (database-canonicalization-report, dataset-architecture) vs **Canonical Dataset** (ADR) — three different "canonical" referents. **Gate-0** is both a milestone and a dump filename. **Era-1/2/3** are used consistently (rc4-final-assessment, seed-architecture-review).

**Conclusion:** no term has exactly one meaning. The highest-risk ambiguities are **Seed/Suite/Canonical Seed** (legacy artifact vs future construct), **Aggregate** (constitutional term with no definition anywhere), and **Runtime** (data class vs engine).

---

## SECTION 3 — Principle Consistency

Pre-ADR principles checked against ADR-002 P1–P9.

| Pre-ADR principle source | Statement | vs ADR-002 | Verdict |
|---|---|---|---|
| ENGINEERING_PRINCIPLES AP-002 | Every architectural layer has a single responsibility | Consistent with I11 (schema/RLS/data separation) and P2 (domain ownership) | Consistent |
| ENGINEERING_PRINCIPLES AP-001 | Business rules never in controllers | Consistent with P2/P3 (invariants in an authoritative model) | Consistent |
| normalization-review | Runtime/history/queues are runtime-generated only; never direct-INSERT | Consistent with I11 and canonical-spec A11 | Consistent |
| normalization-review | Buckets-not-prefixes; environment invariance | Directionally consistent with P4 (semantic deps) and I6 | Consistent |
| canonical-spec A4/A11 | Zero empty-read routes; no leakage; no silent no-op | Consistent with P8 (behavior verification), P9 (no dead data) | Consistent |
| SREA core premise | Re-run the 79-file suite from scratch deterministically = success | **Contradicts I1** (suite is a historical record) and I3 (reproducible construction, not seed re-run) | **Contradiction (architectural)** |
| rc4-final-assessment "Now" step | Keep gate0 dump as the single source of truth | **Contradicts P1** (dataset is truth; dump is a carrier) | **Contradiction (architectural)** |
| installation-readiness Path A | Baseline-restore is the recommended deterministic install path | **Contradicts I3** (restoration ≠ construction) | **Contradiction (architectural)** |
| production-cutover-checklist | "All seeds show [OK]" proves deployment readiness | **Contradicts I2** (tracker state is not proof of execution) | **Contradiction (governance)** |
| database-canonicalization-report | Live DB reflects cumulative application of all seed files | **Contradicts I1** (seeds are history, not the product) | **Contradiction (architectural)** |
| ENTERPRISE_ARCHITECTURE_BASELINE_ASSESSMENT | "No critical blockers" (approved 2026-08-01) | **Contradicts** ADR-002's 4 architectural blockers | **Contradiction (governance)** |

**Summary:** the *mechanism* principles (AP-001/002, runtime-only, buckets) agree with ADR-002. The *worldview* principles — seed re-run as goal, dump as source of truth, restore as install, seed-status as proof — **contradict** ADR-002 and remain live in 5 documents.

---

## SECTION 4 — Governance Consistency

Artifacts that still reference the previous architectural worldview and require governance revision:

| Artifact | Old-worldview content | Required governance change |
|---|---|---|
| production-cutover-checklist.md | seed-status.ps1 "[OK]" as readiness gate | Re-base readiness proof on dataset-construction evidence, not tracker state |
| deployment-hardening-contract.md | ROL-01 "keep seeds manual, not migration-controlled"; SEC-03 plaintext passwords in seed SQL | Re-baseline rollback/provenance policy; remediate credential hygiene in canonical data |
| AGENTS.md | Seed re-run limitation + baseline-restore workflow as the operating procedure | Reference ADR-002; reframe seeds as historical record |
| database-canonicalization-report.md | Seed files as deployment mechanism; stale 57-ACTIVE count (actual: 79 files) | Re-baseline to current 79-file suite + ADR-002 framing |
| RC4-ARCHITECTURE.md | Informal ADR-01..08; dataset posture pre-ADR | Reconcile informal ADRs into the formal series (ADR-002 §7) |
| phase5-observability-audit.md | Informal ADR-001..007 numbering | Renumber into formal series |
| ENTERPRISE_ARCHITECTURE_BASELINE_ASSESSMENT.md | "No critical blockers" — stale vs ADR-002 verdict | Re-run baseline assessment under the new constitution |
| ENGINEERING_MANIFEST / PROGRAM_PLAN / DOCUMENTATION_STANDARD / SCAFFOLD_REPORT | No dataset governance; no ADR-002 reference | Add dataset-governance principles and ADR-002 linkage |
| 2026-08-05-gate1-wave1 plan | "Baseline: Gate 0 approved" as foundation | Note ADR-002 constraints (C2) in the baseline line |
| reference/document-index.md | EMPTY | Must index ADR-002 |
| reference/glossary.md | EMPTY | Must become the terminology registry (Section 2 terms) |
| templates/adr-template.md | EMPTY | Must define the ADR template the series requires |
| docs/README.md | Skeleton, no Decisions section | Must index ADR-002 |

**Governance gap (formal ADR series):** ADR-001 does not exist; ADR-002 is the founding record with no template, no index, and no numbering policy. The informal ADR-01..08 (RC4) and ADR-001..007 (phase5) series create a numbering collision that the formal series must absorb (ADR-002 §7 already anticipates this).

---

## SECTION 5 — Traceability Consistency

Chains traced Problem → Finding → Root Cause → ADR Principle → Affected Documents.

| Chain | Problem | Finding (evidence) | Root Cause | ADR Principle | Affected documents | Status |
|---|---|---|---|---|---|---|
| 1 | Suite not reproducible | seed-quality F; 17-file `-Force` failure; 16 non-idempotent | RC B — installer history | P1, P4, P6 | SREA, installation-readiness, rc4-final-assessment, AGENTS | **BROKEN** — no document operationalizes P1/P6 in execution terms yet |
| 2 | Tracker untrusted | 78 rows identical `applied_at`/`duration_ms=0`; A1 | RC B10 | P7 | SREA registry, installation-readiness | **BROKEN** — no registry document exists |
| 3 | Boundaries rejected (10) | boundary-analysis B1–B10; FK fan-out | RC A + C | P2, P3, P9 | canonical-spec, dataset-architecture, DOMAIN_MODEL | **BROKEN** — P3 (aggregate) has no concept in the terminology constitution |
| 4 | Dead data in canonical counts | templates.* 0 consumers; monitoring.* no consumers; SEED_ONLY 27 populated | RC C | P9 | canonical-spec §6, backend-table-usage | **INTACT** — canonical-spec §6 already lists dead data |
| 5 | Business correctness unverified | RULE 11/12 never asserted; S8 | RC A | P8 | SREA verification engine | **BROKEN** — no verification document adopts P8 behavior assertions |
| 6 | Restoration ≠ construction | A10; Path A only | RC B | I3 | installation-readiness, dataset-architecture | **BROKEN** — Path A still recommended |

**Broken chains: 5 of 6.** The chains break at the final link: ADR-002's principles are stated, but no downstream document has been updated to operationalize them (this review is the first step). Chain 4 is intact because `canonical-seed-specification.md §6` already enumerates dead data.

---

## SECTION 6 — Residual Contradictions

| # | Document A | Document B | ADR-002 says | Classification |
|---|---|---|---|---|
| 1 | rc4-final-assessment: "keep gate0 dump as single source of truth" | — | P1: Canonical Dataset is truth; dump is carrier | Architectural |
| 2 | installation-readiness: Path A baseline-restore is the recommended path | — | I3: reproducibility by construction, not restoration | Architectural |
| 3 | production-cutover-checklist: "all seeds show [OK]" proves readiness | — | I2: tracker state is not proof of execution | Governance |
| 4 | database-canonicalization-report: "live DB reflects cumulative application of all seed files" | — | I1: seeds are a historical record | Architectural |
| 5 | ENTERPRISE_ARCHITECTURE_BASELINE_ASSESSMENT: "no critical blockers" | challenge-review S10 verdict NO + 4 blockers | The decision formalized those blockers | Governance |
| 6 | SREA: re-run the 79-file suite = success criterion | — | I1/I3: suite is history; construction is the goal | Architectural |
| 7 | dataset-architecture: "Yemen National Validation Dataset" as a separate deliverable via seed commits 50–61 | actual suite: no such commit files; 55–64 are forms/Gate-0 | Canonical Dataset is the single product | Conceptual (plus factual — the referenced seed files do not exist) |
| 8 | "canonical seed tree" (SREA) / "canonical seed specification" | ADR-002 "Canonical Dataset" | The product is a dataset, not a seed | Conceptual / terminology |
| 9 | DOMAIN_MODEL: "single source of truth for domain terminology" | — | P3/P6 require "aggregate"/"aggregate root", which DOMAIN_MODEL does not define | Governance / terminology |
| 10 | "scenario" vs "fixture" taxonomy (canonical-spec 15 scenarios vs normalization-review demo/test fixtures vs SREA buckets) | — | Not defined | Editorial / terminology |
| 11 | 9 numeric-prefix collision groups (00, 13, 16, 17, 18, 33, 50, 51, 58) | — | Not addressed (out of scope) | Editorial |

**Distribution:** Architectural 4, Governance 3, Conceptual 2, Editorial 2. The architectural and governance contradictions are the ones that block consolidation; the editorial ones are factual cleanup.

---

## SECTION 7 — Constitutional Baseline

**ADR-002 alone is NOT yet sufficient as the single constitutional baseline.** Five structural gaps prevent it from governing the baseline alone:

| # | Missing piece | Evidence |
|---|---|---|
| G1 | Terminology registry | `glossary.md` empty; DOMAIN_MODEL defines no aggregate/dataset; ADR-002 terms (P3/P6) have no shared definition |
| G2 | ADR series infrastructure | `adr-template.md` empty (0 lines); ADR-001 unwritten; no ADR index; informal ADR-01..08 and ADR-001..007 numbering collisions unresolved |
| G3 | A concrete definition of the Canonical Dataset product boundary | `canonical-seed-specification.md §2` gives content counts but framed as a seed spec; `dataset-architecture.md` is divergent (a different dataset concept); no document defines the aggregate roots (Application, Condition) that P3 requires |
| G4 | Operationalization of I1–I3 in governance | cutover checklist, deployment-hardening contract, database-canonicalization report, AGENTS.md, and the Gate-1 plan still operate on the old worldview |
| G5 | Re-baselined enterprise assessment | ENTERPRISE_ARCHITECTURE_BASELINE_ASSESSMENT ("no critical blockers") contradicts ADR-002's 4-blocker verdict |

**What is present:** the decision (ADR-002), its evidence chain (root-cause + challenge review), its impact matrix, and the content definition of the canonical dataset (canonical-spec §2). The decision layer is internally consistent. The baseline layer is not.

---

## SECTION 8 — Final Verdict

**NO — the project has NOT successfully transitioned from Installer History Architecture to Canonical Dataset Architecture.**

Evidence, all documented above:

1. **The decision was made, but the transition was not.** ADR-002 is accepted and internally consistent (Section 1.1), but ADR-002's own impact matrix marks 5 documents Needs Revision and 1 Superseded — **none have been revised or retired**. The baseline still carries both worldviews simultaneously.

2. **The old worldview is still operative in execution artifacts.** `production-cutover-checklist.md` gates readiness on seed-tracker `[OK]` status (contradicts I2). `deployment-hardening-contract.md` keeps seeds manual and non-migration-controlled (contradicts I1). `database-canonicalization-report.md` still defines deployment as applying seed files (contradicts I1). AGENTS.md still frames baseline-restore as the operating workflow.

3. **The superseded architecture is still referenced as the target.** SREA — explicitly superseded by ADR-002 — is still cited as the forward plan by `rc4-seed-final-assessment.md` and the Gate-1 plan operates on the "Gate 0 approved" baseline framing.

4. **A second, divergent dataset concept still exists.** `dataset-architecture.md` defines a "Yemen National Validation Dataset" built by a commit-by-commit seed plan whose named files do not exist in the current 79-file suite. This is not the Canonical Dataset product concept; the two coexist as separate philosophies.

5. **The terminology layer is empty.** `glossary.md` and `document-index.md` are headers only; the ADR template is empty; DOMAIN_MODEL does not contain the aggregate/dataset concepts ADR-002 depends on. The constitutional vocabulary is not defined anywhere.

6. **A stale governance verdict is still approved.** ENTERPRISE_ARCHITECTURE_BASELINE_ASSESSMENT ("no critical blockers", approved 2026-08-01) sits in the baseline opposite ADR-002's four architectural blockers.

The project has formally **adopted** Canonical Dataset Architecture as a decision. It has not yet **consolidated** the baseline: the decision layer is one coherent architecture, but the document, terminology, governance, and execution layers still embody both the Installer History worldview and the Canonical Dataset worldview. Transition is in progress, not complete.
