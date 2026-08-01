-- ============================================================
-- 55-forms-library.sql
-- ============================================================
-- بنية مكتبة النماذج الرسمية:
--   1. مخطط forms (تعريفات النماذج + مثيلات النماذج)
--   2. ترقيم المستندات الرسمية document_numbering
--   3. توسعة documents.templates (اللغة/الفئة/الافتراضي)
--   4. أنواع المستندات الرسمية
--   5. سياسات RLS
--   6. إرفاق مشغلات التدقيق
--   7. تعريفات النماذج v1 (JSON Schema)
-- Idempotent — يمكن إعادة تطبيقه بأمان.
-- ============================================================

-- ============================================================
-- 1. Forms Schema
-- ============================================================
CREATE SCHEMA IF NOT EXISTS forms;

CREATE TABLE IF NOT EXISTS forms.form_definitions (
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    form_code       VARCHAR(100) NOT NULL,
    form_name_ar    VARCHAR(500) NOT NULL,
    form_name_en    VARCHAR(500),
    category        VARCHAR(50)  NOT NULL,
    workflow_stage  VARCHAR(50)  NOT NULL,
    version_no      INTEGER      NOT NULL DEFAULT 1,
    schema_version  VARCHAR(20)  NOT NULL DEFAULT '1.0.0',
    form_schema     JSONB        NOT NULL,
    renderer        VARCHAR(50)  NOT NULL DEFAULT 'schema-form',
    is_active       BOOLEAN      NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT now(),
    created_by      BIGINT REFERENCES security.users(id),
    updated_at      TIMESTAMPTZ,
    updated_by      BIGINT REFERENCES security.users(id),
    deleted_at      TIMESTAMPTZ,
    deleted_by      BIGINT REFERENCES security.users(id),
    CONSTRAINT uq_form_definitions_code_version UNIQUE (form_code, version_no),
    CONSTRAINT chk_form_definitions_soft_delete CHECK ((deleted_at IS NULL) OR (deleted_by IS NOT NULL))
);

CREATE TABLE IF NOT EXISTS forms.form_instances (
    id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    form_definition_id  BIGINT NOT NULL REFERENCES forms.form_definitions(id),
    entity_type         VARCHAR(100) NOT NULL,
    entity_id           BIGINT NOT NULL,
    status              VARCHAR(20) NOT NULL DEFAULT 'DRAFT'
        CHECK (status IN ('DRAFT','SUBMITTED','RETURNED','APPROVED','VOID')),
    responses           JSONB NOT NULL DEFAULT '{}'::jsonb,
    total_score         NUMERIC(6,2),
    recommendation      VARCHAR(50),
    submitted_by        BIGINT REFERENCES security.users(id),
    submitted_at        TIMESTAMPTZ,
    approved_by         BIGINT REFERENCES security.users(id),
    approved_at         TIMESTAMPTZ,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_by          BIGINT REFERENCES security.users(id),
    updated_at          TIMESTAMPTZ,
    updated_by          BIGINT REFERENCES security.users(id),
    deleted_at          TIMESTAMPTZ,
    deleted_by          BIGINT REFERENCES security.users(id),
    CONSTRAINT chk_form_instances_soft_delete CHECK ((deleted_at IS NULL) OR (deleted_by IS NOT NULL))
);

CREATE INDEX IF NOT EXISTS idx_form_instances_entity ON forms.form_instances (entity_type, entity_id, status);
CREATE INDEX IF NOT EXISTS idx_form_definitions_active ON forms.form_definitions (form_code, is_active);

-- ============================================================
-- 2. Document Numbering
-- ============================================================
CREATE TABLE IF NOT EXISTS documents.document_numbering (
    id        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category  VARCHAR(50) NOT NULL,
    year      INTEGER     NOT NULL,
    prefix    VARCHAR(20) NOT NULL,
    last_seq  BIGINT      NOT NULL DEFAULT 0,
    CONSTRAINT uq_document_numbering UNIQUE (category, year)
);

-- ============================================================
-- 3. Template Extensions
-- ============================================================
ALTER TABLE documents.templates
  ADD COLUMN IF NOT EXISTS language          VARCHAR(5)  NOT NULL DEFAULT 'ar',
  ADD COLUMN IF NOT EXISTS document_category VARCHAR(50),
  ADD COLUMN IF NOT EXISTS is_default        BOOLEAN     NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS schema_metadata   JSONB;

