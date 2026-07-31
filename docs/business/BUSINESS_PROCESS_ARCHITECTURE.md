# Business Process Architecture

## Document Metadata

Document ID: SPEC-0007

Title: Business Process Architecture

Status: Approved

Version: 1.0

Owner: Enterprise Business Process Architecture

Approvers: Product Governance, Research Governance Authority, Enterprise Architecture

Reviewers: Research Ethics Governance, Institution Administration, Business Analysis, Domain Architecture, Enterprise Business Architecture

Classification: Specification

Audience: Ministry Leadership, Research Governance Authorities, Institution Administrators, Research Ethics Committees, Researchers, Principal Investigators, Reviewers, Hospitals, Universities, Regulatory Bodies, Enterprise Architects, Business Analysts, Process Architects, and Future Contributors

Created: 2026-07-31

Last Updated: 2026-07-31

Next Review: To be scheduled by Enterprise Business Process Architecture

Related Documents: `docs/product/PRODUCT_DEFINITION.md`, `docs/domain/DOMAIN_MODEL.md`, `docs/business/BUSINESS_CAPABILITY_MODEL.md`, `docs/governance/ENGINEERING_MANIFEST.md`, `docs/governance/ENGINEERING_DOCUMENTATION_STANDARD.md`

Depends On: `docs/product/PRODUCT_DEFINITION.md`, `docs/domain/DOMAIN_MODEL.md`, `docs/business/BUSINESS_CAPABILITY_MODEL.md`

References: RFC 2119

Keywords: business process architecture, research ethics, process catalog, value stream, lifecycle, governance, BPMN readiness

Confidentiality: Internal

## Normative Language

The key words MUST, MUST NOT, SHALL, SHALL NOT, SHOULD, SHOULD NOT, and MAY in this document are to be interpreted as described by RFC 2119 when used as normative terms.

## 1 Executive Summary

This Business Process Architecture defines the major business processes supported by ERM-System.

ERM-System is an Enterprise Research Ethics Management Platform for the complete lifecycle of ethical governance for health research.

This document describes business process structure, ownership, inputs, outputs, triggers, outcomes, controls, risks, dependencies, interfaces, KPIs, maturity, and priorities.

It SHALL become the primary process reference for workflow design, business process modeling, use cases, business state analysis, application service planning, and future BPMN models.

This document is technology independent.

It does not describe software construction, technical interfaces, persistence, screens, programming models, or implementation mechanisms.

The process architecture is derived from the approved Product Definition, Domain Model, and Business Capability Model.

Future process models SHALL preserve the business terminology and process boundaries defined here unless a later approved business architecture document supersedes them.

## 2 Business Process Philosophy

A business process describes how business actors coordinate work to produce a business outcome.

A business process is not a software component.

A business process is not a technical workflow definition.

A business process is not an organizational chart.

Business processes SHALL be expressed in language understandable by business owners, research ethics experts, enterprise architects, and business analysts.

Business processes SHOULD be stable enough to support future modeling and flexible enough to accommodate institutional governance variation.

Business process architecture SHALL connect capabilities to actual business activity.

Business process architecture SHALL preserve the distinction between business intent and implementation.

## 3 Process Architecture Principles

Processes SHALL use domain terminology from the Domain Model.

Processes SHALL support the Product Definition.

Processes SHALL map to business capabilities from the Business Capability Model.

Processes SHALL identify owners and consumers.

Processes SHALL identify triggers, inputs, outputs, controls, risks, success measures, priority, and maturity.

Processes SHALL remain technology independent.

Processes SHALL distinguish committee authority from administrative coordination.

Processes SHALL preserve accountability for decisions, evidence, approvals, and governance records.

Processes SHOULD support future BPMN modeling.

Processes SHOULD support future state modeling without prescribing implementation.

## 4 Process Landscape (Level 0)

The Level 0 process landscape defines the highest-level process groups.

| Level-0 ID | Level-0 Process | Purpose | Primary Owner |
| --- | --- | --- | --- |
| L0-01 | Research Ethics Application Lifecycle | Manage applications from preparation through initial review readiness. | Research Ethics Governance |
| L0-02 | Ethics Review and Decision Lifecycle | Manage reviewer assignment, review, deliberation, and decision. | Research Ethics Committee |
| L0-03 | Conditions and Evidence Lifecycle | Manage issued conditions, evidence, assessment, and resolution. | Research Ethics Governance |
| L0-04 | Approval and Post-Approval Lifecycle | Manage approval, certificates, amendments, continuing review, completion, and archival. | Research Governance Authority |
| L0-05 | Safety and Compliance Event Lifecycle | Manage safety reporting, protocol deviations, serious adverse events, and compliance follow-up. | Research Governance Authority |
| L0-06 | Governance Oversight and Audit Lifecycle | Manage oversight, audit readiness, audit activity, and governance risk review. | Research Governance Authority |
| L0-07 | Institutional Administration and Communication Lifecycle | Manage administrative coordination, stakeholder communication, responsibilities, and workload. | Institution Administration |
| L0-08 | Analytics, Reporting, and Cross-Institution Lifecycle | Manage operational reporting, executive reporting, oversight analytics, and cross-institution visibility. | Ministry Leadership |

## 5 Value Streams

Value streams describe end-to-end business value flow.

| Value Stream ID | Value Stream | Business Value | Key Processes |
| --- | --- | --- | --- |
| VS-01 | Research Ethics Submission to Decision | Turns research intent into an accountable ethics governance decision. | BP-001 through BP-007 |
| VS-02 | Conditions to Approval | Turns committee requirements and applicant evidence into resolved conditions and approval outcomes. | BP-008 through BP-011 |
| VS-03 | Approved Research Oversight | Maintains governance accountability after approval. | BP-012 through BP-018 |
| VS-04 | Governance Assurance | Provides oversight, audit readiness, compliance visibility, and risk control. | BP-019 through BP-024 |
| VS-05 | Institutional and National Governance Insight | Provides administration, communication, analytics, reporting, and adoption support. | BP-025 through BP-034 |

## 6 End-to-End Business Lifecycle

The end-to-end business lifecycle begins when a research activity is prepared for ethics governance.

The lifecycle continues through submission, screening, review, committee decision, conditions, evidence, approval, certificate issuance, post-approval governance, completion, archival, and audit.

