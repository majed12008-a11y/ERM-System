# PB-002 — BackupService Architecture Review

> **Purpose:** Full engineering review of `BackupService` before Sprint 4 implementation.
> **Rules:** No code changes, no implementation. Review only.
> **Date:** 2026-07-13

---

## 1. Current Backup Architecture

### Files

| File | Role | Lines |
|------|------|-------|
| `backend/src/services/backup.service.ts` | Core service: create, verify, restore, list, delete, rotate | 275 |
| `backend/src/services/backup-destination.ts` | Storage abstraction: local filesystem or S3 (S3 stub) | 122 |
| `backend/src/services/backup-scheduler.ts` | Cron-based scheduled backups | 56 |
| `backend/src/modules/admin/backup.routes.ts` | Express routes: CRUD + verify + restore + rotate | 83 |
| `backend/src/config/env.ts` | Environment config (13 BACKUP_* vars, PG_BIN_PATH) | 60 (relevant lines) |

### Class Diagram

```
BackupService
├── destination: BackupDestination
│   ├── LocalBackupDestination (default, env.BACKUP_DIR)
│   └── S3BackupDestination (stub — methods throw Error)
├── pgBin: string              (prefix from env.PG_BIN_PATH)
├── superUser: string          (from DATABASE_URL or DB_USER)
├── superPassword: string      (from DATABASE_URL or DB_PASSWORD)
│
├── run(cmd: string)           ← SINGLE POINT OF EXECUTION — private
├── connArgs(dbName?)          ← builds -h -p -U -d args string
├── sanitizeDbName(name)       ← replaces [^a-zA-Z0-9_] with _
│
├── create(label?)             → pg_dump -Fc -f <tmpPath>
├── verify(name)               → pg_restore to temp DB, row counts
├── restore(name)              → pg_dump pre-backup, rename, restore, rollback on fail
├── list()                     → destination.list()
├── delete(name)               → destination.delete(name)
├── getStream(name)            → fs.ReadStream
├── rotate(config?)            → retention policy (daily/weekly/monthly)
├── terminateConnections(db)   → pg_terminate_backend()
└── dropDatabase(name)         → DROP DATABASE IF EXISTS
```

### Execution Flow — `run()` Method

```
run(cmd: string)
  ├── fullCmd = pgBin + cmd
  ├── logger.info({ cmd: fullCmd })
  ├── execAsync(fullCmd, { timeout: 600000, env: { ...process.env, PGPASSWORD: password } })
  │   └── child_process.exec() — spawns /bin/sh -c "fullCmd"
  ├── on success → return { stdout, stderr }
  └── on error
      ├── if (tolerateWarnings && err.code === 1) → return { stdout, stderr } (warnings-only)
      └── else → throw Error(stderr)
```

---

## 2. Threat Model

### T1 — Command Injection
- **Severity:** CRITICAL
- **Vector:** User-supplied backup `name` parameter flows into `run()` via `getPath(name)` → `filePath(name)` → `${fp}` in double-quoted shell strings. The `getPath()` method in `LocalBackupDestination` validates `.dump` extension and prevents path traversal (`path.resolve` + `startsWith(dir)`), but does **not** sanitize shell metacharacters (`$()`, backticks, `;`, `|`, `&&`, `\n`).
- **Exploit:** `name = "test$(calc.exe).dump"` passes `getPath()` checks, becomes part of shell command: `pg_restore -h localhost -p 5432 -U ethics_app -d ethics_db -Fc "C:\backups\test$(calc.exe).dump"` — shell expands `$(calc.exe)` before passing to `pg_restore`.
- **Impact:** Remote code execution as the PostgreSQL/application user.

### T2 — Shell Escaping
- **Severity:** MEDIUM
- **Vector:** All command strings use double-quoted shell interpolation (`"${fp}"`). No shell escaping function is applied to any variable.
- **Impact:** Combined with T1 — any unsanitized input flowing to `run()` is an injection vector.

### T3 — Path Traversal
- **Severity:** LOW (Mitigated)
- **Current state:** `LocalBackupDestination.getPath()` calls `path.resolve(dir, base)` where `base = path.basename(name)`, then asserts `resolved.startsWith(dir)`. This correctly prevents `../../etc/passwd` style traversal.
- **Remaining risk:** None identified — `path.basename()` strips directory components, and the starts-with check prevents symlink escapes.