-- فهرس فريد جزئي: قالب افتراضي نشط واحد لكل (رمز، لغة)
CREATE UNIQUE INDEX IF NOT EXISTS uq_templates_default
  ON documents.templates (template_code, language)
  WHERE is_default AND is_active;

-- السماح بوجود قالب لكل لغة بنفس رقم الإصدار (ثنائية اللغة)
ALTER TABLE documents.templates DROP CONSTRAINT IF EXISTS uq_templates_code_version;
ALTER TABLE documents.templates
  ADD CONSTRAINT uq_templates_code_version UNIQUE (template_code, language, version_no);

-- ============================================================
-- 4. Official Document Types
-- ============================================================
INSERT INTO documents.document_types (type_code, type_name_ar, type_name_en, description, is_required)
VALUES
  ('OFFICIAL_LETTER', 'خطاب رسمي', 'Official Letter', 'خطابات القرارات الرسمية (موافقة/رفض/تأجيل)', false),
  ('REVIEW_FORM', 'نموذج مراجعة', 'Review Form', 'نماذج المراجعة العلمية والأخلاقية', false),
  ('MEETING_DOCUMENT', 'وثيقة اجتماع', 'Meeting Document', 'جدول أعمال ومحاضر وقرارات اللجان', false),
  ('CONSENT_DOCUMENT', 'نموذج موافقة', 'Consent Document', 'نماذج الموافقة المستنيرة', false),
  ('SAFETY_REPORT', 'تقرير سلامة', 'Safety Report', 'تقارير الأحداث العكسية والانحرافات', false),
  ('MONITORING_REPORT', 'تقرير ميداني', 'Monitoring Report', 'تقارير مراقبة المواقع', false),
  ('CLOSURE_REPORT', 'تقرير ختامي', 'Closure Report', 'تقارير الإغلاق والنهائية', false)
ON CONFLICT (type_code) DO NOTHING;

-- ============================================================
-- 4b. Permissions for application roles
-- ============================================================
-- يمنح أدوار التطبيق صلاحيات على مخطط forms والجدول الجديد،
-- وينشئ امتيازات افتراضية مستقبلية على مخطط forms.
DO $$
DECLARE
  v_role TEXT;
BEGIN
  FOR v_role IN SELECT unnest(ARRAY['ethics_app', 'ethics_owner', 'postgres'])
  LOOP
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = v_role) THEN
      EXECUTE format('GRANT USAGE ON SCHEMA forms TO %I', v_role);
      EXECUTE format('GRANT SELECT, INSERT, UPDATE ON forms.form_definitions TO %I', v_role);
      EXECUTE format('GRANT SELECT, INSERT, UPDATE ON forms.form_instances TO %I', v_role);
      EXECUTE format('GRANT SELECT, INSERT, UPDATE ON documents.document_numbering TO %I', v_role);
      EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA forms GRANT ALL ON TABLES TO %I', v_role);
    END IF;
  END LOOP;
END;
$$;

-- ============================================================
-- 5. RLS Policies
-- ============================================================ALTER TABLE forms.form_definitions ENABLE ROW LEVEL SECURITY;
ALTER TABLE forms.form_instances ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents.document_numbering ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS fd_select ON forms.form_definitions;
CREATE POLICY fd_select ON forms.form_definitions FOR SELECT USING (true);

DROP POLICY IF EXISTS fd_insert ON forms.form_definitions;
CREATE POLICY fd_insert ON forms.form_definitions FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS fd_update ON forms.form_definitions;
CREATE POLICY fd_update ON forms.form_definitions FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint))
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS fd_delete ON forms.form_definitions;
CREATE POLICY fd_delete ON forms.form_definitions FOR DELETE USING (false);

DROP POLICY IF EXISTS fi_select ON forms.form_instances;
CREATE POLICY fi_select ON forms.form_instances FOR SELECT
  USING (
    created_by = (current_setting('app.user_id', true))::bigint
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR EXISTS (
      SELECT 1 FROM security.user_roles ur
      JOIN security.roles r ON ur.role_id = r.id
      WHERE ur.user_id = (current_setting('app.user_id', true))::bigint
        AND r.is_active = true
        AND r.code IN ('ETHICS_ADMIN','SUPER_ADMIN','SYS_ADMIN','COMMITTEE_CHAIR','REVIEWER','INST_COORDINATOR')
    )
  );

