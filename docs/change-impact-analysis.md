# Change Impact Analysis — RC4 Seed Reconstruction

**Status:** Final pre-implementation architecture review — READ-ONLY. No SQL, no migrations, no code, no commits.
**Predecessor contract:** `docs/canonical-seed-specification.md` (Canonical Seed Specification, §1–§10).
**Data provenance:** Gate-0 baseline (`gate0-baseline-2026-08-04.dump`), `backend-route-traceability.csv` (315 leaf routes), `repo_table_map.csv` (292 pairs), `feature-traceability-matrix.csv` (28 features), `seed_dependency_edges.csv` (113 edges), `canonical-population-matrix.csv` (234 tables), `frontend_pages.csv` (51 pages), `sdk_route_map.csv` (19 SDK files / 167 methods).

---

## SECTION 1 — Impact Matrix

For every business domain, the blast radius if its data is reconstructed. Route counts are leaf routes from the traceability inventory; pages from `frontend_pages.csv`.

| # | Domain | Repositories affected | Services affected | Routes affected | Frontend pages affected | Reports | Workflows |
|---|--------|----------------------|-------------------|-----------------|-------------------------|---------|-----------|
| 1 | Users & Security | AuthRepository (17), UsersRepository (12), AuthorizationRepository (6) | AuthService, UsersService, AuthorizationService | 30 (security module) + admin user routes | Login, Register, ForgotPassword, ResetPassword, VerifyEmail, Users/List, Roles/List, Profile, Admin/AdminDashboard | User/role reports (via ReportingService) | Registration flow only |
| 2 | Institutions & Reference Data | AdminRepository (7), SystemRepository (3) | AdminService, SystemService | 3 (reference) + admin reference CRUD (part of 47) | Admin/ReferenceData, Registry/RegistryPage | Reference lookups in dashboards | None |
| 3 | Committees & Membership | CommitteeRepository (8), MemberRepository (10) | CommitteeService | 101 (all committee mounts incl. meetings/reviews/voting/accreditation/consent/ethics) | Committee/Committees, Committee/CommitteeDetail, Committee/MyReviews | Committee activity + member reports | Committee membership feeds review/meeting assignment |
| 4 | Projects | ProjectRepository (7) | ProjectService | 34 (core module, projects+apps split) | Projects/List, Projects/Detail, Projects/Create | Project status reports | Feeds application workflow |
| 5 | Applications | ApplicationRepository (6), CertificateRepository (13), ConditionRepository (8), DocumentRepository (9) | ApplicationService, CertificateService, ConditionService, EvidenceService, FormService | 34 core (11 read empty) + certificates + conditions | Applications/List, Detail, Create, Edit, CertificatesTab | Application status/summary/trend reports | Application workflow (instances 98) |
| 6 | Documents & Lifecycle | DocumentRepository (9), DocumentRenderRepository (15), DocumentLifecycleRepository (4), DocumentTemplateRepository (2), DocumentNumberingRepository (2) | DocumentService, DocumentRenderService, DocumentLifecycleService, ChecksumService | 27 (documents module) | Documents/DocumentsPage, Admin/DocumentTemplates | None (documents feed certs/reports indirectly) | Document lifecycle states (10) + transitions (14) |
| 7 | Reviews | ReviewRepository (17) | CommitteeService | 11 review routes (all read empty: review_answers, review_scores) | Committee/MyReviews, ReviewForms/ReviewFormsPage | Review outcome reports | Review workflow inside application workflow |
| 8 | Meetings | MeetingRepository (18), VotingRepository (7) | CommitteeService | 15 meeting routes (all read empty: agenda_items, meeting_minutes) | Committee/Meetings, Committee/MeetingDetail | Meeting attendance/quorum reports | Meeting workflow |
| 9 | Notifications & Communication | CommunicationRepository (9), NotificationRepository (4) | CommunicationService, NotificationService, EmailChannelService, SmsChannelService, ChannelRouterService, RetryQueueService | 13 (12 read empty: attachments, push config) | Notifications, Messages/MessagesPage, Admin/NotificationChannels, Admin/EmailSettings | Notification/send reports | Notification triggers on workflow events |
| 10 | Safety | SafetyRepository (15) | SafetyService | 14 (all read empty) | Safety/AdverseEvents, Safety/CorrectiveActions, Safety/RiskIncidents, Safety/RiskRegister | Safety/risk reports | Safety review workflow (needs reconstruction) |
| 11 | Monitoring & Compliance | MonitoringRepository (3) | MonitoringService | 6 (monitoring module; reads populated audit/config) | None (monitoring consumed via admin/audit dashboards) | Compliance/monitoring reports | Compliance review workflow |
| 12 | Accreditation | AccreditationCycleRepository (11), AccreditationAssessmentRepository (7), AccreditationConditionRepository (6), AccreditationEvidenceRepository (5), AccreditationDecisionRepository (3) | AccreditationService | 23 (all read empty) | Accreditation/AssessmentsList, ConditionsList, CycleDetail, CyclesList, Dashboard, Evidence | Accreditation cycle reports | Accreditation workflow (51-accreditation-workflow) |
| 13 | Informed Consent | ConsentTemplateRepository (2), ConsentVersionRepository (4), ConsentReviewRepository (3), ApplicationConsentRepository (7) | CommitteeService | 20 consent routes (all read empty) | Admin/ConsentTemplates, Admin/ConsentTemplateVersions | Consent audit reports | Consent review workflow |
| 14 | Ethics Risk | EthicsRiskRepository (8) | CommitteeService | 9 (all read empty) | None (embedded in application/committee pages) | Ethics review reports | Ethics review workflow |
| 15 | Certificates & Public Verification | CertificateRepository (13) | CertificateService | 9 (1 read empty: approval_certificate_documents) | Applications/CertificatesTab, Verify/VerifyPage | Certificate issuance reports | Certificate workflow (needs cert templates) |
| 16 | Templates Engine | **None** — no repository, no route, no page reads `templates.*` | TemplateRendererService (no data dependency) | 0 (feature dead) | Forms/FormLibraryPage, Forms/FormFillPage (backed by `forms.*`, not `templates.*`) | None | None |
| 17 | Dynamic Forms | FormDefinitionRepository (2), FormInstanceRepository (7) | FormService | 19 (forms module) | Forms/FormLibraryPage, Forms/FormFillPage | None | Form instance lifecycle |
| 18 | Reporting | ReportingRepository (6) | ReportingService | 7 (reporting module) | Reports/ReportsPage, Dashboard | **All reports** (definitions 5, widgets 6) | None (reads aggregates) |
| 19 | Integration | IntegrationRepository (2) | IntegrationService | 2 (both read empty integration_logs) | None | None | Event/outbox processing |
| 20 | System Configuration | SystemRepository (3), EmailConfigRepository (2), SmsConfigRepository (2), PushConfigRepository (2) | SystemService, AdminService | 5 (system) + admin config (part of 47) | Admin/BackupSettings, Admin/NotificationChannels, Admin/EmailSettings, System/SavedSearches | None | None |
| 21 | Audit & Data Integrity | (MonitoringRepository reads audit_logs) | MonitoringService, AdminService | 2 (admin audit) + monitoring/audit, monitoring/config | Admin/AdminDashboard | Audit trail reports | None — **never seeded** |
| 22 | Backup / Admin Ops | AdminRepository (7) | BackupService, AdminService | 6 (admin ops) | Admin/BackupSettings, Admin/AdminDashboard | None | None |

