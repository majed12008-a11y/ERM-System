# Template User Journeys

> **Phase 8 — Template Experience Completion Sprint**
> Comprehensive user journey documentation for the Ethics ERM template system.

---

## Table of Contents

1. [Journey 1: Administrator Creates and Manages a Template](#journey-1-administrator-creates-and-manages-a-template)
2. [Journey 2: Committee Member Generates Documents for a Meeting](#journey-2-committee-member-generates-documents-for-a-meeting)
3. [Journey 3: Researcher Submits Application and Generates Related Documents](#journey-3-researcher-submits-application-and-generates-related-documents)
4. [Journey 4: Administrator Verifies Template Rendering via Variable Inspector](#journey-4-administrator-verifies-template-rendering-via-variable-inspector)
5. [Prerequisites](#prerequisites)
6. [Error Scenarios](#error-scenarios)
7. [Permissions Matrix](#permissions-matrix)
8. [Screenshots Locations](#screenshots-locations)
9. [Testing Checklist](#testing-checklist)

---

## Journey 1: Administrator Creates and Manages a Template

**Actor:** Admin (`template.admin` or `template.create` permission)
**Duration:** ~15 minutes
**Frequency:** Occasional — template authoring/management

### Narrative

As an administrator, I need to create a new document template with Handlebars variables, validate its syntax, preview the rendered output, and store it for committee and researcher use throughout the application lifecycle.

### Steps

| # | Step | URL / Route | Component | Notes |
|---|------|-------------|-----------|-------|
| 1 | Navigate to Template Library | `/templates` | `TemplateLibrary.tsx` | Sidebar navigation or direct URL |
| 2 | View existing templates in grid/table with search and category filter | `/templates` | `TemplateLibrary.tsx:168` | Grid layout; 3-column on large screens |
| 3 | Use search input to filter templates by name or code | `/templates` | `TemplateLibrary.tsx:98-103` | Debounced search; filters client-side from API response |
| 4 | Filter by category dropdown | `/templates` | `TemplateLibrary.tsx:107-116` | Populated from `templates.listCategories()` |
| 5 | Filter by version status (DRAFT/REVIEW/APPROVED/DEPRECATED/ARCHIVED) | `/templates` | `TemplateLibrary.tsx:117-130` | Maps `latestVersionMap` to filter |
| 6 | Click "Create Template" button (top-right) | → `/templates/create` | `TemplateLibrary.tsx:91` | Only visible if user has `template.create` permission |
| 7 | Fill in template metadata form | `/templates/create` | `TemplateCreate.tsx` | Fields: code, name_ar (required), name_en, description, category_id (required), engine, default_locale, tags |
| 8 | Submit the form | → `/templates/:id` | `TemplateCreate.tsx:80-84` | Validates required fields; navigates to detail on success |
| 9 | View Template Detail page | `/templates/:id` | `TemplateDetail.tsx` | Shows metadata card, version list, usage stats |
| 10 | Click "Create Version" button | → `/templates/:id/versions/create` | `TemplateDetail.tsx:433` | Navigates to version creation form |
| 11 | Enter version number (e.g., "1.0.0") | `/templates/:id/versions/create` | `TemplateVersionCreate.tsx:150-157` | Required field |
| 12 | Enter template content in Arabic (RTL textarea) with Handlebars variables | `/templates/:id/versions/create` | `TemplateVersionCreate.tsx:185-192` | Uses `{{variable_name}}` syntax |
| 13 | Optionally enter English content | `/templates/:id/versions/create` | `TemplateVersionCreate.tsx:195-202` | For bilingual templates |
| 14 | System auto-detects variables from content using regex `/\{\{(\w+)\}\}/g` | — | `TemplateVersionCreate.tsx:23-26` | Displays detected variables count |
| 15 | Add variable definitions manually (code, type, required, default_value) | `/templates/:id/versions/create` | `TemplateVersionCreate.tsx:211-263` | Click "Add Variable" button for each |
| 16 | Enter change summary | `/templates/:id/versions/create` | `TemplateVersionCreate.tsx:159-170` | Optional but recommended |
| 17 | Toggle "Show Preview" button (top-right of form) | — | `TemplateVersionCreate.tsx:118-127` | Splits view: editor left, preview right |
| 18 | Enter test variable values in preview panel | — | `TemplateVersionCreate.tsx:286-303` | Fields auto-generated from detected variables |
| 19 | See live HTML output in split view with highlighted variables | — | `TemplateVersionCreate.tsx:308-317` | Variables shown as yellow-highlighted `{{var}}` placeholders |
| 20 | Submit the version | → `/templates/versions/:versionId` | `TemplateVersionCreate.tsx:266-274` | Version created in DRAFT status |
| 21 | View version detail page | `/templates/versions/:versionId` | `TemplateVersionDetail.tsx` | Shows metadata, content, variables, action buttons |
| 22 | Click "Variable Inspector" button in sidebar | — | `TemplateVersionDetail.tsx:576-579` | Opens inline inspector panel |
| 23 | Inspect variables: source type, resolver key, default value, resolved value, status | — | `TemplateVariableInspector.tsx:203-280` | Table with columns: Variable, Source, Resolver, Default, Value, Status |
| 24 | Navigate back to Template Detail to see version list with status badges | `/templates/:id` | `TemplateDetail.tsx:429-501` | Status badges: DRAFT (slate), REVIEW (amber), APPROVED (green), etc. |
| 25 | Click "Clone Template" button | — | `TemplateDetail.tsx:351-357` | Opens clone dialog with pre-filled code/name fields |
| 26 | Fill in clone details (code, name_ar, name_en) and confirm | — | `TemplateDetail.tsx:598-624` | Creates new template with same category/engine/tags |
| 27 | Click "Export" to download template version as JSON | — | `TemplateDetail.tsx:160-179` | Downloads `{code}-v{version}.json` file |
| 28 | Click "Import" to upload a previously exported JSON | — | `TemplateDetail.tsx:181-213` | Creates new version from JSON file |

### Expected Outcome

A new template version created with Handlebars variables, validated, previewed, and stored in **DRAFT** status. Template metadata, version content, variable definitions, and change summary are all persisted. The template is now available for the approval workflow (DRAFT → REVIEW → APPROVED).

### Post-Conditions

- Template visible in library grid at `/templates`
- Version listed in template detail with DRAFT badge
- Variable inspector available for admin verification
- Export JSON available for backup/transfer
- Template ready for submission into approval workflow

---

## Journey 2: Committee Member Generates Documents for a Meeting

**Actor:** Committee member (`committee.view` or `committee.manage`)
**Duration:** ~5 minutes
**Frequency:** Per meeting — routine

### Narrative

As a committee member preparing for a meeting, I need to generate agenda and minutes documents from pre-approved templates, with meeting data automatically resolved into the template variables.

### Steps

| # | Step | URL / Route | Component | Notes |
|---|------|-------------|-----------|-------|
| 1 | Navigate to Committee section | `/committees` | — | Sidebar navigation |
| 2 | Select a specific committee | `/committees/:id` | `CommitteeDetail.tsx` | Shows committee info, members, meetings |
| 3 | Locate the meeting list and select a meeting | `/committees/:id/meetings/:meetingId` | `MeetingDetail.tsx` | Shows meeting agenda, attendees, documents |
| 4 | Locate the "Document Generation" section on the meeting detail page | `/committees/:id/meetings/:meetingId` | `MeetingDetail.tsx` | Bordered section with `FileText` icon header |
| 5 | See available actions: "Generate Agenda", "Generate Minutes" | — | `DocumentGenerationSection.tsx:63-91` | Two action buttons with Preview (outline) + Generate (primary) pairs |
| 6 | Click "Preview" button for "Generate Agenda" | — | `DocumentGenerationSection.tsx:24-38` | Calls `templates.preview()` with meeting variables |
| 7 | Preview modal opens showing rendered HTML agenda | — | `DocumentGenerationSection.tsx:96-105` | Full-screen modal with rendered document; close via × button |
| 8 | Review the generated content: meeting title, date, members, agenda items | — | — | Variables resolved from meeting entity: `meetingDate`, `chairpersonName`, `committeeNameAr`, `meetingAgenda`, `institutionNameAr`, `today` |
| 9 | Close the preview modal | — | `DocumentGenerationSection.tsx:100` | Click × or click outside |
| 10 | Click "Generate" button for "Generate Agenda" | — | `DocumentGenerationSection.tsx:41-55` | Calls `templates.render()` which creates a snapshot |
| 11 | Toast notification: "Document generated successfully (snapshotHash)" | — | `DocumentGenerationSection.tsx:49` | Shows first 8 chars of snapshot hash |
| 12 | Document now available in the Documents section of the meeting | — | — | Tracked with audit trail in `template_outputs` |
| 13 | Repeat steps 5-12 for "Generate Minutes" | — | `meeting-minutes` template | Same flow, different template with additional `meetingDecisions` variable |

### Template Variable Resolution (Meeting)

The system resolves the following variables automatically from the meeting entity:

| Variable | Source | Example Value |
|----------|--------|---------------|
| `meetingDate` | `meeting.date` | "2026-07-15" |
| `chairpersonName` | `committee.chair.fullName` | "Dr. Ahmed Al-Rashid" |
| `committeeNameAr` | `committee.nameAr` | "لجنة الأخلاقيات البحثية" |
| `meetingAgenda` | `meeting.agenda` | "Review of protocol #2024-001..." |
| `institutionNameAr` | `institution.nameAr` | "جامعة الملك سعود" |
| `today` | Current date (context) | "2026-07-15" |

### Expected Outcome

Meeting agenda and minutes documents generated from pre-approved templates with correct variable resolution. Each generation creates a snapshot record in `template_snapshots` for audit trail purposes.

### Post-Conditions

- Generated documents appear in meeting documents section
- Snapshot records created with rendered HTML, hash, and correlation ID
- Render history visible in template version detail (Render History tab)
- Template `usage_count` incremented on the template record

---

## Journey 3: Researcher Submits Application and Generates Related Documents

**Actor:** Researcher (applicant role)
**Duration:** ~10 minutes total (across application lifecycle)
**Frequency:** Per application — at key workflow transitions

### Narrative

As a researcher managing my ethics application, I need to generate various official documents at different stages of the review process — submission confirmation, approval letters, conditional approval letters, and more — each pre-filled with my application data.

### Steps

| # | Step | URL / Route | Component | Notes |
|---|------|-------------|-----------|-------|
| 1 | Navigate to Applications section | `/applications` | — | Sidebar navigation |
| 2 | Open an application detail page | `/applications/:id` | `Applications/Detail.tsx` | Shows application info, workflow status, documents |
| 3 | Application is in `AWAITING_CONDITIONS` status (or relevant workflow state) | — | — | Status badge shown in header |
| 4 | Scroll to the "Document Generation" section | `/applications/:id` | `Applications/Detail.tsx` | 9 available actions (see matrix below) |
| 5 | Click "Preview" for "Submit Application" action | — | `DocumentGenerationSection.tsx:24-38` | Preview modal opens |
| 6 | Review submission confirmation letter | — | — | Shows: `applicationReferenceNumber`, `projectTitleAr`, `piFullName`, `institutionNameAr`, `today` |
| 7 | Close preview, click "Generate" | — | `DocumentGenerationSection.tsx:41-55` | Document created, toast notification shown |
| 8 | Later, after committee review — click "Preview" for "Approval Letter" | — | — | Shows: `decisionNumber`, `decisionDate`, `projectTitleAr`, `accreditationStatus`, etc. |
| 9 | Review approval document | — | — | 16 variables resolved from application + committee + institution entities |
| 10 | Click "Generate" to create the approval document | — | — | Snapshot created, document stored |
| 11 | When conditions are assigned — click "Preview" for "Conditional Approval" | — | — | Shows: `applicationReferenceNumber`, `workflowCurrentState`, `workflowTransitionedAt`, `chairpersonName`, etc. |
| 12 | Review and generate conditional approval letter | — | — | 13 variables resolved |
| 13 | Generate consent form via "Consent Form" action | — | — | `consent-standard` template: 13 variables including `consentType`, `consentStatus`, `consentSignedDate` |
| 14 | Generate risk assessment via "Risk Assessment" action | — | — | `risk-assessment` template: 10 variables including `riskOverallScore`, `riskLevel`, `riskMitigationPlan` |
| 15 | Generate safety report via "Safety Report" action | — | — | `safety-report` template: 12 variables including `safetyEventType`, `safetyEventDate`, etc. |
| 16 | All documents tracked in the Documents section with full audit trail | `/applications/:id` | — | Each generation recorded with timestamp, user, snapshot hash |

### Document Actions Available on Application Detail

| # | Action Key | Template Code | Variables | Status |
|---|-----------|---------------|-----------|--------|
| 1 | application.submission | `protocol-full` | 11 | ✅ Wired |
| 2 | application.receipt | `protocol-full` | 11 | ✅ Wired |
| 3 | application.approval | `certificate-approval` | 16 | ✅ Wired |
| 4 | application.conditional | `condition-letter` | 13 | ✅ Wired |
| 5 | application.rejection | `decision-standard` | 11 | ✅ Wired |
| 6 | application.withdrawal | `protocol-full` | 11 | ✅ Wired |
| 7 | consent.form | `consent-standard` | 13 | ✅ Wired |
| 8 | safety.report | `safety-report` | 12 | ✅ Wired |
| 9 | risk.assessment | `risk-assessment` | 10 | ✅ Wired |

### Template Variable Resolution (Application)

Variables are resolved from multiple entity types via the `TemplateResolverService`:

| Entity | Variables | Source Path |
|--------|-----------|-------------|
| Application | `applicationReferenceNumber`, `applicationCurrentStatus`, `applicationSubmittedAt`, `applicationSubmittedBy`, `applicationType` | `application.*` |
| Project | `projectTitleAr`, `projectTitleEn`, `projectRiskLevel`, `projectFundingSource` | `application.project.*` |
| PI | `piFullName`, `piEmail`, `piPhone` | `application.principalInvestigator.*` |
| Committee | `committeeNameAr`, `committeeNameEn`, `committeeAddress`, `chairpersonName` | `committee.*` |
| Institution | `institutionNameAr`, `institutionNameEn` | `institution.*` |
| Workflow | `workflowCurrentState`, `workflowPreviousState`, `workflowTransitionedAt` | `workflow.*` |
| Decision | `decisionNumber`, `decisionDate`, `decisionResult` | `application.decision.*` |
| Context | `userDisplayName`, `userEmail`, `today`, `currentTime` | Session/request context |

### Expected Outcome

Multiple documents generated throughout the application lifecycle, each with correctly resolved entity data from the application, project, PI, committee, and institution entities. All generations are recorded in the audit trail.

### Post-Conditions

- Documents created and stored in the application's documents section
- Snapshot records created for each generation (stored in `template_snapshots`)
- Template `usage_count` incremented
- Render history visible in template version detail
- Audit trail complete with actor ID, timestamp, and correlation ID

---

## Journey 4: Administrator Verifies Template Rendering via Variable Inspector

**Actor:** Admin (`template.admin` or `template.view`)
**Duration:** ~10 minutes
**Frequency:** Per template version — verification/QA

### Narrative

As an administrator verifying template quality, I need to inspect all variables in a template, test variable resolution with custom values, validate constraints, preview live HTML output, and compare versions to ensure rendering correctness before promoting to APPROVED status.

### Steps

| # | Step | URL / Route | Component | Notes |
|---|------|-------------|-----------|-------|
| 1 | Navigate to Template Library | `/templates` | `TemplateLibrary.tsx` | — |
| 2 | Click a template card to open Template Detail | `/templates/:id` | `TemplateDetail.tsx` | — |
| 3 | Click a specific version row to open Template Version Detail | `/templates/versions/:versionId` | `TemplateVersionDetail.tsx` | — |
| 4 | Click "Variable Inspector" button in the Actions sidebar | — | `TemplateVersionDetail.tsx:576-579` | Only visible for admin users with variable definitions |
| 5 | Inspector panel opens inline below the sidebar | — | `TemplateVersionDetail.tsx:606-623` | Embedded `TemplateVariableInspector` component |
| 6 | Inspector shows all variables defined in the template | — | `TemplateVariableInspector.tsx:198-280` | Merged from variable definitions + content-extracted variables |
| 7 | Review each variable row: name, source type, resolver key, default value, resolved value, status | — | `TemplateVariableInspector.tsx:219-279` | Table columns: Variable, Source, Resolver, Default, Value, Status |
| 8 | Check status badges: Resolved (green), Using Default (amber), Missing (red), Static (slate) | — | `TemplateVariableInspector.tsx:42-84` | Status determined by `getStatus()` function |
| 9 | Click "Test Resolve" button (admin only) | — | `TemplateVariableInspector.tsx:183-189` | Toggles test input column in the table |
| 10 | Enter test values for each variable in the "Test Input" column | — | `TemplateVariableInspector.tsx:267-276` | Input fields appear for each variable row |
| 11 | See rendered output updating below the table | — | `TemplateVariableInspector.tsx:285-291` | Dark-themed code block showing resolved template |
| 12 | Click "Validate All" button | — | `TemplateVariableInspector.tsx:190-195` | Runs validation against all variable constraints |
| 13 | All variables show validation status (checkmark or error message) | — | `TemplateVariableInspector.tsx:124-150` | Checks: required (non-empty), minLength, maxLength, pattern |
| 14 | Navigate to the "Compare Versions" tab | `/templates/versions/:versionId` | `TemplateVersionDetail.tsx:282-288` | Tab with GitCompare icon |
| 15 | Select a version to compare against from the dropdown | — | `TemplateVersionDetail.tsx:490-504` | Lists all other versions for the same template |
| 16 | View diff table: highlighted rows where values differ | — | `TemplateVersionDetail.tsx:215-222` | Amber background on rows where `a !== b` |
| 17 | Open the "Open Preview" toggle (top-right of tabs) | — | `TemplateVersionDetail.tsx:289-296` | Toggles live preview sidebar panel |
| 18 | Enter test variable values in the preview sidebar | — | `TemplateVersionDetail.tsx:636-656` | Auto-detected variables shown as input fields |
| 19 | See live HTML preview updating in real-time via debounced API calls | — | `useTemplateLivePreview.ts` | 500ms debounce; calls `templates.preview()` endpoint |
| 20 | Validation status shown: ✅ Valid (green) or ❌ Invalid (red) with error messages | — | `TemplateVersionDetail.tsx:661-678` | Real-time validation feedback |
| 21 | Click "Preview" button to navigate to full preview page | `/templates/preview/:templateCode` | `TemplatePreview.tsx` | Full-page preview with static/live mode toggle |
| 22 | Toggle to "Live" mode | — | `TemplatePreview.tsx:172-178` | Switches from static (button-triggered) to live (auto-updating) |
| 23 | Edit template content in the code editor | — | `TemplatePreview.tsx:211-218` | Dark-themed textarea; content changes trigger auto-validation |
| 24 | See validation errors/warnings inline | — | `TemplatePreview.tsx:182-198` | Status badge above the editor |
| 25 | See live HTML preview updating as you type | — | `TemplatePreview.tsx:337-352` | Right panel shows rendered HTML |
| 26 | Variables auto-detected and input fields shown | — | `TemplatePreview.tsx:229-253` | From `extractVariablesFromContent()` |
| 27 | Switch between Arabic and English locale | — | `TemplatePreview.tsx:150-161` | Globe icon selector; affects which content variant is rendered |
| 28 | View render metadata: resolution time, cache hit, variable count | — | `TemplatePreview.tsx:344-350` | Shown below the rendered HTML in static mode |
| 29 | Navigate to "Snapshots" tab to verify snapshot history | `/templates/versions/:versionId` | `TemplateVersionDetail.tsx:447-480` | Shows renderedAt, renderedBy, locale, hash, correlationId |
| 30 | Click "Verify" on a snapshot to validate its hash integrity | — | `TemplateVersionDetail.tsx:750-761` | Calls `templates.verifySnapshot()` API |
| 31 | Export template version as JSON for backup/transfer | — | `TemplateDetail.tsx:160-179` | Downloads `{code}-v{version}.json` |

### Expected Outcome

Full verification of template rendering pipeline: variable resolution, validation constraints, live preview, version comparison, and snapshot integrity are all confirmed working. Template is ready for promotion from DRAFT → REVIEW → APPROVED.

### Post-Conditions

- All variables validated against constraints
- Live preview confirms correct HTML rendering
- Version comparison shows intended differences
- Snapshot verification confirms hash integrity
- Template ready for approval workflow

---

## Prerequisites

### Journey 1: Administrator Creates and Manages a Template

| Prerequisite | Description |
|--------------|-------------|
| Database seeded | All seed files (00-33+) applied; `template_categories` table populated with 12 categories |
| User role | `SUPER_ADMIN`, `SYS_ADMIN`, or `ETHICS_ADMIN` role required for `template.create` permission |
| Backend running | Express server on port 8080 (`npm run dev` from backend/) |
| Frontend running | Vite dev server on port 5173 (`npm run dev` from frontend/) |
| Template categories exist | At least one category in `template_categories` table (seeded via `56-template-categories-variables.sql`) |

### Journey 2: Committee Member Generates Documents for a Meeting

| Prerequisite | Description |
|--------------|-------------|
| Templates seeded | `meeting-minutes` template exists with APPROVED status (or DRAFT for testing) |
| Committee exists | At least one committee with members and a meeting record |
| User role | `committee.view` or `committee.manage` permission |
| Backend + Frontend running | Standard development setup |

### Journey 3: Researcher Submits Application and Generates Related Documents

| Prerequisite | Description |
|--------------|-------------|
| Templates seeded | 9 application-related templates seeded (protocol-full, certificate-approval, condition-letter, decision-standard, consent-standard, safety-report, risk-assessment) |
| Application exists | An application in `AWAITING_CONDITIONS` or relevant workflow state |
| User role | Applicant/Researcher role with access to application detail |
| Document generation section wired | `DocumentGenerationSection` component imported and configured in `Applications/Detail.tsx` |

### Journey 4: Administrator Verifies Template Rendering via Variable Inspector

| Prerequisite | Description |
|--------------|-------------|
| Template with variables | At least one template version with variable definitions and Handlebars variables in content |
| Admin role | `SUPER_ADMIN`, `SYS_ADMIN`, or `ETHICS_ADMIN` required for Variable Inspector access |
| Template content with `{{variables}}` | Content must contain Handlebars variable syntax for auto-detection |

---

## Error Scenarios

### Validation Errors

| Scenario | Error Message | Component | Recovery |
|----------|--------------|-----------|----------|
| Missing required field on template creation | "Code is required" / "Name (AR) is required" / "Category is required" | `TemplateCreate.tsx:72-77` | Red border on field; error text below input |
| Missing required field on version creation | "Version number is required" / "Content is required" | `TemplateVersionCreate.tsx:76-82` | Red border on field; error text below |
| Duplicate template code | Backend returns 409 Conflict | `TemplateCreate.tsx:66` | Toast error: backend error message |
| Invalid JSON on import | "Import file is invalid" | `TemplateDetail.tsx:186-197` | Toast error; file input reset |
| Missing version on export | "No versions available" | `TemplateDetail.tsx:162-164` | Toast error; no download triggered |

### Template Rendering Errors

| Scenario | Error Message | Component | Recovery |
|----------|--------------|-----------|----------|
| Template not found | Backend returns 404 | `useTemplateLivePreview.ts:65-71` | Error displayed in preview panel |
| Variable resolution failure | "Preview failed" | `useTemplateLivePreview.ts:67-70` | Red error message in preview |
| Invalid Handlebars syntax | Backend validation error | `TemplatePreview.tsx:96-98` | Toast: "Preview failed"; validation status shows ❌ Invalid |
| Network/API failure | Axios error | `DocumentGenerationSection.tsx:34-36` | Toast: "Generation failed" |
| Missing required variable at render time | Backend returns 400 | — | Error message indicates which variable is missing |

### API/Network Errors

| Scenario | Error Message | Component | Recovery |
|----------|--------------|-----------|----------|
| Backend unavailable | Network error | Any query/mutation | Retry button shown; `refetch()` available |
| Query timeout | React Query retry | `TemplateLibrary.tsx:133-141` | Error state with Retry button and RefreshCw icon |
| Permission denied | 403 Forbidden | SDK interceptor | Redirect to unauthorized page |
| JWT expired | 401 Unauthorized | `api/client.ts` interceptor | Redirect to login |

### State Transition Errors

| Scenario | Error Message | Component | Recovery |
|----------|--------------|-----------|----------|
| Submit non-DRAFT version | Backend returns 400 | `TemplateDetail.tsx:84-91` | Toast error; version status unchanged |
| Approve non-REVIEW version | Backend returns 400 | `TemplateDetail.tsx:93-100` | Toast error; version status unchanged |
| Reject without reason | Backend returns 400 | `TemplateDetail.tsx:102-111` | Toast error; rejection requires reason field |
| Deprecate non-APPROVED version | Backend returns 400 | `TemplateDetail.tsx:113-120` | Toast error |

---

## Permissions Matrix

### Template Management Permissions

| Action | SUPER_ADMIN | SYS_ADMIN | ETHICS_ADMIN | COMMITTEE_ADMIN | USER |
|--------|:-----------:|:---------:|:------------:|:---------------:|:----:|
| View Template Library | ✅ | ✅ | ✅ | ✅ | ✅ |
| View Template Detail | ✅ | ✅ | ✅ | ✅ | ✅ |
| View Template Version | ✅ | ✅ | ✅ | ✅ | ✅ |
| Create Template | ✅ | ✅ | ✅ | ❌ | ❌ |
| Create Version | ✅ | ✅ | ✅ | ❌ | ❌ |
| Edit Version (DRAFT) | ✅ | ✅ | ✅ | ❌ | ❌ |
| Submit for Review | ✅ | ✅ | ✅ | ❌ | ❌ |
| Approve Version | ✅ | ✅ | ✅ | ❌ | ❌ |
| Reject Version | ✅ | ✅ | ✅ | ❌ | ❌ |
| Deprecate Version | ✅ | ✅ | ✅ | ❌ | ❌ |
| Archive Version | ✅ | ✅ | ✅ | ❌ | ❌ |
| Clone Template | ✅ | ✅ | ✅ | ❌ | ❌ |
| Export Template | ✅ | ✅ | ✅ | ✅ | ❌ |
| Import Template | ✅ | ✅ | ✅ | ❌ | ❌ |
| Variable Inspector | ✅ | ✅ | ✅ | ❌ | ❌ |
| Preview Template | ✅ | ✅ | ✅ | ✅ | ✅ |
| Live Preview | ✅ | ✅ | ✅ | ❌ | ❌ |
| Render (Generate Document) | ✅ | ✅ | ✅ | ✅ | ✅ |
| Verify Snapshot | ✅ | ✅ | ✅ | ✅ | ❌ |
| Toggle Active/Inactive | ✅ | ✅ | ✅ | ❌ | ❌ |
| Duplicate Version | ✅ | ✅ | ✅ | ❌ | ❌ |
| Compare Versions | ✅ | ✅ | ✅ | ✅ | ✅ |
| View Render History | ✅ | ✅ | ✅ | ✅ | ✅ |

### Document Generation Permissions

| Module Key | Allowed Roles | Business Page |
|-----------|--------------|---------------|
| application.* | Applicant (own), Admin, Committee | Applications/Detail.tsx |
| meeting.* | Committee member | Committee/MeetingDetail.tsx |
| committee.* | Committee member | Committee/CommitteeDetail.tsx |
| consent.form | Applicant (own), Admin | Applications/Detail.tsx |
| safety.report | Applicant (own), Admin | Applications/Detail.tsx |
| risk.assessment | Applicant (own), Admin | Applications/Detail.tsx |
| report.annual | Admin, Committee | Reports/ReportsPage.tsx |
| accreditation.* | Admin | Accreditation/CycleDetail.tsx (⚠️ not wired) |
| notification.* | System | Notifications.tsx (⚠️ not wired) |
| email.* | Committee | Messages/MessagesPage.tsx (⚠️ not wired) |

---

## Screenshots Locations

For documentation and training materials, capture screenshots at the following locations:

| # | Screenshot | Route / Component | What to Capture |
|---|-----------|-------------------|-----------------|
| 1 | Template Library | `/templates` | Full grid view with search and filters; 6+ template cards visible |
| 2 | Template Create Form | `/templates/create` | Complete form with all fields filled; category dropdown open |
| 3 | Template Detail Page | `/templates/:id` | Metadata card, version list with status badges, action buttons |
| 4 | Version Create — Split View | `/templates/:id/versions/create` | Split view with editor on left and preview on right |
| 5 | Version Detail — Content | `/templates/versions/:versionId` | Code content displayed, variable definitions listed |
| 6 | Variable Inspector — Full | `TemplateVariableInspector.tsx` | Inspector table with all columns visible; test panel open |
| 7 | Variable Inspector — Test Resolve | `TemplateVariableInspector.tsx` | Test inputs filled, rendered output shown below |
| 8 | Version Comparison | `/templates/versions/:versionId` (Compare tab) | Side-by-side diff table with highlighted differences |
| 9 | Live Preview Panel | `TemplateVersionDetail.tsx` sidebar | Preview panel with variable inputs and rendered HTML |
| 10 | Template Preview — Live Mode | `/templates/preview/:templateCode` | Full-page preview in live mode with editing and auto-update |
| 11 | Document Generation Section | `DocumentGenerationSection.tsx` | Action buttons with Preview and Generate pairs |
| 12 | Preview Modal | `DocumentGenerationSection.tsx:96` | Full-screen modal showing rendered document |
| 13 | Clone Template Dialog | `TemplateDetail.tsx:598` | Dialog with code/name fields pre-filled |
| 14 | Export/Import Flow | `TemplateDetail.tsx:160-213` | Export button click; Import file selection |
| 15 | Approval Workflow Buttons | `TemplateVersionDetail.tsx:538-579` | Status-dependent action buttons in sidebar |

---

## Testing Checklist

### Journey 1: Administrator Creates and Manages a Template

- [ ] Navigate to `/templates` — library loads with template grid
- [ ] Search by template name — results filter correctly
- [ ] Filter by category — only matching templates shown
- [ ] Filter by status — DRAFT/REVIEW/APPROVED/DEPRECATED/ARCHIVED filter works
- [ ] Click "Create Template" — navigates to `/templates/create`
- [ ] Submit empty form — validation errors shown for required fields
- [ ] Fill all required fields and submit — navigates to template detail
- [ ] Click "Create Version" — navigates to version creation form
- [ ] Enter content with `{{variables}}` — variables auto-detected
- [ ] Toggle "Show Preview" — split view appears
- [ ] Enter test values — preview updates in real-time
- [ ] Submit version — version created with DRAFT status
- [ ] View version detail — content, metadata, variables displayed
- [ ] Open Variable Inspector — all variables listed with status
- [ ] Clone template — dialog opens with pre-filled fields; confirm creates new template
- [ ] Export — JSON file downloads
- [ ] Import — file upload creates new version

### Journey 2: Committee Member Generates Documents for a Meeting

- [ ] Navigate to meeting detail page
- [ ] "Document Generation" section visible with action buttons
- [ ] Click "Preview" for Agenda — modal opens with rendered HTML
- [ ] Close preview modal
- [ ] Click "Generate" for Agenda — toast notification; document created
- [ ] Click "Preview" for Minutes — modal opens with rendered HTML
- [ ] Click "Generate" for Minutes — toast notification; document created
- [ ] Verify snapshot records created in render history

### Journey 3: Researcher Submits Application and Generates Related Documents

- [ ] Navigate to application detail page
- [ ] "Document Generation" section shows 9 actions
- [ ] Generate "Submit Application" — preview → generate → success
- [ ] Generate "Approval Letter" — preview → generate → success
- [ ] Generate "Conditional Approval" — preview → generate → success
- [ ] Generate "Consent Form" — preview → generate → success
- [ ] Generate "Risk Assessment" — preview → generate → success
- [ ] Generate "Safety Report" — preview → generate → success
- [ ] All generated documents appear in documents section

### Journey 4: Administrator Verifies Template Rendering via Variable Inspector

- [ ] Navigate to template version detail
- [ ] Open Variable Inspector — variables table rendered
- [ ] Verify status badges: Resolved/Using Default/Missing/Static
- [ ] Click "Test Resolve" — test input column appears
- [ ] Enter test values — rendered output updates below
- [ ] Click "Validate All" — validation results shown for each variable
- [ ] Open Compare Versions tab — version dropdown populated
- [ ] Select comparison version — diff table rendered with highlights
- [ ] Toggle live preview — sidebar panel appears
- [ ] Edit variables in preview — HTML updates in real-time
- [ ] Verify validation status badge (Valid/Invalid)
- [ ] Navigate to full preview page (`/templates/preview/:code`)
- [ ] Switch between Static and Live modes
- [ ] Edit content in Live mode — auto-validation runs
- [ ] Switch locale (AR/EN) — content variant changes
- [ ] Export template as JSON — file downloads

### Cross-Cutting Checks

- [ ] RLS policies enforced — non-admin users cannot access Variable Inspector
- [ ] Audit trail complete — all mutations logged in `template_audit` table
- [ ] Snapshot integrity — `verifySnapshot()` returns valid for generated documents
- [ ] Cache behavior — second render of same content/version shows `cacheHit: true`
- [ ] Bilingual support — Arabic (RTL) and English (LTR) rendering correct
- [ ] Status workflow — DRAFT → REVIEW → APPROVED → DEPRECATED → ARCHIVED transitions work
- [ ] Error handling — all API failures show appropriate toast messages
- [ ] Loading states — skeleton animations shown during data fetch
- [ ] Empty states — appropriate messages shown when no data available

---

## Appendix: Architecture Reference

### Frontend File Map

| File | Purpose |
|------|---------|
| `frontend/src/pages/Templates/TemplateLibrary.tsx` | Template grid view with search, filter, create button |
| `frontend/src/pages/Templates/TemplateDetail.tsx` | Template metadata, version list, clone/export/import, variable inspector dialog |
| `frontend/src/pages/Templates/TemplateCreate.tsx` | Template creation form |
| `frontend/src/pages/Templates/TemplateVersionCreate.tsx` | Version creation with content editor, variable definitions, split preview |
| `frontend/src/pages/Templates/TemplateVersionDetail.tsx` | Version detail with tabs: info, history, snapshots, compare; live preview sidebar |
| `frontend/src/pages/Templates/TemplatePreview.tsx` | Full-page template preview with static/live mode toggle |
| `frontend/src/components/DocumentGenerationSection.tsx` | Reusable document generation component with Preview + Generate buttons |
| `frontend/src/components/TemplateVariableInspector.tsx` | Variable inspector table with test resolve, validate all, rendered output |
| `frontend/src/hooks/useTemplateLivePreview.ts` | Hook for debounced content changes, auto-validate, auto-render via API |
| `frontend/src/sdk/domains/templates.sdk.ts` | TypeScript API client for all template endpoints |

### Backend File Map

| File | Purpose |
|------|---------|
| `backend/src/modules/templates/index.ts` | Module registration — wires all template sub-routes and services |
| `backend/src/modules/templates/template.routes.ts` | CRUD routes for templates |
| `backend/src/modules/templates/template-version.routes.ts` | Version CRUD + lifecycle transitions |
| `backend/src/modules/templates/template-preview.routes.ts` | Preview endpoint (validate + render, no snapshot) |
| `backend/src/modules/templates/template-render.routes.ts` | Render endpoint (validate + render + snapshot) |
| `backend/src/modules/templates/template-history.routes.ts` | Audit history for template versions |
| `backend/src/modules/templates/template-snapshot.routes.ts` | Snapshot retrieval and verification |
| `backend/src/modules/templates/template-rollback.routes.ts` | Version rollback functionality |
| `backend/src/modules/templates/template-categories.routes.ts` | Category CRUD |
| `backend/src/modules/templates/template-document.routes.ts` | Document generation via MODULE_DOCUMENTS keys |
| `backend/src/services/template-document.service.ts` | Bridge service mapping module keys to template codes |
| `backend/src/services/template-engine.service.ts` | Handlebars rendering engine |
| `backend/src/services/template-resolver.service.ts` | Variable resolution from entity data |
| `backend/src/services/template-integration.service.ts` | Integration layer: render + snapshot + version management |
| `backend/src/services/template-snapshot.service.ts` | Snapshot creation and verification |
| `backend/src/services/template-version-lifecycle.service.ts` | Status transitions (DRAFT → REVIEW → APPROVED, etc.) |

### Backend API Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/v1/templates` | List all templates (paginated, filterable) |
| GET | `/api/v1/templates/:id` | Get single template |
| POST | `/api/v1/templates` | Create template |
| PUT | `/api/v1/templates/:id` | Update template |
| DELETE | `/api/v1/templates/:id` | Delete template |
| GET | `/api/v1/templates/versions` | List versions (filterable by template_id, status, code) |
| GET | `/api/v1/templates/versions/:id` | Get single version |
| POST | `/api/v1/templates/versions` | Create version |
| PUT | `/api/v1/templates/versions/:id` | Update version |
| POST | `/api/v1/templates/versions/:id/submit` | Submit for review |
| POST | `/api/v1/templates/versions/:id/approve` | Approve version |
| POST | `/api/v1/templates/versions/:id/reject` | Reject version |
| POST | `/api/v1/templates/versions/:id/deprecate` | Deprecate version |
| POST | `/api/v1/templates/versions/:id/archive` | Archive version |
| POST | `/api/v1/templates/template-preview` | Preview render (no snapshot) |
| POST | `/api/v1/templates/template-render` | Render + snapshot |
| GET | `/api/v1/templates/template-history` | Get audit history |
| GET | `/api/v1/templates/template-snapshots` | Get snapshots |
| GET | `/api/v1/templates/template-snapshots/:hash` | Get snapshot by hash |
| POST | `/api/v1/templates/template-snapshots/verify` | Verify snapshot integrity |
| POST | `/api/v1/templates/template-rollback` | Rollback to previous version |
| GET | `/api/v1/templates/categories` | List categories |
| GET | `/api/v1/templates/categories/:id` | Get single category |
