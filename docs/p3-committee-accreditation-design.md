# P3 — Committee Accreditation Design (v1.0)

## 1. Overview

Committee Accreditation is the process by which the National Committee (NCBE) evaluates and certifies that institutional ethics committees meet minimum operational, structural, and procedural standards.

This feature is a regulatory requirement for national ethics oversight and integrates with the existing committee, document, and user infrastructure.

---

## 2. Architectural Model — Design Decisions

### 2.1 Who Is the Accredited Entity?

```
Institution (e.g., جامعة صنعاء)
    │
    └── Committee (e.g., لجنة أخلاقيات جامعة صنعاء)
           │
           └── Accreditation Cycle (e.g., الدورة الأولى 2026–2029)
```

- Accreditation is granted to a **Committee** within a specific **Cycle**.
- An **Institution** may have multiple committees; each committee is accredited independently.
- The institution relationship exists implicitly through `committee.committees.institution_id`.

### 2.2 Are Standards Versioned?

**Yes.** Rather than a flat `requirements` table, we use:

```text
accreditation_standards          (one row per standard concept)
    └── accreditation_standard_versions  (one row per published version)
```

This allows the Ministry of Health to publish **2027 Edition** and **2029 Edition** with different criteria. Each accreditation cycle references a specific standard version.

### 2.3 Four-Layer Separation

Each accreditation follows a strict separation:

| Layer | Table | Responsibility |
|---|---|---|
| **Standard** | `accreditation_standard_versions` | What is required |
| **Evidence** | `accreditation_evidence` | What was submitted |
| **Assessment** | `accreditation_assessments` + `items` | How it was evaluated |
| **Decision** | `accreditation_cycles.status` + `accreditation_conditions` | Final outcome |

### 2.4 Conditional Accreditation

`CONDITIONAL` status is supported from day one with:

- `accreditation_conditions` table — one or more corrective conditions per cycle
- Each condition has: `condition_text`, `due_date`, `status` (OPEN / MET / OVERDUE / WAIVED)
- Accreditation remains CONDITIONAL until all conditions are MET or admin finalizes

### 2.5 Expiry via Scheduled Job

- `valid_from` / `valid_until` stored on `accreditation_cycles`
- A periodic job (`POST /api/v1/accreditation/expire-check`) scans for `valid_until < now() AND status = 'ACCREDITED'` and transitions to `EXPIRED`
- Called manually via API initially; can be wired to cron later

### 2.6 Document Reuse

- Evidence documents link to the existing `documents.documents` table via `document_id` FK
- No separate file storage; entity_type = `ACCREDITATION`

### 2.7 Multiple Assessors

- An accreditation can have **multiple assessments**, each by a different NCBE assessor
- Final decision is based on consolidated assessment results
- Each assessor evaluates all applicable standards independently

---

## 3. Business Rules

### 3.1 Accreditation Lifecycle

```
PENDING → UNDER_REVIEW → ACCREDITED
                        → CONDITIONAL
                        → SUSPENDED → ACCREDITED
                        → REVOKED
ACCREDITED → EXPIRED → (new cycle) PENDING
ACCREDITED → SUSPENDED
CONDITIONAL → ACCREDITED  (conditions MET)
CONDITIONAL → SUSPENDED   (conditions OVERDUE)
CONDITIONAL → REVOKED     (conditions FAILED)
```

- Only one active (non-EXPIRED, non-REVOKED) accreditation per committee at any time.
- A new cycle starts when the previous one expires or is revoked and the committee reapplies.

### 3.2 Statuses

| Status | Description |
|---|---|
| `PENDING` | Application submitted, awaiting NCBE review |
| `UNDER_REVIEW` | Assessment in progress |
| `ACCREDITED` | Fully accredited — all mandatory standards met |
| `CONDITIONAL` | Accredited with specific conditions with due dates |
| `SUSPENDED` | Temporarily suspended due to non-compliance |
| `EXPIRED` | Accreditation period ended |
| `REVOKED` | Permanently revoked |

### 3.3 Duration & Validity

- Default duration: **3 years** from `valid_from` (configurable per cycle)
- `valid_from` set when status changes to ACCREDITED or CONDITIONAL
- `valid_until` = `valid_from + duration`
- Status auto-transitions to EXPIRED via scheduled check

