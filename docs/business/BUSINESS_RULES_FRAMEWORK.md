# Business Rules Framework

## Document Metadata

Document ID: SPEC-0008

Title: Business Rules Framework

Status: Approved

Version: 1.0

Owner: Business Rules Architecture

Approvers: Product Governance, Research Governance Authority, Enterprise Architecture

Reviewers: Domain Architecture, Enterprise Business Architecture, Enterprise Business Process Architecture, Quality Engineering, Security Governance

Classification: Standard

Audience: Business Rules Architects, Business Analysts, Enterprise Architects, Research Ethics Governance, Product Owners, QA Engineers, Security Engineers, AI Agents, and Future Contributors

Created: 2026-07-31

Last Updated: 2026-07-31

Next Review: To be scheduled by Business Rules Architecture

Related Documents: `docs/product/PRODUCT_DEFINITION.md`, `docs/domain/DOMAIN_MODEL.md`, `docs/business/BUSINESS_CAPABILITY_MODEL.md`, `docs/business/BUSINESS_PROCESS_ARCHITECTURE.md`, `docs/governance/ENGINEERING_MANIFEST.md`, `docs/governance/ENGINEERING_DOCUMENTATION_STANDARD.md`

Depends On: `docs/product/PRODUCT_DEFINITION.md`, `docs/domain/DOMAIN_MODEL.md`, `docs/business/BUSINESS_CAPABILITY_MODEL.md`, `docs/business/BUSINESS_PROCESS_ARCHITECTURE.md`

References: RFC 2119

Keywords: business rules, rule governance, rule catalog, rule lifecycle, traceability, validation, testing

Confidentiality: Internal

## Normative Language

The key words MUST, MUST NOT, SHALL, SHALL NOT, SHOULD, SHOULD NOT, and MAY in this document are to be interpreted as described by RFC 2119 when used as normative terms.

## 1 Executive Summary

This Business Rules Framework defines how business rules for ERM-System are identified, classified, governed, referenced, versioned, approved, traced, implemented, tested, and maintained.

ERM-System is an Enterprise Research Ethics Management Platform.

Business rules are central to the integrity of research ethics governance because they define obligations, constraints, decisions, validations, approvals, timing expectations, exceptions, retention expectations, and controlled outcomes.

This document does not define the actual business rules.

This document defines the framework that future Business Rules Catalogs SHALL follow.

The framework is designed to manage a large rule estate, including more than 2,000 business rules.

Future rule catalogs SHALL use the rule classification, numbering, metadata, ownership, lifecycle, approval, traceability, validation, testing, and quality gate rules defined here.

The framework aligns with the Product Definition, Domain Model, Business Capability Model, and Business Process Architecture.

## 2 Purpose

The purpose of this framework is to provide a controlled operating model for business rules.

The framework SHALL ensure that rules are consistently named, numbered, classified, owned, approved, traced, tested, and maintained.

The framework SHALL support future rule catalogs without embedding the actual rules in this document.

The framework SHALL help business owners, analysts, architects, reviewers, testers, and future contributors understand how rules move from business source to governed artifact.

The framework SHOULD reduce ambiguity about whether a statement is a business rule, guidance, process description, policy excerpt, validation expectation, or implementation behavior.

## 3 Scope

This framework governs business rule documentation for ERM-System.

It covers rule identification.

It covers rule classification.

It covers rule numbering.

It covers rule metadata.

It covers rule ownership.

It covers rule authority.

It covers rule source management.

It covers rule traceability.

It covers rule dependencies.

It covers rule versioning.

It covers rule approval.

It covers rule change.

It covers rule deprecation.

It covers rule validation.

It covers rule testing.

It covers rule review.

It covers conflict resolution.

It covers repository structure.

It covers templates.

It covers quality gates.

This framework does not define actual business rules.

This framework does not define software implementation.

This framework does not define database design.

This framework does not define API behavior.

This framework does not define user interface behavior.

## 4 Business Rule Philosophy

A business rule is a business-owned statement that constrains, guides, determines, validates, permits, prohibits, calculates, classifies, routes, retains, reports, or audits business behavior.

A business rule SHALL be expressed in business language.

A business rule SHALL be traceable to a business source or approved business authority.

A business rule SHOULD be testable or verifiable.

A business rule SHOULD be atomic enough to govern one clear business expectation.

A business rule SHALL have an owner.

A business rule SHALL have a status.

A business rule SHALL have a version.

