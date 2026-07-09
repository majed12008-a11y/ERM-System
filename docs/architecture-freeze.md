# Architecture Freeze — RC1

> Effective: 2026-07-09
> Governing document for Phase 10 implementation.

---

## Current State

| Property | Value |
|----------|-------|
| **Release** | RC1 (Production Candidate 1) |
| **Current Branch** | `main` (commit `2278edb`) |
| **Production Readiness Score** | **7.5/10** |
| **Architecture Status** | **FROZEN** |
| **Deployment Target** | Ministry of Health and Environment, Yemen |

---

## Frozen Modules

The following modules and their interfaces are **frozen**. No architectural redesign is permitted.

| Domain | Status | Constraints |
|--------|--------|-------------|
| **Authentication** | FROZEN | JWT flow, Argon2id hashing, refresh tokens |
| **Authorization** | FROZEN | RLS-only access control, role-based permissions |
| **Workflow Engine** | FROZEN | State machine, transition rules, status derivation |
| **Applications** | FROZEN | CRUD, status transitions, lifecycle |
| **Projects** | FROZEN | CRUD, project-application linkage |
| **Committees** | FROZEN | CRUD, member management, accreditation |
| **Reviews** | FROZEN | Assignment, submission, review forms |
| **Conditions** | FROZEN | CRUD, resolution, evidence linkage |
| **Evidence** | FROZEN | Upload, soft-delete, RLS policy matrix |
| **Documents** | FROZEN | Upload, soft-delete, file storage, MIME filtering |
| **Certificates** | FROZEN | Issue, reissue, revoke, PDF generation |
| **Notifications** | FROZEN | SSE stream, in-app, email, push |
| **Messaging** | FROZEN | Internal messaging, attachments |
| **Accreditation** | FROZEN | Cycles, assessments, decisions |
| **Reporting** | FROZEN | KPI results, widgets, analytics snapshots |
| **Observability** | FROZEN | Health endpoints, structured logging, correlation IDs |
| **Backup** | FROZEN | pg_dump/pg_restore, verify, rotate (fix permitted) |
| **Restore** | FROZEN | Pre-restore backup, rollback on failure |
| **Public Verification** | FROZEN | Public certificate verification endpoint |
| **Frontend Architecture** | FROZEN | React 19, Vite, Tailwind 4, shadcn components, SDK pattern |
| **Database Schema** | FROZEN | All tables, views, functions, RLS policies |
| **OpenAPI** | FROZEN | Swagger spec, SDK generation contract |
| **SDK** | FROZEN | Orval-generated TypeScript client |

---

## Allowed Changes

Only the following categories of changes are permitted during Phase 10:

| Category | Examples | Limits |
|----------|----------|--------|
| **Bug fixes** | Correct logic errors, wrong status codes, edge cases | Must be validated in backlog |
| **Security fixes** | Input validation, injection prevention, hardening | Must be validated in backlog |
| **Validation improvements** | Add Zod schemas, strengthen existing schemas | Must be validated in backlog |
| **Operational fixes** | CI scripts, deployment scripts, monitoring | Must be validated in backlog |
| **Production hardening** | Resource limits, health checks, graceful shutdown | Must be validated in backlog |
| **Documentation** | README updates, ADRs, runbooks | Any time |
| **Tests** | Unit, integration, E2E, regression | Any time |
| **Performance tuning** | Query optimization, index tuning | Only if backed by measurement |
| **Logging** | Add structured fields, improve error context | Must not change wire format |
| **Metrics** | Add counters, histograms | Must not change business logic |

---

## Forbidden Changes

The following are **strictly forbidden** during Phase 10:

| Category | Rationale |
|----------|-----------|
| **No database redesign** | Schema is frozen; no new tables, columns, or constraint changes |
| **No workflow redesign** | State machine, transitions, and status derivation are finalized |
| **No API redesign** | No new endpoints, no URL changes, no response contract changes |
| **No module split** | Module boundaries are frozen; no splitting or merging |
| **No service split** | Three-layer (Routes → Services → Repositories) is frozen |
| **No repository redesign** | Repository pattern, base class extensions are frozen |
| **No frontend routing redesign** | Page structure and navigation is frozen |
| **No feature additions** | No new user-facing features |

---

## Engineering Rules

Every implementation commit **must** satisfy all of the following:

| Rule | Description | Verification |
|------|-------------|--------------|
| **Minimal** | Touches only the files required for the specific backlog item | Code review |
| **Atomic** | One backlog item per commit. No mixed changes. | Commit message |
| **Reversible** | Can be rolled back with a single `git revert` | Rollback plan |
| **Regression-tested** | Every change includes or references regression test coverage | Test suite |
| **Documented** | Backlog item ID in commit message; implementation contract updated | Commit message |
| **Builds** | `npm run lint` + `npm test` + `npm run build` pass for both backend and frontend | CI |
| **No side effects** | No formatting-only changes, no naming refactors, no whitespace cleanup | Code review |

---

## Violation Protocol

If any change violates this freeze:

1. The commit is rejected during code review
2. The author reverts the change
3. If disputed, escalation to architecture owner for exception approval

## Exception Process

Exceptions to the forbidden changes list require:

1. Written justification describing the business necessity
2. Impact analysis showing why the frozen design cannot support the requirement
3. Architecture owner approval
4. Documentation update reflecting the exception

---

## Sign-off

This freeze is effective immediately upon commit to `main` and remains in effect until the Production Candidate is accepted for deployment by the Ministry of Health and Environment of Yemen.
