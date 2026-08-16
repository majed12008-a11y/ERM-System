# ADR-003/004 — Current State Verification (Evidence-Based)

> **BASELINE SNAPSHOT (pre-correction).** This report records the repository state **before** the correction package was applied. The corrections it finds missing were subsequently applied and committed in `d60a7b6` (ADR-018/ADR-019 renumbering, ADR-003/ADR-004 historical markers, ADR-INDEX update, A4-01 mis-citation removal, A4-02 hop-edge framing, A3-03 reconciliation, A3-01 precision, A3-02 anchoring, template conformance). See `ADR-018-019-PRE-BOARD-CORRECTION-REPORT.md` for the applied state. The "NOT READY" verdict below refers to the **pre-correction** state only.

> Read-only repository verification. Determines the actual current state of the ADR-003/004 governance correction. No source, SQL, database, seed, registry, specification, relationship, or ADR was modified. No commit, no tag.

| Field | Value |
|---|---|
| Verification | Evidence-based repository inspection (no memory, no prior summary, no assumption) |
| Date | 2026-08-11 |
| Method | Direct file reads + grep + git state inspection |
| No-change rule | HONORED — single documentation report created only |

---

## §1 Verification scope

Verified, directly from the repository:

1. ADR numbering state — `ADR-INDEX.md`, `ADR-001-series-foundation.md`, all files under `docs/architecture/adr/`.
2. ADR-003 and ADR-004 current state — both draft files, the submission set (`ADR-003-004-BOARD-SUBMISSION.md`, `-PRE-BOARD-REVIEW.md`, `-BOARD-READINESS.md`, `-CONSISTENCY-MATRIX.csv`, `-EVIDENCE-MATRIX.csv`, `-RISK-REGISTER.csv`) and all C6/PQ-1 documents.
3. Live SECURITY DEFINER inventory — canonical extraction `database/canonical/functions/*.sql`, seed files, schema dumps, `archive/sql-history/39-drop-auto-transition.sql`, `docs/architecture/Workflow-Implementation-Contract.md`, and the C6 inventory/audit artifacts.
4. EC8 source of truth — `docs/constitutional-object-model.md` §2.3, `backend/src/governance/relationships/relationship-kinds.ts`, `traceability-graph.ts`, `relationships.test.ts`, Phase-3 relationship reports, ADR-004, PQ-1 documents.
5. Board decision status — ADR-INDEX §3, registry state (R1/R9), review-decision artifacts.
6. Git state — `git status`, `git log`, `git diff`, `git diff --cached`.

---

## §2 ADR numbering state

Direct evidence from `ADR-INDEX.md` and the file listing of `docs/architecture/adr/`:

| # | Question | Answer | Evidence |
|---|---|---|---|
| 1 | Which ADR numbers are currently occupied? | **ADR-001** (series foundation) and **ADR-002** (constitution) — the only registered formal ADRs | `ADR-INDEX.md` §1 (lines 11–12); formal-series rows |
| 2 | Which numbers are reserved? | **ADR-003 … ADR-017** | `ADR-INDEX.md` §1 line 13 (`ADR-003+` reserved); §2.1 (RC4 ADR-01..08 → ADR-003..ADR-010); §2.2 (Phase5 ADR-001..007 → ADR-011..ADR-017) |
| 3 | Is ADR-003 already reserved for historical RC4 material? | **YES** — RC4 ADR-01 → `TBD-P3 (ADR-003)` | `ADR-INDEX.md` §2.1 line 23 |
| 4 | Is ADR-004 already reserved? | **YES** — RC4 ADR-02 → `TBD-P3 (ADR-004)` | `ADR-INDEX.md` §2.1 line 24 |
| 5 | What is the next valid free ADR number? | **ADR-018** (reservations end at ADR-017) | Derived from §2.1/§2.2; matches pre-board review R1 (review line 105) |
| 6 | Do ADR-018 and ADR-019 actually exist? | **NO** — no files, no rows | `glob docs/architecture/adr/*` contains no `ADR-018-*` or `ADR-019-*`; `ADR-INDEX.md` has no ADR-018/019 row; grep finds ADR-018/019 only as a **recommended future assignment** in review/readiness docs, not as existing ADRs |
| 7 | Are ADR-018/019 PROPOSED, ACCEPTED, EFFECTIVE, or absent? | **ABSENT** | No file, no header, no index row, no registration |

