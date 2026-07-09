-- =============================================================================
-- Commit 5: Yemen Applications — Document Portfolio
-- Populates documents for all 100 applications from Commit 4
-- =============================================================================

BEGIN;
SELECT set_config('app.user_id', '1', true);
-- =============================================================================
-- 1. NEW DOCUMENT TYPES
-- =============================================================================
INSERT INTO documents.document_types (type_code, type_name_ar, type_name_en, is_required)
SELECT 'PIS', 'معلومات المشارك', 'Participant Information Sheet', false
WHERE NOT EXISTS (SELECT 1 FROM documents.document_types WHERE type_code = 'PIS');
INSERT INTO documents.document_types (type_code, type_name_ar, type_name_en, is_required)
SELECT 'BUDGET', 'وثيقة الميزانية', 'Budget Document', false
WHERE NOT EXISTS (SELECT 1 FROM documents.document_types WHERE type_code = 'BUDGET');
INSERT INTO documents.document_types (type_code, type_name_ar, type_name_en, is_required)
SELECT 'CRF', 'نموذج تقرير الحالة', 'Case Report Form', false
WHERE NOT EXISTS (SELECT 1 FROM documents.document_types WHERE type_code = 'CRF');
INSERT INTO documents.document_types (type_code, type_name_ar, type_name_en, is_required)
SELECT 'SOP', 'الإجراءات التشغيلية القياسية', 'Standard Operating Procedure', false
WHERE NOT EXISTS (SELECT 1 FROM documents.document_types WHERE type_code = 'SOP');
INSERT INTO documents.document_types (type_code, type_name_ar, type_name_en, is_required)
SELECT 'ETHICS_DECISION', 'قرار اللجنة الأخلاقية', 'Ethics Committee Decision', false
WHERE NOT EXISTS (SELECT 1 FROM documents.document_types WHERE type_code = 'ETHICS_DECISION');
INSERT INTO documents.document_types (type_code, type_name_ar, type_name_en, is_required)
SELECT 'MEETING_MINUTES', 'محضر اجتماع اللجنة', 'Committee Meeting Minutes', false
WHERE NOT EXISTS (SELECT 1 FROM documents.document_types WHERE type_code = 'MEETING_MINUTES');
INSERT INTO documents.document_types (type_code, type_name_ar, type_name_en, is_required)
SELECT 'AMENDMENT_PKG', 'حزمة التعديل', 'Amendment Package', false
WHERE NOT EXISTS (SELECT 1 FROM documents.document_types WHERE type_code = 'AMENDMENT_PKG');
INSERT INTO documents.document_types (type_code, type_name_ar, type_name_en, is_required)
SELECT 'FINAL_REPORT', 'التقرير النهائي', 'Final Report', false
WHERE NOT EXISTS (SELECT 1 FROM documents.document_types WHERE type_code = 'FINAL_REPORT');
INSERT INTO documents.document_types (type_code, type_name_ar, type_name_en, is_required)
SELECT 'PUBLICATION', 'منشور علمي', 'Publication', false
WHERE NOT EXISTS (SELECT 1 FROM documents.document_types WHERE type_code = 'PUBLICATION');
INSERT INTO documents.document_types (type_code, type_name_ar, type_name_en, is_required)
SELECT 'DATA_COLLECTION', 'أداة جمع البيانات', 'Data Collection Tool', false
WHERE NOT EXISTS (SELECT 1 FROM documents.document_types WHERE type_code = 'DATA_COLLECTION');
INSERT INTO documents.document_types (type_code, type_name_ar, type_name_en, is_required)
SELECT 'STUDY_PROPOSAL', 'مقترح الدراسة', 'Study Proposal', false
WHERE NOT EXISTS (SELECT 1 FROM documents.document_types WHERE type_code = 'STUDY_PROPOSAL');
-- =============================================================================
-- 2. DOCUMENTS PER APPLICATION
-- =============================================================================
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Injury Patterns from Road Traffic Accidents in Sana''a (النسخة الأصلية)', 'protocol_v1_APP-2025-001002.pdf', 'protocol_v1_APP-2025-001002.pdf', 'application/pdf', 50000, 'uploads/documents/protocol_v1_APP-2025-001002.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 65, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Injury Patterns from Road Traffic Accidents in Sana''a (النسخة النهائية)', 'protocol_v2_APP-2025-001002.pdf', 'protocol_v2_APP-2025-001002.pdf', 'application/pdf', 99380, 'uploads/documents/protocol_v2_APP-2025-001002.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 65, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Injury Patterns from Road Traffic Accidents in Sana''a', 'icf_ar_APP-2025-001002.pdf', 'icf_ar_APP-2025-001002.pdf', 'application/pdf', 148760, 'uploads/documents/icf_ar_APP-2025-001002.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 65, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Injury Patterns from Road Traffic Accidents in Sana''a', 'icf_en_APP-2025-001002.pdf', 'icf_en_APP-2025-001002.pdf', 'application/pdf', 198140, 'uploads/documents/icf_en_APP-2025-001002.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 65, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Injury Patterns from Road Traffic Accidents in Sana''a (النسخة المعدلة)', 'icf_v2_APP-2025-001002.pdf', 'icf_v2_APP-2025-001002.pdf', 'application/pdf', 247520, 'uploads/documents/icf_v2_APP-2025-001002.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 65, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001002.pdf', 'cv_pi_APP-2025-001002.pdf', 'application/pdf', 296900, 'uploads/documents/cv_pi_APP-2025-001002.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 65, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001002.pdf', 'cv_coi_APP-2025-001002.pdf', 'application/pdf', 346280, 'uploads/documents/cv_coi_APP-2025-001002.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 65, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Injury Patterns from Road Traffic Accidents in Sana''a', 'pis_APP-2025-001002.pdf', 'pis_APP-2025-001002.pdf', 'application/pdf', 395660, 'uploads/documents/pis_APP-2025-001002.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 65, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Injury Patterns from Road Traffic Accidents in Sana''a', 'proposal_APP-2025-001002.pdf', 'proposal_APP-2025-001002.pdf', 'application/pdf', 445040, 'uploads/documents/proposal_APP-2025-001002.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 65, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Injury Patterns from Road Traffic Accidents in Sana''a', 'irb_approval_APP-2025-001002.pdf', 'irb_approval_APP-2025-001002.pdf', 'application/pdf', 494420, 'uploads/documents/irb_approval_APP-2025-001002.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 65, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Injury Patterns from Road Traffic Accidents in Sana''a', 'funding_APP-2025-001002.pdf', 'funding_APP-2025-001002.pdf', 'application/pdf', 543800, 'uploads/documents/funding_APP-2025-001002.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 65, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Injury Patterns from Road Traffic Accidents in Sana''a', 'budget_APP-2025-001002.xlsx', 'budget_APP-2025-001002.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 78884, 'uploads/documents/budget_APP-2025-001002.xlsx', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 65, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Injury Patterns from Road Traffic Accidents in Sana''a (موافقة)', 'ethics_decision_APP-2025-001002.pdf', 'ethics_decision_APP-2025-001002.pdf', 'application/pdf', 642560, 'uploads/documents/ethics_decision_APP-2025-001002.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 65, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'محضر اجتماع اللجنة - Injury Patterns from Road Traffic Accidents in Sana''a', 'minutes_APP-2025-001002.pdf', 'minutes_APP-2025-001002.pdf', 'application/pdf', 691940, 'uploads/documents/minutes_APP-2025-001002.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 65, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'MEETING_MINUTES'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Injury Patterns from Road Traffic Accidents in Sana''a', 'certificate_APP-2025-001002.pdf', 'certificate_APP-2025-001002.pdf', 'application/pdf', 741320, 'uploads/documents/certificate_APP-2025-001002.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 65, a.created_at + interval '113 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Injury Patterns from Road Traffic Accidents in Sana''a', 'final_report_APP-2025-001002.pdf', 'final_report_APP-2025-001002.pdf', 'application/pdf', 790700, 'uploads/documents/final_report_APP-2025-001002.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 65, a.created_at + interval '121 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Injury Patterns from Road Traffic Accidents in Sana''a', 'data_collection_APP-2025-001002.xlsx', 'data_collection_APP-2025-001002.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 101104, 'uploads/documents/data_collection_APP-2025-001002.xlsx', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 65, a.created_at + interval '129 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'منشور علمي - Injury Patterns from Road Traffic Accidents in Sana''a', 'publication_APP-2025-001002.pdf', 'publication_APP-2025-001002.pdf', 'application/pdf', 889460, 'uploads/documents/publication_APP-2025-001002.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 65, a.created_at + interval '137 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PUBLICATION'
AND a.application_number = 'APP-2025-001002';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Effectiveness of Supplementary Feeding Programs in Affected Areas', 'protocol_v1_APP-2025-001003.pdf', 'protocol_v1_APP-2025-001003.pdf', 'application/pdf', 87035, 'uploads/documents/protocol_v1_APP-2025-001003.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 66, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001003';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Effectiveness of Supplementary Feeding Programs in Affected Areas', 'icf_ar_APP-2025-001003.pdf', 'icf_ar_APP-2025-001003.pdf', 'application/pdf', 136415, 'uploads/documents/icf_ar_APP-2025-001003.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 66, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001003';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Effectiveness of Supplementary Feeding Programs in Affected Areas', 'icf_en_APP-2025-001003.pdf', 'icf_en_APP-2025-001003.pdf', 'application/pdf', 185795, 'uploads/documents/icf_en_APP-2025-001003.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 66, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001003';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001003.pdf', 'cv_pi_APP-2025-001003.pdf', 'application/pdf', 235175, 'uploads/documents/cv_pi_APP-2025-001003.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 66, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001003';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001003.pdf', 'cv_coi_APP-2025-001003.pdf', 'application/pdf', 284555, 'uploads/documents/cv_coi_APP-2025-001003.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 66, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001003';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Effectiveness of Supplementary Feeding Programs in Affected Areas', 'pis_APP-2025-001003.pdf', 'pis_APP-2025-001003.pdf', 'application/pdf', 333935, 'uploads/documents/pis_APP-2025-001003.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 66, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001003';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Effectiveness of Supplementary Feeding Programs in Affected Areas', 'irb_approval_APP-2025-001003.pdf', 'irb_approval_APP-2025-001003.pdf', 'application/pdf', 383315, 'uploads/documents/irb_approval_APP-2025-001003.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 66, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001003';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Effectiveness of Supplementary Feeding Programs in Affected Areas', 'funding_APP-2025-001003.pdf', 'funding_APP-2025-001003.pdf', 'application/pdf', 432695, 'uploads/documents/funding_APP-2025-001003.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 66, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001003';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Effectiveness of Supplementary Feeding Programs in Affected Areas', 'budget_APP-2025-001003.xlsx', 'budget_APP-2025-001003.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 68885, 'uploads/documents/budget_APP-2025-001003.xlsx', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 66, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001003';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Effectiveness of Supplementary Feeding Programs in Affected Areas (موافقة)', 'ethics_decision_APP-2025-001003.pdf', 'ethics_decision_APP-2025-001003.pdf', 'application/pdf', 531455, 'uploads/documents/ethics_decision_APP-2025-001003.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 66, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2025-001003';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Effectiveness of Supplementary Feeding Programs in Affected Areas', 'certificate_APP-2025-001003.pdf', 'certificate_APP-2025-001003.pdf', 'application/pdf', 580835, 'uploads/documents/certificate_APP-2025-001003.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 66, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2025-001003';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Effectiveness of Supplementary Feeding Programs in Affected Areas', 'final_report_APP-2025-001003.pdf', 'final_report_APP-2025-001003.pdf', 'application/pdf', 630215, 'uploads/documents/final_report_APP-2025-001003.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 66, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2025-001003';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Effectiveness of Supplementary Feeding Programs in Affected Areas', 'data_collection_APP-2025-001003.xlsx', 'data_collection_APP-2025-001003.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 86661, 'uploads/documents/data_collection_APP-2025-001003.xlsx', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 66, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001003';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Knowledge About HPV Vaccine Among Medical Students', 'protocol_v1_APP-2025-001004.pdf', 'protocol_v1_APP-2025-001004.pdf', 'application/pdf', 124070, 'uploads/documents/protocol_v1_APP-2025-001004.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 67, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001004';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Knowledge About HPV Vaccine Among Medical Students', 'icf_ar_APP-2025-001004.pdf', 'icf_ar_APP-2025-001004.pdf', 'application/pdf', 173450, 'uploads/documents/icf_ar_APP-2025-001004.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 67, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001004';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Knowledge About HPV Vaccine Among Medical Students', 'icf_en_APP-2025-001004.pdf', 'icf_en_APP-2025-001004.pdf', 'application/pdf', 222830, 'uploads/documents/icf_en_APP-2025-001004.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 67, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001004';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001004.pdf', 'cv_pi_APP-2025-001004.pdf', 'application/pdf', 272210, 'uploads/documents/cv_pi_APP-2025-001004.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 67, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001004';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001004.pdf', 'cv_coi_APP-2025-001004.pdf', 'application/pdf', 321590, 'uploads/documents/cv_coi_APP-2025-001004.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 67, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001004';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Knowledge About HPV Vaccine Among Medical Students', 'pis_APP-2025-001004.pdf', 'pis_APP-2025-001004.pdf', 'application/pdf', 370970, 'uploads/documents/pis_APP-2025-001004.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 67, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001004';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Knowledge About HPV Vaccine Among Medical Students', 'proposal_APP-2025-001004.pdf', 'proposal_APP-2025-001004.pdf', 'application/pdf', 420350, 'uploads/documents/proposal_APP-2025-001004.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 67, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2025-001004';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Knowledge About HPV Vaccine Among Medical Students', 'irb_approval_APP-2025-001004.pdf', 'irb_approval_APP-2025-001004.pdf', 'application/pdf', 469730, 'uploads/documents/irb_approval_APP-2025-001004.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 67, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001004';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Knowledge About HPV Vaccine Among Medical Students', 'funding_APP-2025-001004.pdf', 'funding_APP-2025-001004.pdf', 'application/pdf', 519110, 'uploads/documents/funding_APP-2025-001004.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 67, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001004';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Knowledge About HPV Vaccine Among Medical Students', 'budget_APP-2025-001004.xlsx', 'budget_APP-2025-001004.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 76662, 'uploads/documents/budget_APP-2025-001004.xlsx', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 67, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001004';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الإجراءات التشغيلية القياسية - Knowledge About HPV Vaccine Among Medical Students', 'sop_APP-2025-001004.pdf', 'sop_APP-2025-001004.pdf', 'application/pdf', 617870, 'uploads/documents/sop_APP-2025-001004.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 67, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'SOP'
AND a.application_number = 'APP-2025-001004';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'استبيان - Knowledge About HPV Vaccine Among Medical Students', 'questionnaire_APP-2025-001004.pdf', 'questionnaire_APP-2025-001004.pdf', 'application/pdf', 667250, 'uploads/documents/questionnaire_APP-2025-001004.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 67, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'QUESTIONNAIRE'
AND a.application_number = 'APP-2025-001004';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Knowledge About HPV Vaccine Among Medical Students', 'data_collection_APP-2025-001004.xlsx', 'data_collection_APP-2025-001004.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 89994, 'uploads/documents/data_collection_APP-2025-001004.xlsx', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 67, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001004';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Serological Screening for Epstein-Barr Virus Among Cancer Patients', 'protocol_v1_APP-2025-001005.pdf', 'protocol_v1_APP-2025-001005.pdf', 'application/pdf', 161105, 'uploads/documents/protocol_v1_APP-2025-001005.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 67, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001005';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Serological Screening for Epstein-Barr Virus Among Cancer Patients', 'icf_ar_APP-2025-001005.pdf', 'icf_ar_APP-2025-001005.pdf', 'application/pdf', 210485, 'uploads/documents/icf_ar_APP-2025-001005.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 67, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001005';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001005.pdf', 'cv_pi_APP-2025-001005.pdf', 'application/pdf', 259865, 'uploads/documents/cv_pi_APP-2025-001005.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 67, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001005';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Serological Screening for Epstein-Barr Virus Among Cancer Patients', 'pis_APP-2025-001005.pdf', 'pis_APP-2025-001005.pdf', 'application/pdf', 309245, 'uploads/documents/pis_APP-2025-001005.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 67, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001005';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Serological Screening for Epstein-Barr Virus Among Cancer Patients', 'proposal_APP-2025-001005.pdf', 'proposal_APP-2025-001005.pdf', 'application/pdf', 358625, 'uploads/documents/proposal_APP-2025-001005.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 67, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2025-001005';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Serological Screening for Epstein-Barr Virus Among Cancer Patients', 'irb_approval_APP-2025-001005.pdf', 'irb_approval_APP-2025-001005.pdf', 'application/pdf', 408005, 'uploads/documents/irb_approval_APP-2025-001005.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 67, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001005';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Factors Leading to Preterm Birth in Taiz Hospitals', 'protocol_v1_APP-2025-001006.pdf', 'protocol_v1_APP-2025-001006.pdf', 'application/pdf', 198140, 'uploads/documents/protocol_v1_APP-2025-001006.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 68, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001006';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Factors Leading to Preterm Birth in Taiz Hospitals', 'icf_APP-2025-001006.pdf', 'icf_APP-2025-001006.pdf', 'application/pdf', 247520, 'uploads/documents/icf_APP-2025-001006.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 68, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001006';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001006.pdf', 'cv_pi_APP-2025-001006.pdf', 'application/pdf', 296900, 'uploads/documents/cv_pi_APP-2025-001006.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 68, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001006';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Factors Leading to Preterm Birth in Taiz Hospitals', 'pis_APP-2025-001006.pdf', 'pis_APP-2025-001006.pdf', 'application/pdf', 346280, 'uploads/documents/pis_APP-2025-001006.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 68, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001006';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Factors Leading to Preterm Birth in Taiz Hospitals', 'proposal_APP-2025-001006.pdf', 'proposal_APP-2025-001006.pdf', 'application/pdf', 395660, 'uploads/documents/proposal_APP-2025-001006.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 68, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2025-001006';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب سحب الطلب - Factors Leading to Preterm Birth in Taiz Hospitals', 'withdrawal_APP-2025-001006.pdf', 'withdrawal_APP-2025-001006.pdf', 'application/pdf', 445040, 'uploads/documents/withdrawal_APP-2025-001006.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 68, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'OTHER'
AND a.application_number = 'APP-2025-001006';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Assessment of Emergency Services in Yemeni General Hospitals', 'protocol_v1_APP-2025-001007.pdf', 'protocol_v1_APP-2025-001007.pdf', 'application/pdf', 235175, 'uploads/documents/protocol_v1_APP-2025-001007.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 69, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001007';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Assessment of Emergency Services in Yemeni General Hospitals', 'icf_ar_APP-2025-001007.pdf', 'icf_ar_APP-2025-001007.pdf', 'application/pdf', 284555, 'uploads/documents/icf_ar_APP-2025-001007.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 69, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001007';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Assessment of Emergency Services in Yemeni General Hospitals', 'icf_en_APP-2025-001007.pdf', 'icf_en_APP-2025-001007.pdf', 'application/pdf', 333935, 'uploads/documents/icf_en_APP-2025-001007.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 69, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001007';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001007.pdf', 'cv_pi_APP-2025-001007.pdf', 'application/pdf', 383315, 'uploads/documents/cv_pi_APP-2025-001007.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 69, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001007';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001007.pdf', 'cv_coi_APP-2025-001007.pdf', 'application/pdf', 432695, 'uploads/documents/cv_coi_APP-2025-001007.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 69, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001007';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Assessment of Emergency Services in Yemeni General Hospitals', 'pis_APP-2025-001007.pdf', 'pis_APP-2025-001007.pdf', 'application/pdf', 482075, 'uploads/documents/pis_APP-2025-001007.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 69, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001007';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Assessment of Emergency Services in Yemeni General Hospitals', 'proposal_APP-2025-001007.pdf', 'proposal_APP-2025-001007.pdf', 'application/pdf', 531455, 'uploads/documents/proposal_APP-2025-001007.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 69, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2025-001007';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Assessment of Emergency Services in Yemeni General Hospitals', 'irb_approval_APP-2025-001007.pdf', 'irb_approval_APP-2025-001007.pdf', 'application/pdf', 580835, 'uploads/documents/irb_approval_APP-2025-001007.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 69, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001007';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Assessment of Emergency Services in Yemeni General Hospitals', 'funding_APP-2025-001007.pdf', 'funding_APP-2025-001007.pdf', 'application/pdf', 630215, 'uploads/documents/funding_APP-2025-001007.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 69, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001007';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Assessment of Emergency Services in Yemeni General Hospitals', 'budget_APP-2025-001007.xlsx', 'budget_APP-2025-001007.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 86661, 'uploads/documents/budget_APP-2025-001007.xlsx', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 69, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001007';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الإجراءات التشغيلية القياسية - Assessment of Emergency Services in Yemeni General Hospitals', 'sop_APP-2025-001007.pdf', 'sop_APP-2025-001007.pdf', 'application/pdf', 728975, 'uploads/documents/sop_APP-2025-001007.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 69, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'SOP'
AND a.application_number = 'APP-2025-001007';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج تقرير الحالة - Assessment of Emergency Services in Yemeni General Hospitals', 'crf_APP-2025-001007.pdf', 'crf_APP-2025-001007.pdf', 'application/pdf', 778355, 'uploads/documents/crf_APP-2025-001007.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 69, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CRF'
AND a.application_number = 'APP-2025-001007';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Assessment of Emergency Services in Yemeni General Hospitals', 'data_collection_APP-2025-001007.xlsx', 'data_collection_APP-2025-001007.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 99993, 'uploads/documents/data_collection_APP-2025-001007.xlsx', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 69, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001007';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Maternal Mortality Rates in Rural Areas of Hajjah Governorate', 'protocol_v1_APP-2025-001008.pdf', 'protocol_v1_APP-2025-001008.pdf', 'application/pdf', 272210, 'uploads/documents/protocol_v1_APP-2025-001008.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 69, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001008';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Maternal Mortality Rates in Rural Areas of Hajjah Governorate', 'icf_ar_APP-2025-001008.pdf', 'icf_ar_APP-2025-001008.pdf', 'application/pdf', 321590, 'uploads/documents/icf_ar_APP-2025-001008.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 69, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001008';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001008.pdf', 'cv_pi_APP-2025-001008.pdf', 'application/pdf', 370970, 'uploads/documents/cv_pi_APP-2025-001008.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 69, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001008';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Maternal Mortality Rates in Rural Areas of Hajjah Governorate', 'pis_APP-2025-001008.pdf', 'pis_APP-2025-001008.pdf', 'application/pdf', 420350, 'uploads/documents/pis_APP-2025-001008.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 69, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001008';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'استبيان - Maternal Mortality Rates in Rural Areas of Hajjah Governorate', 'questionnaire_APP-2025-001008.pdf', 'questionnaire_APP-2025-001008.pdf', 'application/pdf', 469730, 'uploads/documents/questionnaire_APP-2025-001008.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 69, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'QUESTIONNAIRE'
AND a.application_number = 'APP-2025-001008';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Cardiovascular Disease Surveillance in Urban Areas (النسخة الأصلية)', 'protocol_v1_APP-2025-001009.pdf', 'protocol_v1_APP-2025-001009.pdf', 'application/pdf', 309245, 'uploads/documents/protocol_v1_APP-2025-001009.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 70, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Cardiovascular Disease Surveillance in Urban Areas (النسخة النهائية)', 'protocol_v2_APP-2025-001009.pdf', 'protocol_v2_APP-2025-001009.pdf', 'application/pdf', 358625, 'uploads/documents/protocol_v2_APP-2025-001009.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 70, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Cardiovascular Disease Surveillance in Urban Areas', 'icf_ar_APP-2025-001009.pdf', 'icf_ar_APP-2025-001009.pdf', 'application/pdf', 408005, 'uploads/documents/icf_ar_APP-2025-001009.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 70, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Cardiovascular Disease Surveillance in Urban Areas', 'icf_en_APP-2025-001009.pdf', 'icf_en_APP-2025-001009.pdf', 'application/pdf', 457385, 'uploads/documents/icf_en_APP-2025-001009.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 70, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Cardiovascular Disease Surveillance in Urban Areas (النسخة المعدلة)', 'icf_v2_APP-2025-001009.pdf', 'icf_v2_APP-2025-001009.pdf', 'application/pdf', 506765, 'uploads/documents/icf_v2_APP-2025-001009.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 70, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001009.pdf', 'cv_pi_APP-2025-001009.pdf', 'application/pdf', 556145, 'uploads/documents/cv_pi_APP-2025-001009.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 70, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001009.pdf', 'cv_coi_APP-2025-001009.pdf', 'application/pdf', 605525, 'uploads/documents/cv_coi_APP-2025-001009.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 70, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Cardiovascular Disease Surveillance in Urban Areas', 'pis_APP-2025-001009.pdf', 'pis_APP-2025-001009.pdf', 'application/pdf', 654905, 'uploads/documents/pis_APP-2025-001009.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 70, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Cardiovascular Disease Surveillance in Urban Areas', 'proposal_APP-2025-001009.pdf', 'proposal_APP-2025-001009.pdf', 'application/pdf', 704285, 'uploads/documents/proposal_APP-2025-001009.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 70, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Cardiovascular Disease Surveillance in Urban Areas', 'irb_approval_APP-2025-001009.pdf', 'irb_approval_APP-2025-001009.pdf', 'application/pdf', 753665, 'uploads/documents/irb_approval_APP-2025-001009.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 70, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Cardiovascular Disease Surveillance in Urban Areas', 'funding_APP-2025-001009.pdf', 'funding_APP-2025-001009.pdf', 'application/pdf', 803045, 'uploads/documents/funding_APP-2025-001009.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 70, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Cardiovascular Disease Surveillance in Urban Areas', 'budget_APP-2025-001009.xlsx', 'budget_APP-2025-001009.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 102215, 'uploads/documents/budget_APP-2025-001009.xlsx', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 70, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Cardiovascular Disease Surveillance in Urban Areas (موافقة)', 'ethics_decision_APP-2025-001009.pdf', 'ethics_decision_APP-2025-001009.pdf', 'application/pdf', 901805, 'uploads/documents/ethics_decision_APP-2025-001009.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 70, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'محضر اجتماع اللجنة - Cardiovascular Disease Surveillance in Urban Areas', 'minutes_APP-2025-001009.pdf', 'minutes_APP-2025-001009.pdf', 'application/pdf', 951185, 'uploads/documents/minutes_APP-2025-001009.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 70, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'MEETING_MINUTES'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Cardiovascular Disease Surveillance in Urban Areas', 'certificate_APP-2025-001009.pdf', 'certificate_APP-2025-001009.pdf', 'application/pdf', 1000565, 'uploads/documents/certificate_APP-2025-001009.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 70, a.created_at + interval '113 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Cardiovascular Disease Surveillance in Urban Areas', 'final_report_APP-2025-001009.pdf', 'final_report_APP-2025-001009.pdf', 'application/pdf', 1049945, 'uploads/documents/final_report_APP-2025-001009.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 70, a.created_at + interval '121 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Cardiovascular Disease Surveillance in Urban Areas', 'data_collection_APP-2025-001009.xlsx', 'data_collection_APP-2025-001009.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 124435, 'uploads/documents/data_collection_APP-2025-001009.xlsx', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 70, a.created_at + interval '129 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'منشور علمي - Cardiovascular Disease Surveillance in Urban Areas', 'publication_APP-2025-001009.pdf', 'publication_APP-2025-001009.pdf', 'application/pdf', 1148705, 'uploads/documents/publication_APP-2025-001009.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 70, a.created_at + interval '137 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PUBLICATION'
AND a.application_number = 'APP-2025-001009';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Malnutrition Rates Among Under-Five Children in Yemen', 'protocol_v1_APP-2025-001010.pdf', 'protocol_v1_APP-2025-001010.pdf', 'application/pdf', 346280, 'uploads/documents/protocol_v1_APP-2025-001010.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 71, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001010';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Malnutrition Rates Among Under-Five Children in Yemen', 'icf_ar_APP-2025-001010.pdf', 'icf_ar_APP-2025-001010.pdf', 'application/pdf', 395660, 'uploads/documents/icf_ar_APP-2025-001010.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 71, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001010';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Malnutrition Rates Among Under-Five Children in Yemen', 'icf_en_APP-2025-001010.pdf', 'icf_en_APP-2025-001010.pdf', 'application/pdf', 445040, 'uploads/documents/icf_en_APP-2025-001010.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 71, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001010';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001010.pdf', 'cv_pi_APP-2025-001010.pdf', 'application/pdf', 494420, 'uploads/documents/cv_pi_APP-2025-001010.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 71, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001010';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001010.pdf', 'cv_coi_APP-2025-001010.pdf', 'application/pdf', 543800, 'uploads/documents/cv_coi_APP-2025-001010.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 71, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001010';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Malnutrition Rates Among Under-Five Children in Yemen', 'pis_APP-2025-001010.pdf', 'pis_APP-2025-001010.pdf', 'application/pdf', 593180, 'uploads/documents/pis_APP-2025-001010.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 71, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001010';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Malnutrition Rates Among Under-Five Children in Yemen', 'irb_approval_APP-2025-001010.pdf', 'irb_approval_APP-2025-001010.pdf', 'application/pdf', 642560, 'uploads/documents/irb_approval_APP-2025-001010.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 71, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001010';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Malnutrition Rates Among Under-Five Children in Yemen', 'funding_APP-2025-001010.pdf', 'funding_APP-2025-001010.pdf', 'application/pdf', 691940, 'uploads/documents/funding_APP-2025-001010.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 71, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001010';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Malnutrition Rates Among Under-Five Children in Yemen', 'budget_APP-2025-001010.xlsx', 'budget_APP-2025-001010.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 92216, 'uploads/documents/budget_APP-2025-001010.xlsx', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 71, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001010';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Malnutrition Rates Among Under-Five Children in Yemen (موافقة)', 'ethics_decision_APP-2025-001010.pdf', 'ethics_decision_APP-2025-001010.pdf', 'application/pdf', 790700, 'uploads/documents/ethics_decision_APP-2025-001010.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 71, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2025-001010';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Malnutrition Rates Among Under-Five Children in Yemen', 'certificate_APP-2025-001010.pdf', 'certificate_APP-2025-001010.pdf', 'application/pdf', 840080, 'uploads/documents/certificate_APP-2025-001010.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 71, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2025-001010';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Malnutrition Rates Among Under-Five Children in Yemen', 'data_collection_APP-2025-001010.xlsx', 'data_collection_APP-2025-001010.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 105548, 'uploads/documents/data_collection_APP-2025-001010.xlsx', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 71, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001010';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Prevalence of Hepatitis B and C Among Blood Donors', 'protocol_v1_APP-2025-001011.pdf', 'protocol_v1_APP-2025-001011.pdf', 'application/pdf', 383315, 'uploads/documents/protocol_v1_APP-2025-001011.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 71, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001011';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Prevalence of Hepatitis B and C Among Blood Donors', 'icf_ar_APP-2025-001011.pdf', 'icf_ar_APP-2025-001011.pdf', 'application/pdf', 432695, 'uploads/documents/icf_ar_APP-2025-001011.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 71, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001011';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Prevalence of Hepatitis B and C Among Blood Donors', 'icf_en_APP-2025-001011.pdf', 'icf_en_APP-2025-001011.pdf', 'application/pdf', 482075, 'uploads/documents/icf_en_APP-2025-001011.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 71, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001011';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001011.pdf', 'cv_pi_APP-2025-001011.pdf', 'application/pdf', 531455, 'uploads/documents/cv_pi_APP-2025-001011.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 71, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001011';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001011.pdf', 'cv_coi_APP-2025-001011.pdf', 'application/pdf', 580835, 'uploads/documents/cv_coi_APP-2025-001011.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 71, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001011';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Prevalence of Hepatitis B and C Among Blood Donors', 'pis_APP-2025-001011.pdf', 'pis_APP-2025-001011.pdf', 'application/pdf', 630215, 'uploads/documents/pis_APP-2025-001011.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 71, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001011';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Prevalence of Hepatitis B and C Among Blood Donors', 'irb_approval_APP-2025-001011.pdf', 'irb_approval_APP-2025-001011.pdf', 'application/pdf', 679595, 'uploads/documents/irb_approval_APP-2025-001011.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 71, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001011';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Prevalence of Hepatitis B and C Among Blood Donors', 'funding_APP-2025-001011.pdf', 'funding_APP-2025-001011.pdf', 'application/pdf', 728975, 'uploads/documents/funding_APP-2025-001011.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 71, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001011';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Prevalence of Hepatitis B and C Among Blood Donors', 'budget_APP-2025-001011.xlsx', 'budget_APP-2025-001011.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 95549, 'uploads/documents/budget_APP-2025-001011.xlsx', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 71, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001011';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Prevalence of Hepatitis B and C Among Blood Donors (موافقة)', 'ethics_decision_APP-2025-001011.pdf', 'ethics_decision_APP-2025-001011.pdf', 'application/pdf', 827735, 'uploads/documents/ethics_decision_APP-2025-001011.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 71, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2025-001011';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Prevalence of Hepatitis B and C Among Blood Donors', 'certificate_APP-2025-001011.pdf', 'certificate_APP-2025-001011.pdf', 'application/pdf', 877115, 'uploads/documents/certificate_APP-2025-001011.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 71, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2025-001011';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Prevalence of Hepatitis B and C Among Blood Donors', 'final_report_APP-2025-001011.pdf', 'final_report_APP-2025-001011.pdf', 'application/pdf', 926495, 'uploads/documents/final_report_APP-2025-001011.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 71, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2025-001011';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Prevalence of Hepatitis B and C Among Blood Donors', 'data_collection_APP-2025-001011.xlsx', 'data_collection_APP-2025-001011.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 113325, 'uploads/documents/data_collection_APP-2025-001011.xlsx', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 71, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001011';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - HIV Prevalence Among High-Risk Groups in Yemen', 'protocol_v1_APP-2025-001012.pdf', 'protocol_v1_APP-2025-001012.pdf', 'application/pdf', 420350, 'uploads/documents/protocol_v1_APP-2025-001012.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 72, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001012';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - HIV Prevalence Among High-Risk Groups in Yemen', 'icf_APP-2025-001012.pdf', 'icf_APP-2025-001012.pdf', 'application/pdf', 469730, 'uploads/documents/icf_APP-2025-001012.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 72, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001012';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001012.pdf', 'cv_pi_APP-2025-001012.pdf', 'application/pdf', 519110, 'uploads/documents/cv_pi_APP-2025-001012.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 72, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001012';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - HIV Prevalence Among High-Risk Groups in Yemen', 'pis_APP-2025-001012.pdf', 'pis_APP-2025-001012.pdf', 'application/pdf', 568490, 'uploads/documents/pis_APP-2025-001012.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 72, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001012';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - HIV Prevalence Among High-Risk Groups in Yemen (رفض)', 'rejection_APP-2025-001012.pdf', 'rejection_APP-2025-001012.pdf', 'application/pdf', 617870, 'uploads/documents/rejection_APP-2025-001012.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 72, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2025-001012';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Knowledge About HPV Vaccine Among Medical Students (73-0) (النسخة الأصلية)', 'protocol_v1_APP-2025-001013.pdf', 'protocol_v1_APP-2025-001013.pdf', 'application/pdf', 457385, 'uploads/documents/protocol_v1_APP-2025-001013.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 73, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Knowledge About HPV Vaccine Among Medical Students (73-0) (النسخة النهائية)', 'protocol_v2_APP-2025-001013.pdf', 'protocol_v2_APP-2025-001013.pdf', 'application/pdf', 506765, 'uploads/documents/protocol_v2_APP-2025-001013.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 73, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Knowledge About HPV Vaccine Among Medical Students (73-0)', 'icf_ar_APP-2025-001013.pdf', 'icf_ar_APP-2025-001013.pdf', 'application/pdf', 556145, 'uploads/documents/icf_ar_APP-2025-001013.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 73, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Knowledge About HPV Vaccine Among Medical Students (73-0)', 'icf_en_APP-2025-001013.pdf', 'icf_en_APP-2025-001013.pdf', 'application/pdf', 605525, 'uploads/documents/icf_en_APP-2025-001013.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 73, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Knowledge About HPV Vaccine Among Medical Students (73-0) (النسخة المعدلة)', 'icf_v2_APP-2025-001013.pdf', 'icf_v2_APP-2025-001013.pdf', 'application/pdf', 654905, 'uploads/documents/icf_v2_APP-2025-001013.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 73, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001013.pdf', 'cv_pi_APP-2025-001013.pdf', 'application/pdf', 704285, 'uploads/documents/cv_pi_APP-2025-001013.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 73, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001013.pdf', 'cv_coi_APP-2025-001013.pdf', 'application/pdf', 753665, 'uploads/documents/cv_coi_APP-2025-001013.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 73, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Knowledge About HPV Vaccine Among Medical Students (73-0)', 'pis_APP-2025-001013.pdf', 'pis_APP-2025-001013.pdf', 'application/pdf', 803045, 'uploads/documents/pis_APP-2025-001013.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 73, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Knowledge About HPV Vaccine Among Medical Students (73-0)', 'proposal_APP-2025-001013.pdf', 'proposal_APP-2025-001013.pdf', 'application/pdf', 852425, 'uploads/documents/proposal_APP-2025-001013.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 73, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Knowledge About HPV Vaccine Among Medical Students (73-0)', 'irb_approval_APP-2025-001013.pdf', 'irb_approval_APP-2025-001013.pdf', 'application/pdf', 901805, 'uploads/documents/irb_approval_APP-2025-001013.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 73, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Knowledge About HPV Vaccine Among Medical Students (73-0)', 'funding_APP-2025-001013.pdf', 'funding_APP-2025-001013.pdf', 'application/pdf', 951185, 'uploads/documents/funding_APP-2025-001013.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 73, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Knowledge About HPV Vaccine Among Medical Students (73-0)', 'budget_APP-2025-001013.xlsx', 'budget_APP-2025-001013.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 115547, 'uploads/documents/budget_APP-2025-001013.xlsx', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 73, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Knowledge About HPV Vaccine Among Medical Students (73-0) (موافقة)', 'ethics_decision_APP-2025-001013.pdf', 'ethics_decision_APP-2025-001013.pdf', 'application/pdf', 1049945, 'uploads/documents/ethics_decision_APP-2025-001013.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 73, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'محضر اجتماع اللجنة - Knowledge About HPV Vaccine Among Medical Students (73-0)', 'minutes_APP-2025-001013.pdf', 'minutes_APP-2025-001013.pdf', 'application/pdf', 1099325, 'uploads/documents/minutes_APP-2025-001013.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 73, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'MEETING_MINUTES'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Knowledge About HPV Vaccine Among Medical Students (73-0)', 'certificate_APP-2025-001013.pdf', 'certificate_APP-2025-001013.pdf', 'application/pdf', 1148705, 'uploads/documents/certificate_APP-2025-001013.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 73, a.created_at + interval '113 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Knowledge About HPV Vaccine Among Medical Students (73-0)', 'final_report_APP-2025-001013.pdf', 'final_report_APP-2025-001013.pdf', 'application/pdf', 1198085, 'uploads/documents/final_report_APP-2025-001013.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 73, a.created_at + interval '121 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Knowledge About HPV Vaccine Among Medical Students (73-0)', 'data_collection_APP-2025-001013.xlsx', 'data_collection_APP-2025-001013.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 137767, 'uploads/documents/data_collection_APP-2025-001013.xlsx', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 73, a.created_at + interval '129 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'منشور علمي - Knowledge About HPV Vaccine Among Medical Students (73-0)', 'publication_APP-2025-001013.pdf', 'publication_APP-2025-001013.pdf', 'application/pdf', 1296845, 'uploads/documents/publication_APP-2025-001013.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 73, a.created_at + interval '137 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PUBLICATION'
AND a.application_number = 'APP-2025-001013';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Evaluation of Family Planning Programs in Remote Areas', 'protocol_v1_APP-2025-001014.pdf', 'protocol_v1_APP-2025-001014.pdf', 'application/pdf', 494420, 'uploads/documents/protocol_v1_APP-2025-001014.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 73, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001014';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Evaluation of Family Planning Programs in Remote Areas (النسخة المعدلة)', 'protocol_v2_APP-2025-001014.pdf', 'protocol_v2_APP-2025-001014.pdf', 'application/pdf', 543800, 'uploads/documents/protocol_v2_APP-2025-001014.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 73, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001014';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Evaluation of Family Planning Programs in Remote Areas', 'icf_ar_APP-2025-001014.pdf', 'icf_ar_APP-2025-001014.pdf', 'application/pdf', 593180, 'uploads/documents/icf_ar_APP-2025-001014.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 73, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001014';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Evaluation of Family Planning Programs in Remote Areas', 'icf_en_APP-2025-001014.pdf', 'icf_en_APP-2025-001014.pdf', 'application/pdf', 642560, 'uploads/documents/icf_en_APP-2025-001014.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 73, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001014';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001014.pdf', 'cv_pi_APP-2025-001014.pdf', 'application/pdf', 691940, 'uploads/documents/cv_pi_APP-2025-001014.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 73, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001014';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001014.pdf', 'cv_coi_APP-2025-001014.pdf', 'application/pdf', 741320, 'uploads/documents/cv_coi_APP-2025-001014.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 73, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001014';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Evaluation of Family Planning Programs in Remote Areas', 'pis_APP-2025-001014.pdf', 'pis_APP-2025-001014.pdf', 'application/pdf', 790700, 'uploads/documents/pis_APP-2025-001014.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 73, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001014';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Evaluation of Family Planning Programs in Remote Areas', 'irb_approval_APP-2025-001014.pdf', 'irb_approval_APP-2025-001014.pdf', 'application/pdf', 840080, 'uploads/documents/irb_approval_APP-2025-001014.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 73, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001014';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Evaluation of Family Planning Programs in Remote Areas', 'funding_APP-2025-001014.pdf', 'funding_APP-2025-001014.pdf', 'application/pdf', 889460, 'uploads/documents/funding_APP-2025-001014.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 73, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001014';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Evaluation of Family Planning Programs in Remote Areas', 'budget_APP-2025-001014.xlsx', 'budget_APP-2025-001014.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 109992, 'uploads/documents/budget_APP-2025-001014.xlsx', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 73, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001014';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Evaluation of Family Planning Programs in Remote Areas (موافقة)', 'ethics_decision_APP-2025-001014.pdf', 'ethics_decision_APP-2025-001014.pdf', 'application/pdf', 988220, 'uploads/documents/ethics_decision_APP-2025-001014.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 73, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2025-001014';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Evaluation of Family Planning Programs in Remote Areas', 'certificate_APP-2025-001014.pdf', 'certificate_APP-2025-001014.pdf', 'application/pdf', 1037600, 'uploads/documents/certificate_APP-2025-001014.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 73, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2025-001014';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Evaluation of Family Planning Programs in Remote Areas', 'data_collection_APP-2025-001014.xlsx', 'data_collection_APP-2025-001014.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 123324, 'uploads/documents/data_collection_APP-2025-001014.xlsx', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 73, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001014';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Evaluation of Rapid Diagnostic Tests for Malaria in Reference Laboratories', 'protocol_v1_APP-2025-001015.pdf', 'protocol_v1_APP-2025-001015.pdf', 'application/pdf', 531455, 'uploads/documents/protocol_v1_APP-2025-001015.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 74, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001015';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Evaluation of Rapid Diagnostic Tests for Malaria in Reference Laboratories', 'icf_ar_APP-2025-001015.pdf', 'icf_ar_APP-2025-001015.pdf', 'application/pdf', 580835, 'uploads/documents/icf_ar_APP-2025-001015.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 74, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001015';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Evaluation of Rapid Diagnostic Tests for Malaria in Reference Laboratories', 'icf_en_APP-2025-001015.pdf', 'icf_en_APP-2025-001015.pdf', 'application/pdf', 630215, 'uploads/documents/icf_en_APP-2025-001015.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 74, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001015';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001015.pdf', 'cv_pi_APP-2025-001015.pdf', 'application/pdf', 679595, 'uploads/documents/cv_pi_APP-2025-001015.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 74, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001015';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001015.pdf', 'cv_coi_APP-2025-001015.pdf', 'application/pdf', 728975, 'uploads/documents/cv_coi_APP-2025-001015.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 74, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001015';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Evaluation of Rapid Diagnostic Tests for Malaria in Reference Laboratories', 'pis_APP-2025-001015.pdf', 'pis_APP-2025-001015.pdf', 'application/pdf', 778355, 'uploads/documents/pis_APP-2025-001015.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 74, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001015';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Evaluation of Rapid Diagnostic Tests for Malaria in Reference Laboratories', 'proposal_APP-2025-001015.pdf', 'proposal_APP-2025-001015.pdf', 'application/pdf', 827735, 'uploads/documents/proposal_APP-2025-001015.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 74, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2025-001015';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Evaluation of Rapid Diagnostic Tests for Malaria in Reference Laboratories', 'irb_approval_APP-2025-001015.pdf', 'irb_approval_APP-2025-001015.pdf', 'application/pdf', 877115, 'uploads/documents/irb_approval_APP-2025-001015.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 74, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001015';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Evaluation of Rapid Diagnostic Tests for Malaria in Reference Laboratories', 'funding_APP-2025-001015.pdf', 'funding_APP-2025-001015.pdf', 'application/pdf', 926495, 'uploads/documents/funding_APP-2025-001015.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 74, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001015';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Evaluation of Rapid Diagnostic Tests for Malaria in Reference Laboratories', 'budget_APP-2025-001015.xlsx', 'budget_APP-2025-001015.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 113325, 'uploads/documents/budget_APP-2025-001015.xlsx', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 74, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001015';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الإجراءات التشغيلية القياسية - Evaluation of Rapid Diagnostic Tests for Malaria in Reference Laboratories', 'sop_APP-2025-001015.pdf', 'sop_APP-2025-001015.pdf', 'application/pdf', 1025255, 'uploads/documents/sop_APP-2025-001015.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 74, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'SOP'
AND a.application_number = 'APP-2025-001015';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'محضر اجتماع اللجنة - Evaluation of Rapid Diagnostic Tests for Malaria in Reference Laboratories', 'minutes_APP-2025-001015.pdf', 'minutes_APP-2025-001015.pdf', 'application/pdf', 1074635, 'uploads/documents/minutes_APP-2025-001015.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 74, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'MEETING_MINUTES'
AND a.application_number = 'APP-2025-001015';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Seroprevalence of SARS-CoV-2 Among Healthcare Workers in Yemen (مسودة)', 'icf_draft_APP-2025-001016.pdf', 'icf_draft_APP-2025-001016.pdf', 'application/pdf', 568490, 'uploads/documents/icf_draft_APP-2025-001016.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 75, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001016';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001016.pdf', 'cv_pi_APP-2025-001016.pdf', 'application/pdf', 617870, 'uploads/documents/cv_pi_APP-2025-001016.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 75, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001016';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'protocol_v1_APP-2025-001017.pdf', 'protocol_v1_APP-2025-001017.pdf', 'application/pdf', 605525, 'uploads/documents/protocol_v1_APP-2025-001017.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 75, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001017';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (النسخة المعدلة)', 'protocol_v2_APP-2025-001017.pdf', 'protocol_v2_APP-2025-001017.pdf', 'application/pdf', 654905, 'uploads/documents/protocol_v2_APP-2025-001017.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 75, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001017';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'icf_ar_APP-2025-001017.pdf', 'icf_ar_APP-2025-001017.pdf', 'application/pdf', 704285, 'uploads/documents/icf_ar_APP-2025-001017.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 75, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001017';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'icf_en_APP-2025-001017.pdf', 'icf_en_APP-2025-001017.pdf', 'application/pdf', 753665, 'uploads/documents/icf_en_APP-2025-001017.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 75, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001017';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001017.pdf', 'cv_pi_APP-2025-001017.pdf', 'application/pdf', 803045, 'uploads/documents/cv_pi_APP-2025-001017.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 75, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001017';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001017.pdf', 'cv_coi_APP-2025-001017.pdf', 'application/pdf', 852425, 'uploads/documents/cv_coi_APP-2025-001017.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 75, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001017';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'pis_APP-2025-001017.pdf', 'pis_APP-2025-001017.pdf', 'application/pdf', 901805, 'uploads/documents/pis_APP-2025-001017.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 75, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001017';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'irb_approval_APP-2025-001017.pdf', 'irb_approval_APP-2025-001017.pdf', 'application/pdf', 951185, 'uploads/documents/irb_approval_APP-2025-001017.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 75, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001017';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'funding_APP-2025-001017.pdf', 'funding_APP-2025-001017.pdf', 'application/pdf', 1000565, 'uploads/documents/funding_APP-2025-001017.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 75, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001017';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'budget_APP-2025-001017.xlsx', 'budget_APP-2025-001017.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 119991, 'uploads/documents/budget_APP-2025-001017.xlsx', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 75, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001017';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (موافقة)', 'ethics_decision_APP-2025-001017.pdf', 'ethics_decision_APP-2025-001017.pdf', 'application/pdf', 1099325, 'uploads/documents/ethics_decision_APP-2025-001017.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 75, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2025-001017';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'certificate_APP-2025-001017.pdf', 'certificate_APP-2025-001017.pdf', 'application/pdf', 1148705, 'uploads/documents/certificate_APP-2025-001017.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 75, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2025-001017';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'data_collection_APP-2025-001017.xlsx', 'data_collection_APP-2025-001017.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 133323, 'uploads/documents/data_collection_APP-2025-001017.xlsx', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 75, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001017';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Effectiveness of Radiotherapy for Cervical Cancer in Yemen', 'protocol_v1_APP-2025-001018.pdf', 'protocol_v1_APP-2025-001018.pdf', 'application/pdf', 642560, 'uploads/documents/protocol_v1_APP-2025-001018.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 76, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001018';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Effectiveness of Radiotherapy for Cervical Cancer in Yemen (النسخة المعدلة)', 'protocol_v2_APP-2025-001018.pdf', 'protocol_v2_APP-2025-001018.pdf', 'application/pdf', 691940, 'uploads/documents/protocol_v2_APP-2025-001018.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 76, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001018';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Effectiveness of Radiotherapy for Cervical Cancer in Yemen', 'icf_ar_APP-2025-001018.pdf', 'icf_ar_APP-2025-001018.pdf', 'application/pdf', 741320, 'uploads/documents/icf_ar_APP-2025-001018.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 76, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001018';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Effectiveness of Radiotherapy for Cervical Cancer in Yemen', 'icf_en_APP-2025-001018.pdf', 'icf_en_APP-2025-001018.pdf', 'application/pdf', 790700, 'uploads/documents/icf_en_APP-2025-001018.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 76, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001018';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001018.pdf', 'cv_pi_APP-2025-001018.pdf', 'application/pdf', 840080, 'uploads/documents/cv_pi_APP-2025-001018.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 76, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001018';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001018.pdf', 'cv_coi_APP-2025-001018.pdf', 'application/pdf', 889460, 'uploads/documents/cv_coi_APP-2025-001018.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 76, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001018';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Effectiveness of Radiotherapy for Cervical Cancer in Yemen', 'pis_APP-2025-001018.pdf', 'pis_APP-2025-001018.pdf', 'application/pdf', 938840, 'uploads/documents/pis_APP-2025-001018.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 76, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001018';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Effectiveness of Radiotherapy for Cervical Cancer in Yemen', 'irb_approval_APP-2025-001018.pdf', 'irb_approval_APP-2025-001018.pdf', 'application/pdf', 988220, 'uploads/documents/irb_approval_APP-2025-001018.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 76, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001018';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Effectiveness of Radiotherapy for Cervical Cancer in Yemen', 'funding_APP-2025-001018.pdf', 'funding_APP-2025-001018.pdf', 'application/pdf', 1037600, 'uploads/documents/funding_APP-2025-001018.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 76, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001018';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Effectiveness of Radiotherapy for Cervical Cancer in Yemen', 'budget_APP-2025-001018.xlsx', 'budget_APP-2025-001018.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 123324, 'uploads/documents/budget_APP-2025-001018.xlsx', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 76, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001018';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Effectiveness of Radiotherapy for Cervical Cancer in Yemen (موافقة)', 'ethics_decision_APP-2025-001018.pdf', 'ethics_decision_APP-2025-001018.pdf', 'application/pdf', 1136360, 'uploads/documents/ethics_decision_APP-2025-001018.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 76, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2025-001018';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Effectiveness of Radiotherapy for Cervical Cancer in Yemen', 'certificate_APP-2025-001018.pdf', 'certificate_APP-2025-001018.pdf', 'application/pdf', 1185740, 'uploads/documents/certificate_APP-2025-001018.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 76, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2025-001018';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Effectiveness of Radiotherapy for Cervical Cancer in Yemen', 'final_report_APP-2025-001018.pdf', 'final_report_APP-2025-001018.pdf', 'application/pdf', 1235120, 'uploads/documents/final_report_APP-2025-001018.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 76, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2025-001018';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Effectiveness of Radiotherapy for Cervical Cancer in Yemen', 'data_collection_APP-2025-001018.xlsx', 'data_collection_APP-2025-001018.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 141100, 'uploads/documents/data_collection_APP-2025-001018.xlsx', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 76, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001018';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'منشور علمي - Effectiveness of Radiotherapy for Cervical Cancer in Yemen', 'publication_APP-2025-001018.pdf', 'publication_APP-2025-001018.pdf', 'application/pdf', 1333880, 'uploads/documents/publication_APP-2025-001018.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 76, a.created_at + interval '113 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PUBLICATION'
AND a.application_number = 'APP-2025-001018';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'protocol_v1_APP-2025-001019.pdf', 'protocol_v1_APP-2025-001019.pdf', 'application/pdf', 679595, 'uploads/documents/protocol_v1_APP-2025-001019.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 77, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001019';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'icf_ar_APP-2025-001019.pdf', 'icf_ar_APP-2025-001019.pdf', 'application/pdf', 728975, 'uploads/documents/icf_ar_APP-2025-001019.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 77, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001019';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'icf_en_APP-2025-001019.pdf', 'icf_en_APP-2025-001019.pdf', 'application/pdf', 778355, 'uploads/documents/icf_en_APP-2025-001019.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 77, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001019';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001019.pdf', 'cv_pi_APP-2025-001019.pdf', 'application/pdf', 827735, 'uploads/documents/cv_pi_APP-2025-001019.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 77, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001019';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001019.pdf', 'cv_coi_APP-2025-001019.pdf', 'application/pdf', 877115, 'uploads/documents/cv_coi_APP-2025-001019.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 77, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001019';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'pis_APP-2025-001019.pdf', 'pis_APP-2025-001019.pdf', 'application/pdf', 926495, 'uploads/documents/pis_APP-2025-001019.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 77, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001019';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'irb_approval_APP-2025-001019.pdf', 'irb_approval_APP-2025-001019.pdf', 'application/pdf', 975875, 'uploads/documents/irb_approval_APP-2025-001019.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 77, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001019';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'funding_APP-2025-001019.pdf', 'funding_APP-2025-001019.pdf', 'application/pdf', 1025255, 'uploads/documents/funding_APP-2025-001019.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 77, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001019';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'budget_APP-2025-001019.xlsx', 'budget_APP-2025-001019.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 122213, 'uploads/documents/budget_APP-2025-001019.xlsx', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 77, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001019';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Burden of Non-Communicable Diseases in Urban and Rural Areas (موافقة)', 'ethics_decision_APP-2025-001019.pdf', 'ethics_decision_APP-2025-001019.pdf', 'application/pdf', 1124015, 'uploads/documents/ethics_decision_APP-2025-001019.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 77, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2025-001019';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'certificate_APP-2025-001019.pdf', 'certificate_APP-2025-001019.pdf', 'application/pdf', 1173395, 'uploads/documents/certificate_APP-2025-001019.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 77, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2025-001019';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'data_collection_APP-2025-001019.xlsx', 'data_collection_APP-2025-001019.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 135545, 'uploads/documents/data_collection_APP-2025-001019.xlsx', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 77, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001019';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Asthma Prevalence Among Children in Industrial Areas', 'protocol_v1_APP-2025-001020.pdf', 'protocol_v1_APP-2025-001020.pdf', 'application/pdf', 716630, 'uploads/documents/protocol_v1_APP-2025-001020.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 77, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001020';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Asthma Prevalence Among Children in Industrial Areas', 'icf_ar_APP-2025-001020.pdf', 'icf_ar_APP-2025-001020.pdf', 'application/pdf', 766010, 'uploads/documents/icf_ar_APP-2025-001020.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 77, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001020';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Asthma Prevalence Among Children in Industrial Areas', 'icf_en_APP-2025-001020.pdf', 'icf_en_APP-2025-001020.pdf', 'application/pdf', 815390, 'uploads/documents/icf_en_APP-2025-001020.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 77, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001020';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001020.pdf', 'cv_pi_APP-2025-001020.pdf', 'application/pdf', 864770, 'uploads/documents/cv_pi_APP-2025-001020.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 77, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001020';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001020.pdf', 'cv_coi_APP-2025-001020.pdf', 'application/pdf', 914150, 'uploads/documents/cv_coi_APP-2025-001020.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 77, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001020';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Asthma Prevalence Among Children in Industrial Areas', 'pis_APP-2025-001020.pdf', 'pis_APP-2025-001020.pdf', 'application/pdf', 963530, 'uploads/documents/pis_APP-2025-001020.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 77, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001020';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Asthma Prevalence Among Children in Industrial Areas', 'irb_approval_APP-2025-001020.pdf', 'irb_approval_APP-2025-001020.pdf', 'application/pdf', 1012910, 'uploads/documents/irb_approval_APP-2025-001020.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 77, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001020';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Asthma Prevalence Among Children in Industrial Areas', 'funding_APP-2025-001020.pdf', 'funding_APP-2025-001020.pdf', 'application/pdf', 1062290, 'uploads/documents/funding_APP-2025-001020.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 77, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001020';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Asthma Prevalence Among Children in Industrial Areas', 'budget_APP-2025-001020.xlsx', 'budget_APP-2025-001020.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 125546, 'uploads/documents/budget_APP-2025-001020.xlsx', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 77, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001020';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Asthma Prevalence Among Children in Industrial Areas (موافقة)', 'ethics_decision_APP-2025-001020.pdf', 'ethics_decision_APP-2025-001020.pdf', 'application/pdf', 1161050, 'uploads/documents/ethics_decision_APP-2025-001020.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 77, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2025-001020';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Asthma Prevalence Among Children in Industrial Areas', 'certificate_APP-2025-001020.pdf', 'certificate_APP-2025-001020.pdf', 'application/pdf', 1210430, 'uploads/documents/certificate_APP-2025-001020.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 77, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2025-001020';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Asthma Prevalence Among Children in Industrial Areas', 'final_report_APP-2025-001020.pdf', 'final_report_APP-2025-001020.pdf', 'application/pdf', 1259810, 'uploads/documents/final_report_APP-2025-001020.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 77, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2025-001020';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Asthma Prevalence Among Children in Industrial Areas', 'data_collection_APP-2025-001020.xlsx', 'data_collection_APP-2025-001020.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 143322, 'uploads/documents/data_collection_APP-2025-001020.xlsx', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 77, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001020';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'منشور علمي - Asthma Prevalence Among Children in Industrial Areas', 'publication_APP-2025-001020.pdf', 'publication_APP-2025-001020.pdf', 'application/pdf', 1358570, 'uploads/documents/publication_APP-2025-001020.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 77, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PUBLICATION'
AND a.application_number = 'APP-2025-001020';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Hypertension Prevalence Among Diabetic Patients in Sana''a Hospitals', 'protocol_v1_APP-2025-001021.pdf', 'protocol_v1_APP-2025-001021.pdf', 'application/pdf', 753665, 'uploads/documents/protocol_v1_APP-2025-001021.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 78, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001021';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Hypertension Prevalence Among Diabetic Patients in Sana''a Hospitals', 'icf_ar_APP-2025-001021.pdf', 'icf_ar_APP-2025-001021.pdf', 'application/pdf', 803045, 'uploads/documents/icf_ar_APP-2025-001021.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 78, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001021';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Hypertension Prevalence Among Diabetic Patients in Sana''a Hospitals', 'icf_en_APP-2025-001021.pdf', 'icf_en_APP-2025-001021.pdf', 'application/pdf', 852425, 'uploads/documents/icf_en_APP-2025-001021.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 78, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001021';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001021.pdf', 'cv_pi_APP-2025-001021.pdf', 'application/pdf', 901805, 'uploads/documents/cv_pi_APP-2025-001021.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 78, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001021';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001021.pdf', 'cv_coi_APP-2025-001021.pdf', 'application/pdf', 951185, 'uploads/documents/cv_coi_APP-2025-001021.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 78, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001021';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Hypertension Prevalence Among Diabetic Patients in Sana''a Hospitals', 'pis_APP-2025-001021.pdf', 'pis_APP-2025-001021.pdf', 'application/pdf', 1000565, 'uploads/documents/pis_APP-2025-001021.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 78, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001021';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Hypertension Prevalence Among Diabetic Patients in Sana''a Hospitals', 'irb_approval_APP-2025-001021.pdf', 'irb_approval_APP-2025-001021.pdf', 'application/pdf', 1049945, 'uploads/documents/irb_approval_APP-2025-001021.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 78, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001021';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Hypertension Prevalence Among Diabetic Patients in Sana''a Hospitals', 'funding_APP-2025-001021.pdf', 'funding_APP-2025-001021.pdf', 'application/pdf', 1099325, 'uploads/documents/funding_APP-2025-001021.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 78, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001021';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Hypertension Prevalence Among Diabetic Patients in Sana''a Hospitals', 'budget_APP-2025-001021.xlsx', 'budget_APP-2025-001021.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 128879, 'uploads/documents/budget_APP-2025-001021.xlsx', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 78, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001021';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Hypertension Prevalence Among Diabetic Patients in Sana''a Hospitals (موافقة)', 'ethics_decision_APP-2025-001021.pdf', 'ethics_decision_APP-2025-001021.pdf', 'application/pdf', 1198085, 'uploads/documents/ethics_decision_APP-2025-001021.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 78, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2025-001021';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Hypertension Prevalence Among Diabetic Patients in Sana''a Hospitals', 'certificate_APP-2025-001021.pdf', 'certificate_APP-2025-001021.pdf', 'application/pdf', 1247465, 'uploads/documents/certificate_APP-2025-001021.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 78, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2025-001021';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Hypertension Prevalence Among Diabetic Patients in Sana''a Hospitals', 'data_collection_APP-2025-001021.xlsx', 'data_collection_APP-2025-001021.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 142211, 'uploads/documents/data_collection_APP-2025-001021.xlsx', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 78, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001021';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Quality of Life Assessment Among Chronic Kidney Disease Patients', 'protocol_v1_APP-2025-001022.pdf', 'protocol_v1_APP-2025-001022.pdf', 'application/pdf', 790700, 'uploads/documents/protocol_v1_APP-2025-001022.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 79, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001022';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Quality of Life Assessment Among Chronic Kidney Disease Patients', 'icf_ar_APP-2025-001022.pdf', 'icf_ar_APP-2025-001022.pdf', 'application/pdf', 840080, 'uploads/documents/icf_ar_APP-2025-001022.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 79, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001022';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Quality of Life Assessment Among Chronic Kidney Disease Patients', 'icf_en_APP-2025-001022.pdf', 'icf_en_APP-2025-001022.pdf', 'application/pdf', 889460, 'uploads/documents/icf_en_APP-2025-001022.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 79, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001022';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001022.pdf', 'cv_pi_APP-2025-001022.pdf', 'application/pdf', 938840, 'uploads/documents/cv_pi_APP-2025-001022.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 79, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001022';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001022.pdf', 'cv_coi_APP-2025-001022.pdf', 'application/pdf', 988220, 'uploads/documents/cv_coi_APP-2025-001022.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 79, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001022';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Quality of Life Assessment Among Chronic Kidney Disease Patients', 'pis_APP-2025-001022.pdf', 'pis_APP-2025-001022.pdf', 'application/pdf', 1037600, 'uploads/documents/pis_APP-2025-001022.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 79, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001022';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Quality of Life Assessment Among Chronic Kidney Disease Patients', 'proposal_APP-2025-001022.pdf', 'proposal_APP-2025-001022.pdf', 'application/pdf', 1086980, 'uploads/documents/proposal_APP-2025-001022.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 79, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2025-001022';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Quality of Life Assessment Among Chronic Kidney Disease Patients', 'irb_approval_APP-2025-001022.pdf', 'irb_approval_APP-2025-001022.pdf', 'application/pdf', 1136360, 'uploads/documents/irb_approval_APP-2025-001022.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 79, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001022';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Quality of Life Assessment Among Chronic Kidney Disease Patients', 'funding_APP-2025-001022.pdf', 'funding_APP-2025-001022.pdf', 'application/pdf', 1185740, 'uploads/documents/funding_APP-2025-001022.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 79, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001022';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Quality of Life Assessment Among Chronic Kidney Disease Patients', 'budget_APP-2025-001022.xlsx', 'budget_APP-2025-001022.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 136656, 'uploads/documents/budget_APP-2025-001022.xlsx', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 79, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001022';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الإجراءات التشغيلية القياسية - Quality of Life Assessment Among Chronic Kidney Disease Patients', 'sop_APP-2025-001022.pdf', 'sop_APP-2025-001022.pdf', 'application/pdf', 1284500, 'uploads/documents/sop_APP-2025-001022.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 79, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'SOP'
AND a.application_number = 'APP-2025-001022';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'استبيان - Quality of Life Assessment Among Chronic Kidney Disease Patients', 'questionnaire_APP-2025-001022.pdf', 'questionnaire_APP-2025-001022.pdf', 'application/pdf', 1333880, 'uploads/documents/questionnaire_APP-2025-001022.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 79, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'QUESTIONNAIRE'
AND a.application_number = 'APP-2025-001022';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Quality of Life Assessment Among Chronic Kidney Disease Patients', 'data_collection_APP-2025-001022.xlsx', 'data_collection_APP-2025-001022.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 149988, 'uploads/documents/data_collection_APP-2025-001022.xlsx', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 79, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001022';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (79-1)', 'protocol_v1_APP-2025-001023.pdf', 'protocol_v1_APP-2025-001023.pdf', 'application/pdf', 827735, 'uploads/documents/protocol_v1_APP-2025-001023.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 79, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001023';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (79-1) (النسخة المعدلة)', 'protocol_v2_APP-2025-001023.pdf', 'protocol_v2_APP-2025-001023.pdf', 'application/pdf', 877115, 'uploads/documents/protocol_v2_APP-2025-001023.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 79, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001023';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (79-1)', 'icf_ar_APP-2025-001023.pdf', 'icf_ar_APP-2025-001023.pdf', 'application/pdf', 926495, 'uploads/documents/icf_ar_APP-2025-001023.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 79, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001023';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (79-1)', 'icf_en_APP-2025-001023.pdf', 'icf_en_APP-2025-001023.pdf', 'application/pdf', 975875, 'uploads/documents/icf_en_APP-2025-001023.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 79, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001023';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001023.pdf', 'cv_pi_APP-2025-001023.pdf', 'application/pdf', 1025255, 'uploads/documents/cv_pi_APP-2025-001023.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 79, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001023';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001023.pdf', 'cv_coi_APP-2025-001023.pdf', 'application/pdf', 1074635, 'uploads/documents/cv_coi_APP-2025-001023.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 79, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001023';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (79-1)', 'pis_APP-2025-001023.pdf', 'pis_APP-2025-001023.pdf', 'application/pdf', 1124015, 'uploads/documents/pis_APP-2025-001023.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 79, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001023';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (79-1)', 'irb_approval_APP-2025-001023.pdf', 'irb_approval_APP-2025-001023.pdf', 'application/pdf', 1173395, 'uploads/documents/irb_approval_APP-2025-001023.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 79, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001023';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (79-1)', 'funding_APP-2025-001023.pdf', 'funding_APP-2025-001023.pdf', 'application/pdf', 1222775, 'uploads/documents/funding_APP-2025-001023.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 79, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001023';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (79-1)', 'budget_APP-2025-001023.xlsx', 'budget_APP-2025-001023.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 139989, 'uploads/documents/budget_APP-2025-001023.xlsx', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 79, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001023';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (79-1) (موافقة)', 'ethics_decision_APP-2025-001023.pdf', 'ethics_decision_APP-2025-001023.pdf', 'application/pdf', 1321535, 'uploads/documents/ethics_decision_APP-2025-001023.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 79, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2025-001023';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (79-1)', 'certificate_APP-2025-001023.pdf', 'certificate_APP-2025-001023.pdf', 'application/pdf', 1370915, 'uploads/documents/certificate_APP-2025-001023.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 79, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2025-001023';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (79-1)', 'data_collection_APP-2025-001023.xlsx', 'data_collection_APP-2025-001023.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 153321, 'uploads/documents/data_collection_APP-2025-001023.xlsx', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 79, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001023';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Health System Preparedness Assessment for Health Emergencies', 'protocol_v1_APP-2025-001024.pdf', 'protocol_v1_APP-2025-001024.pdf', 'application/pdf', 864770, 'uploads/documents/protocol_v1_APP-2025-001024.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 80, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001024';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Health System Preparedness Assessment for Health Emergencies', 'icf_ar_APP-2025-001024.pdf', 'icf_ar_APP-2025-001024.pdf', 'application/pdf', 914150, 'uploads/documents/icf_ar_APP-2025-001024.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 80, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001024';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001024.pdf', 'cv_pi_APP-2025-001024.pdf', 'application/pdf', 963530, 'uploads/documents/cv_pi_APP-2025-001024.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 80, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001024';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Health System Preparedness Assessment for Health Emergencies', 'pis_APP-2025-001024.pdf', 'pis_APP-2025-001024.pdf', 'application/pdf', 1012910, 'uploads/documents/pis_APP-2025-001024.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 80, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001024';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'استبيان - Health System Preparedness Assessment for Health Emergencies', 'questionnaire_APP-2025-001024.pdf', 'questionnaire_APP-2025-001024.pdf', 'application/pdf', 1062290, 'uploads/documents/questionnaire_APP-2025-001024.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 80, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'QUESTIONNAIRE'
AND a.application_number = 'APP-2025-001024';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates', 'protocol_v1_APP-2025-001025.pdf', 'protocol_v1_APP-2025-001025.pdf', 'application/pdf', 901805, 'uploads/documents/protocol_v1_APP-2025-001025.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 81, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001025';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates', 'icf_ar_APP-2025-001025.pdf', 'icf_ar_APP-2025-001025.pdf', 'application/pdf', 951185, 'uploads/documents/icf_ar_APP-2025-001025.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 81, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001025';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates', 'icf_en_APP-2025-001025.pdf', 'icf_en_APP-2025-001025.pdf', 'application/pdf', 1000565, 'uploads/documents/icf_en_APP-2025-001025.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 81, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001025';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001025.pdf', 'cv_pi_APP-2025-001025.pdf', 'application/pdf', 1049945, 'uploads/documents/cv_pi_APP-2025-001025.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 81, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001025';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001025.pdf', 'cv_coi_APP-2025-001025.pdf', 'application/pdf', 1099325, 'uploads/documents/cv_coi_APP-2025-001025.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 81, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001025';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates', 'pis_APP-2025-001025.pdf', 'pis_APP-2025-001025.pdf', 'application/pdf', 1148705, 'uploads/documents/pis_APP-2025-001025.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 81, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001025';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates', 'irb_approval_APP-2025-001025.pdf', 'irb_approval_APP-2025-001025.pdf', 'application/pdf', 1198085, 'uploads/documents/irb_approval_APP-2025-001025.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 81, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001025';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates', 'funding_APP-2025-001025.pdf', 'funding_APP-2025-001025.pdf', 'application/pdf', 1247465, 'uploads/documents/funding_APP-2025-001025.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 81, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001025';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates', 'budget_APP-2025-001025.xlsx', 'budget_APP-2025-001025.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 142211, 'uploads/documents/budget_APP-2025-001025.xlsx', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 81, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001025';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates (موافقة)', 'ethics_decision_APP-2025-001025.pdf', 'ethics_decision_APP-2025-001025.pdf', 'application/pdf', 1346225, 'uploads/documents/ethics_decision_APP-2025-001025.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 81, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2025-001025';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates', 'certificate_APP-2025-001025.pdf', 'certificate_APP-2025-001025.pdf', 'application/pdf', 1395605, 'uploads/documents/certificate_APP-2025-001025.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 81, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2025-001025';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates', 'final_report_APP-2025-001025.pdf', 'final_report_APP-2025-001025.pdf', 'application/pdf', 1444985, 'uploads/documents/final_report_APP-2025-001025.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 81, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2025-001025';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates', 'data_collection_APP-2025-001025.xlsx', 'data_collection_APP-2025-001025.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 159987, 'uploads/documents/data_collection_APP-2025-001025.xlsx', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 81, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001025';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Injury Patterns from Road Traffic Accidents in Sana''a (81-1)', 'protocol_v1_APP-2025-001026.pdf', 'protocol_v1_APP-2025-001026.pdf', 'application/pdf', 938840, 'uploads/documents/protocol_v1_APP-2025-001026.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 81, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001026';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Injury Patterns from Road Traffic Accidents in Sana''a (81-1)', 'icf_APP-2025-001026.pdf', 'icf_APP-2025-001026.pdf', 'application/pdf', 988220, 'uploads/documents/icf_APP-2025-001026.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 81, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001026';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001026.pdf', 'cv_pi_APP-2025-001026.pdf', 'application/pdf', 1037600, 'uploads/documents/cv_pi_APP-2025-001026.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 81, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001026';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Injury Patterns from Road Traffic Accidents in Sana''a (81-1)', 'pis_APP-2025-001026.pdf', 'pis_APP-2025-001026.pdf', 'application/pdf', 1086980, 'uploads/documents/pis_APP-2025-001026.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 81, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001026';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Injury Patterns from Road Traffic Accidents in Sana''a (81-1)', 'proposal_APP-2025-001026.pdf', 'proposal_APP-2025-001026.pdf', 'application/pdf', 1136360, 'uploads/documents/proposal_APP-2025-001026.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 81, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2025-001026';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب سحب الطلب - Injury Patterns from Road Traffic Accidents in Sana''a (81-1)', 'withdrawal_APP-2025-001026.pdf', 'withdrawal_APP-2025-001026.pdf', 'application/pdf', 1185740, 'uploads/documents/withdrawal_APP-2025-001026.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 81, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'OTHER'
AND a.application_number = 'APP-2025-001026';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Effectiveness of Diabetes Awareness Programs in Schools', 'protocol_v1_APP-2025-001027.pdf', 'protocol_v1_APP-2025-001027.pdf', 'application/pdf', 975875, 'uploads/documents/protocol_v1_APP-2025-001027.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 82, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001027';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Effectiveness of Diabetes Awareness Programs in Schools', 'icf_ar_APP-2025-001027.pdf', 'icf_ar_APP-2025-001027.pdf', 'application/pdf', 1025255, 'uploads/documents/icf_ar_APP-2025-001027.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 82, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001027';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Effectiveness of Diabetes Awareness Programs in Schools', 'icf_en_APP-2025-001027.pdf', 'icf_en_APP-2025-001027.pdf', 'application/pdf', 1074635, 'uploads/documents/icf_en_APP-2025-001027.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 82, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001027';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001027.pdf', 'cv_pi_APP-2025-001027.pdf', 'application/pdf', 1124015, 'uploads/documents/cv_pi_APP-2025-001027.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 82, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001027';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001027.pdf', 'cv_coi_APP-2025-001027.pdf', 'application/pdf', 1173395, 'uploads/documents/cv_coi_APP-2025-001027.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 82, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001027';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Effectiveness of Diabetes Awareness Programs in Schools', 'pis_APP-2025-001027.pdf', 'pis_APP-2025-001027.pdf', 'application/pdf', 1222775, 'uploads/documents/pis_APP-2025-001027.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 82, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001027';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Effectiveness of Diabetes Awareness Programs in Schools', 'irb_approval_APP-2025-001027.pdf', 'irb_approval_APP-2025-001027.pdf', 'application/pdf', 1272155, 'uploads/documents/irb_approval_APP-2025-001027.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 82, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001027';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Effectiveness of Diabetes Awareness Programs in Schools', 'funding_APP-2025-001027.pdf', 'funding_APP-2025-001027.pdf', 'application/pdf', 1321535, 'uploads/documents/funding_APP-2025-001027.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 82, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001027';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Effectiveness of Diabetes Awareness Programs in Schools', 'budget_APP-2025-001027.xlsx', 'budget_APP-2025-001027.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 148877, 'uploads/documents/budget_APP-2025-001027.xlsx', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 82, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001027';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Effectiveness of Diabetes Awareness Programs in Schools (موافقة)', 'ethics_decision_APP-2025-001027.pdf', 'ethics_decision_APP-2025-001027.pdf', 'application/pdf', 1420295, 'uploads/documents/ethics_decision_APP-2025-001027.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 82, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2025-001027';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Effectiveness of Diabetes Awareness Programs in Schools', 'certificate_APP-2025-001027.pdf', 'certificate_APP-2025-001027.pdf', 'application/pdf', 1469675, 'uploads/documents/certificate_APP-2025-001027.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 82, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2025-001027';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Effectiveness of Diabetes Awareness Programs in Schools', 'data_collection_APP-2025-001027.xlsx', 'data_collection_APP-2025-001027.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 162209, 'uploads/documents/data_collection_APP-2025-001027.xlsx', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 82, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001027';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Effectiveness of Supplementary Feeding Programs in Affected Areas (83-0)', 'protocol_v1_APP-2025-001028.pdf', 'protocol_v1_APP-2025-001028.pdf', 'application/pdf', 1012910, 'uploads/documents/protocol_v1_APP-2025-001028.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 83, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001028';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Effectiveness of Supplementary Feeding Programs in Affected Areas (83-0)', 'icf_ar_APP-2025-001028.pdf', 'icf_ar_APP-2025-001028.pdf', 'application/pdf', 1062290, 'uploads/documents/icf_ar_APP-2025-001028.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 83, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001028';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Effectiveness of Supplementary Feeding Programs in Affected Areas (83-0)', 'icf_en_APP-2025-001028.pdf', 'icf_en_APP-2025-001028.pdf', 'application/pdf', 1111670, 'uploads/documents/icf_en_APP-2025-001028.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 83, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001028';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001028.pdf', 'cv_pi_APP-2025-001028.pdf', 'application/pdf', 1161050, 'uploads/documents/cv_pi_APP-2025-001028.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 83, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001028';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001028.pdf', 'cv_coi_APP-2025-001028.pdf', 'application/pdf', 1210430, 'uploads/documents/cv_coi_APP-2025-001028.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 83, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001028';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Effectiveness of Supplementary Feeding Programs in Affected Areas (83-0)', 'pis_APP-2025-001028.pdf', 'pis_APP-2025-001028.pdf', 'application/pdf', 1259810, 'uploads/documents/pis_APP-2025-001028.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 83, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001028';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Effectiveness of Supplementary Feeding Programs in Affected Areas (83-0)', 'irb_approval_APP-2025-001028.pdf', 'irb_approval_APP-2025-001028.pdf', 'application/pdf', 1309190, 'uploads/documents/irb_approval_APP-2025-001028.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 83, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001028';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Effectiveness of Supplementary Feeding Programs in Affected Areas (83-0)', 'funding_APP-2025-001028.pdf', 'funding_APP-2025-001028.pdf', 'application/pdf', 1358570, 'uploads/documents/funding_APP-2025-001028.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 83, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001028';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Effectiveness of Supplementary Feeding Programs in Affected Areas (83-0)', 'budget_APP-2025-001028.xlsx', 'budget_APP-2025-001028.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 152210, 'uploads/documents/budget_APP-2025-001028.xlsx', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 83, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001028';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Effectiveness of Supplementary Feeding Programs in Affected Areas (83-0) (موافقة)', 'ethics_decision_APP-2025-001028.pdf', 'ethics_decision_APP-2025-001028.pdf', 'application/pdf', 1457330, 'uploads/documents/ethics_decision_APP-2025-001028.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 83, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2025-001028';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Effectiveness of Supplementary Feeding Programs in Affected Areas (83-0)', 'certificate_APP-2025-001028.pdf', 'certificate_APP-2025-001028.pdf', 'application/pdf', 1506710, 'uploads/documents/certificate_APP-2025-001028.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 83, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2025-001028';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Effectiveness of Supplementary Feeding Programs in Affected Areas (83-0)', 'data_collection_APP-2025-001028.xlsx', 'data_collection_APP-2025-001028.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 165542, 'uploads/documents/data_collection_APP-2025-001028.xlsx', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 83, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001028';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Assessment of Emergency Services in Yemeni General Hospitals (83-1)', 'protocol_v1_APP-2025-001029.pdf', 'protocol_v1_APP-2025-001029.pdf', 'application/pdf', 1049945, 'uploads/documents/protocol_v1_APP-2025-001029.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 83, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2025-001029';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Assessment of Emergency Services in Yemeni General Hospitals (83-1)', 'icf_ar_APP-2025-001029.pdf', 'icf_ar_APP-2025-001029.pdf', 'application/pdf', 1099325, 'uploads/documents/icf_ar_APP-2025-001029.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 83, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001029';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Assessment of Emergency Services in Yemeni General Hospitals (83-1)', 'icf_en_APP-2025-001029.pdf', 'icf_en_APP-2025-001029.pdf', 'application/pdf', 1148705, 'uploads/documents/icf_en_APP-2025-001029.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 83, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2025-001029';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2025-001029.pdf', 'cv_pi_APP-2025-001029.pdf', 'application/pdf', 1198085, 'uploads/documents/cv_pi_APP-2025-001029.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 83, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001029';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2025-001029.pdf', 'cv_coi_APP-2025-001029.pdf', 'application/pdf', 1247465, 'uploads/documents/cv_coi_APP-2025-001029.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 83, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2025-001029';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Assessment of Emergency Services in Yemeni General Hospitals (83-1)', 'pis_APP-2025-001029.pdf', 'pis_APP-2025-001029.pdf', 'application/pdf', 1296845, 'uploads/documents/pis_APP-2025-001029.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 83, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2025-001029';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Assessment of Emergency Services in Yemeni General Hospitals (83-1)', 'proposal_APP-2025-001029.pdf', 'proposal_APP-2025-001029.pdf', 'application/pdf', 1346225, 'uploads/documents/proposal_APP-2025-001029.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 83, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2025-001029';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Assessment of Emergency Services in Yemeni General Hospitals (83-1)', 'irb_approval_APP-2025-001029.pdf', 'irb_approval_APP-2025-001029.pdf', 'application/pdf', 1395605, 'uploads/documents/irb_approval_APP-2025-001029.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 83, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2025-001029';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Assessment of Emergency Services in Yemeni General Hospitals (83-1)', 'funding_APP-2025-001029.pdf', 'funding_APP-2025-001029.pdf', 'application/pdf', 1444985, 'uploads/documents/funding_APP-2025-001029.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 83, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2025-001029';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Assessment of Emergency Services in Yemeni General Hospitals (83-1)', 'budget_APP-2025-001029.xlsx', 'budget_APP-2025-001029.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 159987, 'uploads/documents/budget_APP-2025-001029.xlsx', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 83, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2025-001029';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج تقرير الحالة - Assessment of Emergency Services in Yemeni General Hospitals (83-1)', 'crf_APP-2025-001029.pdf', 'crf_APP-2025-001029.pdf', 'application/pdf', 1543745, 'uploads/documents/crf_APP-2025-001029.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 83, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CRF'
AND a.application_number = 'APP-2025-001029';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Assessment of Emergency Services in Yemeni General Hospitals (83-1)', 'data_collection_APP-2025-001029.xlsx', 'data_collection_APP-2025-001029.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 168875, 'uploads/documents/data_collection_APP-2025-001029.xlsx', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 83, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2025-001029';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Effectiveness of Supplementary Feeding Programs in Affected Areas (84-0)', 'protocol_v1_APP-2026-001030.pdf', 'protocol_v1_APP-2026-001030.pdf', 'application/pdf', 1086980, 'uploads/documents/protocol_v1_APP-2026-001030.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 84, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001030';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Effectiveness of Supplementary Feeding Programs in Affected Areas (84-0)', 'icf_ar_APP-2026-001030.pdf', 'icf_ar_APP-2026-001030.pdf', 'application/pdf', 1136360, 'uploads/documents/icf_ar_APP-2026-001030.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 84, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001030';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Effectiveness of Supplementary Feeding Programs in Affected Areas (84-0)', 'icf_en_APP-2026-001030.pdf', 'icf_en_APP-2026-001030.pdf', 'application/pdf', 1185740, 'uploads/documents/icf_en_APP-2026-001030.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 84, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001030';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001030.pdf', 'cv_pi_APP-2026-001030.pdf', 'application/pdf', 1235120, 'uploads/documents/cv_pi_APP-2026-001030.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 84, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001030';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001030.pdf', 'cv_coi_APP-2026-001030.pdf', 'application/pdf', 1284500, 'uploads/documents/cv_coi_APP-2026-001030.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 84, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001030';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Effectiveness of Supplementary Feeding Programs in Affected Areas (84-0)', 'pis_APP-2026-001030.pdf', 'pis_APP-2026-001030.pdf', 'application/pdf', 1333880, 'uploads/documents/pis_APP-2026-001030.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 84, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001030';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Effectiveness of Supplementary Feeding Programs in Affected Areas (84-0)', 'irb_approval_APP-2026-001030.pdf', 'irb_approval_APP-2026-001030.pdf', 'application/pdf', 1383260, 'uploads/documents/irb_approval_APP-2026-001030.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 84, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001030';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Effectiveness of Supplementary Feeding Programs in Affected Areas (84-0)', 'funding_APP-2026-001030.pdf', 'funding_APP-2026-001030.pdf', 'application/pdf', 1432640, 'uploads/documents/funding_APP-2026-001030.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 84, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001030';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Effectiveness of Supplementary Feeding Programs in Affected Areas (84-0)', 'budget_APP-2026-001030.xlsx', 'budget_APP-2026-001030.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 158876, 'uploads/documents/budget_APP-2026-001030.xlsx', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 84, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001030';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Effectiveness of Supplementary Feeding Programs in Affected Areas (84-0) (موافقة)', 'ethics_decision_APP-2026-001030.pdf', 'ethics_decision_APP-2026-001030.pdf', 'application/pdf', 1531400, 'uploads/documents/ethics_decision_APP-2026-001030.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 84, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001030';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Effectiveness of Supplementary Feeding Programs in Affected Areas (84-0)', 'certificate_APP-2026-001030.pdf', 'certificate_APP-2026-001030.pdf', 'application/pdf', 1580780, 'uploads/documents/certificate_APP-2026-001030.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 84, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001030';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Effectiveness of Supplementary Feeding Programs in Affected Areas (84-0)', 'data_collection_APP-2026-001030.xlsx', 'data_collection_APP-2026-001030.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 172208, 'uploads/documents/data_collection_APP-2026-001030.xlsx', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 84, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001030';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Evaluation of Nutritional Supplements in Malnourished Patients', 'protocol_v1_APP-2026-001031.pdf', 'protocol_v1_APP-2026-001031.pdf', 'application/pdf', 1124015, 'uploads/documents/protocol_v1_APP-2026-001031.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 85, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001031';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Evaluation of Nutritional Supplements in Malnourished Patients', 'icf_ar_APP-2026-001031.pdf', 'icf_ar_APP-2026-001031.pdf', 'application/pdf', 1173395, 'uploads/documents/icf_ar_APP-2026-001031.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 85, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001031';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Evaluation of Nutritional Supplements in Malnourished Patients', 'icf_en_APP-2026-001031.pdf', 'icf_en_APP-2026-001031.pdf', 'application/pdf', 1222775, 'uploads/documents/icf_en_APP-2026-001031.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 85, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001031';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001031.pdf', 'cv_pi_APP-2026-001031.pdf', 'application/pdf', 1272155, 'uploads/documents/cv_pi_APP-2026-001031.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 85, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001031';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001031.pdf', 'cv_coi_APP-2026-001031.pdf', 'application/pdf', 1321535, 'uploads/documents/cv_coi_APP-2026-001031.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 85, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001031';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Evaluation of Nutritional Supplements in Malnourished Patients', 'pis_APP-2026-001031.pdf', 'pis_APP-2026-001031.pdf', 'application/pdf', 1370915, 'uploads/documents/pis_APP-2026-001031.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 85, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001031';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Evaluation of Nutritional Supplements in Malnourished Patients', 'irb_approval_APP-2026-001031.pdf', 'irb_approval_APP-2026-001031.pdf', 'application/pdf', 1420295, 'uploads/documents/irb_approval_APP-2026-001031.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 85, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001031';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Evaluation of Nutritional Supplements in Malnourished Patients', 'funding_APP-2026-001031.pdf', 'funding_APP-2026-001031.pdf', 'application/pdf', 1469675, 'uploads/documents/funding_APP-2026-001031.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 85, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001031';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Evaluation of Nutritional Supplements in Malnourished Patients', 'budget_APP-2026-001031.xlsx', 'budget_APP-2026-001031.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 162209, 'uploads/documents/budget_APP-2026-001031.xlsx', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 85, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001031';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Evaluation of Nutritional Supplements in Malnourished Patients (موافقة)', 'ethics_decision_APP-2026-001031.pdf', 'ethics_decision_APP-2026-001031.pdf', 'application/pdf', 1568435, 'uploads/documents/ethics_decision_APP-2026-001031.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 85, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001031';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Evaluation of Nutritional Supplements in Malnourished Patients', 'certificate_APP-2026-001031.pdf', 'certificate_APP-2026-001031.pdf', 'application/pdf', 1617815, 'uploads/documents/certificate_APP-2026-001031.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 85, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001031';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Evaluation of Nutritional Supplements in Malnourished Patients', 'final_report_APP-2026-001031.pdf', 'final_report_APP-2026-001031.pdf', 'application/pdf', 1667195, 'uploads/documents/final_report_APP-2026-001031.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 85, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001031';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Evaluation of Nutritional Supplements in Malnourished Patients', 'data_collection_APP-2026-001031.xlsx', 'data_collection_APP-2026-001031.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 179985, 'uploads/documents/data_collection_APP-2026-001031.xlsx', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 85, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001031';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Analysis of Public Health Policy Effectiveness in Combating Chronic Diseases (مسودة)', 'protocol_draft_APP-2026-001032.pdf', 'protocol_draft_APP-2026-001032.pdf', 'application/pdf', 1161050, 'uploads/documents/protocol_draft_APP-2026-001032.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 85, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001032';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Analysis of Public Health Policy Effectiveness in Combating Chronic Diseases (مسودة)', 'icf_draft_APP-2026-001032.pdf', 'icf_draft_APP-2026-001032.pdf', 'application/pdf', 1210430, 'uploads/documents/icf_draft_APP-2026-001032.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 85, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001032';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (85-2)', 'protocol_v1_APP-2026-001033.pdf', 'protocol_v1_APP-2026-001033.pdf', 'application/pdf', 1198085, 'uploads/documents/protocol_v1_APP-2026-001033.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 85, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001033';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (85-2)', 'icf_ar_APP-2026-001033.pdf', 'icf_ar_APP-2026-001033.pdf', 'application/pdf', 1247465, 'uploads/documents/icf_ar_APP-2026-001033.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 85, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001033';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (85-2)', 'icf_en_APP-2026-001033.pdf', 'icf_en_APP-2026-001033.pdf', 'application/pdf', 1296845, 'uploads/documents/icf_en_APP-2026-001033.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 85, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001033';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001033.pdf', 'cv_pi_APP-2026-001033.pdf', 'application/pdf', 1346225, 'uploads/documents/cv_pi_APP-2026-001033.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 85, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001033';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001033.pdf', 'cv_coi_APP-2026-001033.pdf', 'application/pdf', 1395605, 'uploads/documents/cv_coi_APP-2026-001033.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 85, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001033';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (85-2)', 'pis_APP-2026-001033.pdf', 'pis_APP-2026-001033.pdf', 'application/pdf', 1444985, 'uploads/documents/pis_APP-2026-001033.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 85, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001033';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (85-2)', 'irb_approval_APP-2026-001033.pdf', 'irb_approval_APP-2026-001033.pdf', 'application/pdf', 1494365, 'uploads/documents/irb_approval_APP-2026-001033.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 85, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001033';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (85-2)', 'funding_APP-2026-001033.pdf', 'funding_APP-2026-001033.pdf', 'application/pdf', 1543745, 'uploads/documents/funding_APP-2026-001033.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 85, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001033';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (85-2)', 'budget_APP-2026-001033.xlsx', 'budget_APP-2026-001033.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 168875, 'uploads/documents/budget_APP-2026-001033.xlsx', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 85, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001033';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (85-2) (موافقة)', 'ethics_decision_APP-2026-001033.pdf', 'ethics_decision_APP-2026-001033.pdf', 'application/pdf', 1642505, 'uploads/documents/ethics_decision_APP-2026-001033.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 85, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001033';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (85-2)', 'certificate_APP-2026-001033.pdf', 'certificate_APP-2026-001033.pdf', 'application/pdf', 1691885, 'uploads/documents/certificate_APP-2026-001033.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 85, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001033';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (85-2)', 'final_report_APP-2026-001033.pdf', 'final_report_APP-2026-001033.pdf', 'application/pdf', 1741265, 'uploads/documents/final_report_APP-2026-001033.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 85, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001033';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (85-2)', 'data_collection_APP-2026-001033.xlsx', 'data_collection_APP-2026-001033.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 186651, 'uploads/documents/data_collection_APP-2026-001033.xlsx', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 85, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001033';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Antimicrobial Resistance Prevalence in Yemeni Hospitals', 'protocol_v1_APP-2026-001034.pdf', 'protocol_v1_APP-2026-001034.pdf', 'application/pdf', 1235120, 'uploads/documents/protocol_v1_APP-2026-001034.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 85, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001034';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Antimicrobial Resistance Prevalence in Yemeni Hospitals', 'icf_APP-2026-001034.pdf', 'icf_APP-2026-001034.pdf', 'application/pdf', 1284500, 'uploads/documents/icf_APP-2026-001034.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 85, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001034';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001034.pdf', 'cv_pi_APP-2026-001034.pdf', 'application/pdf', 1333880, 'uploads/documents/cv_pi_APP-2026-001034.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 85, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001034';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Antimicrobial Resistance Prevalence in Yemeni Hospitals', 'pis_APP-2026-001034.pdf', 'pis_APP-2026-001034.pdf', 'application/pdf', 1383260, 'uploads/documents/pis_APP-2026-001034.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 85, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001034';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Antimicrobial Resistance Prevalence in Yemeni Hospitals', 'proposal_APP-2026-001034.pdf', 'proposal_APP-2026-001034.pdf', 'application/pdf', 1432640, 'uploads/documents/proposal_APP-2026-001034.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 85, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2026-001034';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب سحب الطلب - Antimicrobial Resistance Prevalence in Yemeni Hospitals', 'withdrawal_APP-2026-001034.pdf', 'withdrawal_APP-2026-001034.pdf', 'application/pdf', 1482020, 'uploads/documents/withdrawal_APP-2026-001034.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 85, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'OTHER'
AND a.application_number = 'APP-2026-001034';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Evaluation of Communicable Disease Surveillance System in Yemen', 'protocol_v1_APP-2026-001035.pdf', 'protocol_v1_APP-2026-001035.pdf', 'application/pdf', 1272155, 'uploads/documents/protocol_v1_APP-2026-001035.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 86, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001035';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Evaluation of Communicable Disease Surveillance System in Yemen', 'icf_ar_APP-2026-001035.pdf', 'icf_ar_APP-2026-001035.pdf', 'application/pdf', 1321535, 'uploads/documents/icf_ar_APP-2026-001035.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 86, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001035';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Evaluation of Communicable Disease Surveillance System in Yemen', 'icf_en_APP-2026-001035.pdf', 'icf_en_APP-2026-001035.pdf', 'application/pdf', 1370915, 'uploads/documents/icf_en_APP-2026-001035.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 86, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001035';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001035.pdf', 'cv_pi_APP-2026-001035.pdf', 'application/pdf', 1420295, 'uploads/documents/cv_pi_APP-2026-001035.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 86, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001035';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001035.pdf', 'cv_coi_APP-2026-001035.pdf', 'application/pdf', 1469675, 'uploads/documents/cv_coi_APP-2026-001035.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 86, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001035';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Evaluation of Communicable Disease Surveillance System in Yemen', 'pis_APP-2026-001035.pdf', 'pis_APP-2026-001035.pdf', 'application/pdf', 1519055, 'uploads/documents/pis_APP-2026-001035.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 86, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001035';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Evaluation of Communicable Disease Surveillance System in Yemen', 'irb_approval_APP-2026-001035.pdf', 'irb_approval_APP-2026-001035.pdf', 'application/pdf', 1568435, 'uploads/documents/irb_approval_APP-2026-001035.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 86, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001035';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Evaluation of Communicable Disease Surveillance System in Yemen', 'funding_APP-2026-001035.pdf', 'funding_APP-2026-001035.pdf', 'application/pdf', 1617815, 'uploads/documents/funding_APP-2026-001035.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 86, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001035';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Evaluation of Communicable Disease Surveillance System in Yemen', 'budget_APP-2026-001035.xlsx', 'budget_APP-2026-001035.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 175541, 'uploads/documents/budget_APP-2026-001035.xlsx', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 86, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001035';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Evaluation of Communicable Disease Surveillance System in Yemen (موافقة)', 'ethics_decision_APP-2026-001035.pdf', 'ethics_decision_APP-2026-001035.pdf', 'application/pdf', 1716575, 'uploads/documents/ethics_decision_APP-2026-001035.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 86, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001035';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Evaluation of Communicable Disease Surveillance System in Yemen', 'certificate_APP-2026-001035.pdf', 'certificate_APP-2026-001035.pdf', 'application/pdf', 1765955, 'uploads/documents/certificate_APP-2026-001035.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 86, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001035';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Evaluation of Communicable Disease Surveillance System in Yemen', 'final_report_APP-2026-001035.pdf', 'final_report_APP-2026-001035.pdf', 'application/pdf', 1815335, 'uploads/documents/final_report_APP-2026-001035.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 86, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001035';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Evaluation of Communicable Disease Surveillance System in Yemen', 'data_collection_APP-2026-001035.xlsx', 'data_collection_APP-2026-001035.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 193317, 'uploads/documents/data_collection_APP-2026-001035.xlsx', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 86, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001035';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Efficacy and Safety Evaluation of Generic Medicines in Yemen', 'protocol_v1_APP-2026-001036.pdf', 'protocol_v1_APP-2026-001036.pdf', 'application/pdf', 1309190, 'uploads/documents/protocol_v1_APP-2026-001036.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 86, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001036';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Efficacy and Safety Evaluation of Generic Medicines in Yemen', 'icf_ar_APP-2026-001036.pdf', 'icf_ar_APP-2026-001036.pdf', 'application/pdf', 1358570, 'uploads/documents/icf_ar_APP-2026-001036.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 86, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001036';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Efficacy and Safety Evaluation of Generic Medicines in Yemen', 'icf_en_APP-2026-001036.pdf', 'icf_en_APP-2026-001036.pdf', 'application/pdf', 1407950, 'uploads/documents/icf_en_APP-2026-001036.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 86, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001036';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001036.pdf', 'cv_pi_APP-2026-001036.pdf', 'application/pdf', 1457330, 'uploads/documents/cv_pi_APP-2026-001036.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 86, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001036';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001036.pdf', 'cv_coi_APP-2026-001036.pdf', 'application/pdf', 1506710, 'uploads/documents/cv_coi_APP-2026-001036.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 86, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001036';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Efficacy and Safety Evaluation of Generic Medicines in Yemen', 'pis_APP-2026-001036.pdf', 'pis_APP-2026-001036.pdf', 'application/pdf', 1556090, 'uploads/documents/pis_APP-2026-001036.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 86, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001036';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Efficacy and Safety Evaluation of Generic Medicines in Yemen', 'proposal_APP-2026-001036.pdf', 'proposal_APP-2026-001036.pdf', 'application/pdf', 1605470, 'uploads/documents/proposal_APP-2026-001036.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 86, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2026-001036';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Efficacy and Safety Evaluation of Generic Medicines in Yemen', 'irb_approval_APP-2026-001036.pdf', 'irb_approval_APP-2026-001036.pdf', 'application/pdf', 1654850, 'uploads/documents/irb_approval_APP-2026-001036.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 86, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001036';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Efficacy and Safety Evaluation of Generic Medicines in Yemen', 'funding_APP-2026-001036.pdf', 'funding_APP-2026-001036.pdf', 'application/pdf', 1704230, 'uploads/documents/funding_APP-2026-001036.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 86, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001036';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Efficacy and Safety Evaluation of Generic Medicines in Yemen', 'budget_APP-2026-001036.xlsx', 'budget_APP-2026-001036.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 183318, 'uploads/documents/budget_APP-2026-001036.xlsx', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 86, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001036';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الإجراءات التشغيلية القياسية - Efficacy and Safety Evaluation of Generic Medicines in Yemen', 'sop_APP-2026-001036.pdf', 'sop_APP-2026-001036.pdf', 'application/pdf', 1802990, 'uploads/documents/sop_APP-2026-001036.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 86, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'SOP'
AND a.application_number = 'APP-2026-001036';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'محضر اجتماع اللجنة - Efficacy and Safety Evaluation of Generic Medicines in Yemen', 'minutes_APP-2026-001036.pdf', 'minutes_APP-2026-001036.pdf', 'application/pdf', 1852370, 'uploads/documents/minutes_APP-2026-001036.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 86, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'MEETING_MINUTES'
AND a.application_number = 'APP-2026-001036';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates (86-2)', 'protocol_v1_APP-2026-001037.pdf', 'protocol_v1_APP-2026-001037.pdf', 'application/pdf', 1346225, 'uploads/documents/protocol_v1_APP-2026-001037.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 86, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001037';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates (86-2)', 'icf_ar_APP-2026-001037.pdf', 'icf_ar_APP-2026-001037.pdf', 'application/pdf', 1395605, 'uploads/documents/icf_ar_APP-2026-001037.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 86, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001037';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001037.pdf', 'cv_pi_APP-2026-001037.pdf', 'application/pdf', 1444985, 'uploads/documents/cv_pi_APP-2026-001037.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 86, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001037';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates (86-2)', 'pis_APP-2026-001037.pdf', 'pis_APP-2026-001037.pdf', 'application/pdf', 1494365, 'uploads/documents/pis_APP-2026-001037.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 86, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001037';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج تقرير الحالة - Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates (86-2)', 'crf_APP-2026-001037.pdf', 'crf_APP-2026-001037.pdf', 'application/pdf', 1543745, 'uploads/documents/crf_APP-2026-001037.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 86, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CRF'
AND a.application_number = 'APP-2026-001037';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Economic Burden of Thalassemia on Yemeni Families', 'protocol_v1_APP-2026-001038.pdf', 'protocol_v1_APP-2026-001038.pdf', 'application/pdf', 1383260, 'uploads/documents/protocol_v1_APP-2026-001038.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 87, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001038';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Economic Burden of Thalassemia on Yemeni Families (النسخة المعدلة)', 'protocol_v2_APP-2026-001038.pdf', 'protocol_v2_APP-2026-001038.pdf', 'application/pdf', 1432640, 'uploads/documents/protocol_v2_APP-2026-001038.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 87, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001038';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Economic Burden of Thalassemia on Yemeni Families', 'icf_ar_APP-2026-001038.pdf', 'icf_ar_APP-2026-001038.pdf', 'application/pdf', 1482020, 'uploads/documents/icf_ar_APP-2026-001038.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 87, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001038';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Economic Burden of Thalassemia on Yemeni Families', 'icf_en_APP-2026-001038.pdf', 'icf_en_APP-2026-001038.pdf', 'application/pdf', 1531400, 'uploads/documents/icf_en_APP-2026-001038.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 87, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001038';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001038.pdf', 'cv_pi_APP-2026-001038.pdf', 'application/pdf', 1580780, 'uploads/documents/cv_pi_APP-2026-001038.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 87, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001038';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001038.pdf', 'cv_coi_APP-2026-001038.pdf', 'application/pdf', 1630160, 'uploads/documents/cv_coi_APP-2026-001038.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 87, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001038';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Economic Burden of Thalassemia on Yemeni Families', 'pis_APP-2026-001038.pdf', 'pis_APP-2026-001038.pdf', 'application/pdf', 1679540, 'uploads/documents/pis_APP-2026-001038.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 87, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001038';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Economic Burden of Thalassemia on Yemeni Families', 'irb_approval_APP-2026-001038.pdf', 'irb_approval_APP-2026-001038.pdf', 'application/pdf', 1728920, 'uploads/documents/irb_approval_APP-2026-001038.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 87, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001038';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Economic Burden of Thalassemia on Yemeni Families', 'funding_APP-2026-001038.pdf', 'funding_APP-2026-001038.pdf', 'application/pdf', 1778300, 'uploads/documents/funding_APP-2026-001038.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 87, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001038';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Economic Burden of Thalassemia on Yemeni Families', 'budget_APP-2026-001038.xlsx', 'budget_APP-2026-001038.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 189984, 'uploads/documents/budget_APP-2026-001038.xlsx', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 87, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001038';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Economic Burden of Thalassemia on Yemeni Families (موافقة)', 'ethics_decision_APP-2026-001038.pdf', 'ethics_decision_APP-2026-001038.pdf', 'application/pdf', 1877060, 'uploads/documents/ethics_decision_APP-2026-001038.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 87, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001038';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Economic Burden of Thalassemia on Yemeni Families', 'certificate_APP-2026-001038.pdf', 'certificate_APP-2026-001038.pdf', 'application/pdf', 1926440, 'uploads/documents/certificate_APP-2026-001038.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 87, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001038';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Economic Burden of Thalassemia on Yemeni Families', 'data_collection_APP-2026-001038.xlsx', 'data_collection_APP-2026-001038.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 203316, 'uploads/documents/data_collection_APP-2026-001038.xlsx', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 87, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001038';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Asthma Prevalence Among Children in Industrial Areas (87-1)', 'protocol_v1_APP-2026-001039.pdf', 'protocol_v1_APP-2026-001039.pdf', 'application/pdf', 1420295, 'uploads/documents/protocol_v1_APP-2026-001039.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 87, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001039';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Asthma Prevalence Among Children in Industrial Areas (87-1)', 'icf_ar_APP-2026-001039.pdf', 'icf_ar_APP-2026-001039.pdf', 'application/pdf', 1469675, 'uploads/documents/icf_ar_APP-2026-001039.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 87, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001039';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001039.pdf', 'cv_pi_APP-2026-001039.pdf', 'application/pdf', 1519055, 'uploads/documents/cv_pi_APP-2026-001039.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 87, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001039';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Asthma Prevalence Among Children in Industrial Areas (87-1)', 'pis_APP-2026-001039.pdf', 'pis_APP-2026-001039.pdf', 'application/pdf', 1568435, 'uploads/documents/pis_APP-2026-001039.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 87, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001039';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج تقرير الحالة - Asthma Prevalence Among Children in Industrial Areas (87-1)', 'crf_APP-2026-001039.pdf', 'crf_APP-2026-001039.pdf', 'application/pdf', 1617815, 'uploads/documents/crf_APP-2026-001039.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 87, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CRF'
AND a.application_number = 'APP-2026-001039';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Antimicrobial Resistance Prevalence in Yemeni Hospitals (87-2)', 'protocol_v1_APP-2026-001040.pdf', 'protocol_v1_APP-2026-001040.pdf', 'application/pdf', 1457330, 'uploads/documents/protocol_v1_APP-2026-001040.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 87, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001040';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Antimicrobial Resistance Prevalence in Yemeni Hospitals (87-2)', 'icf_ar_APP-2026-001040.pdf', 'icf_ar_APP-2026-001040.pdf', 'application/pdf', 1506710, 'uploads/documents/icf_ar_APP-2026-001040.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 87, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001040';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Antimicrobial Resistance Prevalence in Yemeni Hospitals (87-2)', 'icf_en_APP-2026-001040.pdf', 'icf_en_APP-2026-001040.pdf', 'application/pdf', 1556090, 'uploads/documents/icf_en_APP-2026-001040.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 87, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001040';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001040.pdf', 'cv_pi_APP-2026-001040.pdf', 'application/pdf', 1605470, 'uploads/documents/cv_pi_APP-2026-001040.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 87, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001040';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001040.pdf', 'cv_coi_APP-2026-001040.pdf', 'application/pdf', 1654850, 'uploads/documents/cv_coi_APP-2026-001040.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 87, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001040';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Antimicrobial Resistance Prevalence in Yemeni Hospitals (87-2)', 'pis_APP-2026-001040.pdf', 'pis_APP-2026-001040.pdf', 'application/pdf', 1704230, 'uploads/documents/pis_APP-2026-001040.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 87, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001040';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Antimicrobial Resistance Prevalence in Yemeni Hospitals (87-2)', 'irb_approval_APP-2026-001040.pdf', 'irb_approval_APP-2026-001040.pdf', 'application/pdf', 1753610, 'uploads/documents/irb_approval_APP-2026-001040.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 87, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001040';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Antimicrobial Resistance Prevalence in Yemeni Hospitals (87-2)', 'funding_APP-2026-001040.pdf', 'funding_APP-2026-001040.pdf', 'application/pdf', 1802990, 'uploads/documents/funding_APP-2026-001040.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 87, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001040';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Antimicrobial Resistance Prevalence in Yemeni Hospitals (87-2)', 'budget_APP-2026-001040.xlsx', 'budget_APP-2026-001040.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 192206, 'uploads/documents/budget_APP-2026-001040.xlsx', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 87, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001040';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Antimicrobial Resistance Prevalence in Yemeni Hospitals (87-2) (موافقة)', 'ethics_decision_APP-2026-001040.pdf', 'ethics_decision_APP-2026-001040.pdf', 'application/pdf', 1901750, 'uploads/documents/ethics_decision_APP-2026-001040.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 87, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001040';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Antimicrobial Resistance Prevalence in Yemeni Hospitals (87-2)', 'certificate_APP-2026-001040.pdf', 'certificate_APP-2026-001040.pdf', 'application/pdf', 1951130, 'uploads/documents/certificate_APP-2026-001040.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 87, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001040';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Antimicrobial Resistance Prevalence in Yemeni Hospitals (87-2)', 'final_report_APP-2026-001040.pdf', 'final_report_APP-2026-001040.pdf', 'application/pdf', 2000510, 'uploads/documents/final_report_APP-2026-001040.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 87, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001040';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Antimicrobial Resistance Prevalence in Yemeni Hospitals (87-2)', 'data_collection_APP-2026-001040.xlsx', 'data_collection_APP-2026-001040.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 209982, 'uploads/documents/data_collection_APP-2026-001040.xlsx', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 87, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001040';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'منشور علمي - Antimicrobial Resistance Prevalence in Yemeni Hospitals (87-2)', 'publication_APP-2026-001040.pdf', 'publication_APP-2026-001040.pdf', 'application/pdf', 2099270, 'uploads/documents/publication_APP-2026-001040.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 87, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PUBLICATION'
AND a.application_number = 'APP-2026-001040';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Prevalence of Hepatitis B and C Among Blood Donors (87-3)', 'protocol_v1_APP-2026-001041.pdf', 'protocol_v1_APP-2026-001041.pdf', 'application/pdf', 1494365, 'uploads/documents/protocol_v1_APP-2026-001041.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 87, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001041';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Prevalence of Hepatitis B and C Among Blood Donors (87-3)', 'icf_ar_APP-2026-001041.pdf', 'icf_ar_APP-2026-001041.pdf', 'application/pdf', 1543745, 'uploads/documents/icf_ar_APP-2026-001041.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 87, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001041';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Prevalence of Hepatitis B and C Among Blood Donors (87-3)', 'icf_en_APP-2026-001041.pdf', 'icf_en_APP-2026-001041.pdf', 'application/pdf', 1593125, 'uploads/documents/icf_en_APP-2026-001041.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 87, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001041';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001041.pdf', 'cv_pi_APP-2026-001041.pdf', 'application/pdf', 1642505, 'uploads/documents/cv_pi_APP-2026-001041.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 87, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001041';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001041.pdf', 'cv_coi_APP-2026-001041.pdf', 'application/pdf', 1691885, 'uploads/documents/cv_coi_APP-2026-001041.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 87, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001041';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Prevalence of Hepatitis B and C Among Blood Donors (87-3)', 'pis_APP-2026-001041.pdf', 'pis_APP-2026-001041.pdf', 'application/pdf', 1741265, 'uploads/documents/pis_APP-2026-001041.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 87, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001041';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Prevalence of Hepatitis B and C Among Blood Donors (87-3)', 'irb_approval_APP-2026-001041.pdf', 'irb_approval_APP-2026-001041.pdf', 'application/pdf', 1790645, 'uploads/documents/irb_approval_APP-2026-001041.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 87, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001041';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Prevalence of Hepatitis B and C Among Blood Donors (87-3)', 'funding_APP-2026-001041.pdf', 'funding_APP-2026-001041.pdf', 'application/pdf', 1840025, 'uploads/documents/funding_APP-2026-001041.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 87, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001041';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Prevalence of Hepatitis B and C Among Blood Donors (87-3)', 'budget_APP-2026-001041.xlsx', 'budget_APP-2026-001041.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 195539, 'uploads/documents/budget_APP-2026-001041.xlsx', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 87, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001041';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Prevalence of Hepatitis B and C Among Blood Donors (87-3) (موافقة)', 'ethics_decision_APP-2026-001041.pdf', 'ethics_decision_APP-2026-001041.pdf', 'application/pdf', 1938785, 'uploads/documents/ethics_decision_APP-2026-001041.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 87, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001041';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Prevalence of Hepatitis B and C Among Blood Donors (87-3)', 'certificate_APP-2026-001041.pdf', 'certificate_APP-2026-001041.pdf', 'application/pdf', 1988165, 'uploads/documents/certificate_APP-2026-001041.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 87, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001041';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Prevalence of Hepatitis B and C Among Blood Donors (87-3)', 'final_report_APP-2026-001041.pdf', 'final_report_APP-2026-001041.pdf', 'application/pdf', 2037545, 'uploads/documents/final_report_APP-2026-001041.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 87, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001041';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Prevalence of Hepatitis B and C Among Blood Donors (87-3)', 'data_collection_APP-2026-001041.xlsx', 'data_collection_APP-2026-001041.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 213315, 'uploads/documents/data_collection_APP-2026-001041.xlsx', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 87, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001041';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Prevalence of Sickle Cell Disease Among Newborns in Aden (النسخة الأصلية)', 'protocol_v1_APP-2026-001042.pdf', 'protocol_v1_APP-2026-001042.pdf', 'application/pdf', 1531400, 'uploads/documents/protocol_v1_APP-2026-001042.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 87, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Prevalence of Sickle Cell Disease Among Newborns in Aden (النسخة النهائية)', 'protocol_v2_APP-2026-001042.pdf', 'protocol_v2_APP-2026-001042.pdf', 'application/pdf', 1580780, 'uploads/documents/protocol_v2_APP-2026-001042.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 87, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Prevalence of Sickle Cell Disease Among Newborns in Aden', 'icf_ar_APP-2026-001042.pdf', 'icf_ar_APP-2026-001042.pdf', 'application/pdf', 1630160, 'uploads/documents/icf_ar_APP-2026-001042.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 87, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Prevalence of Sickle Cell Disease Among Newborns in Aden', 'icf_en_APP-2026-001042.pdf', 'icf_en_APP-2026-001042.pdf', 'application/pdf', 1679540, 'uploads/documents/icf_en_APP-2026-001042.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 87, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Prevalence of Sickle Cell Disease Among Newborns in Aden (النسخة المعدلة)', 'icf_v2_APP-2026-001042.pdf', 'icf_v2_APP-2026-001042.pdf', 'application/pdf', 1728920, 'uploads/documents/icf_v2_APP-2026-001042.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 87, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001042.pdf', 'cv_pi_APP-2026-001042.pdf', 'application/pdf', 1778300, 'uploads/documents/cv_pi_APP-2026-001042.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 87, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001042.pdf', 'cv_coi_APP-2026-001042.pdf', 'application/pdf', 1827680, 'uploads/documents/cv_coi_APP-2026-001042.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 87, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Prevalence of Sickle Cell Disease Among Newborns in Aden', 'pis_APP-2026-001042.pdf', 'pis_APP-2026-001042.pdf', 'application/pdf', 1877060, 'uploads/documents/pis_APP-2026-001042.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 87, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Prevalence of Sickle Cell Disease Among Newborns in Aden', 'proposal_APP-2026-001042.pdf', 'proposal_APP-2026-001042.pdf', 'application/pdf', 1926440, 'uploads/documents/proposal_APP-2026-001042.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 87, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Prevalence of Sickle Cell Disease Among Newborns in Aden', 'irb_approval_APP-2026-001042.pdf', 'irb_approval_APP-2026-001042.pdf', 'application/pdf', 1975820, 'uploads/documents/irb_approval_APP-2026-001042.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 87, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Prevalence of Sickle Cell Disease Among Newborns in Aden', 'funding_APP-2026-001042.pdf', 'funding_APP-2026-001042.pdf', 'application/pdf', 2025200, 'uploads/documents/funding_APP-2026-001042.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 87, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Prevalence of Sickle Cell Disease Among Newborns in Aden', 'budget_APP-2026-001042.xlsx', 'budget_APP-2026-001042.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 212204, 'uploads/documents/budget_APP-2026-001042.xlsx', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 87, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Prevalence of Sickle Cell Disease Among Newborns in Aden (موافقة)', 'ethics_decision_APP-2026-001042.pdf', 'ethics_decision_APP-2026-001042.pdf', 'application/pdf', 2123960, 'uploads/documents/ethics_decision_APP-2026-001042.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 87, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'محضر اجتماع اللجنة - Prevalence of Sickle Cell Disease Among Newborns in Aden', 'minutes_APP-2026-001042.pdf', 'minutes_APP-2026-001042.pdf', 'application/pdf', 2173340, 'uploads/documents/minutes_APP-2026-001042.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 87, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'MEETING_MINUTES'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Prevalence of Sickle Cell Disease Among Newborns in Aden', 'certificate_APP-2026-001042.pdf', 'certificate_APP-2026-001042.pdf', 'application/pdf', 2222720, 'uploads/documents/certificate_APP-2026-001042.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 87, a.created_at + interval '113 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Prevalence of Sickle Cell Disease Among Newborns in Aden', 'final_report_APP-2026-001042.pdf', 'final_report_APP-2026-001042.pdf', 'application/pdf', 2272100, 'uploads/documents/final_report_APP-2026-001042.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 87, a.created_at + interval '121 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Prevalence of Sickle Cell Disease Among Newborns in Aden', 'data_collection_APP-2026-001042.xlsx', 'data_collection_APP-2026-001042.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 234424, 'uploads/documents/data_collection_APP-2026-001042.xlsx', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 87, a.created_at + interval '129 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'منشور علمي - Prevalence of Sickle Cell Disease Among Newborns in Aden', 'publication_APP-2026-001042.pdf', 'publication_APP-2026-001042.pdf', 'application/pdf', 2370860, 'uploads/documents/publication_APP-2026-001042.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 87, a.created_at + interval '137 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PUBLICATION'
AND a.application_number = 'APP-2026-001042';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (88-0)', 'protocol_v1_APP-2026-001043.pdf', 'protocol_v1_APP-2026-001043.pdf', 'application/pdf', 1568435, 'uploads/documents/protocol_v1_APP-2026-001043.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 88, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001043';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (88-0)', 'icf_ar_APP-2026-001043.pdf', 'icf_ar_APP-2026-001043.pdf', 'application/pdf', 1617815, 'uploads/documents/icf_ar_APP-2026-001043.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 88, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001043';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (88-0)', 'icf_en_APP-2026-001043.pdf', 'icf_en_APP-2026-001043.pdf', 'application/pdf', 1667195, 'uploads/documents/icf_en_APP-2026-001043.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 88, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001043';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001043.pdf', 'cv_pi_APP-2026-001043.pdf', 'application/pdf', 1716575, 'uploads/documents/cv_pi_APP-2026-001043.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 88, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001043';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001043.pdf', 'cv_coi_APP-2026-001043.pdf', 'application/pdf', 1765955, 'uploads/documents/cv_coi_APP-2026-001043.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 88, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001043';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (88-0)', 'pis_APP-2026-001043.pdf', 'pis_APP-2026-001043.pdf', 'application/pdf', 1815335, 'uploads/documents/pis_APP-2026-001043.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 88, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001043';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (88-0)', 'irb_approval_APP-2026-001043.pdf', 'irb_approval_APP-2026-001043.pdf', 'application/pdf', 1864715, 'uploads/documents/irb_approval_APP-2026-001043.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 88, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001043';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (88-0)', 'funding_APP-2026-001043.pdf', 'funding_APP-2026-001043.pdf', 'application/pdf', 1914095, 'uploads/documents/funding_APP-2026-001043.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 88, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001043';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (88-0)', 'budget_APP-2026-001043.xlsx', 'budget_APP-2026-001043.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 202205, 'uploads/documents/budget_APP-2026-001043.xlsx', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 88, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001043';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (88-0) (موافقة)', 'ethics_decision_APP-2026-001043.pdf', 'ethics_decision_APP-2026-001043.pdf', 'application/pdf', 2012855, 'uploads/documents/ethics_decision_APP-2026-001043.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 88, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001043';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (88-0)', 'certificate_APP-2026-001043.pdf', 'certificate_APP-2026-001043.pdf', 'application/pdf', 2062235, 'uploads/documents/certificate_APP-2026-001043.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 88, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001043';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (88-0)', 'data_collection_APP-2026-001043.xlsx', 'data_collection_APP-2026-001043.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 215537, 'uploads/documents/data_collection_APP-2026-001043.xlsx', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 88, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001043';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Effectiveness of Radiotherapy for Cervical Cancer in Yemen (88-1)', 'protocol_v1_APP-2026-001044.pdf', 'protocol_v1_APP-2026-001044.pdf', 'application/pdf', 1605470, 'uploads/documents/protocol_v1_APP-2026-001044.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 88, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001044';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Effectiveness of Radiotherapy for Cervical Cancer in Yemen (88-1)', 'icf_APP-2026-001044.pdf', 'icf_APP-2026-001044.pdf', 'application/pdf', 1654850, 'uploads/documents/icf_APP-2026-001044.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 88, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001044';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001044.pdf', 'cv_pi_APP-2026-001044.pdf', 'application/pdf', 1704230, 'uploads/documents/cv_pi_APP-2026-001044.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 88, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001044';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Effectiveness of Radiotherapy for Cervical Cancer in Yemen (88-1)', 'pis_APP-2026-001044.pdf', 'pis_APP-2026-001044.pdf', 'application/pdf', 1753610, 'uploads/documents/pis_APP-2026-001044.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 88, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001044';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Effectiveness of Radiotherapy for Cervical Cancer in Yemen (88-1)', 'proposal_APP-2026-001044.pdf', 'proposal_APP-2026-001044.pdf', 'application/pdf', 1802990, 'uploads/documents/proposal_APP-2026-001044.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 88, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2026-001044';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب سحب الطلب - Effectiveness of Radiotherapy for Cervical Cancer in Yemen (88-1)', 'withdrawal_APP-2026-001044.pdf', 'withdrawal_APP-2026-001044.pdf', 'application/pdf', 1852370, 'uploads/documents/withdrawal_APP-2026-001044.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 88, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'OTHER'
AND a.application_number = 'APP-2026-001044';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Economic Burden of Thalassemia on Yemeni Families (88-2)', 'protocol_v1_APP-2026-001045.pdf', 'protocol_v1_APP-2026-001045.pdf', 'application/pdf', 1642505, 'uploads/documents/protocol_v1_APP-2026-001045.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 88, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001045';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Economic Burden of Thalassemia on Yemeni Families (88-2)', 'icf_ar_APP-2026-001045.pdf', 'icf_ar_APP-2026-001045.pdf', 'application/pdf', 1691885, 'uploads/documents/icf_ar_APP-2026-001045.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 88, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001045';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Economic Burden of Thalassemia on Yemeni Families (88-2)', 'icf_en_APP-2026-001045.pdf', 'icf_en_APP-2026-001045.pdf', 'application/pdf', 1741265, 'uploads/documents/icf_en_APP-2026-001045.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 88, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001045';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001045.pdf', 'cv_pi_APP-2026-001045.pdf', 'application/pdf', 1790645, 'uploads/documents/cv_pi_APP-2026-001045.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 88, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001045';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001045.pdf', 'cv_coi_APP-2026-001045.pdf', 'application/pdf', 1840025, 'uploads/documents/cv_coi_APP-2026-001045.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 88, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001045';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Economic Burden of Thalassemia on Yemeni Families (88-2)', 'pis_APP-2026-001045.pdf', 'pis_APP-2026-001045.pdf', 'application/pdf', 1889405, 'uploads/documents/pis_APP-2026-001045.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 88, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001045';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Economic Burden of Thalassemia on Yemeni Families (88-2)', 'irb_approval_APP-2026-001045.pdf', 'irb_approval_APP-2026-001045.pdf', 'application/pdf', 1938785, 'uploads/documents/irb_approval_APP-2026-001045.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 88, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001045';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Economic Burden of Thalassemia on Yemeni Families (88-2)', 'funding_APP-2026-001045.pdf', 'funding_APP-2026-001045.pdf', 'application/pdf', 1988165, 'uploads/documents/funding_APP-2026-001045.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 88, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001045';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Economic Burden of Thalassemia on Yemeni Families (88-2)', 'budget_APP-2026-001045.xlsx', 'budget_APP-2026-001045.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 208871, 'uploads/documents/budget_APP-2026-001045.xlsx', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 88, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001045';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Economic Burden of Thalassemia on Yemeni Families (88-2) (موافقة)', 'ethics_decision_APP-2026-001045.pdf', 'ethics_decision_APP-2026-001045.pdf', 'application/pdf', 2086925, 'uploads/documents/ethics_decision_APP-2026-001045.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 88, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001045';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Economic Burden of Thalassemia on Yemeni Families (88-2)', 'certificate_APP-2026-001045.pdf', 'certificate_APP-2026-001045.pdf', 'application/pdf', 2136305, 'uploads/documents/certificate_APP-2026-001045.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 88, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001045';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Economic Burden of Thalassemia on Yemeni Families (88-2)', 'data_collection_APP-2026-001045.xlsx', 'data_collection_APP-2026-001045.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 222203, 'uploads/documents/data_collection_APP-2026-001045.xlsx', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 88, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001045';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Injury Patterns from Road Traffic Accidents in Sana''a (88-3)', 'protocol_v1_APP-2026-001046.pdf', 'protocol_v1_APP-2026-001046.pdf', 'application/pdf', 1679540, 'uploads/documents/protocol_v1_APP-2026-001046.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 88, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001046';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Injury Patterns from Road Traffic Accidents in Sana''a (88-3)', 'icf_ar_APP-2026-001046.pdf', 'icf_ar_APP-2026-001046.pdf', 'application/pdf', 1728920, 'uploads/documents/icf_ar_APP-2026-001046.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 88, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001046';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Injury Patterns from Road Traffic Accidents in Sana''a (88-3)', 'icf_en_APP-2026-001046.pdf', 'icf_en_APP-2026-001046.pdf', 'application/pdf', 1778300, 'uploads/documents/icf_en_APP-2026-001046.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 88, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001046';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001046.pdf', 'cv_pi_APP-2026-001046.pdf', 'application/pdf', 1827680, 'uploads/documents/cv_pi_APP-2026-001046.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 88, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001046';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001046.pdf', 'cv_coi_APP-2026-001046.pdf', 'application/pdf', 1877060, 'uploads/documents/cv_coi_APP-2026-001046.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 88, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001046';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Injury Patterns from Road Traffic Accidents in Sana''a (88-3)', 'pis_APP-2026-001046.pdf', 'pis_APP-2026-001046.pdf', 'application/pdf', 1926440, 'uploads/documents/pis_APP-2026-001046.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 88, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001046';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Injury Patterns from Road Traffic Accidents in Sana''a (88-3)', 'proposal_APP-2026-001046.pdf', 'proposal_APP-2026-001046.pdf', 'application/pdf', 1975820, 'uploads/documents/proposal_APP-2026-001046.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 88, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2026-001046';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Injury Patterns from Road Traffic Accidents in Sana''a (88-3)', 'irb_approval_APP-2026-001046.pdf', 'irb_approval_APP-2026-001046.pdf', 'application/pdf', 2025200, 'uploads/documents/irb_approval_APP-2026-001046.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 88, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001046';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Injury Patterns from Road Traffic Accidents in Sana''a (88-3)', 'funding_APP-2026-001046.pdf', 'funding_APP-2026-001046.pdf', 'application/pdf', 2074580, 'uploads/documents/funding_APP-2026-001046.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 88, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001046';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Injury Patterns from Road Traffic Accidents in Sana''a (88-3)', 'budget_APP-2026-001046.xlsx', 'budget_APP-2026-001046.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 216648, 'uploads/documents/budget_APP-2026-001046.xlsx', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 88, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001046';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'استبيان - Injury Patterns from Road Traffic Accidents in Sana''a (88-3)', 'questionnaire_APP-2026-001046.pdf', 'questionnaire_APP-2026-001046.pdf', 'application/pdf', 2173340, 'uploads/documents/questionnaire_APP-2026-001046.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 88, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'QUESTIONNAIRE'
AND a.application_number = 'APP-2026-001046';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Injury Patterns from Road Traffic Accidents in Sana''a (88-3)', 'data_collection_APP-2026-001046.xlsx', 'data_collection_APP-2026-001046.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 225536, 'uploads/documents/data_collection_APP-2026-001046.xlsx', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 88, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001046';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Blood Transfusion Safety Assessment in Yemeni Blood Banks', 'protocol_v1_APP-2026-001047.pdf', 'protocol_v1_APP-2026-001047.pdf', 'application/pdf', 1716575, 'uploads/documents/protocol_v1_APP-2026-001047.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 89, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001047';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Blood Transfusion Safety Assessment in Yemeni Blood Banks (النسخة المعدلة)', 'protocol_v2_APP-2026-001047.pdf', 'protocol_v2_APP-2026-001047.pdf', 'application/pdf', 1765955, 'uploads/documents/protocol_v2_APP-2026-001047.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 89, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001047';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Blood Transfusion Safety Assessment in Yemeni Blood Banks', 'icf_ar_APP-2026-001047.pdf', 'icf_ar_APP-2026-001047.pdf', 'application/pdf', 1815335, 'uploads/documents/icf_ar_APP-2026-001047.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 89, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001047';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Blood Transfusion Safety Assessment in Yemeni Blood Banks', 'icf_en_APP-2026-001047.pdf', 'icf_en_APP-2026-001047.pdf', 'application/pdf', 1864715, 'uploads/documents/icf_en_APP-2026-001047.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 89, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001047';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001047.pdf', 'cv_pi_APP-2026-001047.pdf', 'application/pdf', 1914095, 'uploads/documents/cv_pi_APP-2026-001047.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 89, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001047';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001047.pdf', 'cv_coi_APP-2026-001047.pdf', 'application/pdf', 1963475, 'uploads/documents/cv_coi_APP-2026-001047.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 89, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001047';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Blood Transfusion Safety Assessment in Yemeni Blood Banks', 'pis_APP-2026-001047.pdf', 'pis_APP-2026-001047.pdf', 'application/pdf', 2012855, 'uploads/documents/pis_APP-2026-001047.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 89, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001047';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Blood Transfusion Safety Assessment in Yemeni Blood Banks', 'irb_approval_APP-2026-001047.pdf', 'irb_approval_APP-2026-001047.pdf', 'application/pdf', 2062235, 'uploads/documents/irb_approval_APP-2026-001047.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 89, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001047';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Blood Transfusion Safety Assessment in Yemeni Blood Banks', 'funding_APP-2026-001047.pdf', 'funding_APP-2026-001047.pdf', 'application/pdf', 2111615, 'uploads/documents/funding_APP-2026-001047.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 89, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001047';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Blood Transfusion Safety Assessment in Yemeni Blood Banks', 'budget_APP-2026-001047.xlsx', 'budget_APP-2026-001047.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 219981, 'uploads/documents/budget_APP-2026-001047.xlsx', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 89, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001047';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Blood Transfusion Safety Assessment in Yemeni Blood Banks (موافقة)', 'ethics_decision_APP-2026-001047.pdf', 'ethics_decision_APP-2026-001047.pdf', 'application/pdf', 2210375, 'uploads/documents/ethics_decision_APP-2026-001047.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 89, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001047';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Blood Transfusion Safety Assessment in Yemeni Blood Banks', 'certificate_APP-2026-001047.pdf', 'certificate_APP-2026-001047.pdf', 'application/pdf', 2259755, 'uploads/documents/certificate_APP-2026-001047.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 89, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001047';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Blood Transfusion Safety Assessment in Yemeni Blood Banks', 'data_collection_APP-2026-001047.xlsx', 'data_collection_APP-2026-001047.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 233313, 'uploads/documents/data_collection_APP-2026-001047.xlsx', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 89, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001047';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates (89-1) (مسودة)', 'protocol_draft_APP-2026-001048.pdf', 'protocol_draft_APP-2026-001048.pdf', 'application/pdf', 1753610, 'uploads/documents/protocol_draft_APP-2026-001048.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 89, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001048';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates (89-1) (مسودة)', 'icf_draft_APP-2026-001048.pdf', 'icf_draft_APP-2026-001048.pdf', 'application/pdf', 1802990, 'uploads/documents/icf_draft_APP-2026-001048.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 89, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001048';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001048.pdf', 'cv_pi_APP-2026-001048.pdf', 'application/pdf', 1852370, 'uploads/documents/cv_pi_APP-2026-001048.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 89, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001048';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Assessment of Emergency Services in Yemeni General Hospitals (89-2)', 'protocol_v1_APP-2026-001049.pdf', 'protocol_v1_APP-2026-001049.pdf', 'application/pdf', 1790645, 'uploads/documents/protocol_v1_APP-2026-001049.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 89, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001049';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Assessment of Emergency Services in Yemeni General Hospitals (89-2)', 'icf_ar_APP-2026-001049.pdf', 'icf_ar_APP-2026-001049.pdf', 'application/pdf', 1840025, 'uploads/documents/icf_ar_APP-2026-001049.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 89, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001049';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Assessment of Emergency Services in Yemeni General Hospitals (89-2)', 'icf_en_APP-2026-001049.pdf', 'icf_en_APP-2026-001049.pdf', 'application/pdf', 1889405, 'uploads/documents/icf_en_APP-2026-001049.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 89, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001049';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001049.pdf', 'cv_pi_APP-2026-001049.pdf', 'application/pdf', 1938785, 'uploads/documents/cv_pi_APP-2026-001049.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 89, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001049';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001049.pdf', 'cv_coi_APP-2026-001049.pdf', 'application/pdf', 1988165, 'uploads/documents/cv_coi_APP-2026-001049.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 89, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001049';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Assessment of Emergency Services in Yemeni General Hospitals (89-2)', 'pis_APP-2026-001049.pdf', 'pis_APP-2026-001049.pdf', 'application/pdf', 2037545, 'uploads/documents/pis_APP-2026-001049.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 89, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001049';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Assessment of Emergency Services in Yemeni General Hospitals (89-2)', 'proposal_APP-2026-001049.pdf', 'proposal_APP-2026-001049.pdf', 'application/pdf', 2086925, 'uploads/documents/proposal_APP-2026-001049.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 89, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2026-001049';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Assessment of Emergency Services in Yemeni General Hospitals (89-2)', 'irb_approval_APP-2026-001049.pdf', 'irb_approval_APP-2026-001049.pdf', 'application/pdf', 2136305, 'uploads/documents/irb_approval_APP-2026-001049.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 89, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001049';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Assessment of Emergency Services in Yemeni General Hospitals (89-2)', 'funding_APP-2026-001049.pdf', 'funding_APP-2026-001049.pdf', 'application/pdf', 2185685, 'uploads/documents/funding_APP-2026-001049.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 89, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001049';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Assessment of Emergency Services in Yemeni General Hospitals (89-2)', 'budget_APP-2026-001049.xlsx', 'budget_APP-2026-001049.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 226647, 'uploads/documents/budget_APP-2026-001049.xlsx', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 89, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001049';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج تقرير الحالة - Assessment of Emergency Services in Yemeni General Hospitals (89-2)', 'crf_APP-2026-001049.pdf', 'crf_APP-2026-001049.pdf', 'application/pdf', 2284445, 'uploads/documents/crf_APP-2026-001049.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 89, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CRF'
AND a.application_number = 'APP-2026-001049';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Assessment of Emergency Services in Yemeni General Hospitals (89-2)', 'data_collection_APP-2026-001049.xlsx', 'data_collection_APP-2026-001049.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 235535, 'uploads/documents/data_collection_APP-2026-001049.xlsx', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 89, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001049';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Effectiveness of CPR Protocols in Emergency Departments (مسودة)', 'protocol_draft_APP-2026-001050.pdf', 'protocol_draft_APP-2026-001050.pdf', 'application/pdf', 1827680, 'uploads/documents/protocol_draft_APP-2026-001050.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 90, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001050';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Effectiveness of CPR Protocols in Emergency Departments (مسودة)', 'icf_draft_APP-2026-001050.pdf', 'icf_draft_APP-2026-001050.pdf', 'application/pdf', 1877060, 'uploads/documents/icf_draft_APP-2026-001050.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 90, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001050';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Seroprevalence of SARS-CoV-2 Among Healthcare Workers in Yemen (90-1)', 'protocol_v1_APP-2026-001051.pdf', 'protocol_v1_APP-2026-001051.pdf', 'application/pdf', 1864715, 'uploads/documents/protocol_v1_APP-2026-001051.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 90, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001051';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Seroprevalence of SARS-CoV-2 Among Healthcare Workers in Yemen (90-1)', 'icf_ar_APP-2026-001051.pdf', 'icf_ar_APP-2026-001051.pdf', 'application/pdf', 1914095, 'uploads/documents/icf_ar_APP-2026-001051.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 90, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001051';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Seroprevalence of SARS-CoV-2 Among Healthcare Workers in Yemen (90-1)', 'icf_en_APP-2026-001051.pdf', 'icf_en_APP-2026-001051.pdf', 'application/pdf', 1963475, 'uploads/documents/icf_en_APP-2026-001051.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 90, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001051';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001051.pdf', 'cv_pi_APP-2026-001051.pdf', 'application/pdf', 2012855, 'uploads/documents/cv_pi_APP-2026-001051.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 90, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001051';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001051.pdf', 'cv_coi_APP-2026-001051.pdf', 'application/pdf', 2062235, 'uploads/documents/cv_coi_APP-2026-001051.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 90, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001051';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Seroprevalence of SARS-CoV-2 Among Healthcare Workers in Yemen (90-1)', 'pis_APP-2026-001051.pdf', 'pis_APP-2026-001051.pdf', 'application/pdf', 2111615, 'uploads/documents/pis_APP-2026-001051.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 90, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001051';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Seroprevalence of SARS-CoV-2 Among Healthcare Workers in Yemen (90-1)', 'irb_approval_APP-2026-001051.pdf', 'irb_approval_APP-2026-001051.pdf', 'application/pdf', 2160995, 'uploads/documents/irb_approval_APP-2026-001051.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 90, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001051';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Seroprevalence of SARS-CoV-2 Among Healthcare Workers in Yemen (90-1)', 'funding_APP-2026-001051.pdf', 'funding_APP-2026-001051.pdf', 'application/pdf', 2210375, 'uploads/documents/funding_APP-2026-001051.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 90, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001051';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Seroprevalence of SARS-CoV-2 Among Healthcare Workers in Yemen (90-1)', 'budget_APP-2026-001051.xlsx', 'budget_APP-2026-001051.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 228869, 'uploads/documents/budget_APP-2026-001051.xlsx', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 90, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001051';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Seroprevalence of SARS-CoV-2 Among Healthcare Workers in Yemen (90-1) (موافقة)', 'ethics_decision_APP-2026-001051.pdf', 'ethics_decision_APP-2026-001051.pdf', 'application/pdf', 2309135, 'uploads/documents/ethics_decision_APP-2026-001051.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 90, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001051';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Seroprevalence of SARS-CoV-2 Among Healthcare Workers in Yemen (90-1)', 'certificate_APP-2026-001051.pdf', 'certificate_APP-2026-001051.pdf', 'application/pdf', 2358515, 'uploads/documents/certificate_APP-2026-001051.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 90, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001051';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Seroprevalence of SARS-CoV-2 Among Healthcare Workers in Yemen (90-1)', 'data_collection_APP-2026-001051.xlsx', 'data_collection_APP-2026-001051.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 242201, 'uploads/documents/data_collection_APP-2026-001051.xlsx', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 90, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001051';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Burden of Non-Communicable Diseases in Urban and Rural Areas (90-2)', 'protocol_v1_APP-2026-001052.pdf', 'protocol_v1_APP-2026-001052.pdf', 'application/pdf', 1901750, 'uploads/documents/protocol_v1_APP-2026-001052.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 90, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001052';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Burden of Non-Communicable Diseases in Urban and Rural Areas (90-2)', 'icf_ar_APP-2026-001052.pdf', 'icf_ar_APP-2026-001052.pdf', 'application/pdf', 1951130, 'uploads/documents/icf_ar_APP-2026-001052.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 90, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001052';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Burden of Non-Communicable Diseases in Urban and Rural Areas (90-2)', 'icf_en_APP-2026-001052.pdf', 'icf_en_APP-2026-001052.pdf', 'application/pdf', 2000510, 'uploads/documents/icf_en_APP-2026-001052.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 90, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001052';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001052.pdf', 'cv_pi_APP-2026-001052.pdf', 'application/pdf', 2049890, 'uploads/documents/cv_pi_APP-2026-001052.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 90, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001052';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001052.pdf', 'cv_coi_APP-2026-001052.pdf', 'application/pdf', 2099270, 'uploads/documents/cv_coi_APP-2026-001052.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 90, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001052';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Burden of Non-Communicable Diseases in Urban and Rural Areas (90-2)', 'pis_APP-2026-001052.pdf', 'pis_APP-2026-001052.pdf', 'application/pdf', 2148650, 'uploads/documents/pis_APP-2026-001052.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 90, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001052';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Burden of Non-Communicable Diseases in Urban and Rural Areas (90-2)', 'proposal_APP-2026-001052.pdf', 'proposal_APP-2026-001052.pdf', 'application/pdf', 2198030, 'uploads/documents/proposal_APP-2026-001052.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 90, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2026-001052';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Burden of Non-Communicable Diseases in Urban and Rural Areas (90-2)', 'irb_approval_APP-2026-001052.pdf', 'irb_approval_APP-2026-001052.pdf', 'application/pdf', 2247410, 'uploads/documents/irb_approval_APP-2026-001052.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 90, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001052';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Burden of Non-Communicable Diseases in Urban and Rural Areas (90-2)', 'funding_APP-2026-001052.pdf', 'funding_APP-2026-001052.pdf', 'application/pdf', 2296790, 'uploads/documents/funding_APP-2026-001052.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 90, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001052';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Burden of Non-Communicable Diseases in Urban and Rural Areas (90-2)', 'budget_APP-2026-001052.xlsx', 'budget_APP-2026-001052.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 236646, 'uploads/documents/budget_APP-2026-001052.xlsx', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 90, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001052';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الإجراءات التشغيلية القياسية - Burden of Non-Communicable Diseases in Urban and Rural Areas (90-2)', 'sop_APP-2026-001052.pdf', 'sop_APP-2026-001052.pdf', 'application/pdf', 2395550, 'uploads/documents/sop_APP-2026-001052.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 90, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'SOP'
AND a.application_number = 'APP-2026-001052';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'استبيان - Burden of Non-Communicable Diseases in Urban and Rural Areas (90-2)', 'questionnaire_APP-2026-001052.pdf', 'questionnaire_APP-2026-001052.pdf', 'application/pdf', 2444930, 'uploads/documents/questionnaire_APP-2026-001052.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 90, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'QUESTIONNAIRE'
AND a.application_number = 'APP-2026-001052';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Burden of Non-Communicable Diseases in Urban and Rural Areas (90-2)', 'data_collection_APP-2026-001052.xlsx', 'data_collection_APP-2026-001052.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 249978, 'uploads/documents/data_collection_APP-2026-001052.xlsx', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 90, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001052';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Assessment of Emergency Services in Yemeni General Hospitals (90-3)', 'protocol_v1_APP-2026-001053.pdf', 'protocol_v1_APP-2026-001053.pdf', 'application/pdf', 1938785, 'uploads/documents/protocol_v1_APP-2026-001053.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 90, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001053';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Assessment of Emergency Services in Yemeni General Hospitals (90-3) (النسخة المعدلة)', 'protocol_v2_APP-2026-001053.pdf', 'protocol_v2_APP-2026-001053.pdf', 'application/pdf', 1988165, 'uploads/documents/protocol_v2_APP-2026-001053.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 90, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001053';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Assessment of Emergency Services in Yemeni General Hospitals (90-3)', 'icf_ar_APP-2026-001053.pdf', 'icf_ar_APP-2026-001053.pdf', 'application/pdf', 2037545, 'uploads/documents/icf_ar_APP-2026-001053.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 90, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001053';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Assessment of Emergency Services in Yemeni General Hospitals (90-3)', 'icf_en_APP-2026-001053.pdf', 'icf_en_APP-2026-001053.pdf', 'application/pdf', 2086925, 'uploads/documents/icf_en_APP-2026-001053.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 90, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001053';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001053.pdf', 'cv_pi_APP-2026-001053.pdf', 'application/pdf', 2136305, 'uploads/documents/cv_pi_APP-2026-001053.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 90, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001053';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001053.pdf', 'cv_coi_APP-2026-001053.pdf', 'application/pdf', 2185685, 'uploads/documents/cv_coi_APP-2026-001053.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 90, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001053';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Assessment of Emergency Services in Yemeni General Hospitals (90-3)', 'pis_APP-2026-001053.pdf', 'pis_APP-2026-001053.pdf', 'application/pdf', 2235065, 'uploads/documents/pis_APP-2026-001053.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 90, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001053';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Assessment of Emergency Services in Yemeni General Hospitals (90-3)', 'irb_approval_APP-2026-001053.pdf', 'irb_approval_APP-2026-001053.pdf', 'application/pdf', 2284445, 'uploads/documents/irb_approval_APP-2026-001053.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 90, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001053';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Assessment of Emergency Services in Yemeni General Hospitals (90-3)', 'funding_APP-2026-001053.pdf', 'funding_APP-2026-001053.pdf', 'application/pdf', 2333825, 'uploads/documents/funding_APP-2026-001053.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 90, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001053';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Assessment of Emergency Services in Yemeni General Hospitals (90-3)', 'budget_APP-2026-001053.xlsx', 'budget_APP-2026-001053.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 239979, 'uploads/documents/budget_APP-2026-001053.xlsx', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 90, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001053';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Assessment of Emergency Services in Yemeni General Hospitals (90-3) (موافقة)', 'ethics_decision_APP-2026-001053.pdf', 'ethics_decision_APP-2026-001053.pdf', 'application/pdf', 2432585, 'uploads/documents/ethics_decision_APP-2026-001053.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 90, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001053';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Assessment of Emergency Services in Yemeni General Hospitals (90-3)', 'certificate_APP-2026-001053.pdf', 'certificate_APP-2026-001053.pdf', 'application/pdf', 2481965, 'uploads/documents/certificate_APP-2026-001053.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 90, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001053';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Assessment of Emergency Services in Yemeni General Hospitals (90-3)', 'data_collection_APP-2026-001053.xlsx', 'data_collection_APP-2026-001053.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 253311, 'uploads/documents/data_collection_APP-2026-001053.xlsx', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 90, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001053';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Assessment of Antenatal Care Services in Primary Health Centers', 'protocol_v1_APP-2026-001054.pdf', 'protocol_v1_APP-2026-001054.pdf', 'application/pdf', 1975820, 'uploads/documents/protocol_v1_APP-2026-001054.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 90, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001054';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Assessment of Antenatal Care Services in Primary Health Centers (النسخة المعدلة)', 'protocol_v2_APP-2026-001054.pdf', 'protocol_v2_APP-2026-001054.pdf', 'application/pdf', 2025200, 'uploads/documents/protocol_v2_APP-2026-001054.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 90, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001054';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Assessment of Antenatal Care Services in Primary Health Centers', 'icf_ar_APP-2026-001054.pdf', 'icf_ar_APP-2026-001054.pdf', 'application/pdf', 2074580, 'uploads/documents/icf_ar_APP-2026-001054.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 90, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001054';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Assessment of Antenatal Care Services in Primary Health Centers', 'icf_en_APP-2026-001054.pdf', 'icf_en_APP-2026-001054.pdf', 'application/pdf', 2123960, 'uploads/documents/icf_en_APP-2026-001054.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 90, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001054';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001054.pdf', 'cv_pi_APP-2026-001054.pdf', 'application/pdf', 2173340, 'uploads/documents/cv_pi_APP-2026-001054.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 90, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001054';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001054.pdf', 'cv_coi_APP-2026-001054.pdf', 'application/pdf', 2222720, 'uploads/documents/cv_coi_APP-2026-001054.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 90, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001054';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Assessment of Antenatal Care Services in Primary Health Centers', 'pis_APP-2026-001054.pdf', 'pis_APP-2026-001054.pdf', 'application/pdf', 2272100, 'uploads/documents/pis_APP-2026-001054.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 90, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001054';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Assessment of Antenatal Care Services in Primary Health Centers', 'irb_approval_APP-2026-001054.pdf', 'irb_approval_APP-2026-001054.pdf', 'application/pdf', 2321480, 'uploads/documents/irb_approval_APP-2026-001054.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 90, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001054';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Assessment of Antenatal Care Services in Primary Health Centers', 'funding_APP-2026-001054.pdf', 'funding_APP-2026-001054.pdf', 'application/pdf', 2370860, 'uploads/documents/funding_APP-2026-001054.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 90, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001054';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Assessment of Antenatal Care Services in Primary Health Centers', 'budget_APP-2026-001054.xlsx', 'budget_APP-2026-001054.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 243312, 'uploads/documents/budget_APP-2026-001054.xlsx', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 90, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001054';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Assessment of Antenatal Care Services in Primary Health Centers (موافقة)', 'ethics_decision_APP-2026-001054.pdf', 'ethics_decision_APP-2026-001054.pdf', 'application/pdf', 2469620, 'uploads/documents/ethics_decision_APP-2026-001054.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 90, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001054';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Assessment of Antenatal Care Services in Primary Health Centers', 'certificate_APP-2026-001054.pdf', 'certificate_APP-2026-001054.pdf', 'application/pdf', 2519000, 'uploads/documents/certificate_APP-2026-001054.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 90, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001054';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Assessment of Antenatal Care Services in Primary Health Centers', 'final_report_APP-2026-001054.pdf', 'final_report_APP-2026-001054.pdf', 'application/pdf', 2568380, 'uploads/documents/final_report_APP-2026-001054.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 90, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001054';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Assessment of Antenatal Care Services in Primary Health Centers', 'data_collection_APP-2026-001054.xlsx', 'data_collection_APP-2026-001054.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 261088, 'uploads/documents/data_collection_APP-2026-001054.xlsx', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 90, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001054';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'منشور علمي - Assessment of Antenatal Care Services in Primary Health Centers', 'publication_APP-2026-001054.pdf', 'publication_APP-2026-001054.pdf', 'application/pdf', 2667140, 'uploads/documents/publication_APP-2026-001054.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 90, a.created_at + interval '113 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PUBLICATION'
AND a.application_number = 'APP-2026-001054';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Genetic Factors Associated with Type 1 Diabetes Mellitus', 'protocol_v1_APP-2026-001055.pdf', 'protocol_v1_APP-2026-001055.pdf', 'application/pdf', 2012855, 'uploads/documents/protocol_v1_APP-2026-001055.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 91, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001055';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Genetic Factors Associated with Type 1 Diabetes Mellitus', 'icf_ar_APP-2026-001055.pdf', 'icf_ar_APP-2026-001055.pdf', 'application/pdf', 2062235, 'uploads/documents/icf_ar_APP-2026-001055.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 91, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001055';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Genetic Factors Associated with Type 1 Diabetes Mellitus', 'icf_en_APP-2026-001055.pdf', 'icf_en_APP-2026-001055.pdf', 'application/pdf', 2111615, 'uploads/documents/icf_en_APP-2026-001055.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 91, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001055';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001055.pdf', 'cv_pi_APP-2026-001055.pdf', 'application/pdf', 2160995, 'uploads/documents/cv_pi_APP-2026-001055.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 91, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001055';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001055.pdf', 'cv_coi_APP-2026-001055.pdf', 'application/pdf', 2210375, 'uploads/documents/cv_coi_APP-2026-001055.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 91, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001055';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Genetic Factors Associated with Type 1 Diabetes Mellitus', 'pis_APP-2026-001055.pdf', 'pis_APP-2026-001055.pdf', 'application/pdf', 2259755, 'uploads/documents/pis_APP-2026-001055.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 91, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001055';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Genetic Factors Associated with Type 1 Diabetes Mellitus', 'proposal_APP-2026-001055.pdf', 'proposal_APP-2026-001055.pdf', 'application/pdf', 2309135, 'uploads/documents/proposal_APP-2026-001055.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 91, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2026-001055';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Genetic Factors Associated with Type 1 Diabetes Mellitus', 'irb_approval_APP-2026-001055.pdf', 'irb_approval_APP-2026-001055.pdf', 'application/pdf', 2358515, 'uploads/documents/irb_approval_APP-2026-001055.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 91, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001055';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Genetic Factors Associated with Type 1 Diabetes Mellitus', 'funding_APP-2026-001055.pdf', 'funding_APP-2026-001055.pdf', 'application/pdf', 2407895, 'uploads/documents/funding_APP-2026-001055.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 91, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001055';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Genetic Factors Associated with Type 1 Diabetes Mellitus', 'budget_APP-2026-001055.xlsx', 'budget_APP-2026-001055.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 246645, 'uploads/documents/budget_APP-2026-001055.xlsx', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 91, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001055';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج تقرير الحالة - Genetic Factors Associated with Type 1 Diabetes Mellitus', 'crf_APP-2026-001055.pdf', 'crf_APP-2026-001055.pdf', 'application/pdf', 2506655, 'uploads/documents/crf_APP-2026-001055.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 91, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CRF'
AND a.application_number = 'APP-2026-001055';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Genetic Factors Associated with Type 1 Diabetes Mellitus', 'data_collection_APP-2026-001055.xlsx', 'data_collection_APP-2026-001055.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 255533, 'uploads/documents/data_collection_APP-2026-001055.xlsx', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 91, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001055';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (91-1)', 'protocol_v1_APP-2026-001056.pdf', 'protocol_v1_APP-2026-001056.pdf', 'application/pdf', 2049890, 'uploads/documents/protocol_v1_APP-2026-001056.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 91, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001056';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (91-1)', 'icf_APP-2026-001056.pdf', 'icf_APP-2026-001056.pdf', 'application/pdf', 2099270, 'uploads/documents/icf_APP-2026-001056.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 91, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001056';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001056.pdf', 'cv_pi_APP-2026-001056.pdf', 'application/pdf', 2148650, 'uploads/documents/cv_pi_APP-2026-001056.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 91, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001056';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (91-1)', 'pis_APP-2026-001056.pdf', 'pis_APP-2026-001056.pdf', 'application/pdf', 2198030, 'uploads/documents/pis_APP-2026-001056.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 91, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001056';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (91-1) (رفض)', 'rejection_APP-2026-001056.pdf', 'rejection_APP-2026-001056.pdf', 'application/pdf', 2247410, 'uploads/documents/rejection_APP-2026-001056.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 91, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001056';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Effectiveness of Radiotherapy for Cervical Cancer in Yemen (91-2)', 'protocol_v1_APP-2026-001057.pdf', 'protocol_v1_APP-2026-001057.pdf', 'application/pdf', 2086925, 'uploads/documents/protocol_v1_APP-2026-001057.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 91, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001057';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Effectiveness of Radiotherapy for Cervical Cancer in Yemen (91-2)', 'icf_APP-2026-001057.pdf', 'icf_APP-2026-001057.pdf', 'application/pdf', 2136305, 'uploads/documents/icf_APP-2026-001057.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 91, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001057';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001057.pdf', 'cv_pi_APP-2026-001057.pdf', 'application/pdf', 2185685, 'uploads/documents/cv_pi_APP-2026-001057.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 91, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001057';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Effectiveness of Radiotherapy for Cervical Cancer in Yemen (91-2)', 'pis_APP-2026-001057.pdf', 'pis_APP-2026-001057.pdf', 'application/pdf', 2235065, 'uploads/documents/pis_APP-2026-001057.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 91, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001057';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Effectiveness of Radiotherapy for Cervical Cancer in Yemen (91-2) (رفض)', 'rejection_APP-2026-001057.pdf', 'rejection_APP-2026-001057.pdf', 'application/pdf', 2284445, 'uploads/documents/rejection_APP-2026-001057.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 91, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001057';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (91-3)', 'protocol_v1_APP-2026-001058.pdf', 'protocol_v1_APP-2026-001058.pdf', 'application/pdf', 2123960, 'uploads/documents/protocol_v1_APP-2026-001058.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 91, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001058';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (91-3)', 'icf_ar_APP-2026-001058.pdf', 'icf_ar_APP-2026-001058.pdf', 'application/pdf', 2173340, 'uploads/documents/icf_ar_APP-2026-001058.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 91, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001058';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (91-3)', 'icf_en_APP-2026-001058.pdf', 'icf_en_APP-2026-001058.pdf', 'application/pdf', 2222720, 'uploads/documents/icf_en_APP-2026-001058.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 91, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001058';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001058.pdf', 'cv_pi_APP-2026-001058.pdf', 'application/pdf', 2272100, 'uploads/documents/cv_pi_APP-2026-001058.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 91, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001058';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001058.pdf', 'cv_coi_APP-2026-001058.pdf', 'application/pdf', 2321480, 'uploads/documents/cv_coi_APP-2026-001058.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 91, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001058';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (91-3)', 'pis_APP-2026-001058.pdf', 'pis_APP-2026-001058.pdf', 'application/pdf', 2370860, 'uploads/documents/pis_APP-2026-001058.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 91, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001058';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (91-3)', 'proposal_APP-2026-001058.pdf', 'proposal_APP-2026-001058.pdf', 'application/pdf', 2420240, 'uploads/documents/proposal_APP-2026-001058.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 91, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2026-001058';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (91-3)', 'irb_approval_APP-2026-001058.pdf', 'irb_approval_APP-2026-001058.pdf', 'application/pdf', 2469620, 'uploads/documents/irb_approval_APP-2026-001058.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 91, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001058';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (91-3)', 'funding_APP-2026-001058.pdf', 'funding_APP-2026-001058.pdf', 'application/pdf', 2519000, 'uploads/documents/funding_APP-2026-001058.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 91, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001058';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (91-3)', 'budget_APP-2026-001058.xlsx', 'budget_APP-2026-001058.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 256644, 'uploads/documents/budget_APP-2026-001058.xlsx', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 91, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001058';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الإجراءات التشغيلية القياسية - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (91-3)', 'sop_APP-2026-001058.pdf', 'sop_APP-2026-001058.pdf', 'application/pdf', 2617760, 'uploads/documents/sop_APP-2026-001058.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 91, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'SOP'
AND a.application_number = 'APP-2026-001058';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'استبيان - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (91-3)', 'questionnaire_APP-2026-001058.pdf', 'questionnaire_APP-2026-001058.pdf', 'application/pdf', 2667140, 'uploads/documents/questionnaire_APP-2026-001058.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 91, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'QUESTIONNAIRE'
AND a.application_number = 'APP-2026-001058';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Maternal Mortality Rates in Rural Areas of Hajjah Governorate (91-3)', 'data_collection_APP-2026-001058.xlsx', 'data_collection_APP-2026-001058.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 269976, 'uploads/documents/data_collection_APP-2026-001058.xlsx', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 91, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001058';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Assessment of Emergency Services in Yemeni General Hospitals (92-0) (النسخة الأصلية)', 'protocol_v1_APP-2026-001059.pdf', 'protocol_v1_APP-2026-001059.pdf', 'application/pdf', 2160995, 'uploads/documents/protocol_v1_APP-2026-001059.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 92, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Assessment of Emergency Services in Yemeni General Hospitals (92-0) (النسخة النهائية)', 'protocol_v2_APP-2026-001059.pdf', 'protocol_v2_APP-2026-001059.pdf', 'application/pdf', 2210375, 'uploads/documents/protocol_v2_APP-2026-001059.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 92, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Assessment of Emergency Services in Yemeni General Hospitals (92-0)', 'icf_ar_APP-2026-001059.pdf', 'icf_ar_APP-2026-001059.pdf', 'application/pdf', 2259755, 'uploads/documents/icf_ar_APP-2026-001059.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 92, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Assessment of Emergency Services in Yemeni General Hospitals (92-0)', 'icf_en_APP-2026-001059.pdf', 'icf_en_APP-2026-001059.pdf', 'application/pdf', 2309135, 'uploads/documents/icf_en_APP-2026-001059.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 92, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Assessment of Emergency Services in Yemeni General Hospitals (92-0) (النسخة المعدلة)', 'icf_v2_APP-2026-001059.pdf', 'icf_v2_APP-2026-001059.pdf', 'application/pdf', 2358515, 'uploads/documents/icf_v2_APP-2026-001059.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 92, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001059.pdf', 'cv_pi_APP-2026-001059.pdf', 'application/pdf', 2407895, 'uploads/documents/cv_pi_APP-2026-001059.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 92, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001059.pdf', 'cv_coi_APP-2026-001059.pdf', 'application/pdf', 2457275, 'uploads/documents/cv_coi_APP-2026-001059.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 92, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Assessment of Emergency Services in Yemeni General Hospitals (92-0)', 'pis_APP-2026-001059.pdf', 'pis_APP-2026-001059.pdf', 'application/pdf', 2506655, 'uploads/documents/pis_APP-2026-001059.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 92, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Assessment of Emergency Services in Yemeni General Hospitals (92-0)', 'proposal_APP-2026-001059.pdf', 'proposal_APP-2026-001059.pdf', 'application/pdf', 2556035, 'uploads/documents/proposal_APP-2026-001059.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 92, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Assessment of Emergency Services in Yemeni General Hospitals (92-0)', 'irb_approval_APP-2026-001059.pdf', 'irb_approval_APP-2026-001059.pdf', 'application/pdf', 2605415, 'uploads/documents/irb_approval_APP-2026-001059.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 92, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Assessment of Emergency Services in Yemeni General Hospitals (92-0)', 'funding_APP-2026-001059.pdf', 'funding_APP-2026-001059.pdf', 'application/pdf', 2654795, 'uploads/documents/funding_APP-2026-001059.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 92, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Assessment of Emergency Services in Yemeni General Hospitals (92-0)', 'budget_APP-2026-001059.xlsx', 'budget_APP-2026-001059.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 268865, 'uploads/documents/budget_APP-2026-001059.xlsx', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 92, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Assessment of Emergency Services in Yemeni General Hospitals (92-0) (موافقة)', 'ethics_decision_APP-2026-001059.pdf', 'ethics_decision_APP-2026-001059.pdf', 'application/pdf', 2753555, 'uploads/documents/ethics_decision_APP-2026-001059.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 92, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'محضر اجتماع اللجنة - Assessment of Emergency Services in Yemeni General Hospitals (92-0)', 'minutes_APP-2026-001059.pdf', 'minutes_APP-2026-001059.pdf', 'application/pdf', 2802935, 'uploads/documents/minutes_APP-2026-001059.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 92, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'MEETING_MINUTES'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Assessment of Emergency Services in Yemeni General Hospitals (92-0)', 'certificate_APP-2026-001059.pdf', 'certificate_APP-2026-001059.pdf', 'application/pdf', 2852315, 'uploads/documents/certificate_APP-2026-001059.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 92, a.created_at + interval '113 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Assessment of Emergency Services in Yemeni General Hospitals (92-0)', 'final_report_APP-2026-001059.pdf', 'final_report_APP-2026-001059.pdf', 'application/pdf', 2901695, 'uploads/documents/final_report_APP-2026-001059.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 92, a.created_at + interval '121 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Assessment of Emergency Services in Yemeni General Hospitals (92-0)', 'data_collection_APP-2026-001059.xlsx', 'data_collection_APP-2026-001059.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 291085, 'uploads/documents/data_collection_APP-2026-001059.xlsx', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 92, a.created_at + interval '129 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'منشور علمي - Assessment of Emergency Services in Yemeni General Hospitals (92-0)', 'publication_APP-2026-001059.pdf', 'publication_APP-2026-001059.pdf', 'application/pdf', 3000455, 'uploads/documents/publication_APP-2026-001059.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 92, a.created_at + interval '137 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PUBLICATION'
AND a.application_number = 'APP-2026-001059';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Cardiovascular Disease Surveillance in Urban Areas (92-1)', 'protocol_v1_APP-2026-001060.pdf', 'protocol_v1_APP-2026-001060.pdf', 'application/pdf', 2198030, 'uploads/documents/protocol_v1_APP-2026-001060.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 92, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001060';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Cardiovascular Disease Surveillance in Urban Areas (92-1)', 'icf_ar_APP-2026-001060.pdf', 'icf_ar_APP-2026-001060.pdf', 'application/pdf', 2247410, 'uploads/documents/icf_ar_APP-2026-001060.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 92, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001060';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Cardiovascular Disease Surveillance in Urban Areas (92-1)', 'icf_en_APP-2026-001060.pdf', 'icf_en_APP-2026-001060.pdf', 'application/pdf', 2296790, 'uploads/documents/icf_en_APP-2026-001060.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 92, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001060';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001060.pdf', 'cv_pi_APP-2026-001060.pdf', 'application/pdf', 2346170, 'uploads/documents/cv_pi_APP-2026-001060.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 92, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001060';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001060.pdf', 'cv_coi_APP-2026-001060.pdf', 'application/pdf', 2395550, 'uploads/documents/cv_coi_APP-2026-001060.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 92, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001060';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Cardiovascular Disease Surveillance in Urban Areas (92-1)', 'pis_APP-2026-001060.pdf', 'pis_APP-2026-001060.pdf', 'application/pdf', 2444930, 'uploads/documents/pis_APP-2026-001060.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 92, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001060';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Cardiovascular Disease Surveillance in Urban Areas (92-1)', 'irb_approval_APP-2026-001060.pdf', 'irb_approval_APP-2026-001060.pdf', 'application/pdf', 2494310, 'uploads/documents/irb_approval_APP-2026-001060.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 92, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001060';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Cardiovascular Disease Surveillance in Urban Areas (92-1)', 'funding_APP-2026-001060.pdf', 'funding_APP-2026-001060.pdf', 'application/pdf', 2543690, 'uploads/documents/funding_APP-2026-001060.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 92, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001060';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Cardiovascular Disease Surveillance in Urban Areas (92-1)', 'budget_APP-2026-001060.xlsx', 'budget_APP-2026-001060.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 258866, 'uploads/documents/budget_APP-2026-001060.xlsx', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 92, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001060';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Cardiovascular Disease Surveillance in Urban Areas (92-1) (موافقة)', 'ethics_decision_APP-2026-001060.pdf', 'ethics_decision_APP-2026-001060.pdf', 'application/pdf', 2642450, 'uploads/documents/ethics_decision_APP-2026-001060.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 92, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001060';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Cardiovascular Disease Surveillance in Urban Areas (92-1)', 'certificate_APP-2026-001060.pdf', 'certificate_APP-2026-001060.pdf', 'application/pdf', 2691830, 'uploads/documents/certificate_APP-2026-001060.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 92, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001060';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Cardiovascular Disease Surveillance in Urban Areas (92-1)', 'final_report_APP-2026-001060.pdf', 'final_report_APP-2026-001060.pdf', 'application/pdf', 2741210, 'uploads/documents/final_report_APP-2026-001060.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 92, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001060';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Cardiovascular Disease Surveillance in Urban Areas (92-1)', 'data_collection_APP-2026-001060.xlsx', 'data_collection_APP-2026-001060.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 276642, 'uploads/documents/data_collection_APP-2026-001060.xlsx', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 92, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001060';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'منشور علمي - Cardiovascular Disease Surveillance in Urban Areas (92-1)', 'publication_APP-2026-001060.pdf', 'publication_APP-2026-001060.pdf', 'application/pdf', 2839970, 'uploads/documents/publication_APP-2026-001060.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 92, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PUBLICATION'
AND a.application_number = 'APP-2026-001060';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Genetic Diversity of Hepatitis B Virus in Yemen', 'protocol_v1_APP-2026-001061.pdf', 'protocol_v1_APP-2026-001061.pdf', 'application/pdf', 2235065, 'uploads/documents/protocol_v1_APP-2026-001061.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 92, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001061';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Genetic Diversity of Hepatitis B Virus in Yemen', 'icf_ar_APP-2026-001061.pdf', 'icf_ar_APP-2026-001061.pdf', 'application/pdf', 2284445, 'uploads/documents/icf_ar_APP-2026-001061.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 92, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001061';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Genetic Diversity of Hepatitis B Virus in Yemen', 'icf_en_APP-2026-001061.pdf', 'icf_en_APP-2026-001061.pdf', 'application/pdf', 2333825, 'uploads/documents/icf_en_APP-2026-001061.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 92, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001061';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001061.pdf', 'cv_pi_APP-2026-001061.pdf', 'application/pdf', 2383205, 'uploads/documents/cv_pi_APP-2026-001061.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 92, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001061';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001061.pdf', 'cv_coi_APP-2026-001061.pdf', 'application/pdf', 2432585, 'uploads/documents/cv_coi_APP-2026-001061.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 92, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001061';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Genetic Diversity of Hepatitis B Virus in Yemen', 'pis_APP-2026-001061.pdf', 'pis_APP-2026-001061.pdf', 'application/pdf', 2481965, 'uploads/documents/pis_APP-2026-001061.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 92, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001061';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Genetic Diversity of Hepatitis B Virus in Yemen', 'irb_approval_APP-2026-001061.pdf', 'irb_approval_APP-2026-001061.pdf', 'application/pdf', 2531345, 'uploads/documents/irb_approval_APP-2026-001061.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 92, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001061';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Genetic Diversity of Hepatitis B Virus in Yemen', 'funding_APP-2026-001061.pdf', 'funding_APP-2026-001061.pdf', 'application/pdf', 2580725, 'uploads/documents/funding_APP-2026-001061.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 92, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001061';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Genetic Diversity of Hepatitis B Virus in Yemen', 'budget_APP-2026-001061.xlsx', 'budget_APP-2026-001061.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 262199, 'uploads/documents/budget_APP-2026-001061.xlsx', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 92, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001061';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Genetic Diversity of Hepatitis B Virus in Yemen (موافقة)', 'ethics_decision_APP-2026-001061.pdf', 'ethics_decision_APP-2026-001061.pdf', 'application/pdf', 2679485, 'uploads/documents/ethics_decision_APP-2026-001061.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 92, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001061';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Genetic Diversity of Hepatitis B Virus in Yemen', 'certificate_APP-2026-001061.pdf', 'certificate_APP-2026-001061.pdf', 'application/pdf', 2728865, 'uploads/documents/certificate_APP-2026-001061.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 92, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001061';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Genetic Diversity of Hepatitis B Virus in Yemen', 'data_collection_APP-2026-001061.xlsx', 'data_collection_APP-2026-001061.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 275531, 'uploads/documents/data_collection_APP-2026-001061.xlsx', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 92, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001061';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Pharmacogenetic Study of Drug Metabolism Among Yemenis', 'protocol_v1_APP-2026-001062.pdf', 'protocol_v1_APP-2026-001062.pdf', 'application/pdf', 2272100, 'uploads/documents/protocol_v1_APP-2026-001062.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 93, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001062';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Pharmacogenetic Study of Drug Metabolism Among Yemenis (النسخة المعدلة)', 'protocol_v2_APP-2026-001062.pdf', 'protocol_v2_APP-2026-001062.pdf', 'application/pdf', 2321480, 'uploads/documents/protocol_v2_APP-2026-001062.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 93, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001062';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Pharmacogenetic Study of Drug Metabolism Among Yemenis', 'icf_ar_APP-2026-001062.pdf', 'icf_ar_APP-2026-001062.pdf', 'application/pdf', 2370860, 'uploads/documents/icf_ar_APP-2026-001062.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 93, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001062';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Pharmacogenetic Study of Drug Metabolism Among Yemenis', 'icf_en_APP-2026-001062.pdf', 'icf_en_APP-2026-001062.pdf', 'application/pdf', 2420240, 'uploads/documents/icf_en_APP-2026-001062.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 93, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001062';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001062.pdf', 'cv_pi_APP-2026-001062.pdf', 'application/pdf', 2469620, 'uploads/documents/cv_pi_APP-2026-001062.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 93, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001062';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001062.pdf', 'cv_coi_APP-2026-001062.pdf', 'application/pdf', 2519000, 'uploads/documents/cv_coi_APP-2026-001062.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 93, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001062';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Pharmacogenetic Study of Drug Metabolism Among Yemenis', 'pis_APP-2026-001062.pdf', 'pis_APP-2026-001062.pdf', 'application/pdf', 2568380, 'uploads/documents/pis_APP-2026-001062.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 93, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001062';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Pharmacogenetic Study of Drug Metabolism Among Yemenis', 'irb_approval_APP-2026-001062.pdf', 'irb_approval_APP-2026-001062.pdf', 'application/pdf', 2617760, 'uploads/documents/irb_approval_APP-2026-001062.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 93, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001062';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Pharmacogenetic Study of Drug Metabolism Among Yemenis', 'funding_APP-2026-001062.pdf', 'funding_APP-2026-001062.pdf', 'application/pdf', 2667140, 'uploads/documents/funding_APP-2026-001062.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 93, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001062';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Pharmacogenetic Study of Drug Metabolism Among Yemenis', 'budget_APP-2026-001062.xlsx', 'budget_APP-2026-001062.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 269976, 'uploads/documents/budget_APP-2026-001062.xlsx', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 93, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001062';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Pharmacogenetic Study of Drug Metabolism Among Yemenis (موافقة)', 'ethics_decision_APP-2026-001062.pdf', 'ethics_decision_APP-2026-001062.pdf', 'application/pdf', 2765900, 'uploads/documents/ethics_decision_APP-2026-001062.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 93, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001062';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Pharmacogenetic Study of Drug Metabolism Among Yemenis', 'certificate_APP-2026-001062.pdf', 'certificate_APP-2026-001062.pdf', 'application/pdf', 2815280, 'uploads/documents/certificate_APP-2026-001062.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 93, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001062';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Pharmacogenetic Study of Drug Metabolism Among Yemenis', 'final_report_APP-2026-001062.pdf', 'final_report_APP-2026-001062.pdf', 'application/pdf', 2864660, 'uploads/documents/final_report_APP-2026-001062.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 93, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001062';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Pharmacogenetic Study of Drug Metabolism Among Yemenis', 'data_collection_APP-2026-001062.xlsx', 'data_collection_APP-2026-001062.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 287752, 'uploads/documents/data_collection_APP-2026-001062.xlsx', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 93, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001062';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'منشور علمي - Pharmacogenetic Study of Drug Metabolism Among Yemenis', 'publication_APP-2026-001062.pdf', 'publication_APP-2026-001062.pdf', 'application/pdf', 2963420, 'uploads/documents/publication_APP-2026-001062.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 93, a.created_at + interval '113 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PUBLICATION'
AND a.application_number = 'APP-2026-001062';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'protocol_v1_APP-2026-001063.pdf', 'protocol_v1_APP-2026-001063.pdf', 'application/pdf', 2309135, 'uploads/documents/protocol_v1_APP-2026-001063.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 93, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001063';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'icf_ar_APP-2026-001063.pdf', 'icf_ar_APP-2026-001063.pdf', 'application/pdf', 2358515, 'uploads/documents/icf_ar_APP-2026-001063.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 93, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001063';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'icf_en_APP-2026-001063.pdf', 'icf_en_APP-2026-001063.pdf', 'application/pdf', 2407895, 'uploads/documents/icf_en_APP-2026-001063.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 93, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001063';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001063.pdf', 'cv_pi_APP-2026-001063.pdf', 'application/pdf', 2457275, 'uploads/documents/cv_pi_APP-2026-001063.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 93, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001063';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001063.pdf', 'cv_coi_APP-2026-001063.pdf', 'application/pdf', 2506655, 'uploads/documents/cv_coi_APP-2026-001063.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 93, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001063';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'pis_APP-2026-001063.pdf', 'pis_APP-2026-001063.pdf', 'application/pdf', 2556035, 'uploads/documents/pis_APP-2026-001063.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 93, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001063';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'irb_approval_APP-2026-001063.pdf', 'irb_approval_APP-2026-001063.pdf', 'application/pdf', 2605415, 'uploads/documents/irb_approval_APP-2026-001063.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 93, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001063';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'funding_APP-2026-001063.pdf', 'funding_APP-2026-001063.pdf', 'application/pdf', 2654795, 'uploads/documents/funding_APP-2026-001063.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 93, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001063';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'budget_APP-2026-001063.xlsx', 'budget_APP-2026-001063.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 268865, 'uploads/documents/budget_APP-2026-001063.xlsx', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 93, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001063';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Obesity Prevalence and Its Association with Chronic Diseases in Adults (موافقة)', 'ethics_decision_APP-2026-001063.pdf', 'ethics_decision_APP-2026-001063.pdf', 'application/pdf', 2753555, 'uploads/documents/ethics_decision_APP-2026-001063.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 93, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001063';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'certificate_APP-2026-001063.pdf', 'certificate_APP-2026-001063.pdf', 'application/pdf', 2802935, 'uploads/documents/certificate_APP-2026-001063.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 93, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001063';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'data_collection_APP-2026-001063.xlsx', 'data_collection_APP-2026-001063.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 282197, 'uploads/documents/data_collection_APP-2026-001063.xlsx', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 93, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001063';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Prevalence of Hepatitis B and C Among Blood Donors (93-2) (مسودة)', 'icf_draft_APP-2026-001064.pdf', 'icf_draft_APP-2026-001064.pdf', 'application/pdf', 2346170, 'uploads/documents/icf_draft_APP-2026-001064.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 93, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001064';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001064.pdf', 'cv_pi_APP-2026-001064.pdf', 'application/pdf', 2395550, 'uploads/documents/cv_pi_APP-2026-001064.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 93, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001064';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Assessment of Emergency Services in Yemeni General Hospitals (93-3)', 'protocol_v1_APP-2026-001065.pdf', 'protocol_v1_APP-2026-001065.pdf', 'application/pdf', 2383205, 'uploads/documents/protocol_v1_APP-2026-001065.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 93, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001065';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Assessment of Emergency Services in Yemeni General Hospitals (93-3) (النسخة المعدلة)', 'protocol_v2_APP-2026-001065.pdf', 'protocol_v2_APP-2026-001065.pdf', 'application/pdf', 2432585, 'uploads/documents/protocol_v2_APP-2026-001065.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 93, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001065';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Assessment of Emergency Services in Yemeni General Hospitals (93-3)', 'icf_ar_APP-2026-001065.pdf', 'icf_ar_APP-2026-001065.pdf', 'application/pdf', 2481965, 'uploads/documents/icf_ar_APP-2026-001065.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 93, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001065';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Assessment of Emergency Services in Yemeni General Hospitals (93-3)', 'icf_en_APP-2026-001065.pdf', 'icf_en_APP-2026-001065.pdf', 'application/pdf', 2531345, 'uploads/documents/icf_en_APP-2026-001065.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 93, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001065';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001065.pdf', 'cv_pi_APP-2026-001065.pdf', 'application/pdf', 2580725, 'uploads/documents/cv_pi_APP-2026-001065.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 93, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001065';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001065.pdf', 'cv_coi_APP-2026-001065.pdf', 'application/pdf', 2630105, 'uploads/documents/cv_coi_APP-2026-001065.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 93, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001065';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Assessment of Emergency Services in Yemeni General Hospitals (93-3)', 'pis_APP-2026-001065.pdf', 'pis_APP-2026-001065.pdf', 'application/pdf', 2679485, 'uploads/documents/pis_APP-2026-001065.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 93, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001065';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Assessment of Emergency Services in Yemeni General Hospitals (93-3)', 'irb_approval_APP-2026-001065.pdf', 'irb_approval_APP-2026-001065.pdf', 'application/pdf', 2728865, 'uploads/documents/irb_approval_APP-2026-001065.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 93, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001065';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Assessment of Emergency Services in Yemeni General Hospitals (93-3)', 'funding_APP-2026-001065.pdf', 'funding_APP-2026-001065.pdf', 'application/pdf', 2778245, 'uploads/documents/funding_APP-2026-001065.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 93, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001065';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Assessment of Emergency Services in Yemeni General Hospitals (93-3)', 'budget_APP-2026-001065.xlsx', 'budget_APP-2026-001065.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 279975, 'uploads/documents/budget_APP-2026-001065.xlsx', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 93, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001065';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Assessment of Emergency Services in Yemeni General Hospitals (93-3) (موافقة)', 'ethics_decision_APP-2026-001065.pdf', 'ethics_decision_APP-2026-001065.pdf', 'application/pdf', 2877005, 'uploads/documents/ethics_decision_APP-2026-001065.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 93, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001065';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Assessment of Emergency Services in Yemeni General Hospitals (93-3)', 'certificate_APP-2026-001065.pdf', 'certificate_APP-2026-001065.pdf', 'application/pdf', 2926385, 'uploads/documents/certificate_APP-2026-001065.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 93, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001065';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Assessment of Emergency Services in Yemeni General Hospitals (93-3)', 'data_collection_APP-2026-001065.xlsx', 'data_collection_APP-2026-001065.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 293307, 'uploads/documents/data_collection_APP-2026-001065.xlsx', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 93, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001065';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Association Between Obesity and Hypertension Among Yemeni Adults (مسودة)', 'protocol_draft_APP-2026-001066.pdf', 'protocol_draft_APP-2026-001066.pdf', 'application/pdf', 2420240, 'uploads/documents/protocol_draft_APP-2026-001066.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 93, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001066';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Association Between Obesity and Hypertension Among Yemeni Adults (مسودة)', 'icf_draft_APP-2026-001066.pdf', 'icf_draft_APP-2026-001066.pdf', 'application/pdf', 2469620, 'uploads/documents/icf_draft_APP-2026-001066.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 93, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001066';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001066.pdf', 'cv_pi_APP-2026-001066.pdf', 'application/pdf', 2519000, 'uploads/documents/cv_pi_APP-2026-001066.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 93, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001066';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Association Between Obesity and Hypertension Among Yemeni Adults (93-5)', 'protocol_v1_APP-2026-001067.pdf', 'protocol_v1_APP-2026-001067.pdf', 'application/pdf', 2457275, 'uploads/documents/protocol_v1_APP-2026-001067.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 93, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001067';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Association Between Obesity and Hypertension Among Yemeni Adults (93-5)', 'icf_ar_APP-2026-001067.pdf', 'icf_ar_APP-2026-001067.pdf', 'application/pdf', 2506655, 'uploads/documents/icf_ar_APP-2026-001067.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 93, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001067';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001067.pdf', 'cv_pi_APP-2026-001067.pdf', 'application/pdf', 2556035, 'uploads/documents/cv_pi_APP-2026-001067.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 93, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001067';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Association Between Obesity and Hypertension Among Yemeni Adults (93-5)', 'pis_APP-2026-001067.pdf', 'pis_APP-2026-001067.pdf', 'application/pdf', 2605415, 'uploads/documents/pis_APP-2026-001067.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 93, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001067';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج تقرير الحالة - Association Between Obesity and Hypertension Among Yemeni Adults (93-5)', 'crf_APP-2026-001067.pdf', 'crf_APP-2026-001067.pdf', 'application/pdf', 2654795, 'uploads/documents/crf_APP-2026-001067.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 93, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CRF'
AND a.application_number = 'APP-2026-001067';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Evaluation of Nutritional Supplements in Malnourished Patients (93-6) (مسودة)', 'protocol_draft_APP-2026-001068.pdf', 'protocol_draft_APP-2026-001068.pdf', 'application/pdf', 2494310, 'uploads/documents/protocol_draft_APP-2026-001068.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 93, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001068';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Evaluation of Nutritional Supplements in Malnourished Patients (93-6) (مسودة)', 'icf_draft_APP-2026-001068.pdf', 'icf_draft_APP-2026-001068.pdf', 'application/pdf', 2543690, 'uploads/documents/icf_draft_APP-2026-001068.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 93, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001068';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Health System Preparedness Assessment for Health Emergencies (94-0)', 'protocol_v1_APP-2026-001069.pdf', 'protocol_v1_APP-2026-001069.pdf', 'application/pdf', 2531345, 'uploads/documents/protocol_v1_APP-2026-001069.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 94, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001069';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Health System Preparedness Assessment for Health Emergencies (94-0)', 'icf_ar_APP-2026-001069.pdf', 'icf_ar_APP-2026-001069.pdf', 'application/pdf', 2580725, 'uploads/documents/icf_ar_APP-2026-001069.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 94, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001069';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Health System Preparedness Assessment for Health Emergencies (94-0)', 'icf_en_APP-2026-001069.pdf', 'icf_en_APP-2026-001069.pdf', 'application/pdf', 2630105, 'uploads/documents/icf_en_APP-2026-001069.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 94, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001069';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001069.pdf', 'cv_pi_APP-2026-001069.pdf', 'application/pdf', 2679485, 'uploads/documents/cv_pi_APP-2026-001069.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 94, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001069';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001069.pdf', 'cv_coi_APP-2026-001069.pdf', 'application/pdf', 2728865, 'uploads/documents/cv_coi_APP-2026-001069.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 94, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001069';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Health System Preparedness Assessment for Health Emergencies (94-0)', 'pis_APP-2026-001069.pdf', 'pis_APP-2026-001069.pdf', 'application/pdf', 2778245, 'uploads/documents/pis_APP-2026-001069.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 94, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001069';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Health System Preparedness Assessment for Health Emergencies (94-0)', 'irb_approval_APP-2026-001069.pdf', 'irb_approval_APP-2026-001069.pdf', 'application/pdf', 2827625, 'uploads/documents/irb_approval_APP-2026-001069.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 94, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001069';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Health System Preparedness Assessment for Health Emergencies (94-0)', 'funding_APP-2026-001069.pdf', 'funding_APP-2026-001069.pdf', 'application/pdf', 2877005, 'uploads/documents/funding_APP-2026-001069.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 94, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001069';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Health System Preparedness Assessment for Health Emergencies (94-0)', 'budget_APP-2026-001069.xlsx', 'budget_APP-2026-001069.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 288863, 'uploads/documents/budget_APP-2026-001069.xlsx', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 94, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001069';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Health System Preparedness Assessment for Health Emergencies (94-0) (موافقة)', 'ethics_decision_APP-2026-001069.pdf', 'ethics_decision_APP-2026-001069.pdf', 'application/pdf', 2975765, 'uploads/documents/ethics_decision_APP-2026-001069.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 94, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001069';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Health System Preparedness Assessment for Health Emergencies (94-0)', 'certificate_APP-2026-001069.pdf', 'certificate_APP-2026-001069.pdf', 'application/pdf', 3025145, 'uploads/documents/certificate_APP-2026-001069.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 94, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001069';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Health System Preparedness Assessment for Health Emergencies (94-0)', 'final_report_APP-2026-001069.pdf', 'final_report_APP-2026-001069.pdf', 'application/pdf', 3074525, 'uploads/documents/final_report_APP-2026-001069.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 94, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001069';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Health System Preparedness Assessment for Health Emergencies (94-0)', 'data_collection_APP-2026-001069.xlsx', 'data_collection_APP-2026-001069.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 306639, 'uploads/documents/data_collection_APP-2026-001069.xlsx', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 94, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001069';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Prevalence of Hepatitis B and C Among Blood Donors (94-1)', 'protocol_v1_APP-2026-001070.pdf', 'protocol_v1_APP-2026-001070.pdf', 'application/pdf', 2568380, 'uploads/documents/protocol_v1_APP-2026-001070.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 94, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001070';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Prevalence of Hepatitis B and C Among Blood Donors (94-1) (النسخة المعدلة)', 'protocol_v2_APP-2026-001070.pdf', 'protocol_v2_APP-2026-001070.pdf', 'application/pdf', 2617760, 'uploads/documents/protocol_v2_APP-2026-001070.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 94, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001070';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Prevalence of Hepatitis B and C Among Blood Donors (94-1)', 'icf_ar_APP-2026-001070.pdf', 'icf_ar_APP-2026-001070.pdf', 'application/pdf', 2667140, 'uploads/documents/icf_ar_APP-2026-001070.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 94, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001070';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Prevalence of Hepatitis B and C Among Blood Donors (94-1)', 'icf_en_APP-2026-001070.pdf', 'icf_en_APP-2026-001070.pdf', 'application/pdf', 2716520, 'uploads/documents/icf_en_APP-2026-001070.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 94, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001070';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001070.pdf', 'cv_pi_APP-2026-001070.pdf', 'application/pdf', 2765900, 'uploads/documents/cv_pi_APP-2026-001070.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 94, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001070';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001070.pdf', 'cv_coi_APP-2026-001070.pdf', 'application/pdf', 2815280, 'uploads/documents/cv_coi_APP-2026-001070.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 94, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001070';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Prevalence of Hepatitis B and C Among Blood Donors (94-1)', 'pis_APP-2026-001070.pdf', 'pis_APP-2026-001070.pdf', 'application/pdf', 2864660, 'uploads/documents/pis_APP-2026-001070.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 94, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001070';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Prevalence of Hepatitis B and C Among Blood Donors (94-1)', 'irb_approval_APP-2026-001070.pdf', 'irb_approval_APP-2026-001070.pdf', 'application/pdf', 2914040, 'uploads/documents/irb_approval_APP-2026-001070.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 94, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001070';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Prevalence of Hepatitis B and C Among Blood Donors (94-1)', 'funding_APP-2026-001070.pdf', 'funding_APP-2026-001070.pdf', 'application/pdf', 2963420, 'uploads/documents/funding_APP-2026-001070.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 94, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001070';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Prevalence of Hepatitis B and C Among Blood Donors (94-1)', 'budget_APP-2026-001070.xlsx', 'budget_APP-2026-001070.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 296640, 'uploads/documents/budget_APP-2026-001070.xlsx', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 94, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001070';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Prevalence of Hepatitis B and C Among Blood Donors (94-1) (موافقة)', 'ethics_decision_APP-2026-001070.pdf', 'ethics_decision_APP-2026-001070.pdf', 'application/pdf', 3062180, 'uploads/documents/ethics_decision_APP-2026-001070.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 94, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001070';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Prevalence of Hepatitis B and C Among Blood Donors (94-1)', 'certificate_APP-2026-001070.pdf', 'certificate_APP-2026-001070.pdf', 'application/pdf', 3111560, 'uploads/documents/certificate_APP-2026-001070.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 94, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001070';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Prevalence of Hepatitis B and C Among Blood Donors (94-1)', 'final_report_APP-2026-001070.pdf', 'final_report_APP-2026-001070.pdf', 'application/pdf', 3160940, 'uploads/documents/final_report_APP-2026-001070.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 94, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001070';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Prevalence of Hepatitis B and C Among Blood Donors (94-1)', 'data_collection_APP-2026-001070.xlsx', 'data_collection_APP-2026-001070.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 314416, 'uploads/documents/data_collection_APP-2026-001070.xlsx', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 94, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001070';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'منشور علمي - Prevalence of Hepatitis B and C Among Blood Donors (94-1)', 'publication_APP-2026-001070.pdf', 'publication_APP-2026-001070.pdf', 'application/pdf', 3259700, 'uploads/documents/publication_APP-2026-001070.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 94, a.created_at + interval '113 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PUBLICATION'
AND a.application_number = 'APP-2026-001070';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Prevalence of Sickle Cell Disease Among Newborns in Aden (94-2)', 'protocol_v1_APP-2026-001071.pdf', 'protocol_v1_APP-2026-001071.pdf', 'application/pdf', 2605415, 'uploads/documents/protocol_v1_APP-2026-001071.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 94, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001071';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Prevalence of Sickle Cell Disease Among Newborns in Aden (94-2) (النسخة المعدلة)', 'protocol_v2_APP-2026-001071.pdf', 'protocol_v2_APP-2026-001071.pdf', 'application/pdf', 2654795, 'uploads/documents/protocol_v2_APP-2026-001071.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 94, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001071';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Prevalence of Sickle Cell Disease Among Newborns in Aden (94-2)', 'icf_ar_APP-2026-001071.pdf', 'icf_ar_APP-2026-001071.pdf', 'application/pdf', 2704175, 'uploads/documents/icf_ar_APP-2026-001071.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 94, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001071';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Prevalence of Sickle Cell Disease Among Newborns in Aden (94-2)', 'icf_en_APP-2026-001071.pdf', 'icf_en_APP-2026-001071.pdf', 'application/pdf', 2753555, 'uploads/documents/icf_en_APP-2026-001071.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 94, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001071';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001071.pdf', 'cv_pi_APP-2026-001071.pdf', 'application/pdf', 2802935, 'uploads/documents/cv_pi_APP-2026-001071.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 94, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001071';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001071.pdf', 'cv_coi_APP-2026-001071.pdf', 'application/pdf', 2852315, 'uploads/documents/cv_coi_APP-2026-001071.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 94, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001071';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Prevalence of Sickle Cell Disease Among Newborns in Aden (94-2)', 'pis_APP-2026-001071.pdf', 'pis_APP-2026-001071.pdf', 'application/pdf', 2901695, 'uploads/documents/pis_APP-2026-001071.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 94, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001071';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Prevalence of Sickle Cell Disease Among Newborns in Aden (94-2)', 'irb_approval_APP-2026-001071.pdf', 'irb_approval_APP-2026-001071.pdf', 'application/pdf', 2951075, 'uploads/documents/irb_approval_APP-2026-001071.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 94, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001071';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Prevalence of Sickle Cell Disease Among Newborns in Aden (94-2)', 'funding_APP-2026-001071.pdf', 'funding_APP-2026-001071.pdf', 'application/pdf', 3000455, 'uploads/documents/funding_APP-2026-001071.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 94, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001071';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Prevalence of Sickle Cell Disease Among Newborns in Aden (94-2)', 'budget_APP-2026-001071.xlsx', 'budget_APP-2026-001071.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 299973, 'uploads/documents/budget_APP-2026-001071.xlsx', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 94, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001071';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Prevalence of Sickle Cell Disease Among Newborns in Aden (94-2) (موافقة)', 'ethics_decision_APP-2026-001071.pdf', 'ethics_decision_APP-2026-001071.pdf', 'application/pdf', 3099215, 'uploads/documents/ethics_decision_APP-2026-001071.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 94, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001071';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Prevalence of Sickle Cell Disease Among Newborns in Aden (94-2)', 'certificate_APP-2026-001071.pdf', 'certificate_APP-2026-001071.pdf', 'application/pdf', 3148595, 'uploads/documents/certificate_APP-2026-001071.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 94, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001071';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Prevalence of Sickle Cell Disease Among Newborns in Aden (94-2)', 'data_collection_APP-2026-001071.xlsx', 'data_collection_APP-2026-001071.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 313305, 'uploads/documents/data_collection_APP-2026-001071.xlsx', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 94, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001071';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Cancer Incidence Patterns in Yemen Based on National Registry', 'protocol_v1_APP-2026-001072.pdf', 'protocol_v1_APP-2026-001072.pdf', 'application/pdf', 2642450, 'uploads/documents/protocol_v1_APP-2026-001072.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 94, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001072';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Cancer Incidence Patterns in Yemen Based on National Registry', 'icf_ar_APP-2026-001072.pdf', 'icf_ar_APP-2026-001072.pdf', 'application/pdf', 2691830, 'uploads/documents/icf_ar_APP-2026-001072.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 94, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001072';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Cancer Incidence Patterns in Yemen Based on National Registry', 'icf_en_APP-2026-001072.pdf', 'icf_en_APP-2026-001072.pdf', 'application/pdf', 2741210, 'uploads/documents/icf_en_APP-2026-001072.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 94, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001072';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001072.pdf', 'cv_pi_APP-2026-001072.pdf', 'application/pdf', 2790590, 'uploads/documents/cv_pi_APP-2026-001072.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 94, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001072';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001072.pdf', 'cv_coi_APP-2026-001072.pdf', 'application/pdf', 2839970, 'uploads/documents/cv_coi_APP-2026-001072.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 94, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001072';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Cancer Incidence Patterns in Yemen Based on National Registry', 'pis_APP-2026-001072.pdf', 'pis_APP-2026-001072.pdf', 'application/pdf', 2889350, 'uploads/documents/pis_APP-2026-001072.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 94, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001072';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Cancer Incidence Patterns in Yemen Based on National Registry', 'proposal_APP-2026-001072.pdf', 'proposal_APP-2026-001072.pdf', 'application/pdf', 2938730, 'uploads/documents/proposal_APP-2026-001072.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 94, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2026-001072';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Cancer Incidence Patterns in Yemen Based on National Registry', 'irb_approval_APP-2026-001072.pdf', 'irb_approval_APP-2026-001072.pdf', 'application/pdf', 2988110, 'uploads/documents/irb_approval_APP-2026-001072.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 94, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001072';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Cancer Incidence Patterns in Yemen Based on National Registry', 'funding_APP-2026-001072.pdf', 'funding_APP-2026-001072.pdf', 'application/pdf', 3037490, 'uploads/documents/funding_APP-2026-001072.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 94, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001072';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Cancer Incidence Patterns in Yemen Based on National Registry', 'budget_APP-2026-001072.xlsx', 'budget_APP-2026-001072.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 303306, 'uploads/documents/budget_APP-2026-001072.xlsx', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 94, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001072';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'استبيان - Cancer Incidence Patterns in Yemen Based on National Registry', 'questionnaire_APP-2026-001072.pdf', 'questionnaire_APP-2026-001072.pdf', 'application/pdf', 3136250, 'uploads/documents/questionnaire_APP-2026-001072.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 94, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'QUESTIONNAIRE'
AND a.application_number = 'APP-2026-001072';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Cancer Incidence Patterns in Yemen Based on National Registry', 'data_collection_APP-2026-001072.xlsx', 'data_collection_APP-2026-001072.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 312194, 'uploads/documents/data_collection_APP-2026-001072.xlsx', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 94, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001072';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001073.pdf', 'cv_pi_APP-2026-001073.pdf', 'application/pdf', 2679485, 'uploads/documents/cv_pi_APP-2026-001073.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 94, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001073';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Blood Transfusion Safety Assessment in Yemeni Blood Banks (94-5)', 'protocol_v1_APP-2026-001074.pdf', 'protocol_v1_APP-2026-001074.pdf', 'application/pdf', 2716520, 'uploads/documents/protocol_v1_APP-2026-001074.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 94, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001074';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Blood Transfusion Safety Assessment in Yemeni Blood Banks (94-5) (النسخة المعدلة)', 'protocol_v2_APP-2026-001074.pdf', 'protocol_v2_APP-2026-001074.pdf', 'application/pdf', 2765900, 'uploads/documents/protocol_v2_APP-2026-001074.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 94, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001074';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Blood Transfusion Safety Assessment in Yemeni Blood Banks (94-5)', 'icf_ar_APP-2026-001074.pdf', 'icf_ar_APP-2026-001074.pdf', 'application/pdf', 2815280, 'uploads/documents/icf_ar_APP-2026-001074.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 94, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001074';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Blood Transfusion Safety Assessment in Yemeni Blood Banks (94-5)', 'icf_en_APP-2026-001074.pdf', 'icf_en_APP-2026-001074.pdf', 'application/pdf', 2864660, 'uploads/documents/icf_en_APP-2026-001074.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 94, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001074';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001074.pdf', 'cv_pi_APP-2026-001074.pdf', 'application/pdf', 2914040, 'uploads/documents/cv_pi_APP-2026-001074.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 94, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001074';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001074.pdf', 'cv_coi_APP-2026-001074.pdf', 'application/pdf', 2963420, 'uploads/documents/cv_coi_APP-2026-001074.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 94, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001074';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Blood Transfusion Safety Assessment in Yemeni Blood Banks (94-5)', 'pis_APP-2026-001074.pdf', 'pis_APP-2026-001074.pdf', 'application/pdf', 3012800, 'uploads/documents/pis_APP-2026-001074.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 94, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001074';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Blood Transfusion Safety Assessment in Yemeni Blood Banks (94-5)', 'irb_approval_APP-2026-001074.pdf', 'irb_approval_APP-2026-001074.pdf', 'application/pdf', 3062180, 'uploads/documents/irb_approval_APP-2026-001074.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 94, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001074';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Blood Transfusion Safety Assessment in Yemeni Blood Banks (94-5)', 'funding_APP-2026-001074.pdf', 'funding_APP-2026-001074.pdf', 'application/pdf', 3111560, 'uploads/documents/funding_APP-2026-001074.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 94, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001074';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Blood Transfusion Safety Assessment in Yemeni Blood Banks (94-5)', 'budget_APP-2026-001074.xlsx', 'budget_APP-2026-001074.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 309972, 'uploads/documents/budget_APP-2026-001074.xlsx', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 94, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001074';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Blood Transfusion Safety Assessment in Yemeni Blood Banks (94-5) (موافقة)', 'ethics_decision_APP-2026-001074.pdf', 'ethics_decision_APP-2026-001074.pdf', 'application/pdf', 3210320, 'uploads/documents/ethics_decision_APP-2026-001074.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 94, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001074';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Blood Transfusion Safety Assessment in Yemeni Blood Banks (94-5)', 'certificate_APP-2026-001074.pdf', 'certificate_APP-2026-001074.pdf', 'application/pdf', 3259700, 'uploads/documents/certificate_APP-2026-001074.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 94, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001074';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Blood Transfusion Safety Assessment in Yemeni Blood Banks (94-5)', 'final_report_APP-2026-001074.pdf', 'final_report_APP-2026-001074.pdf', 'application/pdf', 3309080, 'uploads/documents/final_report_APP-2026-001074.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 94, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001074';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Blood Transfusion Safety Assessment in Yemeni Blood Banks (94-5)', 'data_collection_APP-2026-001074.xlsx', 'data_collection_APP-2026-001074.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 327748, 'uploads/documents/data_collection_APP-2026-001074.xlsx', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 94, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001074';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'منشور علمي - Blood Transfusion Safety Assessment in Yemeni Blood Banks (94-5)', 'publication_APP-2026-001074.pdf', 'publication_APP-2026-001074.pdf', 'application/pdf', 3407840, 'uploads/documents/publication_APP-2026-001074.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 94, a.created_at + interval '113 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PUBLICATION'
AND a.application_number = 'APP-2026-001074';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (95-0)', 'protocol_v1_APP-2026-001075.pdf', 'protocol_v1_APP-2026-001075.pdf', 'application/pdf', 2753555, 'uploads/documents/protocol_v1_APP-2026-001075.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 95, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001075';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (95-0)', 'icf_ar_APP-2026-001075.pdf', 'icf_ar_APP-2026-001075.pdf', 'application/pdf', 2802935, 'uploads/documents/icf_ar_APP-2026-001075.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 95, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001075';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (95-0)', 'icf_en_APP-2026-001075.pdf', 'icf_en_APP-2026-001075.pdf', 'application/pdf', 2852315, 'uploads/documents/icf_en_APP-2026-001075.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 95, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001075';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001075.pdf', 'cv_pi_APP-2026-001075.pdf', 'application/pdf', 2901695, 'uploads/documents/cv_pi_APP-2026-001075.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 95, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001075';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001075.pdf', 'cv_coi_APP-2026-001075.pdf', 'application/pdf', 2951075, 'uploads/documents/cv_coi_APP-2026-001075.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 95, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001075';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (95-0)', 'pis_APP-2026-001075.pdf', 'pis_APP-2026-001075.pdf', 'application/pdf', 3000455, 'uploads/documents/pis_APP-2026-001075.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 95, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001075';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (95-0)', 'irb_approval_APP-2026-001075.pdf', 'irb_approval_APP-2026-001075.pdf', 'application/pdf', 3049835, 'uploads/documents/irb_approval_APP-2026-001075.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 95, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001075';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (95-0)', 'funding_APP-2026-001075.pdf', 'funding_APP-2026-001075.pdf', 'application/pdf', 3099215, 'uploads/documents/funding_APP-2026-001075.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 95, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001075';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (95-0)', 'budget_APP-2026-001075.xlsx', 'budget_APP-2026-001075.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 308861, 'uploads/documents/budget_APP-2026-001075.xlsx', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 95, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001075';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (95-0) (موافقة)', 'ethics_decision_APP-2026-001075.pdf', 'ethics_decision_APP-2026-001075.pdf', 'application/pdf', 3197975, 'uploads/documents/ethics_decision_APP-2026-001075.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 95, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001075';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (95-0)', 'certificate_APP-2026-001075.pdf', 'certificate_APP-2026-001075.pdf', 'application/pdf', 3247355, 'uploads/documents/certificate_APP-2026-001075.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 95, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001075';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (95-0)', 'data_collection_APP-2026-001075.xlsx', 'data_collection_APP-2026-001075.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 322193, 'uploads/documents/data_collection_APP-2026-001075.xlsx', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 95, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001075';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Efficacy and Safety Evaluation of Generic Medicines in Yemen (95-1)', 'protocol_v1_APP-2026-001076.pdf', 'protocol_v1_APP-2026-001076.pdf', 'application/pdf', 2790590, 'uploads/documents/protocol_v1_APP-2026-001076.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 95, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001076';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Efficacy and Safety Evaluation of Generic Medicines in Yemen (95-1)', 'icf_ar_APP-2026-001076.pdf', 'icf_ar_APP-2026-001076.pdf', 'application/pdf', 2839970, 'uploads/documents/icf_ar_APP-2026-001076.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 95, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001076';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Efficacy and Safety Evaluation of Generic Medicines in Yemen (95-1)', 'icf_en_APP-2026-001076.pdf', 'icf_en_APP-2026-001076.pdf', 'application/pdf', 2889350, 'uploads/documents/icf_en_APP-2026-001076.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 95, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001076';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001076.pdf', 'cv_pi_APP-2026-001076.pdf', 'application/pdf', 2938730, 'uploads/documents/cv_pi_APP-2026-001076.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 95, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001076';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001076.pdf', 'cv_coi_APP-2026-001076.pdf', 'application/pdf', 2988110, 'uploads/documents/cv_coi_APP-2026-001076.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 95, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001076';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Efficacy and Safety Evaluation of Generic Medicines in Yemen (95-1)', 'pis_APP-2026-001076.pdf', 'pis_APP-2026-001076.pdf', 'application/pdf', 3037490, 'uploads/documents/pis_APP-2026-001076.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 95, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001076';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Efficacy and Safety Evaluation of Generic Medicines in Yemen (95-1)', 'irb_approval_APP-2026-001076.pdf', 'irb_approval_APP-2026-001076.pdf', 'application/pdf', 3086870, 'uploads/documents/irb_approval_APP-2026-001076.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 95, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001076';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Efficacy and Safety Evaluation of Generic Medicines in Yemen (95-1)', 'funding_APP-2026-001076.pdf', 'funding_APP-2026-001076.pdf', 'application/pdf', 3136250, 'uploads/documents/funding_APP-2026-001076.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 95, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001076';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Efficacy and Safety Evaluation of Generic Medicines in Yemen (95-1)', 'budget_APP-2026-001076.xlsx', 'budget_APP-2026-001076.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 312194, 'uploads/documents/budget_APP-2026-001076.xlsx', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 95, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001076';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Efficacy and Safety Evaluation of Generic Medicines in Yemen (95-1) (موافقة)', 'ethics_decision_APP-2026-001076.pdf', 'ethics_decision_APP-2026-001076.pdf', 'application/pdf', 3235010, 'uploads/documents/ethics_decision_APP-2026-001076.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 95, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001076';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Efficacy and Safety Evaluation of Generic Medicines in Yemen (95-1)', 'certificate_APP-2026-001076.pdf', 'certificate_APP-2026-001076.pdf', 'application/pdf', 3284390, 'uploads/documents/certificate_APP-2026-001076.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 95, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001076';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Efficacy and Safety Evaluation of Generic Medicines in Yemen (95-1)', 'final_report_APP-2026-001076.pdf', 'final_report_APP-2026-001076.pdf', 'application/pdf', 3333770, 'uploads/documents/final_report_APP-2026-001076.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 95, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001076';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Efficacy and Safety Evaluation of Generic Medicines in Yemen (95-1)', 'data_collection_APP-2026-001076.xlsx', 'data_collection_APP-2026-001076.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 329970, 'uploads/documents/data_collection_APP-2026-001076.xlsx', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 95, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001076';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'منشور علمي - Efficacy and Safety Evaluation of Generic Medicines in Yemen (95-1)', 'publication_APP-2026-001076.pdf', 'publication_APP-2026-001076.pdf', 'application/pdf', 3432530, 'uploads/documents/publication_APP-2026-001076.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 95, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PUBLICATION'
AND a.application_number = 'APP-2026-001076';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Obesity Prevalence and Its Association with Chronic Diseases in Adults (95-2) (مسودة)', 'protocol_draft_APP-2026-001077.pdf', 'protocol_draft_APP-2026-001077.pdf', 'application/pdf', 2827625, 'uploads/documents/protocol_draft_APP-2026-001077.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 95, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001077';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Effectiveness of Diabetes Awareness Programs in Schools (95-3)', 'protocol_v1_APP-2026-001078.pdf', 'protocol_v1_APP-2026-001078.pdf', 'application/pdf', 2864660, 'uploads/documents/protocol_v1_APP-2026-001078.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 95, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001078';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Effectiveness of Diabetes Awareness Programs in Schools (95-3)', 'icf_ar_APP-2026-001078.pdf', 'icf_ar_APP-2026-001078.pdf', 'application/pdf', 2914040, 'uploads/documents/icf_ar_APP-2026-001078.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 95, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001078';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Effectiveness of Diabetes Awareness Programs in Schools (95-3)', 'icf_en_APP-2026-001078.pdf', 'icf_en_APP-2026-001078.pdf', 'application/pdf', 2963420, 'uploads/documents/icf_en_APP-2026-001078.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 95, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001078';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001078.pdf', 'cv_pi_APP-2026-001078.pdf', 'application/pdf', 3012800, 'uploads/documents/cv_pi_APP-2026-001078.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 95, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001078';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001078.pdf', 'cv_coi_APP-2026-001078.pdf', 'application/pdf', 3062180, 'uploads/documents/cv_coi_APP-2026-001078.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 95, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001078';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Effectiveness of Diabetes Awareness Programs in Schools (95-3)', 'pis_APP-2026-001078.pdf', 'pis_APP-2026-001078.pdf', 'application/pdf', 3111560, 'uploads/documents/pis_APP-2026-001078.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 95, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001078';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Effectiveness of Diabetes Awareness Programs in Schools (95-3)', 'proposal_APP-2026-001078.pdf', 'proposal_APP-2026-001078.pdf', 'application/pdf', 3160940, 'uploads/documents/proposal_APP-2026-001078.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 95, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2026-001078';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Effectiveness of Diabetes Awareness Programs in Schools (95-3)', 'irb_approval_APP-2026-001078.pdf', 'irb_approval_APP-2026-001078.pdf', 'application/pdf', 3210320, 'uploads/documents/irb_approval_APP-2026-001078.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 95, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001078';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Effectiveness of Diabetes Awareness Programs in Schools (95-3)', 'funding_APP-2026-001078.pdf', 'funding_APP-2026-001078.pdf', 'application/pdf', 3259700, 'uploads/documents/funding_APP-2026-001078.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 95, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001078';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Effectiveness of Diabetes Awareness Programs in Schools (95-3)', 'budget_APP-2026-001078.xlsx', 'budget_APP-2026-001078.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 323304, 'uploads/documents/budget_APP-2026-001078.xlsx', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 95, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001078';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'استبيان - Effectiveness of Diabetes Awareness Programs in Schools (95-3)', 'questionnaire_APP-2026-001078.pdf', 'questionnaire_APP-2026-001078.pdf', 'application/pdf', 3358460, 'uploads/documents/questionnaire_APP-2026-001078.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 95, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'QUESTIONNAIRE'
AND a.application_number = 'APP-2026-001078';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Effectiveness of Diabetes Awareness Programs in Schools (95-3)', 'data_collection_APP-2026-001078.xlsx', 'data_collection_APP-2026-001078.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 32192, 'uploads/documents/data_collection_APP-2026-001078.xlsx', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 95, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001078';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Effectiveness of Diabetes Awareness Programs in Schools (95-4)', 'protocol_v1_APP-2026-001079.pdf', 'protocol_v1_APP-2026-001079.pdf', 'application/pdf', 2901695, 'uploads/documents/protocol_v1_APP-2026-001079.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 95, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001079';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Effectiveness of Diabetes Awareness Programs in Schools (95-4)', 'icf_ar_APP-2026-001079.pdf', 'icf_ar_APP-2026-001079.pdf', 'application/pdf', 2951075, 'uploads/documents/icf_ar_APP-2026-001079.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 95, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001079';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001079.pdf', 'cv_pi_APP-2026-001079.pdf', 'application/pdf', 3000455, 'uploads/documents/cv_pi_APP-2026-001079.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 95, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001079';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Effectiveness of Diabetes Awareness Programs in Schools (95-4)', 'pis_APP-2026-001079.pdf', 'pis_APP-2026-001079.pdf', 'application/pdf', 3049835, 'uploads/documents/pis_APP-2026-001079.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 95, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001079';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج تقرير الحالة - Effectiveness of Diabetes Awareness Programs in Schools (95-4)', 'crf_APP-2026-001079.pdf', 'crf_APP-2026-001079.pdf', 'application/pdf', 3099215, 'uploads/documents/crf_APP-2026-001079.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 95, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CRF'
AND a.application_number = 'APP-2026-001079';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Cancer Incidence Patterns in Yemen Based on National Registry (95-5)', 'protocol_v1_APP-2026-001080.pdf', 'protocol_v1_APP-2026-001080.pdf', 'application/pdf', 2938730, 'uploads/documents/protocol_v1_APP-2026-001080.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 95, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001080';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Cancer Incidence Patterns in Yemen Based on National Registry (95-5) (النسخة المعدلة)', 'protocol_v2_APP-2026-001080.pdf', 'protocol_v2_APP-2026-001080.pdf', 'application/pdf', 2988110, 'uploads/documents/protocol_v2_APP-2026-001080.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 95, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001080';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Cancer Incidence Patterns in Yemen Based on National Registry (95-5)', 'icf_ar_APP-2026-001080.pdf', 'icf_ar_APP-2026-001080.pdf', 'application/pdf', 3037490, 'uploads/documents/icf_ar_APP-2026-001080.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 95, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001080';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Cancer Incidence Patterns in Yemen Based on National Registry (95-5)', 'icf_en_APP-2026-001080.pdf', 'icf_en_APP-2026-001080.pdf', 'application/pdf', 3086870, 'uploads/documents/icf_en_APP-2026-001080.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 95, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001080';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001080.pdf', 'cv_pi_APP-2026-001080.pdf', 'application/pdf', 3136250, 'uploads/documents/cv_pi_APP-2026-001080.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 95, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001080';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001080.pdf', 'cv_coi_APP-2026-001080.pdf', 'application/pdf', 3185630, 'uploads/documents/cv_coi_APP-2026-001080.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 95, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001080';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Cancer Incidence Patterns in Yemen Based on National Registry (95-5)', 'pis_APP-2026-001080.pdf', 'pis_APP-2026-001080.pdf', 'application/pdf', 3235010, 'uploads/documents/pis_APP-2026-001080.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 95, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001080';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Cancer Incidence Patterns in Yemen Based on National Registry (95-5)', 'irb_approval_APP-2026-001080.pdf', 'irb_approval_APP-2026-001080.pdf', 'application/pdf', 3284390, 'uploads/documents/irb_approval_APP-2026-001080.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 95, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001080';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Cancer Incidence Patterns in Yemen Based on National Registry (95-5)', 'funding_APP-2026-001080.pdf', 'funding_APP-2026-001080.pdf', 'application/pdf', 3333770, 'uploads/documents/funding_APP-2026-001080.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 95, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001080';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Cancer Incidence Patterns in Yemen Based on National Registry (95-5)', 'budget_APP-2026-001080.xlsx', 'budget_APP-2026-001080.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 329970, 'uploads/documents/budget_APP-2026-001080.xlsx', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 95, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001080';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Cancer Incidence Patterns in Yemen Based on National Registry (95-5) (موافقة)', 'ethics_decision_APP-2026-001080.pdf', 'ethics_decision_APP-2026-001080.pdf', 'application/pdf', 3432530, 'uploads/documents/ethics_decision_APP-2026-001080.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 95, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001080';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Cancer Incidence Patterns in Yemen Based on National Registry (95-5)', 'certificate_APP-2026-001080.pdf', 'certificate_APP-2026-001080.pdf', 'application/pdf', 3481910, 'uploads/documents/certificate_APP-2026-001080.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 95, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001080';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Cancer Incidence Patterns in Yemen Based on National Registry (95-5)', 'data_collection_APP-2026-001080.xlsx', 'data_collection_APP-2026-001080.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 43302, 'uploads/documents/data_collection_APP-2026-001080.xlsx', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 95, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001080';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Antimicrobial Resistance Prevalence in Yemeni Hospitals (95-6)', 'protocol_v1_APP-2026-001081.pdf', 'protocol_v1_APP-2026-001081.pdf', 'application/pdf', 2975765, 'uploads/documents/protocol_v1_APP-2026-001081.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 95, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001081';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Antimicrobial Resistance Prevalence in Yemeni Hospitals (95-6)', 'icf_ar_APP-2026-001081.pdf', 'icf_ar_APP-2026-001081.pdf', 'application/pdf', 3025145, 'uploads/documents/icf_ar_APP-2026-001081.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 95, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001081';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Antimicrobial Resistance Prevalence in Yemeni Hospitals (95-6)', 'icf_en_APP-2026-001081.pdf', 'icf_en_APP-2026-001081.pdf', 'application/pdf', 3074525, 'uploads/documents/icf_en_APP-2026-001081.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 95, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001081';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001081.pdf', 'cv_pi_APP-2026-001081.pdf', 'application/pdf', 3123905, 'uploads/documents/cv_pi_APP-2026-001081.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 95, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001081';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001081.pdf', 'cv_coi_APP-2026-001081.pdf', 'application/pdf', 3173285, 'uploads/documents/cv_coi_APP-2026-001081.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 95, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001081';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Antimicrobial Resistance Prevalence in Yemeni Hospitals (95-6)', 'pis_APP-2026-001081.pdf', 'pis_APP-2026-001081.pdf', 'application/pdf', 3222665, 'uploads/documents/pis_APP-2026-001081.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 95, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001081';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Antimicrobial Resistance Prevalence in Yemeni Hospitals (95-6)', 'irb_approval_APP-2026-001081.pdf', 'irb_approval_APP-2026-001081.pdf', 'application/pdf', 3272045, 'uploads/documents/irb_approval_APP-2026-001081.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 95, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001081';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Antimicrobial Resistance Prevalence in Yemeni Hospitals (95-6)', 'funding_APP-2026-001081.pdf', 'funding_APP-2026-001081.pdf', 'application/pdf', 3321425, 'uploads/documents/funding_APP-2026-001081.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 95, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001081';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Antimicrobial Resistance Prevalence in Yemeni Hospitals (95-6)', 'budget_APP-2026-001081.xlsx', 'budget_APP-2026-001081.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 328859, 'uploads/documents/budget_APP-2026-001081.xlsx', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 95, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001081';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Antimicrobial Resistance Prevalence in Yemeni Hospitals (95-6) (موافقة)', 'ethics_decision_APP-2026-001081.pdf', 'ethics_decision_APP-2026-001081.pdf', 'application/pdf', 3420185, 'uploads/documents/ethics_decision_APP-2026-001081.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 95, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001081';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Antimicrobial Resistance Prevalence in Yemeni Hospitals (95-6)', 'certificate_APP-2026-001081.pdf', 'certificate_APP-2026-001081.pdf', 'application/pdf', 3469565, 'uploads/documents/certificate_APP-2026-001081.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 95, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001081';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Antimicrobial Resistance Prevalence in Yemeni Hospitals (95-6)', 'data_collection_APP-2026-001081.xlsx', 'data_collection_APP-2026-001081.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 42191, 'uploads/documents/data_collection_APP-2026-001081.xlsx', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 95, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001081';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Cancer Incidence Patterns in Yemen Based on National Registry (95-7)', 'protocol_v1_APP-2026-001082.pdf', 'protocol_v1_APP-2026-001082.pdf', 'application/pdf', 3012800, 'uploads/documents/protocol_v1_APP-2026-001082.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 95, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001082';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Cancer Incidence Patterns in Yemen Based on National Registry (95-7)', 'icf_ar_APP-2026-001082.pdf', 'icf_ar_APP-2026-001082.pdf', 'application/pdf', 3062180, 'uploads/documents/icf_ar_APP-2026-001082.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 95, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001082';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001082.pdf', 'cv_pi_APP-2026-001082.pdf', 'application/pdf', 3111560, 'uploads/documents/cv_pi_APP-2026-001082.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 95, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001082';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Cancer Incidence Patterns in Yemen Based on National Registry (95-7)', 'pis_APP-2026-001082.pdf', 'pis_APP-2026-001082.pdf', 'application/pdf', 3160940, 'uploads/documents/pis_APP-2026-001082.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 95, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001082';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'استبيان - Cancer Incidence Patterns in Yemen Based on National Registry (95-7)', 'questionnaire_APP-2026-001082.pdf', 'questionnaire_APP-2026-001082.pdf', 'application/pdf', 3210320, 'uploads/documents/questionnaire_APP-2026-001082.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 95, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'QUESTIONNAIRE'
AND a.application_number = 'APP-2026-001082';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Injury Patterns from Road Traffic Accidents in Sana''a (96-0)', 'protocol_v1_APP-2026-001083.pdf', 'protocol_v1_APP-2026-001083.pdf', 'application/pdf', 3049835, 'uploads/documents/protocol_v1_APP-2026-001083.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 96, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001083';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Injury Patterns from Road Traffic Accidents in Sana''a (96-0) (النسخة المعدلة)', 'protocol_v2_APP-2026-001083.pdf', 'protocol_v2_APP-2026-001083.pdf', 'application/pdf', 3099215, 'uploads/documents/protocol_v2_APP-2026-001083.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 96, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001083';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Injury Patterns from Road Traffic Accidents in Sana''a (96-0)', 'icf_ar_APP-2026-001083.pdf', 'icf_ar_APP-2026-001083.pdf', 'application/pdf', 3148595, 'uploads/documents/icf_ar_APP-2026-001083.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 96, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001083';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Injury Patterns from Road Traffic Accidents in Sana''a (96-0)', 'icf_en_APP-2026-001083.pdf', 'icf_en_APP-2026-001083.pdf', 'application/pdf', 3197975, 'uploads/documents/icf_en_APP-2026-001083.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 96, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001083';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001083.pdf', 'cv_pi_APP-2026-001083.pdf', 'application/pdf', 3247355, 'uploads/documents/cv_pi_APP-2026-001083.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 96, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001083';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001083.pdf', 'cv_coi_APP-2026-001083.pdf', 'application/pdf', 3296735, 'uploads/documents/cv_coi_APP-2026-001083.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 96, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001083';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Injury Patterns from Road Traffic Accidents in Sana''a (96-0)', 'pis_APP-2026-001083.pdf', 'pis_APP-2026-001083.pdf', 'application/pdf', 3346115, 'uploads/documents/pis_APP-2026-001083.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 96, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001083';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Injury Patterns from Road Traffic Accidents in Sana''a (96-0)', 'irb_approval_APP-2026-001083.pdf', 'irb_approval_APP-2026-001083.pdf', 'application/pdf', 3395495, 'uploads/documents/irb_approval_APP-2026-001083.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 96, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001083';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Injury Patterns from Road Traffic Accidents in Sana''a (96-0)', 'funding_APP-2026-001083.pdf', 'funding_APP-2026-001083.pdf', 'application/pdf', 3444875, 'uploads/documents/funding_APP-2026-001083.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 96, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001083';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Injury Patterns from Road Traffic Accidents in Sana''a (96-0)', 'budget_APP-2026-001083.xlsx', 'budget_APP-2026-001083.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 39969, 'uploads/documents/budget_APP-2026-001083.xlsx', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 96, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001083';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Injury Patterns from Road Traffic Accidents in Sana''a (96-0) (موافقة)', 'ethics_decision_APP-2026-001083.pdf', 'ethics_decision_APP-2026-001083.pdf', 'application/pdf', 3543635, 'uploads/documents/ethics_decision_APP-2026-001083.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 96, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001083';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Injury Patterns from Road Traffic Accidents in Sana''a (96-0)', 'certificate_APP-2026-001083.pdf', 'certificate_APP-2026-001083.pdf', 'application/pdf', 3593015, 'uploads/documents/certificate_APP-2026-001083.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 96, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001083';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Injury Patterns from Road Traffic Accidents in Sana''a (96-0)', 'data_collection_APP-2026-001083.xlsx', 'data_collection_APP-2026-001083.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 53301, 'uploads/documents/data_collection_APP-2026-001083.xlsx', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 96, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001083';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Cancer Incidence Patterns in Yemen Based on National Registry (96-1)', 'protocol_v1_APP-2026-001084.pdf', 'protocol_v1_APP-2026-001084.pdf', 'application/pdf', 3086870, 'uploads/documents/protocol_v1_APP-2026-001084.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 96, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001084';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Cancer Incidence Patterns in Yemen Based on National Registry (96-1)', 'icf_ar_APP-2026-001084.pdf', 'icf_ar_APP-2026-001084.pdf', 'application/pdf', 3136250, 'uploads/documents/icf_ar_APP-2026-001084.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 96, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001084';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Cancer Incidence Patterns in Yemen Based on National Registry (96-1)', 'icf_en_APP-2026-001084.pdf', 'icf_en_APP-2026-001084.pdf', 'application/pdf', 3185630, 'uploads/documents/icf_en_APP-2026-001084.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 96, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001084';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001084.pdf', 'cv_pi_APP-2026-001084.pdf', 'application/pdf', 3235010, 'uploads/documents/cv_pi_APP-2026-001084.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 96, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001084';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001084.pdf', 'cv_coi_APP-2026-001084.pdf', 'application/pdf', 3284390, 'uploads/documents/cv_coi_APP-2026-001084.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 96, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001084';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Cancer Incidence Patterns in Yemen Based on National Registry (96-1)', 'pis_APP-2026-001084.pdf', 'pis_APP-2026-001084.pdf', 'application/pdf', 3333770, 'uploads/documents/pis_APP-2026-001084.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 96, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001084';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Cancer Incidence Patterns in Yemen Based on National Registry (96-1)', 'irb_approval_APP-2026-001084.pdf', 'irb_approval_APP-2026-001084.pdf', 'application/pdf', 3383150, 'uploads/documents/irb_approval_APP-2026-001084.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 96, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001084';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Cancer Incidence Patterns in Yemen Based on National Registry (96-1)', 'funding_APP-2026-001084.pdf', 'funding_APP-2026-001084.pdf', 'application/pdf', 3432530, 'uploads/documents/funding_APP-2026-001084.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 96, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001084';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Cancer Incidence Patterns in Yemen Based on National Registry (96-1)', 'budget_APP-2026-001084.xlsx', 'budget_APP-2026-001084.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 38858, 'uploads/documents/budget_APP-2026-001084.xlsx', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 96, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001084';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Cancer Incidence Patterns in Yemen Based on National Registry (96-1) (موافقة)', 'ethics_decision_APP-2026-001084.pdf', 'ethics_decision_APP-2026-001084.pdf', 'application/pdf', 3531290, 'uploads/documents/ethics_decision_APP-2026-001084.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 96, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001084';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Cancer Incidence Patterns in Yemen Based on National Registry (96-1)', 'certificate_APP-2026-001084.pdf', 'certificate_APP-2026-001084.pdf', 'application/pdf', 3580670, 'uploads/documents/certificate_APP-2026-001084.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 96, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001084';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Cancer Incidence Patterns in Yemen Based on National Registry (96-1)', 'data_collection_APP-2026-001084.xlsx', 'data_collection_APP-2026-001084.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 52190, 'uploads/documents/data_collection_APP-2026-001084.xlsx', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 96, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001084';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Impact of Health Insurance Policies on Access to Curative Services', 'protocol_v1_APP-2026-001085.pdf', 'protocol_v1_APP-2026-001085.pdf', 'application/pdf', 3123905, 'uploads/documents/protocol_v1_APP-2026-001085.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 96, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001085';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Impact of Health Insurance Policies on Access to Curative Services', 'icf_APP-2026-001085.pdf', 'icf_APP-2026-001085.pdf', 'application/pdf', 3173285, 'uploads/documents/icf_APP-2026-001085.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 96, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001085';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001085.pdf', 'cv_pi_APP-2026-001085.pdf', 'application/pdf', 3222665, 'uploads/documents/cv_pi_APP-2026-001085.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 96, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001085';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Impact of Health Insurance Policies on Access to Curative Services', 'pis_APP-2026-001085.pdf', 'pis_APP-2026-001085.pdf', 'application/pdf', 3272045, 'uploads/documents/pis_APP-2026-001085.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 96, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001085';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Impact of Health Insurance Policies on Access to Curative Services (إعادة للمراجعة)', 'return_APP-2026-001085.pdf', 'return_APP-2026-001085.pdf', 'application/pdf', 3321425, 'uploads/documents/return_APP-2026-001085.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 96, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001085';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Asthma Prevalence Among Children in Industrial Areas (96-3)', 'protocol_v1_APP-2026-001086.pdf', 'protocol_v1_APP-2026-001086.pdf', 'application/pdf', 3160940, 'uploads/documents/protocol_v1_APP-2026-001086.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 96, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001086';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Asthma Prevalence Among Children in Industrial Areas (96-3) (النسخة المعدلة)', 'protocol_v2_APP-2026-001086.pdf', 'protocol_v2_APP-2026-001086.pdf', 'application/pdf', 3210320, 'uploads/documents/protocol_v2_APP-2026-001086.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 96, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001086';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Asthma Prevalence Among Children in Industrial Areas (96-3)', 'icf_ar_APP-2026-001086.pdf', 'icf_ar_APP-2026-001086.pdf', 'application/pdf', 3259700, 'uploads/documents/icf_ar_APP-2026-001086.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 96, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001086';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Asthma Prevalence Among Children in Industrial Areas (96-3)', 'icf_en_APP-2026-001086.pdf', 'icf_en_APP-2026-001086.pdf', 'application/pdf', 3309080, 'uploads/documents/icf_en_APP-2026-001086.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 96, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001086';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001086.pdf', 'cv_pi_APP-2026-001086.pdf', 'application/pdf', 3358460, 'uploads/documents/cv_pi_APP-2026-001086.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 96, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001086';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001086.pdf', 'cv_coi_APP-2026-001086.pdf', 'application/pdf', 3407840, 'uploads/documents/cv_coi_APP-2026-001086.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 96, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001086';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Asthma Prevalence Among Children in Industrial Areas (96-3)', 'pis_APP-2026-001086.pdf', 'pis_APP-2026-001086.pdf', 'application/pdf', 3457220, 'uploads/documents/pis_APP-2026-001086.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 96, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001086';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Asthma Prevalence Among Children in Industrial Areas (96-3)', 'irb_approval_APP-2026-001086.pdf', 'irb_approval_APP-2026-001086.pdf', 'application/pdf', 3506600, 'uploads/documents/irb_approval_APP-2026-001086.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 96, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001086';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Asthma Prevalence Among Children in Industrial Areas (96-3)', 'funding_APP-2026-001086.pdf', 'funding_APP-2026-001086.pdf', 'application/pdf', 3555980, 'uploads/documents/funding_APP-2026-001086.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 96, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001086';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Asthma Prevalence Among Children in Industrial Areas (96-3)', 'budget_APP-2026-001086.xlsx', 'budget_APP-2026-001086.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 49968, 'uploads/documents/budget_APP-2026-001086.xlsx', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 96, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001086';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Asthma Prevalence Among Children in Industrial Areas (96-3) (موافقة)', 'ethics_decision_APP-2026-001086.pdf', 'ethics_decision_APP-2026-001086.pdf', 'application/pdf', 3654740, 'uploads/documents/ethics_decision_APP-2026-001086.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 96, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001086';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Asthma Prevalence Among Children in Industrial Areas (96-3)', 'certificate_APP-2026-001086.pdf', 'certificate_APP-2026-001086.pdf', 'application/pdf', 3704120, 'uploads/documents/certificate_APP-2026-001086.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 96, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001086';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Asthma Prevalence Among Children in Industrial Areas (96-3)', 'final_report_APP-2026-001086.pdf', 'final_report_APP-2026-001086.pdf', 'application/pdf', 3753500, 'uploads/documents/final_report_APP-2026-001086.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 96, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001086';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Asthma Prevalence Among Children in Industrial Areas (96-3)', 'data_collection_APP-2026-001086.xlsx', 'data_collection_APP-2026-001086.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 67744, 'uploads/documents/data_collection_APP-2026-001086.xlsx', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 96, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001086';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'منشور علمي - Asthma Prevalence Among Children in Industrial Areas (96-3)', 'publication_APP-2026-001086.pdf', 'publication_APP-2026-001086.pdf', 'application/pdf', 3852260, 'uploads/documents/publication_APP-2026-001086.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 96, a.created_at + interval '113 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PUBLICATION'
AND a.application_number = 'APP-2026-001086';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Assessment of Neonatal Care Services in Intensive Care Units', 'protocol_v1_APP-2026-001087.pdf', 'protocol_v1_APP-2026-001087.pdf', 'application/pdf', 3197975, 'uploads/documents/protocol_v1_APP-2026-001087.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 96, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001087';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Assessment of Neonatal Care Services in Intensive Care Units', 'icf_ar_APP-2026-001087.pdf', 'icf_ar_APP-2026-001087.pdf', 'application/pdf', 3247355, 'uploads/documents/icf_ar_APP-2026-001087.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 96, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001087';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001087.pdf', 'cv_pi_APP-2026-001087.pdf', 'application/pdf', 3296735, 'uploads/documents/cv_pi_APP-2026-001087.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 96, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001087';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Assessment of Neonatal Care Services in Intensive Care Units', 'pis_APP-2026-001087.pdf', 'pis_APP-2026-001087.pdf', 'application/pdf', 3346115, 'uploads/documents/pis_APP-2026-001087.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 96, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001087';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج تقرير الحالة - Assessment of Neonatal Care Services in Intensive Care Units', 'crf_APP-2026-001087.pdf', 'crf_APP-2026-001087.pdf', 'application/pdf', 3395495, 'uploads/documents/crf_APP-2026-001087.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 96, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CRF'
AND a.application_number = 'APP-2026-001087';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Malnutrition Rates Among Under-Five Children in Yemen (96-5)', 'protocol_v1_APP-2026-001088.pdf', 'protocol_v1_APP-2026-001088.pdf', 'application/pdf', 3235010, 'uploads/documents/protocol_v1_APP-2026-001088.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 96, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001088';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Malnutrition Rates Among Under-Five Children in Yemen (96-5)', 'icf_ar_APP-2026-001088.pdf', 'icf_ar_APP-2026-001088.pdf', 'application/pdf', 3284390, 'uploads/documents/icf_ar_APP-2026-001088.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 96, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001088';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Malnutrition Rates Among Under-Five Children in Yemen (96-5)', 'icf_en_APP-2026-001088.pdf', 'icf_en_APP-2026-001088.pdf', 'application/pdf', 3333770, 'uploads/documents/icf_en_APP-2026-001088.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 96, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001088';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001088.pdf', 'cv_pi_APP-2026-001088.pdf', 'application/pdf', 3383150, 'uploads/documents/cv_pi_APP-2026-001088.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 96, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001088';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001088.pdf', 'cv_coi_APP-2026-001088.pdf', 'application/pdf', 3432530, 'uploads/documents/cv_coi_APP-2026-001088.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 96, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001088';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Malnutrition Rates Among Under-Five Children in Yemen (96-5)', 'pis_APP-2026-001088.pdf', 'pis_APP-2026-001088.pdf', 'application/pdf', 3481910, 'uploads/documents/pis_APP-2026-001088.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 96, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001088';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Malnutrition Rates Among Under-Five Children in Yemen (96-5)', 'irb_approval_APP-2026-001088.pdf', 'irb_approval_APP-2026-001088.pdf', 'application/pdf', 3531290, 'uploads/documents/irb_approval_APP-2026-001088.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 96, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001088';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Malnutrition Rates Among Under-Five Children in Yemen (96-5)', 'funding_APP-2026-001088.pdf', 'funding_APP-2026-001088.pdf', 'application/pdf', 3580670, 'uploads/documents/funding_APP-2026-001088.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 96, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001088';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Malnutrition Rates Among Under-Five Children in Yemen (96-5)', 'budget_APP-2026-001088.xlsx', 'budget_APP-2026-001088.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 52190, 'uploads/documents/budget_APP-2026-001088.xlsx', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 96, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001088';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Malnutrition Rates Among Under-Five Children in Yemen (96-5) (موافقة)', 'ethics_decision_APP-2026-001088.pdf', 'ethics_decision_APP-2026-001088.pdf', 'application/pdf', 3679430, 'uploads/documents/ethics_decision_APP-2026-001088.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 96, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001088';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Malnutrition Rates Among Under-Five Children in Yemen (96-5)', 'certificate_APP-2026-001088.pdf', 'certificate_APP-2026-001088.pdf', 'application/pdf', 3728810, 'uploads/documents/certificate_APP-2026-001088.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 96, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001088';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Malnutrition Rates Among Under-Five Children in Yemen (96-5)', 'final_report_APP-2026-001088.pdf', 'final_report_APP-2026-001088.pdf', 'application/pdf', 3778190, 'uploads/documents/final_report_APP-2026-001088.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 96, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001088';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Malnutrition Rates Among Under-Five Children in Yemen (96-5)', 'data_collection_APP-2026-001088.xlsx', 'data_collection_APP-2026-001088.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 69966, 'uploads/documents/data_collection_APP-2026-001088.xlsx', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 96, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001088';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'منشور علمي - Malnutrition Rates Among Under-Five Children in Yemen (96-5)', 'publication_APP-2026-001088.pdf', 'publication_APP-2026-001088.pdf', 'application/pdf', 3876950, 'uploads/documents/publication_APP-2026-001088.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 96, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PUBLICATION'
AND a.application_number = 'APP-2026-001088';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas', 'protocol_v1_APP-2026-001089.pdf', 'protocol_v1_APP-2026-001089.pdf', 'application/pdf', 3272045, 'uploads/documents/protocol_v1_APP-2026-001089.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 2, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001089';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas (النسخة المعدلة)', 'protocol_v2_APP-2026-001089.pdf', 'protocol_v2_APP-2026-001089.pdf', 'application/pdf', 3321425, 'uploads/documents/protocol_v2_APP-2026-001089.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 2, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001089';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas', 'icf_ar_APP-2026-001089.pdf', 'icf_ar_APP-2026-001089.pdf', 'application/pdf', 3370805, 'uploads/documents/icf_ar_APP-2026-001089.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 2, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001089';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas', 'icf_en_APP-2026-001089.pdf', 'icf_en_APP-2026-001089.pdf', 'application/pdf', 3420185, 'uploads/documents/icf_en_APP-2026-001089.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 2, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001089';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001089.pdf', 'cv_pi_APP-2026-001089.pdf', 'application/pdf', 3469565, 'uploads/documents/cv_pi_APP-2026-001089.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 2, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001089';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001089.pdf', 'cv_coi_APP-2026-001089.pdf', 'application/pdf', 3518945, 'uploads/documents/cv_coi_APP-2026-001089.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 2, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001089';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas', 'pis_APP-2026-001089.pdf', 'pis_APP-2026-001089.pdf', 'application/pdf', 3568325, 'uploads/documents/pis_APP-2026-001089.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 2, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001089';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas', 'irb_approval_APP-2026-001089.pdf', 'irb_approval_APP-2026-001089.pdf', 'application/pdf', 3617705, 'uploads/documents/irb_approval_APP-2026-001089.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 2, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001089';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas', 'funding_APP-2026-001089.pdf', 'funding_APP-2026-001089.pdf', 'application/pdf', 3667085, 'uploads/documents/funding_APP-2026-001089.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 2, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001089';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas', 'budget_APP-2026-001089.xlsx', 'budget_APP-2026-001089.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 59967, 'uploads/documents/budget_APP-2026-001089.xlsx', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 2, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001089';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas (موافقة)', 'ethics_decision_APP-2026-001089.pdf', 'ethics_decision_APP-2026-001089.pdf', 'application/pdf', 3765845, 'uploads/documents/ethics_decision_APP-2026-001089.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 2, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001089';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas', 'certificate_APP-2026-001089.pdf', 'certificate_APP-2026-001089.pdf', 'application/pdf', 3815225, 'uploads/documents/certificate_APP-2026-001089.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 2, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001089';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas', 'data_collection_APP-2026-001089.xlsx', 'data_collection_APP-2026-001089.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 73299, 'uploads/documents/data_collection_APP-2026-001089.xlsx', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 2, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001089';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Genetic Factors Associated with Type 1 Diabetes Mellitus (3-0) (مسودة)', 'protocol_draft_APP-2026-001090.pdf', 'protocol_draft_APP-2026-001090.pdf', 'application/pdf', 3309080, 'uploads/documents/protocol_draft_APP-2026-001090.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 3, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001090';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Genetic Factors Associated with Type 1 Diabetes Mellitus (3-0) (مسودة)', 'icf_draft_APP-2026-001090.pdf', 'icf_draft_APP-2026-001090.pdf', 'application/pdf', 3358460, 'uploads/documents/icf_draft_APP-2026-001090.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 3, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001090';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001090.pdf', 'cv_pi_APP-2026-001090.pdf', 'application/pdf', 3407840, 'uploads/documents/cv_pi_APP-2026-001090.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 3, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001090';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001091.pdf', 'cv_pi_APP-2026-001091.pdf', 'application/pdf', 3346115, 'uploads/documents/cv_pi_APP-2026-001091.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 6, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001091';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Cardiovascular Disease Surveillance in Urban Areas (6-1)', 'protocol_v1_APP-2026-001092.pdf', 'protocol_v1_APP-2026-001092.pdf', 'application/pdf', 3383150, 'uploads/documents/protocol_v1_APP-2026-001092.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 6, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001092';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Cardiovascular Disease Surveillance in Urban Areas (6-1) (النسخة المعدلة)', 'protocol_v2_APP-2026-001092.pdf', 'protocol_v2_APP-2026-001092.pdf', 'application/pdf', 3432530, 'uploads/documents/protocol_v2_APP-2026-001092.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 6, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001092';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Cardiovascular Disease Surveillance in Urban Areas (6-1)', 'icf_ar_APP-2026-001092.pdf', 'icf_ar_APP-2026-001092.pdf', 'application/pdf', 3481910, 'uploads/documents/icf_ar_APP-2026-001092.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 6, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001092';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Cardiovascular Disease Surveillance in Urban Areas (6-1)', 'icf_en_APP-2026-001092.pdf', 'icf_en_APP-2026-001092.pdf', 'application/pdf', 3531290, 'uploads/documents/icf_en_APP-2026-001092.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 6, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001092';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001092.pdf', 'cv_pi_APP-2026-001092.pdf', 'application/pdf', 3580670, 'uploads/documents/cv_pi_APP-2026-001092.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 6, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001092';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001092.pdf', 'cv_coi_APP-2026-001092.pdf', 'application/pdf', 3630050, 'uploads/documents/cv_coi_APP-2026-001092.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 6, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001092';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Cardiovascular Disease Surveillance in Urban Areas (6-1)', 'pis_APP-2026-001092.pdf', 'pis_APP-2026-001092.pdf', 'application/pdf', 3679430, 'uploads/documents/pis_APP-2026-001092.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 6, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001092';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Cardiovascular Disease Surveillance in Urban Areas (6-1)', 'irb_approval_APP-2026-001092.pdf', 'irb_approval_APP-2026-001092.pdf', 'application/pdf', 3728810, 'uploads/documents/irb_approval_APP-2026-001092.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 6, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001092';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Cardiovascular Disease Surveillance in Urban Areas (6-1)', 'funding_APP-2026-001092.pdf', 'funding_APP-2026-001092.pdf', 'application/pdf', 3778190, 'uploads/documents/funding_APP-2026-001092.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 6, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001092';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Cardiovascular Disease Surveillance in Urban Areas (6-1)', 'budget_APP-2026-001092.xlsx', 'budget_APP-2026-001092.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 69966, 'uploads/documents/budget_APP-2026-001092.xlsx', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 6, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001092';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Cardiovascular Disease Surveillance in Urban Areas (6-1) (موافقة)', 'ethics_decision_APP-2026-001092.pdf', 'ethics_decision_APP-2026-001092.pdf', 'application/pdf', 3876950, 'uploads/documents/ethics_decision_APP-2026-001092.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 6, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001092';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Cardiovascular Disease Surveillance in Urban Areas (6-1)', 'certificate_APP-2026-001092.pdf', 'certificate_APP-2026-001092.pdf', 'application/pdf', 3926330, 'uploads/documents/certificate_APP-2026-001092.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 6, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001092';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Cardiovascular Disease Surveillance in Urban Areas (6-1)', 'data_collection_APP-2026-001092.xlsx', 'data_collection_APP-2026-001092.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 83298, 'uploads/documents/data_collection_APP-2026-001092.xlsx', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 6, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001092';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Evaluation of Family Planning Programs in Remote Areas (7-0)', 'protocol_v1_APP-2026-001093.pdf', 'protocol_v1_APP-2026-001093.pdf', 'application/pdf', 3420185, 'uploads/documents/protocol_v1_APP-2026-001093.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 7, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001093';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Evaluation of Family Planning Programs in Remote Areas (7-0)', 'icf_APP-2026-001093.pdf', 'icf_APP-2026-001093.pdf', 'application/pdf', 3469565, 'uploads/documents/icf_APP-2026-001093.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 7, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001093';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001093.pdf', 'cv_pi_APP-2026-001093.pdf', 'application/pdf', 3518945, 'uploads/documents/cv_pi_APP-2026-001093.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 7, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001093';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Evaluation of Family Planning Programs in Remote Areas (7-0)', 'pis_APP-2026-001093.pdf', 'pis_APP-2026-001093.pdf', 'application/pdf', 3568325, 'uploads/documents/pis_APP-2026-001093.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 7, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001093';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Evaluation of Family Planning Programs in Remote Areas (7-0)', 'proposal_APP-2026-001093.pdf', 'proposal_APP-2026-001093.pdf', 'application/pdf', 3617705, 'uploads/documents/proposal_APP-2026-001093.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 7, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2026-001093';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب سحب الطلب - Evaluation of Family Planning Programs in Remote Areas (7-0)', 'withdrawal_APP-2026-001093.pdf', 'withdrawal_APP-2026-001093.pdf', 'application/pdf', 3667085, 'uploads/documents/withdrawal_APP-2026-001093.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 7, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'OTHER'
AND a.application_number = 'APP-2026-001093';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Evaluation of Cancer Registry System in Yemen', 'protocol_v1_APP-2026-001094.pdf', 'protocol_v1_APP-2026-001094.pdf', 'application/pdf', 3457220, 'uploads/documents/protocol_v1_APP-2026-001094.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 7, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001094';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة - Evaluation of Cancer Registry System in Yemen', 'icf_APP-2026-001094.pdf', 'icf_APP-2026-001094.pdf', 'application/pdf', 3506600, 'uploads/documents/icf_APP-2026-001094.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 7, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001094';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001094.pdf', 'cv_pi_APP-2026-001094.pdf', 'application/pdf', 3555980, 'uploads/documents/cv_pi_APP-2026-001094.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 7, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001094';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Evaluation of Cancer Registry System in Yemen', 'pis_APP-2026-001094.pdf', 'pis_APP-2026-001094.pdf', 'application/pdf', 3605360, 'uploads/documents/pis_APP-2026-001094.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 7, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001094';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'مقترح الدراسة - Evaluation of Cancer Registry System in Yemen', 'proposal_APP-2026-001094.pdf', 'proposal_APP-2026-001094.pdf', 'application/pdf', 3654740, 'uploads/documents/proposal_APP-2026-001094.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 7, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'STUDY_PROPOSAL'
AND a.application_number = 'APP-2026-001094';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب سحب الطلب - Evaluation of Cancer Registry System in Yemen', 'withdrawal_APP-2026-001094.pdf', 'withdrawal_APP-2026-001094.pdf', 'application/pdf', 3704120, 'uploads/documents/withdrawal_APP-2026-001094.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 7, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'OTHER'
AND a.application_number = 'APP-2026-001094';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'protocol_v1_APP-2026-001095.pdf', 'protocol_v1_APP-2026-001095.pdf', 'application/pdf', 3494255, 'uploads/documents/protocol_v1_APP-2026-001095.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 75, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001095';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (النسخة المعدلة)', 'protocol_v2_APP-2026-001095.pdf', 'protocol_v2_APP-2026-001095.pdf', 'application/pdf', 3543635, 'uploads/documents/protocol_v2_APP-2026-001095.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 75, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001095';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'icf_ar_APP-2026-001095.pdf', 'icf_ar_APP-2026-001095.pdf', 'application/pdf', 3593015, 'uploads/documents/icf_ar_APP-2026-001095.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 75, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001095';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'icf_en_APP-2026-001095.pdf', 'icf_en_APP-2026-001095.pdf', 'application/pdf', 3642395, 'uploads/documents/icf_en_APP-2026-001095.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 75, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001095';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001095.pdf', 'cv_pi_APP-2026-001095.pdf', 'application/pdf', 3691775, 'uploads/documents/cv_pi_APP-2026-001095.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 75, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001095';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001095.pdf', 'cv_coi_APP-2026-001095.pdf', 'application/pdf', 3741155, 'uploads/documents/cv_coi_APP-2026-001095.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 75, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001095';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'pis_APP-2026-001095.pdf', 'pis_APP-2026-001095.pdf', 'application/pdf', 3790535, 'uploads/documents/pis_APP-2026-001095.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 75, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001095';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'irb_approval_APP-2026-001095.pdf', 'irb_approval_APP-2026-001095.pdf', 'application/pdf', 3839915, 'uploads/documents/irb_approval_APP-2026-001095.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 75, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001095';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'funding_APP-2026-001095.pdf', 'funding_APP-2026-001095.pdf', 'application/pdf', 3889295, 'uploads/documents/funding_APP-2026-001095.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 75, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001095';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'budget_APP-2026-001095.xlsx', 'budget_APP-2026-001095.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 79965, 'uploads/documents/budget_APP-2026-001095.xlsx', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 75, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001095';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (موافقة)', 'ethics_decision_APP-2026-001095.pdf', 'ethics_decision_APP-2026-001095.pdf', 'application/pdf', 3988055, 'uploads/documents/ethics_decision_APP-2026-001095.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 75, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001095';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'certificate_APP-2026-001095.pdf', 'certificate_APP-2026-001095.pdf', 'application/pdf', 4037435, 'uploads/documents/certificate_APP-2026-001095.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 75, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001095';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'data_collection_APP-2026-001095.xlsx', 'data_collection_APP-2026-001095.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 93297, 'uploads/documents/data_collection_APP-2026-001095.xlsx', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 75, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001095';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'حزمة التعديل - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'amendment_APP-2026-001095.pdf', 'amendment_APP-2026-001095.pdf', 'application/pdf', 4136195, 'uploads/documents/amendment_APP-2026-001095.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 75, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'AMENDMENT_PKG'
AND a.application_number = 'APP-2026-001095';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث المعدل - Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients', 'protocol_amendment_APP-2026-001095.pdf', 'protocol_amendment_APP-2026-001095.pdf', 'application/pdf', 4185575, 'uploads/documents/protocol_amendment_APP-2026-001095.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 75, a.created_at + interval '113 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001095';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Genetic Diversity of Hepatitis B Virus in Yemen', 'protocol_v1_APP-2026-001096.pdf', 'protocol_v1_APP-2026-001096.pdf', 'application/pdf', 3531290, 'uploads/documents/protocol_v1_APP-2026-001096.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 92, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001096';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Genetic Diversity of Hepatitis B Virus in Yemen', 'icf_ar_APP-2026-001096.pdf', 'icf_ar_APP-2026-001096.pdf', 'application/pdf', 3580670, 'uploads/documents/icf_ar_APP-2026-001096.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 92, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001096';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Genetic Diversity of Hepatitis B Virus in Yemen', 'icf_en_APP-2026-001096.pdf', 'icf_en_APP-2026-001096.pdf', 'application/pdf', 3630050, 'uploads/documents/icf_en_APP-2026-001096.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 92, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001096';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001096.pdf', 'cv_pi_APP-2026-001096.pdf', 'application/pdf', 3679430, 'uploads/documents/cv_pi_APP-2026-001096.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 92, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001096';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001096.pdf', 'cv_coi_APP-2026-001096.pdf', 'application/pdf', 3728810, 'uploads/documents/cv_coi_APP-2026-001096.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 92, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001096';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Genetic Diversity of Hepatitis B Virus in Yemen', 'pis_APP-2026-001096.pdf', 'pis_APP-2026-001096.pdf', 'application/pdf', 3778190, 'uploads/documents/pis_APP-2026-001096.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 92, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001096';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Genetic Diversity of Hepatitis B Virus in Yemen', 'irb_approval_APP-2026-001096.pdf', 'irb_approval_APP-2026-001096.pdf', 'application/pdf', 3827570, 'uploads/documents/irb_approval_APP-2026-001096.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 92, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001096';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Genetic Diversity of Hepatitis B Virus in Yemen', 'funding_APP-2026-001096.pdf', 'funding_APP-2026-001096.pdf', 'application/pdf', 3876950, 'uploads/documents/funding_APP-2026-001096.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 92, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001096';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Genetic Diversity of Hepatitis B Virus in Yemen', 'budget_APP-2026-001096.xlsx', 'budget_APP-2026-001096.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 78854, 'uploads/documents/budget_APP-2026-001096.xlsx', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 92, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001096';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Genetic Diversity of Hepatitis B Virus in Yemen (موافقة)', 'ethics_decision_APP-2026-001096.pdf', 'ethics_decision_APP-2026-001096.pdf', 'application/pdf', 3975710, 'uploads/documents/ethics_decision_APP-2026-001096.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 92, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001096';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Genetic Diversity of Hepatitis B Virus in Yemen', 'certificate_APP-2026-001096.pdf', 'certificate_APP-2026-001096.pdf', 'application/pdf', 4025090, 'uploads/documents/certificate_APP-2026-001096.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 92, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001096';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Genetic Diversity of Hepatitis B Virus in Yemen', 'final_report_APP-2026-001096.pdf', 'final_report_APP-2026-001096.pdf', 'application/pdf', 4074470, 'uploads/documents/final_report_APP-2026-001096.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 92, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001096';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Genetic Diversity of Hepatitis B Virus in Yemen', 'data_collection_APP-2026-001096.xlsx', 'data_collection_APP-2026-001096.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 96630, 'uploads/documents/data_collection_APP-2026-001096.xlsx', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 92, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001096';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'منشور علمي - Genetic Diversity of Hepatitis B Virus in Yemen', 'publication_APP-2026-001096.pdf', 'publication_APP-2026-001096.pdf', 'application/pdf', 4173230, 'uploads/documents/publication_APP-2026-001096.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 92, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PUBLICATION'
AND a.application_number = 'APP-2026-001096';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'حزمة التعديل - Genetic Diversity of Hepatitis B Virus in Yemen', 'amendment_APP-2026-001096.pdf', 'amendment_APP-2026-001096.pdf', 'application/pdf', 4222610, 'uploads/documents/amendment_APP-2026-001096.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 92, a.created_at + interval '113 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'AMENDMENT_PKG'
AND a.application_number = 'APP-2026-001096';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث المعدل - Genetic Diversity of Hepatitis B Virus in Yemen', 'protocol_amendment_APP-2026-001096.pdf', 'protocol_amendment_APP-2026-001096.pdf', 'application/pdf', 4271990, 'uploads/documents/protocol_amendment_APP-2026-001096.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 92, a.created_at + interval '121 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001096';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'protocol_v1_APP-2026-001097.pdf', 'protocol_v1_APP-2026-001097.pdf', 'application/pdf', 3568325, 'uploads/documents/protocol_v1_APP-2026-001097.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 77, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001097';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'icf_ar_APP-2026-001097.pdf', 'icf_ar_APP-2026-001097.pdf', 'application/pdf', 3617705, 'uploads/documents/icf_ar_APP-2026-001097.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 77, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001097';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'icf_en_APP-2026-001097.pdf', 'icf_en_APP-2026-001097.pdf', 'application/pdf', 3667085, 'uploads/documents/icf_en_APP-2026-001097.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 77, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001097';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001097.pdf', 'cv_pi_APP-2026-001097.pdf', 'application/pdf', 3716465, 'uploads/documents/cv_pi_APP-2026-001097.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 77, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001097';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001097.pdf', 'cv_coi_APP-2026-001097.pdf', 'application/pdf', 3765845, 'uploads/documents/cv_coi_APP-2026-001097.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 77, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001097';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'pis_APP-2026-001097.pdf', 'pis_APP-2026-001097.pdf', 'application/pdf', 3815225, 'uploads/documents/pis_APP-2026-001097.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 77, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001097';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'irb_approval_APP-2026-001097.pdf', 'irb_approval_APP-2026-001097.pdf', 'application/pdf', 3864605, 'uploads/documents/irb_approval_APP-2026-001097.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 77, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001097';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'funding_APP-2026-001097.pdf', 'funding_APP-2026-001097.pdf', 'application/pdf', 3913985, 'uploads/documents/funding_APP-2026-001097.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 77, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001097';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'budget_APP-2026-001097.xlsx', 'budget_APP-2026-001097.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 82187, 'uploads/documents/budget_APP-2026-001097.xlsx', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 77, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001097';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Burden of Non-Communicable Diseases in Urban and Rural Areas (موافقة)', 'ethics_decision_APP-2026-001097.pdf', 'ethics_decision_APP-2026-001097.pdf', 'application/pdf', 4012745, 'uploads/documents/ethics_decision_APP-2026-001097.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 77, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001097';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'certificate_APP-2026-001097.pdf', 'certificate_APP-2026-001097.pdf', 'application/pdf', 4062125, 'uploads/documents/certificate_APP-2026-001097.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 77, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001097';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'final_report_APP-2026-001097.pdf', 'final_report_APP-2026-001097.pdf', 'application/pdf', 4111505, 'uploads/documents/final_report_APP-2026-001097.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 77, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001097';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'data_collection_APP-2026-001097.xlsx', 'data_collection_APP-2026-001097.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 99963, 'uploads/documents/data_collection_APP-2026-001097.xlsx', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 77, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001097';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'حزمة التعديل - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'amendment_APP-2026-001097.pdf', 'amendment_APP-2026-001097.pdf', 'application/pdf', 4210265, 'uploads/documents/amendment_APP-2026-001097.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 77, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'AMENDMENT_PKG'
AND a.application_number = 'APP-2026-001097';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث المعدل - Burden of Non-Communicable Diseases in Urban and Rural Areas', 'protocol_amendment_APP-2026-001097.pdf', 'protocol_amendment_APP-2026-001097.pdf', 'application/pdf', 4259645, 'uploads/documents/protocol_amendment_APP-2026-001097.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 77, a.created_at + interval '113 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001097';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas', 'protocol_v1_APP-2026-001098.pdf', 'protocol_v1_APP-2026-001098.pdf', 'application/pdf', 3605360, 'uploads/documents/protocol_v1_APP-2026-001098.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 2, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001098';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas', 'icf_ar_APP-2026-001098.pdf', 'icf_ar_APP-2026-001098.pdf', 'application/pdf', 3654740, 'uploads/documents/icf_ar_APP-2026-001098.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 2, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001098';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas', 'icf_en_APP-2026-001098.pdf', 'icf_en_APP-2026-001098.pdf', 'application/pdf', 3704120, 'uploads/documents/icf_en_APP-2026-001098.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 2, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001098';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001098.pdf', 'cv_pi_APP-2026-001098.pdf', 'application/pdf', 3753500, 'uploads/documents/cv_pi_APP-2026-001098.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 2, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001098';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas', 'pis_APP-2026-001098.pdf', 'pis_APP-2026-001098.pdf', 'application/pdf', 3802880, 'uploads/documents/pis_APP-2026-001098.pdf', '741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da', 2, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001098';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas', 'irb_approval_APP-2026-001098.pdf', 'irb_approval_APP-2026-001098.pdf', 'application/pdf', 3852260, 'uploads/documents/irb_approval_APP-2026-001098.pdf', '30da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc96', 2, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001098';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas (موافقة مشروطة)', 'conditional_approval_APP-2026-001098.pdf', 'conditional_approval_APP-2026-001098.pdf', 'application/pdf', 3901640, 'uploads/documents/conditional_approval_APP-2026-001098.pdf', 'fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852', 2, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001098';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'إثبات استيفاء الشروط - Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas (مرفوض)', 'evidence_rejected_APP-2026-001098.pdf', 'evidence_rejected_APP-2026-001098.pdf', 'application/pdf', 3951020, 'uploads/documents/evidence_rejected_APP-2026-001098.pdf', 'b852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741e', 2, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'EVIDENCE_DOC'
AND a.application_number = 'APP-2026-001098';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Prevalence of Hepatitis B and C Among Blood Donors (94-1)', 'protocol_v1_APP-2026-001099.pdf', 'protocol_v1_APP-2026-001099.pdf', 'application/pdf', 3642395, 'uploads/documents/protocol_v1_APP-2026-001099.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 94, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001099';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Prevalence of Hepatitis B and C Among Blood Donors (94-1)', 'icf_ar_APP-2026-001099.pdf', 'icf_ar_APP-2026-001099.pdf', 'application/pdf', 3691775, 'uploads/documents/icf_ar_APP-2026-001099.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 94, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001099';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Prevalence of Hepatitis B and C Among Blood Donors (94-1)', 'icf_en_APP-2026-001099.pdf', 'icf_en_APP-2026-001099.pdf', 'application/pdf', 3741155, 'uploads/documents/icf_en_APP-2026-001099.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 94, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001099';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001099.pdf', 'cv_pi_APP-2026-001099.pdf', 'application/pdf', 3790535, 'uploads/documents/cv_pi_APP-2026-001099.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 94, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001099';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Prevalence of Hepatitis B and C Among Blood Donors (94-1)', 'pis_APP-2026-001099.pdf', 'pis_APP-2026-001099.pdf', 'application/pdf', 3839915, 'uploads/documents/pis_APP-2026-001099.pdf', '41eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da7', 94, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001099';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Prevalence of Hepatitis B and C Among Blood Donors (94-1)', 'irb_approval_APP-2026-001099.pdf', 'irb_approval_APP-2026-001099.pdf', 'application/pdf', 3889295, 'uploads/documents/irb_approval_APP-2026-001099.pdf', '0da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc963', 94, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001099';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Prevalence of Hepatitis B and C Among Blood Donors (94-1) (موافقة مشروطة)', 'conditional_approval_APP-2026-001099.pdf', 'conditional_approval_APP-2026-001099.pdf', 'application/pdf', 3938675, 'uploads/documents/conditional_approval_APP-2026-001099.pdf', 'c9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f', 94, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001099';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'إثبات استيفاء الشروط - Prevalence of Hepatitis B and C Among Blood Donors (94-1)', 'evidence_APP-2026-001099.pdf', 'evidence_APP-2026-001099.pdf', 'application/pdf', 3988055, 'uploads/documents/evidence_APP-2026-001099.pdf', '852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb', 94, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'EVIDENCE_DOC'
AND a.application_number = 'APP-2026-001099';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Injury Patterns from Road Traffic Accidents in Sana''a (96-0)', 'protocol_v1_APP-2026-001100.pdf', 'protocol_v1_APP-2026-001100.pdf', 'application/pdf', 3679430, 'uploads/documents/protocol_v1_APP-2026-001100.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 96, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001100';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Injury Patterns from Road Traffic Accidents in Sana''a (96-0)', 'icf_ar_APP-2026-001100.pdf', 'icf_ar_APP-2026-001100.pdf', 'application/pdf', 3728810, 'uploads/documents/icf_ar_APP-2026-001100.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 96, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001100';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Injury Patterns from Road Traffic Accidents in Sana''a (96-0)', 'icf_en_APP-2026-001100.pdf', 'icf_en_APP-2026-001100.pdf', 'application/pdf', 3778190, 'uploads/documents/icf_en_APP-2026-001100.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 96, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001100';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001100.pdf', 'cv_pi_APP-2026-001100.pdf', 'application/pdf', 3827570, 'uploads/documents/cv_pi_APP-2026-001100.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 96, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001100';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Injury Patterns from Road Traffic Accidents in Sana''a (96-0)', 'pis_APP-2026-001100.pdf', 'pis_APP-2026-001100.pdf', 'application/pdf', 3876950, 'uploads/documents/pis_APP-2026-001100.pdf', '1eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da74', 96, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001100';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Injury Patterns from Road Traffic Accidents in Sana''a (96-0)', 'irb_approval_APP-2026-001100.pdf', 'irb_approval_APP-2026-001100.pdf', 'application/pdf', 3926330, 'uploads/documents/irb_approval_APP-2026-001100.pdf', 'da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630', 96, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001100';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Injury Patterns from Road Traffic Accidents in Sana''a (96-0) (موافقة مشروطة)', 'conditional_approval_APP-2026-001100.pdf', 'conditional_approval_APP-2026-001100.pdf', 'application/pdf', 3975710, 'uploads/documents/conditional_approval_APP-2026-001100.pdf', '9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc', 96, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001100';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'إثبات استيفاء الشروط - Injury Patterns from Road Traffic Accidents in Sana''a (96-0)', 'evidence_APP-2026-001100.pdf', 'evidence_APP-2026-001100.pdf', 'application/pdf', 4025090, 'uploads/documents/evidence_APP-2026-001100.pdf', '52fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb8', 96, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'EVIDENCE_DOC'
AND a.application_number = 'APP-2026-001100';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'protocol_v1_APP-2026-001101.pdf', 'protocol_v1_APP-2026-001101.pdf', 'application/pdf', 3716465, 'uploads/documents/protocol_v1_APP-2026-001101.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 93, a.created_at + interval '1 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001101';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نموذج الموافقة المستنيرة (عربي) - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'icf_ar_APP-2026-001101.pdf', 'icf_ar_APP-2026-001101.pdf', 'application/pdf', 3765845, 'uploads/documents/icf_ar_APP-2026-001101.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 93, a.created_at + interval '9 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001101';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'Informed Consent Form (English) - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'icf_en_APP-2026-001101.pdf', 'icf_en_APP-2026-001101.pdf', 'application/pdf', 3815225, 'uploads/documents/icf_en_APP-2026-001101.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 93, a.created_at + interval '17 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ICF'
AND a.application_number = 'APP-2026-001101';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_pi_APP-2026-001101.pdf', 'cv_pi_APP-2026-001101.pdf', 'application/pdf', 3864605, 'uploads/documents/cv_pi_APP-2026-001101.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 93, a.created_at + interval '25 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001101';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'السيرة الذاتية - باحث مشارك', 'cv_coi_APP-2026-001101.pdf', 'cv_coi_APP-2026-001101.pdf', 'application/pdf', 3913985, 'uploads/documents/cv_coi_APP-2026-001101.pdf', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 93, a.created_at + interval '33 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'CV'
AND a.application_number = 'APP-2026-001101';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'نشرة معلومات المشارك - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'pis_APP-2026-001101.pdf', 'pis_APP-2026-001101.pdf', 'application/pdf', 3963365, 'uploads/documents/pis_APP-2026-001101.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 93, a.created_at + interval '41 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PIS'
AND a.application_number = 'APP-2026-001101';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'خطاب موافقة المؤسسة - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'irb_approval_APP-2026-001101.pdf', 'irb_approval_APP-2026-001101.pdf', 'application/pdf', 4012745, 'uploads/documents/irb_approval_APP-2026-001101.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 93, a.created_at + interval '49 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'IRB_APPROVAL'
AND a.application_number = 'APP-2026-001101';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'وثيقة التمويل - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'funding_APP-2026-001101.pdf', 'funding_APP-2026-001101.pdf', 'application/pdf', 4062125, 'uploads/documents/funding_APP-2026-001101.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 93, a.created_at + interval '57 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FUNDING'
AND a.application_number = 'APP-2026-001101';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'الميزانية - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'budget_APP-2026-001101.xlsx', 'budget_APP-2026-001101.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 95519, 'uploads/documents/budget_APP-2026-001101.xlsx', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 93, a.created_at + interval '65 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'BUDGET'
AND a.application_number = 'APP-2026-001101';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'قرار اللجنة - Obesity Prevalence and Its Association with Chronic Diseases in Adults (موافقة)', 'ethics_decision_APP-2026-001101.pdf', 'ethics_decision_APP-2026-001101.pdf', 'application/pdf', 4160885, 'uploads/documents/ethics_decision_APP-2026-001101.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 93, a.created_at + interval '73 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'ETHICS_DECISION'
AND a.application_number = 'APP-2026-001101';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'شهادة الاعتماد - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'certificate_APP-2026-001101.pdf', 'certificate_APP-2026-001101.pdf', 'application/pdf', 4210265, 'uploads/documents/certificate_APP-2026-001101.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 93, a.created_at + interval '81 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'APPROVAL_CERTIFICATE'
AND a.application_number = 'APP-2026-001101';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'التقرير النهائي - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'final_report_APP-2026-001101.pdf', 'final_report_APP-2026-001101.pdf', 'application/pdf', 4259645, 'uploads/documents/final_report_APP-2026-001101.pdf', '2fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb85', 93, a.created_at + interval '89 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'FINAL_REPORT'
AND a.application_number = 'APP-2026-001101';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'أداة جمع البيانات - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'data_collection_APP-2026-001101.xlsx', 'data_collection_APP-2026-001101.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 113295, 'uploads/documents/data_collection_APP-2026-001101.xlsx', 'eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741', 93, a.created_at + interval '97 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'DATA_COLLECTION'
AND a.application_number = 'APP-2026-001101';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'حزمة التعديل - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'amendment_APP-2026-001101.pdf', 'amendment_APP-2026-001101.pdf', 'application/pdf', 4358405, 'uploads/documents/amendment_APP-2026-001101.pdf', 'a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630d', 93, a.created_at + interval '105 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'AMENDMENT_PKG'
AND a.application_number = 'APP-2026-001101';
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, 'بروتوكول البحث المعدل - Obesity Prevalence and Its Association with Chronic Diseases in Adults', 'protocol_amendment_APP-2026-001101.pdf', 'protocol_amendment_APP-2026-001101.pdf', 'application/pdf', 4407785, 'uploads/documents/protocol_amendment_APP-2026-001101.pdf', '630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9', 93, a.created_at + interval '113 hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = 'PROTOCOL'
AND a.application_number = 'APP-2026-001101';
-- =============================================================================
-- 3. DOCUMENT VERSIONS
-- =============================================================================
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original submitted version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2025-001002'
AND d.file_name LIKE '%v1%';
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original submitted version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2025-001009'
AND d.file_name LIKE '%v1%';
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original submitted version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2025-001013'
AND d.file_name LIKE '%v1%';
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2025-001014'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2025-001017'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2025-001018'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2025-001023'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2026-001038'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original submitted version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2026-001042'
AND d.file_name LIKE '%v1%';
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2026-001047'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2026-001053'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2026-001054'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original submitted version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2026-001059'
AND d.file_name LIKE '%v1%';
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2026-001062'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2026-001065'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2026-001070'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2026-001071'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2026-001074'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2026-001080'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2026-001083'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2026-001086'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2026-001089'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2026-001092'
AND d.file_name LIKE '%v1%'
LIMIT 1;
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', 'Original version'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = 'APP-2026-001095'
AND d.file_name LIKE '%v1%'
LIMIT 1;
-- =============================================================================
-- 4. APPROVAL CERTIFICATES
-- =============================================================================
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00000', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '15 days'
FROM core.applications a WHERE a.application_number = 'APP-2025-001002';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00001', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '16 days'
FROM core.applications a WHERE a.application_number = 'APP-2025-001003';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00007', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '22 days'
FROM core.applications a WHERE a.application_number = 'APP-2025-001009';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00008', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '23 days'
FROM core.applications a WHERE a.application_number = 'APP-2025-001010';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00009', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '24 days'
FROM core.applications a WHERE a.application_number = 'APP-2025-001011';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00011', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '26 days'
FROM core.applications a WHERE a.application_number = 'APP-2025-001013';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00012', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '27 days'
FROM core.applications a WHERE a.application_number = 'APP-2025-001014';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00015', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '30 days'
FROM core.applications a WHERE a.application_number = 'APP-2025-001017';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00016', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '31 days'
FROM core.applications a WHERE a.application_number = 'APP-2025-001018';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00017', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '32 days'
FROM core.applications a WHERE a.application_number = 'APP-2025-001019';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00018', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '33 days'
FROM core.applications a WHERE a.application_number = 'APP-2025-001020';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00019', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '34 days'
FROM core.applications a WHERE a.application_number = 'APP-2025-001021';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00021', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '36 days'
FROM core.applications a WHERE a.application_number = 'APP-2025-001023';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00023', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '38 days'
FROM core.applications a WHERE a.application_number = 'APP-2025-001025';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00025', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '40 days'
FROM core.applications a WHERE a.application_number = 'APP-2025-001027';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00026', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '41 days'
FROM core.applications a WHERE a.application_number = 'APP-2025-001028';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00028', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '43 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001030';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00029', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '44 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001031';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00031', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '46 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001033';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00033', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '48 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001035';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00036', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '51 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001038';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00038', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '53 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001040';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00039', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '54 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001041';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00040', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '55 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001042';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00041', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '56 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001043';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00043', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '58 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001045';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00045', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '60 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001047';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00049', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '64 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001051';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00051', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '66 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001053';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00052', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '67 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001054';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00057', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '72 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001059';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00058', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '73 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001060';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00059', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '74 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001061';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00060', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '75 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001062';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00061', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '76 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001063';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00063', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '78 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001065';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00067', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '82 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001069';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00068', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '83 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001070';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00069', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '84 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001071';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00072', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '87 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001074';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00073', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '88 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001075';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00074', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '89 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001076';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00078', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '93 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001080';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00079', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '94 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001081';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00081', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '96 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001083';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00082', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '97 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001084';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00084', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '99 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001086';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00086', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '101 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001088';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00087', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '102 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001089';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00090', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '105 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001092';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00093', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '108 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001095';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2024-00094', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '109 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001096';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00095', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '110 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001097';
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, 'ERC-2025-00099', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '114 days'
FROM core.applications a WHERE a.application_number = 'APP-2026-001101';
-- =============================================================================
-- 5. DOCUMENT ACCESS — REVIEWER GRANTS
-- =============================================================================
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001002'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001002'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001002'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001002'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001003'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001003'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001003'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001003'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001004'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001004'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001004'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001004'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001005'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001005'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001005'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001005'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001006'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001006'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001006'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001006'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001007'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001007'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001007'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001007'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001008'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001008'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001008'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001008'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001009'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001009'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001009'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001009'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001010'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001010'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001010'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001010'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001011'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001011'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001011'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001011'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 11, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001012'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 11);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 12, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001012'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 12);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 13, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001012'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 13);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 14, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001012'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 14);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 15, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001012'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 15);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001013'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001013'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001013'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001013'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001014'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001014'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001014'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001014'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 11, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001015'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 11);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 12, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001015'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 12);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 13, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001015'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 13);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 14, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001015'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 14);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 15, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001015'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 15);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001016'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001016'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001016'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001016'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001017'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001017'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001017'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 11, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001018'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 11);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 12, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001018'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 12);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 13, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001018'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 13);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 14, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001018'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 14);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 15, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001018'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 15);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001019'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001019'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001019'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001019'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001020'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001020'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001020'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001020'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001021'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001021'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001021'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001021'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001022'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001022'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001022'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001022'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001023'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001023'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001023'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001023'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001024'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001024'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001024'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001024'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 31, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001025'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 31);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 32, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001025'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 32);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 33, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001025'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 33);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 34, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001025'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 34);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 31, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001026'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 31);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 32, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001026'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 32);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 33, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001026'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 33);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 34, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001026'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 34);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 31, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001027'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 31);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 32, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001027'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 32);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 33, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001027'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 33);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 34, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001027'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 34);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001028'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001028'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001028'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001028'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001029'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001029'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001029'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001029'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001030'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001030'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001030'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001030'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 11, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001031'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 11);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 12, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001031'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 12);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 13, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001031'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 13);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 14, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001031'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 14);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 15, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001031'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 15);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001032'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001032'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001032'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001032'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001033'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001033'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001033'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001033'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001034'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001034'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001034'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001034'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001035'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001035'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001035'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001035'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 11, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001036'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 11);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 12, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001036'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 12);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 13, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001036'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 13);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 14, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001036'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 14);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 15, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001036'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 15);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001037'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001037'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001037'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001037'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001038'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001038'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001038'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001038'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001039'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001039'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001039'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001039'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001040'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001040'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001040'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001040'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001041'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001041'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001041'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001041'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001042'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001042'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001042'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001042'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001043'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001043'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001043'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 11, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001044'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 11);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 12, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001044'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 12);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 13, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001044'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 13);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 14, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001044'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 14);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 15, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001044'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 15);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001045'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001045'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001045'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001045'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001046'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001046'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001046'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001046'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 22, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001047'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 22);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 23, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001047'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 23);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 24, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001047'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 24);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 25, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001047'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 25);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 22, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001048'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 22);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 23, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001048'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 23);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 24, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001048'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 24);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 25, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001048'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 25);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 22, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001049'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 22);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 23, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001049'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 23);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 24, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001049'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 24);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 25, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001049'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 25);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 11, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001050'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 11);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 12, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001050'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 12);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 13, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001050'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 13);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 14, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001050'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 14);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 15, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001050'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 15);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 36, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001051'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 36);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 37, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001051'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 37);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 38, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001051'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 38);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 36, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001052'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 36);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 37, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001052'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 37);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 38, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001052'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 38);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 36, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001053'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 36);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 37, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001053'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 37);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 38, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001053'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 38);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 36, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001054'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 36);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 37, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001054'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 37);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 38, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001054'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 38);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001055'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001055'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001055'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001056'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001056'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001056'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 11, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001057'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 11);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 12, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001057'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 12);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 13, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001057'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 13);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 14, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001057'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 14);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 15, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001057'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 15);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001058'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001058'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001058'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001058'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001059'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001059'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001059'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001059'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001060'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001060'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001060'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001060'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001061'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001061'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001061'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001062'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001062'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001062'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001063'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001063'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001063'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001064'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001064'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001064'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001065'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001065'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001065'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001066'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001066'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001066'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001067'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001067'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001067'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 11, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001068'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 11);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 12, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001068'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 12);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 13, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001068'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 13);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 14, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001068'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 14);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 15, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001068'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 15);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001069'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001069'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001069'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001070'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001070'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001070'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001071'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001071'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001071'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001072'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001072'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001072'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001073'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001073'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001073'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001074'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001074'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001074'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001075'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001075'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001075'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 11, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001076'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 11);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 12, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001076'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 12);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 13, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001076'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 13);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 14, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001076'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 14);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 15, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001076'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 15);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001077'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001077'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001077'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001078'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001078'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001078'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001079'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001079'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001079'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001080'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001080'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001080'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001081'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001081'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001081'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001082'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001082'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001082'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001083'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001083'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001083'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001083'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001084'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001084'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001084'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001084'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001085'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001085'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001085'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001085'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001086'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001086'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001086'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001086'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001087'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001087'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001087'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001087'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001088'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001088'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001088'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001088'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 11, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001089'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 11);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 12, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001089'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 12);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 13, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001089'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 13);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 14, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001089'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 14);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 15, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001089'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 15);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001090'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001090'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001090'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001091'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001091'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001091'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001091'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001092'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001092'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001092'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001092'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001093'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001093'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001093'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001093'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001094'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001094'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001094'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001094'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001095'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001095'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001095'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001096'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001096'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001096'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001097'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001097'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001097'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001097'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 11, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001098'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 11);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 12, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001098'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 12);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 13, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001098'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 13);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 14, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001098'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 14);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 15, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001098'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 15);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001099'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001099'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001099'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 17, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001100'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 17);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 18, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001100'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 18);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 19, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001100'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 19);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 20, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001100'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 20);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 27, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001101'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 27);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 28, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001101'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 28);
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, 29, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001101'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = 29);
-- =============================================================================
-- 6. RESET SEQUENCES
-- =============================================================================

SELECT setval('documents.documents_id_seq', COALESCE((SELECT MAX(id) FROM documents.documents), 0) + 1, false);
SELECT setval('documents.document_types_id_seq', COALESCE((SELECT MAX(id) FROM documents.document_types), 0) + 1, false);
SELECT setval('documents.document_versions_id_seq', COALESCE((SELECT MAX(id) FROM documents.document_versions), 0) + 1, false);
SELECT setval('documents.document_access_id_seq', COALESCE((SELECT MAX(id) FROM documents.document_access), 0) + 1, false);
SELECT setval('documents.approval_certificates_id_seq', COALESCE((SELECT MAX(id) FROM documents.approval_certificates), 0) + 1, false);

COMMIT;
