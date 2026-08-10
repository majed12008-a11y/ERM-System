# Domain Model — Constitutional Aggregate Model

| Field | Value |
|---|---|
| Status | APPROVED — constitutional amendment (Phase 1 deliverable of the transition plan) |
| Date | 2026-08-07 |
| Author | Enterprise Architecture (ADR board) |
| Authority | `architecture-transition-plan.md` Phase 1 (DOMAIN_MODEL amendment); ADR-002 §3 P3, P6; §4 C5; §5 I5, I10; ADR-001 §2.4 (terminology policy); `architecture-baseline-v2-index.md` §2 item 5; `architecture-governance-freeze.md`. |
| Constraints honored | READ-ONLY. Documentation only. No code, no SQL, no schema design, no DDD implementation, no commits. |
| Purpose | Establish the authoritative **Aggregate** model — the constitutional semantic layer for every future Registry, Rule, Constraint, Verification, Evidence, and Dataset. This is the aggregate amendment required by ADR-002 (P3/I5/C5) and the last conceptual prerequisite before engineering implementation. |
| Supersedes | The aggregate-absent framing of `docs/domain/DOMAIN_MODEL.md` with respect to ownership and invariants. The business language, entities, and bounded contexts of that document remain authoritative; this document adds the **Aggregate** and **Aggregate Root** concepts (glossary T14, T15) and the single-ownership table mapping. |
| Relationship to baseline | Amends Baseline v2 constitutional item 5 ("DOMAIN_MODEL with aggregate/aggregate-root concepts — to be amended, Phase 1"). Satisfies exit criterion EC3 (grep for Aggregate, Aggregate Root, Application/Condition roots). |
| Companions | `aggregate-table-mapping.csv` (Section 4, 234 tables), `aggregate-feature-mapping.csv` (Section 5, features / API modules / registries R1–R11). |

---

## Section 1 — Business Aggregates

An **Aggregate** is the authoritative invariant model of ADR-002 (glossary T14): the single home where aggregate-level business invariants are expressible (P3, I5). An **Aggregate Root** is the entity through which the aggregate's invariants are stated and its identity is defined (P6, I10). Aggregate Roots are named for **Application** and **Condition** (glossary T15) and for the other business entities below.

**Tiers.** Aggregates are classed into four tiers that map to the bounded contexts and sub-domain tiers of the business model (`docs/domain/DOMAIN_MODEL.md` §5–§8): **Core** (governance), **Document & Evidence**, **Supporting**, **Infrastructure**.

| # | Aggregate | Tier | Purpose | Owner (enforcement domain D1–D8) | Root Entity | Responsibility | Boundary |
|---|---|---|---|---|---|---|---|
| A01 | Application | Core | The central ethics-governance work item; carries research information through review, decision, condition, approval, closure, archive. | Research Ethics Governance (D1 co-owner; evidence D3) | Application | RULE 11 terminal-state derivation; submission integrity; version immutability; consent linkage | Starts at application preparation; ends at terminal state (REJECTED/WITHDRAWN/ARCHIVED) or handoff to Research Lifecycle |
| A02 | Condition | Core | A requirement issued under a governance decision; its resolution and evidence. | Research Ethics Governance | ApplicationCondition | RULE 12 evidence-DELETE four-factor matrix; condition lifecycle (OPEN/MET/NOT_MET/WAIVED) | Condition issuance → resolution, waiver, or supersession |
| A03 | ResearchProject | Core | The real-world research activity being governed. | Research Governance Authority | Project | Research metadata integrity; site/team/funding coherence | Project proposal → active → closed/archived |
| A04 | Committee | Core | The authorized governance body and its membership. | Research Ethics Committee | Committee | Member term validity; conflict disclosure; committee type authority | Committee constitution → review → renewal/retirement |
| A05 | Meeting | Core | Committee deliberation and voting. | Research Ethics Committee | CommitteeMeeting | Quorum before decision; votes recorded; minutes retained | Meeting call → quorum → decision record |
| A06 | Review | Core | Reviewer assessment of submitted material. | Research Ethics Committee | ReviewAssignment | Reviewer SHALL have an assignment before an outcome; conflict disclosure; score/answer traceability | Assignment → review completion → contribution to decision |
| A07 | Approval | Core | Authorized permission and its formal certificate. | Research Ethics Governance | ApprovalCertificate | Approval SHALL derive from an authorized decision; certificate validity | Approval granted → closed/withdrawn/superseded/archived |
| A08 | Accreditation | Supporting | Institutional/committee maturity and readiness. | Research Governance Authority | AccreditationAssessment | Assessment → decision → conditions/evidence linkage; standard versioning | Accreditation cycle → assessment → decision → conditions |
| A09 | Document | Core | The polymorphic document/evidence store with lifecycle. | Document Handling (D3 evidence owner) | Document | Lifecycle state mandatory; soft-delete; physical DELETE blocked; retention rules; RULE 12 evidence residence | Document creation → version → lifecycle → disposal/archive |
| A10 | E-Signature | Supporting | Digital signing of documents and certificates. | Document Handling | DigitalCertificate | Signature validity; revocation; signature-type registry | Certificate issuance → signature → revocation |
| A11 | Reference | Supporting | Controlled terminology, catalogs, and knowledge content. | Reference Knowledge / Documentation Stewardship | ReferenceCatalog | Term-gate support (G4); reference data idempotency (Reference Dataset) | Vocabulary and catalog lifecycle |
| A12 | Template | Supporting (DEAD) | The forms-library / document template engine. | Document Handling | Template | **P9/I8:** zero consumers — flagged for explicit deprecation/retirement, never silently retained | Template library → render jobs (currently unused) |
| A13 | Communication | Supporting | Notifications, messages, announcements. | Communication Management | Message | Delivery/read state; recipient routing; preference respect | Notification/message dispatch → delivery → read |
| A14 | Safety | Supporting | Adverse events, ethics risk, and safety oversight. | Safety Governance | SafetyReport | Adverse-event reporting; ethics-risk assessment linkage; mitigation traceability | Incident → assessment → report → follow-up |
| A15 | Monitoring | Supporting | Institutional monitoring, inspection, compliance. | Oversight | MonitoringPlan | Inspection → finding → corrective action linkage | Monitoring plan → visit → findings → follow-up |
| A16 | Form | Supporting | The schema-driven form runtime (engine). | Form Runtime (glossary T17) | FormDefinition | Schema validity; instance integrity | Form definition → instance submission |
| A17 | Institution | Supporting | Institution and department structure. | Institution Administration | Institution | Org-structure integrity; department membership | Institution setup → department → retirement |
| A18 | Identity | Supporting (declared shared kernel) | Users, authentication, sessions, profiles. | Identity & Access (P2 shared kernel) | User | Single ownership of identity; session lifecycle; credential handling; never bypassed (I11) | Identity creation → authentication → retirement |
| A19 | AccessControl | Supporting | Roles, permissions, policy, delegation, segregation. | Identity & Access | Role | Role-permission coherence; segregation rules; approval limits | Policy definition → grant → revocation |
| A20 | Workflow | Infrastructure | The workflow state machine; RULE 11 reachability source. | Workflow Runtime | Workflow | State reachability (RULE 11 derivation); no orphan transitions; instance runtime | Workflow definition → instance → terminal state |
| A21 | Integration | Infrastructure | External system connectivity and event plumbing. | Integration Runtime | ExternalSystem | Credential handling; outbox delivery; retry/backoff | Integration config → event exchange |
| A22 | Reporting | Infrastructure | Derived analytics, KPIs, dashboards. | Reporting | ReportDefinition | Derived-data lifecycle; execution recording | Definition → execution → snapshot |
| A23 | SystemConfiguration | Infrastructure | System config, feature flags, runtime rules, search, admin ops. | Platform Operations | SystemConfig | Config governance; runtime rule engine distinct from constitutional RULE_* framework | Config change → effect → audit |
| A24 | Audit | Infrastructure | Immutable audit trail and integrity ledger. | Audit | AuditLog | Append-only immutability; hash ledger integrity; never seeded (I11) | Event → audit record → integrity check |
| A25 | Execution | Infrastructure (historical) | Installer History and execution bookkeeping. | Engineering/DevOps Governance (D8) | ExecutionRecord | Tracker provenance untrusted (P7/A1); historical record, never the dataset (P1/I1) | Installer event → record → retention |

