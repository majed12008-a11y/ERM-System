# ERM-System Forms Library — Official Forms Catalog (v1)

> Version 1.0 · 2026-08-01 · Status: Approved
> This catalog defines the production-ready v1 Forms Library covering the **complete research application lifecycle** for a national ethics review platform (REC/IRB). All forms follow the unified architecture defined in `04-pdf-spec.md` and `05-database-mapping.md`.

---

## 1. Catalog Conventions

Each form card defines:

- **Form ID** — stable identifier `FRM-###`.
- **Code** — machine code used in `forms.form_definitions` and document templates.
- **Category** — one of: `APPLICATION`, `SCREENING`, `REVIEW`, `MEETING`, `DECISION`, `POST_APPROVAL`, `SAFETY`, `MONITORING`, `CLOSURE`, `DECLARATION`, `CONSENT`, `COMMUNICATION`.
- **Workflow stage** — which lifecycle stage it belongs to.
- **Document type** — `INTERACTIVE` (filled in-app, data stored) and/or `OFFICIAL` (printed PDF legal record).
- **Who** — create / edit / approve / sign matrix.
- **Permissions** — permission codes required (see `reference.permissions` / `user_permissions`).
- **Entities** — database entities involved.
- **Numbering** — reference number format.
- **Versioning / audit / notifications / transitions** — operational contract.

### Role shorthand

| Role | Code |
|---|---|
| Applicant (Researcher/PI) | `APPLICANT` |
| REC Staff / Coordinator | `COORDINATOR` |
| Ethics Administrator | `ETHICS_ADMIN` |
| Committee Member / Reviewer | `REVIEWER` |
| Committee Chairperson | `CHAIR` |
| Institutional Representative | `INST_REP` |
| System Admin | `SUPER_ADMIN`/`SYS_ADMIN`/`ADMIN` |

### Permission shorthand

| Permission | Code |
|---|---|
| application.view / .create / .submit | `application.view` `application.create` `application.submit` |
| review.conduct / review.submit | `review.conduct` `review.submit` |
| meeting.manage / meeting.minutes | `meeting.manage` `meeting.minutes` |
| decision.record / decision.approve | `decision.record` `decision.approve` |
| document.generate / document.sign | `document.generate` `document.sign` |
| safety.report / safety.oversight | `safety.report` `safety.oversight` |
| monitoring.conduct / monitoring.oversight | `monitoring.conduct` `monitoring.oversight` |
| consent.manage | `consent.manage` |
| declaration.submit | `declaration.submit` |
| administration | `user.view` (admin gate) |

---

## 2. Forms Catalog Summary

