-- =========================================================================
-- 08_policies.sql — RLS policies (256 policies, 77 RLS enables)
-- Auto-generated from canonical extraction
-- =========================================================================

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



-- =========================================================================
-- communication — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
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

-- Name: notification_logs notification_logs_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_logs_delete ON communication.notification_logs FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: notification_logs notification_logs_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_logs_insert ON communication.notification_logs FOR INSERT WITH CHECK ((system.fn_is_admin(communication.fn_current_user_id()) OR (communication.fn_current_user_id() > 0) OR (CURRENT_USER = 'ethics_app'::name)));


--

-- Name: notification_logs notification_logs_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_logs_select ON communication.notification_logs FOR SELECT USING (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: notification_logs notification_logs_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY notification_logs_update ON communication.notification_logs FOR UPDATE USING (system.fn_is_admin(communication.fn_current_user_id())) WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


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

-- Name: user_notification_preferences pref_admin_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY pref_admin_delete ON communication.user_notification_preferences FOR DELETE USING (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: user_notification_preferences pref_admin_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY pref_admin_insert ON communication.user_notification_preferences FOR INSERT WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: user_notification_preferences pref_admin_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY pref_admin_select ON communication.user_notification_preferences FOR SELECT USING (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: user_notification_preferences pref_admin_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY pref_admin_update ON communication.user_notification_preferences FOR UPDATE USING (system.fn_is_admin(communication.fn_current_user_id())) WITH CHECK (system.fn_is_admin(communication.fn_current_user_id()));


--

-- Name: user_notification_preferences pref_delete; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY pref_delete ON communication.user_notification_preferences FOR DELETE USING ((user_id = communication.fn_current_user_id()));


--

-- Name: user_notification_preferences pref_insert; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY pref_insert ON communication.user_notification_preferences FOR INSERT WITH CHECK ((user_id = communication.fn_current_user_id()));


--

-- Name: user_notification_preferences pref_select; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY pref_select ON communication.user_notification_preferences FOR SELECT USING ((user_id = communication.fn_current_user_id()));


--

-- Name: user_notification_preferences pref_update; Type: POLICY; Schema: communication; Owner: -
--

CREATE POLICY pref_update ON communication.user_notification_preferences FOR UPDATE USING ((user_id = communication.fn_current_user_id())) WITH CHECK ((user_id = communication.fn_current_user_id()));


--


-- =========================================================================
-- communication — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: announcements; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.announcements ENABLE ROW LEVEL SECURITY;

--

-- Name: message_attachments; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.message_attachments ENABLE ROW LEVEL SECURITY;

--

-- Name: message_recipients; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.message_recipients ENABLE ROW LEVEL SECURITY;

--

-- Name: messages; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.messages ENABLE ROW LEVEL SECURITY;

--

-- Name: notification_channels; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.notification_channels ENABLE ROW LEVEL SECURITY;

--

-- Name: notification_logs; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.notification_logs ENABLE ROW LEVEL SECURITY;

--

-- Name: notification_templates; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.notification_templates ENABLE ROW LEVEL SECURITY;

--

-- Name: notifications; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.notifications ENABLE ROW LEVEL SECURITY;

--

-- Name: user_notification_preferences; Type: ROW SECURITY; Schema: communication; Owner: -
--

ALTER TABLE communication.user_notification_preferences ENABLE ROW LEVEL SECURITY;

--



-- =========================================================================
-- core — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: application_consents app_consents_delete; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY app_consents_delete ON core.application_consents FOR DELETE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: application_consents app_consents_insert; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY app_consents_insert ON core.application_consents FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: application_consents app_consents_select; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY app_consents_select ON core.application_consents FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (EXISTS ( SELECT 1
   FROM committee.review_assignments ra
  WHERE ((ra.application_id = application_consents.application_id) AND (ra.reviewer_id = (current_setting('app.user_id'::text, true))::bigint) AND (ra.deleted_at IS NULL)))) OR (EXISTS ( SELECT 1
   FROM core.applications a
  WHERE ((a.id = application_consents.application_id) AND (a.submitted_by = (current_setting('app.user_id'::text, true))::bigint))))));


--

-- Name: application_consents app_consents_update; Type: POLICY; Schema: core; Owner: -
--

CREATE POLICY app_consents_update ON core.application_consents FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


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


-- =========================================================================
-- core — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: application_consents; Type: ROW SECURITY; Schema: core; Owner: -
--

ALTER TABLE core.application_consents ENABLE ROW LEVEL SECURITY;

--

-- Name: applications; Type: ROW SECURITY; Schema: core; Owner: -
--

ALTER TABLE core.applications ENABLE ROW LEVEL SECURITY;

--

-- Name: projects; Type: ROW SECURITY; Schema: core; Owner: -
--

ALTER TABLE core.projects ENABLE ROW LEVEL SECURITY;

--



-- =========================================================================
-- documents — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: approval_certificates cert_delete; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY cert_delete ON documents.approval_certificates FOR DELETE USING (false);


--

-- Name: approval_certificate_documents cert_doc_delete; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY cert_doc_delete ON documents.approval_certificate_documents FOR DELETE USING (false);


--

-- Name: approval_certificate_documents cert_doc_insert; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY cert_doc_insert ON documents.approval_certificate_documents FOR INSERT WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));


