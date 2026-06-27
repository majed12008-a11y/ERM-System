--
-- PostgreSQL database dump
--

\restrict BeJiYhic2kgYW2GrXabhB8bWY1tIxtXXSgbK4HPXmOTGqSJBJG88RgBAWywSqeI

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

--
-- Name: hash_ledger hash_ledger_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.hash_ledger
    ADD CONSTRAINT hash_ledger_pkey PRIMARY KEY (id);


--
-- Name: audit_details pk_audit_details; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.audit_details
    ADD CONSTRAINT pk_audit_details PRIMARY KEY (id);


--
-- Name: audit_logs pk_audit_logs; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.audit_logs
    ADD CONSTRAINT pk_audit_logs PRIMARY KEY (id);


--
-- Name: entity_changes pk_entity_changes; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.entity_changes
    ADD CONSTRAINT pk_entity_changes PRIMARY KEY (id);


--
-- Name: agenda_items pk_agenda_items; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.agenda_items
    ADD CONSTRAINT pk_agenda_items PRIMARY KEY (id);


--
-- Name: attendance_logs pk_attendance_logs; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.attendance_logs
    ADD CONSTRAINT pk_attendance_logs PRIMARY KEY (id);


--
-- Name: committee_meetings pk_committee_meetings; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_meetings
    ADD CONSTRAINT pk_committee_meetings PRIMARY KEY (id);


--
-- Name: committee_member_roles pk_committee_member_roles; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_member_roles
    ADD CONSTRAINT pk_committee_member_roles PRIMARY KEY (id);


--
-- Name: committee_members pk_committee_members; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_members
    ADD CONSTRAINT pk_committee_members PRIMARY KEY (id);


--
-- Name: committee_roles pk_committee_roles; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_roles
    ADD CONSTRAINT pk_committee_roles PRIMARY KEY (id);


--
-- Name: committee_types pk_committee_types; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_types
    ADD CONSTRAINT pk_committee_types PRIMARY KEY (id);


--
-- Name: committees pk_committees; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committees
    ADD CONSTRAINT pk_committees PRIMARY KEY (id);


--
-- Name: ethics_reviews pk_ethics_reviews; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.ethics_reviews
    ADD CONSTRAINT pk_ethics_reviews PRIMARY KEY (id);


--
-- Name: meeting_agendas pk_meeting_agendas; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.meeting_agendas
    ADD CONSTRAINT pk_meeting_agendas PRIMARY KEY (id);


--
-- Name: meeting_minutes pk_meeting_minutes; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.meeting_minutes
    ADD CONSTRAINT pk_meeting_minutes PRIMARY KEY (id);


--
-- Name: member_conflicts pk_member_conflicts; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_conflicts
    ADD CONSTRAINT pk_member_conflicts PRIMARY KEY (id);


--
-- Name: member_qualifications pk_member_qualifications; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_qualifications
    ADD CONSTRAINT pk_member_qualifications PRIMARY KEY (id);


--
-- Name: member_terms pk_member_terms; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_terms
    ADD CONSTRAINT pk_member_terms PRIMARY KEY (id);


--
-- Name: quorum_logs pk_quorum_logs; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.quorum_logs
    ADD CONSTRAINT pk_quorum_logs PRIMARY KEY (id);


--
-- Name: review_answers pk_review_answers; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_answers
    ADD CONSTRAINT pk_review_answers PRIMARY KEY (id);


--
-- Name: review_assignments pk_review_assignments; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_assignments
    ADD CONSTRAINT pk_review_assignments PRIMARY KEY (id);


--
-- Name: review_comments pk_review_comments; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_comments
    ADD CONSTRAINT pk_review_comments PRIMARY KEY (id);


--
-- Name: review_conflicts pk_review_conflicts; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_conflicts
    ADD CONSTRAINT pk_review_conflicts PRIMARY KEY (id);


--
-- Name: review_forms pk_review_forms; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_forms
    ADD CONSTRAINT pk_review_forms PRIMARY KEY (id);


--
-- Name: review_questions pk_review_questions; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_questions
    ADD CONSTRAINT pk_review_questions PRIMARY KEY (id);


--
-- Name: review_recommendations pk_review_recommendations; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_recommendations
    ADD CONSTRAINT pk_review_recommendations PRIMARY KEY (id);


--
-- Name: review_scores pk_review_scores; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_scores
    ADD CONSTRAINT pk_review_scores PRIMARY KEY (id);


--
-- Name: scientific_reviews pk_scientific_reviews; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.scientific_reviews
    ADD CONSTRAINT pk_scientific_reviews PRIMARY KEY (id);


--
-- Name: votes pk_votes; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.votes
    ADD CONSTRAINT pk_votes PRIMARY KEY (id);


--
-- Name: voting_sessions pk_voting_sessions; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.voting_sessions
    ADD CONSTRAINT pk_voting_sessions PRIMARY KEY (id);


--
-- Name: committee_members uq_committee_member; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_members
    ADD CONSTRAINT uq_committee_member UNIQUE (committee_id, user_id);


--
-- Name: committee_member_roles uq_committee_member_role; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_member_roles
    ADD CONSTRAINT uq_committee_member_role UNIQUE (member_id, role_id);


--
-- Name: committee_roles uq_committee_roles_code; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_roles
    ADD CONSTRAINT uq_committee_roles_code UNIQUE (role_code);


--
-- Name: committee_types uq_committee_types_code; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_types
    ADD CONSTRAINT uq_committee_types_code UNIQUE (type_code);


--
-- Name: committees uq_committees_code; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committees
    ADD CONSTRAINT uq_committees_code UNIQUE (committee_code);


--
-- Name: member_conflicts uq_member_conflicts_uuid; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_conflicts
    ADD CONSTRAINT uq_member_conflicts_uuid UNIQUE (uuid);


--
-- Name: member_qualifications uq_member_qualifications_uuid; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_qualifications
    ADD CONSTRAINT uq_member_qualifications_uuid UNIQUE (uuid);


--
-- Name: member_terms uq_member_terms_uuid; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_terms
    ADD CONSTRAINT uq_member_terms_uuid UNIQUE (uuid);


--
-- Name: review_forms uq_review_forms_code; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_forms
    ADD CONSTRAINT uq_review_forms_code UNIQUE (form_code, version_no);


--
-- Name: votes uq_vote_once; Type: CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.votes
    ADD CONSTRAINT uq_vote_once UNIQUE (voting_session_id, voter_id);


--
-- Name: message_attachments message_attachments_pkey; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_attachments
    ADD CONSTRAINT message_attachments_pkey PRIMARY KEY (id);


--
-- Name: message_recipients message_recipients_pkey; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_recipients
    ADD CONSTRAINT message_recipients_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: announcements pk_announcements; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.announcements
    ADD CONSTRAINT pk_announcements PRIMARY KEY (id);


--
-- Name: notification_channels pk_notification_channels; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_channels
    ADD CONSTRAINT pk_notification_channels PRIMARY KEY (id);


--
-- Name: notification_logs pk_notification_logs; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_logs
    ADD CONSTRAINT pk_notification_logs PRIMARY KEY (id);


--
-- Name: notification_templates pk_notification_templates; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_templates
    ADD CONSTRAINT pk_notification_templates PRIMARY KEY (id);


--
-- Name: notifications pk_notifications; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notifications
    ADD CONSTRAINT pk_notifications PRIMARY KEY (id);


--
-- Name: notification_channels uq_notification_channels; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_channels
    ADD CONSTRAINT uq_notification_channels UNIQUE (channel_code);


--
-- Name: notification_templates uq_notification_templates_code; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_templates
    ADD CONSTRAINT uq_notification_templates_code UNIQUE (template_code);


--
-- Name: amendment_requests pk_amendment_requests; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.amendment_requests
    ADD CONSTRAINT pk_amendment_requests PRIMARY KEY (id);


--
-- Name: application_amendments pk_application_amendments; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_amendments
    ADD CONSTRAINT pk_application_amendments PRIMARY KEY (id);


--
-- Name: application_checklists pk_application_checklists; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_checklists
    ADD CONSTRAINT pk_application_checklists PRIMARY KEY (id);


--
-- Name: application_history pk_application_history; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_history
    ADD CONSTRAINT pk_application_history PRIMARY KEY (id);


--
-- Name: application_sections pk_application_sections; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_sections
    ADD CONSTRAINT pk_application_sections PRIMARY KEY (id);


--
-- Name: application_validations pk_application_validations; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_validations
    ADD CONSTRAINT pk_application_validations PRIMARY KEY (id);


--
-- Name: application_versions pk_application_versions; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_versions
    ADD CONSTRAINT pk_application_versions PRIMARY KEY (id);


--
-- Name: applications pk_applications; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.applications
    ADD CONSTRAINT pk_applications PRIMARY KEY (id);


--
-- Name: closure_requests pk_closure_requests; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.closure_requests
    ADD CONSTRAINT pk_closure_requests PRIMARY KEY (id);


--
-- Name: project_attachments pk_project_attachments; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_attachments
    ADD CONSTRAINT pk_project_attachments PRIMARY KEY (id);


--
-- Name: project_funding_sources pk_project_funding_sources; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_funding_sources
    ADD CONSTRAINT pk_project_funding_sources PRIMARY KEY (id);


--
-- Name: project_keywords pk_project_keywords; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_keywords
    ADD CONSTRAINT pk_project_keywords PRIMARY KEY (id);


--
-- Name: project_site_investigators pk_project_site_investigators; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_site_investigators
    ADD CONSTRAINT pk_project_site_investigators PRIMARY KEY (id);


--
-- Name: project_sites pk_project_sites; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_sites
    ADD CONSTRAINT pk_project_sites PRIMARY KEY (id);


--
-- Name: project_status_history pk_project_status_history; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_status_history
    ADD CONSTRAINT pk_project_status_history PRIMARY KEY (id);


--
-- Name: project_tags pk_project_tags; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_tags
    ADD CONSTRAINT pk_project_tags PRIMARY KEY (id);


--
-- Name: project_team_members pk_project_team_members; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_team_members
    ADD CONSTRAINT pk_project_team_members PRIMARY KEY (id);


--
-- Name: project_versions pk_project_versions; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_versions
    ADD CONSTRAINT pk_project_versions PRIMARY KEY (id);


--
-- Name: projects pk_projects; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.projects
    ADD CONSTRAINT pk_projects PRIMARY KEY (id);


--
-- Name: renewal_requests pk_renewal_requests; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.renewal_requests
    ADD CONSTRAINT pk_renewal_requests PRIMARY KEY (id);


--
-- Name: research_categories pk_research_categories; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.research_categories
    ADD CONSTRAINT pk_research_categories PRIMARY KEY (id);


--
-- Name: research_population_links pk_research_population_links; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.research_population_links
    ADD CONSTRAINT pk_research_population_links PRIMARY KEY (id);


--
-- Name: risk_classifications pk_risk_classifications; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.risk_classifications
    ADD CONSTRAINT pk_risk_classifications PRIMARY KEY (id);


--
-- Name: vulnerable_populations pk_vulnerable_populations; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.vulnerable_populations
    ADD CONSTRAINT pk_vulnerable_populations PRIMARY KEY (id);


--
-- Name: application_versions uq_application_versions; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_versions
    ADD CONSTRAINT uq_application_versions UNIQUE (application_id, version_no);


--
-- Name: applications uq_applications_number; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.applications
    ADD CONSTRAINT uq_applications_number UNIQUE (application_number);


--
-- Name: project_team_members uq_project_member; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_team_members
    ADD CONSTRAINT uq_project_member UNIQUE (project_id, user_id);


--
-- Name: project_versions uq_project_version; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_versions
    ADD CONSTRAINT uq_project_version UNIQUE (project_id, version_no);


--
-- Name: projects uq_projects_code; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.projects
    ADD CONSTRAINT uq_projects_code UNIQUE (project_code);


--
-- Name: research_categories uq_research_categories_code; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.research_categories
    ADD CONSTRAINT uq_research_categories_code UNIQUE (code);


--
-- Name: research_population_links uq_research_population_links_uuid; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.research_population_links
    ADD CONSTRAINT uq_research_population_links_uuid UNIQUE (uuid);


--
-- Name: risk_classifications uq_risk_classifications_code; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.risk_classifications
    ADD CONSTRAINT uq_risk_classifications_code UNIQUE (code);


--
-- Name: vulnerable_populations uq_vulnerable_populations_code; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.vulnerable_populations
    ADD CONSTRAINT uq_vulnerable_populations_code UNIQUE (code);


--
-- Name: document_access pk_document_access; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_access
    ADD CONSTRAINT pk_document_access PRIMARY KEY (id);


--
-- Name: document_approvals pk_document_approvals; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_approvals
    ADD CONSTRAINT pk_document_approvals PRIMARY KEY (id);


--
-- Name: document_audit pk_document_audit; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_audit
    ADD CONSTRAINT pk_document_audit PRIMARY KEY (id);


--
-- Name: document_classifications pk_document_classifications; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_classifications
    ADD CONSTRAINT pk_document_classifications PRIMARY KEY (id);


--
-- Name: document_disposal_logs pk_document_disposal_logs; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_disposal_logs
    ADD CONSTRAINT pk_document_disposal_logs PRIMARY KEY (id);


--
-- Name: document_retention_rules pk_document_retention_rules; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_retention_rules
    ADD CONSTRAINT pk_document_retention_rules PRIMARY KEY (id);


--
-- Name: document_signatures pk_document_signatures; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_signatures
    ADD CONSTRAINT pk_document_signatures PRIMARY KEY (id);


--
-- Name: document_types pk_document_types; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_types
    ADD CONSTRAINT pk_document_types PRIMARY KEY (id);


--
-- Name: document_versions pk_document_versions; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_versions
    ADD CONSTRAINT pk_document_versions PRIMARY KEY (id);


--
-- Name: documents pk_documents; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.documents
    ADD CONSTRAINT pk_documents PRIMARY KEY (id);


--
-- Name: generated_documents pk_generated_documents; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.generated_documents
    ADD CONSTRAINT pk_generated_documents PRIMARY KEY (id);


--
-- Name: templates pk_templates; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.templates
    ADD CONSTRAINT pk_templates PRIMARY KEY (id);


--
-- Name: document_classifications uq_document_classifications_code; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_classifications
    ADD CONSTRAINT uq_document_classifications_code UNIQUE (code);


--
-- Name: document_disposal_logs uq_document_disposal_logs_uuid; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_disposal_logs
    ADD CONSTRAINT uq_document_disposal_logs_uuid UNIQUE (uuid);


--
-- Name: document_types uq_document_types_code; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_types
    ADD CONSTRAINT uq_document_types_code UNIQUE (type_code);


--
-- Name: document_versions uq_document_versions; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_versions
    ADD CONSTRAINT uq_document_versions UNIQUE (document_id, version_no);


--
-- Name: templates uq_templates_code_version; Type: CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.templates
    ADD CONSTRAINT uq_templates_code_version UNIQUE (template_code, version_no);


--
-- Name: data_sync_jobs pk_data_sync_jobs; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.data_sync_jobs
    ADD CONSTRAINT pk_data_sync_jobs PRIMARY KEY (id);


--
-- Name: event_bus_config pk_event_bus_config; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.event_bus_config
    ADD CONSTRAINT pk_event_bus_config PRIMARY KEY (id);


--
-- Name: event_outbox pk_event_outbox; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.event_outbox
    ADD CONSTRAINT pk_event_outbox PRIMARY KEY (id);


--
-- Name: event_subscriptions pk_event_subscriptions; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.event_subscriptions
    ADD CONSTRAINT pk_event_subscriptions PRIMARY KEY (id);


--
-- Name: external_systems pk_external_systems; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.external_systems
    ADD CONSTRAINT pk_external_systems PRIMARY KEY (id);


--
-- Name: integration_credentials pk_integration_credentials; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_credentials
    ADD CONSTRAINT pk_integration_credentials PRIMARY KEY (id);


--
-- Name: integration_failures pk_integration_failures; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_failures
    ADD CONSTRAINT pk_integration_failures PRIMARY KEY (id);


--
-- Name: integration_logs pk_integration_logs; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_logs
    ADD CONSTRAINT pk_integration_logs PRIMARY KEY (id);


--
-- Name: retry_queue pk_retry_queue; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.retry_queue
    ADD CONSTRAINT pk_retry_queue PRIMARY KEY (id);


--
-- Name: webhooks pk_webhooks; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.webhooks
    ADD CONSTRAINT pk_webhooks PRIMARY KEY (id);


--
-- Name: data_sync_jobs uq_data_sync_jobs_uuid; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.data_sync_jobs
    ADD CONSTRAINT uq_data_sync_jobs_uuid UNIQUE (uuid);


--
-- Name: event_bus_config uq_event_bus_config_key; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.event_bus_config
    ADD CONSTRAINT uq_event_bus_config_key UNIQUE (config_key);


--
-- Name: event_outbox uq_event_outbox_event_id; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.event_outbox
    ADD CONSTRAINT uq_event_outbox_event_id UNIQUE (event_id);


--
-- Name: external_systems uq_external_systems_code; Type: CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.external_systems
    ADD CONSTRAINT uq_external_systems_code UNIQUE (code);


--
-- Name: compliance_reviews pk_compliance_reviews; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.compliance_reviews
    ADD CONSTRAINT pk_compliance_reviews PRIMARY KEY (id);


--
-- Name: corrective_actions pk_corrective_actions; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.corrective_actions
    ADD CONSTRAINT pk_corrective_actions PRIMARY KEY (id);


--
-- Name: deviations pk_deviations; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.deviations
    ADD CONSTRAINT pk_deviations PRIMARY KEY (id);


--
-- Name: inspection_reports pk_inspection_reports; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.inspection_reports
    ADD CONSTRAINT pk_inspection_reports PRIMARY KEY (id);


--
-- Name: inspections pk_inspections; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.inspections
    ADD CONSTRAINT pk_inspections PRIMARY KEY (id);


--
-- Name: monitoring_findings pk_monitoring_findings; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.monitoring_findings
    ADD CONSTRAINT pk_monitoring_findings PRIMARY KEY (id);


--
-- Name: monitoring_plans pk_monitoring_plans; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.monitoring_plans
    ADD CONSTRAINT pk_monitoring_plans PRIMARY KEY (id);


--
-- Name: monitoring_visits pk_monitoring_visits; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.monitoring_visits
    ADD CONSTRAINT pk_monitoring_visits PRIMARY KEY (id);


--
-- Name: preventive_actions pk_preventive_actions; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.preventive_actions
    ADD CONSTRAINT pk_preventive_actions PRIMARY KEY (id);


--
-- Name: protocol_violations pk_protocol_violations; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.protocol_violations
    ADD CONSTRAINT pk_protocol_violations PRIMARY KEY (id);


--
-- Name: monitoring_plans uq_monitoring_plan_code; Type: CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.monitoring_plans
    ADD CONSTRAINT uq_monitoring_plan_code UNIQUE (plan_code);


--
-- Name: pgmigrations pgmigrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pgmigrations
    ADD CONSTRAINT pgmigrations_pkey PRIMARY KEY (id);


--
-- Name: application_statuses pk_application_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.application_statuses
    ADD CONSTRAINT pk_application_statuses PRIMARY KEY (id);


--
-- Name: committee_decision_types pk_committee_decision_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.committee_decision_types
    ADD CONSTRAINT pk_committee_decision_types PRIMARY KEY (id);


--
-- Name: document_statuses pk_document_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.document_statuses
    ADD CONSTRAINT pk_document_statuses PRIMARY KEY (id);


--
-- Name: institutions_registry pk_institutions_registry; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.institutions_registry
    ADD CONSTRAINT pk_institutions_registry PRIMARY KEY (id);


--
-- Name: licenses_registry pk_licenses_registry; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT pk_licenses_registry PRIMARY KEY (id);