**Cross-domain dependency note:** Committee (101), Core (34), Security (30), and Documents (27) dominate route impact. Reconstructing any one of Users, Applications, or Documents has the widest ripple because they are the top FK targets (Section 2).

---

## SECTION 2 — Referential Risk

FK target fan-out (from `ethics_db_schema.sql`): **`security.users` is referenced 66×**, `core.applications` 26×, `core.projects` 10×, `documents.documents` 7×, `workflow.workflows`/`workflow_instances` 6× each, `committee.committee_meetings` 5×, `committee.committee_members` + `security.institutions` 4× each.

### Classified chains

| # | FK chain (source → target) | Risk | Why |
|---|----------------------------|------|-----|
| C1 | Everything → `security.users` (66 refs: documents.uploaded_by, projects, memberships, workflow actions, audit, reviews) | **Critical** | Highest fan-in in the schema. Recreating users breaks any seed that references an old id; id-reassignment cascades across 20+ tables. |
| C2 | `core.applications` ← reviews, conditions, workflow_instances, documents, certificates, safety, consent (26 refs) | **Critical** | Applications is the hub of every downstream feature. Any change to application keys invalidates 7 feature domains. |
| C3 | `core.projects` ← applications, project_* children, documents (10 refs) | **High** | Project must exist before its children (keywords/sites/team/funding) and before applications. |
| C4 | `documents.documents` ← document_versions, document_access, signatures, approvals, evidence links (7 refs) | **High** | Documents cross-reference applications, conditions, meetings, certificates. `documents.lifecycle_state_id NOT NULL` without default (seed 58) breaks inserts at source. |
| C5 | `workflow.workflows` → `workflow_instances` → `workflow_actions`/`history` (6+6 refs) | **High** | Instances require a definition AND a parent entity; actions require an instance. Missing `workflow_sla` currently empty. |
| C6 | `committee.committees` → `committee_members` → member_roles/terms/qualifications/conflicts → meetings | **Medium** | Committee deletion cascades to membership; meetings reference committee + members. |
| C7 | `committee.committee_meetings` → agenda → agenda_items → votes → minutes | **Medium** | 5 refs; minutes/agenda_items empty today. Insert order inside one seed must be exact. |
| C8 | `safety.*` → `core.applications`/`core.projects`/`security.users` + internal (risk_register ← mitigations/incidents) | **High** | 17-safety-data already fails on `safety.mitigation_actions.risk_assessment_id NOT NULL`; internal ordering is broken today. |
| C9 | `monitoring.*` → `monitoring_findings` (2 refs) + projects | **Medium** | Schema fully empty; plans→inspections→findings order must be honored. |
| C10 | `accreditation.*` → workflow_instances + committee + standards → versions → cycles → assessments | **Medium** | 33-accreditation-seed fails today; cycles reference standards that are inserted later in the same file. |
| C11 | `consent.*` → `consent_templates` → `consent_template_versions` → `application_consents` + documents | **Medium** | 29-informed-consent fails on template/version ordering. |
| C12 | `integration.*` → `integration_logs`, `external_systems` (3 refs) | **Low** | Isolated; only IntegrationRepository touches it. |
| C13 | `reference.*` → statuses/lookups referenced by core + committee | **Medium** | Reference rows are business-key anchored; renaming keys breaks every referencing seed. |
| C14 | `security.password_reset_tokens`, `sessions`, `login_audit` → users | **Low** | Runtime tables; if recreated, must point at the **reconstructed** user ids. |

