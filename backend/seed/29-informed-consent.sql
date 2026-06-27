-- ============================================================
-- 29-INFORMED-CONSENT.SQL
-- Creates informed consent framework tables:
--   consent_templates, consent_template_versions,
--   application_consents, consent_review_comments
-- ============================================================
-- نظام الموافقة المستنيرة: قوالب الموافقة، الإصدارات،
-- مراجعات الموافقة، ربط الموافقة بالطلبات.
-- ============================================================

SET app.user_id = '0';
BEGIN;

-- ============================================================
-- CONSENT TEMPLATES (logical consent types)
-- ============================================================
CREATE TABLE IF NOT EXISTS committee.consent_templates (
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code            VARCHAR(50)   NOT NULL UNIQUE,
    name_ar         VARCHAR(500)  NOT NULL,
    name_en         VARCHAR(500)  NOT NULL,
    description     TEXT,
    consent_type    VARCHAR(50)   NOT NULL,
    is_active       BOOLEAN       NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT now(),
    created_by      BIGINT,
    updated_at      TIMESTAMPTZ,
    updated_by      BIGINT,
    deleted_at      TIMESTAMPTZ,
    deleted_by      BIGINT,
    CONSTRAINT chk_consent_templates_soft_delete CHECK ((deleted_at IS NULL) OR (deleted_by IS NOT NULL))
);

COMMENT ON TABLE committee.consent_templates IS 'نماذج الموافقة المستنيرة (الأنواع المنطقية)';
COMMENT ON COLUMN committee.consent_templates.consent_type IS 'WRITTEN, ELECTRONIC, VERBAL, GUARDIAN, ASSENT, WAIVER, DEFERRED';

CREATE INDEX IF NOT EXISTS idx_consent_templates_type ON committee.consent_templates(consent_type) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_consent_templates_active ON committee.consent_templates(is_active) WHERE deleted_at IS NULL;

GRANT ALL ON TABLE committee.consent_templates TO ethics_app;
GRANT USAGE ON SEQUENCE committee.consent_templates_id_seq TO ethics_app;

-- ============================================================
-- CONSENT TEMPLATE VERSIONS (frozen snapshots with content)
-- ============================================================
CREATE TABLE IF NOT EXISTS committee.consent_template_versions (
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    template_id     BIGINT        NOT NULL REFERENCES committee.consent_templates(id),
    version_no      INTEGER       NOT NULL,
    language        VARCHAR(10)   NOT NULL,
    title           VARCHAR(500)  NOT NULL,
    content         TEXT,
    document_id     BIGINT        REFERENCES documents.documents(id),
    effective_from  DATE,
    retired_at      DATE,
    change_summary  TEXT,
    status          VARCHAR(50)   NOT NULL DEFAULT 'DRAFT',
    is_active       BOOLEAN       NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT now(),
    created_by      BIGINT,
    updated_at      TIMESTAMPTZ,
    updated_by      BIGINT,
    deleted_at      TIMESTAMPTZ,
    deleted_by      BIGINT,
    CONSTRAINT chk_ctv_soft_delete CHECK ((deleted_at IS NULL) OR (deleted_by IS NOT NULL)),
    CONSTRAINT uq_ctv_version_lang UNIQUE (template_id, version_no, language)
);

COMMENT ON TABLE committee.consent_template_versions IS 'إصدارات نماذج الموافقة (لقطة مجمدة غير قابلة للتعديل بعد الاعتماد)';
COMMENT ON COLUMN committee.consent_template_versions.language IS 'ar, en';
COMMENT ON COLUMN committee.consent_template_versions.status IS 'DRAFT, UNDER_REVIEW, APPROVED, RETIRED';

