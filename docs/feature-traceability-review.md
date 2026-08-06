# Feature ↔ Data Traceability Review

**Task:** RC4 final validation — Stage 2: validate the implemented system from the **feature** perspective. For every feature trace the full chain Feature → API Routes → Services → Repositories → Tables → Seed Sources → Data Population, classify per-feature status, and answer whether the canonical dataset can demonstrate 100% of the implemented system.
**Scope:** 315 API leaf routes (Express mounted at `/api/v1`), 30 services, 41 repository classes, 234 tables, 79 seed files, 51 frontend pages, 19 SDK files, verified Gate-0 baseline (2026-08-04, 45,453 rows).
**Compliance:** READ-ONLY. No SQL, schema, migration, seed, code, or documentation beyond this deliverable was modified. No commits.

**Companion artifacts:**
- `docs/feature-traceability-matrix.csv` — per-feature chain summary (28 rows: status, route counts, empty-table reads, gaps)
- `docs/backend-route-traceability.csv` — route-level join (315 rows: module, method, route, layer, target service/repo, read tables, empty-read tables)
- `docs/canonical-population-matrix.csv` — per-table population status (234 rows: category, population phase, status, read-by/write-by repos, seed sources)
- Prior verified deliverables (referenced, not duplicated): `architecture-normalization-review.md`, `architecture-normalization-tables.csv`, `architecture-normalization-seeds.csv`, `database-population-audit.md`, `seed-coverage-matrix.md`, `backend-table-usage.md`, `seed-quality-report.md`

---

# Executive summary

The system is implemented end-to-end for its **core path** — authentication, institutions, users/roles, applications, projects, conditions/evidence, documents, committees, meetings, reviews, certificates, forms, messaging, workflow, and reporting are all backed by a canonical dataset (Yemen lineage: 41 institutions, 106 users, 112 applications, 121 projects, 1,062 documents, 57 certificates, 489 workflow actions) that is readable and demonstrable.

Seven functional areas, however, are **structurally complete but contain zero rows**: Accreditation (9 tables), Consent management (4), Ethics-risk (3), Safety (13), Monitoring (11), E-signatures (3), and Integration (7 of 8). Their seeds exist but **rolled back** (transaction-abort chains in `17-safety`, `18-monitoring`, `28-ethics-risk`, `29-consent`, `33-accreditation`, `90/95/96`). A further 11 features are **partially operational** because one or more supporting tables are empty (e.g., `review_answers`/`review_scores`, `meeting_minutes`, `agenda_items`, `member_terms/qualifications/conflicts`, `workflow_sla`, `message_attachments`, `push_config`, `approval_certificate_documents`).

Headline findings:

| # | Finding | Evidence |
|---|---------|----------|
| F1 | **7 features are unimplementable with the canonical dataset** — their tables are 100% empty despite seeds existing | §3 (S2); 52 tables with registered seeds are empty (seed rollback) |
| F2 | **36 tables are read by 21 repository classes but are empty** — every route touching them returns an empty list or 404 | §4 (S4) |
| F3 | **51 tables are populated but never read** by any repository (41 never touched at all) — dead seed data, e.g. the entire `templates.*` library (seed 55) | §3 (S3) |
| F4 | **163 of 315 API routes traverse at least one empty table** in their read path | §5 (S5) |
| F5 | **Frontend/SDK path mismatches**: `certificates.sdk.ts` hardcodes `applicationId=0`; `Admin/EmailSettings.tsx` is not registered in `App.tsx`; monitoring/consent/accreditation pages exist with no data behind them | §6 (S6) |
| F6 | **Answer to S10 is NO** — the canonical dataset demonstrates the core path only; it cannot demonstrate accreditation, consent, ethics-risk, safety, monitoring, e-signatures, or integration | §10 |

---

# Section 1 — Feature → API → Service → Repository → Table → Seed → Population matrix

## 1.1 Method

