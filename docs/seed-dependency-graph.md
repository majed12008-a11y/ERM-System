# Seed Dependency Graph — `backend/seed`

**Task:** RC4 Phase-2 — reconstruct the dependency relationships between the 79 seed files.
**Method:** Programmatic analysis of every `INSERT ... SELECT ... FROM` clause and hardcoded anchor references across all 79 files (`seed_analysis.csv`, `seed_insert_map.csv`, `seed_dependency_edges.csv`). Edges = "seed A reads table T that seed B writes". DDL-only seeds (policy/function/index) are structural, not data-dependent.
**Deliverable:** `seed_dependency_edges.csv` (113 edges across 24 seeds).

---

# 1. Topology summary

The seed suite is a **near-linear numeric chain** with two structural facts that break naive ordering:

1. **Only 24 of 79 seeds have data dependencies** (`INSERT...SELECT` or anchor lookups). The other 55 are DDL (policies/functions/indexes/tables), pure-`VALUES` inserts, or self-contained generators.
2. **Two parallel data lineages coexist** — the demo-era lineage (seeds `01`–`10` → anchors `KSU`/`IRB-KSU-01`/`APP-2024-*`/demo users) and the Yemen lineage (seeds `50`–`54` → anchors `APP-2025-*`/`APP-2026-*`/Yemen users). They insert into the **same tables** but with **incompatible anchor sets**.

```
DEMO LINEAGE (01–10)                     YEMEN LINEAGE (50–54)
─────────────────────                    ─────────────────────
01-reference → KSU institution           50-yemen-institutions → 41 Yemen inst
02-users → demo users (7 roles)          51-yemen-users → 95+ Yemen users
03-committees → IRB-KSU-01               52-yemen-projects → 93 projects
04-documents → document types            53-yemen-applications → 100+ apps
05-workflow → APP_REVIEW_V1              54-yemen-documents → 1500+ docs
06-projects-apps → APP-2024-001..005
07-workflow-instances → instances
08-reviews → assignments/forms
09-meetings-etc → meetings/comm
│                                        │
└──────┬─────────────────────────────────┘
       ▼
17-safety-data        → reads core.applications, security.users  (anchors APP-2024-* → NO-OP)
18-monitoring-data    → reads core.applications, security.users  (anchors APP-2024-* → NO-OP)
19-additional-comm    → reads communication.notifications        (anchored → partial)
20-remaining-core     → reads 9 tables (incl. applications/users) (anchors APP-2024-* → NO-OP)
21-committee-expand   → reads 6 tables (incl. institutions, users)(anchors APP-2024-006..008 → NO-OP)
28-ethics-risk        → reads applications (anchors APP-2024-*)  (NO-OP)
29-informed-consent   → reads applications (anchors APP-2024-*)  (NO-OP)
33-accreditation-seed → reads accreditation standards + chairs   (NO-OP)
```

The **cross-lineage dead zone** is exactly where the empty domains live: 17/18/20/21/28/29/33 all read demo-era anchors that the Yemen lineage replaced.

---

# 2. The 24 data-dependent seeds and their edges

From `seed_dependency_edges.csv` (113 edges). Grouped by seed, showing which prior seed wrote the table it reads:

| Seed | Dependencies (prior seeds writing its source tables) | Edge count |
|------|------------------------------------------------------|-----------:|
| `02-users.sql` | ← `01-reference` (departments) | 1 |
| `03-committees.sql` | ← `01-reference` (institutions) | 1 |
| `06-projects-apps.sql` | ← `02-users` (users) | 1 |
| `07-workflow-instances.sql` | ← `05-workflow` (workflows, transitions) | 2 |
| `08-reviews.sql` | ← `06-projects-apps` (applications) | 1 |
| `09-meetings-etc.sql` | ← `02-users`, `03-committees`, `06-projects-apps` | 3 |
| `10-yemen-institutions.sql` | ← `01-reference` (institution_types, institutions) | 2 |
| `17-safety-data.sql` | ← `02-users`, `06-projects-apps` (**dead anchors**) | 2 |
| `18-monitoring-data.sql` | ← `02-users` (**dead anchors**) | 1 |
| `19-additional-communication.sql` | ← `02-users`, `09-meetings-etc` | 2 |
| `20-remaining-core-data.sql` | ← `02,05,06,07,09` (8 tables) (**dead anchors**) | 8 |
| `21-committee-expansion.sql` | ← `01,02,03,06,10` (9 edges) (**dead anchors**) | 9 |
| `35-reference-add-statuses.sql` | ← `01-reference` (application_statuses) | 1 |
| `36-workflow-add-states.sql` | ← `05-workflow` (workflows) | 1 |
| `37-workflow-add-transitions.sql` | ← `05-workflow` (workflows) | 1 |
| `41-application-conditions.sql` | ← `04-documents` (document_types) | 1 |
| `51-accreditation-workflow.sql` | ← `05-workflow`, `33-accreditation-seed` | 2 |
| `51-yemen-users.sql` | ← `01,10,50` (institutions) | 3 |
| `52-yemen-projects.sql` | ← `06-projects-apps`, `21-committee-expansion` (projects) | 2 |
| `53-yemen-applications.sql` | ← `03,06,07,21,40,51` (7 edges) | 7 |
| `54-yemen-documents.sql` | ← `04,06,09,21,41,45,53` (7 edges) | 7 |
| `63-document-retention-rules.sql` | ← `04,41,45,54,55` (5 edges) | 5 |
| `95-pilot-dataset.sql` | ← 12 different seeds (20 edges) | 20 |
| `96-realistic-data.sql` | ← 14 different seeds (30 edges) | 30 |

