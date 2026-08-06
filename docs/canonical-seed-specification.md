# Canonical Seed Specification — RC4

**Status:** Architectural contract — READ-ONLY analysis. No SQL, no migrations, no code changes.
**Author:** Architecture Planning Stage (final stage before implementation)
**Provenance:** All counts are from the Gate-0 baseline (`backend/backups/gate0-baseline-2026-08-04.dump`, restore-verified) and the prior deliverables:
`database-population-audit.md`, `seed-coverage-matrix.md` + `.csv`, `architecture-normalization-review.md` + tables/seeds, `feature-traceability-review.md` + matrices.

## Definitions (permanent)

| Term | Meaning |
|------|---------|
| Reference Seed | Idempotent population of reference/master data (statuses, types, workflow states, document types). |
| Core Business Seed | Idempotent population of the primary object graph (institutions, users, committees, projects, applications). |
| Scenario Seed | Population of a business scenario spanning multiple features (e.g. a full safety incident lifecycle). |
| Demo Seed | Named, removable dataset used for demonstration (Yemen lineage). |
| Pilot Seed | Dataset for pilot/UAT deployments; separate from demo. |
| Test Fixture | Dataset for automated tests only; never shipped to any deployment. |
| Generated Data | Procedurally produced rows (keywords, history, access trails) with a deterministic generator. |
| Runtime Data | Rows created only by application code/triggers (audit, sessions, tokens, outbox). Never seeded. |

**Canonical dataset:** Yemen lineage (Era-2), defined in Section 2. The KSU/Era-1 lineage is retired.

---

## SECTION 1 — Functional Population Priority

Levels: **MI** Mandatory for installation · **MFL** Mandatory for first login · **MAW** Mandatory for administrator workflow · **MRW** Mandatory for researcher workflow · **MCW** Mandatory for committee workflow · **MRP** Mandatory for reporting · **DO** Demo only · **OP** Optional · **NS** Never seed

| # | Feature | Priority | Rationale |
|---|---------|----------|-----------|
| 1 | Authentication & Registration | MI | Base accounts + password hashes must exist before first boot. |
| 2 | Password Recovery | MI | No scenario data; tokens are runtime. Needs only base users. |
| 3 | User / Role / Permission Management | MAW | Role/permission/reference rows are install data; user rows belong to admins. |
| 4 | Institutions & Reference Data | MI | Countries, institution types, statuses, lookups are prerequisites for every screen. |
| 5 | Applications | MRW | Applicant scenario data (pre-submission / in-review / approved). |
| 6 | Projects | MRW | Same applicant path. |
| 7 | Conditions & Evidence | MRW | Tied to applications; needed to exercise evidence upload/delete matrix. |
| 8 | Certificates & Public Verification | MRW | Verification page requires real certificate + hash. |
| 9 | Document Management & Lifecycle | MRW / MCW | Uploads, versions, approvals, retention. |
| 10 | E-Signatures | OP | Structurally complete, 0 rows. Seed a minimal signing flow only if demoed. |
| 11 | Committee Management | MFL / MAW | Committee + membership is a prerequisite for any workflow. |
| 12 | Committee Meetings | MCW | Agenda, minutes, quorum, votes. |
| 13 | Committee Reviews | MCW | Review forms/questions exist as install data; answers/scores are scenario. |
| 14 | Informed Consent | DO | Structurally complete, 0 rows; consent templates are OP/MI, scenarios are demo. |
| 15 | Ethics Risk Assessment | DO | 0 rows; needs reconstruction of the seed chain. |
| 16 | Accreditation | DO | 0 rows; standards = reference (MI), cycles/assessments = demo. |
| 17 | Safety | DO | 0 rows; risk categories = reference (MI), incidents/reports = demo. |
| 18 | Monitoring & Compliance | DO | 0 rows; plans/inspections/findings = demo. |
| 19 | Workflow Engine | MI | States/transitions/definitions are install reference; instances are runtime/scenario. |
| 20 | Communication | MCW | Notification templates = MI; notifications = scenario. |
| 21 | Dynamic Forms | MI | `review_forms`/`review_questions` are the form library for reviews. |
| 22 | Templates Engine (forms library) | **NS** | `templates.*` has **no consumer** (no repo, no route, no page). Dead until a consumer is built. |
| 23 | Reporting & Dashboards | MRP | Definitions/widgets = MI; KPI snapshots = runtime/generated. |
| 24 | System Configuration | MI | `system_config` must ship with defaults. |
| 25 | Audit & Data Integrity | **NS** | `audit_logs`/`audit_details`/`login_audit` are trigger-written only. |
| 26 | Integration | DO | `event_outbox` is runtime; external systems/webhooks = demo only. |
| 27 | Saved Searches | MRW | Personal searches are user-owned; demo rows optional. |
| 28 | Admin Operations (backup) | MAW | Operational; no data required. |