The minimum lifecycle SHALL include Research Preparation, Application Submission, Administrative Screening, Reviewer Assignment, Scientific and Ethical Review, Committee Deliberation, Decision Recording, Conditions Management, Evidence Assessment, Approval, Certificate Issuance, Amendments, Continuing Review, Safety Reporting, Protocol Deviations, Serious Adverse Events, Study Completion, Final Report, Archiving, and Audit.

Not every research activity will require every lifecycle branch.

All lifecycle branches SHALL preserve business traceability.

| Sequence | Lifecycle Stage | Primary Process |
| --- | --- | --- |
| 1 | Research Preparation | BP-001 Research Preparation |
| 2 | Application Submission | BP-002 Application Submission |
| 3 | Administrative Screening | BP-003 Administrative Screening |
| 4 | Reviewer Assignment | BP-004 Reviewer Assignment |
| 5 | Scientific and Ethical Review | BP-005 Scientific and Ethical Review |
| 6 | Committee Deliberation | BP-006 Committee Deliberation |
| 7 | Decision Recording | BP-007 Decision Recording |
| 8 | Conditions Management | BP-008 Conditions Management |
| 9 | Evidence Assessment | BP-009 Evidence Assessment |
| 10 | Approval | BP-010 Approval Management |
| 11 | Certificate Issuance | BP-011 Certificate Issuance |
| 12 | Amendments | BP-012 Amendment Management |
| 13 | Continuing Review | BP-013 Continuing Review |
| 14 | Safety Reporting | BP-014 Safety Reporting |
| 15 | Protocol Deviations | BP-015 Protocol Deviation Management |
| 16 | Serious Adverse Events | BP-016 Serious Adverse Event Management |
| 17 | Study Completion | BP-017 Study Completion |
| 18 | Final Report | BP-018 Final Report Management |
| 19 | Archiving | BP-019 Archiving |
| 20 | Audit | BP-020 Audit |

## 7 Core Business Processes

Core business processes directly produce the primary research ethics governance outcome.

Core business processes include BP-001 through BP-011.

Core processes SHALL be prioritized in business modeling, future workflow design, and acceptance criteria.

Core processes SHALL preserve committee authority, applicant accountability, and governance traceability.

## 8 Supporting Business Processes

Supporting business processes enable the core lifecycle to operate.

Supporting business processes include amendment management, continuing review, final reporting, communication, workload coordination, reference guidance, and institutional onboarding.

Supporting processes SHOULD be aligned with core process states and business events.

## 9 Governance Processes

Governance processes protect compliance, oversight, auditability, and policy alignment.

Governance processes include safety reporting, protocol deviation management, serious adverse event management, archiving, audit, compliance oversight, governance risk monitoring, policy alignment, and governance record retrieval.

Governance processes SHALL be treated as business-critical where they protect participants, accountability, or institutional assurance.

## 10 Administrative Processes

Administrative processes coordinate institutional responsibilities and operational flow.

Administrative processes include administrative screening, role and responsibility administration, committee administration, workload coordination, communication, and request management.

Administrative processes SHALL support committee work without replacing committee authority.

## 11 Analytics Processes

Analytics processes convert governed activity into business insight.

Analytics processes include operational reporting, executive reporting, oversight analytics, performance monitoring, cross-institution trend analysis, and governance risk insight.

Analytics processes SHALL use approved business definitions.

Analytics processes SHALL NOT redefine committee decisions.

## 12 Cross-Institution Processes

Cross-institution processes support national adoption, institutional onboarding, external stakeholder coordination, and oversight visibility.

Cross-institution processes SHALL respect institutional responsibility and national governance expectations.

Cross-institution processes SHOULD support comparable definitions across participating institutions.

## 13 Process Decomposition

Processes are decomposed into Level 0 process groups and catalog-level business processes.

Further decomposition MAY be produced in future BPMN models or detailed business process specifications.

Future decomposition SHALL preserve the process IDs and business meanings in this document unless a formal change is approved.

| Level-0 Process | Catalog Processes |
| --- | --- |
| Research Ethics Application Lifecycle | BP-001, BP-002, BP-003 |
| Ethics Review and Decision Lifecycle | BP-004, BP-005, BP-006, BP-007 |
| Conditions and Evidence Lifecycle | BP-008, BP-009 |
| Approval and Post-Approval Lifecycle | BP-010, BP-011, BP-012, BP-013, BP-017, BP-018, BP-019 |
| Safety and Compliance Event Lifecycle | BP-014, BP-015, BP-016 |
| Governance Oversight and Audit Lifecycle | BP-020, BP-021, BP-022, BP-023, BP-024 |
| Institutional Administration and Communication Lifecycle | BP-025, BP-026, BP-027, BP-028, BP-029, BP-030 |
| Analytics, Reporting, and Cross-Institution Lifecycle | BP-031, BP-032, BP-033, BP-034 |

## 14 Process Ownership

Every process SHALL have a business owner.

Process owners SHALL be accountable for business meaning, controls, maturity, risk, and future change.

Process ownership MAY be assigned to a role or function when named individuals are not provided.

Committee-owned processes SHALL remain accountable to the Research Ethics Committee.

Administrative processes SHALL remain accountable to Institution Administration.

Oversight processes SHALL remain accountable to Research Governance Authority or Ministry Leadership as appropriate.

## 15 Process Inputs

Process inputs are business materials, events, decisions, requests, or records required for a process to begin or proceed.

Inputs SHALL be expressed in business terms.

Inputs SHOULD be traceable to domain entities or capability inputs where possible.

Inputs SHALL NOT be expressed as technical payloads or technical interfaces.

## 16 Process Outputs

Process outputs are business outcomes, records, decisions, requests, status changes, or evidence produced by a process.

Outputs SHALL be expressed in business terms.

Outputs SHOULD be consumable by downstream processes.

Outputs SHALL preserve accountability where they represent decisions, evidence, approvals, or governance records.

## 17 Trigger Events

Trigger events are business events that initiate a process.

Trigger events MAY originate from applicants, administrators, reviewers, committees, governance authorities, institutions, or external oversight needs.

Trigger events SHALL be named in domain language.

Trigger events SHOULD map to the business events defined in the Domain Model where possible.

## 18 Business Outcomes

Business outcomes define the value or state produced by a process.

Business outcomes SHALL be measurable where practical.

Business outcomes SHOULD support product success criteria, capability success measures, or governance accountability.

Business outcomes SHALL NOT be confused with technical completion.

