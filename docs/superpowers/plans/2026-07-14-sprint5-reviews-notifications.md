# Sprint 5 Implementation Plan — Reviews Extraction + Notifications SDK Migration

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Extract Reviews service/repository from the monolithic CommitteeService into dedicated files, complete the OpenAPI spec, migrate all frontend consumers to SDK, and migrate Notifications page to SDK with OpenAPI completion.

**Architecture:** Reviews routes stay mounted at `/api/v1/committee/reviews/*` (URL contract preserved) but the service and repository are extracted into standalone files. Notifications stays in the communication module but the frontend page is migrated from raw API calls to the generated SDK. OpenAPI specs are completed for both domains.

**Tech Stack:** Express 5, TypeScript (CommonJS), Zod 4, OpenAPI 3.1, React 19, TanStack Query, Axios SDK

## Global Constraints

- Node.js 22+, PostgreSQL 18+
- Backend port: 8080
- RLS is the sole access control — never disable
- `AsyncLocalStorage` propagates `app.user_id` for RLS
- Frontend SDK is generated from OpenAPI via Orval — edit OpenAPI, regenerate SDK
- i18n: Arabic (RTL) + English (LTR), fallback Arabic
- No mock data — all pages use real API calls via SDK
- No `express.static` for documents — authenticated endpoints only
- Module DoD: 15 categories mandatory
- Gate 8: production build must pass before marking any module

---

## Phase 1 — Reviews Backend Extraction (Tasks 1–6)

### Task 1: Extract ReviewRepository from committee.repository.ts

**Files:**
- Create: `backend/src/repositories/review.repository.ts`
- Modify: `backend/src/repositories/committee.repository.ts` (remove lines 230–417)
- Test: `backend/src/test/review.repository.test.ts`

**Interfaces:**
- Consumes: `AuditableRepository` (base class), `pool` from `../config/database`
- Produces: `ReviewRepository` class with methods: `getMyReviews`, `findAssignmentById`, `getApplicationReviews`, `createAssignment`, `getForms`, `createForm`, `getQuestions`, `addQuestion`, `deleteQuestion`, `getRecommendations`, `getComments`, `getAnswers`, `getScore`, `submitReview`

- [ ] **Step 1: Create review.repository.ts by extracting from committee.repository.ts**

Copy lines 230–417 from `committee.repository.ts` into a new file `review.repository.ts`. The file should:
- Import `AuditableRepository` from `./auditable.repository`
- Import `pool` from `../config/database`
- Export the `ReviewRepository` class
- Include all 15 methods exactly as they exist in committee.repository.ts

- [ ] **Step 2: Update committee.repository.ts to remove ReviewRepository**

Remove lines 230–417 (the `ReviewRepository` class) from `committee.repository.ts`. Keep the `export` statement for `ReviewRepository` pointing to the new file, or remove the export and update consumers.

- [ ] **Step 3: Verify backend compiles**

Run: `npm run lint` in `backend/`
Expected: PASS (0 errors)

- [ ] **Step 4: Run existing tests to verify no regressions**

Run: `npm test` in `backend/`
Expected: 997+ tests pass (same as baseline)

- [ ] **Step 5: Commit**

```bash
git add backend/src/repositories/review.repository.ts backend/src/repositories/committee.repository.ts
git commit -m "refactor(reviews): extract ReviewRepository from committee.repository.ts"
```

---

### Task 2: Extract ReviewService + VotingService from committee.service.ts

**Files:**
- Create: `backend/src/services/review.service.ts`
- Create: `backend/src/services/voting.service.ts`
- Modify: `backend/src/services/committee.service.ts` (remove review + voting methods)
- Test: `backend/src/test/review.service.test.ts`

**Interfaces:**
- Consumes: `ReviewRepository` (from Task 1), `VotingRepository` (from committee.repository.ts), `NotificationService` (`createAndNotify`, `createAndNotifyBatch`), `ApplicationRepository` (for `findById` in closeVotingSession), `broadcastDashboardEvent` from `notification.service`
- Produces: `ReviewService` class, `VotingService` class