### Minimum population per level (guarantee)

| Level | Must contain |
|-------|--------------|
| MI | 7 roles, 32 permissions, role-permission matrix, status/lookup universe, workflow states (14) + transitions (32) + definitions, document types (28), committee types (8)/roles (5), review forms (18)/questions (54), `system_config` defaults, notification templates (8), report definitions (5)/widgets (6), 1 super-admin + 1 institution-admin account. |
| MFL | 6 logins covering the role matrix (super-admin, institution-admin, researcher, chair, member, reviewer) on a working institution + committee. |
| MAW | User CRUD targets, committee membership, reference-data edit targets. |
| MRW | 1 researcher with projects/applications/documents/conditions + evidence + certificate. |
| MCW | 2 committees with meetings, reviews, answers, scores, votes, minutes, notifications. |
| MRP | Dashboard widgets + ≥2 KPI results computable from canonical data. |
| DO | One end-to-end scenario per blocked feature (Safety, Monitoring, Accreditation, Consent, Ethics Risk, E-Signatures, Integration). |
| NS | Never seed: `templates.*`, audit/log tables, sessions, tokens, outbox. |

---

## SECTION 2 — Canonical Dataset Definition

The official RC4 dataset = **Yemen lineage (Era-2)** at the recommended counts below, plus reconstructed data for the seven currently-empty features. Counts marked ★ are the verified Gate-0 baseline; counts marked ◄ are **must be added** (currently 0). Runtime-accumulated rows (audit 35,708, sessions, login audit) are excluded from dataset definition — they are produced by the application, never by seeds.

### Users & Security

| Entity | Min | Recommended | Max useful |
|--------|----:|------------:|-----------:|
| institutions | 3 | 41 ★ | 60 |
| departments | 10 | 127 ★ | 200 |
| users | 12 (role matrix) | 106 ★ | 200 |
| user_profiles | 12 | 101 ★ | 200 |
| roles | 7 ★ | 7 ★ | 7 |
| permissions | 32 ★ | 32 ★ | 32 |
| role_permissions | full matrix | 114 ★ | full matrix |
| user_roles | ≥14 | 107 ★ | 250 |
| user_responsibilities | 4 | 16 ★ | 40 |
| api_keys | 0 | 0 | 2 (demo) |

### Institutions & Reference Data

| Entity | Min | Recommended | Max useful |
|--------|----:|------------:|-----------:|
| institution_types | 4 ★ | 4 ★ | 4 |
| reference.lookup_categories / lookup_values | 3 / 11 | 3 / 11 ★ | 5 / 20 |
| application_statuses | 14 ★ | 14 ★ | 14 |
| document_statuses | 4 ★ | 4 ★ | 4 |
| review_statuses | 4 ★ | 4 ★ | 4 |
| workflow_statuses | 3 ★ | 3 ★ | 3 |
| committee_decision_types / vote_types | 5 / 4 ★ | 5 / 4 ★ | same |
| notification_statuses | 7 ★ | 7 ★ | 7 |
| academic_titles / professions_registry | 11 / 10 ★ | 11 / 10 ★ | same |
| research_categories / vulnerable_populations / risk_classifications | 8 / 6 / 4 ★ | same | same |
| document_types / classifications / signature_types | 28 / 4 / 9 ★ | same | same |

### Committees

| Entity | Min | Recommended | Max useful |
|--------|----:|------------:|-----------:|
| committee_types | 8 ★ | 8 ★ | 8 |
| committees | 2 | 8 ★ | 12 |
| committee_roles | 5 ★ | 5 ★ | 5 |
| committee_members | 12 | 57 ★ | 100 |
| committee_member_roles | ◄ 4 | 8 | 20 |
| member_terms / qualifications / conflicts | ◄ 2 each | 6 each | 15 each |

### Projects

| Entity | Min | Recommended | Max useful |
|--------|----:|------------:|-----------:|
| projects | 3 (one per lifecycle phase) | 121 ★ | 150 |
| project_keywords | 6 | 372 ★ | 500 |
| project_sites | 3 | 93 ★ | 120 |
| project_funding_sources | 3 | 93 ★ | 120 |
| project_team_members | 6 | 141 ★ | 200 |
| project_status_history | 3 | 93 ★ | 120 |
| project_attachments | ◄ 3 | 6 | 12 |
| project_tags | 0 | ◄ 5 | 10 |

### Applications

