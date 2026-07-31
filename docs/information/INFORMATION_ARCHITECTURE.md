# Enterprise Information Architecture

## Document Metadata

Document ID: SPEC-0010

Title: Enterprise Information Architecture

Status: Approved

Version: 1.0

Owner: Chief Information Architecture

Approvers: Product Governance, Research Governance Authority, Enterprise Architecture

Reviewers: Enterprise Business Architecture, Domain Architecture, Enterprise Business Process Architecture, Business Rules Architecture, Security Governance, Data Governance

Classification: Specification

Audience: Ministry Leadership, Research Governance Authorities, Institution Administrators, Research Ethics Committees, Researchers, Principal Investigators, Reviewers, Hospitals, Universities, Regulatory Bodies, Enterprise Architects, Data Architects, Business Analysts, Security Engineers, and Future Contributors

Created: 2026-07-31

Last Updated: 2026-07-31

Next Review: To be scheduled by Chief Information Architecture

Related Documents: `docs/product/PRODUCT_DEFINITION.md`, `docs/domain/DOMAIN_MODEL.md`, `docs/business/BUSINESS_CAPABILITY_MODEL.md`, `docs/business/BUSINESS_PROCESS_ARCHITECTURE.md`, `docs/business/BUSINESS_RULES_FRAMEWORK.md`, `docs/governance/ENGINEERING_MANIFEST.md`, `docs/governance/ENGINEERING_DOCUMENTATION_STANDARD.md`

Depends On: `docs/product/PRODUCT_DEFINITION.md`, `docs/domain/DOMAIN_MODEL.md`, `docs/business/BUSINESS_CAPABILITY_MODEL.md`, `docs/business/BUSINESS_PROCESS_ARCHITECTURE.md`, `docs/business/BUSINESS_RULES_FRAMEWORK.md`

References: RFC 2119

Keywords: information architecture, information objects, information governance, data architecture foundation, research ethics, information lifecycle

Confidentiality: Internal

## Normative Language

The key words MUST, MUST NOT, SHALL, SHALL NOT, SHOULD, SHOULD NOT, and MAY in this document are to be interpreted as described by RFC 2119 when used as normative terms.

## 1 Executive Summary

This Enterprise Information Architecture defines the complete business information landscape for ERM-System.

ERM-System is an Enterprise Research Ethics Management Platform supporting the complete lifecycle of ethical governance for health research.

This document describes information domains, information owners, information producers, information consumers, information objects, master data, transactional data, reference data, metadata, business documents, classification, confidentiality, data quality principles, lifecycle, governance, stewardship, traceability, sharing, retention, archiving, risks, controls, and roadmap.

This document SHALL become the authoritative reference for future Data Architecture and Database Design work.

This document remains completely technology independent.

It does not define database tables, SQL, APIs, software classes, implementation mechanisms, or technical storage models.

Future data architecture work SHALL preserve the business information meanings defined here unless superseded by an approved information architecture decision.

## 2 Information Architecture Vision

The vision is to establish a trusted business information foundation for research ethics governance.

ERM-System information SHALL support participant protection, accountable review, transparent decisions, evidence-based oversight, institutional reporting, audit readiness, and national governance maturity.

Information SHALL be treated as a governed enterprise asset.

Information SHOULD remain understandable to business owners and future data architects.

Information architecture SHALL connect product purpose, domain terminology, business capabilities, business processes, and business rules.

Information architecture SHALL separate business information meaning from implementation choices.

## 3 Information Principles

Information SHALL be defined in business language.

Information SHALL have business ownership.

Information SHALL have a producer and consumer context.

Information SHALL have classification and confidentiality expectations.

Information SHALL be traceable to related domain entities, business processes, and business capabilities.

Information SHOULD be captured once by the accountable producer and reused according to authorized purpose.

Information SHOULD be complete, accurate, timely, consistent, and understandable.

Information SHALL be retained and archived according to approved business principles.

Information SHALL NOT be defined primarily by implementation structures.

## 4 Information Domains

This architecture defines ten information domains.

| Domain ID | Information Domain | Purpose | Primary Owner |
| --- | --- | --- | --- |
| IDOM-01 | Research and Application Information | Describes research activities and ethics applications. | Principal Investigator and Research Ethics Governance |
| IDOM-02 | Participant Protection Information | Describes ethical protections, consent, risk, and participant-facing materials. | Research Ethics Governance |
| IDOM-03 | Review and Committee Information | Describes reviewer assignment, review outcomes, deliberation, and committee decisions. | Research Ethics Committee |
| IDOM-04 | Conditions and Evidence Information | Describes conditions, responses, evidence, and resolution. | Research Ethics Governance |
| IDOM-05 | Approval and Lifecycle Information | Describes approvals, certificates, amendments, continuing review, completion, closure, and archive status. | Research Governance Authority |
| IDOM-06 | Safety and Compliance Information | Describes safety reports, protocol deviations, serious adverse events, compliance observations, and governance risk. | Research Governance Authority |
| IDOM-07 | Stakeholder and Responsibility Information | Describes people, institutions, roles, committees, responsibilities, and accountability. | Institution Administration |
| IDOM-08 | Communication and Notification Information | Describes business communications, requests, notices, reminders, and communication records. | Institution Administration |
| IDOM-09 | Reporting and Oversight Information | Describes operational, executive, oversight, cross-institution, and performance information. | Ministry Leadership and Research Governance Authority |
| IDOM-10 | Reference and Rule Information | Describes terminology, policies, templates, business rules, classifications, and guidance. | Documentation and Governance Stewardship |

## 5 Information Owners

Information owners SHALL be accountable for business meaning, quality expectations, classification, retention principle, and appropriate use.

Ownership MAY be assigned to a role, function, committee, institution, authority, or governance body.

Principal Investigators own the integrity of research information they submit.