**ReviewService methods to extract (from CommitteeService lines 90–127):**

| Method | Signature | Dependencies |
|--------|-----------|-------------|
| `getMyReviews` | `(user: AuthUser)` | `reviews.getMyReviews(user.id)` |
| `getApplicationReviews` | `(applicationId: number)` | `reviews.getApplicationReviews(applicationId)` |
| `assignReview` | `(data: any, user: AuthUser)` | `reviews.createAssignment()`, `createAndNotify()`, `broadcastDashboardEvent()` |
| `getRecommendations` | `(applicationId: number)` | `reviews.getRecommendations(applicationId)` |
| `getComments` | `(applicationId: number)` | `reviews.getComments(applicationId)` |
| `getAnswers` | `(assignmentId: number)` | `reviews.getAnswers(assignmentId)` |
| `getScore` | `(assignmentId: number)` | `reviews.getScore(assignmentId)` |
| `submitReview` | `(assignmentId: number, user: AuthUser, data: any)` | `reviews.findAssignmentById()`, `reviews.submitReview()` |
| `getForms` | `()` | `reviews.getForms()` |
| `createForm` | `(data: any)` | `reviews.createForm(data)` |
| `getQuestions` | `(formId: number)` | `reviews.getQuestions(formId)` |
| `addQuestion` | `(formId: number, data: any)` | `reviews.addQuestion(formId, data)` |
| `deleteQuestion` | `(formId: number, questionId: number)` | `reviews.deleteQuestion(questionId, formId)` |

**VotingService methods to extract (from CommitteeService lines 217–267):**

| Method | Signature | Dependencies |
|--------|-----------|-------------|
| `getVotingSessions` | `(meetingId: number)` | `voting.findByMeeting(meetingId)` |
| `getVotingSession` | `(id: number)` | `voting.findSessionById()`, `voting.getVotes()` |
| `createVotingSession` | `(data: any)` | `voting.createSession(data)` |
| `castVote` | `(sessionId: number, user: AuthUser, voteValue: string, comments?: string)` | `voting.findSessionById()`, `voting.getVotes()`, `voting.castVote()` |
| `closeVotingSession` | `(sessionId: number)` | `voting.closeSession()`, `voting.getVotes()`, `createAndNotifyBatch()`, `broadcastDashboardEvent()`, `applications.findById()` |

**Cross-domain dependency resolution:**
- `ReviewService` needs `NotificationService` for `createAndNotify()` and `broadcastDashboardEvent()`. Inject via constructor.
- `VotingService` needs `NotificationService` for `createAndNotifyBatch()` + `broadcastDashboardEvent()`, and `ApplicationRepository` for `findById()`. Inject via constructor.

- [ ] **Step 1: Create review.service.ts**