--
-- Name: lookup_categories pk_lookup_categories; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.lookup_categories
    ADD CONSTRAINT pk_lookup_categories PRIMARY KEY (id);


--
-- Name: lookup_values pk_lookup_values; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.lookup_values
    ADD CONSTRAINT pk_lookup_values PRIMARY KEY (id);


--
-- Name: notification_statuses pk_notification_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.notification_statuses
    ADD CONSTRAINT pk_notification_statuses PRIMARY KEY (id);


--
-- Name: priority_levels pk_priority_levels; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.priority_levels
    ADD CONSTRAINT pk_priority_levels PRIMARY KEY (id);


--
-- Name: professions_registry pk_professions_registry; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.professions_registry
    ADD CONSTRAINT pk_professions_registry PRIMARY KEY (id);


--
-- Name: review_statuses pk_review_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.review_statuses
    ADD CONSTRAINT pk_review_statuses PRIMARY KEY (id);


--
-- Name: risk_levels pk_risk_levels; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.risk_levels
    ADD CONSTRAINT pk_risk_levels PRIMARY KEY (id);


--
-- Name: status_types pk_status_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.status_types
    ADD CONSTRAINT pk_status_types PRIMARY KEY (id);


--
-- Name: vote_types pk_vote_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.vote_types
    ADD CONSTRAINT pk_vote_types PRIMARY KEY (id);


--
-- Name: workflow_statuses pk_workflow_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.workflow_statuses
    ADD CONSTRAINT pk_workflow_statuses PRIMARY KEY (id);


--
-- Name: application_statuses uq_application_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.application_statuses
    ADD CONSTRAINT uq_application_statuses UNIQUE (status_code);


--
-- Name: committee_decision_types uq_committee_decision_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.committee_decision_types
    ADD CONSTRAINT uq_committee_decision_types UNIQUE (decision_code);


--
-- Name: document_statuses uq_document_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.document_statuses
    ADD CONSTRAINT uq_document_statuses UNIQUE (status_code);


--
-- Name: institutions_registry uq_institutions_registry_national_id; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.institutions_registry
    ADD CONSTRAINT uq_institutions_registry_national_id UNIQUE (national_id);


--
-- Name: institutions_registry uq_institutions_registry_uuid; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.institutions_registry
    ADD CONSTRAINT uq_institutions_registry_uuid UNIQUE (uuid);


--
-- Name: licenses_registry uq_licenses_registry_license_number; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT uq_licenses_registry_license_number UNIQUE (license_number);


--
-- Name: licenses_registry uq_licenses_registry_uuid; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT uq_licenses_registry_uuid UNIQUE (uuid);


--
-- Name: lookup_categories uq_lookup_categories; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.lookup_categories
    ADD CONSTRAINT uq_lookup_categories UNIQUE (category_code);


--
-- Name: lookup_values uq_lookup_values; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.lookup_values
    ADD CONSTRAINT uq_lookup_values UNIQUE (category_id, value_code);


--
-- Name: notification_statuses uq_notification_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.notification_statuses
    ADD CONSTRAINT uq_notification_statuses UNIQUE (status_code);


--
-- Name: priority_levels uq_priority_levels; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.priority_levels
    ADD CONSTRAINT uq_priority_levels UNIQUE (priority_code);


--
-- Name: professions_registry uq_professions_registry_code; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.professions_registry
    ADD CONSTRAINT uq_professions_registry_code UNIQUE (code);


--
-- Name: review_statuses uq_review_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.review_statuses
    ADD CONSTRAINT uq_review_statuses UNIQUE (status_code);


--
-- Name: risk_levels uq_risk_levels; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.risk_levels
    ADD CONSTRAINT uq_risk_levels UNIQUE (risk_code);


--
-- Name: status_types uq_status_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.status_types
    ADD CONSTRAINT uq_status_types UNIQUE (status_type_code);


--
-- Name: vote_types uq_vote_types; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.vote_types
    ADD CONSTRAINT uq_vote_types UNIQUE (vote_code);


--
-- Name: workflow_statuses uq_workflow_statuses; Type: CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.workflow_statuses
    ADD CONSTRAINT uq_workflow_statuses UNIQUE (status_code);


--
-- Name: analytics_snapshots pk_analytics_snapshots; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.analytics_snapshots
    ADD CONSTRAINT pk_analytics_snapshots PRIMARY KEY (id);


--
-- Name: dashboard_widgets pk_dashboard_widgets; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.dashboard_widgets
    ADD CONSTRAINT pk_dashboard_widgets PRIMARY KEY (id);


--
-- Name: kpi_results pk_kpi_results; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.kpi_results
    ADD CONSTRAINT pk_kpi_results PRIMARY KEY (id);


--
-- Name: report_definitions pk_report_definitions; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.report_definitions
    ADD CONSTRAINT pk_report_definitions PRIMARY KEY (id);


--
-- Name: report_executions pk_report_executions; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.report_executions
    ADD CONSTRAINT pk_report_executions PRIMARY KEY (id);


--
-- Name: dashboard_widgets uq_dashboard_widgets; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.dashboard_widgets
    ADD CONSTRAINT uq_dashboard_widgets UNIQUE (widget_code);


--
-- Name: report_definitions uq_report_definitions; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.report_definitions
    ADD CONSTRAINT uq_report_definitions UNIQUE (report_code);


--
-- Name: adverse_events pk_adverse_events; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.adverse_events
    ADD CONSTRAINT pk_adverse_events PRIMARY KEY (id);


--
-- Name: corrective_actions pk_corrective_actions; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.corrective_actions
    ADD CONSTRAINT pk_corrective_actions PRIMARY KEY (id);


--
-- Name: mitigation_actions pk_mitigation_actions; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.mitigation_actions
    ADD CONSTRAINT pk_mitigation_actions PRIMARY KEY (id);


--
-- Name: risk_assessments pk_risk_assessments; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_assessments
    ADD CONSTRAINT pk_risk_assessments PRIMARY KEY (id);


--
-- Name: risk_categories pk_risk_categories; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_categories
    ADD CONSTRAINT pk_risk_categories PRIMARY KEY (id);


--
-- Name: risk_incidents pk_risk_incidents; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_incidents
    ADD CONSTRAINT pk_risk_incidents PRIMARY KEY (id);


--
-- Name: risk_mitigations pk_risk_mitigations; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_mitigations
    ADD CONSTRAINT pk_risk_mitigations PRIMARY KEY (id);


--
-- Name: risk_register pk_risk_register; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_register
    ADD CONSTRAINT pk_risk_register PRIMARY KEY (id);


--
-- Name: safety_committee_reviews pk_safety_committee_reviews; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_committee_reviews
    ADD CONSTRAINT pk_safety_committee_reviews PRIMARY KEY (id);


--
-- Name: safety_followups pk_safety_followups; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_followups
    ADD CONSTRAINT pk_safety_followups PRIMARY KEY (id);


--
-- Name: safety_reports pk_safety_reports; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_reports
    ADD CONSTRAINT pk_safety_reports PRIMARY KEY (id);


--
-- Name: serious_adverse_events pk_serious_adverse_events; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.serious_adverse_events
    ADD CONSTRAINT pk_serious_adverse_events PRIMARY KEY (id);


--
-- Name: adverse_events uq_adverse_events_number; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.adverse_events
    ADD CONSTRAINT uq_adverse_events_number UNIQUE (event_number);


--
-- Name: corrective_actions uq_corrective_actions_code; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.corrective_actions
    ADD CONSTRAINT uq_corrective_actions_code UNIQUE (action_code);


--
-- Name: corrective_actions uq_corrective_actions_uuid; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.corrective_actions
    ADD CONSTRAINT uq_corrective_actions_uuid UNIQUE (uuid);


--
-- Name: risk_categories uq_risk_categories_code; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_categories
    ADD CONSTRAINT uq_risk_categories_code UNIQUE (category_code);


--
-- Name: risk_incidents uq_risk_incidents_code; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_incidents
    ADD CONSTRAINT uq_risk_incidents_code UNIQUE (incident_code);


--
-- Name: risk_incidents uq_risk_incidents_uuid; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_incidents
    ADD CONSTRAINT uq_risk_incidents_uuid UNIQUE (uuid);


--
-- Name: risk_mitigations uq_risk_mitigations_uuid; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_mitigations
    ADD CONSTRAINT uq_risk_mitigations_uuid UNIQUE (uuid);


--
-- Name: risk_register uq_risk_register_code; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_register
    ADD CONSTRAINT uq_risk_register_code UNIQUE (risk_code);


--
-- Name: risk_register uq_risk_register_uuid; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_register
    ADD CONSTRAINT uq_risk_register_uuid UNIQUE (uuid);


--
-- Name: safety_reports uq_safety_reports_number; Type: CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_reports
    ADD CONSTRAINT uq_safety_reports_number UNIQUE (report_number);


--
-- Name: approval_authorities approval_authorities_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.approval_authorities
    ADD CONSTRAINT approval_authorities_pkey PRIMARY KEY (id);


--
-- Name: approval_limits approval_limits_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.approval_limits
    ADD CONSTRAINT approval_limits_pkey PRIMARY KEY (id);


--
-- Name: certificate_revocations certificate_revocations_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.certificate_revocations
    ADD CONSTRAINT certificate_revocations_pkey PRIMARY KEY (id);


--
-- Name: digital_certificates digital_certificates_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.digital_certificates
    ADD CONSTRAINT digital_certificates_pkey PRIMARY KEY (id);


--
-- Name: digital_certificates digital_certificates_serial_number_key; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.digital_certificates
    ADD CONSTRAINT digital_certificates_serial_number_key UNIQUE (serial_number);


--
-- Name: email_verification_tokens email_verification_tokens_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.email_verification_tokens
    ADD CONSTRAINT email_verification_tokens_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (id);


--
-- Name: access_policies pk_access_policies; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.access_policies
    ADD CONSTRAINT pk_access_policies PRIMARY KEY (id);


--
-- Name: api_keys pk_api_keys; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.api_keys
    ADD CONSTRAINT pk_api_keys PRIMARY KEY (id);


--
-- Name: departments pk_departments; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.departments
    ADD CONSTRAINT pk_departments PRIMARY KEY (id);


--
-- Name: institution_types pk_institution_types; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.institution_types
    ADD CONSTRAINT pk_institution_types PRIMARY KEY (id);


--
-- Name: institutions pk_institutions; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.institutions
    ADD CONSTRAINT pk_institutions PRIMARY KEY (id);


--
-- Name: login_audit pk_login_audit; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.login_audit
    ADD CONSTRAINT pk_login_audit PRIMARY KEY (id);


--
-- Name: password_history pk_password_history; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.password_history
    ADD CONSTRAINT pk_password_history PRIMARY KEY (id);


--
-- Name: permissions pk_permissions; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.permissions
    ADD CONSTRAINT pk_permissions PRIMARY KEY (id);


--
-- Name: responsibility_types pk_responsibility_types; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.responsibility_types
    ADD CONSTRAINT pk_responsibility_types PRIMARY KEY (id);


--
-- Name: role_permissions pk_role_permissions; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.role_permissions
    ADD CONSTRAINT pk_role_permissions PRIMARY KEY (role_id, permission_id);


--
-- Name: roles pk_roles; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.roles
    ADD CONSTRAINT pk_roles PRIMARY KEY (id);


--
-- Name: security_events pk_security_events; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.security_events
    ADD CONSTRAINT pk_security_events PRIMARY KEY (id);


--
-- Name: sessions pk_sessions; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.sessions
    ADD CONSTRAINT pk_sessions PRIMARY KEY (id);


--
-- Name: user_profiles pk_user_profiles; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_profiles
    ADD CONSTRAINT pk_user_profiles PRIMARY KEY (id);


--
-- Name: user_responsibilities pk_user_responsibilities; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT pk_user_responsibilities PRIMARY KEY (id);


--
-- Name: user_roles pk_user_roles; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_roles
    ADD CONSTRAINT pk_user_roles PRIMARY KEY (id);


--
-- Name: users pk_users; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT pk_users PRIMARY KEY (id);


--
-- Name: policy_conditions policy_conditions_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.policy_conditions
    ADD CONSTRAINT policy_conditions_pkey PRIMARY KEY (id);


--
-- Name: policy_rules policy_rules_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.policy_rules
    ADD CONSTRAINT policy_rules_pkey PRIMARY KEY (id);


--
-- Name: role_delegations role_delegations_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.role_delegations
    ADD CONSTRAINT role_delegations_pkey PRIMARY KEY (id);


--
-- Name: segregation_rules segregation_rules_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.segregation_rules
    ADD CONSTRAINT segregation_rules_pkey PRIMARY KEY (id);


--
-- Name: access_policies uq_access_policy_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.access_policies
    ADD CONSTRAINT uq_access_policy_code UNIQUE (policy_code);


--
-- Name: departments uq_departments_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.departments
    ADD CONSTRAINT uq_departments_code UNIQUE (institution_id, code);


--
-- Name: institution_types uq_institution_types_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.institution_types
    ADD CONSTRAINT uq_institution_types_code UNIQUE (code);


--
-- Name: institutions uq_institutions_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.institutions
    ADD CONSTRAINT uq_institutions_code UNIQUE (code);


--
-- Name: permissions uq_permissions_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.permissions
    ADD CONSTRAINT uq_permissions_code UNIQUE (permission_code);


--
-- Name: responsibility_types uq_responsibility_types_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.responsibility_types
    ADD CONSTRAINT uq_responsibility_types_code UNIQUE (code);


--
-- Name: roles uq_roles_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.roles
    ADD CONSTRAINT uq_roles_code UNIQUE (code);


--
-- Name: sessions uq_session_token; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.sessions
    ADD CONSTRAINT uq_session_token UNIQUE (session_token);


--
-- Name: user_profiles uq_user_profiles_user; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_profiles
    ADD CONSTRAINT uq_user_profiles_user UNIQUE (user_id);


--
-- Name: user_responsibilities uq_user_responsibilities_uuid; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT uq_user_responsibilities_uuid UNIQUE (uuid);


--
-- Name: user_roles uq_user_role; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_roles
    ADD CONSTRAINT uq_user_role UNIQUE (user_id, role_id);


--
-- Name: users uq_users_email; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT uq_users_email UNIQUE (email);


--
-- Name: users uq_users_username; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT uq_users_username UNIQUE (username);


--
-- Name: users uq_users_uuid; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT uq_users_uuid UNIQUE (uuid);


--
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- Name: business_rules business_rules_code_key; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.business_rules
    ADD CONSTRAINT business_rules_code_key UNIQUE (code);


--
-- Name: business_rules business_rules_pkey; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.business_rules
    ADD CONSTRAINT business_rules_pkey PRIMARY KEY (id);


--
-- Name: feature_flags feature_flags_code_key; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.feature_flags
    ADD CONSTRAINT feature_flags_code_key UNIQUE (code);


--
-- Name: feature_flags feature_flags_pkey; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.feature_flags
    ADD CONSTRAINT feature_flags_pkey PRIMARY KEY (id);


--
-- Name: audit_config pk_audit_config; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.audit_config
    ADD CONSTRAINT pk_audit_config PRIMARY KEY (id);


--
-- Name: email_config pk_email_config; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.email_config
    ADD CONSTRAINT pk_email_config PRIMARY KEY (id);


--
-- Name: maintenance_log pk_maintenance_log; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.maintenance_log
    ADD CONSTRAINT pk_maintenance_log PRIMARY KEY (id);


--
-- Name: rule_actions pk_rule_actions; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_actions
    ADD CONSTRAINT pk_rule_actions PRIMARY KEY (id);


--
-- Name: rule_conditions pk_rule_conditions; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_conditions
    ADD CONSTRAINT pk_rule_conditions PRIMARY KEY (id);


--
-- Name: rule_executions pk_rule_executions; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_executions
    ADD CONSTRAINT pk_rule_executions PRIMARY KEY (id);


--
-- Name: saved_searches pk_saved_searches; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.saved_searches
    ADD CONSTRAINT pk_saved_searches PRIMARY KEY (id);


--
-- Name: search_audit pk_search_audit; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.search_audit
    ADD CONSTRAINT pk_search_audit PRIMARY KEY (id);


--
-- Name: search_indexes pk_search_indexes; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.search_indexes
    ADD CONSTRAINT pk_search_indexes PRIMARY KEY (id);


--
-- Name: sms_config pk_sms_config; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.sms_config
    ADD CONSTRAINT pk_sms_config PRIMARY KEY (id);


--
-- Name: system_config pk_system_config; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.system_config
    ADD CONSTRAINT pk_system_config PRIMARY KEY (id);


--
-- Name: rule_versions rule_versions_pkey; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_versions
    ADD CONSTRAINT rule_versions_pkey PRIMARY KEY (id);


--
-- Name: audit_config uq_audit_config_entity; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.audit_config
    ADD CONSTRAINT uq_audit_config_entity UNIQUE (entity_name);


--
-- Name: saved_searches uq_saved_searches_uuid; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.saved_searches
    ADD CONSTRAINT uq_saved_searches_uuid UNIQUE (uuid);


--
-- Name: system_config uq_system_config_key; Type: CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.system_config
    ADD CONSTRAINT uq_system_config_key UNIQUE (config_key);


--
-- Name: workflow_actions pk_workflow_actions; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_actions
    ADD CONSTRAINT pk_workflow_actions PRIMARY KEY (id);


--
-- Name: workflow_comments pk_workflow_comments; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_comments
    ADD CONSTRAINT pk_workflow_comments PRIMARY KEY (id);


--
-- Name: workflow_escalations pk_workflow_escalations; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_escalations
    ADD CONSTRAINT pk_workflow_escalations PRIMARY KEY (id);


--
-- Name: workflow_events pk_workflow_events; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_events
    ADD CONSTRAINT pk_workflow_events PRIMARY KEY (id);


--
-- Name: workflow_history pk_workflow_history; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_history
    ADD CONSTRAINT pk_workflow_history PRIMARY KEY (id);


--
-- Name: workflow_instances pk_workflow_instances; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_instances
    ADD CONSTRAINT pk_workflow_instances PRIMARY KEY (id);


--
-- Name: workflow_schedulers pk_workflow_schedulers; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_schedulers
    ADD CONSTRAINT pk_workflow_schedulers PRIMARY KEY (id);


--
-- Name: workflow_sla pk_workflow_sla; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_sla
    ADD CONSTRAINT pk_workflow_sla PRIMARY KEY (id);


--
-- Name: workflow_states pk_workflow_states; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_states
    ADD CONSTRAINT pk_workflow_states PRIMARY KEY (id);


--
-- Name: workflow_tasks pk_workflow_tasks; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_tasks
    ADD CONSTRAINT pk_workflow_tasks PRIMARY KEY (id);


--
-- Name: workflow_transitions pk_workflow_transitions; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_transitions
    ADD CONSTRAINT pk_workflow_transitions PRIMARY KEY (id);


--
-- Name: workflow_triggers pk_workflow_triggers; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_triggers
    ADD CONSTRAINT pk_workflow_triggers PRIMARY KEY (id);


--
-- Name: workflow_variables pk_workflow_variables; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_variables
    ADD CONSTRAINT pk_workflow_variables PRIMARY KEY (id);


--
-- Name: workflows pk_workflows; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflows
    ADD CONSTRAINT pk_workflows PRIMARY KEY (id);


--
-- Name: workflow_events uq_workflow_events_uuid; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_events
    ADD CONSTRAINT uq_workflow_events_uuid UNIQUE (uuid);


--
-- Name: workflow_schedulers uq_workflow_schedulers_code; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_schedulers
    ADD CONSTRAINT uq_workflow_schedulers_code UNIQUE (code);


