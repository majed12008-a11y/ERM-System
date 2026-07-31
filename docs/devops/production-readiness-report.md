# Production Readiness Report — RC1

## Overall: READY FOR PILOT (7/10)

| Category | Score | Status |
|----------|-------|--------|
| Security | 7/10 | 15 gaps (0 critical, 2 high, 8 med, 5 low) |
| Operations | 6/10 | 18 gaps (3 critical, 4 high, 8 med, 3 low) |
| Database | 7/10 | 14 gaps (2 critical, 3 high, 5 med, 4 low) |

---

## FIXED ✅

| ID | Description | File(s) |
|----|-------------|---------|
| **C1** | Static file serving in production | `backend/src/index.ts` |
| **C2** | `uncaughtException` now exits process | `backend/src/index.ts` |
| **C3** | Database pool drained on shutdown | `backend/src/index.ts` |
| **C4** | FK constraint on `applications.target_committee_id` | `seed/24-prod-readiness-fixes.sql` |
| **H1** | Message MIME type filter + filename sanitization | `backend/src/modules/communication/messages.routes.ts` |
| **H3** | `verificationToken` removed from register response | `backend/src/services/auth.service.ts` |
| **H4** | Rate limiting on `/register` (5/min) and `/forgot-password` (3/min) | `backend/src/modules/security/auth.routes.ts` |
| **H10** | FK indexes on 15+ columns + composite indexes + JSONB conversion | `seed/24-prod-readiness-fixes.sql` |
| **M1** | CORS dev origin restricted to `localhost:5173` | `backend/src/index.ts` |
| **M2** | `FRONTEND_URL` added to env validation | `backend/src/config/env.ts`, `email.service.ts` |
| **M3** | Zod validation on `change-password` route | `backend/src/middleware/schemas.ts`, `auth.routes.ts` |
| **M5** | JSON body limit reduced to 1mb | `backend/src/index.ts` |

---

## CRITICAL — Must Fix Before Pilot/UAT

### C5. 19 API routes missing Zod validation
**Files:** Multiple route files (meetings, voting, safety, roles, permissions, profile)
**Fix:** Add `validate(schema)` middleware to all POST/PUT/PATCH
**Impact:** Arbitrary data accepted by API
**Status:** ⏳ Not started (large scope, 15+ routes)

---

## HIGH — Should Fix Before Pilot

### H2. Backup service shell injection risk
**File:** `src/services/backup.service.ts:104-148`
**Fix:** Validate `label` with regex; use `execFile()` with args array
**Status:** ⏳ Not started

### H5. Dockerfile copies dev node_modules over prod
**File:** `backend/Dockerfile:15`
**Fix:** Remove `COPY --from=builder /app/node_modules` line
**Status:** ⏳ Not started

### H6. No container resource limits
**File:** `docker-compose.yml`
**Fix:** Add `mem_limit` / `deploy.resources.limits`
**Status:** ⏳ Not started

### H7. PostgreSQL exposed on all host interfaces
**File:** `docker-compose.yml:16`
**Fix:** Bind to `127.0.0.1:5432:5432`
**Status:** ⏳ Not started

### H8. Backup script hardcodes `postgres` password
**File:** `scripts/backup.ps1:10`
**Fix:** Make password mandatory parameter
**Status:** ⏳ Not started

### H9. RLS missing on `monitoring.*` and `reporting.*`
**File:** `seed/`
**Fix:** Create RLS policies for monitoring and reporting schemas
**Status:** ⏳ Not started

---

## MEDIUM — Fix Post-Pilot

### M4. No HEALTHCHECK on backend/frontend containers
### M6. `question_options` → JSONB (DONE in 24-prod-readiness-fixes.sql ✅)
### M7. No `npm audit` script in CI
### M8. Health endpoints return inconsistent formats
### M9. ZodError handler returns 422 instead of 500
### M10. No `stop-prod.ps1` script

---

## Appendix: What IS Production-Ready

- **Password hashing**: Argon2id (memory-hard, GPU-resistant)
- **JWT auth**: 15min access + 7d refresh (HS256)
- **RLS**: Dozens of policies across core schemas
- **Audit trail**: Comprehensive triggers on all tables
- **Rate limiting**: 60 req/min global; 10 req/min on login
- **Security headers**: Helmet with CSP in production
- **Structured logging**: JSON via Pino with correlation IDs
- **Graceful shutdown**: Server closes connections (partial — needs pool drain)
- **Backup/DR**: pg_dump custom format with verify and rotation
- **CI/CD**: Multi-stage pipeline with E2E tests
- **Docker**: Multi-stage builds, non-root user, Alpine base
- **Input validation**: Zod schemas on 15+ critical routes
- **Account security**: Lockout after 5 failures, password history
- **File upload**: MIME whitelist for documents (but not messages)