```typescript
import { ReviewRepository } from '../repositories/review.repository';
import { createAndNotify, broadcastDashboardEvent } from './notification.service';
import { AuthUser } from '../shared/types';

export class ReviewService {
  private reviews = new ReviewRepository();

  async getMyReviews(user: AuthUser) {
    return this.reviews.getMyReviews(user.id);
  }

  async getApplicationReviews(applicationId: number) {
    return this.reviews.getApplicationReviews(applicationId);
  }

  async assignReview(data: any, user: AuthUser) {
    const assignment = await this.reviews.createAssignment({
      ...data,
      assigned_by: user.id,
    });

    await createAndNotify(
      data.reviewer_id,
      'REVIEW_ASSIGNED',
      'New Review Assignment',
      `You have been assigned a ${data.review_type} review.`,
      'HIGH'
    );

    broadcastDashboardEvent('stats-changed', {});

    return assignment;
  }

  async getRecommendations(applicationId: number) {
    return this.reviews.getRecommendations(applicationId);
  }

  async getComments(applicationId: number) {
    return this.reviews.getComments(applicationId);
  }

  async getAnswers(assignmentId: number) {
    return this.reviews.getAnswers(assignmentId);
  }

  async getScore(assignmentId: number) {
    return this.reviews.getScore(assignmentId);
  }

  async submitReview(assignmentId: number, user: AuthUser, data: any) {
    const assignment = await this.reviews.findAssignmentById(assignmentId);

    if (!assignment) {
      throw Object.assign(new Error('Review assignment not found'), { status: 404 });
    }

    if (assignment.reviewer_id !== user.id) {
      throw Object.assign(new Error('Not authorized to submit this review'), { status: 403 });
    }

    if (assignment.status_code === 'COMPLETED') {
      throw Object.assign(new Error('Review already submitted'), { status: 400 });
    }

    const validRecommendations = ['APPROVE', 'REJECT', 'CONDITIONAL', 'ABSTAIN'];
    if (!validRecommendations.includes(data.recommendation_type)) {
      throw Object.assign(new Error('Invalid recommendation type'), { status: 400 });
    }

    return this.reviews.submitReview(assignmentId, user.id, data);
  }

  async getForms() {
    return this.reviews.getForms();
  }

  async createForm(data: any) {
    return this.reviews.createForm(data);
  }

  async getQuestions(formId: number) {
    return this.reviews.getQuestions(formId);
  }

  async addQuestion(formId: number, data: any) {
    return this.reviews.addQuestion(formId, data);
  }

  async deleteQuestion(formId: number, questionId: number) {
    const deleted = await this.reviews.deleteQuestion(questionId, formId);
    if (!deleted) {
      throw Object.assign(new Error('Question not found'), { status: 404 });
    }
    return { message: 'Question deleted' };
  }
}
```

- [ ] **Step 2: Create voting.service.ts**

```typescript
import { VotingRepository } from '../repositories/committee.repository';
import { ApplicationRepository } from '../repositories/application.repository';
import { createAndNotifyBatch, broadcastDashboardEvent } from './notification.service';
import { AuthUser } from '../shared/types';

export class VotingService {
  private voting = new VotingRepository();
  private applications = new ApplicationRepository();

  async getVotingSessions(meetingId: number) {
    return this.voting.findByMeeting(meetingId);
  }

  async getVotingSession(id: number) {
    const session = await this.voting.findSessionById(id);
    if (!session) {
      throw Object.assign(new Error('Voting session not found'), { status: 404 });
    }
    const votes = await this.voting.getVotes(id);
    return { ...session, votes };
  }

  async createVotingSession(data: any) {
    return this.voting.createSession(data);
  }

  async castVote(sessionId: number, user: AuthUser, voteValue: string, comments?: string) {
    const session = await this.voting.findSessionById(sessionId);
    if (!session) {
      throw Object.assign(new Error('Voting session not found'), { status: 404 });
    }

    if (session.status_code !== 'OPEN') {
      throw Object.assign(new Error('Voting session is not open'), { status: 400 });
    }

    const existingVotes = await this.voting.getVotes(sessionId);
    const alreadyVoted = existingVotes.some((v: any) => v.voter_id === user.id);
    if (alreadyVoted) {
      throw Object.assign(new Error('Already voted'), { status: 400 });
    }

    return this.voting.castVote(sessionId, user.id, voteValue, comments);
  }

  async closeVotingSession(sessionId: number) {
    const session = await this.voting.findSessionById(sessionId);
    if (!session) {
      throw Object.assign(new Error('Voting session not found'), { status: 404 });
    }

    await this.voting.closeSession(sessionId);
    const votes = await this.voting.getVotes(sessionId);

    const voterIds = [...new Set(votes.map((v: any) => v.voter_id))];
    if (voterIds.length > 0) {
      await createAndNotifyBatch(
        voterIds.map((id) => ({
          userId: id,
          type: 'VOTING_CLOSED',
          subject: 'Voting Session Closed',
          body: `The voting session "${session.title}" has been closed.`,
          priority: 'MEDIUM',
        }))
      );
    }

    broadcastDashboardEvent('stats-changed', {});

    if (session.application_id) {
      const application = await this.applications.findById(session.application_id);
      if (application?.submitted_by) {
        await createAndNotifyBatch([
          {
            userId: application.submitted_by,
            type: 'APPLICATION_VOTE_CLOSED',
            subject: 'Application Voting Complete',
            body: `Voting for your application has been completed.`,
            priority: 'MEDIUM',
          },
        ]);
      }
    }

    return { message: 'Voting session closed' };
  }
}
```

