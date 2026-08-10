# C6 — SECURITY DEFINER Final Audit (Pre-ADR Deep Audit)

> Pre-ADR audit artifact. NOT part of the formal ADR series; does not amend the constitution; does not authorize Phase 4. Input to the ADR Board decision for ADR-003+ (ADR-INDEX PQ-1, PQ-2).

| Field | Value |
|---|---|
| Status | AUDIT COMPLETE (input only) |
| Date | 2026-08-10 |
| Author | Deep audit (read-only) |
| Scope | Mechanical SECURITY DEFINER inventory; I11 violation-surface reconstruction; exception options 1–6 evaluation; C6-D + C6-C test; RULE 12 authority separation |
| Constraints honored | No source/SQL/DB/seed/registry/spec/relationship/API change; no ADR-003+; no commit/tag; R1–R11 untouched; I11 precedent remains `Unrecorded` |
| Purpose | Verify the SECURITY DEFINER finding mechanically, reconstruct the real I11 violation surface by a causal rule, and determine whether the ADR Board can decide C6 and PQ-1 without further investigation |

---

## 1. Mechanical search — complete inventory

### 1.1 Files containing `SECURITY DEFINER`

| Class | Files | Notes |
|---|---|---|
| A. Executable objects | `database/canonical/functions/{system,security,committee,documents}.sql`; `database/bootstrap/06_functions.sql`; `backend/seed/11,14,18,25,32,33,40,42,46,47,51,57,58,59-*.sql` | Function definitions (canonical extraction + applied seeds) |
| B. References/comments | `AGENTS.md`; seed comments (11:17–21, 42:3–6, 47:60, 51:29, 57:10/121/177); `backend/src/repositories/users.repository.ts:105–108`; `backend/src/repositories/document-lifecycle.repository.ts:3`; governance `exception.registry.ts:5,29,32`, `verification.registry.ts:37`, `exception-linkage.ts:30`, `exception.specification.ts:37` | Documentation/annotations only — NOT executable occurrences |
| C. Historical artifacts | 17 `backend/backups/*.dump` (occurrence counts 15 → 27 → 29 → 32 across 2026-06-20 → 2026-08-05); root `schema_only_dump.sql` (27); `ethics_db_schema.sql` (15); `ethics_db_tables_constraints.sql` (15); `scripts/db-schema-tables.sql` (14); `scripts/db-schema-full.sql` (14); `backend/schema_only_dump.sql` (13); `backup_schema_dump.sql`; `ethics_db_backup.sql` | Live-state snapshots at various dates; the 6 schema dumps re-verify the recorded counts 27/15/15/14/14/13 |
| D. Tests/fixtures | `backend/src/governance/registries/__tests__/registries.test.ts:222`; `backend/src/governance/specifications/__tests__/specifications.test.ts:159` | Assert the R9 precedent is `Unrecorded`/deferred — governance tests, not DB objects |
| E. Migration-only objects | `backend/migrations/002_encryption.js` (`security.fn_encrypt`, `security.fn_decrypt`); `backend/migrations/003_auth_function.js` (`security.fn_authenticate` — also canonical) | Not present in canonical live extraction |

### 1.2 Executable surface — 30 SECURITY DEFINER functions

| Schema | Count | Functions |
|---|---|---|
| `system` | 13 | fn_apply_audit_triggers, fn_calculate_quorum, fn_check_sla, fn_create_snapshot, fn_current_user_id, fn_generate_application_number, fn_generate_project_code, fn_init_workflow, fn_is_admin() (no-arg), fn_is_admin(bigint), fn_is_committee_member_for_application, fn_log_audit, fn_notify_status_change |
| `security` | 4 | fn_authenticate, fn_register_user, fn_reset_password, fn_verify_email |
| `committee` | 6 | fn_cycle_created_by, fn_get_cycle_committee_id, fn_is_admin_or_cycle_creator_or_committee_admin, fn_is_assessor_for_cycle, fn_user_can_access_assessment, fn_user_can_access_cycle |
| `documents` | 5 | fn_get_certificate_verification, fn_verify_generated_document, fn_document_transition, fn_can_view_document, fn_is_document_signer |
| `security` (migration-only) | 2 | fn_encrypt, fn_decrypt (migration 002 only) |
| **Total** | **30** | 28 live + 2 migration-only |

Note: `committee.fn_is_committee_admin`, `system.fn_update_updated_at`, `system.is_active_row` are **NOT** SECURITY DEFINER (verified in source).

### 1.3 Live-surface growth (backup dump counts)

15 (2026-06-20/21) → 27 (2026-07-06..08-01) → 29 (2026-08-02) → 32 (2026-08-04/05, incl. `gate0-baseline-2026-08-04.dump`). The pre-restore dumps match their dates. This traces the accepted-baseline expansion; the Gate-0 document subsystem (seeds 57/58/59) contributes 4 new SECURITY DEFINER functions.