The chain was assembled from four verified intermediate artifacts (each is a full inventory, not a sample):

1. **Routes** — `backend-route-traceability.csv` (315 leaf routes): every route parsed from `backend/src/modules/**/*.routes.ts` plus inline `index.ts` routes, with sub-router mounts resolved (`core/index.ts` mounts `/applications`, `/projects`, `/applications/:applicationId/conditions`, `/applications/:applicationId/certificates`; `committee/index.ts` mounts `/committees`, `/meetings`, `/reviews`, `/members`, `/voting`, `/ethics-risk`, `/consent`, `/accreditation`; `security/index.ts` mounts `/auth`, `/users`, `/roles`, `/permissions`; etc.). Each route resolves to the service class or repository class it invokes (constructor-injection aware).
2. **Services** — `service_repo_map` (30 service classes → the repository classes they instantiate/inject; e.g. `CommitteeService` → Committee, Member, Review, Meeting, Voting, Application, Document repositories).
3. **Repositories** — `repo_table_map` (292 repo↔table pairs, 210 READ / 82 WRITE, all schema-qualified, 103 distinct tables).
4. **Tables/Seeds/Population** — `canonical-population-matrix.csv` (234 tables) joined to `seed_insert_map` (per-table seed sources) and the verified baseline row counts.

The route→table mapping is **service-level attribution**: a route is flagged when its service/repository's read set includes an empty table. Where a single service serves many routes (e.g. `CommitteeService` serves 101 routes), the flag is conservative; the specific blocking tables per feature are stated in the feature matrix and were individually verified against the source files.

## 1.2 The complete matrix

The full 28-feature chain is in `docs/feature-traceability-matrix.csv` (columns: Feature, Status, Routes, RoutesReadingEmpty, EmptyTables, Gaps). A condensed version:

| Feature | Status | Routes | Routes reading empty tables | Key empty tables |
|---------|--------|-------:|---------------------------:|------------------|
| Authentication & Registration | Fully operational | 7 | 7* | `security.password_reset_tokens` (runtime-expected) |
| Password Recovery | Fully operational | 3 | 3* | same (runtime tokens) |
| User / Role / Permission Management | Fully operational | 10 | 0 | — |
| Institutions & Reference Data | Fully operational | 5 | 0 | `reference.licenses_registry` |
| Applications | Partially operational | 18 | 9 | `documents.approval_certificate_documents`, `workflow.workflow_sla` |
| Projects | Fully operational | 4 | 0 | — |
| Conditions & Evidence | Fully operational | 5 | 0 | — |
| Certificates & Public Verification | Partially operational | 9 | 1 | `documents.approval_certificate_documents` |
| Document Management & Lifecycle | Partially operational | 22 | 0 | `document_approvals`, `document_disposal_logs` |
| E-Signatures | Structurally complete but data missing | 22 | 0 | `security.digital_certificates`, `certificate_revocations` |
| Committee Management | Partially operational | 9 | 9 | `committee_member_roles`, `member_terms/qualifications/conflicts` |
| Committee Meetings | Partially operational | 15 | 15 | `agenda_items`, `meeting_minutes`, `quorum_logs` |
| Committee Reviews | Partially operational | 11 | 11 | `review_answers`, `review_scores` |
| Informed Consent | Structurally complete but data missing | 13 | 13 | all 4 consent tables (seed 29 failed) |
| Ethics Risk Assessment | Structurally complete but data missing | 7 | 7 | 2 ethics-risk + `safety.risk_categories` (seed 28 failed) |
| Accreditation | Structurally complete but data missing | 15 | 15 | all 9 accreditation tables (seed 33 failed) |
| Safety | Structurally complete but data missing | 8 | 8 | all 13 safety tables (seeds 17/90/95/96 failed) |
| Monitoring & Compliance | Structurally complete but data missing | 6 | 0 | 11 monitoring tables (seed 18 failed); no UI |
| Workflow Engine | Partially operational | 4 | 4 | `workflow_sla`, tasks/escalations/schedulers/triggers/events/variables |
| Communication | Partially operational | 11 | 10 | `message_attachments`, `announcements`, `preferences` |
| Dynamic Forms | Fully operational | 16 | 0 | — |
| Templates Engine (forms library) | Data exists but feature missing | 20 | 0 | `templates.*` seeded but never read |
| Reporting & Dashboards | Partially operational | 1 | 0 | `analytics_snapshots`, `kpi_results`, `report_executions` |
| System Configuration | Partially operational | 12 | 3 | `system.push_config`, `feature_flags`, `business_rules`+`rule_*` |
| Audit & Data Integrity | Partially operational | 2 | 0 | `hash_ledger`, `entity_changes`; `audit_details` unread |
| Integration | Structurally complete but data missing | 2 | 2 | `integration_logs`; 7 of 8 integration tables empty |
| Saved Searches | Fully operational | 3 | 0 | — |
| Admin Operations (backup) | Fully operational | 6 | 0 | — |