## 19 Business Controls

Business controls reduce risk and preserve trust in process execution.

Controls MAY include ownership checks, completeness checks, eligibility checks, committee authority checks, evidence sufficiency checks, confidentiality checks, record retention checks, review gates, and approval gates.

Controls SHALL be proportional to process risk.

Controls SHALL NOT be bypassed for convenience.

## 20 Business Risks

Business risks describe potential harm, failure, delay, ambiguity, or governance weakness within a process.

Risks SHOULD be visible to process owners.

High-risk processes SHOULD have stronger controls and clearer success measures.

Risks SHALL be reviewed when process scope or governance expectations change.

## 21 Business Rules (High Level)

An application SHALL have an accountable principal investigator before formal ethics review.

An application SHALL be submitted before administrative screening.

Administrative screening SHOULD occur before reviewer assignment.

Reviewer assignment SHALL identify review responsibility.

Review outcomes SHOULD be available before committee deliberation when review is required.

Committee decisions SHALL be attributable to authorized committee authority.

Conditions SHALL be linked to the decision or governance requirement that created them.

Evidence SHALL be linked to the requirement it supports.

Approval SHALL follow an authorized decision and applicable condition status.

Certificates SHALL represent approved governance outcomes.

Amendments SHALL be reviewed according to approved governance expectations.

Safety reports, protocol deviations, and serious adverse events SHALL receive appropriate governance attention.

Final reports SHOULD be reviewed before study closure where governance rules require.

Archived records SHALL remain available for authorized audit or oversight.

## 22 Process Dependencies

Process dependencies SHALL be made visible before detailed process modeling.

| Process | Depends On | Dependency Meaning |
| --- | --- | --- |
| BP-002 Application Submission | BP-001 Research Preparation | Submission requires prepared materials. |
| BP-003 Administrative Screening | BP-002 Application Submission | Screening requires a submitted application. |
| BP-004 Reviewer Assignment | BP-003 Administrative Screening | Assignment requires review readiness. |
| BP-005 Scientific and Ethical Review | BP-004 Reviewer Assignment | Review requires assigned responsibility. |
| BP-006 Committee Deliberation | BP-005 Scientific and Ethical Review | Deliberation uses review outcomes when applicable. |
| BP-007 Decision Recording | BP-006 Committee Deliberation | Decision recording requires committee outcome. |
| BP-008 Conditions Management | BP-007 Decision Recording | Conditions arise from decision or governance requirement. |
| BP-009 Evidence Assessment | BP-008 Conditions Management | Evidence assessment requires submitted evidence or stated requirement. |
| BP-010 Approval Management | BP-007 Decision Recording, BP-009 Evidence Assessment | Approval depends on authorized decision and condition status. |
| BP-011 Certificate Issuance | BP-010 Approval Management | Certificate issuance depends on approval. |
| BP-020 Audit | BP-019 Archiving, BP-024 Governance Record Retrieval | Audit depends on retained and retrievable records. |

## 23 Process Interfaces

Process interfaces are business handoffs between processes, owners, or stakeholder groups.

Process interfaces SHALL be expressed as business exchanges.

Process interfaces SHALL NOT describe technical interfaces.

Key interfaces include applicant to administrator submission, administrator to reviewer assignment, reviewer to committee review outcome, committee to applicant decision communication, applicant to committee evidence response, committee to governance authority approval evidence, institution to oversight authority reporting, and oversight authority to institution compliance feedback.

Future BPMN models SHOULD make process interfaces explicit.

## 24 KPIs

KPIs SHALL measure business process performance and governance outcomes.

KPIs SHOULD be interpreted with care because faster processing is not always better governance.

| KPI | Process Scope | Business Meaning |
| --- | --- | --- |
| Submission completeness rate | BP-001 through BP-003 | Percentage of submissions passing screening without return. |
| Screening cycle time | BP-003 | Time from submission to screening outcome. |
| Review assignment timeliness | BP-004 | Time from readiness to reviewer assignment. |
| Review completion timeliness | BP-005 | Timeliness of reviewer response. |
| Decision recording completeness | BP-007 | Degree to which decisions include required outcome and rationale. |
| Condition resolution timeliness | BP-008, BP-009 | Time required to resolve issued conditions. |
| Approval traceability | BP-010, BP-011 | Degree to which approval can be traced to decision and conditions. |
| Amendment turnaround | BP-012 | Timeliness of amendment governance. |
| Safety event response timeliness | BP-014, BP-016 | Timeliness of governance attention to safety concerns. |
| Audit record retrieval success | BP-020, BP-024 | Ability to retrieve complete authorized records. |
| Reporting consistency | BP-031 through BP-034 | Consistency of business definitions across reports. |

## 25 Process Maturity

Process maturity SHALL support planning and improvement.

| Maturity | Definition |
| --- | --- |
| Initial | Process exists informally or inconsistently. |
| Defined | Process has agreed business meaning and core responsibilities. |
| Managed | Process is measured, governed, and actively improved. |
| Optimized | Process is mature, evidence-driven, and continuously improved. |

Current maturity in this document is an initial business architecture assessment.

Future maturity ratings SHOULD be validated by process owners.

## 26 Process Priorities

Process priorities SHALL guide modeling, roadmap, release planning, and gap analysis.

Critical processes are required for trustworthy research ethics governance.

High priority processes are required for scale, consistency, auditability, and institutional adoption.

Medium priority processes support future maturity or expanded governance value.

Priority SHALL NOT be treated as technical delivery sequence without roadmap review.

## 27 Future Process Evolution

Future process evolution SHOULD be driven by product scope, domain terminology, capability maturity, governance needs, stakeholder feedback, and national adoption strategy.

Future BPMN models SHOULD use this process architecture as the business baseline.

Future state machine analysis SHOULD use this process architecture as a business reference.

Future process changes SHOULD preserve traceability to process IDs, business owners, and capability mappings.

Future process expansion MAY include accreditation, training governance, multi-institution study coordination, sponsor coordination, and broader policy alignment processes after business approval.

## 28 References

`docs/product/PRODUCT_DEFINITION.md`: Authoritative product definition.

`docs/domain/DOMAIN_MODEL.md`: Authoritative domain terminology and business concepts.

`docs/business/BUSINESS_CAPABILITY_MODEL.md`: Authoritative business capability model.

`docs/governance/ENGINEERING_MANIFEST.md`: Root engineering governance reference.

