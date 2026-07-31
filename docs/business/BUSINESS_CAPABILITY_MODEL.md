# Business Capability Model

## Document Metadata

Document ID: SPEC-0006

Title: Business Capability Model

Status: Approved

Version: 1.0

Owner: Enterprise Business Architecture

Approvers: Product Governance, Research Governance Authority, Enterprise Architecture

Reviewers: Ministry Leadership, Research Ethics Governance, Business Analysis, Domain Architecture, Program Management

Classification: Specification

Audience: Ministry Leadership, Research Governance Authorities, Institution Administrators, Research Ethics Committees, Researchers, Principal Investigators, Reviewers, Hospitals, Universities, Regulatory Bodies, Enterprise Architects, Business Analysts, and Future Contributors

Created: 2026-07-31

Last Updated: 2026-07-31

Next Review: To be scheduled by Enterprise Business Architecture

Related Documents: `docs/product/PRODUCT_DEFINITION.md`, `docs/domain/DOMAIN_MODEL.md`, `docs/governance/ENGINEERING_MANIFEST.md`, `docs/governance/ENGINEERING_DOCUMENTATION_STANDARD.md`

Depends On: `docs/product/PRODUCT_DEFINITION.md`, `docs/domain/DOMAIN_MODEL.md`

References: RFC 2119

Keywords: business capability, capability model, enterprise architecture, research ethics, roadmap, maturity, business value

Confidentiality: Internal

## Normative Language

The key words MUST, MUST NOT, SHALL, SHALL NOT, SHOULD, SHOULD NOT, and MAY in this document are to be interpreted as described by RFC 2119 when used as normative terms.

## 1 Executive Summary

This Business Capability Model defines the business capabilities required by ERM-System.

ERM-System is an Enterprise Research Ethics Management Platform that supports the complete lifecycle of ethical governance for health research.

This document describes what the business must be able to do.

It does not describe how those capabilities are implemented.

The model SHALL become the foundation for application architecture, solution architecture, module design, roadmaps, release planning, gap analysis, and future expansion.

The model is technology independent and business focused.

The model organizes capabilities into Level 1 capability domains, Level 2 capability groups, and selected Level 3 capability details where additional business decomposition is useful.

Every capability in the catalog includes a capability identifier, name, business description, owner, business value, inputs, outputs, dependencies, consumers, success measures, maturity, and priority.

Future planning documents SHOULD derive business capability language from this model.

## 2 Capability Philosophy

A business capability describes a stable business ability.

A capability is not a team, process step, organization unit, workflow screen, technical service, data store, or implementation component.

Capabilities SHOULD remain stable even when processes, organization structures, and technology choices change.

Capabilities SHALL be named in business language.

Capabilities SHALL express business outcomes and responsibilities.

Capabilities SHOULD be decomposed only to the level required for planning, ownership, maturity assessment, gap analysis, and roadmap definition.

Capability planning SHOULD support strategic alignment, investment prioritization, governance maturity, and future expansion.

## 3 Capability Map (Level 1)

The Level 1 capability map defines the major business capability domains required by ERM-System.

| Capability ID | Level 1 Capability | Category | Primary Owner | Priority |
| --- | --- | --- | --- | --- |
| BCM-01 | Research Ethics Application Management | Core | Research Ethics Governance | Critical |
| BCM-02 | Ethics Review and Decision Management | Core | Research Ethics Committee | Critical |
| BCM-03 | Conditions and Evidence Management | Core | Research Ethics Governance | Critical |
| BCM-04 | Approval and Research Lifecycle Governance | Core | Research Governance Authority | Critical |
| BCM-05 | Governance Oversight and Compliance | Governance | Research Governance Authority | Critical |
| BCM-06 | Institutional Administration | Supporting | Institution Administration | High |
| BCM-07 | Stakeholder Communication and Engagement | Shared | Institution Administration | High |
| BCM-08 | Analytics and Reporting | Analytics | Research Governance Authority | High |
| BCM-09 | Reference and Knowledge Management | Shared | Documentation and Governance Stewardship | High |
| BCM-10 | Ecosystem Coordination and Future Expansion | Future | Ministry Leadership | Medium |

## 4 Capability Decomposition (Level 2)

Level 2 capabilities decompose each Level 1 capability into major business capability groups.

| Parent ID | Level 2 Capability ID | Capability Name |
| --- | --- | --- |
| BCM-01 | BCM-01.01 | Application Preparation |
| BCM-01 | BCM-01.02 | Application Submission |
| BCM-01 | BCM-01.03 | Administrative Screening |
| BCM-01 | BCM-01.04 | Application Status Management |
| BCM-02 | BCM-02.01 | Reviewer Assignment |
| BCM-02 | BCM-02.02 | Review Assessment |
| BCM-02 | BCM-02.03 | Committee Deliberation |
| BCM-02 | BCM-02.04 | Decision Recording |
| BCM-03 | BCM-03.01 | Condition Issuance |
| BCM-03 | BCM-03.02 | Evidence Submission |
| BCM-03 | BCM-03.03 | Evidence Assessment |
| BCM-03 | BCM-03.04 | Condition Resolution |
| BCM-04 | BCM-04.01 | Approval Management |
| BCM-04 | BCM-04.02 | Certificate Management |
| BCM-04 | BCM-04.03 | Amendment Governance |
| BCM-04 | BCM-04.04 | Closure and Archival Governance |
| BCM-05 | BCM-05.01 | Compliance Oversight |
| BCM-05 | BCM-05.02 | Audit Readiness |
| BCM-05 | BCM-05.03 | Governance Risk Monitoring |
| BCM-05 | BCM-05.04 | Policy Alignment |
| BCM-06 | BCM-06.01 | Institution Configuration Stewardship |
| BCM-06 | BCM-06.02 | Role and Responsibility Administration |
| BCM-06 | BCM-06.03 | Committee Administration |
| BCM-06 | BCM-06.04 | Workload Coordination |
| BCM-07 | BCM-07.01 | Business Notification Management |
| BCM-07 | BCM-07.02 | Stakeholder Request Management |
| BCM-07 | BCM-07.03 | Communication Record Management |
| BCM-08 | BCM-08.01 | Operational Reporting |
| BCM-08 | BCM-08.02 | Executive Reporting |
| BCM-08 | BCM-08.03 | Oversight Analytics |
| BCM-08 | BCM-08.04 | Performance Monitoring |
| BCM-09 | BCM-09.01 | Glossary Stewardship |
| BCM-09 | BCM-09.02 | Policy Reference Management |
| BCM-09 | BCM-09.03 | Template and Guidance Management |
| BCM-10 | BCM-10.01 | National Adoption Planning |
| BCM-10 | BCM-10.02 | Institutional Onboarding |
| BCM-10 | BCM-10.03 | External Stakeholder Coordination |
| BCM-10 | BCM-10.04 | Future Capability Assessment |

## 5 Capability Decomposition (Level 3 where appropriate)

Level 3 decomposition is used only where capability planning requires additional business detail.

| Parent ID | Level 3 Capability ID | Capability Name |
| --- | --- | --- |
| BCM-01.01 | BCM-01.01.01 | Research Information Capture |
| BCM-01.01 | BCM-01.01.02 | Supporting Material Preparation |
| BCM-01.03 | BCM-01.03.01 | Completeness Review |
| BCM-01.03 | BCM-01.03.02 | Administrative Return for Correction |
| BCM-02.01 | BCM-02.01.01 | Reviewer Eligibility Identification |
| BCM-02.01 | BCM-02.01.02 | Review Work Allocation |
| BCM-02.04 | BCM-02.04.01 | Decision Outcome Capture |
| BCM-02.04 | BCM-02.04.02 | Decision Rationale Capture |
| BCM-03.03 | BCM-03.03.01 | Evidence Sufficiency Review |
| BCM-03.03 | BCM-03.03.02 | Evidence Rejection Management |
| BCM-04.03 | BCM-04.03.01 | Amendment Request Intake |
| BCM-04.03 | BCM-04.03.02 | Amendment Review Coordination |
| BCM-05.02 | BCM-05.02.01 | Governance Record Retrieval |
| BCM-05.02 | BCM-05.02.02 | Audit Evidence Packaging |
| BCM-08.03 | BCM-08.03.01 | Cross-Institution Trend Analysis |
| BCM-08.03 | BCM-08.03.02 | Governance Risk Insight |

