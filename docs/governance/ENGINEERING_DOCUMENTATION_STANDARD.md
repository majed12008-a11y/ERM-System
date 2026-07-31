# Engineering Documentation Standard

## Document Metadata

Document ID: SPEC-0002

Title: Engineering Documentation Standard

Status: Approved

Version: 1.0

Owner: Documentation Engineering

Approvers: Engineering Governance

Reviewers: Software Architecture, Technical Leadership, Quality Engineering, Security Engineering

Classification: Standard

Audience: Software Architects, Technical Leads, Backend Engineers, Frontend Engineers, Database Engineers, DevOps Engineers, QA Engineers, Security Engineers, AI Agents, and Future Contributors

Created: 2026-07-31

Last Updated: 2026-07-31

Next Review: To be scheduled by Engineering Governance

Related Documents: `docs/governance/ENGINEERING_MANIFEST.md`

Depends On: `docs/governance/ENGINEERING_MANIFEST.md`

References: RFC 2119

Keywords: documentation, standard, markdown, metadata, review, approval, lifecycle

Confidentiality: Internal

## Normative Language

The key words MUST, MUST NOT, SHALL, SHALL NOT, SHOULD, SHOULD NOT, and MAY in this document are to be interpreted as described by RFC 2119.

## 1. Purpose

This standard defines mandatory documentation rules for engineering documents in the ERM-System repository.

It establishes consistent expectations for structure, metadata, naming, placement, formatting, references, review, approval, and lifecycle management.

It SHALL apply to documents created by humans and AI agents.

It SHALL support long-term consistency, maintainability, reviewability, and discoverability of engineering knowledge.

This standard SHALL NOT define engineering policy.

Engineering policy remains outside the scope of this document.

## 2. Scope

This standard governs engineering documentation stored in the repository.

It governs Markdown structure.

It governs metadata.

It governs file naming.

It governs folder placement.

It governs versioning.

It governs cross references.

It governs diagrams.

It governs tables.

It governs code examples.

It governs images.

It governs terminology.

It governs status values.

It governs review process expectations for documentation.

It governs document lifecycle expectations.

This standard does not govern source code style.

This standard does not govern runtime architecture.

This standard does not govern database design.

This standard does not govern release policy except where release documents are documentation artifacts.

## 3. Authority

This document is an approved engineering documentation standard.

All future engineering documents SHALL comply with this standard unless an approved exception exists.

When a lower-level documentation template conflicts with this standard, this standard SHALL take precedence.

When a future document requires a specialized format, the exception SHALL be documented in that document or in an approved governing record.

## 4. Relationship to Engineering Manifest

The Engineering Manifest is the higher authority.

This standard derives authority from `docs/governance/ENGINEERING_MANIFEST.md`.

This standard SHALL NOT supersede the Engineering Manifest.

Where this standard conflicts with the Engineering Manifest, the Engineering Manifest SHALL prevail.

Every engineering document governed by this standard SHOULD reference the Engineering Manifest.

Documents MAY also reference this standard when documentation format, metadata, lifecycle, or review rules are relevant.

## 5. Document Classification

Every engineering document SHALL declare a classification.

The classification SHALL indicate the intended purpose of the document.

### 5.1 Policy

A Policy defines mandatory governance direction.

A Policy SHALL be approved by the appropriate governance authority.

A Policy SHALL use normative language.

### 5.2 Standard

A Standard defines mandatory rules for consistent execution within a defined area.

A Standard SHALL be specific enough to enforce.

A Standard SHALL remain aligned with higher-authority policies.

### 5.3 Specification

A Specification defines required characteristics, acceptance criteria, or intended outcomes for a document, component, capability, or process.

A Specification SHOULD avoid implementation details unless required for clarity.

### 5.4 Architecture Document

An Architecture Document describes structural, conceptual, or technical design information.

An Architecture Document SHOULD identify its scope and assumptions.

### 5.5 ADR

An Architecture Decision Record records a significant architectural decision.

An ADR SHALL identify context, decision, status, and consequences.

An ADR SHOULD be concise enough to remain usable.