--
-- Name: workflow_states uq_workflow_state; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_states
    ADD CONSTRAINT uq_workflow_state UNIQUE (workflow_id, state_code);


--
-- Name: workflow_triggers uq_workflow_triggers_code; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_triggers
    ADD CONSTRAINT uq_workflow_triggers_code UNIQUE (code);


--
-- Name: workflows uq_workflows_code_version; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflows
    ADD CONSTRAINT uq_workflows_code_version UNIQUE (workflow_code, version_no);


--
-- Name: idx_audit_details_log; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_details_log ON audit.audit_details USING btree (audit_log_id);


--
-- Name: idx_audit_logs_entity; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_logs_entity ON audit.audit_logs USING btree (entity_name, entity_id);


--
-- Name: idx_audit_logs_entity_timestamp; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_logs_entity_timestamp ON audit.audit_logs USING btree (entity_name, event_timestamp DESC);


--
-- Name: idx_audit_logs_new_values; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_logs_new_values ON audit.audit_logs USING gin (new_values);


--
-- Name: idx_audit_logs_old_values; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_logs_old_values ON audit.audit_logs USING gin (old_values);


--
-- Name: idx_audit_logs_timestamp; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_audit_logs_timestamp ON audit.audit_logs USING btree (event_timestamp);


--
-- Name: idx_entity_changes_entity; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_entity_changes_entity ON audit.entity_changes USING btree (entity_name, entity_id);


--
-- Name: idx_entity_changes_json; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX idx_entity_changes_json ON audit.entity_changes USING gin (details);


--
-- Name: idx_agenda_items_agenda; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_agenda_items_agenda ON committee.agenda_items USING btree (agenda_id);


--
-- Name: idx_attendance_logs_meeting; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_attendance_logs_meeting ON committee.attendance_logs USING btree (meeting_id);


--
-- Name: idx_attendance_logs_user; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_attendance_logs_user ON committee.attendance_logs USING btree (user_id);


--
-- Name: idx_committee_meetings_committee; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_committee_meetings_committee ON committee.committee_meetings USING btree (committee_id);


--
-- Name: idx_committee_meetings_date; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_committee_meetings_date ON committee.committee_meetings USING btree (meeting_date);


--
-- Name: idx_committee_member_roles_member; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_committee_member_roles_member ON committee.committee_member_roles USING btree (member_id);


--
-- Name: idx_committee_member_roles_role; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_committee_member_roles_role ON committee.committee_member_roles USING btree (role_id);


--
-- Name: idx_committee_members_committee; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_committee_members_committee ON committee.committee_members USING btree (committee_id);


--
-- Name: idx_committees_active; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_committees_active ON committee.committees USING btree (id) WHERE (deleted_at IS NULL);


--
-- Name: idx_committees_institution; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_committees_institution ON committee.committees USING btree (institution_id);


--
-- Name: idx_ethics_reviews_active; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_ethics_reviews_active ON committee.ethics_reviews USING btree (id) WHERE (deleted_at IS NULL);


--
-- Name: idx_ethics_reviews_application; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_ethics_reviews_application ON committee.ethics_reviews USING btree (application_id);


--
-- Name: idx_ethics_reviews_reviewer; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_ethics_reviews_reviewer ON committee.ethics_reviews USING btree (reviewer_id);


--
-- Name: idx_meeting_agendas_meeting; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_meeting_agendas_meeting ON committee.meeting_agendas USING btree (meeting_id);


--
-- Name: idx_meeting_minutes_meeting; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_meeting_minutes_meeting ON committee.meeting_minutes USING btree (meeting_id);


--
-- Name: idx_member_conflicts_entity; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_member_conflicts_entity ON committee.member_conflicts USING btree (entity_type, entity_id);


--
-- Name: idx_member_conflicts_member; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_member_conflicts_member ON committee.member_conflicts USING btree (member_id);


--
-- Name: idx_quorum_logs_meeting; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_quorum_logs_meeting ON committee.quorum_logs USING btree (meeting_id);


--
-- Name: idx_review_answers_question; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_answers_question ON committee.review_answers USING btree (question_id);


--
-- Name: idx_review_assignments_application; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_assignments_application ON committee.review_assignments USING btree (application_id);


--
-- Name: idx_review_assignments_reviewer; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_assignments_reviewer ON committee.review_assignments USING btree (reviewer_id);


--
-- Name: idx_review_comments_application; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_comments_application ON committee.review_comments USING btree (application_id);


--
-- Name: idx_review_conflicts_application; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_conflicts_application ON committee.review_conflicts USING btree (application_id);


--
-- Name: idx_review_conflicts_reviewer; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_conflicts_reviewer ON committee.review_conflicts USING btree (reviewer_id);


--
-- Name: idx_review_questions_form; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_questions_form ON committee.review_questions USING btree (form_id);


--
-- Name: idx_review_recommendations_application; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_recommendations_application ON committee.review_recommendations USING btree (application_id);


--
-- Name: idx_review_scores_application; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_review_scores_application ON committee.review_scores USING btree (application_id);


--
-- Name: idx_scientific_reviews_active; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_scientific_reviews_active ON committee.scientific_reviews USING btree (id) WHERE (deleted_at IS NULL);


--
-- Name: idx_scientific_reviews_application; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_scientific_reviews_application ON committee.scientific_reviews USING btree (application_id);


--
-- Name: idx_scientific_reviews_reviewer; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_scientific_reviews_reviewer ON committee.scientific_reviews USING btree (reviewer_id);


--
-- Name: idx_votes_session; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_votes_session ON committee.votes USING btree (voting_session_id);


--
-- Name: idx_voting_sessions_meeting; Type: INDEX; Schema: committee; Owner: -
--

CREATE INDEX idx_voting_sessions_meeting ON committee.voting_sessions USING btree (meeting_id);


--
-- Name: idx_announcements_active; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_announcements_active ON communication.announcements USING btree (is_active);


--
-- Name: idx_messages_sender; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_messages_sender ON communication.messages USING btree (sender_id, is_deleted);


--
-- Name: idx_msg_attachments_message; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_msg_attachments_message ON communication.message_attachments USING btree (message_id);


--
-- Name: idx_msg_recipients_message; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_msg_recipients_message ON communication.message_recipients USING btree (message_id);


--
-- Name: idx_msg_recipients_recipient; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_msg_recipients_recipient ON communication.message_recipients USING btree (recipient_id, is_deleted);


--
-- Name: idx_notification_logs_notification; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notification_logs_notification ON communication.notification_logs USING btree (notification_id);


--
-- Name: idx_notifications_active; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notifications_active ON communication.notifications USING btree (id) WHERE (deleted_at IS NULL);


--
-- Name: idx_notifications_read; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notifications_read ON communication.notifications USING btree (is_read);


--
-- Name: idx_notifications_user; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notifications_user ON communication.notifications USING btree (user_id);


--
-- Name: idx_amendment_requests_status; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_amendment_requests_status ON core.amendment_requests USING btree (request_status);


--
-- Name: idx_application_amendments_application; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_application_amendments_application ON core.application_amendments USING btree (application_id);


--
-- Name: idx_application_checklists_application; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_application_checklists_application ON core.application_checklists USING btree (application_id);


--
-- Name: idx_application_history_action_at; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_application_history_action_at ON core.application_history USING btree (action_at);


--
-- Name: idx_application_history_application; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_application_history_application ON core.application_history USING btree (application_id);


--
-- Name: idx_application_sections_application; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_application_sections_application ON core.application_sections USING btree (application_id);


--
-- Name: idx_application_validations_application; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_application_validations_application ON core.application_validations USING btree (application_id);


--
-- Name: idx_application_versions_application; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_application_versions_application ON core.application_versions USING btree (application_id);


--
-- Name: idx_applications_active; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_active ON core.applications USING btree (id) WHERE (deleted_at IS NULL);


--
-- Name: idx_applications_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_project ON core.applications USING btree (project_id);


--
-- Name: idx_applications_status; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_status ON core.applications USING btree (current_status);


--
-- Name: idx_applications_submission_date; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_submission_date ON core.applications USING btree (submission_date);


--
-- Name: idx_closure_requests_application; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_closure_requests_application ON core.closure_requests USING btree (application_id);


--
-- Name: idx_project_attachments_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_project_attachments_project ON core.project_attachments USING btree (project_id);


--
-- Name: idx_project_funding_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_project_funding_project ON core.project_funding_sources USING btree (project_id);


--
-- Name: idx_project_keywords_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_project_keywords_project ON core.project_keywords USING btree (project_id);


--
-- Name: idx_project_sites_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_project_sites_project ON core.project_sites USING btree (project_id);


--
-- Name: idx_project_status_history_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_project_status_history_project ON core.project_status_history USING btree (project_id);


--
-- Name: idx_project_tags_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_project_tags_project ON core.project_tags USING btree (project_id);


--
-- Name: idx_project_team_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_project_team_project ON core.project_team_members USING btree (project_id);


--
-- Name: idx_project_versions_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_project_versions_project ON core.project_versions USING btree (project_id);


--
-- Name: idx_projects_active; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_projects_active ON core.projects USING btree (id) WHERE (deleted_at IS NULL);


--
-- Name: idx_projects_institution; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_projects_institution ON core.projects USING btree (institution_id);


--
-- Name: idx_projects_pi; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_projects_pi ON core.projects USING btree (principal_investigator_id);


--
-- Name: idx_projects_status; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_projects_status ON core.projects USING btree (status_code);


--
-- Name: idx_renewal_requests_application; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_renewal_requests_application ON core.renewal_requests USING btree (application_id);


--
-- Name: idx_research_population_links_project; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_research_population_links_project ON core.research_population_links USING btree (project_id);


--
-- Name: idx_site_investigator_site; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_site_investigator_site ON core.project_site_investigators USING btree (site_id);


--
-- Name: idx_document_access_document; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_document_access_document ON documents.document_access USING btree (document_id);


--
-- Name: idx_document_access_user; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_document_access_user ON documents.document_access USING btree (user_id);


--
-- Name: idx_document_approvals_document; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_document_approvals_document ON documents.document_approvals USING btree (document_id);


--
-- Name: idx_document_audit_details; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_document_audit_details ON documents.document_audit USING gin (details);


--
-- Name: idx_document_audit_document; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_document_audit_document ON documents.document_audit USING btree (document_id);


--
-- Name: idx_document_signatures_document; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_document_signatures_document ON documents.document_signatures USING btree (document_id);


--
-- Name: idx_document_types_code; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_document_types_code ON documents.document_types USING btree (type_code);


--
-- Name: idx_document_versions_document; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_document_versions_document ON documents.document_versions USING btree (document_id);


--
-- Name: idx_documents_active; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_documents_active ON documents.documents USING btree (is_active);


--
-- Name: idx_documents_entity; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_documents_entity ON documents.documents USING btree (entity_type, entity_id);


--
-- Name: idx_documents_type; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_documents_type ON documents.documents USING btree (document_type_id);


--
-- Name: idx_generated_documents_entity; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_generated_documents_entity ON documents.generated_documents USING btree (entity_type, entity_id);


--
-- Name: idx_generated_documents_parameters; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_generated_documents_parameters ON documents.generated_documents USING gin (generation_parameters);


--
-- Name: idx_templates_type; Type: INDEX; Schema: documents; Owner: -
--

CREATE INDEX idx_templates_type ON documents.templates USING btree (template_type);


--
-- Name: idx_data_sync_jobs_status; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_data_sync_jobs_status ON integration.data_sync_jobs USING btree (status);


--
-- Name: idx_data_sync_jobs_system; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_data_sync_jobs_system ON integration.data_sync_jobs USING btree (external_system_id);


--
-- Name: idx_event_outbox_created; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_event_outbox_created ON integration.event_outbox USING btree (created_at);


--
-- Name: idx_event_outbox_event_data; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_event_outbox_event_data ON integration.event_outbox USING gin (event_data);


--
-- Name: idx_event_outbox_status; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_event_outbox_status ON integration.event_outbox USING btree (status);


--
-- Name: idx_event_outbox_type; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_event_outbox_type ON integration.event_outbox USING btree (event_type);


--
-- Name: idx_event_subscriptions_event_type; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_event_subscriptions_event_type ON integration.event_subscriptions USING btree (event_type);


--
-- Name: idx_integration_logs_created; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_integration_logs_created ON integration.integration_logs USING btree (created_at);


--
-- Name: idx_integration_logs_status; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_integration_logs_status ON integration.integration_logs USING btree (status);


--
-- Name: idx_integration_logs_type; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_integration_logs_type ON integration.integration_logs USING btree (integration_type);


--
-- Name: idx_retry_queue_next_retry; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_retry_queue_next_retry ON integration.retry_queue USING btree (next_retry_at);


--
-- Name: idx_retry_queue_status; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_retry_queue_status ON integration.retry_queue USING btree (status);


--
-- Name: idx_webhooks_active; Type: INDEX; Schema: integration; Owner: -
--

CREATE INDEX idx_webhooks_active ON integration.webhooks USING btree (is_active);


--
-- Name: idx_compliance_reviews_application; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_compliance_reviews_application ON monitoring.compliance_reviews USING btree (application_id);


--
-- Name: idx_corrective_actions_finding; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_corrective_actions_finding ON monitoring.corrective_actions USING btree (finding_id);


--
-- Name: idx_deviations_application; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_deviations_application ON monitoring.deviations USING btree (application_id);


--
-- Name: idx_inspection_reports_inspection; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_inspection_reports_inspection ON monitoring.inspection_reports USING btree (inspection_id);


--
-- Name: idx_inspections_application; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_inspections_application ON monitoring.inspections USING btree (application_id);


--
-- Name: idx_monitoring_findings_visit; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_monitoring_findings_visit ON monitoring.monitoring_findings USING btree (monitoring_visit_id);


--
-- Name: idx_monitoring_plans_application; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_monitoring_plans_application ON monitoring.monitoring_plans USING btree (application_id);


--
-- Name: idx_monitoring_visits_plan; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_monitoring_visits_plan ON monitoring.monitoring_visits USING btree (monitoring_plan_id);


--
-- Name: idx_preventive_actions_finding; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_preventive_actions_finding ON monitoring.preventive_actions USING btree (finding_id);


--
-- Name: idx_protocol_violations_application; Type: INDEX; Schema: monitoring; Owner: -
--

CREATE INDEX idx_protocol_violations_application ON monitoring.protocol_violations USING btree (application_id);


--
-- Name: idx_licenses_registry_user; Type: INDEX; Schema: reference; Owner: -
--

CREATE INDEX idx_licenses_registry_user ON reference.licenses_registry USING btree (user_id);


--
-- Name: idx_licenses_registry_verification; Type: INDEX; Schema: reference; Owner: -
--

CREATE INDEX idx_licenses_registry_verification ON reference.licenses_registry USING btree (verification_status);


--
-- Name: idx_lookup_categories_active; Type: INDEX; Schema: reference; Owner: -
--

CREATE INDEX idx_lookup_categories_active ON reference.lookup_categories USING btree (is_active);


--
-- Name: idx_lookup_values_category; Type: INDEX; Schema: reference; Owner: -
--

CREATE INDEX idx_lookup_values_category ON reference.lookup_values USING btree (category_id);


--
-- Name: idx_analytics_snapshots_json; Type: INDEX; Schema: reporting; Owner: -
--

CREATE INDEX idx_analytics_snapshots_json ON reporting.analytics_snapshots USING gin (metrics);


--
-- Name: idx_dashboard_widgets_json; Type: INDEX; Schema: reporting; Owner: -
--

CREATE INDEX idx_dashboard_widgets_json ON reporting.dashboard_widgets USING gin (configuration);


--
-- Name: idx_kpi_results_code; Type: INDEX; Schema: reporting; Owner: -
--

CREATE INDEX idx_kpi_results_code ON reporting.kpi_results USING btree (kpi_code);


--
-- Name: idx_mv_committee_perf; Type: INDEX; Schema: reporting; Owner: -
--

CREATE UNIQUE INDEX idx_mv_committee_perf ON reporting.mv_committee_performance USING btree (committee_id, month);


--
-- Name: idx_mv_daily_snapshot; Type: INDEX; Schema: reporting; Owner: -
--

CREATE UNIQUE INDEX idx_mv_daily_snapshot ON reporting.mv_daily_application_snapshot USING btree (snapshot_date, current_status);


--
-- Name: idx_report_executions_report; Type: INDEX; Schema: reporting; Owner: -
--

CREATE INDEX idx_report_executions_report ON reporting.report_executions USING btree (report_id);


--
-- Name: idx_adverse_events_active; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_adverse_events_active ON safety.adverse_events USING btree (id) WHERE (deleted_at IS NULL);


--
-- Name: idx_adverse_events_application; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_adverse_events_application ON safety.adverse_events USING btree (application_id);


--
-- Name: idx_adverse_events_date; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_adverse_events_date ON safety.adverse_events USING btree (event_date);


--
-- Name: idx_corrective_actions_incident; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_corrective_actions_incident ON safety.corrective_actions USING btree (incident_id);


--
-- Name: idx_mitigation_actions_assessment; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_mitigation_actions_assessment ON safety.mitigation_actions USING btree (risk_assessment_id);


--
-- Name: idx_risk_assessments_application; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_risk_assessments_application ON safety.risk_assessments USING btree (application_id);


--
-- Name: idx_risk_incidents_risk; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_risk_incidents_risk ON safety.risk_incidents USING btree (risk_id);


--
-- Name: idx_risk_mitigations_risk; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_risk_mitigations_risk ON safety.risk_mitigations USING btree (risk_id);


--
-- Name: idx_risk_register_owner; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_risk_register_owner ON safety.risk_register USING btree (owner_id);


--
-- Name: idx_risk_register_status; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_risk_register_status ON safety.risk_register USING btree (status);


--
-- Name: idx_safety_committee_reviews_application; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_safety_committee_reviews_application ON safety.safety_committee_reviews USING btree (application_id);


--
-- Name: idx_safety_committee_reviews_committee; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_safety_committee_reviews_committee ON safety.safety_committee_reviews USING btree (committee_id);


--
-- Name: idx_safety_followups_event; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_safety_followups_event ON safety.safety_followups USING btree (adverse_event_id);


--
-- Name: idx_safety_reports_application; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_safety_reports_application ON safety.safety_reports USING btree (application_id);


--
-- Name: idx_serious_adverse_events_event; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_serious_adverse_events_event ON safety.serious_adverse_events USING btree (adverse_event_id);


--
-- Name: idx_access_policy_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_access_policy_active ON security.access_policies USING btree (is_active);


--
-- Name: idx_access_policy_expression; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_access_policy_expression ON security.access_policies USING gin (policy_expression);


--
-- Name: idx_api_keys_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_api_keys_active ON security.api_keys USING btree (is_active);


--
-- Name: idx_api_keys_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_api_keys_user ON security.api_keys USING btree (user_id);


--
-- Name: idx_departments_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_departments_active ON security.departments USING btree (is_active);


--
-- Name: idx_departments_institution; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_departments_institution ON security.departments USING btree (institution_id);


--
-- Name: idx_email_verif_tokens_hash; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_email_verif_tokens_hash ON security.email_verification_tokens USING btree (token_hash);


--
-- Name: idx_email_verif_tokens_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_email_verif_tokens_user ON security.email_verification_tokens USING btree (user_id);


--
-- Name: idx_institution_types_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_institution_types_active ON security.institution_types USING btree (is_active);


--
-- Name: idx_institution_types_name_ar; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_institution_types_name_ar ON security.institution_types USING btree (name_ar);


--
-- Name: idx_institutions_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_institutions_active ON security.institutions USING btree (is_active);


--
-- Name: idx_institutions_name_ar; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_institutions_name_ar ON security.institutions USING btree (name_ar);


--
-- Name: idx_institutions_type; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_institutions_type ON security.institutions USING btree (institution_type_id);


