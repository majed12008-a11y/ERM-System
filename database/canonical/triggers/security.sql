-- =========================================================================
-- security — TRIGGER
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: access_policies trigger_audit_access_policies; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_access_policies AFTER INSERT OR DELETE OR UPDATE ON security.access_policies FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: api_keys trigger_audit_api_keys; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_api_keys AFTER INSERT OR DELETE OR UPDATE ON security.api_keys FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: approval_authorities trigger_audit_approval_authorities; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_approval_authorities AFTER INSERT OR DELETE OR UPDATE ON security.approval_authorities FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: approval_limits trigger_audit_approval_limits; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_approval_limits AFTER INSERT OR DELETE OR UPDATE ON security.approval_limits FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: certificate_revocations trigger_audit_certificate_revocations; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_certificate_revocations AFTER INSERT OR DELETE OR UPDATE ON security.certificate_revocations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: departments trigger_audit_departments; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_departments AFTER INSERT OR DELETE OR UPDATE ON security.departments FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: digital_certificates trigger_audit_digital_certificates; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_digital_certificates AFTER INSERT OR DELETE OR UPDATE ON security.digital_certificates FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: email_verification_tokens trigger_audit_email_verification_tokens; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_email_verification_tokens AFTER INSERT OR DELETE OR UPDATE ON security.email_verification_tokens FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: institution_types trigger_audit_institution_types; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_institution_types AFTER INSERT OR DELETE OR UPDATE ON security.institution_types FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: institutions trigger_audit_institutions; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_institutions AFTER INSERT OR DELETE OR UPDATE ON security.institutions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: password_reset_tokens trigger_audit_password_reset_tokens; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_password_reset_tokens AFTER INSERT OR DELETE OR UPDATE ON security.password_reset_tokens FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: permissions trigger_audit_permissions; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_permissions AFTER INSERT OR DELETE OR UPDATE ON security.permissions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: policy_conditions trigger_audit_policy_conditions; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_policy_conditions AFTER INSERT OR DELETE OR UPDATE ON security.policy_conditions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: policy_rules trigger_audit_policy_rules; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_policy_rules AFTER INSERT OR DELETE OR UPDATE ON security.policy_rules FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: responsibility_types trigger_audit_responsibility_types; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_responsibility_types AFTER INSERT OR DELETE OR UPDATE ON security.responsibility_types FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: role_delegations trigger_audit_role_delegations; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_role_delegations AFTER INSERT OR DELETE OR UPDATE ON security.role_delegations FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: role_permissions trigger_audit_role_permissions; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_role_permissions AFTER INSERT OR DELETE OR UPDATE ON security.role_permissions FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: roles trigger_audit_roles; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_roles AFTER INSERT OR DELETE OR UPDATE ON security.roles FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: segregation_rules trigger_audit_segregation_rules; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_segregation_rules AFTER INSERT OR DELETE OR UPDATE ON security.segregation_rules FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: user_profiles trigger_audit_user_profiles; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_user_profiles AFTER INSERT OR DELETE OR UPDATE ON security.user_profiles FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: user_responsibilities trigger_audit_user_responsibilities; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_user_responsibilities AFTER INSERT OR DELETE OR UPDATE ON security.user_responsibilities FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: user_roles trigger_audit_user_roles; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_user_roles AFTER INSERT OR DELETE OR UPDATE ON security.user_roles FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();


--

-- Name: users trigger_audit_users; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_audit_users AFTER INSERT OR DELETE OR UPDATE ON security.users FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();

ALTER TABLE security.users DISABLE TRIGGER trigger_audit_users;


--

-- Name: departments trigger_updated_at; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON security.departments FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: institution_types trigger_updated_at; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON security.institution_types FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: institutions trigger_updated_at; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON security.institutions FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: roles trigger_updated_at; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON security.roles FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: user_profiles trigger_updated_at; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON security.user_profiles FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: users trigger_updated_at; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON security.users FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: responsibility_types trigger_updated_at_security_responsibility_types; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_updated_at_security_responsibility_types BEFORE UPDATE ON security.responsibility_types FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--

-- Name: user_responsibilities trigger_updated_at_security_user_responsibilities; Type: TRIGGER; Schema: security; Owner: -
--

CREATE TRIGGER trigger_updated_at_security_user_responsibilities BEFORE UPDATE ON security.user_responsibilities FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at();


--


