-- =========================================================================
-- reporting — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_analytics_snapshots_json; Type: INDEX; Schema: reporting; Owner: -
--

CREATE INDEX idx_analytics_snapshots_json ON reporting.analytics_snapshots USING gin (metrics);


--

-- Name: idx_dashboard_widgets_json; Type: INDEX; Schema: reporting; Owner: -
--

CREATE INDEX idx_dashboard_widgets_json ON reporting.dashboard_widgets USING gin (configuration);


--

-- Name: idx_kpi_results_code; Type: INDEX; Schema: reporting; Owner: -
--

CREATE INDEX idx_kpi_results_code ON reporting.kpi_results USING btree (kpi_code);


--

-- Name: idx_mv_committee_perf; Type: INDEX; Schema: reporting; Owner: -
--

CREATE UNIQUE INDEX idx_mv_committee_perf ON reporting.mv_committee_performance USING btree (committee_id, month);


--

-- Name: idx_mv_daily_snapshot; Type: INDEX; Schema: reporting; Owner: -
--

CREATE UNIQUE INDEX idx_mv_daily_snapshot ON reporting.mv_daily_application_snapshot USING btree (snapshot_date, current_status);


--

-- Name: idx_report_executions_report; Type: INDEX; Schema: reporting; Owner: -
--

CREATE INDEX idx_report_executions_report ON reporting.report_executions USING btree (report_id);


--


