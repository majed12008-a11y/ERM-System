# Architecture Baseline v2 Index

| Field | Value |
|---|---|
| Status | APPROVED — companion to the Architecture Closure Decision |
| Date | 2026-08-06 |
| Authority | Ratified by `architecture-closure-decision.md` §2; defined by `architecture-transition-plan.md` §8; consistent with `architecture-baseline-consolidation-review.md` §7. |
| Constraints honored | READ-ONLY. No code, SQL, manifests, migrations, commits. No redesign. Documentation only. |
| Purpose | The authoritative index of Architecture Baseline v2: the constitutional (normative) list, the supporting (non-normative, immutable evidence) list, and the archived (immutable history) list. One index; one baseline. |
| Companions | `architecture-closure-decision.md`, `architecture-governance-freeze.md`, `document-transition-matrix.csv`, `terminology-transition-plan.csv`, `governance-transition-roadmap.md`. |

---

## SECTION 1 — Status Legend

| Status | Meaning |
|---|---|
| **Accepted** | In force now; constitutional or governing. |
| **To be created / populated / amended / re-based (Phase N)** | Exists or is stubbed; the transition plan assigns its creation or re-baselining to governance Phase 0–3. |
| **Approved** | In force now; an approved governance artifact consistent with ADR-002. |
| **Supporting** | Non-normative; immutable evidence; citable but never authoritative over a constitutional document. |
| **Archived** | Non-normative; immutable history; preserved verbatim per transition plan §7; never authoritative for implementation. |

Baseline v2 contains **three disjoint sets**: constitutional documents, supporting documents, and archived documents. A document belongs to exactly one set. This is the single-baseline property the transition enforces (transition plan T1).

---

## SECTION 2 — Constitutional Documents (normative)

The constitutional list. ADR-002 is the sole constitution; the remaining documents derive from it and must not conflict with it (precedence rule in `architecture-closure-decision.md` §4).

| # | Document | Status | Notes |
|---|---|---|---|
| 1 | ADR-002-canonical-dataset-architecture.md | **Accepted** | The constitution: P1–P9, I1–I11, C1–C12, dataset philosophy. |
| 2 | ADR-001 (series foundation) | **To be created (Phase 0)** | Numbering policy, ADR template, terminology policy, adoption of Baseline v2. |
| 3 | ADR index (with informal-ADR reconciliation map) | **To be created (Phase 0)** | Authority chain; reconciles RC4 ADR-01..08 and phase5 ADR-001..007 into the formal series. |
| 4 | Terminology registry (`reference/glossary.md`) | **To be populated (Phase 0)** | Currently header-only; must record the final vocabulary (transition plan §6.5). |
| 5 | DOMAIN_MODEL (with aggregate/aggregate-root concepts) | **To be amended (Phase 1)** | Must define Aggregate and Aggregate Root; name Application and Condition aggregate roots (P3/P6/I5/I10). |
| 6 | `canonical-dataset-specification.md` (replaces `canonical-seed-specification.md`) | **To be created (Phase 2)** | The Canonical Dataset product specification; absorbs merged `dataset-architecture.md` content; original of the replace is archived. |
| 7 | ENGINEERING_PRINCIPLES (re-baselined) | **To be re-based (Phase 3)** | Add dataset-governance principles; link ADR-002 P1–P9. |
| 8 | ENTERPRISE_TRACEABILITY_MODEL | **Approved** | Existing traceability constitution; extended by ADR-002, not contradicted. |
| 9 | AGENTS.md (re-baselined operating constitution) | **To be re-based (Phase 3)** | Reframe seed/baseline-restore sections under ADR-002; keep RULE 11/12 and RLS constraints. |
| 10 | Business rules framework (RULE_* governance) | **Approved** | RULE 11/12 invariant source; independent of dataset framing. |
| 11 | ENTERPRISE_ARCHITECTURE_BASELINE_ASSESSMENT v2 | **To be re-run (Phase 3)** | ADR-002-consistent verdict required (replaces the stale "no critical blockers" v1). |

---

## SECTION 3 — Supporting Documents (non-normative, immutable evidence)

The 36 Fully Consistent documents. They are the evidence chain of ADR-002. **Keep** disposition; never rewritten (transition plan §4, T8).

### 3.1 Evidence chain (architecture phase deliverables)

| # | Document | Role |
|---|---|---|
| 1 | architecture-root-cause-analysis.md | Basis of ADR-002; verdict codified verbatim. |
| 2 | architecture-challenge-review.md | Basis of ADR-002; S10 verdict formalized by the ADR. |
| 3 | architecture-assumption-register.csv | Evidence; A1/A3/A10 folded into ADR principles. |
| 4 | architecture-risk-register.csv | Evidence; R1–R15 folded into ADR principles. |
| 5 | architecture-boundary-analysis.csv | Evidence; B1–B10 folded into ADR principles. |
| 6 | architecture-blocker-tree.csv | Evidence; R1–R6 folded into ADR principles. |
| 7 | boundary-root-cause-mapping.csv | Evidence. |
| 8 | architecture-normalization-review.md | Explicitly treats dump as carrier, not source of truth — same position as C2/P1. |
| 9 | architecture-normalization-seeds.csv | Factual taxonomy evidence. |
| 10 | architecture-normalization-tables.csv | Factual taxonomy evidence. |

### 3.2 Factual audits and usage evidence

