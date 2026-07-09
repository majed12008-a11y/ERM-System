# Workflow Implementation Contract — ERM System

> **Version**: 1.1
> **Status**: Approved (Pre-Implementation)
> **Authoritative**: Yes — no implementation may contradict this document.
> **Change Process**: Any change requires documented justification and re-approval.

---

## 1. Scope

This contract defines the complete workflow architecture for research application lifecycle management in the ERM System. It governs all state transitions, permissions, notifications, audit events, and business rules.

---

## 2. Workflow States (15 States)

| # | State Code | State Name (Ar) | State Name (En) | Is Initial | Is Terminal | Editable | Purpose |
|---|------------|-----------------|-----------------|------------|-------------|----------|---------|
| 1 | `DRAFT` | مسودة | Draft | **Yes** | No | Yes | Initial creation; researcher prepares application before submission |
| 2 | `SUBMITTED` | مقدم | Submitted | No | No | No | Awaiting administrative triage |
| 3 | `INITIAL_REVIEW` | مراجعة أولية | Initial Review | No | No | No | Administrative completeness check |
| 4 | `SCIENTIFIC_REVIEW` | مراجعة علمية | Scientific Review | No | No | No | Scientific/technical methodology review |
| 5 | `ETHICAL_REVIEW` | مراجعة أخلاقية | Ethical Review | No | No | No | Ethics and consent review |
| 6 | `COMMITTEE_REVIEW` | مراجعة اللجنة | Committee Review | No | No | No | Full committee deliberation and voting |
| 7 | `RETURNED` | معاد للمراجعة | Returned for Revision | No | No | **Yes** | Returned to researcher for scientific/ethics revisions |
| 8 | `AWAITING_CONDITIONS` | بانتظار الشروط | Awaiting Conditions | No | No | Evidence only | Conditional approval; researcher must provide evidence for specified conditions |
| 9 | `EVIDENCE_REJECTED` | الأدلة مرفوضة | Evidence Rejected | No | No | Evidence only | Evidence for conditions was rejected; researcher may resubmit improved evidence |
| 10 | `APPROVED` | موافق عليه | Approved | No | **Semi** | No | Final approval — research may proceed |
| 11 | `REJECTED` | مرفوض | Rejected | No | **Yes** | No | Application rejected |
| 12 | `WITHDRAWN` | مسحوب | Withdrawn | No | **Yes** | No | Voluntarily withdrawn by researcher or admin |
| 13 | `CLOSED` | مغلق | Closed | No | **Semi** | No | Study completed and closed — administrative lifecycle stage, not an active review state |
| 14 | `ARCHIVED` | مؤرشف | Archived | No | **Yes** | No | Final archival after retention period |
| 15 | `SUSPENDED` | معلق | Suspended | No | No | No | *(Future)* Research temporarily halted |

### State Diagram (Simplified)

```
DRAFT → SUBMITTED → INITIAL_REVIEW → SCIENTIFIC_REVIEW → ETHICAL_REVIEW → COMMITTEE_REVIEW
  ↑          ↑              ↑                  ↑                ↑                  ↓
  |          |              |                  |                +-------←---------+---→ APPROVED → CLOSED → ARCHIVED
  |          |              |                  +-------←-------+                       ↓
  |          |              +-------←--------+                                 ---→ REJECTED
  |          +-------←-----+                                              |   |
  +-----←----+                                                           +---→ RETURNED → DRAFT
                                                                                  ↓
                                                                         AWAITING_CONDITIONS ──→ APPROVED
                                                                                  ↓
                                                                         EVIDENCE_REJECTED ──→ AWAITING_CONDITIONS
                                                                                  │
                                                                                  ├──→ REJECTED
                                                                                  └──→ WITHDRAWN
```

### Semi-Terminal States

`APPROVED` and `CLOSED` are semi-terminal:
- `APPROVED` → can transition to `CLOSED` (standard closure) or `SUSPENDED` (future)
- `CLOSED` → can transition to `ARCHIVED`

---

## 3. Transition Codes (32 Transitions)

### 3.1 Forward Transitions