### 3.4 Conditions (for CONDITIONAL status)

Each condition tracked individually:

| Field | Description |
|---|---|
| `condition_text` | What must be fixed (e.g., "Submit missing SOPs") |
| `due_date` | Deadline |
| `status` | OPEN / MET / OVERDUE / WAIVED |

A cycle remains CONDITIONAL until all conditions are MET or admin intervenes.

---

## 4. Database Schema

### 4.1 Tables

#### `accreditation_standards`

Master list of standard concepts (unchanging over time).

| Column | Type | Notes |
|---|---|---|
| id | BIGINT PK | |
| code | VARCHAR(100) UNIQUE | `SOP`, `TOR`, `COI`, etc. |
| name_ar | VARCHAR(300) | |
| name_en | VARCHAR(300) | |
| description_ar | TEXT | |
| description_en | TEXT | |
| category | VARCHAR(50) | `DOCUMENT`, `PROCESS`, `TRAINING`, `COMPLIANCE` |
| sort_order | INT | |
| created_at | TIMESTAMPTZ | |
| updated_at | TIMESTAMPTZ | |

#### `accreditation_standard_versions`

Each published edition of the standards (e.g., 2027 Edition, 2029 Edition).

| Column | Type | Notes |
|---|---|---|
| id | BIGINT PK | |
| standard_id | BIGINT FK → `accreditation_standards(id)` | |
| version_label | VARCHAR(50) | `2027`, `2029`, `1.0`, etc. |
| is_mandatory | BOOLEAN | May change between versions |
| is_active | BOOLEAN | Only one version active at a time |
| effective_from | DATE | When this version takes effect |
| effective_until | DATE | Nullable |
| created_at | TIMESTAMPTZ | |

**Constraint**: UNIQUE `(standard_id, version_label)`

#### `accreditation_cycles`

Core entity — one row per accreditation application/period.

| Column | Type | Notes |
|---|---|---|
| id | BIGINT PK | |
| committee_id | BIGINT FK → `committee.committees(id)` | |
| standard_version_id | BIGINT FK → `accreditation_standard_versions(id)` | Which standards edition applies |
| cycle_number | INT | 1, 2, 3, ... (auto-computed per committee) |
| status | VARCHAR(30) | PENDING → UNDER_REVIEW → ACCREDITED / CONDITIONAL / REVOKED |
| valid_from | TIMESTAMPTZ | Set when ACCREDITED or CONDITIONAL |
| valid_until | TIMESTAMPTZ | Set when valid_from assigned |
| notes | TEXT | |
| decided_by | BIGINT FK → `security.users(id)` | NCBE admin who finalized |
| decided_at | TIMESTAMPTZ | |
| created_by | BIGINT FK → `security.users(id)` | Committee chair/admin who applied |
| created_at | TIMESTAMPTZ | |
| updated_at | TIMESTAMPTZ | |
| deleted_at | TIMESTAMPTZ | Soft delete |

**Constraints**:
- UNIQUE `(committee_id)` WHERE `status NOT IN ('EXPIRED', 'REVOKED')`
- CHECK `valid_until > valid_from` when both set

#### `accreditation_evidence`

Evidence documents submitted by the committee to demonstrate compliance.

| Column | Type | Notes |
|---|---|---|
| id | BIGINT PK | |
| cycle_id | BIGINT FK → `accreditation_cycles(id)` | |
| standard_version_id | BIGINT FK → `accreditation_standard_versions(id)` | Which standard this addresses |
| document_id | BIGINT FK → `documents.documents(id)` | Links to existing document system |
| status | VARCHAR(30) | PENDING, SUBMITTED, ACCEPTED, REJECTED, EXPIRED |
| notes | TEXT | Committee's explanation |
| uploaded_by | BIGINT FK → `security.users(id)` | |
| uploaded_at | TIMESTAMPTZ | |

**Default**: `status = 'PENDING'` on insert. Admin can ACCEPT or REJECT.

#### `accreditation_assessments`

Each assessment is a single NCBE assessor's evaluation of one cycle.

