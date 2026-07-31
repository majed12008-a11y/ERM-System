# RC4 Architecture Package

**Version:** v4.0-draft
**Date:** 2026-07-23
**Status:** PLANNING (No Implementation)

---

# 1. Executive Vision

## Purpose of RC4

RC4 transforms the Ethics ERM System from a **certified development system** (RC3) into a **production-deployable platform** ready for real institutional use. RC3 achieved structural integrity; RC4 achieves operational maturity.

## Business Objectives

1. **Operational Readiness**: Enable daily use by ethics committees, researchers, and administrators
2. **Data Quality**: Ensure the system produces reliable, auditable, compliant research ethics records
3. **Institutional Confidence**: Provide dashboards, reports, and export capabilities that demonstrate system value
4. **Scalability Foundation**: Prepare architecture for multi-institution deployment
5. **Compliance**: Meet international research ethics standards (CIOMS, Declaration of Helsinki, GCP)

## Expected User Value

| User Role | Current Value (RC3) | Enhanced Value (RC4) |
|-----------|--------------------|--------------------|
| Researcher | Submit applications, track status, upload evidence | PDF certificates, application templates, bulk operations |
| Ethics Admin | Manage workflow, review conditions, generate reports | Advanced reporting, audit trail export, performance dashboards |
| Committee Chair | Schedule meetings, conduct reviews, cast votes | Meeting packs, review assignment optimization, SLA tracking |
| Committee Member | View assigned reviews, submit scores | Mobile-friendly review interface |
| Super Admin | System configuration, backup management | Multi-institution support, advanced monitoring |

## Scope

### In-Scope for RC4

1. PDF certificate generation and download
2. Advanced reporting (PDF/Excel export, scheduled reports)
3. Application templates (pre-filled forms, field validation)
4. SLA tracking and escalation alerts
5. Committee meeting pack generation
6. Notification preferences UI
7. Bulk operations (approve/reject multiple applications)
8. Dashboard widgets (role-based, customizable)
9. Audit trail export (CSV/JSON for compliance)
10. Database migration framework
11. E2E test coverage (Playwright)
12. Safety module i18n completion
13. Frontend test coverage (unit + integration)
14. Schema canonical alignment

### Out-of-Scope for RC4

1. Multi-institution deployment (architecture prep only)
2. Mobile native app (responsive web only)
3. AI/ML features
4. External system integrations (ERP, LMS, HR)
5. Workflow designer UI
6. Real-time collaboration
7. Advanced caching (Redis)
8. Microservices split

---

# 2. Gap Analysis

## Functional Gaps

| # | Gap | Current State | Ideal State | Priority | Effort |
|---|-----|--------------|-------------|----------|--------|
| F-01 | No PDF certificate generation | Certificates in DB, no PDF output | One-click PDF download | CRITICAL | High |
| F-02 | No application templates | Blank forms only | Pre-filled templates per research type | HIGH | Medium |
| F-03 | No bulk operations | One-at-a-time processing | Batch approve/reject | HIGH | Medium |
| F-04 | No SLA tracking | SLA columns exist, no enforcement | Automated alerts, escalation | HIGH | Medium |
| F-05 | No meeting pack generation | Manual assembly | Auto-generated agenda + reviews PDF | HIGH | High |
| F-06 | No scheduled reports | On-demand only | Email/FTP scheduled delivery | MEDIUM | Medium |
| F-07 | No application renewal UI | Endpoint exists, no UI | End-to-end renewal flow | MEDIUM | Medium |
| F-08 | No appeal workflow UI | Endpoint exists, no UI | End-to-end appeal flow | MEDIUM | Medium |
| F-09 | No certificate verification UI | Backend endpoint exists | Public verification page with QR | LOW | Low |

## UX Gaps

| # | Gap | Current State | Ideal State | Priority | Effort |
|---|-----|--------------|-------------|----------|--------|
| U-01 | Safety module not i18n (85%) | 4 pages hardcoded Arabic | Full Arabic/English | HIGH | Low |
| U-02 | No role-based route guards | All routes visible, 403 on access | Route-level authorization | HIGH | Medium |
| U-03 | Orphan EmailSettings page | File exists, not routed | Remove or integrate | LOW | Low |
| U-04 | No per-section error boundaries | Single top-level ErrorBoundary | Section-level isolation | MEDIUM | Low |
| U-05 | Mixed SDK vs direct API calls | ConsentTab, RiskAssessment bypass SDK | All pages use SDK | MEDIUM | Low |
| U-06 | No application timeline viz | History endpoint exists, list only | Visual timeline with transitions | MEDIUM | Medium |
| U-07 | No keyboard navigation | Standard tab only | Keyboard shortcuts, command palette | LOW | Medium |
| U-08 | No drag-and-drop upload | Standard file input | Drag-and-drop with preview | LOW | Low |

## Security Gaps

| # | Gap | Current State | Ideal State | Priority | Effort |
|---|-----|--------------|-------------|----------|--------|
| S-01 | Access token in sessionStorage | Vulnerable to XSS | httpOnly cookie | HIGH | Medium |
| S-02 | SSE auth via query string | Token in URL (logged) | Header-based SSE auth | MEDIUM | Medium |
| S-03 | dangerouslySetInnerHTML | Template preview renders raw HTML | Sanitized HTML or iframe | HIGH | Low |
| S-04 | No CSP headers in dev | Helmet CSP in prod only | CSP in all environments | LOW | Low |
| S-05 | No body size differentiation | Global 1MB limit | Per-route limits | LOW | Low |

