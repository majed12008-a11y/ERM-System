# RC1 Frontend Page Map

## Public Routes (unauthenticated)

| Route | Component | SDK Call | API Endpoint(s) |
|---|---|---|---|
| `/login` | `LoginPage` | `auth.login()` | `POST /security/auth/login` |
| `/register` | `RegisterPage` | `auth.register()` | `POST /security/auth/register` |
| `/forgot-password` | `ForgotPasswordPage` | — | `POST /security/auth/forgot-password` |
| `/reset-password` | `ResetPasswordPage` | — | `POST /security/auth/reset-password` |
| `/verify-email` | `VerifyEmailPage` | — | `GET /security/auth/verify-email?token=` |

## Protected Routes (authenticated)

### Dashboard

| Route | Component | SDK Calls | API Endpoints |
|---|---|---|---|
| `/` | `Dashboard` | `reporting.getDashboardStats()` | `GET /reports/dashboard-stats` |

### Applications

| Route | Component | SDK Calls | API Endpoints |
|---|---|---|---|
| `/applications` | `ApplicationList` | `applications.list()` | `GET /core/applications?page=&limit=` |
| `/applications/create` | `ApplicationCreate` | `projects.list()` (dropdown), `applications.create()` | `GET /core/projects`, `POST /core/applications` |
| `/applications/:id` | `ApplicationDetail` | `applications.getById()`, `documents.getByEntity()`, `reviews.getByApplication()`, `workflow.getAvailableTransitions()` | `GET /core/applications/:id`, `GET /documents?entity=application&entity_id=`, `GET /committee/reviews/application/:id`, `GET /workflow/instance/:id/transitions` |

### Projects

| Route | Component | SDK Calls | API Endpoints |
|---|---|---|---|
| `/projects` | `ProjectList` | `projects.list()` | `GET /core/projects?page=&limit=` |
| `/projects/create` | `ProjectCreate` | `reference.getInstitutions()`, `projects.create()` | `GET /reference/institutions-registry`, `POST /core/projects` |
| `/projects/:id` | `ProjectDetail` | `projects.getById()`, `projects.getApplications()`, `documents.getByEntity()` | `GET /core/projects/:id`, `GET /core/projects/:id/applications`, `GET /documents?entity=project&entity_id=` |

### Users & Roles (admin)

| Route | Component | SDK Calls | API Endpoints |
|---|---|---|---|
| `/users` | `UserList` | `users.list()`, `roles.list()` (filter), `users.create()`, `users.update()` | `GET /security/users`, `GET /security/roles`, `POST /security/users`, `PATCH /security/users/:id` |
| `/roles` | `RoleList` | `roles.list()`, `roles.create()`, `roles.update()`, `permissions.list()`, `permissions.getByRole()`, `permissions.updateRole()` | `GET /security/roles`, `POST /security/roles`, `PATCH /security/roles/:id`, `GET /security/permissions`, `GET /security/roles/:id/permissions`, `PUT /security/roles/:id/permissions` |

### Committee & Reviews

| Route | Component | SDK Calls | API Endpoints |
|---|---|---|---|
| `/committee/reviews` | `MyReviews` | `reviews.getMy()` | `GET /committee/reviews/my` |
| `/committee/committees` | `Committees` | `committees.list()`, `committees.listTypes()`, `committees.listRoles()` | `GET /committee/committees?page=&limit=`, `GET /committee/committees/types`, `GET /committee/committees/roles` |
| `/committee/committees/:id` | `CommitteeDetail` | `committees.getById()`, `members.listByCommittee()`, `meetings.listByCommittee()` | `GET /committee/committees/:id`, `GET /committee/committees/:id/members`, `GET /committee/committees/:id/meetings` |
| `/committee/meetings` | `CommitteeMeetings` | `committees.list()`, `meetings.listByCommittee()` | `GET /committee/committees`, `GET /committee/committees/:id/meetings` |
| `/committee/meetings/:id` | `MeetingDetail` | `meetings.getById()`, `meetings.getAgenda()`, `meetings.getAttendance()`, `meetings.getMinutes()`, `meetings.getCommitteeMembers()`, `members.getConflicts()`, `voting.getByMeeting()`, `voting.createSession()`, `voting.castVote()`, `voting.closeSession()` | `GET /committee/meetings/:id`, `GET /committee/meetings/:id/agenda`, `GET /committee/meetings/:id/attendance`, `GET /committee/meetings/:id/minutes`, `GET /committee/meetings/:id/members`, `GET /committee/meetings/:id/conflicts`, `GET /committee/meetings/:id/voting`, `POST /committee/meetings/:id/voting`, etc. |

### Safety & Risk

| Route | Component | SDK Calls | API Endpoints |
|---|---|---|---|
| `/risk-register` | `RiskRegister` | `safety.getRiskRegister()`, `safety.createRiskEntry()`, `safety.getMitigations()`, `safety.addMitigation()` | `GET /safety/risk-register`, `POST /safety/risk-register`, `GET /safety/risk-register/:id/mitigations`, `POST /safety/risk-register/:id/mitigations` |
| `/safety/adverse-events` | `AdverseEvents` | `safety.getAdverseEvents()` | `GET /safety/adverse-events` |
| `/safety/risk-incidents` | `RiskIncidents` | `safety.getIncidents()`, `safety.reportIncident()` | `GET /safety/incidents`, `POST /safety/incidents` |
| `/safety/corrective-actions` | `CorrectiveActions` | `safety.getCorrectiveActions()`, `safety.createCorrectiveAction()` | `GET /safety/corrective-actions`, `POST /safety/corrective-actions` |

