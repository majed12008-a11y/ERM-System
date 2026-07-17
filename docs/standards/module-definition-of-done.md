# Module Definition of Done

> Every module must satisfy ALL of the following before approval.

## Module Lifecycle States

Every module progresses through three states:

| State | Meaning |
|-------|---------|
| **Module Complete** | Functional development finished. All sections, pages, API endpoints, and SDK methods implemented. |
| **Production Ready** | Passed Gate 8. Buildable, testable, deployable. No regressions. |
| **Released** | Shipped in a tagged release (e.g. RC1, v1.0.0). |

A module may NOT be marked **Production Ready** until Gate 8 is satisfied.

---

## Gate 8 — Production Readiness Gate

> A module is only Production Ready when the **entire application** builds, tests, and deploys successfully.

### Project Build

- [ ] Backend TypeScript passes (`cd backend && npm run lint`)
- [ ] Frontend TypeScript passes (`cd frontend && npx tsc --noEmit`)
- [ ] Production build completes (`cd frontend && npm run build`)
- [ ] No build blockers remain

### Tests

- [ ] All tests introduced by the module pass
- [ ] No new failing tests
- [ ] Existing unrelated failures documented
- [ ] Regression assessment completed

### Integration

- [ ] OpenAPI updated
- [ ] SDK regenerated via Orval
- [ ] Frontend uses generated SDK
- [ ] No remaining mock data

### Quality

- [ ] Exit Review completed
- [ ] Accessibility verified
- [ ] Localization verified (AR + EN)
- [ ] RTL/LTR verified
- [ ] Permission checks verified
- [ ] Responsive layout verified

### Performance

- [ ] No unnecessary requests
- [ ] No duplicate requests
- [ ] No significant bundle regression

### Documentation

- [ ] Module documentation updated
- [ ] Known limitations documented
- [ ] Production Ready decision recorded

### Fail Conditions

Gate 8 **automatically FAILS** if any of the following:

- Production build fails
- TypeScript fails
- Module introduces new regressions
- Mock data remains
- SDK and OpenAPI are out of sync
- Exit Review has not been completed

---

## Module Checklist

### Architecture

- Clean Architecture preserved
- Repository pattern respected
- Three-layer separation maintained (Routes → Services → Repositories)
- RLS enforced via AsyncLocalStorage context propagation
- No architectural violations

## Database

- Schema complete
- Constraints validated
- Migrations reviewed
- Seed data available where applicable

## Backend

- Repository complete (extends AuditableRepository)
- Service complete
- Controllers complete
- Validation complete (Zod)
- Authorization complete (RLS policies + role checks)
- Error handling complete

## API

- REST endpoints complete
- OpenAPI spec updated (backend/openapi/)
- Request/response schemas documented
- Server port correct (8080)

## SDK

- Generated successfully via Orval
- No manual request duplication
- Type-safe
- No hardcoded IDs or values

## Frontend

- No mock data — all pages use generated SDK
- List page complete (pagination, sorting, search, filter)
- Details page complete (all sections, tabs)
- Create/Edit pages complete (multi-step wizards)
- Dialogs complete (confirmation, forms)
- Forms validated (Zod schemas)

## User Experience

- Loading states (skeletons)
- Empty states (3 variants: empty, search, error)
- Error states (retry buttons)
- Confirmation dialogs (Radix Dialog)
- Toast notifications (sonner)

## Permissions

- UI permission checks (usePermission hook)
- API authorization checks (RLS + service-level)
- Unauthorized actions hidden or disabled

## Localization

- Arabic complete
- English complete
- No missing translation keys
- RTL verified
- LTR verified

## Accessibility

- Keyboard navigation
- Focus management
- ARIA labels on interactive elements
- Dialog accessibility (Radix primitives)

## Responsive Design

- Desktop (lg+)
- Tablet (md)
- Mobile (sm)

## Testing

- TypeScript passes (tsc --noEmit)
- Production build passes (vite build)
- Backend tests pass (vitest)
- Frontend integration verified
- No critical regressions

## Performance

- No duplicate requests
- No unnecessary renders
- Query invalidation verified
- Acceptable bundle growth

## Exit Review

- Functional verification complete
- Regression assessment complete
- Outstanding issues documented

---

## Module Certification

| Module | Module Complete | Production Ready (Gate 8) | Released |
|--------|:-:|:-:|:-:|
| Applications | ✅ | ✅ 2026-07-13 | — |
| Committees | ✅ | ✅ 2026-07-13 | — |
| Documents | ✅ | ✅ 2026-07-14 | — |
| Reviews | — | — | — |
| Notifications | — | — | — |
| Templates | — | — | — |
| Reporting | — | — | — |

---

**Only after Gate 8 passes may a module be marked PRODUCTION READY.**