### 5.6 RFC

A Request for Comments proposes a change, approach, or design for review before approval.

An RFC SHALL clearly distinguish proposal from approved decision.

### 5.7 Guide

A Guide provides instructional material.

A Guide SHOULD be practical and task oriented.

A Guide SHALL NOT silently introduce mandatory policy unless it cites an approved policy or standard.

### 5.8 Runbook

A Runbook defines repeatable operational or support procedures.

A Runbook SHOULD be actionable, ordered, and verifiable.

### 5.9 Reference

A Reference document provides stable factual information intended for lookup.

A Reference SHOULD minimize narrative and maximize clarity.

### 5.10 Template

A Template defines reusable document structure.

A Template SHALL comply with this standard unless explicitly scoped for a specialized document type.

### 5.11 Checklist

A Checklist defines a list of verification items.

A Checklist SHOULD include clear completion criteria.

### 5.12 Meeting Notes

Meeting Notes record discussion, decisions, action items, and attendees.

Meeting Notes SHALL NOT be treated as approved policy unless later ratified.

### 5.13 Review Report

A Review Report records findings from a review activity.

A Review Report SHOULD identify scope, method, findings, severity where applicable, and recommendations.

### 5.14 Investigation Report

An Investigation Report records analysis of an issue, incident, defect, risk, or uncertainty.

An Investigation Report SHOULD distinguish facts, findings, hypotheses, and recommendations.

## 6. Mandatory Metadata

Every engineering document SHALL include metadata near the top of the document.

Metadata MAY be expressed as a heading section, table, or structured front matter when approved.

The metadata SHALL be readable in plain Markdown.

The following metadata fields are mandatory unless the document is a template that intentionally demonstrates placeholders.

Document ID SHALL identify the document uniquely where a formal identifier exists.

Title SHALL state the document name.

Status SHALL use an approved status value.

Version SHALL identify the document version.

Owner SHALL identify the accountable owner or owning function.

Approvers SHALL identify the approving role, group, or person.

Reviewers SHALL identify the reviewing role, group, or person.

Classification SHALL identify the document classification.

Audience SHALL identify intended readers.

Created SHALL identify the creation date.

Last Updated SHALL identify the last update date.

Next Review SHALL identify the next planned review date, trigger, or governance scheduling note.

Related Documents SHALL identify documents with relevant relationships.

Depends On SHALL identify documents that this document requires or derives from.

References SHALL identify cited standards, documents, or authoritative sources.

Keywords SHALL support discoverability.

Confidentiality SHALL identify the information classification.

When a metadata value is not yet known, the document MAY use `TBD` during Draft status.

Approved documents SHOULD NOT contain `TBD` in mandatory metadata unless explicitly justified.

## 7. Status Lifecycle

Every engineering document SHALL have exactly one current status.

### 7.1 Draft

Draft means the document is being created or materially revised.

Draft documents SHALL NOT be treated as approved guidance.

### 7.2 Review

Review means the document is ready for reviewer evaluation.

Review documents MAY change in response to feedback.

### 7.3 Approved

Approved means the document has completed the required approval workflow.

Approved documents SHALL be treated as active guidance within their scope.

### 7.4 Deprecated

Deprecated means the document remains available but should no longer be used for new work.

Deprecated documents SHOULD identify replacement guidance when available.

### 7.5 Archived

Archived means the document is retained for historical record.

Archived documents SHALL NOT be treated as active guidance.

### 7.6 Superseded

Superseded means another document has replaced the document.

Superseded documents SHALL identify the superseding document when known.

## 8. File Naming Standard

File names SHALL be descriptive.

File names SHALL use Markdown extension `.md` for Markdown documents.

File names SHOULD use uppercase with underscores for root governance documents when that convention improves visibility.

File names SHOULD use lowercase kebab-case for general documentation unless an existing domain convention requires otherwise.

File names SHALL avoid ambiguous names such as `notes.md`, `new.md`, `final.md`, or `document.md`.

File names SHALL NOT depend on numeric prefixes for ordering.

File names SHOULD include the document type when useful for discovery.

