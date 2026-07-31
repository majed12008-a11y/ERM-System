# Domain Model

## Document Metadata

Document ID: SPEC-0005

Title: Domain Model

Status: Approved

Version: 1.0

Owner: Domain Architecture

Approvers: Product Governance, Research Ethics Governance, Enterprise Architecture

Reviewers: Business Analysis, Research Ethics Experts, Software Architecture, Quality Engineering

Classification: Specification

Audience: Business Analysts, Enterprise Architects, Solution Architects, Research Ethics Experts, Software Architects, Product Owners, and Future Contributors

Created: 2026-07-31

Last Updated: 2026-07-31

Next Review: To be scheduled by Domain Architecture

Related Documents: `docs/product/PRODUCT_DEFINITION.md`, `docs/governance/ENGINEERING_MANIFEST.md`, `docs/governance/ENGINEERING_DOCUMENTATION_STANDARD.md`

Depends On: `docs/product/PRODUCT_DEFINITION.md`, `docs/governance/ENGINEERING_MANIFEST.md`

References: RFC 2119

Keywords: domain model, ubiquitous language, research ethics, business entities, bounded contexts, domain events

Confidentiality: Internal

## Normative Language

The key words MUST, MUST NOT, SHALL, SHALL NOT, SHOULD, SHOULD NOT, and MAY in this document are to be interpreted as described by RFC 2119 when used as normative terms.

## 1 Executive Summary

This Domain Model defines the authoritative business language for ERM-System.

ERM-System is an Enterprise Research Ethics Management Platform for the complete lifecycle of ethical governance for health research.

This document defines the business concepts, entities, relationships, responsibilities, events, commands, policies, rules, boundaries, and capabilities that shape the domain.

It SHALL serve as the single source of truth for domain terminology.

Every future document SHALL derive business terminology from this document.

This document is business-focused and technology independent.

It does not describe software design, persistence, integration, programming models, or implementation.

The model is intended for business analysts, enterprise architects, solution architects, research ethics experts, software architects, and future contributors who require a shared language for the research ethics management domain.

## 2 Domain Overview

The ERM-System domain is the governance domain of health research ethics.

The domain concerns how research activities are submitted for ethical review, assessed, decided, conditioned, approved, monitored, closed, and retained as governance records.

The domain includes applicants, principal investigators, research teams, ethics administrators, reviewers, research ethics committees, committee chairs, institutional governance officers, ministry leadership, regulatory observers, and supporting administrative stakeholders.

The domain includes business responsibilities for participant protection, review integrity, accountable decision making, evidence handling, compliance visibility, and institutional oversight.

The domain is not limited to administrative processing.

It includes the full governance meaning of research ethics oversight.

The domain SHALL distinguish business concepts from technology mechanisms.

## 3 Ubiquitous Language

The following terms establish the shared domain language.

### Application

Definition: A formal request for ethics review of a proposed or ongoing health research activity.

Business Meaning: The application is the central work item that carries submitted research information through governance review and decision.

Related Terms: Research Project, Submission, Ethics Review, Principal Investigator, Committee Decision.

Business Owner: Research Ethics Governance.

Typical Usage: "The application is awaiting administrative screening."

### Research Project

Definition: A planned or active health research activity requiring ethical governance.

Business Meaning: The research project is the real-world research activity represented by one or more governance interactions.

Related Terms: Application, Principal Investigator, Research Team, Approval.

Business Owner: Research Governance Authority.

Typical Usage: "The research project requires ethics approval before participant recruitment."

### Submission

Definition: The act of providing an application or follow-up material to the governance process.

Business Meaning: A submission indicates that a responsible party has placed material before an administrator, reviewer, or committee for action.

Related Terms: Application, Evidence, Amendment, Resubmission.

Business Owner: Institution Administration.

Typical Usage: "The submission is complete enough for screening."

### Principal Investigator

Definition: The person with primary business accountability for the research project and ethics application.

Business Meaning: The principal investigator is responsible for truthful submission, timely response, and ongoing compliance with governance decisions.

Related Terms: Researcher, Research Team, Applicant, Application.

Business Owner: Research Institution.

Typical Usage: "The principal investigator must respond to the committee condition."

### Researcher

Definition: A person involved in the design, conduct, or support of a research project.

Business Meaning: The researcher may prepare materials, participate in the project, and support compliance obligations.

Related Terms: Principal Investigator, Research Team, Applicant.