## 6 Core Capabilities

Core capabilities directly create the primary business value of ERM-System.

Core capabilities SHALL receive priority in roadmap planning, maturity assessment, and gap analysis.

Core capabilities include Research Ethics Application Management, Ethics Review and Decision Management, Conditions and Evidence Management, and Approval and Research Lifecycle Governance.

These capabilities define the central ethics governance lifecycle.

## 7 Supporting Capabilities

Supporting capabilities enable the core capabilities to operate effectively.

Supporting capabilities include Institutional Administration, Stakeholder Communication and Engagement, and Reference and Knowledge Management.

Supporting capabilities SHOULD be planned in alignment with the core lifecycle.

## 8 Shared Capabilities

Shared capabilities are used across multiple stakeholder groups and business processes.

Shared capabilities include communication records, reference stewardship, template guidance, role responsibility administration, and stakeholder request management.

Shared capabilities SHOULD maintain consistent business meaning across institutions.

## 9 Governance Capabilities

Governance capabilities preserve accountability, compliance, oversight, risk visibility, and policy alignment.

Governance capabilities include Governance Oversight and Compliance, Audit Readiness, Policy Alignment, and Governance Risk Monitoring.

Governance capabilities SHALL be treated as business-critical because they protect trust in research ethics management.

## 10 Analytics Capabilities

Analytics capabilities help authorized stakeholders interpret activity, performance, risk, workload, and governance maturity.

Analytics capabilities SHOULD support operational, executive, oversight, and future strategic analysis.

Analytics capabilities SHALL use approved business definitions.

Analytics capabilities SHALL distinguish business insight from formal committee decision authority.

## 11 Reporting Capabilities

Reporting capabilities provide structured business information for authorized consumers.

Reporting capabilities include operational reporting, executive reporting, oversight reporting, compliance reporting, and performance reporting.

Reporting capabilities SHOULD support consistent interpretation across institutions.

Reporting capabilities SHALL preserve confidentiality and authorized purpose.

## 12 Administration Capabilities

Administration capabilities support institutional participation, committee administration, role stewardship, workload coordination, and process readiness.

Administration capabilities SHALL support clear responsibility assignment.

Administration capabilities SHOULD reduce ambiguity in operational coordination without replacing committee authority.

## 13 Integration Capabilities

Integration capabilities are business capabilities for coordination with external stakeholders, institutions, authorities, and future ecosystem participants.

Integration capabilities SHALL be described as business information exchange and coordination needs.

Integration capabilities SHALL NOT prescribe technical integration mechanisms.

Integration capabilities include external stakeholder coordination, institutional onboarding, national adoption planning, and future capability assessment.

## 14 Future Capabilities

Future capabilities are candidate business abilities that may become necessary as adoption expands.

Future capabilities MAY include advanced accreditation support, national benchmarking, expanded policy guidance, training governance, research site readiness assessment, and cross-border ethics collaboration.

Future capabilities SHALL be assessed before adoption.

Future capabilities SHOULD be linked to business value, governance need, and stakeholder demand.

## 15 Capability Dependencies

Capability dependencies SHALL be made visible before roadmap decisions.

| Capability | Depends On | Dependency Meaning |
| --- | --- | --- |
| Ethics Review and Decision Management | Research Ethics Application Management | Review requires an application ready for assessment. |
| Conditions and Evidence Management | Ethics Review and Decision Management | Conditions usually arise from governance decisions or review findings. |
| Approval and Research Lifecycle Governance | Ethics Review and Decision Management, Conditions and Evidence Management | Approval depends on an authorized decision and condition status where applicable. |
| Governance Oversight and Compliance | All core capabilities | Oversight depends on reliable governance activity and records. |
| Analytics and Reporting | Core and governance capabilities | Reporting depends on consistent business events and definitions. |
| Institutional Administration | Governance Oversight and Compliance | Administration requires approved responsibilities and governance expectations. |
| Reference and Knowledge Management | Product and domain governance | Shared terminology depends on authoritative business language. |
| Ecosystem Coordination and Future Expansion | Governance Oversight and Compliance, Analytics and Reporting | Expansion depends on maturity, evidence, and adoption readiness. |

## 16 Capability Ownership

Every capability SHALL have a business owner.

Capability owners SHALL be accountable for business meaning, priority, maturity assessment, and future change requests.

Ownership MAY be assigned to a role, function, or authority when named individuals are not available.

| Owner | Capability Scope |
| --- | --- |
| Research Ethics Governance | Core ethics governance lifecycle, conditions, evidence, approval meaning. |
| Research Ethics Committee | Review, deliberation, and decision capabilities. |
| Research Governance Authority | Compliance, oversight, lifecycle governance, and reporting expectations. |
| Institution Administration | Administrative coordination, institutional readiness, and workload capabilities. |
| Ministry Leadership | National adoption, ecosystem coordination, and strategic oversight. |
| Documentation and Governance Stewardship | Reference, glossary, policy reference, and guidance capabilities. |

## 17 Capability Maturity

Capability maturity SHALL describe the business maturity of each capability.

The maturity scale SHALL be used for planning and gap analysis.

| Maturity | Definition |
| --- | --- |
| Initial | Capability exists informally or inconsistently. |
| Defined | Capability has agreed business meaning and basic governance expectations. |
| Managed | Capability is actively governed, measured, and improved. |
| Optimized | Capability is mature, evidence-driven, and continuously improved. |

Current maturity in this document is an initial planning assessment.

Future maturity assessments SHOULD be validated by business owners.

## 18 Capability Priorities

Capability priority SHALL guide sequencing and investment decisions.

Critical capabilities are necessary for trustworthy ethics governance.

High priority capabilities enable scale, consistency, and institutional adoption.

Medium priority capabilities support future expansion or maturity.

Low priority capabilities may be deferred until business demand is validated.

Priority SHALL NOT be interpreted as implementation sequence without roadmap review.

## 19 Capability Roadmap

The capability roadmap SHALL support phased business maturity.

| Phase | Capability Focus | Outcome |
| --- | --- | --- |
| Phase 1 | Core lifecycle capabilities | Applications, reviews, decisions, conditions, evidence, and approvals are governed as a coherent business lifecycle. |
| Phase 2 | Administration and communication capabilities | Institutions can coordinate responsibilities, workloads, and stakeholder communications. |
| Phase 3 | Governance and compliance capabilities | Oversight, audit readiness, policy alignment, and governance risk visibility mature. |
| Phase 4 | Analytics and reporting capabilities | Operational, executive, and oversight reporting become consistent and reliable. |
| Phase 5 | Reference and knowledge capabilities | Shared terminology, guidance, and templates are mature and maintained. |
| Phase 6 | Ecosystem expansion capabilities | National adoption, institutional onboarding, and future capability assessment are coordinated. |

## 20 Business Value Mapping

| Business Value | Supporting Capabilities |
| --- | --- |
| Participant protection | Ethics Review and Decision Management, Conditions and Evidence Management, Governance Oversight and Compliance |
| Researcher clarity | Research Ethics Application Management, Stakeholder Communication and Engagement, Reference and Knowledge Management |
| Committee accountability | Ethics Review and Decision Management, Approval and Research Lifecycle Governance, Audit Readiness |
| Institutional control | Institutional Administration, Analytics and Reporting, Governance Oversight and Compliance |
| National oversight | Analytics and Reporting, Governance Oversight and Compliance, Ecosystem Coordination and Future Expansion |
| Audit readiness | Governance Oversight and Compliance, Conditions and Evidence Management, Approval and Research Lifecycle Governance |

## 21 Stakeholder Mapping

