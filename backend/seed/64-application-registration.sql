-- ============================================================
-- 64-application-registration.sql
-- ============================================================
-- Gate 1 / Wave 1 — Research Application Registration (FRM-001).
-- يضيف:
--   1) تعريف النموذج APP_PROTOCOL (مخطط JSON، وضع المعالج wizard،
--      ربط سير العمل schema.workflow، تكوين المستند schema.document).
--   2) نوع مستند APPLICATION وترقيم REC (يُدار عبر DEFAULT_PREFIXES).
--   3) قوالب APPLICATION_DOC (ar/en) للمستند الرسمي.
-- Idempotent (ON CONFLICT).
-- ============================================================

-- ============================================================
-- 1. Official Document Type: APPLICATION
-- ============================================================
INSERT INTO documents.document_types (type_code, type_name_ar, type_name_en, description, is_required)
VALUES (
  'APPLICATION',
  'طلب تسجيل دراسة',
  'Application Registration',
  'نموذج تسجيل البحث (البروتوكول) المقدم لطلب المراجعة الأخلاقية',
  false
)
ON CONFLICT (type_code) DO NOTHING;

-- ============================================================
-- 2. Form Definition: APP_PROTOCOL
-- ============================================================
INSERT INTO forms.form_definitions
  (form_code, form_name_ar, form_name_en, category, workflow_stage, version_no, schema_version, form_schema, renderer, is_active)