Research Ethics Committees own committee decisions, deliberation outcomes, and review authority information.

Research Governance Authorities own governance oversight, compliance, approval lifecycle, and policy alignment information.

Institution Administration owns institutional responsibility, committee administration, workload coordination, and communication record information.

Ministry Leadership owns national oversight, adoption, and strategic governance reporting information.

Documentation and Governance Stewardship owns reference, terminology, template, and business rule framework information.

## 6 Information Producers

Information producers create or supply business information.

Producers include principal investigators, applicants, research teams, reviewers, committee chairs, committees, ethics administrators, institution administrators, governance officers, ministry leadership, regulatory observers, auditors, and reference stewards.

Information producers SHALL provide information according to the business process and responsibility context.

Information producers SHOULD be identifiable for accountability and traceability.

## 7 Information Consumers

Information consumers use information for governance action, review, oversight, reporting, audit, decision making, communication, or planning.

Consumers include applicants, principal investigators, reviewers, committees, administrators, governance authorities, ministry leadership, regulatory bodies, auditors, institutions, business analysts, enterprise architects, data architects, quality reviewers, and security reviewers.

Information consumers SHALL use information only for authorized business purposes.

Information consumers SHOULD interpret information using approved domain terminology and business definitions.

## 8 Information Objects

Information objects are business-defined information assets.

Information objects SHALL be described independently of database design, software classes, APIs, or implementation mechanisms.

The authoritative catalog of information objects is defined in Appendix A.

Information objects SHALL have owners, producers, consumers, classification, confidentiality, integrity requirements, availability requirements, retention principles, lifecycle, related domain entities, related business processes, and related business capabilities.

## 9 Master Data

Master data describes relatively stable business information used across multiple processes.

Master data in ERM-System includes institution profile information, stakeholder identity information at a business level, committee profile information, role and responsibility information, policy reference information, domain terminology, and controlled classification values.

Master data SHALL have clear ownership and stewardship.

Master data SHOULD be consistent across participating institutions where national governance requires common meaning.

Master data SHALL NOT be defined in this document as database structures.

## 10 Transactional Data

Transactional data describes business activity and lifecycle events.

Transactional information includes applications, submissions, screening outcomes, review assignments, review outcomes, committee decisions, conditions, evidence submissions, approvals, certificates, amendments, continuing reviews, safety reports, protocol deviations, serious adverse events, completion records, final reports, communications, audit requests, and oversight findings.

Transactional information SHALL preserve business traceability.

Transactional information SHOULD identify producer, consumer, event context, and lifecycle state.

## 11 Reference Data

Reference data describes controlled business values and lists.

Reference information includes rule classifications, rule status values, information classifications, confidentiality levels, process categories, capability categories, document classifications, review statuses, decision outcome categories, condition statuses, and risk categories.

Reference data SHALL be governed by an accountable owner.

Reference data SHOULD be stable, versioned where appropriate, and traceable to authority.

## 12 Metadata

Metadata describes information about information.

Metadata includes document metadata, rule metadata, information object metadata, lifecycle status, owner, producer, consumer, classification, confidentiality, source, version, review date, approval status, and traceability references.

Metadata SHALL be sufficient to support governance, search, review, retention, and audit.

Metadata SHOULD be defined consistently across future information and data architecture work.

## 13 Business Documents

Business documents are governed information artifacts used or produced by business processes.

Business documents include applications, supporting materials, review outcomes, committee decisions, condition notices, evidence submissions, approval certificates, amendment requests, safety reports, final reports, audit evidence packages, policy references, templates, and business rule records.

Business documents SHALL have ownership, classification, confidentiality, lifecycle, and retention expectations.

Business documents SHOULD remain traceable to processes and information objects.

## 14 Information Classification

Information classification describes the business category and governance sensitivity of information.

The standard classifications in this architecture are Governance, Research, Participant Protection, Committee, Evidence, Approval, Compliance, Stakeholder, Communication, Reporting, Reference, and Metadata.

Classification SHALL be assigned to each information object.

Classification SHOULD support governance, stewardship, retention, confidentiality, and reporting decisions.

## 15 Confidentiality Levels

Confidentiality levels define expected protection from a business perspective.

| Level | Meaning |
| --- | --- |
| Public | Approved for public release. |
| Internal | Intended for internal project or institutional use. |
| Restricted | Limited to authorized business roles. |
| Confidential | Sensitive governance information requiring strong business controls. |
| Highly Confidential | Highly sensitive information requiring strict access purpose and oversight. |

Information objects SHALL identify a confidentiality level.

Confidentiality levels SHALL be reviewed for information involving participants, safety, compliance, committee deliberation, or audit.

## 16 Data Quality Principles

Data quality is a business responsibility.

Information SHOULD be complete, accurate, consistent, timely, valid, unique, understandable, and traceable.

Critical information SHALL have a defined owner.

High-risk information SHOULD have stronger validation and review expectations.

Information quality issues SHOULD be visible to process owners and information stewards.

Data quality principles SHALL be refined in future data governance and data quality standards.

## 17 Information Lifecycle

The information lifecycle includes creation, submission, review, validation, use, decision, update, retention, archive, and disposal consideration where applicable.

Information lifecycle SHALL align with business process lifecycle.

Information lifecycle SHALL preserve accountability for key governance events.

Active information supports current business activity.

Retained information supports audit, oversight, reporting, and institutional memory.

Archived information supports historical accountability.

Superseded information SHALL remain traceable where it affects decisions, approvals, evidence, or audit.

## 18 Information Governance

Information governance SHALL define decision rights, ownership, stewardship, quality expectations, classification, confidentiality, lifecycle, retention, sharing, and issue resolution.

Information governance SHALL align with product, domain, capability, process, and business rule governance.

Information governance SHALL maintain a clear distinction between business ownership and technical custody.

Information governance SHALL be formalized further in future data governance work.

## 19 Information Stewardship

