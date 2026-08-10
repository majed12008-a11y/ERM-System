# Constitutional Registry — Implementation Inventory (Phase 1)

> Inventory of the Phase 1 registry **foundation** — the structural TypeScript catalogs in `backend/src/governance/registries/`. Every registry is a read-only catalog (`ConstitutionalRegistry` base in `registry.ts`), owned by one enforcement domain (D1–D8), citing its authority, exposing zero business behavior. Companion to `phase1-completion-report.md` and `phase1-traceability-report.md`.
> Authority: `constitutional-enforcement-architecture.md` §2 (component responsibilities); `registry-index.md` (R1–R11).

## 1. Base layer

| File | Purpose | Notes |
|---|---|---|
| `types.ts` | Shared constitutional catalogs and record types: element ids (P/I/G/EC, 43), registry link status (`Mapped`/`Present`/`Present-Partial`), classifications, state ids (9), aggregate ids (A01–A25), table classifications. | Type-only + `as const` data. Source: ADR-002, `constitution-enforcement-matrix.csv`, `DOMAIN_MODEL.md`, `constitutional-state-machine.md`. |
| `registry.ts` | `ConstitutionalRegistry<TEntry>` read-only base: `id` (R1–R11), `ownedBy` (D1–D8), `authority` references, `entries`, `traceability()`. Marks Phase 1 scope and the runtime-enforcement prohibition. | `PHASE_1_SCOPE = 'structural-foundation'`; `RUNTIME_ENFORCEMENT_PROHIBITED` documents the ban on wiring these modules into runtime behavior. |
| `index.ts` | Facade re-exporting all types, base, and the 11 registries; exports the ordered `REGISTRIES` catalog. | Free of routes/services/middleware; nothing in `src/index.ts` or `src/modules/` imports it. |

## 2. Registry-by-registry inventory

| Registry | Owner | Entries (Phase 1) | Content source | Exported catalog |
|---|---|---|---|---|
| R1 Rule | D1 | 43 elements (P1–P9, I1–I11, G1–G13, EC1–EC10) with type, rule text, 5 link statuses, classification, intended verification | `constitution-enforcement-matrix.csv` (43 rows); ADR-002 | `CONSTITUTIONAL_RULES`, `RULE_REGISTRY` |
| R2 Constraint | D2 | 12 present constraints (I1, I11, EC1–EC10); gap baseline 31 | `enforcement-gap-register.csv`; matrix constraint column | `CONSTRAINTS_PRESENT`, `CONSTRAINT_GAP_COUNT` (=31), `CONSTRAINT_REGISTRY` |
| R3 Evidence | D3 | 7 evidence artifact types (with owning body); 13 present evidence sources; gap baseline 30 | `constitutional-enforcement-architecture.md` §2/D3; matrix evidence column | `EVIDENCE_ARTIFACTS`, `EVIDENCE_PRESENT`, `EVIDENCE_GAP_COUNT` (=30), `EVIDENCE_REGISTRY` |
| R4 Verification | D4 | EC1–EC10 initial verification set: 7 Ready / 3 NeedsExtension, all `NotRegistered`; note for Ready non-EC (I11, G11) | `constitutional-enforcement-architecture.md` §6.1/§8 | `VERIFICATION_RECORDS`, `READY_OUTSIDE_INITIAL_SET`, `VERIFICATION_REGISTRY` |
| R5 Gate | D5 | 5 gate definitions (publication, disposition, ADR approval, construction acceptance, cutover); 0 element assignments | D5 scope (domains CSV); architecture §2 | `GATES`, `GATE_ELEMENT_ASSIGNMENTS` (empty), `GATE_REGISTRY` |
| R6 Decision | D6 | 0 decisions recorded (type catalog + traceability note) | architecture §2 (Decision Registry); T3/G3/EC8 | `DECISIONS` (empty), `DECISION_REGISTRY` |
| R7 Execution | D8 | 4 execution event types; `SEED_TRACKER_UNTRUSTED` (A1) marker; 0 events | D8 scope; I2/C3/P7; challenge review A1 | `EXECUTION_EVENT_TYPES`, `EXECUTION_EVENTS` (empty), `SEED_TRACKER_UNTRUSTED`, `EXECUTION_REGISTRY` |
| R8 Architecture State | D7 | 9 states (with meaning + binding effect); 15 transitions (with condition + authority); 7 state rules | `constitutional-state-machine.md` | `CONSTITUTIONAL_STATES`, `STATE_TRANSITIONS`, `STATE_RULES`, `STATE_REGISTRY` |
| R9 Exception | D6 | `KNOWN_PRECEDENTS` = I11 SECURITY DEFINER bypass (`33-fix-register-rls.sql`) as `Unrecorded`/deferred; 0 sanctioned exceptions | architecture §2 (Exception Registry); I11 bypass precedent | `KNOWN_PRECEDENTS`, `EXCEPTIONS` (empty), `EXCEPTION_REGISTRY` |
| R10 Ownership | D3 | 25 aggregate definitions (tier, purpose, business owner, root entity, responsibility, boundary); 234 tables (`aggregate`, `schema`, `table`, `ownership`, `classification`) — 0 duplicates, every table assigned exactly once | `DOMAIN_MODEL.md` §1; `aggregate-table-mapping.csv` (234 rows) | `AGGREGATES`, `AGGREGATE_TABLES`, `OWNERSHIP_REGISTRY` |
| R11 Vocabulary | D1 | 13 canonical terms; 8 allowed terms; 8 deprecated terms (with replacement + transition period); 6 forbidden usages; term gate | `reference/glossary.md` (final vocabulary + forbidden terms) | `CANONICAL_TERMS`, `ALLOWED_TERMS`, `DEPRECATED_TERMS`, `FORBIDDEN_TERMS`, `TERM_GATE`, `VOCABULARY_REGISTRY` |