| Column | Type | Notes |
|---|---|---|
| id | BIGINT PK | |
| cycle_id | BIGINT FK → `accreditation_cycles(id)` | |
| assessed_by | BIGINT FK → `security.users(id)` | NCBE assessor |
| overall_decision | VARCHAR(30) | RECOMMEND_APPROVE, RECOMMEND_CONDITIONAL, RECOMMEND_REJECT, DEFER |
| overall_justification | TEXT | |
| overall_score | INT | 1–100 (optional) |
| assessed_at | TIMESTAMPTZ | |
| created_at | TIMESTAMPTZ | |
| updated_at | TIMESTAMPTZ | |

#### `accreditation_assessment_items`

Per-standard evaluation within an assessment.

| Column | Type | Notes |
|---|---|---|
| id | BIGINT PK | |
| assessment_id | BIGINT FK → `accreditation_assessments(id)` | |
| standard_version_id | BIGINT FK → `accreditation_standard_versions(id)` | |
| is_met | BOOLEAN | |
| findings | TEXT | Assessor's comments |
| score | INT | 1–5 |

#### `accreditation_conditions`

Corrective conditions attached to a CONDITIONAL accreditation.

| Column | Type | Notes |
|---|---|---|
| id | BIGINT PK | |
| cycle_id | BIGINT FK → `accreditation_cycles(id)` | |
| condition_text | TEXT | What must be fulfilled |
| due_date | TIMESTAMPTZ | |
| status | VARCHAR(30) | OPEN, MET, OVERDUE, WAIVED |
| resolved_at | TIMESTAMPTZ | When status changed to MET |
| resolved_by | BIGINT FK → `security.users(id)` | Admin who confirmed |
| created_at | TIMESTAMPTZ | |

#### `accreditation_decisions`

Immutable audit trail of all status changes for a cycle.

| Column | Type | Notes |
|---|---|---|
| id | BIGINT PK | |
| cycle_id | BIGINT FK → `accreditation_cycles(id)` | |
| from_status | VARCHAR(30) | Previous status (null for creation) |
| to_status | VARCHAR(30) | New status |
| decision | VARCHAR(30) | APPROVE, REJECT, SUSPEND, REVOKE, EXPIRE, etc. |
| decided_by | BIGINT FK → `security.users(id)` | |
| notes | TEXT | |
| created_at | TIMESTAMPTZ | |

**Note**: This table is append-only. No UPDATE, no DELETE after insert. Provides full appeals/audit trail.

#### `accreditation_cycle_metrics`

Optional capacity metrics per cycle (nullable, can be populated later).

| Column | Type | Notes |
|---|---|---|
| id | BIGINT PK | |
| cycle_id | BIGINT FK → `accreditation_cycles(id)` UNIQUE | |
| meetings_last_12_months | INT | |
| protocols_reviewed_last_12_months | INT | |
| average_review_days | NUMERIC(5,1) | |
| quorum_percentage | NUMERIC(5,1) | |
| members_count | INT | |
| updated_at | TIMESTAMPTZ | |

### 4.2 Entity Relationship Diagram

```
accreditation_standards (1) ──── (N) accreditation_standard_versions
                                              │
                                   ┌──────────┼──────────┐
                                   │          │          │
                                   │   ┌──────┘          │
                                   │   │                 │
                                   ▼   ▼                 ▼
                            accreditation_cycles ──── accreditation_evidence
                                   │
                        ┌──────────┼──────────┐
                        │          │          │
                        ▼          ▼          ▼
              accreditation     accreditation   accreditation
              _assessments      _conditions     _evidence
                        │
                        ▼
              accreditation_assessment_items
```

### 4.3 RLS Policies (written immediately after DDL)