Information stewards support information owners.

Stewards SHOULD maintain definitions, quality expectations, usage guidance, classification, traceability, and issue resolution practices.

Stewardship MAY be assigned by information domain.

Domain stewards SHOULD coordinate terminology alignment with the Domain Model.

Process stewards SHOULD coordinate information use with the Business Process Architecture.

Rule stewards SHOULD coordinate rule-related information with the Business Rules Framework.

## 20 Information Traceability

Information traceability connects information objects to source, producer, process, capability, domain entity, business rule, decision, evidence, and consumer.

Traceability SHALL be maintained for high-risk information.

Traceability SHOULD be sufficient to explain why information exists, who produced it, who consumed it, what decision used it, and where it is retained.

Traceability gaps SHALL be treated as information governance risk.

Future Data Architecture and Database Design work SHALL preserve traceability from business information objects to downstream data structures.

## 21 Information Sharing

Information sharing SHALL be based on authorized business purpose.

Information sharing SHOULD be limited to the information required for the business purpose.

Information sharing SHALL respect confidentiality, governance authority, stakeholder responsibility, and institutional boundaries.

Information sharing SHOULD preserve context so consumers do not misinterpret information.

Information sharing between institutions, committees, oversight authorities, and regulatory bodies SHALL be governed by approved policy and authority.

## 22 Cross-Institution Information Exchange

Cross-institution information exchange supports national oversight, institutional onboarding, external stakeholder coordination, and governance maturity.

Cross-institution exchange SHALL use common business definitions.

Cross-institution exchange SHALL preserve institutional accountability.

Cross-institution exchange SHALL protect confidential and highly confidential information.

Cross-institution exchange SHOULD identify producer institution, consumer authority, business purpose, information scope, and retention expectation.

Future exchange models SHALL remain aligned with this architecture.

## 23 Retention Principles

Retention principles define why and how long information should remain available from a business perspective.

Retention SHALL support governance accountability, audit readiness, compliance, oversight, and institutional memory.

Retention SHOULD be risk-based and authority-driven.

Retention expectations SHALL be defined by authorized governance, legal, regulatory, or institutional owners.

This document does not define specific retention periods.

Future retention rules SHALL align with the Business Rules Framework.

## 24 Archiving Principles

Archiving preserves information after active processing ends.

Archived information SHALL remain retrievable for authorized audit, oversight, and historical accountability.

Archiving SHALL preserve key context, including business meaning, owner, classification, lifecycle state, and traceability.

Archived information SHALL be protected according to confidentiality level.

Archived information SHALL NOT be treated as active operational information unless reopened by approved business process.

## 25 Information Risks

Information risks include incompleteness, inaccuracy, inconsistency, unauthorized access, over-sharing, under-sharing, loss of context, weak ownership, poor traceability, premature deletion, stale reference information, conflicting definitions, and insufficient audit evidence.

Participant protection information, committee deliberation information, safety information, serious adverse event information, compliance findings, and audit evidence carry elevated risk.

Information risks SHOULD be assessed by domain, process, capability, and confidentiality.

High-risk information SHALL have stronger controls and stewardship.

## 26 Information Controls

Information controls protect quality, confidentiality, integrity, availability, traceability, and appropriate use.

Controls MAY include ownership assignment, classification, confidentiality marking, completeness review, source validation, versioning, approval, traceability, retention, archival review, access purpose review, sharing approval, and audit evidence review.

Controls SHALL be proportional to information risk.

Controls SHOULD be defined before detailed data architecture and database design work begins.

Controls SHALL NOT be bypassed for convenience.

## 27 Information Architecture Roadmap

The roadmap SHALL guide future information and data architecture work.

| Phase | Focus | Outcome |
| --- | --- | --- |
| Phase 1 | Information foundation | Approved information domains, object catalog, and ownership model. |
| Phase 2 | Stewardship model | Assigned information stewards and quality expectations. |
| Phase 3 | Data architecture alignment | Future data architecture maps business information objects to data concepts. |
| Phase 4 | Retention and archive rules | Future rule catalogs define retention and archive requirements. |
| Phase 5 | Cross-institution exchange | Exchange principles and information sharing controls are formalized. |
| Phase 6 | Information quality management | Data quality measures, issue processes, and stewardship reporting are established. |

## 28 References

`docs/product/PRODUCT_DEFINITION.md`: Authoritative product definition.

`docs/domain/DOMAIN_MODEL.md`: Authoritative domain terminology and business concepts.

`docs/business/BUSINESS_CAPABILITY_MODEL.md`: Authoritative business capability model.

`docs/business/BUSINESS_PROCESS_ARCHITECTURE.md`: Authoritative business process architecture.

`docs/business/BUSINESS_RULES_FRAMEWORK.md`: Authoritative business rules framework.

`docs/governance/ENGINEERING_MANIFEST.md`: Root engineering governance reference.

`docs/governance/ENGINEERING_DOCUMENTATION_STANDARD.md`: Documentation standard.

RFC 2119: Key words for use in RFCs to Indicate Requirement Levels.

## 29 Appendix A - Information Catalog

Every information object below includes the mandatory attributes required by this specification.

### INFO-001 Research Project Information

Information ID: INFO-001

Business Name: Research Project Information

Business Definition: Information describing the health research activity subject to ethics governance.

Business Owner: Principal Investigator

Producer: Principal Investigator and Research Team

Consumer: Ethics Administrator, Reviewer, Research Ethics Committee, Research Governance Authority

Classification: Research

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain for governance accountability and research lifecycle traceability.

Lifecycle: Prepared, submitted, reviewed, approved, amended, completed, archived.

Related Domain Entities: Research Project, Application, Principal Investigator

Related Business Processes: BP-001, BP-002, BP-005, BP-010, BP-012, BP-017

Related Business Capabilities: BCM-01, BCM-04

