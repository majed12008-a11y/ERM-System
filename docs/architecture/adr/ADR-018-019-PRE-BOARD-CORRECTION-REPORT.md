# ADR-018 + ADR-019 — Pre-Board Correction Report

| Field | Value |
|---|---|
| Report | Pre-board correction execution report for ADR-018 (I11 SECURITY DEFINER Governance) and ADR-019 (EC8 Audit Chain) |
| Date | 2026-08-11 |
| Corrector | Governance correction execution (read-only against source; documentation/governance changes only) |
| Inputs | `ADR-003-004-PRE-BOARD-REVIEW.md` (findings J-01, A4-01, A4-02, A3-01, A3-02, A3-03, A3-04/A4-03), `ADR-003-004-CURRENT-STATE-VERIFICATION.md` (pre-correction baseline), historical drafts ADR-003/ADR-004, ADR-INDEX, C6/PQ-1 audit package |
| Constraint honored | Correction only. No source/SQL/DB/seed/registry/spec/relationship/API change; no Board decision; no Phase-4 authorization; no commit or tag. |
| Verdict | **READY FOR BOARD REVIEW (documentation package complete).** Board decision remains the Board's; nothing here decides, activates, or authorizes. |

---

## Traceability matrix — findings → correction → document → verification

| Finding | Severity | Correction applied | Document/location | Verification (performed) | Result |
|---|---|---|---|---|---|
| J-01 | HIGH | Renumbered ADR-003 → ADR-018, ADR-004 → ADR-019 (resolution R1); historical drafts marked superseded-numbering; ADR-INDEX §1 registers PROPOSED ADRs; PQ rows reference proposed ADRs | ADR-018, ADR-019, ADR-003 (header), ADR-004 (header), ADR-INDEX §1/§3, BOARD-SUBMISSION §5 | Grep for ADR-018/ADR-019 references; ADR-INDEX table; header notes; no number collision with §2.1/§2.2 reservations (017 is max reserved) | **PASS** |
| A4-01 | HIGH | `PQ1-EC8-final-confirmation.md` removed from traceability-chain evidence (different EC-8 question, non-existent `domain-model/object-model.md` citation); corrected the same conflation in FINAL-READINESS line 22 | ADR-019 §2.1 (removed-evidence note), §5; `ADR-BOARD-C6-PQ1-FINAL-READINESS.md` line 22 | Read both files; confirmed no traceability-chain claim cites PQ1-EC8-final-confirmation.md | **PASS** |
| A4-02 | MEDIUM | Hop-edge claim corrected: chain is a backward `traverses` traversal; `records` validTo=['Verification','Gate'], `examines`/`constrained-by` forward, backward readings = `is-examined-by`/`constrains`; Decision→Evidence hop via provenance projection; hop-edge contract in decision clause 4 | ADR-019 §2.2.1, §2.3(4), §4.1, §4.3 | Cross-checked `relationship-kinds.ts` lines 50/43/34/61 verbatim | **PASS** |
| A3-03 | MEDIUM | `fn_auto_transition` reconciliation recorded (dropped via `39-drop-auto-transition.sql`; WIC:189 REMOVED; absent from canonical functions; excluded from exception scope; live-baseline confirmation required before R9 record) | ADR-018 §1.7.2, §2.2, §2.5(4), §5 | Verified dumps (`schema_only_dump.sql:213`, 5 dumps), drop script, WIC:189, canonical extraction | **PASS** |
| A3-01 | LOW | Bypass count corrected: 27 of 28 live functions access RLS-protected data; `fn_current_user_id` (C6-005) is hygiene-only, included conservatively | ADR-018 §1.4 | Independently counted inventory CSV: 28 A.Executable rows, 27 READ/WRITE, 1 NONE (C6-005) | **PASS** |
| A3-02 | LOW | Precedence/conflict-resolution record anchored to ADR-018 §2.1(1) upon acceptance, enforced later at spec/relationship level — not deferred | ADR-018 §2.5(5) | Read §2.1(1) and §2.5(5) | **PASS** |
| A3-04 / A4-03 | LOW | Template conformance: both ADRs restructured to binding template (§1 Context, §2 Decision, §3 Alternatives, §4 Consequences, §5 References) with all required metadata fields | ADR-018, ADR-019 (full structure) | Compared against `docs/templates/adr-template.md` (all 8 table fields + 5 sections present; no placeholders in effective fields; PROPOSED keeps blank Board fields as permitted) | **PASS** |

