# Gate 2 — Functional Integration Report

> **Release:** RC1.2  
> **Gate:** 2 of 6 — Functional Integration  
> **Execution Date:**  
> **Status:** ☐ Not Started / ☐ In Progress / ☐ Passed / ☐ Failed

---

## INT-FLOW-01: Full Research Lifecycle

| ID | Step | Actor | Result | Evidence |
|----|------|-------|:------:|----------|
| INT-001 | Register | researcher_01 | ☐ | |
| INT-002 | Login | researcher_01 | ☐ | |
| INT-003 | Create project | researcher_01 | ☐ | |
| INT-004 | Create application | researcher_01 | ☐ | |
| INT-005 | Upload document | researcher_01 | ☐ | |
| INT-006 | Submit application | researcher_01 | ☐ | |
| INT-007 | Workflow trigger | system | ☐ | |
| INT-008 | Scientific review | reviewer_01 | ☐ | |
| INT-009 | Ethics review | reviewer_01 | ☐ | |
| INT-010 | Risk assessment | ethics_admin | ☐ | |
| INT-011 | Schedule meeting | chair_01 | ☐ | |
| INT-012 | Mark attendance | chair_01 | ☐ | |
| INT-013 | Start voting | chair_01 | ☐ | |
| INT-014 | Cast votes | members | ☐ | |
| INT-015 | Close voting | chair_01 | ☐ | |
| INT-016 | Issue decision | ethics_admin | ☐ | |
| INT-017 | Consent review | ethics_admin | ☐ | |
| INT-018 | Final approval | ethics_admin | ☐ | |
| INT-019 | Verify notification | researcher_01 | ☐ | |
| INT-020 | Verify audit log | admin | ☐ | |

**Post-Scenario DB Checks:** ☐ Pass / ☐ Fail  
**INT-FLOW-01 Result:** ☐ Pass / ☐ Fail

---

## INT-FLOW-02: Accreditation Lifecycle

| ID | Step | Actor | Result | Evidence |
|----|------|-------|:------:|----------|
| INT-021 | Login | admin | ☐ | |
| INT-022 | Open accreditation | admin | ☐ | |
| INT-023 | Create cycle | admin | ☐ | |
| INT-024 | View detail | admin | ☐ | |
| INT-025 | Upload evidence | admin | ☐ | |
| INT-026 | Submit evidence | admin | ☐ | |
| INT-027 | Accept evidence | admin | ☐ | |
| INT-028 | Create assessment | admin | ☐ | |
| INT-029 | Verify score | admin | ☐ | |
| INT-030 | Create conditions | admin | ☐ | |
| INT-031 | Open dashboard | admin | ☐ | |
| INT-032 | Verify recommendation | admin | ☐ | |
| INT-033 | Issue conditional | admin | ☐ | |
| INT-034 | Resolve condition | admin | ☐ | |
| INT-035 | Issue approve | admin | ☐ | |
| INT-036 | Verify audit | admin | ☐ | |
| INT-037 | Expire cycle | admin | ☐ | |

**INT-FLOW-02 Result:** ☐ Pass / ☐ Fail

---

## INT-FLOW-03: Conditional Path

| ID | Step | Result | Evidence |
|----|------|:------:|----------|
| INT-038 | Follow INT-FLOW-02 steps 1–10 | ☐ | |
| INT-039 | Issue CONDITIONAL decision | ☐ | |
| INT-040 | Verify valid_from/valid_until | ☐ | |
| INT-041 | Resolve 1 condition → MET | ☐ | |
| INT-042 | Resolve 1 condition → WAIVED | ☐ | |
| INT-043 | Dashboard updates | ☐ | |
| INT-044 | Issue ACCREDITED | ☐ | |

**INT-FLOW-03 Result:** ☐ Pass / ☐ Fail

---

## INT-FLOW-04: Suspension & Revocation

| ID | Step | Result | Evidence |
|----|------|:------:|----------|
| INT-045 | Accredited cycle exists | ☐ | |
| INT-046 | Issue SUSPEND | ☐ | |
| INT-047 | Verify read-only | ☐ | |
| INT-048 | Issue RESUME → ACCREDITED | ☐ | |
| INT-049 | Issue REVOKE | ☐ | |
| INT-050 | Verify no transitions | ☐ | |
| INT-051 | Verify EXPIRED → REVOKED | ☐ | |

**INT-FLOW-04 Result:** ☐ Pass / ☐ Fail

---

## Defect Summary

| Severity | Count | IDs |
|----------|:-----:|-----|
| Critical | | |
| High | | |
| Medium | | |
| Low | | |

## Gate 2 Decision

> **☐ Pass** (≥ 95%) — Proceed to Gate 3
>
> **☐ Fail** — Re-run after fixes
