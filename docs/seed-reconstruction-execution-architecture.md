# Seed Reconstruction Execution Architecture — RC4

**Status:** Final DESIGN phase — architecture only. No SQL, no code, no migrations, no commits.
**Authoritative baseline (design inputs):**
- `database-population-audit.md` — 234 tables, 45,453 rows, 112 populated
- `seed-coverage-matrix.md` + `.csv` — 79 seed files, 78 tracked
- `architecture-normalization-review.md` + tables/seeds — 7-way seed taxonomy (29 migration / 15 scenario / 12 reference / 10 patch / 6 demo / 5 infra / 2 test)
- `feature-traceability-review.md` + matrices — 28 features, 163/315 routes read empty tables
- `canonical-seed-specification.md` — canonical dataset, §4 dependency DAG (17 layers), §6 dead data, §7 quality rules, §8 acceptance criteria A1–A11
- `change-impact-analysis.md` — FK hubs (`security.users` 66 refs, `core.applications` 26 refs), runtime tables R1–R14, phase safety gates

**Current-state facts this design replaces:**
- Tracker `ops.seed_tracker` (single table: filename/checksum/applied_at/duration_ms/status/error) is **untrusted** — all 78 rows share one `applied_at` with `duration_ms=0` (bulk-restored, not executed); failed seeds recorded as `success`.
- Runner `scripts/apply-seeds.ps1` orders by **filename**, has **no dependency graph**, no per-seed row counts, no verification, no rollback, no baseline mode, `-DryRun` only echoes paths.
- Restore path `scripts/backup.ps1 -Action Restore` + `scripts/reset-dev-db.ps1` (baseline dump → new seeds → cleanup generated PDFs) is sound but bypasses the tracker (seed suite never replayed from scratch).

---

## SECTION 1 — Seed Runner Architecture

### 1.1 Execution model

A **standalone CLI orchestrator** (TypeScript/Node, matching the npm-workspaces monorepo; SQL executed via `psql -v ON_ERROR_STOP=1`) that drives a **single deterministic pipeline**: `plan → execute → verify → checkpoint`.

- **Sequential execution by default.** One seed file at a time, in topological order. Rationale: seeds mutate shared RLS-protected tables and reference each other; PostgreSQL advisory locks and DDL contention make parallelism non-deterministic. A `--parallel` flag may later unlock *verified-safe* independent reference seeds, but is out of scope for RC4.
- **One process, one run.** A `run` is a complete invocation with a fixed plan (seed set), a recorded mode, and a terminal state.
- **`psql` remains the execution vehicle.** Rationale: no re-implementation of SQL semantics, honors `ON_ERROR_STOP`, transaction control, and `SET SESSION app.user_id` (RLS context) exactly as today. The runner owns ordering/verification/recording; `psql` owns statement execution.
- **No mixed responsibilities.** The runner never mutates seed content, never guesses dependencies, never writes to business tables. It plans, executes, records, verifies, and reports.

### 1.2 Dependency resolution

- Each seed carries a **manifest** declaring `depends_on` (seed ids) and entity-level `prerequisites` (Section 7).
- At run start the runner:
  1. Loads the suite manifest + every per-seed manifest.
  2. Builds the full DAG (Section 3).
  3. Validates that every declared dependency exists in the registry.
  4. Resolves the execution order by topological sort.
- **Filename order is explicitly ignored.** Rationale: the canonical DAG (§4 of the spec) is the sole source of ordering truth; filename ordering is the root cause of the historical cross-version bugs (`06` needed institutions from `10`, etc.).

### 1.3 Layer execution

- Seeds are grouped into the 17 canonical layers (spec §4). Execution proceeds layer by layer; a **layer gate** (Section 9, G1) runs between layers.
- Within a layer, seeds execute in DAG order; cross-layer edges are permitted only downward (a seed may depend on any lower layer).
- **Layer invariants:** at layer boundary the runner records a checkpoint and verifies that (a) all layer tables reach declared floors, (b) no runtime table changed, (c) FK/orphan/duplicate scans are clean.

### 1.4 Transaction boundaries