\* Flags on auth routes are the `password_reset_tokens` table, which is **runtime-expected empty** (tokens are created on demand); they are not gaps.

---

# Section 2 — Feature status classification (S2)

The 28 features above fall into the six-state classification as follows (full rationale per feature in the matrix `Status` column):

| Status | Count | Features |
|--------|------:|----------|
| Fully operational | 9 | Auth/Registration, Password Recovery, User/Role/Permission, Institutions & Reference, Projects, Conditions & Evidence, Dynamic Forms, Saved Searches, Admin Backup |
| Partially operational | 11 | Applications, Certificates & Public Verification, Document Management, Committee Management, Committee Meetings, Committee Reviews, Workflow, Communication, Reporting, System Configuration, Audit & Data Integrity |
| Structurally complete but data missing | 7 | E-Signatures, Informed Consent, Ethics Risk, Accreditation, Safety, Monitoring, Integration |
| Dead feature | 0 | — (no implemented feature is dead: every module has live routes and a UI or SDK) |
| Data exists but feature missing | 1 | Templates Engine (forms library) — `templates.*` seeded (12 templates, 13 versions, 44 variables, 5 partials, 12 categories) but no repository or route consumes it |
| Feature bypasses seeded data | 0 | — (no feature reads its seed data through a path that ignores the canonical dataset) |

### Root cause of the 7 "data missing" features

Every one of the 7 blocked features has a dedicated seed that **attempted** to populate it, but the seed **rolled back** (the whole seed file aborts when one INSERT fails, see `database-population-audit.md`). Verified rollback chain: `17-safety-data.sql` (and `90/95/96`) abort on `safety.mitigation_actions.risk_assessment_id NOT NULL`; `18-monitoring-data.sql`, `28-ethics-risk-assessment.sql`, `29-informed-consent.sql`, and `33-accreditation-seed.sql` all fail for the same class of dependency or CHECK violations. Result: 52 tables have dedicated seed files that attempt population (17 inserts in `33-accreditation`, 36 in `17-safety`, 28 in `18-monitoring`, 8 in `28-ethics-risk`, 28 in `29-consent`) yet contain **0 rows**.

---

# Section 3 — Populated-but-never-read tables (S3)

**Definition:** tables with `row_count > 0` in the baseline that no repository class reads (READ side of `repo_table_map`).

**Count: 51 tables** (41 of which are never written by any repository either — populated only by seeds/triggers). Full list in `canonical-population-matrix.csv`; the notable groups:

