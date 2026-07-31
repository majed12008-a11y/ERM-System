# Changelog

All notable changes to the Ethics ERM System are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/).

---

## [1.0.0-rc2] - 2026-07-16

### Overview

RC2 completes the Template Engine infrastructure and achieves full functional closure. Two defects discovered during the certification sprint were resolved. All 18 certification gates pass. 11 unique evidence screenshots captured with MD5 verification.

### Added

#### Template Engine (Complete)
- Template CRUD with 12 pre-seeded templates across 12 categories
- Template versioning (semantic versioning: major.minor.patch)
- Template lifecycle: DRAFT → REVIEW → APPROVED (with submit, approve, reject, deprecate, archive actions)
- Template preview (Handlebars rendering with variable substitution)
- Template render (production-quality output with snapshot creation)
- Template snapshot verification (content-hash integrity check)
- Template snapshot storage and retrieval
- Template rollback to previous versions
- Template render history tracking
- Template usage statistics
- Template variable definitions and validation
- Template variable inspector (interactive variable panel in UI)
- Template categories management
- Template event mappings
- Template partials (reusable template fragments)
- Template localization support
- Template document generation service
- Template audit trail (full lifecycle event logging)
- Template RLS policies (INSERT, SELECT, UPDATE, DELETE with governance rules)
- Template database integrity checks
- Template version detail page (metadata, approval history, snapshot history, variable inspector)
- Template library page with category filtering
- Template create/edit workflow
- Template preview page with live variable editing
- Template live preview hook (`useTemplateLivePreview`)
- Document generation section in application detail (Preview/Generate buttons)
- Document preview component
- Template variable inspector component

#### Workflow Improvements
- Application workflow states: DRAFT, SUBMITTED, UNDER_REVIEW, APPROVED, REJECTED, WITHDRAWN, ARCHIVED
- Available transitions endpoint with `current_state` + `transitions` array response
- Terminal state governance (REJECTED, WITHDRAWN, ARCHIVED are true terminals)
- Workflow RLS fixes for INSERT, UPDATE operations
- Idempotent workflow initialization

#### Security Improvements
- Argon2 password hashing (with Scrypt fallback during investigation)
- JWT authentication with access + refresh tokens
- Row-Level Security (RLS) on all 174+ tables via `app.user_id` context propagation
- AsyncLocalStorage context propagation for per-request RLS
- Rate limiting on all authentication endpoints
- CORS configuration
- Helmet security headers
- Data encryption support (AES-256 for national_id, passport_number)
- Registration RLS fix for PostgreSQL 18.3 Windows bug (SECURITY DEFINER function)
- Documents INSERT RLS policy

#### Reporting Improvements
- Advanced reporting service with PDF and Excel export
- Reporting SDK with typed API client
- Application flow analysis
- Project health dashboard

#### Communication
- Internal messaging system
- Notification channels (email, SMS configuration)
- Notification preferences
- Notification source tracking
- Notification logs with RLS

#### Accreditation
- Accreditation cycles with status lifecycle
- Cycle assessments and scoring
- Application conditions management
- Evidence submission and verification
- Accreditation workflow and RLS

#### Backup
- Backup service with configurable destinations
- Database dump/restore operations
- Backup security validation

#### Documentation
- RC2 Functional Closure Report
- RC2 Certification Audit (10 deliverables, independent auditor)
- Template user journeys (admin, applicant, auditor)
- Template verification matrix
- Production readiness report
- Production cutover checklist
- Deployment hardening contract
- Architecture freeze documentation
- Database canonicalization report
- Dataset architecture documentation
- Disaster recovery runbook
- Incident response runbook
- Release gates document
- Release rollback playbook
- Phase 10 roadmap
- Production backlog
- SDK automation plan
- Regression matrix

### Fixed
- `transitions.find is not a function` — ApplicationDetail crash due to workflow API returning `{ current_state, transitions }` object instead of bare array. Fixed by extracting `.transitions` property.
- Workflow SDK contract mismatch — `getAvailableTransitions` typed as `SuccessResponse<WorkflowTransition[]>` but backend returns `SuccessResponse<{ current_state, transitions }>`. Added `AvailableTransitionsResponse` interface.
- `useRef` initial value warning — React 19 requires explicit initial value for `useRef`. Fixed in `useTemplateLivePreview.ts`.
- Unused imports in `CycleDetail.tsx` causing TypeScript errors.
- `template-version.routes.ts` performance regression — `findAll()` method added to `TemplateVersionRepository` to avoid loading all versions.
- Registration RLS failure on PostgreSQL 18.3 Windows — `FOR INSERT WITH CHECK` policies fail silently. Fixed with `SECURITY DEFINER` function.
- Documents INSERT RLS policy missing — Added `documents_insert_policy` with entity ownership verification.

---

## [1.0.0-rc1.2] - 2026-07-14

### Overview

RC1.2 establishes the integration testing baseline. All 13 backend modules verified. Committee module completed. Seed data expanded for comprehensive testing.

### Added
- Application conditions schema and RLS
- ConditionRepository with soft-delete isolation and governance compliance
- Committee module completion (members, meetings, reviews, voting)
- Expanded seed data for all domains
- Integration test suite
- E2E test scripts (PowerShell)
- CI/CD pipeline (GitHub Actions)

### Fixed
- Registration RLS (SECURITY DEFINER approach)
- Committee module RLS policies

---

## [1.0.0-rc1] - 2026-07-08

### Overview

RC1 is the initial release candidate with all 13 core domain modules operational.

### Added
- **Security**: User registration, login, JWT auth, role-based access, email verification, password reset
- **Applications**: CRUD, workflow management, evidence management, certificates
- **Documents**: Upload, lifecycle, management
- **Committees**: Members, meeting scheduling, review forms, voting
- **Communication**: Internal messaging, notifications
- **Monitoring**: Dashboard metrics, audit logging, system monitoring
- **Reference Data**: Institutions, categories, lookup tables
- **Projects**: CRUD, management
- **Safety**: Adverse events, ethics risk assessment, informed consent
- **Workflow**: State machine engine, transitions, governance rules
- **Reporting**: PDF/Excel export, advanced queries
- **Admin**: Backup management, system administration
- **Integration**: External system connectors

### Architecture
- Three-layer architecture: Routes → Services → Repositories
- Express 5 + TypeScript (CommonJS)
- React 19 + Vite 8 + Tailwind 4
- PostgreSQL 18 with 174+ RLS policies
- Hand-written TypeScript SDK (no codegen)
- Zod validation on all inputs
- Arabic (RTL) and English (LTR) i18n

---

## [Unreleased]

### Environment
- Node.js 22+ / 25+ (development)
- PostgreSQL 18+ (with Windows-specific workarounds)
- Docker support (docker-compose.yml)