| # | Document | Role |
|---|---|---|
| 11 | database-population-audit.md | Factual audit; unchanged by the decision. |
| 12 | database-table-inventory.csv | Factual evidence. |
| 13 | backend-table-usage.md | Factual usage classes; supports P9. |
| 14 | backend-route-traceability.csv | Factual evidence. |
| 15 | feature-data-coverage.md | Factual coverage; supports P8/P9. |
| 16 | feature-traceability-review.md | Factual coverage. |
| 17 | feature-traceability-matrix.csv | Factual coverage. |
| 18 | seed-architecture-review.md | Factual evidence of the Installer History. |
| 19 | seed-quality-report.md | Factual evidence; basis of the decision. |
| 20 | seed-dependency-graph.md | Factual evidence. |
| 21 | seed-coverage-matrix.md | Factual evidence. |
| 22 | seed-coverage-matrix.csv | Factual evidence. |
| 23 | table-classification.md | Factual evidence. |
| 24 | canonical-population-matrix.csv | Factual population evidence. |

### 3.3 Domain contracts and governance approvals

| # | Document | Role |
|---|---|---|
| 25 | verification-platform.md | Domain contract; no dataset framing. |
| 26 | document-render-pipeline.md | Domain contract; no dataset framing. |
| 27 | Workflow-Implementation-Contract.md | Domain contract; "seed SQL" reference is a mechanism note, not a dataset claim. |
| 28 | ENTERPRISE_TRACEABILITY_MODEL.md | Approved governance baseline extended by ADR-002. |
| 29 | RLS-Audit-Report.md | RLS remains sole access control (I11). |
| 30 | RLS-Hardening-Report.md | RLS invariant unchanged. |
| 31 | RLS-Inventory.md | RLS invariant unchanged. |
| 32 | Defect-Registry.md | RLS/defect evidence unchanged. |
| 33 | Quality-Gates.md | Quality gate definitions unchanged. |
| 34 | BUSINESS_RULES_FRAMEWORK.md | Business-level; RULE 11/12 source domain. |

### 3.4 ADR companions (counted within the 36)

| # | Document | Role |
|---|---|---|
| 35 | ADR-002-canonical-dataset-architecture.md | The constitutional document itself (listed here as evidence of the decision; normative status per §2.1). |
| 36 | ADR-002-impact-matrix.csv | Companion to the ADR; consistent by construction. |

---

## SECTION 4 — Archived Documents (non-normative, immutable history)

Preserved verbatim per transition plan §7.4 (archive location `docs/architecture/archive/` or per-document archive directory, with disposition manifest). No historical information is lost.

### 4.1 Already-superseded or historical artifacts (Archive disposition, Phase 2)

| # | Document | Disposition reason |
|---|---|---|
| 1 | seed-reconstruction-execution-architecture.md | Superseded; construction pipeline for a change ledger (contradicts I1). Factual analysis remains citable. |
| 2 | dataset-architecture.md | Conceptually divergent; useful content merged into `canonical-dataset-specification.md`; seed-commit mechanism discarded. |
| 3 | ENGINEERING_SCAFFOLD_REPORT.md | Historical scaffold snapshot; not forward-operational. |
| 4 | 2026-08-02-gate0-document-lifecycle.md | Historical execution plan that produced seed 58; Gate-0 state is now a historical record. |
| 5 | 2026-08-02-document-infrastructure.md | Historical execution plan; predates ADR-002. |
| 6 | Historical forward superpowers plans | Re-based at plan creation; historical plans archived (transition plan §1.3). |

### 4.2 Archived originals of Rewrite / Replace / Merge dispositions (Phase 2)

Every document disposed by Rewrite (21), Replace (1, `canonical-seed-specification.md`), or Merge (1, `dataset-architecture.md`) yields an archived original, preserved verbatim with a pointer to its replacement (transition plan T6, §7.4). The full disposition list is `document-transition-matrix.csv`; the archive manifest records disposition, date, and replacement for each.

### 4.3 Superseded verdicts and informal ADRs

| Item | Status |
|---|---|
| ENTERPRISE_ARCHITECTURE_BASELINE_ASSESSMENT v1 ("no critical blockers", approved 2026-08-01) | Superseded verdict; archived when v2 is approved (Phase 3). |
| RC4 informal ADR-01..08 | Renumbered into the formal series via the ADR index reconciliation map; decision content preserved (ADR-002 §7). |
| phase5 informal ADR-001..007 | Renumbered into the formal series via the ADR index reconciliation map; decision content preserved. |

---

## SECTION 5 — Disposition Ledger Reference

Disposition counts for the 27 affected documents (per `architecture-transition-matrix.csv`, `architecture-transition-plan.md` §4):

| Disposition | Count |
|---|---|
| Rewrite | 21 |
| Replace | 1 (`canonical-seed-specification.md` → `canonical-dataset-specification.md`) |
| Merge | 1 (`dataset-architecture.md`) |
| Archive | 4 |
| Keep | 36 (all Fully Consistent documents) |
| Delete | 0 (forbidden — transition plan §7) |

The transition executes these dispositions across Phases 0–5 (governance milestones M1–M6) and certifies completion at M6 against exit criteria EC1–EC10.

---

## SECTION 6 — Summary of the Baseline

| Set | Count | Role |
|---|---|---|
| Constitutional (normative) | 11 | Governs all implementation (precedence 1–4 in `architecture-closure-decision.md` §4). |
| Supporting (immutable evidence) | 36 | Evidence, citable but not normative (precedence 6). |
| Archived (immutable history) | 5 direct + all archived originals + superseded verdicts | History, never authoritative (precedence 7). |

This index is the single reference for what belongs to Architecture Baseline v2. A document not listed here in a constitutional or supporting role is either archived or not part of the baseline; introducing any new constitutional document requires a formal ADR (see `architecture-governance-freeze.md`).