| Stakeholder | Primary Capabilities Consumed |
| --- | --- |
| Ministry Leadership | Governance Oversight and Compliance, Analytics and Reporting, Ecosystem Coordination and Future Expansion |
| Research Governance Authorities | Governance Oversight and Compliance, Approval and Research Lifecycle Governance, Analytics and Reporting |
| Institution Administrators | Institutional Administration, Research Ethics Application Management, Stakeholder Communication and Engagement |
| Research Ethics Committees | Ethics Review and Decision Management, Conditions and Evidence Management, Approval and Research Lifecycle Governance |
| Researchers | Research Ethics Application Management, Stakeholder Communication and Engagement, Reference and Knowledge Management |
| Principal Investigators | Research Ethics Application Management, Conditions and Evidence Management, Approval and Research Lifecycle Governance |
| Reviewers | Ethics Review and Decision Management, Stakeholder Communication and Engagement |
| Regulatory Bodies | Governance Oversight and Compliance, Analytics and Reporting, Audit Readiness |

## 22 Strategic Objectives Mapping

| Strategic Objective | Capabilities Supporting Objective |
| --- | --- |
| Strengthen ethical governance | Core lifecycle capabilities, Governance Oversight and Compliance |
| Improve transparency | Application Status Management, Reporting, Communication Record Management |
| Improve accountability | Decision Recording, Audit Readiness, Governance Record Retrieval |
| Support standardization | Reference and Knowledge Management, Policy Alignment, Institutional Administration |
| Improve reporting | Analytics and Reporting, Performance Monitoring, Executive Reporting |
| Support national adoption | Ecosystem Coordination and Future Expansion, National Adoption Planning, Institutional Onboarding |

## 23 Constraints

This document SHALL NOT describe software modules.

This document SHALL NOT describe implementation.

This document SHALL NOT describe APIs.

This document SHALL NOT describe databases.

This document SHALL NOT describe UI.

This document SHALL remain technology independent.

This document SHALL define business capabilities rather than processes alone.

Capability names SHALL remain business-oriented.

## 24 Assumptions

ERM-System is an Enterprise Research Ethics Management Platform.

The product supports the ethical governance lifecycle for health research.

Business capability ownership may be assigned to roles or functions rather than named individuals.

Capability maturity assessments are initial planning assessments until validated by business owners.

National adoption and future expansion will require additional capability assessment.

Future architecture, roadmap, release, and gap analysis work will use this model as a business foundation.

## 25 Future Evolution

This capability model SHOULD be reviewed as product scope, institutional adoption, and governance maturity evolve.

New capabilities SHOULD be added only when they represent stable business abilities.

Capabilities SHOULD be retired, merged, or reclassified when business meaning changes.

Capability maturity SHOULD be reassessed periodically.

Capability ownership SHOULD be updated when governance responsibility changes.

Future capability changes SHOULD preserve traceability to product and domain definitions.

## 26 References

`docs/product/PRODUCT_DEFINITION.md`: Authoritative product definition.

`docs/domain/DOMAIN_MODEL.md`: Authoritative domain terminology and business concepts.

`docs/governance/ENGINEERING_MANIFEST.md`: Root engineering governance reference.

`docs/governance/ENGINEERING_DOCUMENTATION_STANDARD.md`: Documentation standard.

RFC 2119: Key words for use in RFCs to Indicate Requirement Levels.

## 27 Appendix A - Capability Catalog

Every capability below includes the mandatory capability attributes required by this specification.

### BCM-01 Research Ethics Application Management

Capability ID: BCM-01

Capability Name: Research Ethics Application Management

Business Description: Manages the business lifecycle of ethics applications from preparation through readiness for review.

Business Owner: Research Ethics Governance

Business Value: Establishes a controlled entry point for research ethics governance.

Inputs: Research project information, applicant information, supporting materials, submission intent.

Outputs: Submitted application, application status, screening outcome, governance record.

Dependencies: Product scope, domain terminology, institutional submission rules.

Consumers: Researchers, principal investigators, ethics administrators, reviewers, committees.

Success Measures: Complete submissions, reduced clarification cycles, visible application status, timely screening.

Maturity: Defined

Priority: Critical

### BCM-01.01 Application Preparation

Capability ID: BCM-01.01

Capability Name: Application Preparation

Business Description: Enables research teams to assemble the business information required for ethics review.

Business Owner: Principal Investigator

Business Value: Improves submission completeness and researcher readiness.

Inputs: Research proposal, participant materials, governance requirements, researcher declarations.

Outputs: Prepared application package.

Dependencies: Reference guidance, product scope, domain terminology.

Consumers: Applicants, principal investigators, ethics administrators.

Success Measures: Prepared applications meet stated completeness expectations.

Maturity: Initial

Priority: Critical

### BCM-01.02 Application Submission

Capability ID: BCM-01.02

Capability Name: Application Submission

Business Description: Provides the formal business act of placing an application into the ethics governance process.

Business Owner: Principal Investigator

Business Value: Creates a traceable starting point for governance action.

Inputs: Prepared application package, applicant accountability statement.

Outputs: Submitted application, submission acknowledgement, initial status.

Dependencies: Application Preparation, institutional eligibility rules.

Consumers: Applicants, administrators, committees.

Success Measures: Submissions are traceable, attributable, and ready for administrative action.

Maturity: Defined

Priority: Critical

### BCM-01.03 Administrative Screening

Capability ID: BCM-01.03

Capability Name: Administrative Screening

Business Description: Assesses whether a submitted application is complete enough to proceed to review.

Business Owner: Institution Administration

Business Value: Reduces review delays caused by incomplete or misdirected submissions.

Inputs: Submitted application, completeness expectations, institutional governance rules.

Outputs: Screening outcome, return for correction, readiness confirmation.

Dependencies: Application Submission, reference guidance, administrative responsibility model.

Consumers: Applicants, ethics administrators, reviewers, committees.

Success Measures: Screening outcomes are timely, consistent, and clearly communicated.

Maturity: Defined

Priority: Critical

### BCM-01.04 Application Status Management

Capability ID: BCM-01.04

Capability Name: Application Status Management

Business Description: Maintains business visibility of where an application stands in the governance lifecycle.

Business Owner: Institution Administration

Business Value: Improves transparency and reduces uncertainty for stakeholders.

Inputs: Business events, decisions, review progress, condition progress.

Outputs: Current application status, status history, stakeholder visibility.

Dependencies: Core lifecycle capabilities, domain state definitions.

Consumers: Applicants, administrators, committees, leadership.

Success Measures: Status is current, understandable, and aligned with business rules.

Maturity: Defined

Priority: High

### BCM-02 Ethics Review and Decision Management

Capability ID: BCM-02

Capability Name: Ethics Review and Decision Management

Business Description: Manages review assignment, review assessment, committee deliberation, and formal governance decisions.

Business Owner: Research Ethics Committee

Business Value: Protects ethical review integrity and decision accountability.

Inputs: Review-ready application, review criteria, reviewer availability, committee authority.

Outputs: Review outcomes, committee decision, decision rationale, governance record.

Dependencies: Application readiness, committee governance, reviewer eligibility.

Consumers: Committees, reviewers, applicants, institutions, oversight authorities.

Success Measures: Decisions are timely, attributable, documented, and aligned with governance expectations.

Maturity: Defined

Priority: Critical

### BCM-02.01 Reviewer Assignment

Capability ID: BCM-02.01

Capability Name: Reviewer Assignment

Business Description: Allocates review responsibility to appropriate reviewers.

Business Owner: Research Ethics Committee

Business Value: Ensures qualified assessment responsibility is explicit.

Inputs: Review-ready application, reviewer availability, reviewer expertise, conflict considerations.

Outputs: Review assignment, expected review action, review deadline.

Dependencies: Committee administration, role responsibility administration.

Consumers: Reviewers, administrators, committee chairs.

Success Measures: Assignments are timely, appropriate, and accepted.

Maturity: Initial

Priority: Critical

### BCM-02.02 Review Assessment

Capability ID: BCM-02.02

Capability Name: Review Assessment

Business Description: Enables reviewers to evaluate submitted research materials and provide documented findings.

Business Owner: Research Ethics Committee

Business Value: Supports informed and accountable committee decision making.

Inputs: Assigned application, review expectations, supporting materials.

Outputs: Review findings, recommendation, requested clarifications.

Dependencies: Reviewer Assignment, reference guidance, domain terminology.