### T4 — Arbitrary Command Execution
- **Severity:** CRITICAL
- **Vector:** Combined T1 + T2. Any method that accepts external `name` and passes it to `run()` is an RCE vector. Affected routes:
  - `POST /api/v1/admin/backup/:name/verify`
  - `POST /api/v1/admin/backup/:name/restore`
  - `GET /api/v1/admin/backup/:name/download`
  - `DELETE /api/v1/admin/backup/:name`

### T5 — Privilege Escalation
- **Severity:** MEDIUM
- **Vector:** All backup routes require `SUPER_ADMIN`, `SYS_ADMIN`, or `ADMIN` (middleware `authenticate` + `authorize`). However, a compromised admin account or SSRF from within the cluster could trigger T4.
- **Impact:** Full server compromise from a single stolen admin session.

### T6 — Credential Exposure
- **Severity:** MEDIUM
- **Vector:** `PGPASSWORD` is injected via `env` option to `exec()`. On Linux, `exec()` spawns `/bin/sh -c "..."` which exposes the environment to the child shell. `execFile()`/`spawn()` with `env` also expose it, but without the intermediate shell.
- **Impact:** Database credentials visible in `/proc/<pid>/environ` of shell process (briefly). Low practical risk in containerized environment.

### T7 — Temporary File Handling
- **Severity:** LOW (Mitigated)
- **Current state:** `create()` writes to `.tmp_<name>` in `BACKUP_DIR`, then moves to destination. Cleanup in `finally` block with try/catch. Good pattern.
- **Remaining risk:** None significant.

### T8 — Concurrent Backup/Restore
- **Severity:** MEDIUM
- **Vector:** No locking mechanism in `BackupService`. Two concurrent `restore()` calls could:
  1. Both dump pre-backup simultaneously (race writing the same temp file)
  2. Both attempt `ALTER DATABASE ... RENAME TO ...` on the same database name — second call fails
  3. `verify()` creates temp databases with `verify_restore_${Date.now()}` — timestamp reduces collision but millisecond precision means simultaneous calls could collide
- **Impact:** Data corruption on concurrent restore, failed verify on collision.

### T9 — Rollback Safety
- **Severity:** LOW (Well-designed)
- **Current state:** `restore()` follows a safe pattern: (1) pre-backup dump, (2) rename old DB, (3) create new DB with original name, (4) restore into new DB. On failure: drop new DB, rename old DB back. This is correct.
- **Remaining risk:** If the process crashes between step 2 (rename) and step 4 (restore complete), the database is in a renamed state with no active database under the original name. The pre-backup dump preserves data, but manual recovery would be needed. This is an accepted operational risk.

---

## 3. Execution Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        EXPRESS ROUTE HANDLER                            │
│  backup.routes.ts                                                       │
│  POST /:name/verify  →  service.verify(paramName(req))                  │
│  POST /:name/restore →  service.restore(paramName(req))                  │
│  DELETE /:name       →  service.delete(paramName(req))                   │
│  GET /:name/download →  service.getStream(paramName(req))                │
└───────────────────────┬─────────────────────────────────────────────────┘
                        │ name (from URL param)
                        ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                       BACKUP SERVICE                                    │
│                                                                         │
│  verify(name)         restore(name)        delete(name)                 │
│    │                    │                     │                         │
│    │ filePath(name)     │ filePath(name)      │ destination.delete()    │
│    ▼                    ▼                     ▼                          │
│  fs.existsSync(fp)    fs.existsSync(fp)    (no shell)                   │
│    │                    │                                               │
│    │ shell cmd #N       │ shell cmd #M                                  │
│    ▼                    ▼                                               │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  run(cmd: string)                                               │   │
│  │  ┌───────────────────────────────────────────────────────────┐  │   │
│  │  │ execAsync(fullCmd, { timeout, env: { PGPASSWORD } })      │  │   │
│  │  │ child_process.exec() → /bin/sh -c "pgBin + cmd"           │  │   │
│  │  └───────────────────────────────────────────────────────────┘  │   │
│  └─────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 4. Process Creation API Usage

### Currently Used