- **One seed = one transaction.** Each seed runs inside `BEGIN … COMMIT` (or `psql -1`). Rationale: preserves the existing all-or-nothing guarantee (per-file rollback) that `apply-seeds.ps1` already relies on, and makes a failed seed trivially recoverable (nothing committed).
- **Layer ≠ transaction.** Rationale: a full layer is too large to hold in one transaction; committing per seed gives checkpoint granularity and lets the operator resume mid-layer after a fix.
- **Verification runs outside the seed transaction.** Rationale: assertions must observe committed state and must never partially commit with a seed.
- **Deny-list enforcement inside the transaction boundary:** the runner pre-scans each seed for writes to runtime tables (Section 6.4) and refuses execution before `BEGIN`.

### 1.5 Retry behavior

- **No automatic retries for deterministic failures** (SQL error, constraint violation, FK failure). Rationale: the seed is defective or the data state is wrong; retrying masks the defect. The run stops, the seed is recorded `failed`, and the operator must fix content and resume.
- **Automatic retry (≤3, exponential backoff) only for transient connection errors** (connection refused, timeout, deadlock victim). Rationale: these are environment, not seed, failures.
- **Resume contract:** a failed run can be resumed from the last committed checkpoint. Seeds already recorded `committed` with identical checksum are skipped (Section 2 replay policy); the failed seed is re-attempted after the operator's fix.

### 1.6 Dry-run mode

`--dry-run` produces a **complete plan with no writes**:
- Parses and validates all manifests; resolves the DAG; reports cycle errors.
- Lists, in execution order: each seed, bucket, layer, checksum, expected assertions, and whether it would be applied / skipped / blocked.
- Executes **read-only** verification queries (`SELECT` only) to preview row counts and prerequisite satisfaction.
- Never calls `psql` with a mutation, never touches the tracker.
Rationale: the current `-DryRun` only echoes file paths; a real dry-run is the primary safety tool for reviewing a reconstruction before it happens.

### 1.7 Verification mode

`--verify` runs the full verification engine (Section 4) against the current database state **without executing any seed**. Sub-modes:
- `--verify-quick` — row-count assertions only (fast CI smoke).
- `--verify-features` — 28-feature completeness proofs only.
- `--verify-full` — everything (used before baseline certification).
The verification engine is also invoked automatically after every seed (light) and every layer (full), per Section 4.

### 1.8 Baseline mode

Two explicit entry modes, mutually exclusive:
- **`from-dump`:** restores a versioned canonical dump (via the existing `backup.ps1 -Action Restore`), then runs only the seeds **added since that dump** (checksum-driven). This is exactly the `reset-dev-db.ps1` flow, now tracker-trusted. Rationale: preserves the deterministic restore workflow that currently works.
- **`from-scratch`:** schema migrations → infrastructure bootstrap → reference → core → scenarios → demo → verification → freeze. Rationale: this is the mode that finally makes the 79-file suite re-runnable end-to-end, eliminating the "seed suite not re-runnable" limitation.
Both modes converge on a **Verified Canonical Baseline** (Section 8, stage 13).

### 1.9 Failure handling

- Fail-fast by default: a failed seed or failed gate aborts the run; no subsequent seeds execute in that run.
- The failed seed's transaction is rolled back; `ops.seed_executions` records `failed` + error + the recovery checkpoint.
- A **report** is emitted: executed seeds, skipped seeds, failed seed with `psql` stderr, verification results, and the exact resume command.
- `--continue-on-error` is permitted **only** for `fixtures/demo` and `fixtures/pilot` buckets (never for reference/core/scenario); a demo failure is recorded and reported but does not block the rest of the demo layer.

---

## SECTION 2 — Seed Tracker Redesign

The single flat `ops.seed_tracker` table is replaced by a **trusted, append-only, multi-table registry**. Design only — no DDL is specified here.

### 2.1 Data model (conceptual)

