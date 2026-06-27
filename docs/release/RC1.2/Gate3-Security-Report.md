# Gate 3 — Role & Security Report

> **Release:** RC1.2  
> **Gate:** 3 of 6 — Role & Security  
> **Execution Date:**  
> **Status:** ☐ Not Started / ☐ In Progress / ☐ Passed / ☐ Failed

---

## Role-Based Access — Accreditation Module

| ID | Action | SUPER_ADMIN | ETHICS_ADMIN | COMMITTEE_CHAIR | REVIEWER | RESEARCHER | Result |
|----|--------|:-----------:|:------------:|:---------------:|:--------:|:----------:|:------:|
| SEC-001 | View Cycles List | ✅ | ✅ | ✅ | ✅ | ✅ | ☐ |
| SEC-002 | Create Cycle | ✅ | ✅ | ❌ | ❌ | ❌ | ☐ |
| SEC-003 | Delete Cycle | ✅ | ✅ | ❌ | ❌ | ❌ | ☐ |
| SEC-004 | Upload Evidence | ✅ | ✅ | ✅ | ✅ | ❌ | ☐ |
| SEC-005 | Review Evidence | ✅ | ✅ | ❌ | ❌ | ❌ | ☐ |
| SEC-006 | Delete Evidence | ✅ | ✅ | ❌ | ❌ | ❌ | ☐ |
| SEC-007 | Create Assessment | ✅ | ✅ | ❌ | ❌ | ❌ | ☐ |
| SEC-008 | Delete Assessment | ✅ | ✅ | ❌ | ❌ | ❌ | ☐ |
| SEC-009 | Create Condition | ✅ | ✅ | ❌ | ❌ | ❌ | ☐ |
| SEC-010 | Resolve Condition | ✅ | ✅ | ❌ | ❌ | ❌ | ☐ |
| SEC-011 | Issue Final Decision | ✅ | ✅ | ❌ | ❌ | ❌ | ☐ |
| SEC-012 | View Dashboard | ✅ | ✅ | ✅ | ✅ | ✅ | ☐ |

---

## RLS Data Isolation

| ID | Test | Expected | Result |
|----|------|----------|:------:|
| SEC-013 | Researcher isolation | Each sees only own projects | ☐ |
| SEC-014 | Admin visibility | Sees all projects | ☐ |
| SEC-015 | Committee isolation | Each sees own committee meetings | ☐ |
| SEC-016 | Review isolation | Each sees only assigned reviews | ☐ |

---

## API-Level Authorization

| ID | Test | Expected | Result |
|----|------|----------|:------:|
| SEC-017 | No JWT request | 401 | ☐ |
| SEC-018 | Expired JWT | 401 | ☐ |
| SEC-019 | RESEARCHER creates cycle | 403 | ☐ |
| SEC-020 | RESEARCHER uploads evidence | ✅ 200 | ☐ |
| SEC-021 | REVIEWER creates condition | 403 | ☐ |

---

## 403 UX Handling

| ID | Test | Expected UX | Result |
|----|------|-------------|:------:|
| SEC-022 | Hidden button (no permission) | Button not rendered | ☐ |
| SEC-023 | API 403 on mutation | Toast error | ☐ |
| SEC-024 | API 401 on session expiry | Redirect to login | ☐ |

---

## Defect Summary

| Severity | Count | IDs |
|----------|:-----:|-----|
| Critical | | |
| High | | |
| Medium | | |
| Low | | |

## Gate 3 Decision

> **☐ Pass** (100%) — Proceed to Gate 4
>
> **☐ Fail** — Re-run after fixes
