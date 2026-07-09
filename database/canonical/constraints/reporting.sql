-- =========================================================================
-- reporting — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: analytics_snapshots pk_analytics_snapshots; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.analytics_snapshots
    ADD CONSTRAINT pk_analytics_snapshots PRIMARY KEY (id);


--

-- Name: dashboard_widgets pk_dashboard_widgets; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.dashboard_widgets
    ADD CONSTRAINT pk_dashboard_widgets PRIMARY KEY (id);


--

-- Name: kpi_results pk_kpi_results; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.kpi_results
    ADD CONSTRAINT pk_kpi_results PRIMARY KEY (id);


--

-- Name: report_definitions pk_report_definitions; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.report_definitions
    ADD CONSTRAINT pk_report_definitions PRIMARY KEY (id);


--

-- Name: report_executions pk_report_executions; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.report_executions
    ADD CONSTRAINT pk_report_executions PRIMARY KEY (id);


--

-- Name: dashboard_widgets uq_dashboard_widgets; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.dashboard_widgets
    ADD CONSTRAINT uq_dashboard_widgets UNIQUE (widget_code);


--

-- Name: report_definitions uq_report_definitions; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.report_definitions
    ADD CONSTRAINT uq_report_definitions UNIQUE (report_code);


--


-- =========================================================================
-- reporting — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: report_executions fk_report_executions_report; Type: FK CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.report_executions
    ADD CONSTRAINT fk_report_executions_report FOREIGN KEY (report_id) REFERENCES reporting.report_definitions(id);


--

-- Name: report_executions fk_report_executions_user; Type: FK CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.report_executions
    ADD CONSTRAINT fk_report_executions_user FOREIGN KEY (executed_by) REFERENCES security.users(id);


--