## Reporting Gaps

| # | Gap | Current State | Ideal State | Priority | Effort |
|---|-----|--------------|-------------|----------|--------|
| R-01 | No PDF export | CSV only | PDF reports with charts | HIGH | High |
| R-02 | No Excel export | CSV only | Native Excel with formatting | HIGH | Medium |
| R-03 | No report scheduling | On-demand | Email delivery, cron-based | MEDIUM | Medium |
| R-04 | No custom report builder | Fixed templates | User-configurable fields | LOW | High |
| R-05 | No audit trail export | Audit logs in DB only | CSV/JSON for compliance | HIGH | Medium |
| R-06 | No application statistics | Basic dashboard stats | Trend analysis, forecasting | LOW | High |

## Workflow Gaps

| # | Gap | Current State | Ideal State | Priority | Effort |
|---|-----|--------------|-------------|----------|--------|
| W-01 | No SLA enforcement | SLA columns unused | Auto-escalation on breach | HIGH | Medium |
| W-02 | No workflow designer | Code-only states/transitions | Visual workflow editor | LOW | Very High |
| W-03 | No conditional branching | Linear workflow only | Branch based on risk/type | LOW | High |
| W-04 | No workflow templates | Single APP_REVIEW_V1 | Multiple workflow definitions | MEDIUM | High |

## Administrative Gaps

| # | Gap | Current State | Ideal State | Priority | Effort |
|---|-----|--------------|-------------|----------|--------|
| A-01 | No notification preferences UI | Table exists, no UI | Per-event-type email/SMS/push toggle | HIGH | Medium |
| A-02 | No bulk user management | One-at-a-time | CSV import, batch role assignment | MEDIUM | Medium |
| A-03 | No system health dashboard | Basic health endpoint | Comprehensive monitoring UI | MEDIUM | Medium |
| A-04 | No data retention policy | No enforcement | Automated archival/deletion | LOW | Medium |
| A-05 | No multi-tenancy | Single institution | Institution isolation | LOW | Very High |

## Performance Opportunities

| # | Opportunity | Current State | Target | Priority | Effort |
|---|------------|--------------|--------|----------|--------|
| P-01 | Frontend build optimization | ~5s | <3s | MEDIUM | Medium |
| P-02 | Database query optimization | Good index coverage | Query plan analysis | LOW | Medium |
| P-03 | API response caching | No caching | ETag/Cache-Control | MEDIUM | Low |
| P-04 | Connection pool tuning | 20 max connections | Auto-tune based on load | LOW | Low |
| P-05 | Frontend bundle splitting | Single bundle | Route-based code splitting | MEDIUM | Low |

## Integration Opportunities

| # | Opportunity | Current State | Target | Priority | Effort |
|---|------------|--------------|--------|----------|--------|
| I-01 | Email service integration | Console logging only | SMTP/SendGrid integration | HIGH | Medium |
| I-02 | SMS service integration | Config exists, not connected | Twilio/local SMS gateway | MEDIUM | Medium |
| I-03 | Push notifications | Config exists, not connected | Web Push API | LOW | Medium |
| I-04 | Document signing | Basic sign endpoint | Digital signature (PDF) | MEDIUM | High |
| I-05 | SSO/LDAP | Local auth only | Institutional SSO | LOW | High |

---

# 3. Feature Candidates

## CRITICAL Priority

### FC-01: PDF Certificate Generation
- **Description**: Generate PDF certificates from approved applications using the template engine
- **Business Value**: Researchers need downloadable, printable certificates for institutional records
- **Technical Complexity**: Medium (template engine + PDF library)
- **Risk**: Low (template engine already functional)
- **Dependencies**: Template engine (RC3), certificate tables (RC3)
- **Suggested Effort**: 2-3 days

### FC-02: Notification Preferences UI
- **Description**: User interface for managing email/SMS/push notification preferences per event type
- **Business Value**: Users need control over notification channels to avoid overload
- **Technical Complexity**: Low (table exists, CRUD exists, need UI)
- **Risk**: Low
- **Dependencies**: None
- **Suggested Effort**: 1 day

## HIGH Priority

### FC-03: Application Templates
- **Description**: Pre-filled application forms based on research type (clinical trial, survey, etc.)
- **Business Value**: Reduces researcher friction, ensures completeness, speeds up review
- **Technical Complexity**: Medium (template engine integration with application creation)
- **Risk**: Medium (template variable resolution complexity)
- **Dependencies**: Template engine (RC3)
- **Suggested Effort**: 3-4 days

### FC-04: SLA Tracking & Escalation
- **Description**: Automated SLA monitoring with escalation alerts when review deadlines approach
- **Business Value**: Ensures timely reviews, demonstrates institutional compliance
- **Technical Complexity**: Medium (background job + notification integration)
- **Risk**: Low (SLA columns already exist)
- **Dependencies**: Notification system, background job scheduler
- **Suggested Effort**: 2-3 days