| Entity | Min | Recommended | Max useful |
|--------|----:|------------:|-----------:|
| applications | 3 (pre-submission / in-review / approved) | 112 ★ (28×APP-2025 + 84×APP-2026) | 150 |
| application_versions | 3 | 34 ★ | 60 |
| application_history | 3 | 459 ★ (generated) | 700 |
| application_amendments | 0 | 7 ★ | 15 |
| application_conditions | 3 | 15 ★ | 40 |
| application_consents | ◄ 3 | 6 | 12 |
| renewal_requests / closure_requests / amendment_requests | ◄ 1 each | 2 each | 5 each |

### Documents

| Entity | Min | Recommended | Max useful |
|--------|----:|------------:|-----------:|
| documents | 15 | 1,062 ★ | 1,500 |
| document_versions | 15 | 36 ★ | 100 |
| document_access | 0 (regenerate) | regenerated | regenerated |
| document_signatures | ◄ 2 | 6 | 10 |
| document_approvals | ◄ 2 | 6 | 10 |
| lifecycle states / transitions | 10 / 14 ★ | same | same |

### Reviews

| Entity | Min | Recommended | Max useful |
|--------|----:|------------:|-----------:|
| review_forms | 18 ★ | 18 ★ | 18 |
| review_questions | 54 ★ | 54 ★ | 54 |
| scientific_reviews | 3 | 73 ★ | 90 |
| ethics_reviews | 3 | 67 ★ | 90 |
| review_assignments | 3 | 286 ★ | 350 |
| review_answers | ◄ 60 (one per answered assignment) | 286 ★ | 350 |
| review_scores | ◄ 60 | 286 | 350 |
| review_comments | 3 ★ | 3 ★ | 20 |
| review_recommendations | 3 ★ | 3 ★ | 10 |

### Meetings

| Entity | Min | Recommended | Max useful |
|--------|----:|------------:|-----------:|
| committee_meetings | 3 (planning / in-review / decision) | 6 | 12 |
| meeting_agendas | 1 | 6 ★ | 12 |
| agenda_items | ◄ 6 | 24 | 48 |
| meeting_minutes | ◄ 3 | 6 | 12 |
| attendance_logs | 3 | 4 ★ | 12 |
| voting_sessions | 1 ★ | 3 | 6 |
| votes | 2 ★ | 12 | 24 |
| quorum_logs | ◄ 3 | 6 | 12 |

### Notifications & Communication

| Entity | Min | Recommended | Max useful |
|--------|----:|------------:|-----------:|
| notification_templates | 8 ★ | 8 ★ | 8 |
| notifications | 5 | 84 ★ | 120 |
| notification_logs | 0 (runtime) | 12 ★ | runtime |
| communication attachments | ◄ 2 | 4 | 8 |

### Safety ◄ (currently 0 rows)

| Entity | Min | Recommended | Max useful |
|--------|----:|------------:|-----------:|
| risk_categories | 5 | 8 | 10 |
| risk_assessments | 3 | 6 | 10 |
| risk_register | 3 | 8 | 12 |
| safety_reports | 3 | 6 | 10 |
| adverse_events | 2 | 4 | 6 |
| serious_adverse_events | 1 | 2 | 3 |
| corrective_actions / mitigation_actions | 2 / 2 | 4 / 4 | 8 / 8 |
| risk_incidents | 2 | 4 | 6 |
| safety_committee_reviews | 1 | 2 | 4 |
| safety_followups | 2 | 3 | 6 |

### Monitoring ◄ (currently 0 rows)

| Entity | Min | Recommended | Max useful |
|--------|----:|------------:|-----------:|
| monitoring_plans | 2 | 4 | 6 |
| inspections | 3 | 5 | 8 |
| inspection_reports | 3 | 5 | 8 |
| monitoring_findings | 4 | 8 | 12 |
| deviations | 2 | 3 | 5 |
| protocol_violations | 2 | 3 | 5 |
| corrective_actions / preventive_actions | 2 / 2 | 3 / 3 | 6 / 6 |
| compliance_reviews | 2 | 3 | 5 |
| monitoring_visits | 2 | 3 | 5 |

### Accreditation ◄ (currently 0 rows)

| Entity | Min | Recommended | Max useful |
|--------|----:|------------:|-----------:|
| accreditation_standards | 3 | 6 | 10 |
| accreditation_standard_versions | 3 | 6 | 10 |
| accreditation_cycles | 1 | 2 | 3 |
| accreditation_assessments | 3 | 4 | 6 |
| accreditation_assessment_items | 6 | 12 | 20 |
| accreditation_conditions | 2 | 3 | 6 |
| accreditation_evidence | 3 | 6 | 10 |
| accreditation_decisions | 1 | 2 | 3 |
| accreditation_cycle_metrics | 1 | 2 | 3 |