`docs/governance/ENGINEERING_DOCUMENTATION_STANDARD.md`: Documentation standard.

RFC 2119: Key words for use in RFCs to Indicate Requirement Levels.

## 29 Appendix A - Process Catalog

Every process below includes the mandatory process attributes required by this specification.

### BP-001 Research Preparation

Process ID: BP-001

Process Name: Research Preparation

Business Purpose: Prepare research information and supporting materials for ethics governance.

Business Owner: Principal Investigator

Business Trigger: A research activity is expected to require ethics governance.

Business Inputs: Research purpose, methodology summary, participant considerations, supporting materials, governance guidance.

Business Outputs: Prepared application material, research information summary, supporting material set.

Business Consumers: Applicants, ethics administrators, reviewers, committees.

Business Dependencies: Product scope, Domain Model terminology, Reference and Knowledge Management.

Business Controls: Principal investigator accountability, completeness expectations, approved guidance.

Business Risks: Incomplete material, unclear research description, missing participant protection information.

Success Measures: Prepared materials are complete enough for submission and screening.

Priority: Critical

Maturity: Initial

### BP-002 Application Submission

Process ID: BP-002

Process Name: Application Submission

Business Purpose: Formally place an application into the ethics governance process.

Business Owner: Principal Investigator

Business Trigger: Prepared application material is ready for submission.

Business Inputs: Prepared application, applicant declaration, supporting materials.

Business Outputs: Submitted application, submission acknowledgement, initial governance record.

Business Consumers: Applicants, ethics administrators, committees.

Business Dependencies: BP-001 Research Preparation.

Business Controls: Accountable submitter, required declarations, submission completeness expectations.

Business Risks: Unauthorized submission, incomplete submission, unclear accountability.

Success Measures: Submission is attributable, traceable, and ready for administrative screening.

Priority: Critical

Maturity: Defined

### BP-003 Administrative Screening

Process ID: BP-003

Process Name: Administrative Screening

Business Purpose: Assess whether a submitted application is complete enough to proceed to review.

Business Owner: Institution Administration

Business Trigger: Application Submitted.

Business Inputs: Submitted application, completeness expectations, institutional governance rules.

Business Outputs: Screening outcome, readiness confirmation, return for correction, status update.

Business Consumers: Applicants, reviewers, committees, administrators.

Business Dependencies: BP-002 Application Submission, approved screening expectations.

Business Controls: Completeness review, administrative return for correction, screening accountability.

Business Risks: Inconsistent screening, avoidable review delays, incorrect routing.

Success Measures: Screening outcomes are timely, consistent, and clearly communicated.

Priority: Critical

Maturity: Defined

### BP-004 Reviewer Assignment

Process ID: BP-004

Process Name: Reviewer Assignment

Business Purpose: Allocate review responsibility to suitable reviewers.

Business Owner: Research Ethics Committee

Business Trigger: Application is ready for review.

Business Inputs: Review-ready application, reviewer eligibility information, workload visibility, conflict considerations.

Business Outputs: Review assignment, expected review action, review deadline.

Business Consumers: Reviewers, committee chairs, ethics administrators.

Business Dependencies: BP-003 Administrative Screening, committee administration, role responsibility administration.

Business Controls: Reviewer eligibility, conflict awareness, assignment accountability.

Business Risks: Inappropriate reviewer selection, workload imbalance, delayed review assignment.

Success Measures: Assignments are appropriate, accepted, and timely.

Priority: Critical

Maturity: Initial

### BP-005 Scientific and Ethical Review

Process ID: BP-005

Process Name: Scientific and Ethical Review

Business Purpose: Evaluate submitted materials for scientific and ethical considerations relevant to committee decision making.

Business Owner: Research Ethics Committee

Business Trigger: Review assignment has been issued.

Business Inputs: Assigned application, supporting materials, review expectations, domain guidance.

Business Outputs: Review outcome, findings, recommendation, clarification request where needed.

Business Consumers: Committee chair, committee members, ethics administrators, applicants.

Business Dependencies: BP-004 Reviewer Assignment.

Business Controls: Reviewer accountability, review expectations, confidentiality expectations.

Business Risks: Incomplete review, late review, inconsistent assessment, unclear findings.

Success Measures: Review outcomes are timely, documented, and useful for deliberation.

Priority: Critical

Maturity: Defined

### BP-006 Committee Deliberation

Process ID: BP-006

Process Name: Committee Deliberation

Business Purpose: Enable authorized committee consideration of application materials and review outcomes.

Business Owner: Research Ethics Committee

Business Trigger: Application is ready for committee decision.

Business Inputs: Application materials, review outcomes, committee agenda, governance criteria.

Business Outputs: Deliberation outcome, decision direction, required actions.

Business Consumers: Committee chair, committee members, ethics administrators.

Business Dependencies: BP-005 Scientific and Ethical Review where review is required.

Business Controls: Committee authority, quorum or participation expectations where applicable, conflict awareness.

Business Risks: Insufficient information, unclear deliberation outcome, weak decision rationale.

Success Measures: Deliberation produces an accountable decision direction.

Priority: Critical

Maturity: Initial

### BP-007 Decision Recording

Process ID: BP-007

Process Name: Decision Recording

Business Purpose: Capture formal committee decision, outcome, conditions, and rationale.

Business Owner: Research Ethics Committee

Business Trigger: Committee deliberation has produced a decision outcome.

Business Inputs: Deliberation outcome, decision terms, conditions, rationale.

Business Outputs: Committee decision, decision record, communicated outcome.

Business Consumers: Applicants, administrators, committees, oversight authorities.

Business Dependencies: BP-006 Committee Deliberation.

Business Controls: Authorized decision owner, decision completeness, rationale capture.

Business Risks: Ambiguous decision, missing rationale, weak audit evidence.

Success Measures: Decision is complete, attributable, traceable, and communicated.

Priority: Critical

Maturity: Defined

### BP-008 Conditions Management

Process ID: BP-008

Process Name: Conditions Management

Business Purpose: Manage conditions issued by governance authority and required applicant responses.

Business Owner: Research Ethics Governance

Business Trigger: Committee decision creates one or more conditions.

Business Inputs: Committee decision, condition terms, required actions, applicant response.

Business Outputs: Issued condition, condition status, response request, updated governance record.

Business Consumers: Applicants, principal investigators, administrators, committees.

Business Dependencies: BP-007 Decision Recording.

