# Committees Module - Vertical Slice Completion Plan

> **For agentic workers:** Use executing-plans to implement task-by-task.

**Goal:** Complete the Committees module by fixing SDK gaps, migrating raw API calls to SDK, fixing type mismatches, and aligning with the Module Definition of Done.

**Architecture:** Three-layer (Routes → Services → Repositories) with RLS. Frontend: React 19 + TanStack Query + generated SDK.

**Tech Stack:** Express 5, TypeScript, React 19, Vite 8, Tailwind 4, TanStack Query, Zod 4, i18next

## Gap Summary

The module is ~65% complete on the frontend. Backend is mature (75+ endpoints, 26+ tables). Remaining gaps:

| Gap | Severity | Layer | Files |
|-----|----------|-------|-------|
| SDK types mismatched with API responses | HIGH | Frontend | `types.ts`, `committee.sdk.ts` |
| SDK HTTP verb mismatches (POST vs PATCH) | HIGH | Frontend | `committee.sdk.ts`, `reviews.sdk.ts` |
| Pages use raw `api.get/post` instead of SDK | HIGH | Frontend | `Committees.tsx`, `CommitteeDetail.tsx`, `Meetings.tsx`, `MeetingDetail.tsx` |
| N+1 query in Meetings list | MEDIUM | Frontend | `Meetings.tsx` |
| Permission keys use wrong permissions | MEDIUM | Frontend | `Committees.tsx` |
| Edit form lacks Zod validation | MEDIUM | Frontend | `Committees.tsx` |
| No deactivate UI | LOW | Frontend | `Committees.tsx` |
| Backend: qualification schema mismatch | MEDIUM | Backend | `middleware/schemas.ts` |
| Backend: conflict schema missing entity fields | MEDIUM | Backend | `middleware/schemas.ts` |
| Backend: attendance schema missing remarks | LOW | Backend | `middleware/schemas.ts` |

---

## Task 1: Fix SDK Types

**Files:** Modify `frontend/src/sdk/core/types.ts`

The SDK types are too simplistic. Pages define their own local types because the SDK types lack fields. Fix by expanding existing types to match actual API responses.

- [ ] Expand `Meeting` interface: add `meeting_number`, `location`, `committee_name`, `meeting_status`, `meeting_type`
- [ ] Expand `CommitteeMember` interface: add `display_name`, `username`, `role_name`, `is_active`
- [ ] Expand `AgendaItem` interface: add `item_order`, `app_number`, `description`
- [ ] Expand `Attendance` interface: add `display_name`, `username`, `attendance_status`, `remarks`
- [ ] Expand `Minutes` interface: add `minutes_text`, `created_by_username`, `approved_by`, `approved_by_username`, `signatures`
- [ ] Expand `MemberTerm` interface: add `is_active`, `appointment_decision_no`, `termination_decision_no`
- [ ] Expand `MemberQualification` interface: add `specialization`, `academic_degree`, `institution_name`, `experience_years`, `is_verified`
- [ ] Expand `MemberConflict` interface: add `entity_type`, `entity_id`, `description`, `declared_at`, `resolved_at`
- [ ] Add `VotingSession` interface: add `project_title`, `application_number`, `votes` array
- [ ] Add `Vote` interface: add `voter_name`
- [ ] Run `cd frontend && npm run lint` — verify PASS
- [ ] Commit: `fix(committee): expand SDK types to match actual API responses`

---

## Task 2: Fix SDK Methods and HTTP Verbs

**Files:** Modify `frontend/src/sdk/domains/committee.sdk.ts`, `frontend/src/sdk/domains/reviews.sdk.ts`

- [ ] `meetings.update()`: keep as `api.post` — backend route is `router.post('/:id', ...)` (verified at meetings.routes.ts:83). The real bug is in MeetingDetail.tsx which uses raw `api.patch` — Task 6 will fix this by migrating to SDK
- [ ] `members.addQualification()`: fix data shape to `{ specialization: string; academic_degree: string; institution_name?: string; experience_years?: number }` (currently `{ qualification: string }` — mismatch with repository)
- [ ] `members.declareConflict()`: fix data shape to match backend schema (`entity_type`, `entity_id`, `conflict_type`, `description`)
- [ ] `members.addTerm()`: add `appointment_decision_no` to data shape
- [ ] Add `committees.listAll()` method for Meetings page (avoids N+1)
- [ ] In `reviews.sdk.ts`: verify `voting.closeSession()` uses correct HTTP verb (POST, not PATCH)
- [ ] Run `cd frontend && npm run lint` — verify PASS
- [ ] Commit: `fix(committee): fix SDK HTTP verbs and method signatures`

