-- =========================================================================
-- security — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: approval_authorities approval_authorities_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.approval_authorities
    ADD CONSTRAINT approval_authorities_pkey PRIMARY KEY (id);


--

-- Name: approval_limits approval_limits_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.approval_limits
    ADD CONSTRAINT approval_limits_pkey PRIMARY KEY (id);


--

-- Name: certificate_revocations certificate_revocations_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.certificate_revocations
    ADD CONSTRAINT certificate_revocations_pkey PRIMARY KEY (id);


--

-- Name: digital_certificates digital_certificates_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.digital_certificates
    ADD CONSTRAINT digital_certificates_pkey PRIMARY KEY (id);


--

-- Name: digital_certificates digital_certificates_serial_number_key; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.digital_certificates
    ADD CONSTRAINT digital_certificates_serial_number_key UNIQUE (serial_number);


--

-- Name: email_verification_tokens email_verification_tokens_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.email_verification_tokens
    ADD CONSTRAINT email_verification_tokens_pkey PRIMARY KEY (id);


--

-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (id);


--

-- Name: access_policies pk_access_policies; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.access_policies
    ADD CONSTRAINT pk_access_policies PRIMARY KEY (id);


--

-- Name: api_keys pk_api_keys; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.api_keys
    ADD CONSTRAINT pk_api_keys PRIMARY KEY (id);


--

-- Name: departments pk_departments; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.departments
    ADD CONSTRAINT pk_departments PRIMARY KEY (id);


--

-- Name: institution_types pk_institution_types; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.institution_types
    ADD CONSTRAINT pk_institution_types PRIMARY KEY (id);


--

-- Name: institutions pk_institutions; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.institutions
    ADD CONSTRAINT pk_institutions PRIMARY KEY (id);


--

-- Name: login_audit pk_login_audit; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.login_audit
    ADD CONSTRAINT pk_login_audit PRIMARY KEY (id);


--

-- Name: password_history pk_password_history; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.password_history
    ADD CONSTRAINT pk_password_history PRIMARY KEY (id);


--

-- Name: permissions pk_permissions; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.permissions
    ADD CONSTRAINT pk_permissions PRIMARY KEY (id);


--

-- Name: responsibility_types pk_responsibility_types; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.responsibility_types
    ADD CONSTRAINT pk_responsibility_types PRIMARY KEY (id);


--

-- Name: roles pk_roles; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.roles
    ADD CONSTRAINT pk_roles PRIMARY KEY (id);


--

-- Name: security_events pk_security_events; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.security_events
    ADD CONSTRAINT pk_security_events PRIMARY KEY (id);


--

-- Name: sessions pk_sessions; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.sessions
    ADD CONSTRAINT pk_sessions PRIMARY KEY (id);


--

-- Name: user_profiles pk_user_profiles; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_profiles
    ADD CONSTRAINT pk_user_profiles PRIMARY KEY (id);


--

-- Name: user_responsibilities pk_user_responsibilities; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT pk_user_responsibilities PRIMARY KEY (id);


--

-- Name: user_roles pk_user_roles; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_roles
    ADD CONSTRAINT pk_user_roles PRIMARY KEY (id);


--

-- Name: users pk_users; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT pk_users PRIMARY KEY (id);


--

-- Name: policy_conditions policy_conditions_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.policy_conditions
    ADD CONSTRAINT policy_conditions_pkey PRIMARY KEY (id);


--

-- Name: policy_rules policy_rules_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.policy_rules
    ADD CONSTRAINT policy_rules_pkey PRIMARY KEY (id);


--

-- Name: role_delegations role_delegations_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.role_delegations
    ADD CONSTRAINT role_delegations_pkey PRIMARY KEY (id);


--

-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--

-- Name: segregation_rules segregation_rules_pkey; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.segregation_rules
    ADD CONSTRAINT segregation_rules_pkey PRIMARY KEY (id);


--

-- Name: access_policies uq_access_policy_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.access_policies
    ADD CONSTRAINT uq_access_policy_code UNIQUE (policy_code);


--

-- Name: departments uq_departments_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.departments
    ADD CONSTRAINT uq_departments_code UNIQUE (institution_id, code);


--

-- Name: institution_types uq_institution_types_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.institution_types
    ADD CONSTRAINT uq_institution_types_code UNIQUE (code);


--

-- Name: institutions uq_institutions_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.institutions
    ADD CONSTRAINT uq_institutions_code UNIQUE (code);


--

-- Name: permissions uq_permissions_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.permissions
    ADD CONSTRAINT uq_permissions_code UNIQUE (permission_code);


