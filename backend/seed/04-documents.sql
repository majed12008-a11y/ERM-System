-- ============================================================
-- 04-DOCUMENT TYPES
-- ============================================================

INSERT INTO documents.document_types (type_code, type_name_ar, type_name_en, description, is_required) VALUES
  ('PROTOCOL', 'بروتوكول البحث', 'Research Protocol', 'بروتوكول البحث الكامل', true),
  ('ICF', 'نموذج الموافقة المستنيرة', 'Informed Consent Form', 'نموذج الموافقة المستنيرة', true),
  ('CV', 'السيرة الذاتية', 'Curriculum Vitae', 'السيرة الذاتية للباحث الرئيسي', true),
  ('QUESTIONNAIRE', 'استبيان', 'Questionnaire', 'أدوات جمع البيانات', false),
  ('IRB_APPROVAL', 'موافقة اللجنة', 'IRB Approval Letter', 'خطاب موافقة اللجنة', false),
  ('FUNDING', 'تمويل', 'Funding Document', 'مستندات التمويل', false),
  ('OTHER', 'أخرى', 'Other', 'مستندات أخرى', false);
