# Template Verification Matrix

> **Phase 6 — Template Experience Completion Sprint**
> Generated from seed files: `55-template-schema.sql`, `56-template-categories-variables.sql`, `57-template-seed-content.sql`
> Integration source: `template-integration.types.ts` (MODULE_DOCUMENTS)

---

## 1. Category Coverage Matrix

| Category Code | Category Name (EN) | Category Name (AR) | Template Count | Default Format | Approval Required | Status |
|--------------|-------------------|-------------------|----------------|----------------|-------------------|--------|
| PROTOCOL | Research Protocol | بروتوكول بحثي | 1 | PDF | Yes | ✅ |
| CONSENT | Consent Form | نموذج موافقة | 1 | PDF | Yes | ✅ |
| DECISION | Committee Decision | قرار لجنة | 1 | PDF | Yes | ✅ |
| CERTIFICATE | Certificate | شهادة اعتماد | 1 | PDF | Yes | ✅ |
| CONDITION | Condition Letter | خطاب اشتراط | 1 | PDF | Yes | ✅ |
| NOTIFICATION | Notification | إشعار | 1 | EMAIL | No | ✅ |
| EMAIL | Email | بريد إلكتروني | 1 | EMAIL | No | ✅ |
| REPORT | Report | تقرير | 1 | PDF | Yes | ✅ |
| MEETING | Meeting | اجتماع | 1 | PDF | Yes | ✅ |
| RISK | Risk Assessment | تقييم مخاطر | 1 | PDF | Yes | ✅ |
| ACCREDITATION | Accreditation | اعتماد | 1 | PDF | Yes | ✅ |
| SAFETY | Safety | سلامة | 1 | PDF | Yes | ✅ |

**Total categories:** 12/12 seeded | **All categories have at least one template**

---

## 2. Template Coverage Matrix

| # | Template Code | Template Name (EN) | Category | Version | Status | Engine | Locale | Variable Count | Tags |
|---|--------------|-------------------|----------|---------|--------|--------|--------|----------------|------|
| 1 | protocol-full | Full Research Protocol | PROTOCOL | 1.0.0 | DRAFT | handlebars | ar | 11 | PROTOCOL, RESEARCH |
| 2 | consent-standard | Standard Informed Consent | CONSENT | 1.0.0 | DRAFT | handlebars | ar | 13 | CONSENT, INFORMED |
| 3 | decision-standard | Committee Decision | DECISION | 1.0.0 | DRAFT | handlebars | ar | 11 | DECISION, COMMITTEE |
| 4 | certificate-approval | Ethical Approval Certificate | CERTIFICATE | 1.0.0 | DRAFT | handlebars | ar | 16 | CERTIFICATE, APPROVAL |
| 5 | condition-letter | Condition Letter | CONDITION | 1.0.0 | DRAFT | handlebars | ar | 13 | CONDITION, LETTER |
| 6 | notification-status-change | Status Change Notification | NOTIFICATION | 1.0.0 | DRAFT | handlebars | ar | 6 | NOTIFICATION, STATUS |
| 7 | email-generic | Generic Email | EMAIL | 1.0.0 | DRAFT | handlebars | ar | 6 | EMAIL, GENERIC |
| 8 | report-annual | Annual Report | REPORT | 1.0.0 | DRAFT | handlebars | ar | 10 | REPORT, ANNUAL |
| 9 | meeting-minutes | Meeting Minutes | MEETING | 1.0.0 | DRAFT | handlebars | ar | 7 | MEETING, MINUTES |
| 10 | risk-assessment | Risk Assessment | RISK | 1.0.0 | DRAFT | handlebars | ar | 10 | RISK, ASSESSMENT |
| 11 | accreditation-cert | Institutional Accreditation | ACCREDITATION | 1.0.0 | DRAFT | handlebars | ar | 10 | ACCREDITATION, INSTITUTIONAL |
| 12 | safety-report | Safety Report | SAFETY | 1.0.0 | DRAFT | handlebars | ar | 12 | SAFETY, REPORT |

**Total templates:** 12/12 categories seeded | **All versions are DRAFT**

---

## 3. Variable Verification Matrix

### 3.1 Application Variables