Consumers: Committees, administrators, applicants.

Success Measures: Review outcomes are complete, timely, and useful for decision making.

Maturity: Defined

Priority: Critical

### BCM-02.03 Committee Deliberation

Capability ID: BCM-02.03

Capability Name: Committee Deliberation

Business Description: Supports the business activity of committee consideration of applications and review findings.

Business Owner: Research Ethics Committee

Business Value: Preserves collective governance judgment and decision legitimacy.

Inputs: Application materials, review outcomes, committee agenda, governance criteria.

Outputs: Deliberation outcome, decision direction, action requirements.

Dependencies: Review Assessment, committee readiness, decision policy.

Consumers: Committee chair, committee members, administrators.

Success Measures: Deliberations produce clear, accountable outcomes.

Maturity: Initial

Priority: Critical

### BCM-02.04 Decision Recording

Capability ID: BCM-02.04

Capability Name: Decision Recording

Business Description: Captures formal governance decisions and the business rationale required for accountability.

Business Owner: Research Ethics Committee

Business Value: Establishes durable evidence of committee authority.

Inputs: Deliberation outcome, decision terms, conditions, rationale.

Outputs: Committee decision, decision record, communicated outcome.

Dependencies: Committee Deliberation, governance policy, record stewardship.

Consumers: Applicants, administrators, committees, oversight authorities.

Success Measures: Decisions are complete, attributable, traceable, and communicated.

Maturity: Defined

Priority: Critical

### BCM-03 Conditions and Evidence Management

Capability ID: BCM-03

Capability Name: Conditions and Evidence Management

Business Description: Manages requirements issued by governance authority and evidence submitted in response.

Business Owner: Research Ethics Governance

Business Value: Ensures required actions are traceable, assessable, and resolved.

Inputs: Committee decision, conditions, applicant responses, supporting evidence.

Outputs: Condition status, evidence assessment, resolution outcome, governance record.

Dependencies: Decision Recording, applicant accountability, review authority.

Consumers: Applicants, committees, reviewers, administrators, oversight authorities.

Success Measures: Conditions are clear, evidence is reviewed, and resolution is traceable.

Maturity: Defined

Priority: Critical

### BCM-03.01 Condition Issuance

Capability ID: BCM-03.01

Capability Name: Condition Issuance

Business Description: Creates and communicates required actions arising from governance decisions.

Business Owner: Research Ethics Committee

Business Value: Converts decision requirements into actionable obligations.

Inputs: Committee decision, required changes, ethical concerns.

Outputs: Issued conditions, action expectations, due expectations where applicable.

Dependencies: Decision Recording, policy alignment.

Consumers: Applicants, principal investigators, administrators.

Success Measures: Conditions are specific, understandable, and traceable.

Maturity: Defined

Priority: Critical

### BCM-03.02 Evidence Submission

Capability ID: BCM-03.02

Capability Name: Evidence Submission

Business Description: Enables responsible parties to provide material that addresses a condition or governance requirement.

Business Owner: Principal Investigator

Business Value: Provides the basis for condition resolution and decision progression.

Inputs: Issued condition, prepared evidence, applicant response.

Outputs: Submitted evidence, response record, updated condition status.

Dependencies: Condition Issuance, stakeholder communication.

Consumers: Administrators, reviewers, committees.

Success Measures: Evidence submissions are attributable, complete, and linked to requirements.

Maturity: Defined

Priority: Critical

### BCM-03.03 Evidence Assessment

Capability ID: BCM-03.03

Capability Name: Evidence Assessment

Business Description: Determines whether submitted evidence adequately addresses a condition or governance requirement.

Business Owner: Research Ethics Governance

Business Value: Protects decision quality and condition integrity.

Inputs: Submitted evidence, condition terms, review expectations.

Outputs: Assessment outcome, accepted evidence, rejected evidence, further request.

Dependencies: Evidence Submission, reviewer or committee authority.

Consumers: Committees, reviewers, applicants, administrators.

Success Measures: Evidence assessment outcomes are justified and traceable.

Maturity: Initial

Priority: Critical

### BCM-03.04 Condition Resolution

Capability ID: BCM-03.04

Capability Name: Condition Resolution

Business Description: Records the business conclusion of a condition.

Business Owner: Research Ethics Governance

Business Value: Enables progression to approval, further action, or closure.

Inputs: Condition, evidence assessment, waiver decision where applicable.

Outputs: Resolved condition, unresolved condition, waived condition, governance record.

Dependencies: Evidence Assessment, committee authority, policy alignment.

Consumers: Applicants, committees, oversight authorities.

Success Measures: Resolution status is accurate, authorized, and auditable.

Maturity: Defined

Priority: Critical

### BCM-04 Approval and Research Lifecycle Governance

Capability ID: BCM-04

Capability Name: Approval and Research Lifecycle Governance

Business Description: Manages approved ethics outcomes and the governed research lifecycle after decision.

Business Owner: Research Governance Authority

Business Value: Ensures approved research remains accountable throughout its lifecycle.

Inputs: Committee decision, resolved conditions, research lifecycle events.

Outputs: Approval status, certificate, amendment path, closure record, archive status.

Dependencies: Decision Recording, Conditions and Evidence Management.

Consumers: Principal investigators, institutions, committees, oversight authorities.

Success Measures: Approved research activity is traceable, current, and governed.

Maturity: Defined

Priority: Critical

### BCM-04.01 Approval Management

Capability ID: BCM-04.01

Capability Name: Approval Management

Business Description: Records and governs positive ethics outcomes and approval terms.

Business Owner: Research Ethics Committee

Business Value: Provides recognized authority for research to proceed under stated terms.

Inputs: Approval decision, condition status, approval terms.

Outputs: Active approval, approval status, approval record.

Dependencies: Decision Recording, Condition Resolution.

Consumers: Principal investigators, institutions, oversight authorities.

Success Measures: Approvals are authorized, current, and traceable.

Maturity: Defined

Priority: Critical

### BCM-04.02 Certificate Management

Capability ID: BCM-04.02

Capability Name: Certificate Management

Business Description: Manages formal business representation of approval outcomes.

Business Owner: Research Ethics Governance

Business Value: Communicates approval status and terms to authorized stakeholders.

Inputs: Approval record, certificate terms, authorized sign-off.

Outputs: Certificate, certificate status, certificate record.

Dependencies: Approval Management, governance authority.

Consumers: Principal investigators, institutions, regulatory stakeholders.

Success Measures: Certificates accurately represent approved outcomes.

Maturity: Initial

Priority: High

### BCM-04.03 Amendment Governance

Capability ID: BCM-04.03

Capability Name: Amendment Governance

Business Description: Manages proposed changes to approved or active research governance arrangements.

Business Owner: Research Governance Authority

Business Value: Ensures research changes remain ethically governed.

Inputs: Amendment request, current approval status, changed research information.

Outputs: Amendment review outcome, updated governance status, decision record.

Dependencies: Approval Management, Ethics Review and Decision Management.

Consumers: Principal investigators, committees, administrators.

Success Measures: Amendments are reviewed appropriately and linked to existing governance status.

Maturity: Initial

Priority: High

### BCM-04.04 Closure and Archival Governance

Capability ID: BCM-04.04

Capability Name: Closure and Archival Governance

Business Description: Manages conclusion of active governance and retention of historical governance records.

Business Owner: Research Governance Authority

Business Value: Preserves accountability after active activity ends.

Inputs: Closure request, completion information, governance records.

Outputs: Closed status, archived record, retained evidence.

Dependencies: Approval Management, Audit Readiness, policy alignment.

Consumers: Institutions, oversight authorities, auditors.

Success Measures: Closed and archived records remain complete and retrievable for authorized purposes.

Maturity: Initial

Priority: High

### BCM-05 Governance Oversight and Compliance

Capability ID: BCM-05

Capability Name: Governance Oversight and Compliance

Business Description: Provides business oversight of ethics governance quality, compliance, risk, and policy alignment.

Business Owner: Research Governance Authority

Business Value: Supports trust, accountability, and institutional assurance.

Inputs: Governance records, application activity, decision outcomes, policy expectations.