File names SHOULD remain stable after approval.

Renaming an approved document SHOULD be treated as a documentation change requiring review.

## 9. Directory Placement Rules

Documents SHALL be placed according to their primary domain.

Governance documents SHALL be placed under `docs/governance/`.

Product documents SHALL be placed under `docs/product/`.

Domain documents SHALL be placed under `docs/domain/`.

Architecture documents SHALL be placed under `docs/architecture/`.

Engineering practice documents SHALL be placed under `docs/engineering/`.

Backend-specific documents SHALL be placed under `docs/backend/`.

Frontend-specific documents SHALL be placed under `docs/frontend/`.

Database-specific documents SHALL be placed under `docs/database/`.

API-specific documents SHALL be placed under `docs/api/`.

Security documents SHALL be placed under `docs/security/`.

Testing documents SHALL be placed under `docs/testing/`.

DevOps documents SHALL be placed under `docs/devops/`.

AI platform documents SHALL be placed under `docs/ai-platform/`.

AI agent documents SHALL be placed under `docs/ai-agents/`.

Decision records SHALL be placed under `docs/decisions/`.

Governance records SHALL be placed under `docs/governance-records/`.

Roadmap documents SHALL be placed under `docs/roadmap/`.

Operational documents SHALL be placed under `docs/operations/`.

Research documents SHALL be placed under `docs/research/`.

Reference documents SHALL be placed under `docs/reference/`.

Templates SHALL be placed under `docs/templates/`.

When a document spans multiple domains, it SHALL be placed in the domain of primary ownership.

Secondary relationships SHOULD be handled through cross references.

## 10. Markdown Formatting Standard

Documents SHALL use Markdown.

Documents SHALL be readable as plain text.

Documents SHOULD use one top-level `#` heading.

Documents SHOULD use blank lines between headings, paragraphs, lists, tables, and code blocks.

Documents SHOULD avoid excessive styling.

Documents SHALL NOT rely on rendering features that make the raw Markdown difficult to read.

Lists SHOULD use consistent bullet style within a section.

Numbered lists SHOULD be used when sequence matters.

Unordered lists SHOULD be used when sequence does not matter.

Emphasis SHOULD be used sparingly.

Inline code formatting SHALL be used for file paths, commands, identifiers, and literal values.

## 11. Heading Rules

The first heading SHALL be the document title.

Heading levels SHALL be nested logically.

Documents SHALL NOT skip heading levels without reason.

Headings SHOULD be concise.

Headings SHOULD describe the section content.

Headings SHALL NOT be used only for visual styling.

Section numbering MAY be used for formal governance documents.

If section numbering is used, numbering SHOULD remain consistent throughout the document.

## 12. Table Rules

Tables SHOULD be used for structured comparisons, metadata, matrices, and concise reference material.

Tables SHALL have clear column names.

Tables SHOULD avoid excessive width.

Tables SHOULD remain readable in raw Markdown.

Long tables SHOULD be split into smaller tables when readability suffers.

Tables SHALL NOT be used when a list or paragraph would be clearer.

Mandatory fields in tables SHOULD be explicitly marked when applicable.

## 13. Diagram Rules

Diagrams MAY be used when they improve understanding.

Diagrams SHALL have a clear purpose.

Diagrams SHOULD have nearby explanatory text.

Diagrams SHALL be maintainable.

Diagrams SHOULD avoid undocumented symbols.

### 13.1 Mermaid

Mermaid MAY be used for diagrams that benefit from text-based version control.

Mermaid diagrams SHOULD be placed in fenced code blocks using `mermaid`.

Mermaid diagrams SHOULD remain simple enough to review in source form.

### 13.2 PlantUML

PlantUML MAY be used when richer UML-style diagrams are required.

PlantUML source SHOULD be stored in a reviewable text form.

PlantUML diagrams SHOULD include enough context to be understandable without specialized tribal knowledge.

### 13.3 Draw.io

Draw.io MAY be used for diagrams that require visual editing.

Draw.io source files SHOULD be stored with the documentation when the diagram is part of the repository.

