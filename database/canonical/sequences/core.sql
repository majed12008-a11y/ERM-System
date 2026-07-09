-- =========================================================================
-- core — SEQUENCE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: amendment_requests_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.amendment_requests ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.amendment_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: application_amendments_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.application_amendments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.application_amendments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: application_checklists_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.application_checklists ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.application_checklists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: application_consents_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.application_consents ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.application_consents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: application_history_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.application_history ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.application_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: application_sections_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.application_sections ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.application_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: application_validations_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.application_validations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.application_validations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: application_versions_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.application_versions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.application_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: applications_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.applications ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: closure_requests_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.closure_requests ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.closure_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: project_attachments_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_attachments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: project_funding_sources_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_funding_sources ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_funding_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: project_keywords_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_keywords ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_keywords_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: project_site_investigators_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_site_investigators ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_site_investigators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: project_sites_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_sites ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: project_status_history_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_status_history ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_status_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: project_tags_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_tags ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: project_team_members_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_team_members ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_team_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: project_versions_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_versions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: projects_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.projects ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: renewal_requests_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.renewal_requests ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.renewal_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: research_categories_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.research_categories ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.research_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: research_population_links_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.research_population_links ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.research_population_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: risk_classifications_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.risk_classifications ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.risk_classifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: vulnerable_populations_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.vulnerable_populations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.vulnerable_populations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--