| Store | Purpose | Key traits |
|-------|---------|------------|
| `ops.seed_registry` | Immutable metadata for every known seed | `seed_id` (slug), bucket, layer, version, `sql_sha256`, `manifest_sha256`, `depends_on[]`, `prerequisites[]`, assertions, scope_key, deny flags. Content-addressed. |
| `ops.execution_runs` | One row per runner invocation | `run_id`, mode (`from-dump`/`from-scratch`), baseline_ref, started/finished, overall state, summary. |
| `ops.seed_executions` | One row **per attempt** per seed | `execution_id`, `run_id`, `seed_id`, started/finished, `duration_ms`, `rows_affected`, execution_state, verification_state, error, `checkpoint_ref`. Append-only — never upserted. |
| `ops.rollback_ops` | Reverse-operation metadata | `seed_id`, scope_key, prior row counts, compensating delete criteria, checkpoint timestamp. |
| `ops.verification_results` | Every check execution | `check_id`, scope (seed/layer/suite), expected, actual, passed. Append-only. |

### 2.2 Lifecycle

```
registered → pending → running → committed ─→ (verified / verification_failed)
                              ├─→ failed ─→ (operator fix → pending again)
                              ├─→ rolled_back
                              └─→ skipped (reason recorded)
```

- `registered` — present in registry, never attempted in this run.
- `pending` — in the resolved plan, not yet started.
- `running` — transaction open.
- `committed` — transaction committed; verification pending.
- `failed` — transaction rolled back; error captured; not eligible for skip.
- `rolled_back` — committed, then compensated by a rollback op (Section 5).
- `skipped` — explicit `--include`/`--exclude`, or checksum-unchanged replay skip. Reason is mandatory.

### 2.3 Execution states vs verification states

- **Execution states** describe *whether the seed's SQL ran and committed* (Section 2.2).
- **Verification states** describe *whether the seed's assertions were checked*: `unverified → verified → verification_failed`.
- A seed is only `verified` after its own assertions **and** its layer gate pass. A `verification_failed` seed is treated like `failed` for replay purposes — it cannot be skipped on the next run until its assertions pass.

### 2.4 Checksum policy

