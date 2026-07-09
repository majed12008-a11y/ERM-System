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


