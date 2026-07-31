# E5-04: Role Coverage Report

**Date:** 2026-07-23
**Status:** ✅ PASS

---

## Role Definitions

| # | Role Code | Name (AR) | Name (EN) | Level | Users (Seed) |
|---|-----------|-----------|-----------|-------|-------------|
| 1 | SUPER_ADMIN | مدير النظام | System Admin | 1 | 1 (admin@ethics.sa) |
| 2 | ETHICS_ADMIN | مدير الأخلاقيات | Ethics Admin | 2 | 1 (admin@ethics.sa) |
| 3 | COMMITTEE_CHAIR | رئيس اللجنة | Committee Chair | 3 | 1 |
| 4 | COMMITTEE_MEMBER | عضو اللجنة | Committee Member | 4 | 3 |
| 5 | RESEARCHER | باحث | Researcher | 5 | 10 |
| 6 | DEPARTMENT_HEAD | رئيس القسم | Department Head | 3 | 2 |

## Endpoint Access Matrix

### Write Operations

| Module | Operation | SUPER_ADMIN | ETHICS_ADMIN | COMMITTEE_CHAIR | COMMITTEE_MEMBER | RESEARCHER | DEPT_HEAD |
|--------|-----------|:-----------:|:------------:|:---------------:|:----------------:|:----------:|:---------:|
| Applications | Create | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Applications | Submit | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Applications | Withdraw | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ |
| Applications | Transition (admin) | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Applications | Close | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Applications | Archive | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Committee | Vote | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Committee | Create meeting | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Documents | Upload | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Documents | Delete | ✅ | ✅ | ✅ | ❌ | ✅* | ❌ |
| Conditions | Create | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Conditions | Resolve | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Evidence | Submit | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ |
| Evidence | Reject | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Templates | Create/Update | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Templates | Approve | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Saved Search | CRUD | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Safety | Report | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Safety | Investigate | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Backup | Trigger/Restore | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Users | Create/Update | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| System | Config | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

*Researcher document delete restricted to own uploads on own applications (RLS enforced).

### Read Operations

| Module | SUPER_ADMIN | ETHICS_ADMIN | COMMITTEE_CHAIR | COMMITTEE_MEMBER | RESEARCHER | DEPT_HEAD |
|--------|:-----------:|:------------:|:---------------:|:----------------:|:----------:|:---------:|
| Applications (list) | All | All | All | Assigned | Own | Dept |
| Applications (detail) | ✅ | ✅ | ✅ | Assigned | Own | Dept |
| Committee meetings | All | All | All | All | ❌ | ❌ |
| Documents | All | All | All | Assigned | Own | Dept |
| Reports | All | All | All | ❌ | ❌ | ❌ |
| Audit logs | All | All | ❌ | ❌ | ❌ | ❌ |
| Dashboard | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

## Separation of Duties

| Constraint | Enforcement | Status |
|-----------|-------------|--------|
| RESEARCHER cannot approve applications | Workflow transitions | ✅ |
| COMMITTEE_MEMBER cannot reject without CHAIR | Vote quorum check | ✅ |
| Only SUPER_ADMIN can archive | Transition role check | ✅ |
| Only SUPER_ADMIN can trigger backup | Route authorize middleware | ✅ |
| Only SUPER_ADMIN can restore backup | Route authorize middleware | ✅ |
| Only SUPER_ADMIN can manage system config | Route authorize middleware | ✅ |
| RESEARCHER can only see own data | RLS policies | ✅ |
| COMMITTEE_MEMBER sees only assigned | RLS policies | ✅ |

## RLS Enforcement

All role-based access control is enforced at two layers:
1. **Application layer**: `authorize()` middleware on routes checks JWT claims against required roles.
2. **Database layer**: RLS policies on all 291 policies enforce data-level access using `app.user_id` set via `AsyncLocalStorage`.

## Verdict

**✅ PASS** — All 6 roles defined. Write operations have explicit role restrictions. Read operations use RLS for data filtering. Separation of duties enforced at both application and database layers.