--

-- Name: approval_certificate_documents cert_doc_select; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY cert_doc_select ON documents.approval_certificate_documents FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (certificate_id IN ( SELECT approval_certificates.id
   FROM documents.approval_certificates
  WHERE (approval_certificates.issued_to_user_id = (current_setting('app.user_id'::text, true))::bigint))) OR (certificate_id IN ( SELECT ac2.id
   FROM documents.approval_certificates ac2
  WHERE system.fn_is_committee_member_for_application((current_setting('app.user_id'::text, true))::bigint, ac2.application_id)))));


--

-- Name: approval_certificates cert_insert; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY cert_insert ON documents.approval_certificates FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text))::bigint) AND (issued_by_user_id = (current_setting('app.user_id'::text))::bigint)));


--

-- Name: approval_certificates cert_select; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY cert_select ON documents.approval_certificates FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (issued_to_user_id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_committee_member_for_application((current_setting('app.user_id'::text, true))::bigint, application_id)));


--

-- Name: approval_certificates cert_update; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY cert_update ON documents.approval_certificates FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint)) WITH CHECK ((((status)::text = ANY (ARRAY[('REVOKED'::character varying)::text, ('SUPERSEDED'::character varying)::text, ('GENERATING'::character varying)::text])) AND system.fn_is_admin((current_setting('app.user_id'::text))::bigint)));


--

-- Name: documents documents_insert_policy; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY documents_insert_policy ON documents.documents FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text))::bigint) OR ((uploaded_by = (current_setting('app.user_id'::text))::bigint) AND (((entity_type)::text IS DISTINCT FROM 'Application'::text) OR (entity_id IS NULL) OR (EXISTS ( SELECT 1
   FROM core.applications a
  WHERE ((a.id = documents.entity_id) AND (a.submitted_by = (current_setting('app.user_id'::text))::bigint) AND (a.deleted_at IS NULL))))))));


--

-- Name: documents documents_select_policy; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY documents_select_policy ON documents.documents FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = uploaded_by) OR (system.is_active_row(deleted_at) AND (EXISTS ( SELECT 1
   FROM documents.document_access da
  WHERE ((da.document_id = documents.id) AND ((da.user_id = (current_setting('app.user_id'::text, true))::bigint) OR (da.role_id IN ( SELECT ur.role_id
           FROM security.user_roles ur
          WHERE (ur.user_id = (current_setting('app.user_id'::text, true))::bigint))))))))));


--