- [ ] **Step 3: Update reviews.routes.ts to use ReviewService and VotingService**

Replace `import { CommitteeService } from '../../services/committee.service';` with:
```typescript
import { ReviewService } from '../../services/review.service';
import { VotingService } from '../../services/voting.service';
```

Replace `const service = new CommitteeService();` with:
```typescript
const reviewService = new ReviewService();
const votingService = new VotingService();
```

Update all `service.*` calls to use the appropriate service instance (`reviewService.*` or `votingService.*`).

- [ ] **Step 4: Remove review + voting methods from CommitteeService**

Remove lines 90–127 (review methods) and lines 217–267 (voting methods) from `committee.service.ts`. Also remove the `ReviewRepository` and `VotingRepository` imports that are no longer needed (unless other committee methods still use them — check first).

- [ ] **Step 5: Verify backend compiles**

Run: `npm run lint` in `backend/`
Expected: PASS (0 errors)

- [ ] **Step 6: Run existing tests to verify no regressions**

Run: `npm test` in `backend/`
Expected: 997+ tests pass

- [ ] **Step 7: Commit**

```bash
git add backend/src/services/review.service.ts backend/src/services/voting.service.ts backend/src/services/committee.service.ts backend/src/modules/committee/reviews.routes.ts
git commit -m "refactor(reviews): extract ReviewService + VotingService from CommitteeService"
```

---

### Task 3: Complete OpenAPI Spec for Reviews + Voting

**Files:**
- Modify: `backend/openapi/modules/committee.yaml` (review + voting paths need schemas)

**Interfaces:**
- Consumes: Route handlers from `reviews.routes.ts`, validation schemas from `middleware/schemas.ts`
- Produces: Complete OpenAPI paths with request/response schemas

**Current state:** 12 review paths + 5 voting paths exist as stubs with no request/response schemas.

- [ ] **Step 1: Add Notification schema to components**

Add to `committee.yaml` under `components/schemas`:

```yaml
ReviewAssignment:
  type: object
  properties:
    id: { type: integer }
    application_id: { type: integer }
    reviewer_id: { type: integer }
    reviewer_name: { type: string }
    review_type: { type: string, enum: [ETHICS, SCIENTIFIC] }
    status_code: { type: string }
    assigned_by: { type: integer }
    due_date: { type: string, format: date-time }
    form_id: { type: integer }
    created_at: { type: string, format: date-time }

ReviewForm:
  type: object
  properties:
    id: { type: integer }
    form_code: { type: string }
    form_name: { type: string }
    review_type: { type: string }
    description: { type: string }
    is_active: { type: boolean }
    question_count: { type: integer }

ReviewQuestion:
  type: object
  properties:
    id: { type: integer }
    form_id: { type: integer }
    question_code: { type: string }
    question_text: { type: string }
    question_type: { type: string, enum: [TEXT, SCALE, BOOLEAN, CHOICE] }
    is_required: { type: boolean }
    display_order: { type: integer }
    scale_min: { type: integer }
    scale_max: { type: integer }
    question_options: { type: string }

ReviewRecommendation:
  type: object
  properties:
    id: { type: integer }
    application_id: { type: integer }
    reviewer_id: { type: integer }
    reviewer_name: { type: string }
    recommendation_type: { type: string }
    justification: { type: string }
    created_at: { type: string, format: date-time }

ReviewComment:
  type: object
  properties:
    id: { type: integer }
    application_id: { type: integer }
    reviewer_id: { type: integer }
    reviewer_name: { type: string }
    comment_text: { type: string }
    is_internal: { type: boolean }
    created_at: { type: string, format: date-time }

ReviewAnswer:
  type: object
  properties:
    id: { type: integer }
    review_id: { type: integer }
    question_id: { type: integer }
    question_text: { type: string }
    answer_text: { type: string }
    answer_score: { type: number }

ReviewScore:
  type: object
  properties:
    id: { type: integer }
    application_id: { type: integer }
    reviewer_id: { type: integer }
    review_type: { type: string }
    score: { type: number }

VotingSession:
  type: object
  properties:
    id: { type: integer }
    meeting_id: { type: integer }
    application_id: { type: integer }
    voting_type: { type: string }
    title: { type: string }
    description: { type: string }
    status_code: { type: string }
    voting_start: { type: string, format: date-time }
    voting_end: { type: string, format: date-time }
    votes: { type: array, items: { $ref: '#/components/schemas/Vote' } }

Vote:
  type: object
  properties:
    id: { type: integer }
    voting_session_id: { type: integer }
    voter_id: { type: integer }
    voter_name: { type: string }
    vote_value: { type: string }
    comments: { type: string }
    vote_time: { type: string, format: date-time }
```