| Table | Policy |
|---|---|
| `accreditation_standards` | All authenticated: SELECT; Admin: INSERT/UPDATE/DELETE |
| `accreditation_standard_versions` | All authenticated: SELECT; Admin: INSERT/UPDATE/DELETE |
| `accreditation_cycles` | Admin: ALL; Committee members: SELECT own committee's cycles; Committee chair: INSERT (apply) |
| `accreditation_evidence` | Admin: ALL; Committee members: SELECT/INSERT own committee; Others: none |
| `accreditation_assessments` | Admin: ALL; Assessor: SELECT/UPDATE own; Committee: SELECT own committee's |
| `accreditation_assessment_items` | Same as parent assessment |
| `accreditation_conditions` | Admin: ALL; Committee: SELECT own; Assessor: SELECT |
| `accreditation_decisions` | Admin: ALL; Committee: SELECT own cycle's decisions; Assessor: SELECT |
| `accreditation_cycle_metrics` | Admin: ALL; Committee: SELECT own; Assessor: SELECT |

---

## 5. API Endpoints

### 5.1 Standards Management

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/api/v1/accreditation/standards` | All | List standards |
| POST | `/api/v1/accreditation/standards` | Admin | Create standard |
| PUT | `/api/v1/accreditation/standards/:id` | Admin | Update standard |
| DELETE | `/api/v1/accreditation/standards/:id` | Admin | Deactivate standard |
| GET | `/api/v1/accreditation/standards/:id/versions` | All | List versions of a standard |
| POST | `/api/v1/accreditation/standards/:id/versions` | Admin | Publish new version |
| PUT | `/api/v1/accreditation/standards/:id/versions/:verId` | Admin | Update version |

### 5.2 Accreditation Cycles

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/api/v1/accreditation/cycles` | All auth | List cycles (RLS-filtered) |
| GET | `/api/v1/accreditation/cycles/:id` | All auth | Get single cycle |
| POST | `/api/v1/accreditation/cycles` | Committee chair | Apply (creates PENDING cycle) |
| PUT | `/api/v1/accreditation/cycles/:id` | Admin | Update cycle metadata |

### 5.3 Status Transitions

| Method | Path | Auth | Description |
|---|---|---|---|
| POST | `/api/v1/accreditation/cycles/:id/submit` | Committee chair | PENDING → UNDER_REVIEW |
| POST | `/api/v1/accreditation/cycles/:id/approve` | Admin | → ACCREDITED |
| POST | `/api/v1/accreditation/cycles/:id/conditional` | Admin | → CONDITIONAL |
| POST | `/api/v1/accreditation/cycles/:id/suspend` | Admin | → SUSPENDED |
| POST | `/api/v1/accreditation/cycles/:id/revoke` | Admin | → REVOKED |

### 5.4 Evidence

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/api/v1/accreditation/cycles/:id/evidence` | RLS-filtered | List evidence documents |
| POST | `/api/v1/accreditation/cycles/:id/evidence` | Committee chair | Submit evidence |
| DELETE | `/api/v1/accreditation/cycles/:id/evidence/:evId` | Committee chair | Remove evidence |

### 5.5 Assessments

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/api/v1/accreditation/cycles/:id/assessments` | RLS-filtered | List assessments |
| POST | `/api/v1/accreditation/cycles/:id/assessments` | Admin/assessor | Create assessment |
| PUT | `/api/v1/accreditation/cycles/:id/assessments/:aId` | Assessor | Update assessment |
| GET | `/api/v1/accreditation/cycles/:id/assessments/:aId/items` | RLS-filtered | List assessment items |
| POST | `/api/v1/accreditation/cycles/:id/assessments/:aId/items` | Assessor | Add item |
| PUT | `/api/v1/accreditation/cycles/:id/assessments/:aId/items/:iId` | Assessor | Update item |

### 5.6 Conditions

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/api/v1/accreditation/cycles/:id/conditions` | RLS-filtered | List conditions |
| POST | `/api/v1/accreditation/cycles/:id/conditions` | Admin | Add condition |
| PUT | `/api/v1/accreditation/cycles/:id/conditions/:cId` | Admin | Update condition |
| POST | `/api/v1/accreditation/cycles/:id/conditions/:cId/resolve` | Admin | Mark condition MET |

### 5.7 Administrative

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/api/v1/accreditation/stats` | Admin | Statistics (by status, expiring soon) |
| GET | `/api/v1/accreditation/cycles/:id/timeline` | RLS-filtered | Full history |
| POST | `/api/v1/accreditation/expire-check` | Admin | Run expiry check job |

---

## 6. Backend Architecture

### 6.1 Directory Structure