DROP POLICY IF EXISTS fi_insert ON forms.form_instances;
CREATE POLICY fi_insert ON forms.form_instances FOR INSERT
  WITH CHECK (
    created_by = (current_setting('app.user_id', true))::bigint
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  );

DROP POLICY IF EXISTS fi_update ON forms.form_instances;
CREATE POLICY fi_update ON forms.form_instances FOR UPDATE
  USING (
    created_by = (current_setting('app.user_id', true))::bigint
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  )
  WITH CHECK (
    created_by = (current_setting('app.user_id', true))::bigint
    OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  );

DROP POLICY IF EXISTS fi_delete ON forms.form_instances;
CREATE POLICY fi_delete ON forms.form_instances FOR DELETE USING (false);

DROP POLICY IF EXISTS dn_select ON documents.document_numbering;
CREATE POLICY dn_select ON documents.document_numbering FOR SELECT USING (true);

DROP POLICY IF EXISTS dn_insert ON documents.document_numbering;
CREATE POLICY dn_insert ON documents.document_numbering FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS dn_update ON documents.document_numbering;
CREATE POLICY dn_update ON documents.document_numbering FOR UPDATE USING (true) WITH CHECK (true);

-- ============================================================
-- 6. Audit Triggers
-- ============================================================
DO $$
DECLARE
  v_targets TEXT[] := ARRAY['forms.form_definitions', 'forms.form_instances', 'documents.document_numbering'];
  v_item TEXT;
  v_schema TEXT;
  v_table TEXT;
BEGIN
  FOREACH v_item IN ARRAY v_targets
  LOOP
    v_schema := split_part(v_item, '.', 1);
    v_table := split_part(v_item, '.', 2);
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.triggers
      WHERE event_object_schema = v_schema
        AND event_object_table = v_table
        AND trigger_name = 'trg_audit_' || v_table
    ) THEN
      EXECUTE format(
        'CREATE TRIGGER trg_audit_%I AFTER INSERT OR UPDATE OR DELETE ON %I.%I
         FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit()',
        v_table, v_schema, v_table
      );
    END IF;
  END LOOP;
END;
$$;

-- ============================================================
-- 7. Form Definitions (v1)
-- ============================================================
INSERT INTO forms.form_definitions
  (form_code, form_name_ar, form_name_en, category, workflow_stage, version_no, schema_version, form_schema, renderer, is_active)
