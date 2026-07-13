# Template Engine Architecture Document v1.1.1

> **Status:** DRAFT — NOT IMPLEMENTED  
> **Classification:** Architecture Decision Document (ADD)  
> **Domain:** Template Engine — Core Platform Service  
> **Audience:** Architects, Technical Leads, Senior Developers  
> **Revision:** v1.1 → v1.1.1 — Architecture Review Board directive 2026-07-10 (v1.1.1 refinements: Resolver Registry §5.2, Repository-Based Resolution §5.3.1, Event-Driven Generation §4.7)

---

## Table of Contents

1. [Business Purpose](#1-business-purpose)
2. [Domain Model](#2-domain-model)
3. [Versioning Strategy](#3-versioning-strategy)
4. [Rendering Pipeline](#4-rendering-pipeline)
   1. [Mandatory Abstraction: TemplateService](#41-mandatory-abstraction-templateservice)
   2. [Pipeline Overview](#42-pipeline-overview)
   3. [Stage Details](#43-stage-details)
   4. [Error Handling per Stage](#44-error-handling-per-stage)
   5. [Sync vs Async](#45-sync-vs-async)
   6. [Pipeline Timeout](#46-pipeline-timeout)
   7. [Event-Driven Generation](#47-event-driven-generation)
5. [Variable Resolution Engine](#5-variable-resolution-engine)
   1. [Design Principle](#51-design-principle)
   2. [Resolver Registry & Domain Resolvers](#52-resolver-registry--domain-resolvers)
   3. [Path Resolution Model](#53-path-resolution-model)
      1. [Repository-Based Resolution](#531-repository-based-resolution)
   4. [Entity Whitelist](#54-entity-whitelist)
   5. [Function Registry](#55-function-registry)
   6. [Batch Variable Resolution](#56-batch-variable-resolution)
   7. [Recursive Resolution](#57-recursive-resolution)
6. [Validation Engine](#6-validation-engine)
7. [Preview Engine](#7-preview-engine)
8. [Output Providers](#8-output-providers)
9. [Localization](#9-localization)
10. [Security Model](#10-security-model)
11. [Audit](#11-audit)
12. [Storage Strategy](#12-storage-strategy)
13. [API Design](#13-api-design)
14. [Frontend UX](#14-frontend-ux)
15. [Integration Matrix](#15-integration-matrix)
16. [Future AI Layer](#16-future-ai-layer)
17. [Technology Evaluation](#17-technology-evaluation)
18. [Risks](#18-risks)
19. [Migration Strategy](#19-migration-strategy)
20. [Implementation Plan](#20-implementation-plan)

---

## 1. Business Purpose

### 1.1 Why a Template Engine

The ERM system generates hundreds of document types: research protocols, consent forms, committee decisions, certificates, notifications, reports, correspondence, and accreditation evidence. Currently, these are handled by three disjoint systems:

| Existing System | Schema | Purpose | Limitation |
|---|---|---|---|
| `documents.templates` | `documents` | Document generation (PDF/HTML) | Flat structure, no versioning, no localization |
| `committee.consent_templates` | `committee` | Informed consent templates | Consent-specific, cannot be reused |
| `communication.notification_templates` | `communication` | Email/SMS/In-app messages | Channel-specific, no variable resolution |

Each system has its own schema, its own RLS policies, its own versioning (or lack thereof), and its own rendering logic. This fragmentation causes:

- Duplicate variable definitions (a researcher's name is resolved differently in three places)
- Inconsistent localization (Arabic consent templates and Arabic notifications have separate translation mechanisms)
- No cross-template reuse (a protocol template cannot reference a consent template)
- No unified audit trail (no single view of "what was generated when, by whom, from which template")
- No preview capability before generation
- No validation that templates are complete before use

### 1.2 Consuming Subsystems

Every subsystem below currently generates or will generate templated content. The unified Template Engine must serve all of them:

| # | Subsystem | Template Types Generated | Current Approach |
|---|---|---|---|
| 1 | Research Protocols | Protocol documents, study proposals | Hand-coded in seed |
| 2 | Consent Forms | Adult, child, parent, emergency, verbal, online | `committee.consent_templates` |
| 3 | Committee Decisions | Approval, conditional, revision, rejection letters | Inline generation |
| 4 | Approval Certificates | Ethics approval certificates | Puppeteer in seed |
| 5 | Conditional Approval Letters | Condition notification letters | Inline generation |
| 6 | Email Notifications | Submission, approval, reminder, alert emails | `communication.notification_templates` |
| 7 | In-App Notifications | System notifications, alerts | `communication.notification_templates` |
| 8 | SMS Notifications | Reminders, urgent alerts | `communication.notification_templates` |
| 9 | Reports | Quarterly, annual, committee activity, statistics | Custom generation |
| 10 | Workflow Messages | Status transition notifications | Inline generation |
| 11 | Meeting Minutes | Meeting records, agendas, attendance sheets | Inline generation |
| 12 | Risk Assessment Reports | Risk evaluation documents | Not yet built |
| 13 | Accreditation Reports | Site visit reports, CAPA documents | Not yet built |
| 14 | AI-Generated Documents | Draft protocols, summaries, suggestions | Future |

### 1.3 Design Goals

1. **Unify** all template handling into one bounded context
2. **Version** every template change as a first-class, immutable entity
3. **Localize** natively — every template can exist in multiple languages without duplication
4. **Resolve** variables automatically from business identifiers using a path resolution model (no raw SQL)
5. **Validate** before generation — no partial or broken templates
6. **Preview** before approval — no direct generation without human review
7. **Audit** every generation permanently with full snapshot
8. **Extend** to new output formats, variable sources, and AI integration without architecture changes

---

## 2. Domain Model

### 2.1 Bounded Context: `templates`

The Template Engine owns its own PostgreSQL schema: `templates`. No other schema owns template data. Existing template tables in `documents`, `committee`, and `communication` will be deprecated and migrated.

### 2.2 Entity Catalog

#### `templates.categories`

Template classification. A category defines the business purpose, required variables, output format defaults, and approval workflow.

| Column | Type | Description |
|---|---|---|
| `id` | `bigint PK` | Surrogate key |
| `code` | `varchar(50) UNIQUE` | Machine-readable code (e.g., `CONSENT_ADULT`, `DECISION_APPROVAL`) |
| `name_ar` | `varchar(500)` | Arabic display name |
| `name_en` | `varchar(500)` | English display name |
| `description` | `text` | Business purpose |
| `parent_category_id` | `bigint FK -> categories.id NULL` | Hierarchical grouping |
| `required_variables` | `jsonb` | Structured variable schema: `[{"name": "studyTitle", "type": "string", "required": true, "description": "..."}]` |
| `default_output_format` | `varchar(20)` | `PDF`, `DOCX`, `HTML`, `XLSX`, `TXT`, `EMAIL` |
| `approval_required` | `boolean` | Whether versions must be approved before use |
| `sort_order` | `integer` | Display ordering |
| `is_active` | `boolean` | Soft delete flag |
| `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by` | Standard audit | Per ERM convention |

**Relationships:**
- `parent_category_id` -> self-referencing (tree hierarchy)
- Referenced by `templates.template.category_id`

#### `templates.templates`

The template definition. This is the core entity — a named, versioned template with a specific content body.

| Column | Type | Description |
|---|---|---|
| `id` | `bigint PK` | Surrogate key |
| `category_id` | `bigint FK -> categories.id` | Template category |
| `code` | `varchar(100) UNIQUE` | Stable business code (e.g., `PROTOCOL_CROSS_SECTIONAL`) |
| `name_ar` | `varchar(500)` | Arabic display name |
| `name_en` | `varchar(500)` | English display name |
| `description` | `text` | Purpose and usage notes |
| `engine` | `varchar(50)` | Rendering engine: `handlebars` only (see Section 17). Extensible via TemplateService. |
| `default_locale` | `varchar(10)` | `ar`, `en`, `both` |
| `default_output_format` | `varchar(20)` | Override category default |
| `variable_sources` | `jsonb` | Auto-resolve configuration using path notation (NO SQL): `[{"key": "studyTitle", "path": "application.project.title_en", "type": "string"}]` |
| `tags` | `text[]` | Search/filter tags |
| `usage_count` | `integer DEFAULT 0` | Counter, incremented on each generation |
| `is_active` | `boolean` | Soft delete flag |
| Standard audit columns | | |

**Relationships:**
- `category_id` -> `templates.categories`
- Has many -> `templates.template_versions`
- Has many -> `templates.template_variables`
- Has many -> `templates.template_outputs`
- Has many -> `templates.template_partials` (reusable fragments)
- Has many -> `templates.template_package_members` (package membership)

#### `templates.template_versions`

Immutable version snapshots. Once a version transitions to `REVIEW`, its `content` and `variable_definitions` never change.

| Column | Type | Description |
|---|---|---|
| `id` | `bigint PK` | Surrogate key |
| `template_id` | `bigint FK -> templates.id` | Parent template |
| `version` | `varchar(20)` | Semantic version: `MAJOR.MINOR.PATCH` |
| `status` | `varchar(20)` | `DRAFT`, `REVIEW`, `APPROVED`, `DEPRECATED`, `ARCHIVED` |
| `content` | `jsonb` | Template content structure (see Section 2.4) |
| `content_hash` | `varchar(64)` | SHA-256 of the content (for integrity verification) |
| `variable_definitions` | `jsonb` | Structured variable schema: `[{"name": "studyTitle", "type": "string", "required": true, "resolver": {"path": "application.project.title_ar"}, "validationRules": {"minLength": 1}}]` |
| `change_summary` | `text` | Human-readable description of changes from previous version |
| `effective_from` | `timestamptz NULL` | When this version becomes active for generation |
| `effective_until` | `timestamptz NULL` | When this version ceases to be active (set on supersede/rollback) |
| `retired_at` | `timestamptz NULL` | When this version was superseded or archived |
| `approved_by` | `bigint FK -> security.users.id NULL` | Approver |
| `approved_at` | `timestamptz NULL` | Approval timestamp |
| `created_by` | `bigint FK -> security.users.id` | Author |
| `created_at` | `timestamptz` | Creation timestamp |

**Constraints:**
- `UNIQUE(template_id, version)` — one version number per template
- **Partial Unique Index:** `CREATE UNIQUE INDEX one_approved_version ON templates.template_versions (template_id) WHERE status = 'APPROVED';` — enforces exactly one APPROVED version per template at the database level
- `DRAFT` can be soft-deleted; `APPROVED` cannot — only deprecated or superseded
- `effective_from IS NULL OR effective_from <= NOW()` is required for generation eligibility (enforced in TemplateService + SECURITY DEFINER function)

**Immutability rule:** After a version transitions to `REVIEW` or higher:
- `content` and `variable_definitions` are locked via DB trigger
- `content_hash` is verified on every read
- Any change requires a new version

#### `templates.template_localizations`

Translations of approved version content. Each row corresponds to one language variant of one version.

| Column | Type | Description |
|---|---|---|
| `id` | `bigint PK` | |
| `template_version_id` | `bigint FK -> template_versions.id` | Parent version |
| `locale` | `varchar(10)` | `ar`, `en`, or future `fr`, `so` |
| `content` | `jsonb` | Translated content (same structure as version content) |
| `content_hash` | `varchar(64)` | SHA-256 |
| `is_verified` | `boolean DEFAULT false` | Whether a human verified the translation |
| `verified_by` | `bigint FK -> users.id NULL` | |
| `verified_at` | `timestamptz NULL` | |
| `created_at` | `timestamptz` | |

**Constraints:**
- `UNIQUE(template_version_id, locale)` — one translation per locale per version
- If `template_versions.content` uses Arabic/English mixed content, localizations are not required

#### `templates.template_variables`

Registry of all variables across all templates. Enables cross-template validation and discoverability.

| Column | Type | Description |
|---|---|---|
| `id` | `bigint PK` | |
| `code` | `varchar(100) UNIQUE` | Variable code used in templates: `studyTitle`, `piName` |
| `name_ar` | `varchar(500)` | Arabic display name |
| `name_en` | `varchar(500)` | English display name |
| `type` | `varchar(50)` | `string`, `number`, `date`, `boolean`, `array`, `object`, `enum` |
| `enum_values` | `jsonb NULL` | If type is `enum`: `["male", "female", "other"]` |
| `source_type` | `varchar(50)` | How this variable is resolved: `manual`, `entity`, `computed`, `context` |
| `resolver_path` | `varchar(500) NULL` | Path notation ONLY (e.g., `application.project.title_ar`). Must start with an allowed root from the Entity Whitelist (Section 5.4). NO SQL. |
| `resolver_function` | `varchar(100) NULL` | If `computed`: must reference a registered function from the Function Registry (Section 5.5). Must NOT be arbitrary code. No eval. |
| `resolver_function_args` | `jsonb NULL` | Arguments for the registered function |
| `entity_whitelist_root` | `varchar(100) NULL` | Allowed root entity (must be in whitelist per Section 5.4). Rejected at validation if unknown. |
| `default_value` | `jsonb NULL` | Default if not provided and not resolved |
| `description_ar` | `text` | Arabic description |
| `description_en` | `text` | English description |
| `required` | `boolean DEFAULT false` | Whether this variable must have a value |
| `validation_rules` | `jsonb NULL` | `{"minLength": 1, "maxLength": 500, "pattern": "^[A-Z].*"}` |
| `is_active` | `boolean` | |
| Standard audit columns | | |

**Entity Whitelist Enforcement:**
- `resolver_path` is validated against the path resolution model (Section 5.3) at template version submission time
- If the first segment of `resolver_path` is not in the Entity Whitelist (Section 5.4), validation fails with code `UNKNOWN_ENTITY_ROOT`
- No dynamic table names, no catalog access, no arbitrary SQL

#### `templates.template_partials`

Reusable template fragments that can be shared across templates. Partials are versioned independently.

| Column | Type | Description |
|---|---|---|
| `id` | `bigint PK` | |
| `template_id` | `bigint FK -> templates.id NULL` | If owned by one template; NULL = global/shared partial |
| `code` | `varchar(100) UNIQUE` | Machine code: `HEADER`, `FOOTER`, `SIGNATURE_BLOCK`, `COMMITTEE_MEMBERS` |
| `name_ar` | `varchar(500)` | |
| `name_en` | `varchar(500)` | |
| `engine` | `varchar(50)` | Must match parent template engine |
| `content` | `text` | Handlebars template fragment |
| `content_hash` | `varchar(64)` | SHA-256 |
| `version` | `varchar(20)` | Semver for the partial |
| `depends_on` | `varchar(100)[] NULL` | List of partial codes this partial references via `{{> partialCode}}` |
| `is_active` | `boolean` | |
| `created_at`, `created_by`, `updated_at`, `updated_by` | Standard audit | |

**Constraints:**
- Circular dependency prevention: validated at save-time. Partial A cannot reference Partial B if B (transitively) references A.
- Dependency resolution: the Renderer resolves partials before template body rendering, with a maximum nesting depth of 10.

#### `templates.template_packages`

A template package is a logical grouping of templates that execute together as one business action.

| Column | Type | Description |
|---|---|---|
| `id` | `bigint PK` | |
| `code` | `varchar(100) UNIQUE` | `DECISION_APPROVAL_PACKAGE` |
| `name_ar` | `varchar(500)` | |
| `name_en` | `varchar(500)` | |
| `description` | `text` | Purpose and orchestration rules |
| `is_active` | `boolean` | |
| Standard audit columns | | |

#### `templates.template_package_members`

Each package is composed of ordered template slots.

| Column | Type | Description |
|---|---|---|
| `id` | `bigint PK` | |
| `package_id` | `bigint FK -> template_packages.id` | |
| `template_code` | `varchar(100)` | Reference to template code (not FK — allows template to be soft-deleted) |
| `slot_order` | `integer` | Execution order within the package |
| `output_format` | `varchar(20)` | Format for this slot (each slot can have a different format) |
| `required` | `boolean DEFAULT true` | Whether failure in this slot blocks the entire package |
| `depends_on_slot` | `integer NULL` | If set, this slot runs only after the referenced slot completes |

**Package execution example** — "Approval Decision" package:
1. Slot 1: `DECISION_LETTER` -> PDF (must succeed)
2. Slot 2: `APPROVAL_CERTIFICATE` -> PDF (must succeed)
3. Slot 3: `DECISION_NOTIFICATION` -> EMAIL (optional, depends on slot 1)
4. Slot 4: `DECISION_EMAIL_COPY` -> EMAIL (optional)
5. Slot 5: `AUDIT_ARCHIVE` -> PDF (must succeed)

#### `templates.template_outputs`

Generated output records. Every call to generate a template produces one row.

| Column | Type | Description |
|---|---|---|
| `id` | `bigint PK` | |
| `template_version_id` | `bigint FK -> template_versions.id` | Version used |
| `locale` | `varchar(10)` | Output language |
| `output_format` | `varchar(20)` | `PDF`, `DOCX`, `HTML`, `XLSX`, `TXT`, `EMAIL` |
| `entity_type` | `varchar(100)` | Business entity type: must be in Entity Whitelist (Section 5.4) |
| `entity_id` | `bigint` | Business entity ID |
| `storage_path` | `varchar(1000)` | Path in the storage layer |
| `file_name` | `varchar(500)` | Original file name |
| `file_size_bytes` | `bigint` | |
| `checksum_sha256` | `varchar(64)` | SHA-256 of generated output file |
| `variables_hash` | `varchar(64)` | SHA-256 of the variables JSON (privacy-safe audit) |
| `rendered_html_hash` | `varchar(64) NULL` | SHA-256 of the intermediate rendered HTML (before output provider) |
| `digital_signature_ref` | `varchar(500) NULL` | Extension point: reference to external digital signature (not implemented — reserved for future) |
| `generated_by` | `bigint FK -> users.id` | Who triggered generation |
| `generated_at` | `timestamptz` | |
| `generation_duration_ms` | `integer` | Performance tracking |
| `status` | `varchar(20)` | `SUCCESS`, `FAILED`, `PARTIAL` |
| `error_message` | `text NULL` | If failed |

**Output Snapshot** — every output record captures:
- Template version used (FK)
- Variables hash (SHA-256)
- Rendered HTML hash (SHA-256 of intermediate HTML)
- Generated file hash (SHA-256 of final output)
- Generation timestamp
- Generator identity
- Output provider used
- Storage location

#### `templates.template_render_jobs`

Queue-based rendering. For asynchronous or batch generation.

| Column | Type | Description |
|---|---|---|
| `id` | `bigint PK` | |
| `template_version_id` | `bigint FK -> template_versions.id` | |
| `locale` | `varchar(10)` | |
| `output_format` | `varchar(20)` | |
| `entity_type` | `varchar(100)` | |
| `entity_id` | `bigint` | |
| `variables` | `jsonb` | The resolved variables used for this job |
| `priority` | `integer DEFAULT 0` | Higher = more urgent |
| `status` | `varchar(20)` | `QUEUED`, `PROCESSING`, `COMPLETED`, `FAILED` |
| `output_id` | `bigint FK -> template_outputs.id NULL` | Result |
| `error_message` | `text NULL` | |
| `queued_at` | `timestamptz` | |
| `started_at` | `timestamptz NULL` | |
| `completed_at` | `timestamptz NULL` | |
| `created_by` | `bigint FK -> users.id` | |

#### `templates.template_render_history`

Append-only log of all rendering operations. Never deleted. All FKs are denormalized to survive records deletion.

| Column | Type | Description |
|---|---|---|
| `id` | `bigint PK` | |
| `template_version_id` | `bigint` | Denormalized (no FK — survives template deletion) |
| `template_code` | `varchar(100)` | Denormalized |
| `version` | `varchar(20)` | Denormalized |
| `locale` | `varchar(10)` | |
| `output_format` | `varchar(20)` | |
| `entity_type` | `varchar(100)` | |
| `entity_id` | `bigint` | |
| `generated_by` | `bigint` | Denormalized |
| `generated_at` | `timestamptz` | |
| `variables_hash` | `varchar(64)` | |
| `rendered_html_hash` | `varchar(64) NULL` | |
| `output_id` | `bigint` | Denormalized |
| `storage_path` | `varchar(1000)` | |
| `checksum_sha256` | `varchar(64)` | |
| `duration_ms` | `integer` | |
| `status` | `varchar(20)` | |

#### `templates.template_approval_workflow`

Records the approval chain for each version. Supports multi-step approvals.

| Column | Type | Description |
|---|---|---|
| `id` | `bigint PK` | |
| `template_version_id` | `bigint FK -> template_versions.id` | |
| `step_order` | `integer` | Sequential |
| `approver_role` | `varchar(100)` | Required role to approve |
| `approver_id` | `bigint FK -> users.id NULL` | Specific user (if pre-assigned) |
| `status` | `varchar(20)` | `PENDING`, `APPROVED`, `REJECTED` |
| `comments` | `text NULL` | |
| `acted_by` | `bigint FK -> users.id NULL` | |
| `acted_at` | `timestamptz NULL` | |
| `created_at` | `timestamptz` | |

#### `templates.template_usage_statistics`

Aggregated usage data for analytics. Updated asynchronously.

| Column | Type | Description |
|---|---|---|
| `id` | `bigint PK` | |
| `template_id` | `bigint FK -> templates.id` | |
| `date` | `date` | Aggregation date |
| `generation_count` | `integer` | |
| `unique_users` | `integer` | |
| `avg_duration_ms` | `integer` | |
| `total_size_bytes` | `bigint` | |
| `by_format` | `jsonb` | `{"PDF": 45, "DOCX": 12}` |
| `by_locale` | `jsonb` | `{"ar": 30, "en": 27}` |

**Unique constraint:** `(template_id, date)`

#### `templates.template_version_audit`

Append-only audit of every version lifecycle transition.

| Column | Type | Description |
|---|---|---|
| `id` | `bigint PK` | |
| `template_version_id` | `bigint NOT NULL` | |
| `action` | `varchar(20) NOT NULL` | `CREATED`, `SUBMITTED`, `APPROVED`, `REJECTED`, `DEPRECATED`, `ARCHIVED`, `ROLLED_BACK`, `SUPERSEDED` |
| `actor_id` | `bigint NOT NULL` | |
| `previous_status` | `varchar(20)` | |
| `new_status` | `varchar(20)` | |
| `comment` | `text` | |
| `created_at` | `timestamptz NOT NULL DEFAULT NOW()` | |

#### `templates.template_validation_tests`

Automated template testing. Runs on every version promotion. A version cannot be approved if its tests fail.

| Column | Type | Description |
|---|---|---|
| `id` | `bigint PK` | |
| `template_version_id` | `bigint FK -> template_versions.id` | Version under test |
| `test_data` | `jsonb` | Mock variable values |
| `expected_output_hash` | `varchar(64) NULL` | Expected SHA-256 of rendered output |
| `expected_html_hash` | `varchar(64) NULL` | Expected SHA-256 of intermediate HTML |
| `test_description` | `text` | What this test validates |
| `last_run_at` | `timestamptz NULL` | |
| `last_result` | `varchar(10) NULL` | `PASS`, `FAIL`, `ERROR` |
| `last_error` | `text NULL` | |
| `last_output_hash` | `varchar(64) NULL` | Actual hash from last run |

### 2.3 Entity Relationship Diagram

```
+---------------------------+       +--------------------------------+
| categories                |       | template_variables             |
|---------------------------|       |--------------------------------|
| id (PK)                   |---+   | id (PK)                        |
| code (UNIQUE)             |   |   | code (UNIQUE)                  |
| name_ar, name_en          |   |   | type (inc. enum)               |
| parent_category_id(FK)    |---+   | source_type                    |
| required_variables(jsonb) |   |   | resolver_path (NO SQL)         |
| default_format            |   |   | resolver_function (Registry)   |
| approval_required         |   |   | entity_whitelist_root          |
| is_active                 |   |   | validation_rules (jsonb)       |
+---------------------------+   |   | enum_values (jsonb)            |
                                |   | is_active                      |
+---------------------------+   |   +--------------------------------+
| templates                  |   |
|---------------------------|   |   +--------------------------------+
| id (PK)                   |---+   | template_partials              |
| category_id (FK)          |---+   |--------------------------------|
| code (UNIQUE)             |   |   | id (PK)                        |
| name_ar, name_en          |   |   | template_id (FK, NULL)          |
| engine (handlebars)       |   |   | code (UNIQUE)                  |
| variable_sources (jsonb)  |   |   | content (handlebars fragment)   |
| is_active                 |   |   | version (semver)               |
+---------------------------+   |   | depends_on (text[])            |
                                |   | content_hash                   |
+-----------------------------+ |   +--------------------------------+
| template_versions             | |
|-----------------------------| |
| id (PK)                     |<+
| template_id (FK)            |---+
| version (semver)            |   |
| status                      |   |
| content (jsonb)             |   |
| content_hash                |   |   +--------------------------------+
| variable_defns (jsonb)      |   |   | template_localizations        |
| effective_from              |   |   |--------------------------------|
| effective_until             |   |   | id (PK)                        |
| approved_by/at              |   |   | template_version_id(FK)       |
+-----------------------------+   |   | locale                         |
   | Partial Unique Index        |   | content (jsonb)                |
   | (template_id) WHERE         |   | content_hash                   |
   | status = 'APPROVED'         |   | is_verified                    |
                                 |   +--------------------------------+
+-----------------------------+ |   +--------------------------------+
| template_packages            | |   | template_approval              |
|-----------------------------| |   |--------------------------------|
| id (PK)                     | |   | id (PK)                        |
| code (UNIQUE)               | |   | template_version_id(FK)        |
+-------------+---------------+ |   | step_order                     |
              |                 |   | approver_role                  |
+-------------v---------------+ |   | status                         |
| template_package_members     | |   +--------------------------------+
|-----------------------------| |
| id (PK)                     | |   +--------------------------------+
| package_id (FK)             | |   | template_outputs               |
| template_code (ref)         |--+   |--------------------------------|
| slot_order                  |     | id (PK)                        |
| output_format               |     | template_version_id(FK)        |
| depends_on_slot             |     | checksum_sha256                |
+-----------------------------+     | rendered_html_hash            |
                                    | variables_hash                 |
+---------------------------------+ | digital_signature_ref (ext)    |
| template_version_audit          | | generated_by/at                |
|---------------------------------| | status                         |
| id (PK)                         | +--------------------------------+
| template_version_id             |
| action / actor / prev->new      |
| created_at                      |
+---------------------------------+
```

### 2.4 Template Content Structure

The `content` field in `template_versions` and `template_localizations` uses a structured JSONB format that separates body, blocks, and metadata:

```json
{
  "body": "{{> header}}\n\n## Committee Decision\n\nNumber: {{decisionNumber}}\n\n{{> decisionBody}}\n\n{{> footer}}",
  "blocks": {
    "header": "{{committeeName}}\n{{committeeAddress}}",
    "decisionBody": "{{#if approved}}\nApproved.\n{{else}}\nRevision requested.\n{{/if}}",
    "footer": "---\nSignature: {{chairpersonName}}\nDate: {{today}}"
  },
  "metadata": {
    "pageSize": "A4",
    "margins": {"top": 20, "bottom": 20, "left": 15, "right": 15},
    "fontFamily": "Arial",
    "fontSize": 11,
    "rtl": true
  }
}
```

This structure enables:
- **Partial reuse**: `{{> blockName}}` references sub-templates within the same version or shared partials
- **Format-agnostic body**: The same content renders to PDF, DOCX, and HTML
- **Metadata-driven layout**: Rendering engines read `metadata` for format-specific options

---

## 3. Versioning Strategy

### 3.1 Version Identity

Versions are first-class entities (`templates.template_versions`), not JSON arrays. Each version is a distinct row with its own PK, audit trail, and status lifecycle.

### 3.2 Version Numbering

Use **Semantic Versioning** (`MAJOR.MINOR.PATCH`):

| Bump | When | Example |
|---|---|---|
| `MAJOR` | Breaking change: new required variables, structural redesign | `2.0.0` |
| `MINOR` | New optional variables, new blocks, non-breaking additions | `1.3.0` |
| `PATCH` | Bug fixes, typo corrections, translation fixes | `1.2.1` |

### 3.3 Version Lifecycle

```
[DRAFT] --> [REVIEW] --> [APPROVED] --> [DEPRECATED] --> [ARCHIVED]
   |            |              |
   +--(edit)--+               |
                              |
                     When superseded:
                     +--> [DEPRECATED] --> [ARCHIVED]
```

| Status | Meaning | Mutability | Generation Eligible |
|---|---|---|---|
| `DRAFT` | Being authored. Can edit, soft-delete, or submit for review. | Content mutable | NO |
| `REVIEW` | Submitted for approval. Content locked. | Immutable | NO |
| `APPROVED` | Approved if `effective_from <= NOW()` and `effective_until > NOW()` (or both NULL). | Immutable | YES (if within effective range) |
| `DEPRECATED` | Superseded. Still usable with warning. Outputs flagged. | Immutable | YES (with warning) |
| `ARCHIVED` | Historical only. Not usable for generation. | Immutable | NO |

### 3.4 Immutability Enforcement

- `content` and `variable_definitions` are locked after `REVIEW` via DB trigger
- `content_hash = SHA-256(content)` computed on write, verified on every read
- UPDATE to a `REVIEW` or `APPROVED` version returns an error at the database level via trigger
- The only way to change approved content is to create a new version

### 3.5 Partial Unique Index (Enforced at DB Level)

```sql
CREATE UNIQUE INDEX one_approved_version
  ON templates.template_versions (template_id)
  WHERE status = 'APPROVED';
```

This guarantees at the **database level** that no more than one `APPROVED` version exists per template at any time. Business logic alone is not sufficient -- the index prevents race conditions where two concurrent transactions could both approve different versions.

When a new version is approved:
1. The previously `APPROVED` version's status is set to `DEPRECATED` and `effective_until = NOW()`
2. The new version's status is set to `APPROVED`
3. The transaction commits, and the index constraint is re-verified

### 3.6 Rollback

- Rollback = promote a prior `APPROVED` version back to active
- Implementation:
  1. Set current `APPROVED` version to `DEPRECATED` with `effective_until = NOW()`
  2. Set target prior version to `APPROVED` with `effective_until = NULL` and `retired_at = NULL`
  3. Rollback does **not** modify prior outputs -- all outputs remain associated with the version that generated them
  4. Rollback creates an audit entry in `template_version_audit` with action `ROLLED_BACK`
- Rollback is **not** a data modification -- existing outputs are preserved and unchanged
- The previously-current version remains in `DEPRECATED` status (not deleted)

### 3.7 Effective Dates

- `effective_from`: when an approved version begins generating outputs
- `effective_until`: automatically set when a version is superseded or rolled back
- Future-dated versions: approved but not active until `effective_from` is reached (e.g., regulatory changes)
- Generation eligibility is computed as: `status = 'APPROVED' AND (effective_from IS NULL OR effective_from <= CURRENT_TIMESTAMP) AND (effective_until IS NULL OR effective_until > CURRENT_TIMESTAMP)`
- This logic is enforced in both the application layer (`TemplateService`) and via a `SECURITY DEFINER` generation function

### 3.8 DEPRECATED Behavior

- Still usable for generation (backward compatibility during migration)
- Each generation from a `DEPRECATED` version emits a warning log entry and sets `render_history.status = 'SUCCESS_WITH_WARNING'`
- The API response includes a `warning` field: "Template version X.Y.Z is deprecated. Upgrade to A.B.C."
- Cannot be reactivated (use rollback instead)

### 3.9 Audit Trail

Every version transition is recorded in `templates.template_version_audit`:

| Field | Value |
|---|---|
| `action` | `CREATED`, `SUBMITTED`, `APPROVED`, `REJECTED`, `DEPRECATED`, `ARCHIVED`, `ROLLED_BACK`, `SUPERSEDED` |
| `previous_status` | Status before transition |
| `new_status` | Status after transition |
| `actor_id` | User who performed the action |
| `created_at` | Timestamp |

---

## 4. Rendering Pipeline

### 4.1 Mandatory Abstraction: TemplateService

No subsystem may call Handlebars or any rendering engine directly. All template operations go through `TemplateService`:

```
Application / Workflow / Consent / Accreditation / Risk / Reports / Documents
    |                                       (or via Event Bus — see §4.7)
    v
+-----------------------------------------------------------------+
|                    TemplateService                               |
|  (sole entry point for ALL subsystems)                          |
|-----------------------------------------------------------------|
|  generate(templateCode, entityType, entityId,                   |
|           locale, format, vars, [eventContext?])                  |
|  preview(...) / validate(...) / getVersion(...)                  |
+-----------------------------------------------------------------+
    |
    v
+-----------------------------------------------------------------+
|                    ResolverRegistry                              |
|  selects domain resolver by entity root                          |
+-----------------------------------------------------------------+
    |
    v
+-----------------------------------------------------------------+
|  +------------------+  +-----------------+  +-----------------+  |
|  | Application      |  | Committee       |  | Workflow        |  |
|  | Resolver         |  | Resolver        |  | Resolver        |  |
|  +--------+---------+  +-------+---------+  +-------+---------+  |
|           |                     |                   |            |
|           v                     v                   v            |
|  +------------------+  +-----------------+  +-----------------+  |
|  | Application      |  | Committee       |  | Workflow        |  |
|  | Repository       |  | Repository      |  | Repository      |  |
|  +------------------+  +-----------------+  +-----------------+  |
|           |                     |                   |            |
|           +---------+-----------+-------------------+            |
|                     |                                             |
|                     v                                             |
|  +-----------------------------------------------------------+   |
|  |                        DTO Layer                          |   |
|  +-----------------------------------------------------------+   |
|                     |                                             |
|                     v                                             |
|  +-----------------------------------------------------------+   |
|  | Merge + Hash + Per-Request Cache                          |   |
|  +-----------------------------------------------------------+   |
+-----------------------------------------------------------------+
    |
    v
+-----------------------------------------------------------------+
|                    Validator                                     |
|  (variable completeness, type checking, placeholder scan)        |
+-----------------------------------------------------------------+
    |
    v
+-----------------------------------------------------------------+
|  +-----------------------------------------------------------+  |
|  |  Compiled Template Cache                                  |  |
|  |  (Handlebars.compile() result, keyed by version_id        |  |
|  |   + locale, LRU eviction, invalidation on mutation)       |  |
|  +-----------------------------------------------------------+  |
|            |                                                    |
|            v                                                    |
|  +-----------------------------------------------------------+  |
|  |  Renderer (Handlebars)                                    |  |
|  |  (replaceable engine behind TemplateService)               |  |
|  +-----------------------------------------------------------+  |
+-----------------------------------------------------------------+
    |
    v
+-----------------------------------------------------------------+
|                    Output Provider                               |
|  (PDF via Puppeteer pool / DOCX / HTML / EMAIL / ...)            |
+-----------------------------------------------------------------+
    |
    v
+-----------------------------------------------------------------+
|                    Storage + Audit                               |
|  (output snapshot: version, vars hash, HTML hash,               |
|   file hash, timestamp, generator, provider, location)           |
+-----------------------------------------------------------------+
```

### 4.2 Pipeline Overview

```
+----------+   +------------------+   +--------------------+   +-----------+   +----------------+
| Request  |-->| Compiled         |-->| ResolverRegistry  |-->| Validator |-->| Renderer       |
| (entity, |   | Template Cache   |   | → DomainResolver |   | (checks   |   | (Handlebars    |
| template,|   | lookup / compile |   | → Repository →DTO|   | content   |   | via cache)     |
| format)  |   +------------------+   +--------------------+   | & vars)   |   +--------+-------|
+----------+                                                  +-----------+            |
        |         ↑                                                                     v
        |         |                                                            +--------+--------+
        |   +------------------------------------------------------------+    |   Compiled      |
        +-->| Event Bus (optional): APPLICATION_SUBMITTED, etc. →        |    |   Template      |
            | TemplateService subscriber (see §4.7)                        |    |   Cache Store   |
            +------------------------------------------------------------+    +-----------------+
+----------+   +----------+   +----------+
|  Output  |-->| Storage  |-->| Audit +  |
| Provider |   | (path +  |   | Stats    |
|          |   |  hash)   |   |          |
+----------+   +----------+   +----------+
```

### 4.3 Stage Details

#### Stage 1: Request (via TemplateService)

Input contract (the API call):

```json
{
  "templateCode": "DECISION_APPROVAL",
  "entityType": "application",
  "entityId": 1042,
  "locale": "ar",
  "outputFormat": "PDF",
  "variables": {
    "customMessage": "Thank you for your cooperation"
  }
}
```

**Processing:**
1. Lookup the latest `APPROVED` version of `templateCode` (or specified version)
2. Verify entity type is in Entity Whitelist (Section 5.4)
3. Verify the locale is supported (either in version content or localizations)
4. Verify generation eligibility (`status = APPROVED` AND `effective_from <= NOW()` AND (`effective_until` IS NULL OR `effective_until > NOW()`))
5. Check generation authorization (multi-stage per Section 10.3)
6. Create `template_render_jobs` record (status: `QUEUED`)

#### Stage 2: Compiled Template Cache

The pipeline checks the Compiled Template Cache **first** to avoid re-compilation:

- **Cache key:** `hash(template_version_id + locale + engine)`
- **Cache hit:** use pre-compiled Handlebars template (avoids re-compilation)
- **Cache miss:** compile `content` + localizations + partials to Handlebars template, store in cache, proceed
- **Cache invalidation:** when version status changes (`DRAFT` -> `REVIEW` -> `APPROVED`) or when content is mutated
- **Cache scope:** in-memory LRU with configurable max size (default: 500 templates)
- **Cache eviction:** LRU + explicit invalidation on version mutation

This prevents re-compiling Handlebars templates (an O(n) parse operation) on every request.

#### Stage 3: ResolverRegistry + Domain Resolvers

**Input:** Template version ID + Entity type/ID + Optional override variables
**Output:** Complete variable map using Path Resolution Model (NO SQL)

1. Load `variable_sources` from the template version
2. **ResolverRegistry** groups variables by root entity and selects the correct domain resolver for each group
3. For each variable group:
   - `manual`: use provided value (or fail if required and missing)
   - `entity`: domain resolver resolves via path resolution (Section 5.3) through the repository layer (Section 5.3.1) — path only, no SQL exposed
   - `computed`: apply registered function from Function Registry (Section 5.5)
   - `context`: resolve from request context (user, roles, time)
4. **Batch resolution**: `ResolverRegistry` coordinates per-domain batch retrieval (Section 5.6) — each domain resolver calls one repository method that eager-loads all required joins
5. Per-request cache: `(entity_type, entity_id)` cache avoids duplicate retrieval across variables
6. Merge with override variables (override variables win)
7. Produce `variables_hash = SHA-256(JSON.stringify(variables))`

#### Stage 4: Validation

**Input:** Template version + Resolved variables + Locale
**Output:** Validation report (pass/fail + details)

1. Check every `required` variable has a non-null value
2. Check variable types match definitions (including enum validation)
3. Scan template content for unresolved `{{...}}` placeholders not in the variable map
4. If localized: check all blocks have translations
5. Check no circular `{{> block}}` references (depth limit = 10)
6. Check partial dependency graph for cycles
7. Return structured errors: `[{path: "body", code: "MISSING_VARIABLE", detail: "studyTitle"}]`

#### Stage 5: Rendering

**Input:** Validated template content + Variables + Locale
**Output:** Rendered HTML string

1. Retrieve compiled template from cache (or compile on miss)
2. Load content (use localization if available, otherwise version content)
3. Process partial references: recursively resolve `{{> partialCode}}` using registered partials
4. Render with variables
5. Compute `rendered_html_hash = SHA-256(renderedHTML)`
6. Return rendered HTML

The rendering engine produces HTML as an intermediate format. Format-specific output happens in Stage 6.

#### Stage 6: Output Provider

**Input:** Rendered HTML + Metadata (page size, margins, etc.)
**Output:** Final file buffer

| Format | Provider | Tool |
|---|---|---|
| `PDF` | `PdfProvider` | Puppeteer (printBackground: true, connection pool) |
| `DOCX` | `DocxProvider` | HTML to DOCX conversion (via html-docx-js or similar) |
| `HTML` | `HtmlProvider` | Return as-is (with embedded CSS) |
| `XLSX` | `XlsxProvider` | For tabular templates only |
| `TXT` | `TxtProvider` | Strip HTML tags |
| `EMAIL` | `EmailProvider` | Wrap in email template with headers |

Each provider:
- Receives: rendered HTML + metadata + format options
- Returns: `{ buffer: Buffer, format: string, extension: string }`

#### Stage 7: Storage

1. Compute `checksum_sha256` from the output buffer
2. Generate storage path: `templates/{category_code}/{template_code}/{version}/{locale}/{entity_type}_{entity_id}_{timestamp}.{ext}`
3. Write buffer to storage (filesystem or S3-compatible)
4. Record `template_outputs` row with: storage path, `checksum_sha256`, `rendered_html_hash`, `variables_hash`

#### Stage 8: Audit + Statistics

1. Append immutable record to `template_render_history` (includes output snapshot: template version, variables hash, rendered HTML hash, file hash, timestamp, generator, output provider, storage location)
2. Increment `usage_count` on the template
3. Update daily aggregation in `template_usage_statistics`

### 4.4 Error Handling per Stage

| Stage | Failure Behavior | Retryable |
|---|---|---|
| Request | Return validation error immediately | No |
| Cache | Fall through to compile (cache miss) | N/A |
| Resolver | Mark job FAILED, return structured error with failed variable paths | Yes (transient DB errors) |
| Validator | Return validation error, mark job FAILED | No (content error) |
| Renderer | Mark job FAILED, include Handlebars error message | No (template error) |
| Output Provider | Return PARTIAL status if non-critical (email failure), FAILED if critical (PDF) | Yes (transient) |
| Storage | If storage write fails, mark FAILED, preserve in retry queue | Yes |
| Audit | If audit write fails, critical error, rollback storage write | Yes |

### 4.5 Sync vs Async

- **Synchronous mode:** All stages execute within the HTTP request lifetime. Used for preview and real-time generation.
- **Asynchronous mode:** Stages 1-3 execute synchronously (validate + create job). Stages 4-8 execute via job queue. Used for batch and high-latency outputs (PDF via Puppeteer).
- API response for async: `{ jobId: 123, status: "QUEUED" }`
- Client polls `GET /api/v1/templates/jobs/:jobId` for completion

### 4.6 Pipeline Timeout

| Stage | Timeout |
|---|---|
| Request + Cache | 2s |
| Resolver | 10s |
| Validator | 3s |
| Renderer | 10s |
| Output Provider (PDF) | 60s |
| Output Provider (other) | 30s |
| Storage | 10s |
| Total (sync mode) | 120s max |

### 4.7 Event-Driven Generation

Template generation must not be invoked directly from business modules. Instead, an **event-driven architecture** decouples business domain events from document generation:

```
Business Module                      Event Bus
     |                                    |
     v                                    v
Workflow: APPLICATION_APPROVED ──────>  ┌─────────────────┐
Process: APPLICATION_SUBMITTED ──────>  │  Event Bus       │
Accreditation: GRANTED ──────────────>  │  (in-process or  │
Consent: CONSENT_APPROVED ──────────>  │   message queue)  │
Risk: RISK_ESCALATED ───────────────>  └────────┬──────────┘
Reports: REPORT_DUE ─────────────────>         |
User Action: GENERATE_DOCUMENT ────────┐        |
                                       │        v
                                       │  ┌───────────────────────┐
                                       └─>│ TemplateService       │
                                          │ Subscriber            │
                                          │                       │
                                          │ onEvent(event) {      │
                                          │   generate(           │
                                          │     event.templateCode,│
                                          │     event.entityType, │
                                          │     event.entityId,   │
                                          │     ...               │
                                          │   )                   │
                                          │ }                     │
                                          └───────────────────────┘
```

**Supported domain events:**

| Event | Source Module | Triggered When | Template Mapping |
|-------|-------------|----------------|------------------|
| `APPLICATION_SUBMITTED` | Workflow | Application transitions to SUBMITTED | Submission confirmation, PI notification |
| `APPLICATION_APPROVED` | Workflow | Application transitions to APPROVED | Decision letter, approval certificate, email notification |
| `APPLICATION_REJECTED` | Workflow | Application transitions to REJECTED | Rejection letter, PI notification |
| `APPLICATION_CONDITIONS_ISSUED` | Workflow | Conditions attached to approval | Conditional approval letter, condition list |
| `CONSENT_APPROVED` | Consent | Consent record signed/approved | Consent form copy, confirmation receipt |
| `SUBMIT_EVIDENCE_ACCEPTED` | Workflow | Evidence upload accepted under conditions | Evidence acknowledgement letter |
| `ACCREDITATION_GRANTED` | Accreditation | Accreditation status set to GRANTED | Certificate of accreditation, notification |
| `ACCREDITATION_EXPIRED` | Accreditation | Accreditation validity period ends | Expiry notification, renewal reminder |
| `ACCREDITATION_REVOKED` | Accreditation | Accreditation status set to REVOKED | Revocation letter, institution notification |
| `RISK_ESCALATED` | Risk | Risk score crosses escalation threshold | Risk escalation report, committee alert |
| `COMMITTEE_DECISION_ISSUED` | Committee | Decision recorded for an application | Decision letter, minutes entry |
| `MEETING_MINUTES_AVAILABLE` | Committee | Meeting minutes approved | Minutes document, attendee notification |
| `RENEWAL_REMINDER` | Workflow (scheduler) | Periodic renewal reminder | Renewal notice, payment reminder |
| `REPORT_DUE` | Reports (scheduler) | Scheduled report generation | Periodic report |

**Subscriber contract:**

```
interface TemplateEventSubscriber {
  onEvent(event: DomainEvent): Promise<void>;
}

interface DomainEvent {
  type: string;              // e.g. "APPLICATION_APPROVED"
  entityType: string;        // e.g. "application"
  entityId: number;
  occurredAt: Date;
  metadata?: Record<string, unknown>;
}
```

**Design rules:**

1. The business module publishes events **without knowing** who subscribes — no dependency on TemplateService
2. `TemplateService` subscribes to the Event Bus and maps event types to template codes via configuration (`event_template_mapping` table or config file)
3. The subscriber calls `TemplateService.generate()` — the same method used for direct API invocation
4. Direct API generation (e.g., user clicking "Generate PDF" in the UI) remains supported alongside event-driven generation
5. Event bus implementation can be in-process (Node `EventEmitter` for development) or external (RabbitMQ, Redis Pub/Sub, SQS for production)
6. If event processing fails (template not found, generation error), the error is logged to `template_render_history` with status `EVENT_FAILED` and the event is retried (configurable: 3 attempts, exponential backoff)
7. Events include the `entityType` and `entityId` — the ResolverRegistry fetches all variable data via repositories, not from the event payload

**Advantages over direct invocation:**
- Business modules remain independent from document generation
- New document types can be triggered without modifying business code (add a new event mapping)
- Failed generation does not block the business transaction that triggered it
- Audit trail shows both the event source and the generation result

### 5.1 Design Principle

The Resolver must NOT require callers to manually provide every variable. Callers supply only a business entity identifier (e.g., `applicationId: 1042`). The Resolver autonomously fetches all dependent values using the template `variable_sources` configuration through a **Path Resolution Model** -- no SQL, no dynamic execution, no arbitrary code.

All resolution goes through three mandatory layers:

```
Resolver
   ↓
Repository (domain-specific, no SQL exposure)
   ↓
DTO (data transfer object)
   ↓
TemplateService
```

### 5.2 Resolver Registry & Domain Resolvers

The Resolver does NOT use a monolithic switch statement. Instead, a **ResolverRegistry** selects the correct domain-specific resolver based on the entity root. Each domain resolver knows only its own entity graph and delegates all persistence to the corresponding repository. This keeps the architecture open for future modules without modifying existing resolvers.

```
+---------------------------------------------------------------+
| TemplateService                                                |
|   (sole entry point — calls ResolverRegistry)                  |
+---------------------------------------------------------------+
                            |
                            v
+---------------------------------------------------------------+
| ResolverRegistry                                               |
|   - Selects domain resolver by entity root                     |
|   - Orchestrates batch grouping across resolvers               |
|   - Manages per-request cache: (entity_type, entity_id)        |
|   - Coordinates multi-root resolution (e.g., application + user)|
+---------------------------------------------------------------+
         |              |              |               |
         v              v              v               v
+----------------+ +----------------+ +-------------+ +----------------+
| Application    | | Committee      | | Workflow    | | Consent        |
| Resolver       | | Resolver       | | Resolver    | | Resolver       |
| - application  | | - committee    | | - workflow  | | - consent      |
| - project      | | - meeting      | | - user      | | - application  |
| - institution  | | - review       | |             | | - document     |
| - department   | |                | |             | |                |
+-------+--------+ +-------+--------+ +------+------+ +-------+--------+
        |                  |                |                 |
        v                  v                v                 v
+----------------+ +----------------+ +-------------+ +----------------+
| Application    | | Committee      | | Workflow    | | Consent        |
| Repository     | | Repository     | | Repository  | | Repository     |
+----------------+ +----------------+ +-------------+ +----------------+
        |                  |                |                 |
        v                  v                v                 v
+---------------------------------------------------------------+
|                        DTO Layer                               |
|   (domain objects returned by repositories, consumed by        |
|    resolvers and merged into TemplateService variable map)     |
+---------------------------------------------------------------+
        |                  |                |                 |
        +------------------+-------+--------+-----------------+
                                   |
                                   v
+---------------------------------------------------------------+
| Merge + Hash                                                   |
| (override variables win, SHA-256 of variable JSON)             |
+---------------------------------------------------------------+
```

**Registry behavior:**
- `ResolverRegistry.select(rootEntity: string): DomainResolver` — maps entity root (e.g., `"application"`) to the correct resolver (e.g., `ApplicationResolver`)
- Unknown roots are rejected with `UNKNOWN_ENTITY_ROOT` before any resolver is invoked
- Adding a new root entity requires: (1) new `DomainResolver` implementation, (2) registration in `ResolverRegistry`, (3) whitelist update, (4) re-validation of affected templates
- No existing resolver code is modified when adding a new domain — open for extension, closed for modification

**Domain resolver responsibilities:**
- Each resolver owns its entity graph (e.g., `ApplicationResolver` knows about `application → project → institution → department`)
- Translates path segments into repository calls (e.g., `application.project.title_ar` → `ApplicationRepository.findWithProject(id)`)
- Does **NOT** execute SQL, access DB tables, or reference `pg`/`knex` directly
- Returns resolved variables as a plain object merged by `ResolverRegistry`

### 5.3 Path Resolution Model (NO SQL)

All entity variable resolution uses **dotted path notation** only. The domain resolver internally translates paths to repository calls -- never exposes SQL.

**Path format:**
```
{rootEntity}.{joinPath}.{field}
```

**Examples:**
```
application.title
application.reference_number
application.principalInvestigator.fullName
application.project.title_ar
committee.chair.email
workflow.currentState
risk.overallScore
user.displayName
```

**How the domain resolver handles paths:**
1. The `ResolverRegistry` selects the correct domain resolver based on the entity root
2. The domain resolver validates the root against the Entity Whitelist (Section 5.4)
3. The domain resolver parses the remaining segments and calls the appropriate **repository method** (Section 5.3.1)
4. For example, `application.project.title_ar` is resolved as:
   - `ResolverRegistry.select("application")` → `ApplicationResolver`
   - `ApplicationResolver.resolve("project.title_ar", entityId)` → calls `ApplicationRepository.findWithProject(entityId)`
   - The repository returns a DTO containing both `application` and `project` data
   - The resolver extracts `project.title_ar` from the DTO
5. The repository is the **ONLY** component with database knowledge. The resolver knows only entity relationships and DTO shapes.

### 5.3.1 Repository-Based Resolution

Domain resolvers must NOT execute SQL, know table names, or reference database drivers directly. All persistence knowledge is encapsulated in domain-specific repositories.

**Mandatory flow:**

```
Path: application.project.title_ar

ApplicationResolver.resolve("project.title_ar", entityId)
    ↓
ApplicationRepository.findWithProject(entityId)    ← ONLY this knows SQL/tables
    ↓
ApplicationWithProjectDTO {                         ← DTO returned to resolver
    application: { id, title, ... },
    project: { id, title_ar, title_en, ... }
}
    ↓
TemplateService extracts project.title_ar           ← Final variable value
```

**Repository contracts per domain:**

| Domain | Repository | Sample Methods | Returns |
|--------|-----------|----------------|---------|
| Application | `ApplicationRepository` | `findWithProject(id)`, `findWithInvestigator(id)`, `findFullApplication(id)` | `ApplicationDTO`, `ApplicationWithProjectDTO` |
| Committee | `CommitteeRepository` | `findWithMembers(id)`, `findWithMeetings(id)` | `CommitteeDTO`, `CommitteeWithMembersDTO` |
| Workflow | `WorkflowRepository` | `findStateByEntity(entityType, id)` | `WorkflowStateDTO` |
| Consent | `ConsentRepository` | `findWithApplication(id)`, `findWithDocuments(id)` | `ConsentDTO`, `ConsentWithApplicationDTO` |
| Risk | `RiskRepository` | `findWithMitigations(id)`, `findByApplication(id)` | `RiskDTO`, `RiskWithMitigationsDTO` |
| Document | `DocumentRepository` | `findWithEntity(entityType, id)` | `DocumentDTO` |

**Rules:**
- A repository method never returns raw `Row[]` — always typed DTOs
- A domain resolver never calls `db.query()`, `pool.query()`, or any SQL string
- Join logic is encapsulated in repository methods, not scattered across resolvers
- DTOs are plain objects (no ORM classes) to ensure serialisability for audit hashing

### 5.4 Entity Whitelist (Strict)

Only the following root entities are allowed. Any unknown root is rejected at validation time.

| Root | Description | Example Fields |
|---|---|---|
| `application` | Research application | `title`, `referenceNumber`, `currentStatus`, `submittedAt` |
| `project` | Research project | `titleAr`, `titleEn`, `riskLevel`, `fundingSource` |
| `committee` | Review committee | `nameAr`, `nameEn`, `address` |
| `meeting` | Committee meeting | `date`, `agenda`, `minutes` |
| `review` | Application review | `result`, `comments`, `assignedReviewer` |
| `consent` | Consent record | `type`, `status`, `signedDate` |
| `risk` | Risk assessment | `overallScore`, `level`, `mitigationPlan` |
| `accreditation` | Accreditation record | `status`, `validUntil`, `findings` |
| `institution` | Institution | `nameAr`, `nameEn`, `address` |
| `department` | Department | `nameAr`, `nameEn` |
| `document` | Existing document record | `title`, `type`, `uploadedAt` |
| `notification` | Notification record | `type`, `channel`, `sentAt` |
| `workflow` | Workflow state | `currentState`, `previousState`, `transitionedAt` |
| `user` | Current authenticated user | `displayName`, `email`, `title`, `department` |
| `organization` | Organization | `nameAr`, `nameEn` |

**Enforcement:**
- At template version submission time (Section 6.2), every `resolver_path` is checked against this whitelist
- Unknown roots produce error code `UNKNOWN_ENTITY_ROOT`
- No dynamic table names allowed -- the `entity.` generic prefix from v1.0 is **removed**
- No `pg_catalog`, `information_schema`, or system catalogs accessible
- Adding a new root entity requires: (1) new `DomainResolver` implementation, (2) registration in `ResolverRegistry`, (3) whitelist update, (4) re-validation of affected templates

### 5.5 Function Registry (No Arbitrary Code)

Computed variables use only registered functions. No `fn` strings, no `eval()`, no `new Function()`.

**Registered Functions:**

| Key | Signature | Description | Example Usage |
|---|---|---|---|
| `FORMAT_DATE` | `(value: string, locale: string) => string` | Format date with locale | `FORMAT_DATE("2025-01-15", "ar-SA")` |
| `FORMAT_TIME` | `(value: string, locale: string) => string` | Format time with locale | `FORMAT_TIME("14:30", "en")` |
| `FORMAT_CURRENCY` | `(value: number, currency: string, locale: string) => string` | Format currency | `FORMAT_CURRENCY(5000, "SAR", "ar")` |
| `CONCAT` | `(...args: string[]) => string` | Concatenate strings | `CONCAT(studyTitle, " - ", piName)` |
| `JOIN` | `(array: any[], separator: string) => string` | Join array | `JOIN(members, ", ")` |
| `UPPERCASE` | `(value: string) => string` | Convert to uppercase | `UPPERCASE(studyTitle)` |
| `LOWERCASE` | `(value: string) => string` | Convert to lowercase | `LOWERCASE(email)` |
| `TITLE_CASE` | `(value: string) => string` | Convert to title case | `TITLE_CASE(piName)` |
| `IF` | `(condition: boolean, trueVal: any, falseVal: any) => any` | Conditional | `IF(isApproved, "Approved", "Rejected")` |
| `DEFAULT` | `(value: any, defaultVal: any) => any` | Default value | `DEFAULT(phoneNumber, "N/A")` |
| `TRANSLATE` | `(key: string, locale: string) => string` | Lookup translation | `TRANSLATE("approval.status", locale)` |
| `COUNT` | `(array: any[]) => number` | Count array elements | `COUNT(conditions)` |

**Registration:**
- Functions are registered programmatically in the Resolver at startup
- Each function has: `{ key: string, handler: Function, arity: number, description: string }`
- Registration is done in code, not in configuration (prevents injection)

**Lookup:**
- When processing a `computed` variable, the Resolver looks up `resolver_function` in the Registry
- If not found: validation error `UNKNOWN_FUNCTION`
- If arity mismatch: validation error `INVALID_FUNCTION_ARITY`

**Validation:**
- At template submission, all `resolver_function` values are checked against the Registry
- Arguments are validated for type compatibility
- Circular references between computed variables are detected via topological sort

**Execution:**
- The Resolver calls the registered function with the provided arguments
- Execution is sandboxed (no access to `process`, `fs`, `db`, or network)
- Each function has a timeout of 500ms

### 5.6 Batch Variable Resolution

To avoid N+1 query problems, the `ResolverRegistry` orchestrates batch retrieval across domain resolvers and their repositories.

**Algorithm:**
1. **Collect**: `ResolverRegistry` gathers all `entity`-type variable paths from `variable_sources`
2. **Group**: group by root entity (e.g., all `application.*` paths → `ApplicationResolver`)
3. **Delegate**: `ResolverRegistry` calls the appropriate domain resolver with the grouped paths and entity IDs
4. **Batch repository call**: the domain resolver calls a single repository method that eager-loads all required joins (e.g., `ApplicationRepository.findFullApplication(id)` returns a DTO with project, investigator, institution, department)
5. **Map**: the domain resolver populates each variable from the DTO
6. **Cache**: `ResolverRegistry` maintains a per-request cache keyed by `(entity_type, entity_id)` so repeated references to the same entity across different template variables use cached data
7. **Resolve dependencies**: computed variables processed in topological order
8. **Validate**: ensure all required variables are resolved

### 5.7 Recursive Resolution

Variables can reference other variables:

```json
{
  "key": "fullTitle",
  "type": "computed",
  "resolver_function": "CONCAT",
  "resolver_function_args": ["studyTitle", " -- ", "piName"]
}
```

The Resolver must:
1. Build a dependency graph of variables
2. Resolve in topological order
3. Detect circular dependencies (fail with `CIRCULAR_VARIABLE_REFERENCE`)
4. Timeout after 5s for resolution

---

## 6. Validation Engine

### 6.1 Validation Stages

Validation occurs at two distinct points:

1. **Save-time validation** (when a version is submitted for review)
2. **Generation-time validation** (when a render is requested)

### 6.2 Save-Time Validation

Triggered when a version transitions from `DRAFT` to `REVIEW`.

| Check | Logic | Error Code |
|---|---|---|
| Content structure | JSON must parse with valid `body`, `blocks`, `metadata` | `INVALID_CONTENT_STRUCTURE` |
| Variable syntax | Scan for `{{...}}` patterns, extract variable names | `MALFORMED_PLACEHOLDER` |
| Block references | Every `{{> name}}` must have a matching block definition | `UNDEFINED_BLOCK` |
| Circular blocks | Block A to Block B to Block A | `CIRCULAR_BLOCK_REFERENCE` |
| Variable definitions | Every `{{var}}` in content must exist in `variable_definitions` | `UNDEFINED_VARIABLE` |
| Required variables | At minimum, category `required_variables` must be present | `MISSING_CATEGORY_VARIABLE` |
| Translation coverage | If locale is `both`, both localizations must be present | `INCOMPLETE_LOCALIZATION` |
| **Path validity** | `resolver_path` must start with an allowed whitelist root | `UNKNOWN_ENTITY_ROOT` |
| **Path syntax** | `resolver_path` must be valid dotted notation (no SQL, no special chars) | `INVALID_PATH_SYNTAX` |
| **Function registry** | `resolver_function` must be in Function Registry | `UNKNOWN_FUNCTION` |
| **Variable schema** | Variable `type` must be one of: `string`, `number`, `date`, `boolean`, `array`, `object`, `enum` | `INVALID_VARIABLE_TYPE` |
| **Enum values** | If type is `enum`, `enum_values` must be non-empty | `MISSING_ENUM_VALUES` |
| **Validation rules** | `validation_rules` must be consistent with type | `INVALID_VALIDATION_RULE` |
| **Partial dependency** | Partial dependency graph must have no cycles | `CIRCULAR_PARTIAL_REFERENCE` |
| Reference integrity | `resolver_path` paths must map to known entity fields | `INVALID_PATH_REFERENCE` |

### 6.3 Generation-Time Validation

Triggered before every render.

| Check | Logic | Error Code |
|---|---|---|
| Version status | Must be `APPROVED` | `VERSION_NOT_APPROVED` |
| Effective dates | `effective_from <= NOW()` AND (`effective_until` IS NULL OR `effective_until > NOW()`) | `VERSION_NOT_YET_EFFECTIVE` / `VERSION_EXPIRED` |
| Required variables | All `required: true` variables have non-null values | `MISSING_REQUIRED_VARIABLE` |
| Variable types | Values match declared types (including enum) | `TYPE_MISMATCH` |
| Enum values | If type `enum`, value must be in `enum_values` | `INVALID_ENUM_VALUE` |
| Validation rules | Apply `validation_rules` (minLength, maxLength, pattern) | `VALIDATION_RULE_FAILED` |
| Unresolved placeholders | No `{{...}}` remaining after resolution | `UNRESOLVED_PLACEHOLDER` |
| Locale exists | Requested locale has content or is the default | `UNSUPPORTED_LOCALE` |
| Entity exists | `entityType`/`entityId` resolves to a real DB record | `ENTITY_NOT_FOUND` |
| Entity permissions | Current user has permission on the entity (multi-stage per Section 10.3) | `PERMISSION_DENIED` |

### 6.4 Validation Response

```json
{
  "valid": false,
  "errors": [
    {
      "path": "variable_definitions[2].resolver_path",
      "code": "UNKNOWN_ENTITY_ROOT",
      "variable": "piPhone",
      "detail": "Path 'personnel.phone' starts with 'personnel' which is not in the Entity Whitelist"
    },
    {
      "path": "variable_definitions[3].resolver_function",
      "code": "UNKNOWN_FUNCTION",
      "variable": "fullTitle",
      "detail": "Function 'EVAL' is not in the Function Registry"
    },
    {
      "path": "body",
      "code": "MISSING_REQUIRED_VARIABLE",
      "variable": "studyTitle",
      "detail": "Variable 'studyTitle' is required but was not provided and has no default"
    }
  ],
  "warnings": [
    {
      "path": "variable_definitions.phoneNumber",
      "code": "UNUSED_VARIABLE",
      "detail": "Variable 'phoneNumber' is defined but never used in template content"
    }
  ]
}
```

### 6.5 Validation Testing

The template engine includes `templates.template_validation_tests` for automated template testing. Tests run on every version promotion to `REVIEW`. A version cannot be approved if its tests fail.

---

## 7. Preview Engine

### 7.1 Preview Workflow

```
User edits template
    |
    v
[Preview Request] --> Render with SAMPLE data --> Display HTML/PDF
    |
    v
[User edits again] --> [Preview again]
    |
    v
[Submit for Review] --> Version locked --> Approval workflow
    |
    v
[Approve] --> Version status -> APPROVED
    |
    v
[Generate] --> Render with REAL data --> Store --> Audit
```

### 7.2 Sample Data Provider

Every template version can define `sample_data` for preview:

```json
{
  "studyTitle": "Sample Study Title",
  "piName": "Dr. Ahmed Mohammed",
  "committeeName": "Ethics Committee",
  "decisionDate": "2025-01-15",
  "members": [
    {"name": "Dr. Ahmed Mohammed", "role": "Chair"},
    {"name": "Dr. Sarah Abdullah", "role": "Vice Chair"}
  ]
}
```

Sample data:
- Is stored alongside the version (optional field in `template_versions`)
- Contains realistic but fictional data
- Is used ONLY for preview -- never for production generation
- Can be auto-generated from real data (anonymized) for realistic preview

### 7.3 Preview Endpoint

```
POST /api/v1/templates/{code}/versions/{version}/preview
```

### 7.4 Preview Modes

| Mode | Data Source | Use Case |
|---|---|---|
| `sample` | `sample_data` from version | Authoring, anonymous demo |
| `real` | Real entity from DB | "What will this look like for application X?" |
| `custom` | User-provided variables | Testing edge cases |

---

## 8. Output Providers

### 8.1 Provider Interface

Every output provider implements a single interface:

```typescript
interface OutputProvider {
  readonly format: string;
  readonly extension: string;
  render(html: string, metadata: TemplateMetadata, options?: RenderOptions): Promise<RenderResult>;
}

interface RenderResult {
  buffer: Buffer;
  format: string;
  extension: string;
  contentType: string;
  sizeBytes: number;
}

interface TemplateMetadata {
  pageSize?: string;
  margins?: Margins;
  fontFamily?: string;
  fontSize?: number;
  rtl?: boolean;
  orientation?: string;
}
```

### 8.2 Provider Implementations

| Provider | Format | Implementation Strategy |
|---|---|---|
| `HtmlProvider` | `HTML` | Returns rendered HTML with embedded CSS and metadata as `<meta>` tags |
| `PdfProvider` | `PDF` | Puppeteer: headless Chrome via connection pool, `printBackground: true` |
| `DocxProvider` | `DOCX` | Convert HTML to DOCX via `html-docx-js` or custom XML template |
| `XlsxProvider` | `XLSX` | Only for tabular templates. Parse HTML `<table>` to exceljs workbook |
| `TxtProvider` | `TXT` | Strip HTML tags, normalize whitespace, return UTF-8 text |
| `EmailProvider` | `EMAIL` | HTML wrapper with email-compatible CSS, injects into mailer |

### 8.3 Digital Signature Extension Point

The architecture does NOT implement digital signatures. An extension point is reserved for future integration:

```typescript
interface DigitalSignatureProvider {
  readonly name: string;
  sign(buffer: Buffer, options: SignOptions): Promise<SignatureResult>;
  verify(buffer: Buffer, signature: SignatureResult): Promise<boolean>;
}

interface SignOptions {
  certificateRef?: string;
  signatureType: 'pades' | 'cades' | 'xades';
  signatureFieldName?: string;
  reason?: string;
  location?: string;
}

interface SignatureResult {
  signedBuffer: Buffer;
  signatureRef: string;
  signingTime: Date;
  thumbprint: string;
}
```

Future digital signature providers plug in via:
1. Implement `DigitalSignatureProvider`
2. Register in `DigitalSignatureRegistry`
3. The pipeline calls `sign()` between Output Provider (Stage 6) and Storage (Stage 7)
4. `template_outputs.digital_signature_ref` stores the signature reference

No architecture changes required. The rendering pipeline, storage, and audit treat the signature as an opaque step.

### 8.4 Adding a New Provider

To add a new output format:
1. Create a new class implementing `OutputProvider`
2. Register it in the `OutputProviderRegistry` by format name
3. The format becomes available for all templates

### 8.5 Format-Specific Constraints

| Format | Constraints | Fallback |
|---|---|---|
| `PDF` | Requires Chrome/Puppeteer via connection pool. ~500ms overhead per page. | If Chrome unavailable, HTML |
| `DOCX` | Complex layouts may differ from PDF preview | Preview in HTML before generating DOCX |
| `EMAIL` | CSS must be inline-compatible. No scripts. | n/a |
| `XLSX` | Only table content is rendered. No free-form text. | Warn user if template has non-tabular blocks |
| `TXT` | All formatting lost | n/a |

---

## 9. Localization

### 9.1 Design

Each template version has ONE canonical content structure (see Section 2.4). Localizations override specific strings within that structure.

### 9.2 How It Works

1. Template author creates version content with Arabic text
2. Author submits for review
3. After approval, a localization is created for English
4. The English localization only contains translated versions of the same `body` and `blocks`
5. Both share the same `variable_definitions`, `sample_data`, and `metadata`

### 9.3 Localization Granularity

The `template_localizations.content` mirrors the structure of `template_versions.content` but only includes locale-specific overrides.

### 9.4 Version Consistency

All localizations are tied to a specific version. When a new version is created, previous localizations are NOT carried forward automatically.

### 9.5 Adding a New Locale

1. Add locale to global application configuration
2. Create localization records for existing approved templates
3. No schema changes required

---

## 10. Security Model

### 10.1 RLS Policies

All `templates.*` tables use PostgreSQL Row-Level Security with the standard ERM pattern:

```sql
ALTER TABLE templates.templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates.template_versions ENABLE ROW LEVEL SECURITY;

-- Admin: full access
CREATE POLICY templates_admin_all ON templates.templates
  FOR ALL USING (system.fn_is_admin());

-- Read: all authenticated users
CREATE POLICY templates_read_all ON templates.templates
  FOR SELECT USING (true);
```

### 10.2 Permission Matrix

| Action | Admin | Chair | Reviewer | Applicant | Anonymous |
|---|---|---|---|---|---|
| View template library | Yes | Yes | Yes | Yes | No |
| View version history | Yes | Yes | Yes | Yes | No |
| Create/edit draft | Yes | Yes | No | No | No |
| Submit for review | Yes | Yes | No | No | No |
| Approve version | Yes | Yes | No | No | No |
| Deprecate/archive | Yes | No | No | No | No |
| Generate output | Yes | Yes | Yes | Yes (own) | No |
| Preview (sample) | Yes | Yes | Yes | Yes | Yes |
| Preview (real data) | Yes | Yes | Yes | Yes (own) | No |
| View render history | Yes | Yes | Yes | Yes (own) | No |
| View usage statistics | Yes | Yes | No | No | No |
| Delete (own draft) | Yes | Yes | No | No | No |
| Delete (any) | Yes | No | No | No | No |

### 10.3 Generation Permissions (Multi-Stage Authorization)

RLS alone is insufficient for generation authorization because it involves multiple independent checks across different schemas. The authorization is **multi-stage**:

```
Can user U generate from template T for entity E?
```

**Stage 1 -- Authentication:**
- User must be authenticated (not anonymous)
- Rejected at API gateway level

**Stage 2 -- Template Approval:**
- Template version must be APPROVED (not DRAFT, REVIEW, DEPRECATED, or ARCHIVED)
- Enforced via CHECK constraint on `template_versions.status` + generation eligibility function

**Stage 3 -- Template Availability:**
- `effective_from <= NOW()` AND (`effective_until` IS NULL OR `effective_until > NOW()`)
- Enforced via generation eligibility function

**Stage 4 -- Template Category Permission:**
- User must have GENERATE permission on the template's category
- Checked against role: Admin, Chair, Reviewer always pass; Applicant only for own entities

**Stage 5 -- Entity Ownership/Access:**
- Entity must be accessible to the user via standard RLS on the entity's own table
- Checked by querying the entity's table with `app.user_id` context (set by AsyncLocalStorage middleware)

**Stage 6 -- Audit:**
- Every generation attempt (success or failure) is recorded in `template_render_history`
- Attempts that fail Stage 4 or 5 are logged with `status = 'PERMISSION_DENIED'`

**Implementation:**
- Stages 1-3 are enforced in the application layer (TemplateService)
- Stages 4-5 require cross-schema checks that cannot be expressed in a single RLS policy
- A **SECURITY DEFINER function** (`templates.fn_can_generate`) is used for the combined check
- This function checks template status, effective dates, and user role in one DB call

### 10.4 Delete Strategy

Templates must never be physically deleted after publication.

| Action | Mechanism | Who | Audit |
|---|---|---|---|
| Delete draft (unpublished) | Soft delete: `is_active = false` | Admin, Chair (own) | `template_version_audit` (action: DELETED) |
| Archive published version | Status to ARCHIVED | Admin only | `template_version_audit` (action: ARCHIVED) |
| Physical DELETE | **Blocked** -- `FOR DELETE USING (false)` on all template tables | No one | N/A |
| Retention (render history) | Permanent -- never deleted | No one | N/A |
| Retention (outputs) | Permanent -- referential integrity maintained | No one | N/A |

```sql
CREATE POLICY templates_no_physical_delete ON templates.templates
  FOR DELETE USING (false);

CREATE POLICY template_versions_no_physical_delete ON templates.template_versions
  FOR DELETE USING (false);
```

### 10.5 Audit Requirements

| Action | Audit Record |
|---|---|
| Version status change | `template_version_audit` |
| Generate output (success) | `template_render_history` |
| Generate output (permission denied) | `template_render_history` (status: PERMISSION_DENIED) |
| Delete template (soft) | `template_version_audit` (action: DELETED) |
| Rollback | `template_version_audit` (action: ROLLED_BACK) |

---

## 11. Audit

### 11.1 Generation Audit

Every template generation produces an immutable record in `templates.template_render_history`:

| Field | Value | Source |
|---|---|---|
| Who | `user_id` | Authentication context |
| When | `generated_at` | Server timestamp |
| What | `template_code`, `version`, `locale`, `format` | Request parameters |
| For | `entity_type`, `entity_id` | Request parameters |
| Variables | `variables_hash` (SHA-256 of variable JSON) | Computed from resolved variables |
| Content | `rendered_html_hash` (SHA-256 of intermediate HTML) | Computed after render |
| Output | `checksum_sha256` (SHA-256 of final file) | Computed after storage |
| Performance | `duration_ms` | Measured |
| Status | `SUCCESS`, `FAILED`, `PARTIAL`, `PERMISSION_DENIED` | Pipeline result |

### 11.2 Variable Privacy

- The full variables JSON is NOT stored in the history table
- Only `variables_hash = SHA-256(JSON.stringify(variables))` is stored
- The hash can be used to verify that the same set of variables was used without exposing the values
- The full variables are only in `template_render_jobs` (transient, deleted after 30 days)

### 11.3 Retention

| Table | Retention | Rationale |
|---|---|---|
| `template_render_history` | Permanent | Legal/regulatory requirement |
| `template_render_jobs` | 30 days after completion | Transient operational data |
| `template_usage_statistics` | 5 years | Aggregated, no PII |
| `template_outputs` | Permanent (with storage) | Generated document records |
| `template_version_audit` | Permanent | Governance |
| `template_partials` | Permanent (if referenced) | Reusable fragments |
| `template_packages` | Permanent | Business process definition |

---

## 12. Storage Strategy

### 12.1 Storage Path Convention

```
templates/{category_code}/{template_code}/{version}/{locale}/{entity_type}_{entity_id}_{timestamp}.{ext}
```

### 12.2 Storage Abstraction

```typescript
interface StorageProvider {
  write(path: string, buffer: Buffer): Promise<StorageResult>;
  read(path: string): Promise<Buffer>;
  delete(path: string): Promise<void>;
  exists(path: string): Promise<boolean>;
}
```

**Default implementation:** Local filesystem under `uploads/templates/`
**Future implementation:** S3-compatible object storage (MinIO, AWS S3)

### 12.3 Deduplication

- Same checksum -> same buffer -> stored once
- `template_outputs` can reference the same stored file if content is identical
- Implemented via content-addressable storage: `templates/blobs/{sha256[:2]}/{sha256}.{ext}`

### 12.4 Retention and Archiving

| State | Storage Tier | Retention |
|---|---|---|
| Active outputs (< 1 year) | Hot (local SSD) | Keep |
| Historical outputs (1-5 years) | Cold (S3/Glacier) | Keep |
| Draft outputs | Hot | Delete after 90 days |
| Failed outputs | Hot | Delete after 7 days |

### 12.5 Backup

Standard ERM backup procedure includes `uploads/templates/`:
- Incremental backup: daily
- Full backup: weekly
- Checksum verification on every backup

---

## 13. API Design

### 13.1 Base URL

All endpoints under `/api/v1/templates`.

### 13.2 Template Management

```
GET    /api/v1/templates
  -> List templates (paginated, filterable by category, status, locale)
  Query: ?category=decision&status=approved&page=1&limit=20&search=consent

GET    /api/v1/templates/:code
  -> Get template details + latest approved version summary

POST   /api/v1/templates
  -> Create new template

PATCH  /api/v1/templates/:code
  -> Update template metadata

DELETE /api/v1/templates/:code
  -> Soft delete (sets is_active = false)
```

### 13.3 Version Management

```
GET    /api/v1/templates/:code/versions
  -> List all versions for a template

GET    /api/v1/templates/:code/versions/:version
  -> Get specific version with content

POST   /api/v1/templates/:code/versions
  -> Create new version (status: DRAFT)

PATCH  /api/v1/templates/:code/versions/:version
  -> Update draft content (only when status is DRAFT)

POST   /api/v1/templates/:code/versions/:version/submit
  -> Transition DRAFT to REVIEW (triggers save-time validation)

POST   /api/v1/templates/:code/versions/:version/approve
  -> Transition REVIEW to APPROVED

POST   /api/v1/templates/:code/versions/:version/reject
  -> Transition REVIEW to DRAFT

POST   /api/v1/templates/:code/versions/:version/deprecate
  -> Transition APPROVED to DEPRECATED

POST   /api/v1/templates/:code/versions/:version/archive
  -> Transition DEPRECATED to ARCHIVED

POST   /api/v1/templates/:code/versions/:version/rollback
  -> Rollback to this version

POST   /api/v1/templates/:code/versions/:version/publish
  -> Set effective_from date

GET    /api/v1/templates/:code/versions/:version/diff?against=1.2.0
  -> Structured diff between two versions
```

### 13.4 Preview

```
POST   /api/v1/templates/:code/versions/:version/preview
  Body: { locale, outputFormat, entityType?, entityId?, variables? }
  -> If entityId is null, uses sample_data
```

### 13.5 Generate

```
POST   /api/v1/templates/:code/generate
  Body: { version?, locale, outputFormat, entityType, entityId, variables? }
  -> If sync: waits and returns output
  -> If async: returns job ID for polling

GET    /api/v1/templates/jobs/:jobId
  -> Check render job status

GET    /api/v1/templates/outputs/:outputId/download
  -> Download generated file
```

### 13.6 Localization

```
GET    /api/v1/templates/:code/versions/:version/localizations
POST   /api/v1/templates/:code/versions/:version/localizations
PATCH  /api/v1/templates/:code/versions/:version/localizations/:locale/verify
```

### 13.7 Validation

```
POST   /api/v1/templates/:code/versions/:version/validate
  -> Run save-time validation rules, return report

POST   /api/v1/templates/:code/versions/:version/validate-generate
  -> Run generation-time validation with mock entity data
```

### 13.8 Packages

```
GET    /api/v1/templates/packages
POST   /api/v1/templates/packages
GET    /api/v1/templates/packages/:code
POST   /api/v1/templates/packages/:code/generate
  -> Execute a package for a given entity
  -> Returns array of job IDs, one per slot
```

### 13.9 Statistics

```
GET    /api/v1/templates/statistics
GET    /api/v1/templates/:code/statistics
GET    /api/v1/templates/render-history
```

### 13.10 Categories

```
GET    /api/v1/templates/categories
POST   /api/v1/templates/categories
PATCH  /api/v1/templates/categories/:code
```

### 13.11 Variables (Admin)

```
GET    /api/v1/templates/variables
POST   /api/v1/templates/variables
PATCH  /api/v1/templates/variables/:code
```

---

## 14. Frontend UX

(Unchanged from v1.0 -- not in scope for this review cycle.)

---

## 15. Integration Matrix

### 15.1 All Subsystems Communicate Through TemplateService

No subsystem calls Handlebars, Puppeteer, or any rendering API directly. All go through `TemplateService`. Generation may be triggered by direct API call or by domain event (see §4.7):

| System | Integration Point | Template Category | Resolver Path | Event Trigger (optional) |
|---|---|---|---|---|
| **core.projects** | Generate protocol, proposal | `protocol` | `application.project.*` | — |
| **core.applications** | Generate decisions, certificates | `decision`, `certificate` | `application.*` | `APPLICATION_SUBMITTED`, `APPLICATION_APPROVED`, `APPLICATION_REJECTED` |
| **workflow** | Generate notifications on state change | `notification`, `email` | `workflow.*`, `application.currentStatus` | `APPLICATION_SUBMITTED`, `APPLICATION_APPROVED`, `APPLICATION_REJECTED`, `APPLICATION_CONDITIONS_ISSUED`, `SUBMIT_EVIDENCE_ACCEPTED` |
| **committee.consent_templates** | Migrate to new system | `consent` | `application.*`, `user.*` | `CONSENT_APPROVED` |
| **committee.meetings** | Generate minutes, agendas | `meeting` | `meeting.*` | `MEETING_MINUTES_AVAILABLE` |
| **committee.decisions** | Generate decision letters | `decision` | `application.decision.*` | `COMMITTEE_DECISION_ISSUED` |
| **core.conditions** | Generate condition letters | `condition` | `application.conditions.*` | `APPLICATION_CONDITIONS_ISSUED` |
| **safety.sae_reports** | Generate SAE notification | `safety` | `risk.*` | — |
| **documents.generated_documents** | Replace with template_outputs | all | n/a | — |
| **communication.notifications** | Replace notification templates | `notification` | `entity.*`, `user.*` | `APPLICATION_SUBMITTED`, `RISK_ESCALATED` |
| **accreditation** | Generate site visit reports | `accreditation` | `accreditation.*` | `ACCREDITATION_GRANTED`, `ACCREDITATION_EXPIRED`, `ACCREDITATION_REVOKED` |
| **risk_assessment** | Generate risk reports | `risk` | `risk.*`, `application.project.riskLevel` | `RISK_ESCALATED` |
| **reports** | Generate periodic reports | `report` | various (entity-based) | `REPORT_DUE`, `RENEWAL_REMINDER` |
| **audit** | Template render history to audit schema | n/a | n/a | — |
| **storage** | Store generated outputs | n/a | n/a | — |
| **email** | Send templated emails | `email` | `user.email` | — |

### 15.2 Reports Consideration

Reports aggregate data across multiple entities (applications, committees, users, dates). The current Resolver supports single-entity resolution (`entity_type` + `entity_id`). For report templates, the report's own record serves as the entity, with individual data points resolved from related entities.

### 15.3 Migration Mapping

| Current Table | New Table | Strategy |
|---|---|---|
| `documents.templates` | `templates.templates` + `template_versions` | One-time ETL |
| `committee.consent_templates` | `templates.templates` (category: consent) | ETL |
| `committee.consent_template_versions` | `templates.template_versions` + `template_localizations` | ETL |
| `communication.notification_templates` | `templates.templates` (category: notification) | ETL |
| `documents.generated_documents` | `templates.template_outputs` | ETL |

---

## 16. Future AI Layer

### 16.1 Extension Points

| Extension Point | Interface | What AI Would Do |
|---|---|---|
| Variable Resolver | New source type: `ai_generated` | AI generates variable values |
| Content Generator | New engine: `ai` alongside `handlebars` | AI writes template content from a prompt |
| Validation Engine | New rule: `ai_review` | AI reviews template for completeness |
| Preview Engine | New mode: `ai_suggestions` | AI suggests improvements |
| Translation | Integration with `template_localizations` | AI translates, marks `is_verified: false` |
| Template Discovery | Recommendation system | AI recommends templates |

### 16.2 Design Decisions Supporting AI

1. Content as JSON makes it easy for LLMs to parse and modify
2. Variable definitions as metadata gives the AI a complete vocabulary
3. Sample data lets the AI learn from realistic previews
4. Validation rules apply equally to AI-authored templates
5. Version immutability: AI drafts go through the same review pipeline
6. Audit trail: AI-generated content is identifiable in logs

### 16.3 What Would Not Need to Change

- The `templates.*` schema
- The rendering pipeline
- The output providers
- The RLS policies
- The storage layer

---

## 17. Technology Evaluation

### 17.1 Rendering Engine Comparison

| Feature | Handlebars | Mustache | Liquid | EJS |
|---|---|---|---|---|
| Logic | Helpers | None (logicless) | Filters + Tags | Full JS |
| Partials | Native `{{> partial}}` | Native | Native `{% include %}` | Via includes |
| Conditionals | `{{#if}}` `{{#unless}}` | `{{#value}}` (truthy only) | `{% if %}` | `<% if %>` |
| Loops | `{{#each}}` | `{{#list}}` | `{% for %}` | `<% for %>` |
| Custom Helpers | Yes (JS functions) | No | Yes (filters + tags) | Yes |
| Security | Auto-escapes HTML | Auto-escapes | Auto-escapes | Manual escape |
| Learning Curve | Low | Lowest | Low | Medium |
| npm downloads/wk | 25M | 6M | 700K | 11M |
| TypeScript types | Yes | Yes | Yes | Yes |

### 17.2 Recommendation: Handlebars

**Justification:**
1. Already used in codebase (certificate.service.ts, TemplateRendererService)
2. Custom helpers essential for Arabic date/number formatting -- impossible in Mustache
3. Partials (`{{> blockName}}`) map directly to the `blocks` content structure
4. Auto-escaping critical for HTML email and web content
5. TemplateService abstraction (Section 4.1) ensures replaceability

### 17.3 Supporting Libraries

| Library | Purpose |
|---|---|
| `handlebars` v4.7+ | Rendering engine |
| `puppeteer` / `puppeteer-core` | PDF generation (connection pool) |
| `exceljs` v4.4+ | XLSX output |
| `docx` | DOCX output |
| `html-to-docx` | HTML to DOCX conversion |
| `handlebars-helpers` | Date, number, string, comparison helpers |
| `diff` | Version diffing |

---

## 18. Risks

| # | Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| 1 | Template Engine becomes a bottleneck -- all generation routes through one service | Medium | High | Async render jobs. Separate read/write endpoints. Cache compiled templates. |
| 2 | Variable resolution performance -- batch retrieval mitigates but complex entity lookups remain a risk | Medium | Medium | Batch resolution (Section 5.6). In-request caching. Indexed queries. |
| 3 | Puppeteer resource usage -- each PDF spawns Chrome | High | High | Connection pooling. Queue-based generation. Timeout per page. |
| 4 | Migration data loss -- existing templates in 3 schemas have incompatible structures | Medium | High | ETL with dry-run mode. Rollback plan. Validation report after migration. |
| 5 | Version proliferation -- too many versions slowing queries | Low | Medium | Archival of old versions. Pagination. Soft limit of 50 versions per template. |
| 6 | Content injection via variables -- mitigated by path-only resolution and Function Registry | Low | Critical | No raw SQL. No eval(). No arbitrary functions. Auto-escaping. |
| 7 | Circular partial detection missed -- infinite recursion during render | Low | Medium | Depth limit of 10. Dependency graph validation at save-time. |
| 8 | Localization drift -- English localization outdated when Arabic version updated | High | Medium | Version-level localization. Mandatory re-verification on MAJOR bumps. |
| 9 | Storage migration -- filesystem to S3 disrupts existing paths | Medium | Medium | Storage abstraction layer. Dual-write during migration. |
| 10 | Rollback complexity -- reactivating older version may break dependent workflows | Medium | Medium | Rollback updates version pointer only. Old outputs preserved. |
| 11 | Frontend editor not WYSIWYG -- non-technical users struggle with code editor | High | High | Code editor and visual block editor. Real-time preview. |
| 12 | Compliance failure -- templates used without proper approval | Medium | Critical | Block generation from non-APPROVED versions (DB constraint + application check). Audit trail. |

---

## 19. Migration Strategy

### 19.1 Principle

The Template Engine is introduced alongside existing systems. No existing functionality is removed until the new system is validated in production.

### 19.2 Phase 1: Schema + API (no migration)

1. Create `templates` schema and all tables
2. Implement CRUD APIs for templates, versions, categories, variables, localizations
3. Implement validation engine (save-time)
4. Implement preview engine (sample data only)
5. No generation, no migration, no impact on existing functionality

### 19.3 Phase 2: Rendering Pipeline (parallel run)

1. Implement rendering pipeline (Resolver, Validation, Renderer, Output Provider, Storage)
2. Implement all output providers
3. Add generation endpoints
4. Run in parallel: existing systems still handle generation; new system logs what it would have generated
5. Comparison report: existing output vs new engine output for same template + data

### 19.4 Phase 3: ETL from Existing Systems

1. Migrate `documents.templates` to `templates.templates` + `template_versions`
2. Migrate `committee.consent_templates` + `_versions` to templates with category `consent`
3. Migrate `communication.notification_templates` to templates with category `notification`
4. Migrate `documents.generated_documents` to `template_outputs`

Each migration step:
1. Dry-run to validate ETL produces correct count and data
2. Run ETL with `is_active: false` on new records
3. Verification query: count matches, no null required fields
4. Set `is_active: true`
5. Run validation tests

### 19.5 Phase 4: Cutover

1. Update services to use TemplateEngine instead of inline Handlebars
2. Update notification service to use new Template Engine
3. Update consent service to use new Template Engine
4. Remove old tables after 30 days of monitoring

### 19.6 Rollback Plan

If any phase causes issues:
1. Set `templates.templates.is_active = false` on migrated templates
2. Old systems were never removed -- they continue working
3. Fix issue, re-run migration with corrected ETL

---

## 20. Implementation Plan

### 20.1 Commit Sequence

Each commit is an independent, deployable unit. Validation (Commit 6.3) precedes Lifecycle (Commit 6.5). Event-Driven Generation (Commit 6.6) decouples business modules from document generation. Rendering is split into multiple commits. A dedicated Seed Templates commit (6.2) enables end-to-end testing from the start.

#### Commit 6.1 -- Schema Foundation

**Scope:** `templates` schema, core entities, RLS policies, indexes, Partial Unique Index

**Files:**
- `database/canonical/templates/01-schemas.sql`
- `database/canonical/templates/02-categories.sql`
- `database/canonical/templates/03-templates.sql`
- `database/canonical/templates/04-template-versions.sql`
- `database/canonical/templates/05-template-variables.sql`
- `database/canonical/templates/06-template-localizations.sql`
- `database/canonical/templates/07-template-partials.sql`
- `database/canonical/templates/08-template-packages.sql`
- `database/canonical/templates/09-template-audit.sql`
- `database/canonical/templates/10-rls.sql`
- `database/canonical/templates/11-indexes.sql` (includes one_approved_version)
- `database/canonical/templates/12-seed-categories.sql`
- `database/canonical/templates/13-seed-variables.sql`
- `backend/src/shared/db-types.ts` (add Template interfaces)

**Risks:** Schema conflicts with existing `templates` objects (none exist).
**Rollback:** `DROP SCHEMA templates CASCADE;`
**Validation:** Run all CREATE statements. Verify RLS policies exist. Verify seed data. Verify Partial Unique Index.
**Testing:** Run CREATE statements against test DB. Verify RLS policies are active.

#### Commit 6.2 -- Seed Templates

**Scope:** Test seed templates for end-to-end validation

**Files:**
- `database/canonical/templates/14-seed-templates.sql`
- `database/canonical/templates/15-seed-versions.sql`
- `database/canonical/templates/16-seed-partials.sql`

**Acceptance Criteria:**
- At least one template per major category (decision, consent, notification, certificate)
- At least one version (DRAFT) per template
- At least one shared partial (HEADER, FOOTER, SIGNATURE_BLOCK)
- All variable definitions reference valid whitelist roots
- All resolver_path values are valid path notation

#### Commit 6.3 -- Validation Engine

**Scope:** Save-time and generation-time validation

**Files:**
- `backend/src/modules/templates/validation/save-validator.ts`
- `backend/src/modules/templates/validation/generate-validator.ts`
- `backend/src/modules/templates/validation/rules/` (individual rule files)

**Acceptance Criteria:**
- Detect missing required variables
- Detect undefined blocks
- Detect circular block references (block depth limit = 10)
- Detect undefined variables in content
- Detect unresolved placeholders after resolution
- Validate resolver_path against Entity Whitelist
- Validate resolver_function against Function Registry
- Validate variable type and enum values
- Detect circular partial references
- Return structured error report

#### Commit 6.4 -- Resolver Framework (ResolverRegistry + Domain Resolvers + Repository Layer)

**Scope:** ResolverRegistry, domain-specific resolvers, repository layer, Path Resolution Model, Entity Whitelist, Function Registry, Batch Resolution

**Files:**
- `backend/src/modules/templates/resolver/resolver-registry.ts`
- `backend/src/modules/templates/resolver/domain-resolver.interface.ts`
- `backend/src/modules/templates/resolver/domain/application-resolver.ts`
- `backend/src/modules/templates/resolver/domain/committee-resolver.ts`
- `backend/src/modules/templates/resolver/domain/workflow-resolver.ts`
- `backend/src/modules/templates/resolver/domain/consent-resolver.ts`
- `backend/src/modules/templates/resolver/domain/risk-resolver.ts`
- `backend/src/modules/templates/resolver/domain/document-resolver.ts`
- `backend/src/modules/templates/resolver/computed-resolver.ts`
- `backend/src/modules/templates/resolver/context-resolver.ts`
- `backend/src/modules/templates/resolver/function-registry.ts`
- `backend/src/modules/templates/resolver/path-parser.ts`
- `backend/src/modules/templates/resolver/whitelist.ts`
- `backend/src/modules/templates/repositories/application-repository.ts`
- `backend/src/modules/templates/repositories/committee-repository.ts`
- `backend/src/modules/templates/repositories/workflow-repository.ts`
- `backend/src/modules/templates/repositories/consent-repository.ts`
- `backend/src/modules/templates/repositories/risk-repository.ts`
- `backend/src/modules/templates/repositories/document-repository.ts`
- `backend/src/modules/templates/dto/` (typed DTOs per domain)

**Acceptance Criteria:**
- `ResolverRegistry.select("application")` returns `ApplicationResolver`
- Resolve `application.project.title_ar` from application ID via `ApplicationRepository.findWithProject(id)` → DTO (NO SQL in resolver)
- `ApplicationResolver` does not call `db.query()` — delegates to `ApplicationRepository`
- Resolve `user.displayName` from authenticated user
- Resolve computed variables via Function Registry only
- Resolve dependency-ordered variables in topological order
- Detect circular variable references
- Reject unknown entity roots with `UNKNOWN_ENTITY_ROOT`
- Reject unknown functions with `UNKNOWN_FUNCTION`
- Batch resolution: group `application.*` variables → single `ApplicationRepository.findFullApplication(id)` call
- Per-request caching: same entity_id = single DB call
- Adding a new domain resolver does not modify existing resolver code

#### Commit 6.5 -- Lifecycle (Version CRUD + Status Transitions)

**Scope:** Version service, approval workflow, immutability enforcement

**Files:**
- `backend/src/modules/templates/version.service.ts`
- `backend/src/modules/templates/approval.service.ts`
- `database/canonical/templates/17-trigger-content-immutable.sql`

**Acceptance Criteria:**
- DRAFT to REVIEW (content locked, validation runs)
- REVIEW to APPROVED (permission check, Partial Unique Index enforced)
- REVIEW to DRAFT (with rejection reason)
- APPROVED to DEPRECATED to ARCHIVED
- Cannot edit content after REVIEW
- Effective_from / effective_until enforcement
- DEPRECATED generation emits warning

#### Commit 6.6 -- Event-Driven Generation

**Scope:** Event bus integration, TemplateService subscriber, event-to-template mapping, failure handling

**Files:**
- `backend/src/modules/templates/events/event-subscriber.ts`
- `backend/src/modules/templates/events/event-types.ts`
- `backend/src/modules/templates/events/event-template-mapping.ts`
- `backend/src/modules/templates/events/event-retry-handler.ts`
- `database/canonical/templates/17-event-template-mapping.sql`

**Acceptance Criteria:**
- TemplateService subscribes to domain events via an event bus interface
- On `APPLICATION_APPROVED`, TemplateService.generate() is called with the correct template code and entity
- On `ACCREDITATION_GRANTED`, the accreditation certificate template is generated automatically
- No business module contains a direct call to TemplateService — only event publication
- Direct API generation (user-driven) continues to work alongside event-driven generation
- Failed event processing retries up to 3 times with exponential backoff
- Events that fail all retries are logged to `template_render_history` with status `EVENT_FAILED`
- Event-to-template mapping is configurable (database table, not hardcoded)
- Adding a new event-triggered document does not modify business module code

#### Commit 6.7 -- Rendering Core (HTML only)

**Scope:** TemplateService, pipeline orchestration, Handlebars engine, compiled cache, HTML provider

**Files:**
- `backend/src/modules/templates/template-service.ts`
- `backend/src/modules/templates/renderer/pipeline.ts`
- `backend/src/modules/templates/renderer/handlebars-engine.ts`
- `backend/src/modules/templates/renderer/compiled-cache.ts`
- `backend/src/modules/templates/renderer/providers/html-provider.ts`

**Acceptance Criteria:**
- TemplateService.generate() with sync mode
- Compiled Template Cache (LRU, invalidation on version mutation)
- Render HTML from Handlebars template + variables
- Process partial references (from template_partials table)
- Proper error propagation
- All 16 subsystems call TemplateService, not Handlebars directly

#### Commit 6.8 -- PDF Provider

**Scope:** Puppeteer PDF generation with connection pool

**Files:**
- `backend/src/modules/templates/renderer/providers/pdf-provider.ts`
- `backend/src/modules/templates/renderer/providers/puppeteer-pool.ts`

**Acceptance Criteria:**
- Convert rendered HTML to PDF via Puppeteer
- Connection pool (max 3 concurrent Chrome instances)
- Timeout per page (60s)
- Fallback to HTML if Chrome unavailable
- Proper cleanup on failure

#### Commit 6.9 -- DOCX Provider

**Scope:** HTML to DOCX conversion

**Files:**
- `backend/src/modules/templates/renderer/providers/docx-provider.ts`

**Acceptance Criteria:**
- Convert rendered HTML to DOCX
- Preserve basic formatting (headings, tables, lists)
- Handle Arabic/RTL content

#### Commit 6.10 -- Remaining Providers + Generation + Audit

**Scope:** TXT, XLSX, EMAIL providers, storage, audit, statistics

**Files:**
- `backend/src/modules/templates/renderer/providers/txt-provider.ts`
- `backend/src/modules/templates/renderer/providers/xlsx-provider.ts`
- `backend/src/modules/templates/renderer/providers/email-provider.ts`
- `backend/src/modules/templates/generation/generate.service.ts`
- `backend/src/modules/templates/generation/job-queue.ts`
- `backend/src/modules/templates/storage/filesystem-provider.ts`
- `backend/src/modules/templates/storage/s3-provider.ts`
- `database/canonical/templates/18-render-jobs.sql`
- `database/canonical/templates/19-render-history.sql`

**Acceptance Criteria:**
- Sync generation: wait, store, return output
- Async generation: return job ID, poll for completion
- Output snapshot recorded (variables_hash, rendered_html_hash, checksum_sha256)
- Audit record created in template_render_history
- Download generated file by output ID
- Statistics aggregated by day/template

#### Commit 6.11 -- Template CRUD Backend

**Scope:** Backend service for templates, categories, variables, packages

**Files:**
- `backend/src/modules/templates/templates.routes.ts`
- `backend/src/modules/templates/templates.service.ts`
- `backend/src/modules/templates/templates.repository.ts`
- `backend/src/modules/templates/templates.schema.ts` (Zod validation)
- `backend/src/modules/templates/packages.routes.ts`
- `backend/src/modules/templates/index.ts`
- `backend/src/index.ts` (register route)

**Acceptance Criteria:**
- Create/list/get/update/delete template
- Create/list/get/update version
- Create/list/get localization
- Create/list/get categories
- Create/list/get variables
- Create/list/get packages
- Execute package (multiple slots)

#### Commits 6.12-6.14 -- Frontend

**Scope:** Template library, editor, preview, approval, history, statistics (sequential frontend commits)

**Files:**
- `frontend/src/pages/templates/TemplateLibrary.tsx`
- `frontend/src/pages/templates/TemplateEditor.tsx`
- `frontend/src/pages/templates/VersionHistory.tsx`
- `frontend/src/pages/templates/PreviewPage.tsx`
- `frontend/src/pages/templates/ApprovalQueue.tsx`
- `frontend/src/pages/templates/RenderHistory.tsx`
- `frontend/src/pages/templates/UsageStatistics.tsx`
- `frontend/src/pages/templates/DiffViewer.tsx`
- `frontend/src/sdk/domains/templates.sdk.ts`

#### Commit 6.15 -- ETL + Cutover

**Scope:** One-time migration, service replacement

**Files:**
- `scripts/migrations/migrate-document-templates.ts`
- `scripts/migrations/migrate-consent-templates.ts`
- `scripts/migrations/migrate-notification-templates.ts`
- `scripts/migrations/validate-migration.sql`
- `backend/src/services/certificate.service.ts` (modify to use TemplateService)
- `backend/src/services/notification.service.ts` (modify)
- `backend/src/services/consent.service.ts` (modify)

### 20.2 Testing Strategy

| Commit | Unit Tests | Integration Tests | Validation |
|---|---|---|---|
| 6.1 Schema | N/A | Run DDL against test DB | Verify indexes, RLS, seed data |
| 6.2 Seed | N/A | Verify seed SQL produces expected rows | Query seed data |
| 6.3 Validation | Test each rule with valid/invalid input | Test DRAFT->REVIEW triggers validation | Structured error report |
| 6.4 Resolver Framework | Test path parsing, whitelist, function registry, registry selection, domain resolver, repository delegation, batch grouping | Test resolve(applicationId) via ResolverRegistry → ApplicationResolver → ApplicationRepository → DTO | No SQL in resolver code |
| 6.5 Lifecycle | Test each status transition | Test DRAFT->REVIEW->APPROVED-DEPRECATED | Partial Unique Index |
| 6.6 Event-Driven | Test event subscriber, event-to-template mapping, retry logic | Test APPLICATION_APPROVED triggers TemplateService.generate() | No business module calls TemplateService directly |
| 6.7 Core Rendering | Test TemplateService.generate() | Test HTML output for seed template | Cache hit/miss |
| 6.8 PDF | Test Puppeteer pool | Test HTML->PDF conversion | File size constraints |
| 6.9 DOCX | Test conversion | Test Arabic DOCX output | Format preservation |
| 6.10 Remaining | Test each provider | Test storage + audit write | Output snapshot |
| 6.11 CRUD | Test all endpoints | Test full CRUD cycle | API response codes |
| 6.12-6.14 Frontend | Test React components with jsdom | Test with dev server | Visual regression |
| 6.15 ETL | Test migration scripts with dry-run | Test cutover with seed data | Counts match |

---

**Architecture Change Log — v1.0 to v1.1:**

(Previous changes from v1.0 to v1.1 retained below.)

**Architecture Change Log — v1.1 to v1.1.1:**

| Section | Change | Reason |
|---|---|---|
| Header | Added v1.1 revision tag | Version tracking |
| Section 1.3 | Goal #4: added "(no raw SQL)" | Blocker 1 |
| Section 2.2 categories | `required_variables`: text[] to jsonb | HPI 2 |
| Section 2.2 templates | Added template_partials + template_package_members relationships | HPI 5, HPI 6 |
| Section 2.2 template_versions | Added `effective_until`, Partial Unique Index docs, generation eligibility rules | Blocker 4 |
| Section 2.2 template_variables | **Complete rewrite**: removed `source_query` (SQL), added `resolver_path`, `resolver_function`, `entity_whitelist_root`, `enum_values`, `validation_rules`, `resolver_function_args` | Blockers 1, 2, 3; HPI 2 |
| Section 2.2 | New entity: `template_partials` | HPI 5 |
| Section 2.2 | New entity: `template_packages` + `template_package_members` | HPI 6 |
| Section 2.2 | New entity: `template_version_audit` | Blocker 4 |
| Section 2.2 | New entity: `template_validation_tests` (moved from inline) | HPI 3 |
| Section 2.2 template_outputs | Added `rendered_html_hash`, `digital_signature_ref` | HPI 3, HPI 4 |
| Section 2.2 template_outputs | Output Snapshot documentation | HPI 3 |
| Section 2.2 template_render_history | Added `rendered_html_hash` column | HPI 3 |
| Section 2.3 ERD | **Updated**: removed `source_query` (SQL), added partials/packages, added version_audit | All blockers |
| Section 2.4 Content | Updated JSON example for clarity | Readability |
| Section 3.3 Lifecycle | Added Generation Eligible column, DEPRECATED warning behavior | Blocker 4 |
| Section 3.4 Immutability | DB-level trigger enforcement | Blocker 4 |
| Section 3.5 | **New**: Partial Unique Index with SQL DDL | Blocker 4 |
| Section 3.6 Rollback | Clarified that existing outputs are not modified | Blocker 4 |
| Section 3.7 Effective Dates | Added effective_until, generation eligibility formula | Blocker 4 |
| Section 3.8 | **New**: DEPRECATED behavior section | Blocker 4 |
| Section 3.9 | **New**: Audit Trail section | Blocker 4 |
| Section 4.1 | **New**: TemplateService mandatory abstraction | Blocker 5 |
| Section 4.2 Pipeline | Added Compiled Template Cache stage | HPI 1 |
| Section 4.3 Stage 2 | **New**: Compiled Template Cache with LRU, invalidation | HPI 1 |
| Section 4.3 Stage 3 | Removed SQL reference, added batch resolution, Function Registry | Blockers 1, 3; HPI 7 |
| Section 4.4 | **New**: Error handling per stage table | New |
| Section 4.6 | **New**: Pipeline timeout table | New |
| Section 5 | **Complete rewrite**: Path Resolution Model replaces SQL | Blocker 1 |
| Section 5.4 | **New**: Entity Whitelist (15 roots, strict enforcement) | Blocker 2 |
| Section 5.5 | **New**: Function Registry (12 registered functions, no eval) | Blocker 3 |
| Section 5.6 | **New**: Batch Variable Resolution algorithm | HPI 7 |
| Section 5.7 | Recursive resolution with topological sort | Clarified |
| Section 6.2 | Added Path validity, Path syntax, Function registry, Variable schema, Enum values, Validation rules, Partial dependency checks | Blockers 1,2,3; HPI 2 |
| Section 6.3 | Added Effective dates, Enum values, Validation rules checks | Blocker 4; HPI 2 |
| Section 6.4 | Updated validation response with whitelist and function errors | Blockers 2,3 |
| Section 6.5 | Validation tests table (moved to entity catalog) | HPI 3 |
| Section 8.3 | **New**: Digital Signature Extension Point (interface only, no implementation) | HPI 4 |
| Section 10.3 | **New**: Multi-Stage Generation Authorization (SECURITY DEFINER) | HPI 8 |
| Section 10.4 | **New**: Delete Strategy (FOR DELETE USING false) | HPI 9 |
| Section 10.5 | **New**: Audit Requirements table | HPI 8 |
| Section 11.1 | Added output snapshot fields to audit table | HPI 3 |
| Section 13.3 | Added /rollback and /publish endpoints | Blocker 4 |
| Section 13.8 | **New**: Packages API endpoints | HPI 6 |
| Section 15.1 | All subsystems now route through TemplateService | Blocker 5 |
| Section 17.2 | Added "Replaceable" justification | Blocker 5 |
| Section 18 | Updated risks 2, 6, 7 to reflect new architecture | Blockers 1,3 |
| Section 20 | **Complete rewrite**: Validation (6.3) before Lifecycle (6.5), dedicated Seed Templates (6.2), split rendering (6.6-6.9), added Testing Strategy table | All blockers + HPIs |
| Entire doc | `source_query` removed; `resolver_path` + `resolver_function` + `entity_whitelist_root` used instead | Blockers 1,2,3 |

| Section | Change | Reason |
|---|---|---|
| Header | Updated to v1.1.1, added revision tag with refinements summary | v1.1.1 refinements |
| TOC | Added sub-section entries for §4.1-§4.7, §5.1-§5.7, added §4.7, §5.3.1 | Document readability |
| §4.1 (diagram) | Replaced monolithic Resolver with ResolverRegistry → Domain Resolvers → Repositories → DTO Layer; added Event Bus path | Change 6 (Resolver Registry), Change 7 (Repository Resolution) |
| §4.2 (pipeline) | Replaced Resolver with ResolverRegistry → DomainResolver → Repository → DTO | Changes 6, 7 |
| §4.3 Stage 2-3 | Updated for ResolverRegistry selection, domain resolver delegation, repository batch ops, per-request cache | Changes 6, 7 |
| §4.7 | **New section**: Event-Driven Generation with 14 domain events, subscriber contract, event bus architecture, retry policy | Change 8 |
| §5.1-§5.2 | **Complete rewrite**: Replaced Source Registry with ResolverRegistry pattern, 6 domain resolvers (Application, Committee, Workflow, Consent, Risk, Document), mandatory Resolver → Repository → DTO flow | Changes 6, 7 |
| §5.3 (path resolution) | Updated to show ResolverRegistry → domain resolver → repository → DTO flow instead of hardcoded joins | Changes 6, 7 |
| §5.3.1 | **New section**: Repository-Based Resolution with 6 domain repository contracts, typed DTOs, rules prohibiting SQL in resolvers | Change 7 |
| §5.4 (whitelist) | Updated enforcement to reference ResolverRegistry registration | Change 6 |
| §5.6 (batch) | Updated to show ResolverRegistry-coordinated batch across domain resolvers, repository eager-loading | Changes 6, 7 |
| §15.1 | Added Event Trigger column to integration matrix with 14 event mappings | Change 8 |
| §20 (intro) | Updated to mention Event-Driven Generation as 6th commit | Change 8 |
| §20 Commit 6.4 | **Expanded**: renamed "Resolver" to "Resolver Framework", added 6 domain resolvers, 6 repositories, DTO layer, ResolverRegistry | Changes 6, 7 |
| §20 Commit 6.6 | **New**: Event-Driven Generation commit | Change 8 |
| §20 commits 6.7-6.15 | Renumbered (6.7→Rendering, 6.8→PDF, 6.9→DOCX, 6.10→Remaining, 6.11→CRUD, 6.12-6.14→Frontend, 6.15→ETL) | Change 8 (insertion) |
| §20 Testing Strategy | Updated for Resolver Framework, Event-Driven, renumbered | Changes 6, 7, 8 |

---

**Resolved Blockers Summary:**

| Blocker | Resolution | Section(s) |
|---|---|---|
| B1: SQL in Variable Resolution | Replaced `source_query` (SQL text) with `resolver_path` (path notation). Resolver is ONLY component allowed to translate paths. No SQL in template definitions. | 2.2 (template_variables), 5.1-5.3 |
| B2: Entity Whitelist | Strict whitelist of 15 allowed roots. `entity.` generic prefix removed. Unknown roots rejected at validation with UNKNOWN_ENTITY_ROOT. | 5.4 |
| B3: Function Registry | Replaced `fn` strings with registered function registry. 12 functions defined (FORMAT_DATE, CONCAT, IF, etc.). No eval(), no arbitrary code. | 5.5 |
| B4: Version Integrity | Partial Unique Index `one_approved_version` enforces single APPROVED version at DB level. effective_from/effective_until documented. Generation eligibility formula defined. Rollback preserves prior outputs. | 3.5-3.8 |
| B5: TemplateService Layer | TemplateService is the mandatory abstraction. No subsystem calls Handlebars directly. Rendering engine replaceable behind this interface. | 4.1 |

**Additional Refinements (v1.1.1):**

| Refinement | Resolution | Section(s) |
|---|---|---|
| R6: Resolver Registry | Replaced monolithic switch statement with ResolverRegistry + 6 domain-specific resolvers (Application, Committee, Workflow, Consent, Risk, Document). Registry selects resolver by entity root. Adding new domain requires only new resolver + registration. | 5.2 |
| R7: Repository-Based Resolution | Resolvers delegate all persistence to domain-specific repositories. Resolvers never execute SQL, know table names, or reference database drivers. Repositories return typed DTOs. | 5.3.1, 5.6 |
| R8: Event-Driven Generation | Business modules publish domain events (14 defined) without knowing subscribers. TemplateService subscribes via Event Bus. Direct API generation remains supported. | 4.7 |

**Outstanding Risks:**

1. **Frontend editor complexity** (Risk 11): Non-technical users may struggle with the code editor even with visual blocks. Mitigation: real-time preview and rich text editing, but this is inherently a UX challenge.
2. **Migration data compatibility** (Risk 4): The three existing template systems have incompatible structures. The ETL scripts will need careful validation for each source system.
3. **Puppeteer resource usage** (Risk 3): Connection pooling mitigates but does not eliminate the risk of Chrome resource exhaustion under high concurrent load. Queue-based async generation is the primary defense.
4. **Localization drift** (Risk 8): Lack of automatic localization sync means Arabic/English versions can diverge. Mitigation is procedural (mandatory review) rather than technical.
5. **Resolver Registry proliferation** (New): Adding domain resolvers for future modules requires code changes (new resolver class + registration). Mitigation: lightweight registration mechanism; automated tests verify all whitelist roots have a registered resolver.
6. **Event bus reliability** (New): If the event bus goes down, event-driven generation is delayed. Mitigation: events are persisted in a queue table before publication; failed events are retried; direct API generation provides a bypass path.
7. **Repository layer duplication** (New): Each domain resolver needs its own repository, potentially duplicating existing repository code from other modules. Mitigation: repositories are lightweight wrappers that delegate to existing domain services where possible; DTO mapping is kept minimal.

---

**Document prepared for review. No code has been written. No database migrations have been executed. No frontend components have been created.**

**Architecture Document Version:** 1.1.1  
**Prepared for:** ERM Technical Review Board  
**Next Step:** Review and approval before Commit 6 begins