### Consent ◄ (currently 0 rows)

| Entity | Min | Recommended | Max useful |
|--------|----:|------------:|-----------:|
| consent_templates | 3 | 5 | 8 |
| consent_template_versions | 4 | 7 | 10 |
| consent_review_comments | 3 | 5 | 10 |
| core.application_consents | 3 | 6 | 12 |

### Templates Engine

| Entity | Min | Recommended | Max useful |
|--------|----:|------------:|-----------:|
| templates.* (16 tables, 12 templates, 13 versions, 44 variables, 5 partials, 12 categories, 90 rows) | **0** | **0** | **0** |

**Dead by decision** — no consumer exists. Do not include in the canonical dataset (see Section 6).

### Workflow

| Entity | Min | Recommended | Max useful |
|--------|----:|------------:|-----------:|
| workflows | 1 ★ | 1 ★ | 2 |
| workflow_states / transitions | 14 ★ / 32 ★ | same | same |
| workflow_instances | 3 | 98 ★ | 150 |
| workflow_actions | 3 | 489 ★ | 700 |
| workflow_history | 3 | 30 ★ | 80 |
| workflow_sla | ◄ 3 | 6 | 10 |
| workflow_comments | 0 | ◄ 3 | 10 |

### Reporting

| Entity | Min | Recommended | Max useful |
|--------|----:|------------:|-----------:|
| report_definitions | 5 ★ | 5 ★ | 5 |
| dashboard_widgets | 6 ★ | 6 ★ | 6 |
| analytics_snapshots / kpi_results / report_executions | 0 (runtime) | runtime | runtime |

### Integration ◄

| Entity | Min | Recommended | Max useful |
|--------|----:|------------:|-----------:|
| external_systems | 1 | 2 | 3 |
| webhooks | 0 | 1 | 2 |
| event_bus_config / event_subscriptions | 0 | 2 | 4 |
| event_outbox | **0 (runtime only — must be empty after seed)** | runtime | runtime |

---

## SECTION 3 — Minimal Functional Dataset

Smallest dataset capable of demonstrating **100% of the implemented system** (all 28 features, including the 7 currently data-missing and the partial gaps). This is a hard lower bound — no feature may ship with less.

| Domain | Minimal content | Demonstrates |
|--------|-----------------|--------------|
| Users | 6 logins spanning the role matrix + full role/permission matrix (7/32/114) | Auth, Registration, Password Recovery, User/Role/Permission Mgmt, Saved Searches, Admin backup |
| Institutions | 3 institutions + 1 institution-type set + full lookups/statuses | Institutions & Reference Data |
| Committees | 2 committees + 12 members + types/roles + member_roles | Committee Management, Workflow Engine (definitions) |
| Projects | 3 projects across lifecycle + keywords/sites/funding/team | Projects |
| Applications | 3 applications (pre-submission / in-review / approved) + versions + history + 1 amendment | Applications, Dynamic Forms |
| Documents | 15 docs (3 per application) + 2 signatures + 2 approvals + versions | Document Management & Lifecycle, E-Signatures |
| Reviews | 3 scientific + 3 ethics reviews, each with 1 assigned reviewer, **answered** (answers + scores) | Committee Reviews |
| Meetings | 3 meetings (planning/in-review/decision) + 6 agenda items + 3 minutes + 3 quorum logs + votes | Committee Meetings |
| Notifications | 5 notifications + template set + 2 attachments | Communication |
| Safety | 3 assessments + 3 reports + 2 adverse events + 1 SAE + actions (Section 2 min set) | Safety |
| Monitoring | 2 plans + 3 inspections + findings + deviations (Section 2 min set) | Monitoring & Compliance |
| Accreditation | 3 standards + 1 cycle + 3 assessments + 1 decision (Section 2 min set) | Accreditation |
| Consent | 3 templates + 4 versions + 3 application consents | Informed Consent |
| Ethics Risk | 3 assessments + items | Ethics Risk Assessment |
| Templates | **0** | (no consumer — excluded by definition) |
| Reporting | 5 definitions + 6 widgets + ≥2 KPI results computable from canonical data | Reporting & Dashboards |
| Certificates | 1 issued certificate + 1 revoked-for-reissue + public hash | Certificates & Public Verification |
| Conditions | 3 conditions in OPEN state + 3 evidence documents | Conditions & Evidence |
| Integration | 2 external systems + 1 webhook (demo) | Integration |
| System config | `system_config` defaults | System Configuration |
| Audit | 0 (runtime trigger-written) | Audit & Data Integrity |