---

## Task 3: Migrate Committees.tsx to SDK

**Files:** Modify `frontend/src/pages/Committee/Committees.tsx`

Currently uses raw `api.get`, `api.post`, `api.put` for all operations.

- [ ] Replace `api.get('/committee/committees')` with `committees.list()`
- [ ] Replace `api.get('/committee/committees/committee-types')` with `committees.listTypes()`
- [ ] Replace `api.post('/committee/committees', ...)` with `committees.create(...)`
- [ ] Replace `api.put('/committee/committees/${id}', ...)` with `committees.update(id, ...)`
- [ ] Fix permission keys: `user.create` → verify correct permission name in codebase (grep for `committee.create` — if not found, keep `user.create` as the system uses `user.*` for all admin actions)
- [ ] Add Zod validation to edit form (currently uses un-validated `useForm<any>()`)
- [ ] Add deactivate button (uses `committees.deactivate(id)` + confirmation dialog)
- [ ] Remove unused `api` import
- [ ] Run `cd frontend && npm run lint` — verify PASS
- [ ] Commit: `refactor(committee): migrate Committees.tsx to use SDK`

---

## Task 4: Migrate CommitteeDetail.tsx to SDK

**Files:** Modify `frontend/src/pages/Committee/CommitteeDetail.tsx`

Currently mixed: uses SDK for some calls, raw `api.get`/`api.post` for others.

- [ ] Replace `api.get('/committee/committees/${id}/members')` with `members.listByCommittee(id)`
- [ ] Replace `api.get('/committee/committees/${id}/committee-roles')` with `committees.listRoles()`
- [ ] Replace `api.get('/committee/members/${memberId}/terms')` with `members.getTerms(memberId)`
- [ ] Replace `api.get('/committee/members/${memberId}/qualifications')` with `members.getQualifications(memberId)`
- [ ] Replace `api.get('/committee/members/${memberId}/conflicts')` with `members.getConflicts(memberId)`
- [ ] Replace `api.post('/committee/members/${memberId}/qualifications', ...)` with `members.addQualification(memberId, ...)`
- [ ] Replace `api.post('/committee/members/${memberId}/conflicts', ...)` with `members.declareConflict(memberId, ...)`
- [ ] Replace `api.get('/committee/meetings/committee/${id}')` with `meetings.listByCommittee(id)`
- [ ] Replace `api.post('/committee/meetings', ...)` with `meetings.create(...)`
- [ ] Remove local type definitions that duplicate SDK types (e.g., `MemberSummary`, `TermData`)
- [ ] Remove unused `api` import
- [ ] Run `cd frontend && npm run lint` — verify PASS
- [ ] Commit: `refactor(committee): migrate CommitteeDetail.tsx to use SDK`

---

## Task 5: Fix Meetings List N+1 Query

**Files:** Modify `frontend/src/pages/Committee/Meetings.tsx`, `frontend/src/sdk/domains/committee.sdk.ts`, `backend/src/modules/committee/meetings.routes.ts`, `backend/src/repositories/committee.repository.ts`, `backend/src/services/committee.service.ts`

Currently: fetches ALL committees, then makes N separate API calls for each committee's meetings. This is O(N) network requests.

- [ ] Add backend endpoint: `GET /committee/meetings` — returns all meetings with `committee_name` JOINed from `committee.committees`
- [ ] Add `MeetingRepository.findAll()` method (extend AuditableRepository)
- [ ] Add `CommitteeService.findAllMeetings()` method
- [ ] Add route handler in `meetings.routes.ts`
- [ ] Add `meetings.listAll()` SDK method that calls `GET /committee/meetings`
- [ ] Refactor `Meetings.tsx` to use single SDK call instead of N+1 pattern
- [ ] Add loading skeleton and error state
- [ ] Run `cd backend && npm run lint` — verify PASS
- [ ] Run `cd frontend && npm run lint` — verify PASS
- [ ] Commit: `fix(committee): eliminate N+1 query in meetings list`

---

## Task 6: Migrate MeetingDetail.tsx to SDK

