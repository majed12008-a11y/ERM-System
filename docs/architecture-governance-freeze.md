# Architecture Governance Freeze

| Field | Value |
|---|---|
| Status | APPROVED — change control in effect |
| Date | 2026-08-06 |
| Authority | Ratified by `architecture-closure-decision.md` §3 and §6; implements the freeze declared there. |
| Constraints honored | READ-ONLY. No code, SQL, manifests, migrations, commits. No redesign. Documentation only. |
| Purpose | Bind implementation to the frozen constitutional architecture. No future work may silently reintroduce the mixed baseline; every constitutional change requires a formal ADR. |
| Companions | `architecture-closure-decision.md`, `architecture-baseline-v2-index.md`, `architecture-transition-plan.md`, `document-transition-matrix.csv`, `terminology-transition-plan.csv`. |

---

## SECTION 1 — What is FROZEN

A change to any element below **is** a change to the frozen architecture and requires a formal ADR, regardless of which layer (architecture or implementation) the change originates from (`architecture-closure-decision.md` §3.3).

| Frozen element | Source |
|---|---|
| Constitutional principles P1–P9 (Dataset-first, Domain ownership, Aggregate ownership, Semantic dependencies, Dataset lifecycle, Business identity over execution order, Provenance trust, Behavior verification, No dead data) | ADR-002 §3 |
| Invariants I1–I11 | ADR-002 §5 |
| Dataset philosophy: the Canonical Dataset is the product; the seed suite is an Installer History | ADR-002 §2 |
| Governance model: single constitutional source (ADR-002); single ownership per artifact | ADR-002; transition plan T2/T5 |
| Aggregate ownership: aggregate-level invariants (RULE 11, RULE 12) live in one authoritative model; Application/Condition aggregate roots named in DOMAIN_MODEL | ADR-002 P3/P6; transition plan Phase 1 |
| Dependency philosophy: execution order respects the business dependency graph, never numeric order | ADR-002 P4/I6 |
| Final vocabulary (transition plan §6.5): Canonical Dataset, Installer History, Baseline (state), Dump (carrier), Aggregate, Aggregate Root, Business Entity, Domain (qualified), Runtime-Generated Data, Runtime (engine), Reference Dataset, Scenario Dataset, Fixture (Demo/Pilot/Test), Migration, Provenance, Dataset Lifecycle, Canonical Lineage, Canonical Schema | Transition plan §6 |
| Forbidden terms in active documents: "Canonical Seed", "Seed Suite is the source of truth", "keep the dump as single source of truth", "validation dataset" as a separate product, "seed-status [OK] proves deployment", "Business Object" | Transition plan §6.4 |
| The 27 document dispositions in `document-transition-matrix.csv` | Transition plan §4 |
| Baseline v2 exit criteria EC1–EC10 | Transition plan §9 |
| The constitutional baseline list (11 documents) in `architecture-baseline-v2-index.md` §2 | Closure decision §2.1 |

---

## SECTION 2 — What MAY EVOLVE (without an ADR)

These evolve freely under their owning governance bodies, subject to the stated constraint.

| Evolving element | Constraint |
|---|---|
| Implementation mechanism documents (execution contracts, runbooks, deployment contracts) | Must cite ADR-002; must not contradict I1–I11. |
| Operational deployment posture (cutover, hardening, production-readiness) | Re-based under transition Phase 4. |
| The transition plan execution order (which disposition lands first) | Within Phases 0–5; must complete before Baseline v2 certification (governance milestone M6). |
| Implementation-level engineering choices | Under ENGINEERING_DOCUMENTATION_STANDARD and ENGINEERING_PRINCIPLES. |
| RC4 feature construction (domain contracts content) | Must satisfy ADR-002 invariants. |

---

## SECTION 3 — No New Governance Without an ADR

Future implementation **must not** introduce, without a formal ADR:

- **New architectural principles** beyond P1–P9.
- **New constitutional documents** beyond the Baseline v2 list (`architecture-baseline-v2-index.md` §2).
- **New terminology** beyond the final vocabulary (transition plan §6.5).
- **New ownership models** beyond single-ownership per artifact and the aggregate-ownership mandate.

A proposed change that touches a frozen element must first be written as a formal ADR, not implemented and rationalized afterwards. The ADR states the change, the principle/invariant it touches, the evidence, and the impact on the constitutional baseline.

---

## SECTION 4 — ADR Change-Control Mechanism

1. **First governance act of implementation (transition Phase 0):** create ADR-001 (series foundation), the ADR template, and the ADR index. ADR-001 formalizes the series, the numbering policy, the terminology policy, and the adoption of Baseline v2.
2. **Thereafter:** any change to a frozen element is a formal ADR per the ADR template; the ADR index records the authority chain (ADR-001 → ADR-002 → subsequent ADRs).
3. **Until ADR-001 exists:** ADR-002, this Governance Freeze, and the transition plan are jointly the governing authority. **No freeze modification may occur outside that authority.** The freeze is binding from the date of this document; it does not wait for ADR-001.
4. **Implementation-level documents** change freely under ENGINEERING_DOCUMENTATION_STANDARD, but must never contradict a frozen element.
5. **Informal ADRs** (RC4 ADR-01..08, phase5 ADR-001..007) are reconciled into the formal series via the ADR index mapping table (Phase 3); their decision content is preserved (ADR-002 §7).

---

## SECTION 5 — Enforcement and Verification

The freeze is enforced by the transition exit criteria (EC1–EC10) and by governance reviews:

| Control | What it prevents |
|---|---|
| EC1 | No future work before the ADR series exists. |
| EC2 | No new vocabulary without a registry entry. |
| EC3 | No aggregate invariants outside an authoritative model. |
| EC4 | No active document outside Baseline v2 (no mixed worldview). |
| EC5 | No forbidden terminology in active documents (grep-verifiable). |
| EC6 | No readiness gating on seed-status instead of construction evidence. |
| EC7 | No forward plan citing superseded architectures (SREA, dataset-architecture). |
| EC8 | No broken traceability chain. |
| EC9 | No stale enterprise assessment verdict. |
| EC10 | No informal-ADR numbering collision. |

Any implementation review that encounters a contradiction with a frozen element must stop and raise it as an ADR-worthy issue — not resolve it by unilateral interpretation (precedence rule, `architecture-closure-decision.md` §4).

---

## SECTION 6 — Boundary of the Freeze

- The freeze binds the **architecture layer**: principles, terminology, ownership, dependency, dataset philosophy.
- It does **not** bind the **implementation layer**: mechanisms, tools, deployment order, feature construction.
- A change that touches a frozen element **is** a change to the frozen element and requires an ADR, regardless of which layer the change originates from.

---

## SECTION 7 — Binding Declaration

Effective 2026-08-06, Architecture Baseline v2 is frozen. This freeze is binding on all future implementation work. It is change-controlled: the first governance act of the implementation phase is the creation of ADR-001, and until that exists, ADR-002, this Governance Freeze, and the transition plan are jointly the governing authority. No freeze modification may occur outside that authority.
