# P2 — Informed Consent Framework: Design Document

## 1. Architecture Overview

```
Consent Template          (committee.consent_templates)
       ↓
Consent Version           (committee.consent_template_versions)
       ↓
Application Consent       (core.application_consents)
       ↓
Consent Record            (monitoring.consent_records) — RC2
```

### Why 4 layers?

| Layer | Purpose | Example |
|-------|---------|---------|
| Template | Logical consent type | "نموذج موافقة دراسة سريرية" |
| Version | Frozen snapshot with content | v1.0 AR, v1.0 EN, v2.0 AR |
| Application Consent | Links version → application | App 105 uses v2.0 of template X |
| Record | Individual participant signature | Participant P001 signed on 2024-03-15 |

---

## 2. Table Definitions

### 2.1 `committee.consent_templates`

```sql
CREATE TABLE committee.consent_templates (
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code            VARCHAR(50)   NOT NULL UNIQUE,   -- e.g. 'CLINICAL_TRIAL', 'OBSERVATIONAL'
    name_ar         VARCHAR(500)  NOT NULL,
    name_en         VARCHAR(500)  NOT NULL,
    description     TEXT,
    consent_type    VARCHAR(50)   NOT NULL,           -- WRITTEN, ELECTRONIC, VERBAL, GUARDIAN, ASSENT, WAIVER, DEFERRED
    is_active       BOOLEAN       NOT NULL DEFAULT true,
    -- standard audit columns
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT now(),
    created_by      BIGINT,
    updated_at      TIMESTAMPTZ,
    updated_by      BIGINT,
    deleted_at      TIMESTAMPTZ,
    deleted_by      BIGINT
);

CREATE INDEX idx_consent_templates_type ON committee.consent_templates(consent_type);
CREATE INDEX idx_consent_templates_active ON committee.consent_templates(is_active);
```

**Consent Types** (validated via CHECK constraint or application layer):