VALUES (
  'APP_PROTOCOL',
  'طلب تسجيل الدراسة (البروتوكول)',
  'Research Application Registration (Protocol)',
  'APPLICATION',
  'Application Registration',
  1, '1.1.0',
  $json${
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "formCode": "APP_PROTOCOL",
  "version": "1.0.0",
  "wizard": true,
  "workflow": { "entity_type": "Application", "workflow_code": "APP_REVIEW_V1", "transition_on_submit": "SUBMIT" },
  "document": { "template_code": "APPLICATION_DOC", "document_type": "APPLICATION" },
  "computed": {
    "total_score": {
      "type": "count_checked",
      "fields": ["doc_protocol", "doc_icf", "doc_pis", "doc_cv_pi", "doc_funding", "doc_irb_prior", "doc_declaration"]
    }
  },
  "sections": [
    {
      "id": "applicant",
      "title": { "ar": "المتقدم والباحث الرئيسي", "en": "Applicant & Principal Investigator" },
      "fields": [
        { "name": "pi_name", "label": { "ar": "اسم الباحث الرئيسي", "en": "Principal Investigator Name" }, "type": "text", "required": true, "maxLength": 200 },
        { "name": "pi_email", "label": { "ar": "البريد الإلكتروني", "en": "Email" }, "type": "email", "required": true, "maxLength": 200 },
        { "name": "pi_phone", "label": { "ar": "رقم الجوال", "en": "Mobile Phone" }, "type": "tel", "required": true, "pattern": "^[0-9+\\-\\s()]{7,15}$", "helpText": { "ar": "مثال: 05xxxxxxxx أو +9665xxxxxxxx", "en": "e.g. 05xxxxxxxx or +9665xxxxxxxx" } },
        { "name": "pi_department", "label": { "ar": "القسم / الوحدة", "en": "Department / Unit" }, "type": "text", "required": true, "maxLength": 200 },
        { "name": "pi_position", "label": { "ar": "المسمى الوظيفي", "en": "Job Title" }, "type": "text", "required": true, "maxLength": 200 },
        { "name": "pi_qualifications", "label": { "ar": "المؤهلات العلمية", "en": "Academic Qualifications" }, "type": "textarea", "rows": 3 }
      ]
    },
    {
      "id": "study_overview",
      "title": { "ar": "نظرة عامة على الدراسة", "en": "Study Overview" },
      "fields": [
        { "name": "study_title_ar", "label": { "ar": "عنوان الدراسة (عربي)", "en": "Study Title (Arabic)" }, "type": "textarea", "required": true, "rows": 2 },
        { "name": "study_title_en", "label": { "ar": "عنوان الدراسة (إنجليزي)", "en": "Study Title (English)" }, "type": "textarea", "required": true, "rows": 2 },
        { "name": "study_type", "label": { "ar": "نوع الدراسة", "en": "Study Type" }, "type": "select", "required": true, "options": [
          { "value": "INTERVENTIONAL_DRUG", "label": { "ar": "تدخلي - دوائي", "en": "Interventional - Drug" } },
          { "value": "INTERVENTIONAL_DEVICE", "label": { "ar": "تدخلي - أجهزة", "en": "Interventional - Device" } },
          { "value": "INTERVENTIONAL_PROCEDURE", "label": { "ar": "تدخلي - إجراء", "en": "Interventional - Procedure" } },
          { "value": "OBSERVATIONAL", "label": { "ar": "رصدي", "en": "Observational" } },
          { "value": "REGISTRY", "label": { "ar": "سجل", "en": "Registry" } },
          { "value": "QUALITATIVE", "label": { "ar": "نوعي", "en": "Qualitative" } },
          { "value": "OTHER", "label": { "ar": "أخرى", "en": "Other" } }
        ] },
        { "name": "study_design", "label": { "ar": "التصميم الدراسي", "en": "Study Design" }, "type": "select", "required": true, "options": [
          { "value": "RCT", "label": { "ar": "تجربة عشوائية مضبوطة", "en": "Randomized Controlled Trial" } },
          { "value": "CROSS_SECTIONAL", "label": { "ar": "مقطعية", "en": "Cross-Sectional" } },
          { "value": "COHORT", "label": { "ar": "أترابية", "en": "Cohort" } },
          { "value": "CASE_CONTROL", "label": { "ar": "حالات وشواهد", "en": "Case-Control" } },
          { "value": "CASE_SERIES", "label": { "ar": "سلسلة حالات", "en": "Case Series" } },
          { "value": "MIXED_METHODS", "label": { "ar": "طرق مختلطة", "en": "Mixed Methods" } },
          { "value": "OTHER", "label": { "ar": "أخرى", "en": "Other" } }
        ] },
        { "name": "study_summary", "label": { "ar": "ملخص الدراسة", "en": "Study Summary" }, "type": "textarea", "required": true, "rows": 5 },
        { "name": "primary_objective", "label": { "ar": "الهدف الرئيسي", "en": "Primary Objective" }, "type": "textarea", "required": true, "rows": 3 },
        { "name": "secondary_objectives", "label": { "ar": "الأهداف الثانوية", "en": "Secondary Objectives" }, "type": "textarea", "rows": 3 },
        { "name": "start_date", "label": { "ar": "تاريخ البدء المتوقع", "en": "Expected Start Date" }, "type": "date", "required": true },
        { "name": "end_date", "label": { "ar": "تاريخ الانتهاء المتوقع", "en": "Expected End Date" }, "type": "date", "required": true, "dependencies": [
          { "field": "start_date", "op": "gte", "message": { "ar": "يجب أن يكون تاريخ الانتهاء بعد تاريخ البدء", "en": "End date must be after start date" } }
        ] },
        { "name": "funding_source", "label": { "ar": "مصدر التمويل", "en": "Funding Source" }, "type": "select", "required": true, "options": [
          { "value": "INSTITUTION", "label": { "ar": "الجهة", "en": "Institution" } },
          { "value": "GOVERNMENT", "label": { "ar": "حكومي", "en": "Government" } },
          { "value": "INDUSTRY", "label": { "ar": "قطاع خاص", "en": "Industry" } },
          { "value": "NGO", "label": { "ar": "منظمة غير ربحية", "en": "Non-profit" } },
          { "value": "SELF_FUNDED", "label": { "ar": "ذاتي", "en": "Self-funded" } },
          { "value": "NONE", "label": { "ar": "بدون تمويل", "en": "None" } }
        ] },
        { "name": "multi_center", "label": { "ar": "دراسة متعددة المواقع؟", "en": "Multi-center study?" }, "type": "boolean", "required": true },
        { "name": "study_sites", "label": { "ar": "المواقع المشاركة", "en": "Participating Sites" }, "type": "textarea", "rows": 3, "conditional": { "field": "multi_center", "op": "eq", "value": true }, "helpText": { "ar": "اذكر أسماء المواقع والجهات المشاركة", "en": "List participating sites and institutions" } }
      ]
    },
    {
      "id": "participants",
      "title": { "ar": "المشاركون", "en": "Participants" },
      "fields": [
        { "name": "population", "label": { "ar": "مجتمع الدراسة", "en": "Study Population" }, "type": "textarea", "required": true, "rows": 3 },
        { "name": "inclusion_criteria", "label": { "ar": "معايير الإدراج", "en": "Inclusion Criteria" }, "type": "textarea", "required": true, "rows": 3 },
        { "name": "exclusion_criteria", "label": { "ar": "معايير الاستبعاد", "en": "Exclusion Criteria" }, "type": "textarea", "required": true, "rows": 3 },
        { "name": "vulnerable_groups", "label": { "ar": "الفئات الهشة (إن وجدت)", "en": "Vulnerable Groups (if any)" }, "type": "checkbox", "required": true, "options": [
          { "value": "MINORS", "label": { "ar": "قاصرون", "en": "Minors" } },
          { "value": "PREGNANT", "label": { "ar": "حوامل", "en": "Pregnant women" } },
          { "value": "PRISONERS", "label": { "ar": "نزلاء", "en": "Prisoners" } },
          { "value": "COGNITIVE_IMPAIRED", "label": { "ar": "ضعف إدراكي", "en": "Cognitively impaired" } },
          { "value": "CRITICALLY_ILL", "label": { "ar": "مرضى حرجون", "en": "Critically ill" } },
          { "value": "ECONOMICALLY_DISADVANTAGED", "label": { "ar": "محرومون اقتصادياً", "en": "Economically disadvantaged" } },
          { "value": "NONE", "label": { "ar": "لا توجد", "en": "None" } }
        ] },
        { "name": "vulnerable_measures", "label": { "ar": "الضمانات الإضافية للفئات الهشة", "en": "Additional Safeguards for Vulnerable Groups" }, "type": "textarea", "rows": 4, "conditional": { "field": "vulnerable_groups", "op": "in", "value": ["MINORS", "PREGNANT", "PRISONERS", "COGNITIVE_IMPAIRED", "CRITICALLY_ILL", "ECONOMICALLY_DISADVANTAGED"] } },
        { "name": "sample_size", "label": { "ar": "حجم العينة", "en": "Sample Size" }, "type": "number", "required": true, "min": 1, "unit": "مشارك / participants" },
        { "name": "sample_size_justification", "label": { "ar": "مبرر حجم العينة", "en": "Sample Size Justification" }, "type": "textarea", "required": true, "rows": 3 },
        { "name": "recruitment_method", "label": { "ar": "طريقة استقطاب المشاركين", "en": "Recruitment Method" }, "type": "textarea", "required": true, "rows": 3 }
      ]
    },
    {
      "id": "methodology",
      "title": { "ar": "المنهجية", "en": "Methodology" },
      "fields": [
        { "name": "procedures", "label": { "ar": "الإجراءات الدراسية", "en": "Study Procedures" }, "type": "textarea", "required": true, "rows": 5 },
        { "name": "data_collection", "label": { "ar": "طرق جمع البيانات", "en": "Data Collection Methods" }, "type": "textarea", "required": true, "rows": 3 },
        { "name": "data_analysis", "label": { "ar": "التحليل الإحصائي", "en": "Data Analysis" }, "type": "textarea", "required": true, "rows": 3 },
        { "name": "biospecimens", "label": { "ar": "هل تُجمع عينات بيولوجية؟", "en": "Are biological samples collected?" }, "type": "boolean", "required": true },
        { "name": "biospecimens_details", "label": { "ar": "وصف العينات", "en": "Sample Description" }, "type": "textarea", "rows": 3, "conditional": { "field": "biospecimens", "op": "eq", "value": true } },
        { "name": "biospecimens_storage", "label": { "ar": "تخزين العينات", "en": "Sample Storage" }, "type": "select", "conditional": { "field": "biospecimens", "op": "eq", "value": true }, "options": [
          { "value": "NO_STORAGE", "label": { "ar": "لا تخزين بعد التحليل", "en": "No storage after analysis" } },
          { "value": "SHORT_TERM", "label": { "ar": "تخزين قصير المدى", "en": "Short-term" } },
          { "value": "LONG_TERM", "label": { "ar": "تخزين طويل المدى", "en": "Long-term" } },
          { "value": "BIOBANK", "label": { "ar": "بنك بيولوجي", "en": "Biobank" } }
        ] }
      ]
    },
    {
      "id": "ethics",
      "title": { "ar": "الاعتبارات الأخلاقية", "en": "Ethics Considerations" },
      "fields": [
        { "name": "risk_level", "label": { "ar": "مستوى المخاطر", "en": "Risk Level" }, "type": "radio", "required": true, "options": [
          { "value": "MINIMAL", "label": { "ar": "أدنى من الحد الأدنى", "en": "Minimal" } },
          { "value": "LOW", "label": { "ar": "منخفض", "en": "Low" } },
          { "value": "MODERATE", "label": { "ar": "متوسط", "en": "Moderate" } },
          { "value": "HIGH", "label": { "ar": "مرتفع", "en": "High" } }
        ] },
        { "name": "risk_justification", "label": { "ar": "مبرر مستوى المخاطر", "en": "Risk Justification" }, "type": "textarea", "required": true, "rows": 3 },
        { "name": "potential_benefits", "label": { "ar": "الفوائد المحتملة", "en": "Potential Benefits" }, "type": "textarea", "required": true, "rows": 3 },
        { "name": "consent_required", "label": { "ar": "هل يتطلب الدراسة موافقة مستنيرة؟", "en": "Is informed consent required?" }, "type": "boolean", "required": true },
        { "name": "consent_process", "label": { "ar": "إجراءات الحصول على الموافقة", "en": "Consent Process" }, "type": "textarea", "rows": 4, "conditional": { "field": "consent_required", "op": "eq", "value": true } },
        { "name": "waiver_of_consent", "label": { "ar": "هل يُطلب إعفاء من الموافقة؟", "en": "Is a consent waiver requested?" }, "type": "boolean", "required": true },
        { "name": "waiver_justification", "label": { "ar": "مبرر الإعفاء", "en": "Waiver Justification" }, "type": "textarea", "rows": 4, "conditional": { "field": "waiver_of_consent", "op": "eq", "value": true } },
        { "name": "compensation", "label": { "ar": "التعويض", "en": "Compensation" }, "type": "select", "required": true, "options": [
          { "value": "NONE", "label": { "ar": "بدون تعويض", "en": "None" } },
          { "value": "EXPENSES", "label": { "ar": "تعويض مصاريف", "en": "Expense reimbursement" } },
          { "value": "STIPEND", "label": { "ar": "مكافأة", "en": "Stipend" } },
          { "value": "OTHER", "label": { "ar": "أخرى", "en": "Other" } }
        ] },
        { "name": "compensation_details", "label": { "ar": "تفاصيل التعويض", "en": "Compensation Details" }, "type": "textarea", "rows": 3, "conditional": { "field": "compensation", "op": "ne", "value": "NONE" } },
        { "name": "confidentiality_protection", "label": { "ar": "حماية سرية البيانات", "en": "Confidentiality Protection" }, "type": "textarea", "required": true, "rows": 3 },
        { "name": "data_retention_years", "label": { "ar": "مدة الاحتفاظ بالبيانات (سنوات)", "en": "Data Retention (years)" }, "type": "number", "required": true, "min": 1, "max": 100 },
        { "name": "anonymization", "label": { "ar": "هل تُعاد تسمية البيانات/إخفاء هويتها؟", "en": "Will data be anonymized/de-identified?" }, "type": "boolean", "required": true },
        { "name": "data_transfer_international", "label": { "ar": "هل تُنقل البيانات دولياً؟", "en": "Will data be transferred internationally?" }, "type": "boolean", "required": true },
        { "name": "transfer_details", "label": { "ar": "تفاصيل النقل الدولي", "en": "International Transfer Details" }, "type": "textarea", "rows": 3, "conditional": { "field": "data_transfer_international", "op": "eq", "value": true } }
      ]
    },
    {
      "id": "attachments",
      "title": { "ar": "المستندات المرفقة", "en": "Attached Documents" },
      "fields": [
        { "name": "attachments_note", "label": { "ar": "قائمة التحقق — يُرفق كل مستند ضمن تبويب المستندات في الطلب قبل الإرسال", "en": "Checklist — attach each document under the application Documents tab before submitting" }, "type": "text", "required": false },
        { "name": "doc_protocol", "label": { "ar": "بروتوكول البحث كاملاً", "en": "Full Research Protocol" }, "type": "boolean", "required": true },
        { "name": "doc_icf", "label": { "ar": "نموذج الموافقة المستنيرة (ICF)", "en": "Informed Consent Form (ICF)" }, "type": "boolean", "required": true },
        { "name": "doc_pis", "label": { "ar": "معلومات المشارك (PIS)", "en": "Participant Information Sheet (PIS)" }, "type": "boolean", "required": true },
        { "name": "doc_cv_pi", "label": { "ar": "السيرة الذاتية للباحث الرئيسي", "en": "Principal Investigator CV" }, "type": "boolean", "required": true },
        { "name": "doc_funding", "label": { "ar": "وثيقة التمويل / الدعم", "en": "Funding / Support Letter" }, "type": "boolean", "required": false },
        { "name": "doc_irb_prior", "label": { "ar": "موافقات لجان سابقة (إن وجدت)", "en": "Prior IRB Approvals (if any)" }, "type": "boolean", "required": false },
        { "name": "doc_declaration", "label": { "ar": "أُقر بصحة البيانات المقدمة وإرفاق جميع المستندات المطلوبة", "en": "I declare the data provided is accurate and all required documents are attached" }, "type": "boolean", "required": true }
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
-- 3. APPLICATION_DOC templates (ar / en)
-- ============================================================
INSERT INTO documents.templates
  (template_code, template_name, template_type, template_content, version_no, is_active, language, document_category, is_default)
VALUES (
  'APPLICATION_DOC', 'نموذج طلب تسجيل الدراسة', 'HTML',
  $tpl$<div class="letter-body" dir="rtl">
  <p class="recipient-line">
    <span class="label">رقم المستند:</span> {{documentNumber}}
    <span class="label">رقم الطلب:</span> {{applicationNumber}}
  </p>
  <p class="salutation">السادة أعضاء اللجنة الأخلاقية،</p>
  {{#if sections.length}}
  {{#each sections}}
    <table class="doc-section">
      <thead><tr><th colspan="2">{{title}}</th></tr></thead>
      <tbody>
        {{#each rows}}<tr><td class="field-label">{{label}}</td><td>{{value}}</td></tr>{{/each}}
      </tbody>
    </table>
  {{/each}}
  {{/if}}
  <p class="signature-note">مع خالص الشكر والتقدير،</p>
</div>$tpl$,
  1, true, 'ar', 'APPLICATION', true
)
ON CONFLICT (template_code, language, version_no) DO NOTHING;

INSERT INTO documents.templates
  (template_code, template_name, template_type, template_content, version_no, is_active, language, document_category, is_default)
VALUES (
  'APPLICATION_DOC', 'Research Application Registration Form', 'HTML',
  $tpl$<div class="letter-body" dir="ltr">
  <p class="recipient-line">
    <span class="label">Document No:</span> {{documentNumber}}
    <span class="label">Application No:</span> {{applicationNumber}}
  </p>
  <p class="salutation">Dear Members of the Ethics Committee,</p>
  {{#if sections.length}}
  {{#each sections}}
    <table class="doc-section">
      <thead><tr><th colspan="2">{{title}}</th></tr></thead>
      <tbody>
        {{#each rows}}<tr><td class="field-label">{{label}}</td><td>{{value}}</td></tr>{{/each}}
      </tbody>
    </table>
  {{/each}}
  {{/if}}
  <p class="signature-note">Yours sincerely,</p>
</div>$tpl$,
  1, true, 'en', 'APPLICATION', true
)
ON CONFLICT (template_code, language, version_no) DO NOTHING;

-- ============================================================
-- 4. Reference numbering seed for APPLICATION (REC)
-- ============================================================
INSERT INTO documents.document_numbering (category, year, prefix, last_seq)
SELECT 'APPLICATION', EXTRACT(YEAR FROM now())::int, 'REC', 0
WHERE NOT EXISTS (SELECT 1 FROM documents.document_numbering WHERE category = 'APPLICATION' AND year = EXTRACT(YEAR FROM now())::int);
