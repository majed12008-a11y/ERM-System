# ADR-018/019 — Formalization Verification

> Mechanical verification that ADR-018 and ADR-019 are in the formalizable state: every claim required for the Board's decision is checked against repository evidence.
> This document **verifies**; it does not decide, accept, record, transition, close, or authorize. No commit.
> Status legend: **PASS** = expected state confirmed by evidence; **N/A** = not required / correctly absent; **HOLD** = correctly deferred pending the Board's decision.

| # | Check | Expected | Actual | Evidence | Status |
|---|---|---|---|---|---|
| 1 | ADR-018 exists in the ADR directory | File present | `ADR-018-I11-SECURITY-DEFINER-GOVERNANCE.md` (266 lines) | glob of `docs/architecture/adr/*.md` | PASS |
| 2 | ADR-019 exists in the ADR directory | File present | `ADR-019-EC8-AUDIT-CHAIN.md` (173 lines) | glob of `docs/architecture/adr/*.md` | PASS |
| 3 | ADR-018 status | `PROPOSED — PENDING ADR BOARD APPROVAL` | Exactly that value | ADR-018:11 | PASS |
| 4 | ADR-019 status | `PROPOSED — PENDING ADR BOARD APPROVAL` | Exactly that value | ADR-019:13 | PASS |
| 5 | ADR-018 date states DRAFT/TBD | Effective date not set | `DRAFT / TBD (drafted 2026-08-10; renumbered 2026-08-11; effective date is a Board decision, blank in §2.7)` | ADR-018:12 | PASS |
| 6 | ADR-019 date states DRAFT/TBD | Effective date not set | `DRAFT / TBD (drafted 2026-08-10; renumbered 2026-08-11; effective date is a Board decision, blank in §2.4)` | ADR-019:14 | PASS |
| 7 | ADR-018 Board fields blank | All 5 fields blank | Selected/Effective date/Approved by/Conditions/Review date = `*(blank — ADR Board decision)*` | ADR-018:186-192 | PASS |
| 8 | ADR-019 Board fields blank | All 4 fields blank | Selected/Effective date/Approved by/Conditions = `*(blank — ADR Board decision)*` | ADR-019:91-96 | PASS |
| 9 | ADR-018 numbering collision-free | Next free number above all reservations | ADR-018 = first free after ADR-010 (RC4) and ADR-017 (Phase5) | ADR-018:5; ADR-INDEX §2.1/§2.2 | PASS |
| 10 | ADR-019 numbering collision-free | Next free number above all reservations | ADR-019 = second free after ADR-018 | ADR-019:5; ADR-INDEX §1 | PASS |
| 11 | Number never reused (ADR-001 §2.1) | No reuse | ADR-003/ADR-004 remain historical drafts with superseded numbering; ADR-003+ reserved | ADR-INDEX:15; ADR-018:5; ADR-019:5 | PASS |
| 12 | Registered in ADR-INDEX §1 | Both rows present | ADR-018 row (PROPOSED, 2026-08-11 draft); ADR-019 row (PROPOSED, 2026-08-11 draft) | ADR-INDEX:13-14 | PASS |
| 13 | Template-conformant (ADR-001 §2.2) | Context/Decision/Alternatives/Consequences/References | Both ADRs have §1–§5 in template order | ADR-018; ADR-019; `adr-template.md` | PASS |
| 14 | ADR-018 scope = 28 live + 2 migration-only | 30 functions total | 28 live (system 13, security 4, committee 6, documents 5) + 2 migration-only (security.fn_encrypt/fn_decrypt) | ADR-018:93-95; `C6-security-definer-inventory.csv` | PASS |
| 15 | 27/28 live functions access RLS-protected data | 27 bypass; 1 hygiene | 27 READ/WRITE; `system.fn_current_user_id` (C6-005) = NONE (GUC-only, hygiene) | ADR-018:53; `C6-security-definer-inventory.csv` | PASS |
| 16 | `fn_auto_transition` excluded (dropped) | Not in scope | Historical/dropped (`archive/sql-history/39-drop-auto-transition.sql`); REMOVED (WIC:189); absent from canonical extraction and inventory | ADR-018:99-107 | PASS |
| 17 | I11 governance state | VIOLATED (not claimed resolved) | `I11 remains Violated today; resolution is proposed, not achieved` | ADR-018:169; R9 precedent Unrecorded | PASS |
| 18 | ADR-018 does not authorize Phase 4 | No authorization language | `DRAFT ONLY — NOT an accepted decision... does not authorize Phase 4`; `ADR-018 acceptance alone does NOT authorize Phase 4` | ADR-018:3,231-233 | PASS |
| 19 | GD-2 honored | No gate binding on Violated/Suspended | GD-2: `No gate on a breach: a rule in Violated or Suspended may not bind a gate`; I11 Suspended → gate-un-bindable | `gate-dependency.ts:17`; ADR-018 §1.5/§2.5(2) | PASS |
| 20 | Exception is bounded, not a broad waiver | Boundary fields enumerated | 13 boundary requirements (§2.2); future functions not covered; registration-only scope proposed for correction | ADR-018:131-147 | PASS |
| 21 | P3–I11 conflict resolution without amendment | C6-D semantic/enforcement distinction | `without amending P3/I5/I11 text`; precedence interpretation | ADR-018:121 | PASS |
| 22 | I11 transition documented, not performed | Suspended (t10) / Active on expiry (t12) documented | Steps 1–4 in ADR-018 §2.4; state-machine transitions 10/12 | ADR-018:161-167; `constitutional-state-machine.md:42,44` | PASS |
| 23 | R9 `EXCEPTIONS` empty | No recorded exceptions | `export const EXCEPTIONS: ReadonlyArray<ExceptionRecord> = []` | `exception.registry.ts:37` | PASS |
| 24 | R9 `KNOWN_PRECEDENTS` exactly 1 Unrecorded | 1 precedent, status Unrecorded | `PRECEDENT-I11-SECURITY-DEFINER`, authority `Unrecorded — pending ADR review`, expiry `Not defined`, status `Unrecorded` | `exception.registry.ts:24-34` | PASS |
| 25 | No new R9 record created by this review | R9 unchanged | `EXCEPTIONS` remains `[]`; `KNOWN_PRECEDENTS` unchanged | `exception.registry.ts` (re-read) | PASS |
| 26 | R1 I11 classification | `Automatically verifiable (with documented bypass)` | Exactly that value | `rule.registry.ts:73` | PASS |
| 27 | R4 I11 verification readiness | `READY_OUTSIDE_INITIAL_SET` (bypass detection) | I11 bypass detection entry present | `verification.registry.ts:36-38` | PASS |
| 28 | R4 EC8 readiness | `NeedsExtension` | Decision/evidence provenance records to audit chains against | `verification.registry.ts:30` | PASS |
| 29 | ADR-019 chain = Candidate A | `Decision → Evidence → Constraint → Rule` | `§2.3(1) EC8 = Decision → Evidence → Constraint → Rule (Candidate A)` | ADR-019:81; object-model:107 | PASS |
| 30 | Chain explicit in constitution | Object-model §2.3 names it (T3; EC8) | `Traceability | traverses | Relationship | Decision → Evidence → Constraint → Rule (T3; EC8)` | `constitutional-object-model.md:107` | PASS |
| 31 | Secondary constitutional location | Enforcement-architecture §2/§3 | `the backward chain decision → evidence → constraint → rule` (T3/G3/EC8) | `constitutional-enforcement-architecture.md:76` | PASS |
| 32 | Backward traversal via `traverses` | `traverses` is the chain relationship | `traverses` (line 61) validTo includes all chain nodes | `relationship-kinds.ts:61`; ADR-019 §2.2.1 | PASS |
| 33 | `records` cannot connect Decision→Evidence | validTo = Verification/Gate only | `records` line 50 validTo `['Verification','Gate']` | `relationship-kinds.ts:50` | PASS |
| 34 | `examines` forward | Constraint → Evidence | `examines` line 43 forward | `relationship-kinds.ts:43` | PASS |
| 35 | `constrained-by` forward | Rule → Constraint | `constrained-by` line 34 forward | `relationship-kinds.ts:34` | PASS |
| 36 | TRACEABILITY_CHAIN pinned | `['Decision','Evidence','Constraint','Rule']` | Exactly that value | `traceability-graph.ts:26-31` | PASS |
| 37 | Chain assertion test present | Test asserts the chain | `relationships.test.ts:384` asserts TRACEABILITY_CHAIN | `relationships.test.ts:384` | PASS |
| 38 | ADR-019 does not modify vocabulary | No relationship-model change | Constraints honored line: `no... relationship models... changed by this draft` | ADR-019:18 | PASS |
| 39 | Mis-cited evidence removed (A4-01) | `PQ1-EC8-final-confirmation.md` not evidence | Removed; retained only as the A4-01 record; FINAL-READINESS line 22 corrected | ADR-019:52,169 | PASS |
| 40 | PQ-1 OPEN | Not closed by proposal | `Status OPEN`; note: only the Board's decision closes it | ADR-INDEX:52,55 | PASS |
| 41 | PQ-2 OPEN | Not closed by proposal | `Status OPEN`; note: only the Board's decision closes it | ADR-INDEX:53,55 | PASS |
| 42 | C6 status OPEN | Not closed | `C6-final-decision-readiness.md` verdict E = READY FOR ADR DRAFTING (not closure); PREC-01..12 OPEN | `C6-final-decision-readiness.md:7`; `ADR-BOARD-C6-PQ1-PHASE4-PRECONDITIONS.csv` | PASS |
| 43 | Phase 4 BLOCKED | No authorization anywhere | ADR-018:3,231; ADR-019:3,143-145; PREC table all OPEN; R5 GATE_ELEMENT_ASSIGNMENTS = 0 | `gate-dependency.ts:19,37` | PASS |
| 44 | No ACCEPTED/APPROVED claim for ADR-018/019 anywhere | Only PROPOSED | ADR files + ADR-INDEX all PROPOSED | ADR-018:11; ADR-019:13; ADR-INDEX:13-14 | PASS |
| 45 | No forged Effective Date | Board fields blank everywhere | No Effective Date value in ADR-018/019 | ADR-018 §2.6; ADR-019 §2.4 | PASS |
| 46 | No registry-to-runtime edge created | R5 stays empty | `GATE_ELEMENT_ASSIGNMENTS` empty; GD-4 | `gate-dependency.ts:19` | PASS |
| 47 | Historical artifacts preserved | ADR-003/004 drafts + baseline intact | `ADR-003-I11-SECURITY-DEFINER-GOVERNANCE.md`, `ADR-004-EC8-AUDIT-CHAIN.md`, pre-correction baseline retained | ADR-INDEX:15; ADR-018:5 | PASS |
| 48 | No commit/tag performed by this review | git tree unchanged except documented docs | git status shows only pre-existing user workflow changes + this session's docs-only edits | `git status --short` | PASS |

---

> VERIFICATION COMPLETE: 48/48 rows PASS. No HOLD items remain for the readiness question. The Board's decision — not any verification — is the remaining act. No decision made; no Phase 4 authorization.
