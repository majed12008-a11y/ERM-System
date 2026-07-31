# Engineering Manifest

## Document Control

Document ID: SPEC-0001

Title: Engineering Manifest

Status: Approved

Version: 1.0

Owner: Engineering Governance

Audience: Software Architects, Technical Leads, Backend Engineers, Frontend Engineers, Database Engineers, DevOps Engineers, QA Engineers, Security Engineers, AI Agents, and Future Contributors

## Normative Language

The key words MUST, MUST NOT, SHALL, SHALL NOT, SHOULD, SHOULD NOT, and MAY in this document are to be interpreted as described by RFC 2119.

This document is the root engineering governance document for the ERM-System project.

Every future engineering document SHALL reference this Engineering Manifest.

Where another engineering document conflicts with this Engineering Manifest, this Engineering Manifest SHALL take precedence unless a formally approved Architecture Decision Record explicitly supersedes a specific clause.

## 1 Executive Summary

The ERM-System project requires a durable engineering foundation that can guide architecture, implementation, review, operations, security, quality, documentation, and future change.

This Engineering Manifest establishes that foundation.

It defines the engineering intent of the project without replacing detailed design documents, architecture decisions, module specifications, test plans, runbooks, or operational procedures.

It is intended to be stable.

It is intended to be cited.

It is intended to provide alignment when the project grows, when contributors change, when requirements evolve, and when engineering judgment is required.

The ERM-System SHALL be engineered as an enterprise-grade platform.

The platform SHALL prioritize correctness, auditability, security, maintainability, traceability, and operational confidence.

Engineering work SHALL be conducted in a disciplined manner.

Engineering decisions SHALL be documented at the appropriate level.

Implementation details SHALL be traceable to requirements, architecture decisions, or approved engineering tasks.

The project SHALL preserve a clear distinction between governance, architecture, design, implementation, testing, deployment, and operations.

This Manifest establishes common expectations for all engineering participants.

It applies to humans and AI agents.

It applies to future contributors who may not have access to the historical context behind early project decisions.

It applies to every part of the repository, including backend, frontend, database, documentation, DevOps, security, testing, and AI-assisted workflows.

This Manifest does not define every rule required to build the system.

Instead, it defines the principles and governance model from which more specific standards SHALL derive.

Future documents SHOULD be narrower, more concrete, and easier to change than this Manifest.

This Manifest SHOULD change only when the governing engineering philosophy changes.

## 2 Engineering Vision

The engineering vision for ERM-System is to build and maintain a trustworthy platform for ethics and research management.

The system SHALL support accountable workflows, reliable data handling, controlled access, repeatable operations, and evidence-based governance.

Engineering work SHALL enable the organization to trust the system during normal use, review, audit, incident response, and future extension.

The project SHALL be designed so that future engineers can understand why the system works as it does.

The project SHALL avoid designs that require undocumented tribal knowledge.

The project SHALL prefer explicit contracts over implicit assumptions.

The project SHALL prefer traceable decisions over unrecorded convenience.

The project SHALL prefer maintainable evolution over short-term acceleration that creates hidden risk.

The project SHALL treat documentation as part of the system, not as a secondary artifact.

The platform SHOULD remain understandable to a qualified engineer who joins the project after major implementation work has already occurred.

The platform SHOULD remain testable as modules, integrations, and operational practices evolve.

The platform SHOULD remain auditable when business rules, workflow rules, and security policies are challenged.

The platform SHOULD support responsible AI assistance without allowing AI output to bypass review, security, or engineering judgment.

## 3 Engineering Mission

The engineering mission is to deliver and maintain a secure, reliable, auditable, and evolvable ERM-System platform.

Engineering contributors SHALL translate approved requirements into working, reviewed, tested, documented, and operable system behavior.

Engineering contributors SHALL protect the integrity of the system while enabling controlled change.

Engineering contributors SHALL preserve the project’s architectural intent.

Engineering contributors SHALL maintain alignment between source code, database behavior, API contracts, tests, operational procedures, and documentation.

Engineering contributors SHALL identify risks early.

