# ADR-001 — ADR Series Foundation

| Field | Value |
|---|---|
| Number | ADR-001 |
| Status | APPROVED — series foundation; ratified by Phase 0 execution of the approved transition plan |
| Date | 2026-08-07 |
| Author | Enterprise Architecture (ADR board) |
| Provenance | `architecture-transition-plan.md` (Phase 0; §5.1; §8.1), `ADR-002-canonical-dataset-architecture.md` §7 (formal series status and numbering reservation), `architecture-governance-freeze.md` §4 (change-control mechanism), `architecture-baseline-v2-index.md` (Baseline v2 definition), `architecture-closure-decision.md` (architecture phase closure). |
| Constraints honored | READ-ONLY with respect to the constitution. Documentation only. No code, SQL, manifests, migrations. No new architecture decisions — this ADR formalizes decisions already accepted by the approved chain. |
| Purpose | Establish the formal ADR series: numbering policy, binding ADR template, ADR index, terminology policy, and the adoption of Architecture Baseline v2. Founding record of the series per ADR-002 §7. |
| Supersedes | Nothing. ADR-001 is the founding record; it does not supersede ADR-002 (the constitution) and does not overturn any informal technology decision (ADR-002 §7). |

---

## 1. Context

ADR-002 §7 records: "no formal ADR series exists under `docs/architecture/adr/`. **ADR-001 has not been authored.** ADR-002 is therefore the founding record of the formal series." The approved transition plan (Phase 0 — Constitutional scaffolding) makes ADR-001 the first governance act of the implementation phase, per the Governance Freeze §4: "The first governance act of the implementation phase is transition Phase 0: create ADR-001 (series foundation), the ADR template, and the ADR index."

This ADR therefore does not decide anything new. It makes the series definable so that Baseline v2 can be governed.

## 2. Decision

### 2.1 Numbering policy

1. The formal ADR series lives in `docs/architecture/adr/`. Files are named `ADR-<NNN>-<kebab-slug>.md`.
2. ADR-002 is the sole constitution (transition plan T2; Governance Freeze). ADR-001 is the series foundation. Both are authoritative; ADR-002 wins on conflict (closure decision §4 precedence rule).
3. New ADRs are numbered sequentially from ADR-003 onward. A number is never reused.
4. Informal ADRs (RC4 ADR-01..08; phase5 ADR-001..007) are **not** renumbered in Phase 0. They are registered in the ADR index with a reconciliation map and are renumbered into the formal series during transition Phase 3, preserving the mapping (transition plan §5.1; governance roadmap §2.1; EC10).

### 2.2 Binding ADR template

The ADR template at `docs/templates/adr-template.md` is binding for every formal ADR. No ADR is part of the series unless it follows the template and is registered in the ADR index.

### 2.3 ADR index

The ADR index at `docs/architecture/adr/ADR-INDEX.md` is the authority chain of the series. It lists every formal ADR, every registered informal ADR, and the reconciliation map.

### 2.4 Terminology policy

1. The final vocabulary (transition plan §6.5) is binding on all active documents.
2. Forbidden terms (transition plan §6.4) must not appear in active Baseline v2 documents.
3. The glossary at `docs/reference/glossary.md` is the terminology registry (Phase 0 deliverable). Terminology changes require an ADR (Governance Freeze §3 — no new terminology beyond the final vocabulary).

### 2.5 Adoption of Architecture Baseline v2

Architecture Baseline v2 is adopted as defined in `architecture-baseline-v2-index.md`: constitutional (normative), supporting (immutable evidence), and archived (immutable history) sets. The mixed-baseline state described by the consolidation review is closed by executing the transition plan; this ADR is Phase 0 of that execution.

## 3. Consequences

1. The series is definable: template, index, and numbering now exist.
2. Future ADRs derive from ADR-002 and cite it; the index records the authority chain.
3. Until Phase 3 renumbering, informal ADRs remain registered-but-informal; their decision content is preserved (ADR-002 §7).
4. Terminology is change-controlled from this date: new terms require an ADR.

## 4. References

- ADR-002-canonical-dataset-architecture.md (constitution)
- architecture-transition-plan.md (Phase 0; §5.1; §6; §8)
- architecture-governance-freeze.md (§4)
- architecture-baseline-v2-index.md
- architecture-closure-decision.md (§4 precedence rule)
- docs/templates/adr-template.md (binding template)
- docs/architecture/adr/ADR-INDEX.md