- [ ] **Step 2: Complete review path schemas**

For each of the 12 review paths, add request/response schemas. Example for `GET /reviews/my`:

```yaml
'/reviews/my':
  get:
    tags: [Reviews]
    summary: Get my review assignments
    security:
      - bearerAuth: []
    responses:
      '200':
        description: My review assignments
        content:
          application/json:
            schema:
              type: object
              properties:
                success:
                  type: boolean
                data:
                  type: array
                  items:
                    $ref: '#/components/schemas/ReviewAssignment'
```

Apply the same pattern to all 12 review paths and 5 voting paths.

- [ ] **Step 3: Verify OpenAPI spec is valid**

Run: `npx @redocly/cli lint backend/openapi/modules/committee.yaml` (if available)
Or manually verify: all `$ref` references resolve, no duplicate paths, all methods have responses.

- [ ] **Step 4: Commit**

```bash
git add backend/openapi/modules/committee.yaml
git commit -m "docs(openapi): complete review + voting schemas in committee.yaml"
```

---

### Task 4: Generate SDK from Updated OpenAPI

**Files:**
- Modify: `frontend/src/sdk/domains/reviews.sdk.ts` (regenerated from OpenAPI)
- Modify: `frontend/src/sdk/core/types.ts` (regenerated types)

**Interfaces:**
- Consumes: Updated `committee.yaml` from Task 3
- Produces: Updated SDK with correct types

- [ ] **Step 1: Run Orval to regenerate SDK**

```bash
cd frontend && npm run sdk
```

Expected: `reviews.sdk.ts` regenerated with correct types matching the OpenAPI spec.

- [ ] **Step 2: Verify generated types match DB columns**

Check that the generated types have:
- `ReviewForm.form_name` (not `title`)
- `ReviewAssignment` has all fields
- `ReviewAnswer.review_id` (not `assignment_id`), `answer_text` (not `answer_value`)
- `ReviewScore.score` (not `total_score`), `application_id` (not `assignment_id`)
- `Vote.voting_session_id` (not `session_id`), `vote_time` (not `voted_at`)

- [ ] **Step 3: Fix any type mismatches**

If Orval generates incorrect types, update the OpenAPI spec and regenerate.

- [ ] **Step 4: Commit**

```bash
git add frontend/src/sdk/domains/reviews.sdk.ts frontend/src/sdk/core/types.ts
git commit -m "chore(sdk): regenerate reviews SDK from updated OpenAPI spec"
```

---

### Task 5: Migrate ReviewFormsPage to SDK

**Files:**
- Modify: `frontend/src/pages/ReviewForms/ReviewFormsPage.tsx`