| ID | Code | Form | Category | Workflow Stage | Doc Type |
|---|---|---|---|---|---|
| FRM-001 | `APP_PROTOCOL` | Application / Protocol Registration Form | APPLICATION | Submission | INTERACTIVE + OFFICIAL |
| FRM-002 | `ADMIN_SCREENING` | Administrative Screening Checklist | SCREENING | Initial Review | INTERACTIVE + OFFICIAL |
| FRM-003 | `SCI_REVIEW_PRIMARY` | Scientific Review — Primary Reviewer Assessment | REVIEW | Scientific Review | INTERACTIVE + OFFICIAL |
| FRM-004 | `SCI_REVIEW_SECONDARY` | Scientific Review — Secondary Reviewer Assessment | REVIEW | Scientific Review | INTERACTIVE + OFFICIAL |
| FRM-005 | `ETH_REVIEW` | Ethics (Bioethics) Review Form | REVIEW | Ethical Review | INTERACTIVE + OFFICIAL |
| FRM-006 | `STAT_REVIEW` | Statistical Review | REVIEW | Scientific Review | INTERACTIVE |
| FRM-007 | `LEGAL_REVIEW` | Legal Review | REVIEW | Administrative | INTERACTIVE |
| FRM-008 | `EXPEDITED_REVIEW` | Expedited Review Determination | REVIEW | Expedited | INTERACTIVE + OFFICIAL |
| FRM-009 | `EXEMPTION_DETERMINATION` | Exemption Determination | REVIEW | Screening | INTERACTIVE + OFFICIAL |
| FRM-010 | `COMM_AGENDA` | Committee Meeting Agenda | MEETING | Committee Review | OFFICIAL |
| FRM-011 | `COMM_ATTENDANCE` | Meeting Attendance Record | MEETING | Committee Review | INTERACTIVE + OFFICIAL |
| FRM-012 | `COI_DECLARATION` | Conflict of Interest Declaration | DECLARATION | Pre-review | INTERACTIVE + OFFICIAL |
| FRM-013 | `CONFIDENTIALITY_AGREEMENT` | Confidentiality Agreement | DECLARATION | Pre-review | INTERACTIVE + OFFICIAL |
| FRM-014 | `RESEARCHER_DECLARATION` | Researcher Declaration | DECLARATION | Submission | INTERACTIVE + OFFICIAL |
| FRM-015 | `COMM_MINUTES` | Committee Meeting Minutes | MEETING | Committee Review | OFFICIAL |
| FRM-016 | `VOTING_RECORD` | Voting Record | MEETING | Committee Review | OFFICIAL |
| FRM-017 | `DECISION_RECORD` | Decision Record | DECISION | Decision | OFFICIAL |
| FRM-018 | `APPROVAL_CERTIFICATE` | Ethics Approval Certificate | DECISION | Final Approval | OFFICIAL |
| FRM-019 | `CONDITIONAL_APPROVAL` | Conditional Approval Letter | DECISION | Conditional Approval | OFFICIAL |
| FRM-020 | `REJECTION_LETTER` | Rejection Letter | DECISION | Rejection | OFFICIAL |
| FRM-021 | `DEFERRAL_LETTER` | Deferral Letter | DECISION | Deferral | OFFICIAL |
| FRM-022 | `AMENDMENT_REQUEST` | Amendment Request | POST_APPROVAL | Amendment Review | INTERACTIVE + OFFICIAL |
| FRM-023 | `AMENDMENT_REVIEW` | Protocol Amendment Review | POST_APPROVAL | Amendment Review | INTERACTIVE |
| FRM-024 | `CONTINUING_REVIEW` | Continuing Review / Annual Progress Report | POST_APPROVAL | Continuing Review | INTERACTIVE + OFFICIAL |
| FRM-025 | `SAE_REPORT` | Serious Adverse Event Report | SAFETY | SAE Review | INTERACTIVE + OFFICIAL |
| FRM-026 | `DEVIATION_REPORT` | Protocol Deviation Report | SAFETY | Deviation Review | INTERACTIVE + OFFICIAL |
| FRM-027 | `NONCOMPLIANCE_REPORT` | Non-Compliance Report | SAFETY | Oversight | INTERACTIVE + OFFICIAL |
| FRM-028 | `SITE_MONITORING` | Site Monitoring Checklist | MONITORING | Study Monitoring | INTERACTIVE + OFFICIAL |
| FRM-029 | `INSPECTION_REPORT` | Inspection Report | MONITORING | Site Visit | OFFICIAL |
| FRM-030 | `SUSPENSION_NOTICE` | Study Suspension Notice | SAFETY | Suspension | OFFICIAL |
| FRM-031 | `TERMINATION_NOTICE` | Study Termination Notice | SAFETY | Termination | OFFICIAL |
| FRM-032 | `STUDY_CLOSURE` | Study Closure Report | CLOSURE | Study Closure | INTERACTIVE + OFFICIAL |
| FRM-033 | `FINAL_STUDY_REPORT` | Final Study Report | CLOSURE | Final Archive | INTERACTIVE + OFFICIAL |
| FRM-034 | `ICF_TEMPLATE` | Informed Consent / Assent Template | CONSENT | Submission | OFFICIAL |
| FRM-035 | `DOCUMENT_RECEIPT` | Document Receipt Form | COMMUNICATION | Any | OFFICIAL |
| FRM-036 | `PARTICIPANT_COMPLAINT` | Participant Complaint Form | COMMUNICATION | Oversight | INTERACTIVE |
| FRM-037 | `APPEAL_FORM` | Appeal / Reconsideration Form | COMMUNICATION | Decision | INTERACTIVE + OFFICIAL |

**37 forms** in v1. Forms FRM-001 … FRM-005, FRM-010, FRM-011, FRM-014, FRM-015, FRM-017, FRM-018, FRM-019, FRM-020, FRM-021, FRM-024, FRM-025, FRM-026, FRM-028, FRM-030, FRM-031, FRM-032, FRM-033, FRM-034, FRM-035 are the **end-to-end application lifecycle core** implemented in the first delivery.

---

## 3. Form Specifications