### INFO-002 Ethics Application Information

Information ID: INFO-002

Business Name: Ethics Application Information

Business Definition: Information forming the formal request for ethics review.

Business Owner: Research Ethics Governance

Producer: Applicant and Principal Investigator

Consumer: Ethics Administrator, Reviewer, Research Ethics Committee

Classification: Governance

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain as the central governance record for application processing and audit.

Lifecycle: Prepared, submitted, screened, reviewed, decided, closed, archived.

Related Domain Entities: Application, Submission, Principal Investigator

Related Business Processes: BP-001, BP-002, BP-003, BP-004, BP-005, BP-007

Related Business Capabilities: BCM-01, BCM-02

### INFO-003 Applicant Information

Information ID: INFO-003

Business Name: Applicant Information

Business Definition: Information identifying the person or role managing an ethics application interaction.

Business Owner: Institution Administration

Producer: Applicant

Consumer: Ethics Administrator, Research Ethics Governance

Classification: Stakeholder

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain while associated governance records require accountability.

Lifecycle: Captured, verified, used, updated, retained, archived.

Related Domain Entities: Applicant, Submission, Application

Related Business Processes: BP-002, BP-003, BP-028, BP-029

Related Business Capabilities: BCM-01, BCM-06, BCM-07

### INFO-004 Principal Investigator Information

Information ID: INFO-004

Business Name: Principal Investigator Information

Business Definition: Information identifying the accountable person responsible for research submission integrity and compliance.

Business Owner: Research Institution

Producer: Principal Investigator and Institution Administration

Consumer: Ethics Administrator, Research Ethics Committee, Research Governance Authority

Classification: Stakeholder

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain with related research governance records for accountability.

Lifecycle: Identified, confirmed, active, changed, retained, archived.

Related Domain Entities: Principal Investigator, Research Project, Application

Related Business Processes: BP-001, BP-002, BP-008, BP-012, BP-017

Related Business Capabilities: BCM-01, BCM-04, BCM-06

### INFO-005 Research Team Information

Information ID: INFO-005

Business Name: Research Team Information

Business Definition: Information describing individuals participating in the research project.

Business Owner: Principal Investigator

Producer: Principal Investigator and Research Team

Consumer: Ethics Administrator, Reviewer, Research Ethics Committee

Classification: Stakeholder

Confidentiality: Restricted

Integrity Requirement: Medium

Availability Requirement: Medium

Retention Principle: Retain while relevant to governance accountability and approved research context.

Lifecycle: Captured, reviewed, updated, retained, archived.

Related Domain Entities: Research Team, Researcher, Research Project

Related Business Processes: BP-001, BP-002, BP-005, BP-012

Related Business Capabilities: BCM-01, BCM-04

### INFO-006 Participant Protection Information

Information ID: INFO-006

Business Name: Participant Protection Information

Business Definition: Information describing protections for human participants, including risk, consent context, and participant-facing considerations.

Business Owner: Research Ethics Governance

Producer: Principal Investigator and Research Team

Consumer: Reviewer, Research Ethics Committee, Research Governance Authority

Classification: Participant Protection

Confidentiality: Confidential

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain as evidence of participant protection review and decision accountability.

Lifecycle: Prepared, submitted, reviewed, conditioned, approved, amended, archived.

Related Domain Entities: Research Project, Application, Evidence, Approval

Related Business Processes: BP-001, BP-005, BP-006, BP-007, BP-010, BP-012

Related Business Capabilities: BCM-01, BCM-02, BCM-04, BCM-05

### INFO-007 Supporting Material Information

Information ID: INFO-007

Business Name: Supporting Material Information

Business Definition: Information contained in materials submitted to support ethics review.

Business Owner: Principal Investigator

Producer: Principal Investigator and Research Team

Consumer: Ethics Administrator, Reviewer, Research Ethics Committee

Classification: Research

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain with the application and related governance records.

Lifecycle: Prepared, submitted, screened, reviewed, superseded, retained, archived.

Related Domain Entities: Submission, Evidence, Application

Related Business Processes: BP-001, BP-002, BP-003, BP-005

Related Business Capabilities: BCM-01, BCM-02

### INFO-008 Administrative Screening Information

Information ID: INFO-008

Business Name: Administrative Screening Information

Business Definition: Information documenting administrative completeness review and screening outcome.

Business Owner: Institution Administration

Producer: Ethics Administrator

Consumer: Applicant, Research Ethics Committee, Reviewer

Classification: Governance

Confidentiality: Internal

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain as evidence of intake readiness and administrative action.

Lifecycle: Created, communicated, acted upon, retained, archived.

Related Domain Entities: Application, Submission, Governance Record

Related Business Processes: BP-003, BP-004, BP-028

Related Business Capabilities: BCM-01, BCM-06, BCM-07

### INFO-009 Reviewer Assignment Information

Information ID: INFO-009

Business Name: Reviewer Assignment Information

Business Definition: Information documenting allocation of review responsibility.

Business Owner: Research Ethics Committee

Producer: Ethics Administrator or Committee Chair

Consumer: Reviewer, Committee Chair, Ethics Administrator

Classification: Committee

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain as evidence of review accountability.

Lifecycle: Created, assigned, accepted, completed, cancelled, retained, archived.

Related Domain Entities: Review Assignment, Reviewer, Application

Related Business Processes: BP-004, BP-005, BP-027

Related Business Capabilities: BCM-02, BCM-06

### INFO-010 Review Outcome Information

Information ID: INFO-010

Business Name: Review Outcome Information

Business Definition: Information documenting reviewer findings, recommendations, and review completion.

Business Owner: Research Ethics Committee

Producer: Reviewer

Consumer: Committee Chair, Research Ethics Committee, Ethics Administrator

Classification: Committee

Confidentiality: Confidential

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain as evidence supporting committee deliberation and decision.

