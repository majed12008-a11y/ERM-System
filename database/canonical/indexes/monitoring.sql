-- =========================================================================
-- monitoring — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
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


