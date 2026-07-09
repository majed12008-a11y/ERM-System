-- =========================================================================
-- 07_triggers.sql — All triggers (225 total, 6 test_rls excluded)
-- Auto-generated from canonical extraction
-- =========================================================================

-- =========================================================================
-- committee — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: accreditation_assessment_items trigger_audit_accreditation_assessment_items; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_accreditation_assessment_items AFTER INSERT OR DELETE OR UPDATE ON committee.accreditation_assessment_items FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: accreditation_assessments trigger_audit_accreditation_assessments; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_accreditation_assessments AFTER INSERT OR DELETE OR UPDATE ON committee.accreditation_assessments FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: accreditation_conditions trigger_audit_accreditation_conditions; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_accreditation_conditions AFTER INSERT OR DELETE OR UPDATE ON committee.accreditation_conditions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: accreditation_cycle_metrics trigger_audit_accreditation_cycle_metrics; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_accreditation_cycle_metrics AFTER INSERT OR DELETE OR UPDATE ON committee.accreditation_cycle_metrics FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: accreditation_cycles trigger_audit_accreditation_cycles; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_accreditation_cycles AFTER INSERT OR DELETE OR UPDATE ON committee.accreditation_cycles FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: accreditation_decisions trigger_audit_accreditation_decisions; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_accreditation_decisions AFTER INSERT OR DELETE OR UPDATE ON committee.accreditation_decisions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: accreditation_evidence trigger_audit_accreditation_evidence; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_accreditation_evidence AFTER INSERT OR DELETE OR UPDATE ON committee.accreditation_evidence FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: accreditation_standard_versions trigger_audit_accreditation_standard_versions; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_accreditation_standard_versions AFTER INSERT OR DELETE OR UPDATE ON committee.accreditation_standard_versions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: accreditation_standards trigger_audit_accreditation_standards; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_accreditation_standards AFTER INSERT OR DELETE OR UPDATE ON committee.accreditation_standards FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: agenda_items trigger_audit_agenda_items; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_agenda_items AFTER INSERT OR DELETE OR UPDATE ON committee.agenda_items FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: application_conditions trigger_audit_application_conditions; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_application_conditions AFTER INSERT OR DELETE OR UPDATE ON committee.application_conditions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


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

-- Name: consent_review_comments trigger_audit_consent_review_comments; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_consent_review_comments AFTER INSERT OR DELETE OR UPDATE ON committee.consent_review_comments FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: consent_template_versions trigger_audit_consent_template_versions; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_consent_template_versions AFTER INSERT OR DELETE OR UPDATE ON committee.consent_template_versions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: consent_templates trigger_audit_consent_templates; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_consent_templates AFTER INSERT OR DELETE OR UPDATE ON committee.consent_templates FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: ethics_reviews trigger_audit_ethics_reviews; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_ethics_reviews AFTER INSERT OR DELETE OR UPDATE ON committee.ethics_reviews FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: ethics_risk_assessments trigger_audit_ethics_risk_assessments; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_ethics_risk_assessments AFTER INSERT OR DELETE OR UPDATE ON committee.ethics_risk_assessments FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: ethics_risk_items trigger_audit_ethics_risk_items; Type: TRIGGER; Schema: committee; Owner: -
--

CREATE TRIGGER trigger_audit_ethics_risk_items AFTER INSERT OR DELETE OR UPDATE ON committee.ethics_risk_items FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


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



-- =========================================================================
-- communication — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
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



-- =========================================================================
-- core — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
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

-- Name: application_consents trigger_audit_application_consents; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER trigger_audit_application_consents AFTER INSERT OR DELETE OR UPDATE ON core.application_consents FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


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



-- =========================================================================
-- documents — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: approval_certificate_documents trg_audit_approval_certificate_documents; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trg_audit_approval_certificate_documents AFTER INSERT OR DELETE OR UPDATE ON documents.approval_certificate_documents FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: approval_certificates trg_audit_approval_certificates; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trg_audit_approval_certificates AFTER INSERT OR DELETE OR UPDATE ON documents.approval_certificates FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: certificate_verification_log trg_audit_certificate_verification_log; Type: TRIGGER; Schema: documents; Owner: -
--

CREATE TRIGGER trg_audit_certificate_verification_log AFTER INSERT OR DELETE OR UPDATE ON documents.certificate_verification_log FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


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



-- =========================================================================
-- integration — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
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



-- =========================================================================
-- monitoring — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
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



-- =========================================================================
-- reference — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: academic_titles trigger_audit_academic_titles; Type: TRIGGER; Schema: reference; Owner: -
--

CREATE TRIGGER trigger_audit_academic_titles AFTER INSERT OR DELETE OR UPDATE ON reference.academic_titles FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


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



-- =========================================================================
-- reporting — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
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



-- =========================================================================
-- safety — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
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



-- =========================================================================
-- security — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
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

ALTER TABLE security.users DISABLE TRIGGER trigger_audit_users;


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



-- =========================================================================
-- system — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
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



-- =========================================================================
-- workflow — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
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




