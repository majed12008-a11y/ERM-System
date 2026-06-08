-- ============================================================
-- TRUNCATE ALL TABLES (order by dependency, children first)
-- ============================================================
-- Document signatures (depends on documents)
TRUNCATE TABLE documents.document_signatures CASCADE;
-- Documents
TRUNCATE TABLE documents.documents CASCADE;
-- Document types
TRUNCATE TABLE documents.document_types CASCADE;

-- Voting
TRUNCATE TABLE committee.votes CASCADE;
TRUNCATE TABLE committee.voting_sessions CASCADE;

-- Meeting minutes / attendance / agenda
TRUNCATE TABLE committee.meeting_minutes CASCADE;
TRUNCATE TABLE committee.attendance_logs CASCADE;
TRUNCATE TABLE committee.meeting_agendas CASCADE;
TRUNCATE TABLE committee.committee_meetings CASCADE;

-- Reviews
TRUNCATE TABLE committee.review_answers CASCADE;
TRUNCATE TABLE committee.review_comments CASCADE;
TRUNCATE TABLE committee.review_recommendations CASCADE;
TRUNCATE TABLE committee.review_assignments CASCADE;
TRUNCATE TABLE committee.ethics_reviews CASCADE;
TRUNCATE TABLE committee.scientific_reviews CASCADE;
TRUNCATE TABLE committee.review_questions CASCADE;
TRUNCATE TABLE committee.review_forms CASCADE;

-- Committee members
TRUNCATE TABLE committee.committee_members CASCADE;
TRUNCATE TABLE committee.committee_roles CASCADE;
TRUNCATE TABLE committee.committees CASCADE;
TRUNCATE TABLE committee.committee_types CASCADE;

-- Workflow
TRUNCATE TABLE workflow.workflow_actions CASCADE;
TRUNCATE TABLE workflow.workflow_tasks CASCADE;
TRUNCATE TABLE workflow.workflow_instances CASCADE;
TRUNCATE TABLE workflow.workflow_transitions CASCADE;
TRUNCATE TABLE workflow.workflow_states CASCADE;
TRUNCATE TABLE workflow.workflows CASCADE;

-- Applications
TRUNCATE TABLE core.application_versions CASCADE;
TRUNCATE TABLE core.application_history CASCADE;
TRUNCATE TABLE core.applications CASCADE;

-- Projects
TRUNCATE TABLE core.project_team_members CASCADE;
TRUNCATE TABLE core.projects CASCADE;

-- Messages / notifications
TRUNCATE TABLE communication.message_attachments CASCADE;
TRUNCATE TABLE communication.message_recipients CASCADE;
TRUNCATE TABLE communication.messages CASCADE;
TRUNCATE TABLE communication.notifications CASCADE;
TRUNCATE TABLE communication.notification_templates CASCADE;

-- User roles / permissions
TRUNCATE TABLE security.role_permissions CASCADE;
TRUNCATE TABLE security.user_roles CASCADE;
TRUNCATE TABLE security.password_history CASCADE;
TRUNCATE TABLE security.sessions CASCADE;
TRUNCATE TABLE security.user_profiles CASCADE;
TRUNCATE TABLE security.login_audit CASCADE;
TRUNCATE TABLE security.security_events CASCADE;

-- Users
TRUNCATE TABLE security.users CASCADE;
TRUNCATE TABLE security.departments CASCADE;
TRUNCATE TABLE security.institutions CASCADE;
TRUNCATE TABLE security.institution_types CASCADE;
TRUNCATE TABLE security.roles CASCADE;
TRUNCATE TABLE security.permissions CASCADE;

-- Reference
TRUNCATE TABLE reference.application_statuses CASCADE;
TRUNCATE TABLE reference.risk_levels CASCADE;
TRUNCATE TABLE reference.priority_levels CASCADE;
TRUNCATE TABLE reference.vote_types CASCADE;
TRUNCATE TABLE reference.lookup_categories CASCADE;
TRUNCATE TABLE reference.lookup_values CASCADE;
TRUNCATE TABLE reference.workflow_statuses CASCADE;
TRUNCATE TABLE reference.document_statuses CASCADE;
TRUNCATE TABLE reference.committee_decision_types CASCADE;
TRUNCATE TABLE reference.review_statuses CASCADE;

-- Audit
TRUNCATE TABLE system.audit_log CASCADE;
TRUNCATE TABLE audit.audit_logs CASCADE;
