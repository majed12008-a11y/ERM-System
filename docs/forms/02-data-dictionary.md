# ERM-System Forms Library — Data Dictionary & Field Specifications (v1)

> Version 1.0 · 2026-08-01
> Defines every data element used by the v1 Forms Library. Covers the shared entity dictionary, the form definition schema, and field-level specifications for the flagship forms.

---

## 1. Shared Entity Dictionary

### 1.1 `core.applications` (extended for forms)

| Field | Type | M/O | Notes |
|---|---|---|---|
| `id` | bigint PK | M | |
| `application_number` | varchar(50) | M | `REC-<yyyy>-<seq>` |
| `project_id` | bigint FK | M | → `core.projects` |
| `application_type` | enum | M | `INITIAL / AMENDMENT / RENEWAL / EXPEDITED` |
| `target_committee_id` | bigint FK | M | → `committee.committees` |
| `current_status` | enum | M | workflow-synced (`DRAFT…ARCHIVED`) |
| `submitted_by` | bigint FK | M | → `security.users` |
| `submitted_at` | timestamptz | O | set on `SUBMIT` |
| `is_archived` | bool | O | |
| `protocol_version` | varchar(50) | O | applicant's protocol version |
| `risk_level` | enum | O | `MINIMAL / LOW / MODERATE / HIGH` |
| `review_type` | enum | O | `FULL / EXPEDITED / EXEMPT` |
| audit cols | — | M | `created_at/by, updated_at/by, deleted_at/by` |

### 1.2 `forms.form_definitions` (NEW)

| Field | Type | M/O | Notes |
|---|---|---|---|
| `id` | bigint PK | M | |
| `form_code` | varchar(100) | M | e.g. `SCI_REVIEW_PRIMARY` |
| `form_name_ar` | varchar(500) | M | |
| `form_name_en` | varchar(500) | O | |
| `category` | varchar(50) | M | catalog category |
| `workflow_stage` | varchar(50) | M | lifecycle stage |
| `version_no` | int | M | monotonic per code |
| `schema_version` | varchar(20) | M | JSON schema version (`1.0.0`) |
| `form_schema` | jsonb | M | JSON Schema (draft 2020-12) — see `06-json-schemas.md` |
| `renderer` | varchar(50) | O | `schema-form` (interactive) or `handlebars` (document) |
| `is_active` | bool | M | |
| `created_by/at` | — | M | audit |

### 1.3 `forms.form_instances` (NEW)

| Field | Type | M/O | Notes |
|---|---|---|---|
| `id` | bigint PK | M | |
| `form_definition_id` | bigint FK | M | → `forms.form_definitions` |
| `entity_type` | varchar(100) | M | `Application`, `Meeting`, `Site`… |
| `entity_id` | bigint | M | |
| `status` | enum | M | `DRAFT / SUBMITTED / RETURNED / APPROVED / VOID` |
| `responses` | jsonb | M | form data payload |
| `total_score` | numeric | O | computed |
| `recommendation` | varchar(50) | O | reviewer verdict |
| `submitted_by` | bigint FK | M | |
| `submitted_at` | timestamptz | O | |
| `approved_by` | bigint FK | O | |
| `approved_at` | timestamptz | O | |
| audit cols | — | M | |

### 1.4 `documents.document_numbering` (NEW)

| Field | Type | Notes |
|---|---|---|
| `id` | bigint PK | |
| `category` | varchar(50) | numbering category (e.g. `DEC_LETTER`) |
| `year` | int | |
| `last_seq` | bigint | last used sequence |
| `prefix` | varchar(20) | |

Unique `(category, year)`. Allocations use `pg_advisory_xact_lock` to prevent races.

### 1.5 `documents.templates` (EXTENDED)

Adds: `language varchar(5)` (ar/en), `document_category varchar(50)`, `is_default bool`, `schema jsonb` (for data-driven documents). Version uniqueness becomes `(template_code, version_no)` with `language` as an additional dimension on the generated document.

### 1.6 `documents.document_versions` (now WRITTEN by the engine)

Every generated PDF writes a version row: `document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, version_notes`. Guarantees immutable history.

---

## 2. Form Definition JSON Schema (meta-schema)

```jsonc
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "erms://forms/form-definition",
  "type": "object",
  "properties": {
    "sections": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "id": { "type": "string" },
          "title": { "type": "object", "properties": { "ar": {"type":"string"}, "en": {"type":"string"} } },
          "description": { "type": "object", "properties": { "ar": {"type":"string"}, "en": {"type":"string"} } },
          "collapsible": { "type": "boolean", "default": false },
          "collapsedDefault": { "type": "boolean", "default": false },
          "fields": { "type": "array", "items": { "$ref": "#/$defs/field" } }
        },
        "required": ["id", "title", "fields"]
      }
    }
  },
  "$defs": {
    "field": {
      "type": "object",
      "properties": {
        "name": { "type": "string" },
        "label": { "type": "object", "properties": { "ar": {"type":"string"}, "en": {"type":"string"} } },
        "help": { "type": "object", "properties": { "ar": {"type":"string"}, "en": {"type":"string"} } },
        "type": { "enum": ["text", "textarea", "number", "date", "select", "radio", "checkbox", "scale", "boolean", "email", "tel", "file"] },
        "required": { "type": "boolean", "default": false },
        "placeholder": { "type": "object", "properties": { "ar": {"type":"string"}, "en": {"type":"string"} } },
        "options": { "type": "array", "items": { "type": "object", "properties": {
          "value": { "type": "string" }, "label": { "type": "object" } } } },
        "conditional": { "type": "object", "properties": {
          "field": { "type": "string" }, "equals": { "type": "string" } } },
        "min": { "type": "number" }, "max": { "type": "number" },
        "step": { "type": "number" },
        "default": {},
        "pattern": { "type": "string" },
        "multiline": { "type": "boolean", "default": false },
        "rows": { "type": "number" }
      },
      "required": ["name", "label", "type"]
    }
  }
}
```

