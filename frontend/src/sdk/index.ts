// ─── SDK — ERM Ethics API TypeScript Client ───
// Generated from OpenAPI 3.1 Contract (v1.0.0)
// Domain-isolated, type-safe, RBAC-aligned.

export { configureSdk, getConfig } from './core/config'
export * from './core/types'

export { auth, users, roles, permissions, responsibilities } from './domains/security.sdk'
export { projects } from './domains/projects.sdk'
export { applications } from './domains/applications.sdk'
export { committees, meetings, members } from './domains/committee.sdk'
export { reviews, voting } from './domains/reviews.sdk'
export { documents } from './domains/documents.sdk'
export { notifications, messages } from './domains/communication.sdk'
export { reporting } from './domains/reporting.sdk'
export { safety } from './domains/safety.sdk'
export { admin } from './domains/admin.sdk'
export { monitoring } from './domains/monitoring.sdk'
export { integration } from './domains/integration.sdk'
export { system } from './domains/system.sdk'
export { reference } from './domains/reference.sdk'
export { lookups } from './domains/lookups.sdk'
export { workflow } from './domains/workflow.sdk'

import api from '../api/client'
export { api }