| Code | From | To | Actor | Requires Comment | Requires Vote | Description |
|------|------|----|-------|:----------------:|:-------------:|-------------|
| `SUBMIT` | DRAFT | SUBMITTED | Researcher | No | No | Submit draft for review |
| `ACCEPT_INITIAL` | SUBMITTED | INITIAL_REVIEW | Admin/Chair | No | No | Accept for initial review |
| `SEND_TO_SCIENTIFIC` | INITIAL_REVIEW | SCIENTIFIC_REVIEW | Admin/Chair | No | No | Forward to scientific review |
| `SEND_TO_ETHICAL` | SCIENTIFIC_REVIEW | ETHICAL_REVIEW | Admin/Chair | No | No | Forward to ethics review |
| `SEND_TO_COMMITTEE` | ETHICAL_REVIEW | COMMITTEE_REVIEW | Admin/Chair | No | No | Forward to committee review |
| `COMMITTEE_APPROVE` | COMMITTEE_REVIEW | APPROVED | Chair/Admin | No | Yes | Committee approves application |
| `COMMITTEE_CONDITIONAL` | COMMITTEE_REVIEW | AWAITING_CONDITIONS | Chair/Admin | Yes | Yes | Conditional approval with conditions |
| `RESUBMIT` | RETURNED | SUBMITTED | Researcher | No | No | Resubmit revised application |
| `CONDITIONS_MET` | AWAITING_CONDITIONS | APPROVED | Admin/Chair | No | No | All conditions satisfied |
| `CLOSE` | APPROVED | CLOSED | Admin | Yes | No | Close completed study |
| `ARCHIVE` | CLOSED | ARCHIVED | Super Admin | No | No | Archive after retention |

### 3.2 Return Transitions

| Code | From | To | Actor | Requires Comment | Requires Vote | Description |
|------|------|----|-------|:----------------:|:-------------:|-------------|
| `RETURN_SUBMITTED` | SUBMITTED | DRAFT | Admin/Chair | Yes | No | Return to draft with comments |
| `RETURN_FROM_INITIAL` | INITIAL_REVIEW | SUBMITTED | Admin/Chair | Yes | No | Return to submitted with comments |
| `RETURN_FROM_SCIENTIFIC` | SCIENTIFIC_REVIEW | SUBMITTED | Admin/Chair | Yes | No | Return to submitted with comments |
| `RETURN_FROM_ETHICAL` | ETHICAL_REVIEW | INITIAL_REVIEW | Admin/Chair | Yes | No | Return to initial review with comments |
| `COMMITTEE_RETURN` | COMMITTEE_REVIEW | RETURNED | Chair/Admin | Yes | Yes | Return to researcher with revision requests |
| `CONDITIONS_NOT_MET` | AWAITING_CONDITIONS | EVIDENCE_REJECTED | Admin/Chair | Yes | No | Evidence for conditions not satisfied; move to conditions-evidence correction loop |

### 3.3 Rejection Transitions

| Code | From | To | Actor | Requires Comment | Description |
|------|------|----|-------|:----------------:|-------------|
| `REJECT_SUBMITTED` | SUBMITTED | REJECTED | Admin/Chair | Yes | Reject at submission stage |
| `REJECT_FROM_INITIAL` | INITIAL_REVIEW | REJECTED | Admin/Chair | Yes | Reject during initial review |
| `REJECT_FROM_SCIENTIFIC` | SCIENTIFIC_REVIEW | REJECTED | Admin/Chair | Yes | Reject during scientific review |
| `REJECT_FROM_ETHICAL` | ETHICAL_REVIEW | REJECTED | Admin/Chair | Yes | Reject during ethics review |
| `COMMITTEE_REJECT` | COMMITTEE_REVIEW | REJECTED | Chair/Admin | Yes | Yes | Committee rejects application |

### 3.4 Withdrawal Transitions

| Code | From | To | Actor | Requires Comment | Description |
|------|------|----|-------|:----------------:|-------------|
| `WITHDRAW` | DRAFT, SUBMITTED, INITIAL_REVIEW, SCIENTIFIC_REVIEW, ETHICAL_REVIEW, RETURNED, AWAITING_CONDITIONS, EVIDENCE_REJECTED | WITHDRAWN | Researcher or Admin | Yes | Withdraw application |

### 3.5 Conditions Evidence Transitions

| Code | From | To | Actor | Requires Comment | Requires Vote | Description |
|------|------|----|-------|:----------------:|:-------------:|-------------|
| `SUBMIT_EVIDENCE` | EVIDENCE_REJECTED | AWAITING_CONDITIONS | Researcher | No | No | Researcher resubmits improved evidence for conditions |
| `REJECT_CONDITIONS` | EVIDENCE_REJECTED | REJECTED | Admin/Chair | Yes | No | Admin closes the application as rejected for failing to satisfy conditions |