A business rule SHALL NOT be hidden inside narrative text without rule metadata when it is intended to govern behavior.

Business rules SHOULD remain independent of implementation mechanisms.

Implementation artifacts MAY realize business rules, but implementation artifacts SHALL NOT become the authoritative source of business meaning.

## 5 Rule Lifecycle

Rules SHALL move through a controlled lifecycle.

The standard lifecycle is Identified, Draft, Review, Approved, Implemented, Verified, Deprecated, Superseded, and Archived.

Identified means a candidate rule has been recognized but not fully specified.

Draft means the rule has been documented but is not ready for approval.

Review means the rule is ready for subject matter, architecture, quality, security, or governance review as applicable.

Approved means the rule has been accepted by the proper business authority.

Implemented means the rule has been realized in the appropriate business or system environment.

Verified means the rule has evidence that it behaves as intended.

Deprecated means the rule remains visible but SHOULD NOT be used for new work.

Superseded means the rule has been replaced by another rule.

Archived means the rule is retained for historical reference and SHALL NOT govern active behavior.

Rules SHALL NOT move to Approved without an identified owner and authority.

Rules SHALL NOT move to Verified without an identified verification method.

## 6 Rule Classification

Every rule SHALL have one primary classification.

Rules MAY have secondary classifications where useful for search and analysis.

### 6.1 Eligibility Rules

Eligibility Rules determine whether a person, institution, research activity, committee, reviewer, application, or other business subject qualifies for an action, state, responsibility, or pathway.

### 6.2 Validation Rules

Validation Rules determine whether submitted information, evidence, records, or declarations satisfy business completeness, format, consistency, or readiness expectations.

### 6.3 Workflow Rules

Workflow Rules govern allowed business progression, routing, sequencing, state movement, handoffs, and lifecycle behavior.

### 6.4 Decision Rules

Decision Rules determine business outcomes from approved conditions, criteria, facts, or governance judgments.

### 6.5 Approval Rules

Approval Rules govern when approval may be granted, withheld, conditioned, revised, withdrawn, closed, or represented.

### 6.6 Committee Rules

Committee Rules govern committee authority, committee responsibilities, review participation, deliberation expectations, and committee decision governance.

### 6.7 Compliance Rules

Compliance Rules govern alignment with approved governance expectations, institutional obligations, ethics requirements, and oversight expectations.

### 6.8 Regulatory Rules

Regulatory Rules derive from applicable regulatory or statutory authority and SHALL identify the source authority.

### 6.9 Security Rules

Security Rules govern confidentiality, access responsibility, separation of duties, sensitive information handling, and authorized business purpose.

### 6.10 Notification Rules

Notification Rules govern when business notices, reminders, requests, acknowledgements, or communications are required.

### 6.11 Scheduling Rules

Scheduling Rules govern dates, deadlines, due periods, review windows, meeting timing, reminders, escalation timing, or recurrence.

### 6.12 Reporting Rules

Reporting Rules govern business definitions, inclusion criteria, aggregation expectations, reporting periods, and reporting audiences.

### 6.13 Retention Rules

Retention Rules govern record retention, archival expectations, disposal eligibility, and historical record availability.

### 6.14 Audit Rules

Audit Rules govern evidence preservation, audit readiness, audit access, audit scope, audit records, and audit trail expectations.

### 6.15 Reference Rules

Reference Rules govern controlled terms, standard lists, classifications, templates, guidance references, and business reference data.

### 6.16 Calculation Rules

Calculation Rules govern computed business values, scoring, counts, durations, risk measures, maturity measures, or thresholds.

### 6.17 Configuration Rules

Configuration Rules govern business-level settings, institutional options, policy selections, responsibility assignments, or controlled parameterization.

### 6.18 Integration Rules

Integration Rules govern business information exchange, cross-institution coordination, external stakeholder expectations, and authorized data sharing at a business level.

### 6.19 System Constraints

System Constraints define business constraints that a future system must respect, without prescribing the implementation.

### 6.20 National Policy Rules

National Policy Rules derive from national governance direction, ministry authority, national research ethics policy, or other nationally authorized sources.

## 7 Rule Identification Standard

A rule SHALL be identified when a business statement uses mandatory language, constrains behavior, determines an outcome, validates information, controls a state transition, defines an exception, establishes an approval condition, or requires evidence.

Candidate rules SHOULD be captured during product analysis, domain modeling, process modeling, policy review, compliance analysis, testing analysis, operational review, and stakeholder workshops.

