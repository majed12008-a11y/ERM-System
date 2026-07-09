-- =============================================================================
-- cleanup-test-data.sql
-- Removes ALL test/demo data from ethics_db, preserving only
-- reference/initialization data (بيانات التهيئة) required for system function.
--
-- KEPT data:
--   reference schema        — all reference lookup tables
--   system schema           — system configuration
--   security.roles          — role definitions (SUPER_ADMIN, etc.)
--   security.permissions    — permission definitions
--   security.role_permissions — role-permission mappings
--   security.institution_types — institution type codes
--   security.responsibility_types — responsibility type codes
--   security.access_policies — access policy definitions
--   committee.committee_types — IRB, IACUC, IBC
--   committee.committee_roles  — CHAIR, MEMBER, etc.
--   documents.document_types — document type definitions
--   documents.document_classifications — document classification codes
--   documents.templates     — document templates
--   communication.notification_channels — channel configuration
--   communication.notification_templates — template definitions
--   workflow.workflows      — APP_REVIEW_V1 workflow definition
--   workflow.workflow_states — workflow state definitions (9 states)
--   workflow.workflow_transitions — workflow transition definitions (14)
--   core.risk_classifications — risk classification data
--   core.vulnerable_populations — vulnerable population types
--   core.research_categories — research category types
--   reference.academic_titles — academic title reference data
--   reference.professions_registry — profession reference data
--   reporting.dashboard_widgets — widget definitions
--   reporting.report_definitions — report type definitions
--   security.users          — ONLY admin (id=1), all other users deleted
--   security.user_roles     — ONLY admin's role assignments
--   security.user_profiles  — ONLY admin's profile
--
-- Usage:  psql -U postgres -d ethics_db -f scripts/cleanup-test-data.sql
--         psql -U postgres -d ethics_db -f scripts/verify-cleanup.sql
-- WARNING: Destructive. Run verify-cleanup.sql after.
-- =============================================================================

BEGIN;

-- Disable FK triggers for clean deletion order
SET session_replication_role = 'replica';

-- =============================================================================
-- 1. AUDIT — generated audit trail from test activity
-- =============================================================================
DELETE FROM audit.audit_details;
DELETE FROM audit.audit_logs;
DELETE FROM audit.entity_changes;
DELETE FROM audit.hash_ledger;

-- =============================================================================
-- 2. SAFETY — all test safety data
-- =============================================================================
DELETE FROM safety.serious_adverse_events;
DELETE FROM safety.safety_reports;
DELETE FROM safety.safety_followups;
DELETE FROM safety.safety_committee_reviews;
DELETE FROM safety.risk_mitigations;
DELETE FROM safety.risk_incidents;
DELETE FROM safety.risk_register;
DELETE FROM safety.risk_categories;
DELETE FROM safety.risk_assessments;
DELETE FROM safety.mitigation_actions;
DELETE FROM safety.corrective_actions;
DELETE FROM safety.adverse_events;

-- =============================================================================
-- 3. MONITORING — all test monitoring data
-- =============================================================================
DELETE FROM monitoring.protocol_violations;
DELETE FROM monitoring.preventive_actions;
DELETE FROM monitoring.monitoring_visits;
DELETE FROM monitoring.monitoring_plans;
DELETE FROM monitoring.monitoring_findings;
DELETE FROM monitoring.inspections;
DELETE FROM monitoring.inspection_reports;
DELETE FROM monitoring.deviations;
DELETE FROM monitoring.corrective_actions;
DELETE FROM monitoring.compliance_reviews;

-- =============================================================================
-- 4. COMMUNICATION — generated messages, notifications, announcements
-- =============================================================================
DELETE FROM communication.user_notification_preferences;
DELETE FROM communication.notification_logs;
DELETE FROM communication.notifications;
DELETE FROM communication.message_attachments;
DELETE FROM communication.message_recipients;
DELETE FROM communication.messages;
DELETE FROM communication.announcements;

-- =============================================================================
-- 5. DOCUMENTS — test documents, certificates, signatures
-- =============================================================================
DELETE FROM documents.generated_documents;
DELETE FROM documents.certificate_verification_log;
DELETE FROM documents.approval_certificate_documents;
DELETE FROM documents.approval_certificates;
DELETE FROM documents.document_signatures;
DELETE FROM documents.document_disposal_logs;
DELETE FROM documents.document_audit;
DELETE FROM documents.document_approvals;
DELETE FROM documents.document_access;
DELETE FROM documents.document_versions;
DELETE FROM documents.documents;