--
-- Name: idx_login_audit_success; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_login_audit_success ON security.login_audit USING btree (success);


--
-- Name: idx_login_audit_time; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_login_audit_time ON security.login_audit USING btree (login_time DESC);


--
-- Name: idx_password_history_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_password_history_user ON security.password_history USING btree (user_id);


--
-- Name: idx_password_reset_tokens_expires; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_password_reset_tokens_expires ON security.password_reset_tokens USING btree (expires_at);


--
-- Name: idx_password_reset_tokens_user_id; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_password_reset_tokens_user_id ON security.password_reset_tokens USING btree (user_id);


--
-- Name: idx_permissions_module; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_permissions_module ON security.permissions USING btree (module_name);


--
-- Name: idx_role_permissions_permission; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_role_permissions_permission ON security.role_permissions USING btree (permission_id);


--
-- Name: idx_roles_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_roles_active ON security.roles USING btree (is_active);


--
-- Name: idx_security_events_details; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_security_events_details ON security.security_events USING gin (details);


--
-- Name: idx_security_events_severity; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_security_events_severity ON security.security_events USING btree (severity);


--
-- Name: idx_security_events_time; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_security_events_time ON security.security_events USING btree (event_time DESC);


--
-- Name: idx_sessions_expiry; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_sessions_expiry ON security.sessions USING btree (expires_at);


--
-- Name: idx_sessions_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_sessions_user ON security.sessions USING btree (user_id);


--
-- Name: idx_user_profiles_national_id; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_profiles_national_id ON security.user_profiles USING btree (national_id);


--
-- Name: idx_user_profiles_specialization; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_profiles_specialization ON security.user_profiles USING btree (specialization);


--
-- Name: idx_user_responsibilities_entity; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_responsibilities_entity ON security.user_responsibilities USING btree (entity_type, entity_id);


--
-- Name: idx_user_responsibilities_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_responsibilities_user ON security.user_responsibilities USING btree (user_id);


--
-- Name: idx_user_roles_role; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_roles_role ON security.user_roles USING btree (role_id);


--
-- Name: idx_user_roles_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_roles_user ON security.user_roles USING btree (user_id);


--
-- Name: idx_users_department; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_users_department ON security.users USING btree (department_id);


--
-- Name: idx_users_institution; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_users_institution ON security.users USING btree (institution_id);


--
-- Name: idx_users_last_login; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_users_last_login ON security.users USING btree (last_login_at);


--
-- Name: idx_users_status; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_users_status ON security.users USING btree (status);


--
-- Name: idx_audit_log_action; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_audit_log_action ON system.audit_log USING btree (action_type);


--
-- Name: idx_audit_log_created; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_audit_log_created ON system.audit_log USING btree (created_at DESC);


--
-- Name: idx_audit_log_entity; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_audit_log_entity ON system.audit_log USING btree (entity_type, entity_id);


--
-- Name: idx_audit_log_user; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_audit_log_user ON system.audit_log USING btree (user_id);


--
-- Name: idx_maintenance_log_started; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_maintenance_log_started ON system.maintenance_log USING btree (started_at);


--
-- Name: idx_maintenance_log_status; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_maintenance_log_status ON system.maintenance_log USING btree (status);


--
-- Name: idx_rule_actions_rule; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_rule_actions_rule ON system.rule_actions USING btree (rule_id);


--
-- Name: idx_rule_conditions_rule; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_rule_conditions_rule ON system.rule_conditions USING btree (rule_id);


--
-- Name: idx_rule_executions_entity; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_rule_executions_entity ON system.rule_executions USING btree (entity_type, entity_id);


--
-- Name: idx_rule_executions_rule; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_rule_executions_rule ON system.rule_executions USING btree (rule_id);


--
-- Name: idx_search_audit_created; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_search_audit_created ON system.search_audit USING btree (created_at);


--
-- Name: idx_search_audit_user; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_search_audit_user ON system.search_audit USING btree (user_id);


--
-- Name: idx_search_indexes_entity; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_search_indexes_entity ON system.search_indexes USING btree (entity_type, entity_id);


--
-- Name: idx_search_indexes_vector; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_search_indexes_vector ON system.search_indexes USING gin (search_vector);


--
-- Name: idx_system_config_group; Type: INDEX; Schema: system; Owner: -
--

CREATE INDEX idx_system_config_group ON system.system_config USING btree (config_group);


--
-- Name: idx_workflow_actions_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_actions_instance ON workflow.workflow_actions USING btree (workflow_instance_id);


--
-- Name: idx_workflow_comments_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_comments_instance ON workflow.workflow_comments USING btree (workflow_instance_id);


--
-- Name: idx_workflow_escalations_task; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_escalations_task ON workflow.workflow_escalations USING btree (workflow_task_id);


--
-- Name: idx_workflow_events_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_events_instance ON workflow.workflow_events USING btree (workflow_instance_id);


--
-- Name: idx_workflow_events_type; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_events_type ON workflow.workflow_events USING btree (event_type);


--
-- Name: idx_workflow_history_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_history_instance ON workflow.workflow_history USING btree (workflow_instance_id);


--
-- Name: idx_workflow_instances_active; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_instances_active ON workflow.workflow_instances USING btree (id) WHERE (deleted_at IS NULL);


--
-- Name: idx_workflow_instances_entity; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_instances_entity ON workflow.workflow_instances USING btree (entity_type, entity_id);


--
-- Name: idx_workflow_instances_state; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_instances_state ON workflow.workflow_instances USING btree (current_state_id);


--
-- Name: idx_workflow_sla_workflow; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_sla_workflow ON workflow.workflow_sla USING btree (workflow_id);


--
-- Name: idx_workflow_states_workflow; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_states_workflow ON workflow.workflow_states USING btree (workflow_id);


--
-- Name: idx_workflow_tasks_active; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_tasks_active ON workflow.workflow_tasks USING btree (id) WHERE (deleted_at IS NULL);


--
-- Name: idx_workflow_tasks_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_tasks_instance ON workflow.workflow_tasks USING btree (workflow_instance_id);


--
-- Name: idx_workflow_tasks_user; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_tasks_user ON workflow.workflow_tasks USING btree (assigned_to);


--
-- Name: idx_workflow_transitions_workflow; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_transitions_workflow ON workflow.workflow_transitions USING btree (workflow_id);


--
-- Name: idx_workflow_triggers_event; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_triggers_event ON workflow.workflow_triggers USING btree (trigger_event);


--
-- Name: idx_workflow_variables_instance; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_variables_instance ON workflow.workflow_variables USING btree (workflow_instance_id);


--
-- Name: idx_workflow_variables_json; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflow_variables_json ON workflow.workflow_variables USING gin (variable_value);


--
-- Name: idx_workflows_entity; Type: INDEX; Schema: workflow; Owner: -
--

CREATE INDEX idx_workflows_entity ON workflow.workflows USING btree (entity_type);


--
-- Name: agenda_items trigger_audit_agenda_items; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_agenda_items AFTER INSERT OR DELETE OR UPDATE ON committee.agenda_items FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: attendance_logs trigger_audit_attendance_logs; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_attendance_logs AFTER INSERT OR DELETE OR UPDATE ON committee.attendance_logs FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: committee_meetings trigger_audit_committee_meetings; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_committee_meetings AFTER INSERT OR DELETE OR UPDATE ON committee.committee_meetings FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: committee_member_roles trigger_audit_committee_member_roles; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_committee_member_roles AFTER INSERT OR DELETE OR UPDATE ON committee.committee_member_roles FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: committee_members trigger_audit_committee_members; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_committee_members AFTER INSERT OR DELETE OR UPDATE ON committee.committee_members FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: committee_roles trigger_audit_committee_roles; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_committee_roles AFTER INSERT OR DELETE OR UPDATE ON committee.committee_roles FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: committee_types trigger_audit_committee_types; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_committee_types AFTER INSERT OR DELETE OR UPDATE ON committee.committee_types FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: committees trigger_audit_committees; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_committees AFTER INSERT OR DELETE OR UPDATE ON committee.committees FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: ethics_reviews trigger_audit_ethics_reviews; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_ethics_reviews AFTER INSERT OR DELETE OR UPDATE ON committee.ethics_reviews FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: meeting_agendas trigger_audit_meeting_agendas; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_meeting_agendas AFTER INSERT OR DELETE OR UPDATE ON committee.meeting_agendas FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: meeting_minutes trigger_audit_meeting_minutes; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_meeting_minutes AFTER INSERT OR DELETE OR UPDATE ON committee.meeting_minutes FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: member_conflicts trigger_audit_member_conflicts; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_member_conflicts AFTER INSERT OR DELETE OR UPDATE ON committee.member_conflicts FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: member_qualifications trigger_audit_member_qualifications; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_member_qualifications AFTER INSERT OR DELETE OR UPDATE ON committee.member_qualifications FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: member_terms trigger_audit_member_terms; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_member_terms AFTER INSERT OR DELETE OR UPDATE ON committee.member_terms FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: quorum_logs trigger_audit_quorum_logs; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_quorum_logs AFTER INSERT OR DELETE OR UPDATE ON committee.quorum_logs FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: review_answers trigger_audit_review_answers; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_review_answers AFTER INSERT OR DELETE OR UPDATE ON committee.review_answers FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: review_assignments trigger_audit_review_assignments; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_review_assignments AFTER INSERT OR DELETE OR UPDATE ON committee.review_assignments FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: review_comments trigger_audit_review_comments; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_review_comments AFTER INSERT OR DELETE OR UPDATE ON committee.review_comments FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: review_conflicts trigger_audit_review_conflicts; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_review_conflicts AFTER INSERT OR DELETE OR UPDATE ON committee.review_conflicts FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: review_forms trigger_audit_review_forms; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_review_forms AFTER INSERT OR DELETE OR UPDATE ON committee.review_forms FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: review_questions trigger_audit_review_questions; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_review_questions AFTER INSERT OR DELETE OR UPDATE ON committee.review_questions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: review_recommendations trigger_audit_review_recommendations; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_review_recommendations AFTER INSERT OR DELETE OR UPDATE ON committee.review_recommendations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: review_scores trigger_audit_review_scores; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_review_scores AFTER INSERT OR DELETE OR UPDATE ON committee.review_scores FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: scientific_reviews trigger_audit_scientific_reviews; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_scientific_reviews AFTER INSERT OR DELETE OR UPDATE ON committee.scientific_reviews FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: votes trigger_audit_votes; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_votes AFTER INSERT OR DELETE OR UPDATE ON committee.votes FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: voting_sessions trigger_audit_voting_sessions; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_voting_sessions AFTER INSERT OR DELETE OR UPDATE ON committee.voting_sessions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: member_conflicts trigger_updated_at_committee_member_conflicts; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_updated_at_committee_member_conflicts BEFORE UPDATE ON committee.member_conflicts FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: member_qualifications trigger_updated_at_committee_member_qualifications; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_updated_at_committee_member_qualifications BEFORE UPDATE ON committee.member_qualifications FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: member_terms trigger_updated_at_committee_member_terms; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_updated_at_committee_member_terms BEFORE UPDATE ON committee.member_terms FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: announcements trigger_audit_announcements; Type: TRIGGER; Schema: communication; Owner: -
--

CREATE TRIGGER trigger_audit_announcements AFTER INSERT OR DELETE OR UPDATE ON communication.announcements FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: message_attachments trigger_audit_message_attachments; Type: TRIGGER; Schema: communication; Owner: -
--

CREATE TRIGGER trigger_audit_message_attachments AFTER INSERT OR DELETE OR UPDATE ON communication.message_attachments FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: message_recipients trigger_audit_message_recipients; Type: TRIGGER; Schema: communication; Owner: -
--

CREATE TRIGGER trigger_audit_message_recipients AFTER INSERT OR DELETE OR UPDATE ON communication.message_recipients FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: messages trigger_audit_messages; Type: TRIGGER; Schema: communication; Owner: -
--

CREATE TRIGGER trigger_audit_messages AFTER INSERT OR DELETE OR UPDATE ON communication.messages FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: notification_channels trigger_audit_notification_channels; Type: TRIGGER; Schema: communication; Owner: -
--

CREATE TRIGGER trigger_audit_notification_channels AFTER INSERT OR DELETE OR UPDATE ON communication.notification_channels FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: notification_logs trigger_audit_notification_logs; Type: TRIGGER; Schema: communication; Owner: -
--

CREATE TRIGGER trigger_audit_notification_logs AFTER INSERT OR DELETE OR UPDATE ON communication.notification_logs FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: notification_templates trigger_audit_notification_templates; Type: TRIGGER; Schema: communication; Owner: -
--

CREATE TRIGGER trigger_audit_notification_templates AFTER INSERT OR DELETE OR UPDATE ON communication.notification_templates FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: notifications trigger_audit_notifications; Type: TRIGGER; Schema: communication; Owner: -
--

CREATE TRIGGER trigger_audit_notifications AFTER INSERT OR DELETE OR UPDATE ON communication.notifications FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: amendment_requests trigger_audit_amendment_requests; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_amendment_requests AFTER INSERT OR DELETE OR UPDATE ON core.amendment_requests FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: application_amendments trigger_audit_application_amendments; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_application_amendments AFTER INSERT OR DELETE OR UPDATE ON core.application_amendments FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: application_checklists trigger_audit_application_checklists; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_application_checklists AFTER INSERT OR DELETE OR UPDATE ON core.application_checklists FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: application_history trigger_audit_application_history; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_application_history AFTER INSERT OR DELETE OR UPDATE ON core.application_history FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: application_sections trigger_audit_application_sections; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_application_sections AFTER INSERT OR DELETE OR UPDATE ON core.application_sections FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: application_validations trigger_audit_application_validations; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_application_validations AFTER INSERT OR DELETE OR UPDATE ON core.application_validations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: application_versions trigger_audit_application_versions; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_application_versions AFTER INSERT OR DELETE OR UPDATE ON core.application_versions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: applications trigger_audit_applications; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_applications AFTER INSERT OR DELETE OR UPDATE ON core.applications FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: closure_requests trigger_audit_closure_requests; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_closure_requests AFTER INSERT OR DELETE OR UPDATE ON core.closure_requests FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: project_attachments trigger_audit_project_attachments; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_attachments AFTER INSERT OR DELETE OR UPDATE ON core.project_attachments FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: project_funding_sources trigger_audit_project_funding_sources; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_funding_sources AFTER INSERT OR DELETE OR UPDATE ON core.project_funding_sources FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: project_keywords trigger_audit_project_keywords; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_keywords AFTER INSERT OR DELETE OR UPDATE ON core.project_keywords FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: project_site_investigators trigger_audit_project_site_investigators; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_site_investigators AFTER INSERT OR DELETE OR UPDATE ON core.project_site_investigators FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: project_sites trigger_audit_project_sites; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_sites AFTER INSERT OR DELETE OR UPDATE ON core.project_sites FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: project_status_history trigger_audit_project_status_history; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_status_history AFTER INSERT OR DELETE OR UPDATE ON core.project_status_history FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: project_tags trigger_audit_project_tags; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_tags AFTER INSERT OR DELETE OR UPDATE ON core.project_tags FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: project_team_members trigger_audit_project_team_members; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_team_members AFTER INSERT OR DELETE OR UPDATE ON core.project_team_members FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: project_versions trigger_audit_project_versions; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_project_versions AFTER INSERT OR DELETE OR UPDATE ON core.project_versions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: projects trigger_audit_projects; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_projects AFTER INSERT OR DELETE OR UPDATE ON core.projects FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: renewal_requests trigger_audit_renewal_requests; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_renewal_requests AFTER INSERT OR DELETE OR UPDATE ON core.renewal_requests FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: research_categories trigger_audit_research_categories; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_research_categories AFTER INSERT OR DELETE OR UPDATE ON core.research_categories FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: research_population_links trigger_audit_research_population_links; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_research_population_links AFTER INSERT OR DELETE OR UPDATE ON core.research_population_links FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: risk_classifications trigger_audit_risk_classifications; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_risk_classifications AFTER INSERT OR DELETE OR UPDATE ON core.risk_classifications FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: vulnerable_populations trigger_audit_vulnerable_populations; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_vulnerable_populations AFTER INSERT OR DELETE OR UPDATE ON core.vulnerable_populations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: applications trigger_notification_applications; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_notification_applications AFTER UPDATE ON core.applications FOR EACH ROW EXECUTE FUNCTION system.fn_notify_status_change();


--
-- Name: applications trigger_updated_at; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON core.applications FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: projects trigger_updated_at; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON core.projects FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: research_categories trigger_updated_at_core_research_categories; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_updated_at_core_research_categories BEFORE UPDATE ON core.research_categories FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: risk_classifications trigger_updated_at_core_risk_classifications; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_updated_at_core_risk_classifications BEFORE UPDATE ON core.risk_classifications FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: vulnerable_populations trigger_updated_at_core_vulnerable_populations; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_updated_at_core_vulnerable_populations BEFORE UPDATE ON core.vulnerable_populations FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: applications trigger_versioning_applications; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_versioning_applications AFTER UPDATE ON core.applications FOR EACH ROW EXECUTE FUNCTION system.fn_create_snapshot();


--
-- Name: projects trigger_versioning_projects; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_versioning_projects AFTER UPDATE ON core.projects FOR EACH ROW EXECUTE FUNCTION system.fn_create_snapshot();


--
-- Name: document_access trigger_audit_document_access; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_access AFTER INSERT OR DELETE OR UPDATE ON documents.document_access FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: document_approvals trigger_audit_document_approvals; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_approvals AFTER INSERT OR DELETE OR UPDATE ON documents.document_approvals FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: document_audit trigger_audit_document_audit; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_audit AFTER INSERT OR DELETE OR UPDATE ON documents.document_audit FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: document_classifications trigger_audit_document_classifications; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_classifications AFTER INSERT OR DELETE OR UPDATE ON documents.document_classifications FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: document_disposal_logs trigger_audit_document_disposal_logs; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_disposal_logs AFTER INSERT OR DELETE OR UPDATE ON documents.document_disposal_logs FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: document_retention_rules trigger_audit_document_retention_rules; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_retention_rules AFTER INSERT OR DELETE OR UPDATE ON documents.document_retention_rules FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: document_signatures trigger_audit_document_signatures; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_signatures AFTER INSERT OR DELETE OR UPDATE ON documents.document_signatures FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: document_types trigger_audit_document_types; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_types AFTER INSERT OR DELETE OR UPDATE ON documents.document_types FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: document_versions trigger_audit_document_versions; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_document_versions AFTER INSERT OR DELETE OR UPDATE ON documents.document_versions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: documents trigger_audit_documents; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_documents AFTER INSERT OR DELETE OR UPDATE ON documents.documents FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: generated_documents trigger_audit_generated_documents; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_generated_documents AFTER INSERT OR DELETE OR UPDATE ON documents.generated_documents FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: templates trigger_audit_templates; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_audit_templates AFTER INSERT OR DELETE OR UPDATE ON documents.templates FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: document_classifications trigger_updated_at_documents_document_classifications; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_updated_at_documents_document_classifications BEFORE UPDATE ON documents.document_classifications FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: document_retention_rules trigger_updated_at_documents_document_retention_rules; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trigger_updated_at_documents_document_retention_rules BEFORE UPDATE ON documents.document_retention_rules FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: data_sync_jobs trigger_audit_data_sync_jobs; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_data_sync_jobs AFTER INSERT OR DELETE OR UPDATE ON integration.data_sync_jobs FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: event_bus_config trigger_audit_event_bus_config; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_event_bus_config AFTER INSERT OR DELETE OR UPDATE ON integration.event_bus_config FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: event_outbox trigger_audit_event_outbox; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_event_outbox AFTER INSERT OR DELETE OR UPDATE ON integration.event_outbox FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: event_subscriptions trigger_audit_event_subscriptions; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_event_subscriptions AFTER INSERT OR DELETE OR UPDATE ON integration.event_subscriptions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: external_systems trigger_audit_external_systems; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_external_systems AFTER INSERT OR DELETE OR UPDATE ON integration.external_systems FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: integration_credentials trigger_audit_integration_credentials; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_integration_credentials AFTER INSERT OR DELETE OR UPDATE ON integration.integration_credentials FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: integration_failures trigger_audit_integration_failures; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_integration_failures AFTER INSERT OR DELETE OR UPDATE ON integration.integration_failures FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: integration_logs trigger_audit_integration_logs; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_integration_logs AFTER INSERT OR DELETE OR UPDATE ON integration.integration_logs FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: retry_queue trigger_audit_retry_queue; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_retry_queue AFTER INSERT OR DELETE OR UPDATE ON integration.retry_queue FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: webhooks trigger_audit_webhooks; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_audit_webhooks AFTER INSERT OR DELETE OR UPDATE ON integration.webhooks FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: external_systems trigger_updated_at_integration_external_systems; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_updated_at_integration_external_systems BEFORE UPDATE ON integration.external_systems FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: integration_credentials trigger_updated_at_integration_integration_credentials; Type: TRIGGER; Schema: integration; Owner: -
--

