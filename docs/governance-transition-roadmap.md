# Governance Transition Roadmap

| Field | Value |
|---|---|
| Status | ACCEPTED — governance migration order |
| Date | 2026-08-06 |
| Provenance | `architecture-transition-plan.md` (Phases 0–5, Section 5 migration order, single ownership). |
| Purpose | Sequence the migration of governance artifacts from Baseline v1 (Installer History) to Baseline v2 (Canonical Dataset) under ADR-002. |
| Constraints | READ-ONLY. No implementation. No commits. |

---

## 1. Governance layers and migration order

Governance is migrated in 8 artifact classes, in dependency order. Earlier classes gate later ones.

| Order | Artifact class | Migration action | Gate |
|---|---|---|---|
| 1 | ADR infrastructure | Create ADR-001, ADR template, ADR index; reconcile informal ADRs | Phase 0 |
| 2 | Terminology layer | Populate glossary; amend DOMAIN_MODEL with aggregate concepts | Phase 0–1 |
| 3 | Standards | Rewrite ENGINEERING_DOCUMENTATION_STANDARD, ENGINEERING_PRINCIPLES | Phase 3 |
| 4 | Roadmaps | Re-base RC4-ARCHITECTURE on ADR-002 | Phase 3 |
| 5 | Architecture documents | Dispose the 27 affected docs (rewrite/replace/merge/archive) | Phase 2 |
| 6 | Execution contracts | Re-base mechanism references (Workflow contract, phase2/3/4, cutover, hardening) | Phase 4 |
| 7 | Review reports | Re-run enterprise baseline assessment, production-readiness under ADR-002 | Phase 3–4 |
| 8 | Operating constitution | Rewrite AGENTS.md | Phase 3 |

### Rationale for the order

- **1 before 2:** the ADR series defines the authority that owns terminology policy (ADR-001), so the registry is created under it.
- **2 before 3:** standards cannot be rewritten in the final vocabulary before the vocabulary exists.
- **3 before 4:** the master plan must be written to the re-baselined standards.
- **5 before 6:** execution contracts reference architecture documents; the documents they cite must exist first.
- **7 before 8:** AGENTS.md must reflect a certified verdict, not an in-flight one.

---

## 2. Artifact-by-artifact roadmap

### 2.1 ADR hierarchy

| Artifact | Current state | Migration | Phase | Owner |
|---|---|---|---|---|
| ADR-001 | Missing | Create: series foundation, numbering policy, template, terminology policy, Baseline v2 adoption | 0 | Enterprise Architecture (ADR board) |
| ADR-002 | Accepted | Keep — constitution | 0 | Enterprise Architecture |
| ADR template | Empty | Populate from adr-template conventions | 0 | Enterprise Architecture |
| ADR index | Missing | Create; include informal-ADR reconciliation map (RC4 ADR-01..08, phase5 ADR-001..007 → formal numbers) | 0 | Enterprise Architecture |
| phase5 ADR-001..007 | Informal | Renumber into formal series; mapping preserved | 3 | Enterprise Architecture + DevOps Governance |
| RC4 ADR-01..08 | Informal | Renumber into formal series; mapping preserved | 3 | Enterprise Architecture |

### 2.2 Standards

| Artifact | Migration | Phase | Owner |
|---|---|---|---|
| ENGINEERING_DOCUMENTATION_STANDARD | Add ADR series conventions, terminology rules, document lifecycle | 3 | Engineering Governance |
| ENGINEERING_PRINCIPLES | Add dataset-governance principles; link ADR-002 P1–P9 | 3 | Engineering Governance |
| ENGINEERING_MANIFEST | Reference ADR-002; dataset governance entry | 3 | Engineering Governance |
| ENGINEERING_PROGRAM_PLAN | Re-baseline program against Baseline v2 | 3 | Engineering Governance |
| ENGINEERING_SCAFFOLD_REPORT | Archive (historical snapshot) | 2 | Engineering Governance |

### 2.3 Roadmaps

| Artifact | Migration | Phase | Owner |
|---|---|---|---|
| RC4-ARCHITECTURE | Re-base dataset posture on ADR-002; reconcile informal ADRs; mark ADR-03 (migration framework) as aligned with the transition | 3 | Enterprise Architecture |