**Completeness invariant:** after applying the minimal set, **no route may read an empty table** — i.e. the 163-route empty-read count from `feature-traceability-review.md` (S5) must fall to 0 for canonical data, except routes whose empty reads are runtime-expected (`password_reset_tokens`).

**Size bound:** minimal set ≈ 3 institutions, 6 users, 2 committees, 3 projects, 3 applications, ~45 documents, ~60 review answers/scores, 3 meetings, and the Section 2 minimums for the seven blocked domains. Total ≈ 800–1,200 business rows (excluding audit/outbox).

---

## SECTION 4 — Seed Dependency Specification

Business-domain dependency ordering. **Not** file ordering — the runner computes execution order from this DAG (topological sort, not filename sort).

```
Layer 0   Reference universe
          statuses/lookups → document_types → workflow states+transitions → committee types/roles
          → institution_types → responsibility_types → research_categories → risk levels
          → notification_templates → report_definitions → dashboard_widgets → system_config
              │
Layer 1   Institutions & structure
          institutions → departments
              │
Layer 2   Security (users must exist before ownership columns are valid)
          roles/permissions → users → user_roles → user_profiles
              │
Layer 3   Committee structure
          committees → committee_members → committee_member_roles
              │
Layer 4   Researcher graph
          projects → project_keywords/sites/funding/team → applications
              │
Layer 5   Documents (owned by users, linked to applications)
          document_types → documents → document_versions
              │
Layer 6   Committee operations
          meetings → agenda → reviews (forms/questions) → assignments → answers/scores
              │
Layer 7   Conditions & evidence (must come after applications and documents)
          applications → application_conditions → evidence documents
              │
Layer 8   Workflow instances (dependent on workflow definitions, applications, users)
          workflows → workflow_instances → workflow_actions/history
              │
Layer 9   Certificates (after approved applications)
          certificates → verification artifacts
              │
Layer 10  Safety (after projects + committees + users)
          risk_categories → risk_assessments → risk_register → safety_reports
          → adverse_events → corrective/mitigation actions
              │
Layer 11  Monitoring (after projects + safety assessments)
          monitoring_plans → inspections → reports/findings → deviations → actions
              │
Layer 12  Accreditation (after committees + workflow defs)
          standards → standard_versions → cycles → assessments → conditions/evidence → decisions
              │
Layer 13  Consent (after documents + applications)
          consent_templates → template_versions → application_consents
              │
Layer 14  Ethics Risk (after applications + committee)
          ethics_risk_assessments → ethics_risk_items
              │
Layer 15  Integration (after users + applications)
          external_systems → webhooks → event_bus_config
              │
Layer 16  Reporting (after all business data)
          KPI results / dashboard snapshots computed from canonical data
```

**Direction:** an entity at layer N may reference only entities at layer ≤ N. **Edges that currently violate this** (root causes of the seed rollback chains): `safety.mitigation_actions.risk_assessment_id NOT NULL` with the assessment inserted later in the same failed file (17); accreditation cycles before standards (33); consent versions before templates (29). The DAG above fixes each: within-file order must follow the layer order exactly, and cross-file references must point only downward.

---

## SECTION 5 — Seed Reconstruction Plan

No SQL is written here. Strategy only, with the disposition of every existing seed.

### 5.1 Buckets (new layout)

| Bucket | Path | Contents |
|--------|------|----------|
| Infrastructure | `scripts/infrastructure/` | `00-truncate`, `00-seed-tracker`, runner, assertion harness (5 current files). |
| Reference | `seed/reference/` | Idempotent, keyed lookups/statuses/workflow defs (rewrite of 01,04,05,35,36,37,51,56,58,60,63,64). |
| Core Business | `seed/core/` | Institutions, users, committees, projects, applications, documents (split from 02,03,06,10,20,21). |
| Scenario | `seed/scenarios/` | Cross-feature journeys: safety incident, monitoring cycle, accreditation cycle, consent review, meeting+reviews, certificate issue. Rebuilt from 07,08,09,17,18,19,28,29,33. |
| Demo | `seed/fixtures/demo/` | Yemen lineage (50–54) — the canonical demonstration set. |
| Pilot | `seed/fixtures/pilot/` | `95-pilot-dataset` — UAT set, separate from demo. |
| Test Fixtures | `seed/fixtures/test/` | 2 current files + fixtures for the 7 blocked features. |
| Generated | `scripts/generate/` | Deterministic generator for keywords (372), application_history (459), document_access. |
| Runtime | (none — app-only) | audit, sessions, tokens, outbox, logs. Explicitly excluded. |

