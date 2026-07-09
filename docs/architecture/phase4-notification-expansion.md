# Phase 4 — Notification Expansion (Architecture Review)

**Status**: Architecture Contract — v2 (2026-07-03)  
**Depends on**: Phase 3 (Certificate Subsystem), existing SSE infrastructure  
**Review status**: Changes applied per review — ready for approval

---

## 1. Trigger Matrix

### 1.1 Workflow Transition Notifications

| # | event_code | Source Service | Trigger Timing | Recipient(s) | Priority | Notes |
|---|-----------|---------------|----------------|-------------|----------|-------|
| W1 | APPLICATION_SUBMITTED | `application.service.ts:updateStatus` (SUBMIT) | After main txn commits | All admins + chair of target committee | HIGH | Notify all ETHICS_ADMIN + SUPER_ADMIN + COMMITTEE_CHAIR |
| W2 | APPLICATION_IN_REVIEW | `application.service.ts:updateStatus` (ACCEPT_INITIAL) | After main txn commits | Applicant (`app.submitted_by`) | NORMAL | Initial review started |
| W3 | REVIEW_ASSIGNED | `application.service.ts:updateStatus` (SEND_TO_SCIENTIFIC or SEND_TO_ETHICAL) | After main txn commits | Assigned reviewer(s) | HIGH | Reviewer needs to act |
| W4 | APPLICATION_FOR_COMMITTEE | `application.service.ts:updateStatus` (SEND_TO_COMMITTEE) | After main txn commits | Committee chair + all committee members | HIGH | Committee review pending |
| W5 | APPLICATION_APPROVED | `application.service.ts:updateStatus` (COMMITTEE_APPROVE) | After main txn commits | Applicant | HIGH | Final approval |
| W6 | APPLICATION_REJECTED | `application.service.ts:updateStatus` (COMMITTEE_REJECT, REJECT_*) | After main txn commits | Applicant | HIGH | Final rejection |
| W7 | CONDITIONS_REQUIRED | `application.service.ts:updateStatus` (COMMITTEE_CONDITIONAL) | After main txn commits | Applicant | HIGH | Conditional approval |
| W8 | APPLICATION_RETURNED | `application.service.ts:updateStatus` (COMMITTEE_RETURN) | After main txn commits | Applicant | NORMAL | Returned for revision |
| W9 | APPLICATION_WITHDRAWN | `application.service.ts:withdrawApplication` (WITHDRAW*) | After main txn commits | All admins + committee chair | NORMAL | Applicant withdrew |
| W10 | APPLICATION_APPEALED | `application.service.ts:appealDecision` (APPEAL) | After main txn commits | All admins + committee chair | HIGH | Rejected decision appealed |
| W11 | APPLICATION_RENEWAL | `application.service.ts:initiateRenewal` (INITIATE_RENEWAL) | After main txn commits | Applicant | NORMAL | Annual renewal started |

### 1.2 Conditions Notifications

| # | event_code | Source Service | Trigger Timing | Recipient(s) | Priority | Notes |
|---|-----------|---------------|----------------|-------------|----------|-------|
| C1 | CONDITION_ADDED | `condition.service.ts:createCondition` | After repo.create() returns | Applicant | NORMAL | Admin added a condition |
| C2 | CONDITION_RESOLVED_MET | `condition.service.ts:resolveCondition` (→ MET) | After repo.resolveStatus() returns | Admins + committee chair | HIGH | Applicant resolved a condition |
| C3 | CONDITION_NOT_MET | `condition.service.ts:resolveCondition` (→ NOT_MET) | After repo.resolveStatus() returns | Applicant | HIGH | Admin marked condition not met |
| C4 | CONDITION_WAIVED | `condition.service.ts:resolveCondition` (→ WAIVED) | After repo.resolveStatus() returns | Applicant | NORMAL | Condition waived (no action needed) |
| C5 | EVIDENCE_REJECTED | Evidence rejection pathway (→ NOT_MET on evidence condition) | After repo.resolveStatus() returns | Applicant | HIGH | Evidence rejected |

### 1.3 Certificate Notifications