---

## §1. Purpose

This report records the execution and verification of the required corrections (J-01, A4-01, A4-02, A3-01, A3-02, A3-03, A3-04/A4-03) that the pre-board review required before the C6/PQ-1 decisions can be presented to the ADR Board under non-colliding numbers. It is a documentation/governance deliverable only.

## §2. Scope

- **In scope:** documentation/governance corrections — renumbering, mis-citation removal, evidence-chain hygiene, hop-edge framing, bypass-count precision, precedence anchoring, template conformance; creation of ADR-018/ADR-019 drafts, board submission package, consistency matrix, this report; minimum ADR-INDEX reference updates.
- **Out of scope (deliberately NOT done):** ADR Board decision; Phase-4 authorization; R9 exception record creation; state transitions; bypass-detection verification registration; any source/SQL/DB/seed/registry/spec/relationship/API change; commits or tags.

## §3. Baseline (what existed before this correction)

- ADR-003/ADR-004 existed only as PROPOSED drafts (commit `c23dc6a RC8`, 2026-08-10); no ADR-018/019 existed.
- Pre-board review verdict: **CONDITIONAL — READY TO SUBMIT AFTER REQUIRED CORRECTIONS. NOT READY TO ACCEPT AS WRITTEN.** (J-01 blocks registration; A4-01 required before acceptance.)
- Independent verification report (`ADR-003-004-CURRENT-STATE-VERIFICATION.md`) confirmed none of the findings had been corrected.
- C6 OPEN, PQ-1/PQ-2 OPEN, I11 VIOLATED, R9 EXCEPTIONS = [], Phase 4 BLOCKED.

## §4. Numbering correction (J-01)

- Reserved range: ADR-003..ADR-010 (RC4) + ADR-011..ADR-017 (Phase5); ADR-001 §2.1 "A number is never reused"; Governance Freeze EC10.
- Applied resolution R1: ADR-018 (I11) and ADR-019 (EC8) are the next free numbers above all reservations.
- Historical drafts ADR-003/ADR-004 are marked **HISTORICAL DRAFT — SUPERSEDED NUMBERING** and are explicitly not part of the formal series.
- ADR-INDEX §1 now registers ADR-018/ADR-019 as **PROPOSED**; the ADR-003+ reservation row notes the historical drafts.

## §5. ADR-004 mis-citation (A4-01)

- Removed `PQ1-EC8-final-confirmation.md` from the traceability-chain evidence in ADR-019; it resolves a different EC-8 question (Document-aggregate subscriber endpoint) and cites non-existent `domain-model/object-model.md`.
- Corrected `ADR-BOARD-C6-PQ1-FINAL-READINESS.md` line 22 to attribute the chain to `constitutional-object-model.md` §2.3 line 107 and `constitutional-enforcement-architecture.md` §2/§3 line 76.
- ADR-019 §5 lists the document only as the A4-01 removed-evidence record — never as evidence for the chain.

## §6. Hop-edge framing (A4-02)

- Verified vocabulary (`relationship-kinds.ts`): `records` validTo=['Verification','Gate'] (line 50); `examines` forward Constraint→Evidence (line 43); `constrained-by` forward Rule→Constraint (line 34); backward readings are the inverse pairs `is-examined-by`/`constrains`; `traverses` (line 61) validTo includes all chain nodes.
- ADR-019 now frames the chain as a **backward traversal** with an explicit hop-edge contract for the engine's EC8 audit scaffold; no out-of-range direct Decision→Evidence edge is claimed.

## §7. Live-surface reconciliation (A3-03)