CREATE INDEX IF NOT EXISTS idx_ctv_template ON committee.consent_template_versions(template_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_ctv_status ON committee.consent_template_versions(status) WHERE deleted_at IS NULL;

GRANT ALL ON TABLE committee.consent_template_versions TO ethics_app;
GRANT USAGE ON SEQUENCE committee.consent_template_versions_id_seq TO ethics_app;

-- ============================================================
-- APPLICATION CONSENTS (links application ↔ consent version)
-- ============================================================
CREATE TABLE IF NOT EXISTS core.application_consents (
    id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    application_id      BIGINT        NOT NULL REFERENCES core.applications(id),
    consent_version_id  BIGINT        NOT NULL REFERENCES committee.consent_template_versions(id),
    is_required         BOOLEAN       NOT NULL DEFAULT true,
    status              VARCHAR(50)   NOT NULL DEFAULT 'PENDING',
    reviewer_notes      TEXT,
    reviewed_by         BIGINT        REFERENCES security.users(id),
    reviewed_at         TIMESTAMPTZ,
    is_active           BOOLEAN       NOT NULL DEFAULT true,
    created_at          TIMESTAMPTZ   NOT NULL DEFAULT now(),
    created_by          BIGINT,
    updated_at          TIMESTAMPTZ,
    updated_by          BIGINT,
    deleted_at          TIMESTAMPTZ,
    deleted_by          BIGINT,
    CONSTRAINT chk_app_consents_soft_delete CHECK ((deleted_at IS NULL) OR (deleted_by IS NOT NULL)),
    CONSTRAINT uq_app_consent_version UNIQUE (application_id, consent_version_id)
);

COMMENT ON TABLE core.application_consents IS 'ربط الموافقات المستنيرة بالطلبات (طبقة الربط بين التطبيق والإصدار)';
COMMENT ON COLUMN core.application_consents.status IS 'PENDING, APPROVED, MINOR_REVISION, MAJOR_REVISION, REJECTED';
COMMENT ON COLUMN core.application_consents.is_required IS 'true=إلزامي, false=اختياري';

CREATE INDEX IF NOT EXISTS idx_app_consents_app ON core.application_consents(application_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_app_consents_version ON core.application_consents(consent_version_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_app_consents_status ON core.application_consents(status) WHERE deleted_at IS NULL;

GRANT ALL ON TABLE core.application_consents TO ethics_app;
GRANT USAGE ON SEQUENCE core.application_consents_id_seq TO ethics_app;

-- ============================================================
-- CONSENT REVIEW COMMENTS (structured review outcomes)
-- ============================================================
CREATE TABLE IF NOT EXISTS committee.consent_review_comments (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    application_consent_id  BIGINT NOT NULL REFERENCES core.application_consents(id),
    reviewer_id             BIGINT NOT NULL REFERENCES security.users(id),
    decision                VARCHAR(50) NOT NULL,
    comment                 TEXT NOT NULL,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ,
    updated_by              BIGINT,
    deleted_at              TIMESTAMPTZ,
    deleted_by              BIGINT,
    CONSTRAINT chk_consent_review_soft_delete CHECK ((deleted_at IS NULL) OR (deleted_by IS NOT NULL))
);

COMMENT ON TABLE committee.consent_review_comments IS 'سجلات مراجعة الموافقات المستنيرة (القرار + التعليق)';
COMMENT ON COLUMN committee.consent_review_comments.decision IS 'APPROVED, MINOR_REVISION, MAJOR_REVISION, REJECTED';

CREATE INDEX IF NOT EXISTS idx_consent_review_consent ON committee.consent_review_comments(application_consent_id) WHERE deleted_at IS NULL;

GRANT ALL ON TABLE committee.consent_review_comments TO ethics_app;
GRANT USAGE ON SEQUENCE committee.consent_review_comments_id_seq TO ethics_app;

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

-- consent_templates: Admin/Chair only for write, all read
ALTER TABLE committee.consent_templates ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS consent_templates_select ON committee.consent_templates;
CREATE POLICY consent_templates_select ON committee.consent_templates FOR SELECT
  USING (true);

DROP POLICY IF EXISTS consent_templates_insert ON committee.consent_templates;
CREATE POLICY consent_templates_insert ON committee.consent_templates FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS consent_templates_update ON committee.consent_templates;
CREATE POLICY consent_templates_update ON committee.consent_templates FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint))
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS consent_templates_delete ON committee.consent_templates;
CREATE POLICY consent_templates_delete ON committee.consent_templates FOR DELETE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- consent_template_versions: Admin/Chair only for write, all read
ALTER TABLE committee.consent_template_versions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS ctv_select ON committee.consent_template_versions;
CREATE POLICY ctv_select ON committee.consent_template_versions FOR SELECT
  USING (true);

DROP POLICY IF EXISTS ctv_insert ON committee.consent_template_versions;
CREATE POLICY ctv_insert ON committee.consent_template_versions FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS ctv_update ON committee.consent_template_versions;
CREATE POLICY ctv_update ON committee.consent_template_versions FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint))
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS ctv_delete ON committee.consent_template_versions;
CREATE POLICY ctv_delete ON committee.consent_template_versions FOR DELETE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- application_consents: RLS based on application access
ALTER TABLE core.application_consents ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS app_consents_select ON core.application_consents;
CREATE POLICY app_consents_select ON core.application_consents FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR EXISTS (
      SELECT 1 FROM committee.review_assignments ra
      WHERE ra.application_id = application_consents.application_id
        AND ra.reviewer_id = (current_setting('app.user_id', true))::bigint
        AND ra.deleted_at IS NULL
    )
    OR EXISTS (
      SELECT 1 FROM core.applications a
      WHERE a.id = application_consents.application_id
        AND a.submitted_by = (current_setting('app.user_id', true))::bigint
    )
  );

