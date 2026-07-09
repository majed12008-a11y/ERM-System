-- =========================================================================
-- committee — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: application_conditions app_conditions_delete; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY app_conditions_delete ON committee.application_conditions FOR DELETE USING (false);


--

-- Name: application_conditions app_conditions_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY app_conditions_insert ON committee.application_conditions FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text))::bigint) OR (EXISTS ( SELECT 1
   FROM (core.applications a
     JOIN committee.committee_members cm ON ((cm.committee_id = a.target_committee_id)))
  WHERE ((a.id = application_conditions.application_id) AND (cm.user_id = (current_setting('app.user_id'::text))::bigint) AND (cm.is_active = true))))));


--

-- Name: application_conditions app_conditions_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY app_conditions_select ON committee.application_conditions FOR SELECT USING (((application_id IN ( SELECT applications.id
   FROM core.applications
  WHERE (applications.submitted_by = (current_setting('app.user_id'::text))::bigint))) OR (application_id IN ( SELECT a.id
   FROM core.applications a
  WHERE (a.target_committee_id IN ( SELECT cm.committee_id
           FROM committee.committee_members cm
          WHERE ((cm.user_id = (current_setting('app.user_id'::text))::bigint) AND (cm.is_active = true)))))) OR system.fn_is_admin((current_setting('app.user_id'::text))::bigint)));


--

-- Name: application_conditions app_conditions_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY app_conditions_update ON committee.application_conditions FOR UPDATE USING ((system.fn_is_admin((current_setting('app.user_id'::text))::bigint) OR (EXISTS ( SELECT 1
   FROM (core.applications a
     JOIN committee.committee_members cm ON ((cm.committee_id = a.target_committee_id)))
  WHERE ((a.id = application_conditions.application_id) AND (cm.user_id = (current_setting('app.user_id'::text))::bigint) AND (cm.is_active = true)))))) WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text))::bigint) OR (EXISTS ( SELECT 1
   FROM (core.applications a
     JOIN committee.committee_members cm ON ((cm.committee_id = a.target_committee_id)))
  WHERE ((a.id = application_conditions.application_id) AND (cm.user_id = (current_setting('app.user_id'::text))::bigint) AND (cm.is_active = true))))));


--

-- Name: accreditation_assessment_items assessment_items_delete; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY assessment_items_delete ON committee.accreditation_assessment_items FOR DELETE USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (EXISTS ( SELECT 1
   FROM committee.accreditation_assessments aa
  WHERE ((aa.id = accreditation_assessment_items.assessment_id) AND (aa.assessed_by = (current_setting('app.user_id'::text, true))::bigint))))));


--

-- Name: accreditation_assessment_items assessment_items_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY assessment_items_insert ON committee.accreditation_assessment_items FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM committee.accreditation_assessments aa
  WHERE ((aa.id = accreditation_assessment_items.assessment_id) AND (aa.assessed_by = (current_setting('app.user_id'::text, true))::bigint)))));


--

-- Name: accreditation_assessment_items assessment_items_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY assessment_items_select ON committee.accreditation_assessment_items FOR SELECT USING ((EXISTS ( SELECT 1
   FROM committee.accreditation_assessments aa
  WHERE ((aa.id = accreditation_assessment_items.assessment_id) AND (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (aa.assessed_by = (current_setting('app.user_id'::text, true))::bigint) OR committee.fn_is_admin_or_cycle_creator_or_committee_admin((current_setting('app.user_id'::text, true))::bigint, aa.cycle_id))))));


--

-- Name: accreditation_assessment_items assessment_items_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY assessment_items_update ON committee.accreditation_assessment_items FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM committee.accreditation_assessments aa
  WHERE ((aa.id = accreditation_assessment_items.assessment_id) AND (aa.assessed_by = (current_setting('app.user_id'::text, true))::bigint)))));


--

-- Name: accreditation_assessments assessments_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY assessments_insert ON committee.accreditation_assessments FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: accreditation_assessments assessments_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY assessments_select ON committee.accreditation_assessments FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (assessed_by = (current_setting('app.user_id'::text, true))::bigint) OR ((committee.fn_cycle_created_by(cycle_id) = (current_setting('app.user_id'::text, true))::bigint) OR committee.fn_is_committee_admin((current_setting('app.user_id'::text, true))::bigint, committee.fn_get_cycle_committee_id(cycle_id)))));


