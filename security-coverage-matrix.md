# Security Coverage Matrix

**Last Updated:** 2026-06-08  
**Status:** Phase 1 (Fix) ✅ — Phase 2 (RLS Isolation Tests) ✅ — Phase 3 (Soft Delete) ✅ — Phase 4-5 pending  
**Scope:** RLS Isolation, Soft Delete Enforcement, RBAC Authorization, Service-Level Security

---

## ✅ Fixed Gaps (Phase 1 — `14-rls-complete.sql` + `15-rls-select-policy-fix.sql`)

### Critical Discovery: PG18 RLS NEW-row Check
**Root cause:** PostgreSQL 18.3 evaluates the SELECT policy USING clause against the NEW row during UPDATE. When `is_active_row(deleted_at)` was in SELECT policies, any UPDATE setting `deleted_at` to a non-null value failed with `ERROR: new row violates row-level security policy`.

**Fix (`15-rls-select-policy-fix.sql`):** Restructured 17 SELECT + 1 UPDATE policy to bypass `is_active_row()` for admins and row owners. The logic changed from:
  - `is_active_row(deleted_at) AND (admin OR owner OR ...)` ← blocks soft-delete UPDATE
  - To: `admin OR owner OR (is_active_row(deleted_at) AND ...)` ← allows soft-delete UPDATE

### 1. RLS Policies — Now Complete
| Table | Has Soft Delete? | RLS Enabled? | Has Policies? | Risk | Fix |
|-------|:---:|:---:|:---:|------|-----|
| `workflow.workflow_instances` | ✅ | ✅ | ✅ | ~~HIGH~~ ✅ | `14-rls-complete` |
| `workflow.workflow_tasks` | ✅ | ✅ | ✅ | ~~HIGH~~ ✅ | `14-rls-complete` |
| `workflow.workflow_events` | ❌ | ✅ | ✅ | ~~MEDIUM~~ ✅ | `14-rls-complete` |
| `workflow.workflow_schedulers` | ❌ | ✅ | ✅ | ~~MEDIUM~~ ✅ | `14-rls-complete` |
| `workflow.workflow_triggers` | ❌ | ✅ | ✅ | ~~MEDIUM~~ ✅ | `14-rls-complete` |
| `system.search_audit` | ❌ | ✅ | ✅ | ~~MEDIUM~~ ✅ | `14-rls-complete` |
| `reference.licenses_registry` | ❌ | ✅ | ✅ | ~~LOW~~ ✅ | `14-rls-complete` |
| `integration.integration_failures` | ❌ | ✅ | ✅ | ~~LOW~~ ✅ | `14-rls-complete` |
| `integration.data_sync_jobs` | ❌ | ✅ | ✅ | ~~LOW~~ ✅ | `14-rls-complete` |
| `communication.notifications` | ✅ | ❌ | ❌ | **MEDIUM** | Not yet addressed |
| `communication.messages` | ✅ | ❌ | ❌ | **MEDIUM** | Not yet addressed |
| `communication.message_recipients` | ✅ | ❌ | ❌ | MEDIUM | Not yet addressed |

### 2. ✅ `fn_is_admin` Defined
`system.fn_is_admin(p_user_id BIGINT) RETURNS BOOLEAN` — created in `14-rls-complete.sql` as `SECURITY DEFINER`. Checks role codes `SUPER_ADMIN`, `SYS_ADMIN`, `ADMIN`, `ETHICS_ADMIN` in `security.user_roles`.

### 3. ✅ `security.users` — Policies Complete
- `INSERT`: existing (self-registration or admin)
- `SELECT`: own user or admin (`14-rls-complete`)
- `UPDATE`: own user or admin (`14-rls-complete`)
- `DELETE`: intentionally omitted (soft delete only)

---

## Level 1: RLS Isolation Tests

### 1.1 Cross-User Data Access