Rule identification SHALL distinguish rules from goals, principles, process descriptions, user preferences, design choices, implementation constraints, and examples.

A candidate rule SHALL NOT become an approved rule until it has rule metadata, ownership, source, classification, traceability, and approval.

Duplicate candidate rules SHOULD be consolidated before approval.

Ambiguous candidate rules SHOULD be clarified with the business owner before approval.

## 8 Rule Numbering Standard

Every approved or candidate rule SHALL have a unique rule identifier.

Rule identifiers SHALL use the format `BR-NNNNNN`.

The numeric portion SHALL contain six digits.

The first rule identifier SHALL be `BR-000001`.

Identifiers SHALL be assigned sequentially by the rule repository owner.

Identifiers SHALL NOT be reused.

Withdrawn identifiers SHOULD remain reserved.

Deprecated, superseded, and archived identifiers SHALL remain traceable.

Rule identifiers SHALL remain stable across rule title changes.

Sub-rules SHOULD be avoided unless necessary.

If sub-rules are required, the approved catalog MAY use a suffix such as `BR-000001-A`, but the parent rule SHALL remain independently meaningful.

## 9 Rule Metadata

Every future business rule SHALL include the metadata defined in this section.

Rule ID SHALL identify the rule uniquely.

Rule Name SHALL provide a concise business name.

Description SHALL state the rule in clear business language.

Business Rationale SHALL explain why the rule exists.

Business Source SHALL identify the authority, policy, document, workshop, decision, or approved business source.

Business Owner SHALL identify who owns the rule meaning.

Applies To SHALL identify the business subject, actor, entity, process, capability, or context affected.

Preconditions SHALL identify what must be true before the rule is evaluated.

Trigger SHALL identify the event or situation that causes rule evaluation.

Condition SHALL identify the business condition being evaluated.

Outcome SHALL identify the required business result when the condition applies.

Exceptions SHALL identify approved exceptions or state that no exceptions are approved.

Priority SHALL identify sequencing or business importance.

Severity SHALL identify impact if the rule is violated.

Version SHALL identify the rule version.

Status SHALL identify the lifecycle state.

Traceability SHALL connect the rule to source, process, capability, domain entity, test, and implementation reference where applicable.

Related Processes SHALL identify affected business processes.

Related Capabilities SHALL identify affected business capabilities.

Related Domain Entities SHALL identify affected domain entities or terms.

Verification Method SHALL identify how compliance with the rule is verified.

## 10 Rule Ownership

Every rule SHALL have one accountable business owner.

The business owner SHALL be accountable for rule meaning, business rationale, source validity, approval readiness, and change decisions.

A rule MAY have supporting reviewers.

A rule MAY have operational stewards.

A rule MAY have implementation owners, but implementation owners SHALL NOT replace business ownership.

Rules that cross multiple business owners SHALL identify a primary owner and consulted owners.

Rules without an accountable owner SHALL NOT be approved.

## 11 Rule Authority

Rule authority defines who may approve, change, waive, or retire a rule.

Authority SHALL be appropriate to the rule classification and business impact.

Regulatory Rules SHALL identify regulatory authority.

National Policy Rules SHALL identify national policy authority.

Committee Rules SHALL identify committee governance authority.

Security Rules SHALL involve security governance authority.

Retention and Audit Rules SHALL involve records, audit, or governance authority as applicable.

Rules SHALL NOT be approved by a party that lacks authority over the business meaning.

## 12 Rule Source

Every rule SHALL have a documented source.

Rule sources MAY include approved policy, regulation, product specification, domain model, business process architecture, committee charter, governance decision, compliance requirement, stakeholder workshop decision, or approved business exception.

Rule source SHALL be specific enough for future reviewers to understand origin and authority.

When a source is external, the rule SHALL cite the source authority and reference date where practical.

When a source is internal, the rule SHOULD reference the document path, decision record, or governance record.

Rules based on undocumented assumptions SHALL remain Draft until validated.

## 13 Rule Traceability

Rules SHALL be traceable to business context and downstream realization.

At minimum, each rule SHOULD trace to one or more business processes, capabilities, domain entities, and verification methods.

High-risk rules SHALL trace to source authority, approval evidence, implementation reference where applicable, test evidence, and operational control where applicable.

Traceability SHALL be maintained when rules change.

Broken traceability SHALL be treated as rule governance debt.

Future Business Rules Catalogs SHOULD support filtering by process, capability, domain entity, owner, classification, severity, and status.