--

-- Name: accreditation_assessments assessments_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY assessments_update ON committee.accreditation_assessments FOR UPDATE USING ((assessed_by = (current_setting('app.user_id'::text, true))::bigint)) WITH CHECK ((assessed_by = (current_setting('app.user_id'::text, true))::bigint));


--

-- Name: committee_meetings committee_meetings_insert_policy; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY committee_meetings_insert_policy ON committee.committee_meetings FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: committee_meetings committee_meetings_policy; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY committee_meetings_policy ON committee.committee_meetings FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (system.is_active_row(deleted_at) AND (EXISTS ( SELECT 1
   FROM committee.committee_members cm
  WHERE ((cm.committee_id = committee_meetings.committee_id) AND (cm.user_id = (current_setting('app.user_id'::text, true))::bigint) AND (cm.is_active = true)))))));


--

-- Name: committee_meetings committee_meetings_update_policy; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY committee_meetings_update_policy ON committee.committee_meetings FOR UPDATE USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (EXISTS ( SELECT 1
   FROM committee.committee_members cm
  WHERE ((cm.committee_id = committee_meetings.committee_id) AND (cm.user_id = (current_setting('app.user_id'::text, true))::bigint) AND (cm.is_active = true)))))) WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (EXISTS ( SELECT 1
   FROM committee.committee_members cm
  WHERE ((cm.committee_id = committee_meetings.committee_id) AND (cm.user_id = (current_setting('app.user_id'::text, true))::bigint) AND (cm.is_active = true))))));


--

-- Name: accreditation_conditions conditions_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY conditions_insert ON committee.accreditation_conditions FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: accreditation_conditions conditions_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY conditions_select ON committee.accreditation_conditions FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR committee.fn_is_admin_or_cycle_creator_or_committee_admin((current_setting('app.user_id'::text, true))::bigint, cycle_id) OR committee.fn_is_assessor_for_cycle((current_setting('app.user_id'::text, true))::bigint, cycle_id)));


--

-- Name: accreditation_conditions conditions_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY conditions_update ON committee.accreditation_conditions FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: consent_review_comments consent_review_delete; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY consent_review_delete ON committee.consent_review_comments FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: consent_review_comments consent_review_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY consent_review_insert ON committee.consent_review_comments FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (EXISTS ( SELECT 1
   FROM (committee.review_assignments ra
     JOIN core.application_consents ac ON ((ac.id = consent_review_comments.application_consent_id)))
  WHERE ((ra.application_id = ac.application_id) AND (ra.reviewer_id = (current_setting('app.user_id'::text, true))::bigint) AND ((ra.review_type)::text = 'CONSENT'::text) AND (ra.deleted_at IS NULL))))));


--

-- Name: consent_review_comments consent_review_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY consent_review_select ON committee.consent_review_comments FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (reviewer_id = (current_setting('app.user_id'::text, true))::bigint) OR (EXISTS ( SELECT 1
   FROM (committee.review_assignments ra
     JOIN core.application_consents ac ON ((ac.id = consent_review_comments.application_consent_id)))
  WHERE ((ra.application_id = ac.application_id) AND (ra.reviewer_id = (current_setting('app.user_id'::text, true))::bigint) AND (ra.deleted_at IS NULL))))));


--

-- Name: consent_review_comments consent_review_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY consent_review_update ON committee.consent_review_comments FOR UPDATE USING ((reviewer_id = (current_setting('app.user_id'::text, true))::bigint)) WITH CHECK ((reviewer_id = (current_setting('app.user_id'::text, true))::bigint));


--

-- Name: consent_templates consent_templates_delete; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY consent_templates_delete ON committee.consent_templates FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: consent_templates consent_templates_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY consent_templates_insert ON committee.consent_templates FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: consent_templates consent_templates_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY consent_templates_select ON committee.consent_templates FOR SELECT USING (true);


--

-- Name: consent_templates consent_templates_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY consent_templates_update ON committee.consent_templates FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: consent_template_versions ctv_delete; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY ctv_delete ON committee.consent_template_versions FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: consent_template_versions ctv_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY ctv_insert ON committee.consent_template_versions FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: consent_template_versions ctv_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY ctv_select ON committee.consent_template_versions FOR SELECT USING (true);


