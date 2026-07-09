-- =========================================================================
-- safety — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_adverse_events_active; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_adverse_events_active ON safety.adverse_events USING btree (id) WHERE (deleted_at IS NULL);


--

-- Name: idx_adverse_events_application; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_adverse_events_application ON safety.adverse_events USING btree (application_id);


--

-- Name: idx_adverse_events_created_desc; Type: INDEX; Schema: safety; Owner: -
--

CREATE INDEX idx_adverse_events_created_desc ON safety.adverse_events USING btree (created_at DESC);


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