### FRM-001 — Application / Protocol Registration Form
- **Purpose:** Capture the complete research protocol for ethics review (national standard, aligned with ICH-GCP E6(R3) §6 and CIOMS).
- **Workflow stage:** Application Submission.
- **Business rules:** One application per project/committee per submission cycle; `DRAFT → SUBMITTED` only after all mandatory fields and required documents are present.
- **Who:** Create: `APPLICANT`. Edit: `APPLICANT` (draft/returned states). Approve: `COORDINATOR` (administrative completeness). Sign: `APPLICANT` (researcher declaration embedded).
- **Permissions:** `application.create`, `application.submit`.
- **Entities:** `core.applications`, `core.projects`, `committee.committees`, `core.application_documents`, `security.institutions`.
- **Relationships:** Project 1—N Application; Application N—1 Committee; Application 1—N Documents.
- **Validation:** Mandatory: project, committee, title (ar/en), abstract, objectives, design, population, sample size, intervention, endpoints, consent process, data management, risk/benefit. Conditional: device/radiation fields if applicable.
- **Numbering:** `REC-<yyyy>-<seq>` from `reference.application_sequences`.
- **Versioning:** `core.application_versions` snapshots on every edit (existing `system.fn_create_snapshot`).
- **Audit:** `audit.audit_logs` via trigger; document history via `documents.document_versions`.
- **Notifications:** To committee coordinator on submit; to applicant on return.
- **Transitions:** `SUBMIT`, `RETURN_SUBMITTED`, `ACCEPT_INITIAL`.
- **PDF layout:** Cover (title + applicant + committee + number), 8 numbered sections, declaration & signature block, QR on page 1 and last page, numbered footer.

### FRM-002 — Administrative Screening Checklist
- **Purpose:** Verify completeness and compliance (checklist + outcome: Complete / Incomplete / Rejected / Exempt).
- **Workflow stage:** Administrative Screening.
- **Business rules:** Must be completed before scientific review; non-clinical-complete returns to applicant.
- **Who:** Create/Edit/Approve/Sign: `COORDINATOR`.
- **Permissions:** `application.view`, `review.conduct`.
- **Entities:** `core.applications`, `committee.review_forms`, `forms.form_instances`.
- **Numbering:** `SCR-<applicationNumber>-<seq>`.
- **Transitions:** `ACCEPT_INITIAL`, `RETURN_SUBMITTED`, `REJECT_SUBMITTED`, `EXEMPT`.

### FRM-003 / FRM-004 — Scientific Review (Primary / Secondary)
- **Purpose:** Independent scientific assessment (ICH-GCP §6, CIOMS guidelines). Primary and secondary reviewers each complete an assessment; disagreement escalates to full committee.
- **Workflow stage:** Scientific Review.
- **Business rules:** Two independent reviewers; blind to each other's scores; verdict: Approve / Approve with changes / Reject / Return.
- **Who:** Create/Edit: assigned `REVIEWER`. Approve: `CHAIR` (consolidation). Sign: `REVIEWER`.
- **Permissions:** `review.conduct`, `review.submit`.
- **Entities:** `core.review_assignments` (via `committee.reviews`), `committee.review_forms`, `forms.form_instances`.
- **Transitions:** `SEND_TO_SCIENTIFIC`, `RETURN_SCIENTIFIC`, `SEND_TO_ETHICAL`.
- **PDF layout:** Header with application number, reviewer identity block, scored sections, free-text critique, recommendation + justification, signature, QR.

### FRM-005 — Ethics Review Form
- **Purpose:** Evaluate human-subject protections: consent, vulnerable populations, privacy, risk/benefit, confidentiality, local context.
- **Workflow stage:** Ethical Review.
- **Business rules:** Follows Declaration of Helsinki + CIOMS. Any "high risk" response on a safety-critical question triggers full committee review.
- **Who:** `REVIEWER` (create/edit/sign); `CHAIR` (approve).
- **Permissions:** `review.conduct`.
- **Transitions:** `SEND_TO_ETHICAL`, `RETURN_ETHICAL`, `SEND_TO_COMMITTEE`.

### FRM-006 — Statistical Review
- **Purpose:** Assess sample size, randomization, analysis plan, endpoints.
- **Who:** `REVIEWER` (statistician role).
- **Permissions:** `review.conduct`.

### FRM-007 — Legal Review
- **Purpose:** Regulatory/legal compliance (data protection, liability, insurance, national regulations).
- **Who:** `REVIEWER` (legal) / `INST_REP`.