--

-- Name: consent_template_versions ctv_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY ctv_update ON committee.consent_template_versions FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: accreditation_cycles cycles_delete; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY cycles_delete ON committee.accreditation_cycles FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: accreditation_cycles cycles_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY cycles_insert ON committee.accreditation_cycles FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR committee.fn_is_committee_admin((current_setting('app.user_id'::text, true))::bigint, committee_id)));


--

-- Name: accreditation_cycles cycles_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY cycles_select ON committee.accreditation_cycles FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (created_by = (current_setting('app.user_id'::text, true))::bigint) OR committee.fn_is_committee_admin((current_setting('app.user_id'::text, true))::bigint, committee_id) OR committee.fn_is_assessor_for_cycle((current_setting('app.user_id'::text, true))::bigint, id)));


--

-- Name: accreditation_cycles cycles_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY cycles_update ON committee.accreditation_cycles FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: accreditation_decisions decisions_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY decisions_insert ON committee.accreditation_decisions FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: accreditation_decisions decisions_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY decisions_select ON committee.accreditation_decisions FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR committee.fn_is_admin_or_cycle_creator_or_committee_admin((current_setting('app.user_id'::text, true))::bigint, cycle_id) OR committee.fn_is_assessor_for_cycle((current_setting('app.user_id'::text, true))::bigint, cycle_id)));


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

-- Name: ethics_risk_assessments ethics_risk_assessments_delete; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY ethics_risk_assessments_delete ON committee.ethics_risk_assessments FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: ethics_risk_assessments ethics_risk_assessments_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY ethics_risk_assessments_insert ON committee.ethics_risk_assessments FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: ethics_risk_assessments ethics_risk_assessments_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY ethics_risk_assessments_select ON committee.ethics_risk_assessments FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (assessed_by = (current_setting('app.user_id'::text, true))::bigint) OR (EXISTS ( SELECT 1
   FROM core.applications a
  WHERE ((a.id = ethics_risk_assessments.application_id) AND ((a.submitted_by = (current_setting('app.user_id'::text, true))::bigint) OR (EXISTS ( SELECT 1
           FROM committee.review_assignments ra
          WHERE ((ra.application_id = a.id) AND (ra.reviewer_id = (current_setting('app.user_id'::text, true))::bigint))))))))));


--

-- Name: ethics_risk_assessments ethics_risk_assessments_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY ethics_risk_assessments_update ON committee.ethics_risk_assessments FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: ethics_risk_items ethics_risk_items_delete; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY ethics_risk_items_delete ON committee.ethics_risk_items FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: ethics_risk_items ethics_risk_items_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY ethics_risk_items_insert ON committee.ethics_risk_items FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: ethics_risk_items ethics_risk_items_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY ethics_risk_items_select ON committee.ethics_risk_items FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (EXISTS ( SELECT 1
   FROM committee.ethics_risk_assessments era
  WHERE ((era.id = ethics_risk_items.assessment_id) AND ((era.assessed_by = (current_setting('app.user_id'::text, true))::bigint) OR (EXISTS ( SELECT 1
           FROM core.applications a
          WHERE ((a.id = era.application_id) AND ((a.submitted_by = (current_setting('app.user_id'::text, true))::bigint) OR (EXISTS ( SELECT 1
                   FROM committee.review_assignments ra
                  WHERE ((ra.application_id = a.id) AND (ra.reviewer_id = (current_setting('app.user_id'::text, true))::bigint))))))))))))));


--

-- Name: ethics_risk_items ethics_risk_items_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY ethics_risk_items_update ON committee.ethics_risk_items FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: accreditation_evidence evidence_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY evidence_insert ON committee.accreditation_evidence FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((uploaded_by = (current_setting('app.user_id'::text, true))::bigint) AND committee.fn_is_committee_admin((current_setting('app.user_id'::text, true))::bigint, committee.fn_get_cycle_committee_id(cycle_id)))));


--

-- Name: accreditation_evidence evidence_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY evidence_select ON committee.accreditation_evidence FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (uploaded_by = (current_setting('app.user_id'::text, true))::bigint) OR committee.fn_is_committee_admin((current_setting('app.user_id'::text, true))::bigint, committee.fn_get_cycle_committee_id(cycle_id)) OR committee.fn_is_assessor_for_cycle((current_setting('app.user_id'::text, true))::bigint, cycle_id)));