| Group | Tables | Rows | Implication |
|-------|--------|-----:|-------------|
| `templates.*` (forms library) | templates, template_versions, template_variables, template_partials, categories, template_version_audit | 12/13/44/5/12/4 | Seed 55 data is **dead** — no consumer |
| `reference.*` lookups | lookup_categories, lookup_values, academic_titles, professions_registry, status_types, review_statuses, vote_types, risk_levels, priority_levels, workflow_statuses, document_statuses, notification_statuses, committee_decision_types | 5–11 each | Read via **direct-SQL routes** (reference module, not repository classes) — see caveat |
| `core.*` project sub-tables | project_keywords (372), project_funding_sources (93), project_sites (93), project_status_history (93), project_team_members (141), application_history (459), application_versions (34), application_amendments (7) | see rows | Populated by seeds; no repository reads them directly (some are read via direct SQL in `ApplicationService`) |
| `documents.document_access` | 3,956 | audit-side access log, never queried | Sizing/audit blind spot |
| `audit.audit_details` | 12,852 | trigger-populated, never read (unlike `audit_logs` which MonitoringRepository reads) | Data-integrity gap |
| `ops.seed_tracker` | 78 | ops metadata, read only by scripts | fine |

**Caveat:** "never read by a repository" does not mean "never read". Several of these tables are read by **direct-SQL routes** (`reference/index.ts` reads `reference.professions_registry`; `core/lookups.routes.ts` reads `core.research_categories`, `core.risk_classifications`, `core.vulnerable_populations`). The report distinguishes repository-read (structured, RLS-guarded) from route-level SQL. The `templates.*` group, however, is unread by **both** repositories and direct-SQL routes — genuinely dead data.

---

# Section 4 — Repositories reading empty tables (S4)

**S4a — repositories whose READ tables are all empty (2):**
- `ConsentTemplateRepository` — reads only `committee.consent_templates` (0)
- `PushConfigRepository` — reads only `system.push_config` (0)

**S4b — repositories reading ≥1 empty table (21):**

| Repository | Empty tables read |
|------------|-------------------|
| SafetyRepository | 7 safety tables |
| AccreditationCycleRepository | 6 accreditation tables |
| AccreditationAssessmentRepository | 4 |
| AccreditationConditionRepository | 4 |
| ApplicationConsentRepository | 4 (consent_templates, consent_template_versions, application_consents, consent_review_comments) |
| AccreditationEvidenceRepository | 3 |
| MemberRepository | 3 (member_terms, member_qualifications, member_conflicts) |
| EthicsRiskRepository | 3 (ethics_risk_assessments, ethics_risk_items, safety.risk_categories) |
| ConsentVersionRepository | 3 |
| ReviewRepository | 2 (review_answers, review_scores) |
| MeetingRepository | 2 (agenda_items, meeting_minutes) |
| PushConfigRepository | 1 |
| IntegrationRepository | 1 (integration_logs) |
| ConsentReviewRepository | 1 |
| CommunicationRepository | 1 (message_attachments) |
| CommitteeRepository | 1 (committee_member_roles) |
| CertificateRepository | 1 (approval_certificate_documents) |
| AuthRepository | 1 (password_reset_tokens — runtime-expected) |
| AccreditationDecisionRepository | 1 |
| ConsentTemplateRepository | 1 |
| WorkflowRepository | 1 (workflow_sla) |

Every one of these repositories is the data-access layer of a live feature. A route through any of them returns `[]` or `404` for the empty side of its domain.

---

# Section 5 — API endpoints depending on missing data (S5)

**163 of 315 leaf routes** (52%) traverse at least one empty table in their read path (service-level attribution). Distribution by module:

| Module | Routes reading empty tables | Main empty dependencies |
|--------|---------------------------:|-------------------------|
| committee | 101 | accreditation (9), consent (4), ethics-risk (3), agenda_items, meeting_minutes, member_terms/qualifications/conflicts, committee_member_roles, review_answers, review_scores |
| safety | 14 | all 13 safety tables |
| communication | 12 | message_attachments |
| core | 11 | approval_certificate_documents, workflow_sla |
| security | 10 | password_reset_tokens (runtime-expected) |
| admin | 9 | system.push_config |
| workflow | 4 | workflow_sla |
| integration | 2 | integration_logs |

