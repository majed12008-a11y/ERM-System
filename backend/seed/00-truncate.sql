-- ============================================================
-- TRUNCATE ALL TABLES (order by dependency, children first)
-- ============================================================
-- Document templates / generated / access / versions
TRUNCATE TABLE documents.generated_documents CASCADE;
TRUNCATE TABLE documents.document_access CASCADE;
TRUNCATE TABLE documents.document_approvals CASCADE;
TRUNCATE TABLE documents.document_audit CASCADE;
TRUNCATE TABLE documents.document_versions CASCADE;
TRUNCATE TABLE documents.document_signatures CASCADE;
TRUNCATE TABLE documents.documents CASCADE;
TRUNCATE TABLE documents.templates CASCADE;
TRUNCATE TABLE documents.document_types CASCADE;

-- Voting
TRUNCATE TABLE committee.votes CASCADE;
TRUNCATE TABLE committee.voting_sessions CASCADE;

-- Meeting minutes / attendance / agenda
TRUNCATE TABLE committee.agenda_items CASCADE;
TRUNCATE TABLE committee.meeting_minutes CASCADE;
TRUNCATE TABLE committee.quorum_logs CASCADE;
TRUNCATE TABLE committee.attendance_logs CASCADE;
TRUNCATE TABLE committee.meeting_agendas CASCADE;
TRUNCATE TABLE committee.committee_meetings CASCADE;

-- Reviews
TRUNCATE TABLE committee.review_answers CASCADE;
TRUNCATE TABLE committee.review_comments CASCADE;
TRUNCATE TABLE committee.review_recommendations CASCADE;
TRUNCATE TABLE committee.review_scores CASCADE;
TRUNCATE TABLE committee.review_conflicts CASCADE;
TRUNCATE TABLE committee.review_assignments CASCADE;
TRUNCATE TABLE committee.ethics_reviews CASCADE;
TRUNCATE TABLE committee.scientific_reviews CASCADE;
TRUNCATE TABLE committee.review_questions CASCADE;
TRUNCATE TABLE committee.review_forms CASCADE;

-- Committee members
TRUNCATE TABLE committee.member_roles CASCADE;
TRUNCATE TABLE committee.member_conflicts CASCADE;
TRUNCATE TABLE committee.member_qualifications CASCADE;
TRUNCATE TABLE committee.member_terms CASCADE;
TRUNCATE TABLE committee.committee_members CASCADE;
TRUNCATE TABLE committee.committee_roles CASCADE;
TRUNCATE TABLE committee.committees CASCADE;
TRUNCATE TABLE committee.committee_types CASCADE;

-- Workflow
TRUNCATE TABLE workflow.workflow_escalations CASCADE;
TRUNCATE TABLE workflow.workflow_variables CASCADE;
TRUNCATE TABLE workflow.workflow_history CASCADE;
TRUNCATE TABLE workflow.workflow_comments CASCADE;
TRUNCATE TABLE workflow.workflow_actions CASCADE;
TRUNCATE TABLE workflow.workflow_tasks CASCADE;
TRUNCATE TABLE workflow.workflow_instances CASCADE;
TRUNCATE TABLE workflow.workflow_sla CASCADE;
TRUNCATE TABLE workflow.workflow_transitions CASCADE;
TRUNCATE TABLE workflow.workflow_states CASCADE;
TRUNCATE TABLE workflow.workflows CASCADE;

-- Applications
TRUNCATE TABLE core.amendment_requests CASCADE;
TRUNCATE TABLE core.application_amendments CASCADE;
TRUNCATE TABLE core.application_versions CASCADE;
TRUNCATE TABLE core.application_checklists CASCADE;
TRUNCATE TABLE core.application_sections CASCADE;
TRUNCATE TABLE core.application_validations CASCADE;
TRUNCATE TABLE core.application_history CASCADE;
TRUNCATE TABLE core.closure_requests CASCADE;
TRUNCATE TABLE core.renewal_requests CASCADE;
TRUNCATE TABLE core.applications CASCADE;

-- Projects
TRUNCATE TABLE core.project_site_investigators CASCADE;
TRUNCATE TABLE core.project_team_members CASCADE;
TRUNCATE TABLE core.project_status_history CASCADE;
TRUNCATE TABLE core.project_versions CASCADE;
TRUNCATE TABLE core.project_attachments CASCADE;
TRUNCATE TABLE core.project_funding_sources CASCADE;
TRUNCATE TABLE core.project_keywords CASCADE;
TRUNCATE TABLE core.project_tags CASCADE;
TRUNCATE TABLE core.project_sites CASCADE;
TRUNCATE TABLE core.projects CASCADE;

-- Safety
TRUNCATE TABLE safety.safety_followups CASCADE;
TRUNCATE TABLE safety.serious_adverse_events CASCADE;
TRUNCATE TABLE safety.adverse_events CASCADE;
TRUNCATE TABLE safety.mitigation_actions CASCADE;
TRUNCATE TABLE safety.safety_committee_reviews CASCADE;
TRUNCATE TABLE safety.safety_reports CASCADE;
TRUNCATE TABLE safety.risk_assessments CASCADE;
TRUNCATE TABLE safety.risk_categories CASCADE;

-- Monitoring
TRUNCATE TABLE monitoring.inspection_reports CASCADE;
TRUNCATE TABLE monitoring.inspections CASCADE;
TRUNCATE TABLE monitoring.corrective_actions CASCADE;
TRUNCATE TABLE monitoring.preventive_actions CASCADE;
TRUNCATE TABLE monitoring.monitoring_findings CASCADE;
TRUNCATE TABLE monitoring.monitoring_visits CASCADE;
TRUNCATE TABLE monitoring.monitoring_plans CASCADE;
TRUNCATE TABLE monitoring.protocol_violations CASCADE;
TRUNCATE TABLE monitoring.deviations CASCADE;
TRUNCATE TABLE monitoring.compliance_reviews CASCADE;

-- Messages / notifications
TRUNCATE TABLE communication.notification_logs CASCADE;
TRUNCATE TABLE communication.notifications CASCADE;
TRUNCATE TABLE communication.notification_templates CASCADE;
TRUNCATE TABLE communication.notification_channels CASCADE;
TRUNCATE TABLE communication.announcements CASCADE;
TRUNCATE TABLE communication.message_attachments CASCADE;
TRUNCATE TABLE communication.message_recipients CASCADE;
TRUNCATE TABLE communication.messages CASCADE;

-- User roles / permissions
TRUNCATE TABLE security.api_keys CASCADE;
TRUNCATE TABLE security.access_policies CASCADE;
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

-- Reporting
TRUNCATE TABLE reporting.report_executions CASCADE;
TRUNCATE TABLE reporting.report_definitions CASCADE;
TRUNCATE TABLE reporting.kpi_results CASCADE;
TRUNCATE TABLE reporting.dashboard_widgets CASCADE;
TRUNCATE TABLE reporting.analytics_snapshots CASCADE;

-- Reference
TRUNCATE TABLE reference.notification_statuses CASCADE;
TRUNCATE TABLE reference.status_types CASCADE;

-- Audit
TRUNCATE TABLE audit.audit_details CASCADE;
TRUNCATE TABLE audit.entity_changes CASCADE;
TRUNCATE TABLE audit.audit_logs CASCADE;
TRUNCATE TABLE system.audit_log CASCADE;
