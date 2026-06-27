-- ============================================================
-- 01-REFERENCE DATA
-- ============================================================
-- البيانات المرجعية الأساسية: أنواع المؤسسات، التصنيفات، اللغات.
-- تُحمّل هذه البيانات أولاً لأن الجداول الأخرى تعتمد عليها.

-- Institution Types
INSERT INTO security.institution_types (code, name_ar, name_en) VALUES
  ('UNIVERSITY', 'جامعة', 'University'),
  ('HOSPITAL', 'مستشفى', 'Hospital'),
  ('RESEARCH_CENTER', 'مركز أبحاث', 'Research Center');

-- Institution
INSERT INTO security.institutions (institution_type_id, code, name_ar, name_en, email, phone, address, is_active)
SELECT id, 'KSU', 'جامعة الملك سعود', 'King Saud University', 'info@ksu.edu.sa', '+966114670000', 'الرياض، المملكة العربية السعودية', true
FROM security.institution_types WHERE code = 'UNIVERSITY';

-- Departments
INSERT INTO security.departments (institution_id, code, name_ar, name_en)
SELECT i.id, 'MED', 'كلية الطب', 'College of Medicine'
FROM security.institutions i WHERE i.code = 'KSU'
UNION ALL
SELECT i.id, 'PHARM', 'كلية الصيدلة', 'College of Pharmacy'
FROM security.institutions i WHERE i.code = 'KSU'
UNION ALL
SELECT i.id, 'SCI', 'كلية العلوم', 'College of Science'
FROM security.institutions i WHERE i.code = 'KSU'
UNION ALL
SELECT i.id, 'DENT', 'كلية طب الأسنان', 'College of Dentistry'
FROM security.institutions i WHERE i.code = 'KSU';

-- Application Statuses
INSERT INTO reference.application_statuses (status_code, status_name_ar, status_name_en, display_order, is_terminal) VALUES
  ('DRAFT', 'مسودة', 'Draft', 1, false),
  ('SUBMITTED', 'مقدمة', 'Submitted', 2, false),
  ('INITIAL_REVIEW', 'مراجعة أولية', 'Initial Review', 3, false),
  ('SCIENTIFIC_REVIEW', 'مراجعة علمية', 'Scientific Review', 4, false),
  ('ETHICAL_REVIEW', 'مراجعة أخلاقية', 'Ethical Review', 5, false),
  ('COMMITTEE_REVIEW', 'مراجعة اللجنة', 'Committee Review', 6, false),
  ('APPROVED', 'موافقة', 'Approved', 7, true),
  ('REJECTED', 'مرفوض', 'Rejected', 8, true),
  ('RETURNED', 'معاد', 'Returned for Revision', 9, false),
  ('WITHDRAWN', 'مسحوب', 'Withdrawn', 10, true),
  ('CLOSED', 'مغلق', 'Closed', 11, true);

-- Risk Levels
INSERT INTO reference.risk_levels (risk_code, risk_name, severity_score) VALUES
  ('LOW', 'منخفض', 1),
  ('MEDIUM', 'متوسط', 2),
  ('HIGH', 'عالٍ', 3);

-- Priority Levels
INSERT INTO reference.priority_levels (priority_code, priority_name, priority_order) VALUES
  ('LOW', 'منخفض', 1),
  ('NORMAL', 'عادي', 2),
  ('HIGH', 'عالٍ', 3),
  ('URGENT', 'عاجل', 4);

-- Vote Types
INSERT INTO reference.vote_types (vote_code, vote_name, display_order) VALUES
  ('APPROVE', 'موافقة', 1),
  ('REJECT', 'رفض', 2),
  ('ABSTAIN', 'امتناع', 3),
  ('CONDITIONAL', 'موافقة مشروطة', 4);

-- Workflow Statuses
INSERT INTO reference.workflow_statuses (status_code, status_name) VALUES
  ('ACTIVE', 'نشط'),
  ('COMPLETED', 'مكتمل'),
  ('SUSPENDED', 'معلق');

-- Review Statuses
INSERT INTO reference.review_statuses (status_code, status_name) VALUES
  ('ASSIGNED', 'معين'),
  ('IN_PROGRESS', 'قيد المراجعة'),
  ('COMPLETED', 'مكتمل'),
  ('OVERDUE', 'متأخر');

-- Document Statuses
INSERT INTO reference.document_statuses (status_code, status_name) VALUES
  ('PENDING', 'قيد الانتظار'),
  ('APPROVED', 'معتمد'),
  ('REJECTED', 'مرفوض'),
  ('REVISION_REQUIRED', 'يحتاج مراجعة');

-- Lookup Categories for Research Categories
INSERT INTO reference.lookup_categories (category_code, category_name_ar, category_name_en) VALUES
  ('RESEARCH_TYPE', 'نوع البحث', 'Research Type'),
  ('RESEARCH_CATEGORY', 'تصنيف البحث', 'Research Category'),
  ('STUDY_DESIGN', 'تصميم الدراسة', 'Study Design');

INSERT INTO reference.lookup_values (category_id, value_code, value_name_ar, value_name_en, display_order) VALUES
  ((SELECT id FROM reference.lookup_categories WHERE category_code = 'RESEARCH_TYPE'), 'OBSERVATIONAL', 'دراسة رصدية', 'Observational Study', 1),
  ((SELECT id FROM reference.lookup_categories WHERE category_code = 'RESEARCH_TYPE'), 'INTERVENTIONAL', 'دراسة تداخلية', 'Interventional Study', 2),
  ((SELECT id FROM reference.lookup_categories WHERE category_code = 'RESEARCH_TYPE'), 'EXPERIMENTAL', 'دراسة تجريبية', 'Experimental Study', 3),
  ((SELECT id FROM reference.lookup_categories WHERE category_code = 'RESEARCH_CATEGORY'), 'CLINICAL_TRIAL', 'تجربة سريرية', 'Clinical Trial', 1),
  ((SELECT id FROM reference.lookup_categories WHERE category_code = 'RESEARCH_CATEGORY'), 'GENETIC', 'دراسة وراثية', 'Genetic Study', 2),
  ((SELECT id FROM reference.lookup_categories WHERE category_code = 'RESEARCH_CATEGORY'), 'SOCIAL', 'دراسة اجتماعية', 'Social Study', 3),
  ((SELECT id FROM reference.lookup_categories WHERE category_code = 'RESEARCH_CATEGORY'), 'EPIDEMIOLOGICAL', 'دراسة وبائية', 'Epidemiological Study', 4),
  ((SELECT id FROM reference.lookup_categories WHERE category_code = 'STUDY_DESIGN'), 'CROSS_SECTIONAL', 'مقطعية', 'Cross-Sectional', 1),
  ((SELECT id FROM reference.lookup_categories WHERE category_code = 'STUDY_DESIGN'), 'COHORT', 'طولية', 'Cohort', 2),
  ((SELECT id FROM reference.lookup_categories WHERE category_code = 'STUDY_DESIGN'), 'CASE_CONTROL', 'شواهد', 'Case-Control', 3),
  ((SELECT id FROM reference.lookup_categories WHERE category_code = 'STUDY_DESIGN'), 'RCT', 'تجربة عشوائية', 'Randomized Controlled Trial', 4);

-- Committee Decision Types
INSERT INTO reference.committee_decision_types (decision_code, decision_name) VALUES
  ('APPROVED', 'موافقة'),
  ('REJECTED', 'رفض'),
  ('CONDITIONAL', 'موافقة مشروطة'),
  ('DEFERRED', 'تأجيل'),
  ('MODIFICATIONS_REQUIRED', 'يحتاج تعديلات');