**Mitigation rule:** any reconstruction seed must reference entities by stable natural keys (resolved to ids at insert time via SELECT), never by hardcoded ids — this makes C1/C2/C3 resilient to id drift.

---

## SECTION 3 — Runtime Risk

Runtime-generated data that **must never be recreated** by seeds. Recreating it would fabricate state, corrupt timestamps/attribution, and break audit integrity.

| # | Dataset | Baseline rows | Why it must never be recreated |
|---|---------|--------------:|-------------------------------|
| R1 | `audit.audit_logs` | 22,356 | Trigger-written (system.fn_log_audit); RLS + audit trail integrity depends on genuine `app.user_id`/timestamps. Fabricated rows poison compliance evidence. |
| R2 | `audit.audit_details` | 12,852 | Same as R1; deep-dive detail rows. |
| R3 | `security.login_audit` | 488 | Login provenance; seeding breaks account-security forensics. |
| R4 | `security.sessions` | 372 | Active-session state; stale seeded sessions are a security hole. |
| R5 | `security.password_history` | 95 | Password-rotation enforcement; seeded entries could bypass or lock out. |
| R6 | `security.email_verification_tokens` | 13 | One-time tokens; seeds would be forgeable/expired. |
| R7 | `security.password_reset_tokens` | 0 | Same as R6. |
| R8 | `integration.event_outbox` | 30 | Outbox pattern; must be drained by consumers, not prepopulated. |
| R9 | `communication.notification_logs` | 12 | Delivery state; only produced by channel routers. |
| R10 | `workflow.workflow_actions` | 489 | Action ledger produced by workflow execution; seeding breaks transition history. |
| R11 | `workflow.workflow_history` | 30 | Same as R10. |
| R12 | `reporting.analytics_snapshots` / `kpi_results` / `report_executions` | 0 | Computed by reporting engine; seeds would be stale/misattributed. |
| R13 | `documents.document_access` | 3,956 | Access trail; regenerate from documents via trigger, never seed (already decided in Canonical Spec §6.3). |
| R14 | `ops.seed_tracker` | 78 | Repopulated by the runner itself per execution; bulk-restored rows are fabricated (all `duration_ms=0`). |