| Code | Meaning |
|------|---------|
| WRITTEN | Written consent (paper) |
| ELECTRONIC | Electronic consent (e-signature) |
| VERBAL | Verbal consent (witnessed) |
| GUARDIAN | Guardian/parental consent |
| ASSENT | Minor assent (child's agreement) |
| WAIVER | Waiver of consent (ethics committee approved) |
| DEFERRED | Deferred consent (emergency research) |

---

### 2.2 `committee.consent_template_versions`

This is the most critical table. Each version is **immutable once used** — no UPDATEs after an application links to it.

```sql
CREATE TABLE committee.consent_template_versions (
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    template_id     BIGINT        NOT NULL REFERENCES committee.consent_templates(id),
    version_no      INTEGER       NOT NULL,           -- 1, 2, 3...
    language        VARCHAR(10)   NOT NULL,           -- 'ar', 'en'
    title           VARCHAR(500)  NOT NULL,           -- localized title
    content         TEXT,                             -- plain text / HTML content
    document_id     BIGINT,                           -- optional: link to documents.documents for PDF/DOCX
    effective_from  DATE,                             -- first date this version is valid (NULL = immediately)
    retired_at      DATE,                             -- when this version was superseded/retired
    change_summary  TEXT,                             -- what changed from previous version
    status          VARCHAR(50)   NOT NULL DEFAULT 'DRAFT',
        -- DRAFT, UNDER_REVIEW, APPROVED, RETIRED
    is_active       BOOLEAN       NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT now(),
    created_by      BIGINT,
    updated_at      TIMESTAMPTZ,
    updated_by      BIGINT,
    deleted_at      TIMESTAMPTZ,
    deleted_by      BIGINT,

    UNIQUE (template_id, version_no, language)
);

CREATE INDEX idx_ctv_template ON committee.consent_template_versions(template_id);
CREATE INDEX idx_ctv_status ON committee.consent_template_versions(status);
```

**Key constraint**: No two versions of the same template can have the same `version_no` + `language`.

**Immutable rule**: Once `status = 'APPROVED'` and an application links to this version, back-end should reject any UPDATE.

---

### 2.3 `core.application_consents`

Links a specific consent version to an application.

```sql
CREATE TABLE core.application_consents (
    id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    application_id      BIGINT        NOT NULL REFERENCES core.applications(id),
    consent_version_id  BIGINT        NOT NULL REFERENCES committee.consent_template_versions(id),
    is_required         BOOLEAN       NOT NULL DEFAULT true,
    status              VARCHAR(50)   NOT NULL DEFAULT 'PENDING',
        -- PENDING, APPROVED, MINOR_REVISION, MAJOR_REVISION, REJECTED
    reviewer_notes      TEXT,
    reviewed_by         BIGINT,
    reviewed_at         TIMESTAMPTZ,
    is_active           BOOLEAN       NOT NULL DEFAULT true,
    created_at          TIMESTAMPTZ   NOT NULL DEFAULT now(),
    created_by          BIGINT,
    updated_at          TIMESTAMPTZ,
    updated_by          BIGINT,
    deleted_at          TIMESTAMPTZ,
    deleted_by          BIGINT,

    UNIQUE (application_id, consent_version_id)
);

CREATE INDEX idx_app_consents_app ON core.application_consents(application_id);
CREATE INDEX idx_app_consents_status ON core.application_consents(status);
```

**Statuses for consent review** (part of ethics committee workflow):

| Status | Meaning |
|--------|---------|
| PENDING | Not yet reviewed |
| APPROVED | Consent form approved |
| MINOR_REVISION | Minor changes needed |
| MAJOR_REVISION | Significant changes needed |
| REJECTED | Consent form rejected |

---

### 2.4 `committee.consent_review_comments`

Structured review comments on consent forms, linking ethics reviewers to application consents.

```sql
CREATE TABLE committee.consent_review_comments (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    application_consent_id  BIGINT NOT NULL REFERENCES core.application_consents(id),
    reviewer_id             BIGINT NOT NULL REFERENCES security.users(id),
    decision                VARCHAR(50) NOT NULL,
        -- APPROVED, MINOR_REVISION, MAJOR_REVISION, REJECTED
    comment                 TEXT   NOT NULL,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ,
    updated_by              BIGINT,
    deleted_at              TIMESTAMPTZ,
    deleted_by              BIGINT
);

CREATE INDEX idx_consent_review_consent ON committee.consent_review_comments(application_consent_id);
```

---

### 2.5 `monitoring.consent_records` (RC2 — design only)

```sql
CREATE TABLE monitoring.consent_records (
    id                       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    application_consent_id   BIGINT       NOT NULL REFERENCES core.application_consents(id),
    participant_code         VARCHAR(100) NOT NULL,      -- participant identifier
    consent_date             DATE         NOT NULL,
    signed_by_participant    BOOLEAN      NOT NULL DEFAULT false,
    signed_by_witness        BOOLEAN      NOT NULL DEFAULT false,
    signed_by_guardian       BOOLEAN      NOT NULL DEFAULT false,
    witness_name             VARCHAR(300),
    guardian_name            VARCHAR(300),
    relationship_to_subject  VARCHAR(100),
    withdrawn                BOOLEAN      NOT NULL DEFAULT false,
    withdrawal_date          DATE,
    withdrawal_reason        TEXT,
    document_id              BIGINT,                      -- scanned signed PDF
    created_at               TIMESTAMPTZ  NOT NULL DEFAULT now(),
    created_by               BIGINT,
    updated_at               TIMESTAMPTZ,
    updated_by               BIGINT,
    deleted_at               TIMESTAMPTZ,
    deleted_by               BIGINT
);

CREATE INDEX idx_consent_records_participant ON monitoring.consent_records(participant_code);
CREATE INDEX idx_consent_records_consent ON monitoring.consent_records(application_consent_id);
```

---

## 3. Integration Points

### 3.1 Application Workflow — Review Stream Model

Consent Review is **not** a separate Workflow State. Instead, it is a **Review Stream**
tracked alongside scientific and ethics reviews within `UNDER_REVIEW`:

```
SUBMITTED
  ↓
UNDER_REVIEW
  ├── Scientific Review:  COMPLETED
  ├── Ethics Review:      COMPLETED
  ├── Consent Review:     PENDING      ← tracked via application_consents.status
  └── Risk Assessment:   COMPLETED
  ↓
COMMITTEE_REVIEW
  ↓
APPROVED / CONDITIONALLY_APPROVED / REJECTED
```

Benefits:
- Adding future review streams (Privacy, Data Protection, Biosafety) does not require workflow state changes
- Each stream has its own status independent of the application lifecycle
- The ethics review dashboard shows all streams in parallel

### 3.2 Document Integration

Consent version `document_id` links to `documents.documents` for PDF/DOCX storage.
Existing `documents.document_types` will get new rows for:

| type_code | type_name_ar | type_name_en |
|-----------|-------------|-------------|
| CONSENT_FORM | نموذج موافقة | Consent Form |
| CONSENT_WITHDRAWAL | انسحاب من الموافقة | Consent Withdrawal |

### 3.3 Ethics Review Integration

Consent Review is a **Review Stream** under the application's `UNDER_REVIEW` status.
It is tracked via `application_consents.status` (PENDING → APPROVED/MINOR_REVISION/MAJOR_REVISION/REJECTED).

`committee.ethics_reviews` will reference `application_consents` as a review target:
- `review_type` can now be `CONSENT_REVIEW` in addition to existing types
- `review_decision` mirrors the consent review outcome
- Consent review comments appear in the ethics review dashboard alongside scientific/ethics comments

---

## 4. Existing Schema Overlap Analysis

| Existing Table | Overlap | Decision |
|---------------|---------|----------|
| `documents.templates` | Has `template_code`, `template_name`, `template_content`, `version_no` | **Do not reuse** — flat structure, no language split, no consent_type, no lifecycle (DRAFT/FINAL/SUPERSEDED). The new consent tables are designed from scratch. |
| `documents.documents` | Stores uploaded files with `entity_type`/`entity_id` | **Reuse** — consent version PDFs link here via `document_id` |
| `documents.document_types` | Bilingual type codes | **Reuse** — add CONSENT_FORM, CONSENT_WITHDRAWAL types |
| `core.applications` | Has `current_status` | **No change needed** — Consent Review is a review stream tracked via `application_consents.status`, not a workflow state |

---

## 5. Implementation Order

```
Phase 1: Database
  1. CREATE committee.consent_templates
  2. CREATE committee.consent_template_versions
  3. CREATE core.application_consents
  4. CREATE committee.consent_review_comments
  5. INSERT into documents.document_types for consent types
  6. Insert seed consent templates + versions

Phase 2: Backend API
  1. Consent templates CRUD (GET / POST / PUT / DELETE)
  2. Consent versions CRUD (nested under template)
  3. Application consent assignment (POST / PUT)
  4. Consent review endpoints (reviewer comments, status update)
  5. Permissions: ADMIN/CHAIR manage templates, REVIEWER can review

Phase 3: Frontend
  1. Consent Templates management page
  2. Template Versions management (with version diff)
  3. Application Detail tab: "Consent Forms"
  4. Consent review panel (for ethics reviewers)
```

---

## 6. Permissions

| Role | Templates | Versions | Application Consents | Review |
|------|-----------|----------|---------------------|--------|
| SUPER_ADMIN | CRUD | CRUD | View | View |
| ETHICS_ADMIN | CRUD | CRUD | Assign | View |
| COMMITTEE_CHAIR | CRUD | CRUD | Assign | Review |
| REVIEWER | View | View | View | Submit comments |
| RESEARCHER | View | View | View assigned | — |

---

## 7. Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Template version used by application gets updated | Enforce immutability: reject UPDATE on versions with existing application_consents links |
| Consent text stored in two places (DB + PDF) | DB text is the canonical version; PDF is the participant-facing representation |
| Language mismatch (participant signs AR version but EN was reviewed) | application_consents stores which language version was approved |
| Participant withdrawal cascade | withdrawal_date + withdrawal_reason on consent_records; does not cascade-delete other data |

---

## 8. Future Considerations (RC2+)

| Feature | Rationale |
|---------|-----------|
| **Consent Version Diff** | Compare v1.0 vs v1.1 changes — frequently requested during ethics reviews. Implement via diff utility comparing `content` text fields. |
| Electronic Signature | Digital signature integration. Deferred to avoid complexity in RC1.1. |
| Participant Portal | Self-service consent management. Requires authentication layer for participants. |
| National ID Verification | Integration with national ID systems. Regulatory requirement for certain study types. |
| Consent Record CRUD | Full participant-level consent tracking in `monitoring.consent_records`. Not needed until system manages individual participants. |