---

## 4. Permissions Matrix

| Role | Transitions Allowed |
|------|--------------------|
| `RESEARCHER` | `SUBMIT`, `RESUBMIT`, `SUBMIT_EVIDENCE`, `WITHDRAW` (own applications only) |
| `ETHICS_ADMIN` | `ACCEPT_INITIAL`, `SEND_TO_*`, `RETURN_*`, `REJECT_*`, `COMMITTEE_*`, `CONDITIONS_MET`, `CONDITIONS_NOT_MET`, `SUBMIT_EVIDENCE`, `REJECT_CONDITIONS`, `CLOSE`, `WITHDRAW` |
| `COMMITTEE_CHAIR` | Same as ETHICS_ADMIN |
| `COMMITTEE_MEMBER` | `WITHDRAW` (admin-initiated) |
| `SCIENTIFIC_REVIEWER` | None (reviews are independent of workflow) |
| `ETHICS_REVIEWER` | None (reviews are independent of workflow) |
| `SUPER_ADMIN` | All transitions |
| `INST_COORDINATOR` | Read-only for institutional applications |

### Role-Transition Mapping

```
SUBMIT                    → RESEARCHER (owner)
ACCEPT_INITIAL            → ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN
RETURN_SUBMITTED          → ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN
REJECT_SUBMITTED          → ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN
SEND_TO_SCIENTIFIC        → ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN
RETURN_FROM_INITIAL       → ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN
REJECT_FROM_INITIAL       → ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN
SEND_TO_ETHICAL           → ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN
RETURN_FROM_SCIENTIFIC    → ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN
REJECT_FROM_SCIENTIFIC    → ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN
SEND_TO_COMMITTEE         → ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN
RETURN_FROM_ETHICAL       → ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN
REJECT_FROM_ETHICAL       → ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN
COMMITTEE_APPROVE         → COMMITTEE_CHAIR, ETHICS_ADMIN, SUPER_ADMIN
COMMITTEE_REJECT          → COMMITTEE_CHAIR, ETHICS_ADMIN, SUPER_ADMIN
COMMITTEE_RETURN          → COMMITTEE_CHAIR, ETHICS_ADMIN, SUPER_ADMIN
COMMITTEE_CONDITIONAL     → COMMITTEE_CHAIR, ETHICS_ADMIN, SUPER_ADMIN
RESUBMIT                  → RESEARCHER (owner)
CONDITIONS_MET            → ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN
CONDITIONS_NOT_MET        → ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN
SUBMIT_EVIDENCE           → RESEARCHER (owner)
REJECT_CONDITIONS         → ETHICS_ADMIN, COMMITTEE_CHAIR, SUPER_ADMIN
WITHDRAW                  → RESEARCHER (owner), ETHICS_ADMIN, SUPER_ADMIN
CLOSE                     → ETHICS_ADMIN, SUPER_ADMIN
ARCHIVE                   → SUPER_ADMIN
```

---

## 5. Workflow Engine — Single Source of Truth

### 5.1 Cardinal Rule

> **The Workflow Engine is the SINGLE SOURCE OF TRUTH for the application lifecycle.**
>
> - No service may directly update `core.applications.current_status`.
> - No repository may change workflow status independently.
> - No SQL UPDATE may bypass the workflow engine.
> - All state changes must occur exclusively through `executeTransition()` in `WorkflowService`.

### 5.2 Allowed Application Status Writers

Only the following may write to `core.applications.current_status`:

1. **`WorkflowService.executeTransition()`** — via `ApplicationRepository.updateStatus()` called AFTER the workflow transition succeeds.
2. **`ApplicationRepository.create()`** — sets initial status to `DRAFT` (default value).

### 5.3 Banned Patterns

The following patterns are **FORBIDDEN**:

| Pattern | Location (Current) | Replacement |
|---------|-------------------|-------------|
| `repo.updateStatus(id, 'SUBMITTED')` direct call | `application.service.ts:127` | `executeTransition('SUBMIT')` |
| `repo.updateStatus(id, decision)` direct call | `application.service.ts:215` | `executeTransition(decision-to-transition-code-map)` |
| `repo.setApplicationUnderReview(id)` | `application.repository.ts:171` | **REMOVED** |
| `fn_auto_transition()` SQL function | `ethics_db_tables_constraints.sql:258` | **REMOVED** |
| `repo.updateStatus(id, body.status!)` without transition | `application.service.ts:172` | **REMOVED** — transition_code required |