**Tier totals:** Core 7 (A01–A07, A09), Document & Evidence 2 (A09, A10), Supporting 9 (A08, A11–A19), Infrastructure 6 (A20–A25). Note A09 Document is classed Core because evidence handling is a core business concern (ADR-002 C5 names documents among the central four).

---

## Section 2 — Aggregate Anatomy

For every aggregate: **Entities**, **Value Objects**, **Policies**, **Events**, and **External references**. No implementation is described. Value objects and reference data derive from the controlled vocabularies of the Reference aggregate and the glossary final vocabulary.

### A01 Application (root: Application)
- **Entities:** Application, ApplicationVersion, ApplicationHistory, ApplicationAmendment, AmendmentRequest, RenewalRequest, ClosureRequest, ApplicationChecklist, ApplicationSection, ApplicationValidation, ApplicationConsent.
- **Value Objects:** ApplicationNumber (governance identifier, via document numbering), ApplicationStatus (workflow-derived), SubmissionCompleteness, PrincipalInvestigatorReference, ReviewReadiness.
- **Policies:** Application Submission Policy (who may submit, completeness); Screening Policy; Application Version Policy (versions immutable); RULE 11 (terminal states REJECTED/WITHDRAWN/ARCHIVED derived from workflow reachability, never from status naming); Approval Validity reference.
- **Events:** Application Prepared, Application Submitted, Application Screened, Application Returned, Application Under Review, Committee Decision Issued, Application Withdrawn, Application Archived.
- **External references:** ResearchProject (research activity), User (submitted_by/applicant), Workflow instance (state holder), Condition (issued conditions), Approval (certificate), Document (evidence, entity polymorphic), Committee (deciding body).

### A02 Condition (root: ApplicationCondition)
- **Entities:** ApplicationCondition.
- **Value Objects:** ConditionStatus (OPEN/MET/NOT_MET/WAIVED), ConditionType, ConditionNumber, ResolutionRationale.
- **Policies:** Condition Management Policy; Evidence Sufficiency Policy; **RULE 12** evidence-DELETE four-factor matrix (application ownership, condition linkage, workflow state, user role — invariants across A01, A02, A09, A18); no DELETE after terminal state (audit trail integrity).
- **Events:** Condition Issued, Condition Awaiting Evidence, Condition Under Review, Condition Resolved, Condition Waived, Condition Superseded.
- **External references:** Application (parent), Document (evidence, via entity_type), User (responder), Workflow state (application current_status), Review (evidence assessment).