**Files:** Modify `frontend/src/pages/Committee/MeetingDetail.tsx`

Currently uses raw `api.get`/`api.post`/`api.patch` for all operations.

- [ ] Replace `api.get('/committee/meetings/${id}')` with `meetings.getById(id)`
- [ ] Replace `api.patch('/committee/meetings/${id}', ...)` with `meetings.update(id, ...)`
- [ ] Replace `api.get('/committee/meetings/${id}/agenda')` with `meetings.getAgenda(id)`
- [ ] Replace `api.post('/committee/meetings/${id}/agenda', ...)` with `meetings.addAgendaItem(id, ...)`
- [ ] Replace `api.get('/committee/meetings/${id}/attendance')` with `meetings.getAttendance(id)`
- [ ] Replace `api.post('/committee/meetings/${id}/attendance', ...)` with `meetings.recordAttendance(id, ...)`
- [ ] Replace `api.get('/committee/meetings/${id}/minutes')` with `meetings.getMinutes(id)`
- [ ] Replace `api.post('/committee/meetings/${id}/minutes', ...)` with `meetings.createMinutes(id, ...)`
- [ ] Replace `api.patch('/committee/meetings/${id}/minutes/${mid}/approve')` with `meetings.approveMinutes(id, mid)`
- [ ] Replace `api.get('/committee/meetings/${id}/committee-members')` with `meetings.getCommitteeMembers(id)`
- [ ] Remove local type definitions that duplicate SDK types
- [ ] Remove unused `api` import
- [ ] Run `cd frontend && npm run lint` — verify PASS
- [ ] Commit: `refactor(committee): migrate MeetingDetail.tsx to use SDK`

---

## Task 7: Fix Backend Validation Schema Mismatches

**Files:** Modify `backend/src/middleware/schemas.ts`

- [ ] `createQualificationSchema`: align fields with repository expectations (`specialization`, `academic_degree`, `institution_name`, `experience_years`)
- [ ] `createConflictSchema`: add `entity_type` and `entity_id` fields (currently missing — causes SQL insert to receive undefined)
- [ ] `createTermSchema`: remove `role_id` (not used by repository), add optional `appointment_decision_no` and `termination_decision_no`
- [ ] `addAttendanceSchema`: add optional `remarks` field
- [ ] Run `cd backend && npm run lint` — verify PASS
- [ ] Commit: `fix(committee): align validation schemas with repository expectations`

---

## Task 8: Run Full Validation

- [ ] `cd backend && npm run lint` (tsc --noEmit) — PASS
- [ ] `cd backend && npm test` — PASS
- [ ] `cd frontend && npm run lint` — PASS
- [ ] `cd frontend && npm run build` — PASS
- [ ] Manual: verify Committees list loads, create/edit work
- [ ] Manual: verify CommitteeDetail loads members, terms, qualifications, conflicts, meetings
- [ ] Manual: verify Meetings list loads without N+1 delay
- [ ] Manual: verify MeetingDetail agenda, attendance, minutes, voting all work
- [ ] Manual: verify My Reviews page loads review assignments
- [ ] Manual: verify Arabic/English toggle preserves all strings
- [ ] Manual: verify RTL layout intact

---

## Deliverables

1. Files modified: `types.ts`, `committee.sdk.ts`, `reviews.sdk.ts`, `Committees.tsx`, `CommitteeDetail.tsx`, `Meetings.tsx`, `MeetingDetail.tsx`, `schemas.ts` (backend), `meetings.routes.ts` (backend), `committee.repository.ts` (backend), `committee.service.ts` (backend)
2. Frontend pages connected: All 5 committee pages migrated to SDK
3. APIs consumed: All 75+ committee endpoints now consumed via SDK
4. Components reused: DataTable, StatusBadge, Dialog, Button, Card
5. Known limitations: Accreditation, Consent, and Ethics Risk sub-modules have separate frontend components (not in scope for this plan)

---

## Scope Exclusions

The following sub-modules are already functional and embedded in other pages (Application Detail):
- `ConsentTab.tsx` — calls `/committee/consent/*` endpoints
- `RiskAssessment.tsx` — calls `/committee/ethics-risk/*` endpoints
- Accreditation pages — exist under `/admin/accreditation/cycles`

These are out of scope for this plan. They can be addressed in a future iteration if needed.