CREATE TRIGGER trigger_updated_at_integration_integration_credentials BEFORE UPDATE ON integration.integration_credentials FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: compliance_reviews trigger_audit_compliance_reviews; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_compliance_reviews AFTER INSERT OR DELETE OR UPDATE ON monitoring.compliance_reviews FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: corrective_actions trigger_audit_corrective_actions; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_corrective_actions AFTER INSERT OR DELETE OR UPDATE ON monitoring.corrective_actions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: deviations trigger_audit_deviations; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_deviations AFTER INSERT OR DELETE OR UPDATE ON monitoring.deviations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: inspection_reports trigger_audit_inspection_reports; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_inspection_reports AFTER INSERT OR DELETE OR UPDATE ON monitoring.inspection_reports FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: inspections trigger_audit_inspections; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_inspections AFTER INSERT OR DELETE OR UPDATE ON monitoring.inspections FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: monitoring_findings trigger_audit_monitoring_findings; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_monitoring_findings AFTER INSERT OR DELETE OR UPDATE ON monitoring.monitoring_findings FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: monitoring_plans trigger_audit_monitoring_plans; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_monitoring_plans AFTER INSERT OR DELETE OR UPDATE ON monitoring.monitoring_plans FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: monitoring_visits trigger_audit_monitoring_visits; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_monitoring_visits AFTER INSERT OR DELETE OR UPDATE ON monitoring.monitoring_visits FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: preventive_actions trigger_audit_preventive_actions; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_preventive_actions AFTER INSERT OR DELETE OR UPDATE ON monitoring.preventive_actions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: protocol_violations trigger_audit_protocol_violations; Type: TRIGGER; Schema: monitoring; Owner: -
--

CREATE TRIGGER trigger_audit_protocol_violations AFTER INSERT OR DELETE OR UPDATE ON monitoring.protocol_violations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: application_statuses trigger_audit_application_statuses; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_application_statuses AFTER INSERT OR DELETE OR UPDATE ON reference.application_statuses FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: committee_decision_types trigger_audit_committee_decision_types; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_committee_decision_types AFTER INSERT OR DELETE OR UPDATE ON reference.committee_decision_types FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: document_statuses trigger_audit_document_statuses; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_document_statuses AFTER INSERT OR DELETE OR UPDATE ON reference.document_statuses FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: institutions_registry trigger_audit_institutions_registry; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_institutions_registry AFTER INSERT OR DELETE OR UPDATE ON reference.institutions_registry FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: licenses_registry trigger_audit_licenses_registry; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_licenses_registry AFTER INSERT OR DELETE OR UPDATE ON reference.licenses_registry FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: lookup_categories trigger_audit_lookup_categories; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_lookup_categories AFTER INSERT OR DELETE OR UPDATE ON reference.lookup_categories FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: lookup_values trigger_audit_lookup_values; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_lookup_values AFTER INSERT OR DELETE OR UPDATE ON reference.lookup_values FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: notification_statuses trigger_audit_notification_statuses; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_notification_statuses AFTER INSERT OR DELETE OR UPDATE ON reference.notification_statuses FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: priority_levels trigger_audit_priority_levels; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_priority_levels AFTER INSERT OR DELETE OR UPDATE ON reference.priority_levels FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: professions_registry trigger_audit_professions_registry; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_professions_registry AFTER INSERT OR DELETE OR UPDATE ON reference.professions_registry FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: review_statuses trigger_audit_review_statuses; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_review_statuses AFTER INSERT OR DELETE OR UPDATE ON reference.review_statuses FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: risk_levels trigger_audit_risk_levels; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_risk_levels AFTER INSERT OR DELETE OR UPDATE ON reference.risk_levels FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: status_types trigger_audit_status_types; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_status_types AFTER INSERT OR DELETE OR UPDATE ON reference.status_types FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: vote_types trigger_audit_vote_types; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_vote_types AFTER INSERT OR DELETE OR UPDATE ON reference.vote_types FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: workflow_statuses trigger_audit_workflow_statuses; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_statuses AFTER INSERT OR DELETE OR UPDATE ON reference.workflow_statuses FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: institutions_registry trigger_updated_at_reference_institutions_registry; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_updated_at_reference_institutions_registry BEFORE UPDATE ON reference.institutions_registry FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: licenses_registry trigger_updated_at_reference_licenses_registry; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_updated_at_reference_licenses_registry BEFORE UPDATE ON reference.licenses_registry FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: professions_registry trigger_updated_at_reference_professions_registry; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_updated_at_reference_professions_registry BEFORE UPDATE ON reference.professions_registry FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: analytics_snapshots trigger_audit_analytics_snapshots; Type: TRIGGER; Schema: reporting; Owner: -
--

CREATE TRIGGER trigger_audit_analytics_snapshots AFTER INSERT OR DELETE OR UPDATE ON reporting.analytics_snapshots FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: dashboard_widgets trigger_audit_dashboard_widgets; Type: TRIGGER; Schema: reporting; Owner: -
--

CREATE TRIGGER trigger_audit_dashboard_widgets AFTER INSERT OR DELETE OR UPDATE ON reporting.dashboard_widgets FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: kpi_results trigger_audit_kpi_results; Type: TRIGGER; Schema: reporting; Owner: -
--

CREATE TRIGGER trigger_audit_kpi_results AFTER INSERT OR DELETE OR UPDATE ON reporting.kpi_results FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: report_definitions trigger_audit_report_definitions; Type: TRIGGER; Schema: reporting; Owner: -
--

CREATE TRIGGER trigger_audit_report_definitions AFTER INSERT OR DELETE OR UPDATE ON reporting.report_definitions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: report_executions trigger_audit_report_executions; Type: TRIGGER; Schema: reporting; Owner: -
--

CREATE TRIGGER trigger_audit_report_executions AFTER INSERT OR DELETE OR UPDATE ON reporting.report_executions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: adverse_events trigger_audit_adverse_events; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_adverse_events AFTER INSERT OR DELETE OR UPDATE ON safety.adverse_events FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: corrective_actions trigger_audit_corrective_actions; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_corrective_actions AFTER INSERT OR DELETE OR UPDATE ON safety.corrective_actions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: mitigation_actions trigger_audit_mitigation_actions; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_mitigation_actions AFTER INSERT OR DELETE OR UPDATE ON safety.mitigation_actions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: risk_assessments trigger_audit_risk_assessments; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_risk_assessments AFTER INSERT OR DELETE OR UPDATE ON safety.risk_assessments FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: risk_categories trigger_audit_risk_categories; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_risk_categories AFTER INSERT OR DELETE OR UPDATE ON safety.risk_categories FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: risk_incidents trigger_audit_risk_incidents; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_risk_incidents AFTER INSERT OR DELETE OR UPDATE ON safety.risk_incidents FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: risk_mitigations trigger_audit_risk_mitigations; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_risk_mitigations AFTER INSERT OR DELETE OR UPDATE ON safety.risk_mitigations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: risk_register trigger_audit_risk_register; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_risk_register AFTER INSERT OR DELETE OR UPDATE ON safety.risk_register FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: safety_committee_reviews trigger_audit_safety_committee_reviews; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_safety_committee_reviews AFTER INSERT OR DELETE OR UPDATE ON safety.safety_committee_reviews FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: safety_followups trigger_audit_safety_followups; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_safety_followups AFTER INSERT OR DELETE OR UPDATE ON safety.safety_followups FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: safety_reports trigger_audit_safety_reports; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_safety_reports AFTER INSERT OR DELETE OR UPDATE ON safety.safety_reports FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: serious_adverse_events trigger_audit_serious_adverse_events; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_audit_serious_adverse_events AFTER INSERT OR DELETE OR UPDATE ON safety.serious_adverse_events FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: corrective_actions trigger_updated_at_safety_corrective_actions; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_updated_at_safety_corrective_actions BEFORE UPDATE ON safety.corrective_actions FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: risk_incidents trigger_updated_at_safety_risk_incidents; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_updated_at_safety_risk_incidents BEFORE UPDATE ON safety.risk_incidents FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: risk_mitigations trigger_updated_at_safety_risk_mitigations; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_updated_at_safety_risk_mitigations BEFORE UPDATE ON safety.risk_mitigations FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: risk_register trigger_updated_at_safety_risk_register; Type: TRIGGER; Schema: safety; Owner: -
--

CREATE TRIGGER trigger_updated_at_safety_risk_register BEFORE UPDATE ON safety.risk_register FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: access_policies trigger_audit_access_policies; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_access_policies AFTER INSERT OR DELETE OR UPDATE ON security.access_policies FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: api_keys trigger_audit_api_keys; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_api_keys AFTER INSERT OR DELETE OR UPDATE ON security.api_keys FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: approval_authorities trigger_audit_approval_authorities; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_approval_authorities AFTER INSERT OR DELETE OR UPDATE ON security.approval_authorities FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: approval_limits trigger_audit_approval_limits; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_approval_limits AFTER INSERT OR DELETE OR UPDATE ON security.approval_limits FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: certificate_revocations trigger_audit_certificate_revocations; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_certificate_revocations AFTER INSERT OR DELETE OR UPDATE ON security.certificate_revocations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: departments trigger_audit_departments; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_departments AFTER INSERT OR DELETE OR UPDATE ON security.departments FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: digital_certificates trigger_audit_digital_certificates; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_digital_certificates AFTER INSERT OR DELETE OR UPDATE ON security.digital_certificates FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: email_verification_tokens trigger_audit_email_verification_tokens; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_email_verification_tokens AFTER INSERT OR DELETE OR UPDATE ON security.email_verification_tokens FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: institution_types trigger_audit_institution_types; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_institution_types AFTER INSERT OR DELETE OR UPDATE ON security.institution_types FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: institutions trigger_audit_institutions; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_institutions AFTER INSERT OR DELETE OR UPDATE ON security.institutions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: password_reset_tokens trigger_audit_password_reset_tokens; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_password_reset_tokens AFTER INSERT OR DELETE OR UPDATE ON security.password_reset_tokens FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: permissions trigger_audit_permissions; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_permissions AFTER INSERT OR DELETE OR UPDATE ON security.permissions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: policy_conditions trigger_audit_policy_conditions; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_policy_conditions AFTER INSERT OR DELETE OR UPDATE ON security.policy_conditions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: policy_rules trigger_audit_policy_rules; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_policy_rules AFTER INSERT OR DELETE OR UPDATE ON security.policy_rules FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: responsibility_types trigger_audit_responsibility_types; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_responsibility_types AFTER INSERT OR DELETE OR UPDATE ON security.responsibility_types FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: role_delegations trigger_audit_role_delegations; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_role_delegations AFTER INSERT OR DELETE OR UPDATE ON security.role_delegations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: role_permissions trigger_audit_role_permissions; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_role_permissions AFTER INSERT OR DELETE OR UPDATE ON security.role_permissions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: roles trigger_audit_roles; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_roles AFTER INSERT OR DELETE OR UPDATE ON security.roles FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: segregation_rules trigger_audit_segregation_rules; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_segregation_rules AFTER INSERT OR DELETE OR UPDATE ON security.segregation_rules FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: user_profiles trigger_audit_user_profiles; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_user_profiles AFTER INSERT OR DELETE OR UPDATE ON security.user_profiles FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: user_responsibilities trigger_audit_user_responsibilities; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_user_responsibilities AFTER INSERT OR DELETE OR UPDATE ON security.user_responsibilities FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: user_roles trigger_audit_user_roles; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_user_roles AFTER INSERT OR DELETE OR UPDATE ON security.user_roles FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: users trigger_audit_users; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_users AFTER INSERT OR DELETE OR UPDATE ON security.users FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: departments trigger_updated_at; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON security.departments FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: institution_types trigger_updated_at; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON security.institution_types FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: institutions trigger_updated_at; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON security.institutions FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: roles trigger_updated_at; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON security.roles FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: user_profiles trigger_updated_at; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON security.user_profiles FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: users trigger_updated_at; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON security.users FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: responsibility_types trigger_updated_at_security_responsibility_types; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_updated_at_security_responsibility_types BEFORE UPDATE ON security.responsibility_types FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: user_responsibilities trigger_updated_at_security_user_responsibilities; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_updated_at_security_user_responsibilities BEFORE UPDATE ON security.user_responsibilities FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: business_rules trigger_audit_business_rules; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_business_rules AFTER INSERT OR DELETE OR UPDATE ON system.business_rules FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: email_config trigger_audit_email_config; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_email_config AFTER INSERT OR DELETE OR UPDATE ON system.email_config FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: feature_flags trigger_audit_feature_flags; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_feature_flags AFTER INSERT OR DELETE OR UPDATE ON system.feature_flags FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: maintenance_log trigger_audit_maintenance_log; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_maintenance_log AFTER INSERT OR DELETE OR UPDATE ON system.maintenance_log FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: rule_actions trigger_audit_rule_actions; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_rule_actions AFTER INSERT OR DELETE OR UPDATE ON system.rule_actions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: rule_conditions trigger_audit_rule_conditions; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_rule_conditions AFTER INSERT OR DELETE OR UPDATE ON system.rule_conditions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: rule_executions trigger_audit_rule_executions; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_rule_executions AFTER INSERT OR DELETE OR UPDATE ON system.rule_executions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: rule_versions trigger_audit_rule_versions; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_rule_versions AFTER INSERT OR DELETE OR UPDATE ON system.rule_versions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: saved_searches trigger_audit_saved_searches; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_saved_searches AFTER INSERT OR DELETE OR UPDATE ON system.saved_searches FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: sms_config trigger_audit_sms_config; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_sms_config AFTER INSERT OR DELETE OR UPDATE ON system.sms_config FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: system_config trigger_audit_system_config; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_audit_system_config AFTER INSERT OR DELETE OR UPDATE ON system.system_config FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: system_config trigger_updated_at; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON system.system_config FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: saved_searches trigger_updated_at_system_saved_searches; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_updated_at_system_saved_searches BEFORE UPDATE ON system.saved_searches FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: search_indexes trigger_updated_at_system_search_indexes; Type: TRIGGER; Schema: system; Owner: -
--

CREATE TRIGGER trigger_updated_at_system_search_indexes BEFORE UPDATE ON system.search_indexes FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: workflow_instances trigger_audit_workflow; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_instances FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: workflow_actions trigger_audit_workflow_actions; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_actions AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_actions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: workflow_comments trigger_audit_workflow_comments; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_comments AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_comments FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: workflow_escalations trigger_audit_workflow_escalations; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_escalations AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_escalations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: workflow_events trigger_audit_workflow_events; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_events AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_events FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: workflow_history trigger_audit_workflow_history; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_history AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_history FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: workflow_schedulers trigger_audit_workflow_schedulers; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_schedulers AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_schedulers FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: workflow_sla trigger_audit_workflow_sla; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_sla AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_sla FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: workflow_states trigger_audit_workflow_states; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_states AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_states FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: workflow_tasks trigger_audit_workflow_tasks; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_tasks AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_tasks FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: workflow_transitions trigger_audit_workflow_transitions; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_transitions AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_transitions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: workflow_triggers trigger_audit_workflow_triggers; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_triggers AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_triggers FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: workflow_variables trigger_audit_workflow_variables; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflow_variables AFTER INSERT OR DELETE OR UPDATE ON workflow.workflow_variables FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: workflows trigger_audit_workflows; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_audit_workflows AFTER INSERT OR DELETE OR UPDATE ON workflow.workflows FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--
-- Name: workflow_schedulers trigger_updated_at_workflow_workflow_schedulers; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_updated_at_workflow_workflow_schedulers BEFORE UPDATE ON workflow.workflow_schedulers FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: workflow_triggers trigger_updated_at_workflow_workflow_triggers; Type: TRIGGER; Schema: workflow; Owner: -
--

CREATE TRIGGER trigger_updated_at_workflow_workflow_triggers BEFORE UPDATE ON workflow.workflow_triggers FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--
-- Name: audit_details fk_audit_details_log; Type: FK CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.audit_details
    ADD CONSTRAINT fk_audit_details_log FOREIGN KEY (audit_log_id) REFERENCES audit.audit_logs(id) ON DELETE CASCADE;


--
-- Name: audit_logs fk_audit_logs_user; Type: FK CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.audit_logs
    ADD CONSTRAINT fk_audit_logs_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--
-- Name: entity_changes fk_entity_changes_user; Type: FK CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.entity_changes
    ADD CONSTRAINT fk_entity_changes_user FOREIGN KEY (changed_by) REFERENCES security.users(id);


--
-- Name: committee_members committee_members_role_id_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_members
    ADD CONSTRAINT committee_members_role_id_fkey FOREIGN KEY (role_id) REFERENCES committee.committee_roles(id);


--
-- Name: agenda_items fk_agenda_items_agenda; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.agenda_items
    ADD CONSTRAINT fk_agenda_items_agenda FOREIGN KEY (agenda_id) REFERENCES committee.meeting_agendas(id) ON DELETE CASCADE;


--
-- Name: agenda_items fk_agenda_items_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.agenda_items
    ADD CONSTRAINT fk_agenda_items_application FOREIGN KEY (application_id) REFERENCES core.applications(id);


--
-- Name: attendance_logs fk_attendance_logs_meeting; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.attendance_logs
    ADD CONSTRAINT fk_attendance_logs_meeting FOREIGN KEY (meeting_id) REFERENCES committee.committee_meetings(id) ON DELETE CASCADE;


--
-- Name: attendance_logs fk_attendance_logs_user; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.attendance_logs
    ADD CONSTRAINT fk_attendance_logs_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--
-- Name: committee_meetings fk_committee_meetings_committee; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_meetings
    ADD CONSTRAINT fk_committee_meetings_committee FOREIGN KEY (committee_id) REFERENCES committee.committees(id) ON DELETE CASCADE;


--
-- Name: committee_members fk_committee_members_committee; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_members
    ADD CONSTRAINT fk_committee_members_committee FOREIGN KEY (committee_id) REFERENCES committee.committees(id) ON DELETE CASCADE;


--
-- Name: committee_members fk_committee_members_user; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_members
    ADD CONSTRAINT fk_committee_members_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--
-- Name: committees fk_committees_institution; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committees
    ADD CONSTRAINT fk_committees_institution FOREIGN KEY (institution_id) REFERENCES security.institutions(id);


--
-- Name: committees fk_committees_type; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committees
    ADD CONSTRAINT fk_committees_type FOREIGN KEY (committee_type_id) REFERENCES committee.committee_types(id);