Lifecycle: Drafted, submitted, considered, superseded, retained, archived.

Related Domain Entities: Review Outcome, Reviewer, Committee Decision

Related Business Processes: BP-005, BP-006, BP-007

Related Business Capabilities: BCM-02

### INFO-011 Committee Deliberation Information

Information ID: INFO-011

Business Name: Committee Deliberation Information

Business Definition: Information documenting committee consideration of application materials and review outcomes.

Business Owner: Research Ethics Committee

Producer: Research Ethics Committee and Committee Chair

Consumer: Committee Chair, Ethics Administrator, Research Governance Authority where authorized

Classification: Committee

Confidentiality: Confidential

Integrity Requirement: High

Availability Requirement: Medium

Retention Principle: Retain according to governance accountability and confidentiality expectations.

Lifecycle: Created, considered, summarized, retained, archived.

Related Domain Entities: Research Ethics Committee, Committee Chair, Committee Decision

Related Business Processes: BP-006, BP-007, BP-020

Related Business Capabilities: BCM-02, BCM-05

### INFO-012 Committee Decision Information

Information ID: INFO-012

Business Name: Committee Decision Information

Business Definition: Information documenting the formal decision issued by authorized committee authority.

Business Owner: Research Ethics Committee

Producer: Research Ethics Committee

Consumer: Applicant, Principal Investigator, Institution Administration, Research Governance Authority

Classification: Governance

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain permanently or according to approved governance retention authority for decision accountability.

Lifecycle: Proposed, issued, communicated, acted upon, superseded, archived.

Related Domain Entities: Committee Decision, Application, Governance Record

Related Business Processes: BP-007, BP-008, BP-010, BP-020

Related Business Capabilities: BCM-02, BCM-03, BCM-04, BCM-05

### INFO-013 Condition Information

Information ID: INFO-013

Business Name: Condition Information

Business Definition: Information describing requirements issued as part of a governance decision or obligation.

Business Owner: Research Ethics Governance

Producer: Research Ethics Committee

Consumer: Applicant, Principal Investigator, Ethics Administrator, Reviewer

Classification: Governance

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain with related decision and evidence records.

Lifecycle: Issued, open, evidence-submitted, under-review, resolved, waived, superseded, archived.

Related Domain Entities: Condition, Committee Decision, Evidence

Related Business Processes: BP-008, BP-009, BP-010

Related Business Capabilities: BCM-03, BCM-04

### INFO-014 Evidence Information

Information ID: INFO-014

Business Name: Evidence Information

Business Definition: Information submitted to demonstrate that a requirement, condition, or governance expectation has been addressed.

Business Owner: Research Ethics Governance

Producer: Principal Investigator, Applicant, Research Team

Consumer: Ethics Administrator, Reviewer, Research Ethics Committee, Auditor

Classification: Evidence

Confidentiality: Confidential

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain as evidence supporting decision, condition resolution, audit, and oversight.

Lifecycle: Requested, submitted, reviewed, accepted, rejected, superseded, retained, archived.

Related Domain Entities: Evidence, Condition, Governance Record

Related Business Processes: BP-008, BP-009, BP-020, BP-024

Related Business Capabilities: BCM-03, BCM-05

### INFO-015 Evidence Assessment Information

Information ID: INFO-015

Business Name: Evidence Assessment Information

Business Definition: Information documenting the assessment of whether submitted evidence satisfies a requirement.

Business Owner: Research Ethics Governance

Producer: Reviewer, Committee, or Governance Authority

Consumer: Applicant, Ethics Administrator, Research Ethics Committee

Classification: Evidence

Confidentiality: Confidential

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain with condition and evidence records for traceability.

Lifecycle: Created, reviewed, communicated, acted upon, retained, archived.

Related Domain Entities: Evidence, Condition, Review Outcome

Related Business Processes: BP-009, BP-008, BP-010

Related Business Capabilities: BCM-03

### INFO-016 Approval Information

Information ID: INFO-016

Business Name: Approval Information

Business Definition: Information documenting authorized permission for research to proceed under defined terms.

Business Owner: Research Ethics Committee

Producer: Research Ethics Committee

Consumer: Principal Investigator, Institution Administration, Research Governance Authority, Regulatory Stakeholders

Classification: Approval

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain as authoritative approval evidence for the research lifecycle.

Lifecycle: Granted, active, amended, closed, superseded, archived.

Related Domain Entities: Approval, Committee Decision, Research Project

Related Business Processes: BP-010, BP-011, BP-012, BP-013, BP-017

Related Business Capabilities: BCM-04, BCM-05

### INFO-017 Certificate Information

Information ID: INFO-017

Business Name: Certificate Information

Business Definition: Information representing formal communication of an approved ethics governance outcome.

Business Owner: Research Ethics Governance

Producer: Research Ethics Governance

Consumer: Principal Investigator, Institution, Regulatory Stakeholder

Classification: Approval

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain with approval information and governance records.

Lifecycle: Created, issued, active, superseded, retained, archived.

Related Domain Entities: Certificate, Approval, Research Project

Related Business Processes: BP-011, BP-020, BP-024

Related Business Capabilities: BCM-04

### INFO-018 Amendment Information

Information ID: INFO-018

Business Name: Amendment Information

Business Definition: Information describing proposed changes to approved or active research governance arrangements.

Business Owner: Research Governance Authority

Producer: Principal Investigator

Consumer: Ethics Administrator, Reviewer, Research Ethics Committee, Research Governance Authority

Classification: Governance

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain with related approval and research lifecycle records.

Lifecycle: Requested, screened, reviewed, decided, retained, archived.

Related Domain Entities: Amendment, Research Project, Approval

Related Business Processes: BP-012, BP-005, BP-007, BP-010

Related Business Capabilities: BCM-04, BCM-02

### INFO-019 Continuing Review Information

Information ID: INFO-019