### FRM-008 — Expedited Review Determination
- **Purpose:** Authorize/record expedited review for minimal-risk research (US OHRP expedited categories).
- **Who:** `CHAIR` or designee. 
- **Permissions:** `review.conduct`.
- **Transitions:** expedited path to `COMMITTEE_APPROVE` or `COMMITTEE_REJECT`.

### FRM-009 — Exemption Determination
- **Purpose:** Record exemption (e.g., existing de-identified data, educational tests) with regulatory basis.
- **Who:** `COORDINATOR` / `CHAIR`.

### FRM-010 — Committee Meeting Agenda
- **Purpose:** Formal agenda: call to order, conflicts, quorum, application docket, decisions, adjournment.
- **Who:** Create/Edit: `COORDINATOR`. Approve: `CHAIR`. 
- **Permissions:** `meeting.manage`.
- **Entities:** `committee.meetings`, `committee.meeting_items`, `committee.meeting_agenda_items`.
- **PDF layout:** Official letterhead, agenda items numbered, times, applicants, reviewers.

### FRM-011 — Meeting Attendance Record
- **Purpose:** Record attendance + quorum for each meeting; conflicts recused.
- **Who:** `COORDINATOR` (create), `CHAIR` (approve), attendees (sign via e-signature).
- **Permissions:** `meeting.manage`.

### FRM-012 — Conflict of Interest Declaration
- **Purpose:** Members declare financial/academic/personal interests before each review.
- **Who:** `REVIEWER` (submit); `COORDINATOR` (record); recusal enforced by workflow.
- **Business rules:** If declared conflict, reviewer cannot be assigned; existing assignment must be released and replaced.
- **Permissions:** `declaration.submit`.

### FRM-013 — Confidentiality Agreement
- **Purpose:** Binding confidentiality for reviewers and staff.
- **Who:** `REVIEWER`/`COORDINATOR` (sign). 
- **Permissions:** `declaration.submit`.
- **Audit:** signature recorded in `documents.document_signatures`.

### FRM-014 — Researcher Declaration
- **Purpose:** Applicant attests to accuracy, training (GCP/Helsinki), regulatory approvals, data handling.
- **Who:** `APPLICANT` (sign). Mandatory before `SUBMIT`.
- **Permissions:** `application.submit`.

### FRM-015 — Committee Meeting Minutes
- **Purpose:** Official record of proceedings, decisions, voting, and conditions.
- **Who:** Create: `COORDINATOR`. Approve: `CHAIR`. Sign: `CHAIR` + `COORDINATOR`.
- **Permissions:** `meeting.minutes`.
- **Business rules:** Minutes must be approved before decisions are finalized; locked after approval (immutable).
- **Transitions:** minutes approval gates `COMMITTEE_APPROVE` etc.

### FRM-016 — Voting Record
- **Purpose:** Formal vote tally per application (approve / approve-with-conditions / defer / reject / recuse).
- **Who:** `COORDINATOR` (record), `CHAIR` (certify). 
- **Business rules:** Quorum required; majority rules per policy; recusals documented.

### FRM-017 — Decision Record
- **Purpose:** Consolidated official decision referencing minutes, voting, and conditions.
- **Who:** Create: `COORDINATOR`. Approve/Sign: `CHAIR`.
- **Permissions:** `decision.record`, `decision.approve`.
- **Transitions:** `COMMITTEE_APPROVE`, `COMMITTEE_REJECT`, `COMMITTEE_CONDITIONAL`, `COMMITTEE_RETURN`.

### FRM-018 — Ethics Approval Certificate
- **Purpose:** Official certificate of ethics approval (already implemented — to be aligned with the new engine).
- **Who:** Generated automatically on `APPROVED`; signed: `CHAIR`; seal: `INST_REP`.
- **Transitions:** reissue → new version; revoke → status change; verified publicly by QR.

### FRM-019 / FRM-020 / FRM-021 — Conditional Approval / Rejection / Deferral Letters
- **Purpose:** Official outcome letters with conditions / reasons / deferral instructions.
- **Who:** Draft: `COORDINATOR`. Approve & sign: `CHAIR`.
- **Permissions:** `decision.record`.
- **Transitions:** `COMMITTEE_CONDITIONAL` → applicant submits evidence (`SUBMIT_EVIDENCE`); `COMMITTEE_REJECT` → terminal `REJECTED`; deferral → `COMMITTEE_RETURN` → `RESUBMIT`.

