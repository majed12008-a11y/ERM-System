# Architecture Constitution Stress Test

| Field | Value |
|---|---|
| Status | COMPLETE — adversarial validation of the constitutional architecture |
| Date | 2026-08-06 |
| Authority | Independent Principal Architect, challenging under the frozen Baseline v2. ADR-002 is treated as constitutional; Architecture Phase = CLOSED; Governance Freeze = active; Transition Plan = approved. |
| Constraints honored | READ-ONLY. No code, SQL, manifests, migrations, commits. No redesign. No recommendations. Validation only. |
| Purpose | Attempt to BREAK the constitutional architecture under extreme scenarios, per-principle and per-invariant attack, governance-circumvention attempts, and dataset-philosophy relapse. |
| Verdict | **NO — the constitutional architecture did not survive the stress test.** |

**Method.** Each element is attacked adversarially. An element is invalidated only if the constitution contradicts itself, cannot express the scenario without unstated assumptions, or cannot prevent a documented violation. Deferred topics (closure decision §5, D1–D8) and out-of-scope mechanisms (ADR-002 §6) are explicitly neither-pass-nor-fail answers; where a challenge resolves to one of those, the verdict is PARTIALLY, not YES.

---

## SECTION 1 — Scenario Stress Test

For each extreme scenario: does the constitutional architecture remain valid?

| # | Scenario | Valid? | Why |
|---|---|---|---|
| 1 | 10× feature growth | **YES** | P2/P4/P8/P9 are scale-independent: 10× features create 10× ownership claims, each resolved by the same single-ownership, semantic-ordering, behavior-verification, and dead-data rules. Features retired by growth are handled by the P5/I7 lifecycle. |
| 2 | 10× data growth | **YES** | P1 (dataset is truth), P6/I10 (business identity) are volume-independent. I3 (construction reproducibility) becomes more expensive at 10× volume, but expense is a mechanism property (ADR-002 §6 out of scope), not an invariant violation. |
| 3 | Multiple countries | **YES** | Explicitly anticipated: C6/C11 express the multi-institution objective through dataset lifecycle branching/merging; P5/I7 make branch/merge mandatory lifecycle stages. |
| 4 | Multiple ministries | **YES** | Same constitutional mechanism as multiple countries (C11): dataset branches under one product, one lifecycle, one ownership model. |
| 5 | Multiple tenants | **PARTIALLY** | I11's RLS can express tenant isolation (row-level tenant predicates). But the constitution does not say whether P2/I4 single-ownership is global or tenant-scoped, whether the Application/Condition aggregate roots (P3) are tenant-scoped, or whether tenant isolation is the same construct as multi-institution branching (C11). The scenario is expressible only under unstated assumptions. |
| 6 | Multiple canonical datasets | **PARTIALLY** | Valid only as branches of the one product (C6/C11, P5). As genuinely separate products, P1 ("THE Canonical Dataset is the source of truth") becomes ambiguous — which product is truth? The constitution does not define the boundary between a branch of one dataset and a second dataset. This is the deferred topic D1. |
| 7 | Continuous migrations | **YES** | The final vocabulary separates Migration (versioned forward-only schema evolution) from data; I11 keeps schema, RLS, and data distinct. Continuous schema evolution is exactly what the constitution's separation-of-concerns exists for; data evolution is the P5 lifecycle. |
| 8 | Regulatory changes | **YES** | Rule content (RULE 11/12) is owned by the business rules framework, which is changeable governance; the freeze freezes the *ownership* of the rules (single authoritative model, P3/I5), not their content. A regulatory change updates rule content under the existing ownership model. |
| 9 | Replacement of PostgreSQL | **PARTIALLY** | I11 names a concrete PG mechanism ("RLS remains the sole access-control mechanism") and the entire access layer is 174+ PG RLS policies plus SECURITY DEFINER workarounds. The constitutional separation-of-concerns survives only if the replacement provides equivalent row-level access control. The invariant's mechanism is PG-bound; the principle is not. |
| 10 | Complete UI rewrite | **YES** | The constitution governs the dataset, not consumers. A UI rewrite that drops features triggers P9/I8 (retire the orphaned data) via P5; the rewrite itself is an implementation concern (ADR-002 §6 out of scope). |
| 11 | API versioning | **YES** | The constitution out-of-scopes interfaces. Data is versioned by P5/I7; API versioning is a consumer-side mechanism and does not conflict with dataset lifecycle. |
| 12 | Distributed deployment | **PARTIALLY** | I11 (RLS is session/identity-based via `app.user_id`), I3 (construction demonstrability), and P3/I5 (a single authoritative aggregate model) all assume one logical database and one identity context. Distribution requires per-node RLS identity propagation and cross-node aggregate-invariant enforcement — neither expressible nor forbidden by the constitution. The scenario is unaddressed, not answered. |
| 13 | Offline deployment | **YES** | Offline operation is a deployment-mode mechanism (deferred D7). Dataset construction (I3) uses local artifacts and works offline; I11 RLS is local. No invariant is contradicted. |
| 14 | Disaster recovery | **PARTIALLY** | C2/I3 forbid restoration *as construction proof*, but the constitution never defines recovery. A DR restore uses the dump as a carrier to recover an operational state — arguably permitted, arguably a drift vector (C12). Additionally I2: a restored database has no execution provenance, so any subsequent decision relying on its data is provenance-less. The constitution neither authorizes nor forbids the primary DR mechanism. |
| 15 | Parallel product editions | **YES** | Editions (v1/v2/v3) are versions of one product; P5/I7 (promote, version, deprecate) and C10 (change management) directly support them. I10 defines idempotency per edition by business identity. |