| # | event_code | Source Service | Trigger Timing | Recipient(s) | Priority | Notes |
|---|-----------|---------------|----------------|-------------|----------|-------|
| P1 | CERTIFICATE_ISSUED | `certificate.service.ts:generate` (after `markIssued`) | Inside async fire-and-forget, after DB write | Applicant | HIGH | Certificate ready for download |
| P2 | CERTIFICATE_REVOKED | `certificate.service.ts:revoke` | After repo.revoke() returns | Applicant | HIGH | Certificate revoked |
| P3 | CERTIFICATE_REISSUED | `certificate.service.ts:reissue` (after `markIssued`) | Inside async fire-and-forget, after DB write | Applicant | NORMAL | New version issued |
| P4 | CERTIFICATE_GENERATION_FAILED | `certificate.service.ts:generate` catch block | Inside async fire-and-forget, after FAILED status set | Admins | HIGH | Generation failure needs admin intervention |

---

## 2. Transaction Boundary

### Rule (immutable)
**Workflow state changes must never fail because notification delivery failed.**

### Approved flow

```
PATCH /api/v1/applications/:id/status

  ┌──────────────────────────────────────────────────────────┐
  │  Step 1: Pre-checks (outside transaction)                │
  │  • Fetch app, validate transition_code, check permissions │
  └──────────────────────────────────────────────────────────┘
       │
       ▼
  ┌──────────────────────────────────────────────────────────┐
  │  Step 2: withTransaction()                                │
  │  │                                                        │
  │  ├── workflow.executeTransition(..., client)              │
  │  │     → INSERT INTO workflow_executions                  │
  │  │     → INSERT INTO workflow_comments (if comment)       │
  │  │                                                        │
  │  ├── repo.updateStatus(id, to_state, client)              │
  │  │     → UPDATE applications SET current_status           │
  │  │                                                        │
  │  ├── ★ NotificationRepository.createPending()              │
  │  │     → INSERT INTO communication.notifications          │
  │  │       (user_id, notification_type, subject,            │
  │  │        message_body, source_entity_type,               │
  │  │        source_entity_id, sent_at = NULL)               │
  │  │     → Uses transactional client                        │
  │  │     → Returns notification_id                          │
  │  │                                                        │
  │  └── return { updated, notificationIds[] }                │
  │                                                            │
  │  ★ TRANSACTION COMMITS ★                                  │
  │  On commit → workflow state + notification row are durable │
  │  On rollback → notification row also rolls back (correct)  │
  └──────────────────────────────────────────────────────────┘
       │
       ▼  COMMIT SUCCESS — WORKFLOW + NOTIFICATION(S) ARE DURABLE
       │
  ┌──────────────────────────────────────────────────────────┐
  │  Step 3: Post-commit delivery (fire-and-forget)           │
  │                                                            │
  │  Each notificationId → NotificationService.deliver()      │
  │    1. Read notification from DB (separate connection)     │
  │    2. SSE.broadcastToUser()                                │
  │       → In-memory, best-effort                             │
  │       → If client not connected: notification in DB only   │
  │    3. ChannelRouter.dispatch(notification)                 │
  │       → Email/SMS/Push (if configured, Phase 4 scaffold)   │
  │       → Logs to notification_logs                          │
  │    4. repo.markDelivered(notificationId)                   │
  │       → UPDATE sent_at = now()                             │
  │       → Separate connection, own transaction               │
  │       → If this fails: sent_at stays NULL, retry later     │
  │                                                            │
  │  ★ NEVER THROW — errors logged, workflow unaffected        │
  │                                                            │
  │  Certificate auto-generation (existing):                    │
  │  this.certificates.generate(id).catch(...)                  │
  │                                                            │
  │  Dashboard SSE (existing):                                  │
  │  broadcastDashboardEvent('dashboard-stats', {})             │
  └──────────────────────────────────────────────────────────┘
```

### Key design decisions

| Aspect | Decision | Rationale |
|--------|----------|-----------|
| Notification INSERT inside transaction? | **YES** | Atomic with workflow state change. If crash occurs between COMMIT and delivery, the notification row is already in DB (persistent, not lost). |
| Channel delivery inside transaction? | **NO** | Delivery failures must not roll back the workflow. |
| Which connection for `createPending()`? | Transactional `client` | Passed into `withTransaction()` callback. Uses same PoolClient as workflow execution. |
| Which connection for `deliver()`? | Separate pool `query()` | Independent of the committed transaction. Can fail without affecting anything. |
| What if crash between COMMIT and `deliver()`? | Notification persists in DB with `sent_at = NULL` | On restart, user sees it on next `/notifications` poll. No permanent loss. A background job (Phase 5) can retry delivery for `sent_at IS NULL` notifications. |
| What if `deliver()` succeeds but `markDelivered()` fails? | `sent_at` stays NULL | Next delivery attempt would re-broadcast SSE (best-effort, duplicate is harmless) and re-attempt channel delivery (idempotent per `notification_logs`). |