Business Name: Continuing Review Information

Business Definition: Information supporting periodic or required review of ongoing research governance status.

Business Owner: Research Governance Authority

Producer: Principal Investigator, Governance Officer, Research Ethics Committee

Consumer: Research Governance Authority, Research Ethics Committee, Institution Administration

Classification: Governance

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: Medium

Retention Principle: Retain as evidence of ongoing oversight and lifecycle governance.

Lifecycle: Due, submitted, reviewed, acted upon, retained, archived.

Related Domain Entities: Research Project, Approval, Governance Record

Related Business Processes: BP-013, BP-021, BP-022

Related Business Capabilities: BCM-04, BCM-05

### INFO-020 Safety Report Information

Information ID: INFO-020

Business Name: Safety Report Information

Business Definition: Information describing safety concerns or required safety reports related to approved or active research.

Business Owner: Research Governance Authority

Producer: Principal Investigator, Research Team, Institution

Consumer: Research Ethics Committee, Governance Officer, Regulatory Stakeholder

Classification: Compliance

Confidentiality: Highly Confidential

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain as sensitive governance evidence for participant protection and oversight.

Lifecycle: Reported, assessed, escalated, resolved, retained, archived.

Related Domain Entities: Research Project, Governance Record, Compliance

Related Business Processes: BP-014, BP-016, BP-021

Related Business Capabilities: BCM-05, BCM-04

### INFO-021 Protocol Deviation Information

Information ID: INFO-021

Business Name: Protocol Deviation Information

Business Definition: Information documenting departures from approved research arrangements.

Business Owner: Research Governance Authority

Producer: Principal Investigator, Research Team, Institution

Consumer: Research Ethics Committee, Governance Officer, Oversight Authority

Classification: Compliance

Confidentiality: Confidential

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain as compliance and governance accountability evidence.

Lifecycle: Reported, assessed, corrected, escalated, retained, archived.

Related Domain Entities: Research Project, Compliance, Governance Record

Related Business Processes: BP-015, BP-021, BP-022

Related Business Capabilities: BCM-05, BCM-04

### INFO-022 Serious Adverse Event Information

Information ID: INFO-022

Business Name: Serious Adverse Event Information

Business Definition: Information documenting serious adverse events requiring heightened governance attention.

Business Owner: Research Governance Authority

Producer: Principal Investigator, Research Team, Institution

Consumer: Research Ethics Committee, Research Governance Authority, Regulatory Body

Classification: Compliance

Confidentiality: Highly Confidential

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain as high-risk safety and compliance evidence.

Lifecycle: Reported, triaged, escalated, reviewed, resolved, retained, archived.

Related Domain Entities: Research Project, Compliance, Governance Record

Related Business Processes: BP-016, BP-014, BP-021, BP-020

Related Business Capabilities: BCM-05

### INFO-023 Study Completion Information

Information ID: INFO-023

Business Name: Study Completion Information

Business Definition: Information documenting that approved research activity has reached completion from a governance perspective.

Business Owner: Principal Investigator

Producer: Principal Investigator

Consumer: Institution Administration, Research Governance Authority, Research Ethics Committee

Classification: Governance

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: Medium

Retention Principle: Retain with closure and final reporting records.

Lifecycle: Declared, reviewed, accepted, retained, archived.

Related Domain Entities: Research Project, Closure, Approval

Related Business Processes: BP-017, BP-018, BP-019

Related Business Capabilities: BCM-04

### INFO-024 Final Report Information

Information ID: INFO-024

Business Name: Final Report Information

Business Definition: Information submitted at the end of a research activity to support governance closure.

Business Owner: Research Governance Authority

Producer: Principal Investigator

Consumer: Research Ethics Committee, Institution Administration, Oversight Authority

Classification: Governance

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: Medium

Retention Principle: Retain as closure evidence and institutional memory.

Lifecycle: Requested, submitted, assessed, accepted, retained, archived.

Related Domain Entities: Research Project, Closure, Governance Record

Related Business Processes: BP-018, BP-017, BP-019, BP-020

Related Business Capabilities: BCM-04, BCM-05

### INFO-025 Governance Record Information

Information ID: INFO-025

Business Name: Governance Record Information

Business Definition: Information retained as evidence of ethics governance activity, action, decision, or outcome.

Business Owner: Research Governance Authority

Producer: All authorized governance process participants

Consumer: Institution Administration, Oversight Authority, Auditor, Research Governance Authority

Classification: Governance

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain for auditability, oversight, and institutional memory.

Lifecycle: Created, retained, referenced, audited, archived.

Related Domain Entities: Governance Record, Application, Decision, Evidence

Related Business Processes: BP-019, BP-020, BP-024

Related Business Capabilities: BCM-05, BCM-04

### INFO-026 Audit Evidence Information

Information ID: INFO-026

Business Name: Audit Evidence Information

Business Definition: Information organized for authorized audit or oversight review.

Business Owner: Authorized Audit or Oversight Authority

Producer: Institution Administration

Consumer: Auditor, Oversight Authority, Ministry Leadership

Classification: Compliance

Confidentiality: Confidential

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain according to audit and governance evidence expectations.

Lifecycle: Requested, assembled, reviewed, retained, archived.

Related Domain Entities: Audit, Governance Record, Compliance

Related Business Processes: BP-020, BP-024

Related Business Capabilities: BCM-05

### INFO-027 Compliance Observation Information

Information ID: INFO-027

Business Name: Compliance Observation Information

Business Definition: Information documenting compliance observations, exceptions, or follow-up recommendations.

Business Owner: Research Governance Authority

Producer: Governance Officer, Auditor, Oversight Authority

Consumer: Institution Leadership, Research Ethics Committee, Ministry Leadership

Classification: Compliance

Confidentiality: Confidential

Integrity Requirement: High

Availability Requirement: Medium