### A03 ResearchProject (root: Project)
- **Entities:** Project, ProjectVersion, ProjectTeamMember, ProjectSite, ProjectSiteInvestigator, ProjectFundingSource, ProjectKeyword, ProjectTag, ProjectAttachment, ProjectStatusHistory.
- **Value Objects:** ProjectStatus, ResearchCategory, RiskClassification, VulnerablePopulation, FundingAmount, SiteLocation.
- **Policies:** Project Integrity Policy; Team Accountability Policy (PI accountable); Site Authorization Policy.
- **Events:** Project Proposed, Project Approved, Project Amended, Project Completed, Project Closed, Project Archived.
- **External references:** Application (governance request), User (PI/team), Institution (host), Document (attachments/evidence).

### A04 Committee (root: Committee)
- **Entities:** Committee, CommitteeType, CommitteeMember, CommitteeMemberRole, CommitteeRole, MemberTerm, MemberQualification, MemberConflict.
- **Value Objects:** CommitteeType (from committee_types), MemberTermPeriod, QualificationProfile, ConflictDeclaration.
- **Policies:** Committee Constitution Policy; Member Term Policy (term validity); Conflict-of-Interest Disclosure Policy; Chair Accountability Policy.
- **Events:** Committee Constituted, Member Appointed, Member Term Expired, Member Suspended, Committee Renewed, Committee Retired.
- **External references:** Institution (host), User (members), Meeting (sessions), Review (assignments), v_chair_id view (chair resolution).

### A05 Meeting (root: CommitteeMeeting)
- **Entities:** CommitteeMeeting, MeetingAgenda, AgendaItem, AttendanceLog, QuorumLog, VotingSession, Vote, MeetingMinute.
- **Value Objects:** QuorumState, VoteOutcome, MeetingStatus, DecisionOutcome.
- **Policies:** Quorum Policy (decision requires quorum); Voting Policy; Minutes Retention Policy; Committee Decision Policy (attributable to an authorized committee).
- **Events:** Meeting Called, Quorum Reached, Vote Cast, Decision Recorded, Minutes Approved.
- **External references:** Committee (owner), Review (outcomes considered), Application (items), User (attendees), Approval/Decision outcome (recorded).

### A06 Review (root: ReviewAssignment)
- **Entities:** ReviewAssignment, EthicsReview, ScientificReview, ReviewForm, ReviewQuestion, ReviewAnswer, ReviewScore, ReviewComment, ReviewRecommendation, ReviewConflict, ConsentReviewComment.
- **Value Objects:** ReviewRecommendation, ReviewScoreValue, ReviewStatus (from review_statuses), ConflictFlag, ReviewDeadline.
- **Policies:** Reviewer Assignment Policy (an outcome SHALL have an explicit assignment); Conflict Disclosure Policy; Review Deadline Policy; Evidence Sufficiency Policy (contribution).
- **Events:** Review Assigned, Review Completed, Review Reassigned, Review Withdrawn, Recommendation Submitted.
- **External references:** User (reviewer), Application (subject), Committee (body), Condition (evidence assessed), Consent templates (consent review input).

### A07 Approval (root: ApprovalCertificate)
- **Entities:** ApprovalCertificate, ApprovalCertificateDocument, CertificateVerificationLog.
- **Value Objects:** ApprovalValidity, DecisionOutcome, CertificateNumber, VerificationResult.
- **Policies:** Approval Policy (approval SHALL derive from an authorized decision); Certificate Policy (certificate reflects a valid decision); Public Verification Policy (verification log records attempts).
- **Events:** Approval Granted, Certificate Issued, Certificate Verified, Approval Closed, Approval Superseded, Approval Archived.
- **External references:** Application (approved subject), Committee (issuing body), Document (certificate documents, generated output), Condition (terms attached).

### A08 Accreditation (root: AccreditationAssessment)
- **Entities:** AccreditationAssessment, AccreditationCycle, AccreditationStandard, AccreditationStandardVersion, AccreditationAssessmentItem, AccreditationDecision, AccreditationCondition, AccreditationEvidence, AccreditationCycleMetric.
- **Value Objects:** StandardVersion, AssessmentScore, CycleStatus, AccreditationOutcome.
- **Policies:** Standard Versioning Policy; Assessment → Decision Policy; Conditions/Evidence Linkage Policy.
- **Events:** Cycle Started, Assessment Completed, Decision Issued, Condition Issued, Evidence Submitted.
- **External references:** Institution (accredited body), Committee (assessed), Reference (standards vocabulary).

### A09 Document (root: Document)
- **Entities:** Document, DocumentVersion, DocumentAccess, DocumentApproval, DocumentAudit, DocumentClassification, DocumentDisposalLog, DocumentLifecycleState, DocumentLifecycleTransition, DocumentNumbering, DocumentRetentionRule, DocumentType, DocumentWatermarkConfig, DocumentVerificationLog.
- **Value Objects:** DocumentStatus (from document_statuses), LifecycleState, RetentionPeriod, Classification, WatermarkSpec.
- **Policies:** Document Lifecycle Policy (lifecycle state mandatory — `documents.lifecycle_state_id` NOT NULL); Soft-Delete Policy (`deleted_at`/`deleted_by`); Physical-DELETE-Forbidden Policy (`FOR DELETE USING (false)`); Retention/Disposal Policy; **RULE 12** evidence residence for condition evidence.
- **Events:** Document Created, Document Versioned, Document Submitted as Evidence, Document Approved, Document Disposed, Document Archived.
- **External references:** Application/Condition/Certificate (via polymorphic entity_type), User (uploaded_by), Document type, E-Signature (signature), Template (render output).