Business Controls: Condition clarity, ownership, due expectation where applicable, status traceability.

Business Risks: Unclear conditions, delayed responses, lost accountability.

Success Measures: Conditions are understandable, assigned, tracked, and resolvable.

Priority: Critical

Maturity: Defined

### BP-009 Evidence Assessment

Process ID: BP-009

Process Name: Evidence Assessment

Business Purpose: Determine whether submitted evidence satisfies a condition or governance requirement.

Business Owner: Research Ethics Governance

Business Trigger: Evidence Submitted.

Business Inputs: Submitted evidence, condition terms, review expectation, prior decision.

Business Outputs: Evidence assessment outcome, accepted evidence, rejection reason, further request.

Business Consumers: Applicants, committees, reviewers, administrators.

Business Dependencies: BP-008 Conditions Management.

Business Controls: Evidence sufficiency review, rejection rationale, reviewer or committee authority.

Business Risks: Insufficient evidence accepted, sufficient evidence rejected, unclear next action.

Success Measures: Assessment outcomes are justified, traceable, and actionable.

Priority: Critical

Maturity: Initial

### BP-010 Approval Management

Process ID: BP-010

Process Name: Approval Management

Business Purpose: Record and govern a positive ethics outcome under defined terms.

Business Owner: Research Ethics Committee

Business Trigger: Authorized decision and applicable condition status support approval.

Business Inputs: Approval decision, condition resolution status, approval terms.

Business Outputs: Active approval, approval status, approval record.

Business Consumers: Principal investigators, institutions, oversight authorities.

Business Dependencies: BP-007 Decision Recording, BP-009 Evidence Assessment where applicable.

Business Controls: Authorized approval, condition status verification, approval traceability.

Business Risks: Premature approval, unclear terms, weak linkage to decision.

Success Measures: Approval is authorized, current, traceable, and understandable.

Priority: Critical

Maturity: Defined

### BP-011 Certificate Issuance

Process ID: BP-011

Process Name: Certificate Issuance

Business Purpose: Provide formal business representation of an approved ethics governance outcome.

Business Owner: Research Ethics Governance

Business Trigger: Approval Granted.

Business Inputs: Approval record, approval terms, authorized sign-off.

Business Outputs: Certificate, certificate status, certificate record.

Business Consumers: Principal investigators, institutions, regulatory stakeholders.

Business Dependencies: BP-010 Approval Management.

Business Controls: Certificate accuracy, approval linkage, authorized issuance.

Business Risks: Certificate misstates approval, outdated certificate, unclear validity.

Success Measures: Certificates accurately represent approved outcomes.

Priority: High

Maturity: Initial

### BP-012 Amendment Management

Process ID: BP-012

Process Name: Amendment Management

Business Purpose: Manage proposed changes to approved or active research governance arrangements.

Business Owner: Research Governance Authority

Business Trigger: Amendment Requested.

Business Inputs: Amendment request, current approval information, change description, supporting evidence.

Business Outputs: Amendment review outcome, updated governance status, decision record.

Business Consumers: Principal investigators, committees, administrators, oversight authorities.

Business Dependencies: BP-010 Approval Management, BP-005 Scientific and Ethical Review where required.

Business Controls: Amendment completeness, ethical significance assessment, committee authority where required.

Business Risks: Ungoverned research changes, unclear amendment scope, delayed decision.

Success Measures: Amendments are reviewed appropriately and linked to existing governance status.

Priority: High

Maturity: Initial

### BP-013 Continuing Review

Process ID: BP-013

Process Name: Continuing Review

Business Purpose: Review ongoing research governance status where continuing oversight is required.

Business Owner: Research Governance Authority

Business Trigger: Continuing review due date, governance requirement, or oversight request.

Business Inputs: Approval status, progress information, safety information, compliance information.

Business Outputs: Continuing review outcome, required action, updated governance record.

Business Consumers: Principal investigators, committees, governance officers, oversight authorities.

Business Dependencies: BP-010 Approval Management, BP-031 Operational Reporting.

Business Controls: Review due tracking, responsible owner, committee or governance authority review.

Business Risks: Ongoing research not reviewed, expired oversight, missed compliance concerns.

Success Measures: Continuing review occurs when required and produces clear outcome.

Priority: High

Maturity: Initial

### BP-014 Safety Reporting

Process ID: BP-014

Process Name: Safety Reporting

Business Purpose: Receive and govern safety information related to approved or active research.

Business Owner: Research Governance Authority

Business Trigger: Safety concern or required safety report is identified.

Business Inputs: Safety report, research project information, approval status, participant protection concern.

Business Outputs: Safety governance record, required action, escalation where needed.

Business Consumers: Committees, governance officers, principal investigators, oversight authorities.

Business Dependencies: BP-010 Approval Management, BP-013 Continuing Review where applicable.

Business Controls: Timely reporting, severity assessment, escalation criteria, confidentiality expectations.

Business Risks: Delayed reporting, insufficient response, participant protection risk.

Success Measures: Safety reports receive timely and appropriate governance attention.

Priority: Critical

Maturity: Initial

### BP-015 Protocol Deviation Management

Process ID: BP-015

Process Name: Protocol Deviation Management

Business Purpose: Manage reported departures from approved research arrangements.

Business Owner: Research Governance Authority

Business Trigger: Protocol deviation is identified or reported.

Business Inputs: Deviation report, approval terms, research project information, corrective action proposal.

Business Outputs: Deviation assessment, corrective action, governance record, escalation where needed.

Business Consumers: Principal investigators, committees, governance officers, oversight authorities.

Business Dependencies: BP-010 Approval Management, BP-021 Compliance Oversight.

Business Controls: Deviation classification, corrective action review, escalation criteria.

Business Risks: Repeated deviations, uncorrected non-compliance, participant protection concern.

Success Measures: Deviations are assessed, recorded, and followed up appropriately.

Priority: Critical

Maturity: Initial

### BP-016 Serious Adverse Event Management

Process ID: BP-016

Process Name: Serious Adverse Event Management

Business Purpose: Manage serious adverse event reports requiring heightened governance attention.

Business Owner: Research Governance Authority

Business Trigger: Serious adverse event is reported or identified.

Business Inputs: Serious adverse event report, research project information, safety context, approval status.

Business Outputs: Serious adverse event governance record, escalation, required action, committee attention where required.