---

## 3. Field Specifications — Flagship Forms

### 3.1 FRM-003 Scientific Review — Primary Reviewer Assessment

**Sections & fields:**

| Section | Field | Type | M/O | Validation |
|---|---|---|---|---|
| Reviewer | `reviewer_name` | text | M | max 200 |
| | `review_date` | date | M | ≤ today |
| | `reviewer_role` | select | M | PRIMARY/SECONDARY |
| | `application_number` | text | M (autofill) | pattern `^REC-\d{4}-\d{6}$` |
| Study summary | `study_title` | text | M (autofill) | |
| | `study_design` | select | M | RCT / Cohort / Case-control / Qualitative / Others |
| | `objectives_clarity` | scale 1-5 | M | 1=unclear 5=clear |
| | `hypothesis` | textarea | M | |
| Methodology | `sample_size_adequate` | scale 1-5 | M | |
| | `sampling_bias` | radio | M | None/Low/Moderate/High |
| | `statistical_plan` | textarea | O | |
| | `data_collection` | textarea | M | |
| Ethics of science | `risk_minimization` | scale 1-5 | M | |
| | `stopping_rules` | boolean | M | |
| | `scientific_comment` | textarea | O | free critique |
| Verdict | `recommendation` | radio | M | APPROVE / APPROVE_WITH_CHANGES / REJECT / RETURN |
| | `recommendation_justification` | textarea | M (if REJECT/RETURN) | conditional |
| | `changes_required` | textarea | O | list of changes |

**Calculated:** `total_score` = mean of scale fields (2 dp). **Generated:** document reference number, QR, review instance number.

### 3.2 FRM-025 Serious Adverse Event (SAE) Report

| Section | Field | Type | M/O | Validation |
|---|---|---|---|---|
| Event | `sae_report_number` | text | M (generated) | `SAF-<appNo>-SAE-<seq>` |
| | `event_date` | date | M | |
| | `reported_at` | datetime | M (auto) | |
| | `report_timeliness` | select | M | ≤24h / ≤7d / delayed |
| | `event_type` | select | M | Death / Life-threatening / Hospitalization / Disability / Congenital / Other Serious |
| | `severity` | select | M | Grade 1–5 (CTCAE) |
| | `relationship` | select | M | Unrelated / Possible / Probable / Definite |
| | `expectedness` | select | M | Expected / Unexpected |
| Participant | `participant_id` | text | M (coded) | |
| | `participant_outcome` | select | M | Recovered / Ongoing / Death / Unknown |
| Actions | `action_taken` | textarea | M | |
| | `protocol_change` | boolean | M | if true → requires amendment |
| | `investigator_comment` | textarea | O | |

### 3.3 FRM-028 Site Monitoring Checklist

| Section | Field | Type | M/O |
|---|---|---|---|
| Visit | `site_name`, `visit_date`, `monitor_name`, `visit_type` | text/date/select | M |
| Verification | `source_data_verified` (boolean), `consent_verified_count` (number), `eligibility_adherence` (radio), `drug_accountability` (radio), `ae_documentation` (radio) | — | M |
| Findings | `critical_findings` (textarea), `major_findings` (textarea), `minor_findings` (textarea), `corrective_actions` (textarea), `follow_up_date` (date) | — | M/O |

### 3.4 FRM-015 Committee Minutes

| Section | Field | Type | M/O |
|---|---|---|---|
| Meeting | `meeting_ref`, `meeting_date`, `chair`, `quorum_confirmed`, `attendance_count` | — | M |
| Proceedings | `call_to_order`, `conflict_summary`, `docket_review` (repeating {application, presenter, discussion, decision}), `adjournment` | — | M |
| Attestation | `minutes_approved_by`, `minutes_approval_date`, signatures | — | M |

---

## 4. Auto-Save & Draft Contract

- Every interactive form instance persists `status=DRAFT` with `responses` JSONB on every field blur / debounce (1s).
- Auto-save calls `PUT /api/v1/forms/instances/:id` — the renderer reports last-saved-at and dirty state.
- Submission transitions `DRAFT → SUBMITTED`, immutably locks `responses` (new edits require `RETURN`).
- Drafts are user-scoped; submissions are entity-scoped and visible per RLS.

## 5. Localization & RTL Contract

- `label`, `help`, `placeholder`, `options[].label`, `sections[].title/description` are bilingual objects `{ar, en}`.
- The renderer picks the active language; `document.documentElement.dir` already switches.
- Official PDFs are rendered with `dir` and language chosen from the generation request; templates use `{{lang}}` context.