DROP POLICY IF EXISTS app_consents_insert ON core.application_consents;
CREATE POLICY app_consents_insert ON core.application_consents FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS app_consents_update ON core.application_consents;
CREATE POLICY app_consents_update ON core.application_consents FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint))
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS app_consents_delete ON core.application_consents;
CREATE POLICY app_consents_delete ON core.application_consents FOR DELETE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- consent_review_comments: Reviewer/Chair for write, admin/chair/reviewer for read
ALTER TABLE committee.consent_review_comments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS consent_review_select ON committee.consent_review_comments;
CREATE POLICY consent_review_select ON committee.consent_review_comments FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR reviewer_id = (current_setting('app.user_id', true))::bigint
    OR EXISTS (
      SELECT 1 FROM committee.review_assignments ra
      JOIN core.application_consents ac ON ac.id = consent_review_comments.application_consent_id
      WHERE ra.application_id = ac.application_id
        AND ra.reviewer_id = (current_setting('app.user_id', true))::bigint
        AND ra.deleted_at IS NULL
    )
  );

DROP POLICY IF EXISTS consent_review_insert ON committee.consent_review_comments;
CREATE POLICY consent_review_insert ON committee.consent_review_comments FOR INSERT
  WITH CHECK (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR EXISTS (
      SELECT 1 FROM committee.review_assignments ra
      JOIN core.application_consents ac ON ac.id = application_consent_id
      WHERE ra.application_id = ac.application_id
        AND ra.reviewer_id = (current_setting('app.user_id', true))::bigint
        AND ra.review_type = 'CONSENT'
        AND ra.deleted_at IS NULL
    )
  );

DROP POLICY IF EXISTS consent_review_update ON committee.consent_review_comments;
CREATE POLICY consent_review_update ON committee.consent_review_comments FOR UPDATE
  USING (reviewer_id = (current_setting('app.user_id', true))::bigint)
  WITH CHECK (reviewer_id = (current_setting('app.user_id', true))::bigint);

