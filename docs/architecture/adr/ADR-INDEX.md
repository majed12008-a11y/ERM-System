# ADR Index

> Authority chain of the formal ADR series. Established by ADR-001 (series foundation); governance register of `docs/architecture/adr/`.
> Governing authority: ADR-002 (constitution) > ADR-001 (series foundation) > registered ADRs (closure decision §4 precedence rule).
> Every ADR is registered here; an unregistered ADR is not part of the series (ADR-001 §2.2, §2.3).

## 1. Formal ADR series

| ADR | Title | Status | Date | Scope |
|---|---|---|---|---|
| [ADR-001](ADR-001-series-foundation.md) | ADR Series Foundation | APPROVED | 2026-08-07 | Numbering policy; binding template; ADR index; terminology policy; adoption of Baseline v2 |
| [ADR-002](ADR-002-canonical-dataset-architecture.md) | Canonical Dataset Architecture (constitution) | APPROVED | 2026-08-06 | P1–P9, I1–I11, G1–G13, EC1–EC10; the constitution |
| [ADR-018](ADR-018-I11-SECURITY-DEFINER-GOVERNANCE.md) | I11 SECURITY DEFINER Governance | PROPOSED | 2026-08-11 (draft) | C6/PQ-2 — bounded R9 exception for the 28 live SECURITY DEFINER functions; P3–I11 conflict resolution (C6-D + C6-C). Renumbered from the historical ADR-003 draft per J-01 R1. |
| [ADR-019](ADR-019-EC8-AUDIT-CHAIN.md) | EC8 Audit Chain | PROPOSED | 2026-08-11 (draft) | PQ-1 — canonical EC8 audit chain `Decision → Evidence → Constraint → Rule` (Candidate A); enforcement chain as projection. Renumbered from the historical ADR-004 draft per J-01 R1. |
| ADR-003+ | (reserved) | — | — | New decisions only; number never reused (ADR-001 §2.1). ADR-003/ADR-004 are historical drafts with superseded numbering (J-01 R1) — NOT part of the formal series; see `ADR-003-004-PRE-BOARD-REVIEW.md` §Phase 5. |

## 2. Informal-ADR reconciliation map

> Registered informal ADRs (ADR-002 §7). Their decision content is preserved; they are renumbered into the formal series during transition Phase 3 (ADR-001 §2.1; governance roadmap §2.1; EC10). Formal numbers are reserved as TBD-P3 until then.

### 2.1 RC4 architecture review — `docs/rc4-architecture.md` (informal ADR-01..08)

| Informal ref | Topic | Decision content | Formal number |
|---|---|---|---|
| RC4 ADR-01 | PDF generation | Approved library / approach for PDF rendering | TBD-P3 (ADR-003) |
| RC4 ADR-02 | Email delivery | Approved email transport approach | TBD-P3 (ADR-004) |
| RC4 ADR-03 | Migration framework | Approved DB migration approach | TBD-P3 (ADR-005) |
| RC4 ADR-04 | HTML sanitization | Approved sanitization library | TBD-P3 (ADR-006) |
| RC4 ADR-05 | Test coverage | Approved test coverage policy | TBD-P3 (ADR-007) |
| RC4 ADR-06 | Token storage | Approved client token storage approach | TBD-P3 (ADR-008) |
| RC4 ADR-07 | Caching | Approved caching approach | TBD-P3 (ADR-009) |
| RC4 ADR-08 | Job runner | Approved background job approach | TBD-P3 (ADR-010) |

### 2.2 Phase5 observability audit — `docs/devops/phase5-priority3-observability-audit.md` (informal ADR-001..007)

| Informal ref | Topic | Decision content | Formal number |
|---|---|---|---|
| Phase5 ADR-001 | Health probes | Approved health probe endpoints | TBD-P3 (ADR-011) |
| Phase5 ADR-002 | Metrics library | Approved metrics instrumentation library | TBD-P3 (ADR-012) |
| Phase5 ADR-003 | Metrics security | Approved metrics exposure security | TBD-P3 (ADR-013) |
| Phase5 ADR-004 | Naming | Approved metrics/host naming convention | TBD-P3 (ADR-014) |
| Phase5 ADR-005 | Health consolidation | Approved health aggregation strategy | TBD-P3 (ADR-015) |
| Phase5 ADR-006 | Workflow telemetry | Approved workflow-state telemetry | TBD-P3 (ADR-016) |
| Phase5 ADR-007 | Notification metrics | Approved notification-sink metrics | TBD-P3 (ADR-017) |

## 3. Pending ADR-board questions

> Questions surfaced by architectural review that require an ADR-board decision before the next phase. Resolved here → decisions are recorded as formal ADRs (ADR-001 §2.1). Raised in `docs/architecture/registry/phase3-review-decision.md` and `phase3-conditions-closure-report.md`.

| PQ | Question | Source | Required decision | Status |
|---|---|---|---|---|
| PQ-1 | Which traceability chain is authoritative for EC8: the §2.3 chain `Decision → Evidence → Constraint → Rule`, or the §4 full chain via Verification/Gate? | LOW-2 (`phase3-review-decision.md`) | Select one chain; record the other as a projection — **proposed in [ADR-019](ADR-019-EC8-AUDIT-CHAIN.md)** | OPEN |
| PQ-2 | When will the ADR board record the I11 SECURITY DEFINER exception (formal ADR with dated commitment) and resolve the P3–I11 conflict? | C6 / R9 (`phase3-review-decision.md`, I11) | Formal ADR committing to the exception and conflict resolution — **proposed in [ADR-018](ADR-018-I11-SECURITY-DEFINER-GOVERNANCE.md)** | OPEN |

> Status remains **OPEN** for both — the proposed ADRs (ADR-018/ADR-019, PROPOSED) record the proposed decisions; they do not close the questions. Only the ADR Board's formal decision can close them.

## 4. References

- `ADR-001-series-foundation.md` (this index's authority; §2.1–§2.3)
- `ADR-002-canonical-dataset-architecture.md` (§7 — formal series status, numbering reservation, informal ADRs)
- `docs/architecture-transition-plan.md` (§5.1 Phase 3 renumbering; EC10)
- `docs/governance-transition-roadmap.md`