**Operational rule:** reconstruction runs on a freshly restored baseline where these tables are **already populated by the application or trigger** or **empty by design**. No seed may write to them (enforced by runner bucket rules and `ops.seed_tracker`).

---

## SECTION 4 — Migration Safety

Independence, rollback points, and irreversible operations for each reconstruction phase (phases per Canonical Spec §10).

| Phase | Executable independently? | Rollback point | Irreversible operations |
|-------|--------------------------|----------------|-------------------------|
| 0 — Contract ratification | Yes (no data) | n/a (document) | None |
| 1 — Seed infrastructure (runner/tracker) | Yes | Restore baseline dump (runner config not applied to DB) | Tracker table rewrite: **old fabricated rows destroyed** (acceptable; spec §6.7) |
| 2 — Reference seed rewrite | Yes, per-file | Per-file reverse DELETE by natural key set | Renaming/removing a reference key permanently orphans referencing seeds |
| 3 — `documents.lifecycle_state_id` default (migration) | No — touches shared schema | Restore baseline dump | Column default change is not auto-reversible in place |
| 4 — Core business seeds (users→inst→committee→project→app→doc) | Yes per layer | Restore baseline; DELETE by seed-scope tag | Reassigning user/application ids (C1/C2) if not keyed |
| 5 — Reconstruct 5 failing chains (safety/monitoring/ethics/consent/accreditation) | Yes per chain | Restore baseline; per-chain delete | Inserting into currently-empty tables then discovering a broken FK mid-chain requires truncation |
| 6 — Committee scenario data (meetings/reviews/certs/notifications) | Yes | Restore baseline; per-scenario delete | None beyond data |
| 7 — Demo + pilot | Yes | Restore baseline | None (additive) |
| 8 — Dead-data removal (`templates.*`, fabricated runtime rows) | Yes | Restore baseline | **Deleting `templates.*` rows is irreversible** unless baseline is restored; schema stays, data goes |
| 9 — Verification | Yes (read-only) | n/a | None |
| 10 — Baseline freeze (new dump) | Yes | Keep prior dump | **Overwriting the Gate-0 baseline dump** — always write a new versioned dump, never replace |

**Guarantees:**
- **Rollback point of last resort for every phase:** `scripts/reset-dev-db.ps1` restoring `gate0-baseline-2026-08-04.dump` (deterministic, verified).
- **Irreversible operations** are limited to: (1) tracker table rewrite (Phase 1), (2) reference-key changes (Phase 2), (3) column-default migration (Phase 3), (4) `templates.*` data deletion (Phase 8), (5) baseline dump overwrite (Phase 10). Each is gated in Section 8.

---

## SECTION 5 — Validation Strategy

Pre-, execution-, post-, and rollback-validation for every phase.