### A10 E-Signature (root: DigitalCertificate)
- **Entities:** DigitalCertificate, CertificateRevocation, DocumentSignature, DocumentSignatureType.
- **Value Objects:** SignatureStatus, CertificateValidity, RevocationReason.
- **Policies:** Signature Validity Policy; Revocation Policy; Signature-Type Registry Policy.
- **Events:** Certificate Issued, Document Signed, Certificate Revoked, Signature Verified.
- **External references:** User (signatory), Document (signed document), Institution (issuing authority).

### A11 Reference (root: ReferenceCatalog)
- **Entities:** LookupCategory, LookupValue, AcademicTitle, ApplicationStatus, CommitteeDecisionType, DocumentStatus, InstitutionRegistryEntry, LicenseRegistryEntry, ProfessionRegistryEntry, NotificationStatus, PriorityLevel, ReviewStatus, RiskLevel, StatusType, VoteType, WorkflowStatus, ConsentTemplate, ConsentTemplateVersion.
- **Value Objects:** LookupKey, StatusCode, RegistryCode.
- **Policies:** Term-Gate Policy (G4 — vocabulary must be registered); Reference Data Idempotency (Reference Dataset class); Catalog Stewardship Policy.
- **Events:** Term Registered, Catalog Versioned, Term Deprecated, Term Retired.
- **External references:** All aggregates (vocabulary consumed externally; single ownership here).

### A12 Template (root: Template)
- **Entities:** Template, TemplateVersion, Category, EventTemplateMapping, TemplateApprovalWorkflow, TemplateLocalization, TemplateOutput, TemplatePackage, TemplatePackageMember, TemplatePartial, TemplateRenderHistory, TemplateRenderJob, TemplateUsageStatistic, TemplateValidationTest, TemplateVariable, TemplateVersionAudit, plus documents.templates and documents.generated_documents.
- **Value Objects:** TemplateKind, OutputFormat, RenderStatus.
- **Policies:** **P9/I8 Dead-Data Policy** — `templates.*` has zero consumers; the aggregate is registered but flagged for explicit deprecation/retirement in the dataset transition, never silently retained in canonical counts.
- **Events:** (none active — feature absent; render events pending retirement decision).
- **External references:** Document (rendered output), Form (forms-library overlap).

### A13 Communication (root: Message)
- **Entities:** Message, MessageRecipient, MessageAttachment, Notification, NotificationLog, NotificationChannel, NotificationTemplate, UserNotificationPreference, Announcement.
- **Value Objects:** DeliveryState, ReadState, NotificationStatus (from notification_statuses), ChannelType.
- **Policies:** Delivery Policy; Recipient Routing Policy; Preference Respect Policy; Message Retention Policy.
- **Events:** Notification Dispatched, Message Delivered, Message Read, Announcement Published.
- **External references:** User (recipient/sender), Application (subject context), Reference (statuses), Integration (channels).

### A14 Safety (root: SafetyReport)
- **Entities:** SafetyReport, AdverseEvent, SeriousAdverseEvent, RiskIncident, RiskAssessment, RiskCategory, RiskRegister, RiskMitigation, MitigationAction, CorrectiveAction, SafetyCommitteeReview, SafetyFollowup, EthicsRiskAssessment, EthicsRiskItem.
- **Value Objects:** RiskLevel (from safety.risk_categories), SeverityGrade, IncidentStatus, MitigationStatus.
- **Policies:** Adverse Event Reporting Policy; Ethics Risk Assessment Policy; Risk Register Policy; Mitigation Traceability Policy.
- **Events:** Incident Reported, Risk Assessed, Mitigation Required, Follow-up Completed, Report Closed.
- **External references:** Application (affected research), Condition (related terms), Reference (risk levels), Committee (safety review).

### A15 Monitoring (root: MonitoringPlan)
- **Entities:** MonitoringPlan, MonitoringVisit, Inspection, InspectionReport, MonitoringFinding, ComplianceReview, Deviation, ProtocolViolation, CorrectiveAction, PreventiveAction.
- **Value Objects:** FindingSeverity, VisitStatus, ComplianceStatus.
- **Policies:** Inspection → Finding → Corrective Action Policy; Deviation Escalation Policy; Compliance Review Policy.
- **Events:** Plan Approved, Visit Scheduled, Finding Raised, Corrective Action Required, Review Closed.
- **External references:** Application (monitored subject), Institution (monitored body), User (inspectors).

### A16 Form (root: FormDefinition)
- **Entities:** FormDefinition, FormInstance.
- **Value Objects:** SchemaVersion, InstanceStatus.
- **Policies:** Schema Validity Policy; Instance Integrity Policy (runtime-generated — never seeded, I11).
- **Events:** Form Defined, Form Versioned, Form Submitted.
- **External references:** Application (form-driven intake — sections/validations), User (submitter).

### A17 Institution (root: Institution)
- **Entities:** Institution, InstitutionType, Department, plus v_inst_codes view.
- **Value Objects:** InstitutionCode, DepartmentName.
- **Policies:** Org-Structure Policy; Department Membership Policy.
- **Events:** Institution Onboarded, Department Created, Institution Retired.
- **External references:** User (affiliation), Committee (host), Reference (institutions_registry — enrollment-gated), License registry (licensing).