Retention Principle: Retain as evidence of compliance oversight and improvement.

Lifecycle: Identified, reviewed, assigned, followed-up, closed, archived.

Related Domain Entities: Compliance, Oversight, Audit

Related Business Processes: BP-021, BP-022, BP-023

Related Business Capabilities: BCM-05

### INFO-028 Governance Risk Information

Information ID: INFO-028

Business Name: Governance Risk Information

Business Definition: Information describing governance risks, indicators, escalations, and mitigation recommendations.

Business Owner: Research Governance Authority

Producer: Governance Officer, Oversight Analytics, Institution Administration

Consumer: Ministry Leadership, Institution Leadership, Research Governance Authority

Classification: Compliance

Confidentiality: Confidential

Integrity Requirement: High

Availability Requirement: Medium

Retention Principle: Retain while risk remains active and as evidence of mitigation decisions.

Lifecycle: Identified, assessed, escalated, mitigated, monitored, closed, archived.

Related Domain Entities: Oversight, Compliance, Governance Record

Related Business Processes: BP-022, BP-033, BP-032

Related Business Capabilities: BCM-05, BCM-08

### INFO-029 Institution Information

Information ID: INFO-029

Business Name: Institution Information

Business Definition: Information describing participating institutions and their governance responsibilities.

Business Owner: Institution Administration

Producer: Institution Administration

Consumer: Ministry Leadership, Research Governance Authority, Committee Administration

Classification: Stakeholder

Confidentiality: Internal

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain while institution participates and for historical adoption accountability.

Lifecycle: Captured, verified, active, updated, retired, archived.

Related Domain Entities: Institution, Oversight, Governance Record

Related Business Processes: BP-025, BP-026, BP-034

Related Business Capabilities: BCM-06, BCM-10

### INFO-030 Committee Information

Information ID: INFO-030

Business Name: Committee Information

Business Definition: Information describing research ethics committee membership, authority, readiness, and operating responsibility.

Business Owner: Research Ethics Committee

Producer: Institution Administration and Committee Chair

Consumer: Reviewers, Ethics Administrators, Governance Authorities

Classification: Committee

Confidentiality: Internal

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain while committee operates and as governance history where required.

Lifecycle: Constituted, active, updated, reviewed, retired, archived.

Related Domain Entities: Research Ethics Committee, Committee Chair, Reviewer

Related Business Processes: BP-004, BP-006, BP-026

Related Business Capabilities: BCM-02, BCM-06

### INFO-031 Reviewer Information

Information ID: INFO-031

Business Name: Reviewer Information

Business Definition: Information describing reviewer identity, eligibility, responsibility, and review participation.

Business Owner: Research Ethics Committee

Producer: Institution Administration and Reviewer

Consumer: Committee Chair, Ethics Administrator, Research Governance Authority

Classification: Stakeholder

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain while reviewer responsibilities and related review records require accountability.

Lifecycle: Identified, eligible, assigned, active, inactive, archived.

Related Domain Entities: Reviewer, Review Assignment, Review Outcome

Related Business Processes: BP-004, BP-005, BP-025, BP-026

Related Business Capabilities: BCM-02, BCM-06

### INFO-032 Role and Responsibility Information

Information ID: INFO-032

Business Name: Role and Responsibility Information

Business Definition: Information describing business roles, responsibilities, accountability, and authorized participation.

Business Owner: Institution Administration

Producer: Institution Administration

Consumer: Administrators, Committees, Oversight Authorities

Classification: Stakeholder

Confidentiality: Internal

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain as evidence of accountability and authorized participation.

Lifecycle: Defined, assigned, reviewed, changed, retired, archived.

Related Domain Entities: Business Role, Applicant, Reviewer, Committee Chair

Related Business Processes: BP-025, BP-026, BP-004

Related Business Capabilities: BCM-06

### INFO-033 Communication Record Information

Information ID: INFO-033

Business Name: Communication Record Information

Business Definition: Information documenting business notices, requests, responses, reminders, and decision communications.

Business Owner: Institution Administration

Producer: Administrators, Committees, Applicants, Governance Authorities

Consumer: Applicants, Reviewers, Committees, Auditors, Oversight Authorities

Classification: Communication

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: Medium

Retention Principle: Retain where communication supports action, decision, audit, or governance traceability.

Lifecycle: Created, sent, received, responded, retained, archived.

Related Domain Entities: Submission, Committee Decision, Condition, Governance Record

Related Business Processes: BP-028, BP-029, BP-030, BP-020

Related Business Capabilities: BCM-07, BCM-05

### INFO-034 Operational Reporting Information

Information ID: INFO-034

Business Name: Operational Reporting Information

Business Definition: Information summarizing day-to-day status, workload, overdue actions, and operational activity.

Business Owner: Institution Administration

Producer: Institution Administration

Consumer: Administrators, Committee Chairs, Institution Leadership

Classification: Reporting

Confidentiality: Internal

Integrity Requirement: Medium

Availability Requirement: High

Retention Principle: Retain according to operational reporting and governance review needs.

Lifecycle: Produced, reviewed, acted upon, refreshed, retained, archived where required.

Related Domain Entities: Application, Review Assignment, Condition, Oversight

Related Business Processes: BP-027, BP-031

Related Business Capabilities: BCM-08, BCM-06

### INFO-035 Executive Reporting Information

Information ID: INFO-035

Business Name: Executive Reporting Information

Business Definition: Information summarizing governance performance, volume, risk, outcomes, and strategic indicators for leadership.

Business Owner: Ministry Leadership

Producer: Research Governance Authority and Institution Administration

Consumer: Ministry Leadership, Institution Leadership, Governance Authorities

Classification: Reporting

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: Medium

Retention Principle: Retain as evidence of governance oversight and strategic review.

Lifecycle: Produced, reviewed, interpreted, retained, archived.

