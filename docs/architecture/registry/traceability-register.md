# Traceability Register — Phase 0 deliverables

> Traceability scaffolding for the Phase 0 constitutional scaffolding (transition plan Phase 0). Records, for every Phase 0 deliverable, its provenance in the approved architecture and its contribution to exit criteria EC1/EC2.
> Authority: ADR-001 §2, ADR-002, `architecture-transition-plan.md` (Phase 0 output list), `architecture-governance-freeze.md` (§3, §4), `architecture-baseline-v2-index.md` (§2 items 2–4).
> This register is documentation only; it implements no verification. EC1/EC2 are the verification set for later phases (D4).

## 1. Deliverable traceability

| Phase 0 deliverable | File | Provenance (approved architecture) | Exit criterion | Disposition status |
|---|---|---|---|---|
| ADR-001 (series foundation) | `architecture/adr/ADR-001-series-foundation.md` | Transition plan Phase 0 output list; ADR-002 §7 ("ADR-001 has not been authored"); Governance Freeze §4 (first governance act) | EC1 | Created |
| Binding ADR template | `templates/adr-template.md` | Transition plan Phase 0 output list; ADR-001 §2.2; EC1 | EC1 | Populated (was empty, 0 lines) |
| ADR index (with informal-ADR reconciliation map) | `architecture/adr/ADR-INDEX.md` | Transition plan Phase 0 output list; ADR-002 §7 (RC4 ADR-01..08; phase5 ADR-001..007); governance roadmap §2.1; EC10 (Phase 3 renumbering) | EC1, EC10 | Created |
| Architecture glossary / terminology registry | `reference/glossary.md` | Transition plan Phase 0 output list; transition plan §6.5 (final vocabulary, 28 rows T1–T28); baseline index §2 item 4; G1 (was empty) | EC2 | Populated (was header-only) |
| Document index | `reference/document-index.md` | Transition plan Phase 0 output list; `architecture-baseline-v2-index.md` (three-set baseline); consolidation review §7 | EC2 | Populated (was header-only) |
| Constitutional Registry skeleton | `architecture/registry/registry-index.md` | `constitutional-enforcement-architecture.md` §2 (11 registries); `constitutional-enforcement-domains.csv` (D1–D8); enforcement architecture verdict "YES AFTER IMPLEMENTING THIS ARCHITECTURE" | — | Created |
| Traceability scaffolding register | `architecture/registry/traceability-register.md` | Transition plan §5.1 (traceability); T3/G3/EC8 backward-traceability requirement | EC8 (later phase) | Created |
| Repository README update | `docs/README.md` | Governance Freeze §3 (documentation governance); baseline index §2 | EC2 | Updated (Decisions/ADR section) |

## 2. Non-scope confirmation (Phase 0 delivers none of these)

| Out of scope | Rationale (authority) |
|---|---|
| Enforcement logic, constraints, verification procedures, gates | Enforcement architecture §8 — enforcement is implemented in later phases |
| Seed runner / dataset logic / migrations | Transition plan Phase 0 scope; no code/SQL/manifests |
| Resolution of known constitutional conflicts (P3 vs I11; I11 SECURITY DEFINER bypass; P7 circularity) | Governance rule: architectural conflicts STOP and report; never invent a solution |
| ADR-003+ or renumbering of informal ADRs | ADR-001 §2.1 — reserved for later phases (Phase 3 renumbering, EC10) |
| Code, SQL, commits, runtime behavior changes | Mission constraint: documentation only, zero code touched |

## 3. References

- `architecture/registry/registry-index.md` (§4 — change control for this register)
- `architecture/adr/ADR-INDEX.md` — ADR authority chain
- `architecture-baseline-v2-index.md` — baseline set definitions