### FC-05: Bulk Operations
- **Description**: Batch approve/reject applications, batch condition resolution, batch document operations
- **Business Value**: Admins process many applications daily; one-at-a-time is unsustainable
- **Technical Complexity**: Medium (transaction management, partial failure handling)
- **Risk**: Medium (data integrity during partial failures)
- **Dependencies**: Workflow engine (RC3)
- **Suggested Effort**: 2-3 days

### FC-06: Meeting Pack Generation
- **Description**: Auto-generate PDF meeting packs containing agenda, applications, reviews, and documents
- **Business Value**: Committee chairs spend hours manually assembling meeting materials
- **Technical Complexity**: High (PDF generation + document aggregation)
- **Risk**: Medium (large document assembly)
- **Dependencies**: PDF library, template engine
- **Suggested Effort**: 3-4 days

### FC-07: Excel Report Export
- **Description**: Native Excel export for all report endpoints with formatting and charts
- **Business Value**: Admins need Excel for institutional reporting and analysis
- **Technical Complexity**: Medium (Excel library integration)
- **Risk**: Low
- **Dependencies**: Report endpoints (RC3)
- **Suggested Effort**: 1-2 days

### FC-08: Audit Trail Export
- **Description**: Export audit logs as CSV/JSON for compliance audits
- **Business Value**: Institutions must demonstrate audit trail to regulators
- **Technical Complexity**: Low (query + CSV/JSON serialization)
- **Risk**: Low
- **Dependencies**: Audit logs (RC3)
- **Suggested Effort**: 1 day

### FC-09: Role-Based Route Guards
- **Description**: Frontend route-level authorization (redirect unauthorized users)
- **Business Value**: Prevents confusion from seeing routes you cannot access
- **Technical Complexity**: Low (extend ProtectedRoute)
- **Risk**: Low
- **Dependencies**: None
- **Suggested Effort**: 0.5 day

### FC-10: Email Service Integration
- **Description**: Connect notification system to real SMTP/SendGrid for email delivery
- **Business Value**: Notifications are currently console-only; production requires real delivery
- **Technical Complexity**: Medium (SMTP client, template rendering, queue management)
- **Risk**: Medium (delivery reliability, rate limiting)
- **Dependencies**: Notification preferences (FC-02)
- **Suggested Effort**: 2-3 days

### FC-11: Safety Module i18n
- **Description**: Complete Arabic/English translation for the Safety module pages
- **Business Value**: RC3 known issue, 85% to 100% coverage
- **Technical Complexity**: Low (string extraction + translation)
- **Risk**: Low
- **Dependencies**: None
- **Suggested Effort**: 0.5 day

## MEDIUM Priority

### FC-12: Application Timeline Visualization
- **Description**: Visual timeline showing status transitions with dates and actors
- **Business Value**: Users quickly understand the application journey
- **Technical Complexity**: Low (timeline component + history API)
- **Risk**: Low
- **Dependencies**: Application history endpoint (RC3)
- **Suggested Effort**: 1 day

### FC-13: Frontend Test Coverage
- **Description**: Unit and integration tests for critical pages, components, and hooks
- **Business Value**: Prevents regressions, enables confident refactoring
- **Technical Complexity**: Medium (test infrastructure + writing tests)
- **Risk**: Low
- **Dependencies**: None
- **Suggested Effort**: 5-7 days

### FC-14: E2E Test Coverage
- **Description**: Playwright tests for critical user flows (login, submit application, review, approve)
- **Business Value**: End-to-end validation of production workflows
- **Technical Complexity**: Medium (Playwright setup + test writing)
- **Risk**: Low
- **Dependencies**: None
- **Suggested Effort**: 3-5 days

### FC-15: Database Migration Framework
- **Description**: Proper up/down migration system replacing ad-hoc seed files
- **Business Value**: Safe schema changes, rollback capability, dry-run support
- **Technical Complexity**: Medium (migration tool integration)
- **Risk**: Medium (migration from existing seeds)
- **Dependencies**: None
- **Suggested Effort**: 2-3 days

### FC-16: Per-Section Error Boundaries
- **Description**: Add ErrorBoundary wrappers around major page sections
- **Business Value**: Prevents a single component crash from taking down an entire page
- **Technical Complexity**: Low (wrap existing sections)
- **Risk**: Low
- **Dependencies**: None
- **Suggested Effort**: 0.5 day

### FC-17: API Response Caching
- **Description**: Add ETag/Cache-Control headers for GET endpoints
- **Business Value**: Reduces server load, improves perceived performance
- **Technical Complexity**: Low (middleware + hash computation)
- **Risk**: Low
- **Dependencies**: None
- **Suggested Effort**: 1 day

### FC-18: SDK Harmonization
- **Description**: Migrate components that call the API directly to use the SDK
- **Business Value**: Consistent API contract, easier maintenance
- **Technical Complexity**: Low (replace api.get with SDK calls)
- **Risk**: Low
- **Dependencies**: None
- **Suggested Effort**: 0.5 day

### FC-19: Orphan Page Cleanup
- **Description**: Route or remove the orphan EmailSettings page
- **Business Value**: Code hygiene, prevent confusion
- **Technical Complexity**: Trivial
- **Risk**: None
- **Dependencies**: None
- **Suggested Effort**: 0.25 day

