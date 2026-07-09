-- =========================================================================
-- reference — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_licenses_registry_user; Type: INDEX; Schema: reference; Owner: -
--

CREATE INDEX idx_licenses_registry_user ON reference.licenses_registry USING btree (user_id);


--

-- Name: idx_licenses_registry_verification; Type: INDEX; Schema: reference; Owner: -
--

CREATE INDEX idx_licenses_registry_verification ON reference.licenses_registry USING btree (verification_status);


--

-- Name: idx_lookup_categories_active; Type: INDEX; Schema: reference; Owner: -
--

CREATE INDEX idx_lookup_categories_active ON reference.lookup_categories USING btree (is_active);


--

-- Name: idx_lookup_values_category; Type: INDEX; Schema: reference; Owner: -
--

CREATE INDEX idx_lookup_values_category ON reference.lookup_values USING btree (category_id);


--