### A18 Identity (root: User) — declared shared kernel (P2)
- **Entities:** User, UserProfile, UserRole, UserResponsibility, Session, LoginAudit, ApiKey, EmailVerificationToken, PasswordResetToken, PasswordHistory, plus v_user_id view.
- **Value Objects:** CredentialStatus, SessionToken, VerificationState.
- **Policies:** Identity Single-Ownership Policy (P2/I4 — the shared kernel is declared, all 66 FK references are external); Credential Policy (password history, reset tokens); Session Policy; RLS registration policy (I11 — registration must never bypass RLS; the current SECURITY DEFINER workaround is an unrecorded exception, deferred).
- **Events:** User Registered, Login Succeeded, Login Failed, Session Expired, Password Changed, User Retired.
- **External references:** Every aggregate that stores `created_by`/`submitted_by`/`uploaded_by` (external reference, never ownership).

### A19 AccessControl (root: Role)
- **Entities:** Role, Permission, RolePermission, RoleDelegation, AccessPolicy, PolicyRule, PolicyCondition, ResponsibilityType, SegregationRule, SecurityEvent, ApprovalAuthority, ApprovalLimit.
- **Value Objects:** RoleKey, PermissionKey, PolicyConditionExpression, SegregationConstraint.
- **Policies:** Role-Permission Coherence Policy; Segregation of Duties Policy; Approval Authority/Limit Policy; Delegation Policy.
- **Events:** Role Granted, Permission Revoked, Delegation Active, Policy Enforced, Security Event Raised.
- **External references:** User (grantee), Institution (scope), Application (approval limits).

### A20 Workflow (root: Workflow)
- **Entities:** Workflow, WorkflowState, WorkflowTransition, WorkflowInstance, WorkflowAction, WorkflowTask, WorkflowEvent, WorkflowHistory, WorkflowComment, WorkflowEscalation, WorkflowScheduler, WorkflowTrigger, WorkflowVariable, WorkflowSla.
- **Value Objects:** WorkflowStatus (from workflow_statuses), StateCode, TransitionGuard.
- **Policies:** Reachability Policy (RULE 11 — terminal-state derivation source); No-Orphan-Transition Policy; Instance Lifecycle Policy (runtime-generated, never seeded, I11); SLA Policy.
- **Events:** Workflow Instance Started, State Entered, Transition Fired, Task Created, Escalation Raised, Instance Terminated.
- **External references:** Application (instance subject), all stateful aggregates (state holder).

### A21 Integration (root: ExternalSystem)
- **Entities:** ExternalSystem, Webhook, IntegrationCredential, DataSyncJob, EventSubscription, EventBusConfig, EventOutbox, IntegrationFailure, IntegrationLog, RetryQueue.
- **Value Objects:** CredentialRef, DeliveryState, RetryState.
- **Policies:** Credential Handling Policy; Outbox Delivery Policy (I11 runtime data class); Retry/Backoff Policy; Webhook Security Policy.
- **Events:** Event Published, Event Delivered, Sync Job Completed, Failure Recorded, Retry Enqueued.
- **External references:** User (integrator identity), Communication (channel), Reference (config).

### A22 Reporting (root: ReportDefinition)
- **Entities:** ReportDefinition, ReportExecution, AnalyticsSnapshot, KpiResult, DashboardWidget.
- **Value Objects:** KpiDefinition, SnapshotPeriod, ExecutionStatus.
- **Policies:** Derived-Data Policy (snapshots/KPIs are derived at runtime — never seeded); Execution Recording Policy.
- **Events:** Report Executed, Snapshot Built, Kpi Computed.
- **External references:** Application/Committee/Institution (report subjects), Audit (data provenance).

### A23 SystemConfiguration (root: SystemConfig)
- **Entities:** SystemConfig, FeatureFlag, BusinessRule, RuleAction, RuleCondition, RuleExecution, RuleVersion, EmailConfig, SmsConfig, PushConfig, AuditConfig, AuditLog, SavedSearch, SearchAudit, SearchIndex, MaintenanceLog.
- **Value Objects:** ConfigKey, FlagState, RuleExpression.
- **Policies:** Config Governance Policy; Runtime-Rule Engine Distinction Policy (the runtime `business_rules`/`rule_*` tables are a platform mechanism, distinct from the constitutional RULE_* governance framework); Saved-Search Retention Policy; Admin Operations (backup) Policy.
- **Events:** Config Changed, Flag Flipped, Rule Executed, Backup Completed.
- **External references:** All aggregates (config consumed), Audit (config change audit), Execution (backup provenance).

### A24 Audit (root: AuditLog)
- **Entities:** AuditLog, AuditDetail, EntityChange, HashLedger.
- **Value Objects:** AuditEventType, IntegrityHash.
- **Policies:** Append-Only Immutability Policy; Integrity Ledger Policy (hash_ledger); Never-Seeded Policy (I11 runtime data class).
- **Events:** Audit Record Written, Integrity Checked.
- **External references:** All aggregates (audited data), SystemConfiguration (audit_config).

### A25 Execution (root: ExecutionRecord)
- **Entities:** SeedTracker, Pgmigration, PerfResult.
- **Value Objects:** ExecutionProvenance, Checksum, AppliedAt.
- **Policies:** Installer-History Policy (P1/I1 — the seed suite is a historical record, never the dataset); Provenance-Trust Policy (P7/A1 — tracker state is untrusted until provenance is rebuilt, not migrated); Migration Bookkeeping Policy.
- **Events:** Installer Step Recorded, Migration Recorded, Restore Detected.
- **External references:** All dataset construction artifacts (this aggregate records their execution), Audit.

---

## Section 3 — Ownership Rules