**Key fact:** the informal reconciliation map reserves ADR-003 and ADR-004 for RC4 material. The proposed I11/EC8 drafts use exactly those reserved numbers. This is the J-01 collision — still present (see §10).

---

## §3 ADR-003 state

File: `docs/architecture/adr/ADR-003-I11-SECURITY-DEFINER-GOVERNANCE.md`

| Aspect | Observed state | Evidence |
|---|---|---|
| Status | **PROPOSED — PENDING ADR BOARD APPROVAL** (draft only) | Header line 9; §1 line 27; footer line 281 |
| Number used | **ADR-003** (collides with §2.1 reservation) | Header line 7 |
| Not accepted / not effective | Confirmed — "DRAFT ONLY — NOT an accepted decision" | Lines 3, 128, 281 |
| Does not authorize Phase 4 | Confirmed | §11 line 223–225 |
| §13 decision fields | **Blank** (Board's to fill) | Lines 246–252 |
| I11 state representation | I11 remains **Violated** today; exception/conflict resolution only proposed | §8 lines 180–186; header note |
| Exception boundary | Bounded class (13 fields); proposed scope = 28 live functions; migration-only C6-029/C6-030 excluded; future functions not covered | §6 lines 142–160 |
| P3–I11 conflict | Proposed resolution by C6-D (semantic home vs enforcement expression) — **proposed, not recorded** | §5 line 132; §7 |

The ADR-003 draft body itself (as committed in RC8) does **not** contain the corrections that the pre-board review later recommended (A3-01 precision note, A3-02 anchoring, A3-03 fn_auto_transition reconciliation). See §10.

---

## §4 ADR-004 state

File: `docs/architecture/adr/ADR-004-EC8-AUDIT-CHAIN.md`

| Aspect | Observed state | Evidence |
|---|---|---|
| Status | **PROPOSED — PENDING ADR BOARD APPROVAL** (draft only) | Header line 9; footer line 171 |
| Number used | **ADR-004** (collides with §2.1 reservation) | Header line 7 |
| Not accepted / not effective | Confirmed — "DRAFT ONLY — NOT an accepted decision" | Lines 3, 76 |
| Does not authorize Phase 4 | Confirmed | §8 lines 132–134 |
| §9 decision fields | **Blank** (Board's to fill) | Lines 143–147 |
| Proposed decision | Candidate A — `Decision → Evidence → Constraint → Rule`; Candidate B recorded as projection | §4 lines 80–83 |
| Constitutional source cited | `docs/constitutional-object-model.md` §2.3 line 107 (verified verbatim) | §2 item 1; §3.3 |
| Mis-citation A4-01 | **STILL PRESENT** — §2 item 3 and §3.3 still cite `PQ1-EC8-final-confirmation.md` as supporting the traceability-chain Candidate A | Lines 40, 68 (see §10) |
| Hop-edge claim A4-02 | **STILL PRESENT** — §3.1/§5/§6 still claim the chain edges are `records`/`examines`/`constrained-by` | Lines 56, 97, 113 (see §10) |

---

## §5 C6/I11 state

Direct registry and audit evidence:

| Item | State | Evidence |
|---|---|---|
| R9 `KNOWN_PRECEDENTS` | One entry `PRECEDENT-I11-SECURITY-DEFINER`, status **`Unrecorded`**, authority "Unrecorded — pending ADR review", scope "registration only", expiry "Not defined" | `backend/src/governance/registries/exception.registry.ts` lines 24–34 |
| R9 `EXCEPTIONS` | **Empty (`[]`)** — no recorded exception | `exception.registry.ts` line 37 |
| I11 registry state | **Violated** (classification "Automatically verifiable (with documented bypass)") | `rule.registry.ts` lines 67–74 |
| R4 | I11 in `READY_OUTSIDE_INITIAL_SET` with bypass-detection basis — not registered as verification | `verification.registry.ts` lines 36–37 |
| C6 decision status | **OPEN** — ADR-board decision required; no dated commitment exists | `c6-pq1-review-decision.md` §1, §2; `ADR-BOARD-C6-PQ1-DECISION-PACKAGE.md` §2.3 |
| I11 gate binding | Forbidden while Violated/Suspended (GD-2) | `gate-dependency.ts`; state-machine rule 2 |

---

## §6 PQ-1/EC8 state

### EC8 CHAIN
`Decision → Evidence → Constraint → Rule`

### RELATIONSHIP/TRAVERSAL SEMANTICS
The chain is a **backward traversal** (`traverses`), not a single registered edge chain. Verified in `relationship-kinds.ts`:
- `traverses` (line 61): validFrom `Traceability`, validTo includes `Rule, Constraint, Evidence, Verification, Gate, Decision` — this is the EC8 chain vehicle.
- `records` (line 50): validFrom `Decision`, validTo **`['Verification','Gate']` only** — it **cannot** connect Decision → Evidence.
- `examines` (line 43): forward, Constraint → Evidence.
- `constrained-by` (line 34): forward, Rule → Constraint.
- No direct `Decision → Evidence` registered edge exists; that hop is established through the recorded provenance projection (`records`/`produces` via Verification/Gate) or via the `traverses` traversal.

### SOURCE OF TRUTH
`docs/constitutional-object-model.md` **§2.3, line 107**:
> Traceability | traverses | Relationship | **Decision → Evidence → Constraint → Rule (T3; EC8).**

Verified verbatim. Secondary source: `docs/constitutional-enforcement-architecture.md` §2/§3 ("the backward chain decision → evidence → constraint → rule").

### EXACT SECTION
`constitutional-object-model.md` §2.3 (line 107).

### CONFLICTING DOCUMENTS
1. **`PQ1-EC8-final-confirmation.md`** — resolves a **different** EC-8 question (Document aggregate subscriber endpoint, its own Candidate A/B), and cites a **non-existent** source (`domain-model/object-model.md`; no `domain-model/` directory exists). It does **not** speak to the traceability chain. It is still cited for that purpose in ADR-004 (A4-01) and in `ADR-BOARD-C6-PQ1-FINAL-READINESS.md` line 22.
2. **`ADR-BOARD-C6-PQ1-DECISION-PACKAGE.md` §8.3** and **`ADR-004` §3.1/§5/§6** — claim the chain edges are `records`/`examines`/`constrained-by` (all "in range"), which is vocabulary-imprecise per `relationship-kinds.ts` (A4-02). `records` cannot connect Decision → Evidence.
3. **`constitutional-object-model.md` §4** — the full enforcement chain `Rule → Constraint → Evidence → Verification → Gate → Decision`, from which Candidate B (`Decision → Gate → Verification → Evidence → Constraint → Rule`) can be inferred. Not labeled as the audit chain anywhere; the Phase-3 reports record Candidate A and surface the ambiguity as PQ-1 (LOW-2).
4. **`TRACEABILITY_CHAIN`** in `traceability-graph.ts` lines 26–31 = `['Decision','Evidence','Constraint','Rule']` (Candidate A), asserted at `relationships.test.ts:384`.

---

## §7 fn_auto_transition reconciliation

Mechanical evidence:

| Source | Finding |
|---|---|
| `backend/schema_only_dump.sql` lines 210–213 | `CREATE FUNCTION system.fn_auto_transition(...)` — **`LANGUAGE plpgsql SECURITY DEFINER`** |
| `ethics_db_schema.sql` (line 328), `ethics_db_tables_constraints.sql` (line 258), `scripts/db-schema-tables.sql` (line 316), `scripts/db-schema-full.sql` (line 316), `ethics_db_backup.sql` (line 409) | `fn_auto_transition` appears in the historical schema dumps (SECURITY DEFINER) |
| `archive/sql-history/39-drop-auto-transition.sql` | `DROP FUNCTION IF EXISTS system.fn_auto_transition(...)` — **"broken by design"**; dropped, all callers removed |
| `docs/architecture/Workflow-Implementation-Contract.md` line 189 | `fn_auto_transition()` — **REMOVED** |
| `database/canonical/functions/*.sql` (6 files) | **NOT PRESENT** — no `fn_auto_transition` in the canonical live extraction (grep confirmed) |
| `C6-security-definer-inventory.csv` (rows C6-001..C6-030) | **EXCLUDED** — the authoritative final audit inventory does not list it |

### Classification
- **fn_auto_transition = HISTORICAL / DROPPED (not part of the live surface).**
  - It *is* `SECURITY DEFINER` in the historical schema dumps (which is why the prior decision package at line 171 and the evidence register C6EV-10 over-counted it).
  - It was **dropped** (39-drop-auto-transition.sql; WIC line 189 REMOVED) and is **absent** from the canonical live extraction.
  - The final audit inventory (the authoritative input ADR-003 cites) correctly **excludes** it.

### Inventory reconciliation (the question's explicit numbers)

| Metric | Count | Evidence |
|---|---|---|
| **TOTAL FUNCTIONS** | **30** executable SECURITY DEFINER functions | `C6-security-definer-inventory.csv` rows C6-001..C6-030; final audit §1.2 |
| **LIVE** | **28** (13 system + 4 security + 6 committee + 5 documents) | inventory classification A; canonical extraction counts: system 13, security 4, committee 6, documents 1 canonical + 4 from seeds 47/57/58/59 = 5 |
| **MIGRATION-ONLY** | **2** (`security.fn_encrypt`, `security.fn_decrypt` — C6-029/C6-030) | inventory classification E; `backend/migrations/002_encryption.js` |
| **HISTORICAL/OTHER** | **fn_auto_transition** (dropped; schema-dump-only), plus the 17 backup dumps / historical schema dumps as class C evidence | `archive/sql-history/39-drop-auto-transition.sql`; WIC line 189; final audit §1.1 class C |

Live-surface verification performed in this session: `database/canonical/functions/system.sql` = 13 SECURITY DEFINER; `security.sql` = 4; `committee.sql` = 6; `documents.sql` = 1 (fn_get_certificate_verification) with the other 4 documents functions present as SECURITY DEFINER in seeds 47 (fn_get_certificate_verification), 57 (fn_verify_generated_document), 58 (fn_document_transition), 59 (fn_can_view_document, fn_is_document_signer). **Total = 28 live.** No `fn_auto_transition` in canonical or seeds.

---

## §8 Board decision status

| Item | Status | Evidence |
|---|---|---|
| **PQ-1** (EC8 audit-chain selection) | **OPEN** | `ADR-INDEX.md` §3 line 50 |
| **PQ-2** (I11 exception + P3–I11 conflict) | **OPEN** | `ADR-INDEX.md` §3 line 51 |
| **C6** | **OPEN — ADR-board decision required** | `c6-pq1-review-decision.md`; DECISION-P3-001 |
| **ADR-003** | **PROPOSED (draft)** — not accepted, not effective, not registered | ADR-003 header; ADR-INDEX §1 has no ADR-003 row |
| **ADR-004** | **PROPOSED (draft)** — not accepted, not effective, not registered | ADR-004 header; ADR-INDEX §1 has no ADR-004 row |
| **ADR-018 / ADR-019** | **DO NOT EXIST** — only recommended as a future numbering option | §2 of this report |
| **R9 exception record** | **Not created** — `EXCEPTIONS` empty | `exception.registry.ts` line 37 |
| **I11 state** | **Violated** (unchanged) | `rule.registry.ts`; R9 `Unrecorded` |
| **Board decision** | **NONE EXISTS.** No accepted/effective ADR; no ADR-INDEX registration; no dated commitment; no decision-log entry accepting these ADRs | ADR-INDEX §1/§3; `c6-pq1-review-decision.md` |

**Important distinction (confirmed):** a draft recommendation is not a Board decision; a proposed ADR is not an effective ADR; an analysis is not an ADR commitment. The repository contains only: analysis artifacts (C6 audit, decision package, governance analysis), a recommendation, a review, a readiness assessment, and the two PROPOSED drafts. **There is no Board decision.**

---

## §9 Git state

| Item | Value | Evidence |
|---|---|---|
| Branch | `master` — up to date with `origin/master` | `git status` |
| Latest commit | **`c23dc6a` — "RC8"** — 2026-08-10 22:50:05 +0300 | `git log -1` |
| Working tree | **CLEAN** — nothing to commit | `git status` |
| `git diff` | **Empty** | `git diff --stat` (no output) |
| `git diff --cached` | **Empty** | `git diff --cached --stat` (no output) |
| Untracked ADR files | **None** | `git status` clean |
| Modified tracked files | **None** | `git status` clean |
| Uncommitted implementation | **None** | `git status` clean; `git diff` empty |

**Critical timeline fact:** the pre-board review (`ADR-003-004-PRE-BOARD-REVIEW.md`) and the two ADR drafts were committed **in the same single commit** (`c23dc6a RC8`). There is **no subsequent commit** in which the review's required/recommended corrections were applied. The drafts in the working tree are byte-identical to what the review said is **NOT READY TO ACCEPT AS WRITTEN**.

---

## §10 Findings against J-01 / A4-01 / A4-02 / A3-03 / A3-01 / A3-02

| ID | Severity (review) | Required? | Corrected in repository? | Evidence |
|---|---|---|---|---|
| **J-01** | HIGH | YES (before registration) | **NOT CORRECTED** | ADR-003 and ADR-004 still use numbers 003/004; ADR-INDEX §2.1 still reserves those for RC4 ADR-01/02; no ADR-018/019 created; `ADR-003-004-BOARD-SUBMISSION.md` §4 still records the collision as unresolved; EVIDENCE-MATRIX C-029 = "BLOCKS REGISTRATION" |
| **A4-01** | HIGH | YES (before acceptance) | **NOT CORRECTED** | ADR-004 §2 item 3 (line 40) and §3.3 (line 68) still cite `PQ1-EC8-final-confirmation.md` as confirming the traceability-chain Candidate A. That document resolves a different EC-8 question (subscriber endpoint) and cites non-existent `domain-model/object-model.md`. Same conflation still in `ADR-BOARD-C6-PQ1-FINAL-READINESS.md` line 22; EVIDENCE-MATRIX C-021 = "NEEDS CORRECTION" |
| **A4-02** | MEDIUM | RECOMMENDED | **NOT CORRECTED** | ADR-004 §3.1 (line 56), §5 (line 97), §6 (line 113) still claim edges `records`/`examines`/`constrained-by` "all in range". Verified against `relationship-kinds.ts`: `records` validTo = Verification/Gate only (cannot connect Decision→Evidence); `examines`/`constrained-by` are forward forms; no direct Decision→Evidence edge; correct framing is backward traversal via `traverses`; EVIDENCE-MATRIX C-022 = "NEEDS CORRECTION" |
| **A3-03** | MEDIUM | RECOMMENDED (at R9 record time) | **NOT ADDRESSED in ADR-003** | ADR-003 does **not** mention `fn_auto_transition` or the live-baseline reconciliation anywhere. The reconciliation was verified as feasible (§7: final audit correctly excludes it; canonical extraction confirms absence), but the ADR draft carries no note; EVIDENCE-MATRIX C-015 = "NEEDS RECONCILIATION" |
| **A3-01** | LOW | RECOMMENDED | **NOT CORRECTED** | ADR-003 §2.3(1) (line 63) still says all 28 "bypass RLS on protected data"; the audit's own §2 Q1 and inventory row C6-005 record `fn_current_user_id` as hygiene-only, NOT an RLS bypass. Precision note (27 of 28) absent; EVIDENCE-MATRIX C-009 = "NEEDS CORRECTION" |
| **A3-02** | LOW | RECOMMENDED | **NOT CORRECTED** | ADR-003 §12 item 5 (line 237) still defers the precedence/conflict-resolution recording to "per the later enforcement work" instead of anchoring to the §5(1) precedence statement recorded on acceptance; EVIDENCE-MATRIX C-016 = "NEEDS CORRECTION" |

Additionally (inherited, not yet corrected):
- **A3-04 / A4-03 (LOW, at registration):** both drafts use custom section numbering instead of the binding template structure (ADR-001 §2.2) — unchanged.
- **RVW-09 (evidence-chain divergence):** prior-package C6EV-10 still enumerates `fn_auto_transition`; FINAL-READINESS line 22 still carries the A4-01 conflation — both still present.

---

## §11 Exact remaining blockers

| # | Blocker | Required action | Severity |
|---|---|---|---|
| 1 | **J-01 numbering collision** | Board resolves the numbering **before** registration: assign ADR-018 (I11) and ADR-019 (EC8), or an explicit re-sequencing; update file names, headers, ADR-INDEX references, submission | HIGH (blocks registration) |
| 2 | **A4-01 mis-citation** | Remove/correct the `PQ1-EC8-final-confirmation.md` citation in ADR-004 §2(3)/§3.3; correct `ADR-BOARD-C6-PQ1-FINAL-READINESS.md` line 22 | HIGH (required before acceptance) |
| 3 | **A4-02 edge framing** | Reword ADR-004 §3.1/§5/§6 to the backward-traversal + hop-edge contract (Evidence→Constraint via `is-examined-by`; Constraint→Rule via `constrains`; Decision→Evidence via recorded provenance projection) | MEDIUM (recommended) |
| 4 | **A3-03 reconciliation note** | Record the `fn_auto_transition` reconciliation (dropped; excluded from the 28-function inventory) in ADR-003 or the future R9 record, and confirm the live baseline matches the 28 enumerated functions before creating the exception record | MEDIUM (recommended, PREC-04) |
| 5 | **A3-01 bypass-count precision** | Add the precision note: 27 of 28 in-scope functions access RLS-protected data; `fn_current_user_id` (C6-005) hygiene-only, included conservatively | LOW (recommended) |
| 6 | **A3-02 precedence anchoring** | Anchor ADR-003 §12(5) to the precedence statement in §5(1) (recorded on acceptance) | LOW (recommended) |
| 7 | **Template conformance (A3-04/A4-03)** | Map custom sections to the binding template at registration | LOW (at registration) |
| 8 | **Board decision itself** | Board fills §13 (ADR-003) and §9 (ADR-004) fields and accepts/registers — **not yet done** | Board action |
| 9 | **R9 exception record + I11 transition** | Created only **after** acceptance: EXCEPTIONS entry (authority = ADR, scope = Board-fixed surface, expiry = Board-set, status = Recorded); I11 → Suspended (transition 10); bypass-detection verification registered without gating on a Suspended rule (GD-2) | After acceptance |
| 10 | **ADR-INDEX registration + PQ-1/PQ-2 closure** | ADR rows added to §1; PQ-1/PQ-2 closed — **not yet done** | After acceptance |
| 11 | **Phase 4** | Remains **BLOCKED**; requires separate Board authorization after all the above plus the later architectural review confirming C1–C6 closure | Gated |

---

## §12 Final verdict

**NOT READY FOR BOARD REVIEW**

The pre-board review's verdict was **CONDITIONAL — READY TO SUBMIT AFTER REQUIRED CORRECTIONS. NOT READY TO ACCEPT AS WRITTEN.** This verification confirms **none** of the review's six findings (J-01, A4-01, A4-02, A3-03, A3-01, A3-02) have been implemented in the repository. The two required-before-acceptance items — **J-01 (numbering collision)** and **A4-01 (mis-citation)** — remain open, and the two ADR drafts still carry the exact defects the review flagged.

Both ADRs remain **PROPOSED drafts**. They are not accepted, not effective, not registered, and are **not part of the formal ADR series** (ADR-001 §2.2/§2.3). No ADR-018/019 exists. No Board decision exists. R9 `EXCEPTIONS` is empty; I11 remains **Violated**; C6 and PQ-1 remain **OPEN**; Phase 4 remains **BLOCKED**.

The corrections must be applied to the drafts (and the numbering resolved) before these instruments can go to the Board for acceptance/registration.