Outputs: Oversight findings, compliance visibility, risk indicators, improvement recommendations.

Dependencies: Core lifecycle capabilities, reference governance.

Consumers: Ministry leadership, institutions, regulatory bodies, committees.

Success Measures: Oversight information is reliable, timely, and actionable.

Maturity: Initial

Priority: Critical

### BCM-05.01 Compliance Oversight

Capability ID: BCM-05.01

Capability Name: Compliance Oversight

Business Description: Monitors alignment between governance activity and approved expectations.

Business Owner: Research Governance Authority

Business Value: Reduces governance risk and supports regulatory confidence.

Inputs: Governance activity, compliance expectations, records.

Outputs: Compliance observations, exceptions, follow-up actions.

Dependencies: Policy Alignment, Audit Readiness.

Consumers: Governance authorities, institutions, regulatory bodies.

Success Measures: Compliance concerns are visible and assigned for follow-up.

Maturity: Initial

Priority: Critical

### BCM-05.02 Audit Readiness

Capability ID: BCM-05.02

Capability Name: Audit Readiness

Business Description: Ensures governance evidence can support authorized audit and review.

Business Owner: Institution Administration

Business Value: Preserves institutional accountability and confidence.

Inputs: Governance records, decision records, evidence records, approval records.

Outputs: Audit evidence package, record retrieval outcome, audit response.

Dependencies: Governance Record stewardship, Closure and Archival Governance.

Consumers: Auditors, oversight authorities, institution leadership.

Success Measures: Required records are complete, retrievable, and understandable.

Maturity: Initial

Priority: Critical

### BCM-05.03 Governance Risk Monitoring

Capability ID: BCM-05.03

Capability Name: Governance Risk Monitoring

Business Description: Identifies and monitors business risks in research ethics governance activity.

Business Owner: Research Governance Authority

Business Value: Enables early intervention and continuous improvement.

Inputs: Delays, exceptions, overdue actions, review trends, compliance concerns.

Outputs: Risk indicators, escalation items, mitigation recommendations.

Dependencies: Analytics and Reporting, Compliance Oversight.

Consumers: Ministry leadership, institution leadership, governance officers.

Success Measures: Material governance risks are identified and acted upon.

Maturity: Initial

Priority: High

### BCM-05.04 Policy Alignment

Capability ID: BCM-05.04

Capability Name: Policy Alignment

Business Description: Aligns business practices with approved research ethics policies and governance expectations.

Business Owner: Research Governance Authority

Business Value: Ensures consistent interpretation of ethics governance requirements.

Inputs: Policies, guidance, governance decisions, compliance findings.

Outputs: Policy interpretation, alignment findings, change recommendations.

Dependencies: Reference and Knowledge Management.

Consumers: Committees, administrators, researchers, oversight authorities.

Success Measures: Policy expectations are consistently reflected in governance practice.

Maturity: Initial

Priority: High

### BCM-06 Institutional Administration

Capability ID: BCM-06

Capability Name: Institutional Administration

Business Description: Coordinates institutional readiness, responsibilities, committees, and workload for ethics governance operations.

Business Owner: Institution Administration

Business Value: Enables institutions to participate effectively in research ethics governance.

Inputs: Institutional policies, user responsibilities, committee structure, workload information.

Outputs: Administrative readiness, role assignments, committee setup, workload visibility.

Dependencies: Governance model, reference guidance, core lifecycle capabilities.

Consumers: Administrators, committees, researchers, leadership.

Success Measures: Institutional responsibilities are clear and operational coordination is effective.

Maturity: Defined

Priority: High

### BCM-06.01 Institution Configuration Stewardship

Capability ID: BCM-06.01

Capability Name: Institution Configuration Stewardship

Business Description: Maintains business-level institutional participation settings, responsibilities, and governance preferences.

Business Owner: Institution Administration

Business Value: Supports consistent local adoption.

Inputs: Institution profile, governance responsibilities, approved local rules.

Outputs: Institution readiness record, local governance configuration record.

Dependencies: Governance oversight, policy alignment.

Consumers: Administrators, committees, leadership.

Success Measures: Institutional settings remain current and aligned with governance expectations.

Maturity: Initial

Priority: High

### BCM-06.02 Role and Responsibility Administration

Capability ID: BCM-06.02

Capability Name: Role and Responsibility Administration

Business Description: Maintains business responsibility assignments for stakeholders participating in governance.

Business Owner: Institution Administration

Business Value: Clarifies accountability and authorized participation.

Inputs: Stakeholder roles, committee membership, administrative responsibilities.

Outputs: Responsibility assignments, role records, accountability visibility.

Dependencies: Institutional governance model, committee administration.

Consumers: Administrators, committees, oversight authorities.

Success Measures: Responsibility assignments are current and unambiguous.

Maturity: Defined

Priority: High

### BCM-06.03 Committee Administration

Capability ID: BCM-06.03

Capability Name: Committee Administration

Business Description: Coordinates committee membership, readiness, workload, and governance support.

Business Owner: Institution Administration

Business Value: Enables committee review activity to operate predictably.

Inputs: Committee membership, meeting needs, review workload, governance schedule.

Outputs: Committee readiness, membership records, meeting support information.

Dependencies: Role and Responsibility Administration, Workload Coordination.

Consumers: Committee chairs, reviewers, administrators.

Success Measures: Committees are ready to perform authorized responsibilities.

Maturity: Initial

Priority: High

### BCM-06.04 Workload Coordination

Capability ID: BCM-06.04

Capability Name: Workload Coordination

Business Description: Coordinates visible work across applications, reviews, conditions, and committee actions.

Business Owner: Institution Administration

Business Value: Reduces delay and supports balanced governance operations.

Inputs: Application status, review assignments, condition status, committee schedule.

Outputs: Workload view, prioritization input, overdue action visibility.

Dependencies: Core lifecycle capabilities, reporting capabilities.

Consumers: Administrators, committee chairs, leadership.

Success Measures: Workload risks are visible and actionable.

Maturity: Initial

Priority: High

### BCM-07 Stakeholder Communication and Engagement

Capability ID: BCM-07

Capability Name: Stakeholder Communication and Engagement

Business Description: Manages business communications, notifications, requests, and communication records among authorized stakeholders.

Business Owner: Institution Administration

Business Value: Improves clarity, responsiveness, and traceability of stakeholder interactions.

Inputs: Business events, requests, decisions, required actions.

Outputs: Notifications, requests, communication records, stakeholder responses.

Dependencies: Core lifecycle capabilities, role responsibility administration.

Consumers: Applicants, administrators, reviewers, committees, leadership.

Success Measures: Stakeholders receive clear, timely, and traceable communications.

Maturity: Defined

Priority: High

### BCM-07.01 Business Notification Management

Capability ID: BCM-07.01

Capability Name: Business Notification Management

Business Description: Provides business notices related to status, required action, review activity, and decision outcomes.

Business Owner: Institution Administration

Business Value: Reduces uncertainty and missed actions.

Inputs: Business events, recipient responsibilities, communication rules.

Outputs: Notifications, reminders, notice records.

Dependencies: Application Status Management, Decision Recording, Condition Management.

Consumers: Applicants, reviewers, administrators, committees.

Success Measures: Notifications are timely, relevant, and traceable.

Maturity: Defined

Priority: High

### BCM-07.02 Stakeholder Request Management

Capability ID: BCM-07.02

Capability Name: Stakeholder Request Management

Business Description: Manages business requests for information, clarification, action, or follow-up.

Business Owner: Institution Administration

Business Value: Provides a controlled path for stakeholder action and response.

Inputs: Clarification needs, condition requests, administrative requests.

Outputs: Stakeholder request, response, request status.

Dependencies: Communication rules, condition management.

Consumers: Applicants, administrators, reviewers, committees.

Success Measures: Requests are clear, assigned, tracked, and resolved.

Maturity: Initial

Priority: High

### BCM-07.03 Communication Record Management

Capability ID: BCM-07.03

Capability Name: Communication Record Management

Business Description: Retains business communication records that support traceability and accountability.

Business Owner: Institution Administration

Business Value: Supports audit, oversight, and continuity.