Business Consumers: Committees, governance authorities, principal investigators, regulatory bodies.

Business Dependencies: BP-014 Safety Reporting, BP-021 Compliance Oversight.

Business Controls: Timely escalation, severity assessment, confidentiality expectations, oversight notification where applicable.

Business Risks: Participant harm, delayed governance response, inadequate escalation.

Success Measures: Serious adverse events receive urgent, accountable, and traceable governance handling.

Priority: Critical

Maturity: Initial

### BP-017 Study Completion

Process ID: BP-017

Process Name: Study Completion

Business Purpose: Record that approved research activity has reached completion from a governance perspective.

Business Owner: Principal Investigator

Business Trigger: Research activity has completed or is ready for closure.

Business Inputs: Completion notice, approval status, outstanding conditions, final reporting expectations.

Business Outputs: Completion record, closure readiness status, final report request where applicable.

Business Consumers: Administrators, committees, governance authorities.

Business Dependencies: BP-010 Approval Management, BP-013 Continuing Review where applicable.

Business Controls: Outstanding obligation check, accountable completion declaration.

Business Risks: Premature closure, unresolved obligations, incomplete final evidence.

Success Measures: Completion status is clear and linked to closure requirements.

Priority: High

Maturity: Initial

### BP-018 Final Report Management

Process ID: BP-018

Process Name: Final Report Management

Business Purpose: Receive and assess final research reporting required for governance closure.

Business Owner: Research Governance Authority

Business Trigger: Study completion or final report due expectation.

Business Inputs: Final report, completion information, approval terms, unresolved governance items.

Business Outputs: Final report outcome, closure recommendation, retained governance record.

Business Consumers: Committees, governance authorities, institutions, oversight authorities.

Business Dependencies: BP-017 Study Completion.

Business Controls: Final report completeness, unresolved issue check, accountable review.

Business Risks: Missing final report, incomplete closure evidence, weak institutional memory.

Success Measures: Final reports are received, assessed, and retained where required.

Priority: High

Maturity: Initial

### BP-019 Archiving

Process ID: BP-019

Process Name: Archiving

Business Purpose: Retain governance records after active processing or closure.

Business Owner: Institution Administration

Business Trigger: Application, approval, research project, or governance record reaches archival state.

Business Inputs: Governance records, closure status, retention expectations, audit needs.

Business Outputs: Archived record, archive status, retained evidence.

Business Consumers: Institutions, oversight authorities, auditors, governance authorities.

Business Dependencies: BP-017 Study Completion, BP-018 Final Report Management where applicable.

Business Controls: Retention rules, archival authorization, confidentiality expectations.

Business Risks: Record loss, unauthorized access, incomplete archival package.

Success Measures: Archived records are complete, protected, and retrievable for authorized purposes.

Priority: Critical

Maturity: Initial

### BP-020 Audit

Process ID: BP-020

Process Name: Audit

Business Purpose: Examine governance records, actions, decisions, or processes for accountability and assurance.

Business Owner: Authorized Audit or Oversight Authority

Business Trigger: Audit request, oversight review, compliance concern, scheduled assurance activity.

Business Inputs: Audit scope, governance records, decision evidence, communication records, approval records.

Business Outputs: Audit finding, audit evidence package, recommendations, follow-up actions.

Business Consumers: Ministry leadership, institutions, research governance authorities, regulatory bodies.

Business Dependencies: BP-019 Archiving, BP-024 Governance Record Retrieval.

Business Controls: Authorized audit purpose, confidentiality, evidence completeness, finding review.

Business Risks: Incomplete evidence, unclear audit scope, unsupported findings.

Success Measures: Audit can confirm governance activity using complete and reliable records.

Priority: Critical

Maturity: Initial

### BP-021 Compliance Oversight

Process ID: BP-021

Process Name: Compliance Oversight

Business Purpose: Monitor alignment between research ethics governance activity and approved expectations.

Business Owner: Research Governance Authority

Business Trigger: Oversight schedule, compliance signal, audit finding, governance concern.

Business Inputs: Governance records, compliance expectations, process activity, exception information.

Business Outputs: Compliance observation, exception record, follow-up recommendation.

Business Consumers: Governance authorities, institutions, committees, regulatory bodies.

Business Dependencies: Core lifecycle processes, BP-020 Audit.

Business Controls: Approved compliance criteria, owner assignment, follow-up tracking.

Business Risks: Undetected non-compliance, inconsistent interpretation, unresolved exceptions.

Success Measures: Compliance concerns are visible, assigned, and followed up.

Priority: Critical

Maturity: Initial

### BP-022 Governance Risk Monitoring

Process ID: BP-022

Process Name: Governance Risk Monitoring

Business Purpose: Identify and monitor business risks in research ethics governance activity.

Business Owner: Research Governance Authority

Business Trigger: Risk indicator, performance trend, compliance observation, escalation request.

Business Inputs: Delays, exceptions, overdue actions, review trends, safety events, compliance concerns.

Business Outputs: Risk indicator, escalation item, mitigation recommendation.

Business Consumers: Ministry leadership, institution leadership, governance officers.

Business Dependencies: BP-021 Compliance Oversight, BP-033 Oversight Analytics.

Business Controls: Risk classification, owner assignment, escalation criteria.

Business Risks: Hidden governance risk, delayed mitigation, inconsistent escalation.

Success Measures: Material governance risks are identified and acted upon.

Priority: High

Maturity: Initial

### BP-023 Policy Alignment

Process ID: BP-023

Process Name: Policy Alignment

Business Purpose: Align research ethics business practice with approved policies and governance expectations.

Business Owner: Research Governance Authority

Business Trigger: Policy change, compliance finding, stakeholder question, governance review.

Business Inputs: Approved policies, guidance, governance decisions, compliance observations.

Business Outputs: Policy interpretation, alignment finding, change recommendation.

Business Consumers: Committees, administrators, researchers, oversight authorities.

Business Dependencies: Reference and Knowledge Management, BP-021 Compliance Oversight.

Business Controls: Authorized interpretation, version awareness, governance owner review.

Business Risks: Conflicting interpretations, outdated guidance, inconsistent institutional practice.

Success Measures: Governance practice remains aligned with approved policy expectations.

Priority: High

Maturity: Initial

### BP-024 Governance Record Retrieval

Process ID: BP-024

Process Name: Governance Record Retrieval

Business Purpose: Retrieve retained governance records for authorized review, audit, oversight, or institutional need.