**Interfaces:**
- Consumes: `reviews` SDK object from `reviews.sdk.ts` (methods: `getForms`, `getQuestions`, `createForm`, `addQuestion`, `deleteQuestion`)
- Produces: Updated page using SDK instead of raw `api.*` calls

**Current raw API calls to replace:**

| Line | Current Call | SDK Replacement |
|------|-------------|-----------------|
| 44 | `api.get('/committee/reviews/forms')` | `reviews.getForms()` |
| 49 | `api.get('/committee/reviews/forms/${expandedForm}/questions')` | `reviews.getQuestions(expandedForm)` |
| 54 | `api.post('/committee/reviews/forms', data)` | `reviews.createForm(data)` |
| 60 | `api.post('/committee/reviews/forms/${expandedForm}/questions', data)` | `reviews.addQuestion(expandedForm, data)` |
| 67 | `api.delete('/committee/reviews/forms/${expandedForm}/questions/${id}')` | `reviews.deleteQuestion(expandedForm, id)` |

- [ ] **Step 1: Replace raw API calls with SDK calls**

Remove `import { api } from '../../api/client';` and replace with `import { reviews } from '../../sdk/domains/reviews.sdk';`.

Replace each `api.get/post/delete` call with the corresponding SDK method.

- [ ] **Step 2: Verify frontend compiles**

Run: `npm run lint` in `frontend/`
Expected: PASS (0 errors)

- [ ] **Step 3: Verify production build**

Run: `npm run build` in `frontend/`
Expected: PASS

- [ ] **Step 4: Commit**

```bash
git add frontend/src/pages/ReviewForms/ReviewFormsPage.tsx
git commit -m "refactor(reviews): migrate ReviewFormsPage to SDK"
```

---

### Task 6: Migrate Applications/Detail.tsx Review Calls to SDK

**Files:**
- Modify: `frontend/src/pages/Applications/Detail.tsx`

**Interfaces:**
- Consumes: `reviews` SDK object from `reviews.sdk.ts`
- Produces: Updated page using SDK for review-related calls

**Current raw API calls to replace:**

| Line | Current Call | SDK Replacement |
|------|-------------|-----------------|
| 86 | `api.get('/committee/reviews/application/${id}')` | `reviews.getApplicationReviews(id)` |
| 98 | `api.get('/committee/reviews/application/${id}/recommendations')` | `reviews.getRecommendations(id)` |
| 104 | `api.get('/committee/reviews/application/${id}/comments')` | `reviews.getComments(id)` |
| 148 | `api.get('/committee/reviews/forms')` | `reviews.getForms()` |
| 154 | `api.get('/committee/reviews/forms/${reviewForm.id}/questions')` | `reviews.getQuestions(reviewForm.id)` |
| 172 | `api.post('/committee/reviews/${myAssignment.id}/submit', body)` | `reviews.submitReview(myAssignment.id, body)` |

- [ ] **Step 1: Add SDK import**

Add `import { reviews } from '../../sdk/domains/reviews.sdk';` to the file.

- [ ] **Step 2: Replace review-related API calls with SDK calls**

Replace each `api.get/post` call for review endpoints with the corresponding SDK method.

**Important:** Keep `api.get` calls for non-review endpoints (application details, documents, etc.) — those are TD-003 and out of scope for this task.

- [ ] **Step 3: Verify frontend compiles**

Run: `npm run lint` in `frontend/`
Expected: PASS (0 errors)

- [ ] **Step 4: Verify production build**

