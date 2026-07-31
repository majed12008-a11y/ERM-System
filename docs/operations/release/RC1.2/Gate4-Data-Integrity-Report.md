# Gate 4 — Data Integrity Report

> **Release:** RC1.2  
> **Gate:** 4 of 6 — Data Integrity  
> **Execution Date:**  
> **Status:** ☐ Not Started / ☐ In Progress / ☐ Passed / ☐ Failed

---

## Structural Integrity

| ID | Check | Expected | Result |
|----|-------|----------|:------:|
| DAT-001 | All FK constraints enabled | All expected FKs present | ☐ |
| DAT-002 | No orphan records | 0 rows for all FKs | ☐ |
| DAT-003 | No duplicate UNIQUE violations | 0 rows | ☐ |
| DAT-004 | Sequences match row counts | Consistent | ☐ |
| DAT-005 | CHECK constraints honored | 0 rows | ☐ |

---

## Audit Field Integrity

| ID | Check | Expected | Result |
|----|-------|----------|:------:|
| DAT-006 | `created_by` is never NULL | Every row has a creator | ☐ |
| DAT-007 | `created_at` is never NULL | Every row has a timestamp | ☐ |
| DAT-008 | `updated_at` ≥ `created_at` | Time moves forward | ☐ |
| DAT-009 | `deleted_at` IS NULL for active rows | Soft delete pattern | ☐ |
| DAT-010 | `updated_by` matches a valid user | FK to users.id | ☐ |

---

## State Machine Integrity

| ID | State Machine | Check | Result |
|----|---------------|-------|:------:|
| DAT-011 | Accreditation cycles | Valid status values | ☐ |
| DAT-012 | Accreditation cycles | No impossible transitions | ☐ |
| DAT-013 | Evidence | Valid status values | ☐ |
| DAT-014 | Conditions | Valid status values | ☐ |
| DAT-015 | Conditions | Resolved conditions have resolved_at | ☐ |

---

## Workflow Integrity

| ID | Check | Expected | Result |
|----|-------|----------|:------:|
| DAT-016 | Every application has one active workflow | 1:1 | ☐ |
| DAT-017 | Workflow transitions are sequential | Monotonic timestamps | ☐ |
| DAT-018 | No stale IN_PROGRESS workflows | >90 days flagged | ☐ |

---

## Defect Summary

| Severity | Count | IDs |
|----------|:-----:|-----|
| Critical | | |
| High | | |
| Medium | | |
| Low | | |

## Gate 4 Decision

> **☐ Pass** (100%) — Proceed to Gate 5
>
> **☐ Fail** — Re-run after fixes