| Phase | Pre-validation | Execution validation | Post-validation | Rollback validation |
|-------|---------------|----------------------|-----------------|---------------------|
| 1 — Infra | Confirm runner runs on current baseline; tracker readable | Each seed reports rows+duration+checksum; `ON_ERROR_STOP=1`; DAG order enforced | Tracker shows real per-file records; suite 0 failures (A1/A3) | Restore baseline; confirm tracker rebuilt empty & runner re-initializes |
| 2 — Reference | Dependency edges all satisfied (seed_dependency_edges check); keys unique | Idempotent upsert; count in declared range; no silent zero-row | Reference tables ≥ declared floor; re-run produces identical counts (A2) | Restore baseline; confirm no orphaned referencing keys |
| 3 — Migration | Schema dump diff clean; no dependent seeds applied yet | Single transaction; `lifecycle_state_id` default applied | Document insert without explicit state succeeds; audit trigger intact | Restore baseline; confirm schema back to pre-migration state |
| 4 — Core | Layer order per DAG; user/institution/app keyed sets defined | Per-layer count assertions; FK checks enabled | Zero empty-read routes on core path (A4 partial); RLS matrix passes for seeded users (A7) | Restore baseline; confirm no partial user/app rows |
| 5 — Failing chains | Per-chain DAG validated (spec §4 Layers 10–14); referenced entities exist | Transaction-wrapped; row counts reported per file | All 7 blocked features have data ≥ spec §3 minimums; feature proof queries pass (A5) | Restore baseline; confirm empty chains fully rolled back, not half-inserted |
| 6 — Scenario | Meetings/reviews reference existing apps+committees | Count assertions; minutes/agenda non-empty | S5 empty-read count 163→0 (A4); demo journeys complete (A9) | Restore baseline; confirm no orphaned scenario rows |
| 7 — Demo/Pilot | Canonical counts defined; no overlap with core keys | Idempotent apply | Two independent restores → identical counts (A8) | Restore baseline; confirm demo removable without touching core |
| 8 — Dead data | Snapshot of `templates.*` + runtime rows before deletion | Deletion only in approved scope | `templates.*` = 0 rows; runtime tables intact; A6 passes | **Restore baseline** (the only reversible path for this phase) |
| 9 — Verification | A1–A11 checklist prepared | Full suite + E2E run | All acceptance criteria green; feature proof green | n/a (read-only) |
| 10 — Freeze | New dump name versioned; prior dump intact | `pg_dump` with RLS context; checksums recorded | Restore-from-new-dump yields identical counts (A8) | Prior dump restored → original Gate-0 state |

---

## SECTION 6 — Feature Regression Matrix

Ranked by probability × impact. P = likelihood of regression during reconstruction, I = business impact if it regresses.

| # | Feature | P | I | Rank | Regression vector |
|---|---------|---|---|------|-------------------|
| 1 | Authentication & Registration | High | Critical | **1** | User/role rebuild (C1) breaks login if keys/hashes change; RLS on register (33-fix) depends on seeded user rows |
| 2 | Applications | High | Critical | **2** | Hub table (C2); re-sequencing app ids breaks documents/reviews/workflow/certs |
| 3 | User/Role/Permission Management | High | High | 3 | Role/permission matrix + user_roles must stay in lock-step with code constants |
| 4 | Documents & Lifecycle | High | High | 4 | lifecycle_state_id migration + FK chains (C4); existing 1,062 docs must survive |
| 5 | Workflow Engine | Medium-High | Critical | 5 | States/transitions are business-key anchored (spec §7 R1); instances (98) depend on both defs and apps |
| 6 | Committee Reviews | High | High | 6 | Currently empty (answers/scores); new data must match review form/question ids |
| 7 | Committee Meetings | High | Medium | 7 | Currently empty (agenda/minutes); quorum logic is strict |
| 8 | Projects | Medium | High | 8 | Children (keywords/sites/team) must follow parent; status history (93) |
| 9 | Conditions & Evidence | Medium-High | High | 9 | Evidence DELETE policy matrix (RULE 12) depends on exact state combos |
| 10 | Certificates & Public Verification | Medium | High | 10 | approval_certificate_documents empty; `certificates.sdk` hardcodes `applicationId=0` (pre-existing defect surfaced) |
| 11 | Communication / Notifications | Medium | Medium | 11 | Attachments + push config empty today |
| 12 | Reporting & Dashboards | Medium | Medium | 12 | Report defs/widgets are reference; KPI computed — rebuild of apps changes aggregates |
| 13 | Safety | High (chain broken) | Medium | 13 | Seed 17 fails outright; any reconstruction must succeed on first pass |
| 14 | Monitoring | High (chain broken) | Low | 14 | Fully empty; routes read populated audit/config so no crash, but feature absent |
| 15 | Accreditation | High (chain broken) | Low | 15 | 23 routes empty; workflow def exists (51) |
| 16 | Consent | High (chain broken) | Low | 16 | 20 routes empty |
| 17 | Ethics Risk | High (chain broken) | Low | 17 | 9 routes empty |
| 18 | E-Signatures | Medium | Low | 18 | document_signatures empty; signing flow untested |
| 19 | Integration | Low | Low | 19 | Isolated; 2 routes |
| 20 | Dynamic Forms | Low | Medium | 20 | forms.* populated; low risk |
| 21 | Saved Searches / Admin Ops / System Config | Low | Low | 21 | Runtime-only or stable reference |
| 22 | Audit & Data Integrity | Medium | High | 22 | If audit tables are touched, integrity is permanently compromised |
| 23 | Templates Engine | **None** | None | 23 | Dead data; removal cannot regress any feature (spec §6.1) |