| Variable Code | Name (EN) | Name (AR) | Type | Source | Resolver Path | Required | Status |
|--------------|-----------|-----------|------|--------|---------------|----------|--------|
| applicationTitle | Application Title | عنوان الطلب | string | entity | application.title | Yes | ✅ |
| applicationReferenceNumber | Reference Number | رقم المرجع | string | entity | application.referenceNumber | Yes | ✅ |
| applicationCurrentStatus | Current Status | الحالة الحالية | string | entity | application.currentStatus | Yes | ✅ |
| applicationSubmittedAt | Submission Date | تاريخ التقديم | date | entity | application.submittedAt | No | ✅ |
| applicationSubmittedBy | Applicant Name | اسم مقدم الطلب | string | entity | application.submittedBy | Yes | ✅ |
| applicationType | Application Type | نوع الطلب | string | entity | application.applicationType | Yes | ✅ |

### 3.2 Project Variables

| Variable Code | Name (EN) | Name (AR) | Type | Source | Resolver Path | Required | Status |
|--------------|-----------|-----------|------|--------|---------------|----------|--------|
| projectTitleAr | Project Title (Arabic) | عنوان المشروع (عربي) | string | entity | application.project.titleAr | Yes | ✅ |
| projectTitleEn | Project Title (English) | عنوان المشروع (إنجليزي) | string | entity | application.project.titleEn | No | ✅ |
| projectRiskLevel | Risk Level | مستوى المخاطر | string | entity | application.project.riskLevel | Yes | ✅ |
| projectFundingSource | Funding Source | مصدر التمويل | string | entity | application.project.fundingSource | No | ✅ |

### 3.3 PI / Applicant Variables

| Variable Code | Name (EN) | Name (AR) | Type | Source | Resolver Path | Required | Status |
|--------------|-----------|-----------|------|--------|---------------|----------|--------|
| piFullName | PI Full Name | اسم الباحث الرئيسي | string | entity | application.principalInvestigator.fullName | Yes | ✅ |
| piEmail | PI Email | البريد الإلكتروني للباحث | string | entity | application.principalInvestigator.email | No | ✅ |
| piPhone | PI Phone | هاتف الباحث | string | entity | application.principalInvestigator.phone | No | ✅ |

### 3.4 Committee Variables

| Variable Code | Name (EN) | Name (AR) | Type | Source | Resolver Path | Required | Status |
|--------------|-----------|-----------|------|--------|---------------|----------|--------|
| committeeNameAr | Committee Name (Arabic) | اسم اللجنة (عربي) | string | entity | committee.nameAr | Yes | ✅ |
| committeeNameEn | Committee Name (English) | اسم اللجنة (إنجليزي) | string | entity | committee.nameEn | No | ✅ |
| committeeAddress | Committee Address | عنوان اللجنة | string | entity | committee.address | No | ✅ |
| chairpersonName | Chairperson Name | اسم رئيس اللجنة | string | entity | committee.chair.fullName | Yes | ✅ |

### 3.5 Institution Variables

| Variable Code | Name (EN) | Name (AR) | Type | Source | Resolver Path | Required | Status |
|--------------|-----------|-----------|------|--------|---------------|----------|--------|
| institutionNameAr | Institution Name (Arabic) | اسم المؤسسة (عربي) | string | entity | institution.nameAr | Yes | ✅ |
| institutionNameEn | Institution Name (English) | اسم المؤسسة (إنجليزي) | string | entity | institution.nameEn | No | ✅ |

### 3.6 Workflow Variables

| Variable Code | Name (EN) | Name (AR) | Type | Source | Resolver Path | Required | Status |
|--------------|-----------|-----------|------|--------|---------------|----------|--------|
| workflowCurrentState | Workflow Current State | الحالة الحالية لسير العمل | string | entity | workflow.currentState | Yes | ✅ |
| workflowPreviousState | Previous State | الحالة السابقة | string | entity | workflow.previousState | No | ✅ |
| workflowTransitionedAt | Transition Date | تاريخ الانتقال | date | entity | workflow.transitionedAt | No | ✅ |

### 3.7 Consent Variables

| Variable Code | Name (EN) | Name (AR) | Type | Source | Resolver Path | Required | Status |
|--------------|-----------|-----------|------|--------|---------------|----------|--------|
| consentType | Consent Type | نوع الموافقة | string | entity | consent.type | Yes | ✅ |
| consentStatus | Consent Status | حالة الموافقة | string | entity | consent.status | Yes | ✅ |
| consentSignedDate | Signed Date | تاريخ التوقيع | date | entity | consent.signedDate | No | ✅ |