## 14 Rule Dependencies

Rule dependencies SHALL be documented when one rule relies on another rule, conflicts with another rule, overrides another rule, or is evaluated before another rule.

Dependency types MAY include prerequisite, override, exception, conflict, sequence, calculation input, shared source, shared outcome, and supersession.

Rule dependencies SHOULD be reviewed before approval.

High-risk dependency chains SHOULD be tested and reviewed as a group.

Circular dependencies SHALL be resolved before approval unless explicitly accepted by a governance authority with documented rationale.

## 15 Rule Versioning

Every rule SHALL have a version.

Rule versions SHOULD use major and minor versioning.

Major version changes SHOULD indicate material change to meaning, outcome, authority, scope, exception, or severity.

Minor version changes SHOULD indicate clarification or compatible refinement.

Editorial corrections MAY be recorded without changing rule version when meaning is unchanged and governance permits.

Version history SHALL preserve prior approved meaning.

Approved rules SHALL NOT be silently changed.

Rule catalogs SHALL indicate the current approved version of each rule.

## 16 Rule Approval Process

Rule approval SHALL confirm that a rule is clear, owned, sourced, classified, traceable, verifiable, and authorized.

The approval process SHALL include business owner review.

The approval process SHOULD include domain review when terminology or entities are affected.

The approval process SHOULD include process review when process behavior is affected.

The approval process SHOULD include quality review when verification expectations are affected.

The approval process SHALL include security review for Security Rules and confidentiality-sensitive rules.

The approval process SHALL include regulatory or policy authority review for Regulatory Rules and National Policy Rules.

Approval SHALL be explicit.

Approval SHALL NOT be implied by silence.

Rules SHALL NOT move to Approved status with unresolved mandatory metadata.

## 17 Rule Change Process

Rule changes SHALL be controlled.

A change request SHOULD identify the rule ID, current version, proposed change, business rationale, source, impact, dependencies, verification impact, and approval authority.

Material rule changes SHALL update version.

Rule changes SHALL preserve traceability.

Rule changes SHOULD identify affected processes, capabilities, domain entities, tests, documentation, and implementation references where applicable.

Emergency changes MAY use an expedited process.

Emergency changes SHALL be reviewed afterward.

Rule changes SHALL NOT be bundled with unrelated changes when avoidable.

## 18 Rule Deprecation

A rule MAY be deprecated when it remains visible but should not govern new work.

Deprecated rules SHALL retain their identifier.

Deprecated rules SHALL identify the reason for deprecation.

Deprecated rules SHOULD identify replacement rules where applicable.

Deprecated rules SHALL remain traceable to prior usage.

Deprecated rules SHALL NOT be treated as active rules unless an approved exception exists.

Superseded rules SHALL identify the superseding rule.

Archived rules SHALL be retained for historical reference according to retention expectations.

## 19 Rule Validation

Rule validation confirms that the rule is meaningful, correct, complete, and business-owned before implementation or testing.

Validation SHALL include review of rule clarity.

Validation SHALL include review of business source.

Validation SHALL include review of ownership.

Validation SHALL include review of classification.

Validation SHALL include review of traceability.

Validation SHALL include review of exceptions.

Validation SHALL include review of dependencies.

Validation SHALL include review of verification method.

Validation SHOULD include scenario review for rules that affect decisions, approvals, workflow, compliance, security, audit, or retention.

Rules that cannot be validated SHOULD remain Draft or Review until resolved.

## 20 Rule Testing

Rule testing verifies that a rule behaves as intended wherever it is applied.

Every approved rule SHOULD have at least one verification method.

High-risk rules SHALL have defined test evidence expectations.

Testing methods MAY include business scenario review, acceptance criteria, sample case validation, decision table review, process walkthrough, audit evidence review, reporting reconciliation, security review, or operational control check.

Testing SHALL distinguish business rule correctness from implementation correctness.

Implementation tests MAY be used as evidence, but the business rule itself SHALL remain business-owned.

Rule tests SHOULD include normal cases, exception cases, boundary cases, and conflict cases where relevant.

## 21 Rule Review

Rules SHALL be reviewed before approval.

Rules SHOULD be reviewed periodically after approval.

Review frequency SHOULD depend on classification, severity, source volatility, regulatory importance, and process risk.

Rules affected by policy change SHALL be reviewed.

Rules affected by domain terminology change SHOULD be reviewed.

Rules affected by process change SHOULD be reviewed.

