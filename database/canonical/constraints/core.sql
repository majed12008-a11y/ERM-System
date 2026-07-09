-- =========================================================================
-- core — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: application_consents application_consents_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_consents
    ADD CONSTRAINT application_consents_pkey PRIMARY KEY (id);


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

-- Name: application_consents uq_app_consent_version; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_consents
    ADD CONSTRAINT uq_app_consent_version UNIQUE (application_id, consent_version_id);


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


-- =========================================================================
-- core — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: application_consents application_consents_application_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_consents
    ADD CONSTRAINT application_consents_application_id_fkey FOREIGN KEY (application_id) REFERENCES core.applications(id);


--

-- Name: application_consents application_consents_consent_version_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_consents
    ADD CONSTRAINT application_consents_consent_version_id_fkey FOREIGN KEY (consent_version_id) REFERENCES committee.consent_template_versions(id);


--

-- Name: application_consents application_consents_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.application_consents
    ADD CONSTRAINT application_consents_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES security.users(id);


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

-- Name: applications fk_applications_committee; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.applications
    ADD CONSTRAINT fk_applications_committee FOREIGN KEY (target_committee_id) REFERENCES committee.committees(id);


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


