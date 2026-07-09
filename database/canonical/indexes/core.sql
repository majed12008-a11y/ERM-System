-- =========================================================================
-- core — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_amendment_requests_status; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_amendment_requests_status ON core.amendment_requests USING btree (request_status);


--

-- Name: idx_app_consents_app; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_app_consents_app ON core.application_consents USING btree (application_id) WHERE (deleted_at IS NULL);


--

-- Name: idx_app_consents_status; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_app_consents_status ON core.application_consents USING btree (status) WHERE (deleted_at IS NULL);


--

-- Name: idx_app_consents_version; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_app_consents_version ON core.application_consents USING btree (consent_version_id) WHERE (deleted_at IS NULL);


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

-- Name: idx_applications_committee; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_committee ON core.applications USING btree (target_committee_id);


--

-- Name: idx_applications_created_at; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_created_at ON core.applications USING btree (created_at DESC);


--

-- Name: idx_applications_created_desc; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_created_desc ON core.applications USING btree (created_at DESC);


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

-- Name: idx_applications_submitted_by; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_submitted_by ON core.applications USING btree (submitted_by);


--

-- Name: idx_applications_submitted_by_created; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_applications_submitted_by_created ON core.applications USING btree (submitted_by, created_at DESC);


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

-- Name: idx_projects_created_desc; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX idx_projects_created_desc ON core.projects USING btree (created_at DESC);


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