Exported images SHOULD NOT be the only editable source unless an exception is approved.

## 14. Code Block Rules

Code blocks SHALL use fenced code blocks.

Code blocks SHOULD include a language identifier when practical.

Code examples SHALL be accurate for their documented purpose.

Code examples SHOULD be minimal.

Code examples SHALL NOT expose secrets.

Code examples SHALL NOT include production credentials.

Code examples SHOULD distinguish illustrative snippets from executable instructions.

Command examples SHOULD identify assumptions when those assumptions affect correctness.

## 15. Cross Reference Rules

Documents SHOULD reference related documents using relative repository paths where practical.

Cross references SHALL be accurate at the time of publication.

Cross references SHOULD use stable document names.

Documents SHALL NOT rely on vague references such as "the other document" when a direct reference is possible.

When a document depends on another document, that relationship SHALL be declared in metadata.

When a document supersedes another document, the relationship SHALL be explicit.

## 16. Citation Rules

External citations SHOULD be used when referencing external standards, specifications, or authoritative guidance.

Citations SHALL identify the source clearly.

Documents SHOULD avoid unsupported claims when a citation is required.

References to external sources SHOULD be durable where practical.

Internal citations SHOULD use repository paths.

Citations SHALL NOT be used to obscure uncertainty.

## 17. Terminology Rules

Documents SHALL use consistent terminology.

Terms with special meaning SHOULD be defined or linked to a glossary.

Documents SHALL avoid using multiple terms for the same concept unless distinctions are intentional.

Normative terms SHALL be used carefully.

The terms MUST, SHALL, SHOULD, MAY, MUST NOT, and SHALL NOT SHALL be used only when the document intends normative meaning.

Documents SHOULD avoid informal language in approved standards, policies, specifications, and runbooks.

## 18. Glossary Usage

The project glossary SHALL be used for shared terminology.

Documents SHOULD link to glossary entries when terms are specialized or likely to be misunderstood.

New recurring terms SHOULD be added to the glossary or proposed for addition.

Documents SHOULD NOT redefine glossary terms inconsistently.

If a document-specific definition is necessary, it SHALL identify the local scope of that definition.

## 19. Acronym Usage

Acronyms SHOULD be expanded on first use.

Acronyms used across the project SHOULD appear in the acronyms reference.

Documents SHOULD avoid unnecessary acronyms.

Documents SHALL NOT introduce ambiguous acronyms without definition.

If an acronym has multiple meanings, the intended meaning SHALL be clear from context or definition.

## 20. Versioning Rules

Approved documents SHALL include a version.

Draft documents SHOULD include a version when they are expected to become controlled documents.

Version numbers SHOULD follow a consistent major and minor pattern.

Major version changes SHOULD indicate substantive structural or normative change.

Minor version changes SHOULD indicate compatible additions or clarifications.

Editorial changes MAY be recorded through Git history without changing the document version when governance permits.

Version changes SHOULD be accompanied by an update to Last Updated metadata.

Superseded documents SHALL identify the replacing document when known.

## 21. Review Workflow

Documents requiring review SHALL be moved or marked as Review status before approval.

Reviewers SHALL evaluate clarity, correctness, scope, consistency, references, metadata, and placement.

Reviewers SHOULD verify that the document does not conflict with higher-authority documents.

Reviewers SHOULD verify that normative language is appropriate.

Review comments SHOULD be actionable.

Authors SHALL address review feedback or document why it was not accepted.

Review completion SHOULD be evident from metadata, review records, or repository workflow.

## 22. Approval Workflow

Approval SHALL be required for Policy, Standard, Specification, ADR, and other controlled documents.

Approvers SHALL be identified in metadata.

Approvers SHALL confirm that the document is ready for its declared status.

Approval SHALL NOT be implied by silence.

Approved documents SHALL have Approved status.

Approved documents SHOULD NOT contain unresolved placeholders.

Approval evidence SHOULD be retained through repository history or governance records.

## 23. Document Change Policy

Changes to approved documents SHALL preserve history through normal version control.

Material changes SHOULD update Version and Last Updated metadata.

Material changes SHOULD receive review.

