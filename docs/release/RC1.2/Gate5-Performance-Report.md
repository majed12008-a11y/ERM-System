# Gate 5 — Non-Functional Report

> **Release:** RC1.2  
> **Gate:** 5 of 6 — Non-Functional  
> **Execution Date:**  
> **Status:** ☐ Not Started / ☐ In Progress / ☐ Passed / ☐ Failed

---

## Performance

| ID | Test | Target | Actual | Result |
|----|------|--------|:------:|:------:|
| NFR-001 | Accreditation cycles list API | < 500ms | | ☐ |
| NFR-002 | Cycle detail with inline queries | < 800ms | | ☐ |
| NFR-003 | Dashboard page (4 parallel queries) | < 3s | | ☐ |
| NFR-004 | Evidence upload (1MB PDF) | < 3s | | ☐ |
| NFR-005 | Login + JWT generation | < 200ms | | ☐ |
| NFR-006 | DataTable render (100 rows) | < 1s | | ☐ |
| NFR-007 | Page transition (lazy load) | < 1.5s | | ☐ |

---

## Concurrency

| ID | Scenario | Expected | Result |
|----|----------|----------|:------:|
| NFR-008 | Two admins create cycle simultaneously | 201 + 409 | ☐ |
| NFR-009 | Two admins issue decision on same cycle | First OK, second error | ☐ |
| NFR-010 | Upload while review in progress | No lost updates | ☐ |
| NFR-011 | Mutate conditions while dashboard loads | Eventual consistency OK | ☐ |

---

## Security

| ID | Test | Method | Expected | Result |
|----|------|--------|----------|:------:|
| NFR-012 | SQL injection | `' OR 1=1--` | Parameterized | ☐ |
| NFR-013 | XSS | `<script>alert(1)</script>` | Sanitized | ☐ |
| NFR-014 | Rate limiting | 20 rapid requests | 429 | ☐ |
| NFR-015 | JWT tampering | Modify token | 401 | ☐ |
| NFR-016 | File upload validation | Upload .exe | Rejected | ☐ |
| NFR-017 | CORS | `Origin: https://evil.com` | Blocked | ☐ |
| NFR-018 | Helmet headers | `curl -I` | Headers present | ☐ |

---

## Backup & Recovery

| ID | Test | Expected | Result |
|----|------|----------|:------:|
| NFR-019 | Database backup | Complete dump | ☐ |
| NFR-020 | Restore from backup | All data intact | ☐ |
| NFR-021 | Backup during active write | Consistent snapshot | ☐ |
| NFR-022 | Application restart | Backend recovers | ☐ |

---

## Large Dataset

| ID | Scenario | Concern | Result |
|----|----------|---------|:------:|
| NFR-023 | 5000 evidence records per cycle | Pagination, timeout | ☐ |
| NFR-024 | 200 conditions per cycle | Dashboard aggregation | ☐ |
| NFR-025 | 50 assessors per cycle | Consensus rendering | ☐ |

---

## Defect Summary

| Severity | Count | IDs |
|----------|:-----:|-----|
| Critical | | |
| High | | |
| Medium | | |
| Low | | |

## Gate 5 Decision

> **☐ Pass** (within thresholds) — Proceed to Gate 6
>
> **☐ Fail** — Re-run after fixes