--
-- Name: ethics_reviews fk_ethics_reviews_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.ethics_reviews
    ADD CONSTRAINT fk_ethics_reviews_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: ethics_reviews fk_ethics_reviews_reviewer; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.ethics_reviews
    ADD CONSTRAINT fk_ethics_reviews_reviewer FOREIGN KEY (reviewer_id) REFERENCES security.users(id);


--
-- Name: meeting_agendas fk_meeting_agendas_meeting; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.meeting_agendas
    ADD CONSTRAINT fk_meeting_agendas_meeting FOREIGN KEY (meeting_id) REFERENCES committee.committee_meetings(id) ON DELETE CASCADE;


--
-- Name: meeting_minutes fk_meeting_minutes_meeting; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.meeting_minutes
    ADD CONSTRAINT fk_meeting_minutes_meeting FOREIGN KEY (meeting_id) REFERENCES committee.committee_meetings(id) ON DELETE CASCADE;


--
-- Name: member_conflicts fk_member_conflicts_member; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_conflicts
    ADD CONSTRAINT fk_member_conflicts_member FOREIGN KEY (member_id) REFERENCES committee.committee_members(id);


--
-- Name: member_qualifications fk_member_qualifications_member; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_qualifications
    ADD CONSTRAINT fk_member_qualifications_member FOREIGN KEY (member_id) REFERENCES committee.committee_members(id);


--
-- Name: member_qualifications fk_member_qualifications_verified_by; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_qualifications
    ADD CONSTRAINT fk_member_qualifications_verified_by FOREIGN KEY (verified_by) REFERENCES security.users(id);


--
-- Name: committee_member_roles fk_member_roles_member; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_member_roles
    ADD CONSTRAINT fk_member_roles_member FOREIGN KEY (member_id) REFERENCES committee.committee_members(id) ON DELETE CASCADE;


--
-- Name: committee_member_roles fk_member_roles_role; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.committee_member_roles
    ADD CONSTRAINT fk_member_roles_role FOREIGN KEY (role_id) REFERENCES committee.committee_roles(id) ON DELETE CASCADE;


--
-- Name: member_terms fk_member_terms_member; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.member_terms
    ADD CONSTRAINT fk_member_terms_member FOREIGN KEY (member_id) REFERENCES committee.committee_members(id);


--
-- Name: quorum_logs fk_quorum_logs_meeting; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.quorum_logs
    ADD CONSTRAINT fk_quorum_logs_meeting FOREIGN KEY (meeting_id) REFERENCES committee.committee_meetings(id) ON DELETE CASCADE;


--
-- Name: review_answers fk_review_answers_question; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_answers
    ADD CONSTRAINT fk_review_answers_question FOREIGN KEY (question_id) REFERENCES committee.review_questions(id) ON DELETE CASCADE;


--
-- Name: review_assignments fk_review_assignments_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_assignments
    ADD CONSTRAINT fk_review_assignments_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: review_assignments fk_review_assignments_reviewer; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_assignments
    ADD CONSTRAINT fk_review_assignments_reviewer FOREIGN KEY (reviewer_id) REFERENCES security.users(id);


--
-- Name: review_comments fk_review_comments_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_comments
    ADD CONSTRAINT fk_review_comments_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: review_conflicts fk_review_conflicts_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_conflicts
    ADD CONSTRAINT fk_review_conflicts_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: review_questions fk_review_questions_form; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_questions
    ADD CONSTRAINT fk_review_questions_form FOREIGN KEY (form_id) REFERENCES committee.review_forms(id) ON DELETE CASCADE;


--
-- Name: review_recommendations fk_review_recommendations_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_recommendations
    ADD CONSTRAINT fk_review_recommendations_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: review_scores fk_review_scores_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.review_scores
    ADD CONSTRAINT fk_review_scores_application FOREIGN KEY (application_id) REFERENCES core.applications(id);


--
-- Name: scientific_reviews fk_scientific_reviews_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.scientific_reviews
    ADD CONSTRAINT fk_scientific_reviews_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: scientific_reviews fk_scientific_reviews_reviewer; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.scientific_reviews
    ADD CONSTRAINT fk_scientific_reviews_reviewer FOREIGN KEY (reviewer_id) REFERENCES security.users(id);


--
-- Name: votes fk_votes_session; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.votes
    ADD CONSTRAINT fk_votes_session FOREIGN KEY (voting_session_id) REFERENCES committee.voting_sessions(id) ON DELETE CASCADE;


--
-- Name: votes fk_votes_voter; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.votes
    ADD CONSTRAINT fk_votes_voter FOREIGN KEY (voter_id) REFERENCES security.users(id);


--
-- Name: voting_sessions fk_voting_sessions_application; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.voting_sessions
    ADD CONSTRAINT fk_voting_sessions_application FOREIGN KEY (application_id) REFERENCES core.applications(id);


--
-- Name: voting_sessions fk_voting_sessions_meeting; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.voting_sessions
    ADD CONSTRAINT fk_voting_sessions_meeting FOREIGN KEY (meeting_id) REFERENCES committee.committee_meetings(id);


--
-- Name: meeting_minutes meeting_minutes_created_by_fkey; Type: FK CONSTRAINT; Schema: committee; Owner: -
--

ALTER TABLE ONLY committee.meeting_minutes
    ADD CONSTRAINT meeting_minutes_created_by_fkey FOREIGN KEY (created_by) REFERENCES security.users(id);


--
-- Name: announcements fk_announcements_user; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.announcements
    ADD CONSTRAINT fk_announcements_user FOREIGN KEY (created_by) REFERENCES security.users(id);


--
-- Name: notification_logs fk_notification_logs_notification; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_logs
    ADD CONSTRAINT fk_notification_logs_notification FOREIGN KEY (notification_id) REFERENCES communication.notifications(id) ON DELETE CASCADE;


--
-- Name: notifications fk_notifications_user; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notifications
    ADD CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--
-- Name: message_attachments message_attachments_message_id_fkey; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_attachments
    ADD CONSTRAINT message_attachments_message_id_fkey FOREIGN KEY (message_id) REFERENCES communication.messages(id) ON DELETE CASCADE;


--
-- Name: message_recipients message_recipients_message_id_fkey; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_recipients
    ADD CONSTRAINT message_recipients_message_id_fkey FOREIGN KEY (message_id) REFERENCES communication.messages(id) ON DELETE CASCADE;


--
-- Name: message_recipients message_recipients_recipient_id_fkey; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_recipients
    ADD CONSTRAINT message_recipients_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES security.users(id);


--
-- Name: messages messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.messages
    ADD CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES security.users(id);


--
-- Name: amendment_requests fk_amendment_requests_amendment; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.amendment_requests
    ADD CONSTRAINT fk_amendment_requests_amendment FOREIGN KEY (amendment_id) REFERENCES core.application_amendments(id) ON DELETE CASCADE;


--
-- Name: application_amendments fk_application_amendments_application; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_amendments
    ADD CONSTRAINT fk_application_amendments_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: application_checklists fk_application_checklists_application; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_checklists
    ADD CONSTRAINT fk_application_checklists_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: application_history fk_application_history_application; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_history
    ADD CONSTRAINT fk_application_history_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: application_sections fk_application_sections_application; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_sections
    ADD CONSTRAINT fk_application_sections_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: application_validations fk_application_validations_application; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_validations
    ADD CONSTRAINT fk_application_validations_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: application_versions fk_application_versions_application; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_versions
    ADD CONSTRAINT fk_application_versions_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: applications fk_applications_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.applications
    ADD CONSTRAINT fk_applications_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--
-- Name: applications fk_applications_user; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.applications
    ADD CONSTRAINT fk_applications_user FOREIGN KEY (submitted_by) REFERENCES security.users(id);


--
-- Name: closure_requests fk_closure_requests_application; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.closure_requests
    ADD CONSTRAINT fk_closure_requests_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: project_attachments fk_project_attachment_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_attachments
    ADD CONSTRAINT fk_project_attachment_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--
-- Name: project_funding_sources fk_project_funding_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_funding_sources
    ADD CONSTRAINT fk_project_funding_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--
-- Name: project_keywords fk_project_keywords_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_keywords
    ADD CONSTRAINT fk_project_keywords_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--
-- Name: project_team_members fk_project_member_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_team_members
    ADD CONSTRAINT fk_project_member_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--
-- Name: project_team_members fk_project_member_user; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_team_members
    ADD CONSTRAINT fk_project_member_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--
-- Name: project_sites fk_project_sites_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_sites
    ADD CONSTRAINT fk_project_sites_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--
-- Name: project_status_history fk_project_status_history_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_status_history
    ADD CONSTRAINT fk_project_status_history_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--
-- Name: project_tags fk_project_tags_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_tags
    ADD CONSTRAINT fk_project_tags_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--
-- Name: project_versions fk_project_versions_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_versions
    ADD CONSTRAINT fk_project_versions_project FOREIGN KEY (project_id) REFERENCES core.projects(id) ON DELETE CASCADE;


--
-- Name: projects fk_projects_institution; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.projects
    ADD CONSTRAINT fk_projects_institution FOREIGN KEY (institution_id) REFERENCES security.institutions(id);


--
-- Name: projects fk_projects_pi; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.projects
    ADD CONSTRAINT fk_projects_pi FOREIGN KEY (principal_investigator_id) REFERENCES security.users(id);


--
-- Name: renewal_requests fk_renewal_requests_application; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.renewal_requests
    ADD CONSTRAINT fk_renewal_requests_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: research_population_links fk_research_population_links_population; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.research_population_links
    ADD CONSTRAINT fk_research_population_links_population FOREIGN KEY (vulnerable_population_id) REFERENCES core.vulnerable_populations(id);


--
-- Name: research_population_links fk_research_population_links_project; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.research_population_links
    ADD CONSTRAINT fk_research_population_links_project FOREIGN KEY (project_id) REFERENCES core.projects(id);


--
-- Name: project_site_investigators fk_site_inv_site; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_site_investigators
    ADD CONSTRAINT fk_site_inv_site FOREIGN KEY (site_id) REFERENCES core.project_sites(id) ON DELETE CASCADE;


--
-- Name: project_site_investigators fk_site_inv_user; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.project_site_investigators
    ADD CONSTRAINT fk_site_inv_user FOREIGN KEY (investigator_id) REFERENCES security.users(id);


--
-- Name: document_access fk_document_access_document; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_access
    ADD CONSTRAINT fk_document_access_document FOREIGN KEY (document_id) REFERENCES documents.documents(id) ON DELETE CASCADE;


--
-- Name: document_access fk_document_access_role; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_access
    ADD CONSTRAINT fk_document_access_role FOREIGN KEY (role_id) REFERENCES security.roles(id);


--
-- Name: document_access fk_document_access_user; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_access
    ADD CONSTRAINT fk_document_access_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--
-- Name: document_approvals fk_document_approvals_approver; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_approvals
    ADD CONSTRAINT fk_document_approvals_approver FOREIGN KEY (approver_id) REFERENCES security.users(id);


--
-- Name: document_approvals fk_document_approvals_document; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_approvals
    ADD CONSTRAINT fk_document_approvals_document FOREIGN KEY (document_id) REFERENCES documents.documents(id) ON DELETE CASCADE;


--
-- Name: document_audit fk_document_audit_document; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_audit
    ADD CONSTRAINT fk_document_audit_document FOREIGN KEY (document_id) REFERENCES documents.documents(id) ON DELETE CASCADE;


--
-- Name: document_disposal_logs fk_document_disposal_logs_disposed_by; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_disposal_logs
    ADD CONSTRAINT fk_document_disposal_logs_disposed_by FOREIGN KEY (disposed_by) REFERENCES security.users(id);


--
-- Name: document_disposal_logs fk_document_disposal_logs_document; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_disposal_logs
    ADD CONSTRAINT fk_document_disposal_logs_document FOREIGN KEY (document_id) REFERENCES documents.documents(id);


--
-- Name: document_retention_rules fk_document_retention_rules_type; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_retention_rules
    ADD CONSTRAINT fk_document_retention_rules_type FOREIGN KEY (document_type_id) REFERENCES documents.document_types(id);


--
-- Name: document_signatures fk_document_signatures_document; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_signatures
    ADD CONSTRAINT fk_document_signatures_document FOREIGN KEY (document_id) REFERENCES documents.documents(id) ON DELETE CASCADE;


--
-- Name: document_signatures fk_document_signatures_signer; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_signatures
    ADD CONSTRAINT fk_document_signatures_signer FOREIGN KEY (signer_id) REFERENCES security.users(id);


--
-- Name: document_versions fk_document_versions_document; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_versions
    ADD CONSTRAINT fk_document_versions_document FOREIGN KEY (document_id) REFERENCES documents.documents(id) ON DELETE CASCADE;


--
-- Name: document_versions fk_document_versions_user; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.document_versions
    ADD CONSTRAINT fk_document_versions_user FOREIGN KEY (uploaded_by) REFERENCES security.users(id);


--
-- Name: documents fk_documents_type; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.documents
    ADD CONSTRAINT fk_documents_type FOREIGN KEY (document_type_id) REFERENCES documents.document_types(id);


--
-- Name: documents fk_documents_uploaded_by; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.documents
    ADD CONSTRAINT fk_documents_uploaded_by FOREIGN KEY (uploaded_by) REFERENCES security.users(id);


--
-- Name: generated_documents fk_generated_documents_document; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.generated_documents
    ADD CONSTRAINT fk_generated_documents_document FOREIGN KEY (generated_document_id) REFERENCES documents.documents(id);


--
-- Name: generated_documents fk_generated_documents_template; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.generated_documents
    ADD CONSTRAINT fk_generated_documents_template FOREIGN KEY (template_id) REFERENCES documents.templates(id);


--
-- Name: generated_documents fk_generated_documents_user; Type: FK CONSTRAINT; Schema: documents; Owner: -
--

ALTER TABLE ONLY documents.generated_documents
    ADD CONSTRAINT fk_generated_documents_user FOREIGN KEY (generated_by) REFERENCES security.users(id);


--
-- Name: data_sync_jobs fk_data_sync_jobs_system; Type: FK CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.data_sync_jobs
    ADD CONSTRAINT fk_data_sync_jobs_system FOREIGN KEY (external_system_id) REFERENCES integration.external_systems(id) ON DELETE CASCADE;


--
-- Name: integration_credentials fk_integration_credentials_system; Type: FK CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_credentials
    ADD CONSTRAINT fk_integration_credentials_system FOREIGN KEY (external_system_id) REFERENCES integration.external_systems(id) ON DELETE CASCADE;


--
-- Name: integration_failures fk_integration_failures_resolved_by; Type: FK CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_failures
    ADD CONSTRAINT fk_integration_failures_resolved_by FOREIGN KEY (resolved_by) REFERENCES security.users(id) ON DELETE SET NULL;


--
-- Name: integration_failures fk_integration_failures_system; Type: FK CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_failures
    ADD CONSTRAINT fk_integration_failures_system FOREIGN KEY (external_system_id) REFERENCES integration.external_systems(id) ON DELETE SET NULL;


--
-- Name: integration_logs fk_integration_logs_user; Type: FK CONSTRAINT; Schema: integration; Owner: -
--

ALTER TABLE ONLY integration.integration_logs
    ADD CONSTRAINT fk_integration_logs_user FOREIGN KEY (created_by) REFERENCES security.users(id);


--
-- Name: compliance_reviews fk_compliance_reviews_application; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.compliance_reviews
    ADD CONSTRAINT fk_compliance_reviews_application FOREIGN KEY (application_id) REFERENCES core.applications(id);


--
-- Name: compliance_reviews fk_compliance_reviews_reviewer; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.compliance_reviews
    ADD CONSTRAINT fk_compliance_reviews_reviewer FOREIGN KEY (reviewer_id) REFERENCES security.users(id);


--
-- Name: corrective_actions fk_corrective_actions_finding; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.corrective_actions
    ADD CONSTRAINT fk_corrective_actions_finding FOREIGN KEY (finding_id) REFERENCES monitoring.monitoring_findings(id) ON DELETE CASCADE;


--
-- Name: deviations fk_deviations_application; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.deviations
    ADD CONSTRAINT fk_deviations_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: inspection_reports fk_inspection_reports_inspection; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.inspection_reports
    ADD CONSTRAINT fk_inspection_reports_inspection FOREIGN KEY (inspection_id) REFERENCES monitoring.inspections(id) ON DELETE CASCADE;


--
-- Name: inspections fk_inspections_application; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.inspections
    ADD CONSTRAINT fk_inspections_application FOREIGN KEY (application_id) REFERENCES core.applications(id);


--
-- Name: inspections fk_inspections_inspector; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.inspections
    ADD CONSTRAINT fk_inspections_inspector FOREIGN KEY (inspector_id) REFERENCES security.users(id);


--
-- Name: monitoring_findings fk_monitoring_findings_visit; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.monitoring_findings
    ADD CONSTRAINT fk_monitoring_findings_visit FOREIGN KEY (monitoring_visit_id) REFERENCES monitoring.monitoring_visits(id) ON DELETE CASCADE;


--
-- Name: monitoring_plans fk_monitoring_plan_application; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.monitoring_plans
    ADD CONSTRAINT fk_monitoring_plan_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: monitoring_visits fk_monitoring_visits_monitor; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.monitoring_visits
    ADD CONSTRAINT fk_monitoring_visits_monitor FOREIGN KEY (monitor_id) REFERENCES security.users(id);


--
-- Name: monitoring_visits fk_monitoring_visits_plan; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.monitoring_visits
    ADD CONSTRAINT fk_monitoring_visits_plan FOREIGN KEY (monitoring_plan_id) REFERENCES monitoring.monitoring_plans(id) ON DELETE CASCADE;


--
-- Name: preventive_actions fk_preventive_actions_finding; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.preventive_actions
    ADD CONSTRAINT fk_preventive_actions_finding FOREIGN KEY (finding_id) REFERENCES monitoring.monitoring_findings(id) ON DELETE CASCADE;


--
-- Name: protocol_violations fk_protocol_violations_application; Type: FK CONSTRAINT; Schema: monitoring; Owner: -
--

ALTER TABLE ONLY monitoring.protocol_violations
    ADD CONSTRAINT fk_protocol_violations_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: licenses_registry fk_licenses_registry_profession; Type: FK CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT fk_licenses_registry_profession FOREIGN KEY (profession_id) REFERENCES reference.professions_registry(id);


--
-- Name: licenses_registry fk_licenses_registry_user; Type: FK CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT fk_licenses_registry_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--
-- Name: licenses_registry fk_licenses_registry_verified_by; Type: FK CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.licenses_registry
    ADD CONSTRAINT fk_licenses_registry_verified_by FOREIGN KEY (verified_by) REFERENCES security.users(id);


--
-- Name: lookup_values fk_lookup_values_category; Type: FK CONSTRAINT; Schema: reference; Owner: -
--

ALTER TABLE ONLY reference.lookup_values
    ADD CONSTRAINT fk_lookup_values_category FOREIGN KEY (category_id) REFERENCES reference.lookup_categories(id) ON DELETE CASCADE;


--
-- Name: report_executions fk_report_executions_report; Type: FK CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.report_executions
    ADD CONSTRAINT fk_report_executions_report FOREIGN KEY (report_id) REFERENCES reporting.report_definitions(id);


--
-- Name: report_executions fk_report_executions_user; Type: FK CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.report_executions
    ADD CONSTRAINT fk_report_executions_user FOREIGN KEY (executed_by) REFERENCES security.users(id);


--
-- Name: adverse_events fk_adverse_events_application; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.adverse_events
    ADD CONSTRAINT fk_adverse_events_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: adverse_events fk_adverse_events_reported_by; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.adverse_events
    ADD CONSTRAINT fk_adverse_events_reported_by FOREIGN KEY (reported_by) REFERENCES security.users(id);


