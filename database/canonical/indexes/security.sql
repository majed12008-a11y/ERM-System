-- =========================================================================
-- security — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_access_policy_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_access_policy_active ON security.access_policies USING btree (is_active);


--

-- Name: idx_access_policy_expression; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_access_policy_expression ON security.access_policies USING gin (policy_expression);


--

-- Name: idx_api_keys_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_api_keys_active ON security.api_keys USING btree (is_active);


--

-- Name: idx_api_keys_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_api_keys_user ON security.api_keys USING btree (user_id);


--

-- Name: idx_departments_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_departments_active ON security.departments USING btree (is_active);


--

-- Name: idx_departments_institution; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_departments_institution ON security.departments USING btree (institution_id);


--

-- Name: idx_email_verif_tokens_hash; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_email_verif_tokens_hash ON security.email_verification_tokens USING btree (token_hash);


--

-- Name: idx_email_verif_tokens_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_email_verif_tokens_user ON security.email_verification_tokens USING btree (user_id);


--

-- Name: idx_institution_types_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_institution_types_active ON security.institution_types USING btree (is_active);


--

-- Name: idx_institution_types_name_ar; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_institution_types_name_ar ON security.institution_types USING btree (name_ar);


--

-- Name: idx_institutions_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_institutions_active ON security.institutions USING btree (is_active);


--

-- Name: idx_institutions_name_ar; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_institutions_name_ar ON security.institutions USING btree (name_ar);


--

-- Name: idx_institutions_type; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_institutions_type ON security.institutions USING btree (institution_type_id);


--

-- Name: idx_login_audit_success; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_login_audit_success ON security.login_audit USING btree (success);


--

-- Name: idx_login_audit_time; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_login_audit_time ON security.login_audit USING btree (login_time DESC);


--

-- Name: idx_password_history_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_password_history_user ON security.password_history USING btree (user_id);


--

-- Name: idx_password_reset_tokens_expires; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_password_reset_tokens_expires ON security.password_reset_tokens USING btree (expires_at);


--

-- Name: idx_password_reset_tokens_user_id; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_password_reset_tokens_user_id ON security.password_reset_tokens USING btree (user_id);


--

-- Name: idx_permissions_module; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_permissions_module ON security.permissions USING btree (module_name);


--

-- Name: idx_role_permissions_permission; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_role_permissions_permission ON security.role_permissions USING btree (permission_id);


--

-- Name: idx_roles_active; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_roles_active ON security.roles USING btree (is_active);


--

-- Name: idx_security_events_details; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_security_events_details ON security.security_events USING gin (details);


--

-- Name: idx_security_events_severity; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_security_events_severity ON security.security_events USING btree (severity);


--

-- Name: idx_security_events_time; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_security_events_time ON security.security_events USING btree (event_time DESC);


--

-- Name: idx_sessions_expiry; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_sessions_expiry ON security.sessions USING btree (expires_at);


--

-- Name: idx_sessions_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_sessions_user ON security.sessions USING btree (user_id);


--

-- Name: idx_user_profiles_national_id; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_profiles_national_id ON security.user_profiles USING btree (national_id);


--

-- Name: idx_user_profiles_specialization; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_profiles_specialization ON security.user_profiles USING btree (specialization);


--

-- Name: idx_user_responsibilities_entity; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_responsibilities_entity ON security.user_responsibilities USING btree (entity_type, entity_id);


--

-- Name: idx_user_responsibilities_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_responsibilities_user ON security.user_responsibilities USING btree (user_id);


--

-- Name: idx_user_roles_role; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_roles_role ON security.user_roles USING btree (role_id);


--

-- Name: idx_user_roles_user; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_user_roles_user ON security.user_roles USING btree (user_id);


--

-- Name: idx_users_created_desc; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_users_created_desc ON security.users USING btree (created_at DESC);


--

-- Name: idx_users_department; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_users_department ON security.users USING btree (department_id);


--

-- Name: idx_users_institution; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_users_institution ON security.users USING btree (institution_id);


--

-- Name: idx_users_last_login; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_users_last_login ON security.users USING btree (last_login_at);


--

-- Name: idx_users_status; Type: INDEX; Schema: security; Owner: -
--

CREATE INDEX idx_users_status ON security.users USING btree (status);


--

-- Name: uq_role_permissions_role_perm; Type: INDEX; Schema: security; Owner: -
--

CREATE UNIQUE INDEX uq_role_permissions_role_perm ON security.role_permissions USING btree (role_id, permission_id);


--