Business Owner: Research Institution.

Typical Usage: "The researcher prepared the participant information materials."

### Research Team

Definition: The group of individuals participating in the research project.

Business Meaning: The research team shares project execution responsibilities under the accountability of the principal investigator.

Related Terms: Principal Investigator, Researcher, Application.

Business Owner: Principal Investigator.

Typical Usage: "The research team provided revised evidence."

### Applicant

Definition: The person or role that initiates or manages an ethics application on behalf of a research project.

Business Meaning: The applicant interacts with the ethics governance process and may be the principal investigator or an authorized delegate.

Related Terms: Principal Investigator, Researcher, Submission.

Business Owner: Research Institution.

Typical Usage: "The applicant submitted a response to requested conditions."

### Ethics Administrator

Definition: A business role responsible for coordinating administrative aspects of ethics governance.

Business Meaning: The ethics administrator supports intake, completeness checks, routing, communication, record coordination, and status visibility.

Related Terms: Screening, Committee, Application, Reviewer.

Business Owner: Institution Administration.

Typical Usage: "The ethics administrator completed the initial screening."

### Reviewer

Definition: A person assigned to assess submitted research materials and provide a documented review outcome.

Business Meaning: The reviewer contributes expert or committee review input to support decision making.

Related Terms: Review Assignment, Review Outcome, Committee Decision.

Business Owner: Research Ethics Committee.

Typical Usage: "The reviewer requested clarification on participant recruitment."

### Research Ethics Committee

Definition: An authorized governance body responsible for ethics review and decision making.

Business Meaning: The committee protects ethical standards by reviewing applications and issuing governance decisions.

Related Terms: Committee Chair, Reviewer, Decision, Meeting.

Business Owner: Research Ethics Governance.

Typical Usage: "The research ethics committee approved the application with conditions."

### Committee Chair

Definition: The committee leadership role responsible for coordinating committee authority and decision accountability.

Business Meaning: The chair helps ensure committee deliberation and decisions are properly governed.

Related Terms: Research Ethics Committee, Committee Decision, Meeting.

Business Owner: Research Ethics Committee.

Typical Usage: "The committee chair confirmed the decision outcome."

### Review Assignment

Definition: A business allocation of review responsibility to a reviewer or committee member.

Business Meaning: The assignment identifies who is expected to assess material and provide review input.

Related Terms: Reviewer, Review Outcome, Application.

Business Owner: Ethics Administrator.

Typical Usage: "The review assignment is pending reviewer response."

### Review Outcome

Definition: The documented result of a review activity.

Business Meaning: The outcome informs committee deliberation, administrative action, or decision making.

Related Terms: Reviewer, Committee Decision, Condition.

Business Owner: Research Ethics Committee.

Typical Usage: "The review outcome recommended revisions before approval."

### Committee Decision

Definition: The formal decision issued by an authorized ethics governance body.

Business Meaning: The decision determines the governance outcome or required next action for an application.

Related Terms: Approval, Rejection, Condition, Withdrawal, Closure.

Business Owner: Research Ethics Committee.

Typical Usage: "The committee decision requires additional evidence."

### Condition

Definition: A requirement issued as part of a governance decision that must be satisfied, waived, or otherwise resolved.

Business Meaning: A condition represents a specific obligation placed on the applicant or research team before or after a decision milestone.

Related Terms: Evidence, Committee Decision, Approval.

Business Owner: Research Ethics Committee.

Typical Usage: "The condition requires an updated consent form."

### Evidence

Definition: Material submitted to demonstrate that a requirement, condition, or governance expectation has been addressed.

Business Meaning: Evidence supports review, decision making, audit, and accountability.

Related Terms: Condition, Submission, Document, Review Outcome.

Business Owner: Submitting Party or Governance Authority, depending on context.

Typical Usage: "The evidence was reviewed by the committee."

### Approval

Definition: A positive governance outcome authorizing the research activity under defined ethical conditions.

Business Meaning: Approval indicates that the authorized governance body has permitted the research to proceed according to stated terms.

Related Terms: Committee Decision, Certificate, Condition, Research Project.

Business Owner: Research Ethics Committee.

Typical Usage: "The approval is valid subject to stated conditions."

### Certificate

Definition: A formal representation of an approved ethics governance outcome.

Business Meaning: The certificate communicates approval status and relevant governance terms to authorized stakeholders.

Related Terms: Approval, Committee Decision, Research Project.