VALUES
  (
    'ADMIN_SCREENING', 'قائمة التدقيق الإداري', 'Administrative Screening Checklist',
    'SCREENING', 'Initial Review', 1, '1.0.0',
    $json${
      "$schema": "https://json-schema.org/draft/2020-12/schema",
      "formCode": "ADMIN_SCREENING",
      "version": "1.0.0",
      "sections": [
        {
          "id": "completeness",
          "title": {"ar": "الاكتمال الإداري", "en": "Administrative Completeness"},
          "fields": [
            {"name": "protocol_complete", "label": {"ar": "البروتوكول مكتمل", "en": "Protocol complete"}, "type": "boolean", "required": true},
            {"name": "consent_submitted", "label": {"ar": "نموذج الموافقة مرفق", "en": "Consent form attached"}, "type": "boolean", "required": true},
            {"name": "declaration_signed", "label": {"ar": "إقرار الباحث موقع", "en": "Researcher declaration signed"}, "type": "boolean", "required": true},
            {"name": "documents_verified", "label": {"ar": "المستندات المطلوبة مكتملة", "en": "Required documents verified"}, "type": "boolean", "required": true}
          ]
        },
        {
          "id": "outcome",
          "title": {"ar": "النتيجة", "en": "Outcome"},
          "fields": [
            {
              "name": "outcome", "label": {"ar": "النتيجة", "en": "Outcome"}, "type": "radio", "required": true,
              "options": [
                {"value": "COMPLETE", "label": {"ar": "مكتمل", "en": "Complete"}},
                {"value": "INCOMPLETE", "label": {"ar": "ناقص", "en": "Incomplete"}},
                {"value": "REJECTED", "label": {"ar": "مرفوض", "en": "Rejected"}}
              ]
            },
            {"name": "comments", "label": {"ar": "ملاحظات", "en": "Comments"}, "type": "textarea", "required": false, "rows": 4}
          ]
        }
      ]
    }$json$,
    'schema-form', true
  ),
  (
    'SCI_REVIEW_PRIMARY', 'المراجعة العلمية - التقييم الأساسي', 'Scientific Review - Primary Assessment',
    'REVIEW', 'Scientific Review', 1, '1.0.0',
    $json${
      "$schema": "https://json-schema.org/draft/2020-12/schema",
      "formCode": "SCI_REVIEW_PRIMARY",
      "version": "1.0.0",
      "sections": [
        {
          "id": "reviewer",
          "title": {"ar": "بيانات المراجع", "en": "Reviewer Information"},
          "fields": [
            {"name": "reviewer_name", "label": {"ar": "اسم المراجع", "en": "Reviewer Name"}, "type": "text", "required": true, "maxLength": 200},
            {"name": "review_date", "label": {"ar": "تاريخ المراجعة", "en": "Review Date"}, "type": "date", "required": true},
            {"name": "application_number", "label": {"ar": "رقم الطلب", "en": "Application Number"}, "type": "text", "required": true, "pattern": "^APP-\\d{4}-\\d{6}$"}
          ]
        },
        {
          "id": "scientific_merit",
          "title": {"ar": "الجدارة العلمية", "en": "Scientific Merit"},
          "fields": [
            {"name": "objectives_clarity", "label": {"ar": "وضوح الأهداف", "en": "Clarity of Objectives"}, "type": "scale", "required": true, "min": 1, "max": 5},
            {"name": "study_design", "label": {"ar": "تصميم الدراسة", "en": "Study Design"}, "type": "select", "required": true,
              "options": [
                {"value": "RCT", "label": {"ar": "تجربة عشوائية مضبوطة", "en": "Randomized Controlled Trial"}},
                {"value": "COHORT", "label": {"ar": "دراسة أترابية", "en": "Cohort Study"}},
                {"value": "CASE_CONTROL", "label": {"ar": "دراسة حالات وشواهد", "en": "Case-Control Study"}},
                {"value": "QUALITATIVE", "label": {"ar": "دراسة نوعية", "en": "Qualitative Study"}},
                {"value": "OTHER", "label": {"ar": "أخرى", "en": "Other"}}
              ]},
            {"name": "sample_size_adequate", "label": {"ar": "كفاية حجم العينة", "en": "Adequacy of Sample Size"}, "type": "scale", "required": true, "min": 1, "max": 5},
            {"name": "statistical_plan", "label": {"ar": "الخطة الإحصائية", "en": "Statistical Plan"}, "type": "textarea", "required": false, "rows": 4},
            {"name": "scientific_comment", "label": {"ar": "تعليق علمي", "en": "Scientific Comment"}, "type": "textarea", "required": false, "rows": 6}
          ]
        },
        {
          "id": "verdict",
          "title": {"ar": "القرار", "en": "Verdict"},
          "fields": [
            {
              "name": "recommendation", "label": {"ar": "التوصية", "en": "Recommendation"}, "type": "radio", "required": true,
              "options": [
                {"value": "APPROVE", "label": {"ar": "الموافقة", "en": "Approve"}},
                {"value": "APPROVE_WITH_CHANGES", "label": {"ar": "الموافقة مع تعديلات", "en": "Approve with Changes"}},
                {"value": "REJECT", "label": {"ar": "الرفض", "en": "Reject"}},
                {"value": "RETURN", "label": {"ar": "إعادة للمراجعة", "en": "Return for Revision"}}
              ]
            },
            {"name": "recommendation_justification", "label": {"ar": "مبرر القرار", "en": "Justification"}, "type": "textarea", "required": true, "rows": 4,
              "conditional": {"field": "recommendation", "equals": "REJECT"}},
            {"name": "changes_required", "label": {"ar": "التعديلات المطلوبة", "en": "Required Changes"}, "type": "textarea", "required": false, "rows": 4}
          ]
        }
      ],
      "computed": {"total_score": {"type": "mean", "fields": ["objectives_clarity", "sample_size_adequate"]}}
    }$json$,
    'schema-form', true
  ),
  (
    'ETH_REVIEW', 'المراجعة الأخلاقية', 'Ethics Review Form',
    'REVIEW', 'Ethical Review', 1, '1.0.0',
    $json${
      "$schema": "https://json-schema.org/draft/2020-12/schema",
      "formCode": "ETH_REVIEW",
      "version": "1.0.0",
      "sections": [
        {
          "id": "human_protection",
          "title": {"ar": "حماية المشاركين", "en": "Human Subject Protection"},
          "fields": [
            {"name": "consent_process_adequate", "label": {"ar": "إجراءات الموافقة مناسبة", "en": "Consent process adequate"}, "type": "scale", "required": true, "min": 1, "max": 5},
            {"name": "vulnerable_population", "label": {"ar": "هل يشمل البحث فئات ضعيفة؟", "en": "Vulnerable population involved?"}, "type": "boolean", "required": true},
            {"name": "privacy_protected", "label": {"ar": "الخصوصية محمية", "en": "Privacy protected"}, "type": "scale", "required": true, "min": 1, "max": 5},
            {"name": "risk_benefit_balance", "label": {"ar": "توازن المخاطر والفوائد", "en": "Risk/benefit balance"}, "type": "scale", "required": true, "min": 1, "max": 5}
          ]
        },
        {
          "id": "verdict",
          "title": {"ar": "القرار", "en": "Verdict"},
          "fields": [
            {
              "name": "recommendation", "label": {"ar": "التوصية", "en": "Recommendation"}, "type": "radio", "required": true,
              "options": [
                {"value": "APPROVE", "label": {"ar": "الموافقة", "en": "Approve"}},
                {"value": "APPROVE_WITH_CHANGES", "label": {"ar": "الموافقة مع تعديلات", "en": "Approve with Changes"}},
                {"value": "REJECT", "label": {"ar": "الرفض", "en": "Reject"}}
              ]
            },
            {"name": "ethics_comment", "label": {"ar": "ملاحظات أخلاقية", "en": "Ethics Comments"}, "type": "textarea", "required": true, "rows": 5}
          ]
        }
      ],
      "computed": {"total_score": {"type": "mean", "fields": ["consent_process_adequate", "privacy_protected", "risk_benefit_balance"]}}
    }$json$,
    'schema-form', true
  ),
  (
    'ANNUAL_PROGRESS', 'تقرير التقدم السنوي', 'Annual Progress Report',
    'POST_APPROVAL', 'Continuing Review', 1, '1.0.0',
    $json${
      "$schema": "https://json-schema.org/draft/2020-12/schema",
      "formCode": "ANNUAL_PROGRESS",
      "version": "1.0.0",
      "sections": [
        {
          "id": "period",
          "title": {"ar": "فترة التقرير", "en": "Reporting Period"},
          "fields": [
            {"name": "period_start", "label": {"ar": "بداية الفترة", "en": "Period Start"}, "type": "date", "required": true},
            {"name": "period_end", "label": {"ar": "نهاية الفترة", "en": "Period End"}, "type": "date", "required": true}
          ]
        },
        {
          "id": "progress",
          "title": {"ar": "التقدم", "en": "Progress"},
          "fields": [
            {"name": "participants_enrolled", "label": {"ar": "عدد المشاركين المسجلين", "en": "Participants Enrolled"}, "type": "number", "required": true, "min": 0},
            {"name": "participants_completed", "label": {"ar": "عدد المشاركين المكملين", "en": "Participants Completed"}, "type": "number", "required": true, "min": 0},
            {"name": "adverse_events", "label": {"ar": "الأحداث العكسية", "en": "Adverse Events"}, "type": "number", "required": true, "min": 0},
            {"name": "summary", "label": {"ar": "ملخص التقدم", "en": "Progress Summary"}, "type": "textarea", "required": true, "rows": 6}
          ]
        }
      ]
    }$json$,
    'schema-form', true
  ),
  (
    'SAE_REPORT', 'تقرير الحدث العكسي الخطير', 'Serious Adverse Event Report',
    'SAFETY', 'SAE Review', 1, '1.0.0',
    $json${
      "$schema": "https://json-schema.org/draft/2020-12/schema",
      "formCode": "SAE_REPORT",
      "version": "1.0.0",
      "sections": [
        {
          "id": "event",
          "title": {"ar": "بيانات الحدث", "en": "Event Details"},
          "fields": [
            {"name": "event_date", "label": {"ar": "تاريخ الحدث", "en": "Event Date"}, "type": "date", "required": true},
            {"name": "report_timeliness", "label": {"ar": "الالتزام بالتبليغ", "en": "Reporting Timeliness"}, "type": "select", "required": true,
              "options": [
                {"value": "WITHIN_24H", "label": {"ar": "خلال 24 ساعة", "en": "Within 24 hours"}},
                {"value": "WITHIN_7D", "label": {"ar": "خلال 7 أيام", "en": "Within 7 days"}},
                {"value": "DELAYED", "label": {"ar": "متأخر", "en": "Delayed"}}
              ]},
            {"name": "event_type", "label": {"ar": "نوع الحدث", "en": "Event Type"}, "type": "select", "required": true,
              "options": [
                {"value": "DEATH", "label": {"ar": "وفاة", "en": "Death"}},
                {"value": "LIFE_THREATENING", "label": {"ar": "يهدد الحياة", "en": "Life-threatening"}},
                {"value": "HOSPITALIZATION", "label": {"ar": "تنويم بالمستشفى", "en": "Hospitalization"}},
                {"value": "DISABILITY", "label": {"ar": "إعاقة دائمة", "en": "Persistent Disability"}},
                {"value": "CONGENITAL", "label": {"ar": "تشوه خلقي", "en": "Congenital Anomaly"}},
                {"value": "OTHER_SERIOUS", "label": {"ar": "حدث خطير آخر", "en": "Other Serious Event"}}
              ]},
            {"name": "severity", "label": {"ar": "الشدة", "en": "Severity"}, "type": "select", "required": true,
              "options": [
                {"value": "G1", "label": {"ar": "درجة 1", "en": "Grade 1"}},
                {"value": "G2", "label": {"ar": "درجة 2", "en": "Grade 2"}},
                {"value": "G3", "label": {"ar": "درجة 3", "en": "Grade 3"}},
                {"value": "G4", "label": {"ar": "درجة 4", "en": "Grade 4"}},
                {"value": "G5", "label": {"ar": "درجة 5", "en": "Grade 5"}}
              ]},
            {"name": "relationship", "label": {"ar": "العلاقة السببية", "en": "Causality"}, "type": "select", "required": true,
              "options": [
                {"value": "UNRELATED", "label": {"ar": "غير مرتبط", "en": "Unrelated"}},
                {"value": "POSSIBLE", "label": {"ar": "ممكن", "en": "Possible"}},
                {"value": "PROBABLE", "label": {"ar": "مرجح", "en": "Probable"}},
                {"value": "DEFINITE", "label": {"ar": "مؤكد", "en": "Definite"}}
              ]},
            {"name": "expectedness", "label": {"ar": "التوقع", "en": "Expectedness"}, "type": "select", "required": true,
              "options": [
                {"value": "EXPECTED", "label": {"ar": "متوقع", "en": "Expected"}},
                {"value": "UNEXPECTED", "label": {"ar": "غير متوقع", "en": "Unexpected"}}
              ]}
          ]
        },
        {
          "id": "participant",
          "title": {"ar": "بيانات المشارك", "en": "Participant"},
          "fields": [
            {"name": "participant_id", "label": {"ar": "معرّف المشارك (مشفر)", "en": "Participant ID (coded)"}, "type": "text", "required": true},
            {"name": "participant_outcome", "label": {"ar": "حالة المشارك", "en": "Outcome"}, "type": "select", "required": true,
              "options": [
                {"value": "RECOVERED", "label": {"ar": "تعافى", "en": "Recovered"}},
                {"value": "RECOVERING", "label": {"ar": "في تحسن", "en": "Recovering"}},
                {"value": "DEATH", "label": {"ar": "وفاة", "en": "Death"}},
                {"value": "UNKNOWN", "label": {"ar": "غير معروف", "en": "Unknown"}}
              ]}
          ]
        },
        {
          "id": "actions",
          "title": {"ar": "الإجراءات", "en": "Actions Taken"},
          "fields": [
            {"name": "event_description", "label": {"ar": "وصف الحدث", "en": "Event Description"}, "type": "textarea", "required": true, "rows": 6},
            {"name": "action_taken", "label": {"ar": "الإجراء المتخذ", "en": "Action Taken"}, "type": "textarea", "required": true, "rows": 4},
            {"name": "protocol_change", "label": {"ar": "هل يتطلب تعديل البروتوكول؟", "en": "Requires a protocol amendment?"}, "type": "boolean", "required": true}
          ]
        }
      ]
    }$json$,
    'schema-form', true
  ),
  (
    'SITE_MONITORING', 'قائمة مراقبة الموقع', 'Site Monitoring Checklist',
    'MONITORING', 'Study Monitoring', 1, '1.0.0',
    $json${
      "$schema": "https://json-schema.org/draft/2020-12/schema",
      "formCode": "SITE_MONITORING",
      "version": "1.0.0",
      "sections": [
        {
          "id": "visit",
          "title": {"ar": "بيانات الزيارة", "en": "Visit Details"},
          "fields": [
            {"name": "site_name", "label": {"ar": "اسم الموقع", "en": "Site Name"}, "type": "text", "required": true},
            {"name": "visit_date", "label": {"ar": "تاريخ الزيارة", "en": "Visit Date"}, "type": "date", "required": true},
            {"name": "monitor_name", "label": {"ar": "اسم المراقب", "en": "Monitor Name"}, "type": "text", "required": true}
          ]
        },
        {
          "id": "verification",
          "title": {"ar": "التحقق", "en": "Verification"},
          "fields": [
            {"name": "source_data_verified", "label": {"ar": "تم التحقق من المصادر", "en": "Source data verified"}, "type": "boolean", "required": true},
            {"name": "consent_verified_count", "label": {"ar": "عدد نماذج الموافقة المفحوصة", "en": "Consent forms verified"}, "type": "number", "required": true, "min": 0},
            {"name": "eligibility_adherence", "label": {"ar": "الالتزام بمعايير الأهلية", "en": "Eligibility adherence"}, "type": "scale", "required": true, "min": 1, "max": 5},
            {"name": "ae_documentation", "label": {"ar": "توثيق الأحداث العكسية", "en": "AE documentation"}, "type": "scale", "required": true, "min": 1, "max": 5}
          ]
        },
        {
          "id": "findings",
          "title": {"ar": "النتائج", "en": "Findings"},
          "fields": [
            {"name": "critical_findings", "label": {"ar": "نتائج حرجة", "en": "Critical Findings"}, "type": "textarea", "required": false, "rows": 3},
            {"name": "major_findings", "label": {"ar": "نتائج رئيسية", "en": "Major Findings"}, "type": "textarea", "required": false, "rows": 3},
            {"name": "minor_findings", "label": {"ar": "نتائج ثانوية", "en": "Minor Findings"}, "type": "textarea", "required": false, "rows": 3},
            {"name": "corrective_actions", "label": {"ar": "الإجراءات التصحيحية", "en": "Corrective Actions"}, "type": "textarea", "required": false, "rows": 3},
            {"name": "follow_up_date", "label": {"ar": "تاريخ المتابعة", "en": "Follow-up Date"}, "type": "date", "required": false}
          ]
        }
      ]
    }$json$,
    'schema-form', true
  ),
  (
    'STUDY_CLOSURE', 'تقرير إغلاق الدراسة', 'Study Closure Report',
    'CLOSURE', 'Study Closure', 1, '1.0.0',
    $json${
      "$schema": "https://json-schema.org/draft/2020-12/schema",
      "formCode": "STUDY_CLOSURE",
      "version": "1.0.0",
      "sections": [
        {
          "id": "enrollment",
          "title": {"ar": "التسجيل", "en": "Enrollment"},
          "fields": [
            {"name": "final_enrollment", "label": {"ar": "إجمالي المشاركين المسجلين", "en": "Final Enrollment"}, "type": "number", "required": true, "min": 0},
            {"name": "completion_date", "label": {"ar": "تاريخ الإنجاز", "en": "Completion Date"}, "type": "date", "required": true}
          ]
        },
        {
          "id": "retention",
          "title": {"ar": "الاحتفاظ بالبيانات", "en": "Data Retention"},
          "fields": [
            {"name": "data_retention_period", "label": {"ar": "مدة الاحتفاظ (شهور)", "en": "Retention (months)"}, "type": "number", "required": true, "min": 0},
            {"name": "archive_location", "label": {"ar": "موقع الأرشيف", "en": "Archive Location"}, "type": "text", "required": true},
            {"name": "notes", "label": {"ar": "ملاحظات", "en": "Notes"}, "type": "textarea", "required": false, "rows": 4}
          ]
        }
      ]
    }$json$,
    'schema-form', true
  ),
  (
    'COMM_MINUTES', 'محضر اجتماع اللجنة', 'Committee Meeting Minutes',
    'MEETING', 'Committee Review', 1, '1.0.0',
    $json${
      "$schema": "https://json-schema.org/draft/2020-12/schema",
      "formCode": "COMM_MINUTES",
      "version": "1.0.0",
      "sections": [
        {
          "id": "meeting",
          "title": {"ar": "بيانات الاجتماع", "en": "Meeting Details"},
          "fields": [
            {"name": "meeting_ref", "label": {"ar": "مرجع الاجتماع", "en": "Meeting Reference"}, "type": "text", "required": true},
            {"name": "meeting_date", "label": {"ar": "تاريخ الاجتماع", "en": "Meeting Date"}, "type": "date", "required": true},
            {"name": "chair", "label": {"ar": "الرئيس", "en": "Chairperson"}, "type": "text", "required": true},
            {"name": "quorum_confirmed", "label": {"ar": "اكتمال النصاب القانوني", "en": "Quorum confirmed"}, "type": "boolean", "required": true}
          ]
        },
        {
          "id": "proceedings",
          "title": {"ar": "الجلسة", "en": "Proceedings"},
          "fields": [
            {"name": "call_to_order", "label": {"ar": "افتتاح الجلسة", "en": "Call to Order"}, "type": "textarea", "required": true, "rows": 2},
            {"name": "conflict_summary", "label": {"ar": "إقرارات تعارض المصالح", "en": "Conflict of Interest Summary"}, "type": "textarea", "required": false, "rows": 3},
            {"name": "docket_review", "label": {"ar": "مراجعة البنود", "en": "Docket Review"}, "type": "textarea", "required": true, "rows": 8},
            {"name": "adjournment", "label": {"ar": "اختتام الجلسة", "en": "Adjournment"}, "type": "textarea", "required": true, "rows": 2}
          ]
        }
      ]
    }$json$,
    'schema-form', true
  )