-- Name: documents documents_update_policy; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY documents_update_policy ON documents.documents FOR UPDATE USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = uploaded_by))) WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = uploaded_by)));


--

-- Name: certificate_verification_log ver_log_insert; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY ver_log_insert ON documents.certificate_verification_log FOR INSERT WITH CHECK (true);


--

-- Name: certificate_verification_log ver_log_select; Type: POLICY; Schema: documents; Owner: -
--

CREATE POLICY ver_log_select ON documents.certificate_verification_log FOR SELECT USING (true);


--


-- =========================================================================
-- documents — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: approval_certificate_documents; Type: ROW SECURITY; Schema: documents; Owner: -
--

ALTER TABLE documents.approval_certificate_documents ENABLE ROW LEVEL SECURITY;

--

-- Name: approval_certificates; Type: ROW SECURITY; Schema: documents; Owner: -
--

ALTER TABLE documents.approval_certificates ENABLE ROW LEVEL SECURITY;

--

-- Name: certificate_verification_log; Type: ROW SECURITY; Schema: documents; Owner: -
--

ALTER TABLE documents.certificate_verification_log ENABLE ROW LEVEL SECURITY;

--

-- Name: documents; Type: ROW SECURITY; Schema: documents; Owner: -
--

ALTER TABLE documents.documents ENABLE ROW LEVEL SECURITY;

--



-- =========================================================================
-- integration — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
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

-- Name: integration_failures integration_failures_select; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY integration_failures_select ON integration.integration_failures FOR SELECT USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--

-- Name: integration_failures integration_failures_update; Type: POLICY; Schema: integration; Owner: -
--