**Top-3 watch list:** (1) Authentication/Users, (2) Applications, (3) Workflow — all share the C1/C2/C5 FK hubs and the business-key-anchoring rule (§7 R1) is the primary defense.

---

## SECTION 7 — Data Preservation Matrix

Per-table disposition for reconstruction. **Keep** = preserve Gate-0 rows untouched · **Replace** = delete+recreate (dead/fabricated) · **Merge** = keep + add reconstructed rows · **Generate** = regenerate deterministically · **Never touch** = application/trigger-owned.

| Schema | Tables | Disposition | Rationale |
|--------|--------|-------------|-----------|
| `reference.*` (statuses/lookups, 14 populated) | application_statuses, document_statuses, review_statuses, workflow_statuses, committee_decision_types, vote_types, notification_statuses, lookup_categories/values, academic_titles, professions_registry, priority_levels, risk_levels | **Keep** | Canonical reference universe; only add missing keys during Phase 2 if a route requires them |
| `reference.*` empty | institutions_registry, licenses_registry | **Merge** (Phase 4) | Empty; needed by reference.sdk (getInstitutions/getProfessions/getLicenses) |
| `security.users` (106) + profiles, user_roles, role_permissions, roles (7), permissions (32), departments (127) | | **Keep** (canonical) + **Merge** (blocked-feature principals in Phase 5) | Users are the 66× FK hub; never replace ids, only add |
| `security.sessions`, `login_audit`, `password_history`, `email_verification_tokens`, `password_reset_tokens`, `certificate_revocations`, `security_events`, `role_delegations`, `approval_limits`, `policy_*` | | **Never touch** | Runtime (R3–R7) or empty-by-design |
| `security.api_keys`, `access_policies`, `responsibility_types`, `user_responsibilities`, `institutions`, `institution_types` | | **Keep** | Canonical |
| `core.projects` (121) + project_keywords/sites/funding/team/status_history | | **Keep** + **Generate** (keywords/history deterministic) | Canonical; generated bulk regenerable |
| `core.applications` (112) + application_versions (34), application_history (459), application_amendments (7), application_conditions (15) | | **Keep** + **Merge** (Phase 6: conditions) | Hub (C2); history is generated |
| `core.*` empty | amendment_requests, application_checklists, application_consents, application_sections, application_validations, closure_requests, renewal_requests, research_population_links, project_attachments, project_site_investigators, project_tags, project_versions | **Merge** (Phase 5/6, minimal per spec §3) | Needed to demonstrate consent/renewal/closure flows |
| `documents.documents` (1,062) + document_versions (36), document_types (28), lifecycle states/transitions | | **Keep** + **Merge** (Phase 5/6 evidence/signatures/approvals) | Canonical; lifecycle_state_id migration is Phase 3 |
| `documents.document_access` (3,956) | | **Generate / Never touch** | Derived trail (R13); regenerate from docs, never seed |
| `documents.document_approvals`, `document_signatures` (2) | | **Merge** (Phase 6) | Currently near-empty |
| `committee.committees` (8), committee_members (57), committee_types (8), committee_roles (5) | | **Keep** + **Merge** (member_roles/terms/qualifications/conflicts) | Canonical |
| `committee.committee_meetings` (2), meeting_agendas (1), agenda_items (0), meeting_minutes (0), attendance_logs (4), votes (2), voting_sessions (1), quorum_logs (0) | | **Keep** + **Merge** (Phase 6 minimal) | Partially empty; needs agenda/minutes/quorum |
| `committee.review_forms` (18), review_questions (54), scientific_reviews (73), ethics_reviews (67), review_assignments (286), review_comments (3), review_recommendations (3) | | **Keep** | Canonical and populated |
| `committee.review_answers` (0), review_scores (0) | | **Merge** (Phase 6 — critical gap) | S5: 11 review routes read empty |
| `committee.ethics_reviews` (67) | | **Keep** | Canonical |
| `committee.ethics_risk_assessments`, ethics_risk_items (0) | | **Merge** (Phase 5) | Empty chain |
| `committee.consent_*` (0) | templates, template_versions, review_comments | **Merge** (Phase 5) | Empty chain |
| `committee.accreditation_*` (0) | standards, standard_versions, cycles, assessments, assessment_items, conditions, evidence, decisions, cycle_metrics | **Merge** (Phase 5) | Empty chain |
| `safety.*` (0) | 12 tables | **Merge** (Phase 5 — critical gap) | Empty chain; seed 17 must be rebuilt |
| `monitoring.*` (0) | 10 tables | **Merge** (Phase 5) | Empty chain; routes read audit/config so low regression but feature missing |
| `workflow.workflows` (1), workflow_states (14), transitions (32) | | **Keep** | Installation reference (business-keyed) |
| `workflow.workflow_instances` (98), workflow_actions (489), workflow_history (30) | | **Keep** (existing) — **Never touch** (actions/history) | Actions/history are runtime (R10/R11) |
| `workflow.workflow_sla` (0) | | **Merge** (Phase 6) | 4 workflow routes read empty |
| `communication.notifications` (84), notification_templates (8), notification_logs (12) | | **Keep** (notifications/templates); **Never touch** (logs R9) | Canonical |
| `integration.event_outbox` (30) | | **Never touch** (R8) | Outbox runtime |
| `integration.*` empty (external_systems, webhooks, etc.) | | **Merge** (Phase 5, demo-minimal) | Feature demo |
| `templates.*` (90 rows, 16 tables) | | **Replace → empty** (Phase 8) | Dead data (spec §6.1) |
| `reporting.report_definitions` (5), dashboard_widgets (6) | | **Keep** | Reference |
| `reporting.analytics_snapshots`/kpi_results/report_executions | | **Never touch** (R12) | Computed |
| `system.*` (config, business_rules) | | **Keep** | Installation |
| `audit.*` (35,208) | | **Never touch** (R1/R2) | Trigger-owned |
| `ops.seed_tracker` (78) | | **Replace** (Phase 1) | Runner-owned |

