-- =========================================================================
-- monitoring — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
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


-- =========================================================================
-- monitoring — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
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