---

## 6. Decision Types

| Decision Code | Maps To Transition | Results In State | Description |
|---------------|-------------------|-----------------|-------------|
| `APPROVED` | `COMMITTEE_APPROVE` | APPROVED | Full approval |
| `REJECTED` | `COMMITTEE_REJECT` | REJECTED | Rejection |
| `CONDITIONAL` | `COMMITTEE_CONDITIONAL` | AWAITING_CONDITIONS | Approval subject to conditions |
| `RETURN` | `COMMITTEE_RETURN` | RETURNED | Return for revision |
| `DEFERRED` | *(Future)* | *(Future)* | Decision deferred |
| `MODIFICATIONS_REQUIRED` | *(Future)* | *(Future)* | Modifications needed before decision |

---

## 7. Status Codes Reference

### 7.1 Application Statuses (`core.applications.current_status`)

```
DRAFT, SUBMITTED, INITIAL_REVIEW, SCIENTIFIC_REVIEW, ETHICAL_REVIEW,
COMMITTEE_REVIEW, RETURNED, AWAITING_CONDITIONS, EVIDENCE_REJECTED,
APPROVED, REJECTED, WITHDRAWN, CLOSED, ARCHIVED
```

### 7.2 Workflow Instance Statuses (`workflow.workflow_instances.status_code`)

```
ACTIVE      — Workflow instance is in progress
COMPLETED   — Terminal state reached (APPROVED, REJECTED, WITHDRAWN, ARCHIVED)
SUSPENDED   — Temporarily halted (future)
```

### 7.3 Condition Statuses (`committee.application_conditions.status`)

```
PENDING     — Condition created, awaiting evidence
EVIDENCE_SUBMITTED — Evidence uploaded, awaiting verification
MET         — Condition satisfied by evidence
NOT_MET     — Condition not satisfied
WAIVED      — Condition waived by committee
```

### 7.4 Review Assignment Statuses

```
ASSIGNED     — Reviewer assigned, not started
IN_PROGRESS  — Reviewer is working
COMPLETED    — Review submitted
OVERDUE      — Past deadline
```

---

## 8. Notification Events

| Event Code | Trigger Transition | Recipient | Priority |
|------------|-------------------|-----------|----------|
| `APPLICATION_SUBMITTED` | `SUBMIT` | ETHICS_ADMIN(s) | NORMAL |
| `INITIAL_REVIEW_STARTED` | `ACCEPT_INITIAL` | Researcher | NORMAL |
| `SCIENTIFIC_REVIEW_STARTED` | `SEND_TO_SCIENTIFIC` | Researcher | NORMAL |
| `ETHICAL_REVIEW_STARTED` | `SEND_TO_ETHICAL` | Researcher | NORMAL |
| `COMMITTEE_REVIEW_STARTED` | `SEND_TO_COMMITTEE` | Researcher | HIGH |
| `APPLICATION_RETURNED` | Any `RETURN_*` or `COMMITTEE_RETURN` | Researcher | HIGH |
| `APPLICATION_REJECTED` | Any `REJECT_*` or `COMMITTEE_REJECT` | Researcher | HIGH |
| `APPLICATION_APPROVED` | `COMMITTEE_APPROVE` or `CONDITIONS_MET` | Researcher | HIGH |
| `CONDITIONS_SET` | `COMMITTEE_CONDITIONAL` | Researcher | HIGH |
| `EVIDENCE_SUBMITTED` | (evidence upload action) | ETHICS_ADMIN(s) | NORMAL |
| `CONDITIONS_MET` | `CONDITIONS_MET` | Researcher | HIGH |
| `CONDITIONS_NOT_MET` | `CONDITIONS_NOT_MET` | Researcher | HIGH |
| `EVIDENCE_RESUBMITTED` | `SUBMIT_EVIDENCE` | ETHICS_ADMIN(s) | NORMAL |
| `CONDITIONS_REJECTED` | `REJECT_CONDITIONS` | Researcher | HIGH |
| `APPLICATION_RESUBMITTED` | `RESUBMIT` | ETHICS_ADMIN(s) | NORMAL |
| `APPLICATION_WITHDRAWN` | `WITHDRAW` | Other party | NORMAL |
| `STUDY_CLOSED` | `CLOSE` | Researcher | NORMAL |
| `APPLICATION_ARCHIVED` | `ARCHIVE` | None | LOW |
| `CERTIFICATE_AVAILABLE` | (after `COMMITTEE_APPROVE`/`CONDITIONS_MET`) | Researcher | HIGH |
| `REVIEW_REQUEST` | (review assignment action) | Reviewer | NORMAL |
| `VOTE_CLOSED` | (voting session close) | Voters | HIGH |
| `MEETING_SCHEDULED` | (meeting creation) | Committee members | NORMAL |

