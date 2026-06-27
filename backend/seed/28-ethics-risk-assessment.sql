SET app.user_id = '0';
BEGIN;

-- ============================================================
-- 28-ETHICS-RISK-ASSESSMENT.SQL
-- ============================================================
-- نظام تقييم المخاطر الأخلاقية: جداول تقييم المخاطر،
-- التصنيفات، مستويات المخاطر المرتبطة بطلبات البحث.
-- Creates risk assessment tables integrated with the ethics review process
-- ============================================================

-- 1. ETHICS RISK ASSESSMENTS (header per application)
CREATE TABLE IF NOT EXISTS committee.ethics_risk_assessments (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    application_id BIGINT NOT NULL REFERENCES core.applications(id),
    ethics_review_id BIGINT REFERENCES committee.ethics_reviews(id),
    scientific_review_id BIGINT REFERENCES committee.scientific_reviews(id),
    assessment_version INTEGER DEFAULT 1 NOT NULL,
    overall_risk_level VARCHAR(50) NOT NULL,
    overall_risk_score NUMERIC(10,2),
    recommendation VARCHAR(100),
    assessed_by BIGINT NOT NULL REFERENCES security.users(id),
    assessment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    summary TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    created_by BIGINT,
    updated_at TIMESTAMPTZ,
    updated_by BIGINT,
    deleted_at TIMESTAMPTZ,
    deleted_by BIGINT,
    CONSTRAINT chk_ethics_risk_assessments_soft_delete CHECK ((deleted_at IS NULL) OR (deleted_by IS NOT NULL))
);

COMMENT ON TABLE committee.ethics_risk_assessments IS 'تقييم المخاطر الأخلاقية القبلي (جزء من المراجعة الأخلاقية)';
COMMENT ON COLUMN committee.ethics_risk_assessments.overall_risk_level IS 'LOW, MEDIUM, HIGH, CRITICAL';
COMMENT ON COLUMN committee.ethics_risk_assessments.recommendation IS 'APPROVE, APPROVE_WITH_MONITORING, CONDITIONAL, REJECT';

-- 2. ETHICS RISK ITEMS (individual risk entries)
CREATE TABLE IF NOT EXISTS committee.ethics_risk_items (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    assessment_id BIGINT NOT NULL REFERENCES committee.ethics_risk_assessments(id) ON DELETE CASCADE,
    risk_category_id BIGINT NOT NULL REFERENCES safety.risk_categories(id),
    risk_description TEXT NOT NULL,
    probability INTEGER NOT NULL CHECK (probability >= 1 AND probability <= 5),
    severity INTEGER NOT NULL CHECK (severity >= 1 AND severity <= 5),
    risk_score INTEGER GENERATED ALWAYS AS (probability * severity) STORED,
    mitigation_plan TEXT,
    residual_probability INTEGER CHECK (residual_probability >= 1 AND residual_probability <= 5),
    residual_severity INTEGER CHECK (residual_severity >= 1 AND residual_severity <= 5),
    residual_score INTEGER GENERATED ALWAYS AS (residual_probability * residual_severity) STORED,
    is_acceptable BOOLEAN DEFAULT false,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at TIMESTAMPTZ,
    updated_by BIGINT,
    deleted_at TIMESTAMPTZ,
    deleted_by BIGINT,
    CONSTRAINT chk_ethics_risk_items_soft_delete CHECK ((deleted_at IS NULL) OR (deleted_by IS NOT NULL))
);