1. **Single ownership.** Every business entity and every table belongs to **exactly one aggregate** (P2, I4). No table appears in more than one aggregate. `aggregate-table-mapping.csv` is the ownership declaration; the R10 Ownership Registry content derives from it.
2. **No shared ownership.** There are no two-owner entities. Where the business model previously assigned dual ownership (e.g., ReviewAssignment "Ethics Administrator and Research Ethics Committee"; Evidence "Submitting Party or Governance Authority"), the aggregate owns the entity and the second party holds only an **external reference** or an **approval authority** (A19). This is the P2 single-ownership resolution.
3. **Shared kernels are declared, not defaulted.** `security.users` (66-table FK fan-out) is a **declared shared kernel** owned by the **Identity** aggregate (A18). Every other aggregate that stores `created_by`/`submitted_by`/`uploaded_by` holds an external reference to Identity; it does not own the user. This satisfies P2/I4 (a datum has exactly one owner; references are not ownership).
4. **Cross-aggregate relationships are external references, not ownership.** Cross-aggregate links (e.g., Condition → Application; Document → Condition evidence; Approval → Application) are stated as external references. They carry no ownership; they are the substrate of cross-aggregate invariants (notably RULE 12), which are verified by reading across boundaries (D4 verification), never by moving ownership.
5. **Schema is not ownership.** A table's physical schema is a storage location, not an ownership claim. Examples: `committee.application_conditions` is owned by the Condition aggregate (A02); `committee.accreditation_*`, `committee.ethics_risk_*`, `committee.consent_*` are owned by A08/A14/A11 respectively; `documents.templates`/`documents.generated_documents` are owned by the Template aggregate (A12). Schema/ownership divergence is recorded as a violation in Section 6 for normalization.
6. **The execution mechanism owns nothing.** No datum is owned by the mechanism that produced it (I4). Runtime-produced rows (sessions, audit, outbox, workflow instances, notifications, form instances, report snapshots) belong to their owning aggregate's runtime data class (I11), not to the Execution aggregate. The Execution aggregate (A25) owns only the Installer History and migration bookkeeping.

---

## Section 4 — 234-Table Mapping

Every table in the system inventory (`database-table-inventory.csv`, 234 tables) is assigned to exactly one aggregate. Full mapping: `aggregate-table-mapping.csv` (columns Aggregate, Schema, Table, Ownership, Classification).

**Aggregate table counts (Σ = 234):**

| Aggregate | Tables | Aggregate | Tables | Aggregate | Tables |
|---|---|---|---|---|---|
| A01 Application | 11 | A10 E-Signature | 4 | A18 Identity | 11 |
| A02 Condition | 1 | A11 Reference | 18 | A19 AccessControl | 12 |
| A03 ResearchProject | 14 | A12 Template | 18 | A20 Workflow | 14 |
| A04 Committee | 9 | A13 Communication | 9 | A21 Integration | 10 |
| A05 Meeting | 8 | A14 Safety | 14 | A22 Reporting | 5 |
| A06 Review | 11 | A15 Monitoring | 10 | A23 SystemConfiguration | 16 |
| A07 Approval | 3 | A16 Form | 2 | A24 Audit | 4 |
| A08 Accreditation | 9 | A17 Institution | 4 | A25 Execution | 3 |
| A09 Document | 14 | | | **Total** | **234** |

**No table remains unassigned.** Per-schema coverage: audit 4, committee 41, communication 9, core 25, documents 21, forms 2, integration 10, monitoring 10, ops 1, public 5, reference 16, reporting 5, safety 12, security 27, system 16, templates 16, workflow 14 — all mapped, none shared.

**Natural keys (P6/I10).** Each aggregate root declares a business identity: Application → ApplicationNumber; Condition → (Application, ConditionNumber); Project → ProjectReference; Committee → (Institution, CommitteeCode); ReviewAssignment → (Application, Reviewer); ApprovalCertificate → CertificateNumber; Document → (EntityType, EntityId, DocumentNumber); User → Username/Email; Role → RoleKey; Reference → LookupKey; Institution → InstitutionCode; Workflow → WorkflowKey. These are the identity basis for idempotency and dataset reconciliation.

---

## Section 5 — Feature, API Module, and Registry Mapping

### 5.1 Features → aggregates

Full mapping: `aggregate-feature-mapping.csv`. Summary (28 features):

| Feature | Aggregates |
|---|---|
| Authentication & Registration | A18 Identity |
| Password Recovery | A18 Identity |
| User / Role / Permission Management | A18 Identity, A19 AccessControl |
| Institutions & Reference Data | A11 Reference, A17 Institution |
| Applications | A01 Application |
| Projects | A03 ResearchProject |
| Conditions & Evidence | A02 Condition, A09 Document |
| Certificates & Public Verification | A07 Approval, A09 Document |
| Document Management & Lifecycle | A09 Document |
| E-Signatures | A10 E-Signature |
| Committee Management | A04 Committee |
| Committee Meetings | A05 Meeting |
| Committee Reviews | A06 Review |
| Informed Consent | A01 Application, A11 Reference, A06 Review |
| Ethics Risk Assessment | A14 Safety |
| Accreditation | A08 Accreditation |
| Safety | A14 Safety |
| Monitoring & Compliance | A15 Monitoring |
| Workflow Engine | A20 Workflow |
| Communication | A13 Communication |
| Dynamic Forms | A16 Form |
| Templates Engine (forms library) | A12 Template |
| Reporting & Dashboards | A22 Reporting |
| System Configuration | A23 SystemConfiguration |
| Audit & Data Integrity | A24 Audit |
| Integration | A21 Integration |
| Saved Searches | A23 SystemConfiguration |
| Admin Operations (backup) | A23 SystemConfiguration, A25 Execution |