## 2. I11 causal rule

**Rule text (ADR-002 §5 line 124; rule.registry.ts:69):**

> Schema, RLS, and data are distinct architectural concerns; no single construct may own more than one (RLS remains the sole access-control mechanism per AGENTS.md — never disabled, never bypassed).

**Causal rule:** a SECURITY DEFINER function executes with the privileges of its owner (typically `ethics_owner`), so PostgreSQL does **not** apply RLS to the queries it executes. Therefore **every SECURITY DEFINER function that reads or writes an RLS-protected table is a bypass of RLS**. Per R9 (exception.registry.ts header): *"Unrecorded deviation = violation regardless of intent."* The only known precedent (`PRECEDENT-I11-SECURITY-DEFINER`) records scope **"registration only"** and status **`Unrecorded`**.

**Six sub-questions answered:**

| # | Question | Answer |
|---|---|---|
| 1 | Is the SECURITY DEFINER attribute itself an I11 violation? | **No.** I11 governs access control, not the language attribute. Functions with no RLS-protected-table access (e.g. `fn_current_user_id` — reads only the `app.user_id` GUC) do not bypass RLS; their SECURITY DEFINER marking is unnecessary hygiene, not a bypass. |
| 2 | Is a SECURITY DEFINER function that WRITES protected tables a violation? | **Yes.** `fn_register_user` (INSERT into `security.users`), `fn_document_transition` (UPDATE `documents.documents` + INSERT audit/approvals), `fn_reset_password`, `fn_verify_email`, `fn_init_workflow` — all run as owner, bypassing RLS on writes. |
| 3 | Is a SECURITY DEFINER function used INSIDE an RLS policy a violation? | **Yes.** `fn_is_admin()/fn_is_admin(bigint)`, `fn_can_view_document`, `fn_is_document_signer`, the 6 `committee.fn_*` helpers read role/membership/cycle data as owner inside policy predicates — bypassing RLS on those tables. This is the dominant pattern (~30+ policy call sites). |
| 4 | Does intent matter? | **No.** R9: unrecorded deviation = violation regardless of intent. |
| 5 | Workaround or design pattern? | Both, per seed comments: bug workaround (33), recursion breaker (32), role-bypass predicate (14/25), membership-bypass predicate (46), public verify with no session user (47/57), single mutation path (58). |
| 6 | Is the violation surface = all executable SECURITY DEFINER functions minus recorded exceptions? | **Yes.** The only recorded precedent is `Unrecorded` and covers registration only. Therefore **all 28 live executable functions** constitute the current unrecorded-deviation surface. |

## 3. Reconstructed I11 violation surface

- **Surface:** 28 live SECURITY DEFINER functions (13 system + 4 security + 6 committee + 5 documents), all bypassing RLS on protected data.
- **Recorded coverage:** 1 precedent, `Unrecorded`, scope "registration only" — covers only `security.fn_register_user`.
- **Uncovered surface:** 27 live functions — an order of magnitude wider than the recorded precedent. This is the fact the ADR Board's exception scope must confront (the recorded scope is factually false for the repository, per the earlier finding at DECISION-PACKAGE §6.2).
- **Migration-only (E):** `fn_encrypt`, `fn_decrypt` are transitional artifacts (migration 002), not runtime surface.
- **Historical (C):** the 17 backup dumps and schema dumps are evidence of surface growth, not live objects.

## 4. Exception options 1–6 — evaluation (no selection)

| # | Option | Constitutional consistency | Security | Ownership/auditability | Blast radius | Recommendation position |
|---|---|---|---|---|---|---|
| 1 | One broad exception covering all SECURITY DEFINER functions | Weakest — legitimizes the exact pattern stress-test §3 warns authorizes future workarounds | Highest risk of unbounded bypass | Single record, hard to audit per-function | Whole surface | Not recommended alone |
| 2 | Per-object/per-domain exceptions (28 records) | Strong; matches R9 record shape | Precise, minimal | Heavy registry load; each needs authority/expiry | Minimal | Defensible but operationally heavy |
| 3 | Bounded class exception with constraints (categories: policy-predicate reads, single mutation paths, public verify) + detection/registration requirement | Strong; matches C6-A carve-out shape | Bounded; categories enumerable from the inventory | Each category enumerable from the inventory | Moderate | **Viable core** of C6-C |
| 4 | Infrastructure-outside-I11 treatment (trigger/infra functions e.g. fn_log_audit, fn_apply_audit_triggers) | Requires reinterpreting I11 scope — risky since these write audit/protected data | Depends on the definition of "infrastructure" | Needs new classification rule | Wide | Not recommended alone |
| 5 | Amend I11 (C6-A) — bounded registered-bypass carve-out in the invariant text | Makes I11 text truthful about the baseline; largest frozen-text change | Bounded by carve-out wording | Precedent-authorization risk must be neutralized | Wide | Only if board wants text-truthfulness |
| 6 | Evidence-supported hybrid (C6-D interpretation + C6-C exception) | No frozen-text change; records precedence | Bounded, enumerable | Precedence rule + R9 record | Smallest | **RECOMMENDED** |