Business Owner: Research Ethics Governance.

Typical Usage: "The certificate confirms ethics approval."

### Amendment

Definition: A proposed change to a research project or approved ethics arrangement.

Business Meaning: An amendment may require governance review before the changed research activity may proceed.

Related Terms: Research Project, Application, Approval, Committee Decision.

Business Owner: Principal Investigator.

Typical Usage: "The amendment requests a change to recruitment procedures."

### Withdrawal

Definition: The removal of an application from active consideration by an authorized party.

Business Meaning: Withdrawal ends active processing without a committee approval or rejection outcome.

Related Terms: Application, Applicant, Closure.

Business Owner: Applicant or Governance Authority, depending on rules.

Typical Usage: "The applicant withdrew the application."

### Closure

Definition: The business conclusion of a research ethics governance lifecycle.

Business Meaning: Closure records that active governance follow-up has ended according to approved rules.

Related Terms: Research Project, Approval, Archive.

Business Owner: Research Governance Authority.

Typical Usage: "The project was closed after completion reporting."

### Archive

Definition: The retained historical state of governance records no longer active in daily processing.

Business Meaning: Archive preserves evidence and accountability for future audit, oversight, and institutional memory.

Related Terms: Governance Record, Closure, Audit.

Business Owner: Institution Administration.

Typical Usage: "Archived records remain available for authorized audit."

### Governance Record

Definition: A retained business record documenting an ethics governance activity, decision, action, or evidence item.

Business Meaning: Governance records provide traceability and auditability of ethical oversight.

Related Terms: Application, Evidence, Decision, Archive.

Business Owner: Research Governance Authority.

Typical Usage: "The governance record shows the decision rationale."

### Oversight

Definition: Authorized monitoring or review of governance activity, quality, compliance, and performance.

Business Meaning: Oversight supports institutional and national accountability.

Related Terms: Reporting, Compliance, Governance Record, Regulatory Observer.

Business Owner: Ministry Leadership or Research Governance Authority.

Typical Usage: "Oversight reporting identified delayed reviews."

### Compliance

Definition: Alignment with approved governance expectations, applicable obligations, and ethical requirements.

Business Meaning: Compliance supports trust in research governance and participant protection.

Related Terms: Oversight, Audit, Governance Record, Policy.

Business Owner: Research Governance Authority.

Typical Usage: "The application requires compliance evidence."

### Audit

Definition: A formal examination of records, actions, decisions, or processes for accountability and assurance.

Business Meaning: Audit verifies that governance activity was performed and recorded appropriately.

Related Terms: Governance Record, Compliance, Oversight.

Business Owner: Authorized Audit or Oversight Authority.

Typical Usage: "The audit reviewed approval records."

## 4 Domain Vision

The domain vision is to establish a consistent business language for research ethics governance across institutions and oversight authorities.

The domain model SHALL allow stakeholders to describe applications, reviews, decisions, conditions, evidence, approvals, records, and oversight using shared terminology.

The domain model SHOULD reduce ambiguity between applicants, administrators, reviewers, committees, and leadership.

The domain model SHOULD support future analysis, documentation, architecture, testing, operations, and governance without binding the business language to implementation choices.

## 5 Domain Principles

The domain SHALL be expressed in business language.

The domain SHALL distinguish business accountability from technical responsibility.

The domain SHALL preserve the authority of research ethics committees and governance bodies.

The domain SHALL make the lifecycle of ethics governance explicit.

The domain SHALL treat evidence and governance records as core business concerns.

The domain SHOULD support institutional and national oversight.

The domain SHOULD support clear responsibility for actions and decisions.

The domain MUST NOT define software implementation.

## 6 Core Domain

The core domain is Research Ethics Governance.

Research Ethics Governance includes the business activities that determine whether a health research activity meets ethical governance expectations and how that decision is recorded, conditioned, monitored, and retained.

The core domain includes application management, ethics review, committee decision making, condition management, evidence review, approval management, governance records, and oversight.

The core domain creates the primary business value of ERM-System.

The core domain SHALL receive priority when terminology conflicts arise.

## 7 Supporting Domains

Supporting domains provide necessary business capabilities that enable the core domain.

Institution Administration supports intake coordination, routing, user coordination, record management, and local adoption.

Reporting and Oversight supports management visibility, performance review, compliance evidence, and national governance insight.

Communication Management supports business notifications, requests, reminders, and formal messages.