Engineering contributors SHALL make tradeoffs visible.

Engineering contributors SHALL record material decisions.

Engineering contributors SHALL avoid changes that are correct in isolation but harmful to the platform as a whole.

The mission is not merely to produce code.

The mission is to produce reliable engineering outcomes.

## 4 Engineering Values

### 4.1 Trustworthiness

The project SHALL value correctness, security, and auditability over superficial speed.

Engineering work MUST be suitable for a platform that handles sensitive governance workflows.

Contributors MUST consider whether a change preserves user trust, institutional trust, and audit trust.

### 4.2 Clarity

The project SHALL value clear naming, clear documentation, clear ownership, and clear contracts.

Ambiguous behavior SHOULD be clarified before implementation.

Where ambiguity remains, assumptions SHALL be documented.

### 4.3 Traceability

The project SHALL value traceability from requirements to implementation to tests to release evidence.

Material changes SHOULD be linkable to tasks, specifications, decisions, or defects.

Traceability SHALL be treated as an engineering capability, not administrative overhead.

### 4.4 Maintainability

The project SHALL value systems that can be safely changed.

Maintainability includes readable code, coherent module boundaries, stable contracts, useful tests, and current documentation.

Contributors SHALL avoid unnecessary complexity.

Contributors SHALL avoid changes that increase long-term cost without an explicit and approved reason.

### 4.5 Security

Security SHALL be a first-class engineering concern.

Security MUST be considered in design, implementation, review, testing, operations, and documentation.

Security controls SHALL NOT be bypassed for convenience.

### 4.6 Accountability

Engineering decisions SHALL have accountable owners.

Reviews SHALL be meaningful.

Approvals SHALL represent actual understanding of the change being approved.

### 4.7 Operational Readiness

The system SHALL be engineered for operation, not merely demonstration.

Changes SHOULD consider deployability, observability, rollback, incident response, and supportability.

### 4.8 Responsible AI Collaboration

AI agents MAY assist with engineering work.

AI agents MUST operate within the same governance constraints as human contributors.

AI-generated changes MUST be reviewed and verified.

AI output SHALL NOT be treated as authoritative merely because it is fluent.

## 5 Engineering Principles

### 5.1 Principle of Explicit Authority

Every material engineering change SHOULD derive from an approved requirement, specification, defect, architecture decision, or engineering task.

Unplanned changes MAY be made only when necessary and SHOULD be documented afterward.

### 5.2 Principle of Least Surprise

The system SHOULD behave in ways that are consistent with its documented contracts and established patterns.

Contributors SHOULD avoid introducing local behavior that contradicts platform conventions.

### 5.3 Principle of Layer Respect

The project SHALL preserve architectural boundaries.

Routes, services, repositories, database policies, frontend views, SDK contracts, and documentation assets each have distinct responsibilities.

Changes SHOULD be made at the correct layer.

Bypassing a layer MUST be justified and reviewed.

### 5.4 Principle of Secure Defaults

Default behavior SHOULD deny unauthorized access, preserve auditability, avoid data exposure, and fail safely.

Controls MUST NOT rely on undocumented assumptions.

### 5.5 Principle of Controlled Evolution

The platform SHALL evolve through reviewed and traceable changes.

Large changes SHOULD be decomposed into understandable increments.

Architectural changes SHOULD be recorded before implementation when feasible.

### 5.6 Principle of Testable Behavior

System behavior SHOULD be testable.

Critical workflows MUST have appropriate verification evidence.

Tests SHOULD validate business behavior, security behavior, integration behavior, and failure behavior where relevant.

### 5.7 Principle of Documentation Proximity

Documentation SHOULD live close to the domain it describes.

Root governance documents SHALL live under governance.

Architecture documents SHALL live under architecture unless a more specific domain folder is appropriate.

Operational documents SHALL live under operations.

### 5.8 Principle of Human Review

Human review SHALL remain required for material engineering decisions and changes.

AI assistance SHALL NOT remove the need for accountable review.

### 5.9 Principle of Audit Preservation

The project SHALL preserve audit trails and evidence.