The highest-impact endpoint families (each returns empty or errors without data):

1. **Accreditation** — `GET/POST/PUT/PATCH/DELETE /api/v1/committee/accreditation/*` (15 routes) — entire feature empty.
2. **Consent** — `/api/v1/committee/consent/*` (13 routes) — entire feature empty.
3. **Ethics-risk** — `/api/v1/committee/ethics-risk/*` (7 routes) — entire feature empty.
4. **Safety** — `/api/v1/safety/*` (8 routes) — entire feature empty.
5. **Committee member detail** — `GET /committee/members/:memberId/conflicts|qualifications|terms` — empty.
6. **Meeting artifacts** — `GET/POST /committee/meetings/:id/minutes`, `/agenda`, `/quorum` — minutes/quorum/agenda items empty.
7. **Review scoring** — `GET /committee/reviews/:applicationConsentId`, `GET /committee/reviews/.../answers`, `/score` — empty.
8. **Certificates** — `GET /core/applications/:applicationId/certificates` reads `approval_certificate_documents` (0) — certificate rows exist (57) but linked PDF documents do not.
9. **Integration** — `GET /integration/logs` — empty; `GET /integration/events` reads `event_outbox` (30) and works.

---

# Section 6 — UI pages blocked by absent seed data (S6)

Of 48 registered routes in `frontend/src/App.tsx` (51 page components on disk):

**Pages whose primary data source is empty (rendered blank/empty-state):**
- `Accreditation/*` (6 pages: CyclesList, CycleDetail, Evidence, AssessmentsList, ConditionsList, Dashboard) — all 9 accreditation tables empty
- `Admin/ConsentTemplates`, `Admin/ConsentTemplateVersions` — all consent tables empty
- `Safety/*` (4 pages: RiskRegister, AdverseEvents, RiskIncidents, CorrectiveActions) — all safety tables empty
- `ESignatures/ESignaturesPage` — digital_certificates (0), certificate_revocations (0)

**Pages partially blocked:**
- `Committee/MeetingDetail` — minutes/quorum/agenda sections empty
- `Committee/CommitteeDetail` — member terms/qualifications/conflicts empty
- `ReviewForms/ReviewFormsPage` — answers/scores empty
- `Applications/CertificatesTab` — certificate list works (57), download blocked (no PDF documents); `certificates.sdk` also hardcodes `applicationId=0` in `getById/download/reissue/retry/revoke`
- `Admin/NotificationChannels` — push channel config empty (email/sms present)

**Frontend wiring findings (independent of data):**
- `Admin/EmailSettings.tsx` exists on disk but is **not registered** in `App.tsx` (orphan page)
- Only 4 pages import SDK functions (VerifyPage, CertificatesTab, CommitteeDetail, MeetingDetail); the other 47 pages call `api.*` directly — the generated SDK is **not the primary client** in practice
- `api/forms.ts` is a parallel hand-written client for the forms module (the forms SDK does not exist)
- `monitoring.sdk.ts` (health/audit/config) is imported by no page
- No SDK function exists for: accreditation, consent templates, document templates, backup, reference-data admin, forgot/reset/verify-email

---

# Section 7 — End-to-End Coverage Matrix (E2E)

The end-to-end matrix (Feature → DB → API → UI → Seed → Status) is the `feature-traceability-matrix.csv` joined with §6. Condensed, demonstrating the strongest and weakest end-to-end paths:

