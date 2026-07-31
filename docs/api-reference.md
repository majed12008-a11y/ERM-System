# API Reference — Ethics ERM System

**Base URL:** `http://localhost:8080/api/v1`
**Version:** 1.0.0-rc2
**Authentication:** JWT Bearer token (HS256)

---

## Table of Contents

1. [Authentication](#1-authentication)
2. [Authorization](#2-authorization)
3. [Pagination](#3-pagination)
4. [Error Format](#4-error-format)
5. [Rate Limiting](#5-rate-limiting)
6. [API Modules](#6-api-modules)
   - [Monitoring](#61-monitoring)
   - [Security](#62-security)
   - [Core](#63-core)
   - [Committee](#64-committee)
   - [Workflow](#65-workflow)
   - [Documents](#66-documents)
   - [Communication](#67-communication)
   - [Safety](#68-safety)
   - [Reporting](#69-reporting)
   - [Admin](#610-admin)
   - [Integration](#611-integration)
   - [System](#612-system)
   - [Reference](#613-reference)
   - [Public](#614-public)
   - [Templates](#615-templates)

---

## 1. Authentication

### Login

```
POST /api/v1/security/auth/login
```

**Request:**
```json
{
  "username": "admin",
  "password": "password123"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIs...",
    "userId": 1
  }
}
```

The access token is a JWT (HS256) with 15-minute expiry. The refresh token is set as an httpOnly cookie (`refreshToken`) with 7-day expiry, scoped to `/api/v1/security/auth`.

### Using the Token

```
Authorization: Bearer <accessToken>
```

### Refresh Token

```
POST /api/v1/security/auth/refresh
Cookie: refreshToken=<refreshToken>
```

Returns a new access/refresh token pair. The old refresh token is rotated.

### Token Types

| Type | Expiry | Usage |
|------|--------|-------|
| `access` | 15 minutes | API requests (`Authorization: Bearer` header) |
| `refresh` | 7 days | Token renewal (httpOnly cookie) |

**Important:** Refresh tokens must NOT be used as access tokens. The server rejects them with `401 "Access token required"`.

### Other Auth Endpoints

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| `POST` | `/security/auth/register` | No | Create new user account |
| `POST` | `/security/auth/forgot-password` | No | Request password reset email |
| `POST` | `/security/auth/reset-password` | No | Reset password with token |
| `POST` | `/security/auth/verify-email` | No | Verify email address |
| `POST` | `/security/auth/logout` | Yes | Invalidate session |
| `GET` | `/security/auth/me` | Yes | Get current user info |
| `POST` | `/security/auth/resend-verification` | Yes | Resend verification email |
| `POST` | `/security/auth/change-password` | Yes | Change password |

---

## 2. Authorization

### Role Hierarchy

```
SUPER_ADMIN          (full system access, bypasses all role checks)
  └── SYS_ADMIN      (admin operations, user/role management)
      └── ADMIN      (admin operations)
          └── ETHICS_ADMIN  (workflow, conditions, certificates, committees)
              └── COMMITTEE_CHAIR  (committee-specific operations)
                  └── REVIEWER  (review forms, ethics risk items)
                      └── RESEARCHER  (create projects/applications)
                          └── INST_COORDINATOR  (institution-level)
```

### `authorize()` Middleware

- `SUPER_ADMIN` bypasses all role checks — can access any role-gated endpoint.
- If no roles are specified in `authorize()`, any authenticated user passes.
- Returns `403 "Insufficient permissions"` if the user lacks the required roles.

---

## 3. Pagination

### Request Parameters

| Parameter | Default | Range | Description |
|-----------|---------|-------|-------------|
| `page` | `1` | ≥ 1 | Page number |
| `limit` | `20` | 1–100 | Items per page |

**Example:** `GET /api/v1/core/applications?page=2&limit=50`

### Response Format

```json
{
  "success": true,
  "data": [ ... ],
  "pagination": {
    "page": 2,
    "limit": 50,
    "total": 150,
    "totalPages": 3
  }
}
```

---

## 4. Error Format

### Standard Error Envelope

```json
{
  "success": false,
  "error": "Error message",
  "requestId": "01923456-7890-..."
}
```

### HTTP Status Codes

| Code | Meaning |
|------|---------|
| `400` | Validation error (Zod) |
| `401` | Not authenticated / invalid token |
| `403` | Insufficient permissions |
| `404` | Resource not found |
| `409` | Conflict (duplicate) |
| `429` | Rate limit exceeded |
| `500` | Internal server error |

### Validation Error Detail

Zod validation errors are formatted as semicolon-separated strings:

```json
{
  "success": false,
  "error": "username: Required; email: Invalid email",
  "requestId": "-"
}
```

---

## 5. Rate Limiting

All endpoints are subject to a global rate limit of **60 requests/minute** (configurable via `RATE_LIMIT_GLOBAL_MAX`).

### Auth-Specific Limits

| Endpoint | Limit | Env Variable |
|----------|-------|-------------|
| Login | 10/min | `RATE_LIMIT_LOGIN_MAX` |
| Register | 5/min | `RATE_LIMIT_REGISTER_MAX` |
| Forgot Password | 3/min | `RATE_LIMIT_FORGOT_MAX` |
| Reset Password | 5/min | `RATE_LIMIT_RESET_PASSWORD_MAX` |
| Refresh Token | 10/min | `RATE_LIMIT_REFRESH_MAX` |
| Resend Verification | 5/min | `RATE_LIMIT_RESEND_VERIFICATION_MAX` |

Rate limit headers are included in responses:
```
RateLimit-Limit: 60
RateLimit-Remaining: 59
RateLimit-Reset: 1640995200
```

---

## 6. API Modules

### 6.1 Monitoring

**Base:** `/api/v1/monitoring`
**Auth:** None (health probes), Admin (audit/config)
**Purpose:** System health, readiness, metrics, and audit configuration.

| Method | Path | Auth | Roles | Description |
|--------|------|------|-------|-------------|
| `GET` | `/live` | No | — | Liveness probe |
| `GET` | `/ready` | No | — | Readiness probe (DB check) |
| `GET` | `/health` | No | — | Detailed health status |
| `GET` | `/metrics` | No | — | System metrics |
| `GET` | `/audit` | Yes | SUPER_ADMIN, SYS_ADMIN | Audit log configuration |
| `GET` | `/config` | Yes | SUPER_ADMIN, SYS_ADMIN | System configuration |

---

### 6.2 Security

**Base:** `/api/v1/security`
**Purpose:** Authentication, user management, roles, permissions, profiles.

#### Auth Routes

| Method | Path | Auth | Validation | Description |
|--------|------|------|------------|-------------|
| `POST` | `/auth/login` | No | `loginSchema` | Authenticate user |
| `POST` | `/auth/register` | No | `registerSchema` | Create account |
| `POST` | `/auth/forgot-password` | No | `forgotPasswordSchema` | Request reset email |
| `POST` | `/auth/reset-password` | No | `resetPasswordSchema` | Reset password |
| `POST` | `/auth/refresh` | No | — | Refresh access token |
| `POST` | `/auth/logout` | Yes | — | End session |
| `GET` | `/auth/me` | Yes | — | Current user info |
| `POST` | `/auth/verify-email` | No | `verifyEmailSchema` | Verify email |
| `POST` | `/auth/resend-verification` | Yes | — | Resend verification |
| `POST` | `/auth/change-password` | Yes | `changePasswordSchema` | Change password |

#### Users

| Method | Path | Auth | Roles | Validation | Description |
|--------|------|------|-------|------------|-------------|
| `GET` | `/users` | Yes | ADMIN+ | — | List users |
| `GET` | `/users/:id` | Yes | — | — | Get user by ID |
| `POST` | `/users` | Yes | SUPER_ADMIN, SYS_ADMIN, ADMIN | `createUserSchema` | Create user |
| `PUT` | `/users/:id` | Yes | SUPER_ADMIN, SYS_ADMIN, ADMIN | `updateUserSchema` | Update user |

#### Roles

| Method | Path | Auth | Roles | Validation | Description |
|--------|------|------|-------|------------|-------------|
| `GET` | `/roles` | Yes | ADMIN+ | — | List roles |
| `GET` | `/roles/:id` | Yes | ADMIN+ | — | Get role |
| `POST` | `/roles` | Yes | SUPER_ADMIN | `createRoleSchema` | Create role |
| `PUT` | `/roles/:id` | Yes | SUPER_ADMIN | `updateRoleSchema` | Update role |

#### Permissions

| Method | Path | Auth | Roles | Validation | Description |
|--------|------|------|-------|------------|-------------|
| `GET` | `/permissions` | Yes | ADMIN+ | — | List permissions |
| `POST` | `/permissions` | Yes | SUPER_ADMIN | `createPermissionSchema` | Create permission |
| `DELETE` | `/permissions/:id` | Yes | SUPER_ADMIN | — | Delete permission |
| `GET` | `/permissions/role/:roleId` | Yes | ADMIN+ | — | Get role permissions |
| `PUT` | `/permissions/role/:roleId` | Yes | SUPER_ADMIN | `setRolePermissionsSchema` | Set role permissions |

#### Profiles

| Method | Path | Auth | Roles | Validation | Description |
|--------|------|------|-------|------------|-------------|
| `GET` | `/profile` | Yes | — | — | Get own profile |
| `PUT` | `/profile` | Yes | — | `upsertProfileSchema` | Update own profile |
| `GET` | `/profile/:userId` | Yes | ADMIN+ | — | Get user profile |

#### Responsibility

| Method | Path | Auth | Roles | Validation | Description |
|--------|------|------|-------|------------|-------------|
| `GET` | `/responsibility-types` | Yes | — | — | List types |
| `GET` | `/user-responsibilities` | Yes | — | — | List user responsibilities |
| `POST` | `/user-responsibilities` | Yes | ADMIN+ | `createResponsibilitySchema` | Assign responsibility |
| `DELETE` | `/user-responsibilities/:id` | Yes | ADMIN+ | — | Remove responsibility |

---

### 6.3 Core

**Base:** `/api/v1/core`
**Purpose:** Projects, applications, conditions, evidence, certificates, lookups.

#### Projects

| Method | Path | Auth | Roles | Validation | Description |
|--------|------|------|-------|------------|-------------|
| `GET` | `/projects` | Yes | — | — | List projects |
| `GET` | `/projects/:id` | Yes | — | — | Get project |
| `POST` | `/projects` | Yes | RESEARCHER+ | `createProjectSchema` | Create project |
| `GET` | `/projects/:id/applications` | Yes | — | — | List project applications |
| `GET` | `/projects/:id/stats` | Yes | — | — | Project statistics |

#### Applications

| Method | Path | Auth | Roles | Validation | Description |
|--------|------|------|-------|------------|-------------|
| `GET` | `/applications` | Yes | — | — | List applications |
| `GET` | `/applications/:id` | Yes | — | — | Get application |
| `POST` | `/applications` | Yes | RESEARCHER, INST_COORDINATOR | `createApplicationSchema` | Create application |
| `PUT` | `/applications/:id` | Yes | — | `updateApplicationSchema` | Update application |
| `PATCH` | `/applications/:id/status` | Yes | — | `updateApplicationStatusSchema` | Update status |
| `POST` | `/applications/:id/withdraw` | Yes | RESEARCHER | `withdrawApplicationSchema` | Withdraw |
| `POST` | `/applications/:id/appeal` | Yes | RESEARCHER | `appealApplicationSchema` | Appeal |
| `POST` | `/applications/:id/renewal` | Yes | ETHICS_ADMIN, SUPER_ADMIN | — | Renew |
| `GET` | `/applications/:id/sla` | Yes | — | — | SLA info |
| `GET` | `/applications/:id/history` | Yes | — | — | Status history |

#### Conditions

| Method | Path | Auth | Roles | Validation | Description |
|--------|------|------|-------|------------|-------------|
| `GET` | `/applications/:aid/conditions` | Yes | — | — | List conditions |
| `POST` | `/applications/:aid/conditions` | Yes | ETHICS_ADMIN+ | `createConditionSchema` | Create condition |
| `PUT` | `/applications/:aid/conditions/:id` | Yes | ETHICS_ADMIN+ | `updateConditionSchema` | Update condition |
| `PATCH` | `/applications/:aid/conditions/:id/resolve` | Yes | ETHICS_ADMIN+ | `resolveConditionSchema` | Resolve condition |
| `DELETE` | `/applications/:aid/conditions/:id` | Yes | ETHICS_ADMIN+ | — | Delete condition |
| `GET` | `/applications/:aid/conditions/summary` | Yes | — | — | Conditions summary |

#### Evidence

| Method | Path | Auth | Roles | Validation | Description |
|--------|------|------|-------|------------|-------------|
| `POST` | `/applications/:aid/conditions/:cid/evidence` | Yes | — | `uploadEvidenceSchema` | Upload evidence |
| `GET` | `/applications/:aid/conditions/:cid/evidence` | Yes | — | — | List evidence |
| `DELETE` | `/applications/:aid/conditions/:cid/evidence/:eid` | Yes | — | — | Delete evidence |

#### Certificates

| Method | Path | Auth | Roles | Validation | Description |
|--------|------|------|-------|------------|-------------|
| `GET` | `/applications/:aid/certificates` | Yes | — | — | List certificates |
| `GET` | `/applications/:aid/certificates/:id` | Yes | — | — | Get certificate |
| `POST` | `/applications/:aid/certificates/:id/reissue` | Yes | ETHICS_ADMIN+ | — | Reissue |
| `POST` | `/applications/:aid/certificates/:id/retry` | Yes | ETHICS_ADMIN+ | — | Retry generation |
| `POST` | `/applications/:aid/certificates/:id/revoke` | Yes | ETHICS_ADMIN+ | `revokeCertificateSchema` | Revoke |
| `GET` | `/applications/:aid/certificates/:id/download` | Yes | — | — | Download PDF |

#### Lookups

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| `GET` | `/research-categories` | Yes | Research categories |
| `GET` | `/risk-classifications` | Yes | Risk levels |
| `GET` | `/vulnerable-populations` | Yes | Vulnerable populations |
| `GET` | `/research-population-links` | Yes | Population-category links |

---

### 6.4 Committee

**Base:** `/api/v1/committee`
**Purpose:** Committees, meetings, reviews, voting, ethics risk, consent, accreditation.

**102 routes** across 8 sub-modules. Key endpoints:

#### Committees

| Method | Path | Auth | Roles | Description |
|--------|------|------|-------|-------------|
| `GET` | `/committees` | Yes | — | List committees |
| `POST` | `/committees` | Yes | ETHICS_ADMIN+ | Create committee |
| `PUT` | `/committees/:id` | Yes | ETHICS_ADMIN+ | Update committee |
| `DELETE` | `/committees/:id` | Yes | ETHICS_ADMIN+ | Delete committee |
| `GET` | `/committees/:id/members` | Yes | — | List members |
| `POST` | `/committees/:id/members` | Yes | ETHICS_ADMIN+ | Add member |
| `PUT` | `/committees/:id/members/:mid` | Yes | ETHICS_ADMIN+ | Update member |
| `DELETE` | `/committees/:id/members/:mid` | Yes | ETHICS_ADMIN+ | Remove member |

#### Meetings

| Method | Path | Auth | Roles | Description |
|--------|------|------|-------|-------------|
| `GET` | `/meetings` | Yes | — | List meetings |
| `POST` | `/meetings` | Yes | COMMITTEE_CHAIR, ETHICS_ADMIN | Create meeting |
| `GET` | `/meetings/:id` | Yes | — | Get meeting |
| `GET` | `/meetings/:id/agenda` | Yes | — | Get agenda |
| `POST` | `/meetings/:id/agenda` | Yes | COMMITTEE_CHAIR, ETHICS_ADMIN | Create agenda |
| `POST` | `/meetings/:id/attendance` | Yes | — | Record attendance |
| `GET` | `/meetings/:id/minutes` | Yes | — | Get minutes |
| `POST` | `/meetings/:id/minutes` | Yes | COMMITTEE_CHAIR, ETHICS_ADMIN | Create minutes |
| `PATCH` | `/meetings/:id/minutes/:mid/approve` | Yes | COMMITTEE_CHAIR, ETHICS_ADMIN | Approve minutes |

#### Reviews

| Method | Path | Auth | Roles | Description |
|--------|------|------|-------|-------------|
| `GET` | `/reviews/my` | Yes | — | My review assignments |
| `POST` | `/reviews/assign` | Yes | ETHICS_ADMIN+ | Assign reviewer |
| `POST` | `/reviews/:aid/submit` | Yes | — | Submit review |
| `GET` | `/reviews/forms` | Yes | — | List review forms |
| `POST` | `/reviews/forms` | Yes | ETHICS_ADMIN+ | Create review form |

#### Voting

| Method | Path | Auth | Roles | Description |
|--------|------|------|-------|-------------|
| `POST` | `/voting/sessions` | Yes | COMMITTEE_CHAIR, ETHICS_ADMIN | Create voting session |
| `POST` | `/voting/sessions/:id/vote` | Yes | — | Cast vote |
| `POST` | `/voting/sessions/:id/close` | Yes | COMMITTEE_CHAIR, ETHICS_ADMIN | Close vote |

#### Ethics Risk Assessment

| Method | Path | Auth | Roles | Description |
|--------|------|------|-------|-------------|
| `GET` | `/ethics-risk/categories` | Yes | — | Risk categories |
| `POST` | `/ethics-risk` | Yes | ETHICS_ADMIN+ | Create assessment |
| `PUT` | `/ethics-risk/:id` | Yes | ETHICS_ADMIN+ | Update assessment |
| `POST` | `/ethics-risk/:aid/items` | Yes | ETHICS_ADMIN+ | Add risk item |

#### Consent

| Method | Path | Auth | Roles | Description |
|--------|------|------|-------|-------------|
| `GET` | `/consent/templates` | Yes | — | List templates |
| `POST` | `/consent/templates` | Yes | ETHICS_ADMIN+ | Create template |
| `POST` | `/consent/templates/:tid/versions` | Yes | ETHICS_ADMIN+ | Create version |
| `POST` | `/consent/versions/:id/approve` | Yes | ETHICS_ADMIN+ | Approve version |
| `POST` | `/consent/application-consents` | Yes | ETHICS_ADMIN+ | Assign consent |

#### Accreditation

| Method | Path | Auth | Roles | Description |
|--------|------|------|-------|-------------|
| `GET` | `/accreditation/cycles` | Yes | — | List cycles |
| `POST` | `/accreditation/cycles` | Yes | ETHICS_ADMIN+ | Create cycle |
| `GET` | `/accreditation/standards` | Yes | — | List standards |
| `POST` | `/accreditation/cycles/:cid/assessments` | Yes | ETHICS_ADMIN+ | Create assessment |
| `POST` | `/accreditation/cycles/:cid/evidence` | Yes | — | Upload evidence |
| `POST` | `/accreditation/cycles/:cid/conditions` | Yes | ETHICS_ADMIN+ | Add condition |
| `POST` | `/accreditation/cycles/:cid/decisions` | Yes | ETHICS_ADMIN+ | Record decision |

---

### 6.5 Workflow

**Base:** `/api/v1/workflow`
**Purpose:** Workflow state machine operations.

| Method | Path | Auth | Validation | Description |
|--------|------|------|------------|-------------|
| `GET` | `/definitions` | Yes | — | List workflow definitions |
| `GET` | `/instances/:entityType/:entityId` | Yes | — | Get workflow instance |
| `GET` | `/available-transitions/:entityType/:entityId` | Yes | — | Available transitions |
| `POST` | `/execute-transition` | Yes | `executeTransitionSchema` | Execute transition |

---

### 6.6 Documents

**Base:** `/api/v1/documents`
**Purpose:** Document management, upload, download, signing.

| Method | Path | Auth | Validation | Description |
|--------|------|------|------------|-------------|
| `GET` | `/` | Yes | — | List documents |
| `GET` | `/types` | Yes | — | Document types |
| `GET` | `/classifications` | Yes | — | Classifications |
| `GET` | `/pending-signatures` | Yes | — | Pending signatures |
| `GET` | `/entity/:entityType/:entityId` | Yes | — | Documents by entity |
| `GET` | `/:id` | Yes | — | Get document |
| `GET` | `/:id/download` | Yes | — | Download document |
| `GET` | `/:id/preview` | Yes | — | Preview document |
| `POST` | `/` | Yes | `uploadDocumentSchema` | Upload document |
| `POST` | `/:id/sign` | Yes | `signDocumentSchema` | Sign document |
| `GET` | `/:id/signatures` | Yes | — | List signatures |
| `POST` | `/:id/restore` | Yes | — | Restore soft-deleted |
| `DELETE` | `/:id` | Yes | — | Soft-delete document |

---

### 6.7 Communication

**Base:** `/api/v1/communication`
**Purpose:** Messages, notifications, real-time SSE streams.

#### Messages

| Method | Path | Auth | Validation | Description |
|--------|------|------|------------|-------------|
| `GET` | `/messages` | Yes | — | List messages |
| `GET` | `/messages/unread-count` | Yes | — | Unread count |
| `GET` | `/messages/:id` | Yes | — | Get message |
| `POST` | `/messages` | Yes | `createMessageSchema` | Send message |
| `DELETE` | `/messages/:id` | Yes | — | Delete message |
| `GET` | `/messages/:id/attachments/:aid` | Yes | — | Download attachment |
| `GET` | `/users/search` | Yes | — | Search users |

#### Notifications

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| `GET` | `/notifications` | Yes | List notifications |
| `GET` | `/notifications/unread-count` | Yes | Unread count |
| `PATCH` | `/notifications/:id/read` | Yes | Mark as read |
| `PATCH` | `/notifications/read-all` | Yes | Mark all as read |
| `DELETE` | `/notifications/:id` | Yes | Delete notification |
| `GET` | `/notifications/stream` | Query token | SSE stream |

---

### 6.8 Safety

**Base:** `/api/v1/safety`
**Purpose:** Adverse events, risk register, corrective actions.

| Method | Path | Auth | Roles | Validation | Description |
|--------|------|------|-------|------------|-------------|
| `GET` | `/adverse-events` | Yes | — | — | List adverse events |
| `POST` | `/adverse-events` | Yes | — | `createAdverseEventSchema` | Report event |
| `GET` | `/serious-adverse-events` | Yes | — | — | List SAEs |
| `GET` | `/safety-reports` | Yes | — | — | Safety reports |
| `GET` | `/risk-register` | Yes | — | — | Risk register |
| `POST` | `/risk-register` | Yes | ADMIN+ | `createRiskIncidentSchema` | Add risk |
| `PUT` | `/risk-register/:id` | Yes | ADMIN+ | `updateRiskRegisterSchema` | Update risk |
| `DELETE` | `/risk-register/:id` | Yes | ADMIN+ | — | Delete risk |
| `POST` | `/risk-register/:id/mitigations` | Yes | ADMIN+ | `createMitigationSchema` | Add mitigation |
| `GET` | `/risk-incidents` | Yes | — | — | List incidents |
| `POST` | `/risk-incidents` | Yes | — | `createRiskIncidentSchema` | Report incident |
| `GET` | `/corrective-actions` | Yes | — | — | List actions |
| `POST` | `/corrective-actions` | Yes | ADMIN+ | `createCorrectiveActionSchema` | Create action |

---

### 6.9 Reporting

**Base:** `/api/v1/reporting`
**Purpose:** Dashboard statistics, trend reports, data export.

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| `GET` | `/dashboard/stats` | Yes | Dashboard statistics |
| `GET` | `/dashboard/stream` | Query token | SSE dashboard stream |
| `GET` | `/applications` | Yes | Application report |
| `GET` | `/committees` | Yes | Committee report |
| `GET` | `/status-summary` | Yes | Status summary |
| `GET` | `/applications-trend` | Yes | Trend data |
| `GET` | `/export/applications` | Yes | Export applications |

---

### 6.10 Admin

**Base:** `/api/v1/admin`
**Purpose:** System administration, configuration, backup, reference data.

All admin routes require `SUPER_ADMIN`, `SYS_ADMIN`, or `ADMIN` roles.

#### General Admin

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| `GET` | `/stats` | ADMIN+ | Admin statistics |
| `GET` | `/audit-log` | ADMIN+ | Audit log |
| `GET` | `/audit-log/actions` | ADMIN+ | Audit actions |
| `GET` | `/online-users` | ADMIN+ | Online users |
| `GET` | `/recent-activity` | ADMIN+ | Recent activity |

#### Email Configuration

| Method | Path | Auth | Validation | Description |
|--------|------|------|------------|-------------|
| `GET` | `/email-config` | ADMIN+ | — | List configs |
| `GET` | `/email-config/active` | ADMIN+ | — | Active config |
| `POST` | `/email-config` | ADMIN+ | `createEmailConfigSchema` | Create config |
| `PUT` | `/email-config/:id` | ADMIN+ | `updateEmailConfigSchema` | Update config |
| `DELETE` | `/email-config/:id` | ADMIN+ | — | Delete config |
| `POST` | `/email-config/test` | ADMIN+ | — | Test email |

#### SMS Configuration

| Method | Path | Auth | Validation | Description |
|--------|------|------|------------|-------------|
| `GET` | `/sms-config` | ADMIN+ | — | List configs |
| `POST` | `/sms-config` | ADMIN+ | `createSmsConfigSchema` | Create config |
| `PUT` | `/sms-config/:id` | ADMIN+ | `updateSmsConfigSchema` | Update config |
| `DELETE` | `/sms-config/:id` | ADMIN+ | — | Delete config |

#### Push Configuration

| Method | Path | Auth | Validation | Description |
|--------|------|------|------------|-------------|
| `GET` | `/push-config` | ADMIN+ | — | List configs |
| `POST` | `/push-config` | ADMIN+ | `createPushConfigSchema` | Create config |
| `PUT` | `/push-config/:id` | ADMIN+ | `updatePushConfigSchema` | Update config |
| `DELETE` | `/push-config/:id` | ADMIN+ | — | Delete config |

#### System Configuration

| Method | Path | Auth | Validation | Description |
|--------|------|------|------------|-------------|
| `GET` | `/system-config/:group` | ADMIN+ | — | Get config group |
| `PUT` | `/system-config/:group/:key` | ADMIN+ | `updateSystemConfigSchema` | Update config |

#### Backup

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| `GET` | `/backup` | ADMIN+ | List backups |
| `POST` | `/backup` | ADMIN+ | Create backup |
| `POST` | `/backup/:name/verify` | ADMIN+ | Verify backup |
| `POST` | `/backup/:name/restore` | ADMIN+ | Restore backup |
| `GET` | `/backup/:name/download` | ADMIN+ | Download backup |
| `DELETE` | `/backup/:name` | ADMIN+ | Delete backup |
| `POST` | `/backup/rotate` | ADMIN+ | Rotate old backups |

#### Reference Data

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| `GET` | `/reference-data/:entity` | ADMIN+ | List entity |
| `GET` | `/reference-data/:entity/:id` | ADMIN+ | Get entity |
| `POST` | `/reference-data/:entity` | ADMIN+ | Create entity |
| `PUT` | `/reference-data/:entity/:id` | ADMIN+ | Update entity |
| `DELETE` | `/reference-data/:entity/:id` | ADMIN+ | Delete entity |

---

### 6.11 Integration

**Base:** `/api/v1/integration`
**Purpose:** External system integration events and logs.

| Method | Path | Auth | Roles | Description |
|--------|------|------|-------|-------------|
| `GET` | `/events` | Yes | SUPER_ADMIN, SYS_ADMIN | Integration events |
| `GET` | `/logs` | Yes | SUPER_ADMIN, SYS_ADMIN | Integration logs |

---

### 6.12 System

**Base:** `/api/v1/system`
**Purpose:** Saved searches, system configuration.

| Method | Path | Auth | Roles | Validation | Description |
|--------|------|------|-------|------------|-------------|
| `GET` | `/saved-searches` | Yes | — | — | List saved searches |
| `POST` | `/saved-searches` | Yes | — | `createSavedSearchSchema` | Create search |
| `PUT` | `/saved-searches/:id` | Yes | — | `updateSavedSearchSchema` | Update search |
| `DELETE` | `/saved-searches/:id` | Yes | — | — | Delete search |
| `GET` | `/config` | Yes | ADMIN+ | — | System config |

---

### 6.13 Reference

**Base:** `/api/v1/reference`
**Purpose:** Reference data for institutions and professions.

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| `GET` | `/institutions-registry` | No | Yemen institutions (public) |
| `GET` | `/professions` | Yes | Professions list |
| `GET` | `/licenses` | Yes | Licenses list |

---

### 6.14 Public

**Base:** `/api/v1/public`
**Purpose:** Public endpoints (no authentication).

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| `GET` | `/certificates/verify/:serialNumber` | No | Verify certificate (rate-limited) |

---

### 6.15 Templates

**Base:** `/api/v1/templates`
**Purpose:** Template management, versioning, preview, render, snapshots, rollback.

#### Template CRUD

| Method | Path | Auth | Roles | Validation | Description |
|--------|------|------|-------|------------|-------------|
| `GET` | `/` | Yes | — | — | List templates |
| `GET` | `/categories` | Yes | — | — | List categories |
| `GET` | `/categories/:id` | Yes | — | — | Get category |
| `GET` | `/module-keys` | Yes | — | — | Module keys |
| `GET` | `/module-config/:key` | Yes | — | — | Module config |
| `GET` | `/:id` | Yes | — | — | Get template |
| `POST` | `/` | Yes | ADMIN+ | `createTemplateSchema` | Create template |
| `PUT` | `/:id` | Yes | ADMIN+ | `updateTemplateSchema` | Update template |
| `DELETE` | `/:id` | Yes | ADMIN+ | — | Delete template |

#### Template Versions

| Method | Path | Auth | Roles | Validation | Description |
|--------|------|------|-------|------------|-------------|
| `GET` | `/versions` | Yes | — | — | List versions |
| `GET` | `/versions/:id` | Yes | — | — | Get version |
| `POST` | `/versions` | Yes | ADMIN+ | `createVersionSchema` | Create version |
| `PUT` | `/versions/:id` | Yes | ADMIN+ | `updateVersionSchema` | Update version |
| `POST` | `/versions/:id/submit` | Yes | ADMIN+ | `submitSchema` | Submit for review |
| `POST` | `/versions/:id/approve` | Yes | ETHICS_ADMIN+ | `approveSchema` | Approve version |
| `POST` | `/versions/:id/reject` | Yes | ETHICS_ADMIN+ | `rejectSchema` | Reject version |
| `POST` | `/versions/:id/deprecate` | Yes | ADMIN+ | `deprecateSchema` | Deprecate |
| `POST` | `/versions/:id/archive` | Yes | ADMIN+ | `archiveSchema` | Archive |

#### Template Preview & Render

| Method | Path | Auth | Roles | Validation | Description |
|--------|------|------|-------|------------|-------------|
| `POST` | `/template-preview` | Yes | — | `previewSchema` | Preview template |
| `POST` | `/template-render` | Yes | — | `renderSchema` | Render template |
| `POST` | `/preview` | Yes | ADMIN+ | `previewDocumentSchema` | Preview document |
| `POST` | `/render` | Yes | ADMIN+ | `renderDocumentSchema` | Render document |

#### Template Snapshots

| Method | Path | Auth | Validation | Description |
|--------|------|------|------------|-------------|
| `GET` | `/template-snapshots` | Yes | — | List snapshots |
| `GET` | `/template-snapshots/:hash` | Yes | — | Get snapshot by hash |
| `POST` | `/template-snapshots/verify` | Yes | `verifySchema` | Verify snapshot |

#### Template History & Rollback

| Method | Path | Auth | Roles | Validation | Description |
|--------|------|------|-------|------------|-------------|
| `GET` | `/template-history` | Yes | — | — | Version history |
| `POST` | `/template-rollback` | Yes | ADMIN+ | `rollbackSchema` | Rollback to version |

---

## Summary Statistics

| Module | Routes | Auth Required | Role-Gated | With Validation |
|--------|:------:|:-------------:|:----------:|:---------------:|
| Monitoring | 6 | 2 | 2 | 0 |
| Security | 30 | 23 | 15 | 11 |
| Core | 34 | 34 | 12 | 10 |
| Committee | 102 | 102 | 62 | 33 |
| Workflow | 4 | 4 | 0 | 1 |
| Documents | 13 | 13 | 0 | 2 |
| Communication | 13 | 12 | 0 | 1 |
| Safety | 14 | 14 | 6 | 6 |
| Reporting | 7 | 6 | 0 | 0 |
| Admin | 38 | 38 | 38 | 14 |
| Integration | 2 | 2 | 2 | 0 |
| System | 5 | 5 | 1 | 2 |
| Reference | 3 | 2 | 0 | 0 |
| Public | 1 | 0 | 0 | 0 |
| Templates | 27 | 27 | 17 | 14 |
| **Total** | **299** | **284** | **155** | **94** |