### 5.2 API modules → aggregates

| API module (backend) | Aggregates |
|---|---|
| admin | A23 SystemConfiguration, A25 Execution |
| committee | A04 Committee, A05 Meeting, A06 Review, A08 Accreditation |
| communication | A13 Communication |
| core | A01 Application, A03 ResearchProject, A02 Condition |
| documents | A09 Document, A07 Approval, A10 E-Signature, A12 Template |
| forms | A16 Form |
| integration | A21 Integration |
| monitoring | A15 Monitoring |
| public | A07 Approval (public verification) |
| reference | A11 Reference, A17 Institution |
| reporting | A22 Reporting |
| safety | A14 Safety |
| security | A18 Identity, A19 AccessControl, A10 E-Signature, A17 Institution |
| system | A23 SystemConfiguration |
| workflow | A20 Workflow |

### 5.3 Registries (R1–R11) → aggregates

| Registry | Ownership domain | Relationship to aggregates |
|---|---|---|
| R1 Rule Registry | D1 | Sources rules **from aggregates**: each aggregate's Policies (Section 2) feed the Rule Registry; primary sources A01, A02, A09, A20 (RULE 11/12). |
| R2 Constraint Registry | D2 | Constraint per aggregate invariant; first constraints from A01 (RULE 11), A02 (RULE 12), A09 (lifecycle), A20 (reachability). |
| R3 Evidence Registry | D3 | The **aggregate model itself** (this document), the business dependency graph, and natural-key sets are registered evidence for P3/P6/I5/I10. |
| R4 Verification Registry | D4 | EC3 (DOMAIN_MODEL grep) verifies this document; P3/I5 verification targets the aggregate model as evidence. |
| R5 Gate Registry | D5 | Dataset construction acceptance gates consume the aggregate mapping (what construction must produce, per aggregate root natural keys). |
| R6 Decision Registry | D6 | Records this constitutional amendment as a Decision (ADR series). |
| R7 Execution Registry | D8 | Dataset construction ordered by the **aggregate dependency graph** (P4/I6); each aggregate root's natural keys are construction targets (P6/I10). |
| R8 Architecture State Registry | D7 | Governs constitutional objects (this document's own state), not business aggregates. |
| R9 Exception Registry | D6 | Unrelated to aggregates except the A18 note (I11 SECURITY DEFINER workaround remains an unrecorded exception — deferred). |
| R10 Ownership Registry | D3 | **Content = Section 4 mapping**: every table → exactly one aggregate/owner. This document is the ownership declaration. |
| R11 Vocabulary Registry | D1 | Glossary final vocabulary; this document uses only registered terms. |

---

## Section 6 — Violations Identified

| # | Type | Finding | Status |
|---|---|---|---|
| V1 | Shared ownership | `security.users` FK fan-out (66 references) — a system-wide shared anchor. | **Resolved by declaration**: Identity aggregate (A18) declared shared kernel with single ownership (P2/I4). References are external; no two owners. |
| V2 | Boundary leakage (schema vs ownership) | `committee.application_conditions` (A02), `committee.accreditation_*` (A08), `committee.ethics_risk_*` (A14), `committee.consent_*` (A11), `documents.templates`/`generated_documents` (A12) physically reside in schemas owned by other domains. | Ownership is correct and unique; physical schema must be normalized to match (dataset transition Phase 4 work). |
| V3 | Boundary leakage (duplicate concepts) | `system.audit_log` vs `audit.audit_logs`; `safety.corrective_actions` vs `monitoring.corrective_actions` vs `safety.mitigation_actions`; three risk vocabularies (`core.risk_classifications`, `safety.risk_categories`, `reference.risk_levels`). | Duplicate-concept ownership ambiguity; each is single-owned here but the naming collision must be reconciled (Phase 4 normalization / terminology). |
| V4 | Aggregate reference cycle | A01 → A02 → A09 → (A01/A02 via polymorphic entity_type): Application → Condition → Document → Application. RULE 12 crosses A01, A02, A09, A18. | **No ownership cycle** (every table single-owned). The cycle is a reference cycle; it requires verification-across-boundaries and eventual-consistency discipline, never ownership changes. |
| V5 | Incorrect-ownership risk | `system.business_rules` + `rule_*` are a runtime rule-execution mechanism, easily conflated with the constitutional RULE_* governance framework (RULE 11/12 source). | Assigned to A23 SystemConfiguration; the distinction is declared in A23 Policy. |
| V6 | Missing aggregate → dead data | `templates.*` (16 tables) plus `documents.templates`/`generated_documents` have zero consumers (P9/I8). | Registered as the **Template aggregate (A12)** with Dead-Data status; must be explicitly deprecated/retired, never silently retained. |
| V7 | Incorrect/empty ownership | `reference.institutions_registry`, `reference.licenses_registry` empty (enrollment-gated); `monitoring.*` (11 tables) seeded-failed, data missing. | No aggregate error; data-state issue recorded for construction planning. |
| V8 | Constitutional conflicts (not model violations) | P3 vs I11 conflict (RULE 12's two mandated homes: aggregate model vs schema/RLS/data distinctness); I11 bypass precedent (SECURITY DEFINER); P7 circularity. | Out of scope for this document; require ADR amendment via the enforcement architecture machinery. The aggregate home required by P3 is now provided here; the RLS home remains per I11. |

---

## Section 7 — Consistency Verification

| Constitution / baseline artifact | Consistency result |
|---|---|
| **ADR-001** (series foundation, terminology policy) | Consistent. Uses the final vocabulary (Aggregate, Aggregate Root, Business Entity, qualified Domain, Runtime-Generated Data); no forbidden terms; is a constitutional amendment recorded in the ADR series (baseline item 5). |
| **ADR-002** (constitution) | Consistent. Realizes P3 (aggregate model), P6/I10 (natural keys per aggregate root), P2/I4 (single ownership mapping), I5 (RULE 11/12 expressible and assertable), C5 (applications, conditions, documents, certificates architecturally related), P9/I8 (dead data flagged), C8 (behavior-verifiable). No invariant violated. |
| **Architecture Baseline v2** | Consistent. Satisfies constitutional item 5 (DOMAIN_MODEL amended with aggregate/aggregate-root); document belongs to the constitutional set per the transition plan; companions registered in the document index. |
| **Glossary** (final vocabulary) | Consistent. Terms Aggregate (T14), Aggregate Root (T15), Business Entity (T10 replacement), Runtime-Generated Data (T16), Dataset classes (T21–T23), qualified Domain (T18) used throughout. |
| **Constitution** (P1–P9, I1–I11) | Consistent. P1/I1 respected (seed suite = historical record, A25); I3 (construction not restoration); I4 (no shared ownership; shared kernel declared); I9 (behavior over integrity); I11 (runtime data never seeded; RLS never bypassed). |
| **Enforcement Architecture** | Consistent. D3 evidence set (aggregate model, business dependency graph, natural-key sets, ownership) now has content; R10 ownership registry content = Section 4 mapping; P3/I5, P2/I4, G5 move from "Needs Extension / Missing evidence" toward verifiable. |
| **Constitutional Object Model** | Consistent. The 25 aggregates are Evidence objects (owned by D3) and Ownership declarations (owned by R10); they compose the Business Dependency Graph Evidence; the RULE 12 cross-aggregate invariant is a Rule → Constraint → Evidence chain across A01/A02/A09/A18. |
| **Constitutional State Machine** | Consistent. The 9-state machine governs constitutional objects (this document's own lifecycle), not business entities. Business states (application statuses) are workflow-derived (RULE 11), a separate concern; no state conflict. |

---

## Section 8 — Final Verdict

**Can Phase 1 implementation now begin safely?**

**YES.**

Supported only by evidence:

1. **ADR-002 §3 P3 / §5 I5 (C5):** the aggregate model is now expressible in a single authoritative model. RULE 11 (A01, source A20) and RULE 12 (A02, crossing A01/A09/A18) have authoritative homes with stated invariants. This was the stated blocking requirement of the root cause analysis and the challenge review.
2. **ADR-002 §5 I10 / P6:** natural keys are declared for every aggregate root (Section 4), providing the business identity basis for idempotency and dataset reconciliation.
3. **ADR-002 §3 P2 / §5 I4 / G5:** the 234-table single-ownership mapping (`aggregate-table-mapping.csv`) is the ownership declaration; the declared shared kernel (users → A18) satisfies P2/I4; no table is unassigned, no table is shared.
4. **Enforcement readiness (enforcement architecture §6):** P3/I5, P2/I4, and G5 were classed "Needs Extension — Missing evidence." This document supplies that evidence (aggregate model, ownership registry content, natural keys). EC3 (DOMAIN_MODEL grep for Aggregate/Aggregate Root and Application/Condition roots) is now satisfiable.
5. **Baseline v2 item 5:** the last open constitutional prerequisite — the DOMAIN_MODEL aggregate amendment — is delivered. No other conceptual prerequisite remains open in the transition plan.

Known remaining items do **not** block Phase 1: the three constitutional conflicts (V8: P3 vs I11, I11 bypass, P7 circularity) require ADR amendment through the enforcement machinery and are explicitly out of scope for this document. Their handling is Phase 1 work, not a Phase 1 precondition.

**Conclusion.** The canonical Domain Model constitution is complete. Phase 1 implementation may begin safely.

---

## References

- `docs/architecture/adr/ADR-002-canonical-dataset-architecture.md` (constitution — P1–P9, I1–I11, C1–C12)
- `docs/architecture/adr/ADR-001-series-foundation.md` (ADR series foundation, terminology policy)
- `docs/architecture/architecture-transition-plan.md` (Phase 1 — DOMAIN_MODEL amendment)
- `docs/architecture/architecture-baseline-v2-index.md` (§2 item 5)
- `docs/architecture/architecture-governance-freeze.md`
- `docs/reference/glossary.md` (final vocabulary — T14, T15, T16, T17, T18)
- `docs/domain/DOMAIN_MODEL.md` (business language source, unaffected)
- `docs/architecture/constitutional-enforcement-architecture.md` (D1–D8; §6 readiness)
- `docs/architecture/constitutional-object-model.md`, `docs/architecture/constitutional-state-machine.md`
- `docs/architecture/constitution-enforcement-matrix.csv`, `docs/architecture/enforcement-gap-register.csv`
- `docs/database-table-inventory.csv` (234-table source inventory)
- `docs/feature-traceability-matrix.csv` (28 features)
- `docs/backend-route-traceability.csv` (API module enumeration)
- `docs/architecture/aggregate-table-mapping.csv`, `docs/architecture/aggregate-feature-mapping.csv` (companions)