### 5.2 Disposition of the existing 79 seeds

| Current role | Count | Disposition |
|--------------|------:|-------------|
| Migration (schema DDL) | 29 | **Untouched** — schema only; stays as migrations. |
| Patch Seed (RLS/hotfix) | 10 | **Keep as patches**, verify each still applies on Gate-0 schema. |
| Reference Seed | 12 | **Rewrite** — make idempotent, keyed, guarded, with row-count reports (currently 8 of 12 are silent-no-op or non-idempotent). |
| Scenario Seed | 15 | **Split & rebuild** — 5 of them (17,18,28,29,33) fail on their dependency chains and must be rebuilt against the Layer 10–14 DAG. |
| Demo Fixture | 6 | **Keep** (50–54 = canonical); `95-pilot` moves to Pilot bucket. |
| Test Fixture | 2 | Keep; extend for blocked features. |
| Infrastructure | 5 | Extend runner with DAG order + row-count assertions + real per-file tracker. |
| `64-application-registration.sql` (untracked WIP) | 1 | Fold into core bucket; register in tracker. |

### 5.3 Strategy elements

1. **Reference seeds** keyed by natural codes with `ON CONFLICT` upserts; assert final count ≥ declared floor.
2. **Core business seeds** anchored to reference keys (never hardcoded UUIDs/names); users created before documents; `app.user_id` propagation verified per-file.
3. **Scenario seeds** built bottom-up per the DAG; each file covers one vertical slice and reports its row counts.
4. **Demo seeds (Yemen lineage)** preserved as the canonical dataset — 41 institutions, 106 users, 8 committees, 121 projects, 112 applications, 1,062 documents — with **added** review answers/scores, meeting agendas/minutes, and the seven blocked domains' minimums.
5. **Generated data** produced by a deterministic generator (seeded PRNG) for bulk keywords, history, and access trails so re-runs are byte-identical.
6. **Runtime data** never seeded: audit, sessions, login audit, password history, tokens, outbox.
7. **Ordering** computed from the Section 4 DAG by the runner; filename order is irrelevant.
8. **Verification** per file: inserted-count report + post-conditions (e.g. "no route reads an empty table").

---

## SECTION 6 — Dead Data Elimination

Datasets that must disappear permanently from the seed suite.

| # | Dataset | Size | Why it must go |
|---|---------|------|----------------|
| 1 | **`templates.*`** (16 tables: 12 templates, 13 versions, 44 variables, 5 partials, 12 categories, 4 audit rows) | 90 rows | **No consumer.** No repository, no route, no page reads these tables (S3, traceability review). Seeded-only dead data. Remove from canonical dataset; schema may remain, but no seed may populate it until a consumer exists. |
| 2 | **Fabricated runtime artifacts in seeds** — `security.sessions` (372), `security.login_audit` (488), `security.password_history` (95), `security.email_verification_tokens` (13), `integration.event_outbox` (30) | 998 rows | These are application-produced records. Seeded copies are stale/fake and violate "runtime data is never seeded". All seed inserters for these tables must be removed. |
| 3 | **`documents.document_access`** (3,956) | 3,956 rows | Derived data with no repo reader. Must not be hand-seeded; regenerate from documents via the access trigger, or drop seed entirely. |
| 4 | **Era-1 (KSU) lineage remnants** | variable | Superseded by the Yemen canonical decision. Any seed inserting KSU institutions/committees/`APP-2024-*` rows is retired. The canonical baseline contains Yemen only; this rule prevents reintroduction. |
| 5 | **`audit.audit_details` / `audit_logs`** (35,708) | largest | Trigger-written integrity records. Never seeded; a fresh canonical restore must start them empty and let the application populate them. |
| 6 | **`reporting.analytics_snapshots` / `kpi_results` / `report_executions`** | 0 | Runtime/computed. No seed may write them; only the reporting engine may. |
| 7 | **`ops.seed_tracker` bulk-restored rows** | 78 | The tracker must be repopulated by the runner itself (per-file, real duration/rows), never by a dump restore. Old fabricated `applied_at`/`duration_ms=0` rows are replaced. |

**Kept intentionally** (populated-but-unread today, but not dead): `core.application_history` (459, generated, useful for timelines), project keyword/site/funding/team (read via direct-SQL lookups), `core.project_status_history` (93), workflow history (30). These stay as generated/scenario data.

---

## SECTION 7 — Seed Quality Rules

Permanent architectural rules. These are non-negotiable for all future seeds.