Business Owner: Institution Administration

Business Trigger: Authorized record request.

Business Inputs: Record request, governance identifier, retrieval purpose, authorization basis.

Business Outputs: Retrieved record, retrieval outcome, evidence package where needed.

Business Consumers: Auditors, oversight authorities, institution leadership, governance authorities.

Business Dependencies: BP-019 Archiving.

Business Controls: Authorized purpose, confidentiality, record completeness, retrieval traceability.

Business Risks: Unauthorized retrieval, incomplete records, delayed audit response.

Success Measures: Records are retrievable, complete, and understandable for authorized purposes.

Priority: Critical

Maturity: Initial

### BP-025 Role and Responsibility Administration

Process ID: BP-025

Process Name: Role and Responsibility Administration

Business Purpose: Maintain business responsibility assignments for stakeholders participating in governance.

Business Owner: Institution Administration

Business Trigger: Institution onboarding, role change, committee change, responsibility review.

Business Inputs: Stakeholder role information, committee membership, administrative responsibilities.

Business Outputs: Responsibility assignment, role record, accountability visibility.

Business Consumers: Administrators, committees, oversight authorities.

Business Dependencies: Institutional governance model, policy alignment.

Business Controls: Authorized assignment, role review, responsibility clarity.

Business Risks: Ambiguous responsibility, unauthorized participation, outdated role information.

Success Measures: Responsibility assignments are current and unambiguous.

Priority: High

Maturity: Defined

### BP-026 Committee Administration

Process ID: BP-026

Process Name: Committee Administration

Business Purpose: Coordinate committee membership, readiness, meeting support, and workload.

Business Owner: Institution Administration

Business Trigger: Committee setup, membership update, meeting cycle, review workload need.

Business Inputs: Committee membership, meeting needs, review workload, governance schedule.

Business Outputs: Committee readiness, membership record, meeting support information.

Business Consumers: Committee chairs, reviewers, administrators, governance authorities.

Business Dependencies: BP-025 Role and Responsibility Administration.

Business Controls: Committee membership review, readiness check, meeting support accountability.

Business Risks: Committee unavailable, outdated membership, review bottlenecks.

Success Measures: Committees are ready to perform authorized responsibilities.

Priority: High

Maturity: Initial

### BP-027 Workload Coordination

Process ID: BP-027

Process Name: Workload Coordination

Business Purpose: Coordinate visible work across applications, reviews, conditions, and committee actions.

Business Owner: Institution Administration

Business Trigger: New work item, overdue action, workload review, committee planning need.

Business Inputs: Application status, review assignments, condition status, committee schedule.

Business Outputs: Workload view, prioritization input, overdue action visibility.

Business Consumers: Administrators, committee chairs, institution leadership.

Business Dependencies: Core lifecycle processes, BP-031 Operational Reporting.

Business Controls: Workload review, overdue action visibility, escalation criteria.

Business Risks: Delays, overload, hidden bottlenecks, missed actions.

Success Measures: Workload risks are visible and actionable.

Priority: High

Maturity: Initial

### BP-028 Business Notification Management

Process ID: BP-028

Process Name: Business Notification Management

Business Purpose: Provide business notices related to status, required action, review activity, and decision outcomes.

Business Owner: Institution Administration

Business Trigger: Business event, required action, decision outcome, review milestone.

Business Inputs: Business event, recipient responsibility, communication rule, message purpose.

Business Outputs: Notification, reminder, notice record.

Business Consumers: Applicants, reviewers, administrators, committees.

Business Dependencies: Application Status Management, Decision Recording, Conditions Management.

Business Controls: Recipient relevance, message clarity, communication record.

Business Risks: Missed notification, unclear message, inappropriate disclosure.

Success Measures: Notices are timely, relevant, and traceable.

Priority: High

Maturity: Defined

### BP-029 Stakeholder Request Management

Process ID: BP-029

Process Name: Stakeholder Request Management

Business Purpose: Manage requests for information, clarification, action, or follow-up.

Business Owner: Institution Administration

Business Trigger: Clarification need, condition request, administrative request, stakeholder question.

Business Inputs: Request purpose, responsible party, supporting context, due expectation where applicable.

Business Outputs: Stakeholder request, response, request status.

Business Consumers: Applicants, administrators, reviewers, committees.

Business Dependencies: BP-028 Business Notification Management, BP-008 Conditions Management.

Business Controls: Request ownership, response tracking, clarity of required action.

Business Risks: Unanswered requests, unclear ownership, delayed responses.

Success Measures: Requests are clear, assigned, tracked, and resolved.

Priority: High

Maturity: Initial

### BP-030 Communication Record Management

Process ID: BP-030

Process Name: Communication Record Management

Business Purpose: Retain business communication records that support traceability and accountability.

Business Owner: Institution Administration

Business Trigger: Business communication is issued or received.

Business Inputs: Notice, request, response, decision communication, stakeholder message.

Business Outputs: Communication record, communication history.

Business Consumers: Administrators, committees, oversight authorities, auditors.

Business Dependencies: BP-028 Business Notification Management, BP-029 Stakeholder Request Management.

Business Controls: Record retention, confidentiality expectation, communication linkage.

Business Risks: Lost communication history, incomplete audit trail, unclear stakeholder action.

Success Measures: Communication records are complete and retrievable for authorized purposes.

Priority: Medium

Maturity: Initial

### BP-031 Operational Reporting

Process ID: BP-031

Process Name: Operational Reporting

Business Purpose: Provide day-to-day visibility into applications, reviews, conditions, workload, and required actions.

Business Owner: Institution Administration

Business Trigger: Operational monitoring need, work planning cycle, overdue action review.

Business Inputs: Application status, review status, condition status, workload information.

Business Outputs: Operational report, action list, workload summary.

Business Consumers: Administrators, committee chairs, reviewers, institution leadership.

Business Dependencies: Core lifecycle processes, BP-027 Workload Coordination.

Business Controls: Approved business definitions, report ownership, confidentiality expectation.

Business Risks: Misleading report, inconsistent definitions, hidden overdue work.

Success Measures: Reports support timely action and reduced delays.

Priority: High

Maturity: Initial

### BP-032 Executive Reporting

Process ID: BP-032

Process Name: Executive Reporting

Business Purpose: Provide leadership-level visibility into governance performance, volume, risk, and outcomes.

Business Owner: Ministry Leadership

