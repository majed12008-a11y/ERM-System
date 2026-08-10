# Document Index

> Registry of Architecture Baseline v2 documents (Phase 0 deliverable; EC2). Lists the constitutional set, the supporting evidence set, the archived set, and the governance/decision-chain artifacts.
> Normative definition of the three sets: `architecture-baseline-v2-index.md`. Governance rules: `architecture-governance-freeze.md`. Terminology: `reference/glossary.md`.

## 1. Constitutional documents (normative)

Authority chain per `architecture-closure-decision.md` §4 precedence rule. `reference/glossary.md` notes Phase 1–3 amendments in parentheses.

| Document | Status (baseline index §2) |
|---|---|
| `architecture/adr/ADR-002-canonical-dataset-architecture.md` | Accepted (the constitution) |
| `architecture/adr/ADR-001-series-foundation.md` | Accepted (created Phase 0) |
| `architecture/adr/ADR-INDEX.md` | Accepted (created Phase 0; informal-ADR reconciliation map) |
| `reference/glossary.md` | Accepted (populated Phase 0) |
| DOMAIN_MODEL | To be amended (Phase 1) |
| `canonical-dataset-specification.md` | To be created (Phase 2; replaces `canonical-seed-specification.md`) |
| ENGINEERING_PRINCIPLES | To be re-based (Phase 3) |
| ENTERPRISE_TRACEABILITY_MODEL | Approved |
| AGENTS.md (root) | To be re-based (Phase 3) |
| Business rules framework (RULE_* governance) | Approved |
| ENTERPRISE_ARCHITECTURE_BASELINE_ASSESSMENT v2 | To be re-run (Phase 3) |

## 2. Governance and decision chain (approved governance artifacts)

| Document | Role |
|---|---|
| `architecture-closure-decision.md` | Architecture phase closure; precedence rule |
| `architecture-baseline-v2-index.md` | Single-baseline definition (this index's authority) |
| `architecture-governance-freeze.md` | Change-control mechanism; first governance act = ADR-001 |
| `architecture-transition-plan.md` | Approved transition plan (Phases 0–5) |
| `governance-transition-roadmap.md` | Milestones M1–M6, exit criteria EC1–EC10 |
| `architecture-baseline-consolidation-review.md` | Mixed-baseline analysis closed by the transition |
| `document-transition-matrix.csv` | Disposition ledger for the 27 affected documents |
| `terminology-transition-plan.csv` | 28-row terminology transition (final vocabulary source) |
| `architecture-terminology-registry.csv` | 19-row ambiguity registry |

## 3. Constitutional enforcement architecture (Phase 0 scaffold)

| Document | Role |
|---|---|
| `constitutional-enforcement-architecture.md` | Enforcement architecture (verdict: YES AFTER IMPLEMENTING THIS ARCHITECTURE) |
| `constitutional-object-model.md` | 16 constitutional objects |
| `constitutional-state-machine.md` | 9 states, 15 transitions |
| `constitutional-enforcement-domains.csv` | 8 enforcement domains |
| `constitution-enforcement-matrix.csv` | 43 elements × enforcement links (P/M) |
| `constitutional-maturity-model.csv` | 43 elements, current/required maturity |
| `enforcement-gap-register.csv` | 43 elements, gap + cause + risk |
| `architecture-enforcement-model.md` | Enforcement model (verdict: NO; maturity 0.12/4.00) |
| `architecture-constitution-stress-test.md` | Stress test (verdict: NO) |
| `architecture/registry/registry-index.md` | Constitutional Registry skeleton |
| `architecture/registry/traceability-register.md` | Traceability scaffolding register |

## 4. Supporting documents (immutable evidence — 36)

Non-normative, citable, never rewritten (baseline index §3). Full 36-item list and roles: `architecture-baseline-v2-index.md` §3. Headline items:

- Evidence chain: `architecture-root-cause-analysis.md`, `architecture-challenge-review.md`, `architecture-assumption-register.csv`, `architecture-risk-register.csv`, `architecture-boundary-analysis.csv`, `architecture-blocker-tree.csv`, `boundary-root-cause-mapping.csv`, `architecture-normalization-review.md`, `architecture-normalization-seeds.csv`, `architecture-normalization-tables.csv`
- Audits: `database-population-audit.md`, `database-table-inventory.csv`, `backend-table-usage.md`, `backend-route-traceability.csv`, `feature-data-coverage.md`, `feature-traceability-review.md`, `feature-traceability-matrix.csv`, `seed-architecture-review.md`, `seed-quality-report.md`, `seed-dependency-graph.md`, `seed-coverage-matrix.md`, `seed-coverage-matrix.csv`, `table-classification.md`, `canonical-population-matrix.csv`
- Contracts/approvals: `verification-platform.md`, `document-render-pipeline.md`, `Workflow-Implementation-Contract.md`, `ENTERPRISE_TRACEABILITY_MODEL.md`, RLS reports (Audit/Hardening/Inventory/Defect-Registry/Quality-Gates), `BUSINESS_RULES_FRAMEWORK.md`
- ADR companions: `architecture/adr/ADR-002-canonical-dataset-architecture.md`, `architecture/adr/ADR-002-impact-matrix.csv`

## 5. Archived documents (immutable history)

Preserved verbatim (baseline index §4; transition plan §7). Includes `seed-reconstruction-execution-architecture.md`, `dataset-architecture.md`, `ENGINEERING_SCAFFOLD_REPORT.md`, Gate-0 execution plans, archived originals of Rewrite/Replace/Merge dispositions, superseded ENTERPRISE_ARCHITECTURE_BASELINE_ASSESSMENT v1. Archive location: `architecture/archive/`.

## 6. Reference and templates

| Document | Role |
|---|---|
| `reference/glossary.md` | Terminology registry (final vocabulary) |
| `reference/document-index.md` | This document |
| `reference/acronyms.md` | Acronym expansion |
| `templates/adr-template.md` | Binding ADR template (ADR-001 §2.2) |
| `templates/architecture-template.md` | Architecture document template |

## 7. Provenance and traceability

- Authority: `architecture-baseline-v2-index.md`, `architecture-transition-plan.md`, `architecture-governance-freeze.md`, ADR-001, ADR-002.
- Traceability register: `architecture/registry/traceability-register.md`.