| Coverage tier | Features | Verifiable E2E with canonical data? |
|---------------|----------|-------------------------------------|
| **Fully demonstrable** | Login/register, user/role mgmt, institutions, applications CRUD + workflow, projects, conditions/evidence upload, documents, committee CRUD, meetings (schedule/attendance/vote), reviews (assign/comment/recommend), certificates (issue list), forms, messaging, notifications, reporting/dashboard, public verification, saved searches, backup | Yes — data present end-to-end |
| **Partially demonstrable** | Review scoring (no answers/scores), meeting minutes/quorum (no rows), member profile extras, workflow SLA, communication attachments, push notifications, renewal/closure/amendment requests | Yes for read-side, no for the empty sub-feature |
| **Not demonstrable** | Accreditation, consent, ethics-risk, safety, monitoring, e-signatures, integration | No — zero rows |

---

# Section 8 — Gap Matrix ranked by impact (S8)

## 8.1 Missing feature data (seeds exist but rolled back — 52 empty tables)

| Impact | Feature | Empty tables | Failing seed |
|-------:|---------|--------------|--------------|
| HIGH | Accreditation | 9 `committee.accreditation_*` | `33-accreditation-seed.sql` |
| HIGH | Safety | 13 `safety.*` | `17-safety-data.sql` (+ `90/95/96`) |
| HIGH | Monitoring | 11 `monitoring.*` | `18-monitoring-data.sql` |
| HIGH | Informed Consent | 4 (consent_templates, consent_template_versions, application_consents, consent_review_comments) | `29-informed-consent.sql` |
| HIGH | Ethics Risk | 3 (ethics_risk_assessments, ethics_risk_items, safety.risk_categories) | `28-ethics-risk-assessment.sql` |
| MED | Review scoring | review_answers, review_scores | `08-reviews.sql` |
| MED | Meeting minutes/quorum/agenda | meeting_minutes, quorum_logs, agenda_items | `09-meetings-etc.sql` / `20-remaining-core-data.sql` |
| MED | Committee member profile | member_terms, member_qualifications, member_conflicts, committee_member_roles | `03-committees.sql`, `21-committee-expansion.sql` |
| MED | Certificates PDFs | approval_certificate_documents | runtime-generated; none produced |
| MED | E-signatures | digital_certificates, certificate_revocations | runtime |
| LOW | Workflow SLA | workflow_sla, workflow_variables | `20-remaining-core-data.sql` |
| LOW | Communication attachments | message_attachments | runtime |

## 8.2 Unused seed data (populated but never consumed — 41 tables never touched)

- **`templates.*` (7 tables, seed 55)** — the entire forms-library template dataset is dead. High-impact signal: a feature shipped seeds nobody reads.
- **`reference.*` lookups + `security.*` static sets + `reporting.*` widget config + `system.audit_config`** — populated but repository-unread (some read via direct-SQL routes).
- **`documents.document_access` (3,956 rows)** — full audit-side access log, unread.

## 8.3 Unused APIs / repos / services

- `monitoring.sdk` (getHealth/getAudit/getConfig) — no UI consumer; endpoints work (read populated tables)
- `templates` repository set — `TemplateRendererService`, `TemplateRendererService`-adjacent renderer infra: the renderer has no route and no seeded template is consumed
- `integrations` — 7 of 8 tables empty; only `event_outbox` (30) is real
- `forms` module routes (`/forms/documents/*`, `/forms/instances/:id/approve|return|void`) — instance workflows exist but `FormFillPage` performs no API call (fill flow not wired to the client)

## 8.4 Data exists but feature absent (inverse direction)

- `templates.*` — data seeded, feature (templates renderer/library UI) missing/not consumed
- `documents.approval_certificates` (57) — data present, but the certificate **document** layer (PDF) is absent, so the "issued certificate" user journey stops at the record

---

# Section 9 — Canonical Population Matrix (S9)

For **every one of the 234 tables** the phase at which it must be populated and its current status are in `docs/canonical-population-matrix.csv` (columns: Schema, Table, RowCount, Category, **Phase**, **Status**, ReadBy, WriteBy, Seeds).

**Phases used:**

