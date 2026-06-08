# Repository Governance

## READ Rules

| Rule | Description |
|---|---|
| No PoolClient | READ methods MUST NOT accept a `PoolClient` parameter |
| No transactions | READ methods MUST NOT call `withTransaction()` or issue `BEGIN`/`COMMIT` |
| SELECT only | READ methods MUST perform SELECT operations only |

```typescript
// ✅ Correct
async findById(id: number): Promise<T | null> {
  const result = await this.query(`SELECT * FROM t WHERE id = $1`, [id]);
  return result.rows[0] || null;
}

// ❌ Forbidden — PoolClient in read method
async findById(id: number, client?: PoolClient): Promise<T | null> { ... }
```

## WRITE Rules

| Rule | Description |
|---|---|
| PoolClient required | WRITE methods MUST accept `PoolClient` as the last parameter |
| Transaction boundary | WRITE methods MUST be called from within `withTransaction()` in the Service |
| No internal transactions | WRITE methods MUST NOT call `withTransaction()` themselves |

```typescript
// ✅ Correct
async create(data: CreateDTO, client: PoolClient): Promise<T> {
  const result = await this.query(`INSERT INTO t ...`, [...], client);
  return result.rows[0];
}

// ❌ Forbidden — no PoolClient in write
async create(data: CreateDTO): Promise<T> { ... }
```

## Transaction Boundaries

- **Service layer** owns `withTransaction()`
- **Repository** receives the `client` and uses it
- **READ path** uses `this.query(text, params)` → `pool.query()` (no BEGIN/COMMIT)
- **WRITE path** uses `this.query(text, params, client)` → `client.query()` (inside transaction)

## Service Layer Rules

| Rule | Description |
|---|---|
| No SQL | Services MUST NOT contain raw SQL strings |
| No pool.query | Services MUST NOT call `pool.query()` or `this.query()` directly |
| No direct writes | Writing MUST go through Repository → `client.query()` |

## Repository Checklist

Apply to every repository:

- [ ] READ methods have no `PoolClient`
- [ ] WRITE methods have `client: PoolClient` as last parameter
- [ ] No `pool.query()` calls outside READ path
- [ ] No `withTransaction()` calls inside repository methods