Reference Governance supports controlled terminology, policy references, templates, and business guidance material.

Accreditation and Capacity Governance may support institutional maturity, committee readiness, and continuous improvement where applicable.

## 8 Generic Domains

Generic domains are common business areas that support the product but do not define its unique value.

Identity and Access Responsibility represents the business need to know who is acting and what responsibilities they hold.

Document Handling represents the business need to manage submitted and retained materials.

Notification represents the business need to inform stakeholders of required actions and status changes.

Reporting represents the business need to summarize governance information for authorized audiences.

Audit Support represents the business need to examine historical activity and evidence.

## 9 Bounded Contexts

Bounded contexts define areas where terms have precise meanings within a business boundary.

This document defines nine bounded contexts.

### 9.1 Application Intake Context

Purpose: Manages the business meaning of preparing, submitting, screening, and accepting applications for review.

Core Terms: Application, Submission, Applicant, Principal Investigator, Screening.

Business Owner: Institution Administration.

Boundary: Begins when research material is prepared for ethics submission and ends when the application is accepted for review, returned for correction, withdrawn, or otherwise redirected.

### 9.2 Ethics Review Context

Purpose: Manages the business meaning of reviewer assignment, assessment, recommendations, and review outcomes.

Core Terms: Reviewer, Review Assignment, Review Outcome, Application.

Business Owner: Research Ethics Committee.

Boundary: Begins when review responsibility is assigned and ends when review input is completed or withdrawn.

### 9.3 Committee Decision Context

Purpose: Manages the business meaning of deliberation, formal decisions, decision rationale, and decision communication.

Core Terms: Research Ethics Committee, Committee Chair, Committee Decision, Condition, Approval.

Business Owner: Research Ethics Committee.

Boundary: Begins when an application is ready for committee decision and ends when the decision is recorded and communicated.

### 9.4 Conditions and Evidence Context

Purpose: Manages the business meaning of conditions, evidence submission, evidence review, resolution, and waiver.

Core Terms: Condition, Evidence, Submission, Review Outcome.

Business Owner: Research Ethics Governance.

Boundary: Begins when a condition is issued and ends when the condition is resolved, waived, superseded, or no longer actionable.

### 9.5 Approval and Certification Context

Purpose: Manages the business meaning of approved outcomes, approval validity, and formal approval representation.

Core Terms: Approval, Certificate, Research Project, Committee Decision.

Business Owner: Research Ethics Governance.

Boundary: Begins when approval is granted and ends when approval is closed, withdrawn, superseded, or archived.

### 9.6 Research Lifecycle Context

Purpose: Manages the business meaning of ongoing research governance after initial approval.

Core Terms: Research Project, Amendment, Closure, Compliance, Governance Record.

Business Owner: Research Governance Authority.

Boundary: Begins when a research project enters governed activity and ends when all required governance responsibilities are closed or archived.

### 9.7 Institutional Oversight Context

Purpose: Manages the business meaning of institutional monitoring, reporting, performance, compliance, and escalation.

Core Terms: Oversight, Compliance, Audit, Governance Record.

Business Owner: Institution Administration.

Boundary: Covers authorized institutional visibility across applications, decisions, records, and performance indicators.

### 9.8 National Governance Context

Purpose: Manages the business meaning of national oversight, policy visibility, cross-institution analysis, and strategic governance.

Core Terms: Oversight, Regulatory Observer, Research Governance Authority, Reporting.

Business Owner: Ministry Leadership.

Boundary: Covers authorized national or regulatory visibility into governance activity and outcomes.

### 9.9 Reference Knowledge Context

Purpose: Manages the business meaning of shared terminology, policy references, guidance, and reusable business definitions.

Core Terms: Glossary, Policy, Template, Reference.

Business Owner: Documentation and Governance Stewardship.

Boundary: Covers shared domain language and controlled reference material used across contexts.

## 10 Context Relationships

Application Intake provides screened applications to Ethics Review and Committee Decision.

Ethics Review provides review outcomes to Committee Decision.

Committee Decision creates decisions that may initiate Conditions and Evidence or Approval and Certification.

Conditions and Evidence provides resolved or unresolved condition status back to Committee Decision and Approval and Certification.

Approval and Certification provides approved outcome information to Research Lifecycle.

Research Lifecycle may initiate new governance interactions such as amendments or closure actions.

Institutional Oversight observes and reports across institutional contexts.