**Full edge list** (113 rows: `Seed, DependsOn, Table, Reason`) is in `seed_dependency_edges.csv`.

---

# 3. Dependency chains (longest paths)

## 3.1 The Yemen lineage backbone (active, healthy)

```
50-yemen-institutions
  └→ 51-yemen-users          (reads security.institutions)
       └→ 52-yemen-projects  (reads core.projects)
            └→ 53-yemen-applications  (reads core.applications, committees, workflow_instances)
                 └→ 54-yemen-documents  (reads core.applications, document_types, documents)
                      └→ 63-document-retention-rules  (reads document_types)
```

This is the **only fully-satisfied chain** — every edge resolves because every anchor exists. It produces the 45,453-row baseline.

## 3.2 The demo lineage backbone (dead in current DB)

```
01-reference → 02-users → 03-committees → 06-projects-apps (APP-2024-*)
   └→ 07-workflow-instances → 08-reviews → 09-meetings-etc
```
All anchors (`KSU`, `IRB-KSU-01`, `researcher1`, `APP-2024-*`) are absent from the DB. The lineage itself is what *created* them — but the Yemen lineage later overwrote/replaced those tables.

## 3.3 The cross-lineage dead zone (the bug)

```
06-projects-apps (APP-2024-001..005) ──dead──→ 17-safety-data
                                              18-monitoring-data
                                              20-remaining-core-data
                                              28-ethics-risk-assessment
                                              29-informed-consent
06/08/09 (demo users/apps) ──────────dead──→ 21-committee-expansion (APP-2024-006..008)
33-accreditation (chairs) ───────────dead──→ 51-accreditation-workflow
```

Every one of these edges points to an anchor that no longer exists → silent 0-row inserts.

## 3.4 Secondary/optional chains

- **Accreditation**: `31-accreditation-schema` → `32-accreditation-rls` → `33-accreditation-seed` → `51-accreditation-workflow`. The first three create tables/policies; the seed and workflow need chairs/standards that don't exist. Result: tables exist, `ACCREDITATION_CYCLE_V1` workflow **absent** from DB despite tracker `success`.
- **Gate-0 documents**: `45-certificates` → `57-document-infrastructure` → `58-gate0-lifecycle` → `59-gate0-rls` → `60-signatures` → `61-rls` → `62-watermark` → `63-retention-rules`. Fully resolved (Gate-0 baseline), no dead anchors.
- **Forms**: `55-forms-library` → `56-forms-library-templates`. Self-contained, resolved.
- **Test datasets**: `90-gen-test-data`, `95-pilot-dataset`, `96-realistic-data` are **fan-in sinks** — they read from 12–14 earlier seeds (institutions, users, committees, applications). On the current baseline they partially resolve (Yemen anchors exist) but their demo-era reads (e.g., 96's `ethics_admin`/`adverse_events` reads) no-op.

---

# 4. DDL-only seeds (no data edges) — 55 files

These create policies/functions/indexes/tables/triggers and have no data dependencies. They are the "migration" half of the suite:

`00-seed-tracker`, `00-truncate`, `12-soft-delete`, `13-audit-triggers`, `13-data-dictionary`, `14-rls-complete`, `15-rls-select-policy-fix`, `16-pagination-indexes`, `16-rls-communication`, `16-rls-enable`, `17-rls-cud-policies`, `18-audit-fix`, `22-add-member-roles`, `23-add-audit-columns`, `24-prod-readiness-fixes`, `25-rls-monitoring-reporting`, `26-reference-data-crud`, `27-notification-channel-config`, `30-rls-ethics-risk`, `31-accreditation-schema`, `32-accreditation-rls`, `33-fix-register-rls`, `34-documents-insert-rls`, `38-workflow-add-constraints`, `40-init-workflow-idempotent`, `42/43-fix-workflow-*rls`, `44-fix-terminal-states`, `46-certificate-rls-hotfix`, `47-public-verify-function`, `48-notification-source-columns`, `49-notification-preferences`, `50-notification-logs-rls-fix`, `57-document-infrastructure`, `58-gate0-document-lifecycle`, `58-official-templates-en`, `59-gate0-document-rls`, `60/61-gate0-signature*-rls`, `62-watermark-engine`, `99-fix-checksums`, `migration-add-question-options`.

> Their numeric interleaving (e.g. `17-rls-cud-policies` before `17-safety-data`; `18-audit-fix` before `18-monitoring-data`) shows the directory was grown by **appending fixes next to the file they fix**, not by a coherent migration plan. This is the D-01 evidence from `RC4-ARCHITECTURE.md`.

---

# 5. Graph-level conclusions

1. **The dependency graph is not a DAG with one root — it is two roots** (demo + Yemen lineages) that collide in the shared tables. The collision is where data is lost.
2. **Numeric ordering is insufficient to detect the dead zone**: seeds 17/18/20/21/28/29/33 run "successfully" (psql exit 0) because an `INSERT...SELECT` that matches zero rows is not an error. Only an anchor-existence check at seed time would have caught it.
3. **`51-accreditation-workflow` is a live example of a dangling edge**: its `WHERE NOT EXISTS` guard would create `ACCREDITATION_CYCLE_V1` in `workflow.workflows`, but it is absent from the DB — proving that seed either rolled back (its transaction with `33-accreditation-seed` data) or was never genuinely applied, despite tracker `success`.
4. **For a clean future state**, the graph should be reduced to the Yemen lineage backbone (§3.1) + DDL stack + Gate-0 chain (§3.4), and the dead-zone seeds (17/18/20/21/28/29/33) should be repointed to Yemen anchors or removed.