| # | Rule |
|---|------|
| 1 | **No business-key anchoring.** No hardcoded UUIDs, names, or emails in seeds. Reference by natural code with UNIQUE constraints; join via keys, never by literal business values. |
| 2 | **No `INSERT...SELECT` without validation.** Every `INSERT...SELECT` must guard against the source being empty or the target count drifting, and must report source/target row counts. |
| 3 | **No silent zero-row inserts.** Every seed must declare an expected row-count range and **fail** if the final count is outside it (currently 7/12 reference seeds carry silent-no-op risk, 5/12 are non-idempotent, and all 15 scenario seeds carry silent-no-op risk). |
| 4 | **Every seed reports inserted row count.** The runner records per-file `rows_inserted`, `duration_ms`, `checksum`, and `status` in `ops.seed_tracker` (replacing the bulk-restored fake rows). |
| 5 | **Every dependency validated before execution.** A seed declares its dependencies (Layer numbers / entity names); the runner aborts the run if a dependency is missing or failed. |
| 6 | **Every seed independently executable.** Any single seed can be applied to a correct prior state and succeed; no seed depends on another file's *ordering* or on later files. |
| 7 | **Every seed independently testable.** Each seed has an assertion set (row counts + required-state checks) runnable in isolation. |
| 8 | **Deterministic ordering.** Execution order is the topological sort of the Section 4 DAG — never filename order. |
| 9 | **Idempotency.** Re-running the suite produces an identical final state. Only `00-truncate` (infrastructure) is destructive and must be invoked explicitly. |
| 10 | **RLS-compliance.** Every seed runs as a real seeded principal via the context-propagation path; `SET SESSION app.user_id` is set; no `ALTER TABLE ... DISABLE ROW LEVEL SECURITY`, no `SECURITY DEFINER` for data seeds. |
| 11 | **Transaction-wrapped with `ON_ERROR_STOP=1`.** A failed file rolls back entirely and fails the run loudly (matches current `apply-seeds.ps1` behavior). |
| 12 | **Runtime tables are never seeded.** Audit, sessions, tokens, outbox, logs are populated only by application code/triggers. |
| 13 | **Within-file order follows the DAG.** A file's own inserts respect Layer order (fixes the 17-safety / 33-accreditation / 29-consent rollback class). |
| 14 | **Canonical data is versioned.** Every dataset change bumps the canonical version (e.g. `canonical-2026-08-04 → canonical-2026-08-xx`); old baselines remain restorable. |

---

## SECTION 8 — Acceptance Criteria

Objective, machine-checkable gates for the future seed architecture.

| # | Criterion | Check |
|---|-----------|-------|
| A1 | **Clean install passes.** Fresh schema + suite → 0 failures, every seed `success`. | CI job; `ops.seed_tracker` all `success` with real durations. |
| A2 | **Idempotent replay.** Two consecutive full runs → identical final row counts for every table. | Diff of per-table counts. |
| A3 | **Row-count integrity.** Every seed's reported inserted count is within its declared range. | Assertion harness. |
| A4 | **Zero empty-read routes.** For the canonical dataset, 0 of the 315 leaf routes reads an empty table (S5 count drops to 0), excluding runtime-expected empties (`password_reset_tokens`). | Route×table audit against populated canonical DB. |
| A5 | **Feature proof.** Each of the 28 features has a data-query proof: canonical rows ≥ Section 3 minimums for every feature's tables. | Per-feature SQL assertions. |
| A6 | **Dead data absent.** `templates.*`, audit/log/session/outbox tables are empty after seed; only the application populates them. | Count audit. |
| A7 | **RLS matrix passes.** Seeded accounts satisfy the registration flow and the 7-scenario evidence-DELETE policy matrix (RULE 12). | E2E tests using seeded credentials. |
| A8 | **Determinism.** Two independent restores of the same canonical version → identical business-row counts. | Restore × 2. |
| A9 | **Full demo coverage.** The Section 9 journeys (researcher submission, committee review, post-approval) and one scenario per blocked feature complete end-to-end. | Playwright E2E. |
| A10 | **Performance.** Full suite completes within a stated budget (e.g. < 5 min on the dev machine). | Runner metric. |
| A11 | **No leakage.** No seed writes outside its bucket; generated and runtime data are clearly separated. | Bucket boundary check in runner. |

---

## SECTION 9 — RC4 Execution Readiness

**Is the project ready to begin seed reconstruction?**

**NO.**

### Remaining architectural blockers

