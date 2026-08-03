# ERM-System Forms Library — Official Forms Catalog (v2)

> Version 2.0 · 2026-08-02 · Status: Approved
> Defines the complete v2 Forms Library (~50 forms) covering the full research-application lifecycle for a national ethics review platform (REC/IRB). Forms are organized into the six task categories: **General, Review, Committee, Official Documents, Study Monitoring, Participant**.
> Supersedes: v1.0 (2026-08-01, 37 forms) which used legacy categories. Form IDs FRM-001…FRM-037 are preserved from v1; FRM-038…FRM-050 are new.
> Status legend: ✅ seeded & active · 🔧 refactor in place · 🔴 to create

---

## 1. Catalog Conventions

Each form card defines:

- **Form ID** — stable `FRM-###`.
- **Code** — machine code in `forms.form_definitions` (and optionally a linked template).
- **Category** — one of the six task categories.
- **Workflow stage** — lifecycle stage (states from `workflow.workflow_states`).
- **Doc type** — `INTERACTIVE` (in-app, data stored) and/or `OFFICIAL` (generated PDF legal record).
- **Who** — create / edit / approve / sign matrix.
- **Permissions** — permission codes.
- **Entities** — DB entities.
- **Numbering** — reference-number prefix.
- **Status** — ✅/🔧/🔴.
- **Template** — linked `documents.templates.template_code` for OFFICIAL docs.

### Role shorthand

| Role | Code |
|---|---|
| Applicant (Researcher/PI) | `APPLICANT` |
| REC Staff / Coordinator | `COORDINATOR` |
| Ethics Administrator | `ETHICS_ADMIN` |
| Committee Member / Reviewer | `REVIEWER` |
| Committee Chairperson | `CHAIR` |
| Institutional Representative | `INST_REP` |
| Monitor / Inspector | `MONITOR` |
| System Admin | `SUPER_ADMIN`/`SYS_ADMIN`/`ADMIN` |

### Permission shorthand

`application.view/.create/.submit`, `review.conduct/.submit`, `meeting.manage/.minutes`, `decision.record/.approve`, `document.generate/.sign`, `safety.report/.oversight`, `monitoring.conduct/.oversight`, `consent.manage`, `declaration.submit`, `participant.intake`.

---

## 2. Catalog Summary (50 forms)

### Category: General (8)

| ID | Code | Form | Workflow | Doc | Status |
|---|---|---|---|---|---|
| FRM-001 | `APP_PROTOCOL` | Application / Protocol Registration | Submission | INTERACTIVE + OFFICIAL | 🔴 |
| FRM-002 | `ADMIN_SCREENING` | Administrative Screening Checklist | Initial Review | INTERACTIVE + OFFICIAL | ✅ |
| FRM-009 | `EXEMPTION_DETERMINATION` | Exemption Determination | Screening | INTERACTIVE + OFFICIAL | 🔴 |
| FRM-035 | `DOCUMENT_RECEIPT` | Document Receipt Form | Any | OFFICIAL | 🔴 |
| FRM-037 | `APPEAL_FORM` | Appeal / Reconsideration Form | Decision | INTERACTIVE + OFFICIAL | 🔴 |
| FRM-045 | `CORRESPONDENCE` | General Correspondence / Cover Letter | Any | OFFICIAL | 🔴 |
| FRM-046 | `APPLICATION_WITHDRAWAL` | Application Withdrawal Form | Any | INTERACTIVE + OFFICIAL | 🔴 |
| FRM-049 | `DATA_REQUEST_FORM` | Data / Records Request Form | Any | INTERACTIVE | 🔴 |

### Category: Review (10)

| ID | Code | Form | Workflow | Doc | Status |
|---|---|---|---|---|---|
| FRM-003 | `SCI_REVIEW_PRIMARY` | Scientific Review — Primary Reviewer Assessment | Scientific Review | INTERACTIVE + OFFICIAL | ✅ |
| FRM-004 | `SCI_REVIEW_SECONDARY` | Scientific Review — Secondary Reviewer Assessment | Scientific Review | INTERACTIVE + OFFICIAL | 🔴 |
| FRM-005 | `ETH_REVIEW` | Ethics (Bioethics) Review Form | Ethical Review | INTERACTIVE + OFFICIAL | ✅ |
| FRM-006 | `STAT_REVIEW` | Statistical Review | Scientific Review | INTERACTIVE | 🔴 |
| FRM-007 | `LEGAL_REVIEW` | Legal / Regulatory Review | Administrative | INTERACTIVE | 🔴 |
| FRM-008 | `EXPEDITED_REVIEW` | Expedited Review Determination | Expedited | INTERACTIVE + OFFICIAL | 🔴 |
| FRM-022 | `AMENDMENT_REQUEST` | Protocol Amendment Request | Amendment Review | INTERACTIVE + OFFICIAL | 🔴 |
| FRM-023 | `AMENDMENT_REVIEW` | Protocol Amendment Review | Amendment Review | INTERACTIVE | 🔴 |
| FRM-047 | `REVIEW_ASSIGNMENT` | Reviewer Assignment Record | Initial → Scientific | INTERACTIVE | 🔴 |
| FRM-048 | `REVIEW_CONSOLIDATION` | Reviewer Verdict Consolidation (chair) | Scientific/Ethical | INTERACTIVE + OFFICIAL | 🔴 |