### FC-20: Scheduled Reports
- **Description**: Background job to generate and email reports on schedule
- **Business Value**: Stakeholders receive regular reports without manual action
- **Technical Complexity**: Medium (cron scheduler + email integration)
- **Risk**: Medium
- **Dependencies**: Email service (FC-10)
- **Suggested Effort**: 2 days

## LOW Priority

### FC-21: Workflow Templates
- **Description**: Support multiple workflow definitions beyond APP_REVIEW_V1
- **Business Value**: Accommodates different research types and institutional policies
- **Technical Complexity**: High (workflow engine generalization)
- **Risk**: High (breaks existing workflow assumptions)
- **Dependencies**: None
- **Suggested Effort**: 5-7 days

### FC-22: Dashboard Widget Customization
- **Description**: Allow users to configure dashboard layout and widgets
- **Business Value**: Personalized experience for different roles
- **Technical Complexity**: Medium (widget registry, layout persistence)
- **Risk**: Low
- **Dependencies**: None
- **Suggested Effort**: 3-4 days

### FC-23: Certificate Verification UI
- **Description**: Public verification page with QR code scanning
- **Business Value**: External parties can verify certificate authenticity
- **Technical Complexity**: Low (public endpoint + QR generation)
- **Risk**: Low
- **Dependencies**: Certificate verification endpoint (RC3)
- **Suggested Effort**: 1 day

### FC-24: Multi-Institution Architecture
- **Description**: Institution isolation via tenant_id column and RLS policies
- **Business Value**: Enables SaaS deployment model
- **Technical Complexity**: Very High (schema-wide changes)
- **Risk**: High (fundamental architectural change)
- **Dependencies**: None
- **Suggested Effort**: 15-20 days

### FC-25: Mobile Responsive Optimization
- **Description**: Optimize all pages for mobile/tablet viewports
- **Business Value**: Committee members review on mobile devices
- **Technical Complexity**: Medium (responsive breakpoints, touch interactions)
- **Risk**: Low
- **Dependencies**: None
- **Suggested Effort**: 3-5 days

---

# 4. Architecture Review

## Backend

### Current Assessment: GOOD

The three-layer architecture (Routes -> Services -> Repositories) is consistently applied. The RLS context propagation via AsyncLocalStorage is well-implemented. The dual query path (lightweight for reads, transactional for writes) is a good pattern.

### Recommended Improvements

| # | Improvement | Justification | Effort |
|---|------------|---------------|--------|
| B-01 | Split monolithic schemas.ts | Large single file with 50+ schemas is unmaintainable. Split per module. | Low |
| B-02 | Extract sanitizeFilename() to shared utility | Duplicated in evidence and document routes | Trivial |
| B-03 | Use async error wrapper | Eliminate try/catch boilerplate from route handlers | Low |
| B-04 | Use AuthenticatedRequest type | Replace untyped request casts with typed access | Low |
| B-05 | Fix non-RESTful update patterns | Some modules use POST for updates instead of PUT | Trivial |
| B-06 | Add DI container | Manual service/repository wiring in template module is fragile | Medium |

### Anti-Patterns to Address

1. **Direct query() in route files**: Several route files bypass the service/repository layer
2. **Error handling verbosity**: Route handlers have identical try/catch blocks
3. **Unified request typing**: ~100+ places use untyped request access

## Frontend

### Current Assessment: GOOD

React 19 + TanStack Query 5 provides solid server state management. The SDK layer is clean and comprehensive. i18n coverage is strong (85%). Lazy loading is applied to all pages.

### Recommended Improvements

| # | Improvement | Justification | Effort |
|---|------------|---------------|--------|
| F-01 | Add per-section ErrorBoundaries | Single crash takes down the entire page | Low |
| F-02 | Harmonize SDK usage | Some components bypass SDK | Trivial |
| F-03 | Remove orphan page | Dead code | Trivial |
| F-04 | Add role-based route guards | Prevent unauthorized route access | Low |
| F-05 | Sanitize template HTML output | XSS risk in dangerouslySetInnerHTML | Low |
| F-06 | Modularize route definitions | Centralized route tree could be split by module | Medium |

## Database

### Current Assessment: GOOD

15 schemas provide excellent domain isolation. 291 RLS policies enforce access control. 80 tables have soft delete. 6 standard audit columns on transaction tables.

### Recommended Improvements

| # | Improvement | Justification | Effort |
|---|------------|---------------|--------|
| D-01 | Adopt migration framework | Ad-hoc seed files have no rollback capability | Medium |
| D-02 | Align canonical schema with seeds | Root DDL files, canonical directory, and seeds may diverge | Medium |
| D-03 | Add database health monitoring | Connection pool stats, query performance metrics | Low |
| D-04 | Implement connection pool tuning | Fixed connections may not suit all deployment sizes | Low |

## Workflow Engine

### Current Assessment: GOOD

Single workflow definition (APP_REVIEW_V1) with 14 states and 32 transitions. Terminal state handling is correct (RULE 11). Idempotent init function.

### Recommended Improvements