--
-- Name: corrective_actions fk_corrective_actions_assigned_to; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.corrective_actions
    ADD CONSTRAINT fk_corrective_actions_assigned_to FOREIGN KEY (assigned_to) REFERENCES security.users(id);


--
-- Name: corrective_actions fk_corrective_actions_incident; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.corrective_actions
    ADD CONSTRAINT fk_corrective_actions_incident FOREIGN KEY (incident_id) REFERENCES safety.risk_incidents(id);


--
-- Name: mitigation_actions fk_mitigation_actions_assessment; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.mitigation_actions
    ADD CONSTRAINT fk_mitigation_actions_assessment FOREIGN KEY (risk_assessment_id) REFERENCES safety.risk_assessments(id) ON DELETE CASCADE;


--
-- Name: mitigation_actions fk_mitigation_actions_category; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.mitigation_actions
    ADD CONSTRAINT fk_mitigation_actions_category FOREIGN KEY (risk_category_id) REFERENCES safety.risk_categories(id);


--
-- Name: mitigation_actions fk_mitigation_actions_user; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.mitigation_actions
    ADD CONSTRAINT fk_mitigation_actions_user FOREIGN KEY (responsible_user_id) REFERENCES security.users(id);


--
-- Name: risk_assessments fk_risk_assessments_application; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_assessments
    ADD CONSTRAINT fk_risk_assessments_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: risk_assessments fk_risk_assessments_user; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_assessments
    ADD CONSTRAINT fk_risk_assessments_user FOREIGN KEY (assessed_by) REFERENCES security.users(id);


--
-- Name: risk_incidents fk_risk_incidents_reported_by; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_incidents
    ADD CONSTRAINT fk_risk_incidents_reported_by FOREIGN KEY (reported_by) REFERENCES security.users(id);


--
-- Name: risk_incidents fk_risk_incidents_risk; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_incidents
    ADD CONSTRAINT fk_risk_incidents_risk FOREIGN KEY (risk_id) REFERENCES safety.risk_register(id);


--
-- Name: risk_mitigations fk_risk_mitigations_responsible; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_mitigations
    ADD CONSTRAINT fk_risk_mitigations_responsible FOREIGN KEY (responsible_party) REFERENCES security.users(id);


--
-- Name: risk_mitigations fk_risk_mitigations_risk; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_mitigations
    ADD CONSTRAINT fk_risk_mitigations_risk FOREIGN KEY (risk_id) REFERENCES safety.risk_register(id);


--
-- Name: risk_register fk_risk_register_category; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_register
    ADD CONSTRAINT fk_risk_register_category FOREIGN KEY (risk_category_id) REFERENCES safety.risk_categories(id);


--
-- Name: risk_register fk_risk_register_identified_by; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_register
    ADD CONSTRAINT fk_risk_register_identified_by FOREIGN KEY (identified_by) REFERENCES security.users(id);


--
-- Name: risk_register fk_risk_register_owner; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_register
    ADD CONSTRAINT fk_risk_register_owner FOREIGN KEY (owner_id) REFERENCES security.users(id);


--
-- Name: risk_register fk_risk_register_reviewed_by; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.risk_register
    ADD CONSTRAINT fk_risk_register_reviewed_by FOREIGN KEY (reviewed_by) REFERENCES security.users(id);


--
-- Name: safety_committee_reviews fk_safety_committee_reviews_application; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_committee_reviews
    ADD CONSTRAINT fk_safety_committee_reviews_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: safety_committee_reviews fk_safety_committee_reviews_committee; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_committee_reviews
    ADD CONSTRAINT fk_safety_committee_reviews_committee FOREIGN KEY (committee_id) REFERENCES committee.committees(id);


--
-- Name: safety_committee_reviews fk_safety_committee_reviews_user; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_committee_reviews
    ADD CONSTRAINT fk_safety_committee_reviews_user FOREIGN KEY (reviewed_by) REFERENCES security.users(id);


--
-- Name: safety_followups fk_safety_followups_event; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_followups
    ADD CONSTRAINT fk_safety_followups_event FOREIGN KEY (adverse_event_id) REFERENCES safety.adverse_events(id) ON DELETE CASCADE;


--
-- Name: safety_reports fk_safety_reports_application; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_reports
    ADD CONSTRAINT fk_safety_reports_application FOREIGN KEY (application_id) REFERENCES core.applications(id) ON DELETE CASCADE;


--
-- Name: safety_reports fk_safety_reports_user; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.safety_reports
    ADD CONSTRAINT fk_safety_reports_user FOREIGN KEY (submitted_by) REFERENCES security.users(id);


--
-- Name: serious_adverse_events fk_serious_adverse_events_event; Type: FK CONSTRAINT; Schema: safety; Owner: -
--

ALTER TABLE ONLY safety.serious_adverse_events
    ADD CONSTRAINT fk_serious_adverse_events_event FOREIGN KEY (adverse_event_id) REFERENCES safety.adverse_events(id) ON DELETE CASCADE;


--
-- Name: email_verification_tokens email_verification_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.email_verification_tokens
    ADD CONSTRAINT email_verification_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--
-- Name: api_keys fk_api_keys_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.api_keys
    ADD CONSTRAINT fk_api_keys_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--
-- Name: departments fk_departments_institution; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.departments
    ADD CONSTRAINT fk_departments_institution FOREIGN KEY (institution_id) REFERENCES security.institutions(id) ON DELETE CASCADE;


--
-- Name: institutions fk_institutions_type; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.institutions
    ADD CONSTRAINT fk_institutions_type FOREIGN KEY (institution_type_id) REFERENCES security.institution_types(id) ON DELETE RESTRICT;


--
-- Name: login_audit fk_login_audit_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.login_audit
    ADD CONSTRAINT fk_login_audit_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE SET NULL;


--
-- Name: password_history fk_password_history_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.password_history
    ADD CONSTRAINT fk_password_history_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--
-- Name: role_permissions fk_role_permissions_permission; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.role_permissions
    ADD CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id) REFERENCES security.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions fk_role_permissions_role; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.role_permissions
    ADD CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES security.roles(id) ON DELETE CASCADE;


--
-- Name: security_events fk_security_events_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.security_events
    ADD CONSTRAINT fk_security_events_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE SET NULL;


--
-- Name: sessions fk_sessions_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.sessions
    ADD CONSTRAINT fk_sessions_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--
-- Name: user_profiles fk_user_profiles_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_profiles
    ADD CONSTRAINT fk_user_profiles_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--
-- Name: user_responsibilities fk_user_responsibilities_assigned_by; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT fk_user_responsibilities_assigned_by FOREIGN KEY (assigned_by) REFERENCES security.users(id);


--
-- Name: user_responsibilities fk_user_responsibilities_revoked_by; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT fk_user_responsibilities_revoked_by FOREIGN KEY (revoked_by) REFERENCES security.users(id);


--
-- Name: user_responsibilities fk_user_responsibilities_type; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT fk_user_responsibilities_type FOREIGN KEY (responsibility_type_id) REFERENCES security.responsibility_types(id);


--
-- Name: user_responsibilities fk_user_responsibilities_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT fk_user_responsibilities_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--
-- Name: user_roles fk_user_roles_role; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_roles
    ADD CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES security.roles(id) ON DELETE CASCADE;


--
-- Name: user_roles fk_user_roles_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_roles
    ADD CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--
-- Name: users fk_users_department; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT fk_users_department FOREIGN KEY (department_id) REFERENCES security.departments(id);


--
-- Name: users fk_users_institution; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT fk_users_institution FOREIGN KEY (institution_id) REFERENCES security.institutions(id);


--
-- Name: password_reset_tokens password_reset_tokens_created_by_fkey; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_created_by_fkey FOREIGN KEY (created_by) REFERENCES security.users(id);


--
-- Name: password_reset_tokens password_reset_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--
-- Name: audit_log audit_log_user_id_fkey; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.audit_log
    ADD CONSTRAINT audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES security.users(id);


--
-- Name: maintenance_log fk_maintenance_log_user; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.maintenance_log
    ADD CONSTRAINT fk_maintenance_log_user FOREIGN KEY (performed_by) REFERENCES security.users(id);


--
-- Name: rule_actions fk_rule_actions_rule; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_actions
    ADD CONSTRAINT fk_rule_actions_rule FOREIGN KEY (rule_id) REFERENCES system.business_rules(id) ON DELETE CASCADE;


--
-- Name: rule_conditions fk_rule_conditions_rule; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_conditions
    ADD CONSTRAINT fk_rule_conditions_rule FOREIGN KEY (rule_id) REFERENCES system.business_rules(id) ON DELETE CASCADE;


--
-- Name: rule_executions fk_rule_executions_rule; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_executions
    ADD CONSTRAINT fk_rule_executions_rule FOREIGN KEY (rule_id) REFERENCES system.business_rules(id) ON DELETE CASCADE;


--
-- Name: rule_executions fk_rule_executions_triggered_by; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_executions
    ADD CONSTRAINT fk_rule_executions_triggered_by FOREIGN KEY (triggered_by) REFERENCES security.users(id) ON DELETE SET NULL;


--
-- Name: saved_searches fk_saved_searches_user; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.saved_searches
    ADD CONSTRAINT fk_saved_searches_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--
-- Name: search_audit fk_search_audit_user; Type: FK CONSTRAINT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.search_audit
    ADD CONSTRAINT fk_search_audit_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE SET NULL;


--
-- Name: workflow_transitions fk_transition_from_state; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_transitions
    ADD CONSTRAINT fk_transition_from_state FOREIGN KEY (from_state_id) REFERENCES workflow.workflow_states(id);


--
-- Name: workflow_transitions fk_transition_to_state; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_transitions
    ADD CONSTRAINT fk_transition_to_state FOREIGN KEY (to_state_id) REFERENCES workflow.workflow_states(id);


--
-- Name: workflow_transitions fk_transition_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_transitions
    ADD CONSTRAINT fk_transition_workflow FOREIGN KEY (workflow_id) REFERENCES workflow.workflows(id);


--
-- Name: workflow_actions fk_workflow_actions_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_actions
    ADD CONSTRAINT fk_workflow_actions_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE CASCADE;


--
-- Name: workflow_actions fk_workflow_actions_transition; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_actions
    ADD CONSTRAINT fk_workflow_actions_transition FOREIGN KEY (transition_id) REFERENCES workflow.workflow_transitions(id);


--
-- Name: workflow_actions fk_workflow_actions_user; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_actions
    ADD CONSTRAINT fk_workflow_actions_user FOREIGN KEY (action_by) REFERENCES security.users(id);


--
-- Name: workflow_comments fk_workflow_comments_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_comments
    ADD CONSTRAINT fk_workflow_comments_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE CASCADE;


--
-- Name: workflow_comments fk_workflow_comments_user; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_comments
    ADD CONSTRAINT fk_workflow_comments_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--
-- Name: workflow_escalations fk_workflow_escalations_task; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_escalations
    ADD CONSTRAINT fk_workflow_escalations_task FOREIGN KEY (workflow_task_id) REFERENCES workflow.workflow_tasks(id) ON DELETE CASCADE;


--
-- Name: workflow_events fk_workflow_events_created_by; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_events
    ADD CONSTRAINT fk_workflow_events_created_by FOREIGN KEY (created_by) REFERENCES security.users(id) ON DELETE SET NULL;


--
-- Name: workflow_events fk_workflow_events_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_events
    ADD CONSTRAINT fk_workflow_events_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE SET NULL;


--
-- Name: workflow_history fk_workflow_history_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_history
    ADD CONSTRAINT fk_workflow_history_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE CASCADE;


--
-- Name: workflow_instances fk_workflow_instances_state; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_instances
    ADD CONSTRAINT fk_workflow_instances_state FOREIGN KEY (current_state_id) REFERENCES workflow.workflow_states(id);


--
-- Name: workflow_instances fk_workflow_instances_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_instances
    ADD CONSTRAINT fk_workflow_instances_workflow FOREIGN KEY (workflow_id) REFERENCES workflow.workflows(id);


--
-- Name: workflow_schedulers fk_workflow_schedulers_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_schedulers
    ADD CONSTRAINT fk_workflow_schedulers_workflow FOREIGN KEY (workflow_id) REFERENCES workflow.workflows(id);


--
-- Name: workflow_sla fk_workflow_sla_state; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_sla
    ADD CONSTRAINT fk_workflow_sla_state FOREIGN KEY (state_id) REFERENCES workflow.workflow_states(id);


--
-- Name: workflow_sla fk_workflow_sla_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_sla
    ADD CONSTRAINT fk_workflow_sla_workflow FOREIGN KEY (workflow_id) REFERENCES workflow.workflows(id);


--
-- Name: workflow_states fk_workflow_states_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_states
    ADD CONSTRAINT fk_workflow_states_workflow FOREIGN KEY (workflow_id) REFERENCES workflow.workflows(id) ON DELETE CASCADE;


--
-- Name: workflow_tasks fk_workflow_tasks_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_tasks
    ADD CONSTRAINT fk_workflow_tasks_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE CASCADE;


--
-- Name: workflow_tasks fk_workflow_tasks_user; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_tasks
    ADD CONSTRAINT fk_workflow_tasks_user FOREIGN KEY (assigned_to) REFERENCES security.users(id);


--
-- Name: workflow_triggers fk_workflow_triggers_workflow; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_triggers
    ADD CONSTRAINT fk_workflow_triggers_workflow FOREIGN KEY (target_workflow_id) REFERENCES workflow.workflows(id);


--
-- Name: workflow_variables fk_workflow_variables_instance; Type: FK CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.workflow_variables
    ADD CONSTRAINT fk_workflow_variables_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE CASCADE;


--
-- Name: committee_meetings; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.committee_meetings ENABLE ROW LEVEL SECURITY;

--
-- Name: committee_meetings committee_meetings_policy; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY committee_meetings_policy ON committee.committee_meetings FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (system.is_active_row(deleted_at) AND (EXISTS ( SELECT 1
   FROM committee.committee_members cm
  WHERE ((cm.committee_id = committee_meetings.committee_id) AND (cm.user_id = (current_setting('app.user_id'::text, true))::bigint) AND (cm.is_active = true)))))));


--
-- Name: ethics_reviews; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.ethics_reviews ENABLE ROW LEVEL SECURITY;

--
-- Name: ethics_reviews ethics_reviews_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY ethics_reviews_insert ON committee.ethics_reviews FOR INSERT WITH CHECK ((((current_setting('app.user_id'::text, true))::bigint = reviewer_id) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: ethics_reviews ethics_reviews_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY ethics_reviews_select ON committee.ethics_reviews FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = reviewer_id)));


--
-- Name: ethics_reviews ethics_reviews_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY ethics_reviews_update ON committee.ethics_reviews FOR UPDATE USING ((system.is_active_row(deleted_at) AND (((current_setting('app.user_id'::text, true))::bigint = reviewer_id) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)))) WITH CHECK ((((current_setting('app.user_id'::text, true))::bigint = reviewer_id) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: member_conflicts; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.member_conflicts ENABLE ROW LEVEL SECURITY;

--
-- Name: member_conflicts member_conflicts_delete; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY member_conflicts_delete ON committee.member_conflicts FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: member_conflicts member_conflicts_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY member_conflicts_insert ON committee.member_conflicts FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (member_id IN ( SELECT cm.id
   FROM committee.committee_members cm
  WHERE (cm.user_id = (current_setting('app.user_id'::text, true))::bigint)))));


--
-- Name: member_conflicts member_conflicts_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY member_conflicts_select ON committee.member_conflicts FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (system.is_active_row(deleted_at) AND (member_id IN ( SELECT cm.id
   FROM committee.committee_members cm
  WHERE (cm.user_id = (current_setting('app.user_id'::text, true))::bigint))))));


--
-- Name: member_conflicts member_conflicts_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY member_conflicts_update ON committee.member_conflicts FOR UPDATE USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (member_id IN ( SELECT cm.id
   FROM committee.committee_members cm
  WHERE (cm.user_id = (current_setting('app.user_id'::text, true))::bigint))))) WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (member_id IN ( SELECT cm.id
   FROM committee.committee_members cm
  WHERE (cm.user_id = (current_setting('app.user_id'::text, true))::bigint)))));


--
-- Name: member_qualifications; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.member_qualifications ENABLE ROW LEVEL SECURITY;

--
-- Name: member_qualifications member_qualifications_delete; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY member_qualifications_delete ON committee.member_qualifications FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: member_qualifications member_qualifications_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY member_qualifications_insert ON committee.member_qualifications FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: member_qualifications member_qualifications_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY member_qualifications_select ON committee.member_qualifications FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (system.is_active_row(deleted_at) AND (member_id IN ( SELECT cm.id
   FROM committee.committee_members cm
  WHERE (cm.user_id = (current_setting('app.user_id'::text, true))::bigint))))));


--
-- Name: member_qualifications member_qualifications_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY member_qualifications_update ON committee.member_qualifications FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: member_terms; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.member_terms ENABLE ROW LEVEL SECURITY;

--
-- Name: member_terms member_terms_delete; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY member_terms_delete ON committee.member_terms FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: member_terms member_terms_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY member_terms_insert ON committee.member_terms FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: member_terms member_terms_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY member_terms_select ON committee.member_terms FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (system.is_active_row(deleted_at) AND (member_id IN ( SELECT cm.id
   FROM committee.committee_members cm
  WHERE (cm.user_id = (current_setting('app.user_id'::text, true))::bigint))))));


--
-- Name: member_terms member_terms_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY member_terms_update ON committee.member_terms FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: review_assignments; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.review_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: review_assignments review_assignments_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY review_assignments_insert ON committee.review_assignments FOR INSERT WITH CHECK ((((current_setting('app.user_id'::text, true))::bigint = reviewer_id) OR ((current_setting('app.user_id'::text, true))::bigint = assigned_by) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: review_assignments review_assignments_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY review_assignments_select ON committee.review_assignments FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = reviewer_id) OR ((current_setting('app.user_id'::text, true))::bigint = assigned_by)));


