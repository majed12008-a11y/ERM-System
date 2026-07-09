# Phase 2 — Conditional Approval / Conditions Module

**Status**: Approved with modifications (2026-07-02)  
**Depends on**: Phase 1.6 hotfix for `TERMINAL_STATES` in `workflow.service.ts`

---

## 1. DB Schema: `committee.application_conditions`

```sql
CREATE TABLE committee.application_conditions (
  id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  application_id    BIGINT NOT NULL REFERENCES core.applications(id) ON DELETE CASCADE,
  condition_text    TEXT NOT NULL,
  severity          VARCHAR(10) NOT NULL DEFAULT 'MAJOR'
                      CHECK (severity IN ('MINOR', 'MAJOR', 'CRITICAL')),
  category          VARCHAR(50) DEFAULT 'GENERAL'
                      CHECK (category IN ('GENERAL', 'SCIENTIFIC', 'ETHICAL', 'ADMINISTRATIVE', 'SAFETY')),
  due_date          TIMESTAMPTZ,
  status            VARCHAR(20) NOT NULL DEFAULT 'OPEN'
                      CHECK (status IN ('OPEN', 'MET', 'NOT_MET', 'WAIVED')),
  resolved_by       BIGINT REFERENCES security.users(id),
  resolved_at       TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_by        BIGINT NOT NULL REFERENCES security.users(id),
  updated_at        TIMESTAMPTZ,
  updated_by        BIGINT REFERENCES security.users(id),
  deleted_at        TIMESTAMPTZ,
  deleted_by        BIGINT REFERENCES security.users(id)
);

CREATE INDEX idx_app_conditions_app_id ON committee.application_conditions(application_id)
  WHERE deleted_at IS NULL;

CREATE INDEX idx_app_conditions_status ON committee.application_conditions(status)
  WHERE deleted_at IS NULL;
```

Evidence documents reuse the existing `documents.documents` table with polymorphic link:  
`entity_type = 'ApplicationCondition'`, `entity_id = <condition_id>`.

### Policy: Document retention on condition delete

When a condition is soft-deleted, its linked evidence documents are **not** cascade-deleted. Instead:

- The documents remain in `documents.documents` with `deleted_at` untouched — they persist for audit/history.
- A background cleanup query (run monthly via pg_cron or scheduler) identifies orphaned evidence documents where the parent condition was deleted >90 days ago and marks them as soft-deleted:
  ```sql
  UPDATE documents.documents d
  SET deleted_at = now(), deleted_by = 0
  WHERE d.entity_type = 'ApplicationCondition'
    AND d.deleted_at IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM committee.application_conditions ac
      WHERE ac.id = d.entity_id::bigint AND ac.deleted_at IS NULL
    )
    AND d.created_at < now() - INTERVAL '90 days';
  ```

---

## 2. RLS Policies

### SELECT: application owner OR committee of the application OR admin

```sql
CREATE POLICY app_conditions_select ON committee.application_conditions FOR SELECT
  USING (
    -- Application owner
    application_id IN (
      SELECT id FROM core.applications
      WHERE submitted_by = current_setting('app.user_id')::BIGINT
    )
    OR
    -- Member of the specific committee assigned to this application
    application_id IN (
      SELECT a.id FROM core.applications a
      WHERE a.target_committee_id IN (
        SELECT cm.committee_id FROM committee.committee_members cm
        WHERE cm.user_id = current_setting('app.user_id')::BIGINT
          AND cm.is_active = true
      )
    )
    OR
    -- Super admin / ethics admin bypass
    system.fn_is_admin()
  );
```

This scopes committee access to only those committees linked to the application, not all committees.

### INSERT / UPDATE / DELETE: Committee members (scoped) + admins