| # | Improvement | Justification | Effort |
|---|------------|---------------|--------|
| W-01 | Add SLA enforcement | SLA columns exist but are unused | Medium |
| W-02 | Add workflow event hooks | No way to trigger actions on state transitions | Medium |
| W-03 | Support multiple workflow definitions | Accommodate different research types | High |

## Notification Engine

### Current Assessment: FUNCTIONAL

SSE streams work. Notification creation works. Email/SMS/push are console-only.

### Recommended Improvements

| # | Improvement | Justification | Effort |
|---|------------|---------------|--------|
| N-01 | Integrate real email delivery | Production requires actual email sending | Medium |
| N-02 | Add notification preferences UI | Table exists, no user interface | Low |
| N-03 | Add notification queue | Handle high-volume notification bursts | Medium |

## Template Engine

### Current Assessment: EXCELLENT

Full lifecycle (5 states), variable resolution, preview/render, snapshots, rollback, module integration. Security: FunctionRegistry with blocklist.

### Recommended Improvements

| # | Improvement | Justification | Effort |
|---|------------|---------------|--------|
| T-01 | Add template version diffing | Visual comparison between versions | Medium |
| T-02 | Add template usage analytics | Track which templates are used most | Low |

## Reporting

### Current Assessment: FUNCTIONAL

Report endpoints, CSV export available, dashboard stats.

### Recommended Improvements

| # | Improvement | Justification | Effort |
|---|------------|---------------|--------|
| R-01 | Add PDF export | Stakeholders need PDF reports | High |
| R-02 | Add Excel export | Admins need Excel for analysis | Medium |
| R-03 | Add report scheduling | Automated delivery reduces manual work | Medium |

## Security

### Current Assessment: GOOD

JWT auth, RBAC, RLS, rate limiting, input validation. Shell injection vector (PB-002) fixed.

### Recommended Improvements

| # | Improvement | Justification | Effort |
|---|------------|---------------|--------|
| S-01 | Move access token to httpOnly cookie | sessionStorage vulnerable to XSS | Medium |
| S-02 | Sanitize template HTML output | dangerouslySetInnerHTML XSS risk | Low |
| S-03 | Add CSP headers in dev | Consistent security posture | Low |
| S-04 | SSE header-based auth | Avoid token in URL logs | Medium |

## Caching

### Current Assessment: NONE

No caching layer exists. All requests hit the database.

### Recommended Improvements

| # | Improvement | Justification | Effort |
|---|------------|---------------|--------|
| C-01 | Add ETag/Cache-Control headers | Reduce unnecessary data transfer | Low |
| C-02 | Assess Redis need | May not be needed at current scale | Assessment |

## File Storage

### Current Assessment: LOCAL FILESYSTEM

Files stored on local disk via uploads directory.

### Recommended Improvements

| # | Improvement | Justification | Effort |
|---|------------|---------------|--------|
| FS-01 | Add S3/MinIO option | Production deployments need scalable storage | Medium |
| FS-02 | Add file cleanup job | Orphaned files accumulate | Low |

## Audit

### Current Assessment: EXCELLENT

6 standard columns, audit triggers, old_values/new_values JSONB, field-level tracking.

### Recommended Improvements

| # | Improvement | Justification | Effort |
|---|------------|---------------|--------|
| A-01 | Add audit trail export | Compliance requires exportable audit logs | Low |
| A-02 | Add audit log retention policy | Unbounded growth | Medium |

## API

### Current Assessment: GOOD

299 routes, consistent response format, validation, authorization.

### Recommended Improvements

| # | Improvement | Justification | Effort |
|---|------------|---------------|--------|
| API-01 | Generate OpenAPI from code | Keep spec in sync with implementation | Medium |
| API-02 | Add API versioning strategy | Plan for future breaking changes | Low |

## SDK

### Current Assessment: GOOD

18 domain files, manually written, comprehensive coverage.

### Recommended Improvements

| # | Improvement | Justification | Effort |
|---|------------|---------------|--------|
| SDK-01 | Add SDK tests | Validate SDK contract matches backend | Medium |
| SDK-02 | Add retry/timeout configuration | Production resilience | Low |

---

# 5. Technical Debt Register

## Known Issues (from RC3)

| # | Issue | Severity | Source | Target |
|---|-------|----------|--------|--------|
| TD-01 | Safety pages missing i18n | LOW | E5-05 | RC4 |
| TD-02 | Frontend build time trending up | LOW | E5-09 | Monitor |
| TD-03 | 3 backend test failures (pre-existing) | LOW | E0-03 | RC4 |
| TD-04 | 1 frontend test failure (pre-existing) | LOW | E0-03 | RC4 |
| TD-05 | 1 table count discrepancy (baseline) | LOW | E5-01 | Document |
| TD-06 | Routes without authorize (public reads) | INFO | E5-03 | No action |

## Deferred Improvements