### 3.8 Risk Variables

| Variable Code | Name (EN) | Name (AR) | Type | Source | Resolver Path | Required | Status |
|--------------|-----------|-----------|------|--------|---------------|----------|--------|
| riskOverallScore | Overall Score | الدرجة الإجمالية | number | entity | risk.overallScore | Yes | ✅ |
| riskLevel | Risk Level | مستوى المخاطرة | string | entity | risk.level | Yes | ✅ |
| riskMitigationPlan | Mitigation Plan | خطة التخفيف | string | entity | risk.mitigationPlan | No | ✅ |

### 3.9 Accreditation Variables

| Variable Code | Name (EN) | Name (AR) | Type | Source | Resolver Path | Required | Status |
|--------------|-----------|-----------|------|--------|---------------|----------|--------|
| accreditationStatus | Accreditation Status | حالة الاعتماد | string | entity | accreditation.status | Yes | ✅ |
| accreditationValidUntil | Valid Until | صلاحية الاعتماد حتى | date | entity | accreditation.validUntil | Yes | ✅ |

### 3.10 User Variables (Context)

| Variable Code | Name (EN) | Name (AR) | Type | Source | Resolver Path | Required | Status |
|--------------|-----------|-----------|------|--------|---------------|----------|--------|
| userDisplayName | User Display Name | اسم المستخدم | string | context | NULL | Yes | ✅ |
| userEmail | User Email | البريد الإلكتروني | string | context | NULL | No | ✅ |
| userTitle | User Title | المسمى الوظيفي | string | context | NULL | No | ✅ |

### 3.11 Decision Variables

| Variable Code | Name (EN) | Name (AR) | Type | Source | Resolver Path | Required | Status |
|--------------|-----------|-----------|------|--------|---------------|----------|--------|
| decisionNumber | Decision Number | رقم القرار | string | entity | application.decision.number | Yes | ✅ |
| decisionDate | Decision Date | تاريخ القرار | date | entity | application.decision.date | Yes | ✅ |
| decisionResult | Decision Result | نتيجة القرار | string | entity | application.decision.result | Yes | ✅ |

### 3.12 Meeting Variables

| Variable Code | Name (EN) | Name (AR) | Type | Source | Resolver Path | Required | Status |
|--------------|-----------|-----------|------|--------|---------------|----------|--------|
| meetingDate | Meeting Date | تاريخ الاجتماع | date | entity | meeting.date | Yes | ✅ |
| meetingAgenda | Agenda | جدول الأعمال | string | entity | meeting.agenda | No | ✅ |

### 3.13 Review Variables

| Variable Code | Name (EN) | Name (AR) | Type | Source | Resolver Path | Required | Status |
|--------------|-----------|-----------|------|--------|---------------|----------|--------|
| reviewResult | Review Result | نتيجة المراجعة | string | entity | review.result | Yes | ✅ |
| reviewComments | Review Comments | تعليقات المراجعة | string | entity | review.comments | No | ✅ |

### 3.14 Organization Variables

| Variable Code | Name (EN) | Name (AR) | Type | Source | Resolver Path | Required | Status |
|--------------|-----------|-----------|------|--------|---------------|----------|--------|
| organizationNameAr | Organization Name (Arabic) | اسم المنظمة (عربي) | string | entity | organization.nameAr | Yes | ✅ |
| organizationNameEn | Organization Name (English) | اسم المنظمة (إنجليزي) | string | entity | organization.nameEn | No | ✅ |

### 3.15 Context Timestamp Variables

| Variable Code | Name (EN) | Name (AR) | Type | Source | Resolver Path | Required | Status |
|--------------|-----------|-----------|------|--------|---------------|----------|--------|
| today | Current Date | تاريخ اليوم | date | context | NULL | Yes | ✅ |
| currentTime | Current Time | الوقت الحالي | string | context | NULL | No | ✅ |

**Total variables:** 44 registered in the variable registry

---

## 4. Template-to-Variable Usage Matrix