-- =============================================================================
-- 6. WORKFLOW — test workflow instances and execution history
-- =============================================================================
DELETE FROM workflow.workflow_variables;
DELETE FROM workflow.workflow_triggers;
DELETE FROM workflow.workflow_tasks;
DELETE FROM workflow.workflow_schedulers;
DELETE FROM workflow.workflow_sla;
DELETE FROM workflow.workflow_history;
DELETE FROM workflow.workflow_events;
DELETE FROM workflow.workflow_escalations;
DELETE FROM workflow.workflow_comments;
DELETE FROM workflow.workflow_actions;
DELETE FROM workflow.workflow_instances;

-- =============================================================================
-- 7. COMMITTEE — test reviews, meetings, accreditation, conditions
-- =============================================================================
-- Ethics risk assessment
DELETE FROM committee.ethics_risk_items;
DELETE FROM committee.ethics_risk_assessments;

-- Consent
DELETE FROM committee.consent_review_comments;
DELETE FROM committee.consent_template_versions;
DELETE FROM committee.consent_templates;

-- Reviews (delete leaf tables first)
DELETE FROM committee.review_recommendations;
DELETE FROM committee.review_scores;
DELETE FROM committee.review_conflicts;
DELETE FROM committee.review_comments;
DELETE FROM committee.review_answers;
DELETE FROM committee.review_assignments;
DELETE FROM committee.scientific_reviews;
DELETE FROM committee.ethics_reviews;

-- Review forms and questions (test data, not reference)
DELETE FROM committee.review_questions;
DELETE FROM committee.review_forms;

-- Meeting-related
DELETE FROM committee.quorum_logs;
DELETE FROM committee.agenda_items;
DELETE FROM committee.meeting_minutes;
DELETE FROM committee.meeting_agendas;
DELETE FROM committee.attendance_logs;
DELETE FROM committee.committee_meetings;
DELETE FROM committee.votes;
DELETE FROM committee.voting_sessions;

-- Accreditation
DELETE FROM committee.accreditation_evidence;
DELETE FROM committee.accreditation_conditions;
DELETE FROM committee.accreditation_decisions;
DELETE FROM committee.accreditation_assessment_items;
DELETE FROM committee.accreditation_assessments;
DELETE FROM committee.accreditation_standard_versions;
DELETE FROM committee.accreditation_standards;
DELETE FROM committee.accreditation_cycle_metrics;
DELETE FROM committee.accreditation_cycles;

-- Conditions
DELETE FROM committee.application_conditions;

-- Member roles and members (all test data)
DELETE FROM committee.committee_member_roles;
DELETE FROM committee.committee_members;

-- Committees (all are test data)
DELETE FROM committee.committees;

-- =============================================================================
-- 8. CORE — all projects, applications, research data
-- =============================================================================
DELETE FROM core.renewal_requests;
DELETE FROM core.closure_requests;
DELETE FROM core.application_amendments;
DELETE FROM core.amendment_requests;
DELETE FROM core.application_validations;
DELETE FROM core.application_history;
DELETE FROM core.application_consents;
DELETE FROM core.application_checklists;
DELETE FROM core.application_sections;
DELETE FROM core.application_versions;
DELETE FROM core.applications;
DELETE FROM core.project_versions;
DELETE FROM core.project_status_history;
DELETE FROM core.research_population_links;
DELETE FROM core.project_attachments;
DELETE FROM core.project_tags;
DELETE FROM core.project_team_members;
DELETE FROM core.project_site_investigators;
DELETE FROM core.project_sites;
DELETE FROM core.project_funding_sources;
DELETE FROM core.project_keywords;
DELETE FROM core.projects;

-- =============================================================================
-- 9. INTEGRATION — generated event and sync data
-- =============================================================================
DELETE FROM integration.webhooks;
DELETE FROM integration.retry_queue;
DELETE FROM integration.integration_logs;
DELETE FROM integration.integration_failures;
DELETE FROM integration.integration_credentials;
DELETE FROM integration.external_systems;
DELETE FROM integration.event_subscriptions;
DELETE FROM integration.event_outbox;
DELETE FROM integration.event_bus_config;
DELETE FROM integration.data_sync_jobs;

-- =============================================================================
-- 10. REPORTING — generated analytics (keep definitions)
-- =============================================================================
DELETE FROM reporting.report_executions;
DELETE FROM reporting.kpi_results;
DELETE FROM reporting.analytics_snapshots;