COMMENT ON TABLE committee.ethics_risk_items IS 'بنود تقييم المخاطر الفردية';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_ethics_risk_assessments_app ON committee.ethics_risk_assessments(application_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_ethics_risk_assessments_review ON committee.ethics_risk_assessments(ethics_review_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_ethics_risk_items_assessment ON committee.ethics_risk_items(assessment_id) WHERE deleted_at IS NULL;

-- Grant permissions
GRANT ALL ON TABLE committee.ethics_risk_assessments TO ethics_app;
GRANT ALL ON TABLE committee.ethics_risk_items TO ethics_app;
GRANT USAGE ON SEQUENCE committee.ethics_risk_assessments_id_seq TO ethics_app;
GRANT USAGE ON SEQUENCE committee.ethics_risk_items_id_seq TO ethics_app;

-- ============================================================
-- 3. SEED DATA: Risk Categories (already in safety.risk_categories)
-- We also add committee-specific risk categories not in safety schema
-- ============================================================

-- ============================================================
-- 4. SEED: Ethics Risk Assessments for existing applications
-- ============================================================
DO $$
  DECLARE
  v_app1_id BIGINT; v_app2_id BIGINT; v_app3_id BIGINT; v_app4_id BIGINT; v_app5_id BIGINT;
  v_ethics_admin BIGINT; v_reviewer1 BIGINT; v_reviewer2 BIGINT;
  v_assessment1 BIGINT; v_assessment2 BIGINT; v_assessment3 BIGINT; v_assessment5 BIGINT;
  v_phy_id BIGINT; v_psych_id BIGINT; v_social_id BIGINT; v_econ_id BIGINT;
  v_legal_id BIGINT; v_bio_id BIGINT; v_chem_id BIGINT; v_data_id BIGINT;
  v_reput_id BIGINT; v_ethics_id BIGINT;
BEGIN
  SELECT id INTO v_ethics_admin FROM security.users WHERE username = 'ethics_admin';
  SELECT id INTO v_reviewer1 FROM security.users WHERE username = 'reviewer1';
  SELECT id INTO v_reviewer2 FROM security.users WHERE username = 'reviewer2';

  SELECT id INTO v_app1_id FROM core.applications WHERE application_number = 'APP-2024-001';
  SELECT id INTO v_app2_id FROM core.applications WHERE application_number = 'APP-2024-002';
  SELECT id INTO v_app3_id FROM core.applications WHERE application_number = 'APP-2024-003';
  SELECT id INTO v_app4_id FROM core.applications WHERE application_number = 'APP-2024-004';
  SELECT id INTO v_app5_id FROM core.applications WHERE application_number = 'APP-2024-005';

  SELECT id INTO v_phy_id FROM safety.risk_categories WHERE category_code = 'PHYSICAL';
  SELECT id INTO v_psych_id FROM safety.risk_categories WHERE category_code = 'PSYCHOLOGICAL';
  SELECT id INTO v_social_id FROM safety.risk_categories WHERE category_code = 'SOCIAL';
  SELECT id INTO v_econ_id FROM safety.risk_categories WHERE category_code = 'ECONOMIC';
  SELECT id INTO v_legal_id FROM safety.risk_categories WHERE category_code = 'LEGAL';
  SELECT id INTO v_bio_id FROM safety.risk_categories WHERE category_code = 'BIOLOGICAL';
  SELECT id INTO v_chem_id FROM safety.risk_categories WHERE category_code = 'CHEMICAL';
  SELECT id INTO v_data_id FROM safety.risk_categories WHERE category_code = 'DATA_PRIVACY';
  SELECT id INTO v_reput_id FROM safety.risk_categories WHERE category_code = 'REPUTATIONAL';
  SELECT id INTO v_ethics_id FROM safety.risk_categories WHERE category_code = 'ETHICAL';

  -- Assessment 1: Warfarin Study (MEDIUM risk, max item score = 3×3 = 9)
  INSERT INTO committee.ethics_risk_assessments (application_id, overall_risk_level, overall_risk_score, recommendation, assessed_by, assessment_date, summary)
  VALUES (v_app1_id, 'MEDIUM', 9, 'APPROVE_WITH_MONITORING', v_ethics_admin, '2024-03-15'::date,
    'تقييم المخاطر الأخلاقية لدراسة الوارفارين: المخاطر متوسطة وتشمل النزيف والتفاعلات الدوائية. الفائدة المرجوة تفوق المخاطر بشرط المراقبة الدقيقة.')
  RETURNING id INTO v_assessment1;

  INSERT INTO committee.ethics_risk_items (assessment_id, risk_category_id, risk_description, probability, severity, mitigation_plan, residual_probability, residual_severity, is_acceptable, display_order)
  VALUES
    (v_assessment1, v_phy_id, 'خطر النزيف بسبب علاج الوارفارين', 3, 3, 'مراقبة INR بشكل دوري وتعديل الجرعة حسب الحاجة', 2, 2, true, 1),
    (v_assessment1, v_chem_id, 'تفاعلات دوائية مع أدوية أخرى', 2, 3, 'فحص الأدوية المصاحبة وتثقيف المريض', 1, 2, true, 2),
    (v_assessment1, v_data_id, 'خطر خرق سرية البيانات الصحية', 2, 4, 'تشفير البيانات وفصل المعلومات الشخصية عن السريرية', 1, 2, true, 3);

  -- Assessment 2: Breast Cancer Study (HIGH risk, max item score = 4×4 = 16)
  INSERT INTO committee.ethics_risk_assessments (application_id, overall_risk_level, overall_risk_score, recommendation, assessed_by, assessment_date, summary)
  VALUES (v_app2_id, 'HIGH', 16, 'APPROVE_WITH_MONITORING', v_ethics_admin, '2024-06-10'::date,
    'تقييم المخاطر الأخلاقية لدراسة سرطان الثدي: مخاطر عالية بسبب العلاج المناعي التجريبي. تتطلب مراقبة مكثفة وتقارير سلامة دورية.')
  RETURNING id INTO v_assessment2;

  INSERT INTO committee.ethics_risk_items (assessment_id, risk_category_id, risk_description, probability, severity, mitigation_plan, residual_probability, residual_severity, is_acceptable, display_order)
  VALUES
    (v_assessment2, v_phy_id, 'آثار جانبية للعلاج المناعي (متلازمة إفراز السيتوكاين، التهاب القولون، التهاب الرئة)', 4, 4, 'بروتوكول مراقبة مكثف مع تدخل طبي فوري', 3, 3, true, 1),
    (v_assessment2, v_psych_id, 'الضغط النفسي للمريضات نتيجة العلاج التجريبي', 3, 3, 'دعم نفسي مستمر للمشاركات', 2, 2, true, 2),
    (v_assessment2, v_data_id, 'خطر تسرب بيانات المشاركات', 2, 5, 'نظام إدارة بيانات آمن مع صلاحيات وصول محددة', 1, 3, true, 3),
    (v_assessment2, v_ethics_id, 'خطر الإكراه أو التأثير غير الملائم على المشاركات', 2, 4, 'تثقيف المشاركات حول حق الانسحاب في أي وقت', 1, 2, true, 4);

  -- Assessment 3: Breast Cancer Amendment (HIGH risk, max item score = 4×4 = 16)
  INSERT INTO committee.ethics_risk_assessments (application_id, overall_risk_level, overall_risk_score, recommendation, assessed_by, assessment_date, summary)
  VALUES (v_app3_id, 'HIGH', 16, 'CONDITIONAL', v_reviewer1, '2024-08-20'::date,
    'تقييم مخاطر التعديل على دراسة سرطان الثدي: إضافة ذراع علاجي جديد يزيد من مستوى المخاطر. الموافقة مشروطة بمراجعة بروتوكول السلامة.')
  RETURNING id INTO v_assessment3;

  INSERT INTO committee.ethics_risk_items (assessment_id, risk_category_id, risk_description, probability, severity, mitigation_plan, residual_probability, residual_severity, is_acceptable, display_order)
  VALUES
    (v_assessment3, v_phy_id, 'آثار جانبية إضافية للذراع العلاجي الجديد', 4, 4, 'تحديث بروتوكول المراقبة ليشمل الذراع الجديد', 3, 3, true, 1),
    (v_assessment3, v_data_id, 'تحديث الموافقة المستنيرة للمشاركات الحاليات', 3, 3, 'إعادة توقيع الموافقة المستنيرة بعد التحديث', 2, 2, true, 2);

  -- Assessment 5: Microbiome Study (LOW risk, max item score = 2×3 = 6)
  INSERT INTO committee.ethics_risk_assessments (application_id, overall_risk_level, overall_risk_score, recommendation, assessed_by, assessment_date, summary)
  VALUES (v_app5_id, 'LOW', 6, 'APPROVED', v_reviewer2, '2024-09-25'::date,
    'تقييم المخاطر الأخلاقية لدراسة الميكروبيوم: مخاطر منخفضة. دراسة مقطعية غير تداخلية.')
  RETURNING id INTO v_assessment5;

  INSERT INTO committee.ethics_risk_items (assessment_id, risk_category_id, risk_description, probability, severity, mitigation_plan, residual_probability, residual_severity, is_acceptable, display_order)
  VALUES
    (v_assessment5, v_data_id, 'خطر خرق سرية بيانات الأطفال المشاركين', 2, 3, 'استخدام رموز تعريفية بدلاً من الأسماء', 1, 2, true, 1),
    (v_assessment5, v_psych_id, 'قلق الأطفال أثناء المقابلات وجمع العينات', 2, 2, 'استبيانات ذاتية التعبئة ووجود مشرف نفسي', 1, 1, true, 2);

END $$;

COMMIT;