--

-- Name: accreditation_evidence evidence_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY evidence_update ON committee.accreditation_evidence FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


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

-- Name: accreditation_cycle_metrics metrics_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY metrics_insert ON committee.accreditation_cycle_metrics FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: accreditation_cycle_metrics metrics_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY metrics_select ON committee.accreditation_cycle_metrics FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR committee.fn_is_admin_or_cycle_creator_or_committee_admin((current_setting('app.user_id'::text, true))::bigint, cycle_id) OR committee.fn_is_assessor_for_cycle((current_setting('app.user_id'::text, true))::bigint, cycle_id)));


--

-- Name: accreditation_cycle_metrics metrics_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY metrics_update ON committee.accreditation_cycle_metrics FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


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

-- Name: accreditation_standards standards_delete; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY standards_delete ON committee.accreditation_standards FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: accreditation_standards standards_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY standards_insert ON committee.accreditation_standards FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: accreditation_standards standards_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY standards_select ON committee.accreditation_standards FOR SELECT USING (true);


--

-- Name: accreditation_standards standards_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY standards_update ON committee.accreditation_standards FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: accreditation_standard_versions stdver_delete; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY stdver_delete ON committee.accreditation_standard_versions FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: accreditation_standard_versions stdver_insert; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY stdver_insert ON committee.accreditation_standard_versions FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: accreditation_standard_versions stdver_select; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY stdver_select ON committee.accreditation_standard_versions FOR SELECT USING (true);


--

-- Name: accreditation_standard_versions stdver_update; Type: POLICY; Schema: committee; Owner: -
--

CREATE POLICY stdver_update ON committee.accreditation_standard_versions FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--


-- =========================================================================
-- committee — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: accreditation_assessment_items; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_assessment_items ENABLE ROW LEVEL SECURITY;

--

-- Name: accreditation_assessments; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_assessments ENABLE ROW LEVEL SECURITY;

--

-- Name: accreditation_conditions; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_conditions ENABLE ROW LEVEL SECURITY;

--

-- Name: accreditation_cycle_metrics; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_cycle_metrics ENABLE ROW LEVEL SECURITY;

--

-- Name: accreditation_cycles; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_cycles ENABLE ROW LEVEL SECURITY;

--

-- Name: accreditation_decisions; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_decisions ENABLE ROW LEVEL SECURITY;

--

-- Name: accreditation_evidence; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_evidence ENABLE ROW LEVEL SECURITY;

--

-- Name: accreditation_standard_versions; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_standard_versions ENABLE ROW LEVEL SECURITY;

--

-- Name: accreditation_standards; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.accreditation_standards ENABLE ROW LEVEL SECURITY;

--

-- Name: application_conditions; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.application_conditions ENABLE ROW LEVEL SECURITY;

--

-- Name: committee_meetings; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.committee_meetings ENABLE ROW LEVEL SECURITY;

--

-- Name: consent_review_comments; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.consent_review_comments ENABLE ROW LEVEL SECURITY;

--

-- Name: consent_template_versions; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.consent_template_versions ENABLE ROW LEVEL SECURITY;

--

-- Name: consent_templates; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.consent_templates ENABLE ROW LEVEL SECURITY;

--

-- Name: ethics_reviews; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.ethics_reviews ENABLE ROW LEVEL SECURITY;

--

-- Name: ethics_risk_assessments; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.ethics_risk_assessments ENABLE ROW LEVEL SECURITY;

--

-- Name: ethics_risk_items; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.ethics_risk_items ENABLE ROW LEVEL SECURITY;

--

-- Name: member_conflicts; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.member_conflicts ENABLE ROW LEVEL SECURITY;

--

-- Name: member_qualifications; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.member_qualifications ENABLE ROW LEVEL SECURITY;

--

-- Name: member_terms; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.member_terms ENABLE ROW LEVEL SECURITY;

--

-- Name: review_assignments; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.review_assignments ENABLE ROW LEVEL SECURITY;

--

-- Name: scientific_reviews; Type: ROW SECURITY; Schema: committee; Owner: -
--

ALTER TABLE committee.scientific_reviews ENABLE ROW LEVEL SECURITY;

--


