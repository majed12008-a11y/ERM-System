import swaggerJsdoc from 'swagger-jsdoc';

const options: swaggerJsdoc.Options = {
  definition: {
    openapi: '3.1.0',
    info: {
      title: 'Ethics ERM API',
      version: '1.0.0',
      description: 'National Ethics & Medical Research Governance Platform — REST API',
      contact: { email: 'admin@ethics-erm.gov' },
    },
    servers: [{ url: '/api/v1', description: 'API v1' }],
    components: {
      securitySchemes: {
        bearerAuth: { type: 'http', scheme: 'bearer', bearerFormat: 'JWT' },
      },
      schemas: {
        ApiResponse: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            data: { type: 'object' },
            error: { type: 'string' },
            message: { type: 'string' },
            pagination: {
              type: 'object',
              properties: { page: { type: 'integer' }, limit: { type: 'integer' }, total: { type: 'integer' } },
            },
          },
        },
        User: {
          type: 'object',
          properties: {
            id: { type: 'integer' }, uuid: { type: 'string' }, username: { type: 'string' },
            email: { type: 'string' }, institution_id: { type: 'integer' }, status: { type: 'string' },
            roles: { type: 'array', items: { type: 'string' } },
          },
        },
        Application: {
          type: 'object',
          properties: {
            id: { type: 'integer' }, application_number: { type: 'string' },
            project_id: { type: 'integer' }, application_type: { type: 'string' },
            current_status: { type: 'string' }, submitted_by: { type: 'integer' },
            target_committee_id: { type: 'integer' }, created_at: { type: 'string' },
          },
        },
        Project: {
          type: 'object',
          properties: {
            id: { type: 'integer' }, project_code: { type: 'string' },
            title_ar: { type: 'string' }, title_en: { type: 'string' },
            research_category: { type: 'string' }, risk_level: { type: 'string' },
            principal_investigator_id: { type: 'integer' }, institution_id: { type: 'integer' },
          },
        },
        Committee: {
          type: 'object',
          properties: {
            id: { type: 'integer' }, committee_name_ar: { type: 'string' },
            committee_type_id: { type: 'integer' }, institution_id: { type: 'integer' },
            is_active: { type: 'boolean' },
          },
        },
        ReviewAssignment: {
          type: 'object',
          properties: {
            id: { type: 'integer' }, application_id: { type: 'integer' },
            reviewer_id: { type: 'integer' }, review_type: { type: 'string' },
            assigned_by: { type: 'integer' }, due_date: { type: 'string' },
            assigned_at: { type: 'string' },
          },
        },
        CommitteeMeeting: {
          type: 'object',
          properties: {
            id: { type: 'integer' }, committee_id: { type: 'integer' },
            meeting_number: { type: 'string' }, meeting_date: { type: 'string' },
            location: { type: 'string' }, meeting_status: { type: 'string' },
          },
        },
        Document: {
          type: 'object',
          properties: {
            id: { type: 'integer' }, document_title: { type: 'string' },
            document_type_id: { type: 'integer' }, entity_type: { type: 'string' },
            entity_id: { type: 'integer' }, file_name: { type: 'string' },
            mime_type: { type: 'string' }, uploaded_by: { type: 'integer' },
          },
        },
        Notification: {
          type: 'object', properties: {
            id: { type: 'integer' }, user_id: { type: 'integer' },
            subject: { type: 'string' }, message_body: { type: 'string' },
            is_read: { type: 'boolean' }, created_at: { type: 'string' },
          },
        },
        WorkflowDefinition: {
          type: 'object', properties: {
            id: { type: 'integer' }, workflow_code: { type: 'string' },
            workflow_name: { type: 'string' }, is_active: { type: 'boolean' },
            states: { type: 'array', items: { type: 'object' } },
            transitions: { type: 'array', items: { type: 'object' } },
          },
        },
        Error: {
          type: 'object', properties: {
            success: { type: 'boolean', enum: [false] },
            error: { type: 'string' },
          },
        },
      },
    },
    paths: {
      // ─── Health ───
      '/health': {
        get: {
          tags: ['System'], summary: 'Health check',
          responses: { '200': { description: 'Service healthy' } },
        },
      },

      // ─── Auth ───
      '/security/auth/login': {
        post: {
          tags: ['Authentication'], summary: 'User login',
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { username: { type: 'string' }, password: { type: 'string', format: 'password' } }, required: ['username', 'password'] } } } },
          responses: { '200': { description: 'Login successful — accessToken + HttpOnly refresh cookie' }, '401': { description: 'Invalid credentials' }, '423': { description: 'Account locked' } },
        },
      },
      '/security/auth/refresh': {
        post: {
          tags: ['Authentication'], summary: 'Refresh access token',
          responses: { '200': { description: 'New access token' }, '401': { description: 'Invalid or expired refresh token' } },
        },
      },
      '/security/auth/logout': {
        post: {
          tags: ['Authentication'], summary: 'Logout — revoke session', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Logged out' } },
        },
      },
      '/security/auth/me': {
        get: {
          tags: ['Authentication'], summary: 'Current user info', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'User data', content: { 'application/json': { schema: { $ref: '#/components/schemas/User' } } } } },
        },
      },
      '/security/auth/change-password': {
        post: {
          tags: ['Authentication'], summary: 'Change password', security: [{ bearerAuth: [] }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { oldPassword: { type: 'string' }, newPassword: { type: 'string' } }, required: ['oldPassword', 'newPassword'] } } } },
          responses: { '200': { description: 'Password changed — all sessions revoked' }, '400': { description: 'Invalid input or weak password' } },
        },
      },

      // ─── Users ───
      '/security/users': {
        get: {
          tags: ['Users'], summary: 'List users', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'page', in: 'query', schema: { type: 'integer' } }, { name: 'limit', in: 'query', schema: { type: 'integer' } }],
          responses: { '200': { description: 'Paginated users list' } },
        },
        post: {
          tags: ['Users'], summary: 'Create user', security: [{ bearerAuth: [] }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { username: { type: 'string' }, email: { type: 'string' }, password: { type: 'string' }, first_name_ar: { type: 'string' }, last_name_ar: { type: 'string' }, institution_id: { type: 'integer' }, role_codes: { type: 'array', items: { type: 'string' } } } } } } },
          responses: { '201': { description: 'User created' }, '409': { description: 'Conflict' } },
        },
      },
      '/security/users/{id}': {
        get: {
          tags: ['Users'], summary: 'Get user by ID', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'User details' }, '404': { description: 'Not found' } },
        },
      },

      // ─── Roles ───
      '/security/roles': {
        get: {
          tags: ['Roles'], summary: 'List roles with permissions', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Roles with their permissions' } },
        },
        post: {
          tags: ['Roles'], summary: 'Create role', security: [{ bearerAuth: [] }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { code: { type: 'string' }, name_ar: { type: 'string' }, name_en: { type: 'string' }, description: { type: 'string' } }, required: ['code', 'name_ar'] } } } },
          responses: { '201': { description: 'Role created' } },
        },
      },
      '/security/roles/{id}': {
        get: {
          tags: ['Roles'], summary: 'Get role details', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Role with permissions' }, '404': { description: 'Not found' } },
        },
        put: {
          tags: ['Roles'], summary: 'Update role', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Role updated' } },
        },
      },
      '/security/permissions': {
        get: {
          tags: ['Permissions'], summary: 'List all permissions', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'All permissions grouped by module' } },
        },
        post: {
          tags: ['Permissions'], summary: 'Create permission', security: [{ bearerAuth: [] }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { permission_code: { type: 'string' }, module_name: { type: 'string' }, action_name: { type: 'string' }, description: { type: 'string' } }, required: ['permission_code', 'module_name', 'action_name'] } } } },
          responses: { '201': { description: 'Permission created' } },
        },
      },
      '/security/permissions/role/{roleId}': {
        get: {
          tags: ['Permissions'], summary: 'Get permissions for a role', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'roleId', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Permissions with granted flag' } },
        },
        put: {
          tags: ['Permissions'], summary: 'Update role permissions', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'roleId', in: 'path', required: true, schema: { type: 'integer' } }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { permission_ids: { type: 'array', items: { type: 'integer' } } } } } } },
          responses: { '200': { description: 'Role permissions updated' } },
        },
      },
      '/security/profile': {
        get: {
          tags: ['Profiles'], summary: 'My profile', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'User profile (sensitive fields decrypted)' } },
        },
        put: {
          tags: ['Profiles'], summary: 'Update my profile', security: [{ bearerAuth: [] }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { national_id: { type: 'string' }, passport_number: { type: 'string' }, gender: { type: 'string' }, date_of_birth: { type: 'string' }, nationality_code: { type: 'string' }, academic_title: { type: 'string' }, specialization: { type: 'string' }, biography: { type: 'string' } } } } } },
          responses: { '200': { description: 'Profile updated' } },
        },
      },

      // ─── Projects ───
      '/core/projects': {
        get: {
          tags: ['Projects'], summary: 'List projects', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'page', in: 'query', schema: { type: 'integer' } }, { name: 'limit', in: 'query', schema: { type: 'integer' } }],
          responses: { '200': { description: 'Paginated projects' } },
        },
        post: {
          tags: ['Projects'], summary: 'Create project', security: [{ bearerAuth: [] }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { title_ar: { type: 'string' }, title_en: { type: 'string' }, abstract_ar: { type: 'string' }, abstract_en: { type: 'string' }, objectives: { type: 'string' }, research_category: { type: 'string' }, risk_level: { type: 'string' } }, required: ['title_ar', 'objectives'] } } } },
          responses: { '201': { description: 'Project created' } },
        },
      },
      '/core/projects/{id}': {
        get: {
          tags: ['Projects'], summary: 'Get project by ID', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Project details' }, '404': { description: 'Not found' } },
        },
      },

      // ─── Applications ───
      '/core/applications': {
        get: {
          tags: ['Applications'], summary: 'List applications', security: [{ bearerAuth: [] }],
          parameters: [
            { name: 'page', in: 'query', schema: { type: 'integer' } },
            { name: 'limit', in: 'query', schema: { type: 'integer' } },
            { name: 'status', in: 'query', schema: { type: 'string' }, description: 'Filter by status code' },
          ],
          responses: { '200': { description: 'Paginated applications' } },
        },
        post: {
          tags: ['Applications'], summary: 'Submit application', security: [{ bearerAuth: [] }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { project_id: { type: 'integer' }, application_type: { type: 'string', enum: ['INITIAL', 'AMENDMENT', 'RENEWAL', 'EXPEDITED'] }, target_committee_id: { type: 'integer' } }, required: ['project_id', 'target_committee_id'] } } } },
          responses: { '201': { description: 'Application submitted — workflow auto-initiated' } },
        },
      },
      '/core/applications/{id}': {
        get: {
          tags: ['Applications'], summary: 'Get application', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Application details' }, '404': { description: 'Not found' } },
        },
      },
      '/core/applications/{id}/status': {
        patch: {
          tags: ['Applications'], summary: 'Update application status', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { status: { type: 'string' } } } } } },
          responses: { '200': { description: 'Status updated — auto-transition triggered' } },
        },
      },

      // ─── Committees ───
      '/committee/committees': {
        get: {
          tags: ['Committees'], summary: 'List committees', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Committees with member counts' } },
        },
      },
      '/committee/committees/{id}': {
        get: {
          tags: ['Committees'], summary: 'Committee details with members', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Committee with members' }, '404': { description: 'Not found' } },
        },
      },

      // ─── Meetings ───
      '/committee/meetings/committee/{committeeId}': {
        get: {
          tags: ['Meetings'], summary: 'List meetings by committee', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'committeeId', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Meetings list' } },
        },
      },
      '/committee/meetings': {
        post: {
          tags: ['Meetings'], summary: 'Create meeting', security: [{ bearerAuth: [] }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { committee_id: { type: 'integer' }, meeting_date: { type: 'string' }, location: { type: 'string' } } } } } },
          responses: { '201': { description: 'Meeting created' } },
        },
      },
      '/committee/meetings/{id}/quorum': {
        post: {
          tags: ['Meetings'], summary: 'Check meeting quorum', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Quorum status' } },
        },
      },

      // ─── Reviews ───
      '/committee/reviews/my': {
        get: {
          tags: ['Reviews'], summary: 'My review assignments', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Assignments list' } },
        },
      },
      '/committee/reviews/assign': {
        post: {
          tags: ['Reviews'], summary: 'Assign reviewer', security: [{ bearerAuth: [] }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { application_id: { type: 'integer' }, reviewer_id: { type: 'integer' }, review_type: { type: 'string' }, due_date: { type: 'string' } } } } } },
          responses: { '201': { description: 'Reviewer assigned — status set to UNDER_REVIEW' } },
        },
      },

      // ─── Workflow ───
      '/workflow/definitions': {
        get: {
          tags: ['Workflow'], summary: 'List workflow definitions', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Workflow definitions with states and transitions' } },
        },
      },
      '/workflow/instances/{entityType}/{entityId}': {
        get: {
          tags: ['Workflow'], summary: 'Get workflow instance for entity', security: [{ bearerAuth: [] }],
          parameters: [
            { name: 'entityType', in: 'path', required: true, schema: { type: 'string' } },
            { name: 'entityId', in: 'path', required: true, schema: { type: 'integer' } },
          ],
          responses: { '200': { description: 'Active workflow instance' } },
        },
      },
      '/workflow/transition': {
        post: {
          tags: ['Workflow'], summary: 'Execute workflow transition', security: [{ bearerAuth: [] }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { entity_type: { type: 'string' }, entity_id: { type: 'integer' }, comment: { type: 'string' } } } } } },
          responses: { '200': { description: 'Transition result' }, '400': { description: 'Invalid transition' } },
        },
      },

      // ─── Documents ───
      '/documents': {
        get: {
          tags: ['Documents'], summary: 'List documents', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'page', in: 'query', schema: { type: 'integer' } }, { name: 'limit', in: 'query', schema: { type: 'integer' } }],
          responses: { '200': { description: 'Paginated documents' } },
        },
        post: {
          tags: ['Documents'], summary: 'Upload document', security: [{ bearerAuth: [] }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { document_type_id: { type: 'integer' }, entity_type: { type: 'string' }, entity_id: { type: 'integer' }, document_title: { type: 'string' }, file_name: { type: 'string' }, mime_type: { type: 'string' } } } } } },
          responses: { '201': { description: 'Document uploaded' } },
        },
      },
      '/documents/types': {
        get: {
          tags: ['Documents'], summary: 'List document types', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Document types' } },
        },
      },

      // ─── Communication ───
      '/communication/notifications': {
        get: {
          tags: ['Notifications'], summary: 'My notifications', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Recent 50 notifications' } },
        },
      },
      '/communication/notifications/{id}/read': {
        patch: {
          tags: ['Notifications'], summary: 'Mark notification as read', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Marked as read' } },
        },
      },

      // ─── Monitoring ───
      '/monitoring/health': {
        get: {
          tags: ['Monitoring'], summary: 'Database health check',
          responses: { '200': { description: 'Healthy' }, '503': { description: 'Unhealthy' } },
        },
      },
      '/monitoring/audit': {
        get: {
          tags: ['Monitoring'], summary: 'Audit log (last 100)', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Audit entries' } },
        },
      },
      '/monitoring/config': {
        get: {
          tags: ['Monitoring'], summary: 'System config (non-encrypted)', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Config entries' } },
        },
      },

      // ─── Safety ───
      '/safety/adverse-events': {
        get: {
          tags: ['Safety'], summary: 'List adverse events', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Adverse events' } },
        },
      },
      '/safety/serious-adverse-events': {
        get: {
          tags: ['Safety'], summary: 'List serious adverse events', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Serious adverse events' } },
        },
      },
      '/safety/safety-reports': {
        get: {
          tags: ['Safety'], summary: 'List safety reports', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Safety reports' } },
        },
      },
      '/safety/risk-register': {
        get: {
          tags: ['Safety'], summary: 'Risk register', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Risk list' } },
        },
        post: {
          tags: ['Safety'], summary: 'Register a risk', security: [{ bearerAuth: [] }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { risk_code: { type: 'string' }, risk_title: { type: 'string' }, risk_description: { type: 'string' }, likelihood: { type: 'integer' }, impact: { type: 'integer' }, owner_id: { type: 'integer' } } } } } },
          responses: { '201': { description: 'Risk created' } },
        },
      },

      // ─── Reporting ───
      '/reporting/dashboard/stats': {
        get: {
          tags: ['Reporting'], summary: 'Dashboard application stats', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Stats' } },
        },
      },
      '/reporting/dashboard/committee-workload': {
        get: {
          tags: ['Reporting'], summary: 'Committee workload', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Workload by committee' } },
        },
      },
      '/reporting/dashboard/approval-rate': {
        get: {
          tags: ['Reporting'], summary: 'Approval rate KPI', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'KPI data' } },
        },
      },
      '/reporting/definitions': {
        get: {
          tags: ['Reporting'], summary: 'Report definitions', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Active report definitions' } },
        },
      },

      // ─── Workflow ───
      '/workflow/available-transitions/{entityType}/{entityId}': {
        get: {
          tags: ['Workflow'], summary: 'Get available transitions for entity', security: [{ bearerAuth: [] }],
          parameters: [
            { name: 'entityType', in: 'path', required: true, schema: { type: 'string' } },
            { name: 'entityId', in: 'path', required: true, schema: { type: 'integer' } },
          ],
          responses: { '200': { description: 'Available transitions filtered by user roles' } },
        },
      },
      '/workflow/execute-transition': {
        post: {
          tags: ['Workflow'], summary: 'Execute a workflow transition', security: [{ bearerAuth: [] }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { entity_type: { type: 'string' }, entity_id: { type: 'integer' }, transition_code: { type: 'string' }, comment: { type: 'string' } }, required: ['entity_type', 'entity_id', 'transition_code'] } } } },
          responses: { '200': { description: 'Transition executed' }, '400': { description: 'Invalid transition or missing comment' }, '403': { description: 'Not authorized for this transition' } },
        },
      },

      // ─── Notifications ───
      '/communication/notifications/read-all': {
        patch: {
          tags: ['Notifications'], summary: 'Mark all notifications as read', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'All marked as read' } },
        },
      },
      '/communication/notifications/{id}': {
        delete: {
          tags: ['Notifications'], summary: 'Delete a notification', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Deleted' } },
        },
      },
      '/communication/notifications/stream': {
        get: {
          tags: ['Notifications'], summary: 'SSE stream for real-time notifications',
          parameters: [{ name: 'token', in: 'query', required: true, schema: { type: 'string' }, description: 'JWT token' }],
          responses: { '200': { description: 'EventSource stream — sends notification events' } },
        },
      },

      // ─── Messaging ───
      '/communication/messages': {
        get: {
          tags: ['Messaging'], summary: 'List messages (inbox/sent)', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'box', in: 'query', schema: { type: 'string', enum: ['inbox', 'sent'] } }],
          responses: { '200': { description: 'Messages list' } },
        },
        post: {
          tags: ['Messaging'], summary: 'Send a message with optional attachments', security: [{ bearerAuth: [] }],
          requestBody: { content: { 'multipart/form-data': { schema: { type: 'object', properties: { recipient_ids: { type: 'string', description: 'JSON array of user IDs' }, subject: { type: 'string' }, message_body: { type: 'string' }, attachments: { type: 'array', items: { type: 'string', format: 'binary' } } }, required: ['recipient_ids', 'subject'] } } } },
          responses: { '201': { description: 'Message sent' } },
        },
      },
      '/communication/messages/unread-count': {
        get: {
          tags: ['Messaging'], summary: 'Unread message count', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Unread count' } },
        },
      },
      '/communication/messages/{id}': {
        get: {
          tags: ['Messaging'], summary: 'Get message detail with recipients & attachments', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Message with recipients' } },
        },
        delete: {
          tags: ['Messaging'], summary: 'Soft-delete a message', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Deleted' } },
        },
      },
      '/communication/messages/{id}/attachments/{attachmentId}': {
        get: {
          tags: ['Messaging'], summary: 'Download a message attachment', security: [{ bearerAuth: [] }],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } },
            { name: 'attachmentId', in: 'path', required: true, schema: { type: 'integer' } },
          ],
          responses: { '200': { description: 'File download' } },
        },
      },
      '/communication/users/search': {
        get: {
          tags: ['Messaging'], summary: 'Search users by username', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'q', in: 'query', required: true, schema: { type: 'string' }, description: 'Min 2 characters' }],
          responses: { '200': { description: 'Matching users' } },
        },
      },

      // ─── Documents ───
      '/documents/{id}/sign': {
        post: {
          tags: ['Documents'], summary: 'Sign a document electronically', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { signature_type: { type: 'string', enum: ['ELECTRONIC', 'DIGITAL', 'WET'] } }, required: ['signature_type'] } } } },
          responses: { '201': { description: 'Signature created with SHA-256 hash' } },
        },
      },
      '/documents/{id}/signatures': {
        get: {
          tags: ['Documents'], summary: 'List signatures on a document', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Signatures with signer info' } },
        },
      },
      '/documents/pending-signatures': {
        get: {
          tags: ['Documents'], summary: 'Documents pending my signature', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Pending documents' } },
        },
      },
      '/documents/classifications': {
        get: {
          tags: ['Documents'], summary: 'Document classifications', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Classifications list' } },
        },
      },
      '/documents/entity/{entityType}/{entityId}': {
        get: {
          tags: ['Documents'], summary: 'Documents for an entity', security: [{ bearerAuth: [] }],
          parameters: [
            { name: 'entityType', in: 'path', required: true, schema: { type: 'string' } },
            { name: 'entityId', in: 'path', required: true, schema: { type: 'integer' } },
          ],
          responses: { '200': { description: 'Entity documents' } },
        },
      },

      // ─── Review Forms ───
      '/committee/reviews/forms': {
        get: {
          tags: ['Review Forms'], summary: 'List review forms', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Forms with question count' } },
        },
        post: {
          tags: ['Review Forms'], summary: 'Create a review form', security: [{ bearerAuth: [] }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { form_name: { type: 'string' }, form_type: { type: 'string' }, description: { type: 'string' }, is_active: { type: 'boolean' } }, required: ['form_name', 'form_type'] } } } },
          responses: { '201': { description: 'Form created' } },
        },
      },
      '/committee/reviews/forms/{formId}/questions': {
        get: {
          tags: ['Review Forms'], summary: 'List questions for a form', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'formId', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Questions list' } },
        },
        post: {
          tags: ['Review Forms'], summary: 'Add question to form', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'formId', in: 'path', required: true, schema: { type: 'integer' } }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { question_text: { type: 'string' }, question_type: { type: 'string', enum: ['TEXT', 'SCALE', 'BOOLEAN'] }, is_required: { type: 'boolean' }, display_order: { type: 'integer' }, scale_min: { type: 'integer' }, scale_max: { type: 'integer' } }, required: ['question_text', 'question_type'] } } } },
          responses: { '201': { description: 'Question added' } },
        },
        delete: {
          tags: ['Review Forms'], summary: 'Delete a question', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'formId', in: 'path', required: true, schema: { type: 'integer' } }, { name: 'questionId', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Question deleted' } },
        },
      },

      // ─── Reviews ───
      '/committee/reviews/{assignmentId}/submit': {
        post: {
          tags: ['Reviews'], summary: 'Submit a review with recommendations', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'assignmentId', in: 'path', required: true, schema: { type: 'integer' } }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { recommendation_type: { type: 'string', enum: ['APPROVE', 'REJECT', 'CONDITIONAL', 'ABSTAIN'] }, justification: { type: 'string' }, comment_text: { type: 'string' }, answers: { type: 'array', items: { type: 'object' } } }, required: ['recommendation_type'] } } } },
          responses: { '201': { description: 'Review submitted' } },
        },
      },
      '/committee/reviews/application/{applicationId}': {
        get: {
          tags: ['Reviews'], summary: 'Get all reviews for an application', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'applicationId', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Review assignments' } },
        },
      },
      '/committee/reviews/application/{applicationId}/recommendations': {
        get: {
          tags: ['Reviews'], summary: 'Get recommendations for an application', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'applicationId', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Recommendations' } },
        },
      },
      '/committee/reviews/application/{applicationId}/comments': {
        get: {
          tags: ['Reviews'], summary: 'Get review comments for an application', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'applicationId', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Comments' } },
        },
      },

      // ─── Meetings ───
      '/committee/meetings/{id}': {
        get: {
          tags: ['Meetings'], summary: 'Get meeting details', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Meeting with agenda, attendance, minutes' } },
        },
        patch: {
          tags: ['Meetings'], summary: 'Update meeting', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Meeting updated' } },
        },
      },
      '/committee/meetings/{id}/agenda': {
        get: {
          tags: ['Meetings'], summary: 'Meeting agenda items', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Agenda items' } },
        },
        post: {
          tags: ['Meetings'], summary: 'Add agenda item', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '201': { description: 'Agenda item added' } },
        },
        delete: {
          tags: ['Meetings'], summary: 'Remove agenda item', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }, { name: 'agendaId', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Removed' } },
        },
      },
      '/committee/meetings/{id}/attendance': {
        get: {
          tags: ['Meetings'], summary: 'Meeting attendance', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Attendance records' } },
        },
        post: {
          tags: ['Meetings'], summary: 'Mark attendance', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '201': { description: 'Attendance recorded' } },
        },
      },
      '/committee/meetings/{id}/minutes': {
        post: {
          tags: ['Meetings'], summary: 'Add meeting minutes', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '201': { description: 'Minutes created with auto-generated document' } },
        },
      },
      '/committee/meetings/{id}/minutes/{minutesId}/approve': {
        patch: {
          tags: ['Meetings'], summary: 'Approve minutes with e-signature', security: [{ bearerAuth: [] }],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } },
            { name: 'minutesId', in: 'path', required: true, schema: { type: 'integer' } },
          ],
          responses: { '200': { description: 'Minutes approved with SHA-256 signature' } },
        },
      },
      '/committee/meetings/{id}/committee-members': {
        get: {
          tags: ['Meetings'], summary: 'Meeting committee members', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Active committee members' } },
        },
      },

      // ─── Voting ───
      '/committee/voting/meeting/{meetingId}': {
        get: {
          tags: ['Voting'], summary: 'Voting sessions for a meeting', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'meetingId', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Voting sessions' } },
        },
      },
      '/committee/voting/sessions': {
        post: {
          tags: ['Voting'], summary: 'Create voting session', security: [{ bearerAuth: [] }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { meeting_agenda_id: { type: 'integer' } }, required: ['meeting_agenda_id'] } } } },
          responses: { '201': { description: 'Session created' } },
        },
      },
      '/committee/voting/sessions/{id}/vote': {
        post: {
          tags: ['Voting'], summary: 'Cast a vote', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { vote_value: { type: 'string', enum: ['APPROVE', 'REJECT', 'ABSTAIN'] }, vote_notes: { type: 'string' } }, required: ['vote_value'] } } } },
          responses: { '201': { description: 'Vote recorded' } },
        },
      },
      '/committee/voting/sessions/{id}/close': {
        patch: {
          tags: ['Voting'], summary: 'Close voting session', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          responses: { '200': { description: 'Session closed, voters and applicant notified' } },
        },
      },

      // ─── Reporting (remaining) ───
      '/reporting/applications': {
        get: {
          tags: ['Reporting'], summary: 'Filter applications', security: [{ bearerAuth: [] }],
          parameters: [
            { name: 'status', in: 'query', schema: { type: 'string' } },
            { name: 'from', in: 'query', schema: { type: 'string', format: 'date' } },
            { name: 'to', in: 'query', schema: { type: 'string', format: 'date' } },
            { name: 'search', in: 'query', schema: { type: 'string' } },
          ],
          responses: { '200': { description: 'Filtered applications' } },
        },
      },
      '/reporting/committees': {
        get: {
          tags: ['Reporting'], summary: 'Committees with review/meeting stats', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Committee stats' } },
        },
      },
      '/reporting/status-summary': {
        get: {
          tags: ['Reporting'], summary: 'Status summary counts', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Aggregate by status' } },
        },
      },
      '/reporting/applications-trend': {
        get: {
          tags: ['Reporting'], summary: 'Monthly application trend (12 months)', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Monthly counts' } },
        },
      },
      '/reporting/export/applications': {
        get: {
          tags: ['Reporting'], summary: 'Export applications as CSV', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'CSV file download' } },
        },
      },
      '/reporting/dashboard/stream': {
        get: {
          tags: ['Reporting'], summary: 'SSE stream for real-time dashboard updates',
          parameters: [{ name: 'token', in: 'query', required: true, schema: { type: 'string' }, description: 'JWT token' }],
          responses: { '200': { description: 'EventSource stream — sends dashboard-stats events' } },
        },
      },

      // ─── Applications ───
      '/core/applications/{id}/committee-decision': {
        post: {
          tags: ['Applications'], summary: 'Submit committee decision', security: [{ bearerAuth: [] }],
          parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'integer' } }],
          requestBody: { content: { 'application/json': { schema: { type: 'object', properties: { decision: { type: 'string', enum: ['APPROVED', 'REJECTED', 'CONDITIONAL'] }, notes: { type: 'string' } }, required: ['decision'] } } } },
          responses: { '201': { description: 'Decision recorded' } },
        },
      },

      // ─── Integration ───
      '/integration/events': {
        get: {
          tags: ['Integration'], summary: 'Event outbox (last 100)', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Events' } },
        },
      },
      '/integration/logs': {
        get: {
          tags: ['Integration'], summary: 'Integration log (last 100)', security: [{ bearerAuth: [] }],
          responses: { '200': { description: 'Logs' } },
        },
      },
    },
  },
  apis: [],
};

export const swaggerSpec = swaggerJsdoc(options);