---

## SECTION 8 — RC4 Execution Safety Gates

Mandatory gates **before** each reconstruction milestone. A gate failure = stop and restore baseline.

### Before Reference reconstruction (Phase 2)
1. Runner + tracker (Phase 1) certified: DAG order, row-count reporting, `ON_ERROR_STOP` all green on a **read-only replay** against the current baseline.
2. Dependency graph (`seed_dependency_edges.csv`) re-verified against the Phase-2 target key sets — no edge points at a key scheduled for removal.
3. Reference keys frozen: adding/renaming a key requires sign-off (C13).

### Before Core reconstruction (Phase 4)
4. Phase 3 migration applied & verified (document inserts succeed without explicit lifecycle_state).
5. User/institution/application keyed sets approved (canonical identity, not ids).
6. FK-enabled sanity check: referencing seed files (52 seeded-but-empty tables) listed and their Phase-5 chain planned.
7. RLS smoke test passes with Phase-2 reference data only.

### Before Scenario reconstruction (Phase 5/6)
8. The five broken chains (17/18/28/29/33) have an approved per-chain DAG per spec §4 Layers 10–14.
9. Runtime tables asserted untouched (Section 3 list) — audit row count unchanged before and after scenario apply.
10. Feature-proof queries for the 7 blocked features defined and failing **green-precondition** (query returns 0 rows) before apply.

### Before Demo reconstruction (Phase 7)
11. Canonical counts ratified (spec §2 recommended column) and non-overlapping with core keys.
12. Two prior independent baseline restores produced identical counts (A8 pre-check).
13. Demo removable: applying demo, then deleting only demo-scoped rows, returns to core state.

### Before Baseline generation (Phase 10)
14. A1–A11 acceptance criteria all green on a fresh restore + full suite.
15. S5 empty-read count = 0 (excluding runtime-expected `password_reset_tokens`).
16. Dead-data audit green: `templates.*` = 0, runtime tables intact (A6).
17. New dump written to a **versioned filename** (never overwrite Gate-0); checksums recorded; prior dump remains restorable.

---

## SECTION 9 — Final Risk Assessment