### Category: Committee (7)

| ID | Code | Form | Workflow | Doc | Status |
|---|---|---|---|---|---|
| FRM-010 | `COMM_AGENDA` | Committee Meeting Agenda | Committee Review | OFFICIAL | 🔴 |
| FRM-011 | `COMM_ATTENDANCE` | Meeting Attendance Record | Committee Review | INTERACTIVE + OFFICIAL | 🔴 |
| FRM-012 | `COI_DECLARATION` | Conflict of Interest Declaration | Pre-review | INTERACTIVE + OFFICIAL | 🔴 |
| FRM-013 | `CONFIDENTIALITY_AGREEMENT` | Confidentiality Agreement | Pre-review | INTERACTIVE + OFFICIAL | 🔴 |
| FRM-015 | `COMM_MINUTES` | Committee Meeting Minutes | Committee Review | OFFICIAL | ✅ |
| FRM-016 | `VOTING_RECORD` | Voting Record | Committee Review | OFFICIAL | 🔴 |
| FRM-017 | `DECISION_RECORD` | Decision Record | Decision | OFFICIAL | 🔴 |

### Category: Official Documents (12)

| ID | Code | Form | Workflow | Doc | Status |
|---|---|---|---|---|---|
| FRM-014 | `RESEARCHER_DECLARATION` | Researcher Declaration | Submission | INTERACTIVE + OFFICIAL | 🔴 |
| FRM-018 | `APPROVAL_CERTIFICATE` | Ethics Approval Certificate | Final Approval | OFFICIAL | 🔧 (certificate subsystem → align to engine) |
| FRM-019 | `CONDITIONAL_APPROVAL` | Conditional Approval Letter | Conditional Approval | OFFICIAL | 🔴 |
| FRM-020 | `REJECTION_LETTER` | Rejection Letter | Rejection | OFFICIAL | 🔴 |
| FRM-021 | `DEFERRAL_LETTER` | Deferral Letter | Deferral | OFFICIAL | 🔴 |
| FRM-030 | `SUSPENSION_NOTICE` | Study Suspension Notice | Suspension | OFFICIAL | 🔴 |
| FRM-031 | `TERMINATION_NOTICE` | Study Termination Notice | Termination | OFFICIAL | 🔴 |
| FRM-034 | `ICF_TEMPLATE` | Informed Consent / Assent Template | Submission | OFFICIAL | 🔴 |
| FRM-042 | `STUDY_INITIATION_LETTER` | Permission to Conduct (Initiation) Letter | Post-approval | OFFICIAL | 🔴 |
| FRM-043 | `AMENDMENT_APPROVAL_LETTER` | Amendment Approval Letter | Amendment | OFFICIAL | 🔴 |
| FRM-044 | `RENEWAL_LETTER` | Approval Renewal Letter | Continuing Review | OFFICIAL | 🔴 |
| FRM-050 | `SITE_APPROVAL_LETTER` | Site / Institution Approval Letter | Pre-submission | OFFICIAL | 🔴 |

### Category: Study Monitoring (8)

| ID | Code | Form | Workflow | Doc | Status |
|---|---|---|---|---|---|
| FRM-024 | `ANNUAL_PROGRESS` | Continuing Review / Annual Progress Report | Continuing Review | INTERACTIVE + OFFICIAL | ✅ |
| FRM-025 | `SAE_REPORT` | Serious Adverse Event Report | SAE Review | INTERACTIVE + OFFICIAL | ✅ |
| FRM-026 | `DEVIATION_REPORT` | Protocol Deviation Report | Deviation Review | INTERACTIVE + OFFICIAL | 🔴 |
| FRM-027 | `NONCOMPLIANCE_REPORT` | Non-Compliance Report | Oversight | INTERACTIVE + OFFICIAL | 🔴 |
| FRM-028 | `SITE_MONITORING` | Site Monitoring Checklist | Study Monitoring | INTERACTIVE + OFFICIAL | ✅ |
| FRM-029 | `INSPECTION_REPORT` | Inspection Report | Site Visit | OFFICIAL | 🔴 |
| FRM-032 | `STUDY_CLOSURE` | Study Closure Report | Study Closure | INTERACTIVE + OFFICIAL | ✅ |
| FRM-033 | `FINAL_STUDY_REPORT` | Final Study Report | Final Archive | INTERACTIVE + OFFICIAL | 🔴 |