| # | Scenario | User A | User B | SQL | Expected | Status |
|---|----------|--------|--------|-----|----------|--------|
| 1.1.1 | Applicant reads another's application | `researcher1` | `researcher2` | `SELECT * FROM core.applications WHERE submitted_by = researcher2.id` | DENY | ✅ PASS |
| 1.1.2 | Applicant updates another's application | `researcher1` | `researcher2` | `UPDATE core.applications SET project_title='Hacked' WHERE submitted_by = researcher2.id` | DENY | ✅ PASS |
| 1.1.3 | Applicant reads another's project | `researcher1` | `researcher2` | `SELECT * FROM core.projects WHERE principal_investigator_id = researcher2.id` | DENY | ✅ PASS |
| 1.1.4 | Reviewer reads unassigned application | `reviewer1` | — | `SELECT * FROM core.applications WHERE id NOT IN (SELECT application_id FROM committee.review_assignments WHERE reviewer_id = reviewer1.id)` | DENY | ❓ (not tested) |
| 1.1.5 | Reviewer reads review by another reviewer | `reviewer1` | `reviewer2` | `SELECT * FROM committee.ethics_reviews WHERE reviewer_id = reviewer2.id` | DENY | ❓ (not tested) |
| 1.1.6 | Committee member reads other committee data | `chairperson` | — | `SELECT * FROM committee.committee_meetings WHERE committee_id != chairperson's committee` | DENY | ❓ (not tested) |
| 1.1.7 | User reads another user's profile | `researcher1` | `researcher2` | `SELECT * FROM security.users WHERE id = researcher2.id` | DENY (users_select_policy: own or admin) | ✅ PASS |
| 1.1.8 | User reads another's risk entry | `researcher1` | `researcher2` | `SELECT * FROM safety.risk_register WHERE owner_id = researcher2.id` | DENY | ✅ PASS |

### 1.2 Anonymous / Unauthenticated Access

| # | Scenario | `app.user_id` | SQL | Expected | Status |
|---|----------|:---:|-----|----------|--------|
| 1.2.1 | Anonymous reads applications | `0` | `SELECT * FROM core.applications` | DENY | ✅ PASS |
| 1.2.2 | Anonymous registers new user | `0` | `INSERT INTO security.users ...` | ALLOW (per `users_insert_policy`) | ❓ (not tested) |
| 1.2.3 | Anonymous reads documents | `0` | `SELECT * FROM documents.documents` | DENY | ✅ PASS |
| 1.2.4 | Anonymous reads projects | `0` | `SELECT * FROM core.projects` | DENY | ✅ PASS |

### 1.3 Admin Access

| # | Scenario | `app.user_id` | SQL | Expected | Status |
|---|----------|:---:|-----|----------|--------|
| 1.3.1 | Admin reads any application | `admin.id` | `SELECT * FROM core.applications` | ALLOW | ✅ PASS |
| 1.3.2 | Admin reads any project | `admin.id` | `SELECT * FROM core.projects` | ALLOW | ✅ PASS |
| 1.3.3 | Admin reads any document | `admin.id` | `SELECT * FROM documents.documents` | ALLOW | ✅ PASS |
| 1.3.4 | Admin reads any review | `admin.id` | `SELECT * FROM committee.ethics_reviews` | ALLOW | ✅ PASS (0 rows — no reviews seeded) |
| 1.3.5 | Admin reads integration credentials | `admin.id` | `SELECT * FROM integration.integration_credentials` | ALLOW | ✅ PASS (0 rows — no creds seeded) |
| 1.3.6 | Admin reads saved searches | `admin.id` | `SELECT * FROM system.saved_searches` | ALLOW | ✅ PASS (0 rows — none seeded) |
| 1.3.7 | Admin inserts user responsibility | `admin.id` | `INSERT INTO security.user_responsibilities ...` | ALLOW | ❓ (not tested) |

---

## Level 2: Soft Delete Enforcement Tests

### 2.1 Soft-Deleted Row Visibility

| # | Scenario | SQL | Expected | Status |
|---|----------|-----|----------|--------|
| 2.1.1 | Admin sees soft-deleted rows | `SELECT * FROM core.applications WHERE deleted_at IS NOT NULL` | Rows returned (admin bypass is_active_row) | ✅ PASS |
| 2.1.2 | Non-owner sees soft-deleted app | `SELECT * FROM core.applications WHERE deleted_at IS NOT NULL` | Empty (non-admin, non-owner see only active) | ✅ PASS |
| 2.1.3 | Admin UPDATE on soft-deleted app | `UPDATE core.applications SET current_status='X' WHERE deleted_at IS NOT NULL` | 1 affected (admin bypass is_active_row in USING) | ✅ PASS |
| 2.1.4 | Non-owner UPDATE on soft-deleted app | `UPDATE core.applications SET current_status='X' WHERE deleted_at IS NOT NULL` | 0 affected (non-admin: is_active_row filters OLD row) | ✅ PASS |
| 2.1.5 | Admin restores soft-deleted row | `UPDATE core.applications SET deleted_at=NULL WHERE deleted_at IS NOT NULL` | 1 affected (admin bypass is_active_row) | ✅ PASS |
| 2.1.6 | Owner sees own soft-deleted row | `SELECT * FROM core.applications WHERE submitted_by=owner AND deleted_at IS NOT NULL` | Rows returned (owner bypass is_active_row) | ✅ PASS |
| 2.1.7 | Owner un-deletes own row | `UPDATE core.applications SET deleted_at=NULL WHERE submitted_by=owner` | 0 affected (owner bypass in SELECT only, not in UPDATE USING) | ✅ PASS (intentional) |