Engineering work MUST NOT remove or weaken audit behavior without formal approval.

### 5.10 Principle of Minimal Necessary Change

Changes SHOULD be scoped to the task at hand.

Unrelated refactoring SHOULD be avoided unless explicitly approved.

When broader cleanup is necessary, it SHOULD be separated from feature or defect work.

## 6 Engineering Governance

Engineering governance defines how the project maintains technical coherence over time.

The project SHALL maintain governance documents that define policies, standards, and decision rules.

Governance documents SHALL be written in professional technical English unless a document has an approved reason to use another language.

Governance documents SHALL identify their purpose, audience, status, and relationship to this Manifest.

Governance documents SHALL NOT silently contradict this Manifest.

Engineering governance SHALL include architecture governance, documentation governance, coding governance, AI governance, quality governance, security governance, release governance, change management, and risk management.

Governance SHALL be practical.

Governance SHALL support delivery rather than replace delivery.

Governance SHALL be strong where the system carries high risk.

Governance MAY be lightweight where the change is low risk and local.

The governance model SHALL recognize that not every change requires the same level of ceremony.

However, every change SHALL require an appropriate level of care.

## 7 Decision Making Process

Engineering decisions SHALL be made at the lowest appropriate level of authority.

Decisions that affect local implementation MAY be made by the responsible engineer, subject to review.

Decisions that affect module boundaries SHOULD involve the relevant technical lead or architect.

Decisions that affect system architecture SHALL be recorded as architecture decisions.

Decisions that affect security posture SHALL involve security review.

Decisions that affect release readiness SHALL involve release governance.

Decisions that affect data integrity, auditability, or access control SHALL receive heightened review.

Decision records SHOULD include context, options considered, decision, consequences, and status.

When a decision is reversible and low risk, a lightweight process MAY be used.

When a decision is difficult to reverse, high risk, or cross-cutting, a formal decision process SHALL be used.

Rejected options SHOULD be recorded when future contributors are likely to revisit the same question.

Decisions SHALL be reviewed when their assumptions are no longer valid.

Decisions SHALL NOT be changed informally through implementation drift.

## 8 Architecture Governance

Architecture governance SHALL preserve the structural integrity of the ERM-System.

Architecture documents SHALL define system structure, module responsibilities, integration boundaries, and major quality attributes.

Architecture decisions SHALL be captured in decision records when they establish or change significant direction.

Architecture governance SHALL respect the existing project architecture.

The backend follows a layered structure.

The frontend follows a component and page-oriented application structure.

The database and access policies are first-class parts of the architecture.

The documentation hierarchy is part of the engineering architecture for knowledge management.

Architecture work SHALL consider security, auditability, maintainability, performance, reliability, testability, and operability.

Architecture changes SHOULD describe impact on existing modules.

Architecture changes SHOULD identify migration concerns.

Architecture changes SHOULD identify documentation that must be updated.

Architecture changes SHOULD identify tests or verification evidence required.

Architecture governance SHALL NOT be used to freeze the system.

It SHALL be used to make change safe, intentional, and understandable.

## 9 Documentation Governance

Documentation SHALL be treated as an engineering deliverable.

Every engineering document SHALL reference this Engineering Manifest.

Every engineering document SHOULD have a clear purpose.

Every engineering document SHOULD identify its intended audience.

Every engineering document SHOULD be placed in the correct domain-based documentation folder.

Documentation SHALL use domain-based directory names.

Documentation SHALL NOT use numeric directory prefixes.

Documentation SHALL avoid duplicating source code.

Documentation SHALL avoid duplicating future detailed standards when a principle-level reference is sufficient.

Documentation SHOULD record stable knowledge, decisions, contracts, and procedures.

Documentation SHOULD NOT become a dumping ground for temporary notes.

Temporary notes MAY exist when clearly marked and managed.

Superseded documents SHOULD be identified rather than silently removed.

Documentation changes SHOULD be reviewed when they affect engineering standards, architecture, security, release readiness, or operational behavior.

Documentation SHALL be updated when a change invalidates existing documentation.