```sql
CREATE POLICY app_conditions_insert ON committee.application_conditions FOR INSERT
  WITH CHECK (
    system.fn_is_admin()
    OR EXISTS (
      SELECT 1 FROM core.applications a
      JOIN committee.committee_members cm ON cm.committee_id = a.target_committee_id
      WHERE a.id = application_id
        AND cm.user_id = current_setting('app.user_id')::BIGINT
        AND cm.is_active = true
    )
  );

CREATE POLICY app_conditions_update ON committee.application_conditions FOR UPDATE
  USING (
    system.fn_is_admin()
    OR EXISTS (
      SELECT 1 FROM core.applications a
      JOIN committee.committee_members cm ON cm.committee_id = a.target_committee_id
      WHERE a.id = application_id
        AND cm.user_id = current_setting('app.user_id')::BIGINT
        AND cm.is_active = true
    )
  )
  WITH CHECK (
    -- Researchers cannot resolve conditions (enforced at DB level)
    current_setting('app.user_id')::BIGINT NOT IN (
      SELECT id FROM security.users
      WHERE NOT (system.fn_is_admin() OR EXISTS (
        SELECT 1 FROM committee.committee_members cm
        WHERE cm.user_id = security.users.id AND cm.is_active = true
      ))
    )
  );
```

The `WITH CHECK` on UPDATE prevents non-committee, non-admin users from modifying condition status. This is defense-in-depth — the service layer also enforces this.

---

## 3. Workflow Integration

### Condition Validation Hook

In `ApplicationService.updateStatus()`, add before `workflow.executeTransition()`:

```typescript
const conditionTransitions = ['COMMITTEE_CONDITIONAL', 'CONDITIONS_MET', 'CONDITIONS_NOT_MET', 'SUBMIT_EVIDENCE', 'REJECT_CONDITIONS'];
if (conditionTransitions.includes(transitionCode)) {
  await this.conditionService.validateTransition(transitionCode, id, user, client);
}
```

### Entry gate: `COMMITTEE_CONDITIONAL` (COMMITTEE_REVIEW → AWAITING_CONDITIONS)

```
WHEN transition_code = 'COMMITTEE_CONDITIONAL':
  REQUIRE: At least one OPEN condition exists for this application
  REJECT: 400 "At least one condition must be specified before conditional approval"
```

### Exit gate: `CONDITIONS_MET` (AWAITING_CONDITIONS → APPROVED)

```
WHEN transition_code = 'CONDITIONS_MET':
  REQUIRE: All conditions have status = 'MET'
  REJECT: 400 "All conditions must be marked MET before approving"
           + list of condition_ids that are not MET
```

### Exit gate: `CONDITIONS_NOT_MET` (AWAITING_CONDITIONS → EVIDENCE_REJECTED)

```
WHEN transition_code = 'CONDITIONS_NOT_MET':
  REQUIRE: At least one condition has status = 'NOT_MET'
           OR any condition has status = 'OPEN' with past due_date
  SOFT: Admin discretion — warning logged if none unmet
  COMMENT: Required (existing transition rule)
```

### Re-entry: `SUBMIT_EVIDENCE` (EVIDENCE_REJECTED → AWAITING_CONDITIONS)

```
WHEN transition_code = 'SUBMIT_EVIDENCE':
  REQUIRE: Every condition with status 'OPEN' or 'NOT_MET'
           has at least one evidence document attached.
           Document query:
             SELECT d.id FROM documents.documents d
             WHERE d.entity_type = 'ApplicationCondition'
               AND d.entity_id::bigint = <condition_id>
               AND d.deleted_at IS NULL
  REJECT: 400 "Evidence required for all unresolved conditions"
           + list of condition_ids missing evidence
```

### Terminal reject: `REJECT_CONDITIONS` (EVIDENCE_REJECTED → REJECTED)

```
WHEN transition_code = 'REJECT_CONDITIONS':
  VALIDATION: Admin discretion — no condition-level guard
  COMMENT: Required (existing transition rule)
```

---

## 4. Backend Services

### `ConditionService`

```
backend/src/services/condition.service.ts
```

| Method | Purpose |
|---|---|
| `getConditions(applicationId)` | List conditions for an app (RLS-filtered) |
| `createCondition(applicationId, data, user)` | Create condition |
| `updateCondition(id, data, user)` | Edit text, severity, category, due_date |
| `resolveCondition(id, status, user)` | Mark MET / NOT_MET / WAIVED. **Researcher role rejected** |
| `deleteCondition(id, user)` | Soft delete. **Blocked if last OPEN condition in AWAITING_CONDITIONS / EVIDENCE_REJECTED** |
| `validateTransition(transitionCode, applicationId, user, client?)` | Pre-execution guard for 5 transitions (per §3) |
| `evaluate(applicationId)` | Aggregate helper returning condition summary + boolean flags |

### `ConditionService.evaluate()` — Aggregate Helper

