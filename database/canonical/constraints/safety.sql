-- =========================================================================
-- safety — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
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


-- =========================================================================
-- safety — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
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