Documentation debt SHALL be treated as technical debt.

## 10 Coding Governance

Coding governance SHALL ensure that implementation work remains consistent, maintainable, secure, and reviewable.

Contributors SHALL follow established patterns in the repository.

Contributors SHALL avoid introducing new frameworks, libraries, or architectural styles without approval.

Contributors SHALL keep changes scoped to the approved task.

Contributors SHALL avoid unrelated formatting churn.

Contributors SHALL preserve existing behavior unless the task explicitly changes it.

Contributors SHALL understand the code they modify.

Contributors SHALL consider the effect of changes on adjacent modules, tests, documentation, and operations.

Generated files SHALL be managed through their generator where applicable.

Generated files SHOULD NOT be hand-edited unless the project has explicitly approved that workflow.

Code comments SHOULD explain non-obvious intent.

Code comments SHOULD NOT restate obvious implementation mechanics.

Public contracts SHOULD be stable.

Breaking changes SHALL be identified, reviewed, and documented.

Error handling SHOULD be explicit and consistent with established project behavior.

Data validation SHOULD occur at appropriate boundaries.

Security-sensitive code MUST be reviewed with appropriate care.

## 11 AI Governance

AI agents MAY assist with analysis, documentation, coding, testing, review, and operational support.

AI agents SHALL follow this Manifest.

AI agents SHALL respect repository boundaries and task constraints.

AI agents SHALL NOT modify application source code when the task is limited to documentation.

AI agents SHALL NOT bypass security controls.

AI agents SHALL NOT invent project facts.

AI agents SHALL distinguish between known project context, inferred context, and external information.

AI agents SHOULD inspect local project context before making project-specific claims.

AI agents MUST NOT expose secrets.

AI agents MUST NOT fabricate test results.

AI agents MUST NOT claim that work is complete unless it has been completed or the limitation is disclosed.

AI-generated code or documentation SHALL be reviewed with the same rigor as human-authored work.

AI-generated recommendations SHOULD include assumptions when assumptions materially affect correctness.

AI agents SHOULD prefer small, verifiable changes.

AI agents SHOULD preserve user changes.

AI agents SHALL NOT revert unrelated work without explicit authorization.

AI usage SHALL remain accountable to the responsible human owner.

## 12 Quality Governance

Quality governance SHALL define how the project achieves confidence in the system.

Quality SHALL include functional correctness, integration correctness, security correctness, data integrity, usability, performance, reliability, maintainability, and documentation accuracy.

Quality SHALL be built into the lifecycle rather than added only at the end.

Tests SHOULD be aligned with risk.

High-risk changes SHOULD require stronger verification.

Low-risk documentation-only changes MAY require lightweight verification.

Critical business workflows SHOULD have explicit acceptance criteria.

Defects SHALL be recorded with sufficient information to reproduce, assess, prioritize, and verify resolution.

Regression risk SHOULD be considered for every change.

Quality evidence SHOULD be preserved for release decisions.

Quality gates SHOULD be explicit.

A failed quality gate SHALL be resolved or formally accepted as risk before release.

Testing SHALL NOT be reduced merely to satisfy schedule pressure without explicit risk acceptance.

## 13 Security Governance

Security governance SHALL protect confidentiality, integrity, availability, accountability, and auditability.

Security SHALL be considered during requirements, architecture, implementation, testing, release, and operations.

Access control SHALL remain explicit and enforceable.

Security controls SHALL NOT be bypassed for convenience.

Sensitive data SHALL be handled according to approved project security rules.

Secrets MUST NOT be committed or exposed.

Authentication, authorization, audit, and data isolation behavior SHALL be reviewed when changed.

Database access control and row-level security are first-class security concerns for this project.

Changes affecting row-level security MUST receive appropriate review and verification.

Audit trail behavior MUST be preserved unless a formal decision approves a change.

Security defects SHALL be prioritized according to impact and exploitability.

Security documentation SHALL be kept current enough to support review, incident response, and operations.

Security exceptions SHALL be documented with owner, rationale, scope, expiration or review date, and mitigation.

## 14 Release Governance

