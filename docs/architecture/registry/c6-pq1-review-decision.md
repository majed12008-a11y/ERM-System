# C6 / PQ-1 Review Decision — Governance Blockers for Phase 4

| Field | Value |
|---|---|
| Decision | **DECISION-C6-PQ1-001 — CONFIRMED OPEN, ADR-BOARD REQUIRED** (governance review decision) |
| This report | Confirms the analysis of `c6-pq1-governance-analysis.md`: C6 (I11 exception + P3–I11 conflict) and PQ-1 (EC8 audit-chain selection) are the two remaining Phase-3 blockers and both require **formal ADR-board decisions (ADR-003+)** before any Phase-4 work. Review artifact only — not an ADR; does not amend the constitution; does not authorize Phase 4. |
| Date | 2026-08-10 |
| Authority | ADR-001; ADR-002; ADR-INDEX; `constitutional-object-model.md`; `constitutional-enforcement-architecture.md`; `constitutional-state-machine.md`; `architecture-enforcement-model.md`; `architecture-constitution-stress-test.md`; `architecture-governance-freeze.md`; `phase3-review-decision.md` (DECISION-P3-001); `phase3-independent-review-decision.md` (DECISION-P3-002) |
| Basis | `c6-pq1-governance-analysis.md`; `c6-pq1-decision-matrix.csv`; `c6-pq1-risk-register.csv`; the cited registries (R9) and Phase-3 review artifacts; no source/SQL/DB/seed/registry/spec/relationship/API change, no commits |
| Later review | Per `phase3-review-decision.md` §4, the later architectural review must confirm closure of C1–C6 before Phase 4. This decision records the current C6/PQ-1 status for that review. |

---

## 1. Decision

**CONFIRMED OPEN — no Phase-4 work may begin until both blockers close.**

This governance review confirms, with no unresolved contradiction:

- **C6 — OPEN (confirmed).** The SECURITY DEFINER bypass is a documented I11 violation in the accepted baseline, registered only as an *unrecorded* precedent in R9 (`PRECEDENT-I11-SECURITY-DEFINER`, `status: 'Unrecorded'`, authority `'Unrecorded — pending ADR review'`); `EXCEPTIONS` is empty. The P3–I11 conflict (RULE 12's two mandated homes) is unresolved in the current constitution. No ADR-003+, no dated commitment.
- **PQ-1 — OPEN (confirmed).** The EC8 audit chain is a genuine constitutional-source conflict: object-model §2.3 / enforcement-architecture §2–§3 state Candidate A (`Decision → Evidence → Constraint → Rule`); object-model §4 implies Candidate B (`Decision → Gate → Verification → Evidence → Constraint → Rule`). Phase 3 could not and must not decide unilaterally.
- **I11 cannot bind a gate in either state.** Violated today; even with a recorded exception it becomes **Suspended**, and GD-2 / state-machine rule 2 forbids both from binding a gate (D5). Readiness (enforcement-architecture §6.1) is about specifiability, not authorization.
- **No new contradiction.** The analysis reproduces, quotes, and anchors every claim to a repository artifact; no fact was inferred and no blocker was made to disappear.

## 2. Required decisions (ADR board, ADR-003+, dated)

| # | Decision | Required instrument | Closes |
|---|---|---|---|
| 1 | Record the I11 SECURITY DEFINER exception (target element, scope, authority, expiry, status) **and** resolve the P3–I11 conflict (reconcile RULE 12's two homes; state the precedence between P3/I5 and I11) | **Formal ADR-003+** with a dated commitment (ADR-INDEX PQ-2) | **C6** |
| 2 | Select the canonical EC8 audit chain (Candidate A or B); record the other as projection; update the affected relationship/provenance artifacts (and, if B, amend object-model §2.3 + enforcement-architecture §2/§3) | **Formal ADR-003+** (ADR-INDEX PQ-1) | **PQ-1** |

Neither may be substituted by a documentation note, a bare R9 row, or an interpretation in a report (Governance Freeze §4; stress-test §4; object-model §2.2 — an Exception must reference an ADR or authority).

## 3. Binding statements

1. **Phase 4 is prohibited until C6 and PQ-1 close.** No enforcement engine, constraint/verification/gate authoring, predicate writing, EC8 audit building, or runtime wiring.
2. **The No-Change Boundary holds for this analysis.** Documentation only: zero changes to source, SQL, database, seeds, registries (R1–R11 untouched; I11 precedent remains Unrecorded), specifications, relationship models, APIs, commits, tags.
3. **This decision amends nothing in the constitution** (Governance Freeze §4). The three known constitutional defects (P3–I11 conflict, I11 bypass, P7 circularity) remain deferred to their ADRs.
4. **The later architectural review** must confirm closure of C1–C6 per `phase3-review-decision.md` §4 before approving Phase 4; this decision records the current status for that confirmation.

## 4. Decision log

| Date | Entry | Authority |
|---|---|---|
| 2026-08-10 | Governance analysis completed; C6 and PQ-1 confirmed OPEN; both require formal ADR-board decisions (ADR-003+); I11 un-bindable while Violated/Suspended (GD-2); risk register records 12 risks (C6RSK-01..05, PQ1RSK-01..05, GOVRSK-01..03); decision CONFIRMED OPEN. | D6 (Decision & Exception) / ADR board review |

---

Prepared by the governance review. Registered under `docs/architecture/registry/`. Not an ADR; does not amend the constitution.
