# Administrator Guide — Template Management

**Version:** 1.0.0-rc2
**Last Updated:** 2026-07-22

---

## Table of Contents

1. [Overview](#1-overview)
2. [Template Library](#2-template-library)
3. [Creating Templates](#3-creating-templates)
4. [Managing Versions](#4-managing-versions)
5. [Version Lifecycle](#5-version-lifecycle)
6. [Preview and Render](#6-preview-and-render)
7. [Document Generation](#7-document-generation)
8. [Snapshot Verification](#8-snapshot-verification)
9. [Rollback](#9-rollback)
10. [Template Categories](#10-template-categories)
11. [Approval Workflow](#11-approval-workflow)
12. [API Quick Reference](#12-api-quick-reference)

---

## 1. Overview

The Template Engine manages document templates used throughout the Ethics ERM system. Templates define the structure and content of official documents such as:

- Application submission forms
- Approval certificates
- Condition letters
- Meeting minutes
- Accreditation certificates
- Consent forms
- Safety reports

### Key Concepts

| Concept | Description |
|---------|-------------|
| **Template** | A reusable document definition with a unique code (e.g., `certificate-approval`) |
| **Version** | A specific iteration of a template, identified by semver (e.g., `1.0.0`, `2.1.0`) |
| **Content** | Bilingual content (Arabic + English) with Handlebars template syntax |
| **Variables** | Dynamic fields within templates that are resolved at render time |
| **Snapshot** | An immutable record of a rendered document for audit purposes |
| **Module Key** | A logical identifier mapping business events to template codes (e.g., `application.approval`) |

### Access Roles

| Action | Required Roles |
|--------|---------------|
| View templates, versions, snapshots | Any authenticated user |
| Create/update/delete templates | ADMIN+ (SUPER_ADMIN, SYS_ADMIN, ADMIN, ETHICS_ADMIN) |
| Submit versions for review | ADMIN+ or version creator |
| Approve/reject versions | ETHICS_ADMIN, ETHICS_CHAIR, ETHICS_REVIEWER |
| Deprecate/archive versions | ADMIN+ |
| Rollback versions | ETHICS_ADMIN, SUPER_ADMIN only |
| Preview/render documents | ADMIN+ |

---

## 2. Template Library

### Browsing Templates

All templates are listed with:
- **Code** — unique identifier (e.g., `certificate-approval`)
- **Name** — bilingual (Arabic/English)
- **Category** — functional grouping
- **Engine** — template engine used (Handlebars)
- **Status** — active/inactive
- **Usage Count** — number of times rendered

### Filtering

Templates can be filtered by:
- Category ID
- Active/inactive status
- Search term (matches code, name, or description)

### Categories

Templates are organized into categories:

| Category | Purpose |
|----------|---------|
| Application | Templates for application lifecycle documents |
| Committee | Templates for committee operations |
| Accreditation | Templates for accreditation processes |
| Consent | Templates for informed consent documents |
| Safety | Templates for safety reporting |
| Notification | Templates for system notifications |
| Email | Templates for email communications |

---

## 3. Creating Templates

### Template Fields

| Field | Required | Description |
|-------|----------|-------------|
| `code` | Yes | Unique identifier, UPPER_SNAKE_CASE (e.g., `PROTOCOL_FULL`) |
| `category_id` | Yes | FK to categories table |
| `name_ar` | Yes | Arabic display name |
| `name_en` | Yes | English display name |
| `description` | No | Template description |
| `engine` | No | Default: `handlebars` |
| `default_locale` | No | Default: `ar` (Arabic) |
| `tags` | No | Array of search tags |

### Creating a Version

Each template has one or more versions. A version contains:

| Field | Required | Description |
|-------|----------|-------------|
| `template_id` | Yes | Parent template ID |
| `version` | Yes | Semver string (e.g., `1.0.0`), unique per template |
| `content` | Yes | Bilingual content object |
| `change_summary` | No | Description of changes |
| `variable_definitions` | No | Array of variable definitions |

### Content Structure

Content is a bilingual object with locale keys:

```json
{
  "ar": {
    "body": "<h1>بسم الله الرحمن الرحيم</h1><p>{{applicationTitle}}</p>",
    "header": "تقرير أخلاقيات البحث",
    "footer": "التوقيع: {{chairName}}"
  },
  "en": {
    "body": "<h1>In the Name of God</h1><p>{{applicationTitle}}</p>",
    "header": "Ethics Research Report",
    "footer": "Signed: {{chairName}}"
  }
}
```

### Variable Definitions

Variables are defined with metadata for validation and resolution:

```json
[
  {
    "code": "applicationTitle",
    "label_ar": "عنوان الطلب",
    "label_en": "Application Title",
    "type": "string",
    "required": true,
    "source": "entity",
    "resolver_path": "Application.repository.getTitle"
  },
  {
    "code": "chairName",
    "label_ar": "اسم رئيس اللجنة",
    "label_en": "Committee Chair Name",
    "type": "string",
    "required": true,
    "source": "user",
    "default": ""
  }
]
```

### Variable Types

| Type | Description |
|------|-------------|
| `string` | Text value |
| `number` | Numeric value |
| `date` | Date value |
| `boolean` | True/false |
| `array` | List of values |
| `object` | Nested object |
| `enum` | Predefined choices |

---

## 4. Managing Versions

### Version States

| State | Description | Content Editable? |
|-------|-------------|-------------------|
| **DRAFT** | Initial state, content can be modified | Yes |
| **REVIEW** | Submitted for approval | No |
| **APPROVED** | Active, used for rendering | No |
| **DEPRECATED** | Superseded or rolled back | No |
| **ARCHIVED** | Permanent, frozen | No |

### Version Operations

| Operation | From → To | Authorized Roles |
|-----------|-----------|-----------------|
| Create | — → DRAFT | ADMIN+ |
| Edit | DRAFT → DRAFT | ADMIN+ |
| Submit | DRAFT → REVIEW | ADMIN+ or version creator |
| Approve | REVIEW → APPROVED | ETHICS_ADMIN, ETHICS_CHAIR, ETHICS_REVIEWER |
| Reject | REVIEW → DRAFT | ETHICS_ADMIN, ETHICS_CHAIR, ETHICS_REVIEWER |
| Deprecate | APPROVED → DEPRECATED | ADMIN+ |
| Archive | DEPRECATED → ARCHIVED | ADMIN+ |
| Rollback | DEPRECATED → APPROVED | ETHICS_ADMIN, SUPER_ADMIN |

### Lifecycle State Diagram

```
                    ┌──────────┐
                    │  DRAFT   │ ← Content editable
                    └────┬─────┘
                         │ submit
                         ▼
                    ┌──────────┐
                    │  REVIEW  │ ← Awaiting approval
                    └────┬─────┘
                    ╱         ╲
            approve           reject
              ╱                   ╲
             ▼                     ▼
    ┌──────────────┐        ┌──────────┐
    │   APPROVED   │───────▶│  DRAFT   │
    └──────┬───────┘        └──────────┘
           │ deprecate
           ▼
    ┌──────────────┐
    │ DEPRECATED   │
    └──────┬───────┘
      ╱         ╲
  archive     rollback
    ╱             ╲
   ▼               ▼
┌──────────┐  ┌──────────────┐
│ ARCHIVED │  │   APPROVED   │ ← Terminal
└──────────┘  └──────────────┘
```

---

## 5. Version Lifecycle

### Submit for Review

Before submitting, the system runs a 7-check validation sequence:

1. **Structural validation** — content has required fields, valid Handlebars syntax
2. **State transition validity** — version must be in DRAFT
3. **Business preconditions** — content exists with `ar.body` or `en.body`
4. **Authorization** — user has ADMIN+ role or is the version creator
5. **Effective dates** — date ranges are valid if specified
6. **Approval workflow** — not checked at submit (checked at approve)
7. **Status consistency** — version status matches expected state

**API Call:**
```bash
curl -X POST http://localhost:8080/api/v1/templates/versions/:id/submit \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"comment": "Ready for review"}'
```

### Approve

When approving a version in REVIEW:

1. All approval workflow steps must be APPROVED (if any exist)
2. Any previously APPROVED version for the same template is **automatically deprecated** (SUPERSEDED)

**API Call:**
```bash
curl -X POST http://localhost:8080/api/v1/templates/versions/:id/approve \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"comment": "Approved for production use"}'
```

### Reject

Rejection requires a reason and returns the version to DRAFT:

**API Call:**
```bash
curl -X POST http://localhost:8080/api/v1/templates/versions/:id/reject \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"reason": "Missing required variables in Arabic content"}'
```

---

## 6. Preview and Render

### Preview (No Snapshot)

Preview renders the template without creating an audit record:

```bash
curl -X POST http://localhost:8080/api/v1/templates/template-preview \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "templateCode": "certificate-approval",
    "version": "1.0.0",
    "locale": "ar",
    "variables": {
      "applicationTitle": "بحث تجريبي",
      "chairName": "د. أحمد محمد"
    }
  }'
```

**Response:**
```json
{
  "success": true,
  "data": {
    "html": "<h1>بسم الله الرحمن الرحيم</h1><p>بحث تجريبي</p>",
    "renderResult": {
      "cacheHit": false,
      "resolutionTimeMs": 5,
      "variableCount": 2
    }
  }
}
```

### Render (With Snapshot)

Render creates an immutable snapshot for audit:

```bash
curl -X POST http://localhost:8080/api/v1/templates/template-render \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "templateCode": "certificate-approval",
    "version": "1.0.0",
    "locale": "ar",
    "entityType": "Application",
    "entityId": 1,
    "variables": {
      "applicationTitle": "بحث تجريبي"
    }
  }'
```

**Response includes:**
- `html` — rendered HTML
- `snapshot` — snapshot object with hash, timestamp, correlation ID
- `snapshotHash` — SHA-256 hash for verification
- `correlationId` — UUID linking the render request

### Variable Resolution Priority

1. **Default values** from `variable_definitions`
2. **Entity/computed values** from resolver service (if `entityType` + `entityId` provided)
3. **User-provided values** (override all above)

---

## 7. Document Generation

### Module Keys

Module keys map business events to template codes:

| Module Key | Template Code | Use Case |
|-----------|---------------|----------|
| `application.submission` | `protocol-full` | Application submission |
| `application.approval` | `certificate-approval` | Approval certificate |
| `application.conditional` | `condition-letter` | Conditional approval |
| `application.rejection` | `decision-standard` | Rejection letter |
| `meeting.agenda` | `meeting-minutes` | Meeting agenda |
| `meeting.minutes` | `meeting-minutes` | Meeting minutes |
| `committee.review` | `decision-standard` | Committee review |
| `accreditation.decision` | `accreditation-cert` | Accreditation decision |
| `consent.form` | `consent-standard` | Consent form |
| `safety.report` | `safety-report` | Safety report |

### Document Preview

```bash
curl -X POST http://localhost:8080/api/v1/templates/preview \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "moduleKey": "application.approval",
    "entityType": "Application",
    "entityId": 1,
    "locale": "ar"
  }'
```

### Document Render

```bash
curl -X POST http://localhost:8080/api/v1/templates/render \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "moduleKey": "application.approval",
    "entityType": "Application",
    "entityId": 1,
    "locale": "ar"
  }'
```

---

## 8. Snapshot Verification

### List Snapshots

```bash
curl "http://localhost:8080/api/v1/templates/template-snapshots?templateVersionId=1" \
  -H "Authorization: Bearer <token>"
```

### Get Snapshot by Hash

```bash
curl "http://localhost:8080/api/v1/templates/template-snapshots/<sha256-hash>" \
  -H "Authorization: Bearer <token>"
```

### Verify Snapshot Integrity

```bash
curl -X POST http://localhost:8080/api/v1/templates/template-snapshots/verify \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"hash": "<sha256-hash>"}'
```

**Response:**
```json
{
  "success": true,
  "data": {
    "valid": true,
    "match": true
  }
}
```

The system recomputes the hash from stored components (templateVersionId, contentHash, resolvedVariablesHash, locale, renderedHtml) and compares it with the stored hash.

---

## 9. Rollback

Rollback restores a DEPRECATED version to APPROVED status.

### Prerequisites

- Version must be in DEPRECATED status
- User must be ETHICS_ADMIN or SUPER_ADMIN

### Rollback Process

1. System validates the version is DEPRECATED
2. Captures current timeline state
3. Sets version to APPROVED (clears effective dates)
4. Auto-deprecates any previously active version (SUPERSEDED)
5. Verifies content integrity (hash comparison)
6. Checks chronology consistency (no overlapping APPROVED periods)
7. Returns full impact report

### API Call

```bash
curl -X POST http://localhost:8080/api/v1/templates/template-rollback \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "templateCode": "certificate-approval",
    "version": "1.0.0",
    "reason": "Version 2.0.0 has critical issues"
  }'
```

**Response:**
```json
{
  "success": true,
  "data": {
    "versionId": 1,
    "previousStatus": "DEPRECATED",
    "newStatus": "APPROVED",
    "contentIntegrityVerified": true,
    "impact": {
      "timelineBefore": [...],
      "timelineAfter": [...]
    },
    "consistencyVerified": true,
    "consistencyIssues": []
  }
}
```

---

## 10. Template Categories

Categories are read-only and pre-seeded:

```bash
# List all categories
curl http://localhost:8080/api/v1/templates/categories \
  -H "Authorization: Bearer <token>"

# Get specific category
curl http://localhost:8080/api/v1/templates/categories/:id \
  -H "Authorization: Bearer <token>"
```

Categories cannot be created, updated, or deleted through the API.

---

## 11. Approval Workflow

### Setting Up Approval Steps

Approval steps are configured per template version and define the review process:

| Field | Description |
|-------|-------------|
| `step_order` | Sequential order (1, 2, 3...) |
| `approver_role` | Role required to approve (e.g., `ETHICS_CHAIR`) |
| `approver_id` | Optional specific user ID |

### Approval Flow

1. Admin initiates approval workflow for a version in REVIEW
2. Each step is assigned to a user with the required role
3. Each step goes through: PENDING → APPROVED/REJECTED
4. All steps must be APPROVED before the version-level approve is allowed

### Checking Status

```bash
curl "http://localhost:8080/api/v1/templates/versions/:id" \
  -H "Authorization: Bearer <token>"
```

The version response includes approval workflow status.

---

## 12. API Quick Reference

### Template CRUD

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/v1/templates` | List templates |
| `GET` | `/api/v1/templates/:id` | Get template |
| `POST` | `/api/v1/templates` | Create template |
| `PUT` | `/api/v1/templates/:id` | Update template |
| `DELETE` | `/api/v1/templates/:id` | Delete template |

### Version Management

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/v1/templates/versions` | List versions |
| `GET` | `/api/v1/templates/versions/:id` | Get version |
| `POST` | `/api/v1/templates/versions` | Create version |
| `PUT` | `/api/v1/templates/versions/:id` | Update version |
| `POST` | `/api/v1/templates/versions/:id/submit` | Submit for review |
| `POST` | `/api/v1/templates/versions/:id/approve` | Approve version |
| `POST` | `/api/v1/templates/versions/:id/reject` | Reject version |
| `POST` | `/api/v1/templates/versions/:id/deprecate` | Deprecate version |
| `POST` | `/api/v1/templates/versions/:id/archive` | Archive version |

### Rendering

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/v1/templates/template-preview` | Preview (no snapshot) |
| `POST` | `/api/v1/templates/template-render` | Render (with snapshot) |
| `POST` | `/api/v1/templates/preview` | Document preview by module key |
| `POST` | `/api/v1/templates/render` | Document render by module key |

### Snapshots & History

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/v1/templates/template-snapshots` | List snapshots |
| `GET` | `/api/v1/templates/template-snapshots/:hash` | Get snapshot |
| `POST` | `/api/v1/templates/template-snapshots/verify` | Verify snapshot |
| `GET` | `/api/v1/templates/template-history` | Version history |
| `POST` | `/api/v1/templates/template-rollback` | Rollback version |

### Categories & Config

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/v1/templates/categories` | List categories |
| `GET` | `/api/v1/templates/categories/:id` | Get category |
| `GET` | `/api/v1/templates/module-keys` | List module keys |
| `GET` | `/api/v1/templates/module-config/:key` | Get module config |