Run: `npm run build` in `frontend/`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add frontend/src/pages/Applications/Detail.tsx
git commit -m "refactor(reviews): migrate review calls in Application Detail to SDK"
```

---

## Phase 2 — Notifications SDK Migration (Tasks 7–9)

### Task 7: Complete OpenAPI Spec for Notifications

**Files:**
- Modify: `backend/openapi/modules/communication.yaml`

**Interfaces:**
- Consumes: Route handlers from `communication/index.ts`
- Produces: Complete OpenAPI paths with request/response schemas

**Current state:** 4 paths exist with no schemas. Missing: `/notifications/unread-count`, `/notifications/stream` (SSE).

- [ ] **Step 1: Add Notification schema to components**

```yaml
components:
  schemas:
    Notification:
      type: object
      properties:
        id: { type: integer }
        user_id: { type: integer }
        notification_type: { type: string }
        subject: { type: string }
        message_body: { type: string }
        priority_level: { type: string }
        is_read: { type: boolean }
        source_entity_type: { type: string }
        source_entity_id: { type: integer }
        created_at: { type: string, format: date-time }
        sent_at: { type: string, format: date-time }

    UnreadCountResponse:
      type: object
      properties:
        success: { type: boolean }
        data:
          type: object
          properties:
            count: { type: integer }
```

- [ ] **Step 2: Add missing /notifications/unread-count path**

```yaml
'/notifications/unread-count':
  get:
    tags: [Notifications]
    summary: Get unread notification count
    security:
      - bearerAuth: []
    responses:
      '200':
        description: Unread count
        content:
          application/json:
            schema:
              type: object
              properties:
                success:
                  type: boolean
                data:
                  type: object
                  properties:
                    count:
                      type: integer
```

- [ ] **Step 3: Complete existing 4 paths with response schemas**

Add response schemas for GET /notifications, PATCH /notifications/{id}/read, PATCH /notifications/read-all, DELETE /notifications/{id}.

- [ ] **Step 4: Verify OpenAPI spec is valid**

- [ ] **Step 5: Commit**

```bash
git add backend/openapi/modules/communication.yaml
git commit -m "docs(openapi): complete notification schemas in communication.yaml"
```

---

### Task 8: Regenerate Communication SDK + Fix Type Mismatch

**Files:**
- Modify: `frontend/src/sdk/domains/communication.sdk.ts` (regenerated)
- Modify: `frontend/src/sdk/core/types.ts` (regenerated)

**Interfaces:**
- Consumes: Updated `communication.yaml` from Task 7
- Produces: Updated SDK with correct types

**Known type mismatch:** `Notification.title`/`body` should be `subject`/`message_body` (matches DB columns).

- [ ] **Step 1: Run Orval to regenerate SDK**

```bash
cd frontend && npm run sdk
```

- [ ] **Step 2: Verify Notification type has correct fields**

Check that the generated `Notification` type has `subject` and `message_body` (not `title` and `body`).

- [ ] **Step 3: Commit**

```bash
git add frontend/src/sdk/domains/communication.sdk.ts frontend/src/sdk/core/types.ts
git commit -m "chore(sdk): regenerate communication SDK with correct notification types"
```

---

### Task 9: Migrate Notifications Page to SDK + Add Live Updates

**Files:**
- Modify: `frontend/src/pages/Notifications/Notifications.tsx`

**Interfaces:**
- Consumes: `notifications` SDK object from `communication.sdk.ts`, `useNotificationStream` hook
- Produces: Updated page using SDK + SSE for live updates

**Current raw API calls to replace:**

| Line | Current Call | SDK Replacement |
|------|-------------|-----------------|
| 21 | `api.get('/communication/notifications')` | `notifications.list()` |
| 25 | `api.patch(...)` | `notifications.markAsRead(id)` |
| 30 | `api.patch(...)` | `notifications.markAllAsRead()` |
| 35 | `api.delete(...)` | `notifications.delete(id)` |

**Additional improvement:** Mount `useNotificationStream` hook for live updates. Currently the page has no SSE integration — notifications don't appear in real-time.

**Add unread count from API:** Currently computes client-side by filtering the full list. Replace with `notifications.getUnreadCount()` for efficiency.

- [ ] **Step 1: Replace raw API calls with SDK calls**

Remove `import { api } from '../../api/client';` and replace with `import { notifications } from '../../sdk/domains/communication.sdk';`.

Replace each `api.get/patch/delete` call with the corresponding SDK method.

- [ ] **Step 2: Add useNotificationStream hook**

Import and mount the `useNotificationStream` hook to enable live notification updates.

- [ ] **Step 3: Use getUnreadCount API**

Replace client-side filtering with `notifications.getUnreadCount()` for the unread badge.

- [ ] **Step 4: Verify frontend compiles**

Run: `npm run lint` in `frontend/`
Expected: PASS (0 errors)

- [ ] **Step 5: Verify production build**

Run: `npm run build` in `frontend/`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add frontend/src/pages/Notifications/Notifications.tsx
git commit -m "refactor(notifications): migrate to SDK + add SSE live updates"
```