Release governance SHALL ensure that changes are delivered with appropriate confidence.

Release readiness SHOULD be based on evidence.

Release evidence MAY include completed tasks, tests, reviews, security checks, migration checks, operational checks, and acceptance results.

Release decisions SHALL consider quality, security, operational readiness, known defects, rollback options, and business urgency.

Release notes SHOULD identify material changes, risks, migration steps, and known limitations.

Release artifacts SHOULD be traceable to the work included in the release.

Critical releases SHOULD include rollback or recovery considerations.

Release approval SHALL be performed by accountable owners.

A release SHALL NOT be considered ready merely because implementation work is complete.

Release readiness requires appropriate verification and operational confidence.

## 15 Change Management

Change management SHALL provide disciplined control over modifications to the system.

Changes SHOULD have clear scope.

Changes SHOULD have clear acceptance criteria.

Changes SHOULD identify affected areas.

Changes SHOULD identify verification requirements.

Changes SHOULD identify documentation updates.

Changes SHOULD identify operational impact.

High-risk changes SHALL require stronger review and evidence.

Emergency changes MAY use expedited processes.

Emergency changes SHALL be documented afterward.

Changes SHALL preserve Git history.

Changes SHALL NOT delete or rewrite history unless explicitly approved by the project governance process.

Changes SHALL distinguish between intentional changes and incidental workspace state.

Unrelated changes SHALL NOT be mixed when avoidable.

## 16 Risk Management

Engineering risk SHALL be identified, assessed, communicated, and managed.

Risk management SHALL consider technical, security, operational, data, compliance, schedule, quality, and maintainability risks.

Risks SHOULD have owners.

Risks SHOULD have mitigations.

Risks SHOULD be reviewed when conditions change.

Unresolved high-risk issues SHOULD be visible to decision makers.

Risk acceptance SHALL be explicit.

Risk acceptance SHALL identify scope and rationale.

Risk acceptance SHALL NOT be implied by silence.

The project SHOULD prefer reducing risk early over discovering risk at release time.

Architectural risk SHOULD be captured in architecture documents or decision records.

Security risk SHOULD be captured in security documentation.

Operational risk SHOULD be captured in operational documentation.

## 17 Technical Debt Policy

Technical debt is any known gap that increases the future cost, risk, or difficulty of changing, operating, securing, testing, or understanding the system.

Technical debt MAY be acceptable when consciously incurred for a justified reason.

Technical debt SHALL NOT be hidden.

Technical debt SHOULD have an owner or responsible area.

Technical debt SHOULD have an impact statement.

Technical debt SHOULD have a remediation path where practical.

Technical debt SHOULD be reviewed periodically.

High-risk technical debt SHALL be escalated.

Documentation debt is technical debt.

Test debt is technical debt.

Security debt is technical debt with elevated risk.

Operational debt is technical debt when it impairs supportability or recovery.

The project SHALL avoid treating technical debt as a moral failure.

The project SHALL treat unmanaged technical debt as an engineering risk.

## 18 Definition of Ready

A work item is ready when it has enough information for responsible implementation to begin.

The Definition of Ready SHOULD be scaled to the risk and size of the work.

For material engineering work, a ready item SHOULD identify the objective.

For material engineering work, a ready item SHOULD identify scope.

For material engineering work, a ready item SHOULD identify affected areas.

For material engineering work, a ready item SHOULD identify acceptance criteria.

For material engineering work, a ready item SHOULD identify constraints.

For material engineering work, a ready item SHOULD identify security considerations.

For material engineering work, a ready item SHOULD identify test expectations.

For material engineering work, a ready item SHOULD identify documentation expectations.

For material engineering work, a ready item SHOULD identify dependencies.

A work item SHALL NOT be considered ready if critical ambiguity would force the implementer to invent requirements.

A work item MAY begin before complete readiness when exploratory analysis is the explicit purpose of the task.

## 19 Definition of Done

A work item is done when it satisfies its acceptance criteria and is ready for its intended next lifecycle step.

The Definition of Done SHOULD be scaled to the risk and size of the work.