Business Trigger: Executive review cycle, strategic oversight need, governance reporting request.

Business Inputs: Aggregated activity, performance indicators, risk indicators, institutional summaries.

Business Outputs: Executive summary, trend view, strategic reporting.

Business Consumers: Ministry leadership, institution leadership, governance authorities.

Business Dependencies: BP-031 Operational Reporting, BP-022 Governance Risk Monitoring.

Business Controls: Approved definitions, authorized audience, interpretation review.

Business Risks: Misinterpretation, inconsistent aggregation, incomplete context.

Success Measures: Leaders can understand governance performance and priority issues.

Priority: High

Maturity: Initial

### BP-033 Oversight Analytics

Process ID: BP-033

Process Name: Oversight Analytics

Business Purpose: Analyze governance patterns, risks, compliance signals, and cross-institution trends.

Business Owner: Research Governance Authority

Business Trigger: Oversight analysis cycle, governance risk question, policy planning need.

Business Inputs: Governance activity, risk indicators, compliance observations, institution information.

Business Outputs: Oversight insight, trend analysis, improvement recommendation.

Business Consumers: Research governance authorities, ministry leadership, regulatory stakeholders.

Business Dependencies: BP-021 Compliance Oversight, BP-032 Executive Reporting.

Business Controls: Approved definitions, interpretation review, confidentiality expectation.

Business Risks: Unsupported conclusions, inconsistent comparison, insufficient context.

Success Measures: Analytics identify meaningful trends and support action.

Priority: Medium

Maturity: Initial

### BP-034 Cross-Institution Coordination

Process ID: BP-034

Process Name: Cross-Institution Coordination

Business Purpose: Coordinate national adoption, institutional onboarding, external stakeholder alignment, and future process improvement.

Business Owner: Ministry Leadership

Business Trigger: National adoption phase, institution onboarding need, external stakeholder request, future capability assessment.

Business Inputs: Adoption goals, readiness findings, stakeholder needs, maturity findings.

Business Outputs: Adoption plan, onboarding approach, stakeholder coordination record, future process candidate.

Business Consumers: Ministry leadership, institutions, governance authorities, regulatory stakeholders.

Business Dependencies: BP-032 Executive Reporting, BP-033 Oversight Analytics, approved governance direction.

Business Controls: Governance sponsorship, readiness assessment, stakeholder accountability.

Business Risks: Misaligned adoption, unclear ownership, inconsistent institutional practice.

Success Measures: Cross-institution coordination is planned, governed, and aligned with business value.

Priority: Medium

Maturity: Initial

## 30 Appendix B - End-to-End Process Matrix

| Lifecycle Area | Process ID | Process Name | Primary Capability | Primary Owner | Priority |
| --- | --- | --- | --- | --- | --- |
| Preparation | BP-001 | Research Preparation | Application Preparation | Principal Investigator | Critical |
| Submission | BP-002 | Application Submission | Application Submission | Principal Investigator | Critical |
| Screening | BP-003 | Administrative Screening | Administrative Screening | Institution Administration | Critical |
| Review Assignment | BP-004 | Reviewer Assignment | Reviewer Assignment | Research Ethics Committee | Critical |
| Review | BP-005 | Scientific and Ethical Review | Review Assessment | Research Ethics Committee | Critical |
| Deliberation | BP-006 | Committee Deliberation | Committee Deliberation | Research Ethics Committee | Critical |
| Decision | BP-007 | Decision Recording | Decision Recording | Research Ethics Committee | Critical |
| Conditions | BP-008 | Conditions Management | Condition Management | Research Ethics Governance | Critical |
| Evidence | BP-009 | Evidence Assessment | Evidence Assessment | Research Ethics Governance | Critical |
| Approval | BP-010 | Approval Management | Approval Management | Research Ethics Committee | Critical |
| Certificate | BP-011 | Certificate Issuance | Certificate Management | Research Ethics Governance | High |
| Amendment | BP-012 | Amendment Management | Amendment Governance | Research Governance Authority | High |
| Continuing Review | BP-013 | Continuing Review | Research Lifecycle Oversight | Research Governance Authority | High |
| Safety | BP-014 | Safety Reporting | Governance Oversight and Compliance | Research Governance Authority | Critical |
| Deviation | BP-015 | Protocol Deviation Management | Governance Oversight and Compliance | Research Governance Authority | Critical |
| Serious Event | BP-016 | Serious Adverse Event Management | Governance Oversight and Compliance | Research Governance Authority | Critical |
| Completion | BP-017 | Study Completion | Closure and Archival Governance | Principal Investigator | High |
| Final Report | BP-018 | Final Report Management | Closure and Archival Governance | Research Governance Authority | High |
| Archive | BP-019 | Archiving | Closure and Archival Governance | Institution Administration | Critical |
| Audit | BP-020 | Audit | Audit Readiness | Authorized Audit or Oversight Authority | Critical |
| Compliance | BP-021 | Compliance Oversight | Compliance Oversight | Research Governance Authority | Critical |
| Risk | BP-022 | Governance Risk Monitoring | Governance Risk Monitoring | Research Governance Authority | High |
| Policy | BP-023 | Policy Alignment | Policy Alignment | Research Governance Authority | High |
| Records | BP-024 | Governance Record Retrieval | Governance Record Retrieval | Institution Administration | Critical |
| Responsibility | BP-025 | Role and Responsibility Administration | Role and Responsibility Administration | Institution Administration | High |
| Committee Admin | BP-026 | Committee Administration | Committee Administration | Institution Administration | High |
| Workload | BP-027 | Workload Coordination | Workload Coordination | Institution Administration | High |
| Notification | BP-028 | Business Notification Management | Business Notification Management | Institution Administration | High |
| Request | BP-029 | Stakeholder Request Management | Stakeholder Request Management | Institution Administration | High |
| Communication | BP-030 | Communication Record Management | Communication Record Management | Institution Administration | Medium |
| Operations Reporting | BP-031 | Operational Reporting | Operational Reporting | Institution Administration | High |
| Executive Reporting | BP-032 | Executive Reporting | Executive Reporting | Ministry Leadership | High |
| Oversight Analytics | BP-033 | Oversight Analytics | Oversight Analytics | Research Governance Authority | Medium |
| Cross-Institution | BP-034 | Cross-Institution Coordination | Ecosystem Coordination and Future Expansion | Ministry Leadership | Medium |