---

## Phase 3 — Verification (Tasks 10–11)

### Task 10: Full Backend Verification

- [ ] **Step 1: TypeScript compilation**

Run: `npm run lint` in `backend/`
Expected: PASS (0 errors)

- [ ] **Step 2: Unit tests**

Run: `npm test` in `backend/`
Expected: 997+ tests pass (no regressions)

- [ ] **Step 3: Verify Reviews routes still work**

Check that `/api/v1/committee/reviews/*` and `/api/v1/committee/voting/*` URLs are unchanged.

- [ ] **Step 4: Verify Notification routes still work**

Check that `/api/v1/communication/notifications/*` URLs are unchanged.

---

### Task 11: Full Frontend Verification

- [ ] **Step 1: TypeScript compilation**

Run: `npm run lint` in `frontend/`
Expected: PASS (0 errors)

- [ ] **Step 2: Production build**

Run: `npm run build` in `frontend/`
Expected: PASS (< 3s, < 525KB JS)

- [ ] **Step 3: Verify SDK methods exist**

Check that `reviews.getMy()`, `reviews.getForms()`, `reviews.getQuestions()`, `reviews.createForm()`, `reviews.addQuestion()`, `reviews.deleteQuestion()`, `reviews.getApplicationReviews()`, `reviews.getRecommendations()`, `reviews.getComments()`, `reviews.submitReview()` all exist.

Check that `notifications.list()`, `notifications.getUnreadCount()`, `notifications.markAsRead()`, `notifications.markAllAsRead()`, `notifications.delete()` all exist.

- [ ] **Step 4: Verify no raw API calls remain in migrated pages**

Check `ReviewFormsPage.tsx`, `Notifications.tsx` for any remaining `api.get/patch/post/delete` calls to review or notification endpoints.

- [ ] **Step 5: Verify Applications/Detail.tsx review calls are migrated**

Check that the 6 review-related API calls are replaced with SDK calls. Non-review calls (TD-003) remain as-is.

---

## Commit Sequence

```
1. refactor(reviews): extract ReviewRepository from committee.repository.ts
2. refactor(reviews): extract ReviewService + VotingService from CommitteeService
3. docs(openapi): complete review + voting schemas in committee.yaml
4. chore(sdk): regenerate reviews SDK from updated OpenAPI spec
5. refactor(reviews): migrate ReviewFormsPage to SDK
6. refactor(reviews): migrate review calls in Application Detail to SDK
7. docs(openapi): complete notification schemas in communication.yaml
8. chore(sdk): regenerate communication SDK with correct notification types
9. refactor(notifications): migrate to SDK + add SSE live updates
```

---

## Success Criteria

| Criterion | Target |
|-----------|--------|
| Backend TypeScript | PASS (0 errors) |
| Frontend TypeScript | PASS (0 errors) |
| Production Build | PASS |
| Backend Tests | 997+ pass (no regressions) |
| Reviews routes | Unchanged URLs (/api/v1/committee/reviews/*) |
| Notification routes | Unchanged URLs (/api/v1/communication/notifications/*) |
| Raw API calls in Reviews pages | 0 (all migrated to SDK) |
| Raw API calls in Notifications page | 0 (all migrated to SDK) |
| OpenAPI spec (reviews) | Complete with schemas |
| OpenAPI spec (notifications) | Complete with schemas |
| SDK types match DB columns | Yes |
| SSE live updates in Notifications | Enabled |
| Regressions | 0 |
| Commits | 9 atomic commits |