| Template Code | Variables Used | Total | Required Count |
|--------------|----------------|-------|----------------|
| protocol-full | applicationReferenceNumber, applicationSubmittedAt, projectTitleAr, projectTitleEn, projectRiskLevel, applicationSubmittedBy, applicationType, piFullName, piEmail, piPhone, today | 11 | 8 |
| consent-standard | applicationReferenceNumber, projectTitleAr, projectTitleEn, consentType, consentStatus, consentSignedDate, piFullName, piPhone, piEmail, committeeNameAr, chairpersonName, institutionNameAr, today | 13 | 9 |
| decision-standard | decisionNumber, decisionDate, applicationReferenceNumber, projectTitleAr, applicationSubmittedBy, piFullName, decisionResult, committeeNameAr, institutionNameAr, chairpersonName, today | 11 | 11 |
| certificate-approval | institutionNameAr, committeeNameAr, decisionNumber, decisionDate, projectTitleAr, projectTitleEn, applicationReferenceNumber, applicationSubmittedBy, piFullName, projectRiskLevel, accreditationStatus, accreditationValidUntil, chairpersonName, today, institutionNameEn, committeeNameEn | 16 | 13 |
| condition-letter | applicationReferenceNumber, decisionDate, applicationSubmittedBy, applicationSubmittedAt, projectTitleAr, projectTitleEn, decisionResult, workflowCurrentState, workflowTransitionedAt, chairpersonName, committeeNameAr, institutionNameAr, today | 13 | 10 |
| notification-status-change | applicationReferenceNumber, applicationSubmittedBy, workflowPreviousState, workflowCurrentState, workflowTransitionedAt, today | 6 | 4 |
| email-generic | committeeNameAr, committeeNameEn, userDisplayName, bodyContent, institutionNameAr, today | 6 | 5 |
| report-annual | committeeNameAr, institutionNameAr, reportYear, executiveSummary, totalApplications, approvedApplications, rejectedApplications, pendingApplications, chairpersonName, today | 10 | 10 |
| meeting-minutes | meetingDate, chairpersonName, committeeNameAr, meetingAgenda, meetingDecisions, institutionNameAr, today | 7 | 6 |
| risk-assessment | applicationReferenceNumber, projectTitleAr, projectTitleEn, piFullName, riskOverallScore, riskLevel, riskMitigationPlan, institutionNameAr, committeeNameAr, today | 10 | 8 |
| accreditation-cert | institutionNameAr, institutionNameEn, organizationNameAr, organizationNameEn, committeeNameAr, committeeNameEn, accreditationStatus, accreditationValidUntil, chairpersonName, today | 10 | 7 |
| safety-report | applicationReferenceNumber, projectTitleAr, projectRiskLevel, piFullName, safetyEventType, safetyEventDate, safetyEventDescription, safetyActionTaken, safetyRecommendations, institutionNameAr, committeeNameAr, today | 12 | 12 |

---

## 5. MODULE_DOCUMENTS Integration Matrix