```typescript
interface ConditionEvaluation {
  total: number
  open: number
  met: number
  notMet: number
  waived: number
  allSatisfied: boolean       // all conditions are MET or WAIVED
  canApprove: boolean         // allSatisfied && application is in AWAITING_CONDITIONS
  canReject: boolean          // application is in AWAITING_CONDITIONS
  canSubmitEvidence: boolean  // application is in EVIDENCE_REJECTED
                             // && every OPEN/NOT_MET condition has evidence docs
  unmetConditionIds: number[]
  missingEvidenceIds: number[]
}
```

Used by:
- Frontend to determine which buttons/transitions to show
- `validateTransition()` to avoid re-querying
- Notification decision logic

### `ConditionRepository`

```
backend/src/repositories/condition.repository.ts
```

Extends `AuditableRepository`. Methods:
- `findByApplication(applicationId)` — list, ordered by severity desc, created_at asc
- `findById(id)` — single
- `create(data)` — with `this.createMeta()`
- `update(id, data)` — with `this.updateMeta()`
- `softDelete(id)` — with `this.deleteMeta()`
- `resolveStatus(id, status, resolvedBy)` — sets `status, resolved_by, resolved_at`
- `getOpenCount(applicationId)` — count of `OPEN` conditions for the app
- `getUnmetConditionIds(applicationId)` — IDs where status in `('OPEN', 'NOT_MET')`
- `evaluateEvidenceCoverage(applicationId, conditionIds)` — returns `{ condition_id, has_evidence }[]`
- `countByStatus(applicationId)` — aggregate counts

All queries filter `WHERE deleted_at IS NULL`.

### Deletion Guard

```typescript
// In ConditionService.deleteCondition():
const app = await this.applicationRepo.findById(condition.application_id);
if (['AWAITING_CONDITIONS', 'EVIDENCE_REJECTED'].includes(app.current_status)) {
  const openCount = await this.repo.getOpenCount(condition.application_id);
  if (openCount <= 1) {
    throw Object.assign(
      new Error('Cannot delete the last condition while application is in conditions review'),
      { status: 409 }
    );
  }
}
```

### Feature Flag: `CONDITIONS_MODULE_ENABLED`

In `backend/src/config/env.ts`:
```typescript
CONDITIONS_MODULE_ENABLED: z.coerce.boolean().default(true),
```

**Behavior when disabled:**
- `ConditionService.validateTransition()` — returns silently (no-op), allowing workflow transitions to proceed without condition checks
- `ConditionService.getConditions()` — returns empty array
- `ConditionService.evaluate()` — returns `{ total: 0, open: 0, ..., allSatisfied: true, canApprove: false, ... }`
- Routes remain registered — they return empty/safe responses rather than 404
- Frontend condition panel does not render (checked via `/conditions/summary` returning zeroes)

This ensures that rolling back Phase 2 doesn't break the core workflow — all transitions still work, just without condition guards.

### Routes: `conditions.routes.ts`

```
backend/src/modules/conditions/
  index.ts
  conditions.routes.ts
```

| Method | Path | Auth | Roles | Purpose |
|---|---|---|---|---|
| `GET` | `/core/applications/:id/conditions` | JWT | — | List |
| `GET` | `/core/applications/:id/conditions/summary` | JWT | — | Counts |
| `GET` | `/core/applications/:id/conditions/evaluate` | JWT | — | `evaluate()` result |
| `POST` | `/core/applications/:id/conditions` | JWT | COMMITTEE_MEMBER, ETHICS_ADMIN, SUPER_ADMIN | Create |
| `PUT` | `/core/applications/:id/conditions/:conditionId` | JWT | COMMITTEE_MEMBER, ETHICS_ADMIN, SUPER_ADMIN | Update |
| `PATCH` | `/core/applications/:id/conditions/:conditionId/resolve` | JWT | COMMITTEE_MEMBER, ETHICS_ADMIN, SUPER_ADMIN | Resolve |
| `DELETE` | `/core/applications/:id/conditions/:conditionId` | JWT | ETHICS_ADMIN, SUPER_ADMIN | Soft delete |

---

## 5. Notifications

### Event Types

Add to `communication.notification_templates`:

| event_code | Subject (ar) | Trigger | Recipient |
|---|---|---|---|
| `CONDITIONS_SET` | "تم تحديد شروط للموافقة على الطلب {app_number}" | COMMITTEE_CONDITIONAL | Researcher |
| `CONDITIONS_MET` | "تم استيفاء شروط الطلب {app_number}" | CONDITIONS_MET | Researcher + committee chair |
| `CONDITIONS_NOT_MET` | "لم يتم استيفاء شروط الطلب {app_number}" | CONDITIONS_NOT_MET | Researcher |
| `EVIDENCE_SUBMITTED` | "تم تقديم أدلة جديدة للطلب {app_number}" | SUBMIT_EVIDENCE | Committee chair + ethics admin |
| `CONDITION_REJECTED` | "تم رفض الطلب لعدم استيفاء الشروط {app_number}" | REJECT_CONDITIONS | Researcher |
| `CONDITION_REMINDER` | "تذكير: استيفاء شروط الطلب {app_number}" | Scheduler (daily) | Researcher |
| `CONDITION_OVERDUE` | "انتهت مهلة استيفاء شروط الطلب {app_number}" | Scheduler | Researcher + committee chair |

### Dispatch Hook

In `ApplicationService.updateStatus()`, after successful transition + condition validation:

```typescript
switch (transitionCode) {
  case 'COMMITTEE_CONDITIONAL':
    await notify(application.submitted_by, 'CONDITIONS_SET', { app_number }, 'HIGH');
    break;
  case 'CONDITIONS_MET':
    await notify(application.submitted_by, 'CONDITIONS_MET', { app_number });
    await notifyCommittee(application.target_committee_id, 'CONDITIONS_MET', { app_number });
    break;
  case 'CONDITIONS_NOT_MET':
    await notify(application.submitted_by, 'CONDITIONS_NOT_MET', { app_number });
    break;
  case 'SUBMIT_EVIDENCE':
    await notifyCommittee(application.target_committee_id, 'EVIDENCE_SUBMITTED', { app_number });
    break;
  case 'REJECT_CONDITIONS':
    await notify(application.submitted_by, 'CONDITION_REJECTED', { app_number });
    break;
}
```

---

## 6. Scheduler Design

### Due-Date Reminders and Overdue Escalation

A new scheduled job (runs via existing cron mechanism or a simple `setInterval` in a dedicated service):

```
backend/src/services/condition-scheduler.service.ts
```

| Job | Frequency | Query | Action |
|---|---|---|---|
| `checkDueDates` | Daily (06:00) | `SELECT ac.* FROM committee.application_conditions ac JOIN core.applications a ON a.id = ac.application_id WHERE ac.status = 'OPEN' AND ac.due_date IS NOT NULL AND ac.due_date <= now() + INTERVAL '3 days' AND ac.due_date > now() AND a.current_status = 'AWAITING_CONDITIONS'` | Send `CONDITION_REMINDER` notification |
| `checkOverdue` | Daily (06:00) | `SELECT ac.* ... WHERE ac.status = 'OPEN' AND ac.due_date IS NOT NULL AND ac.due_date < now() AND a.current_status IN ('AWAITING_CONDITIONS', 'EVIDENCE_REJECTED')` | Send `CONDITION_OVERDUE` notification + optionally auto-trigger `CONDITIONS_NOT_MET` (configurable, default OFF) |

### Auto-reject (configurable, default OFF)

If `CONDITIONS_AUTO_REJECT_OVERDUE = true` in `.env`:
```typescript
// In checkOverdue job:
await applicationService.updateStatus(applicationId, {
  transition_code: 'CONDITIONS_NOT_MET',
  comment: 'تلقائي: انتهت المهلة المحددة لاستيفاء الشروط',
}, systemUser);
```

---

## 7. Frontend

### Components

```
frontend/src/components/ConditionsPanel.tsx
  ├── ConditionSummaryBar     — "3 of 5 conditions met" progress + counts
  ├── ConditionCard           — individual condition (text, severity, category, due date, status)
  │     ├── ConditionCardEdit       — inline edit form (committee view)
  │     ├── ConditionCardResolve    — status toggle dropdown (committee view)
  │     └── ConditionCardEvidence   — evidence upload + document list (researcher view)
  └── ConditionList           — list of ConditionCards with add button
```

### Context-Aware Behavior