Inputs: Notices, requests, responses, decision communications.

Outputs: Communication record, communication history.

Dependencies: Stakeholder Communication and Engagement, Audit Readiness.

Consumers: Administrators, committees, oversight authorities.

Success Measures: Communication records are complete and retrievable for authorized purposes.

Maturity: Initial

Priority: Medium

### BCM-08 Analytics and Reporting

Capability ID: BCM-08

Capability Name: Analytics and Reporting

Business Description: Provides authorized business insight into research ethics governance activity, performance, workload, compliance, and outcomes.

Business Owner: Research Governance Authority

Business Value: Enables evidence-based governance, oversight, and improvement.

Inputs: Governance activity, status information, decisions, conditions, workload indicators.

Outputs: Reports, dashboards in business terms, trends, oversight insights, performance indicators.

Dependencies: Core lifecycle capabilities, reference definitions, governance records.

Consumers: Ministry leadership, institution leadership, governance officers, committees.

Success Measures: Reports are reliable, consistent, and useful for decision making.

Maturity: Initial

Priority: High

### BCM-08.01 Operational Reporting

Capability ID: BCM-08.01

Capability Name: Operational Reporting

Business Description: Provides day-to-day visibility into applications, reviews, conditions, workload, and required actions.

Business Owner: Institution Administration

Business Value: Supports timely operational coordination.

Inputs: Application status, review status, condition status, workload information.

Outputs: Operational reports, action lists, workload summaries.

Dependencies: Application Status Management, Workload Coordination.

Consumers: Administrators, committee chairs, reviewers.

Success Measures: Operational reports support timely action and reduced delays.

Maturity: Initial

Priority: High

### BCM-08.02 Executive Reporting

Capability ID: BCM-08.02

Capability Name: Executive Reporting

Business Description: Provides leadership-level visibility into governance performance, volume, risk, and outcomes.

Business Owner: Ministry Leadership

Business Value: Supports strategic oversight and resource decisions.

Inputs: Aggregated activity, performance indicators, risk indicators.

Outputs: Executive summaries, trend views, strategic reporting.

Dependencies: Operational Reporting, Governance Risk Monitoring.

Consumers: Ministry leadership, institution leadership, governance authorities.

Success Measures: Leaders can understand governance performance and priority issues.

Maturity: Initial

Priority: High

### BCM-08.03 Oversight Analytics

Capability ID: BCM-08.03

Capability Name: Oversight Analytics

Business Description: Provides analysis of governance patterns, risks, compliance signals, and cross-institution trends.

Business Owner: Research Governance Authority

Business Value: Supports policy, improvement, and national governance maturity.

Inputs: Governance activity, risk indicators, compliance observations, institution information.

Outputs: Oversight insights, trend analysis, improvement recommendations.

Dependencies: Compliance Oversight, Executive Reporting, reference definitions.

Consumers: Research governance authorities, ministry leadership, regulatory stakeholders.

Success Measures: Analytics identify meaningful trends and support action.

Maturity: Initial

Priority: Medium

### BCM-08.04 Performance Monitoring

Capability ID: BCM-08.04

Capability Name: Performance Monitoring

Business Description: Monitors business performance of research ethics governance activities.

Business Owner: Research Governance Authority

Business Value: Enables improvement in timeliness, workload management, and governance quality.

Inputs: Milestones, durations, workload indicators, outcome counts.

Outputs: Performance indicators, improvement targets, monitoring summaries.

Dependencies: Operational Reporting, Application Status Management.

Consumers: Institution leadership, committees, governance authorities.

Success Measures: Performance information supports improvement without weakening governance quality.

Maturity: Initial

Priority: Medium

### BCM-09 Reference and Knowledge Management

Capability ID: BCM-09

Capability Name: Reference and Knowledge Management

Business Description: Maintains shared business language, policy references, templates, and guidance used across research ethics governance.

Business Owner: Documentation and Governance Stewardship

Business Value: Improves consistency, understanding, and adoption.

Inputs: Approved terminology, policy references, templates, guidance needs.

Outputs: Glossary entries, reference material, templates, guidance updates.

Dependencies: Product definition, domain model, governance standards.

Consumers: All stakeholder groups.

Success Measures: Shared terms and guidance are current, trusted, and used consistently.

Maturity: Defined

Priority: High

### BCM-09.01 Glossary Stewardship

Capability ID: BCM-09.01

Capability Name: Glossary Stewardship

Business Description: Maintains approved business terminology.

Business Owner: Domain Architecture

Business Value: Reduces ambiguity across stakeholders and documents.

Inputs: Domain terms, term change requests, approved definitions.

Outputs: Glossary entries, deprecated terms, terminology decisions.

Dependencies: Domain Model, documentation standard.

Consumers: Business analysts, architects, committees, administrators, AI agents.

Success Measures: Important terms are defined and used consistently.

Maturity: Initial

Priority: High

### BCM-09.02 Policy Reference Management

Capability ID: BCM-09.02

Capability Name: Policy Reference Management

Business Description: Maintains business references to approved governance policies and guidance.

Business Owner: Research Governance Authority

Business Value: Supports consistent interpretation of governance expectations.

Inputs: Policies, guidance, governance decisions, updates.

Outputs: Policy references, guidance links, reference updates.

Dependencies: Policy Alignment, governance ownership.

Consumers: Researchers, administrators, committees, reviewers.

Success Measures: Policy references are current and accessible to authorized stakeholders.

Maturity: Initial

Priority: High

### BCM-09.03 Template and Guidance Management

Capability ID: BCM-09.03

Capability Name: Template and Guidance Management

Business Description: Maintains reusable business templates and guidance for consistent governance activity.

Business Owner: Documentation and Governance Stewardship

Business Value: Improves consistency and reduces preparation burden.

Inputs: Template needs, guidance requirements, stakeholder feedback.

Outputs: Approved templates, guidance material, revision records.

Dependencies: Documentation standard, product definition, domain model.

Consumers: Researchers, administrators, committees, governance authorities.

Success Measures: Templates and guidance are current, understandable, and used appropriately.

Maturity: Initial

Priority: Medium

### BCM-10 Ecosystem Coordination and Future Expansion

Capability ID: BCM-10

Capability Name: Ecosystem Coordination and Future Expansion

Business Description: Coordinates national adoption, institutional onboarding, external stakeholder alignment, and future capability assessment.

Business Owner: Ministry Leadership

Business Value: Enables sustainable growth and strategic alignment.

Inputs: Adoption goals, institutional readiness, stakeholder needs, maturity findings.

Outputs: Adoption plan, onboarding approach, stakeholder coordination records, future capability candidates.

Dependencies: Governance Oversight and Compliance, Analytics and Reporting, Reference and Knowledge Management.

Consumers: Ministry leadership, institutions, governance authorities, regulatory stakeholders.

Success Measures: Expansion is planned, governed, and aligned with business value.

Maturity: Initial

Priority: Medium

### BCM-10.01 National Adoption Planning

Capability ID: BCM-10.01

Capability Name: National Adoption Planning

Business Description: Defines business planning for broader national rollout and governance alignment.

Business Owner: Ministry Leadership

Business Value: Supports coordinated adoption across institutions.

Inputs: Strategic objectives, readiness findings, stakeholder priorities.

Outputs: Adoption roadmap, rollout priorities, readiness expectations.

Dependencies: Product definition, governance oversight, executive reporting.

Consumers: Ministry leadership, institution leadership, governance authorities.

Success Measures: Adoption planning is phased, realistic, and governance-led.

Maturity: Initial

Priority: Medium

### BCM-10.02 Institutional Onboarding

Capability ID: BCM-10.02

Capability Name: Institutional Onboarding

Business Description: Coordinates business readiness for institutions joining the research ethics governance platform.

Business Owner: Institution Administration

Business Value: Improves adoption success and reduces operational confusion.

Inputs: Institution profile, readiness assessment, role assignments, training needs.

Outputs: Onboarding plan, readiness confirmation, responsibility map.

Dependencies: National Adoption Planning, Role and Responsibility Administration.

Consumers: Institutions, ministry leadership, governance authorities.

Success Measures: Institutions can participate with clear responsibilities and readiness.

