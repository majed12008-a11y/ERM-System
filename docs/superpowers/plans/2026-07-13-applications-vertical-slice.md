# Applications Module - Vertical Slice Completion Plan

> **For agentic workers:** Use executing-plans to implement task-by-task.

**Goal:** Complete the Applications module by fixing SDK gaps, broken timeline, missing actions, and OpenAPI alignment.

**Architecture:** Three-layer (Routes -> Services -> Repositories) with RLS. Frontend: React 19 + TanStack Query + generated SDK.

**Tech Stack:** Express 5, TypeScript, React 19, Vite 8, Tailwind 4, TanStack Query, Zod 4, i18next

## Gap Summary

The module is ~85% complete. Backend is mature, frontend pages exist with real API calls. Remaining gaps:

| Gap | Severity | Files |
|-----|----------|-------|
| SDK missing: withdraw, appeal, renew, SLA, history | HIGH | `applications.sdk.ts` |
| Certificate SDK hardcoded ID=0 | BUG | `certificates.sdk.ts`, `CertificatesTab.tsx` |
| Workflow timeline uses instances API instead of history | BROKEN | `Detail.tsx` |
| No SLA indicator | MEDIUM | `Detail.tsx` |
| No withdraw/appeal/renew UI | HIGH | `Detail.tsx` |
| No server-side status filter on list | MEDIUM | `List.tsx` |
| OpenAPI missing 5 endpoints + wrong port | LOW | `applications.yaml`, `openapi.yaml` |

---

## Task 1: Extend applications.sdk.ts

**Files:** Modify `frontend/src/sdk/domains/applications.sdk.ts`

- [ ] Add 5 methods: `withdraw`, `appeal`, `renew`, `getSla`, `getHistory`
- [ ] Run `cd frontend && npm run lint` - verify PASS
- [ ] Commit: `feat(applications): add withdraw, appeal, renew, SLA, history SDK methods`

---

## Task 2: Fix Certificate SDK Hardcoded ID Bug

**Files:** Modify `frontend/src/sdk/domains/certificates.sdk.ts`, `frontend/src/pages/Applications/CertificatesTab.tsx`

- [ ] Change all single-cert methods to accept `applicationId` as first param instead of hardcoding `0`
- [ ] Update all callers in CertificatesTab.tsx
- [ ] Run `cd frontend && npm run lint` - verify PASS
- [ ] Commit: `fix(applications): fix certificate SDK hardcoded application ID`

---

## Task 3: Fix Workflow Timeline

**Files:** Modify `frontend/src/pages/Applications/Detail.tsx`

- [ ] Replace `workflowInstance` query with `applications.getHistory()` query
- [ ] Update timeline rendering to show `from_state_name`, `to_state_name`, `action_by_name`, `comments`, `action_date`
- [ ] Run `cd frontend && npm run lint` - verify PASS
- [ ] Commit: `fix(applications): fix workflow timeline to use history API`

---

## Task 4: Add SLA Status Display

**Files:** Modify `frontend/src/pages/Applications/Detail.tsx`, `ar.json`, `en.json`

- [ ] Add `applications.getSla()` query
- [ ] Add red SLA overdue badge in header when `!sla.within_sla`
- [ ] Add i18n key `applications.overdue`
- [ ] Run `cd frontend && npm run lint` - verify PASS
- [ ] Commit: `feat(applications): add SLA status indicator to detail page`

---

## Task 5: Add Withdraw, Appeal, Renew Actions

**Files:** Modify `frontend/src/pages/Applications/Detail.tsx`, `ar.json`, `en.json`

- [ ] Add withdraw/appeal dialog state + mutations using `applications.withdraw()`, `applications.appeal()`, `applications.renew()`
- [ ] Add conditional action buttons: Withdraw (DRAFT/SUBMITTED/RETURNED + owner), Appeal (REJECTED + owner), Renew (APPROVED + admin)
- [ ] Add withdraw confirmation dialog with optional comment
- [ ] Add appeal dialog with 10-char minimum justification
- [ ] Add 14 i18n keys for both locales (withdraw, appeal, renewal strings)
- [ ] Ensure Dialog/Textarea imports are present
- [ ] Run `cd frontend && npm run lint` - verify PASS
- [ ] Commit: `feat(applications): add withdraw, appeal, and renewal actions to detail page`

---

## Task 6: Add Status Filter to List Page

**Files:** Modify `frontend/src/pages/Applications/List.tsx`

- [ ] Add `statusFilter` state, switch from raw `api.get` to `applications.list({ status })` SDK call
- [ ] Add status dropdown filter (DRAFT, SUBMITTED, INITIAL_REVIEW, etc.)
- [ ] Remove unused `api` import, add `applications` SDK import and `useState`
- [ ] Run `cd frontend && npm run lint` - verify PASS
- [ ] Commit: `feat(applications): add server-side status filter to list page`

---

## Task 7: Update OpenAPI Spec

**Files:** Modify `backend/openapi/modules/applications.yaml`, `backend/openapi/openapi.yaml`

- [ ] Fix server URL from port 3000 to 8080
- [ ] Add missing endpoints: `GET /:id/history`, `GET /:id/sla`, `POST /:id/withdraw`, `POST /:id/appeal`, `POST /:id/renewal`
- [ ] Run `cd backend && npm run lint` - verify PASS
- [ ] Commit: `docs(openapi): add missing application endpoints and fix server port`

---

## Task 8: Run Full Validation

- [ ] `cd backend && npm run lint` (tsc --noEmit)
- [ ] `cd backend && npm test`
- [ ] `cd frontend && npm run lint`
- [ ] `cd frontend && npm run build`
- [ ] Manual: verify List, Create, Edit, Detail pages render and load data
- [ ] Manual: verify withdraw/appeal/renew buttons appear in correct states
- [ ] Manual: verify workflow timeline shows history entries
- [ ] Manual: verify SLA badge appears for overdue applications
- [ ] Manual: verify status filter works on list page
- [ ] Manual: verify certificate download works (no hardcoded ID)
- [ ] Manual: verify Arabic/English toggle preserves all new strings
- [ ] Manual: verify RTL layout intact

---

## Deliverables

1. Files modified: `applications.sdk.ts`, `certificates.sdk.ts`, `CertificatesTab.tsx`, `Detail.tsx`, `List.tsx`, `applications.yaml`, `openapi.yaml`, `ar.json`, `en.json`
2. Frontend pages connected: List (filter upgrade), Detail (timeline fix + SLA + withdraw/appeal/renew)
3. APIs consumed: All 16 application endpoints now consumed by frontend
4. Components reused: DataTable, StatusBadge, Dialog, Button, Card, ConditionsPanel, ConsentTab, CertificatesTab, RiskAssessment
5. Components created: None (all changes fit existing patterns)
6. Known limitations: Integration tests still target port 3000 (pre-existing)