| # | Item | Severity | Source | Target |
|---|------|----------|--------|--------|
| TD-07 | Split monolithic schemas.ts | MEDIUM | Architecture Review | RC4 |
| TD-08 | Extract shared sanitizeFilename() | LOW | Architecture Review | RC4 |
| TD-09 | Use async error wrapper | MEDIUM | Architecture Review | RC4 |
| TD-10 | Use AuthenticatedRequest type | MEDIUM | Architecture Review | RC4 |
| TD-11 | Fix non-RESTful update patterns | LOW | Architecture Review | RC4 |
| TD-12 | Add per-section ErrorBoundaries | MEDIUM | Architecture Review | RC4 |
| TD-13 | Harmonize SDK usage | MEDIUM | Architecture Review | RC4 |
| TD-14 | Remove orphan page | LOW | Architecture Review | RC4 |
| TD-15 | Sanitize template HTML output (XSS risk) | HIGH | Architecture Review | RC4 |
| TD-16 | Add role-based route guards | HIGH | Architecture Review | RC4 |
| TD-17 | Move access token to httpOnly cookie | HIGH | Architecture Review | RC4 |
| TD-18 | SSE header-based auth | MEDIUM | Architecture Review | RC4 |

## Developer Experience

| # | Item | Severity | Source | Target |
|---|------|----------|--------|--------|
| TD-19 | No migration framework | HIGH | Database Analysis | RC4 |
| TD-20 | No API contract testing | MEDIUM | Architecture Review | RC4 |
| TD-21 | ESLint warnings (frontend) | LOW | E3-04 | Monitor |
| TD-22 | No code coverage tooling configured | MEDIUM | E0-07 | RC4 |

## Testing

| # | Item | Severity | Source | Target |
|---|------|----------|--------|--------|
| TD-23 | Frontend: minimal test files for 48+ pages | HIGH | Frontend Analysis | RC4 |
| TD-24 | Frontend: no component tests | HIGH | Frontend Analysis | RC4 |
| TD-25 | Frontend: no hook tests | MEDIUM | Frontend Analysis | RC4 |
| TD-26 | Frontend: no SDK tests | MEDIUM | Frontend Analysis | RC4 |
| TD-27 | Backend: test failures (match baseline) | LOW | E0-03 | RC4 |
| TD-28 | Backend: skipped tests | LOW | E0-03 | Investigate |

## Documentation

| # | Item | Severity | Source | Target |
|---|------|----------|--------|--------|
| TD-29 | No inline code comments | LOW | Code Analysis | Post-RC4 |
| TD-30 | No CHANGELOG.md | MEDIUM | Missing | RC4 |

## Performance

| # | Item | Severity | Source | Target |
|---|------|----------|--------|--------|
| TD-31 | Frontend build time trending up | LOW | E5-09 | Monitor |
| TD-32 | No API response caching | MEDIUM | Architecture Review | RC4 |
| TD-33 | No database query performance monitoring | MEDIUM | Architecture Review | RC4 |

## Maintainability

| # | Item | Severity | Source | Target |
|---|------|----------|--------|--------|
| TD-34 | Manual service/repository wiring | MEDIUM | Architecture Review | RC4 |
| TD-35 | Root DDL files may diverge from canonical | MEDIUM | Database Analysis | RC4 |
| TD-36 | Seed files with no rollback capability | HIGH | Database Analysis | RC4 |

---

# 6. RC4 Work Breakdown Structure

## Release Strategy

**RC4 Recommendation: MEDIUM RELEASE**

Rationale: RC4 addresses operational maturity gaps (PDF generation, real notifications, test coverage, migration framework) without fundamental architectural changes. It builds on RC3's solid foundation to make the system production-ready.

## Epic Overview

| Epic | Name | Tasks | Estimated Effort | Priority |
|------|------|-------|-----------------|----------|
| Epic 0 | Foundation | 4 | 2-3 days | CRITICAL |
| Epic 1 | Certificate & Template Engine | 5 | 5-7 days | CRITICAL |
| Epic 2 | Notification & SLA | 4 | 4-6 days | HIGH |
| Epic 3 | Reporting & Export | 4 | 4-6 days | HIGH |
| Epic 4 | UX & Security Hardening | 6 | 4-5 days | HIGH |
| Epic 5 | Testing & Quality | 5 | 8-12 days | HIGH |
| Epic 6 | Database & DevOps | 3 | 3-4 days | MEDIUM |
| **Total** | | **31** | **30-43 days** | |

## Epic 0: Foundation

| Task | Description | Dependencies | Effort | Acceptance Criteria |
|------|-------------|-------------|--------|---------------------|
| E0-01 | Adopt migration framework (golang-migrate or similar) | None | 1 day | Migration CLI works, up/down/redo/status commands functional |
| E0-02 | Create CHANGELOG.md | None | 0.5 day | Documents RC1-RC3 changes, Keep a Changelog format |
| E0-03 | Fix backend test failures | None | 0.5 day | All backend tests pass, 0 failures |
| E0-04 | Configure vitest coverage tooling | None | 0.5 day | npm run coverage produces HTML report |

## Epic 1: Certificate & Template Engine

| Task | Description | Dependencies | Effort | Acceptance Criteria |
|------|-------------|-------------|--------|---------------------|
| E1-01 | PDF certificate generation (backend) | None | 2 days | GET /certificates/:id/pdf returns valid PDF |
| E1-02 | PDF certificate download (frontend) | E1-01 | 0.5 day | Download button on certificate detail page |
| E1-03 | Application template pre-fill | None | 2 days | Create application from template with pre-filled fields |
| E1-04 | Meeting pack PDF generation | E1-01 | 2 days | Generate combined PDF with agenda + reviews + documents |
| E1-05 | Certificate verification QR code | E1-01 | 0.5 day | QR code on PDF links to public verification page |

