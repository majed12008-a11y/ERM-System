-- =========================================================================
-- templates — SEQUENCE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: categories_id_seq; Type: SEQUENCE; Schema: templates; Owner: -
--

ALTER TABLE templates.categories ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.categories_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);


--

-- Name: templates_id_seq; Type: SEQUENCE; Schema: templates; Owner: -
--

ALTER TABLE templates.templates ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.templates_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);


--

-- Name: template_versions_id_seq; Type: SEQUENCE; Schema: templates; Owner: -
--

ALTER TABLE templates.template_versions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_versions_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);


--

-- Name: template_localizations_id_seq; Type: SEQUENCE; Schema: templates; Owner: -
--

ALTER TABLE templates.template_localizations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_localizations_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);


--

-- Name: template_variables_id_seq; Type: SEQUENCE; Schema: templates; Owner: -
--

ALTER TABLE templates.template_variables ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_variables_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);


--

-- Name: template_partials_id_seq; Type: SEQUENCE; Schema: templates; Owner: -
--

ALTER TABLE templates.template_partials ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_partials_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);


--

-- Name: template_packages_id_seq; Type: SEQUENCE; Schema: templates; Owner: -
--

ALTER TABLE templates.template_packages ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_packages_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);


--

-- Name: template_package_members_id_seq; Type: SEQUENCE; Schema: templates; Owner: -
--

ALTER TABLE templates.template_package_members ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_package_members_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);


--

-- Name: template_outputs_id_seq; Type: SEQUENCE; Schema: templates; Owner: -
--

ALTER TABLE templates.template_outputs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_outputs_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);


--

-- Name: template_render_jobs_id_seq; Type: SEQUENCE; Schema: templates; Owner: -
--

ALTER TABLE templates.template_render_jobs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_render_jobs_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);


--

-- Name: template_render_history_id_seq; Type: SEQUENCE; Schema: templates; Owner: -
--

ALTER TABLE templates.template_render_history ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_render_history_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);


--

-- Name: template_approval_workflow_id_seq; Type: SEQUENCE; Schema: templates; Owner: -
--

ALTER TABLE templates.template_approval_workflow ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_approval_workflow_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);


--

-- Name: template_usage_statistics_id_seq; Type: SEQUENCE; Schema: templates; Owner: -
--

ALTER TABLE templates.template_usage_statistics ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_usage_statistics_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);


--

-- Name: template_version_audit_id_seq; Type: SEQUENCE; Schema: templates; Owner: -
--

ALTER TABLE templates.template_version_audit ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_version_audit_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);


--

-- Name: template_validation_tests_id_seq; Type: SEQUENCE; Schema: templates; Owner: -
--

ALTER TABLE templates.template_validation_tests ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_validation_tests_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);


--

-- Name: event_template_mapping_id_seq; Type: SEQUENCE; Schema: templates; Owner: -
--

ALTER TABLE templates.event_template_mapping ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.event_template_mapping_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);