| Dimension | Assessment |
|-----------|------------|
| **Overall Risk** | **HIGH.** Reconstruction touches the schema's two largest FK hubs (`security.users` 66 refs, `core.applications` 26 refs) plus 163 routes that currently read empty tables. However, risk is well-bounded by a deterministic baseline restore, per-phase independence, and key-based (never id-based) seeding. |
| **Highest Risk** | **Phase 5 — reconstructing the five broken seed chains.** Today they all fail; any successful run is the first. Mitigation: per-chain DAG, transaction-wrapping, row-count assertions. |
| **Highest Uncertainty** | **Generated data** (keywords 372, application_history 459, document_access 3,956) and the **`documents.lifecycle_state_id` migration** — both have never been exercised successfully end-to-end. |
| **Highest Dependency** | **`security.users`** (66 FK targets) → then `core.applications` (26) → then `documents.documents` (7). Every other domain depends transitively on these three. |
| **Most Sensitive Tables** | (1) `audit.audit_logs`/`audit_details` (35,208 rows — integrity, never touch), (2) `security.users` (hub), (3) `core.applications` (hub), (4) `security.sessions`/`login_audit` (security), (5) `workflow.workflow_actions`/`workflow_history` (runtime ledger), (6) `ops.seed_tracker` (trust anchor). |

---

## SECTION 10 — Final Executive Decision

**Is the project safe to begin reconstruction?**

**NO — not yet.**

### Remaining blockers

1. **Seed-tracker trust is broken.** All 78 entries report identical `applied_at` and `duration_ms=0` (bulk-restored, never executed); failed seeds are recorded as `success`. No reconstruction can be measured, audited, or gated until Phase 1 (runner + real tracker) is built — this is the hard prerequisite.
2. **The five broken seed chains have no working implementation.** 17/18/28/29/33 (and 90/95/96) still fail on dependency/`NOT NULL` violations; the affected 7 features have zero rows and 82 routes reading empty tables.
3. **Reference/core seeds are non-idempotent and business-key-anchored.** 7/12 reference seeds carry silent-no-op risk, 5/12 are non-idempotent; all 15 scenario seeds carry silent-no-op risk. Reconstructing on this base reproduces the current failure class.
4. **No dependency engine.** Ordering is filename-based with known cross-version bugs (06 depends on 10); the spec §4 DAG is designed but not implemented.
5. **`documents.lifecycle_state_id NOT NULL` without default** blocks document reseeding (Phase 3 migration not yet approved).
6. **Dead-data disposition unapproved.** `templates.*` (90 rows, no consumer), fabricated runtime rows (sessions 372, login_audit 488, password_history 95, tokens 13, outbox 30), and `document_access` (3,956) seeding are not yet cleared for removal.
7. **Generated-data strategy undefined** — deterministic generator for keywords/history/access trails does not exist.
8. **Test fixtures for the blocked features undefined** — A2/A7/A9 cannot be satisfied without them.
9. **The 41 SEEDED_UNUSED tables** (populated but never read) lack a ratified keep/remove decision per table (Section 7 resolves this analysis, but the sign-off is pending).

### Recommended execution sequence (once blockers cleared)

1. Phase 0 — Ratify this analysis + Canonical Seed Specification (this review is the approval gate).
2. Phase 1 — Seed infrastructure: DAG runner + real per-file tracker + row-count assertions + bucket boundaries.
3. Phase 2 — Reference seed rewrite (idempotent, keyed, guarded).
4. Phase 3 — `documents.lifecycle_state_id` default migration (approved, coordinated).
5. Phase 4 — Core business seeds (users → institutions → committees → projects → applications → documents) with generated data.
6. Phase 5 — Reconstruct the five broken chains (safety, monitoring, ethics risk, consent, accreditation) per Layers 10–14.
7. Phase 6 — Committee scenario data (meetings/agenda/minutes/quorum, review answers/scores, certificates, conditions evidence, notifications).
8. Phase 7 — Canonical demo (Yemen lineage at spec §2 recommended counts) + pilot separation.
9. Phase 8 — Dead-data removal (`templates.*`, fabricated runtime rows, `document_access` seeders, Era-1 remnants).
10. Phase 9 — Full verification (A1–A11 + S5 empty-read=0 + RLS matrix + demo journeys).
11. Phase 10 — Versioned baseline freeze (new dump; Gate-0 dump preserved).

The sequence is identical to Canonical Spec §10. **Phase 1 completion is the go/no-go gate** — no data reconstruction should begin before the runner and tracker prove they can execute, measure, and roll back.

---

*End of Change Impact Analysis. READ-ONLY deliverable — no SQL, no migrations, no code, no commits.*