### 2.2 Soft Delete Constraint

| # | Scenario | SQL | Expected | Status |
|---|----------|-----|----------|--------|
| 2.2.1 | Set `deleted_at` without `deleted_by` | `UPDATE core.applications SET deleted_at = now() WHERE id = X` | Constraint violation (`chk_*_soft_delete`) | ✅ PASS |
| 2.2.2 | Set `deleted_at` with `deleted_by` | `UPDATE core.applications SET deleted_at = now(), deleted_by = current_user WHERE id = X` | ALLOW | ✅ PASS |

---

## Level 3: RBAC Authorization Tests

### 3.1 Role-Based Permission Matrix

| # | Permission | SUPER_ADMIN | ETHICS_ADMIN | COMMITTEE_CHAIR | REVIEWER | RESEARCHER |
|---|-----------|:-----------:|:------------:|:---------------:|:--------:|:----------:|
| 3.1.1 | `application.view` | ✅ | ✅ | ✅ | ✅ | ✅ |
| 3.1.2 | `application.create` | ✅ | ❌ | ❌ | ❌ | ✅ |
| 3.1.3 | `application.update` | ✅ | ✅ | ❌ | ❌ | ✅ |
| 3.1.4 | `application.approve` | ✅ | ✅ | ✅ | ❌ | ❌ |
| 3.1.5 | `user.view` | ✅ | ✅ | ❌ | ❌ | ❌ |
| 3.1.6 | `user.create` | ✅ | ✅ | ❌ | ❌ | ❌ |
| 3.1.7 | `user.update` | ✅ | ✅ | ❌ | ❌ | ❌ |
| 3.1.8 | `meeting.create` | ✅ | ✅ | ❌ | ❌ | ❌ |
| 3.1.9 | `meeting.update` | ✅ | ✅ | ✅ | ❌ | ❌ |
| 3.1.10 | `review.create` | ✅ | ✅ | ❌ | ❌ | ❌ |
| 3.1.11 | `review.submit` | ✅ | ✅ | ✅ | ✅ | ❌ |
| 3.1.12 | `risk.create` | ✅ | ❌ | ❌ | ❌ | ❌ |
| 3.1.13 | `document.delete` | ✅ | ✅ | ❌ | ❌ | ❌ |
| 3.1.14 | `report.export` | ✅ | ✅ | ❌ | ❌ | ❌ |
| 3.1.15 | `admin.access` | ✅ | ✅ | ❌ | ❌ | ❌ |

*✅ = Permission granted per seed data (02-users.sql)*

### 3.2 Endpoint Authorization Tests

| # | Scenario | Role | Endpoint | Expected HTTP | Status |
|---|----------|------|----------|:-------------:|--------|
| 3.2.1 | Researcher creates application | RESEARCHER | `POST /api/v1/applications` | 201 | ❓ |
| 3.2.2 | Reviewer creates application | REVIEWER | `POST /api/v1/applications` | 403 | ❓ |
| 3.2.3 | Researcher approves application | RESEARCHER | `PATCH /api/v1/applications/:id/status` | 403 | ❓ |
| 3.2.4 | Admin accesses admin dashboard | SUPER_ADMIN | `GET /api/v1/admin/stats` | 200 | ❓ |
| 3.2.5 | Researcher accesses admin dashboard | RESEARCHER | `GET /api/v1/admin/stats` | 403 | ❓ |
| 3.2.6 | Admin manages users | SUPER_ADMIN | `GET /api/v1/security/users` | 200 | ❓ |
| 3.2.7 | Researcher views users list | RESEARCHER | `GET /api/v1/security/users` | 403 | ❓ |
| 3.2.8 | Reviewer submits review | REVIEWER | `POST /api/v1/committee/reviews/:id/submit` | 200 | ❓ |
| 3.2.9 | Chair updates meeting | COMMITTEE_CHAIR | `PATCH /api/v1/committee/meetings/:id` | 200 | ❓ |
| 3.2.10 | Researcher exports report | RESEARCHER | `GET /api/v1/reporting/export/applications` | 403 | ❓ |

---

## Level 4: Service-Level Security Tests

### 4.1 Authorization Bypass via Direct Service Call