Maturity: Initial

Priority: Medium

### BCM-10.03 External Stakeholder Coordination

Capability ID: BCM-10.03

Capability Name: External Stakeholder Coordination

Business Description: Coordinates business relationships with regulators, sponsors, partner institutions, and other authorized stakeholders.

Business Owner: Research Governance Authority

Business Value: Supports coherent governance across the research ecosystem.

Inputs: Stakeholder requirements, coordination needs, oversight expectations.

Outputs: Coordination records, stakeholder agreements, shared expectations.

Dependencies: Governance Oversight and Compliance, policy alignment.

Consumers: Regulatory bodies, institutions, ministry leadership.

Success Measures: External coordination supports governance clarity and avoids conflicting expectations.

Maturity: Initial

Priority: Medium

### BCM-10.04 Future Capability Assessment

Capability ID: BCM-10.04

Capability Name: Future Capability Assessment

Business Description: Evaluates candidate capabilities for future adoption based on business value, readiness, and governance need.

Business Owner: Enterprise Business Architecture

Business Value: Ensures expansion is deliberate and strategically aligned.

Inputs: Improvement ideas, maturity findings, stakeholder requests, risk observations.

Outputs: Candidate capability assessment, recommendation, roadmap input.

Dependencies: Analytics and Reporting, Continuous Improvement, stakeholder feedback.

Consumers: Product governance, ministry leadership, enterprise architecture.

Success Measures: Future capabilities are evaluated before adoption and linked to clear business value.

Maturity: Initial

Priority: Medium

### BCM-01.01.01 Research Information Capture

Capability ID: BCM-01.01.01

Capability Name: Research Information Capture

Business Description: Captures the business information needed to describe the proposed research activity for ethics consideration.

Business Owner: Principal Investigator

Business Value: Improves clarity and completeness of research description.

Inputs: Research purpose, methodology summary, participant considerations, governance declarations.

Outputs: Research information summary.

Dependencies: Application Preparation, domain terminology.

Consumers: Applicants, administrators, reviewers, committees.

Success Measures: Research information is complete enough to support review readiness.

Maturity: Initial

Priority: Critical

### BCM-01.01.02 Supporting Material Preparation

Capability ID: BCM-01.01.02

Capability Name: Supporting Material Preparation

Business Description: Prepares supporting materials required for ethics review.

Business Owner: Principal Investigator

Business Value: Reduces incomplete submissions and improves review quality.

Inputs: Research documents, participant materials, institutional guidance.

Outputs: Supporting material set.

Dependencies: Application Preparation, Reference and Knowledge Management.

Consumers: Applicants, administrators, reviewers, committees.

Success Measures: Supporting materials align with stated submission expectations.

Maturity: Initial

Priority: Critical

### BCM-01.03.01 Completeness Review

Capability ID: BCM-01.03.01

Capability Name: Completeness Review

Business Description: Determines whether submitted materials satisfy administrative completeness expectations.

Business Owner: Institution Administration

Business Value: Improves readiness before formal ethics review.

Inputs: Submitted application, completeness checklist, supporting materials.

Outputs: Completeness outcome.

Dependencies: Administrative Screening, Reference and Knowledge Management.

Consumers: Applicants, administrators, committees.

Success Measures: Completeness outcomes are consistent and timely.

Maturity: Defined

Priority: Critical

### BCM-01.03.02 Administrative Return for Correction

Capability ID: BCM-01.03.02

Capability Name: Administrative Return for Correction

Business Description: Returns incomplete or incorrect submissions to the responsible party for correction.

Business Owner: Institution Administration

Business Value: Prevents avoidable review delays and clarifies required action.

Inputs: Screening findings, submitted application, correction reason.

Outputs: Return notice, correction request, revised submission expectation.

Dependencies: Completeness Review, Stakeholder Communication and Engagement.

Consumers: Applicants, administrators.

Success Measures: Returned items are clear, actionable, and resolved efficiently.

Maturity: Initial

Priority: High

### BCM-02.01.01 Reviewer Eligibility Identification

Capability ID: BCM-02.01.01

Capability Name: Reviewer Eligibility Identification

Business Description: Identifies reviewers who are suitable for a review responsibility from a business perspective.

Business Owner: Research Ethics Committee

Business Value: Supports appropriate and credible review assignment.

Inputs: Reviewer role information, expertise indicators, availability, conflict considerations.

Outputs: Eligible reviewer list.

Dependencies: Role and Responsibility Administration, Committee Administration.

Consumers: Committee chairs, ethics administrators.

Success Measures: Reviewers selected for assignment are appropriate for the review need.

Maturity: Initial

Priority: Critical

### BCM-02.01.02 Review Work Allocation

Capability ID: BCM-02.01.02

Capability Name: Review Work Allocation

Business Description: Allocates review work to selected reviewers with expected responsibilities.

Business Owner: Research Ethics Committee

Business Value: Makes review accountability explicit and manageable.

Inputs: Eligible reviewer list, application information, workload visibility.

Outputs: Review work allocation, expected response timeframe.

Dependencies: Reviewer Eligibility Identification, Workload Coordination.

Consumers: Reviewers, administrators, committee chairs.

Success Measures: Review work is assigned clearly and balanced appropriately.

Maturity: Initial

Priority: Critical

### BCM-02.04.01 Decision Outcome Capture

Capability ID: BCM-02.04.01

Capability Name: Decision Outcome Capture

Business Description: Captures the formal outcome of committee authority.

Business Owner: Research Ethics Committee

Business Value: Preserves the authoritative result of committee decision making.

Inputs: Committee deliberation outcome, decision options, approval or rejection terms.

Outputs: Decision outcome record.

Dependencies: Committee Deliberation, Decision Recording.

Consumers: Applicants, administrators, oversight authorities.

Success Measures: Decision outcomes are clear, attributable, and complete.

Maturity: Defined

Priority: Critical

### BCM-02.04.02 Decision Rationale Capture

Capability ID: BCM-02.04.02

Capability Name: Decision Rationale Capture

Business Description: Captures the business rationale supporting a committee decision.

Business Owner: Research Ethics Committee

Business Value: Improves accountability, audit readiness, and stakeholder understanding.

Inputs: Deliberation notes, review findings, ethical considerations.

Outputs: Decision rationale record.

Dependencies: Review Assessment, Committee Deliberation, Decision Recording.

Consumers: Committees, applicants, oversight authorities.

Success Measures: Rationale is sufficient to understand why the decision was made.

Maturity: Initial

Priority: Critical

### BCM-03.03.01 Evidence Sufficiency Review

Capability ID: BCM-03.03.01

Capability Name: Evidence Sufficiency Review

Business Description: Reviews whether submitted evidence is sufficient to satisfy a stated requirement.

Business Owner: Research Ethics Governance

Business Value: Protects the integrity of condition resolution.

Inputs: Submitted evidence, condition terms, review expectation.

Outputs: Sufficiency finding.

Dependencies: Evidence Submission, Evidence Assessment.

Consumers: Committees, reviewers, administrators, applicants.

Success Measures: Sufficiency findings are justified and traceable.

Maturity: Initial

Priority: Critical

### BCM-03.03.02 Evidence Rejection Management

Capability ID: BCM-03.03.02

Capability Name: Evidence Rejection Management

Business Description: Manages business handling when submitted evidence does not satisfy a requirement.

Business Owner: Research Ethics Governance

Business Value: Clarifies unresolved requirements and next actions.

Inputs: Insufficient evidence finding, condition terms, reviewer feedback.

Outputs: Rejection reason, further action request, updated condition status.

Dependencies: Evidence Sufficiency Review, Stakeholder Request Management.

Consumers: Applicants, administrators, committees.

Success Measures: Rejections are clear, justified, and actionable.

Maturity: Initial

Priority: High

### BCM-04.03.01 Amendment Request Intake

Capability ID: BCM-04.03.01

Capability Name: Amendment Request Intake

Business Description: Receives proposed changes to approved or active research governance arrangements.

Business Owner: Research Governance Authority

Business Value: Creates a controlled path for governing research changes.

Inputs: Amendment request, current approval information, change description.