Related Domain Entities: Oversight, Compliance, Governance Record

Related Business Processes: BP-032, BP-033, BP-034

Related Business Capabilities: BCM-08, BCM-10

### INFO-036 Cross-Institution Trend Information

Information ID: INFO-036

Business Name: Cross-Institution Trend Information

Business Definition: Information describing comparable governance patterns across participating institutions.

Business Owner: Ministry Leadership

Producer: Research Governance Authority and Participating Institutions

Consumer: Ministry Leadership, Research Governance Authority, Institution Leadership

Classification: Reporting

Confidentiality: Restricted

Integrity Requirement: High

Availability Requirement: Medium

Retention Principle: Retain for national oversight, policy planning, and continuous improvement.

Lifecycle: Collected, normalized in business meaning, analyzed, reported, retained, archived.

Related Domain Entities: Oversight, Compliance, Institution

Related Business Processes: BP-033, BP-034, BP-032

Related Business Capabilities: BCM-08, BCM-10

### INFO-037 Policy Reference Information

Information ID: INFO-037

Business Name: Policy Reference Information

Business Definition: Information identifying approved policies, guidance, and governance references used by research ethics processes.

Business Owner: Research Governance Authority

Producer: Research Governance Authority and Reference Steward

Consumer: Researchers, Administrators, Reviewers, Committees, Governance Authorities

Classification: Reference

Confidentiality: Internal

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain current and historical references needed to understand governance decisions.

Lifecycle: Proposed, approved, published, revised, superseded, archived.

Related Domain Entities: Policy, Reference, Compliance

Related Business Processes: BP-023, BP-001, BP-005, BP-021

Related Business Capabilities: BCM-09, BCM-05

### INFO-038 Business Rule Information

Information ID: INFO-038

Business Name: Business Rule Information

Business Definition: Information documenting governed business rules, rule metadata, lifecycle, authority, and traceability.

Business Owner: Business Rules Architecture

Producer: Business Rule Owner and Business Rules Architecture

Consumer: Business Analysts, Process Architects, Quality Engineering, Data Architects, Governance Authorities

Classification: Reference

Confidentiality: Internal

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain active, superseded, deprecated, and archived rule records for traceability.

Lifecycle: Identified, draft, review, approved, implemented, verified, deprecated, superseded, archived.

Related Domain Entities: Business Rule, Policy, Governance Record

Related Business Processes: BP-023, BP-021, BP-020

Related Business Capabilities: BCM-09, BCM-05

### INFO-039 Template and Guidance Information

Information ID: INFO-039

Business Name: Template and Guidance Information

Business Definition: Information providing reusable business guidance, forms, templates, and documentation aids.

Business Owner: Documentation and Governance Stewardship

Producer: Reference Steward, Product Governance, Research Governance Authority

Consumer: Researchers, Administrators, Committees, Reviewers, Business Analysts

Classification: Reference

Confidentiality: Internal

Integrity Requirement: Medium

Availability Requirement: High

Retention Principle: Retain current guidance and historical versions needed to interpret past submissions.

Lifecycle: Drafted, reviewed, approved, published, revised, superseded, archived.

Related Domain Entities: Template, Reference, Submission

Related Business Processes: BP-001, BP-003, BP-023

Related Business Capabilities: BCM-09, BCM-01

### INFO-040 Information Metadata

Information ID: INFO-040

Business Name: Information Metadata

Business Definition: Information describing ownership, classification, lifecycle, version, source, status, and traceability of information assets.

Business Owner: Chief Information Architecture

Producer: Information Steward, Document Owner, Rule Owner, Process Owner

Consumer: Data Architects, Governance Authorities, Auditors, Information Stewards

Classification: Metadata

Confidentiality: Internal

Integrity Requirement: High

Availability Requirement: High

Retention Principle: Retain as long as needed to interpret governed information assets.

Lifecycle: Defined, assigned, updated, reviewed, retained, archived.

Related Domain Entities: Governance Record, Reference, Audit

Related Business Processes: BP-020, BP-021, BP-024

Related Business Capabilities: BCM-05, BCM-09

## 30 Appendix B - Information Relationship Matrix

| Information Object | Primary Domain | Key Related Objects |
| --- | --- | --- |
| INFO-001 Research Project Information | IDOM-01 | INFO-002, INFO-004, INFO-016, INFO-018 |
| INFO-002 Ethics Application Information | IDOM-01 | INFO-001, INFO-003, INFO-008, INFO-012 |
| INFO-006 Participant Protection Information | IDOM-02 | INFO-001, INFO-007, INFO-010, INFO-012 |
| INFO-009 Reviewer Assignment Information | IDOM-03 | INFO-010, INFO-030, INFO-031 |
| INFO-010 Review Outcome Information | IDOM-03 | INFO-009, INFO-011, INFO-012 |
| INFO-012 Committee Decision Information | IDOM-03 | INFO-013, INFO-016, INFO-025 |
| INFO-013 Condition Information | IDOM-04 | INFO-014, INFO-015, INFO-016 |
| INFO-014 Evidence Information | IDOM-04 | INFO-013, INFO-015, INFO-025 |
| INFO-016 Approval Information | IDOM-05 | INFO-017, INFO-018, INFO-023 |
| INFO-020 Safety Report Information | IDOM-06 | INFO-022, INFO-027, INFO-028 |
| INFO-025 Governance Record Information | IDOM-06 | INFO-026, INFO-027, INFO-040 |
| INFO-029 Institution Information | IDOM-07 | INFO-030, INFO-032, INFO-036 |
| INFO-033 Communication Record Information | IDOM-08 | INFO-012, INFO-013, INFO-025 |
| INFO-035 Executive Reporting Information | IDOM-09 | INFO-034, INFO-036, INFO-028 |
| INFO-038 Business Rule Information | IDOM-10 | INFO-037, INFO-039, INFO-040 |