**Pattern of the partials.** The five PARTIALLY scenarios (tenants, multi-dataset, PG replacement, distribution, DR) share one property: the constitution remains valid only under an unstated assumption that the constitution itself does not supply. None breaks the constitution outright (0 NO); all five resolve to either a deferred topic (D1, D7) or a mechanism the constitution explicitly out-of-scopes (ADR-002 §6). The scenarios therefore do not invalidate the constitution — they expose that the constitution answers fewer questions than it claims to freeze.

---

## SECTION 2 — Principle Challenges

For each principle: the strongest invalidation attempt, and whether it holds.

| # | Principle | Invalidation attempt | Result |
|---|---|---|---|
| P1 | Dataset-first | The ONLY artifacts that can reproduce data today are the seed suite and the dump. Until `canonical-dataset-specification.md` (Phase 2) and construction tooling exist, the suite/dump is the de facto truth. P1 asserts a state that does not yet exist and is unverifiable. | **Holds only by declaration.** P1 is unenforceable until construction exists. It is an assertion, not a demonstrated property. |
| P2 | Domain ownership | The shared-kernel exception ("or is declared an explicit shared kernel") is an escape hatch: any contested datum can be *declared* a shared kernel, converting "exactly one owner" into "everyone owns it." `security.users` (FK fan-out 66×) is the live case. | **Weak.** The escape hatch is real; P2 depends on a governance act (the declaration) that the constitution does not define. |
| P3 | Aggregate ownership | RULE 11/12 "must be expressible in a single authoritative model" — but no such model exists. DOMAIN_MODEL is Partially Consistent (defines no aggregate), amendment is Phase 1, and consolidation-review traceability chain 5 is BROKEN. Today the invariants are scattered exactly as the principle forbids, and nothing has changed. | **Fails.** P3 is currently false. The authoritative model is promised (Phase 1), not present. |
| P4 | Semantic dependencies | The business dependency graph is never materialized in the constitution. Numeric order is banned, but the graph that replaces it is not defined, owned, or versioned anywhere in ADR-002. An unenforceable prohibition. | **Holds only by declaration.** No artifact implements P4 until construction exists. |
| P5 | Dataset lifecycle | Lifecycle transitions (promote/deprecate/archive) have no authority defined. P2 says each datum has one owner, but P5 does not say who approves a promotion or deprecation. The lifecycle exists as a word, not a process. | **Weak.** Roles/authority for lifecycle acts are undefined; deferred to Phase 2–4 artifacts. |
| P6 | Business identity over execution order | Natural keys and aggregate-root identity are not enumerated. Idempotency-by-business-identity cannot be defined until the identity sets exist (Phase 1/2). P6 is a promise about future construction. | **Holds only by declaration.** Same conditionality as P3/P4. |
| P7 | Provenance trust | The mechanism is circular: C3 requires provenance that "survives restore," but any recorded provenance is itself restore-able and forgeable. A restored provenance record proves nothing about execution — it only proves the record was copied. P7 demands evidence that any recordable evidence can be fabricated. | **Fails.** The constitution's own provenance requirement is self-defeating without an external anchor, which is undefined. |
| P8 | Behavior verification | Verification of behavior requires formalized behaviors (RULE 11 reachability, RULE 12 matrices). Those formalizations belong to the same missing aggregate model as P3. Until then, P8 has nothing to assert — integrity-only verification (exactly what the seed-quality report did) cannot be distinguished from compliant. | **Holds only by declaration.** Conditionality identical to P3/P6. |
| P9 | No dead data | "Zero consumers" is time-sensitive. A feature temporarily without consumers (mid-UI-rewrite, scenario 10) becomes "dead"; P5 retires its data; when consumers return, the data must be un-archived — a resurrection the lifecycle does not define (archive is a terminal-ish state; the constitution forbids data loss but not re-activation rules). | **Weak.** The consumer count is a snapshot, not a property; the constitution defines no measurement time nor resurrection path. |

