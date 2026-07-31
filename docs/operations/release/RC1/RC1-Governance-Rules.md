# RC1 — Repository Governance Rules

## Contracts (`backend/src/repositories/contracts.ts`)

| Interface | Methods | PoolClient Rule |
|-----------|---------|-----------------|
| `IReadRepository<T>` | `findById(id)` | MUST NOT accept |
| `IPaginatedReadRepository<T>` | `findAll(page, limit)` | MUST NOT accept |
| `IWriteRepository<T>` | `create(data, client)` | MUST receive as last param |
| `IUpdateRepository<T>` | `update(id, data, client)` | MUST receive as last param |
| `ISoftDeleteRepository` | `softDelete(id, client)` | MUST receive as last param |

## Enforcement

- **163 governance tests** in `backend/src/test/repository-governance.test.ts`
- Scans all service files: no SQL leakage (`pool.query`, `client.query`, raw SQL strings)
- Scans all repository files: no `PoolClient` in read methods
- Verifies every repository implements its required contracts
- **Result: 163/163 PASS**

## Transaction Boundaries

```typescript
// READ — no transaction, no PoolClient
const project = await projectRepository.findById(id);

// WRITE — must be inside withTransaction()
const result = await withTransaction(async (client) => {
  const created = await projectRepository.create(data, client);
  await applicationRepository.create(appData, client);
  return created;
});
```

## Rules Summary

| Rule | Applies To | ❌ Wrong | ✅ Correct |
|------|-----------|----------|------------|
| No SQL in services | All service files | `pool.query(...)` | `repository.method(...)` |
| No PoolClient in reads | Read repository methods | `findById(id, client)` | `findById(id)` |
| PoolClient required in writes | Write repository methods | `create(data)` | `create(data, client)` |
| WRITE within transaction | Service calling write repos | `repo.create(data)` | `withTransaction(() => repo.create(data, client))` |

## Exception

`notification.service.ts` — contains raw SQL for SSE notification infrastructure (exempted by decision).