### Documents & E-Signatures

| Route | Component | SDK Calls | API Endpoints |
|---|---|---|---|
| `/documents` | `DocumentsPage` | `documents.list()`, `documents.getTypes()`, `documents.getClassifications()`, `documents.upload()`, `documents.delete()` | `GET /documents?page=&limit=`, `GET /documents/types`, `GET /documents/classifications`, `POST /documents/upload`, `DELETE /documents/:id` |
| `/e-signatures` | `ESignaturesPage` | `documents.getPendingSignatures()`, `documents.sign()` | `GET /e-signatures/pending`, `POST /e-signatures/sign` |

### Communications

| Route | Component | SDK Calls | API Endpoints |
|---|---|---|---|
| `/notifications` | `Notifications` | `notifications.list()`, `notifications.markAsRead()`, `notifications.markAllAsRead()`, `notifications.delete()` | `GET /notifications`, `PATCH /notifications/:id/read`, `PATCH /notifications/read-all`, `DELETE /notifications/:id` |
| `/messages` | `MessagesPage` | `messages.list()`, `messages.getUnreadCount()`, `messages.getById()`, `messages.send()`, `messages.delete()`, `messages.searchUsers()` | `GET /messages/inbox`, `GET /messages/unread-count`, `GET /messages/:id`, `POST /messages`, `DELETE /messages/:id`, `GET /users/search?q=` |

### Reports

| Route | Component | SDK Calls | API Endpoints |
|---|---|---|---|
| `/reports` | `ReportsPage` | `reporting.getApplications()`, `reporting.getCommittees()`, `reporting.getStatusSummary()`, `reporting.getApplicationsTrend()`, `reporting.exportApplications()` | `GET /reports/applications`, `GET /reports/committees`, `GET /reports/status-summary`, `GET /reports/applications-trend`, `GET /reports/applications/export?format=csv` |

### System & Registry

| Route | Component | SDK Calls | API Endpoints |
|---|---|---|---|
| `/saved-searches` | `SavedSearches` | `system.getSavedSearches()`, `system.createSavedSearch()`, `system.updateSavedSearch()`, `system.deleteSavedSearch()` | `GET /system/saved-searches`, `POST /system/saved-searches`, `PATCH /system/saved-searches/:id`, `DELETE /system/saved-searches/:id` |
| `/registry` | `RegistryPage` | `reference.getInstitutions()`, `reference.getProfessions()`, `reference.getLicenses()` | `GET /reference/institutions-registry`, `GET /reference/professions`, `GET /reference/licenses` |

### Profile

| Route | Component | SDK Calls | API Endpoints |
|---|---|---|---|
| `/profile` | `ProfilePage` | `users.getProfile()`, `users.updateProfile()`, `auth.changePassword()` | `GET /security/users/profile`, `PATCH /security/users/profile`, `PUT /security/auth/change-password` |

### Admin

| Route | Component | SDK Calls | API Endpoints |
|---|---|---|---|
| `/admin` | `AdminDashboard` | `admin.getStats()`, `admin.getAuditLog()`, `admin.getDistinctActions()`, `admin.getOnlineUsers()`, `admin.getRecentActivity()` | `GET /admin/stats`, `GET /admin/audit-log`, `GET /admin/audit-log/actions`, `GET /admin/online-users`, `GET /admin/recent-activity` |
| `/admin/email-settings` | `EmailSettings` | — (uses `api` directly) | `GET /admin/email-config`, `POST /admin/email-config`, `PATCH /admin/email-config/:id`, `DELETE /admin/email-config/:id` |
| `/admin/backup` | `BackupSettings` | `admin.getAuditLog()` (uses `api` directly for backup) | `GET /admin/backup`, `POST /admin/backup`, `POST /admin/backup/:name/verify`, `DELETE /admin/backup/:name` |

### Review Forms

| Route | Component | SDK Calls | API Endpoints |
|---|---|---|---|
| `/review-forms` | `ReviewFormsPage` | `reviews.getForms()`, `reviews.createForm()`, `reviews.getQuestions()`, `reviews.addQuestion()`, `reviews.deleteQuestion()` | `GET /committee/review-forms`, `POST /committee/review-forms`, `GET /committee/review-forms/:id/questions`, `POST /committee/review-forms/:id/questions`, `DELETE /committee/review-forms/:id/questions/:qid` |

## Data Flow Pattern

```
Page Component
  │
  ├── useQuery({ queryKey, queryFn })  ← TanStack Query
  │       │
  │       └── sdk.domain.method()       ← SDK module
  │               │
  │               └── api.get/post()    ← Axios client (baseURL: /api/v1)
  │                       │
  │                       └── Express route  ← OpenAPI contract
  │                               │
  │                               └── Service → Repository → PostgreSQL
  │
  └── useMutation({ mutationFn, onSuccess })
          │
          └── (same chain, but invalidates related queryKey on success)
```

## Pagination Convention

All list endpoints return:
```json
{ "data": [...], "pagination": { "page": 1, "limit": 20, "total": 150, "totalPages": 8 } }
```

`DataTable` component accepts `{ columns, data, pagination, onPageChange }` and renders sortable headers + page controls.