ON CONFLICT (form_code, version_no) DO UPDATE SET
  form_name_ar = EXCLUDED.form_name_ar,
  form_name_en = EXCLUDED.form_name_en,
  category = EXCLUDED.category,
  workflow_stage = EXCLUDED.workflow_stage,
  form_schema = EXCLUDED.form_schema,
  schema_version = EXCLUDED.schema_version,
  renderer = EXCLUDED.renderer,
  is_active = EXCLUDED.is_active;

-- ============================================================
-- 8. Reference Document Types for numbering categories
-- ============================================================
INSERT INTO documents.document_numbering (category, year, prefix, last_seq)
SELECT 'OFFICIAL_LETTER', EXTRACT(YEAR FROM now())::int, 'DEC', 0
WHERE NOT EXISTS (SELECT 1 FROM documents.document_numbering WHERE category = 'OFFICIAL_LETTER' AND year = EXTRACT(YEAR FROM now())::int);

INSERT INTO documents.document_numbering (category, year, prefix, last_seq)
SELECT 'REVIEW_FORM', EXTRACT(YEAR FROM now())::int, 'RVW', 0
WHERE NOT EXISTS (SELECT 1 FROM documents.document_numbering WHERE category = 'REVIEW_FORM' AND year = EXTRACT(YEAR FROM now())::int);