- `system.fn_auto_transition`: SECURITY DEFINER in dumps (`schema_only_dump.sql:213`), dropped by `archive/sql-history/39-drop-auto-transition.sql`, WIC:189 REMOVED, absent from `database/canonical/functions/*.sql`, excluded from the C6 inventory.
- ADR-018 §1.7.2 records the reconciliation and requires a live-baseline confirmation (exactly the 28 enumerated functions, not `fn_auto_transition`) before the R9 record (PREC-04).

## §8. Bypass-count precision (A3-01)

- Independent count of `C6-security-definer-inventory.csv`: **28 A.Executable** rows; **27** carry READ/WRITE RLS-protected access; **1** (`C6-005 system.fn_current_user_id`) carries `NONE (reads app.user_id GUC only)`.
- ADR-018 §1.4 states: 27 of 28 access RLS-protected data; C6-005 is hygiene-only and included conservatively.

## §9. Precedence anchoring (A3-02)

- ADR-018 §2.5(5) now states the semantic-vs-enforcement interpretation is **recorded by §2.1(1) of this ADR upon acceptance** and enforced later at specification/relationship level — the precedence record is not deferred.

## §10. Template conformance (A3-04/A4-03)

- Both ADRs follow `docs/templates/adr-template.md`: metadata table (Number, Status, Date, Author, Provenance, Constraints honored, Purpose, Supersedes + project-specific rows) and the five binding sections (§1 Context, §2 Decision, §3 Alternatives, §4 Consequences, §5 References).
- Effective fields contain no placeholders; the only blank fields are the Board Decision Template fields, which are intentionally blank in a PROPOSED ADR.

## §11. Deliverables produced

| File | Purpose |
|---|---|
| `ADR-018-I11-SECURITY-DEFINER-GOVERNANCE.md` | Corrected, renumbered ADR-003 draft (PROPOSED) |
| `ADR-019-EC8-AUDIT-CHAIN.md` | Corrected, renumbered ADR-004 draft (PROPOSED) |
| `ADR-003-I11-SECURITY-DEFINER-GOVERNANCE.md` | Historical draft — superseded-numbering header |
| `ADR-004-EC8-AUDIT-CHAIN.md` | Historical draft — superseded-numbering header |
| `ADR-BOARD-C6-PQ1-FINAL-READINESS.md` | Line 22 conflation corrected |
| `ADR-INDEX.md` | §1 registers ADR-018/019 PROPOSED; §3 PQ rows reference proposed ADRs; §1 reservation note |
| `ADR-018-019-BOARD-SUBMISSION.md` | Board submission cover |
| `ADR-018-019-CONSISTENCY-MATRIX.csv` | Consistency matrix (7 rows, all PROPOSED) |
| `ADR-018-019-PRE-BOARD-CORRECTION-REPORT.md` | This report |

## §12. Final verification and verdict

**Verification performed:**
1. Numbering uniqueness: ADR-018/019 are above all reservations (max reserved = 017); ADR-INDEX §1 consistent; no reuse.
2. ADR-018/ADR-019 content checks: all corrected claims match verified evidence (27/28; fn_auto_transition reconciliation; hop-edge ranges; mis-citation removed).
3. Template conformance: both ADRs match the binding template structure.
4. Terminology: final-vocabulary terms only; no forbidden terms introduced (verified against `docs/reference/glossary.md` §3/§4 — "Gate-0" used historically, permitted; "seed (historical)" usage avoided in new ADR text).
5. No-change boundary: `git status` shows documentation files only; no source/SQL/DB/seed/registry/spec/relationship/API changes; no commit, no tag.

**Verdict: READY FOR BOARD REVIEW.** The correction package satisfies the pre-board review's required corrections (J-01, A4-01) and its recommended corrections (A4-02, A3-03, A3-01, A3-02, A3-04/A4-03). Nothing in this package decides the Board's questions, activates either ADR, or authorizes Phase 4. I11 remains Violated; EXCEPTIONS empty; PQ-1/PQ-2 OPEN; Phase 4 BLOCKED — until the Board decides.