| API | Import | Usage | Count |
|-----|--------|-------|-------|
| `exec` | `const { exec } = require('child_process')` | `promisify(exec)` → `execAsync()` | 1 wrapper → 11 call sites |
| `execSync` | — | Not used | 0 |
| `spawn` | — | Not used | 0 |
| `spawnSync` | — | Not used | 0 |
| `execFile` | — | Not used | 0 |
| `execFileSync` | — | Not used | 0 |

### Source

`backend/src/services/backup.service.ts` line 1:
```typescript
import { exec } from 'child_process';
import { promisify } from 'util';
```

Line 9:
```typescript
const execAsync = promisify(exec);
```

Line 77-94 — the `run()` method wraps ALL process execution through `execAsync(fullCmd, ...)`.

---

## 5. Every Shell Command Currently Executed

All 11 commands go through `run(cmd)` which prepends `pgBin` and passes to `exec()`. Shell expansion is active in every case.

| # | Caller | Command | User Data | Risk |
|---|--------|---------|-----------|------|
| 1 | `create()` L107 | `pg_dump <connArgs> -Fc -f "<tmpPath>"` | `tmpPath` = `BACKUP_DIR/.tmp_<name>` — `name` has label sanitized via `[^a-zA-Z0-9_-]` | 🟢 Low |
| 2 | `verify()` L129 | `psql <connArgs(postgres)> -c "CREATE DATABASE <safeDb> OWNER ethics_app;"` | `safeDb` = `sanitizeDbName('verify_restore_' + Date.now())` | 🟢 Low |
| 3 | `verify()` L131 | `pg_restore <connArgs(verifyDb)> -Fc "<fp>"` | `fp` = `getPath(name)` — .dump checked, traversal checked, but no shell sanitization | 🔴 HIGH |
| 4 | `verify()` L144 | `psql <connArgs(verifyDb)> -At -c "<q.sql>"` | `q.sql` hardcoded in source | 🟢 None |
| 5 | `restore()` L165 | `pg_dump <connArgs> -Fc -f "<prePath>"` | `prePath` = `BACKUP_DIR/pre_restore_<timestamp>.dump` (no user input) | 🟢 Low |
| 6 | `restore()` L170 | `psql <connArgs(postgres)> -c "ALTER DATABASE <dbName> RENAME TO <safeOldName>;"` | `dbName` from env, `safeOldName` = `sanitizeDbName(dbName + '_old_' + Date.now())` | 🟢 Low |
| 7 | `restore()` L171 | `psql <connArgs(postgres)> -c "CREATE DATABASE <dbName> OWNER ethics_app;"` | `dbName` from env | 🟢 None |
| 8 | `restore()` L174 | `pg_restore <connArgs(dbName)> -Fc "<fp>"` | `fp` = `getPath(name)` — **same as #3** | 🔴 HIGH |
| 9 | `restore()` L179 | `psql <connArgs(postgres)> -c "ALTER DATABASE <safeOldName> RENAME TO <dbName>;"` | Both sanitized or from env | 🟢 Low |
| 10 | `terminateConnections()` L253 | `psql <connArgs(postgres)> -At -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '<safe>' AND pid <> pg_backend_pid();"` | `safe` = `sanitizeDbName(dbName)` | 🟢 Low |
| 11 | `dropDatabase()` L265 | `psql <connArgs(postgres)> -c "DROP DATABASE IF EXISTS <safe>;"` | `safe` = `sanitizeDbName(name)` | 🟢 Low |

### Risk Summary

| Risk Level | Count | Details |
|-----------|-------|---------|
| 🔴 HIGH | 2 | Commands #3, #8 — `name` flows to `${fp}` in double-quoted shell string via `getPath()`. No shell metacharacter sanitization. |
| 🟡 MEDIUM | 0 | — |
| 🟢 Low/None | 9 | All other commands use env-derived or programmatically-generated values with proper sanitization. |

---

## 6. Recommended Replacement

### Priority Order (per requirement)

```
execFile  (safest — no shell, argument array)
   ↓
spawn     (no shell, argument array, supports streaming)
   ↓
exec      (DO NOT USE — spawns shell)
```

### Recommendation: **Use `execFile` for all commands**