For material engineering work, done SHOULD mean the implementation is complete.

For material engineering work, done SHOULD mean relevant tests or verification have been completed or limitations documented.

For material engineering work, done SHOULD mean relevant documentation has been updated.

For material engineering work, done SHOULD mean review feedback has been addressed or formally deferred.

For material engineering work, done SHOULD mean known risks are documented.

For material engineering work, done SHOULD mean no unrelated changes were introduced.

For material engineering work, done SHOULD mean release or operational implications are understood.

A work item SHALL NOT be called done when known acceptance criteria remain unmet.

A work item SHALL NOT be called done when verification has been skipped without disclosure.

## 20 Engineering Lifecycle

The engineering lifecycle SHALL support controlled movement from idea to operation.

The lifecycle SHOULD include intake, clarification, design, decision, implementation, review, verification, release, operation, and improvement.

Not every change requires every phase at the same level of formality.

Every change SHOULD have an appropriate lifecycle path.

Intake SHOULD capture the reason for the work.

Clarification SHOULD reduce ambiguity.

Design SHOULD address structure and risk.

Decision records SHOULD capture significant choices.

Implementation SHOULD follow approved architecture and coding standards.

Review SHOULD assess correctness, risk, maintainability, security, and fit.

Verification SHOULD provide evidence appropriate to the change.

Release SHOULD be governed by readiness.

Operation SHOULD preserve availability, supportability, and incident response capability.

Improvement SHOULD capture lessons learned.

Lifecycle artifacts SHOULD be traceable where practical.

## 21 Repository Organization

The repository SHALL remain organized so contributors can locate engineering assets predictably.

Application source code SHALL remain separate from documentation governance assets.

Documentation SHALL live under the docs directory.

Governance documents SHALL live under docs/governance unless a more specific approved location applies.

Architecture documents SHALL live under docs/architecture.

Backend documentation SHALL live under docs/backend.

Frontend documentation SHALL live under docs/frontend.

Database documentation SHALL live under docs/database.

API documentation SHALL live under docs/api.

Security documentation SHALL live under docs/security.

Testing documentation SHALL live under docs/testing.

DevOps documentation SHALL live under docs/devops.

Operational documentation SHALL live under docs/operations.

Reference documentation SHALL live under docs/reference.

Templates SHALL live under docs/templates.

Repository organization changes SHALL be documented when they affect contributor workflows.

Repository organization SHALL NOT depend on numeric directory prefixes.

## 22 Documentation Hierarchy

The documentation hierarchy SHALL be domain-based.

The top-level documentation domains are governance, product, domain, architecture, engineering, backend, frontend, database, api, security, testing, devops, ai-platform, ai-agents, decisions, governance-records, roadmap, operations, research, reference, and templates.

This Engineering Manifest SHALL be the root document of the Engineering Knowledge Base.

Documents under governance SHALL define project-wide engineering standards and controls.

Documents under product SHALL describe product intent and product-level requirements.

Documents under domain SHALL describe domain concepts and business rules.

Documents under architecture SHALL describe structural and cross-cutting technical design.

Documents under engineering SHALL describe engineering practices and contributor workflows.

Documents under backend SHALL describe backend-specific concerns.

Documents under frontend SHALL describe frontend-specific concerns.

Documents under database SHALL describe database-specific concerns.

Documents under api SHALL describe API-specific concerns.

Documents under security SHALL describe security policies, audits, controls, and risks.

Documents under testing SHALL describe test strategy, evidence, and quality gates.

Documents under devops SHALL describe deployment, CI, environment, and infrastructure practices.

Documents under ai-platform SHALL describe AI platform governance and platform-level AI integration principles.

Documents under ai-agents SHALL describe AI agent roles, constraints, and workflows.

Documents under decisions SHALL contain decision records.

Documents under governance-records SHALL preserve governance evidence and records.

Documents under roadmap SHALL describe planned engineering evolution.

Documents under operations SHALL describe operational procedures and runbooks.

Documents under research SHALL contain research and exploratory analysis.

Documents under reference SHALL contain glossary, acronyms, indexes, and stable reference material.