### FRM-022 / FRM-023 — Amendment Request / Review
- **Purpose:** Post-approval protocol change submission and review.
- **Who:** `APPLICANT` (request), `COORDINATOR`/`REVIEWER` (review), `CHAIR` (approve).
- **Business rules:** Substantive amendments require full review; administrative amendments expedited.

### FRM-024 — Continuing Review / Annual Progress Report
- **Purpose:** Renewal/progress reporting (ICH-GCP §6.12.3): enrollment, outcomes, adverse events, new risks.
- **Who:** `APPLICANT` (submit), `REVIEWER`/`CHAIR` (approve).
- **Business rules:** Must be submitted before expiry; late submission suspends active status.

### FRM-025 — Serious Adverse Event (SAE) Report
- **Purpose:** SAE notification within regulatory timelines (ICH-GCP §6.12.3, national regulation).
- **Who:** `APPLICANT` (submit, within 24h fatal/life-threatening, 7 days others), `COORDINATOR` (acknowledge), committee review.
- **Permissions:** `safety.report`.

### FRM-026 — Protocol Deviation Report
- **Purpose:** Report deviations, classification (minor/major), impact, corrective action.

### FRM-027 — Non-Compliance Report
- **Purpose:** Document non-compliance, investigation, corrective/preventive actions (CAPA), sanction recommendation.

### FRM-028 — Site Monitoring Checklist
- **Purpose:** Structured site visit assessment (ICH-GCP §5.18): source data, consent verification, drug/device accountability, AE handling, facilities.

### FRM-029 — Inspection Report
- **Purpose:** Regulatory inspection findings with severity rating.

### FRM-030 / FRM-031 — Suspension / Termination Notices
- **Purpose:** Official notices halting/ending a study with reasons, required actions, and reinstatement pathway.

### FRM-032 — Study Closure Report
- **Purpose:** Formal closure: final enrollment, follow-up completion, data retention, archiving plan.

### FRM-033 — Final Study Report
- **Purpose:** Summary of study results and outcomes for archival.

### FRM-034 — Informed Consent / Assent Template
- **Purpose:** Bilingual consent document produced from the approved template + protocol data; versions frozen at approval.
- **Who:** `APPLICANT` (customize from template), `COORDINATOR` (validate), `CHAIR` (approve).
- **Permissions:** `consent.manage`.

### FRM-035 — Document Receipt Form
- **Purpose:** Prove submission/delivery of any document with timestamp + recipient.

### FRM-036 — Participant Complaint Form
- **Purpose:** Participant concerns intake (complaint register) with confidentiality handling.

### FRM-037 — Appeal / Reconsideration Form
- **Purpose:** Formal request to reconsider a decision, with grounds and new information.

---

## 4. Document Numbering Register

All official documents carry a reference number generated server-side from `documents.document_numbering`.

| Document | Prefix | Format |
|---|---|---|
| Approval Certificate | `CERT` | `CERT-<appNo>-V<n>` (kept for backward compatibility) |
| Application | `REC` | `REC-<yyyy>-<6-digit seq>` |
| Screening checklist | `SCR` | `SCR-<appNo>-<seq>` |
| Decision letters | `DEC` | `DEC-<appNo>-<type>-<seq>` (APPR/COND/REJ/DEF) |
| Committee documents | `COM` | `COM-<meetingNo>-<AGN|MIN|ATT|VOT>` |
| Safety reports | `SAF` | `SAF-<appNo>-<SAE|DEV|NC>-<seq>` |
| Monitoring | `MON` | `MON-<site>-<seq>` |
| Closure/Final | `FIN` | `FIN-<appNo>-<type>` |
| Consent | `ICF` | `ICF-<appNo>-<version>` |

---

## 5. Delivery Order (v1 core)

The following are implemented in the first delivery as **production-ready** end-to-end (schema → DB → renderer → PDF):

1. FRM-001 Application / Protocol Registration
2. FRM-002 Administrative Screening Checklist
3. FRM-003/004/005 Review Forms (Primary/Secondary/Ethics)
4. FRM-010/011/015/016/017 Meeting Agenda, Attendance, Minutes, Voting, Decision Record
5. FRM-014 Researcher Declaration, FRM-012 COI, FRM-013 Confidentiality
6. FRM-018 Approval Certificate, FRM-019/020/021 Official Letters
7. FRM-024 Annual Progress, FRM-025 SAE, FRM-026 Deviation
8. FRM-028 Site Monitoring, FRM-030/031 Suspension/Termination
9. FRM-032/033 Closure/Final, FRM-034 Consent, FRM-035 Receipt