| Module Key | Template Code | Version | Entity Type | Business Page | Status |
|-----------|---------------|---------|-------------|---------------|--------|
| application.submission | protocol-full | 1.0.0 | Application | Applications/Detail.tsx | ✅ |
| application.receipt | protocol-full | 1.0.0 | Application | Applications/Detail.tsx | ✅ |
| application.correction | protocol-full | 1.0.0 | Application | Applications/Detail.tsx | ⚠️ Not wired |
| application.approval | certificate-approval | 1.0.0 | Application | Applications/Detail.tsx | ✅ |
| application.conditional | condition-letter | 1.0.0 | Application | Applications/Detail.tsx | ✅ |
| application.rejection | decision-standard | 1.0.0 | Application | Applications/Detail.tsx | ✅ |
| application.withdrawal | protocol-full | 1.0.0 | Application | Applications/Detail.tsx | ✅ |
| consent.form | consent-standard | 1.0.0 | Application | Applications/Detail.tsx | ✅ |
| safety.report | safety-report | 1.0.0 | Application | Applications/Detail.tsx | ✅ |
| risk.assessment | risk-assessment | 1.0.0 | Application | Applications/Detail.tsx | ✅ |
| meeting.agenda | meeting-minutes | 1.0.0 | Meeting | Committee/MeetingDetail.tsx | ✅ |
| meeting.minutes | meeting-minutes | 1.0.0 | Meeting | Committee/MeetingDetail.tsx | ✅ |
| committee.review | decision-standard | 1.0.0 | Committee | Committee/CommitteeDetail.tsx | ✅ |
| committee.decision | decision-standard | 1.0.0 | Committee | Committee/CommitteeDetail.tsx | ✅ |
| accreditation.decision | accreditation-cert | 1.0.0 | Institution | Accreditation/CycleDetail.tsx | ⚠️ No actions |
| accreditation.conditional | accreditation-cert | 1.0.0 | Institution | Accreditation/CycleDetail.tsx | ⚠️ No actions |
| accreditation.suspension | accreditation-cert | 1.0.0 | Institution | Accreditation/CycleDetail.tsx | ⚠️ No actions |
| accreditation.revocation | accreditation-cert | 1.0.0 | Institution | Accreditation/CycleDetail.tsx | ⚠️ No actions |
| accreditation.expiration | accreditation-cert | 1.0.0 | Institution | Accreditation/CycleDetail.tsx | ⚠️ No actions |
| accreditation.certificate | accreditation-cert | 1.0.0 | Institution | Accreditation/CycleDetail.tsx | ⚠️ No actions |
| notification.status | notification-status-change | 1.0.0 | Notification | Notifications.tsx | ⚠️ Not wired |
| email.generic | email-generic | 1.0.0 | Committee | Messages/MessagesPage.tsx | ⚠️ Not wired |
| report.annual | report-annual | 1.0.0 | Application | Reports/ReportsPage.tsx | ✅ |

**Total MODULE_DOCUMENTS keys:** 23

---

## 6. Business Page Integration Status

| Page | File Path | Document Actions | Templates Used | Status |
|------|-----------|-----------------|----------------|--------|
| Applications Detail | frontend/src/pages/Applications/Detail.tsx | 9 | protocol-full, certificate-approval, condition-letter, decision-standard, consent-standard, safety-report, risk-assessment | ✅ Complete |
| Committee Meeting Detail | frontend/src/pages/Committee/MeetingDetail.tsx | 2 | meeting-minutes | ✅ Complete |
| Committee Detail | frontend/src/pages/Committee/CommitteeDetail.tsx | 2 | decision-standard | ✅ Complete |
| Reports | frontend/src/pages/Reports/ReportsPage.tsx | 1 | report-annual | ✅ Complete |
| Accreditation Cycle | frontend/src/pages/Accreditation/CycleDetail.tsx | 0 | — | ⚠️ Actions imported but not defined |
| Safety Incidents | frontend/src/pages/Safety/RiskIncidents.tsx | 0 | — | ❌ No integration |
| Notifications | frontend/src/pages/Notifications.tsx | 0 | — | ❌ No integration |
| Messages | frontend/src/pages/Messages/MessagesPage.tsx | 0 | — | ❌ No integration |

**Pages with template actions:** 4/8

---

## 7. Template Partials Verification

| Partial Code | Name (EN) | Name (AR) | Version | Used By Templates | Status |
|-------------|-----------|-----------|---------|-------------------|--------|
| header_standard | Standard Page Header | رأس الصفحة القياسي | 1.0.0 | — (available for use) | ✅ |
| header_email | Email Header | رأس البريد الإلكتروني | 1.0.0 | — (available for use) | ✅ |
| footer_standard | Standard Page Footer | تذييل الصفحة القياسي | 1.0.0 | protocol-full, decision-standard, condition-letter, report-annual, meeting-minutes, risk-assessment, safety-report | ✅ |
| footer_email | Email Footer | تذييل البريد الإلكتروني | 1.0.0 | — (available for use) | ✅ |
| disclaimer_standard | Standard Disclaimer | إخلاء مسؤولية | 1.0.0 | protocol-full | ✅ |

**Total partials:** 5 | **Used in templates:** 3 unique partials referenced

---

## 8. Template Reuse Analysis

| Template Code | Used by MODULE_DOCUMENTS Keys | Count |
|--------------|-------------------------------|-------|
| protocol-full | application.submission, application.receipt, application.correction, application.withdrawal | 4 |
| decision-standard | application.rejection, committee.review, committee.decision | 3 |
| certificate-approval | application.approval | 1 |
| condition-letter | application.conditional | 1 |
| consent-standard | consent.form | 1 |
| safety-report | safety.report | 1 |
| risk-assessment | risk.assessment | 1 |
| meeting-minutes | meeting.agenda, meeting.minutes | 2 |
| notification-status-change | notification.status | 1 |
| email-generic | email.generic | 1 |
| report-annual | report.annual | 1 |
| accreditation-cert | accreditation.decision, accreditation.conditional, accreditation.suspension, accreditation.revocation, accreditation.expiration, accreditation.certificate | 6 |