CREATE POLICY integration_failures_update ON integration.integration_failures FOR UPDATE USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)) WITH CHECK (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--


-- =========================================================================
-- integration — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: data_sync_jobs; Type: ROW SECURITY; Schema: integration; Owner: -
--

ALTER TABLE integration.data_sync_jobs ENABLE ROW LEVEL SECURITY;

--

-- Name: integration_credentials; Type: ROW SECURITY; Schema: integration; Owner: -
--

ALTER TABLE integration.integration_credentials ENABLE ROW LEVEL SECURITY;

--

-- Name: integration_failures; Type: ROW SECURITY; Schema: integration; Owner: -
--

ALTER TABLE integration.integration_failures ENABLE ROW LEVEL SECURITY;

--



-- =========================================================================
-- monitoring — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: compliance_reviews compliance_reviews_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY compliance_reviews_delete_policy ON monitoring.compliance_reviews FOR DELETE USING (system.fn_is_admin());


--

-- Name: compliance_reviews compliance_reviews_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY compliance_reviews_insert_policy ON monitoring.compliance_reviews FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: compliance_reviews compliance_reviews_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY compliance_reviews_select_policy ON monitoring.compliance_reviews FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: compliance_reviews compliance_reviews_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY compliance_reviews_update_policy ON monitoring.compliance_reviews FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: corrective_actions corrective_actions_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY corrective_actions_delete_policy ON monitoring.corrective_actions FOR DELETE USING (system.fn_is_admin());


--

-- Name: corrective_actions corrective_actions_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY corrective_actions_insert_policy ON monitoring.corrective_actions FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: corrective_actions corrective_actions_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY corrective_actions_select_policy ON monitoring.corrective_actions FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: corrective_actions corrective_actions_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY corrective_actions_update_policy ON monitoring.corrective_actions FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: deviations deviations_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY deviations_delete_policy ON monitoring.deviations FOR DELETE USING (system.fn_is_admin());


--

-- Name: deviations deviations_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY deviations_insert_policy ON monitoring.deviations FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: deviations deviations_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY deviations_select_policy ON monitoring.deviations FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: deviations deviations_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY deviations_update_policy ON monitoring.deviations FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: inspection_reports inspection_reports_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY inspection_reports_delete_policy ON monitoring.inspection_reports FOR DELETE USING (system.fn_is_admin());


--

-- Name: inspection_reports inspection_reports_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY inspection_reports_insert_policy ON monitoring.inspection_reports FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: inspection_reports inspection_reports_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY inspection_reports_select_policy ON monitoring.inspection_reports FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: inspection_reports inspection_reports_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY inspection_reports_update_policy ON monitoring.inspection_reports FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: inspections inspections_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY inspections_delete_policy ON monitoring.inspections FOR DELETE USING (system.fn_is_admin());


--

-- Name: inspections inspections_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY inspections_insert_policy ON monitoring.inspections FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: inspections inspections_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY inspections_select_policy ON monitoring.inspections FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: inspections inspections_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY inspections_update_policy ON monitoring.inspections FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: monitoring_findings monitoring_findings_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_findings_delete_policy ON monitoring.monitoring_findings FOR DELETE USING (system.fn_is_admin());


--

-- Name: monitoring_findings monitoring_findings_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_findings_insert_policy ON monitoring.monitoring_findings FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: monitoring_findings monitoring_findings_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_findings_select_policy ON monitoring.monitoring_findings FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: monitoring_findings monitoring_findings_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_findings_update_policy ON monitoring.monitoring_findings FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: monitoring_plans monitoring_plans_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_plans_delete_policy ON monitoring.monitoring_plans FOR DELETE USING (system.fn_is_admin());


--

-- Name: monitoring_plans monitoring_plans_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_plans_insert_policy ON monitoring.monitoring_plans FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: monitoring_plans monitoring_plans_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_plans_select_policy ON monitoring.monitoring_plans FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: monitoring_plans monitoring_plans_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_plans_update_policy ON monitoring.monitoring_plans FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: monitoring_visits monitoring_visits_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_visits_delete_policy ON monitoring.monitoring_visits FOR DELETE USING (system.fn_is_admin());


--

-- Name: monitoring_visits monitoring_visits_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_visits_insert_policy ON monitoring.monitoring_visits FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: monitoring_visits monitoring_visits_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_visits_select_policy ON monitoring.monitoring_visits FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: monitoring_visits monitoring_visits_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY monitoring_visits_update_policy ON monitoring.monitoring_visits FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: preventive_actions preventive_actions_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY preventive_actions_delete_policy ON monitoring.preventive_actions FOR DELETE USING (system.fn_is_admin());


--

-- Name: preventive_actions preventive_actions_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY preventive_actions_insert_policy ON monitoring.preventive_actions FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: preventive_actions preventive_actions_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY preventive_actions_select_policy ON monitoring.preventive_actions FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: preventive_actions preventive_actions_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY preventive_actions_update_policy ON monitoring.preventive_actions FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: protocol_violations protocol_violations_delete_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY protocol_violations_delete_policy ON monitoring.protocol_violations FOR DELETE USING (system.fn_is_admin());


--

-- Name: protocol_violations protocol_violations_insert_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY protocol_violations_insert_policy ON monitoring.protocol_violations FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: protocol_violations protocol_violations_select_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY protocol_violations_select_policy ON monitoring.protocol_violations FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: protocol_violations protocol_violations_update_policy; Type: POLICY; Schema: monitoring; Owner: -
--

CREATE POLICY protocol_violations_update_policy ON monitoring.protocol_violations FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--


-- =========================================================================
-- monitoring — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: compliance_reviews; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.compliance_reviews ENABLE ROW LEVEL SECURITY;

--

-- Name: corrective_actions; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.corrective_actions ENABLE ROW LEVEL SECURITY;

--

-- Name: deviations; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.deviations ENABLE ROW LEVEL SECURITY;

--

-- Name: inspection_reports; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.inspection_reports ENABLE ROW LEVEL SECURITY;

--

-- Name: inspections; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.inspections ENABLE ROW LEVEL SECURITY;

--

-- Name: monitoring_findings; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.monitoring_findings ENABLE ROW LEVEL SECURITY;

--

-- Name: monitoring_plans; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.monitoring_plans ENABLE ROW LEVEL SECURITY;

--

-- Name: monitoring_visits; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.monitoring_visits ENABLE ROW LEVEL SECURITY;

--

-- Name: preventive_actions; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.preventive_actions ENABLE ROW LEVEL SECURITY;

--

-- Name: protocol_violations; Type: ROW SECURITY; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.protocol_violations ENABLE ROW LEVEL SECURITY;

--



-- =========================================================================
-- reference — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
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


-- =========================================================================
-- reference — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: licenses_registry; Type: ROW SECURITY; Schema: reference; Owner: -
--

ALTER TABLE reference.licenses_registry ENABLE ROW LEVEL SECURITY;

--



-- =========================================================================
-- reporting — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: analytics_snapshots analytics_snapshots_delete_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY analytics_snapshots_delete_policy ON reporting.analytics_snapshots FOR DELETE USING (system.fn_is_admin());


--

-- Name: analytics_snapshots analytics_snapshots_insert_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY analytics_snapshots_insert_policy ON reporting.analytics_snapshots FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: analytics_snapshots analytics_snapshots_select_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY analytics_snapshots_select_policy ON reporting.analytics_snapshots FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: analytics_snapshots analytics_snapshots_update_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY analytics_snapshots_update_policy ON reporting.analytics_snapshots FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: dashboard_widgets dashboard_widgets_delete_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY dashboard_widgets_delete_policy ON reporting.dashboard_widgets FOR DELETE USING (system.fn_is_admin());


--

-- Name: dashboard_widgets dashboard_widgets_insert_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY dashboard_widgets_insert_policy ON reporting.dashboard_widgets FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: dashboard_widgets dashboard_widgets_select_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY dashboard_widgets_select_policy ON reporting.dashboard_widgets FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: dashboard_widgets dashboard_widgets_update_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY dashboard_widgets_update_policy ON reporting.dashboard_widgets FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: kpi_results kpi_results_delete_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY kpi_results_delete_policy ON reporting.kpi_results FOR DELETE USING (system.fn_is_admin());


--

-- Name: kpi_results kpi_results_insert_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY kpi_results_insert_policy ON reporting.kpi_results FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: kpi_results kpi_results_select_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY kpi_results_select_policy ON reporting.kpi_results FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: kpi_results kpi_results_update_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY kpi_results_update_policy ON reporting.kpi_results FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: report_definitions report_definitions_delete_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY report_definitions_delete_policy ON reporting.report_definitions FOR DELETE USING (system.fn_is_admin());


--

-- Name: report_definitions report_definitions_insert_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY report_definitions_insert_policy ON reporting.report_definitions FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: report_definitions report_definitions_select_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY report_definitions_select_policy ON reporting.report_definitions FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: report_definitions report_definitions_update_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY report_definitions_update_policy ON reporting.report_definitions FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--

-- Name: report_executions report_executions_delete_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY report_executions_delete_policy ON reporting.report_executions FOR DELETE USING (system.fn_is_admin());


--

-- Name: report_executions report_executions_insert_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY report_executions_insert_policy ON reporting.report_executions FOR INSERT WITH CHECK (system.fn_is_admin());


--

-- Name: report_executions report_executions_select_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY report_executions_select_policy ON reporting.report_executions FOR SELECT USING ((system.fn_is_admin() OR (EXISTS ( SELECT 1
   FROM security.users u
  WHERE (u.id = system.fn_current_user_id())))));


--

-- Name: report_executions report_executions_update_policy; Type: POLICY; Schema: reporting; Owner: -
--

CREATE POLICY report_executions_update_policy ON reporting.report_executions FOR UPDATE USING (system.fn_is_admin()) WITH CHECK (system.fn_is_admin());


--


-- =========================================================================
-- reporting — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: analytics_snapshots; Type: ROW SECURITY; Schema: reporting; Owner: -
--

ALTER TABLE reporting.analytics_snapshots ENABLE ROW LEVEL SECURITY;

--

-- Name: dashboard_widgets; Type: ROW SECURITY; Schema: reporting; Owner: -
--

ALTER TABLE reporting.dashboard_widgets ENABLE ROW LEVEL SECURITY;

--

-- Name: kpi_results; Type: ROW SECURITY; Schema: reporting; Owner: -
--

ALTER TABLE reporting.kpi_results ENABLE ROW LEVEL SECURITY;

--

-- Name: report_definitions; Type: ROW SECURITY; Schema: reporting; Owner: -
--

ALTER TABLE reporting.report_definitions ENABLE ROW LEVEL SECURITY;

--

-- Name: report_executions; Type: ROW SECURITY; Schema: reporting; Owner: -
--

ALTER TABLE reporting.report_executions ENABLE ROW LEVEL SECURITY;

--



-- =========================================================================
-- safety — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: corrective_actions corrective_actions_insert; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY corrective_actions_insert ON safety.corrective_actions FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = assigned_to)));


