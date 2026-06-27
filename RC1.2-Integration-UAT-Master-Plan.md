# RC1.2 Integration & UAT Master Plan

> **Version:** 1.2  
> **Project:** Ethics ERM System — Committee Accreditation Module (P3)  
> **Status:** Approved for Execution  
> **Target Release:** RC1.2  
> **Next Phase:** Operational Pilot (RC1.2.1)

---

## Table of Contents

1. [Scope](#1-scope)
2. [Environment](#2-environment)
3. [Test Data Matrix](#3-test-data-matrix)
4. [Role Matrix](#4-role-matrix)
5. [Pre-Execution Checklist](#5-pre-execution-checklist)
6. [Execution Gates Overview](#6-execution-gates-overview)
7. [Gate 1 — Smoke Test](#7-gate-1--smoke-test)
8. [Gate 2 — Functional Integration](#8-gate-2--functional-integration)
9. [Gate 3 — Role & Security](#9-gate-3--role--security)
10. [Gate 4 — Data Integrity](#10-gate-4--data-integrity)
11. [Gate 5 — Non-Functional](#11-gate-5--non-functional)
12. [Gate 6 — UAT](#12-gate-6--uat)
13. [Production Data Validation](#13-production-data-validation)
14. [Module Integration Matrix](#14-module-integration-matrix)
15. [Negative & Edge Cases](#15-negative--edge-cases)
16. [Regression Suite](#16-regression-suite)
17. [Defect Severity Matrix](#17-defect-severity-matrix)
18. [Exit Criteria](#18-exit-criteria)
19. [Traceability Matrix](#19-traceability-matrix)
20. [Requirement Coverage Matrix](#20-requirement-coverage-matrix)
21. [Execution Roadmap](#21-execution-roadmap)
22. [Test Evidence & Metrics](#22-test-evidence--metrics)
23. [Release Sign-off](#23-release-sign-off)
24. [Appendices](#24-appendices)

---

## 1. Scope

### 1.1 In Scope

All modules that constitute the RC1.2 release, tested as an integrated whole:

| # | Module | Backend Routes | Frontend Pages |
|---|--------|---------------|----------------|
| 1 | **Authentication & Authorization** | `auth.routes.ts`, `permissions.routes.ts`, `roles.routes.ts` | Login, Register, Roles |
| 2 | **User & Profile Management** | `users.routes.ts`, `profiles.routes.ts`, `responsibility.routes.ts` | Users, Profile |
| 3 | **Institutions** | (via `lookups.routes.ts` + seed data) | (dropdown selects) |
| 4 | **Committees** | `committees.routes.ts`, `members.routes.ts` | Committees, CommitteeDetail |
| 5 | **Projects** | `projects.routes.ts` | Projects (List, Create, Detail) |
| 6 | **Applications** | `applications.routes.ts` | Applications (List, Create, Detail) |
| 7 | **Scientific & Ethics Review** | `reviews.routes.ts`, `review-forms` | MyReviews |
| 8 | **Meetings & Voting** | `meetings.routes.ts`, `voting.routes.ts` | CommitteeMeetings, MeetingDetail |
| 9 | **Risk Assessment** | `ethics-risk.routes.ts` | RiskRegister |
| 10 | **Informed Consent** | `consent.routes.ts` | ConsentTemplates |
| 11 | **Safety (Adverse Events, Incidents, Actions)** | `risk.routes.ts` | AdverseEvents, RiskIncidents, CorrectiveActions |
| 12 | **Communication** | `messages.routes.ts` | Messages |
| 13 | **Documents** | `documents.routes.ts` | Documents |
| 14 | **Committee Accreditation (P3)** | `accreditation.routes.ts` | Cycles, CycleDetail, Evidence, Assessments, Conditions, Dashboard |
| 15 | **Workflow Engine** | `workflow.routes.ts` | (embedded in applications/reviews) |
| 16 | **Notifications** | `push-config.routes.ts` | Notifications |
| 17 | **Reporting** | (via reporting module) | Reports |
| 18 | **Audit & RLS** | (middleware, database-level) | (transparent) |
| 19 | **Admin** | `reference-data.routes.ts`, `backup.routes.ts`, ... | AdminDashboard, ReferenceData, BackupSettings |

### 1.2 Out of Scope (RC2)

- Decision Snapshot (`accreditation_decision_snapshot`)
- Accreditation Certificate PDF generation
- KPI Dashboard (system-wide analytics)
- Notification automation for accreditation lifecycle
- Public certificate verification page
- Integration with external systems (API Gateway, EHR, etc.)

---

## 2. Environment

### 2.1 Infrastructure

| Component | Version | Details |
|-----------|---------|---------|
| **Database** | PostgreSQL 18 Alpine | `postgres:18-alpine` |
| **Backend Runtime** | Node.js 22 | `node:22-alpine` (via Docker build) |
| **Frontend Runtime** | Nginx (Vite build) | Static SPA served via nginx |
| **Container Runtime** | Docker Compose v2+ | 3 services: postgres, backend, frontend |

### 2.2 Docker Services

```yaml
postgres:
  port:    127.0.0.1:5432 → 5432
  db:      ethics_db
  user:    postgres
  pass:    postgres (default, overridable via DB_PASSWORD)
  memory:  1G limit / 512M reserved
  init:    4 SQL scripts (DDL, tables, functions, constraints)

backend:
  port:    8080 → 8080
  env:     NODE_ENV=production
  memory:  512M limit / 256M reserved

frontend:
  port:    80 → 80
  memory:  256M limit / 128M reserved
```

### 2.3 Backend Versions

| Dependency | Version |
|------------|---------|
| TypeScript | 6.0.3 |
| Express | 5.2.1 |
| pg (node-postgres) | 8.21.0 |
| node-pg-migrate | 8.0.4 |
| argon2 | 0.44.0 |
| jose (JWT) | 6.2.3 |
| zod | 4.4.3 |
| multer (file upload) | 2.1.1 |
| nodemailer | 9.0.1 |
| pino (logging) | 10.0.0 |
| swagger-jsdoc | 6.3.0 |

### 2.4 Frontend Versions

| Dependency | Version |
|------------|---------|
| TypeScript | 6.0.2 |
| React | 19.2.6 |
| Vite | 8.0.12 |
| Tailwind CSS | 4.3.0 |
| TanStack Query | 5.101.0 |
| react-router-dom | 7.16.0 |
| react-hook-form | 7.77.0 |
| zod | 4.4.3 |
| i18next | 26.3.1 |
| recharts | 2.15.3 |
| sonner (toast) | 2.0.7 |
| lucide-react (icons) | 1.17.0 |
| axios | 1.17.0 |

### 2.5 Seed Data

The seed files are located in `backend/seed/` and must be executed in numerical order:

| File | Purpose |
|------|---------|
| `00-truncate.sql` | Truncate all tables (reset) |
| `01-reference.sql` | Lookup tables, reference codes |
| `02-users.sql` | Roles, permissions, users |
| `03-committees.sql` | Committees and members |
| `04-documents.sql` | Document types and templates |
| `05-workflow.sql` | Workflow engine configuration |
| `06-projects-apps.sql` | Projects and applications |
| `07-workflow-instances.sql` | Workflow instances |
| `08-reviews.sql` | Review assignments and results |
| `09-meetings-etc.sql` | Meetings, voting, minutes |
| `10-yemen-institutions.sql` | 28 Yemeni institutions |
| `11-rls-fix.sql` through `30-rls-ethics-risk.sql` | RLS policies, audit, indexes |
| `31-accreditation-schema.sql` | Accreditation schema |
| `32-accreditation-rls.sql` | Accreditation RLS |
| `33-accreditation-seed.sql` | Accreditation seed data |
| `95-pilot-dataset.sql` | Yemeni pilot UAT data (Yemen MOH, NBC, etc.) |
| `96-realistic-data.sql` | Realistic universities/hospitals dataset |

### 2.6 Test Users

| Username | Role | Password | Purpose |
|----------|------|----------|---------|
| admin | SUPER_ADMIN | `Pilot@1234` | Full system access |
| ethics_admin | ETHICS_ADMIN | `Pilot@1234` | Manage ethics & accreditation |
| chair_01 | COMMITTEE_CHAIR | `Pilot@1234` | Chair specific committees |
| reviewer_01 | REVIEWER | `Pilot@1234` | Review applications |
| researcher_01 | RESEARCHER | `Pilot@1234` | Submit research applications |

### 2.7 Dataset Snapshot (Post-Seed)

| Entity | Count |
|--------|-------|
| Institutions | 28 |
| Committees | 19 |
| Committee Members | 176 |
| Users | 313 |
| Projects | 107 |
| Applications | 92 |
| Safety Events | 208 |
| Accreditation Cycles | ~5–10 (per seed) |

### 2.8 Browser Matrix

| Browser | Minimum Version |
|---------|----------------|
| Chrome | 120+ |
| Firefox | 120+ |
| Edge | 120+ |
| Safari | 17+ |

---

## 3. Test Data Matrix

### 3.1 Institutions (28)

| Type | Count | Examples |
|------|-------|---------|
| UNIVERSITY | 10 | Sana'a University, Aden University, Taiz University |
| HOSPITAL | 8 | Al-Thawra Hospital, Kuwait Hospital, Al-Jomhori Hospital |
| GOVERNMENT | 5 | Yemen MOH, National Bioethics Committee |
| RESEARCH_CENTER | 4 | Saudi Research Centers (via seed) |
| NATIONAL_COMMITTEE | 1 | National Bioethics Committee (NBC) |

### 3.2 Committees (19)

| Type | Count | Jurisdiction |
|------|-------|-------------|
| Institutional Review Boards (IRB) | 10 | Per university |
| National Ethics Committees | 3 | MOH, NBC, specialized |
| Hospital Ethics Committees | 4 | Per major hospital |
| Accreditation Committees | 2 | NCBE, specialized |

### 3.3 Roles Available for Testing (5)

| Role | Users | System Role |
|------|-------|-------------|
| SUPER_ADMIN | 1+ | Yes |
| ETHICS_ADMIN | 1+ | Yes |
| COMMITTEE_CHAIR | 3+ | Yes |
| REVIEWER | 10+ | No |
| RESEARCHER | 50+ | No |

### 3.4 Accreditation-Specific Data

| Entity | Count (expected) | Notes |
|--------|------------------|-------|
| Accreditation Standards | 12 | Per `33-accreditation-seed.sql` |
| Standard Versions | 12 | Version 2025.1 |
| Cycles (PENDING) | 3+ | Ready for UAT |
| Conditions | Variable | Created during UAT |
| Decisions | Variable | Created during UAT |

---

## 4. Role Matrix

### 4.1 Accreditation Module

| Page / Action | SUPER_ADMIN | ETHICS_ADMIN | COMMITTEE_CHAIR | REVIEWER | RESEARCHER |
|---------------|:-----------:|:------------:|:---------------:|:--------:|:----------:|
| **Cycles** | | | | | |
| View Cycle List | ✅ | ✅ | ✅ | ✅ | ✅ |
| View Cycle Detail | ✅ | ✅ | ✅ | ✅ | ✅ |
| Create Cycle | ✅ | ✅ | ❌ | ❌ | ❌ |
| Delete Cycle | ✅ | ✅ | ❌ | ❌ | ❌ |
| Change Status | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Evidence** | | | | | |
| View Evidence | ✅ | ✅ | ✅ | ✅ | ✅ |
| Upload Evidence | ✅ | ✅ | ✅ | ✅ | ❌ |
| Review Evidence (Accept/Reject) | ✅ | ✅ | ❌ | ❌ | ❌ |
| Delete Evidence | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Assessments** | | | | | |
| View Assessments | ✅ | ✅ | ✅ | ✅ | ✅ |
| Create Assessment | ✅ | ✅ | ❌ | ❌ | ❌ |
| Update Assessment Items | ✅ | ✅ | ❌ | ❌ | ❌ |
| Delete Assessment | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Conditions** | | | | | |
| View Conditions | ✅ | ✅ | ✅ | ✅ | ✅ |
| Create Condition | ✅ | ✅ | ❌ | ❌ | ❌ |
| Resolve Condition | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Dashboard** | | | | | |
| View Dashboard | ✅ | ✅ | ✅ | ✅ | ✅ |
| Issue Final Decision | ✅ | ✅ | ❌ | ❌ | ❌ |

### 4.2 General Module Permissions

| Module | SUPER_ADMIN | ETHICS_ADMIN | COMMITTEE_CHAIR | REVIEWER | RESEARCHER |
|--------|:-----------:|:------------:|:---------------:|:--------:|:----------:|
| Projects (view) | ✅ | ✅ | ✅ | ✅ | ✅* |
| Projects (create) | ✅ | ✅ | ❌ | ❌ | ✅ |
| Applications (view) | ✅ | ✅ | ✅ | ✅ | ✅* |
| Applications (create) | ✅ | ✅ | ❌ | ❌ | ✅ |
| Reviews (view) | ✅ | ✅ | ✅ | ✅ | ❌ |
| Reviews (submit) | ✅ | ✅ | ✅ | ✅ | ❌ |
| Meetings (view) | ✅ | ✅ | ✅ | ✅ | ❌ |
| Meetings (create) | ✅ | ✅ | ✅ | ❌ | ❌ |
| Voting | ✅ | ✅ | ✅ | ❌ | ❌ |
| Risk Register | ✅ | ✅ | ❌ | ❌ | ❌ |
| Safety Events | ✅ | ✅ | ✅ | ✅ | ✅ |
| Documents (upload) | ✅ | ✅ | ✅ | ✅ | ✅ |
| Documents (delete) | ✅ | ✅ | ✅ | ❌ | ❌ |
| Users (manage) | ✅ | ✅ | ❌ | ❌ | ❌ |
| Roles (manage) | ✅ | ❌ | ❌ | ❌ | ❌ |
| Admin Panel | ✅ | ✅ | ❌ | ❌ | ❌ |
| Reports | ✅ | ✅ | ✅ | ✅ | ❌ |

> \* Researchers see only their own projects/applications (enforced by RLS).

---

## 5. Pre-Execution Checklist

### 5.1 Baseline Snapshot

Before ANY test is executed, record the following baseline. This ensures every result is reproducible.

| ID | Item | Value | Verified |
|---|------|-------|:--------:|
| B-01 | Git Commit Hash | `git rev-parse HEAD` | ☐ |
| B-02 | Git Tag | `git describe --tags --exact-match` (or `RC1.2-candidate`) | ☐ |
| B-03 | Branch | `git branch --show-current` | ☐ |
| B-04 | Schema Version | Check `pgmigrations` table last migration | ☐ |
| B-05 | Seed Version | Last seed file executed | ☐ |
| B-06 | Docker Image Tags | `docker images ghcr.io/*/backend ghcr.io/*/frontend` | ☐ |
| B-07 | Node Version | `node --version` | ☐ |
| B-08 | PostgreSQL Version | `psql --version` / `SHOW server_version;` | ☐ |
| B-09 | npm Dependency Hash | `npm ls --depth=0` or lockfile hash | ☐ |
| B-10 | Test Start Timestamp | `Get-Date -Format "yyyy-MM-ddTHH:mm:ss"` | ☐ |

### 5.2 Test Freeze Confirmation

| ID | Rule | Status |
|---|------|:------:|
| F-01 | No new features during test execution | ☐ Confirmed |
| F-02 | No database schema changes | ☐ Confirmed |
| F-03 | No dependency updates | ☐ Confirmed |
| F-04 | No refactoring outside bug fixes | ☐ Confirmed |
| F-05 | Only bug fixes for defects found during testing | ☐ Confirmed |

### 5.3 Environment Readiness

| ID | Check | Expected | Verified |
|---|-------|----------|:--------:|
| R-01 | Docker services running | 3/3 healthy | ☐ |
| R-02 | Database accessible | `pg_isready` | ☐ |
| R-03 | Seeds applied | All 00–33 executed | ☐ |
| R-04 | Migrations up | `node-pg-migrate up` (no pending) | ☐ |
| R-05 | Test users exist | 5 users with correct roles | ☐ |
| R-06 | Backend API responding | `GET /api/v1` → 200 | ☐ |
| R-07 | Frontend serving | `GET http://localhost` → 200 | ☐ |
| R-08 | Logging configured | Backend → stdout, file | ☐ |
| R-09 | No fatal errors in logs | `docker-compose logs --tail=50 backend` | ☐ |
| R-10 | Free disk space | > 10GB available | ☐ |

## 6. Execution Gates Overview

The validation is organized into **6 sequential gates**. Each gate must pass at 100% before proceeding to the next.

| Gate | Name | Focus | Success Criteria |
|:----:|------|-------|:----------------:|
| **1** | Smoke Test | System boots, build succeeds, basic login | 100% |
| **2** | Functional Integration | End-to-end scenarios across all modules | ≥ 95% |
| **3** | Role & Security | RBAC, RLS, authorization for all roles | 100% |
| **4** | Data Integrity | FK correctness, audit fields, no orphans | 100% |
| **5** | Non-Functional | Performance, concurrency, backup/restore, security | Within thresholds |
| **6** | UAT | Real-world scenarios by end users | User acceptance |

---

## 7. Gate 1 — Smoke Test

**Objective:** Verify the system boots cleanly, all services respond, and most basic user journeys work. Executed in **4 sequential batches**.

### 7.1 Batch A — Startup Validation

| ID | Test | Action | Expected | Evidence |
|---|------|--------|----------|:--------:|
| SMK-001 | Docker compose up | `docker-compose up -d` | All 3 services start | Logs |
| SMK-002 | PostgreSQL health | `pg_isready -U postgres -d ethics_db` | Accepting connections | Logs |
| SMK-003 | Backend health | `curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/v1/` | 200 | CURL |
| SMK-004 | Frontend health | `curl -s -o /dev/null -w "%{http_code}" http://localhost/` | 200 | CURL |
| SMK-005 | DB connection from backend | Check backend logs for "connected" | No connection errors | Logs |
| SMK-006 | Migration status | `cd backend && npx node-pg-migrate up` | No pending migrations | CLI |
| SMK-007 | Seed applied | Verify test users exist | `SELECT COUNT(*) FROM security.users` > 0 | SQL |
| SMK-008 | No fatal logs | Check logs for FATAL | 0 matches | Logs |

### 7.2 Batch B — Authentication Smoke

| ID | Test | Action | Expected | Evidence |
|---|------|--------|----------|:--------:|
| SMK-009 | Login page renders | Visit `http://localhost/login` | Login form visible | Screenshot |
| SMK-010 | Login as SUPER_ADMIN | admin / Pilot@1234 | Dashboard, username visible | Screenshot |
| SMK-011 | Login as ETHICS_ADMIN | ethics_admin / Pilot@1234 | Dashboard | Screenshot |
| SMK-012 | Login as COMMITTEE_CHAIR | chair_01 / Pilot@1234 | Dashboard | Screenshot |
| SMK-013 | Login as REVIEWER | reviewer_01 / Pilot@1234 | Dashboard | Screenshot |
| SMK-014 | Login as RESEARCHER | researcher_01 / Pilot@1234 | Dashboard | Screenshot |
| SMK-015 | Invalid credentials | fake / wrong | 401, error message | API |
| SMK-016 | Logout | Click logout | Redirect to login, no session | Screenshot |
| SMK-017 | Session expiry | Use expired JWT | 401, redirect to login | API |
| SMK-018 | API without JWT | `GET /api/v1/committee/accreditation/cycles` (no header) | 401 | CURL |

### 7.3 Batch C — Core Navigation Smoke

| ID | Page | Expected | Evidence |
|---|------|----------|:--------:|
| SMK-019 | Dashboard | Renders, no errors | Screenshot |
| SMK-020 | Projects | List loads, table renders | Screenshot |
| SMK-021 | Applications | List loads, table renders | Screenshot |
| SMK-022 | Committees | List loads, table renders | Screenshot |
| SMK-023 | Committee Detail | Detail loads, member list renders | Screenshot |
| SMK-024 | Meetings | List loads, table renders | Screenshot |
| SMK-025 | My Reviews | List loads, table renders | Screenshot |
| SMK-026 | Accreditation Cycles | List loads, table renders | Screenshot |
| SMK-027 | Cycle Detail | Detail loads, sections render | Screenshot |
| SMK-028 | Evidence | Page loads, upload button visible | Screenshot |
| SMK-029 | Assessments | Page loads, create button visible (admin) | Screenshot |
| SMK-030 | Conditions | Page loads, create button visible (admin) | Screenshot |
| SMK-031 | Dashboard (accreditation) | Summary cards render, no errors | Screenshot |
| SMK-032 | Notifications | List loads | Screenshot |
| SMK-033 | Documents | List loads, upload button | Screenshot |
| SMK-034 | Reports | Page loads | Screenshot |
| SMK-035 | Users (admin) | List loads (admin only) | Screenshot |
| SMK-036 | Profile | User info displays correctly | Screenshot |
| SMK-037 | Arabic/RTL toggle | Switch language → layout flips correctly | Screenshot |
| SMK-038 | All pages — browser console | 0 JavaScript errors | Console |

### 7.4 Batch D — Critical API Smoke

| ID | Endpoint | Method | Expected | Evidence |
|---|----------|--------|:--------:|:--------:|
| SMK-039 | `/api/v1/auth/login` | POST | 200 | API Log |
| SMK-040 | `/api/v1/projects` | GET | 200 | API Log |
| SMK-041 | `/api/v1/applications` | GET | 200 | API Log |
| SMK-042 | `/api/v1/committee/committees` | GET | 200 | API Log |
| SMK-043 | `/api/v1/committee/reviews` | GET | 200 | API Log |
| SMK-044 | `/api/v1/committee/accreditation/cycles` | GET | 200 | API Log |
| SMK-045 | `/api/v1/committee/accreditation/standards` | GET | 200 | API Log |
| SMK-046 | `/api/v1/documents` | GET | 200 | API Log |
| SMK-047 | `/api/v1/notifications` | GET | 200 | API Log |
| SMK-048 | `/api/v1/users` | GET | 200 | API Log |

### 7.5 Gate 1 Pass Criteria

| # | Criterion | Target |
|---|-----------|-------:|
| SMK-P01 | Batch A (Startup) | 8/8 pass |
| SMK-P02 | Batch B (Auth) | 10/10 pass |
| SMK-P03 | Batch C (Navigation) | 20/20 pass, 0 JS errors |
| SMK-P04 | Batch D (API) | 10/10 pass |
| **Total** | **All tests** | **48/48 pass** |

> **Gate 1 Pass → Proceed to Gate 2**

---

## 8. Gate 2 — Functional Integration

**Objective:** Execute the full end-to-end scenario that covers 80% of system usage, then verify cross-module data flows.

### 8.1 Primary E2E — Full Research Lifecycle (INT-FLOW-01)

This is the single most important scenario. It touches every major module in the system.

```
Researcher → Register → Create Project → Create Application →
Upload Documents → Submit → Workflow → Scientific Review →
Ethics Review → Risk Assessment → Committee Meeting → Voting →
Decision → Consent Review → Approval → Notification → Audit Log
```

**Preconditions:**
- System is clean-seeded with realistic data (seeds 00–33, 96)
- All 5 test users exist
- At least one committee is active with members assigned

| ID | Step | Actor | Action | Expected Result | DB Check |
|---|------|-------|--------|-----------------|----------|
| INT-001 | Register | researcher_01 | `POST /api/v1/auth/register` | 201, user created | `users` +1 row |
| INT-002 | Login | researcher_01 | `POST /api/v1/auth/login` | 200, JWT returned | — |
| INT-003 | Create project | researcher_01 | `POST /api/v1/projects` with title, objectives, dates | 201, project created | `core.projects` +1 row, `created_by` set |
| INT-004 | Create application | researcher_01 | `POST /api/v1/applications` linked to project | 201, DRAFT status | `core.applications` +1 row, FK valid |
| INT-005 | Upload document | researcher_01 | `POST /api/v1/documents` (protocol PDF) | 201, document stored | `documents.documents` +1 row |
| INT-006 | Submit application | researcher_01 | `PATCH /api/v1/applications/:id/submit` | 200, status → SUBMITTED | Workflow instance created |
| INT-007 | Workflow trigger | system | Automatic: assignment created | Notification to reviewer | `workflow_instances` +1, `notifications` +1 |
| INT-008 | Scientific review | reviewer_01 | `POST /api/v1/reviews` with findings | 201, review saved | `reviews` +1 row, `reviewed_by` set |
| INT-009 | Ethics review | reviewer_01 | `PATCH /api/v1/reviews/:id/decision` | 200, recommendation submitted | Status + `recommendation` updated |
| INT-010 | Risk assessment | ethics_admin | `POST /api/v1/ethics-risk` with risk level | 201, risk recorded | `ethics_risk_assessments` +1 |
| INT-011 | Schedule meeting | chair_01 | `POST /api/v1/meetings` with application on agenda | 201, meeting created | `meetings` +1, `agenda_items` +1 |
| INT-012 | Mark attendance | chair_01 | `POST /api/v1/meetings/:id/attendance` | 200, members marked | `meeting_attendance` +N rows |
| INT-013 | Start voting | chair_01 | `POST /api/v1/meetings/:id/voting` | 201, session open | `voting_sessions` +1 |
| INT-014 | Cast votes | members | `POST /api/v1/voting/:id/vote` (APPROVE / REJECT) | 200, vote recorded | `votes` +N rows |
| INT-015 | Close voting | chair_01 | `POST /api/v1/meetings/:id/voting/:id/close` | 200, outcome tallied | Session status → CLOSED |
| INT-016 | Issue decision | ethics_admin | `POST /api/v1/applications/:id/decision` (APPROVED) | 200, application approved | `application.status` → APPROVED |
| INT-017 | Consent review | ethics_admin | `POST /api/v1/consent/review` | 201, consent verified | `consent_reviews` +1 |
| INT-018 | Final approval | ethics_admin | Workflow transition to APPROVED | 200 | `workflow_instances.status` updated |
| INT-019 | Verify notification | researcher_01 | `GET /api/v1/notifications` | Notification present | `notifications` row with correct `user_id` |
| INT-020 | Verify audit log | admin | `GET /api/v1/audit?entity=applications&id=X` | Full history trail | `audit_log` entries for each transition |

**Post-Scenario DB Integrity Checks:**
```sql
-- No orphan records
SELECT * FROM core.applications WHERE project_id NOT IN (SELECT id FROM core.projects);  -- 0 rows
-- FK integrity
SELECT * FROM workflow_instances WHERE application_id NOT IN (SELECT id FROM core.applications);  -- 0 rows
-- Audit trail completeness
SELECT COUNT(*) FROM audit_log WHERE entity_type = 'application' AND entity_id = :appId;  -- ≥ 10 entries
```

**Success Criteria:**
- All 20 steps pass without errors
- Every mutation creates the expected database record
- Every status transition is correct per state machine
- Foreign keys are valid across all created records
- Audit trail exists for every state change
- Notifications were delivered to the correct recipients

### 8.2 Accreditation Lifecycle (INT-FLOW-02)

The full P3 accreditation flow, as designed in the Accreditation module:

| ID | Step | Actor | Action | Expected |
|---|------|-------|--------|----------|
| INT-021 | Login | admin | Authenticate as SUPER_ADMIN | Dashboard |
| INT-022 | Open accreditation | admin | Navigate to `/admin/accreditation/cycles` | Cycles list |
| INT-023 | Create cycle | admin | Select committee + standard version | Cycle PENDING |
| INT-024 | View detail | admin | Navigate to cycle detail | Detail with empty sections |
| INT-025 | Upload evidence | admin | Per standard (12 standards) | Evidence PENDING |
| INT-026 | Submit evidence | admin | Mark as SUBMITTED | Ready for review |
| INT-027 | Accept evidence | admin | Review → ACCEPTED | Evidence count updates |
| INT-028 | Create assessment | admin | Score each standard 1–4 | Assessment with items |
| INT-029 | Verify score | admin | View assessment | Correct % calculated |
| INT-030 | Create conditions | admin | Add conditions with severity | Conditions OPEN |
| INT-031 | Open dashboard | admin | `/admin/accreditation/cycles/:id/dashboard` | Summary cards, recommendation |
| INT-032 | Verify recommendation | admin | Check auto-calculated value | Matches rules |
| INT-033 | Issue conditional | admin | CONDITIONAL + decision_reason | Cycle → CONDITIONAL |
| INT-034 | Resolve condition | admin | Mark condition as MET | Status → MET, resolved_at set |
| INT-035 | Issue approve | admin | ACCREDITED + valid_from/valid_until | Cycle → ACCREDITED |
| INT-036 | Verify audit | admin | Cycle detail → decision history | All decisions recorded |
| INT-037 | Expire cycle | admin | EXPIRE transition | Cycle → EXPIRED |

### 8.3 Conditional Accreditation Path (INT-FLOW-03)

**Objective:** Test CONDITIONAL → ACCREDITED transition with condition resolution.

| ID | Step | Actor | Action | Expected |
|---|------|-------|--------|----------|
| INT-038 | Follow INT-FLOW-02 steps 1–10 | admin | Cycle UNDER_REVIEW with conditions | Ready |
| INT-039 | Issue CONDITIONAL decision | admin | Decision reason required | Cycle → CONDITIONAL |
| INT-040 | Verify valid_from/valid_until | admin | Dates displayed in detail | Visible |
| INT-041 | Resolve 1 condition → MET | admin | Condition resolved | Status change, resolved_at |
| INT-042 | Resolve 1 condition → WAIVED | admin | Condition waived | Status → WAIVED |
| INT-043 | Dashboard updates | admin | Recommendation recalculated | Updated |
| INT-044 | Issue ACCREDITED | admin | All conditions resolved | Cycle → ACCREDITED |

### 8.4 Suspension & Revocation (INT-FLOW-04)

**Objective:** Test SUSPENDED → ACCREDITED and REVOKE terminal state.

| ID | Step | Actor | Action | Expected |
|---|------|-------|--------|----------|
| INT-045 | Accredited cycle exists | — | From INT-FLOW-02 | ACCREDITED |
| INT-046 | Issue SUSPEND | admin | Decision reason required | Cycle → SUSPENDED |
| INT-047 | Verify read-only | admin | Evidence, assessments visible but no edit | Read-only |
| INT-048 | Issue RESUME → ACCREDITED | admin | Resume transition | Cycle → ACCREDITED |
| INT-049 | Issue REVOKE | admin | Decision reason required | Cycle → REVOKED |
| INT-050 | Verify no transitions | admin | StatusDialog shows empty | No available transitions |
| INT-051 | Verify EXPIRED → REVOKED | admin | ACCREDITED → EXPIRE → REVOKE | Works |

### 8.5 Cross-Module Data Flow (INT-FLOW-05)

| Sequence | Path | Check |
|----------|------|-------|
| Institution → Committee → Cycle | Institution FK through committee to cycle | Institution name appears in cycle detail |
| Cycle → Evidence → Assessment | Evidence acceptance unlocks assessment readiness | UI shows evidence status |
| Assessment → Dashboard | Assessment scores aggregate into recommendation | Recommendation matches rule engine |
| Condition → Dashboard | Condition count updates dashboard cards | Counts match filter |
| Decision → Audit | Decision creates immutable record | Decision appears in history log |

---

## 9. Gate 3 — Role & Security

**Objective:** Verify every role sees exactly what they should, and all RBAC/RLS policies are enforced.

### 9.1 Role-Based Access — Accreditation Module

| ID | Page / Action | SUPER_ADMIN | ETHICS_ADMIN | COMMITTEE_CHAIR | REVIEWER | RESEARCHER |
|---|---------------|:-----------:|:------------:|:---------------:|:--------:|:----------:|
| SEC-001 | View Cycles List | ✅ Access | ✅ Access | ✅ Access | ✅ Access | ✅ Access |
| SEC-002 | Create Cycle | ✅ Access | ✅ Access | ❌ Hidden/403 | ❌ Hidden/403 | ❌ Hidden/403 |
| SEC-003 | Delete Cycle | ✅ Access | ✅ Access | ❌ Hidden/403 | ❌ Hidden/403 | ❌ Hidden/403 |
| SEC-004 | Upload Evidence | ✅ Access | ✅ Access | ✅ Access | ✅ Access | ❌ Hidden/403 |
| SEC-005 | Review Evidence | ✅ Access | ✅ Access | ❌ Hidden/403 | ❌ Hidden/403 | ❌ Hidden/403 |
| SEC-006 | Delete Evidence | ✅ Access | ✅ Access | ❌ Hidden/403 | ❌ Hidden/403 | ❌ Hidden/403 |
| SEC-007 | Create Assessment | ✅ Access | ✅ Access | ❌ Hidden/403 | ❌ Hidden/403 | ❌ Hidden/403 |
| SEC-008 | Delete Assessment | ✅ Access | ✅ Access | ❌ Hidden/403 | ❌ Hidden/403 | ❌ Hidden/403 |
| SEC-009 | Create Condition | ✅ Access | ✅ Access | ❌ Hidden/403 | ❌ Hidden/403 | ❌ Hidden/403 |
| SEC-010 | Resolve Condition | ✅ Access | ✅ Access | ❌ Hidden/403 | ❌ Hidden/403 | ❌ Hidden/403 |
| SEC-011 | Issue Final Decision | ✅ Access | ✅ Access | ❌ Hidden/403 | ❌ Hidden/403 | ❌ Hidden/403 |
| SEC-012 | View Dashboard | ✅ Access | ✅ Access | ✅ Access | ✅ Access | ✅ Access |

### 9.2 RLS Data Isolation

| ID | Test | Actor A | Actor B | Expected |
|---|------|---------|---------|----------|
| SEC-013 | Researcher isolation | researcher_01 views Projects | researcher_02 views Projects | Each sees only own projects |
| SEC-014 | Admin visibility | admin views Projects | — | Sees all projects |
| SEC-015 | Committee isolation | chair_01 views meetings | chair_02 views meetings | Each sees only own committee meetings |
| SEC-016 | Review isolation | reviewer_01 views reviews | reviewer_02 views reviews | Each sees only assigned reviews |

### 9.3 API-Level Authorization

| ID | Test | Action | Expected |
|---|------|--------|----------|
| SEC-017 | No JWT request | `GET /api/v1/committee/accreditation/cycles` | 401 |
| SEC-018 | Expired JWT | `GET /api/v1/committee/accreditation/cycles` (expired token) | 401 |
| SEC-019 | RESEARCHER creates cycle | `POST /api/v1/committee/accreditation/cycles` as researcher | 403 |
| SEC-020 | RESEARCHER uploads evidence | `POST /api/v1/committee/accreditation/cycles/:id/evidence` as researcher | ✅ Allowed |
| SEC-021 | REVIEWER creates condition | `POST /api/v1/committee/accreditation/conditions` as reviewer | 403 |

### 9.4 403 UX Handling

| ID | Test | Expected UX |
|---|------|-------------|
| SEC-022 | Hidden button (no permission) | Button not rendered in DOM |
| SEC-023 | API 403 on mutation | Toast: "You do not have permission" |
| SEC-024 | API 401 on session expiry | Redirect to login, no data leak |

---

## 10. Gate 4 — Data Integrity

**Objective:** Verify that after every operation, the database is in a consistent, correct state.

### 10.1 Structural Integrity

| ID | Check | SQL / Method | Expected |
|---|-------|-------------|----------|
| DAT-001 | All FK constraints enabled | `SELECT conname FROM pg_constraint WHERE contype = 'f'` | All expected FKs present |
| DAT-002 | No orphan records | `SELECT * FROM table WHERE fk_col NOT IN (SELECT id FROM ref_table)` | 0 rows for all FKs |
| DAT-003 | No duplicate UNIQUE violations | `SELECT col, COUNT(*) FROM table GROUP BY col HAVING COUNT(*) > 1` | 0 rows |
| DAT-004 | Sequences match row counts | `SELECT MAX(id) FROM table` vs sequence `last_value` | Consistent |
| DAT-005 | CHECK constraints honored | `SELECT * FROM table WHERE check_constraint_is_false` | 0 rows |

### 10.2 Audit Field Integrity

| ID | Check | Expected |
|---|-------|----------|
| DAT-006 | `created_by` is never NULL for audited tables | Every row has a creator |
| DAT-007 | `created_at` is never NULL for audited tables | Every row has a creation timestamp |
| DAT-008 | `updated_at` ≥ `created_at` for updated rows | Time moves forward |
| DAT-009 | `deleted_at` IS NULL for active rows | Soft delete pattern respected |
| DAT-010 | `updated_by` matches a valid user | FK to `users.id` |

### 10.3 State Machine Integrity

| ID | State Machine | Check | Expected |
|---|---------------|-------|----------|
| DAT-011 | Accreditation cycles | No cycle has invalid status | `status IN ('PENDING','UNDER_REVIEW','ACCREDITED','CONDITIONAL','SUSPENDED','EXPIRED','REVOKED')` |
| DAT-012 | Accreditation cycles | No cycle has impossible transition history | Each decision's `from_status → to_status` is a valid transition |
| DAT-013 | Evidence | All evidence statuses valid | `status IN ('PENDING','SUBMITTED','ACCEPTED','REJECTED','EXPIRED')` |
| DAT-014 | Conditions | All condition statuses valid | `status IN ('OPEN','MET','OVERDUE','WAIVED')` |
| DAT-015 | Conditions | Resolved conditions have `resolved_at` | `resolved_at` IS NOT NULL when status IN ('MET','WAIVED') |

### 10.4 Workflow Integrity

| ID | Check | Expected |
|---|-------|----------|
| DAT-016 | Every application has exactly one active workflow instance | 1:1 relationship |
| DAT-017 | Workflow transitions are sequential (no gaps) | `created_at` timestamps are monotonic |
| DAT-018 | No workflow in "IN_PROGRESS" for > 90 days | Stale workflows flagged |

---

## 11. Gate 5 — Non-Functional

**Objective:** Verify performance, security, and operational resilience.

### 11.1 Performance

| ID | Test | Target | Method |
|---|------|--------|--------|
| NFR-001 | Accreditation cycles list API | < 500ms | `curl -w "%{time_total}"` |
| NFR-002 | Cycle detail with inline subqueries | < 800ms | Chrome DevTools Network |
| NFR-003 | Dashboard page (4 parallel queries) | < 3s aggregate | `performance.now()` or DevTools |
| NFR-004 | Evidence upload (1MB PDF) | < 3s | multer timing |
| NFR-005 | Login + JWT generation | < 200ms | `curl -w` |
| NFR-006 | DataTable render (100 rows) | < 1s | React DevTools Profiler |
| NFR-007 | Page transition (lazy load) | < 1.5s | Lighthouse |

### 11.2 Concurrency

| ID | Scenario | Expected |
|---|----------|----------|
| NFR-008 | Two admins create cycle for same committee simultaneously | One succeeds (201), second gets 409 |
| NFR-009 | Two admins issue decision on same cycle | First succeeds, second gets error |
| NFR-010 | Upload evidence while another admin reviews | Transaction isolation; no lost updates |
| NFR-011 | Mutate conditions while dashboard loads | Dashboard may show stale data (eventual consistency acceptable) |

### 11.3 Security

| ID | Test | Method | Expected |
|---|------|--------|----------|
| NFR-012 | SQL injection in search fields | `' OR 1=1--` in search box | Parameterized query, no injection |
| NFR-013 | XSS in condition_text | `<script>alert(1)</script>` | Sanitized, not executed |
| NFR-014 | Rate limiting on login | 20 rapid requests | 429 after threshold |
| NFR-015 | JWT tampering | Modify token payload | 401, rejected |
| NFR-016 | File upload validation | Upload `.exe`, `.sh` | Rejected by multer config |
| NFR-017 | CORS | `curl -H "Origin: https://evil.com"` | Blocked |
| NFR-018 | Helmet security headers | `curl -I` | XSS Protection, CSP, etc. present |

### 11.4 Backup & Recovery

| ID | Test | Steps | Expected |
|---|------|-------|----------|
| NFR-019 | Database backup | `pg_dump -U postgres ethics_db > backup.sql` | Complete dump, no errors |
| NFR-020 | Restore from backup | `psql -U postgres -d ethics_db_test < backup.sql` | All data intact, sequences correct |
| NFR-021 | Backup during active write | Run backup while creating cycle | Consistent snapshot |
| NFR-022 | Application restart | `docker-compose restart backend` | Backend recovers, no data loss |

### 11.5 Large Dataset

| ID | Scenario | Concern |
|---|----------|---------|
| NFR-023 | 5000 evidence records per cycle | DataTable pagination, query timeout |
| NFR-024 | 200 conditions per cycle | Dashboard query aggregation |
| NFR-025 | 50 assessors per cycle | Consensus table rendering |

---

## 12. Gate 6 — UAT

**Objective:** Real-world scenarios executed by end users representing each role. These are unscripted explorations based on user stories.

### 12.1 UAT Scenarios

| ID | Scenario | Actor | Focus |
|---|----------|-------|-------|
| UAT-001 | "أريد تقديم طلب بحثي جديد" | RESEARCHER | Project → Application → Upload → Submit |
| UAT-002 | "أريد مراجعة الطلبات المسندة إلي" | REVIEWER | Review list → Read application → Submit review |
| UAT-003 | "أريد عقد اجتماع اللجنة" | COMMITTEE_CHAIR | Create meeting → Agenda → Attendance → Vote |
| UAT-004 | "أريد متابعة اعتماد اللجنة" | ETHICS_ADMIN | Cycles → Evidence → Assessments → Conditions → Decision |
| UAT-005 | "أريد تقريراً عن أداء النظام" | SUPER_ADMIN | Reports → Filter → Export |
| UAT-006 | "أريد البحث عن طلب معين" | Any role | Search by title, number, status, date range |

### 12.2 User Acceptance Criteria

| ID | Criterion | Method |
|---|-----------|--------|
| UAT-007 | All labels and messages in correct language | Visual inspection (Ar/En) |
| UAT-008 | RTL layout is correct for Arabic | Visual inspection |
| UAT-009 | Error messages are clear and actionable | Trigger errors intentionally |
| UAT-010 | Navigation between related pages is intuitive | Complete flows without using browser back |
| UAT-011 | Loading states show feedback | Observe during slow network |
| UAT-012 | Forms validate before submission | Submit empty forms |

---

## 13. Production Data Validation

**Objective:** After every Gate execution, verify that the database state matches what the UI reported. Do not trust the UI alone — verify the data layer.

### 13.1 Post-Scenario DB Checklist

After **every** scenario (not just UAT), run this checklist:

```sql
-- 1. Record counts match expectations
SELECT 'applications' AS entity, COUNT(*) FROM core.applications
UNION ALL SELECT 'projects', COUNT(*) FROM core.projects
UNION ALL SELECT 'reviews', COUNT(*) FROM committee.reviews
UNION ALL SELECT 'meetings', COUNT(*) FROM committee.meetings
-- ... per scenario

-- 2. No orphan records
SELECT * FROM core.applications WHERE project_id NOT IN (SELECT id FROM core.projects);
SELECT * FROM committee.reviews WHERE application_id NOT IN (SELECT id FROM core.applications);
SELECT * FROM committee.accreditation_evidence WHERE cycle_id NOT IN (SELECT id FROM committee.accreditation_cycles);
SELECT * FROM committee.accreditation_conditions WHERE cycle_id NOT IN (SELECT id FROM committee.accreditation_cycles);
-- Repeat for all FK relationships

-- 3. Audit fields populated
SELECT id, created_by, created_at, updated_at
FROM core.applications
WHERE created_by IS NULL OR created_at IS NULL;  -- 0 rows

-- 4. Status values within allowed range
SELECT DISTINCT status FROM committee.accreditation_cycles;   -- subset of allowed values
SELECT DISTINCT status FROM committee.accreditation_evidence; -- subset of allowed values
SELECT DISTINCT status FROM committee.accreditation_conditions;-- subset of allowed values

-- 5. Workflow state machine check
SELECT wf.id, wf.status, wf.current_step_id, wf.updated_at
FROM workflow.workflow_instances wf
WHERE wf.application_id = :appId;  -- Verify expected transition path

-- 6. Notification delivery check
SELECT * FROM notifications
WHERE entity_type = 'application' AND entity_id = :appId
AND user_id = :expectedUserId;  -- Verify notification was sent
```

### 13.2 Data Validation Per Accreditation Gate

| Gate | Validation Queries |
|------|-------------------|
| **Gate 2 — Functional** | After INT-FLOW-02: Verify `accreditation_cycles` row, `accreditation_evidence` rows (12), `accreditation_assessments` + items, `accreditation_conditions` (N), `accreditation_decisions` (≥2) |
| **Gate 3 — Role** | After each role action: Verify that forbidden mutations produced no DB changes (compare `updated_at` timestamps) |
| **Gate 4 — Data Integrity** | Full structural integrity scan of all 40+ tables |
| **Gate 5 — Non-Functional** | After backup/restore: Full row count + checksum comparison |
| **Gate 6 — UAT** | After each UAT scenario: Run the full post-scenario checklist above |

### 13.3 Automated Validation Script

A script `scripts/validate-data-integrity.sql` should be created and run after each Gate:

```sql
-- Core integrity checks
DO $$
DECLARE
  orphan_count INT;
BEGIN
  -- Check all FK relationships
  SELECT COUNT(*) INTO orphan_count FROM core.applications a
    LEFT JOIN core.projects p ON a.project_id = p.id WHERE p.id IS NULL;
  ASSERT orphan_count = 0, 'Orphan applications found';

  SELECT COUNT(*) INTO orphan_count FROM committee.accreditation_evidence e
    LEFT JOIN committee.accreditation_cycles c ON e.cycle_id = c.id WHERE c.id IS NULL;
  ASSERT orphan_count = 0, 'Orphan evidence found';

  -- Add all other FK checks...

  RAISE NOTICE 'All integrity checks passed';
END $$;
```

---

## 14. Module Integration Matrix

### 14.1 Data Flow Dependencies

| From | To | Interface | Tested | Notes |
|------|----|-----------|--------|-------|
| Institutions | Committees | FK `committee.institution_id` | ✅ | Committee creation |
| Committees | Accreditation Cycles | FK `cycle.committee_id` | ✅ | P3 core |
| Committees | Meetings | FK `meeting.committee_id` | ✅ | |
| Committees | Members | FK `committee_member.committee_id` | ✅ | |
| Standard Versions | Accreditation Cycles | FK `cycle.standard_version_id` | ✅ | P3 core |
| Standard Versions | Evidence | FK `evidence.standard_version_id` | ✅ | P3 core |
| Standard Versions | Assessment Items | FK `assessment_item.standard_version_id` | ✅ | P3 core |
| Cycles | Evidence | FK `evidence.cycle_id` | ✅ | P3 |
| Cycles | Assessments | FK `assessment.cycle_id` | ✅ | P3 |
| Assessments | Assessment Items | FK `assessment_item.assessment_id` | ✅ | P3 |
| Assessments | Conditions | FK `condition.assessment_id` | ✅ | P3 B.2 |
| Cycles | Conditions | FK `condition.cycle_id` | ✅ | P3 B.2 |
| Cycles | Decisions | FK `decision.cycle_id` | ✅ | P3 |
| Users | Cycles (created_by) | FK | ✅ | Audit |
| Users | Decisions (decided_by) | FK | ✅ | Audit |
| Documents | Evidence | FK `evidence.document_id` | ✅ | |
| Projects | Applications | FK `application.project_id` | ✅ | |
| Applications | Reviews | FK `review.application_id` | ✅ | |
| Applications | Meetings (agenda) | FK `agenda_item.application_id` | ✅ | |
| Workflow | Applications | state machine | ✅ | |
| Workflow | Notifications | automated trigger | ❌ | RC2 |

### 14.2 API Coverage

| Module | Routes | GET | POST | PUT/PATCH | DELETE |
|--------|--------|:---:|:----:|:---------:|:------:|
| Auth | 2 | 0 | 2 | 0 | 0 |
| Users | 8 | 4 | 1 | 2 | 1 |
| Roles | 5 | 2 | 1 | 1 | 1 |
| Committees | 8 | 4 | 1 | 2 | 1 |
| Members | 4 | 2 | 1 | 1 | 0 |
| Projects | 6 | 3 | 1 | 1 | 1 |
| Applications | 6 | 3 | 1 | 1 | 1 |
| Reviews | 4 | 2 | 0 | 2 | 0 |
| Meetings | 8 | 4 | 2 | 2 | 0 |
| Voting | 4 | 2 | 1 | 1 | 0 |
| Accreditation | 18 | 8 | 4 | 4 | 2 |
| Evidence | 4 | 2 | 1 | 0 | 1 |
| Safety | 6 | 3 | 3 | 0 | 0 |
| Documents | 4 | 2 | 1 | 0 | 1 |
| Messages | 4 | 2 | 2 | 0 | 0 |
| Reporting | 2 | 2 | 0 | 0 | 0 |
| Admin | 6 | 3 | 1 | 1 | 1 |
| **Total** | **~95** | **~50** | **~24** | **~16** | **~8** |

---

## 15. Negative & Edge Cases

### 15.1 Application Lifecycle Edge Cases

| ID | Scenario | Expected Outcome |
|---|----------|------------------|
| NEG-001 | Reviewer rejects application | Status → REJECTED, researcher notified |
| NEG-002 | Reviewer requests revisions | Status → REVISION_REQUIRED, researcher can resubmit |
| NEG-003 | Researcher resubmits after revisions | Workflow continues, reviewer reassigned |
| NEG-004 | Committee member withdraws mid-review | Meeting reconfigured, quorum recalculated |
| NEG-005 | Quorum not met for meeting | Voting disabled, meeting postponed |
| NEG-006 | Password reset while application is under review | No data loss, session invalidated |
| NEG-007 | Researcher uploads new protocol version during review | Version history preserved, reviewer notified |
| NEG-008 | Multiple reviewers assigned, decisions conflict | Consensus logic resolves (e.g., chair decides) |
| NEG-009 | Application reopened after final decision | New review cycle initiated, audit trail preserved |
| NEG-010 | Consent form expires during review | Reviewer warned, researcher asked to renew |

### 15.2 Accreditation Edge Cases

| ID | Scenario | Expected Outcome |
|---|----------|------------------|
| NEG-011 | Cycle created for committee with active cycle | 409 error: "Already has an active cycle" |
| NEG-012 | Transition from PENDING directly to ACCREDITED | 422 error: "Invalid transition" |
| NEG-013 | Issue decision without decision_reason for CONDITIONAL | Form validation prevents submission |
| NEG-014 | Delete evidence that is part of an accepted set | Evidence removed, status unaffected |
| NEG-015 | Resolve already-resolved condition | 404 / condition already in final state |
| NEG-016 | Create condition with past due_date | Allowed (back-dated conditions) |
| NEG-017 | Upload evidence with no document attached | API error: document required |
| NEG-018 | Dashboard with zero assessments | All cards show 0 or "Awaiting Data" |
| NEG-019 | Dashboard with zero conditions | No conditions shown, no errors |
| NEG-020 | Expired cycle → attempt status change | No available transitions |

### 15.3 Data Edge Cases

| ID | Scenario | Expected Outcome |
|---|----------|------------------|
| NEG-021 | Arabic text with special characters in condition_text | Stored and displayed correctly (UTF-8) |
| NEG-022 | Extremely long condition_text (10,000 chars) | Stored, UI truncates with ellipsis |
| NEG-023 | Upload oversized file (500MB) | Rejected by multer/file size limit |
| NEG-024 | Concurrent login same user, two sessions | Both active, last write wins |
| NEG-025 | Network timeout during decision issue | UI shows error, no partial state |
| NEG-026 | Delete a committee that has active cycles | FK constraint prevents deletion |

---

## 16. Regression Suite

### 16.1 Smoke Tests (Run after every PR/change)

| ID | Test | Expected |
|----|------|----------|
| S-01 | System boots | `docker-compose up` → 3/3 healthy |
| S-02 | Login as admin | Dashboard loads, no errors |
| S-03 | Accreditation cycles list | Renders without error |
| S-04 | Create cycle | 201, cycle visible in list |
| S-05 | Logout | Session terminated |
| S-06 | Login as RESEARCHER | Read-only access confirmed |

### 16.2 Regression Tests (Before every Release Candidate)

| ID | Module | Test | Expected |
|----|--------|------|----------|
| REG-01 | Auth | Login with all 5 roles | 5/5 succeed |
| REG-02 | Auth | Invalid credentials | 401 |
| REG-03 | Accreditation | Full cycle (INT-FLOW-02) | All steps pass |
| REG-04 | Accreditation | Role restrictions | All roles correct |
| REG-05 | Evidence | Upload + review + delete | CRUD complete |
| REG-06 | Assessments | Create + score calculation | Score % correct |
| REG-07 | Conditions | Create + resolve | Status transitions work |
| REG-08 | Dashboard | Recommendation engine | All 4 scenarios correct |
| REG-09 | Projects | CRUD | All operations |
| REG-10 | Applications | Submit + workflow | State machine correct |
| REG-11 | Meetings | Create + agenda + vote | Full lifecycle |
| REG-12 | Safety | Report + review + track | Full lifecycle |
| REG-13 | Documents | Upload + delete | File storage correct |
| REG-14 | RLS | SUPER_ADMIN vs RESEARCHER | Data isolation |

### 16.3 Full Certification (Before Pilot)

Complete execution of:
- All 14 Regression Tests
- All 6 Gates
- All Non-Functional Tests (Section 10)
- All 5 Browser targets
- Data integrity check (row counts, FK constraints)

---

## 17. Defect Severity Matrix

Every defect found during testing must be classified using the table below. RC1.2 **cannot be released** with any open Critical or High defects.

### 17.1 Severity Levels

| Severity | Definition | Examples | Release Blocking? |
|----------|------------|----------|:-----------------:|
| **Critical** | Data loss, security breach, system unavailability, privilege escalation | Unauthorized data access, data corruption, 500 error on critical endpoint, RLS bypass | **Yes** |
| **High** | Core workflow broken, major feature unusable, incorrect business logic | Workflow state machine allows invalid transition, assessment score calculated incorrectly, evidence cannot be reviewed | **Yes** |
| **Medium** | Feature works but partially, non-critical path broken, UX issue | DataTable sort not working, filter returns wrong results, missing validation on optional field | No |
| **Low** | Cosmetic issue, translation missing, minor layout problem | Wrong label color, missing tooltip, padding inconsistent, RTL minor glitch | No |

### 17.2 Defect Tracking

| Field | Required | Example |
|-------|:--------:|---------|
| ID | ✅ | `BUG-042` |
| Gate | ✅ | `Gate 2 — Functional` |
| Severity | ✅ | `High` |
| Module | ✅ | `Accreditation — Conditions` |
| Summary | ✅ | `Creating condition without due_date still submits form` |
| Steps to Reproduce | ✅ | 1. Open Conditions for cycle X. 2. Leave due_date empty. 3. Submit. |
| Expected | ✅ | Form validation prevents submission |
| Actual | ✅ | API returns 201 with NULL due_date |
| Evidence | ✅ | Screenshot / API Log / SQL query |
| Status | ✅ | `Open` / `In Progress` / `Fixed` / `Verified` / `Closed` |
| Reported By | ✅ | `tester_01` |
| Assigned To | ✅ | `dev_02` |

### 17.3 Bug Lifecycle

```text
Found → Open → [Triage] → In Progress → Fixed → Verified → Closed
                         ↕
                     Won't Fix / Deferred
```

| Phase | Gate | Action |
|-------|------|--------|
| **Triage** | Daily during test execution | Severity + priority confirmed by lead |
| **Fix** | Within 24h for Critical/High | Developer fixes on `develop` branch |
| **Verify** | Same day as fix | Tester re-runs the failing test case |
| **Close** | After verification | Bug confirmed resolved |

### 17.4 Severity Counts — Per Gate

| Gate | Tested | Critical | High | Medium | Low | Pass Rate |
|:----:|:------:|:--------:|:----:|:-----:|:---:|:---------:|
| 1 — Smoke | 48 | — | — | — | — | — |
| 2 — Functional | — | — | — | — | — | — |
| 3 — Role & Security | — | — | — | — | — | — |
| 4 — Data Integrity | — | — | — | — | — | — |
| 5 — Non-Functional | — | — | — | — | — | — |
| 6 — UAT | — | — | — | — | — | — |
| **Total** | — | **0** | **0** | **0** | **0** | **—** |


## 18. Exit Criteria

### 18.1 Mandatory Gates

| ID | Criterion | Target | Verifier |
|---|-----------|--------|----------|
| E-01 | TypeScript compilation (backend) | 0 errors | `tsc --noEmit` |
| E-02 | TypeScript compilation (frontend) | 0 errors | `tsc --noEmit` |
| E-03 | Backend unit tests | 100% pass | `npm test` |
| E-04 | Frontend build | Success | `npm run build` |
| E-05 | Docker build (all 3 services) | Success | `docker-compose build` |
| E-06 | Gate 1 — Smoke Test | 100% pass | Manual |
| E-07 | Gate 2 — Functional Integration | ≥ 95% pass | Manual |
| E-08 | Gate 3 — Role & Security | 100% pass | Manual |
| E-09 | Gate 4 — Data Integrity | 100% pass | SQL queries |
| E-10 | Gate 5 — Non-Functional | Within thresholds | Tools |
| E-11 | Gate 6 — UAT | User acceptance | Users |
| E-12 | No critical security findings | 0 | Code review + tools |
| E-13 | Backup & restore verified | Successful | `pg_dump` + `pg_restore` |
| E-14 | E2E CI pipeline (GitHub Actions) | Green | CI run on `develop` |

### 18.2 Quality Gates

| # | Criterion | Target |
|---|-----------|--------|
| Q-01 | Page load time (accreditation screens) | < 3s |
| Q-02 | API response time (p95) | < 1s |
| Q-03 | Browser compatibility | 5/5 targets pass |
| Q-04 | RTL layout (Arabic) | No layout breaks |
| Q-05 | Translation coverage | ≥ 95% keys translated |

### 18.3 Release Decision

RC1.2 is declared ready when:

> **All E (Mandatory) gates pass at 100%.**
>
> All Q (Quality) gates meet or exceed targets.
>
> Zero P0/P1 bugs open.
>
> Code Freeze applied to `develop` branch.
>
> Release tag `rc1.2` created.

---

## 19. Traceability Matrix

### 19.1 Accreditation Module

| Requirement | Database | API | Frontend | Test | UAT |
|-------------|:--------:|:---:|:--------:|:----:|:---:|
| Accreditation Cycles CRUD | `accreditation_cycles` | `GET/POST /cycles` | CyclesList.tsx | REG-03 | AC-01 |
| Cycle Status State Machine | `chk_cycle_status` | `PATCH /cycles/:id/status` | CyclesList (StatusDialog) | REG-03 | AC-01 |
| Evidence Management | `accreditation_evidence` | `GET/POST /evidence` | Evidence.tsx | REG-05 | AC-01 |
| Evidence Review | `accreditation_evidence.status` | `PATCH /evidence/:id/status` | Evidence.tsx | REG-05 | AC-01 |
| Assessment CRUD | `accreditation_assessments` | `GET/POST /assessments` | AssessmentsList.tsx | REG-06 | AC-01 |
| Assessment Items (12 standards) | `accreditation_assessment_items` | `PUT /assessments/:id/items` | AssessmentsList.tsx | REG-06 | AC-01 |
| Score Calculation | `overall_score` | Computed in service | AssessmentsList (avgScore) | REG-06 | AC-01 |
| Condition CRUD | `accreditation_conditions` | `GET/POST /conditions` | ConditionsList.tsx | REG-07 | AC-02 |
| Condition Resolution | `conditions.status` | `PATCH /conditions/:id/status` | ConditionsList.tsx | REG-07 | AC-02 |
| Condition Severity | `conditions.severity` | In GET response | ConditionsList (badge) | REG-07 | AC-02 |
| Decision Dashboard | Aggregate Queries | GET /cycles/:id + /assessments + /evidence | Dashboard.tsx | REG-08 | AC-01 |
| Recommendation Engine | Client-side compute | — | Dashboard.tsx (computeRecommendation) | REG-08 | AC-01 |
| Final Decision / State Machine | `accreditation_decisions` | `PATCH /cycles/:id/status` | Dashboard.tsx (Decision Panel) | REG-03 | AC-01 |
| RLS: SUPER_ADMIN full access | RLS policies | authorize() middleware | — | REG-14 | AC-04 |
| RLS: Read-only for RESEARCHER | RLS policies | authorize() middleware | — | REG-14 | AC-04 |
| Audit Trail | `accreditation_decisions` | GET /cycles/:id (inline) | CycleDetail.tsx | REG-03 | AC-01 |
| Bilingual UI | — | — | i18next (en/ar) | Q-05 | — |

### 19.2 Cross-Module Traceability

| Requirement | Database | API | UI | Test |
|-------------|:--------:|:---:|:--:|:----:|
| Institution linked to Committee | FK chain | Committee routes | CommitteeDetail | INT-01 |
| Committee linked to Cycle | FK | Accreditation routes | CycleDetail | INT-01 |
| Document linked to Evidence | FK | Evidence routes | Evidence | INT-01 |
| User audit (created_by, etc.) | Audit columns | Middleware | — | REG-03 |
| Committee structure | committee.* tables | Committee routes | Committees, Members | REG-09 |

---

## 20. Requirement Coverage Matrix

**Objective:** Ensure every functional requirement is covered by at least one test. This matrix is the executive answer to: *"Did we test everything?"*

### 20.1 Accreditation Module

| Requirement | DB | API | UI | Test ID | Status |
|------------|:--:|:---:|:--:|---------|:------:|
| User Registration | ✓ | ✓ | ✓ | INT-001 | Covered |
| Login with all roles | ✓ | ✓ | ✓ | SMK-009–014, INT-002 | Covered |
| Create Research Project | ✓ | ✓ | ✓ | INT-003 | Covered |
| Submit Application | ✓ | ✓ | ✓ | INT-006 | Covered |
| Scientific Review | ✓ | ✓ | ✓ | INT-008 | Covered |
| Ethics Review | ✓ | ✓ | ✓ | INT-009 | Covered |
| Risk Assessment | ✓ | ✓ | ✓ | INT-010 | Covered |
| Committee Meeting & Agenda | ✓ | ✓ | ✓ | INT-011 | Covered |
| Attendance & Quorum | ✓ | ✓ | ✓ | INT-012, NEG-005 | Covered |
| Voting & Tally | ✓ | ✓ | ✓ | INT-013–015 | Covered |
| Decision Issuance | ✓ | ✓ | ✓ | INT-016 | Covered |
| Consent Review | ✓ | ✓ | ✓ | INT-017 | Covered |
| Final Approval | ✓ | ✓ | ✓ | INT-018 | Covered |
| Notification Delivery | ✓ | — | ✓ | INT-019 | Covered |
| Audit Trail | ✓ | ✓ | ✓ | INT-020 | Covered |

### 20.2 Accreditation Module (P3)

| Requirement | DB | API | UI | Test ID | Status |
|------------|:--:|:---:|:--:|---------|:------:|
| Create Accreditation Cycle | ✓ | ✓ | ✓ | INT-023 | Covered |
| Upload Evidence (12 standards) | ✓ | ✓ | ✓ | INT-025 | Covered |
| Review & Accept Evidence | ✓ | ✓ | ✓ | INT-027 | Covered |
| Create Assessment (score 1–4) | ✓ | ✓ | ✓ | INT-028 | Covered |
| Score Calculation (%) | ✓ | ✓ | ✓ | INT-029 | Covered |
| Create Conditions | ✓ | ✓ | ✓ | INT-030 | Covered |
| Condition Resolution (MET/WAIVED) | ✓ | ✓ | ✓ | INT-034, INT-041–042 | Covered |
| Decision Dashboard | ✓ | ✓ | ✓ | INT-031–032 | Covered |
| Conditional Decision | ✓ | ✓ | ✓ | INT-033, NEG-013 | Covered |
| Suspend/Resume/Revoke | ✓ | ✓ | ✓ | INT-046–051 | Covered |
| Cycle Expiry | ✓ | ✓ | ✓ | INT-037 | Covered |
| RBAC: Admin creates Cycle | — | ✓ | ✓ | SEC-002 | Covered |
| RBAC: Researcher cannot create Cycle | — | ✓ | ✓ | SEC-019 | Covered |
| RLS: Researcher sees own data | ✓ | ✓ | ✓ | SEC-013 | Covered |

### 20.3 Cross-Cutting Requirements

| Requirement | Verified By | Status |
|------------|-------------|:------:|
| Authentication (JWT, session) | SMK-009–018, INT-002 | Covered |
| Authorization (RBAC) | SEC-001–024 | Covered |
| Data Integrity (FKs, audit, state machine) | DAT-001–018 | Covered |
| Input Validation (Zod schemas) | NEG-013, NEG-017, NEG-023 | Covered |
| Error Handling (403, 401, 500) | SEC-022–024, SMK-015 | Covered |
| Arabic/RTL Support | SMK-037, UAT-008 | Covered |
| Performance (< 3s pages) | NFR-001–007 | Covered |
| Security (XSS, SQLi, CORS) | NFR-012–018 | Covered |
| Backup & Recovery | NFR-019–022 | Covered |
| Multi-Assessor Consensus | INT-FLOW-02 (deferred to UAT) | Partial |
| Notification Automation | INT-019 | Covered |

### 20.4 Requirements Not Yet Covered

| Requirement | Gap | Action |
|------------|-----|--------|
| Accreditation Certificate PDF | Out of scope (RC2) | Deferred |
| KPI Dashboard | Out of scope (RC2) | Deferred |
| Public Certificate Verification | Out of scope (RC2) | Deferred |
| Notification automation for accreditation lifecycle | Out of scope (RC2) | Deferred |
| Multi-assessor consensus threshold config | Out of scope (RC2) | Deferred |
| Condition-evidence linking (file upload per condition) | Out of scope (RC2) | Deferred |

---

## 21. Execution Roadmap

### 21.1 Phase 1 — Gate Execution (Weeks 1–3)

| Week | Gate | Activities | Dependencies |
|:----:|:----:|------------|:-----------:|
| **1** | **Gate 1 — Smoke** | Build verification, infrastructure check, basic login/logout | Clean seed |
| **1** | **Gate 2 — Functional** | INT-FLOW-01 (E2E research lifecycle) + INT-FLOW-02 (Accreditation) + INT-FLOW-03/04/05 | Gate 1 pass |
| **2** | **Gate 3 — Role & Security** | 24 RBAC checks, RLS data isolation, API auth, 403 UX | Gate 2 pass |
| **2** | **Gate 4 — Data Integrity** | Full structural scan, audit fields, state machine, workflow integrity | Gate 3 pass |
| **3** | **Gate 5 — Non-Functional** | Performance, concurrency, security, backup/restore, large dataset | Gate 4 pass |
| **3** | **Gate 6 — UAT** | 6 user scenarios, language/RTL validation, usability review | Gate 5 pass |

### 21.2 Phase 2 — Bug Fixing & Hardening (Week 4)

| Activity | Goal |
|----------|------|
| Triage all P0/P1 bugs opened during Gates | Zero P0/P1 |
| Fix failed test cases | All Gates at 100% |
| Address UX feedback from UAT | User satisfaction |
| Performance optimization for slow queries | Within thresholds |
| Final `tsc --noEmit` + `npm test` + `npm run build` | Clean |

### 21.3 Phase 3 — Code Freeze & RC1.2 (End of Week 4)

| Action | Detail |
|--------|--------|
| Code Freeze | `develop` branch locked |
| Release tag | `git tag rc1.2` |
| Docker images | Push to GHCR |
| Release notes | Changelog + known limitations |
| Documentation | Master plan finalized |

### 21.4 Phase 4 — Operational Pilot RC1.2.1 (Weeks 5–8)

> Recommended before starting any RC2 work.

**Duration:** 2–4 weeks  
**Environment:** Semi-production (staging with real data)  
**Users:** 10–15 real users across all roles  
**Rules:** No new features — only bug fixes and stability

| Week | Activity |
|:----:|----------|
| **5** | Deploy RC1.2 to staging; onboard pilot users; train on 6 accreditation screens |
| **6** | Active pilot usage; log all issues in tracker; daily triage |
| **7** | Fix critical issues; second round of pilot usage |
| **8** | Retrospective; go/no-go decision for RC2 |

**Pilot Success Criteria:**
- All pilot users have completed at least one full workflow
- Zero data loss incidents
- Average page load < 3s
- No P0/P1 bugs found in final week
- User satisfaction survey ≥ 4/5

**If Pilot Fails:**
- Extend pilot by 1–2 weeks
- Address root causes
- Re-run failed scenarios
- New go/no-go decision

**If Pilot Passes:**
- Begin RC2 planning
- Confidence that the system is production-ready
- All RC2 features built on a proven foundation

---

## 22. Test Evidence & Metrics

### 22.1 Required Evidence Per Gate

Every Gate execution must produce the following evidence artifacts. These make post-test reviews and debugging significantly faster.

| # | Artifact | Format | Responsibility | Example |
|---|----------|--------|---------------|---------|
| EV-01 | Screenshot of each passing screen | PNG | Tester | `gate1-batchC-1C-08-cycles-list.png` |
| EV-02 | API request/response for each mutation | JSON (console copy) | Tester | `gate2-INT-FLOW-01-step3-create-project.json` |
| EV-03 | SQL validation output | TXT / CSV | Tester | `gate4-D-01-orphan-check.sql` |
| EV-04 | Audit log entries | JSON / SQL | Tester | `gate2-INT-FLOW-01-step20-audit-log.sql` |
| EV-05 | Notification content | JSON | Tester | `gate2-INT-FLOW-01-step19-notification.json` |
| EV-06 | Browser console capture | TXT | Tester | `gate1-batchC-console-errors.txt` |
| EV-07 | Server/backend logs | TXT (last 100 lines) | Tester | `gate1-batchA-backend-logs.txt` |
| EV-08 | Docker health status | `docker-compose ps` output | Tester | `gate1-batchA-docker-status.txt` |
| EV-09 | Failed test reproduction steps | MD | Tester | `BUG-042-reproduction.md` |
| EV-10 | Performance timing | `curl -w` output | Tester | `gate5-N-01-cycles-list-time.txt` |

### 22.2 Evidence Directory Structure

```
evidence/
├── gate1-smoke/
│   ├── batchA-startup/
│   │   ├── 1A-01-docker-ps.txt
│   │   ├── 1A-02-pg-isready.txt
│   │   └── ...
│   ├── batchB-auth/
│   │   ├── 1B-02-login-admin.png
│   │   ├── 1B-07-invalid-credentials.png
│   │   └── ...
│   ├── batchC-navigation/
│   │   ├── 1C-08-cycles-list.png
│   │   ├── 1C-19-rtl-arabic.png
│   │   └── ...
│   └── batchD-api/
│       ├── 1D-01-login.json
│       ├── 1D-06-cycles.json
│       └── ...
├── gate2-functional/
│   ├── INT-FLOW-01/
│   │   ├── step01-register.json
│   │   ├── step03-create-project.json
│   │   ├── ...
│   │   └── step20-audit-log.sql
│   └── INT-FLOW-02/
│       └── ...
├── gate3-role/
├── gate4-integrity/
├── gate5-nonfunc/
├── gate6-uat/
└── README.md
```

### 22.3 Test Metrics Dashboard Template

After **every Gate**, update the metrics dashboard:

**Gate `[N]` — `[Name]` — `[Date]`**

| Metric | Value |
|--------|------:|
| Planned Tests | `[N]` |
| Executed | `[N]` |
| Passed | `[N]` |
| Failed | `[N]` |
| Blocked | `[N]` |
| **Pass Rate** | **`[X]%`** |
| Critical Bugs | `[N]` |
| High Bugs | `[N]` |
| Medium Bugs | `[N]` |
| Low Bugs | `[N]` |
| Coverage (of planned) | `[X]%` |

### 22.4 Cumulative Metrics (All Gates)

| Metric | G1 | G2 | G3 | G4 | G5 | G6 | **Total** |
|--------|:--:|:--:|:--:|:--:|:--:|:--:|:---------:|
| Planned | 48 | — | — | — | — | — | **—** |
| Executed | — | — | — | — | — | — | **—** |
| Passed | — | — | — | — | — | — | **—** |
| Failed | — | — | — | — | — | — | **—** |
| Pass Rate | — | — | — | — | — | — | **—** |
| Critical Bugs | — | — | — | — | — | — | **0** |
| High Bugs | — | — | — | — | — | — | **0** |

---

## 23. Release Sign-off

This page records the formal approval decision for RC1.2. Every role must sign before progressing to the Operational Pilot (RC1.2.1).

### 23.1 Release Approval

| Role | Name | Date | Signature | Status |
|------|------|:----:|:---------:|:------:|
| QA Lead | | | | ☐ Pending |
| Technical Lead | | | | ☐ Pending |
| Security Reviewer | | | | ☐ Pending |
| Product Owner | | | | ☐ Pending |
| Project Manager | | | | ☐ Pending |

### 23.2 Release Decision

> **☐ Approved for Pilot (RC1.2.1)**
>
> **☐ Approved for Production**
>
> **☐ Rejected — requires rework**
>
> **☐ Deferred — merged into RC2**

### 23.3 Sign-off Conditions

The release may be approved for **Pilot** only when:

1. All 6 Gates have passed at the required rate (see [§18 — Exit Criteria](#18-exit-criteria))
2. Zero Critical or High defects remain open (see [§17 — Defect Severity Matrix](#17-defect-severity-matrix))
3. All 14 Regression Tests pass at 100%
4. Baseline Snapshot ([§5.1](#51-baseline-snapshot)) is recorded and version-controlled
5. Test Freeze ([§5.2](#52-test-freeze-confirmation)) is confirmed in writing
6. Evidence artifacts for all 6 Gates are archived (see [§22 — Evidence & Metrics](#22-test-evidence--metrics))

### 23.4 Post-Sign-off Actions

| Action | Owner | Timeline |
|--------|-------|----------|
| Tag release `rc1.2` on `develop` | Tech Lead | Day of sign-off |
| Build Docker images with `rc1.2` tag | DevOps | Day of sign-off |
| Deploy to Pilot environment | DevOps | Within 2 days |
| Notify Pilot users | PM | Within 2 days |
| Begin Pilot (RC1.2.1) | All | Within 3 days |

---

## 24. Appendices

### A. Quick-Start Commands

```bash
# Start environment
docker-compose up -d

# Run migrations
cd backend && npm run migrate:up

# Run seeds (in order)
Get-ChildItem seed/*.sql | Sort-Object Name | ForEach-Object {
  psql -U postgres -d ethics_db -f $_.FullName
}

# Run tests
cd backend && npm test
cd frontend && npm test

# TypeScript check
cd backend && npx tsc --noEmit
cd frontend && npx tsc --noEmit

# Build
cd backend && npm run build
cd frontend && npm run build
```

### B. Test User Credentials

| Username | Password | Role |
|----------|----------|------|
| admin | Pilot@1234 | SUPER_ADMIN |
| ethics_admin | Pilot@1234 | ETHICS_ADMIN |
| chair_01 | Pilot@1234 | COMMITTEE_CHAIR |
| reviewer_01 | Pilot@1234 | REVIEWER |
| researcher_01 | Pilot@1234 | RESEARCHER |

### C. Key URLs

| Resource | URL |
|----------|-----|
| Application | `http://localhost` |
| Backend API | `http://localhost:8080/api/v1` |
| Swagger Docs | `http://localhost:8080/api-docs` |
| Database | `postgres://postgres:postgres@localhost:5432/ethics_db` |

### D. Known Limitations (RC1.2)

| # | Limitation | Impact | Planned For |
|---|------------|--------|-------------|
| 1 | No accreditation certificate PDF | Manual certificate issuance | RC2 |
| 2 | No KPI dashboard | Manual reporting | RC2 |
| 3 | No notification automation for accreditation | Admin must monitor manually | RC2 |
| 4 | Decision snapshot not persisted | Decision references current data | RC2 |
| 5 | valid_from/valid_until not auto-set by decision | Admin must set manually | RC1.3 |
| 6 | Multi-assessor consensus UI basic | Works but no consensus threshold config | RC2 |
| 7 | Condition-evidence linking | No file upload per condition | RC2 |

---

> **Document prepared for:** Ethics ERM System — RC1.2  
> **Review status:** Approved for Execution — Version 1.2  
> **Next action:** Begin **Gate 1 — Smoke Test** execution  
> **After RC1.2:** Operational Pilot (RC1.2.1) for 2–4 weeks before RC2 planning