| Status | Committee View | Researcher View |
|---|---|---|
| `COMMITTEE_REVIEW` | "Conditional Approve" button opens condition creation dialog. Must add ≥1 condition to proceed with COMMITTEE_CONDITIONAL | Nothing |
| `AWAITING_CONDITIONS` | Condition list (read/write). Resolve dropdowns. CONDITIONS_MET / CONDITIONS_NOT_MET buttons in transition area | Condition list (read-only). Evidence upload per condition. No resolve buttons. Transition dropdown hidden |
| `EVIDENCE_REJECTED` | Condition list (read-only review). REJECT_CONDITIONS button | Condition list (read-only). Evidence upload per condition. "Submit Evidence" button |
| `APPROVED` | Condition list (read-only, historical) | Same |

### Transition Area Modification

In `Detail.tsx`, when `current_status` is `AWAITING_CONDITIONS`:

- **Replace** the generic transition dropdown with two dedicated buttons:
  - "✓ Mark Conditions Met" (calls `CONDITIONS_MET`) — disabled unless `evaluate().canApprove === true`
  - "✗ Mark Conditions Not Met" (calls `CONDITIONS_NOT_MET`) — requires comment

When `current_status` is `EVIDENCE_REJECTED`:

- **Show** generic transition dropdown filtered to `SUBMIT_EVIDENCE` and `REJECT_CONDITIONS`
- Researcher sees only `SUBMIT_EVIDENCE`
- Committee sees both

### StatusBadge Update

Add entries for new statuses:

| Status | Variant | Style |
|---|---|---|
| `AWAITING_CONDITIONS` | `warning` | `bg-amber-100 text-amber-800` |
| `EVIDENCE_REJECTED` | `destructive` | `bg-red-100 text-red-800` |

---

## 8. Permission Matrix (Revised)

| Action | RESEARCHER | COMMITTEE_MEMBER* | ETHICS_ADMIN | COMMITTEE_CHAIR | SUPER_ADMIN |
|---|---|---|---|---|---|
| View conditions (own app) | ✓ | — | — | — | — |
| View conditions (scoped committee app) | — | ✓ | ✓ | ✓ | ✓ |
| Create condition | — | ✓ | ✓ | ✓ | ✓ |
| Edit condition | — | ✓ | ✓ | ✓ | ✓ |
| Resolve condition (MET / NOT_MET / WAIVED) | — | **✓** | ✓ | ✓ | ✓ |
| Delete condition | — | — | ✓ | — | ✓ |
| Upload evidence | ✓ | — | — | — | — |
| Execute COMMITTEE_CONDITIONAL | — | — | ✓ | ✓ | ✓ |
| Execute CONDITIONS_MET | — | — | ✓ | ✓ | ✓ |
| Execute CONDITIONS_NOT_MET | — | — | ✓ | ✓ | ✓ |
| Execute SUBMIT_EVIDENCE | ✓ | — | — | — | — |
| Execute REJECT_CONDITIONS | — | — | ✓ | ✓ | ✓ |

*Committee_Member scoped to the specific committee assigned to the application (via `core.applications.target_committee_id`).

---

## 9. Implementation Order

| Step | Deliverable | Depends On |
|---|---|---|
| **0** | **Phase 1.6 hotfix**: Add `ARCHIVED` to `TERMINAL_STATES` in `workflow.service.ts` | — |
| 1 | DB migration (`committee.application_conditions` table) | — |
| 2 | RLS policies (scoped committee access per §2) | Step 1 |
| 3 | `ConditionRepository` | Step 1 |
| 4 | `ConditionService` (CRUD + validateTransition + evaluate + deletion guard) | Step 3 |
| 5 | `ConditionSchedulerService` (due-date reminders, overdue escalation) | Step 4 |
| 6 | Registration: scheduler in app startup | Step 5 |
| 7 | Seed: document type `EVIDENCE_DOC` + notification templates | — |
| 8 | Backend routes + module registration | Step 4 |
| 9 | `ApplicationService.updateStatus()` integration (validation hook + notifications) | Step 4, 8 |
| 10 | Feature flag wiring (`CONDITIONS_MODULE_ENABLED`) | Step 4, 8 |
| 11 | SDK types + methods | — |
| 12 | `ConditionsPanel` + sub-components | Step 11 |
| 13 | `Detail.tsx` integration (context-aware transitions, panel rendering) | Step 12 |
| 14 | `StatusBadge` update | — |
| 15 | E2E tests | Steps 1–14 |
| 16 | Document cleanup policy (90-day orphaned evidence purge) | — |