--

-- Name: corrective_actions corrective_actions_select; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY corrective_actions_select ON safety.corrective_actions FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = assigned_to)));


--

-- Name: risk_incidents risk_incidents_insert; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY risk_incidents_insert ON safety.risk_incidents FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = reported_by)));


--

-- Name: risk_incidents risk_incidents_select; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY risk_incidents_select ON safety.risk_incidents FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = reported_by)));


--

-- Name: risk_mitigations risk_mitigations_insert; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY risk_mitigations_insert ON safety.risk_mitigations FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = responsible_party)));


--

-- Name: risk_mitigations risk_mitigations_select; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY risk_mitigations_select ON safety.risk_mitigations FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = responsible_party)));


--

-- Name: risk_register risk_register_insert; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY risk_register_insert ON safety.risk_register FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = owner_id) OR ((current_setting('app.user_id'::text, true))::bigint = identified_by)));


--

-- Name: risk_register risk_register_select; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY risk_register_select ON safety.risk_register FOR SELECT USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = owner_id) OR ((current_setting('app.user_id'::text, true))::bigint = identified_by)));


--

-- Name: risk_register risk_register_update; Type: POLICY; Schema: safety; Owner: -
--

CREATE POLICY risk_register_update ON safety.risk_register FOR UPDATE USING ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = owner_id) OR ((current_setting('app.user_id'::text, true))::bigint = identified_by))) WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR ((current_setting('app.user_id'::text, true))::bigint = owner_id) OR ((current_setting('app.user_id'::text, true))::bigint = identified_by)));