### Category: Participant (5)

| ID | Code | Form | Workflow | Doc | Status |
|---|---|---|---|---|---|
| FRM-036 | `PARTICIPANT_COMPLAINT` | Participant Complaint Form | Oversight | INTERACTIVE | 🔴 |
| FRM-038 | `PIS_TEMPLATE` | Participant Information Sheet | Submission | OFFICIAL | 🔴 |
| FRM-039 | `ASSENT_TEMPLATE` | Minor Assent Form | Submission | OFFICIAL | 🔴 |
| FRM-040 | `PARTICIPANT_WITHDRAWAL` | Participant Withdrawal Form | Ongoing | INTERACTIVE + OFFICIAL | 🔴 |
| FRM-041 | `PARTICIPANT_NOTICE` | Participant Safety / Trial-Halt Notice | Ongoing | OFFICIAL | 🔴 |

> Catalog grand total **50 forms** (8 + 10 + 7 + 12 + 8 + 5).

---

## 3. Full Form Register (all 50)

| ID | Code | Category | Status |
|---|---|---|---|
| FRM-001 | `APP_PROTOCOL` | General | 🔴 |
| FRM-002 | `ADMIN_SCREENING` | General | ✅ |
| FRM-003 | `SCI_REVIEW_PRIMARY` | Review | ✅ |
| FRM-004 | `SCI_REVIEW_SECONDARY` | Review | 🔴 |
| FRM-005 | `ETH_REVIEW` | Review | ✅ |
| FRM-006 | `STAT_REVIEW` | Review | 🔴 |
| FRM-007 | `LEGAL_REVIEW` | Review | 🔴 |
| FRM-008 | `EXPEDITED_REVIEW` | Review | 🔴 |
| FRM-009 | `EXEMPTION_DETERMINATION` | General | 🔴 |
| FRM-010 | `COMM_AGENDA` | Committee | 🔴 |
| FRM-011 | `COMM_ATTENDANCE` | Committee | 🔴 |
| FRM-012 | `COI_DECLARATION` | Committee | 🔴 |
| FRM-013 | `CONFIDENTIALITY_AGREEMENT` | Committee | 🔴 |
| FRM-014 | `RESEARCHER_DECLARATION` | Official Documents | 🔴 |
| FRM-015 | `COMM_MINUTES` | Committee | ✅ |
| FRM-016 | `VOTING_RECORD` | Committee | 🔴 |
| FRM-017 | `DECISION_RECORD` | Committee | 🔴 |
| FRM-018 | `APPROVAL_CERTIFICATE` | Official Documents | 🔧 |
| FRM-019 | `CONDITIONAL_APPROVAL` | Official Documents | 🔴 |
| FRM-020 | `REJECTION_LETTER` | Official Documents | 🔴 |
| FRM-021 | `DEFERRAL_LETTER` | Official Documents | 🔴 |
| FRM-022 | `AMENDMENT_REQUEST` | Review | 🔴 |
| FRM-023 | `AMENDMENT_REVIEW` | Review | 🔴 |
| FRM-024 | `ANNUAL_PROGRESS` | Study Monitoring | ✅ |
| FRM-025 | `SAE_REPORT` | Study Monitoring | ✅ |
| FRM-026 | `DEVIATION_REPORT` | Study Monitoring | 🔴 |
| FRM-027 | `NONCOMPLIANCE_REPORT` | Study Monitoring | 🔴 |
| FRM-028 | `SITE_MONITORING` | Study Monitoring | ✅ |
| FRM-029 | `INSPECTION_REPORT` | Study Monitoring | 🔴 |
| FRM-030 | `SUSPENSION_NOTICE` | Official Documents | 🔴 |
| FRM-031 | `TERMINATION_NOTICE` | Official Documents | 🔴 |
| FRM-032 | `STUDY_CLOSURE` | Study Monitoring | ✅ |
| FRM-033 | `FINAL_STUDY_REPORT` | Study Monitoring | 🔴 |
| FRM-034 | `ICF_TEMPLATE` | Official Documents | 🔴 |
| FRM-035 | `DOCUMENT_RECEIPT` | General | 🔴 |
| FRM-036 | `PARTICIPANT_COMPLAINT` | Participant | 🔴 |
| FRM-037 | `APPEAL_FORM` | General | 🔴 |
| FRM-038 | `PIS_TEMPLATE` | Participant | 🔴 |
| FRM-039 | `ASSENT_TEMPLATE` | Participant | 🔴 |
| FRM-040 | `PARTICIPANT_WITHDRAWAL` | Participant | 🔴 |
| FRM-041 | `PARTICIPANT_NOTICE` | Participant | 🔴 |
| FRM-042 | `STUDY_INITIATION_LETTER` | Official Documents | 🔴 |
| FRM-043 | `AMENDMENT_APPROVAL_LETTER` | Official Documents | 🔴 |
| FRM-044 | `RENEWAL_LETTER` | Official Documents | 🔴 |
| FRM-045 | `CORRESPONDENCE` | General | 🔴 |
| FRM-046 | `APPLICATION_WITHDRAWAL` | General | 🔴 |
| FRM-047 | `REVIEW_ASSIGNMENT` | Review | 🔴 |
| FRM-048 | `REVIEW_CONSOLIDATION` | Review | 🔴 |
| FRM-049 | `DATA_REQUEST_FORM` | General | 🔴 |
| FRM-050 | `SITE_APPROVAL_LETTER` | Official Documents | 🔴 |

