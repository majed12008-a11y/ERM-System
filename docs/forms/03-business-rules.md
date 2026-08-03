# ERM-System Forms Library — Business Rules & Workflow Mapping (v2)

> Version 2.0 · 2026-08-02
> Defines the business rules enforced by each form and the mapping of forms to workflow states/transitions, roles, and notifications.
> **v2 reconciliation (2026-08-02):** §2 state machine verified against `workflow.workflow_states`/`workflow_transitions` (14 states, 32 transitions incl. multi-source `WITHDRAW`). Added BR-010 (multi-signature gate), BR-011 (checksum verification), BR-012 (watermark rendering), BR-013 (document lifecycle status gate) per the five mandatory features. Documents `status` CHECK now `OFFICIAL/REVOKED/VOID/SUPERSEDED` — **target** expansion to `DRAFT/PENDING_SIGNATURE/APPROVED/ISSUED/SUPERSEDED/REVOKED/VOID/EXPIRED/ARCHIVED`.

---

## 1. Cross-Cutting Business Rules

| Rule ID | Rule | Enforcement point |
|---|---|---|
| BR-001 | A form instance's `responses` are immutable once `SUBMITTED`; only `RETURNED` allows editing. | Backend service + DB CHECK (`status='DRAFT' OR responses locked`) |
| BR-002 | Official documents are generated **only** from `SUBMITTED`/`APPROVED` data — never from drafts. | `DocumentRenderService` guards |
| BR-003 | Generated PDFs are immutable: physical DELETE blocked at DB level; only soft-delete. | RLS `FOR DELETE USING (false)` |
| BR-004 | Every generated document records a SHA-256 checksum and a `document_versions` row. | Engine `createVersion()` |
| BR-005 | Reference numbers are allocated atomically and never reused. | `document_numbering` + advisory lock |
| BR-006 | Approval/decision documents require at least one electronic signature from the responsible role before they are considered official. | Signing workflow + status gate |
| BR-007 | Audit: all form + document mutations write `audit.audit_logs` via trigger; `documents.document_audit` records generation actions. | Triggers + engine |
| BR-008 | Bilingual rule: mandatory documents must render in the language of the recipient; templates may supply `ar` and `en` variants. | Engine `language` parameter |
| BR-009 | RLS is the sole access control; new tables get policies (see `05-database-mapping.md`). | Seed SQL |
| BR-010 | Official documents may carry **multiple** electronic signatures (Reviewer/Secretary/Chair/Institutional Representative); signing allowed only in the ISSUED (or configured) lifecycle gate; `(document_id, signer_id, signature_type)` unique. | Signing service + DB unique index |
| BR-011 | **Checksum verification:** `POST /public/checksum` recomputes SHA-256 of an uploaded PDF and compares to `documents.checksum_sha256` → `VALID / INVALID / MODIFIED`. | Public route + repo |
| BR-012 | **Watermarks** are applied at render time (never stored in canonical bytes): DRAFT/COPY/VOID/SUPERSEDED/REVOKED/EXPIRED per status+version; OFFICIAL default version renders none. | Engine wrapper |
| BR-013 | **Document lifecycle:** only `DRAFT→PENDING_SIGNATURE→APPROVED→ISSUED` forward + `ISSUED→SUPERSEDED/REVOKED/VOID` + `ISSUED→EXPIRED→ARCHIVED`; terminal states immutable (RLS `FOR DELETE USING (false)` + `trg_documents_immutable`). | Engine + DB CHECK/trigger |

---

## 2. Workflow State Mapping

The application workflow (states from `reference.application_statuses` + `35/36/37` + terminal-state fix `44`) with the forms that drive each transition:

| From → To | Transition | Triggering Form(s) | Role | Notification |
|---|---|---|---|---|
| `DRAFT → SUBMITTED` | `SUBMIT` | FRM-001 (Application), FRM-014 (Researcher Declaration) | APPLICANT | Coordinator |
| `SUBMITTED → INITIAL_REVIEW` | `ACCEPT_INITIAL` | FRM-002 (Admin Screening) | COORDINATOR | Applicant, Reviewers |
| `SUBMITTED → SUBMITTED` | `RETURN_SUBMITTED` | FRM-002 (incomplete) | COORDINATOR | Applicant |
| `SUBMITTED → REJECTED` | `REJECT_SUBMITTED` | FRM-002, FRM-009 (Exemption) | COORDINATOR/CHAIR | Applicant |
| `INITIAL_REVIEW → SCIENTIFIC_REVIEW` | `SEND_TO_SCIENTIFIC` | FRM-002, FRM-007 (Legal) | COORDINATOR | Reviewers |
| `SCIENTIFIC_REVIEW → ETHICAL_REVIEW` | `SEND_TO_ETHICAL` | FRM-003/004 (Sci Review), FRM-006 | CHAIR | Ethics reviewers |
| `SCIENTIFIC_REVIEW → SCIENTIFIC_REVIEW` | `RETURN_SCIENTIFIC` | FRM-003/004 | CHAIR | Reviewers |
| `ETHICAL_REVIEW → COMMITTEE_REVIEW` | `SEND_TO_COMMITTEE` | FRM-005 (Ethics Review), FRM-012/013 (COI/Confidentiality) | CHAIR | Coordinator |
| `COMMITTEE_REVIEW → APPROVED` | `COMMITTEE_APPROVE` | FRM-010/011/015/016/017 (Agenda/Attendance/Minutes/Voting/Decision) | CHAIR | Applicant → certificate (FRM-018) |
| `COMMITTEE_REVIEW → REJECTED` | `COMMITTEE_REJECT` | FRM-017, FRM-020 (Rejection Letter) | CHAIR | Applicant |
| `COMMITTEE_REVIEW → AWAITING_CONDITIONS` | `COMMITTEE_CONDITIONAL` | FRM-017, FRM-019 (Conditional Approval) | CHAIR | Applicant |
| `AWAITING_CONDITIONS → AWAITING_CONDITIONS` | `CONDITIONS_MET / CONDITIONS_NOT_MET / SUBMIT_EVIDENCE` | FRM-019 evidence workflow | APPLICANT/COORDINATOR | Applicant |
| `COMMITTEE_REVIEW → COMMITTEE_REVIEW` | `COMMITTEE_RETURN` | FRM-021 (Deferral Letter), FRM-037 (Appeal) | CHAIR | Applicant |
| `APPROVED → CLOSED` | `CLOSE` | FRM-024 (Continuing Review), FRM-032/033 (Closure/Final) | CHAIR | Applicant |
| `APPROVED → ARCHIVED` | `ARCHIVE` | FRM-033, FRM-035 (Receipt) | COORDINATOR | Applicant |
| any → `WITHDRAWN` | `WITHDRAW` | FRM-001 (withdraw action) | APPLICANT | Coordinator |

**Post-approval sub-workflows (not part of the state machine states):**
- **Continuing review:** FRM-024 must be submitted before expiry; expiry → suspension pathway.
- **Safety:** FRM-025 (SAE) / FRM-026 (Deviation) / FRM-027 (Non-compliance) arrive out-of-band and attach to the application; escalate to suspension (FRM-030) / termination (FRM-031) when warranted.
- **Monitoring:** FRM-028/029 findings may trigger corrective action conditions or suspension.

---

## 3. Role × Form Capability Matrix (v1)