Rules with repeated exceptions, defects, disputes, or audit findings SHALL be reviewed.

Review outcomes SHOULD be recorded in the rule catalog or governance record.

## 22 Rule Conflict Resolution

Rule conflicts SHALL be identified, recorded, and resolved.

Conflicts MAY occur when two rules produce incompatible outcomes, apply different authority to the same condition, use inconsistent terminology, define conflicting exceptions, or depend on incompatible sources.

Conflict resolution SHALL consider authority, source, effective date, specificity, jurisdiction, risk, and approved governance decisions.

Higher-authority rules SHALL take precedence unless a formal exception exists.

Regulatory and National Policy Rules SHALL be escalated to the appropriate authority when conflict is suspected.

Temporary conflict resolution MAY be documented as an exception.

Permanent conflict resolution SHOULD update, supersede, or deprecate affected rules.

## 23 Rule Governance

Rule governance SHALL define accountability for the rule estate.

Business Rules Architecture SHALL own the framework and rule modeling standards.

Business owners SHALL own rule meaning.

Domain Architecture SHALL review terminology alignment.

Enterprise Business Process Architecture SHALL review process alignment.

Quality Engineering SHALL review verification expectations.

Security Governance SHALL review security-sensitive rules.

Product Governance SHALL review product alignment.

Research Governance Authority SHALL review research ethics governance authority and policy alignment.

Rule governance SHALL maintain consistency across rule catalogs.

Rule governance SHALL maintain visibility of rule debt, conflicts, deprecated rules, and unverified rules.

## 24 Rule Repository Structure

Business rules SHALL be stored in governed documentation or catalog structures approved by Documentation Engineering and Business Rules Architecture.

The recommended documentation location for rule frameworks is `docs/business/`.

Future rule catalogs SHOULD be located under a controlled business rules folder or equivalent governed repository structure.

Rule repository structure SHOULD support large-scale rule management.

The structure SHOULD support filtering by ID, classification, owner, status, process, capability, domain entity, version, severity, and source.

The structure SHOULD support traceability to verification evidence and implementation references where applicable.

The structure SHALL preserve historical rule identifiers.

The structure SHALL NOT depend on undocumented naming conventions.

## 25 Rule Templates

Every future business rule SHALL use the standard rule template unless an approved specialized template exists.

The standard template SHALL include all required metadata fields.

The template SHALL distinguish the rule statement from rationale, source, exceptions, traceability, and verification.

Templates SHOULD support both human readability and future catalog automation.

Templates SHALL NOT embed actual business rules inside this framework.

Appendix A defines the standard rule template.

## 26 Rule Quality Gates

Quality gates SHALL be applied before a rule is approved.

Gate BR-QG-001 SHALL verify rule identifier format.

Gate BR-QG-002 SHALL verify mandatory metadata completeness.

Gate BR-QG-003 SHALL verify classification.

Gate BR-QG-004 SHALL verify business owner.

Gate BR-QG-005 SHALL verify business source.

Gate BR-QG-006 SHALL verify business-language clarity.

Gate BR-QG-007 SHALL verify traceability to process, capability, and domain entity where applicable.

Gate BR-QG-008 SHALL verify dependency and conflict review.

Gate BR-QG-009 SHALL verify exception handling.

Gate BR-QG-010 SHALL verify verification method.

Gate BR-QG-011 SHALL verify approval authority.

Gate BR-QG-012 SHALL verify status and version.

Rules that fail mandatory quality gates SHALL NOT be approved.

## 27 Rule Examples

This framework SHALL NOT define actual ERM-System business rules.

The following examples are structural examples only.

They SHALL NOT be used as active rules.

Structural examples MAY demonstrate how fields are completed without creating business obligations.

Example Rule ID: `BR-000000`

Example Rule Name: Example Placeholder Rule

Example Classification: Validation Rule

Example Description: This placeholder demonstrates the rule description field and does not define an active rule.

Example Business Rationale: This placeholder demonstrates where rationale would be documented.

Example Outcome: This placeholder demonstrates where an outcome would be documented.

Any future document that includes real business rule examples SHALL clearly distinguish examples from approved rules.

## 28 References

`docs/product/PRODUCT_DEFINITION.md`: Authoritative product definition.

`docs/domain/DOMAIN_MODEL.md`: Authoritative domain terminology and business concepts.

`docs/business/BUSINESS_CAPABILITY_MODEL.md`: Authoritative business capability model.