INSERT INTO documents.document_numbering (category, year, prefix, last_seq)
SELECT 'MEETING_DOCUMENT', EXTRACT(YEAR FROM now())::int, 'COM', 0
WHERE NOT EXISTS (SELECT 1 FROM documents.document_numbering WHERE category = 'MEETING_DOCUMENT' AND year = EXTRACT(YEAR FROM now())::int);

INSERT INTO documents.document_numbering (category, year, prefix, last_seq)
SELECT 'SAFETY_REPORT', EXTRACT(YEAR FROM now())::int, 'SAF', 0
WHERE NOT EXISTS (SELECT 1 FROM documents.document_numbering WHERE category = 'SAFETY_REPORT' AND year = EXTRACT(YEAR FROM now())::int);

INSERT INTO documents.document_numbering (category, year, prefix, last_seq)
SELECT 'MONITORING_REPORT', EXTRACT(YEAR FROM now())::int, 'MON', 0
WHERE NOT EXISTS (SELECT 1 FROM documents.document_numbering WHERE category = 'MONITORING_REPORT' AND year = EXTRACT(YEAR FROM now())::int);

INSERT INTO documents.document_numbering (category, year, prefix, last_seq)
SELECT 'CLOSURE_REPORT', EXTRACT(YEAR FROM now())::int, 'FIN', 0
WHERE NOT EXISTS (SELECT 1 FROM documents.document_numbering WHERE category = 'CLOSURE_REPORT' AND year = EXTRACT(YEAR FROM now())::int);

INSERT INTO documents.document_numbering (category, year, prefix, last_seq)
SELECT 'CONSENT_DOCUMENT', EXTRACT(YEAR FROM now())::int, 'ICF', 0
WHERE NOT EXISTS (SELECT 1 FROM documents.document_numbering WHERE category = 'CONSENT_DOCUMENT' AND year = EXTRACT(YEAR FROM now())::int);