DROP POLICY IF EXISTS consent_review_delete ON committee.consent_review_comments;
CREATE POLICY consent_review_delete ON committee.consent_review_comments FOR DELETE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- ============================================================
-- SEED DATA
-- ============================================================
DO $$
  DECLARE
    -- consent templates
    v_clinical_id BIGINT; v_observ_id BIGINT; v_guardian_id BIGINT; v_bio_id BIGINT;

    -- consent versions
    v_clin_ar_v1 BIGINT; v_clin_en_v1 BIGINT; v_clin_ar_v2 BIGINT;
    v_obs_ar_v1 BIGINT; v_obs_en_v1 BIGINT;
    v_guard_ar_v1 BIGINT; v_guard_en_v1 BIGINT;
    v_bio_ar_v1 BIGINT; v_bio_en_v1 BIGINT;

    -- application lookups
    v_app1_id BIGINT; v_app2_id BIGINT; v_app3_id BIGINT; v_app4_id BIGINT; v_app5_id BIGINT;

    -- user lookups
    v_ethics_admin BIGINT; v_reviewer1 BIGINT; v_reviewer2 BIGINT;

    -- application consent lookups
    v_ac_app1 BIGINT; v_ac_app3 BIGINT;

    -- review assignment
    v_ra_consent BIGINT;
  BEGIN
    -- ========================
    -- LOOKUP EXISTING RECORDS
    -- ========================
    SELECT id INTO v_app1_id FROM core.applications WHERE application_number = 'APP-2024-001';
    SELECT id INTO v_app2_id FROM core.applications WHERE application_number = 'APP-2024-002';
    SELECT id INTO v_app3_id FROM core.applications WHERE application_number = 'APP-2024-003';
    SELECT id INTO v_app4_id FROM core.applications WHERE application_number = 'APP-2024-004';
    SELECT id INTO v_app5_id FROM core.applications WHERE application_number = 'APP-2024-005';

    SELECT id INTO v_ethics_admin FROM security.users WHERE username = 'ethics_admin';
    SELECT id INTO v_reviewer1 FROM security.users WHERE username = 'reviewer1';
    SELECT id INTO v_reviewer2 FROM security.users WHERE username = 'reviewer2';

    -- ========================
    -- CONSENT TEMPLATES
    -- ========================

    -- Template 1: Clinical Trial Consent
    INSERT INTO committee.consent_templates (code, name_ar, name_en, description, consent_type)
    VALUES ('CLINICAL_TRIAL', 'نموذج موافقة دراسة سريرية', 'Clinical Trial Consent Form',
            'نموذج الموافقة المستنيرة للمشاركة في التجارب السريرية', 'WRITTEN')
    RETURNING id INTO v_clinical_id;

    -- Template 2: Observational Study Consent
    INSERT INTO committee.consent_templates (code, name_ar, name_en, description, consent_type)
    VALUES ('OBSERVATIONAL', 'نموذج موافقة دراسة مراقبة', 'Observational Study Consent Form',
            'نموذج الموافقة المستنيرة للدراسات الرصدية غير التداخلية', 'WRITTEN')
    RETURNING id INTO v_observ_id;

    -- Template 3: Guardian Consent
    INSERT INTO committee.consent_templates (code, name_ar, name_en, description, consent_type)
    VALUES ('GUARDIAN_CONSENT', 'نموذج موافقة ولي أمر', 'Guardian Consent Form',
            'نموذج موافقة ولي الأمر أو الوصي القانوني للمشاركين القصر', 'GUARDIAN')
    RETURNING id INTO v_guardian_id;

    -- Template 4: Biological Samples Consent
    INSERT INTO committee.consent_templates (code, name_ar, name_en, description, consent_type)
    VALUES ('BIOLOGICAL_SAMPLES', 'نموذج موافقة استخدام عينات حيوية', 'Biological Samples Consent Form',
            'نموذج الموافقة على جمع واستخدام العينات الحيوية في الأبحاث', 'WRITTEN')
    RETURNING id INTO v_bio_id;

    -- ========================
    -- CONSENT TEMPLATE VERSIONS
    -- ========================

    -- Clinical Trial v1.0 AR
    INSERT INTO committee.consent_template_versions (template_id, version_no, language, title, content, effective_from, status)
    VALUES (v_clinical_id, 1, 'ar', 'نموذج الموافقة المستنيرة للتجارب السريرية - النسخة العربية 1.0',
            'أنا الموقع أدناه ... أقر بموافقتي على المشاركة في التجربة السريرية ...',
            '2024-01-01'::date, 'APPROVED')
    RETURNING id INTO v_clin_ar_v1;

    -- Clinical Trial v1.0 EN
    INSERT INTO committee.consent_template_versions (template_id, version_no, language, title, content, effective_from, status)
    VALUES (v_clinical_id, 1, 'en', 'Clinical Trial Informed Consent v1.0',
            'I, the undersigned ... hereby consent to participate in the clinical trial ...',
            '2024-01-01'::date, 'APPROVED')
    RETURNING id INTO v_clin_en_v1;

    -- Clinical Trial v2.0 AR (updated)
    INSERT INTO committee.consent_template_versions (template_id, version_no, language, title, content, effective_from, change_summary, status)
    VALUES (v_clinical_id, 2, 'ar', 'نموذج الموافقة المستنيرة للتجارب السريرية - النسخة العربية 2.0',
            'أنا الموقع أدناه ... أقر بموافقتي على المشاركة في التجربة السريرية ... (محدث)',
            '2024-06-01'::date, 'إضافة معلومات عن الآثار الجانبية النادرة وتحديث معلومات الاتصال بلجنة الأخلاقيات', 'APPROVED')
    RETURNING id INTO v_clin_ar_v2;

    -- Observational Study v1.0 AR
    INSERT INTO committee.consent_template_versions (template_id, version_no, language, title, content, effective_from, status)
    VALUES (v_observ_id, 1, 'ar', 'نموذج الموافقة المستنيرة للدراسات الرصدية - النسخة العربية 1.0',
            'أنا الموقع أدناه ... أوافق على المشاركة في الدراسة الرصدية ...',
            '2024-01-01'::date, 'APPROVED')
    RETURNING id INTO v_obs_ar_v1;

    -- Observational Study v1.0 EN
    INSERT INTO committee.consent_template_versions (template_id, version_no, language, title, content, effective_from, status)
    VALUES (v_observ_id, 1, 'en', 'Observational Study Informed Consent v1.0',
            'I, the undersigned ... consent to participate in the observational study ...',
            '2024-01-01'::date, 'APPROVED')
    RETURNING id INTO v_obs_en_v1;

    -- Guardian Consent v1.0 AR
    INSERT INTO committee.consent_template_versions (template_id, version_no, language, title, content, effective_from, status)
    VALUES (v_guardian_id, 1, 'ar', 'نموذج موافقة ولي الأمر - النسخة العربية 1.0',
            'أنا ولي أمر/ وصي قانوني ... أوافق على مشاركة ... في البحث ...',
            '2024-01-01'::date, 'APPROVED')
    RETURNING id INTO v_guard_ar_v1;

    -- Guardian Consent v1.0 EN
    INSERT INTO committee.consent_template_versions (template_id, version_no, language, title, content, effective_from, status)
    VALUES (v_guardian_id, 1, 'en', 'Guardian Consent Form v1.0',
            'I, the legal guardian ... consent to the participation of ... in the research ...',
            '2024-01-01'::date, 'APPROVED')
    RETURNING id INTO v_guard_en_v1;

    -- Biological Samples v1.0 AR
    INSERT INTO committee.consent_template_versions (template_id, version_no, language, title, content, effective_from, status)
    VALUES (v_bio_id, 1, 'ar', 'نموذج الموافقة على استخدام العينات الحيوية - النسخة العربية 1.0',
            'أوافق على جمع واستخدام عيناتي الحيوية لأغراض البحث العلمي ...',
            '2024-01-01'::date, 'APPROVED')
    RETURNING id INTO v_bio_ar_v1;

    -- Biological Samples v1.0 EN
    INSERT INTO committee.consent_template_versions (template_id, version_no, language, title, content, effective_from, status)
    VALUES (v_bio_id, 1, 'en', 'Biological Samples Consent Form v1.0',
            'I consent to the collection and use of my biological samples for research purposes ...',
            '2024-01-01'::date, 'APPROVED')
    RETURNING id INTO v_bio_en_v1;

    -- ========================
    -- APPLICATION CONSENTS (link applications to consent versions)
    -- ========================

    -- Application 1 (Warfarin): Clinical Trial v1.0 AR + Guardian Consent v1.0 AR
    INSERT INTO core.application_consents (application_id, consent_version_id, is_required, status)
    VALUES (v_app1_id, v_clin_ar_v1, true, 'APPROVED')
    RETURNING id INTO v_ac_app1;

    INSERT INTO core.application_consents (application_id, consent_version_id, is_required, status)
    VALUES (v_app1_id, v_guard_ar_v1, false, 'PENDING');

    -- Application 2 (Breast Cancer): Clinical Trial v1.0 AR + Biological Samples AR
    INSERT INTO core.application_consents (application_id, consent_version_id, is_required, status)
    VALUES (v_app2_id, v_clin_ar_v1, true, 'APPROVED');

    INSERT INTO core.application_consents (application_id, consent_version_id, is_required, status)
    VALUES (v_app2_id, v_bio_ar_v1, true, 'APPROVED');

    -- Application 3 (Breast Cancer Amendment): Clinical Trial v2.0 AR
    INSERT INTO core.application_consents (application_id, consent_version_id, is_required, status)
    VALUES (v_app3_id, v_clin_ar_v2, true, 'MINOR_REVISION')
    RETURNING id INTO v_ac_app3;

    -- Application 4 (Medical Device): Observational Study v1.0 EN
    INSERT INTO core.application_consents (application_id, consent_version_id, is_required, status)
    VALUES (v_app4_id, v_obs_en_v1, true, 'PENDING');

    -- Application 5 (Microbiome): Observational Study v1.0 AR + Guardian Consent + Biological Samples
    INSERT INTO core.application_consents (application_id, consent_version_id, is_required, status)
    VALUES (v_app5_id, v_obs_ar_v1, true, 'PENDING');

    INSERT INTO core.application_consents (application_id, consent_version_id, is_required, status)
    VALUES (v_app5_id, v_guard_ar_v1, true, 'PENDING');

    INSERT INTO core.application_consents (application_id, consent_version_id, is_required, status)
    VALUES (v_app5_id, v_bio_ar_v1, false, 'PENDING');

    -- ========================
    -- REVIEW ASSIGNMENTS (CONSENT type)
    -- ========================

    -- Assign reviewer1 to consent review for Application 1
    INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, assigned_at, status_code)
    VALUES (v_app1_id, v_reviewer1, 'CONSENT', v_ethics_admin, now(), 'COMPLETED')
    RETURNING id INTO v_ra_consent;

    -- Assign reviewer2 to consent review for Application 2
    INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, assigned_at, status_code)
    VALUES (v_app2_id, v_reviewer2, 'CONSENT', v_ethics_admin, now(), 'COMPLETED');

    -- Assign reviewer1 to consent review for Application 3 (pending)
    INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, assigned_at, status_code)
    VALUES (v_app3_id, v_reviewer1, 'CONSENT', v_ethics_admin, now(), 'IN_REVIEW');

    -- Assign reviewer2 to consent review for Application 5 (pending)
    INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, assigned_at, due_date, status_code)
    VALUES (v_app5_id, v_reviewer2, 'CONSENT', v_ethics_admin, now(), now() + interval '14 days', 'ASSIGNED');

    -- ========================
    -- CONSENT REVIEW COMMENTS
    -- ========================

    -- Review comment for Application 1 (approved)
    INSERT INTO committee.consent_review_comments (application_consent_id, reviewer_id, decision, comment)
    VALUES (v_ac_app1, v_reviewer1, 'APPROVED', 'النموذج مطابق للمعايير الأخلاقية. لا توجد ملاحظات.');

    -- Review comment for Application 3 (minor revision needed)
    INSERT INTO committee.consent_review_comments (application_consent_id, reviewer_id, decision, comment)
    VALUES (v_ac_app3, v_reviewer1, 'MINOR_REVISION', 'يحتاج النموذج إلى تحديث معلومات الاتصال بلجنة الأخلاقيات وإضافة فقرة عن حق المشارك في الانسحاب في أي وقت.');
  END $$;

COMMIT;