Documents under templates SHALL contain reusable documentation templates.

## 23 Versioning Policy

Engineering documents SHOULD identify version when versioning is meaningful.

Governance documents SHALL identify version.

Approved governance documents SHALL identify status.

Version changes SHOULD reflect the significance of change.

Major versions SHOULD indicate substantive policy or standard changes.

Minor versions SHOULD indicate clarifications or compatible additions.

Patch or editorial changes MAY be tracked through Git history without changing the visible document version when governance permits.

Source code versioning SHALL follow the project’s release and repository practices.

Documentation versioning SHALL preserve the ability to understand what guidance was in effect at a given time.

Superseded guidance SHOULD be marked or linked rather than silently contradicted.

Version metadata SHALL NOT be used as a substitute for Git history.

## 24 Traceability Policy

Traceability SHALL connect engineering intent to engineering evidence.

Material requirements SHOULD be traceable to implementation.

Material implementation SHOULD be traceable to tests or verification evidence.

Material decisions SHOULD be traceable to decision records.

Material releases SHOULD be traceable to included changes and release evidence.

Security-sensitive changes SHALL be traceable to review and verification evidence.

Database and access-control changes SHALL be traceable to their rationale and validation.

Documentation changes SHOULD be traceable to the standards, decisions, or tasks that required them.

Traceability MAY be lightweight for minor or local changes.

Traceability SHALL be strong for high-risk or cross-cutting changes.

The absence of traceability SHOULD be treated as a risk.

## 25 Review Policy

Review SHALL be part of the engineering process.

The review level SHALL match the risk and scope of the change.

Code review SHOULD assess correctness.

Code review SHOULD assess maintainability.

Code review SHOULD assess security implications.

Code review SHOULD assess test adequacy.

Code review SHOULD assess documentation impact.

Architecture review SHALL be required for significant architectural changes.

Security review SHALL be required for changes affecting security posture.

Database review SHOULD be required for changes affecting schema, policies, migrations, data integrity, or audit behavior.

Documentation review SHOULD be required for governance and architecture documents.

Reviewers SHALL provide actionable feedback.

Authors SHALL address review feedback or document why it is not accepted.

Approval SHALL NOT be a substitute for understanding.

## 26 Approval Workflow

Approval workflows SHALL define who may approve changes and under what conditions.

Approval SHALL be based on evidence and accountability.

Governance documents SHALL require approval by the appropriate governance owner.

Architecture decisions SHALL require approval by the appropriate architecture authority.

Security-sensitive changes SHALL require approval by an appropriate security authority.

Release decisions SHALL require approval by release owners.

Emergency approvals MAY be expedited.

Emergency approvals SHALL be documented afterward.

Approval records SHOULD be retained where they support auditability.

Approval SHALL NOT be implied by inactivity.

Approval SHALL NOT excuse failure to meet mandatory controls unless an exception is explicitly approved.

Rejected changes SHOULD include a reason when practical.

Deferred changes SHOULD include the condition for reconsideration when practical.

## 27 Continuous Improvement

The project SHALL improve its engineering system over time.

Continuous improvement SHOULD be based on evidence.

Evidence MAY include defects, incidents, review findings, delivery friction, operational issues, security findings, test gaps, documentation gaps, and contributor feedback.

Improvement work SHOULD target root causes rather than symptoms.

Improvement work SHOULD be prioritized according to risk and value.

Lessons learned SHOULD be documented when they affect future engineering behavior.

Governance documents SHOULD be reviewed when repeated friction indicates that standards are unclear or outdated.

The project SHOULD avoid process accumulation that does not improve outcomes.

The project SHOULD remove or simplify controls that no longer serve a clear purpose.

The project SHALL preserve controls that protect security, auditability, quality, and operational safety.

## 28 Success Metrics

Engineering success SHALL be measured by outcomes, not activity alone.

Success metrics SHOULD include system reliability.

Success metrics SHOULD include defect trends.

Success metrics SHOULD include security findings and remediation.

Success metrics SHOULD include test effectiveness.