---

## 9. Audit Events

Every workflow transition generates an audit event:

| Audit Event | Description | Data Captured |
|-------------|-------------|---------------|
| `WORKFLOW_TRANSITION_EXECUTED` | Transition executed | from_state, to_state, transition_code, actor_id, comment, timestamp |
| `WORKFLOW_INSTANCE_CREATED` | Workflow initialized | workflow_code, entity_type, entity_id, initial_state |
| `WORKFLOW_INSTANCE_COMPLETED` | Terminal state reached | instance_id, terminal_state |

### Audit Storage

- Primary: `workflow.workflow_history` table (per-transition)
- Secondary: `workflow.workflow_actions` table (per-action)
- Integration event: `integration.event_outbox` (for external systems)
- Audit meta columns: `created_by`, `created_at`, `updated_by`, `updated_at` on `core.applications`

---

## 10. Business Rules

### 10.1 Submission Rules
- **BR-SUB-01**: Only the application owner (`submitted_by`) may submit.
- **BR-SUB-02**: Submission requires `DRAFT` or `RETURNED` status.
- **BR-SUB-03**: On submit, the workflow instance must be initialized (if not already) and the `SUBMIT` transition executed.
- **BR-SUB-04**: On submit, `application_consent` must be confirmed (future: mandatory check).

### 10.2 Edit Rules
- **BR-EDIT-01**: Applications may be edited only in `DRAFT` or `RETURNED` state.
- **BR-EDIT-02**: Only the owner or admin may edit.
- **BR-EDIT-03**: Editing a RETURNED application resets `returned_at` tracking.

### 10.3 Review Rules
- **BR-REV-01**: All assigned reviews must be `COMPLETED` before the application can progress to the next stage.
- **BR-REV-02**: A review may be `APPROVE`, `REJECT`, `CONDITIONAL`, or `ABSTAIN`.
- **BR-REV-03**: Abstain votes do not count toward the decision tally.

### 10.4 Committee Decision Rules
- **BR-COM-01**: Committee decisions require `COMMITTEE_REVIEW` state.
- **BR-COM-02**: Committee decisions require a voting session with at least one `APPROVE` or `REJECT` vote (abstain-only sessions are invalid).
- **BR-COM-03**: The chair (or admin) enters the final decision via `executeTransition`, NOT directly.
- **BR-COM-04**: `COMMITTEE_CONDITIONAL` requires at least one condition to be specified.
- **BR-COM-05**: `COMMITTEE_RETURN` and `COMMITTEE_REJECT` require a comment explaining the reason.

### 10.5 Conditional Approval Rules
- **BR-CON-01**: Conditions are created automatically during `COMMITTEE_CONDITIONAL` transition.
- **BR-CON-02**: Each condition has a `due_date` (default: 90 days from creation).
- **BR-CON-03**: The researcher may upload evidence for each condition independently.
- **BR-CON-04**: The researcher must explicitly "submit for verification" after uploading evidence.
- **BR-CON-05**: An admin/chair verifies each condition as `MET`, `NOT_MET`, or `WAIVED`.
- **BR-CON-06**: When all conditions are `MET` or `WAIVED`, the application may transition to `APPROVED` via `CONDITIONS_MET`.
- **BR-CON-07**: If any condition is `NOT_MET` and cannot be waived, the application transitions to `EVIDENCE_REJECTED` via `CONDITIONS_NOT_MET` — a separate correction loop distinct from the scientific revision cycle (`RETURNED`).
- **BR-CON-08**: From `EVIDENCE_REJECTED`, the researcher may:
  1. Resubmit improved evidence via `SUBMIT_EVIDENCE` → `AWAITING_CONDITIONS`.
  2. Withdraw via `WITHDRAW` → `WITHDRAWN`.