1. **Five seed chains still fail** — `17-safety-data`, `18-monitoring-data`, `28-ethics-risk-assessment`, `29-informed-consent`, `33-accreditation-seed` (plus `90/95/96`) abort on `NOT NULL`/dependency violations. There is no working seed for 7 features (Safety, Monitoring, Ethics Risk, Consent, Accreditation, E-Signatures, Integration). Reconstruction cannot begin until the Section 4 DAG is ratified and these chains are redesigned against it.
2. **Reference/core seeds are non-idempotent and business-key-anchored** (01, 02, 03, 05, 06, 07, 08, 09, 10, 20, 21…): silent-no-op risk on 8/12 reference seeds, hardcoded keys throughout. Rules R1–R3 of Section 7 require a rewrite before any new data is added.
3. **Seed tracker integrity is broken.** All 78 entries show identical `applied_at` and `duration_ms=0` (bulk-restored, not executed); failed seeds are recorded as `success`. The tracker must be re-architected (real per-file execution records) before it can gate A1/A3.
4. **No dependency engine.** Current ordering is filename-based with known cross-version ordering bugs (`06` needs institution from `10`). Section 4 DAG + runner is a prerequisite.
5. **No row-count reporting/assertion infrastructure** exists for seeds (R3/R4, A3).
6. **Dead-data disposition is unresolved.** `templates.*`, fabricated sessions/audit/tokens/outbox rows, and `document_access` seeding must be removed per Section 6 before a canonical build.
7. **Generated-data strategy undefined.** Keyword/history/access bulk rows (Section 5.1 "Generated") have no deterministic generator.
8. **Test-fixture strategy for the 7 blocked features undefined.** A2/A7/A9 cannot pass without them.
9. **Disposition of the 41 SEEDED_UNUSED tables** (populated but never read) needs the keep/remove decision ratified — currently only partially covered by Section 6.
10. **Schema/migration inconsistency blocks clean data insertion** — `documents.lifecycle_state_id NOT NULL` without default (seed 58/Gate-0). This is a migration concern, not a seed concern, but it must be resolved before documents can be reseeded.

---

## SECTION 10 — Executive Recommendation

Recommended implementation order once the blockers are cleared. This is the seed-reconstruction execution contract.

| Phase | Scope | Output | Gate |
|-------|-------|--------|------|
| 0 | **Contract ratification.** Sign off on this specification: canonical dataset (Section 2), minimal set (Section 3), DAG (Section 4), dead-data list (Section 6), quality rules (Section 7). | Approved spec | None (this document) |
| 1 | **Seed infrastructure.** Rewrite tracker + runner with DAG ordering, row-count reporting, assertions, bucket boundaries. | Runner + tracker | A1 (partial), A3, A10 |
| 2 | **Reference seed rewrite.** Idempotent, keyed, guarded versions of the 12 reference seeds + workflow definitions. | Reference bucket | A2, R1–R3 |
| 3 | **Resolve schema blocker.** `documents.lifecycle_state_id` default (migration, coordination required) — prerequisite to documents reseed. | Migration change | unblocks A4 |
| 4 | **Core business seeds.** Institutions → users → committees → projects → applications → documents, following the DAG, with generated data (keywords/history). | Core bucket | A4 partial, A6 |
| 5 | **Reconstruct the 5 failing chains.** Safety, Monitoring, Ethics Risk, Consent, Accreditation scenario seeds, bottom-up per Layers 10–14. | Scenario bucket | A5 for the 7 blocked features |
| 6 | **Committee scenario data.** Meeting agendas/minutes/quorum, review answers/scores, certificates, conditions evidence, notifications. | Scenario bucket | A4 (163→0), A5 |
| 7 | **Canonical demo + pilot.** Yemen lineage at recommended counts + reconstructed data; `95-pilot` moved to Pilot bucket. | Demo/Pilot | A8, A9 |
| 8 | **Dead-data removal.** Delete `templates.*` seed, fabricated runtime rows, `document_access` seeders, Era-1 remnants. | Clean suite | A6 |
| 9 | **Verification.** Fresh-restore idempotency run, feature proof (A5), route-empty audit (A4), RLS matrix E2E (A7), full demo journeys (A9). | Verified baseline | A1–A11 |
| 10 | **Baseline freeze.** Produce the new canonical dump; register in backup workflow; document version. | `canonical-rc4-*.dump` | A8, A11 |

**Priority order rationale:** infrastructure first (1) so every later seed is order-safe and measurable; reference + schema blocker (2–3) because core data cannot be keyed or documents cannot be reseeded without them; core (4) because it unblocks the majority of routes; the five failing chains (5) because they are the only data gap preventing 100% demonstration; committee scenario data (6) closes the last partial gaps; demo/pilot (7) and dead-data removal (8) finalize the dataset; verification (9) and baseline freeze (10) make the result reproducible.

---

*End of Canonical Seed Specification. READ-ONLY deliverable — no SQL, no migrations, no code, no commits.*