National Governance observes authorized information across institutions.

Reference Knowledge provides shared terminology and guidance to all contexts.

Context relationships SHALL preserve the meaning of terms within their bounded contexts.

## 11 Business Actors

Business actors are people or governance bodies participating in the domain.

Principal Investigator is accountable for the research project and application integrity.

Applicant initiates and manages submission interactions.

Researcher contributes to research materials and project activity.

Ethics Administrator coordinates administrative governance activity.

Reviewer assesses submitted material and provides review outcomes.

Committee Chair coordinates committee authority and decision accountability.

Research Ethics Committee issues ethics governance decisions.

Institution Administrator manages institutional participation and local governance support.

Research Governance Authority defines governance expectations and oversight responsibilities.

Ministry Leadership provides strategic direction and national oversight expectations.

Regulatory Observer reviews authorized governance evidence.

## 12 Business Roles

A business role is a responsibility pattern within the domain.

Applicant Role submits and responds to governance requests.

Principal Investigator Role carries primary accountability for research ethics compliance.

Reviewer Role evaluates material and provides review input.

Committee Member Role participates in deliberation and decision support.

Committee Chair Role confirms and coordinates decision accountability.

Administrator Role coordinates process, status, communication, and records.

Governance Officer Role monitors compliance, performance, and institutional obligations.

Oversight Role reviews governance activity for policy, compliance, or regulatory purposes.

Reference Steward Role maintains shared terminology and domain references.

## 13 Domain Concepts

Ethics Governance is the organized business practice of ensuring that research is reviewed, approved, monitored, and recorded according to ethical expectations.

Review Readiness is the state in which an application has enough business completeness to proceed to review.

Decision Accountability is the principle that governance outcomes must be attributable to authorized actors.

Condition Resolution is the process of determining whether a requirement has been satisfied, waived, or otherwise concluded.

Evidence Sufficiency is the business judgment that submitted material adequately supports a requirement or decision.

Governance Traceability is the ability to connect submissions, reviews, decisions, evidence, approvals, and records.

Oversight Visibility is authorized access to governance status and evidence for monitoring and assurance.

Lifecycle Closure is the conclusion of active governance responsibility for a research project or application.

## 14 Business Entities

This document defines twelve primary business entities.

### 14.1 Application

Purpose: Represents the formal ethics review request for a research activity.

Business Responsibility: Carries submitted information through screening, review, decision, condition, approval, closure, or archive.

Relationships: Relates to Research Project, Principal Investigator, Applicant, Review Assignment, Committee Decision, Condition, Evidence, Governance Record.

Lifecycle: Prepared, submitted, screened, reviewed, decided, condition-managed, approved, rejected, withdrawn, closed, or archived.

Ownership: Principal Investigator for submission integrity; Research Ethics Governance for decision lifecycle.

### 14.2 Research Project

Purpose: Represents the real-world health research activity subject to ethics governance.

Business Responsibility: Provides the ethical and operational subject of governance review.

Relationships: Relates to Application, Principal Investigator, Research Team, Approval, Amendment, Closure.

Lifecycle: Proposed, submitted for review, approved, amended, active, completed, closed, or archived.

Ownership: Principal Investigator and Research Institution.

### 14.3 Principal Investigator

Purpose: Represents the accountable person responsible for the research project.

Business Responsibility: Ensures truthful submission, response to requirements, and ongoing compliance.

Relationships: Relates to Research Project, Application, Research Team, Condition, Evidence.

Lifecycle: Identified, confirmed, active, changed, or removed according to governance rules.

Ownership: Research Institution.

### 14.4 Research Ethics Committee

Purpose: Represents the authorized governance body for ethics review.

Business Responsibility: Reviews research activities and issues decisions.

Relationships: Relates to Reviewer, Committee Chair, Committee Decision, Application, Review Outcome.

Lifecycle: Constituted, active, reviewed, renewed, suspended, or retired according to governance rules.

Ownership: Research Governance Authority or Institution, according to policy.

### 14.5 Reviewer

Purpose: Represents a person assigned to evaluate submitted materials.

Business Responsibility: Provides review findings or recommendations.

Relationships: Relates to Review Assignment, Review Outcome, Application, Research Ethics Committee.

Lifecycle: Eligible, assigned, reviewing, completed, unavailable, or reassigned.

Ownership: Research Ethics Committee.

### 14.6 Review Assignment

Purpose: Represents responsibility to perform a review.