> FRM-045 `CORRESPONDENCE` and FRM-047 `REVIEW_ASSIGNMENT` are in the register above (General and Review respectively); register total = 50.

---

## 4. Flagship Form Specifications (condensed)

### FRM-001 — Application / Protocol Registration (General)
- **Purpose:** capture the complete research protocol (ICH-GCP E6(R3) §6, CIOMS).
- **Business rules:** one application per project per committee; `DRAFT → SUBMITTED` only when complete; edit only in DRAFT/RETURNED.
- **Who:** Create/Edit/Sign: `APPLICANT`. Approve: `COORDINATOR`.
- **Entities:** `core.applications`, `core.projects`, `committee.committees`, `core.application_documents`, `security.institutions`.
- **Validation:** mandatory protocol fields + consent + declaration; conditional device/radiation fields.
- **Numbering:** `REC-<yyyy>-<seq>`.
- **Transitions:** `SUBMIT`, `RETURN_SUBMITTED`, `ACCEPT_INITIAL`.
- **Status:** 🔴 to create. **Template:** `APPLICATION_DOC` (new).

### FRM-002 — Administrative Screening Checklist (General) ✅ seeded
- Verdict matrix: completeness booleans + outcome `COMPLETE/INCOMPLETE/REJECTED` (+ future `EXEMPT`).
- **Transitions:** `ACCEPT_INITIAL`, `RETURN_SUBMITTED`, `REJECT_SUBMITTED`.
- **Template:** none (INTERACTIVE) or `REVIEW_FORM_DOC`.

### FRM-003 / FRM-004 — Scientific Review Primary / Secondary (Review)
- Two independent blind reviewers; verdict `APPROVE / APPROVE_WITH_CHANGES / REJECT / RETURN`; chair consolidates via FRM-048.
- **Transitions:** `SEND_TO_SCIENTIFIC`, `RETURN_SCIENTIFIC`, `SEND_TO_ETHICAL`.
- **Template:** `REVIEW_FORM_DOC` (ar/en). ✅/🔴.

### FRM-005 — Ethics Review (Review) ✅ seeded
- Helsinki + CIOMS; any high-risk answer → full committee. **Transitions:** `SEND_TO_ETHICAL`, `RETURN_ETHICAL`, `SEND_TO_COMMITTEE`. **Template:** `REVIEW_FORM_DOC`.

### FRM-006/007/008 — Statistical / Legal / Expedited (Review) 🔴
- Stat: sample size, randomization, analysis plan. Legal: data protection, liability, national regs. Expedited: OHRP minimal-risk categories → `COMMITTEE_APPROVE`/`COMMITTEE_REJECT`.

### FRM-015 — Committee Minutes (Committee) ✅ seeded
- **Template:** `MEETING_MINUTES_DOC` (ar/en). Gates `COMMITTEE_APPROVE` etc.; locked after approval.

### FRM-018 — Approval Certificate (Official Documents) 🔧
- Auto-generated on `APPROVED`; signed `CHAIR`, sealed `INST_REP`; QR public verification; reissue → new version. **Keep serial compatibility** `CERT-<appNo>-V<n>`.

