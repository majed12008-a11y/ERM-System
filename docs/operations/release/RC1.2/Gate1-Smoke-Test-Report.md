# Gate 1 — Smoke Test Report

> **Release:** RC1.2  
> **Gate:** 1 of 6 — Smoke Test  
> **Baseline Tag:** `rc1.2-test-baseline`  
> **Execution Date:**  
> **Tester:**  
> **Status:** ☐ Not Started / ☐ In Progress / ☐ Passed / ☐ Failed

---

## Phase A — Infrastructure Smoke

| ID | Test | Result | Evidence | Notes |
|----|------|:------:|----------|-------|
| SMK-001 | Docker compose up | ☐ | | |
| SMK-002 | PostgreSQL health | ☐ | | |
| SMK-003 | Backend health | ☐ | | |
| SMK-004 | Frontend health | ☐ | | |
| SMK-005 | DB connection from backend | ☐ | | |
| SMK-006 | Migration status | ☐ | | |
| SMK-007 | Seed applied | ☐ | | |
| SMK-008 | No fatal logs | ☐ | | |

**Phase A Result:** ☐ Pass / ☐ Fail

> If any test in Phase A fails, **Gate 1 stops entirely**.

---

## Phase B — Authentication Smoke

| ID | Test | Result | Evidence | Notes |
|----|------|:------:|----------|-------|
| SMK-009 | Login page renders | ☐ | | |
| SMK-010 | Login as SUPER_ADMIN | ☐ | | |
| SMK-011 | Login as ETHICS_ADMIN | ☐ | | |
| SMK-012 | Login as COMMITTEE_CHAIR | ☐ | | |
| SMK-013 | Login as REVIEWER | ☐ | | |
| SMK-014 | Login as RESEARCHER | ☐ | | |
| SMK-015 | Invalid credentials | ☐ | | |
| SMK-016 | Logout | ☐ | | |
| SMK-017 | Session expiry | ☐ | | |
| SMK-018 | API without JWT | ☐ | | |

**Phase B Result:** ☐ Pass / ☐ Fail

---

## Phase C — Core Navigation Smoke

| ID | Page | Result | Console Errors | Evidence | Notes |
|----|------|:------:|:--------------:|----------|-------|
| SMK-019 | Dashboard | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-020 | Projects | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-021 | Applications | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-022 | Committees | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-023 | Committee Detail | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-024 | Meetings | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-025 | My Reviews | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-026 | Accreditation Cycles | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-027 | Cycle Detail | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-028 | Evidence | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-029 | Assessments | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-030 | Conditions | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-031 | Dashboard (accreditation) | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-032 | Notifications | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-033 | Documents | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-034 | Reports | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-035 | Users (admin) | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-036 | Profile | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-037 | Arabic/RTL toggle | ☐ | ☐ 0 / ☐ >0 | | |
| SMK-038 | All pages — console | ☐ | ☐ 0 / ☐ >0 | | |

**Phase C Result:** ☐ Pass / ☐ Fail

---

## Phase D — Critical API Smoke

| ID | Endpoint | Method | Expected | Result | Evidence |
|----|----------|:------:|:--------:|:------:|----------|
| SMK-039 | `/api/v1/auth/login` | POST | 200 | ☐ | |
| SMK-040 | `/api/v1/projects` | GET | 200 | ☐ | |
| SMK-041 | `/api/v1/applications` | GET | 200 | ☐ | |
| SMK-042 | `/api/v1/committee/committees` | GET | 200 | ☐ | |
| SMK-043 | `/api/v1/committee/reviews` | GET | 200 | ☐ | |
| SMK-044 | `/api/v1/committee/accreditation/cycles` | GET | 200 | ☐ | |
| SMK-045 | `/api/v1/committee/accreditation/standards` | GET | 200 | ☐ | |
| SMK-046 | `/api/v1/documents` | GET | 200 | ☐ | |
| SMK-047 | `/api/v1/notifications` | GET | 200 | ☐ | |
| SMK-048 | `/api/v1/users` | GET | 200 | ☐ | |

**Phase D Result:** ☐ Pass / ☐ Fail

---

## Pass Criteria

| Criterion | Target | Result |
|-----------|-------:|:------:|
| SMK-P01 | Batch A (Startup) | 8/8 pass | ☐ |
| SMK-P02 | Batch B (Auth) | 10/10 pass | ☐ |
| SMK-P03 | Batch C (Navigation) | 20/20 pass, 0 JS errors | ☐ |
| SMK-P04 | Batch D (API) | 10/10 pass | ☐ |
| **Total** | **48/48 pass** | **☐ Pass / ☐ Fail** |

---

## Defect Summary

| Severity | Count | IDs |
|----------|:-----:|-----|
| Critical | | |
| High | | |
| Medium | | |
| Low | | |

## Gate 1 Decision

> **☐ Pass** — Proceed to Gate 2 (Functional Integration)
>
> **☐ Fail** — See defect list above; re-run Gate 1 after fixes

## Evidence Archive

Evidence stored at: `evidence/gate1-smoke/`

- Batch A logs: 
- Batch B screenshots:
- Batch C screenshots + console captures:
- Batch D API responses:

## Notes / Observations

```
```