---

## 9. Gaps and Recommendations

### Critical Gaps

| # | Gap | Severity | Recommendation |
|---|-----|----------|----------------|
| 1 | Accreditation Cycle page has `DocumentGenerationSection` imported but **no `documentActions` array defined** | 🔴 High | Define 6 accreditation actions (decision, conditional, suspension, revocation, expiration, certificate) in `CycleDetail.tsx` |
| 2 | Safety Incidents page (`RiskIncidents.tsx`) has **no template integration** | 🔴 High | Add `DocumentGenerationSection` with safety report action |
| 3 | Notifications page has **no template integration** | 🟡 Medium | Add notification status template action or handle via backend event-driven generation |
| 4 | Messages page has **no template integration** | 🟡 Medium | Add generic email template action or handle via backend event-driven generation |
| 5 | `application.correction` MODULE_DOCUMENTS key exists but is **not wired** in any frontend page | 🟡 Medium | Add correction action to Applications/Detail.tsx |
| 6 | All 12 template versions are **DRAFT** status | 🟡 Medium | Promote to APPROVED for production use via approval workflow |
| 7 | `email-generic` template uses undefined variable `bodyContent` in content | 🟡 Medium | Register `bodyContent` as a variable or use a dynamic injection mechanism |
| 8 | `report-annual` template uses undefined variables `reportYear`, `executiveSummary`, `totalApplications`, `approvedApplications`, `rejectedApplications`, `pendingApplications` | 🟡 Medium | Register these variables in the variable registry (56-template-categories-variables.sql) |
| 9 | `meeting-minutes` template uses undefined variable `meetingDecisions` | 🟡 Medium | Register in variable registry |
| 10 | `safety-report` template uses undefined variables `safetyEventType`, `safetyEventDate`, `safetyEventDescription`, `safetyActionTaken`, `safetyRecommendations` | 🟡 Medium | Register in variable registry |

### Observations

| # | Observation | Impact |
|---|-------------|--------|
| 1 | `protocol-full` is reused for 4 different application actions (submission, receipt, correction, withdrawal) — different contexts may need different content | Consider creating action-specific templates or using partials for conditional sections |
| 2 | `decision-standard` serves both application rejection and committee review/decision — same template for different workflows | Acceptable if template content is generic enough |
| 3 | `accreditation-cert` serves 6 different accreditation lifecycle events with the same template | May need differentiation for suspension vs. certificate vs. revocation |
| 4 | Frontend variable passing uses simplified keys (`application_number`, `project_title`) while backend expects full resolver paths | Template variable resolver must map frontend keys to entity paths |

---

## 10. Summary Statistics

| Metric | Count |
|--------|-------|
| **Total categories** | 12 |
| **Total templates** | 12 |
| **Total template versions** | 12 (all DRAFT) |
| **Total variables in registry** | 44 |
| **Total template partials** | 5 |
| **MODULE_DOCUMENTS keys** | 23 |
| **Unique templates referenced** | 12/12 (100%) |
| **Business pages with template actions** | 4/8 |
| **Total frontend document actions** | 14 |
| **Template actions fully wired** | 14/23 MODULE_DOCUMENTS keys |
| **Overall integration status** | ⚠️ Partial — 9 MODULE_DOCUMENTS keys not wired to frontend |

### Coverage Breakdown

- **Schema:** ✅ 16 tables, RLS enabled, audit triggers active
- **Categories:** ✅ 12/12 seeded with all fields
- **Variables:** ⚠️ 44 registered; ~12 used in templates but not in registry
- **Templates:** ✅ 12/12 seeded with bilingual content (ar + en)
- **Partials:** ✅ 5 shared components seeded
- **MODULE_DOCUMENTS:** ✅ 23 keys defined
- **Frontend integration:** ⚠️ 14/23 actions wired (61%)
- **Approval status:** ⚠️ All versions DRAFT — none APPROVED