-- Materialized views: refresh with no data to clear their contents
REFRESH MATERIALIZED VIEW reporting.mv_daily_application_snapshot WITH NO DATA;
REFRESH MATERIALIZED VIEW reporting.mv_committee_performance WITH NO DATA;

-- =============================================================================
-- 11. PUBLIC — test performance results
-- =============================================================================
DELETE FROM public.perf_results;

-- =============================================================================
-- 12. SECURITY — sessions, tokens, test users, test institutions
-- =============================================================================
DELETE FROM security.security_events;
DELETE FROM security.segregation_rules;
DELETE FROM security.role_delegations;
DELETE FROM security.password_reset_tokens;
DELETE FROM security.password_history;
DELETE FROM security.email_verification_tokens;
DELETE FROM security.digital_certificates;
DELETE FROM security.certificate_revocations;
DELETE FROM security.approval_limits;
DELETE FROM security.approval_authorities;
DELETE FROM security.api_keys;
DELETE FROM security.sessions;
DELETE FROM security.login_audit;
DELETE FROM security.user_responsibilities;

-- Delete non-admin user profiles, roles, and users
DELETE FROM security.user_profiles WHERE user_id > 1;
DELETE FROM security.user_roles WHERE user_id > 1;
DELETE FROM security.users WHERE id > 1;

-- Detach admin from any institution (will be re-associated later)
-- Note: institution_id has NOT NULL constraint, so keep THU (id=1) as base institution
-- UPDATE security.users SET institution_id = NULL WHERE id = 1;

-- Delete all test institutions (keep only base institution THU, id=1)
DELETE FROM security.departments WHERE institution_id > 1;
DELETE FROM security.institutions WHERE id > 1;

-- Keep: access_policies (all 7 are reference data)

-- =============================================================================
-- 13. Reset sequences for cleaned tables (optional)
-- =============================================================================
-- Audit
ALTER SEQUENCE IF EXISTS audit.audit_details_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS audit.audit_logs_id_seq RESTART WITH 1;

-- Core
ALTER SEQUENCE IF EXISTS core.projects_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS core.applications_id_seq RESTART WITH 1;

-- Committee
ALTER SEQUENCE IF EXISTS committee.committees_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS committee.committee_members_id_seq RESTART WITH 1;

-- Workflow
ALTER SEQUENCE IF EXISTS workflow.workflow_instances_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS workflow.workflow_actions_id_seq RESTART WITH 1;

-- Security (users only)
ALTER SEQUENCE IF EXISTS security.users_id_seq RESTART WITH 2;

-- Re-enable FK triggers
SET session_replication_role = 'origin';

COMMIT;

-- =============================================================================
-- Verification
-- =============================================================================
\t on
\echo ''
\echo '=== Cleanup Complete ==='
\echo '=== Verify: Only reference data + admin remain ==='
\echo ''

\echo '► Users (should be 1 — admin):'
SELECT COUNT(*) AS remaining_users FROM security.users;

\echo '► Remaining users (should be admin only):'
SELECT id, username FROM security.users ORDER BY id;

\echo '► Institutions (should be 1 — base institution THU):'
SELECT COUNT(*) AS remaining_institutions FROM security.institutions;

\echo '► Projects (should be 0):'
SELECT COUNT(*) AS remaining_projects FROM core.projects;

\echo '► Applications (should be 0):'
SELECT COUNT(*) AS remaining_applications FROM core.applications;

\echo '► Roles (reference data — should be 5):'
SELECT code, name_en FROM security.roles ORDER BY code;

\echo '► Permissions (reference data — should be 29+):'
SELECT COUNT(*) AS remaining_permissions FROM security.permissions;

\echo '► Workflows (should be 1 — APP_REVIEW_V1):'
SELECT workflow_code, workflow_name FROM workflow.workflows;

\echo '► Workflow states (should be 9):'
SELECT COUNT(*) AS workflow_states FROM workflow.workflow_states;

\echo '► Workflow transitions (should be 14):'
SELECT COUNT(*) AS workflow_transitions FROM workflow.workflow_transitions;

\echo '► Reference statuses (should be populated):'
SELECT COUNT(*) AS application_statuses FROM reference.application_statuses;

\echo '► Document types (should be 9):'
SELECT COUNT(*) AS document_types FROM documents.document_types;

\echo '► Committee types (reference — should be 3):'
SELECT type_code, type_name FROM committee.committee_types;

\echo '► Committee roles (reference — should be 5):'
SELECT role_code, role_name FROM committee.committee_roles;

\t on