--

-- Name: responsibility_types uq_responsibility_types_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.responsibility_types
    ADD CONSTRAINT uq_responsibility_types_code UNIQUE (code);


--

-- Name: roles uq_roles_code; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.roles
    ADD CONSTRAINT uq_roles_code UNIQUE (code);


--

-- Name: sessions uq_session_token; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.sessions
    ADD CONSTRAINT uq_session_token UNIQUE (session_token);


--

-- Name: user_profiles uq_user_profiles_user; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_profiles
    ADD CONSTRAINT uq_user_profiles_user UNIQUE (user_id);


--

-- Name: user_responsibilities uq_user_responsibilities_uuid; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT uq_user_responsibilities_uuid UNIQUE (uuid);


--

-- Name: user_roles uq_user_role; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_roles
    ADD CONSTRAINT uq_user_role UNIQUE (user_id, role_id);


--

-- Name: users uq_users_email; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT uq_users_email UNIQUE (email);


--

-- Name: users uq_users_username; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT uq_users_username UNIQUE (username);


--

-- Name: users uq_users_uuid; Type: CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT uq_users_uuid UNIQUE (uuid);


--


-- =========================================================================
-- security — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: email_verification_tokens email_verification_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.email_verification_tokens
    ADD CONSTRAINT email_verification_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--

-- Name: api_keys fk_api_keys_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.api_keys
    ADD CONSTRAINT fk_api_keys_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--

-- Name: departments fk_departments_institution; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.departments
    ADD CONSTRAINT fk_departments_institution FOREIGN KEY (institution_id) REFERENCES security.institutions(id) ON DELETE CASCADE;


--

-- Name: institutions fk_institutions_type; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.institutions
    ADD CONSTRAINT fk_institutions_type FOREIGN KEY (institution_type_id) REFERENCES security.institution_types(id) ON DELETE RESTRICT;


--

-- Name: login_audit fk_login_audit_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.login_audit
    ADD CONSTRAINT fk_login_audit_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE SET NULL;


--

-- Name: password_history fk_password_history_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.password_history
    ADD CONSTRAINT fk_password_history_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--

-- Name: role_permissions fk_role_permissions_permission; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.role_permissions
    ADD CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id) REFERENCES security.permissions(id) ON DELETE CASCADE;


--

-- Name: role_permissions fk_role_permissions_role; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.role_permissions
    ADD CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES security.roles(id) ON DELETE CASCADE;


--

-- Name: security_events fk_security_events_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.security_events
    ADD CONSTRAINT fk_security_events_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE SET NULL;


--

-- Name: sessions fk_sessions_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.sessions
    ADD CONSTRAINT fk_sessions_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--

-- Name: user_profiles fk_user_profiles_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_profiles
    ADD CONSTRAINT fk_user_profiles_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--

-- Name: user_responsibilities fk_user_responsibilities_assigned_by; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT fk_user_responsibilities_assigned_by FOREIGN KEY (assigned_by) REFERENCES security.users(id);


--

-- Name: user_responsibilities fk_user_responsibilities_revoked_by; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT fk_user_responsibilities_revoked_by FOREIGN KEY (revoked_by) REFERENCES security.users(id);


--

-- Name: user_responsibilities fk_user_responsibilities_type; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT fk_user_responsibilities_type FOREIGN KEY (responsibility_type_id) REFERENCES security.responsibility_types(id);


--

-- Name: user_responsibilities fk_user_responsibilities_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_responsibilities
    ADD CONSTRAINT fk_user_responsibilities_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--

-- Name: user_roles fk_user_roles_role; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_roles
    ADD CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES security.roles(id) ON DELETE CASCADE;


--

-- Name: user_roles fk_user_roles_user; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_roles
    ADD CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--

-- Name: users fk_users_department; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT fk_users_department FOREIGN KEY (department_id) REFERENCES security.departments(id);


--

-- Name: users fk_users_institution; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT fk_users_institution FOREIGN KEY (institution_id) REFERENCES security.institutions(id);


--

-- Name: password_reset_tokens password_reset_tokens_created_by_fkey; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_created_by_fkey FOREIGN KEY (created_by) REFERENCES security.users(id);


--

-- Name: password_reset_tokens password_reset_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--

-- Name: user_profiles user_profiles_academic_title_id_fkey; Type: FK CONSTRAINT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.user_profiles
    ADD CONSTRAINT user_profiles_academic_title_id_fkey FOREIGN KEY (academic_title_id) REFERENCES reference.academic_titles(id);


--