**Cross-principle conflict.**

| Conflict | Resolution in the constitution | Verdict |
|---|---|---|
| **P3 vs I11.** P3/I5 require RULE 12 (the evidence-DELETE four-factor matrix) to live in a single authoritative model. I11 requires RLS to be the sole access-control mechanism. RULE 12 IS an access-control decision. One rule, two mandated authoritative homes (the aggregate model and the RLS policy layer). The constitution does not define how an access-control matrix can be simultaneously expressed in one model and in row-level policies. | None stated. | **Genuine conflict.** The constitution mandates two homes for the same invariant and does not reconcile them. |

No other principle pair conflicts (P1–P7 dependency weakness is a sequencing gap, not a contradiction; P2/P9's shared-kernel exception is internally consistent with I4). The P3-vs-I11 conflict is the only true contradiction.

---

## SECTION 3 — Invariant Challenges

For each invariant: the strongest violation attempt, and whether the architecture prevents it.

| # | Invariant | Violation attempt | Does the architecture prevent it? |
|---|---|---|---|
| I1 | Suite never the dataset product | An engineer uses the seed suite directly as the reference dataset (reads seeds as canonical content). | **No — prevention is documentation-only.** EC5 greps forbidden *words* in active documents; it cannot detect an engineer *behaving* as if seeds were truth. No mechanism distinguishes a dataset read from a seed read. |
| I2 | No decision on non-provenanced execution state | A team gates a release on seed-tracker `[OK]` rows that were restored from a dump. | **Partially.** EC6 explicitly re-bases cutover readiness on construction evidence, closing this specific gate. But the required replacement — provenance that survives restore (C3) — is the circular mechanism P7 invalidates. |
| I3 | Reproducibility by construction, not restoration | An operator installs by restoring a dump and asserts "the environment has the right data." | **No.** C2 forbids this in governance terms, but no mechanism detects that a state was restored rather than constructed. Prevention depends on an unexecuted Phase 2 construction artifact. |
| I4 | Single ownership per datum | A feature creates data in an unowned schema (the historical `monitoring.*` case). | **No.** P9/I8 require deprecation/retirement, but the constitution contains no enforcement step; the exact violation exists today in the accepted baseline. |
| I5 | Aggregate invariants in one authoritative model | RULE 11/12 placed in a repository method (the historical scattering). | **No.** DOMAIN_MODEL is not amended (Phase 1); traceability chain 5 is BROKEN; nothing currently prevents re-scattering. I5 is unenforced today. |
| I6 | Order respects business graph, never numeric | A construct runs in numeric order because no graph is materialized. | **No.** With no graph artifact defined, there is nothing to violate against; P4/I6 cannot be checked. |
| I7 | All canonical data in a lifecycle | Canonical data is inserted with no lifecycle stage. | **No.** Lifecycle mechanics are out of scope (ADR-002 §6); the constitution declares I7 but provides no stage registry or transition enforcement. |
| I8 | No consumerless data in canonical counts | `templates.*`/`monitoring.*` retained in canonical counts. | **Partially.** Canonical-spec §6 already enumerates the dead data (chain 4 is INTACT), so the *inventory* problem is solved. The retirement (P5) is undefined, so the data remains counted. |
| I9 | Verification asserts behavior, not only integrity | A verification run checks FK integrity only (the historical seed-quality posture). | **No.** Nothing distinguishes an integrity-only verification from a compliant one until P8's behavior formalizations exist. |
| I10 | Idempotency by business identity | Idempotency implemented by file position. | **No.** Natural keys are undefined (Phase 1/2); the constitution declares I10 but no mechanism can check identity-based idempotency. |
| I11 | Schema/RLS/data distinct; RLS sole access control; never disabled, never bypassed | Registration via `security.fn_register_user` — a SECURITY DEFINER function that bypasses RLS. | **No — and the violation is already in the accepted baseline.** The sanctioned fix `33-fix-register-rls.sql` is a documented RLS bypass (SECURITY DEFINER), justified by a PostgreSQL 18.3 Windows policy bug. The invariant says "never disabled, never bypassed"; the accepted baseline bypasses it, and the precedent authorizes future SECURITY DEFINER workarounds. |

**Result.** The architecture mechanically prevents **zero** of the eleven invariant violations. It prevents two by governance artifact (I2 via EC6, I8 via canonical-spec §6), and one is *already violated in the accepted baseline* (I11). The remaining eight are prevented by nothing — they are prohibited by declaration and unenforced until transition Phases 1–2 deliver the artifacts the constitution presupposes.

---

## SECTION 4 — Governance Challenge

Attempts to evolve the project without breaking the Governance Freeze.

| Attempt | Freeze response | Result |
|---|---|---|
| Execute the transition (Phase 0–5) | Explicitly permitted; it IS the freeze's own first act (Phase 0: ADR-001, template, index). | Allowed. |
| Add a new principle (e.g., a tenancy rule) | Requires a formal ADR (freeze §3). | Blocked — but resolvable via ADR. The freeze has a legitimate exit. |
| Introduce new terminology (e.g., "Tenant") for a needed feature | Requires an ADR (no new terminology beyond final vocabulary). A Gate-1 feature needing tenant semantics is blocked until such an ADR. | Blocked — resolvable, but the freeze *deliberately* stalls feature work until the ADR exists. |
| Create ADR-003 directly, skipping ADR-001 | Freeze §4.3: until ADR-001 exists, ADR-002 + freeze + transition plan are jointly the sole authority; no freeze modification outside it. A premature ADR has no template, no index, no numbering policy. | Blocked. The ordering gate is enforced. |
| Change ownership at code level (not in documents) | Freeze §3.3: a change that touches a frozen element IS a change to the frozen element, regardless of originating layer. | Blocked. No implementation loophole. |
| Write an "implementation-level" doc that introduces a new term | Freeze §3/§4: implementation documents change freely but must never contradict a frozen element; new terminology beyond the final vocabulary is forbidden. | Blocked — subject to classification dispute, but the freeze text covers it. |

**Conclusion.** The freeze is circumventable in exactly one way: the formal ADR path, whose entry precondition is Phase 0. Evolution is possible, but strictly ordered and gated. The governance challenge **failed to break the freeze** — with one consequence: between this date and Phase 0 completion, the freeze is absolute and blocks even the changes the ADR mechanism would later permit. That is a designed lock, not a defect. The freeze holds.

---

## SECTION 5 — Dataset Philosophy Challenge

Attempts to prove the project can fall back into Installer History Architecture, and whether ADR-002 prevents it.

| Fallback path | Does ADR-002 prevent it? |
|---|---|
| **Neglect.** Phase 0 is never executed; the Partially Consistent documents stay active; the mixed baseline persists exactly as the consolidation review described it. | **No.** ADR-002 prevents nothing here. Prevention is the transition plan's execution (EC1–EC10), which does not exist yet. The constitution only declares; it does not execute. |
| **Drift (C12's own named risk).** The Gate-0 dump becomes the only trusted artifact and the seed suite is abandoned. | **Partially.** C12 names this exact risk and asserts it is "addressed by making the Canonical Dataset a product with defined construction" — but that construction is a Phase 2 deliverable that does not exist. Until then, the dump remains the only reproducible carrier, and nothing stops it from becoming the operational truth. |
| **Terminology relapse.** A new active document uses "canonical seed." | **Yes — conditionally.** EC5 grep audits it, but only if the audit runs. Prevention is a governance step, not an architectural one. |
| **Mechanism relapse.** Restoration is normalized as the install path (DR or convenience). | **No.** I3/C2 forbid it in words; no mechanism detects restoration. Same unenforced-by-architecture result as invariant I3. |
| **Tooling vacancy.** The seed suite remains the only source that can reproduce data until construction tooling ships. | **No.** ADR-002 does not, and cannot, prevent the suite being the de facto truth in the interim; it only re-labels it (I1). |

**Conclusion.** ADR-002 does **not** prevent the fallback on its own. Every defense it has (EC5, EC6, EC7, C12's construction product) is a governance artifact or a Phase 2 deliverable that does not yet exist. The constitution's protection against Installer History Architecture is entirely delegated to the unexecuted transition plan and the unexecuted construction work. The constitution names the risk (C12) and describes the remedy; it does not provide the remedy.

---

## SECTION 6 — Final Verdict

**NO — the constitutional architecture did not survive the stress test.**

Not because any scenario collapsed it — the scenario test returned **0 NO** — but because the constitution fails the tests that matter under active attack:

1. **The invariants are not enforced by the architecture.** The test of each invariant ("does the architecture prevent the violation?") returned "no mechanism prevents it" for 8 of 11, "partially" for 2, and an active violation for 1. A constitution whose invariants are declarations, not enforced properties, does not survive an invariant challenge.

2. **One invariant is already violated in the accepted baseline.** I11 — "RLS ... never disabled, never bypassed" — is bypassed by the sanctioned `33-fix-register-rls.sql` SECURITY DEFINER workaround, and that precedent authorizes further bypasses. A frozen invariant that the baseline itself breaches is not frozen.

3. **The constitution presupposes artifacts that do not exist.** P3/I5 (single authoritative aggregate model), P4/I6 (business dependency graph), P6/I10 (business identity), P7 (provenance that survives restore), P8/I9 (behavior verification) all condition on Phase 1–2 deliverables. Until then these principles and invariants are unverifiable — the architecture freezes terms, not enforced properties.

4. **P7 is circular.** Provenance that must "survive restore" can itself be restored, and therefore proves nothing about execution. The constitution's trust mechanism is self-defeating without an external anchor it does not define.

5. **There is a genuine cross-principle conflict.** P3/I5 and I11 both mandate RULE 12 into a different authoritative home (single model vs RLS policies), with no reconciliation. A constitution containing an unresolved contradiction between its own principles and invariants is not internally consistent.

6. **The dataset-philosophy defense is delegated, not delivered.** Every fallback path into Installer History Architecture is blocked only by governance artifacts or Phase 2 construction that do not exist yet. The constitution names the drift risk (C12) but does not prevent it.

The constitutional architecture survives the scenario test and the governance challenge, but fails the principle, invariant, and dataset-philosophy challenges. It is a coherent **declaration** of architecture — not an architecture that prevents its own violation. Against an adversarial test that demands the constitution hold on its own terms, it does not.