Business Responsibility: Connects an application or material to an expected reviewer action.

Relationships: Relates to Reviewer, Application, Review Outcome, Ethics Administrator.

Lifecycle: Created, assigned, accepted, completed, overdue, cancelled, or reassigned.

Ownership: Ethics Administrator and Research Ethics Committee.

### 14.7 Review Outcome

Purpose: Represents documented review input.

Business Responsibility: Supports committee decision making or administrative follow-up.

Relationships: Relates to Review Assignment, Reviewer, Application, Committee Decision, Condition.

Lifecycle: Drafted, submitted, considered, superseded, or retained.

Ownership: Reviewer for content; Committee for decision use.

### 14.8 Committee Decision

Purpose: Represents the formal outcome of committee authority.

Business Responsibility: Determines the next business state of an application or research project.

Relationships: Relates to Application, Research Ethics Committee, Committee Chair, Condition, Approval, Rejection, Governance Record.

Lifecycle: Proposed, deliberated, issued, communicated, acted upon, superseded, or archived.

Ownership: Research Ethics Committee.

### 14.9 Condition

Purpose: Represents a requirement issued by governance authority.

Business Responsibility: Defines an obligation that must be resolved for the application or research project.

Relationships: Relates to Committee Decision, Application, Evidence, Principal Investigator, Reviewer.

Lifecycle: Issued, open, evidence-submitted, under-review, met, not-met, waived, superseded, or archived.

Ownership: Research Ethics Committee for requirement; Principal Investigator for response where applicable.

### 14.10 Evidence

Purpose: Represents material used to support a claim, condition response, review, or governance decision.

Business Responsibility: Provides basis for judgment, traceability, and audit.

Relationships: Relates to Condition, Application, Research Project, Governance Record, Reviewer.

Lifecycle: Requested, submitted, reviewed, accepted, rejected, superseded, retained, or archived.

Ownership: Submitting party for submitted material; Governance authority for retained governance record.

### 14.11 Approval

Purpose: Represents authorized permission for research to proceed under defined terms.

Business Responsibility: Communicates positive ethics governance outcome and conditions.

Relationships: Relates to Committee Decision, Research Project, Certificate, Condition, Closure.

Lifecycle: Granted, active, amended, suspended where policy allows, closed, superseded, or archived.

Ownership: Research Ethics Committee and Research Governance Authority.

### 14.12 Governance Record

Purpose: Represents retained evidence of governance activity.

Business Responsibility: Preserves traceability, accountability, auditability, and institutional memory.

Relationships: Relates to Application, Review Outcome, Committee Decision, Condition, Evidence, Approval, Audit.

Lifecycle: Created, retained, referenced, audited, archived, or superseded.

Ownership: Institution Administration and Research Governance Authority.

## 15 Entity Responsibilities

Application is responsible for carrying the ethics governance request through the lifecycle.

Research Project is responsible for representing the research activity being governed.

Principal Investigator is responsible for accountability and compliance commitment.

Research Ethics Committee is responsible for authorized ethics decision making.

Reviewer is responsible for documented assessment.

Review Assignment is responsible for making review responsibility explicit.

Review Outcome is responsible for preserving review input.

Committee Decision is responsible for defining formal governance outcome.

Condition is responsible for representing required action or resolution.

Evidence is responsible for supporting judgment and accountability.

Approval is responsible for representing authorized permission.

Governance Record is responsible for preserving historical accountability.

## 16 Business Value Objects

Application Status describes the current business position of an application in the governance lifecycle.

Decision Outcome describes the result of committee authority.

Condition Status describes whether a requirement is open, under review, resolved, waived, or no longer actionable.

Review Recommendation describes reviewer advice for committee consideration.

Approval Validity describes the business period or terms under which approval is recognized.

Risk Level describes the business seriousness of an ethics, compliance, or governance concern.

Confidentiality Level describes the sensitivity of governance information.

Review Deadline describes the expected date or period for review action.

Governance Identifier describes a stable business reference used to identify a governance item.

## 17 Business Events

Application Prepared indicates that submission material has been assembled.

Application Submitted indicates that an applicant has formally provided an application for ethics governance.

Application Screened indicates that administrative readiness has been assessed.

Review Assigned indicates that a reviewer has been given review responsibility.

Review Completed indicates that review input has been submitted.

Committee Decision Issued indicates that formal committee authority has produced a decision.

