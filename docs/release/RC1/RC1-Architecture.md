# RC1 — Architecture Overview

## System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Frontend (Vite + React)                │
│  SDK ← axios client → Bearer JWT ← pino-http logs       │
└────────────────────────────────┬────────────────────────┘
                                 │ HTTP / SSE
┌────────────────────────────────┴────────────────────────┐
│                    Backend (Express 5.2.1)               │
│                                                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────────┐  │
│  │  Routes   │→│ Services  │→│   Repositories       │  │
│  │(auth, JWT)│  │(no SQL)  │  │(READ: no PoolClient) │  │
│  └──────────┘  └──────────┘  │(WRITE: PoolClient    │  │
│                               │ required)            │  │
│                               └──────────┬───────────┘  │
│                                          │               │
│  ┌──────────────────────────────────────┐│               │
│  │ Database Layer                       ││               │
│  │  query()  — read path (2 RTT)       ││               │
│  │  withTransaction() — write path     ││               │
│  │  set_config('app.user_id', ...)    ││               │
│  └──────────────────────────────────────┘               │
└────────────────────────────────┬────────────────────────┘
                                 │ TCP 5432
┌────────────────────────────────┴────────────────────────┐
│              PostgreSQL 18.3 (ethics_app)                │
│  • RLS on 27 tables • 62 policies • Soft Delete         │
│  • Append-only: document_versions/signatures/approvals  │
└─────────────────────────────────────────────────────────┘
```

## Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| `query()` read/write split | 4→2 RTT per query |
| `withTransaction()` for writes | BEGIN/COMMIT with session-level `app.user_id` |
| Repository contracts (5 interfaces) | Governance by enforcement, not convention |
| SDK hand-built (not Orval) | Inherits existing axios + token refresh |
| Pagination: `{page, limit, total, totalPages}` | Unified across all list endpoints |
| RTL-first UI | Arabic primary language with i18next |
| SSE auth via query param JWT | Self-contained, no cookie dependency |

## Governance Rules

- **READ repos**: MUST NOT accept `PoolClient`, MUST NOT start transactions
- **WRITE repos**: MUST receive `PoolClient` as last param, called within `withTransaction()`
- **Services**: MUST NOT contain raw SQL, MUST NOT call `pool.query()` or `client.query()`
- **No `DELETE FROM`**: use `softDelete()` or `UPDATE ... SET deleted_at`
- **Exception**: `notification.service.ts` (SSE infrastructure)