- `sql_sha256` = SHA-256 of the seed SQL file content. `manifest_sha256` = SHA-256 of the canonical serialized manifest. Both are stored.
- **Replay decision is checksum-based:** a seed is replayed if (a) never committed, (b) either checksum changed from the last committed execution, (c) `--force`, or (d) any dependency was replayed since it committed (invalidation cascade).
- **Checksum drift requires explicit action.** A changed seed is never silently skipped; the runner reports `[CHANGED]` and requires `--force` (mirrors today's behavior, but now at the per-seed DAG level and recorded in `seed_executions`).
- The 78 bulk-restored rows are **not migrated** — the trusted registry starts empty; `from-dump` mode trusts the dump's own data and only records seeds actually executed afterward.

### 2.5 Replay policy

- Deterministic: identical manifest + identical sql + no dependency invalidation → skipped with recorded `skipped(unchanged)`.
- Invocation is idempotent: running the same plan twice on the same state produces the same end state (A2).
- `from-scratch` on a fresh DB replays everything; `from-dump` replays only deltas.

### 2.6 Rollback metadata

- Each committed execution optionally records a `rollback_ops` row: scope_key, prior row counts, and the compensating criteria (natural-key/scope-based DELETE) that would remove exactly the rows it inserted. Rationale: enables chain-level rollback without id-anchoring (Section 5.1).
- The checkpoint_ref ties the execution to the last durable checkpoint (Section 5.2), so "roll back to before seed X" is a restore of checkpoint + replay of verified predecessors.

### 2.7 Dependency metadata

- `depends_on[]` is stored per seed and is **authoritative** — the DAG is built from registry data, never inferred from filenames.
- At registry load, the runner validates: every `depends_on` id exists; no duplicate edges; edges only point to equal-or-lower layers; the graph is acyclic (Section 3.2). Corrupt metadata aborts the run before any SQL executes.

---

## SECTION 3 — Dependency Engine

### 3.1 DAG model

- Nodes = `seed_id` (registry entries). Edges = `depends_on` (hard) with an optional `kind: optional` for demo/pilot/test fixtures.
- Every node carries: `layer` (0–16 per canonical §4), bucket, and entity-level `prerequisites` (`{schema, table, min_rows?}`).
- Edges are **explicit and declared**, never discovered. Rationale: prevents the historical class of silent cross-seed coupling (e.g. `06` silently assuming `10`'s institutions).

### 3.2 Cycle detection

- Kahn's algorithm at plan time; on cycle detection the run aborts **before any SQL** and reports the full cycle path (e.g. `A→B→C→A`).
- Because edges are registry-declared, cycles are caught at manifest-parse time in CI, not at seed-execution time.

### 3.3 Ordering

- Topological sort of the DAG, tie-broken deterministically by `(layer, declared_order)`.
- Determinism is required for reproducible reports and for idempotent replay comparison (A8).
- The resolved order is written into the run plan (and a `lockfile` for the frozen canonical version, Section 7) so a given canonical version always resolves identically.

### 3.4 Prerequisite validation

- **Entity prerequisite:** before executing a node, `SELECT 1 FROM <schema>.<table> LIMIT 1` (and optional `COUNT(*) >= min_rows`) is checked. Missing table or below-floor row count → hard fail with a message naming the seed that should have created the data.
- This directly prevents the five broken chains (17/18/28/29/33) from re-failing silently: e.g. safety mitigation seeds cannot run before `safety.risk_assessments` has rows.

### 3.5 Optional phases

- Buckets `fixtures/demo`, `fixtures/pilot`, `fixtures/test` are **optional by default**. They are included only when requested (`--include=demo` etc.).
- An optional node is `skipped` with reason `not_requested`; it never blocks a required node.
- Required buckets (reference, core, scenarios, patches, migrations) can never be skipped via flags.

### 3.6 Skipped phases

Three distinct skip reasons, all recorded:
1. `not_requested` — optional bucket excluded by flags.
2. `unchanged` — checksum match + no dependency invalidation (Section 2.5).
3. `blocked` — a required dependency failed; the node is marked skipped but the run is already failing (fail-fast). `blocked` skip is reported loudly, never silently.

---

## SECTION 4 — Verification Engine

Runs automatically at three scopes: **per-seed** (light), **per-layer** (full), **per-suite/baseline** (complete). All results append to `ops.verification_results`.

### 4.1 Row-count assertions

- Every seed declares assertion ranges for the tables it owns (e.g. `{table: "safety.risk_assessments", min: 3}`). Post-commit, the runner checks each range; violations → `verification_failed`.
- Global per-table floors come from the canonical population matrix (spec §2 minimums). A table below its declared floor at layer/suite scope fails verification.
- **No silent zero-row inserts** (spec §7 R3): a seed declaring min≥1 that inserts 0 rows fails.

### 4.2 FK validation

- Uses FK metadata (from the schema) to run anti-join scans: for each FK edge, `SELECT ... LEFT JOIN parent WHERE parent IS NULL` → count dangling refs. Any > 0 fails the layer gate.
- Rationale: the C1–C3 hubs (users 66 refs, applications 26, projects 10) make dangling-reference detection the single highest-value integrity check.

### 4.3 Orphan detection

- Rows whose parent exists but is **soft-deleted** (`deleted_at` set) while child rows remain active, on tables with soft-delete semantics (per `is_active_row()` convention). Detected and reported per layer; policy is configurable (fail vs warn) but default is fail for reference/core/scenario.

### 4.4 Duplicate detection

- On declared natural keys (unique codes/names): scan for duplicate `code`, `name_en`, `slug`, etc. across reference/master tables. Duplicates fail the layer gate (they would break key-based seeding and lookups).

### 4.5 Empty-chain detection

- **Expected non-empty chains:** every table that a route reads must have rows (S5 target: 163 empty-read routes → 0). A table that was empty and is required by the phase fails.
- **Expected empty chains:** runtime tables (Section 3 of the Change Impact Analysis) and dead data (`templates.*` after Phase 8) must be empty. Unexpected rows fail verification.

### 4.6 Business-rule assertions

- **RLS active:** for every RLS table, `relrowsecurity` must be `true`; no policy set may be empty. Rationale: RLS is the sole access control (AGENTS.md).
- **RULE 11 — terminal states:** `REJECTED`, `WITHDRAWN`, `ARCHIVED` have no outgoing transitions; `APPROVED`/`CLOSED` must still have outgoing transitions (to CLOSE/ARCHIVE).
- **RULE 12 — evidence matrix preconditions:** application + condition states and user roles present such that each of the 7 evidence-DELETE scenarios has at least one demonstrable row combination.
- **Audit plumbing:** `system.fn_log_audit()` exists and audit tables are trigger-wired (runtime-only).
- **Document lifecycle:** `documents.lifecycle_state_id` populated for all rows after Phase 3 migration.

### 4.7 Feature-completeness validation

- Maps the 28 features (feature matrix) to required tables and minimum counts; runs one proof query per feature.
- Also maps feature → routes (traceability) and asserts that no route reads an empty table for canonical data (excluding runtime-expected `password_reset_tokens`).
- Output is a per-feature pass/fail table used at baseline certification (Section 9, G3).

---

## SECTION 5 — Rollback Architecture

### 5.1 Rollback granularity

Four levels, chosen per failure class:

| Level | Scope | Mechanism | Used when |
|-------|-------|-----------|-----------|
| Seed | one seed | automatic transaction rollback | any SQL failure |
| Chain | one domain/chain (e.g. safety) | compensating `rollback_ops` deletes by scope_key, executed in reverse order | chain verification failure |
| Layer | one canonical layer | restore layer checkpoint (Section 5.2) | layer gate failure |
| Suite | whole run | baseline dump restore | irrecoverable state / corruption |

- Chain rollback uses **scope-key deletes** (Section 2.6), never id-based deletes, so it is safe across re-seeding.
- Layer and suite rollback use the durable checkpoint + replay of verified predecessors (never full re-run of everything, preserving determinism).

### 5.2 Checkpoint strategy

- **Durable checkpoint (suite):** the versioned canonical baseline dump. This is the "rollback point of last resort" for every phase (Change Impact §4).
- **Layer checkpoints (logical):** at each layer boundary, record per-table row counts + execution records + verification results. Rationale: cheap, sufficient to prove a layer was clean before proceeding, and to detect drift on resume.
- **Pre-restore safety dump:** `backup.ps1` already creates a `pre_restore_*` dump before any restore; retained as policy (Change Impact §4 rollback points).
- Checkpoint files are **versioned and immutable** — a checkpoint is written once and never overwritten.

### 5.3 Recovery strategy

1. On failure: roll back current seed (auto), record failure + checkpoint_ref.
2. Operator fixes content or data, then invokes `resume` from the last clean checkpoint.
3. Resume replays only seeds recorded `pending`/`failed`/`blocked` whose dependencies are satisfied; all `committed`+`verified` seeds are skipped by checksum.
4. If the state is not provably clean (verification was incomplete at failure), recovery **defaults to checkpoint restore** rather than assuming the DB is good.

### 5.4 Baseline restore policy

- **Never overwrite a baseline.** Every freeze writes a new versioned filename (`canonical-rc4-YYYY-MM-DD.dump`); the Gate-0 dump remains restorable (spec §10 Phase 10, Change Impact §4 irreversible ops).
- Restore is only accepted after a **restore-verification** step: post-restore row counts must match the recorded counts of the dump's baseline (A8).
- Restores always create a pre-restore safety dump first (already implemented in `backup.ps1`).

---

## SECTION 6 — Idempotency Architecture

Permanent rules enforced by the runner (Section 7 R9) and by verification (Section 4). **These are architectural rules, not conventions.**

### 6.1 Reference seeds

- **Natural-key upsert only** (`ON CONFLICT (natural_key) DO UPDATE/NOTHING` or `MERGE`), where `natural_key` is a declared business key (e.g. status `code`, workflow state `name`).
- Pure reference: no side effects, no references to volatile data, no timestamps of "now" that change on re-run.
- Re-run → identical final rows (A2). Asserted via row-count ranges and duplicate detection (4.4).
- **No hardcoded ids.** All inter-seed references are resolved by key lookup at insert time (C1/C2/C3 mitigation).

### 6.2 Scenario seeds

- Scoped by a **scenario key** (a stable business identifier of the scenario set). Re-running = delete rows belonging to the scope, then insert the same set → identical state.
- Scenario rows may reference reference/core rows by key; never by id.
- Asserted: post-run scope row counts match declared ranges; orphan/duplicate scans clean (4.2/4.4).

### 6.3 Demo seeds

- Same scope-key discipline as scenarios, plus a **demo marker** so the entire demo dataset is removable in one compensating op (rollback_ops with `scope=demo`).
- Demo is optional (3.5); removing demo must return the DB to core state (Gate before demo, Change Impact §8 gate 13).

### 6.4 Runtime-generated tables

- **Deny-list enforced by the runner:** `audit.*`, `security.sessions`, `security.login_audit`, `security.password_history`, `security.email_verification_tokens`, `security.password_reset_tokens`, `integration.event_outbox`, `communication.notification_logs`, `workflow.workflow_actions`, `workflow.workflow_history`, `reporting.analytics_snapshots`, `reporting.kpi_results`, `reporting.report_executions`, `documents.document_access`, `ops.seed_tracker`/new registry tables.
- A seed whose SQL text writes any deny-listed table is **refused before execution** (parsed via table-write detection).
- Verification asserts deny-listed tables are byte-for-byte unchanged across the run (row counts equal at start and end).
- Rationale: Change Impact §3 R1–R14 — these tables carry integrity/security state that fabrication would corrupt.

### 6.5 Global idempotency guarantee

- The suite is re-runnable end-to-end (`from-scratch` twice → identical counts). This is the permanent replacement for the current "not idempotent, must use baseline restore" limitation.

---

## SECTION 7 — Seed Package Architecture

### 7.1 Directory layout

```
backend/
  seeds/                              # NEW canonical seed tree (replaces flat backend/seed/)
    manifest.json                     # suite-level manifest (schema version, buckets, layers)
    lockfile.canonical-rc4.json       # frozen resolved DAG + checksums for the certified baseline
    reference/01-core-lookups/        #   seed.sql + seed.manifest.json (+ optional helpers/)
    core/02-users/
    core/03-committees/
    core/04-projects-applications/
    core/05-documents/
    scenarios/06-workflow-reviews/
    scenarios/07-meetings-certificates/
    scenarios/08-safety/
    scenarios/09-monitoring/
    scenarios/10-accreditation/
    scenarios/11-consent/
    scenarios/12-ethics-risk/
    fixtures/demo/yemen/              # canonical demo lineage
    fixtures/pilot/
    fixtures/test/
  seed/                               # LEGACY flat tree — frozen, read-only reference (not executed)
  migrations/                         # existing 29 schema migrations (untouched, ordered by their numeric prefix)
  patches/                            # existing 10 RLS/hotfix patches (kept, applied in declared order)
```

### 7.2 Naming convention

- Seed file: `{layer:02d}-{domain}-{purpose}.sql` (layer = canonical layer, e.g. `04-projects-applications.sql`).
- Manifest: identical base name + `.seed.json` (`04-projects-applications.seed.json`).
- Bucket name = parent directory. Layer is **derived from the canonical DAG**, not from the numeric prefix (the prefix is human-facing only).

### 7.3 Metadata format (seed.manifest.json)

```jsonc
{
  "id": "core.projects-applications",        // stable slug; dependency target
  "name": "Projects and Applications",
  "bucket": "core",                          // reference | core | scenarios | fixtures/demo | fixtures/pilot | fixtures/test | migrations | patches | infrastructure
  "layer": 4,                                // canonical layer 0..16
  "version": 1,
  "sql": "04-projects-applications.sql",     // executed with psql
  "depends_on": ["core.committees", "reference.core-lookups"],
  "prerequisites": [
    {"schema": "security", "table": "users", "min_rows": 12},
    {"schema": "core", "table": "institutions", "min_rows": 3}
  ],
  "assertions": [
    {"type": "rows", "table": "core.projects", "min": 3},
    {"type": "rows", "table": "core.applications", "min": 3}
  ],
  "scope_key": null,                          // for scenarios/demo: natural scope of the set
  "runtime_deny": false,                      // true → runner refuses execution
  "optional": false                           // true only for fixtures/*
}
```

### 7.4 Suite manifest (backend/seeds/manifest.json)

- Declares: `schema_version` (tracker/runner contract version), the bucket list, the canonical layer table (0–16 names), and the ordered list of seed ids per bucket.
- Enables CI to validate the whole tree (DAG acyclicity, checksums, denylist compliance) without touching the DB.

### 7.5 Lockfile (frozen canonical)

- `lockfile.canonical-rc4.json` captures the **exact resolved plan** (execution order, per-seed sql+manifest checksums, layer mapping, assertion set) at baseline certification.
- Reconstructing from the lockfile is byte-deterministic; a lockfile mismatch is reported before execution.

### 7.6 Dependency declarations

- **Seed-level:** `depends_on` (Section 3.1). **Entity-level:** `prerequisites` (Section 3.4). Both are mandatory in the manifest — a seed with neither and a non-empty assertion set is rejected at registry load.
- The runner never infers dependencies from SQL text or filenames (single source of truth).

---

## SECTION 8 — Execution Lifecycle

Complete path from **Fresh Database** to **Verified Canonical Baseline**. Every stage ends with a recorded checkpoint (Section 5.2) and passes its gate (Section 9).

| Stage | Activity | Gate | Checkpoint |
|-------|----------|------|-----------|
| 1 | **Fresh database** — create empty DB, schemas; run 29 migrations in declared order | G0 (pre-execution) | schema-only dump |
| 2 | **Infrastructure bootstrap** — `ops` registry + runner tables; load suite manifest; validate DAG + checksums + deny-list | G0/G1 | registry initialized |
| 3 | **Reference layer (L0)** — lookups, statuses, document types, workflow states/transitions, notification templates, report defs/widgets, `system_config` | G1 | layer checkpoint |
| 4 | **Core L1–L2** — institutions → departments → users/roles/permissions → committees/membership | G1 | layer checkpoint |
| 5 | **Core L3–L5** — projects (keywords/sites/team/funding) → applications → documents/versions | G1 | layer checkpoint |
| 6 | **Scenario L6–L8** — workflow instances/actions, conditions & evidence, certificates | G1 | layer checkpoint |
| 7 | **Blocked chains L10–L14** — safety, monitoring, accreditation, consent, ethics risk (rebuilt from scratch) | G1 | layer checkpoint |
| 8 | **Scenario L6-again + L15** — meetings/agenda/minutes/quorum, review answers/scores, notifications, integration demo | G1 | layer checkpoint |
| 9 | **Reporting L16** — compute KPI/dashboard aggregates from canonical data | G1 | layer checkpoint |
| 10 | **Demo/pilot/test fixtures** (optional `--include`) | G1 | fixture checkpoint |
| 11 | **Full verification** — A1–A11 + feature completeness + empty-read=0 | G2 | verification results |
| 12 | **Dead-data removal** — `templates.*` rows, fabricated runtime rows, Era-1 remnants; confirm deny-listed tables untouched | G2 | removal audit |
| 13 | **Canonical baseline freeze** — versioned dump + lockfile + checksums; Gate-0 preserved | G3 | **Verified Canonical Baseline** |

**Terminal state:** a versioned, restorable, byte-deterministic canonical baseline plus a lockfile that reproduces it.

---

## SECTION 9 — Acceptance Gates

### 9.1 Pre-execution gates (G0)

- G0.1 Baseline/restore availability: target dump exists and restores cleanly; pre-restore safety dump policy armed.
- G0.2 Suite integrity: all manifests parse; every `depends_on` resolves; DAG acyclic; layer mapping valid.
- G0.3 Deny-list compliance: no seed's SQL writes runtime tables (static scan).
- G0.4 No drift: lockfile (if present) matches current seed tree checksums; else `--force-lockfile-new` required.
- G0.5 RLS context pre-check: `SET SESSION app.user_id` path functional (pool connect handler present).

### 9.2 Phase gates (G1 — after each stage 3–10)

- G1.1 Per-seed assertions passed (all seeds in stage `verified`).
- G1.2 Per-layer verification passed: FK/orphan/duplicate/empty-chain scans clean.
- G1.3 Runtime tables unchanged (deny-list row counts identical pre/post).
- G1.4 Checkpoint recorded (row counts + verification results).
- Fail → stop; recover per Section 5.

### 9.3 Verification gates (G2 — stage 11/12)

- G2.1 Acceptance criteria A1–A11 (canonical spec §8) all green.
- G2.2 S5 empty-read = 0 (excluding runtime-expected `password_reset_tokens`).
- G2.3 28-feature completeness proofs green.
- G2.4 RLS matrix passes (registration flow + 7-scenario evidence-DELETE matrix, RULE 12).
- G2.5 Dead-data audit green: `templates.*` = 0, deny-listed tables intact.

### 9.4 Baseline certification (G3 — stage 13)

- G3.1 Determinism: `from-scratch` twice → identical per-table counts; restore-from-new-dump → identical counts (A8).
- G3.2 Lockfile written and verified to reproduce the dump exactly.
- G3.3 Gate-0 dump still restorable; new dump versioned, checksum recorded.
- G3.4 Certification signed off (documented in tracker `execution_runs`).

---

## SECTION 10 — Implementation Roadmap

Each phase is independently **testable** (dry-run + unit tests on the current baseline), **reviewable** (single self-contained deliverable), and **reversible** (no DB mutation until its own commit gate; baseline always restorable). No code is written here — these are the implementation work packages.

| # | Phase | Deliverable | Independently testable via | Independently reversible via |
|---|-------|-------------|---------------------------|------------------------------|
| 1 | **Trusted registry + tracker** | `ops.seed_registry`/`executions`/`runs`/`verification_results` schema + runner bootstrap | Dry-run on current baseline; unit tests of registry load | Restore baseline; registry starts empty |
| 2 | **Runner core** | plan/execute/record engine, `--dry-run`, mode selection | `--dry-run` prints full DAG plan for current 79 files (legacy fallback: single-bucket, DAG from declared order) | Restore baseline; no seeds executed |
| 3 | **Dependency engine** | DAG build, cycle detection, topo sort, prerequisite validation | Unit tests with synthetic graphs + dry-run | n/a (pure logic) |
| 4 | **Verification engine v1** | row counts, FK scans, orphan/duplicate/empty-chain, business-rule checks | Run against current baseline → must report the known gaps (S3/S4/S5 findings) | n/a (read-only) |
| 5 | **Rollback + checkpoints + resume + baseline mode** | rollback_ops, layer checkpoints, resume, `from-dump`/`from-scratch` | Failure-injection tests on a throwaway DB; resume-after-fix demo | Restore baseline |
| 6 | **Reference + core manifests** | Author manifests for L0–L5 (rewrite of seeds 01–10/20/21/51-accreditation-workflow) | Dry-run + quick-verify on baseline | Restore baseline; bucket not yet executed |
| 7 | **Scenario + blocked-chain manifests** | Rebuild 17/18/28/29/33 + 90/95/96 as scoped scenarios (L6–L15) | Full `from-scratch` to stage 7–8; S5 → 0 | Restore baseline |
| 8 | **Demo/pilot/test manifests** | Yemen demo, pilot split, fixtures for blocked features | `--include=demo` then demo-removal → core state intact | Scope-key removal |
| 9 | **Idempotency + deny-list + dead data** | enforcement (6.4), `templates.*` removal, runtime-row cleanup | Idempotent replay (A2); deny-list diff; dead-data audit (A6) | Restore baseline (only reversible path for dead-data) |
| 10 | **Certification tooling** | lockfile, full verification, baseline freeze flow | G2 + G3 on a clean machine | Prior dumps preserved |

**Roadmap dependencies:** 1 → 2 → 3 → 4 → 5 form the engine core and must land in order (each is independently testable against the *existing* baseline without touching seed content). 6–8 translate and rebuild seed content on the engine. 9 removes dead data only after 7 proves the blocked chains work. 10 certifies the result. Every phase leaves the Gate-0 baseline restorable.

---

*End of Seed Reconstruction Execution Architecture. Architecture only — no SQL, no code, no migrations, no commits.*