Condition Issued indicates that a required action has been created.

Evidence Submitted indicates that material has been provided in response to a request or condition.

Condition Resolved indicates that a condition has reached a business conclusion.

Approval Granted indicates that ethics permission has been issued.

Amendment Requested indicates that a change to a governed research activity has been proposed.

Research Closed indicates that active governance follow-up has concluded.

Record Archived indicates that governance material has moved into retained historical status.

## 18 Business Commands

Prepare Application is a request to assemble research ethics material.

Submit Application is a request to place an application into the governance process.

Screen Application is a request to assess administrative readiness.

Assign Reviewer is a request to allocate review responsibility.

Submit Review Outcome is a request to provide review input.

Record Committee Decision is a request to capture formal governance outcome.

Issue Condition is a request to create a required action.

Submit Evidence is a request to provide material supporting a requirement.

Assess Evidence is a request to judge whether evidence supports resolution.

Grant Approval is a request to record positive governance outcome.

Request Amendment is a request to consider a change to governed research activity.

Close Research Governance is a request to conclude active governance follow-up.

Archive Governance Record is a request to retain material as historical evidence.

## 19 Business Policies

Application Submission Policy defines who may submit and what business completeness is required.

Screening Policy defines how administrative readiness is assessed.

Reviewer Assignment Policy defines how review responsibility is allocated.

Committee Decision Policy defines how authorized decisions are issued and recorded.

Condition Management Policy defines how requirements are created, resolved, waived, or superseded.

Evidence Sufficiency Policy defines how submitted material is judged for business adequacy.

Approval Policy defines the conditions under which approval may be granted and recognized.

Closure Policy defines how active governance responsibility ends.

Archive Policy defines how governance records are retained for future accountability.

Oversight Policy defines how authorized stakeholders may review governance activity.

## 20 Business Rules (High Level)

An application SHALL have an accountable principal investigator.

An application SHALL be submitted before formal review may occur.

An application SHOULD be screened for business completeness before review.

A reviewer SHALL have an explicit review assignment before a review outcome is expected.

A committee decision SHALL be attributable to an authorized research ethics committee.

A condition SHALL be associated with a decision, application, or research governance requirement.

Evidence SHALL be associated with the requirement or governance item it supports.

Approval SHALL be based on an authorized decision.

Governance records SHALL be retained according to approved retention expectations.

Oversight access SHALL be limited to authorized business purposes.

## 21 Domain Services (Business Perspective)

Application Intake Coordination is the business service that organizes submission and screening activity.

Review Coordination is the business service that organizes review assignments and review completion.

Committee Decision Coordination is the business service that supports decision readiness, recording, and communication.

Condition Resolution Coordination is the business service that manages requirements, evidence, and resolution outcomes.

Approval Coordination is the business service that manages recognition and communication of approved outcomes.

Governance Record Stewardship is the business service that preserves accountable records.

Oversight Reporting is the business service that provides authorized visibility into governance activity.

Reference Stewardship is the business service that maintains shared domain language and guidance.

## 22 Domain Lifecycle

The domain lifecycle begins when a research activity requires ethics governance.

The lifecycle continues through preparation, submission, screening, review, decision, conditions, evidence, approval or rejection, governed activity, amendments where applicable, closure, and archival.

Not every research activity follows every possible lifecycle branch.

The lifecycle SHALL preserve accountability for who acted, what was decided, what evidence was considered, and what outcome was reached.

The lifecycle SHALL distinguish active governance work from retained historical records.

## 23 State Transitions (Business Level)

An application may move from Prepared to Submitted.

An application may move from Submitted to Under Screening.

An application may move from Under Screening to Returned for Correction.

An application may move from Under Screening to Ready for Review.

An application may move from Ready for Review to Under Review.

An application may move from Under Review to Awaiting Committee Decision.

An application may move from Awaiting Committee Decision to Conditions Issued.

An application may move from Conditions Issued to Awaiting Evidence.

An application may move from Awaiting Evidence to Evidence Under Review.

An application may move from Evidence Under Review to Approved.

An application may move from Evidence Under Review to Further Conditions Required.

An application may move from Awaiting Committee Decision to Rejected.

An application may move from an eligible active state to Withdrawn where business rules allow.

An approved research project may move to Amendment Requested.

An approved research project may move to Closed.

A closed governance record may move to Archived.

State transition definitions SHALL remain business-level and SHALL NOT imply implementation design.