## Epic 2: Notification & SLA

| Task | Description | Dependencies | Effort | Acceptance Criteria |
|------|-------------|-------------|--------|---------------------|
| E2-01 | Email service integration (SMTP) | None | 2 days | Emails delivered via configured SMTP server |
| E2-02 | Notification preferences UI | None | 1 day | Users can toggle email/SMS/push per event type |
| E2-03 | SLA tracking & escalation | None | 2 days | Alerts sent when SLA approaching/past deadline |
| E2-04 | Move SSE auth to headers | None | 0.5 day | SSE connections use Authorization header, not query string |

## Epic 3: Reporting & Export

| Task | Description | Dependencies | Effort | Acceptance Criteria |
|------|-------------|-------------|--------|---------------------|
| E3-01 | Excel export (backend) | None | 1 day | Export endpoints support ?format=xlsx returns .xlsx |
| E3-02 | PDF report export | None | 2 days | PDF reports with charts and tables |
| E3-03 | Audit trail CSV/JSON export | None | 1 day | GET /admin/audit-log/export returns CSV or JSON |
| E3-04 | Scheduled reports (cron) | E2-01 | 2 days | Reports generated and emailed on schedule |

## Epic 4: UX & Security Hardening

| Task | Description | Dependencies | Effort | Acceptance Criteria |
|------|-------------|-------------|--------|---------------------|
| E4-01 | Safety module i18n completion | None | 0.5 day | 100% of pages have i18n |
| E4-02 | Role-based route guards | None | 0.5 day | Unauthorized routes redirect to /unauthorized |
| E4-03 | Per-section ErrorBoundaries | None | 0.5 day | Component crash shows fallback, not page crash |
| E4-04 | Sanitize template HTML output | None | 0.5 day | No XSS vectors in template preview/render |
| E4-05 | SDK harmonization | None | 0.5 day | All components use SDK, no direct api.get |
| E4-06 | Orphan page cleanup | None | 0.25 day | Orphan page removed or routed |

## Epic 5: Testing & Quality

| Task | Description | Dependencies | Effort | Acceptance Criteria |
|------|-------------|-------------|--------|---------------------|
| E5-01 | Frontend unit tests (critical pages) | E0-04 | 3 days | Coverage for Login, Dashboard, Application CRUD, Committee |
| E5-02 | Frontend component tests | E0-04 | 2 days | Tests for DataTable, StatusBadge, ConditionsPanel, DocumentUpload |
| E5-03 | Frontend hook tests | E0-04 | 1 day | Tests for usePermission, useNotificationStream |
| E5-04 | E2E tests (critical flows) | None | 3 days | Playwright tests for login, submit, review, approve flows |
| E5-05 | API contract tests | None | 2 days | Validate SDK matches backend OpenAPI spec |

## Epic 6: Database & DevOps

| Task | Description | Dependencies | Effort | Acceptance Criteria |
|------|-------------|-------------|--------|---------------------|
| E6-01 | Migrate existing seeds to migration format | E0-01 | 2 days | All seeds converted to up/down migrations |
| E6-02 | Align canonical schema with migrations | E6-01 | 1 day | database/canonical/ matches migration output |
| E6-03 | Add API response caching (ETag) | None | 1 day | GET endpoints return ETag header, 304 on match |

## Gates

| Gate | Criteria | After Epic |
|------|----------|------------|
| G0 | Foundation complete, tests pass, coverage configured | Epic 0 |
| G1 | PDF generation working, template engine integrated | Epic 1 |
| G2 | Email delivery working, SLA alerts functional | Epic 2 |
| G3 | Export endpoints functional, reports schedulable | Epic 3 |
| G4 | i18n 100%, security hardened, no XSS vectors | Epic 4 |
| G5 | Test coverage thresholds met, E2E passing | Epic 5 |
| G6 | Migrations working, canonical aligned, caching active | Epic 6 |
| G7 | Final certification (scorecard 20/20) | All |

## Release Criteria

| # | Criterion | Target |
|---|-----------|--------|
| 1 | All tests pass | 0 failures |
| 2 | Frontend test coverage | >50% statements |
| 3 | E2E critical flows | 100% pass |
| 4 | npm audit high+critical | 0 |
| 5 | i18n coverage | 100% |
| 6 | XSS vectors | 0 |
| 7 | PDF generation | Working |
| 8 | Email delivery | Working |
| 9 | Migration framework | Operational |
| 10 | Build time | <10s |

---

# 7. Risk Register

