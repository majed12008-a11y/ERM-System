-- =============================================================================
-- 63-document-retention-rules.sql
-- سياسات الاحتفاظ الافتراضية للمستندات (بيانات تهيئة / مرجعية)
-- Default document retention rules — reference data.
--
-- يحدد لكل نوع مستند فترة الاحتفاظ بالبيانات وإجراء التصرف عند انتهائها.
-- يُستهلك عبر GET /api/v1/documents/retention-rules (Task 8).
-- Idempotent: safe to re-run (ON CONFLICT (id) DO UPDATE).
-- =============================================================================

INSERT INTO documents.document_retention_rules
  (id, document_type_id, retention_period_days, disposition_action, legal_basis, is_active)
OVERRIDING SYSTEM VALUE
VALUES
  (1,  (SELECT id FROM documents.document_types WHERE type_code = 'PROTOCOL'),             3650, 'ARCHIVE', 'سياسة حفظ سجلات الأبحاث — 10 سنوات', TRUE),   -- Research Protocol
  (2,  (SELECT id FROM documents.document_types WHERE type_code = 'ICF'),                  3650, 'ARCHIVE', 'سياسة حفظ سجلات الأبحاث — 10 سنوات', TRUE),   -- Informed Consent Form
  (3,  (SELECT id FROM documents.document_types WHERE type_code = 'PIS'),                  3650, 'ARCHIVE', 'سياسة حفظ سجلات الأبحاث — 10 سنوات', TRUE),   -- Participant Information Sheet
  (4,  (SELECT id FROM documents.document_types WHERE type_code = 'CV'),                   730,  'DESTROY', 'سياسة السجلات الإدارية — سنتان', TRUE),        -- Curriculum Vitae
  (5,  (SELECT id FROM documents.document_types WHERE type_code = 'QUESTIONNAIRE'),        1825, 'ARCHIVE', 'سياسة حفظ أدوات البحث — 5 سنوات', TRUE),        -- Questionnaire
  (6,  (SELECT id FROM documents.document_types WHERE type_code = 'IRB_APPROVAL'),         3650, 'ARCHIVE', 'سياسة حفظ سجلات الأبحاث — 10 سنوات', TRUE),   -- IRB Approval Letter
  (7,  (SELECT id FROM documents.document_types WHERE type_code = 'FUNDING'),              3650, 'ARCHIVE', 'سياسة حفظ السجلات المالية — 10 سنوات', TRUE),  -- Funding Document
  (8,  (SELECT id FROM documents.document_types WHERE type_code = 'BUDGET'),               2555, 'ARCHIVE', 'سياسة حفظ السجلات المالية — 7 سنوات', TRUE),    -- Budget Document
  (9,  (SELECT id FROM documents.document_types WHERE type_code = 'CRF'),                  5475, 'ARCHIVE', 'سياسة حفظ بيانات المشاركين — 15 سنة', TRUE),     -- Case Report Form
  (10, (SELECT id FROM documents.document_types WHERE type_code = 'SOP'),                  3650, 'ARCHIVE', 'سياسة حفظ الوثائق التشغيلية — 10 سنوات', TRUE), -- Standard Operating Procedure
  (11, (SELECT id FROM documents.document_types WHERE type_code = 'ETHICS_DECISION'),      3650, 'ARCHIVE', 'سياسة حفظ سجلات الأبحاث — 10 سنوات', TRUE),   -- Ethics Committee Decision
  (12, (SELECT id FROM documents.document_types WHERE type_code = 'MEETING_MINUTES'),      3650, 'ARCHIVE', 'سياسة حفظ محاضر اللجان — 10 سنوات', TRUE),      -- Committee Meeting Minutes
  (13, (SELECT id FROM documents.document_types WHERE type_code = 'AMENDMENT_PKG'),        3650, 'ARCHIVE', 'سياسة حفظ سجلات الأبحاث — 10 سنوات', TRUE),   -- Amendment Package
  (14, (SELECT id FROM documents.document_types WHERE type_code = 'FINAL_REPORT'),         3650, 'ARCHIVE', 'سياسة حفظ التقارير النهائية — 10 سنوات', TRUE), -- Final Report
  (15, (SELECT id FROM documents.document_types WHERE type_code = 'PUBLICATION'),          36500, 'ARCHIVE', 'سياسة حفظ المنشورات — دائم', TRUE),            -- Publication (long-term)
  (16, (SELECT id FROM documents.document_types WHERE type_code = 'DATA_COLLECTION'),      1825, 'DESTROY', 'سياسة حفظ أدوات البحث — 5 سنوات', TRUE),        -- Data Collection Tool
  (17, (SELECT id FROM documents.document_types WHERE type_code = 'STUDY_PROPOSAL'),       3650, 'ARCHIVE', 'سياسة حفظ سجلات الأبحاث — 10 سنوات', TRUE),   -- Study Proposal
  (18, (SELECT id FROM documents.document_types WHERE type_code = 'OFFICIAL_LETTER'),      1825, 'ARCHIVE', 'سياسة السجلات الإدارية — 5 سنوات', TRUE),       -- Official Letter
  (19, (SELECT id FROM documents.document_types WHERE type_code = 'REVIEW_FORM'),          3650, 'ARCHIVE', 'سياسة حفظ تقارير المراجعة — 10 سنوات', TRUE),   -- Review Form
  (20, (SELECT id FROM documents.document_types WHERE type_code = 'MEETING_DOCUMENT'),     1825, 'ARCHIVE', 'سياسة السجلات الإدارية — 5 سنوات', TRUE),       -- Meeting Document
  (21, (SELECT id FROM documents.document_types WHERE type_code = 'CONSENT_DOCUMENT'),     3650, 'ARCHIVE', 'سياسة حفظ سجلات الأبحاث — 10 سنوات', TRUE),   -- Consent Document
  (22, (SELECT id FROM documents.document_types WHERE type_code = 'SAFETY_REPORT'),        3650, 'ARCHIVE', 'سياسة حفظ تقارير السلامة — 10 سنوات', TRUE),    -- Safety Report
  (23, (SELECT id FROM documents.document_types WHERE type_code = 'MONITORING_REPORT'),    3650, 'ARCHIVE', 'سياسة حفظ تقارير المراقبة — 10 سنوات', TRUE),   -- Monitoring Report
  (24, (SELECT id FROM documents.document_types WHERE type_code = 'CLOSURE_REPORT'),       3650, 'ARCHIVE', 'سياسة حفظ التقارير الختامية — 10 سنوات', TRUE),  -- Closure Report
  (25, (SELECT id FROM documents.document_types WHERE type_code = 'EVIDENCE_DOC'),         1825, 'ARCHIVE', 'سياسة حفظ مستندات الإثبات — 5 سنوات', TRUE),     -- Evidence Document
  (26, (SELECT id FROM documents.document_types WHERE type_code = 'APPROVAL_CERTIFICATE'), 3650, 'ARCHIVE', 'سياسة حفظ شهادات الاعتماد — 10 سنوات', TRUE),   -- Approval Certificate
  (27, (SELECT id FROM documents.document_types WHERE type_code = 'OTHER'),                1825, 'ARCHIVE', 'سياسة حفظ الوثائق العامة — 5 سنوات', TRUE)       -- Other
ON CONFLICT (id) DO UPDATE
  SET document_type_id      = EXCLUDED.document_type_id,
      retention_period_days = EXCLUDED.retention_period_days,
      disposition_action    = EXCLUDED.disposition_action,
      legal_basis           = EXCLUDED.legal_basis,
      is_active             = EXCLUDED.is_active,
      updated_at            = NOW();

-- مزامنة المتسلسلة مع أكبر معرّف مضروب (id هو GENERATED ALWAYS)
-- Keep the identity sequence in sync after explicit-id inserts.
SELECT setval(pg_get_serial_sequence('documents.document_retention_rules', 'id'),
              (SELECT COALESCE(MAX(id), 1) FROM documents.document_retention_rules));