Rationale:
- `execFile(cmd, args[], options)` does NOT spawn a shell
- All arguments are passed directly to the executable as an array
- Shell metacharacters in argument values are treated as literal characters — **injection impossible**
- Supports the same `timeout` and `env` options as `exec`
- Returns `{ stdout, stderr }` via `Buffer` — same interface as `exec` when promisified
- `pg_dump`, `pg_restore`, and `psql` all accept `-c "SQL"` as a single argument — works identically with `execFile`

### Why not `spawn`?
- `spawn` returns a `ChildProcess` stream, not a promise with `{ stdout, stderr }`. This would require restructuring `run()` to collect output via stream events, making it harder to verify behavioral equivalence.
- `execFile` is a drop-in replacement for `exec` when shell features (pipes, redirects, variable expansion) are not needed — and they are not needed here.

### Migration Pattern

```typescript
// BEFORE (line 81)
const result = await execAsync(fullCmd, {
  timeout: 600000,
  env: { ...process.env, PGPASSWORD: this.superPassword },
});

// AFTER
const result = await execFileAsync(pgBin + 'pg_dump', ['-h', host, '-p', port, '-U', user, '-d', db, '-Fc', '-f', tmpPath], {
  timeout: 600000,
  env: { ...process.env, PGPASSWORD: this.superPassword },
});
```

### SQL Command Handling

`psql -c "SQL"` works identically with `execFile`:
```typescript
// execFile('psql', ['-h', host, '-p', port, '-U', user, '-d', 'postgres', '-c', 'CREATE DATABASE foo OWNER ethics_app;'])
```
The SQL string is passed as a single array element. PostgreSQL's psql receives it as the argument to `-c`. SQL injection is still prevented by `sanitizeDbName()`.

---



## 7. Functionality Preservation Verification

### Behavioral Equivalence

| Aspect | `exec()` | `execFile()` | Impact |
|--------|----------|--------------|--------|
| Shell spawning | Yes (`/bin/sh -c`) | No | 🔑 Key security improvement |
| Argument passing | Shell-interpolated string | Array of strings | Identical for non-metacharacter values |
| File paths with spaces | Require `"${fp}"` quoting | Passed as separate array element — no quoting needed | ✅ Identical (better: spaces handled natively) |
| Timeout | `{ timeout: 600000 }` | Same option | ✅ Identical |
| Environment | `{ env: { ...process.env, PGPASSWORD } }` | Same option | ✅ Identical |
| stdout/stderr | `{ stdout: string, stderr: string }` | Same shape via `Buffer → string` | ✅ Identical |
| Exit code handling | `err.code === 1` for warnings | Same (`execFile` throws on non-zero exit) | ✅ Identical |
| Max buffer | Default 1024KB | Same default | ✅ Identical |

### SQL Commands — Argument Conversion

| Before (shell string) | After (execFile args) | Notes |
|-----------------------|----------------------|-------|
| `pg_dump <connArgs> -Fc -f "<tmpPath>"` | `['pg_dump', '-h', host, '-p', port, '-U', user, '-d', db, '-Fc', '-f', tmpPath]` | `tmpPath` doesn't need quoting |
| `psql <connArgs> -c "CREATE DATABASE x OWNER ethics_app;"` | `['psql', '-h', host, '-p', port, '-U', user, '-d', 'postgres', '-c', 'CREATE DATABASE x OWNER ethics_app;']` | SQL is a single arg |
| `pg_restore <connArgs> -Fc "<fp>"` | `['pg_restore', '-h', host, '-p', port, '-U', user, '-d', db, '-Fc', fp]` | `fp` with spaces works natively |

### What Does NOT Change

- No API changes — all public method signatures remain identical
- No database changes — SQL commands produce identical results
- No workflow changes — backup → verify → restore cycle behavior is preserved
- No frontend changes — backend-only change
- No route changes — `backup.routes.ts` remains untouched

### Confirmed: Functionality Remains Identical

After replacing `exec()` with `execFile()`:

1. **Backup create**: Same `pg_dump` command, same output file
2. **Backup verify**: Same `pg_restore` to temp database, same row count queries
3. **Backup restore**: Same pre-backup dump, same DB rename/create/restore cycle, same rollback on failure
4. **Connection termination**: Same `pg_terminate_backend` queries, same behavior
5. **Database drop**: Same `DROP DATABASE IF EXISTS`
6. **Timeout**: Same 600-second limit
7. **Environment**: Same `PGPASSWORD` injection
8. **Error handling**: Same exit code checking for warning tolerance
9. **Rollback**: Same rename-back behavior on restore failure