- **BR-CON-09**: From `EVIDENCE_REJECTED`, the admin/chair may reject the application via `REJECT_CONDITIONS` → `REJECTED` if conditions cannot be satisfied.

### 10.6 Withdrawal Rules
- **BR-WIT-01**: Withdrawal is allowed from any non-terminal state except `COMMITTEE_REVIEW` (when committee is deliberating). Withdrawal is available from `EVIDENCE_REJECTED`.
- **BR-WIT-02**: Withdrawal requires a comment explaining the reason.
- **BR-WIT-03**: Withdrawn applications cannot be reinstated.

### 10.7 Closure Rules
- **BR-CLO-01**: Only `APPROVED` applications may be closed.
- **BR-CLO-02**: Closure requires a final report document.
- **BR-CLO-03**: Closure sets the study end date.

### 10.8 Archival Rules
- **BR-ARC-01**: Only `CLOSED` applications may be archived.
- **BR-ARC-02**: Archival is irreversible.

---

## 11. Researcher Responsibilities

1. Ensure application is complete before submission.
2. Respond to return comments by editing and resubmitting.
3. Upload evidence documents for each condition within the due date.
4. Submit evidence for verification when all conditions are addressed.
5. Conduct research only after receiving full approval (APPROVED state).
6. Notify the committee of any protocol amendments.
7. Submit annual progress reports (future).
8. Request study closure when research is complete.

---

## 12. Committee Responsibilities

1. Triage submitted applications promptly.
2. Assign qualified reviewers within the review timeline.
3. Conduct fair and thorough scientific and ethics reviews.
4. Schedule committee meetings with adequate notice.
5. Conduct voting sessions with proper quorum.
6. Enter clear, justified decisions through the workflow engine.
7. Set reasonable conditions with clear due dates.
8. Verify condition evidence promptly.
9. Generate and sign approval certificates.
10. Monitor approved studies for compliance.

---

## 13. Prohibited Code Patterns

The following patterns are **BANNED** throughout the codebase:

```typescript
// BANNED: Direct status update without workflow
await this.repo.updateStatus(id, 'SOME_STATUS');

// BANNED: Setting ghost/unofficial statuses
await this.query(`UPDATE core.applications SET current_status = 'UNDER_REVIEW' ...`);

// BANNED: Calling autoTransition (broken by design)
await this.workflow.autoTransition('Application', id, userId);

// BANNED: Bypassing executeTransition for committee decisions
// Do NOT create committeeDecision() — use executeTransition() with COMMITTEE_* codes

// BANNED: Checking only 'DRAFT' when 'RETURNED' should also be allowed
if (app.current_status !== 'DRAFT') { throw error } // Must also allow RETURNED
```

---

## 14. Migration & Backward Compatibility

### 14.1 Existing Data
- Existing applications in `DRAFT`, `SUBMITTED`, `INITIAL_REVIEW`, `SCIENTIFIC_REVIEW`, `ETHICAL_REVIEW`, `COMMITTEE_REVIEW`, `APPROVED`, `REJECTED` — continue to work.
- Existing applications with `current_status = 'RETURNED'` → now unblocked (edit + resubmit allowed).
- Existing applications with `current_status = 'CONDITIONAL'` → these are **orphaned** (no workflow state exists). Must be migrated to `AWAITING_CONDITIONS` state.
- Existing applications with `current_status = 'UNDER_REVIEW'` → should be mapped to the appropriate review state based on workflow position.

### 14.2 Migration Steps
1. Add new workflow states to `workflow.workflow_states` (seed SQL).
2. Add new transitions to `workflow.workflow_transitions` (seed SQL).
3. Update `core.applications` rows:
   - `current_status = 'CONDITIONAL'` → `'AWAITING_CONDITIONS'`
   - `current_status = 'UNDER_REVIEW'` → `'SUBMITTED'` (safe default, admin will re-evaluate)
4. Create workflow instances for any applications missing them.
5. Drop `fn_auto_transition()` function.
6. Remove `setApplicationUnderReview()` from all layers.

---

## 15. Contract Compliance

Every pull request related to workflow must be checked against this contract. Any deviation must be:
1. Documented with justification
2. Approved by the architectural reviewer
3. Reflected in an updated version of this contract

---

*End of Workflow Implementation Contract*
