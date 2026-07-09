-- =========================================================================
-- security — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: TABLE responsibility_types; Type: COMMENT; Schema: security; Owner: -
--

COMMENT ON TABLE security.responsibility_types IS 'أنواع المسؤوليات / Responsibility Types';


--

-- Name: COLUMN responsibility_types.code; Type: COMMENT; Schema: security; Owner: -
--

COMMENT ON COLUMN security.responsibility_types.code IS 'الكود (Reviewer, Approver, Signer, Observer, Coordinator, Secretary)';


--

-- Name: COLUMN user_profiles.gender; Type: COMMENT; Schema: security; Owner: -
--

COMMENT ON COLUMN security.user_profiles.gender IS 'ذكر / أنثى';


--

-- Name: COLUMN user_profiles.academic_title; Type: COMMENT; Schema: security; Owner: -
--

COMMENT ON COLUMN security.user_profiles.academic_title IS 'اللقب الأكاديمي';


--

-- Name: COLUMN user_profiles.academic_title_id; Type: COMMENT; Schema: security; Owner: -
--

COMMENT ON COLUMN security.user_profiles.academic_title_id IS 'اللقب الأكاديمي (مرجع)';


--

-- Name: TABLE user_responsibilities; Type: COMMENT; Schema: security; Owner: -
--

COMMENT ON TABLE security.user_responsibilities IS 'مسؤوليات المستخدمين / User Responsibilities';


--

-- Name: COLUMN user_responsibilities.entity_type; Type: COMMENT; Schema: security; Owner: -
--

COMMENT ON COLUMN security.user_responsibilities.entity_type IS 'نوع الكيان (application, project, committee)';


--

-- Name: COLUMN user_responsibilities.entity_id; Type: COMMENT; Schema: security; Owner: -
--

COMMENT ON COLUMN security.user_responsibilities.entity_id IS 'معرف الكيان';


--