Success metrics SHOULD include release quality.

Success metrics SHOULD include documentation currency.

Success metrics SHOULD include review effectiveness.

Success metrics SHOULD include operational readiness.

Success metrics SHOULD include traceability coverage for high-risk work.

Success metrics SHOULD include technical debt visibility and reduction.

Metrics SHALL be interpreted carefully.

Metrics SHALL NOT be used in ways that incentivize unsafe behavior.

Metrics SHOULD inform decisions rather than replace engineering judgment.

The project SHOULD periodically review whether its metrics still reflect the desired engineering outcomes.

## 29 References

RFC 2119 SHALL be the normative reference for requirement keyword interpretation in this document.

This document SHALL be referenced by future engineering standards, architecture documents, governance records, and engineering templates.

Architecture Decision Records SHALL be maintained under the project documentation hierarchy.

Project-specific implementation documents SHOULD reference this Manifest and the relevant domain standards.

Security documents SHOULD reference this Manifest when defining controls, findings, or exceptions.

Release documents SHOULD reference this Manifest when defining release evidence or readiness.

Testing documents SHOULD reference this Manifest when defining quality gates and verification strategy.

Operational documents SHOULD reference this Manifest when defining supportability, incident response, recovery, or runbook practices.

AI governance documents SHOULD reference this Manifest when defining agent behavior, review expectations, and boundaries.

## 30 Appendix

### 30.1 Manifest Scope

This Manifest defines project-wide engineering governance.

It does not define detailed coding standards.

It does not define detailed database design.

It does not define detailed API specifications.

It does not define detailed frontend design rules.

It does not define detailed test procedures.

It does not define detailed operational runbooks.

Those documents SHALL derive from this Manifest.

### 30.2 Required Reference Clause for Future Engineering Documents

Future engineering documents SHOULD include a reference statement equivalent to:

This document is governed by `docs/governance/ENGINEERING_MANIFEST.md`.

The exact wording MAY vary when appropriate.

The governance relationship SHALL remain clear.

### 30.3 Policy Conflict Handling

When two documents conflict, contributors SHALL identify the conflict.

Contributors SHALL determine the authority level of each document.

Contributors SHALL follow the higher-authority document until the conflict is resolved.

Contributors SHOULD create or update a decision record when the conflict affects architecture or governance.

Contributors SHALL NOT silently choose the more convenient interpretation.

### 30.4 Exception Handling

Exceptions to mandatory requirements SHALL be documented.

Exceptions SHALL have an owner.

Exceptions SHALL have a rationale.

Exceptions SHALL have a scope.

Exceptions SHOULD have an expiration date or review trigger.

Security exceptions SHALL receive security review.

Architecture exceptions SHALL receive architecture review.

Release exceptions SHALL be visible during release approval.

### 30.5 Contributor Expectations

Contributors SHALL read the relevant documentation before making material changes.

Contributors SHALL ask for clarification when requirements are ambiguous.

Contributors SHALL preserve existing user work.

Contributors SHALL avoid unrelated changes.

Contributors SHALL document material assumptions.

Contributors SHALL verify work at a level appropriate to risk.

Contributors SHALL disclose limitations in verification.

Contributors SHALL maintain professional engineering discipline.

### 30.6 AI Agent Expectations

AI agents SHALL inspect relevant local context before project-specific changes.

AI agents SHALL obey task constraints.

AI agents SHALL avoid modifying source code during documentation-only tasks.

AI agents SHALL report what they changed.

AI agents SHALL report what they could not verify.

AI agents SHALL distinguish between completed work and recommended follow-up.

AI agents SHALL preserve human accountability.

### 30.7 Governance Review

This Manifest SHOULD be reviewed when major engineering governance changes are proposed.

This Manifest SHOULD be reviewed when repeated exceptions indicate that the policy no longer fits the project.

This Manifest SHOULD be reviewed when a major architectural transition changes the assumptions behind the governance model.

This Manifest SHOULD be reviewed when security, operational, or quality incidents reveal a gap in engineering governance.

Changes to this Manifest SHALL be approved through the appropriate governance process.
