-- =========================================================================
-- system — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: FUNCTION fn_is_admin(p_user_id bigint); Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON FUNCTION system.fn_is_admin(p_user_id bigint) IS 'Returns true if the user holds any administrative role. SECURITY DEFINER to bypass RLS on user_roles.';


--

-- Name: FUNCTION fn_is_committee_member_for_application(p_user_id bigint, p_application_id bigint); Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON FUNCTION system.fn_is_committee_member_for_application(p_user_id bigint, p_application_id bigint) IS 'Returns true if p_user_id is an active committee member of the committee reviewing p_application_id. SECURITY DEFINER to bypass RLS.';


--

-- Name: FUNCTION is_active_row(p_deleted_at timestamp with time zone); Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON FUNCTION system.is_active_row(p_deleted_at timestamp with time zone) IS 'Returns true if the row is not soft-deleted. Used in RLS policies.';


SET default_table_access_method = heap;

--

-- Name: TABLE push_config; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON TABLE system.push_config IS 'إعدادات الإشعارات الفورية / Push Notification Config';


--

-- Name: COLUMN push_config.config_name; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON COLUMN system.push_config.config_name IS 'اسم الإعداد';


--

-- Name: COLUMN push_config.provider; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON COLUMN system.push_config.provider IS 'المزود (FCM, APNs, ...)';


--

-- Name: COLUMN push_config.server_key; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON COLUMN system.push_config.server_key IS 'مفتاح الخادم';


--

-- Name: COLUMN push_config.app_id; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON COLUMN system.push_config.app_id IS 'معرف التطبيق';


--

-- Name: TABLE rule_actions; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON TABLE system.rule_actions IS 'إجراءات قواعد الأعمال / Rule Actions';


--

-- Name: TABLE rule_conditions; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON TABLE system.rule_conditions IS 'شروط قواعد الأعمال / Rule Conditions';


--

-- Name: TABLE rule_executions; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON TABLE system.rule_executions IS 'سجل تنفيذ قواعد الأعمال / Rule Executions';


--

-- Name: TABLE saved_searches; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON TABLE system.saved_searches IS 'عمليات البحث المحفوظة / Saved Searches';


--

-- Name: TABLE search_audit; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON TABLE system.search_audit IS 'سجل عمليات البحث / Search Audit Log';


--

-- Name: TABLE search_indexes; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON TABLE system.search_indexes IS 'فهارس البحث النصي / Search Indexes';


--