### Conditions and Certificates

Conditions service does not use `withTransaction()` currently — each operation is a single query. For consistency:

```typescript
// Condition service — uses same pattern if inside a route-level transaction
async resolveCondition(id, status, user) {
  const updated = await this.repo.resolveStatus(id, status, user.id);
  // Post-condition: async create + deliver notification
  this.notificationService.createAndDeliver(
    user.id, notificationType, subject, body, 'Condition', id
  ).catch(logger.error);
}
```

Certificate generation is already async fire-and-forget. The `CERTIFICATE_ISSUED` notification fires inside `generate()` after `markIssued()` succeeds. It uses `createAndDeliver()` (non-transactional, since cert generation isn't wrapped in a workflow transaction).

---

## 3. Notification Architecture

### Layers

```
┌──────────────────────────────────────────────────────────┐
│                    Domain Services                        │
│  (ApplicationService, ConditionService, CertificateSvc)  │
│  Call: notificationService.createAndDeliver()             │
│    → Inside txn: call createPending(client)               │
│    → After commit: call deliver(id)                       │
│    → For non-txn contexts: createPending + deliver async  │
└──────────────────────┬───────────────────────────────────┘
                       │
┌──────────────────────▼───────────────────────────────────┐
│                  NotificationService                       │
│  Responsibilities:                                        │
│  • createPending(client, data) — INSERT inside txn         │
│  • deliver(notificationId) — after-commit delivery         │
│  • createAndDeliver(userId, type, ...) — convenience       │
│    helper for non-txn contexts (creates then delivers)     │
│  • Service-level dedup check before createPending()        │
│  • SSE.broadcast() after commit                            │
│  • ChannelRouter.dispatch() after commit                   │
│  • markDelivered() after all channel delivery              │
│  • NEVER throw to caller                                   │
└────┬──────────────────────┬──────────────────┬────────────┘
     │                      │                  │
┌────▼─────────┐   ┌───────▼────────┐  ┌─────▼────────────┐
│NotificationR  │   │ ChannelRouter  │  │TemplateRenderer  │
│epository      │   │                │  │                  │
│               │   │ Determine      │  │ Compile          │
│ • createPending│   │ channels per   │  │ Handlebars       │
│   (with client)│   │ notification   │  │ templates from   │
│ • findById()  │   │ type + user    │  │ notification_    │
│ • findByUser()│   │ preferences    │  │ templates table  │
│ • markRead()  │   │                │  │                  │
│ • markDelivered│  │ For each:      │  │ Cached per       │
│ • logDelivery │   │  deliver async │  │ notification_type│
│ • getPrefs()  │   └───────┬────────┘  └──────────────────┘
│ • checkDedup()│           │
│ • getTemplate │  ┌────────▼──────────────────────┐
└───────┬───────┘  │     SSE Broadcaster            │
        │          │  (in-memory Map<userId, SSE[]> │
        │          │   addClient, broadcastToUser)   │
        │          └────────────────────────────────┘
        │
        │          ┌────────────────────────────────┐
        │          │  EmailService / SmsService     │
        │          │  (scaffold only — Phase 4)     │
        │          └────────────────────────────────┘
```

### Two-phase notification lifecycle

```
                    Phase 1 (inside txn)     Phase 2 (after commit)
                    ────────────────────     ─────────────────────
Service called:     createPending(client)    deliver(id)
DB write:           INSERT notification      UPDATE sent_at = now()
SSE:                —                        broadcastToUser()
Channel dispatch:   —                        ChannelRouter.dispatch()
Error handling:     Rollback txn             Log + return
Crash after step:   Notification rolls back  Notification in DB (sent_at = NULL)
```

### No overlapping responsibilities

- **NotificationService** is the ONLY entry point from domain services
- **NotificationRepository** is the ONLY component that writes to `communication.notifications` and `notification_logs`
- **SSE Broadcaster** is called ONLY by NotificationService.deliver()
- **TemplateRenderer** is called ONLY by NotificationService.deliver()
- **ChannelRouter** is called ONLY by NotificationService.deliver()

---

## 4. Delivery Guarantees

### Scenario matrix

| Scenario | Step 1: createPending() | COMMIT | Step 2: deliver() | markDelivered() | Outcome |
|----------|------------------------|--------|-------------------|-----------------|---------|
| 1 | ✅ | ✅ | ✅ SSE + Email | ✅ | Full delivery |
| 2 | ✅ | ✅ | ✅ SSE, ❌ Email | ✅ (sent_at set) | Notification in DB + SSE; email logged as FAILED |
| 3 | ✅ | ✅ | ❌ Crash before deliver() | ❌ | Notification in DB, `sent_at = NULL`. User sees on poll. Never lost. |
| 4 | ✅ | ❌ Rollback | N/A | N/A | Notification rolls back. No inconsistent state. |
| 5 | ❌ createPending fails | N/A | N/A | N/A | Transaction rolls back. Workflow NOT affected? |
| 6 | ✅ | ✅ | ✅ deliver success | ❌ markDelivered fails | SSE sent, channels dispatched. `sent_at` stays NULL. Next delivery retry re-broadcasts SSE (harmless). |

### Wait — Scenario 5 is critical

**If `createPending()` fails inside the transaction (e.g., FK violation, RLS block), the entire workflow transaction rolls back.**

This is the tradeoff of the approved design. Mitigations:
- `createPending()` only touches `communication.notifications` (single INSERT, no complex logic)
- RLS policies allow authenticated users to INSERT (Section 6.3)
- FK constraint on `user_id` references `security.users` — should always be valid
- If `createPending()` throws, the `withTransaction()` callback throws, and the transaction rolls back. The client receives a 500 error.

**Acceptable risk**: The INSERT is a simple single-row operation with well-defined constraints. Failures would indicate a systemic bug (corrupt data, missing FK) that would affect other parts of the system anyway.

### Strategy summary

| Aspect | Strategy |
|--------|----------|
| **Notification persistence** | Exactly-once (atomic with workflow transaction) |
| **SSE delivery** | Best-effort, at-most-once (broadcast once after commit) |
| **Email/SMS/Push delivery** | At-least-once with retry (from `deliver()` method) |
| **Crash before deliver()** | Notification in DB (`sent_at = NULL`), visible via polling |
| **Duplicate deliver() call** | Check `sent_at` — if already set, skip (idempotent wrapper) |

---

## 5. Idempotency Strategy

### Scope

Full dedup across all notification types is not required. The workflow state machine already prevents duplicate transitions. Certificates use advisory locks.

**Minimal dedup for high-risk events only:**

| Event | Risk of duplicate | Dedup strategy |
|-------|------------------|----------------|
| `CERTIFICATE_ISSUED` | Medium — certificate generation retries | DB unique index + service-level check |
| `CERTIFICATE_REVOKED` | Low — admin action, manual | None (manual actions are single-shot) |
| `CERTIFICATE_GENERATION_FAILED` | Medium — retry could re-fire | DB unique index + service-level check |
| `CONDITION_ADDED` | Low — admin creates once | None |
| `CONDITION_REMINDER` | **High** — scheduled job could overlap | Service-level time-window check (7-day window) |
| All workflow transitions | Low — state machine prevents duplicates | None (workflow-level dedup) |

### Strategy A: DB unique index (for certificate events)

```sql
CREATE UNIQUE INDEX uq_cert_notif_dedup
  ON communication.notifications (notification_type, user_id, source_entity_id)
  WHERE source_entity_type = 'Certificate';
```

This guarantees: only one notification per (event type, user, certificate) combination. Attempting to insert a duplicate raises a unique violation — which `createPending()` catches and converts to a no-op (not a throw).

### Strategy B: Service-level time-window check (for condition reminders)

```typescript
// In NotificationService.createPending() or a before-create wrapper
async function checkDedup(
  notificationType: string,
  userId: number,
  sourceEntityType: string,
  sourceEntityId: number,
  windowHours: number = 168 // 7 days for condition reminders
): Promise<boolean> {
  const result = await this.repo.query(
    `SELECT 1 FROM communication.notifications
     WHERE notification_type = $1
       AND user_id = $2
       AND source_entity_type = $3
       AND source_entity_id = $4
       AND created_at > NOW() - make_interval(hours => $5)
     LIMIT 1`,
    [notificationType, userId, sourceEntityType, sourceEntityId, windowHours]
  );
  return result.rows.length > 0;
}
```

### Behavior when duplicate detected

```typescript
// In NotificationService.createPending():
async createPending(data, client): Promise<number | null> {
  // High-risk dedup check (before INSERT)
  if (this.isHighRiskEvent(data.notificationType)) {
    const isDuplicate = await this.checkDedup(
      data.notificationType, data.userId,
      data.sourceEntityType, data.sourceEntityId,
      this.getDedupWindow(data.notificationType) // hours
    );
    if (isDuplicate) {
      logger.debug({ data }, 'Duplicate suppressed');
      return null; // No notification created, no error thrown
    }
  }

  // INSERT (inside transaction)
  const result = await client.query(
    `INSERT INTO communication.notifications (...)
     VALUES ($1, $2, $3, $4, $5, $6) RETURNING id`,
    [...]
  );
  return result.rows[0].id;
}
```

The caller (domain service) receives `null` instead of an ID:

```typescript
const notificationId = await this.notificationService.createPending(data, client);
if (notificationId !== null) {
  // Only deliver if a notification was actually created
  this.notificationService.deliver(notificationId).catch(logger.error);
}
```

### Dedup configuration

```typescript
// In notification-types.ts
const DEDUP_CONFIG: Record<string, { enabled: boolean; windowHours: number; dbIndex: boolean }> = {
  CERTIFICATE_ISSUED:              { enabled: true, windowHours: 0,    dbIndex: true },
  CERTIFICATE_GENERATION_FAILED:   { enabled: true, windowHours: 0,    dbIndex: true },
  CONDITION_REMINDER:              { enabled: true, windowHours: 168,  dbIndex: false },
  // All others: { enabled: false }
};
```

- `windowHours = 0` with `dbIndex = true`: uses DB unique index (enforced globally, no time window)
- `windowHours > 0` with `dbIndex = false`: uses service-level time-windowed check
- `enabled: false`: no dedup check (for workflow transitions and low-risk events)

---

## 6. Notification Storage Schema

### 6.1 Table Alterations

#### `communication.notifications`

```sql
-- Add source entity columns (nullable — only workflow transitions and conditions populate these)
ALTER TABLE communication.notifications
  ADD COLUMN source_entity_type VARCHAR(50),
  ADD COLUMN source_entity_id   BIGINT;
```

The `sent_at` column already exists (nullable). Not used for pending/delivered distinction — see below.

### 6.2 New Tables

#### `communication.user_notification_preferences`

```sql
CREATE TABLE IF NOT EXISTS communication.user_notification_preferences (
    id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id           BIGINT NOT NULL REFERENCES security.users(id) ON DELETE CASCADE,
    notification_type VARCHAR(100) NOT NULL,
    channel           VARCHAR(50) NOT NULL CHECK (channel IN ('IN_APP', 'EMAIL', 'SMS', 'PUSH')),
    is_enabled        BOOLEAN NOT NULL DEFAULT TRUE,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ,
    CONSTRAINT uq_user_notif_pref UNIQUE (user_id, notification_type, channel)
);
```

RLS policies (same as v1):
```sql
ALTER TABLE communication.user_notification_preferences ENABLE ROW LEVEL SECURITY;

CREATE POLICY pref_select ON communication.user_notification_preferences FOR SELECT
  USING (user_id = communication.fn_current_user_id() OR system.fn_is_admin(communication.fn_current_user_id()));

CREATE POLICY pref_insert ON communication.user_notification_preferences FOR INSERT
  WITH CHECK (user_id = communication.fn_current_user_id() OR system.fn_is_admin(communication.fn_current_user_id()));

CREATE POLICY pref_update ON communication.user_notification_preferences FOR UPDATE
  USING (user_id = communication.fn_current_user_id() OR system.fn_is_admin(communication.fn_current_user_id()))
  WITH CHECK (user_id = communication.fn_current_user_id() OR system.fn_is_admin(communication.fn_current_user_id()));

CREATE POLICY pref_delete ON communication.user_notification_preferences FOR DELETE
  USING (system.fn_is_admin(communication.fn_current_user_id()));
```

### 6.3 Indexes

```sql
-- Feed queries (user's notification list)
CREATE INDEX IF NOT EXISTS idx_notifications_user_created
  ON communication.notifications (user_id, created_at DESC)
  WHERE deleted_at IS NULL;

-- Source entity lookups (admin queries, batch operations)
CREATE INDEX IF NOT EXISTS idx_notifications_source
  ON communication.notifications (source_entity_type, source_entity_id);

-- Dedup: certificate events (one notification per type + user + certificate)
CREATE UNIQUE INDEX IF NOT EXISTS uq_cert_notif_dedup
  ON communication.notifications (notification_type, user_id, source_entity_id)
  WHERE source_entity_type = 'Certificate';
```

### 6.4 RLS Policy Change — `notification_logs`

**Current policy**: INSERT requires `fn_is_admin()` — blocks non-admin delivery logging.

**Fix**:
```sql
DROP POLICY IF EXISTS notification_logs_insert ON communication.notification_logs;
CREATE POLICY notification_logs_insert ON communication.notification_logs FOR INSERT
  WITH CHECK (communication.fn_current_user_id() > 0);
```

SELECT policy remains admin-only.

### 6.5 Retention Strategy

| Scope | Action | Schedule |
|-------|--------|----------|
| Soft-deleted notifications | Hard delete | After 90 days |
| `notification_logs` > 365 days | Archive + hard delete | Monthly job |
| `user_notification_preferences` | Never delete | Permanent |

---

## 7. Channel Strategy

### Channel inventory

| Channel | Code | Status in Phase 4 | Sync/Async | Infrastructure needed | Retry | Failure handling |
|---------|------|-------------------|-----------|----------------------|-------|-----------------|
| In-App (SSE) | IN_APP | Implemented — improvements only | Async (in-memory broadcast) | None (existing SSE endpoint) | 0 — client reconnects | Remove stale client; notification persists in DB |
| Email | EMAIL | Scaffold only — no SMTP config | Async (in-process retry queue) | SMTP server or SendGrid API key | 3 attempts (5min/15min/1hr) | Log to `notification_logs` as FAILED |
| SMS | SMS | Scaffold only — no provider | Async (in-process retry queue) | SMS gateway (Twilio, etc.) | 2 attempts (5min/15min) | Log as FAILED |
| Push | PUSH | Scaffold only — no provider | Async (in-process retry queue) | FCM/APNs config | 2 attempts (1min/5min) | Log as FAILED |
| Webhook | WEBHOOK | Not implemented in Phase 4 | N/A | N/A | N/A | N/A |

### Delivery state machine (per-channel, in `notification_logs`)

```
SENT → DELIVERED
SENT → RETRYING → DELIVERED
SENT → RETRYING → FAILED
```

### `delivery_status` values

| Status | Meaning |
|--------|---------|
| `SENT` | Initial state — notification row created |
| `DELIVERED` | Successfully delivered to channel |
| `RETRYING` | Attempt failed, queued for retry |
| `FAILED` | All retries exhausted |

Note: The `notifications.sent_at` column is NOT used as a delivery status indicator. It is set only after `deliver()` succeeds (at least one channel confirmed). A NULL `sent_at` does not mean "undelivered" — it may mean delivery hasn't been attempted yet, or a crash occurred before `markDelivered()`.

---

## 8. Performance Impact

### Cost per notification trigger

| Operation | Count | Type | Estimated cost |
|-----------|-------|------|---------------|
| INSERT notification (inside txn) | 1 | DB write | <3ms (single row, no triggers) |
| Dedup check (high-risk events only) | 0–1 | DB read | <2ms (indexed) |
| SSE broadcast per connected client | 1 per client | In-memory write() | <1ms per client |
| ChannelRouter dispatch | 1–4 | In-process + DB writes | <10ms total |

### Worst-case scenario

**Bulk approval of 10 applications** (simultaneous COMMITTEE_APPROVE):

```
Phase 2 added inside transaction:
  +10 notification INSERTs (negligible extension of txn duration)

Phase 2 added after commit:
  +10 SSE broadcasts (one per applicant)

Total extra: <50ms
```

**Worst-case storm**: COMMITTEE_CONDITIONAL with 1 applicant + 15 committee + 5 admins = 21 notifications:
- Inside txn: 21-row INSERT via unnest — single DB round-trip, <5ms
- After commit: 21 SSE broadcasts — <21ms

### No caching needed

Phase 4 adds <50ms overhead per transition. No background job queue needed for Phase 4 volumes.

---

## 9. Rollback Strategy

### 9.1 Feature Flag

```typescript
NOTIFICATIONS_ENABLED: z.coerce.boolean().default(true),
```

```typescript
async createPending(data, client): Promise<number | null> {
  if (!env.NOTIFICATIONS_ENABLED) return null;
  // ... rest
}
```

When disabled: `createPending` returns `null` (no notification created), `deliver()` is never called.

### 9.2 Per-priority disable flags

```typescript
WORKFLOW_NOTIFICATIONS_ENABLED: z.coerce.boolean().default(true),
CONDITIONS_NOTIFICATIONS_ENABLED: z.coerce.boolean().default(true),
CERTIFICATE_NOTIFICATIONS_ENABLED: z.coerce.boolean().default(true),
```

### 9.3 Migration Rollback

```sql
-- Rollback: Drop new columns
ALTER TABLE communication.notifications
  DROP COLUMN IF EXISTS source_entity_type,
  DROP COLUMN IF EXISTS source_entity_id;

-- Rollback: Drop indexes
DROP INDEX IF EXISTS idx_notifications_user_created;
DROP INDEX IF EXISTS idx_notifications_source;
DROP INDEX IF EXISTS uq_cert_notif_dedup;

-- Rollback: Restore notification_logs INSERT policy
DROP POLICY IF EXISTS notification_logs_insert ON communication.notification_logs;
CREATE POLICY notification_logs_insert ON communication.notification_logs FOR INSERT
  WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));

-- Rollback: Drop preferences table
DROP TABLE IF EXISTS communication.user_notification_preferences CASCADE;
```

### 9.4 Graceful Degradation

| Failure | Effect | Recovery |
|---------|--------|----------|
| `createPending()` throws inside txn | Transaction rolls back. Workflow NOT committed. System error. | Fix bug. No inconsistent state. |
| `deliver()` crashes mid-way | SSE not sent, channels not dispatched. Notification in DB. | User sees on poll. Restart retries (if Phase 5 background job). |
| SSE connection per notification | At most 1 attempt. Silently fails if client disconnected. | EventSource auto-reconnect on client. |
| Email service down | Logged as FAILED, retries exhausted. | Manual retry from admin panel. |

---

## 10. Implementation Order

### Priority 1 — Workflow Transition Notifications (12 commits)

| # | Type | Description | Files | Test verification |
|---|------|-------------|-------|-----------------|
| 1 | **Schema** | Add `source_entity_type`, `source_entity_id` to `communication.notifications`. Add indexes: `idx_notifications_user_created` (filtered `WHERE deleted_at IS NULL`), `idx_notifications_source`, `uq_cert_notif_dedup` (partial unique for Certificate type). Seed: `backend/seed/48-notification-source-columns.sql`. | 1 new SQL | Run seed, verify via `\d communication.notifications` |
| 2 | **Schema** | Create `communication.user_notification_preferences` table with RLS. No seed data. Seed: `backend/seed/49-notification-preferences.sql`. | 1 new SQL | Run seed, verify table + RLS via `\dp` |
| 3 | **Schema** | Fix `notification_logs` INSERT policy: `fn_is_admin()` → `fn_current_user_id() > 0`. Seed: `backend/seed/50-notification-logs-rls-fix.sql`. | 1 new SQL | INSERT as non-admin user succeeds |
| 4 | **Repository** | Create `NotificationRepository` in `backend/src/repositories/notification.repository.ts`. Methods: `createPending(client, data)` — INSERT inside txn, returns id. `findById(id)`, `findByUser(userId)`, `markRead()`, `markAllRead()`, `softDelete()`, `getUnreadCount()`, `markDelivered(id)` — UPDATE sent_at, `logDelivery()`, `getUserPreferences()`, `upsertPreference()`, `getTemplate()`, `checkDedup(type, userId, sourceType, sourceId, windowHours)` — service-level dedup query. | 1 new TS | `npm test` |
| 5 | **Service** | Split `notification.service.ts` into `NotificationService` class. Two core methods: `createPending(data, client)` → INSERT inside txn, returns id or null. `deliver(notificationId)` → SSE broadcast + ChannelRouter dispatch + `markDelivered()`. Add helper `createAndDeliver(data)` for non-txn contexts (calls createPending via pool query, then deliver). Export backward-compatible wrappers. | 1 new TS, 1 refactored TS | `npm test` |
| 6 | **Constants** | Create `backend/src/services/notification-types.ts`. Export: `TRANSITION_NOTIFICATION_MAP` (event_code → type config), `DEDUP_CONFIG` (per-type dedup settings), `DEFAULT_CHANNELS`, `getRecipients(eventCode, app)` returning userIds for batch dispatch. | 1 new TS | `npm test` |
| 7 | **Trigger: App in-status** | Wire `createPending(client)` into `application.service.ts:updateStatus()` inside `withTransaction()`. Wire `deliver()` after commit. Handle: ACCEPT_INITIAL, COMMITTEE_APPROVE, COMMITTEE_REJECT, COMMITTEE_CONDITIONAL, COMMITTEE_RETURN, REJECT_* → notify applicant. | 1 modified TS | Integration: notification row exists after each transition |
| 8 | **Trigger: Batch** | Wire batch admin/committee notifications. `notifyAdminsAndChair(appId, eventCode)`: query committee chair from `committee_members`, ETHICS_ADMIN + SUPER_ADMIN from `user_roles`. Use `createPendingBatch(client, items)` with unnest. Wire into: SUBMIT (notify admins + chair), WITHDRAW (notify admins + chair), APPEAL (notify admins + chair), SEND_TO_COMMITTEE (notify committee members). | 1 modified TS | Integration: multiple notification rows per transition |
| 9 | **Trigger: Withdraw/Appeal** | Wire `createPending(client)` + `deliver()` into `withdrawApplication()` and `appealDecision()`. | 1 modified TS | Integration test |
| 10 | **Trigger: SUBMIT applicant** | Wire applicant notification for SUBMIT transition (applicant notified of submission). | 1 modified TS | Integration test |
| 11 | **Frontend: SSE reliability** | Improve `useNotificationStream.ts`: exponential backoff reconnect (1s → 2s → 4s → 8s → max 30s). 60s timeout detection. `last-event-id` header support. | 1 modified TSX | Manual: dev server, verify reconnect |
| 12 | **Frontend: Unread count** | Add `GET /api/v1/communication/notifications/unread-count` to communication module. Wire to `NotificationRepository.getUnreadCount()`. | 1 modified TS + route addition | API test |

### Priority 1 total scope

| Metric | Count |
|--------|-------|
| New SQL seed files | 3 |
| New TypeScript files | 3 (repository, service, constants) |
| Modified TypeScript files | 5 (application.service, notification.service, communication module + route, useNotificationStream) |
| New routes | 1 (unread-count) |
| Modified API | 1 (existing notification routes unchanged) |

### Priority 2+ (outline)

| Batch | Scope | Commits |
|-------|-------|---------|
| P2 | Conditions notifications: wire into `condition.service.ts` | 2 |
| P3 | Certificate notifications: wire into `certificate.service.ts` | 2 |
| P4 | SSE: backend connection dedup, heartbeat improvements | 2 |
| P5 | Preferences: CRUD routes + frontend UI + template rendering | 5 |

---

## Appendix A — RLS concerns

### `notification_logs` INSERT policy

**Issue**: INSERT currently requires `fn_is_admin()`. Blocks non-admin delivery logging.

**Fix**: Commit #3 — change to `fn_current_user_id() > 0`.

### SSE in-memory volatility

The `Map<number, SSEClient[]>` is volatile. On server restart, all SSE connections drop (reconnect via EventSource). Acceptable for Phase 4. Future: Redis pub/sub.

---

## Appendix B — Default Preference Seed

```sql
INSERT INTO communication.user_notification_preferences (user_id, notification_type, channel, is_enabled)
SELECT u.id, ntype.notification_type, ch.channel,
  CASE
    WHEN ch.channel = 'IN_APP' THEN TRUE
    WHEN ch.channel = 'EMAIL' AND ntype.notification_type IN (
      'APPLICATION_SUBMITTED', 'APPLICATION_APPROVED', 'APPLICATION_REJECTED',
      'CERTIFICATE_ISSUED', 'CERTIFICATE_REVOKED',
      'CONDITIONS_REQUIRED', 'EVIDENCE_REJECTED', 'REVIEW_ASSIGNED'
    ) THEN TRUE
    WHEN ch.channel = 'SMS' AND ntype.notification_type IN (
      'APPLICATION_APPROVED', 'APPLICATION_REJECTED'
    ) THEN TRUE
    ELSE FALSE
  END
FROM security.users u
CROSS JOIN ( VALUES ... ) AS ntype(notification_type)
CROSS JOIN ( VALUES ('IN_APP'), ('EMAIL'), ('SMS'), ('PUSH') ) AS ch(channel)
WHERE u.status = 'ACTIVE'
ON CONFLICT (user_id, notification_type, channel) DO NOTHING;
```

---

## Appendix C — Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| `createPending()` inside txn — if it fails, workflow transaction rolls back | **Low** — simple single-row INSERT with validated inputs | High (workflow fails) | INSERT is minimal; all inputs validated before txn; FK constraints on trusted data; if this fails, there's a systemic bug |
| Crash between COMMIT and `deliver()` — SSE never sent | Medium | Low (notification in DB) | User sees on next poll. Phase 5: background job retries `sent_at IS NULL` |
| Duplicate `deliver()` call | Low | Low (re-broadcast) | `send_at` check prevents duplicate markDelivered; SSE re-broadcast harmless |
| `notification_logs` INSERT fails due to RLS | **High** | Medium (logs lost) | Fix in commit #3 |
| Email/SMS/Push infra not ready | Medium | Low | Phase 4 ships IN_APP only; other channels scaffolded but disabled |