| Form | Create | Edit | Approve | Sign |
|---|---|---|---|---|
| FRM-001 Application | APPLICANT | APPLICANT (DRAFT/RETURNED) | COORDINATOR | APPLICANT |
| FRM-002 Admin Screening | COORDINATOR | COORDINATOR | COORDINATOR | COORDINATOR |
| FRM-003/004/005 Reviews | REVIEWER | REVIEWER (own, DRAFT) | CHAIR | REVIEWER |
| FRM-006/007 Stat/Legal | REVIEWER | REVIEWER | CHAIR | REVIEWER |
| FRM-008/009 Expedited/Exempt | CHAIR | CHAIR | CHAIR | CHAIR |
| FRM-010 Agenda | COORDINATOR | COORDINATOR | CHAIR | — |
| FRM-011 Attendance | COORDINATOR | COORDINATOR | CHAIR | Attendees |
| FRM-012/013 COI/Confidentiality | REVIEWER | — | COORDINATOR | REVIEWER |
| FRM-014 Researcher Decl. | APPLICANT | — | COORDINATOR | APPLICANT |
| FRM-015 Minutes | COORDINATOR | COORDINATOR (DRAFT) | CHAIR | CHAIR + COORDINATOR |
| FRM-016 Voting | COORDINATOR | — | CHAIR | CHAIR |
| FRM-017 Decision | COORDINATOR | — | CHAIR | CHAIR |
| FRM-018 Certificate | AUTO | — | CHAIR (sign) | CHAIR |
| FRM-019/020/021 Letters | COORDINATOR | COORDINATOR (DRAFT) | CHAIR | CHAIR |
| FRM-022 Amendment Request | APPLICANT | APPLICANT | CHAIR | APPLICANT |
| FRM-024 Progress | APPLICANT | APPLICANT | CHAIR | APPLICANT |
| FRM-025/026/027 Safety | APPLICANT | — | CHAIR/COORDINATOR | APPLICANT |
| FRM-028/029 Monitoring | MONITOR | MONITOR (DRAFT) | CHAIR | MONITOR |
| FRM-030/031 Suspend/Terminate | COORDINATOR | — | CHAIR | CHAIR |
| FRM-032/033 Closure/Final | APPLICANT | APPLICANT | CHAIR | APPLICANT |
| FRM-034 Consent | APPLICANT (customize) | APPLICANT | CHAIR | CHAIR |
| FRM-035 Receipt | COORDINATOR | — | — | COORDINATOR |
| FRM-037 Appeal | APPLICANT | — | CHAIR | APPLICANT |

**Permissions required:** `application.view/create/submit` (001,014,022,024,025,032,033), `review.conduct` (002–009), `meeting.manage` (010,011), `meeting.minutes` (015), `decision.record` (016,017), `decision.approve` (018–021,030,031), `consent.manage` (034), `safety.report` (025,026,027), `monitoring.conduct` (028,029), `declaration.submit` (012,013,014).

---

## 4. Validation Rules

1. **Required-if logic** is encoded in each form schema via `conditional` (e.g., justification required when recommendation = REJECT).
2. **Scale bounds** `min`/`max` enforced by the renderer and re-validated server-side.
3. **Pattern** for reference fields (`application_number`, `sae_report_number`).
4. **Cross-field:** SAE `protocol_change=true` requires a linked amendment; Continuing Review requires non-empty `participants_enrolled`; Minutes require `quorum_confirmed=true` before decisions render.
5. **Server-side:** Zod schema generated from the stored `form_schema` at submission time (never trust client).

---

## 5. Notification Triggers

| Event | Recipients | Template |
|---|---|---|
| Form submitted | Coordinator + assigned reviewers | `NTF_FORM_SUBMITTED` |
| Review returned to applicant | Applicant | `NTF_FORM_RETURNED` |
| Review verdict finalized | Applicant + coordinator | `NTF_REVIEW_FINALIZED` |
| Certificate issued | Applicant | `CERTIFICATE_ISSUED` |
| Letter issued (conditional/reject/defer) | Applicant | `NTF_DECISION_LETTER` |
| SAE/Deviation received | Coordinator + CHAIR | `NTF_SAFETY_REPORT` |
| Continuing review due (≤60 days) | Applicant | `NTF_CONTINUING_DUE` |
| Monitoring finding critical | CHAIR | `NTF_MONITORING_CRITICAL` |

All notifications persist in `communication.notifications` and are surfaced via the existing SSE stream.