## 24 Capability Mapping

| Capability | Core Context | Primary Business Owner |
| --- | --- | --- |
| Application Management | Application Intake | Institution Administration |
| Administrative Screening | Application Intake | Ethics Administrator |
| Ethics Review | Ethics Review | Research Ethics Committee |
| Committee Decision Management | Committee Decision | Research Ethics Committee |
| Condition Management | Conditions and Evidence | Research Ethics Governance |
| Evidence Management | Conditions and Evidence | Research Ethics Governance |
| Approval Management | Approval and Certification | Research Ethics Governance |
| Research Lifecycle Oversight | Research Lifecycle | Research Governance Authority |
| Institutional Reporting | Institutional Oversight | Institution Administration |
| National Oversight Reporting | National Governance | Ministry Leadership |
| Reference Stewardship | Reference Knowledge | Documentation and Governance Stewardship |

## 25 Domain Glossary

Application: A formal request for ethics review of a proposed or ongoing health research activity.

Approval: A positive governance outcome authorizing the research activity under defined ethical conditions.

Archive: The retained historical state of governance records no longer active in daily processing.

Audit: A formal examination of records, actions, decisions, or processes for accountability and assurance.

Certificate: A formal representation of an approved ethics governance outcome.

Committee Decision: The formal decision issued by an authorized ethics governance body.

Condition: A requirement issued as part of a governance decision.

Evidence: Material submitted to demonstrate that a requirement, condition, or governance expectation has been addressed.

Governance Record: A retained business record documenting an ethics governance activity, decision, action, or evidence item.

Principal Investigator: The person with primary business accountability for the research project and ethics application.

Research Ethics Committee: An authorized governance body responsible for ethics review and decision making.

Review Assignment: A business allocation of review responsibility to a reviewer or committee member.

Review Outcome: The documented result of a review activity.

Submission: The act of providing an application or follow-up material to the governance process.

## 26 Assumptions

ERM-System is focused on health research ethics governance.

The product supports institutional and oversight responsibilities.

Research ethics committees retain business authority for ethics decisions.

Principal investigators remain accountable for research submission integrity and compliance.

Business terminology will continue to evolve as governance practices mature.

Future documents will use this domain model as the terminology source of truth.

## 27 Constraints

This document SHALL NOT describe software design.

This document SHALL NOT describe implementation.

This document SHALL NOT describe APIs.

This document SHALL NOT describe persistence.

This document SHALL NOT describe database schema.

This document SHALL remain technology independent.

This document SHALL define business language at a level suitable for enterprise architecture.

Detailed policies SHALL be defined in future policy or governance documents.

## 28 Future Domain Evolution

The domain may evolve as national adoption expands.

The domain may evolve as institutional governance maturity increases.

The domain may evolve as additional ethics governance processes are formalized.

The domain may evolve as reporting, accreditation, monitoring, and policy support capabilities mature.

Future evolution SHOULD preserve backward traceability to approved terminology.

New terms SHOULD be assessed against the existing ubiquitous language before adoption.

Bounded contexts SHOULD be revised when business meaning changes materially.

## 29 References

`docs/product/PRODUCT_DEFINITION.md`: Authoritative product definition.

`docs/governance/ENGINEERING_MANIFEST.md`: Root engineering governance reference.

`docs/governance/ENGINEERING_DOCUMENTATION_STANDARD.md`: Documentation standard.

RFC 2119: Key words for use in RFCs to Indicate Requirement Levels.

Future glossary and acronym references SHOULD align with this domain model.

## 30 Appendix

### Appendix A Business Term Governance

New domain terms SHOULD be reviewed by Domain Architecture.

New domain terms SHOULD include definition, business meaning, related terms, business owner, and typical usage.

Terms that conflict with this document SHOULD be escalated for domain review.

Deprecated terms SHOULD identify replacement terminology.

### Appendix B Business Entity Governance

New business entities SHOULD include purpose, business responsibility, relationships, lifecycle, and ownership.

Entity changes SHOULD be reviewed when they affect downstream documentation.

Entity naming SHOULD remain business-oriented.

Entity definitions SHALL NOT be replaced by technical implementation names.

### Appendix C Context Governance

Bounded context changes SHOULD identify business reason, affected terms, affected entities, and affected downstream documents.

Context boundaries SHOULD be reviewed when responsibilities shift between stakeholders.

Context relationships SHOULD remain explicit where they influence business interpretation.
