-- ============================================================
-- TRUNCATE ALL TABLES (order by dependency, children first)
-- ============================================================
-- تفريغ جميع الجداول من البيانات مع إعادة تعيين المتسلسلات (sequences).
-- يُستخدم قبل إعادة تشغيل البذور من البداية لضمان بيئة نظيفة.
-- Document templates / generated / access / versions
TRUNCATE TABLE documents.generated_documents RESTART IDENTITY CASCADE;
TRUNCATE TABLE documents.document_access RESTART IDENTITY CASCADE;
TRUNCATE TABLE documents.document_approvals RESTART IDENTITY CASCADE;
TRUNCATE TABLE documents.document_audit RESTART IDENTITY CASCADE;
TRUNCATE TABLE documents.document_versions RESTART IDENTITY CASCADE;
TRUNCATE TABLE documents.document_signatures RESTART IDENTITY CASCADE;
TRUNCATE TABLE documents.documents RESTART IDENTITY CASCADE;
TRUNCATE TABLE documents.templates RESTART IDENTITY CASCADE;
TRUNCATE TABLE documents.document_types RESTART IDENTITY CASCADE;

-- Voting
TRUNCATE TABLE committee.votes RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.voting_sessions RESTART IDENTITY CASCADE;

-- Meeting minutes / attendance / agenda
TRUNCATE TABLE committee.agenda_items RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.meeting_minutes RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.quorum_logs RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.attendance_logs RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.meeting_agendas RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.committee_meetings RESTART IDENTITY CASCADE;

-- Reviews
TRUNCATE TABLE committee.consent_review_comments RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.application_consents RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.consent_template_versions RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.consent_templates RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.ethics_risk_items RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.ethics_risk_assessments RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.review_answers RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.review_comments RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.review_recommendations RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.review_scores RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.review_conflicts RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.review_assignments RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.ethics_reviews RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.scientific_reviews RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.review_questions RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.review_forms RESTART IDENTITY CASCADE;

-- Committee members
TRUNCATE TABLE committee.committee_member_roles RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.member_conflicts RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.member_qualifications RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.member_terms RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.committee_members RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.committee_roles RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.committees RESTART IDENTITY CASCADE;
TRUNCATE TABLE committee.committee_types RESTART IDENTITY CASCADE;

-- Workflow
TRUNCATE TABLE workflow.workflow_escalations RESTART IDENTITY CASCADE;
TRUNCATE TABLE workflow.workflow_variables RESTART IDENTITY CASCADE;
TRUNCATE TABLE workflow.workflow_history RESTART IDENTITY CASCADE;
TRUNCATE TABLE workflow.workflow_comments RESTART IDENTITY CASCADE;
TRUNCATE TABLE workflow.workflow_actions RESTART IDENTITY CASCADE;
TRUNCATE TABLE workflow.workflow_tasks RESTART IDENTITY CASCADE;
TRUNCATE TABLE workflow.workflow_instances RESTART IDENTITY CASCADE;
TRUNCATE TABLE workflow.workflow_sla RESTART IDENTITY CASCADE;
TRUNCATE TABLE workflow.workflow_transitions RESTART IDENTITY CASCADE;
TRUNCATE TABLE workflow.workflow_states RESTART IDENTITY CASCADE;
TRUNCATE TABLE workflow.workflows RESTART IDENTITY CASCADE;

-- Applications
TRUNCATE TABLE core.amendment_requests RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.application_amendments RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.application_versions RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.application_checklists RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.application_sections RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.application_validations RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.application_history RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.closure_requests RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.renewal_requests RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.applications RESTART IDENTITY CASCADE;

-- Projects
TRUNCATE TABLE core.project_site_investigators RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.project_team_members RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.project_status_history RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.project_versions RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.project_attachments RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.project_funding_sources RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.project_keywords RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.project_tags RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.project_sites RESTART IDENTITY CASCADE;
TRUNCATE TABLE core.projects RESTART IDENTITY CASCADE;

-- Safety
TRUNCATE TABLE safety.safety_followups RESTART IDENTITY CASCADE;
TRUNCATE TABLE safety.serious_adverse_events RESTART IDENTITY CASCADE;
TRUNCATE TABLE safety.adverse_events RESTART IDENTITY CASCADE;
TRUNCATE TABLE safety.mitigation_actions RESTART IDENTITY CASCADE;
TRUNCATE TABLE safety.safety_committee_reviews RESTART IDENTITY CASCADE;
TRUNCATE TABLE safety.safety_reports RESTART IDENTITY CASCADE;
TRUNCATE TABLE safety.risk_assessments RESTART IDENTITY CASCADE;
TRUNCATE TABLE safety.risk_categories RESTART IDENTITY CASCADE;