Changes SHALL preserve the document classification unless a reclassification is intentional and reviewed.

Changes SHOULD preserve existing cross references or update them.

Minor editorial changes MAY be made with lightweight review when they do not change meaning.

Documents SHALL NOT be changed to silently reverse approved guidance.

## 24. Breaking Documentation Changes

A breaking documentation change is a change that invalidates existing references, changes mandatory guidance, changes classification, removes required content, or alters approved meaning.

Breaking documentation changes SHALL be reviewed.

Breaking documentation changes SHOULD update version metadata.

Breaking documentation changes SHOULD identify migration or reader impact.

Renaming, moving, or superseding approved documents MAY be breaking documentation changes.

Broken cross references caused by breaking changes SHALL be corrected or documented.

## 25. Deprecation Policy

Deprecated documents SHALL use Deprecated status.

Deprecated documents SHOULD identify the reason for deprecation.

Deprecated documents SHOULD identify replacement guidance when available.

Deprecated documents SHOULD remain available until archiving or supersession is approved.

Deprecated documents SHALL NOT be used as active guidance for new work unless an exception is documented.

## 26. Archiving Policy

Archived documents SHALL use Archived status.

Archived documents SHALL be retained for historical reference when they provide governance, audit, decision, release, or operational value.

Archived documents SHOULD identify why they were archived.

Archived documents SHOULD identify replacement or superseding documents when applicable.

Archived documents SHALL NOT be edited except to correct metadata, references, or archival notices unless an exception is approved.

## 27. AI Generated Documents

AI agents MAY create or update engineering documents when authorized.

AI-generated documents SHALL comply with this standard.

AI agents SHALL include mandatory metadata when creating controlled documents.

AI agents SHALL NOT invent approvals.

AI agents SHALL NOT fabricate review evidence.

AI agents SHALL NOT create unsupported citations.

AI agents SHALL distinguish assumptions from known facts.

AI agents SHALL avoid project-specific claims unless grounded in repository context or provided requirements.

AI-generated documents SHALL be reviewed according to the same standards as human-authored documents.

AI agents SHOULD report files created, files modified, assumptions, and verification performed.

## 28. Quality Checklist

Before approval, a controlled document SHOULD satisfy the following checklist.

- The document has the correct title.
- The document has mandatory metadata.
- The document has the correct classification.
- The document has the correct status.
- The document is placed in the correct directory.
- The file name follows this standard.
- The document references the Engineering Manifest when required.
- The document does not conflict with higher-authority documents.
- The document uses consistent terminology.
- Acronyms are expanded or referenced.
- Tables are readable.
- Diagrams are purposeful and maintainable.
- Code blocks are accurate and safe.
- Cross references are valid.
- External citations are clear when used.
- Normative language is intentional.
- Reviewers are identified where required.
- Approvers are identified where required.
- Placeholders are removed or justified.
- The document lifecycle status is accurate.

## 29. Common Anti-Patterns

Documents SHALL avoid unclear ownership.

Documents SHALL avoid missing metadata.

Documents SHALL avoid vague status values.

Documents SHALL avoid numeric directory prefixes.

Documents SHALL avoid duplicated guidance without references.

Documents SHALL avoid obsolete links.

Documents SHALL avoid unexplained acronyms.

Documents SHALL avoid unsupported external claims.

Documents SHALL avoid excessive implementation detail when the document is a standard or policy.

Documents SHALL avoid hidden policy statements inside guides or meeting notes.

Documents SHALL avoid images without editable sources when the image represents governed content.

Documents SHALL avoid code examples containing secrets or credentials.

Documents SHALL avoid using approval language without actual approval.

Documents SHALL avoid mixing active guidance and historical notes without clear status.

## 30. References

RFC 2119: Key words for use in RFCs to Indicate Requirement Levels.

`docs/governance/ENGINEERING_MANIFEST.md`: Higher-authority engineering governance document.

`docs/reference/glossary.md`: Project glossary reference.

`docs/reference/acronyms.md`: Project acronym reference.

`docs/reference/document-index.md`: Project document index reference.