```
backend/src/
├── modules/
│   └── accreditation/
│       ├── index.ts
│       ├── accreditation.routes.ts
│       ├── accreditation.controller.ts
│       ├── accreditation.schema.ts
│       └── accreditation.service.ts
├── repositories/
│   ├── accreditation-standard.repository.ts
│   ├── accreditation-standard-version.repository.ts
│   ├── accreditation-cycle.repository.ts
│   ├── accreditation-evidence.repository.ts
│   ├── accreditation-assessment.repository.ts
│   ├── accreditation-assessment-item.repository.ts
│   └── accreditation-condition.repository.ts
```

### 6.2 Key Service Methods

- `applyForAccreditation(committeeId, userId)` — Creates cycle with PENDING status, auto-computes cycle_number, assigns latest active standard version
- `submitForReview(cycleId, userId)` — Transitions PENDING → UNDER_REVIEW, validates evidence exists for mandatory standards
- `finalizeDecision(cycleId, decision, userId)` — Sets ACCREDITED/CONDITIONAL/REVOKED, assigns valid_from/valid_until
- `getTimeline(cycleId)` — Full history with evidence, assessments, conditions
- `checkExpiredAccreditations()` — Scans ACCREDITED cycles where valid_until < now(), transitions to EXPIRED
- `consolidateAssessments(cycleId)` — Aggregates all assessor recommendations; if all recommend approve → auto-recommend
- `resolveCondition(conditionId, userId)` — Marks condition as MET

### 6.3 Validation (Zod)

- `createCycleSchema` — `committee_id` (validated to exist, user must be chair/admin)
- `submitEvidenceSchema` — `standard_version_id`, `document_id`, `notes`
- `assessmentSchema` — `overall_decision`, `overall_justification`, `overall_score`
- `assessmentItemSchema` — `standard_version_id`, `is_met`, `findings`, `score`
- `conditionSchema` — `condition_text`, `due_date`

---

## 7. Frontend Architecture

### 7.1 Pages

| Route | Component | Auth |
|---|---|---|
| `/accreditation` | `AccreditationList` | All authenticated |
| `/accreditation/:id` | `AccreditationDetail` | RLS-filtered |
| `/accreditation/apply` | `AccreditationApply` | Committee chair |
| `/accreditation/:id/assessments/new` | `AccreditationAssess` | NCBE assessor |
| `/accreditation/:id/conditions` | `AccreditationConditions` | Admin/committee |
| `/admin/accreditation/standards` | `AccreditationStandards` | Admin |

### 7.2 Shared Components

- `AccreditationStatusBadge` — Color-coded status label
- `AccreditationTimeline` — Vertical timeline of status changes + key events
- `StandardChecklist` — List of standards with met/unmet per assessment
- `AssessmentForm` — Multi-step form for assessors (standards → scores → decision)
- `ConditionCard` — Single condition with status, due date, resolve action
- `EvidenceUploader` — Document upload targeting specific standard

### 7.3 Navigation

- Sidebar: **Accreditations** (after Committees)
- Admin panel: **Accreditation Standards** (manage standard versions)
- Committee detail page: accreditation status badge + link to latest cycle

### 7.4 Locale Keys

~50-60 new keys (en/ar): status labels, form labels, evidence types, condition statuses, notifications.

---

## 8. Seed Data

### 8.1 Standards

| Code | Name (EN) | Category | Mandatory (2027) |
|---|---|---|---|
| `SOP` | Standard Operating Procedures | DOCUMENT | Yes |
| `TOR` | Terms of Reference | DOCUMENT | Yes |
| `COI` | Conflict of Interest Policy | DOCUMENT | Yes |
| `TRAINING` | Reviewer Training Records | TRAINING | Yes |
| `QUORUM` | Quorum Compliance Evidence | COMPLIANCE | Yes |
| `MEETING_MINUTES` | Meeting Documentation | DOCUMENT | Yes |
| `CONTINUING_REVIEW` | Continuing Review Process | PROCESS | Yes |
| `SAE_HANDLING` | SAE Handling Process | PROCESS | Yes |
| `DATA_PROTECTION` | Data Protection & Confidentiality | DOCUMENT | Yes |
| `MEMBER_QUAL` | Member Qualification Records | TRAINING | Yes |
| `ANNUAL_REPORT` | Annual Activity Report | DOCUMENT | No |
| `BUDGET` | Operational Budget | DOCUMENT | No |