**Conclusion:** one exception is possible (option 3 is the sound bounded form; option 6 pairs it with the conflict resolution). Selection remains the Board's — this audit does not select.

## 5. Test: C6-D + C6-C recommendation

- **C6-D (interpretation):** DOMAIN_MODEL A02/A09 is the **semantic home** of RULE 12; RLS policies are its **enforcement expression**; no P3/I5 text change. Resolves the P3–I11 conflict (RULE 12's two homes) by separating semantics from enforcement.
- **C6-C (exception):** record the exception in R9 with authority = the ADR, scope fixed to the **full enumerated 28-function live surface** (not "registration only"), expiry set, status `Recorded`; I11 → **Suspended** (state-machine transition 10) for the exception's scope/expiry.
- **Test result — SUFFICIENT for C6 governance closure:** the pair satisfies C6's two required parts (record exception + resolve the P3–I11 conflict; phase3-review-decision.md §3 C6; ADR-INDEX PQ-2).
- **Test result — NOT sufficient to bind the I11 gate:** GD-2 / state-machine rule 2 forbids a gate on a rule in **Violated or Suspended**; a recorded exception leaves I11 **Suspended** → still un-bindable. The I11 bypass-detection verification cannot be gated while the exception is in force. This is a documented consequence, not a defect of the pair.

## 6. RULE 12 authority — semantic vs enforcement

| Concern | Owner | Source |
|---|---|---|
| **Semantic authority** (the four-factor matrix, its invariants) | DOMAIN_MODEL aggregates A02 (Condition), A09 (Document); R2 constraint per aggregate | P3, I5; DOMAIN_MODEL V4/V8 |
| **Enforcement location** | RLS policy `WHERE` clauses on `documents.documents` (`FOR DELETE USING (false)`), `document_access`, `documents_select_policy` | I11 |
| **Verification owner** | D4 (Verification) | constitutional-enforcement-architecture.md §1 |
| **Decision/exception owner** | D6 (Decision & Exception) — ADR Board | constitutional-enforcement-architecture.md §1 |

**Result:** once semantics (aggregate model) is separated from enforcement (RLS policies), no single construct owns more than one concern; the P3–I11 conflict disappears without amendment. RULE 12's aggregate home is satisfied (DOMAIN_MODEL V8); its RLS home remains per I11; the separation IS the C6-D interpretation.

## 7. Conclusions

1. The SECURITY DEFINER finding is **verified** and the surface is **complete**: 30 executable functions (28 live + 2 migration-only), classified A–E; the recorded counts 27/15/15/14/14/13 are re-verified from the 6 schema dumps.
2. The real I11 violation surface is **all 28 live SECURITY DEFINER functions** (unrecorded deviation; the 1 recorded precedent is `Unrecorded` and covers registration only).
3. **One exception is possible**; the bounded class form (option 3) is sound and the recommended hybrid (C6-D + C6-C, option 6) resolves both C6 parts.
4. C6-D + C6-C is **sufficient for C6 governance closure** but leaves I11 gate-unbindable (GD-2) — a documented consequence.
5. RULE 12's semantic vs enforcement authority is **separable without amendment**.
6. The Board can decide C6 **now** with the evidence in this artifact and the inventory CSV; no further investigation is required.

## 8. References

- `docs/architecture/adr/ADR-002-canonical-dataset-architecture.md` (I11 §5 line 124; P3 §3; I5 §5)
- `backend/src/governance/registries/exception.registry.ts` (R9 precedent)
- `backend/src/governance/registries/rule.registry.ts` (R1 I11, lines 67–74)
- `backend/src/governance/registries/verification.registry.ts` (READY_OUTSIDE_INITIAL_SET line 37)
- `docs/architecture-constitution-stress-test.md` (§2 conflict; §3 I11 row)
- `docs/architecture-enforcement-model.md` (§5 failures 1–2)
- `C6-security-definer-inventory.csv` (companion)
- Prior package: `ADR-BOARD-C6-PQ1-DECISION-PACKAGE.md`, `ADR-BOARD-C6-PQ1-OPTION-MATRIX.csv`, `ADR-BOARD-C6-PQ1-RECOMMENDATION.md`