### FRM-019/020/021 — Conditional / Rejection / Deferral Letters (Official Documents) 🔴
- **Template:** `DECISION_LETTER` (ar/en). Transitions: `COMMITTEE_CONDITIONAL` / `COMMITTEE_REJECT` / `COMMITTEE_RETURN`.

### FRM-024 — Continuing Review / Annual Progress (Study Monitoring) ✅ seeded
- **Template:** `PROGRESS_REPORT_DOC` (re-categorized to POST_APPROVAL).

### FRM-025 — SAE Report (Study Monitoring) ✅ seeded
- Timelines 24h/7d; causality; severity CTCAE. **Template:** `SAFETY_REPORT_DOC`.

### FRM-028 — Site Monitoring Checklist (Study Monitoring) ✅ seeded
- **Template:** `MONITORING_REPORT_DOC`.

### FRM-032 — Study Closure Report (Study Monitoring) ✅ seeded
- **Template:** `CLOSURE_REPORT_DOC`.

### FRM-034 — Informed Consent / Assent Template (Official Documents) 🔴
- Bilingual consent produced from approved template + protocol data; versions frozen at approval. **Template:** `CONSENT_DOCUMENT` (new; replaces dead `ICF_TEMPLATE`).

---

## 5. Document Numbering Register

| Document class | Prefix | Format |
|---|---|---|
| Application | `REC` | `REC-<yyyy>-<seq>` |
| Screening / exemption | `SCR` | `SCR-<appNo>-<seq>` |
| Review forms | `REV` | `REV-<appNo>-<REVIEWER>-<seq>` |
| Committee documents | `COM` | `COM-<meetingNo>-<AGN\|MIN\|ATT\|VOT\|DEC>` |
| Decision letters | `DEC` | `DEC-<appNo>-<type>-<seq>` (APPR/COND/REJ/DEF) |
| Certificate | `CERT` | `CERT-<appNo>-V<n>` (back-compat) |
| Safety reports | `SAF` | `SAF-<appNo>-<SAE\|DEV\|NC>-<seq>` |
| Monitoring / inspection | `MON` | `MON-<site>-<seq>` |
| Closure / final | `FIN` | `FIN-<appNo>-<type>` |
| Consent / PIS / assent | `ICF` | `ICF-<appNo>-<version>` |
| Participant docs | `PPT` | `PPT-<appNo>-<type>-<seq>` |
| General correspondence | `GEN` | `GEN-<yyyy>-<seq>` |

---

## 6. Template ↔ Form Mapping (for OFFICIAL docs)

| Form(s) | Template (`documents.templates`) | Status |
|---|---|---|
| FRM-003/004/005/006/007/008/048 | `REVIEW_FORM_DOC` | ✅ ar+en |
| FRM-015/016/017 | `MEETING_MINUTES_DOC` | ✅ ar+en |
| FRM-019/020/021/042/043/044/050 | `DECISION_LETTER` | ✅ ar+en |
| FRM-024 | `PROGRESS_REPORT_DOC` | 🔧 re-categorize |
| FRM-025/026/027 | `SAFETY_REPORT_DOC` | ✅ ar+en |
| FRM-028/029 | `MONITORING_REPORT_DOC` | ✅ ar+en |
| FRM-032/033 | `CLOSURE_REPORT_DOC` | ✅ ar+en |
| FRM-018 | certificate subsystem → engine | 🔧 |
| FRM-034/038/039 | `CONSENT_DOCUMENT` (new) | 🔴 |
| FRM-001 | `APPLICATION_DOC` (new) | 🔴 |
| FRM-035/036/037/040/041/045/046/049 | various notice/receipt templates (new) | 🔴 |

---

## 7. Delivery Order (phased, feature-gated)

1. **Gate 0 — mandatory features** (before new forms): multi-signature, checksum API, verification portal, watermarks, expanded lifecycle.
2. **Phase 1:** refactor seeded forms (FRM-002/003/005/024/025/028/032/015) to full specs + re-categorize.
3. **Phase 2:** Review forms (FRM-004/006/007/008/022/023/047/048).
4. **Phase 3:** Committee forms (FRM-010/011/012/013/016/017).
5. **Phase 4:** Official Documents (FRM-014/019/020/021/030/031/042/043/044/050) + certificate alignment (FRM-018).
6. **Phase 5:** Study Monitoring (FRM-026/027/029/033) + General (FRM-001/009/035/037/045/046/049).
7. **Phase 6:** Participant (FRM-036/038/039/040/041) + consent (FRM-034).

Full data dictionary, business rules, JSON schemas, DB mapping, UI/API/PDF/template specs, and migration roadmap are in the companion documents in this folder.