| # | Risk | Probability | Impact | Mitigation | Owner |
|---|------|-------------|--------|------------|-------|
| R-01 | PDF library complexity (fonts, RTL, Arabic) | Medium | High | Use battle-tested library (PDFKit or puppeteer); prototype early | Dev Lead |
| R-02 | Email delivery reliability (spam filters, rate limits) | Medium | High | Use established provider (SendGrid); implement retry queue | Dev Lead |
| R-03 | Migration framework breaks existing seeds | Medium | High | Dry-run all migrations against test DB before committing | DBA |
| R-04 | Test coverage takes longer than estimated | High | Medium | Prioritize critical paths; defer non-critical tests to RC5 | QA Lead |
| R-05 | Template engine XSS via dangerouslySetInnerHTML | Low | Critical | Sanitize HTML server-side before rendering; use DOMPurify | Security |
| R-06 | SLA escalation generates excessive notifications | Medium | Medium | Implement notification deduplication and rate limiting | Dev Lead |
| R-07 | Meeting pack PDF too large for email | Low | Medium | Implement pagination; offer download link instead of attachment | Dev Lead |
| R-08 | Multi-institution scope creep | Medium | High | Strict scope control; architecture prep only, no implementation | PM |
| R-09 | RBAC route guards conflict with existing navigation | Low | Medium | Test all role combinations; fallback to current behavior | Frontend Lead |
| R-10 | Frontend test infrastructure setup takes longer | Medium | Low | Use existing vitest + testing-library setup; minimal config | Frontend Lead |

---

# 8. ADR Candidates

These architectural decisions should be documented as ADRs before implementation begins:

| # | Decision | Context | Options | Recommended |
|---|----------|---------|---------|-------------|
| ADR-01 | PDF Generation Library | Need PDF output for certificates and reports | PDFKit, Puppeteer, pdf-lib, WeasyPrint | PDFKit (lightweight, no browser dependency) |
| ADR-02 | Email Delivery Provider | Need SMTP/email for notifications | SendGrid, AWS SES, Nodemailer, Mailgun | Nodemailer + institutional SMTP (no external dependency) |
| ADR-03 | Migration Framework | Replace ad-hoc seed files | golang-migrate, Knex, TypeORM, raw SQL | golang-migrate (language-agnostic, simple, proven) |
| ADR-04 | HTML Sanitization | Template preview renders user-influenced HTML | DOMPurify, sanitize-html, iframe sandbox | DOMPurify (industry standard, well-maintained) |
| ADR-05 | Test Coverage Threshold | Determine minimum coverage for RC4 | 30%, 50%, 70%, 80% | 50% statements (realistic for RC4, increase in RC5) |
| ADR-06 | Access Token Storage | Move from sessionStorage | httpOnly cookie, in-memory, secure sessionStorage | httpOnly cookie (matches refresh token pattern) |
| ADR-07 | Caching Strategy | Add response caching | ETag, Cache-Control, Redis, in-memory | ETag + Cache-Control headers (simplest, no infra) |
| ADR-08 | Scheduled Job Runner | Need background job execution | node-cron, bull/bullmq, agenda, custom | node-cron (simplest for single-server deployment) |

---

# 9. Release Strategy

## Recommendation: MEDIUM RELEASE

### Why Medium (Not Small)

RC4 addresses **operational maturity** gaps that prevent real-world use:
- No PDF output (researchers cannot get certificates)
- No real email delivery (notifications are console-only)
- No test coverage (regression risk is high)
- No migration framework (schema changes are risky)

These are not enhancements — they are **production blockers**. A small release would not address them.

### Why Medium (Not Major)

RC4 does NOT require:
- Schema redesign
- API breaking changes
- New database schemas
- Architecture overhaul
- Multi-tenancy

The existing architecture (three-layer, RLS, workflow engine) is sound. RC4 fills operational gaps within the existing structure.

### Timeline Estimate

| Phase | Duration | Parallelizable |
|-------|----------|---------------|
| Epic 0: Foundation | 2-3 days | Yes |
| Epic 1: Certificate & Templates | 5-7 days | Partially |
| Epic 2: Notification & SLA | 4-6 days | Yes |
| Epic 3: Reporting & Export | 4-6 days | Yes |
| Epic 4: UX & Security | 4-5 days | Yes |
| Epic 5: Testing | 8-12 days | Partially |
| Epic 6: Database & DevOps | 3-4 days | Partially |
| **Total** | **30-43 days** | |

With parallelism: **15-20 working days** (3-4 weeks)

### Milestone Schedule

| Milestone | Target | Gate |
|-----------|--------|------|
| M1: Foundation | Day 3 | G0 |
| M2: Core Features | Day 10 | G1 + G2 |
| M3: Export & UX | Day 14 | G3 + G4 |
| M4: Quality | Day 18 | G5 + G6 |
| M5: Release | Day 20 | G7 |

---

# 10. Recommendation

## READY FOR RC4 IMPLEMENTATION

**Rationale:**

1. **Clear scope**: 31 tasks across 7 epics, all with acceptance criteria
2. **Manageable risk**: No architectural changes, fills operational gaps within existing structure
3. **Measurable gates**: 8 gates with specific pass criteria
4. **Realistic timeline**: 15-20 working days with parallelism
5. **Strong foundation**: RC3's certified architecture provides solid base

**Conditions for starting RC4:**

1. ADR-01 (PDF library) decided before Epic 1 begins
2. ADR-02 (email provider) decided before Epic 2 begins
3. ADR-03 (migration framework) decided before Epic 6 begins
4. E0-03 (fix backend test failures) completed first to ensure clean baseline

**Next Steps:**

1. Review and approve this architecture package
2. Decide on ADR candidates (01, 02, 03)
3. Create RC4 branch from v1.0.0-rc3
4. Begin Epic 0: Foundation

---

*End of RC4 Architecture Package*
