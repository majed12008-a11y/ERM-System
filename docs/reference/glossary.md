# Glossary

> Terminology registry of Architecture Baseline v2. Binding on all active documents (ADR-001 §2.4; transition plan §6.5; EC2).
> Governed by the final vocabulary below. New terminology requires an ADR (Governance Freeze §3).
> Source data: `terminology-transition-plan.csv` (28 rows, T1–T28) and `architecture-terminology-registry.csv` (19 rows).
> ID references below use the transition-plan row (T-<row>).

## 1. Canonical terms — final vocabulary

| Term | Status | Definition | Source |
|---|---|---|---|
| Canonical Dataset | Canonical | THE product; the source of truth (P1). The canonical dataset content (Era-2 Yemen lineage) as the single authority. | T-11; ADR-002 P1 |
| Installer History | Canonical | The role of the seed suite: an append-only change ledger; never the product (P1). | T-12; ADR-002 |
| Baseline | Canonical | A versioned, reproducible dataset STATE (I3); never the dump. | T-13; ADR-002 I3 |
| Aggregate | Canonical | The authoritative invariant model (P3, P6, I5, I10); to be added to DOMAIN_MODEL in Phase 1. | T-14; ADR-002 |
| Aggregate Root | Canonical | Named for Application and Condition (Phase 1). | T-15 |
| Runtime-Generated Data | Canonical | Data class (audit, sessions, history, outbox) that is never seeded (I11). | T-16; ADR-002 I11 |
| Scenario Dataset | Canonical | Dataset category: business scenarios over canonical data. | T-21 |
| Fixture | Canonical | Presentation/test data over canonical data; qualified Demo/Pilot/Test. | T-22 |
| Reference Dataset | Canonical | Idempotent, environment-invariant master data. | T-23 |
| Migration | Canonical | Versioned, forward-only schema evolution; distinct from data. | T-24 |
| Provenance | Canonical | Execution evidence that survives restore (I2, I7). | T-25; ADR-002 |
| Dataset Lifecycle | Canonical | Promote, version, deprecate, branch, merge, archive (P5). | T-26; ADR-002 P5 |
| Dataset Construction | Canonical | The construction path for datasets; restoration is not construction (I3). Replaces "Baseline-restore (as install path)". | T-7; ADR-002 I3 |

## 2. Allowed terms — qualified use

| Term | Status | Definition | Source |
|---|---|---|---|
| Seed (as historical artifact) | Allowed | The 79 files in `backend/seed/` when describing history; qualified as "seed file (historical)". | T-5 |
| Runtime (engine) | Allowed | Form Runtime = the schema-driven form ENGINE; distinct from Runtime-Generated Data. | T-17 |
| Domain | Allowed (qualified) | Must be qualified: Bounded Context (DOMAIN_MODEL) / Domain Module (backend) / Domain Schema (DB). | T-18 |
| Canonical Lineage | Allowed synonym | Canonical Dataset content (Era-2 Yemen). | T-19 |
| Canonical Schema | Allowed synonym | Schema authority (`database/canonical/`); distinct from Canonical Dataset. | T-20 |
| Gate-0 | Allowed (historical) | Historical milestone / dump referent; not a forward construct. | T-27 |
| Era-1/2/3 | Allowed (historical) | Epoch labels for the installer history. | T-28 |
| Dump | Allowed | Carrier/mechanism artifact that reproduces a state by restoration; not the dataset (C2). | registry #20; ADR-002 C2 |

## 3. Deprecated terms — use replacement

| Deprecated term | Replacement | Transition period | Source |
|---|---|---|---|
| Canonical Seed | Canonical Dataset | Phase 0–5 | T-1 |
| Seed Suite (as product) | Installer History / Canonical Dataset | Phase 0–5 | T-2 |
| Seed (as future construct unit) | Migration / Reference Dataset / Scenario Dataset / Fixture | Phase 0–5 | T-3 |
| Validation Dataset | Canonical Dataset | Phase 2 | T-6 |
| Baseline-restore (as install path) | Dataset Construction | Phase 0–5 | T-7 |
| Dump / Gate-0 baseline (as source of truth) | Baseline (dataset state) / Dump (carrier) | Phase 0–5 | T-8 |
| seed-status [OK] as readiness proof | Provenance evidence | Phase 4 | T-9 |
| Business Object | Business Entity (DOMAIN_MODEL) / Aggregate (ADR) | Phase 1 | T-10 |

## 4. Forbidden terms in active documents

The following usages must not appear in active Baseline v2 documents (transition plan §6.4):

- "Canonical Seed" (a dataset is never a kind of seed)
- "Seed Suite is the source of truth" / "the seed suite is the deliverable" (contradicts P1)
- "keep the dump as single source of truth" (contradicts P1, C2)
- "validation dataset" as a separate product
- "seed-status [OK] proves deployment" (contradicts I2)
- "Business Object" as a defined model term (undefined; conflicts with terminology constitution)

## 5. Notes

- Word-level ambiguities resolved by this registry are recorded in `architecture-terminology-registry.csv` (Seed, Seed Suite, Dataset, Baseline, Scenario, Fixture, Runtime, Business Object, Aggregate, Domain, Gate-0).
- Identification rule: when a word is ambiguous between dataset-category and fixture/scenario, use the qualified canonical term (Reference/Scenario/Fixture) over the bare word (registry #7, #9, #11).