Outputs: Received amendment request, initial amendment status.

Dependencies: Approval Management, Stakeholder Communication and Engagement.

Consumers: Principal investigators, administrators, committees.

Success Measures: Amendment requests are complete, attributable, and ready for assessment.

Maturity: Initial

Priority: High

### BCM-04.03.02 Amendment Review Coordination

Capability ID: BCM-04.03.02

Capability Name: Amendment Review Coordination

Business Description: Coordinates business review of proposed amendments.

Business Owner: Research Governance Authority

Business Value: Ensures changes to approved research remain ethically governed.

Inputs: Amendment request, current approval terms, review expectations.

Outputs: Amendment review outcome, decision recommendation, updated governance action.

Dependencies: Amendment Request Intake, Ethics Review and Decision Management.

Consumers: Committees, reviewers, principal investigators, administrators.

Success Measures: Amendment reviews are timely, appropriate, and traceable.

Maturity: Initial

Priority: High

### BCM-05.02.01 Governance Record Retrieval

Capability ID: BCM-05.02.01

Capability Name: Governance Record Retrieval

Business Description: Retrieves retained governance records for authorized review or audit.

Business Owner: Institution Administration

Business Value: Supports audit readiness and institutional accountability.

Inputs: Authorized record request, governance identifier, retrieval purpose.

Outputs: Retrieved governance records, retrieval outcome.

Dependencies: Audit Readiness, Closure and Archival Governance.

Consumers: Auditors, oversight authorities, institution leadership.

Success Measures: Authorized records are retrievable, complete, and understandable.

Maturity: Initial

Priority: Critical

### BCM-05.02.02 Audit Evidence Packaging

Capability ID: BCM-05.02.02

Capability Name: Audit Evidence Packaging

Business Description: Organizes governance records into an evidence set for authorized audit or oversight use.

Business Owner: Institution Administration

Business Value: Improves audit response quality and reduces preparation burden.

Inputs: Retrieved governance records, audit scope, evidence expectations.

Outputs: Audit evidence package, evidence summary.

Dependencies: Governance Record Retrieval, Compliance Oversight.

Consumers: Auditors, regulatory stakeholders, governance authorities.

Success Measures: Evidence packages satisfy authorized audit scope and are traceable.

Maturity: Initial

Priority: High

### BCM-08.03.01 Cross-Institution Trend Analysis

Capability ID: BCM-08.03.01

Capability Name: Cross-Institution Trend Analysis

Business Description: Analyzes governance activity patterns across participating institutions.

Business Owner: Ministry Leadership

Business Value: Supports national oversight, policy planning, and institutional learning.

Inputs: Institution-level reporting, governance activity summaries, common definitions.

Outputs: Cross-institution trends, comparison insights, improvement themes.

Dependencies: Executive Reporting, Oversight Analytics, Reference and Knowledge Management.

Consumers: Ministry leadership, governance authorities, institution leadership.

Success Measures: Trends are meaningful, comparable, and useful for strategic decisions.

Maturity: Initial

Priority: Medium

### BCM-08.03.02 Governance Risk Insight

Capability ID: BCM-08.03.02

Capability Name: Governance Risk Insight

Business Description: Identifies governance risk themes from activity, performance, and compliance signals.

Business Owner: Research Governance Authority

Business Value: Enables early intervention and continuous governance improvement.

Inputs: Risk indicators, compliance observations, performance trends.

Outputs: Risk insights, escalation recommendations, improvement opportunities.

Dependencies: Governance Risk Monitoring, Oversight Analytics.

Consumers: Governance authorities, ministry leadership, institution leadership.

Success Measures: Risk insights lead to informed follow-up or mitigation.

Maturity: Initial

Priority: Medium

## 28 Appendix B - Capability Heat Map

| Capability | Priority | Maturity | Heat |
| --- | --- | --- | --- |
| Research Ethics Application Management | Critical | Defined | High attention |
| Ethics Review and Decision Management | Critical | Defined | High attention |
| Conditions and Evidence Management | Critical | Defined | High attention |
| Approval and Research Lifecycle Governance | Critical | Defined | High attention |
| Governance Oversight and Compliance | Critical | Initial | High attention |
| Institutional Administration | High | Defined | Medium attention |
| Stakeholder Communication and Engagement | High | Defined | Medium attention |
| Analytics and Reporting | High | Initial | High attention |
| Reference and Knowledge Management | High | Defined | Medium attention |
| Ecosystem Coordination and Future Expansion | Medium | Initial | Watch |

## 29 Appendix C - Capability Hierarchy

- BCM-01 Research Ethics Application Management
- BCM-01.01 Application Preparation
- BCM-01.01.01 Research Information Capture
- BCM-01.01.02 Supporting Material Preparation
- BCM-01.02 Application Submission
- BCM-01.03 Administrative Screening
- BCM-01.03.01 Completeness Review
- BCM-01.03.02 Administrative Return for Correction
- BCM-01.04 Application Status Management
- BCM-02 Ethics Review and Decision Management
- BCM-02.01 Reviewer Assignment
- BCM-02.01.01 Reviewer Eligibility Identification
- BCM-02.01.02 Review Work Allocation
- BCM-02.02 Review Assessment
- BCM-02.03 Committee Deliberation
- BCM-02.04 Decision Recording
- BCM-02.04.01 Decision Outcome Capture
- BCM-02.04.02 Decision Rationale Capture
- BCM-03 Conditions and Evidence Management
- BCM-03.01 Condition Issuance
- BCM-03.02 Evidence Submission
- BCM-03.03 Evidence Assessment
- BCM-03.03.01 Evidence Sufficiency Review
- BCM-03.03.02 Evidence Rejection Management
- BCM-03.04 Condition Resolution
- BCM-04 Approval and Research Lifecycle Governance
- BCM-04.01 Approval Management
- BCM-04.02 Certificate Management
- BCM-04.03 Amendment Governance
- BCM-04.03.01 Amendment Request Intake
- BCM-04.03.02 Amendment Review Coordination
- BCM-04.04 Closure and Archival Governance
- BCM-05 Governance Oversight and Compliance
- BCM-05.01 Compliance Oversight
- BCM-05.02 Audit Readiness
- BCM-05.02.01 Governance Record Retrieval
- BCM-05.02.02 Audit Evidence Packaging
- BCM-05.03 Governance Risk Monitoring
- BCM-05.04 Policy Alignment
- BCM-06 Institutional Administration
- BCM-06.01 Institution Configuration Stewardship
- BCM-06.02 Role and Responsibility Administration
- BCM-06.03 Committee Administration
- BCM-06.04 Workload Coordination
- BCM-07 Stakeholder Communication and Engagement
- BCM-07.01 Business Notification Management
- BCM-07.02 Stakeholder Request Management
- BCM-07.03 Communication Record Management
- BCM-08 Analytics and Reporting
- BCM-08.01 Operational Reporting
- BCM-08.02 Executive Reporting
- BCM-08.03 Oversight Analytics
- BCM-08.03.01 Cross-Institution Trend Analysis
- BCM-08.03.02 Governance Risk Insight
- BCM-08.04 Performance Monitoring
- BCM-09 Reference and Knowledge Management
- BCM-09.01 Glossary Stewardship
- BCM-09.02 Policy Reference Management
- BCM-09.03 Template and Guidance Management
- BCM-10 Ecosystem Coordination and Future Expansion
- BCM-10.01 National Adoption Planning
- BCM-10.02 Institutional Onboarding
- BCM-10.03 External Stakeholder Coordination
- BCM-10.04 Future Capability Assessment

## 30 Appendix D - Future Capability Candidates

Future capability candidates SHALL be assessed before inclusion in the approved capability catalog.

Potential future candidates include accreditation readiness management.

Potential future candidates include research ethics training governance.

Potential future candidates include national benchmarking.

Potential future candidates include policy impact analysis.

Potential future candidates include research site readiness assessment.

Potential future candidates include multi-institution study coordination.

Potential future candidates include sponsor coordination.

Potential future candidates include international collaboration support.

Potential future candidates include advanced governance maturity assessment.

Potential future candidates include ethics committee capacity planning.