--
-- Name: review_assignments review_assignments_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY review_assignments_update ON committee.review_assignments FOR UPDATE USING ((system.is_active_row(deleted_at) AND (((current_setting('app.user_id'::text, true))::bigint = reviewer_id) OR ((current_setting('app.user_id'::text, true))::bigint = assigned_by) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)))) WITH CHECK ((((current_setting('app.user_id'::text, true))::bigint = reviewer_id) OR ((current_setting('app.user_id'::text, true))::bigint = assigned_by) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: scientific_reviews; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.scientific_reviews ENABLE ROW LEVEL SECURITY;

--
-- Name: scientific_reviews scientific_reviews_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY scientific_reviews_insert ON committee.scientific_reviews FOR INSERT WITH CHECK ((((current_setting('app.user_id'::text, true))::bigint = reviewer_id) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: scientific_reviews scientific_reviews_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY scientific_reviews_select ON committee.scientific_reviews FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = reviewer_id)));


--
-- Name: scientific_reviews scientific_reviews_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY scientific_reviews_update ON committee.scientific_reviews FOR UPDATE USING ((system.is_active_row(deleted_at) AND (((current_setting('app.user_id'::text, true))::bigint = reviewer_id) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)))) WITH CHECK ((((current_setting('app.user_id'::text, true))::bigint = reviewer_id) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: announcements; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.announcements ENABLE ROW LEVEL SECURITY;

--
-- Name: announcements announcements_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY announcements_delete ON communication.announcements FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: announcements announcements_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY announcements_insert ON communication.announcements FOR INSERT WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: announcements announcements_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY announcements_select ON communication.announcements FOR SELECT USING (((is_active = true) OR system.fn_is_admin(communication.fn_current_user_id())));


--
-- Name: announcements announcements_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY announcements_update ON communication.announcements FOR UPDATE USING (system.fn_is_admin(communication.fn_current_user_id())) WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: message_attachments; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.message_attachments ENABLE ROW LEVEL SECURITY;

--
-- Name: message_attachments message_attachments_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY message_attachments_delete ON communication.message_attachments FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: message_attachments message_attachments_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY message_attachments_insert ON communication.message_attachments FOR INSERT WITH CHECK (((EXISTS ( SELECT 1
   FROM communication.messages m
  WHERE ((m.id = message_attachments.message_id) AND (m.sender_id = communication.fn_current_user_id())))) OR system.fn_is_admin(communication.fn_current_user_id())));


--
-- Name: message_attachments message_attachments_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY message_attachments_select ON communication.message_attachments FOR SELECT USING (((EXISTS ( SELECT 1
   FROM communication.messages m
  WHERE ((m.id = message_attachments.message_id) AND (m.sender_id = communication.fn_current_user_id())))) OR (EXISTS ( SELECT 1
   FROM communication.message_recipients mr
  WHERE ((mr.message_id = mr.message_id) AND (mr.recipient_id = communication.fn_current_user_id())))) OR system.fn_is_admin(communication.fn_current_user_id())));


--
-- Name: message_attachments message_attachments_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY message_attachments_update ON communication.message_attachments FOR UPDATE USING (system.fn_is_admin(communication.fn_current_user_id())) WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: message_recipients; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.message_recipients ENABLE ROW LEVEL SECURITY;

--
-- Name: message_recipients message_recipients_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY message_recipients_delete ON communication.message_recipients FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: message_recipients message_recipients_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY message_recipients_insert ON communication.message_recipients FOR INSERT WITH CHECK (((EXISTS ( SELECT 1
   FROM communication.messages m
  WHERE ((m.id = message_recipients.message_id) AND (m.sender_id = communication.fn_current_user_id())))) OR system.fn_is_admin(communication.fn_current_user_id())));


--
-- Name: message_recipients message_recipients_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY message_recipients_select ON communication.message_recipients FOR SELECT USING (((recipient_id = communication.fn_current_user_id()) OR system.fn_is_admin(communication.fn_current_user_id())));


--
-- Name: message_recipients message_recipients_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY message_recipients_update ON communication.message_recipients FOR UPDATE USING ((recipient_id = communication.fn_current_user_id())) WITH CHECK ((recipient_id = communication.fn_current_user_id()));


--
-- Name: messages; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: messages messages_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY messages_delete ON communication.messages FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: messages messages_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY messages_insert ON communication.messages FOR INSERT WITH CHECK ((sender_id = communication.fn_current_user_id()));


--
-- Name: messages messages_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY messages_select ON communication.messages FOR SELECT USING (((sender_id = communication.fn_current_user_id()) OR (EXISTS ( SELECT 1
   FROM communication.message_recipients mr
  WHERE ((mr.message_id = messages.id) AND (mr.recipient_id = communication.fn_current_user_id())))) OR system.fn_is_admin(communication.fn_current_user_id())));


--
-- Name: messages messages_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY messages_update ON communication.messages FOR UPDATE USING ((sender_id = communication.fn_current_user_id())) WITH CHECK ((sender_id = communication.fn_current_user_id()));


--
-- Name: notification_channels; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.notification_channels ENABLE ROW LEVEL SECURITY;

--
-- Name: notification_channels notification_channels_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_channels_delete ON communication.notification_channels FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: notification_channels notification_channels_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_channels_insert ON communication.notification_channels FOR INSERT WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: notification_channels notification_channels_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_channels_select ON communication.notification_channels FOR SELECT USING (((is_active = true) OR system.fn_is_admin(communication.fn_current_user_id())));


--
-- Name: notification_channels notification_channels_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_channels_update ON communication.notification_channels FOR UPDATE USING (system.fn_is_admin(communication.fn_current_user_id())) WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: notification_logs; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.notification_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: notification_logs notification_logs_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_logs_delete ON communication.notification_logs FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: notification_logs notification_logs_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_logs_insert ON communication.notification_logs FOR INSERT WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: notification_logs notification_logs_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_logs_select ON communication.notification_logs FOR SELECT USING (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: notification_logs notification_logs_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_logs_update ON communication.notification_logs FOR UPDATE USING (system.fn_is_admin(communication.fn_current_user_id())) WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: notification_templates; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.notification_templates ENABLE ROW LEVEL SECURITY;

--
-- Name: notification_templates notification_templates_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_templates_delete ON communication.notification_templates FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: notification_templates notification_templates_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_templates_insert ON communication.notification_templates FOR INSERT WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: notification_templates notification_templates_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_templates_select ON communication.notification_templates FOR SELECT USING (((is_active = true) OR system.fn_is_admin(communication.fn_current_user_id())));


--
-- Name: notification_templates notification_templates_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_templates_update ON communication.notification_templates FOR UPDATE USING (system.fn_is_admin(communication.fn_current_user_id())) WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: notifications; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.notifications ENABLE ROW LEVEL SECURITY;

--
-- Name: notifications notifications_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notifications_delete ON communication.notifications FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--
-- Name: notifications notifications_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notifications_insert ON communication.notifications FOR INSERT WITH CHECK (((communication.fn_current_user_id() > 0) OR system.fn_is_admin(communication.fn_current_user_id())));


--
-- Name: notifications notifications_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notifications_select ON communication.notifications FOR SELECT USING (((user_id = communication.fn_current_user_id()) OR system.fn_is_admin(communication.fn_current_user_id())));


--
-- Name: notifications notifications_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notifications_update ON communication.notifications FOR UPDATE USING ((user_id = communication.fn_current_user_id())) WITH CHECK ((user_id = communication.fn_current_user_id()));


--
-- Name: applications; Type: ROW SECURITY; Schema: core; Owner: -
--

ALTER TABLE core.applications ENABLE ROW LEVEL SECURITY;

--
-- Name: applications applications_insert_policy; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY applications_insert_policy ON core.applications FOR INSERT WITH CHECK (((submitted_by = (current_setting('app.user_id'::text))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text))::bigint)));


--
-- Name: applications applications_select_policy; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY applications_select_policy ON core.applications FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = submitted_by) OR (system.is_active_row(deleted_at) AND ((EXISTS ( SELECT 1
   FROM committee.review_assignments ra
  WHERE ((ra.application_id = applications.id) AND (ra.reviewer_id = (current_setting('app.user_id'::text, true))::bigint)))) OR (EXISTS ( SELECT 1
   FROM (committee.committee_members cm
     JOIN committee.committees c ON ((cm.committee_id = c.id)))
  WHERE ((cm.user_id = (current_setting('app.user_id'::text, true))::bigint) AND (c.id = applications.target_committee_id))))))));


--
-- Name: applications applications_update_policy; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY applications_update_policy ON core.applications FOR UPDATE USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (system.is_active_row(deleted_at) AND (((current_setting('app.user_id'::text, true))::bigint = submitted_by) OR (EXISTS ( SELECT 1
   FROM committee.review_assignments ra
  WHERE ((ra.application_id = applications.id) AND (ra.reviewer_id = (current_setting('app.user_id'::text, true))::bigint)))))))) WITH CHECK ((((current_setting('app.user_id'::text, true))::bigint = submitted_by) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: projects; Type: ROW SECURITY; Schema: core; Owner: -
--

ALTER TABLE core.projects ENABLE ROW LEVEL SECURITY;

--
-- Name: projects projects_insert_policy; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY projects_insert_policy ON core.projects FOR INSERT WITH CHECK (((principal_investigator_id = (current_setting('app.user_id'::text))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text))::bigint)));


--
-- Name: projects projects_select_policy; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY projects_select_policy ON core.projects FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = principal_investigator_id) OR (system.is_active_row(deleted_at) AND (EXISTS ( SELECT 1
   FROM core.project_team_members ptm
  WHERE ((ptm.project_id = projects.id) AND (ptm.user_id = (current_setting('app.user_id'::text, true))::bigint)))))));


--
-- Name: projects projects_update_policy; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY projects_update_policy ON core.projects FOR UPDATE USING ((system.is_active_row(deleted_at) AND (((current_setting('app.user_id'::text, true))::bigint = principal_investigator_id) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)))) WITH CHECK ((((current_setting('app.user_id'::text, true))::bigint = principal_investigator_id) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: documents; Type: ROW SECURITY; Schema: documents; Owner: -
--

ALTER TABLE documents.documents ENABLE ROW LEVEL SECURITY;

--
-- Name: documents documents_select_policy; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY documents_select_policy ON documents.documents FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = uploaded_by) OR (system.is_active_row(deleted_at) AND (EXISTS ( SELECT 1
   FROM documents.document_access da
  WHERE ((da.document_id = documents.id) AND ((da.user_id = (current_setting('app.user_id'::text, true))::bigint) OR (da.role_id IN ( SELECT ur.role_id
           FROM security.user_roles ur
          WHERE (ur.user_id = (current_setting('app.user_id'::text, true))::bigint))))))))));


--
-- Name: data_sync_jobs; Type: ROW SECURITY; Schema: integration; Owner: -
--

ALTER TABLE integration.data_sync_jobs ENABLE ROW LEVEL SECURITY;

--
-- Name: data_sync_jobs data_sync_jobs_insert; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY data_sync_jobs_insert ON integration.data_sync_jobs FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: data_sync_jobs data_sync_jobs_select; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY data_sync_jobs_select ON integration.data_sync_jobs FOR SELECT USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: data_sync_jobs data_sync_jobs_update; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY data_sync_jobs_update ON integration.data_sync_jobs FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: integration_credentials; Type: ROW SECURITY; Schema: integration; Owner: -
--

ALTER TABLE integration.integration_credentials ENABLE ROW LEVEL SECURITY;

--
-- Name: integration_credentials integration_credentials_delete; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY integration_credentials_delete ON integration.integration_credentials FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: integration_credentials integration_credentials_insert; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY integration_credentials_insert ON integration.integration_credentials FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: integration_credentials integration_credentials_select; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY integration_credentials_select ON integration.integration_credentials FOR SELECT USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: integration_credentials integration_credentials_update; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY integration_credentials_update ON integration.integration_credentials FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: integration_failures; Type: ROW SECURITY; Schema: integration; Owner: -
--

ALTER TABLE integration.integration_failures ENABLE ROW LEVEL SECURITY;

--
-- Name: integration_failures integration_failures_select; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY integration_failures_select ON integration.integration_failures FOR SELECT USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: integration_failures integration_failures_update; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY integration_failures_update ON integration.integration_failures FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: licenses_registry; Type: ROW SECURITY; Schema: reference; Owner: -
--

ALTER TABLE reference.licenses_registry ENABLE ROW LEVEL SECURITY;

--
-- Name: licenses_registry licenses_registry_delete; Type: POLICY; Schema: reference; Owner: -
--

CREATE POLICY licenses_registry_delete ON reference.licenses_registry FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: licenses_registry licenses_registry_insert; Type: POLICY; Schema: reference; Owner: -
--

CREATE POLICY licenses_registry_insert ON reference.licenses_registry FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: licenses_registry licenses_registry_select; Type: POLICY; Schema: reference; Owner: -
--

CREATE POLICY licenses_registry_select ON reference.licenses_registry FOR SELECT USING (true);


--
-- Name: licenses_registry licenses_registry_update; Type: POLICY; Schema: reference; Owner: -
--

CREATE POLICY licenses_registry_update ON reference.licenses_registry FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: corrective_actions; Type: ROW SECURITY; Schema: safety; Owner: -
--

ALTER TABLE safety.corrective_actions ENABLE ROW LEVEL SECURITY;

--
-- Name: corrective_actions corrective_actions_select; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY corrective_actions_select ON safety.corrective_actions FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = assigned_to)));


--
-- Name: risk_incidents; Type: ROW SECURITY; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_incidents ENABLE ROW LEVEL SECURITY;

--
-- Name: risk_incidents risk_incidents_select; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY risk_incidents_select ON safety.risk_incidents FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = reported_by)));


--
-- Name: risk_mitigations; Type: ROW SECURITY; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_mitigations ENABLE ROW LEVEL SECURITY;

--
-- Name: risk_mitigations risk_mitigations_select; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY risk_mitigations_select ON safety.risk_mitigations FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = responsible_party)));


--
-- Name: risk_register; Type: ROW SECURITY; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_register ENABLE ROW LEVEL SECURITY;

--
-- Name: risk_register risk_register_select; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY risk_register_select ON safety.risk_register FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = owner_id) OR ((current_setting('app.user_id'::text, true))::bigint = identified_by)));


--
-- Name: password_reset_tokens; Type: ROW SECURITY; Schema: security; Owner: -
--

ALTER TABLE security.password_reset_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: password_reset_tokens password_reset_tokens_insert; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY password_reset_tokens_insert ON security.password_reset_tokens FOR INSERT WITH CHECK ((((current_setting('app.user_id'::text, true))::bigint = 0) OR (user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: password_reset_tokens password_reset_tokens_select; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY password_reset_tokens_select ON security.password_reset_tokens FOR SELECT USING ((((current_setting('app.user_id'::text, true))::bigint = 0) OR (user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: password_reset_tokens password_reset_tokens_update; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY password_reset_tokens_update ON security.password_reset_tokens FOR UPDATE USING (((user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint))) WITH CHECK (((user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: user_responsibilities; Type: ROW SECURITY; Schema: security; Owner: -
--

ALTER TABLE security.user_responsibilities ENABLE ROW LEVEL SECURITY;

--
-- Name: user_responsibilities user_responsibilities_delete; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY user_responsibilities_delete ON security.user_responsibilities FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: user_responsibilities user_responsibilities_insert; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY user_responsibilities_insert ON security.user_responsibilities FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: user_responsibilities user_responsibilities_select; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY user_responsibilities_select ON security.user_responsibilities FOR SELECT USING (((user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: user_responsibilities user_responsibilities_update; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY user_responsibilities_update ON security.user_responsibilities FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: users; Type: ROW SECURITY; Schema: security; Owner: -
--

ALTER TABLE security.users ENABLE ROW LEVEL SECURITY;

--
-- Name: users users_insert_policy; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY users_insert_policy ON security.users FOR INSERT WITH CHECK ((((current_setting('app.user_id'::text, true))::bigint = 0) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: users users_select_policy; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY users_select_policy ON security.users FOR SELECT USING ((((current_setting('app.user_id'::text, true))::bigint = 0) OR (id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: users users_update_policy; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY users_update_policy ON security.users FOR UPDATE USING (((id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint))) WITH CHECK (((id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: saved_searches; Type: ROW SECURITY; Schema: system; Owner: -
--

ALTER TABLE system.saved_searches ENABLE ROW LEVEL SECURITY;

--
-- Name: saved_searches saved_searches_delete; Type: POLICY; Schema: system; Owner: -
--

CREATE POLICY saved_searches_delete ON system.saved_searches FOR DELETE USING (((user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: saved_searches saved_searches_insert; Type: POLICY; Schema: system; Owner: -
--

CREATE POLICY saved_searches_insert ON system.saved_searches FOR INSERT WITH CHECK (((user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: saved_searches saved_searches_select; Type: POLICY; Schema: system; Owner: -
--

CREATE POLICY saved_searches_select ON system.saved_searches FOR SELECT USING (((user_id = (current_setting('app.user_id'::text, true))::bigint) OR (is_shared = true) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: saved_searches saved_searches_update; Type: POLICY; Schema: system; Owner: -
--

CREATE POLICY saved_searches_update ON system.saved_searches FOR UPDATE USING (((user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: search_audit; Type: ROW SECURITY; Schema: system; Owner: -
--

ALTER TABLE system.search_audit ENABLE ROW LEVEL SECURITY;

--
-- Name: search_audit search_audit_select; Type: POLICY; Schema: system; Owner: -
--

CREATE POLICY search_audit_select ON system.search_audit FOR SELECT USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: workflow_events; Type: ROW SECURITY; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_events ENABLE ROW LEVEL SECURITY;

--
-- Name: workflow_events workflow_events_select; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_events_select ON workflow.workflow_events FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (EXISTS ( SELECT 1
   FROM workflow.workflow_instances wi
  WHERE ((wi.id = workflow_events.workflow_instance_id) AND system.is_active_row(wi.deleted_at) AND ((((wi.entity_type)::text = 'Application'::text) AND (wi.entity_id IN ( SELECT applications.id
           FROM core.applications
          WHERE (applications.submitted_by = (current_setting('app.user_id'::text, true))::bigint)))) OR (((wi.entity_type)::text = 'Application'::text) AND (EXISTS ( SELECT 1
           FROM committee.review_assignments ra
          WHERE ((ra.application_id = wi.entity_id) AND (ra.reviewer_id = (current_setting('app.user_id'::text, true))::bigint)))))))))));


--
-- Name: workflow_instances; Type: ROW SECURITY; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_instances ENABLE ROW LEVEL SECURITY;

--
-- Name: workflow_instances workflow_instances_insert; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_instances_insert ON workflow.workflow_instances FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: workflow_instances workflow_instances_select; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_instances_select ON workflow.workflow_instances FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (system.is_active_row(deleted_at) AND ((((entity_type)::text = 'Application'::text) AND (entity_id IN ( SELECT applications.id
   FROM core.applications
  WHERE (applications.submitted_by = (current_setting('app.user_id'::text, true))::bigint)))) OR (((entity_type)::text = 'Application'::text) AND (EXISTS ( SELECT 1
   FROM committee.review_assignments ra
  WHERE ((ra.application_id = workflow_instances.entity_id) AND (ra.reviewer_id = (current_setting('app.user_id'::text, true))::bigint)))))))));


--
-- Name: workflow_instances workflow_instances_update; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_instances_update ON workflow.workflow_instances FOR UPDATE USING ((system.is_active_row(deleted_at) AND system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint))) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: workflow_schedulers; Type: ROW SECURITY; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_schedulers ENABLE ROW LEVEL SECURITY;

--
-- Name: workflow_schedulers workflow_schedulers_insert; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_schedulers_insert ON workflow.workflow_schedulers FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: workflow_schedulers workflow_schedulers_select; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_schedulers_select ON workflow.workflow_schedulers FOR SELECT USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: workflow_schedulers workflow_schedulers_update; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_schedulers_update ON workflow.workflow_schedulers FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: workflow_tasks; Type: ROW SECURITY; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_tasks ENABLE ROW LEVEL SECURITY;

--
-- Name: workflow_tasks workflow_tasks_insert; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_tasks_insert ON workflow.workflow_tasks FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: workflow_tasks workflow_tasks_select; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_tasks_select ON workflow.workflow_tasks FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = assigned_to)));


--
-- Name: workflow_tasks workflow_tasks_update; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_tasks_update ON workflow.workflow_tasks FOR UPDATE USING ((system.is_active_row(deleted_at) AND (((current_setting('app.user_id'::text, true))::bigint = assigned_to) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)))) WITH CHECK ((((current_setting('app.user_id'::text, true))::bigint = assigned_to) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--
-- Name: workflow_triggers; Type: ROW SECURITY; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_triggers ENABLE ROW LEVEL SECURITY;

--
-- Name: workflow_triggers workflow_triggers_insert; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_triggers_insert ON workflow.workflow_triggers FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: workflow_triggers workflow_triggers_select; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_triggers_select ON workflow.workflow_triggers FOR SELECT USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- Name: workflow_triggers workflow_triggers_update; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_triggers_update ON workflow.workflow_triggers FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--
-- PostgreSQL database dump complete
--

\unrestrict BeJiYhic2kgYW2GrXabhB8bWY1tIxtXXSgbK4HPXmOTGqSJBJG88RgBAWywSqeI