| Phase | Purpose | Table count |
|-------|---------|------------:|
| INSTALLATION | Populated by seeds at install/restore time | 164 |
| COMMITTEE_WORKFLOW | Populated as committees/meetings/reviews execute | 32 |
| RUNTIME | Populated by application usage or triggers | 38 |

**Status distribution across all 234 tables:**

| Status | Tables | Meaning |
|--------|-------:|---------|
| MISSING_DATA | 98 | 0 rows, not a runtime-category (of which 52 have seeds that rolled back; 36 are read by repos → real gaps) |
| SEEDED_AND_READ | 61 | populated and consumed — healthy |
| SEEDED_UNUSED | 41 | populated but never touched — dead seed data (§8.2) |
| RUNTIME_OK | 24 | 0 rows, runtime-category, expected empty at baseline |
| RUNTIME_ACCUMULATED | 6 | audit/history rows present, unread |
| WRITE_ONLY | 4 | write-target only, read via direct SQL |

**Per-feature population prescription (the three verifiable journeys):**

- **Installation → first login:** `security.*` (users 106, roles 7, institutions 41, departments 127, permissions 32, role_permissions 114), `reference.*` (13 tables), `system.*` (email/sms config), `committee.*` (types 8, roles 5, committees 8), `documents.*` (types 28, lifecycle 10/14, numbering 8, retention 27) — all INSTALLATION and currently present.
- **First application → committee review:** `core.applications` (112), `projects` (121), `application_history` (459), `documents` (1,062), `committee.application_conditions` (15), `review_assignments` (286), `review_forms/questions` (18/54), `scientific_reviews` (73) — present. **Missing for full journey:** `review_answers`, `review_scores`.
- **Committee workflow:** `committee_meetings` (2), `voting_sessions` (1), `votes` (2), `attendance_logs` (4), `meeting_agendas` (1) — present. **Missing:** `agenda_items`, `meeting_minutes`, `quorum_logs`.

---

# Section 10 — Conclusion: can the canonical dataset demonstrate 100% of the system? (S10)

**No.** The canonical Yemen-lineage dataset (Gate-0 baseline, `gate0-baseline-2026-08-04.dump`) demonstrates the implemented system's **core path** completely — authentication, user/role management, institutions, applications, projects, conditions/evidence, documents, committee management, meetings, reviews, certificates, dynamic forms, messaging, workflow, and reporting are all fully readable end-to-end.

**Functional areas that CANNOT be demonstrated with the canonical dataset** (structurally complete, zero rows, seeds rolled back):

1. **Accreditation** — 9 tables, seed `33-accreditation-seed.sql` fails; 15 routes + 6 UI pages empty
2. **Informed consent** — 4 tables, seed `29-informed-consent.sql` fails; 13 routes + 2 UI pages empty
3. **Ethics-risk assessment** — 3 tables, seed `28-ethics-risk-assessment.sql` fails; 7 routes empty
4. **Safety** (risk register, incidents, adverse events, corrective actions) — 13 tables, seeds `17/90/95/96` fail; 8 routes + 4 UI pages empty
5. **Monitoring & compliance** — 11 tables, seed `18-monitoring-data.sql` fails; 6 routes, no UI
6. **E-signatures** — `digital_certificates`, `certificate_revocations` empty; 1 UI page
7. **Integration** — 7 of 8 tables empty; 2 routes

**Additionally incomplete even within the demonstrable core:**
- Review scoring (no answers/scores), meeting minutes/quorum/agenda items, committee member terms/qualifications/conflicts
- Issued certificate PDF documents (approval records exist; generated documents do not)
- Workflow SLA/escalation, communication attachments, push notifications, analytics/KPI snapshots, renewal/closure/amendment request flows

**To reach 100% demonstration** the canonical dataset would need to be extended (or the failing seeds repaired) for the seven empty functional areas plus the partial sub-features above. This is the actionable follow-up implied by the review; no recommendation for *how* is made here, per the READ-ONLY constraint.
