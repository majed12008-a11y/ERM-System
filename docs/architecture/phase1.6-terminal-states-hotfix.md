# Phase 1.6 — TERMINAL_STATES Hotfix

**Discovered during Phase 2 architecture analysis**.

## Problem

`workflow.service.ts:79` hard-codes a `TERMINAL_STATES` array:

```typescript
const TERMINAL_STATES = ['APPROVED', 'REJECTED', 'WITHDRAWN', 'CLOSED'];
```

Missing: `ARCHIVED` (which has `is_terminal = true` in the DB).

## Impact

When `ARCHIVE` transition executes from `CLOSED` → `ARCHIVED`, the workflow instance is **not** marked `COMPLETED` because `ARCHIVED` is not in the hard-coded list. This leaves the instance in `ACTIVE` status, which conflicts with the unique partial index `uq_workflow_instance_active`.

## Fix

Single-word change:

```typescript
const TERMINAL_STATES = ['APPROVED', 'REJECTED', 'WITHDRAWN', 'CLOSED', 'ARCHIVED'];
```

## Dependencies

None. Can be applied before or during Phase 2.