### 8.2 Standard Version

- Version `2027` — effective immediately, all 12 standards above with mandatory flags

### 8.3 Test Data

- 1 ACCREDITED cycle (committee 1, cycle 1, valid 2026–2029)
- 1 PENDING cycle (committee 2, newly applied)
- 1 CONDITIONAL cycle (committee 3, 2 open conditions)

---

## 9. UAT Plan

| ID | Scenario | Role | Prerequisites |
|---|---|---|---|
| ACC-01 | Committee chair applies for accreditation | Committee Chair | Committee exists, user is chair |
| ACC-02 | Chair uploads evidence documents | Committee Chair | Cycle in PENDING/UNDER_REVIEW |
| ACC-03 | Chair submits for NCBE review | Committee Chair | At least one evidence uploaded |
| ACC-04 | NCBE admin views pending application | Admin | Cycle in UNDER_REVIEW |
| ACC-05 | Assessor evaluates all standards | Assessor | Cycle assigned to assessor |
| ACC-06 | Admin approves accreditation | Admin | Assessment completed |
| ACC-07 | Verify badge + valid_until displayed | Committee Chair | Cycle ACCREDITED |
| ACC-08 | Admin creates condition (CONDITIONAL) | Admin | Cycle set to CONDITIONAL |
| ACC-09 | Committee resolves condition | Committee Chair | Condition exists |
| ACC-10 | Admin confirms condition MET | Admin | Evidence submitted |
| ACC-11 | Run expire check | Admin | ACCREDITED cycle with past valid_until |
| ACC-12 | Committee reapplies after expiry | Committee Chair | Cycle EXPIRED |

---

## 10. Implementation Order

```
Design Review & Approval
    ↓
Database Schema (DDL + Constraints + Indexes)
    ↓
RLS Policies (written immediately after DDL)
    ↓
Seed Data (standards, versions, test data)
    ↓
Backend Repositories (7 repositories)
    ↓
Backend Service Layer (business rules + transitions)
    ↓
Backend Routes + Controller + Zod Validation
    ↓
Frontend — List + Detail + Apply
    ↓
Frontend — Assessment + Conditions + Admin Standards
    ↓
Integration Testing + UAT
    ↓
RC1.2 Planning
```

---

## 11. Changes from Draft (v0.1 → v1.0)

| Point | v0.1 (Draft) | v1.0 (After Review) |
|---|---|---|
| Entity model | Committee + Cycles | Institution → Committee → Cycle (clarified) |
| Standards versioning | Flat `requirements` table | `standards` + `standard_versions` |
| 4-layer separation | Implicit | Explicit: Standard → Evidence → Assessment → Decision |
| Conditional support | Status only | `conditions` table with `condition_text`, `due_date`, status tracking |
| Expiry job | Mentioned | Concrete API + design |
| Document linking | Reuses `documents.documents` | Same, clarified with `entity_type = 'ACCREDITATION'` |
| Multiple assessors | Multiple `assessments` rows | Multiple assessments, each by a single assessor, consolidated for final decision |
| RLS timing | After seed | Immediately after DDL |

---

## 12. Dependencies

- `committee.committees` table (existing)
- `documents.documents` table (existing)
- `security.users` + roles (existing)
- Audit logging (existing triggers, reusable)
- Locale/i18n system (existing)

---

## 13. Open Questions

1. **Assessment assignment**: Should an accreditation be auto-assigned to an assessor or manually assigned by admin?
   - **Recommendation**: Admin assigns manually via `POST /accreditation/cycles/:id/assessments`

2. **Auto-consolidation**: Should the system auto-calculate the final decision from multiple assessments?
   - **Recommendation**: Yes, as a helper. Admin retains final say.

3. **Notifications**: Email on status changes?
   - **Recommendation**: Deferred to RC1.2. Audit log only for now.

4. **Public-facing badge**: Should accredited committees have a public API endpoint?
   - **Recommendation**: Deferred. Internal visibility only for RC1.