### 2.4 Architecture documents

| Artifact | Migration | Phase | Owner |
|---|---|---|---|
| canonical-seed-specification | Replace → canonical-dataset-specification; original archived | 2 | Enterprise Architecture |
| dataset-architecture | Merge useful content into canonical-dataset-specification; discard seed-commit mechanism; archive | 2 | Enterprise Architecture |
| seed-reconstruction-execution-architecture | Archive (superseded); factual content citable | 2 | Enterprise Architecture |
| installation-readiness | Rewrite: restoration vs construction; construction as the goal | 2 | Enterprise Architecture |
| rc4-seed-final-assessment | Rewrite: recommendation updated to dataset-as-truth | 2 | Enterprise Architecture |
| database-canonicalization-report | Rewrite: current 79-file suite; dataset framing | 4 | Database/DevOps Governance |

### 2.5 Execution contracts

| Artifact | Migration | Phase | Owner |
|---|---|---|---|
| Workflow-Implementation-Contract | Re-base "seed SQL" mechanism note to dataset/migration framing | 4 | Domain Architecture |
| phase2-conditions / phase3-certificates / phase4-notifications contracts | Re-base seed-mechanism references; keep RLS/state content | 4 | Domain Architecture |
| production-cutover-checklist | Re-base readiness proof from seed-status [OK] to dataset-construction evidence | 4 | DevOps Governance |
| deployment-hardening-contract | Re-baseline ROL-01 (migration-controlled), SEC-03 credential hygiene | 4 | DevOps Governance |
| forward superpowers plans | New plans cite Baseline v2; historical plans archived | 4 | Engineering Governance |

### 2.6 Review reports

| Artifact | Migration | Phase | Owner |
|---|---|---|---|
| ENTERPRISE_ARCHITECTURE_BASELINE_ASSESSMENT | Re-run as v2 with ADR-002-consistent verdict; superseded verdict archived | 3 | Independent Enterprise Architecture Review Board |
| production-readiness-report | Re-baseline under new constitution | 4 | DevOps Governance |
| All evidence chain (36 Fully Consistent docs) | Keep — immutable evidence | None | — |

### 2.7 Operating constitution

| Artifact | Migration | Phase | Owner |
|---|---|---|---|
| AGENTS.md | Rewrite seed/seed-re-run/baseline-restore sections under ADR-002; keep Rule 11/12, RLS constraints | 3 | Engineering Governance + Enterprise Architecture |

---

## 3. Sequence of governance milestones

| Milestone | Gates | Deliverable |
|---|---|---|
| M1 | Phase 0 complete | ADR-001 approved; ADR template + index; glossary/document-index populated |
| M2 | Phase 1 complete | DOMAIN_MODEL defines aggregates; final vocabulary in force |
| M3 | Phase 2 complete | All 27 affected documents disposed; archives manifest complete |
| M4 | Phase 3 complete | Engineering standards + RC4 + enterprise assessment v2 re-baselined; informal ADRs renumbered |
| M5 | Phase 4 complete | Operational artifacts re-based; no forward plan cites SREA/dataset-architecture |
| M6 | Phase 5 complete | All 10 exit criteria met; Architecture Baseline v2 declared |

## 4. Single ownership summary

| Governance body | Owns |
|---|---|
| Enterprise Architecture (ADR board) | ADR series, RC4-ARCHITECTURE, architecture baseline, canonical dataset specification, enterprise baseline assessment |
| Domain Architecture | DOMAIN_MODEL, terminology registry, domain contracts |
| Engineering Governance | ENGINEERING_* standards, AGENTS.md (joint), superpowers plans |
| DevOps Governance | Operational contracts (cutover, hardening, production-readiness, database-canonicalization) |
| Business Architecture | Business rules framework (RULE_*) |
| Independent Enterprise Architecture Review Board | Baseline assessments, review reports |

---

## 5. Transition completion

Completion is certified at M6 when all 10 exit criteria (EC1–EC10, `architecture-transition-plan.md` Section 9) are verifiably satisfied. After that, all governance artifacts belong to exactly one worldview (Canonical Dataset Architecture) and the mixed-baseline state is closed.
