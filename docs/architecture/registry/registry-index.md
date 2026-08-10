# Constitutional Registry — Registry Index (skeleton)

> Skeleton of the Constitutional Registry (transition Phase 0 deliverable). Establishes the 11 registries of the constitutional enforcement architecture (`constitutional-enforcement-architecture.md` §2) as named, owned, and traced-to-authority placeholders.
> **Scope constraint:** Phase 0 creates the registry *skeleton* — names, ownership, authority, and placeholder status. It implements NO enforcement logic, NO runtime behavior, and NO verification. That is the mandate of later phases (constitutional-enforcement-architecture §8; transition plan Phase 0).
> Authority: ADR-001 (series foundation), ADR-002 (constitution), `constitutional-enforcement-architecture.md`, `constitutional-enforcement-domains.csv` (D1–D8).

## 1. The eleven registries

| # | Registry | Owned by (D-domain) | What it will hold | Phase 0 placeholder status |
|---|---|---|---|---|
| R1 | **Rule Registry** | D1 Constitutional Definition | The authoritative enumeration of every constitutional rule (P1–P9, I1–I11, G1–G13, EC1–EC10) with legal state, owner, supersession history. Nothing is constitutional unless registered. | Enumeration source = ADR-002 + `constitution-enforcement-matrix.csv` (43 rows). Skeleton only — no state held. |
| R2 | **Constraint Registry** | D2 Constraint | The checkable operational predicate per rule ("what does a violation look like?"). A rule without a registered constraint is unfalsifiable. | Gap baseline = `enforcement-gap-register.csv` (31 of 43 elements lack a constraint). |
| R3 | **Evidence Registry** | D3 Evidence | The artifacts each constraint examines, their owning body (P2/I4/G5), currency. Unregistered evidence is inadmissible. | Gap baseline = `enforcement-gap-register.csv` (30 of 43 lack evidence). |
| R4 | **Verification Registry** | D4 Verification | The objective procedure per constraint, its inputs/outputs, last run, result. Unregistered verification does not exist. | EC1–EC10 are the initial verification set (enforcement architecture §8). No procedures defined in Phase 0. |
| R5 | **Gate Registry** | D5 Gate | The binding process points and the verification each gate requires. | Gap baseline = 0 of 43 elements have a gate. |
| R6 | **Decision Registry** | D6 Decision & Exception | The recorded outcome of every verification and gate ruling, with authority. | Gap baseline = 0 of 43 have decisions. |
| R7 | **Execution Registry** | D8 Execution & Provenance | Construction and execution events with provenance that survives restore (I2/C3/P7). No decision relies on an event absent here. | `ops.seed_tracker` rows are untrusted (A1); provenance must be rebuilt in later phases, not migrated. |
| R8 | **Architecture State Registry** | D7 Constitutional State | The legal state of every constitutional object per `constitutional-state-machine.md`. A rule whose state is unknown is not usable. | 9 states (Draft, Proposed, Approved, Active, Verified, Violated, Suspended, Deprecated, Archived); 15 transitions. No state held in Phase 0. |
| R9 | **Exception Registry** | D6 Decision & Exception | Sanctioned deviations with authority, scope, expiry. An unrecorded deviation is a violation regardless of intent. | Known precedent awaiting recording: the I11 SECURITY DEFINER bypass (`33-fix-register-rls.sql`). Recording is NOT Phase 0 work — deferred with its ADR review. |
| R10 | **Ownership Registry** | D3 Evidence (ownership declared here; enforced by evidence domain) | The single owning body of every artifact and datum (P2/I4/G5). | Ownership matrix per `constitutional-enforcement-domains.csv` (D1–D8 responsibility column). |
| R11 | **Vocabulary Registry** | D1 Constitutional Definition | The final vocabulary, forbidden terms, and the term gate (G4/G11; EC2/EC5). A term not registered may not enter an active document. | **Populated in Phase 0**: `docs/reference/glossary.md` (final vocabulary + forbidden terms). This registry's content is live. |

## 2. Enforcement chain mapping

The eleven components map to the enforcement chain (enforcement architecture §2 component grouping):

`Rule (R1) → Constraint (R2) → Evidence (R3, R10, R11) → Verification (R4) → Gate (R5) → Decision (R6, R9)` — with cross-cutting `Execution (R7)` and `Architecture State (R8)`.

The chain is satisfied only when each rule's links run through the registries in order — not by the existence of the registries (enforcement architecture §2).

## 3. Known gaps deferred by design (Phase 0 does not close these)

- Enforcement links absent for the 43 constitutional elements: constraints 12/43 present, evidence 13/43, verification 11/43, gates 0/43, decisions 0/43 (`constitution-enforcement-matrix.csv`).
- Maturity baseline 0.12/4.00 (`constitutional-maturity-model.csv`); enforcement readiness 9 Ready / 34 Needs Extension / 0 Impossible (`architecture-enforcement-model.md` §5).
- I11 remains bypassed (SECURITY DEFINER `33-fix-register-rls.sql`) with no recorded exception — recording is deferred to a later phase, NOT resolved here.

## 4. Change control

- Adding a registry entry, changing registry ownership, or defining an enforcement link is governed by ADR-001/ADR-002 (constitutional change requires an ADR). Registry skeleton edits that do not change authority are ordinary documentation changes.
- Traceability of every Phase 0 file: `traceability-register.md`.

## 5. References

- `constitutional-enforcement-architecture.md` §2 (component table), §3, §8
- `constitutional-enforcement-domains.csv` (D1–D8 ownership)
- `constitutional-state-machine.md` (R8 states/transitions)
- `constitution-enforcement-matrix.csv`, `enforcement-gap-register.csv`, `constitutional-maturity-model.csv`
- `reference/glossary.md` (R11 content)
- ADR-001, ADR-002