---

## 8. Proposed Implementation Plan for PB-002

### Step 1: Refactor `run()` method (⚠️ ONLY code change in `backup.service.ts`)

**Change:** Replace `execAsync(fullCmd, ...)` with `execFileAsync(executable, args[], ...)`.

**How:**
1. Change import: `exec` → `execFile` (or add both and deprecate `exec`)
2. Change `run()` signature from `run(cmd: string)` to `run(executable: string, args: string[])`
3. Remove the `pgBin` string prepend — pass the full binary path as first argument
4. All existing callers pass `(binary, args[])` instead of a flat string

### Step 2: Update `connArgs()` (refactor to return array, not string)

**Change:** `connArgs(dbName?)` returns `string[]` instead of `string`.

Before: `return '-h ${env.DB_HOST} -p ${env.DB_PORT} -U ${this.superUser} -d ${dbName}`  
After: `return ['-h', env.DB_HOST, '-p', String(env.DB_PORT), '-U', this.superUser, '-d', dbName]`

### Step 3: Update each call site

**11 call sites** → each converts from string interpolation to array arguments.

Example for `verify()` L131:
```typescript
// Before:
await this.run(`pg_restore ${this.connArgs(verifyDb)} -Fc "${fp}"`, true);

// After:
await this.run('pg_restore', [...this.connArgs(verifyDb), '-Fc', fp], true);
```

### Step 4: Add Zod schema for backup name parameter

**File:** `backend/src/middleware/schemas.ts` (already modified during PB-001)

Add:
```typescript
export const backupNameSchema = z.string()
  .min(1)
  .max(255)
  .regex(/^[a-zA-Z0-9_.-]+\.dump$/);
```

### Step 5: Update backup routes to validate name param

**File:** `backend/src/modules/admin/backup.routes.ts`

Add `validate(paramSchema)` middleware to routes that accept `:name` parameter.

### Step 6: Write security tests

**File:** `backend/src/test/backup-security.test.ts`

Test cases:
- Valid backup name → accepted
- Name with `$(calc.exe)` → 400 (Zod rejects or execFile treats as literal)
- Name with backticks → 400
- Name with semicolons → 400
- Name with path traversal (`../etc`) → 400
- Empty name → 400
- Name without `.dump` extension → 400
- Unicode name → 400 or handled safely

### Step 7: Run full regression suite

- `npm run lint` (tsc --noEmit) — 0 errors expected
- `npm test` — all 999+ tests pass, 0 regressions
- `cd frontend && npm run build` — passes (no frontend changes)
- Manual: backup create → verify → restore cycle in staging

### Files Modified (estimated)

| File | Change Type | Complexity |
|------|-------------|------------|
| `backend/src/services/backup.service.ts` | Refactor `run()`, update 11 call sites, update `connArgs()` | Medium |
| `backend/src/middleware/schemas.ts` | Add `backupNameSchema` | Low |
| `backend/src/modules/admin/backup.routes.ts` | Add `validate()` for name param | Low |
| `backend/src/test/backup-security.test.ts` | New file — 8+ security tests | Low |

### Files NOT Modified

- `backend/src/services/backup-destination.ts` — No changes needed (getPath already validates)
- `backend/src/services/backup-scheduler.ts` — No changes (uses only env, no user input)
- `backend/src/modules/admin/backup.routes.ts` — Route handlers remain identical
- Any frontend files — No frontend changes
- Any database files — No schema changes
- Any CI files — No pipeline changes

---

## Review Summary

| Area | Verdict |
|------|---------|
| Current architecture | Solid design with safe rollback pattern |
| Threat exposure | **CRITICAL** — RCE via shell injection in 2 command paths |
| Process API usage | Only `exec()` — worst choice for security |
| Recommended replacement | `execFile()` — drop-in replacement, no behavioral change |
| Route-level validation | Zod `backupNameSchema` with strict regex (additive) |
| Functionality preservation | ✅ Verified — no behavior changes, no API changes, no DB changes, no workflow changes, no frontend changes |
| Implementation risk | Low — mechanical refactor of argument passing, no logic changes |
| Estimated effort | 1 day (4h refactor + 2h testing + 2h security tests) |