`docs/business/BUSINESS_PROCESS_ARCHITECTURE.md`: Authoritative business process architecture.

`docs/governance/ENGINEERING_MANIFEST.md`: Root engineering governance reference.

`docs/governance/ENGINEERING_DOCUMENTATION_STANDARD.md`: Documentation standard.

RFC 2119: Key words for use in RFCs to Indicate Requirement Levels.

## 29 Appendix A - Rule Template

Future rule catalogs SHALL use the following template for every business rule.

### Rule Header

Rule ID: `BR-NNNNNN`

Rule Name: `<Concise business name>`

Classification: `<Primary rule classification>`

Status: `<Identified | Draft | Review | Approved | Implemented | Verified | Deprecated | Superseded | Archived>`

Version: `<Major.Minor>`

Priority: `<Critical | High | Medium | Low>`

Severity: `<Critical | High | Medium | Low>`

### Rule Definition

Description: `<Business-language rule statement>`

Business Rationale: `<Why this rule exists>`

Business Source: `<Authority, document, policy, decision, regulation, or approved source>`

Business Owner: `<Accountable business owner>`

Applies To: `<Business subject, process, capability, actor, context, or entity>`

### Rule Logic

Preconditions: `<What must be true before evaluation>`

Trigger: `<Business event or circumstance that triggers evaluation>`

Condition: `<Business condition being evaluated>`

Outcome: `<Required business result>`

Exceptions: `<Approved exceptions or "None approved">`

### Rule Traceability

Traceability: `<Source, approval, verification, and downstream references>`

Related Processes: `<Process IDs or names>`

Related Capabilities: `<Capability IDs or names>`

Related Domain Entities: `<Domain entities or terms>`

Dependencies: `<Related rule IDs and dependency type>`

### Rule Verification

Verification Method: `<Scenario review, acceptance test, decision table, audit review, reporting reconciliation, security review, or other method>`

Verification Evidence: `<Evidence reference when available>`

Last Verified: `<Date or not yet verified>`

### Rule Governance

Approver: `<Approving authority>`

Reviewers: `<Reviewing roles or groups>`

Created: `<Date>`

Last Updated: `<Date>`

Next Review: `<Date or review trigger>`

Supersedes: `<Rule ID or none>`

Superseded By: `<Rule ID or none>`

## 30 Appendix B - Rule Taxonomy

| Classification | Primary Purpose | Typical Owner | Typical Verification Method |
| --- | --- | --- | --- |
| Eligibility Rules | Determine qualification for action, role, pathway, or state. | Relevant business authority | Scenario review |
| Validation Rules | Determine completeness, consistency, or readiness. | Process owner | Sample case validation |
| Workflow Rules | Govern sequence, routing, lifecycle, and state movement. | Process owner | Process walkthrough |
| Decision Rules | Determine business outcome from criteria. | Decision authority | Decision table review |
| Approval Rules | Govern approval eligibility, terms, and outcomes. | Approval authority | Acceptance criteria review |
| Committee Rules | Govern committee authority and decision activity. | Research Ethics Committee | Governance review |
| Compliance Rules | Govern alignment with approved obligations. | Research Governance Authority | Compliance review |
| Regulatory Rules | Reflect regulatory authority. | Regulatory authority or delegate | Regulatory review |
| Security Rules | Govern confidentiality and authorized access purpose. | Security Governance | Security review |
| Notification Rules | Govern notices, reminders, requests, and communication triggers. | Process owner | Scenario review |
| Scheduling Rules | Govern deadlines, due periods, recurrence, and escalation timing. | Process owner | Boundary case review |
| Reporting Rules | Govern report inclusion, aggregation, and interpretation. | Reporting owner | Reporting reconciliation |
| Retention Rules | Govern record retention and archival expectations. | Records authority | Audit review |
| Audit Rules | Govern audit evidence, audit scope, and audit trail expectations. | Audit authority | Audit evidence review |
| Reference Rules | Govern controlled terms, lists, and guidance references. | Reference steward | Reference review |
| Calculation Rules | Govern calculated business values or thresholds. | Business owner | Calculation check |
| Configuration Rules | Govern business-level settings or controlled options. | Configuration owner | Configuration review |
| Integration Rules | Govern business information exchange and coordination. | Coordination owner | Interface walkthrough |
| System Constraints | Define business constraints future systems must respect. | Product or governance owner | Architecture review |
| National Policy Rules | Reflect national governance policy. | National policy authority | Policy review |