## 3. Structural test inventory

`__tests__/registries.test.ts` — 43 structural tests, pure TypeScript (no DB), covering:

- **Facade:** 11 registries in order R1–R11; every registry declares an owning domain (D1–D8) and non-empty authority.
- **R1:** 43 elements; id order P/I/G/EC; no duplicates; type ↔ id-prefix consistency; non-empty rule text.
- **R2:** 12 present constraints; gap = 31; present set exactly {I1, I11, EC1–EC10}.
- **R3:** 7 artifact types; 13 present evidence; gap = 30.
- **R4:** EC1–EC10 initial set; 7 Ready / 3 NeedsExtension; all `NotRegistered`.
- **R5:** 5 gates; 0 element assignments.
- **R6:** 0 decisions.
- **R7:** `ops.seed_tracker` marked untrusted with "rebuilt, not migrated" disposition; 0 events.
- **R8:** 9 states matching the catalog; 15 transitions; Archived terminal with null destination.
- **R9:** I11 precedent unrecorded; 0 sanctioned exceptions.
- **R10:** 25 aggregates (A01–A25); 234 tables; no duplicate aggregate ids; every table maps to a defined aggregate; no duplicate `(schema, table)` pairs.
- **R11:** non-empty canonical/allowed/deprecated/forbidden lists; every deprecated term has a replacement + transition period; term gate cites G4/G11/EC5.

## 4. Deliberately NOT implemented (by Phase 1 scope)

- No constraint predicates authored (R2 status only), no verification procedures (R4 `NotRegistered`), no gate bindings (R5 empty), no decisions (R6 empty), no execution events (R7 empty), no sanctioned exceptions (R9 empty).
- No runtime wiring: the facade is not imported by `src/index.ts`, `src/modules/`, or any route/service/repository. No API, OpenAPI, schema, migration, or seed changes.
- No new ADRs, no architectural documents.