--


-- =========================================================================
-- safety — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: corrective_actions; Type: ROW SECURITY; Schema: safety; Owner: -
--

ALTER TABLE safety.corrective_actions ENABLE ROW LEVEL SECURITY;

--

-- Name: risk_incidents; Type: ROW SECURITY; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_incidents ENABLE ROW LEVEL SECURITY;

--

-- Name: risk_mitigations; Type: ROW SECURITY; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_mitigations ENABLE ROW LEVEL SECURITY;

--

-- Name: risk_register; Type: ROW SECURITY; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_register ENABLE ROW LEVEL SECURITY;

--



-- =========================================================================
-- security — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
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

-- Name: users users_insert_policy; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY users_insert_policy ON security.users FOR INSERT WITH CHECK ((((current_setting('app.user_id'::text, true))::bigint = 0) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--

-- Name: users users_select_policy; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY users_select_policy ON security.users FOR SELECT USING (((id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--

-- Name: users users_update_policy; Type: POLICY; Schema: security; Owner: -
--

CREATE POLICY users_update_policy ON security.users FOR UPDATE USING (((id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint))) WITH CHECK (((id = (current_setting('app.user_id'::text, true))::bigint) OR system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint)));


--


-- =========================================================================
-- security — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: password_reset_tokens; Type: ROW SECURITY; Schema: security; Owner: -
--

ALTER TABLE security.password_reset_tokens ENABLE ROW LEVEL SECURITY;

--

-- Name: user_responsibilities; Type: ROW SECURITY; Schema: security; Owner: -
--

ALTER TABLE security.user_responsibilities ENABLE ROW LEVEL SECURITY;

--

-- Name: users; Type: ROW SECURITY; Schema: security; Owner: -
--

ALTER TABLE security.users ENABLE ROW LEVEL SECURITY;

--



-- =========================================================================
-- system — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
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

-- Name: search_audit search_audit_select; Type: POLICY; Schema: system; Owner: -
--

CREATE POLICY search_audit_select ON system.search_audit FOR SELECT USING (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint));


--


-- =========================================================================
-- system — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: saved_searches; Type: ROW SECURITY; Schema: system; Owner: -
--

ALTER TABLE system.saved_searches ENABLE ROW LEVEL SECURITY;

--

-- Name: search_audit; Type: ROW SECURITY; Schema: system; Owner: -
--

ALTER TABLE system.search_audit ENABLE ROW LEVEL SECURITY;

--



-- =========================================================================
-- workflow — POLICY
-- Extracted from live database — auto-generated
-- =========================================================================
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

-- Name: workflow_instances workflow_instances_insert; Type: POLICY; Schema: workflow; Owner: -
--

CREATE POLICY workflow_instances_insert ON workflow.workflow_instances FOR INSERT WITH CHECK ((system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (((entity_type)::text = 'Application'::text) AND (EXISTS ( SELECT 1
   FROM core.applications a
  WHERE ((a.id = workflow_instances.entity_id) AND (a.submitted_by = (current_setting('app.user_id'::text, true))::bigint)))))));


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

CREATE POLICY workflow_instances_update ON workflow.workflow_instances FOR UPDATE USING ((system.is_active_row(deleted_at) AND (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (((entity_type)::text = 'Application'::text) AND (entity_id IN ( SELECT applications.id
   FROM core.applications
  WHERE (applications.submitted_by = (current_setting('app.user_id'::text, true))::bigint)))) OR (((entity_type)::text = 'Application'::text) AND (EXISTS ( SELECT 1
   FROM committee.review_assignments ra
  WHERE ((ra.application_id = workflow_instances.entity_id) AND (ra.reviewer_id = (current_setting('app.user_id'::text, true))::bigint)))))))) WITH CHECK ((system.is_active_row(deleted_at) AND (system.fn_is_admin((current_setting('app.user_id'::text, true))::bigint) OR (((entity_type)::text = 'Application'::text) AND (entity_id IN ( SELECT applications.id
   FROM core.applications
  WHERE (applications.submitted_by = (current_setting('app.user_id'::text, true))::bigint)))))));


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

\unrestrict EfLlh8zaoAZxblLLdcE75DJECOVvXBNZDXOIfd9p47FVIMzCWGvDdoVXLpIxYSn


-- =========================================================================
-- workflow — RLS_ENABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: workflow_events; Type: ROW SECURITY; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_events ENABLE ROW LEVEL SECURITY;

--

-- Name: workflow_instances; Type: ROW SECURITY; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_instances ENABLE ROW LEVEL SECURITY;

--

-- Name: workflow_schedulers; Type: ROW SECURITY; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_schedulers ENABLE ROW LEVEL SECURITY;

--

-- Name: workflow_tasks; Type: ROW SECURITY; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_tasks ENABLE ROW LEVEL SECURITY;

--

-- Name: workflow_triggers; Type: ROW SECURITY; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_triggers ENABLE ROW LEVEL SECURITY;

--