-- Monitoring
TRUNCATE TABLE monitoring.inspection_reports RESTART IDENTITY CASCADE;
TRUNCATE TABLE monitoring.inspections RESTART IDENTITY CASCADE;
TRUNCATE TABLE monitoring.corrective_actions RESTART IDENTITY CASCADE;
TRUNCATE TABLE monitoring.preventive_actions RESTART IDENTITY CASCADE;
TRUNCATE TABLE monitoring.monitoring_findings RESTART IDENTITY CASCADE;
TRUNCATE TABLE monitoring.monitoring_visits RESTART IDENTITY CASCADE;
TRUNCATE TABLE monitoring.monitoring_plans RESTART IDENTITY CASCADE;
TRUNCATE TABLE monitoring.protocol_violations RESTART IDENTITY CASCADE;
TRUNCATE TABLE monitoring.deviations RESTART IDENTITY CASCADE;
TRUNCATE TABLE monitoring.compliance_reviews RESTART IDENTITY CASCADE;

-- Messages / notifications
TRUNCATE TABLE communication.notification_logs RESTART IDENTITY CASCADE;
TRUNCATE TABLE communication.notifications RESTART IDENTITY CASCADE;
TRUNCATE TABLE communication.notification_templates RESTART IDENTITY CASCADE;
TRUNCATE TABLE communication.notification_channels RESTART IDENTITY CASCADE;
TRUNCATE TABLE communication.announcements RESTART IDENTITY CASCADE;
TRUNCATE TABLE communication.message_attachments RESTART IDENTITY CASCADE;
TRUNCATE TABLE communication.message_recipients RESTART IDENTITY CASCADE;
TRUNCATE TABLE communication.messages RESTART IDENTITY CASCADE;

-- User roles / permissions
TRUNCATE TABLE security.api_keys RESTART IDENTITY CASCADE;
TRUNCATE TABLE security.access_policies RESTART IDENTITY CASCADE;
TRUNCATE TABLE security.role_permissions RESTART IDENTITY CASCADE;
TRUNCATE TABLE security.user_roles RESTART IDENTITY CASCADE;
TRUNCATE TABLE security.password_history RESTART IDENTITY CASCADE;
TRUNCATE TABLE security.sessions RESTART IDENTITY CASCADE;
TRUNCATE TABLE security.user_profiles RESTART IDENTITY CASCADE;
TRUNCATE TABLE security.login_audit RESTART IDENTITY CASCADE;
TRUNCATE TABLE security.security_events RESTART IDENTITY CASCADE;

-- Users
TRUNCATE TABLE security.users RESTART IDENTITY CASCADE;
TRUNCATE TABLE security.departments RESTART IDENTITY CASCADE;
TRUNCATE TABLE security.institutions RESTART IDENTITY CASCADE;
TRUNCATE TABLE security.institution_types RESTART IDENTITY CASCADE;
TRUNCATE TABLE security.roles RESTART IDENTITY CASCADE;
TRUNCATE TABLE security.permissions RESTART IDENTITY CASCADE;

-- Reference
TRUNCATE TABLE reference.application_statuses RESTART IDENTITY CASCADE;
TRUNCATE TABLE reference.risk_levels RESTART IDENTITY CASCADE;
TRUNCATE TABLE reference.priority_levels RESTART IDENTITY CASCADE;
TRUNCATE TABLE reference.vote_types RESTART IDENTITY CASCADE;
TRUNCATE TABLE reference.lookup_categories RESTART IDENTITY CASCADE;
TRUNCATE TABLE reference.lookup_values RESTART IDENTITY CASCADE;
TRUNCATE TABLE reference.workflow_statuses RESTART IDENTITY CASCADE;
TRUNCATE TABLE reference.document_statuses RESTART IDENTITY CASCADE;
TRUNCATE TABLE reference.committee_decision_types RESTART IDENTITY CASCADE;
TRUNCATE TABLE reference.review_statuses RESTART IDENTITY CASCADE;
TRUNCATE TABLE reference.academic_titles RESTART IDENTITY CASCADE;

-- Reporting
TRUNCATE TABLE reporting.report_executions RESTART IDENTITY CASCADE;
TRUNCATE TABLE reporting.report_definitions RESTART IDENTITY CASCADE;
TRUNCATE TABLE reporting.kpi_results RESTART IDENTITY CASCADE;
TRUNCATE TABLE reporting.dashboard_widgets RESTART IDENTITY CASCADE;
TRUNCATE TABLE reporting.analytics_snapshots RESTART IDENTITY CASCADE;

-- Reference
TRUNCATE TABLE reference.notification_statuses RESTART IDENTITY CASCADE;
TRUNCATE TABLE reference.status_types RESTART IDENTITY CASCADE;

-- Audit
TRUNCATE TABLE audit.audit_details RESTART IDENTITY CASCADE;
TRUNCATE TABLE audit.entity_changes RESTART IDENTITY CASCADE;
TRUNCATE TABLE audit.audit_logs RESTART IDENTITY CASCADE;
TRUNCATE TABLE system.push_config RESTART IDENTITY CASCADE;
TRUNCATE TABLE system.audit_log RESTART IDENTITY CASCADE;