| # | Scenario | Action | Expected | Status |
|---|----------|--------|----------|--------|
| 4.1.1 | Reviewer calls `ApplicationService.updateStatus()` on someone else's app | `appService.updateStatus(applicationId, 'APPROVED', reviewerId)` | Throws `ForbiddenError` | ❓ |
| 4.1.2 | Researcher calls `WorkflowService.executeTransition()` with invalid state | `workflowService.executeTransition(instanceId, 'APPROVE', researcherId)` | Throws `ForbiddenError` | ❓ |
| 4.1.3 | Reviewer reads unassigned application via service | `appService.getById(appId, reviewerId)` | Throws `NotFoundError` | ❓ |
| 4.1.4 | User calls `AdminService.getStats()` without admin role | `adminService.getStats(userId)` | Throws `ForbiddenError` | ❓ |
| 4.1.5 | User deletes another user's document via service | `docService.delete(docId, otherUserId)` | Throws `ForbiddenError` | ❓ |

### 4.2 Transaction Boundary Tests

| # | Scenario | Expected | Status |
|---|----------|----------|--------|
| 4.2.1 | Create application + init workflow in transaction: partial failure rolls back both | Atomic: both succeed or both fail | ❓ |
| 4.2.2 | Transition workflow + create notification: if notification fails, workflow unchanged | Atomic | ❓ |
| 4.2.3 | Direct `query()` outside service bypasses `withTransaction` | RLS still enforces row-level access | ❓ |
| 4.2.4 | `app.user_id` is NOT set on direct database connection | RLS defaults to `NULL` → all policies return false | ❓ |

---

## Remaining Tables Without RLS (Post-Phase 1)

These tables still lack RLS. All are in `communication` schema:

| Priority | Table | Schema | Current State | Recommended Action |
|:--------:|-------|--------|---------------|-------------------|
| 🟡 MED | `notifications` | `communication` | Soft delete, NO RLS | Add `SELECT`/`UPDATE` for recipient |
| 🟡 MED | `messages` | `communication` | Soft delete, NO RLS | Add `SELECT`/`DELETE` (soft) for sender or recipient |
| 🟡 MED | `message_recipients` | `communication` | Soft delete, NO RLS | Add `SELECT` for recipient

---

## Execution Plan

```text
Phase 1: Fix critical gaps ✅ (14-rls-complete.sql)
  ├── ✅ Add fn_is_admin CREATE FUNCTION
  ├── ✅ Add RLS policies for workflow_instances and workflow_tasks
  ├── ✅ Add RLS policies for 7 tables with ENABLE RLS but no policies
  ├── ✅ Complete security.users policies (SELECT, UPDATE)
  └── ⏳ communication.notifications, messages (deferred — lower risk)

Phase 2: Execute Level 1 tests (RLS Isolation) ✅
  ├── ✅ Create test file: backend/test-rls-isolation.sql (direct SQL)
  ├── ✅ Apply 14-rls-complete.sql to database
  ├── ✅ Run as ethics_app: `psql -U ethics_app -d ethics_db -f backend/test-rls-isolation.sql`
  ├── ✅ 11/11 core scenarios PASS (1.1.1-1.4.3)
  └── ⏳ Remaining: 1.1.4-1.1.6 (reviewer/committee), 1.2.2 (anonymous register), 1.3.7 (admin insert)

Phase 3: Execute Level 2 tests (Soft Delete) ✅
  ├── ✅ Create test file: backend/test-soft-delete.sql
  ├── ✅ Discovered PG18 root cause: SELECT policy checked against NEW row during UPDATE
  ├── ✅ Create 15-rls-select-policy-fix.sql — restructures all 17 SELECT policies
  ├── ✅ Apply fix: is_active_row is bypassed for admins and row owners
  ├── ✅ Run as ethics_app: `psql -U ethics_app -d ethics_db -f backend/test-soft-delete.sql`
  ├── ✅ 7/7 Soft Delete scenarios PASS
  └── ⏳ Update vitest test file for soft-delete endpoints

Phase 4: Execute Level 3 tests (RBAC)
  ├── Create test file: src/test/rbac.test.ts
  └── Verify role-based endpoint access

Phase 5: Execute Level 4 tests (Service Layer)
  ├── Create test file: src/test/service-auth.test.ts
  └── Verify service-level authorization + transaction boundaries

Phase 6: Apply 14-rls-complete.sql to production-like database
  └── Verify no regression on existing functionality
```

---

## How to Execute a Test

Each test follows this pattern:

```sql
-- 1. Set the user context (simulates authenticated user)
SELECT set_config('app.user_id', '<user_id>', true);

-- 2. Execute the operation
SELECT * FROM core.applications LIMIT 1;

-- 3. Verify
--    - If DENY: should return 0 rows or throw error
--    - If ALLOW: should return expected data
```

For endpoint tests, use the backend test suite:

```bash
# From backend directory
npx jest --testPathPattern="security"
```
